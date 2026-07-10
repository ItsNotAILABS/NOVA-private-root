#!/usr/bin/env python3
"""NOVA polyglot coding capsule session server.

Local-first server for live coding sessions. It exposes health, language
inventory, governed run/compile requests, frontend preview, deploy receipts,
and GitHub handoff packets.

Security boundary:
- binds to 127.0.0.1 by default
- uses explicit workspace roots
- blocks shell metacharacter command construction by using argv lists
- treats unsupported compilers as capability gaps, not silent success
"""

from __future__ import annotations

import argparse
import http.server
import json
import os
import pathlib
import shutil
import subprocess
import tempfile
import time
import uuid
from dataclasses import dataclass, asdict
from typing import Any
from urllib.parse import parse_qs, urlparse

ROOT = pathlib.Path(__file__).resolve().parent
LANGUAGE_REGISTRY = ROOT / "languages.json"
DEFAULT_WORKSPACE = ROOT / "workspace"
DEFAULT_PREVIEW = ROOT / "workspace" / "preview"


@dataclass
class Receipt:
    ok: bool
    action: str
    language: str | None
    session_id: str
    started_at: float
    ended_at: float
    stdout: str = ""
    stderr: str = ""
    output_path: str | None = None
    preview_url: str | None = None
    deploy_target: str | None = None
    message: str = ""

    def to_dict(self) -> dict[str, Any]:
        data = asdict(self)
        data["duration_ms"] = int((self.ended_at - self.started_at) * 1000)
        return data


def load_registry() -> dict[str, Any]:
    with LANGUAGE_REGISTRY.open("r", encoding="utf-8") as f:
        return json.load(f)


def language_for_filename(filename: str) -> dict[str, Any] | None:
    suffix = pathlib.Path(filename).suffix.lower()
    for lang in load_registry()["languages"]:
        if suffix in lang.get("extensions", []):
            return lang
    return None


def safe_workspace(path: str | None) -> pathlib.Path:
    base = pathlib.Path(path or DEFAULT_WORKSPACE).resolve()
    base.mkdir(parents=True, exist_ok=True)
    return base


def write_receipt(workspace: pathlib.Path, receipt: Receipt) -> pathlib.Path:
    receipts = workspace / ".nova" / "receipts"
    receipts.mkdir(parents=True, exist_ok=True)
    out = receipts / f"{int(time.time())}-{uuid.uuid4().hex[:8]}-{receipt.action}.json"
    out.write_text(json.dumps(receipt.to_dict(), indent=2, sort_keys=True), encoding="utf-8")
    return out


def run_subprocess(argv: list[str], cwd: pathlib.Path, timeout: int) -> subprocess.CompletedProcess[str]:
    return subprocess.run(argv, cwd=str(cwd), text=True, capture_output=True, timeout=timeout, check=False)


