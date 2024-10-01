"""Tests for integrations.aci.aci."""

# pylint: disable=invalid-name
import unittest
from unittest.mock import Mock, patch

from nautobot_chatops.integrations.aci.aci import NautobotPluginChatopsAci, RequestHTTPError


# pylint: disable-next=too-many-public-methods
class TestAciMethods(unittest.TestCase):
    """Test NautobotPluginChatopsAci object methods."""

    def setUp(self):
        """Test setup."""
        self.mock_login = Mock()
        self.mock_login.ok = True
        self.aci_obj = NautobotPluginChatopsAci(
            username="fakeuser", password="fakepwd", base_uri="fakeuri", verify=False
        )  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_tenants(self, mocked_login, mocked_handle_request):
        """Test get_tenants method."""
        mock_fvTenant = Mock()
        mock_fvTenant.status_code = 200
        mock_fvTenant.json.return_value = {
            "imdata": [
                {"fvTenant": {"attributes": {"name": "test_tenant_1"}}},
                {"fvTenant": {"attributes": {"name": "test_tenant_2"}}},
            ]
        }

        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_fvTenant

        assert self.aci_obj.get_tenants() == ["test_tenant_1", "test_tenant_2"]  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_tenants_negative(self, mocked_login, mocked_handle_request):
        """Test get_tenants error response."""
        mock_fvTenant = Mock()
        mock_fvTenant.ok = False
        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_fvTenant

        self.assertRaises(RequestHTTPError, self.aci_obj.get_tenants)  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_aps(self, mocked_login, mocked_handle_request):
        """Test get_aps method."""
        mock_fvAp = Mock()
        mock_fvAp.json.return_value = {
            "imdata": [
                {"fvAp": {"attributes": {"dn": "uni/tn-test-tenant-1/ap-test-ap-1", "name": "test-ap-1"}}},
                {"fvAp": {"attributes": {"dn": "uni/tn-test-tenant-1/ap-test-ap-2", "name": "test-ap-2"}}},
            ]
        }

        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_fvAp

        assert self.aci_obj.get_aps("test-tenant-1") == [
            {"tenant": "test-tenant-1", "ap": "test-ap-1"},
            {"tenant": "test-tenant-1", "ap": "test-ap-2"},
        ]  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_aps_negative(self, mocked_login, mocked_handle_request):
        """Test get_aps error response."""
        mock_fvAp = Mock()
        mock_fvAp.ok = False
        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_fvAp
        self.assertRaises(RequestHTTPError, self.aci_obj.get_aps, "test-tenant")

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_epgs(self, mocked_login, mocked_handle_request):
        """Test get_epgs method."""
        mock_fvAEPg = Mock()
        mock_fvAEPg.status_code = 200
        mock_fvAEPg.json.return_value = {
            "imdata": [
                {
                    "fvAEPg": {
                        "attributes": {"dn": "uni/tn-test-tenant-1/ap-test-ap1/epg-test-epg-1", "name": "test-epg-1"}
                    }
                },
                {
                    "fvAEPg": {
                        "attributes": {"dn": "uni/tn-test-tenant-1/ap-test-ap1/epg-test-epg-2", "name": "test-epg-2"}
                    }
                },
            ]
        }

        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_fvAEPg

        assert self.aci_obj.get_epgs("test-tenant-1", "test-ap1") == [
            {"tenant": "test-tenant-1", "ap": "test-ap1", "epg": "test-epg-1"},
            {"tenant": "test-tenant-1", "ap": "test-ap1", "epg": "test-epg-2"},
        ]  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_epgs_negative(self, mocked_login, mocked_handle_request):
        """Test get_epgs failure response."""
        mock_fvAEPg = Mock()
        mock_fvAEPg.ok = False
        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_fvAEPg
        self.assertRaises(RequestHTTPError, self.aci_obj.get_epgs, "test-tenant-1", "test-ap-1")  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_bd_subnet(self, mocked_login, mocked_handle_request):
        """Test get_bd_subnet method."""
        mock_fvSubnet = Mock()
        mock_fvSubnet.status_code = 200
        mock_fvSubnet.json.return_value = {
            "imdata": [{"fvSubnet": {"attributes": {"ip": "10.1.1.1/24"}}}],
            "totalCount": 1,
        }
        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_fvSubnet
        assert self.aci_obj.get_bd_subnet("test-tenant-1", "bd1") == ["10.1.1.1/24"]  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_bd_subnet_negative(self, mocked_login, mocked_handle_request):
        """Test get_bd_subnet failure response."""
        mock_fvSubnet = Mock()
        mock_fvSubnet.ok = False
        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_fvSubnet
        self.assertRaises(RequestHTTPError, self.aci_obj.get_bd_subnet, "test-tenant-1", "bd-1")  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_contract_filters(self, mocked_login, mocked_handle_request):
        """Test get_contract_filters method."""
        mock_vzSubj = Mock()
        mock_vzSubj.json.return_value = {
            "imdata": [{"vzSubj": {"attributes": {"dn": "uni/tn-test-tenant/brc-test-contract/subj-web"}}}]
        }

        mock_vzRsSubjFiltAtt = Mock()
        mock_vzRsSubjFiltAtt.json.return_value = {
            "imdata": [
                {
                    "vzRsSubjFiltAtt": {
                        "attributes": {
                            "tDn": "uni/tn-test-tenant/brc-test-contract/subj-web/rssubjFiltAtt-web",
                            "action": "permit",
                        }
                    }
                }
            ]
        }

        mock_vzEntry = Mock()
        mock_vzEntry.json.return_value = {
            "imdata": [{"vzEntry": {"attributes": {"name": "web", "dToPort": 80, "etherT": "ip", "prot": "tcp"}}}]
        }
        mocked_login.return_value = self.mock_login
        mocked_handle_request.side_effect = [mock_vzSubj, mock_vzRsSubjFiltAtt, mock_vzEntry]

        expected_data = [{"name": "web", "dstport": 80, "etype": "ip", "prot": "tcp", "action": "permit"}]

        assert self.aci_obj.get_contract_filters("test-tenant", "test-contract") == expected_data  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_contract_filters_negative(self, mocked_login, mocked_handle_request):
        """Test get_contract_filters error response."""
        mock_vzSubj = Mock()
        mock_vzSubj.ok = False
        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_vzSubj
        self.assertRaises(RequestHTTPError, self.aci_obj.get_bd_subnet, "test-tenant-1", "bd-1")  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_static_path_nonPC(self, mocked_login, mocked_handle_request):
        """Test get_static_path method for non-PortChanneled link."""
        mock_fvRsPathAtt = Mock()
        mock_fvRsPathAtt.json.return_value = {
            "imdata": [
                {
                    "fvRsPathAtt": {
                        "attributes": {"encap": "vlan-102", "tDn": "topology/pod-1/paths-101/pathep-[eth1/20]"}
                    }
                }
            ]
        }

        mock_fabricPathEpCont = Mock()
        mock_fabricPathEpCont.json.return_value = {"imdata": [{"fabricPathEpCont": {"attributes": {"nodeId": 102}}}]}

        mock_fabricPathEp = Mock()
        mock_fabricPathEp.json.return_value = {
            "imdata": [{"fabricPathEp": {"attributes": {"name": "eth1/20", "pathT": "leaf"}}}]
        }

        mocked_login.return_value = self.mock_login
        mocked_handle_request.side_effect = [mock_fvRsPathAtt, mock_fabricPathEpCont, mock_fabricPathEp]

        expected_data = [{"encap": "vlan-102", "node_id": 102, "intf": "eth1/20", "pathtype": "leaf", "type": "non-PC"}]

        assert self.aci_obj.get_static_path("test-tenant", "test-ap", "test-epg") == expected_data  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_static_path_PC(self, mocked_login, mocked_handle_request):
        """Test get_static_path method for PortChanneled link."""
        mock_fvRsPathAtt = Mock()
        mock_fvRsPathAtt.json.return_value = {
            "imdata": [
                {
                    "fvRsPathAtt": {
                        "attributes": {
                            "encap": "vlan-101",
                            "tDn": "topology/pod-1/protpaths-101-102/pathep-[vPC-10GE-LACP]",
                        }
                    }
                }
            ]
        }

        mock_fabricProtPathEpCont = Mock()
        mock_fabricProtPathEpCont.json.return_value = {
            "imdata": [{"fabricProtPathEpCont": {"attributes": {"nodeAId": 101, "nodeBId": 102}}}]
        }

        mock_fabricPathEp = Mock()
        mock_fabricPathEp.json.return_value = {
            "imdata": [
                {
                    "fabricPathEp": {
                        "attributes": {
                            "name": "vPC-10GE-LACP",
                        }
                    }
                }
            ]
        }

        mock_infraRtAccBaseGrp = Mock()
        mock_infraRtAccBaseGrp.json.return_value = {
            "imdata": [
                {
                    "infraRtAccBaseGrp": {
                        "attributes": {
                            "tDn": "uni/infra/accportprof-Leaf101_Profile_ifSelector/hports-PORT04-typ-range",
                        }
                    }
                },
                {
                    "infraRtAccBaseGrp": {
                        "attributes": {
                            "tDn": "uni/infra/accportprof-Leaf102_Profile_ifSelector/hports-PORT04-typ-range",
                        }
                    }
                },
            ]
        }

        mock_infraPortBlk1 = Mock()
        mock_infraPortBlk1.json.return_value = {
            "imdata": [{"infraPortBlk": {"attributes": {"toCard": "1", "toPort": "4"}}}]
        }

        mock_infraPortBlk2 = Mock()
        mock_infraPortBlk2.json.return_value = {
            "imdata": [{"infraPortBlk": {"attributes": {"toCard": "1", "toPort": "4"}}}]
        }

        mocked_login.return_value = self.mock_login
        mocked_handle_request.side_effect = [
            mock_fvRsPathAtt,
            mock_fabricProtPathEpCont,
            mock_fabricPathEp,
            mock_infraRtAccBaseGrp,
            mock_infraPortBlk1,
            mock_infraPortBlk2,
        ]

        expected_data = [
            {
                "encap": "vlan-101",
                "node_a": 101,
                "node_b": 102,
                "node_a_intfs": ["1/4"],
                "node_b_intfs": ["1/4"],
                "node_a_ifselector": "Leaf101_Profile_ifSelector",
                "node_b_ifselector": "Leaf102_Profile_ifSelector",
                "type": "vPC",
            }
        ]

        assert self.aci_obj.get_static_path("test-tenant", "test-ap", "test-epg") == expected_data  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_static_path_negative(self, mocked_login, mocked_handle_request):
        """Test get_static_path error response."""
        mock_response = Mock()
        mock_response.ok = False
        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_response
        self.assertRaises(RequestHTTPError, self.aci_obj.get_static_path, "test-tenant-1", "test-ap", "test-epg")  # nosec

    @patch.object(NautobotPluginChatopsAci, "get_static_path")
    @patch.object(NautobotPluginChatopsAci, "get_contract_filters")
    @patch.object(NautobotPluginChatopsAci, "get_bd_subnet")
    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_epg_details(
        self,
        mocked_login,
        mocked_handle_request,
        mocked_get_bd_subnet,
        mocked_get_contract_filters,
        mocked_get_static_path,
    ):
        """Test get_epg_details method."""
        mocked_epg = Mock()
        mocked_epg.json.return_value = {
            "imdata": [
                {"fvRsBd": {"attributes": {"tnFvBDName": "Vlan101_App"}}},
                {"fvRsCons": {"attributes": {"tnVzBrCPName": "App-to-DB"}}},
                {"fvRsProv": {"attributes": {"tnVzBrCPName": "Web-to-App"}}},
                {"fvRsDomAtt": {"attributes": {"tDn": "uni/phys-PHYS"}}},
                {"fvRsPathAtt": {}},
            ]
        }

        mocked_physDomP = Mock()
        mocked_physDomP.json.return_value = {"imdata": [{"physDomP": {"attributes": {"name": "PHYS"}}}]}

        mocked_get_bd_subnet.return_value = "10.1.1.1/24"
        mocked_get_contract_filters.side_effect = [
            [{"name": "mysql", "dstport": "3306", "etype": "ip", "prot": "tcp", "action": "permit"}],
            [{"name": "tcp8080", "dstport": "8080", "etype": "ip", "prot": "tcp", "action": "permit"}],
        ]
        mocked_get_static_path.return_value = [
            {
                "encap": "vlan-100",
                "node_a": "101",
                "node_b": "102",
                "type": "vPC",
                "node_a_intfs": ["1/4"],
                "node_b_intfs": ["1/4"],
                "node_a_ifselector": "Leaf101_Profile_ifSelector",
                "node_b_ifselector": "Leaf102_Profile_ifSelector",
            }
        ]

        mocked_login.return_value = self.mock_login
        mocked_handle_request.side_effect = [mocked_epg, mocked_physDomP]

        expected_data = {
            "bd": "Vlan101_App",
            "subnets": "10.1.1.1/24",
            "provided_contracts": [
                {
                    "name": "Web-to-App",
                    "filters": [
                        {"name": "tcp8080", "dstport": "8080", "etype": "ip", "prot": "tcp", "action": "permit"}
                    ],
                }
            ],
            "consumed_contracts": [
                {
                    "name": "App-to-DB",
                    "filters": [{"name": "mysql", "dstport": "3306", "etype": "ip", "prot": "tcp", "action": "permit"}],
                }
            ],
            "domains": ["PHYS"],
            "static_paths": [
                {
                    "encap": "vlan-100",
                    "node_a": "101",
                    "node_b": "102",
                    "type": "vPC",
                    "node_a_intfs": ["1/4"],
                    "node_b_intfs": ["1/4"],
                    "node_a_ifselector": "Leaf101_Profile_ifSelector",
                    "node_b_ifselector": "Leaf102_Profile_ifSelector",
                }
            ],
            "name": "App",
        }

        assert self.aci_obj.get_epg_details("test-tenant", "3-Tier-App", "App") == expected_data  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_vrfs(self, mocked_login, mocked_handle_request):
        """Test get_vrfs method."""
        mock_fvCtx = Mock()
        mock_fvCtx.json.return_value = {
            "imdata": [
                {"fvCtx": {"attributes": {"dn": "uni/tn-ntc-chatops/ctx-vrf-1", "name": "vrf-1"}}},
                {"fvCtx": {"attributes": {"dn": "uni/tn-ntc-chatops/ctx-vrf-2", "name": "vrf-2"}}},
            ]
        }
        mocked_login.return_value = mocked_login
        mocked_handle_request.return_value = mock_fvCtx

        assert self.aci_obj.get_vrfs("ntc-chatops") == [
            {"tenant": "ntc-chatops", "name": "vrf-1"},
            {"tenant": "ntc-chatops", "name": "vrf-2"},
        ]  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_vrfs_negative(self, mocked_login, mocked_handle_request):
        """Test get_vrfs error response."""
        mock_response = Mock()
        mock_response.ok = False
        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_response
        self.assertRaises(RequestHTTPError, self.aci_obj.get_vrfs, "ntc-chatops")  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_bds(self, mocked_login, mocked_handle_request):
        """Test get_bds method."""
        mocked_fvBD = Mock()
        mocked_fvBD.status_code = 200
        mocked_fvBD.json.return_value = {
            "imdata": [
                {
                    "fvBD": {
                        "attributes": {
                            "dn": "uni/tn-ntc-chatops/BD-Vlan100_Web",
                            "name": "Vlan100_Web",
                            "descr": "WEB",
                            "unicastRoute": "yes",
                            "mac": "00:22:BD:F8:19:FF",
                            "unkMacUcastAct": "proxy",
                        }
                    }
                },
                {
                    "fvBD": {
                        "attributes": {
                            "dn": "uni/tn-ntc-chatops/BD-Vlan101_App",
                            "name": "Vlan101_App",
                            "descr": "APP",
                            "unicastRoute": "yes",
                            "mac": "00:22:BD:F8:19:FF",
                            "unkMacUcastAct": "proxy",
                        }
                    }
                },
            ]
        }

        mocked_fvRsCtx_1 = Mock()
        mocked_fvRsCtx_1.status_code = 200
        mocked_fvRsCtx_1.json.return_value = {"imdata": [{"fvRsCtx": {"attributes": {"tnFvCtxName": "vrf1"}}}]}

        mocked_fvRsCtx_2 = Mock()
        mocked_fvRsCtx_2.status_code = 200
        mocked_fvRsCtx_2.json.return_value = {"imdata": [{"fvRsCtx": {"attributes": {"tnFvCtxName": "vrf2"}}}]}

        mocked_fvSubnet_1 = Mock()
        mocked_fvSubnet_1.status_code = 200
        mocked_fvSubnet_1.json.return_value = {
            "imdata": [{"fvSubnet": {"attributes": {"ip": "10.1.1.1/24", "scope": "public"}}}]
        }

        mocked_fvSubnet_2 = Mock()
        mocked_fvSubnet_2.status_code = 200
        mocked_fvSubnet_2.json.return_value = {
            "imdata": [{"fvSubnet": {"attributes": {"ip": "10.2.2.2/24", "scope": "public"}}}]
        }

        mocked_login.return_value = self.mock_login
        mocked_handle_request.side_effect = [
            mocked_fvBD,
            mocked_fvRsCtx_1,
            mocked_fvSubnet_1,
            mocked_fvRsCtx_2,
            mocked_fvSubnet_2,
        ]

        expected_data = {
            "Vlan100_Web": {
                "tenant": "ntc-chatops",
                "description": "WEB",
                "unicast_routing": "yes",
                "mac": "00:22:BD:F8:19:FF",
                "l2unicast": "proxy",
                "vrf": "vrf1",
                "subnets": [("10.1.1.1/24", "public")],
            },
            "Vlan101_App": {
                "tenant": "ntc-chatops",
                "description": "APP",
                "unicast_routing": "yes",
                "mac": "00:22:BD:F8:19:FF",
                "l2unicast": "proxy",
                "vrf": "vrf2",
                "subnets": [("10.2.2.2/24", "public")],
            },
        }

        assert self.aci_obj.get_bds("ntc-chatops") == expected_data  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_bds_negative(self, mocked_login, mocked_handle_request):
        """Test get_bds error response."""
        mock_response = Mock()
        mock_response.ok = False
        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mock_response
        self.assertRaises(RequestHTTPError, self.aci_obj.get_bds, "ntc-chatops")

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_nodes(self, mocked_login, mocked_handle_request):
        """Test get_nodes method."""
        mock_fabricNode = Mock()
        mock_fabricNode.status_code = 200
        mock_fabricNode.json.return_value = {
            "imdata": [
                {
                    "fabricNode": {
                        "attributes": {
                            "fabricSt": "active",
                            "id": "101",
                            "name": "Leaf101",
                            "model": "N9K-C9396PX",
                            "role": "leaf",
                            "serial": "TEP-1-101",
                            "address": "10.0.160.66",
                        }
                    }
                },
                {
                    "fabricNode": {
                        "attributes": {
                            "fabricSt": "active",
                            "id": "102",
                            "name": "Leaf102",
                            "model": "N9K-C9396PX",
                            "role": "leaf",
                            "serial": "TEP-1-102",
                            "address": "10.0.160.67",
                        }
                    }
                },
            ]
        }

        mock_topSystem = Mock()
        mock_topSystem.status_code = 200
        mock_topSystem.json.return_value = {
            "imdata": [
                {
                    "topSystem": {
                        "attributes": {
                            "id": "101",
                            "podId": "1",
                            "oobMgmtAddr": "10.1.1.101",
                            "systemUpTime": "05:22:43:18.000",
                        }
                    }
                },
                {
                    "topSystem": {
                        "attributes": {
                            "id": "102",
                            "podId": "1",
                            "oobMgmtAddr": "10.1.1.102",
                            "systemUpTime": "05:25:45:54.000",
                        }
                    }
                },
            ]
        }

        mocked_login.return_value = self.mock_login
        mocked_handle_request.side_effect = [mock_fabricNode, mock_topSystem]

        expected_data = {
            "101": {
                "name": "Leaf101",
                "model": "N9K-C9396PX",
                "role": "leaf",
                "serial": "TEP-1-101",
                "fabric_ip": "10.0.160.66",
                "pod": "1",
                "oob_ip": "10.1.1.101",
                "uptime": "05:22:43:18.000",
            },
            "102": {
                "name": "Leaf102",
                "model": "N9K-C9396PX",
                "role": "leaf",
                "serial": "TEP-1-102",
                "fabric_ip": "10.0.160.67",
                "pod": "1",
                "oob_ip": "10.1.1.102",
                "uptime": "05:25:45:54.000",
            },
        }

        assert self.aci_obj.get_nodes() == expected_data  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_nodes_negative(self, mocked_login, mocked_handle_request):
        """Test get_nodes error response."""
        mock_fabricNode = Mock()
        mock_fabricNode.ok = False
        mock_fabricNode.status_code = 400

        mock_topSystem = Mock()
        mock_topSystem.ok = False
        mock_topSystem.status_code = 400

        mocked_login.return_value = self.mock_login
        mocked_handle_request.side_effect = [mock_fabricNode, mock_topSystem]
        self.assertRaises(RequestHTTPError, self.aci_obj.get_nodes)  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_controllers(self, mocked_login, mocked_handle_request):
        """Test get_controllers method."""
        mock_fabricNode = Mock()
        mock_fabricNode.status_code = 200
        mock_fabricNode.json.return_value = {
            "imdata": [
                {
                    "fabricNode": {
                        "attributes": {
                            "fabricSt": "unknown",
                            "id": "1",
                            "name": "apic1",
                            "model": "VMware Virtual Platform",
                            "role": "controller",
                            "serial": "TEP-1-1",
                            "address": "10.0.0.1",
                        }
                    }
                }
            ]
        }

        mock_topSystem = Mock()
        mock_topSystem.status_code = 200
        mock_topSystem.json.return_value = {
            "imdata": [
                {
                    "topSystem": {
                        "attributes": {
                            "id": "1",
                            "podId": "1",
                            "oobMgmtAddr": "10.1.1.1",
                            "systemUpTime": "05:22:43:18.000",
                        }
                    }
                }
            ]
        }
        mocked_login.return_value = self.mock_login
        mocked_handle_request.side_effect = [mock_fabricNode, mock_topSystem]

        expected_data = {
            "1": {
                "name": "apic1",
                "model": "VMware Virtual Platform",
                "role": "controller",
                "serial": "TEP-1-1",
                "fabric_ip": "10.0.0.1",
                "pod": "1",
                "oob_ip": "10.1.1.1",
                "uptime": "05:22:43:18.000",
            },
        }

        assert self.aci_obj.get_controllers() == expected_data  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_controllers_negative(self, mocked_login, mocked_handle_request):
        """Test get_nodes error response."""
        mock_fabricNode = Mock()
        mock_fabricNode.ok = False
        mock_fabricNode.status_code = 400

        mock_topSystem = Mock()
        mock_topSystem.ok = False
        mock_topSystem.status_code = 400

        mocked_login.return_value = self.mock_login
        mocked_handle_request.side_effect = [mock_fabricNode, mock_topSystem]
        self.assertRaises(RequestHTTPError, self.aci_obj.get_controllers)  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_pending_nodes(self, mocked_login, mocked_handle_request):
        """Test get_pending_nodes method."""
        mocked_dhcpClient = Mock()
        mocked_dhcpClient.status_code = 200
        mocked_dhcpClient.json.return_value = {
            "imdata": [
                {
                    "dhcpClient": {
                        "attributes": {
                            "fabricId": "1",
                            "nodeId": "101",
                            "model": "N9K-C9396PX",
                            "nodeRole": "leaf",
                            "id": "TEP-1-101",
                            "supported": "yes",
                        }
                    }
                },
                {
                    "dhcpClient": {
                        "attributes": {
                            "fabricId": "1",
                            "nodeId": "102",
                            "model": "N9K-C9396PX",
                            "nodeRole": "leaf",
                            "id": "TEP-1-102",
                            "supported": "yes",
                        }
                    }
                },
            ]
        }

        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mocked_dhcpClient

        expected_data = {
            "TEP-1-101": {
                "fabric_id": "1",
                "node_id": "101",
                "model": "N9K-C9396PX",
                "role": "leaf",
                "supported": "yes",
            },
            "TEP-1-102": {
                "fabric_id": "1",
                "node_id": "102",
                "model": "N9K-C9396PX",
                "role": "leaf",
                "supported": "yes",
            },
        }

        assert self.aci_obj.get_pending_nodes() == expected_data  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_pending_nodes_negative(self, mocked_login, mocked_handle_request):
        """Test get_nodes error response."""
        mocked_dhcpClient = Mock()
        mocked_dhcpClient.ok = False

        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mocked_dhcpClient
        self.assertRaises(RequestHTTPError, self.aci_obj.get_pending_nodes)  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_interfaces(self, mocked_login, mocked_handle_request):
        """Test get_interfaces method."""
        mocked_l1PhysIf = Mock()
        mocked_l1PhysIf.status_code = 200
        mocked_l1PhysIf.json.return_value = {
            "imdata": [
                {
                    "l1PhysIf": {
                        "attributes": {
                            "id": "eth1/1",
                            "descr": "UCS-6348-1",
                            "speed": "10G",
                            "bw": "0",
                            "usage": "discovery",
                            "layer": "Layer2",
                            "mode": "trunk",
                            "switchingSt": "disabled",
                        },
                        "children": [{"ethpmPhysIf": {"attributes": {"operSt": "down", "operStQual": "admin-down"}}}],
                    }
                },
                {
                    "l1PhysIf": {
                        "attributes": {
                            "id": "eth1/2",
                            "descr": "UCS-6348-2",
                            "speed": "10G",
                            "bw": "0",
                            "usage": "discovery",
                            "layer": "Layer2",
                            "mode": "trunk",
                            "switchingSt": "disabled",
                        },
                        "children": [{"ethpmPhysIf": {"attributes": {"operSt": "down", "operStQual": "admin-down"}}}],
                    }
                },
            ]
        }
        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mocked_l1PhysIf

        expected_data = {
            "eth1/1": {
                "descr": "UCS-6348-1",
                "speed": "10G",
                "bw": "0",
                "usage": "discovery",
                "layer": "Layer2",
                "mode": "trunk",
                "switchingSt": "disabled",
                "state": "down",
                "state_reason": "admin-down",
            },
            "eth1/2": {
                "descr": "UCS-6348-2",
                "speed": "10G",
                "bw": "0",
                "usage": "discovery",
                "layer": "Layer2",
                "mode": "trunk",
                "switchingSt": "disabled",
                "state": "down",
                "state_reason": "admin-down",
            },
        }

        assert self.aci_obj.get_interfaces(1, "101", "all") == expected_data  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_get_interfaces_negative(self, mocked_login, mocked_handle_request):
        """Test get_interfaces error response."""
        mocked_response = Mock()
        mocked_response.ok = False

        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mocked_response
        self.assertRaises(RequestHTTPError, self.aci_obj.get_interfaces, 1, "101", "all")  # nosec

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_register_node(self, mocked_login, mocked_handle_request):
        """Test get_interfaces method."""
        mocked_resp = Mock()
        mocked_resp.status_code == 200  # pylint: disable=W0104
        mocked_resp.return_value = True

        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mocked_resp
        assert self.aci_obj.register_node("TEP-1-101", "101", "Leaf101") is True  # noqa: E712
        mocked_handle_request.assert_called_with(
            "fakeuri/api/node/mo/uni/controller/nodeidentpol.json",
            None,
            request_type="post",
            data={
                "fabricNodeIdentP": {
                    "attributes": {
                        "dn": "uni/controller/nodeidentpol/nodep-TEP-1-101",
                        "serial": "TEP-1-101",
                        "nodeId": "101",
                        "name": "Leaf101",
                    }
                }
            },
        )

    @patch.object(NautobotPluginChatopsAci, "_handle_request")
    @patch.object(NautobotPluginChatopsAci, "_login")
    def test_register_node_negative(self, mocked_login, mocked_handle_request):
        """Test register_node error response."""
        mocked_resp = Mock()
        mocked_resp.ok = False
        mocked_resp.status_code = 500
        mocked_resp.reason = "Bad Request"

        mocked_login.return_value = self.mock_login
        mocked_handle_request.return_value = mocked_resp

        self.assertRaises(RequestHTTPError, self.aci_obj.register_node, "TEP-1-101", "101", "Leaf101")  # nosec
