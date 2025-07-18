"""Worker functions implementing Nautobot "NautobotGPT" command and subcommands."""

import logging
from collections import namedtuple

from django.conf import settings

from nautobot_chatops.choices import CommandStatusChoices
from nautobot_chatops.workers import handle_subcommands, subcommand_of

from .nautobotgpt import NautobotGPT

NAUTOBOTGPT_URL = settings.PLUGINS_CONFIG["nautobot_chatops"]["nautobotgpt_url"]

NAUTOBOTGPT_LOGO_PATH = "nautobotgpt/NautobotGPT.png"
NAUTOBOTGPT_LOGO_ALT = "NautobotGPT Logo"

Origin = namedtuple("Origin", ["name", "slug"])

LOGGER = logging.getLogger("nautobot_chatops.integrations.nautobotgpt")


def nautobotgpt_logo(dispatcher):
    """Construct an image_element containing the locally hosted NautobotGPT logo."""
    return dispatcher.image_element(dispatcher.static_url(NAUTOBOTGPT_LOGO_PATH), alt_text=NAUTOBOTGPT_LOGO_ALT)


def nautobotgpt(subcommand, **kwargs):
    """Interact with NautobotGPT."""
    return handle_subcommands("nautobotgpt", subcommand, **kwargs)


@subcommand_of("nautobotgpt")
def ask(dispatcher, *args):
    """Ask NautobotGPT a question."""
    nbgpt = NautobotGPT()

    if not args:
        dispatcher.send_markdown("Please provide a question to ask NautobotGPT.")
        return CommandStatusChoices.STATUS_FAILED

    question = ' '.join(''.join(word) for word in args).strip()
    dispatcher.send_markdown(f"*Question:* {question}\nThinking...", ephemeral=True)

    response = nbgpt.ask(question)

    dispatcher.send_markdown(response, ephemeral=True)
    return CommandStatusChoices.STATUS_SUCCEEDED
