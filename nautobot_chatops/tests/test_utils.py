"""Tests for Nautobot utility functions."""

from unittest.mock import patch

from django.test import TestCase

from nautobot_chatops.choices import AccessGrantTypeChoices
from nautobot_chatops.models import AccessGrant
from nautobot_chatops.utils import check_and_enqueue_command


class MockDispatcher:
    """Mock version of the Dispatcher interface."""

    error = None

    platform_slug = "mock"
    platform_name = "mock"
    platform_color = "FF00FF"

    def __init__(self, context, *args, **kwargs):
        """Instantiate a MockDispatcher."""
        self.context = context

    @classmethod
    def reset(cls):
        """Reset the class to baseline (no recorded error)."""
        cls.error = None
        return cls

    @classmethod
    def send_error(cls, message):
        """Record an error message."""
        cls.error = message


def nada():
    """No-op function for testing purposes."""


@patch("nautobot_chatops.utils.get_queue")
class TestCheckAndEnqueue(TestCase):
    """Verify that access grants are correctly implemented."""

    mock_registry = {
        "x": {"function": nada, "subcommands": {}},
        "y": {"function": nada, "subcommands": {}},
        "z": {"function": nada, "subcommands": {}},
    }

    def test_default_deny(self, mock_get_queue):
        """With no AccessGrants in the database, all requests are denied by default."""
        mock_get_queue.reset_mock()
        check_and_enqueue_command(
            self.mock_registry,
            "x",
            "y",
            [],
            {"org_id": "11", "channel_id": "111", "user_id": "1111"},
            MockDispatcher.reset(),
        )
        self.assertEqual(
            MockDispatcher.error,
            "Access to this bot and/or command is not permitted in organization 11, "
            "ask your Nautobot administrator to define an appropriate Access Grant",
        )
        mock_get_queue.assert_not_called()

        # Add an organization access grant
        AccessGrant.objects.create(
            command="*",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_ORGANIZATION,
            name="org1",
            value="11",
        )
        mock_get_queue.reset_mock()
        check_and_enqueue_command(
            self.mock_registry,
            "x",
            "y",
            [],
            {"org_id": "11", "channel_id": "111", "user_id": "1111"},
            MockDispatcher.reset(),
        )
        self.assertEqual(
            MockDispatcher.error,
            "Access to this bot and/or command is not permitted in channel 111, "
            "ask your Nautobot administrator to define an appropriate Access Grant",
        )
        mock_get_queue.assert_not_called()

        # Add a channel access grant
        AccessGrant.objects.create(
            command="*",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_CHANNEL,
            name="channel1",
            value="111",
        )
        mock_get_queue.reset_mock()
        check_and_enqueue_command(
            self.mock_registry,
            "x",
            "y",
            [],
            {"org_id": "11", "channel_id": "111", "user_id": "1111"},
            MockDispatcher.reset(),
        )
        self.assertEqual(
            MockDispatcher.error,
            "Access to this bot and/or command is not permitted by user 1111, "
            "ask your Nautobot administrator to define an appropriate Access Grant",
        )
        mock_get_queue.assert_not_called()

        # Add a user access grant - now things should be permitted
        AccessGrant.objects.create(
            command="*",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_USER,
            name="user1",
            value="1111",
        )
        mock_get_queue.reset_mock()
        check_and_enqueue_command(
            self.mock_registry,
            "x",
            "y",
            [],
            {"org_id": "11", "channel_id": "111", "user_id": "1111"},
            MockDispatcher.reset(),
        )
        self.assertIsNone(MockDispatcher.error)
        mock_get_queue.assert_called_once()

    # pylint: disable=no-self-use
    def setup_db(self):
        """Per-testcase database population for most test cases."""
        # Create some globally applicable access grants:
        AccessGrant.objects.create(
            command="*",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_ORGANIZATION,
            name="org1",
            value="11",
        )
        AccessGrant.objects.create(
            command="*",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_CHANNEL,
            name="channel1",
            value="111",
        )
        AccessGrant.objects.create(
            command="*",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_USER,
            name="user1",
            value="1111",
        )
        # And some per-command access grants:
        AccessGrant.objects.create(
            command="x",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_ORGANIZATION,
            name="org2",
            value="22",
        )
        AccessGrant.objects.create(
            command="x",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_CHANNEL,
            name="channel2",
            value="222",
        )
        AccessGrant.objects.create(
            command="x",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_USER,
            name="user2",
            value="2222",
        )
        # And some per-subcommand access grants:
        AccessGrant.objects.create(
            command="x",
            subcommand="a",
            grant_type=AccessGrantTypeChoices.TYPE_ORGANIZATION,
            name="org3",
            value="33",
        )
        AccessGrant.objects.create(
            command="x",
            subcommand="a",
            grant_type=AccessGrantTypeChoices.TYPE_CHANNEL,
            name="channel3",
            value="333",
        )
        AccessGrant.objects.create(
            command="x",
            subcommand="a",
            grant_type=AccessGrantTypeChoices.TYPE_USER,
            name="user3",
            value="3333",
        )
        # And some wildcard access grants:
        AccessGrant.objects.create(
            command="y",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_ORGANIZATION,
            name="any",
            value="*",
        )
        AccessGrant.objects.create(
            command="y",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_CHANNEL,
            name="any",
            value="*",
        )
        AccessGrant.objects.create(
            command="y",
            subcommand="*",
            grant_type=AccessGrantTypeChoices.TYPE_USER,
            name="any",
            value="*",
        )

    def test_permitted_globally(self, mock_get_queue):
        """A global access grant applies to all commands and subcommands."""
        self.setup_db()
        # user1/channel1/org1 are globally permitted
        for cmd, subcmd in [("x", "a"), ("x", "b"), ("y", "a"), ("z", "a")]:
            mock_get_queue.reset_mock()
            check_and_enqueue_command(
                self.mock_registry,
                cmd,
                subcmd,
                [],
                {"org_id": "11", "channel_id": "111", "user_id": "1111"},
                MockDispatcher.reset(),
            )
            self.assertIsNone(MockDispatcher.error)
            mock_get_queue.assert_called_once()

    def test_permitted_command(self, mock_get_queue):
        """A per-command access grant applies to all subcommands under the command, and no others."""
        self.setup_db()
        # user2/channel2/org2 are explicitly permitted to subcommands of command "x"
        # all users/channels/orgs are permitted to subcommands of command "y"
        for cmd, subcmd in [("x", "a"), ("x", "b"), ("y", "a")]:
            mock_get_queue.reset_mock()
            check_and_enqueue_command(
                self.mock_registry,
                cmd,
                subcmd,
                [],
                {"org_id": "22", "channel_id": "222", "user_id": "2222"},
                MockDispatcher.reset(),
            )
            self.assertIsNone(MockDispatcher.error)
            mock_get_queue.assert_called_once()
        for cmd, subcmd in [("z", "a")]:
            mock_get_queue.reset_mock()
            check_and_enqueue_command(
                self.mock_registry,
                cmd,
                subcmd,
                [],
                {"org_id": "22", "channel_id": "222", "user_id": "2222"},
                MockDispatcher.reset(),
            )
            self.assertEqual(
                MockDispatcher.error,
                "Access to this bot and/or command is not permitted in organization 22, "
                "ask your Nautobot administrator to define an appropriate Access Grant",
            )
            mock_get_queue.assert_not_called()

    def test_permitted_subcommand(self, mock_get_queue):
        """A per-subcommand access grant applies that subcommands under that command, and no others."""
        self.setup_db()
        # user3/channel3/org3 are only permitted to subcommand "a" of command "x"
        # all users/channels/orgs are permitted to subcommands of command "y"
        # 3rd and 4th use cases are for verifying that the help commands will execute
        for cmd, subcmd in [("x", "a"), ("y", "a"), ("x", ""), ("y", "")]:
            mock_get_queue.reset_mock()
            check_and_enqueue_command(
                self.mock_registry,
                cmd,
                subcmd,
                [],
                {"org_id": "33", "channel_id": "333", "user_id": "3333"},
                MockDispatcher.reset(),
            )
            self.assertIsNone(MockDispatcher.error)
            mock_get_queue.assert_called_once()

        for cmd, subcmd in [("x", "b"), ("z", "a"), ("z", "")]:
            mock_get_queue.reset_mock()
            check_and_enqueue_command(
                self.mock_registry,
                cmd,
                subcmd,
                [],
                {"org_id": "33", "channel_id": "333", "user_id": "3333"},
                MockDispatcher.reset(),
            )
            self.assertEqual(
                MockDispatcher.error,
                "Access to this bot and/or command is not permitted in organization 33, "
                "ask your Nautobot administrator to define an appropriate Access Grant",
            )
            mock_get_queue.assert_not_called()

    def test_not_permitted_user(self, mock_get_queue):
        """Per-user access grants are checked."""
        self.setup_db()
        for cmd, subcmd in [("x", "a"), ("x", "b"), ("z", "a")]:
            mock_get_queue.reset_mock()
            check_and_enqueue_command(
                self.mock_registry,
                cmd,
                subcmd,
                [],
                {"org_id": "11", "channel_id": "111", "user_id": "9999"},
                MockDispatcher.reset(),
            )
            self.assertEqual(
                MockDispatcher.error,
                "Access to this bot and/or command is not permitted by user 9999, "
                "ask your Nautobot administrator to define an appropriate Access Grant",
            )
            mock_get_queue.assert_not_called()

    def test_not_permitted_channel(self, mock_get_queue):
        """Per-channel access grants are checked."""
        self.setup_db()
        for cmd, subcmd in [("x", "a"), ("x", "b"), ("z", "a")]:
            mock_get_queue.reset_mock()
            check_and_enqueue_command(
                self.mock_registry,
                cmd,
                subcmd,
                [],
                {"org_id": "11", "channel_id": "999", "user_id": "1111"},
                MockDispatcher.reset(),
            )
            self.assertEqual(
                MockDispatcher.error,
                "Access to this bot and/or command is not permitted in channel 999, "
                "ask your Nautobot administrator to define an appropriate Access Grant",
            )
            mock_get_queue.assert_not_called()

    def test_not_permitted_organization(self, mock_get_queue):
        """Per-organization access grants are checked."""
        self.setup_db()
        for cmd, subcmd in [("x", "a"), ("x", "b"), ("z", "a")]:
            mock_get_queue.reset_mock()
            check_and_enqueue_command(
                self.mock_registry,
                cmd,
                subcmd,
                [],
                {"org_id": "99", "channel_id": "111", "user_id": "1111"},
                MockDispatcher.reset(),
            )
            self.assertEqual(
                MockDispatcher.error,
                "Access to this bot and/or command is not permitted in organization 99, "
                "ask your Nautobot administrator to define an appropriate Access Grant",
            )
            mock_get_queue.assert_not_called()
