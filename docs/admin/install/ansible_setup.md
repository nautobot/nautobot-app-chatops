# AWX / Ansible Tower Integration Setup

This guide will walk you through steps to set up AWX / Ansible Tower integration with the `nautobot_chatops` App.

## Prerequisites

Before configuring the integration, please ensure the following:

- `nautobot-chatops` App was [installed with integration extra dependencies](./index.md#installation-guide).
    ```shell
    pip install nautobot-chatops[ansible]
    ```
- `nautobot-chatops` App is set up with at least one [enabled chat platform](./index.md#chat-platforms-configuration) and [tested](./index.md#test-your-chatbot).

## Command Setup

Create a top-level command named `ansible` in your enabled chat platform. For detailed instructions related to your specific chat platform, refer to the [platform specific set up](./index.md#chat-platforms-configuration).

## Configuration

You must define the following values in your `nautobot_config.py` file:

```
| Configuration Setting | Mandatory? | Default     |
| --------------------- | ---------- | ----------- |
| `enable_ansible`      | Yes        | False       |
| `tower_password`      | No         |             |
| `tower_uri`           | No         |             |
| `tower_username`      | No         |             |
| `tower_verify_ssl`    | No         | True        |
```

R: Convert each configuration item to a table row with the setting name, whether it is mandatory or not, and the default value if available.

Below is an example snippet from `development/nautobot_config.py` that demonstrates how to enable and configure AWX / Ansible Tower integration:

```python
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
        ...
        "enable_ansible": True,
        "tower_password": os.getenv("NAUTOBOT_TOWER_PASSWORD"),
        "tower_uri": os.getenv("NAUTOBOT_TOWER_URI"),
        "tower_username": os.getenv("NAUTOBOT_TOWER_USERNAME"),
        "tower_verify_ssl": is_truthy(os.getenv("NAUTOBOT_TOWER_VERIFY_SSL", True)),
    }
}
```

## Upgrading from `nautobot-plugin-chatops-ansible` App

!!! warning
    When upgrading from `nautobot-plugin-chatops-ansible` App, it's necessary to [avoid conflicts](index.md#potential-apps-conflicts).

- Uninstall the old App:
    ```shell
    pip uninstall nautobot-plugin-chatops-ansible
    ```
- Upgrade the App with required extras:
    ```shell
    pip install --upgrade nautobot-chatops[ansible]
    ```
- Fix `nautobot_config.py` by removing `nautobot_chatops_ansible` from `PLUGINS` and merging App configuration into `nautobot_chatops`:
    ```python
    PLUGINS = [
        "nautobot_chatops",
        # "nautobot_chatops_ansible"  # REMOVE THIS LINE
    ]

    PLUGINS_CONFIG = {
        # "nautobot_chatops_ansible": {  REMOVE THIS APP CONFIGURATION
        #     MOVE FOLLOWING LINES TO `nautobot_chatops` SECTION
        #     "tower_uri": os.getenv("NAUTOBOT_TOWER_URI"),
        #     "tower_username": os.getenv("NAUTOBOT_TOWER_USERNAME"),
        #     "tower_password": os.getenv("NAUTOBOT_TOWER_PASSWORD"),
        #     "tower_verify_ssl": is_truthy(os.getenv("NAUTOBOT_TOWER_VERIFY_SSL", "true")),
        # }
        "nautobot_chatops": {
            # Enable AWX / Ansible Tower integration
            "enable_ansible": True,
            # Following lines are moved from `nautobot_chatops_ansible`
            "tower_uri": os.getenv("NAUTOBOT_TOWER_URI"),
            "tower_username": os.getenv("NAUTOBOT_TOWER_USERNAME"),
            "tower_password": os.getenv("NAUTOBOT_TOWER_PASSWORD"),
            "tower_verify_ssl": is_truthy(os.getenv("NAUTOBOT_TOWER_VERIFY_SSL", "true")),
        }
    }
    ```

Environment variables for this integration are the same for both, old and new configuration.
