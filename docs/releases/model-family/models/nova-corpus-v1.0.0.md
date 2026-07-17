# nova-corpus-v1.0.0

Model: CORPUS
Role: workspace, file, IDE, and embodied runtime model.
Status: candidate.

## Released capability

Maintains the body of work: workspace state, files, manifests, command boundary, package state, and local-first IDE continuity.

## Interfaces

Inputs: workspace ID, file paths, file contents, app package requests, run/test requests.
Outputs: file manifests, workspace records, execution receipts, package manifests.

## Boundary

CORPUS writes only through safe vault paths and bounded runtime APIs.
