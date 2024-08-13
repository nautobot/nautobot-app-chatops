# Microsoft Teams Setup

| Configuration Setting        | Mandatory? | Default | Available on Admin Config |
| ---------------------------- | ---------- | ------- | --------------------------|
| `enable_ms_teams`            | **Yes**    | False   | Yes                       |
| `microsoft_app_id`           | **Yes**    | --      | No                        |
| `microsoft_app_password`     | **Yes**    | --      | No                        |

## Register Microsoft Entra App

### Add App Registration

1. Login to [https://portal.azure.com](https://portal.azure.com) and select "App registrations".  
    ![Azure App registrations](../../images/light/azure_app_registration.png#only-light)
    ![Azure App registrations](../../images/dark/azure_app_registration.png#only-dark)
2. Select New Registration.  
    ![Azure add App registrations](../../images/light/azure_add_app_registration.png#only-light)
    ![Azure add App registrations](../../images/dark/azure_add_app_registration.png#only-dark)
3. Enter the name of your app, for example, **Chatops-NautobotDev**
4. Select **Accounts in any organizational directory (Any Microsoft Entra ID tenant - Multitenant)**.
    !!! warning
    You must use Multitenant here, this is what allows the Bot to integrate with Microsoft Teams (which is technically a different Tenant).
5. Select Register.
    ![Azure Registration Form](../../images/light/azure_registration_form.png#only-light)
    ![Azure Registration Form](../../images/dark/azure_registration_form.png#only-dark)
6. Your app is registered in Microsoft Entra. The app overview page appears. Save Application (client) ID and Directory (tenant) ID for later use.
    ![Azure App Overview](../../images/light/azure_app_overview.png#only-light)
    ![Azure App Overview](../../images/dark/azure_app_overview.png#only-dark)

### Add a Web Authentication

1. In the left pane, under **Manage**, select **Authentication**.
2. Select **Add a platform > Web**.
    ![Azure Add Platform](../../images/light/azure_add_platform.png#only-light)
    ![Azure Add Platform](../../images/dark/azure_add_platform.png#only-dark)
3. Enter the redirect URI for your app by appending **/api/plugins/chatops/ms_teams/messages/** to the fully qualified domain name. For example, `https://example.com/api/plugins/chatops/ms_teams/messages/`.
4. Under **Implicit grant and hybrid flows** select the **Access tokens** and **ID tokens** checkboxes.
5. Select Configure.  
    ![Azure Configure Web](../../images/light/azure_configure_web.png#only-light)
    ![Azure Configure Web](../../images/dark/azure_configure_web.png#only-dark)
6. Under Web, select Add URI
7. Enter `https://token.botframework.com/.auth/web/redirect`.
8. Under **Implicit grant and hybrid flows**, verify all checkboxes are checked.
9. Under **Supported account types** lower on the page, verify **Accounts in any organizational directory (Any Microsoft Entra ID tenant - Multitenant)** is selected.
10. Select **Save** at the bottom of the page.
    ![Azure Additional URI and Confirmation](../../images/light/azure_confirm_web.png#only-light)
    ![Azure Additional URI and Confirmation](../../images/dark/azure_confirm_web.png#only-dark)

!!! warning
    Both entries **must** be present, one pointing to Nautobot and the other to `https://token.botframework.com/.auth/web/redirect`

### Create a Client Secret

1. In the left pane, under Manage, select Certificates & secrets.
2. Under Client secrets, select + New client secret.
    The Add a client secret window appears.
3. Enter Description.
4. Configure Expires according to your security policies.  
5. Select Add.
    ![Azure Create Client Secret](../../images/light/azure_create_client_secret.png#only-light)
    ![Azure Create Client Secret](../../images/dark/azure_create_client_secret.png#only-dark)
6. Under **Value** select **Copy to clipboard** to save the Client Secret value. This secret will need to be configured in Nautobot.
    ![Azure Copy Client Secret value](../../images/light/azure_copy_secret_value.png#only-light)
    ![Azure Copy Client Secret value](../../images/dark/azure_copy_secret_value.png#only-dark)
!!! tip
    It is highly recommended to document the Expiration somewhere so that the secret can be renewed beforehand. Otherwise, ChatOps will stop working.

### Add API Permissions

1. In the left pane, select **API permissions**.
2. Select **+ Add a permission.**
3. Select Microsoft Graph.  
    ![Azure Add API Permissions](../../images/light/azure_add_api_permissions.png#only-light)
    ![Azure Add API Permissions](../../images/dark/azure_add_api_permissions.png#only-dark)
4. Select **Application permissions**.
5. If **User > User.Read** is not already configured, select it here.
6. Select **User > User.Read.All**.
7. Select **Add Permissions**.  
    ![Azure User Read All permission](../../images/light/azure_user_read_all.png#only-light)
    ![Azure User Read All permission](../../images/dark/azure_user_read_all.png#only-dark)
!!! warning
    The **User > User.Read.All permission requires approval from an Azure Admin before it can be utilized.

### Add Application ID URI

1. In the left pane, under **Manage**, select **Expose an API**, then **Add** next to **Application ID URI**.
    ![Azure Expose API](../../images/light/azure_expose_api.png#only-light)
    ![Azure Expose API](../../images/dark/azure_expose_api.png#only-dark)
2. Add the FQDN to the Application ID URI, be sure to leave the UUID in place.
    ![Azure Application ID URI](../../images/light/azure_application_id_uri.png#only-light)
    ![Azure Application ID URI](../../images/dark/azure_application_id_uri.png#only-dark)
3. Click on Save.

### Add a Scope

1. In the left pane, under **Manage**, select **Expose an API**.
2. Select **+ Add a scope**.
    ![Azure Add a Scope](../../images/light/azure_add_scope.png#only-light)
    ![Azure Add a Scope](../../images/dark/azure_add_scope.png#only-dark)
3. Enter `access_as_user` as the **Scope name**.
4. Under **Who can consent?**, select `Admins and users`.
5. Update the values for the rest of the fields as follows:
   1. Enter `Teams can access the user's profile` as **Admin consent display name**.
   2. Enter `Allows Teams to call the app's web APIs as the current user` as **Admin consent description**.
   3. Enter `Teams can access the user profile and make requests on the user's behalf` as **User consent display name**.
   4. Enter `Enable Teams to call this app's APIs with the same rights as the user` as **User consent description**.
6. Ensure that **State** is set to `Enabled`.
7. Select **Add scope**.
    ![Azure Add a Scope Form](../../images/light/azure_add_scope_form.png#only-light)
    ![Azure Add a Scope Form](../../images/dark/azure_add_scope_form.png#only-dark)

### Add Client Application

1. In the left pane, under **Manage**, select **Expose an API**.
   Under Authorized client applications, identify the applications that you want to authorize for your app’s web application.
2. Select **+ Add a client application**.
3. Add Teams mobile/desktop and/or Teams web application. You can add one or both of these Client IDs.
   1. For Teams mobile app and desktop client app: Enter the Client ID as `1fec8e78-bce4-4aaf-ab1b-5451cc387264`.
   2. For Teams web client: Enter the Client ID as `5e3ce6c0-2b1f-4285-8d4b-75ee78787346`.
4. Select the **Authorized Scopes** checkbox for the `api://` endpoint we just created in section [Add Application ID URI](#add-application-id-uri)
5. Select **Add application**.
    ![Azure Add Client Application](../../images/light/azure_add_client_application.png#only-light)
    ![Azure Add Client Application](../../images/dark/azure_add_client_application.png#only-dark)

## Create Azure Bot

### Create an Azure Bot Resource

1. Login to [https://portal.azure.com](https://portal.azure.com) and select **+ Create a Resource**.
2. Use the search box to locate **Azure Bot**, and select **Enter**.
3. Select **Azure Bot**
4. Select **Create**
    ![Azure Bot](../../images/light/azure_azure_bot.png#only-light)
    ![Azure Bot](../../images/dark/azure_azure_bot.png#only-dark)
5. Enter the bot name in the **Bot handle**.
   1. This is used as an identifier in Azure Bot Framework, not what the bot is called in the MS Teams.
6. Select your **Subscription** from the dropdown list.
7. Select your **Resource group** from the dropdown list if you want to use an existing one. Otherwise, select the **Create New** and create a new resource group.
8. Under **Pricing**, select **Change plan**.
9. Be sure to select the **F0** (free) pricing tier if desired. Otherwise the default is set to the **S1** paid tier.
10. Under the **Microsoft App ID**, select **Type of App** as **Multi Tenant**
11. In the **Creation type**, select **Use existing app registration**.
12. Enter the **App ID**. This is the Application ID we saved for later use in [Add App Registration](#add-app-registration)
13. Select **Review + create**.
14. After the validation passes, select **Create**. The bot takes a few minutes to provision.
15. Select **Go to resource**.
16. In the left pane, under **Settings**, select **Configuration**.
17. Update the **Messaging endpoint** in the format: `https://<nautobot_url>/api/plugins/chatops/ms_teams/messages/`
    ![Azure Bot Configuration](../../images/light/azure_bot_configuration.png#only-light)
    ![Azure Bot Configuration](../../images/dark/azure_bot_configuration.png#only-dark)

### Add a Teams Channel

1. In the left pane, under **Settings**, select **Channels**.
2. Under **Available Channels**, select **Microsoft Teams**.
    ![Azure Bot Channels](../../images/light/azure_bot_channels.png#only-light)
    ![Azure Bot Channels](../../images/dark/azure_bot_channels.png#only-dark)
3. Select the checkbox to accept the **Terms of Service**.
4. Select **Agree**.
5. Select **Apply**.

### Configure The Chatops App

1. Download the **Nautobot_ms_teams.zip** file containing the Chatops app from the [repository](https://github.com/nautobot/nautobot-app-chatops)
2. Unzip he contents of the **Nautobot_ms_teams.zip** file to the **Nautobot_ms_teams** directory and open the **manifest.json** file for editing.
3. Replace the following values with your bot's Microsoft App ID that we previous saved in [Add App Registration](#add-app-registration)
   1. `id` on line 5
   2. `botId` in **bots** array on line 43
   3. `webApplicationInfo.id` on line 104
4. Save the **manifest.json** file.
5. Zip the contents of the **Nautobot_ms_teams** directory to create **Nautobot_ms_teams.zip**.
!!! danger "Mac OSX"

    If you are on a Mac, OSX will insert hidden OSX-related files that will cause the import to fail. Instead, open **Terminal**, navigate to the extracted **Nautobot_ms_teams** folder, and run the following command:

    ```bash
    zip -r Nautobot_ms_teams.zip . -x '**/.*' -x '**/__MACOSX'
    ```

### Upload the App to MS Teams Portal

1. To deploy the bot to your team, log in to the [Microsoft Developer Portal](https://dev.teams.microsoft.com/) and select “Apps” from the left-hand menu.
2. Select "Import app" and upload the Nautobot ChatOps_ms_teams.zip file. It can be found from this directory or downloaded from GitHub [here](https://github.com/nautobot/nautobot-app-chatops/blob/develop/Nautobot_ms_teams.zip). **NOTE:** If you get an error stating “App package has errors”, you can ignore this and click on “Import” to complete the import.
3. Under section “Configure”, select “Basic Information”. Scroll to the bottom. Under “Application (client) ID, type in the value that you took note of above in Azure step 10.
4.  Under section “Configure”, select “App features”. Select the triple dots (...) next to the “Bot” tile and select “Edit”.
5.  On the Bot Edit page, under section “Identify your bot,” select “Enter a bot ID” and type in the same App ID value used above in step 4. Click Save.
6.  Under section “Publish”, select “Publish to org.” Click the “Publish your app” button. This will need to be approved by your organization’s MS Teams administrator.

## MS Teams Client

1. In the Microsoft Teams client, select “Apps” from the sidebar to the left.
2. Select “Built for your org.”
3. Select the tile for the new Nautobot app. Click the blue “Add” button.
4. Proceed to the [Install Guide](../install.md#Install-Guide) section.

## Nautobot Config

- `microsoft_app_id` - This is the "Microsoft App ID" from Azure step 10.
- `microsoft_app_password` - This is the "Client Secret" from Azure step 13.

## Handling ChatOps Behind a Firewall

A common security concern with ChatOps is how to protect your network/application from malicious activity. In order to do so proper firewall policy should be implemented. Through trials, researching, and testing in multiple environments, allowing inbound connections from `52.112.0.0/14` has proven to be successful. Although Microsoft doesn't publish all their ranges this range was found in a [Microsoft Blog Post](https://blog.botframework.com/2020/11/23/bots-secured-behind-a-firewall-teams/) and has yielded success in locked down environments.  Additionally Microsoft Posted their [IP Address and DNS ranges](https://learn.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide#skype-for-business-online-and-microsoft-teams).

## Additional Resources

Reference the [Setting Up Nautobot ChatOps With MSTeams Fall 2022](https://blog.networktocode.com/post/setting-up-nautobot-chatops-with-msteams-fall-2022/) blog post for more details and additional screenshots.

## General Chat Setup Instructions

See [admin_install](../install.md) instructions here for general app setup instructions.
