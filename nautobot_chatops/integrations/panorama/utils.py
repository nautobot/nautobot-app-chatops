"""Functions used for interacting with Panroama."""

import logging
import time
from typing import List

import defusedxml.ElementTree as ET
import requests
from netmiko import ConnectHandler
from panos.errors import PanDeviceXapiError
from panos.firewall import Firewall
from panos.panorama import DeviceGroup, Panorama, PanoramaDeviceGroupHierarchy
from panos.policies import PostRulebase, PreRulebase, Rulebase, SecurityRule
from requests.exceptions import RequestException

from .constant import DEFAULT_TIMEOUT, PLUGIN_CFG

logger = logging.getLogger(__name__)


def get_api_key_api(url: str = PLUGIN_CFG["panorama_host"]) -> str:
    """Returns the API key.

    Args:
        url (str): URL of the device

    Returns:
        The API key.
    """
    url = url.rstrip("/")

    params = {"type": "keygen", "user": PLUGIN_CFG["panorama_user"], "password": PLUGIN_CFG["panorama_password"]}

    # TODO: The Verify option should be configurable.
    response = requests.get(
        f"https://{url}/api/",
        params=params,
        verify=False,  # noqa: S501
        timeout=DEFAULT_TIMEOUT,
    )
    if response.status_code != 200:
        raise RequestException(f"Something went wrong while making a request. Reason: {response.text}")

    xml_data = ET.fromstring(response.text)
    return xml_data.find(".//key").text


def connect_panorama() -> Panorama:
    """Method to connect to Panorama instance."""
    pano = Panorama(
        hostname=PLUGIN_CFG["panorama_host"],
        api_username=PLUGIN_CFG["panorama_user"],
        api_password=PLUGIN_CFG["panorama_password"],
    )
    return pano


def get_rule_match(pano: Panorama, five_tuple: dict, device: Firewall) -> List[dict]:
    """Method to test if rule match is found for Device name.

    Args:
        pano (Panorama): Connection object to Panorama.
        five_tuple (dict): Five tuple dictionary for rule lookup
        device (Firewall): Firewall device to query

    Returns:
        List[dict]: List of dictionaries of all matched rules.
    """
    match = []
    if device:
        pano.add(device)
        match = device.test_security_policy_match(
            source=five_tuple["src_ip"],
            destination=five_tuple["dst_ip"],
            protocol=int(five_tuple["protocol"]),
            port=int(five_tuple["dst_port"]),
        )
    return match


def get_from_pano(connection: Panorama, devices: bool = False, groups: bool = False) -> dict:
    """Method to obtain the devices or DeviceGroups connected to Panorama.

    Args:
        connection (Panorama): Connection object to Panorama.
        devices (bool): Get Devices from Panorama.
        groups (bool): Get Groups from Panorama.

    Returns:
        dict: Dictionary of all devices attached to Panorama.
    """
    response = {}
    dev_groups = connection.refresh_devices()
    if devices:
        response = build_device_info(connection=connection, groups=dev_groups)
    if groups:
        response = build_group_info(connection=connection, groups=dev_groups)
    return response


def build_device_info(connection: Panorama, groups: List[DeviceGroup]) -> dict:
    """Method to create the devices connected to Panorama.

    Args:
        connection (Panorama): Connection object to Panorama.
        groups (List[DeviceGroup]): List of DeviceGroups that are configured in Panorama.

    Returns:
        dict: Dictionary of all devices attached to Panorama.
    """
    _device_dict = {}
    for group in groups:
        for device in group.children:
            try:
                connection.add(device)
                device_system_info = device.show_system_info()["system"]
                # TODO: Add support for virtual firewall (vsys PA's) on same physical device
                _device_dict[device_system_info["hostname"]] = {
                    "hostname": device_system_info["hostname"],
                    "serial": device_system_info["serial"],
                    "group_name": group.name,
                    "ip_address": device_system_info["ip-address"],
                    "status": device.is_active(),
                    "model": device_system_info["model"],
                    "os_version": device_system_info["sw-version"],
                }
            except PanDeviceXapiError as err:
                logger.warning("Unable to pull info for %s. %s", device, err)
    return _device_dict


