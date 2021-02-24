"""Nautobot plugin application level metrics exposed through nautobot_metrics_ext."""

from prometheus_client.core import CounterMetricFamily


def metric_commands():
    """Report the number of command available."""
    # pylint: disable=import-outside-toplevel
    from .workers import get_commands_registry

    counters = CounterMetricFamily(
        "nautobot_command_library",
        "Count of commands available per subcommand ",
        labels=["command", "subcommand"],
    )

    registry = get_commands_registry()

    for command in sorted(registry):
        if isinstance(registry[command], bool):
            continue

        subcommands = registry[command].get("subcommands")
        if not subcommands:
            counters.add_metric([command], 1)
            continue

        for subcommand in sorted(subcommands):
            counters.add_metric([command, subcommand], 1)

    yield counters
