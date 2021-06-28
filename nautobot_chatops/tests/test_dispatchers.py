"""Tests for Nautobot dispatcher class implementations."""
from unittest.mock import patch

from django.conf import settings
from django.test import TestCase
from slack_sdk.errors import SlackApiError

from nautobot_chatops.dispatchers.ms_teams import MSTeamsDispatcher
from nautobot_chatops.dispatchers.slack import SlackDispatcher
from nautobot_chatops.dispatchers.webex import WebExDispatcher
from nautobot_chatops.dispatchers.mattermost import MattermostDispatcher


# pylint: disable=unnecessary-pass


class TestSlackDispatcher(TestCase):
    """Test the SlackDispatcher class."""

    dispatcher_class = SlackDispatcher
    platform_name = "Slack"
    enable_opt_name = "enable_slack"

    def setUp(self):
        """Per-test-case setup function."""
        settings.PLUGINS_CONFIG["nautobot_chatops"][self.enable_opt_name] = True
        self.dispatcher = self.dispatcher_class(
            context={"user_name": "Glenn", "user_id": "abc123", "channel_id": "456def"}
        )

    def test_platform_name(self):
        """Make sure the platform name is properly defined for this dispatcher."""
        self.assertEqual(self.dispatcher_class.platform_name, self.platform_name)

    def test_command_response_header(self):
        """Make sure the generated header includes all appropriate content."""
        header = self.dispatcher.command_response_header("commandname", "sub-command", [("arg", "value")])
        header_str = str(header)
        self.assertIn("commandname", header_str)
        self.assertIn("sub-command", header_str)
        self.assertIn("arg", header_str)
        self.assertIn("value", header_str)
        self.assertIn(self.dispatcher.user_mention(), header_str)

    def test_actions_block(self):
        """Make sure actions_block() is implemented."""
        block = self.dispatcher.actions_block("block_id", [])
        self.assertNotEqual(block, None)
        self.assertIn("block_id", str(block))

    def test_markdown_block(self):
        """Make sure markdown_block() is implemented."""
        block = self.dispatcher.markdown_block("hello world!")
        self.assertNotEqual(block, None)
        self.assertIn("hello world!", str(block))

    def test_image_element(self):
        """Make sure image_element() is implemented."""
        element = self.dispatcher.image_element("http://example.com", alt_text="image")
        self.assertNotEqual(element, None)
        self.assertIn("http://example.com", str(element))

    def test_markdown_element(self):
        """Make sure markdown_element() is implemented."""
        element = self.dispatcher.markdown_element("hello world!")
        self.assertNotEqual(element, None)
        self.assertIn("hello world!", str(element))

    def test_select_element(self):
        """Make sure select_element() is implemented."""
        element = self.dispatcher.select_element("action_id", [("1st", "first"), ("2nd", "second")])
        self.assertNotEqual(element, None)
        self.assertIn("action_id", str(element))
        self.assertIn("first", str(element))
        self.assertIn("second", str(element))

    def test_text_element(self):
        """Make sure text_element() is implemented."""
        element = self.dispatcher.text_element("hello world!")
        self.assertNotEqual(element, None)
        self.assertIn("hello world!", str(element))

    def test_prompt_from_menu_error(self):
        """Make sure prompt_from_menu() errors out properly."""
        with self.assertRaises(SlackApiError):
            self.dispatcher.prompt_from_menu("action_id", "help_text", [])

    def test_get_prompt_from_menu_choices(self):
        """Make sure get_prompt_from_menu_choices() is implemented."""
        choices = [("switch01", "switch01"), ("switch02", "switch02"), ("switch03", "switch03")]

        response = self.dispatcher.get_prompt_from_menu_choices(choices)
        self.assertEqual(response, choices)

        choices = list()
        for i in range(1, 101):
            choices.append((f"switch{i}", f"switch{i}"))
        response = self.dispatcher.get_prompt_from_menu_choices(choices)
        self.assertEqual(response, choices)

        choices = list()
        for i in range(1, 511):
            choices.append((f"switch{i}", f"switch{i}"))

        expected_choices = choices[:99]
        expected_choices.append(("Next...", "menu_offset-99"))
        response = self.dispatcher.get_prompt_from_menu_choices(choices)
        self.assertEqual(response, expected_choices)

        expected_choices = choices[99:198]
        expected_choices.append(("Next...", "menu_offset-198"))
        response = self.dispatcher.get_prompt_from_menu_choices(choices, offset=99)
        self.assertEqual(response, expected_choices)

        expected_choices = choices[363:462]
        expected_choices.append(("Next...", "menu_offset-462"))
        response = self.dispatcher.get_prompt_from_menu_choices(choices, offset=363)
        self.assertEqual(response, expected_choices)

        expected_choices = choices[500:]
        response = self.dispatcher.get_prompt_from_menu_choices(choices, offset=500)
        self.assertEqual(response, expected_choices)

    def test_send_snippet_no_title(self):
        """Make sure files_upload is called with no title."""
        with patch.object(self.dispatcher.slack_client, "files_upload") as mocked_files_upload:
            self.dispatcher.send_snippet("Testing files upload.")
            mocked_files_upload.assert_called_with(channels="456def", content="Testing files upload.", title=None)

    def test_send_snippet_title(self):
        """Make sure files_upload is called with title."""
        with patch.object(self.dispatcher.slack_client, "files_upload") as mocked_files_upload:
            self.dispatcher.send_snippet("Testing files upload.", "Testing files upload title.")
            mocked_files_upload.assert_called_with(
                channels="456def", content="Testing files upload.", title="Testing files upload title."
            )


