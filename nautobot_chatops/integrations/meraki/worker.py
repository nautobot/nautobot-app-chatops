"""Demo meraki addition to Nautobot."""

import logging
import os

from django.conf import settings

from nautobot_chatops.choices import CommandStatusChoices
from nautobot_chatops.workers import handle_subcommands, subcommand_of

from .utils import MerakiClient

MERAKI_LOGO_PATH = "nautobot_meraki/meraki.png"
MERAKI_LOGO_ALT = "Meraki Logo"

LOGGER = logging.getLogger("nautobot")


DEVICE_TYPES = [
    ("all", "all"),
    ("aps", "aps"),
    ("cameras", "cameras"),
    ("firewalls", "firewalls"),
    ("switches", "switches"),
]

try:
    MERAKI_DASHBOARD_API_KEY = settings.PLUGINS_CONFIG["nautobot_chatops"]["meraki_dashboard_api_key"]
except KeyError as err:
    MERAKI_DASHBOARD_API_KEY = os.getenv("MERAKI_DASHBOARD_API_KEY")
    if not MERAKI_DASHBOARD_API_KEY:
        # pylint: disable-next=broad-exception-raised
        raise Exception("Unable to find the Meraki API key.") from err


def meraki_logo(dispatcher):
    """Construct an image_element containing the locally hosted Meraki logo."""
    return dispatcher.image_element(dispatcher.static_url(MERAKI_LOGO_PATH), alt_text=MERAKI_LOGO_ALT)


def prompt_for_organization(dispatcher, command):
    """Prompt the user to select a Meraki Organization."""
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    org_list = client.get_meraki_orgs()
    dispatcher.prompt_from_menu(command, "Select an Organization", [(org["name"], org["name"]) for org in org_list])
    return False


def prompt_for_device(dispatcher, command, org, dev_type=None):
    """Prompt the user to select a Meraki device."""
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    dev_list = client.get_meraki_devices(org)
    if not dev_type:
        dispatcher.prompt_from_menu(
            command, "Select a Device", [(dev["name"], dev["name"]) for dev in dev_list if len(dev["name"]) > 0]
        )
        return False
    dev_list = parse_device_list(dev_type, client.get_meraki_devices(org))
    dispatcher.prompt_from_menu(command, "Select a Device", [(dev, dev) for dev in dev_list])
    return False


def prompt_for_network(dispatcher, command, org):
    """Prompt the user to select a Network name."""
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    net_list = client.get_meraki_networks_by_org(org)
    dispatcher.prompt_from_menu(
        command, "Select a Network", [(net["name"], net["name"]) for net in net_list if len(net["name"]) > 0]
    )
    return False


def prompt_for_port(dispatcher, command, org, switch_name):
    """Prompt the user to select a port from a switch."""
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    ports = client.get_meraki_switchports(org, switch_name)
    dispatcher.prompt_from_menu(command, "Select a Port", [(port["portId"], port["portId"]) for port in ports])
    return False


def parse_device_list(dev_type, devs):
    """Take a list of device and a type and returns only those device types."""
    meraki_dev_mapper = {
        "aps": "MR",
        "cameras": "MV",
        "firewalls": "MX",
        "switches": "MS",
    }
    if dev_type != "all":
        return [dev["name"] for dev in devs if meraki_dev_mapper.get(dev_type) in dev["model"]]
    return [dev["name"] for dev in devs]


def cisco_meraki(subcommand, **kwargs):
    """Interact with Meraki."""
    return handle_subcommands("meraki", subcommand, **kwargs)


