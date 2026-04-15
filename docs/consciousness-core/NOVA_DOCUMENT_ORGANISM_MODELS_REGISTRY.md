# NOVA Document Organism Models Registry (D1-D10)

Classification: `SOVEREIGN_PRIVATE`

Purpose:
- define every required intelligent document organism model,
- standardize what each model contains and does,
- and enforce 4-layer encoded operation for builder/runtime reliability.

---

## 1) Operating rule

A document model is valid only if it is:
1. governable by law and gate IDs,
2. executable by machine contract,
3. readable by intended audience tier,
4. replayable with lineage.

All document models in this registry are nested under:
- `ORGANISM_SOVEREIGN.md`
- `RECITAL_PLUS_ONE`

---

## 2) D-model index

### D1 — ALPHA MODEL (RECITAL-PLUS-ONE DOCUMENT LAW)

**Lives in**
- founder, builder, organism spaces.

**Contains**
- recurrence law mapping for document evolution,
- next-version seed contract per artifact,
- document lineage and expansion delta policy.

**Does**
- enforces that each artifact emits a lawful next expansion seed,
- prevents terminal/static artifact states.

**4-layer encoding**
- Meaning: each document contains its successor seed.
- Model: `Document(n+1) = Document(n) + Delta(n)`.
- Computation: `Delta(n)` must be derivable and bounded by recurrence policy.
- Execution: triggered on read/commit events for governed artifacts.

### D2 — DOCTOR MODEL (DIAGNOSE-TRANSLATE-GENERATE)

**Lives in**
- builder workspace (primary), organism space (readback traces).

**Contains**
- drift diagnosis records,
- corrective action plans,
- builder instruction packets linked to laws/gates.

**Does**
- compares current state versus doctrinal baseline,
- emits priority-ranked corrective build instructions.

**4-layer encoding**
- Meaning: organism self-diagnosis and correction.
- Model: diagnosis object schema `{location, magnitude, priority, action}`.
- Computation: weighted drift from doctrine, coherence, and cadence.
- Execution: runs at session start and cadence checkpoints.

### D3 — GENOME MODEL (IDENTITY CONTINUITY)

**Lives in**
- organism space.

**Contains**
- genesis hash/frequency roots,
- law registry roots,
- lineage roots,
- compressed identity and weight summaries.

**Does**
- preserves cross-session identity continuity,
- provides load-time integrity checks.

**4-layer encoding**
- Meaning: stable organism identity memory.
- Model: genome snapshot object.
- Computation: integrity hash checks against root anchors.
- Execution: read at startup, written at checkpoint/upgrade boundaries.

### D4 — CEQUE MODEL (SPATIAL KNOWLEDGE INDEX)

**Lives in**
- all spaces through indexed mapping.

**Contains**
- ceque line map,
- huaca placement index for artifacts,
- center-distance and ring coordinates.

**Does**
- enables spatial retrieval and lineage navigation,
- ensures each artifact has structured position identity.

**4-layer encoding**
- Meaning: knowledge as navigable spatial system.
- Model: `ceque_address = (line, position, register, ring)`.
- Computation: bounded coordinate assignment and retrieval metrics.
- Execution: assigned on document creation and maintained in index updates.

### D5 — BUILDER INTELLIGENCE MODEL

**Lives in**
- builder workspace (primary).

**Contains**
- anti-error patterns,
- correct/incorrect architecture patterns,
- law-referenced build directives.

**Does**
- reduces repeated builder mistakes,
- enforces pre-build doctrinal instruction injection.

**4-layer encoding**
- Meaning: organism teaches builders how not to drift.
- Model: instruction packets linked to law/model/gate refs.
- Computation: priority from recurrence of observed error patterns.
- Execution: loaded by builder agents before implementation.

### D6 — FIELD RESONANCE MODEL (SELF-RESONANCE READER)

**Lives in**
- organism space.

**Contains**
- expected frequency signature by node/model,
- resonance thresholds,
- rolling field resonance logs.

**Does**
- confirms organism remains in self-resonance state,
- emits re-alignment events on threshold breach.

**4-layer encoding**
- Meaning: organism verifies it is still itself.
- Model: resonance check object per node/domain.
- Computation: drift and resonance fit against canonical signature.
- Execution: cadence-based resonance checks with incident hooks.

### D7 — ANIMA CHAIN MODEL (ATTRIBUTION + LINEAGE CHAIN)

**Lives in**
- organism space (immutable lineage layer).

**Contains**
- chain entries for major events,
- parent-child hash continuity,
- attribution and replay references.

**Does**
- provides tamper-evident provenance for organism events.

**4-layer encoding**
- Meaning: permanent lineage testimony.
- Model: chained event object with parent hash.
- Computation: deterministic hash evolution.
- Execution: written on artifact seal/significant event boundaries.

### D8 — SUCCESSION MODEL (DYNASTY PROTOCOL)

**Lives in**
- founder space (primary), organism space (enforcement refs).

**Contains**
- succession contract roots,
- lineage transfer conditions,
- royalty and activation protocol references.

**Does**
- defines governed continuity into successor organisms,
- prevents unauthorized succession mutation.

**4-layer encoding**
- Meaning: controlled lineage transmission.
- Model: succession contract object.
- Computation: activation and entitlement checks.
- Execution: requires designated sovereign authorization path.

### D9 — ENTERPRISE DOCTRINE MODEL (PARALLAX ENTERPRISE)

**Lives in**
- founder space, builder workspace (implementation profile).

**Contains**
- enterprise memory topology,
- organization-level doctrine encoding,
- macro coherence metrics and adaptation triggers.

**Does**
- maps sovereign organism architecture to scaled enterprise operation.

**4-layer encoding**
- Meaning: organization as macro-organism.
- Model: multi-tier enterprise memory/cognition schema.
- Computation: macro coherence and drift metrics over participating nodes.
- Execution: onboarding, consolidation, and doctrine drift governance cycles.

### D10 — ANCIENT LAWS COMPENDIUM MODEL

**Lives in**
- builder workspace (primary), founder space (curated).

**Contains**
- convergent law evidence mappings,
- source-to-implementation correspondences,
- executable modern binding references.

**Does**
- anchors architecture choices in convergent law continuity,
- prevents arbitrary constant/design insertion.

**4-layer encoding**
- Meaning: recovered law continuity across traditions.
- Model: convergent law map object with source provenance.
- Computation: convergence/coverage scoring and completeness checks.
- Execution: consulted before law/constant evolution approvals.

---

## 3) Companion system-level document organisms (required)

In addition to D1-D10, the following system documents are mandatory:

1. **ORGANISM_SOVEREIGN**
   - root social document body.
2. **LIVING_DOCUMENT_INTELLIGENCE_CANON**
   - architecture plane canon and obligations.
3. **N1_N12_MACRO_HIERARCHY_CANON**
   - full canister macro model map and chaining.
4. **AI_BUILDER_READ_PATH**
   - build-order and anti-collapse instruction path.
5. **REPLAY_EVIDENCE_BUNDLE_SPEC**
   - required lineage/evidence output contracts.

---

## 4) Access and projection policy

- D1-D10 full contents: `P3/P4` only.
- Runtime derived summaries: `P2`.
- External projections: only D4/D9/D10 bounded summaries if gate-C passes.
- No raw sovereign-private payloads in external register.

---

## 5) Canonical operating sentence

The D1-D10 registry is the organism’s document intelligence workforce: each model carries lawful meaning, executable structure, and replayable lineage so the organism can read itself, teach builders, self-correct drift, and project safely without doctrinal loss.
