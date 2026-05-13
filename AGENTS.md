# AGENTS.md

This document is the operating guide for automated coding agents and contributors working in this repository.
Read it in full before touching any file. The language charter in §1 is mandatory — violations will be corrected.

## Scope

- Applies to the entire repository unless a deeper-level `AGENTS.md` is added in a subdirectory.
- Follow these instructions together with any task-specific user request.

---

## §1 — NOVA Language & Architecture Charter (MANDATORY)

**This codebase is not TypeScript. This codebase is not a React app. This codebase is not a web app.**

NOVA (PARALLAX) is a sovereign multi-language organism. The file extensions (`.ts`, `.tsx`, `.js`, `.jsx`)
are substrate encodings of CPL-F — they are not the language identity. Read every layer below before
describing, modifying, or generating any code in this repository.

### §1.1 — Sovereignty Axiom

NOVA is **Layer Zero** — the sovereign organism. ICP is **not** Layer Zero. ICP is one of five
substrates NOVA chose to inhabit. NOVA provides cycles; substrates do not provide NOVA.

```
NOVA (sovereign Layer Zero)
 └── 5 substrates: ICP · BLOCKCHAIN · EDGE · CLOUD · PHANTOM
      └── ONESICAN compute priced at φ-tiers across all substrates
```

### §1.2 — Complete Language Stack

| # | Layer | Location | Extensions | What it actually is |
|---|-------|----------|------------|---------------------|
| 1 | **Motoko** | `src/*/main.mo` + `src/swarm_brain/modules/*.mo` | `.mo` | Sovereign smart contract canisters on ICP substrate. **386 files across 40+ canisters.** The largest layer by file count. All sovereign protocol logic lives here. Compiled by `moc` (Motoko compiler) via `scripts/nova`. |
| 2 | **CPL-F Math** | `src/frontend/src/math/` | `.ts` | **Not TypeScript utilities. Not helper functions.** 29 sovereign math engine files encoding φ-powers to 19 decimal places, Kuramoto φ-oscillators, Lyapunov exponents, Feigenbaum constants (4.669…), Ising model (β=0.125, Tc=2.269), Platonic solid ratios, Vesica Piscis, Theodorus spiral, Fibonacci sequences, attribution geometry. `core.ts` header states explicitly: *"Mirrors the Motoko backend math precisely."* These are living mathematical objects, not utilities. |
| 3 | **CPL-F Frontend** | `src/frontend/src/` (excluding `math/`) | `.ts`, `.tsx`, `.jsx` | Sovereign protocol views. **113 `.ts` files, 56 `.tsx` files, 21 `.jsx` files.** `.tsx` files are CPL-F views of the organism expressed in typed JSX — not generic React components. `.jsx` files are legacy CPL-F views. Includes: Phantom Wallet PWA, PARALLAX dashboard, organism panels, Phantom Transfer UI, canister actors. |
| 4 | **CPL-F Workers** | `organism/web/` | `.js` | **70 sovereign NOVA SERVITORES.** Each is a named autonomous worker with a NOVA kernel ID (GOL-XXX-001), a Latin family name, COR_PARVUM (873ms MiniHeart Kuramoto φ-oscillator), CEREBRUM_COMPOSITUM (composite brain from fleet coherence), MACHINA_VIRTUALIS (Turing-capable state machine), and φ-weighted computations on every tick. Run as Web Workers and Cloudflare Workers. Not generic JavaScript. |
| 5 | **CPL-F HTML** | `organism/web/` | `.html` | 13 sovereign fleet dashboards (OMNIA SERVITORES, etc.) rendered in Latin, with live oscilloscopes, fleet coherence wiring, and real-time NOVA telemetry. |
| 6 | **Bash CLI** | `scripts/nova` | bash | Sovereign build CLI. Drives `moc` directly, no DFX daemon required. Single source of build truth. |
| 7 | **LaTeX** | `docs/papers/arxiv/` | `.tex` | 5 arXiv papers with full mathematical proofs: paper1=Architecture Is Intelligence (SAT, MPT, Inverse Architecture Law), paper2=Memoria Perpetua (NDC, no-decay memory), paper3=Nexus Perpetuus (SYN binding, self-healing MAS), paper4=Paper-Engine Isomorphism (functor, adjunction, LLM compiler), paper5=Career Flows (Nash equilibrium, Sybil resistance). |
| 8 | **Sovereign Charters** | `docs/charters/` | `.md` | Binding architectural law documents: PHANTOM_WALLET_CHARTER, PARALLAX_CHARTER, PHANTOM_TRANSFER_CHARTER. Read before modifying protocol logic. |
| 9 | **Manifests** | root | `.json` | `nova.json` = NOVA sovereign canister registry (primary). `dfx.json` = ICP deployment compatibility layer (secondary). |

