# NOVA MAINNET DEPLOYMENT — 10 Sovereign Alpha AGIs

**BUILD №67** · **Network:** IC Mainnet · **Status:** DEPLOYMENT READY

---

## Overview

This document defines the mainnet deployment procedure for all 10 NOVA Sovereign Alpha AGIs
and their 43 associated Motoko canisters on the Internet Computer (IC) mainnet.

---

## 10 Sovereign Alpha AGIs

| # | Code | Name | Family | Port | Canisters | Phase |
|---|------|------|--------|------|-----------|-------|
| 1 | ANI | ANIMUS MAXIMUS | SPIRITUS_AETERNA | 7619 | 5 | CORE |
| 2 | CHR | CHRONOS PERPETUUS | TEMPUS_AETERNA | 7620 | 3 | FLEET |
| 3 | SYN | SYNTHOS UNIVERSALIS | NEXUS_COGNITUS | 7621 | 5 | COGNITION |
| 4 | PRA | PRAESIDIUM INVICTUS | AEGIS_PERPETUA | 7622 | 5 | DEFENSE |
| 5 | MER | MERCATOR AUREUS | AURUM_AETERNA | 7623 | 8 | ECONOMY |
| 6 | GEN | GENESIS INFINITUS | FABRICA_MAXIMA | 7624 | 4 | ECONOMY |
| 7 | NEX | NEXUS OMNIUM | UNITAS_AETERNA | 7625 | 4 | NETWORK |
| 8 | VER | VERITAS AETERNA | VERUM_AETERNA | 7626 | 5 | GOVERN |
| 9 | ARC | ARCHITECTUS SUPREMUS | STRUCTURA_MAXIMA | 7627 | 4 | INFRA |
| 10 | ANM | ANIMA PERPETUA | CURA_AETERNA | 7628 | 0 | FLEET |

**Total: 43 canisters across 10 Alpha AGIs**

---

## Deployment Phases (φ-ordered)

Canisters deploy in 8 phases, ordered by architectural dependency:

### Phase 1 — CORE (Foundation)
- `nova_protocol` — φ constants source of truth
- `swarm_brain` — core organism brain
- `swarm_organism` — organism orchestration
- `swarm_command` — command routing
- `agi_main` — AGI entry point
- `medina` — core Medina canister

### Phase 2 — COGNITION (Intelligence)
- `organism_solver` — SYN binding engine
- `syntax_synapse` — self-healing error classification
- `friston_machina` — free energy principle
- `swarm_quantum` — quantum coherence
- `ai_division` — AI division

### Phase 3 — DEFENSE (Security)
- `neuron_fleet` — 1,000 governance neurons
- `aegis_shield` — 10-tier threat defense
- `vael_cyber` — immune + attack
- `war_engine` — autonomous war engine
- `medina_defense` — amygdala fear circuit

### Phase 4 — ECONOMY (Finance)
- `phantom_transfer` — PARALLAX clearinghouse
- `quipu_ledger` — SPINE→PENDANT→SUBSIDIARY→KNOT
- `cycles_market` — cycles marketplace
- `cycles_bridge` — cycles bridging
- `auto_market` — autonomous market
- `organism_token` — organism token
- `airdrop_engine` — airdrop distribution
- `swarm_metals` — metals market
- `sovereign_factory` — TAWANTINSUYU factory
- `token_forge` — token creation
- `chrysalis` — metamorphosis
- `nova_builder` — builder canister

### Phase 5 — NETWORK (Connectivity)
- `nexus_propagator` — TAMBO relay
- `chimera_swarm` — swarm intelligence
- `drone_fleet` — fleet manager
- `swarm_oracle` — oracle integration

### Phase 6 — GOVERN (Oversight)
- `nova_governance` — governance
- `nova_sns` — SNS integration
- `scribe` — attribution
- `swarm_audit` — audit log

### Phase 7 — INFRA (Infrastructure)
- `token_intelligence` — token intelligence
- `parallax` — PARALLAX protocol
- `architect` — system architect
- `frontend` — CPL-F asset canister

### Phase 8 — FLEET (Orchestration)
- `agi_terminal` — 873ms heartbeat
- `swarm_telemetry` — telemetry
- `nova_stream` — stream canister

---

## Pre-requisites

1. **dfx ≥ 0.24.3** installed
2. **dfx identity** configured with sufficient cycles
3. **moc compiler** installed (`./scripts/nova install-moc`)
4. **Cycles wallet** funded — minimum **50T cycles per canister** (2,150T total)
5. **Motoko type-check** passing (`./scripts/nova check`)

