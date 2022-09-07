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

To ensure Nautobot Plugin ChatOps is automatically re-installed during future upgrades, create a file named `local_requirements.txt` (if not already existing) in the Nautobot root directory (alongside `requirements.txt`) and list the `nautobot-chatops` package:

```no-highlight
# echo nautobot-chatops >> local_requirements.txt
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

## App Configuration

The plugin behavior can be controlled with the following list of settings:

| Configuration Setting        | Description | Mandatory? | Default |
| ---------------------------- | ----------- | ---------- | ------- |
| `delete_input_on_submission` | After prompting the user for additional inputs, delete the input prompt from the chat history | No | `False` |

## Grant Access to the Chatbot

Nautobot provides an HTTP endpoint(s) for each supported chat platform.
Although these endpoints do implement authentication to prevent arbitrary HTTP requests from triggering bot actions,
they can accept and act on any validly-formed request from the chat platform, which could originate from any
organization, team, channel, or user who has access to the chat system.

For most realistic deployments, open and unrestricted access to the bot from any chat account is undesirable.
Therefore, in this version, access to the chatbot defaults to "deny all" when initially installed, but varying scopes
(per organization, per channel, per user) and degrees (all commands, all subcommands of a single command,
single subcommand of a single command) of access can be granted through Nautobot.

The access grants are maintained in Nautobot's database for persistence, and are change-logged like other Nautobot records.

![access grants](../../images/nb_plugins_grants.png)

Note that access grants are based on the chat platform's internal ID values for users, channels, and organizations;
although you can and should attach a user-friendly name to each access grant for reference, it is the ID value that
is actually enforced by Nautobot. On some platforms and for some access scopes, the Nautobot UI "Look up Value from Name"
button can be used to auto-discover the ID value corresponding to a given name; if this fails, you can always attempt
to send a request to Nautobot from the desired user/channel/organization and retrieve the ID value from the resulting
error message to use to define a new access grant.

The specific access grants you will want to define will depend on your operational requirements,
but some examples are provided below to help you get started.

### Example: Unrestricted Access Within a Single Organization

In the simplest realistic configuration example, access to all chatbot commands is granted for all users and
all channels in a single organization scope.

| Command | Subcommand | Grant type   | Name   | Value       |
| ------- | ---------- | ------------ | ------ | ----------- |
| `*`     | `*`        | organization | my-org | `T202B88NN` |
| `*`     | `*`        | channel      | any    | `*`         |
| `*`     | `*`        | user         | any    | `*`         |

### Example: Split Command Access to Different Channels

In this example, Nautobot is providing two separate command groupings, each of which is intended for use by a
different team within the organization. Each team has a dedicated channel on the chat platform, to which access is
already controlled by other means, so we can allow all users within a given channel access.

| Command   | Subcommand | Grant type   | Name    | Value       |
| --------- | ---------- | ------------ | ------- | ----------- |
| `*`       | `*`        | organization | my-org  | `T202B88NN` |
| `support` | `*`        | channel      | support | `C2020H455` |
| `devops`  | `*`        | channel      | devops  | `C3030I566` |
| `*`       | `*`        | user         | any     | `*`         |

### Example: Restrict Specific Command and Subcommand to Specific Users in a Specific Channel

In this example, Nautobot has a potentially-destructive subcommand that should only be used by a handful of admin users.
Other subcommands under this subcommand can be used by anyone in the devops channel.
Other commands are harmless fun and can be used by any user in the organization in any channel.

| Command   | Subcommand | Grant type   | Name    | Value       |
| --------- | ---------- | ------------ | ------- | ----------- |
| `*`       | `*`        | organization | my-org  | `T202B88NN` |
| `jokes`   | `*`        | channel      | any     | `*`         |
| `jokes`   | `*`        | user         | any     | `*`         |
| `network` | `*`        | channel      | devops  | `C3030I566` |
| `network` | `history`  | user         | any     | `*`         |
| `network` | `redeploy` | user         | admin1  | `U2049K991` |
| `network` | `redeploy` | user         | admin2  | `U2039K725` |
| `network` | `redeploy` | user         | admin3  | `U7924K784` |
| `network` | `status`   | user         | any     | `*`         |
| `weather` | `*`        | channel      | any     | `*`         |
| `weather` | `*`        | user         | any     | `*`         |

## Test Your Chatbot

Now test your chatbot within your specific chat application.
