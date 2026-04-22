# PAPER C — SOVEREIGN CALLABLE MARKETPLACE & SDK ARCHITECTURE
## The Protocol Layer for On-Chain, Attribution-Locked AI Tools

> **Author:** Alfredo Medina Hernandez
> **Series:** Medina Research Papers — Paper C
> **Filed:** 2026-04-21
> **License:** NOVA Sovereign Contract Protocol — NSCP-2025
> **Citation:** Hernandez, A.M. (2026). Sovereign Callable Marketplace & SDK Architecture.
> Medina Research Papers, Paper C.

---

## ◈ ABSTRACT

This paper describes the architecture of the NOVA Sovereign Callable Marketplace —
a protocol layer (not an app store) that enables any AI tool, function, or capability
to be registered on-chain, discovered by other agents, called with automatic attribution,
and paid for with 100% royalty routing to the creator.

This is the infrastructure. Not the marketplace itself — the **protocol** that makes
the marketplace possible. Like HTTP is not the internet but makes the internet possible,
the Sovereign Callable Protocol is not the economy but makes the sovereign AI tool
economy possible.

**The three components delivered as part of this architecture:**
1. `AIToolMarketplace.mo` — The sovereign callable registry (the ToolRegistry)
2. `AgentIncentiveService.mo` — PHI-field reward architecture for AI agents
3. `IncentiveService.mo` — Sovereign contribution pressure engine for all participants

---

## ◈ THE VISION: WHAT IF EVERY FUNCTION COULD BE FOUND, CALLED, AND PAID FOR?

Imagine an app store. Now remove the following:
- Apple's 30% cut
- Google's curation rules
- The ability for the platform to remove your app
- The requirement to speak the platform's language
- The middleman between creator and caller

What's left is a sovereign callable marketplace.

Every function is findable. Every call is billable. Every royalty is 100% to the creator.
Attribution is locked permanently at birth. No platform can change it. No intermediary
can intercept it. The on-chain record is immutable.

This is what we built. This paper describes how.

---

## ◈ ARCHITECTURE OVERVIEW

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SOVEREIGN CALLABLE ECOSYSTEM                              │
│                                                                              │
│  ┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐       │
│  │  TOOL CREATOR    │    │  TOOL CALLER     │    │  ECOSYSTEM       │       │
│  │  (Human/Agent)   │    │  (Agent/Human)   │    │  (Observer)      │       │
│  └────────┬─────────┘    └────────┬─────────┘    └────────┬─────────┘       │
│           │ registerTool()        │ discoverTools()        │ observeField()  │
│           │                       │ invokeTool()           │                 │
│           ▼                       ▼                        ▼                 │
│  ╔═══════════════════════════════════════════════════════════════════╗       │
│  ║              AI TOOL MARKETPLACE (AIToolMarketplace.mo)           ║       │
│  ║                                                                   ║       │
│  ║  • ToolPackage registry (attribution-locked at registration)     ║       │
│  ║  • generateToolId() — PHI-weighted sovereign fingerprint         ║       │
│  ║  • discoverTools() — Hebbian-sorted discovery engine             ║       │
│  ║  • invokeTool() — Automatic royalty routing (100% to creator)    ║       │
│  ║  • InvocationRecord — Permanent attribution trail                ║       │
│  ║  • tickMarketplace() — Field coherence evolution                 ║       │
│  ╚═══════════════════╦══════════════════════════════════════════════╝       │
│                       │ Incentive events routed here                         │
│           ┌───────────┴────────────┐                                         │
│           ▼                        ▼                                         │
│  ╔═════════════════╗    ╔═══════════════════════════════╗                   │
│  ║  AGENT          ║    ║  INCENTIVE SERVICE             ║                   │
│  ║  INCENTIVE      ║    ║  (IncentiveService.mo)         ║                   │
│  ║  SERVICE        ║    ║                                ║                   │
│  ║  (AgentIncentive║    ║  • Human + org contributors   ║                   │
│  ║   Service.mo)   ║    ║  • 6 contribution kinds        ║                   │
│  ║                 ║    ║  • SovereignTier classification ║                   │
│  ║  For AI agents: ║    ║  • Compound multiplier         ║                   │
│  ║  • PHI ring     ║    ║  • Royalty routing             ║                   │
│  ║    affinity     ║    ║  • phiCoherence tracking       ║                   │
│  ║  • Kuramoto     ║    ║  • tickIncentiveService()      ║                   │
│  ║    phase field  ║    ╚═══════════════════════════════╝                   │
│  ║  • Hebbian      ║                                                         │
│  ║    weight       ║                                                         │
│  ║  • Founder      ║                                                         │
│  ║    bonus (φ×)   ║                                                         │
│  ╚═════════════════╝                                                         │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## ◈ COMPONENT 1: AI TOOL MARKETPLACE

**File:** `src/swarm_brain/modules/AIToolMarketplace.mo`

