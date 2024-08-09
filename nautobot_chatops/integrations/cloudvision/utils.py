"""Utilities for cloudvision chatbot."""

import os
import ssl
from datetime import datetime

import requests
from cloudvision.Connector.grpc_client import GRPCClient, create_query
from cvprac.cvp_client import CvpClient
from django.conf import settings
from google.protobuf.timestamp_pb2 import Timestamp  # pylint: disable=no-name-in-module

fullpath = os.path.abspath(__file__)
directory = os.path.dirname(fullpath)


DEFAULT_TIMEOUT = 20


def _get_config() -> dict:
    plugin_settings = settings.PLUGINS_CONFIG["nautobot_chatops"]

    def get(name):
        return plugin_settings.get(f"aristacv_{name}", None)

    return {
        "cvaas_url": get("cvaas_url"),
        "cvaas_token": get("cvaas_token"),
        "cvp_host": get("cvp_host"),
        "cvp_insecure": get("cvp_insecure"),
        "cvp_password": get("cvp_password"),
        "cvp_username": get("cvp_username"),
        "on_prem": get("on_prem"),
    }


CONFIG = _get_config()


CVAAS_TOKEN = CONFIG["cvaas_token"]
CVAAS_ADDR = CONFIG["cvaas_url"]

CVP_USERNAME = CONFIG["cvp_username"]
CVP_PASSWORD = CONFIG["cvp_password"]
CVP_HOST = CONFIG["cvp_host"]
CVP_INSECURE = CONFIG["cvp_insecure"]
ON_PREM = CONFIG["on_prem"]
CVP_TOKEN_PATH = "token.txt"  # noqa: S105
CRT_FILE_PATH = "cvp.crt"


def prompt_for_events_filter(action_id, help_text, dispatcher):
    """Prompt user to select how to filter events."""
    choices = [
        ("device", "device"),
        ("severity", "severity"),
        ("type", "type"),
        ("all", "all"),
    ]
    return dispatcher.prompt_from_menu(action_id, help_text, choices)


def prompt_for_device_or_container(action_id, help_text, dispatcher):
    """Prompt user to select device or container."""
    choices = [("Container", "container"), ("Device", "device")]
    return dispatcher.prompt_from_menu(action_id, help_text, choices)


def prompt_for_image_bundle_name_or_all(action_id, help_text, dispatcher):
    """Prompt user to select device or container or `all`."""
    choices = [("Bundle", "bundle"), ("All", "all")]
    return dispatcher.prompt_from_menu(action_id, help_text, choices)


def connect_cvp():
    """Connect to an instance of Cloudvision."""
    on_prem = CONFIG["on_prem"]
    if on_prem is None:
        on_prem = "false"

    cvaas_url = CONFIG["cvaas_url"]
    if cvaas_url is None:
        cvaas_url = "www.arista.io"

    if str(on_prem).lower() == "true":
        clnt = CvpClient()
        clnt.connect([CVP_HOST], CVP_USERNAME, CVP_PASSWORD)
    else:
        clnt = CvpClient()
        clnt.connect([cvaas_url], username="", password="", is_cvaas=True, api_token=CVAAS_TOKEN)  # nosec
    return clnt


def get_cloudvision_container_devices(container_name):
    """Get devices from specified container."""
    clnt = connect_cvp()
    result = clnt.api.get_devices_in_container(container_name)
    return result


def get_cloudvision_containers():
    """Get list of all containers from CVP."""
    clnt = connect_cvp()
    result = clnt.api.get_containers()
    return result["data"]


def get_cloudvision_configlets_names():
    """Get name of configlets."""
    clnt = connect_cvp()
    result = clnt.api.get_configlets()
    return result["data"]


def get_configlet_config(configlet_name):
    """Get configlet config lines."""
    clnt = connect_cvp()
    result = clnt.api.get_configlet_by_name(configlet_name)
    return result["config"]


def get_cloudvision_devices_all():
    """Get all devices in Cloudvision."""
    clnt = connect_cvp()
    result = clnt.get("/inventory/devices")
    return result


