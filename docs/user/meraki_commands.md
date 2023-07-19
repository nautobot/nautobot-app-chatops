# Cisco Meraki Chat Commands

## `/meraki` Command

Interact with Cisco Meraki by utilizing the following sub-commands:

| Command | Arguments | Description |
| ------- | --------- | ----------- |
| `get-organizations` |  | Gather all the Meraki Organizations. |
| `get-admins` | `[org_name]` | Based on an Organization Name Return the Admins. |
| `get-devices` | `[org_name]` `[device_type]` | Gathers devices from Meraki. |
| `get-networks` | `[org_name]` | Gathers networks from Meraki. |
| `get-switchports` | `[org_name]` `[device_name]` | Gathers switch ports from a MS switch device. |
| `get-switchports-status` | `[org_name]` `[device_name]` | Gathers switch ports status from a MS switch device. |
| `get-firewall-performance` | `[org_name]` `[device_name]` | Query Meraki with a firewall to device performance. |
| `get-wlan-ssids` | `[org_name]` `[net_name]` | Query Meraki for all SSIDs for a given Network. |
| `get-camera-recent` | `[org_name]` `[device_name]` | Query Meraki Recent Camera Analytics. |
| `get-clients` | `[org_name]` `[device_name]` | Query Meraki for List of Clients. |
| `get-neighbors` | `[org_name]` `[device_name]` | Query Meraki for List of LLDP or CDP Neighbors. |
| `configure-basic-access-port` | `[org_name]` `[device_name]` `[port_number]` `[enabled]` `[vlan]` `[port_desc]` | Configure an access port with description, VLAN and state. |
| `cycle-port` | `[org_name]` `[device_name]` `[port_number]` | Cycle a port on a switch. |

!!! note
    All sub-commands are intended to be used with the `/meraki` prefix.

## Screenshots

TBD
