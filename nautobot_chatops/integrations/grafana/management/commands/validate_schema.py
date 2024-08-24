"""Nautobot Server CLI extension for Grafana ChatOps."""

from django.core.management.base import BaseCommand

from nautobot_chatops.integrations.grafana.helpers import validate


class Command(BaseCommand):
    """Extends the nautobot-server command to handle schema enforcer."""

    def handle(self, *args, **kwargs):
        """Handles incoming request passed to the validate_schema command."""
        schema_errors = validate(strict=kwargs["strict"])
        if schema_errors:
            print(",".join(schema_errors))
        else:
            print("ALL SCHEMA VALIDATION CHECKS PASSED √√")

    def add_arguments(self, parser):
        """Adds arguments to the command.

        Args:
            parser: Argument parser.
        """
        parser.add_argument(
            "--strict",
            action="store_true",
            help="Force a stricter schema check that warns about unexpected additional properties",
        )
