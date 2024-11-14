"""Views module for the nautobot_chatops.integrations.grafana App.

The views implemented in this module act as endpoints for various chat platforms
to send requests and notifications to.
"""

import logging

from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.shortcuts import redirect, render, reverse
from django.template.response import TemplateResponse
from nautobot.apps.config import get_app_settings_or_config
from nautobot.core.forms import ConfirmationForm
from nautobot.core.views.generic import (
    BulkDeleteView,
    BulkEditView,
    BulkImportView,
    ObjectDeleteView,
    ObjectEditView,
    ObjectListView,
)

from nautobot_chatops.integrations.grafana.filters import DashboardFilter, PanelFilter, VariableFilter
from nautobot_chatops.integrations.grafana.forms import (
    DashboardBulkEditForm,
    DashboardsFilterForm,
    DashboardsForm,
    PanelsBulkEditForm,
    PanelsFilterForm,
    PanelsForm,
    PanelsSyncForm,
    PanelVariablesBulkEditForm,
    PanelVariablesFilterForm,
    PanelVariablesForm,
    PanelVariablesSyncForm,
)
from nautobot_chatops.integrations.grafana.models import GrafanaDashboard, GrafanaPanel, GrafanaPanelVariable
from nautobot_chatops.integrations.grafana.tables import (
    GrafanaDashboardTable,
    GrafanaPanelTable,
    GrafanaPanelVariableTable,
)

logger = logging.getLogger(__name__)


try:
    from nautobot_chatops.integrations.grafana.diffsync.sync import (
        run_dashboard_sync,
        run_panels_sync,
        run_variables_sync,
    )
    from nautobot_chatops.integrations.grafana.grafana import handler

    GRAFANA_DEPENDENCIES_INSTALLED = True
    GRAFANA_DEPENDENCIES_EXCEPTION = None
except ImportError as exc:
    logger.warning("Grafana integration dependencies are missing. Grafana views will be disabled.")
    GRAFANA_DEPENDENCIES_INSTALLED = False
    GRAFANA_DEPENDENCIES_EXCEPTION = exc


# -------------------------------------------------------------------------------------
# Dashboard Specific Views
# -------------------------------------------------------------------------------------


class GrafanaViewMixin(LoginRequiredMixin):
    """View mixin for Grafana views to toggle views based on constance setting."""

    def dispatch(self, request, *args, **kwargs):
        """Dispatch method for Grafana views."""
        if not request.user.is_authenticated:
            return self.handle_no_permission()
        if not get_app_settings_or_config("nautobot_chatops", "enable_grafana"):
            return TemplateResponse(
                request=self.request,
                template="nautobot_chatops_grafana/grafana_disabled.html",
                context={},
            )
        if not GRAFANA_DEPENDENCIES_INSTALLED:
            logger.error("Grafana integration dependencies are missing. Grafana views will be disabled.")
            raise GRAFANA_DEPENDENCIES_EXCEPTION
        return super().dispatch(request, *args, **kwargs)


class Dashboards(GrafanaViewMixin, ObjectListView):
    """View for showing dashboard configuration."""

    queryset = GrafanaDashboard.objects.all()
    filterset = DashboardFilter
    filterset_form = DashboardsFilterForm
    table = GrafanaDashboardTable
    action_buttons = ("add", "import")
    template_name = "nautobot_chatops_grafana/dashboard_list.html"

    def get_required_permission(self):
        """Return required view permission."""
        return "nautobot_chatops.dashboard_read"


class DashboardsCreate(GrafanaViewMixin, PermissionRequiredMixin, ObjectEditView):
    """View for creating a new Dashboard."""

    permission_required = "nautobot_chatops.dashboard_add"
    model = GrafanaDashboard
    queryset = GrafanaDashboard.objects.all()
    model_form = DashboardsForm
    default_return_url = "plugins:nautobot_chatops:grafanadashboard_list"


class DashboardsEdit(DashboardsCreate):
    """View for editing an existing Dashboard."""

    permission_required = "nautobot_chatops.dashboard_edit"


class DashboardsSync(GrafanaViewMixin, PermissionRequiredMixin, ObjectDeleteView):
    """View for syncing Grafana Dashboards with the Grafana API."""

    permission_required = "nautobot_chatops.dashboard_sync"
    default_return_url = "plugins:nautobot_chatops:grafanadashboard_list"

    def get(self, request, **kwargs):
        """Get request for the Dashboard Sync view."""
        return render(
            request,
            "nautobot_chatops_grafana/sync_confirmation.html",
            {
                "form": ConfirmationForm(initial=request.GET),
                "grafana_url": handler.config.grafana_url,
                "return_url": reverse("plugins:nautobot_chatops:grafanadashboard_list"),
            },
        )

    def post(self, request, **kwargs):
        """Post request for the Dashboard Sync view."""
        form = ConfirmationForm(request.POST)

        if not form.is_valid():
            messages.error(request, "Form validation failed.")

        else:
            sync_data = run_dashboard_sync(request.POST.get("delete") == "true")
            if not sync_data:
                messages.info(request, "No diffs found for the Grafana Dashboards!")
            else:
                messages.success(request, "Grafana Dashboards synchronization complete!")

        return redirect(reverse("plugins:nautobot_chatops:grafanadashboard_list"))


