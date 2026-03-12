"""Test CommandLog Filter."""

from nautobot.apps.testing import FilterTestCases

from nautobot_chatops import filters, models


class CommandLogFilterTestCase(FilterTestCases.FilterTestCase):  # pylint: disable=too-many-ancestors
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
        models.CommandLog.objects.create(
            user_name="Test One",
            user_id="user-1",
            platform="slack",
            platform_color="9e9e9e",
            command="chatops",
            subcommand="run",
            params=["foo"],
        )
        models.CommandLog.objects.create(
            user_name="Test Two",
            user_id="user-2",
            platform="webex",
            platform_color="9e9e9e",
            command="chatops",
            subcommand="check",
            params=["bar"],
        )

    def test_q_search_name(self):
        """Test using Q search with name of CommandLog."""
        params = {"q": "Test One"}
        self.assertEqual(self.filterset(params, self.queryset).qs.count(), 1)

    def test_q_invalid(self):
        """Test using invalid Q search for CommandLog."""
        params = {"q": "test-five"}
        self.assertEqual(self.filterset(params, self.queryset).qs.count(), 0)
