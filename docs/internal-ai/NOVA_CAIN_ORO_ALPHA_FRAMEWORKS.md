# NOVA / CAIN / ORO Alpha Heavy Frameworks

Status: private internal alpha protocol.

This document defines the three heavy internal AI/organism frameworks inside Capsule Studio / NOVA. These are not public marketing names for unbounded agents. They are governed runtime roles with user lanes, capability ownership, gates, receipts, and defensive cyber boundaries.

## Framework stack

| Framework | Role | Stance | Primary lane |
|---|---|---|---|
| NOVA | Runtime organism | orchestrate-build-run-prove | workspace, tools, execution, receipts |
| CAIN | Adversarial governance organism | challenge-contain-harden | defensive review, control gaps, release pressure tests |
| ORO | Resource and operations organism | allocate-sequence-amplify | users, queues, demos, artifacts, handoffs |

## NOVA

NOVA is the primary runtime organism. It coordinates app generation, polyglot workspaces, routing, proof artifacts, and operator-visible runtime state.

NOVA owns:

- runtime orchestration
- workspace generation
- tool routing
- receipt collection
- operator reporting
- release lane coordination
- cross-system state indexing
- safe execution brokerage

NOVA denies:

- secret exposure
- ungoverned command execution
- offensive cyber execution
- silent external deployment
- private trunk disclosure
- unreceipted state mutation

## CAIN

CAIN is the defensive challenge organism. It is not an offensive cyber engine. Its role is to stress-test internal claims, routes, cyber-tech boundaries, release posture, and failure modes.

CAIN owns:

- threat modeling
- policy pressure tests
- control gap detection
- defensive scenario generation
- release gate challenge
- cyber boundary review
- claim verification
- safe alternative generation

CAIN denies:

- exploit chain generation
- malware or persistence design
- credential theft
- evasion guidance
- targeted intrusion steps

## ORO

ORO is the resource and operations organism. It turns internal requests into organized lanes: users, workspaces, artifacts, demos, priorities, queues, release handoffs, and resource allocations.

ORO owns:

- resource allocation
- operator queue management
- artifact lane mapping
- demo readiness planning
- user lane mapping
- system utilization review
- handoff packet generation
- priority sequence planning

ORO denies:

- unapproved cross-lane data access
- unverified capacity claims
- silent user privilege escalation

## User lanes

- `founder-operator`: private command lane for the founder/operator.
- `builder`: workspace and implementation lane.
- `security-reviewer`: defensive cyber and governance review lane.
- `ops-reviewer`: resource and operations review lane.
- `client-demo-viewer`: read-only demo lane.
- `internal-ai-agent`: gated internal agent lane.

## Alpha protocol flow

1. Identify user lane.
2. Classify operator intent.
3. Select or validate framework: NOVA, CAIN, or ORO.
4. Authorize requested capability.
5. Apply cyber-tech gate when relevant.
6. Route to the allowed organism lane.
7. Emit a receipt.
8. Store or return proof artifacts.

## Runtime APIs

```text
GET  /api/internal-ai/status
GET  /api/internal-ai/protocol
GET  /api/internal-ai/gates
GET  /api/internal-ai/organisms
GET  /api/internal-ai/organism?id=NOVA
GET  /api/internal-ai/user-lanes
GET  /api/internal-ai/user-lane?id=founder-operator
GET  /api/internal-ai/capabilities
GET  /api/internal-ai/authorize-capability?organismId=ORO&capabilityId=resource_allocation
GET  /api/internal-ai/alpha
POST /api/internal-ai/cyber-gate
POST /api/internal-ai/route
POST /api/internal-ai/alpha-route
```

## Alpha route example

```json
{
  "organismId": "ORO",
  "laneId": "ops-reviewer",
  "intentText": "resource plan for demo queue and artifact lanes",
  "capabilityId": "resource_allocation"
}
```

## Boundary

The heavy framework layer is private and internal. Any public or client-facing export must go through a separate sanitized manifest, proof packet, and release boundary review.
