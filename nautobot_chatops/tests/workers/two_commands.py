"""Test file defining two commands and their subcommands (issue #20)."""

from django_rq import job
from nautobot_chatops.workers import subcommand_of, handle_subcommands


@job("default")
def first_command(subcommand, **kwargs):
    """My first command."""
    return handle_subcommands("first_command", subcommand, **kwargs)


@job("default")
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
