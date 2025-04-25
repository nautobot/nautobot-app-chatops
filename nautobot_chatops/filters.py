"""Django FilterSet classes for Nautobot."""

import django_filters
from nautobot.apps.filters import BaseFilterSet, NautobotFilterSet, SearchFilter

from nautobot_chatops.choices import PlatformChoices
from nautobot_chatops.models import AccessGrant, ChatOpsAccountLink, CommandLog, CommandToken


class CommandLogFilterSet(NameSearchFilterSet, NautobotFilterSet):  # pylint: disable=too-many-ancestors
    """Filter for CommandLog."""

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

        # add any fields from the model that you would like to filter your searches by using those
        fields = "__all__"
