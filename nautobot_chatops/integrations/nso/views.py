"""Views module for the nautobot_chatops.integrations.nso plugin.

The views implemented in this module act as endpoints for various chat platforms
to send requests and notifications to.
"""

from django.contrib.auth.mixins import PermissionRequiredMixin
from nautobot.core.views.generic import ObjectListView, ObjectEditView, ObjectDeleteView, ObjectView
from nautobot_chatops.integrations.nso.tables import NSOCommandFilterTable
from nautobot_chatops.integrations.nso.models import NSOCommandFilter
from nautobot_chatops.integrations.nso.forms import NSOCommandFilterForm


class NSOCommandFilterListView(ObjectListView):
    """View for command filters list."""

    queryset = NSOCommandFilter.objects.all()
    table = NSOCommandFilterTable
    action_buttons = ("add", "export")


class NSOCommandFilterView(ObjectView):
    """View for command filter details."""

    queryset = NSOCommandFilter.objects.all()
    template_name = "nautobot_chatops_nso/nsocommandfilter.html"


class NSOCommandFiltersCreateView(PermissionRequiredMixin, ObjectEditView):
    """View for creating a new command filter."""

    permission_required = "nautobot_chatops.add_nsocommandfilter"
    model = NSOCommandFilter
    queryset = NSOCommandFilter.objects.all()
    model_form = NSOCommandFilterForm


class NSOCommandFiltersUpdateView(NSOCommandFiltersCreateView):
    """View for editing an existing command filter."""

    permission_required = "nautobot_chatops.change_nsocommandfilter"


class NSOCommandFiltersDeleteView(PermissionRequiredMixin, ObjectDeleteView):
    """View for deleting a single command filter record."""

    queryset = NSOCommandFilter.objects.all()
    permission_required = "nautobot_chatops.delete_nsocommandfilter"
    default_return_url = "plugins:nautobot_chatops:nsocommandfilter_list"
