"""Worker functions implementing Nautobot "nso" command and subcommands."""

from django.core.exceptions import ObjectDoesNotExist
from nautobot.core.settings_funcs import is_truthy
from nautobot.dcim.models import Device

from nautobot_chatops.choices import CommandStatusChoices
from nautobot_chatops.integrations.nso.nso import REQUEST_TIMEOUT_SEC, SLASH_COMMAND, NSOClient
from nautobot_chatops.workers import handle_subcommands, subcommand_of


def nso_logo(dispatcher):
    """Construct an image_element containing the locally hosted Cisco NSO logo."""
    return dispatcher.image_element(dispatcher.static_url("nso/nso-logo.png"), alt_text="Cisco NSO Logo")


def nso(subcommand, **kwargs):
    """Interact with nso plugin."""
    return handle_subcommands("nso", subcommand, **kwargs)


@subcommand_of("nso")
def ping(dispatcher, device_name=None):
    """Ping a device."""
    if not device_name:
        devices = Device.objects.all()
        choices = [(device.name, device.name) for device in devices]
        dispatcher.prompt_from_menu("nso ping", "Select a device.", choices)
        return False

    nso_client = NSOClient()
    ping_result = nso_client.ping(device_name)

    if "100% packet loss" in ping_result:
        dispatcher.send_markdown(f"❌ NSO Ping of Device {device_name} failed.")
        return CommandStatusChoices.STATUS_FAILED
    if "Device does not exist in NSO" in ping_result:
        dispatcher.send_markdown(f"❌ Device {device_name} doesn't exist in NSO.")
        return CommandStatusChoices.STATUS_FAILED
    dispatcher.send_markdown(f"✅ NSO Ping of Device {device_name} was successful.")
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nso")
def connect(dispatcher, device_name=None):
    """Get connect status of device."""
    if not device_name:
        devices = Device.objects.all()
        choices = [(device.name, device.name) for device in devices]
        dispatcher.prompt_from_menu("nso connect", "Select a device.", choices)
        return False

    nso_client = NSOClient()
    ping_result = nso_client.connect(device_name)

    if not ping_result:
        dispatcher.send_markdown(f"❌ NSO Connection to Device {device_name} failed.")
        return CommandStatusChoices.STATUS_FAILED
    if "Device does not exist in NSO" in str(ping_result):
        dispatcher.send_markdown(f"❌ Device {device_name} does not exist in NSO.")
        return CommandStatusChoices.STATUS_FAILED
    dispatcher.send_markdown(f"✅ NSO Connection to Device {device_name} was successful.")
    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("nso")
def check_sync(dispatcher, device_name=None, compare_config=None):
    """Get sync status of device."""
    nso_client = NSOClient()

    if not device_name:
        devices = Device.objects.all()
        choices = [(device.name, device.name) for device in devices]
        choices.insert(0, ("all", "all"))

        dispatcher.prompt_from_menu("nso check-sync", "Select a device.", choices)
        return False

    if device_name == "all":
        dispatcher.send_markdown(f"Stand by {dispatcher.user_mention()}, I'm getting that sync status report for you.")
        sync_data = nso_client.sync_status_all()

        dispatcher.send_blocks(
            [
                *dispatcher.command_response_header(
                    "nso", "check_sync", [("Device Name", device_name)], "information", nso_logo(dispatcher)
                )
            ]
        )

        header = ["Device Name", "NSO Sync Status"]
        rows = [(item["device"], item["result"]) for item in sync_data]

        dispatcher.send_large_table(header, rows)
        return CommandStatusChoices.STATUS_SUCCEEDED

    # If user chose to compare config on the device and NSO, return compare_config
    if device_name and compare_config:
        if is_truthy(compare_config):
            dispatcher.send_markdown(f"Checking configuration of device {device_name}.")
            compared_config = nso_client.compare_config(device_name)
            if len(compared_config) < 1000:
                dispatcher.send_markdown(f"```{compared_config}\n```")
            else:
                dispatcher.send_snippet(compared_config)
        else:
            dispatcher.send_warning("Device configuration will not be checked.")
        return CommandStatusChoices.STATUS_SUCCEEDED

    # Check sync status for chosen device
    sync_status = nso_client.sync_status(device_name)

    if sync_status == "in-sync":
        dispatcher.send_markdown(f"✅ Device {device_name} configuration is in sync with NSO.")
        return CommandStatusChoices.STATUS_SUCCEEDED

    if sync_status == "out-of-sync":
        dispatcher.send_markdown(f"❌ Device {device_name} configuration is out of sync with NSO.")
        dispatcher.prompt_from_menu(
            f"nso check-sync {device_name}", "Would you like to compare the config?", [("Yes", "Yes"), ("No", "No")]
        )
        return False

    dispatcher.send_markdown(f"❌ Device {device_name} NSO status: {sync_status}")

    return CommandStatusChoices.STATUS_SUCCEEDED


