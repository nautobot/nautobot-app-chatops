"""Views module for the nautobot_chatops.integrations.grafana plugin.

The views implemented in this module act as endpoints for various chat platforms
to send requests and notifications to.
"""

from django.shortcuts import render, reverse, redirect
from django.contrib import messages
from django.contrib.auth.mixins import PermissionRequiredMixin
from nautobot.core.views.generic import (
    ObjectEditView,
    ObjectDeleteView,
    ObjectListView,
    BulkImportView,
    BulkDeleteView,
    BulkEditView,
)
from nautobot.utilities.forms import ConfirmationForm
from nautobot_chatops.integrations.grafana.diffsync.sync import run_dashboard_sync, run_panels_sync, run_variables_sync
from nautobot_chatops.integrations.grafana.tables import PanelViewTable, DashboardViewTable, PanelVariableViewTable
from nautobot_chatops.integrations.grafana.models import Panel, Dashboard, PanelVariable
from nautobot_chatops.integrations.grafana.grafana import handler
from nautobot_chatops.integrations.grafana.filters import DashboardFilter, PanelFilter, VariableFilter
from nautobot_chatops.integrations.grafana.forms import (
    DashboardsForm,
    DashboardsFilterForm,
    DashboardCSVForm,
    DashboardBulkEditForm,
    PanelsForm,
    PanelsSyncForm,
    PanelsCSVForm,
    PanelsFilterForm,
    PanelsBulkEditForm,
    PanelVariablesForm,
    PanelVariablesSyncForm,
    PanelVariablesFilterForm,
    PanelVariablesBulkEditForm,
    PanelVariablesCSVForm,
)

# -------------------------------------------------------------------------------------
# Dashboard Specific Views
# -------------------------------------------------------------------------------------


class Dashboards(ObjectListView):
    """View for showing dashboard configuration."""

    queryset = Dashboard.objects.all()
    filterset = DashboardFilter
    filterset_form = DashboardsFilterForm
    table = DashboardViewTable
    action_buttons = ("add", "import")
    template_name = "nautobot_chatops_grafana/dashboard_list.html"

    def get_required_permission(self):
        """Return required view permission."""
        return "nautobot_chatops.dashboard_read"


class DashboardsCreate(PermissionRequiredMixin, ObjectEditView):
    """View for creating a new Dashboard."""

    permission_required = "nautobot_chatops.dashboard_add"
    model = Dashboard
    queryset = Dashboard.objects.all()
    model_form = DashboardsForm
    default_return_url = "plugins:nautobot_chatops:grafanadashboards"


class DashboardsEdit(DashboardsCreate):
    """View for editing an existing Dashboard."""

    permission_required = "nautobot_chatops.dashboard_edit"


