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
7. `NOVA_PLAIN_LANGUAGE_GLOSSARY.md` (shared language for non-engineers and AI agents)
8. `NOVA_ACCESS_TIERS_AND_READING_POLICY.md` (who can read/write which artifacts)
9. `NOVA_NON_ENGINEER_AND_AI_READING_GUIDE.md` (execution order for humans + AI teams)
10. `NOVA_BUILD_INSTANCE_TEMPLATE.yaml` (single-file instantiation for new builds)
11. `NOVA_BUILD_CONSTITUTION.md` (master constitutional build contract)
12. `NOVA_ARTIFACT_CATALOG.md` (artifact library index and usage map)
13. `docs/templates/NOVA_LAW_REGISTRY.yaml` (compressed law registry machine template)
14. `docs/templates/NOVA_TRANSFER_PROTOCOL.yaml` (T01-T70 transfer contract template)
15. `docs/templates/NOVA_SPHERICAL_RING_SCHEMA.yaml` (full spherical ring authority schema)
16. `docs/templates/NOVA_RING_TRANSFER_GRAPH.yaml` (allowed/forbidden ring transfer graph)
17. `docs/templates/NOVA_GATES_SCORECARD.yaml` (Gate A/B/C pass/fail and evidence contract)
18. `docs/templates/NOVA_OPERATING_ORDERS.yaml` (execution-plane authority and route controls)
19. `docs/templates/NOVA_RING_FLOW.yaml` (compact ring ingress/egress and illegal path map)
20. `docs/templates/NOVA_MEMORY_RESIDENCY.yaml` (no-drop memory residency and replay classes)
21. `docs/templates/NOVA_EQUATION_REGISTRY.yaml` (machine equation canon with law/gate bindings)
22. `docs/templates/NOVA_PHRASE_EXPANSION.yaml` (resonance phrase-to-execution expansion map)

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
9. Configure access tiers before enabling any external AI agent workflow.
10. Verify inner-organism/agent views are routed to safe-summary docs only.

---

## 7) One-Line Reuse Rule

Never start from zero:
Reuse the same fundamentals, laws, model language, and twin-core gates; only change domain rings and product projections.

---

## 8) Resonance Artifact Add-On (Doctrine Encoding Layer)

Use these companion templates to encode high-density doctrine meaning without exposing internals:

- `docs/templates/NOVA_RESONANCE_LEXICON.yaml`
- `docs/templates/NOVA_DOCTRINE_PACK.yaml`
- `docs/templates/NOVA_RESONANCE_CLAUSE.md`

Purpose:

- Keep sacred/value-level language in structured doctrine artifacts.
- Map compressed phrases/symbols to explicit machine-facing effects.
- Preserve Zero-Exposure externally while keeping full internal meaning.

Rule:

- Every resonance clause must resolve to concrete law/model/gate references.
- If a clause cannot be operationalized, it remains commentary and cannot gate runtime behavior.

---

## 9) Constitutional Pack (High-Value Artifact Set)

For long-horizon reuse (family, future builders, multi-build programs), treat this as the mandatory constitutional pack:

- `docs/NOVA_BUILD_CONSTITUTION.md`
- `docs/NOVA_ARTIFACT_CATALOG.md`
- `docs/NOVA_FULL_SPHERE_ARCHITECTURE.md`
- `docs/NOVA_RESONANCE_ARTIFACT_SYSTEM.md`
- `docs/NOVA_ACCESS_TIERS_AND_READING_POLICY.md`
- `docs/NOVA_PLAIN_LANGUAGE_GLOSSARY.md`
- `docs/INDEX.md`
- `docs/consciousness-core/README_CONSCIOUSNESS_CORE.md`
- `docs/consciousness-core/NOVA_CONSCIOUSNESS_EQUATION_CANON.md`
- `docs/internal-ai-teams/README_INTERNAL_AI_TEAMS.md`
- `docs/internal-ai-teams/NOVA_INTERNAL_WORKFORCE_ORCHESTRATION.md`
- `docs/external-products/README_EXTERNAL_PRODUCTS.md`
- `docs/external-products/NOVA_EXTERNAL_PROJECTION_CONTRACT.md`
- `docs/model-directory/README.md`
- `docs/model-directory/ENTERPRISE_MODEL_FAMILIES.yaml`
- `docs/templates/NOVA_DOCTRINE_PACK.yaml`
- `docs/templates/NOVA_LAW_REGISTRY.yaml`
- `docs/templates/NOVA_TRANSFER_PROTOCOL.yaml`
- `docs/templates/NOVA_BUILD_INSTANCE_TEMPLATE.yaml`
- `docs/templates/NOVA_SPHERICAL_RING_SCHEMA.yaml`
- `docs/templates/NOVA_RING_TRANSFER_GRAPH.yaml`
- `docs/templates/NOVA_GATES_SCORECARD.yaml`
- `docs/templates/NOVA_OPERATING_ORDERS.yaml`
- `docs/templates/NOVA_RING_FLOW.yaml`
- `docs/templates/NOVA_MEMORY_RESIDENCY.yaml`
- `docs/templates/NOVA_EQUATION_REGISTRY.yaml`
- `docs/templates/NOVA_PHRASE_EXPANSION.yaml`

This pack is designed to carry high-density architectural meaning while remaining operationally executable.
