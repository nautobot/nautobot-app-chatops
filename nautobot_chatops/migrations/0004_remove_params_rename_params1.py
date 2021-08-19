from django.db import migrations, connection


class Migration(migrations.Migration):

    dependencies = [
        ("nautobot_chatops", "0003_params_to_params1"),
    ]

    operations = []

    if connection.vendor == "postgresql":
        operations.append(
            migrations.RemoveField(
                model_name="commandlog",
                name="params",
            )
        )

    operations.append(
        migrations.RenameField(
            model_name="commandlog",
            old_name="params1",
            new_name="params",
        ),
    )
