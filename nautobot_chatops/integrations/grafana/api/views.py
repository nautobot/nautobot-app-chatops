"""API views for the Nautobot ChatOps Grafana integration."""

from nautobot.apps.api import NautobotModelViewSet

from nautobot_chatops.integrations.grafana.api.serializers import GrafanaDashboardSerializer
from nautobot_chatops.integrations.grafana.filters import DashboardFilterSet
from nautobot_chatops.integrations.grafana.models import GrafanaDashboard


class GrafanaDashboardViewSet(NautobotModelViewSet):
    """API viewset for Grafana dashboards."""

    queryset = GrafanaDashboard.objects.all()
    serializer_class = GrafanaDashboardSerializer
    filterset_class = DashboardFilterSet
