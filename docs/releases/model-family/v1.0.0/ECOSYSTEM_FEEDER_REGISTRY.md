# NOVA Ecosystem Feeder Registry

Status: `ACTIVE_EXPANSION_REGISTRY`

This registry tracks the ecosystem around the main NOVA model family. Each feeder repo should eventually contain schemas, model cards, release manifests, CI validators, proof receipts, and safe promotion boundaries.

| Repo | Role | Target harness | Current priority |
|---|---|---|---|
| `ItsNotAILABS/NOVA-private-root` | main model-family and platform root | model-family release CI | highest |
| `ItsNotAILABS/SNS---TOKEN` | PARALLAX token/governance feeder | governance/token release harness | highest |
| `ItsNotAILABS/PARALLAX-Exchange-Clearinghouse` | exchange/clearing feeder | market registry and clearing release harness | high |
| `ItsNotAILABS/PARRALAX-AIHFTFUND` | trading/wallet/research feeder | research-only strategy/wallet release harness | high |
| `ItsNotAILABS/MedinaMemorySystems` | memory infrastructure feeder | memory model and persistence release harness | high |
| `ItsNotAILABS/NEUROSWARMAI` | swarm intelligence feeder | swarm/orchestration release harness | high |
| `ItsNotAILABS/FABLEBREAKER` | proof-before-speed benchmark feeder | benchmark/evaluation release harness | high |
| `ItsNotAILABS/LOOM-Memoria-De-Intelligencia-` | memory/history feeder | loom memory release harness | medium |
| `ItsNotAILABS/AURO` | app/runtime feeder | AURO release harness | medium |
| `ItsNotAILABS/Auro14B` | model surface feeder | model-card and eval harness | medium |
| `ItsNotAILABS/PhoneAI` | mobile/voice feeder | phone/voice release harness | medium |
| `ItsNotAILABS/CAPSULA` | capsule packaging feeder | capsule release harness | medium |

## Standard feeder harness

Every feeder repo should converge on:

- `docs/release-harness/README.md`
- `docs/release-harness/model-cards/`
- `docs/release-harness/release-packages/v1.0.0/RELEASE.md`
- `docs/release-harness/release-packages/v1.0.0/release-manifest.json`
- `schemas/*.schema.json`
- `scripts` or `docs/release-harness/scripts` validator
- `.github/workflows/*release-harness*.yml`
- explicit non-claims and approval gates

## Promotion rule

Feeder repos feed the main NOVA system only after CI passes, release manifest validates, unsafe claims are absent, and operator/legal/security boundaries are explicit.
