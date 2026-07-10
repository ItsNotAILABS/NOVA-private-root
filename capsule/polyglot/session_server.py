#!/usr/bin/env python3
"""NOVA polyglot coding capsule session server.

Scaled local-first server for live coding sessions. It exposes language
inventory, governed run/compile requests, frontend preview, session records,
project templates, hash manifests, deploy packets, and GitHub handoff lanes.
"""

from __future__ import annotations

import argparse
import http.server
import json
import pathlib
import shutil
import subprocess
import tempfile
import time
import uuid
from dataclasses import asdict, dataclass
from typing import Any
from urllib.parse import parse_qs, urlparse

try:
    from .scaler import build_deploy_packet, build_hash_manifest, create_session, init_project, list_sessions
except ImportError:  # pragma: no cover - direct script execution
    from scaler import build_deploy_packet, build_hash_manifest, create_session, init_project, list_sessions

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
    server_version = "NovaPolyglotCapsule/0.2"

    def do_GET(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        path = parsed.path.rstrip("/") or "/"
        query = parse_qs(parsed.query)
        if path == "/":
            return self.send_json({"service": "NOVA polyglot coding capsule", "routes": ["/health", "/languages", "/sessions", "/manifest?workspace=...", "/preview/<file>", "/deploy/packet?workspace=..."]})
        if path == "/health":
            return self.send_json({"ok": True, "service": "nova-polyglot-capsule", "server": "live", "scaled": True, "preview": True, "deploy_packet": True, "sessions": True})
        if path == "/languages":
            return self.send_json(load_registry())
        if path == "/sessions":
            return self.send_json({"sessions": list_sessions(query.get("workspace_root", [None])[0])})
        if path == "/manifest":
            workspace = query.get("workspace", [str(DEFAULT_WORKSPACE)])[0]
            return self.send_json(build_hash_manifest(workspace))
        if path == "/deploy/packet":
            workspace = query.get("workspace", [str(DEFAULT_WORKSPACE)])[0]
            target = query.get("target", ["github-handoff"])[0]
            return self.send_json(build_deploy_packet(workspace, target))
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
        path = parsed.path.rstrip("/")
        length = int(self.headers.get("Content-Length", "0"))
        body = self.rfile.read(length).decode("utf-8") if length else "{}"
        payload = json.loads(body)
        if path == "/run":
            result = compile_and_run(payload.get("file", ""), payload.get("workspace"), payload.get("timeout"))
            return self.send_json(result, status=200 if result.get("ok") else 400)
        if path == "/sessions":
            result = create_session(payload.get("project", "nova-project"), payload.get("workspace_root"))
            return self.send_json(result)
        if path == "/init-project":
            result = init_project(payload.get("workspace", str(DEFAULT_WORKSPACE)), payload.get("kind", "web"))
            return self.send_json(result)
        return self.send_json({"ok": False, "error": "not_found"}, status=404)

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
