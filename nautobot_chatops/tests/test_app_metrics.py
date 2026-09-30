"""Test cases for application metrics endpoint views."""

import sys
from unittest import mock

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
        self.assertNotIn("nautobot_capacity_metrics", sys.modules)

    def test_app_features_list_command_library(self):
        """Ensure the app features list the command library metric."""
        features = apps.get_app_config("nautobot_chatops").features
        self.assertIn("nautobot_command_library", features["metrics"])

    @mock.patch("nautobot_chatops.workers.get_commands_registry", return_value={})
    def test_metric_commands_empty_registry(self, _):
        """Ensure an empty command registry yields a metric with no samples."""
        collected = list(metric_commands())
        self.assertEqual(len(collected), 1)
        self.assertEqual(collected[0].name, "nautobot_command_library")
        self.assertEqual(collected[0].samples, [])
