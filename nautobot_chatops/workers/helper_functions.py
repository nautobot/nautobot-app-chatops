"""Helper functions for nautobot.py worker."""


NAUTOBOT_LOGO_PATH = "nautobot/NautobotLogoSquare.png"
NAUTOBOT_LOGO_ALT = "Nautobot Logo"


def nautobot_logo(dispatcher):
    """Construct an image_element containing the locally hosted Nautobot logo."""
    return dispatcher.image_element(dispatcher.static_url(NAUTOBOT_LOGO_PATH), alt_text=NAUTOBOT_LOGO_ALT)


def menu_item_check(item):
    """Return True if value starts with 'menu_offset' for dealing with Slack menu display limit."""
    if item:
        try:
            return item.startswith("menu_offset-")
        except AttributeError:
            return False
    return True


def menu_offset_value(item):
    """Return value of menu offset if too many choices for Slack to handle."""
    menu_offset = 0
    if item and menu_item_check(item):
        menu_offset = int(item.replace("menu_offset-", ""))  # Index tracking when too many choices to display
    return menu_offset


# pylint: disable=too-many-return-statements
def add_asterisk(device, filter_type, value):
    # pylint: disable=no-else-return,line-too-long
    """Add asterisks to devices that are not of value `value` but are connected to those devices in the requested grouping."""
    if filter_type == "all":
        return str(device)
    elif filter_type == "device":
        return str(device)
    elif filter_type == "site" and device.site == value:
        return str(device)
    elif filter_type == "role" and device.device_role == value:
        return str(device)
    elif filter_type == "region" and device.site.region == value:
        return str(device)
    elif filter_type == "model" and device.device_type == value:
        return str(device)
    else:
        # Else, the device does not match the filter, so annotate it with an asterisk:
        return f"*{device}"


def prompt_for_device_filter_type(action_id, help_text, dispatcher):
    """Prompt the user to select a valid device filter type from a drop-down menu."""
    choices = [
        ("Name", "name"),
        ("Site", "site"),
        ("Role", "role"),
        ("Model", "model"),
        ("Manufacturer", "manufacturer"),
    ]
    return dispatcher.prompt_from_menu(action_id, help_text, choices)


def prompt_for_interface_filter_type(action_id, help_text, dispatcher):
    """Prompt the user to select a valid device filter type from a drop-down menu."""
    choices = [
        ("Device", "device"),
        ("Model", "model"),
        ("Region", "region"),
        ("Role", "role"),
        ("Site", "site"),
        ("All (no filter)", "all"),
    ]
    return dispatcher.prompt_from_menu(action_id, help_text, choices)


def prompt_for_vlan_filter_type(action_id, help_text, dispatcher):
    """Prompt the user to select a valid VLAN filter type from a drop-down menu."""
    choices = [
        ("VLAN ID", "id"),
        ("Group", "group"),
        ("Name", "name"),
        ("Role", "role"),
        ("Site", "site"),
        ("Status", "status"),
        ("Tenant", "tenant"),
        ("All (no filter)", "all"),
    ]
    return dispatcher.prompt_from_menu(action_id, help_text, choices)


def prompt_for_circuit_filter_type(action_id, help_text, dispatcher):
    """Prompt the user to select a valid device filter type from a drop-down menu."""
    choices = [
        ("Provider", "provider"),
        ("Site", "site"),
        ("Type", "type"),
        ("All (no filter)", "all"),
    ]
    return dispatcher.prompt_from_menu(action_id, help_text, choices)
