# AURO One-Hour Deploy Template (Phone-Ready)

Classification: `BUILDER_CONFIDENTIAL`

Purpose:
- launch AURO Companion fast,
- expose it to your phone on the same network,
- and keep security defaults tight while you test.

This template is the deploy-now version: run script, scan URL, test voice/chat in under an hour.

---

## 1) Prerequisites

On your host machine:
- Node.js + npm installed
- Repo cloned
- same Wi-Fi/network for laptop and phone

Optional:
- `tmux` installed (recommended for persistent local sessions)

---

## 2) One-command bootstrap

From repo root:

```bash
bash scripts/auro_one_hour_mobile_bootstrap.sh
```

What it does:
1. installs frontend deps,
2. builds frontend,
3. starts AURO bridge on `0.0.0.0:8787` (dry-run exec by default),
4. starts frontend dev server on `0.0.0.0:5173`,
5. prints phone URLs and quick checks.

---

## 3) Phone URL and runtime

After bootstrap, open on your phone:

- `http://<YOUR_LAN_IP>:5173`

Then in app nav:
- open **Companion**
- run `/status`
- run `/voice on`

Bridge health check:
- `http://<YOUR_LAN_IP>:8787/health`

---

## 4) Security defaults (recommended for first test)

Defaults in script:
- `AURO_ALLOW_EXEC=0` (no host command execution)
- `AURO_BRIDGE_TOKEN` disabled by default for rapid local bring-up

Result:
- chat and voice are testable immediately,
- shell exec stays dry-run until you intentionally enable it.

To enable shell exec for trusted local testing only:

```bash
export AURO_ALLOW_EXEC=1
```

Then in Companion:
- `/shell on`
- `/run pwd`

---

## 5) Environment template

Copy:

```bash
cp src/frontend/.env.example src/frontend/.env.local
```

Set these fields for your LAN:
- `VITE_AURO_API_BASE=http://<YOUR_LAN_IP>:8787`
- `VITE_AURO_BRIDGE_TOKEN=<token from bootstrap output>`

The app auto-loads these env values in `main.tsx`.

Token note:
- if `VITE_AURO_BRIDGE_TOKEN` is empty, companion uses open local bridge mode
- to enforce auth, set both:
  - bridge env `AURO_BRIDGE_TOKEN`
  - frontend env `VITE_AURO_BRIDGE_TOKEN`

---

## 6) Rapid validation checklist (10 minutes)

1. UI loads on phone (`:5173`)
2. Companion opens
3. `/status` returns bridge URL/token mode
4. `/voice on` enables speech output
5. chat message returns `/chat` response
6. `/shell on` and `/run date` behaves as expected:
   - dry-run in secure default
   - executes only when `AURO_ALLOW_EXEC=1`

---

## 7) Upgrade path after quick test

After fast validation:
1. switch dev server to production build serving,
2. put bridge behind reverse proxy + TLS,
3. enforce token auth and origin restrictions,
4. add signed command protocol for privileged actions.

---

## 8) One-line operating rule

Launch fast with secure defaults, validate phone companion loop, then harden before broad external exposure.

