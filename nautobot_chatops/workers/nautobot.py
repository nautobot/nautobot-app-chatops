"""Worker functions for interacting with Nautobot."""

from django.core.exceptions import ValidationError
from django.db.models import Count
from django.contrib.contenttypes.models import ContentType
from django_rq import job

from nautobot.dcim.models.device_components import Interface
from nautobot.circuits.models import Circuit, CircuitType, Provider, CircuitTermination
from nautobot.dcim.choices import DeviceStatusChoices
from nautobot.dcim.models import Device, Site, DeviceRole, DeviceType, Manufacturer, Rack, Region, Cable
from nautobot.ipam.models import VLAN, Prefix, VLANGroup, Role
from nautobot.tenancy.models import Tenant
from nautobot.extras.models import Status

from nautobot_chatops.choices import CommandStatusChoices
from nautobot_chatops.workers import subcommand_of, handle_subcommands
from nautobot_chatops.workers.helper_functions import (
    add_asterisk,
    menu_offset_value,
    nautobot_logo,
    menu_item_check,
    prompt_for_circuit_filter_type,
    prompt_for_device_filter_type,
    prompt_for_interface_filter_type,
    prompt_for_vlan_filter_type,
)

# pylint: disable=too-many-return-statements,too-many-branches


@job("default")
def nautobot(subcommand, **kwargs):
    """Interact with Nautobot."""
    return handle_subcommands("nautobot", subcommand, **kwargs)


def prompt_for_device(action_id, help_text, dispatcher, devices=None, offset=0):
    """Prompt the user to select a valid device from a drop-down menu."""
    # In the previous implementation, we grouped the devices into subgroups by site.
    # Unfortunately, while this is possible in Slack, the Adaptive Cards spec (MS Teams / WebEx) can't do it.
    if devices is None:
        devices = Device.objects.all().order_by("site", "name")
    if not devices:
        dispatcher.send_error("No devices were found")
        return (CommandStatusChoices.STATUS_FAILED, "No devices found")
    choices = [(f"{device.site.name}: {device.name}", device.name) for device in devices]
    return dispatcher.prompt_from_menu(action_id, help_text, choices, offset=offset)


def prompt_for_vlan(action_id, help_text, dispatcher, filter_type, filter_value_1, vlans=None):
    """Prompt the user to select a valid vlan id from a drop-down menu."""
    if vlans is None:
        vlans = VLAN.objects.all().order_by("vid", "name")
    if not vlans:
        dispatcher.send_error("No vlans were found")
        return (CommandStatusChoices.STATUS_FAILED, "No vlans found")
    if filter_type == "id":
        choices = [(f"{vlan.vid}: {vlan.name}", str(vlan.vid)) for vlan in vlans]
    else:
        choices = [(vlan.name, vlan.name) for vlan in vlans]
    return dispatcher.prompt_from_menu(action_id, help_text, choices, offset=menu_offset_value(filter_value_1))


def send_interface_connection_table(dispatcher, connections, filter_type, value):
    """Send request large table to Slack Channel."""
    header = ["Device A", "Interface A", "Device B", "Interface B", "Connection Status"]
    rows = [
        (
            add_asterisk(connection._termination_a_device, filter_type, value),  # pylint: disable=protected-access
            str(connection.termination_a),
            add_asterisk(connection._termination_b_device, filter_type, value),  # pylint: disable=protected-access
            str(connection.termination_b),
            str(connection.status),
        )
        for connection in connections
    ]
    rows = list(sorted(set(rows)))
    dispatcher.send_large_table(header, rows)


def get_prefix_for_vlan(vlan):
    """Get a prefix given VLAN object."""
    try:
        prefix = Prefix.objects.get(vlan=vlan)
    except Prefix.DoesNotExist:
        return ""
    return str(prefix)


def send_vlan_table(dispatcher, vlans, filter_type):
    """Returns a large vlan table based on filter_type."""
    if ("name" in filter_type) or ("id" in filter_type):
        vlans = [vlans]
    header = ["ID", "Site", "Group", "Name", "Prefixes", "Tenant", "Status", "Role", "Description"]
    rows = [
        (
            vlan.vid,
            vlan.site,
            vlan.group,
            vlan.name,
            get_prefix_for_vlan(vlan),
            vlan.tenant,
            vlan.status,
            vlan.role,
            vlan.description,
        )
        for vlan in vlans
    ]
    rows = list(sorted(set(rows)))
    dispatcher.send_large_table(header, rows)


