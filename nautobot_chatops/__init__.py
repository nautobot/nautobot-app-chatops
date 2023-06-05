"""Nautobot plugin implementing a chatbot."""
try:
    from importlib import metadata
except ImportError:
    # Python version < 3.8
    import importlib_metadata as metadata

__version__ = metadata.version(__name__)

from django.conf import settings
from nautobot.extras.plugins import PluginConfig


_CONFLICTING_APP_NAMES = [
    # App names that conflict with nautobot_chatops
    "nautobot_plugin_chatops_meraki",
]


def _check_for_conflicting_apps():
    intersection = set(_CONFLICTING_APP_NAMES).intersection(set(settings.PLUGINS))
    if intersection:
        raise RuntimeError(
            f"The following apps are installed and conflict with `nautobot-chatops`: {', '.join(intersection)}."
        )


_check_for_conflicting_apps()


class NautobotChatOpsConfig(PluginConfig):
    """Plugin configuration for the nautobot_chatops plugin."""

    name = "nautobot_chatops"
    verbose_name = "Nautobot ChatOps"
    version = __version__
    author = "Network to Code"
    author_email = "opensource@networktocode.com"
    description = """
        Nautobot App that is a multi-platform chatbot supporting Slack, MS Teams, Webex Teams,
        and Mattermost that simplifies creating chat commands with pre-defined design patterns.
        Includes the 'nautobot' command that simplifies fetching and updating data in Nautobot.
    """
    base_url = "chatops"
    required_settings = []
    default_settings = {
        "enable_slack": False,
        "enable_ms_teams": False,
        "enable_webex": False,
        # Should menus, text input fields, etc. be deleted from the chat history after the user makes a selection?
        "delete_input_on_submission": False,
        # Session Cache
        "session_cache_timeout": 86400,
        # Slack-specific settings
        "slack_api_token": None,  # for example, "xoxb-123456"
        "slack_signing_secret": None,
        "slack_ephemeral_message_size_limit": 3000,
        # Any prefix that's prepended to all slash-commands for this bot and should be stripped away
        # in order to identify the actual command name to be invoked, eg "/nautobot-"
        "slack_slash_command_prefix": "/",
        # Since Slack Socket is meant keep Nautobot server out of public access, slack needs to know
        # where to find Static images. If Django Storages is configured with an External server like S3,
        # this can be ignored.
        # If neither option is provided, then no static images (like Nautobot Logo) will be shown.
        "slack_socket_static_host": None,
        # Microsoft-Teams-specific settings
        "microsoft_app_id": None,
        "microsoft_app_password": None,
        # WebEx-specific settings
        "webex_token": None,
        "webex_signing_secret": None,
        "enable_mattermost": False,
        # Mattermost-specific settings
        "mattermost_api_token": None,
        "mattermost_url": None,
        # As requested on https://github.com/nautobot/nautobot-plugin-chatops/issues/114 this setting is used for
        # sending all messages as an ephemeral message, meaning only the person interacting with the bot will see the
        # responses.
        "send_all_messages_private": False,
        "restrict_help": False,
        "meraki_dashboard_api_key": None,
        "tower_uri": None,
        "tower_username": None,
        "tower_password": None,
        "tower_verify_ssl": False,
    }

    max_version = "1.999"
    min_version = "1.4.0"
    caching_config = {}

    def ready(self):
        """Function invoked after all plugins have been loaded."""
        super().ready()
        # pylint: disable=import-outside-toplevel
        from nautobot_capacity_metrics import register_metric_func
        from .metrics_app import metric_commands

        register_metric_func(metric_commands)


config = NautobotChatOpsConfig  # pylint:disable=invalid-name
