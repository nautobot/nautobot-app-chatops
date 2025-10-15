"""Filtering for Nautobot ChatOps Grafana integration."""

from django.db.models import Q
from django_filters import CharFilter, FilterSet
from nautobot.apps.filters import NautobotFilterSet

from nautobot_chatops.integrations.grafana.models import Dashboard, Panel, PanelVariable


class GrafanaDashboardFilterSet(NautobotFilterSet):  # pylint: disable=nb-sub-class-name
    """Filter for Dashboards."""

    q = CharFilter(method="search", label="Search")

    class Meta:
        """Meta attributes for filter."""

        model = Dashboard

        fields = "__all__"

    def search(self, queryset, name, value):  # pylint: disable=unused-argument
        """Perform the filtered search."""
        if not value.strip():
            return queryset
        qs_filter = (
            Q(dashboard_slug__icontains=value) | Q(dashboard_uid__icontains=value) | Q(friendly_name__icontains=value)
        )
        return queryset.filter(qs_filter)


class GrafanaPanelFilterSet(NautobotFilterSet):  # pylint: disable=nb-sub-class-name
    """Filter for Panels."""

    q = CharFilter(method="search", label="Search")

    class Meta:
        """Meta attributes for filter."""

        model = Panel

        fields = "__all__"

    def search(self, queryset, name, value):  # pylint: disable=unused-argument
        """Perform the filtered search."""
        if not value.strip():
            return queryset

        qs_filter = (
            Q(dashboard__dashboard_slug__icontains=value)
            | Q(command_name__icontains=value)
            | Q(friendly_name__icontains=value)
            | Q(panel_id__icontains=value) & Q(action=value)
        )
        return queryset.filter(qs_filter)


class VariableFilter(FilterSet):
    """Filter for PanelVariables."""

    q = CharFilter(method="search", label="Search")

    class Meta:
        """Meta attributes for filter."""

        model = PanelVariable

        fields = ("panel", "name", "friendly_name", "query", "modelattr", "value", "response")

    def search(self, queryset, name, value):  # pylint: disable=unused-argument
        """Perform the filtered search."""
        if not value.strip():
            return queryset
        qs_filter = (
            Q(name__icontains=value)
            | Q(friendly_name__icontains=value)
            | Q(query__icontains=value)
            | Q(modelattr__icontains=value)
            | Q(value__icontains=value)
            | Q(response__icontains=value)
            | Q(includeincmd=value)
            | Q(includeinurl=value)
            | Q(panel=value)
        )
        return queryset.filter(qs_filter)
