"""Dispatcher implementation for sending content to Mattermost."""

import json
import logging
import time
import requests
from requests.exceptions import HTTPError

from django.conf import settings

from nautobot_chatops.metrics import backend_action_sum
from .base import Dispatcher

logger = logging.getLogger("rq.worker")

# pylint: disable=abstract-method,line-too-long,raise-missing-from

# Create a metric to track time spent and requests made.
BACKEND_ACTION_LOOKUP = backend_action_sum.labels("mattermost", "platform_lookup")
BACKEND_ACTION_MARKDOWN = backend_action_sum.labels("mattermost", "send_markdown")
BACKEND_ACTION_BLOCKS = backend_action_sum.labels("mattermost", "send_blocks")
BACKEND_ACTION_SNIPPET = backend_action_sum.labels("mattermost", "send_snippet")


class MMException(Exception):
    """Generic Mattermost Exception."""


class MMRateLimit(MMException):
    """Mattermost responded with Rate Limited."""


class BadRequestException(MMException):
    """Malformed Request."""


class UnauthorizedException(MMException):
    """Invalid Personal Access Token."""


class ForbiddenException(MMException):
    """Bot Unauthorized for api endpoint."""


class NotFoundException(MMException):
    """Endpoint does not exist."""


class MethodNotAllowedException(MMException):
    """Endpoint does not allow used method."""


class NotAcceptableException(MMException):
    """Invalid Content Type for Endpoint."""


class UnsupportedMediaTypeException(MMException):
    """Attempting to POST data in incorrect format."""


class InternalServerErrorException(MMException):
    """Mattermost Server Error."""


class ServiceUnavailableException(MMException):
    """Mattermost API is currently in maintenance mode."""


def error_report(function):
    """Wrapper to catch api errors and raise appropriate Exceptions."""

    def inner(*args, **kwargs):  # pylint: disable=inconsistent-return-statements
        """Inner wrapper to catch api errors and raise appropriate Exceptions."""
        try:
            return function(*args, **kwargs)
        except HTTPError as err:
            if err.response.status_code == 400:
                raise BadRequestException("Malformatted requests: {}".format(err.response.text))
            if err.response.status_code == 401:
                raise UnauthorizedException(
                    "Invalid credentials provided or account is locked: {}".format(err.response.text)
                )
            if err.response.status_code == 403:
                raise ForbiddenException(
                    "Insufficient permissions to execute request (ie, any POST method as a regular user): {}".format(
                        err.response.text
                    )
                )
            if err.response.status_code == 404:
                raise NotFoundException(
                    "Attempting to access an endpoint that does not exist: {}".format(err.response.text)
                )
            if err.response.status_code == 405:
                raise MethodNotAllowedException(
                    "Wrong request type for target endpoint (ie, POSTing data to a GET endpoint): {}".format(
                        err.response.text
                    )
                )
            if err.response.status_code == 406:
                raise NotAcceptableException(
                    "Content Type of the data returned does not match the Accept header of the request: {}".format(
                        err.response.text
                    )
                )
            if err.response.status_code == 415:
                raise UnsupportedMediaTypeException(
                    "Attempting to POST data in incorrect format: {}".format(err.response.text)
                )
            if err.response.status_code == 429:
                raise MMRateLimit(
                    "You have exceeded the max number of requests per 1-minute period: {}".format(err.response.text)
                )
            if err.response.status_code == 500:
                raise InternalServerErrorException(
                    "Contact support if you see this error type: {}".format(err.response.text)
                )
            if err.response.status_code == 503:
                raise ServiceUnavailableException(
                    "The Mattermost API is currently in maintenance mode: {}".format(err.response.text)
                )

    return inner