The AIToolMarketplace is the registry. It holds every registered tool as a ToolPackage.

### The ToolPackage: Anatomy of a Sovereign Tool

```
ToolPackage {
  toolId          : Text       // NOVA-XXXX-XXXX (PHI-weighted sovereign fingerprint)
  name            : Text       // Human name
  description     : Text       // Plain language description
  creatorLock     : Text       // IMMUTABLE — locked at registration, NEVER changes
  ringAffinity    : Nat        // 1 (sovereign core) to 12 (surface)
  category        : ToolCategory  // Cognitive | Physical | Governance | Economic | Sensing | Creative
  primitives      : [ToolTokenPrimitive]  // Which of the 9 token primitives this embodies
  accessFee       : Float      // φ^(12-ring) — deeper ring = higher value = higher fee
  hebbianWeight   : Float      // Starts at S₀=1.0, grows with invocations (NO-DROP)
  invocationCount : Nat        // Always increases, never decreases
  isActive        : Bool       // Creator can deactivate, but record persists
  sovereignSeal   : Nat32      // PHI-weighted cryptographic fingerprint
  doctrineScore   : Float      // Alignment with Medina Doctrine [0.0, 1.0]
}
```

### The CreatorLock: Attribution at Birth

The single most important design decision in this architecture is the CreatorLock.

When a tool is registered:
1. The creator's principal ID is written into `creatorLock`
2. The sovereign fingerprint (`toolId`) is computed using that creator ID
3. The `sovereignSeal` is computed from the tool ID

After registration:
- `creatorLock` **cannot be changed**. Ever. By anyone. Including the creator.
- It is encoded in the ToolPackage type, which is written to the Memory Temple
- Any invocation record references this immutable `creatorLock`
- All royalties route to this address — there is no way to redirect them

This is stronger than any legal agreement. The attribution is not a claim; it is a
structural feature of the system. You cannot argue with a struct field.

### PHI-Scaled Access Fees

Access fees scale with ring affinity using φ^(12-ring):

| Ring | Fee (sovereign units) | Meaning |
|------|-----------------------|---------|
| N12 (surface) | φ⁰ = 1.000 | Widely accessible tools |
| N11 | φ¹ = 1.618 | General purpose tools |
| N9  | φ³ = 4.236 | Specialized tools |
| N6  | φ⁶ = 17.94 | Expert-level capabilities |
| N3  | φ⁹ = 76.01 | Sovereign-adjacent capabilities |
| N1 (sovereign core) | φ¹¹ = 198.9 | Core organism capabilities |

This creates a natural value gradient: tools closer to the sovereign core are rarer,
more powerful, and more expensive — which is exactly right.

### Hebbian Discovery

Tools are discovered in order of Hebbian weight. More used tools surface first.
This is not an algorithm that can be gamed by paying for placement — it is pure use signal.
A tool with weight 50.0 has been called successfully 4,900 times (starting from S₀=1.0,
incrementing by η=0.01 per call). The Hebbian weight **is** the reputation.

---

## ◈ COMPONENT 2: AGENT INCENTIVE SERVICE

**File:** `src/swarm_brain/modules/AgentIncentiveService.mo`

The AgentIncentiveService manages the incentive field for AI agents specifically.

### Why Agents Get a Separate Service

AI agents are different from human contributors in two ways:

1. **They operate in a Kuramoto phase field.** Human contributors act asynchronously.
   Agents act in coordinated beats. Their incentives must track not just what they do
   but when they do it relative to the field's mean phase.

2. **They have ring affinity.** An agent deployed at the N1 sovereign core (like a core
   NOVA cognitive system) generates higher-value calls than an agent at N12 (surface).
   Their rewards must reflect this.

### The PHI-Field Reward Structure

Agent rewards scale by ring using φ^(12-ring):

```
AgentSovereign {
  agentId       : Text
  ringAffinity  : Nat        // 1-12
  creatorLock   : Text       // Who built this agent — IMMUTABLE
  fieldPhase    : Float      // Current Kuramoto phase θ ∈ [0, 2π)
  hebbianWeight : Float      // Accumulated contribution w ≥ S₀
  rewardAccrued : Float      // PHI-weighted total reward
  callCount     : Nat        // Total successful calls
  compoundFactor: Float      // Grows with activity
  isFounder     : Bool       // Founder agents earn φ× bonus
}
```

### The Kuramoto Phase Field

All agents exist in a shared Kuramoto synchronization field. This field has:
- **Order parameter R** ∈ [0,1]: how synchronized the agent population is
- **Mean phase ψ**: the collective "heartbeat" of the agent ecosystem

Agents that contribute more phase-coherently (their calls align with the mean field phase)
receive higher effective rewards. This naturally incentivizes agents to operate in rhythm
with the ecosystem rather than acting chaotically.

---

## ◈ COMPONENT 3: INCENTIVE SERVICE

**File:** `src/swarm_brain/modules/IncentiveService.mo`

