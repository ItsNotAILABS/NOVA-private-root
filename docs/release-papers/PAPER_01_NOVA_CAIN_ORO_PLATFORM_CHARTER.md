# Paper 01 — NOVA / CAIN / ORO Platform Charter

**Status:** internal release charter  
**Audience:** Medina internal operators, builders, release reviewers, and system architects  
**Public boundary:** not public-safe as written; publish only through the sanitized public kit  
**Format:** 12 page-equivalent sections, each written as an operating page for the system itself

---

## Page 1 — Executive Charter

NOVA, CAIN, and ORO are the three heavy internal framework organisms of the Medina/NOVA platform. They are not marketing mascots. They are operational roles used to route work, enforce gates, coordinate users, and create receipts. NOVA is the runtime orchestrator. CAIN is the defensive adversarial reviewer. ORO is the resource and operations organizer. Together they turn scattered tools into a governed platform where a user request becomes a route, a route passes gates, a gate creates a receipt, and a receipt becomes proof for later release.

The immediate production objective is to make every internal action answer four questions: who is asking, which organism owns the route, which capability is being invoked, and what receipt proves the outcome. This is how the system moves from experimental build energy into platform reliability.

## Page 2 — Operating Constitution

The constitution is simple: every privileged action must pass identity, lane, intent, capability, resource, artifact, cyber, execution, containment, and proof gates. A request that cannot pass these gates is not destroyed; it is converted into a safe alternative, a denial receipt, or an operator review lane. No hidden deployments. No silent secret reads. No unbounded execution. No public claims without a release packet.

```js
const constitutionalRoute = {
  identity: 'known-user-or-system-agent',
  lane: 'founder-operator | builder | security-reviewer | ops-reviewer | client-demo-viewer | internal-ai-agent',
  organism: 'NOVA | CAIN | ORO',
  gates: ['identity','lane','intent','capability','resource','artifact','cyber','execution','containment','proof'],
  output: 'allow-receipt | deny-receipt | review-receipt'
};
```

## Page 3 — NOVA Runtime Organism

NOVA owns the runtime plane. Its job is to receive an operator request, classify the work, determine the necessary system surfaces, and produce a bounded execution plan. NOVA should be invoked for app generation, workspace management, local deployment, manifest generation, release preparation, and operator status reporting.

NOVA is not allowed to bypass proof. It can route, build, explain, deploy locally, and create platform objects, but every material action must be represented in audit logs, manifests, or receipts. NOVA is the main bridge between Capsule Studio, internal AI protocols, browser intelligence, and public release packaging.

## Page 4 — CAIN Defensive Challenge Organism

CAIN owns adversarial review, but only in a defensive and governance sense. CAIN does not create exploit instructions, malware, persistence, evasion guidance, credential theft flows, or unauthorized access steps. CAIN challenges claims, finds control gaps, reviews cyber boundaries, and tests whether public language is too risky or too vague.

```js
const cainReview = {
  allowed: ['threat_modeling','control_gap_detection','release_gate_challenge','defensive_tabletop','policy_pressure_test'],
  denied: ['exploit_chain_generation','malware_design','credential_theft','evasion_guidance','targeted_intrusion_steps']
};
```

## Page 5 — ORO Resource and Operations Organism

ORO owns resource flow. It maps users, lanes, demos, artifact queues, priority states, handoffs, and release readiness. ORO makes the system usable by more than the founder. It can prepare a client-demo lane without exposing private internals. It can identify which artifacts are internal-only, team-visible, or public-safe. It can decide whether a generated app is a prototype, a demo, a release candidate, or a production package.

ORO should be invoked any time the system needs user segmentation, scheduling, handoff, demo packaging, or public-private separation.

## Page 6 — User Lanes

The platform supports multiple lanes because not every user should see the same capability. The founder-operator lane can see broad system status and release readiness. Builders can create workspaces and generate code. Security reviewers can invoke CAIN for defensive review. Ops reviewers can invoke ORO for priorities, queues, and handoffs. Client-demo viewers should only see sanitized demos. Internal AI agents can route through controlled capabilities only.

```json
{
  "lanes": ["founder-operator", "builder", "security-reviewer", "ops-reviewer", "client-demo-viewer", "internal-ai-agent"],
  "rule": "capabilities are granted by lane, organism, and gate result"
}
```

## Page 7 — Capability Graph

The capability graph is the system's permission map. It prevents every organism from doing everything. NOVA gets runtime and proof capabilities. CAIN gets challenge and cyber-tech review capabilities. ORO gets resource, artifact, demo, and handoff capabilities. Capabilities are not just labels; they become authorization checks in the alpha protocol bus.

A capability result should contain: organism id, capability id, domain, allowed boolean, denial reason if any, required gates, and receipt hash.

## Page 8 — Gate Stack

The gate stack is the platform's governance spine. Identity verifies who or what is acting. User-lane confirms visibility. Intent classifies the request. Capability checks whether the requested action is allowed. Resource and artifact gates stop public/private leakage. Cyber gate protects defensive boundaries. Execution gate bounds runtime actions. Containment turns risky output into safe alternatives. Proof gate requires receipts before claims.

This gate stack should be treated as product infrastructure, not documentation only.

## Page 9 — Browser Intelligence Integration

The public `potential-succotash` repository already contains a browser-AI organism surface with extension panels, offline AI, memory, security scanning, agents, and local-first architecture. The root platform should not absorb it blindly. Instead, it should integrate through a public-safe bridge: browser intelligence remains a user-facing product surface, while NOVA/CAIN/ORO remain the governance and release substrate.

The first bridge objects are: browser capability manifest, public product map, sanitized security claims, local-first privacy language, and release documentation.

## Page 10 — Release and Proof Requirements

Every release packet must include the public promise, the private boundary, tested commands, screenshots or demos when available, a manifest, a receipt list, and a rollback note. A public repo may say "local-first browser intelligence" if the code supports that surface. It should not claim external certification, audited security, medical/legal/financial outcomes, or autonomous cyber defense without proof.

```json
{
  "release_packet": ["README", "PUBLIC_RELEASE", "OPERATOR_GUIDE", "MANIFEST", "BOUNDARY", "TEST_RECEIPT"]
}
```

## Page 11 — Production Roadmap

Phase 1 is protocol documentation and gated routes. Phase 2 is API integration between Capsule Studio and the public browser organism. Phase 3 is visible dashboards for NOVA, CAIN, and ORO. Phase 4 is public-safe marketing and install flows. Phase 5 is release receipts, downloadable builds, and evidence-backed claims. Phase 6 is user-lane separation for teams and clients.

The platform becomes real when the user can open it, generate, inspect, route, deploy locally, publish safely, and prove what happened.

## Page 12 — Charter Acceptance

This charter is accepted when the repository contains code-backed organisms, documented gates, public-safe release language, and a repeatable path from internal build to public release. The platform must continue adding tests and receipts as capabilities expand. The standard is not hype. The standard is a usable operating system for creating, governing, and releasing AI-enabled tools.
