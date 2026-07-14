# NOVA Browser AI — First-Class Platform Runtime

This pass brings the browser AI work from `FreddyCreates/potential-succotash` into the NOVA App Platform as runtime code, not a placeholder.

## Source lineage

Imported architectural patterns:

- Vigil/Jarvis-style background brain.
- MiniHeart / MiniBrain / MetaThought runtime loop.
- Protocol agent registry.
- Natural language browser command parser.
- Browser action plan builder.
- Memory Temple categorization.
- Page snapshot ingestion.

The code was adapted into the NOVA platform boundary instead of copying extension-only execution directly.

## Runtime surfaces

```text
platform/nova-app-platform/src/browserAI/neuroCore.js
platform/nova-app-platform/src/browserAI/intentRouter.js
platform/nova-app-platform/src/browserAI/runtime.js
platform/nova-app-platform/public/browser-ai.html
platform/nova-app-platform/public/browser-ai.js
platform/nova-app-platform/tests/browser-ai.test.js
```

## API routes

```text
GET  /browser-ai
GET  /api/browser-ai/status
GET  /api/browser-ai/history
POST /api/browser-ai/command
POST /api/browser-ai/page-snapshot
```

`/api/browser-ai/command`, `/api/browser-ai/page-snapshot`, and `/api/browser-ai/history` require the NOVA operator token or a platform session.

## Boundary

The browser AI does not silently control the browser from the platform server. It produces command records, agent routing, plans, and receipts. Real browser actions stay behind the browser extension/user execution surface.

The browser never receives `OPENAI_API_KEY`. AI model calls remain server-side through the NOVA App Platform gateway.

## Run

```bash
cd platform/nova-app-platform
npm install
npm test
npm start
```

Open:

```text
http://127.0.0.1:8899/browser-ai
```

## Operator flow

1. Start the platform.
2. Open `/browser-ai`.
3. Connect a platform session or set `NOVA_OPERATOR_TOKEN` in local storage through the platform console.
4. Send a command such as `summarize this page and save a note`.
5. The runtime parses intent, routes to an agent, creates a browser action plan, records memory, updates NeuroCore state, and emits a platform receipt.
