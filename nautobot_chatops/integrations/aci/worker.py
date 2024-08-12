"""Worker functions implementing Nautobot "aci" command and subcommands."""

from django.conf import settings
from nautobot.core.celery import nautobot_task
from nautobot.core.settings_funcs import is_truthy

from nautobot_chatops.choices import CommandStatusChoices
from nautobot_chatops.workers import handle_subcommands, subcommand_of

from .aci import NautobotPluginChatopsAci, RequestConnectError, RequestHTTPError
from .utils import build_table, logger, send_logo, send_wait_msg

PLUGIN_SETTINGS = settings.PLUGINS_CONFIG["nautobot_chatops"]


def _read_settings():
    creds = {}
    for key in PLUGIN_SETTINGS["aci_creds"]:
        subkey = key[key.rfind("_") + 1 :].lower()  # noqa: E203
        creds.setdefault(subkey, {})
        if "USERNAME" in key:
            creds[subkey]["username"] = PLUGIN_SETTINGS["aci_creds"][key]
        if "PASSWORD" in key:
            creds[subkey]["password"] = PLUGIN_SETTINGS["aci_creds"][key]
        if "URI" in key:
            creds[subkey]["base_uri"] = PLUGIN_SETTINGS["aci_creds"][key]
        if "VERIFY" in key:
            creds[subkey]["verify"] = is_truthy(PLUGIN_SETTINGS["aci_creds"][key])

    choices = [(key, key) for key in creds]

    return creds, choices


aci_creds, apic_choices = _read_settings()


@nautobot_task
def aci(subcommand, **kwargs):
    """Interact with aci app."""
    return handle_subcommands("aci", subcommand, **kwargs)


@subcommand_of("aci")
def get_tenants(dispatcher, apic):
    """Display tenants configured in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci get-tenants", "Select APIC Cluster", apic_choices)
        return False

    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    send_wait_msg(dispatcher)

    # pylint: disable-next=logging-fstring-interpolation
    logger.info(f"Getting list of tenants from APIC {aci_creds[apic]['base_uri']}")
    try:
        tenant_list = aci_obj.get_tenants()
    except (RequestConnectError, RequestHTTPError) as exc:
        dispatcher.send_error(exc)
        logger.error(exc)
        return CommandStatusChoices.STATUS_FAILED

    table_fields = ["TENANT"]
    table_rows = [[tenant] for tenant in tenant_list]

    send_logo(dispatcher, "get-tenants", f"get-tenants {apic}", args=[("APIC", aci_creds[apic]["base_uri"])])

    # TO-DO: add title argument
    dispatcher.send_large_table(table_fields, table_rows, title="get-tenants")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("aci")
def get_aps(dispatcher, apic, tenant):
    """Display Application Profiles configured in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci get-aps", "Select APIC Cluster", apic_choices)
        return False

    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    if not tenant:
        # pylint: disable-next=logging-fstring-interpolation
        logger.info(f"Getting list of tenants from APIC {aci_creds[apic]['base_uri']} in tenant {tenant}")
        try:
            tenant_list = aci_obj.get_tenants()
        except (RequestConnectError, RequestHTTPError) as exc:
            dispatcher.send_error(exc)
            logger.error(exc)
            return CommandStatusChoices.STATUS_FAILED
        tenant_choices = [(tenant, tenant) for tenant in tenant_list]
        tenant_choices.append(("all", "all"))
        dispatcher.prompt_from_menu(f"aci get-aps {apic}", "Select Tenant", tenant_choices)
        return False

    send_wait_msg(dispatcher)

    # pylint: disable-next=logging-fstring-interpolation
    logger.info(f"Getting list of Application Profiles from APIC {aci_creds[apic]['base_uri']} in tenant {tenant}")
    try:
        ap_list = aci_obj.get_aps(tenant)
    except (RequestConnectError, RequestHTTPError) as exc:
        dispatcher.send_error(exc)
        logger.error(exc)
        return CommandStatusChoices.STATUS_FAILED

    table_fields = ["Tenant", "Application Profile"]
    # pylint: disable-next=invalid-name
    table_rows = [[ap["tenant"], ap["ap"]] for ap in ap_list]

    send_logo(
        dispatcher,
        "get-aps",
        f"get-aps {apic} {tenant}",
        args=[("APIC", aci_creds[apic]["base_uri"]), ("Tenant", tenant)],
    )

    # TO-DO: add title argument
    dispatcher.send_large_table(table_fields, table_rows, title="get-aps")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("aci")
