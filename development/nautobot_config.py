"""Nautobot configuration."""
import os
import sys

from distutils.util import strtobool

from django.core.exceptions import ImproperlyConfigured
from nautobot.core.settings import *  # noqa: F401,F403 pylint: disable=wildcard-import,unused-wildcard-import


def is_truthy(arg):
    """Convert "truthy" strings into Booleans.

    Examples:
        >>> is_truthy('yes')
        True
    Args:
        arg (str): Truthy string (True values are y, yes, t, true, on and 1; false values are n, no,
        f, false, off and 0. Raises ValueError if val is anything else.
    """
    if isinstance(arg, bool):
        return arg
    return bool(strtobool(arg))


# Enforce required configuration parameters
for key in [
    "ALLOWED_HOSTS",
    "POSTGRES_DB",
    "POSTGRES_USER",
    "POSTGRES_HOST",
    "POSTGRES_PASSWORD",
    "REDIS_HOST",
    "REDIS_PASSWORD",
    "SECRET_KEY",
]:
    if not os.environ.get(key):
        raise ImproperlyConfigured(f"Required environment variable {key} is missing.")

# For reference see https://nautobot.readthedocs.io/en/latest/configuration/required-settings/
# Based on config from nautobot-server init

#########################
#                       #
#   Required settings   #
#                       #
#########################

# This is a list of valid fully-qualified domain names (FQDNs) for the Nautobot server. Nautobot will not permit write
# access to the server via any other hostnames. The first FQDN in the list will be treated as the preferred name.
#
# Example: ALLOWED_HOSTS = ['nautobot.example.com', 'nautobot.internal.local']
ALLOWED_HOSTS = os.environ["ALLOWED_HOSTS"].split(" ")

# PostgreSQL database configuration. See the Django documentation for a complete list of available parameters:
#   https://docs.djangoproject.com/en/stable/ref/settings/#databases
DATABASE_PORT = 5432 if not os.environ.get("POSTGRES_PORT", False) else int(os.environ["POSTGRES_PORT"])
DATABASES = {
    "default": {
        "NAME": os.getenv("POSTGRES_DB", ""),  # Database name
        "USER": os.getenv("POSTGRES_USER", ""),  # Database username
        "PASSWORD": os.getenv("POSTGRES_PASSWORD", ""),  # Datbase password
        "HOST": os.getenv("POSTGRES_HOST", "localhost"),  # Database server
        "PORT": DATABASE_PORT,  # Database port (leave blank for default)
        "CONN_MAX_AGE": int(os.environ.get("NAUTOBOT_DB_TIMEOUT", 300)),  # Database timeout
        "ENGINE": "django.db.backends.postgresql",  # Database driver (Postres only supported!)
    }
}

# Nautobot uses RQ for task scheduling. These are the following defaults.
# For detailed configuration see: https://github.com/rq/django-rq#installation
RQ_QUEUES = {
    "default": {
        "HOST": os.environ["REDIS_HOST"],
        "PORT": int(os.environ.get("REDIS_PORT", 6379)),
        "DB": 0,
        "PASSWORD": os.environ["REDIS_PASSWORD"],
        "SSL": is_truthy(os.environ.get("REDIS_SSL", False)),
        "DEFAULT_TIMEOUT": 300,
    },
    "check_releases": {
        "HOST": os.environ["REDIS_HOST"],
        "PORT": int(os.environ.get("REDIS_PORT", 6379)),
        "DB": 0,
        "PASSWORD": os.environ["REDIS_PASSWORD"],
        "SSL": is_truthy(os.environ.get("REDIS_SSL", False)),
        "DEFAULT_TIMEOUT": 300,
    },
}

# Nautobot uses Cacheops for database query caching. These are the following defaults.
# For detailed configuration see: https://github.com/Suor/django-cacheops#setup
# REDIS_URL used for healthchecks
if is_truthy(os.environ.get("REDIS_SSL", False)):
    REDIS_PROTOCOL = "rediss"
else:
    REDIS_PROTOCOL = "redis"
CACHEOPS_REDIS = f"{REDIS_PROTOCOL}://{os.environ['REDIS_HOST']}:{os.environ.get('REDIS_PORT', 6379)}/1"

