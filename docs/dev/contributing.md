# Contributing to Nautobot ChatOps

The project is packaged with a light [development environment](dev_environment.md) based on `docker-compose` to help with the local development of the project and to run tests.

The project is following Network to Code software development guidelines and is leveraging the following:

- Python linting and formatting: `black`, `pylint`, `bandit`, `flake8`, and `pydocstyle`.
- YAML linting is done with `yamllint`.
- Django unit test to ensure the plugin is working properly.

Documentation is built using [mkdocs](https://www.mkdocs.org/).
The [Docker based development environment](dev_environment.md#docker-development-environment) automatically starts a container hosting a live version of the documentation website on [http://localhost:8001](http://localhost:8001) that auto-refreshes when you make any changes to your local files.

## Creating Changelog Fragments

All pull requests to `next` or `develop` must include a changelog fragment file in the `./changes` directory. To create a fragment, use your GitHub issue number and fragment type as the filename. For example, `2362.added`. Valid fragment types are `added`, `changed`, `deprecated`, `fixed`, `removed`, and `security`. The change summary is added to the file in plain text. Change summaries should be complete sentences, starting with a capital letter and ending with a period, and be in past tense. Each line of the change fragment will generate a single change entry in the release notes. Use multiple lines in the same file if your change needs to generate multiple release notes in the same category. If the change needs to create multiple entries in separate categories, create multiple files.

!!! example

    **Wrong**
    ```plaintext title="changes/1234.fixed"
    fix critical bug in documentation
    ```

    **Right**
    ```plaintext title="changes/1234.fixed"
    Fixed critical bug in documentation.
    ```

!!! example "Multiple Entry Example"

    This will generate 2 entries in the `fixed` category and one entry in the `changed` category.

    ```plaintext title="changes/1234.fixed"
    Fixed critical bug in documentation.
    Fixed release notes generation.
    ```

    ```plaintext title="changes/1234.changed"
    Changed release notes generation.
    ```

## Adding a new top-level command

First, you should be familiar with the design goals and constraints involved in Nautobot (`design.md`).
Be sure that this is really what you want to do, versus adding a sub-command instead.

We recommend that each command exist as its own submodule under `nautobot_chatops/workers/` (or, as a separate package
entirely, such as `nautobot_chatops_mycommand/worker.py`, using the `entrypoint/plugin` capability described in `design.md`)
to keep code files to a reasonable size and complexity. This submodule or package should implement a
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

By using `handle_subcommands`, the top-level command worker will automatically recognize the sub-command "help",
as well as any sub-commands registered using the `@subcommand_of` decorator.

You shouldn't need to make any changes to the `views` or `dispatchers` modules in this scenario.

For usability, you should use the App Studio app in the Microsoft Teams client to update the bot settings
(`Nautobot_ms_teams.zip`) to include this new top-level command as a documented command supported by the bot.
You will probably then need to delete the bot deployment from your team and re-deploy it for the new command to appear.

You will also need to log in to api.slack.com and add the new slash-command to your bot's configuration.

## Adding a new sub-command

First, you should be familiar with the design goals and constraints involved in Nautobot (`design.md`).

To register a sub-command, write a function whose name matches the sub-command's name (any `_` in the function name
will be automatically converted to `-` for the sub-command name), and decorate it with the `@subcommand_of` decorator.
This function must take `dispatcher` (an instance of any `Dispatcher` subclass) as its first argument; any additional
positional arguments become arguments in the chat app UI. The docstring of this function will become the help text
displayed for this sub-command when a user invokes `<command> help`, so it should be concise and to the point.

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

A sub-command worker function should always return one of the following:

### `return False`

This indicates that the function did not do anything meaningful, and it so should not be logged in Nautobot's
command log. Typically, this is only returned when not all required parameters have been provided by the user
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

## Adding support for a new chat platform (Webhooks)

First, you should be familiar with the design goals and constraints involved in Nautobot (`design.md`).

You'll need to add a new `nautobot_chatops.views.<platform>` submodule that provides any necessary API endpoints.

You'll also need to add a new `nautobot_chatops.dispatchers.<platform>` submodule that implements an appropriate
subclass of `Dispatcher`. This new dispatcher class will need to implement any abstract methods of the base class
and override any other methods where platform-specific behavior is required (which will probably be most of them).

You shouldn't need to make any changes to the `workers` module in this scenario.

## Adding support for a new chat platform (WebSockets)

First, you should be familiar with the design goals and constraints involved in Nautobot (`design.md`).

You'll need to add a new `nautobot_chatops.sockets.<platform>` submodule that provides the necessary WebSockets connection to the Platform.

You'll also need to add a new `nautobot_chatops.dispatchers.<platform>` submodule that implements an appropriate
subclass of `Dispatcher`. This new dispatcher class will need to implement any abstract methods of the base class
and override any other methods where platform-specific behavior is required (which will probably be most of them).

Finally, you will need to add a new `nautobot_chatops.management.start_<platform>_socket` management command that will start the WebSockets asynchronous loop.
In 2.0 these will likely be condensed to use a single base command with arguments to select the platform.

You shouldn't need to make any changes to the `workers` module in this scenario.

## Submitting Pull Requests

- It is recommended to open an issue **before** starting work on a pull request, and discuss your idea with the Nautobot maintainers before beginning work. This will help prevent wasting time on something that we might not be able to implement. When suggesting a new feature, also make sure it won't conflict with any work that's already in progress.

- Once you've opened or identified an issue you'd like to work on, ask that it
  be assigned to you so that others are aware it's being worked on. A maintainer
  will then mark the issue as "accepted."

- If you followed the project guidelines, have ample tests, code quality, you will first be acknowledged for your work. So, thank you in advance! After that, the PR will be quickly reviewed to ensure that it makes sense as a contribution to the project, and to gauge the work effort or issues with merging into *current*. If the effort required by the core team isn’t trivial, it’ll likely still be a few weeks before it gets thoroughly reviewed and merged, thus it won't be uncommon to move it to *near term* with a `near-term` label. It will just depend on the current backlog.

- All code submissions should meet the following criteria (CI will enforce
these checks):
    - Python syntax is valid
    - All unit tests pass successfully
    - PEP 8 compliance is enforced, with the exception that lines may be
    greater than 80 characters in length
    - At least one [changelog fragment](#creating-changelog-fragments) has
    been included in the feature branch

## Branching Policy

The branching policy includes the following tenets:

- The `develop` branch is the primary branch to develop off of.
- PRs intended to add new features should be sourced from the `develop` branch.
- PRs intended to address bug fixes and security patches should be sourced from the `develop` branch.
- PRs intended to add new features that break backward compatibility should be discussed before a PR is created.

Nautobot ChatOps app will observe semantic versioning, as of 1.0. This may result in a quick turn around in minor versions to keep pace with an ever-growing feature set.

## Release Policy

Nautobot ChatOps currently has no intended scheduled release schedule, and will release new features in minor versions.

When a new release of any kind (e.g. from `develop` to `main`, or a release of a `stable-<major>.<minor>`) is created the following should happen.

- A release PR is created:
    - Add and/or update to the changelog in `docs/admin/release_notes/version_<major>.<minor>.md` file to reflect the changes.
    - Update the mkdocs.yml file to include updates when adding a new release_notes version file.
    - Change the version from `<major>.<minor>.<patch>-beta` to `<major>.<minor>.<patch>` in `pyproject.toml`.
    - Set the PR to the proper branch, e.g. either `main` or `stable-<major>.<minor>`.
- Ensure the tests for the PR pass.
- Merge the PR.
- Create a new tag:
    - The tag should be in the form of `v<major>.<minor>.<patch>`.
    - The title should be in the form of `v<major>.<minor>.<patch>`.
    - The description should be the changes that were added to the `version_<major>.<minor>.md` document.
- If merged into `main`, then push from `main` to `develop`, in order to retain the merge commit created when the PR was merged.
- If there is a new `<major>.<minor>`, create a `stable-<major>.<minor>` for the **previous** version, so that security updates to old versions may be applied more easily.
- A post release PR is created:
    - Change the version from `<major>.<minor>.<patch>` to `<major>.<minor>.<patch + 1>-beta` in `pyproject.toml`.
    - Set the PR to the proper branch, e.g. either `develop` or `stable-<major>.<minor>`.
    - Once tests pass, merge.
