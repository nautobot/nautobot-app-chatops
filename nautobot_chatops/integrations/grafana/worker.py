"""Worker function for /net commands in Slack."""

import argparse
import os
import tempfile
from datetime import datetime
from typing import Dict, List, NoReturn, Union

from django.core.exceptions import FieldError, MultipleObjectsReturned, ObjectDoesNotExist
from isodate import ISO8601Error, parse_duration
from jinja2 import Template
from nautobot.core.models.querysets import RestrictedQuerySet
from pydantic import ValidationError

from nautobot_chatops.dispatchers import Dispatcher
from nautobot_chatops.integrations.grafana.exceptions import DefaultArgsError, MultipleOptionsError, PanelError
from nautobot_chatops.integrations.grafana.grafana import (
    GRAFANA_LOGO_ALT,
    GRAFANA_LOGO_PATH,
    LOGGER,
    REQUEST_TIMEOUT_SEC,
    SLASH_COMMAND,
    handler,
)
from nautobot_chatops.integrations.grafana.models import VALID_MODELS, Panel, PanelVariable
from nautobot_chatops.workers import add_subcommand, handle_subcommands


def grafana_logo(dispatcher):
    """Construct an image_element containing the locally hosted Grafana logo."""
    return dispatcher.image_element(dispatcher.static_url(GRAFANA_LOGO_PATH), alt_text=GRAFANA_LOGO_ALT)


def grafana(subcommand, **kwargs):
    """Pull Panels from Grafana."""
    initialize_subcommands()
    handler.current_subcommand = subcommand
    return handle_subcommands(SLASH_COMMAND, subcommand, **kwargs)


def initialize_subcommands():
    """Based on the panels configuration yaml provided build chat subcommands."""
    default_params = [
        f"width={handler.width}",
        f"height={handler.height}",
        f"theme={handler.theme}",
        f"timespan={handler.timespan}",
        f"timezone={handler.timezone}",
    ]
    for panel in Panel.objects.filter(active=True):
        panel_variables = []
        # Build parameters list from dynamic variables in panels
        for variable in PanelVariable.objects.filter(panel=panel).order_by("positional_order", "name"):
            if variable.includeincmd:
                panel_variables.append(variable.name)
        # The subcommand name with be get-{command_name}
        add_subcommand(
            command_name=SLASH_COMMAND,
            command_func=grafana,
            subcommand_name=f"get-{panel.command_name}",
            subcommand_spec={
                "worker": chat_get_panel,
                "params": panel_variables + default_params,
                "doc": panel.friendly_name,
            },
        )


def chat_get_panel(dispatcher: Dispatcher, *args) -> bool:  # pylint: disable=too-many-return-statements
    """High level function to handle the panel request.

    Args:
        dispatcher (nautobot_chatops.dispatchers.Dispatcher): Abstracted dispatcher class for chat-ops.
        *args: Grafana Panel Arguments.

    Returns:
        bool: ChatOps response pass or fail.
    """
    # Find the panel config matching the current subcommand
    try:
        panel = Panel.objects.get(command_name=handler.current_subcommand.replace("get-", ""))
    except ObjectDoesNotExist:
        dispatcher.send_error(f"Command {handler.current_subcommand} Not Found!")
        return False
    except MultipleObjectsReturned:
        dispatcher.send_error(f"Command {handler.current_subcommand} Multiple Panels Defined!")
        return False

    panel_vars = PanelVariable.objects.filter(panel=panel).order_by("positional_order", "name")

    parsed_args = chat_parse_args(panel_vars, *args)
    if not parsed_args:
        return False

    try:
        # Validate nautobot Args and get any missing parameters
        chat_validate_nautobot_args(
            dispatcher=dispatcher,
            panel=panel,
            panel_vars=panel_vars,
            parsed_args=parsed_args,
            action_id=f"grafana {handler.current_subcommand} {' '.join(args)}",
        )
    except PanelError as exc:
        dispatcher.send_error(f"Sorry, {dispatcher.user_mention()} there was an error with the panel definition, {exc}")
        return False

    except MultipleOptionsError:
        return False

    try:
        # Validate the default arguments to make sure the conform to their defined pydantic type.
        chat_validate_default_args(parsed_args=parsed_args)
    except DefaultArgsError as exc:
        dispatcher.send_error(exc)
        return False

    return chat_return_panel(dispatcher=dispatcher, panel=panel, panel_vars=panel_vars, parsed_args=parsed_args)


