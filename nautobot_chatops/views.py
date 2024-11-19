"""Views module for the nautobot_chatops Nautobot App.

The views implemented in this module act as endpoints for various chat platforms
to send requests and notifications to.
"""

from django.contrib.auth.mixins import PermissionRequiredMixin
from django.core.exceptions import ImproperlyConfigured
from django.http import Http404
from django.shortcuts import render
from nautobot.apps.config import get_app_settings_or_config
from nautobot.core.forms import restrict_form_fields
from nautobot.core.utils.requests import normalize_querydict
from nautobot.core.views.generic import BulkDeleteView, ObjectDeleteView, ObjectEditView, ObjectListView, ObjectView

from nautobot_chatops import forms
from nautobot_chatops.filters import (
    AccessGrantFilterSet,
    ChatOpsAccountLinkFilterSet,
    CommandLogFilterSet,
    CommandTokenFilterSet,
)
from nautobot_chatops.models import AccessGrant, ChatOpsAccountLink, CommandLog, CommandToken
from nautobot_chatops.tables import AccessGrantTable, ChatOpsAccountLinkTable, CommandLogTable, CommandTokenTable


class SettingsControlledViewMixin:
    """View mixin to enable or disable views based on constance settings."""

    enable_view_setting = None

    def dispatch(self, request, *args, **kwargs):
        """Return a 404 if the view is not enabled in the settings."""
        if not getattr(self, "enable_view_setting", None):
            raise ImproperlyConfigured(
                "Property `enable_view_setting` must be defined on the view to use SettingsControlledView."
            )
        if not get_app_settings_or_config("nautobot_chatops", self.enable_view_setting):
            raise Http404
        return super().dispatch(request, *args, **kwargs)


class CommandLogListView(PermissionRequiredMixin, ObjectListView):
    """View for listing all extant Command Logs."""

    action_buttons = ("export",)
    permission_required = "nautobot_chatops.view_commandlog"
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
    permission_required = "nautobot_chatops.view_accessgrant"
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
    template_name = "nautobot_chatops/access_grant_edit.html"
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
    template_name = "nautobot_chatops/command_token_edit.html"
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


class ChatOpsAccountLinkListView(ObjectListView):
    """View for listing the ChatOps Account Link objects for the user browsing."""

    queryset = ChatOpsAccountLink.objects.all()
    action_buttons = ("add",)
    table = ChatOpsAccountLinkTable
    filterset = ChatOpsAccountLinkFilterSet
    filterset_form = forms.ChatOpsAccountLinkFilterForm

    def extra_context(self):
        """Restrict the Accounts Links that are shown to the user."""
        user = self.request.user
        table = self.table(self.queryset.filter(nautobot_user=user), user=user)
        return {
            "table": table,
        }


class ChatOpsAccountLinkView(ObjectView):
    """Detail view for Account Links."""

    queryset = ChatOpsAccountLink.objects.all()


class ChatOpsAccountLinkEditView(ObjectEditView):
    """Edit view for Account Links."""

    queryset = ChatOpsAccountLink.objects.all()
    model_form = forms.ChatOpsAccountLinkForm
    template_name = "nautobot_chatops/chatops_account_link_edit.html"

    def alter_obj(self, obj, request, url_args, url_kwargs):
        """Store the request user on the object."""
        obj.nautobot_user = request.user
        return super().alter_obj(obj, request, url_args, url_kwargs)

    def get(self, request, *args, **kwargs):
        """Add the users email to the form automatically, this can be overriden by the user."""
        obj = self.alter_obj(self.get_object(kwargs), request, args, kwargs)

        initial_data = normalize_querydict(request.GET)
        if not initial_data.get("email") and request.user.is_authenticated:
            initial_data["email"] = request.user.email
        form = self.model_form(instance=obj, initial=initial_data)
        restrict_form_fields(form, request.user)

        return render(
            request,
            self.template_name,
            {
                "obj": obj,
                "obj_type": self.queryset.model._meta.verbose_name,
                "form": form,
                "return_url": self.get_return_url(request, obj),
                "editing": obj.present_in_database,
                **self.get_extra_context(request, obj),
            },
        )


class ChatOpsAccountLinkDeleteView(ObjectDeleteView):
    """Delete view for Account Links."""

    queryset = ChatOpsAccountLink.objects.all()
