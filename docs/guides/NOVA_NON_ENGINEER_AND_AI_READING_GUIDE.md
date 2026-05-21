# NOVA AI Builder Reading Guide

This guide explains how AI builders should read the repository in the right order and with the right access level.
It is designed for:

- internal AI teams,
- builder AIs,
- and family governance roles supervising AI execution.

---

## 1) The five things in this repository

1. **INTERNAL_OVERVIEW** (or internal readme equivalent): internal orientation only.
2. **docs/**: architecture, doctrine, policy, and operating manuals.
3. **templates/** (inside docs): reusable machine/human scaffolds.
4. **src/**: live runtime code.
5. **scripts/**: repeatable operational commands.

---

## 2) Reading order by persona

### A) External observer (post-release showcase only)

Read:

1. Public showcase material only (not internal architecture docs)

Do not read:

- doctrine internals
- law registry internals
- creator-only kernels

### B) Family operator supervising AI builders

Read:

1. `docs/NOVA_PLAIN_LANGUAGE_GLOSSARY.md`
2. `docs/NOVA_FULL_SPHERE_ARCHITECTURE.md` (sections 1-4 and ring map)
3. `docs/NOVA_REUSE_KIT.md` (checklists)
4. command runbooks

Focus on:

- what each ring does,
- what each gate means,
- which AI roles can change what.

### C) Inner organism runtime AI

Read:

- only runtime-safe model contracts
- operational state forms
- limited law outputs needed for behavior gating

Must not read:

- sacred/doctrine-private material
- creator-only surfaces
- internal build and governance internals

### D) Internal lab AI (intrinsic)

Read:

- Core A relevant doctrine and model contracts
- runtime telemetry and replay bundles
- lab-specific policy

Cannot do:

- direct public exposure changes
- doctrine registry edits without governance

### E) Workforce AI (industrial, Core B)

Read:

- full architecture docs
- templates
- build/release policy
- source code

Must pass:

- Gate A/B/C process
- zero-exposure checks

### F) Family / governance authority

Read:

- full doctrine and architecture materials
- all policies and governance artifacts
- all source and scripts

Authority:

- law and doctrine governance control
- final escalation decisions

---

## 3) What each file family means operationally

### `README.md`

- Internal orientation only.
- Used by family and internal AI teams.
- Not a public onboarding surface.

### `docs/*.md`

- Human governance and architecture memory.
- This is where non-engineers can understand system intent and authority boundaries.

### `docs/templates/*`

- Reuse blueprints.
- They keep new builds consistent with doctrine and model language.

### `src/**`

- The living implementation.
- This is where runtime truth is executed.

### `scripts/**`

- Operational shortcuts.
- They let teams run setup/build/deploy/test in repeatable ways.

### `.yml/.yaml`

- Machine-readable operating orders.
- CI, release rules, manifests, and automated checks.

---

## 4) Non-collapse reading reminders

Never collapse these while reading:

- Absolute vs Law
- Law vs Model
- Model vs Engine
- Engine vs Core
- Core vs Module
- Lab vs Workforce
- Runtime truth vs Product projection

If a reader collapses these categories, they must stop and re-read the glossary before acting.

---

## 5) “Need to know” access rule

Use least privilege by default:

- public sees product projection only,
- operators see governance-safe operational views,
- inner runtime AI sees only needed runtime contracts,
- builders/family get broader access under policy.

This preserves sovereignty while still enabling full enterprise execution.

