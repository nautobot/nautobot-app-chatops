"""Nautobot App ChatOps Grafana Exceptions."""

from isodate import ISO8601Error
from pydantic import ValidationError


class DefaultArgsError(BaseException):
    """Errors related to pydantic model when setting arguments in the chat command."""

    def __init__(self, element, err):
        """Handles the error messages for the grafana chatops default arguments."""
        super().__init__()

        if isinstance(err, ValidationError):
            self.message = (
                f"\"{element}\" is an invalid {err.errors()[0]['loc'][0].replace('default_', '')}, "
                f"{err.errors()[0]['msg']}."
            )
        elif isinstance(err, ISO8601Error):
            self.message = (
                f'"{element}" is an invalid ISO8601 timespan duration. '
                f"See https://en.wikipedia.org/wiki/ISO_8601#Durations for more information."
            )
        else:
            self.message = f"{element} is invalid. {str(err)}"

    def __str__(self):
        """String representation of the error message."""
        return self.message


class PanelError(BaseException):
    """Errors related to arguments defined in the panels.yml file."""


class MultipleOptionsError(BaseException):
    """Error raised when there are too many options to perform an action. Send options back to user."""
