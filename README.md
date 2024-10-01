# Nautobot ChatOps App

<p align="center">
  <img src="https://raw.githubusercontent.com/nautobot/nautobot-app-chatops/develop/docs/assets/icon-ChatOps.png" alt="ChatOps Logo" class="logo" height="200px">
  <br>
  <a href="https://github.com/nautobot/nautobot-app-chatops/actions"><img src="https://github.com/nautobot/nautobot-app-chatops/actions/workflows/ci.yml/badge.svg?branch=main"></a>
  <a href="https://docs.nautobot.com/projects/chatops/en/latest/"><img src="https://readthedocs.org/projects/nautobot-plugin-chatops/badge/"></a>
  <a href="https://pypi.org/project/nautobot-chatops/"><img src="https://img.shields.io/pypi/v/nautobot-chatops"></a>
  <a href="https://pypi.org/project/nautobot-chatops/"><img src="https://img.shields.io/pypi/dm/nautobot-chatops"></a>
  <br>
  An <a href="https://networktocode.com/nautobot-apps/">App</a> for <a href="https://nautobot.com/">Nautobot</a>.
</p>

## Overview

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
- Extensible - other Nautobot apps can provide additional commands which will be dynamically discovered.
- Automatic generation of basic help menus (accessed via `help`, `/command help`, or `/command sub-command help`).
- Metrics of command usage via the `nautobot_capacity_metrics` app.

### Screenshots

#### Command: `/nautobot`

![image](https://user-images.githubusercontent.com/6332586/118281576-5db4e980-b49b-11eb-8574-1332ed4b9757.png)

#### Command: `/nautobot get-devices`

![image](https://user-images.githubusercontent.com/6332586/118281772-95239600-b49b-11eb-9c79-e2040dc4a982.png)

#### Command: `/nautobot get-interface-connections`

![image](https://user-images.githubusercontent.com/6332586/118281976-ca2fe880-b49b-11eb-87ad-2a41eaa168ed.png)

## Try it out!

This App is installed in the Nautobot Community Sandbox found over at [demo.nautobot.com](https://demo.nautobot.com/)!

> For a full list of all the available always-on sandbox environments, head over to the main page on [networktocode.com](https://www.networktocode.com/nautobot/sandbox-environments/).

## Documentation

Full documentation for this App can be found over on the [Nautobot Docs](https://docs.nautobot.com) website:

- [User Guide](https://docs.nautobot.com/projects/chatops/en/latest/user/app_overview/) - Overview, Using the App, Getting Started.
- [Administrator Guide](https://docs.nautobot.com/projects/chatops/en/latest/admin/install/) - How to Install, Configure, Upgrade, or Uninstall the App.
- [Developer Guide](https://docs.nautobot.com/projects/chatops/en/latest/dev/contributing/) - Extending the App, Code Reference, Contribution Guide.
- [Release Notes / Changelog](https://docs.nautobot.com/projects/chatops/en/latest/admin/release_notes/).
- [Frequently Asked Questions](https://docs.nautobot.com/projects/chatops/en/latest/user/faq/).
- [Glossary](https://docs.nautobot.com/projects/chatops/en/latest/glossary/)

### Contributing to the Documentation

You can find all the Markdown source for the App documentation under the [`docs`](https://github.com/nautobot/nautobot-app-chatops/tree/develop/docs) folder in this repository. For simple edits, a Markdown capable editor is sufficient: clone the repository and edit away.

If you need to view the fully-generated documentation site, you can build it with [MkDocs](https://www.mkdocs.org/). A container hosting the documentation can be started using the `invoke` commands (details in the [Development Environment Guide](https://docs.nautobot.com/projects/chatops/en/latest/dev/dev_environment/#docker-development-environment)) on [http://localhost:8001](http://localhost:8001). Using this container, as your changes to the documentation are saved, they will be automatically rebuilt and any pages currently being viewed will be reloaded in your browser.

Any PRs with fixes or improvements are very welcome!

## Questions

For any questions or comments, please check the [FAQ](https://docs.nautobot.com/projects/chatops/en/latest/user/app_faq/) first and feel free to swing by the [Network to Code slack channel](https://networktocode.slack.com/) (channel #nautobot).
Sign up [here](https://slack.networktocode.com/)

## Acknowledgements

This project includes code originally written in separate apps, which have been merged into this project:

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
