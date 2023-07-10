"""Utility functions for Nautobot "ipfabric" command and subcommands."""


def parse_hosts(hosts: dict) -> list:
    """Parse inventory host information."""
    parsed_hosts = []

    for host in hosts:
        parsed_edges = []
        parsed_gws = []
        parsed_aps = []

        for edge in host.get("edges"):
            parsed_edges.append(f"{edge.get('hostname', '')} ({edge.get('intName', '')})")

        for gateway in host.get("gateways"):
            parsed_gws.append(f"{gateway.get('hostname', '')} ({gateway.get('intName', '')})")

        for access_point in host.get("accessPoints"):
            parsed_aps.append(f"{access_point.get('hostname', '')} ({access_point.get('intName', '')})")

        host["edges"] = ";".join(parsed_edges) if parsed_edges else ""
        host["gateways"] = ";".join(parsed_gws) if parsed_gws else ""
        host["accessPoints"] = ";".join(parsed_aps) if parsed_aps else ""

        parsed_hosts.append(host)
    return parsed_hosts
