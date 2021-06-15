"""API Views for Nautobot Chatops."""
from rest_framework.routers import APIRootView
from nautobot.core.api.views import ModelViewSet

from nautobot_chatops.api.serializers import CommandTokenSerializer
from nautobot_chatops.models import CommandToken
from nautobot_chatops.filters import CommandTokenFilter


class NautobotChatopsRootView(APIRootView):
    """Nautobot Chatops API root view."""

    def get_view_name(self):
        """Return name for the Nautobot Chatops API Root."""
        return "Nautobot Chatops"


class CommandTokenViewSet(ModelViewSet):  # pylint: disable=too-many-ancestors
    """API viewset for interacting with CommandToken objects."""

    queryset = CommandToken.objects.all()
    serializer_class = CommandTokenSerializer
    filterset_class = CommandTokenFilter
