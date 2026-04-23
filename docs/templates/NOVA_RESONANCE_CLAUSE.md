# Resonance Clause Template

Use this for short doctrine phrases that carry large meaning while staying human-readable.

## Clause Metadata

- Clause ID: `RC-XXX`
- Ring Target: `R0|R1|R2|R3|R4|R5|R6|R7`
- Law IDs: `Lxx, Lyy`
- Model IDs: `MEDINA-*`
- Visibility: `private|owner|public-safe`

## Canonical Phrase

`<one concise phrase>`

## Operational Meaning (Expanded)

- What this phrase means in runtime behavior:
  - ...
- What must never happen if this clause is active:
  - ...
- Which gates are affected:
  - ...

## Machine Binding

- Doctrine token key: `doctrine.<token_name>`
- FK binding:
  - `gate_id: ...`
  - `weights: ...`
  - `reinjection_rules: [...]`
- Replay tags:
  - `clause_id`
  - `law_ids`
  - `model_ids`

## Exposure Rule

- Public-safe projection (if any): numeric/proof only
- Private details: hidden

