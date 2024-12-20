<!-- markdownlint-disable MD024 -->
# v3.1 Release Notes

<!-- towncrier release notes start -->
## [v3.1.3 (2024-12-20)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v3.1.3)

### Fixed

- [#355](https://github.com/nautobot/nautobot-app-chatops/issues/355) - Fixed "Server has gone away" error in Slack Socket Mode.

## [v3.1.2 (2024-12-19)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v3.1.2)

### Fixed

- [#348](https://github.com/nautobot/nautobot-app-chatops/issues/348) - Fixed failure when running slack socket mode.

## [v3.1.1 (2024-11-18)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v3.1.1)

### Added

- [#341](https://github.com/nautobot/nautobot-app-chatops/issues/341) - Added a "grafana disabled" view in case a user clicks on a grafana nav menu item when the grafana integration is disabled.

### Removed

- [#341](https://github.com/nautobot/nautobot-app-chatops/issues/341) - Removed all grafana integration API files since there are no API views provided by grafana integration.

### Fixed

- [#341](https://github.com/nautobot/nautobot-app-chatops/issues/341) - Fixed django-constance not being upgradable due to this app accessing the database before migrations could run.
- [#341](https://github.com/nautobot/nautobot-app-chatops/issues/341) - Removed conditional logic for adding grafana navigation menu items.
- [#341](https://github.com/nautobot/nautobot-app-chatops/issues/341) - Fixed Nautobot v2.3 incompatibility caused by saved views not being able to determine the models' table classes.
- [#341](https://github.com/nautobot/nautobot-app-chatops/issues/341) - Added exception handling for cases where diffsync is not installed, since it's marked as optional.

### Dependencies

- [#333](https://github.com/nautobot/nautobot-app-chatops/issues/333) - Fixed slack-sdk to version ^3.19.0 for `files_upload_v2`.

### Documentation

- [#331](https://github.com/nautobot/nautobot-app-chatops/issues/331) - Fix unrecognized relative link and anchors.

### Housekeeping

- [#0](https://github.com/nautobot/nautobot-app-chatops/issues/0) - Rebaked from the cookie `nautobot-app-v2.4.0`.
- [#339](https://github.com/nautobot/nautobot-app-chatops/issues/339) - Changed model_class_name in .cookiecutter.json to a valid model to help with drift management.
- [#341](https://github.com/nautobot/nautobot-app-chatops/issues/341) - Fixed dev environment nautobot_config.py to fall back to constance if environment variable is not used.

## [v3.1.0 (2024-09-30)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v3.1.0)

### Added

- [#317](https://github.com/nautobot/nautobot-app-chatops/issues/317) - Migrated IPFabric SSoT Job command from SSoT project.
- [#325](https://github.com/nautobot/nautobot-app-chatops/issues/325) - Added Python 3.12 support.

### Fixed

- [#306](https://github.com/nautobot/nautobot-app-chatops/issues/306) - Add reversible migration for Grafana.
- [#327](https://github.com/nautobot/nautobot-app-chatops/issues/327) - Slack has deprecated files_upload, replacing with files_upload_v2.

### Dependencies

- [#313](https://github.com/nautobot/nautobot-app-chatops/issues/313) - Update Pydantic to ^2.0.0.
- [#313](https://github.com/nautobot/nautobot-app-chatops/issues/313) - Update Schema Enforcer to ^1.4.0 to support Pydantic V2
- [#313](https://github.com/nautobot/nautobot-app-chatops/issues/313) - Update IPFabric to ^6.6.2
- [#314](https://github.com/nautobot/nautobot-app-chatops/issues/314) - Pin Meraki to 1.45.0 due to Meraki removing support for Python <3.10 in 1.46.0

### Documentation

- [#169](https://github.com/nautobot/nautobot-app-chatops/issues/169) - Updated documentation to match the new requirements for setting up Microsoft Teams in Azure.
- [#169](https://github.com/nautobot/nautobot-app-chatops/issues/169) - Documented Bot Framework configuration.
- [#311](https://github.com/nautobot/nautobot-app-chatops/issues/311) - Update Account Link docs to refer to `fallback_chatops_user` option.
- [#319](https://github.com/nautobot/nautobot-app-chatops/issues/319) - Updated app config settings to point to new url.py path for activating docs link.

### Housekeeping

- [#169](https://github.com/nautobot/nautobot-app-chatops/issues/169) - Added Bot Framework compatibility for testing MS Teams.
- [#309](https://github.com/nautobot/nautobot-app-chatops/issues/309) - Release v3.0.2
- [#321](https://github.com/nautobot/nautobot-app-chatops/issues/321) - Rebake with 2.3.0 Cookiecutter.
- [#325](https://github.com/nautobot/nautobot-app-chatops/issues/325) - Rebaked with nautobot-app-v2.3.2 cookie.
