"""Views to receive inbound notifications from Mattermost, parse them, and enqueue worker actions."""

import json
import logging
import shlex

from django.conf import settings
from django.http import HttpResponse
from django.utils.decorators import method_decorator
from django.views import View
from django.views.decorators.csrf import csrf_exempt

from nautobot_chatops.workers import get_commands_registry, commands_help, parse_command_string
from nautobot_chatops.dispatchers.mattermost import MattermostDispatcher, Driver
from nautobot_chatops.utils import check_and_enqueue_command
from nautobot_chatops.metrics import signature_error_cntr
from nautobot_chatops.models import CommandToken
from nautobot_chatops.choices import CommandTokenPlatformChoices

# pylint: disable=logging-fstring-interpolation

logger = logging.getLogger(__name__)


def verify_signature(request):
    """Verify that a given request was legitimately signed by Mattermost.

    https://developers.mattermost.com/integrate/slash-commands/

    Returns:
      tuple: (valid, reason)
    """
    if request.headers.get("Authorization"):
        expected_signature = request.headers.get("Authorization")
    else:
        # For some reason Integration Messages from Mattermost do not show up in POST.items()
        # in these cases, we have to load the request.body
        try:
            data = json.loads(request.body)
        except ValueError as err:
            logger.info("No request body to decode, setting data to empty dict. Error: %s", err)
            data = {}
        if request.POST.items():
            data.update(request.POST)
        # For Interactive Messages, the token will be passed in the context.
        if data.get("context"):
            action = data.get("context")
            expected_signature = action.get("token")
        # For Interactive Dialogs, the token will be passed in the state.
        elif data.get("state"):
            expected_signature = data.get("state")

        else:
            signature_error_cntr.labels("mattermost", "missing_signature").inc()
            return False, "Missing Command Token in Body or Header"

    if not expected_signature:
        signature_error_cntr.labels("mattermost", "missing_signature").inc()
        return False, "Missing Command Token"

    command_tokens = CommandToken.objects.filter(platform=CommandTokenPlatformChoices.MATTERMOST)

    if not command_tokens.filter(token=expected_signature.split("Token ")[1]):
        signature_error_cntr.labels("mattermost", "incorrect_signature").inc()
        return False, "Incorrect signature"

    return True, "Signature is valid"


@method_decorator(csrf_exempt, name="dispatch")
class MattermostSlashCommandView(View):
    """Handle notifications from a Mattermost /command."""

    http_method_names = ["post"]

    def post(self, request, *args, **kwargs):
        """Handle an inbound HTTP POST request representing a user-issued /command."""
        valid, reason = verify_signature(request)
        if not valid:
            return HttpResponse(status=401, reason=reason)

        command = request.POST.get("command")
        if not command:
            return HttpResponse("No command specified")
        command = command.replace("/", "")
        params = request.POST.get("text", "")
        context = {
            "request_scheme": request.scheme,
            "request_host": request.get_host(),
            "org_id": request.POST.get("team_id"),
            "org_name": request.POST.get("team_domain"),
            "channel_id": request.POST.get("channel_id"),
            "channel_name": request.POST.get("channel_name"),
            "user_id": request.POST.get("user_id"),
            "user_name": request.POST.get("user_name"),
            "response_url": request.POST.get("response_url"),
            "trigger_id": request.POST.get("trigger_id"),
            "integration_url": request.build_absolute_uri("/api/plugins/chatops/mattermost/interaction/"),
            "token": request.headers.get("Authorization"),
        }

        try:
            command, subcommand, params = parse_command_string(f"{command} {params}")
        except ValueError as err:
            logger.error("%s", err)
            return HttpResponse(status=400, reason=f"'Error: {err}' encountered on '{command} {params}")

        registry = get_commands_registry()

        if command not in registry:
            MattermostDispatcher(context).send_markdown(commands_help(prefix="/"))
            return HttpResponse()

        MattermostDispatcher(context).send_busy_indicator()

        return check_and_enqueue_command(registry, command, subcommand, params, context, MattermostDispatcher)


