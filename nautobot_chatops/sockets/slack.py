"""WebSocket Client to receive inbound notifications from Slack, parse them, and enqueue worker actions."""

import asyncio
import json
import shlex

from asgiref.sync import sync_to_async
from django.conf import settings
from slack_sdk.socket_mode.aiohttp import SocketModeClient
from slack_sdk.socket_mode.request import SocketModeRequest
from slack_sdk.socket_mode.response import SocketModeResponse
from slack_sdk.web.async_client import AsyncWebClient

from nautobot_chatops.dispatchers.slack import SlackDispatcher
from nautobot_chatops.utils import socket_check_and_enqueue_command
from nautobot_chatops.workers import commands_help, get_commands_registry, parse_command_string


# pylint: disable-next=too-many-statements
async def main():
    """Slack Socket Main Loop."""
    # pylint: disable-next=invalid-name
    SLASH_PREFIX = settings.PLUGINS_CONFIG["nautobot_chatops"].get("slack_slash_command_prefix")
    client = SocketModeClient(
        app_token=settings.PLUGINS_CONFIG["nautobot_chatops"].get("slack_app_token"),
        web_client=AsyncWebClient(token=settings.PLUGINS_CONFIG["nautobot_chatops"]["slack_api_token"]),
    )

    async def process(client: SocketModeClient, req: SocketModeRequest):
        client.logger.debug("Worker received a socket request.")
        if req.type == "slash_commands":
            client.logger.debug("Received slash command.")
            # Acknowledge the request anyway
            response = SocketModeResponse(envelope_id=req.envelope_id)
            # Don't forget having await for method calls
            await client.send_socket_mode_response(response)
            await process_slash_command(client, req)

        if req.type == "interactive":
            client.logger.debug("Received interactive request.")
            # Acknowledge the request anyway
            response = SocketModeResponse(envelope_id=req.envelope_id)
            # Don't forget having await for method calls
            await client.send_socket_mode_response(response)
            await process_interactive(client, req)

        if req.type == "events_api" and req.payload.get("event", {}).get("type") == "app_mention":
            client.logger.debug("Received mention of bot")
            response = SocketModeResponse(envelope_id=req.envelope_id)
            await client.send_socket_mode_response(response)
            await process_mention(client, req)

    async def process_slash_command(client, req):
        client.logger.debug("Processing slash command.")
        command = req.payload.get("command")
        command = command.replace(SLASH_PREFIX, "")
        params = req.payload.get("text")
        context = {
            "org_id": req.payload.get("team_id"),
            "org_name": req.payload.get("team_domain"),
            "channel_id": req.payload.get("channel_id"),
            "channel_name": req.payload.get("channel_name"),
            "user_id": req.payload.get("user_id"),
            "user_name": req.payload.get("user_name"),
            "response_url": req.payload.get("response_url"),
            "trigger_id": req.payload.get("trigger_id"),
        }

        try:
            command, subcommand, params = parse_command_string(f"{command} {params}")
        except ValueError as err:
            client.logger.error("%s", err)
            return

        registry = await sync_to_async(get_commands_registry)()

        if command not in registry:
            SlackDispatcher(context).send_markdown(commands_help(prefix=SLASH_PREFIX))

        return await socket_check_and_enqueue_command(registry, command, subcommand, params, context, SlackDispatcher)

    # pylint: disable-next=too-many-locals,too-many-return-statements,too-many-branches,too-many-statements
    async def process_interactive(client, req):
        client.logger.debug("Processing interactive.")
        payload = req.payload

        context = {
            "org_id": payload.get("team", {}).get("id"),
            "org_name": payload.get("team", {}).get("domain"),
            "channel_id": payload.get("channel", {}).get("id"),
            "channel_name": payload.get("channel", {}).get("name"),
            "user_id": payload.get("user", {}).get("id"),
            "user_name": payload.get("user", {}).get("username"),
            "response_url": payload.get("response_url"),
            "trigger_id": payload.get("trigger_id"),
            "thread_ts": req.payload.get("event", {}).get("event_ts")
            or req.payload.get("container", {}).get("thread_ts"),
        }

        # Check for channel_name if channel_id is present
        if context["channel_name"] is None and context["channel_id"] is not None:
            # Get the channel information from Slack API
            channel_info = client.web_client.conversations_info(channel=context["channel_id"])

            # Assign the Channel name out of the conversations info end point
            context["channel_name"] = channel_info["channel"]["name"]

        if "actions" in payload and payload["actions"]:
            # Block action triggered by a non-modal interactive component
            action = payload["actions"][0]
            action_id = action.get("action_id", "")
            block_id = action.get("block_id", "")
            if action["type"] == "static_select":
                value = action.get("selected_option", {}).get("value", "")
                selected_value = f"'{value}'"
            elif action["type"] == "button":
                value = action.get("value")
                selected_value = f"'{value}'"
            else:
                client.logger.error(f"Unhandled action type {action['type']}")

            if settings.PLUGINS_CONFIG["nautobot_chatops"].get("delete_input_on_submission"):
                # Delete the interactive element since it's served its purpose
                SlackDispatcher(context).delete_message(context["response_url"])
            if action_id == "action" and selected_value == "cancel":
                # Nothing more to do
                return

        # pylint: disable-next=too-many-nested-blocks
        elif "view" in payload and payload["view"]:
            # View submission triggered from a modal dialog
            client.logger.info("Submission triggered from a modal dialog")
            client.logger.info(json.dumps(payload, indent=2))
            values = payload["view"].get("state", {}).get("values", {})

            # Handling for multiple fields. This will be used when the multi_input_dialog() method of the Slack
            # Dispatcher class is utilized.
            if len(values) > 1:
                selected_value = ""
                callback_id = payload["view"].get("callback_id")
                # sometimes in the case of back-to-back dialogs there will be
                # parameters included in the callback_id.  Below parses those
                # out and adds them to selected_value.
                try:
                    cmds = shlex.split(callback_id)
                except ValueError as err:
                    client.logger.error("%s", err)
                    return
                for i, cmd in enumerate(cmds):
                    if i == 2:
                        selected_value += shlex.quote(f"'{cmd}'")
                    elif i > 2:
                        selected_value += shlex.quote(f" '{cmd}'")
                action_id = shlex.quote(f"{cmds[0]} {cmds[1]}")

                sorted_params = sorted(values.keys())
                for blk_id in sorted_params:
                    for act_id in values[blk_id].values():
                        if act_id["type"] == "static_select":
                            try:
                                value = act_id["selected_option"]["value"]
                            except (AttributeError, TypeError):
                                # Error is thrown if no option selected and field is optional
                                value = None
                        elif act_id["type"] == "plain_text_input":
                            value = act_id["value"]
                        else:
                            client.logger.error(f"Unhandled dialog type {act_id['type']}")

                        # If an optional parameter is passed, it is returned as a NoneType.
                        # We instead want to return an empty string, otherwise 'None' is returned as a string.
                        if value:
                            selected_value += shlex.quote(f" '{value}'")
                        else:
                            selected_value += shlex.quote(" ''")

            # Original un-modified single-field handling below
            else:
                block_id = sorted(values.keys())[0]
                action_id = sorted(values[block_id].keys())[0]
                action = values[block_id][action_id]
                if action["type"] == "plain_text_input":
                    value = action["value"]
                    selected_value = f"'{value}'"
                else:
                    client.logger.error(f"Unhandled action type {action['type']}")
                    return

            # Modal view submissions don't generally contain a channel ID, but we hide one for our convenience:
            if "private_metadata" in payload["view"]:
                private_metadata = json.loads(payload["view"]["private_metadata"])
                if "channel_id" in private_metadata:
                    context["channel_id"] = private_metadata["channel_id"]
                if "thread_ts" in private_metadata:
                    context["thread_ts"] = private_metadata["thread_ts"]
        else:
            client.logger.error("I didn't understand that notification.")
            return

        client.logger.info(f"action_id: {action_id}, selected_value: {selected_value}")
        try:
            command, subcommand, params = parse_command_string(f"{action_id} {selected_value}")
        except ValueError as err:
            client.logger.error("%s", err)
            return

        # Convert empty parameter strings to NoneType
        for idx, param in enumerate(params):
            if not param:
                params[idx] = None

        client.logger.info(f"command: {command}, subcommand: {subcommand}, params: {params}")

        registry = await sync_to_async(get_commands_registry)()

        if command not in registry:
            SlackDispatcher(context).send_markdown(commands_help(prefix=SLASH_PREFIX))
            return

        # What we'd like to do here is send a "Nautobot is typing..." to the channel,
        # but unfortunately the API we're using doesn't support that (only the legacy/deprecated RTM API does).
        # SlackDispatcher(context).send_busy_indicator()

        return await socket_check_and_enqueue_command(registry, command, subcommand, params, context, SlackDispatcher)

    async def process_mention(client, req):
        context = {
            "org_id": req.payload.get("team_id"),
            "org_name": req.payload.get("team_domain"),
            "channel_id": req.payload.get("event", {}).get("channel"),
            "channel_name": req.payload.get("channel_name"),
            "user_id": req.payload.get("event", {}).get("user"),
            "user_name": req.payload.get("event", {}).get("user"),
            "thread_ts": req.payload.get("event", {}).get("thread_ts"),
        }
        bot_id = req.payload.get("authorizations", [{}])[0].get("user_id")
        text_after_mention = req.payload.get("event", {}).get("text").split(f"<@{bot_id}>")[-1]
        text_after_mention = text_after_mention.replace(SLASH_PREFIX, "")
        try:
            command, subcommand, params = parse_command_string(text_after_mention)
        except ValueError as err:
            client.logger.error("%s", err)
            return

        registry = await sync_to_async(get_commands_registry)()

        if command not in registry:
            SlackDispatcher(context).send_markdown(commands_help(prefix=SLASH_PREFIX))

        return await socket_check_and_enqueue_command(registry, command, subcommand, params, context, SlackDispatcher)

    client.socket_mode_request_listeners.append(process)

    await client.connect()

    await asyncio.sleep(float("inf"))
