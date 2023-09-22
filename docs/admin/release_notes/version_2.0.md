<!-- markdownlint-disable MD024 -->
# v2.0 Release Notes

<!-- towncrier release notes start -->
## [v2.0.3 (2023-09-22)](https://github.com/nautobot/nautobot-plugin-chatops/releases/tag/v2.0.3)

### Added

- [#227](https://github.com/nautobot/nautobot-plugin-chatops/issues/227) - Added some tests for VLAN chatops.

### Fixed

- [#227](https://github.com/nautobot/nautobot-plugin-chatops/issues/227) - Fixed parameters that should be set to None if they have not been defined yet by default.
- [#239](https://github.com/nautobot/nautobot-plugin-chatops/issues/239) - Updated IP Fabric Logo.
- [#241](https://github.com/nautobot/nautobot-plugin-chatops/issues/241) - Remove Grafana Navigation and urls if disabled.
- [#253](https://github.com/nautobot/nautobot-plugin-chatops/issues/253) - Sorted the ICMP types from IP Fabric diagrams package.

## [v2.0.2 (2023-08-11)](https://github.com/nautobot/nautobot-plugin-chatops/releases/tag/v2.0.2)

### Changed

- [#233](https://github.com/nautobot/nautobot-plugin-chatops/pull/233) - Fixed App initialization when `[grafana]` extra is not installed.

## [v2.0.1 (2023-08-08)](https://github.com/nautobot/nautobot-plugin-chatops/releases/tag/v2.0.1)

### Changed

- [#228](https://github.com/nautobot/nautobot-plugin-chatops/issues/228) - Move Contributing Changelog Fragments higher in documentation

## [v2.0.0 (2023-08-02)](https://github.com/nautobot/nautobot-plugin-chatops/releases/tag/v2.0.0)

### Added

- [#67](https://github.com/nautobot/nautobot-plugin-chatops/issues/67) - Added the ability within Slack to mention the chat bot by name in a channel and in threads.
- [#194](https://github.com/nautobot/nautobot-plugin-chatops/issues/194) - Added Mattermost container for the development.
- [#194](https://github.com/nautobot/nautobot-plugin-chatops/issues/194) - Improved invoke tasks.
- [#197](https://github.com/nautobot/nautobot-plugin-chatops/issues/197) - Add a try/except block and error logger message when access_token missing from get_token() response.
- [#202](https://github.com/nautobot/nautobot-plugin-chatops/issues/202) - Added Ansible integration from nautobot-plugin-chatops-ansible.
- [#203](https://github.com/nautobot/nautobot-plugin-chatops/issues/203) - Added IP Fabric integration from nautobot-plugin-chatops-ipfabric.
- [#204](https://github.com/nautobot/nautobot-plugin-chatops/issues/204) - Added Arista CloudVision integration from nautobot-plugin-chatops-arista-cloudvision.
- [#205](https://github.com/nautobot/nautobot-plugin-chatops/issues/205) - Added Cisco Meraki integration from nautobot-plugin-chatops-meraki.
- [#206](https://github.com/nautobot/nautobot-plugin-chatops/issues/206) - Added Cisco ACI integration from nautobot-plugin-chatops-aci.
- [#207](https://github.com/nautobot/nautobot-plugin-chatops/issues/207) - Added Panorama integration from nautobot-plugin-chatops-panorama
- [#208](https://github.com/nautobot/nautobot-plugin-chatops/issues/208) - Added Grafana integration from nautobot-plugin-chatops-grafana.

### Changed

- [#67](https://github.com/nautobot/nautobot-plugin-chatops/issues/67) - Modified the clear command to not work within Slack threads.
- [#196](https://github.com/nautobot/nautobot-plugin-chatops/issues/196) - Update to microsoft IPs and correcting the one in the doc.
- [#218](https://github.com/nautobot/nautobot-plugin-chatops/issues/218) - Added `/clear` command to development Mattermost.
- [#218](https://github.com/nautobot/nautobot-plugin-chatops/issues/218) - Improved integration workers loading.
- [#218](https://github.com/nautobot/nautobot-plugin-chatops/issues/218) - Sorted App config and environment variables.
- [#218](https://github.com/nautobot/nautobot-plugin-chatops/issues/218) - Sorted pyproject configurations.

### Removed

- Removed support for Python 3.7
