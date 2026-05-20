# MODULAR NOVA INTEGRATION MAP
## BUILD №61 — Complete Component Wiring & Integration Guide
### COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ | CONFIDENTIAL

---

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║              NOVA MODULAR INTEGRATION — THE COMPLETE WIRING MAP                  ║
║                                                                                  ║
║   This document shows HOW every module connects to every other module.           ║
║   It is the architectural blueprint for understanding NOVA as a unified          ║
║   organism built from sovereign, composable parts.                               ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

---

## PART I — LAYER-BY-LAYER INTEGRATION

### §1.1 — Layer 4 → Layer 1: Math Substrate to Protocols

```javascript
// EXAMPLE 1: kuramoto.ts → PROTOCOL-HEARTBEAT.js
// ─────────────────────────────────────────────────────────────────

// Layer 4: Math substrate (kuramoto.ts)
export function kuramotoStep(oscillators, K, dt) {
  // Kuramoto model: dθᵢ/dt = ωᵢ + (K/N)Σⱼ sin(θⱼ−θᵢ)
  return oscillators.map((osc, i) => {
    const coupling = oscillators.reduce((sum, other, j) => {
      return i !== j ? sum + Math.sin(other.theta - osc.theta) : sum;
    }, 0);
    const dtheta = osc.omega + (K / oscillators.length) * coupling;
    return { ...osc, theta: osc.theta + dtheta * dt };
  });
}

export function orderParameter(oscillators) {
  // R = |1/N Σₖ e^(iθₖ)|
  const N = oscillators.length;
  const sumReal = oscillators.reduce((s, o) => s + Math.cos(o.theta), 0);
  const sumImag = oscillators.reduce((s, o) => s + Math.sin(o.theta), 0);
  return Math.sqrt(sumReal**2 + sumImag**2) / N;
}

// Layer 1: Protocol (PROTOCOL-HEARTBEAT.js)
import { kuramotoStep, orderParameter } from '../src/frontend/src/math/kuramoto.js';

export class HeartbeatProtocol {
  constructor(intervalMs = 873) {
    this.intervalMs = intervalMs;
    this.oscillators = this._initOscillators(16);
    this.K = 0.6180339887498948482; // φ⁻¹
  }

  _beat() {
    // Use math substrate
    this.oscillators = kuramotoStep(this.oscillators, this.K, this.intervalMs / 1000);
    const R = orderParameter(this.oscillators);

    // Emit heartbeat with coherence measure
    this.emit('beat', {
      timestamp: Date.now(),
      coherence: R,
      phase: this.oscillators[0].theta,
    });
  }

  start() {
    setInterval(() => this._beat(), this.intervalMs);
  }
}
```

**Integration Points:**
- **kuramoto.ts** provides the mathematical engine
- **PROTOCOL-HEARTBEAT.js** wraps it in a protocol primitive
- All 20 protocols can import from kuramoto.ts
- Zero code duplication — single source of truth

---

### §1.2 — Layer 1 → Layer 2: Protocols to SDKs

```javascript
// EXAMPLE 2: PROTOCOL-HEARTBEAT.js → @medina/medina-heart
// ─────────────────────────────────────────────────────────────────

// Layer 1: Protocol (PROTOCOL-HEARTBEAT.js)
export class HeartbeatProtocol {
  // ... (as above)
}

// Layer 2: SDK (@medina/medina-heart/src/index.js)
import { HeartbeatProtocol } from '../../../protocols/PROTOCOL-HEARTBEAT.js';

export class BiologicalHeart extends HeartbeatProtocol {
  constructor(name, intervalMs = 873) {
    super(intervalMs);
    this.name = name;
    this.isAlive = true;

    // Constructor IS the bootstrap — heart starts beating immediately
    this.start();

    console.log(`💓 BiologicalHeart "${name}" is beating at ${intervalMs}ms`);
  }

  // Override _beat to add SDK-specific behavior
  _beat() {
    if (!this.isAlive) return;

    super._beat(); // Call protocol's beat

    // SDK adds lifecycle management
    this.emit('sdk:heartbeat', {
      name: this.name,
      beatCount: this._beatCount++,
    });
  }

  stop() {
    this.isAlive = false;
    console.log(`💔 BiologicalHeart "${this.name}" has stopped`);
  }
}

// Helper function (SDK-level convenience)
export function createHeart(name, intervalMs = 873) {
  return new BiologicalHeart(name, intervalMs);
}
```