def get_filtered_connections(device, interface_ct):
    """Query cables by Django filter and return the query."""
    return (
        Cable.objects.filter(
            _termination_a_device=device,
            status__slug="connected",
            termination_a_type=interface_ct.pk,
            termination_b_type=interface_ct.pk,
        )
        .exclude(_termination_b_device=None)
        .exclude(_termination_a_device=None)
        | Cable.objects.filter(
            _termination_b_device=device,
            status__slug="connected",
            termination_a_type=interface_ct.pk,
            termination_b_type=interface_ct.pk,
        )
        .exclude(_termination_b_device=None)
        .exclude(_termination_a_device=None)
    )


# pylint: disable=too-many-statements
@subcommand_of("nautobot")
def get_vlans(dispatcher, filter_type, filter_value_1):
    """Return a filtered list of VLANS based on filter type and/or filter_value_1."""
    # pylint: disable=no-else-return
    if not filter_type:
        prompt_for_vlan_filter_type("nautobot get-vlans", "select a vlan filter", dispatcher)
        return False
    if menu_item_check(filter_value_1):
        # One parameter Slash Command All
        if filter_type == "all":
            vlans = VLAN.objects.all()
            dispatcher.send_blocks(
                dispatcher.command_response_header(
                    "nautobot",
                    "get-vlans",
                    [("Filter type", filter_type)],
                    "VLANs list",
                    nautobot_logo(dispatcher),
                )
            )
            send_vlan_table(dispatcher, vlans, filter_type)
            return CommandStatusChoices.STATUS_SUCCEEDED
        # Two parameter Slash Commands
        elif filter_type == "id":
            prompt_for_vlan(
                f"nautobot get-vlans {filter_type}",
                f"select a vlan {filter_type}",
                dispatcher,
                filter_type,
                filter_value_1,
            )
            return False
        elif filter_type == "name":
            prompt_for_vlan(
                f"nautobot get-vlans {filter_type}",
                f"select a vlan {filter_type}",
                dispatcher,
                filter_type,
                filter_value_1,
            )
            return False
        elif filter_type == "status":
            vlans = VLAN.objects.all()
            choices = [(vlan.status.name, str(vlan.status.slug)) for vlan in vlans]
            choices = list(sorted(set(choices)))
        elif filter_type == "site":
            choices = [
                (site.name, site.slug) for site in Site.objects.annotate(Count("vlans")).filter(vlans__count__gt=0)
            ]
        elif filter_type == "group":
            choices = [
                (group.name, group.slug)
                for group in VLANGroup.objects.annotate(Count("vlans")).filter(vlans__count__gt=0)
            ]
        elif filter_type == "tenant":
            choices = [
                (tenant.name, tenant.slug)
                for tenant in Tenant.objects.annotate(Count("vlans")).filter(vlans__count__gt=0)
            ]
        elif filter_type == "role":
            choices = [
                (role.name, role.slug) for role in Role.objects.annotate(Count("vlans")).filter(vlans__count__gt=0)
            ]

        if not choices:
            dispatcher.send_error(f"VLAN {filter_type} {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'VLAN "{filter_type}" "{filter_value_1}" not found',
            )

        dispatcher.prompt_from_menu(
            f"nautobot get-vlans {filter_type}",
            f"Select a {filter_type}",
            choices,
            offset=menu_offset_value(filter_value_1),
        )
        return False

    if filter_type == "name":
        try:
            vlans = VLAN.objects.get(name=filter_value_1)
        except VLAN.DoesNotExist:
            dispatcher.send_error(f"VLAN {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'VLAN "{filter_value_1}" not found',
            )
    elif filter_type == "id":
        try:
            vlans = VLAN.objects.get(vid=filter_value_1)
        except VLAN.DoesNotExist:
            dispatcher.send_error(f"VLAN {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'VLAN "{filter_value_1}" not found',
            )
    elif filter_type == "status":
        vlans = VLAN.objects.filter(status__slug=filter_value_1)
        if not vlans:
            dispatcher.send_error(f"VLAN with status {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'No VLANs with status "{filter_value_1}" found',
            )
    elif filter_type == "site":
        try:
            site = Site.objects.get(slug=filter_value_1)
        except Site.DoesNotExist:
            dispatcher.send_error(f"Site {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Site "{filter_value_1}" not found',
            )
        vlans = VLAN.objects.filter(site=site)
        if not vlans:
            dispatcher.send_error(f"No VLANs found in site {filter_value_1}")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'No VLANs found in site "{filter_value_1}"',
            )
    elif filter_type == "group":
        try:
            group = VLANGroup.objects.get(slug=filter_value_1)
        except VLANGroup.DoesNotExist:
            dispatcher.send_error(f"Group {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Group "{filter_value_1}" not found',
            )
        vlans = VLAN.objects.filter(group=group)
        if not vlans:
            dispatcher.send_error(f"No VLANs found in group {filter_value_1}")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'No VLANs found in group "{filter_value_1}"',
            )
    elif filter_type == "tenant":
        try:
            tenant = Tenant.objects.get(slug=filter_value_1)
        except Tenant.DoesNotExist:
            dispatcher.send_error(f"Tenant {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Tenant "{filter_value_1}" not found',
            )
        vlans = VLAN.objects.filter(tenant=tenant)
        if not vlans:
            dispatcher.send_error(f"No VLANs belonging to tenant {filter_value_1} found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'No VLANs belonging to tenant "{filter_value_1}" found',
            )
    elif filter_type == "role":
        try:
            role = Role.objects.get(slug=filter_value_1)
        except Role.DoesNotExist:
            dispatcher.send_error(f"Role {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Role "{filter_value_1}" not found',
            )
        vlans = VLAN.objects.filter(role=role)
        if not vlans:
            dispatcher.send_error(f"No VLANs of role {filter_value_1} found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'No VLANs of role "{filter_value_1}" found',
            )
    else:
        # unsupported filter_type check.
        dispatcher.send_error(f"{filter_type} not supported")
        return (
            CommandStatusChoices.STATUS_FAILED,
            f'"{filter_type}" not supported',
        )
    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "nautobot",
            "get-vlans",
            [
                ("Filter type", filter_type),
                ("Filter Value 1", filter_value_1),
            ],
            "VLANs list",
            nautobot_logo(dispatcher),
        )
    )
    send_vlan_table(dispatcher, vlans, filter_type)
    return CommandStatusChoices.STATUS_SUCCEEDED


