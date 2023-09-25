"""Django urlpatterns declaration for nautobot_chatops plugin."""

import logging
from typing import Dict

from django.conf import settings
from django.urls import include, path
from nautobot.core.api import OrderedDefaultRouter
from nautobot_chatops.api.views.generic import AccessGrantViewSet, CommandTokenViewSet, NautobotChatopsRootView
from nautobot_chatops.api.views.lookup import AccessLookupView

_APP_CONFIG: Dict = settings.PLUGINS_CONFIG["nautobot_chatops"]

logger = logging.getLogger(__name__)
urlpatterns = [path("lookup/", AccessLookupView.as_view(), name="access_lookup")]

if _APP_CONFIG.get("enable_slack"):
    from nautobot_chatops.api.views.slack import SlackSlashCommandView, SlackInteractionView, SlackEventAPIView

    urlpatterns += [
        path("slack/slash_command/", SlackSlashCommandView.as_view(), name="slack_slash_command"),
        path("slack/interaction/", SlackInteractionView.as_view(), name="slack_interaction"),
        path("slack/event/", SlackEventAPIView.as_view(), name="slack_event"),
    ]

if _APP_CONFIG.get("enable_ms_teams"):
    from nautobot_chatops.api.views.ms_teams import MSTeamsMessagesView

    urlpatterns += [
        path("ms_teams/messages/", MSTeamsMessagesView.as_view(), name="ms_teams_messages"),
    ]

if _APP_CONFIG.get("enable_webex"):
    from nautobot_chatops.api.views.webex import WebexView

    urlpatterns += [
        path("webex/", WebexView.as_view(), name="webex"),
    ]

if _APP_CONFIG.get("enable_mattermost"):
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

urlpatterns += [path("grafana/", include("nautobot_chatops.integrations.grafana.api.urls"))]
