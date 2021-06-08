"""Django table classes for Nautobot."""

from django_tables2 import TemplateColumn

from nautobot.utilities.tables import BaseTable, ToggleColumn

from .models import CommandLog, AccessGrant, CommandToken


class CommandLogTable(BaseTable):
    """Table for rendering a listing of CommandLog entries."""

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
            "command",
            "subcommand",
            "params",
            "status",
            "details",
        )
        default_columns = ("start_time", "user_name", "command", "subcommand", "params", "status")


class AccessGrantTable(BaseTable):
    """Table for rendering a listing of AccessGrant entries."""

    pk = ToggleColumn()

    command = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.command }}</span>')

    subcommand = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.subcommand }}</span>')

    grant_type = TemplateColumn(template_code='<span class="label label-success">{{ record.grant_type }}</span>')

    value = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.value }}</span>')

    actions = TemplateColumn(
        template_code="""
<a href="{% url 'plugins:nautobot_chatops:accessgrant_changelog' pk=record.pk %}" class="btn btn-default btn-xs" title="Change log"><span class="mdi mdi-history"></span></a>
{% if perms.nautobot_chatops.change_accessgrant %}
<a href="{% url 'plugins:nautobot_chatops:accessgrant_edit' pk=record.pk %}" class="btn btn-xs btn-warning"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
{% endif %}""",
        attrs={"td": {"class": "text-right noprint"}},
        verbose_name="",
    )

    class Meta(BaseTable.Meta):
        """Metaclass attributes of AccessGrantTable."""

        model = AccessGrant
        fields = ("pk", "command", "subcommand", "grant_type", "name", "value", "actions")
        default_columns = ("pk", "command", "subcommand", "grant_type", "name", "actions")


class CommandTokenTable(BaseTable):
    """Table for rendering a listing of CommandToken entries."""

    pk = ToggleColumn()

    platform = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.platform }}</span>')

    token = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.token }}</span>')

    comment = TemplateColumn(template_code='<span style="font-family: monospace">{{ record.comment }}</span>')

    actions = TemplateColumn(
        template_code="""
<a href="{% url 'plugins:nautobot_chatops:commandtoken_changelog' pk=record.pk %}" class="btn btn-default btn-xs" title="Change log"><span class="mdi mdi-history"></span></a>
{% if perms.nautobot_chatops.change_commandtoken %}
<a href="{% url 'plugins:nautobot_chatops:commandtoken_edit' pk=record.pk %}" class="btn btn-xs btn-warning"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
{% endif %}""",
        attrs={"td": {"class": "text-right noprint"}},
        verbose_name="",
    )

    class Meta(BaseTable.Meta):
        """Metaclass attributes of CommandTokenTable."""

        model = CommandToken
        fields = ("pk", "platform", "token", "comment", "actions")
        default_columns = ("pk", "platform", "comment", "actions")
