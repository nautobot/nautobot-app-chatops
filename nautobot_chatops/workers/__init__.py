"""Workers module for the nautobot_chatops Nautobot plugin.

The functions in this module provide back-end worker logic that is totally ignorant
of the differences between various chat platforms. They receive generic data from
one of the platform-specific ``views``, handle it appropriately, then dispatch it
back to the chat using the provided ``dispatchers`` instance's generic API.
"""

from datetime import datetime, timezone
import inspect
from functools import wraps
import logging
import shlex
import pkg_resources

from nautobot_chatops.choices import CommandStatusChoices
from nautobot_chatops.models import CommandLog
from nautobot_chatops.utils import create_command_log
from nautobot_chatops.metrics import request_command_cntr, command_histogram

logger = logging.getLogger("rq.worker")


_registry_initialized = False  # pylint: disable=invalid-name
_commands_registry = {}  # pylint: disable=invalid-name
"""Registry of commands and their subcommands.

Populated by calling nautobot_chatops.workers.get_commands_registry()

_commands_registry = {
  'command_1': {
    'doc': "docstring"
    'function': <function object>
    'subcommands': {
       'subcommand_1': {
          'worker': worker_function,
          'params': [],
          'doc': "docstring"
       },
       'subcommand_2': {
          'worker': worker_function,
          'params': [],
          'doc': "docstring"
       },
    },
  },
  'command_2': {
    ...
  }
}
"""


def get_commands_registry():
    """Populate and return the _commands_registry dictionary with all known commands, subcommands, and workers."""
    global _commands_registry  # pylint: disable=global-statement,invalid-name
    global _registry_initialized  # pylint: disable=global-statement,invalid-name
    if _registry_initialized:
        # Already populated, don't regenerate it
        return _commands_registry

    # See issue #20 - if there are subcommands of multiple top-level commands in a single module,
    # that whole module gets loaded when we call worker.load() below, which includes the subcommands
    # of commands we haven't yet processed.
    # In other words, we can't guarantee that we process a command before we process its subcommands,
    # so don't treat the subcommand-before-command case as an error.

    for worker in pkg_resources.iter_entry_points("nautobot.workers"):
        # See above. However, we still should never have two command worker functions registered under the same name.
        command_func = worker.load()
        if (
            worker.name in _commands_registry
            and "function" in _commands_registry[worker.name]
            and _commands_registry[worker.name]["function"]
        ):
            if _commands_registry[worker.name]["function"] == command_func:
                logger.warning("Command worker function '%s' was processed twice. This should not happen", worker.name)
            else:
                logger.error("Duplicate worker name '%s' detected! Check for redundant plugins", worker.name)
            continue

        if worker.name not in _commands_registry:
            _commands_registry[worker.name] = {"subcommands": {}}
        _commands_registry[worker.name]["function"] = command_func
        # Split lines to get the first line of the docstring for the doc
        _commands_registry[worker.name]["doc"] = command_func.__doc__.splitlines()[0]

    # Mark the registry as initialized
    _registry_initialized = True

    return _commands_registry


# Preserve backwards compatibility
get_workers = get_commands_registry


def commands_help(prefix=""):
    """Construct a top-level "help" menu for the bot to use."""
    return "I know the following commands:\n" + "\n".join(
        f"- `{prefix}{name}`\t{data['doc']}" for name, data in get_commands_registry().items()
    )


# Preserve backwards compatibility
workers_help = commands_help


def parse_command_string(command_string):
    """Parse a command string into (command, subcommand, *args).

    Any of the following syntaxes are valid:
    - command sub-command
    - command sub-command arg1 arg2
    - command-sub-command
    - command-sub-command arg1 arg2

    Note that a command's name never contains internal hyphens, although a subcommand's name may.
    """
    # Strip leading/trailing whitespace
    command_string = command_string.strip()
    if " " in command_string:
        command, subcommand = command_string.split(maxsplit=1)
        if "-" in command:
            text = subcommand
            command, subcommand = command.split(sep="-", maxsplit=1)
        elif " " in subcommand:
            subcommand, text = subcommand.split(maxsplit=1)
        else:
            text = ""
    elif "-" in command_string:
        command, subcommand = command_string.split(sep="-", maxsplit=1)
        text = ""
    else:
        command = command_string
        subcommand = ""
        text = ""

    clean_text = convert_smart_quotes(text)

    args = shlex.split(clean_text)
    return command, subcommand, args


