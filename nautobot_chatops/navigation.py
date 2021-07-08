"""Plugin additions to the Nautobot navigation menu."""
from nautobot.core.apps import NavMenuAddButton, NavMenuGroup, NavMenuItem, NavMenuImportButton, NavMenuTab
from nautobot.extras.plugins import PluginMenuItem, PluginMenuButton
from nautobot.utilities.choices import ButtonColorChoices

menu_items = (
    PluginMenuItem(
        link="plugins:nautobot_chatops:accessgrant_list",
        link_text="Access Grants",
        permissions=["nautobot_chatops.view_accessgrant"],
        buttons=(
            PluginMenuButton(
                link="plugins:nautobot_chatops:accessgrant_add",
                title="Add",
                icon_class="mdi mdi-plus-thick",
                color=ButtonColorChoices.GREEN,
                permissions=["nautobot_chatops.add_accessgrant"],
            ),
        ),
    ),
    PluginMenuItem(
        link="plugins:nautobot_chatops:commandtoken_list",
        link_text="Command Tokens",
        permissions=["nautobot_chatops.view_commandtoken"],
        buttons=(
            PluginMenuButton(
                link="plugins:nautobot_chatops:commandtoken_add",
                title="Add",
                icon_class="mdi mdi-plus-thick",
                color=ButtonColorChoices.GREEN,
                permissions=["nautobot_chatops.add_commandtoken"],
            ),
        ),
    ),
    PluginMenuItem(
        link="plugins:nautobot_chatops:home",
        link_text="Command Usage Records",
        permissions=["nautobot_chatops.view_commandlog"],
    ),
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