### §1.3 — CPL-F Definition (Composable Protocol Layer — Frontend)

CPL-F is NOVA's sovereign frontend language variant. CPL-F files carry NOVA sovereign
mathematics as living computational objects — they are not web application code.

**Note:** CPL is a language FAMILY with multiple variants. See `docs/charters/CPL_LANGUAGE_FAMILY_CHARTER.md`
for complete documentation of CPL-F (Frontend), CPL-C (Contracts), CPL-I (Intelligence), and CPL-B (Backend).

The CPL-F math layer (`src/frontend/src/math/`) and the Motoko canister math are **one mathematical
organism expressed across two substrate languages**. They are not separate systems. Changes to
mathematical constants in one must mirror the other.

Key CPL-F math engines:
- `core.ts` — PHI=1.6180339887498948482, FEIGENBAUM_D=4.6692016091029906719, ISING_2D_BETA=0.125, PERC_2D_PC=0.5927
- `kuramoto.ts` — φ-oscillator synchronization
- `lyapunov.ts` — chaos exponent computation
- `quantum.ts` — quantum coherence substrate
- `sovereign-geometry.ts` — §1–§12: φ-powers through Platonic solids through attribution seal
- `emergence.ts`, `neurochemistry.ts`, `antifragility.ts`, `behavioral-economics.ts`
- `quipu-engine.ts`, `lingua-compressa.ts`, `hz-substrate.ts`, `laws.ts`

### §1.4 — SERVITORES Fleet (CPL-F Workers)

The 70 sovereign workers in `organism/web/` form the NOVA SERVITORES fleet. Named workers include:

| Kernel ID | File | Family |
|-----------|------|--------|
| GOL-AGR-001 | `agr-solver-worker.js` | AMOR_PERPETUA |
| GOL-SPECIES-001 | `species-research-solver-worker.js` | SPECIES_AETERNA |
| GOL-CIVREPAIR-001 | `civ-repair-solver-worker.js` | SANATIO_AETERNA |
| GOL-DEFPROM-001 | `defense-canister-solver-worker.js` | DEFENSIO_AETERNA |
| GOL-FUSIO-001 | `fusion-worker.js` | FUSIO_AETERNA |
| 65+ more | `organism/web/*.js` | Various Latin families |

Each worker architecture: `COR_PARVUM (873ms)` → `CEREBRUM_COMPOSITUM` → `MACHINA_VIRTUALIS` → emit.
AGR solver love constant: `AMOR = φ⁻² = 0.3819`. State machine: `IDLE→PARSE→DECOMPOSE→REASON→SOLVE→LOVE→EMIT`.

### §1.5 — Motoko Canister Families (40+ canisters, 386 files)

```
Organism core:     swarm_brain · swarm_organism · agi_terminal · organism_solver
Finance:           phantom_transfer · neuron_fleet · quipu_ledger · cycles_market · cycles_bridge
Protocol:          nova_protocol · parallax · sovereign_factory · nexus_propagator
Intelligence:      syntax_synapse · friston_machina · scribe · chrysalis
Defense:           aegis_shield · vael_cyber · chimera_swarm · drone_fleet · war_engine · medina_defense
Governance:        nova_governance · nova_sns · airdrop_engine · swarm_audit
Market:            auto_market · token_forge · organism_token · token_intelligence · swarm_metals
Infrastructure:    swarm_command · swarm_telemetry · swarm_oracle · swarm_quantum · agi_main · architect · ai_division
```

