"""Custom Django Jinja filters."""

from django_jinja import library


@library.filter
def build_service_objects(service):
    """Build service objects."""
    service_objects = []
    name = service.name.upper()
    protocol = service.protocol.upper()
    for port in service.ports:
        service_objects.append(f"{name}_{protocol}_{port}")

    return ", ".join(service_objects)


@library.filter
def build_address_objects(ip_addresses, name):
    """Build address objects."""
    address_objects = []
    for ip_address in ip_addresses.all():
        address_objects.append(f"{name.upper()}_{ip_address.host.replace('.', '_')}_{ip_address.prefix_length}")

    return ", ".join(address_objects)
