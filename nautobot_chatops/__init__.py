"""App declaration for nautobot_chatops."""

# Metadata is inherited from Nautobot. If not including Nautobot in the environment, this should be added
from importlib import metadata

from django.conf import settings
from nautobot.apps import ConstanceConfigItem, NautobotAppConfig

__version__ = metadata.version(__name__)


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


class NautobotChatOpsConfig(NautobotAppConfig):
    """App configuration for the nautobot_chatops app."""

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
        # As requested on https://github.com/nautobot/nautobot-app-chatops/issues/114 this setting is used for
        # sending all messages as an ephemeral message, meaning only the person interacting with the bot will see the
        # responses.
        "send_all_messages_private": False,
        # Session Cache
        "session_cache_timeout": 86400,
        # = Chat Platforms ===================
        # - Mattermost -----------------------
        "mattermost_api_token": "",
        "mattermost_url": "",
        # - Microsoft Teams ------------------
        "microsoft_app_id": "",
        "microsoft_app_password": "",
        # - Slack ----------------------------
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
        "webex_token": "",
        "webex_signing_secret": "",
        "webex_msg_char_limit": 7439,
        # = Integrations =====================
        # - Cisco ACI ------------------------
        "aci_creds": "",
        # - AWX / Ansible Tower --------------
        "tower_password": "",
        "tower_uri": "",
        "tower_username": "",
        "tower_verify_ssl": True,
        # - Arista CloudVision ---------------
        "aristacv_cvaas_url": "www.arista.io:443",
        "aristacv_cvaas_token": "",
        "aristacv_cvp_host": "",
        "aristacv_cvp_insecure": False,
        "aristacv_cvp_password": "",
        "aristacv_cvp_username": "",
        "aristacv_on_prem": False,
        # - Grafana --------------------------
        "grafana_url": "",
        "grafana_api_key": "",
        "grafana_default_width": 0,
        "grafana_default_height": 0,
        "grafana_default_theme": "dark",
        "grafana_default_timespan": "",
        "grafana_org_id": 1,
        "grafana_default_tz": "",
        # - IPFabric -------------------------
        "ipfabric_api_token": "",
        "ipfabric_host": "",
        "ipfabric_timeout": "",
        "ipfabric_verify": False,
        # - Cisco Meraki ---------------------
        "meraki_dashboard_api_key": "",
        # - Palo Alto Panorama ---------------
        "panorama_host": "",
        "panorama_password": "",
        "panorama_user": "",
        # - Cisco NSO ------------------------
        "nso_url": "",
        "nso_username": "",
        "nso_password": "",
        "nso_request_timeout": "",
    }
    constance_config = {
        "fallback_chatops_user": ConstanceConfigItem(default="chatbot", help_text="Enable Mattermost Chat Platform."),
        "enable_mattermost": ConstanceConfigItem(
            default=False, help_text="Enable Mattermost Chat Platform.", field_type=bool
        ),
        "enable_ms_teams": ConstanceConfigItem(
            default=False, help_text="Enable Microsoft Teams Chat Platform.", field_type=bool
        ),
        "enable_slack": ConstanceConfigItem(default=False, help_text="Enable Slack Chat Platform.", field_type=bool),
        "enable_webex": ConstanceConfigItem(default=False, help_text="Enable Webex Chat Platform.", field_type=bool),
        "enable_aci": ConstanceConfigItem(default=False, help_text="Enable Cisco ACI Integration.", field_type=bool),
        "enable_ansible": ConstanceConfigItem(default=False, help_text="Enable Ansible Integration.", field_type=bool),
        "enable_cloudvision": ConstanceConfigItem(
            default=False, help_text="Enable Arista CloudVision Integration.", field_type=bool
        ),
        "enable_grafana": ConstanceConfigItem(default=False, help_text="Enable Grafana Integration.", field_type=bool),
        "enable_ipfabric": ConstanceConfigItem(
            default=False, help_text="Enable IP Fabric Integration.", field_type=bool
        ),
        "enable_meraki": ConstanceConfigItem(
            default=False, help_text="Enable Cisco Meraki Integration.", field_type=bool
        ),
        "enable_panorama": ConstanceConfigItem(
            default=False, help_text="Enable Panorama Integration.", field_type=bool
        ),
        "enable_nso": ConstanceConfigItem(default=False, help_text="Enable NSO Integration.", field_type=bool),
    }

    caching_config = {}
    docs_view_name = "plugins:nautobot_chatops:docs"

    def ready(self):
        """Function invoked after all apps have been loaded."""
        super().ready()
        # pylint: disable=import-outside-toplevel
        from nautobot_capacity_metrics import register_metric_func

        from .metrics_app import metric_commands

        register_metric_func(metric_commands)


config = NautobotChatOpsConfig  # pylint:disable=invalid-name
