# Extending ChatOps

## How message processing works

Nautobot Chatops processes messages in a stateless fashion. Chat clients do not maintain a connection with Nautobot. Nautobot Chatops does not wait for the response from the chat client. Each interaction between the chat client and the Nautobot Chatops are treated as new interactions.

Let's use the `nautobot get-devices` command and subcommand to explore the message processing. In this example, we will be using Slack. 

### SlashCommandView

The end user will type `/nautobot get-devices` in Slack and hit enter. Slack will reach out to the configured Slash Command endpoint. This will go to SlackSlashCommandView. Here the sender (Slack) will be verified (Authentication). Once the verified, the request data from Slack is stored in the `context` then the command will be parsed separating out the command, subcommand and params. In this example `nautobot` is the command, `get-devices` is the subcommand and no params were given. Next, the commands registry is checked to confirm that `nautobot` is a valid command. If the command is valid, it is sent to the check_and_enqueue_command function.

### Check_and_enqueue_command

The check_and_enqueue_command function takes the commands registry, parsed command string, the context and originating dispatcher (Slack in this case). Here we will double-check the registry, then create a `command_log` entry (Accounting). Next we process the `access_grants` to verify that the user is authorized to use this command/subcommand (Authorization). If authorized, the parsed command string, context, dispatcher and function are enqueued with a worker.

### Worker Processing

In this example, get_devices gets sent to the Celery or RQ Worker. The get_devices function takes two arguments (params). Since no params were passed in at the first check for `filter_type`, the function calls `prompt_for_device_filter_type` which uses the `prompt_from_menu`**Insert_link to send a dropdown menu to the chat client. Then the function returns `False` since the command is not finished therefore it should not be logged. The worker then exits.

### InteractionView

If the user selects an option in the prompt, Slack will send that option along with the `action_id` that `prompt_from_menu` sent. In this example lets pretend that the user selected `site`. The InteractionView will receive a payload and try to process the payload to get the `action_id` which will be `nautobot get-devices` and the params `site`. This will be sent to check_and_enqueue, then to the worker.

### Worker Processing Continued

Continuing with the example, the Nautobot subcommand get-devices will now have the filter_type argument set to `site`. The function can now continue to use the dispatcher to prompt for more information, or use the dispatcher to return data to the user. To log completion of the command, the function can return `CommandStatusChoices.STATUS_SUCCEEDED` or `CommandStatusChoices.STATUS_FAILED` to log a successful or failed command.

## Dispatcher Functions

This is a list of all the available dispatcher functions that can be used to build out the interactive components of your chat commands.

### 