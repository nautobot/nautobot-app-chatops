# v4.2 Release Notes

This document describes all new features and changes in the release. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Release Overview

- Major features or milestones
- Changes to compatibility with Nautobot and/or other apps, libraries etc.

<!-- towncrier release notes start -->

## [v4.2.0 (2026-11-18)](https://github.com/nautobot/nautobot-app-chatops/releases/tag/v4.2.0)

### Breaking Changes

- [#464](https://github.com/nautobot/nautobot-app-chatops/issues/464) - Moved the `nautobot_command_library` metric from `/api/plugins/capacity-metrics/app-metrics` to the Nautobot core `/metrics` endpoint. Set `METRICS_ENABLED = True`, update the Prometheus scrape job, and remove `nautobot_capacity_metrics` from `PLUGINS` if the package is not installed.

### Changed

- [#459](https://github.com/nautobot/nautobot-app-chatops/issues/459) - Changed `/ipfabric table-diff` to list the tables provided by the installed `ipfabric` SDK instead of a fixed list.

### Removed

- [#459](https://github.com/nautobot/nautobot-app-chatops/issues/459) - Removed the `errors` and `drops` metrics from `/ipfabric interfaces` because IP Fabric no longer provides interface error and drop rates through its API.
- [#464](https://github.com/nautobot/nautobot-app-chatops/issues/464) - Removed the `nautobot-capacity-metrics` dependency.

### Fixed

- [#459](https://github.com/nautobot/nautobot-app-chatops/issues/459) - Fixed `ipfabric` dependency conflict with `nautobot-ssot[ipfabric]` by allowing `ipfabric` SDK versions 7.x and 8.x.
- [#463](https://github.com/nautobot/nautobot-app-chatops/issues/463) - Fixed `meraki` dependency conflict with `nautobot-ssot[meraki]` by allowing `meraki` 3.x on Python 3.11 and later.

### Documentation

- [#459](https://github.com/nautobot/nautobot-app-chatops/issues/459) - Documented that the `ipfabric` SDK major version must match the IP Fabric server version.
- [#464](https://github.com/nautobot/nautobot-app-chatops/issues/464) - Added metrics install and upgrade notes.
