"""Navigation for Circuit Maintenance."""
from nautobot.extras.plugins import PluginMenuItem, PluginMenuButton, ButtonColorChoices

menu_items = (
    PluginMenuItem(
        link="plugins:nautobot_chatops:grafanadashboards",
        permissions=["nautobot_chatops.dashboards_read"],
        link_text="Grafana Dashboards",
        buttons=(
            PluginMenuButton(
                link="plugins:nautobot_chatops:grafanadashboard_add",
                title="Add",
                icon_class="mdi mdi-plus-thick",
                color=ButtonColorChoices.GREEN,
                permissions=["nautobot_chatops.dashboard_add"],
            ),
        ),
    ),
    PluginMenuItem(
        link="plugins:nautobot_chatops:grafanapanel",
        permissions=["nautobot_chatops.panel_read"],
        link_text="Grafana Panels",
        buttons=(
            PluginMenuButton(
                link="plugins:nautobot_chatops:grafanapanel_add",
                title="Add",
                icon_class="mdi mdi-plus-thick",
                color=ButtonColorChoices.GREEN,
                permissions=["nautobot_chatops.panel_add"],
            ),
        ),
    ),
    PluginMenuItem(
        link="plugins:nautobot_chatops:grafanapanelvariables",
        permissions=["nautobot_chatops.panelvariables_read"],
        link_text="Grafana Variables",
        buttons=(
            PluginMenuButton(
                link="plugins:nautobot_chatops:grafanapanelvariable_add",
                title="Add",
                icon_class="mdi mdi-plus-thick",
                color=ButtonColorChoices.GREEN,
                permissions=["nautobot_chatops.panelvariable_add"],
            ),
        ),
    ),
)
