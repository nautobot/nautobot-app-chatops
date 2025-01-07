"""Django API urlpatterns declaration for nautobot_chatops app."""

from nautobot.apps.api import OrderedDefaultRouter

from nautobot_chatops.api import views

router = OrderedDefaultRouter()
# add the name of your api endpoint, usually hyphenated model name in plural, e.g. "my-model-classes"
router.register("commandlog", views.CommandLogViewSet)

urlpatterns = router.urls