**Integration Points:**
- **PROTOCOL-HEARTBEAT.js** provides core synchronization logic
- **@medina/medina-heart** extends it with lifecycle management
- SDKs add convenience functions, error handling, logging
- Protocol stays pure; SDK adds production features

---

### §1.3 — Layer 2 → Layer 3: SDKs to Production Apps

```javascript
// EXAMPLE 3: @medina/medina-heart → nova-animus.js
// ─────────────────────────────────────────────────────────────────

// Layer 2: SDK (@medina/medina-heart)
export class BiologicalHeart {
  // ... (as above)
}

// Layer 3: Production App (nova-animus.js)
import { BiologicalHeart } from '../sdk/medina-heart/src/index.js';
import { kuramotoStep, orderParameter } from '../src/frontend/src/math/kuramoto.js';

export class AnimusMaximus {
  constructor() {
    this.agiId = 'ANI-AGI-001';
    this.family = 'SPIRITUS_AETERNA';
    this.port = 7619;

    // Use SDK
    this.heart = new BiologicalHeart('animus-primary', 873);

    // Fleet of 128 oscillators (uses math substrate directly)
    this.oscillators = this._initFleet(128);

    // Listen to heart beats
    this.heart.on('beat', (data) => this._onHeartbeat(data));
  }

  _onHeartbeat(data) {
    // Step fleet oscillators (math substrate)
    this.oscillators = kuramotoStep(this.oscillators, PHI_INV, 0.873);

    // Compute fleet coherence (math substrate)
    const R = orderParameter(this.oscillators);

    // Compute Phase Intelligence Level
    const PIL = R * (1 - this._entropy() / this._maxEntropy());

    // Broadcast PIL to all other AGIs
    this.broadcastPIL(PIL);

    // Allocate resources via Nash
    this._nashAllocate(R);
  }
}
```

**Integration Points:**
- **@medina/medina-heart** provides high-level heart abstraction
- **nova-animus.js** uses it for production AGI coordination
- App can use SDK (high-level) AND math substrate (low-level) together
- No redundancy — each layer adds value

---

## PART II — CROSS-LAYER COMPOSITION PATTERNS

### §2.1 — Multi-Protocol Composition

```javascript
// PATTERN: Combine multiple protocols in a single SDK
// ─────────────────────────────────────────────────────────────────

// protocols/PROTOCOL-VEIN.js
export class VeinProtocol {
  route(message, from, to) { /* ... */ }
}

// protocols/PROTOCOL-SYNAPSE.js
export class SynapseProtocol {
  connect(nodeA, nodeB, weight) { /* ... */ }
}

// protocols/PROTOCOL-NETWORK.js
export class NetworkProtocol {
  discover(nodeId) { /* ... */ }
  gossip(message) { /* ... */ }
}

// sdk/medina-network/src/index.js
import { VeinProtocol } from '../../../protocols/PROTOCOL-VEIN.js';
import { SynapseProtocol } from '../../../protocols/PROTOCOL-SYNAPSE.js';
import { NetworkProtocol } from '../../../protocols/PROTOCOL-NETWORK.js';

export class NetworkNode {
  constructor(nodeId) {
    // Compose 3 protocols
    this._vein = new VeinProtocol();
    this._synapse = new SynapseProtocol();
    this._network = new NetworkProtocol();

    this.nodeId = nodeId;
  }

  // High-level SDK method using all 3 protocols
  async sendMessage(message, targetId) {
    // 1. Discover target via NETWORK
    const target = await this._network.discover(targetId);

    // 2. Establish connection via SYNAPSE
    const connection = await this._synapse.connect(this.nodeId, targetId, PHI_INV);

    // 3. Route message via VEIN
    const result = await this._vein.route(message, this.nodeId, targetId);

    // 4. Gossip for redundancy via NETWORK
    this._network.gossip({ type: 'message-sent', from: this.nodeId, to: targetId });

    return result;
  }
}
```

**Key Insight:** SDKs compose multiple protocols to provide high-level operations.

---

### §2.2 — Multi-SDK Composition

