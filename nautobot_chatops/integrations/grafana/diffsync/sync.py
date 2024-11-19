"""Synchronization functions for the implemented DiffSync models."""

from typing import Union

try:
    from diffsync import DiffSyncFlags

    DIFFSYNC_INSTALLED = True
except ImportError:
    DIFFSYNC_INSTALLED = False

if DIFFSYNC_INSTALLED:
    from nautobot_chatops.integrations.grafana.diffsync.models import (
        GrafanaDashboard,
        GrafanaPanel,
        GrafanaVariable,
        NautobotDashboard,
        NautobotPanel,
        NautobotVariable,
    )
from nautobot_chatops.integrations.grafana.grafana import handler
from nautobot_chatops.integrations.grafana.models import Dashboard, Panel, PanelVariable


def run_dashboard_sync(overwrite: bool = False) -> Union[str, None]:
    """run_dashboard_sync will run a diffsync between Grafana and Nautobot data, then sync if there are inconsistencies.

    Args:
        overwrite (bool): Overwrite Nautobot data and delete records that are no longer in Grafana.

    Raises:
        ImportError: If DiffSync is not installed.
    """
    if not DIFFSYNC_INSTALLED:
        raise ImportError("DiffSync is not installed. Please install DiffSync to use the grafana integration.")

    df_flags = DiffSyncFlags.NONE if overwrite else DiffSyncFlags.SKIP_UNMATCHED_DST

    # Fetch dashboards from the Grafana API
    grafana_dashboards = handler.get_dashboards()

    # Fetch dashboards from the Nautobot ORM
    nautobot_dashboards = Dashboard.objects.all()

    # Load the dashboards info retrieved from the API into the DiffSync model.
    diff_nautobot_dashboards = NautobotDashboard(nautobot_dashboards)

    # Load the Dashboard objects retrieved from the Nautobot ORM into the DiffSync model.
    diff_grafana_dashboards = GrafanaDashboard(grafana_dashboards)

    diff_result = diff_nautobot_dashboards.diff_from(diff_grafana_dashboards, flags=df_flags)

    if not diff_result.has_diffs():
        return None

    diff_nautobot_dashboards.sync_from(diff_grafana_dashboards, flags=df_flags)
    return diff_result.str()


def run_panels_sync(dashboard: Dashboard, overwrite: bool = False) -> Union[str, None]:
    """run_panels_sync will run a diffsync between Grafana and Nautobot data, then sync if there are inconsistencies.

    Args:
        dashboard (nautobot_chatops.integrations.grafana.models.Dashboard): The dashboard we are going to do a diffsync with.
        overwrite (bool): Overwrite Nautobot data and delete records that are no longer in Grafana.

    Raises:
        ImportError: If DiffSync is not installed.
    """
    if not DIFFSYNC_INSTALLED:
        raise ImportError("DiffSync is not installed. Please install DiffSync to use the grafana integration.")

    df_flags = DiffSyncFlags.NONE if overwrite else DiffSyncFlags.SKIP_UNMATCHED_DST

    # Fetch panels from the Grafana API
    grafana_panels = handler.get_panels(dashboard_uid=dashboard.dashboard_uid)

    # Fetch panels from the Nautobot ORM
    nautobot_panels = Panel.objects.filter(dashboard=dashboard)

    # Load the panels info retrieved from the API into the DiffSync model.
    diff_nautobot = NautobotPanel(nautobot_panels)

    # Load the Panel objects retrieved from the Nautobot ORM into the DiffSync model.
    diff_grafana = GrafanaPanel(grafana_panels, dashboard)

    diff_result = diff_nautobot.diff_from(diff_grafana, flags=df_flags)

    if not diff_result.has_diffs():
        return None

    diff_nautobot.sync_from(diff_grafana, flags=df_flags)
    return diff_result.str()


def run_variables_sync(dashboard: Dashboard, overwrite: bool = False) -> Union[str, None]:
    """run_variables_sync will run a diffsync between Grafana and Nautobot data, then sync if there are inconsistencies.

    Args:
        dashboard (nautobot_chatops.integrations.grafana.models.Dashboard): The dashboard we are going to do a diffsync with.
        overwrite (bool): Overwrite Nautobot data and delete records that are no longer in Grafana.

    Raises:
        ImportError: If DiffSync is not installed.
    """
    if not DIFFSYNC_INSTALLED:
        raise ImportError("DiffSync is not installed. Please install DiffSync to use the grafana integration.")

    df_flags = DiffSyncFlags.NONE if overwrite else DiffSyncFlags.SKIP_UNMATCHED_DST

    # Fetch panels from the Grafana API
    grafana_variables = handler.get_variables(dashboard_uid=dashboard.dashboard_uid)

    # Fetch panels from the Nautobot ORM
    nautobot_variables = []
    for panel in Panel.objects.filter(dashboard=dashboard):
        nautobot_variables.extend(PanelVariable.objects.filter(panel=panel))

    # Load the panels info retrieved from the API into the DiffSync model.
    diff_nautobot = NautobotVariable(nautobot_variables)

    # Load the Panel objects retrieved from the Nautobot ORM into the DiffSync model.
    diff_grafana = GrafanaVariable(grafana_variables, dashboard)

    diff_result = diff_nautobot.diff_from(diff_grafana, flags=df_flags)

    if not diff_result.has_diffs():
        return None

    diff_nautobot.sync_from(diff_grafana, flags=df_flags)
    return diff_result.str()