def chat_parse_args(panel_vars: List[PanelVariable], *args) -> Union[dict, bool]:
    """Parse the arguments from the user via chat using argparser.

    Args:
        panel_vars (List[nautobot_chatops.models.GrafanaPanelVariable]): List of PanelVariable objects.
        *args: Grafana Panel arguments.

    Returns:
        parsed_args: dict of the arguments from the user's raw input
    """
    # Append on the flag command to conform to argparse parsing methods.
    fixed_args = []
    for arg in args:
        if arg.startswith(tuple(handler.default_params.keys())):
            fixed_args.append(f"--{arg}")
        else:
            fixed_args.append(arg)

    # Collect the arguments sent by the user parse them matching the panel config
    parser = argparse.ArgumentParser(description="Handles command arguments")
    predefined_args = {}
    for variable in panel_vars:
        if variable.includeincmd:
            parser.add_argument(f"{variable.name}", default=variable.response, nargs="?")
        else:
            # The variable from the config wasn't included in the users response (hidden) so
            # add the default response if provided in the config
            predefined_args[variable.name] = variable.response

    parser.add_argument("--width", default=handler.width, nargs="?")
    parser.add_argument("--height", default=handler.height, nargs="?")
    parser.add_argument("--theme", default=handler.theme, nargs="?")
    parser.add_argument("--timespan", default=handler.timespan, nargs="?")
    parser.add_argument("--timezone", default=handler.timezone, nargs="?")
    args_namespace = parser.parse_args(fixed_args)
    parsed_args = {**vars(args_namespace), **predefined_args}
    return parsed_args


def chat_return_panel(dispatcher: Dispatcher, panel: Panel, panel_vars: List[PanelVariable], parsed_args: dict) -> bool:
    """After everything passes the tests decorate the response and return the panel to the user.

    Args:
        dispatcher (nautobot_chatops.dispatchers.Dispatcher): Abstracted dispatcher class for chat-ops.
        panel (nautobot_chatops.models.GrafanaPanel): A Panel object.
        panel_vars (list(nautobot_chatops.models.GrafanaPanelVariable)): A list of PanelVariable objects.
        parsed_args (dict): Dictionary of parsed arguments from argparse.

    Returns:
        bool: ChatOps response pass or fail.
    """
    dispatcher.send_markdown(
        f"Standby {dispatcher.user_mention()}, I'm getting that result.\n"
        f"Please be patient as this can take up to {REQUEST_TIMEOUT_SEC} seconds.",
        ephemeral=True,
    )
    dispatcher.send_busy_indicator()

    raw_png = handler.get_png(panel, panel_vars)
    if not raw_png:
        dispatcher.send_error("An error occurred while accessing Grafana")
        return False

    dispatcher.send_blocks(
        dispatcher.command_response_header(
            command=SLASH_COMMAND,
            subcommand=handler.current_subcommand,
            args=chat_header_args(panel_vars=panel_vars, parsed_args=parsed_args)[:5],
            description=(
                f"<{handler.panel_url(panel=panel)}|{panel.dashboard.dashboard_slug}:{panel.command_name}> panel"
            ),
            image_element=grafana_logo(dispatcher),
        )
    )

    with tempfile.TemporaryDirectory() as tempdir:
        # Note: Microsoft Teams will silently fail if we have ":" in our filename.
        now = datetime.now()
        time_str = now.strftime("%Y-%m-%d-%H-%M-%S")

        # If a timespan is specified, set the filename of the image to be the correct timespan displayed in the
        # Grafana image.
        if parsed_args.get("timespan"):
            timedelta = parse_duration(parsed_args.get("timespan")).totimedelta(start=now)
            from_ts = (now - timedelta).strftime("%Y-%m-%d-%H-%M-%S")
            time_str = f"{from_ts}-to-{time_str}"

        img_path = os.path.join(tempdir, f"{handler.current_subcommand}_{time_str}.png")
        with open(img_path, "wb") as img_file:
            img_file.write(raw_png)
        dispatcher.send_image(img_path)
    return True