def get_cloudvision_devices_all_resource():
    """Get all devices in Cloudvision via resource API."""
    clnt = connect_cvp()
    dev_url = "/api/resources/inventory/v1/Device/all"
    devices_data = clnt.get(dev_url)
    devices = []
    for device in devices_data["data"]:
        try:
            if device["result"]["value"]["streamingStatus"] == "STREAMING_STATUS_ACTIVE":
                devices.append(device)
        # pass on archived datasets
        except KeyError:
            continue
    return devices


def get_cloudvision_devices_by_sn(serial_number):
    """Get a device hostname given a device id."""
    clnt = connect_cvp()
    url = "/api/resources/inventory/v1/Device/all"
    device_data = clnt.get(url)
    for device in device_data["data"]:
        try:
            if device["result"]["value"]["key"]["deviceId"] == serial_number:
                return device["result"]["value"]["hostname"]
        except KeyError:
            continue
    return serial_number


def get_device_id_from_hostname(hostname):
    """Get a device id given a hostname."""
    clnt = connect_cvp()
    url = "/api/resources/inventory/v1/Device/all"
    device_data = clnt.get(url)
    for device in device_data["data"]:
        try:
            if (
                device["result"]["value"]["streamingStatus"] == "STREAMING_STATUS_ACTIVE"
                and device["result"]["value"]["hostname"] == hostname
            ):
                return device["result"]["value"]["key"]["deviceId"]
        except KeyError:
            continue
    return hostname


def get_device_running_configuration(device_mac_address):
    """Get running configuration of device."""
    clnt = connect_cvp()
    result = clnt.api.get_device_configuration(device_mac_address)
    return result


def get_cloudvision_tasks():
    """Get all tasks from cloudvision."""
    clnt = connect_cvp()
    result = clnt.api.get_tasks()
    return result["data"]


def get_cloudvision_task_logs(single_task_cc_id, single_task_stage_id):
    """Get logs from task specified."""
    log_list = []
    clnt = connect_cvp()
    result = clnt.api.get_audit_logs_by_id(single_task_cc_id, single_task_stage_id)
    for log_entry in result["data"]:
        log_list.insert(0, log_entry["activity"])
    return log_list


def get_container_id_by_name(name):
    """Get container id."""
    clnt = connect_cvp()
    result = clnt.get(f"/inventory/containers?name={name}")
    return result[0]["Key"]


def get_applied_configlets_container_id(container_id):
    """Get a list of applied configlets."""
    clnt = connect_cvp()
    result = clnt.api.get_configlets_by_container_id(container_id)
    return [configlet["name"] for configlet in result["configletList"]]


def get_applied_configlets_device_id(device_name, device_list):
    """Get configlets applied to device."""
    clnt = connect_cvp()
    chosen_device = next(device for device in device_list if device["hostname"] == device_name)
    result = clnt.api.get_configlets_by_device_id(chosen_device["systemMacAddress"])
    return [configlet["name"] for configlet in result]


def get_severity_choices():
    """Severity levels used for get-events command."""
    choices = [
        ("UNSPECIFIED", "UNSPECIFIED"),
        ("INFO", "INFO"),
        ("WARNING", "WARNING"),
        ("ERROR", "ERROR"),
        ("CRITICAL", "CRITICAL"),
    ]
    return choices


def get_severity_events(filter_value):
    """Gets events based on severity filter."""
    clnt = connect_cvp()
    payload = {"partialEqFilter": [{"severity": filter_value}]}
    event_url = "/api/resources/event/v1/Event/all"
    result = clnt.post(event_url, data=payload)
    return result["data"]


