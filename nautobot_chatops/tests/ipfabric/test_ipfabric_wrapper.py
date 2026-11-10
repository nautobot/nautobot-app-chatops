"""Tests for the IP Fabric API wrapper."""

from ipfabric.models import Inventory, Table, Technology
from nautobot.apps.testing import TestCase

from nautobot_chatops.integrations.ipfabric.ipfabric_wrapper import IpFabric, discover_table_choices


class TestDiscoverTableChoices(TestCase):
    """Test building the table-diff menu from the installed `ipfabric` SDK."""

    def test_every_table_choice_is_a_table_on_the_installed_sdk(self):
        for category, tables in discover_table_choices().items():
            model = Inventory if category == "inventory" else Technology.model_computed_fields.get(category).return_type
            self.assertTrue(tables, f"{category} has no tables")
            for table in tables:
                with self.subTest(category=category, table=table):
                    self.assertTrue(issubclass(model.model_computed_fields[table].return_type, Table))

    def test_tables_used_by_chat_commands_are_available(self):
        """The tables the worker reads directly must exist on every supported SDK version."""
        used_tables = {
            "inventory": ["devices", "hosts"],
            "interfaces": ["current_rates_data_bidirectional"],
            "routing": ["bgp_neighbors"],
            "wireless": ["clients", "radios_detail"],
        }
        for category, tables in used_tables.items():
            for table in tables:
                with self.subTest(category=category, table=table):
                    self.assertIn(table, IpFabric.table_choices[category])

    def test_technology_level_tables_are_not_categories(self):
        self.assertNotIn("serial_ports", discover_table_choices())
