"""Nautobot plugin implementing a chatbot."""
__version__ = "1.1.0"


from nautobot.extras.plugins import PluginConfig


class NautobotChatOpsConfig(PluginConfig):
    """Plugin configuration for the nautobot_chatops plugin."""

    name = "nautobot_chatops"
    verbose_name = "Nautobot ChatOps"
    version = __version__
    author = "Network to Code"
    author_email = "opensource@networktocode.com"
    description = "A plugin providing chatops capabilities."
    base_url = "chatops"
    required_settings = []
    default_settings = {
        "enable_slack": False,
        "enable_ms_teams": False,
        "enable_webex_teams": False,
        # Should menus, text input fields, etc. be deleted from the chat history after the user makes a selection?
        "delete_input_on_submission": False,
        # Slack-specific settings
        "slack_api_token": None,  # for example, "xoxb-123456"
        "slack_signing_secret": None,
        # Any prefix that's prepended to all slash-commands for this bot and should be stripped away
        # in order to identify the actual command name to be invoked, eg "/nautobot-"
        "slack_slash_command_prefix": "/",
        # Microsoft-Teams-specific settings
        "microsoft_app_id": None,
        "microsoft_app_password": None,
        # WebEx-Teams-specific settings
        "webex_teams_token": None,
        "webex_teams_signing_secret": None,
        "enable_mattermost": False,
        # Mattermost-specific settings
        "mattermost_api_token": None,
        "mattermost_url": None,
    }
    # TODO dgarros : Define min and max version when things stabilize
    # min_version = "0.9"
    # max_version = ""
    caching_config = {}

    def ready(self):
        """Function invoked after all plugins have been loaded."""
        super().ready()
        # pylint: disable=import-outside-toplevel
        from nautobot_capacity_metrics import register_metric_func
        from .metrics_app import metric_commands

        register_metric_func(metric_commands)


config = NautobotChatOpsConfig  # pylint:disable=invalid-name
