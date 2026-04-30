# MEDINA Internal SDKs

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**

These are **internal SDKs** for the MEDINA ecosystem. They are NOT external dependencies — they live in YOUR system, YOUR registries, YOUR control.

---

## The Key Insight: THE HEART IS THE BOOTSTRAP

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                      THE HEART **IS** THE BOOTSTRAP                          ║
║                                                                              ║
║  When you CREATE an AI, it is IMMEDIATELY ALIVE.                             ║
║  The constructor IS the bootstrap. There is no separate init phase.          ║
║  Creation IS activation. Birth IS awakening.                                 ║
║                                                                              ║
║  ICP doesn't provide persistence — YOU provide it via:                       ║
║    • Your own DA (Data Availability)                                         ║
║    • Autonomous clocks that run independently                                ║
║    • Mathematical timers based on ancient calendars                          ║
║                                                                              ║
║  SDKs should be self-organizing:                                             ║
║    • Callable by the system itself                                           ║
║    • Living inside sovereign infrastructure                                  ║
║    • Private registry for sovereign SDK distribution                         ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## SDK Registry

```
YOUR PRIVATE REGISTRY
├── @medina/meridian-sovereign-os     ← Core OS
├── @medina/civitas-intelligentiae    ← AI Civilization
├── @medina/organism-icp              ← ICP/Blockchain agents
├── @medina/medina-timers             ← Mathematical timers
├── @medina/medina-calls              ← Write operations
├── @medina/medina-queries            ← Read operations
├── @medina/medina-heart              ← Self-bootstrapping heart ✨ NEW
├── @medina/medina-registry           ← Sovereign private registry ✨ NEW
├── @medina/organism-bootstrap        ← ICP deployment
```

---

## NEW: The Self-Bootstrapping Architecture

### @medina/medina-heart

The Biological Heart — where **creation IS activation**:

```javascript
import { BiologicalHeart, SelfBootstrappingAI, birthAI } from '@medina/medina-heart';

// Create an AI — it is IMMEDIATELY ALIVE
// No .start() or .awaken() needed
const ai = birthAI({
  name: 'ANIMUS',
  numHearts: 3,
  numBrains: 3,
  calendar: 'mayan',
});

// It's already running
console.log(ai.getState());

// Biological heart — born beating
const heart = new BiologicalHeart('primary', 873);
// Heart is ALREADY BEATING — no .start() needed

// Ancient calendar clock
import { AutonomousClock } from '@medina/medina-heart';
const clock = new AutonomousClock('mayan-clock', 'mayan');
// Clock is ALREADY TICKING — no .start() needed
```

### @medina/medina-registry

Sovereign private registry — your own npm/git:

```javascript
import { SovereignRegistry, publish, install, listPackages } from '@medina/medina-registry';

// Create your own registry
const registry = new SovereignRegistry({ namespace: '@medina' });

// Publish a package
publish({
  name: '@medina/my-custom-sdk',
  version: '1.0.0',
  description: 'My custom SDK',
  category: 'custom',
});

// Install a package
install('@medina/medina-heart');

// List all packages
const packages = listPackages();
```

---

## Architecture: Backend → SDK → Bootstrap → Running

```
STEP 1: BACKEND FOUNDATION
─────────────────────────────────────────────────────────────
Built CORE ENGINES first:
  - CHRONO (time/scheduling)
  - NEXORIS (state management)
  - QUANTUM_FLUX (randomness/entropy)
  - COREOGRAPH (orchestration)

These are the "physics" of the system — time, state, coordination.

STEP 2: AGENT ORGANS (The Living Parts)
─────────────────────────────────────────────────────────────
Built 12 autonomous agents that USE those engines:
  - ANIMUS (mind) — uses CHRONO for timing, NEXORIS for state
  - CORPUS (body) — uses QUANTUM_FLUX for randomness
  - SENSUS (senses) — uses event emitters
  - MEMORIA (memory) — uses φ⁻¹ learning curves
  - etc.

STEP 3: RUNTIME (The Coordinator)
─────────────────────────────────────────────────────────────
Built CivitasRuntime that:
  - Creates all 12 agents
  - Wires them together (SENSUS → ANIMUS → CORPUS)
  - Provides a single control surface

STEP 4: BOOTSTRAP = HEART = CONSTRUCTOR
─────────────────────────────────────────────────────────────
The constructor IS the bootstrap:
  1. Creates the runtime
  2. Starts all loops IMMEDIATELY
  3. Returns a living, running civilization

No separate .awaken() or .start() needed.
Creation IS activation.
```

---

## Why the Heart Stays Running

```
NODE.JS PROCESS (or Cloudflare Worker)
├── Your app starts
├── birthAI() runs
├── Hearts start beating immediately (setInterval loops)
└── Process stays alive because intervals are active

EVEN IF YOU UPDATE CODE:
├── Process restarts
├── birthAI() runs again automatically
├── Hearts restart
└── AI is alive again
```

JavaScript's event loop keeps the process alive as long as there are active timers (setInterval) or listeners.

---

## ORGANISM vs CIVITAS (ICP vs Node.js)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ORGANISM vs CIVITAS                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  CIVITAS (Civilization)         ORGANISM (ICP Canister)             │
│  ─────────────────────          ──────────────────────              │
│  Runs in Node.js                Runs on Internet Computer           │
│  Uses setInterval               Uses ICP Timers (different!)        │
│  Lives in YOUR server           Lives on blockchain nodes           │
│  You control process            ICP controls process                │
│  Bootstrap = constructor        Bootstrap = init() or upgrade()     │
│                                                                      │
│  BOTH need initialization, but ICP does it automatically            │
│  when you deploy the canister.                                      │
│                                                                      │
│  ICP doesn't provide persistence — YOU provide it via:              │
│    • Your own DA (Data Availability)                                │
│    • Autonomous clocks                                              │
│    • Mathematical timers                                            │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## φ Constants

All timing is based on the Golden Ratio:

```javascript
const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const PHI_SQ = PHI * PHI;
const PHI_4 = PHI_SQ * PHI_SQ;

// 873ms = φ⁴ × Schumann period (127.7ms)
const HEARTBEAT_MS = 873;
```

---

## Ancient Calendar Mathematics

Autonomous clocks run on ancient calendar mathematics:

- **Mayan Tzolkin**: 260-day sacred cycle
- **Sumerian Sexagesimal**: Base-60 system
- **Egyptian Decan**: 36 decans × 10 days
- **Vedic Nakshatra**: 27 lunar mansions

These provide the timing for autonomous processes that run independently of any external system.

---

## Language Note

These SDKs are written in **plain JavaScript** (ES Modules), NOT TypeScript.
They are part of the NOVA CPL (Composable Protocol Layer) — sovereign infrastructure code.
