"""Views module for the nautobot_plugin_chatops_nso plugin.

The views implemented in this module act as endpoints for various chat platforms
to send requests and notifications to.
"""

from django.views import View
from django.shortcuts import redirect
from django.contrib.auth.mixins import PermissionRequiredMixin
from nautobot.core.views.generic import ObjectListView, ObjectEditView, ObjectDeleteView
from nautobot_plugin_chatops_nso.nso import PLUGIN_SETTINGS
from nautobot_plugin_chatops_nso.tables import CommandFilterTable
from nautobot_plugin_chatops_nso.models import CommandFilter
from nautobot_plugin_chatops_nso.forms import CommandFilterForm


class CiscoNSOView(View):
    """View for redirecting to the Cisco NSO pages."""

    def get(self, request, *args, **kwargs):
        """Get request for the redirect."""
        return redirect(PLUGIN_SETTINGS.get("nso_url"))


class CommandFilterListView(ObjectListView):
    """View for command filters list."""

    queryset = CommandFilter.objects.all()
    table = CommandFilterTable
    action_buttons = ("add", "export")


class CommandFiltersCreateView(PermissionRequiredMixin, ObjectEditView):
    """View for creating a new command filter."""

    permission_required = "nautobot_plugin_chatops_nso.add_commandfilter"
    model = CommandFilter
    queryset = CommandFilter.objects.all()
    model_form = CommandFilterForm
    default_return_url = "plugins:nautobot_plugin_chatops_nso:commandfilter_list"


class CommandFiltersUpdateView(CommandFiltersCreateView):
    """View for editing an existing command filter."""

    permission_required = "nautobot_plugin_chatops_nso.change_commandfilter"


class CommandFiltersDeleteView(PermissionRequiredMixin, ObjectDeleteView):
    """View for deleting a single command filter record."""

    queryset = CommandFilter.objects.all()
    permission_required = "nautobot_plugin_chatops_nso.delete_commandfilter"
    default_return_url = "plugins:nautobot_plugin_chatops_nso:commandfilter_list"
