"""Django urlpatterns declaration for nautobot_chatops app."""

import logging

from django.urls import path
from nautobot.apps.api import OrderedDefaultRouter

from nautobot_chatops.api.views.generic import (
    AccessGrantViewSet,
    CommandLogViewSet,
    CommandTokenViewSet,
    NautobotChatopsRootView,
)
from nautobot_chatops.api.views.lookup import AccessLookupView, UserEmailLookupView
from nautobot_chatops.api.views.mattermost import MattermostInteractionView, MattermostSlashCommandView
from nautobot_chatops.api.views.ms_teams import MSTeamsMessagesView
from nautobot_chatops.api.views.slack import SlackEventAPIView, SlackInteractionView, SlackSlashCommandView
from nautobot_chatops.api.views.webex import WebexView

logger = logging.getLogger(__name__)
urlpatterns = [
    path("lookup/", AccessLookupView.as_view(), name="access_lookup"),
    path("email-lookup/", UserEmailLookupView.as_view(), name="email_lookup"),
    path("slack/slash_command/", SlackSlashCommandView.as_view(), name="slack_slash_command"),
    path("slack/interaction/", SlackInteractionView.as_view(), name="slack_interaction"),
    path("slack/event/", SlackEventAPIView.as_view(), name="slack_event"),
    path("ms_teams/messages/", MSTeamsMessagesView.as_view(), name="ms_teams_messages"),
    path("webex/", WebexView.as_view(), name="webex"),
    path("mattermost/slash_command/", MattermostSlashCommandView.as_view(), name="mattermost_slash_command"),
    path("mattermost/interaction/", MattermostInteractionView.as_view(), name="mattermost_interaction"),
]

router = OrderedDefaultRouter()
router.APIRootView = NautobotChatopsRootView
router.register("commandtoken", CommandTokenViewSet)
router.register("accessgrant", AccessGrantViewSet)
router.register("commandlog", CommandLogViewSet)

app_name = "nautobot_chatops-api"

urlpatterns += router.urls
