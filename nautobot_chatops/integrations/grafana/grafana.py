"""This module is intended to handle grafana requests generically perhaps outside of nautobot."""

import datetime
import logging
import urllib.parse
from http import HTTPStatus
from typing import List, Tuple, Union

import isodate
import requests
from django.conf import settings
from pydantic import BaseModel  # pylint: disable=no-name-in-module
from requests.exceptions import RequestException
from typing_extensions import Literal

from nautobot_chatops.integrations.grafana.models import Panel, PanelVariable

LOGGER = logging.getLogger("nautobot.plugin.grafana")
PLUGIN_SETTINGS = settings.PLUGINS_CONFIG["nautobot_chatops"]

SLASH_COMMAND = "grafana"
GRAFANA_LOGO_PATH = "grafana/grafana_icon.png"
GRAFANA_LOGO_ALT = "Grafana Logo"
REQUEST_TIMEOUT_SEC = 60


class GrafanaConfigSettings(BaseModel):  # pylint: disable=too-few-public-methods
    """Model for config parameters to validate config schema."""

    grafana_url: str
    grafana_api_key: str
    default_width: int
    default_height: int
    default_theme: Literal["light", "dark"]
    default_timespan: datetime.timedelta
    grafana_org_id: int
    default_tz: str


def _get_settings_from_chatops(config: dict) -> GrafanaConfigSettings:
    try:
        # See: https://docs.pydantic.dev/2.6/api/standard_library_types/#datetimetimedelta
        default_timespan = int(config["grafana_default_timespan"])
    except ValueError:
        default_timespan = config["grafana_default_timespan"]

    return GrafanaConfigSettings(
        grafana_url=config["grafana_url"],
        grafana_api_key=config["grafana_api_key"],
        default_width=config["grafana_default_width"],
        default_height=config["grafana_default_height"],
        default_theme=config["grafana_default_theme"],
        default_timespan=default_timespan,
        grafana_org_id=config["grafana_org_id"],
        default_tz=config["grafana_default_tz"],
    )


