"""Django urlpatterns declaration for nautobot_chatops.integrations.grafana plugin."""

# from django.urls import path

from nautobot.apps.api import OrderedDefaultRouter
from nautobot_chatops.integrations.grafana.api.views.generic import NautobotPluginChatopsGrafanaRootView


urlpatterns = []

router = OrderedDefaultRouter()
router.APIRootView = NautobotPluginChatopsGrafanaRootView

app_name = "nautobot_chatops.grafana-api"

urlpatterns += router.urls
