"""Views to receive inbound notifications from Slack, parse them, and enqueue worker actions."""

import hashlib
import hmac
import json
import logging
import shlex

from django.conf import settings
from django.http import HttpResponse
from django.utils.decorators import method_decorator
from django.views import View
from django.views.decorators.csrf import csrf_exempt
from slack_sdk import WebClient

from nautobot_chatops.workers import get_commands_registry, commands_help, parse_command_string
from nautobot_chatops.dispatchers.slack import SlackDispatcher
from nautobot_chatops.utils import check_and_enqueue_command
from nautobot_chatops.metrics import signature_error_cntr

# pylint: disable=logging-fstring-interpolation


SLASH_PREFIX = settings.PLUGINS_CONFIG["nautobot_chatops"].get("slack_slash_command_prefix")

logger = logging.getLogger(__name__)


def generate_signature(request):
    """Calculate the expected signature of a given request."""
    version = "v0"
    # The existence of this header should already have been checked
    timestamp = request.headers.get("X-Slack-Request-Timestamp")
    body = request.body.decode("utf-8")
    base_string = f"{version}:{timestamp}:{body}".encode("utf-8")
    signing_secret = settings.PLUGINS_CONFIG["nautobot_chatops"].get("slack_signing_secret").encode("utf-8")

    computed_signature = hmac.new(signing_secret, base_string, digestmod=hashlib.sha256).hexdigest()
    return f"{version}={computed_signature}"


def verify_signature(request):
    """Verify that a given request was legitimately signed by Slack.

    https://api.slack.com/authentication/verifying-requests-from-slack

    Returns:
      tuple: (valid, reason)
    """
    expected_signature = request.headers.get("X-Slack-Signature")
    if not expected_signature:
        signature_error_cntr.labels("slack", "missing_signature").inc()
        return False, "Missing X-Slack-Signature header"
    timestamp = request.headers.get("X-Slack-Request-Timestamp")
    if not timestamp:
        signature_error_cntr.labels("slack", "missing_timestamp").inc()
        return False, "Missing X-Slack-Request-Timestamp header"

    computed_signature = generate_signature(request)

    if computed_signature != expected_signature:
        signature_error_cntr.labels("slack", "incorrect_signature").inc()
        return False, "Incorrect signature"

    return True, "Signature is valid"


@method_decorator(csrf_exempt, name="dispatch")
class SlackSlashCommandView(View):
    """Handle notifications from a Slack /command."""

    http_method_names = ["post"]

    def post(self, request, *args, **kwargs):
        """Handle an inbound HTTP POST request representing a user-issued /command."""
        valid, reason = verify_signature(request)
        if not valid:
            return HttpResponse(status=401, reason=reason)

        command = request.POST.get("command")
        if not command:
            return HttpResponse("No command specified")
        command = command.replace(SLASH_PREFIX, "")
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
        }
        try:
            command, subcommand, params = parse_command_string(f"{command} {params}")
        except ValueError as err:
            logger.error("%s", err)
            # Tried sending 400 error, but the friendly message never made it to slack.
            return HttpResponse(f"'Error: {err}' encountered on command '{command} {params}'.")

        registry = get_commands_registry()

        if command not in registry:
            SlackDispatcher(context).send_markdown(commands_help(prefix=SLASH_PREFIX))
            return HttpResponse()

        # What we'd like to do here is send a "Nautobot is typing..." to the channel,
        # but unfortunately the API we're using doesn't support that (only the legacy/deprecated RTM API does).
        # SlackDispatcher(context).send_busy_indicator()

        return check_and_enqueue_command(registry, command, subcommand, params, context, SlackDispatcher)


