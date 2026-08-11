"""Test cases for the Nautobot workers module."""

from django.test import SimpleTestCase

import nautobot_chatops.workers
from nautobot_chatops.tests.workers import dynamic_commands, two_commands
from nautobot_chatops.workers import add_subcommand, convert_smart_quotes, get_commands_registry, parse_command_string


def _load_test_commands():
    """Load test command modules directly."""
    # Register the command functions
    add_subcommand(
        command_name="first_command",
        command_func=two_commands.first_command,
        subcommand_name="first-subcommand",
        subcommand_spec={
            "worker": two_commands.first_subcommand,
            "params": [],
            "doc": "Do the first thing of the first command.",
        },
    )

    add_subcommand(
        command_name="second_command",
        command_func=two_commands.second_command,
        subcommand_name="second-subcommand",
        subcommand_spec={
            "worker": two_commands.second_subcommand,
            "params": [],
            "doc": "Do the second thing of the second command.",
        },
    )

    add_subcommand(
        command_name="third_command",
        command_func=dynamic_commands.third_command,
        subcommand_name="third-subcommand",
        subcommand_spec={
            "worker": dynamic_commands.third_subcommand,
            "params": [],
            "doc": "Do the third thing of the third command.",
        },
    )

    add_subcommand(
        command_name="dynamic_command",
        command_func=dynamic_commands.dynamic_command,
        subcommand_name="dynamic-subcommand-name",
        subcommand_spec={
            "worker": dynamic_commands.dynamic_subcommand,
            "params": ["param1", "param2"],
            "doc": "Do Something Dynamically",
        },
    )


class TestFunctions(SimpleTestCase):
    """Test the generic functions provided by nautobot_chatops.workers."""

    def setUp(self):
        """Cleanup commands registry."""
        # Due to testing with multiple entry points with multiple tests we must reinitialize
        # the command registry.  This will produce warnings but will not happen in production.
        nautobot_chatops.workers._registry_initialized = False  # pylint: disable=protected-access

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
            ("command sub-command arg1", "command", "sub-command", ["arg1"]),
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
            ("command sub-command ar'g1", "command", "sub-command", ["ar'g1"]),
            ('command sub-command arg1 arg"2', "command", "sub-command", ["arg1", 'arg"2']),
        ):
            command, subcommand, params = parse_command_string(string)
            self.assertEqual(command, exp_cmd)
            self.assertEqual(subcommand, exp_sub)
            self.assertEqual(params, exp_params)

    def test_get_commands_registry_multiple_same_file(self):
        """Verify that a single file can contain multiple command workers and their subcommands."""
        _load_test_commands()
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
        _load_test_commands()
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
        self.assertTrue(callable(registry["dynamic_command"]["subcommands"]["dynamic-subcommand-name"]["worker"]))

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

    def test_convert_smart_quotes(self):
        """Verify Convert Smart Quotes."""
        self.assertEqual(convert_smart_quotes("''"), "''")
        self.assertEqual(convert_smart_quotes(""), "")
        self.assertEqual(convert_smart_quotes("\u201c\u201d"), "''")
        self.assertEqual(convert_smart_quotes("\u2018\u2019"), "''")
        self.assertEqual(convert_smart_quotes("\u201c"), "'")
        self.assertEqual(convert_smart_quotes("\u201d"), "'")
        self.assertEqual(convert_smart_quotes("\u2018"), "'")
        self.assertEqual(convert_smart_quotes("\u2019"), "'")
        self.assertEqual(convert_smart_quotes("\u201cLas Vegas\u201d"), "'Las Vegas'")
        self.assertEqual(convert_smart_quotes("\u2018Las Vegas\u2019"), "'Las Vegas'")
