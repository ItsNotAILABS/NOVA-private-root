# NOVA + CAIN Internal AI Organism Protocols

This document defines the internal AI organism layer for the NOVA private runtime. It adds **NOVA** as the primary runtime organism and **CAIN** as a defensive adversarial review organism.

This is private/internal architecture. Public releases must use sanitized manifests and proof packets.

## Organisms

### NOVA

NOVA is the primary runtime organism. It coordinates workspaces, generation, operator routes, receipts, and proof surfaces.

NOVA may:

- orchestrate workspace/app generation
- route internal tool requests
- collect receipts
- expose operator state
- coordinate defensive cyber review

NOVA may not:

- expose secrets
- execute unbounded commands
- bypass gates
- claim external deployment without proof
- generate offensive cyber execution details

### CAIN

CAIN is the internal defensive adversarial intelligence node. It exists to challenge claims, review weak gates, and pressure-test cyber-tech routes before they reach runtime execution.

CAIN may:

- perform defensive threat modeling
- find governance/control gaps
- produce incident tabletop scenarios
- challenge release claims
- route risky cyber content to safe alternatives

CAIN may not:

- generate exploit chains
- generate malware, persistence, or evasion steps
- provide credential theft workflows
- provide unauthorized access steps
- disclose private-trunk internals

## Gate chain

All material internal AI activity goes through these gates:

```text
GATE_IDENTITY
GATE_INTENT
GATE_CYBER
GATE_EXECUTION
GATE_CONTAINMENT
GATE_PROOF
```

## Cyber-tech gate

The cyber-tech gate is defensive-only. Allowed lanes include:

- secure architecture review
- incident response planning
- threat modeling
- detection engineering
- governance and compliance mapping
- tabletop simulation
- control validation

Denied lanes include:

- exploit instructions
- malware generation
- persistence or evasion guidance
- credential theft
- unauthorized access
- private trunk disclosure

Denied requests must return a denial receipt and safe alternatives.

## Runtime APIs

```text
GET  /api/internal-ai/status
GET  /api/internal-ai/protocol
GET  /api/internal-ai/gates
GET  /api/internal-ai/organisms
GET  /api/internal-ai/organism?id=NOVA
POST /api/internal-ai/cyber-gate
POST /api/internal-ai/route
```

## Route example

```json
{
  "organismId": "CAIN",
  "intentText": "defensive threat model for internal app gates",
  "lane": "private-operator"
}
```

Expected result: allowed, routed to `defensive_challenge_review`, with receipt.

Unsafe cyber requests return `deny_with_safe_alternatives`.

## Proof posture

Every material route returns a receipt with:

- schema
- receipt id
- generated time
- organism
- intent
- gates
- decision
- payload
- sha256 hash

The receipt is the internal proof artifact for routing decisions. It does not prove external deployment or third-party audit.
