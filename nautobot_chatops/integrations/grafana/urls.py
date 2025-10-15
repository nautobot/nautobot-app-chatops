"""Django urlpatterns declaration for nautobot_chatops.integrations.grafana app."""

from django.urls import path
from nautobot.apps.urls import NautobotUIViewSetRouter

from nautobot_chatops.integrations.grafana.views import (
    DashboardsBulkImportView,
    DashboardsSync,
    GrafanaDashboardUIViewSet,
    GrafanaPanelUIViewSet,
    GrafanaPanelVariableUIViewSet,
    PanelsBulkImportView,
    PanelsSync,
    VariablesBulkImportView,
    VariablesSync,
)

router = NautobotUIViewSetRouter()
router.register("grafana/dashboards", viewset=GrafanaDashboardUIViewSet)
router.register("grafana/panels", viewset=GrafanaPanelUIViewSet)
router.register("grafana/variables", viewset=GrafanaPanelVariableUIViewSet)

urlpatterns = router.urls

urlpatterns += [
    # Dashboard specific views.
    path("grafana/dashboards/sync/", DashboardsSync.as_view(), name="grafanadashboard_sync"),
    path("grafana/dashboards/import/", DashboardsBulkImportView.as_view(), name="grafanadashboard_import"),
    # Panel specific views.
    path("grafana/panels/sync/", PanelsSync.as_view(), name="grafanapanel_sync"),
    path("grafana/panels/import/", PanelsBulkImportView.as_view(), name="grafanapanel_import"),
    # Panel-variables specific views.
    path("grafana/variables/sync/", VariablesSync.as_view(), name="grafanapanelvariable_sync"),
    path("grafana/variables/import/", VariablesBulkImportView.as_view(), name="grafanapanelvariable_import"),
]

app_name = "nautobot_chatops"
