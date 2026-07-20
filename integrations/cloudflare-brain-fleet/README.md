# NOVA Cloudflare Brain Fleet

This package turns the Cloudflare edge pattern into a governed NOVA swarm lane: many small Workers act as repo, release, CI, memory, and browser-mesh brains while a Durable Object coordinates identity, task leasing, receipts, and operator boundaries.

## What it is

- A Cloudflare Worker entrypoint for the global edge.
- A Durable Object coordinator for fleet state.
- Brain registration and heartbeat endpoints.
- Priority task queue with leases and stale-lease recovery.
- Receipt emission for brain registration, task enqueue, task claim, and task completion.
- Explicit capability allow-list.

## What it is not

- Not an unrestricted auto-committer.
- Not a hidden secret runner.
- Not a replacement for GitHub branch, PR, review, CI, and operator approvals.
- Not live deployment authority without explicit promotion.

## Routes

```text
GET  /health
POST /brains/register
POST /brains/:id/heartbeat
GET  /brains
POST /tasks
POST /tasks/claim
POST /tasks/:id/complete
GET  /tasks
GET  /receipts
```

## Capability lanes

```text
repo.monitor
repo.ci
repo.repair-plan
release.validate
docs.summarize
edge.inference
browser.mesh
memory.recall
receipt.emit
```

## Deploy path

```bash
cd integrations/cloudflare-brain-fleet
cp wrangler.toml.example wrangler.toml
wrangler secret put NOVA_BRAIN_FLEET_TOKEN
wrangler deploy
```

## Operator architecture

Use this as the edge coordination layer around NOVA, not as the whole brain. The edge fleet watches, claims, summarizes, validates, and emits receipts. Privileged repository write actions still go through governed GitHub PRs, CI, and explicit merge gates.

## Scale posture

The target pattern is many small specialized brains, not one monolith. A repo can have CI brains, release brains, doc brains, memory brains, browser-context brains, and benchmark brains all claiming work from the same coordinator. Multiple repos can share the same schema and publish receipts back into the main NOVA model-family registry.

## Constitutional identity and custody

Production startup fails closed unless `NOVA_BRAIN_FLEET_TOKEN` is configured. The only tokenless mode is explicit `local-dev` on localhost. Registration returns a one-time brain credential; only its SHA-256 digest is stored. Heartbeat, claim, and completion require that credential, and completion is rejected unless the brain owns an unexpired lease. Fleet receipts carry `previousHash` and advance a persistent Durable Object chain head.
