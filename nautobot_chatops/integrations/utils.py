"""Utility functions for nautobot_chatops integrations."""
from collections.abc import Mapping
from importlib import import_module
from pathlib import Path
from types import ModuleType
from typing import Generator

from django.conf import settings

from nautobot_chatops.utils import logger


def _each_integration() -> Generator[str, None, None]:
    """Return all integrations."""
    for path in Path(__file__).parent.iterdir():
        if (path / "worker.py").is_file():
            yield path.name


ALL_INTEGRATIONS = set(_each_integration())


def _each_enabled_integration() -> Generator[str, None, None]:
    """Return all enabled integrations."""
    if not isinstance(settings.PLUGINS_CONFIG, Mapping):
        raise TypeError("Django `settings.PLUGINS_CONFIG` must be a Mapping")

    config = settings.PLUGINS_CONFIG["nautobot_chatops"]
    if not isinstance(config, Mapping):
        raise TypeError("nautobot_chatops config must be a Mapping")

    for name in ALL_INTEGRATIONS:
        if config.get(f"enable_{name}", False):
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
