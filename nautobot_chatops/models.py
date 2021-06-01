"""Django models for recording user interactions with Nautobot."""

from django.core.exceptions import ValidationError
from django.db import models
from django.contrib.postgres.fields import ArrayField

from nautobot.utilities.fields import ColorField
from nautobot.extras.models.change_logging import ChangeLoggedModel
from nautobot.core.models import BaseModel

from .choices import AccessGrantTypeChoices, CommandStatusChoices, CommandTokenPlatformChoices


class CommandLog(BaseModel):
    """Record of a single fully-executed Nautobot command.

    Incomplete commands (those requiring additional user input) should not be recorded,
    nor should any "help" commands or invalid command entries.
    """

    start_time = models.DateTimeField(null=True)
    runtime = models.DurationField(null=True)

    user_name = models.CharField(max_length=255, help_text="Invoking username")
    user_id = models.CharField(max_length=255, help_text="Invoking user ID")
    platform = models.CharField(max_length=64, help_text="Chat platform")
    platform_color = ColorField()

    command = models.CharField(max_length=64, help_text="Command issued")
    subcommand = models.CharField(max_length=64, help_text="Sub-command issued")
    params = ArrayField(
        ArrayField(models.CharField(default="", max_length=255)), default=list, help_text="user_input_parameters"
    )

    status = models.CharField(
        max_length=32,
        choices=CommandStatusChoices,
        default=CommandStatusChoices.STATUS_SUCCEEDED,
    )
    details = models.CharField(max_length=255, default="")

    @property
    def status_label_class(self):
        """Bootstrap CSS label class for each status value."""
        # pylint: disable=no-else-return
        if self.status == CommandStatusChoices.STATUS_SUCCEEDED:
            return "success"
        elif self.status == CommandStatusChoices.STATUS_BLOCKED:
            return "default"
        elif self.status == CommandStatusChoices.STATUS_FAILED:
            return "warning"
        else:  # STATUS_ERRORED, STATUS_UNKNOWN
            return "danger"

    def __str__(self):
        """String representation of a CommandLog entry."""
        return f"{self.user_name} on {self.platform}: {self.command} {self.subcommand} {self.params} ({self.status})"

    class Meta:
        """Meta-attributes of a CommandLog."""

        ordering = ["start_time"]


class AccessGrant(BaseModel, ChangeLoggedModel):
    """Record of a single form of access granted to the chatbot."""

    command = models.CharField(max_length=64, help_text="Enter <tt>*</tt> to grant access to all commands")
    subcommand = models.CharField(
        max_length=64,
        help_text="Enter <tt>*</tt> to grant access to all subcommands of the given command",
    )

    grant_type = models.CharField(max_length=32, choices=AccessGrantTypeChoices)

    name = models.CharField(max_length=255, help_text="Organization name, channel name, or user name")
    value = models.CharField(
        max_length=255,
        help_text=(
            "Corresponding ID value to grant access to.<br>"
            "Enter <tt>*</tt> to grant access to all organizations, channels, or users"
        ),
    )

    def clean(self):
        """Model validation logic."""
        super().clean()
        if self.command == "*" and self.subcommand != "*":
            raise ValidationError("Use of a command wildcard with a non-wildcard subcommand is not permitted")

    def __str__(self):
        """String representation of an AccessGrant."""
        return f'cmd: "{self.command} {self.subcommand}", {self.grant_type}: "{self.name}" ({self.value})'

    class Meta:
        """Meta-attributes of an AccessGrant."""

        ordering = ["command", "subcommand", "grant_type"]


class CommandToken(BaseModel, ChangeLoggedModel):
    """Record of a Token granted for the chat platform and chat command."""

    comment = models.CharField(max_length=255, help_text="Optional: Enter description of token", blank=True, default="")
    platform = models.CharField(max_length=32, choices=CommandTokenPlatformChoices)
    token = models.CharField(max_length=255, help_text="Token given by chat platform for signing or command validation")

    def __str__(self):
        """String representation of a CommandToken."""
        return f'platform: "{self.platform}", token: "{self.token}", comment: "{self.comment}"'

    class Meta:
        """Meta-attributes of a CommandToken."""

        ordering = ["platform", "token", "comment"]
