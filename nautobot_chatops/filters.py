"""Django FilterSet classes for Nautobot."""

import django_filters
from nautobot.apps.filters import NautobotFilterSet, SearchFilter

from nautobot_chatops.choices import PlatformChoices
from nautobot_chatops.integrations.grafana.filters import (
    DashboardFilterSet as GrafanaDashboardIntegrationFilterSet,
)
from nautobot_chatops.models import AccessGrant, ChatOpsAccountLink, CommandLog, CommandToken


class CommandLogFilterSet(NautobotFilterSet):
    """FilterSet for filtering a set of CommandLog objects."""

    q = SearchFilter(
        filter_predicates={
            "user_name": "icontains",
            "nautobot_user__username": "icontains",
            "platform": "icontains",
            "command": "icontains",
            "subcommand": "icontains",
            "status": "icontains",
            "details": "icontains",
        },
    )

    class Meta:
        """Metaclass attributes of CommandLogFilterSet."""

        model = CommandLog
        fields = "__all__"


class AccessGrantFilterSet(NautobotFilterSet):
    """FilterSet for filtering a set of AccessGrant objects."""

    q = SearchFilter(
        filter_predicates={
            "name": "icontains",
            "command": "icontains",
            "subcommand": "icontains",
            "value": "icontains",
            "grant_type": "icontains",
        },
    )

    class Meta:
        """Metaclass attributes of AccessGrantFilterSet."""

        model = AccessGrant
        fields = "__all__"


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


class CommandTokenFilterSet(NautobotFilterSet):
    """FilterSet for filtering a set of CommandToken objects."""

    q = SearchFilter(
        filter_predicates={
            "comment": "icontains",
            "platform": "icontains",
        },
    )

    class Meta:
        """Metaclass attributes of CommandTokenFilterSet."""

        model = CommandToken
        fields = "__all__"


# Re-export Grafana dashboard filter for Nautobot's lookup utilities.
GrafanaDashboardFilterSet = GrafanaDashboardIntegrationFilterSet