# This key is used for secure generation of random numbers and strings. It must never be exposed outside of this file.
# For optimal security, SECRET_KEY should be at least 50 characters in length and contain a mix of letters, numbers, and
# symbols. Nautobot will not run without this defined. For more information, see
# https://docs.djangoproject.com/en/stable/ref/settings/#std:setting-SECRET_KEY
SECRET_KEY = os.environ["SECRET_KEY"]


#########################
#                       #
#   Optional settings   #
#                       #
#########################

# Specify one or more name and email address tuples representing Nautobot administrators. These people will be notified of
# application errors (assuming correct email settings are provided).
ADMINS = [
    # ['John Doe', 'jdoe@example.com'],
]

# Optionally display a persistent banner at the top and/or bottom of every page. HTML is allowed. To display the same
# content in both banners, define BANNER_TOP and set BANNER_BOTTOM = BANNER_TOP.
BANNER_TOP = os.environ.get("BANNER_TOP", "")
BANNER_BOTTOM = os.environ.get("BANNER_BOTTOM", "")

# Text to include on the login page above the login form. HTML is allowed.
BANNER_LOGIN = os.environ.get("BANNER_LOGIN", "")

# Base URL path if accessing Nautobot within a directory. For example, if installed at https://example.com/nautobot/, set:
# BASE_PATH = 'nautobot/'
BASE_PATH = os.environ.get("BASE_PATH", "")

# Cache timeout in seconds. Set to 0 to dissable caching. Defaults to 900 (15 minutes)
CACHEOPS_DEFAULTS = {"timeout": 900}

# The file path where jobs will be stored. A trailing slash is not needed. Note that the default value of
# this setting is inside the invoking user's home directory.
# JOBS_ROOT = os.path.expanduser('~/.nautobot/jobs')

# Set to True to enable server debugging. WARNING: Debugging introduces a substantial performance penalty and may reveal
# sensitive information about your installation. Only enable debugging while performing testing. Never enable debugging
# on a production system.
DEBUG = is_truthy(os.environ.get("DEBUG", False))

# Enforcement of unique IP space can be toggled on a per-VRF basis. To enforce unique IP space
# within the global table (all prefixes and IP addresses not assigned to a VRF), set
# ENFORCE_GLOBAL_UNIQUE to True.
ENFORCE_GLOBAL_UNIQUE = is_truthy(os.environ.get("ENFORCE_GLOBAL_UNIQUE", False))

# Exempt certain models from the enforcement of view permissions. Models listed here will be viewable by all users and
# by anonymous users. List models in the form `<app>.<model>`. Add '*' to this list to exempt all models.
EXEMPT_VIEW_PERMISSIONS = [
    # 'dcim.site',
    # 'dcim.region',
    # 'ipam.prefix',
]

# A list of strings designating all applications that are enabled in this Django installation. Each string should be a dotted Python path to an application configuration class (preferred), or a package containing an application.
# http://nautobot.readthedocs.io/configuration/optional-settings/#extra-applications
EXTRA_INSTALLED_APPS = []

# HTTP proxies Nautobot should use when sending outbound HTTP requests (e.g. for webhooks).
# HTTP_PROXIES = {
#     'http': 'http://10.10.1.10:3128',
#     'https': 'http://10.10.1.10:1080',
# }

# IP addresses recognized as internal to the system. The debugging toolbar will be available only to clients accessing
# Nautobot from an internal IP.
INTERNAL_IPS = ("127.0.0.1", "::1")

# The file path where jobs will be stored. A trailing slash is not needed. Note that the default value of
# this setting is derived from the installed location.
JOBS_ROOT = os.environ.get("JOBS_ROOT", os.path.expanduser("~/.nautobot/jobs"))

LOG_LEVEL = os.environ.get("LOG_LEVEL", "DEBUG" if DEBUG else "INFO")

# Enable custom logging. Please see the Django documentation for detailed guidance on configuring custom logs:
#   https://docs.djangoproject.com/en/stable/topics/logging/
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "verbose": {
            "format": "{asctime} {levelname} {message} - {name} - {module} - {pathname}:{lineno}",
            "datefmt": "%H:%M:%S",
            "style": "{",
        },
    },
    "handlers": {"console": {"level": "DEBUG", "class": "rq.utils.ColorizingStreamHandler", "formatter": "verbose"}},
    "root": {"handlers": ["console"], "level": LOG_LEVEL},
}

# Setting this to True will display a "maintenance mode" banner at the top of every page.
MAINTENANCE_MODE = is_truthy(os.environ.get("MAINTENANCE_MODE", False))

