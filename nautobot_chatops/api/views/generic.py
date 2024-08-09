"""API Views for Nautobot Chatops."""

from nautobot.apps.api import NautobotModelViewSet
from rest_framework.routers import APIRootView

from nautobot_chatops.api.serializers import AccessGrantSerializer, CommandLogSerializer, CommandTokenSerializer
from nautobot_chatops.filters import AccessGrantFilterSet, CommandLogFilterSet, CommandTokenFilterSet
from nautobot_chatops.models import AccessGrant, CommandLog, CommandToken


class NautobotChatopsRootView(APIRootView):
    """Nautobot Chatops API root view."""

    def get_view_name(self):
        """Return name for the Nautobot Chatops API Root."""
        return "Nautobot Chatops"


class CommandTokenViewSet(NautobotModelViewSet):  # pylint: disable=too-many-ancestors
    """API viewset for interacting with CommandToken objects."""

    queryset = CommandToken.objects.all()
    serializer_class = CommandTokenSerializer
    filterset_class = CommandTokenFilterSet


class CommandLogViewSet(NautobotModelViewSet):
    """API viewset for interacting with CommandLog objects."""

    queryset = CommandLog.objects.all()
    serializer_class = CommandLogSerializer
    filterset_class = CommandLogFilterSet


class AccessGrantViewSet(NautobotModelViewSet):  # pylint: disable=too-many-ancestors
    """API viewset for interacting with AccessGrant objects."""

    queryset = AccessGrant.objects.all()
    serializer_class = AccessGrantSerializer
    filterset_class = AccessGrantFilterSet
