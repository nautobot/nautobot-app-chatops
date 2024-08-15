"""Utility functions for API view implementations."""

import logging
import sys
from datetime import datetime, timezone

from asgiref.sync import sync_to_async
from django.conf import settings
from django.db.models import Q
from django.http import HttpResponse, JsonResponse
from nautobot.core.celery import nautobot_task
from nautobot.extras.context_managers import web_request_context

from nautobot_chatops.choices import AccessGrantTypeChoices, CommandStatusChoices
from nautobot_chatops.metrics import request_command_cntr
from nautobot_chatops.models import AccessGrant, CommandLog

logger = logging.getLogger(__name__)


def get_app_config_part(prefix: str) -> dict:
    """Get part of the app config.

    Args:
        prefix (str): Prefix of the config to get.

    Returns:
        dict: Config part.
    """
    config: dict = settings.PLUGINS_CONFIG["nautobot_chatops"]

    prefix_ = f"{prefix}_"
    result = {key.replace(prefix_, ""): value for key, value in config.items() if key.startswith(prefix_)}

    result["enabled"] = config.get(f"enable_{prefix}", False)

    return result


@nautobot_task
def celery_worker_task(command, subcommand, params, dispatcher_module, dispatcher_name, context):
    """Task executed by Celery worker.

    Celery cannot serialize/deserialize objects, instead of passing the
    function, registry or dispatcher_class, we will have to look them up.
    """
    # import done here instead of up top to prevent circular imports.
    # Disabling cyclic-import as this does not affect the worker.
    # pylint: disable=import-outside-toplevel,cyclic-import
    from nautobot_chatops.workers import get_commands_registry

    # Looking up the function from the registry using the command.
    registry = get_commands_registry()
    function = registry[command]["function"]
    # Get dispatcher class from module, since the module is already loaded, we can use
    # sys.modules to map the dispatcher module string to the module. Then pull the class
    # using getattr.
    dispatcher_class = getattr(sys.modules[dispatcher_module], dispatcher_name)

    return function(
        subcommand,
        params=params,
        dispatcher_class=dispatcher_class,
        context=context,
    )


def enqueue_task(*, command, subcommand, params, dispatcher_class, context, **kwargs):
    """Enqueue task with Celery worker."""
    return celery_worker_task.delay(
        command,
        subcommand,
        params=params,
        dispatcher_module=dispatcher_class.__module__,
        dispatcher_name=dispatcher_class.__name__,
        context=context,
    )


def create_command_log(dispatcher, registry, command, subcommand, params=()):
    """Helper function to instantiate a new CommandLog based on the given information.

    Args:
        dispatcher (BaseDispatcher): Dispatcher subclass instance.
        registry (dict): See nautobot_chatops.workers.get_commands_registry().
        command (str): Top-level chatbot command -- *must* be present in the provided registry
        subcommand (str): Chatbot subcommand
        params (list): Any parameters passed to the command/subcommand

    Returns:
        CommandLog
    """
    if subcommand not in registry[command]["subcommands"]:
        # Valid command, invalid subcommand - e.g. "/clear meaningless-subcommand" - discard the subcommand
        subcommand = ""

    param_names = registry[command]["subcommands"].get(subcommand, {}).get("params", [])

    # The user might have specified more parameters than the command actually pays attention to,
    # e.g. "/nautobot get-circuit-providers meaningless-arg1 meaningless-arg2"
    # Only log the params that actually have meaning. Fortunately, zip() does this for us.
    params_list = list(zip(param_names, params))
    return CommandLog(
        user_name=dispatcher.context.get("user_name", "UNKNOWN"),
        user_id=dispatcher.context.get("user_id", "UNKNOWN"),
        platform=dispatcher.platform_name,
        platform_color=dispatcher.platform_color,
        command=command,
        subcommand=subcommand,
        start_time=datetime.now(timezone.utc),
        params=params_list,
        nautobot_user=dispatcher.user,
    )


@sync_to_async
def socket_check_and_enqueue_command(*args, **kwargs):
    """Calls check_and_enqueue_command() when in Socket mode."""
    return check_and_enqueue_command(*args, **kwargs)


