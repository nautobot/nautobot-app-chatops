"""Views module for the nautobot_chatops.integrations.nso plugin.

The views implemented in this module act as endpoints for various chat platforms
to send requests and notifications to.
"""

from django.contrib.auth.mixins import PermissionRequiredMixin
from nautobot.core.views.generic import ObjectListView, ObjectEditView, ObjectDeleteView, ObjectView
from nautobot_chatops.integrations.nso.tables import CommandFilterTable
from nautobot_chatops.integrations.nso.models import CommandFilter
from nautobot_chatops.integrations.nso.forms import CommandFilterForm


class CommandFilterListView(ObjectListView):
    """View for command filters list."""

    queryset = CommandFilter.objects.all()
    table = CommandFilterTable
    action_buttons = ("add", "export")


class CommandFilterView(ObjectView):
    """View for command filter details."""

    queryset = CommandFilter.objects.all()
    template_name = "nautobot_chatops_nso/commandfilter.html"


class CommandFiltersCreateView(PermissionRequiredMixin, ObjectEditView):
    """View for creating a new command filter."""

    permission_required = "nautobot_chatops.add_commandfilter"
    model = CommandFilter
    queryset = CommandFilter.objects.all()
    model_form = CommandFilterForm


class CommandFiltersUpdateView(CommandFiltersCreateView):
    """View for editing an existing command filter."""

    permission_required = "nautobot_chatops.change_commandfilter"


class CommandFiltersDeleteView(PermissionRequiredMixin, ObjectDeleteView):
    """View for deleting a single command filter record."""

    queryset = CommandFilter.objects.all()
    permission_required = "nautobot_chatops.delete_commandfilter"
    default_return_url = "plugins:nautobot_chatops:commandfilter_list"