@subcommand_of("meraki")
def get_organizations(dispatcher):
    """Gather all the Meraki Organizations."""
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    org_list = client.get_meraki_orgs()
    if len(org_list) == 0:
        dispatcher.send_markdown("NO Meraki Orgs!")
        return (
            CommandStatusChoices.STATUS_SUCCEEDED,
            "NO Meraki Orgs!",
        )
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-organizations",
            [],
            "Organization List",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(["Organizations"], [(org["name"],) for org in org_list])
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def get_admins(dispatcher, org_name=None):
    """Based on an Organization Name Return the Admins."""
    LOGGER.info("ORG NAME: %s", org_name)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki get-admins")
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    admins = client.get_meraki_org_admins(org_name)
    if len(admins) == 0:
        dispatcher.send_markdown(f"NO Meraki Admins for {org_name}!")
        return (
            CommandStatusChoices.STATUS_SUCCEEDED,
            f"NO Meraki Admins for {org_name}!",
        )
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-admins",
            [("Org Name", org_name)],
            "Admin List",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(["Admins"], [(admin["name"],) for admin in admins])
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def get_devices(dispatcher, org_name=None, device_type=None):
    """Gathers devices from Meraki."""
    LOGGER.info("ORG NAME: %s", org_name)
    LOGGER.info("DEVICE TYPE: %s", device_type)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki get-devices")
    if not device_type:
        dispatcher.prompt_from_menu(f"meraki get-devices '{org_name}'", "Select a Device Type", DEVICE_TYPES)
        return False
    LOGGER.info("Translated Device Type: %s", device_type)
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    devices = client.get_meraki_devices(org_name)
    devices_result = parse_device_list(device_type, devices)
    if len(devices_result) == 0:
        dispatcher.send_markdown("There are NO devices that meet the requirements!")
        return (
            CommandStatusChoices.STATUS_SUCCEEDED,
            "There are NO devices that meet the requirements!",
        )
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-devices",
            [("Org Name", org_name), ("Device Type", device_type)],
            "Device List",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(["Devices"], [(device,) for device in devices_result])
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def get_networks(dispatcher, org_name=None):
    """Gathers networks from Meraki."""
    LOGGER.info("ORG NAME: %s", org_name)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki get-networks")
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    networks = client.get_meraki_networks_by_org(org_name)
    if len(networks) == 0:
        dispatcher.send_markdown(f"NO Networks in {org_name}!")
        return (
            CommandStatusChoices.STATUS_SUCCEEDED,
            f"NO Networks in {org_name}!",
        )
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-networks",
            [("Org Name", org_name)],
            "Network List",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(["Networks", "Notes"], [(net["name"], net["notes"]) for net in networks])
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def get_switchports(dispatcher, org_name=None, device_name=None):
    """Gathers switch ports from a MS switch device."""
    LOGGER.info("ORG NAME: %s", org_name)
    LOGGER.info("DEVICE NAME: %s", device_name)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki get-switchports")
    if not device_name:
        return prompt_for_device(dispatcher, f"meraki get-switchports {org_name}", org_name, dev_type="switches")
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    ports = client.get_meraki_switchports(org_name, device_name)
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-switchports",
            [("Org Name", org_name), ("Device Name", device_name)],
            "Switchport Details",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(
        [
            "Port",
            "Name",
            "Tags",
            "Enabled",
            "PoE",
            "Type",
            "VLAN",
            "Voice VLAN",
            "Allowed VLANs",
            "Isolation Enabled",
            "RSTP Enabled",
            "STP Guard",
            "Link Negotiation",
            "Port Scheduled ID",
            "UDLD",
        ],
        [
            (
                entry["portId"],
                entry["name"],
                entry["tags"],
                entry["enabled"],
                entry["poeEnabled"],
                entry["type"],
                entry["vlan"],
                entry["voiceVlan"],
                entry["allowedVlans"],
                entry["isolationEnabled"],
                entry["rstpEnabled"],
                entry["stpGuard"],
                entry["linkNegotiation"],
                entry["portScheduleId"],
                entry["udld"],
            )
            for entry in ports
        ],
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def get_switchports_status(dispatcher, org_name=None, device_name=None):
    """Gathers switch ports status from a MS switch device."""
    LOGGER.info("ORG NAME: %s", org_name)
    LOGGER.info("DEVICE NAME: %s", device_name)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki get-switchports-status")
    if not device_name:
        return prompt_for_device(dispatcher, f"meraki get-switchports-status {org_name}", org_name, dev_type="switches")
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    ports = client.get_meraki_switchports_status(org_name, device_name)
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-switchports-status",
            [("Org Name", org_name), ("Device Name", device_name)],
            "Switchport Details",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(
        [
            "Port",
            "Enabled",
            "Status",
            "Errors",
            "Warnings",
            "Speed",
            "Duplex",
            "Usage (Kb)",
            "Client Count",
            "Traffic In (Kbps)",
        ],
        [
            (
                entry["portId"],
                entry["enabled"],
                entry["status"],
                "\n".join(entry["errors"]),
                "\n".join(entry["warnings"]),
                entry["speed"],
                entry["duplex"],
                "\n".join([f"{key}: {value}" for key, value in entry["usageInKb"].items()]),
                entry["clientCount"],
                "\n".join([f"{key}: {value}" for key, value in entry["trafficInKbps"].items()]),
            )
            for entry in ports
        ],
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def get_firewall_performance(dispatcher, org_name=None, device_name=None):
    """Query Meraki with a firewall to device performance."""
    LOGGER.info("ORG NAME: %s", org_name)
    LOGGER.info("DEVICE NAME: %s", device_name)
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki get-firewall-performance")
    if not device_name:
        devices = client.get_meraki_devices(org_name)
        fws = parse_device_list("firewalls", devices)
        if len(fws) == 0:
            dispatcher.send_markdown("There are NO Firewalls in this Meraki Org!")
            return (
                CommandStatusChoices.STATUS_SUCCEEDED,
                "There are NO Firewalls in this Meraki Org!",
            )
        return prompt_for_device(
            dispatcher, f"meraki get-firewall-performance {org_name}", org_name, dev_type="firewalls"
        )
    fw_perfomance = client.get_meraki_firewall_performance(org_name, device_name)
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-firewall-performance",
            [("Org Name", org_name), ("Device Name", device_name)],
            "Firewall Performance",
            meraki_logo(dispatcher),
        ),
        dispatcher.markdown_block(f"{device_name} has a performance score of {fw_perfomance['perfScore']}."),
    ]
    dispatcher.send_blocks(blocks)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def get_wlan_ssids(dispatcher, org_name=None, net_name=None):
    """Query Meraki for all SSIDs for a given Network."""
    LOGGER.info("ORG NAME: %s", org_name)
    LOGGER.info("NETWORK NAME: %s", net_name)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki get-wlan-ssids")
    if not net_name:
        return prompt_for_network(dispatcher, f"meraki get-wlan-ssids {org_name}", org_name)
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    ssids = client.get_meraki_network_ssids(org_name, net_name)
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-wlan-ssids",
            [("Org Name", org_name), ("Network Name", net_name)],
            "SSID List",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(
        ["Name", "Enabled", "Visible", "Band"],
        [(ssid["name"], ssid["enabled"], ssid["visible"], ssid["bandSelection"]) for ssid in ssids],
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def get_camera_recent(dispatcher, org_name=None, device_name=None):
    """Query Meraki Recent Camera Analytics."""
    LOGGER.info("ORG NAME: %s", org_name)
    LOGGER.info("DEVICE NAME: %s", device_name)
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki get-camera-recent")
    if not device_name:
        devices = client.get_meraki_devices(org_name)
        cams = parse_device_list("cameras", devices)
        if len(cams) == 0:
            dispatcher.send_markdown("There are NO Cameras in this Meraki Org!")
            return (
                CommandStatusChoices.STATUS_SUCCEEDED,
                "There are NO Cameras in this Meraki Org!",
            )
        return prompt_for_device(dispatcher, f"meraki get-camera-recent '{org_name}'", org_name, dev_type="cameras")
    camera_stats = client.get_meraki_camera_recent(org_name, device_name)
    if len(camera_stats) == 0:
        return (
            CommandStatusChoices.STATUS_SUCCEEDED,
            "There are NO Cameras in this Meraki Org!",
        )
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-camera-recent",
            [("Org Name", org_name), ("Device Name", device_name)],
            "Recent Camera Analytics",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(
        ["Zone", "Start Time", "End Time", "Entrances", "Average Count"],
        [
            (
                entry["zoneId"],
                entry["startTs"],
                entry["endTs"],
                entry["entrances"],
                entry["averageCount"],
            )
            for entry in camera_stats
        ],
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def get_clients(dispatcher, org_name=None, device_name=None):
    """Query Meraki for List of Clients."""
    LOGGER.info("ORG NAME: %s", org_name)
    LOGGER.info("DEVICE NAME: %s", device_name)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki get-clients")
    if not device_name:
        return prompt_for_device(dispatcher, f"meraki get-clients '{org_name}'", org_name)
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    client_list = client.get_meraki_device_clients(org_name, device_name)
    if len(client_list) == 0:
        dispatcher.send_markdown(f"There are NO Clients on {device_name}!")
        return (
            CommandStatusChoices.STATUS_SUCCEEDED,
            f"There are NO Clients on {device_name}!",
        )
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-get-clients",
            [("Org Name", org_name), ("Device Name", device_name)],
            "Get Clients",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(
        ["Usage", "Description", "MAC", "IP", "User", "VLAN", "Switchport", "DHCP Hostname"],
        [
            (
                "\n".join([f"{key}: {value}" for key, value in entry["usage"].items()]),
                entry["description"],
                entry["mac"],
                entry["ip"],
                entry["user"],
                entry["vlan"],
                entry["switchport"],
                entry["dhcpHostname"],
            )
            for entry in client_list
        ],
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def get_neighbors(dispatcher, org_name=None, device_name=None):
    """Query Meraki for List of LLDP or CDP Neighbors."""
    LOGGER.info("ORG NAME: %s", org_name)
    LOGGER.info("DEVICE NAME: %s", device_name)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki get-neighbors")
    if not device_name:
        return prompt_for_device(dispatcher, f"meraki get-neighbors '{org_name}'", org_name)
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    neighbor_list = client.get_meraki_device_lldpcdp(org_name, device_name)
    if len(neighbor_list) == 0:
        dispatcher.send_markdown(f"NO LLDP/CDP neighbors for {device_name}!")
        return (
            CommandStatusChoices.STATUS_SUCCEEDED,
            f"NO LLDP/CDP neighbors for {device_name}!",
        )
    table_data = []
    for key, vals in neighbor_list["ports"].items():
        for dp_type, dp_vals in vals.items():
            if dp_type == "cdp":
                table_data.append(
                    (key, dp_type, dp_vals.get("deviceId"), dp_vals.get("portId"), dp_vals.get("address"))
                )
            elif dp_type == "lldp":
                table_data.append(
                    (
                        key,
                        dp_type,
                        dp_vals.get("systemName"),
                        dp_vals.get("portId"),
                        dp_vals.get("managementAddress"),
                    )
                )
            else:
                LOGGER.debug(dp_type)
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "get-get-neighbors",
            [("Org Name", org_name), ("Device Name", device_name)],
            "Get LLDP/CDP Neighbors",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(
        ["Local Port", "Type", "Remote Device", "Remote Port", "Remote Address"],
        table_data,
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def configure_basic_access_port(  # pylint: disable=too-many-arguments
    dispatcher, org_name=None, device_name=None, port_number=None, enabled=None, vlan=None, port_desc=None
):
    """Configure an access port with description, VLAN and state."""
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki configure-basic-access-port")
    if not device_name:
        return prompt_for_device(
            dispatcher, f"meraki configure-basic-access-port {org_name}", org_name, dev_type="switches"
        )
    if not port_number:
        return prompt_for_port(
            dispatcher, f"meraki configure-basic-access-port {org_name} {device_name}", org_name, device_name
        )
    if not (enabled and vlan and port_desc):
        dialog_list = [
            {
                "type": "select",
                "label": "Port Enabled Status",
                "choices": [("Port Enabled", "True"), ("Port Disabled", "False")],
                "default": ("Port Enabled", "True"),
            },
            {"type": "text", "label": "VLAN", "default": ""},
            {"type": "text", "label": "Port Description", "default": ""},
        ]
        dispatcher.multi_input_dialog(
            "meraki",
            f"configure-basic-access-port {org_name} {device_name} {port_number}",
            dialog_title="Port Configuration",
            dialog_list=dialog_list,
        )
        return False
    # pylint: disable-next=use-dict-literal
    port_params = dict(name=port_desc, enabled=bool(enabled), type="access", vlan=vlan)
    LOGGER.info("PORT PARMS: %s", port_params)
    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    result = client.update_meraki_switch_port(org_name, device_name, port_number, **port_params)
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "configure-basic-access-port",
            [
                ("Org Name", org_name),
                ("Device Name", device_name),
                ("Port ID", port_number),
            ],
            "Configured Port",
            meraki_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(list(result.keys()), [tuple(result.values())])
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("meraki")
def cycle_port(dispatcher, org_name=None, device_name=None, port_number=None):
    """Cycle a port on a switch."""
    LOGGER.info("ORG NAME: %s", org_name)
    if not org_name:
        return prompt_for_organization(dispatcher, "meraki cycle-port")
    if not device_name:
        return prompt_for_device(dispatcher, f"meraki cycle-port {org_name}", org_name, dev_type="switches")
    if not port_number:
        return prompt_for_port(dispatcher, f"meraki cycle-port {org_name} {device_name}", org_name, device_name)

    client = MerakiClient(api_key=MERAKI_DASHBOARD_API_KEY)
    cycled_port = client.port_cycle(org_name, device_name, port_number)
    blocks = [
        *dispatcher.command_response_header(
            "meraki",
            "cycle-port",
            [("Org Name", org_name), ("Device Name", device_name), ("Port", port_number)],
            "cycled port",
            meraki_logo(dispatcher),
        ),
        dispatcher.markdown_block(f"Port {cycled_port['ports'][0]} cycled successfully!"),
    ]
    dispatcher.send_blocks(blocks)
    return CommandStatusChoices.STATUS_SUCCEEDED
