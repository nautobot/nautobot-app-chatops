"""Set up nautobot testing data."""
try:
    from importlib import metadata
except ImportError:
    # Python version < 3.8
    import importlib_metadata as metadata

__version__ = metadata.version("nautobot_chatops")

from nautobot.apps import NautobotAppConfig
from nautobot.apps import nautobot_database_ready


def _bootstrap(_sender, *, apps, **_kwargs):
    AccessGrantTypeChoices = apps.get_model("nautobot_chatops", "AccessGrantTypeChoices")
    AccessGrant = apps.get_model("nautobot_chatops", "AccessGrant")

    for slug in ["organization", "channel", "user"]:
        AccessGrant.objects.update_or_create(
            defaults={
                "command": "*",
                "subcommand": "*",
                "grant_type": AccessGrantTypeChoices.objects.get(slug=slug),
                "name": "*",
                "value": "*",
            },
        )

    CommandTokenPlatformChoices = apps.get_model("nautobot_chatops", "CommandTokenPlatformChoices")
    CommandToken = apps.get_model("nautobot_chatops", "CommandToken")
    CommandToken.objects.update_or_create(
        defaults={
            "comment": "nautobot",
            "platform": CommandTokenPlatformChoices.objects.get(slug="mattermost"),
            "token": "rmdpfdjhnpg988e7ujzyom4euh",
        }
    )


class NautobotChatOpsTestsBootstrapConfig(NautobotAppConfig):
    """Plugin to set up nautobot testing data."""

    name = "nautobot_chatops.tests.bootstrap"
    verbose_name = "Nautobot ChatOps Testing Bootstrap"
    version = __version__
    author = "Network to Code"
    author_email = "opensource@networktocode.com"
    description = "Nautobot App that sets up testing data for Nautobot ChatOps"
    base_url = None
    required_settings = []
    max_version = "1.999"
    min_version = "1.5.2"

    def ready(self):
        """Function invoked after all plugins have been loaded."""
        # super().ready()

        nautobot_database_ready.connect(_bootstrap, sender=self)


config = NautobotChatOpsTestsBootstrapConfig  # pylint:disable=invalid-name
