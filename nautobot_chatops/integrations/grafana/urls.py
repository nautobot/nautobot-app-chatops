"""Django urlpatterns declaration for nautobot_chatops.integrations.grafana app."""

from django.urls import path
from nautobot.apps.urls import NautobotUIViewSetRouter

from nautobot_chatops.integrations.grafana.views import (
    DashboardsSync,
    GrafanaDashboardUIViewSet,
    GrafanaPanelUIViewSet,
    GrafanaPanelVariableUIViewSet,
    PanelsSync,
    VariablesSync,
)

router = NautobotUIViewSetRouter()
router.register("grafana/dashboards", viewset=GrafanaDashboardUIViewSet)
router.register("grafana/panels", viewset=GrafanaPanelUIViewSet)
router.register("grafana/variables", viewset=GrafanaPanelVariableUIViewSet)

urlpatterns = [
    # Dashboard specific views.
    path("grafana/dashboards/sync/", DashboardsSync.as_view(), name="grafanadashboard_sync"),
    # Panel specific views.
    path("grafana/panels/sync/", PanelsSync.as_view(), name="grafanapanel_sync"),
    # Panel-variables specific views.
    path("grafana/variables/sync/", VariablesSync.as_view(), name="grafanapanelvariable_sync"),
] + router.urls

app_name = "nautobot_chatops"
