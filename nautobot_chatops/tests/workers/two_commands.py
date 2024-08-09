"""Test file defining two commands and their subcommands (issue #20)."""

from nautobot_chatops.workers import handle_subcommands, subcommand_of


def first_command(subcommand, **kwargs):
    """My first command."""
    return handle_subcommands("first_command", subcommand, **kwargs)


def second_command(subcommand, **kwargs):
    """My second command."""
    return handle_subcommands("second_command", subcommand, **kwargs)


# pylint: disable=unused-argument
@subcommand_of("first_command")
def first_subcommand(dispatcher, *args):
    """Do the first thing of the first command."""


# pylint: disable=unused-argument
@subcommand_of("second_command")
def second_subcommand(dispatcher, *args):
    """Do the second thing of the second command."""
