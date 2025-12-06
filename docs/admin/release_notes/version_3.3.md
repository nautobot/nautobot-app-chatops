# v3.3 Release Notes

This document describes all new features and changes in the release. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Release Overview

- Change minimum Nautobot version to 2.4.20.
- Dropped support for Python 3.9.

<!-- towncrier release notes start -->
## [v3.3.0 (2025-12-05)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v3.3.0)

### Added

- [#384](https://github.com/nautobot/nautobot-app-chatops/issues/384) - Added Bulk Update functionality for the AccessGrant, CommandToken and ChatOpsAccountLink models.

### Fixed

- [#412](https://github.com/nautobot/nautobot-app-chatops/issues/412) - Fixed bulk operations on Grafana views.

### Dependencies

- [#403](https://github.com/nautobot/nautobot-app-chatops/issues/403) - Updated schema-enforcer and termcolor dependencies.

### Housekeeping

- [#384](https://github.com/nautobot/nautobot-app-chatops/issues/384) - Refactored AccessGrant model, ChatOpsAccountLink, CommandLog, CommandToken related UI views to use `NautobotUIViewSet` and `UI component framework`.
- [#394](https://github.com/nautobot/nautobot-app-chatops/issues/394) - Refactored GrafanaDashboard related UI views to use `NautobotUIViewSet` and `UI component framework`.
- Rebaked from the cookie `nautobot-app-v2.7.0`.
- Rebaked from the cookie `nautobot-app-v2.7.1`.
- Rebaked from the cookie `nautobot-app-v2.7.2`.
