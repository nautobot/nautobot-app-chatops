"""Views to receive inbound notifications from Microsoft Teams, parse them, and enqueue worker actions."""

import json
import re

import requests
import jwt

from django.conf import settings
from django.http import HttpResponse
from django.utils.decorators import method_decorator
from django.views import View
from django.views.decorators.csrf import csrf_exempt

from nautobot_chatops.workers import get_commands_registry, commands_help, parse_command_string
from nautobot_chatops.dispatchers.ms_teams import MSTeamsDispatcher
from nautobot_chatops.utils import check_and_enqueue_command


APP_ID = settings.PLUGINS_CONFIG["nautobot_chatops"]["microsoft_app_id"]

BOT_CONNECTOR_METADATA_URI = "https://login.botframework.com/v1/.well-known/openidconfiguration"
BOT_EMULATOR_METADATA_URI = "https://login.microsoftonline.com/botframework.com/v2.0/.well-known/openid-configuration"


def get_bot_signing_keys(metadata_uri=BOT_CONNECTOR_METADATA_URI):
    """Get the keys used by the Bot Connector service to sign requests and the associated algorithms."""
    response = requests.get(metadata_uri)
    id_token_signing_alg_values_supported = response.json()["id_token_signing_alg_values_supported"]
    jwks_uri = response.json()["jwks_uri"]

    response = requests.get(jwks_uri)
    # https://renzo.lucioni.xyz/verifying-jwts-with-jwks-and-pyjwt/
    public_keys = {}
    for jwk in response.json()["keys"]:
        kid = jwk["kid"]
        public_keys[kid] = jwt.algorithms.RSAAlgorithm.from_jwk(json.dumps(jwk))

    # TODO: we're supposed to be able to cache this for up to 5 days rather than retrieving it every time
    return public_keys, id_token_signing_alg_values_supported


def verify_jwt_token(request_headers, request_json):
    """Verify that an inbound HTTP request is appropriately signed with a valid JWT token.

    References:
      - https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-authentication?
        view=azure-bot-service-4.0#step-4-verify-the-jwt-token
      - https://github.com/microsoft/BotFramework-Emulator/pull/324

    Returns:
      tuple: (valid, reason)
    """
    # 1. The token was sent in the HTTP Authorization header with Bearer scheme
    if "authorization" not in request_headers:
        return False, "no Authorization header present"
    auth_type, auth_token = request_headers.get("authorization").split(" ")
    if auth_type != "Bearer":
        return False, "incorrect authorization scheme"

    # Which key does the auth_token say we should use?
    kid = jwt.get_unverified_header(auth_token)["kid"]

    real_connector = True
    public_keys, algorithms = get_bot_signing_keys(BOT_CONNECTOR_METADATA_URI)
    if kid not in public_keys:
        # Maybe it was signed by the emulator instead?
        public_keys, algorithms = get_bot_signing_keys(BOT_EMULATOR_METADATA_URI)
        real_connector = False
        if kid not in public_keys:
            return False, "unknown/unrecognized kid {kid}"

    try:
        # 2. The token is valid JSON that conforms to the JWT standard.
        token_payload = jwt.decode(
            auth_token,
            # 6. The token has a valid cryptographic signature, with a key listed in the OpenID keys document,
            #    using a signing algorithm specified in the Open ID Metadata
            key=public_keys[kid],
            algorithms=algorithms,
            # 3. The token contains an "issuer" claim with value of https://api.botframework.com (for the real thing)
            # or https://login.microsoftonline.com/d6d49420-f39b-4df7-a1dc-d59a935871db/v2.0 (for the emulator)
            issuer=(
                "https://api.botframework.com"
                if real_connector
                else "https://login.microsoftonline.com/d6d49420-f39b-4df7-a1dc-d59a935871db/v2.0"
            ),
            # 4. The token contains an "audience" claim with a value equal to the bot's Microsoft App ID.
            audience=APP_ID,
            # 5. The token is within its validity period plus or minus 5 minutes.
            leeway=(5 * 60),
            options={
                # I think these default to True but better safe than sorry!
                "verify_iss": True,
                "verify_aud": True,
                "verify_nbf": True,
                "verify_exp": True,
                "verify_signature": True,
            },
        )
    except jwt.exceptions.InvalidTokenError as exc:
        return False, str(exc)

    # 7. The token contains a "serviceUrl" claim with value that matches the incoming request
    # In practice I see this is (sometimes?) labeled as "serviceurl"
    service_url = token_payload.get("serviceUrl", token_payload.get("serviceurl"))
    # The bot emulator doesn't seem to provide this claim, so only test if working with a real connector
    if real_connector and (not service_url or service_url != request_json.get("serviceUrl")):
        return False, f"Missing or incorrect serviceUrl claim ({service_url}) in token"

    return True, None


