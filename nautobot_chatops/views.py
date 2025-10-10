"""Views module for the nautobot_chatops Nautobot App.

The views implemented in this module act as endpoints for various chat platforms
to send requests and notifications to.
"""

from django.core.exceptions import ImproperlyConfigured
from django.http import Http404
from nautobot.apps.config import get_app_settings_or_config
from nautobot.apps.ui import ObjectDetailContent, ObjectFieldsPanel, SectionChoices
from nautobot.apps.views import (
    NautobotUIViewSet,
    ObjectChangeLogViewMixin,
    ObjectListViewMixin,
    ObjectNotesViewMixin,
)

from nautobot_chatops import filters, forms, tables
from nautobot_chatops.api import serializers
from nautobot_chatops.models import AccessGrant, ChatOpsAccountLink, CommandLog, CommandToken


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


class CommandLogUIViewSet(
    ObjectListViewMixin,
    ObjectChangeLogViewMixin,
    ObjectNotesViewMixin,
):  # pylint: disable=abstract-method
    """View for listing all extant Command Logs."""

    action_buttons = ("export",)
    queryset = CommandLog.objects.all().order_by("-start_time")
    filterset_class = filters.CommandLogFilterSet
    filterset_form_class = forms.CommandLogFilterForm
    table_class = tables.CommandLogTable
    serializer_class = serializers.CommandLogSerializer


class AccessGrantUIViewSet(
    NautobotUIViewSet,
):
    """ViewSet for AccessGrants."""

    bulk_update_form_class = forms.AccessGrantBulkEditForm
    queryset = AccessGrant.objects.all().order_by("command")
    filterset_class = filters.AccessGrantFilterSet
    filterset_form_class = forms.AccessGrantFilterForm
    table_class = tables.AccessGrantTable
    form_class = forms.AccessGrantForm
    serializer_class = serializers.AccessGrantSerializer

    object_detail_content = ObjectDetailContent(
        panels=(
            ObjectFieldsPanel(
                section=SectionChoices.LEFT_HALF,
                weight=100,
                fields="__all__",
            ),
        )
    )


class CommandTokenUIViewSet(NautobotUIViewSet):
    """ViewSet for CommandToken."""

    bulk_update_form_class = forms.CommandTokenBulkEditForm
    queryset = CommandToken.objects.all().order_by("platform")
    filterset_class = filters.CommandTokenFilterSet
    filterset_form_class = forms.CommandTokenFilterForm
    table_class = tables.CommandTokenTable
    serializer_class = serializers.CommandTokenSerializer
    form_class = forms.CommandTokenForm

    object_detail_content = ObjectDetailContent(
        panels=(
            ObjectFieldsPanel(
                section=SectionChoices.LEFT_HALF,
                weight=100,
                fields="__all__",
            ),
        )
    )


class ChatOpsAccountLinkUIViewSet(NautobotUIViewSet):
    """ViewSet for ChatOpsAccountLink."""

    bulk_update_form_class = forms.ChatOpsAccountLinkBulkEditForm
    queryset = ChatOpsAccountLink.objects.all()
    filterset_class = filters.ChatOpsAccountLinkFilterSet
    filterset_form_class = forms.ChatOpsAccountLinkFilterForm
    table_class = tables.ChatOpsAccountLinkTable
    form_class = forms.ChatOpsAccountLinkForm
    serializer_class = serializers.ChatOpsAccountLinkSerializer

    object_detail_content = ObjectDetailContent(
        panels=(
            ObjectFieldsPanel(
                section=SectionChoices.LEFT_HALF,
                weight=100,
                fields="__all__",
            ),
        )
    )

    def get_queryset(self):
        """Limit list view to only the user's own account links."""
        queryset = super().get_queryset()
        if self.action == "list":
            queryset = queryset.filter(nautobot_user=self.request.user)
        return queryset

    def get_object(self):
        """Set `nautobot_user` and prefill `email` on new objects."""
        obj = super().get_object()
        if not obj.present_in_database:
            obj.nautobot_user = self.request.user
            obj.email = self.request.GET.get("email") or (
                self.request.user.email if self.request.user.is_authenticated else None
            )
        return obj