# pylint: disable-next=invalid-name,too-many-branches,too-many-statements,too-many-return-statements
def get_epgs(dispatcher, apic, tenant, ap):
    """Display Endpoint Groups (EPGs) configured in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci get-epgs", "Select APIC Cluster", apic_choices)
        return False

    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    if not tenant:
        # pylint: disable-next=logging-fstring-interpolation
        logger.info(f"Getting list of tenants from APIC {aci_creds[apic]['base_uri']} in tenant {tenant}")
        try:
            tenant_list = aci_obj.get_tenants()
        except (RequestConnectError, RequestHTTPError) as exc:
            dispatcher.send_error(exc)
            logger.error(exc)
            return CommandStatusChoices.STATUS_FAILED
        tenant_choices = [(tenant, tenant) for tenant in tenant_list]
        tenant_choices.append(("all", "all"))
        dispatcher.prompt_from_menu(f"aci get-epgs {apic}", "Select Tenant", tenant_choices)
        return False

    if tenant == "all":
        ap = "all"

    if not ap:
        # pylint: disable-next=logging-fstring-interpolation
        logger.info(f"Getting list of Application Profiles from APIC {aci_creds[apic]['base_uri']} in tenant {tenant}")
        try:
            ap_list = aci_obj.get_aps(tenant)
        except (RequestConnectError, RequestHTTPError) as exc:
            dispatcher.send_error(exc)
            logger.error(exc)
            return CommandStatusChoices.STATUS_FAILED
        ap_choices = [(ap["ap"], ap["ap"]) for ap in ap_list]
        ap_choices.append(("all", "all"))
        dispatcher.prompt_from_menu(f"aci get-epgs {apic} {tenant}", "Select Application Profile", ap_choices)
        return False

    send_wait_msg(dispatcher)

    # pylint: disable-next=logging-fstring-interpolation
    logger.info(f"Getting list of EPGs from APIC {aci_creds[apic]['base_uri']} for app profile {ap}")
    try:
        epg_list = aci_obj.get_epgs(tenant, ap)
    except (RequestConnectError, RequestHTTPError) as exc:
        dispatcher.send_error(exc)
        logger.error(exc)
        return CommandStatusChoices.STATUS_FAILED

    table_fields = ["TENANT", "APPLICATION PROFILE", "EPG"]
    table_rows = [[epg["tenant"], epg["ap"], epg["epg"]] for epg in epg_list]

    send_logo(
        dispatcher,
        "get-epgs",
        f"get-epgs {apic} {tenant} {ap}",
        args=[("APIC", aci_creds[apic]["base_uri"]), ("Tenant", tenant), ("Application Profile", ap)],
    )

    dispatcher.send_large_table(table_fields, table_rows, "get-epgs")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("aci")
# pylint: disable-next=invalid-name,too-many-branches,too-many-locals,too-many-statements,too-many-return-statements
def get_epg_details(dispatcher, apic, tenant, ap, epg):
    """Display details for an Endpoint Group in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci get-epg-details", "Select APIC Cluster", apic_choices)
        return False

    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    if not tenant:
        # pylint: disable-next=logging-fstring-interpolation
        logger.info(f"Getting list of tenants from APIC {aci_creds[apic]['base_uri']} in tenant {tenant}")
        try:
            tenant_list = aci_obj.get_tenants()
        except (RequestConnectError, RequestHTTPError) as exc:
            dispatcher.send_error(exc)
            logger.error(exc)
            return CommandStatusChoices.STATUS_FAILED
        tenant_choices = [(tenant, tenant) for tenant in tenant_list]
        dispatcher.prompt_from_menu(f"aci get-epg-details {apic}", "Select Tenant", tenant_choices)
        return False

    if not ap:
        # pylint: disable-next=logging-fstring-interpolation
        logger.info(f"Getting list of Application Profiles from APIC {aci_creds[apic]['base_uri']} in tenant {tenant}")
        try:
            ap_list = aci_obj.get_aps(tenant)
        except (RequestConnectError, RequestHTTPError) as exc:
            dispatcher.send_error(exc)
            logger.error(exc)
            return CommandStatusChoices.STATUS_FAILED
        ap_choices = [(ap["ap"], ap["ap"]) for ap in ap_list]
        dispatcher.prompt_from_menu(f"aci get-epg-details {apic} {tenant}", "Select Application Profile", ap_choices)
        return False

    if not epg:
        # pylint: disable-next=logging-fstring-interpolation
        logger.info(f"Getting list of EPGs from APIC {aci_creds[apic]['base_uri']} in ap {ap}")
        try:
            epg_list = aci_obj.get_epgs(tenant, ap)
        except (RequestConnectError, RequestHTTPError) as exc:
            dispatcher.send_error(exc)
            logger.error(exc)
            return CommandStatusChoices.STATUS_FAILED
        epg_choices = [(epg["epg"], epg["epg"]) for epg in epg_list]
        dispatcher.prompt_from_menu(f"aci get-epg-details {apic} {tenant} {ap}", "Select Endpoint Group", epg_choices)
        return False

    send_wait_msg(dispatcher)

    # pylint: disable-next=logging-fstring-interpolation
    logger.info(f"Getting EPG details from APIC {aci_creds[apic]['base_uri']} for app profile {ap} epg {epg}")
    try:
        epg_details = aci_obj.get_epg_details(tenant, ap, epg)
    except (RequestConnectError, RequestHTTPError) as exc:
        dispatcher.send_error(exc)
        logger.error(exc)
        return CommandStatusChoices.STATUS_FAILED

    output = ""
    table_fields = ["EPG", "BRIDGE DOMAIN", "SUBNETS", "ASSOCIATED DOMAINS"]
    subnets = ", ".join(epg_details["subnets"])
    domains = ", ".join(epg_details["domains"])
    table_rows = [[epg_details["name"], epg_details["bd"], subnets, domains]]
    table = build_table(table_fields, table_rows)

    output += f"{table}\n"

    output += "\nPROVIDED CONTRACTS:\n"

    if epg_details["provided_contracts"]:
        contract_ct = 0
        for contract in epg_details["provided_contracts"]:
            contract_ct += 1
            output += f"{contract_ct}. {contract['name']}\n"
            output += "\nFilters:\n"
            table_fields = ["NAME", "ETHERTYPE", "PROTOCOL", "DSTPORT", "ACTION"]
            table_rows = []
            for fltr in contract["filters"]:
                table_rows.append([fltr["name"], fltr["etype"], fltr["prot"], fltr["dstport"], fltr["action"]])
            table = build_table(table_fields, table_rows)
            output += f"{table}\n"
    else:
        output += "None\n"

    output += "\nCONSUMED CONTRACTS:\n"

    if epg_details["consumed_contracts"]:
        contract_ct = 0
        for contract in epg_details["consumed_contracts"]:
            contract_ct += 1
            output += f"{contract_ct}. {contract['name']}\n"
            output += "\nFilters:\n"
            table_fields = ["NAME", "ETHERTYPE", "PROTOCOL", "DSTPORT", "ACTION"]
            table_rows = []
            for fltr in contract["filters"]:
                table_rows.append([fltr["name"], fltr["etype"], fltr["prot"], fltr["dstport"], fltr["action"]])
            table = build_table(table_fields, table_rows)
            output += f"{table}\n"
    else:
        output += "None\n"

    output += "\nSTATIC PATH MAPPINGS:\n"

    if epg_details["static_paths"]:
        table_fields = ["NODE A", "NODE B", "NODE-A PORT", "NODE-B PORT", "ENCAP", "TYPE"]
        table_rows = []
        # pylint: disable-next=invalid-name
        for sp in epg_details["static_paths"]:
            if sp["type"] == "non-PC":
                node_a = sp["node_id"]
                node_b = "N/A"
                node_a_port = sp["intf"]
                node_b_port = "N/A"
            else:
                node_a = sp["node_a"]
                node_b = sp["node_b"]
                node_a_port = ", ".join(sp["node_a_intfs"])
                node_b_port = ", ".join(sp["node_b_intfs"])
            table_rows.append([node_a, node_b, node_a_port, node_b_port, sp["encap"], sp["type"]])
        table = build_table(table_fields, table_rows)
        output += f"{table}"
    else:
        output += "None\n"

    send_logo(
        dispatcher,
        "get-epg-details",
        f"get-epg-details {apic} {tenant} {ap} {epg}",
        args=[
            ("APIC", aci_creds[apic]["base_uri"]),
            ("Tenant", tenant),
            ("Application Profile", ap),
            ("Endpoint Group", epg),
        ],
    )

    # dispatcher.send_markdown(f"```{output}```")
    dispatcher.send_snippet(output, title=f"epg-{epg}")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("aci")
