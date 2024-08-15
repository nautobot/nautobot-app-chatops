"""ACI ChatOps Utilities."""

import logging
import re

from prettytable import PrettyTable

logger = logging.getLogger("nautobot")


def aci_logo(dispatcher):
    """Construct an image_element containing the locally hosted ACI logo."""
    return dispatcher.image_element(
        dispatcher.static_url("nautobot_plugin_chatops_aci/aci-transparent.png"), alt_text="Cisco ACI"
    )


def send_wait_msg(dispatcher):
    """Send a message indicating work in progress."""
    return dispatcher.send_markdown("Retrieving details, please wait...", ephemeral=True)


def send_logo(dispatcher, cmd, shortcut, args=None):
    """Display a logo and message in Slack."""
    output = ""
    if args:
        for arg in args:
            output += f"{dispatcher.bold(arg[0])}: {arg[1]}\n"
    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(
                "aci",
                shortcut,
                [],
                f"Cisco ACI `{cmd}`",
                aci_logo(dispatcher),
            ),
            dispatcher.markdown_block(output),
        ]
    )


def build_table(field_names, rows):
    """Create a table from a list of headers and row data."""
    table = PrettyTable()
    table.max_table_width = 120
    table.field_names = field_names
    for row in rows:
        table.add_row(row)
    return table


# pylint: disable-next=invalid-name
def tenant_from_dn(dn):
    """Match an ACI tenant in the Distiguished Name (DN)."""
    pattern = "tn-[A-Za-z0-9\-]+"  # noqa: W605  # pylint: disable=anomalous-backslash-in-string
    return re.search(pattern, dn).group().replace("tn-", "").rstrip("/")


# pylint: disable-next=invalid-name
def ap_from_dn(dn):
    """Match an ACI Application Profile in the Distinguished Name (DN)."""
    pattern = "ap-[A-Za-z0-9\-]+"  # noqa: W605 # pylint: disable=anomalous-backslash-in-string
    return re.search(pattern, dn).group().replace("ap-", "").rstrip("/")