class TestMSTeamsDispatcher(TestSlackDispatcher):
    """Test the MSTeamsDispatcher class."""

    dispatcher_class = MSTeamsDispatcher
    platform_name = "Microsoft Teams"
    enable_opt_name = "enable_ms_teams"

    # Includes all of the test cases defined in TestSlackDispatcher, but uses MSTeamsDispatcher instead

    def test_prompt_from_menu_error(self):
        """Not implemented."""
        pass

    def test_get_prompt_from_menu_choices(self):
        """Not implemented."""
        pass

    def test_send_snippet_no_title(self):
        """Not implemented."""
        # pylint: disable W0221
        pass

    def test_send_snippet_title(self):
        """Not implemented."""
        # pylint: disable W0221
        pass


class TestWebExDispatcher(TestSlackDispatcher):
    """Test the WebExDispatcher class."""

    dispatcher_class = WebExDispatcher
    platform_name = "WebEx"
    enable_opt_name = "enable_webex"

    # Includes all of the test cases defined in TestSlackDispatcher, but uses WebExDispatcher instead

    def test_prompt_from_menu_error(self):
        """Not implemented."""
        pass

    def test_get_prompt_from_menu_choices(self):
        """Not implemented."""
        pass

    def test_send_snippet_no_title(self):
        """Not implemented."""
        pass

    def test_send_snippet_title(self):
        """Not implemented."""
        pass

    @patch("nautobot_chatops.dispatchers.webex.WebExDispatcher.send_markdown")
    def test_send_large_table(self, mock_send_markdown):
        """Make sure send_large_table() is implemented."""
        header = ["Name", "Status", "Tenant", "Site", "Rack", "Role", "Type", "IP Address"]
        rows = []
        expected_arg0 = "```\n"

        for i in range(0, 300):
            rows.append((f"Switch0{i}", "Active", "", "test01", "", "role01", "3560", "1.2.3.4"))
            if i >= 298:
                expected_arg0 += f"Switch0{i}   Active            test01          role01   3560   1.2.3.4   \n"
        expected_arg0 += "\n```"

        self.dispatcher.send_large_table(header, rows)

        # Make sure the outputs include proper formatting for WebEx
        self.assertTrue(mock_send_markdown.called)
        self.assertEqual(mock_send_markdown.call_args[0][0], expected_arg0)

        total_message_length = 0
        # Make sure no individual call exceeded the Webex message length limit
        for call_args in mock_send_markdown.call_args_list:
            # pylint: disable=no-member
            self.assertLessEqual(len(call_args[0][0]), self.dispatcher.webex_msg_char_limit)
            total_message_length += len(call_args[0][0])

        # Make sure the total message length was in excess of the Webex limit
        # pylint: disable=no-member
        self.assertGreater(total_message_length, self.dispatcher.webex_msg_char_limit)

        # Make sure content was appropriately divided amongst the separate messages:
        # Header should only be in the first call, not in subsequent ones
        self.assertIn("Tenant ", mock_send_markdown.call_args_list[0][0][0])
        for call_args in mock_send_markdown.call_args_list[1:]:
            self.assertNotIn("Tenant ", call_args[0][0])

        # Make sure the first row appears in the first send, and the last row appears in the last send
        self.assertIn("Switch00 ", mock_send_markdown.call_args_list[0][0][0])
        self.assertIn("Switch0299 ", mock_send_markdown.call_args_list[-1][0][0])


class TestMattermostDispatcher(TestSlackDispatcher):
    """Test the MattermostDispatcher class."""

    dispatcher_class = MattermostDispatcher
    platform_name = "Mattermost"
    enable_opt_name = "enable_mattermost"

    # Includes all of the test cases defined in TestSlackDispatcher, but uses MattermostDispatcher instead

    def test_prompt_from_menu_error(self):
        """Not implemented."""
        pass

    def test_get_prompt_from_menu_choices(self):
        """Not implemented."""
        pass

    def test_send_snippet_no_title(self):
        """Not implemented."""
        # pylint: disable W0221
        pass

    def test_send_snippet_title(self):
        """Not implemented."""
        # pylint: disable W0221
        pass