def get_vrfs(dispatcher, apic, tenant):
    """Display vrfs configured in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci get-vrfs", "Select APIC Cluster", apic_choices)
        return False

    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    if not tenant:
        # pylint: disable-next=logging-fstring-interpolation
        logger.info(f"Getting list of tenants from APIC {aci_creds[apic]['base_uri']} in tenant {tenant}")
        try:
            tenant_list = aci_obj.get_tenants()
        except (RequestConnectError, RequestHTTPError) as exc:
            dispatcher.send_error(exc)
            logger.error(exc)
            return CommandStatusChoices.STATUS_FAILED
        tenant_choices = [(tenant, tenant) for tenant in tenant_list]
        tenant_choices.append(("all", "all"))
        dispatcher.prompt_from_menu(f"aci get-vrfs {apic}", "Select Tenant", tenant_choices)
        return False

    send_wait_msg(dispatcher)

    # pylint: disable-next=logging-fstring-interpolation
    logger.info(f"Getting list of vrfs from APIC {aci_creds[apic]['base_uri']} for tenant {tenant}")
    try:
        vrf_list = aci_obj.get_vrfs(tenant)
    except (RequestConnectError, RequestHTTPError) as exc:
        dispatcher.send_error(exc)
        logger.error(exc)
        return CommandStatusChoices.STATUS_FAILED

    table_fields = ["TENANT", "VRF"]
    table_rows = [[vrf["tenant"], vrf["name"]] for vrf in vrf_list]

    send_logo(
        dispatcher,
        "get-vrfs",
        f"get-vrfs {apic} {tenant}",
        args=[("APIC", aci_creds[apic]["base_uri"]), ("Tenant", tenant)],
    )

    dispatcher.send_large_table(table_fields, table_rows, title="get-vrfs")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("aci")
def get_bds(dispatcher, apic, tenant):
    """Display Bridge Domains configured in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci get-bds", "Select APIC Cluster", apic_choices)
        return False

    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    if not tenant:
        # pylint: disable-next=logging-fstring-interpolation
        logger.info(f"Getting list of Bridge Domains from APIC {aci_creds[apic]['base_uri']} in tenant {tenant}")
        try:
            tenant_list = aci_obj.get_tenants()
        except (RequestConnectError, RequestHTTPError) as exc:
            dispatcher.send_error(exc)
            logger.error(exc)
            return CommandStatusChoices.STATUS_FAILED
        tenant_choices = [(tenant, tenant) for tenant in tenant_list]
        tenant_choices.append(("all", "all"))
        dispatcher.prompt_from_menu(f"aci get-bds {apic}", "Select Tenant", tenant_choices)
        return False

    send_wait_msg(dispatcher)

    # pylint: disable-next=logging-fstring-interpolation
    logger.info(f"Getting list of Bridge Domains from APIC {aci_creds[apic]['base_uri']} for tenant {tenant}")
    try:
        bd_dict = aci_obj.get_bds(tenant)
    except (RequestConnectError, RequestHTTPError) as exc:
        dispatcher.send_error(exc)
        logger.error(exc)
        return CommandStatusChoices.STATUS_FAILED

    table_fields = [
        "TENANT",
        "BRIDGE DOMAIN",
        "DESCRIPTION",
        "VRF",
        "SUBNET",
        "UNICAST ROUTING",
        "SCOPE",
        "UNKNOWN UNICAST",
    ]
    table_rows = []
    for key, value in bd_dict.items():
        for subnet in value.get("subnets", [("", "")]):
            table_rows.append(
                [
                    value["tenant"],
                    key,
                    value["description"],
                    value["vrf"],
                    subnet[0],
                    value["unicast_routing"],
                    subnet[1],
                    value["l2unicast"],
                ]
            )

    send_logo(
        dispatcher,
        "get-bds",
        f"get-bds {apic} {tenant}",
        args=[("APIC", aci_creds[apic]["base_uri"]), ("Tenant", tenant)],
    )

    dispatcher.send_large_table(table_fields, table_rows, title="get-bds")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("aci")
