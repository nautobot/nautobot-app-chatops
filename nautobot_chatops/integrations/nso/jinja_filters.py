"""Custom filters for nautobot_chatops.integrations.nso."""

from django_jinja import library

from nautobot_chatops.integrations.nso.nso import NSOClient


@library.filter
def get_nso_sync_status(device_name):
    """Pull NSO sync status for specified device."""
    nso = NSOClient()
    try:
        response = nso.sync_status(device_name)
        return response
    except Exception:  # pylint: disable=W0703
        return "N/A"
