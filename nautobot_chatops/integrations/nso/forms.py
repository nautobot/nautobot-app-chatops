"""Forms for Nautobot."""

from django.forms import ModelForm, CharField
from nautobot.core.forms import BootstrapMixin, DynamicModelChoiceField
from nautobot.dcim.models.devices import Platform
from nautobot.extras.models import Role
from nautobot_chatops.integrations.nso.models import NSOCommandFilter


class NSOCommandFilterForm(BootstrapMixin, ModelForm):
    """Form for editing command filters."""

    command = CharField(
        max_length=200, help_text=" Supports <a href='https://pythex.org/' target='_blank'>Regular Expression</a>."
    )
    role = DynamicModelChoiceField(queryset=Role.objects.all())
    platform = DynamicModelChoiceField(
        queryset=Platform.objects.all(),
    )

    class Meta:
        """Metaclass attributes of the command filters form."""

        model = NSOCommandFilter

        fields = ("command", "role", "platform")
