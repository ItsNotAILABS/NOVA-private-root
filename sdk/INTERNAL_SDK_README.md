# MEDINA Internal SDKs

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**

These are **internal SDKs** for the MEDINA ecosystem. They are NOT external dependencies — they live in YOUR system, YOUR registries, YOUR control.

---

## Master Architecture: INTERNAL vs EXTERNAL CALLS

```
YOUR APP
│
│ External call: birthAI({ name: 'ANIMUS' })
│
▼
┌────────────────────────────────────────────────────────────────────────────────┐
│                           @medina/birth-ai SDK                                  │
│                                                                                │
│   ┌──────────────────────────────────────┐   ┌──────────────────────────────┐  │
│   │       INTERNAL CALLS                  │   │       EXTERNAL CALLS         │  │
│   │       (AI talks to itself)            │   │       (You call the SDK)     │  │
│   │                                       │   │                              │  │
│   │   • heart._startBeating()             │   │   • ai.speak(message)        │  │
│   │   • memory._store()                   │   │   • ai.hear(message)         │  │
│   │   • memory._consolidate()             │   │   • ai.setGoal(description)  │  │
│   │   • brain._think()                    │   │   • ai.learn(content)        │  │
│   │   • brain._processGoal()              │   │   • ai.recall(query)         │  │
│   │                                       │   │   • ai.getState()            │  │
│   │   These happen AUTOMATICALLY          │   │   • ai.getConversation()     │  │
│   │   The AI doesn't need your help       │   │                              │  │
│   └──────────────────────────────────────┘   │   You call these when needed  │
│                                               └──────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────────────┘
```

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
├── @medina/birth-ai                  ← Main SDK for birthing AI entities ✨ NEW
├── @medina/medina-calls              ← Write/mutation operations (internal + external) ✨ NEW
├── @medina/medina-queries            ← Read operations (internal + external) ✨ NEW
├── @medina/medina-tools              ← PDF, virtual computer, file ops ✨ NEW
├── @medina/medina-tasks              ← Task scheduling & execution ✨ NEW
├── @medina/medina-multimodal         ← Image, audio, video processing ✨ NEW
├── @medina/medina-builder            ← SDK that builds other SDKs ✨ NEW
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

---

## Complete SDK Reference

### @medina/birth-ai — The Main Entry Point

The SDK that births AI entities. When you call `birthAI()`, you get a living, running AI immediately.

```javascript
import { birthAI, birthInternalAI, birthExternalAgent, birthWorker, birthService } from '@medina/birth-ai';

// Create an AI — IMMEDIATELY ALIVE
const ai = birthAI({
  name: 'ANIMUS',
  numHearts: 1,
  type: 'internal_ai', // or 'external_agent', 'worker', 'service'
});

// External API (what you call)
ai.speak('Hello!');                    // AI speaks
ai.hear('What is 2+2?');               // AI receives input
ai.setGoal('Learn mathematics', 0.8);  // Set a goal with priority
ai.learn({ topic: 'algebra' });        // Teach the AI
const memories = ai.recall('math');    // Query memories
ai.onMessage(msg => console.log(msg)); // Subscribe to messages
console.log(ai.getState());            // Get full state

// Specialized factories
const internal = birthInternalAI('CORE');     // Lives inside organism
const agent = birthExternalAgent('HELPER');   // User-facing
const worker = birthWorker('PROCESSOR');      // Background tasks
const service = birthService('API');          // Always-on service
```

### @medina/medina-calls — Write Operations

Handles all write/mutation operations across internal and external systems.

```javascript
import { 
  internalCall, 
  externalCall, 
  canisterCall,
  registerInternalHandler,
  registerExternalHandler,
  registerCanister,
} from '@medina/medina-calls';

// Internal call — AI talking to itself
internalCall('memory.consolidate', { threshold: 0.7 });

// External call — User/app calling the system
externalCall('ai.setGoal', { description: 'Learn', priority: 0.8 });

// Canister call — Call ICP canister
await canisterCall('canister_id', 'method_name', arg1, arg2);

// Register handlers
registerInternalHandler('memory.consolidate', async (params) => {
  // Handle consolidation
});

registerExternalHandler('ai.setGoal', async (params) => {
  // Handle goal setting
}, { rateLimit: { maxCalls: 10, windowMs: 60000 } });
```

### @medina/medina-queries — Read Operations

Handles all read/query operations with caching support.

