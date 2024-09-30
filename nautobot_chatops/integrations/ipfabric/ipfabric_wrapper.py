"""IPFabric API integration."""

import logging

from ipfabric import IPFClient

logger = logging.getLogger("nautobot")


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
    INTERFACE_ERRORS_COLUMNS = ["intName", "errPktsPct", "errRate"]
    INTERFACE_DROPS_COLUMNS = ["intName", "dropsPktsPct", "dropsRate"]
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

    # Tables
    table_choices = {
        "addressing": [
            "arp_table",
            "ipv6_neighbor_discovery",
            "mac_table",
            "managed_duplicate_ip",
            "managed_ip_ipv4",
            "managed_ip_ipv6",
            "nat_pools",
            "nat_rules",
        ],
        "cloud": ["virtual_interfaces", "virtual_machines"],
        "dhcp": [
            "relay_global_stats_received",
            "relay_global_stats_relayed",
            "relay_global_stats_sent",
            "relay_global_stats_summary",
            "relay_interfaces",
            "relay_interfaces_stats_received",
            "relay_interfaces_stats_relayed",
            "relay_interfaces_stats_sent",
            "server_excluded_interfaces",
            "server_excluded_ranges",
            "server_leases",
            "server_pools",
            "server_summary",
        ],
        "fhrp": [
            "balancing",
            "glbp_forwarders",
            "group_members",
            "group_state",
            "stproot_alignment",
            "virtual_gateways",
        ],
        "interfaces": [
            "average_rates_data_bidirectional",
            "average_rates_data_bidirectional_per_device",
            "average_rates_data_inbound",
            "average_rates_data_inbound_per_device",
            "average_rates_data_outbound",
            "average_rates_data_outbound_per_device",
            "average_rates_drops_bidirectional",
            "average_rates_drops_bidirectional_per_device",
            "average_rates_drops_inbound",
            "average_rates_drops_inbound_per_device",
            "average_rates_drops_outbound",
            "average_rates_drops_outbound_per_device",
            "average_rates_errors_bidirectional",
            "average_rates_errors_bidirectional_per_device",
            "average_rates_errors_inbound",
            "average_rates_errors_inbound_per_device",
            "average_rates_errors_outbound",
            "average_rates_errors_outbound_per_device",
            "connectivity_matrix",
            "connectivity_matrix_unmanaged_neighbors_detail",
            "connectivity_matrix_unmanaged_neighbors_summary",
            "counters_inbound",
            "counters_outbound",
            "current_rates_data_bidirectional",
            "current_rates_data_inbound",
            "current_rates_data_outbound",
            "duplex",
            "err_disabled",
            "mtu",
            "point_to_point_over_ethernet",
            "point_to_point_over_ethernet_sessions",
            "storm_control_all",
            "storm_control_broadcast",
            "storm_control_multicast",
            "storm_control_unicast",
            "switchport",
            "transceivers",
            "transceivers_errors",
            "transceivers_statistics",
            "transceivers_triggered_thresholds",
            "tunnels_ipv4",
            "tunnels_ipv6",
        ],
        "ip_telephony": ["phones"],
        "inventory": [
            "devices",
            "families",
            "fans",
            "hosts",
            "interfaces",
            "models",
            "modules",
            "os_version_consistency",
            "phones",
            "platforms",
            "pn",
            "sites",
            "vendors",
        ],
        "load_balancing": [
            "virtual_servers",
            "virtual_servers_f5_partitions",
            "virtual_servers_pool_members",
            "virtual_servers_pools",
        ],
        "managed_networks": ["gateway_redundancy", "networks"],
        "management": [
            "aaa_accounting",
            "aaa_authentication",
            "aaa_authorization",
            "aaa_lines",
            "aaa_password_strength",
            "aaa_servers",
            "aaa_users",
            "cisco_smart_licenses_authorization",
            "cisco_smart_licenses_registration",
            "cisco_smart_licenses_reservations",
            "dns_resolver_servers",
            "dns_resolver_settings",
            "flow_overview",
            "license_summary",
            "licenses",
            "licenses_detail",
            "logging_local",
            "logging_remote",
            "logging_summary",
            "netflow_collectors",
            "netflow_devices",
            "netflow_interfaces",
            "ntp_sources",
            "ntp_summary",
            "port_mirroring",
            "ptp_interfaces",
            "ptp_local_clock",
            "ptp_masters",
            "saved_config_consistency",
            "sflow_collectors",
            "sflow_devices",
            "sflow_sources",
            "snmp_communities",
            "snmp_summary",
            "snmp_trap_hosts",
            "snmp_users",
            "telnet_access",
        ],
        "mpls": [
            "l2vpn_circuit_cross_connect",
            "l2vpn_point_to_multipoint",
            "l2vpn_point_to_point_vpws",
            "l2vpn_pseudowires",
            "l3vpn_pe_routers",
            "l3vpn_pe_routes",
            "l3vpn_pe_vrfs",
            "l3vpn_vrf_targets",
            "ldp_interfaces",
            "ldp_neighbors",
            "rsvp_forwarding",
            "rsvp_interfaces",
            "rsvp_neighbors",
        ],
        "multicast": [
            "igmp_groups",
            "igmp_interfaces",
            "igmp_snooping_global_config",
            "igmp_snooping_groups",
            "igmp_snooping_vlans",
            "mac_table",
            "mroute_counters",
            "mroute_first_hop_router",
            "mroute_oil_detail",
            "mroute_overview",
            "mroute_sources",
            "mroute_table",
            "pim_neighbors",
            "rp_bsr",
            "rp_mappings",
            "rp_mappings_groups",
            "rp_overview",
        ],
        "neighbors": [
            "neighbors_all",
            "neighbors_endpoints",
            "neighbors_unidirectional",
            "neighbors_unmanaged",
        ],
        "oam": [
            "unidirectional_link_detection_interfaces",
            "unidirectional_link_detection_neighbors",
        ],
        "platforms": [
            "cisco_fex_interfaces",
            "cisco_fex_modules",
            "cisco_vdc_devices",
            "cisco_vss_chassis",
            "cisco_vss_vsl",
            "environment_fans",
            "environment_modules",
            "environment_power_supplies",
            "environment_power_supplies_fans",
            "juniper_cluster",
            "platform_cisco_vss",
            "poe_devices",
            "poe_interfaces",
            "poe_modules",
            "stacks",
            "stacks_members",
            "stacks_stack_ports",
        ],
        "port_channels": [
            "inbound_balancing_table",
            "member_status_table",
            "mlag_cisco_vpc",
            "mlag_pairs",
            "mlag_peers",
            "mlag_switches",
            "outbound_balancing_table",
        ],
        "qos": [
            "marking",
            "policing",
            "policy_maps",
            "priority_queuing",
            "queuing",
            "random_drops",
            "shapping",
        ],
        "routing": [
            "bgp_address_families",
            "bgp_neighbors",
            "eigrp_interfaces",
            "eigrp_neighbors",
            "isis_interfaces",
            "isis_neighbors",
            "ospf_interfaces",
            "ospf_neighbors",
            "ospfv3_interfaces",
            "ospfv3_neighbors",
            "path_lookup_checks",
            "rip_interfaces",
            "rip_neighbors",
            "route_stability",
            "routes_ipv4",
            "routes_ipv6",
            "summary_protocols",
            "summary_protocols_bgp",
            "summary_protocols_eigrp",
            "summary_protocols_isis",
            "summary_protocols_ospf",
            "summary_protocols_ospfv3",
            "summary_protocols_rip",
            "vrf_detail",
            "vrf_interfaces",
            "vrf_summary",
        ],
        "sdn": [
            "aci_dtep",
            "aci_endpoints",
            "aci_vlan",
            "aci_vrf",
            "apic_applications",
            "apic_bridge_domains",
            "apic_contexts",
            "apic_contracts",
            "apic_controllers",
            "apic_endpoint_groups",
            "apic_endpoint_groups_contracts",
            "vxlan_interfaces",
            "vxlan_peers",
            "vxlan_vni",
            "vxlan_vtep",
        ],
        "sdwan": ["links", "sites"],
        "security": [
            "acl",
            "acl_global_policies",
            "acl_interface",
            "dhcp_snooping",
            "dhcp_snooping_bindings",
            "dmvpn",
            "ipsec_gateways",
            "ipsec_tunnels",
            "secure_ports_devices",
            "secure_ports_interfaces",
            "secure_ports_users",
            "zone_firewall_interfaces",
            "zone_firewall_policies",
        ],
        "stp": [
            "bridges",
            "guards",
            "inconsistencies",
            "inconsistencies_details",
            "inconsistencies_multiple_stp",
            "inconsistencies_ports_multiple_neighbors",
            "inconsistencies_ports_vlan_mismatch",
            "inconsistencies_stp_cdp_ports_mismatch",
            "instances",
            "neighbors",
            "ports",
            "stability",
            "vlans",
        ],
        "vlans": [
            "device_detail",
            "device_summary",
            "l3_gateways",
            "network_summary",
            "site_summary",
        ],
        "wireless": [
            "access_points",
            "clients",
            "controllers",
            "radios_detail",
            "radios_ssid_summary",
        ],
    }

    all_tables = []

    for k, v in table_choices.items():
        all_tables.extend(v)

    skip_properties = [
        "stpDomain",
        "siteKey",
        "rd",
        "taskKey",
        "source",
        "target",
        "neiSiteKey",
        "srcSiteKey",
        "dstSiteKey",
        "inDropsPktsPct",
        "inDropsRate",
        "inImpactDrops",
        "outDropsPktsPct",
        "outDropsRate",
        "outImpactDrops",
        "outBytesRate",
        "uniqId",
        "license",
    ]

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
