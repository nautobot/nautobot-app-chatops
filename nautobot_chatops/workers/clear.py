"""Simple worker function for "clearing" the chat screen by sending a block of blank text."""

from datetime import datetime, timezone

from nautobot.extras.context_managers import web_request_context

from nautobot_chatops.choices import CommandStatusChoices
from nautobot_chatops.dispatchers.slack import SlackDispatcher
from nautobot_chatops.utils import create_command_log
from nautobot_chatops.workers import get_commands_registry


# pylint: disable=unused-argument
def clear(subcommand, params, dispatcher_class=None, context=None, **kwargs):
    """Scroll the chat history out of view."""
    # This command is somewhat unique as it doesn't have any subcommands or parameters.
    # Hence we don't use the usual handle_subcommands() / subcommand_of() functions used in more complex workers.
    dispatcher = dispatcher_class(context=context)

    # Choosing not to allow the clear function within SlackThreads.
    if dispatcher_class is SlackDispatcher and context.get("thread_ts"):
        dispatcher.send_markdown("Clear not supported within threads", ephemeral=True)
        return CommandStatusChoices.STATUS_SUCCEEDED
    command_log = create_command_log(dispatcher, get_commands_registry(), "clear", subcommand)

    # 1) Markdown ignores single newlines, you need two consecutive ones to get a rendered newline
    # 2) If you have more than two consecutive newlines, they get collapsed together, so we need something between them
    # 3) The below is using " " (Unicode NO-BREAK SPACE) rather than an ordinary " " (space)
    dispatcher.send_markdown("Clearing..." + " \n\n" * 50 + "...Cleared!", ephemeral=True)

    command_log.runtime = datetime.now(timezone.utc) - command_log.start_time
    with web_request_context(dispatcher.user):
        command_log.save()

    return CommandStatusChoices.STATUS_SUCCEEDED