def get_pending_nodes(dispatcher, apic):
    """Display unregistered nodes in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci get-pending-nodes", "Select APIC Cluster", apic_choices)
        return False

    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    send_wait_msg(dispatcher)

    try:
        node_dict = aci_obj.get_pending_nodes()
    except (RequestHTTPError, RequestConnectError) as exc:
        dispatcher.send_error(exc)
        logger.error(exc)
        return CommandStatusChoices.STATUS_FAILED

    table_fields = ["S/N", "NODE_ID", "MODEL", "ROLE", "SUPPORTED"]
    table_rows = []
    for key, value in node_dict.items():
        table_rows.append(
            [
                key,
                value["node_id"],
                value["model"],
                value["role"],
                value["supported"],
            ]
        )

    send_logo(
        dispatcher, "get-pending-nodes", f"get-pending-nodes {apic}", args=[("APIC", aci_creds[apic]["base_uri"])]
    )

    dispatcher.send_large_table(table_fields, table_rows, title="get-pending-nodes")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("aci")
def get_nodes(dispatcher, apic):
    """Display fabric nodes in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci get-nodes", "Select APIC Cluster", apic_choices)
        return False
    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    send_wait_msg(dispatcher)

    try:
        node_dict = aci_obj.get_nodes()
    except (RequestHTTPError, RequestConnectError) as exc:
        dispatcher.send_error(exc)
        logger.error(exc)
        return CommandStatusChoices.STATUS_FAILED

    table_fields = ["POD", "ID", "NAME", "MODEL", "ROLE", "SERIAL", "TEP IP", "OOB IP", "UPTIME"]
    table_rows = []
    for node in sorted(node_dict):
        table_rows.append(
            [
                node_dict[node]["pod"],
                node,
                node_dict[node]["name"],
                node_dict[node]["model"],
                node_dict[node]["role"],
                node_dict[node]["serial"],
                node_dict[node]["fabric_ip"],
                node_dict[node]["oob_ip"],
                node_dict[node]["uptime"],
            ]
        )

    send_logo(dispatcher, "get-nodes", f"get-nodes {apic}", args=[("APIC", aci_creds[apic]["base_uri"])])

    dispatcher.send_large_table(table_fields, table_rows, title="get-nodes")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("aci")
