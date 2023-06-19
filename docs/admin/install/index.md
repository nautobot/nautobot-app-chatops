# Nautobot ChatOps Installation Guide

This guide describes the step-by-step process of enabling Nautobot ChatOps. The process involves the following steps:

1. [Configure the specific chat platform.](#chat-platforms-configuration)
2. [Install the App.](#installation-guide)
3. [Configure the App.](#configuration-guide)
4. [Grant access to the chatbot in the Nautobot Web UI.](#granting-access-to-the-chat-platform)
5. [Test the installation.](#test-your-chatbot)
6. [Configure integrations.](#integrations-configuration)

{%
    include-markdown '../../glossary.md'
    heading-offset=1
%}

## Prerequisites

Before starting the installation, please ensure the following:

- Nautobot 1.4.0 or higher is installed.
- Nautobot is accessible from your chat platform using an HTTPs URL.
  - Some chat platforms require **SSL certificate verification** when communicating with the Nautobot server.
  - For development purposes, it's possible to rely on the HTTP protocol only.
- You have `sudo` access on the Nautobot server.
- You have administrative access within the Nautobot Web UI.

### Potential Apps Conflicts

!!! WARNING
    If you are upgrading to the latest version of the `nautobot-chatops` App, please be aware that it now incorporates the features previously provided by individual apps.

Conflicting Apps list:

- `nautobot_plugin_chatops_aci`
- `nautobot_plugin_chatops_ansible`
- `nautobot_plugin_chatops_meraki`
- `nautobot_plugin_chatops_panorama`

Each [integration set up guide](#integrations-configuration) contain chapter with upgrade instructions.

Therefore, you should **not** have these apps installed and enabled at the same time as this can lead to conflicts and unexpected behavior.

In order to prevent conflicts when upgrading `nautobot-chatops`, it is necessary to perform the following steps:

- Remove conflicting applications from the `PLUGINS` section in your Nautobot configuration. This should be done before enabling the latest version of `nautobot-chatops`.
- Relocate the configuration for conflicting apps to the `PLUGIN_CONFIG["nautobot_chatops"]` section of your Nautobot configuration. See `development/nautobot_config.py` for an example of how this should look.
- Remove conflicting applications from your project's requirements.

By following these steps, you can avoid common issues encountered when upgrading `nautobot-chatops`. Please remember to back up your data and thoroughly test your configuration after performing these changes.

!!! NOTE
    If you fail to remove conflicting apps from `PLUGINS`, the `nautobot-chatops` app will raise an exception during startup to prevent potential conflicts.

## Chat Platforms Configuration

There are multiple chat platforms supported by `nautobot-chatops` package.

Follow the setup instructions based on your chosen chat platform:

- [Set up Mattermost](./mattermost_setup.md)
- [Set up Microsoft Teams](./microsoft_teams_setup.md)
- [Set up Slack](./slack_setup.md)
- [Set up Cisco Webex](./webex_setup.md)

## Installation Guide

!!! NOTE
    The App can be installed manually or via Python's `pip`. Visit the [Nautobot documentation](https://nautobot.readthedocs.io/en/latest/plugins/#install-the-package) for comprehensive information. The pip package for this App is [`nautobot-chatops`](https://pypi.org/project/nautobot-chatops/).

!!! WARNING
    Adhere to the [Nautobot App Installation Instructions](https://nautobot.readthedocs.io/en/stable/plugins/#installing-plugins) for the complete and most recent instructions.

The App is available as a Python package on PyPI and can be installed with `pip`:

```shell
pip install nautobot-chatops
```

If you want to install specific integration, remember to add it as an extra dependency:

```shell
pip install nautobot-chatops[ansible]
```

To ensure the Nautobot ChatOps App is automatically re-installed during future upgrades, add `nautobot-chatops` to `local_requirements.txt` (create if not existing) in the Nautobot root directory, right next to `requirements.txt`:

```no-highlight
echo nautobot-chatops >> local_requirements.txt
```

After installation, you need to enable the App in your Nautobot configuration. Update your `nautobot_config.py` file with the code block below:

- Include `"nautobot_chatops"` in the `PLUGINS` list.
- Append the `"nautobot_chatops"` dictionary to the `PLUGINS_CONFIG` dictionary and override the defaults, if any.

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

The behavior of the App can be adjusted using the following settings:

| Configuration Setting | Description | Mandatory? | Default |
| - | - | - | - |
| `delete_input_on_submission` | After asking the user for more inputs, the input prompt will be removed from the chat history | No | `False` |
| `restrict_help` | Show Help prompt only to users based on their Access Grants | No | `False` |
| `session_cache_timeout` | Session cache control | No | `86400` |
| `send_all_messages_private` | Only the person interacting with the bot will see the responses | No | `False` |

## Granting Access to the Chat Platform

{%
    include-markdown '../../models/accessgrant.md'
    start='<!--access-grant-->'
    heading-offset=1
%}

## Test Your Chatbot

Finally, verify the functionality of your chatbot within your chosen chat application using e.g. `/nautobot get-devices` chat command.

## Integrations Configuration

There are multiple integrations already included directly in `nautobot-chatops` package. Each integration requires extra dependencies defined in `pyproject.toml` file. See [install guide](#installation-guide) for instruction, how to install extra dependencies.

To set up an integration follow the specific guide:

- [Set up Cisco ACI](./aci_setup.md)
- [Set up AWX / Ansible Tower](./ansible_setup.md)
- [Set up Cisco Meraki](./meraki_setup.md)
- [Set up Palo Alto Networks Panorama](./panorama_setup.md)
