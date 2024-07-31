"""Bootstrap script for Nautobot to allow Mattermost integration."""


import contextlib
from django.contrib.auth import get_user_model
from django.core.exceptions import ObjectDoesNotExist

from nautobot_chatops.models import (
    AccessGrantTypeChoices,
    PlatformChoices,
    AccessGrant,
    CommandToken,
    ChatOpsAccountLink,
)


User = get_user_model()

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
    "aci": "b9wrs7paz7fi5ragz9uurwd9fa",  # nosec
    "ansible": "4hz941bgtpde9g75sesdp7tp1h",  # nosec
    "clear": "u7p1an973bd1jqg75i3y7pxj7y",  # nosec
    "cloudvision": "71o3ku7jwjyxup6biu1way1h5y",  # nosec
    "grafana": "3wxwh3m8mjrzxr11psersqkwue",  # nosec
    "ipfabric": "ppm316za33ritm3xgpobcmmgre",  # nosec
    "meraki": "11ix54hycjr4dmxcgw4d77qc4w",  # nosec
    "nautobot": "ncygprhkt3rrxr4rkytcaa7c9c",  # nosec
    "panorama": "fh1kbk45xtgm8r48jzr39ru1ww",  # nosec
    "nso": "j9bcga71hl4lreaczecen7i5dz",  # nosec
}

for command, token in _COMMAND_TOKENS.items():
    CommandToken.objects.update_or_create(
        platform=PlatformChoices.MATTERMOST,
        comment=command,
        token=token,
    )

with contextlib.suppress(ObjectDoesNotExist):
    admin = User.objects.get(name="admin")
    ChatOpsAccountLink.objects.update_or_create(
        user_id="w7uyhzuo7fnfueen6og9cxmn9h",
        platform=PlatformChoices.MATTERMOST,
        defaults={"nautobot_user": admin},
    )
