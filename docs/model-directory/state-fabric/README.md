# State Fabric Models

Classification: `RUNTIME_RESTRICTED`

Purpose:
- define shared runtime organism state structures,
- preserve coherence/drift/continuity semantics across teams,
- and prevent local state payload fragmentation.

Primary owner: `core-a-runtime`

Consumers:
- core-a-runtime
- intrinsic-labs
- core-b-governance (read-only snapshots)

Gates touched:
- GATE-A
- GATE-B

One-line law:
State fabric models carry organism truth state, not projection state.
