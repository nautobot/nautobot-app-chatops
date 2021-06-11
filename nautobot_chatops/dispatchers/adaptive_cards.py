"""Dispatcher subclass for chat platforms that use Adaptive Cards (https://adaptivecards.io/)."""

from .base import Dispatcher

# pylint: disable=abstract-method


class AdaptiveCardsDispatcher(Dispatcher):
    """Semi-abstract class for chat platforms that use Adaptive Cards for presentation."""

    def command_response_header(self, command, subcommand, args, description="information", image_element=None):
        """Construct a consistently forwarded header including the command that was issued.

        Args:
          command (str): Primary command string
          subcommand (str): Secondary command string
          args (list): of tuples, either (arg_name, human_readable_value, literal_value) or (arg_name, literal_value)
          description (str): Short description of what information is contained in the response
          image_element (dict): As constructed by self.image_element()
        """
        header = [
            {
                "type": "ColumnSet",
                "columns": [
                    {
                        "type": "Column",
                        "width": "stretch",
                        "items": [
                            self.markdown_element(
                                f"Hey {self.user_mention()}, here is that {description} you requested\n\n"
                                f'Shortcut: "{command} {subcommand} {" ".join(arg[-1] for arg in args)}"',
                            ),
                        ],
                    },
                    {
                        "type": "Column",
                        "width": "80px",  # magic number, trying to make it look similar to Slack's "accessory" icon
                        "items": [image_element],
                    },
                ],
            },
        ]

        if args:
            header[0]["columns"][0]["items"].append(
                {
                    "type": "FactSet",
                    "facts": [{"title": first, "value": second} for first, second, *_ in args],
                }
            )

        return header

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
        callback_id = f"{command} {sub_command}"
        blocks = []
        for i, dialog in enumerate(dialog_list):
            if dialog["type"] == "select":
                menu = self.select_element(
                    f"param_{i}",
                    dialog["choices"],
                    default=dialog.get("default", (None, None)),
                    confirm=dialog.get("confirm", False),
                )
                blocks.append(self.text_element(dialog["label"]))
                blocks.append(menu)
            elif dialog["type"] == "text":
                textentry = {
                    "type": "Input.Text",
                    "id": f"param_{i}",
                    "placeholder": dialog["label"],
                    "value": dialog.get("default", None),
                }
                blocks.append(self.text_element(dialog["label"]))
                blocks.append(textentry)
        buttons = {
            "type": "ActionSet",
            "id": "action",
            "actions": [
                {"type": "Action.Submit", "title": "Submit", "data": {"action": callback_id}},
                {"type": "Action.Submit", "title": "Cancel", "data": {"action": "cancel"}},
            ],
        }
        blocks.append(buttons)
        return self.send_blocks(blocks, callback_id=callback_id, modal=True, ephemeral=False, title=dialog_title)

    def send_warning(self, message):
        """Send a warning message to the user/channel specified by the context."""
        self.send_blocks([{"type": "TextBlock", "text": message, "wrap": True, "color": "warning"}])

    def send_error(self, message):
        """Send an error message to the user/channel specified by the context."""
        self.send_blocks([{"type": "TextBlock", "text": message, "wrap": True, "color": "attention"}])

    def prompt_for_text(self, action_id, help_text, label, title="Your attention please!"):
        """Prompt the user to enter freeform text into a field.

        Args:
          action_id (str): Identifier string to attach to the "submit" action.
          help_text (str): Markdown string to display as help text.
          label (str): Label text to display adjacent to the text field.
          title (str): Title to include on the modal dialog.
        """
        textentry = {"type": "Input.Text", "id": "param_0", "label": label}
        buttons = {
            "type": "ActionSet",
            "id": "action",
            "actions": [
                {"type": "Action.Submit", "title": "Submit", "data": {"action": action_id}},
                {"type": "Action.Submit", "title": "Cancel", "data": {"action": "cancel"}},
            ],
        }

        blocks = [self.markdown_block(help_text), self.actions_block("TODO", [textentry, buttons])]
        return self.send_blocks(blocks, ephemeral=True, title=title)

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
        menu = self.select_element("param_0", choices, default=default, confirm=confirm)
        buttons = {
            "type": "ActionSet",
            "id": "action",
            "actions": [
                {"type": "Action.Submit", "title": "Submit", "data": {"action": action_id}},
                {"type": "Action.Submit", "title": "Cancel", "data": {"action": "cancel"}},
            ],
        }

        blocks = [self.markdown_block(help_text), self.actions_block("TODO", [menu, buttons])]
        return self.send_blocks(blocks, ephemeral=True)

    def actions_block(self, block_id, actions):
        """Construct a block consisting of a set of action elements."""
        # We don't use the ActionSet type as that only supports a small set of actions
        return {"type": "Container", "id": block_id, "items": actions}

    def markdown_block(self, text):
        """Construct a simple Markdown-formatted text block."""
        return {"type": "TextBlock", "text": text, "wrap": True}

    def image_element(self, url, alt_text=""):
        """Construct an image element that can be embedded in a block."""
        return {"type": "Image", "url": url, "altText": alt_text}

    def markdown_element(self, text):
        """Construct a simple Markdown-formatted text element."""
        return {"type": "TextBlock", "text": text, "wrap": True}

    def select_element(self, action_id, choices, default=(None, None), confirm=False):
        """Construct a basic selection menu with the given choices.

        Args:
          action_id (str): Identifying string to associate with this element
          choices (list): List of (display, value) tuples
          default (tuple: Default (display, value) to preselect
          confirm (bool): If true (and the platform supports it), prompt the user to confirm their selection
        """
        return {
            "type": "Input.ChoiceSet",
            "id": action_id,
            "style": "compact",
            "isMultiSelect": False,
            "value": default[1],
            "choices": [{"title": title, "value": value} for title, value in choices],
        }

    def text_element(self, text):
        """Construct a simple plaintext element."""
        return {"type": "TextBlock", "text": text, "wrap": True}
