"""Test file defining a dynamic subcommand (issue #54)."""

from django_rq import job
from nautobot_chatops.workers import subcommand_of, handle_subcommands


@job("default")
def dynamic_command(subcommand, **kwargs):
    """My Dynamic command."""
    return handle_subcommands("dynamic_command", subcommand, **kwargs)


# pylint: disable=unused-argument
def dynamic_subcommand(dispatcher, *args):
    """Figure out what to do dynamically."""


@job("default")
def third_command(subcommand, **kwargs):
    """My third command."""
    return handle_subcommands("third_command", subcommand, **kwargs)


# pylint: disable=unused-argument
@subcommand_of("third_command")
def third_subcommand(dispatcher, *args):
    """Do the third thing of the third command."""
