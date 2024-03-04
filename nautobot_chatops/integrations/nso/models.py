"""Django models for recording user interactions with Nautobot."""
from django.db import models
from nautobot.core.models.generics import PrimaryModel


class NSOCommandFilter(PrimaryModel):
    """An allowed command tied to a given object."""

    command = models.CharField(max_length=200, help_text="Standard regex supported.")
    role = models.ForeignKey(to="extras.Role", on_delete=models.CASCADE)
    platform = models.ForeignKey(to="dcim.Platform", on_delete=models.CASCADE)

    def __str__(self):
        """String representation of an NSOCommandFilter."""
        return f'cmd: "{self.command}; on: {self.role}:{self.platform}'

    class Meta:
        """Meta-attributes of an NSOCommandFilter."""

        ordering = ["command", "role", "platform"]
        constraints = [models.UniqueConstraint(fields=["command", "role", "platform"], name="unique command filter")]