@method_decorator(csrf_exempt, name="dispatch")
class SlackInteractionView(View):
    """Handle notifications resulting from a Slack interactive block or modal."""

    http_method_names = ["post"]

    # pylint: disable=too-many-locals,too-many-return-statements,too-many-branches,too-many-statements
    def post(self, request, *args, **kwargs):
        """Handle an inbound HTTP POST request representing a user interaction with a UI element."""
        valid, reason = verify_signature(request)
        if not valid:
            return HttpResponse(status=401, reason=reason)

        payload = json.loads(request.POST.get("payload", ""))

        context = {
            "request_scheme": request.scheme,
            "request_host": request.get_host(),
            "org_id": payload.get("team", {}).get("id"),
            "org_name": payload.get("team", {}).get("domain"),
            "channel_id": payload.get("channel", {}).get("id"),
            "channel_name": payload.get("channel", {}).get("name"),
            "user_id": payload.get("user", {}).get("id"),
            "user_name": payload.get("user", {}).get("username"),
            "response_url": payload.get("response_url"),
            "trigger_id": payload.get("trigger_id"),
        }

        # Check for channel_name if channel_id is present
        if context["channel_name"] is None and context["channel_id"] is not None:
            # Build a Slack Client Object
            slack_client = WebClient(token=settings.PLUGINS_CONFIG["nautobot_chatops"]["slack_api_token"])

            # Get the channel information from Slack API
            channel_info = slack_client.conversations_info(channel=context["channel_id"])

            # Assign the Channel name out of the conversations info end point
            context["channel_name"] = channel_info["channel"]["name"]

        if "actions" in payload and payload["actions"]:
            # Block action triggered by a non-modal interactive component
            action = payload["actions"][0]
            action_id = action.get("action_id", "")
            block_id = action.get("block_id", "")
            if action["type"] == "static_select":
                value = action.get("selected_option", {}).get("value", "")
                selected_value = f"'{value}'"
            elif action["type"] == "button":
                value = action.get("value")
                selected_value = f"'{value}'"
            else:
                logger.error(f"Unhandled action type {action['type']}")
                return HttpResponse(status=500)

            if settings.PLUGINS_CONFIG["nautobot_chatops"].get("delete_input_on_submission"):
                # Delete the interactive element since it's served its purpose
                SlackDispatcher(context).delete_message(context["response_url"])
            if action_id == "action" and selected_value == "cancel":
                # Nothing more to do
                return HttpResponse()
        elif "view" in payload and payload["view"]:
            # View submission triggered from a modal dialog
            logger.info("Submission triggered from a modal dialog")
            logger.info(json.dumps(payload, indent=2))
            values = payload["view"].get("state", {}).get("values", {})

            # Handling for multiple fields. This will be used when the multi_input_dialog() method of the Slack
            # Dispatcher class is utilized.
            if len(values) > 1:
                selected_value = ""
                callback_id = payload["view"].get("callback_id")
                # sometimes in the case of back-to-back dialogs there will be
                # parameters included in the callback_id.  Below parses those
                # out and adds them to selected_value.
                try:
                    cmds = shlex.split(callback_id)
                except ValueError as err:
                    logger.error("%s", err)
                    return HttpResponse(f"Error: {err} encountered when processing {callback_id}")
                for i, cmd in enumerate(cmds):
                    if i == 2:
                        selected_value += f"'{cmd}'"
                    elif i > 2:
                        selected_value += f" '{cmd}'"
                action_id = f"{cmds[0]} {cmds[1]}"

                sorted_params = sorted(values.keys())
                for blk_id in sorted_params:
                    for act_id in values[blk_id].values():
                        if act_id["type"] == "static_select":
                            value = act_id["selected_option"]["value"]
                            selected_value += f" '{value}'"
                        elif act_id["type"] == "plain_text_input":
                            value = act_id["value"]
                            selected_value += f" '{value}'"
                        else:
                            logger.error(f"Unhandled dialog type {act_id['type']}")
                            return HttpResponse(status=500)
            # Original un-modified single-field handling below
            else:
                block_id = sorted(values.keys())[0]
                action_id = sorted(values[block_id].keys())[0]
                action = values[block_id][action_id]
                if action["type"] == "plain_text_input":
                    value = action["value"]
                    selected_value = f"'{value}'"
                else:
                    logger.error(f"Unhandled action type {action['type']}")
                    return HttpResponse(status=500)

            # Modal view submissions don't generally contain a channel ID, but we hide one for our convenience:
            if "private_metadata" in payload["view"]:
                private_metadata = json.loads(payload["view"]["private_metadata"])
                if "channel_id" in private_metadata:
                    context["channel_id"] = private_metadata["channel_id"]
        else:
            return HttpResponse("I didn't understand that notification.")

        logger.info(f"action_id: {action_id}, selected_value: {selected_value}")
        try:
            command, subcommand, params = parse_command_string(f"{action_id} {selected_value}")
        except ValueError as err:
            logger.error("%s", err)
            # Tried sending 400 error, but the friendly message never made it to slack.
            return HttpResponse(f"'Error: {err}' encountered on command '{action_id} {selected_value}'.")
        logger.info(f"command: {command}, subcommand: {subcommand}, params: {params}")

        registry = get_commands_registry()

        if command not in registry:
            SlackDispatcher(context).send_markdown(commands_help(prefix=SLASH_PREFIX))
            return HttpResponse()

        # What we'd like to do here is send a "Nautobot is typing..." to the channel,
        # but unfortunately the API we're using doesn't support that (only the legacy/deprecated RTM API does).
        # SlackDispatcher(context).send_busy_indicator()

        return check_and_enqueue_command(registry, command, subcommand, params, context, SlackDispatcher)
