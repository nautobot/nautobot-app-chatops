"""Worker functions for interacting with Nautobot."""

from django.core.exceptions import ValidationError
from django.db.models import Count
from django.contrib.contenttypes.models import ContentType
from django.utils.text import slugify

from nautobot.dcim.models.device_components import Interface, FrontPort, RearPort
from nautobot.circuits.models import Circuit, CircuitType, Provider, CircuitTermination
from nautobot.dcim.models import Device, DeviceType, Location, LocationType, Manufacturer, Rack, Cable
from nautobot.ipam.models import VLAN, Prefix, VLANGroup
from nautobot.tenancy.models import Tenant
from nautobot.extras.models import Role, Status

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


def nautobot(subcommand, **kwargs):
    """Interact with Nautobot."""
    return handle_subcommands("nautobot", subcommand, **kwargs)


def prompt_for_device(action_id, help_text, dispatcher, devices=None, offset=0):
    """Prompt the user to select a valid device from a drop-down menu."""
    # In the previous implementation, we grouped the devices into subgroups by location.
    # Unfortunately, while this is possible in Slack, the Adaptive Cards spec (MS Teams / Webex) can't do it.
    if devices is None:
        devices = Device.objects.restrict(dispatcher.user, "view").order_by("location", "name")
    if not devices:
        dispatcher.send_error("No devices were found")
        return (CommandStatusChoices.STATUS_FAILED, "No devices found")
    choices = [
        (
            f"{'>'.join([str(ancestor) for ancestor in device.location.ancestors()])}"
            f"{'>' if device.location.ancestors() else ''}"
            f"{device.location.name}: {device.name}",
            str(device.pk),
        )
        for device in devices
    ]
    return dispatcher.prompt_from_menu(action_id, help_text, choices, offset=offset)


