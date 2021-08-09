"""Views to receive inbound notifications from WebEx, parse them, and enqueue worker actions."""

import hashlib
import hmac
import json
import logging
import re

from django.conf import settings
from django.http import HttpResponse
from django.utils.decorators import method_decorator
from django.views import View
from django.views.decorators.csrf import csrf_exempt

from webexteamssdk import WebexTeamsAPI
from webexteamssdk.exceptions import AccessTokenError, ApiError

from nautobot_chatops.workers import get_commands_registry, commands_help, parse_command_string
from nautobot_chatops.dispatchers.webex import WebExDispatcher
from nautobot_chatops.utils import check_and_enqueue_command

logger = logging.getLogger(__name__)

# v1.4.0 Deprecation warning
if settings.PLUGINS_CONFIG["nautobot_chatops"].get("webex_teams_token") and not settings.PLUGINS_CONFIG[
    "nautobot_chatops"
].get("webex_token"):
    TOKEN = settings.PLUGINS_CONFIG["nautobot_chatops"]["webex_teams_token"]
    logger.warning("The 'webex_teams_token' setting is deprecated, please use 'webex_token' instead")
else:
    try:
        TOKEN = settings.PLUGINS_CONFIG["nautobot_chatops"]["webex_token"]
    except KeyError as err:
        ERROR_MSG = "The 'webex_token' setting must be configured"
        logger.error(ERROR_MSG)
        raise KeyError(ERROR_MSG) from err


try:
    API = WebexTeamsAPI(access_token=TOKEN)
    BOT_ID = API.people.me().id
except (AccessTokenError, ApiError):
    logger.warning(
        "Missing or invalid WEBEX_TOKEN setting. "
        "This may be ignored if you are not running Nautobot as a WebEx chatbot."
    )
    API = None
    BOT_ID = None

# TODO: the plugin should verify that the webhooks are correctly set up, or else make API calls to create them


def generate_signature(request):
    """Calculate the expected signature of a given request."""
    # v1.4.0 Deprecation warning
    if settings.PLUGINS_CONFIG["nautobot_chatops"].get("webex_teams_token") and not settings.PLUGINS_CONFIG[
        "nautobot_chatops"
    ].get("webex_token"):
        signing_secret = settings.PLUGINS_CONFIG["nautobot_chatops"].get("webex_teams_signing_secret").encode("utf-8")
        logger.warning(
            "The 'webex_teams_signing_secret' setting is deprecated, please use 'webex_signing_secret' instead"
        )
    else:
        try:
            signing_secret = settings.PLUGINS_CONFIG["nautobot_chatops"]["webex_signing_secret"].encode("utf-8")
        except KeyError as err:
            error_msg = "The 'webex_token' setting must be configured"
            logger.error(error_msg)
            raise KeyError(error_msg) from err

    return hmac.new(signing_secret, request.body, digestmod=hashlib.sha1).hexdigest()


def verify_signature(request):
    """Verify that a given request was legitimately signed by WebEx.

    https://developer.webex.com/docs/api/guides/webhooks#handling-requests-from-webex-teams

    Returns:
      tuple: (valid, reason)
    """
    expected_signature = request.headers.get("X-Spark-Signature")
    if not expected_signature:
        return False, "Missing X-Spark-Signature header"

    computed_signature = generate_signature(request)

    if expected_signature != computed_signature:
        return False, "Incorrect signature"

    return True, "Valid signature"


@method_decorator(csrf_exempt, name="dispatch")
class WebExView(View):
    """Handle all supported inbound notifications from WebEx."""

    http_method_names = ["post"]

    # pylint: disable=too-many-locals,too-many-return-statements,too-many-branches
    def post(self, request, *args, **kwargs):
        """Process an inbound HTTP POST request."""
        if not API:
            return HttpResponse(reason="Incomplete or incorrect bot setup")

        valid, reason = verify_signature(request)
        if not valid:
            return HttpResponse(status=401, reason=reason)

        body = json.loads(request.body)

        if body.get("resource") not in ["messages", "attachmentActions"] or body.get("event") != "created":
            return HttpResponse(reason="No support for {body.get('resource')} {body.get('event')} notifications.")

        data = body.get("data", {})
        if data.get("personId") == BOT_ID:
            logger.info("Ignoring message that we are the sender of.")
            return HttpResponse(200)

        context = {
            "request_scheme": request.scheme,
            "request_host": request.get_host(),
            "org_id": body.get("orgId"),
            "channel_id": data.get("roomId"),
            "user_id": data.get("personId"),
            # In a 'attachmentActions' notification, the relevant message ID is 'messageId'.
            # In a 'messages' notification, the relevant message ID is 'id'.
            "message_id": data.get("messageId") or data.get("id"),
        }

        # In WebEx, the webhook doesn't contain the user/channel/org names. We have to call back for them.
        # For whatever reason, API.organizations.get() is only permitted by admin users, which the bot is not.
        # context["org_name"] = API.organizations.get(context["org_id"]).displayName
        context["channel_name"] = API.rooms.get(context["channel_id"]).title
        context["user_name"] = API.people.get(context["user_id"]).displayName

        if body.get("resource") == "messages":
            # In WebEx, the webhook notification doesn't contain the message text. We have to call back for it.
            message = API.messages.get(context["message_id"])
            command = message.text.strip()
            # Check for a mention of the bot in the HTML (i.e., if this is not a direct message), and remove it if so.
            if message.html:
                bot_mention = re.search("<spark-mention.*?>(.+?)</spark-mention>", message.html)
                if bot_mention:
                    command = re.sub(bot_mention.group(1), "", command).strip()
            command, subcommand, params = parse_command_string(command)
        elif body.get("resource") == "attachmentActions":
            # In WebEx, the webhook notification doesn't contain the action details. We have to call back for it.
            action = API.attachment_actions.get(body.get("data", {}).get("id"))
            if settings.PLUGINS_CONFIG["nautobot_chatops"].get("delete_input_on_submission"):
                # Delete the card that this action was triggered from
                WebExDispatcher(context).delete_message(context["message_id"])
            if action.inputs.get("action") == "cancel":
                return HttpResponse(status=200)
            command, subcommand, params = parse_command_string(action.inputs.get("action"))
            i = 0
            while True:
                key = f"param_{i}"
                if key not in action.inputs:
                    break
                params.append(action.inputs[key])
                i += 1

        registry = get_commands_registry()

        if command not in registry:
            WebExDispatcher(context).send_markdown(commands_help())
            return HttpResponse(status=200)

        return check_and_enqueue_command(registry, command, subcommand, params, context, WebExDispatcher)
