# NOVA Reuse Kit (Deployable Templates)

This kit turns the architecture into repeatable artifacts you can copy into any new build.

---

## 1) Required Reuse Artifacts

Every build MUST include these files:

1. `phi.*` (backend/frontend constants parity)
2. `types.*` (canonical model contracts parity)
3. `LAW_REGISTRY.*` (compressed law registry + enforcement mapping)
4. `TWIN_CORE_MANIFEST.*` (Core A / Core B boundaries and gates)
5. `RING_MAP.*` (full sphere composition for this build)
6. `EXPOSURE_POLICY.*` (zero-exposure routing and public surface controls)

---

## 2) Twin Core Manifest Template

Use this structure verbatim:

```yaml
twin_core_manifest:
  version: "1.0"
  build_id: "text"
  doctrine_fingerprint: "text"

  core_a:
    name: "Runtime Intelligence Core"
    authority:
      runtime_truth_write: true
      law_gate_authority: true
      arbitration_authority: true
      continuity_authority: true
    accepts_from:
      - intrinsic_labs
      - core_b
    accepts_conditions:
      - contract_valid
      - law_pass
      - replay_safe

  core_b:
    name: "Workforce Orchestration Core"
    authority:
      runtime_truth_write: false
      proposal_write: true
      build_release_authority: true
    can_modify:
      - product_surfaces
      - pipeline_artifacts
    cannot_modify:
      - doctrine_registry
      - runtime_truth_state

  gates:
    gate_a_core_runtime_readiness:
      required:
        - deterministic_beat
        - bounded_coherence_drift
        - law_before_actuation
        - deterministic_arbitration
        - no_drop_reinjection
        - replay_reconstructable
    gate_b_workforce_activation:
      required:
        - core_a_contract_compatibility
        - security_channel_controls
        - rollback_hooks
        - build_audit_replay
    gate_c_public_projection:
      required:
        - zero_exposure_pass
        - owner_surface_protection
        - incident_controls
```

---

## 3) Ring Map Template

```yaml
ring_map:
  r0_fundamentals:
    scope: "absolutes and encoded constants"
  r1_doctrine:
    scope: "laws and invariants"
  r2_substrate_language:
    scope: "backend/frontend substrate + canonical types"
  r3_runtime_intelligence:
    scope: "core_a runtime truth"
  r4_intrinsic_labs:
    scope: "self-improvement inside organism domain"
  r5_industrial_workforce:
    scope: "core_b build factory"
  r6_product_projection:
    scope: "public/enterprise offerings"
  r7_external_ecosystem:
    scope: "partners/users/device federation"
```

---

## 4) Model Contract Classification Template

Use this to avoid model/function collapse:

```yaml
model_registry_entry:
  model_id: "MEDINA-EXAMPLE"
  class: "M0|M1|M2"
  definition:
    m0_archetype: "doctrine meaning"
    m1_contract: "type signature file and schema hash"
    m2_instance: "runtime record origin and beat semantics"
  shared_by:
    - core_a
    - core_b
    - frontend_kernels
  not_a_model_if:
    - "single-use only"
    - "local helper payload"
```

---

## 5) Exposure Policy Template

```yaml
exposure_policy:
  public_allowed:
    - numeric_metrics
    - proof_references
    - bounded_status
  public_forbidden:
    - doctrine_labels
    - law_names
    - coupling_topology
    - sovereign_thresholds
    - creator_only_views
  owner_only_surfaces:
    - creator_terminal
    - full_snapshot_debug
```

---

## 6) Build Bootstrap Checklist

1. Copy reuse artifacts into new build.
2. Verify `phi.mo` <-> `phi.ts` parity hash.
3. Verify `types.mo` <-> `types.ts` parity hash.
4. Freeze Twin Core manifest and gate definitions.
5. Bring up Core A and pass Gate A.
6. Enable Core B (Gate B).
7. Expose products only after Gate C.
8. Archive replay bundle for first production cycle.

---

## 7) One-Line Reuse Rule

Never start from zero:
Reuse the same fundamentals, laws, model language, and twin-core gates; only change domain rings and product projections.
