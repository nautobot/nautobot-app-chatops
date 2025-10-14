"""Forms for Nautobot."""

from django import forms
from nautobot_chatops.integrations.grafana.forms import (
    GrafanaDashboardBulkEditForm as GrafanaDashboardIntegrationBulkEditForm,
)

from nautobot.apps.forms import (
    NautobotBulkEditForm,
    NautobotFilterForm,
    NautobotModelForm,
    StaticSelect2Multiple,
    add_blank_choice,
)

from .choices import AccessGrantTypeChoices, CommandStatusChoices, PlatformChoices
from .constants import ACCESS_GRANT_COMMAND_HELP_TEXT, COMMAND_TOKEN_TOKEN_HELP_TEXT
from .models import AccessGrant, ChatOpsAccountLink, CommandLog, CommandToken


class AccessGrantFilterForm(NautobotFilterForm):
    """Form for filtering AccessGrant instances."""

    model = AccessGrant
    command = forms.CharField(required=False)
    subcommand = forms.CharField(required=False)
    grant_type = forms.ChoiceField(choices=add_blank_choice(AccessGrantTypeChoices.CHOICES), required=False)


class AccessGrantForm(NautobotModelForm):
    """Form for creating or editing an AccessGrant instance."""

    command = forms.CharField(
        max_length=64,
        help_text=ACCESS_GRANT_COMMAND_HELP_TEXT,
        widget=forms.TextInput(attrs={"autofocus": True}),
    )

    class Meta:
        """Metaclass attributes of AccessGrantForm."""

        model = AccessGrant
        fields = "__all__"


class AccessGrantBulkEditForm(NautobotBulkEditForm):
    """Form for bulk editing AccessGrants."""

    pk = forms.ModelMultipleChoiceField(queryset=AccessGrant.objects.all(), widget=forms.MultipleHiddenInput)

    class Meta:
        """Metaclass attributes of AccessGrantFormBulkEditForm."""

        nullable_fields = []


class ChatOpsAccountLinkForm(NautobotModelForm):
    """Form for creating or editing a ChatOps Account Link instance."""

    platform = forms.ChoiceField(choices=PlatformChoices.CHOICES)

    class Meta:
        """Metaclass attributes of ChatOpsAccountLinkForm."""

        model = ChatOpsAccountLink
        fields = ("platform", "email", "user_id")  # pylint: disable = nb-use-fields-all


class ChatOpsAccountLinkBulkEditForm(NautobotBulkEditForm):
    """Form for bulk editing ChatOpsAccountLink."""

    pk = forms.ModelMultipleChoiceField(queryset=ChatOpsAccountLink.objects.all(), widget=forms.MultipleHiddenInput)

    class Meta:
        """Metaclass attributes of CommandTokenBulkEditForm."""

        nullable_fields = []


class ChatOpsAccountLinkFilterForm(NautobotFilterForm):
    """Form for filtering ChatOps Account Link Instances."""

    model = ChatOpsAccountLink
    field_order = [
        "q",
        "platform",
    ]
    q = forms.CharField(required=False, label="Search")
    platform = forms.MultipleChoiceField(choices=PlatformChoices, required=False, widget=StaticSelect2Multiple())


class CommandLogFilterForm(NautobotFilterForm):
    """Form for filtering Command Logs."""

    platform = forms.ChoiceField(choices=PlatformChoices.CHOICES, required=False, widget=StaticSelect2Multiple())
    command = forms.CharField(required=False)
    subcommand = forms.CharField(required=False)
    status = forms.ChoiceField(choices=add_blank_choice(CommandStatusChoices.CHOICES), required=False)
    details = forms.CharField(required=False)
    model = CommandLog


class CommandTokenFilterForm(NautobotFilterForm):
    """Form for filtering ComandToken instances."""

    model = CommandToken
    platform = forms.ChoiceField(choices=PlatformChoices.CHOICES)
    comment = forms.CharField(required=False)


class CommandTokenForm(NautobotModelForm):
    """Form for creating or editing an CommandToken instance."""

    token = forms.CharField(
        max_length=255,
        help_text=COMMAND_TOKEN_TOKEN_HELP_TEXT,
        widget=forms.TextInput(attrs={"autofocus": True}),
    )
    platform = forms.ChoiceField(choices=PlatformChoices.CHOICES, required=True)

    class Meta:
        """Metaclass attributes of CommandTokenForm."""

        model = CommandToken

        fields = "__all__"


class CommandTokenBulkEditForm(NautobotBulkEditForm):
    """Form for bulk editing CommandTokens."""

    pk = forms.ModelMultipleChoiceField(queryset=CommandToken.objects.all(), widget=forms.MultipleHiddenInput)
    comment = forms.CharField(max_length=255, required=False)

    class Meta:
        """Metaclass attributes of CommandTokenBulkEditForm."""

        nullable_fields = [
            "comment",
        ]


# Re-export Grafana dashboard bulk edit form for Nautobot's lookup utilities.
GrafanaDashboardBulkEditForm = GrafanaDashboardIntegrationBulkEditForm
