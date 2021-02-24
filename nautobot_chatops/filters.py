"""Django FilterSet classes for Nautobot."""

from django_filters import FilterSet

from nautobot_chatops.models import CommandLog, AccessGrant, CommandToken


class CommandLogFilter(FilterSet):
    """FilterSet for filtering a set of CommandLog objects."""

    class Meta:
        """Metaclass attributes of CommandLogFilter."""

        model = CommandLog
        exclude = ["id", "platform_color", "params"]


class AccessGrantFilter(FilterSet):
    """FilterSet for filtering a set of AccessGrant objects."""

    class Meta:
        """Metaclass attributes of AccessGrantFilter."""

        model = AccessGrant
        exclude = ["id", "name"]


class CommandTokenFilter(FilterSet):
    """FilterSet for filtering a set of CommandToken objects."""

    class Meta:
        """Metaclass attributes of CommandTokenFilter."""

        model = CommandToken
        exclude = ["id", "token"]
