"""Django table classes for Nautobot."""
import django_tables2 as tables
from django_tables2 import TemplateColumn
from nautobot.utilities.tables import BaseTable, ColoredLabelColumn
from nautobot_plugin_chatops_nso.models import CommandFilter


def _action_template(view: str) -> str:
    return f"""
<a  href="{{% url 'plugins:nautobot_plugin_chatops_nso:{view}_changelog' pk=record.pk %}}"
    class="btn btn-default btn-xs" title="Change log">
        <span class="mdi mdi-history"></span>
</a>

<a  href="{{% url 'plugins:nautobot_plugin_chatops_nso:{view}_update' pk=record.pk %}}"
    class="btn btn-xs btn-warning">
        <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
</a>

<a  href="{{% url 'plugins:nautobot_plugin_chatops_nso:{view}_delete' pk=record.pk %}}"
    class="btn btn-xs btn-danger">
        <i class="mdi mdi-trash-can-outline" aria-hidden="true"></i>
</a>"""


class CommandFilterTable(BaseTable):
    """Table for rendering filter commands."""

    command = TemplateColumn(
        template_code="<span>{{ record.command }}</span>",
        attrs={"span": {"class": "text-secondary"}},
        verbose_name="Command Regex",
    )

    device_role = ColoredLabelColumn(linkify=True, verbose_name="Role")

    platform = tables.Column(linkify=True, verbose_name="Platform")

    actions = TemplateColumn(
        template_code=_action_template("commandfilter"),
        attrs={"td": {"class": "text-right noprint"}},
        verbose_name="",
    )

    class Meta(BaseTable.Meta):  # pylint: disable=too-few-public-methods
        """Meta for class PanelViewTable."""

        model = CommandFilter
        fields = ("command", "device_role", "platform")