def compile_and_run(filename: str, workspace_path: str | None = None, timeout: int | None = None) -> dict[str, Any]:
    started = time.time()
    session_id = uuid.uuid4().hex
    workspace = safe_workspace(workspace_path)
    file_path = (workspace / filename).resolve()
    if not str(file_path).startswith(str(workspace)):
        receipt = Receipt(False, "run", None, session_id, started, time.time(), message="file escapes workspace")
        write_receipt(workspace, receipt)
        return receipt.to_dict()
    lang = language_for_filename(filename)
    if lang is None:
        receipt = Receipt(False, "run", None, session_id, started, time.time(), message="unsupported file extension")
        write_receipt(workspace, receipt)
        return receipt.to_dict()
    if not file_path.exists():
        receipt = Receipt(False, "run", lang["id"], session_id, started, time.time(), message="file not found")
        write_receipt(workspace, receipt)
        return receipt.to_dict()

    build_dir = pathlib.Path(tempfile.mkdtemp(prefix="nova-capsule-", dir=str(workspace)))
    binary = build_dir / "program"
    compiled_file = build_dir / (file_path.stem + ".js")
    timeout_s = int(timeout or load_registry().get("default_timeout_seconds", 30))

    try:
        stdout = ""
        stderr = ""
        compile_cmd = lang.get("compile")
        if compile_cmd:
            compiler = compile_cmd.split()[0]
            if shutil.which(compiler) is None:
                receipt = Receipt(False, "compile", lang["id"], session_id, started, time.time(), message=f"compiler not available: {compiler}")
                write_receipt(workspace, receipt)
                return receipt.to_dict()
            argv = compile_cmd.format(file=str(file_path), binary=str(binary), build_dir=str(build_dir), compiled_file=str(compiled_file), main_class=file_path.stem).split()
            compiled = run_subprocess(argv, workspace, timeout_s)
            stdout += compiled.stdout
            stderr += compiled.stderr
            if compiled.returncode != 0:
                receipt = Receipt(False, "compile", lang["id"], session_id, started, time.time(), stdout, stderr, message="compile failed")
                write_receipt(workspace, receipt)
                return receipt.to_dict()

        if lang["id"] == "html":
            preview_dir = DEFAULT_PREVIEW
            preview_dir.mkdir(parents=True, exist_ok=True)
            target = preview_dir / file_path.name
            target.write_text(file_path.read_text(encoding="utf-8"), encoding="utf-8")
            receipt = Receipt(True, "preview", lang["id"], session_id, started, time.time(), output_path=str(target), preview_url=f"/preview/{target.name}", message="frontend preview ready")
            write_receipt(workspace, receipt)
            return receipt.to_dict()

        runner = lang.get("runner")
        if runner in (None, "static-preview"):
            receipt = Receipt(True, "compile", lang["id"], session_id, started, time.time(), stdout, stderr, output_path=str(binary) if binary.exists() else None, message="compiled or preview-only language")
            write_receipt(workspace, receipt)
            return receipt.to_dict()
        executable = runner.split()[0].format(binary=str(binary), file=str(file_path), compiled_file=str(compiled_file), main_class=file_path.stem)
        if executable != str(binary) and shutil.which(executable) is None:
            receipt = Receipt(False, "run", lang["id"], session_id, started, time.time(), stdout, stderr, message=f"runner not available: {executable}")
            write_receipt(workspace, receipt)
            return receipt.to_dict()
        argv = runner.format(file=str(file_path), binary=str(binary), build_dir=str(build_dir), compiled_file=str(compiled_file), main_class=file_path.stem).split()
        ran = run_subprocess(argv, workspace, timeout_s)
        stdout += ran.stdout
        stderr += ran.stderr
        receipt = Receipt(ran.returncode == 0, "run", lang["id"], session_id, started, time.time(), stdout, stderr, output_path=str(binary) if binary.exists() else None, message="run complete" if ran.returncode == 0 else "run failed")
        write_receipt(workspace, receipt)
        return receipt.to_dict()
    except subprocess.TimeoutExpired as exc:
        receipt = Receipt(False, "run", lang["id"], session_id, started, time.time(), exc.stdout or "", exc.stderr or "", message="timeout")
        write_receipt(workspace, receipt)
        return receipt.to_dict()


class CapsuleHandler(http.server.SimpleHTTPRequestHandler):
    server_version = "NovaPolyglotCapsule/0.1"

    def do_GET(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        path = parsed.path.rstrip("/") or "/"
        if path == "/":
            return self.send_json({"service": "NOVA polyglot coding capsule", "routes": ["/health", "/languages", "/preview/<file>", "/deploy/packet"]})
        if path == "/health":
            return self.send_json({"ok": True, "service": "nova-polyglot-capsule", "server": "live", "preview": True, "deploy_packet": True})
        if path == "/languages":
            return self.send_json(load_registry())
        if path == "/deploy/packet":
            return self.send_json({"ok": True, "target": "github-handoff", "message": "local deploy packet ready; use receipts under .nova/receipts for commit/deploy handoff"})
        if path.startswith("/preview"):
            preview_root = DEFAULT_PREVIEW.resolve()
            rel = path.replace("/preview", "", 1).lstrip("/") or "index.html"
            target = (preview_root / rel).resolve()
            if not str(target).startswith(str(preview_root)) or not target.exists():
                return self.send_json({"ok": False, "error": "preview_not_found"}, status=404)
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8" if target.suffix == ".html" else "text/plain; charset=utf-8")
            body = target.read_bytes()
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return
        return self.send_json({"ok": False, "error": "not_found", "path": path}, status=404)

    def do_POST(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        if parsed.path.rstrip("/") != "/run":
            return self.send_json({"ok": False, "error": "not_found"}, status=404)
        length = int(self.headers.get("Content-Length", "0"))
        body = self.rfile.read(length).decode("utf-8") if length else "{}"
        payload = json.loads(body)
        result = compile_and_run(payload.get("file", ""), payload.get("workspace"), payload.get("timeout"))
        return self.send_json(result, status=200 if result.get("ok") else 400)

    def send_json(self, payload: dict[str, Any], status: int = 200) -> None:
        body = json.dumps(payload, indent=2, sort_keys=True).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Run NOVA polyglot coding capsule session server.")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8787)
    args = parser.parse_args(argv)
    DEFAULT_WORKSPACE.mkdir(parents=True, exist_ok=True)
    DEFAULT_PREVIEW.mkdir(parents=True, exist_ok=True)
    server = http.server.ThreadingHTTPServer((args.host, args.port), CapsuleHandler)
    print(f"NOVA polyglot capsule live at http://{args.host}:{args.port}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
