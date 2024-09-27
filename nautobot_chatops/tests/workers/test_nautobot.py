"""Tests for the /nautobot chatops commands."""

from unittest.mock import MagicMock

from django.contrib.contenttypes.models import ContentType
from django.test import TestCase
from nautobot.dcim.models import Location, LocationType
from nautobot.extras.models import Status
from nautobot.ipam.models import VLAN

from nautobot_chatops.choices import CommandStatusChoices
from nautobot_chatops.dispatchers import Dispatcher
from nautobot_chatops.workers.nautobot import get_vlans


class IpamTestCase(TestCase):
    """Tests related to IPAM ChatOps commands."""

    def setUp(self):
        """Per-test-case setup function."""
        self.active_status = Status.objects.get(name="Active")
        location_type, _ = LocationType.objects.get_or_create(name="Site")
        location_type.content_types.add(ContentType.objects.get_for_model(VLAN))

        self.location = Location.objects.create(location_type=location_type, name="site-1", status=self.active_status)
        self.vlans, _ = VLAN.objects.get_or_create(
            vid=1, name="vlan-1", status=self.active_status, location=self.location
        )

        # Mock the dispatcher
        self.dispatcher = MagicMock(Dispatcher)

    def test_get_vlans_initial_prompt(self):
        """Test get VLANs initial command."""
        self.assertFalse(get_vlans(self.dispatcher))
        self.dispatcher.send_error.assert_not_called()
        self.dispatcher.prompt_from_menu.assert_called_with(
            "nautobot get-vlans",
            "select a vlan filter",
            [
                ("VLAN ID", "id"),
                ("Group", "group"),
                ("Name", "name"),
                ("Role", "role"),
                ("Location", "location"),
                ("Status", "status"),
                ("Tenant", "tenant"),
                ("All (no filter)", "all"),
            ],
        )

    def test_get_vlans_filter_type_sent_filter_name(self):
        """Test get VLANs with filter type Name selected."""
        self.assertFalse(get_vlans(self.dispatcher, "name"))
        self.dispatcher.send_error.assert_not_called()
        self.dispatcher.prompt_from_menu.assert_called_with(
            "nautobot get-vlans name", "select a vlan name", [("vlan-1", "vlan-1")], offset=0
        )

    def test_get_vlans_filter_type_sent_filter_all(self):
        """Test get VLANs with filter type All selected."""
        self.assertEqual(get_vlans(self.dispatcher, "all"), CommandStatusChoices.STATUS_SUCCEEDED)
        self.dispatcher.send_error.assert_not_called()
