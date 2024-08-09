"""Test rundeck client."""
# Disable protected access, since..ya know. We need to test them. # pylint: disable=protected-access

import json
from os import path

import responses
from django.test import SimpleTestCase

from nautobot_chatops.integrations.nso.exceptions import (
    CommunicationError,
    DeviceLocked,
    DeviceNotFound,
    DeviceNotSupported,
)
from nautobot_chatops.integrations.nso.nso import NSOClient as nso

HERE = path.abspath(path.dirname(__file__))


def load_api_calls(_responses, fixture):
    """Load the API calls into memory for mocking."""
    with open(f"{HERE}/fixtures/{fixture}.json", "r", encoding="utf-8") as file_:
        api_calls = json.load(file_)

        for api_call in api_calls:
            if api_call["method"] == "GET":
                _responses.add(
                    _responses.GET,
                    api_call["url"],
                    json=api_call["response_json"],
                    status=api_call["status"],
                    headers={"Content-Type": "application/yang-data+xml"},
                )
                continue

            if api_call["method"] == "POST":
                _responses.add(
                    _responses.POST,
                    api_call["url"],
                    json=api_call["response_json"],
                    match=[_responses.matchers.json_params_matcher(api_call["body"])] if "body" in api_call else [],
                    status=api_call["status"],
                    headers={"Content-Type": "application/yang-data+xml"},
                )
                continue


class TestNSO(SimpleTestCase):
    """Test Base NSO Client and Calls."""

    def setUp(self):
        """Setup."""
        self.url = "https://nso.test"
        self.username = "username"
        self.password = "password"  # nosec
        self.nso = nso(self.url, self.username, self.password)

        self.error_url = "https://nso.error"
        self.error_nso = nso(self.error_url, self.username, self.password)

    @responses.activate
    def test_ping(self):
        """Test Ping Device API Call."""

        load_api_calls(responses, "ping_device_responses")

        self.assertIn("1 packets transmitted, 1 received, 0% packet loss", self.nso.ping("good_device"))
        self.assertIn("100% packet loss", self.nso.ping("offline_device"))
        # self.assertIn("Device does not exist in NSO", self.nso.ping("nonexistent_device"))
        with self.assertRaises(DeviceNotFound):
            self.nso.ping("nonexistent_device")
        with self.assertRaises(CommunicationError):
            self.error_nso.ping("error_device")

    @responses.activate
    def test_connect(self):
        """Test Connect to Device API Call."""

        load_api_calls(responses, "connect_device_responses")

        self.assertEqual(self.nso.connect("good_device"), True)
        self.assertEqual(self.nso.connect("offline_device"), False)
        # self.assertEqual(self.nso.connect("nonexistent_device"), "Device does not exist in NSO")
        with self.assertRaises(DeviceNotFound):
            self.nso.connect("nonexistent_device")

    @responses.activate
    def test_sync_to(self):
        """Test Sync to Device API Call."""

        load_api_calls(responses, "sync_to_responses")

        self.assertEqual(self.nso.sync_to("good_device"), True)
        self.assertEqual(self.nso.sync_to("offline_device"), False)

    @responses.activate
    def test_sync_from(self):
        """Test Sync from Device API Call."""

        load_api_calls(responses, "sync_from_responses")

        self.assertEqual(self.nso.sync_from("good_device"), True)
        self.assertEqual(self.nso.sync_from("offline_device"), False)

    @responses.activate
    def test_sync_status(self):
        """Test Check Sync Status of Device API Call."""

        load_api_calls(responses, "sync_status_responses")

        self.assertEqual(self.nso.sync_status("in_sync_device"), "in-sync")
        self.assertEqual(self.nso.sync_status("out_of_sync_device"), "out-of-sync")
        self.assertEqual(self.nso.sync_status("offline_device"), "locked")

    @responses.activate
    def test_sync_status_all(self):
        """Test Check Sync Status of All Devices API Call."""

        load_api_calls(responses, "sync_status_responses")
        response_sync_status_all = [
            {"device": "in_sync_device", "result": "in-sync"},
            {"device": "out_of_sync_device", "result": "out-of-sync"},
            {"device": "offline_device", "result": "locked"},
        ]
        self.assertEqual(self.nso.sync_status_all(), response_sync_status_all)
        with self.assertRaises(CommunicationError):
            self.error_nso.sync_status_all()

    @responses.activate
    def test_compare_config(self):
        """Test Compare Config of Device API Call."""

        load_api_calls(responses, "compare_config_responses")

        self.assertEqual(self.nso.compare_config("in_sync_device"), {})
        self.assertIn("Test Change", self.nso.compare_config("out_of_sync_device"))
        self.assertEqual(self.nso.compare_config("offline_device"), {"info": "Device c3 is southbound locked"})

    @responses.activate
    def test_live_status(self):
        """Test Compare Config of Device API Call."""

        load_api_calls(responses, "live_status_responses")

        self.assertEqual(
            self.nso.live_status("good_device", "show version"), "\r\nCisco IOS Software, NETSIM\r\ngood_device# "
        )
        self.assertEqual(
            self.nso.live_status("good_device_nx", "show version"),
            "\r\nCisco NX-OS Software, NETSIM\r\ngood_device_nx# ",
        )
        with self.assertRaises(DeviceLocked):
            self.nso.live_status("offline_device", "show version")
        with self.assertRaises(DeviceNotSupported):
            self.nso.live_status("unsupported_device_asa", "show version")
        with self.assertRaises(DeviceNotFound):
            self.nso.live_status("nonexistent_device", "show version")
        with self.assertRaises(CommunicationError):
            self.error_nso.live_status("error_device_type", "show version")
        with self.assertRaises(CommunicationError):
            self.error_nso.live_status("error_live_status", "show version")
