# Glossary

- **Chat Platform**: A communication service (e.g., Mattermost, Microsoft Teams, Slack, Cisco Webex).
- **Command**: A particular instruction sent by users via the Chat Platform, which is then processed by an Integration.
- **Dispatcher**: A class specific to the Chat Platform that processes incoming chat messages, executes commands, and sends results back to the Chat Platform.
- **Integration**: A component that defines commands, handles data retrieval, and manipulation for specific tools or services (e.g., IP Fabric, AWX / Ansible Tower, Palo Alto Panorama, Grafana, Cisco ACI, Cisco Meraki, Arista CloudVision).
- **Platform View**: A Django View designed to handle Chat Platform data.
- **Sub-command**: An instruction that is nested within a Command.
- **Worker**: A module within an Integration, designed to handle and process a Command, receiving data from Platform Views and returning results via a Dispatcher's generic API.
