"""Plugin additions to the Nautobot navigation menu."""

from django.conf import settings
from nautobot.extras.plugins import PluginMenuItem, PluginMenuButton
from nautobot.utilities.choices import ButtonColorChoices

if settings.PLUGINS_CONFIG["nautobot_chatops"]["enable_grafana"]:
    from .integrations.grafana.navigation import menu_items as grafana_menu_items
else:
    grafana_menu_items = ()

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
    *grafana_menu_items,
)
