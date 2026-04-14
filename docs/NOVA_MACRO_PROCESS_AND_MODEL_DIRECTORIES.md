# NOVA Macro Process and Model Directories (Enterprise Canon)

Classification: `BUILDER_CONFIDENTIAL`

Purpose:
- name the real macro process end-to-end in non-collapsed form,
- define how many model families are required to run enterprise-grade builds,
- and define permanent naming/directory conventions so models can be reused across products/APIs.

---

## 1) The macro process name

Use this permanent process name:

**Sovereign Macro Orchestration Fabric (SMOF)**

SMOF is not a single pipeline. It is a governed multi-plane operating system:

1. Constitutional plane
2. Ontology plane
3. Model language plane
4. Macro orchestration plane
5. Micro execution plane
6. Runtime substrate plane
7. Core/engine plane
8. Arbitration/reinjection plane
9. Evidence/projection plane

---

## 2) Minimal model families for enterprise operation

For your architecture style, the minimal complete set is **12 model families**.

This is enough to run internal organism, workforce, and product projection without collapse.

1. **Constitution Models**
   - doctrine fingerprint, law set version, invariant map
2. **Identity and Authority Models**
   - actor tier, role grants, signer scope, access decisions
3. **State Fabric Models**
   - global organism state (coherence, drift, cognition, emergence, continuity)
4. **Beat and Time Models**
   - heartbeat event, timestamp4D, depth position
5. **Coupling and Transfer Models**
   - coupling edges, transfer routes, allowed propagation
6. **Arbitration Models**
   - candidate outputs, score terms, verdict, reserve lineage
7. **Memory and Continuity Models**
   - reinjection records, continuity traces, retention lineage
8. **Proof and Replay Models**
   - proof links, replay bundles, causal trace entries
9. **Economic Models**
   - treasury flows, reserve lock state, multiplier states
10. **Defense and Safety Models**
    - threat vectors, containment status, rollback anchors
11. **Workforce and Build Models**
    - task packets, build proposals, validation records, release artifacts
12. **Projection Models**
    - public-safe output schemas, API contracts, exposure audit records

Rule:
- If a candidate model belongs to only one function and one local consumer, keep it local and do not promote to sovereign model family.

---

## 3) Macro YAML stack vs Micro YAML stack

### Macro YAML stack (constitutional orchestration)

These are long-lived, build-governing orchestration models:

- `NOVA_DOCTRINE_PACK.yaml`
- `NOVA_LAW_REGISTRY.yaml`
- `NOVA_TRANSFER_PROTOCOL.yaml`
- `NOVA_BUILD_INSTANCE_TEMPLATE.yaml`
- (recommended) `NOVA_MODEL_DIRECTORY.yaml`
- (recommended) `NOVA_GATES_SCORECARD.yaml`

Purpose:
- tells AI builders what must exist, what can move, and what gates must pass.

### Micro YAML stack (execution packets)

Short-lived per-phase/per-run/per-job packets:

- active gate context
- selected model subset
- allowed transfer subset
- required evidence outputs

Purpose:
- execute specific cycle work under macro constraints.

---

## 4) Permanent naming system (high-value, long-lived)

Use unique, stable prefixes:

- `CONST-*` constitutional entities
- `LAW-*` law entries
- `MOD-*` model families
- `FLOW-*` transfer routes
- `GATE-*` readiness/release controls
- `EVID-*` evidence/replay artifacts
- `PROJ-*` external projection contracts

Example IDs:
- `MOD-STATE-FABRIC`
- `MOD-ARBITRATION`
- `FLOW-RUNTIME-TO-WORKFORCE`
- `GATE-A-RUNTIME`
- `EVID-REPLAY-BUNDLE`
- `PROJ-PUBLIC-NUMERIC`

---

## 5) Model directory architecture (what you asked for)

Each model family should have a directory so it can be reused by internal builds and future APIs.

Recommended canonical structure (docs-side first):

```text
docs/model-directory/
  constitution/
    README.md
    MODELS.yaml
  identity-authority/
    README.md
    MODELS.yaml
  state-fabric/
    README.md
    MODELS.yaml
  beat-time/
    README.md
    MODELS.yaml
  coupling-transfer/
    README.md
    MODELS.yaml
  arbitration/
    README.md
    MODELS.yaml
  memory-continuity/
    README.md
    MODELS.yaml
  proof-replay/
    README.md
    MODELS.yaml
  economic/
    README.md
    MODELS.yaml
  defense-safety/
    README.md
    MODELS.yaml
  workforce-build/
    README.md
    MODELS.yaml
  projection/
    README.md
    MODELS.yaml
```

Every family `MODELS.yaml` should include:
- model ID
- class (M0/M1/M2)
- owner
- consumers
- gates touched
- exposure class
- parity hash refs

---

## 6) How this maps to products and APIs later

Because directories are family-scoped and stable:

- Core A can import required runtime families directly.
- Core B can discover and reuse build/workforce families.
- API layer can expose only `projection` family models.
- internal families stay reusable without re-deriving architecture each time.

This is how one model family can support many business uses without collapsing language.

---

## 7) Practical "A to B" answer

You asked "from A to B how many models does it really take?"

For enterprise-grade execution in your architecture:

- **12 sovereign model families** (above) is the minimal complete answer.
- You can have many individual models inside each family.
- The flow works because families are stable and orchestration is gated.

---

## 8) One-line operating principle

Use macro orchestration models to govern the system, micro execution models to run cycles, and model-family directories to preserve long-term reuse across organism, workforce, and product projection.

