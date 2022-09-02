"""Dispatcher implementation for sending content to Slack."""

import logging
import os

from django.conf import settings
from django.templatetags.static import static

from nautobot_chatops.metrics import backend_action_sum
from .slack import SlackDispatcher

logger = logging.getLogger("rq.worker")

# pylint: disable=abstract-method

# Create a metric to track time spent and requests made.
BACKEND_ACTION_LOOKUP = backend_action_sum.labels("slack_socket", "platform_lookup")
BACKEND_ACTION_MARKDOWN = backend_action_sum.labels("slack_socket", "send_markdown")
BACKEND_ACTION_BLOCKS = backend_action_sum.labels("slack_socket", "send_blocks")
BACKEND_ACTION_SNIPPET = backend_action_sum.labels("slack_socket", "send_snippet")

class SlackSocketDispatcher(SlackDispatcher):
    """Dispatch messages and cards to Slack through SocketMode."""

    # pylint: disable=too-many-public-methods
    platform_name = "Slack"
    platform_slug = "slack"

    platform_color = "4A154B"  # Slack Aubergine

    command_prefix = settings.PLUGINS_CONFIG["nautobot_chatops"]["slack_slash_command_prefix"]
    """Prefix prepended to all commands, such as "/" or "!" in some clients."""

    def static_url(self, path):
        return str(static(path))