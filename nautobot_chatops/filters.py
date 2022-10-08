"""Django FilterSet classes for Nautobot."""

from nautobot.utilities.filters import BaseFilterSet

from nautobot_chatops.models import CommandLog, AccessGrant, CommandToken


class CommandLogFilterSet(BaseFilterSet):
    """FilterSet for filtering a set of CommandLog objects."""

    class Meta:
        """Metaclass attributes of CommandLogFilterSet."""

        model = CommandLog
        fields = [
            "start_time",
            "runtime",
            "user_name",
            "user_id",
            "platform",
            "command",
            "subcommand",
            "status",
            "details",
        ]


class AccessGrantFilterSet(BaseFilterSet):
    """FilterSet for filtering a set of AccessGrant objects."""

    class Meta:
        """Metaclass attributes of AccessGrantFilterSet."""

        model = AccessGrant
        fields = ["command", "subcommand", "grant_type", "value"]


class CommandTokenFilterSet(BaseFilterSet):
    """FilterSet for filtering a set of CommandToken objects."""

    class Meta:
        """Metaclass attributes of CommandTokenFilterSet."""

        model = CommandToken
        fields = ["comment", "platform"]
