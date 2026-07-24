# Alpha Showcase Asset Specification

## Objective

Produce a technical showcase that proves the system through reproducible assets. The showcase must make the architecture understandable in five minutes and auditable in depth.

## Required asset families

### 1. Portfolio map

Create one top-level diagram showing:

- intelligence runtimes
- memory systems
- MCP and connector surfaces
- phone and operator interfaces
- deployment systems
- security and receipt boundaries
- financial and on-chain systems

Source format: Mermaid or D2 committed to the repository.

Exports:

- SVG for README and website
- PNG for social and presentations
- dark and light variants

### 2. Golden Alpha Path sequence

Show the actual runtime sequence:

```text
PhoneAI
  -> authenticated MCP session
  -> tool discovery
  -> signed intent
  -> NOVA policy and routing
  -> MedinaMemorySystems retrieval
  -> AURO inference
  -> governed tool execution
  -> durable receipt
  -> operator result
```

The sequence diagram must identify trust transitions, storage writes, approval checks, and evidence outputs.

### 3. Product-family architecture diagrams

Required diagrams:

- NOVA envelope and cognition cycle
- AURO model-serving and routing stack
- MedinaMemorySystems data and retrieval lifecycle
- MCP trust boundary
- PhoneAI local and remote topology
- MESIE signal-to-intelligence pipeline
- PARALLAX synchronization and audit flow
- CAPSULA build, seal, deploy, and restore flow

### 4. Real screenshots

Screenshots must come from running software, not mockups presented as runtime evidence.

Required captures:

- PhoneAI connected to local MCP
- MCP tool discovery output
- one approved tool invocation
- receipt-chain verification
- AURO inference result with measured timing
- memory retrieval with provenance
- MESIE analysis output
- portfolio registry dashboard

Every screenshot must include:

- capture date
- version or commit
- environment label
- LIVE, ALPHA, PROTOTYPE, or RESEARCH status

### 5. Demo videos

Produce three video classes.

#### 60-second overview

Audience: public, partners, social.

Flow:

1. portfolio map
2. phone initiates a task
3. MCP discovers tools
4. NOVA routes work
5. memory and model execute
6. receipt appears
7. system map updates

#### 3-minute technical walkthrough

Audience: developers and technical partners.

Must show installation, initialization, discovery, call, receipt, replay, and limitations.

#### 10-minute architecture walkthrough

Audience: investors, research partners, senior engineers.

Must explain system boundaries, differentiation, security posture, external benchmarks, and roadmap.

Video source files, scripts, captions, and shot lists must be versioned. Compressed exports may be linked through release assets when too large for Git.

### 6. Benchmark cards

Each benchmark card must show:

- benchmark name
- exact workload
- hardware and environment
- model/tool version
- latency distribution
- throughput
- memory usage
- measured cost
- pass/fail threshold
- evidence link

No badge may say enterprise-grade, production-ready, or live without a referenced benchmark or deployment proof.

### 7. Security posture cards

Each externally exposed service must display:

- authentication mechanism
- authorization model
- secret handling
- SSRF boundary
- path boundary
- replay protection
- receipt durability
- rate limits
- current known gaps

### 8. Claim-to-evidence index

Create a generated table mapping every major README or website claim to:

- source repository
- source file and line
- evidence artifact
- status class
- last verification date
- responsible system

Claims with no evidence must automatically be labeled RESEARCH or PLANNED.

## Visual language

Use one coherent system across repositories:

- deep navy/black infrastructure base
- cyan for information flow
- amber for computation or transformation
- green for verified evidence
- purple for memory and cognition
- red only for denied, unsafe, or failed paths

Repository diagrams should favor clarity over decorative complexity.

## Directory convention

```text
docs/showcase/
  diagrams/
    source/
    rendered/
  screenshots/
  videos/
    scripts/
    captions/
    shotlists/
  benchmarks/
  security/
  manifests/
```

## Asset manifest

Every rendered or recorded asset should have a manifest entry containing:

```json
{
  "asset_id": "golden-alpha-path-v1",
  "type": "diagram",
  "status": "ALPHA",
  "source": "docs/showcase/diagrams/source/golden-alpha-path.mmd",
  "rendered": "docs/showcase/diagrams/rendered/golden-alpha-path.svg",
  "commit": "<git-sha>",
  "generated_at": "<timestamp>",
  "evidence": ["<receipt-or-test-reference>"]
}
```

## Alpha showcase acceptance gate

The showcase is ready only when:

- the portfolio map is generated from the registry
- the Golden Alpha Path has a recorded successful run
- every screenshot is tied to a commit and environment
- all videos distinguish simulation from physical execution
- all high-impact actions display approval and receipt evidence
- public claims pass the claim-to-evidence audit
- a clean machine can reproduce the primary demo