class GrafanaHandler:
    """Handle Building Grafana Requests."""

    config: GrafanaConfigSettings = None
    panels = None
    current_subcommand = ""
    now = datetime.datetime.utcnow()

    def __init__(self, config: dict) -> None:
        """Initialize the class."""
        self.config = _get_settings_from_chatops(config)
        self.load_panels()
        self.default_params = {
            "width": self.config.default_width,
            "height": self.config.default_height,
            "theme": self.config.default_theme,
            "timespan": self.config.default_timespan,
            "timezone": self.config.default_tz,
        }

    def load_panels(self):
        """This method loads the yaml configuration file, and validates the schema."""
        self.panels = Panel.objects.all()

    @property
    def width(self):
        """Simple Get Width."""
        return self.config.default_width

    @property
    def height(self):
        """Simple Get Height."""
        return self.config.default_height

    @property
    def theme(self):
        """Simple Get Theme."""
        return self.config.default_theme

    @property
    def timespan(self):
        """Simple Get Timespan."""
        return self.config.default_timespan

    @property
    def timezone(self):
        """Simple Get Timezone."""
        return self.config.default_tz

    @width.setter
    def width(self, new_width: int):
        """Simple Set Width.  Must redefine the config model for pydantic to validate."""
        new_config = GrafanaConfigSettings(
            grafana_url=self.config.grafana_url,
            grafana_api_key=self.config.grafana_api_key,
            default_width=new_width,
            default_height=self.config.default_height,
            default_theme=self.config.default_theme,
            default_timespan=self.config.default_timespan,
            grafana_org_id=self.config.grafana_org_id,
            default_tz=self.config.default_tz,
        )
        self.config = new_config

    @height.setter
    def height(self, new_height: int):
        """Simple Set Height.  Must redefine the config model for pydantic to validate."""
        new_config = GrafanaConfigSettings(
            grafana_url=self.config.grafana_url,
            grafana_api_key=self.config.grafana_api_key,
            default_width=self.config.default_width,
            default_height=new_height,
            default_theme=self.config.default_theme,
            default_timespan=self.config.default_timespan,
            grafana_org_id=self.config.grafana_org_id,
            default_tz=self.config.default_tz,
        )
        self.config = new_config

    @theme.setter
    def theme(self, new_theme: Literal["light", "dark"]):
        """Simple Set Theme.  Must redefine the config model for pydantic to validate."""
        new_config = GrafanaConfigSettings(
            grafana_url=self.config.grafana_url,
            grafana_api_key=self.config.grafana_api_key,
            default_width=self.config.default_width,
            default_height=self.config.default_height,
            default_theme=new_theme,
            default_timespan=self.config.default_timespan,
            grafana_org_id=self.config.grafana_org_id,
            default_tz=self.config.default_tz,
        )
        self.config = new_config

    @timespan.setter
    def timespan(self, new_timespan: str):
        """Simple Set Timespan.  Must redefine the config model for pydantic to validate."""
        new_config = GrafanaConfigSettings(
            grafana_url=self.config.grafana_url,
            grafana_api_key=self.config.grafana_api_key,
            default_width=self.config.default_width,
            default_height=self.config.default_height,
            default_theme=self.config.default_theme,
            default_timespan=new_timespan
            if not new_timespan
            else isodate.parse_duration(new_timespan).totimedelta(start=self.now),
            grafana_org_id=self.config.grafana_org_id,
            default_tz=self.config.default_tz,
        )
        self.config = new_config

    @timezone.setter
    def timezone(self, new_timezone: str):
        """Simple Set Timezone.  Must redefine the config model for pydantic to validate."""
        new_config = GrafanaConfigSettings(
            grafana_url=self.config.grafana_url,
            grafana_api_key=self.config.grafana_api_key,
            default_width=self.config.default_width,
            default_height=self.config.default_height,
            default_theme=self.config.default_theme,
            default_timespan=self.config.default_timespan,
            grafana_org_id=self.config.grafana_org_id,
            default_tz=new_timezone,
        )
        self.config = new_config

    @property
    def headers(self) -> dict:
        """Helper function to return the required headers for a Grafana requests.

        Returns:
            (dict): key, value pairs of header values.
        """
        headers = {"Accept": "application/json"}
        if self.config.grafana_api_key:
            headers["Authorization"] = f"Bearer {self.config.grafana_api_key}"
        return headers

    def get_png(self, panel: Panel, panel_vars: List[PanelVariable]) -> Union[bytes, None]:
        """Using requests GET the generated URL and return the binary contents of the file.

        Args:
            panel (nautobot_chatops.grafana.models.Panel): The Panel object.
            panel_vars (List[nautobot_chatops.grafana.models.PanelVariable]): List of PanelVariable objects.

        Returns:
            Union[bytes, None]: The raw image from the renderer or None if there was an error.
        """
        url, payload = self.get_png_url(panel, panel_vars)
        try:
            LOGGER.debug("Begin GET %s", url)
            results = requests.get(url, headers=self.headers, stream=True, params=payload, timeout=REQUEST_TIMEOUT_SEC)
        except RequestException as exc:
            LOGGER.error("An error occurred while accessing the url: %s Exception: %s", url, exc)
            return None

        if results.status_code == HTTPStatus.OK:
            LOGGER.debug("Request returned %s", results.status_code)
            return results.content

        LOGGER.error("Request returned %s for %s", results.status_code, url)
        return None

    def get_png_url(self, panel: Panel, panel_vars: List[PanelVariable]) -> Tuple[str, dict]:
        """Generate the URL and the Payload for the request.

        Args:
            panel (nautobot_chatops.grafana.models.Panel): The Panel object.
            panel_vars (List[nautobot_chatops.grafana.models.PanelVariable]): List of PanelVariable objects.

        Returns:
            Tuple[str, dict]: Grafana url and payload to send to the grafana renderer.
        """
        payload = {
            "orgId": self.config.grafana_org_id,
            "panelId": panel.panel_id,
            "tz": urllib.parse.quote(self.config.default_tz),
            "theme": self.config.default_theme,
        }
        from_time = str(int((self.now - self.config.default_timespan).timestamp() * 1e3))
        to_time = str(int(self.now.timestamp() * 1e3))
        if from_time != to_time:
            payload["from"] = from_time
            payload["to"] = to_time
        if self.config.default_width > 0:
            payload["width"] = self.config.default_width
        if self.config.default_height > 0:
            payload["height"] = self.config.default_height

        for variable in panel_vars:
            if variable.includeinurl and variable.value:
                payload[f"var-{variable.name}"] = variable.value
        url = (
            f"{self.config.grafana_url}/render/d-solo/{panel.dashboard.dashboard_uid}/{panel.dashboard.dashboard_slug}"
        )
        LOGGER.debug("URL: %s Payload: %s", url, payload)
        return url, payload

    def get_dashboards(self) -> List[dict]:
        """get_dashboards will fetch the active dashboards from the grafana API.

        Returns:
            List[dict]: A list of the grafana dashboards.
        """
        url = f"{self.config.grafana_url}/api/search"
        try:
            LOGGER.debug("Begin GET /api/search")
            results = requests.get(
                url=url,
                headers=self.headers,
                params={"type": "dash-db"},
                timeout=REQUEST_TIMEOUT_SEC,
            )
        except RequestException as exc:
            LOGGER.error("An error occurred while accessing the url: %s Exception: %s", url, exc)
            return []

        if results.status_code == HTTPStatus.OK:
            LOGGER.debug("Request returned %s", results.status_code)
            return results.json()

        LOGGER.error("Request returned %s for %s", results.status_code, url)
        return []

    def get_panels(self, dashboard_uid: str) -> List[dict]:
        """get_panels will fetch the active panels for a given dashboard from the grafana API.

        Returns:
            List[dict]: A list of the grafana panels.
        """
        url = f"{self.config.grafana_url}/api/dashboards/uid/{dashboard_uid}"
        try:
            LOGGER.debug("Begin GET /api/dashboards/uid/")
            results = requests.get(
                url=url,
                headers=self.headers,
                timeout=REQUEST_TIMEOUT_SEC,
            )
        except RequestException as exc:
            LOGGER.error("An error occurred while accessing the url: %s Exception: %s", url, exc)
            return []

        if results.status_code != HTTPStatus.OK:
            LOGGER.error("Request returned %s for %s", results.status_code, url)
            return []

        LOGGER.debug("Request returned %s", results.status_code)
        data = results.json()
        if not data.get("dashboard"):
            LOGGER.error("Response does not contain `dashboard` key.")
            return []

        if not data["dashboard"].get("panels"):
            LOGGER.error("Response does not contain `dashboard.panels` key.")
            return []

        return data["dashboard"]["panels"]

    def get_variables(self, dashboard_uid: str) -> List[dict]:
        """get_variables will fetch the active templates for a given dashboard from the grafana API.

        Returns:
            List[dict]: A list of the grafana variables.
        """
        url = f"{self.config.grafana_url}/api/dashboards/uid/{dashboard_uid}"
        try:
            LOGGER.debug("Begin GET /api/dashboards/uid/")
            results = requests.get(
                url=url,
                headers=self.headers,
                timeout=REQUEST_TIMEOUT_SEC,
            )
        except RequestException as exc:
            LOGGER.error("An error occurred while accessing the url: %s Exception: %s", url, exc)
            return []

        if results.status_code != HTTPStatus.OK:
            LOGGER.error("Request returned %s for %s", results.status_code, url)
            return []

        LOGGER.debug("Request returned %s", results.status_code)
        data = results.json()
        if not data.get("dashboard"):
            LOGGER.error("Response does not contain `dashboard` key.")
            return []

        if not data["dashboard"].get("templating"):
            LOGGER.error("Response does not contain `dashboard.templating` key.")
            return []

        if not data["dashboard"]["templating"].get("list"):
            LOGGER.error("Response does not contain `dashboard.templating.list` key.")
            return []

        variables = []
        for variable in data["dashboard"]["templating"]["list"]:
            variables.append(
                {
                    "name": variable["name"],
                    "response": variable["current"].get("text"),
                    "includeinurl": True,
                    "includeincmd": False,
                    "friendly_name": variable["name"],
                }
            )

        return variables

    def panel_url(self, panel: Panel):
        """Helper method that will build the panel URL for a given request from ChatOps.

        Args:
            panel (Panel): Grafana Dashboard panel.
        """
        payload = {
            "orgId": self.config.grafana_org_id,
            "viewPanel": panel.panel_id,
        }
        from_time = str(int((self.now - self.config.default_timespan).timestamp() * 1e3))
        to_time = str(int(self.now.timestamp() * 1e3))
        if from_time != to_time:
            payload["from"] = from_time
            payload["to"] = to_time

        base_url = f"{self.config.grafana_url}/d/{panel.dashboard.dashboard_uid}/{panel.dashboard.dashboard_slug}"
        return f"{base_url}?{urllib.parse.urlencode(payload)}"


handler = GrafanaHandler(PLUGIN_SETTINGS)
