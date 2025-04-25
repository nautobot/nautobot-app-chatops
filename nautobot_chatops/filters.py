"""Filtering for nautobot_chatops."""

from nautobot.apps.filters import NameSearchFilterSet, NautobotFilterSet

from nautobot_chatops import models


class CommandLogFilterSet(NameSearchFilterSet, NautobotFilterSet):  # pylint: disable=too-many-ancestors
    """Filter for CommandLog."""

    class Meta:
        """Meta attributes for filter."""

        model = models.CommandLog

        # add any fields from the model that you would like to filter your searches by using those
        fields = "__all__"