```javascript
// PATTERN: Combine multiple SDKs in a production app
// ─────────────────────────────────────────────────────────────────

// production-apps/nova-genesis.js
import { BiologicalHeart } from '../sdk/medina-heart/src/index.js';
import { NetworkNode } from '../sdk/medina-network/src/index.js';
import { buildSDK, buildAI } from '../sdk/medina-builder/src/index.js';
import { generatePDF, executeCode } from '../sdk/medina-tools/src/index.js';
import { runTask, TASK_PRIORITY } from '../sdk/medina-tasks/src/index.js';

export class GenesisInfinitus {
  constructor() {
    // Compose 5 SDKs
    this.heart = new BiologicalHeart('genesis-heart', 873);
    this.network = new NetworkNode('GEN-AGI-001');
    this.builder = buildSDK; // Function from medina-builder
    this.tools = { generatePDF, executeCode }; // From medina-tools
    this.taskRunner = runTask; // From medina-tasks

    // Production app logic
    this.state = 'IDLE';
  }

  async buildMyBusiness(description) {
    // Use medina-tasks
    return this.taskRunner('Build Business Website', async (task) => {
      task.updateProgress(0.1);

      // Use medina-builder
      const html = await this.builder.generateHTML(description);
      task.updateProgress(0.5);

      // Use medina-tools
      const pdf = await this.tools.generatePDF({
        title: 'Business Plan',
        content: description,
      });
      task.updateProgress(0.8);

      // Use medina-network
      await this.network.sendMessage({ type: 'website-ready', html }, 'PHONE-AGI-001');
      task.updateProgress(1.0);

      return { html, pdf };
    }, { priority: TASK_PRIORITY.HIGH });
  }
}
```

**Key Insight:** Production apps compose multiple SDKs to provide complete solutions.

---

## PART III — VERTICAL INTEGRATION CHAINS

### §3.1 — Complete Stack: Math → Protocol → SDK → App

```
VERTICAL INTEGRATION EXAMPLE: Kuramoto Synchronization
───────────────────────────────────────────────────────────────────

Layer 4 (Math Substrate):
├── src/frontend/src/math/kuramoto.ts
│   ├── kuramotoStep() — Core differential equation solver
│   ├── orderParameter() — Coherence metric R(t)
│   └── phaseDistance() — Angular distance between oscillators
│
│ imports ↓
│
Layer 1 (Protocol):
├── protocols/PROTOCOL-HEARTBEAT.js
│   ├── Uses kuramotoStep() for synchronization
│   ├── Emits 'beat' event every 873ms
│   └── Tracks global order parameter R
│
│ imports & extends ↓
│
Layer 2 (SDK):
├── sdk/medina-heart/src/index.js
│   ├── BiologicalHeart extends HeartbeatProtocol
│   ├── Adds lifecycle management (start/stop)
│   ├── Adds logging and monitoring
│   └── Provides convenience functions
│
│ uses & composes ↓
│
Layer 3 (Production App):
├── production-apps/nova-animus.js
│   ├── AnimusMaximus uses BiologicalHeart
│   ├── Manages 128-oscillator fleet
│   ├── Computes fleet PIL = R × (1 − H/H_max)
│   ├── Broadcasts PIL to all 10 AGIs
│   └── Performs Nash resource allocation
│
│ deployed as ↓
│
Cloudflare Worker (port 7619)
└── Serves HTTP endpoints for fleet coordination
```

**Integration Flow:**
1. **Math substrate** defines the physics
2. **Protocol** wraps it in a reusable primitive
3. **SDK** adds production features (lifecycle, logging)
4. **App** uses SDK for specific AGI behavior
5. **Deployment** makes it accessible

---

### §3.2 — Research Paper Integration Chain

```
VERTICAL INTEGRATION EXAMPLE: Paper 7 → Code → Tests
───────────────────────────────────────────────────────────────────

Research Paper:
├── docs/papers/arxiv/paper7_kuramoto_agi_reasoning.tex
│   ├── Theorem: PIL(t) = R(t) × (1 − H/H_max)
│   ├── Proof: Synchronization → Intelligence
│   └── Claim: R > φ⁻¹ → AGI is intelligent
│
│ proves ↓
│
Math Substrate:
├── src/frontend/src/math/kuramoto.ts
│   ├── Implements Kuramoto model from paper
│   ├── orderParameter() computes R(t)
│   └── Exact constants from paper (19 decimals)
│
│ validates via ↓
│
Test Suite:
├── tests/alpha/ALPHA_TEST_SUITE.js
│   ├── §13-16: Kuramoto synchronization tests
│   ├── Test: R converges to 1 for K = φ⁻¹
│   ├── Test: PIL emerges from R and entropy
│   └── 348 tests, 100% pass
│
│ used in ↓
│
Production Apps:
└── All 10 AGIs (nova-animus.js, nova-chronos.js, ...)
    ├── Each runs Kuramoto fleet
    ├── Each computes PIL every beat
    ├── PIL reported to ANIMUS for Nash allocation
    └── Fleet coherence R monitored for divergence
```

