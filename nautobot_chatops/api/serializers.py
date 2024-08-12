"""API Serializers for ChatOps App."""

from nautobot.core.api import NautobotModelSerializer
from rest_framework import serializers

from nautobot_chatops.models import AccessGrant, CommandLog, CommandToken


class CommandTokenSerializer(NautobotModelSerializer):
    """API serializer for interacting with CommandToken objects."""

    url = serializers.HyperlinkedIdentityField(view_name="plugins-api:nautobot_chatops-api:commandtoken-detail")

    class Meta:
        """Meta for CommandToken Serializer."""

        model = CommandToken
        fields = "__all__"


class AccessGrantSerializer(NautobotModelSerializer):
    """API serializer for interacting with AccessGrant objects."""

    url = serializers.HyperlinkedIdentityField(view_name="plugins-api:nautobot_chatops-api:accessgrant-detail")

    class Meta:
        """Meta for AccessGrant Serializer."""

        model = AccessGrant
        fields = "__all__"


class CommandLogSerializer(NautobotModelSerializer):
    """API serializer for interacting with CommandLog objects."""

    class Meta:
        """Meta for CommandLog Serializer."""

        model = CommandLog
        fields = "__all__"
