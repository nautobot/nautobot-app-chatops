"""Django models for recording user interactions with Nautobot."""
from django.db import models
from nautobot.core.models import BaseModel


class CommandFilter(BaseModel):
    """An allowed command tied to a given object."""

    command = models.CharField(max_length=200, help_text="Standard regex supported.")
    device_role = models.ForeignKey(to="extras.Role", on_delete=models.CASCADE)
    platform = models.ForeignKey(to="dcim.Platform", on_delete=models.CASCADE)

    def __str__(self):
        """String representation of an CommandFilter."""
        return f'cmd: "{self.command}; on: {self.device_role}:{self.platform}'

    class Meta:
        """Meta-attributes of an CommandFilter."""

        ordering = ["command", "device_role", "platform"]
