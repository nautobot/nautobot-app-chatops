"""Views for nautobot_chatops."""

from nautobot.apps.views import NautobotUIViewSet
from nautobot.apps.ui import ObjectDetailContent, ObjectFieldsPanel, ObjectsTablePanel, SectionChoices
from nautobot.core.templatetags import helpers

from nautobot_chatops import filters, forms, models, tables
from nautobot_chatops.api import serializers


class CommandLogUIViewSet(NautobotUIViewSet):
    """ViewSet for CommandLog views."""

    bulk_update_form_class = forms.CommandLogBulkEditForm
    filterset_class = filters.CommandLogFilterSet
    filterset_form_class = forms.CommandLogFilterForm
    form_class = forms.CommandLogForm
    lookup_field = "pk"
    queryset = models.CommandLog.objects.all()
    serializer_class = serializers.CommandLogSerializer
    table_class = tables.CommandLogTable

    # Here is an example of using the UI  Component Framework for the detail view.
    # More information can be found in the Nautobot documentation:
    # https://docs.nautobot.com/projects/core/en/stable/development/core/ui-component-framework/
    object_detail_content = ObjectDetailContent(
        panels=[
            ObjectFieldsPanel(
                weight=100,
                section=SectionChoices.LEFT_HALF,
                fields="__all__",
                # Alternatively, you can specify a list of field names:
                # fields=[
                #     "name",
                #     "description",
                # ],
                # Some fields may require additional configuration, we can use value_transforms
                # value_transforms={
                #     "name": [helpers.bettertitle]
                # },
            ),
            # If there is a ForeignKey or M2M with this model we can use ObjectsTablePanel
            # to display them in a table format.
            # ObjectsTablePanel(
                # weight=200,
                # section=SectionChoices.RIGHT_HALF,
                # table_class=tables.CommandLogTable,
                # You will want to filter the table using the related_name
                # filter="commandlogs",
            # ),
        ],
    )
