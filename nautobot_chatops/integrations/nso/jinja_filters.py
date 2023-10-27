"""Custom filters for nautobot_plugin_chatops_nso."""
from django_jinja import library
from nautobot_plugin_chatops_nso.nso import NSOClient


@library.filter
def get_nso_sync_status(device_name):
    """Pull NSO sync status for specified device."""
    nso = NSOClient()
    try:
        response = nso.sync_status(device_name)
        return response
    except Exception:  # pylint: disable=W0703
        return "N/A"
