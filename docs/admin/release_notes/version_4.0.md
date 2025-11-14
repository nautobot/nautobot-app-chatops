# v4.0 Release Notes

This document describes all new features and changes in the release. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Release Overview

- Major features or milestones
- Changes to compatibility with Nautobot and/or other apps, libraries etc.

<!-- towncrier release notes start -->


## [v4.0.0a1 (2025-11-14)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v4.0.0a1)

### Added

- [#384](https://github.com/nautobot/nautobot-app-chatops/issues/384) - Added Bulk Update functionality for the AccessGrant, CommandToken and ChatOpsAccountLink models.

### Changed

- [#404](https://github.com/nautobot/nautobot-app-chatops/issues/404) - Updated template bootstrap version from 3 to 5.

### Dependencies

- [#403](https://github.com/nautobot/nautobot-app-chatops/issues/403) - Updated schema-enforcer and termcolor dependencies.

### Housekeeping

- [#384](https://github.com/nautobot/nautobot-app-chatops/issues/384) - Refactored AccessGrant model, ChatOpsAccountLink, CommandLog, CommandToken related UI views to use `NautobotUIViewSet` and `UI component framework`.
- [#394](https://github.com/nautobot/nautobot-app-chatops/issues/394) - Refactored GrafanaDashboard related UI views to use `NautobotUIViewSet` and `UI component framework`.
- [#397](https://github.com/nautobot/nautobot-app-chatops/issues/397) - Replaced deprecated object_edit and object_detail templates.
- Rebaked from the cookie `nautobot-app-v2.7.0`.
- Rebaked from the cookie `nautobot-app-v2.7.1`.