# pylint: disable=too-many-statements
@subcommand_of("nautobot")
def get_interface_connections(dispatcher, filter_type, filter_value_1, filter_value_2):
    """Return a filtered list of interface connections based on filter type, filter_value_1 and/or filter_value_2."""
    interface_ct = ContentType.objects.get_for_model(Interface)
    if not filter_type:
        prompt_for_interface_filter_type(
            "nautobot get-interface-connections", "Select an interface connection filter", dispatcher
        )
        return False  # command did not run to completion and therefore should not be logged
    if menu_item_check(filter_value_1):
        if filter_type in ["device", "site"]:
            # Since the device filter prompts the user to pick a site first in order to further
            # query devices located in the chosen site, the device filter will start off with
            # choices of all the sites with one or more devices.
            choices = [
                (site.name, site.slug)
                for site in Site.objects.annotate(Count("devices")).filter(devices__count__gt=0).order_by("name")
            ]
        elif filter_type == "role":
            choices = [
                (role.name, role.slug)
                for role in DeviceRole.objects.annotate(Count("devices")).filter(devices__count__gt=0).order_by("name")
            ]
        elif filter_type == "region":
            choices = [
                (region.name, region.slug)
                for region in Region.objects.annotate(Count("sites")).filter(sites__count__gt=0).order_by("name")
            ]
        elif filter_type == "model":
            choices = [
                (device_type.display_name, device_type.slug)
                for device_type in DeviceType.objects.all().order_by("manufacturer__name", "model")
            ]
        elif filter_type == "all":
            # 1 param slash command
            connections = (
                Cable.objects.filter(status__slug="connected", termination_a_type=interface_ct.pk)
                .exclude(_termination_b_device=None)
                .exclude(_termination_a_device=None)
            )
            if len(connections) == 0:
                dispatcher.send_warning("No interface connections found")
                return CommandStatusChoices.STATUS_SUCCEEDED
            dispatcher.send_blocks(
                dispatcher.command_response_header(
                    "nautobot",
                    "get-interface-connections",
                    [("Filter type", filter_type)],
                    "Interface Connection List",
                    nautobot_logo(dispatcher),
                )
            )
            send_interface_connection_table(dispatcher, connections, filter_type, filter_value_1)
            return CommandStatusChoices.STATUS_SUCCEEDED
        else:
            dispatcher.send_error(f"I don't know how to filter by {filter_type}")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Unknown filter type "{filter_type}"',
            )  # command did not run to completion and therefore should not be logged

        if filter_type != "device":
            dispatcher.prompt_from_menu(
                f"nautobot get-interface-connections {filter_type}",
                f"Select a {filter_type}",
                choices,
                offset=menu_offset_value(filter_value_1),
            )
        else:
            dispatcher.prompt_from_menu(
                f"nautobot get-interface-connections {filter_type}",
                "Select a site",
                choices,
                offset=menu_offset_value(filter_value_1),
            )
        return False  # command did not run to completion and therefore should not be logged

    # 3 param slash command
    if filter_type == "device" and menu_item_check(filter_value_2):
        try:
            site = Site.objects.get(slug=filter_value_1)
        except Site.DoesNotExist:
            dispatcher.send_error(f"Site {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Site "{filter_value_1}" not found',
            )  # command did not run to completion and therefore should not be logged

        device_options = [(device.name, str(device.name)) for device in Device.objects.filter(site=site)]
        dispatcher.prompt_from_menu(
            f"nautobot get-interface-connections {filter_type} {filter_value_1}",
            "Select a device",
            device_options,
            offset=menu_offset_value(filter_value_2),
        )
        return False

    if filter_type == "device" and filter_value_1 and filter_value_2:
        device_name = str(filter_value_2)
        try:
            device = Device.objects.get(name=device_name)
        except Device.DoesNotExist:
            dispatcher.send_error(f"Device {device_name} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Device "{filter_value_2}" not found',
            )  # command did not run to completion and therefore should not be logged
        connections = get_filtered_connections(device, interface_ct)
        # pylint: disable=no-else-return
        if len(connections) == 0:
            dispatcher.send_warning("Filtered list is empty")
            return (
                CommandStatusChoices.STATUS_SUCCEEDED
            )  # command ran to completion, it just didn't have anything to report
        else:
            dispatcher.send_blocks(
                dispatcher.command_response_header(
                    "nautobot",
                    "get-interface-connections",
                    [
                        ("filter_type", filter_type),
                        ("filter_value_1", filter_value_1),
                        ("filter_value_2", filter_value_2),
                    ],
                    "Interface Connection List",
                    nautobot_logo(dispatcher),
                )
            )
            send_interface_connection_table(dispatcher, connections, filter_type, filter_value_1)
            return CommandStatusChoices.STATUS_SUCCEEDED

    # 2 param slash command
    sites = []
    devices = []
    if filter_type == "site":
        try:
            value = Site.objects.get(slug=filter_value_1)
        except Site.DoesNotExist:
            dispatcher.send_error(f"Site {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Site "{filter_value_1}" not found',
            )  # command did not run to completion and therefore should not be logged
        devices = Device.objects.filter(site=value)
    elif filter_type == "role":
        try:
            value = DeviceRole.objects.get(slug=filter_value_1)
        except DeviceRole.DoesNotExist:
            dispatcher.send_error(f"Device role {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Device role "{filter_value_1}" not found',
            )  # command did not run to completion and therefore should not be logged
        devices = Device.objects.filter(device_role=value)
    elif filter_type == "region":
        try:
            value = Region.objects.get(slug=filter_value_1)
        except Region.DoesNotExist:
            dispatcher.send_error(f"Device Region {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Device region "{filter_value_1}" not found',
            )  # command did not run to completion and therefore should not be logged
        sites = Site.objects.filter(region=value)
    elif filter_type == "model":
        try:
            value = DeviceType.objects.get(slug=filter_value_1)
        except DeviceType.DoesNotExist:
            dispatcher.send_error(f"Device type {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Device type "{filter_value_1}" not found',
            )  # command did not run to completion and therefore should not be logged
        devices = Device.objects.filter(device_type=value)
    else:
        dispatcher.send_error(f"I don't know how to filter by {filter_type}")
        return (
            CommandStatusChoices.STATUS_FAILED,
            f'Unknown filter type "{filter_type}"',
        )  # command did not run to completion and therefore should not be logged
    # pylint: disable=no-else-return
    if filter_type != "region" and len(devices) == 0:
        dispatcher.send_warning("Filtered interface connection list is empty")
        return (
            CommandStatusChoices.STATUS_SUCCEEDED
        )  # command ran to completion, it just didn't have anything to report
    elif filter_type == "region" and len(sites) == 0:
        dispatcher.send_warning("Filtered interface connection list is empty")
        return (
            CommandStatusChoices.STATUS_SUCCEEDED
        )  # command ran to completion, it just didn't have anything to report

    # Since object Device has no region attribute so I have to connect them through Site first.
    if filter_type != "region":
        connections = []
        for device in devices:
            connections += get_filtered_connections(device, interface_ct)
        if not connections:
            dispatcher.send_warning("Filtered interface connection list is empty")
            return CommandStatusChoices.STATUS_SUCCEEDED
    else:
        connections = []
        for site in sites:
            devices = Device.objects.filter(site=site)
            for device in devices:
                connections += get_filtered_connections(device, interface_ct)
        if not connections:
            dispatcher.send_warning("Filtered interface connection list is empty")
            return CommandStatusChoices.STATUS_SUCCEEDED

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "nautobot",
            "get-interface-connections",
            [("Filter type", filter_type), ("Filter value 1", filter_value_1)],
            "Interface Connection List, Note that a `(*)` indicates the device isn’t in "
            "the grouping requested, but is connected to a device that is.",
            nautobot_logo(dispatcher),
        )
    )
    send_interface_connection_table(dispatcher, connections, filter_type, value)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def get_device_status(dispatcher, device_name):
    """Get the status of a device in Nautobot."""
    if menu_item_check(device_name):
        prompt_for_device(
            "nautobot get-device-status",
            "Get Nautobot Device Status",
            dispatcher,
            offset=menu_offset_value(device_name),
        )
        return False  # command did not run to completion and therefore should not be logged

    try:
        device = Device.objects.get(name=device_name)
    except Device.DoesNotExist:
        dispatcher.send_error(f"I don't know device '{device_name}'")
        prompt_for_device("nautobot get-device-status", "Get Nautobot Device Status", dispatcher)
        return False  # command did not run to completion and therefore should not be logged

    blocks = [
        *dispatcher.command_response_header(
            "nautobot",
            "get-device-status",
            [("Name", device_name)],
            "device status",
            nautobot_logo(dispatcher),
        ),
        dispatcher.markdown_block(f"The status of {dispatcher.bold(device_name)} is {dispatcher.bold(device.status)}"),
    ]

    dispatcher.send_blocks(blocks)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def change_device_status(dispatcher, device_name, status):
    """Set the status of a device in Nautobot."""
    if menu_item_check(device_name):
        prompt_for_device(
            "nautobot change-device-status",
            "Change Nautobot Device Status",
            dispatcher,
            offset=menu_offset_value(device_name),
        )
        return False  # command did not run to completion and therefore should not be logged

    try:
        device = Device.objects.get(name=device_name)
    except Device.DoesNotExist:
        dispatcher.send_error(f"I don't know device '{device_name}'")
        prompt_for_device("nautobot change-device-status", "Change Nautobot Device Status", dispatcher)
        return False  # command did not run to completion and therefore should not be logged

    if menu_item_check(status):
        dispatcher.prompt_from_menu(
            f"nautobot change-device-status {device_name}",
            f"Change Nautobot Device Status for {device_name}",
            [(choice[1], choice[0]) for choice in DeviceStatusChoices.CHOICES],
            default=(device.status.name, device.status.slug),
            confirm=True,
            offset=menu_offset_value(status),
        )
        return False  # command did not run to completion and therefore should not be logged

    device.status = Status.objects.get_for_model(Device).get(slug=status)
    try:
        device.clean_fields()
    except ValidationError:
        dispatcher.send_error(f"I'm sorry, but {status} is not a valid device status value.")
        return (CommandStatusChoices.STATUS_FAILED, f'Invalid status value "{status}"')

    device.save()
    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(
                "nautobot",
                "change-device-status",
                [("Device name", device_name), ("Status", status)],
                "device status change",
                nautobot_logo(dispatcher),
            ),
            dispatcher.markdown_block(
                f"Nautobot status for {dispatcher.bold(device_name)} "
                f"successfully changed to {dispatcher.monospace(status)}."
            ),
        ]
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def get_device_facts(dispatcher, device_name):
    """Get detailed facts about a device from Nautobot in YAML format."""
    if menu_item_check(device_name):
        prompt_for_device(
            "nautobot get-device-facts",
            "Get Nautobot Device Facts",
            dispatcher,
            offset=menu_offset_value(device_name),
        )
        return False  # command did not run to completion and therefore should not be logged

    try:
        device = Device.objects.get(name=device_name)
    except Device.DoesNotExist:
        dispatcher.send_error(f"I don't know device '{device_name}'")
        prompt_for_device("nautobot get-device-facts", "Get Nautobot Device Facts", dispatcher)
        return False  # command did not run to completion and therefore should not be logged

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "nautobot",
            "get-device-facts",
            [("Name", device_name)],
            "fact data",
            nautobot_logo(dispatcher),
        )
    )

    # We use send_markdown() rather than including this as a markdown_block() in the above send_blocks() call
    # because MS Teams doesn't support the ```preformatted text``` markdown in blocks, but does in standalone messages.
    dispatcher.send_markdown(
        "```\n---\n"
        f"name: {device.name}\n"
        f"manufacturer: {device.device_type.manufacturer.name}\n"
        f"model: {device.device_type.model}\n"
        f"role: {device.device_role.name if device.device_role else '~'}\n"
        f"platform: {device.platform.name if device.platform else '~'}\n"
        f"primary_ip: {device.primary_ip.address if device.primary_ip else '~'}\n"
        f"created: {device.created}\n"
        f"updated: {device.last_updated}\n"
        "```\n"
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


# pylint: disable=too-many-statements
@subcommand_of("nautobot")
def get_devices(dispatcher, filter_type, filter_value):
    """Get a filtered list of devices from Nautobot."""
    if not filter_type:
        prompt_for_device_filter_type("nautobot get-devices", "Select a device filter", dispatcher)
        return False  # command did not run to completion and therefore should not be logged

    # pylint: disable=no-else-return
    if menu_item_check(filter_value):
        if filter_type == "name":
            dispatcher.prompt_for_text(f"nautobot get-devices {filter_type}", "Enter device name", "Device name")
            return False  # command did not run to completion and therefore should not be logged
        elif filter_type == "site":
            choices = [(site.name, site.slug) for site in Site.objects.all()]
        elif filter_type == "role":
            choices = [(role.name, role.slug) for role in DeviceRole.objects.all()]
        elif filter_type == "model":
            choices = [(device_type.display_name, device_type.slug) for device_type in DeviceType.objects.all()]
        elif filter_type == "manufacturer":
            choices = [(manufacturer.name, manufacturer.slug) for manufacturer in Manufacturer.objects.all()]
        else:
            dispatcher.send_error(f"I don't know how to filter by {filter_type}")
            return (CommandStatusChoices.STATUS_FAILED, f'Unknown filter type "{filter_type}"')

        if not choices:
            dispatcher.send_error("No data found to filter by")
            return (CommandStatusChoices.STATUS_SUCCEEDED, f'No "{filter_type}" data found')

        dispatcher.prompt_from_menu(
            f"nautobot get-devices {filter_type}",
            f"Select a {filter_type}",
            choices,
            offset=menu_offset_value(filter_value),
        )
        return False  # command did not run to completion and therefore should not be logged

    if filter_type == "name":
        devices = Device.objects.filter(name=filter_value)
    elif filter_type == "site":
        try:
            site = Site.objects.get(slug=filter_value)
        except Site.DoesNotExist:
            dispatcher.send_error(f"Site {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Site "{filter_value}" not found')
        devices = Device.objects.filter(site=site)
    elif filter_type == "role":
        try:
            role = DeviceRole.objects.get(slug=filter_value)
        except DeviceRole.DoesNotExist:
            dispatcher.send_error(f"Device role {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Device role "{filter_value}" not found')
        devices = Device.objects.filter(device_role=role)
    elif filter_type == "model":
        try:
            device_type = DeviceType.objects.get(slug=filter_value)
        except DeviceType.DoesNotExist:
            dispatcher.send_error(f"Device type {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Device type "{filter_value}" not found')
        devices = Device.objects.filter(device_type=device_type)
    elif filter_type == "manufacturer":
        # This one is a bit weird, as devices don't directly have a Manufacturer attribute,
        # but the previous implementation supported this filter, so here we go.
        # TODO: is there a better way?
        try:
            manufacturer = Manufacturer.objects.get(slug=filter_value)
        except Manufacturer.DoesNotExist:
            dispatcher.send_error(f"Manufacturer {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Manufacturer "{filter_value}" not found')
        device_types = DeviceType.objects.filter(manufacturer=manufacturer)
        devices = Device.objects.filter(device_type__in=device_types)
    else:
        dispatcher.send_error(f"I don't know how to filter by {filter_type}")
        return (CommandStatusChoices.STATUS_FAILED, f'Unknown filter type "{filter_type}"')

    if not devices:
        dispatcher.send_warning("Filtered device list is empty")
        return (CommandStatusChoices.STATUS_SUCCEEDED, "No devices found")

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "nautobot",
            "get-devices",
            [("Filter type", filter_type), ("Filter value", filter_value)],
            "device list",
            nautobot_logo(dispatcher),
        )
    )

    header = ["Name", "Status", "Tenant", "Site", "Rack", "Role", "Type", "IP Address"]
    rows = [
        (
            str(device.name),
            str(device.status),
            str(device.tenant) if device.tenant else "",
            str(device.site),
            str(device.rack) if device.rack else "",
            str(device.device_role),
            str(device.device_type),
            str(device.primary_ip.address).split("/")[0] if device.primary_ip else "",
        )
        for device in devices
    ]

    dispatcher.send_large_table(header, rows)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def get_rack(dispatcher, site_slug, rack_id):
    """Get information about a specific rack from Nautobot."""
    if menu_item_check(site_slug):
        # Only include sites with a non-zero number of racks
        site_options = [
            (site.name, site.slug)
            for site in Site.objects.annotate(Count("racks")).filter(racks__count__gt=0).order_by("name", "name")
        ]
        if not site_options:
            dispatcher.send_error("No sites with associated racks were found")
            return (CommandStatusChoices.STATUS_SUCCEEDED, "No sites with associated racks were found")
        dispatcher.prompt_from_menu(
            "nautobot get-rack", "Select a site", site_options, offset=menu_offset_value(site_slug)
        )
        return False  # command did not run to completion and therefore should not be logged

    try:
        site = Site.objects.get(slug=site_slug)
    except Site.DoesNotExist:
        dispatcher.send_error(f"Site {site_slug} not found")
        return (CommandStatusChoices.STATUS_FAILED, f'Site "{site_slug}" not found')

    if menu_item_check(rack_id):
        rack_options = [(rack.name, str(rack.id)) for rack in Rack.objects.filter(site=site)]
        if not rack_options:
            dispatcher.send_error(f"No racks associated with site {site_slug} were found")
            return (CommandStatusChoices.STATUS_SUCCEEDED, f'No racks found for site "{site_slug}"')
        dispatcher.prompt_from_menu(
            f"nautobot get-rack {site_slug}", "Select a rack", rack_options, offset=menu_offset_value(rack_id)
        )
        return False  # command did not run to completion and therefore should not be logged

    try:
        rack = Rack.objects.get(id=rack_id)
    except Rack.DoesNotExist:
        dispatcher.send_error(f"Rack {rack_id} not found")
        return (CommandStatusChoices.STATUS_FAILED, f'Rack "{rack_id}" not found')

    # Slack limits a block to no more than 3000 characters of text, and also limits the max width of a Markdown block.
    # It also limits the length of a message to no more than 4000 characters.
    # So we'll send the header as a block, then the table itself as a "file" attachment, which has no length limit.

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "nautobot",
            "get-rack",
            [("Site", site.name, site_slug), ("Rack", rack.name, str(rack_id))],
            "rack overview",
            nautobot_logo(dispatcher),
        )
    )

    units = rack.get_rack_units()
    if not units:
        dispatcher.send_warning("Rack is empty")
        return (CommandStatusChoices.STATUS_SUCCEEDED, f'Rack "{rack_id}" is empty')

    table = "\n".join(f"{unit['id']:2d} | {unit['device'].name if unit['device'] else ''}" for unit in units)
    dispatcher.send_snippet(table)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def get_circuits(dispatcher, filter_type, filter_value):
    """Get a filtered list of circuits from Nautobot."""
    if not filter_type:
        prompt_for_circuit_filter_type("nautobot get-circuits", "Select a circuit filter", dispatcher)
        return False  # command did not run to completion and therefore should not be logged

    if filter_type != "all" and menu_item_check(filter_value):
        if filter_type == "type":
            choices = [(ctype.name, ctype.slug) for ctype in CircuitType.objects.all()]
        elif filter_type == "provider":
            choices = [(prov.name, prov.slug) for prov in Provider.objects.all()]
        elif filter_type == "site":
            choices = [(site.name, site.slug) for site in Site.objects.all()]
        else:
            dispatcher.send_error(f"I don't know how to filter by {filter_type}")
            return (CommandStatusChoices.STATUS_FAILED, f'Unknown filter type "{filter_type}"')

        if not choices:
            dispatcher.send_error(f"No matching entries found for {filter_type}")
            return (CommandStatusChoices.STATUS_SUCCEEDED, f'No matching entries found for "{filter_type}"')

        dispatcher.prompt_from_menu(
            f"nautobot get-circuits {filter_type}",
            f"Select a circuit {filter_type}",
            choices,
            offset=menu_offset_value(filter_value),
        )
        return False  # command did not run to completion and therefore should not be logged

    if filter_type == "all":
        circuits = Circuit.objects.all()
    elif filter_type == "type":
        try:
            ctype = CircuitType.objects.get(slug=filter_value)
        except CircuitType.DoesNotExist:
            dispatcher.send_error(f"Circuit type {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Circuit type "{filter_value}" not found')
        circuits = Circuit.objects.filter(type=ctype)
    elif filter_type == "provider":
        try:
            prov = Provider.objects.get(slug=filter_value)
        except Provider.DoesNotExist:
            dispatcher.send_error(f"Provider {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Provider "{filter_value}" not found')
        circuits = Circuit.objects.filter(provider=prov)
    elif filter_type == "site":
        try:
            site = Site.objects.get(slug=filter_value)
        except Site.DoesNotExist:
            dispatcher.send_error(f"Site {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Site "{filter_value}" not found')
        # TODO is there a cleaner way to do this?
        terms = CircuitTermination.objects.filter(site=site)
        circuits = Circuit.objects.filter(terminations__in=terms)
    else:
        dispatcher.send_error(f"I don't know how to filter by {filter_type}")
        return (CommandStatusChoices.STATUS_FAILED, f'Unknown filter type "{filter_type}"')

    if not circuits:
        dispatcher.send_warning("Filtered circuit list is empty")
        return (CommandStatusChoices.STATUS_SUCCEEDED, "Filtered circuit list is empty")

    filter_pairs = [("Filter type", filter_type)]
    if filter_value:
        filter_pairs.append(("Filter value", filter_value))

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "nautobot",
            "get-circuits",
            filter_pairs,
            "circuit list",
            nautobot_logo(dispatcher),
        )
    )

    header = ["ID", "Provider", "Type", "Status", "Tenant", "A Side", "Z Side", "Description"]
    rows = [
        (
            circuit.cid,
            str(circuit.provider) if circuit.provider else "",
            str(circuit.type),
            circuit.status,
            str(circuit.tenant) if circuit.tenant else "",
            str(circuit.termination_a.site) if circuit.termination_a else "",
            str(circuit.termination_z.site) if circuit.termination_z else "",
            circuit.description,
        )
        for circuit in circuits
    ]

    dispatcher.send_large_table(header, rows)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def get_circuit_providers(dispatcher, *args):
    """Get a list of circuit providers."""
    providers = Provider.objects.all()

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "nautobot",
            "get-circuit-providers",
            [],
            "circuit provider list",
            nautobot_logo(dispatcher),
        )
    )

    header = ["Name", "ASN", "Account", "Circuits"]
    rows = [
        (prov.name, str(prov.asn) if prov.asn else "", prov.account, len(prov.circuits.all())) for prov in providers
    ]

    dispatcher.send_large_table(header, rows)
    return CommandStatusChoices.STATUS_SUCCEEDED
