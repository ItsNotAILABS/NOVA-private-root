# NOVA Builder — Cloudflare-Native Web3 Build Platform

NOVA Builder is being migrated as a Cloudflare-native product rather than copied from Replit or forced into one runtime.

## Product purpose

NOVA Builder gives users one workspace to create, compile, package, deploy, inspect, and operate Web3 applications across Cloudflare and external chains. The platform owns build sessions, artifact provenance, deployment receipts, runtime selection, and the operator experience.

## Runtime architecture

```text
React product
  -> Workers Static Assets
  -> Worker gateway (/api and /engine)
     -> D1: projects, builds, deployments, audit events
     -> KV: workspace configuration and feature flags
     -> R2: source bundles, generated code, manifests, build artifacts
     -> Durable Objects: one serialized coordinator per build
     -> Queues: durable build dispatch and retry
     -> Cron: stalled-build recovery and synthetic-user runs
     -> AI Gateway / Workers AI: model routing and observability
     -> Hyperdrive: existing Postgres-backed product lanes
     -> extended runtime: filesystem, subprocess, dfx, cargo, polyglot jobs
     -> ICP canisters: sovereign deploy and on-chain proof lane
```

## Deliberate separation

Worker-native jobs stay inside Workers. Python HTTP workloads may use Python Workers. Filesystem-heavy, subprocess-heavy, Docker, `dfx`, Cargo, and long polyglot THESIS jobs use the contained extended-runtime adapter. The gateway remains the control plane and records every transition.

## Implemented backend slice

- Worker gateway for `/api` and `/engine`
- D1 schema for projects, builds, deployments, and audit events
- build submission API
- automatic runtime-lane selection
- Queue-backed durable dispatch
- Durable Object build coordinator
- R2 artifact manifests
- stalled-build recovery through Cron
- Static Assets binding for the React product
- explicit extended-runtime and ICP gateway configuration

## API

```text
GET  /api/health
GET  /api/projects
POST /api/projects
POST /api/projects/:projectId/builds
GET  /api/builds/:buildId
```

Example project:

```json
{
  "name": "Treasury Console",
  "slug": "treasury-console",
  "chainTarget": "evm",
  "framework": "react-worker"
}
```

Example build:

```json
{
  "name": "Treasury Console",
  "chainTarget": "evm",
  "framework": "react-worker",
  "runtimeLane": "worker",
  "sourceRevision": "git:abc123",
  "commands": ["npm run build"]
}
```

## Local setup

```bash
cd apps/nova-builder-cloudflare
npm install
npx wrangler d1 create nova-builder
npx wrangler kv namespace create CONFIG
npx wrangler r2 bucket create nova-builder-artifacts
npx wrangler queues create nova-builder-builds
npx wrangler d1 execute nova-builder --local --file schema.sql
npm run dev
```

Replace placeholder binding identifiers in `wrangler.toml` before remote deployment.

## Current boundary

This branch establishes the backend control plane. It does not claim that remote Cloudflare resources have been provisioned, that a production URL is live, or that extended-runtime and chain deployment credentials are configured. Those are explicit deployment gates.