def prompt_for_vlan(action_id, help_text, dispatcher, filter_type, filter_value_1, vlans=None):
    """Prompt the user to select a valid vlan id from a drop-down menu."""
    if vlans is None:
        vlans = VLAN.objects.restrict(dispatcher.user, "view").order_by("vid", "name")
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
    header = ["ID", "Location", "Group", "Name", "Prefixes", "Tenant", "Status", "Role", "Description"]
    rows = [
        (
            vlan.vid,
            vlan.location,
            vlan.vlan_group,
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


def get_filtered_connections(device, interface):
    """Query cables by Django filter and return the query."""
    return Cable.objects.filter(
        _termination_a_device=device,
        status__name="Connected",
        termination_a_type=interface.pk,
        termination_b_type=interface.pk,
    ).exclude(_termination_b_device=None).exclude(_termination_a_device=None) | Cable.objects.filter(
        _termination_b_device=device,
        status__name="Connected",
        termination_a_type=interface.pk,
        termination_b_type=interface.pk,
    ).exclude(
        _termination_b_device=None
    ).exclude(
        _termination_a_device=None
    )


def analyze_circuit_endpoints(endpoint):
    """Analyzes a circuit's endpoint and returns info about what object the endpoint connects to."""
    if isinstance(endpoint, (Interface, FrontPort, RearPort)):
        # Put into format: object.device_name
        info = f"Device: {endpoint.device.name}  {endpoint.__class__.__name__}: {endpoint.name}"
    elif isinstance(endpoint, CircuitTermination):
        # Return circuit ID of endpoint circuit
        info = f"Circuit with circuit ID {endpoint.circuit.cid}"

    return info


def examine_termination_endpoints(circuit):
    """Given a Circuit object, determine the A, Z side endpoints."""
    try:
        term_a = circuit.circuit_termination_a.trace()[0][2]
        endpoint_info_a = analyze_circuit_endpoints(term_a)
    except (AttributeError, IndexError):
        endpoint_info_a = "No A Side Connection in Database"
    try:
        term_z = circuit.circuit_termination_z.trace()[0][2]
        endpoint_info_z = analyze_circuit_endpoints(term_z)
    except (AttributeError, IndexError):
        endpoint_info_z = "No Z Side Connection in Database"

    return endpoint_info_a, endpoint_info_z


# pylint: disable=too-many-statements
@subcommand_of("nautobot")
def get_vlans(dispatcher, filter_type, filter_value_1):
    """Return a filtered list of VLANs based on filter type and/or `filter_value_1`."""
    content_type = ContentType.objects.get_for_model(VLAN)
    # pylint: disable=no-else-return
    if not filter_type:
        prompt_for_vlan_filter_type("nautobot get-vlans", "select a vlan filter", dispatcher)
        return False
    if menu_item_check(filter_value_1):
        # One parameter Slash Command All
        if filter_type == "all":
            vlans = VLAN.objects.restrict(dispatcher.user, "view")
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
            vlans = VLAN.objects.restrict(dispatcher.user, "view")
            choices = [(status.name, str(status.pk)) for status in Status.objects.get_for_model(VLAN)]
        elif filter_type == "location":
            location_types = LocationType.objects.filter(content_types=ContentType.objects.get_for_model(VLAN))
            choices = [
                (
                    f"{'>'.join([str(ancestor) for ancestor in location.ancestors()])}"
                    f"{'>' if location.ancestors() else ''}"
                    f"{location.name}",
                    str(location.pk),
                )
                for location in Location.objects.annotate(Count("vlans"))
                .filter(location_type__in=location_types)
                .filter(vlans__count__gt=0)
            ]
        elif filter_type == "group":
            choices = [
                (group.name, str(group.pk))
                for group in VLANGroup.objects.annotate(Count("vlans")).filter(vlans__count__gt=0)
            ]
        elif filter_type == "tenant":
            choices = [
                (tenant.name, str(tenant.pk))
                for tenant in Tenant.objects.annotate(Count("vlans")).filter(vlans__count__gt=0)
            ]
        elif filter_type == "role":
            choices = [(role.name, str(role.pk)) for role in Role.objects.filter(content_types=content_type)]

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
            vlans = VLAN.objects.restrict(dispatcher.user, "view").get(name=filter_value_1)
        except VLAN.DoesNotExist:
            dispatcher.send_error(f"VLAN {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'VLAN "{filter_value_1}" not found',
            )
    elif filter_type == "id":
        try:
            vlans = VLAN.objects.restrict(dispatcher.user, "view").get(vid=filter_value_1)
        except VLAN.DoesNotExist:
            dispatcher.send_error(f"VLAN {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'VLAN "{filter_value_1}" not found',
            )
    elif filter_type == "status":
        vlans = VLAN.objects.filter(status__pk=filter_value_1)
        if not vlans:
            dispatcher.send_error(f"VLAN with status {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'No VLANs with status "{filter_value_1}" found',
            )
    elif filter_type == "location":
        try:
            location = Location.objects.restrict(dispatcher.user, "view").get(pk=filter_value_1)
        except Location.DoesNotExist:
            dispatcher.send_error(f"Location {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Location "{filter_value_1}" not found',
            )
        vlans = VLAN.objects.filter(location=location)
        if not vlans:
            dispatcher.send_error(f"No VLANs found in location {filter_value_1}")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'No VLANs found in location "{filter_value_1}"',
            )
    elif filter_type == "group":
        try:
            group = VLANGroup.objects.restrict(dispatcher.user, "view").get(pk=filter_value_1)
        except VLANGroup.DoesNotExist:
            dispatcher.send_error(f"Group {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Group "{filter_value_1}" not found',
            )
        vlans = VLAN.objects.filter(vlan_group=group)
        if not vlans:
            dispatcher.send_error(f"No VLANs found in group {filter_value_1}")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'No VLANs found in group "{filter_value_1}"',
            )
    elif filter_type == "tenant":
        try:
            tenant = Tenant.objects.restrict(dispatcher.user, "view").get(pk=filter_value_1)
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
            role = Role.objects.restrict(dispatcher.user, "view").get(pk=filter_value_1, content_types=content_type)
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
    """Return a filtered list of interface connections based on type, `filter_value_1` and/or `filter_value_2`."""
    device_ct = ContentType.objects.get_for_model(Device)
    interface_ct = ContentType.objects.get_for_model(Interface)
    if not filter_type:
        prompt_for_interface_filter_type(
            "nautobot get-interface-connections", "Select an interface connection filter", dispatcher
        )
        return False  # command did not run to completion and therefore should not be logged

    filter_type = filter_type.lower()
    if menu_item_check(filter_value_1):
        if filter_type in ["device", "location"]:
            # Since the device filter prompts the user to pick a location first in order to further
            # query devices located in the chosen location, the device filter will start off with
            # choices of all the locations with one or more devices.
            location_types = LocationType.objects.filter(content_types=device_ct)
            choices = [
                (
                    f"{'>'.join([str(ancestor) for ancestor in location.ancestors()])}"
                    f"{'>' if location.ancestors() else ''}"
                    f"{location.name}",
                    str(location.pk),
                )
                for location in Location.objects.annotate(Count("devices"))
                .filter(location_type__in=location_types)
                .filter(devices__count__gt=0)
                .order_by("name")
            ]
        elif filter_type == "role":
            choices = [
                (role.name, str(role.pk)) for role in Role.objects.filter(content_types=device_ct).order_by("name")
            ]
        elif filter_type == "model":
            # TODO Switch to utilizing Natural Key instead of PK.
            choices = [
                (device_type.model, str(device_type.pk))
                for device_type in DeviceType.objects.restrict(dispatcher.user, "view").order_by(
                    "manufacturer__name", "model"
                )
            ]
        elif filter_type == "all":
            # 1 param slash command
            connections = (
                Cable.objects.filter(status__name="Connected", termination_a_type=interface_ct.pk)
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

        # Check on empty choice list, send an error back
        if not choices:
            dispatcher.send_markdown(
                message=f"Unable to filter by '{filter_type}', as it appears there is no corresponding data available",
                ephemeral=True,
            )
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'No choices found when filtering by "{filter_type}"',
            )

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
                "Select a location",
                choices,
                offset=menu_offset_value(filter_value_1),
            )
        return False  # command did not run to completion and therefore should not be logged

    # 3 param slash command
    if filter_type == "device" and menu_item_check(filter_value_2):
        try:
            location = Location.objects.restrict(dispatcher.user, "view").get(pk=filter_value_1)
        except Location.DoesNotExist:
            dispatcher.send_error(f"Location {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Location "{filter_value_1}" not found',
            )  # command did not run to completion and therefore should not be logged

        device_options = [(device.name, str(device.pk)) for device in Device.objects.filter(location=location)]
        dispatcher.prompt_from_menu(
            f"nautobot get-interface-connections {filter_type} {filter_value_1}",
            "Select a device",
            device_options,
            offset=menu_offset_value(filter_value_2),
        )
        return False

    if filter_type == "device" and filter_value_1 and filter_value_2:
        device_key = filter_value_2
        try:
            device = Device.objects.restrict(dispatcher.user, "view").get(pk=device_key)
        except Device.DoesNotExist:
            dispatcher.send_error(f"Device {device_key} not found")
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
    devices = []
    if filter_type == "location":
        try:
            value = Location.objects.restrict(dispatcher.user, "view").get(pk=filter_value_1)
        except Location.DoesNotExist:
            dispatcher.send_error(f"Location {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Location "{filter_value_1}" not found',
            )  # command did not run to completion and therefore should not be logged
        devices = Device.objects.filter(location=value)
    elif filter_type == "role":
        try:
            value = Role.objects.restrict(dispatcher.user, "view").get(pk=filter_value_1, content_types=device_ct)
        except Role.DoesNotExist:
            dispatcher.send_error(f"Role {filter_value_1} not found")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f'Role "{filter_value_1}" not found',
            )  # command did not run to completion and therefore should not be logged
        devices = Device.objects.restrict(dispatcher.user, "view").filter(role=value)
    elif filter_type == "model":
        try:
            value = DeviceType.objects.restrict(dispatcher.user, "view").get(pk=filter_value_1)
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

    connections = []
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
def get_device_status(dispatcher, device_key):
    """Get the status of a device in Nautobot."""
    if menu_item_check(device_key):
        prompt_for_device(
            "nautobot get-device-status",
            "Get Nautobot Device Status",
            dispatcher,
            offset=menu_offset_value(str(device_key)),
        )
        return False  # command did not run to completion and therefore should not be logged

    try:
        device = Device.objects.restrict(dispatcher.user, "view").get(pk=device_key)
    except Device.DoesNotExist:
        dispatcher.send_error(f"I don't know device '{device_key}'")
        prompt_for_device("nautobot get-device-status", "Get Nautobot Device Status", dispatcher)
        return False  # command did not run to completion and therefore should not be logged

    blocks = [
        *dispatcher.command_response_header(
            "nautobot",
            "get-device-status",
            [("PK", device_key)],
            "device status",
            nautobot_logo(dispatcher),
        ),
        dispatcher.markdown_block(f"The status of {dispatcher.bold(device.name)} is {dispatcher.bold(device.status)}"),
    ]

    dispatcher.send_blocks(blocks)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def change_device_status(dispatcher, device_key, status):
    """Set the status of a device in Nautobot."""
    if menu_item_check(device_key):
        prompt_for_device(
            "nautobot change-device-status",
            "Change Nautobot Device Status",
            dispatcher,
            offset=menu_offset_value(device_key),
        )
        return False  # command did not run to completion and therefore should not be logged

    try:
        device = Device.objects.restrict(dispatcher.user, "edit").get(pk=device_key)
    except Device.DoesNotExist:
        dispatcher.send_error(f"I don't know device '{device_key}'")
        prompt_for_device("nautobot change-device-status", "Change Nautobot Device Status", dispatcher)
        return False  # command did not run to completion and therefore should not be logged

    if menu_item_check(status):
        dispatcher.prompt_from_menu(
            f"nautobot change-device-status {device_key}",
            f"Change Nautobot Device Status for {device_key}",
            [(status.name, str(status.pk)) for status in Status.objects.get_for_model(Device)],
            default=(device.status.name, str(device.status.pk)),
            confirm=True,
            offset=menu_offset_value(status),
        )
        return False  # command did not run to completion and therefore should not be logged
    change_status = Status.objects.get_for_model(Device).get(pk=status)
    device.status = change_status
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
                [("Device PK", device_key), ("Status PK", status)],
                "device status change",
                nautobot_logo(dispatcher),
            ),
            dispatcher.markdown_block(
                f"Nautobot status for {dispatcher.bold(device.name)} "
                f"successfully changed to {dispatcher.monospace(change_status.name)}."
            ),
        ]
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def get_device_facts(dispatcher, device_key):
    """Get detailed facts about a device from Nautobot in YAML format."""
    if menu_item_check(device_key):
        prompt_for_device(
            "nautobot get-device-facts",
            "Get Nautobot Device Facts",
            dispatcher,
            offset=menu_offset_value(device_key),
        )
        return False  # command did not run to completion and therefore should not be logged

    try:
        device = Device.objects.restrict(dispatcher.user, "view").get(pk=device_key)
    except Device.DoesNotExist:
        dispatcher.send_error(f"I don't know device '{device_key}'")
        prompt_for_device("nautobot get-device-facts", "Get Nautobot Device Facts", dispatcher)
        return False  # command did not run to completion and therefore should not be logged

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "nautobot",
            "get-device-facts",
            [("Name", device_key)],
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
        f"role: {device.role.name if device.role else '~'}\n"
        f"platform: {device.platform.name if device.platform else '~'}\n"
        f"primary_ip: {device.primary_ip.address if device.primary_ip else '~'}\n"
        f"created: {device.created}\n"
        f"updated: {device.last_updated}\n"
        f"pk: {device.pk}\n"
        "```\n"
    )
    return CommandStatusChoices.STATUS_SUCCEEDED