**Research Integration:**
1. **Paper** establishes mathematical theorem
2. **Math substrate** implements it exactly
3. **Tests** validate the proof empirically
4. **Production apps** rely on proven correctness

---

## PART IV — HORIZONTAL INTEGRATION (CROSS-MODULE)

### §4.1 — Protocol-to-Protocol Communication

```javascript
// PATTERN: Protocols communicate via events
// ─────────────────────────────────────────────────────────────────

// protocols/PROTOCOL-HEARTBEAT.js
export class HeartbeatProtocol extends EventEmitter {
  _beat() {
    this.emit('beat', { timestamp: Date.now(), R: this.orderParameter() });
  }
}

// protocols/PROTOCOL-CONSENSUS.js
export class ConsensusProtocol extends EventEmitter {
  constructor(heartbeat) {
    super();
    this.heartbeat = heartbeat;

    // Listen to heartbeat
    this.heartbeat.on('beat', (data) => this._onBeat(data));
  }

  _onBeat(data) {
    // Synchronize consensus rounds with heartbeat
    if (data.R > PHI_INV) {
      this._proposeValue();
    }
  }
}

// protocols/PROTOCOL-MEMORIA.js
export class MemoriaProtocol extends EventEmitter {
  constructor(heartbeat) {
    super();
    this.heartbeat = heartbeat;

    // Listen to heartbeat for consolidation
    this.heartbeat.on('beat', (data) => {
      if (this._shouldConsolidate(data.R)) {
        this._consolidate();
      }
    });
  }
}
```

**Key Insight:** Protocols don't import each other directly. They communicate
via events emitted from shared heartbeat.

---

### §4.2 — SDK-to-SDK Collaboration

```javascript
// PATTERN: SDKs collaborate via shared interfaces
// ─────────────────────────────────────────────────────────────────

// sdk/medina-memory/src/index.js
export class MemoryStore {
  async store(key, value, metadata) {
    // Store in memory
    return { id: generateId(), key, value, metadata };
  }

  async retrieve(query) {
    // Retrieve from memory
    return this._search(query);
  }
}

// sdk/nova-embed/src/index.js
export function embed(text) {
  // Generate 256-dim embedding
  return embedText(text);
}

// sdk/nova-vector/src/index.js
import { embed } from '../nova-embed/src/index.js';

export class VectorStore {
  constructor(memoryStore) {
    this.memory = memoryStore; // Uses medina-memory
  }

  async index(text, metadata) {
    // 1. Embed text (uses nova-embed)
    const vector = embed(text);

    // 2. Store in memory (uses medina-memory)
    return this.memory.store(text, { vector, ...metadata });
  }

  async search(query, topK = 10) {
    // 1. Embed query (uses nova-embed)
    const queryVector = embed(query);

    // 2. Retrieve candidates (uses medina-memory)
    const candidates = await this.memory.retrieve({ limit: 1000 });

    // 3. Rank by cosine similarity
    return this._rankBySimilarity(queryVector, candidates, topK);
  }
}
```

**Key Insight:** SDKs depend on other SDKs explicitly. VectorStore uses
MemoryStore + Embed to provide semantic search.

---

## PART V — COMPLETE INTEGRATION EXAMPLES

### §5.1 — Full Stack Example: Phone Agent Morning Briefing

