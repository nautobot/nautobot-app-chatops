"""Custom navigation options for the nautobot_plugin_chatops_nso plugin."""
from nautobot.core.apps import NavMenuTab, NavMenuGroup, NavMenuItem, NavMenuButton
from nautobot.utilities.choices import ButtonColorChoices

menu_items = (
    NavMenuTab(
        name="Plugins",
        groups=(
            NavMenuGroup(
                name="NSO ChatOps",
                weight=200,
                items=(
                    NavMenuItem(
                        link="plugins:nautobot_plugin_chatops_nso:commandfilter_list",
                        name="Command Filters",
                        permissions=[
                            "nautobot_plugin_chatops_nso.view_commandfilter",
                        ],
                        buttons=(
                            NavMenuButton(
                                link="plugins:nautobot_plugin_chatops_nso:commandfilter_add",
                                title="Command Filter",
                                icon_class="mdi mdi-plus-thick",
                                button_class=ButtonColorChoices.GREEN,
                                permissions=[
                                    "nautobot_plugin_chatops_nso.add_commandfilter",
                                ],
                            ),
                        ),
                    ),
                    NavMenuItem(
                        link="plugins:nautobot_plugin_chatops_nso:nso_page",
                        name="NSO Instance Link",
                        permissions=[],
                        buttons=(),
                    ),
                ),
            ),
        ),
    ),
)
