"""API views for dynamic lookup of platform-specific data."""

import contextlib

from django.http import HttpResponseBadRequest, HttpResponseNotFound, JsonResponse
from django.views import View

from nautobot_chatops.dispatchers import Dispatcher


class AccessLookupView(View):
    """Look up a given access grant value by name."""

    http_method_names = ["get"]

    def get(self, request, *args, **kwargs):
        """Handle an inbound GET request for a specific access grant value."""
        for required_param in ("grant_type", "name"):
            if required_param not in request.GET:
                return HttpResponseBadRequest(f"Missing mandatory parameter {required_param}")

        value = None
        # For now we try all available Dispatchers (all supported platforms).
        # In a typical "real" deployment, we would only have one dispatcher_class installed.
        for dispatcher_class in Dispatcher.subclasses():
            try:
                value = dispatcher_class.platform_lookup(request.GET["grant_type"], request.GET["name"])
                if value:
                    break
            except NotImplementedError:
                continue

        if not value:
            return HttpResponseNotFound(f"No {request.GET['grant_type']} {request.GET['name']} found")

        return JsonResponse(data={"value": value})


class UserEmailLookupView(View):
    """Look up a user_id by email."""

    http_method_names = ["get"]

    def get(self, request, *args, **kwargs):
        """Handle an inbound GET request for a specific access grant value."""
        if missing_params := {"email", "platform"} - set(request.GET.keys()):
            return HttpResponseBadRequest(f"Missing mandatory parameter(s) {missing_params}")

        value = None
        for dispatcher_class in Dispatcher.subclasses():
            if dispatcher_class.platform_slug == request.GET["platform"]:
                with contextlib.suppress(NotImplementedError):
                    value = dispatcher_class.lookup_user_id_by_email(request.GET["email"])
        return (
            JsonResponse(data={"user_id": value})
            if value
            else HttpResponseNotFound(f"No user_id found for {request.GET['email']}")
        )
