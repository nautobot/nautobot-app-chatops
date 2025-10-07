"""Django table classes for Nautobot."""

from django.utils.html import format_html, format_html_join
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

    # pylint: disable=line-too-long
    platform = TemplateColumn(
        template_code='<span class="label" style="background-color: #{{ record.platform_color }}">{{ record.platform }}</span>'
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

    def render_params(self, record):
        """Render the params column."""
        if record.params:
            return format_html_join("", "<strong>{}</strong>:&nbsp;{}<br>", ((key, value) for key, value in record.params))
        return self.default

    def render_status(self, record):
        """Render the status column."""
        if record.status:
            return format_html("<span class='label label-{}'>{}</span>", record.status_label_class, record.status)
        return self.default


class AccessGrantTable(BaseTable):
    """Table for rendering a listing of AccessGrant entries."""

    pk = ToggleColumn()
    name = Column(linkify=True)

    actions = ButtonsColumn(AccessGrant)

    class Meta(BaseTable.Meta):
        """Metaclass attributes of AccessGrantTable."""

        model = AccessGrant
        fields = ("pk", "name", "value", "command", "subcommand", "grant_type", "actions")
        default_columns = ("pk", "name", "command", "subcommand", "grant_type", "actions")


class CommandTokenTable(BaseTable):
    """Table for rendering a listing of CommandToken entries."""

    pk = ToggleColumn()
    token = Column(linkify=True)
    actions = ButtonsColumn(CommandToken)

    class Meta(BaseTable.Meta):
        """Metaclass attributes of CommandTokenTable."""

        model = CommandToken
        fields = ("pk", "token", "platform", "comment", "actions")
        default_columns = ("pk", "token", "platform", "comment", "actions")


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
