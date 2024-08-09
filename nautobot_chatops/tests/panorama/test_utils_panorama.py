"""Unit tests for Panorama utility functions."""

from unittest.mock import MagicMock

from nautobot.core.testing import TestCase

from nautobot_chatops.integrations.panorama.utils import get_from_pano


class TestPanoramaUtils(TestCase):
    """Test Panorama utility methods."""

    databases = ("default", "job_logs")

    def setUp(self):
        """Setup common elements for unit tests."""
        self.mock_device = MagicMock()
        self.mock_device.is_active = MagicMock()
        self.mock_device.is_active.return_value = True
        self.mock_device.show_system_info = MagicMock()
        self.mock_device.show_system_info.return_value = {
            "system": {
                "hostname": "Test",
                "serial": 123456,
                "ip-address": "1.1.1.1/32",
                "model": "PAN-2110",
                "sw-version": "10.0.2",
            }
        }
        self.mock_group = MagicMock()
        self.mock_group.name = "Test Group"
        self.mock_group.children = [self.mock_device]
        self.mock_empty_group = MagicMock()
        self.mock_empty_group.name = "Empty Group"
        self.mock_empty_group.children = []
        self.mock_conn = MagicMock()
        self.mock_conn.refresh_devices = MagicMock()
        self.mock_conn.refresh_devices.return_value = [self.mock_group]

    def test_get_from_pano_devices(self):
        """Test the get_from_pano function success for devices."""
        expected = {
            "Test": {
                "group_name": "Test Group",
                "hostname": "Test",
                "ip_address": "1.1.1.1/32",
                "model": "PAN-2110",
                "os_version": "10.0.2",
                "serial": 123456,
                "status": True,
            }
        }
        result = get_from_pano(connection=self.mock_conn, devices=True)
        self.assertEqual(result, expected)

    def test_get_from_pano_groups(self):
        """Test the get_from_pano function success for DeviceGroups."""
        self.mock_conn.refresh_devices.return_value = [self.mock_group, self.mock_empty_group]
        expected = {
            "Test Group": {
                "devices": [
                    {
                        "hostname": "Test",
                        "address": "1.1.1.1/32",
                        "serial": 123456,
                        "model": "PAN-2110",
                        "version": "10.0.2",
                    }
                ]
            },
            "Empty Group": {"devices": []},
        }
        result = get_from_pano(connection=self.mock_conn, groups=True)
        self.assertEqual(result, expected)
