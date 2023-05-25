"""Forms for Nautobot."""

from django.forms import (
    ModelForm,
    CharField,
    IntegerField,
    BooleanField,
    JSONField,
    ModelChoiceField,
    ModelMultipleChoiceField,
    MultipleHiddenInput,
)
from django.core.serializers.json import DjangoJSONEncoder
from nautobot.utilities.forms import BootstrapMixin
from nautobot.extras.forms import CustomFieldModelCSVForm
from nautobot.utilities.forms import BulkEditForm
from nautobot_chatops.integrations.grafana.models import Dashboard, Panel, PanelVariable


class DashboardsForm(BootstrapMixin, ModelForm):
    """Form for editing Dashboard instances."""

    dashboard_slug = CharField(max_length=64)
    dashboard_uid = CharField(max_length=64)
    friendly_name = CharField(max_length=255)

    class Meta:
        """Metaclass attributes of Dashboard."""

        model = Dashboard

        fields = ("dashboard_slug", "dashboard_uid", "friendly_name")


class DashboardsFilterForm(BootstrapMixin, ModelForm):
    """Filter form to filter searches."""

    q = CharField(required=False, label="Search")
    dashboard_slug = CharField(required=False, label="Slug")
    dashboard_uid = CharField(required=False, label="Grafana Dashboard UID")
    friendly_name = CharField(required=False, label="Friendly Name")

    class Meta:
        """Meta attributes."""

        model = Dashboard

        fields = ("q", "dashboard_slug", "dashboard_uid", "friendly_name")

        widgets = {}


class DashboardCSVForm(CustomFieldModelCSVForm):
    """Form for creating bulk dashboards."""

    class Meta:
        """Meta attributes."""

        model = Dashboard
        fields = Dashboard.csv_headers


class DashboardBulkEditForm(BootstrapMixin, BulkEditForm):
    """Dashboard bulk edit form."""

    pk = ModelMultipleChoiceField(queryset=Dashboard.objects.all(), widget=MultipleHiddenInput)
    friendly_name = CharField(max_length=255, required=False)

    class Meta:
        """Meta attributes."""

        nullable_fields = [
            "friendly_name",
        ]


class PanelsForm(BootstrapMixin, ModelForm):
    """Form for editing Panel instances."""

    dashboard = ModelChoiceField(queryset=Dashboard.objects.all())
    command_name = CharField(max_length=64)
    friendly_name = CharField(max_length=64)
    panel_id = IntegerField()
    active = BooleanField()

    class Meta:
        """Metaclass attributes of Panel."""

        model = Panel

        fields = ("dashboard", "command_name", "friendly_name", "panel_id", "active")


class PanelsSyncForm(BootstrapMixin, ModelForm):
    """Form for editing Panel instances."""

    dashboard = ModelChoiceField(queryset=Dashboard.objects.all())

    class Meta:
        """Metaclass attributes of Panel."""

        model = Panel

        fields = ("dashboard",)


class PanelsFilterForm(BootstrapMixin, ModelForm):
    """Filter form to filter searches."""

    q = CharField(required=False, label="Search")
    dashboard = ModelChoiceField(required=False, queryset=Dashboard.objects.all())
    command_name = CharField(required=False, label="Command Name")
    friendly_name = CharField(required=False, label="Friendly Name")
    panel_id = IntegerField(required=False, label="Panel ID")
    active = BooleanField(required=False)

    class Meta:
        """Meta attributes."""

        model = Panel

        fields = ("q", "dashboard", "command_name", "friendly_name", "panel_id", "active")

        widgets = {}


class PanelsCSVForm(CustomFieldModelCSVForm):
    """Form for creating bulk Panels."""

    dashboard = ModelChoiceField(
        required=True,
        queryset=Dashboard.objects.all(),
        to_field_name="dashboard_slug",
        label="Dashboard Slug",
    )
    friendly_name = CharField(max_length=64, required=False)

    class Meta:
        """Meta attributes."""

        model = Panel
        fields = Panel.csv_headers