def get_active_events_data(apiserverAddr=None, token=None, certs=None, key=None, ca=None):
    # pylint: disable=invalid-name
    """Gets a list of active event types from CVP."""
    if check_on_prem():
        apiserverAddr = f"{CVP_HOST}:8443"
        get_token_crt()

        pathElts = [
            "events",
            "activeEvents",
        ]
        query = [create_query([(pathElts, [])], "analytics")]
        events = []
        with GRPCClient(apiserverAddr, token=CVP_TOKEN_PATH, ca=CRT_FILE_PATH) as client:
            for batch in client.get(query):
                for notif in batch["notifications"]:
                    for info in notif["updates"].values():
                        single_event = {}
                        single_event["title"] = info["title"]
                        single_event["severity"] = info["severity"]
                        single_event["description"] = info["description"]
                        single_event["deviceId"] = get_cloudvision_devices_by_sn(info["data"]["deviceId"])
                        events.append(single_event)
        return events

    if CVAAS_ADDR is None:
        apiserverAddr = "apiserver.arista.io"
    else:
        apiserverAddr = f"apiserver.{CVAAS_ADDR[4:]}"
    token = CVAAS_TOKEN

    pathElts = [
        "events",
        "activeEvents",
    ]
    query = [create_query([(pathElts, [])], "analytics")]
    events = []
    with GRPCClient(apiserverAddr, tokenValue=token, key=key, ca=ca, certs=certs) as client:
        for batch in client.get(query):
            for notif in batch["notifications"]:
                for info in notif["updates"].values():
                    single_event = {}
                    single_event["title"] = info["title"]
                    single_event["severity"] = info["severity"]
                    single_event["description"] = info["description"]
                    single_event["deviceId"] = get_cloudvision_devices_by_sn(info["data"]["deviceId"])
                    events.append(single_event)
    return events


def get_active_events_data_filter(
    filter_type, filter_value, start_time, end_time, apiserverAddr=None, token=None, certs=None, key=None, ca=None
):
    # pylint: disable=invalid-name,too-many-arguments,too-many-locals,too-many-branches,no-member, too-many-statements
    """Gets a list of active event types from CVP in a specific time range."""
    if check_on_prem():
        apiserverAddr = f"{CVP_HOST}:8443"
        get_token_crt()

        start = Timestamp()
        if isinstance(start_time, str):
            start_ts = datetime.fromisoformat(start_time)
        else:
            start_ts = start_time
        start.FromDatetime(start_ts)

        end = Timestamp()
        end_ts = datetime.fromisoformat(end_time)
        end.FromDatetime(end_ts)

        pathElts = [
            "events",
            "activeEvents",
        ]
        query = [create_query([(pathElts, [])], "analytics")]
        events = []
        with GRPCClient(apiserverAddr, token=CVP_TOKEN_PATH, ca=CRT_FILE_PATH) as client:
            for batch in client.get(query, start=start, end=end):
                for notif in batch["notifications"]:
                    for info in notif["updates"].values():
                        single_event = {}
                        single_event["title"] = info["title"]
                        single_event["severity"] = info["severity"]
                        single_event["description"] = info["description"]
                        single_event["deviceId"] = get_cloudvision_devices_by_sn(info["data"]["deviceId"])
                        if filter_type == "severity":
                            if single_event["severity"] == filter_value:
                                events.append(single_event)
                        elif filter_type == "device":
                            if single_event["deviceId"] == filter_value:
                                events.append(single_event)
                        elif filter_type == "type":
                            if info["eventType"] == filter_value:
                                events.append(single_event)

        return events

    if CVAAS_ADDR is None:
        apiserverAddr = "apiserver.arista.io"
    else:
        apiserverAddr = f"apiserver.{CVAAS_ADDR[4:]}"

    token = CVAAS_TOKEN

    start = Timestamp()
    if isinstance(start_time, str):
        start_ts = datetime.fromisoformat(start_time)
    else:
        start_ts = start_time
    start.FromDatetime(start_ts)

    end = Timestamp()
    end_ts = datetime.fromisoformat(end_time)
    end.FromDatetime(end_ts)

    pathElts = [
        "events",
        "activeEvents",
    ]
    query = [create_query([(pathElts, [])], "analytics")]
    events = []
    with GRPCClient(apiserverAddr, tokenValue=token, key=key, ca=ca, certs=certs) as client:
        for batch in client.get(query, start=start, end=end):
            for notif in batch["notifications"]:
                for info in notif["updates"].values():
                    single_event = {}
                    single_event["title"] = info["title"]
                    single_event["severity"] = info["severity"]
                    single_event["description"] = info["description"]
                    single_event["deviceId"] = get_cloudvision_devices_by_sn(info["data"]["deviceId"])
                    if filter_type == "severity":
                        if single_event["severity"] == filter_value:
                            events.append(single_event)
                    elif filter_type == "device":
                        if single_event["deviceId"] == filter_value:
                            events.append(single_event)
                    elif filter_type == "type":
                        if info["eventType"] == filter_value:
                            events.append(single_event)

    return events


