"""Django urlpatterns declaration for nautobot_chatops plugin."""

import logging
from django.urls import path

from django.conf import settings
from nautobot.core.api import OrderedDefaultRouter
from nautobot_chatops.api.views.lookup import AccessLookupView
from nautobot_chatops.api.views.generic import AccessGrantViewSet, CommandTokenViewSet, NautobotChatopsRootView


logger = logging.getLogger(__name__)
urlpatterns = [path("lookup/", AccessLookupView.as_view(), name="access_lookup")]

if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_slack"):
    from nautobot_chatops.api.views.slack import SlackSlashCommandView, SlackInteractionView

    urlpatterns += [
        path("slack/slash_command/", SlackSlashCommandView.as_view(), name="slack_slash_command"),
        path("slack/interaction/", SlackInteractionView.as_view(), name="slack_interaction"),
    ]

if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_ms_teams"):
    from nautobot_chatops.api.views.ms_teams import MSTeamsMessagesView

    urlpatterns += [
        path("ms_teams/messages/", MSTeamsMessagesView.as_view(), name="ms_teams_messages"),
    ]

# v1.4.0 - Preserve backwards compatibility with variable name until 2.0.0
if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_webex") or settings.PLUGINS_CONFIG["nautobot_chatops"].get(
    "enable_webex_teams"
):
    if settings.PLUGINS_CONFIG["nautobot_chatops"].get("webex_teams_token") and not settings.PLUGINS_CONFIG[
        "nautobot_chatops"
    ].get("webex_token"):
        # v1.4.0 Deprecation warning
        logger.warning("The 'enable_webex_teams' setting is deprecated. Please use 'enable_webex' instead.")
    from nautobot_chatops.api.views.webex import WebExView

    urlpatterns += [
        path("webex/", WebExView.as_view(), name="webex"),
        path("webex_teams/", WebExView.as_view(), name="webex_teams"),  # Deprecated v1.4.0
    ]

if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_mattermost"):
    from nautobot_chatops.api.views.mattermost import MattermostSlashCommandView, MattermostInteractionView

    urlpatterns += [
        path("mattermost/slash_command/", MattermostSlashCommandView.as_view(), name="mattermost_slash_command"),
        path("mattermost/interaction/", MattermostInteractionView.as_view(), name="mattermost_interaction"),
    ]

router = OrderedDefaultRouter()
router.APIRootView = NautobotChatopsRootView
router.register("commandtoken", CommandTokenViewSet)
router.register("accessgrant", AccessGrantViewSet)

app_name = "nautobot_chatops-api"

urlpatterns += router.urls
