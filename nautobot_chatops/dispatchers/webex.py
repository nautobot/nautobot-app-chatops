"""Dispatcher implementation for sending content to Webex."""

import logging
from typing import Optional

from texttable import Texttable
from webexteamssdk import WebexTeamsAPI
from webexteamssdk.exceptions import ApiError

from nautobot_chatops.metrics import backend_action_sum
from nautobot_chatops.utils import get_app_config_part

from .adaptive_cards import AdaptiveCardsDispatcher

logger = logging.getLogger(__name__)

# Create a metric to track time spent and requests made.
BACKEND_ACTION_LOOKUP = backend_action_sum.labels("webex", "platform_lookup")
BACKEND_ACTION_MARKDOWN = backend_action_sum.labels("webex", "send_markdown")
BACKEND_ACTION_BLOCKS = backend_action_sum.labels("webex", "send_blocks")
BACKEND_ACTION_SNIPPET = backend_action_sum.labels("webex", "send_snippet")
WEBEX_CONFIG = get_app_config_part("webex")

# pylint: disable=abstract-method


class WebexDispatcher(AdaptiveCardsDispatcher):
    """Dispatch cards and messages to Webex."""

    platform_name = "Webex"
    platform_slug = "webex"

    platform_color = "6EBE4A"

    def __init__(self, *args, **kwargs):
        """Init a WebexDispatcher."""
        super().__init__(*args, **kwargs)

        try:
            access_token = WEBEX_CONFIG["token"]
        except KeyError as err:
            error_msg = "The 'webex_token' setting must be configured"
            logger.error(error_msg)
            raise KeyError(error_msg) from err

        self.client = WebexTeamsAPI(access_token=access_token)
        self.webex_msg_char_limit = WEBEX_CONFIG.get("msg_char_limit", 7439)

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

    @classmethod
    def lookup_user_id_by_email(cls, email) -> Optional[str]:
        """Call out to Webex to look up a specific user ID by email.

        Args:
          email (str): Uniquely identifying email address of the user.

        Returns:
          (str, None)
        """
        instance = cls(context=None)
        try:
            response = instance.client.people.list(email=email)
            for person in response:
                return person.id
        except ApiError:
            return None

    @BACKEND_ACTION_MARKDOWN.time()
    def send_markdown(self, message, ephemeral=None):
        """Send a markdown-formatted text message to the user/channel specified by the context."""
        self.client.messages.create(roomId=self.context["channel_id"], markdown=message)

    @BACKEND_ACTION_BLOCKS.time()
    def send_blocks(self, blocks, callback_id=None, modal=False, ephemeral=None, title=None):
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
    def send_snippet(self, text, title=None, ephemeral=None):
        """Send a longer chunk of text as a file snippet."""
        return self.send_markdown(f"```\n{text}\n```")

    def delete_message(self, message_id):
        """Delete a message that was previously sent."""
        self.client.messages.delete(message_id)

    def user_mention(self):
        """Markup for a mention of the username/userid specified in our context."""
        # Webex doesn't let you use @mentions inside a direct message session.
        # It also doesn't seem to let you use @mentions inside an adaptive card (block).
        # So for now we just use the user name throughout.
        return f"{self.context.get('user_name')}"

    def send_large_table(self, header, rows, title=None):
        """Send a large table of data to the user/channel.

        Webex has a character limit per message of 7439 characters.
        This table is outputted at a max of 120 characters per line, but this varies based on the data in Nautobot.
        This table is dynamically rendered up to the maximum allowable charaters for each posting.
        """
        table = Texttable(max_width=120)
        table.set_deco(Texttable.HEADER)
        table.header(header)
        # Force all columns to be shown as text. Otherwise long numbers (such as account #) get abbreviated as 123.4e10
        table.set_cols_dtype(["t" for item in header])
        table.add_rows(rows, header=False)

        char_count = 0
        table_snippet = ""

        for line in table.draw().splitlines():
            # +1 is for the length of '\n'
            line_len = len(line) + 1
            if char_count + line_len > self.webex_msg_char_limit:
                self.send_snippet(table_snippet)
                table_snippet = ""
                char_count = 0
            table_snippet += line + "\n"
            char_count = len(table_snippet)
        self.send_snippet(table_snippet, title=title)
