from __future__ import annotations

from dataclasses import asdict
import json
import secrets
import sys
import time
from typing import Any

from bridge import NovaIoTBridge
from protocol import AgentSession, DeviceDescriptor, ToolDescriptor, ToolIntent, digest

PROTOCOL_VERSION = "2025-06-18"
SERVER_INFO = {"name": "nova-iot-mcp", "version": "1.0.0"}


def sensor_read(arguments: dict[str, Any], device: DeviceDescriptor) -> dict[str, Any]:
    metric = str(arguments.get("metric", "temperature_c"))
    values = {
        "temperature_c": (22.5, "C"),
        "humidity_pct": (42.0, "%"),
        "voltage_v": (3.31, "V"),
    }
    value, unit = values.get(metric, (0.0, "unknown"))
    return {
        "device_id": device.device_id,
        "metric": metric,
        "value": value,
        "unit": unit,
        "simulated": True,
        "sampled_at": int(time.time()),
    }


def relay_set(arguments: dict[str, Any], device: DeviceDescriptor) -> dict[str, Any]:
    state = bool(arguments.get("state", False))
    return {
        "device_id": device.device_id,
        "requested_state": state,
        "applied": True,
        "simulated": True,
        "applied_at": int(time.time()),
    }


def bootstrap_bridge() -> NovaIoTBridge:
    bridge = NovaIoTBridge()
    now = int(time.time())
    bridge.register_session(AgentSession(
        session_id="nova-mcp-local",
        agent_id="nova-mcp-client",
        card_version=1,
        capabilities=("iot.sensor.read", "iot.relay.set"),
        issued_at=now - 30,
        expires_at=now + 86_400,
        nonce=secrets.token_hex(16),
    ))
    bridge.register_device(DeviceDescriptor(
        device_id="lab-sensor-01",
        device_type="sensor",
        namespace="nova.iot.lab.sensor.01",
        capabilities=("iot.sensor.read",),
        online=True,
    ))
    bridge.register_device(DeviceDescriptor(
        device_id="lab-relay-01",
        device_type="relay",
        namespace="nova.iot.lab.relay.01",
        capabilities=("iot.relay.set",),
        online=True,
        requires_sandbox=True,
    ))
    bridge.register_tool(ToolDescriptor(
        server_id="nova-local-iot",
        tool_name="read_sensor",
        capability="iot.sensor.read",
        risk_tier="observe",
        input_schema_hash=digest({"metric": "string"}),
        output_schema_hash=digest({"value": "number", "unit": "string"}),
        allowed_device_types=("sensor", "lab-instrument"),
        timeout_ms=3_000,
    ), sensor_read)
    bridge.register_tool(ToolDescriptor(
        server_id="nova-local-iot",
        tool_name="set_relay",
        capability="iot.relay.set",
        risk_tier="execute",
        input_schema_hash=digest({"state": "boolean"}),
        output_schema_hash=digest({"applied": "boolean"}),
        allowed_device_types=("relay",),
        timeout_ms=3_000,
        requires_human_approval=True,
    ), relay_set)
    return bridge


