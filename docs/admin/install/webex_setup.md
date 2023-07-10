# Webex Setup

| Configuration Setting        | Mandatory? | Default |
| ---------------------------- | ---------- | ------- |
| `enable_webex`         | **Yes**    | False   |
| `webex_token`          | **Yes**    | --      |
| `webex_signing_secret` | **Yes**    | --      |

1. Login to [https://developer.webex.com](https://developer.webex.com) and select "Start building apps", then "Create a New App", then "Create a Bot".
   - Enter the bot name, username, icon (you can use `nautobot_logo.png` from this directory), and description,
     and select "Add Bot"
2. Configure the displayed Bot Access Token string as the `webex_token` in your `.creds.env` file.
   It can't be recovered later, so if you lose it you'll need to log in and regenerate a new token.
3. Currently the bot does not automatically register its own webhooks (although this is a capability that WebEx
   provides, TODO?) so you'll need to set them up yourself.
   - Go to [https://developer.webex.com/docs/api/v1/webhooks](https://developer.webex.com/docs/api/v1/webhooks)
   - *For all of these API calls, be sure you deselect "Use personal access token" and instead specify the
     Bot Access Token string as the authorization instead.*
   - If desired, you can use [https://developer.webex.com/docs/api/v1/webhooks/list-webhooks](https://developer.webex.com/docs/api/v1/webhooks/list-webhooks) to query for existing
     webhooks. There should be none if this is a new deployment.
   - Use [https://developer.webex.com/docs/api/v1/webhooks/create-a-webhook](https://developer.webex.com/docs/api/v1/webhooks/create-a-webhook) (again, with the bot access token) to create
     a new webhook with the following parameters:
     - name: "nautobot messages"
     - targetUrl: "https://\<server\>/api/plugins/chatops/webex/"
     - resource: "messages"
     - event: "created"
     - secret: (enter a secret string that you don't mind having passed around as plaintext)
   - Change the `resource` to "attachmentActions" and run the API call again to create a second webhook.
4. Configure the `webex_signing_secret` in your `.creds.env` to match the Webhook secret string that you selected above.
5. Proceed to the [Install Guide](index.md#Install-Guide) section.

## Deprecation Warning

As of Nautobot ChatOps Plugin v1.4.0, the PLUGIN_CONFIG settings for Webex has changed to align with the official renaming of `Webex Teams` to `Webex`:

- `enable_webex_teams` is deprecated. Use `enable_webex` instead.
- `webex_teams_token` is deprecated. Use `webex_token` instead.
- `webex_teams_signing_secret` is deprecated. Use `webex_signing_secret` instead.

Both settings will currently work, however support for `enable_webex_teams`, `webex_teams_token` and `webex_teams_signing_secret` will be removed in v2.0.0.

## General Chat Setup Instructions

See [admin_install](index.md) instructions here for general plugin setup instructions.
