"""Views for nautobot_chatops."""

from nautobot.apps.views import NautobotUIViewSet

from nautobot_chatops import filters, forms, models, tables
from nautobot_chatops.api import serializers


class CommandLogUIViewSet(NautobotUIViewSet):
    """ViewSet for CommandLog views."""

    bulk_update_form_class = forms.CommandLogBulkEditForm
    filterset_class = filters.CommandLogFilterSet
    filterset_form_class = forms.CommandLogFilterForm
    form_class = forms.CommandLogForm
    lookup_field = "pk"
    queryset = models.CommandLog.objects.all()
    serializer_class = serializers.CommandLogSerializer
    table_class = tables.CommandLogTable