def check_and_enqueue_command(registry, command, subcommand, params, context, dispatcher_class):  # noqa: PLR0915 pylint:disable=too-many-statements
    """Check whether the given command is permitted by any access grants, and enqueue it if permitted.

    For a command/subcommand to be permitted, we must have:

    - access grants for each of the AccessGrantTypeChoices (organization, channel, user)
    - that match either this command + subcommand exactly, or this command + "*" subcommand, or "*" command
    - and permit either this (organization, channel, user) exactly, or have a "*" value

    Args:
        registry (dict): See nautobot_chatops.workers.get_commands_registry().
        command (str): Top-level chatbot command
        subcommand (str): Chatbot subcommand
        params (list): Any parameters of the command/subcommand
        context (dict): Invocation context of the command
        dispatcher_class (class): Dispatcher concrete subclass

    Returns:
      HttpResponse
    """
    # Add to the context the command and subcommand issued to make available downstream
    context.update({"command": command, "subcommand": subcommand})
    dispatcher = dispatcher_class(context)

    # Mattermost requires at minimum an empty json response.
    response = HttpResponse()
    if dispatcher.platform_slug == "mattermost":
        data = {}
        response = JsonResponse(data)

    if command not in registry or "function" not in registry[command] or not callable(registry[command]["function"]):
        logger.error("Invalid/unknown command '%s'. Check registry:\n%s", command, registry)
        dispatcher.send_error(f"Something has gone wrong; I don't know how to handle command '{command}'.")
        return response

    command_log = create_command_log(dispatcher, registry, command, subcommand, params)

    if subcommand == "":
        # Command help - permit if any form of access to this command or any of its subcommands is permitted
        access_grants = AccessGrant.objects.filter(Q(command="*") | Q(command=command))
    else:
        # Actual subcommand  - permit only if this particular subcommand (or all commands/subcommands) are permitted
        access_grants = AccessGrant.objects.filter(
            Q(command="*") | Q(command=command, subcommand="*") | Q(command=command, subcommand=subcommand),
        )

    org_grants = access_grants.filter(grant_type=AccessGrantTypeChoices.TYPE_ORGANIZATION)
    if "org_id" not in context or not org_grants.filter(Q(value="*") | Q(value=context["org_id"])):
        label = context.get("org_id", "unspecified")
        if "org_name" in context:
            label += f" ({context['org_name']})"
        logger.warning(
            "Blocked %s %s: organization %s is not granted access",
            command,
            subcommand,
            label,
        )
        dispatcher.send_error(
            f"Access to this bot and/or command is not permitted in organization {label}, "
            "ask your Nautobot administrator to define an appropriate Access Grant"
        )
        request_command_cntr.labels(
            dispatcher.platform_slug,
            command,
            subcommand,
            CommandStatusChoices.STATUS_BLOCKED,
        ).inc()
        command_log.status = CommandStatusChoices.STATUS_BLOCKED
        command_log.details = f"Not permitted in organization {label}"
        command_log.runtime = datetime.now(timezone.utc) - command_log.start_time
        with web_request_context(dispatcher.user):
            command_log.save()
        return response

    chan_grants = access_grants.filter(grant_type=AccessGrantTypeChoices.TYPE_CHANNEL)
    if "channel_id" not in context or not chan_grants.filter(Q(value="*") | Q(value=context["channel_id"])):
        label = context.get("channel_id", "unspecified")
        if "channel_name" in context:
            label += f" ({context['channel_name']})"
        logger.warning(
            "Blocked %s %s: channel %s is not granted access",
            command,
            subcommand,
            label,
        )
        dispatcher.send_error(
            f"Access to this bot and/or command is not permitted in channel {label}, "
            "ask your Nautobot administrator to define an appropriate Access Grant"
        )
        request_command_cntr.labels(
            dispatcher.platform_slug,
            command,
            subcommand,
            CommandStatusChoices.STATUS_BLOCKED,
        ).inc()
        command_log.status = CommandStatusChoices.STATUS_BLOCKED
        command_log.details = f"Not permitted in channel {label}"
        command_log.runtime = datetime.now(timezone.utc) - command_log.start_time
        with web_request_context(dispatcher.user):
            command_log.save()
        return response

    user_grants = access_grants.filter(grant_type=AccessGrantTypeChoices.TYPE_USER)
    if "user_id" not in context or not user_grants.filter(Q(value="*") | Q(value=context["user_id"])):
        label = context.get("user_id", "unspecified")
        if "user_name" in context:
            label += f" ({context['user_name']})"
        logger.warning("Blocked %s %s: user %s is not granted access", command, subcommand, label)
        dispatcher.send_error(
            f"Access to this bot and/or command is not permitted by user {label}, "
            "ask your Nautobot administrator to define an appropriate Access Grant"
        )
        request_command_cntr.labels(
            dispatcher.platform_slug,
            command,
            subcommand,
            CommandStatusChoices.STATUS_BLOCKED,
        ).inc()
        command_log.status = CommandStatusChoices.STATUS_BLOCKED
        command_log.details = f"Not permitted by user {label}"
        command_log.runtime = datetime.now(timezone.utc) - command_log.start_time
        with web_request_context(dispatcher.user):
            command_log.save()
        return response

    # If we made it here, we're permitted. Enqueue it for the worker
    enqueue_task(
        command=command,
        subcommand=subcommand,
        params=params,
        dispatcher_class=dispatcher_class,
        context=context,
        function=registry[command]["function"],
    )
    return response
