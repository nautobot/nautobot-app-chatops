"""Django urlpatterns declaration for nautobot_chatops app."""

from django.templatetags.static import static
from django.urls import path
from django.views.generic import RedirectView
from nautobot.apps.urls import NautobotUIViewSetRouter
from nautobot.extras.views import ObjectChangeLogView, ObjectNotesView

from nautobot_chatops.integrations.grafana.urls import urlpatterns as grafana_urlpatterns
from nautobot_chatops.models import CommandLog
from nautobot_chatops.views import (
    AccessGrantUIViewSet,
    ChatOpsAccountLinkUIViewSet,
    CommandLogListView,
    CommandTokenUIViewSet,
)

router = NautobotUIViewSetRouter()
router.register("access", viewset=AccessGrantUIViewSet)
router.register("account-link", viewset=ChatOpsAccountLinkUIViewSet)
router.register("tokens", viewset=CommandTokenUIViewSet)

urlpatterns = router.urls

urlpatterns += [
    path("", CommandLogListView.as_view(), name="commandlog_list"),
    path(
        "commandlog/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="commandlog_changelog",
        kwargs={"model": CommandLog},
    ),
    path(
        "commandlog/<uuid:pk>/notes/",
        ObjectNotesView.as_view(),
        name="commandlog_notes",
        kwargs={"model": CommandLog},
    ),
    *grafana_urlpatterns,
    path("docs/", RedirectView.as_view(url=static("nautobot_chatops/docs/index.html")), name="docs"),
]
