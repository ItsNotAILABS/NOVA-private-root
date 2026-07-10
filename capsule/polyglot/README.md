# NOVA Polyglot Coding Capsule

The NOVA polyglot coding capsule turns a coding session into a local governed runtime that can compile, run, preview, receipt, scale into isolated sessions, generate project templates, create hash manifests, and hand off artifacts to GitHub/local deploy lanes.

It is designed for the live coding playground described in the NOVA stack:

- Python coding sessions
- MATLAB / Octave-compatible sessions
- Java
- C / C++
- JavaScript / TypeScript
- HTML / CSS frontend previews
- Rust / Go lanes
- shell lanes under governed boundaries
- future WASM capsule packaging
- scaled session/project workspaces
- local preview dashboard
- deploy packet handoff

## What comes online during a session

When the coding capsule session starts, the local session server comes online:

```bash
python3 capsule/polyglot/session_server.py --host 127.0.0.1 --port 8787
```

Default routes:

| Route | Purpose |
|---|---|
| `GET /health` | confirms live scaled session server |
| `GET /languages` | supported language registry |
| `GET /sessions` | active session records |
| `POST /sessions` | create a new isolated session workspace |
| `POST /init-project` | initialize web/python/cpp/java project templates |
| `POST /run` | compile/run a workspace file |
| `GET /manifest?workspace=...` | generate hash manifest |
| `GET /preview/<file>` | frontend preview route |
| `GET /deploy/packet?workspace=...` | deploy/GitHub handoff packet |

## CLI

```bash
python3 capsule/polyglot/capsule_cli.py languages
python3 capsule/polyglot/capsule_cli.py create-session --project client-playground
python3 capsule/polyglot/capsule_cli.py sessions
python3 capsule/polyglot/capsule_cli.py init-project --kind web
python3 capsule/polyglot/capsule_cli.py init-project --kind cpp --workspace capsule/polyglot/workspace/cpp-demo
python3 capsule/polyglot/capsule_cli.py run hello.py
python3 capsule/polyglot/capsule_cli.py run index.html
python3 capsule/polyglot/capsule_cli.py manifest
python3 capsule/polyglot/capsule_cli.py deploy-packet --target github-handoff
python3 capsule/polyglot/capsule_cli.py server --host 127.0.0.1 --port 8787
```

## Frontend preview

Create or place an HTML file in the capsule workspace, then run:

```bash
python3 capsule/polyglot/capsule_cli.py run index.html
```

The server emits a preview receipt with:

```text
/preview/index.html
```

A polished local dashboard also exists at:

```text
capsule/polyglot/dashboard/index.html
```

## Scaled sessions

Create isolated sessions:

```bash
python3 capsule/polyglot/capsule_cli.py create-session --project chemineer-playground
python3 capsule/polyglot/capsule_cli.py create-session --project jeremi-platform
python3 capsule/polyglot/capsule_cli.py create-session --project self-runtime
```

Each session gets:

- session id
- project slug
- workspace path
- preview URL
- status
- timestamps

## Project templates

Supported starter templates:

| Kind | Files |
|---|---|
| `web` | `index.html`, `styles.css`, `app.js`, `README.md` |
| `python` | `hello.py`, `README.md` |
| `cpp` | `main.cpp`, `README.md` |
| `java` | `Main.java`, `README.md` |

## Hash manifests and deploy packets

Generate proof artifacts:

```bash
python3 capsule/polyglot/capsule_cli.py manifest
python3 capsule/polyglot/capsule_cli.py deploy-packet --target github-handoff
```

Outputs:

```text
.nova/hash-manifest.json
.nova/deploy-packet.json
```

These are the bridge to GitHub commits, local deploys, WASM packaging, and release receipts.

## WASM capsule strategy

The registry separates host-runner support from WASM support. Some languages compile directly to WASM through existing targets; others use host bridges or runtime capsules.

| Lane | Strategy |
|---|---|
| C/C++ | clang / Emscripten / WASI |
| Rust | wasm32-wasi or wasm-bindgen |
| Go | TinyGo or Go wasm |
| Python | Pyodide / MicroPython capsule |
| Java | TeaVM or JVM host bridge |
| MATLAB | Octave-compatible host bridge first |
| HTML/CSS/JS | browser-native preview |

## Receipts

Every run writes a JSON receipt under:

```text
capsule/polyglot/workspace/.nova/receipts/
```

Receipts record:

- language
- action
- output path
- preview URL
- stdout/stderr
- timing
- failure boundary

## Boundary

This is a local runtime. It binds to `127.0.0.1` by default, denies unbounded public server exposure, and records compile/run/preview/deploy handoff activity through receipts. External deployment is a later bridge, not silently assumed.
