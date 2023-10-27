"""Django urlpatterns declaration for nautobot_plugin_chatops_nso plugin."""
from django.urls import path
from nautobot.extras.views import ObjectChangeLogView
from nautobot_plugin_chatops_nso.models import CommandFilter
from nautobot_plugin_chatops_nso.views import (
    CiscoNSOView,
    CommandFilterListView,
    CommandFiltersCreateView,
    CommandFiltersUpdateView,
    CommandFiltersDeleteView,
)

urlpatterns = [
    path("nso/", CiscoNSOView.as_view(), name="nso_page"),
    path("command-filter/", CommandFilterListView.as_view(), name="commandfilter_list"),
    path(
        "command-filter/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="commandfilter_changelog",
        kwargs={"model": CommandFilter},
    ),
    path("command-filter/add/", CommandFiltersCreateView.as_view(), name="commandfilter_add"),
    path("command-filter/<uuid:pk>/edit/", CommandFiltersUpdateView.as_view(), name="commandfilter_update"),
    path("command-filter/<uuid:pk>/delete/", CommandFiltersDeleteView.as_view(), name="commandfilter_delete"),
]
