"""API Views for Nautobot Plugin Chatops Grafana."""
from rest_framework.routers import APIRootView


class NautobotPluginChatopsGrafanaRootView(APIRootView):
    """Nautobot Chatops Grafana API root view."""

    def get_view_name(self):
        """Return name for API Root."""
        return "Grafana"