def build_group_info(connection: Panorama, groups: List[DeviceGroup]) -> dict:
    """Method to obtain DeviceGroups and associated information for devices.

    Args:
        connection (Panorama): Connection object to Panorama.
        groups (List[DeviceGroup]): List of DeviceGroups that are are configured in Panorama.

    Returns:
        dict: Dictionary of all DeviceGroups and associated Firewalls that are attached to Panorama.
    """
    _group_dict = {}
    for group in groups:
        if group.name not in _group_dict:
            _group_dict[group.name] = {"devices": []}
        for device in group.children:
            dev = None
            try:
                connection.add(device)
                dev = device.show_system_info()["system"]
            except PanDeviceXapiError as err:
                logger.warning("Unable to pull info for %s. %s", device, err)
            if dev:
                _group_dict[group.name]["devices"].append(
                    {
                        "hostname": dev["hostname"],
                        "address": dev["ip-address"],
                        "serial": dev["serial"],
                        "model": dev["model"],
                        "version": dev["sw-version"],
                    }
                )
    return _group_dict


def start_packet_capture(capture_filename: str, ip_address: str, filters: dict):
    """Starts or stops packet capturing on the Managed FW.

    Args:
        capture_filename (str): Name of packet capture file
        ip_address (str): IP address of the device
        filters (dict): Commands to pass to the device for packet capturing
    """
    dev_connect = {
        "device_type": "paloalto_panos",
        "host": ip_address,
        "username": PLUGIN_CFG["panorama_user"],
        "password": PLUGIN_CFG["panorama_password"],
    }

    command = f"debug dataplane packet-diag set filter index 1 match ingress-interface {filters['intf_name']}"

    # Ignore this command if not filtering by port (when user sets port to 'any')
    if filters["dport"] and filters["dport"] != "any":
        command += f" destination-port {filters['dport']}"

    if filters["dnet"] != "0.0.0.0":  # noqa: S104
        command += f" destination {filters['dnet']}"
        if filters["dcidr"] != "0":
            command += f" destination-netmask {filters['dcidr']}"

    if filters["snet"] != "0.0.0.0":  # noqa: S104
        command += f" source {filters['snet']}"
        if filters["scidr"] != "0":
            command += f" source-netmask {filters['scidr']}"

    # Ignore this command if not filtering by port (when user sets protocol to 'any')
    if filters["ip_proto"] and filters["ip_proto"] != "any":
        command += f" protocol {filters['ip_proto']}"

    ssh = ConnectHandler(**dev_connect)
    ssh.send_command("debug dataplane packet-diag clear all")
    ssh.send_command("delete debug-filter file python.pcap")

    ssh.send_command(command)
    ssh.send_command("debug dataplane packet-diag set filter on")
    ssh.send_command(
        f"debug dataplane packet-diag set capture stage {filters['stage']}  byte-count 1024 file python.pcap"
    )
    ssh.send_command("debug dataplane packet-diag set capture on")
    time.sleep(int(filters["capture_seconds"]))
    ssh.send_command("debug dataplane packet-diag set capture off")
    ssh.send_command("debug dataplane packet-diag set filter off")
    ssh.disconnect()
    _get_pcap(capture_filename, ip_address)


def _get_pcap(capture_filename: str, ip_address: str):
    """Downloads PCAP file from PANOS device.

    Args:
        capture_filename (str): Name of packet capture file
        ip_address (str): IP address of the device
    """
    url = f"https://{ip_address}/api/"

    params = {"key": get_api_key_api(), "type": "export", "category": "filters-pcap", "from": "1.pcap"}

    # TODO: The Verify option should be configurable.
    respone = requests.get(
        url,
        params=params,
        verify=False,  # noqa S501 # nosec
        timeout=DEFAULT_TIMEOUT,
    )

    with open(capture_filename, "wb") as pcap_file:
        pcap_file.write(respone.content)


def parse_all_rule_names(xml_rules: str) -> list:
    """Parse all rules names."""
    rule_names = []
    root = ET.fromstring(xml_rules)
    # Get names of rules
    for i in root.findall(".//entry"):
        name = i.attrib.get("name")
        rule_names.append(name)
    return rule_names


