# The design of Nautobot

By delivering this as a Nautobot Chatops plugin, we gain the following benefits:

- No need to stand up a separate HTTP server, just use Nautobot's own HTTP server.
- Use of `async` is not required because we can hand off long-running tasks to Nautobot's `django-rq` workers.

## Code structure

The design goal of this plugin is to be able to write chatbot commands once and have them run anywhere
(Slack, Microsoft Teams, WebEx, etc.). Toward that end, it's divided into three layers:

1. input (`nautobot_chatops.views`)

   - Each module in this layer provides the HTTP endpoint(s) that a given chat platform requires for a chatbot.
     For example, `nautobot_chatops.views.slack` provides 2 such endpoints:

     1. for inbound slash-commands (invoked by `/command`)
     2. for inbound interactive actions (invoked by blocks or modal dialogs)

     Different chat platforms may require more or fewer such endpoints.

   - Each endpoint view is responsible for pulling relevant data (command, subcommand, parameters) out of the
     provided chat-platform-specific encoding or data structures (form-encoded, JSON, XML, whatever) and enqueuing
     the extracted data into `django-rq` for the worker that handles a given command.

   - In addition to enqueuing the command parameters for the worker, the queue also requires a `Dispatcher` class
     (see below) and any additional `context` that the dispatcher requires (such as user_id, channel_id, tokens, etc.)

   - Support for additional chat platform endpoints can be implemented as additional modules in this plugin,
     or could be delivered as an entirely separate Nautobot plugin if desired.

2. worker (`nautobot_chatops.workers`)

   - This layer is _completely ignorant_ of chat platforms. All code in this layer does not know or care about the
     difference between Slack, WebEx, Microsoft Teams, or any other platform we may support in the future.

   - Each `job` worker function acts on the provided parameters, then invokes generic methods on its provided
     `Dispatcher` class to post to the channel, prompt the user for more information, or whatever other user-facing
     action is desired.

   - Each module in this layer would provide a different top-level command, such as `nautobot`, `grafana`, or `ansible`.

   - This layer is designed to be extensible through Python's packaging `entry_points` functionality (`plugins` in
     Poetry's terminology). A Python package (Nautobot plugin) can register any worker functions under the `nautobot.workers` entry point,
     and the worker(s) will automatically be added to the client's capabilities.

3. output (`nautobot_chatops.dispatchers`)

   - This layer handles all presentation of information back to the end user via the chat platform.

   - The base `nautobot_chatops.dispatchers.Dispatcher` class defines the interface to which all chat-platform-specific
     subclasses must implement. Fundamentally this interface provides a set of building blocks for common patterns,
     such as direct-messaging a user, posting a message to a channel, prompting the user to select from a drop-down,
     and so forth.

   - It may also be extended to provide more complex/specific APIs if the presentation of a particular
     set of information needs to differ significantly between chat platforms in ways not provided for by the basic
     building blocks.

   - This interface must by necessity remain generic as, again, the worker layer has no knowledge of what chat platform
     is in use, but it knows what it wants to do.

   - Each module in this layer provides the `Dispatcher` subclass for a specific chat platform, such as
     `nautobot_chatops.dispatchers.slack.SlackDispatcher`. Therefore, there is typically a one-to-one mapping between
     `views` submodules and `dispatchers` submodules.

   - As with the `views` layer, the `Dispatcher` for a new chat platform could be implemented as a new submodule for
     this plugin, or could be delivered as part of a separate Nautobot plugin.

## Information flow

```
[ Chat client ] [ Chat server ] [ Nautobot main process ]
 |                |               |
 |-- User input ->|               |
 |                |-- HTTP POST ->|
 |                |               | nautobot_chatops/views/*
 |                |               |-- Enqueue job,dispatcher to RQ --> <queue>
 |                |<---- 200 OK --|
 |<- "Received" --|
```

...Time passes...