def get_active_severity_types(apiserverAddr=None, token=None, certs=None, key=None, ca=None):
    """Gets a list of active event types from CVP."""
    # pylint: disable=invalid-name
    if check_on_prem():
        apiserverAddr = f"{CVP_HOST}:8443"
        get_token_crt()

        pathElts = [
            "events",
            "type",
        ]
        query = [create_query([(pathElts, [])], "analytics")]
        event_types = []
        with GRPCClient(apiserverAddr, token=CVP_TOKEN_PATH, ca=CRT_FILE_PATH) as client:
            for batch in client.get(query):
                for notif in batch["notifications"]:
                    for info in notif["updates"]:
                        event_types.append(info)
        return event_types

    if CVAAS_ADDR is None:
        apiserverAddr = "apiserver.arista.io"
    else:
        apiserverAddr = f"apiserver.{CVAAS_ADDR[4:]}"
    token = CVAAS_TOKEN

    pathElts = [
        "events",
        "type",
    ]
    query = [create_query([(pathElts, [])], "analytics")]
    event_types = []
    with GRPCClient(apiserverAddr, tokenValue=token, key=key, ca=ca, certs=certs) as client:
        for batch in client.get(query):
            for notif in batch["notifications"]:
                for info in notif["updates"]:
                    event_types.append(info)
    return event_types


def get_applied_tags(device_id):
    """Get tags applied to device by device id."""
    clnt = connect_cvp()
    tag_url = "/api/resources/tag/v1/InterfaceTagAssignmentConfig/all"
    payload = {"partialEqFilter": [{"key": {"deviceId": device_id}}]}
    result = clnt.post(tag_url, data=payload)
    return result


def get_device_bugs_data(device_id, apiserverAddr=None, token=None, certs=None, key=None, ca=None):
    """Get bugs associated with a device."""
    # pylint: disable=invalid-name,too-many-arguments
    if check_on_prem():
        apiserverAddr = f"{CVP_HOST}:8443"
        get_token_crt()

        pathElts = ["tags", "BugAlerts", "devices"]
        query = [create_query([(pathElts, [])], "analytics")]
        bugs = []
        with GRPCClient(apiserverAddr, token=CVP_TOKEN_PATH, ca=CRT_FILE_PATH) as client:
            for batch in client.get(query):
                for notif in batch["notifications"]:
                    if notif["updates"].get(device_id):
                        return notif["updates"].get(device_id)
        return bugs

    if CVAAS_ADDR is None:
        apiserverAddr = "apiserver.arista.io"
    else:
        apiserverAddr = f"apiserver.{CVAAS_ADDR[4:]}"
    token = CVAAS_TOKEN

    pathElts = ["tags", "BugAlerts", "devices"]
    query = [create_query([(pathElts, [])], "analytics")]
    bugs = []
    with GRPCClient(apiserverAddr, tokenValue=token, key=key, ca=ca, certs=certs) as client:
        for batch in client.get(query):
            for notif in batch["notifications"]:
                if notif["updates"].get(device_id):
                    return notif["updates"].get(device_id)
    return bugs


