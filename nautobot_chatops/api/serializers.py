"""API Serializers for Merlin."""
from nautobot.core.api import ValidatedModelSerializer

from nautobot_chatops.models import CommandToken


class CommandTokenSerializer(ValidatedModelSerializer):
    """API serializer for interacting with CommandToken objects."""

    class Meta:
        """Meta for CommandToken Serializer."""

        model = CommandToken
        fields = ("id", "comment", "platform", "token")