@method_decorator(csrf_exempt, name="dispatch")
class MattermostInteractionView(View):
    """Handle notifications resulting from a Mattermost interactive block."""

    http_method_names = ["post"]

    # pylint: disable=too-many-locals,too-many-return-statements,too-many-branches,too-many-statements
    def post(self, request, *args, **kwargs):
        """Handle an inbound HTTP POST request representing a user interaction with a UI element."""
        valid, reason = verify_signature(request)
        if not valid:
            return HttpResponse(status=401, reason=reason)

        # For some reason Integration Messages from Mattermost do not show up in POST.items()
        # in these cases, we have to load the request.body
        try:
            data = json.loads(request.body)
        except ValueError as err:
            logger.info("No request body to decode, setting data to empty dict. Error: %s", err)
            data = {}
        if request.POST.dict():
            data.update(request.POST)

        context = {
            "org_id": data.get("team_id"),
            "org_name": data.get("team_domain"),
            "channel_id": data.get("channel_id"),
            "channel_name": data.get("channel_name"),
            "user_id": data.get("user_id"),
            "user_name": data.get("user_name"),
            "response_url": data.get("response_url"),
            "trigger_id": data.get("trigger_id"),
            "post_id": data.get("post_id"),
            "request_scheme": request.get_host(),
            "request_host": request.get_host(),
            "integration_url": request.build_absolute_uri("/api/plugins/chatops/mattermost/interaction/"),
        }

        # Check for channel_name if channel_id is present
        mm_url = settings.PLUGINS_CONFIG["nautobot_chatops"]["mattermost_url"]
        token = settings.PLUGINS_CONFIG["nautobot_chatops"]["mattermost_api_token"]
        if context["channel_name"] is None and context["channel_id"] is not None:
            # Build a Mattermost Client Object
            mm_client = Driver(
                {
                    "url": mm_url,
                    "token": token,
                }
            )

            # Get the channel information from Mattermost API
            channel_info = mm_client.get(f'/channels/{context["channel_id"]}')

            # Assign the Channel name out of the conversations info end point
            context["channel_name"] = channel_info["name"]

        if context["user_name"] is None and context["user_id"] is not None:
            # Build a Mattermost Client Object
            mm_client = Driver(
                {
                    "url": mm_url,
                    "token": token,
                }
            )

            # Get the channel information from Mattermost API
            user_info = mm_client.get(f'/users/{context["user_id"]}')

            # Assign the Channel name out of the conversations info end point
            context["user_name"] = user_info["username"]

        # Block action triggered by a non-modal interactive component
        if data.get("context"):
            action = data.get("context")
            action_id = action.get("action_id", "")
            context["token"] = action.get("token", "")
            if action["type"] == "static_select":
                value = action.get("selected_option", "")
            elif action["type"] == "button":
                value = action.get("value")
            else:
                logger.error(f"Unhandled action type {action['type']} in Mattermost Dispatcher")
                return HttpResponse(status=500)
            selected_value = f"'{value}'"

        elif data.get("submission"):
            # View submission triggered from a modal dialog
            logger.info("Submission triggered from a modal dialog")
            values = data.get("submission")
            context["token"] = data.get("state")
            callback_id = data.get("callback_id")
            logger.debug(json.dumps(data, indent=2))

            # Handling for multiple fields. This will be used when the multi_input_dialog() method of the Mattermost
            # Dispatcher class is utilized.
            if len(values) > 1:
                selected_value = ""
                # sometimes in the case of back-to-back dialogs there will be
                # parameters included in the callback_id.  Below parses those
                # out and adds them to selected_value.
                try:
                    cmds = shlex.split(callback_id)
                except ValueError as err:
                    logger.error("Mattermost: %s", err)
                    return HttpResponse(status=400, reason=f"Error: {err} encountered when processing {callback_id}")
                for i, cmd in enumerate(cmds):
                    if i == 2:
                        selected_value += f"'{cmd}'"
                    elif i > 2:
                        selected_value += f" '{cmd}'"
                action_id = f"{cmds[0]} {cmds[1]}"

                sorted_params = sorted(values.keys())
                for blk_id in sorted_params:
                    selected_value += f" '{values[blk_id]}'"

            # Original un-modified single-field handling below
            else:
                action_id = sorted(values.keys())[0]
                selected_value = values[action_id]
        else:
            return HttpResponse(status=500, reason="I didn't understand that notification.")

        if settings.PLUGINS_CONFIG["nautobot_chatops"].get("delete_input_on_submission"):
            # Delete the interactive element since it's served its purpose
            # Does not work for Ephemeral Posts.
            if context["post_id"] is not None:
                MattermostDispatcher(context).delete_message(context["post_id"])
        if action_id == "action" and selected_value == "cancel":
            # Nothing more to do
            return HttpResponse()

        logger.info(f"action_id: {action_id}, selected_value: {selected_value}")
        try:
            command, subcommand, params = parse_command_string(f"{action_id} {selected_value}")
        except ValueError as err:
            logger.error("%s", err)
            return HttpResponse(
                status=400, reason=f"Error: {err} encountered on command '{action_id} {selected_value}'"
            )
        logger.info(f"command: {command}, subcommand: {subcommand}, params: {params}")

        registry = get_commands_registry()

        if command not in registry:
            MattermostDispatcher(context).send_markdown(commands_help())
            return HttpResponse()

        MattermostDispatcher(context).send_busy_indicator()

        return check_and_enqueue_command(registry, command, subcommand, params, context, MattermostDispatcher)
