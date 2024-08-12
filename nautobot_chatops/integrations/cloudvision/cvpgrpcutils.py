"""Utilities for using GRPC with Cloudvision Chatbot."""

import ssl

import arista.tag.v1 as tag
import grpc
import requests
from google.protobuf import wrappers_pb2 as wrappers

from .utils import CVAAS_ADDR, DEFAULT_TIMEOUT


def connect_cv(settings):
    """Connect shared gRPC channel to the configured CloudVision instance."""
    global _channel  # pylint: disable=C0103,W0601

    cvp_host = settings.get("cvp_host")
    # If CVP_HOST is defined, we assume an on-prem installation.
    if cvp_host:
        cvp_url = f"{cvp_host}:8443"
        insecure = settings.get("insecure")
        username = settings.get("cvp_user")
        password = settings.get("cvp_password")
        # If insecure, the cert will be downloaded from the server and automatically trusted for gRPC.
        if insecure:
            cert = bytes(ssl.get_server_certificate((cvp_host, 8443)), "utf-8")
            channel_creds = grpc.ssl_channel_credentials(cert)
            response = requests.post(
                f"https://{cvp_host}/cvpservice/login/authenticate.do",
                auth=(username, password),
                verify=False,  # noqa: S501
                timeout=DEFAULT_TIMEOUT,
            )
        # Otherwise, the server is expected to have a valid certificate signed by a well-known CA.
        else:
            channel_creds = grpc.ssl_channel_credentials()
            response = requests.post(
                f"https://{cvp_host}/cvpservice/login/authenticate.do",
                auth=(username, password),
                timeout=DEFAULT_TIMEOUT,
            )
        call_creds = grpc.access_token_call_credentials(response.json()["sessionId"])
    # Set up credentials for CVaaS using supplied token.
    else:
        if CVAAS_ADDR is None:
            cvp_url = "www.arista.io:443"
        else:
            cvp_url = CVAAS_ADDR
        call_creds = grpc.access_token_call_credentials(settings.get("cvaas_token"))
        channel_creds = grpc.ssl_channel_credentials()
    conn_creds = grpc.composite_channel_credentials(channel_creds, call_creds)
    _channel = grpc.secure_channel(cvp_url, conn_creds)


def disconnect_cv():
    """Close the shared gRPC channel."""
    global _channel  # pylint: disable=global-variable-not-assigned,invalid-name
    _channel.close()


def get_device_tags(device_id: str, settings):
    """Get tags for specific device."""
    connect_cv(settings)
    tag_stub = tag.services.DeviceTagAssignmentConfigServiceStub(_channel)
    req = tag.services.DeviceTagAssignmentConfigStreamRequest(
        partial_eq_filter=[
            tag.models.DeviceTagAssignmentConfig(
                key=tag.models.DeviceTagAssignmentKey(
                    device_id=wrappers.StringValue(value=device_id),  # pylint: disable=no-member
                )
            )
        ]
    )
    responses = tag_stub.GetAll(req)
    tags = []
    for resp in responses:
        dev_tag = {
            "label": resp.value.key.label.value,
            "value": resp.value.key.value.value,
        }
        tags.append(dev_tag)
    return tags
