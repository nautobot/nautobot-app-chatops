"""Worker functions implementing Nautobot "ansible" command and subcommands."""

import json
import logging
from collections import namedtuple

import yaml
from django.conf import settings

from nautobot_chatops.workers import handle_subcommands, subcommand_of

from .tower import Tower

TOWER_URI = settings.PLUGINS_CONFIG["nautobot_chatops"]["tower_uri"]

ANSIBLE_LOGO_PATH = "nautobot_ansible/Ansible_Logo.png"
ANSIBLE_LOGO_ALT = "Ansible Logo"

Origin = namedtuple("Origin", ["name", "slug"])

LOGGER = logging.getLogger("nautobot_chatops.integrations.ansible")


def ansible_logo(dispatcher):
    """Construct an image_element containing the locally hosted Ansible logo."""
    return dispatcher.image_element(dispatcher.static_url(ANSIBLE_LOGO_PATH), alt_text=ANSIBLE_LOGO_ALT)


def prompt_for_job_template(dispatcher, command):
    """Prompt the user to select a job template."""
    tower = Tower(origin=Origin(dispatcher.platform_name, dispatcher.platform_slug))
    data = tower.retrieve_job_templates()
    LOGGER.debug("Data for job template: %s", data)
    job_templates = data
    dispatcher.prompt_from_menu(
        command, "Select job template", [(entry["name"], entry["name"]) for entry in job_templates]
    )
    return False


def ansible(subcommand, **kwargs):
    """Interact with Ansible Tower."""
    return handle_subcommands("ansible", subcommand, **kwargs)


@subcommand_of("ansible")
def get_dashboard(dispatcher):
    """Get Ansible Tower / AWX dashboard status."""
    # TODO: the dashboard/ API endpoint says it's deprecated and will be removed
    tower = Tower(origin=Origin(dispatcher.platform_name, dispatcher.platform_slug))
    data = tower.get_tower_dashboard()

    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(
                "ansible",
                "get-dashboard",
                [],
                "Ansible Tower / AWX dashboard",
                ansible_logo(dispatcher),
            ),
            dispatcher.markdown_block(f"{TOWER_URI}/#/home"),
            dispatcher.markdown_block(
                f"""
- {dispatcher.bold("Total Hosts")}: {data["hosts"]["total"]}
- {dispatcher.bold("Failed Hosts")}: {data["hosts"]["failed"]}
- {dispatcher.bold("Total Inventories")}: {data["inventories"]["total"]}
- {dispatcher.bold("Inventory Sync Failures")}: {data["inventories"]["inventory_failed"]}
- {dispatcher.bold("Total Projects")}: {data["projects"]["total"]}
- {dispatcher.bold("Project Sync Failures")}: {data["projects"]["failed"]}
"""
            ),
        ]
    )

    return True


@subcommand_of("ansible")
def get_inventory(dispatcher, inventory, group):
    """Get Ansible Tower / AWX inventory details."""
    tower = Tower(origin=Origin(dispatcher.platform_name, dispatcher.platform_slug))
    if not inventory:
        data = tower.get_tower_inventories()
        dispatcher.prompt_from_menu(
            "ansible get-inventory",
            "Select inventory",
            [(entry["name"], entry["name"]) for entry in data["results"]],
        )
        return False

    if not group:
        data = tower.get_tower_inventory_groups(inventory=inventory)
        LOGGER.debug("Data result: %s", data)
        dispatcher.prompt_from_menu(
            f"ansible get-inventory '{inventory}'",
            "Select inventory group",
            [(entry["name"], entry["name"]) for entry in data["results"]],
        )
        return False

    inventory_id = tower.get_tower_inventory_id(inventory_name=inventory)
    group_id = tower.get_tower_group_id(inventory_id=inventory_id, group_name=group)
    data = tower.get_tower_inventory_hosts(group_id=group_id)

    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(
                "ansible",
                "get-inventory",
                [("Inventory", inventory), ("Group", group)],
                "Ansible Tower / AWX inventory",
                ansible_logo(dispatcher),
            ),
            dispatcher.markdown_block(
                f"{TOWER_URI}/#/inventories/inventory/{inventory}/groups/edit/{group}/nested_hosts",
            ),
        ]
    )

    reformatted_data = {entry["name"]: json.loads(entry["variables"]) for entry in data["results"]}
    dispatcher.send_snippet(yaml.dump(reformatted_data, width=120, explicit_start=True))
    return True


