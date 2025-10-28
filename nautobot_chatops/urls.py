"""Django urlpatterns declaration for nautobot_chatops app."""

from django.templatetags.static import static
from django.urls import path
from django.views.generic import RedirectView
from nautobot.apps.urls import NautobotUIViewSetRouter

from nautobot_chatops.integrations.grafana.urls import urlpatterns as grafana_urlpatterns
from nautobot_chatops.views import (
    AccessGrantUIViewSet,
    ChatOpsAccountLinkUIViewSet,
    CommandLogUIViewSet,
    CommandTokenUIViewSet,
)

router = NautobotUIViewSetRouter()
router.register("", viewset=CommandLogUIViewSet)
router.register("access-grant", viewset=AccessGrantUIViewSet)
router.register("account-link", viewset=ChatOpsAccountLinkUIViewSet)
router.register("tokens", viewset=CommandTokenUIViewSet)

urlpatterns = router.urls

urlpatterns += [
    *grafana_urlpatterns,
    path("docs/", RedirectView.as_view(url=static("nautobot_chatops/docs/index.html")), name="docs"),
]

app_name = "nautobot_chatops"
