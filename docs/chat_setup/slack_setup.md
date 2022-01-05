# Slack Setup

These are the four distinct configuration values you will need to configure in `nautobot_config.py`.

| Configuration Setting        | Mandatory? | Default |
| ---------------------------- | ---------- | ------- |
| `enable_slack`               | **Yes**    | False   |
| `slack_api_token`            | **Yes**    | --      |
| `slack_signing_secret`       | **Yes**    | --      |
| `slack_slash_command_prefix` | No         | `"/"`   |

These values will be used in the `nautobot_config.py` file, once we get to the section where we cover server configuration.
For now, take a mental note that in this section where we are configuring the Slack application, we will need to explicitly note the
`slack_api_token` and `slack_signing_secret` values when they are presented.

Example config snippet from `nautobot_config.py` for configuring chatops with Slack:

```python
# Enable installed plugins. Add the name of each plugin to the list.
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    'nautobot_chatops': {
        'enable_slack': True,
        'slack_api_token': '<slack-api-token>',
        'slack_signing_secret': '<slack-signing-secret>',
    }
}
```

## Create Slack App using a Manifest

1. Log in to [https://api.slack.com/apps](https://api.slack.com/apps) and select "Create New App". Select "From an app manifest."
2. Select your preferred Slack workspace for your app.
3. In the window titled "Enter app manifest below," copy/paste the contents of file [nautobot_slack_manifest.yml](https://github.com/nautobot/nautobot-plugin-chatops/blob/develop/setup_files/nautobot_slack_manifest.yml) in the root of this repo. Update the below settings, then click Next.
   - On line 5, you can change the name of the Chatbot here. By default it is set to `Nautobot`
   - On line 12, under setting `features/slash_commands/url`, update `<your-URL>` with a publicly accessible URL to your Nautobot server. Note: The trailing `/api/plugins/...` are required.
   - Repeat this for line 31, under setting `settings/interactivity/request_url`
4. Review the summarized settings on the next window and click Create.
5. On the General --> Basic Information page, note the `Signing Secret` near the bottom, under App Credentials. This will be needed later for setting `SLACK_SIGNING_SECRET`.
6. Under Distribution --> Install App, select `Install to Workspace`.
   - If you are not a Slack admin, this step will require approval first from an Slack admin in your company.
   - Once installed, note the `Bot User OAuth Token` here. This will be needed later for setting `SLACK_API_TOKEN`.
7. Continue with below section "Post App-Creation Steps"

> **Optional:** You can configure the App Icon on the General --> Basic Information page. Under `App Icon`, select "Choose File." You can use the supplied icon [nautobot_chatops_icon.png](https://github.com/nautobot/nautobot-plugin-chatops/blob/develop/setup_files/nautobot_chatops_icon.png).

## Create Slack App without a Manifest (original method)

1. Log in to [https://api.slack.com/apps](https://api.slack.com/apps) and select "Create New App".
   - Select "From scratch"
   - Enter "Nautobot Chatops" as the "App Name"
   - Select your preferred Slack workspace for your app
   - Click "Create App"
2. On the "Basic Information" page for your app, under "Add features and functionality", select "Interactive Components"
   - Set the toggle to "On"
   - Enter the HTTPS URL of the Slack `interaction` endpoint for your Nautobot installation - it should be something
     like `https://<server>/api/plugins/chatops/slack/interaction/` (note the trailing slash)
   - Select "Save Changes"
3. On the "Basic Information" page for your app, under "Add features and functionality", select "Slash Commands"
   - Decide now whether your setup requires a slack slash command prefix to disambiguate this bot's commands from those understood
     by other bots (such as if you have multiple older Nautobot Chatops versions also enabled), such as `/nautobot-` or `/network2-`
   - This part is a bit tedious, but for each supported command (e.g. `/nautobot`, `/grafana`) you will need to:
     - Select "Create New Command"
     - Enter the command text, the request URL (`https://<server>/api/plugins/chatops/slack/slash_command/` in all cases),
       and the description and usage hints
     - Select "Save"
   - It's up to you whether to configure only the top-level commands (`/nautobot`, etc.) or whether
     you wish to configure all of the sub-commands as slash-commands as well (`/nautobot-get-devices`, `/nautobot-get-facts`,
     etc.). The sub-commands can always be entered as parameters to the top-level commands in any case
     (`/nautobot get-devices`) whether or not you also define them as first-class slash-commands in their own right.
   - TODO: we need a helper script that could be easily run to generate a full listing of subcommands so that a new
     deployer can know what all they need to set up!

> Note: if you want to interact with Nautobot to retrieve data without doing any custom code development, your slash command must
> be `/nautobot` or end with `nautobot` following the configured slack_slash_command_prefix. For example, the
> `/network2-nautobot` command would have a `slack_slash_command_prefix` of `/network2-`

4. On the "Basic Information" page for your app, under "App Credentials", find the "Signing Secret" and click "Show".
   You will need to configure this value for the plugin as the `slack_signing_secret` value, such as through an
   `.env` file. If this value is not correctly configured, the bot will be unable to validate that inbound
   notifications it receives have been properly signed by the Slack server.
5. In the sidebar to the left, select "OAuth & Permissions".
   - Under "Scopes", select "Add an OAuth Scope", and add the following scopes:
     - `chat:write`
     - `commands`
     - `channels:read`
     - `files:write`
     - `incoming-webhook`
     - `users:read`
     - `app_mentions:read`
     - `groups:read`
     - `im:read`
     - `mpim:read`
   - At the top of this page, select "Install App to Workspace" and confirm it.
   - There should now be a "Bot User OAuth Access Token" displayed, typically a string starting with `xoxb-`.
     You will need to configure this value for the plugin as the `slack_api_token` value, either directly or through an
     `.env` file. If this value is not properly configured, the bot will be unable to send content to the user.
6. Returning to the "Basic Information" page for your app, under "Display Information", you can specify the name,
   description, icon, and accent/background color for the app. You can use the `nautobot_logo.png` from this
   directory if desired.
7. Continue with below section "Post App-Creation Steps"

## Post App-Creation Steps

Proceed to the [Nautobot Server Preparation and Configuration](./chat_setup.md#Plug-In-Installation) section.

> **Note**: In the Slack app, you will need to invite the chatbot to each channel that it will belong to with `@<app name>`.
> For example, when an app named `Nautobot Chatops` is installed to the workspace:
>
> 1. A message is displayed in the channel, saying that the integration`Nautobot Chatops` has been added
> 2. You `@Nautobot Chatops` in the channel
> 3. You are prompted to add `@Nautobot Chatops` to the channel

![slack integration invite](../images/add_nautobot.png)

## Configuring Multiple Chatbots in a Workspace

Chatbots from multiple Nautobot implementations can exist in a single Slack workspace and even channel.

They will be differentiated in the workspace using the `slack_slash_command_prefix` value in `PLUGINS_CONFIG`.

Here is an example `nautobot_config.py` for the first Nautobot chatbot implementation in the workspace. This chatbot will be called in the workspace using `/nautobot`.

```python
# Enable installed plugins. Add the name of each plugin to the list.
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    'nautobot_chatops': {
        'enable_slack': True,
        'slack_api_token': '<slack-api-token>',
        'slack_signing_secret': '<slack-signing-secret>',
    }
}
```

Here is an example `nautobot_config.py` for a second Nautobot chatbot implementation in the workspace.
This configuration explicitly configures the `slack_slash_command_prefix` key/value.
This chatbot will be called in the workspace using `/network2-nautobot`.

```python
# Enable installed plugins. Add the name of each plugin to the list.
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    'nautobot_chatops': {
        'enable_slack': True,
        'slack_api_token': '<slack-api-token>',
        'slack_signing_secret': '<slack-signing-secret>',
        'slack_slash_command_prefix': '/network2-'
    }
}
```

> NOTE: by default, your slash command must end with `nautobot`. If no `slack_slash_command_prefix` is specified,
> the slash command will be `/nautobot`. If a `slack_slash_command_prefix` is specified, the slash command will be `<slack_slash_command_prefix>nautobot`.

> NOTE: Custom chatbot development allows for chatbot slash commands such as `/grafana` and `/meraki`.

## General Chat Setup Instructions

See [Chat Setup](./chat_setup.md) instructions here for general plugin setup instructions.
