"""Django urlpatterns declaration for nautobot_chatops.integrations.grafana plugin."""

from django.conf import settings

from nautobot.core.api import OrderedDefaultRouter
from nautobot_chatops.integrations.grafana.api.views.generic import NautobotPluginChatopsGrafanaRootView


urlpatterns = []
if settings.PLUGINS_CONFIG["nautobot_chatops"]["enable_grafana"]:
    router = OrderedDefaultRouter()
    router.APIRootView = NautobotPluginChatopsGrafanaRootView

    app_name = "nautobot_chatops.grafana-api"

    urlpatterns += router.urls
