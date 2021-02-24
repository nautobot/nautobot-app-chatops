"""Test cases for application metrics endpoint views."""

from django.test import TestCase

from nautobot_chatops.metrics_app import metric_commands


class AppMetricTests(TestCase):
    """Test cases for ensuring application metric endpoint is working properly."""

    def test_metric_commands(self):
        """Ensure the metric_commands command is working properly."""
        commands = metric_commands()
        for command in commands:
            self.assertIsInstance(command.name, str)
            self.assertIsInstance(command.samples, list)
            self.assertIsNot(len(command.samples), 0)
