<!-- markdownlint-disable MD024 -->
# v3.1 Release Notes

<!-- towncrier release notes start -->
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
