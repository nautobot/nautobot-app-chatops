"""Test of nautobotgpt.py."""

from os import path

import requests_mock
from django.test import SimpleTestCase

from nautobot_chatops.integrations.nautobotgpt.nautobotgpt import NautobotGPT

# Setup Mock information
HERE = path.abspath(path.dirname(__file__))

API_CALLS = [
    {
        "url": "https://mockgpt/api/v1/chat/completions",
        "fixture": f"{HERE}/fixtures/01_ask.json",
        "method": "get",
    }
]

MODEL = "nautobotgpt"


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
    """Test the functions from NautobotGPT file."""

    def test_fail_missing_url(self):
        """Test missing url."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            with self.assertRaises(ValueError):
                NautobotGPT(nautobotgpt_url=None, username="mock", password="mock", model=MODEL)

    def test_fail_url_scheme_wrong(self):
        """Test url scheme is http or https."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            with self.assertRaises(ValueError):
                NautobotGPT(nautobotgpt_url="ftp://mockgpt", username="mock", password="mock", model=MODEL)

    def test_success_url_strip(self):
        """Test rstrip on a trailing url slash."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_nbgpt = NautobotGPT(nautobotgpt_url="http://mockgpt/", username="mock", password="mock", model=MODEL)
            self.assertEqual(test_nbgpt.url, "http://mockgpt")

    def test_success_url_scheme_http(self):
        """Test url scheme as http."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_nbgpt = NautobotGPT(nautobotgpt_url="http://mockgpt", username="mock", password="mock", model=MODEL)
            self.assertEqual(test_nbgpt.url, "http://mockgpt")

    def test_success_url_scheme_https(self):
        """Test url scheme as https."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_nbgpt = NautobotGPT(nautobotgpt_url="https://mockgpt", username="mock", password="mock", model=MODEL)
            self.assertEqual(test_nbgpt.url, "https://mockgpt")

    def test_fail_missing_username(self):
        """Test missing username."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            with self.assertRaises(ValueError):
                NautobotGPT(nautobotgpt_url="https://mockgpt", username=None, password="mock", model=MODEL)

    def test_fail_missing_password(self):
        """Test missing password."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            with self.assertRaises(ValueError):
                NautobotGPT(nautobotgpt_url="https://mockgpt", username="mock", password=None, model=MODEL)

    def test_success_authenticate(self):
        """Test successful authentication."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_nbgpt = NautobotGPT(nautobotgpt_url="https://mockgpt", username="mock", password="mock", model=MODEL)
            self.assertTrue(test_nbgpt.headers.get("Authorization", "").startswith("Bearer "))
            self.assertEqual(test_nbgpt.headers["Content-Type"], "application/json")

    def test_ask(self):
        """Test asking a question to NautobotGPT."""
        with requests_mock.Mocker() as mock:
            load_api_calls(mock)

            test_nbgpt = NautobotGPT(nautobotgpt_url="https://mockgpt", username="mock", password="mock", model=MODEL)
            response = test_nbgpt.ask("What is the meaning of life?")
            self.assertEqual(response["choices"][0]["message"]["content"], "The meaning of life is 42.")
            self.assertEqual(response["model"], MODEL)
