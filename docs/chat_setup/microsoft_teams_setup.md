# Microsoft Teams Setup

| Configuration Setting        | Mandatory? | Default |
| ---------------------------- | ---------- | ------- |
| `enable_ms_teams`            | **Yes**    | False   |
| `microsoft_app_id`           | **Yes**    | --      |
| `microsoft_app_password`     | **Yes**    | --      |



## Azure

1. Login to [https://portal.azure.com](https://portal.azure.com) and select "Create a Resource".
2. Use the search box to locate "Bot Channels Registration", then select "Bot Channels Registration" under section Marketplace.
3. Configure the bot handle, subscription, resource group, and location. Create new resource group. It can be named the same as the bot handle for simplicity.
4. Be sure to select the "F0" (free) pricing tier, rather than the default "S1" paid tier.
5. For the "Messaging endpoint", enter your service URL (`https://<server>/api/plugins/chatops/ms_teams/messages/`)
6. Select "Create" and wait for the "Deployment succeeded" pop-up to appear in your browser.
7. Once completed, in the top search bar, enter "Bot Services", then select "Bot Services" under section "Services". Select the name of the bot you just created (not the resource group).
8. In the sidebar to the left, select "Channels" and select the "Microsoft Teams" icon, labeled "Configure Microsoft Teams channel". All of the default settings here are fine, so just click "Save".
9. In the sidebar to the left, under Settings, select "Configuration". Copy the "Microsoft App ID" that is displayed (it's greyed out, but can be selected for copying), then click the "Manage" link above the App ID field.
10. On the new "Certificates & secrets" page, click "New client secret". (You may have to delete one of the existing secrets first, as there is a maximum limit). Copy the newly generated secret, as there's no way to recover it once you leave the page - you will have to return to this page and generate a new secret if you lose it.

## MS Teams Client

1. Now to deploy the bot to your team. In the Microsoft Teams client, select "Apps" from the sidebar to the left.
2. Use the search bar to find "App Studio" and select and open it. If it isn't currently installed, install it first.
3. Select the "Manifest editor" tab at the top of the window.
4. Select "Import an existing app", and upload the `Nautobot_ms_teams.zip` file from this directory.
5. Under section 1 Details, page "App details", update the "App ID" to the value that you took note of in step 8 above.
6. Under section 2 Capabilities, page "Bots", select the Edit button next to the Bot at the top. In the field "Connect to a different bot id", update the "App ID" to the value that you took note of in step 8 above.
7. Under section 3 Finish, page "Test and distribute", Select "Download" to save the app package to your disk.
8. Again select "Apps" in the left sidebar, then "Upload a custom app" at the bottom.
9. Select your updated app package zip file.
10. After a few moments, the Nautobot app will appear in the window. Select it and click "Add".
11. Configure the `microsoft_app_id` and `microsoft_app_password` for the plugin with the App ID and client secret values from step 8 in your `.creds.env` file (on the Nautobot server, not in the MS Teams client).
12. Proceed to the [Nautobot Server Preparation and Configuration](./chat_setup.md#Plug-In Installation) section.

[Chat Setup](./chat_setup.md)
