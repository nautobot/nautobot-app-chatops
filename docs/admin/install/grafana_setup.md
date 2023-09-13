# Grafana Integration Setup

This guide will walk you through steps to set up Grafana integration with the `nautobot_chatops` App.

## Prerequisites

Before configuring the integration, please ensure the following:

- `nautobot-chatops` App was [installed with integration extra dependencies](./index.md#installation-guide).
    ```shell
    pip install nautobot-chatops[grafana]
    ```
- `nautobot-chatops` App is set up with at least one [enabled chat platform](./index.md#chat-platforms-configuration) and [tested](./index.md#test-your-chatbot).
- [Grafana](https://grafana.com/docs/grafana/latest/installation/) application installed and configured with dashboards and panels.
- [Grafana Image Rendering Service](https://grafana.com/docs/grafana/latest/administration/image_rendering/) installed.
- [Grafana Image Rending Plugin for Grafana](https://grafana.com/grafana/plugins/grafana-image-renderer/) installed in your Grafana application.

## Command Setup

Create a top-level command named `grafana` in your enabled chat platform. For detailed instructions related to your specific chat platform, refer to the [platform specific set up](./index.md#chat-platforms-configuration).

## Configuration

You must define the following values in your `nautobot_config.py` file:

| Configuration Setting | Mandatory? | Default | Notes |
| --------------------- | ---------- | ------- | ----- |
| `enable_grafana` | **Yes** | False | Enable Grafana integration. |
| `grafana_url` | **Yes** | | Base url that the Grafana application is hosted at. |
| `grafana_api_key` | **Yes** | | Found in `<grafana_url>/org/apikeys`. |
| `grafana_default_width` | | 0 | Grafana image width when rendered into the chat client. Default will render width dynamically. |
| `grafana_default_height` | | 0 | Grafana image height when rendered into the chat client. Default will render height dynamically. |
| `grafana_default_theme` | | dark | Theme color to use when generating rendered Grafana images. Options are [`dark`, `light`]. |
| `grafana_default_timespan` | | 0 | Timespan that data is collected on a panel in Grafana. Default action is to use the defined timespan in Grafana. |
| `grafana_org_id` | | 1 | Found in `<grafana_url>/admin/orgs`. |
| `grafana_default_tz` | | | Timezone in which the renderer will render charts and graphs in. |

!!! note
   Grafana API key only needs to have `Viewer` permissions assigned!

Below is an example snippet from `development/nautobot_config.py` that demonstrates how to enable and configure Grafana integration:

```python
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
        ...
        "enable_grafana": True,
        "grafana_url": os.environ.get("GRAFANA_URL", ""),
        "grafana_api_key": os.environ.get("GRAFANA_API_KEY", ""),
        "grafana_default_width": 0,
        "grafana_default_height": 0,
        "grafana_default_theme": "dark",
        "grafana_default_timespan": "0",
        "grafana_org_id": 1,
        "grafana_default_tz": "America/Denver",
    }
}
```

## Upgrading from `nautobot-plugin-chatops-grafana` App

!!! warning
    When upgrading from `nautobot-plugin-chatops-grafana` App, it's necessary to [avoid conflicts](index.md#potential-apps-conflicts).

- Uninstall the old App:
    ```shell
    pip uninstall nautobot-plugin-chatops-grafana
    ```
- Upgrade the App with required extras:
    ```shell
    pip install --upgrade nautobot-chatops[grafana]
    ```
- Fix `nautobot_config.py` by removing `nautobot_plugin_chatops_grafana` from `PLUGINS` and merging App configuration into `nautobot_chatops`:
    ```python
    PLUGINS = [
        "nautobot_chatops",
        # "nautobot_plugin_chatops_grafana"  # REMOVE THIS LINE
    ]

    PLUGINS_CONFIG = {
        # "nautobot_plugin_chatops_grafana": {  REMOVE THIS APP CONFIGURATION
        #     MOVE FOLLOWING LINES TO `nautobot_chatops` SECTION, PREFIX ENV VARIABLES WITH `GRAFANA_`
        #     "grafana_url": os.environ.get("GRAFANA_URL", ""),
        #     "grafana_api_key": os.environ.get("GRAFANA_API_KEY", ""),
        #     "default_width": 0,
        #     "default_height": 0,
        #     "default_theme": "dark",
        #     "default_timespan": "0",
        #     "grafana_org_id": 1,
        #     "default_tz": "America/Denver",
        # }
        "nautobot_chatops": {
            # Enable Grafana integration
            "enable_grafana": True,
            # Following line is moved from `nautobot_plugin_chatops_grafana`
            "grafana_url": os.environ.get("GRAFANA_URL", ""),
            "grafana_api_key": os.environ.get("GRAFANA_API_KEY", ""),
            "grafana_default_width": 0,
            "grafana_default_height": 0,
            "grafana_default_theme": "dark",
            "grafana_default_timespan": "0",
            "grafana_org_id": 1,
            "grafana_default_tz": "America/Denver",
        }
    }
    ```

!!! note
    All environment variables for this integration are now prefixed with `GRAFANA_`. Remember to update your environment variables depending on your deployment.
