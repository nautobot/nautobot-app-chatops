"""API Serializers for ChatOps Plugin."""

from rest_framework import serializers

from nautobot.core.api import NautobotModelSerializer

from nautobot_chatops.models import AccessGrant, CommandLog, CommandToken


class CommandTokenSerializer(NautobotModelSerializer):
    """API serializer for interacting with CommandToken objects."""

    url = serializers.HyperlinkedIdentityField(view_name="plugins-api:nautobot_chatops-api:commandtoken-detail")

    class Meta:
        """Meta for CommandToken Serializer."""

        model = CommandToken
        fields = ("id", "comment", "platform", "token", "url")


class AccessGrantSerializer(NautobotModelSerializer):
    """API serializer for interacting with AccessGrant objects."""

    url = serializers.HyperlinkedIdentityField(view_name="plugins-api:nautobot_chatops-api:accessgrant-detail")

    class Meta:
        """Meta for AccessGrant Serializer."""

        model = AccessGrant
        fields = ("id", "command", "subcommand", "grant_type", "name", "value", "url")


class CommandLogSerializer(NautobotModelSerializer):
    """API serializer for interacting with CommandLog objects."""

    class Meta:
        """Meta for CommandLog Serializer."""

        model = CommandLog
        fields = ("id", "start_time", "user_name", "user_id", "platform", "command", "subcommand", "params", "status", "details")
