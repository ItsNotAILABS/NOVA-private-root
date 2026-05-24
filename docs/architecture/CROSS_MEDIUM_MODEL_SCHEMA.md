# NOVA Cross-Medium Model Schema (Canonical Adoption)

This document adopts a canonical cross-medium schema for model identity, authority, consistency, and proof state across substrate and projection forms.

## Canonical Identity

- `schema`: `nova.cross_medium_model.v1`
- `model_id`: globally unique immutable identifier
- `version`: semantic version of the model record
- `created_at` / `updated_at`: ISO 8601 timestamps
- `owner_domain`: owning canister/fleet/domain

## Invariant Bundle

Each model record carries:

- `L_m`: law payload
- `S_m`: canonical substrate state variables
- `I_m`: identity/formation fingerprint
- `R_m`: resonance/coherence signature
- `T_m`: temporal/heartbeat relation
- `P_m`: projection profile

## Authority Weights

The schema defines authority ordering and weighting:

- `substrate_motoko`
- `doctrine_docs`
- `projection_cpl_f`
- `synthesis_python` (optional/contextual)
- `transport_wasm` (optional/contextual)
- `interface_candid` (optional/contextual)

Required constraints:

1. `substrate_motoko > doctrine_docs`
2. `doctrine_docs > projection_cpl_f`
3. all weights are within `[0,1]`

## Cross-Medium Forms

- `substrate_form`: operator/state/access control references
- `document_form`: doctrine refs, meaning hash, exposure class
- `projection_form`: CPL-F refs and surface bindings
- `synthesis_form`: optional synthesis contract refs
- `transport_form`: optional artifact/build contract refs
- `interface_treaty`: candid refs and compatibility version

## Consistency and Drift

- `C(Sub_m, Doc_m)` → `sub_doc`
- `C(Doc_m, Exe_m)` → `doc_exe`
- `C(Exe_m, Proj_m)` → `exe_proj`
- `C(Proj_m, Sub_m)` → `proj_sub`
- `Xi_m`: weighted integrity score
- `D_m`: drift metric with `drift_budget` and status (`stable|warning|breach`)

## Runtime, Proof, and Gates

- Runtime heartbeat/coherence/immune/memory fields are mandatory.
- Proof state includes audit status, evidence refs, verifier, and runtime truth class.
- Required gates:
  - authority gate
  - consistency gate
  - treaty gate
  - proof gate
  - runtime truth gate

## Canonical Artifacts

- YAML template: `/home/runner/work/NOVA/NOVA/docs/templates/NOVA_CROSS_MEDIUM_MODEL_SCHEMA.yaml`
- JSON Schema: `/home/runner/work/NOVA/NOVA/docs/templates/NOVA_CROSS_MEDIUM_MODEL_SCHEMA.schema.json`