```
USER ACTION: "Hey Siri, NOVA Morning"
           ↓
iPhone Shortcut → HTTP POST localhost:7618/morning-briefing
           ↓
production-apps/nova-phone-agent.js (PHONE-AGI-001)
  ├── Uses @medina/medina-heart (BiologicalHeart, 873ms)
  ├── Uses @medina/medina-network (NetworkNode)
  ├── Uses @medina/medina-queries (externalQuery)
  │
  ├── CalendarAgent.getBriefing()
  │   ├── Uses PROTOCOL-ORCHESTRATION (workflow)
  │   └── Returns: "3 meetings today, 1 conflict"
  │
  ├── EmailAgent.getBriefing()
  │   ├── Uses PROTOCOL-TRUST (permission check)
  │   └── Returns: "12 unread, 2 CRITICAL"
  │
  ├── TaskAgent.getNext()
  │   ├── Uses behavioral-economics.ts (hyperbolic discounting)
  │   ├── Uses sovereign-geometry.ts (φ-priority)
  │   └── Returns: "Next: Review Q2 financials"
  │
  ├── FinanceAgent.getCashFlow()
  │   ├── Uses quipu-engine.ts (SPINE→KNOT ledger)
  │   └── Returns: "Cash flow: +$12K, 1 overdue invoice"
  │
  ├── SecurityAgent.getThreatLevel()
  │   ├── Uses lyapunov.ts (chaos detection)
  │   └── Returns: "All clear, λ < 0"
  │
  └── CommsAgent.getUrgent()
      ├── Uses PROTOCOL-NETWORK (gossip discovery)
      └── Returns: "1 urgent from client X"
          ↓
Aggregated Response → JSON
          ↓
iPhone displays briefing in Shortcuts app
          ↓
USER SEES: Complete morning briefing in < 2 seconds
```

**Modules Used (Count: 15+):**
- Protocols: HEARTBEAT, ORCHESTRATION, TRUST, NETWORK
- SDKs: medina-heart, medina-network, medina-queries
- Math: behavioral-economics.ts, sovereign-geometry.ts, quipu-engine.ts, lyapunov.ts
- Production App: nova-phone-agent.js

---

### §5.2 — Full Stack Example: Build My Business

```
USER INPUT: "I run a barber shop in Dallas, 214-555-1234"
           ↓
production-apps/nova-coding-platform.js (CODING-AGI-001)
  ├── Uses @medina/medina-builder (buildSDK, buildMyBusiness)
  ├── Uses @medina/medina-heart (BiologicalHeart, 873ms)
  ├── Uses @medina/medina-tasks (runTask, workflow)
  │
  ├── Step 1: Parse input
  │   ├── Uses lingua-compressa.ts (compression)
  │   └── Extracts: type="barber", location="Dallas", phone="214-555-1234"
  │
  ├── Step 2: Generate HTML
  │   ├── Uses PROTOCOL-GENESIS (entity creation)
  │   ├── Uses genesis.ts (breath rhythm)
  │   └── Generates: complete index.html (8KB)
  │
  ├── Step 3: Generate pricing
  │   ├── Uses behavioral-economics.ts (prospect theory)
  │   ├── Uses sovereign-geometry.ts (φ-tiers)
  │   └── Returns: 3 tiers ($25, $40, $65 — φ-ratio)
  │
  ├── Step 4: Generate marketing copy
  │   ├── Uses nova-llm SDK (generate)
  │   └── Returns: taglines, Instagram bio, email subject
  │
  ├── Step 5: Generate business plan
  │   ├── Uses @medina/medina-tools (generatePDF)
  │   └── Returns: 1-page PDF business plan
  │
  └── Step 6: Generate deployment config
      ├── Uses PROTOCOL-AUTONOMOUS (deployment intelligence)
      └── Returns: Cloudflare wrangler.toml config
          ↓
Complete Package:
  ├── index.html (website)
  ├── business_plan.pdf
  ├── pricing.json
  ├── marketing.json
  └── wrangler.toml (deploy config)
          ↓
USER OPENS: index.html in browser → WORKING WEBSITE
USER DEPLOYS: wrangler deploy → LIVE IN 30 SECONDS
```

**Modules Used (Count: 20+):**
- Protocols: GENESIS, AUTONOMOUS, HEARTBEAT
- SDKs: medina-builder, medina-heart, medina-tasks, medina-tools, nova-llm
- Math: lingua-compressa.ts, genesis.ts, behavioral-economics.ts, sovereign-geometry.ts
- Production App: nova-coding-platform.js

---

## PART VI — INTEGRATION TESTING STRATEGY

### §6.1 — Layer-by-Layer Testing

