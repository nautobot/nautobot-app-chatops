# Slurpit Integration Setup

This guide will walk you through steps to set up Slurpit integration with the `nautobot_chatops` App.

## Prerequisites

Before configuring the integration, please ensure the following:

- `nautobot-chatops` App was [installed with integration extra dependencies](../install.md#installation-guide).
    ```shell
    pip install nautobot-chatops[slurpit]
    ```
- `nautobot-chatops` App is set up with at least one [enabled chat platform](../install.md#chat-platforms-configuration) and [tested](./../install.md#test-your-chatbot).

## Command Setup

Create a top-level command named `slurpit` in your enabled chat platform. For detailed instructions related to your specific chat platform, refer to the [platform specific set up](../install.md#chat-platforms-configuration).

## Configuration

You must define the following values in your `nautobot_config.py` file:

| Configuration Setting | Mandatory? | Default | Available on Admin Config |
| --------------------- | ---------- | ------- | ------------------------- |
| `enable_slurpit`      | **Yes**    | False   | Yes                       |
| `slurpit_host`        | **Yes**    |         | No                        |
| `slurpit_token`       | **Yes**    |         | No                        |
| `slurpit_verify`      | **Yes**    |         | No                        |

Below is an example snippet from `development/nautobot_config.py` that demonstrates how to enable and configure Cisco ACI integration:

```python
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
        ...
        "enable_slurpit": True,
        "slurpit_host": os.environ.get("SLURPIT_HOST"),
        "slurpit_token": os.environ.get("SLURPIT_API_TOKEN"),
        "slurpit_verify": is_truthy(os.environ.get("SLURPIT_VERIFY", True)),
    }
}
```

The example configuration is using environment variables. Define these using the following environment variables:

```shell
export SLURPIT_HOST="{{ slurpit Host }}"
export SLURPIT_API_TOKEN="{{ Slurpit API Token }}"
export SLURPIT_VERIFY="{{ True }}"
```