# Changelog - Nautobot Plugin Chatops

## 1.8.0

### Additions

Adds support For Nautobot 1.3

### Removes

Nautobot 1.0.x support
Python 3.6 support

## v1.7.0

### Additions

(#123) Adds export button of command usage
(#128) Adds QOL change for focusing of fields

### Fixes

(#129) Fixes errors on private messages
(#128) Access grants updates

## v1.6.0

### Additions

(#123) Added export button for chat command usage as CSV
(#120) Added `send_all_messages_private` setting

## v1.5.1

(#97) Fixes MS Teams Bold markdown. Moves from **<text>** to *<text>* to align with guides from Microsoft

## v1.5.0

### Updates

- Introduced support for MySQL database backends
- Introduced support for Nautobot Celery workers

### Fixes

#17 - Error with filtering by empty regions, no message back

## v1.4.1

### Updates

Minor update to better handle the versioning. This fixes an issue where the version number within Nautobot was not updated alongside the pyproject.toml.

## v1.4.0

Updates Nautobot Chatops name for Webex Teams to Webex. As part of Cisco's renaming of Webex Teams to just Webex, the underlying configuration was updated.

### Fixes

(#68) Correct var names for Nautobot
(#61) Mattermost sending interactive Dialog

### Updates

(#63) Add additional Breadcrumbs
(#24) Rename Webex Teams to Webex

## v1.3.1

### Fixes
(#54) Reverted pinning of cryptography

## v1.3.0

Updates to pyjwt to address concerns with other dependencies in the Nautobot ecosystem.

### Updates

Updates pyjwt from 1.7.1 minimum to 2.1
Adds cryptography as separate requirement

## v1.2.0

- Replaces Slack client (slack_client) with Slack SDK (https://pypi.org/project/slack-sdk/)
- This update does not require any code changes to the bots that leverage Slack. This does require the update of system requirements on installation.

### Fixes
#2 - Cisco WebEx error on content too large

## v1.1.0

### What's New

Slack handling of list items > 100 items, now including a next option in the drop down list to get more options #10

### Bug Fixes
Updated MS Teams Zip File #29
Fix connection filter ordering #23

## v1.0.1

### FIXES

Fix issue with new Status field

## v1.0.0

Initial Release
