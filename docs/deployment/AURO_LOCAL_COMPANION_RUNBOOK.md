# AURO Local Companion Runbook (Chat + Voice + Computer Bridge)

This runbook gets a local AURO companion online quickly:

- chat in UI,
- browser voice input/output,
- optional local computer command bridge,
- optional DFX bootstrap for canister path.

For a one-command fast launch (phone-ready), use:
- `docs/AURO_ONE_HOUR_DEPLOY_TEMPLATE.md`
- `scripts/auro_one_hour_mobile_bootstrap.sh`

## 1) Frontend setup

From repo root:

```bash
cd src/frontend
npm install
cp .env.example .env.local
# set VITE_AURO_API_BASE to your bridge host, for example:
# VITE_AURO_API_BASE=http://192.168.1.25:8787
npm run dev
```

Open the URL shown by Vite.

## 2) Companion mode in UI

In top navigation, open **Companion**.

Capabilities:

- text chat,
- browser speech-to-text (if supported),
- browser text-to-speech,
- optional execution of local commands through bridge.

## 3) Start local command bridge (optional)

From repo root:

```bash
node scripts/auro-companion-bridge.mjs
```

By default bridge listens on:

- `http://127.0.0.1:8787/health`
- `http://127.0.0.1:8787/chat` (POST `{ "message": "..." }`)
- `http://127.0.0.1:8787/command` (POST `{ "command": "..." }`)

### Security defaults

- command execution is **off** by default (`AURO_ALLOW_EXEC=0`),
- optional token auth can be enforced with `AURO_BRIDGE_TOKEN`.

Configure via env:

- `AURO_BRIDGE_PORT` (default `8787`)
- `AURO_BRIDGE_HOST` (default `127.0.0.1`)
- `AURO_ALLOW_EXEC` (`1` to execute commands, default dry-run)
- `AURO_BRIDGE_TOKEN` (optional shared token; pass in `x-auro-token`)

For phone testing on local Wi-Fi, bind host to all interfaces:

```bash
AURO_BRIDGE_HOST=0.0.0.0 AURO_BRIDGE_PORT=8787 node scripts/auro-companion-bridge.mjs
```

## 4) Enable bridge in browser app

In the Companion UI:

- `/status` to verify runtime
- `/voice on` to enable speech output + mic controls
- `/shell on` to allow command routing
- `/run <command>` to run command requests

Safe examples:

- `date`
- `pwd`
- `ls`
- `git status`

## 5) Install DFX locally (optional)

From repo root:

```bash
bash scripts/install_dfx_local.sh
```

This script installs DFX if missing and confirms version.

## 6) Bootstrap local canister stack (optional)

From repo root:

```bash
bash scripts/bootstrap_local_stack.sh
```

This script:

1. verifies DFX,
2. installs frontend dependencies,
3. builds frontend assets,
4. starts/uses local replica,
5. deploys `swarm_brain`, `swarm_organism`, `frontend`.

## Notes

- Browser voice features depend on Web Speech API support.
- Computer control is intentionally command-gated and local-only.
- For production/remote operation, use stronger authentication and a signed command protocol.

