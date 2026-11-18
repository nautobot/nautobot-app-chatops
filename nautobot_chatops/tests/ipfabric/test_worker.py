"""Tests for the IP Fabric chat commands."""

from unittest.mock import MagicMock, patch

from nautobot.apps.testing import TestCase

from nautobot_chatops.choices import CommandStatusChoices
from nautobot_chatops.integrations.ipfabric import worker
from nautobot_chatops.integrations.ipfabric.ipfabric_wrapper import IpFabric


@patch.object(worker, "get_user_snapshot", return_value="$last")
@patch.object(worker, "ipfabric_api", create=True)
class TestInterfacesCommand(TestCase):
    """Test the `/ipfabric interfaces` command."""

    def setUp(self):
        self.dispatcher = MagicMock()

    def test_load_metric_sends_interface_load(self, mock_api, _):
        mock_api.client.inventory.devices.fetch.return_value = [{"hostname": "leaf-01"}]
        mock_api.client.technology.interfaces.current_rates_data_bidirectional.fetch.return_value = [
            {"intName": "Ethernet1", "bytes": 100, "pkts": 10}
        ]

        result = worker.interfaces(self.dispatcher, "leaf-01", "load")

        self.assertTrue(result)
        self.dispatcher.send_large_table.assert_called_once_with(
            ["IntName", "Bytes/Sec", "Packets/Sec"], [["Ethernet1", 100, 10]], title="Interface Load"
        )

    def test_removed_metrics_are_rejected(self, mock_api, _):
        mock_api.client.inventory.devices.fetch.return_value = [{"hostname": "leaf-01"}]

        for metric in ("errors", "drops"):
            with self.subTest(metric=metric):
                self.dispatcher.reset_mock()

                result = worker.interfaces(self.dispatcher, "leaf-01", metric)

                self.assertEqual(result, CommandStatusChoices.STATUS_FAILED)
                self.dispatcher.send_error.assert_called_once()
                self.dispatcher.send_large_table.assert_not_called()

    def test_metric_prompt_only_offers_load(self, mock_api, _):
        mock_api.client.inventory.devices.fetch.return_value = [{"hostname": "leaf-01"}]

        worker.interfaces(self.dispatcher, None, None)

        dialog_list = self.dispatcher.multi_input_dialog.call_args.args[3]
        self.assertEqual(dialog_list[1]["choices"], [("Load", "load")])


@patch.object(worker, "ipfabric_api", create=True)
class TestTableDiffCommand(TestCase):
    """Test the `/ipfabric table-diff` command."""

    def setUp(self):
        self.dispatcher = MagicMock()

    def test_category_prompt_lists_tables_from_sdk(self, mock_api):
        mock_api.table_choices = IpFabric.table_choices

        result = worker.table_diff(self.dispatcher, "routing", None, None, None)

        self.assertFalse(result)
        choices = self.dispatcher.prompt_from_menu.call_args.args[2]
        self.assertEqual(choices, [(table, table) for table in IpFabric.table_choices["routing"]])

    def test_unknown_category_is_rejected(self, mock_api):
        mock_api.table_choices = IpFabric.table_choices

        result = worker.table_diff(self.dispatcher, "not-a-category", None, None, None)

        self.assertEqual(result, CommandStatusChoices.STATUS_FAILED)
        self.dispatcher.send_error.assert_called_once()
        self.dispatcher.prompt_from_menu.assert_not_called()

    def test_unknown_table_is_rejected(self, mock_api):
        mock_api.table_choices = IpFabric.table_choices

        result = worker.table_diff(self.dispatcher, "routing", "average_rates_errors_bidirectional", None, None)

        self.assertEqual(result, CommandStatusChoices.STATUS_FAILED)
        self.dispatcher.send_error.assert_called_once()