class PanelsBulkEditForm(BootstrapMixin, BulkEditForm):
    """Panels bulk edit form."""

    pk = ModelMultipleChoiceField(queryset=Panel.objects.all(), widget=MultipleHiddenInput)
    friendly_name = CharField(max_length=255, required=False)
    active = BooleanField(required=False)

    class Meta:
        """Meta attributes."""

        nullable_fields = [
            "friendly_name",
        ]


class PanelVariablesForm(BootstrapMixin, ModelForm):
    """Form for editing Panel Variable instances."""

    panel = ModelChoiceField(queryset=Panel.objects.all())
    name = CharField(max_length=32)
    friendly_name = CharField(max_length=64, required=False)
    query = CharField(max_length=64, required=False, label="Model")
    modelattr = CharField(max_length=64, required=False)
    value = CharField(max_length=64, required=False)
    response = CharField(max_length=255, required=False)
    filter = JSONField(required=False)
    includeincmd = BooleanField(required=False)
    includeinurl = BooleanField(required=False)
    positional_order = IntegerField(required=False)

    class Meta:
        """Metaclass attributes of PanelVariable Variable."""

        model = PanelVariable

        fields = tuple(PanelVariable.csv_headers)


class PanelVariablesFilterForm(BootstrapMixin, ModelForm):
    """Filter form to filter searches."""

    q = CharField(
        required=False,
        label="Search",
    )
    panel = ModelChoiceField(queryset=Panel.objects.all(), required=False)
    name = CharField(max_length=32, required=False)
    friendly_name = CharField(max_length=64, required=False)
    query = CharField(max_length=64, required=False)
    modelattr = CharField(max_length=64, required=False)
    value = CharField(max_length=64, required=False)
    response = CharField(max_length=255, required=False)
    includeincmd = BooleanField(required=False)
    includeinurl = BooleanField(required=False)
    positional_order = IntegerField(required=False)

    class Meta:
        """Meta attributes."""

        model = PanelVariable

        fields = ("q",) + tuple(PanelVariable.csv_headers[:-1])

        widgets = {}


class PanelVariablesCSVForm(CustomFieldModelCSVForm):
    """Form for creating bulk Panels."""

    panel = ModelChoiceField(
        required=True,
        queryset=Panel.objects.all(),
        to_field_name="command_name",
        label="Panel Command Name",
    )
    name = CharField(max_length=32, required=True, label="Variable Name")
    friendly_name = CharField(max_length=64, required=False, label="Friendly Name")
    query = CharField(max_length=64, required=False, label="Nautobot Query Object (i.e. 'Device')")
    modelattr = CharField(max_length=64, required=False, label="Attribute on the query object (i.e. 'name')")
    value = CharField(max_length=64, required=False, label="Jinja2 object reference value. (i.e. '{{ device.name }}')")
    response = CharField(max_length=255, required=False)
    filter = JSONField(required=False)
    includeincmd = BooleanField(required=False)
    includeinurl = BooleanField(required=False)
    positional_order = IntegerField(required=False)

    class Meta:
        """Meta attributes."""

        model = PanelVariable
        fields = PanelVariable.csv_headers


class PanelVariablesBulkEditForm(BootstrapMixin, BulkEditForm):
    """PanelVariables bulk edit form."""

    pk = ModelMultipleChoiceField(queryset=PanelVariable.objects.all(), widget=MultipleHiddenInput)
    friendly_name = CharField(max_length=64, required=False)
    query = CharField(max_length=64, required=False)
    modelattr = CharField(max_length=64, required=False)
    value = CharField(max_length=64, required=False)
    response = CharField(max_length=255, required=False)
    filter = JSONField(encoder=DjangoJSONEncoder, required=False)
    includeincmd = BooleanField(required=False)
    includeinurl = BooleanField(required=False)
    positional_order = IntegerField(required=False)

    class Meta:
        """Meta attributes."""

        nullable_fields = [
            "friendly_name",
        ]


class PanelVariablesSyncForm(BootstrapMixin, ModelForm):
    """Form for editing Panel Variable instances."""

    dashboard = ModelChoiceField(queryset=Dashboard.objects.all())

    class Meta:
        """Metaclass attributes of Panel."""

        model = Panel

        fields = ("dashboard",)
