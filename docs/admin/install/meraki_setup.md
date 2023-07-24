# Cisco Meraki Integration Setup

This guide will walk you through steps to set up Cisco Meraki integration with the `nautobot_chatops` App.

## Prerequisites

Before configuring the integration, please ensure the following:

- `nautobot-chatops` App was [installed with integration extra dependencies](./index.md#installation-guide).
    ```shell
    pip install nautobot-chatops[meraki]
    ```
- `nautobot-chatops` App is set up with at least one [enabled chat platform](./index.md#chat-platforms-configuration) and [tested](./index.md#test-your-chatbot).

## Command Setup

Create a top-level command named `meraki` in your enabled chat platform. For detailed instructions related to your specific chat platform, refer to the [platform specific set up](./index.md#chat-platforms-configuration).

## Configuration

You must define the following values in your `nautobot_config.py` file:

| Configuration Setting | Mandatory? | Default |
| --------------------- | ---------- | ------- |
| `enable_meraki` | **Yes** | False |
| `meraki_dashboard_api_key` | **Yes** | |

Below is an example snippet from `development/nautobot_config.py` that demonstrates how to enable and configure Cisco Meraki integration:

```python
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
        ...
        "enable_meraki": True,
        "meraki_dashboard_api_key": os.environ.get("MERAKI_API_KEY"),
    }
}
```

The alternative option is to set the environmental variable:

- `MERAKI_DASHBOARD_API_KEY`: Is set to the dashboard API key.

## Upgrading from `nautobot-plugin-chatops-meraki` App

!!! warning
    When upgrading from `nautobot-plugin-chatops-meraki` App, it's necessary to [avoid conflicts](index.md#potential-apps-conflicts).

- Uninstall the old App:
    ```shell
    pip uninstall nautobot-plugin-chatops-meraki
    ```
- Upgrade the App with required extras:
    ```shell
    pip install --upgrade nautobot-chatops[meraki]
    ```
- Fix `nautobot_config.py` by removing `nautobot_plugin_chatops_meraki` from `PLUGINS` and merging App configuration into `nautobot_chatops`:
    ```python
    PLUGINS = [
        "nautobot_chatops",
        # "nautobot_plugin_chatops_meraki"  # REMOVE THIS LINE
    ]

    PLUGINS_CONFIG = {
        # "nautobot_plugin_chatops_meraki": {  REMOVE THIS APP CONFIGURATION
        #     "meraki_dashboard_api_key": <API KEY>  # MOVE THIS LINE TO `nautobot_chatops` SECTION
        # }
        "nautobot_chatops": {
            # Enable Cisco Meraki integration
            "enable_meraki": True,
            # Following line is moved from `nautobot_plugin_chatops_meraki`
            "meraki_dashboard_api_key": os.environ.get("MERAKI_API_KEY"),
        }
    }
    ```
