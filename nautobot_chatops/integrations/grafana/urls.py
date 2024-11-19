"""Django urlpatterns declaration for nautobot_chatops.integrations.grafana app."""

from django.urls import path
from nautobot.extras.views import ObjectChangeLogView

from nautobot_chatops.integrations.grafana.models import GrafanaDashboard, GrafanaPanel, GrafanaPanelVariable
from nautobot_chatops.integrations.grafana.views import (
    DashboardBulkEditView,
    Dashboards,
    DashboardsBulkDeleteView,
    DashboardsBulkImportView,
    DashboardsCreate,
    DashboardsDelete,
    DashboardsEdit,
    DashboardsSync,
    Panels,
    PanelsBulkDeleteView,
    PanelsBulkEditView,
    PanelsBulkImportView,
    PanelsCreate,
    PanelsDelete,
    PanelsEdit,
    PanelsSync,
    Variables,
    VariablesBulkDeleteView,
    VariablesBulkEditView,
    VariablesBulkImportView,
    VariablesCreate,
    VariablesDelete,
    VariablesEdit,
    VariablesSync,
)

urlpatterns = [
    # Dashboard specific views.
    path("grafana/dashboards/", Dashboards.as_view(), name="grafanadashboard_list"),
    path(
        "dashboards/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="grafanadashboard_changelog",
        kwargs={"model": GrafanaDashboard},
    ),
    path("grafana/dashboards/add/", DashboardsCreate.as_view(), name="grafanadashboard_add"),
    path("grafana/dashboards/sync/", DashboardsSync.as_view(), name="grafanadashboard_sync"),
    path("grafana/dashboards/<uuid:pk>/edit/", DashboardsEdit.as_view(), name="grafanadashboard_edit"),
    path("grafana/dashboards/edit/", DashboardBulkEditView.as_view(), name="grafanadashboard_bulk_edit"),
    path("grafana/dashboards/<uuid:pk>/delete/", DashboardsDelete.as_view(), name="grafanadashboard_delete"),
    path("grafana/dashboards/delete/", DashboardsBulkDeleteView.as_view(), name="grafanadashboard_bulk_delete"),
    path("grafana/dashboards/import/", DashboardsBulkImportView.as_view(), name="grafanadashboard_import"),
    # Panel specific views.
    path("grafana/panels/", Panels.as_view(), name="grafanapanel_list"),
    path(
        "panels/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="grafanapanel_changelog",
        kwargs={"model": GrafanaPanel},
    ),
    path("grafana/panels/add/", PanelsCreate.as_view(), name="grafanapanel_add"),
    path("grafana/panels/sync/", PanelsSync.as_view(), name="grafanapanel_sync"),
    path("grafana/panels/<uuid:pk>/edit/", PanelsEdit.as_view(), name="grafanapanel_edit"),
    path("grafana/panels/edit/", PanelsBulkEditView.as_view(), name="grafanapanel_bulk_edit"),
    path("grafana/panels/<uuid:pk>/delete/", PanelsDelete.as_view(), name="grafanapanel_delete"),
    path("grafana/panels/delete/", PanelsBulkDeleteView.as_view(), name="grafanapanel_bulk_delete"),
    path("grafana/panels/import/", PanelsBulkImportView.as_view(), name="grafanapanel_import"),
    # Panel-variables specific views.
    path("grafana/variables/", Variables.as_view(), name="grafanapanelvariable_list"),
    path(
        "variables/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="grafanapanelvariable_changelog",
        kwargs={"model": GrafanaPanelVariable},
    ),
    path("grafana/variables/add/", VariablesCreate.as_view(), name="grafanapanelvariable_add"),
    path("grafana/variables/sync/", VariablesSync.as_view(), name="grafanapanelvariable_sync"),
    path("grafana/variables/<uuid:pk>/edit/", VariablesEdit.as_view(), name="grafanapanelvariable_edit"),
    path("grafana/variables/edit/", VariablesBulkEditView.as_view(), name="grafanapanelvariable_bulk_edit"),
    path("grafana/variables/<uuid:pk>/delete/", VariablesDelete.as_view(), name="grafanapanelvariable_delete"),
    path("grafana/variables/delete/", VariablesBulkDeleteView.as_view(), name="grafanapanelvariable_bulk_delete"),
    path("grafana/variables/import/", VariablesBulkImportView.as_view(), name="grafanapanelvariable_import"),
]
