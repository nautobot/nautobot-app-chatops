"""Views module for the nautobot_chatops Nautobot App.

The views implemented in this module act as endpoints for various chat platforms
to send requests and notifications to.
"""

from django.contrib.auth.mixins import PermissionRequiredMixin
from django.core.exceptions import ImproperlyConfigured
from django.http import Http404
from nautobot.apps.config import get_app_settings_or_config
from nautobot.core.views.generic import ObjectListView
from nautobot.core.views.mixins import (
    ObjectBulkDestroyViewMixin,
    ObjectChangeLogViewMixin,
    ObjectDestroyViewMixin,
    ObjectDetailViewMixin,
    ObjectEditViewMixin,
    ObjectListViewMixin,
    ObjectNotesViewMixin,
)

from nautobot_chatops import forms
from nautobot_chatops.api import serializers
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


class AccessGrantUIViewSet(
    ObjectListViewMixin,
    ObjectEditViewMixin,
    ObjectBulkDestroyViewMixin,
    ObjectChangeLogViewMixin,
    ObjectNotesViewMixin,
):
    """ViewSet for AccessGrants."""

    queryset = AccessGrant.objects.all().order_by("command")
    filterset_class = AccessGrantFilterSet
    filterset_form_class = forms.AccessGrantFilterForm
    table_class = AccessGrantTable
    form_class = forms.AccessGrantForm
    serializer_class = serializers.AccessGrantSerializer
    action_buttons = ("add",)

    def get_extra_context(self, request, instance):
        """Add extra context for Access Grant List View."""
        context = super().get_extra_context(request, instance)
        if self.action == "list":
            context["title"] = "Nautobot Access Grants"
        return context


class CommandTokenUIViewSet(
    ObjectListViewMixin,
    ObjectEditViewMixin,
    ObjectBulkDestroyViewMixin,
    ObjectChangeLogViewMixin,
    ObjectNotesViewMixin,
):
    """ViewSet for CommandToken."""

    queryset = CommandToken.objects.all().order_by("platform")
    filterset_class = CommandTokenFilterSet
    filterset_form_class = forms.CommandTokenFilterForm
    table_class = CommandTokenTable
    serializer_class = serializers.CommandTokenSerializer
    form_class = forms.CommandTokenForm
    action_buttons = ("add",)

    def get_extra_context(self, request, instance):
        """Add extra context for Access Grant List View."""
        context = super().get_extra_context(request, instance)
        if self.action == "list":
            context["title"] = "Nautobot Command Tokens"
        return context


class ChatOpsAccountLinkUIViewSet(
    ObjectDetailViewMixin,
    ObjectListViewMixin,
    ObjectEditViewMixin,
    ObjectDestroyViewMixin,
    ObjectChangeLogViewMixin,
    ObjectNotesViewMixin,
):
    """ViewSet for ChatOpsAccountLink."""

    queryset = ChatOpsAccountLink.objects.all()
    filterset_class = ChatOpsAccountLinkFilterSet
    filterset_form_class = forms.ChatOpsAccountLinkFilterForm
    table_class = ChatOpsAccountLinkTable
    form_class = forms.ChatOpsAccountLinkForm
    serializer_class = serializers.ChatOpsAccountLinkSerializer
    action_buttons = ("add",)

    def get_extra_context(self, request, instance):
        """Restrict the Accounts Links that are shown to the user."""
        context = super().get_extra_context(request, instance)
        if self.action == "list":
            user = request.user
            table = self.table_class(self.queryset.filter(nautobot_user=user), user=user)
            context.update(
                {
                    "table": table,
                }
            )
        return context

    def get_object(self):
        """Set `nautobot_user` and prefill `email` on new objects."""
        obj = super().get_object()
        if not obj.present_in_database:
            obj.nautobot_user = self.request.user
            obj.email = self.request.GET.get("email") or (
                self.request.user.email if self.request.user.is_authenticated else None
            )
        return obj
