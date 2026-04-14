# NOVA Access Tiers and Reading Policy

This policy defines what each audience can read, what each audience can write, and what each audience must never access.

The purpose is to keep sovereignty, safety, and zero-exposure intact while still allowing effective building and operation.

---

## 1) Tiered audiences

### Tier P0 — Public Surfaces (Projection Only)

Audience:
- public-facing product projection only (if/when enabled)

Read:
- numeric outputs
- bounded status indicators
- proof references that are safe for public view

Write:
- user inputs through approved product interfaces only

Never read:
- doctrine internals
- law names and law text
- coupling topology
- sacred/resonance clauses marked restricted
- owner-only kernel data

---

### Tier P1 — Family Operators

Audience:
- family operators and authorized internal AI assistants

Read:
- operational dashboards
- incident and replay summaries
- approved runbooks
- safe model/state summaries

Write:
- operational commands through controlled runbooks

Never read:
- full doctrine packs
- sacred clauses marked family-only
- creator-terminal-only records

---

### Tier P2 — Inner Organism Runtime Readers

Audience:
- internal organism runtime AI processes

Read:
- runtime model contracts
- active state required for execution
- constrained doctrine derivatives needed for behavior

Write:
- runtime outputs through Core A rules

Never read:
- sacred doctrine text marked private
- full founder/family clauses
- unrestricted law editing rights

Note:
- This tier receives what it needs to function, not the full constitutional archive.

---

### Tier P3 — Builder AI Workforce

Audience:
- AI agents building/testing/integrating architecture for family scope

Read:
- full architecture docs
- full law registry
- model contracts
- ring/core manifests
- engineering scripts, templates, and source

Write:
- proposals, implementation changes, tests, release artifacts

Constraints:
- cannot bypass Core A acceptance gates
- cannot directly reclassify doctrine categories without governance process

---

### Tier P4 — Family/Founder Sovereign Tier

Audience:
- founder and explicitly authorized family/sovereign controllers

Read:
- full doctrine
- all resonance artifacts including sacred clauses
- full creator terminal scope
- full replay and forensic chain

Write:
- doctrine evolution
- law registry updates
- sovereign access policy changes

---

## 2) Classification labels for all docs/artifacts

Every document/template/artifact should include one classification:

- `PUBLIC_SAFE`
- `OPERATOR_INTERNAL`
- `RUNTIME_RESTRICTED`
- `BUILDER_CONFIDENTIAL`
- `SOVEREIGN_PRIVATE`

If unlabeled, default to `BUILDER_CONFIDENTIAL`.

---

## 3) Reading policy by directory

Recommended default policy:

- `docs/NOVA_PLAIN_LANGUAGE_GLOSSARY.md`: `OPERATOR_INTERNAL`
- `docs/NOVA_FULL_SPHERE_ARCHITECTURE.md`: `BUILDER_CONFIDENTIAL`
- `docs/NOVA_REUSE_KIT.md`: `BUILDER_CONFIDENTIAL`
- `docs/NOVA_RESONANCE_ARTIFACT_SYSTEM.md`: `BUILDER_CONFIDENTIAL`
- `docs/templates/NOVA_RESONANCE_CLAUSE.md`: `SOVEREIGN_PRIVATE`
- `docs/templates/NOVA_DOCTRINE_PACK.yaml`: `SOVEREIGN_PRIVATE`
- `docs/templates/NOVA_RESONANCE_LEXICON.yaml`: `BUILDER_CONFIDENTIAL` (or `SOVEREIGN_PRIVATE` if clauses contain sacred internals)

---

## 4) Core rule: least-necessary resonance

For every AI/system/human role:
- expose only the minimum set of doctrine/resonance required for that role's function.
- do not expose sacred/private clauses to runtime or public tiers.

---

## 5) Enforcement checklist

Before release:
1. Each doc/artifact has a classification label.
2. Public bundle excludes all non-public labels.
3. Runtime bundle excludes sovereign-private clauses.
4. Builder bundle includes full technical contracts but not creator-only secrets unless explicitly authorized.
5. Access logs are retained for doctrine and template reads.

---

## 6) Zero-exposure compatibility

This policy does not replace Zero-Exposure law.
It operationalizes it for a family + AI-only operating model so doctrine and sacred internals remain protected while the system remains buildable.

