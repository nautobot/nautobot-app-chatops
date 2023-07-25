# Nautobot ChatOps

<p align="center">
  <img src="https://raw.githubusercontent.com/nautobot/nautobot-plugin-chatops/develop/docs/assets/icon-ChatOps.png" alt="ChatOps Logo" class="logo" height="200px">
  <br>
  <a href="https://github.com/nautobot/nautobot-plugin-chatops/actions"><img src="https://github.com/nautobot/nautobot-plugin-chatops/actions/workflows/ci.yml/badge.svg?branch=main"></a>
  <a href="https://docs.nautobot.com/projects/chatops/en/latest"><img src="https://readthedocs.org/projects/nautobot-plugin-chatops/badge/"></a>
  <a href="https://pypi.org/project/nautobot-chatops/"><img src="https://img.shields.io/pypi/v/nautobot-chatops"></a>
  <a href="https://pypi.org/project/nautobot-chatops/"><img src="https://img.shields.io/pypi/dm/nautobot-chatops"></a>
  <br>
  A multi-platform ChatOps bot App for <a href="https://github.com/nautobot/nautobot">Nautobot</a>.
</p>

- Support for multiple chat platforms:
    - Mattermost
    - Microsoft Teams
    - Slack
    - Cisco Webex
- Support for multiple integrations:
    - Cisco ACI
    - AWX / Ansible Tower
    - Arista CloudVision
    - Grafana
    - IPFabric
    - Cisco Meraki
    - Palo Alto Panorama
- Write a command once and run it on every supported platform, including rich content formatting.
- Extensible - other Nautobot plugins can provide additional commands which will be dynamically discovered.
- Automatic generation of basic help menus (accessed via `help`, `/command help`, or `/command sub-command help`).
- Metrics of command usage via the `nautobot_capacity_metrics` plugin.

## Documentation

Full web-based HTML documentation for this app can be found over on the [Nautobot Docs](https://docs.nautobot.com/projects/chatops/en/latest/) website:

- [User Guide](https://docs.nautobot.com/projects/chatops/en/latest/user/app_overview/) - Overview, Using the App, Getting Started
- [Administrator Guide](https://docs.nautobot.com/projects/chatops/en/latest/admin/install/) - How to Install, Configure, Upgrade, or Uninstall the App.
- [Developer Guide](https://docs.nautobot.com/projects/chatops/en/latest/dev/contributing/) - Extending the App, Code Reference, Contribution Guide.
- [Release Notes / Changelog](https://docs.nautobot.com/projects/chatops/en/latest/admin/release_notes/)
- [Frequently Asked Questions](https://docs.nautobot.com/projects/chatops/en/latest/user/app_faq/)
- [Glossary](https://docs.nautobot.com/projects/chatops/en/latest/glossary/)

## Try it Out

Interested to see Nautobot ChatOps in action?  It's currently setup on the [Demo Instance](https://demo.nautobot.com/) and integrated into [NTC Slack](https://slack.networktocode.com).  You can sign up for that Slack workspace and join the `#nautobot-chat` channel to understand what this bot can do and try it for yourself.  You can try these exact chat commands and many more:

### Command: `/nautobot`

![image](https://user-images.githubusercontent.com/6332586/118281576-5db4e980-b49b-11eb-8574-1332ed4b9757.png)

### Command: `/nautobot get-devices`

![image](https://user-images.githubusercontent.com/6332586/118281772-95239600-b49b-11eb-9c79-e2040dc4a982.png)

### Command: `/nautobot get-interface-connections`

![image](https://user-images.githubusercontent.com/6332586/118281976-ca2fe880-b49b-11eb-87ad-2a41eaa168ed.png)

## Questions

For any questions or comments, please check the [FAQ](https://docs.nautobot.com/projects/chatops/en/latest/user/app_faq/) first and feel free to swing by the [Network to Code slack channel](https://networktocode.slack.com/) (channel #nautobot).
Sign up [here](https://slack.networktocode.com/)

## Acknowledgements

This project includes code originally written in separate plugins, which have been merged into this project:

- [nautobot-plugin-chatops-aci](https://github.com/nautobot/nautobot-plugin-chatops-aci):
    Thanks
    [@mamullen13316](https://github.com/mamullen13316),
    [@smk4664](https://github.com/smk4664),
    [@ubajze](https://github.com/ubajze),
    [@whitej6](https://github.com/whitej6),
- [nautobot-plugin-chatops-ansible](https://github.com/nautobot/nautobot-plugin-chatops-ansible):
    Thanks
    [@chipn](https://github.com/chipn),
    [@dgjustice](https://github.com/dgjustice),
    [@jeffkala](https://github.com/jeffkala),
    [@jvanderaa](https://github.com/jvanderaa),
    [@matt852](https://github.com/matt852),
    [@smk4664](https://github.com/smk4664),
    [@ubajze](https://github.com/ubajze),
    [@whitej6](https://github.com/whitej6),
- [nautobot-plugin-chatops-arista-cloudvision](https://github.com/nautobot/nautobot-plugin-chatops-arista-cloudvision):
    Thanks
    [@qduk](https://github.com/qduk),
    [@ubajze](https://github.com/ubajze),
    [@whitej6](https://github.com/whitej6),
- [nautobot-plugin-chatops-grafana](https://github.com/nautobot/nautobot-plugin-chatops-grafana):
    Thanks
    [@jedelman8](https://github.com/jedelman8),
    [@josh-silvas](https://github.com/josh-silvas),
    [@nniehoff](https://github.com/nniehoff),
    [@tim-fiola](https://github.com/tim-fiola),
    [@ubajze](https://github.com/ubajze),
    [@whitej6](https://github.com/whitej6),
- [nautobot-plugin-chatops-ipfabric](https://github.com/nautobot/nautobot-plugin-chatops-ipfabric):
    Thanks
    [@alhogan](https://github.com/alhogan),
    [@chadell](https://github.com/chadell),
    [@chipn](https://github.com/chipn),
    [@justinjeffery-ipf](https://github.com/justinjeffery-ipf),
    [@nniehoff](https://github.com/nniehoff),
    [@pke11y](https://github.com/pke11y),
    [@scetron](https://github.com/scetron),
    [@smk4664](https://github.com/smk4664),
    [@ubajze](https://github.com/ubajze),
    [@whitej6](https://github.com/whitej6),
- [nautobot-plugin-chatops-meraki](https://github.com/nautobot/nautobot-plugin-chatops-meraki):
    Thanks
    [@jedelman8](https://github.com/jedelman8),
    [@jeffkala](https://github.com/jeffkala),
    [@qduk](https://github.com/qduk),
    [@tim-fiola](https://github.com/tim-fiola),
    [@ubajze](https://github.com/ubajze),
    [@whitej6](https://github.com/whitej6),
- [nautobot-plugin-chatops-panorama](https://github.com/nautobot/nautobot-plugin-chatops-panorama):
    Thanks
    [@FragmentedPacket](https://github.com/FragmentedPacket),
    [@PhillSimonds](https://github.com/PhillSimonds),
    [@armartirosyan](https://github.com/armartirosyan),
    [@itdependsnetworks](https://github.com/itdependsnetworks),
    [@jamesholland-uk](https://github.com/jamesholland-uk),
    [@jdrew82](https://github.com/jdrew82),
    [@matt852](https://github.com/matt852),
    [@qduk](https://github.com/qduk),
    [@ubajze](https://github.com/ubajze),
    [@whitej6](https://github.com/whitej6),
