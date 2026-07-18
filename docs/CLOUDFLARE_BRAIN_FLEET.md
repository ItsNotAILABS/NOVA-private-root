# NOVA Cloudflare Brain Fleet

## Purpose

The Cloudflare Brain Fleet is the edge-scale control pattern for NOVA. It turns each repo or product surface into a set of small specialized AI workers that can run close to users, dashboards, GitHub webhooks, and browser surfaces while remaining coordinated by one governed control plane.

The goal is not one giant server. The goal is a fleet:

- CI health brains;
- release validation brains;
- repo monitoring brains;
- documentation/research brains;
- benchmark/proof brains;
- browser mesh brains;
- memory recall brains;
- receipt emitter brains.

## Architecture

```text
GitHub repos / browser surfaces / dashboards
        |
        v
Cloudflare Worker brain instances at edge
        |
        v
Durable Object coordinator
        |
        v
Task queue + leases + receipts + capability gates
        |
        v
NOVA main release registry and operator-approved PR flow
```

## Production boundary

Cloudflare Workers are the distributed agent plane. They are not the unrestricted authority plane.

Allowed:

- observe repo state;
- enqueue and claim tasks;
- run bounded validation and summarization;
- emit receipts;
- report CI health;
- propose fixes;
- coordinate browser-local mesh work.

Not allowed without an explicit operator gate:

- direct merge;
- secret access;
- live deployment;
- financial execution;
- custody actions;
- destructive repository mutation.

## Why this matters for NOVA

NOVA now has a main model-family production harness and multiple feeder repos. A Cloudflare brain fleet gives those repos a shared operating fabric. Each repo can publish validated status and receipts back into the main NOVA registry without forcing every task through one central machine.

## Maturity path

1. Worker + Durable Object coordinator.
2. Per-repo release harness validators.
3. GitHub webhook ingestion.
4. Task leases and stale work recovery.
5. Receipt federation into `docs/releases/model-family/v1.0.0/ECOSYSTEM_FEEDER_REGISTRY.md`.
6. Browser mesh bridge for local context and WebGPU inference.
7. Operator dashboard for swarm health, pending fixes, and promotion gates.

## Truth statement

This is an operator-controlled edge swarm architecture. It can scale to many small specialized brains, but repository writes, releases, deployment, and regulated actions stay behind explicit approval, CI, and receipts.
