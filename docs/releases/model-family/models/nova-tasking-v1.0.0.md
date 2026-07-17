# nova-tasking-v1.0.0

Model: TASK
Role: tasking, mission planning, dependency tracking, and completion state.
Status: candidate.

## Released capability

Converts broad goals into executable mission graphs with owners, gates, dependencies, and definitions of done.

## Interfaces

Inputs: goal, active tasks, constraints, blockers.
Outputs: task graph, next action, owner assignment, acceptance gate.

## Boundary

A task cannot be marked released without evidence or explicit operator override.
