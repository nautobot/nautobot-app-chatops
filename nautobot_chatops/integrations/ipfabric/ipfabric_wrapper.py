"""IPFabric API integration."""

import inspect
import logging

from ipfabric import IPFClient
from ipfabric.models import Inventory, Table, Technology

logger = logging.getLogger("nautobot")


def _is_table(return_type):
    return inspect.isclass(return_type) and issubclass(return_type, Table)


def _table_names(model):
    return sorted(name for name, field in model.model_computed_fields.items() if _is_table(field.return_type))


def discover_table_choices():
    """Build the table-diff menu from the tables defined by the installed `ipfabric` SDK.

    The available tables change between SDK releases, which track the IP Fabric server version, so they are read
    from the SDK's `Technology` and `Inventory` models instead of being listed by hand.

    Returns:
        dict: Mapping of category name to a sorted list of table names, e.g. `{"routing": ["bgp_neighbors", ...]}`.
    """
    choices = {"inventory": _table_names(Inventory)}
    for category, field in Technology.model_computed_fields.items():
        # Technology also exposes a few tables directly (e.g. `serial_ports`); only nested categories are menus.
        if inspect.isclass(field.return_type) and not _is_table(field.return_type):
            choices[category] = _table_names(field.return_type)
    return dict(sorted(choices.items()))


# pylint: disable=R0904, disable=R0903
class IpFabric:
    """IpFabric will provide a wrapper for python-ipfabric clients that contain all the necessary API methods."""

    # Default IP Fabric API pagination limit
    DEFAULT_PAGE_LIMIT = 100
    LAST = "$last"
    PREV = "$prev"
    LAST_LOCKED = "$lastLocked"

    EMPTY = "(empty)"

    # COLUMNS
    INVENTORY_COLUMNS = [
        "hostname",
        "siteName",
        "vendor",
        "platform",
        "model",
        "memoryUtilization",
        "version",
        "sn",
        "loginIp",
    ]
    DEVICE_INFO_COLUMNS = ["hostname", "siteName", "vendor", "platform", "model"]
    INTERFACE_LOAD_COLUMNS = ["intName", "bytes", "pkts"]
    BGP_NEIGHBORS_COLUMNS = [
        "hostname",
        "localAs",
        "srcInt",
        "localAddress",
        "vrf",
        "neiHostname",
        "neiAddress",
        "neiAs",
        "state",
        "totalReceivedPrefixes",
    ]
    WIRELESS_SSID_COLUMNS = [
        "wlanSsid",
        "siteName",
        "apName",
        "radioDscr",
        "radioStatus",
        "clientCount",
    ]
    WIRELESS_CLIENT_COLUMNS = [
        "controller",
        "siteName",
        "apName",
        "client",
        "clientIp",
        "ssid",
        "rssi",
        "signalToNoiseRatio",
        "state",
    ]
    ADDRESSING_HOSTS_COLUMNS = [
        "ip",
        "vrf",
        "dnsName",
        "siteName",
        "edges",
        "gateways",
        "accessPoints",
        "mac",
        "vendor",
        "vlan",
    ]

    # Filters
    IEQ = "ieq"
    EQ = "eq"

    # Sort
    INTERFACE_SORT = {"order": "desc", "column": "intName"}

    table_choices = discover_table_choices()

    def __init__(self, base_url, token, verify=False, timeout=10):
        """Initialise the IP Fabric wrapper object to provide access to the client and diagram API.

        Uses the python-ipfabric library.

        Args:
            base_url (str): URL of the IP Fabric host.
            token (str): API token for the IP Fabric client to access the server.
            verify (bool, optional): Verify identity of requested host when using HTTPS. Defaults to False.
                Enable with verify='path/to/client.pem'.
            timeout (int, optional): HTTP timeout connection (seconds). Defaults to 10.
        """
        self.client = IPFClient(
            base_url=base_url,
            auth=token,
            verify=verify,
            timeout=timeout,
        )
        self.ui_url = str(self.client.base_url).split("api", maxsplit=1)[0]

    def get_formatted_snapshots(self):
        """Get all loaded snapshots and format them for display in chatops choice menu.

        Returns:
            dict: Snapshot objects as dict of tuples {snapshot_ref: (description, snapshot_id)}
        """
        formatted_snapshots = {}
        snapshot_refs = []
        for snapshot_ref, snapshot in self.client.snapshots.items():
            description = "🔒 " if snapshot.locked else ""
            if snapshot_ref in [self.LAST, self.PREV, self.LAST_LOCKED]:
                description += f"{snapshot_ref}: "
                snapshot_refs.append(snapshot_ref)
            if snapshot.name:
                description += snapshot.name + " - " + snapshot.end.strftime("%d-%b-%y %H:%M:%S")
            else:
                description += snapshot.end.strftime("%d-%b-%y %H:%M:%S") + " - " + snapshot.snapshot_id
            formatted_snapshots[snapshot_ref] = (description, snapshot.snapshot_id)
        for ref in snapshot_refs:
            formatted_snapshots.pop(formatted_snapshots[ref][1], None)

        return formatted_snapshots

    def get_snapshots_table(self, formatted_snapshots=None):
        """Get all snapshots and format them for display in chatops table.

        Returns:
            list: Snapshot descriptions as list of as tuple [(data, data, ...)]
        """
        formatted_snapshots = formatted_snapshots if formatted_snapshots else self.get_formatted_snapshots()

        snapshot_table = [
            (
                snap_id,
                self.client.snapshots[snap_id].name or self.EMPTY,
                self.client.snapshots[snap_id].start.strftime("%d-%b-%y %H:%M:%S"),
                self.client.snapshots[snap_id].end.strftime("%d-%b-%y %H:%M:%S"),
                self.client.snapshots[snap_id].total_dev_count,
                self.client.snapshots[snap_id].licensed_dev_count or self.EMPTY,
                str(self.client.snapshots[snap_id].locked),
                self.client.snapshots[snap_id].version or self.EMPTY,
                getattr(self.client.snapshots[snap_id], "note", None) or self.EMPTY,
            )
            for snap_id in formatted_snapshots
        ]
        return snapshot_table
