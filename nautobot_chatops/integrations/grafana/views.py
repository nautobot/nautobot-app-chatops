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
from nautobot.apps.ui import ObjectDetailContent, ObjectFieldsPanel, SectionChoices
from nautobot.apps.views import (
    NautobotUIViewSet,
)
from nautobot.core.forms import ConfirmationForm
from nautobot.core.views.generic import (
    BulkDeleteView,
    BulkEditView,
    BulkImportView,
    ObjectDeleteView,
    ObjectEditView,
    ObjectListView,
)

from nautobot_chatops.integrations.grafana.api.serializers import GrafanaDashboardSerializer, GrafanaPanelSerializer
from nautobot_chatops.integrations.grafana.filters import DashboardFilterSet, PanelFilterSet, VariableFilter
from nautobot_chatops.integrations.grafana.forms import (
    DashboardFilterForm,
    DashboardForm,
    GrafanaDashboardBulkEditForm,
    PanelsBulkEditForm,
    PanelFilterForm,
    PanelForm,
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


class GrafanaDashboardUIViewSet(GrafanaViewMixin, NautobotUIViewSet):
    """View for showing dashboard configuration."""

    bulk_update_form_class = GrafanaDashboardBulkEditForm
    queryset = GrafanaDashboard.objects.all()
    filterset_class = DashboardFilterSet
    filterset_form_class = DashboardFilterForm
    table_class = GrafanaDashboardTable
    form_class = DashboardForm
    serializer_class = GrafanaDashboardSerializer
    action_buttons = ("add", "import")

    object_detail_content = ObjectDetailContent(
        panels=(
            ObjectFieldsPanel(
                section=SectionChoices.LEFT_HALF,
                weight=100,
                fields="__all__",
            ),
        )
    )

    def get_required_permission(self):
        """Return required view permission."""
        return "nautobot_chatops.dashboard_read"


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


class DashboardsBulkImportView(GrafanaViewMixin, BulkImportView):
    """View for bulk import of eox notices."""

    queryset = GrafanaDashboard.objects.all()
    table = GrafanaDashboardTable
    default_return_url = "plugins:nautobot_chatops:grafanadashboard_list"


# -------------------------------------------------------------------------------------
# Panel Specific Views
# -------------------------------------------------------------------------------------
class GrafanaPanelUIViewSet(GrafanaViewMixin, NautobotUIViewSet):
    """NautobotUIViewSet for Grafana panels."""

    bulk_update_form_class = PanelsBulkEditForm
    queryset = GrafanaPanel.objects.all()
    filterset_class = PanelFilterSet
    filterset_form_class = PanelFilterForm
    table_class = GrafanaPanelTable
    serializer_class = GrafanaPanelSerializer
    form_class = PanelForm
    action_buttons = ("add", "import")

    object_detail_content = ObjectDetailContent(
        panels=(
            ObjectFieldsPanel(
                section=SectionChoices.LEFT_HALF,
                weight=100,
                fields="__all__",
            ),
        )
    )


    def get_required_permission(self):
        """Return required view permission."""
        return "nautobot_chatops.panel_read"


# Backward compatibility alias.
GrafanaPanelsUIViewSet = GrafanaPanelUIViewSet


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


class PanelsBulkImportView(GrafanaViewMixin, BulkImportView):
    """View for bulk import of Panels."""

    queryset = GrafanaPanel.objects.all()
    table = GrafanaPanelTable
    default_return_url = "plugins:nautobot_chatops:grafanapanel_list"


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
