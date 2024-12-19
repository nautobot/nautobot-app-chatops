"""Worker functions implementing Nautobot "slurpit" command and subcommands."""

import asyncio

import slurpit as slurpitClient
from django.conf import settings

from nautobot_chatops.workers import handle_subcommands, subcommand_of


def run_async(coroutine):
    """Run an async coroutine synchronously."""
    try:
        loop = asyncio.get_event_loop()
        if loop.is_closed():
            loop = asyncio.new_event_loop()
            asyncio.set_event_loop(loop)
        return loop.run_until_complete(coroutine)
    except RuntimeError:
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        return loop.run_until_complete(coroutine)


SLURPIT_LOGO_PATH = "nautobot_slurpit/slurpit_logo.png"
SLURPIT_LOGO_ALT = "Slurpit Logo"


CHATOPS_PLUGIN = "nautobot_chatops"
BASE_CMD = "slurpit"

COLUMN_MAPPINGS = {
    "get_devices": [
        "hostname",
        "fqdn",
        "port",
        "ipv4",
        "device_os",
        "device_type",
        "brand",
        "disabled",
        "added",
        "last_seen",
        "vault",
        "site",
    ],
    "get_sites": ["sitename", "description", "number", "street", "city", "county", "state", "country", "zipcode"],
    "get_plannings": ["name", "slug", "comment"],
}

slurpit_client = slurpitClient.api(
    url=settings.PLUGINS_CONFIG[CHATOPS_PLUGIN].get("slurpit_host"),
    api_key=settings.PLUGINS_CONFIG[CHATOPS_PLUGIN].get("slurpit_token"),
    verify=settings.PLUGINS_CONFIG[CHATOPS_PLUGIN].get("slurpit_verify"),
)


def slurpit_logo(dispatcher):
    """Construct an image_element containing the locally hosted Slurpit logo."""
    return dispatcher.image_element(dispatcher.static_url(SLURPIT_LOGO_PATH), alt_text=SLURPIT_LOGO_ALT)


def slurpit(subcommand, **kwargs):
    """Interact with Slurpit app."""
    return handle_subcommands(BASE_CMD, subcommand, **kwargs)


def fetch_and_display(dispatcher, resource, name, title, url_path):
    """Generic function to fetch and display data."""
    columns = COLUMN_MAPPINGS[name]
    items = [item.to_dict() for item in run_async(resource())]

    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(BASE_CMD, name, [], title, slurpit_logo(dispatcher)),
            dispatcher.markdown_block(f"{settings.PLUGINS_CONFIG[CHATOPS_PLUGIN].get('slurpit_host')}/{url_path}"),
        ]
    )

    if not items:
        dispatcher.send_markdown(f"No {title.lower()} found in Slurpit")
        return False

    dispatcher.send_large_table(
        [col.replace("_", " ").title() for col in columns],
        [[item.get(col, "None") for col in columns] for item in items],
        title=title,
    )
    return True


@subcommand_of("slurpit")
def get_devices(dispatcher):
    """Get a full list of devices from Slurpit."""
    return fetch_and_display(
        dispatcher, slurpit_client.device.get_devices, "get_devices", "Device Inventory", "admin/devices"
    )


@subcommand_of("slurpit")
def get_device(dispatcher, hostname=None):
    """Get a device information from Slurpit."""
    if not hostname:
        dispatcher.prompt_for_text(f"{BASE_CMD} get-device", "Enter hostname to search", "Hostname")
        return False
    devices = run_async(slurpit_client.device.get_devices())
    device = next((device for device in devices if device.hostname.lower() == hostname.lower()), None)
    if not device:
        dispatcher.send_markdown(f"No device found for {hostname}")
        return False

    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(
                BASE_CMD,
                "get-device",
                [("Hostname", hostname)],
                "device information",
                slurpit_logo(dispatcher),
            ),
            dispatcher.markdown_block(
                f"{settings.PLUGINS_CONFIG[CHATOPS_PLUGIN].get('slurpit_host')}/admin/devices/{device.id}"
            ),
            dispatcher.markdown_block(
                f"""
- {dispatcher.bold("ID")}: {device.id}
- {dispatcher.bold("FQDN")}: {device.fqdn}
- {dispatcher.bold("Port")}: {device.port}
- {dispatcher.bold("IPv4")}: {device.ipv4}
- {dispatcher.bold("Device OS")}: {device.device_os}
- {dispatcher.bold("Device Type")}: {device.device_type}
- {dispatcher.bold("Brand")}: {device.brand}
- {dispatcher.bold("Disabled")}: {"True" if device.disabled else "False"}
- {dispatcher.bold("Added")}: {device.added}
- {dispatcher.bold("Last Seen")}: {device.last_seen}
- {dispatcher.bold("Vault")}: {device.vault}
- {dispatcher.bold("Site")}: {device.site}
- {dispatcher.bold("Created Date")}: {device.createddate}
- {dispatcher.bold("Changed Date")}: {device.changeddate}
"""
            ),
        ]
    )

    return True


