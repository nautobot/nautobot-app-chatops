"""Forms for Nautobot."""

from django import forms

from nautobot.utilities.forms import BootstrapMixin

from .models import AccessGrant, CommandToken
from .choices import AccessGrantTypeChoices, CommandTokenPlatformChoices


BLANK_CHOICE = (("", "--------"),)


class AccessGrantFilterForm(BootstrapMixin, forms.ModelForm):
    """Form for filtering AccessGrant instances."""

    command = forms.CharField(required=False)
    subcommand = forms.CharField(required=False)

    grant_type = forms.ChoiceField(choices=BLANK_CHOICE + AccessGrantTypeChoices.CHOICES, required=False)

    class Meta:
        """Metaclass attributes of AccessGrantFilterForm."""

        model = AccessGrant

        fields = ("command", "subcommand", "grant_type")


class AccessGrantForm(BootstrapMixin, forms.ModelForm):
    """Form for creating or editing an AccessGrant instance."""

    grant_type = forms.ChoiceField(choices=BLANK_CHOICE + AccessGrantTypeChoices.CHOICES)

    class Meta:
        """Metaclass attributes of AccessGrantForm."""

        model = AccessGrant

        fields = ("command", "subcommand", "grant_type", "name", "value")


class CommandTokenFilterForm(BootstrapMixin, forms.ModelForm):
    """Form for filtering ComandToken instances."""

    platform = forms.ChoiceField(choices=CommandTokenPlatformChoices.CHOICES)
    comment = forms.CharField(required=False)

    class Meta:
        """Metaclass attributes of CommandTokenFilterForm."""

        model = CommandToken

        fields = ("platform", "comment")


class CommandTokenForm(BootstrapMixin, forms.ModelForm):
    """Form for creating or editing an CommandToken instance."""

    platform = forms.ChoiceField(choices=CommandTokenPlatformChoices.CHOICES, required=True)

    class Meta:
        """Metaclass attributes of CommandTokenForm."""

        model = CommandToken

        fields = ("platform", "comment", "token")
