"""Compat helper for dynamic worker entrypoints in tests."""

from contextlib import contextmanager
from importlib import import_module
from typing import Iterator

from nautobot_chatops import workers


@contextmanager
def dynamic_entrypoint(group: str, name: str, module: str) -> Iterator[None]:
    """Temporarily inject an entrypoint for worker registry tests.

    This replaces the dependency on `prybar.dynamic_entrypoint`, which imports
    `pkg_resources` and fails in environments where setuptools doesn't provide it.
    """
    if group != "nautobot.workers":
        raise ValueError(f"Unsupported entrypoint group for tests: {group}")

    original_iter = workers._iter_worker_entry_points  # pylint: disable=protected-access

    class _InjectedEntryPoint:
        def __init__(self, entry_name: str, module_path: str):
            self.name = entry_name
            self._module_path = module_path

        def load(self):
            """Load the referenced entrypoint callable."""
            loaded_module = import_module(self._module_path)
            return getattr(loaded_module, self.name)

    def _patched_iter():
        yield from original_iter()
        yield _InjectedEntryPoint(name, module)

    workers._iter_worker_entry_points = _patched_iter  # pylint: disable=protected-access
    try:
        yield
    finally:
        workers._iter_worker_entry_points = original_iter  # pylint: disable=protected-access
