"""API views for nautobot_chatops."""

from nautobot.apps.api import NautobotModelViewSet

from nautobot_chatops import filters, models
from nautobot_chatops.api import serializers


class CommandLogViewSet(NautobotModelViewSet):  # pylint: disable=too-many-ancestors
    """CommandLog viewset."""

    queryset = models.CommandLog.objects.all()
    serializer_class = serializers.CommandLogSerializer
    filterset_class = filters.CommandLogFilterSet

    # Option for modifying the default HTTP methods:
    # http_method_names = ["get", "post", "put", "patch", "delete", "head", "options", "trace"]
