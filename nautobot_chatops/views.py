"""Views module for the nautobot_chatops Nautobot plugin.

The views implemented in this module act as endpoints for various chat platforms
to send requests and notifications to.
"""

from django.contrib.auth.mixins import PermissionRequiredMixin
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.shortcuts import render, redirect
from django.utils.decorators import method_decorator
from django.views import View
from django.template.defaulttags import register

from django_tables2 import RequestConfig

from nautobot.core.views.generic import ObjectListView, ObjectEditView, BulkDeleteView
from nautobot.utilities.paginator import EnhancedPaginator, get_paginate_count
from nautobot.utilities.forms import TableConfigForm

from nautobot_chatops.workers import get_commands_registry
from nautobot_chatops.models import CommandLog, AccessGrant, CommandToken
from nautobot_chatops.filters import CommandLogFilter, AccessGrantFilter, CommandTokenFilter
from nautobot_chatops.forms import AccessGrantFilterForm, AccessGrantForm, CommandTokenFilterForm, CommandTokenForm
from nautobot_chatops.tables import CommandLogTable, AccessGrantTable, CommandTokenTable


@register.filter
def shorter_timedelta(timedelta):
    """Render a timedelta as "HH:MM:SS.4" instead of "HH:MM:SS.456789".

    Note that we don't bother with rounding.
    """
    prefix, microseconds = str(timedelta).split(".", 1)
    deciseconds = int(microseconds) // 100_000
    return f"{prefix}.{deciseconds}"


class NautobotHomeView(PermissionRequiredMixin, View):
    """Homepage view for Nautobot."""

    permission_required = "nautobot_chatops.view_commandlog"
    http_method_names = ["get", "post"]

    table = CommandLogTable

    def get(self, request, *args, **kwargs):
        """Render the home page for Nautobot."""
        registry = dict(get_commands_registry())
        logs = CommandLog.objects.all().order_by("-start_time")

        # Summarize the number of times each command/subcommand has been called
        for command_name, command_data in registry.items():
            registry[command_name]["count"] = logs.filter(command=command_name).count()

            for subcommand_name in command_data["subcommands"]:
                registry[command_name]["subcommands"][subcommand_name]["count"] = logs.filter(
                    command=command_name, subcommand=subcommand_name
                ).count()

        # Support sorting, filtering, customization, and pagination of the table
        queryset = CommandLogFilter(request.GET, logs).qs
        table = self.table(queryset, user=request.user)
        RequestConfig(
            request, paginate={"paginator_class": EnhancedPaginator, "per_page": get_paginate_count(request)}
        ).configure(table)

        return render(
            request,
            "nautobot/home.html",
            {"commands": registry, "table": table, "table_config_form": TableConfigForm(table)},
        )

    @method_decorator(login_required)
    def post(self, request):
        """Update the user's table configuration.

        Copied from Nautobot utilities.views.ObjectListView.
        """
        logs = CommandLog.objects.all().order_by("-start_time")
        table = self.table(CommandLogFilter(request.GET, logs).qs)
        form = TableConfigForm(table=table, data=request.POST)
        preference_name = f"tables.{self.table.__name__}.columns"

        if form.is_valid():
            if "set" in request.POST:
                request.user.config.set(preference_name, form.cleaned_data["columns"], commit=True)
            elif "clear" in request.POST:
                request.user.config.clear(preference_name, commit=True)
            messages.success(request, "Your preferences have been updated.")

        return redirect(request.get_full_path())


class AccessGrantListView(PermissionRequiredMixin, ObjectListView):
    """View for listing all extant AccessGrants."""

    permission_required = "nautobot_chatops.view_accessgrant"
    queryset = AccessGrant.objects.all().order_by("command")
    filterset = AccessGrantFilter
    filterset_form = AccessGrantFilterForm
    table = AccessGrantTable
    template_name = "nautobot/access_grant_list.html"


class AccessGrantCreateView(PermissionRequiredMixin, ObjectEditView):
    """View for creating a new AccessGrant."""

    permission_required = "nautobot_chatops.add_accessgrant"
    model = AccessGrant
    queryset = AccessGrant.objects.all()
    model_form = AccessGrantForm
    template_name = "nautobot/access_grant_edit.html"
    default_return_url = "plugins:nautobot_chatops:accessgrant_list"


# pylint: disable=too-many-ancestors
class AccessGrantView(AccessGrantCreateView):
    """View for editing an existing AccessGrant."""

    permission_required = "nautobot_chatops.change_accessgrant"


class AccessGrantBulkDeleteView(PermissionRequiredMixin, BulkDeleteView):
    """View for deleting one or more AccessGrant records."""

    permission_required = "nautobot_chatops.delete_accessgrant"
    queryset = AccessGrant.objects.filter()
    table = AccessGrantTable
    default_return_url = "plugins:nautobot_chatops:accessgrant_list"


class CommandTokenListView(PermissionRequiredMixin, ObjectListView):
    """View for listing all extant CommandTokens."""

    permission_required = "nautobot_chatops.view_commandtoken"
    queryset = CommandToken.objects.all().order_by("platform")
    filterset = CommandTokenFilter
    filterset_form = CommandTokenFilterForm
    table = CommandTokenTable
    template_name = "nautobot/command_token_list.html"


class CommandTokenCreateView(PermissionRequiredMixin, ObjectEditView):
    """View for creating a new CommandToken."""

    permission_required = "nautobot_chatops.add_commandtoken"
    model = CommandToken
    queryset = CommandToken.objects.all()
    model_form = CommandTokenForm
    template_name = "nautobot/command_token_edit.html"
    default_return_url = "plugins:nautobot_chatops:commandtoken_list"


# pylint: disable=too-many-ancestors
class CommandTokenView(CommandTokenCreateView):
    """View for editing an existing CommandToken."""

    permission_required = "nautobot_chatops.change_commandtoken"


class CommandTokenBulkDeleteView(PermissionRequiredMixin, BulkDeleteView):
    """View for deleting one or more CommandToken records."""

    permission_required = "nautobot_chatops.delete_commandtoken"
    queryset = CommandToken.objects.filter()
    table = CommandTokenTable
    default_return_url = "plugins:nautobot_chatops:commandtoken_list"
