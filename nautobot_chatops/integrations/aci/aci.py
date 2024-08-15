"""All interactions with aci."""

import logging
import re
import sys
from datetime import datetime, timedelta

import requests
import urllib3

from .utils import ap_from_dn, tenant_from_dn

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

logger = logging.getLogger("nautobot")


class RequestConnectError(Exception):
    """Exception class to be raised upon requests module connection errors."""


class RequestHTTPError(Exception):
    """Exception class to be raised upon requests module HTTP errors."""


class NautobotPluginChatopsAci:
    """Representation and methods for interacting with aci."""

    def __init__(self, username: str, password: str, base_uri: str, verify: bool):
        """Initialization of aci class."""
        self.username = username
        self.password = password
        self.base_uri = base_uri
        self.verify = verify
        self.cookies = ""
        self.last_login = None
        self.refresh_timeout = None

    def _login(self):
        """Method to log into the ACI fabric and retrieve the token."""
        payload = {"aaaUser": {"attributes": {"name": self.username, "pwd": self.password}}}
        url = self.base_uri + "/api/aaaLogin.json"
        resp = self._handle_request(url, request_type="post", data=payload)
        if resp.ok:
            self.cookies = resp.cookies
            self.last_login = datetime.now()
            self.refresh_timeout = int(resp.json()["imdata"][0]["aaaLogin"]["attributes"]["refreshTimeoutSeconds"])
        return resp

    def _handle_request(self, url: str, params: dict = None, request_type: str = "get", data: dict = None) -> object:
        """Send a REST API call to the APIC."""
        try:
            resp = requests.request(
                method=request_type,
                url=url,
                cookies=self.cookies,
                params=params,
                verify=self.verify,
                json=data,
                timeout=10,
            )
        except requests.exceptions.RequestException as error:
            raise RequestConnectError(f"Error occurred communicating with {self.base_uri}:\n{error}") from error
        return resp

    def _refresh_token(self):
        """Private method to check if the login token needs refreshed. Returns True if login needs refresh."""
        if not self.last_login:
            return True
        # if time diff b/w now and last login greater than refresh_timeout then refresh login
        if datetime.now() - self.last_login > timedelta(seconds=self.refresh_timeout):
            return True
        return False

    def _handle_error(self, response: object):
        """Private method to handle HTTP errors."""
        calling_func = sys._getframe().f_back.f_code.co_name  # pylint: disable=protected-access
        raise RequestHTTPError(
            f"There was an HTTP error while performing the {calling_func} operation on {self.base_uri}:\n"
            f"Error: {response.status_code}, Reason: {response.reason}"
        )

    def _get(self, uri: str, params: dict = None) -> object:
        """Method to retrieve data from the ACI fabric."""
        url = self.base_uri + uri
        if self._refresh_token():
            login_resp = self._login()
            if login_resp.ok:
                resp = self._handle_request(url, params)
                if resp.ok:
                    return resp
                return self._handle_error(resp)
            return self._handle_error(login_resp)
        resp = self._handle_request(url, params)
        if resp.ok:
            return resp
        return self._handle_error(resp)

    def _post(self, uri: str, params: dict = None, data=None) -> object:
        """Method to post data to the ACI fabric."""
        url = self.base_uri + uri
        if self._refresh_token():
            login_resp = self._login()
            if login_resp.ok:
                resp = self._handle_request(url, params, request_type="post", data=data)
                if resp.ok:
                    return resp
                return self._handle_error(resp)
            return self._handle_error(login_resp)
        resp = self._handle_request(url, params, request_type="post", data=data)
        if resp.ok:
            return resp
        return self._handle_error(resp)

    def get_tenants(self) -> list:
        """Retrieve the list of tenants from the ACI fabric."""
        resp = self._get("/api/node/class/fvTenant.json")
        tenant_list = [data["fvTenant"]["attributes"]["name"] for data in resp.json()["imdata"]]
        return tenant_list

    def get_aps(self, tenant: str) -> list:
        """Return Application Profiles from the Cisco APIC."""
        if tenant == "all":
            resp = self._get("/api/node/class/fvAp.json")
        else:
            resp = self._get(f"/api/node/mo/uni/tn-{tenant}.json?query-target=children&target-subtree-class=fvAp")

        ap_list = [
            {"tenant": tenant_from_dn(data["fvAp"]["attributes"]["dn"]), "ap": data["fvAp"]["attributes"]["name"]}
            for data in resp.json()["imdata"]
        ]
        return ap_list

    # pylint: disable-next=invalid-name
    def get_epgs(self, tenant: str, ap: str) -> list:
        """Return EPGs configured in the Cisco APIC."""
        if ap == "all":
            resp = self._get("/api/node/class/fvAEPg.json")
        else:
            resp = self._get(
                f"/api/node/mo/uni/tn-{tenant}/ap-{ap}.json?query-target=children&target-subtree-class=fvAEPg"
            )

        if tenant == "all":
            epg_list = [
                {
                    "tenant": tenant_from_dn(data["fvAEPg"]["attributes"]["dn"]),
                    "ap": ap_from_dn(data["fvAEPg"]["attributes"]["dn"]),
                    "epg": data["fvAEPg"]["attributes"]["name"],
                }
                for data in resp.json()["imdata"]
            ]
        else:
            epg_list = [
                {
                    "tenant": tenant_from_dn(data["fvAEPg"]["attributes"]["dn"]),
                    "ap": ap_from_dn(data["fvAEPg"]["attributes"]["dn"]),
                    "epg": data["fvAEPg"]["attributes"]["name"],
                }
                for data in resp.json()["imdata"]
                if tenant_from_dn(data["fvAEPg"]["attributes"]["dn"]) == tenant
            ]
        return epg_list

    # pylint: disable-next=invalid-name
    def get_bd_subnet(self, tenant: str, bd: str) -> list:
        """Returns the subnet(s) of a BD, or None."""
        resp = self._get(
            f"/api/node/mo/uni/tn-{tenant}/BD-{bd}.json?query-target=children&target-subtree-class=fvSubnet"
        )
        if int(resp.json()["totalCount"]) > 0:
            subnet_list = [data["fvSubnet"]["attributes"]["ip"] for data in resp.json()["imdata"]]
            return subnet_list
        return None

    def get_contract_filters(self, tenant, contract_name: str) -> list:
        """Returns filters for a specified contract."""
        resp = self._get(
            f"/api/node/mo/uni/tn-{tenant}/brc-{contract_name}.json?query-target=subtree&target-subtree-class=vzSubj"
        )
        subj_list = [subj_dn["vzSubj"]["attributes"]["dn"] for subj_dn in resp.json()["imdata"]]
        filter_list = []
        # pylint: disable-next=invalid-name
        for dn in subj_list:
            subj_resp = self._get(f"/api/node/mo/{dn}.json?query-target=subtree&target-subtree-class=vzRsSubjFiltAtt")
            for fltr in subj_resp.json()["imdata"]:
                fltr_dn = fltr["vzRsSubjFiltAtt"]["attributes"]["tDn"]
                entry_resp = self._get(f"/api/node/mo/{fltr_dn}.json?query-target=subtree&target-subtree-class=vzEntry")
                for entry in entry_resp.json()["imdata"]:
                    fltr_dict = {}
                    fltr_dict["name"] = entry["vzEntry"]["attributes"]["name"]
                    fltr_dict["dstport"] = entry["vzEntry"]["attributes"]["dToPort"]
                    fltr_dict["etype"] = entry["vzEntry"]["attributes"]["etherT"]
                    fltr_dict["prot"] = entry["vzEntry"]["attributes"]["prot"]
                    fltr_dict["action"] = fltr["vzRsSubjFiltAtt"]["attributes"]["action"]
                    filter_list.append(fltr_dict)
        return filter_list

    # pylint: disable-next=invalid-name
    def get_static_path(self, tenant: str, ap: str, epg: str) -> list:
        """Return static path mapping details for an EPG."""
        resp = self._get(
            f"/api/node/mo/uni/tn-{tenant}/ap-{ap}/epg-{epg}.json?query-target=subtree&target-subtree-class=fvRsPathAtt"
        )
        sp_list = []
        for obj in resp.json()["imdata"]:
            # pylint: disable-next=use-dict-literal
            sp_dict = dict(encap=obj["fvRsPathAtt"]["attributes"]["encap"])
            # pylint: disable-next=invalid-name
            tDn = obj["fvRsPathAtt"]["attributes"]["tDn"]
            if "paths" in tDn and "protpaths" not in tDn:
                # port on a single node
                sp_dict["type"] = "non-PC"
                pattern = "topology/pod-[0-9]/paths-[0-9]+"
                resp = self._get(f"/api/node/mo/{re.match(pattern, tDn).group()}.json")
                sp_dict["node_id"] = resp.json()["imdata"][0]["fabricPathEpCont"]["attributes"]["nodeId"]
                resp = self._get(f"/api/node/mo/{tDn}.json")
                sp_dict["intf"] = resp.json()["imdata"][0]["fabricPathEp"]["attributes"]["name"]
                sp_dict["pathtype"] = resp.json()["imdata"][0]["fabricPathEp"]["attributes"]["pathT"]
                sp_list.append(sp_dict)
            if "protpaths" in tDn:
                # PortChannel or vPC
                pattern = "topology/pod-[0-9]/protpaths-[0-9]+-[0-9]+"
                resp = self._get(f"/api/node/mo/{re.match(pattern, tDn).group()}.json")
                if len(resp.json()["imdata"]) > 0:
                    sp_dict["node_a"] = resp.json()["imdata"][0]["fabricProtPathEpCont"]["attributes"]["nodeAId"]
                    sp_dict["node_b"] = resp.json()["imdata"][0]["fabricProtPathEpCont"]["attributes"]["nodeBId"]
                    if sp_dict["node_a"] == sp_dict["node_b"]:
                        sp_dict["type"] = "PC"
                    else:
                        sp_dict["type"] = "vPC"

                    resp = self._get(f"/api/node/mo/{tDn}.json")
                    polgrp = resp.json()["imdata"][0]["fabricPathEp"]["attributes"]["name"]
                    resp = self._get(
                        f"/api/node/mo/uni/infra/funcprof/accbundle-{polgrp}.json?"
                        "query-target=subtree&target-subtree-class=infraRtAccBaseGrp"
                    )
                    sp_dict["node_a_intfs"] = []
                    sp_dict["node_b_intfs"] = []
                    for data in resp.json()["imdata"]:
                        # pylint: disable-next=invalid-name
                        tDn = data["infraRtAccBaseGrp"]["attributes"]["tDn"]
                        pattern = "-.*/"
                        ifselector = re.search(pattern, tDn).group().lstrip("-").rstrip("/")
                        resp = self._get(
                            f"/api/node/mo/{tDn}.json?query-target=subtree&target-subtree-class=infraPortBlk"
                        )
                        intfs = [
                            (
                                f"{data['infraPortBlk']['attributes']['toCard']}/"
                                f"{data['infraPortBlk']['attributes']['toPort']}"
                            )
                            for data in resp.json()["imdata"]
                        ]
                        if "node_a_ifselector" not in sp_dict:
                            sp_dict["node_a_ifselector"] = ifselector
                            sp_dict["node_a_intfs"] += intfs
                        elif sp_dict["node_a_ifselector"] == ifselector:
                            sp_dict["node_a_intfs"] += intfs
                        else:
                            sp_dict["node_b_ifselector"] = ifselector
                            sp_dict["node_b_intfs"] += intfs
                else:
                    sp_dict["node_a"] = None
                    sp_dict["node_b"] = None
                    sp_dict["node_a_intfs"] = []
                    sp_dict["node_b_intfs"] = []
                    sp_dict["type"] = None
                sp_list.append(sp_dict)
        return sp_list

    # pylint: disable-next=invalid-name
    def get_epg_details(self, tenant: str, ap: str, epg: str) -> dict:
        """Return EPG configuration details."""
        resp = self._get(f"/api/node/mo/uni/tn-{tenant}/ap-{ap}/epg-{epg}.json?query-target=children")
        # pylint: disable-next=use-dict-literal
        epg_dict = dict(bd=None, subnets=[], provided_contracts=[], consumed_contracts=[], domains=[], static_paths=[])
        epg_dict["name"] = epg
        for obj in resp.json()["imdata"]:
            if "fvRsBd" in obj:
                epg_dict["bd"] = obj["fvRsBd"]["attributes"]["tnFvBDName"]
                epg_dict["subnets"] = self.get_bd_subnet(tenant, epg_dict["bd"])
            if "fvRsCons" in obj:
                epg_dict["consumed_contracts"].append(
                    # pylint: disable-next=use-dict-literal
                    dict(
                        name=obj["fvRsCons"]["attributes"]["tnVzBrCPName"],
                        filters=self.get_contract_filters(tenant, obj["fvRsCons"]["attributes"]["tnVzBrCPName"]),
                    )
                )
            if "fvRsProv" in obj:
                epg_dict["provided_contracts"].append(
                    # pylint: disable-next=use-dict-literal
                    dict(
                        name=obj["fvRsProv"]["attributes"]["tnVzBrCPName"],
                        filters=self.get_contract_filters(tenant, obj["fvRsProv"]["attributes"]["tnVzBrCPName"]),
                    )
                )
            if "fvRsDomAtt" in obj:
                resp = self._get(f"/api/node/mo/{obj['fvRsDomAtt']['attributes']['tDn']}.json")
                epg_dict["domains"].append(resp.json()["imdata"][0]["physDomP"]["attributes"]["name"])
            if "fvRsPathAtt" in obj:
                epg_dict["static_paths"] = self.get_static_path(tenant, ap, epg)
        return epg_dict

    def get_vrfs(self, tenant: str) -> list:
        """Retrieve a list of VRFs in the Cisco APIC."""
        if tenant == "all":
            resp = self._get("/api/node/class/fvCtx.json")
        else:
            resp = self._get(f"/api/node/mo/uni/tn-{tenant}.json?query-target=children&target-subtree-class=fvCtx")
        vrf_list = [
            {"name": data["fvCtx"]["attributes"]["name"], "tenant": tenant_from_dn(data["fvCtx"]["attributes"]["dn"])}
            for data in resp.json()["imdata"]
        ]
        return vrf_list

    def get_bds(self, tenant: str) -> dict:
        """Return Bridge Domains and Subnets from the Cisco APIC."""
        if tenant == "all":
            resp = self._get("/api/node/class/fvBD.json")
        else:
            resp = self._get(f"/api/node/mo/uni/tn-{tenant}.json?query-target=children&target-subtree-class=fvBD")

        bd_dict = {}
        for data in resp.json()["imdata"]:
            bd_dict.setdefault(data["fvBD"]["attributes"]["name"], {})
            bd_dict[data["fvBD"]["attributes"]["name"]]["tenant"] = tenant_from_dn(data["fvBD"]["attributes"]["dn"])
            bd_dict[data["fvBD"]["attributes"]["name"]]["description"] = data["fvBD"]["attributes"]["descr"]
            bd_dict[data["fvBD"]["attributes"]["name"]]["unicast_routing"] = data["fvBD"]["attributes"]["unicastRoute"]
            bd_dict[data["fvBD"]["attributes"]["name"]]["mac"] = data["fvBD"]["attributes"]["mac"]
            bd_dict[data["fvBD"]["attributes"]["name"]]["l2unicast"] = data["fvBD"]["attributes"]["unkMacUcastAct"]

        for key, value in bd_dict.items():
            # get the containing VRF
            resp = self._get(
                f"/api/node/mo/uni/tn-{value['tenant']}/BD-{key}.json?"
                "query-target=children&target-subtree-class=fvRsCtx"
            )

            value["vrf"] = [data["fvRsCtx"]["attributes"]["tnFvCtxName"] for data in resp.json()["imdata"]][0]

            # get subnets
            resp = self._get(
                f"/api/node/mo/uni/tn-{value['tenant']}/BD-{key}.json?"
                "query-target=children&target-subtree-class=fvSubnet"
            )
            subnet_list = [
                (data["fvSubnet"]["attributes"]["ip"], data["fvSubnet"]["attributes"]["scope"])
                for data in resp.json()["imdata"]
            ]
            for subnet in subnet_list:
                value.setdefault("subnets", [])
                value["subnets"].append(subnet)
        return bd_dict

    def get_nodes(self) -> dict:
        """Return list of Leaf/Spine nodes in the ACI fabric."""
        resp = self._get('/api/class/fabricNode.json?query-target-filter=ne(fabricNode.role,"controller")')
        node_dict = {}
        for node in resp.json()["imdata"]:
            if node["fabricNode"]["attributes"]["fabricSt"] == "active":
                node_id = node["fabricNode"]["attributes"]["id"]
                node_dict[node_id] = {}
                node_dict[node_id]["name"] = node["fabricNode"]["attributes"]["name"]
                node_dict[node_id]["model"] = node["fabricNode"]["attributes"]["model"]
                node_dict[node_id]["role"] = node["fabricNode"]["attributes"]["role"]
                node_dict[node_id]["serial"] = node["fabricNode"]["attributes"]["serial"]
                node_dict[node_id]["fabric_ip"] = node["fabricNode"]["attributes"]["address"]
        resp = self._get('/api/class/topSystem.json?query-target-filter=ne(topSystem.role,"controller")')

        for node in resp.json()["imdata"]:
            node_id = node["topSystem"]["attributes"]["id"]
            node_dict[node_id]["pod"] = node["topSystem"]["attributes"]["podId"]
            node_dict[node_id]["oob_ip"] = node["topSystem"]["attributes"]["oobMgmtAddr"]
            node_dict[node_id]["uptime"] = node["topSystem"]["attributes"]["systemUpTime"]
        return node_dict

    def get_controllers(self) -> dict:
        """Return list of Leaf/Spine nodes in the ACI fabric."""
        resp = self._get('/api/class/fabricNode.json?query-target-filter=eq(fabricNode.role,"controller")')
        node_dict = {}
        for node in resp.json()["imdata"]:
            node_id = node["fabricNode"]["attributes"]["id"]
            node_dict[node_id] = {}
            node_dict[node_id]["name"] = node["fabricNode"]["attributes"]["name"]
            node_dict[node_id]["model"] = node["fabricNode"]["attributes"]["model"]
            node_dict[node_id]["role"] = node["fabricNode"]["attributes"]["role"]
            node_dict[node_id]["serial"] = node["fabricNode"]["attributes"]["serial"]
            node_dict[node_id]["fabric_ip"] = node["fabricNode"]["attributes"]["address"]
        resp = self._get('/api/class/topSystem.json?query-target-filter=eq(topSystem.role,"controller")')
        for node in resp.json()["imdata"]:
            node_id = node["topSystem"]["attributes"]["id"]
            node_dict[node_id]["pod"] = node["topSystem"]["attributes"]["podId"]
            node_dict[node_id]["oob_ip"] = node["topSystem"]["attributes"]["oobMgmtAddr"]
            node_dict[node_id]["uptime"] = node["topSystem"]["attributes"]["systemUpTime"]
        return node_dict

    def get_pending_nodes(self) -> dict:
        """Return list of Leaf/Spine nodes which are pending registration."""
        resp = self._get(
            "/api/node/class/dhcpClient.json?query-target-filter"
            '=and(not(wcard(dhcpClient.dn,"__ui_")),and(or(eq(dhcpClient.ip,"0.0.0.0")),'
            'or(eq(dhcpClient.nodeRole,"spine"),eq(dhcpClient.nodeRole,"leaf"),eq(dhcpClient.nodeRole,"unsupported"))))'
        )

        node_dict = {}
        for node in resp.json()["imdata"]:
            # pylint: disable-next=invalid-name
            sn = node["dhcpClient"]["attributes"]["id"]
            node_dict[sn] = {}
            node_dict[sn]["fabric_id"] = node["dhcpClient"]["attributes"]["fabricId"]
            node_dict[sn]["node_id"] = node["dhcpClient"]["attributes"]["nodeId"]
            node_dict[sn]["model"] = node["dhcpClient"]["attributes"]["model"]
            node_dict[sn]["role"] = node["dhcpClient"]["attributes"]["nodeRole"]
            node_dict[sn]["supported"] = node["dhcpClient"]["attributes"]["supported"]
        return node_dict

    def get_interfaces(self, pod_id, node_id, state):
        """Get interfaces on a specified leaf with filtering by up/down state."""
        if state == "all":
            resp = self._get(
                f"/api/node/class/topology/pod-{pod_id}/node-{node_id}/l1PhysIf.json?"
                "rsp-subtree=children&rsp-subtree-class=ethpmPhysIf&order-by=l1PhysIf.id"
            )
        else:
            resp = self._get(
                f"/api/node/class/topology/pod-{pod_id}/node-{node_id}/l1PhysIf.json?"
                "rsp-subtree=children&rsp-subtree-class=ethpmPhysIf&"
                f'rsp-subtree-filter=eq(ethpmPhysIf.operSt,"{state}")&order-by=l1PhysIf.id'
            )

        intf_dict = {}
        for intf in resp.json()["imdata"]:
            if "children" in intf["l1PhysIf"]:
                intf_id = intf["l1PhysIf"]["attributes"]["id"]
                intf_dict[intf_id] = {}
                intf_dict[intf_id]["descr"] = intf["l1PhysIf"]["attributes"]["descr"]
                intf_dict[intf_id]["speed"] = intf["l1PhysIf"]["attributes"]["speed"]
                intf_dict[intf_id]["bw"] = intf["l1PhysIf"]["attributes"]["bw"]
                intf_dict[intf_id]["usage"] = intf["l1PhysIf"]["attributes"]["usage"]
                intf_dict[intf_id]["layer"] = intf["l1PhysIf"]["attributes"]["layer"]
                intf_dict[intf_id]["mode"] = intf["l1PhysIf"]["attributes"]["mode"]
                intf_dict[intf_id]["switchingSt"] = intf["l1PhysIf"]["attributes"]["switchingSt"]
                intf_dict[intf_id]["state"] = intf["l1PhysIf"]["children"][0]["ethpmPhysIf"]["attributes"]["operSt"]
                intf_dict[intf_id]["state_reason"] = intf["l1PhysIf"]["children"][0]["ethpmPhysIf"]["attributes"][
                    "operStQual"
                ]
        return intf_dict

    def register_node(self, serial_nbr, node_id, name) -> bool:
        """Register a new node to the Cisco APIC."""
        payload = {
            "fabricNodeIdentP": {
                "attributes": {
                    "dn": f"uni/controller/nodeidentpol/nodep-{serial_nbr}",
                    "serial": serial_nbr,
                    "nodeId": node_id,
                    "name": name,
                }
            }
        }
        resp = self._post("/api/node/mo/uni/controller/nodeidentpol.json", data=payload)
        if resp.ok:
            return True
        return self._handle_error(resp)
