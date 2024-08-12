"""Test of tower.py."""

from collections import namedtuple
from os import path

import requests_mock
from django.test import SimpleTestCase

from nautobot_chatops.integrations.ansible.tower import Tower

Origin = namedtuple("Origin", ["name", "slug"])

# Setup Mock information
HERE = path.abspath(path.dirname(__file__))

API_CALLS = [
    {
        "url": "https://mocktower/api/v2/inventories/",
        "fixture": f"{HERE}/fixtures/01_get_inventories.json",
        "method": "get",
    },
    {
        "url": "https://mocktower/api/v2/inventories/6/groups/",
        "fixture": f"{HERE}/fixtures/02_get_inventory_groups.json",
        "method": "get",
    },
    {
        "url": "https://mocktower/api/v2/groups/59/hosts/",
        "fixture": f"{HERE}/fixtures/03_get_inventory_hosts.json",
        "method": "get",
    },
    {
        "url": "https://mocktower/api/v2/dashboard/",
        "fixture": f"{HERE}/fixtures/04_get_dashboard.json",
        "method": "get",
    },
    {
        "url": "https://mocktower/api/v2/jobs/?order_by=-created&page_size=10",
        "fixture": f"{HERE}/fixtures/05_get_jobs.json",
        "method": "get",
    },
    {
        "url": "https://mocktower/api/v2/projects/",
        "fixture": f"{HERE}/fixtures/06_get_projects.json",
        "method": "get",
    },
]

SLACK_ORIGIN = Origin(name="Slack", slug="slack")


def load_api_calls(mock):
    """Load all of the API calls into memory for mocking."""
    for api_call in API_CALLS:
        with open(api_call["fixture"], "r", encoding="utf-8") as file_:
            data = file_.read()

        if api_call["method"] == "get":
            mock.get(api_call["url"], text=data, complete_qs=True)
            continue

        if api_call["method"] == "post":
            mock.post(api_call["url"], text=data, complete_qs=True)
            continue


class TestFunctions(SimpleTestCase):
    """Test the functions from Tower file."""

    def test_fail_missing_uri(self):
        """Test missing URI."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            with self.assertRaises(ValueError):
                Tower(origin=SLACK_ORIGIN, tower_uri=None, username="mock", password="mock", verify_ssl=False)

    def test_fail_uri_scheme_wrong(self):
        """Test URI scheme is http or https."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            with self.assertRaises(ValueError):
                Tower(
                    origin=SLACK_ORIGIN, tower_uri="ftp://mocktower", username="mock", password="mock", verify_ssl=False
                )

    def test_success_uri_strip(self):
        """Test rstrip on a trailing URI slash."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="http://mocktower/", username="mock", password="mock", verify_ssl=False
            )
            self.assertEqual(test_tower.uri, "http://mocktower")

    def test_success_uri_scheme_http(self):
        """Test uri scheme as http."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="http://mocktower", username="mock", password="mock", verify_ssl=False
            )
            self.assertEqual(test_tower.uri, "http://mocktower")

    def test_success_uri_scheme_https(self):
        """Test uri scheme as https."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="https://mocktower", username="mock", password="mock", verify_ssl=False
            )
            self.assertEqual(test_tower.uri, "https://mocktower")

    def test_fail_missing_username(self):
        """Test missing username."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            with self.assertRaises(ValueError):
                Tower(
                    origin=SLACK_ORIGIN, tower_uri="https://mocktower", username=None, password="mock", verify_ssl=False
                )

    def test_fail_missing_password(self):
        """Test missing password."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            with self.assertRaises(ValueError):
                Tower(
                    origin=SLACK_ORIGIN, tower_uri="https://mocktower", username="mock", password=None, verify_ssl=False
                )

    def test_get_tower_inventories(self):
        """Test tower inventory gathering."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="https://mocktower", username="mock", password="mock", verify_ssl=False
            )
            inventory = test_tower.get_tower_inventories()
            self.assertEqual(inventory["count"], 6)
            self.assertEqual(inventory["results"][0]["created"], "2020-05-15T22:36:10.743860Z")
            self.assertFalse(test_tower.tower_verify_ssl)

    def test_get_tower_inventory_id(self):
        """Test get tower inventory id."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="https://mocktower", username="mock", password="mock", verify_ssl=False
            )
            inventory_id = test_tower.get_tower_inventory_id(inventory_name="NautobotSOT")
            self.assertEqual(inventory_id, 6)
            self.assertFalse(test_tower.tower_verify_ssl)

    def test_get_tower_inventory_groups(self):
        """Test get tower inventory groups."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="https://mocktower", username="mock", password="mock", verify_ssl=False
            )
            inventory_name = "NautobotSOT"
            inv_groups = test_tower.get_tower_inventory_groups(inventory_name)
            self.assertEqual(inv_groups["count"], 34)
            self.assertEqual(len(inv_groups["results"]), 25)
            self.assertEqual(inv_groups["results"][0]["name"], "access_switch")
            self.assertFalse(test_tower.tower_verify_ssl)

    def test_get_tower_group_id(self):
        """Test get tower group id."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="https://mocktower", username="mock", password="mock", verify_ssl=False
            )
            inventory_id = 6
            group_name = "access_switch"
            group_id = test_tower.get_tower_group_id(inventory_id=inventory_id, group_name=group_name)
            self.assertEqual(group_id, 59)

    def test_get_tower_inventory_hosts(self):
        """Test get tower inventory hosts."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="https://mocktower", username="mock", password="mock", verify_ssl=False
            )
            group_id = 59
            inv_groups = test_tower.get_tower_inventory_hosts(group_id=group_id)
            self.assertEqual(inv_groups["count"], 11)
            self.assertEqual(len(inv_groups["results"]), 11)
            self.assertEqual(inv_groups["results"][0]["name"], "HQ-IDF01-R02-SW01")

    def test_get_tower_dashboard(self):
        """Test get tower dashboard."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="https://mocktower", username="mock", password="mock", verify_ssl=False
            )
            dashboard = test_tower.get_tower_dashboard()
            self.assertEqual(dashboard["inventories"]["total"], 6)
            self.assertEqual(dashboard["projects"]["failed"], 1)

    def test_get_tower_jobs(self):
        """Test get tower jobs."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="https://mocktower", username="mock", password="mock", verify_ssl=False
            )
            jobs = test_tower.get_tower_jobs(count=10)
            self.assertEqual(len(jobs), 5)
            self.assertEqual(jobs[0]["started"], "2021-03-05T16:52:13.605004Z")
            self.assertEqual(jobs[1]["started"], "2021-03-05T02:38:01.665837Z")

    def test_get_tower_projects(self):
        """Test get tower projects."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_tower = Tower(
                origin=SLACK_ORIGIN, tower_uri="https://mocktower", username="mock", password="mock", verify_ssl=False
            )
            projects = test_tower.get_tower_projects()
            self.assertEqual(len(projects), 1)
