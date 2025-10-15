"""Django API urlpatterns declaration for nautobot_chatops app."""

from nautobot.apps.api import OrderedDefaultRouter

from nautobot_chatops.integrations.grafana.api.views import GrafanaDashboardViewSet, GrafanaPanelViewSet

router = OrderedDefaultRouter()
router.register("grafana/dashboards", GrafanaDashboardViewSet)
router.register("grafana/panels", GrafanaPanelViewSet)

urlpatterns = router.urls
