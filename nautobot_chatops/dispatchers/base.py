"""Generic base class modeling the API for sending messages to a generic chat platform."""

import logging

from django.templatetags.static import static

from django.conf import settings

from texttable import Texttable

logger = logging.getLogger("rq.worker")


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

    @classmethod
    def subclasses(cls):
        """Get a list of all subclasses of Dispatcher that are known to Nautobot."""
        # TODO: this should be dynamic using entry_points
        # pylint: disable=import-outside-toplevel, unused-import, cyclic-import
        if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_slack"):
            from .slack import SlackDispatcher

        if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_ms_teams"):
            from .ms_teams import MSTeamsDispatcher

        # v1.4.0 backwards compatibility
        if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_webex") or settings.PLUGINS_CONFIG[
            "nautobot_chatops"
        ].get("enable_webex_teams"):
            from .webex import WebExDispatcher

            if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_webex_teams"):
                logger.warning("The 'enable_webex_teams' setting is deprecated, please use 'enable_webex' instead.")

        if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_mattermost"):
            from .mattermost import MattermostDispatcher

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
    def platform_lookup(cls, item_type, item_name):
        """Call out to the chat platform to look up, e.g., a specific user ID by name.

        Args:
          item_type (str): One of "organization", "channel", "user"
          item_name (str): Uniquely identifying name of the given item.

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

    def send_large_table(self, header, rows):
        """Send a large table of data to the user/channel.

        The below default implementation works for both Slack and WebEx.
        """
        table = Texttable(max_width=120)
        table.set_deco(Texttable.HEADER)
        table.header(header)
        # Force all columns to be shown as text. Otherwise long numbers (such as account #) get abbreviated as 123.4e10
        table.set_cols_dtype(["t" for item in header])
        table.add_rows(rows, header=False)
        self.send_snippet(table.draw())

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
        raise NotImplementedError

    # pylint: disable=no-self-use
    def needs_permission_to_send_image(self):
        """Return True if this bot needs to ask the user for permission to post an image."""
        return False

    def ask_permission_to_send_image(self, filename, action_id):
        """Send a prompt to the user to grant permission to post an image."""
        raise NotImplementedError

    # Send various content to the user or channel

    def send_markdown(self, message, ephemeral=False):
        """Send a Markdown-formatted text message to the user/channel specified by the context."""
        raise NotImplementedError

    def send_blocks(self, blocks, callback_id=None, modal=False, ephemeral=False, title=None):
        """Send a series of formatting blocks to the user/channel specified by the context."""
        raise NotImplementedError

    def send_snippet(self, text, title=None):
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

    def prompt_from_menu(
        self, action_id, help_text, choices, default=(None, None), confirm=False, offset=0
    ):  # pylint: disable=too-many-arguments
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

    # pylint: disable=no-self-use
    def bold(self, text):
        """Mark text as bold."""
        return f"**{text}**"

    # pylint: disable=no-self-use
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
          default (tuple: Default (display, value) to preselect
          confirm (bool): If true (and the platform supports it), prompt the user to confirm their selection
        """
        raise NotImplementedError

    def text_element(self, text):
        """Construct a simple plaintext element."""
        raise NotImplementedError
