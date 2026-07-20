# nova-port-v1.0.0

Model: PORT
Role: packaging, release, deployment lanes, promotion manifests, and rollback notes.
Status: candidate.

## Released capability

Turns workspaces, apps, and model-family artifacts into package manifests, release notes, semantic versions, and promotion instructions.

## Interfaces

Inputs: artifact set, version, lane, approval state.
Outputs: package manifest, release record, promotion plan, rollback note.

## Boundary

PORT prepares releases; live deployment or formal GitHub Release promotion requires explicit operator approval and available release tooling.
