"""Django urlpatterns declaration for nautobot_chatops app."""

from django.templatetags.static import static
from django.urls import path
from django.views.generic import RedirectView
from nautobot.apps.urls import NautobotUIViewSetRouter
from nautobot.extras.views import ObjectChangeLogView, ObjectNotesView

from nautobot_chatops.integrations.grafana.urls import urlpatterns as grafana_urlpatterns
from nautobot_chatops.models import CommandLog, CommandToken
from nautobot_chatops.views import (
    AccessGrantUIViewSet,
    ChatOpsAccountLinkUIViewSet,
    CommandLogListView,
    CommandTokenBulkDeleteView,
    CommandTokenCreateView,
    CommandTokenListView,
    CommandTokenView,
)

router = NautobotUIViewSetRouter()
router.register("access", viewset=AccessGrantUIViewSet)
router.register("account-link", viewset=ChatOpsAccountLinkUIViewSet)

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
    path("tokens/", CommandTokenListView.as_view(), name="commandtoken_list"),
    path(
        "tokens/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="commandtoken_changelog",
        kwargs={"model": CommandToken},
    ),
    path(
        "tokens/<uuid:pk>/notes/",
        ObjectNotesView.as_view(),
        name="commandtoken_notes",
        kwargs={"model": CommandToken},
    ),
    path("tokens/<uuid:pk>/edit/", CommandTokenView.as_view(), name="commandtoken_edit"),
    path("tokens/add/", CommandTokenCreateView.as_view(), name="commandtoken_add"),
    path("tokens/delete/", CommandTokenBulkDeleteView.as_view(), name="commandtoken_bulk_delete"),
    *grafana_urlpatterns,
    path("docs/", RedirectView.as_view(url=static("nautobot_chatops/docs/index.html")), name="docs"),
]