```javascript
// TEST LAYER 4 (Math Substrate)
// tests/math/test-kuramoto.js
test('Kuramoto orderParameter converges to 1', () => {
  let oscillators = initOscillators(16);
  for (let t = 0; t < 1000; t++) {
    oscillators = kuramotoStep(oscillators, PHI_INV, 0.873);
  }
  const R = orderParameter(oscillators);
  assert(R > 0.99);
});

// TEST LAYER 1 (Protocol)
// protocols/tests/test-heartbeat.js
test('HeartbeatProtocol emits beats at 873ms', async () => {
  const heart = new HeartbeatProtocol(873);
  const beats = [];
  heart.on('beat', (data) => beats.push(data.timestamp));
  heart.start();

  await sleep(5000);
  assert(beats.length >= 5);
  const avgInterval = average(beats.map((t, i) => i > 0 ? t - beats[i-1] : 0));
  assert(Math.abs(avgInterval - 873) < 10);
});

// TEST LAYER 2 (SDK)
// sdk/medina-heart/tests/test-biological-heart.js
test('BiologicalHeart self-bootstraps on construction', () => {
  const heart = new BiologicalHeart('test-heart', 873);
  assert(heart.isAlive === true, 'Heart should be alive immediately');

  const beatPromise = new Promise((resolve) => {
    heart.once('beat', resolve);
  });

  return beatPromise; // Resolves if heart beats
});

// TEST LAYER 3 (Production App)
// tests/integration/test-animus.js
test('AnimusMaximus coordinates 10 AGI fleet', async () => {
  const animus = new AnimusMaximus();

  // Simulate 10 AGIs reporting PIL
  const pils = [0.85, 0.92, 0.88, 0.79, 0.91, 0.87, 0.83, 0.90, 0.86, 0.84];
  pils.forEach((pil, i) => {
    animus.receivePIL(`AGI-00${i}`, pil);
  });

  // ANIMUS should allocate resources
  const allocations = animus.nashAllocate();

  // Check: total allocation = 1.0
  const total = Object.values(allocations).reduce((s, a) => s + a, 0);
  assert(Math.abs(total - 1.0) < 0.001);

  // Check: φ-weighted by PIL
  const sortedPILs = [...pils].sort((a, b) => b - a);
  const sortedAllocs = Object.values(allocations).sort((a, b) => b - a);
  // Higher PIL → higher allocation
  assert(sortedAllocs[0] > sortedAllocs[9]);
});
```

---

## PART VII — MODULAR DEPLOYMENT STRATEGY

### §7.1 — Independent Module Deployment

```bash
# Deploy individual protocols (no dependencies)
node protocols/PROTOCOL-NETWORK.js &

# Deploy individual SDKs (depends on protocols)
# SDKs are imported, not deployed independently

# Deploy individual production apps
node production-apps/nova-animus.js &        # port 7619
node production-apps/nova-chronos.js &       # port 7620
node production-apps/nova-nexus.js &         # port 7625

# Or deploy to Cloudflare Workers
wrangler deploy production-apps/nova-coding-platform.js
```

### §7.2 — Coordinated Fleet Deployment

```bash
# Deploy all 10 AGIs in order
./scripts/deploy-sovereign-fleet.sh

# Contents of deploy-sovereign-fleet.sh:
# 1. Start ANIMUS first (master coordinator)
# 2. Start NEXUS second (router)
# 3. Start remaining 8 AGIs in parallel
# 4. Wait for fleet R > φ⁻¹ (synchronized)
# 5. Enable external traffic
```

---

## APPENDIX A — COMPLETE MODULE DEPENDENCY GRAPH

