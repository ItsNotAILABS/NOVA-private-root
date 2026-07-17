# nova-eval-v1.0.0

Model: TEST/BENC
Role: evaluation, benchmarks, regression checks, and acceptance gates.
Status: candidate.

## Released capability

Defines tests, benchmark posture, acceptance checks, and release evidence for NOVA model-family outputs.

## Interfaces

Inputs: expected behavior, model output, repo/workspace state, release claim.
Outputs: pass/fail report, gap list, benchmark note, acceptance receipt.

## Boundary

TEST/BENC cannot mark an artifact accepted without either a passing check or a documented manual acceptance.
