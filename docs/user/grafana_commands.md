# Grafana Chat Commands

## `/grafana` Command

Interact with Grafana by utilizing the following sub-commands:

| Command | Arguments | Description |
| ------- | --------- | ----------- |
| `get-aps` | `[APIC]` `[tenant]` | Display Application Profiles configured for a given tenant. |
| `get-bds` | `[APIC]` `[tenant]` | Show configured Bridge Domains for a given tenant. |
| `get-controllers` | `[APIC]` | Display all APIC controllers. |
| `get-epg-details` | `[APIC]` `[tenant]` `[ap]` `[epg]` | Show details for a specific Endpoint Group. |
| `get-epgs` | `[APIC]` `[tenant]` `[ap]` | Display Endpoint Groups (EPGs) for a specific Application Profile. |
| `get-interfaces` | `[APIC]` `[pod-id]` `[node-id]` `[state]` | Show interfaces on a specific node. |
| `get-nodes` | `[APIC]` | Show all fabric nodes. |
| `get-pending-nodes` | `[APIC]` | Display any unregistered nodes. |
| `get-tenants` | `[APIC]` | Display configured tenants. |
| `get-vrfs` | `[APIC]` `[tenant]` | Display configured VRFs for a given tenant. |
| `register-node` | `[APIC]` `[serial-nbr]` `[node-id]` `[name]` | Register a new fabric node. |

!!! note
    All sub-commands are intended to be used with the `/grafana` prefix.
