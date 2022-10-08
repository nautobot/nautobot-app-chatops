# v1.2 Release Notes

## [v1.2.0](https://github.com/nautobot/nautobot-plugin-chatops/releases/tag/v1.2.0)

- Replaces Slack client (slack_client) with Slack SDK (https://pypi.org/project/slack-sdk/)
- This update does not require any code changes to the bots that leverage Slack. This does require the update of system requirements on installation.

### Fixes

[#2](https://github.com/nautobot/nautobot-plugin-chatops/issues/2) - Cisco WebEx error on content too large
