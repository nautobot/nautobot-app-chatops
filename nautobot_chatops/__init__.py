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
    "nautobot_plugin_chatops_aci",
    "nautobot_plugin_chatops_ansible",
    "nautobot_plugin_chatops_aristacv",
    "nautobot_plugin_chatops_grafana",
    "nautobot_plugin_chatops_ipfabric",
    "nautobot_plugin_chatops_meraki",
    "nautobot_plugin_chatops_panorama",
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
        Nautobot App that is a multi-platform chatbot supporting Slack, MS Teams, Cisco Webex,
        and Mattermost that simplifies creating chat commands with pre-defined design patterns.
        Includes the 'nautobot' command that simplifies fetching and updating data in Nautobot.
    """
    base_url = "chatops"
    required_settings = []
    default_settings = {
        # = Common Settings ==================
        # Should menus, text input fields, etc. be deleted from the chat history after the user makes a selection?
        "delete_input_on_submission": False,
        "restrict_help": False,
        # As requested on https://github.com/nautobot/nautobot-plugin-chatops/issues/114 this setting is used for
        # sending all messages as an ephemeral message, meaning only the person interacting with the bot will see the
        # responses.
        "send_all_messages_private": False,
        # Session Cache
        "session_cache_timeout": 86400,
        # = Chat Platforms ===================
        # - Mattermost -----------------------
        "enable_mattermost": False,
        "mattermost_api_token": "",
        "mattermost_url": "",
        # - Microsoft Teams ------------------
        "enable_ms_teams": False,
        "microsoft_app_id": "",
        "microsoft_app_password": "",
        # - Slack ----------------------------
        "enable_slack": False,
        "slack_api_token": "",  # for example, "xoxb-123456"
        "slack_signing_secret": "",
        "slack_ephemeral_message_size_limit": 3000,
        # Any prefix that's prepended to all slash-commands for this bot and should be stripped away
        # in order to identify the actual command name to be invoked, eg "/nautobot-"
        "slack_slash_command_prefix": "/",
        # Since Slack Socket is meant keep Nautobot server out of public access, slack needs to know
        # where to find Static images. If Django Storages is configured with an External server like S3,
        # this can be ignored.
        # If neither option is provided, then no static images (like Nautobot Logo) will be shown.
        "slack_socket_static_host": "",
        # - Cisco Webex ----------------------
        "enable_webex": False,
        "webex_token": "",
        "webex_signing_secret": "",
        "webex_msg_char_limit": 7439,
        # = Integrations =====================
        # - Cisco ACI ------------------------
        "enable_aci": False,
        "aci_creds": "",
        # - AWX / Ansible Tower --------------
        "enable_ansible": False,
        "tower_password": "",
        "tower_uri": "",
        "tower_username": "",
        "tower_verify_ssl": True,
        # - Arista CloudVision ---------------
        "enable_aristacv": False,
        "aristacv_cvaas_url": "www.arista.io:443",
        "aristacv_cvaas_token": "",
        "aristacv_cvp_host": "",
        "aristacv_cvp_insecure": False,
        "aristacv_cvp_password": "",
        "aristacv_cvp_username": "",
        "aristacv_on_prem": False,
        # - Grafana --------------------------
        "enable_grafana": False,
        "grafana_url": "",
        "grafana_api_key": "",
        "grafana_default_width": 0,
        "grafana_default_height": 0,
        "grafana_default_theme": "dark",
        "grafana_default_timespan": "",
        "grafana_org_id": 1,
        "grafana_default_tz": "",
        # - IPFabric ---------------------
        "enable_ipfabric": False,
        "ipfabric_api_token": "",
        "ipfabric_host": "",
        "ipfabric_timeout": "",
        "ipfabric_verify": False,
        # - Cisco Meraki ---------------------
        "enable_meraki": False,
        "meraki_dashboard_api_key": "",
        # - Palo Alto Panorama ---------------
        "enable_panorama": False,
        "panorama_host": "",
        "panorama_password": "",
        "panorama_user": "",
    }

    max_version = "1.999"
    min_version = "1.5.4"
    caching_config = {}

    def ready(self):
        """Function invoked after all plugins have been loaded."""
        super().ready()
        # pylint: disable=import-outside-toplevel
        from nautobot_capacity_metrics import register_metric_func
        from .metrics_app import metric_commands

        register_metric_func(metric_commands)


config = NautobotChatOpsConfig  # pylint:disable=invalid-name
