"""Test cases for the Nautobot workers module."""

from django.test import TestCase
from prybar import dynamic_entrypoint

import nautobot_chatops.workers
from nautobot_chatops.integrations.grafana.models import Dashboard, Panel
from nautobot_chatops.integrations.grafana.worker import initialize_subcommands
from nautobot_chatops.tests.workers.dynamic_commands import dynamic_command, dynamic_subcommand
from nautobot_chatops.workers import add_subcommand, get_commands_registry, parse_command_string


class TestGrafana(TestCase):
    """Test the generic functions provided by nautobot_chatops.workers."""

    def setUp(self):
        """Cleanup commands registry."""
        # Due to testing with multiple entry points with multiple tests we must reinitialize
        # the command registry.  This will produce warnings but will not happen in production.
        nautobot_chatops.workers._registry_initialized = False  # pylint: disable=protected-access

        # Create a mock dashboard in the test database so we can test command generation.
        test_dashboard = Dashboard.objects.create(
            dashboard_slug="test-dashboard", dashboard_uid="7Wkldj8Q", friendly_name="Test Dashboard"
        )

        # Generate a few commands (panels) to populate the test database with some slash commands.
        for i in range(0, 5):
            Panel.objects.create(
                dashboard=test_dashboard,
                command_name=f"test-command-{i}",
                friendly_name=f"Test Command {i}",
                panel_id=i,
                active=True,
            )

    def test_parse_command_string(self):
        """Verify that various inputs to parse_command_string() are handled correctly."""
        for string, exp_cmd, exp_sub, exp_params in (
            ("", "", "", []),
            ("   ", "", "", []),
            ("command", "command", "", []),
            ("command   ", "command", "", []),
            ("   command   ", "command", "", []),
            ("command sub-command", "command", "sub-command", []),
            ("command-sub-command", "command", "sub-command", []),
            ("command   sub-command", "command", "sub-command", []),
            ("   command   sub-command   ", "command", "sub-command", []),
            ("command sub-command arg1 arg2", "command", "sub-command", ["arg1", "arg2"]),
            ("command  sub-command  arg1   arg2", "command", "sub-command", ["arg1", "arg2"]),
            ("   command  sub-command  arg1   arg2   ", "command", "sub-command", ["arg1", "arg2"]),
            ("command sub-command arg1 arg2 arg3", "command", "sub-command", ["arg1", "arg2", "arg3"]),
            ("   command sub-command   arg1   arg2   arg3", "command", "sub-command", ["arg1", "arg2", "arg3"]),
            (
                "command sub-command 'Las Vegas' 'Dallas' Orlando",
                "command",
                "sub-command",
                ["Las Vegas", "Dallas", "Orlando"],
            ),
        ):
            command, subcommand, params = parse_command_string(string)
            self.assertEqual(command, exp_cmd)
            self.assertEqual(subcommand, exp_sub)
            self.assertEqual(params, exp_params)

    def test_get_commands_registry_multiple_same_file(self):
        """Verify that a single file can contain multiple command workers and their subcommands."""
        with dynamic_entrypoint(
            "nautobot.workers", name="first_command", module="nautobot_chatops.tests.workers.two_commands"
        ):
            with dynamic_entrypoint(
                "nautobot.workers", name="second_command", module="nautobot_chatops.tests.workers.two_commands"
            ):
                registry = get_commands_registry()

                # Make sure both commands and both subcommands were loaded

                self.assertIn("first_command", registry)
                self.assertIn("function", registry["first_command"])
                self.assertTrue(callable(registry["first_command"]["function"]))
                self.assertIn("subcommands", registry["first_command"])
                self.assertIn("first-subcommand", registry["first_command"]["subcommands"])
                self.assertIn("worker", registry["first_command"]["subcommands"]["first-subcommand"])
                self.assertTrue(callable(registry["first_command"]["subcommands"]["first-subcommand"]["worker"]))

                self.assertIn("second_command", registry)
                self.assertIn("function", registry["second_command"])
                self.assertTrue(callable(registry["second_command"]["function"]))
                self.assertIn("subcommands", registry["second_command"])
                self.assertIn("second-subcommand", registry["second_command"]["subcommands"])
                self.assertIn("worker", registry["second_command"]["subcommands"]["second-subcommand"])
                self.assertTrue(callable(registry["second_command"]["subcommands"]["second-subcommand"]["worker"]))

    def test_get_commands_registry_dynamic_subcommands(self):
        """Verify Dynamic Commands."""
        with dynamic_entrypoint(
            "nautobot.workers", name="dynamic_command", module="nautobot_chatops.tests.workers.dynamic_commands"
        ):
            with dynamic_entrypoint(
                "nautobot.workers", name="third_command", module="nautobot_chatops.tests.workers.dynamic_commands"
            ):
                subcommand_spec = {
                    "worker": dynamic_subcommand,
                    "params": ["param1", "param2"],
                    "doc": "Do Something Dynamically",
                }
                add_subcommand(
                    command_name="dynamic_command",
                    command_func=dynamic_command,
                    subcommand_name="dynamic-subcommand-name",
                    subcommand_spec=subcommand_spec,
                )

                registry = get_commands_registry()

                # Make sure the dynamic command is loaded

                self.assertIn("dynamic_command", registry)
                self.assertIn("function", registry["dynamic_command"])
                self.assertTrue(callable(registry["dynamic_command"]["function"]))
                self.assertIn("subcommands", registry["dynamic_command"])
                self.assertIn("dynamic-subcommand-name", registry["dynamic_command"]["subcommands"])
                self.assertIn("worker", registry["dynamic_command"]["subcommands"]["dynamic-subcommand-name"])
                self.assertIn("param1", registry["dynamic_command"]["subcommands"]["dynamic-subcommand-name"]["params"])
                self.assertIn("param2", registry["dynamic_command"]["subcommands"]["dynamic-subcommand-name"]["params"])
                self.assertTrue(
                    callable(registry["dynamic_command"]["subcommands"]["dynamic-subcommand-name"]["worker"])
                )

                # Make sure the static command is also loaded

                self.assertIn("third_command", registry)
                self.assertIn("function", registry["third_command"])
                self.assertTrue(callable(registry["third_command"]["function"]))
                self.assertIn("subcommands", registry["third_command"])
                self.assertIn("third-subcommand", registry["third_command"]["subcommands"])
                self.assertIn("worker", registry["third_command"]["subcommands"]["third-subcommand"])
                self.assertTrue(callable(registry["third_command"]["subcommands"]["third-subcommand"]["worker"]))

                # Make sure the default nautobot command is still loaded

                self.assertIn("nautobot", registry)

    def test_grafana_commands_registry_dynamic_subcommands(self):
        """Specific testing for the Grafana Chatops App."""
        with dynamic_entrypoint("nautobot.workers", name="grafana", module="nautobot_chatops.grafana.worker"):
            registry = get_commands_registry()

            # Populate the command registry with the dynamic Grafana commands.
            initialize_subcommands()

            self.assertIn("grafana", registry)

            # Make sure there is a top-level callable function
            self.assertIn("function", registry["grafana"])
            self.assertTrue(callable(registry["grafana"]["function"]))

            # Test that subcommands are being dynamically generated and have a callable function
            self.assertIn("subcommands", registry["grafana"])
            self.assertIn("get-test-command-1", registry["grafana"]["subcommands"])
            self.assertIn("worker", registry["grafana"]["subcommands"]["get-test-command-1"])
            self.assertIn("timespan", str(registry["grafana"]["subcommands"]["get-test-command-1"]["params"]))
            self.assertTrue(callable(registry["grafana"]["subcommands"]["get-test-command-1"]["worker"]))
