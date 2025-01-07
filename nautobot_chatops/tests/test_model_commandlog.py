"""Test CommandLog."""

from django.test import TestCase

from nautobot_chatops import models


class TestCommandLog(TestCase):
    """Test CommandLog."""

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
