"""API serializers for nautobot_chatops."""

from nautobot.apps.api import NautobotModelSerializer, TaggedModelSerializerMixin

from nautobot_chatops import models
from nautobot_chatops.integrations.grafana.api.serializers import GrafanaDashboardSerializer as DashboardSerializer
from nautobot_chatops.integrations.grafana.api.serializers import GrafanaPanelSerializer as PanelSerializer
from nautobot_chatops.integrations.grafana.api.serializers import (
    GrafanaPanelVariableSerializer as PanelVariableSerializer,
)


class ChatOpsAccountLinkSerializer(NautobotModelSerializer, TaggedModelSerializerMixin):
    """ChatOpsAccountLink Serializer."""

    class Meta:
        """Meta attributes."""

        model = models.ChatOpsAccountLink
        fields = "__all__"


class CommandLogSerializer(NautobotModelSerializer, TaggedModelSerializerMixin):  # pylint: disable=too-many-ancestors
    """CommandLog Serializer."""

    class Meta:
        """Meta attributes."""

        model = models.CommandLog
        fields = "__all__"


class CommandTokenSerializer(NautobotModelSerializer, TaggedModelSerializerMixin):  # pylint: disable=too-many-ancestors
    """CommandToken Serializer."""

    class Meta:
        """Meta attributes."""

        model = models.CommandToken
        fields = "__all__"


class AccessGrantSerializer(NautobotModelSerializer, TaggedModelSerializerMixin):  # pylint: disable=too-many-ancestors
    """AccessGrant Serializer."""

    class Meta:
        """Meta attributes."""

        model = models.AccessGrant
        fields = "__all__"


"""
These aliases are required because Nautobot's model lookup helpers (e.g., get_form_for_model, get_filterset_for_model)
expect serializers, filters, and forms to be defined in standard module locations (like filters.py or forms.py).
However, our Grafana integration defines these only within the integration module.
These assignments ensure that lookups for Grafana models resolve correctly.
This can be removed once Nautobot supports custom model registration or dynamic lookup that includes integration paths
(or if we move these classes into the main app structure).

"""

GrafanaDashboardSerializer = DashboardSerializer
GrafanaPanelSerializer = PanelSerializer
GrafanaPanelVariableSerializer = PanelVariableSerializer
