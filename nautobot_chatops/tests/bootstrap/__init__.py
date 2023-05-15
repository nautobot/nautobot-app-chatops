"""Set up nautobot testing data."""

from nautobot.apps import NautobotAppConfig
from nautobot.apps import nautobot_database_ready

from nautobot_chatops import __version__


# pylint: disable-next=unused-argument
def _bootstrap(sender, *, apps, **_kwargs):
    # pylint: disable-next=import-outside-toplevel
    from nautobot_chatops.models import AccessGrantTypeChoices, CommandTokenPlatformChoices

    # pylint: disable-next=invalid-name
    AccessGrant = apps.get_model("nautobot_chatops", "AccessGrant")
    for grant_type in AccessGrantTypeChoices.values():
        AccessGrant.objects.update_or_create(
            command="*",
            subcommand="*",
            grant_type=grant_type,
            name="*",
            value="*",
        )

    # pylint: disable-next=invalid-name
    CommandToken = apps.get_model("nautobot_chatops", "CommandToken")
    CommandToken.objects.update_or_create(
        comment="nautobot",
        platform=CommandTokenPlatformChoices.MATTERMOST,
        token="rmdpfdjhnpg988e7ujzyom4euh",
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

        # Omitting super().ready() here to avoid calling the parent class's ready() method
        # super().ready()

        nautobot_database_ready.connect(_bootstrap, sender=self)


config = NautobotChatOpsTestsBootstrapConfig  # pylint:disable=invalid-name
