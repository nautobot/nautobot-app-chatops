"""Forms for nautobot_chatops."""

from django import forms
from nautobot.apps.forms import NautobotBulkEditForm, NautobotFilterForm, NautobotModelForm, TagsBulkEditFormMixin

from nautobot_chatops import models


class CommandLogForm(NautobotModelForm):  # pylint: disable=too-many-ancestors
    """CommandLog creation/edit form."""

    class Meta:
        """Meta attributes."""

        model = models.CommandLog
        fields = [
            "name",
            "description",
        ]


class CommandLogBulkEditForm(TagsBulkEditFormMixin, NautobotBulkEditForm):  # pylint: disable=too-many-ancestors
    """CommandLog bulk edit form."""

    pk = forms.ModelMultipleChoiceField(queryset=models.CommandLog.objects.all(), widget=forms.MultipleHiddenInput)
    description = forms.CharField(required=False)

    class Meta:
        """Meta attributes."""

        nullable_fields = [
            "description",
        ]


class CommandLogFilterForm(NautobotFilterForm):
    """Filter form to filter searches."""

    model = models.CommandLog
    field_order = ["q", "name"]

    q = forms.CharField(
        required=False,
        label="Search",
        help_text="Search within Name or Slug.",
    )
    name = forms.CharField(required=False, label="Name")
