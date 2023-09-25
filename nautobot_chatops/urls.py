"""Django urlpatterns declaration for nautobot_chatops plugin."""
import logging

from django.conf import settings
from django.urls import path

from nautobot.extras.views import ObjectChangeLogView

from nautobot_chatops.models import AccessGrant, CommandToken
from nautobot_chatops.views import (
    CommandTokenBulkDeleteView,
    CommandTokenCreateView,
    CommandTokenListView,
    CommandTokenView,
    NautobotHomeView,
    AccessGrantListView,
    AccessGrantView,
    AccessGrantCreateView,
    AccessGrantBulkDeleteView,
)

if settings.PLUGINS_CONFIG["nautobot_chatops"]["enable_grafana"]:
    try:
        from nautobot_chatops.integrations.grafana.urls import urlpatterns as grafana_urlpatterns
    # pylint: disable-next=broad-except
    except Exception:
        grafana_urlpatterns = []
        logger = logging.getLogger(__name__)
        logger.warning("Grafana ChatOps integration is not available.", exc_info=True)
else:
    grafana_urlpatterns = []
    logger = logging.getLogger(__name__)
    logger.warning("Grafana ChatOps integration is not available.", exc_info=True)

urlpatterns = [
    path("", NautobotHomeView.as_view(), name="home"),
    path("access/", AccessGrantListView.as_view(), name="accessgrant_list"),
    path(
        "access/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="accessgrant_changelog",
        kwargs={"model": AccessGrant},
    ),
    path("access/<uuid:pk>/edit/", AccessGrantView.as_view(), name="accessgrant_edit"),
    path("access/add/", AccessGrantCreateView.as_view(), name="accessgrant_add"),
    path("access/delete/", AccessGrantBulkDeleteView.as_view(), name="accessgrant_bulk_delete"),
    path("tokens/", CommandTokenListView.as_view(), name="commandtoken_list"),
    path(
        "tokens/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="commandtoken_changelog",
        kwargs={"model": CommandToken},
    ),
    path("tokens/<uuid:pk>/edit/", CommandTokenView.as_view(), name="commandtoken_edit"),
    path("tokens/add/", CommandTokenCreateView.as_view(), name="commandtoken_add"),
    path("tokens/delete/", CommandTokenBulkDeleteView.as_view(), name="commandtoken_bulk_delete"),
    *grafana_urlpatterns,
]
