# Glossary

- Chat Platform: A communication service, such as Mattermost, Microsoft Teams, Slack or Webex.
- Dispatcher: A Platform specific class that processes incoming chat messages, executes Commands, and sends results back to the Platform.
- Platform View: Django View to handle Platform data.
- Integration: A component that defines Commands, handles data retrieval, and manipulation for particular tools or services (e.g., IP Fabric, Ansible, Panorama, Grafana, ACI, Meraki, Arista CloudVision).
- Command: A specific instruction sent by users through the chat Platform, processed by some Integration.
- Worker: A Command specific module, that processes tasks independently of Platform, receiving data from Platform Views and returning results via a Dispatcher's generic API.
- Sub-command: An instruction nested within some Command.
