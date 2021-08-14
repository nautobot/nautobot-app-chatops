from django.db import migrations, connection

def migrate_params(apps, schema_editor):
    """Migrate params field to params1"""
    CommandLog = apps.get_model('nautobot_chatops', 'CommandLog')
    for log in CommandLog.objects.all():
        params_list = list
        for key, value in log.params:
            params_list.append([key, value])
        log.params1 = params_list
        log.save()

def reverse_migrate_params(apps, schema_editor):
    """Reverse migration of params to params1."""
    CommandLog = apps.get_model('nautobot_chatops', 'CommandLog')
    for log in CommandLog.objects.all():
        params_list = list
        for key, value in log.params1:
            params_list.append([key, value])
        log.params = params_list
        log.save()

class Migration(migrations.Migration):

    dependencies = [
        ('nautobot_chatops', '0002_commandlog_params1'),
    ]

    operations = []

    if connection.vendor == 'postgresql':
        operations.append(migrations.RunPython(migrate_params, reverse_migrate_params))
