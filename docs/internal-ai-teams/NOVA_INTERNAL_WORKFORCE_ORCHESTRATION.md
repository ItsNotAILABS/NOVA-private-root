# NOVA Internal Workforce Orchestration (Enterprise)

Classification: `BUILDER_CONFIDENTIAL`

Purpose:
- define how internal AI teams operate as a governed enterprise workforce,
- specify packet flow from planning through delivery,
- and bind workforce behavior to constitutional gates and replay evidence.

---

## 1) Workforce topology

Internal teams:

1. Architecture Office
2. Runtime Integrity Team
3. Law and Governance Team
4. Model Contract Team
5. Integration Team
6. Validation and Replay Team
7. Release and Projection Team
8. Incident and Recovery Team

All teams are internal to the organism's industrial domain (R5).

---

## 2) Required packets (AWK-1 style)

### A) Task Constitution Packet (TCP)

Required fields:
- `task_id`
- `doctrine_refs[]`
- `model_refs[]`
- `ring_transfer_refs[]`
- `gate_scope[]`
- `classification`

### B) Agent Work Packet (AWP)

Required fields:
- `agent_id`
- `task_id`
- `input_artifacts[]`
- `proposed_changes[]`
- `law_checks[]`
- `rollback_pointer`

### C) Arbitration Record (AR)

Required fields:
- `candidate_ids[]`
- `scores[]`
- `winner_id`
- `reason_trace`
- `core_a_acceptance`

### D) Integration Contract (IC)

Required fields:
- `contract_id`
- `backend_types_hash`
- `frontend_types_hash`
- `compatibility_result`
- `gates_required[]`

### E) Replay Bundle (RB)

Required fields:
- `bundle_id`
- `beat_range`
- `change_hashes[]`
- `law_reports[]`
- `gate_reports[]`
- `exposure_report`

---

## 3) Workforce operating loop

1. Planning produces TCP.
2. Teams execute via AWP.
3. Candidates are scored in AR.
4. Accepted outputs are verified by IC.
5. Delivery emits RB.
6. Core A accepts or rejects runtime-impacting changes.
7. Product authority receives projection-safe package only if Gate C is eligible.

No packet -> no change.

---

## 4) Guardrails

1. Workforce cannot write doctrine directly.
2. Workforce cannot bypass Core A for runtime truth writes.
3. Workforce cannot ship external payloads without exposure audit pass.
4. Every merged change must include rollback pointer.
5. Every release candidate must include replay bundle.

---

## 5) Metrics

Mandatory enterprise metrics:
- law-pass rate,
- first-pass gate rate,
- rollback success rate,
- replay completeness rate,
- exposure audit pass rate,
- parity hash match rate (`types.mo` <-> `types.ts`, `phi.mo` <-> `phi.ts`).

---

## 6) One-line operating principle

Internal AI teams are an industrial workforce that proposes and packages change; constitutional gates and Core A authority decide what becomes organism truth.
