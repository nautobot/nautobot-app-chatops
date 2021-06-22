"""API Serializers for Merlin."""
from nautobot.core.api import ValidatedModelSerializer

from nautobot_chatops.models import AccessGrant, CommandToken


class CommandTokenSerializer(ValidatedModelSerializer):
    """API serializer for interacting with CommandToken objects."""

    class Meta:
        """Meta for CommandToken Serializer."""

        model = CommandToken
        fields = ("id", "comment", "platform", "token")


class AccessGrantSerializer(ValidatedModelSerializer):
    """API serializer for interacting with AccessGrant objects."""

    class Meta:
        """Meta for AccessGrant Serializer."""

        model = AccessGrant
        fields = ("id", "command", "subcommand", "grant_type", "name", "value")
