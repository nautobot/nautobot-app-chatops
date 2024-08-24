"""API Views for Nautobot Chatops."""

from nautobot.core.api.views import ModelViewSet
from rest_framework.routers import APIRootView

from nautobot_chatops.api.serializers import AccessGrantSerializer, CommandTokenSerializer
from nautobot_chatops.filters import AccessGrantFilterSet, CommandTokenFilterSet
from nautobot_chatops.models import AccessGrant, CommandToken


class NautobotChatopsRootView(APIRootView):
    """Nautobot Chatops API root view."""

    def get_view_name(self):
        """Return name for the Nautobot Chatops API Root."""
        return "Nautobot Chatops"


class CommandTokenViewSet(ModelViewSet):  # pylint: disable=too-many-ancestors
    """API viewset for interacting with CommandToken objects."""

    queryset = CommandToken.objects.all()
    serializer_class = CommandTokenSerializer
    filterset_class = CommandTokenFilterSet


class AccessGrantViewSet(ModelViewSet):  # pylint: disable=too-many-ancestors
    """API viewset for interacting with AccessGrant objects."""

    queryset = AccessGrant.objects.all()
    serializer_class = AccessGrantSerializer
    filterset_class = AccessGrantFilterSet
