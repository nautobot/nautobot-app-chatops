# AWX / Ansible Tower Chat Commands

## `/ansible` Command

Interact with AWX / Ansible Tower by utilizing the following sub-commands:

| Command | Arguments | Description |
| ------- | --------- | ----------- |
| `get-dashboard` | | Get Ansible Tower / AWX dashboard status. |
| `get-inventory` | `[inventory]` | Get Ansible Tower / AWX inventory details. |
| `get-jobs` | `[count]` | Get the status of Ansible Tower / AWX jobs. |
| `get-job-templates` | | List available Ansible Tower / AWX job templates. |
| `get-projects` | | List available Ansible Tower / AWX projects. |
| `run-job-template` | `[template_name]` | Execute an Ansible Tower / AWX job template. |

!!! note
    All sub-commands are intended to be used with the `/ansible` prefix.
