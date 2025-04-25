"""Unit tests for views."""

from nautobot.apps.testing import ViewTestCases

from nautobot_chatops import models
from nautobot_chatops.tests import fixtures


class CommandLogViewTest(ViewTestCases.PrimaryObjectViewTestCase):
    # pylint: disable=too-many-ancestors
    """Test the CommandLog views."""

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
    def setUpTestData(cls):
        fixtures.create_commandlog()
