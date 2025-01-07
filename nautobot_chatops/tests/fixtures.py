"""Create fixtures for tests."""

from nautobot_chatops.models import CommandLog


def create_commandlog():
    """Fixture to create necessary number of CommandLog for tests."""
    CommandLog.objects.create(name="Test One")
    CommandLog.objects.create(name="Test Two")
    CommandLog.objects.create(name="Test Three")
