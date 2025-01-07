"""Unit tests for nautobot_chatops."""

from nautobot.apps.testing import APIViewTestCases

from nautobot_chatops import models
from nautobot_chatops.tests import fixtures


class CommandLogAPIViewTest(APIViewTestCases.APIViewTestCase):
    # pylint: disable=too-many-ancestors
    """Test the API viewsets for CommandLog."""

    model = models.CommandLog
    create_data = [
        {
            "name": "Test Model 1",
            "description": "test description",
        },
        {
            "name": "Test Model 2",
        },
    ]
    bulk_update_data = {"description": "Test Bulk Update"}

    @classmethod
    def setUpTestData(cls):
        fixtures.create_commandlog()
