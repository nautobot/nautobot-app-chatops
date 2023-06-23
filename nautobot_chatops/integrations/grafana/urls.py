"""Django urlpatterns declaration for nautobot_chatops.integrations.grafana plugin."""
from django.urls import path
from nautobot.extras.views import ObjectChangeLogView
from nautobot_chatops.integrations.grafana.models import Dashboard, PanelVariable, Panel
from nautobot_chatops.integrations.grafana.views import (
    Dashboards,
    DashboardsCreate,
    DashboardsDelete,
    DashboardsEdit,
    DashboardsSync,
    DashboardsBulkImportView,
    DashboardsBulkDeleteView,
    DashboardBulkEditView,
    Panels,
    PanelsCreate,
    PanelsEdit,
    PanelsSync,
    PanelsDelete,
    PanelsBulkImportView,
    PanelsBulkDeleteView,
    PanelsBulkEditView,
    Variables,
    VariablesCreate,
    VariablesSync,
    VariablesEdit,
    VariablesDelete,
    VariablesBulkImportView,
    VariablesBulkDeleteView,
    VariablesBulkEditView,
)

urlpatterns = [
    # Dashboard specific views.
    path("grafana/dashboards/", Dashboards.as_view(), name="grafanadashboards"),
    path(
        "dashboards/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="grafanadashboard_changelog",
        kwargs={"model": Dashboard},
    ),
    path("grafana/dashboards/add/", DashboardsCreate.as_view(), name="grafanadashboard_add"),
    path("grafana/dashboards/sync/", DashboardsSync.as_view(), name="grafanadashboard_sync"),
    path("grafana/dashboards/<uuid:pk>/edit/", DashboardsEdit.as_view(), name="grafanadashboard_edit"),
    path("grafana/dashboards/edit/", DashboardBulkEditView.as_view(), name="grafanadashboard_bulk_edit"),
    path("grafana/dashboards/<uuid:pk>/delete/", DashboardsDelete.as_view(), name="grafanadashboard_delete"),
    path("grafana/dashboards/delete/", DashboardsBulkDeleteView.as_view(), name="grafanadashboard_bulk_delete"),
    path("grafana/dashboards/import/", DashboardsBulkImportView.as_view(), name="grafanadashboard_import"),
    # Panel specific views.
    path("grafana/panels/", Panels.as_view(), name="grafanapanel"),
    path(
        "panels/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="grafanapanel_changelog",
        kwargs={"model": Panel},
    ),
    path("grafana/panels/add/", PanelsCreate.as_view(), name="grafanapanel_add"),
    path("grafana/panels/sync/", PanelsSync.as_view(), name="grafanapanel_sync"),
    path("grafana/panels/<uuid:pk>/edit/", PanelsEdit.as_view(), name="grafanapanel_edit"),
    path("grafana/panels/edit/", PanelsBulkEditView.as_view(), name="grafanapanel_bulk_edit"),
    path("grafana/panels/<uuid:pk>/delete/", PanelsDelete.as_view(), name="grafanapanel_delete"),
    path("grafana/panels/delete/", PanelsBulkDeleteView.as_view(), name="grafanapanel_bulk_delete"),
    path("grafana/panels/import/", PanelsBulkImportView.as_view(), name="grafanapanel_import"),
    # Panel-variables specific views.
    path("grafana/variables/", Variables.as_view(), name="grafanapanelvariables"),
    path(
        "variables/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="grafanapanelvariable_changelog",
        kwargs={"model": PanelVariable},
    ),
    path("grafana/variables/add/", VariablesCreate.as_view(), name="grafanapanelvariable_add"),
    path("grafana/variables/sync/", VariablesSync.as_view(), name="grafanapanelvariable_sync"),
    path("grafana/variables/<uuid:pk>/edit/", VariablesEdit.as_view(), name="grafanapanelvariable_edit"),
    path("grafana/variables/edit/", VariablesBulkEditView.as_view(), name="grafanapanelvariable_bulk_edit"),
    path("grafana/variables/<uuid:pk>/delete/", VariablesDelete.as_view(), name="grafanapanelvariable_delete"),
    path("grafana/variables/delete/", VariablesBulkDeleteView.as_view(), name="grafanapanelvariable_bulk_delete"),
    path("grafana/variables/import/", VariablesBulkImportView.as_view(), name="grafanapanelvariable_import"),
]