```javascript
import {
  internalQuery,
  externalQuery,
  canisterQuery,
  registerInternalStateProvider,
  registerExternalQueryHandler,
} from '@medina/medina-queries';

// Internal query — AI querying its own state
const state = await internalQuery('state:memory');

// External query — User querying the system
const data = await externalQuery('ai.goals');

// Canister query — Query ICP canister (with caching)
const result = await canisterQuery('canister_id', 'getState');

// Register state providers and handlers
registerInternalStateProvider('memory', () => ({
  shortTerm: 50,
  longTerm: 1000,
}));

registerExternalQueryHandler('ai.goals', async (params) => {
  return getGoals();
}, { cacheable: true, ttl: 30000 });
```

### @medina/medina-tools — Tools (PDF, Virtual Computer, etc.)

Provides tools that AIs can use.

```javascript
import {
  useTool,
  generatePDF,
  executeCode,
  runCommand,
  transformData,
  listTools,
} from '@medina/medina-tools';

// Generate PDF
const pdf = await generatePDF({
  title: 'Report',
  content: 'This is the report content...',
});

// Execute code in virtual computer
const result = await executeCode('javascript', `
  const x = 2 + 2;
  console.log(x);
`);

// Run command
const output = await runCommand('ls', ['-la']);

// Transform data
const transformed = await transformData(
  [{ name: 'Alice', age: 30 }, { name: 'Bob', age: 25 }],
  { fullName: 'name', years: 'age' }
);

// Generic tool usage
await useTool('pdf_tool', 'addText', { 
  documentId: pdf.documentId, 
  text: 'Additional text', 
  page: 1 
});

// List available tools
const tools = listTools();
// → pdf_tool, virtual_computer, file_tool, data_tool, code_tool
```

### @medina/medina-tasks — Task Scheduling

Manages tasks, workflows, and scheduling.

```javascript
import {
  runTask,
  runSequential,
  runParallel,
  createWorkflow,
  scheduleTask,
  TASK_PRIORITY,
} from '@medina/medina-tasks';

// Run a simple task
const task = runTask('Process data', async (task) => {
  // Do work
  task.updateProgress(0.5);
  // More work
  return { processed: true };
}, { priority: TASK_PRIORITY.HIGH });

// Run steps in sequence
runSequential('ETL Pipeline', [
  { name: 'Extract', handler: async () => extractData() },
  { name: 'Transform', handler: async (ctx) => transformData(ctx.previousResults[0]) },
  { name: 'Load', handler: async (ctx) => loadData(ctx.previousResults[1]) },
]);

// Run steps in parallel
runParallel('Fetch all', [
  { name: 'Users', handler: async () => fetchUsers() },
  { name: 'Products', handler: async () => fetchProducts() },
  { name: 'Orders', handler: async () => fetchOrders() },
]);

// Create a complex workflow
const workflow = createWorkflow('Data Processing')
  .step('fetch', async () => fetchData())
  .then('validate', async (ctx) => validate(ctx))
  .parallel([
    { name: 'processA', handler: async () => processA() },
    { name: 'processB', handler: async () => processB() },
  ])
  .then('combine', async (ctx) => combine(ctx.completed));

// Schedule tasks
scheduleTask(task, { after: 5000 });              // Run after 5 seconds
scheduleTask(task, { at: new Date('2024-12-01') }); // Run at specific time
scheduleTask(() => new Task(config), { every: 60000 }); // Run every minute
```

### @medina/medina-multimodal — Image, Audio, Video Processing

Process different modalities.

```javascript
import {
  processImage,
  processAudio,
  processVideo,
  processDocument,
  fuseModalities,
} from '@medina/medina-multimodal';

// Image processing
const analysis = await processImage(imageData, { action: 'analyze' });
const resized = await processImage(imageData, { action: 'resize', width: 800, height: 600 });
const ocr = await processImage(imageData, { action: 'ocr' });
const detected = await processImage(imageData, { action: 'detect', detectType: 'faces' });

// Audio processing
const transcript = await processAudio(audioData, { action: 'transcribe', language: 'en' });
const speech = await processAudio(null, { action: 'synthesize', text: 'Hello world' });

// Video processing
const videoAnalysis = await processVideo(videoData, { action: 'analyze' });
const frames = await processVideo(videoData, { action: 'extract_frames', interval: 1 });
const thumbnail = await processVideo(videoData, { action: 'generate_thumbnail', time: 5 });

// Document processing
const parsed = await processDocument(pdfData, { action: 'parse' });
const text = await processDocument(pdfData, { action: 'extract_text' });
const summary = await processDocument(pdfData, { action: 'summarize', maxLength: 500 });

// Fuse multiple modalities
const fused = await fuseModalities([
  { modality: 'IMAGE', data: imageData, options: { action: 'analyze' } },
  { modality: 'AUDIO', data: audioData, options: { action: 'transcribe' } },
]);
```

### @medina/medina-builder — SDK that Builds Other SDKs

