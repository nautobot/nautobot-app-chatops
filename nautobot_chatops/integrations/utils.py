"""Utility functions for nautobot_chatops integrations."""

from importlib import import_module
from pathlib import Path
from types import ModuleType
from typing import Generator

from nautobot.apps.config import get_app_settings_or_config

from nautobot_chatops.utils import logger


def _each_integration() -> Generator[str, None, None]:
    """Return all integrations."""
    for path in Path(__file__).parent.iterdir():
        if (path / "worker.py").is_file():
            yield path.name


ALL_INTEGRATIONS = set(_each_integration())


def _each_enabled_integration() -> Generator[str, None, None]:
    """Return all enabled integrations."""
    for name in ALL_INTEGRATIONS:
        if get_app_settings_or_config("nautobot_chatops", f"enable_{name}"):
            yield name


ENABLED_INTEGRATIONS = set(_each_enabled_integration())
DISABLED_INTEGRATIONS = ALL_INTEGRATIONS - ENABLED_INTEGRATIONS


def each_enabled_integration_module(module_name: str) -> Generator[ModuleType, None, None]:
    """For each enabled integration, import the module name."""
    for name in ENABLED_INTEGRATIONS:
        try:
            module = import_module(f"nautobot_chatops.integrations.{name}.{module_name}")
        except ModuleNotFoundError:
            logger.debug("Integration %s does not have a %s module, skipping.", name, module_name)
            continue

        yield module
