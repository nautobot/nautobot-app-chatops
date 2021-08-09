"""ChoiceSet classes for Nautobot."""

from nautobot.utilities.choices import ChoiceSet


class AccessGrantTypeChoices(ChoiceSet):
    """Choices for the AccessGrant grant_type field."""

    TYPE_ORGANIZATION = "organization"
    TYPE_CHANNEL = "channel"
    TYPE_USER = "user"

    CHOICES = (
        (TYPE_ORGANIZATION, "Organization"),
        (TYPE_CHANNEL, "Channel"),
        (TYPE_USER, "User"),
    )


class CommandStatusChoices(ChoiceSet):
    """Choices for the CommandLog status field."""

    STATUS_UNKNOWN = "unknown"
    STATUS_BLOCKED = "blocked"
    STATUS_SUCCEEDED = "succeeded"
    STATUS_FAILED = "failed"
    STATUS_ERRORED = "errored"

    CHOICES = (
        (STATUS_SUCCEEDED, "Succeeded"),
        (STATUS_BLOCKED, "Blocked by policy"),
        (STATUS_FAILED, "Failed"),
        (STATUS_ERRORED, "Errored"),
        (STATUS_UNKNOWN, "Unknown/invalid"),
    )


class CommandTokenPlatformChoices(ChoiceSet):
    """Choices for the CommandToken platform field."""

    MATTERMOST = "mattermost"
    SLACK = "slack"
    MS_TEAMS = "microsoft_teams"
    WEBEX = "webex"

    CHOICES = ((MATTERMOST, "Mattermost"),)
