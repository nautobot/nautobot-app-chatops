"""Django urlpatterns declaration for nautobot_chatops plugin."""
import logging

from django.urls import path

from nautobot.extras.views import ObjectChangeLogView

from nautobot_chatops.models import AccessGrant, ChatOpsAccountLink, CommandToken
from nautobot_chatops.views import (
    CommandTokenBulkDeleteView,
    CommandTokenCreateView,
    CommandTokenListView,
    CommandTokenView,
    CommandLogListView,
    AccessGrantListView,
    AccessGrantView,
    AccessGrantCreateView,
    AccessGrantBulkDeleteView,
    ChatOpsAccountLinkView,
    ChatOpsAccountLinkEditView,
    ChatOpsAccountLinkListView,
    ChatOpsAccountLinkDeleteView,
)

try:
    from nautobot_chatops.integrations.grafana.urls import urlpatterns as grafana_urlpatterns
# pylint: disable-next=broad-except
except Exception:
    grafana_urlpatterns = []
    logger = logging.getLogger(__name__)
    logger.warning("Grafana ChatOps integration is not available.", exc_info=True)


urlpatterns = [
    path("", CommandLogListView.as_view(), name="commandlog_list"),
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
    path("account-link/add/", ChatOpsAccountLinkEditView.as_view(), name="chatopsaccountlink_add"),
    path("account-link/", ChatOpsAccountLinkListView.as_view(), name="chatopsaccountlink_list"),
    path("account-link/<uuid:pk>/", ChatOpsAccountLinkView.as_view(), name="chatopsaccountlink"),
    path("account-link/<uuid:pk>/edit/", ChatOpsAccountLinkEditView.as_view(), name="chatopsaccountlink_edit"),
    path("account-link/<uuid:pk>/delete/", ChatOpsAccountLinkDeleteView.as_view(), name="chatopsaccountlink_delete"),
    path(
        "account-link/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="chatopsaccountlink_changelog",
        kwargs={"model": ChatOpsAccountLink},
    ),
    *grafana_urlpatterns,
]