def subcommand_of(command):
    """Decorator to register a function as a subcommand of a given command.

    NOTE: The return value of the subcommand function is used to influence command logging for metrics and such:
    - False: the command did not actually run (additional input is needed from the user, etc.) and
      so, to reduce noise, it should not be logged.
    - CommandStatusChoices.STATUS_*, typically STATUS_SUCCEEDED: the command should be logged with the given status
    - (CommandStatusChoices.STATUS_*, "details"): the command should be logged with the given status and detail message

    This decorator also does some magic to allow for optional positional arguments, so that the function can be called
    while only specifying some positional args (those unspecified will default to None). The first argument that
    this function takes must be the Dispatcher instance that the subcommand will use to communicate back to the user;
    all other positional arguments will be strings or None.

    ::

        @subcommand_of("commandname")
        def subcommand_name(dispatcher, arg_1, arg_2, arg_3):
            pass

        # Equivalent to calling subcommand_name(dispatcher, None, None, None)
        get_commands_registry()["commandname"]["subcommands"]["subcommand_name"]["worker"](dispatcher)
        # Equivalent to calling subcommand_name(dispatcher, "alpha", "beta", None)
        get_commands_registry()["commandname"]["subcommands"]["subcommand_name"]["worker"](dispatcher, "alpha", "beta")

    This is designed to work in combination with :func:`handle_subcommands`, below.
    """

    def subcommand(func):
        """Constructs the wrapper function for the decorated function."""
        global _commands_registry  # pylint: disable=global-statement,invalid-name

        sig = inspect.signature(func)
        # What are the positional args of func?
        params = [p for p in sig.parameters.values() if p.kind in (p.POSITIONAL_ONLY, p.POSITIONAL_OR_KEYWORD)]

        @wraps(func)
        def wrapper(*args, **kwargs):
            """Fill in None values for any omitted args, then call the decorated function."""
            args = list(args)
            while len(args) < len(params):
                args.append(None)
            return func(*args, **kwargs)

        # Register this function in the _commands_registry dictionary as a subcommand
        subcommand_name = func.__name__.replace("_", "-")

        subcommand_spec = {
            "worker": wrapper,
            # params[0] is always the "dispatcher" instance, omit that
            "params": [p.name.replace("_", "-") for p in params[1:]],
            "doc": func.__doc__.splitlines()[0],  # Split lines to get the first line of the docstring
        }
        add_subcommand(
            command_name=command, command_func=None, subcommand_name=subcommand_name, subcommand_spec=subcommand_spec
        )

        return wrapper

    return subcommand


def add_subcommand(command_name, command_func, subcommand_name, subcommand_spec):
    """Function to add additional subcommands without the need for a decorator function.

    Args:
        command_name (string): The parent command name
        command_func (function): The Parent command function
        subcommand_name (string): The name of the subcommand to add
        subcommand_spec (dict): A dictionary containing the definition of the subcommand:

    The subcommand_spec dictionary should have the following format:
    {
        'worker': worker_function,
        'params': [],
        'doc': "docstring"
    }
    """
    global _commands_registry  # pylint: disable=global-statement,invalid-name

    # See issue #20 - depending on code structure, it's possible we may process a subcommand before we
    # have actually processed its parent command. This is normal and we need to handle it.
    _commands_registry.setdefault(command_name, {}).setdefault("subcommands", {})[subcommand_name] = subcommand_spec
    if not _commands_registry[command_name].get("function", False) and command_func:
        _commands_registry[command_name]["function"] = command_func
        _commands_registry[command_name]["doc"] = command_func.__doc__


