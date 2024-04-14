# Account Link

+++ 3.0.0

Nautobot ChatOps now uses the built-in Nautobot permissions for Nautobot Objects (Devices, Locations, Racks, etc.). You can still fall back to the previous behavior by setting the `fallback_chatops_user` setting, otherwise each user will need to link their Nautobot Account with their Chat Platform User Account. Login to Nautobot then access the Link ChatOps Account within the Plugins menu. Here you can provide your email address and select the ChatOps Platform you are using, then click the Look up User ID from Email to get your Chat User ID.

A Nautobot user can have multiple Chat users connected, but the Chat User can only be linked to one Nautobot user. As an example my team is transitioning from Slack to Mattermost. My Slack User ID and my Mattermost User ID can both be connected to the same Nautobot User.

![Link Accounts](../images/account_link.png)

## Configuring Account Link for many users

Admins have the ability to access the Nautobot Admin page and can use `ChatOps Account Links` page to link multiple accounts, but you will need to know the Chat Platforms user IDs for each user you are linking.

If you would like to set a single account for all users, see the [configuration guide](../admin/install.md#configuration-guide) for more details on the `fallback_chatops_user` option.
