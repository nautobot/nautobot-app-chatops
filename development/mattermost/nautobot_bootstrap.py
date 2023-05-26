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

# The following tokens are for the development only and safe to store in the repo.
_COMMAND_TOKENS = {
    "ansible": "c7udax974iymjkmoyhi1a11cpy",  # nosec
    "ipfabric": "uqydyxkx4tykinw5z5u9dany1o",  # nosec
    "nautobot": "rmdpfdjhnpg988e7ujzyom4euh",  # nosec
}

for command, token in _COMMAND_TOKENS.items():
    CommandToken.objects.update_or_create(
        platform=CommandTokenPlatformChoices.MATTERMOST,
        comment=command,
        token=token,
    )
