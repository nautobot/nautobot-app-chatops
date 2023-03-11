# Mattermost Setup

| Configuration Setting        | Mandatory? | Default |
| ---------------------------- | ---------- | ------- |
| `enable_mattermost`          | **Yes**    | False   |
| `mattermost_api_token`       | **Yes**    | --      |
| `mattermost_url`             | **Yes**    | --      |

1. Login to your instance of Mattermost and select Integrations, then click Bot Accounts.
   - Enter the bot username, icon, Display name and Description.
   - Choose the Role for the bot. In order to use Ephemeral posts, you need to choose System Admin.
2. Configure the displayed Access Token string as the `mattermost_api_token` in your `.creds.env` file or directly in the `PLUGINS_CONFIG` section of `nautobot_config.py`.
   It can't be recovered later, so if you lose it you'll need to log in and regenerate a new token.
3. Go back to Integrations, then click Slash Commands.
   - Click Add Slash Command, filling out the Title, Description, Command Trigger Word
   - Set the Request URL to `https://<server>/api/plugins/chatops/mattermost/slash_command/`
   - Click Save.
4. Configure the displayed Token following the guide for [Add Command Token to database](#add-command-token-to-database) below.
   - The Command will be `Command Trigger Word` from step 3.
   - Use the token displayed from step 3; you can access this token from Mattermost at any time.
5. Configure `mattermost_url` with the URL for your Mattermost instance.
   - To get this from within the client go to the Server Management:
     - From Windows `file - settings`
     - From Mac `Mattermost - preferences`
   - Copy the displayed url matching the Server you want to add the chatbot to.
     - Make sure to include the `http://` or `https://`.
     - If shown, make sure to include the port. Ex. `https://example.com:8065`
6. Proceed to the [Install Guide](index.md#Install-Guide) section.

**Note:** For every Slash Command created for Mattermost, a separate token will be generated.

## Add Command Token to Database

{%
    include-markdown '../../models/commandtoken.md'
    start='<!--command-token-->'
    heading-offset=1
%}

## General Chat Setup Instructions

See [admin_install](index.md) instructions here for general plugin setup instructions.