@subcommand_of("slurpit")
def get_sites(dispatcher):
    """Get all configured sites from Slurpit."""
    return fetch_and_display(dispatcher, slurpit_client.site.get_sites, "get_sites", "Site Inventory", "admin/sites")


@subcommand_of("slurpit")
def get_plannings(dispatcher):
    """Get all configured plannings from Slurpit."""
    return fetch_and_display(
        dispatcher, slurpit_client.planning.get_plannings, "get_plannings", "Planning Inventory", "admin/planning"
    )


def handle_planning_search(dispatcher, sub_cmd, plannings, planning, latest, search=None, device_search=False):
    """Handle planning search and display results."""
    latest_bool = str(latest).lower() == "true"
    planning_found = next((plan for plan in plannings if plan.get("slug") == planning), None)

    if not planning_found:
        planning_choices = [(plan.get("name"), plan.get("slug")) for plan in plannings if plan.get("slug")]
        dispatcher.prompt_from_menu(
            f"{BASE_CMD} search-plannings",
            f"No valid planning found for {planning}, please select a valid planning",
            choices=planning_choices,
            default=planning_choices[0],
        )
        return False

    command = [("Planning", planning_found.get("slug")), ("Latest", str(latest_bool))]

    if search:
        command.append(("Search", search))

    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(
                BASE_CMD,
                sub_cmd,
                command,
                "Planning Details",
                slurpit_logo(dispatcher),
            ),
            dispatcher.markdown_block(
                f"{settings.PLUGINS_CONFIG[CHATOPS_PLUGIN].get('slurpit_host')}/admin/planning/{planning}"
            ),
        ]
    )

    post_data = {
        "planning_id": planning_found["id"],
        "unique_results": True,
        "latest": latest_bool,
    }
    if search and not device_search:
        post_data["search"] = search
    elif search and device_search:
        post_data["hostnames"] = [search]

    results = run_async(slurpit_client.planning.search_plannings(post_data, limit=30000))

    if not results:
        dispatcher.send_markdown(f"No planning results found for {planning_found.get('name')}")
        return False

    headers = [col.get("column", "") for col in planning_found.get("columns", [])]
    headers.insert(0, "hostname")

    dispatcher.send_markdown(f"Found {len(results)} results")
    dispatcher.send_large_table(
        headers,
        [[result.get(header, "None") for header in headers] for result in results],
        title=f"{planning_found.get('name')} Results",
    )
    return True


@subcommand_of("slurpit")
def search_data(dispatcher, planning=None, latest=None, search=None):
    """Search planning results from Slurpit."""
    plannings = [plan.to_dict() for plan in run_async(slurpit_client.planning.get_plannings())]
    if not planning:
        planning_choices = [(plan.get("name"), plan.get("slug")) for plan in plannings if plan.get("slug")]
        dispatcher.prompt_from_menu(
            f"{BASE_CMD} search-data", "Search Plannings", choices=planning_choices, default=planning_choices[0]
        )
        return False

    return handle_planning_search(dispatcher, "search-data", plannings, planning, latest, search)


@subcommand_of("slurpit")
def device_data(dispatcher, planning=None, latest=None, hostname=None):
    """Get device specific information from planning results from Slurpit."""
    plannings = [plan.to_dict() for plan in run_async(slurpit_client.planning.get_plannings())]
    if not planning:
        planning_choices = [(plan.get("name"), plan.get("slug")) for plan in plannings if plan.get("slug")]
        dispatcher.prompt_from_menu(
            f"{BASE_CMD} device-data", "Search Plannings", choices=planning_choices, default=planning_choices[0]
        )
        return False

    if not hostname:
        dispatcher.prompt_for_text(
            f"{BASE_CMD} device-data {planning} {latest}", "Enter hostname to search", "Hostname"
        )
        return False

    return handle_planning_search(dispatcher, "device-data", plannings, planning, latest, hostname, True)
