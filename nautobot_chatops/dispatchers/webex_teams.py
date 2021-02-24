"""Dispatcher implementation for sending content to WebEx Teams."""
import logging
from webexteamssdk import WebexTeamsAPI
from webexteamssdk.exceptions import ApiError
from django.conf import settings

from .adaptive_cards import AdaptiveCardsDispatcher
from nautobot_chatops.metrics import backend_action_sum

logger = logging.getLogger("rq.worker")

# Create a metric to track time spent and requests made.
BACKEND_ACTION_LOOKUP = backend_action_sum.labels("webex_teams", "platform_lookup")
BACKEND_ACTION_MARKDOWN = backend_action_sum.labels("webex_teams", "send_markdown")
BACKEND_ACTION_BLOCKS = backend_action_sum.labels("webex_teams", "send_blocks")
BACKEND_ACTION_SNIPPET = backend_action_sum.labels("webex_teams", "send_snippet")


class WebExTeamsDispatcher(AdaptiveCardsDispatcher):
    """Dispatch cards and messages to WebEx Teams."""

    platform_name = "WebEx Teams"
    platform_slug = "webex_teams"

    platform_color = "6EBE4A"

    def __init__(self, *args, **kwargs):
        """Init a WebExTeamsDispatcher."""
        super().__init__(*args, **kwargs)
        self.client = WebexTeamsAPI(access_token=settings.PLUGINS_CONFIG["nautobot_chatops"]["webex_teams_token"])

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
        instance = cls(context=None)
        # TODO: handle API pagination
        if item_type == "organization":
            try:
                # TODO: this seems to only work for "real" organizations, not privately created one-off channels
                response = instance.client.teams.list()
                for team in response:
                    if team.name == item_name:
                        return team.id
            except ApiError:
                pass
        elif item_type == "channel":
            try:
                response = instance.client.rooms.list()
                for channel in response:
                    if channel.title == item_name:
                        return channel.id
            except ApiError:
                pass
        elif item_type == "user":
            try:
                response = instance.client.people.list(email=item_name)
                for person in response:
                    return person.id
            except ApiError:
                pass
        else:
            raise NotImplementedError

        return None

    @BACKEND_ACTION_MARKDOWN.time()
    def send_markdown(self, message, ephemeral=False):
        """Send a markdown-formatted text message to the user/channel specified by the context."""
        self.client.messages.create(roomId=self.context["channel_id"], markdown=message)

    @BACKEND_ACTION_BLOCKS.time()
    def send_blocks(self, blocks, callback_id=None, modal=False, ephemeral=False, title=None):
        """Send a series of formatting blocks to the user/channel specified by the context."""
        if title and title not in str(blocks[0]):
            blocks.insert(0, self.markdown_element(self.bold(title)))
        self.client.messages.create(
            roomId=self.context["channel_id"],
            text="If you're seeing this message, something went wrong",
            attachments=[
                {
                    "contentType": "application/vnd.microsoft.card.adaptive",
                    "content": {"type": "AdaptiveCard", "version": "1.1", "body": blocks},
                }
            ],
        )

    def send_image(self, image_path):
        """Send an image as a file upload."""
        self.client.messages.create(roomId=self.context["channel_id"], files=[image_path])

    @BACKEND_ACTION_SNIPPET.time()
    def send_snippet(self, text):
        """Send a longer chunk of text as a file snippet."""
        return self.send_markdown(f"```\n{text}\n```")

    def delete_message(self, message_id):
        """Delete a message that was previously sent."""
        self.client.messages.delete(message_id)

    def user_mention(self):
        """Markup for a mention of the username/userid specified in our context."""
        # WebEx Teams doesn't let you use @mentions inside a direct message session.
        # It also doesn't seem to let you use @mentions inside an adaptive card (block).
        # So for now we just use the user name throughout.
        return f"{self.context.get('user_name')}"
