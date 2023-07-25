# Arista CloudVision Integration Setup

This guide will walk you through steps to set up Arista CloudVision integration with the `nautobot_chatops` App.

## Prerequisites

Before configuring the integration, please ensure the following:

- `nautobot-chatops` App was [installed with integration extra dependencies](./index.md#installation-guide).
    ```shell
    pip install nautobot-chatops[aristacv]
    ```
- `nautobot-chatops` App is set up with at least one [enabled chat platform](./index.md#chat-platforms-configuration) and [tested](./index.md#test-your-chatbot).

## Command Setup

Create a top-level command named `aristacv` in your enabled chat platform. For detailed instructions related to your specific chat platform, refer to the [platform specific set up](./index.md#chat-platforms-configuration).

## Configuration

You must define the following values in your `nautobot_config.py` file:

| Configuration Setting  | Mandatory? | Default               |
| ---------------------- | ---------- | --------------------- |
| `enable_aristacv`      | **Yes**    | False                 |
| `aristacv_cvaas_url`   | No         | "www.arista.io:443"   |
| `aristacv_cvaas_token` | No         | None                  |
| `aristacv_cvp_host`    | No         | None                  |
| `aristacv_cvp_insecure`| No         | False                 |
| `aristacv_cvp_password`| No         | None                  |
| `aristacv_cvp_username`| No         | None                  |
| `aristacv_on_prem`     | No         | False                 |

Below is an example snippet from `development/nautobot_config.py` that demonstrates how to enable and configure Arista CloudVision integration:

```python
PLUGINS = ["nautobot_chatops"]

PLUGINS_CONFIG = {
    "nautobot_chatops": {
        ...
        "enable_aristacv": True,
        "aristacv_cvaas_url": os.environ.get("ARISTACV_CVAAS_URL"),
        "aristacv_cvaas_token": os.environ.get("ARISTACV_CVAAS_TOKEN"),
        "aristacv_cvp_host": os.environ.get("ARISTACV_CVP_HOST"),
        "aristacv_cvp_insecure": is_truthy(os.environ.get("ARISTACV_CVP_INSECURE")),
        "aristacv_cvp_password": os.environ.get("ARISTACV_CVP_PASSWORD"),
        "aristacv_cvp_username": os.environ.get("ARISTACV_CVP_USERNAME"),
        "aristacv_on_prem": is_truthy(os.environ.get("ARISTACV_ON_PREM")),
    }
}
```

For CVAAS the following environment variables must be set.

- `ARISTACV_CVAAS_TOKEN`: Token generated from CVAAS service account. Documentation for that process can be found [here](https://www.arista.com/assets/data/pdf/qsg/qsg-books/QS_CloudVision_as_a_Service.pdf) in section 1.7
- `ARISTACV_CVAAS_URL`: This is the url of your CloudVision-as-a-Service. When setting this make sure to include `www`. When not set, this defaults to `www.arista.io`

For on premise instance of CloudVision, these environment variables must be set.

- `ARISTACV_CVP_USERNAME`: The username that will be used to authenticate to CloudVision.
- `ARISTACV_CVP_PASSWORD`: The password for the configured username.
- `ARISTACV_CVP_HOST`: The IP or hostname of the on premise CloudVision appliance.
- `ARISTACV_CVP_INSECURE`: If this is set to `True`, the appliance cert will be downloaded and automatically trusted. Otherwise, the appliance is expected to have a valid certificate.
- `ARISTACV_ON_PREM`: By default this is set to False, this must be changed to `True` if using an on-prem instance of CloudVision.

Once you have updated your environment file, restart both nautobot and nautobot-worker.

## Upgrading from `nautobot-plugin-chatops-arista-cloudvision` App

!!! warning
    When upgrading from `nautobot-plugin-chatops-arista-cloudvision` App, it's necessary to [avoid conflicts](index.md#potential-apps-conflicts).

- Uninstall the old App:
    ```shell
    pip uninstall nautobot-plugin-chatops-arista-cloudvision
    ```
- Upgrade the App with required extras:
    ```shell
    pip install --upgrade nautobot-chatops[aristacv]
    ```
- Fix `nautobot_config.py` by removing `nautobot_chatops_arista_cloudvision` from `PLUGINS` and merging App configuration into `nautobot_chatops`:
    ```python
    PLUGINS = [
        "nautobot_chatops",
        # "nautobot_chatops_arista_cloudvision"  # REMOVE THIS LINE
    ]

    PLUGINS_CONFIG = {
        # "nautobot_chatops_arista_cloudvision": {  REMOVE THIS APP CONFIGURATION
        #     MOVE FOLLOWING LINES TO `nautobot_chatops` SECTION, PREFIX ENV VARIABLES WITH `ARISTACV_`
        #     'cvaas_token': os.environ.get("CVAAS_TOKEN"),
        #     'cvp_username': os.environ.get("CVP_USERNAME"),
        #     'cvp_password': os.environ.get("CVP_PASSWORD"),
        #     'cvp_host': os.environ.get("CVP_HOST"),
        #     'cvp_insecure': os.environ.get("CVP_INSECURE"),
        #     'on_prem': os.environ.get("ON_PREM")
        # }
        "nautobot_chatops": {
            # Enable Arista CloudVision integration
            "enable_aristacv": True,
            "aristacv_cvaas_url": os.environ.get("ARISTACV_CVAAS_URL"),
            "aristacv_cvaas_token": os.environ.get("ARISTACV_CVAAS_TOKEN"),
            "aristacv_cvp_host": os.environ.get("ARISTACV_CVP_HOST"),
            "aristacv_cvp_insecure": is_truthy(os.environ.get("ARISTACV_CVP_INSECURE")),
            "aristacv_cvp_password": os.environ.get("ARISTACV_CVP_PASSWORD"),
            "aristacv_cvp_username": os.environ.get("ARISTACV_CVP_USERNAME"),
            "aristacv_on_prem": is_truthy(os.environ.get("ARISTACV_ON_PREM")),
        }
    }
    ```

!!! note
    Environment variables for this integration are now prefixed with `ARISTACV_`. Remember to update your environment variables depending on your deployment.