class DashboardsDelete(GrafanaViewMixin, PermissionRequiredMixin, ObjectDeleteView):
    """View for deleting one or more Dashboard records."""

    queryset = GrafanaDashboard.objects.all()
    permission_required = "nautobot_chatops.dashboard_delete"
    default_return_url = "plugins:nautobot_chatops:grafanadashboard_list"


class DashboardsBulkImportView(GrafanaViewMixin, BulkImportView):
    """View for bulk import of eox notices."""

    queryset = GrafanaDashboard.objects.all()
    table = GrafanaDashboardTable
    default_return_url = "plugins:nautobot_chatops:grafanadashboard_list"


class DashboardsBulkDeleteView(GrafanaViewMixin, BulkDeleteView):
    """View for deleting one or more Dashboard records."""

    queryset = GrafanaDashboard.objects.all()
    table = GrafanaDashboardTable
    bulk_delete_url = "plugins:nautobot_chatops:grafanadashboard_bulk_delete"
    default_return_url = "plugins:nautobot_chatops:grafanadashboard_list"

    def get_required_permission(self):
        """Return required delete permission."""
        return "nautobot_chatops.dashboard_delete"


class DashboardBulkEditView(GrafanaViewMixin, BulkEditView):
    """View for editing one or more Dashboard records."""

    queryset = GrafanaDashboard.objects.all()
    filterset = DashboardFilter
    table = GrafanaDashboardTable
    form = DashboardBulkEditForm
    bulk_edit_url = "plugins:nautobot_chatops:grafanadashboard_bulk_edit"

    def get_required_permission(self):
        """Return required change permission."""
        return "nautobot_chatops.dashboard_edit"


# -------------------------------------------------------------------------------------
# Panel Specific Views
# -------------------------------------------------------------------------------------


class Panels(GrafanaViewMixin, ObjectListView):
    """View for showing panels configuration."""

    queryset = GrafanaPanel.objects.all()
    filterset = PanelFilter
    filterset_form = PanelsFilterForm
    table = GrafanaPanelTable
    action_buttons = ("add", "import")
    template_name = "nautobot_chatops_grafana/panel_list.html"

    def get_required_permission(self):
        """Return required view permission."""
        return "nautobot_chatops.panel_read"


class PanelsCreate(GrafanaViewMixin, PermissionRequiredMixin, ObjectEditView):
    """View for creating a new Panel."""

    permission_required = "nautobot_chatops.panel_add"
    model = GrafanaPanel
    queryset = GrafanaPanel.objects.all()
    model_form = PanelsForm
    default_return_url = "plugins:nautobot_chatops:grafanapanel_list"


class PanelsEdit(PanelsCreate):
    """View for editing an existing Panel."""

    permission_required = "nautobot_chatops.panel_edit"


class PanelsSync(GrafanaViewMixin, PermissionRequiredMixin, ObjectEditView):
    """View for synchronizing data between the Grafana Dashboard Panels and Nautobot."""

    permission_required = "nautobot_chatops.panel_sync"
    model = GrafanaPanel
    queryset = GrafanaPanel.objects.all()
    model_form = PanelsSyncForm
    template_name = "nautobot_chatops_grafana/panels_sync.html"
    default_return_url = "plugins:nautobot_chatops:grafanapanel_list"

    def get_permission_required(self):
        """Permissions over-rride for the Panels Sync view."""
        return "nautobot_chatops.panel_sync"

    def post(self, request, *args, **kwargs):
        """Post request for the Panels Sync view."""
        dashboard_pk = request.POST.get("dashboard")
        if not dashboard_pk:
            messages.error(request, "Unable to determine Grafana Dashboard!")
            return redirect(reverse("plugins:nautobot_chatops:grafanapanel_list"))

        dashboard = GrafanaDashboard.objects.get(pk=dashboard_pk)

        sync_data = run_panels_sync(dashboard, request.POST.get("delete") == "true")
        if not sync_data:
            messages.info(request, "No diffs found for the Grafana Dashboards!")
        else:
            messages.success(request, "Grafana Dashboards synchronization complete!")

        return redirect(reverse("plugins:nautobot_chatops:grafanapanel_list"))


class PanelsDelete(GrafanaViewMixin, PermissionRequiredMixin, ObjectDeleteView):
    """View for deleting one or more Panel records."""

    queryset = GrafanaPanel.objects.all()
    permission_required = "nautobot_chatops.panel_delete"
    default_return_url = "plugins:nautobot_chatops:grafanapanel_list"


class PanelsBulkImportView(GrafanaViewMixin, BulkImportView):
    """View for bulk import of Panels."""

    queryset = GrafanaPanel.objects.all()
    table = GrafanaPanelTable
    default_return_url = "plugins:nautobot_chatops:grafanapanel_list"


