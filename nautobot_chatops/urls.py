"""Django urlpatterns declaration for nautobot_chatops plugin."""

from django.urls import path

from nautobot.extras.views import ObjectChangeLogView

from nautobot_chatops.models import AccessGrant, ChatOpsAccountLink, CommandToken
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
    ChatOpsAccountLinkEditView,
    ChatOpsAccountLinkListView,
    ChatOpsAccountLinkDeleteView,
)

from nautobot_chatops.integrations.grafana.urls import urlpatterns as grafana_urlpatterns

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
    path("account-link/add/", ChatOpsAccountLinkEditView.as_view(), name="chatopsaccountlink_add"),
    path("account-link/", ChatOpsAccountLinkListView.as_view(), name="chatopsaccountlink_list"),
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