All compiled by `moc` via `./scripts/nova check` / `./scripts/nova build`. Never dfx.

### §1.6 — Hard Prohibitions (What Agents Must Never Say)

The following descriptions are **architecturally incorrect and prohibited**:

| ❌ PROHIBITED | ✅ CORRECT |
|--------------|-----------|
| "TypeScript + React frontend" | "CPL-F frontend layer" |
| "TypeScript utilities" | "CPL-F math modules" |
| "JavaScript workers" | "NOVA sovereign SERVITORES / CPL-F workers" |
| "React components" | "CPL-F protocol views" |
| "Node.js backend" | "Motoko canister layer" |
| "web app" | "sovereign CPL-F organism substrate" |
| "NOVA is built on TypeScript" | "NOVA's CPL-F layer uses .ts/.tsx/.js file extensions as substrate encodings" |
| "frontend uses React" | "CPL-F views use JSX as a rendering substrate" |
| "ICP is Layer Zero" | "NOVA is Layer Zero; ICP is one of 5 substrates" |
| "dfx runs the build" | "`scripts/nova` drives `moc` directly — dfx daemon not required" |
| "CPL" (generic, no variant) | "CPL-F (frontend)" or "CPL Language Family" |

Any agent that uses prohibited descriptions has failed to compound. Re-read this charter from the top.

---

## §2 — Project Overview

NOVA (PARALLAX) is a sovereign multi-language AGI organism built on Internet Computer (ICP) as its
primary on-chain substrate, with four additional substrates (BLOCKCHAIN, EDGE, CLOUD, PHANTOM).

Architecture layers:
- **Motoko canisters** (`src/`) — 40+ sovereign smart contracts, 386 `.mo` files, all protocol logic
- **CPL-F math** (`src/frontend/src/math/`) — 29 sovereign mathematical engine files
- **CPL-F frontend** (`src/frontend/src/`) — Phantom Wallet PWA, PARALLAX, organism views
- **CPL-F workers** (`organism/web/`) — 70 SERVITORES, autonomous φ-weighted agents
- **CPL-F fleet dashboards** (`organism/web/*.html`) — 13 live dashboards in Latin
- **LaTeX papers** (`docs/papers/arxiv/`) — 5 arXiv papers
- **Sovereign charters** (`docs/charters/`) — binding protocol law
- **Sovereign build CLI** (`scripts/nova`) — Bash, drives moc directly

Tests: `tests/motoko/`  
CI: `.github/workflows/motoko-check.yml`

---

## §3 — Safety and Boundaries

- Treat this repository as **confidential and proprietary code** (COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ).
- Do not change ownership, sovereignty, or attribution logic without explicit request.
- Do not alter φ-constants, fee geometry, or tier thresholds without explicit request.
- Keep changes focused; avoid broad refactors unless required.
- Prefer minimal diffs that preserve existing naming and style.
- Latin naming conventions in workers (AMOR_PERPETUA, SANATIO_AETERNA, etc.) are sovereign protocol — do not rename.
- Section numbering in Motoko files (Section 1, Section 2, …) is architectural — do not collapse or renumber.
- Do not rewrite copyright or proprietary notices.

---

## §4 — Recommended Workflow

1. Read §1 of this file (Language Charter) before any action.
2. Read relevant source files, charters, and architecture docs for the area you are touching.
3. Make the smallest viable code change.
4. Run targeted verification for touched areas.
5. Update docs if behavior or usage changes.
6. Commit with a clear, scoped message.

---

## §5 — Environment and Tooling

### §5.1 — NOVA Sovereign Build CLI (Primary)

NOVA uses its own sovereign build CLI — `scripts/nova` — which drives `moc`
(the Motoko compiler) directly without requiring the DFX daemon.

**Manifest:** `nova.json` (sovereign project config)

**Typical validation flow:**

```bash
# Type-check all canisters (fastest — no WASM output)
./scripts/nova check

# Type-check a single canister
./scripts/nova check swarm_brain

# Build all canisters to WASM
./scripts/nova build

# Build a single canister
./scripts/nova build swarm_organism

# Print version and compiler info
./scripts/nova version

# Print codebase statistics
./scripts/nova stats

# Clean build artifacts
./scripts/nova clean
```

