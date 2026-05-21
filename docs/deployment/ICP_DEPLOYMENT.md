# NOVA ICP Deployment — How To Actually Ship

**BUILD №68 — SOVEREIGN DEPLOYMENT GUIDE**

---

## The 3-Minute Version

```bash
# 1. Install dfx (one time)
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"

# 2. Deploy locally (proves everything works)
./scripts/nova-deploy-local

# 3. Deploy to IC mainnet (live on the internet)
./scripts/nova-deploy --dry-run  # preview commands first
./scripts/nova-deploy             # actually deploy
```

---

## How ICP Deployment Actually Works

When you run `dfx deploy`, here's what happens:

```
Your Motoko code (.mo files)
    ↓ moc compiler
WASM binary (.wasm)
    ↓ dfx deploy
Installed on ICP as a canister (gets a unique ID like "ryjl3-tyaaa-aaaaa-aaaba-cai")
    ↓ accessible at
https://<canister-id>.icp0.io  (mainnet)
http://<canister-id>.localhost:8000  (local)
```

For the frontend:
```
Your React/CPL-F code
    ↓ npm run build (Vite)
Static files in dist/ (HTML, JS, CSS)
    ↓ dfx deploy frontend
Served from an asset canister on ICP
    ↓ accessible at
https://<frontend-canister-id>.icp0.io  (your live website!)
```

The frontend calls your backend canisters using `@dfinity/agent`. That's what the files in `src/frontend/src/canister/` do.

---

## Local Development Cycle

### Prerequisites
- `dfx` installed
- Node.js ≥ 18
- `cd src/frontend && npm install` (one time)

### Full local deploy
```bash
./scripts/nova-deploy-local
```

This does:
1. Starts local dfx replica (if not running)
2. Deploys core backend canisters (swarm_brain, nova_builder, parallax, etc.)
3. Auto-generates `.env` with local canister IDs
4. Builds frontend with Vite
5. Deploys frontend as asset canister
6. Prints the URL to open

### Just the frontend (after backend is deployed)
```bash
./scripts/nova-deploy-local --frontend
```

### Check what's deployed
```bash
./scripts/nova-deploy-local --status
```

---

## Mainnet Deployment

### First time setup
```bash
# Create an identity (one time)
dfx identity new nova-owner
dfx identity use nova-owner

# Get your principal
dfx identity get-principal

# You need cycles to deploy. Options:
# A) Free cycles from faucet (limited): https://faucet.dfinity.org
# B) Convert ICP to cycles: dfx cycles convert --amount 1 --network ic
# C) Use cycles wallet
```

### Deploy to mainnet
```bash
# Preview what will happen
./scripts/nova-deploy --dry-run

# Actually deploy agi_main (the heartbeat canister)
./scripts/nova-deploy

# Deploy individual canisters manually
dfx deploy --network ic nova_builder
dfx deploy --network ic parallax

# Build frontend for mainnet and deploy
cp src/frontend/.env.ic-mainnet.example src/frontend/.env
# Fill in canister IDs from canister_ids.json
cd src/frontend && npm run build && cd ../..
dfx deploy --network ic frontend
```

After mainnet deploy, `dfx` writes IDs to `canister_ids.json`:
```json
{
  "nova_builder": { "ic": "xxxxx-xxxxx-xxxxx-xxxxx-cai" },
  "frontend": { "ic": "yyyyy-yyyyy-yyyyy-yyyyy-cai" }
}
```

Your app is now live at: `https://<frontend-id>.icp0.io`

---

## Environment Variables

The frontend reads canister IDs from Vite env vars at build time:

| Variable | Local | Mainnet |
|----------|-------|---------|
| `VITE_IC_HOST` | `http://127.0.0.1:8000` | `https://icp0.io` |
| `VITE_SWARM_BRAIN_CANISTER_ID` | auto from dfx | from canister_ids.json |
| `VITE_NOVA_BUILDER_CANISTER_ID` | auto from dfx | from canister_ids.json |
| `VITE_PARALLAX_CANISTER_ID` | auto from dfx | from canister_ids.json |

See `src/frontend/.env.example` for the full list.

---

## What Other ICP Platforms Do (and NOVA now does too)

| Platform | Backend | Frontend | How they serve |
|----------|---------|----------|---------------|
| OpenChat | Rust canisters | Svelte → asset canister | `oc.app` (custom domain → asset canister) |
| DSCVR | Rust canisters | React → asset canister | `dscvr.one` |
| **NOVA** | **Motoko canisters** | **React/CPL-F → asset canister** | `<id>.icp0.io` or custom domain |

The architecture is identical:
1. Backend canister has public functions (query + update)
2. Frontend calls those functions using `@dfinity/agent`
3. Asset canister serves the website
4. No servers. No ports. No Node.js processes needed.

---

## Canister Architecture

```
                    ┌─────────────────────┐
                    │   FRONTEND          │
                    │   Asset canister    │
                    │   (serves React)    │
                    └────────┬────────────┘
                             │ @dfinity/agent calls
              ┌──────────────┼──────────────┐
              │              │              │
    ┌─────────▼──┐  ┌───────▼───┐  ┌──────▼──────┐
    │ swarm_brain │  │nova_builder│  │  parallax   │
    │ (organism)  │  │ (deploy)   │  │(settlement) │
    └─────────────┘  └────────────┘  └─────────────┘
              │
    ┌─────────▼───────────────────────────────┐
    │  40+ more Motoko canisters              │
    │  (agi_main, phantom_transfer, etc.)     │
    └─────────────────────────────────────────┘
```

---

## Troubleshooting

### "Cannot find canister ID"
Run `dfx deploy` first. Canister IDs are assigned on first deploy.

### "Insufficient cycles"
Get cycles: `dfx cycles convert --amount 1 --network ic` (costs 1 ICP)

### Frontend shows blank page on mainnet
Check that `.env` has mainnet canister IDs and `VITE_IC_HOST=https://icp0.io`, then rebuild: `npm run build`.

### "Replica not running"
```bash
dfx start --background --clean
```

### Build errors in Motoko
```bash
./scripts/nova check  # type-check without full deploy
```

---

## Files That Matter

| File | Purpose |
|------|---------|
| `dfx.json` | Canister registry (what gets deployed) |
| `canister_ids.json` | Mainnet canister IDs (created by dfx) |
| `src/frontend/.env` | Env vars for frontend build |
| `src/frontend/src/canister/*.ts` | Frontend ↔ canister connections |
| `scripts/nova-deploy-local` | Local full-cycle deploy |
| `scripts/nova-deploy` | Mainnet deploy (agi_main + economy) |
| `scripts/nova` | Type-check / build Motoko (no deploy) |