class Driver:
    """Mattermost API Client."""

    def __init__(self, options):
        """Init the Mattermost Driver."""
        self._url = options["url"] + "/api/v4"
        self._token = options["token"]
        self._user_id = None
        self._headers = {"Authorization": "Bearer " + self._token}

    @error_report
    def post(self, endpoint, params=None, data=None, multipart_formdata=None):
        """Post object to endpoint.

        Args:
            endpoint (str): Endpoint to post object to.
            params (str, optional): Optional params to pass to POST. Defaults to None.
            data (dict, optional): JSON dictionary to send to Mattermost. Defaults to None.
            multipart_formdata (str, optional): data to send using Multipart/formdata. Defaults to None.

        Returns:
            dict: Response from Mattermost API.
        """
        if data is not None:
            data = json.dumps(data)

        mm_response = requests.post(
            self._url + endpoint, headers=self._headers, params=params, data=data, files=multipart_formdata
        )
        mm_response.raise_for_status()

        return mm_response.json()

    @error_report
    def get(self, endpoint, params=None, raw=False):
        """Get object from endpoint.

        Args:
            endpoint (str): Endpoint to get object from.
            params (str, optional): Params to pass to the GET. Defaults to None.
            raw (bool, optional): Changes return to string. Defaults to False.

        Returns:
            dict: Response from Mattermost API. Unless raw, which returns the string.
        """
        mm_response = requests.get(self._url + endpoint, headers=self._headers, params=params)
        mm_response.raise_for_status()
        if raw:
            return mm_response

        return mm_response.json()

    @error_report
    def delete(self, endpoint):
        """Delete object at endpoint.

        Args:
            endpoint (string): Endpoint to post delete to.
        """
        mm_response = requests.delete(self._url + endpoint, headers=self._headers)
        mm_response.raise_for_status()

    def chat_post_message(self, channel_id, message=None, blocks=None, files=None, snippet=None):
        """Post Message to Mattermost Channel.

        Args:
            channel_id (str): Mattermost ID for the Channel.
            message (str, optional): Text to add to the post. Defaults to None.
            blocks (dict, optional): Blocks to add to the post. Defaults to None.
            files (list, optional): Local filepaths of files to send. Defaults to None.
            snippet ([type], optional): Long text to upload and attach. Defaults to None.
        """
        data = {
            "channel_id": channel_id,
        }
        if message:
            data["message"] = message

        if blocks:
            data["props"] = {"attachments": blocks}
        file_ids = []
        if files:
            for filename in files:
                file_ids.append(self.upload_file(channel_id, open(filename, "rb"))["id"])
        if snippet:
            file_ids.append(self.upload_file(channel_id, snippet.encode("utf-8"))["id"])
        data["file_ids"] = file_ids
        self.post("/posts", data=data)

    def chat_post_ephemeral(self, channel_id, user_id, message=None, blocks=None):
        """Post Ephemeral Message to Mattermost Channel.

        Args:
            channel_id (str): Mattermost ID for the Channel.
            user_id (str): Mattermost ID for the User.
            message (str, optional): Text to add to the post. Defaults to None.
            blocks (dict, optional): Blocks to add to the post. Defaults to None.
        """
        data = {"user_id": user_id}
        post = {
            "channel_id": channel_id,
        }
        if message:
            post["message"] = message

        if blocks:
            post["props"] = {"attachments": blocks}
        data["post"] = post
        self.post("/posts/ephemeral", data=data)

    def open_dialog(self, trigger_id, view, dialog_url):
        """Opens a Dialog in Mattermost.

        Args:
            trigger_id (str): [description]
            view ([type]): [description]
            dialog_url ([type]): [description]
        """
        data = {"trigger_id": trigger_id, "url": dialog_url, "dialog": view}
        self.post("/actions/dialogs/open", data=data)

    def upload_file(self, channel_id, file):
        """Uploads a file that can later be attached to a post.

        Instead of passing the filepath, we instead expect a
        File Object or a byte string.  This is to support
        images as well as snippets.

        Args:
            channel_id (str): The channel ID to upload to.
            file (byte): The byte representation of the file.

        Returns:
            dict: Uploaded File.

        """
        return self.post("/files", multipart_formdata={"files": file, "channel_id": (None, channel_id)})["file_infos"][
            0
        ]


