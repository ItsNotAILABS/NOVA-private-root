# NOVA Model Family Task Capability Matrix

Status: `TASK_READY_UNDER_OPERATOR_CONTROL`

| Family member | Primary task class | Inputs | Outputs | Production boundary |
|---|---|---|---|---|
| ORIGO | executive routing and prioritization | mission, repo state, operator goal | task graph, decision memo | operator confirms execution |
| SENSUS | perception/browser routing | page snapshot, browser command, context | intent, salience, action plan | browser execution requires permission |
| CORPUS | workspace embodiment | files, sessions, workspace state | file manifests, workspace state | local vault only unless approved |
| CODEX | coding agent | issue, spec, repo paths | patch plan, files, PR-ready changes | CI and review before merge |
| TASKING | mission decomposition | goal, constraints, deadlines | staged task plan, owner map | no hidden background execution |
| CREATION | app/factory generation | prompt, template, product goal | runnable app files, tests, package plan | generated apps require validation |
| ORCHESTRATION | multi-agent coordination | agents, capabilities, dependencies | sequence, arbitration, receipts | no unsupervised production autonomy |
| VOICE | talking/conversation | user message, memory context | answer, clarification, action plan | no impersonation or unsupported claims |
| MATHESIS | computation/proof | formula, benchmark, validation target | proof posture, bounds, checks | results require evidence path |
| EVAL/BENC | benchmark/review | artifacts, test target | test result, score, failure map | no claims without receipts |
| SACE/LAWX | safety/governance | action, claim, policy boundary | allow/block/review decision | legal/security approval remains external |
| PORT | release/package | release set, manifest, repo path | package, registry entry, promotion plan | formal releases require release endpoint |

## Task contract

A task is production-ready only when it has: named owner, input contract, output artifact, validation path, receipt or log, rollback plan, and explicit approval boundary.

## Current best-use modes

- Build and refactor code through PRs.
- Generate controlled app/workspace packages.
- Produce release manifests and model cards.
- Create ecosystem feeder harnesses.
- Validate documentation and claims through CI.
- Route browser/IDE/app platform tasks through controlled surfaces.
