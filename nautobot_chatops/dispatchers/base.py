"""Generic base class modeling the API for sending messages to a generic chat platform."""

import logging
from typing import Dict, Optional

from django.conf import settings
from django.contrib.auth import get_user_model
from django.core.cache import cache
from django.core.exceptions import ObjectDoesNotExist
from django.templatetags.static import static
from nautobot.apps.config import get_app_settings_or_config
from texttable import Texttable

from nautobot_chatops.models import ChatOpsAccountLink

logger = logging.getLogger(__name__)

_APP_CONFIG: Dict = settings.PLUGINS_CONFIG["nautobot_chatops"]


class Dispatcher:
    """Abstract base class for all chat-app dispatchers."""

    # pylint:disable=too-many-public-methods

    platform_name = None
    """Descriptive string - must be set by all subclasses."""

    platform_slug = None
    """String which is used to set the "chat_type" extra
    variable when sending jobs to Ansible tower.

    Ansible uses this to derive the filename of the module to call
    when running the chat_message Role.
    """

    platform_color = None
    """RGB hex code associated with this platform - must be set by all subclasses."""

    command_prefix = ""
    """Prefix prepended to all commands, such as "/" or "!" in some clients."""

    def __init__(self, context=None):
        """Init this Dispatcher with the provided dict of contextual information (which will vary by app)."""
        self.context = context or {}

    @property
    def user(self):
        """Dispatcher property containing the Nautobot User that is linked to the Chat User."""
        if self.context.get("user_id"):
            try:
                return ChatOpsAccountLink.objects.get(
                    platform=self.platform_slug, user_id=self.context["user_id"]
                ).nautobot_user
            except ObjectDoesNotExist:
                logger.warning(
                    "Could not find User matching %s - id: %s. Add a ChatOps User to link the accounts.",
                    self.context["user_name"],
                    self.context["user_id"],
                )
        user_model = get_user_model()
        user, _ = user_model.objects.get_or_create(
            username=get_app_settings_or_config("nautobot_chatops", "fallback_chatops_user")
        )
        return user

    def _get_cache_key(self) -> str:
        """Key generator for the cache, adding the app prefix name."""
        # Using __file__ as a key customization within the cache
        return "-".join([__file__, self.context.get("user_id", "generic")])

    def get_session_entry(self, key: str):
        """Return the session data for a key."""
        return cache.get(self._get_cache_key(), {}).get(key, None)

    def set_session_entry(self, key: str, value):
        """Set the session data for a key."""
        session_value = cache.get(self._get_cache_key(), {})
        session_value[key] = value

        cache.set(
            self._get_cache_key(),
            session_value,
            timeout=_APP_CONFIG["session_cache_timeout"],
        )

    def unset_session_entry(self, key: str):
        """Unset a session data for a key."""
        session_value = cache.get(self._get_cache_key(), {})
        try:
            del session_value[key]
            self.set_session(session_value)
        except KeyError:
            pass

    def get_session(self):
        """Return the whole session data."""
        return cache.get(self._get_cache_key(), {})

    def set_session(self, value: Dict):
        """Set the whole session data."""
        if not isinstance(value, dict):
            raise ValueError("Value must be a dict for the whole session data.")
        session_value = value

        cache.set(
            self._get_cache_key(),
            session_value,
            timeout=_APP_CONFIG["session_cache_timeout"],
        )

    def unset_session(self):
        """Unset whole session data."""
        cache.delete(self._get_cache_key())

    @classmethod
    def subclasses(cls):
        """Get a list of all subclasses of Dispatcher that are known to Nautobot."""
        # TODO: this should be dynamic using entry_points
        # pylint: disable=import-outside-toplevel, unused-import, cyclic-import
        if get_app_settings_or_config("nautobot_chatops", "enable_slack"):
            from .slack import SlackDispatcher  # noqa: F401

        if get_app_settings_or_config("nautobot_chatops", "enable_ms_teams"):
            from .ms_teams import MSTeamsDispatcher  # noqa: F401

        if get_app_settings_or_config("nautobot_chatops", "enable_webex"):
            from .webex import WebexDispatcher  # noqa: F401

        if get_app_settings_or_config("nautobot_chatops", "enable_mattermost"):
            from .mattermost import MattermostDispatcher  # noqa: F401

        subclasses = set()
        classes = [cls]
        while classes:
            parent = classes.pop()
            for child in parent.__subclasses__():
                if child not in subclasses:
                    subclasses.add(child)
                    classes.append(child)
        return subclasses

    @classmethod
    def platform_lookup(cls, item_type, item_name) -> Optional[str]:
        """Call out to the chat platform to look up, e.g., a specific user ID by name.

        Args:
          item_type (str): One of "organization", "channel", "user"
          item_name (str): Uniquely identifying name of the given item.

        Returns:
          (str, None)
        """
        raise NotImplementedError

    @classmethod
    def lookup_user_id_by_email(cls, email) -> Optional[str]:
        """Call out to the chat platform to look up a specific user ID by email.

        Args:
          email (str): Uniquely identifying email address of the user.

        Returns:
          (str, None)
        """
        raise NotImplementedError

    def static_url(self, path):
        """Construct an absolute URL for the given static file path, such as "nautobot/NautobotLogoSquare.png"."""
        static_path = str(static(path))
        if static_path.startswith("http"):
            return static_path
        return f"{self.context['request_scheme']}://{self.context['request_host']}{static_path}"

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
        raise NotImplementedError

    def send_large_table(self, header, rows, title=None):
        """Send a large table of data to the user/channel.

        The below default implementation works for both Slack and Webex.
        """
        table = Texttable(max_width=120)
        table.set_deco(Texttable.HEADER)
        table.header(header)
        # Left Align headers to match the alignment of the rows
        table.set_header_align(["l" for _ in header])
        # Force all columns to be shown as text. Otherwise long numbers (such as account #) get abbreviated as 123.4e10
        table.set_cols_dtype(["t" for _ in header])
        table.add_rows(rows, header=False)
        self.send_snippet(table.draw(), title=title)

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
                    default: "default-value",
                    optional: True
                }

            Dictionary Fields

            - type: The type of object to create. Currently supported values: select, text
            - label: A text descriptor that will be placed next to the field
            - choices: A list of tuples which populates the choices in a dropdown selector
            - default: (optional) Default choice of a select menu or initial value to put in a text field.
            - confirm: (optional) If set to True, it will display a "Are you sure?" dialog upon submit.
            - optional: (optional) If set to True, the field will return NoneType is not specified.
        """
        raise NotImplementedError

    def needs_permission_to_send_image(self):
        """Return True if this bot needs to ask the user for permission to post an image."""
        return False

    def ask_permission_to_send_image(self, filename, action_id):
        """Send a prompt to the user to grant permission to post an image."""
        raise NotImplementedError

    # Send various content to the user or channel

    def send_markdown(self, message, ephemeral=None):
        """Send a Markdown-formatted text message to the user/channel specified by the context."""
        # pylint: disable=unused-argument
        if ephemeral is None:
            ephemeral = _APP_CONFIG["send_all_messages_private"]
        raise NotImplementedError

    def send_blocks(
        self,
        blocks,
        callback_id=None,
        modal=False,
        ephemeral=None,
        title=None,
    ):
        """Send a series of formatting blocks to the user/channel specified by the context."""
        # pylint: disable=unused-argument
        if ephemeral is None:
            ephemeral = _APP_CONFIG["send_all_messages_private"]
        raise NotImplementedError

    def send_snippet(self, text, title=None, ephemeral=None):
        """Send a longer chunk of text as a snippet or file attachment."""
        raise NotImplementedError

    def send_image(self, image_path):
        """Send an image as a file upload."""
        raise NotImplementedError

    def send_warning(self, message):
        """Send a warning message to the user/channel specified by the context."""
        raise NotImplementedError

    def send_error(self, message):
        """Send an error message to the user/channel specified by the context."""
        raise NotImplementedError

    def send_busy_indicator(self):
        """Send a "typing" indicator to show that work is in progress."""
        raise NotImplementedError

    # Prompt the user for various basic inputs

    def prompt_for_text(self, action_id, help_text, label, title="Your attention please!"):
        """Prompt the user to enter freeform text into a field.

        Args:
          action_id (str): Identifier string to attach to the "submit" action.
          help_text (str): Markdown string to display as help text.
          label (str): Label text to display adjacent to the text field.
          title (str): Title to include on the modal dialog.
        """
        raise NotImplementedError

    def prompt_from_menu(self, action_id, help_text, choices, default=(None, None), confirm=False, offset=0):  # pylint: disable=too-many-arguments
        """Prompt the user to make a selection from a menu of choices.

        Args:
          action_id (str): Identifier string to attach to the "submit" action.
          help_text (str): Markdown string to display as help text.
          choices (list): List of (display, value) tuples.
          default (tuple): Default (display, value) to pre-select.
          confirm (bool): If True, prompt the user to confirm their selection (if the platform supports this).
          offset (int): Used for apps that have a menu selection display limit.
        """
        raise NotImplementedError

    # Inline text formatting

    def user_mention(self):
        """Markup for a mention of the username/userid specified in our context."""
        raise NotImplementedError

    def bold(self, text):
        """Mark text as bold."""
        return f"**{text}**"

    def hyperlink(self, text, url):
        """Create Hyperlinks."""
        return f"[{text}]({url})"

    def monospace(self, text):
        """Mark text as monospace."""
        return f"`{text}`"

    # Individual blocks to assemble together for use with send_blocks()

    def actions_block(self, block_id, actions):
        """Construct a block consisting of a set of action elements."""
        raise NotImplementedError

    def markdown_block(self, text):
        """Construct a simple Markdown-formatted text block."""
        raise NotImplementedError

    # Individual UI elements within a block - the most basic piece of all

    def image_element(self, url, alt_text=""):
        """Construct an image element that can be embedded in a block."""
        raise NotImplementedError

    def markdown_element(self, text):
        """Construct a simple Markdown-formatted text element."""
        raise NotImplementedError

    def select_element(self, action_id, choices, default=(None, None), confirm=False):
        """Construct a basic selection menu with the given choices.

        Args:
          action_id (str): Identifying string to associate with this element
          choices (list): List of (display, value) tuples
          default (tuple): Default (display, value) to preselect
          confirm (bool): If true (and the platform supports it), prompt the user to confirm their selection
        """
        raise NotImplementedError

    def text_element(self, text):
        """Construct a simple plaintext element."""
        raise NotImplementedError

    @staticmethod
    def split_message(text_string: str, max_message_size: int) -> list:
        """Method to split a message into smaller messages.

        Args:
            text_string (str): Text string that should be split
            max_message_size (int): Maximum size for a message
        """
        return_list = [""]

        for line in text_string.splitlines():
            # len(line) + 2 to account for a new line character in the character line
            # Check to see if the line length of the last item in the list is longer than the max message size
            # Once it would be larger than the max size, then start the next line.
            if (len(line) + 2) + len(return_list[-1]) < max_message_size:
                return_list[-1] += f"{line}\n"
            else:
                return_list.append(f"{line}\n")

        return return_list
