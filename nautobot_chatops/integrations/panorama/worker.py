"""Example worker to handle /panorama chat commands with 1 subcommand addition."""

import logging
import os
import re
from ipaddress import ip_network
from typing import List, Tuple, Union

from nautobot.dcim.models import Interface
from netmiko import NetMikoTimeoutException
from netutils.protocol_mapper import PROTO_NAME_TO_NUM
from panos.errors import PanDeviceError, PanDeviceXapiError
from panos.firewall import Firewall
from panos.panorama import DeviceGroup

from nautobot_chatops.choices import CommandStatusChoices
from nautobot_chatops.integrations.panorama.utils import (
    connect_panorama,
    get_all_rules,
    get_from_pano,
    get_object,
    get_panorama_device_group_hierarchy,
    get_rule_match,
    split_rules,
    start_packet_capture,
)
from nautobot_chatops.workers import handle_subcommands, subcommand_of

PALO_LOGO_PATH = "nautobot_palo/palo_transparent.png"
PALO_LOGO_ALT = "Palo Alto Networks Logo"

logger = logging.getLogger(__name__)


def palo_logo(dispatcher):
    """Construct an image_element containing the locally hosted Palo Alto Networks logo."""
    return dispatcher.image_element(dispatcher.static_url(PALO_LOGO_PATH), alt_text=PALO_LOGO_ALT)


def prompt_for_device(dispatcher, command, conn):
    """Prompt the user to select a Palo Alto device."""
    device_list = []
    groups = get_from_pano(connection=conn, groups=True)
    for group_name, group in groups.items():
        if group not in device_list:
            device_list.append(f"{group_name}__DeviceGroup")
        for dev in group["devices"]:
            device_list.append(dev["hostname"])
    dispatcher.prompt_from_menu(command, "Select a Device or DeviceGroup", [(dev, dev) for dev in device_list])
    return CommandStatusChoices.STATUS_SUCCEEDED


def prompt_for_versions(dispatcher, command, conn, prompt_offset=None):
    """Prompt the user to select a version."""
    conn.software.check()
    versions = conn.software.versions
    if prompt_offset:
        prompt_offset = int(prompt_offset)
    dispatcher.prompt_from_menu(command, "Select a Version", [(ver, ver) for ver in versions][prompt_offset:])
    return CommandStatusChoices.STATUS_SUCCEEDED


def is_valid_cidr(ip_address: str) -> str:
    """Checks if string is a valid IPv4 CIDR."""
    try:
        return str(ip_network(str(ip_address)))
    except ValueError:
        return ""


def notify_user_of_error(dispatcher: object, error_msg: str) -> str:
    """Notify the user of an error, logs error to syslog, and returns FAILED command status for Nautobot logging."""
    logger.error(error_msg)
    dispatcher.send_warning(error_msg)
    return CommandStatusChoices.STATUS_FAILED


def capture_packet_str_validation(
    dispatcher: object,
    value_to_check: str,
    valid_values: List[Tuple[str, Union[str, int]]],
    variable_description: str,
    not_found_error: str,
) -> Tuple[str, bool]:
    """Validates a user string input against list existing of valid values.

    Args:
        dispatcher (obj): Dispatcher object from Nautobot/Django
        value_to_check (str): Value to check to see if valid
        valid_values (list): List of tuples with valid values
        variable_description (str): Type of variable being checked (e.g. "Interface")
        not_found_error (str): Error to display to user and log to syslog if value given is invalid

    Returns:
        tuple: Tuple of string value, and boolean if validation passed
    """
    try:
        valid_item_found = [
            valid_item for valid_item in valid_values if value_to_check.lower() == valid_item[0].lower()
        ]
        if valid_item_found:
            return valid_item_found[0][1], True
        # User supplied an invalid or unsupported value
        return notify_user_of_error(dispatcher, not_found_error), False
    except AttributeError:
        # User may have supplied an invalid value, or there was an error parsing the value given as a string
        #   Ideally this should not trigger
        return notify_user_of_error(dispatcher, f"{variable_description} is invalid."), False


def panorama(subcommand, **kwargs):
    """Perform panorama and its subcommands."""
    return handle_subcommands("panorama", subcommand, **kwargs)