@method_decorator(csrf_exempt, name="dispatch")
class MSTeamsMessagesView(View):
    """Handle notifications from a Microsoft Teams bot."""

    http_method_names = ["post"]

    # pylint: disable=too-many-locals,too-many-branches,too-many-statements
    def post(self, request, *args, **kwargs):
        """Process an inbound HTTP POST request."""
        body = json.loads(request.body)

        valid, reason = verify_jwt_token(request.headers, body)
        if not valid:
            return HttpResponse(status=403, reason=reason)

        if body["type"] not in ["message", "invoke"]:
            return HttpResponse(status=200, reason=f"No support for {body['type']} notifications")

        context = {
            "request_scheme": request.scheme,
            "request_host": request.get_host(),
            # We don't get a team_id or a channel_id in direct message conversations
            "channel_id": body["channelData"].get("channel", {}).get("id"),
            "org_id": body["channelData"].get("team", {}).get("id"),
            # Note that the default channel in a team has channel_id == org_id
            "user_id": body["from"]["id"],
            "user_name": body["from"]["name"],
            "user_role": body["from"].get("role"),
            "conversation_id": body["conversation"]["id"],
            "conversation_name": body["conversation"].get("name"),
            "bot_id": body["recipient"]["id"],
            "bot_name": body["recipient"]["name"],
            "bot_role": body["recipient"].get("role"),
            "message_id": body["id"],
            "service_url": body["serviceUrl"],
            "tenant_id": body["channelData"]["tenant"]["id"],
            "is_group": body["conversation"].get("isGroup", False),
        }

        if context["org_id"]:
            # Get the organization name as well
            response = requests.get(
                f"{context['service_url']}/v3/teams/{context['org_id']}",
                headers={"Authorization": f"Bearer {MSTeamsDispatcher.get_token()}"},
            )
            response.raise_for_status()
            context["org_name"] = response.json()["name"]
        else:
            # Direct message - use the user as the "organization" - better than nothing
            context["org_id"] = context["user_id"]
            context["org_name"] = f"direct message with {context['user_name']}"

        if context["channel_id"]:
            # Get the channel name as well
            response = requests.get(
                f"{context['service_url']}/v3/teams/{context['org_id']}/conversations",
                headers={"Authorization": f"Bearer {MSTeamsDispatcher.get_token()}"},
            )
            response.raise_for_status()
            for conversation in response.json()["conversations"]:
                if conversation["id"] == context["channel_id"]:
                    # The "General" channel has a null name
                    context["channel_name"] = conversation["name"] or "General"
                    break
        else:
            # Direct message - use the user as the "channel" - better than nothing
            context["channel_id"] = context["user_id"]
            context["channel_name"] = f"direct message with {context['user_name']}"

        if "text" in body:
            # A command typed directly by the user
            command = body["text"]

            # If we get @ed in a channel, the message will be "<at>NAutobot</at> command subcommand"
            command = re.sub(r"<at>.*</at>", "", command)

            command, subcommand, params = parse_command_string(command)
        elif "value" in body:
            if body["value"].get("type") == "fileUpload":
                # User either granted or denied permission to upload a file
                if body["value"]["action"] == "accept":
                    command = body["value"]["context"]["action_id"]
                    context["uploadInfo"] = body["value"]["uploadInfo"]
                else:
                    command = "cancel"

                command, subcommand, params = parse_command_string(command)
            else:
                # Content that we got from an interactive card
                command, subcommand, params = parse_command_string(body["value"]["action"])
                i = 0
                while True:
                    key = f"param_{i}"
                    if key not in body["value"]:
                        break
                    params.append(body["value"][key])
                    i += 1

            if settings.PLUGINS_CONFIG["nautobot_chatops"].get("delete_input_on_submission"):
                # Delete the card
                MSTeamsDispatcher(context).delete_message(body["replyToId"])
            if command.startswith("cancel"):
                # Nothing more to do
                return HttpResponse(status=200)
        else:
            command = ""
            subcommand = ""
            params = []

        registry = get_commands_registry()

        if command not in registry:
            MSTeamsDispatcher(context).send_markdown(commands_help())
            return HttpResponse(status=200)

        # Send "typing" indicator to the client so they know we received the request
        MSTeamsDispatcher(context).send_busy_indicator()

        return check_and_enqueue_command(registry, command, subcommand, params, context, MSTeamsDispatcher)
