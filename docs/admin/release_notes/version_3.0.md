<!-- markdownlint-disable MD024 -->
# v3.0 Release Notes

<!-- towncrier release notes start -->
## [v3.0.0 (2023-09-29)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v3.0.0)

### Added

- [#112](https://github.com/nautobot/nautobot-app-chatops/issues/112) - Add ability to link Chat User with Nautobot User.
- [#272](https://github.com/nautobot/nautobot-app-chatops/issues/272) - Add ObjectNotesView for ChatOps models.

## [v3.0.1 (2023-09-29)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v3.0.1)

### Fixed

- [#281](https://github.com/nautobot/nautobot-app-chatops/issues/281) - Address permissions bug found during release review.

## [v3.0.2 (2024-03-28)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v3.0.2)

### Added

- [#270](https://github.com/nautobot/nautobot-app-chatops/issues/270) - Add run_job Nautobot subcommand, which initiates a job with kwargs or a job requiring no manual form input.
- [#270](https://github.com/nautobot/nautobot-app-chatops/issues/270) - Add run_job_form Nautobot subcommand, which presents job's form widgets to the user.
- [#270](https://github.com/nautobot/nautobot-app-chatops/issues/270) - Add get_jobs Nautobot subcommand, which returns all Nautobot jobs viewable to user.
- [#270](https://github.com/nautobot/nautobot-app-chatops/issues/270) - Add filter_jobs Nautobot subcommand, which returns filtered set of Nautobot jobs viewable to user.
- [#288](https://github.com/nautobot/nautobot-app-chatops/issues/288) - Added Cisco NSO integration

### Changed

- [#265](https://github.com/nautobot/nautobot-app-chatops/issues/265) - Aligned integrations documentation structure with SSoT.
- [#297](https://github.com/nautobot/nautobot-app-chatops/issues/297) - Replaced pydocstyle with ruff.

### Fixed

- [#293](https://github.com/nautobot/nautobot-app-chatops/issues/293) - Fix Aristacv not disabling with the setting.

### Housekeeping

- [#8](https://github.com/nautobot/nautobot-app-chatops/issues/8), [#307](https://github.com/nautobot/nautobot-app-chatops/issues/307) - Re-baked from the latest template.
- [#293](https://github.com/nautobot/nautobot-app-chatops/issues/293) - Add debug logs to msteams dispatcher and api view.