def get_controllers(dispatcher, apic):
    """Display APIC controllers in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci get-controllers", "Select APIC Cluster", apic_choices)
        return False

    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    send_wait_msg(dispatcher)

    try:
        node_dict = aci_obj.get_controllers()
    except (RequestHTTPError, RequestConnectError) as exc:
        dispatcher.send_error(exc)
        logger.error(exc)
        return CommandStatusChoices.STATUS_FAILED

    table_fields = ["POD", "ID", "NAME", "MODEL", "ROLE", "SERIAL", "TEP IP", "OOB IP", "UPTIME"]
    table_rows = []
    for node in sorted(node_dict):
        table_rows.append(
            [
                node_dict[node]["pod"],
                node,
                node_dict[node]["name"],
                node_dict[node]["model"],
                node_dict[node]["role"],
                node_dict[node]["serial"],
                node_dict[node]["fabric_ip"],
                node_dict[node]["oob_ip"],
                node_dict[node]["uptime"],
            ]
        )

    send_logo(dispatcher, "get-controllers", f"get-controllers {apic}", args=[("APIC", aci_creds[apic]["base_uri"])])

    dispatcher.send_large_table(table_fields, table_rows, title="get-controllers")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("aci")
# pylint: disable-next=too-many-locals,too-many-return-statements
def get_interfaces(dispatcher, apic, pod_id, node_id, state):
    """Display interfaces on a specified node in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci get-interfaces", "Select APIC Cluster", apic_choices)
        return False

    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    if not pod_id:
        pod_choices = [(str(x), str(x)) for x in range(1, 10)]
        dispatcher.prompt_from_menu(f"aci get-interfaces {apic}", "Select Pod", pod_choices)
        return False

    if not node_id:
        node_dict = aci_obj.get_nodes()
        node_choices = [(key, key) for key in node_dict]
        dispatcher.prompt_from_menu(f"aci get-interfaces {apic} {pod_id}", "Select Node", node_choices)
        return False

    if not state:
        state_choices = [("all", "all"), ("up", "up"), ("down", "down")]
        dispatcher.prompt_from_menu(
            f"aci get-interfaces {apic} {pod_id} {node_id}", "Select Interface State", state_choices
        )
        return False

    send_wait_msg(dispatcher)

    try:
        intf_dict = aci_obj.get_interfaces(pod_id, node_id, state)
    except (RequestHTTPError, RequestConnectError) as exc:
        dispatcher.send_error(exc)
        logger.error(exc)
        return CommandStatusChoices.STATUS_FAILED

    table_fields = ["INTERFACE", "DESCRIPTION", "SPEED", "LAYER", "MODE", "STATE", "REASON", "USAGE"]
    table_rows = []
    for key, value in intf_dict.items():
        table_rows.append(
            [
                key,
                value["descr"],
                value["speed"],
                value["layer"],
                value["mode"],
                value["state"],
                value["state_reason"],
                value["usage"],
            ]
        )

    send_logo(
        dispatcher,
        "get-interfaces",
        f"get-interfaces {apic} {pod_id} {node_id}",
        args=[("APIC", aci_creds[apic]["base_uri"]), ("Pod", pod_id), ("NodeId", node_id), ("State", state)],
    )

    dispatcher.send_large_table(table_fields, table_rows, title="get-interfaces")

    return CommandStatusChoices.STATUS_SUCCEEDED


