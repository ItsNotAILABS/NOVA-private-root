from __future__ import annotations

import hashlib
import json
import os
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

ALLOWED = {"python", "capsula", "matdaemon", "office", "wallet", "receipt"}
TOKEN = os.environ.get("HIM_BRIDGE_TOKEN", "")


def digest(value: object) -> str:
    payload = json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def dispatch(capability: str, payload: object) -> object:
    if capability == "matdaemon":
        return {"engine": "MatDaemon", "accepted": True, "payload": payload}
    if capability == "capsula":
        return {"engine": "CAPSULA", "sandboxed": True, "payload": payload}
    if capability in {"office", "wallet", "receipt", "python"}:
        return {"engine": capability, "queued": True, "payload": payload}
    raise ValueError("unsupported capability")


class Handler(BaseHTTPRequestHandler):
    def send_json(self, status: int, value: object) -> None:
        body = json.dumps(value).encode()
        self.send_response(status)
        self.send_header("content-type", "application/json")
        self.send_header("content-length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self) -> None:
        if self.path == "/health":
            self.send_json(200, {"ok": True, "capabilities": sorted(ALLOWED)})
        else:
            self.send_json(404, {"error": "not_found"})

    def do_POST(self) -> None:
        if self.path != "/v1/tasks/execute":
            return self.send_json(404, {"error": "not_found"})
        if TOKEN and self.headers.get("authorization") != f"Bearer {TOKEN}":
            return self.send_json(401, {"status": "denied_auth"})
        try:
            request = json.loads(self.rfile.read(int(self.headers.get("content-length", "0"))) or b"{}")
            capability = str(request.get("capability", ""))
            if capability not in ALLOWED:
                return self.send_json(403, {"status": "denied_capability"})
            result = dispatch(capability, request.get("payload"))
            receipt = {
                "schema": "medina.him.python_bridge.receipt.v1",
                "task_id": request.get("task_id"),
                "capability": capability,
                "request_hash": digest(request),
                "result_hash": digest(result),
                "timestamp": time.time(),
            }
            self.send_json(200, {"status": "completed", "result": result, "receipt": receipt})
        except Exception as error:
            self.send_json(500, {"status": "failed", "error": str(error)})

    def log_message(self, *_: object) -> None:
        return


if __name__ == "__main__":
    host = os.environ.get("HIM_BRIDGE_HOST", "127.0.0.1")
    port = int(os.environ.get("HIM_BRIDGE_PORT", "8092"))
    print(json.dumps({"ready": True, "url": f"http://{host}:{port}"}))
    ThreadingHTTPServer((host, port), Handler).serve_forever()