class PanelsBulkDeleteView(GrafanaViewMixin, BulkDeleteView):
    """View for deleting one or more Panels records."""

    queryset = GrafanaPanel.objects.all()
    table = GrafanaPanelTable
    bulk_delete_url = "plugins:nautobot_chatops:grafanapanel_bulk_delete"
    default_return_url = "plugins:nautobot_chatops:grafanapanel_list"

    def get_required_permission(self):
        """Return required delete permission."""
        return "nautobot_chatops.panel_delete"


class PanelsBulkEditView(GrafanaViewMixin, BulkEditView):
    """View for editing one or more Panels records."""

    queryset = GrafanaPanel.objects.all()
    filterset = PanelsFilterForm
    table = GrafanaPanelTable
    form = PanelsBulkEditForm
    bulk_edit_url = "plugins:nautobot_chatops:grafanapanel_bulk_edit"

    def get_required_permission(self):
        """Return required change permission."""
        return "nautobot_chatops.panel_edit"


# -------------------------------------------------------------------------------------
# Panel Variable Specific Views
# -------------------------------------------------------------------------------------


class Variables(GrafanaViewMixin, ObjectListView):
    """View for showing panel-variables configuration."""

    queryset = GrafanaPanelVariable.objects.all()
    filterset = VariableFilter
    filterset_form = PanelVariablesFilterForm
    table = GrafanaPanelVariableTable
    action_buttons = ("add", "import")
    template_name = "nautobot_chatops_grafana/variable_list.html"

    def get_required_permission(self):
        """Return required view permission."""
        return "nautobot_chatops.panelvariable_read"


class VariablesCreate(GrafanaViewMixin, PermissionRequiredMixin, ObjectEditView):
    """View for creating a new Variable."""

    permission_required = "nautobot_chatops.panelvariable_add"
    model = GrafanaPanelVariable
    queryset = GrafanaPanelVariable.objects.all()
    model_form = PanelVariablesForm
    default_return_url = "plugins:nautobot_chatops:grafanapanelvariable_list"


class VariablesEdit(VariablesCreate):
    """View for editing an existing Variable."""

    permission_required = "nautobot_chatops.panelvariable_edit"


class VariablesDelete(GrafanaViewMixin, PermissionRequiredMixin, ObjectDeleteView):
    """View for deleting one or more Variable records."""

    queryset = GrafanaPanelVariable.objects.all()
    permission_required = "nautobot_chatops.panelvariable_delete"
    default_return_url = "plugins:nautobot_chatops:grafanapanelvariable_list"


class VariablesBulkImportView(GrafanaViewMixin, BulkImportView):
    """View for bulk import of Variables."""

    queryset = GrafanaPanelVariable.objects.all()
    table = GrafanaPanelVariableTable
    default_return_url = "plugins:nautobot_chatops:grafanapanelvariable_list"


class VariablesBulkDeleteView(GrafanaViewMixin, BulkDeleteView):
    """View for deleting one or more Variable records."""

    queryset = GrafanaPanelVariable.objects.all()
    table = GrafanaPanelVariableTable
    bulk_delete_url = "plugins:nautobot_chatops:grafanapanelvariable_bulk_delete"
    default_return_url = "plugins:nautobot_chatops:grafanapanelvariable_list"

    def get_required_permission(self):
        """Return required delete permission."""
        return "nautobot_chatops.panelvariable_delete"


class VariablesBulkEditView(GrafanaViewMixin, BulkEditView):
    """View for editing one or more Variable records."""

    queryset = GrafanaPanelVariable.objects.all()
    filterset = PanelVariablesFilterForm
    table = GrafanaPanelVariableTable
    form = PanelVariablesBulkEditForm
    bulk_edit_url = "plugins:nautobot_chatops:grafanapanelvariable_bulk_edit"

    def get_required_permission(self):
        """Return required change permission."""
        return "nautobot_chatops.panelvariable_edit"


class VariablesSync(GrafanaViewMixin, PermissionRequiredMixin, ObjectEditView):
    """View for synchronizing data between the Grafana Dashboard Variables and Nautobot."""

    permission_required = "nautobot_chatops.panelvariable_sync"
    model = GrafanaPanelVariable
    queryset = GrafanaPanelVariable.objects.all()
    model_form = PanelVariablesSyncForm
    template_name = "nautobot_chatops_grafana/variables_sync.html"
    default_return_url = "plugins:nautobot_chatops:grafanapanelvariable_list"

    def get_permission_required(self):
        """Permissions over-ride for the Panels Sync view."""
        return "nautobot_chatops.panelvariable_sync"

    def post(self, request, *args, **kwargs):
        """Post request for the Panels Sync view."""
        dashboard_pk = request.POST.get("dashboard")
        if not dashboard_pk:
            messages.error(request, "Unable to determine Grafana Dashboard!")
            return redirect(reverse("plugins:nautobot_chatops:grafanapanelvariable_list"))

        dashboard = GrafanaDashboard.objects.get(pk=dashboard_pk)

        sync_data = run_variables_sync(dashboard, request.POST.get("delete") == "true")
        if not sync_data:
            messages.info(request, "No diffs found for the Grafana Dashboard Variables!")
        else:
            messages.success(request, "Grafana Dashboard Variable synchronization complete!")

        return redirect(reverse("plugins:nautobot_chatops:grafanapanelvariable_list"))
