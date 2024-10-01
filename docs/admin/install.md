# Nautobot ChatOps Installation Guide

This guide outlines the process of enabling Nautobot ChatOps, which includes:

- [Nautobot ChatOps Installation Guide](#nautobot-chatops-installation-guide)
  - [Prerequisites](#prerequisites)
    - [Potential Apps Conflicts](#potential-apps-conflicts)
  - [Chat Platforms Configuration](#chat-platforms-configuration)
  - [Installation Guide](#installation-guide)
  - [Configuration Guide](#configuration-guide)
  - [Granting Access to the Chat Platform](#granting-access-to-the-chat-platform)
  - [Link Nautobot Account](#link-nautobot-account)
  - [Test Your Chatbot](#test-your-chatbot)
  - [Integrations Configuration](#integrations-configuration)

{% include-markdown '../glossary.md' heading-offset=1 %}

## Prerequisites

Ensure the following before beginning the installation:

- Nautobot 1.5.4 or higher is installed.
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

- [Mattermost](./platforms/mattermost.md)
- [Microsoft Teams](./platforms/microsoft_teams.md)
- [Slack](./platforms/slack.md)
- [Cisco Webex](./platforms/webex.md)

## Installation Guide

!!! note
    Install the App manually or via Python's `pip`. For detailed information, visit the [Nautobot documentation](https://nautobot.readthedocs.io/en/latest/plugins/#install-the-package). The pip package for this App is [`nautobot-chatops`](https://pypi.org/project/nautobot-chatops/).

!!! warning
    Follow the [Nautobot App Installation Instructions](https://nautobot.readthedocs.io/en/stable/plugins/#installing-plugins) for complete and most recent guidelines.

## Install Guide

!!! note
    Apps can be installed from the [Python Package Index](https://pypi.org/) or locally. See the [Nautobot documentation](https://docs.nautobot.com/projects/core/en/stable/user-guide/administration/installation/app-install/) for more details. The pip package name for this app is [`nautobot-chatops`](https://pypi.org/project/nautobot-chatops/).

The app is available as a Python package via PyPI and can be installed with `pip`:

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

+++ 3.0.0
    Some configuration settings have now been added to the Nautobot Admin Config page. See [Nautobot Admin](https://docs.nautobot.com/projects/core/en/stable/configuration/optional-settings/?h=administr#administratively-configurable-settings)

## Configuration Guide

Adjust the App's behavior with the following settings:

| Configuration Setting | Description | Mandatory? | Default | Available on Admin Config |
| - | - | - | - | - |
| `delete_input_on_submission` | Removes the input prompt from the chat history after user input | No | `False` | No |
| `restrict_help` | Shows Help prompt only to users based on their Access Grants | No | `False` | No |
| `send_all_messages_private` | Ensures only the person interacting with the bot sees the responses | No | `False` | No |
| `fallback_chatops_user` | Nautobot User for Chat Commands to use if the user has not linked their account | Yes | `chatbot` | Yes |
| `session_cache_timeout` | Controls session cache | No | `86400` | No |

## Granting Access to the Chat Platform

{%
    include-markdown '../models/accessgrant.md'
    start='<!--access-grant-->'
    heading-offset=1
%}

## Link Nautobot Account

{%
    include-markdown '../models/chatopsaccountlink.md'
    start='<!--account-link-->'
    heading-offset=1
%}

## Test Your Chatbot

Finally, test your chatbot's functionality within your chosen chat application, using a command like `/nautobot get-devices`.

## Integrations Configuration

The `nautobot-chatops` package includes multiple integrations. Each requires extra dependencies defined in `pyproject.toml`. See the [installation guide](#installation-guide) for instructions on installing these dependencies.

Set up integrations using the specific guides:

- [Cisco ACI](./integrations/aci.md)
- [AWX / Ansible Tower](./integrations/ansible.md)
- [Arista CloudVision](./integrations/aristacv.md)
- [Grafana](./integrations/grafana.md)
- [IPFabric](./integrations/ipfabric.md)
- [Cisco Meraki](./integrations/meraki.md)
- [Cisco NSO](./integrations/nso.md)
- [Palo Alto Panorama](./integrations/panorama.md)
