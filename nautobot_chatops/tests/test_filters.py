"""Test CommandLog Filter."""

from nautobot.apps.testing import FilterTestCases

from nautobot_chatops import filters, models
from nautobot_chatops.tests import fixtures


class CommandLogFilterTestCase(FilterTestCases.FilterTestCase):
    """CommandLog Filter Test Case."""

    queryset = models.CommandLog.objects.all()
    filterset = filters.CommandLogFilterSet
    generic_filter_tests = (
        ("id",),
        ("created",),
        ("last_updated",),
        ("name",),
    )

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
