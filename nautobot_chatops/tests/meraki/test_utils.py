"""Test of utils.py."""

import unittest
from unittest.mock import patch

from nautobot_chatops.integrations.meraki.utils import MerakiClient


class TestUtils(unittest.TestCase):
    """Test Version is the same."""

    @patch("nautobot_chatops.integrations.meraki.utils.MerakiClient.get_meraki_orgs")
    def test_org_name_to_id(self, mock_orgs):
        """Test Translate Org Name to Org Id."""
        mock_orgs.return_value = [
            {
                "id": "123456",
                "name": "NTC-TEST",
                "url": "https://meraki.com/organization/overview",
                "api": {"enabled": True},
            }
        ]
        client = MerakiClient(api_key="1234567890")
        assert client.org_name_to_id("NTC-TEST") == "123456"

    @patch("nautobot_chatops.integrations.meraki.utils.MerakiClient.get_meraki_devices")
    def test_name_to_serial(self, mock_devices):
        """Test Translate Name to Serial."""
        mock_devices.return_value = [
            {
                "name": "sw01-test",
                "serial": "SN987654",
                "mac": "0c:8d:db:7e:d4:48",
                "networkId": "L_12345",
                "model": "MS220-8P",
            },
            {
                "name": "fw01-test",
                "serial": "SN123456",
                "mac": "0c:8d:db:1b:5e:80",
                "networkId": "L_12345",
                "model": "MX64",
            },
        ]
        client = MerakiClient(api_key="1234567890")
        assert client.name_to_serial("NTC-TEST", "fw01-test") == "SN123456"

    @patch("nautobot_chatops.integrations.meraki.utils.MerakiClient.get_meraki_networks_by_org")
    def test_netname_to_id(self, mock_net_name):
        """Translate Network Name to Network ID."""
        mock_net_name.return_value = [
            {
                "configTemplateId": "L_604608249974501883",
                "enrollmentString": None,
                "id": "L_987654321",
                "name": "test-network-name",
                "notes": "",
                "organizationId": "123456",
                "productTypes": ["appliance", "switch", "wireless"],
                "tags": [],
                "timeZone": "America/Chicago",
                "url": "https://meraki.fake.com",
            },
            {
                "enrollmentString": None,
                "id": "L_123456789",
                "name": "test-network-name-noused",
                "notes": None,
                "organizationId": "123456",
                "productTypes": ["appliance", "switch", "wireless"],
                "tags": [],
                "timeZone": "America/New_York",
                "url": "https://meraki.fake.com",
            },
        ]
        client = MerakiClient(api_key="1234567890")
        assert client.netname_to_id("NTC-TEST", "test-network-name") == "L_987654321"
