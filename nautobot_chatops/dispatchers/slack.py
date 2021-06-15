"""Dispatcher implementation for sending content to Slack."""

import json
import logging
import os
import time

from django.conf import settings
from slack_sdk import WebClient
from slack_sdk.webhook.client import WebhookClient
from slack_sdk.errors import SlackApiError, SlackClientError

from nautobot_chatops.metrics import backend_action_sum
from .base import Dispatcher

logger = logging.getLogger("rq.worker")

# pylint: disable=abstract-method

# Create a metric to track time spent and requests made.
BACKEND_ACTION_LOOKUP = backend_action_sum.labels("slack", "platform_lookup")
BACKEND_ACTION_MARKDOWN = backend_action_sum.labels("slack", "send_markdown")
BACKEND_ACTION_BLOCKS = backend_action_sum.labels("slack", "send_blocks")
BACKEND_ACTION_SNIPPET = backend_action_sum.labels("slack", "send_snippet")


class SlackDispatcher(Dispatcher):
    """Dispatch messages and cards to Slack."""

    # pylint: disable=too-many-public-methods
    platform_name = "Slack"
    platform_slug = "slack"

    platform_color = "4A154B"  # Slack Aubergine

    command_prefix = settings.PLUGINS_CONFIG["nautobot_chatops"]["slack_slash_command_prefix"]
    """Prefix prepended to all commands, such as "/" or "!" in some clients."""

    def __init__(self, *args, **kwargs):
        """Init a SlackDispatcher."""
        super().__init__(*args, **kwargs)
        self.slack_client = WebClient(token=settings.PLUGINS_CONFIG["nautobot_chatops"]["slack_api_token"])
        self.slack_menu_limit = int(os.getenv("SLACK_MENU_LIMIT", "100"))

    # pylint: disable=too-many-branches
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
        cursor = None
        if item_type == "organization":  # pylint: disable=no-else-raise
            # The admin_teams_list API requires admin access and only works under Enterprise
            raise NotImplementedError
        elif item_type == "channel":
            while True:
                try:
                    response = instance.slack_client.conversations_list(cursor=cursor, limit=20, exclude_archived=True)
                except SlackApiError as err:
                    if err.response["error"] == "ratelimited":
                        delay = int(err.response.headers["Retry-After"])
                        time.sleep(delay)
                        continue
                    raise err
                for channel in response["channels"]:
                    if channel["name"] == item_name:
                        return channel["id"]
                cursor = response["response_metadata"]["next_cursor"]
                if not cursor:
                    break

        elif item_type == "user":
            while True:
                try:
                    response = instance.slack_client.users_list(cursor=cursor, limit=20)
                except SlackApiError as err:
                    if err.response["error"] == "ratelimited":
                        delay = int(err.response.headers["Retry-After"])
                        time.sleep(delay)
                        continue
                    raise err
                for member in response["members"]:
                    if member["name"] == item_name:
                        return member["id"]
                cursor = response["response_metadata"]["next_cursor"]
                if not cursor:
                    break

        return None

    # More complex APIs for presenting structured data - these typically build on the more basic functions below

    def command_response_header(self, command, subcommand, args, description="information", image_element=None):
        """Construct a consistently forwarded header including the command that was issued.

        Args:
          command (str): Primary command string
          subcommand (str): Secondary command string
          args (list): of tuples, either (arg_name, human_readable_value, literal_value) or (arg_name, literal_value)
          description (str): Short description of what information is contained in the response
          image_element (dict): As constructed by self.image_element()
        """
        fields = []
        for name, value, *_ in args:
            fields.append(self.markdown_element(self.bold(name)))
            fields.append(self.markdown_element(value))

        command = f"{self.command_prefix}{command}"

        block = {
            "type": "section",
            "text": self.markdown_element(
                f"Hey {self.user_mention()}, here is that {description} you requested\n"
                f"Shortcut: `{command} {subcommand} {' '.join(arg[-1] for arg in args)}`"
            ),
        }

        # Add to block "accessory" key if image_element exists. Otherwise do not
        if image_element:
            block["accessory"] = image_element

        # Slack doesn't like it if we send an empty fields list, we have to omit it entirely
        if fields:
            block["fields"] = fields

        return [block]

    # Send various content to the user or channel

    @BACKEND_ACTION_MARKDOWN.time()
    def send_markdown(self, message, ephemeral=False):
        """Send a Markdown-formatted text message to the user/channel specified by the context."""
        try:
            if ephemeral:
                self.slack_client.chat_postEphemeral(
                    channel=self.context.get("channel_id"),
                    user=self.context.get("user_id"),
                    text=message,
                )
            else:
                self.slack_client.chat_postMessage(
                    channel=self.context.get("channel_id"),
                    user=self.context.get("user_id"),
                    text=message,
                )
        except SlackClientError as slack_error:
            self.send_exception(slack_error)

    # pylint: disable=arguments-differ
    @BACKEND_ACTION_BLOCKS.time()
    def send_blocks(self, blocks, callback_id=None, ephemeral=False, modal=False, title="Your attention please!"):
        """Send a series of formatting blocks to the user/channel specified by the context.

        Slack distinguishes between simple inline interactive elements and modal dialogs. Modals can contain multiple
        inputs in a single dialog; more importantly for our purposes, certain inputs (such as textentry) can ONLY
        be used in modals and will be rejected if we try to use them inline.

        Args:
          blocks (list): List of block contents as constructed by other dispatcher functions
          callback_id (str): Callback ID string such as "command subcommand arg1 arg2". Required if `modal` is True.
          ephemeral (bool): Whether to send this as an ephemeral message (only visible to the targeted user)
          modal (bool): Whether to send this as a modal dialog rather than an inline block.
          title (str): Title to include on a modal dialog.
        """
        logger.info("Sending blocks: %s", json.dumps(blocks, indent=2))
        try:
            if modal:
                if not callback_id:
                    self.send_error("Tried to create a modal dialog without specifying a callback_id")
                    return
                self.slack_client.views_open(
                    trigger_id=self.context.get("trigger_id"),
                    view={
                        "type": "modal",
                        "title": self.text_element(title),
                        "submit": self.text_element("Submit"),
                        "blocks": blocks,
                        # Embed the current channel information into to the modal as modals don't store this otherwise
                        "private_metadata": json.dumps(
                            {
                                "channel_id": self.context.get("channel_id"),
                            }
                        ),
                        "callback_id": callback_id,
                    },
                )
            elif ephemeral:
                self.slack_client.chat_postEphemeral(
                    channel=self.context.get("channel_id"),
                    user=self.context.get("user_id"),
                    blocks=blocks,
                )
            else:
                self.slack_client.chat_postMessage(
                    channel=self.context.get("channel_id"),
                    user=self.context.get("user_id"),
                    blocks=blocks,
                )
        except SlackClientError as slack_error:
            self.send_exception(slack_error)

    @BACKEND_ACTION_SNIPPET.time()
    def send_snippet(self, text, title=None):
        """Send a longer chunk of text as a file snippet."""
        if self.context.get("channel_name") == "directmessage":
            channels = [self.context.get("user_id")]
        else:
            channels = [self.context.get("channel_id")]
        channels = ",".join(channels)
        logger.info("Sending snippet to %s: %s", channels, text)
        try:
            self.slack_client.files_upload(channels=channels, content=text, title=title)
        except SlackClientError as slack_error:
            self.send_exception(slack_error)

    def send_image(self, image_path):
        """Send an image as a file upload."""
        if self.context.get("channel_name") == "directmessage":
            channels = [self.context.get("user_id")]
        else:
            channels = [self.context.get("channel_id")]
        channels = ",".join(channels)
        logger.info("Sending image %s to %s", image_path, channels)
        self.slack_client.files_upload(channels=channels, file=image_path)

    def send_warning(self, message):
        """Send a warning message to the user/channel specified by the context."""
        self.send_markdown(f":warning: {self.bold(message)} :warning:", ephemeral=True)

    def send_error(self, message):
        """Send an error message to the user/channel specified by the context."""
        self.send_markdown(f":warning: {self.bold(message)} :warning:", ephemeral=True)

    # pylint: disable=unnecessary-pass
    def send_busy_indicator(self):
        """Send a "typing" indicator to show that work is in progress."""
        # Currently the Slack Events API does not support the "user_typing" event.
        # We're trying not to use the legacy Slack RTM API as it's deprecated.
        # So for now, we do nothing.
        pass

    def send_exception(self, exception):
        """Try to report an exception to the user."""
        self.slack_client.chat_postEphemeral(
            channel=self.context.get("channel_id"),
            user=self.context.get("user_id"),
            text=f"Sorry @{self.context.get('user_name')}, an error occurred :sob:\n```{exception}```",
        )

    # pylint: disable=no-self-use
    def delete_message(self, response_url):
        """Delete a message that was previously sent."""
        WebhookClient(response_url).send_dict({"delete_original": "true"})

    # Prompt the user for various basic inputs

    def prompt_for_text(self, action_id, help_text, label, title="Your attention please!"):
        """Prompt the user to enter freeform text into a field.

        Args:
          action_id (str): Identifier string to attach to the "submit" action.
          help_text (str): Markdown string to display as help text.
          label (str): Label text to display adjacent to the text field.
          title (str): Title to include on the modal dialog.
        """
        textentry = {
            "type": "input",
            "block_id": action_id,
            "label": self.text_element(label),
            "element": {"type": "plain_text_input", "action_id": action_id, "placeholder": self.text_element(label)},
        }
        blocks = [self.markdown_block(help_text), textentry]
        # In Slack, a textentry element can ONLY be sent in a modal dialog
        return self.send_blocks(blocks, callback_id=action_id, ephemeral=True, modal=True, title=title)

    def get_prompt_from_menu_choices(self, choices, offset=0):
        """Returns choices list to accommodate for Slack menu limits.

        Args:
          choices (list): List of (display, value) tuples
          offset (int): If set, starts displaying choices at index location from all choices,
                         as Slack only displays 100 options at a time

        Returns:
          choices (list): List of (display, value) tuples accommodating for Slack menu limits
        """
        choice_length = len(choices)
        if choice_length > self.slack_menu_limit:
            try:
                # Since we are showing "Next..." at the end, this isn't required to show to users anymore
                self.send_warning(
                    f"More than {self.slack_menu_limit} options are available."
                    f"Slack limits us to only displaying {self.slack_menu_limit} options at a time."
                )
            except SlackApiError:
                pass
            new_offset = offset + self.slack_menu_limit - 1
            if offset == 0:
                choices = choices[: self.slack_menu_limit - 1]  # 1 is to leave space for 'next' insert
            else:
                choices = choices[offset:new_offset]
            if choice_length > new_offset:
                # Only insert a 'next' offset if we still have more choices left to see
                choices.append(("Next...", f"menu_offset-{new_offset}"))
        return choices

    def prompt_from_menu(
        self, action_id, help_text, choices, default=(None, None), confirm=False, offset=0
    ):  # pylint: disable=too-many-arguments
        """Prompt the user for a selection from a menu.

        Args:
          action_id (str): Identifier string to attach to the "submit" action.
          help_text (str): Markdown string to display as help text.
          choices (list): List of (display, value) tuples.
          default (tuple): Default (display, value) to pre-select.
          confirm (bool): If True, prompt the user to confirm their selection (if the platform supports this).
          offset (int): If set, starts displaying choices at index location from all choices,
                         as Slack only displays 100 options at a time.
        """
        choices = self.get_prompt_from_menu_choices(choices, offset=offset)
        menu = self.select_element(action_id, choices, default=default, confirm=confirm)
        cancel_button = {
            "type": "button",
            "text": self.text_element("Cancel"),
            "action_id": "action",
            "value": "cancel",
        }

        blocks = [self.markdown_block(help_text), self.actions_block(action_id, [menu, cancel_button])]
        return self.send_blocks(blocks, ephemeral=True)

    # Construct content piecemeal, mostly for use with send_blocks()

    def multi_input_dialog(self, command, sub_command, dialog_title, dialog_list):
        """Provide several input fields on a single dialog.

        Args:
            command (str):  The top level command in use. (ex. net)
            sub_command (str): The command being invoked (ex. add-vlan)
            dialog_title (str): Title of the dialog box
            dialog_list (list):  List of dictionaries containing the dialog parameters. See Example below.

        Example:
            For a selection menu::

                {
                    type: "select",
                    label: "label",
                    choices: [("display 1", "value1"), ("display 2", "value 2")],
                    default: ("display 1", "value1"),
                    confirm: False
                }

            For a text dialog::

                {
                    type: "text",
                    label: "text displayed next to field"
                    default: "default-value"
                }

            Dictionary Fields

            - type: The type of object to create. Currently supported values: select, text
            - label: A text descriptor that will be placed next to the field
            - choices: A list of tuples which populates the choices in a dropdown selector
            - default: (optional) Default choice of a select menu or initial value to put in a text field.
            - confirm: (optional) If set to True, it will display a "Are you sure?" dialog upon submit.
        """
        blocks = []
        callback_id = f"{command} {sub_command}"
        for i, dialog in enumerate(dialog_list):
            action_id = f"param_{i}"
            if dialog["type"] == "select":
                menu = self.select_element(
                    action_id,
                    dialog["choices"],
                    default=dialog.get("default", (None, None)),
                    confirm=dialog.get("confirm", False),
                )
                blocks.append(self._input_block(action_id, dialog["label"], menu))
            if dialog["type"] == "text":
                textentry = {
                    "type": "plain_text_input",
                    "action_id": action_id,
                    "placeholder": self.text_element(dialog["label"]),
                    "initial_value": dialog.get("default", "") or "",
                }
                blocks.append(self._input_block(action_id, dialog["label"], textentry))

        return self.send_blocks(blocks, callback_id=callback_id, modal=True, ephemeral=False, title=dialog_title)

    def user_mention(self):
        """Markup for a mention of the username/userid specified in our context."""
        return f"<@{self.context['user_id']}>"

    def bold(self, text):
        """Mark text as bold."""
        return f"*{text}*"

    def actions_block(self, block_id, actions):
        """Construct a block consisting of a set of action elements."""
        return {"type": "actions", "block_id": block_id, "elements": actions}

    def _input_block(self, block_id, label, element):
        """Construct a block consisting of Input elements."""
        text_obj = self.text_element(label)
        return {"type": "input", "block_id": block_id, "label": text_obj, "element": element}

    def markdown_block(self, text):
        """Construct a simple Markdown-formatted text block."""
        return {"type": "section", "text": self.markdown_element(text)}

    def image_element(self, url, alt_text=""):
        """Construct an image element that can be embedded in a block."""
        return {"type": "image", "image_url": url, "alt_text": alt_text}

    def markdown_element(self, text):
        """Construct a basic Markdown-formatted text element."""
        return {"type": "mrkdwn", "text": text}

    def select_element(self, action_id, choices, default=(None, None), confirm=False):
        """Construct a basic selection menu with the given choices.

        .. note:: Slack's select menu supports option groups, but others such as Adaptive Cards do not;
                  we have to stick to the lowest common denominator, which means no groups.

        TODO: maybe refactor this API so that Slack can use groups and other dispatchers just ignore the groups?

        Args:
          action_id (str): Identifying string to associate with this element
          choices (list): List of (display, value) tuples
          default (tuple: Default (display, value) to preselect
          confirm (bool): If true (and the platform supports it), prompt the user to confirm their selection
        """
        data = {
            "type": "static_select",
            "action_id": action_id,
            "placeholder": self.text_element("Select an option"),
            "options": [{"text": self.text_element(choice), "value": value} for choice, value in choices],
        }
        default_text, default_value = default
        if default_text and default_value:
            data["initial_option"] = {"text": self.text_element(default_text), "value": default_value}
        if confirm:
            data["confirm"] = {
                "title": self.text_element("Are you sure?"),
                "text": self.markdown_element("Are you *really* sure you want to do this?"),
                "confirm": self.text_element("Yes"),
                "deny": self.text_element("No"),
            }

        return data

    def text_element(self, text):
        """Construct a basic plaintext element."""
        return {"type": "plain_text", "text": text}
