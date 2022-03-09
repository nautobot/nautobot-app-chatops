"""Django models for recording user interactions with Nautobot."""

from django.core.exceptions import ValidationError
from django.db import models

from nautobot.utilities.fields import ColorField
from nautobot.extras.models.change_logging import ChangeLoggedModel
from nautobot.core.models import BaseModel

from .choices import AccessGrantTypeChoices, CommandStatusChoices, CommandTokenPlatformChoices

from .constants import (
    COMMAND_LOG_USER_NAME_HELP_TEXT,
    COMMAND_LOG_USER_ID_HELP_TEXT,
    COMMAND_LOG_PLATFORM_HELP_TEXT,
    COMMAND_LOG_COMMAND_TEXT,
    COMMAND_LOG_SUBCOMMAND_HELP_TEXT,
    COMMAND_LOG_PARAMS_HELP_TEXT,
    ACCESS_GRANT_COMMAND_HELP_TEXT,
    ACCESS_GRANT_SUBCOMMAND_HELP_TEXT,
    ACCESS_GRANT_NAME_HELP_TEXT,
    ACCESS_GRANT_VALUE_HELP_TEXT,
    COMMAND_TOKEN_COMMENT_HELP_TEXT,
    COMMAND_TOKEN_TOKEN_HELP_TEXT,
)


class CommandLog(BaseModel):
    """Record of a single fully-executed Nautobot command.

    Incomplete commands (those requiring additional user input) should not be recorded,
    nor should any "help" commands or invalid command entries.
    """

    start_time = models.DateTimeField(null=True)
    runtime = models.DurationField(null=True)

    user_name = models.CharField(max_length=255, help_text=COMMAND_LOG_USER_NAME_HELP_TEXT)
    user_id = models.CharField(max_length=255, help_text=COMMAND_LOG_USER_ID_HELP_TEXT)
    platform = models.CharField(max_length=64, help_text=COMMAND_LOG_PLATFORM_HELP_TEXT)
    platform_color = ColorField()

    command = models.CharField(max_length=64, help_text=COMMAND_LOG_COMMAND_TEXT)
    subcommand = models.CharField(max_length=64, help_text=COMMAND_LOG_SUBCOMMAND_HELP_TEXT)

    params = models.JSONField(default=list, help_text=COMMAND_LOG_PARAMS_HELP_TEXT)

    status = models.CharField(
        max_length=32,
        choices=CommandStatusChoices,
        default=CommandStatusChoices.STATUS_SUCCEEDED,
    )
    details = models.CharField(max_length=255, default="")

    csv_headers = ["Start Time", "Username", "Command", "Subcommand", "Params", "Status"]

    def to_csv(self):
        """Indicates model fields to return as csv."""
        return (
            self.start_time,
            self.user_name,
            self.command,
            self.subcommand,
            self.params if self.params else "",
            self.status,
        )

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

    command = models.CharField(max_length=64, help_text=ACCESS_GRANT_COMMAND_HELP_TEXT)
    subcommand = models.CharField(
        max_length=64,
        help_text=ACCESS_GRANT_SUBCOMMAND_HELP_TEXT,
    )

    grant_type = models.CharField(max_length=32, choices=AccessGrantTypeChoices)

    name = models.CharField(max_length=255, help_text=ACCESS_GRANT_NAME_HELP_TEXT)
    value = models.CharField(
        max_length=255,
        help_text=ACCESS_GRANT_VALUE_HELP_TEXT,
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

    comment = models.CharField(max_length=255, help_text=COMMAND_TOKEN_COMMENT_HELP_TEXT, blank=True, default="")
    platform = models.CharField(max_length=32, choices=CommandTokenPlatformChoices)
    token = models.CharField(max_length=255, help_text=COMMAND_TOKEN_TOKEN_HELP_TEXT)

    def __str__(self):
        """String representation of a CommandToken."""
        return f'platform: "{self.platform}", token: "{self.token}", comment: "{self.comment}"'

    class Meta:
        """Meta-attributes of a CommandToken."""

        ordering = ["platform", "token", "comment"]