The META SDK — builds SDKs, AI entities, workers, services, and canisters from instructions.

```javascript
import { build, buildSDK, buildAI, buildWorker, buildService, buildCanister } from '@medina/medina-builder';

// Build from natural language
const result = await build('Create an SDK called DataProcessor that can transform, filter, and aggregate data');

// Build from structured specification
const sdk = await build({
  type: 'SDK',
  name: 'MySDK',
  description: 'Does awesome things',
  capabilities: ['process', 'analyze', 'transform'],
});

// Quick builders
const dataSdk = await buildSDK('DataProcessor', 'Process and transform data', ['transform', 'filter']);
const aiEntity = await buildAI('HELPER', 'A helpful AI assistant', ['communicate', 'search']);
const worker = await buildWorker('ImageProcessor', 'Process images in background', ['resize', 'filter']);
const service = await buildService('APIGateway', 'Handle API requests', ['route', 'validate']);
const canister = await buildCanister('StorageCanister', 'Store and retrieve data', ['store', 'retrieve']);

// Deploy immediately
const deployed = await build('Create an AI called NEXUS', { deploy: true });
```

---

## Entity Types

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              ENTITY TYPES                                        │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  INTERNAL_AI          Lives inside the organism. Talks to itself and other AIs. │
│  ────────────          Self-bootstraps. Heart IS the bootstrap.                 │
│                                                                                  │
│  EXTERNAL_AGENT       User-facing. Deployed externally. Still self-bootstraps.  │
│  ────────────────     Can be called by users, has public API.                   │
│                                                                                  │
│  WORKER               Background task processor. Part of SERVITORES fleet.      │
│  ────────             Latin naming (GOL-XXX-001). Has COR_PARVUM minihearts.    │
│                                                                                  │
│  SERVICE              Always-on service. Never stops. Multi-hearted for         │
│  ────────             reliability. Handles requests continuously.               │
│                                                                                  │
│  CANISTER             ICP smart contract. Deployed to blockchain.               │
│  ────────             Motoko code. Has heartbeat() system function.             │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## SDK Dependency Graph

```
                                @medina/birth-ai
                                      │
                 ┌────────────────────┼────────────────────┐
                 │                    │                    │
                 ▼                    ▼                    ▼
         @medina/medina-heart   @medina/medina-calls   @medina/medina-queries
                                      │                    │
                                      └──────────┬─────────┘
                                                 │
                 ┌───────────────────────────────┼───────────────────────────────┐
                 │                               │                               │
                 ▼                               ▼                               ▼
         @medina/medina-tools            @medina/medina-tasks           @medina/medina-multimodal
                                                 │
                                                 ▼
                                        @medina/medina-builder
                                                 │
                                                 ▼
                                        @medina/medina-registry
```

---

## Full Example: Building a Complete AI System

```javascript
import { birthAI } from '@medina/birth-ai';
import { runTask, TASK_PRIORITY } from '@medina/medina-tasks';
import { processImage, processDocument } from '@medina/medina-multimodal';
import { useTool } from '@medina/medina-tools';
import { build } from '@medina/medina-builder';

// 1. Birth an AI
const ai = birthAI({
  name: 'DOCUMENT_PROCESSOR',
  numHearts: 2,
});

// 2. Set goals
ai.setGoal('Process incoming documents', TASK_PRIORITY.HIGH);

// 3. Listen for messages
ai.onMessage(async (msg) => {
  if (msg.direction === 'INBOUND' && msg.content.type === 'document') {
    // Process document
    const parsed = await processDocument(msg.content.data, { action: 'parse' });
    
    // Extract text
    const text = await processDocument(msg.content.data, { action: 'extract_text' });
    
    // Learn from document
    ai.learn({ type: 'document', content: text.text });
    
    // Generate summary PDF
    const pdf = await useTool('pdf_tool', 'generate', {
      title: `Summary: ${parsed.metadata.title}`,
      content: text.text,
    });
    
    // Respond
    ai.speak({ type: 'processed', documentId: pdf.documentId });
  }
});

// 4. Run background task
runTask('Document Watch', async (task) => {
  while (true) {
    const memories = ai.recall('document');
    task.updateProgress(0.5);
    // Process memories...
    await new Promise(r => setTimeout(r, 873)); // Heartbeat
  }
});

// 5. Build a helper SDK on the fly
const helperSDK = await build('Create an SDK called DocumentHelper that can summarize, extract, and categorize documents');

console.log('AI System is ALIVE:', ai.getState());
```

---

**The internal AIs have their bootstrap built into them. When you create one, it self-bootstraps. The heart IS the bootstrap function, running continuously — not a one-time init, but the pulse of life itself.**
