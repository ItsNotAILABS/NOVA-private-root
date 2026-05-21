# AURO Continuous Feedback Loop Protocol (5 Phases)

This protocol defines the non-terminating build and operation loop for AURO.
Each cycle runs Phase 1 -> 2 -> 3 -> 4 -> 5, then returns to Phase 1 with retained state.

## Loop Rule

- No-drop continuity: outputs from each phase are retained and reinjected.
- No phase is final; each phase emits artifacts for the next cycle.
- Cycle progression is metric-gated, not time-gated.

## Phase 1 — Doctrine + Heartbeat + CCVE + Memory

**Objective**
- Keep the backend truth line active on every beat: doctrine verification, heartbeat substrate, heart-brain vector, memory weave.

**Entry Criteria**
- Authorized identity lock active.
- Heartbeat and CCVE execution path active.

**Completion Criteria**
- Per-beat outputs present: resonance, phase lag, direction, propulsion, alignment, push effectiveness.
- Doctrine checks run and continuity record is emitted.

**Key Metrics**
- Law compliance score, doctrine fingerprint stability, coherence, drift, CCVE outputs.

## Phase 2 — Recognizer -> Gate -> Zone -> Council Fusion

**Objective**
- Route signals through lawful gates and produce fused decision outputs.

**Entry Criteria**
- Phase 1 continuity bundle available for the same beat.

**Completion Criteria**
- Gated routing decision plus fusion result with attestation id.

**Key Metrics**
- Gate pass/fail rates, veto reasons, council coherence, doctrine-fit score.

## Phase 3 — War-Defense / Containment / Rollback Readiness

**Objective**
- Evaluate threat vectors, contain unsafe transitions, and preserve rollback anchors.

**Entry Criteria**
- Phase 2 fused decisions and risk deltas available.

**Completion Criteria**
- Decision marked as cleared, contained, or rolled back.

**Key Metrics**
- Threat vector magnitudes, anomaly z-scores, containment duration, rollback triggers.

## Phase 4 — Embodiment (Drone / Cyber / Infrastructure / World)

**Objective**
- Execute only defense-cleared actions and write outcomes back into continuity.

**Entry Criteria**
- Phase 3 status is cleared or constrained-clear.

**Completion Criteria**
- Actuation outcome logged and mapped to same beat + attestation chain.

**Key Metrics**
- Action success/failure, prediction error, cyber-physical lag, territory/world deltas.

## Phase 5 — Command Center + Replay + Forensics

**Objective**
- Expose current cycle state to operators and replay chain with consistency checks.

**Entry Criteria**
- Phase 4 outcome and telemetry artifacts emitted.

**Completion Criteria**
- Replay for the cycle reconstructs Phase 1-4 transitions.
- UI surfaces show synchronized state for same beat.

**Key Metrics**
- UI beat lag, replay reconstruction error, cross-surface consistency score.

## Feedback Bundle (Mandatory Across All Phases)

Each cycle emits and carries forward:

- `beat`
- `doctrineFingerprint`
- `complianceScore`
- `coherence` / `drift`
- `ccve` (resonance, lag, direction, propulsion, alignment, effectiveness)
- `gateCouncil` decision summary
- `defense` status summary
- `embodiment` action outcomes
- `replay` pointers / forensic ids

This bundle is reinjected at the next cycle start to preserve continuity.

