# NOVA Polyglot Coding Capsule

The polyglot coding capsule is the NOVA sandbox layer for live coding sessions. It is designed to make the coding environment behave like a local virtual server space: when a session is live, the server can turn on, code can run, frontend previews can render, and deploy packets can be handed off to GitHub.

## Goals

- Support Python, MATLAB/Octave, Java, C, C++, JavaScript, TypeScript, HTML/CSS, Rust, Go, shell, and future language lanes through an extensible registry.
- Turn coding sessions into governed local runtime spaces.
- Support frontend previews for full websites.
- Emit receipts for every compile/run/preview/deploy handoff.
- Prepare code for WASM capsule packaging.
- Keep daemon and background processes explicit and session-scoped.
- Support GitHub handoff without overcomplicating the first implementation.

## Runtime Surfaces

| Surface | Path | Purpose |
|---|---|---|
| Language registry | `capsule/polyglot/languages.json` | Defines supported languages and compile/run strategies |
| Session server | `capsule/polyglot/session_server.py` | Local HTTP server for live coding session |
| CLI | `capsule/polyglot/capsule_cli.py` | Operator commands for language list, run, server, demo init |
| Daemon manifest | `capsule/polyglot/daemon_manifest.json` | Declares session daemons and operator boundary |
| WASM plan | `capsule/polyglot/wasm_capsule.plan.json` | Phased WASM packaging strategy |
| Receipts | `capsule/polyglot/workspace/.nova/receipts` | Run, compile, preview, and deploy handoff proof |

## Start Session Server

```bash
python3 capsule/polyglot/session_server.py --host 127.0.0.1 --port 8787
```

Routes:

```text
GET  /health
GET  /languages
POST /run
GET  /preview/<file>
GET  /deploy/packet
```

## Local Playground Flow

```bash
python3 capsule/polyglot/capsule_cli.py init-demo
python3 capsule/polyglot/capsule_cli.py run hello.py
python3 capsule/polyglot/capsule_cli.py run index.html
python3 capsule/polyglot/capsule_cli.py server --host 127.0.0.1 --port 8787
```

Then preview:

```text
http://127.0.0.1:8787/preview/index.html
```

## Deployment Handoff

The first implementation does not silently deploy to public infrastructure. It creates receipts and deploy packets so the next lane can commit artifacts to GitHub or hand them to a local deploy/runtime bridge.

```text
GET /deploy/packet
```

## Operator Boundary

- default host: `127.0.0.1`
- public network binding denied by default
- every run writes a receipt
- missing compilers are reported as capability gaps
- workspace escape attempts are denied
- background daemons are declared in `daemon_manifest.json`

## Next Build Queue

1. Add WASI toolchain wrappers for C/C++/Rust.
2. Add local deploy bridge for static websites.
3. Add GitHub commit handoff from receipts.
4. Add browser preview UI tab.
5. Add daemon lifecycle controller.
6. Add hash manifest and release receipt generator.
7. Add language wrappers for MATLAB host bridges and Java/TeaVM lanes.
