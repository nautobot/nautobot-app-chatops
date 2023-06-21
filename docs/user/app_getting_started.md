# Getting Started with the App

A step-by-step tutorial on how to get the App going and how to use it.

## Install the App

To install the App, please follow the instructions detailed in the [Administrator Guide](../admin/install/index.md).

## Built-in Commands

Each command can be invoked with `help` sub-command to display all sub-commands with the description.

### `/clear` Command

Scroll the chat history out of view. This command has no sub-commands.

### `/nautobot` Command

Interact with Nautobot by utilizing the following sub-commands:

| Command | Arguments | Description |
| ------- | --------- | ----------- |
| `about` || Provide a link for more information on Nautobot Apps. |
| `change-device-status` | `[device-name]` `[status]` | Set the status of a device in Nautobot. |
| `get-circuit-connections` | `[provider-slug]` `[circuit-id]` | For a given circuit, find the objects the circuit connects to. |
| `get-circuit-providers` || Get a list of circuit providers. |
| `get-circuits` | `[filter-type]` `[filter-value]` | Get a filtered list of circuits from Nautobot. |
| `get-device-facts` | `[device-name]` | Get detailed facts about a device from Nautobot in YAML format. |
| `get-device-status` | `[device-name]` | Get the status of a device in Nautobot. |
| `get-devices` | `[filter-type]` `[filter-value]` | Get a filtered list of devices from Nautobot. |
| `get-interface-connections` | `[filter-type]` `[filter-value-1]` `[filter-value-2]` | Return a filtered list of interface connections based on filter type, `filter_value_1` and/or `filter_value_2`. |
| `get-manufacturer-summary` || Provides a summary of each manufacturer and how many devices have that manufacturer. |
| `get-rack` | `[site-slug]` `[rack-id]` | Get information about a specific rack from Nautobot. |
| `get-vlans` | `[filter-type]` `[filter-value-1]` | Return a filtered list of VLANs based on filter type and/or `filter_value_1`. |

!!! NOTE
    All sub-commands are intended to be used with the `nautobot` prefix. For example, to retrieve a filtered list of VLANs, use the command `/nautobot get-vlans`.

{%
    include-markdown './aci_commands.md'
    heading-offset=1
%}
