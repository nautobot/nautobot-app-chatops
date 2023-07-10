# Installing the App in Nautobot

There are four main phases to enable Nautobot ChatOps:

1. Configure the specific chat platform
2. Install the plugin
3. Configure `nautobot_config.py` to support nautobot-chatops
4. Grant access to the chatbot in the Nautobot Web UI

## Prerequisites

- The plugin is compatible with Nautobot 1.2.0 and higher.
- Databases supported: PostgreSQL, MySQL
- Publicly accessible URL for Nautobot or ability/permission to use ngrok to get a publicly accessible URL for Nautobot
- `sudo` access on the Nautobot server
- Administrative access within the Nautobot Web UI

!!! note
    Some chat platforms, such as Slack, require a signed certificate from a trusted provider on the Nautobot server in order
    to allow the application platform to communicate with the Nautobot server

## Access Requirements

### [Setup for Slack](slack_setup.md)

### [Setup for Microsoft Teams](microsoft_teams_setup.md)

### [Setup for WebEx](webex_setup.md)

### [Setup for Mattermost](mattermost_setup.md)

## Install Guide

!!! note
    Plugins can be installed manually or using Python's `pip`. See the [nautobot documentation](https://nautobot.readthedocs.io/en/latest/plugins/#install-the-package) for more details. The pip package name for this plugin is [`nautobot_chatops`](https://pypi.org/project/nautobot_chatops/).

!!! warning
    You should follow the [Nautobot Plugin Installation Instructions](https://nautobot.readthedocs.io/en/stable/plugins/#installing-plugins) for the full and up-to-date list of instructions.

The plugin is available as a Python package via PyPI and can be installed with `pip`:

```shell
pip install nautobot-chatops
```

To ensure Nautobot Plugin ChatOps is automatically re-installed during future upgrades, create a file named `local_requirements.txt` (if not already existing) in the Nautobot root directory (alongside `requirements.txt`) and list the `nautobot-chatops` package as the Nautobot user:

```no-highlight
echo nautobot-chatops >> local_requirements.txt
```

Once installed, the plugin needs to be enabled in your Nautobot configuration. The following block of code below shows the additional configuration required to be added to your `nautobot_config.py` file:

- Append `"nautobot_chatops"` to the `PLUGINS` list.
- Append the `"nautobot_chatops"` dictionary to the `PLUGINS_CONFIG` dictionary and override any defaults.

```python
# In your nautobot_config.py
PLUGINS = ["nautobot_chatops"]

# PLUGINS_CONFIG = {
#   "nautobot_chatops": {
#     ADD YOUR SETTINGS HERE
#   }
# }
```

### ⚠️ Important Warning: Conflicting Applications

If you are upgrading to the latest version of the `nautobot-chatops` app, please be aware that it now includes the functionality previously provided by the following apps:

- 'nautobot_plugin_chatops_ansible'
- 'nautobot_plugin_chatops_ipfabric'
- `nautobot_plugin_chatops_aci`
- `nautobot_plugin_chatops_ansible`
- `nautobot_plugin_chatops_grafana`
- `nautobot_plugin_chatops_meraki`
- `nautobot_plugin_chatops_panorama`

- `nautobot_plugin_chatops_arista_cloudvision`

Therefore, you should **not** have these apps installed and enabled at the same time as this can lead to conflicts and unexpected behavior.

In order to prevent conflicts when upgrading `nautobot-chatops`, it is necessary to perform the following steps:

- Remove conflicting applications from the `PLUGINS` section in your Nautobot configuration. This should be done before enabling the latest version of `nautobot-chatops`.
- Relocate the configuration for conflicting apps to the `PLUGIN_CONFIG["nautobot_chatops"]` section of your Nautobot configuration. See `development/nautobot_config.py` for an example of how this should look.
- Remove conflicting applications from your project's requirements.

By following these steps, you can avoid common issues encountered when upgrading `nautobot-chatops`. Please remember to backup your data and thoroughly test your configuration after performing these changes.

Please note: If you fail to remove conflicting apps from `PLUGINS`, the `nautobot-chatops` app will raise an exception during startup to prevent potential conflicts.

## App Configuration

The plugin behavior can be controlled with the following list of settings:

| Configuration Setting        | Description | Mandatory? | Default |
| ---------------------------- | ----------- | ---------- | ------- |
| `delete_input_on_submission` | After prompting the user for additional inputs, delete the input prompt from the chat history | No | `False` |
| `restrict_help` | Only show Help prompt for users based on their Access Grants | No | `False` |

## Grant Access to the Chatbot

{%
    include-markdown '../../models/accessgrant.md'
    start='<!--access-grant-->'
    heading-offset=1
%}

## Test Your Chatbot

Now test your chatbot within your specific chat application.
