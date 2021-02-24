# nautobot-chatops

A multi-platform ChatOps bot plugin for [Nautobot](https://github.com/nautobot/nautobot).

- Support for multiple chat platforms (currently Slack, Microsoft Teams, and WebEx Teams)
- Write a command once and run it on every supported platform, including rich content formatting
- Extensible - other Nautobot plugins can provide additional commands which will be dynamically discovered.
- Automatic generation of basic help menus (accessed via `help`, `/command help`, or `/command sub-command help`)
- Metrics of command usage via the `nautobot_capacity_metrics` plugin.

## Installation

The plugin is available as a Python package in pypi and can be installed with pip
```shell
pip install nautobot-chatops
```

> The plugin is compatible with Nautobot 1.0.0beta1 and higher

Once installed, the plugin needs to be enabled in your `nautobot_config.py`
```python
# In your nautobot_config.py
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
         #     ADD YOUR SETTINGS HERE
    }
}
```

Nautobot supports `Slack`, `MS Teams` and `Webex Teams` as backends but by default all of them are disabled. You need to explicitly enable the chat platform(s) that you want to use in the `PLUGINS_CONFIG` with one or more of `enable_slack`, `enable_ms_teams` or `enable_webex_teams`. 

The plugin behavior can be controlled with the following list of general settings:

| Configuration Setting        | Description | Mandatory? | Default |
| ---------------------------- | ----------- | ---------- | ------- |
| `delete_input_on_submission` | After prompting the user for additional inputs, delete the input prompt from the chat history | No | `False` |

For details on the platform-specific settings needed to enable Nautobot for the chat platform(s) of your choice, refer to [the documentation](docs/chat_setup.md).

## Documentation

- [Installation Guide](docs/chat_setup.md)
- [Design](docs/design.md)
- [Contributing](docs/contributing.md)
- [FAQ](docs/FAQ.md)

## Contributing

Thank you for your interest in helping to improve Nautobot!
Refer to the [contributing guidelines](docs/contributing.md) for details.

## Questions

For any questions or comments, please check the [FAQ](docs/FAQ.md) first and feel free to swing by the [Network to Code slack channel](https://networktocode.slack.com/) (channel #nautobot).
Sign up [here](http://slack.networktocode.com/)
