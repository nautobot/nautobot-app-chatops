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
    "aci": "tc1u8wbh53fwxxdkhswbmu9wsa",  # nosec
    "ansible": "c7udax974iymjkmoyhi1a11cpy",  # nosec
    "clear": "p7phuwhpaiddjxqf8c1hnw33yh",  # nosec
    "cloudvision": "pxannsh78iyhbm8fumz8mxk9ih",  # nosec
    "grafana": "o1yiadnpifbzddt3umcedeypdr",  # nosec
    "ipfabric": "uqydyxkx4tykinw5z5u9dany1o",  # nosec
    "meraki": "t9irqwjni3dozf3yx6tzak7k3w",  # nosec
    "nautobot": "rmdpfdjhnpg988e7ujzyom4euh",  # nosec
    "panorama": "6nf5cmz1ft8bdfykz46cs5pofo",  # nosec
}

for command, token in _COMMAND_TOKENS.items():
    CommandToken.objects.update_or_create(
        platform=CommandTokenPlatformChoices.MATTERMOST,
        comment=command,
        token=token,
    )
