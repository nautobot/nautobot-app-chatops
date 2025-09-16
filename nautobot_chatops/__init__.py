"""App declaration for nautobot_chatops."""

# Metadata is inherited from Nautobot. If not including Nautobot in the environment, this should be added
from importlib import metadata

from nautobot.apps import NautobotAppConfig

__version__ = metadata.version(__name__)


class NautobotChatOpsAppConfig(NautobotAppConfig):
    """App configuration for the nautobot_chatops app."""

    name = "nautobot_chatops"
    verbose_name = "Nautobot ChatOps App"
    version = __version__
    author = "Network to Code, LLC"
    description = "Nautobot ChatOps App."
    base_url = "chatops"
    required_settings = []
    default_settings = {}
    caching_config = {}
    docs_view_name = "plugins:nautobot_chatops:docs"
    searchable_models = ["commandlog"]


config = NautobotChatOpsAppConfig  # pylint:disable=invalid-name
