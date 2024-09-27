"""Import a panels.yml file into the Grafana object models in Nautobot."""

import yaml
from django.core.management.base import BaseCommand
from pydantic import ValidationError
from termcolor import colored

from nautobot_chatops.integrations.grafana.helpers import validate
from nautobot_chatops.integrations.grafana.models import Dashboard, Panel, PanelVariable


class Command(BaseCommand):
    """Extends the nautobot-server command to handle schema enforcer."""

    def handle(self, *args, **kwargs):
        """Import a panels.yml file into the ORM."""
        try:
            schema_errors = validate()
            if schema_errors:
                raise ValidationError(",".join(schema_errors))

            with open(kwargs["filename"]) as config_file:
                panels = yaml.safe_load(config_file)

                for dashboard in panels["dashboards"]:
                    dashboard_object = Dashboard.objects.get_or_create(
                        dashboard_slug=dashboard["dashboard_slug"], dashboard_uid=dashboard["dashboard_uid"]
                    )
                    for panel in dashboard.get("panels", []):
                        panel_object = Panel.objects.get_or_create(
                            command_name=panel["command_name"],
                            panel_id=panel["panel_id"],
                            friendly_name=panel.get("friendly_name", ""),
                            dashboard=dashboard_object[0],
                        )
                        for variable in panel.get("variables", []):
                            PanelVariable.objects.get_or_create(
                                panel=panel_object[0],
                                name=variable["name"],
                                query=variable.get("query", ""),
                                friendly_name=variable.get("friendly_name", ""),
                                includeincmd=variable.get("includeincmd", "False"),
                                includeinurl=variable.get("includeinurl", "True"),
                                modelattr=variable.get("modelattr", ""),
                                value=variable.get("value", ""),
                                response=variable.get("response", ""),
                                filter=variable.get("filter", {}),
                            )
                    print(
                        colored(
                            text=f"Created dashboard `{dashboard['dashboard_slug']}` with {len(dashboard.get('panels', []))} panels.",
                            color="green",
                        )
                    )

        except FileNotFoundError as exc:
            print(colored(text=exc, color="red"))

    def add_arguments(self, parser):
        """Adds arguments to the command.

        Args:
            parser: Argument parser.
        """
        parser.add_argument(
            "-f", "--filename", default="panels.yml", help="panels.yml filepath, if not in current directory."
        )
