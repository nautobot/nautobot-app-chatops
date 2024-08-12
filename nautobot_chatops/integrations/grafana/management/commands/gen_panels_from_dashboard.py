"""Generate a panels.yml file using the json file retrieved from Grafana."""

import json

import yaml
from django.core.management.base import BaseCommand
from termcolor import colored


class Command(BaseCommand):
    """Extends the nautobot-server command to handle schema enforcer."""

    def handle(self, *args, **kwargs):
        """Build a panels.yml file using the passed in json file."""
        try:
            with open(kwargs["filename"], "r") as dashboard_file:
                try:
                    dashboard_def = json.load(dashboard_file)
                except json.JSONDecodeError as exc:
                    print(colored(text=f"{kwargs['filename']} is not valid a valid json file. {exc}", color="red"))
                    return

                dashboard_slug = "a-django-prometheus"
                dashboard_uid = dashboard_def["uid"]

                gen_panels_yml = []

                for panel in dashboard_def["panels"]:
                    if panel.get("type", str()):
                        if panel["type"] == "row":
                            continue
                        command_name = str("-".join(panel["title"].lower().split(" ")))
                        panel_id = int(panel["id"])
                        friendly_name = str(panel["title"])
                        panel = {
                            "command_name": f"{command_name}",
                            "panel_id": panel_id,
                            "friendly_name": f"{friendly_name}",
                        }

                    gen_panels_yml.append(panel)

                output = {
                    "dashboards": [
                        {
                            "dashboard_slug": f"{dashboard_slug}",
                            "dashboard_uid": f"{dashboard_uid}",
                            "panels": gen_panels_yml,
                        }
                    ]
                }

                print(yaml.dump(output))
        except FileNotFoundError as exc:
            print(colored(text=exc, color="red"))

    def add_arguments(self, parser):
        """Adds arguments to the command.

        Args:
            parser: Argument parser.
        """
        parser.add_argument("filename", help="JSON filename to convert into a panels.yml format.")
