"""Banner to alert Staff to use Admin site if trying to add/edit Account Links for other Users."""

from typing import Optional

from django.urls import reverse
from django.utils.html import format_html
from nautobot.extras.choices import BannerClassChoices
from nautobot.extras.plugins import PluginBanner


def banner(context, *args, **kwargs) -> Optional[PluginBanner]:
    """
    Construct the ChatOps Account Link Banner.

    This Banner will provide link to alert Staff users of the
    admin site list/add/edit options for managing other users
    ChatOps Account Links.
    """
    if "chatops/account-link/" in context.request.path and (
        context.request.user.is_staff or context.request.user.is_superuser
    ):
        content = format_html(
            "This page is to manage your ChatOps Account Links, to manage other users ChatOps Account Links,"
            'visit the <a href="{}">Admin Site</a>',
            reverse("admin:nautobot_chatops_chatopsaccountlink_changelist"),
        )
        return PluginBanner(content=content, banner_class=BannerClassChoices.CLASS_INFO)
    return None
