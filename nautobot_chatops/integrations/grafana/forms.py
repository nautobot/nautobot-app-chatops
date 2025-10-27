"""Forms for Nautobot."""

from django.core.serializers.json import DjangoJSONEncoder
from django.forms import (
    BooleanField,
    CharField,
    IntegerField,
    JSONField,
    ModelChoiceField,
    ModelForm,
    ModelMultipleChoiceField,
    MultipleHiddenInput,
)
from nautobot.apps.forms import NautobotBulkEditForm, NautobotFilterForm, NautobotModelForm
from nautobot.core.forms import BootstrapMixin, BulkEditForm

from nautobot_chatops.integrations.grafana.models import Dashboard, Panel, PanelVariable


class GrafanaDashboardFilterForm(NautobotFilterForm):  # pylint: disable=nb-sub-class-name
    """Form for filtering Dashboard instances."""

    model = Dashboard

    dashboard_slug = CharField(max_length=64)
    dashboard_uid = CharField(max_length=64)
    friendly_name = CharField(max_length=255)


class GrafanaDashboardForm(NautobotModelForm):  # pylint: disable=nb-sub-class-name
    """Form for editing Dashboard instances."""

    class Meta:
        """Metaclass attributes of Dashboard."""

        model = Dashboard

        fields = "__all__"


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


class GrafanaDashboardBulkEditForm(NautobotBulkEditForm):
    """Dashboard bulk edit form."""

    pk = ModelMultipleChoiceField(queryset=Dashboard.objects.all(), widget=MultipleHiddenInput)
    friendly_name = CharField(max_length=255, required=False)

    class Meta:
        """Meta attributes."""

        nullable_fields = [
            "friendly_name",
        ]


class GrafanaPanelForm(NautobotModelForm):  # pylint: disable=nb-sub-class-name
    """Form for editing Panel instances."""

    class Meta:
        """Metaclass attributes of Dashboard."""

        model = Panel

        fields = "__all__"


class PanelsSyncForm(BootstrapMixin, ModelForm):
    """Form for editing Panel instances."""

    dashboard = ModelChoiceField(queryset=Dashboard.objects.all())

    class Meta:
        """Metaclass attributes of Panel."""

        model = Panel

        fields = ("dashboard",)


class GrafanaPanelFilterForm(NautobotFilterForm):  # pylint: disable=nb-sub-class-name
    """Filter form to filter searches."""

    model = Panel

    q = CharField(required=False, label="Search")
    dashboard = ModelChoiceField(required=False, queryset=Dashboard.objects.all())
    command_name = CharField(required=False, label="Command Name")
    friendly_name = CharField(required=False, label="Friendly Name")
    panel_id = IntegerField(required=False, label="Panel ID")
    active = BooleanField(required=False)


class GrafanaPanelBulkEditForm(NautobotBulkEditForm):
    """Panel bulk edit form."""

    pk = ModelMultipleChoiceField(queryset=Panel.objects.all(), widget=MultipleHiddenInput)
    friendly_name = CharField(max_length=255, required=False)
    active = BooleanField(required=False)

    class Meta:
        """Meta attributes."""

        nullable_fields = [
            "friendly_name",
        ]


class GrafanaPanelVariableForm(NautobotModelForm):  # pylint: disable=nb-sub-class-name
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

        fields = "__all__"


class GrafanaPanelVariableFilterForm(NautobotFilterForm):  # pylint: disable=nb-sub-class-name
    """Filter form to filter searches."""

    model = PanelVariable

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


class GrafanaPanelVariableBulkEditForm(BootstrapMixin, BulkEditForm):
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
