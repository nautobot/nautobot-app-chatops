# Contributing to Nautobot ChatOps

Pull requests are welcomed and automatically built and tested against multiple version of Python and multiple version of Nautobot through Github Actions.

The project is packaged with a light development environment based on `docker-compose` to help with the local development of the project and to run the tests within Github Actions.

The project is following Network to Code software development guidelines and is leveraging:

- Black, Pylint, Bandit and pydocstyle for Python linting and formatting.
- Django unit test to ensure the plugin is working properly.

## Adding a new top-level command

First, you should be familiar with the design goals and constraints involved in Nautobot (`design.md`).
Be sure that this is really what you want to do, versus adding a subcommand instead.

We recommend that each command exist as its own submodule under `nautobot_chatops/workers/` (or, as a separate package
entirely, such as `nautobot_chatops_mycommand/worker.py`, using the entrypoint/plugin capability described in `design.md`)
so as to keep code files to a reasonable size and complexity. This submodule or package should implement a
`celery` worker function(s). In general this worker function shouldn't need to do much more than call
the `handle_subcommands` helper function provided:

```python
# nautobot_chatops/workers/mycommand.py

from django_rq import job

from nautobot_chatops.workers import handle_subcommands, subcommand_of

@job("default")
def mycommand(subcommand, **kwargs)
    """Perform mycommand and its subcommands."""
    return handle_subcommands("mycommand", subcommand, **kwargs)
```

By using `handle_subcommands`, the top-level command worker will automatically recognize the subcommand "help",
as well as any subcommands registered using the `@subcommand_of` decorator.

You shouldn't need to make any changes to the `views` or `dispatchers` modules in this scenario.

For usability, you should use the App Studio app in the Microsoft Teams client to update the bot settings
(`Nautobot_ms_teams.zip`) to include this new top-level command as a documented command supported by the bot.
You will probably then need to delete the bot deployment from your team and re-deploy it for the new command to appear.

You will also need to log in to api.slack.com and add the new slash-command to your bot's configuration.

## Adding a new subcommand

First, you should be familiar with the design goals and constraints involved in Nautobot (`design.md`).

To register a subcommand, write a function whose name matches the subcommand's name (any `_` in the function name
will be automatically converted to `-` for the subcommand name), and decorate it with the `@subcommand_of` decorator.
This function must take `dispatcher` (an instance of any `Dispatcher` subclass) as its first argument; any additional
positional arguments become arguments in the chat app UI. The docstring of this function will become the help text
displayed for this subcommand when a user invokes `<command> help`, so it should be concise and to the point.

```python
from nautobot_chatops.workers import subcommand_of

# ...

@subcommand_of("mycommand")
def do_something(dispatcher, first_arg, second_arg):
    """Do something with two arguments."""
    # ...
```

With the above code, the command `mycommand do_something [first_arg] [second_arg]` will now be available.

You shouldn't need to make any changes to the `views` or `dispatchers` modules in this scenario.

A subcommand worker function should always return one of the following:

### `return False`

This indicates that the function did not do anything meaningful and it so should not be logged in Nautobot's
command log. Typically this is only returned when not all required parameters have been provided by the user
and so the function needs to prompt the user for additional inputs, for example:

```python
@subcommand_of("nautobot")
def get_rack(dispatcher, site_slug, rack_id):
    """Get information about a specific rack from Nautobot."""
    if not site_slug:
        site_options = [(site.name, site.slug) for site in Site.objects.all()]
        dispatcher.prompt_from_menu("nautobot get-rack", "Select a site", site_options)
        return False  # command did not run to completion and therefore should not be logged
    ...
```

### `return CommandStatusChoices.STATUS_SUCCEEDED`

This indicates that the command was successful, and no further details are necessary in the logging.
You *could* return another status code besides `STATUS_SUCCEEDED` in this pattern, but in general any other status
code should be accompanied by an explanatory message:

### `return (CommandStatusChoices.STATUS_FAILED, details_str)`

This indicates that the command failed for some reason, which is provided for logging purposes.
You could also use other status codes (including `STATUS_SUCCEEDED`) for any other outcome that also requires
explanation.

The provided `details_str` will be stored in the Nautobot command log history.

## Adding support for a new chat platform

First, you should be familiar with the design goals and constraints involved in Nautobot (`design.md`).

You'll need to add a new `nautobot_chatops.views.<platform>` submodule that provides any necessary API endpoints.

You'll also need to add a new `nautobot_chatops.dispatchers.<platform>` submodule that implements an appropriate
subclass of `Dispatcher`. This new dispatcher class will need to implement any abstract methods of the base class
and override any other methods where platform-specific behavior is required (which will probably be most of them).

You shouldn't need to make any changes to the `workers` module in this scenario.
