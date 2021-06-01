"""Views to receive inbound notifications from WebEx Teams, parse them, and enqueue worker actions."""

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
from nautobot_chatops.dispatchers.webex_teams import WebExTeamsDispatcher
from nautobot_chatops.utils import check_and_enqueue_command

logger = logging.getLogger(__name__)

TOKEN = settings.PLUGINS_CONFIG["nautobot_chatops"]["webex_teams_token"]

try:
    API = WebexTeamsAPI(access_token=TOKEN)
    BOT_ID = API.people.me().id
except (AccessTokenError, ApiError):
    logger.warning(
        "Missing or invalid WEBEX_TEAMS_TOKEN setting. "
        "This may be ignored if you are not running Nautobot as a WebEx Teams chatbot."
    )
    API = None
    BOT_ID = None

# TODO: the plugin should verify that the webhooks are correctly set up, or else make API calls to create them


def generate_signature(request):
    """Calculate the expected signature of a given request."""
    signing_secret = settings.PLUGINS_CONFIG["nautobot_chatops"].get("webex_teams_signing_secret").encode("utf-8")
    return hmac.new(signing_secret, request.body, digestmod=hashlib.sha1).hexdigest()


def verify_signature(request):
    """Verify that a given request was legitimately signed by WebEx Teams.

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
class WebExTeamsView(View):
    """Handle all supported inbound notifications from WebEx Teams."""

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

        # In WebEx Teams, the webhook doesn't contain the user/channel/org names. We have to call back for them.
        # For whatever reason, API.organizations.get() is only permitted by admin users, which the bot is not.
        # context["org_name"] = API.organizations.get(context["org_id"]).displayName
        context["channel_name"] = API.rooms.get(context["channel_id"]).title
        context["user_name"] = API.people.get(context["user_id"]).displayName

        if body.get("resource") == "messages":
            # In WebEx Teams, the webhook notification doesn't contain the message text. We have to call back for it.
            message = API.messages.get(context["message_id"])
            command = message.text.strip()
            # Check for a mention of the bot in the HTML (i.e., if this is not a direct message), and remove it if so.
            if message.html:
                bot_mention = re.search("<spark-mention.*?>(.+?)</spark-mention>", message.html)
                if bot_mention:
                    command = re.sub(bot_mention.group(1), "", command).strip()
            command, subcommand, params = parse_command_string(command)
        elif body.get("resource") == "attachmentActions":
            # In WebEx Teams, the webhook notification doesn't contain the action details. We have to call back for it.
            action = API.attachment_actions.get(body.get("data", {}).get("id"))
            if settings.PLUGINS_CONFIG["nautobot_chatops"].get("delete_input_on_submission"):
                # Delete the card that this action was triggered from
                WebExTeamsDispatcher(context).delete_message(context["message_id"])
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
            WebExTeamsDispatcher(context).send_markdown(commands_help())
            return HttpResponse(status=200)

        return check_and_enqueue_command(registry, command, subcommand, params, context, WebExTeamsDispatcher)