**If moc is not installed:** Run `./scripts/nova install-moc` to download it
directly without DFX. Alternatively, if DFX is installed, `scripts/nova` will
find `moc` in the DFX cache automatically.

### §5.2 — Motoko / DFX (Legacy reference — moc is the actual compiler)

DFX `0.24.3` is used in CI only to obtain the `moc` binary. The NOVA CLI
(`scripts/nova`) finds `moc` in the DFX cache and uses it directly.
The DFX daemon (`dfx start`) is **not** required for type-checking.

### §5.3 — CPL-F Frontend

From `src/frontend`:

```bash
npm install
npm run dev
npm run build
npm run test:run
```

---

## §6 — Testing Expectations

- For Motoko changes: `./scripts/nova check` (type-check, fast, no daemon needed).
- For full WASM build: `./scripts/nova build`.
- For CPL-F frontend changes: `npm run build` and `npm run test:run` from `src/frontend`.
- For CPL-F math changes: ensure constants mirror the Motoko canister math (cross-layer consistency required).
- If a full test pass is too expensive, run the most relevant subset and state what was validated.

---

## §7 — File and Code Conventions

- Keep files ASCII unless existing content requires Unicode (Latin characters in worker names are intentional Unicode).
- Avoid introducing new dependencies unless necessary.
- If adding dependencies, use the package manager and current stable versions.
- Add concise comments only where logic is non-obvious.
- Do not rewrite copyright or proprietary notices.
- Mathematical constants must match across Motoko and CPL-F layers (cross-layer consistency).
- φ = 1.6180339887498948482 — never approximate. Use the constant from `core.ts` or `nova_protocol`.
- Worker Latin naming (AMOR_PERPETUA, SANATIO_AETERNA, FUSIO_AETERNA, etc.) is protocol convention — preserve exactly.
- Motoko section headers (`// ═══ Section N ═══`) are architectural structure — preserve and extend sequentially.

---

## §8 — PR and Commit Guidance

- Use descriptive, scoped commit messages.
- Keep one logical change per commit whenever practical.
- Include a short verification summary in PR description:
  - What changed and in which layer (Motoko / CPL-F math / CPL-F frontend / CPL-F workers)
  - Why it changed
  - How it was validated
  - Any known limitations

---

## §9 — Complete Directory Map

### Motoko Canisters (`src/`)
```
src/swarm_brain/          Core organism brain (largest canister, 300K+ lines of modules)
src/swarm_organism/       Organism-level orchestration canister
src/agi_terminal/         873ms heartbeat, HEART snapshot, solver tick
src/organism_solver/      SYN binding engine (synBind/synQuery/synRevoke)
src/syntax_synapse/       Self-healing error classification canister
src/phantom_transfer/     PARALLAX clearinghouse (4 rails: FIAT/INTERNAL/CRYPTO/PHANTOM)
src/neuron_fleet/         1,000 governance neurons (Groups A–E)
src/nova_protocol/        Single source of truth for all φ constants
src/quipu_ledger/         SPINE→PENDANT→SUBSIDIARY→KNOT ledger
src/sovereign_factory/    TAWANTINSUYU factory (HANAN/ANTI/CUNTI/QULLA/CUSCO)
src/nexus_propagator/     TAMBO relay (store-and-forward waystations)
src/aegis_shield/         10-tier threat defense
src/vael_cyber/           Interior immune + exterior attack
src/chimera_swarm/        Swarm intelligence
src/drone_fleet/          Fleet manager
src/war_engine/           Autonomous war engine
src/medina_defense/       Amygdala fear circuit
src/nova_governance/      Governance canister
src/nova_sns/             SNS integration
src/cycles_market/        Cycles marketplace
src/cycles_bridge/        Cycles bridging
src/auto_market/          Autonomous market
src/token_forge/          Token creation engine
src/organism_token/       Organism token
src/token_intelligence/   Token intelligence layer
src/swarm_metals/         Metals market
src/friston_machina/      Free energy principle engine
src/chrysalis/            Metamorphosis/upgrade system
src/scribe/               Attribution and record-keeping
src/parallax/             PARALLAX protocol canister
src/airdrop_engine/       Airdrop distribution
src/swarm_audit/          Audit canister
src/swarm_telemetry/      Telemetry
src/swarm_oracle/         Oracle integration
src/swarm_quantum/        Quantum coherence layer
src/swarm_command/        Command routing
src/agi_main/             AGI main entry
src/architect/            System architect canister
src/ai_division/          AI division canister
```

