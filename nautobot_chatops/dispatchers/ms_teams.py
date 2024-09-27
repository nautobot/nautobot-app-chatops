"""Dispatcher implementation for sending content to Microsoft Teams."""

import logging
import os
from typing import Optional

import requests
from django.conf import settings
from django.contrib.auth import get_user_model
from django.core.exceptions import ObjectDoesNotExist
from nautobot.apps.config import get_app_settings_or_config

from nautobot_chatops.metrics import backend_action_sum
from nautobot_chatops.models import ChatOpsAccountLink

from .adaptive_cards import AdaptiveCardsDispatcher

logger = logging.getLogger(__name__)

# Create a metric to track time spent and requests made.
BACKEND_ACTION_LOOKUP = backend_action_sum.labels("msteams", "platform_lookup")
BACKEND_ACTION_MARKDOWN = backend_action_sum.labels("msteams", "send_markdown")
BACKEND_ACTION_BLOCKS = backend_action_sum.labels("msteams", "send_blocks")
BACKEND_ACTION_SNIPPET = backend_action_sum.labels("msteams", "send_snippet")


class MSTeamsDispatcher(AdaptiveCardsDispatcher):
    """Dispatch messages and cards to Microsoft Teams."""

    platform_name = "Microsoft Teams"
    platform_slug = "microsoft_teams"

    platform_color = "6264A7"

    def __init__(self, *args, **kwargs):
        """Init a MSTeamsDispatcher."""
        super().__init__(*args, **kwargs)

    @property
    def user(self):
        """Dispatcher property containing the Nautobot User that is linked to the Chat User."""
        if self.context.get("user_ad_id"):
            try:
                logger.debug("DEBUG: user() - Found ChatOps user - %s", self.context["user_name"])
                return ChatOpsAccountLink.objects.get(
                    platform=self.platform_slug, user_id=self.context["user_ad_id"]
                ).nautobot_user
            except ObjectDoesNotExist:
                logger.warning(
                    "Could not find User matching %s - id: %s. Add a ChatOps User to link the accounts.",
                    self.context["user_name"],
                    self.context["user_ad_id"],
                )
        user_model = get_user_model()
        user, _ = user_model.objects.get_or_create(
            username=get_app_settings_or_config("nautobot_chatops", "fallback_chatops_user")
        )
        return user

    @classmethod
    @BACKEND_ACTION_LOOKUP.time()
    def platform_lookup(cls, item_type, item_name) -> Optional[str]:
        """Call out to the chat platform to look up, e.g., a specific user ID by name.

        Args:
          item_type (str): One of "organization", "channel", "user"
          item_name (str): Uniquely identifying name of the given item.

        Returns:
          (str, None)
        """
        # TODO: chicken-and-egg problem here. We need the serviceUrl to send requests to, but the serviceUrl
        # is something we can't look up on our own - it gets sent to us when we receive a message or get added
        # to a new channel. What we need to do is cache serviceUrl globally in either of the above cases rather
        # than storing it per-instance of the MSTeamsDispatcher.
        raise NotImplementedError

    @staticmethod
    def get_token(service="botframework.com", scope="https://api.botframework.com/.default"):
        """Obtain the JWT token that's needed for the bot to publish messages back to MS Teams."""
        # TODO: for efficiency, cache the token and only refresh it when it expires
        # For now we just get a new token every time.
        response = requests.post(
            f"https://login.microsoftonline.com/{service}/oauth2/v2.0/token",
            data={
                "grant_type": "client_credentials",
                "client_id": settings.PLUGINS_CONFIG["nautobot_chatops"]["microsoft_app_id"],
                "client_secret": settings.PLUGINS_CONFIG["nautobot_chatops"]["microsoft_app_password"],
                "scope": scope,
            },
            timeout=15,
        )
        logger.debug("DEBUG: get_token() response %s", response.json())
        try:
            token = response.json()["access_token"]
        except KeyError as exc:
            logger.error(
                "get_token() response is missing access_token, which indicates an error authenticating with MS Teams."
                "Check the app_id and app_secret."
            )
            raise KeyError(
                "get_token() response is missing access_token, which indicates an error authenticating with MS Teams."
                "Check the app_id and app_secret."
            ) from exc
        return token

    @classmethod
    def lookup_user_id_by_email(cls, email) -> Optional[str]:
        """Call out to Microsoft Teams to look up a specific user ID by email.

        Args:
          email (str): Uniquely identifying email address of the user.

        Returns:
          (str, None)
        """
        service = settings.PLUGINS_CONFIG["nautobot_chatops"]["microsoft_tenant_id"]
        scope = "https://graph.microsoft.com/.default"
        try:
            # Try to use the email as the User Principal Name
            response = requests.get(
                f"https://graph.microsoft.com/v1.0/users/{email}?$select=id",
                headers={"Authorization": f"Bearer {cls.get_token(service=service, scope=scope)}"},
                timeout=15,
            )
            return response.json()["id"]
        except KeyError:
            try:
                # Fall back to filtering by email address.
                response = requests.get(
                    f"https://graph.microsoft.com/v1.0/users?$select=id&$filter=mail eq '{email}'",
                    headers={"Authorization": f"Bearer {cls.get_token(service=service, scope=scope)}"},
                    timeout=15,
                )
                return response.json()["value"][0]["id"]
            except (KeyError, IndexError):
                return None

    def _send(self, content, content_type="message"):
        """Publish content back to Microsoft Teams."""
        logger.debug("DEBUG: _send() - updating content with %s", self.context)
        content = content.copy()
        content.update(
            {
                "type": content_type,
                "from": {
                    "id": self.context["bot_id"],
                    "name": self.context["bot_name"],
                },
                "conversation": {
                    "id": self.context["conversation_id"],
                    "name": self.context["conversation_name"],
                },
                "recipient": {
                    "id": self.context["user_id"],
                    "name": self.context["user_name"],
                },
                "replyToId": self.context["message_id"],
            }
        )
        logger.debug("DEBUG: _send() - Sending response back to MSTeams")
        logger.debug("DEBUG: _send() - Sending content with %s", content)
        logger.debug(
            "DEBUG: _send() - Sending to URL %s/v3/conversations/%s/activities",
            self.context["service_url"],
            self.context["conversation_id"],
        )
        response = requests.post(
            f"{self.context['service_url']}/v3/conversations/{self.context['conversation_id']}/activities",
            headers={"Authorization": f"Bearer {self.get_token()}"},
            json=content,
            timeout=15,
        )
        logger.debug("DEBUG: _send() response %s", response.status_code)
        logger.debug("DEBUG: _send() reason %s", response.reason)
        response.raise_for_status()
        return response

    def send_large_table(self, header, rows, title=None):
        """Send a large table of data to the user/channel.

        MS Teams really doesn't have a good way to present large tables, unfortunately,
        so we'll instead send each row separately formatted as a record.
        """
        blocks = []
        for row in rows:
            blocks.append(
                {
                    "type": "FactSet",
                    "facts": [{"title": header, "value": str(value)} for header, value in zip(header, row)],
                }
            )

        self.send_blocks(blocks, title=title)

    def needs_permission_to_send_image(self):
        """Return True if this bot needs to ask the user for permission to post an image.

        In MS Teams, this permission is required, unless we know that the user already granted it.
        """
        return "uploadInfo" not in self.context

    def ask_permission_to_send_image(self, filename, action_id):
        """Send a prompt to the user to grant permission to post an image."""
        # A FileConsentCard *cannot* be sent to a team channel.
        # We must always direct-message the user instead.
        if self.context["is_group"]:
            self.send_markdown(f"Hi {self.user_mention()}, I'll handle that in a private conversation with you.")
            response = requests.post(
                f"{self.context['service_url']}/v3/conversations",
                headers={"Authorization": f"Bearer {self.get_token()}"},
                json={
                    "bot": {"id": self.context["bot_id"], "name": self.context["bot_name"]},
                    "isGroup": False,
                    "members": [{"id": self.context["user_id"], "name": self.context["user_name"]}],
                    "tenantId": self.context["tenant_id"],
                    "topicName": "Image upload",
                },
                timeout=15,
            )
            response.raise_for_status()
            self.context["conversation_id"] = response.json()["id"]

        self._send(
            {
                "attachments": [
                    {
                        "contentType": "application/vnd.microsoft.teams.card.file.consent",
                        "content": {"description": "Your requested image", "acceptContext": {"action_id": action_id}},
                        "name": filename,
                    }
                ]
            }
        )

    @BACKEND_ACTION_MARKDOWN.time()
    def send_markdown(self, message, ephemeral=None):
        """Send a markdown-formatted text message to the user/channel specified by the context."""
        logger.debug("DEBUG: send_markdown() Sending message =  %s", message)
        self._send({"text": message, "textFormat": "markdown"})

    @BACKEND_ACTION_BLOCKS.time()
    def send_blocks(self, blocks, callback_id=None, modal=False, ephemeral=None, title=None):
        """Send a series of formatting blocks to the user/channel specified by the context."""
        logger.debug("DEBUG: send_blocks() Sending Blocks = %s", blocks)
        if title and title not in str(blocks[0]):
            blocks.insert(0, self.markdown_element(self.bold(title)))
        self._send(
            {
                "attachments": [
                    {
                        "contentType": "application/vnd.microsoft.card.adaptive",
                        "content": {"type": "AdaptiveCard", "version": "1.0", "body": blocks},
                    }
                ]
            }
        )

    @BACKEND_ACTION_SNIPPET.time()
    def send_snippet(self, text, title=None, ephemeral=None):
        """Send a longer chunk of text as a snippet or file attachment."""
        self.send_markdown(f"```\n{text}\n```")

    def send_image(self, image_path):
        """Send an image as an inline attachment."""
        if self.needs_permission_to_send_image():
            raise RuntimeError("send_image() called without permission being granted to send an image")

        # https://docs.microsoft.com/en-us/microsoftteams/platform/bots/how-to/conversations/send-and-receive-files

        # Upload the image to where we've been given permission to do so
        file_size = os.path.getsize(image_path)
        response = requests.put(
            self.context["uploadInfo"]["uploadUrl"],
            open(image_path, "rb"),  # pylint: disable=consider-using-with
            headers={
                "Content-Length": str(file_size),
                "Content-Range": f"bytes 0-{file_size-1}/{file_size}",
            },
            timeout=15,
        )
        response.raise_for_status()

        # Send the user a link to the uploaded image
        response = self._send(
            {
                "attachments": [
                    {
                        "contentType": "application/vnd.microsoft.teams.card.file.info",
                        "content": {
                            "fileType": self.context["uploadInfo"]["fileType"],
                            "uniqueId": self.context["uploadInfo"]["uniqueId"],
                        },
                        "name": os.path.basename(image_path),
                        "contentUrl": self.context["uploadInfo"]["contentUrl"],
                    }
                ]
            }
        )
        response.raise_for_status()

    def send_busy_indicator(self):
        """Send a "typing" indicator to show that work is in progress."""
        self._send({}, content_type="typing")

    def delete_message(self, message_id):
        """Delete a message that was previously sent."""
        requests.delete(
            f"{self.context['service_url']}/v3/conversations/{self.context['conversation_id']}/activities/{message_id}",
            headers={"Authorization": f"Bearer {self.get_token()}"},
            timeout=15,
        )

    def user_mention(self):
        """Markup for a mention of the username/userid specified in our context."""
        # TODO: this is non-trivial in MS Teams as we have to add metadata to the containing block
        # https://docs.microsoft.com/en-us/microsoftteams/platform/bots/how-to/conversations/
        #   channel-and-group-conversations?tabs=python#adding-mentions-to-your-messages
        # For now we just use the user name as plaintext, not an actual mention
        return f"{self.context['user_name']}"

    def bold(self, text):
        """Mark text as bold."""
        return f"*{text}*"
