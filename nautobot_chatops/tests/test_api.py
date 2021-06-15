"""Test cases for Nautobot Chatops API."""

from django.urls import reverse

from nautobot.utilities.testing import APITestCase, APIViewTestCases
from nautobot_chatops.models import CommandToken


class AppTest(APITestCase):  # pylint: disable=too-many-ancestors
    """Test cases for the Nautobot_chatops App."""

    def test_root(self):
        """Validate the root for Nautobot Chatops API."""
        url = reverse("plugins-api:nautobot_chatops-api:api-root")
        response = self.client.get("{}?format=api".format(url), **self.header)

        self.assertEqual(response.status_code, 200)


class CommandTokenTest(APIViewTestCases.APIViewTestCase):  # pylint: disable=too-many-ancestors
    """Tests for the CommandToken Endpoint."""

    model = CommandToken
    brief_fields = ["comment", "display", "id", "platform", "token"]
    create_data = [
        {"comment": "Test 4", "platform": "mattermost", "token": "token4"},
        {"comment": "Test 5", "platform": "mattermost", "token": "token5"},
        {"comment": "Test 6", "platform": "mattermost", "token": "token6"},
    ]
    bulk_update_data = {"comment": "Testing"}

    @classmethod
    def setUpTestData(cls):
        """Generate test data for the CommandToken Endpoint."""
        CommandToken.objects.create(comment="Test 1", platform="mattermost", token="token1")
        CommandToken.objects.create(comment="Test 2", platform="mattermost", token="token2")
        CommandToken.objects.create(comment="Test 3", platform="mattermost", token="token3")