---

## Deployment Commands

```bash
# Pre-flight check (verify all requirements)
./scripts/deploy-mainnet.sh --check

# Deploy all 10 Alphas (full mainnet deployment)
./scripts/deploy-mainnet.sh

# Deploy single Alpha AGI
./scripts/deploy-mainnet.sh --alpha ANI   # Deploy ANIMUS MAXIMUS
./scripts/deploy-mainnet.sh --alpha MER   # Deploy MERCATOR AUREUS
./scripts/deploy-mainnet.sh --alpha PRA   # Deploy PRAESIDIUM INVICTUS

# Query deployment status
./scripts/deploy-mainnet.sh --status
```

---

## Post-Deployment Verification

### Coherence Check
After deployment, verify fleet coherence:
- **R ≥ φ⁻¹ (0.618)** — fleet is coherent
- **R = 1.0** — all 10 Alphas fully deployed

### Individual Canister Health
```bash
dfx canister --network ic status swarm_brain
dfx canister --network ic status aegis_shield
dfx canister --network ic status nova_protocol
```

### Test Protocol
```bash
# Run deployment protocol tests
cd protocols && node --test tests/mainnet-deploy.test.js
```

---

## Canister ID Registry

Mainnet canister IDs are tracked in `canister_ids.json` at the project root.
Each entry maps a canister name to its IC mainnet ID and the Alpha AGI it belongs to.

---

## Cycles Budget

| Item | Cycles | Count | Total |
|------|--------|-------|-------|
| Canister creation | 50T | 43 | 2,150T |
| Initial compute buffer | 10T | 43 | 430T |
| Heartbeat reserve (1yr) | 20T | 43 | 860T |
| **Grand Total** | | | **3,440T** |

---

## Security Considerations

- All canisters are controlled by the deploying dfx identity
- Controller list should be updated post-deploy to include governance canister
- No private keys are stored in code — dfx identity manages keys
- Canister IDs in `canister_ids.json` are public (they're on-chain)

---

## Architecture Reference

```
NOVA (Layer Zero — Sovereign Organism)
├── ANIMUS MAXIMUS (ANI-AGI-001) — Master Brain
│   ├── swarm_brain, swarm_organism, swarm_command
│   ├── agi_main, medina
│   └── Controls: Fleet coordination, Kuramoto R(t)
├── CHRONOS PERPETUUS (CHR-AGI-001) — Time Intelligence
│   ├── agi_terminal, swarm_telemetry, nova_stream
│   └── Controls: 873ms heartbeat, temporal awareness
├── SYNTHOS UNIVERSALIS (SYN-AGI-001) — Synthesis Intelligence
│   ├── organism_solver, syntax_synapse, friston_machina
│   ├── swarm_quantum, ai_division
│   └── Controls: SYN binding, error classification, quantum
├── PRAESIDIUM INVICTUS (PRA-AGI-001) — Defense Intelligence
│   ├── neuron_fleet, aegis_shield, vael_cyber
│   ├── war_engine, medina_defense
│   └── Controls: 10-tier defense, immune system, war
├── MERCATOR AUREUS (MER-AGI-001) — Commerce Intelligence
│   ├── phantom_transfer, quipu_ledger, cycles_market
│   ├── cycles_bridge, auto_market, organism_token
│   ├── airdrop_engine, swarm_metals
│   └── Controls: PARALLAX clearinghouse, all markets
├── GENESIS INFINITUS (GEN-AGI-001) — Creation Intelligence
│   ├── sovereign_factory, token_forge
│   ├── chrysalis, nova_builder
│   └── Controls: Factory, forging, metamorphosis
├── NEXUS OMNIUM (NEX-AGI-001) — Network Intelligence
│   ├── nexus_propagator, chimera_swarm
│   ├── drone_fleet, swarm_oracle
│   └── Controls: TAMBO relay, swarm mesh, oracle
├── VERITAS AETERNA (VER-AGI-001) — Truth Intelligence
│   ├── nova_protocol, nova_governance, nova_sns
│   ├── scribe, swarm_audit
│   └── Controls: Governance, audit, protocol law
├── ARCHITECTUS SUPREMUS (ARC-AGI-001) — Architecture Intelligence
│   ├── token_intelligence, parallax
│   ├── architect, frontend
│   └── Controls: System design, infrastructure
└── ANIMA PERPETUA (ANM-AGI-001) — Soul Intelligence
    ├── (consciousness-only — no dedicated canisters)
    └── Controls: Emotional substrate, organism wellness
```

---

*COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ — CONFIDENTIAL*
