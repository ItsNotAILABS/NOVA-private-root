#!/usr/bin/env python3
"""Command-line operator for NOVA polyglot coding capsules."""

from __future__ import annotations

import argparse
import json
import pathlib
import subprocess
import sys

from session_server import compile_and_run, load_registry


def emit(payload: object) -> None:
    print(json.dumps(payload, indent=2, sort_keys=True))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="nova-capsule", description="NOVA polyglot coding capsule CLI")
    sub = parser.add_subparsers(dest="cmd")

    sub.add_parser("languages", help="Print supported language registry")

    run_p = sub.add_parser("run", help="Compile/run a file inside the capsule workspace")
    run_p.add_argument("file")
    run_p.add_argument("--workspace", default=None)
    run_p.add_argument("--timeout", type=int, default=None)

    server_p = sub.add_parser("server", help="Start local session server")
    server_p.add_argument("--host", default="127.0.0.1")
    server_p.add_argument("--port", type=int, default=8787)

    init_p = sub.add_parser("init-demo", help="Create demo frontend/code workspace")
    init_p.add_argument("--workspace", default=str(pathlib.Path(__file__).resolve().parent / "workspace"))

    args = parser.parse_args(argv)
    if args.cmd == "languages" or args.cmd is None:
        emit(load_registry())
        return 0
    if args.cmd == "run":
        result = compile_and_run(args.file, args.workspace, args.timeout)
        emit(result)
        return 0 if result.get("ok") else 1
    if args.cmd == "server":
        server = pathlib.Path(__file__).with_name("session_server.py")
        return subprocess.call([sys.executable, str(server), "--host", args.host, "--port", str(args.port)])
    if args.cmd == "init-demo":
        workspace = pathlib.Path(args.workspace).resolve()
        workspace.mkdir(parents=True, exist_ok=True)
        (workspace / "index.html").write_text("""<!doctype html>
<html><head><meta charset=\"utf-8\"><title>NOVA Capsule Preview</title></head>
<body style=\"font-family:system-ui;background:#020617;color:#f8fafc;padding:48px\">
<h1>NOVA Capsule Preview</h1>
<p>This page was created inside a governed polyglot coding capsule.</p>
</body></html>
""", encoding="utf-8")
        (workspace / "hello.py").write_text("print('hello from NOVA polyglot capsule')\n", encoding="utf-8")
        emit({"ok": True, "workspace": str(workspace), "files": ["index.html", "hello.py"]})
        return 0
    parser.print_help()
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
