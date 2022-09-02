import asyncio
from django.core.management.base import BaseCommand
from nautobot_chatops.sockets.slack import main

class Command(BaseCommand):
    """Starts the Slack Socket."""

    def handle(self, *args, **kwargs):
        asyncio.run(main())
