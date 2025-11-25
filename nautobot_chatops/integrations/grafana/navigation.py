"""Navigation for Circuit Maintenance."""

from nautobot.apps.ui import NavMenuItem

items = [
    NavMenuItem(
        link="plugins:nautobot_chatops:grafanadashboard_list",
        permissions=["nautobot_chatops.dashboards_read"],
        name="Grafana Dashboards",
        weight=500,
    ),
    NavMenuItem(
        link="plugins:nautobot_chatops:grafanapanel_list",
        permissions=["nautobot_chatops.panel_read"],
        name="Grafana Panels",
        weight=600,
    ),
    NavMenuItem(
        link="plugins:nautobot_chatops:grafanapanelvariable_list",
        permissions=["nautobot_chatops.panelvariables_read"],
        name="Grafana Variables",
        weight=700,
    ),
]
