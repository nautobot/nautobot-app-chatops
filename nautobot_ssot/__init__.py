"""Plugin declaration for nautobot_ssot."""
# Metadata is inherited from Nautobot. If not including Nautobot in the environment, this should be added
from importlib import metadata

__version__ = metadata.version(__name__)

from nautobot.extras.plugins import NautobotAppConfig


class NautobotChatOpsPluginConfig(NautobotAppConfig):
    """Plugin configuration for the nautobot_ssot plugin."""

    name = "nautobot_ssot"
    verbose_name = "Nautobot ChatOps App"
    version = __version__
    author = "Network to Code, LLC"
    description = "Nautobot ChatOps App."
    base_url = "chatops"
    required_settings = []
    min_version = "2.0.0"
    max_version = "2.9999"
    default_settings = {}
    caching_config = {}


config = NautobotChatOpsPluginConfig  # pylint:disable=invalid-name
