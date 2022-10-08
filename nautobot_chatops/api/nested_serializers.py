"""Nested Serializers for ChatOps Plugin."""

from rest_framework import serializers

from nautobot.core.api import WritableNestedSerializer
from nautobot_chatops.models import AccessGrant, CommandToken


class NestedCommandTokenSerializer(WritableNestedSerializer):
    """Nested serializer for CommandToken objects."""

    url = serializers.HyperlinkedIdentityField(view_name="plugins-api:nautobot_chatops-api:commandtoken-detail")

    class Meta:
        """Meta for Nested CommandToken Serializer."""

        model = CommandToken
        fields = ("id", "comment", "platform", "token", "url")


class NestedAccessGrantSerializer(WritableNestedSerializer):
    """Nested serializer for AccessGrant objects."""

    url = serializers.HyperlinkedIdentityField(view_name="plugins-api:nautobot_chatops-api:accessgrant-detail")

    class Meta:
        """Meta for Nested AccessGrant Serializer."""

        model = AccessGrant
        fields = ("id", "command", "subcommand", "grant_type", "name", "value", "url")