# pylint: disable=too-many-statements
@subcommand_of("nautobot")
def get_devices(dispatcher, filter_type, filter_value):
    """Get a filtered list of devices from Nautobot."""
    device_ct = ContentType.objects.get_for_model(Device)
    if not filter_type:
        prompt_for_device_filter_type("nautobot get-devices", "Select a device filter", dispatcher)
        return False  # command did not run to completion and therefore should not be logged

    # pylint: disable=no-else-return
    if menu_item_check(filter_value):
        if filter_type == "name":
            dispatcher.prompt_for_text(f"nautobot get-devices {filter_type}", "Enter device name", "Device name")
            return False  # command did not run to completion and therefore should not be logged
        elif filter_type == "location":
            location_types = LocationType.objects.restrict(dispatcher.user, "view").filter(content_types=device_ct)
            choices = [
                (
                    f"{'>'.join([str(ancestor) for ancestor in location.ancestors()])}"
                    f"{'>' if location.ancestors() else ''}"
                    f"{location.name}",
                    str(location.pk),
                )
                for location in Location.objects.restrict(dispatcher.user, "view").filter(
                    location_type__in=location_types
                )
            ]
        elif filter_type == "role":
            choices = [
                (role.name, str(role.pk))
                for role in Role.objects.restrict(dispatcher.user, "view").filter(content_types=device_ct)
            ]
        elif filter_type == "model":
            choices = [
                (device_type.model, str(device_type.pk))
                for device_type in DeviceType.objects.restrict(dispatcher.user, "view")
            ]
        elif filter_type == "manufacturer":
            choices = [
                (manufacturer.name, str(manufacturer.pk))
                for manufacturer in Manufacturer.objects.restrict(dispatcher.user, "view")
            ]
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
    elif filter_type == "location":
        try:
            location = Location.objects.restrict(dispatcher.user, "view").get(pk=filter_value)
        except Location.DoesNotExist:
            dispatcher.send_error(f"Location {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Location "{filter_value}" not found')
        devices = Device.objects.restrict(dispatcher.user, "view").filter(location=location)
    elif filter_type == "role":
        try:
            role = Role.objects.restrict(dispatcher.user, "view").get(pk=filter_value, content_types=device_ct)
        except Role.DoesNotExist:
            dispatcher.send_error(f"Role {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Role "{filter_value}" not found')
        devices = Device.objects.restrict(dispatcher.user, "view").filter(role=role)
    elif filter_type == "model":
        try:
            device_type = DeviceType.objects.restrict(dispatcher.user, "view").get(pk=filter_value)
        except DeviceType.DoesNotExist:
            dispatcher.send_error(f"Device type {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Device type "{filter_value}" not found')
        devices = Device.objects.filter(device_type=device_type)
    elif filter_type == "manufacturer":
        # This one is a bit weird, as devices don't directly have a Manufacturer attribute,
        # but the previous implementation supported this filter, so here we go.
        # TODO: is there a better way?
        try:
            manufacturer = Manufacturer.objects.restrict(dispatcher.user, "view").get(pk=filter_value)
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

    header = ["Name", "Status", "Tenant", "Location", "Rack", "Role", "Type", "IP Address"]
    rows = [
        (
            str(device.name),
            str(device.status),
            str(device.tenant) if device.tenant else "",
            str(device.location) if device.location else "",
            str(device.rack) if device.rack else "",
            str(device.role),
            str(device.device_type),
            str(device.primary_ip.address).split("/", maxsplit=1)[0] if device.primary_ip else "",
        )
        for device in devices
    ]

    dispatcher.send_large_table(header, rows)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def get_rack(dispatcher, location_key, rack_id):
    """Get information about a specific rack from Nautobot."""
    rack_ct = ContentType.objects.get_for_model(Rack)
    if menu_item_check(location_key):
        # Only include locations with a non-zero number of racks
        location_types = LocationType.objects.filter(content_types=rack_ct)
        location_options = [
            (
                f"{'>'.join([str(ancestor) for ancestor in location.ancestors()])}"
                f"{'>' if location.ancestors() else ''}"
                f"{location.name}",
                str(location.pk),
            )
            for location in Location.objects.filter(location_type__in=location_types).order_by("name")
        ]
        if not location_options:
            dispatcher.send_error("No locations with associated racks were found")
            return (CommandStatusChoices.STATUS_SUCCEEDED, "No locations with associated racks were found")
        dispatcher.prompt_from_menu(
            "nautobot get-rack", "Select a location", location_options, offset=menu_offset_value(location_key)
        )
        return False  # command did not run to completion and therefore should not be logged

    try:
        location = Location.objects.restrict(dispatcher.user, "view").get(pk=location_key)
    except Location.DoesNotExist:
        dispatcher.send_error(f"Location {location_key} not found")
        return (CommandStatusChoices.STATUS_FAILED, f'Location "{location_key}" not found')

    if menu_item_check(rack_id):
        rack_options = [(rack.name, str(rack.pk)) for rack in Rack.objects.filter(location=location)]
        if not rack_options:
            dispatcher.send_error(f"No racks associated with location {location_key} were found")
            return (CommandStatusChoices.STATUS_SUCCEEDED, f'No racks found for location "{location_key}"')
        dispatcher.prompt_from_menu(
            f"nautobot get-rack {location_key}", "Select a rack", rack_options, offset=menu_offset_value(rack_id)
        )
        return False  # command did not run to completion and therefore should not be logged

    try:
        rack = Rack.objects.restrict(dispatcher.user, "view").get(pk=rack_id)
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
            [("Location", location.name, location_key), ("Rack", rack.name, str(rack_id))],
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
            choices = [(ctype.name, str(ctype.pk)) for ctype in CircuitType.objects.restrict(dispatcher.user, "view")]
        elif filter_type == "provider":
            choices = [(prov.name, str(prov.pk)) for prov in Provider.objects.restrict(dispatcher.user, "view")]
        elif filter_type == "location":
            location_types = LocationType.objects.restrict(dispatcher.user, "view").filter(
                content_types=ContentType.objects.get_for_model(CircuitTermination)
            )
            choices = [
                (
                    f"{'>'.join([str(ancestor) for ancestor in location.ancestors()])}"
                    f"{'>' if location.ancestors() else ''}"
                    f"{location.name}",
                    str(location.pk),
                )
                for location in Location.objects.restrict(dispatcher.user, "view").filter(
                    location_type__in=location_types
                )
            ]
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
        circuits = Circuit.objects.restrict(dispatcher.user, "view")
    elif filter_type == "type":
        try:
            ctype = CircuitType.objects.restrict(dispatcher.user, "view").get(pk=filter_value)
        except CircuitType.DoesNotExist:
            dispatcher.send_error(f"Circuit type {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Circuit type "{filter_value}" not found')
        circuits = Circuit.objects.filter(circuit_type=ctype)
    elif filter_type == "provider":
        try:
            prov = Provider.objects.restrict(dispatcher.user, "view").get(pk=filter_value)
        except Provider.DoesNotExist:
            dispatcher.send_error(f"Provider {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Provider "{filter_value}" not found')
        circuits = Circuit.objects.filter(provider=prov)
    elif filter_type == "location":
        try:
            location = Location.objects.restrict(dispatcher.user, "view").get(pk=filter_value)
        except Location.DoesNotExist:
            dispatcher.send_error(f"Location {filter_value} not found")
            return (CommandStatusChoices.STATUS_FAILED, f'Location "{filter_value}" not found')
        # TODO is there a cleaner way to do this?
        terms = CircuitTermination.objects.filter(location=location)
        circuits = Circuit.objects.filter(circuit_terminations__in=terms)
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
            str(circuit.circuit_type),
            circuit.status,
            str(circuit.tenant) if circuit.tenant else "",
            str(circuit.circuit_termination_a.location) if circuit.circuit_termination_a else "",
            str(circuit.circuit_termination_z.location) if circuit.circuit_termination_z else "",
            circuit.description,
        )
        for circuit in circuits
    ]

    dispatcher.send_large_table(header, rows)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def get_circuit_providers(dispatcher, *args):
    """Get a list of circuit providers."""
    providers = Provider.objects.restrict(dispatcher.user, "view")

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


@subcommand_of("nautobot")
def about(dispatcher, *args):
    """Provide link for more information on Nautobot Apps."""
    url = "https://www.networktocode.com/nautobot/apps/"
    blocks = [
        dispatcher.markdown_block(f"More Chat commands can be found at {dispatcher.hyperlink('Nautobot Apps', url)}"),
    ]

    dispatcher.send_blocks(blocks)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def get_manufacturer_summary(dispatcher):
    """Provides summary of each manufacturer and how many devices have that manufacturer."""
    # Get manufacturers
    manufacturers = Manufacturer.objects.restrict(dispatcher.user, "view")

    # Dict to hold the summary result
    manufacturer_rollup = {}

    # Get device types for each manufacturer
    for manufacturer in manufacturers:
        # Total count for the manufacturer
        total_count = 0

        # Get the device types for each manufacturer
        dev_types = manufacturer.device_types.all()

        # Get quantity of each device type
        for dev_type in dev_types:
            # Add to the total_count the amount of the device type
            total_count += dev_type.devices.count()

        # This is the total quantity of devices for that manufacturer.
        # Make a dict entry in the rollup with the manufacturer:quantity (key:value)
        manufacturer_rollup[slugify(manufacturer.name)] = total_count

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "nautobot",
            "get-manufacturer-summary",
            [],
            "manufacturer summary",
            nautobot_logo(dispatcher),
        )
    )

    header = ["Manufacturer", "Quantity of Devices"]
    rows = manufacturer_rollup.items()

    dispatcher.send_large_table(header, rows)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nautobot")
def get_circuit_connections(dispatcher, provider_key, circuit_id):
    """For a given circuit, find the objects the circuit connects to."""
    # Check for the Slack menu item limit; if a provider_key is not initially provided,
    # then menu_item_check will return True and provider_options will be defined
    if menu_item_check(provider_key):
        # Only list circuit providers that have a nonzero amount of circuits.
        provider_options = [
            (provider.name, str(provider.pk))
            for provider in Provider.objects.annotate(Count("circuits")).filter(circuits__count__gt=0).order_by("name")
        ]
        if not provider_options:  # No providers with associated circuits exist
            no_provider_error_msg = "No Providers with circuits were found"
            dispatcher.send_error(no_provider_error_msg)
            return (CommandStatusChoices.STATUS_SUCCEEDED, no_provider_error_msg)

        # Prompt user to select a circuit provider_key from a list of provider_options
        dispatcher.prompt_from_menu(
            "nautobot get-circuit-connections",  # command sub-command
            "Select a circuit provider",  # Prompt to user
            provider_options,  # Options to choose from
            offset=menu_offset_value(provider_key),
        )
        return False  # command did not run to completion and therefore should not be logged

    # Now that provider_key is defined, get the provider object from the provider_key;
    # return an error msg if provider does not exist for that provider_key
    try:
        provider = Provider.objects.restrict(dispatcher.user, "view").get(pk=provider_key)
    except Provider.DoesNotExist:  # If provider cannot be found, return STATUS_FAILED with msg
        provider_not_found_error_msg = f"Circuit provider with name {provider_key} does not exist"
        dispatcher.send_error(provider_not_found_error_msg)
        return (CommandStatusChoices.STATUS_FAILED, provider_not_found_error_msg)

    # Check for the Slack menu item limit; if a circuit_id is not initially provided,
    # then menu_item_check will return True and circuit_options will be defined
    if menu_item_check(circuit_id):
        circuit_options = [(circuit.cid, circuit.cid) for circuit in Circuit.objects.filter(provider__pk=provider.pk)]
        if not circuit_options:
            no_circuits_found_error_msg = f"No circuits with provider name {provider.name} were found"
            dispatcher.send_error(no_circuits_found_error_msg)
            return (CommandStatusChoices.STATUS_SUCCEEDED, no_circuits_found_error_msg)
        dispatcher.prompt_from_menu(
            f"nautobot get-circuit-connections {provider_key}",
            "Select a circuit",
            circuit_options,
            offset=menu_offset_value(circuit_id),
        )
        return False  # command did not run to completion and therefore should not be logged

    # Now that circuit_id is defined, get the circuit object for that circuit_id; if the
    # circuit_id does not match to a Circuit, return an error msg
    try:
        circuit = Circuit.objects.restrict(dispatcher.user, "view").get(cid=circuit_id)
    except Circuit.DoesNotExist:
        cid_not_found_msg = f"Circuit with circuit ID {circuit_id} not found"
        dispatcher.send_error(cid_not_found_msg)
        return (CommandStatusChoices.STATUS_FAILED, cid_not_found_msg)

    # Ensure the termination endpoints are present, otherwise set to a string value
    endpoint_info_a, endpoint_info_z = examine_termination_endpoints(circuit)

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "nautobot",  # command
            "get-circuit-connections",  # sub_command
            [("Provider PK", str(provider.pk)), ("Circuit ID", circuit.cid)],  # args
            "circuit connection info",  # description
            nautobot_logo(dispatcher),  # image_element
        )
    )

    header = ["Side", "Connecting Object"]
    rows = [("A", endpoint_info_a), ("Z", endpoint_info_z)]

    dispatcher.send_large_table(header, rows)

    return CommandStatusChoices.STATUS_SUCCEEDED
