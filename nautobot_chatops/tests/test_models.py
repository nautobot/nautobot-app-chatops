"""Tests for ChatOps models."""
import datetime
from django.test import TestCase
from nautobot_chatops.choices import CommandStatusChoices

from nautobot_chatops.models import CommandLog


class CommandLogTestCase(TestCase):
    """Test case for CommandLog model."""

    def test_to_csv(self):
        """Check that `to_csv` returns the correct data from the CommandLog model."""
        expected_data = (
            datetime.datetime(2020, 1, 26, 15, 37, 36),
            "User 1",
            "nautobot",
            "get-devices",
            ["mydevice_1"],
            "succeeded",
        )
        commandlog_a = CommandLog(
            start_time="2020-01-26T15:37:36",
            user_name="User 1",
            command="nautobot",
            subcommand="get-devices",
            params=["mydevice_1"],
            status=CommandStatusChoices.STATUS_SUCCEEDED,
            runtime="00:00:02",
            user_id="112233",
            platform="Slack",
            platform_color="ff0000",
            details="This is for testing.",
        )
        commandlog_a.validated_save()
        csv_data = commandlog_a.to_csv()
        self.assertEqual(expected_data, csv_data)
