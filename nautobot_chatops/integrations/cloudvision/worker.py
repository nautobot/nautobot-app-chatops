"""Cloudvision chatops."""

import logging
import os
from datetime import datetime, timedelta

from nautobot_chatops.choices import CommandStatusChoices  # pylint: disable=import-error
from nautobot_chatops.workers import handle_subcommands, subcommand_of  # pylint: disable=import-error

from .cvpgrpcutils import get_device_tags
from .utils import (
    CONFIG,
    get_active_events_data,
    get_active_events_data_filter,
    get_active_severity_types,
    get_applied_configlets_container_id,
    get_applied_configlets_device_id,
    get_bug_device_report,
    get_bug_info,
    get_cloudvision_configlets_names,
    get_cloudvision_container_devices,
    get_cloudvision_containers,
    get_cloudvision_devices_all,
    get_cloudvision_devices_all_resource,
    get_cloudvision_devices_by_sn,
    get_cloudvision_task_logs,
    get_cloudvision_tasks,
    get_configlet_config,
    get_container_id_by_name,
    get_device_bugs_data,
    get_device_id_from_hostname,
    get_device_running_configuration,
    get_severity_choices,
    prompt_for_device_or_container,
    prompt_for_events_filter,
)

logger = logging.getLogger(__name__)
dir_path = os.path.dirname(os.path.realpath(__file__))
CLOUDVISION_LOGO_PATH = "nautobot_cloudvision/cloudvision_logo.png"
CLOUDVISION_LOGO_ALT = "CloudVision Logo"


def cloudvision_logo(dispatcher):
    """Construct an image_element containing the locally hosted CVP logo."""
    return dispatcher.image_element(dispatcher.static_url(CLOUDVISION_LOGO_PATH), alt_text=CLOUDVISION_LOGO_ALT)


def check_credentials(dispatcher):
    """Check whether to use on prem or cloud instance of Cloudvision."""
    if CONFIG["on_prem"]:
        if not CONFIG.get("cvp_username") and not CONFIG.get("cvp_password") and not CONFIG.get("cvp_host"):
            dispatcher.send_warning(
                "Please ensure environment variables ARISTACV_CVP_USERNAME, ARISTACV_CVP_PASSWORD "
                "and ARISTACV_CVP_URL are set and your nautobot config file is updated."
            )
            return False
    elif not CONFIG.get("cvaas_token"):
        dispatcher.send_warning(
            "Please ensure environment variable ARISTACV_CVAAS_TOKEN "
            "is set and your nautobot config file is updated."
        )
        return False
    return True


def cloudvision(subcommand, **kwargs):
    """Interact with cloudvision."""
    return handle_subcommands("cloudvision", subcommand, **kwargs)


@subcommand_of("cloudvision")
def get_devices_in_container(dispatcher, container_name=None):
    """Get a list of devices in a Cloudvision container."""
    if not check_credentials(dispatcher):
        return CommandStatusChoices.STATUS_FAILED

    if not container_name:
        container_list = get_cloudvision_containers()

        choices = [(x["Name"], x["Name"]) for x in container_list]
        dispatcher.prompt_from_menu("cloudvision get-devices-in-container", "Select Container", choices)
        return False

    dispatcher.send_markdown(
        f"Standby {dispatcher.user_mention()}, I'm getting the devices from the container {container_name}.",
        ephemeral=True,
    )

    devices = get_cloudvision_container_devices(container_name)

    if devices:
        dispatcher.send_blocks(
            dispatcher.command_response_header(
                "cloudvision",
                "get-devices-in-container",
                [("Container Name", container_name)],
                "information",
                cloudvision_logo(dispatcher),
            )
        )
        header = ["Device", "In Container"]
        rows = [(x["hostname"], container_name) for x in devices]
        dispatcher.send_large_table(header, rows)
    else:
        dispatcher.send_warning("There are no devices in this container.")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("cloudvision")
