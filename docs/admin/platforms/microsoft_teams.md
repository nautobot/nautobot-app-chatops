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

1. In the left pane, under **Manage**, select **Expose an API**.
2. 

## Azure

1. Login to [https://portal.azure.com](https://portal.azure.com) and select "Create a Resource".
2. Use the search box to locate "Azure Bot", and select "Create".
3. Configure the bot handle, subscription, resource group, location, data residency, pricing tier, and Type of App. For "Type of App", select "Multi Tenant".
    !!! warning
    You must use Multi Tenant here, this is what allows the Bot to integrate with Microsoft Teams (which is technically a different Tenant).
4. Be sure to select the "F0" (free) pricing tier if desired. Otherwise the default is set to the "S1" paid tier.
5. Select “Review + create”, then select "Create" and wait for the "Deployment succeeded" pop-up to appear in your browser.
6. Click "Go to resource".
7. In the sidebar to the left, select "Channels" and select the "Microsoft Teams" icon. All of the default settings here are fine, so just click "Save".
8. In the sidebar to the left under “Settings”, select "Configuration".
9. For the "Messaging endpoint", enter your service URL (`https://<server>/api/plugins/chatops/ms_teams/messages/`)
10. On the same page, take note of the "Microsoft App ID" that is displayed. This will be needed at a later step.
11. Click the "Manage Password" link next to the "Microsoft App ID" from step 10.
12. Click "Certificates & secrets" on the left side menu, under section "Manage".
13. Click "New client secret" to create a new secret. Name it something descriptive, configure the expiration setting as necessary, and click Add. Make note of this secret (Value column) as it will be needed later, and cannot be revealed again once you navigate away from this window.

## MS Teams Developer Portal

1. To deploy the bot to your team, log in to the [Microsoft Developer Portal](https://dev.teams.microsoft.com/) and select “Apps” from the left-hand menu.
2. Select "Import app" and upload the Nautobot ChatOps_ms_teams.zip file. It can be found from this directory or downloaded from GitHub [here](https://github.com/nautobot/nautobot-app-chatops/blob/develop/Nautobot_ms_teams.zip). **NOTE:** If you get an error stating “App package has errors”, you can ignore this and click on “Import” to complete the import.
3. Under section “Configure”, select “Basic Information”. Scroll to the bottom. Under “Application (client) ID, type in the value that you took note of above in Azure step 10.
4. Under section “Configure”, select “App features”. Select the triple dots (...) next to the “Bot” tile and select “Edit”.
5. On the Bot Edit page, under section “Identify your bot,” select “Enter a bot ID” and type in the same App ID value used above in step 4. Click Save.
6. Under section “Publish”, select “Publish to org.” Click the “Publish your app” button. This will need to be approved by your organization’s MS Teams administrator.

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
