"""Tests for Nautobot dispatcher class implementations."""

from django.conf import settings
from django.test import TestCase

from nautobot_chatops.dispatchers.ms_teams import MSTeamsDispatcher
from nautobot_chatops.dispatchers.slack import SlackDispatcher
from nautobot_chatops.dispatchers.webex_teams import WebExTeamsDispatcher
from nautobot_chatops.dispatchers.mattermost import MattermostDispatcher


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


class TestMSTeamsDispatcher(TestSlackDispatcher):
    """Test the MSTeamsDispatcher class."""

    dispatcher_class = MSTeamsDispatcher
    platform_name = "Microsoft Teams"
    enable_opt_name = "enable_ms_teams"

    # Includes all of the test cases defined in TestSlackDispatcher, but uses MSTeamsDispatcher instead


class TestWebExTeamsDispatcher(TestSlackDispatcher):
    """Test the WebExTeamsDispatcher class."""

    dispatcher_class = WebExTeamsDispatcher
    platform_name = "WebEx Teams"
    enable_opt_name = "enable_webex_teams"

    # Includes all of the test cases defined in TestSlackDispatcher, but uses WebExTeamsDispatcher instead


class TestMattermostDispatcher(TestSlackDispatcher):
    """Test the MattermostDispatcher class."""

    dispatcher_class = MattermostDispatcher
    platform_name = "Mattermost"
    enable_opt_name = "enable_mattermost"

    # Includes all of the test cases defined in TestSlackDispatcher, but uses MattermostDispatcher instead
