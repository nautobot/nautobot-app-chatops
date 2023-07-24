# Palo Alto Panorama Integration Setup

This guide will walk you through steps to set up Palo Alto Panorama integration with the `nautobot_chatops` App.

## Prerequisites

Before configuring the integration, please ensure the following:

- `nautobot-chatops` App was [installed with integration extra dependencies](./index.md#installation-guide).
    ```shell
    pip install nautobot-chatops[panorama]
    ```
- `nautobot-chatops` App is set up with at least one [enabled chat platform](./index.md#chat-platforms-configuration) and [tested](./index.md#test-your-chatbot).

## Command Setup

Create a top-level command named `panorama` in your enabled chat platform. For detailed instructions related to your specific chat platform, refer to the [platform specific set up](./index.md#chat-platforms-configuration).

## Configuration

You must define the following values in your `nautobot_config.py` file:

| Configuration Setting | Mandatory? | Default |
| ---------------------- | ---------- | ------- |
| `enable_panorama` | **Yes** | False |
| `panorama_host` | **Yes** | |
| `panorama_password` | **Yes** | |
| `panorama_user` | **Yes** | |

Below is an example snippet from `development/nautobot_config.py` that demonstrates how to enable and configure Palo Alto Panorama integration:

```python
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
        ...
        "enable_panorama": True,
        "panorama_host": os.environ.get("PANORAMA_HOST"),
        "panorama_password": os.environ.get("PANORAMA_PASSWORD"),
        "panorama_user": os.environ.get("PANORAMA_USER"),
    }
}
```

## Upgrading from `nautobot-plugin-chatops-panorama` App

!!! warning
    When upgrading from `nautobot-plugin-chatops-panorama` App, it's necessary to [avoid conflicts](index.md#potential-apps-conflicts).

- Uninstall the old App:
    ```shell
    pip uninstall nautobot-plugin-chatops-panorama
    ```
- Upgrade the App with required extras:
    ```shell
    pip install --upgrade nautobot-chatops[panorama]
    ```
- Fix `nautobot_config.py` by removing `nautobot_plugin_chatops_panorama` from `PLUGINS` and merging App configuration into `nautobot_chatops`:
    ```python
    PLUGINS = [
        "nautobot_chatops",
        # "nautobot_plugin_chatops_panorama"  # REMOVE THIS LINE
    ]

    PLUGINS_CONFIG = {
        # "nautobot_plugin_chatops_panorama": {  REMOVE THIS APP CONFIGURATION
        #     MOVE FOLLOWING LINES TO `nautobot_chatops` SECTION
        #     "panorama_host": os.environ.get("PANORAMA_HOST"),
        #     "panorama_user": os.environ.get("PANORAMA_USER"),
        #     "panorama_password": os.environ.get("PANORAMA_PASSWORD"),
        # }
        "nautobot_chatops": {
            # Enable Palo Alto Panorama integration
            "enable_panorama": True,
            # Following lines are moved from `nautobot_plugin_chatops_panorama`
            "panorama_host": os.environ.get("PANORAMA_HOST"),
            "panorama_password": os.environ.get("PANORAMA_PASSWORD"),
            "panorama_user": os.environ.get("PANORAMA_USER"),
        }
    }
    ```

Environment variables for this integration are the same for both, old and new configuration.
