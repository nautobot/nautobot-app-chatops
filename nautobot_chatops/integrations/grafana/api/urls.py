"""Django API urlpatterns declaration for nautobot_chatops app."""

from nautobot.apps.api import OrderedDefaultRouter

from nautobot_chatops.integrations.grafana.api.views import GrafanaDashboardViewSet

router = OrderedDefaultRouter()
router.register("grafana/dashboards", GrafanaDashboardViewSet)
urlpatterns = router.urls
