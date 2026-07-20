# Multi-Repo Feeder Spine

Status: internal integration lane  
Root repository: `ItsNotAILABS/NOVA-private-root`  
Feeder model: multiple repositories publish sanitized bridge manifests, import maps, receipts, and release notes into the root system.

## Purpose

The root repo is the main operating system. Feeder repos remain independent product or subsystem repos, but each feeder must describe what it contributes, what is safe to import, what must stay private, and which NOVA / CAIN / ORO gates must approve the feed.

This prevents random copying between repositories. Every feed into the root has a contract.

## Root responsibilities

- Keep the canonical integration registry.
- Store bridge manifests for approved feeders.
- Track public/private boundaries.
- Route imported capabilities through NOVA, CAIN, and ORO.
- Require receipts for any imported runtime, token, governance, mobile, browser, or cyber-adjacent subsystem.
- Keep public-safe release artifacts separate from private internal protocols.

## Feeder responsibilities

Each feeder repo should publish a small package:

```text
bridge/feeder-manifest.json
bridge/README.md
bridge/ROOT_FEED_RECEIPT.md
```

The feeder manifest describes product purpose, importable artifacts, denied artifacts, security posture, public release posture, and root destination paths.

## Gate routing

```text
NOVA -> runtime import, orchestration, workspace connection, release proof
CAIN -> adversarial review, cyber boundary, unsafe claim rejection
ORO  -> user lanes, resource lanes, demo/public packaging, market handoff
```

## Initial feeders

```text
ItsNotAILABS/SNS---TOKEN -> SNS/token/governance feed candidate
FreddyCreates/potential-succotash -> public browser-intelligence feed candidate
```

`FreddyCreates/potential-succotash` is currently inspectable but not writable through the GitHub App integration. Its public-safe package is staged under `public-release/potential-succotash/` until write access is granted.

## Integration rule

A feeder is not merged into root just because it exists. It becomes part of root only after:

1. feeder manifest exists,
2. root import map exists,
3. public/private boundary is explicit,
4. unsafe claims are removed,
5. receipts identify what changed,
6. NOVA / CAIN / ORO route decision is documented.
