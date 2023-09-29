"""Django table classes for Nautobot."""

from django_tables2 import TemplateColumn, Column, BooleanColumn
from nautobot.core.tables import BaseTable, ToggleColumn, ButtonsColumn
from nautobot_chatops.integrations.grafana.models import Panel, Dashboard, PanelVariable


class DashboardViewTable(BaseTable):
    """Table for rendering panels for dashboards in the grafana plugin."""

    pk = ToggleColumn()

    actions = ButtonsColumn(Dashboard, buttons=("changelog", "edit", "delete"))

    class Meta(BaseTable.Meta):  # pylint: disable=too-few-public-methods
        """Meta for class DashboardViewTable."""

        model = Dashboard
        fields = ("pk", "dashboard_slug", "dashboard_uid", "friendly_name", "actions")


class PanelViewTable(BaseTable):
    """Table for rendering panels for dashboards in the grafana plugin."""

    pk = ToggleColumn()

    actions = ButtonsColumn(Panel, buttons=("changelog", "edit", "delete"))

    chat_command = TemplateColumn(
        template_code="<span class='text-muted'><i>/grafana get-{{ record.command_name }}</i></span>",
        verbose_name="Chat Command",
    )
    active = BooleanColumn(yesno="🟢,🔴")

    class Meta(BaseTable.Meta):  # pylint: disable=too-few-public-methods
        """Meta for class PanelViewTable."""

        model = Panel
        fields = ("pk", "chat_command", "command_name", "friendly_name", "panel_id", "dashboard", "active", "actions")


class PanelVariableViewTable(BaseTable):
    """Table for rendering panel variables for dashboards in the grafana plugin."""

    pk = ToggleColumn()

    actions = ButtonsColumn(PanelVariable, buttons=("changelog", "edit", "delete"))
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

        model = PanelVariable
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
