from __future__ import annotations

from dataclasses import asdict
import json
import secrets
import sys
import time
from typing import Any

from robot_access import RobotCommand, RobotTaskPlanner, build_default_registry


PROTOCOL_VERSION = "2025-06-18"
SERVER_INFO = {"name": "nova-robot-access-mcp", "version": "0.1.0-alpha"}


class NovaRobotMcpServer:
    def __init__(self) -> None:
        self.registry = build_default_registry()
        self.planner = RobotTaskPlanner(self.registry)
        self.initialized = False

    @staticmethod
    def _result(request_id: Any, result: Any) -> dict[str, Any]:
        return {"jsonrpc": "2.0", "id": request_id, "result": result}

    @staticmethod
    def _error(request_id: Any, code: int, message: str, data: Any = None) -> dict[str, Any]:
        error: dict[str, Any] = {"code": code, "message": message}
        if data is not None:
            error["data"] = data
        return {"jsonrpc": "2.0", "id": request_id, "error": error}

    @classmethod
    def _tool_result(cls, request_id: Any, payload: Any, is_error: bool = False) -> dict[str, Any]:
        return cls._result(request_id, {
            "content": [{"type": "text", "text": json.dumps(payload, sort_keys=True)}],
            "structuredContent": payload,
            "isError": is_error,
        })

    def handle(self, message: dict[str, Any]) -> dict[str, Any] | None:
        request_id = message.get("id")
        method = message.get("method")
        params = message.get("params") or {}
        if message.get("jsonrpc") != "2.0" or not isinstance(method, str):
            return self._error(request_id, -32600, "Invalid Request")

        if method == "initialize":
            self.initialized = True
            return self._result(request_id, {
                "protocolVersion": str(params.get("protocolVersion", PROTOCOL_VERSION)),
                "capabilities": {
                    "tools": {"listChanged": False},
                    "resources": {"subscribe": False, "listChanged": False},
                    "logging": {},
                },
                "serverInfo": SERVER_INFO,
                "instructions": (
                    "NOVA robot/device access MCP. AI planning returns proposal-bound dry-run plans. "
                    "Physical execution remains gated by device promotion status, approval and a configured signed gateway."
                ),
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
                {"uri": "nova://robot/access-points", "name": "Robot access points", "mimeType": "application/json"},
                {"uri": "nova://robot/promotion-levels", "name": "Device promotion levels", "mimeType": "application/json"},
                {"uri": "nova://robot/capability-map", "name": "Robot capability map", "mimeType": "application/json"},
            ]})
        if method == "resources/read":
            return self._read_resource(request_id, str(params.get("uri", "")))
        if method == "logging/setLevel":
            return self._result(request_id, {})
        return self._error(request_id, -32601, "Method not found", {"method": method})

    def _tools(self) -> list[dict[str, Any]]:
        return [
            {
                "name": "nova_robot_list_access_points",
                "description": "List robot, industrial, building, vision and edge-compute integrations.",
                "inputSchema": {"type": "object", "properties": {}, "additionalProperties": False},
                "annotations": {"readOnlyHint": True, "destructiveHint": False, "idempotentHint": True, "openWorldHint": False},
            },
            {
                "name": "nova_robot_plan_task",
                "description": "Translate a natural-language robot/device instruction into a governed proposal. Does not execute.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "instruction": {"type": "string", "minLength": 1},
                        "device_id": {"type": "string", "minLength": 1},
                        "preferred_access": {"type": "string"},
                    },
                    "required": ["instruction", "device_id"],
                    "additionalProperties": False,
                },
                "annotations": {"readOnlyHint": True, "destructiveHint": False, "idempotentHint": False, "openWorldHint": False},
            },
            {
                "name": "nova_robot_set_promotion_status",
                "description": "Set local certification status for a device. Promotion does not bypass gateway or approval controls.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "device_id": {"type": "string", "minLength": 1},
                        "status": {"type": "string", "enum": ["DISCOVERED", "OBSERVE", "SIMULATE", "SUPERVISED", "CERTIFIED"]},
                    },
                    "required": ["device_id", "status"],
                    "additionalProperties": False,
                },
                "annotations": {"readOnlyHint": False, "destructiveHint": False, "idempotentHint": True, "openWorldHint": False},
            },
            {
                "name": "nova_robot_invoke",
                "description": "Invoke a protocol access point. Defaults to dry-run; execute-tier calls require approval_id and promoted device state.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "access_id": {"type": "string"},
                        "device_id": {"type": "string"},
                        "capability": {"type": "string"},
                        "arguments": {"type": "object"},
                        "risk_tier": {"type": "string", "enum": ["observe", "simulate", "prepare", "execute", "critical"]},
                        "dry_run": {"type": "boolean", "default": True},
                        "approval_id": {"type": "string"},
                        "deadline_seconds": {"type": "integer", "minimum": 1, "maximum": 300, "default": 30},
                    },
                    "required": ["access_id", "device_id", "capability", "arguments", "risk_tier"],
                    "additionalProperties": False,
                },
                "annotations": {"readOnlyHint": False, "destructiveHint": True, "idempotentHint": False, "openWorldHint": False},
            },
        ]

    def _call_tool(self, request_id: Any, params: dict[str, Any]) -> dict[str, Any]:
        name = params.get("name")
        arguments = params.get("arguments") or {}
        if not isinstance(arguments, dict):
            return self._error(request_id, -32602, "Tool arguments must be an object")
        try:
            if name == "nova_robot_list_access_points":
                return self._tool_result(request_id, self.registry.list_access_points())
            if name == "nova_robot_plan_task":
                instruction = str(arguments.get("instruction", "")).strip()
                device_id = str(arguments.get("device_id", "")).strip()
                if not instruction or not device_id:
                    raise ValueError("instruction and device_id are required")
                proposal = self.planner.plan(instruction, device_id, arguments.get("preferred_access"))
                return self._tool_result(request_id, proposal)
            if name == "nova_robot_set_promotion_status":
                device_id = str(arguments.get("device_id", "")).strip()
                status = str(arguments.get("status", "")).strip()
                self.registry.set_device_status(device_id, status)
                return self._tool_result(request_id, {"ok": True, "device_id": device_id, "status": status})
            if name == "nova_robot_invoke":
                deadline_seconds = int(arguments.get("deadline_seconds", 30))
                if not 1 <= deadline_seconds <= 300:
                    raise ValueError("deadline_seconds must be between 1 and 300")
                command = RobotCommand(
                    access_id=str(arguments.get("access_id", "")),
                    device_id=str(arguments.get("device_id", "")),
                    capability=str(arguments.get("capability", "")),
                    arguments=dict(arguments.get("arguments") or {}),
                    risk_tier=str(arguments.get("risk_tier", "observe")),
                    dry_run=bool(arguments.get("dry_run", True)),
                    approval_id=arguments.get("approval_id"),
                    deadline=int(time.time()) + deadline_seconds,
                    nonce=secrets.token_hex(16),
                )
                result = self.registry.invoke(command)
                return self._tool_result(request_id, asdict(result), is_error=not result.ok)
            return self._error(request_id, -32602, "Unknown tool", {"name": name})
        except (ValueError, KeyError, PermissionError) as exc:
            return self._tool_result(request_id, {"ok": False, "error": str(exc)}, is_error=True)
        except Exception as exc:
            return self._tool_result(request_id, {"ok": False, "error": type(exc).__name__}, is_error=True)

    def _read_resource(self, request_id: Any, uri: str) -> dict[str, Any]:
        if uri == "nova://robot/access-points":
            payload: Any = self.registry.list_access_points()
        elif uri == "nova://robot/promotion-levels":
            payload = {
                "DISCOVERED": "Known but untrusted; inventory only.",
                "OBSERVE": "Read-only telemetry and health.",
                "SIMULATE": "Commands execute only against simulation or dry-run adapters.",
                "SUPERVISED": "Physical execution requires live approval and local operator supervision.",
                "CERTIFIED": "Tested device profile; still subject to identity, policy, approval and receipt controls.",
            }
        elif uri == "nova://robot/capability-map":
            payload = {
                item["access_id"]: list(item["capabilities"])
                for item in self.registry.list_access_points()
            }
        else:
            return self._error(request_id, -32002, "Resource not found", {"uri": uri})
        return self._result(request_id, {"contents": [{
            "uri": uri,
            "mimeType": "application/json",
            "text": json.dumps(payload, sort_keys=True),
        }]})


def run_stdio() -> None:
    server = NovaRobotMcpServer()
    for raw_line in sys.stdin:
        line = raw_line.strip()
        if not line:
            continue
        try:
            message = json.loads(line)
            response = server.handle(message) if isinstance(message, dict) else server._error(None, -32600, "Invalid Request")
        except json.JSONDecodeError as exc:
            response = server._error(None, -32700, "Parse error", {"message": str(exc)})
        except Exception as exc:
            response = server._error(None, -32603, "Internal error", {"type": type(exc).__name__})
        if response is not None:
            sys.stdout.write(json.dumps(response, separators=(",", ":")) + "\n")
            sys.stdout.flush()


if __name__ == "__main__":
    run_stdio()
