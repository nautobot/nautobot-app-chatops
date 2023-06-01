"""Nautobot configuration."""
import json
import os
import sys


from nautobot.core.settings import *  # noqa: F401,F403 pylint: disable=wildcard-import,unused-wildcard-import
from nautobot.core.settings_funcs import parse_redis_connection


def _get_bool_env(name: str, default=False):
    value = os.getenv(name, str(default))
    return bool(json.loads(value.lower()))


ALLOWED_HOSTS = os.getenv("NAUTOBOT_ALLOWED_HOSTS", "").split(" ")
SECRET_KEY = os.getenv("NAUTOBOT_SECRET_KEY", "")

nautobot_db_engine = os.getenv("NAUTOBOT_DB_ENGINE", "django.db.backends.postgresql")
default_db_settings = {
    "django.db.backends.postgresql": {
        "NAUTOBOT_DB_PORT": "5432",
    },
    "django.db.backends.mysql": {
        "NAUTOBOT_DB_PORT": "3306",
    },
}
DATABASES = {
    "default": {
        "NAME": os.getenv("NAUTOBOT_DB_NAME", "nautobot"),  # Database name
        "USER": os.getenv("NAUTOBOT_DB_USER", ""),  # Database username
        "PASSWORD": os.getenv("NAUTOBOT_DB_PASSWORD", ""),  # Database password
        "HOST": os.getenv("NAUTOBOT_DB_HOST", "localhost"),  # Database server
        "PORT": os.getenv(
            "NAUTOBOT_DB_PORT", default_db_settings[nautobot_db_engine]["NAUTOBOT_DB_PORT"]
        ),  # Database port, default to postgres
        "CONN_MAX_AGE": int(os.getenv("NAUTOBOT_DB_TIMEOUT", 300)),  # Database timeout
        "ENGINE": nautobot_db_engine,
    }
}

#
# Debug
#

DEBUG = True

# Django Debug Toolbar
DEBUG_TOOLBAR_CONFIG = {"SHOW_TOOLBAR_CALLBACK": lambda _request: DEBUG and not TESTING}

if DEBUG and "debug_toolbar" not in INSTALLED_APPS:  # noqa: F405
    INSTALLED_APPS.append("debug_toolbar")  # noqa: F405
if DEBUG and "debug_toolbar.middleware.DebugToolbarMiddleware" not in MIDDLEWARE:  # noqa: F405
    MIDDLEWARE.insert(0, "debug_toolbar.middleware.DebugToolbarMiddleware")  # noqa: F405

#
# Logging
#

LOG_LEVEL = "DEBUG" if DEBUG else "INFO"

TESTING = len(sys.argv) > 1 and sys.argv[1] == "test"

# Verbose logging during normal development operation, but quiet logging during unit test execution
if not TESTING:
    LOGGING = {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "normal": {
                "format": "%(asctime)s.%(msecs)03d %(levelname)-7s %(name)s :\n  %(message)s",
                "datefmt": "%H:%M:%S",
            },
            "verbose": {
                "format": "%(asctime)s.%(msecs)03d %(levelname)-7s %(name)-20s %(filename)-15s %(funcName)30s() :\n  %(message)s",
                "datefmt": "%H:%M:%S",
            },
        },
        "handlers": {
            "normal_console": {
                "level": "INFO",
                "class": "logging.StreamHandler",
                "formatter": "normal",
            },
            "verbose_console": {
                "level": "DEBUG",
                "class": "logging.StreamHandler",
                "formatter": "verbose",
            },
        },
        "loggers": {
            "django": {"handlers": ["normal_console"], "level": "INFO"},
            "nautobot": {
                "handlers": ["verbose_console" if DEBUG else "normal_console"],
                "level": LOG_LEVEL,
            },
        },
    }

#
# Redis
#

# The django-redis cache is used to establish concurrent locks using Redis. The
# django-rq settings will use the same instance/database by default.
#
# This "default" server is now used by RQ_QUEUES.
# >> See: nautobot.core.settings.RQ_QUEUES
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": parse_redis_connection(redis_database=0),
        "TIMEOUT": 300,
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        },
    }
}

# RQ_QUEUES is not set here because it just uses the default that gets imported
# up top via `from nautobot.core.settings import *`.

# Redis Cacheops
CACHEOPS_REDIS = parse_redis_connection(redis_database=1)

# Enable installed plugins. Add the name of each plugin to the list.
PLUGINS = [
    "nautobot_capacity_metrics",
    "nautobot_chatops",
]

# Plugins configuration settings. These settings are used by various plugins that the user may have installed.
# Each key in the dictionary is the name of an installed plugin and its value is a dictionary of settings.
PLUGINS_CONFIG = {
    "nautobot_chatops": {
        "aci_creds": {x: os.environ[x] for x in os.environ if "APIC" in x},
        "enable_mattermost": _get_bool_env("NAUTOBOT_CHATOPS_ENABLE_MATTERMOST"),
        "enable_ms_teams": _get_bool_env("NAUTOBOT_CHATOPS_ENABLE_MS_TEAMS"),
        "enable_slack": _get_bool_env("NAUTOBOT_CHATOPS_ENABLE_SLACK"),
        "enable_webex": _get_bool_env("NAUTOBOT_CHATOPS_ENABLE_WEBEX"),
        "mattermost_api_token": os.environ.get("MATTERMOST_API_TOKEN"),
        "mattermost_url": os.environ.get("MATTERMOST_URL"),
        "microsoft_app_id": os.environ.get("MICROSOFT_APP_ID"),
        "microsoft_app_password": os.environ.get("MICROSOFT_APP_PASSWORD"),
        "restrict_help": _get_bool_env("NAUTOBOT_CHATOPS_RESTRICT_HELP"),
        "slack_api_token": os.environ.get("SLACK_API_TOKEN"),
        "slack_app_token": os.environ.get("SLACK_APP_TOKEN"),
        "slack_signing_secret": os.environ.get("SLACK_SIGNING_SECRET"),
        "slack_slash_command_prefix": os.environ.get("SLACK_SLASH_COMMAND_PREFIX", "/"),
        "tower_uri": os.getenv("NAUTOBOT_TOWER_URI"),
        "tower_username": os.getenv("NAUTOBOT_TOWER_USERNAME"),
        "tower_password": os.getenv("NAUTOBOT_TOWER_PASSWORD"),
        "tower_verify_ssl": _get_bool_env("NAUTOBOT_TOWER_VERIFY_SSL", True),
        "webex_signing_secret": os.environ.get("WEBEX_SIGNING_SECRET"),
        "webex_token": os.environ.get("WEBEX_ACCESS_TOKEN"),
    },
}

METRICS_ENABLED = _get_bool_env("NAUTOBOT_METRICS_ENABLED")
