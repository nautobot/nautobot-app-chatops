"""All interactions with nso."""

import logging

import requests
from django.conf import settings
from rest_framework import status

from nautobot_chatops.integrations.nso.exceptions import (
    CommunicationError,
    DeviceLocked,
    DeviceNotFound,
    DeviceNotSupported,
)

logger = logging.getLogger("nautobot.plugin.nso")

# Import config vars from nautobot_config.py
PLUGIN_SETTINGS = settings.PLUGINS_CONFIG["nautobot_chatops"]

SLASH_COMMAND = "nso"
REQUEST_TIMEOUT_SEC = PLUGIN_SETTINGS["nso_request_timeout"]

NSO_URL = PLUGIN_SETTINGS["nso_url"]
NSO_USERNAME = PLUGIN_SETTINGS["nso_username"]
NSO_PASSWORD = PLUGIN_SETTINGS["nso_password"]


class NSOClient:
    """Representation and methods for interacting with nso."""

    def __init__(self, url=NSO_URL, username=NSO_USERNAME, password=NSO_PASSWORD):
        """Initialization of nso class."""
        self.url = url
        self.auth = (username, password)
        self.headers = {"Accept": "application/yang-data+json", "Content-Type": "application/yang-data+json"}

    @property
    def base_url(self):
        """Base URL for RESTCONF."""
        return f"{self.url}/restconf/data"

    def __device_operation(self, device, operation):
        """Basic device operations.

        Args:
            device (str): Device name
            operation (str): Device operation, such as ping, connect, sync-to

        Returns:
            The response.

        Raises:
            CommunicationError: Raises an exception when response code != 200 or 404.
            DeviceNotFound: Raises an exception when response code == 404.
        """
        url = f"{self.base_url}/tailf-ncs:devices/device={device}/{operation}"

        response = requests.post(url, headers=self.headers, auth=self.auth, timeout=REQUEST_TIMEOUT_SEC)

        if response.ok:
            json_response = response.json()
            out = json_response.get("tailf-ncs:output", {})
            if "result" in out:
                return out["result"]
            if "diff" in out:
                return out["diff"]
            return out
        if response.status_code == status.HTTP_404_NOT_FOUND:
            json_response = response.json()
            out = json_response.get("ietf-restconf:errors", {})
            if "error" in out:
                if "error-message" in out["error"][0]:
                    if out["error"][0]["error-message"] == "uri keypath not found":
                        raise DeviceNotFound(f"Device {device} does not exist in NSO")
        raise CommunicationError(f"Error communicating to NSO! ({response.status_code})")

    def ping(self, device):
        """Ping device operation.

        Args:
            device (str): Device name

        Returns:
            The response.
        """
        return self.__device_operation(device, "ping")

    def connect(self, device):
        """Connect device operation.

        Args:
            device (str): Device name

        Returns:
            The response.
        """
        return self.__device_operation(device, "connect")

    def sync_to(self, device):
        """Sync to device operation.

        Args:
            device (str): Device name

        Returns:
            The response.
        """
        return self.__device_operation(device, "sync-to")

    def sync_from(self, device):
        """Sync from device operation.

        Args:
            device (str): Device name

        Returns:
            The response.
        """
        return self.__device_operation(device, "sync-from")

    def sync_status(self, device):
        """Check sync device operation.

        Args:
            device (str): Device name

        Returns:
            The response.
        """
        return self.__device_operation(device, "check-sync")

    def sync_status_all(self):
        """Check sync of all devices operation.

        Returns:
            The response.

        Raises:
            CommunicationError: Raises an exception when response code != 200.
        """
        url = f"{self.base_url}/tailf-ncs:devices/check-sync"

        response = requests.post(url, headers=self.headers, auth=self.auth, timeout=REQUEST_TIMEOUT_SEC)

        if response.ok:
            json_response = response.json()
            out = json_response.get("tailf-ncs:output", {})
            if "sync-result" in out:
                return out["sync-result"]
            return out
        raise CommunicationError(f"Error communicating to NSO! ({response.status_code})")

    def compare_config(self, device):
        """Compare config device operation.

        Args:
            device (str): Device name

        Returns:
            The response.
        """
        return self.__device_operation(device, "compare-config")

    def live_status(self, device, command):
        """Executes a show command.

        Args:
            device (str): Device name
            command (str): The show command

        Returns:
            The response.
        """
        # Get device type
        url = f"{self.base_url}/tailf-ncs:devices/device={device}/device-type"
        response = requests.get(url, headers=self.headers, auth=self.auth, timeout=REQUEST_TIMEOUT_SEC)

        if not response.ok:
            json_response = response.json()
            out = json_response.get("ietf-restconf:errors", {})
            if "error" in out:
                if "error-message" in out["error"][0]:
                    if out["error"][0]["error-message"] == "uri keypath not found":
                        raise DeviceNotFound(f"Device {device} does not exist in NSO")
            raise CommunicationError(f"Error communicating to NSO! ({response.status_code})")

        json_response = response.json()
        ned_id = json_response["tailf-ncs:device-type"]["cli"]["ned-id"]
        if "nx" in ned_id:
            ned_id_live = "tailf-ned-cisco-nx-stats"
        elif "ios" in ned_id:
            ned_id_live = "tailf-ned-cisco-ios-stats"
        else:
            raise DeviceNotSupported(f"Device type is not supported! ({ned_id})")

        url = f"{self.base_url}/tailf-ncs:devices/device={device}"
        url += f"/live-status/{ned_id_live}:exec/show"

        command = command.replace("show ", "")
        body = {"input": {"args": command}}

        response = requests.post(url, headers=self.headers, auth=self.auth, json=body, timeout=REQUEST_TIMEOUT_SEC)

        if response.ok:
            json_response = response.json()
            return json_response[f"{ned_id_live}:output"]["result"]
        if response.status_code == status.HTTP_500_INTERNAL_SERVER_ERROR:
            json_response = response.json()
            out = json_response.get("ietf-restconf:errors", {})
            if "error" in out:
                if "error-message" in out["error"][0]:
                    if "southbound locked" in out["error"][0]["error-message"]:
                        raise DeviceLocked(f"Device {device} is southbound locked")
        raise CommunicationError(f"Error communicating to NSO! ({response.status_code})")
