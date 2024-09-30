"""Storage of data that will not change throughout the life cycle of application."""

from django.conf import settings

PLUGIN_CFG = settings.PLUGINS_CONFIG["nautobot_chatops"]
INTERFACES = [
    "Management",
    "ethernet1/1",
    "ethernet1/2",
    "ethernet1/3",
    "ethernet1/4",
    "ethernet1/5",
    "ethernet1/6",
    "ethernet1/7",
    "ethernet1/8",
]

UNKNOWN_SITE = "Unknown"

ALLOWED_OBJECTS = ("all", "address", "service")

NAPALM_DRIVER = "panos"
PANOS_MANUFACTURER_NAME = "Palo Alto Networks"
PANOS_PLATFORM = "PANOS"
PANOS_DEVICE_ROLE = "Firewall"
DEFAULT_TIMEOUT = 20