class MattermostDispatcher(Dispatcher):  # pylint: disable=too-many-public-methods
    """Dispatch messages and cards to Mattermost."""

    platform_name = "Mattermost"
    platform_slug = "mattermost"

    platform_color = "145dbf"  # Mattermost Blue

    def __init__(self, *args, **kwargs):
        """Init a MattermostDispatcher."""
        super().__init__(*args, **kwargs)
        self.mm_client = Driver(
            {
                "url": settings.PLUGINS_CONFIG["nautobot_chatops"]["mattermost_url"],
                "token": settings.PLUGINS_CONFIG["nautobot_chatops"]["mattermost_api_token"],
            }
        )

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
        if item_type == "organization":  # pylint: disable=no-else-raise
            # The admin_teams_list API requires admin access and only works under Enterprise
            raise NotImplementedError
        elif item_type == "channel":
            page = 0
            while True:
                try:
                    response = instance.mm_client.get("/channels", params=f"per_page=20&page={page}")
                except MMRateLimit as err:
                    logger.info("Rate Limit for Mattermost API hit, pausing for 5 seconds to clear: %s", err)
                    # TODO find a way to access HEADERS X-Ratelimit-Reset
                    time.sleep(5)
                    continue
                if not response:
                    break
                for channel in response:
                    if channel["name"] == item_name:
                        return channel["id"]
                page += 1

        elif item_type == "user":
            response = instance.mm_client.get(f"/users/username/{item_name}")
            return response["id"]

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
            field = {"title": name, "value": value}
            fields.append(field)

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
            block.update(image_element)

        # Mattermost doesn't like it if we send an empty fields list, we have to omit it entirely
        if fields:
            block["fields"] = fields

        return [block]

    # Send various content to the user or channel

    @BACKEND_ACTION_MARKDOWN.time()
    def send_markdown(self, message, ephemeral=False):
        """Send a Markdown-formatted text message to the user/channel specified by the context."""
        try:
            if ephemeral:
                self.mm_client.chat_post_ephemeral(
                    self.context.get("channel_id"), self.context.get("user_id"), message=message
                )
            else:
                self.mm_client.chat_post_message(channel_id=self.context.get("channel_id"), message=message)
        except MMException as mattermost_error:
            self.send_exception(mattermost_error)

    # pylint: disable=arguments-differ
    @BACKEND_ACTION_BLOCKS.time()
    def send_blocks(self, blocks, callback_id=None, ephemeral=False, modal=False, title="Your attention please!"):
        """Send a series of formatting blocks to the user/channel specified by the context.

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
                    self.send_error("Tried to create a dialog without specifying a callback_id")
                    return
                self.mm_client.open_dialog(
                    trigger_id=self.context.get("trigger_id"),
                    view={
                        "title": self.text_element(title),
                        "submit_label": self.text_element("Submit"),
                        "elements": blocks,
                        # Embed the current channel information into to the modal as modals don't store this otherwise
                        "private_metadata": json.dumps(
                            {
                                "channel_id": self.context.get("channel_id"),
                            }
                        ),
                        "callback_id": callback_id,
                        "state": self.context.get("token", ""),
                    },
                    dialog_url=self.context.get("integration_url"),
                )
            elif ephemeral:
                self.mm_client.chat_post_ephemeral(
                    channel_id=self.context.get("channel_id"), user_id=self.context.get("user_id"), blocks=blocks
                )
            else:
                self.mm_client.chat_post_message(channel_id=self.context.get("channel_id"), blocks=blocks)
        except MMException as mm_error:
            self.send_exception(mm_error)

    @BACKEND_ACTION_SNIPPET.time()
    def send_snippet(self, text, title=None):
        """Send a longer chunk of text as a file snippet."""
        channel = [self.context.get("channel_id")]
        logger.info("Sending snippet to %s: %s", channel, text)
        self.mm_client.chat_post_message(channel_id=self.context.get("channel_id"), snippet=text)

    def send_image(self, image_path):
        """Send an image as a file upload."""
        channel = [self.context.get("channel_id")]
        logger.info("Sending image %s to %s", image_path, channel)
        self.mm_client.chat_post_message(channel_id=self.context.get("channel_id"), files=[image_path])

    def send_warning(self, message):
        """Send a warning message to the user/channel specified by the context."""
        self.send_markdown(f":warning: {self.bold(message)} :warning:", ephemeral=True)

    def send_error(self, message):
        """Send an error message to the user/channel specified by the context."""
        self.send_markdown(f":warning: {self.bold(message)} :warning:", ephemeral=True)

    def send_busy_indicator(self):
        """Send a "typing" indicator to show that work is in progress."""
        self.mm_client.post("/users/me/typing", data={"channel_id": self.context.get("channel_id")})

    def send_exception(self, exception):
        """Try to report an exception to the user."""
        self.mm_client.chat_post_ephemeral(
            channel_id=self.context.get("channel_id"),
            user_id=self.context.get("user_id"),
            message=f"Sorry @{self.context.get('user_name')}, an error occurred :sob:\n```{exception}```",
        )

    def delete_message(self, post_id):
        """Delete a message that was previously sent."""
        # Bot accounts cannot delete Ephemeral Messages.
        try:
            self.mm_client.delete(f"/posts/{post_id}")
        except ForbiddenException as exc:
            logger.info("Ignoring 403 exception as this is likely an Ephemeral post: %s ", exc)

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
            "type": "text",
            "name": action_id,
            "display_name": self.text_element(label),
            "help_text": help_text,
        }
        blocks = [textentry]
        # In Mattermost, a textentry element can ONLY be sent in a modal Interactive dialog
        return self.send_blocks(blocks, callback_id=action_id, ephemeral=False, modal=True, title=title)

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
          offset (int): Used for apps that have a menu selection display limit.
        """
        # Default and Confirm options can only be done in Interactive Dialog.  Since the prompt_from_menu is
        # using Ephemeral we will build the basic select.  multi_input_dialog will use the Interactive Dialog.
        logger.info("Ignoring: prompt_from_menu cannot use provided default: %s or confirm: %s", default, confirm)
        menu = self.select_element(action_id, choices)
        cancel_button = {
            "id": "Cancel",
            "name": "Cancel",
            "integration": {
                "url": self.context.get("integration_url", ""),
                "context": {"type": "button", "action_id": "action", "value": "cancel", "action": "cancel"},
            },
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
                select_menu = self.select_element_interactive(
                    action_id, dialog["choices"], dialog.get("default", (None, None)), dialog.get("confirm", False)
                )
                blocks.append(self._input_block(action_id, dialog["label"], select_menu))
            if dialog["type"] == "text":
                text_entry = {
                    "type": "text",
                    "name": action_id,
                    "display_name": self.text_element(dialog["label"]),
                    "default": dialog.get("default", "") or "",
                }
                blocks.append(self._input_block(action_id, dialog["label"], text_entry))

        return self.send_blocks(blocks, callback_id=callback_id, modal=True, ephemeral=True, title=dialog_title)

    def user_mention(self):
        """Markup for a mention of the username/userid specified in our context."""
        return f"@{self.context['user_name']}"

    def bold(self, text):
        """Mark text as bold."""
        return f"**{text}**"

    def actions_block(self, action_id, actions):
        """Construct a block consisting of a set of action elements."""
        # Mattermost doesn't use the "block_id", but it ignores the input.
        # Leaving in place to pass the testing.
        return {"block_id": action_id, "actions": actions}

    # pylint: disable=no-self-use
    def _input_block(self, block_id, label, element):
        """Construct a block consisting of Input elements."""
        element["display_name"] = label
        element["action_id"] = block_id
        return element

    def markdown_block(self, text):
        """Construct a simple Markdown-formatted text block."""
        return {"text": self.markdown_element(text)}

    def image_element(self, url, alt_text=""):
        """Construct an image element that can be embedded in an attachment."""
        # Mattermost doesn't seem to use the alt_text for Image attachments.
        # Only inline markdown. Adding alt_text to the dictionary doesn't
        # Break anything though.
        return {"image_url": url, "alt_text": alt_text}

    def markdown_element(self, text):
        """Construct a basic Markdown-formatted text element."""
        return text

    def select_element(self, action_id, choices):
        """Construct a basic selection menu with the given choices.

        Args:
            action_id (str): Identifying string to associate with this element
            choices (list): List of (display, value) tuples

        Returns:
            dict: select element
        """
        # Definitely should be a mattermost bug, but "id" has to equal the
        # root of the "integration_url", since this should always be the same
        # I am hardcoding instead of trying to parse the url.
        data = {
            "id": "api",
            "type": "select",
            "integration": {
                "url": self.context.get("integration_url", ""),
                "context": {"action_id": action_id, "type": "static_select", "token": self.context.get("token", "")},
            },
            "name": self.text_element("Select an option"),
            "options": [{"text": self.text_element(choice), "value": value} for choice, value in choices],
        }

        return data

    def select_element_interactive(self, action_id, choices, default=(None, None), confirm=False):
        """Construct a basic selection menu for a dialog with the given choices.

        Args:
          action_id (str): Identifying string to associate with this element
          choices (list): List of (display, value) tuples
          default (tuple: Default (display, value) to preselect
          confirm (bool): If true (and the platform supports it), prompt the user to confirm their selection
        """
        default_text, default_value = default
        logger.info("Ignoring: select_element_interactive has no confirm: %s", confirm)
        data = {
            "type": "select",
            "name": action_id,
            "placeholder": self.text_element("Select an option"),
            "options": [{"text": self.text_element(choice), "value": value} for choice, value in choices],
        }

        if default_text and default_value:
            data["default"] = default_value

        return data

    def text_element(self, text):
        """Construct a basic plaintext element."""
        return text
