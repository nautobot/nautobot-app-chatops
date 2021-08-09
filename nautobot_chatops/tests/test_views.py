"""Tests for Nautobot views and related functionality."""

from django.conf import settings
from django.test import TestCase
from django.test.client import RequestFactory


from nautobot_chatops.api.views.slack import (
    verify_signature as slack_verify_signature,
    generate_signature as slack_generate_signature,
)
from nautobot_chatops.api.views.webex import (
    verify_signature as webex_verify_signature,
    generate_signature as webex_generate_signature,
)
from nautobot_chatops.api.views.mattermost import verify_signature as mattermost_verify_signature
from nautobot_chatops.choices import CommandTokenPlatformChoices
from nautobot_chatops.models import CommandToken


class TestSignatureVerification(TestCase):
    """Verify that message signing is correctly validated by each view."""

    def setUp(self):
        """Per-test-case initialization."""
        self.factory = RequestFactory()

        settings.PLUGINS_CONFIG["nautobot_chatops"]["webex_signing_secret"] = "helloworld"
        settings.PLUGINS_CONFIG["nautobot_chatops"]["slack_signing_secret"] = "helloworld"
        settings.PLUGINS_CONFIG["nautobot_chatops"]["enable_slack"] = True
        settings.PLUGINS_CONFIG["nautobot_chatops"]["enable_webex"] = True
        settings.PLUGINS_CONFIG["nautobot_chatops"]["enable_mattermost"] = True
        CommandToken.objects.create(
            comment="*",
            platform=CommandTokenPlatformChoices.MATTERMOST,
            token="helloworld",
        )

    def test_verify_signature_slack(self):
        """Validate the Slack verify_signature function."""
        data = {
            "token": "OZeAd85QzSZ87j3",
            "org_id": "T101A77MM",
            "org_name": "networktocode",
            "channel_id": "D0151KJHUA0",
            "channel_name": "directmessage",
            "user_id": "U011DDZJZ7A",
            "user_name": "glenn.matthews",
            "command": "/na-nautobot",
            "text": "help",
            "response_url": "https://hooks.slack.com/commands/T101A77MM/1211379614961/xvl",
            "trigger_id": "1192022867894.34044245735",
        }
        # The URL doesn't matter as we're testing the function directly, not the view
        request_1 = self.factory.post("/test", data=data)
        valid, reason = slack_verify_signature(request_1)
        self.assertFalse(valid)
        self.assertEqual(reason, "Missing X-Slack-Signature header")

        request_2 = self.factory.post("/test", data=data, HTTP_X_SLACK_SIGNATURE="abc123")
        valid, reason = slack_verify_signature(request_2)
        self.assertFalse(valid)
        self.assertEqual(reason, "Missing X-Slack-Request-Timestamp header")

        request_3 = self.factory.post(
            "/test",
            data=data,
            HTTP_X_SLACK_SIGNATURE="abc123",
            HTTP_X_SLACK_REQUEST_TIMESTAMP="1592849101",
        )
        valid, reason = slack_verify_signature(request_3)
        self.assertFalse(valid)
        self.assertEqual(reason, "Incorrect signature")

        request_4 = self.factory.post(
            "/test",
            data=data,
            HTTP_X_SLACK_REQUEST_TIMESTAMP="1592849101",
            HTTP_X_SLACK_SIGNATURE=slack_generate_signature(request_3),
        )
        valid, reason = slack_verify_signature(request_4)
        self.assertTrue(valid)

    def test_verify_signature_webex(self):
        """Validate the WebEx verify_signature function."""
        data = {
            "id": "Y2lzY29zcGFyazo",
            "name": "ntc-nautobot-poc messages",
            "targetUrl": "https://abc123.ngrok.io/api/plugins/nautobot/webex/",
            "resource": "messages",
            "event": "created",
            "orgId": "Y2lzY29zcGFyazo",
            "createdBy": "Y2lzY29zcGFyazo",
            "appId": "Y2lzY29zcGFyazo",
            "ownedBy": "creator",
            "status": "active",
            "created": "2020-06-15T20:03:49.251Z",
            "actorId": "Y2lzY29zcGFyazo",
            "data": {
                "id": "Y2lzY29zcGFyazo",
                "roomId": "Y2lzY29zcGFyazo",
                "roomType": "direct",
                "personId": "Y2lzY29zcGFyazo",
                "personEmail": "glenn.matthews@networktocode.com",
                "created": "2020-06-22T17:53:02.279Z",
            },
        }
        # The URL doesn't matter as we're testing the function directly, not the view
        request_1 = self.factory.post("/test", content_type="application/json", json=data)
        valid, reason = webex_verify_signature(request_1)
        self.assertFalse(valid)
        self.assertEqual(reason, "Missing X-Spark-Signature header")

        request_2 = self.factory.post(
            "/test", content_type="application/json", json=data, HTTP_X_SPARK_SIGNATURE="abc123"
        )
        valid, reason = webex_verify_signature(request_2)
        self.assertFalse(valid)
        self.assertEqual(reason, "Incorrect signature")

        request_3 = self.factory.post(
            "/test",
            content_type="application/json",
            json=data,
            HTTP_X_SPARK_SIGNATURE=webex_generate_signature(request_1),
        )
        valid, reason = webex_verify_signature(request_3)
        self.assertTrue(valid)

    def test_verify_signature_mattermost(self):
        """Validate the Mattermost verify_signature function."""
        data = {
            "org_id": "T101A77MM",
            "org_name": "networktocode",
            "channel_id": "D0151KJHUA0",
            "channel_name": "directmessage",
            "user_id": "U011DDZJZ7A",
            "user_name": "glenn.matthews",
            "command": "/na-nautobot",
            "text": "help",
            "response_url": "https://hooks.slack.com/commands/T101A77MM/1211379614961/xvl",
            "trigger_id": "1192022867894.34044245735",
        }
        # The URL doesn't matter as we're testing the function directly, not the view
        request_1 = self.factory.post("/test", data=data)
        valid, reason = mattermost_verify_signature(request_1)
        self.assertFalse(valid)
        self.assertEqual(reason, "Missing Command Token in Body or Header")

        request_2 = self.factory.post("/test", data=data, HTTP_AUTHORIZATION="Token abc123")
        valid, reason = mattermost_verify_signature(request_2)
        self.assertFalse(valid)
        self.assertEqual(reason, "Incorrect signature")

        request_3 = self.factory.post("/test", data=data, HTTP_AUTHORIZATION="Token helloworld")
        valid, reason = mattermost_verify_signature(request_3)
        self.assertTrue(valid)

        # Test Interactive Messages
        tokendata = data.copy()
        tokendata["context"] = {"token": "Token helloworld"}
        request_4 = self.factory.post("/test", tokendata, format="json", content_type="application/json")
        valid, reason = mattermost_verify_signature(request_4)
        self.assertTrue(valid)

        # Test Interactive Dialog
        statedata = data.copy()
        statedata["state"] = "Token helloworld"
        request_5 = self.factory.post("/test", statedata, format="json", content_type="application/json")
        valid, reason = mattermost_verify_signature(request_5)
        self.assertTrue(valid)
