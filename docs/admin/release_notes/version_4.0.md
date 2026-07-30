# v4.0 Release Notes

This document describes all new features and changes in the release. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Release Overview

This major release marks the compatibility of the ChatOps App with Nautobot 3.0.0. Check out the [full details](https://docs.nautobot.com/projects/core/en/stable/release-notes/version-3.0/) of the changes included in this new major release of Nautobot. Highlights:

* Minimum Nautobot version supported is 3.0.
* Added support for Python 3.13 and removed support for 3.9.
* Updated UI framework to use latest Bootstrap 5.3.

We will continue to support the previous major release for users of Nautobot LTM 2.4 only with critical bug and security fixes as per the [Software Lifecycle Policy](https://networktocode.com/company/legal/software-lifecycle-policy/).

<!-- towncrier release notes start -->

## [v4.0.3 (2026-07-29)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v4.0.3)

### Added

- [#421](https://github.com/nautobot/nautobot-app-chatops/issues/421) - Add Slack token rotation support.

### Dependencies

- Updated the `aristacv` (Arista CloudVision) extra to require `cloudvision>=1.25` and `protobuf>=5,<6`, and migrated the CloudVision device-tag lookup from the `arista.tag.v1` to the `arista.tag.v2` API, restoring compatibility with Nautobot 3.2, which requires protobuf 5.

### Housekeeping

- [#428](https://github.com/nautobot/nautobot-app-chatops/issues/428) - Removed duplicate pull request template file.

## [v4.0.2 (2026-06-26)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v4.0.2)

### Fixed

- [#438](https://github.com/nautobot/nautobot-app-chatops/issues/438) - Fixed `grafana_default_timespan` to be 0 if not provided.

### Documentation

- Fixed some typos in the documentation and module docstrings.

## [v4.0.1 (2026-05-26)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v4.0.1)

### Removed

- [#417](https://github.com/nautobot/nautobot-app-chatops/issues/417) - Removed former employee from codeowners and cookiecutter.

### Housekeeping

- [#432](https://github.com/nautobot/nautobot-app-chatops/issues/432) - Housekeeping for deprecated dependency: pkg_resources and prybar.
- Rebaked from the cookie `nautobot-app-v3.0.0`.
- Rebaked from the cookie `nautobot-app-v3.1.3`.

## [v4.0.0 (2025-11-24)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v4.0.0)

### Added

- Added support for Nautobot 3.0.
- Added support for Python 3.13.

### Fixed

- [#408](https://github.com/nautobot/nautobot-app-chatops/issues/408) - Fixed bulk operations on Grafana views.

## [v4.0.0a1 (2025-11-14)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v4.0.0a1)
