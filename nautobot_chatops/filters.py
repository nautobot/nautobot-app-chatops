"""Django FilterSet classes for Nautobot."""

import django_filters
from nautobot.apps.filters import BaseFilterSet, NautobotFilterSet, SearchFilter

from nautobot_chatops.choices import PlatformChoices
from nautobot_chatops.models import AccessGrant, ChatOpsAccountLink, CommandLog, CommandToken


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


class ChatOpsAccountLinkFilterSet(NautobotFilterSet):
    """FilterSet for filtering the ChatOps Account Links."""

    q = SearchFilter(
        filter_predicates={
            "user_id": "icontains",
            "platform": "icontains",
        }
    )
    platform = django_filters.MultipleChoiceFilter(choices=PlatformChoices)

    class Meta:
        """Metaclass attributes of ChatOpsAccountLinkFilterSet."""

        model = ChatOpsAccountLink
        fields = "__all__"


class CommandTokenFilterSet(BaseFilterSet):
    """FilterSet for filtering a set of CommandToken objects."""

    class Meta:
        """Metaclass attributes of CommandTokenFilterSet."""

        model = CommandToken
        fields = ["comment", "platform"]
