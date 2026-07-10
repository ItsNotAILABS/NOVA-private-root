#!/usr/bin/env python3
"""Command-line operator for NOVA polyglot coding capsules."""

from __future__ import annotations

import argparse
import json
import pathlib
import subprocess
import sys

try:
    from .scaler import build_deploy_packet, build_hash_manifest, create_session, init_project, list_sessions
    from .session_server import compile_and_run, load_registry
except ImportError:  # pragma: no cover - direct script execution
    from scaler import build_deploy_packet, build_hash_manifest, create_session, init_project, list_sessions
    from session_server import compile_and_run, load_registry


def emit(payload: object) -> None:
    print(json.dumps(payload, indent=2, sort_keys=True))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="nova-capsule", description="NOVA polyglot coding capsule CLI")
    sub = parser.add_subparsers(dest="cmd")

    sub.add_parser("languages", help="Print supported language registry")
    sub.add_parser("sessions", help="List active session records")

    create_p = sub.add_parser("create-session", help="Create a scaled project session")
    create_p.add_argument("--project", default="nova-project")
    create_p.add_argument("--workspace-root", default=None)

    init_project_p = sub.add_parser("init-project", help="Initialize a project template")
    init_project_p.add_argument("--workspace", default=str(pathlib.Path(__file__).resolve().parent / "workspace"))
    init_project_p.add_argument("--kind", choices=["web", "python", "cpp", "java"], default="web")

    run_p = sub.add_parser("run", help="Compile/run a file inside the capsule workspace")
    run_p.add_argument("file")
    run_p.add_argument("--workspace", default=None)
    run_p.add_argument("--timeout", type=int, default=None)

    manifest_p = sub.add_parser("manifest", help="Generate hash manifest for a workspace")
    manifest_p.add_argument("--workspace", default=str(pathlib.Path(__file__).resolve().parent / "workspace"))

    deploy_p = sub.add_parser("deploy-packet", help="Generate a deploy handoff packet")
    deploy_p.add_argument("--workspace", default=str(pathlib.Path(__file__).resolve().parent / "workspace"))
    deploy_p.add_argument("--target", default="github-handoff")

    server_p = sub.add_parser("server", help="Start local session server")
    server_p.add_argument("--host", default="127.0.0.1")
    server_p.add_argument("--port", type=int, default=8787)

    init_p = sub.add_parser("init-demo", help="Create demo frontend/code workspace")
    init_p.add_argument("--workspace", default=str(pathlib.Path(__file__).resolve().parent / "workspace"))

    args = parser.parse_args(argv)
    if args.cmd == "languages" or args.cmd is None:
        emit(load_registry())
        return 0
    if args.cmd == "sessions":
        emit({"sessions": list_sessions()})
        return 0
    if args.cmd == "create-session":
        emit(create_session(args.project, args.workspace_root))
        return 0
    if args.cmd == "init-project":
        emit(init_project(args.workspace, args.kind))
        return 0
    if args.cmd == "run":
        result = compile_and_run(args.file, args.workspace, args.timeout)
        emit(result)
        return 0 if result.get("ok") else 1
    if args.cmd == "manifest":
        emit(build_hash_manifest(args.workspace))
        return 0
    if args.cmd == "deploy-packet":
        emit(build_deploy_packet(args.workspace, args.target))
        return 0
    if args.cmd == "server":
        server = pathlib.Path(__file__).with_name("session_server.py")
        return subprocess.call([sys.executable, str(server), "--host", args.host, "--port", str(args.port)])
    if args.cmd == "init-demo":
        workspace = pathlib.Path(args.workspace).resolve()
        result = init_project(str(workspace), "web")
        (workspace / "hello.py").write_text("print('hello from NOVA polyglot capsule')\n", encoding="utf-8")
        result["files"].append("hello.py")
        emit(result)
        return 0
    parser.print_help()
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
