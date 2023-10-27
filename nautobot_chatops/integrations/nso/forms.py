"""Forms for Nautobot."""

from django.forms import ModelForm, CharField
from nautobot.utilities.forms import BootstrapMixin
from nautobot.dcim.models.devices import Platform, DeviceRole
from nautobot.utilities.forms import DynamicModelChoiceField
from nautobot_plugin_chatops_nso.models import CommandFilter


class CommandFilterForm(BootstrapMixin, ModelForm):
    """Form for editing command filters."""

    command = CharField(
        max_length=200, help_text=" Supports <a href='https://pythex.org/' target='_blank'>Regular Expression</a>."
    )
    device_role = DynamicModelChoiceField(queryset=DeviceRole.objects.all())
    platform = DynamicModelChoiceField(
        queryset=Platform.objects.all(),
    )

    class Meta:
        """Metaclass attributes of the command filters form."""

        model = CommandFilter

        fields = ("command", "device_role", "platform")