def get_all_rules(device_name: str, pano: Panorama) -> list:  # pylint: disable=too-many-locals
    """Get all currently configured rules.

    Args:
        device_name (str): Name of firewall or DeviceGroup in Panorama
        pano (Panorama): Panorama connection

    Returns:
        list: List of rules
    """
    rules: List[SecurityRule] = []
    shared_pre_rulebase = pano.add(PreRulebase())
    shared_pre_rules = SecurityRule.refreshall(shared_pre_rulebase)
    shared_post_rulebase = pano.add(PostRulebase())
    shared_post_rules = SecurityRule.refreshall(shared_post_rulebase)
    if shared_pre_rules:
        rules.extend(shared_pre_rules)
    if shared_post_rules:
        rules.extend(shared_post_rules)
    target = get_object(pano=pano, object_name=device_name)
    try:
        if isinstance(target, DeviceGroup):
            for child in target.children:
                try:
                    child.refresh()
                    target = child
                    break
                except PanDeviceXapiError as err:
                    logger.warning("Error refreshing %s. %s", child, err)
        device_group_pre_rulebase = target.add(PreRulebase())
        device_group_pre_rules = SecurityRule.refreshall(device_group_pre_rulebase)
        device_group_post_rulebase = target.add(PostRulebase())
        device_group_post_rules = SecurityRule.refreshall(device_group_post_rulebase)
        if device_group_pre_rules:
            rules.extend(device_group_pre_rules)
        if device_group_post_rules:
            rules.extend(device_group_post_rules)
    except PanDeviceXapiError as err:
        logger.warning("Unable to pull info for %s. %s", device_name, err)
    rulebase = target.add(Rulebase())
    try:
        local_rules = SecurityRule.refreshall(rulebase)
        if local_rules:
            rules.extend(local_rules)
    except PanDeviceXapiError as err:
        logger.warning("Unable to find information about %s as it's not connected to Panorama. %s", target, err)
        rules = []
    return rules


def split_rules(rules, title=""):
    """Split rules into CSV format."""
    output = title or "Name,Source,Destination,Service,Action,To Zone,From Zone\n"
    for rule in rules:
        sources = ""
        for src in rule.source:
            sources += src + " "
        destinations = ""
        for dst in rule.destination:
            destinations += dst + " "
        services = ""
        for svc in rule.service:
            services += svc + " "
        tozone = ""
        for tzone in rule.tozone:
            tozone += tzone + " "
        fromzone = ""
        for fzone in rule.fromzone:
            fromzone += fzone + " "

        output += (
            f"{rule.name},{sources[:-1]},{destinations[:-1]},{services[:-1]},"
            f"{rule.action},{tozone[:-1]},{fromzone[:-1]}\n"
        )

    return output


def get_object(pano: Panorama, object_name: str):
    """Searches Panorama inventory for provided object name and returns either a DeviceGroup or Firewall object.

    Args:
        pano (Panorama): Connection to Panorama.
        object_name (str): Name of either a Firewall or DeviceGroup to find and return.

    Returns:
        DeviceGroup|Firewall: Either a Firewall or DeviceGroup object if found.
    """
    object_index = {}
    dev_groups = pano.refresh_devices()
    for instance in dev_groups:  # pylint: disable=too-many-nested-blocks
        if isinstance(instance, DeviceGroup):
            group_name = f"{instance.name}__DeviceGroup"
            object_index[group_name] = instance
            if instance.children:
                for child in instance.children:
                    if isinstance(child, Firewall):
                        try:
                            pano.add(child)
                            info = child.show_system_info()["system"]
                            object_index[info["hostname"]] = child
                        except PanDeviceXapiError as err:
                            logger.warning("Unable to connect to %s. %s", child, err)
        if isinstance(instance, Firewall):
            pano.add(instance)
            info = instance.show_system_info()["system"]
            object_index[info["hostname"]] = instance

    if object_name in object_index:
        return object_index[object_name]
    return None


def get_panorama_device_group_hierarchy(pano: Panorama):
    """Returns a dict of DeviceGroups and their parent DeviceGroup if found.

    Args:
        pano (Panorama): Connection to Panorama.
    """
    return PanoramaDeviceGroupHierarchy(pano).fetch()