def get_configlet(dispatcher, configlet_name=None):
    """Get configuration of a specified configlet."""
    if not check_credentials(dispatcher):
        return CommandStatusChoices.STATUS_FAILED

    if not configlet_name:
        configlet_list = get_cloudvision_configlets_names()

        choices = [(x["name"], x["name"]) for x in configlet_list]
        dispatcher.prompt_from_menu("cloudvision get-configlet", "Select Configlet", choices)
        return False

    dispatcher.send_markdown(
        f"Standby {dispatcher.user_mention()}, I'm getting the configuration of the {configlet_name} configlet.",
        ephemeral=True,
    )

    config = get_configlet_config(configlet_name)
    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "cloudvision",
            "get-configlet",
            [("Configlet Name", configlet_name)],
            "information",
            cloudvision_logo(dispatcher),
        )
    )

    dispatcher.send_snippet(f"{config}")
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("cloudvision")
def get_device_configuration(dispatcher, device_name=None):
    """Get running configuration of a specified device."""
    if not check_credentials(dispatcher):
        return CommandStatusChoices.STATUS_FAILED

    device_list = get_cloudvision_devices_all()

    if not device_name:
        choices = [(x["hostname"], x["hostname"]) for x in device_list]
        dispatcher.prompt_from_menu("cloudvision get-device-configuration", "Select Device", choices)

        return False

    dispatcher.send_markdown(
        f"Stand by {dispatcher.user_mention()}, I'm getting the running configuration for {device_name}.",
        ephemeral=True,
    )

    device = next(device for device in device_list if device["hostname"] == device_name)
    device_mac_address = device["systemMacAddress"]

    running_config = get_device_running_configuration(device_mac_address)
    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "cloudvision",
            "get-device-configuration",
            [("Device Name", device_name)],
            "information",
            cloudvision_logo(dispatcher),
        )
    )

    dispatcher.send_snippet(running_config)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("cloudvision")
def get_task_logs(dispatcher, task_id=None):
    """Get logs of a specified task."""
    if not check_credentials(dispatcher):
        return CommandStatusChoices.STATUS_FAILED

    task_list = get_cloudvision_tasks()

    if not task_id:
        choices = [(x["workOrderId"], x["workOrderId"]) for x in task_list]
        dispatcher.prompt_from_menu("cloudvision get-task-logs", "Select task", choices)

        return False

    dispatcher.send_markdown(
        f"Stand by {dispatcher.user_mention()}, I'm getting the logs of task {task_id}.", ephemeral=True
    )

    single_task = next(task for task in task_list if task["workOrderId"] == task_id)
    single_task_cc_id = single_task.get("ccIdV2")
    single_task_stage_id = single_task.get("stageId")

    if not single_task_cc_id:
        dispatcher.send_warning(f"No ccIdV2 for task {task_id}. The task was likely cancelled.")
        return CommandStatusChoices.STATUS_FAILED

    if not single_task_stage_id:
        dispatcher.send_warning(f"No stage ID found for task {task_id}.")
        return CommandStatusChoices.STATUS_FAILED

    log_list = get_cloudvision_task_logs(single_task_cc_id, single_task_stage_id)

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "cloudvision", "get-task-logs", [("Task ID", task_id)], "information", cloudvision_logo(dispatcher)
        )
    )

    dispatcher.send_snippet("\n".join(log for log in log_list))
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("cloudvision")
def get_applied_configlets(dispatcher, filter_type=None, filter_value=None):
    """Get configlets applied to either a device or a container."""
    if not check_credentials(dispatcher):
        return CommandStatusChoices.STATUS_FAILED

    device_list = get_cloudvision_devices_all()

    if not filter_type:
        prompt_for_device_or_container(
            "cloudvision get-applied-configlets",
            "Select which item to check configlets are applied to.",
            dispatcher,
        )
        return False

    if not filter_value:
        if filter_type == "container":
            container_list = get_cloudvision_containers()
            choices = [(x["Name"], x["Name"]) for x in container_list]
        elif filter_type == "device":
            choices = [(x["hostname"], x["hostname"]) for x in device_list]
        else:
            dispatcher.send_error(f"I don't know how to filter by {filter_type}.")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f"Unknown filter type '{filter_type}'",
            )

        if not choices:
            dispatcher.send_error("No data found to filter by.")

        dispatcher.prompt_from_menu(
            f"cloudvision get-applied-configlets {filter_type}",
            f"Select a {filter_type}.",
            choices,
        )
        return False

    if filter_type == "container":
        container_id = get_container_id_by_name(filter_value)
        applied_configlets = get_applied_configlets_container_id(container_id)
    elif filter_type == "device":
        applied_configlets = get_applied_configlets_device_id(filter_value, device_list)

    dispatcher.send_markdown(
        f"Stand by {dispatcher.user_mention()}, I'm getting the configs applied to the {filter_type} {filter_value}.",
        ephemeral=True,
    )
    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "cloudvision",
            "get-applied-configlets",
            [("Filter type", filter_type), ("Filter value", filter_value)],
            "information",
            cloudvision_logo(dispatcher),
        )
    )

    if not applied_configlets:
        dispatcher.send_warning(f"There are no configlets applied to {filter_type} {filter_value}.")
        return CommandStatusChoices.STATUS_FAILED

    header = ["Configlet name", f"Applied to {filter_type}"]
    rows = [(configlet, filter_value) for configlet in applied_configlets]
    dispatcher.send_large_table(header, rows)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("cloudvision")
