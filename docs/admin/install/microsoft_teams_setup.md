# Microsoft Teams Setup

| Configuration Setting        | Mandatory? | Default |
| ---------------------------- | ---------- | ------- |
| `enable_ms_teams`            | **Yes**    | False   |
| `microsoft_app_id`           | **Yes**    | --      |
| `microsoft_app_password`     | **Yes**    | --      |

## Azure

1. Login to [https://portal.azure.com](https://portal.azure.com) and select "Create a Resource".
2. Use the search box to locate "Azure Bot", and select "Create".
3. Configure the bot handle, subscription, resource group, location, data residency, pricing tier, and Type of App. For "Type of App", select "Multi Tenant".
4. Be sure to select the "F0" (free) pricing tier if desired. Otherwise the default is set to the "S1" paid tier.
5. Select “Review + create”, then select "Create" and wait for the "Deployment succeeded" pop-up to appear in your browser.
6. Click "Go to resource".
7. In the sidebar to the left, select "Channels" and select the "Microsoft Teams" icon. All of the default settings here are fine, so just click "Save".
8. In the sidebar to the left under “Settings”, select "Configuration".
9. For the "Messaging endpoint", enter your service URL (`https://<server>/api/plugins/chatops/ms_teams/messages/`)
10. On the same page, take note of the "Microsoft App ID" that is displayed. This will be needed at a later step.
11. Click the "Manage" link next to the "Microsoft App ID" from step 10.
12. Click "Certificates & secrets" on the left side menu, under section "Manage".
13. Click "New client secret" to create a new secret. Name it something descriptive, configure the expiration setting as necessary, and click Add. Make note of this secret as it will be needed later, and cannot be revealed again once you navigate away from this window.

## MS Teams Developer Portal

1. To deploy the bot to your team, log in to the [Microsoft Developer Portal](https://dev.teams.microsoft.com/) and select “Apps” from the left-hand menu.
2. Select "Import app" and upload the Nautobot ChatOps_ms_teams.zip file. It can be found from this directory or downloaded from GitHub [here](https://github.com/nautobot/nautobot-plugin-chatops/blob/develop/Nautobot_ms_teams.zip). **NOTE:** If you get an error stating “App package has errors”, you can ignore this and click on “Import” to complete the import.
3. Under section “Configure”, select “Basic Information”. Scroll to the bottom. Under “Application (client) ID, type in the value that you took note of above in Azure step 10.
4. Under section “Configure”, select “App features”. Select the triple dots (...) next to the “Bot” tile and select “Edit”.
5. On the Bot Edit page, under section “Identify your bot,” select “Enter a bot ID” and type in the same App ID value used above in step 4. Click Save.
6. Under section “Publish”, select “Publish to org.” Click the “Publish your app” button. This will need to be approved by your organization’s MS Teams administrator.

## MS Teams Client

1. In the Microsoft Teams client, select “Apps” from the sidebar to the left.
2. Select “Built for your org.”
3. Select the tile for the new Nautobot app. Click the blue “Add” button.
4. Proceed to the [Install Guide](index.md#Install-Guide) section.

## Nautobot Config

- `microsoft_app_id` - This is the "Microsoft App ID" from Azure step 10.
- `microsoft_app_password` - This is the "Microsoft App ID" from Azure step 13.

## Handling ChatOps Behind a Firewall

A common security concern with ChatOps is how to protect your network/application from malicious activity. In order to do so proper firewall policy should be implemented. Through trials, researching, and testing in multiple environments, allowing inbound connections from `52.12.0.0/14` has proven to be successful. Although Microsoft doesn't publish all their ranges this range was found in a [Microsoft Blog Post](https://blog.botframework.com/2020/11/23/bots-secured-behind-a-firewall-teams/) and has yielded success in locked down environments.

## Additional Resources

Reference the [Setting Up Nautobot ChatOps With MSTeams Fall 2022](https://blog.networktocode.com/post/setting-up-nautobot-chatops-with-msteams-fall-2022/) blog post for more details and additional screenshots.

## General Chat Setup Instructions

See [admin_install](index.md) instructions here for general plugin setup instructions.
