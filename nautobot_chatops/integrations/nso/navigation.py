"""Custom navigation options for the nautobot_chatops.integrations.nso plugin."""
from nautobot.apps.ui import NavMenuAddButton, NavMenuItem

items = [
    NavMenuItem(
        link="plugins:nautobot_chatops:nsocommandfilter_list",
        permissions=["nautobot_chatops.view_nsocommandfilter"],
        name="NSO Command Filter",
        buttons=(
            NavMenuAddButton(
                link="plugins:nautobot_chatops:nsocommandfilter_add",
                permissions=["nautobot_chatops.add_nsocommandfilter"],
            ),
        ),
    ),
]
