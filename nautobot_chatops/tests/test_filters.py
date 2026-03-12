"""Test CommandLog Filter."""

from django.contrib.auth import get_user_model
from nautobot.apps.testing import FilterTestCases

from nautobot_chatops import filters, models


class CommandLogFilterTestCase(FilterTestCases.FilterTestCase):  # pylint: disable=too-many-ancestors
    """CommandLog Filter Test Case."""

    queryset = models.CommandLog.objects.all()
    filterset = filters.CommandLogFilterSet
    generic_filter_tests = (
        ("user_name",),
        ("platform",),
    )

    @classmethod
    def setUpTestData(cls):
        """Setup test data for CommandLog Model."""
        user_model = get_user_model()
        nautobot_user_one = user_model.objects.create(username="chatops-user-1")
        nautobot_user_two = user_model.objects.create(username="chatops-user-2")
        nautobot_user_three = user_model.objects.create(username="chatops-user-3")

        models.CommandLog.objects.create(
            user_name="Test One",
            user_id="user-1",
            platform="slack",
            platform_color="9e9e9e",
            command="chatops",
            subcommand="run",
            params=["foo"],
            nautobot_user=nautobot_user_one,
        )
        models.CommandLog.objects.create(
            user_name="Test Two",
            user_id="user-2",
            platform="webex",
            platform_color="9e9e9e",
            command="nautobot",
            subcommand="check",
            params=["bar"],
            nautobot_user=nautobot_user_two,
        )
        models.CommandLog.objects.create(
            user_name="Test Three",
            user_id="user-3",
            platform="mattermost",
            platform_color="9e9e9e",
            command="grafana",
            subcommand="status",
            params=["baz"],
            nautobot_user=nautobot_user_three,
        )

    def test_q_search_name(self):
        """Test using Q search with name of CommandLog."""
        params = {"q": "Test One"}
        self.assertEqual(self.filterset(params, self.queryset).qs.count(), 1)

    def test_q_invalid(self):
        """Test using invalid Q search for CommandLog."""
        params = {"q": "test-five"}
        self.assertEqual(self.filterset(params, self.queryset).qs.count(), 0)

    def test_command_filter(self):
        """Test filtering by command."""
        params = {"command": ["nautobot"]}
        self.assertEqual(self.filterset(params, self.queryset).qs.count(), 1)
