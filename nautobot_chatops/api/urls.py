"""Django urlpatterns declaration for nautobot_chatops plugin."""

from django.urls import path

from django.conf import settings
from nautobot_chatops.api.views.lookup import AccessLookupView


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

if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_webex_teams"):
    from nautobot_chatops.api.views.webex_teams import WebExTeamsView

    urlpatterns += [
        path("webex_teams/", WebExTeamsView.as_view(), name="webex_teams"),
    ]

if settings.PLUGINS_CONFIG["nautobot_chatops"].get("enable_mattermost"):
    from nautobot_chatops.api.views.mattermost import MattermostSlashCommandView, MattermostInteractionView

    urlpatterns += [
        path("mattermost/slash_command/", MattermostSlashCommandView.as_view(), name="mattermost_slash_command"),
        path("mattermost/interaction/", MattermostInteractionView.as_view(), name="mattermost_interaction"),
    ]
