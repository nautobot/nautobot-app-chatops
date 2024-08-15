"""All interactions with Ansible AWX/Tower."""

import json
import logging
from urllib.parse import urlparse

import requests
from django.conf import settings

logger = logging.getLogger(__name__)

_CONFIG = settings.PLUGINS_CONFIG["nautobot_chatops"]

DEFAULT_TIMEOUT = 20


def _get_uri(uri):
    """Validate URI schema and no trailing slash.

    Args:
        uri(str): Tower/AWX URI

    Returns:
        (str): Validated/Cleaned URI.
    """
    valid_uri = urlparse(uri)
    if valid_uri.scheme not in ["http", "https"]:
        return None
    return valid_uri.geturl().rstrip("/")


class Tower:  # pylint: disable=too-many-function-args
    """Representation and methods for interacting with Ansible Tower/AWX."""

    def __init__(
        self,
        origin,
        tower_uri=_CONFIG["tower_uri"],
        username=_CONFIG["tower_username"],
        password=_CONFIG["tower_password"],
        verify_ssl=_CONFIG["tower_verify_ssl"],
    ):  # pylint: disable=too-many-arguments
        """Initialization of Tower class.

        Args:
            origin (namedtuple): Contains platform name and slug
            tower_uri (str): URI of Tower/AWX instance
            username (str): Username to log into Ansible Tower
            password (str): Password to log into Ansible Tower
            verify_ssl (bool): Verify SSL connections. Defaults to True.
        """
        if tower_uri:
            self.uri = _get_uri(tower_uri)
        else:
            self.uri = None
        self.username = username
        self.password = password
        self.tower_verify_ssl = verify_ssl
        self.headers = {"Content-Type": "application/json"}
        self.origin = origin
        self.extra_vars = {}
        if not self.uri or not self.username or not self.password:
            raise ValueError("Missing required parameters for Tower access - check environment and app configuration")

    def _launch_job(self, template_name, extra_vars):
        """Launch a playbook in Ansible Tower.

        Args:
            template_name(str): Name of the template in Ansible tower which will be called
            extra_vars(dict): extra variables that will be passed to Ansible at run time
        """
        extra_vars["origin"] = self.origin.name
        extra_vars["chat_type"] = self.origin.slug
        url = f"{self.uri}/api/v2/job_templates/{template_name}/launch/"
        logger.info("Launch URL: %s", url)
        logger.info("Launch Extra Vars: %s", extra_vars)
        response = requests.post(
            url,
            auth=requests.auth.HTTPBasicAuth(self.username, self.password),
            headers=self.headers,
            data=json.dumps({"extra_vars": extra_vars}),
            verify=self.tower_verify_ssl,  # nosec
            timeout=DEFAULT_TIMEOUT,
        )
        response.raise_for_status()
        logger.info("Job submission to Ansible Tower:")
        logger.info(response.json())

        return response.json()

    def _get_tower(self, api_path, **kwargs):
        """Issues get to Ansible Tower at the api path specified.

        Args:
            api_path (str): API path to get data from
            **kwargs: Additional Keyword Arguments

        Returns:
            (JSON): JSON data for the response
        """
        response = requests.get(
            f"{self.uri}/api/v2/{api_path}",
            auth=(self.username, self.password),
            **kwargs,
            verify=self.tower_verify_ssl,  # nosec
            timeout=DEFAULT_TIMEOUT,
        )
        return response.json()

    def get_tower_inventories(self):
        """Gets inventory of devices in Ansible Tower."""
        return self._get_tower("inventories/")

    def get_tower_inventory_id(self, inventory_name: str):  # pylint: disable=inconsistent-return-statements
        """Gets Tower inventory ID from list of inventories.

        Args:
            inventory_name (str): Name of the inventory to get

        Returns:
            (int): Inventory ID
        """
        inventories = self.get_tower_inventories()["results"]
        for inventory in inventories:
            if inventory["name"] == inventory_name:
                return inventory["id"]

    def get_tower_inventory_groups(self, inventory):
        """Gets Tower groups from inventory.

        Args:
            inventory (str): Name of the inventory

        Returns:
            (json): JSON data of the Tower groups
        """
        # Get the inventory ID from the name
        inventory_id = self.get_tower_inventory_id(inventory_name=inventory)

        # Return the groups of the inventory
        return self._get_tower(f"inventories/{inventory_id}/groups/")

    def get_tower_group_id(self, inventory_id: int, group_name: str):  # pylint: disable=inconsistent-return-statements
        """Gets Group ID from groups.

        Args:
            group_name (str): Name of the desired group
            inventory_id (int): The inventory ID
        """
        groups = self._get_tower(f"inventories/{inventory_id}/groups/")["results"]
        for group in groups:
            if group["name"] == group_name:
                return group["id"]

    def get_tower_inventory_hosts(self, group_id):
        """Gets hosts for a given Tower inventory.

        Args:
            group_id (str): Group Name

        Returns:
            (json): JSON data of the Tower hosts
        """
        return self._get_tower(f"groups/{group_id}/hosts/")

    def get_tower_dashboard(self):
        """Gets dashboard data from Ansible Tower.

        This is likely to be deprecated in the future per docs.

        Returns:
            dict: Dictionary results
        """
        return self._get_tower("dashboard/")

    def get_tower_jobs(self, count: int):
        """Gets Tower Job results.

        Args:
            count (int): Number of jobs to get

        Returns:
            dict: Job results
        """
        response = self._get_tower("jobs/", params={"order_by": "-created", "page_size": str(count)})
        return response["results"]

    def get_tower_projects(self):
        """Gets tower projects.

        Returns:
            dict: Tower projects return
        """
        response = self._get_tower("projects/")
        return response["results"]

    def run_tower_template(self, dispatcher, template_name):
        """Executes a tower template.

        Args:
            dispatcher (dispatcher): Information about the dispatcher (chat client)
            template_name (str): Name of the template

        Returns:
            Requests.response: Response of requests
        """
        response = self._launch_job(
            template_name=template_name,
            extra_vars={"channel": dispatcher.context.get("channel_name")},
        )
        return response

    def get_tower_template(self, template_name):
        """Gets tower template from a name.

        Args:
            template_name (str): Name of the template to get

        Returns:
            requests.response: Requests response
        """
        return self._get_tower("job_templates/", params={"name": template_name})

    def retrieve_job_templates(self):
        """Get job template listing from Ansible."""
        response = self._get_tower("job_templates/")
        return response["results"]
