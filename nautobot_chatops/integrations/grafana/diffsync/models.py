"""DiffSync model definitions for Grafana Dashboards."""

from typing import List, Optional

from diffsync import DiffSync, DiffSyncModel

from nautobot_chatops.integrations.grafana.helpers import format_command
from nautobot_chatops.integrations.grafana.models import Dashboard, Panel, PanelVariable


class DashboardModel(DiffSyncModel):
    """DashboardModel class used to model the response into a consumable format."""

    _modelname = "dashboard"
    _identifiers = ("slug",)
    _attributes = (
        "uid",
        "friendly_name",
    )

    slug: str
    uid: str
    friendly_name: Optional[str]

    @classmethod
    def create(cls, diffsync: DiffSync, ids: dict, attrs: dict) -> Optional[DiffSyncModel]:
        """Handler to create an object if it does not exist as per the diff.

        Args:
            diffsync (DiffSync): DiffSync
            ids (dict): Identifiers in the DiffSync model
            attrs (dict): Additional attributes in the DiffSync model

        Returns:
            Optional[DiffSyncModel]: [description]
        """
        item = super().create(ids=ids, diffsync=diffsync, attrs=attrs)
        Dashboard.objects.create(
            dashboard_slug=ids["slug"],
            dashboard_uid=attrs["uid"],
            friendly_name=attrs["friendly_name"],
        )
        return item

    def update(self, attrs: dict) -> Optional[DiffSyncModel]:
        """Update will handle updating elements we care about in the attrs on the object.

        Args:
            attrs (dict): attributes that require an update in nautobot_chatops.GrafanaDashboard

        Returns:
            Optional[DiffSyncModel]: Updated model.
        """
        dashboard_object = Dashboard.objects.get(dashboard_slug=self.slug)

        for key, value in attrs.items():
            setattr(dashboard_object, key, value)
        dashboard_object.save()
        return super().update(attrs)

    def delete(self) -> Optional[DiffSyncModel]:
        """Delete elements no longer needed on the object.

        Returns:
            Optional[DiffSyncModel]: Updated model.
        """
        Dashboard.objects.get(dashboard_slug=self.slug).delete()

        super().delete()
        return self


class NautobotDashboard(DiffSync):
    """NautobotDashboard class used to represent the data model for nautobot_chatops.integrations.grafana.models.Dashboard."""

    dashboard = DashboardModel

    top_level = ["dashboard"]

    def __init__(self, dashboards: List[Dashboard], *args, **kwargs):
        """Initialize the DiffSync model and populate the dashboard."""
        super().__init__(*args, **kwargs)

        for dashboard in dashboards:
            # Create a dashboard record for this item
            self.add(
                self.dashboard(
                    uid=dashboard.dashboard_uid, slug=dashboard.dashboard_slug, friendly_name=dashboard.friendly_name
                )
            )


class GrafanaDashboard(DiffSync):
    """GrafanaDashboard class used to represent the data model from the Grafana API."""

    dashboard = DashboardModel

    top_level = ["dashboard"]

    _required_fields = ("uid", "uri")

    def __init__(self, dashboards: List[dict], *args, **kwargs):
        """Initialize the DiffSync model and populate the object."""
        super().__init__(*args, **kwargs)

        for dashboard in dashboards:
            # Validation to ensure the required keys exist. If not, fail and continue to the next.
            if not all(x in dashboard.keys() for x in self._required_fields):
                raise ValueError(f"Dashboard {dashboard} missing fields . Must have all of {self._required_fields}")

            # Create a dashboard record for this item
            self.add(
                self.dashboard(
                    slug=dashboard["uri"].replace("db/", ""),
                    uid=dashboard["uid"],
                    friendly_name=dashboard.get("title", ""),
                )
            )


class PanelModel(DiffSyncModel):
    """PanelModel class used to model the response into a consumable format."""

    _modelname = "panel"
    _identifiers = ("command_name",)
    _attributes = (
        "dashboard",
        "panel_id",
        "friendly_name",
    )

    command_name: str
    panel_id: int
    dashboard: Dashboard
    friendly_name: Optional[str]

    @classmethod
    def create(cls, diffsync: DiffSync, ids: dict, attrs: dict) -> Optional[DiffSyncModel]:
        """Handler to create an object if it does not exist as per the diff.

        Args:
            diffsync (DiffSync): DiffSync
            ids (dict): Identifiers in the DiffSync model
            attrs (dict): Additional attributes in the DiffSync model

        Returns:
            Optional[DiffSyncModel]: [description]
        """
        item = super().create(ids=ids, diffsync=diffsync, attrs=attrs)
        Panel.objects.create(
            dashboard=attrs["dashboard"],
            command_name=ids["command_name"],
            panel_id=attrs["panel_id"],
            friendly_name=attrs["friendly_name"],
            active=False,
        )
        return item

    def update(self, attrs: dict) -> Optional[DiffSyncModel]:
        """Update will handle updating elements we care about in the attrs on the object.

        Args:
            attrs (dict): attributes that require an update in nautobot_chatops.integrations.grafana.Panel

        Returns:
            Optional[DiffSyncModel]: Updated model.
        """
        panel_object = Panel.objects.get(command_name=self.command_name)

        for key, value in attrs.items():
            setattr(panel_object, key, value)
        panel_object.save()
        return super().update(attrs)

    def delete(self) -> Optional[DiffSyncModel]:
        """Delete elements no longer needed on the object.

        Returns:
            Optional[DiffSyncModel]: Updated model.
        """
        Panel.objects.get(command_name=self.command_name).delete()

        super().delete()
        return self


