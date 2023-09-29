# Upgrading the App

## Upgrade Guide

When a new release comes out it may be necessary to run a migration of the database to account for any changes in the data models used by this plugin. Execute the command `nautobot-server post_upgrade` from the Nautobot install nautobot/ directory after updating the package.

### Upgrading to ChatOps 3.0

Introduced in 3.0.0 is [Account Linking](../models/chatopsaccountlink.md), users will now need to link their Chat Platform User with their Nautobot User. Until this is done, the `fallback_chatops_user` setting controls the default Nautobot User and should have proper Nautobot Permissions applied.
