"""Menu items."""

from nautobot.apps.ui import NavMenuAddButton, NavMenuGroup, NavMenuItem, NavMenuTab

items = (
    NavMenuItem(
        link="plugins:nautobot_chatops:commandlog_list",
        name="Nautobot ChatOps App",
        permissions=["nautobot_chatops.view_commandlog"],
        buttons=(
            NavMenuAddButton(
                link="plugins:nautobot_chatops:commandlog_add",
                permissions=["nautobot_chatops.add_commandlog"],
            ),
        ),
    ),
)

menu_items = (
    NavMenuTab(
        name="Apps",
        groups=(NavMenuGroup(name="Nautobot ChatOps App", items=tuple(items)),),
    ),
)
