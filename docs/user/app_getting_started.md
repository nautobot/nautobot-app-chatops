# Getting Started with the App

A step-by-step tutorial on how to get the App going and how to use it.

## Install the App

To install the App, please follow the instructions detailed in the [Administrator Guide](../admin/install/index.md).

## Built-in Commands

### Nautobot

Use `nautobot` to interact with Nautobot!

#### get-vlans

Return a filtered list of VLANS based on filter type and/or values.

#### get-interface-connections

Return a filtered list of interface connections based on filter type and values.

#### get-device-status

Get the status of a device in Nautobot.

#### change-device-status

Set the status of a device in Nautobot.

#### get-device-facts

Get detailed facts about a device from Nautobot in YAML format.

#### get-devices

Get a filtered list of devices from Nautobot.

#### get-rack

Get information about a specific rack from Nautobot.

#### get-circuits

Get a filtered list of circuits from Nautobot.

#### get-circuit-connections

For a given circuit, find the objects the circuit connects to.

#### get-circuit-providers

Get a list of circuit providers.

#### about

Provide link for more information on Nautobot Apps.

#### get-manufacturer-summary

Provides summary of each manufacturer and how many devices have that manufacturer.

### Clear

Scroll the chat history out of view.

{%
    include-markdown './aci_commands.md'
    heading-offset=1
%}
