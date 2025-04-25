"""Tests for Nautobot views and related functionality."""

from unittest.mock import patch

from django.conf import settings
from django.test import TestCase
from django.test.client import RequestFactory
from nautobot.core.testing import ViewTestCases

from nautobot_chatops.api.views.mattermost import verify_signature as mattermost_verify_signature
from nautobot_chatops.api.views.slack import (
    generate_signature as slack_generate_signature,
)
from nautobot_chatops.api.views.slack import (
    verify_signature as slack_verify_signature,
)
from nautobot_chatops.api.views.webex import (
    generate_signature as webex_generate_signature,
)
from nautobot_chatops.api.views.webex import (
    verify_signature as webex_verify_signature,
)
from nautobot_chatops.choices import CommandStatusChoices, PlatformChoices
from nautobot_chatops.models import CommandLog, CommandToken


class TestSignatureVerification(TestCase):
    """Verify that message signing is correctly validated by each view."""

    model = models.CommandLog
    bulk_edit_data = {"description": "Bulk edit views"}
    form_data = {
        "name": "Test 1",
        "description": "Initial model",
    }

    update_data = {
        "name": "Test 2",
        "description": "Updated model",
    }

    @classmethod
    def setUp(cls):  # pylint: disable=invalid-name
        """Setup function for test class."""
        commandlog_a = CommandLog(
            start_time="2020-01-26T15:37:36",
            user_name="User 2",
            command="meraki",
            subcommand="get-organizations",
            params=["myorg_1"],
            status=CommandStatusChoices.STATUS_SUCCEEDED,
            runtime="00:00:05",
            user_id="998877",
            platform="Teams",
            platform_color="ffffff",
            details="This is for testing.",
        )
        commandlog_a.validated_save()
