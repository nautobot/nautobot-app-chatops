"""Test file defining a dynamic subcommand (issue #54)."""

from nautobot_chatops.workers import handle_subcommands, subcommand_of


def dynamic_command(subcommand, **kwargs):
    """My Dynamic command."""
    return handle_subcommands("dynamic_command", subcommand, **kwargs)


# pylint: disable=unused-argument
def dynamic_subcommand(dispatcher, *args):
    """Figure out what to do dynamically."""


def third_command(subcommand, **kwargs):
    """My third command."""
    return handle_subcommands("third_command", subcommand, **kwargs)


# pylint: disable=unused-argument
@subcommand_of("third_command")
def third_subcommand(dispatcher, *args):
    """Do the third thing of the third command."""
