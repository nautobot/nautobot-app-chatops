"""Plugin additions to the Nautobot navigation menu."""
from nautobot.core.apps import NavMenuAddButton, NavMenuGroup, NavMenuItem, NavMenuImportButton, NavMenuTab
from nautobot.extras.plugins import PluginMenuItem, PluginMenuButton
from nautobot.utilities.choices import ButtonColorChoices

menu_items = (
    NavMenuTab(
        name="ChatOps",
        weight=1200,
        groups=(
            NavMenuGroup(
                name="ChatOps",
                weight=100,
                items=(
                    NavMenuItem(
                        link="plugins:nautobot_chatops:accessgrant_list",
                        name="Access Grants",
                        permissions=["nautobot_chatops.view_commandtoken"],
                        buttons=(
                            NavMenuAddButton(
                                link="plugins:nautobot_chatops:accessgrant_add",
                                permissions=["nautobot_chatops.add_accessgrant"],
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
                        link="plugins:nautobot_chatops:home",
                        name="Command Usage Records",
                        permissions=["nautobot_chatops.view_commandlog"],
                    ),
                ),
            ),
        ),
    ),
)
