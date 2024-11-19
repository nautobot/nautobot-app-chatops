"""Django models for recording user interactions with Nautobot."""

from django.conf import settings
from django.core.exceptions import ValidationError
from django.db import models
from django.urls import reverse
from nautobot.core.models.fields import ColorField
from nautobot.core.models.generics import PrimaryModel

from .choices import AccessGrantTypeChoices, CommandStatusChoices, PlatformChoices
from .constants import (
    ACCESS_GRANT_COMMAND_HELP_TEXT,
    ACCESS_GRANT_NAME_HELP_TEXT,
    ACCESS_GRANT_SUBCOMMAND_HELP_TEXT,
    ACCESS_GRANT_VALUE_HELP_TEXT,
    CHATOPS_USER_ID_HELP_TEXT,
    COMMAND_LOG_COMMAND_TEXT,
    COMMAND_LOG_PARAMS_HELP_TEXT,
    COMMAND_LOG_PLATFORM_HELP_TEXT,
    COMMAND_LOG_SUBCOMMAND_HELP_TEXT,
    COMMAND_LOG_USER_ID_HELP_TEXT,
    COMMAND_LOG_USER_NAME_HELP_TEXT,
    COMMAND_TOKEN_COMMENT_HELP_TEXT,
    COMMAND_TOKEN_TOKEN_HELP_TEXT,
)
from .integrations.grafana.models import GrafanaDashboard, GrafanaPanel, GrafanaPanelVariable


class CommandLog(PrimaryModel):  # pylint: disable=nb-string-field-blank-null
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
    nautobot_user = models.ForeignKey(
        to=settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="command_log",
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

    def get_absolute_url(self, api=False):
        """Override the objects absolute url since we have no detail view."""
        return reverse("plugins:nautobot_chatops:commandlog_list")

    class Meta:
        """Meta-attributes of a CommandLog."""

        ordering = ["start_time"]


class AccessGrant(PrimaryModel):
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

    def get_absolute_url(self, api=False):
        """Override the objects absolute url since we have no detail view."""
        return reverse("plugins:nautobot_chatops:accessgrant_list")

    class Meta:
        """Meta-attributes of an AccessGrant."""

        ordering = ["command", "subcommand", "grant_type"]
        unique_together = [["command", "subcommand", "grant_type", "value"]]


class CommandToken(PrimaryModel):
    """Record of a Token granted for the chat platform and chat command."""

    comment = models.CharField(max_length=255, help_text=COMMAND_TOKEN_COMMENT_HELP_TEXT, blank=True, default="")
    platform = models.CharField(max_length=32, choices=PlatformChoices)
    token = models.CharField(max_length=255, help_text=COMMAND_TOKEN_TOKEN_HELP_TEXT)

    def __str__(self):
        """String representation of a CommandToken."""
        return f'platform: "{self.platform}", token: "{self.token}", comment: "{self.comment}"'

    def get_absolute_url(self, api=False):
        """Override the objects absolute url since we have no detail view."""
        return reverse("plugins:nautobot_chatops:commandtoken_list")

    class Meta:
        """Meta-attributes of a CommandToken."""

        ordering = ["platform", "token", "comment"]
        unique_together = [["platform", "token"]]


class ChatOpsAccountLink(PrimaryModel):
    """Connect ChatOps User with Nautobot User."""

    nautobot_user = models.ForeignKey(
        to=settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="chatops_user",
        verbose_name="User",
    )
    platform = models.CharField(max_length=32, choices=PlatformChoices)
    user_id = models.CharField(max_length=255, help_text=CHATOPS_USER_ID_HELP_TEXT, verbose_name="Chat User ID")
    email = models.EmailField(blank=True)

    def __str__(self):
        """String representation of a ChatOps Account Link."""
        return f"{self.nautobot_user.username} -> {self.platform} {self.user_id}"

    class Meta:
        """Metadata for ChatOps Account Link."""

        unique_together = [["user_id", "platform"]]
        verbose_name = "ChatOps Account Link"


__all__ = (
    "ChatOpsAccountLink",
    "CommandLog",
    "AccessGrant",
    "CommandToken",
    "GrafanaDashboard",
    "GrafanaPanel",
    "GrafanaPanelVariable",
)