@command_histogram.time()
def handle_subcommands(command, subcommand, params=(), dispatcher_class=None, context=None):
    """Generic worker function, to be used in combination with the @subcommand_of decorator above.

    ::

        @job("default")
        def commandname(subcommand, **kwargs):
            return handle_subcommands("command_name", subcommand, **kwargs)

        @subcommand_of("commandname")
        def first_subcommand(dispatcher, arg_1, arg_2):
            '''The first subcommand.'''
            pass

        @subcommand_of("commandname")
        def second_subcommand(dispatcher, arg_1):
            '''The second subcommand.'''
            pass

    chat client::

        > /commandname help
        "/commandname" subcommands:
        - /commandname first-subcommand [arg-1] [arg-2]  The first subcommand
        - /commandname second-subcommand [arg-1]         The second subcommand
    """
    if not context:
        context = {}
    registry = get_commands_registry()
    dispatcher = dispatcher_class(context=context)

    command_log = create_command_log(dispatcher, registry, command, subcommand, params)

    if subcommand == "help" or not subcommand:
        message = f"I know the following `{dispatcher.command_prefix}{command}` subcommands:\n"
        for subcmd, entry in registry[command].get("subcommands", {}).items():
            message += (
                f"- `{dispatcher.command_prefix}{command} {subcmd} "
                f"{' '.join(f'[{param}]' for param in entry['params'])}`\t{entry['doc']}\n"
            )
        # Present help message, do not save command_log
        dispatcher.send_markdown(message, ephemeral=True)
        return False

    if subcommand not in registry.get(command, {}).get("subcommands", {}):
        # Usage error, do not save command_log
        dispatcher.send_error(f'I don\'t know the {dispatcher.command_prefix}{command} subcommand "{subcommand}"')
        return False

    if params and params[0] == "help":
        entry = registry[command]["subcommands"][subcommand]
        message = (
            f"Usage: `{dispatcher.command_prefix}{command} {subcommand} "
            f"{' '.join(f'[{param}]' for param in entry['params'])}`\n{entry['doc']}"
        )
        # Present usage message, do not save command_log
        dispatcher.send_markdown(message, ephemeral=True)
        return False

    try:
        # A subcommand can return:
        # False: if it shouldn't be logged (used mostly for the case where the command prompted the user for more info)
        # A CommandStatusChoices value for logging
        # A tuple of (CommandStatusChoices value, details_str) to log details as well.
        result = registry[command]["subcommands"][subcommand]["worker"](dispatcher, *params)
        if result is not False:
            command_log.runtime = datetime.now(timezone.utc) - command_log.start_time
            # For backward compatibility, a return value of True is considered a "success" status.
            if result is True:
                status = CommandStatusChoices.STATUS_SUCCEEDED
                details = ""
            elif isinstance(result, (list, tuple)):
                status, details = result[:2]
            else:
                status = result
                details = ""

            if status not in CommandStatusChoices.values():
                if not details:
                    details = f"Unknown/invalid status '{status}'"
                status = CommandStatusChoices.STATUS_UNKNOWN

            command_log.status = status
            command_log.details = details
            command_log.save()
            request_command_cntr.labels(dispatcher.platform_slug, command, subcommand, status).inc()

    except Exception as exc:  # pylint:disable=broad-except
        dispatcher.send_error(f"An internal error occurred:\n{exc}")
        # Sure, we might as well save the command log in this case...
        command_log.runtime = datetime.now(timezone.utc) - command_log.start_time
        command_log.status = CommandStatusChoices.STATUS_ERRORED
        command_log.details = str(exc)
        command_log.save()
        request_command_cntr.labels(
            dispatcher.platform_slug, command, subcommand, CommandStatusChoices.STATUS_ERRORED
        ).inc()
        raise

    return result


def convert_smart_quotes(text):
    """Converts Smart Quotes to single quotes.

    When parsing the command string, it is necessary
    to convert the Smart Quotes that chat clients can
    send (depending on OS settings) in order to
    properly parse the command.

    Args:
        text (str): Text to convert

    Returns:
        str: Text with smart quotes to single quotes.
    """
    charmap = {0x201C: "'", 0x201D: "'", 0x2018: "'", 0x2019: "'"}

    return text.translate(charmap)
