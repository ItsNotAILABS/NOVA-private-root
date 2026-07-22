from __future__ import annotations

from dataclasses import asdict
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import os
import time
from typing import Any

from bridge import NovaIoTBridge
from protocol import AgentSession, DeviceDescriptor, ToolDescriptor, ToolIntent, digest

BRIDGE = NovaIoTBridge()


def sensor_read(arguments: dict[str, Any], device: DeviceDescriptor) -> dict[str, Any]:
    metric = str(arguments.get("metric", "temperature_c"))
    return {"device_id": device.device_id, "metric": metric, "value": 22.5, "unit": "C", "simulated": True}


def relay_set(arguments: dict[str, Any], device: DeviceDescriptor) -> dict[str, Any]:
    state = bool(arguments.get("state", False))
    return {"device_id": device.device_id, "requested_state": state, "applied": True}


def bootstrap() -> None:
    now = int(time.time())
    BRIDGE.register_session(AgentSession(
        session_id="nova-local-session",
        agent_id="nova-sovereign-mind",
        card_version=1,
        capabilities=("iot.sensor.read", "iot.relay.set"),
        issued_at=now - 60,
        expires_at=now + 86400,
        nonce="nova-session-nonce-0001",
    ))
    BRIDGE.register_device(DeviceDescriptor(
        device_id="lab-sensor-01",
        device_type="sensor",
        namespace="nova.iot.lab.sensor.01",
        capabilities=("iot.sensor.read",),
        online=True,
    ))
    BRIDGE.register_device(DeviceDescriptor(
        device_id="lab-relay-01",
        device_type="relay",
        namespace="nova.iot.lab.relay.01",
        capabilities=("iot.relay.set",),
        online=True,
        requires_sandbox=True,
    ))
    BRIDGE.register_tool(ToolDescriptor(
        server_id="nova-local-iot",
        tool_name="read_sensor",
        capability="iot.sensor.read",
        risk_tier="observe",
        input_schema_hash=digest({"metric": "string"}),
        output_schema_hash=digest({"value": "number", "unit": "string"}),
        allowed_device_types=("sensor", "lab-instrument"),
        timeout_ms=3000,
    ), sensor_read)
    BRIDGE.register_tool(ToolDescriptor(
        server_id="nova-local-iot",
        tool_name="set_relay",
        capability="iot.relay.set",
        risk_tier="execute",
        input_schema_hash=digest({"state": "boolean"}),
        output_schema_hash=digest({"applied": "boolean"}),
        allowed_device_types=("relay",),
        timeout_ms=3000,
        requires_human_approval=True,
    ), relay_set)


class Handler(BaseHTTPRequestHandler):
    server_version = "NOVA-IoT-MCP/0.1"

    def _send(self, status: int, payload: Any) -> None:
        body = json.dumps(payload, sort_keys=True).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _body(self) -> dict[str, Any]:
        length = int(self.headers.get("Content-Length", "0"))
        return json.loads(self.rfile.read(length) or b"{}")

    def do_GET(self) -> None:
        if self.path == "/health":
            self._send(200, {"ok": True, "service": "nova-iot-mcp", "receipt_chain_head": BRIDGE.receipts.head})
        elif self.path == "/v1/devices":
            self._send(200, {"devices": [asdict(item) for item in BRIDGE.devices.values()]})
        elif self.path == "/v1/tools":
            self._send(200, {"tools": [asdict(item) for item in BRIDGE.tools.values()]})
        elif self.path == "/v1/receipts":
            self._send(200, {"valid": BRIDGE.receipts.verify(), "receipts": BRIDGE.receipts.export()})
        else:
            self._send(404, {"ok": False, "error": "not-found"})

    def do_POST(self) -> None:
        if self.path != "/v1/invoke":
            self._send(404, {"ok": False, "error": "not-found"})
            return
        try:
            payload = self._body()
            intent = ToolIntent(**payload)
            result = BRIDGE.invoke(intent)
            self._send(200 if result.get("ok") else 403, result)
        except (TypeError, ValueError, json.JSONDecodeError) as exc:
            self._send(400, {"ok": False, "error": "invalid-request", "message": str(exc)})

    def log_message(self, fmt: str, *args: Any) -> None:
        print(json.dumps({"service": "nova-iot-mcp", "message": fmt % args}))


if __name__ == "__main__":
    bootstrap()
    host = os.getenv("NOVA_IOT_HOST", "127.0.0.1")
    port = int(os.getenv("NOVA_IOT_PORT", "8080"))
    print(f"NOVA IoT MCP bridge listening on http://{host}:{port}")
    ThreadingHTTPServer((host, port), Handler).serve_forever()
