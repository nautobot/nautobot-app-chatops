"""Helper functions and classes for Slack integration."""

import logging
from datetime import datetime, timedelta, timezone

from constance import config
from django.conf import settings
from nautobot.apps.config import get_app_settings_or_config
from slack_sdk import WebClient
from slack_sdk.web.async_client import AsyncWebClient

from nautobot_chatops.utils import database_sync_to_async

logger = logging.getLogger(__name__)


def get_slack_api_token() -> str:
    """Return the current Slack token.

    Returns:
        str: A valid access token if token rotation is enabled, otherwise the bot token.
    """
    if not get_app_settings_or_config("nautobot_chatops", "slack_enable_token_rotation"):
        return get_app_settings_or_config("nautobot_chatops", "slack_api_token")

    token_time_str = config.nautobot_chatops__slack_access_token_timestamp
    now = datetime.now(timezone.utc)
    token_time = None
    if token_time_str:
        try:
            token_time = datetime.fromisoformat(token_time_str)
        except Exception as e:
            logger.warning(f"Could not parse slack_access_token_timestamp: {e}")
            token_time = None

    is_access_token_expired = token_time is None or (now - token_time) > timedelta(hours=12)
    if is_access_token_expired:
        logger.info("Slack access token is expired or missing, attempting rotation. "
                    "Consider enabling the renewal job to avoid delays.")
        return rotate_slack_access_token()

    logger.debug("Using existing Slack access token.")
    return config.nautobot_chatops__slack_access_token


def rotate_slack_access_token() -> str | None:
    """Rotate the Slack access token using the refresh token.

    Args:
        refresh_token (str): Current Slack refresh token.

    Returns:
        str: access_token or None on failure.
    """
    slack_client_id = get_app_settings_or_config("nautobot_chatops", "slack_client_id")
    if not slack_client_id:
        logger.error("No Slack client ID found in Constance.")
        return None

    slack_client_secret = get_app_settings_or_config("nautobot_chatops", "slack_client_secret")
    if not slack_client_secret:
        logger.error("No Slack client secret found in Constance.")
        return None

    # not using get_app_settings_or_config here because we want to prioritize Constance for the refresh token
    refresh_token = config.nautobot_chatops__slack_refresh_token or \
        settings.PLUGINS_CONFIG["nautobot_chatops"].get("slack_api_token", "")
    if not refresh_token:
        logger.error("No Slack refresh token found in Constance.")
        return None

    new_timestamp = datetime.now(timezone.utc).isoformat()
    try:
        oauth_client = WebClient()
        response = oauth_client.oauth_v2_access(client_id=slack_client_id, client_secret=slack_client_secret,
                                                grant_type="refresh_token", refresh_token=refresh_token)

        new_access_token = response["access_token"]
        new_refresh_token = response["refresh_token"]

        config.nautobot_chatops__slack_access_token = new_access_token
        config.nautobot_chatops__slack_refresh_token = new_refresh_token
        config.nautobot_chatops__slack_access_token_timestamp = new_timestamp

        logger.info("Slack access token rotated successfully.")

        return new_access_token
    except Exception:
        logger.exception("Slack token rotation error")
        return None


class RotationAwareWebClient(WebClient):
    """A WebClient that refreshes its token on each request if token rotation is enabled."""

    def api_call(self, api_method: str, **kwargs):
        """Override api_call to refresh token if needed before making the call."""
        self.token = get_slack_api_token()
        return super().api_call(api_method, **kwargs)


class RotationAwareAsyncWebClient(AsyncWebClient):
    """An AsyncWebClient that refreshes its token on each request if token rotation is enabled."""

    async def api_call(self, api_method: str, **kwargs):
        """Override api_call to refresh token if needed before making the call."""
        self.token = await database_sync_to_async(get_slack_api_token)()
        return await super().api_call(api_method, **kwargs)