def get_active_events(dispatcher, filter_type=None, filter_value=None, start_time=None, end_time=None):
    # pylint: disable=too-many-return-statements,too-many-branches,too-many-statements
    """Get active events from CloudVision based on severity, type, or device. Can also get 'all` active events."""
    if not check_credentials(dispatcher):
        return CommandStatusChoices.STATUS_FAILED

    if not filter_type:
        prompt_for_events_filter(
            "cloudvision get-active-events",
            "Select which item to filter events by. Choose 'all' to get all active events.",
            dispatcher,
        )
        return False

    if filter_type == "all":
        active_events = get_active_events_data()
        header = ["Title", "Severity", "Description", "Device"]
        rows = [(event["title"], event["severity"], event["description"], event["deviceId"]) for event in active_events]

        dispatcher.send_blocks(
            dispatcher.command_response_header(
                "cloudvision",
                "get-active-events",
                [("Filter type", filter_type)],
                "information",
                cloudvision_logo(dispatcher),
            )
        )

        dispatcher.send_large_table(header, rows)
        return CommandStatusChoices.STATUS_SUCCEEDED

    if not filter_value:
        if filter_type == "severity":
            choices = get_severity_choices()
        elif filter_type == "device":
            device_list = get_cloudvision_devices_all_resource()
            choices = [
                (device["result"]["value"]["hostname"], device["result"]["value"]["hostname"]) for device in device_list
            ]
        elif filter_type == "type":
            event_types = get_active_severity_types()
            choices = [(type, type) for type in event_types]
        else:
            dispatcher.send_error(f"I don't know how to filter by {filter_type}.")
            return (
                CommandStatusChoices.STATUS_FAILED,
                f"Unknown filter type '{filter_type}'",
            )

        if not choices:
            dispatcher.send_error("No data found to filter by.")

        dispatcher.prompt_from_menu(f"cloudvision get-active-events {filter_type}", f"Select a {filter_type}.", choices)
        return False

    if not start_time:
        dispatcher.prompt_for_text(
            f"cloudvision get-active-events {filter_type} {filter_value}",
            (
                "Enter start time in ISO format or enter a relative time using 'h' for hours, "
                "'d' for days, and 'w' for weeks. Ex: '-2d'"
            ),
            "Start Time",
        )
        return False

    if not end_time:
        dispatcher.prompt_for_text(
            f"cloudvision get-active-events {filter_type} {filter_value} {start_time}",
            (
                "Enter end time in ISO format or enter a relative time using 'h' for hours, "
                "'d' for days, and 'w' for weeks. Ex: '-2d'. You may also type 'now' to use the current time."
            ),
            "End Time",
        )
        return False

    if start_time.startswith("-"):
        time_diff = start_time[1:-1]
        if start_time[-1] == "h":
            start_time = datetime.now() - timedelta(hours=int(time_diff))
        elif start_time[-1] == "d":
            start_time = datetime.now() - timedelta(days=int(time_diff))
        elif start_time[-1] == "w":
            start_time = datetime.now() - timedelta(weeks=int(time_diff))
        elif start_time[-1] == "m":
            start_time = datetime.now() - timedelta(minutes=int(time_diff))

    if end_time.startswith("-"):
        time_diff = end_time[1:-1]
        if end_time[-1] == "h":
            end_time = datetime.now() - timedelta(hours=int(time_diff))
        elif end_time[-1] == "d":
            end_time = datetime.now() - timedelta(days=int(time_diff))
        elif end_time[-1] == "w":
            end_time = datetime.now() - timedelta(weeks=int(time_diff))
        elif end_time[-1] == "m":
            end_time = datetime.now() - timedelta(minutes=int(time_diff))

    if end_time.lower() == "now":
        end_time = str(datetime.now())

    if filter_type == "severity":
        active_events = get_active_events_data_filter(
            filter_type=filter_type, filter_value=filter_value, start_time=start_time, end_time=end_time
        )
        dispatcher.send_markdown(
            f"Stand by {dispatcher.user_mention()}, I'm getting the desired events with severity level {filter_value}.",
            ephemeral=True,
        )
    elif filter_type == "device":
        active_events = get_active_events_data_filter(
            filter_type=filter_type, filter_value=filter_value, start_time=start_time, end_time=end_time
        )
        dispatcher.send_markdown(
            f"Stand by {dispatcher.user_mention()}, I'm getting the desired events for device {filter_value}.",
            ephemeral=True,
        )
    elif filter_type == "type":
        active_events = get_active_events_data_filter(
            filter_type=filter_type, filter_value=filter_value, start_time=start_time, end_time=end_time
        )
        dispatcher.send_markdown(
            f"Stand by {dispatcher.user_mention()}, I'm getting the desired events for event type {filter_value}.",
            ephemeral=True,
        )

    header = ["Title", "Severity", "Description", "Device"]
    rows = [(event["title"], event["severity"], event["description"], event["deviceId"]) for event in active_events]

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "cloudvision",
            "get-active-events",
            [
                ("Filter type", filter_type),
                ("Filter value", filter_value),
                ("Start time", str(start_time)),
                ("End time", end_time),
            ],
            "information",
            cloudvision_logo(dispatcher),
        )
    )

    dispatcher.send_large_table(header, rows)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("cloudvision")
