"""API serializers for nautobot_chatops."""

from nautobot.apps.api import NautobotModelSerializer, TaggedModelSerializerMixin

from nautobot_chatops.integrations.grafana.models import GrafanaDashboard


class GrafanaDashboardSerializer(TaggedModelSerializerMixin, NautobotModelSerializer):
    """Serializer for Grafana dashboards exposed via the API."""

    class Meta:
        """Meta attributes."""

        model = GrafanaDashboard
        fields = "__all__"
