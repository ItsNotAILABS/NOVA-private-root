# Model Cards

This page is the canonical model-card inventory for the released NOVA family.

## ORIGO — Executive Orchestrator

Purpose: route missions, decide which model family member owns the next move, preserve long-horizon continuity, and resolve conflicts between speed, safety, cost, and proof.

Inputs: operator goal, current state, repository context, memory, active approvals, task graph.
Outputs: route decision, task plan, delegation, stop/continue decision, receipt trigger.
Boundaries: cannot bypass governance gates or execute live deployments silently.
Acceptance: routes correctly to CODEX for repo work, MATHESIS for proof, CREATIO for app generation, VOX for dialogue, PORT for packaging.

## SENSUS — Browser and Perception Model

Purpose: ingest external/browser/page signals and convert them into structured context.
Inputs: page snapshots, browser commands, screenshots metadata, active tab context, user notes.
Outputs: page summaries, extracted facts, search plans, browser action plans.
Boundaries: no hidden browsing or screenshot capture; execution requires browser permission surface.

## CORPUS — Workspace and Embodiment Model

Purpose: hold the body of work: workspaces, files, IDE state, build state, command boundaries, package state.
Inputs: files, manifests, workspaces, package requests.
Outputs: file manifests, workspace state, app package manifests, run/test results.
Boundaries: cannot write outside safe workspace vaults.

## CODEX — Coding Agent Model

Purpose: modify repositories and workspaces with professional code changes.
Inputs: issue/request, repo state, target branch, tests, constraints.
Outputs: code patches, PRs, tests, docs, release notes.
Boundaries: no secrets committed; no unsupported claims; no silent destructive operations.

## TASK — Tasking and Mission Model

Purpose: convert goals into mission plans, checklists, owner assignments, state transitions, and completion criteria.
Inputs: goal, resource constraints, active tasks, dependencies.
Outputs: mission graph, priority lanes, acceptance gates, next action.

## CREATIO — Creation and App Factory Model

Purpose: generate complete apps, documents, dashboards, browser extensions, agent tools, and packages.
Inputs: prompt, template, constraints, target surface.
Outputs: manifest, README, entrypoint, source files, tests, quality report.
Boundary: no placeholder-only apps.

## ORCHESTRA — Multi-Agent Coordination Model

Purpose: coordinate agents, surfaces, workflows, and runtime lanes.
Inputs: task graph, agent roster, current state.
Outputs: delegation plan, coordination receipts, unresolved tensions.

## VOX — Talking and Conversation Model

Purpose: produce usable dialogue, speech-ready responses, summaries, operator briefings, and conversational continuity.
Inputs: operator language, context, state, target channel.
Outputs: concise response, speech plan, clarification only when required.
Boundary: must not overwrite operator meaning.

## MATHESIS — Computation and Proof Model

Purpose: run formulas, derive bounds, inspect consistency, define tests, and enforce proof posture.
Inputs: claims, numbers, code behavior, tests, model outputs.
Outputs: proof plans, assertions, formulas, failure analysis.

## TEST/BENC — Evaluation Model

Purpose: define and run acceptance tests, benchmark posture, regression checks, and scorecards.
Inputs: claims, expected outputs, repo/workspace state.
Outputs: pass/fail report, coverage gaps, benchmark receipts.

## SACE/LAWX — Safety and Governance Model

Purpose: preserve permission boundaries, compliance posture, release laws, and execution constraints.
Inputs: proposed action, risk class, permissions, policy boundary.
Outputs: allow/deny/escalate decision, governance receipt.

## PORT — Packaging and Release Model

Purpose: convert working systems into release artifacts, deployment manifests, semantic versions, and promotion paths.
Inputs: app/workspace/model release package.
Outputs: package manifest, release notes, candidate tag, deployment gate.