def chat_validate_nautobot_args(
    dispatcher: Dispatcher, panel: Panel, panel_vars: List[PanelVariable], parsed_args: dict, action_id: str
) -> NoReturn:
    """Parse through args and validate them against the definition with the panel.

    Args:
        dispatcher (nautobot_chatops.dispatchers.Dispatcher): Abstracted dispatcher class for chat-ops.
        panel (nautobot_chatops.models.GrafanaPanel): A Panel object.
        panel_vars (list(nautobot_chatops.models.GrafanaPanelVariable)): A list of PanelVariable objects.
        parsed_args (dict): Dictionary of parsed arguments from argparse.
        action_id (str): full grafana chatops command.

    Raises:
        PanelError: An issue fetching objects based on panel variables.
        MultipleOptionsError: Objects retrieved from Nautobot is not specific enough to process, return choices to user.

    Returns:
        NoReturn
    """
    validated_variables = {}

    for variable in panel_vars:
        if not variable.query:
            LOGGER.debug("Validated variable %s with input %s", variable.name, parsed_args[variable.name])
            validated_variables[variable.name] = parsed_args[variable.name]

        else:
            LOGGER.debug("Validating variable %s with input %s", variable.name, parsed_args[variable.name])
            # A nautobot Query is defined so first lets get all of those objects
            objects = get_nautobot_objects(variable=variable)

            # Copy the filter object from the variable in case a filter has been defined.
            _filter = variable.filter

            # If the user specified a filter in the chat command:
            # i.e. /grafana get-<name> 'site', and 'site' exist as the variable name,
            # we will add it to the filter.
            if parsed_args.get(variable.name):
                _filter[variable.modelattr] = parsed_args[variable.name]

            try:
                filtered_objects = objects.filter(**_filter)
            except FieldError:
                LOGGER.error("Unable to filter %s by %s", variable.query, _filter)
                raise PanelError(f"I was unable to filter {variable.query} by {_filter}") from None

            # filtered_objects should be a single record by this point. If not, we cannot process further,
            # we need to prompt the user for the options to filter further.
            if filtered_objects.count() != 1 or not parsed_args[variable.name]:
                if filtered_objects.count() > 1:
                    choices = [
                        (f"{filtered_object.name}", getattr(filtered_object, variable.modelattr))
                        for filtered_object in filtered_objects
                    ]
                else:
                    choices = [(f"{obj.name}", getattr(obj, variable.modelattr)) for obj in objects]
                helper_text = (
                    f"{panel.friendly_name} Requires {variable.friendly_name}"
                    if variable.friendly_name
                    else panel.friendly_name
                )
                parsed_args[variable.name] = dispatcher.prompt_from_menu(action_id, helper_text, choices)
                raise MultipleOptionsError

            # Add the validated device to the dict so templates can use it later
            LOGGER.debug("Validated variable %s with input %s", variable.name, parsed_args[variable.name])
            validated_variables[variable.name] = filtered_objects[0].__dict__

        # Now we now we have a valid device lets parse the value template for this variable
        # Where the modelattr refers to the Nautobot model and it's attribute (i.e. Site.name)
        # The `value` is the value that we will pass to Grafana in variable filtering.
        if variable.value == "":
            variable.value = validated_variables.get(variable.name)
        else:
            # If there is a variable value, it could be in jinja2 format, so we can take
            # that format and pass in the validated variables to get the correct rendered template.
            # If it's not Jinja2, then it should just return the value.
            variable.value = Template(variable.value).render(validated_variables)


def get_nautobot_objects(variable: PanelVariable) -> RestrictedQuerySet:
    """get_nautobot_objects fetches objects from the Nautobot ORM based on user-defined query params.

    Args:
        variable (nautobot_chatops.models.GrafanaPanelVariable): A PanelVariable object.

    Raises:
        PanelError: An issue fetching objects based on panel variables.

    Returns:
        RestrictedQuerySet: Objects returned from the Nautobot ORM.
    """
    objects = None
    # Example, if a 'query' defined in panels.yml is set to 'Site', we would pull all sites
    # using 'Site.objects.all()'
    for models in VALID_MODELS:
        if hasattr(models, variable.query):
            objects = getattr(models, variable.query).objects.all()
            break

    if not objects:
        LOGGER.error("Unable to find class %s in nautobot models.", variable.query)
        raise PanelError(f"I was unable to find class {variable.query} in nautobot models.") from None

    if not variable.modelattr:
        raise PanelError("When specifying a query, a modelattr is also required")
    if objects.count() < 1:
        raise PanelError(f"{variable.query} returned {objects.count()} items in the dcim.model.")

    return objects


def chat_validate_default_args(parsed_args: dict) -> NoReturn:
    """chat_validate_default_args will run pydantic validation checks against the default arguments.

    Args:
        parsed_args (dict): Combination of default and panel specified arguments, parsed into a dict.

    Raises:
        DefaultArgsError: An error validating the default arguments against their defined pydantic types.

    Returns:
        NoReturn
    """
    # Validate and set the default arguments
    for default_arg in handler.default_params:
        try:
            setattr(handler, default_arg, parsed_args[default_arg])
        except (ValidationError, ISO8601Error) as exc:
            raise DefaultArgsError(parsed_args[default_arg], exc) from None


def chat_header_args(panel_vars: List[PanelVariable], parsed_args: Dict) -> List:
    """Creates a list of tuples containing the passed in arguments from the chat command.

    Args:
        panel_vars (list(nautobot_chatops.models.GrafanaPanelVariable)): A list of PanelVariable objects.
        parsed_args (dict): Dictionary of parsed arguments from argparse.

    Returns:
        args (List): List of tuples containing the arguments passed into the chat command.

    Examples:
        >>> print(chat_header_args([PanelVariable(name="test")], {"test": "testing", "timespan": "P12M"}))
        [("test", "testing"), ("timespan", "timespan=P12M")]
    """
    args = []
    # Check the parsed args to see if they match a panel variable. If so, and the
    # value isn't the default value, then append it on as a passed in arg.
    for panel_var in panel_vars:
        arg = parsed_args.get(panel_var.name)
        if arg and arg != panel_var.response:
            args.append((panel_var.name, arg))
            continue

    # If we didn't find the parsed arg in the panel variable, look in the default variables.
    # Do the same here, if it does not match the default value, append it on as a passed in arg.
    for def_param, def_value in handler.default_params.items():
        arg = parsed_args.get(def_param)
        if arg and def_value != arg and def_param not in [a[0] for a in args]:
            args.append((def_param, f"{def_param}={arg}"))

    return args