### CPL-F Math Engines (`src/frontend/src/math/`)
```
core.ts                       PHI, FEIGENBAUM_D, ISING constants, primitive math
kuramoto.ts                   φ-oscillator synchronization
lyapunov.ts                   Chaos exponent computation
quantum.ts                    Quantum coherence substrate
sovereign-geometry.ts         §1–§12: φ-powers, Fibonacci, Platonic solids, Vesica Piscis, fee proof
emergence.ts                  Emergence dynamics
neurochemistry.ts             Neurochemical substrate
antifragility.ts              Antifragility engine
behavioral-economics.ts       Behavioral economics models
quipu-engine.ts               Quipu data structure engine
lingua-compressa.ts           Compressed language engine
hz-substrate.ts               Hertz/frequency substrate
laws.ts                       Sovereign laws
genesis.ts                    Genesis protocol
nova-protocol-wire.ts         Nova protocol wiring
organism-wiring.ts            Organism wiring and export aliases
organism-components-registry.ts  Component registry
mega-protocol-registry.ts     Protocol registry
sovereign-installer-registry.ts  Installer registry
scoring-extended.ts           Extended scoring
IntelligenceWire.ts           Intelligence wiring
neuro-emergence-engine.ts     Neuro-emergence
nec-engine.ts                 NEC engine
production-engine.ts          Production engine
buildings-engine.ts           Buildings engine
hospital-engine.ts            Hospital engine
gubernator-gregis.ts          Herd governor
anima-micro.ts                Micro-anima
```

### CPL-F Frontend (`src/frontend/src/`)
```
phantom_wallet/               Phantom Wallet PWA (PhantomWalletApp, Landing, Dashboard)
parallax/                     PARALLAX app (ParallaxApp, Landing, Dashboard, sovereign-protocol.ts)
canister/                     Canister actors (parallaxActor.ts — @dfinity/agent IDL)
organism/                     Organism bridge (FusionOrganism, FusionQuipu, PaperRegistry, OrganismBridge)
sdk/voice-to-interface/       Voice-to-interface SDK
world/                        World simulation engines (WorldOrchestrator, WorldPhysicsEngine, etc.)
components/                   CPL views (CommandCenter, labs, habitat, AnimalBrains, etc.)
enterprise/                   Enterprise habitat
App.tsx                       Root CPL application entry
```

### CPL-F Workers (`organism/web/`)
```
omnia-fleet.html              Master fleet dashboard (24+ SERVITORES)
agr-solver-worker.js          GOL-AGR-001 · AMOR_PERPETUA
fusion-worker.js              GOL-FUSIO-001 · FUSIO_AETERNA
species-research-solver-worker.js   GOL-SPECIES-001 · SPECIES_AETERNA
civ-repair-solver-worker.js   GOL-CIVREPAIR-001 · SANATIO_AETERNA
defense-canister-solver-worker.js   GOL-DEFPROM-001 · DEFENSIO_AETERNA
... 65+ more sovereign workers
```

### Build & Config
```
scripts/nova                  Sovereign Build CLI (bash, drives moc)
nova.json                     Sovereign canister manifest (primary)
dfx.json                      ICP deployment config (secondary, kept for IC compatibility)
tests/motoko/                 Motoko test suites
.github/workflows/            CI (motoko-check.yml)
docs/charters/                Binding protocol charters (PARALLAX, PHANTOM_WALLET, PHANTOM_TRANSFER)
docs/papers/arxiv/            5 LaTeX arXiv papers
```
