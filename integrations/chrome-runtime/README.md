# HIM Chrome Runtime

Browser-native continuation of the adaptive Auro skill-organ envelope.

## Architecture

- **WebGPU-first inference** with WASM fallback for local text generation and eligible tensor work.
- **Decentralized multi-tab mesh** using `BroadcastChannel` for peer discovery and task coordination.
- **Persistent workflow queue** in IndexedDB with priorities, leases, retries, and terminal states.
- **Governed Python bridge** for privileged capabilities: Python workers, CAPSULA, MatDaemon, Office, wallet, and receipts.
- **Receipt boundary**: browser peers cannot claim privileged execution without a bridge response and hash-bearing receipt.

## Run

```bash
cd integrations/chrome-runtime
npm install
npm run typecheck
npm run build
```

Start the local Python bridge:

```bash
export HIM_BRIDGE_TOKEN='replace-me'
python bridge/server.py
```

Create the browser runtime:

```ts
import { ChromeRuntime } from './dist/index.js';

const runtime = new ChromeRuntime('http://127.0.0.1:8092', 'replace-me');
runtime.start();
await runtime.mesh.enqueue('inference', {
  modelId: '/models/auro-browser',
  prompt: 'Route this task through the embedded organs.'
}, 10);
setInterval(() => runtime.workOnce(), 250);
```

## Security boundary

The browser may perform local inference and non-privileged tensor work. It may request privileged execution, but the Python bridge independently validates authentication and capability allowlists. The current bridge contains safe adapter placeholders; production engine adapters must call CAPSULA, MatDaemon, Office, wallet, and worker APIs rather than executing arbitrary payloads directly.

## Fallback ladder

1. WebGPU local inference
2. WASM local inference
3. governed remote-Python inference/task execution

No fallback may silently bypass receipts or capability checks.