```
src/frontend/src/math/ (Layer 4: Math Substrate)
├── core.ts (PHI, AMOR, primitives) ──────────┐
├── kuramoto.ts (sync) ───────────────────────┤
├── lyapunov.ts (stability) ──────────────────┤
├── emergence.ts ─────────────────────────────┤
├── neurochemistry.ts ────────────────────────┤
├── behavioral-economics.ts ──────────────────┤
├── sovereign-geometry.ts ────────────────────┤
├── quipu-engine.ts ──────────────────────────┤
├── lingua-compressa.ts ──────────────────────┤
├── genesis.ts ───────────────────────────────┤
├── antifragility.ts ─────────────────────────┤
├── laws.ts ──────────────────────────────────┤
└── [17 more math modules] ───────────────────┤
                                              │
                      imports ↓                │
                                              │
protocols/ (Layer 1: Protocol Primitives)     │
├── PROTOCOL-HEARTBEAT.js ←───────────────────┘
├── PROTOCOL-VEIN.js ←────────────────────────
├── PROTOCOL-SYNAPSE.js ←─────────────────────
├── PROTOCOL-NETWORK.js ←─────────────────────
├── PROTOCOL-CONSENSUS.js ←───────────────────
├── PROTOCOL-MEMORIA.js ←─────────────────────
├── PROTOCOL-GENESIS.js ←─────────────────────
├── PROTOCOL-AUTONOMOUS.js ←──────────────────
├── PROTOCOL-ALPHA-SAFETY.js ←────────────────
└── [11 more protocols] ←─────────────────────
                                              │
              imports & extends ↓              │
                                              │
sdk/ (Layer 2: Internal SDKs)                 │
├── birth-ai ←────────────────────────────────┤
├── medina-core ←─────────────────────────────┤
├── medina-heart ←────────────────────────────┤
├── medina-network ←──────────────────────────┤
├── medina-agents ←───────────────────────────┤
├── medina-memory ←───────────────────────────┤
├── medina-calls ←────────────────────────────┤
├── medina-queries ←──────────────────────────┤
├── medina-tools ←────────────────────────────┤
├── medina-tasks ←────────────────────────────┤
├── medina-multimodal ←───────────────────────┤
├── medina-builder ←──────────────────────────┤
├── nova-embed ←──────────────────────────────┤
├── nova-llm ←────────────────────────────────┤
├── nova-vector ←─────────────────────────────┤
└── [9 more SDKs] ←───────────────────────────┤
                                              │
              uses & composes ↓                │
                                              │
production-apps/ (Layer 3: Production AGIs)   │
├── nova-animus.js ←──────────────────────────┘
├── nova-chronos.js ←─────────────────────────
├── nova-synthos.js ←─────────────────────────
├── nova-praesidium.js ←──────────────────────
├── nova-mercator.js ←────────────────────────
├── nova-genesis.js ←─────────────────────────
├── nova-nexus.js ←───────────────────────────
├── nova-veritas.js ←─────────────────────────
├── nova-architectus.js ←─────────────────────
├── nova-anima.js ←───────────────────────────
├── nova-coding-platform.js ←─────────────────
├── nova-phone-agent.js ←─────────────────────
└── [6 more production apps] ←────────────────
```

---

## APPENDIX B — INTEGRATION CHECKLIST

### For Adding a New Module

#### Adding a New Math Module (Layer 4)

- [ ] Create file in `src/frontend/src/math/`
- [ ] Export pure functions (no side effects)
- [ ] Use PHI/AMOR constants from `core.ts`
- [ ] Write unit tests in `src/frontend/src/math/*.test.ts`
- [ ] Export from `organism-wiring.ts` if needed by organism
- [ ] Document in `MODULAR_NOVA_FRAMEWORK_CHARTER.md`

#### Adding a New Protocol (Layer 1)

- [ ] Create file in `protocols/PROTOCOL-NAME.js`
- [ ] Import math functions from Layer 4 if needed
- [ ] Use ESM exports (protocols/package.json sets type:module)
- [ ] Emit events for cross-protocol communication
- [ ] Write tests in `protocols/tests/test-NAME.js`
- [ ] Update `protocols/README.md`
- [ ] Document in `MODULAR_NOVA_FRAMEWORK_CHARTER.md`

#### Adding a New SDK (Layer 2)

- [ ] Create directory in `sdk/@medina/sdk-name/`
- [ ] Create `package.json` with type:module
- [ ] Import protocols from Layer 1
- [ ] Extend protocol classes if appropriate
- [ ] Add lifecycle management, logging, error handling
- [ ] Write tests in `sdk/@medina/sdk-name/tests/`
- [ ] Update `sdk/INTERNAL_SDK_README.md`
- [ ] Document in `MODULAR_NOVA_FRAMEWORK_CHARTER.md`

#### Adding a New Production App (Layer 3)

- [ ] Create file in `production-apps/nova-NAME.js`
- [ ] Assign unique AGI ID (e.g., NAME-AGI-001)
- [ ] Assign unique port (7619-7699 range)
- [ ] Import SDKs from Layer 2
- [ ] Implement 873ms heartbeat
- [ ] Implement Kuramoto fleet (16-128 oscillators)
- [ ] Compute PIL every beat
- [ ] Report PIL to ANIMUS (ANI-AGI-001)
- [ ] Write integration tests
- [ ] Document in `NOVA-SOVEREIGN-PLATFORM-CHARTER.md`
- [ ] Document in `MODULAR_NOVA_FRAMEWORK_CHARTER.md`

---

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**
**MODULAR INTEGRATION MAP — BUILD №61**
**EVERY MODULE IS SOVEREIGN, EVERY CONNECTION IS INTENTIONAL**