class NautobotPanel(DiffSync):
    """NautobotPanel class used to represent the data model for nautobot_chatops.integrations.grafana.models.Panel."""

    panel = PanelModel

    top_level = ["panel"]

    def __init__(self, panels: List[Panel], *args, **kwargs):
        """Initialize the DiffSync model and populate the panel."""
        super().__init__(*args, **kwargs)

        for panel in panels:
            # Create a panel record for this item
            self.add(
                self.panel(
                    dashboard=panel.dashboard,
                    command_name=panel.command_name,
                    panel_id=panel.panel_id,
                    friendly_name=panel.friendly_name,
                )
            )


class GrafanaPanel(DiffSync):
    """GrafanaPanel class used to represent the data model from the Grafana API."""

    panel = PanelModel

    top_level = ["panel"]

    _required_fields = ("id",)

    def __init__(self, panels: List[dict], dashboard: Dashboard, *args, **kwargs):
        """Initialize the DiffSync model and populate the object."""
        super().__init__(*args, **kwargs)

        panel_iterator = {}

        for panel in panels:
            # Validation to ensure the required keys exist. If not, fail and continue to the next.
            if not all(x in panel.keys() for x in self._required_fields):
                raise ValueError(
                    f"Panel {panel.get('title')} missing fields . Must have all of {self._required_fields}, got {panel.keys()}"
                )

            # We do not want to sync rows as they do not contain target data.
            if panel.get("type", "row") == "row":
                continue

            # There should always be a panel title, but if for some reason there is not, we should skip
            # trying to synchronize it.
            title = panel.get("title", "")
            if not title:
                continue

            command = format_command(title)
            existing = self.dict()
            if existing.get("panel"):
                if command in existing["panel"].keys():
                    if panel_iterator.get(command):
                        command = f"{command}-{panel_iterator.get(command)+1}"
                    else:
                        command = f"{command}-1"
                        panel_iterator[command] = 1

            # Create a record for this item
            self.add(
                self.panel(
                    dashboard=dashboard,
                    command_name=command,
                    panel_id=int(panel["id"]),
                    friendly_name=title,
                )
            )


class VariableModel(DiffSyncModel):
    """VariableModel class used to model the response into a consumable format."""

    _modelname = "variable"
    _identifiers = ("name", "panel")
    _attributes = (
        "includeincmd",
        "includeinurl",
        "response",
        "friendly_name",
    )

    name: str
    panel: Panel
    includeincmd: bool
    includeinurl: bool
    response: str
    friendly_name: Optional[str]

    @classmethod
    def create(cls, diffsync: DiffSync, ids: dict, attrs: dict) -> Optional[DiffSyncModel]:
        """Handler to create an object if it does not exist as per the diff.

        Args:
            diffsync (DiffSync): DiffSync
            ids (dict): Identifiers in the DiffSync model
            attrs (dict): Additional attributes in the DiffSync model

        Returns:
            Optional[DiffSyncModel]: [description]
        """
        item = super().create(ids=ids, diffsync=diffsync, attrs=attrs)
        PanelVariable.objects.create(
            panel=ids["panel"],
            name=ids["name"],
            includeincmd=attrs["includeincmd"],
            includeinurl=attrs["includeinurl"],
            response=attrs["response"],
            friendly_name=attrs["friendly_name"],
            positional_order=100,
        )
        return item

    def update(self, attrs: dict) -> Optional[DiffSyncModel]:
        """Update will handle updating elements we care about in the attrs on the object.

        Args:
            attrs (dict): attributes that require an update in nautobot_chatops.integrations.grafana.PanelVariable

        Returns:
            Optional[DiffSyncModel]: Updated model.
        """
        variable_object = PanelVariable.objects.get(name=self.name, panel=self.panel)

        for key, value in attrs.items():
            # Skip synchronization of static created attributes during the sync process.
            if key in ["includeincmd", "includeinurl"]:
                continue
            setattr(variable_object, key, value)
        variable_object.save()
        return super().update(attrs)

    def delete(self) -> Optional[DiffSyncModel]:
        """Delete elements no longer needed on the object.

        Returns:
            Optional[DiffSyncModel]: Updated model.
        """
        PanelVariable.objects.get(name=self.name, panel=self.panel).delete()

        super().delete()
        return self


class NautobotVariable(DiffSync):
    """NautobotVariable class used to represent the model for nautobot_chatops.integrations.grafana.models.PanelVariable."""

    variable = VariableModel

    top_level = ["variable"]

    def __init__(self, variables: List[PanelVariable], *args, **kwargs):
        """Initialize the DiffSync model and populate the panel."""
        super().__init__(*args, **kwargs)

        for variable in variables:
            # Create a panel record for this item
            self.add(
                self.variable(
                    panel=variable.panel,
                    name=variable.name,
                    includeincmd=variable.includeincmd,
                    includeinurl=variable.includeinurl,
                    response=variable.response,
                    friendly_name=variable.friendly_name,
                )
            )


class GrafanaVariable(DiffSync):
    """GrafanaVariable class used to represent the data model from the Grafana API."""

    variable = VariableModel

    top_level = ["variable"]

    _required_fields = ("id",)

    def __init__(self, variables: List[dict], dashboard: Dashboard, *args, **kwargs):
        """Initialize the DiffSync model and populate the object."""
        super().__init__(*args, **kwargs)

        for panel in Panel.objects.filter(dashboard=dashboard):
            # Add this variable for each panel in the dashboard.
            for var_item in variables:
                # Create a record for this item
                self.add(
                    self.variable(
                        panel=panel,
                        name=var_item["name"],
                        includeincmd=var_item["includeincmd"],
                        includeinurl=var_item["includeinurl"],
                        response=var_item["response"],
                        friendly_name=var_item["friendly_name"],
                    )
                )
