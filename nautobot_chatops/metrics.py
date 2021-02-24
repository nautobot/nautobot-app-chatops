"""Nautobot plugin metrics exposed through nautobot_metrics_ext."""

from prometheus_client import Counter, Histogram, Summary

# pylint: disable=pointless-string-statement

METRICS_PREFIX = "nautobot_chatops"

"""Number of signature error per platform and type of error

Labels:
    platform (str)
    error_type (str) [ missing_signature, missing_timestamp, incorrect_signature]
"""
signature_error_cntr = Counter(
    f"{METRICS_PREFIX}_signature_error_count",
    "Number of signature error per platform and type of error",
    ["platform", "type"],
)

"""Count the number of commmand

Labels:
    platform (str)
    command (str) name of the command
    subcommand (str) name of the subcommand
    status (str) status of the command from CommandStatusChoices
"""
request_command_cntr = Counter(
    f"{METRICS_PREFIX}_command_count",
    "Count number of command & subcommand per platform & status",
    ["platform", "command", "subcommand", "status"],
)

"""Histogram of time spent executing each command in the worker"""
command_histogram = Histogram(
    f"{METRICS_PREFIX}_command_seconds", "Histogram of time spent executing each command in the worker"
)

"""Summary of the time spent to interact with each backend platform.

Labels:
    platform (str)
    action (str) identifier of the action performed (send_markdown etc ..)
"""
backend_action_sum = Summary(
    f"{METRICS_PREFIX}_backend_action_seconds",
    "Time spent interacting with the backend platform.",
    ["platform", "action"],
)