@subcommand_of("ansible")
def get_jobs(dispatcher, count):
    """Get the status of Ansible Tower / AWX jobs."""
    tower = Tower(origin=Origin(dispatcher.platform_name, dispatcher.platform_slug))
    if not count:
        count = 10
    jobs = tower.get_tower_jobs(count=count)

    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(
                "ansible",
                "get-jobs",
                [("Job Count", str(count))],
                "Ansible Tower / AWX job list",
                ansible_logo(dispatcher),
            ),
            dispatcher.markdown_block(f"{TOWER_URI}/#/jobs?job_search=page_size:{count};order_by:-created"),
        ]
    )

    dispatcher.send_large_table(
        ["Job ID", "Name", "User", "Created", "Finished", "Status"],
        [
            (
                entry["id"],
                entry["name"],
                entry["summary_fields"].get("created_by", {}).get("username", "Scheduler"),
                entry["created"],
                entry["finished"],
                entry["status"],
            )
            for entry in jobs
        ],
    )
    return True


@subcommand_of("ansible")
def get_job_templates(dispatcher):
    """List available Ansible Tower / AWX job templates."""
    tower = Tower(origin=Origin(dispatcher.platform_name, dispatcher.platform_slug))
    job_templates = tower.retrieve_job_templates()
    if not job_templates:
        dispatcher.send_markdown("No job templates found?")
        return False

    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(
                "ansible",
                "get-job-templates",
                [],
                "Ansible Tower / AWX job template list",
                ansible_logo(dispatcher),
            ),
            dispatcher.markdown_block(f"{TOWER_URI}/#/templates"),
        ]
    )

    dispatcher.send_large_table(
        ["Name", "Description", "Project", "Inventory"],
        [
            (
                entry["name"],
                entry["description"],
                entry["summary_fields"]["project"]["name"],
                entry["summary_fields"].get("inventory", {}).get("name", "Ask Inventory on Launch"),
            )
            for entry in job_templates
        ],
    )
    return True


@subcommand_of("ansible")
def get_projects(dispatcher):
    """List available Ansible Tower / AWX projects."""
    tower = Tower(origin=Origin(dispatcher.platform_name, dispatcher.platform_slug))

    projects = tower.get_tower_projects()

    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(
                "ansible",
                "get-projects",
                [],
                "Ansible Tower / AWX project list",
                ansible_logo(dispatcher),
            ),
            dispatcher.markdown_block(f"{TOWER_URI}/#/projects"),
        ]
    )

    dispatcher.send_large_table(
        ["Name", "Description", "SCM", "Branch"],
        [(entry["name"], entry["description"], entry["scm_url"], entry["scm_branch"]) for entry in projects],
    )

    return True


@subcommand_of("ansible")
def run_job_template(dispatcher, template_name):
    """Execute an Ansible Tower / AWX job template."""
    tower = Tower(origin=Origin(dispatcher.platform_name, dispatcher.platform_slug))

    if not template_name:
        return prompt_for_job_template(dispatcher, "ansible run-job-template")

    data = tower.get_tower_template(template_name=template_name)
    template = data["results"][0] if data["results"] else {}
    if not template:
        dispatcher.send_error("No such job template found")
        return prompt_for_job_template(dispatcher, "ansible run-job-template")

    # TODO: parse any additional args into extra_vars, perhaps as "keyword=value" pairs?

    response = tower.run_tower_template(dispatcher=dispatcher, template_name=template_name)
    job_id = response["id"]
    dispatcher.send_markdown(
        f"Hey {dispatcher.user_mention()}, Job template {template_name} has been submitted, job ID is {job_id}"
    )
    dispatcher.send_markdown(f"{TOWER_URI}/#/jobs/playbook/{job_id}")
    return True
