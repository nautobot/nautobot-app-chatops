"""Navigation for Circuit Maintenance."""

from nautobot.apps.ui import NavMenuAddButton, NavMenuItem

items = [
    NavMenuItem(
        link="plugins:nautobot_chatops:grafanadashboard_list",
        permissions=["nautobot_chatops.dashboards_read"],
        name="Grafana Dashboards",
        buttons=(
            NavMenuAddButton(
                link="plugins:nautobot_chatops:grafanadashboard_add",
                permissions=["nautobot_chatops.dashboard_add"],
            ),
        ),
    ),
    NavMenuItem(
        link="plugins:nautobot_chatops:grafanapanel_list",
        permissions=["nautobot_chatops.panel_read"],
        name="Grafana Panels",
        buttons=(
            NavMenuAddButton(
                link="plugins:nautobot_chatops:grafanapanel_add",
                permissions=["nautobot_chatops.panel_add"],
            ),
        ),
    ),
    NavMenuItem(
        link="plugins:nautobot_chatops:grafanapanelvariable_list",
        permissions=["nautobot_chatops.panelvariables_read"],
        name="Grafana Variables",
        buttons=(
            NavMenuAddButton(
                link="plugins:nautobot_chatops:grafanapanelvariable_add",
                permissions=["nautobot_chatops.panelvariable_add"],
            ),
        ),
    ),
]
