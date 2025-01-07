"""Django urlpatterns declaration for nautobot_chatops app."""

from django.templatetags.static import static
from django.urls import path
from django.views.generic import RedirectView
from nautobot.apps.urls import NautobotUIViewSetRouter


from nautobot_chatops import views


router = NautobotUIViewSetRouter()

router.register("commandlog", views.CommandLogUIViewSet)


urlpatterns = [
    path("docs/", RedirectView.as_view(url=static("nautobot_chatops/docs/index.html")), name="docs"),
]

urlpatterns += router.urls
