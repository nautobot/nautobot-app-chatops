# Installing Nautobot Chatops

## Installation

The plugin is available as a Python package in PyPI and can be installed with `pip3` after logging in with the `nautobot` user account.

```shell
sudo -iu nautobot
pip3 install nautobot-chatops
```

> The plugin is compatible with Nautobot 1.0.0beta1 and higher

Once installed, the plugin needs to be enabled in your `nautobot_config.py`

```python
# In your nautobot_config.py
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
         #     ADD YOUR SETTINGS HERE
    }
}
```

Nautobot supports `Slack`, `MS Teams` and `Webex Teams` as backends but by default all of them are disabled. You need to explicitly enable the chat platform(s) that you want to use in the `PLUGINS_CONFIG` with one or more of `enable_slack`, `enable_ms_teams` or `enable_webex_teams`.

The plugin behavior can be controlled with the following list of general settings:

| Configuration Setting        | Description | Mandatory? | Default |
| ---------------------------- | ----------- | ---------- | ------- |
| `delete_input_on_submission` | After prompting the user for additional inputs, delete the input prompt from the chat history | No | `False` |

## General setup

Install this plugin into Nautobot and enable it in `nautobot_config.py` under `PLUGINS`, as described in `README.md`.
There are no general mandatory settings in `PLUGINS_CONFIG`, but see below for platform-specific setup requirements.
If you're running Nautobot locally on a laptop or similar, you may need to install and run `ngrok` to provide a
publicly accessible HTTP endpoint for the chat platform(s) to connect to.

## Platform-specific setup

### [Setup for Slack](./slack_setup.md)

### [Setup for Microsoft Teams](./microsoft_teams_setup.md)

### [Setup for WebEx Teams](./webex_teams_setup.md)

### [Setup for Mattermost](./mattermost_setup.md)

## Add Command Token to database

Nautobot provides an HTTP endpoint(s) for each supported chat platform.
These endpoints implement authentication to prevent arbitrary HTTP requests from being accepted.
Some platforms this `signing_secret` is valid for all commands, other platforms, such as Mattermost,
create a seperate `token` for every slash command.  Keeping the records for Mattermost tokens in the
`.creds.env` file would not be sustainable.  

To solve this issue, the plugin has the option to store Command Tokens to the Nautobot Database.
In Nautobot, open Nautobot and go to the Plugins and select Command Tokens. Below is an example to
get you started.

### Example: Adding tokens for Mattermost

Here is an example that supports Mattermost.

| Platform    | Comment   | Token            |
| ----------- | ---------- | ---------------- |
| Mattermost  | `nautobot`   | `x0xb5hj5ga5tge` |
| Mattermost  | `clear`    | `x7g7ag9ohkafbe` |

**Note:** The Comment field is optional and used to help the user when there are multiple tokens.

## Grant access to the chatbot

Nautobot provides an HTTP endpoint(s) for each supported chat platform.
Although these endpoints do implement authentication to prevent arbitrary HTTP requests from triggering bot actions,
they can accept and act on any validly-formed request from the chat platform, which could originate from any
organization, team, channel, or user who has access to the chat system.

For most realistic deployments, open and unrestricted access to the bot from any chat account is undesirable.
Therefore, in this version, access to the chatbot defaults to "deny all" when initially installed, but varying scopes
(per organization, per channel, per user) and degrees (all commands, all subcommands of a single command,
single subcommand of a single command) of access can be granted through Nautobot.

The access grants are maintained in Nautobot's database for persistence, and are change-logged like other Nautobot records.

![access grants](../images/nb_plugins_grants.png)

Note that access grants are based on the chat platform's internal ID values for users, channels, and organizations;
although you can and should attach a user-friendly name to each access grant for reference, it is the ID value that
is actually enforced by Nautobot. On some platforms and for some access scopes, the Nautobot UI "Look up Value from Name"
button can be used to auto-discover the ID value corresponding to a given name; if this fails, you can always attempt
to send a request to Nautobot from the desired user/channel/organization and retrieve the ID value from the resulting
error message to use to define a new access grant.

The specific access grants you will want to define will depend on your operational requirements,
but some examples are provided below to help you get started.

### Example: unrestricted access within a single organization

In the simplest realistic configuration example, access to all chatbot commands is granted for all users and
all channels in a single organization scope.

| Command | Subcommand | Grant type   | Name   | Value       |
| ------- | ---------- | ------------ | ------ | ----------- |
| `*`     | `*`        | organization | my-org | `T202B88NN` |
| `*`     | `*`        | channel      | any    | `*`         |
| `*`     | `*`        | user         | any    | `*`         |

### Example: split command access to different channels

In this example, Nautobot is providing two separate command groupings, each of which is intended for use by a
different team within the organization. Each team has a dedicated channel on the chat platform, to which access is
already controlled by other means, so we can allow all users within a given channel access.

| Command   | Subcommand | Grant type   | Name    | Value       |
| --------- | ---------- | ------------ | ------- | ----------- |
| `*`       | `*`        | organization | my-org  | `T202B88NN` |
| `support` | `*`        | channel      | support | `C2020H455` |
| `devops`  | `*`        | channel      | devops  | `C3030I566` |
| `*`       | `*`        | user         | any     | `*`         |

### Example: restrict specific command and subcommand to specific users in a specific channel

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
