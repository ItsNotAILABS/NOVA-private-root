# NOVA Polyglot Coding Capsule

The NOVA polyglot coding capsule turns a coding session into a local governed runtime that can compile, run, preview, receipt, and hand off artifacts to GitHub.

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

## What comes online during a session

When the coding capsule session starts, the local session server comes online:

```bash
python3 capsule/polyglot/session_server.py --host 127.0.0.1 --port 8787
```

Default routes:

| Route | Purpose |
|---|---|
| `GET /health` | confirms live session server |
| `GET /languages` | supported language registry |
| `POST /run` | compile/run a workspace file |
| `GET /preview/<file>` | frontend preview route |
| `GET /deploy/packet` | deploy/GitHub handoff packet |

## CLI

```bash
python3 capsule/polyglot/capsule_cli.py languages
python3 capsule/polyglot/capsule_cli.py init-demo
python3 capsule/polyglot/capsule_cli.py run hello.py
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

Receipts are the bridge to deployment and GitHub handoff. They record:

- language
- action
- output path
- preview URL
- stdout/stderr
- timing
- failure boundary

## Boundary

This is a local runtime. It binds to `127.0.0.1` by default, denies unbounded public server exposure, and records compile/run activity through receipts. External deployment is a later bridge, not silently assumed.
