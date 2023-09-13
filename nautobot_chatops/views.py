"""Views module for the nautobot_chatops Nautobot plugin.

The views implemented in this module act as endpoints for various chat platforms
to send requests and notifications to.
"""

from django.contrib.auth.mixins import PermissionRequiredMixin

from nautobot.core.views.generic import ObjectListView, ObjectEditView, BulkDeleteView

from nautobot_chatops.models import CommandLog, AccessGrant, CommandToken
from nautobot_chatops.filters import CommandLogFilterSet, AccessGrantFilterSet, CommandTokenFilterSet
from nautobot_chatops import forms
from nautobot_chatops.tables import CommandLogTable, AccessGrantTable, CommandTokenTable


class CommandLogListView(PermissionRequiredMixin, ObjectListView):
    """View for listing all extant AccessGrants."""

    action_buttons = ("export",)
    permission_required = "nautobot_chatops.view_accessgrant"
    queryset = CommandLog.objects.all().order_by("-start_time")
    filterset = CommandLogFilterSet
    filterset_form = forms.CommandLogFilterForm
    table = CommandLogTable

    def extra_context(self):
        """Add extra context for Command Usage List View."""
        return {
            "title": "Nautobot Command Usage Records",
        }


class AccessGrantListView(PermissionRequiredMixin, ObjectListView):
    """View for listing all extant AccessGrants."""

    # Set the action buttons to correspond to what there are views. If import/export are added, this should be updated
    action_buttons = ("add",)
    permission_required = "nautobot_chatops.view_commandlog"
    queryset = AccessGrant.objects.all().order_by("command")
    filterset = AccessGrantFilterSet
    filterset_form = forms.AccessGrantFilterForm
    table = AccessGrantTable

    def extra_context(self):
        """Add extra context for Access Grant List View."""
        return {
            "title": "Nautobot Access Grants",
        }


class AccessGrantCreateView(PermissionRequiredMixin, ObjectEditView):
    """View for creating a new AccessGrant."""

    permission_required = "nautobot_chatops.add_accessgrant"
    model = AccessGrant
    queryset = AccessGrant.objects.all()
    model_form = forms.AccessGrantForm
    template_name = "nautobot/access_grant_edit.html"
    default_return_url = "plugins:nautobot_chatops:accessgrant_list"


# pylint: disable=too-many-ancestors
class AccessGrantView(AccessGrantCreateView):
    """View for editing an existing AccessGrant."""

    permission_required = "nautobot_chatops.change_accessgrant"


class AccessGrantBulkDeleteView(PermissionRequiredMixin, BulkDeleteView):
    """View for deleting one or more AccessGrant records."""

    permission_required = "nautobot_chatops.delete_accessgrant"
    queryset = AccessGrant.objects.filter()
    table = AccessGrantTable
    default_return_url = "plugins:nautobot_chatops:accessgrant_list"


class CommandTokenListView(PermissionRequiredMixin, ObjectListView):
    """View for listing all extant CommandTokens."""

    # Set the action buttons to correspond to what there are views. If import/export are added, this should be updated
    action_buttons = ("add",)
    permission_required = "nautobot_chatops.view_commandtoken"
    queryset = CommandToken.objects.all().order_by("platform")
    filterset = CommandTokenFilterSet
    filterset_form = forms.CommandTokenFilterForm
    table = CommandTokenTable

    def extra_context(self):
        """Add extra context for Command Token List View."""
        return {
            "title": "Nautobot Command Tokens",
        }


class CommandTokenCreateView(PermissionRequiredMixin, ObjectEditView):
    """View for creating a new CommandToken."""

    permission_required = "nautobot_chatops.add_commandtoken"
    model = CommandToken
    queryset = CommandToken.objects.all()
    model_form = forms.CommandTokenForm
    template_name = "nautobot/command_token_edit.html"
    default_return_url = "plugins:nautobot_chatops:commandtoken_list"


# pylint: disable=too-many-ancestors
class CommandTokenView(CommandTokenCreateView):
    """View for editing an existing CommandToken."""

    permission_required = "nautobot_chatops.change_commandtoken"


class CommandTokenBulkDeleteView(PermissionRequiredMixin, BulkDeleteView):
    """View for deleting one or more CommandToken records."""

    permission_required = "nautobot_chatops.delete_commandtoken"
    queryset = CommandToken.objects.filter()
    table = CommandTokenTable
    default_return_url = "plugins:nautobot_chatops:commandtoken_list"
