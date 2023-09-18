"""Administrative capabilities for nautobot_chatops plugin."""

from django.contrib import admin
from .models import CommandLog, ChatOpsAccountLink


@admin.register(CommandLog)
class CommandLogAdmin(admin.ModelAdmin):
    """Administrative view for managing CommandLog instances."""

    list_display = (
        "pk",
        "start_time",
        "runtime",
        "user_name",
        "user_id",
        "platform",
        "command",
        "subcommand",
        "nautobot_user",
    )


@admin.register(ChatOpsAccountLink)
class ChatOpsAccountLinkAdmin(admin.ModelAdmin):
    """Administrative view for managing ChatOps Account Link instances."""

    list_display = (
        "pk",
        "nautobot_user",
        "platform",
        "user_id",
    )
