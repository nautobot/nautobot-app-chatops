# NautobotGPT Integration Setup

This guide will walk you through steps to set up NautobotGPT integration with the `nautobot_chatops` App.

## Prerequisites

Before configuring the integration, please ensure the following:

- `nautobot-chatops` App was [installed with integration extra dependencies](../install.md#installation-guide).

```shell
pip install nautobot-chatops[nautobotgpt]
```

- `nautobot-chatops` App is set up with at least one [enabled chat platform](../install.md#chat-platforms-configuration) and [tested](./../install.md#test-your-chatbot).

## Command Setup

Create a top-level command named `nautobotgpt` in your enabled chat platform. For detailed instructions related to your specific chat platform, refer to the [platform specific set up](../install.md#chat-platforms-configuration).

## Configuration

You must define the following values in your `nautobot_config.py` file:

```
| Configuration Setting  | Mandatory? | Default     | Available on Admin Config |
| ---------------------- | ---------- | ----------- | ------------------------- |
| `enable_nautobotgpt`   | Yes        | False       | Yes                       |
| `nautobotgpt_model`    | No         |             | No                        |
| `nautobotgpt_url`      | Yes        |             | No                        |
| `nautobotgpt_username` | Yes        |             | No                        |
| `nautobotgpt_password` | Yes        | True        | No                        |
```

Below is an example snippet from `development/nautobot_config.py` that demonstrates how to enable and configure NautobotGPT integration:

```python
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
        ...
        "enable_nautobotgpt": is_truthy(os.getenv("NAUTOBOT_CHATOPS_ENABLE_NAUTOBOTGPT", True)),
        "nautobotgpt_model": os.getenv("NAUTOBOTGPT_MODEL"),
        "nautobotgpt_url": os.getenv("NAUTOBOTGPT_URL"),
        "nautobotgpt_username": os.getenv("NAUTOBOTGPT_USERNAME"),
        "nautobotgpt_password": os.getenv("NAUTOBOTGPT_PASSWORD"),
    }
}
```
