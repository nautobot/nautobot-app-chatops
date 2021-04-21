# nautobot-chatops

A multi-platform ChatOps bot plugin for [Nautobot](https://github.com/nautobot/nautobot).

- Support for multiple chat platforms (currently Slack, Microsoft Teams, and WebEx Teams)
- Write a command once and run it on every supported platform, including rich content formatting
- Extensible - other Nautobot plugins can provide additional commands which will be dynamically discovered.
- Automatic generation of basic help menus (accessed via `help`, `/command help`, or `/command sub-command help`)
- Metrics of command usage via the `nautobot_capacity_metrics` plugin.

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