def _run_command_helper(dispatcher, device_name, device_commands, sub_command):
    """Helper function for run-commands and run-command-set NSO commands."""
    # Create a dialog prompt for any missing parameters in the command.
    dialog_list = []

    all_choices = [(device.name, device.name) for device in Device.objects.all()]
    if not device_name:
        # Handle Slack 100 items menu limit
        if dispatcher.platform_slug == "slack":
            all_choices = dispatcher.get_prompt_from_menu_choices(choices=all_choices)

        dialog_list.append(
            {
                "type": "select",
                "label": "Select target device",
                "default": ("", "-----"),
                "choices": all_choices,
            }
        )
    elif device_name.startswith("menu_offset-"):
        dialog_list.append(
            {
                "type": "select",
                "label": "Select target device",
                "default": ("", "-----"),
                "choices": dispatcher.get_prompt_from_menu_choices(
                    choices=all_choices, offset=int(device_name.replace("menu_offset-", ""))
                ),
            }
        )
    else:
        try:
            nautobot_device = Device.objects.get(name=device_name)
        except ObjectDoesNotExist:
            dispatcher.send_error(f"{device_name} does not exist in Nautobot!")
            return False
        dialog_list.append(
            {
                "type": "select",
                "label": "Select target device",
                "default": (nautobot_device.name, nautobot_device.name),
                "choices": all_choices,
            }
        )

    if not device_commands:
        if sub_command == "run-commands":
            dialog_list.append({"type": "text", "label": "Comma separated device commands.", "default": ""})
        if sub_command == "run-command-set":
            cmd_choices = [
                ("display ip addresses and routing table", "show ip interface brief, show ip route"),
                ("display routing table", "show ip route"),
                ("display OS version", "show version"),
                ("display device neighbors", "show cdp neighbor"),
                ("display mac table", "show mac address-table"),
                ("list interfaces", "show interface brief"),
                ("display bgp neighbors", "show ip bgp sum"),
            ]
            dialog_list.append(
                {"type": "select", "label": "Select command set", "choices": cmd_choices, "default": (None, None)}
            )

        dispatcher.multi_input_dialog(
            command=SLASH_COMMAND,
            sub_command=sub_command,
            dialog_title="Run raw commands",
            dialog_list=dialog_list,
        )
        return False

    # Split and strip device_commands, exclude empty results
    stripped_device_commands = [cmd.strip() for cmd in device_commands.split(",") if cmd.strip() != ""]

    # Send a Markdown-formatted text message.
    dispatcher.send_markdown(
        f"Standby {dispatcher.user_mention()} while I get that info from Cisco NSO.\n"
        f"Please be patient as this can take up to {REQUEST_TIMEOUT_SEC} seconds.",
        ephemeral=True,
    )

    # Send a "typing" indicator to show that work is in progress.
    dispatcher.send_busy_indicator()

    nso_client = NSOClient()

    # Response we're going to send to the chat client. This will get built as commands
    # are run through NSO.
    response = ""
    for cmd in stripped_device_commands:
        # Pull data from NSO using the live_status operand.
        data = nso_client.live_status(device_name, cmd)
        response += f"\n! {'-' * 30}\n! Command '{cmd}' results:\n! {'-' * 30}\n{data}"

    dispatcher.send_blocks(
        [
            *dispatcher.command_response_header(
                SLASH_COMMAND,
                f'{sub_command} {device_name} "{device_commands}"',
                [],
                "Cisco NSO Live Status",
                nso_logo(dispatcher),
            )
        ]
    )

    # If it's a short response, we can add it as a code-block. If it's a bit larger, we will need to stream
    # it as a file attachment.
    if len(response) < 1000:
        dispatcher.send_markdown(f"```{response}\n```")
        return True

    dispatcher.send_snippet(response)
    return True


@subcommand_of("nso")
def run_command_set(dispatcher, device_name, device_commands):
    """Select a predefined command set to run on a device using Cisco NSO."""
    return _run_command_helper(dispatcher, device_name, device_commands, "run-command-set")
