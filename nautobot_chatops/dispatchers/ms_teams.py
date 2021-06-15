"""Dispatcher impelementation for sending content to Microsoft Teams."""
import os
import logging
import requests

from django.conf import settings

from nautobot_chatops.metrics import backend_action_sum
from .adaptive_cards import AdaptiveCardsDispatcher

logger = logging.getLogger("rq.worker")

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

    @classmethod
    @BACKEND_ACTION_LOOKUP.time()
    def platform_lookup(cls, item_type, item_name):
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
    def get_token():
        """Obtain the JWT token that's needed for the bot to publish messages back to MS Teams."""
        # TODO: for efficiency, cache the token and only refresh it when it expires
        # For now we just get a new token every time.
        response = requests.post(
            "https://login.microsoftonline.com/botframework.com/oauth2/v2.0/token",
            data={
                "grant_type": "client_credentials",
                "client_id": settings.PLUGINS_CONFIG["nautobot_chatops"]["microsoft_app_id"],
                "client_secret": settings.PLUGINS_CONFIG["nautobot_chatops"]["microsoft_app_password"],
                "scope": "https://api.botframework.com/.default",
            },
        )
        token = response.json()["access_token"]
        return token

    def _send(self, content, content_type="message"):
        """Publish content back to Microsoft Teams."""
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
        response = requests.post(
            f"{self.context['service_url']}/v3/conversations/{self.context['conversation_id']}/activities",
            headers={"Authorization": f"Bearer {self.get_token()}"},
            json=content,
        )
        return response

    def send_large_table(self, header, rows):
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

        self.send_blocks(blocks)

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
    def send_markdown(self, message, ephemeral=False):
        """Send a markdown-formatted text message to the user/channel specified by the context."""
        self._send({"text": message, "textFormat": "markdown"})

    @BACKEND_ACTION_BLOCKS.time()
    def send_blocks(self, blocks, callback_id=None, modal=False, ephemeral=False, title=None):
        """Send a series of formatting blocks to the user/channel specified by the context."""
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
    def send_snippet(self, text, title=None):
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
            open(image_path, "rb"),
            headers={
                "Content-Length": str(file_size),
                "Content-Range": f"bytes 0-{file_size-1}/{file_size}",
            },
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
        )

    def user_mention(self):
        """Markup for a mention of the username/userid specified in our context."""
        # TODO: this is non-trivial in MS Teams as we have to add metadata to the containing block
        # https://docs.microsoft.com/en-us/microsoftteams/platform/bots/how-to/conversations/
        #   channel-and-group-conversations?tabs=python#adding-mentions-to-your-messages
        # For now we just use the user name as plaintext, not an actual mention
        return f"{self.context['user_name']}"