```
[ Chat client ] [ Chat server ] [ Nautobot django_rq worker process ----------------------------------- ]
 |                |                                                  | nautobot/workers/*
 |                |                                                  | Pick up next job from queue
 |                |                                                  | Instantiate provided dispatcher
 |                |                                                  |
 |                |                 | <- send status to dispatcher --|
 |                |                 | nautobot/dispatchers/*         |
 |                |<--- HTTP POST --|                                |-- call Nautobot, REST APIs, etc. -->
 |<- user output--|                                                  | Additional calls, processing, etc.
 |                |                                                  |
 |                |                 | <- send output to dispatcher --|
 |                |                 | nautobot/dispatchers/*
 |                |<--- HTTP POST --|
 |<- user output--|
```

## Design considerations

### Command-subcommand structure

In general, we recommend structuring commands as a two-tiered command-subcommand structure, rather than implementing
every command as a top-level worker function. (`/nautobot get-device-info <device>`, `/nautobot get-vlan-info <vlan>`, etc.
rather than `/nautobot-get-device-info <device>`, `/nautobot-get-vlan-info <vlan>`, etc.) This is because:

a. On platforms such as Slack, each separate slash-command must be enabled and configured separately on the server,
so an excessive number of distinct top-level commands will make the chatbot inconvenient to deploy.
b. Platforms such as Microsoft Teams may limit the number of top-level commands that are displayed to the user in
a chat client, so large numbers of commands may be difficult to discover.

That said, the implementation of Nautobot allows it to transparently support both syntaxes (`/command-sub-command` as
well as `/command sub-command`; if the deployer takes the time to set up the bot accordingly.

### Multi-word Parameters

Nautobot dispatchers now allow multi-word arguments to be passed into commands. An example of this is passing city
names to a subcommand parameters. As an example, say we have a command that perfoms a lookup for all sites in Nautobot
that match a city. The command and parameters might look like `/nautobot get-sites location Dallas` where Dallas is the
city we want to search for. For the command to support cities such as `Las Vegas` we would want to quote the city
argument. The new command should look as `/nautobot get-sites location 'Las Vegas'`.

The worker would need to preserve the quoting when prompting for additional parameters. Below is an example:

Here we use the previous example, but add limit to the site lookup.

```Python
action = f"get-sites location '{city}'" # Adding single quotes around city to preserve quotes.
dispatcher.prompt_for_text(action_id=action, help_text="Please enter the maximum number of sites to return.", label="Number")
```

You should also preserve quoting when providing the user the shortcut text (`command_response_header`)

**Note:** If the user provides a single quote or leaves off a quote, an exception is raised.

### Output/dispatcher formatting

In general, the formatting of outputs/messages to the user will need to keep the lowest common denominator in mind.
Basic formatting such as bold, italic, lists, and headers is generally supported on all platforms.
Some known limitations of currently supported platforms:

#### Slack

- Text messages are typically limited to a maximum of 4000 characters, and content within blocks is often limited
  to even less than that (commonly 3000 characters).
  Longer content will either need to be split across multiple messages/blocks or be presented as a `snippet`
  (file attachment), which has no such limitations.
- Very limited table functionality in blocks. The `fields` attribute can be used for small two-column tables but it
  is limited to a maximum of 5 rows by Slack.
- Markdown in a block is wrapped to a maximum width of XXX characters; text-only Markdown messages are not
  wrapped to a fixed width but are still limited to the 4000-character maximum length.

#### Microsoft Teams

- No support for preformatted text in cards (blocks) - while text can be rendered as `monospace`, it still does not
  preserve whitespace, so it's not suitable for aligning output into text tables and the like.
- While text-only messages _do_ support Markdown preformatted text, the text is wrapped to a max width of 69
  characters regardless of how large the client's window is.
- No table functionality in cards (blocks). The `ColumnSet` card layout feature allows for wrapping content across
  multiple columns, but does not provide for any alignment across columns, so it's not suitable for tables.

## Settings

The setting of `send_all_messages_private` within the configuration applied within the Nautobot config is used to send all messages as private messages. The messages will be sent in private when this is set to `True`. The default setting is `False`, which is the default behavior for several message settings.

### Settings - Platform Support of Settings

> This table represents the platform support of particular settings

| Platform | send_all_messages_private |
| Slack | ✅ |
| MS Teams | ❌ |
| WebEx | ❌ |
| Mattermost | ✅ |