# An API consumer can request an arbitrary number of objects =by appending the "limit" parameter to the URL (e.g.
# "?limit=1000"). This setting defines the maximum limit. Setting it to 0 or None will allow an API consumer to request
# all objects by specifying "?limit=0".
MAX_PAGE_SIZE = int(os.environ.get("MAX_PAGE_SIZE", 1000))

# The file path where uploaded media such as image attachments are stored. A trailing slash is not needed. Note that
# the default value of this setting is within the invoking user's home directory
MEDIA_ROOT = os.environ.get("MEDIA_ROOT", os.path.expanduser("~/.nautobot/media"))

# Expose Prometheus monitoring metrics at the HTTP endpoint '/metrics'
METRICS_ENABLED = True

# Determine how many objects to display per page within a list. (Default: 50)
PAGINATE_COUNT = int(os.environ.get("PAGINATE_COUNT", 50))

# Enable installed plugins. Add the name of each plugin to the list.
PLUGINS = ["nautobot_chatops", "nautobot_capacity_metrics"]

# Plugins configuration settings. These settings are used by various plugins that the user may have installed.
# Each key in the dictionary is the name of an installed plugin and its value is a dictionary of settings.
PLUGINS_CONFIG = {
    "nautobot_chatops": {
        "enable_slack": True,
        "enable_ms_teams": True,
        "enable_webex_teams": True,
        "microsoft_app_id": os.environ.get("MICROSOFT_APP_ID"),
        "microsoft_app_password": os.environ.get("MICROSOFT_APP_PASSWORD"),
        "slack_api_token": os.environ.get("SLACK_API_TOKEN"),
        "slack_signing_secret": os.environ.get("SLACK_SIGNING_SECRET"),
        "slack_slash_command_prefix": os.environ.get("SLACK_SLASH_COMMAND_PREFIX", "/"),
        "webex_teams_token": os.environ.get("WEBEX_TEAMS_ACCESS_TOKEN"),
        "webex_teams_signing_secret": os.environ.get("WEBEX_TEAMS_SIGNING_SECRET"),
        "enable_mattermost": True,
        "mattermost_api_token": os.environ.get("MATTERMOST_API_TOKEN"),
        "mattermost_url": os.environ.get("MATTERMOST_URL"),
    },
}


# When determining the primary IP address for a device, IPv6 is preferred over IPv4 by default. Set this to True to
# prefer IPv4 instead.
PREFER_IPV4 = is_truthy(os.environ.get("PREFER_IPV4", False))

# Remote authentication support
REMOTE_AUTH_ENABLED = False
REMOTE_AUTH_BACKEND = "nautobot.core.authentication.RemoteUserBackend"
REMOTE_AUTH_HEADER = "HTTP_REMOTE_USER"
REMOTE_AUTH_AUTO_CREATE_USER = True
REMOTE_AUTH_DEFAULT_GROUPS = []
REMOTE_AUTH_DEFAULT_PERMISSIONS = {}

# This determines how often the GitHub API is called to check the latest release of Nautobot. Must be at least 1 hour.
RELEASE_CHECK_TIMEOUT = 24 * 3600

# Maximum execution time for background tasks, in seconds.
RQ_DEFAULT_TIMEOUT = 300

# Configure SSO, for more information see docs/configuration/authentication/sso.md
SOCIAL_AUTH_ENABLED = False

# By default uploaded media is stored on the local filesystem. Using Django-storages is also supported. Provide the
# class path of the storage driver in STORAGE_BACKEND and any configuration options in STORAGE_CONFIG. For example:
# STORAGE_BACKEND = 'storages.backends.s3boto3.S3Boto3Storage'
# STORAGE_CONFIG = {
#     'AWS_ACCESS_KEY_ID': 'Key ID',
#     'AWS_SECRET_ACCESS_KEY': 'Secret',
#     'AWS_STORAGE_BUCKET_NAME': 'nautobot',
#     'AWS_S3_REGION_NAME': 'eu-west-1',
# }

# Time zone (default: UTC)
TIME_ZONE = os.environ.get("TIME_ZONE", "UTC")

# Django Debug Toolbar
TESTING = len(sys.argv) > 1 and sys.argv[1] == "test"
DEBUG_TOOLBAR_CONFIG = {"SHOW_TOOLBAR_CALLBACK": lambda _request: DEBUG and not TESTING}
