# IPFabric Integration Setup

This guide will walk you through steps to set up IPFabric integration with the `nautobot_chatops` App.

## Prerequisites

Before configuring the integration, please ensure the following:

- `nautobot-chatops` App was [installed with integration extra dependencies](./index.md#installation-guide).
    ```shell
    pip install nautobot-chatops[ipfabric]
    ```
- `nautobot-chatops` App is set up with at least one [enabled chat platform](./index.md#chat-platforms-configuration) and [tested](./index.md#test-your-chatbot).

## Version Matrix

Here is a compatibility matrix and the minimum versions required to run this plugin:

| IP Fabric | Python | Nautobot | chatops | chatops-ipfabric | [python-ipfabric](https://github.com/community-fabric/python-ipfabric) | [python-ipfabric-diagrams](https://github.com/community-fabric/python-ipfabric-diagrams) |
|-----------|--------|----------|---------|------------------|------------------------------------------------------------------------|------------------------------------------------------------------------------------------|
| 4.4 | 3.7.1 | 1.1.0 | 1.1.0 | 1.2.0 | 0.11.0 | 1.2.7 |
| 5.0.1 | 3.7.1 | 1.1.0 | 1.1.0 | 1.3.0 | 5.0.4 | 5.0.2 |
| 6.0 | 3.7.1 | 1.4.0 | 1.1.0 | 3.0.0 | 6.0.9 | 6.0.2
| 6.0 | 3.7.2 | 1.4.0 | 1.3.0 | DISABLE | 6.0.9 | 6.0.2

## Command Setup

Create a top-level command named `ipfabric` in your enabled chat platform. For detailed instructions related to your specific chat platform, refer to the [platform specific set up](./index.md#chat-platforms-configuration).

## Configuration

You must define the following values in your `nautobot_config.py` file:

| Configuration Setting | Mandatory? | Default |
| ---------------------- | ---------- | ------- |
| `enable_ipfabric` | **Yes** | False |
| `ipfabric_api_token` | **Yes** | |
| `ipfabric_host` | **Yes** | |
| `ipfabric_timeout` | | |
| `ipfabric_verify` | | True |

Below is an example snippet from `development/nautobot_config.py` that demonstrates how to enable and configure IPFabric integration:

```python
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
        ...
        "enable_ipfabric": True,
        "ipfabric_api_token": os.environ.get("IPFABRIC_API_TOKEN"),
        "ipfabric_host": os.environ.get("IPFABRIC_HOST"),
        "ipfabric_timeout": os.environ.get("IPFABRIC_TIMEOUT", 15),
        "ipfabric_verify": is_truthy(os.environ.get("IPFABRIC_VERIFY", True)),
    }
}
```

## Upgrading from `nautobot-plugin-chatops-ipfabric` App

!!! warning
    When upgrading from `nautobot-plugin-chatops-ipfabric` App, it's necessary to [avoid conflicts](index.md#potential-apps-conflicts).

- Uninstall the old App:
    ```shell
    pip uninstall nautobot-plugin-chatops-ipfabric
    ```
- Upgrade the App with required extras:
    ```shell
    pip install --upgrade nautobot-chatops[ipfabric]
    ```
- Fix `nautobot_config.py` by removing `nautobot_plugin_chatops_ipfabric` from `PLUGINS` and merging App configuration into `nautobot_chatops`:
    ```python
    PLUGINS = [
        "nautobot_chatops",
        # "nautobot_plugin_chatops_ipfabric"  # REMOVE THIS LINE
    ]

    PLUGINS_CONFIG = {
        # "nautobot_plugin_chatops_ipfabric": {  REMOVE THIS APP CONFIGURATION
        #     MOVE AND RENAME FOLLOWING ITEMS:
        #     "IPFABRIC_API_TOKEN": os.environ.get("IPFABRIC_API_TOKEN"),
        #     "IPFABRIC_HOST": os.environ.get("IPFABRIC_HOST"),
        #     "IPFABRIC_VERIFY": os.environ.get("IPFABRIC_VERIFY", True),
        # }
        "nautobot_chatops": {
            # Enable IPFabric integration
            "enable_ipfabric": True,
            # Following lines are moved from `nautobot_plugin_chatops_ipfabric`
            "ipfabric_api_token": os.environ.get("IPFABRIC_API_TOKEN"),
            "ipfabric_host": os.environ.get("IPFABRIC_HOST"),
            "ipfabric_timeout": os.environ.get("IPFABRIC_TIMEOUT", 15),
            "ipfabric_verify": is_truthy(os.environ.get("IPFABRIC_VERIFY", True)),
        }
    }
    ```

!!! warning
    Configuration keys for IPFabric integration are now lowercased, compared to the old plugin.

Environment variables for this integration are the same for both, old and new configuration.
