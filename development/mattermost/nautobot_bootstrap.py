"""Bootstrap script for Nautobot to allow Mattermost integration."""

from nautobot_chatops.models import AccessGrantTypeChoices, CommandTokenPlatformChoices, AccessGrant, CommandToken

for grant_type in AccessGrantTypeChoices.values():
    AccessGrant.objects.update_or_create(
        command="*",
        subcommand="*",
        grant_type=grant_type,
        name="*",
        value="*",
    )

CommandToken.objects.update_or_create(
    comment="nautobot",
    platform=CommandTokenPlatformChoices.MATTERMOST,
    # The following token is safe to store in the repo because it is only used for local development.
    token="rmdpfdjhnpg988e7ujzyom4euh",  # nosec
)
