# Training and Evaluation Boundary

Status: `MODEL_FAMILY_CONTRACT_READY`

The NOVA model family release is a production harness for model roles, operating contracts, task routing, validation, and release governance. It is not a claim that new base-model weights have been trained inside this repository.

## What trained means in this release

For this release, trained means the family has stable operating roles, model cards, routing contracts, task capability maps, governance boundaries, and repeatable validation expectations. It does not mean that a neural checkpoint is included in this repo.

## Evidence required for future stronger claims

A future `TRAINED_CHECKPOINT_RELEASE` must add:

- dataset card;
- training configuration;
- model checkpoint pointer or artifact hash;
- benchmark harness;
- benchmark reports;
- red-team report;
- eval receipts;
- safety review;
- license and distribution terms;
- reproducibility notes.

## Current evidence

- Repo-backed wiki.
- Model release cards.
- Task capability matrix.
- Production readiness report.
- Release manifest.
- CI validator.
- Existing NOVA platform work for IDE/App Factory/Browser AI and release packaging.

## Evaluation modes

- Contract validation: required files, manifest fields, model lists, banned-claim scan.
- Task capability review: each family member has task class, input, output, and boundary.
- Release governance review: approvals are explicit and promotion is gated.
- Ecosystem review: feeder repos are tracked as production harness targets.

## Non-claims

This release does not claim hidden dataset training, independent consciousness, unsupervised production autonomy, financial performance, regulated authority, or live deployment readiness without operator approval.
