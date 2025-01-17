"""API serializers for nautobot_chatops."""

from nautobot.apps.api import NautobotModelSerializer, TaggedModelSerializerMixin

from nautobot_chatops import models


class CommandLogSerializer(NautobotModelSerializer, TaggedModelSerializerMixin):  # pylint: disable=too-many-ancestors
    """CommandLog Serializer."""

    class Meta:
        """Meta attributes."""

        model = models.CommandLog
        fields = "__all__"

        # Option for disabling write for certain fields:
        # read_only_fields = []


class CommandTokenSerializer(NautobotModelSerializer, TaggedModelSerializerMixin):  # pylint: disable=too-many-ancestors
    """CommandToken Serializer."""

    class Meta:
        """Meta attributes."""

        model = models.CommandToken
        fields = "__all__"

        # Option for disabling write for certain fields:
        # read_only_fields = []


class AccessGrantSerializer(NautobotModelSerializer, TaggedModelSerializerMixin):  # pylint: disable=too-many-ancestors
    """AccessGrant Serializer."""

    class Meta:
        """Meta attributes."""

        model = models.AccessGrant
        fields = "__all__"

        # Option for disabling write for certain fields:
        # read_only_fields = []
