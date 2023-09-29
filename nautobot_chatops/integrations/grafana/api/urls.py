"""Django urlpatterns declaration for nautobot_chatops.integrations.grafana plugin."""

from nautobot.apps.api import OrderedDefaultRouter
from nautobot.apps.config import get_app_settings_or_config

from nautobot_chatops.integrations.grafana.api.views.generic import NautobotPluginChatopsGrafanaRootView


urlpatterns = []
if get_app_settings_or_config("nautobot_chatops", "enable_grafana"):
    router = OrderedDefaultRouter()
    router.APIRootView = NautobotPluginChatopsGrafanaRootView

    app_name = "nautobot_chatops.grafana-api"

    urlpatterns += router.urls