def get_tags(dispatcher, device_name=None):
    """Get system or user tags assigned to a device."""
    if not check_credentials(dispatcher):
        return CommandStatusChoices.STATUS_FAILED

    if not device_name:
        device_list = get_cloudvision_devices_all_resource()
        choices = [
            (device["result"]["value"]["hostname"], device["result"]["value"]["hostname"]) for device in device_list
        ]

        dispatcher.prompt_from_menu("cloudvision get-tags", "Select a device.", choices)
        return False

    dispatcher.send_markdown(
        f"Stand by {dispatcher.user_mention()}, I'm getting the tags for {device_name}.", ephemeral=True
    )

    device_id = get_device_id_from_hostname(device_name)
    tags = get_device_tags(device_id, CONFIG)

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "cloudvision", "get-tags", [("Device Name", device_name)], "information", cloudvision_logo(dispatcher)
        )
    )

    header = ["Label", "Value"]
    rows = [(tag.get("label"), tag.get("value")) for tag in tags]

    dispatcher.send_large_table(header, rows)
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("cloudvision")
def get_device_cve(dispatcher, device_name=None):
    """Get CVE's Cloudvision has found for a device or a list of all devices with CVEs."""
    if not check_credentials(dispatcher):
        return CommandStatusChoices.STATUS_FAILED

    if not device_name:
        device_list = get_cloudvision_devices_all_resource()
        choices = [
            (device["result"]["value"]["hostname"], device["result"]["value"]["hostname"]) for device in device_list
        ]
        choices.insert(0, ("all", "all"))

        dispatcher.prompt_from_menu("cloudvision get-device-cve", "Select a device.", choices)
        return False

    if device_name == "all":
        bug_count = get_bug_device_report()

        dispatcher.send_markdown(
            f"Stand by {dispatcher.user_mention()}, I'm getting that CVE report for you.", ephemeral=True
        )

        dispatcher.send_blocks(
            dispatcher.command_response_header(
                "cloudvision",
                "get-device-cve",
                [("Device Name", device_name)],
                "information",
                cloudvision_logo(dispatcher),
            )
        )

        header = ["Device Name", "Bug Count"]
        rows = [(get_cloudvision_devices_by_sn(device_sn), bug_count) for device_sn, bug_count in bug_count.items()]

        dispatcher.send_large_table(header, rows)
        return CommandStatusChoices.STATUS_SUCCEEDED

    device_id = get_device_id_from_hostname(device_name)
    device_bugs = get_device_bugs_data(device_id)

    if not device_bugs:
        dispatcher.send_warning(f"There are no bugs for device {device_name}.")
        return CommandStatusChoices.STATUS_FAILED

    bug_info = []
    for bug in device_bugs:
        bug_info.append(get_bug_info(bug))

    header = ["Identifier", "Summary", "Severity", "Version(s) Fixed"]
    rows = [(bug["identifier"], bug["summary"], bug["severity"], bug["versions_fixed"]) for bug in bug_info]

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            "cloudvision", "get-device-cve", [("Device Name", device_name)], "information", cloudvision_logo(dispatcher)
        )
    )

    dispatcher.send_large_table(header, rows)
    return CommandStatusChoices.STATUS_SUCCEEDED
