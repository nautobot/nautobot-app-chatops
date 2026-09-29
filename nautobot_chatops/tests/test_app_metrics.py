"""Test cases for application metrics endpoint views."""

import sys

from django.apps import apps
from django.test import TestCase
from nautobot.core.views import NautobotAppMetricsCollector
from nautobot.extras.registry import registry

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

    def test_metrics_registered_with_core(self):
        """Ensure the metric function is registered with Nautobot core."""
        self.assertIn(metric_commands, registry["app_metrics"])

    def test_core_collector_yields_command_library(self):
        """Ensure the core collector yields the command library metric."""
        collected = {metric.name: metric for metric in NautobotAppMetricsCollector().collect()}
        self.assertIn("nautobot_command_library", collected)
        commands = {sample.labels["command"] for sample in collected["nautobot_command_library"].samples}
        self.assertIn("nautobot", commands)

    def test_app_config_does_not_import_capacity_metrics(self):
        """Ensure the app does not import the capacity metrics app."""
        apps.get_app_config("nautobot_chatops")
        self.assertFalse("nautobot_capacity_metrics" in sys.modules)