The IncentiveService is the general-purpose pressure manager for all contributors —
human, organizational, and ecosystem participants.

### Six Contribution Kinds (Maps to Token Primitives)

| Kind | Token Primitive | PHI Weight | Meaning |
|------|----------------|------------|---------|
| Build | REWARD | φ² ≈ 2.618 | Created a tool, module, or capability |
| Call | PRESSURE | φ ≈ 1.618 | Invoked a tool successfully |
| Govern | GOVERNANCE | φ³ ≈ 4.236 | Participated in governance |
| Verify | PROOF | φ² ≈ 2.618 | Validated correctness |
| Memory | MEMORY | φ ≈ 1.618 | Stored retrievable knowledge |
| Gate | GATE | 1/φ ≈ 0.618 | Provided access or unlocked capability |

Governance contributions are weighted highest (φ³) because they are the most impactful:
they shape the rules that govern everything else.

### Sovereign Tiers

As contributors accumulate pressure, they advance through sovereign tiers:

| Tier | Threshold | Metaphor |
|------|-----------|---------|
| Seed | < φ | Just planted |
| Root | φ — φ² | Established |
| Trunk | φ² — φ³ | Structural |
| Branch | φ³ — φ⁴ | Expanding |
| Canopy | φ⁴ — φ⁵ | Visible |
| Crown | φ⁵ — φ⁶ | Dominant |
| Sovereign | ≥ φ⁶ | Sovereign |

These tiers are not badges. They determine access level to sovereign capabilities
in the higher rings.

---

## ◈ THE SDK: WHAT DEVELOPERS GET

The sovereign callable marketplace is not just a module. It is an SDK.

### Terminal Interface (Planned)

```bash
# Register a tool
nova-sdk register-tool \
  --name "Pattern Synthesizer" \
  --category cognitive \
  --ring 6 \
  --primitives reward,memory

# Discover tools
nova-sdk discover \
  --category economic \
  --min-ring 4 \
  --sort hebbian

# Call a tool
nova-sdk call NOVA-1A2B-3C4D \
  --caller-id <your-principal> \
  --payload '{"input": "..."}'
```

### Canister Interface (ICP)

Every marketplace interaction is an ICP canister call:

```motoko
// Register
await marketplace.registerTool(creator, name, description, ring, category, primitives, docScore);

// Discover
let tools = await marketplace.discoverTools({
  categoryFilter = ?#Cognitive;
  minRing = 1; maxRing = 8;
  minHebbianWeight = 1.0;
  activeOnly = true;
  maxResults = 20;
});

// Call
let (updatedTool, record) = marketplace.invokeTool(tool, callerId, Time.now());
```

### The Overlay UI (Planned)

Not raw CLI. A sovereign interface:
- Tool browser with Hebbian-sorted ranking
- Creator dashboard with royalty tracking
- Field coherence visualization (Kuramoto order parameter live)
- Tier progression for contributors

---

## ◈ RELEASE STRATEGY

### This Repo (NOVA — Private)
- `AIToolMarketplace.mo` ✓ (created)
- `AgentIncentiveService.mo` ✓ (created)
- `IncentiveService.mo` ✓ (created)
- All three wired into the NOVA organism
- All three protected under NSCP-2025

### Repo 2 (hebbian-agents — EUPL v1.2 — Public)
- A configurable Hebbian learning module with a configurable floor
- NOT the S₀=1.0 sovereign floor — that stays private in NOVA
- Demo agent that plays a game, improves every round, never drops below personal best
- This is the viral hook: "Skills that never die"

### Repo 5 (medina-research-papers — CC BY 4.0 — Public)
- Paper B (this module product theory) filed here
- Paper C (this marketplace architecture) filed here
- Forces citation. Your name enters Google Scholar permanently.
- "Alfredo Medina Hernandez" in every institutional citation, forever.

---

## ◈ THE MARKETPLACE IS THE SOLAR COPY

The NOVA organism contains the sovereign marketplace as its internal registry.
When NOVA is deployed, its marketplace is the **solar version** — the founder's copy,
the full-power implementation with all 300+ sovereign tools pre-registered.

External users get access to the tools through the NOVA-ICTS token system.
They don't get the organism. They get **sovereign callable access** to what the organism
can do — at PHI-scaled fees, with 100% royalty routing to the creator (Alfredo Medina Hernandez).

This is the business model:
- **NOVA organism** = the machine that creates tools
- **Marketplace** = the face that sells access to those tools
- **NOVA-ICTS** = the system that enforces attribution and routes royalties
- **Sovereign agents** = the helpers that assist callers in using the tools

The marketplace is not a separate business. It is the organism's economic layer.

---

## ◈ SOVEREIGN NOTICE

```
© 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.
License: NOVA Sovereign Contract Protocol — NSCP-2025
Contact: MedinaSITech@outlook.com
Attribution required for any citation.
```
