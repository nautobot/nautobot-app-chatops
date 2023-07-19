# Nautobot ChatOps Installation Guide

This guide outlines the process of enabling Nautobot ChatOps, which includes:

1. [Configuring the specific chat platform](#chat-platforms-configuration)
2. [Installing the App](#installation-guide)
3. [Configuring the App](#configuration-guide)
4. [Granting chatbot access in the Nautobot Web UI](#granting-access-to-the-chat-platform)
5. [Testing the installation](#test-your-chatbot)
6. [Configuring integrations](#integrations-configuration)

{% include-markdown '../../glossary.md' heading-offset=1 %}

## Prerequisites

Ensure the following before beginning the installation:

- Nautobot 1.4.0 or higher is installed.
- Your chat platform can access Nautobot via an HTTPS URL.
    - Some chat platforms require **SSL certificate verification** to communicate with the Nautobot server.
    - For development, you may use HTTP.
- You have `sudo` access on the Nautobot server.
- You have administrative access within the Nautobot Web UI.

### Potential Apps Conflicts

!!! warning
    If upgrading from `1.x` version to `2.x` version of `nautobot-chatops` App, note that it now incorporates features previously provided by individual apps.

Conflicting Apps list:

- `nautobot_plugin_chatops_aci`
- `nautobot_plugin_chatops_ansible`
- `nautobot_plugin_chatops_arista_cloudvision`
- `nautobot_plugin_chatops_ipfabric`
- `nautobot_plugin_chatops_grafana`
- `nautobot_plugin_chatops_meraki`
- `nautobot_plugin_chatops_panorama`

To prevent conflicts during `nautobot-chatops` upgrade:

- Remove conflicting applications from the `PLUGINS` section in your Nautobot configuration before enabling the latest `nautobot-chatops` version.
- Transfer the configuration for conflicting apps to the `PLUGIN_CONFIG["nautobot_chatops"]` section of your Nautobot configuration. See `development/nautobot_config.py` for an example. Each [integration set up guide](#integrations-configuration) contains a chapter with upgrade instructions.
- Remove conflicting applications from your project's requirements.

These steps will help prevent issues during `nautobot-chatops` upgrades. Always back up your data and thoroughly test your configuration after these changes.

!!! warning
    If conflicting Apps remain in `PLUGINS`, the `nautobot-chatops` App will raise an exception during startup to prevent potential conflicts.

## Chat Platforms Configuration

The `nautobot-chatops` package supports multiple chat platforms.

Set up your chosen chat platform:

- [Mattermost](./mattermost_setup.md)
- [Microsoft Teams](./microsoft_teams_setup.md)
- [Slack](./slack_setup.md)
- [Cisco Webex](./webex_setup.md)

## Installation Guide

!!! note
    Install the App manually or via Python's `pip`. For detailed information, visit the [Nautobot documentation](https://nautobot.readthedocs.io/en/latest/plugins/#install-the-package). The pip package for this App is [`nautobot-chatops`](https://pypi.org/project/nautobot-chatops/).

!!! warning
    Follow the [Nautobot App Installation Instructions](https://nautobot.readthedocs.io/en/stable/plugins/#installing-plugins) for complete and most recent guidelines.

The App is a Python package available on PyPI, installable with `pip`:

```shell
pip install nautobot-chatops
```

To use specific integrations, add them as extra dependencies:

```shell
pip install nautobot-chatops[ansible]
```

To auto-install Nautobot ChatOps during future upgrades, add `nautobot-chatops` to `local_requirements.txt` (create if not

 present) in the Nautobot root directory, adjacent to `requirements.txt`:

```no-highlight
echo nautobot-chatops >> local_requirements.txt
```

After installation, enable the App in your Nautobot configuration by updating your `nautobot_config.py` file:

- Include `"nautobot_chatops"` in the `PLUGINS` list.
- Add the `"nautobot_chatops"` dictionary to `PLUGINS_CONFIG` and override defaults if necessary.

```python
# In your nautobot_config.py
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
        # ADD YOUR SETTINGS HERE
    }
}
```

## Configuration Guide

Adjust the App's behavior with the following settings:

| Configuration Setting | Description | Mandatory? | Default |
| - | - | - | - |
| `delete_input_on_submission` | Removes the input prompt from the chat history after user input | No | `False` |
| `restrict_help` | Shows Help prompt only to users based on their Access Grants | No | `False` |
| `send_all_messages_private` | Ensures only the person interacting with the bot sees the responses | No | `False` |
| `session_cache_timeout` | Controls session cache | No | `86400` |

## Granting Access to the Chat Platform

{%
    include-markdown '../../models/accessgrant.md'
    start='<!--access-grant-->'
    heading-offset=1
%}

## Test Your Chatbot

Finally, test your chatbot's functionality within your chosen chat application, using a command like `/nautobot get-devices`.

## Integrations Configuration

The `nautobot-chatops` package includes multiple integrations. Each requires extra dependencies defined in `pyproject.toml`. See the [installation guide](#installation-guide) for instructions on installing these dependencies.

Set up integrations using the specific guides:

- [Cisco ACI](./aci_setup.md)
- [AWX / Ansible Tower](./ansible_setup.md)
- [Arista CloudVision](./aristacv_setup.md)
- [Grafana](./grafana_setup.md)
- [IPFabric](./ipfabric_setup.md)
- [Cisco Meraki](./meraki_setup.md)
- [Palo Alto Panorama](./panorama_setup.md)
