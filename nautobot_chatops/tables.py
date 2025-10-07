"""Django table classes for Nautobot."""

from django_tables2 import Column, LinkColumn, TemplateColumn
from nautobot.core.tables import BaseTable, ButtonsColumn, ToggleColumn

# pylint: disable=W0611
from nautobot_chatops.integrations.grafana.tables import (  # noqa: F401 unused-import these imports are required for list views to work
    GrafanaDashboardTable,
    GrafanaPanelTable,
    GrafanaPanelVariableTable,
)

from .models import AccessGrant, ChatOpsAccountLink, CommandLog, CommandToken


class CommandLogTable(BaseTable):
    """Table for rendering a listing of CommandLog entries."""

    pk = ToggleColumn()
    runtime = TemplateColumn(template_code="{{ record.runtime | shorter_timedelta }}")

    # pylint: disable=line-too-long
    platform = TemplateColumn(
        template_code='<span class="label" style="background-color: #{{ record.platform_color }}">{{ record.platform }}</span>'
    )

    command = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.command }}</span>')
    subcommand = TemplateColumn(
        template_code='<span style="font-family: monospace">'
        "{% if record.subcommand %}{{ record.subcommand }}{% else %}&mdash;{% endif %}</span>"
    )
    params = TemplateColumn(
        template_code="""
{% for key, value in record.params %}
<div><strong>{{ key }}</strong>:&nbsp;{{ value }}</div>
{% empty %}
&mdash;
{% endfor %}""",
    )

    status = TemplateColumn(
        template_code='<span class="label label-{{record.status_label_class}}">{{ record.status }}</span>'
    )

    class Meta(BaseTable.Meta):
        """Metaclass attributes of CommandLogTable."""

        model = CommandLog
        fields = (
            "start_time",
            "runtime",
            "platform",
            "user_name",
            "nautobot_user",
            "command",
            "subcommand",
            "params",
            "status",
            "details",
        )
        default_columns = ("start_time", "user_name", "nautobot_user", "command", "subcommand", "params", "status")


class AccessGrantTable(BaseTable):
    """Table for rendering a listing of AccessGrant entries."""

    pk = ToggleColumn()

    command = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.command }}</span>')

    subcommand = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.subcommand }}</span>')

    grant_type = TemplateColumn(template_code='<span class="label label-success">{{ record.grant_type }}</span>')

    value = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.value }}</span>')
    name = Column(linkify=True)

    actions = ButtonsColumn(AccessGrant)

    class Meta(BaseTable.Meta):
        """Metaclass attributes of AccessGrantTable."""

        model = AccessGrant
        fields = ("pk", "command", "subcommand", "grant_type", "name", "value", "actions")
        default_columns = ("pk", "command", "subcommand", "grant_type", "name", "actions")


class CommandTokenTable(BaseTable):
    """Table for rendering a listing of CommandToken entries."""

    pk = ToggleColumn()

    platform = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.platform }}</span>')

    token = Column(linkify=True)

    comment = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.comment }}</span>')

    actions = ButtonsColumn(CommandToken)

    class Meta(BaseTable.Meta):
        """Metaclass attributes of CommandTokenTable."""

        model = CommandToken
        fields = ("pk", "platform", "token", "comment", "actions")
        default_columns = ("pk", "platform", "token", "comment", "actions")


class ChatOpsAccountLinkTable(BaseTable):
    """Table for listing the Account Links."""

    pk = ToggleColumn()
    user_id = LinkColumn()
    actions = ButtonsColumn(ChatOpsAccountLink)

    class Meta(BaseTable.Meta):
        """Metaclass for attributes of ChatOps Account Links."""

        model = ChatOpsAccountLink
        fields = ("pk", "user_id", "platform", "nautobot_user", "email", "actions")
        default_columns = ("pk", "user_id", "platform", "nautobot_user", "email", "actions")
