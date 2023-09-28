"""Plugin additions to the Nautobot navigation menu."""

from nautobot.apps.config import get_app_settings_or_config
from nautobot.apps.ui import NavMenuAddButton, NavMenuGroup, NavMenuItem, NavMenuTab

if get_app_settings_or_config("nautobot_chatops", "enable_grafana"):
    from .integrations.grafana.navigation import items as grafana_items
else:
    grafana_items = ()


items = [
    NavMenuItem(
        link="plugins:nautobot_chatops:accessgrant_list",
        name="Access Grants",
        permissions=["nautobot_chatops.view_accessgrant"],
        buttons=(
            NavMenuAddButton(
                link="plugins:nautobot_chatops:accessgrant_add",
                permissions=["nautobot_chatops.add_accessgrant"],
            ),
        ),
    ),
    NavMenuItem(
        link="plugins:nautobot_chatops:chatopsaccountlink_list",
        name="Link ChatOps Account",
        permissions=["nautobot_chatops.view_chatopsaccountlink"],
        buttons=(
            NavMenuAddButton(
                link="plugins:nautobot_chatops:chatopsaccountlink_add",
                permissions=["nautobot_chatops.add_chatopsaccountlink"],
            ),
        ),
    ),
    NavMenuItem(
        link="plugins:nautobot_chatops:commandtoken_list",
        name="Command Tokens",
        permissions=["nautobot_chatops.view_commandtoken"],
        buttons=(
            NavMenuAddButton(
                link="plugins:nautobot_chatops:commandtoken_add",
                permissions=["nautobot_chatops.add_commandtoken"],
            ),
        ),
    ),
    NavMenuItem(
        link="plugins:nautobot_chatops:commandlog_list",
        name="Command Usage Records",
        permissions=["nautobot_chatops.view_commandlog"],
    ),
    *grafana_items,
]

menu_items = (
    NavMenuTab(
        name="Plugins",
        groups=(NavMenuGroup(name="Nautobot ChatOps", items=tuple(items)),),
    ),
)
