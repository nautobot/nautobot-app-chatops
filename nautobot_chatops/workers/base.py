"""Base functionality for any worker implementation.

Obsolete - contents of this file have been migrated to other modules.
"""

import warnings

# For backwards compatibility -- these used to be defined in this file
# pylint: disable=unused-import

warnings.warn(
    """Importing from `nautobot_chatops.workers.base` has been deprecated, please use `nautobot_chatops.workers`
    for `subcommand_of` and `handle_subcommands` or `nautobot_chatops.utils` for `create_command_log`""",
    DeprecationWarning,
)
