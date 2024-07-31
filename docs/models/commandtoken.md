# Command Tokens

<!--command-token-->
Nautobot provides an HTTP endpoint(s) for each supported chat platform.
These endpoints implement authentication to prevent arbitrary HTTP requests from being accepted.
Some platforms this `signing_secret` is valid for all commands, other platforms, such as Mattermost,
create a separate `token` for every slash command.  Keeping the records for Mattermost tokens in the
`.creds.env` file would not be sustainable.  

To solve this issue, the app has the option to store Command Tokens to the Nautobot Database.
In Nautobot, open Nautobot and go to the Plugins and select Command Tokens. Below is an example to
get you started.

## Example: Adding tokens for Mattermost

Here is an example that supports Mattermost.

| Platform    | Comment   | Token            |
| ----------- | ---------- | ---------------- |
| Mattermost  | `nautobot`   | `x0xb5hj5ga5tge` |
| Mattermost  | `clear`    | `x7g7ag9ohkafbe` |

**Note:** The Comment field is optional and used to help the user when there are multiple tokens.
