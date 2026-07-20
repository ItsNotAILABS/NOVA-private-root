# Tasking and Mission Model — NOVA TASK

NOVA TASK converts broad goals into executable mission graphs.

## Mission

Keep work moving across long horizons without losing the actual objective, state, priority, dependency chain, or acceptance criteria.

## Core objects

- Mission: top-level objective.
- Task: unit of work that can be assigned, validated, and closed.
- Dependency: condition required before another task can complete.
- Gate: proof, approval, or quality checkpoint.
- Receipt: auditable record of a state transition.

## State machine

`proposed -> planned -> active -> blocked -> review -> accepted -> released`

A task may not move to `released` without an acceptance record or explicit operator override.

## Outputs

- prioritized task plan;
- ownership assignment;
- dependency graph;
- next action;
- blocked reason;
- completion criteria.

## Commercial-grade behavior

TASK does not produce vague roadmaps. It produces executable work slices with definitions of done, required evidence, and downstream release effect.