# Microsoft Teams Setup

| Configuration Setting        | Mandatory? | Default |
| ---------------------------- | ---------- | ------- |
| `enable_ms_teams`            | **Yes**    | False   |
| `microsoft_app_id`           | **Yes**    | --      |
| `microsoft_app_password`     | **Yes**    | --      |



## Azure

1. Login to [https://portal.azure.com](https://portal.azure.com) and select "Create a Resource".
2. Use the search box to locate "Azure Bot", and select "Create".
3. Configure the bot handle, subscription, resource group, location, and pricing tier.
4. Be sure to select the "F0" (free) pricing tier, rather than the default "S1" paid tier.
5. Select “Review + create”, then select "Create" and wait for the "Deployment succeeded" pop-up to appear in your browser.
6. Click "Go to resource".
7. In the sidebar to the left, select "Channels" and select the "Microsoft Teams" icon. All of the default settings here are fine, so just click "Save".
8. In the sidebar to the left under “Settings”, select "Configuration".
9. For the "Messaging endpoint", enter your service URL (`https://<server>/api/plugins/chatops/ms_teams/messages/`)
10. On the same page, take note of the "Microsoft App ID" that is displayed, then click the "Manage" link above the App ID field.
11. On the new "Certificates & secrets" page, click "New client secret". (You may have to delete one of the existing secrets first, as there is a maximum limit). **NOTE: Take note of the newly generated secret, as there's no way to recover it later - you will have to return to this page and generate a new secret if you lose it.**

## MS Teams Developer Portal

1. To deploy the bot to your team, log in to the [Microsoft Developer Portal](https://dev.teams.microsoft.com/) and select “Apps” from the left-hand menu.
2. Select "Import app" and upload the Nautobot ChatOps_ms_teams.zip file. It can be found from this directory or downloaded from GitHub [here](https://github.com/nautobot/nautobot-plugin-chatops/blob/develop/Nautobot_ms_teams.zip). **NOTE:** If you get an error stating “App package has errors”, you can ignore this and click on “Import” to complete the import.
3. Under section “Configure”, select “Basic Information”. Scroll to the bottom. Under “Application (client) ID, type in the value that you took note of above in Azure.
4. Under section “Configure”, select “App features”. Select the triple dots (...) next to the “Bot” tile and select “Edit”.
5. On the Bot Edit page, under section “Identify your bot,” select “Enter a bot ID” and type in the same App ID value used above in step 4. Click Save.
6. Under section “Publish”, select “Publish to org.” Click the “Publish your app” button. This will need to be approved by your organization’s MS Teams administrator.

## MS Teams Client

1. In the Microsoft Teams client, select “Apps” from the sidebar to the left.
2. Select “Built for your org.”
3. Select the tile for the new Nautobot app. Click the blue “Add” button.
4. Proceed to the Nautobot Server Preparation and Configuration section in the [Chat Setup](./chat_setup.md) document.

## Additional Resources

Reference the [Setting Up Nautobot Chatops With MSTeams Fall 2021](http://blog.networktocode.com/post/setting-up-nautobot-chatops-with-msteams-fall-2021/) blog post for more details and additional screenshots.