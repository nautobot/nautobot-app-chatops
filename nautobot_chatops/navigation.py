"""App additions to the Nautobot navigation menu."""

from nautobot.apps.ui import NavigationIconChoices, NavigationWeightChoices, NavMenuGroup, NavMenuItem, NavMenuTab

from nautobot_chatops.integrations.grafana.navigation import items as grafana_items

items = [
    NavMenuItem(
        link="plugins:nautobot_chatops:accessgrant_list",
        name="Access Grants",
        weight=100,
        permissions=["nautobot_chatops.view_accessgrant"],
    ),
    NavMenuItem(
        link="plugins:nautobot_chatops:chatopsaccountlink_list",
        name="Link ChatOps Account",
        weight=200,
        permissions=["nautobot_chatops.view_chatopsaccountlink"],
    ),
    NavMenuItem(
        link="plugins:nautobot_chatops:commandtoken_list",
        name="Command Tokens",
        weight=300,
        permissions=["nautobot_chatops.view_commandtoken"],
    ),
    NavMenuItem(
        link="plugins:nautobot_chatops:commandlog_list",
        name="Command Logs",
        weight=400,
        permissions=["nautobot_chatops.view_commandlog"],
    ),
    *grafana_items,
]

menu_items = (
    NavMenuTab(
        name="Apps",
        icon=NavigationIconChoices.APPS,
        weight=NavigationWeightChoices.APPS,
        groups=(NavMenuGroup(name="Nautobot ChatOps", weight=200, items=tuple(items)),),
    ),
)
