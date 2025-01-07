"""Test CommandLog Filter."""

from django.test import TestCase

from nautobot_chatops import filters, models
from nautobot_chatops.tests import fixtures


class CommandLogFilterTestCase(TestCase):
    """CommandLog Filter Test Case."""

    queryset = models.CommandLog.objects.all()
    filterset = filters.CommandLogFilterSet

    @classmethod
    def setUpTestData(cls):
        """Setup test data for CommandLog Model."""
        fixtures.create_commandlog()

    def test_q_search_name(self):
        """Test using Q search with name of CommandLog."""
        params = {"q": "Test One"}
        self.assertEqual(self.filterset(params, self.queryset).qs.count(), 1)

    def test_q_invalid(self):
        """Test using invalid Q search for CommandLog."""
        params = {"q": "test-five"}
        self.assertEqual(self.filterset(params, self.queryset).qs.count(), 0)
