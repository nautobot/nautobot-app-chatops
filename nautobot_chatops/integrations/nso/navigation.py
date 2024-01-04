"""Custom navigation options for the nautobot_chatops.integrations.nso plugin."""
from nautobot.apps.ui import NavMenuAddButton, NavMenuItem

items = [
    NavMenuItem(
        link="plugins:nautobot_chatops:commandfilter_list",
        permissions=["nautobot_chatops.view_commandfilter"],
        name="NSO Command Filter",
        buttons=(
            NavMenuAddButton(
                link="plugins:nautobot_chatops:commandfilter_add",
                permissions=["nautobot_chatops.add_commandfilter"],
            ),
        ),
    ),
]