@subcommand_of("panorama")
def get_devices(dispatcher, **kwargs):
    """Get information about connected devices from Panorama."""
    pano = connect_panorama()
    dispatcher.send_markdown(
        (
            f"Hey {dispatcher.user_mention()}, "
            "I'm gathering information about the devices connected to this Panorama as requested."
        ),
        ephemeral=True,
    )
    devices = get_from_pano(connection=pano, devices=True)
    dispatcher.send_markdown(
        f"{dispatcher.user_mention()}, here are the connected devices as requested.", ephemeral=True
    )
    dispatcher.send_large_table(
        ["Hostname", "Serial", "DeviceGroup", "IP Address", "Active", "Model", "OS Version"],
        [list(device.values()) for _, device in devices.items()],
        title="Device Inventory",
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("panorama")
def get_devicegroups(dispatcher, **kwargs):
    """Get information about DeviceGroups and their associated devices from Panorama."""
    pano = connect_panorama()
    dispatcher.send_markdown(
        (
            f"Hey {dispatcher.user_mention()}, "
            "I'm gathering information about the DeviceGroups connected to this Panorama."
        ),
        ephemeral=True,
    )
    devicegroups = get_from_pano(connection=pano, groups=True)
    dgh = get_panorama_device_group_hierarchy(pano=pano)
    dispatcher.send_markdown(
        f"{dispatcher.user_mention()}, here is the information about the configured DeviceGroups as requested.",
        ephemeral=True,
    )
    message = ""
    for group_name, group_info in devicegroups.items():
        message += f"{group_name}\n"
        if dgh.get(group_name):
            message += f"Parent DeviceGroup: {dgh[group_name]}\n"
        if len(group_info["devices"]) > 0:
            for dev in group_info["devices"]:
                message += (
                    f"Hostname: {dev['hostname']}\nAddress: {dev['address']}\nSerial: {dev['serial']}\n"
                    f"Model: {dev['model']}\nVersion: {dev['version']}\n\n"
                )
        else:
            message += f"No connected devices found for {group_name}.\n"
    dispatcher.send_snippet(
        message,
        title="DeviceGroups",
        ephemeral=True,
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("panorama")
def validate_rule_exists(dispatcher, device, src_ip, dst_ip, protocol, dst_port):  # pylint:disable=too-many-arguments,too-many-locals,too-many-branches,too-many-statements
    """Verify that the rule exists within a device, via Panorama."""
    dialog_list = [
        {
            "type": "text",
            "label": "Source IP",
        },
        {
            "type": "text",
            "label": "Destination IP",
        },
        {
            "type": "select",
            "label": "Dest IP",
            "choices": [("TCP", "TCP"), ("UDP", "UDP")],
            "default": ("TCP", "TCP"),
        },
        {
            "type": "text",
            "label": "Destination Port",
            "default": "443",
        },
    ]

    if all([device, src_ip, dst_ip, protocol, dst_port]):
        dispatcher.send_markdown(
            f"Standby {dispatcher.user_mention()}, I'm checking the firewall rules now. ",
            ephemeral=True,
        )

    pano = connect_panorama()
    if not device:
        return prompt_for_device(dispatcher, "panorama validate-rule-exists", pano)

    dev_obj = get_object(pano, device)

    if not dev_obj:
        dispatcher.send_warning(f"Unable to find {device}.")
        return CommandStatusChoices.STATUS_FAILED

    if isinstance(dev_obj, DeviceGroup):
        for child in dev_obj.children:
            if isinstance(child, Firewall):
                try:
                    child.refresh()
                    dev_obj = child
                    break
                except PanDeviceXapiError as err:
                    dispatcher.send_warning(f"Unable to connect to {child}. {err}")

    if not all([src_ip, dst_ip, protocol, dst_port]):
        dispatcher.multi_input_dialog(
            "panorama", f"validate-rule-exists {device}", "Verify if rule exists", dialog_list
        )
        return CommandStatusChoices.STATUS_SUCCEEDED

    # Validate IP addresses are valid or 'any' is used.
    # TODO: Add support for hostnames
    if not is_valid_cidr(src_ip) and src_ip.lower() != "any":
        dispatcher.send_warning(
            f"Source IP {src_ip} is not a valid host or CIDR. "
            "Please specify a valid host IP address or IP network in CIDR notation."
        )
        dispatcher.multi_input_dialog(
            "panorama", f"validate-rule-exists {device}", "Verify if rule exists", dialog_list
        )
        return CommandStatusChoices.STATUS_ERRORED

    if not is_valid_cidr(dst_ip) and src_ip.lower() != "any":
        dispatcher.send_warning()
        dispatcher.multi_input_dialog(
            "panorama", f"validate-rule-exists {device}", "Verify if rule exists", dialog_list
        )
        return CommandStatusChoices.STATUS_ERRORED

    data = {
        "src_ip": src_ip,
        "dst_ip": dst_ip,
        "protocol": PROTO_NAME_TO_NUM.get(protocol.upper()),
        "dst_port": dst_port,
    }
    matching_rules = get_rule_match(pano=pano, five_tuple=data, device=dev_obj)

    if matching_rules:
        all_rules = []
        for rule in get_all_rules(device, pano):
            if rule.name == matching_rules[0]["name"]:
                rule_list = []
                rule_list.append(rule.name)
                sources = ""
                for src in rule.source:
                    sources += src + ", "
                rule_list.append(sources[:-2])
                destination = ""
                for dst in rule.destination:
                    destination += dst + ", "
                rule_list.append(destination[:-2])
                service = ""
                for svc in rule.service:
                    service += svc + ", "
                rule_list.append(service[:-2])
                rule_list.append(rule.action)
                all_rules.append(rule_list)
        blocks = [
            *dispatcher.command_response_header(
                "panorama",
                "validate-rule-exists",
                [
                    ("Device", device),
                    ("Source IP", src_ip),
                    ("Destination IP", dst_ip),
                    ("Protocol", protocol.upper()),
                    ("Destination Port", dst_port),
                ],
                "validated rule",
                palo_logo(dispatcher),
            ),
        ]
        dispatcher.send_blocks(blocks)
        dispatcher.send_markdown(f"The Traffic is permitted via a rule named `{matching_rules[0]['name']}`:")
        dispatcher.send_large_table(("Name", "Source", "Destination", "Service", "Action"), all_rules)
    else:
        blocks = [
            *dispatcher.command_response_header(
                "panorama",
                "validate-rule-exists",
                [
                    ("Device", device),
                    ("Source IP", src_ip),
                    ("Destination IP", dst_ip),
                    ("Protocol", protocol.upper()),
                    ("Destination Port", dst_port),
                ],
                "rule validation",
                palo_logo(dispatcher),
            ),
        ]
        dispatcher.send_blocks(blocks)
        dispatcher.send_markdown("`No matching rule` found for:")
        all_values = [
            ["Device", device],
            ["Source IP", src_ip],
            ["Destination", dst_ip],
            ["Protocol", protocol],
            ["Destination Port", dst_port],
        ]
        dispatcher.send_large_table(("Object", "Value"), all_values)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("panorama")
def get_version(dispatcher):
    """Obtain software version information for Panorama."""
    dispatcher.send_markdown(
        f"Standby {dispatcher.user_mention()}, I'm getting Panorama's version for you.",
        ephemeral=True,
    )
    pano = connect_panorama()
    version = pano.refresh_system_info().version
    blocks = [
        *dispatcher.command_response_header(
            "panorama",
            "get-version",
            [],
            "Panorama version",
            palo_logo(dispatcher),
        )
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_markdown(f"The version of Panorama is {version}.")
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("panorama")
def upload_software(dispatcher, device, version, **kwargs):
    """Upload software to specified Palo Alto device."""
    logger.info("DEVICE: %s", device)
    logger.info("VERSION: %s", version)
    pano = connect_panorama()
    if not device:
        return prompt_for_device(dispatcher, "panorama upload-software", pano)

    if not version:
        return prompt_for_versions(dispatcher, f"panorama upload-software {device}", pano)

    if "menu_offset" in version:
        return prompt_for_versions(
            dispatcher, f"panorama upload-software {device}", pano, prompt_offset=re.findall(r"\d+", version)[0]
        )

    dispatcher.send_markdown(
        f"Hey {dispatcher.user_mention()}, you've requested to upload {version} to {device}.", ephemeral=True
    )
    _firewall = get_object(pano=pano, object_name=device)

    is_devicegroup = False
    if isinstance(_firewall, DeviceGroup):
        is_devicegroup = True
        for child in _firewall.children:
            try:
                child.refresh()
                _firewall = child
                break
            except PanDeviceXapiError as err:
                dispatcher.send_warning(f"There was an issue connecting to {child}. {err}")

    pano.add(_firewall)
    dispatcher.send_markdown("Starting download now...", ephemeral=True)
    try:
        if is_devicegroup:
            _firewall.software.download(version, sync_to_peer=True)
        else:
            _firewall.software.download(version)
    except PanDeviceError as err:
        blocks = [
            *dispatcher.command_response_header(
                "panorama",
                "upload-software",
                [("Device", device), ("Version", version)],
                "information on that upload software task",
                palo_logo(dispatcher),
            ),
        ]
        dispatcher.send_blocks(blocks)
        dispatcher.send_warning(f"There was an issue uploading {version} to {device}. {err}")
        return CommandStatusChoices.STATUS_SUCCEEDED
    blocks = [
        *dispatcher.command_response_header(
            "panorama",
            "upload-software",
            [("Device", device), ("Version", version)],
            "information on that upload software task",
            palo_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_markdown(f"As requested, {version} is being uploaded to {device}.")
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("panorama")
def install_software(dispatcher, device, version, **kwargs):
    """Install software to specified Palo Alto device."""
    logger.info("DEVICE: %s", device)
    logger.info("VERSION: %s", version)
    pano = connect_panorama()
    if not device:
        return prompt_for_device(dispatcher, "panorama install-software", pano)

    if not version:
        prompt_for_versions(dispatcher, f"panorama install-software {device}", pano)
        return False

    if "menu_offset" in version:
        return prompt_for_versions(
            dispatcher, f"panorama upload-software {device}", pano, prompt_offset=re.findall(r"\d+", version)[0]
        )

    devs = get_from_pano(connection=pano, devices=True)
    dispatcher.send_markdown(
        f"Hey {dispatcher.user_mention()}, you've requested to install {version} to {device}.", ephemeral=True
    )
    _firewall = Firewall(serial=devs[device]["serial"])
    pano.add(_firewall)
    try:
        _firewall.software.install(version)
    except PanDeviceError as err:
        blocks = [
            *dispatcher.command_response_header(
                "panorama",
                "install-software",
                [("Device", device), ("Version", version)],
                "information on that install software task",
                palo_logo(dispatcher),
            ),
        ]
        dispatcher.send_blocks(blocks)
        dispatcher.send_warning(f"There was an issue installing {version} on {device}. {err}")
        return CommandStatusChoices.STATUS_FAILED
    blocks = [
        *dispatcher.command_response_header(
            "panorama",
            "install-software",
            [("Device", device), ("Version", version)],
            "information on that install software task",
            palo_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_markdown(f"As requested, {version} has been installed on {device}.")
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("panorama")
def get_device_rules(dispatcher, device, **kwargs):
    """Get list of firewall rules with details."""
    pano = connect_panorama()
    if not device:
        return prompt_for_device(dispatcher, "panorama get-device-rules", pano)

    dispatcher.send_markdown(
        f"Standby {dispatcher.user_mention()}, I'm getting the rules for device {device}.",
        ephemeral=True,
    )

    rules = get_all_rules(device, pano)

    all_rules = []
    for rule in rules:
        rule_list = []
        rule_list.append(rule.name)
        sources = ""
        for src in rule.source:
            sources += src + ", "
        rule_list.append(sources[:-2])
        destination = ""
        for dst in rule.destination:
            destination += dst + ", "
        rule_list.append(destination[:-2])
        service = ""
        for svc in rule.service:
            service += svc + ", "
        rule_list.append(service[:-2])
        rule_list.append(rule.action)
        all_rules.append(rule_list)

    blocks = [
        *dispatcher.command_response_header(
            "panorama",
            "get-device-rules",
            [("Device", device)],
            f"rules for device {device}",
            palo_logo(dispatcher),
        ),
    ]
    dispatcher.send_blocks(blocks)
    dispatcher.send_large_table(("Name", "Source", "Destination", "Service", "Action"), all_rules)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("panorama")
def export_device_rules(dispatcher, device, **kwargs):
    """Generate list of firewall rules with details in CSV format."""
    if device:
        dispatcher.send_markdown(
            f"Standby {dispatcher.user_mention()}, I'm creating the CSV file for the rules on device {device}.",
            ephemeral=True,
        )
    else:
        pano = connect_panorama()
        return prompt_for_device(dispatcher, "panorama export-device-rules", pano)
    logger.debug("Running /panorama export-device-rules, device=%s", device)

    pano = connect_panorama()
    rules = get_all_rules(device, pano)

    file_name = f"{device}-device-rules.csv"

    output = split_rules(rules)
    with open(file_name, "w") as file:  # pylint: disable=unspecified-encoding
        file.write(output)

    dispatcher.send_image(file_name)

    try:
        os.remove(file_name)
        logger.debug("Deleted generated CSV file %s", file_name)
    except FileNotFoundError:
        logger.warning("Unable to delete generated CSV file %s", file_name)

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("panorama")
def capture_traffic(
    dispatcher: object,
    device: str,
    snet: str,
    dnet: str,
    dport: str,
    intf_name: str,
    ip_proto: str,
    stage: str,
    capture_seconds: str,
    **kwargs,
):  # pylint:disable=too-many-statements,too-many-arguments,too-many-return-statements,too-many-locals,too-many-branches
    """Capture IP traffic on PANOS Device.

    Args:
        dispatcher (object): Chatops app dispatcher object
        device (str): Device name
        snet (str): Source IP/network in IPv4 CIDR notation
        dnet (str): Destination IP/network in IPv4 CIDR notation
        dport (str): Destination port
        intf_name (str): Interface name
        ip_proto (str): Protocol for destination port
        stage (str): Stage to use
        capture_seconds (str): Number of seconds to run packet capture
        **kwargs: Any additional args

    """
    logger.info("Starting capture_traffic()")

    valid_ip_protocols = [("ANY", "any"), ("TCP", "6"), ("UDP", "17")]
    valid_stages = [("Receive", "receive"), ("Transmit", "transmit"), ("Drop", "drop"), ("Firewall", "firewall")]

    if all([device, snet, dnet, dport, intf_name, ip_proto, stage, capture_seconds]):
        dispatcher.send_markdown(
            f"Standby {dispatcher.user_mention()}, I'm starting the packet capture on device {device}.",
            ephemeral=True,
        )

    # ---------------------------------------------------
    # Get device to execute against
    # ---------------------------------------------------
    pano = connect_panorama()

    if not device:
        return prompt_for_device(dispatcher, "panorama capture-traffic", pano)

    # ---------------------------------------------------
    # Get parameters used to filter packet capture
    # ---------------------------------------------------
    # TODO: This needs to be removed and the interfaces pulled dynamically from Panorama
    _interfaces = Interface.objects.filter(device__name=device)
    interface_list = [(intf.name, intf.name) for intf in _interfaces]

    dialog_list = [
        {
            "type": "text",
            "label": "Source Network",
            "default": "0.0.0.0/0",
        },
        {
            "type": "text",
            "label": "Destination Network",
            "default": "0.0.0.0/0",
        },
        {
            "type": "text",
            "label": "Destination Port",
            "default": "any",
        },
        {
            "type": "select",
            "label": "Interface Name",
            "choices": interface_list,
            "confirm": False,
        },
        {
            "type": "select",
            "label": "IP Protocol",
            "choices": valid_ip_protocols,
            "confirm": False,
            "default": ("ANY", "any"),
        },
        {
            "type": "select",
            "label": "Capture Stage",
            "choices": valid_stages,
            "confirm": False,
            "default": ("Receive", "receive"),
        },
        {
            "type": "text",
            "label": "Capture Seconds",
            "default": "15",
        },
    ]

    if not all([snet, dnet, dport, intf_name, ip_proto, stage, capture_seconds]):
        dispatcher.multi_input_dialog("panorama", f"capture-traffic {device}", "Capture Filter", dialog_list)
        return CommandStatusChoices.STATUS_SUCCEEDED

    logger.debug(
        (
            "Running packet capture with the following information:\nDevice - %s\nSource Network - %s\n"
            "Destination Network - %s\nDestination Port - %s\nInterface Name - %s\nIP Protocol - %s\nStage - %s\n"
            "Capture Seconds - %s"
        ),
        device,
        snet,
        dnet,
        dport,
        intf_name,
        ip_proto,
        stage,
        capture_seconds,
    )

    # ---------------------------------------------------
    # Validate dialog list
    # ---------------------------------------------------

    # Validate snet
    try:
        ip_network(snet)
    except ValueError:
        return notify_user_of_error(
            dispatcher, f"Source Network {snet} is not a valid CIDR, please specify a valid network in CIDR notation."
        )

    # Validate dnet
    try:
        ip_network(dnet)
    except ValueError:
        return notify_user_of_error(
            dispatcher,
            f"Destination Network {dnet} is not a valid CIDR, please specify a valid network in CIDR notation.",
        )

    # Validate dport
    dport_error = f"Destination Port {dport} must be either the string `any` or an integer in the range 1-65535."
    try:
        if not 1 <= int(dport) <= 65535:
            raise TypeError
    except ValueError:
        # Port may be a string, which is still valid
        dport = dport.lower()
        if dport != "any":
            return notify_user_of_error(dispatcher, dport_error)
    except (AttributeError, TypeError):
        return notify_user_of_error(dispatcher, dport_error)

    # Validate intf_name
    # If the user supplied an interface name, this uses the actual one present and ignores case sensitivity
    intf_name, validation_result = capture_packet_str_validation(
        dispatcher, intf_name, interface_list, "Interface", f"Interface {intf_name} was not found on device {device}."
    )
    if not validation_result:
        return intf_name

    # Validate ip_proto
    # We have to validate here and do some conversion in case the user pastes in the full command
    # If valid, change to value needed for actual command. E.g. 'tcp' should be the protocol number '6'
    # Invalid because we currently do not support pasting in protocol integers,
    # only the protocol name (e.g. 'tcp') or 'any', or the user supplied an unsupported protocol.
    ip_proto, validation_result = capture_packet_str_validation(
        dispatcher,
        ip_proto,
        valid_ip_protocols,
        "IP protocol",
        f"IP protocol {ip_proto} must be a valid IP protocol `tcp`, `udp`, or the string `any`.",
    )
    if not validation_result:
        return ip_proto

    # Validate stage
    stage, validation_result = capture_packet_str_validation(
        dispatcher,
        stage,
        valid_stages,
        "Stage",
        f"Stage {stage} must be a valid stage `drop`, `firewall`, `receive`, or `transmit`",
    )
    if not validation_result:
        return stage

    # Validate capture_seconds
    try:
        if not 1 <= int(capture_seconds) <= 120:
            raise ValueError
    except ValueError:
        return notify_user_of_error(dispatcher, "Capture Seconds must be specified as a number in the range 1-120.")

    # ---------------------------------------------------
    # Start Packet Capture on Device
    # ---------------------------------------------------
    devices = get_from_pano(connection=pano, devices=True)
    try:
        # TODO: This gathers the internal IP address that Panorama sees.
        # However if the firewall is accessible to Nautobot via a different IP address (e.g. external), this fails.
        #       Add support for multiple possible IP addresses here
        device_ip = devices[device]["ip_address"]
        logger.info("Attempting packet capture to device %s via IP address %s.", device, device_ip)
    except KeyError:
        return notify_user_of_error(dispatcher, f"No IP address found assigned to device {device} in Panorama.")

    # Name of capture file
    capture_filename = f"{device}-packet-capture.pcap"

    # Begin packet capture on device
    try:
        start_packet_capture(
            capture_filename,
            device_ip,
            {
                "snet": snet.split("/")[0],
                "scidr": snet.split("/")[1],
                "dnet": dnet.split("/")[0],
                "dcidr": dnet.split("/")[1],
                "dport": dport,
                "intf_name": intf_name,
                "ip_proto": ip_proto,
                "stage": stage,
                "capture_seconds": capture_seconds,
            },
        )
    except NetMikoTimeoutException:
        return notify_user_of_error(dispatcher, f"Unable to connect to device {device} via IP address {device_ip}.")

    blocks = [
        *dispatcher.command_response_header(
            "panorama",
            "capture-traffic",
            [("Details below:", " ")],
            "PCAP file",
            palo_logo(dispatcher),
        ),
    ]

    dispatcher.send_blocks(blocks)

    all_values = [
        ["Device", device],
        ["Source Network", snet],
        ["Destination Network", dnet],
        ["Destination Port", dport],
        ["Interface Name", intf_name],
        ["IP Protocol", ip_proto],
        ["Stage", stage],
        ["Capture Seconds", capture_seconds],
    ]
    dispatcher.send_large_table(("Object", "Value"), all_values)
    dispatcher.send_image(capture_filename)
    return CommandStatusChoices.STATUS_SUCCEEDED
