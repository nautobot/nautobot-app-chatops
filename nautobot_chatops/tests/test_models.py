"""Test CommandLog."""

from nautobot.apps.testing import ModelTestCases

from nautobot_chatops import models
from nautobot_chatops.tests import fixtures


class TestCommandLog(ModelTestCases.BaseModelTestCase):
    """Test CommandLog."""

    model = models.CommandLog

    @classmethod
    def setUpTestData(cls):
        """Create test data for CommandLog Model."""
        super().setUpTestData()
        # Create 3 objects for the model test cases.
        fixtures.create_commandlog()

    def test_create_commandlog_only_required(self):
        """Create with only required fields, and validate null description and __str__."""
        commandlog = models.CommandLog.objects.create(name="Development")
        self.assertEqual(commandlog.name, "Development")
        self.assertEqual(commandlog.description, "")
        self.assertEqual(str(commandlog), "Development")

    def test_create_commandlog_all_fields_success(self):
        """Create CommandLog with all fields."""
        commandlog = models.CommandLog.objects.create(name="Development", description="Development Test")
        self.assertEqual(commandlog.name, "Development")
        self.assertEqual(commandlog.description, "Development Test")