class DashboardsSync(PermissionRequiredMixin, ObjectDeleteView):
    """View for syncing Grafana Dashboards with the Grafana API."""

    permission_required = "nautobot_chatops.dashboard_sync"
    default_return_url = "plugins:nautobot_chatops:grafanadashboards"

    def get(self, request, **kwargs):
        """Get request for the Dashboard Sync view."""
        return render(
            request,
            "nautobot_chatops_grafana/sync_confirmation.html",
            {
                "form": ConfirmationForm(initial=request.GET),
                "grafana_url": handler.config.grafana_url,
                "return_url": reverse("plugins:nautobot_chatops:grafanadashboards"),
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

        return redirect(reverse("plugins:nautobot_chatops:grafanadashboards"))


class DashboardsDelete(PermissionRequiredMixin, ObjectDeleteView):
    """View for deleting one or more Dashboard records."""

    queryset = Dashboard.objects.all()
    permission_required = "nautobot_chatops.dashboard_delete"
    default_return_url = "plugins:nautobot_chatops:grafanadashboards"


class DashboardsBulkImportView(BulkImportView):
    """View for bulk import of eox notices."""

    queryset = Dashboard.objects.all()
    model_form = DashboardCSVForm
    table = DashboardViewTable
    default_return_url = "plugins:nautobot_chatops:grafanadashboards"


class DashboardsBulkDeleteView(BulkDeleteView):
    """View for deleting one or more Dashboard records."""

    queryset = Dashboard.objects.all()
    table = DashboardViewTable
    bulk_delete_url = "plugins:nautobot_chatops:grafanadashboard_bulk_delete"
    default_return_url = "plugins:nautobot_chatops:grafanadashboards"

    def get_required_permission(self):
        """Return required delete permission."""
        return "nautobot_chatops.dashboard_delete"


class DashboardBulkEditView(BulkEditView):
    """View for editing one or more Dashboard records."""

    queryset = Dashboard.objects.all()
    filterset = DashboardFilter
    table = DashboardViewTable
    form = DashboardBulkEditForm
    bulk_edit_url = "plugins:nautobot_chatops:grafanadashboard_bulk_edit"

    def get_required_permission(self):
        """Return required change permission."""
        return "nautobot_chatops.dashboard_edit"


# -------------------------------------------------------------------------------------
# Panel Specific Views
# -------------------------------------------------------------------------------------


class Panels(ObjectListView):
    """View for showing panels configuration."""

    queryset = Panel.objects.all()
    filterset = PanelFilter
    filterset_form = PanelsFilterForm
    table = PanelViewTable
    action_buttons = ("add", "import")
    template_name = "nautobot_chatops_grafana/panel_list.html"

    def get_required_permission(self):
        """Return required view permission."""
        return "nautobot_chatops.panel_read"


class PanelsCreate(PermissionRequiredMixin, ObjectEditView):
    """View for creating a new Panel."""

    permission_required = "nautobot_chatops.panel_add"
    model = Panel
    queryset = Panel.objects.all()
    model_form = PanelsForm
    default_return_url = "plugins:nautobot_chatops:grafanapanel"


class PanelsEdit(PanelsCreate):
    """View for editing an existing Panel."""

    permission_required = "nautobot_chatops.panel_edit"


class PanelsSync(PermissionRequiredMixin, ObjectEditView):
    """View for synchronizing data between the Grafana Dashboard Panels and Nautobot."""

    permission_required = "nautobot_chatops.panel_sync"
    model = Panel
    queryset = Panel.objects.all()
    model_form = PanelsSyncForm
    template_name = "nautobot_chatops_grafana/panels_sync.html"
    default_return_url = "plugins:nautobot_chatops:grafanapanel"

    def get_permission_required(self):
        """Permissions over-rride for the Panels Sync view."""
        return "nautobot_chatops.panel_sync"

    def post(self, request, *args, **kwargs):
        """Post request for the Panels Sync view."""
        dashboard_pk = request.POST.get("dashboard")
        if not dashboard_pk:
            messages.error(request, "Unable to determine Grafana Dashboard!")
            return redirect(reverse("plugins:nautobot_chatops:grafanapanel"))

        dashboard = Dashboard.objects.get(pk=dashboard_pk)

        sync_data = run_panels_sync(dashboard, request.POST.get("delete") == "true")
        if not sync_data:
            messages.info(request, "No diffs found for the Grafana Dashboards!")
        else:
            messages.success(request, "Grafana Dashboards synchronization complete!")

        return redirect(reverse("plugins:nautobot_chatops:grafanapanel"))


class PanelsDelete(PermissionRequiredMixin, ObjectDeleteView):
    """View for deleting one or more Panel records."""

    queryset = Panel.objects.all()
    permission_required = "nautobot_chatops.panel_delete"
    default_return_url = "plugins:nautobot_chatops:grafanapanel"


class PanelsBulkImportView(BulkImportView):
    """View for bulk import of Panels."""

    queryset = Panel.objects.all()
    model_form = PanelsCSVForm
    table = PanelViewTable
    default_return_url = "plugins:nautobot_chatops:grafanapanel"


class PanelsBulkDeleteView(BulkDeleteView):
    """View for deleting one or more Panels records."""

    queryset = Panel.objects.all()
    table = PanelViewTable
    bulk_delete_url = "plugins:nautobot_chatops:grafanapanel_bulk_delete"
    default_return_url = "plugins:nautobot_chatops:grafanapanel"

    def get_required_permission(self):
        """Return required delete permission."""
        return "nautobot_chatops.panel_delete"


class PanelsBulkEditView(BulkEditView):
    """View for editing one or more Panels records."""

    queryset = Panel.objects.all()
    filterset = PanelsFilterForm
    table = PanelViewTable
    form = PanelsBulkEditForm
    bulk_edit_url = "plugins:nautobot_chatops:grafanapanel_bulk_edit"

    def get_required_permission(self):
        """Return required change permission."""
        return "nautobot_chatops.panel_edit"


# -------------------------------------------------------------------------------------
# Panel Variable Specific Views
# -------------------------------------------------------------------------------------


class Variables(ObjectListView):
    """View for showing panel-variables configuration."""

    queryset = PanelVariable.objects.all()
    filterset = VariableFilter
    filterset_form = PanelVariablesFilterForm
    table = PanelVariableViewTable
    action_buttons = ("add", "import")
    template_name = "nautobot_chatops_grafana/variable_list.html"

    def get_required_permission(self):
        """Return required view permission."""
        return "nautobot_chatops.panelvariable_read"


class VariablesCreate(PermissionRequiredMixin, ObjectEditView):
    """View for creating a new Variable."""

    permission_required = "nautobot_chatops.panelvariable_add"
    model = PanelVariable
    queryset = PanelVariable.objects.all()
    model_form = PanelVariablesForm
    default_return_url = "plugins:nautobot_chatops:grafanapanelvariables"


class VariablesEdit(VariablesCreate):
    """View for editing an existing Variable."""

    permission_required = "nautobot_chatops.panelvariable_edit"


class VariablesDelete(PermissionRequiredMixin, ObjectDeleteView):
    """View for deleting one or more Variable records."""

    queryset = PanelVariable.objects.all()
    permission_required = "nautobot_chatops.panelvariable_delete"
    default_return_url = "plugins:nautobot_chatops:grafanapanelvariables"


class VariablesBulkImportView(BulkImportView):
    """View for bulk import of Variables."""

    queryset = PanelVariable.objects.all()
    model_form = PanelVariablesCSVForm
    table = PanelVariableViewTable
    default_return_url = "plugins:nautobot_chatops:grafanapanelvariables"


class VariablesBulkDeleteView(BulkDeleteView):
    """View for deleting one or more Variable records."""

    queryset = PanelVariable.objects.all()
    table = PanelVariableViewTable
    bulk_delete_url = "plugins:nautobot_chatops:grafanapanelvariable_bulk_delete"
    default_return_url = "plugins:nautobot_chatops:grafanapanelvariables"

    def get_required_permission(self):
        """Return required delete permission."""
        return "nautobot_chatops.panelvariable_delete"


class VariablesBulkEditView(BulkEditView):
    """View for editing one or more Variable records."""

    queryset = PanelVariable.objects.all()
    filterset = PanelVariablesFilterForm
    table = PanelVariableViewTable
    form = PanelVariablesBulkEditForm
    bulk_edit_url = "plugins:nautobot_chatops:grafanapanelvariable_bulk_edit"

    def get_required_permission(self):
        """Return required change permission."""
        return "nautobot_chatops.panelvariable_edit"


class VariablesSync(PermissionRequiredMixin, ObjectEditView):
    """View for synchronizing data between the Grafana Dashboard Variables and Nautobot."""

    permission_required = "nautobot_chatops.panelvariable_sync"
    model = PanelVariable
    queryset = PanelVariable.objects.all()
    model_form = PanelVariablesSyncForm
    template_name = "nautobot_chatops_grafana/variables_sync.html"
    default_return_url = "plugins:nautobot_chatops:grafanapanelvariables"

    def get_permission_required(self):
        """Permissions over-ride for the Panels Sync view."""
        return "nautobot_chatops.panelvariable_sync"

    def post(self, request, *args, **kwargs):
        """Post request for the Panels Sync view."""
        dashboard_pk = request.POST.get("dashboard")
        if not dashboard_pk:
            messages.error(request, "Unable to determine Grafana Dashboard!")
            return redirect(reverse("plugins:nautobot_chatops:grafanapanelvariables"))

        dashboard = Dashboard.objects.get(pk=dashboard_pk)

        sync_data = run_variables_sync(dashboard, request.POST.get("delete") == "true")
        if not sync_data:
            messages.info(request, "No diffs found for the Grafana Dashboard Variables!")
        else:
            messages.success(request, "Grafana Dashboard Variable synchronization complete!")

        return redirect(reverse("plugins:nautobot_chatops:grafanapanelvariables"))
