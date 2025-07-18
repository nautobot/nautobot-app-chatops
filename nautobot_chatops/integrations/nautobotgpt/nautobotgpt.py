"""All interactions with NautobotGPT."""

import logging
from urllib.parse import urlparse

import requests
from django.conf import settings

logger = logging.getLogger(__name__)

_CONFIG = settings.PLUGINS_CONFIG["nautobot_chatops"]

DEFAULT_TIMEOUT = 30


def _get_url(uri):
    """Validate URI schema and no trailing slash.

    Args:
        uri(str): NautobotGPT URI

    Returns:
        (str): Validated/Cleaned URI.
    """
    valid_uri = urlparse(uri)
    if valid_uri.scheme not in ["http", "https"]:
        return None
    return valid_uri.geturl().rstrip("/")


class NautobotGPT:  # pylint: disable=too-many-function-args
    """Representation and methods for interacting with NautobotGPT."""

    def __init__(
        self,
        nautobotgpt_url=_CONFIG["nautobotgpt_url"],
        username=_CONFIG["nautobotgpt_username"],
        password=_CONFIG["nautobotgpt_password"],
        model=_CONFIG["nautobotgpt_model"],
    ):  # pylint: disable=too-many-arguments
        """Initialization of NautobotGPT class.

        Args:
            nautobotgpt_url (str): URL of NautobotGPT endpoint
            username (str): Username to log into NautobotGPT
            password (str): Password to log into NautobotGPT
            model (str): Model to use for NautobotGPT
        """
        if nautobotgpt_url:
            self.url = _get_url(nautobotgpt_url)
        else:
            self.url = None
        self.username = username
        self.password = password
        self.model = model
        self.headers = {"Content-Type": "application/json"}
        if not self.url or not self.username or not self.password:
            raise ValueError("Missing required parameters for NautobotGPT access - check environment and app configuration")
        self.login_open_webui()
        self.template: str = "Format your response in markdown formatting. Use a single * for bold text, a single _ for italic text, and a single ` for inline code. For code blocks, use three backticks (```) before and after the code block. For example:\n\n```python\nprint('Hello, World!')\n```\n\n"

    def login_open_webui(self) -> None:
        """Log in to Open WebUI and return the token."""
        url = f"{self.url}/api/v1/auths/signin"
        payload = {"email": self.username, "password": self.password}

        response = requests.post(url, headers=self.headers, json=payload, timeout=DEFAULT_TIMEOUT)
        data = response.json()
        self.headers["Authorization"] = f"Bearer {data.get('token')}"

    def ask(self, user_prompt: str, chat_id: str="00000000-0000-0000-0000-000000000000") -> str:
        """"Ask a question to NautobotGPT and return the response.

        Args:
            user_prompt (str): The question or prompt to send to NautobotGPT.
            chat_id (str): The ID of the chat session. Defaults to a placeholder value.

        Returns:
            str: The response from NautobotGPT.
        """
        url = f"{self.url}/api/chat/completions"
        payload = {
            "model": self.model,
            "messages": [{"role": "user", "content": self.template + user_prompt}],
            "stream": False,
            "chat_id": chat_id,
        }
        max_retries = 3  # Maximum number of retries
        attempt = 0

        while attempt < max_retries:
            try:
                response = requests.post(url, headers=self.headers, json=payload, timeout=DEFAULT_TIMEOUT)
                response.raise_for_status()  # Raise HTTPError for bad responses
                break  # Exit the loop if the request is successful
            except requests.RequestException:
                attempt += 1

        data = response.json()
        choices = data.get("choices", [])
        message_content = choices[0].get("message", {}).get("content", "") if choices else "No response"
        return message_content