@subcommand_of("aci")
# pylint: disable-next=too-many-return-statements
def register_node(dispatcher, apic, serial_nbr, node_id, name):
    """Register a new fabric node in Cisco ACI."""
    if not apic:
        dispatcher.prompt_from_menu("aci register-node", "Select APIC Cluster", apic_choices)
        return False

    try:
        aci_obj = NautobotPluginChatopsAci(**aci_creds[apic])
    except KeyError:
        dispatcher.send_markdown(
            f"Sorry, there is no cluster configured with name {dispatcher.bold(apic)}", ephemeral=True
        )
        return False

    if not serial_nbr:
        try:
            node_dict = aci_obj.get_pending_nodes()
        except (RequestHTTPError, RequestConnectError) as exc:
            dispatcher.send_error(exc)
            logger.error(exc)
            return CommandStatusChoices.STATUS_FAILED

        if not node_dict:
            dispatcher.send_markdown(
                f"Sorry {dispatcher.user_mention()}, there are no pending nodes to register at this time."
            )
            return CommandStatusChoices.STATUS_SUCCEEDED

        serial_nbr_choices = [(sn, sn) for sn in node_dict]
        multi_input_list = [
            {"type": "select", "label": "Serial Number", "choices": serial_nbr_choices},
            {"type": "text", "label": "Node ID"},
            {"type": "text", "label": "Node Name"},
        ]
        dispatcher.multi_input_dialog("aci", f"register-node {apic}", "Node Details", multi_input_list)
        return False

    # pylint: disable-next=logging-fstring-interpolation
    logger.info(f"SERIAL_NBR: {serial_nbr}, NODE_ID: {node_id}, NAME: {name}")

    if aci_obj.register_node(serial_nbr, node_id, name):
        dispatcher.send_markdown(
            f"{dispatcher.user_mention()} Successfully registered node with the following details:"
        )
        dispatcher.send_markdown(f"Serial Number: {serial_nbr}\nNode ID: {node_id}\nName: {name}")
        return CommandStatusChoices.STATUS_SUCCEEDED
    return CommandStatusChoices.STATUS_FAILED
