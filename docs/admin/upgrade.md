# Upgrading the App

Here you will find any steps necessary to upgrade the App in your Nautobot environment.

## Upgrade Guide

When a new release comes out it may be necessary to run a migration of the database to account for any changes in the data models used by this app. Execute the command `nautobot-server post_upgrade` within the runtime environment of your Nautobot installation after updating the `nautobot-chatops` package via `pip`.

### Upgrading to ChatOps 3.0

Introduced in 3.0.0 is [Account Linking](../models/chatopsaccountlink.md), users will now need to link their Chat Platform User with their Nautobot User. Until this is done, the `fallback_chatops_user` setting controls the default Nautobot User and should have proper Nautobot Permissions applied.

### Upgrading to ChatOps 4.2

ChatOps no longer depends on `nautobot-capacity-metrics`.

- The `nautobot_command_library` metric moved from `/api/plugins/capacity-metrics/app-metrics` to `/metrics`. Update your Prometheus scrape job, and set `METRICS_ENABLED = True`.
- If no other app needs it, remove `nautobot_capacity_metrics` from `PLUGINS`, and uninstall the package.