def get_bug_info(bug_id, apiserverAddr=None, token=None):
    """Get detailed information about a bug given its identifier."""
    # pylint: disable=invalid-name
    if check_on_prem():
        apiserverAddr = f"{CVP_HOST}:8443"
        get_token_crt()

        pathElts = [
            "BugAlerts",
            "bugs",
            int(bug_id),
        ]
        query = [create_query([(pathElts, [])], "analytics")]
        bug_info = {}
        with GRPCClient(apiserverAddr, token=CVP_TOKEN_PATH, ca=CRT_FILE_PATH) as client:
            for batch in client.get(query):
                for notif in batch["notifications"]:
                    bug_info["identifier"] = bug_id
                    bug_info["summary"] = notif["updates"]["alertNote"]
                    bug_info["severity"] = notif["updates"]["severity"]
                    bug_info["versions_fixed"] = notif["updates"]["versionFixed"]
        return bug_info

    if CVAAS_ADDR is None:
        apiserverAddr = "apiserver.arista.io"
    else:
        apiserverAddr = f"apiserver.{CVAAS_ADDR[4:]}"
    token = CVAAS_TOKEN

    pathElts = [
        "BugAlerts",
        "bugs",
        int(bug_id),
    ]
    query = [create_query([(pathElts, [])], "analytics")]
    bug_info = {}
    with GRPCClient(apiserverAddr, tokenValue=token) as client:
        for batch in client.get(query):
            for notif in batch["notifications"]:
                bug_info["identifier"] = bug_id
                bug_info["summary"] = notif["updates"]["alertNote"]
                bug_info["severity"] = notif["updates"]["severity"]
                bug_info["versions_fixed"] = notif["updates"]["versionFixed"]
    return bug_info


def get_bug_device_report(apiserverAddr=None, token=None):
    """Get how many bugs each device has."""
    # pylint: disable=invalid-name
    if check_on_prem():
        apiserverAddr = f"{CVP_HOST}:8443"
        get_token_crt()

        pathElts = ["BugAlerts", "DevicesBugsCount"]
        query = [create_query([(pathElts, [])], "analytics")]
        bug_count = {}
        with GRPCClient(apiserverAddr, token=CVP_TOKEN_PATH, ca=CRT_FILE_PATH) as client:
            for batch in client.get(query):
                for notif in batch["notifications"]:
                    bug_count = notif["updates"]
        return bug_count

    if CVAAS_ADDR is None:
        apiserverAddr = "apiserver.arista.io"
    else:
        apiserverAddr = f"apiserver.{CVAAS_ADDR[4:]}"
    token = CVAAS_TOKEN

    pathElts = ["BugAlerts", "DevicesBugsCount"]
    query = [create_query([(pathElts, [])], "analytics")]
    bug_count = {}
    with GRPCClient(apiserverAddr, tokenValue=token) as client:
        for batch in client.get(query):
            for notif in batch["notifications"]:
                bug_count = notif["updates"]
    return bug_count


def check_on_prem():
    """Checks environment variable 'on_prem'."""
    on_prem = CONFIG["on_prem"]
    if on_prem is None:
        on_prem = "false"

    if on_prem.lower() == "false":
        return False
    return True


def get_token_crt():
    """Writes cert and user token to files for onprem GRPClient use."""
    if CVP_INSECURE.lower() == "true":
        request = requests.post(
            f"https://{CVP_HOST}/cvpservice/login/authenticate.do",
            auth=(CVP_USERNAME, CVP_PASSWORD),
            verify=False,  # noqa: S501
            timeout=DEFAULT_TIMEOUT,
        )
    else:
        request = requests.post(
            f"https://{CVP_HOST}/cvpservice/login/authenticate.do",
            auth=(CVP_USERNAME, CVP_PASSWORD),
            timeout=DEFAULT_TIMEOUT,
        )

    with open("token.txt", "w") as tokenfile:  # pylint: disable=unspecified-encoding
        tokenfile.write(request.json()["sessionId"])

    with open("cvp.crt", "w") as cert_file:  # pylint: disable=unspecified-encoding
        cert_file.write(ssl.get_server_certificate((CVP_HOST, 8443)))
