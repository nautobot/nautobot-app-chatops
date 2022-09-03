# nautobot-chatops

![ChatOps Logo](https://raw.githubusercontent.com/nautobot/nautobot-plugin-chatops/develop/docs/assets/icon-ChatOps.png)

A multi-platform ChatOps bot plugin for [Nautobot](https://github.com/nautobot/nautobot).

- Support for multiple chat platforms (currently Slack, Microsoft Teams, Mattermost, and WebEx)
- Write a command once and run it on every supported platform, including rich content formatting
- Extensible - other Nautobot plugins can provide additional commands which will be dynamically discovered.
- Automatic generation of basic help menus (accessed via `help`, `/command help`, or `/command sub-command help`)
- Metrics of command usage via the `nautobot_capacity_metrics` plugin.

## Documentation

Full web-based HTML documentation for this app can be found over on the [Nautobot Docs](https://docs.nautobot.com/projects/chatops/en/latest/) website:

- [User Guide](https://docs.nautobot.com/projects/chatops/en/latest/user/app_overview/) - Overview, Using the App, Getting Started
- [Administrator Guide](https://docs.nautobot.com/projects/chatops/en/latest/admin/admin_install/) - How to Install, Configure, Upgrade, or Uninstall the App.
- [Developer Guide](https://docs.nautobot.com/projects/chatops/en/latest/dev/dev_contributing/) - Extending the App, Code Reference, Contribution Guide.
- [Release Notes / Changelog](https://docs.nautobot.com/projects/chatops/en/latest/admin/release_notes/)
- [Frequently Asked Questions](https://docs.nautobot.com/projects/chatops/en/latest/user/app_faq/)

## Try it Out

Interested to see Nautobot ChatOps in action?  It's currently setup on the [Demo Instance](https://demo.nautobot.com/) and integrated into [NTC Slack](slack.networktocode.com).  You can sign up for that Slack workspace and join the `#nautobot-chat` channel to understand what this bot can do and try it for yourself.  You can try these exact chat commands and many more:

### Command: `/nautobot`

![image](https://user-images.githubusercontent.com/6332586/118281576-5db4e980-b49b-11eb-8574-1332ed4b9757.png)

### Command: `/nautobot get-devices`

![image](https://user-images.githubusercontent.com/6332586/118281772-95239600-b49b-11eb-9c79-e2040dc4a982.png)

### Command: `/nautobot get-interface-connections`

![image](https://user-images.githubusercontent.com/6332586/118281976-ca2fe880-b49b-11eb-87ad-2a41eaa168ed.png)

## Questions

For any questions or comments, please check the [FAQ](docs/FAQ.md) first and feel free to swing by the [Network to Code slack channel](https://networktocode.slack.com/) (channel #nautobot).
Sign up [here](http://slack.networktocode.com/)
