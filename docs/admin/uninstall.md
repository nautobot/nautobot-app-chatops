# Uninstall the App from Nautobot

## Uninstall Guide

1. Remove Database migrations for ChatOps:

    ```bash
    nautobot-server migrate nautobot-chatops zero
    ```

2. Remove the configuration you added in `nautobot_config.py` from `PLUGINS` & `PLUGINS_CONFIG`.
3. Run Nautobot-server post_upgrade

    ```bash
    nautobot-server post_ugprade
    ```

4. Restart Nautobot Services
