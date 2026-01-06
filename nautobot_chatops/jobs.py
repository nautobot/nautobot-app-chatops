""""Job to rotate Slack access token using refresh token. Schedule to run every hour or so."""
from datetime import datetime, timedelta, timezone

from constance import config
from nautobot.apps.config import get_app_settings_or_config
from nautobot.apps.jobs import register_jobs
from nautobot.extras.jobs import BooleanVar, Job

from nautobot_chatops.helpers.slack import rotate_slack_access_token


class RotateSlackTokenJob(Job):
    """Rotate the Slack access token using the refresh token."""
    force_rotate = BooleanVar(
        description="Rotate the Slack access token now, regardless of expiration.",
        default=False,
    )

    class Meta:
        """Meta attributes for the RotateSlackTokenJob."""
        name = "Rotate Slack Access Token"
        description = "Rotate the Slack access token if neeeded, using the refresh token."
        has_sensitive_variables = False

    def run(self, force_rotate):
        """__Run the job to rotate the Slack access token."""
        if not get_app_settings_or_config("nautobot_chatops", "slack_enable_token_rotation"):
            self.logger.error("Slack token rotation is not enabled.")
            return

        token_time = datetime.fromisoformat(config.nautobot_chatops__slack_access_token_timestamp)
        if not force_rotate and datetime.now(timezone.utc) - token_time < timedelta(hours=3):
            self.logger.info("Slack access token is still valid; no rotation needed.")
            return

        self.logger.info("Attempting Slack access token rotation...")
        new_token = rotate_slack_access_token()
        if new_token:
            self.logger.success("Slack access token rotated successfully.")
        else:
            self.logger.failure("Slack token rotation failed; will retry on next scheduled run.")


register_jobs(RotateSlackTokenJob)
