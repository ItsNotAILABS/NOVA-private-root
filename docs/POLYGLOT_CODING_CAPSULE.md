# NOVA Polyglot Coding Capsule

The polyglot coding capsule is the NOVA sandbox layer for live coding sessions. It makes the coding environment behave like a local virtual server space: when a session is live, the server can turn on, code can run, frontend previews can render, deploy packets can be created, and GitHub/local deploy handoffs can be generated through receipts.

## Goals

- Support Python, MATLAB/Octave, Java, C, C++, JavaScript, TypeScript, HTML/CSS, Rust, Go, shell, and future language lanes through an extensible registry.
- Turn coding sessions into governed local runtime spaces.
- Support frontend previews for full websites.
- Scale into multiple isolated session workspaces.
- Generate project templates for common lanes.
- Emit receipts for every compile/run/preview/deploy handoff.
- Generate hash manifests and deploy packets.
- Prepare code for WASM capsule packaging.
- Keep daemon and background processes explicit and session-scoped.
- Support GitHub handoff without overcomplicating the first implementation.

## Runtime Surfaces

| Surface | Path | Purpose |
|---|---|---|
| Language registry | `capsule/polyglot/languages.json` | Defines supported languages and compile/run strategies |
| Session server | `capsule/polyglot/session_server.py` | Local HTTP server for live scaled coding sessions |
| Scale layer | `capsule/polyglot/scaler.py` | Sessions, templates, manifests, deploy packets |
| CLI | `capsule/polyglot/capsule_cli.py` | Operator commands for language list, sessions, run, server, manifests, deploy packets |
| Dashboard | `capsule/polyglot/dashboard/index.html` | Previewable operator surface |
| Daemon manifest | `capsule/polyglot/daemon_manifest.json` | Declares session daemons and operator boundary |
| WASM plan | `capsule/polyglot/wasm_capsule.plan.json` | Phased WASM packaging strategy |
| Receipts | `capsule/polyglot/workspace/.nova/receipts` | Run, compile, preview, and deploy handoff proof |
| Hash manifest | `.nova/hash-manifest.json` | File hash proof for capsule artifacts |
| Deploy packet | `.nova/deploy-packet.json` | Local/GitHub handoff packet |

## Start Session Server

```bash
python3 capsule/polyglot/session_server.py --host 127.0.0.1 --port 8787
```

Routes:

```text
GET  /health
GET  /languages
GET  /sessions
POST /sessions
POST /init-project
POST /run
GET  /manifest?workspace=...
GET  /preview/<file>
GET  /deploy/packet?workspace=...
```

## Local Playground Flow

```bash
python3 capsule/polyglot/capsule_cli.py create-session --project chemineer
python3 capsule/polyglot/capsule_cli.py init-project --kind web
python3 capsule/polyglot/capsule_cli.py run index.html
python3 capsule/polyglot/capsule_cli.py manifest
python3 capsule/polyglot/capsule_cli.py deploy-packet --target github-handoff
python3 capsule/polyglot/capsule_cli.py server --host 127.0.0.1 --port 8787
```

Then preview:

```text
http://127.0.0.1:8787/preview/index.html
```

## Scaling model

The scaled capsule model has four operating lanes:

1. **Session lane** — isolated workspace per project/person/platform.
2. **Runner lane** — compile/run with timeout, receipts, and denial records.
3. **Preview lane** — frontend artifacts served locally.
4. **Deploy handoff lane** — hash manifest and deployment packet for GitHub/local runtime bridges.

## Deployment Handoff

This implementation does not silently deploy to public infrastructure. It creates receipts, hash manifests, and deploy packets so the next lane can commit artifacts to GitHub or hand them to a local deploy/runtime bridge.

```text
GET /deploy/packet?workspace=/path/to/workspace&target=github-handoff
```

## Operator Boundary

- default host: `127.0.0.1`
- public network binding denied by default
- every run writes a receipt
- hash manifests are generated before deploy handoff
- missing compilers are reported as capability gaps
- workspace escape attempts are denied
- background daemons are declared in `daemon_manifest.json`

## Next Build Queue

1. Add WASI toolchain wrappers for C/C++/Rust.
2. Add local deploy bridge for static websites.
3. Add GitHub commit handoff from receipts.
4. Add browser preview UI tab wired to server JSON.
5. Add daemon lifecycle controller.
6. Add release receipt generator.
7. Add language wrappers for MATLAB host bridges and Java/TeaVM lanes.
8. Add persistent workspace registry by user/team/artifact lane.
