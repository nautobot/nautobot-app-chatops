"""Models for Grafana Plugin."""

from django.core.exceptions import ValidationError
from django.core.serializers.json import DjangoJSONEncoder
from django.db import models
from django.utils.translation import gettext_lazy as _
from nautobot.circuits import models as circuit_models
from nautobot.core.models.generics import OrganizationalModel, PrimaryModel
from nautobot.dcim import models as dcim_models
from nautobot.extras import models as extra_models
from nautobot.extras.utils import extras_features
from nautobot.ipam import models as ipam_models
from nautobot.tenancy import models as tenancy_models
from nautobot.virtualization import models as virtualization_models

# Valid models to be used in Panel Variables as query options. If a model doesn't exist in
# this list, you cannot set or use the `query` field in a panel variable.
VALID_MODELS = (
    dcim_models,
    ipam_models,
    extra_models,
    tenancy_models,
    virtualization_models,
    circuit_models,
)


@extras_features(
    "custom_fields",
    "custom_links",
    "custom_validators",
    "export_templates",
    "relationships",
    "statuses",
    "webhooks",
)
# pylint: disable-next=too-many-ancestors
class GrafanaDashboard(PrimaryModel):
    """Model for dashboards."""

    dashboard_slug = models.CharField(max_length=255, unique=True, blank=False)
    friendly_name = models.CharField(max_length=255, default="", blank=True)
    dashboard_uid = models.CharField(max_length=64, unique=True, blank=False)

    class Meta:
        """Metadata for the model."""

        ordering = ["dashboard_slug"]

    def __str__(self):
        """String value for HTML rendering."""
        return f"{self.dashboard_slug}"


Dashboard = GrafanaDashboard


@extras_features(
    "custom_fields",
    "custom_links",
    "custom_validators",
    "export_templates",
    "relationships",
    "webhooks",
)
# pylint: disable-next=too-many-ancestors
class GrafanaPanel(OrganizationalModel):
    """Model for GrafanaDashboard Panels."""

    dashboard = models.ForeignKey(GrafanaDashboard, on_delete=models.CASCADE)
    command_name = models.CharField(max_length=64, blank=False)
    friendly_name = models.CharField(max_length=64, default="", blank=False)
    panel_id = models.IntegerField(blank=False)
    active = models.BooleanField(default=False)

    class Meta:
        """Metadata for the model."""

        ordering = ["command_name", "dashboard"]

    def __str__(self):
        """String value for HTML rendering."""
        return f"{self.command_name}"


Panel = GrafanaPanel


@extras_features(
    "custom_fields",
    "custom_links",
    "custom_validators",
    "export_templates",
    "relationships",
    "webhooks",
)
# pylint: disable-next=too-many-ancestors
class GrafanaPanelVariable(OrganizationalModel):
    """Model for GrafanaDashboard GrafanaPanel Variables."""

    panel = models.ForeignKey(GrafanaPanel, on_delete=models.CASCADE)
    name = models.CharField(max_length=32, blank=False)
    friendly_name = models.CharField(max_length=64)
    query = models.CharField(max_length=64, verbose_name="Model")
    includeincmd = models.BooleanField(default=False)
    includeinurl = models.BooleanField(default=True)
    modelattr = models.CharField(max_length=64)
    value = models.TextField(max_length=64)
    response = models.CharField(max_length=255)
    filter = models.JSONField(blank=True, default=dict, encoder=DjangoJSONEncoder)
    positional_order = models.IntegerField(default=100)

    class Meta:
        """Metadata for the model."""

        ordering = ["name"]

    def __str__(self):
        """String value for HTML rendering."""
        return f"{self.name}"

    def clean(self):
        """Override clean to do custom validation."""
        super().clean()

        # Raise error if a query (model) is specified but an associated attribute is not.
        if self.query and not self.modelattr:
            raise ValidationError(_("A modelattr must be specified when a query is set!"))

        # Validate that the model name passed in is correct, and that the modelattr is an element
        # on the model.
        for nb_model in VALID_MODELS:
            if hasattr(nb_model, str(self.query)):
                model = getattr(nb_model, str(self.query))
                if hasattr(model, str(self.modelattr)):
                    return

                raise ValidationError(
                    _(
                        f"Nautobot model `{self.query}` does not have an attribute of `{self.modelattr}`."
                        f" {[f.name for f in model._meta.fields if not f.name.startswith('_')]}"
                    )
                )

        raise ValidationError(_(f"`{self.query}` is not a valid Nautobot model."))


PanelVariable = GrafanaPanelVariable
