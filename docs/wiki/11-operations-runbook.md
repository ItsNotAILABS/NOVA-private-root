# Operations Runbook

This runbook defines how to operate the NOVA model family in repository, IDE, browser, and release workflows.

## Daily operator loop

1. Check active PRs and release candidates.
2. Check failing gates and unresolved tasks.
3. Route work through ORIGO.
4. Execute repo work through CODEX.
5. Execute workspace/app work through CREATIO + CORPUS.
6. Validate through MATHESIS + TEST/BENC.
7. Package through PORT.
8. Govern through SACE/LAWX.
9. Brief through VOX.

## Release promotion loop

1. Confirm release package exists under `docs/releases/`.
2. Confirm model cards and wiki pages are complete.
3. Confirm tests/receipts are present or note missing evidence.
4. Confirm no secrets.
5. Open or update release PR.
6. After merge, create GitHub tag/release from the release package.
7. Mark release status as promoted.

## Incident loop

When a model output is wrong or unsafe:

1. Preserve the bad output and context.
2. Identify owner model.
3. Classify failure: routing, memory, code, proof, governance, or expression.
4. Add test or release note correction.
5. Patch documentation/runtime.
6. Emit a correction receipt.

## Operator commands

- `Build it` -> CODEX/CREATIO with PR or workspace package.
- `Make it commercial grade` -> MATHESIS/SACE/PORT readiness upgrade.
- `Release it` -> PORT release package, tag/release promotion after merge.
- `Explain how it works` -> VOX with state-preserving explanation.