"""Testing tool for slack deployment."""

from django.core.management.base import BaseCommand
from texttable import Texttable

from nautobot_chatops.dispatchers.slack import SlackDispatcher


class Command(BaseCommand):
    """Testing Command for Slack."""

    def handle(self, *args, **kwargs):
        """This method provides a simple manage.py command to list slack channels."""
        dispatcher = SlackDispatcher()
        # conversation_list documentation https://api.slack.com/methods/conversations.list
        conversations = dispatcher.slack_client.conversations_list(types="public_channel, private_channel")

        table = Texttable(max_width=0)
        table.set_deco(Texttable.HEADER | Texttable.HLINES | Texttable.VLINES)

        header = [
            "id",
            "name",
            "is_channel",
            "is_group",
            "is_im",
            "created",
            "creator",
            "is_archived",
            "is_general",
            "unlinked",
            "name_normalized",
            "is_shared",
            "is_ext_shared",
            "is_org_shared",
            "pending_shared",
            "is_pending_ext_shared",
            "is_member",
            "is_private",
            "is_mpim",
            "num_members",
        ]

        table.header(header)
        # Force all columns to be shown as text. Otherwise long numbers (such as account #) get abbreviated as 123.4e10
        table.set_cols_dtype(["t" for item in header])

        rows = [
            (
                conversation["id"],
                conversation["name"],
                conversation["is_channel"],
                conversation["is_group"],
                conversation["is_im"],
                conversation["created"],
                conversation["creator"],
                conversation["is_archived"],
                conversation["is_general"],
                conversation["unlinked"],
                conversation["name_normalized"],
                conversation["is_shared"],
                conversation["is_ext_shared"],
                conversation["is_org_shared"],
                ", ".join(conversation["pending_shared"]),
                conversation["is_pending_ext_shared"],
                conversation["is_member"],
                conversation["is_private"],
                conversation["is_mpim"],
                conversation["num_members"],
            )
            for conversation in conversations["channels"]
        ]

        table.add_rows(rows, header=False)
        print(table.draw())
