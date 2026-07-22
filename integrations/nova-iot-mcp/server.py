from __future__ import annotations

from dataclasses import asdict
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import hmac
import json
import os
from pathlib import Path
import secrets
import time
from typing import Any

from bridge import NovaIoTBridge
from protocol import AgentSession, DeviceDescriptor, ToolDescriptor, ToolIntent, digest

BRIDGE = NovaIoTBridge()
ROOT = Path(__file__).resolve().parent
PAIR_TOKEN = os.getenv("NOVA_IOT_PAIR_TOKEN") or secrets.token_urlsafe(24)
ALLOW_ORIGIN = os.getenv("NOVA_IOT_ALLOW_ORIGIN", "*")


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


def bootstrap() -> None:
    now = int(time.time())
    BRIDGE.register_session(AgentSession(
        session_id="nova-local-session",
        agent_id="nova-sovereign-mind",
        card_version=2,
        capabilities=("iot.sensor.read", "iot.relay.set"),
        issued_at=now - 60,
        expires_at=now + 86400,
        nonce="nova-session-nonce-0002",
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
    server_version = "NOVA-IoT-MCP/0.2"

    def _cors(self) -> None:
        self.send_header("Access-Control-Allow-Origin", ALLOW_ORIGIN)
        self.send_header("Access-Control-Allow-Headers", "Content-Type, X-NOVA-PAIR")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("X-Frame-Options", "DENY")

    def _send(self, status: int, payload: Any) -> None:
        body = json.dumps(payload, sort_keys=True).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self._cors()
        self.end_headers()
        self.wfile.write(body)

    def _send_html(self, path: Path) -> None:
        if not path.is_file():
            self._send(404, {"ok": False, "error": "phone-console-missing"})
            return
        body = path.read_bytes()
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-cache")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("X-Frame-Options", "DENY")
        self.end_headers()
        self.wfile.write(body)

    def _body(self) -> dict[str, Any]:
        length = int(self.headers.get("Content-Length", "0"))
        if length > 1_000_000:
            raise ValueError("request body exceeds 1 MB")
        return json.loads(self.rfile.read(length) or b"{}")

    def _paired(self) -> bool:
        supplied = self.headers.get("X-NOVA-PAIR", "")
        return bool(supplied) and hmac.compare_digest(supplied, PAIR_TOKEN)

    def _require_pairing(self) -> bool:
        if self._paired():
            return True
        self._send(401, {"ok": False, "error": "pairing-required"})
        return False

    def do_OPTIONS(self) -> None:
        self.send_response(204)
        self._cors()
        self.end_headers()

    def do_GET(self) -> None:
        if self.path in {"/", "/phone", "/phone.html"}:
            self._send_html(ROOT / "phone.html")
            return
        if not self._require_pairing():
            return
        if self.path == "/health":
            self._send(200, {
                "ok": True,
                "service": "nova-iot-mcp",
                "version": "0.2",
                "receipt_chain_head": BRIDGE.receipts.head,
                "receipt_chain_valid": BRIDGE.receipts.verify(),
                "devices": len(BRIDGE.devices),
                "tools": len(BRIDGE.tools),
                "server_time": int(time.time()),
            })
        elif self.path == "/v1/devices":
            self._send(200, {"devices": [asdict(item) for item in BRIDGE.devices.values()]})
        elif self.path == "/v1/tools":
            self._send(200, {"tools": [asdict(item) for item in BRIDGE.tools.values()]})
        elif self.path == "/v1/receipts":
            self._send(200, {"valid": BRIDGE.receipts.verify(), "receipts": BRIDGE.receipts.export()})
        elif self.path == "/v1/session":
            session = BRIDGE.sessions.get("nova-local-session")
            self._send(200, {"session": asdict(session) if session else None})
        else:
            self._send(404, {"ok": False, "error": "not-found"})

    def do_POST(self) -> None:
        if not self._require_pairing():
            return
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
        except Exception as exc:
            self._send(500, {"ok": False, "error": "bridge-failure", "message": type(exc).__name__})

    def log_message(self, fmt: str, *args: Any) -> None:
        print(json.dumps({"service": "nova-iot-mcp", "client": self.client_address[0], "message": fmt % args}))


if __name__ == "__main__":
    bootstrap()
    host = os.getenv("NOVA_IOT_HOST", "0.0.0.0")
    port = int(os.getenv("NOVA_IOT_PORT", "8080"))
    print(f"NOVA IoT MCP bridge listening on http://{host}:{port}")
    print(f"NOVA Phone console: http://<desktop-lan-ip>:{port}/phone")
    print(f"NOVA pair token: {PAIR_TOKEN}")
    ThreadingHTTPServer((host, port), Handler).serve_forever()
