"""Static variables used in plugin."""

COMMAND_LOG_USER_NAME_HELP_TEXT = "Invoking username"
COMMAND_LOG_USER_ID_HELP_TEXT = "Invoking user ID"
COMMAND_LOG_PLATFORM_HELP_TEXT = "Chat platform"
COMMAND_LOG_COMMAND_TEXT = "Command issued"
COMMAND_LOG_SUBCOMMAND_HELP_TEXT = "Sub-command issued"
COMMAND_LOG_PARAMS_HELP_TEXT = "user_input_parameters"

ACCESS_GRANT_COMMAND_HELP_TEXT = "Enter <tt>*</tt> to grant access to all commands"
ACCESS_GRANT_SUBCOMMAND_HELP_TEXT = "Enter <tt>*</tt> to grant access to all subcommands of the given command"
ACCESS_GRANT_NAME_HELP_TEXT = "Organization name, channel name, or user name"
# pylint: disable=line-too-long
ACCESS_GRANT_VALUE_HELP_TEXT = "Corresponding ID value to grant access to.<br>Enter <tt>*</tt> to grant access to all organizations, channels, or users"

COMMAND_TOKEN_COMMENT_HELP_TEXT = "Optional: Enter description of token"  # nosec - skips Bandit B105 error
COMMAND_TOKEN_TOKEN_HELP_TEXT = (
    "Token given by chat platform for signing or command validation"  # nosec - skips Bandit B105 error
)
