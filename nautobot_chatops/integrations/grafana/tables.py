"""Django table classes for Nautobot."""

from django_tables2 import BooleanColumn, Column, TemplateColumn
from nautobot.core.tables import BaseTable, ButtonsColumn, ToggleColumn

from nautobot_chatops.integrations.grafana.models import GrafanaDashboard, GrafanaPanel, GrafanaPanelVariable


class GrafanaDashboardTable(BaseTable):  # pylint: disable=nb-sub-class-name
    """Table for rendering panels for dashboards in the grafana app."""

    pk = ToggleColumn()

    actions = ButtonsColumn(GrafanaDashboard, buttons=("changelog", "edit", "delete"))

    class Meta(BaseTable.Meta):  # pylint: disable=too-few-public-methods
        """Meta for class DashboardViewTable."""

        model = GrafanaDashboard
        fields = ("pk", "dashboard_slug", "dashboard_uid", "friendly_name", "actions")


class GrafanaPanelTable(BaseTable):  # pylint: disable=nb-sub-class-name
    """Table for rendering panels for dashboards in the grafana app."""

    pk = ToggleColumn()

    actions = ButtonsColumn(GrafanaPanel, buttons=("changelog", "edit", "delete"))

    chat_command = TemplateColumn(
        template_code="<span class='text-muted'><i>/grafana get-{{ record.command_name }}</i></span>",
        verbose_name="Chat Command",
    )
    active = BooleanColumn(yesno="🟢,🔴")

    class Meta(BaseTable.Meta):  # pylint: disable=too-few-public-methods
        """Meta for class PanelViewTable."""

        model = GrafanaPanel
        fields = ("pk", "chat_command", "command_name", "friendly_name", "panel_id", "dashboard", "active", "actions")


class GrafanaPanelVariableTable(BaseTable):  # pylint: disable=nb-sub-class-name
    """Table for rendering panel variables for dashboards in the grafana app."""

    pk = ToggleColumn()

    actions = ButtonsColumn(GrafanaPanelVariable, buttons=("changelog", "edit", "delete"))
    value = TemplateColumn(
        template_code=(
            "{% if record.value %}<pre class='small'>{{ record.value }}</pre>{% else %}{{ record.value}}{% endif %}"
        )
    )
    positional_order = Column(verbose_name="Order")
    includeincmd = BooleanColumn(verbose_name="In CMD", yesno="🟢,🔴")
    includeinurl = BooleanColumn(verbose_name="In URL", yesno="🟢,🔴")

    class Meta(BaseTable.Meta):  # pylint: disable=too-few-public-methods
        """Meta for class PanelVariableViewTable."""

        model = GrafanaPanelVariable
        fields = [
            "pk",
            "panel",
            "name",
            "friendly_name",
            "query",
            "modelattr",
            "value",
            "response",
            "positional_order",
            "includeincmd",
            "includeinurl",
            "filter",
            "actions",
        ]
