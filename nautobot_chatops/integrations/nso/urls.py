"""Django urlpatterns declaration for nautobot_chatops.integrations.nso plugin."""
from django.urls import path
from nautobot.extras.views import ObjectChangeLogView
from nautobot_chatops.integrations.nso.models import NSOCommandFilter
from nautobot_chatops.integrations.nso.views import (
    NSOCommandFilterView,
    NSOCommandFilterListView,
    NSOCommandFiltersCreateView,
    NSOCommandFiltersUpdateView,
    NSOCommandFiltersDeleteView,
)

urlpatterns = [
    path("command-filter/", NSOCommandFilterListView.as_view(), name="nsocommandfilter_list"),
    path(
        "command-filter/<uuid:pk>/changelog/",
        ObjectChangeLogView.as_view(),
        name="nsocommandfilter_changelog",
        kwargs={"model": NSOCommandFilter},
    ),
    path("command-filter/add/", NSOCommandFiltersCreateView.as_view(), name="nsocommandfilter_add"),
    path("command-filter/<uuid:pk>/edit/", NSOCommandFiltersUpdateView.as_view(), name="nsocommandfilter_update"),
    path("command-filter/<uuid:pk>/delete/", NSOCommandFiltersDeleteView.as_view(), name="nsocommandfilter_delete"),
    path("command-filter/<uuid:pk>/", NSOCommandFilterView.as_view(), name="nsocommandfilter"),
]