class NovaMcpServer:
    def __init__(self) -> None:
        self.bridge = bootstrap_bridge()
        self.initialized = False
        self.client_info: dict[str, Any] = {}

    @staticmethod
    def _error(request_id: Any, code: int, message: str, data: Any = None) -> dict[str, Any]:
        error: dict[str, Any] = {"code": code, "message": message}
        if data is not None:
            error["data"] = data
        return {"jsonrpc": "2.0", "id": request_id, "error": error}

    @staticmethod
    def _result(request_id: Any, result: Any) -> dict[str, Any]:
        return {"jsonrpc": "2.0", "id": request_id, "result": result}

    def handle(self, message: dict[str, Any]) -> dict[str, Any] | None:
        request_id = message.get("id")
        method = message.get("method")
        params = message.get("params") or {}

        if message.get("jsonrpc") != "2.0" or not isinstance(method, str):
            return self._error(request_id, -32600, "Invalid Request")

        if method == "initialize":
            requested = str(params.get("protocolVersion", PROTOCOL_VERSION))
            self.client_info = dict(params.get("clientInfo") or {})
            self.initialized = True
            return self._result(request_id, {
                "protocolVersion": requested,
                "capabilities": {
                    "tools": {"listChanged": False},
                    "resources": {"subscribe": False, "listChanged": False},
                    "logging": {},
                },
                "serverInfo": SERVER_INFO,
                "instructions": "NOVA governed IoT MCP. Current bundled adapters are simulations. Execute-tier tools require approval_id.",
            })

        if method == "notifications/initialized":
            self.initialized = True
            return None

        if method == "ping":
            return self._result(request_id, {})

        if not self.initialized:
            return self._error(request_id, -32002, "Server not initialized")

        if method == "tools/list":
            return self._result(request_id, {"tools": self._tools()})

        if method == "tools/call":
            return self._call_tool(request_id, params)

        if method == "resources/list":
            return self._result(request_id, {"resources": [
                {
                    "uri": "nova://devices",
                    "name": "NOVA IoT devices",
                    "description": "Registered device descriptors and online state",
                    "mimeType": "application/json",
                },
                {
                    "uri": "nova://receipts",
                    "name": "NOVA execution receipts",
                    "description": "Current hash-chained receipt history",
                    "mimeType": "application/json",
                },
            ]})

        if method == "resources/read":
            uri = str(params.get("uri", ""))
            if uri == "nova://devices":
                payload = [asdict(item) for item in self.bridge.devices.values()]
            elif uri == "nova://receipts":
                payload = {"valid": self.bridge.receipts.verify(), "receipts": self.bridge.receipts.export()}
            else:
                return self._error(request_id, -32002, "Resource not found", {"uri": uri})
            return self._result(request_id, {"contents": [{
                "uri": uri,
                "mimeType": "application/json",
                "text": json.dumps(payload, sort_keys=True),
            }]})

        if method == "logging/setLevel":
            return self._result(request_id, {})

        return self._error(request_id, -32601, "Method not found", {"method": method})

    def _tools(self) -> list[dict[str, Any]]:
        return [
            {
                "name": "nova_iot_read_sensor",
                "description": "Read a registered NOVA sensor. Bundled adapter returns simulated telemetry.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "device_id": {"type": "string", "default": "lab-sensor-01"},
                        "metric": {"type": "string", "enum": ["temperature_c", "humidity_pct", "voltage_v"]},
                    },
                    "required": ["metric"],
                    "additionalProperties": False,
                },
                "annotations": {"readOnlyHint": True, "destructiveHint": False, "idempotentHint": True, "openWorldHint": False},
            },
            {
                "name": "nova_iot_set_relay",
                "description": "Request a governed relay state change. Requires approval_id and remains simulated in the bundled adapter.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "device_id": {"type": "string", "default": "lab-relay-01"},
                        "state": {"type": "boolean"},
                        "approval_id": {"type": "string", "minLength": 1},
                        "dry_run": {"type": "boolean", "default": True},
                    },
                    "required": ["state", "approval_id"],
                    "additionalProperties": False,
                },
                "annotations": {"readOnlyHint": False, "destructiveHint": True, "idempotentHint": True, "openWorldHint": False},
            },
            {
                "name": "nova_iot_list_devices",
                "description": "List registered NOVA IoT devices and capabilities.",
                "inputSchema": {"type": "object", "properties": {}, "additionalProperties": False},
                "annotations": {"readOnlyHint": True, "destructiveHint": False, "idempotentHint": True, "openWorldHint": False},
            },
            {
                "name": "nova_iot_verify_receipts",
                "description": "Verify the in-process NOVA receipt chain and return its head.",
                "inputSchema": {"type": "object", "properties": {}, "additionalProperties": False},
                "annotations": {"readOnlyHint": True, "destructiveHint": False, "idempotentHint": True, "openWorldHint": False},
            },
        ]

    def _call_tool(self, request_id: Any, params: dict[str, Any]) -> dict[str, Any]:
        name = params.get("name")
        arguments = params.get("arguments") or {}
        if not isinstance(arguments, dict):
            return self._error(request_id, -32602, "Tool arguments must be an object")

        if name == "nova_iot_list_devices":
            result = [asdict(item) for item in self.bridge.devices.values()]
            return self._tool_result(request_id, result)

        if name == "nova_iot_verify_receipts":
            result = {"valid": self.bridge.receipts.verify(), "head": self.bridge.receipts.head, "count": len(self.bridge.receipts.export())}
            return self._tool_result(request_id, result)

        now = int(time.time())
        if name == "nova_iot_read_sensor":
            metric = arguments.get("metric")
            if metric not in {"temperature_c", "humidity_pct", "voltage_v"}:
                return self._tool_error(request_id, "Unsupported sensor metric")
            intent = ToolIntent(
                request_id=secrets.token_hex(8),
                session_id="nova-mcp-local",
                agent_id="nova-mcp-client",
                capability="iot.sensor.read",
                server_id="nova-local-iot",
                tool_name="read_sensor",
                device_id=str(arguments.get("device_id", "lab-sensor-01")),
                arguments={"metric": metric},
                risk_tier="observe",
                intent_nonce=secrets.token_hex(16),
                deadline=now + 30,
                approval_id=None,
                dry_run=False,
            )
        elif name == "nova_iot_set_relay":
            if "state" not in arguments or not isinstance(arguments.get("state"), bool):
                return self._tool_error(request_id, "state must be boolean")
            approval_id = arguments.get("approval_id")
            if not isinstance(approval_id, str) or not approval_id:
                return self._tool_error(request_id, "approval_id is required")
            intent = ToolIntent(
                request_id=secrets.token_hex(8),
                session_id="nova-mcp-local",
                agent_id="nova-mcp-client",
                capability="iot.relay.set",
                server_id="nova-local-iot",
                tool_name="set_relay",
                device_id=str(arguments.get("device_id", "lab-relay-01")),
                arguments={"state": arguments["state"]},
                risk_tier="execute",
                intent_nonce=secrets.token_hex(16),
                deadline=now + 30,
                approval_id=approval_id,
                dry_run=bool(arguments.get("dry_run", True)),
            )
        else:
            return self._error(request_id, -32602, "Unknown tool", {"name": name})

        result = self.bridge.invoke(intent)
        return self._tool_result(request_id, result, is_error=not bool(result.get("ok")))

    @staticmethod
    def _tool_result(request_id: Any, payload: Any, is_error: bool = False) -> dict[str, Any]:
        return NovaMcpServer._result(request_id, {
            "content": [{"type": "text", "text": json.dumps(payload, sort_keys=True)}],
            "structuredContent": payload,
            "isError": is_error,
        })

    @staticmethod
    def _tool_error(request_id: Any, message: str) -> dict[str, Any]:
        return NovaMcpServer._tool_result(request_id, {"ok": False, "error": message}, is_error=True)


def run_stdio() -> None:
    server = NovaMcpServer()
    for raw_line in sys.stdin:
        line = raw_line.strip()
        if not line:
            continue
        try:
            message = json.loads(line)
            if not isinstance(message, dict):
                response = server._error(None, -32600, "Invalid Request")
            else:
                response = server.handle(message)
        except json.JSONDecodeError as exc:
            response = server._error(None, -32700, "Parse error", {"message": str(exc)})
        except Exception as exc:
            response = server._error(None, -32603, "Internal error", {"type": type(exc).__name__})
        if response is not None:
            sys.stdout.write(json.dumps(response, separators=(",", ":")) + "\n")
            sys.stdout.flush()


if __name__ == "__main__":
    run_stdio()
