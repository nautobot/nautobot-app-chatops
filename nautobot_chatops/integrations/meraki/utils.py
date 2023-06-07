"""Utilities for Meraki SDK."""

import meraki


class MerakiClient:
    """Meraki client class."""

    def __init__(self, api_key=None):
        """Class constructor."""
        self.dashboard = meraki.DashboardAPI(suppress_logging=True, api_key=api_key)

    def org_name_to_id(self, org_name):
        """Translate Org Name to Org Id."""
        return [org["id"] for org in self.get_meraki_orgs() if org["name"].lower() == org_name.lower()][0]

    def name_to_serial(self, org_name, device_name):
        """Translate Name to Serial."""
        return [
            dev["serial"] for dev in self.get_meraki_devices(org_name) if dev["name"].lower() == device_name.lower()
        ][0]

    def netname_to_id(self, org_name, net_name):
        """Translate Network Name to Network ID."""
        return [
            net["id"] for net in self.get_meraki_networks_by_org(org_name) if net["name"].lower() == net_name.lower()
        ][0]

    def get_meraki_orgs(self):
        """Query the Meraki Dashboard API for a list of defined organizations."""
        return self.dashboard.organizations.getOrganizations()

    def get_meraki_org_admins(self, org_name):
        """Query the Meraki Dashboard API for the admins of a organization."""
        return self.dashboard.organizations.getOrganizationAdmins(self.org_name_to_id(org_name))

    def get_meraki_devices(self, org_name):
        """Query the Meraki Dashboard API for a list of devices in the given organization."""
        return self.dashboard.organizations.getOrganizationDevices(organizationId=self.org_name_to_id(org_name))

    def get_meraki_networks_by_org(self, org_name):
        """Query the Meraki Dashboard API for a list of Networks."""
        return self.dashboard.organizations.getOrganizationNetworks(self.org_name_to_id(org_name))

    def get_meraki_switchports(self, org_name, device_name):
        """Query the Meraki Dashboard API for a list of Switchports for a Switch."""
        return self.dashboard.switch.getDeviceSwitchPorts(self.name_to_serial(org_name, device_name))

    def get_meraki_switchports_status(self, org_name, device_name):
        """Query Meraki for Port Status for a Switch."""
        return self.dashboard.switch.getDeviceSwitchPortsStatuses(self.name_to_serial(org_name, device_name))

    def get_meraki_firewall_performance(self, org_name, device_name):
        """Query Meraki with a firewall to return device performance."""
        return self.dashboard.appliance.getDeviceAppliancePerformance(self.name_to_serial(org_name, device_name))

    def get_meraki_network_ssids(self, org_name, net_name):
        """Query Meraki for a Networks SSIDs."""
        return self.dashboard.wireless.getNetworkWirelessSsids(self.netname_to_id(org_name, net_name))

    def get_meraki_camera_recent(self, org_name, device_name):
        """Query Meraki Recent Cameras."""
        return self.dashboard.camera.getDeviceCameraAnalyticsRecent(self.name_to_serial(org_name, device_name))

    def get_meraki_device_clients(self, org_name, device_name):
        """Query Meraki for Clients."""
        return self.dashboard.devices.getDeviceClients(self.name_to_serial(org_name, device_name))

    def get_meraki_device_lldpcdp(self, org_name, device_name):
        """Query Meraki for Clients."""
        return self.dashboard.devices.getDeviceLldpCdp(self.name_to_serial(org_name, device_name))

    def update_meraki_switch_port(self, org_name, device_name, port, **kwargs):
        """Update SwitchPort Configuration."""
        return self.dashboard.switch.updateDeviceSwitchPort(self.name_to_serial(org_name, device_name), port, **kwargs)

    def port_cycle(self, org_name, device_name, port):
        """Cycle a port on a switch."""
        return self.dashboard.switch.cycleDeviceSwitchPorts(self.name_to_serial(org_name, device_name), list(port))
