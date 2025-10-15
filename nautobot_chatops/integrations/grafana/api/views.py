"""API views for the Nautobot ChatOps Grafana integration."""

from nautobot.apps.api import NautobotModelViewSet

from nautobot_chatops.integrations.grafana.api.serializers import GrafanaDashboardSerializer, GrafanaPanelSerializer
from nautobot_chatops.integrations.grafana.filters import GrafanaDashboardFilterSet, GrafanaPanelFilterSet
from nautobot_chatops.integrations.grafana.models import GrafanaDashboard, GrafanaPanel


class GrafanaDashboardViewSet(NautobotModelViewSet):
    """API viewset for Grafana dashboards."""

    queryset = GrafanaDashboard.objects.all()
    serializer_class = GrafanaDashboardSerializer
    filterset_class = GrafanaDashboardFilterSet


class GrafanaPanelViewSet(NautobotModelViewSet):
    """API viewset for Grafana panels."""

    queryset = GrafanaPanel.objects.all()
    serializer_class = GrafanaPanelSerializer
    filterset_class = GrafanaPanelFilterSet
