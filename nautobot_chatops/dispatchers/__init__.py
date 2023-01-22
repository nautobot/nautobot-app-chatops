"""Dispatchers module for the nautobot_chatops Nautobot plugin.

The classes implemented in this module implement a common API for "dispatching" content
(plaintext messages, formatted text, UI elements, etc.) to the user of a given chat platform.
"""

from .base import Dispatcher
from .slack import SlackDispatcher
from .mattermost import MattermostDispatcher
from .ms_teams import MSTeamsDispatcher
from .webex import WebExDispatcher

__all__ = ("Dispatcher", "SlackDispatcher", "MattermostDispatcher", "MSTeamsDispatcher", "WebExDispatcher")
