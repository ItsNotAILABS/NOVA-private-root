# Paper 02 — Browser Intelligence Public-Safe Charter

**Status:** internal-to-public release charter  
**Source surface inspected:** `FreddyCreates/potential-succotash` public repository  
**Public-safe objective:** convert existing browser AI work into clear, usable, marketable documentation without exposing private NOVA internals  
**Format:** 12 page-equivalent sections

---

## Page 1 — Release Position

The public browser intelligence system should be positioned as a local-first AI browser platform: a browser extension, desktop-capable project, offline AI surface, research assistant, memory system, security awareness layer, and developer organism. The existing repository already describes Sonic Ninja / Vigil AI as a browser-side platform with offline Solus inference, 22 panels, autonomous agents, memory, SentryAI, knowledge graph, PDF/Excel export, and local installation flows. The release task is not to invent the product; it is to make the story safer, clearer, and easier to install.

The public release must be grounded in code-backed features and avoid unsupported claims. Words like "sovereign" can stay as brand language, but the functional promise should be: local-first browser intelligence that helps users read, research, organize, and protect their browsing workflow.

## Page 2 — Public Claims Boundary

Public copy may claim local-first operation where code supports it, browser extension packaging where build artifacts exist, and offline AI where Solus/offscreen model routing exists. Public copy should not claim certified security, guaranteed protection, legal advice, medical advice, financial results, or total privacy beyond the actual architecture. The public release can say: "designed to keep core workflows local" and "no cloud requirement for core offline features." It should avoid saying: "no data ever leaves" unless every optional connector, worker, and remote feature is clearly disabled or documented.

```md
Safe: local-first browser intelligence.
Safe: optional integrations are documented separately.
Unsafe: certified security system.
Unsafe: guaranteed private for all flows.
Unsafe: autonomous defense against all threats.
```

## Page 3 — Browser Product Surface

The main public product is the browser side panel. It should be presented as the user's command surface for chat, Solus, memory, sentry scanning, highlights, graph, agents, journal, files, vault, prompts, workspace, search, tabs, and logs. The public documentation should explain the surface in user language first and developer language second.

The user should understand in one minute: install extension, open panel, summarize current page, save memory, ask about highlighted text, run a research agent, and export a report. That is the adoption path.

## Page 4 — Solus Offline AI Surface

Solus is the strongest public-safe technical pillar. It can be described as an offline browser AI engine using local model execution for summarization, classification, and question answering. The README already describes an offscreen document pattern to keep the service worker lean. The public release should turn that into a clear diagram and developer note.

```ts
async function askSolus(context: string, question: string) {
  return chrome.runtime.sendMessage({
    action: '_solus_answer',
    context,
    question
  });
}
```

The release promise: core AI reading tasks can run locally after model setup. The boundary: optional online connectors, workers, and external APIs must be described separately.

## Page 5 — Memory and Knowledge

Memory Palace, highlights, notes, documents, graph, and temple entries are user-facing concepts that should be consolidated into a single "Knowledge Layer" chapter. The public docs should explain what is stored, where it is stored, how users clear it, and how exports work.

The marketing claim should be practical: "Turn browsing into a searchable personal knowledge base." This is stronger and safer than claiming consciousness, permanent agency, or guaranteed perfect recall.

## Page 6 — Agents and Research

The repository describes researcher, crawler, scraper, scout, digest, monitor, analyst, and sweep agents. The public release should show them as operator-triggered research automations. The safe frame is: agents help gather, compare, and summarize public information; the user remains responsible for checking outputs and obeying site terms.

```json
{
  "agent": "researcher",
  "allowed": ["public page summarization", "topic research", "link map", "structured extraction"],
  "denied": ["credentialed scraping", "bypass", "evasion", "unauthorized access"]
}
```

## Page 7 — Security and Sentry

SentryAI should be described as a browser safety awareness layer, not a certified security appliance. Public-safe language: phishing indicators, suspicious content cues, PII awareness, injection-pattern warnings, and user alerts. Avoid guarantees. Include a disclaimer that it is an assistive tool, not a replacement for endpoint protection, enterprise security tooling, or professional incident response.

CAIN can be used internally to review this language before public release.

## Page 8 — Developer Architecture

The developer docs should include repository structure, extension build commands, offscreen AI pattern, storage boundaries, worker integrations, and packaging. Keep the developer story compact: install dependencies, run tests, build extension, load unpacked, build desktop, and inspect logs.

```bash
git clone https://github.com/FreddyCreates/potential-succotash.git
cd potential-succotash
npm install
npm run lint
npm test
npm run build
```

## Page 9 — Public Release Artifacts

A public release should include README, PUBLIC_RELEASE, INSTALL, OPERATOR_GUIDE, PRIVACY_BOUNDARY, SECURITY_BOUNDARY, ROADMAP, and MANIFEST. The manifest should list features, safe claims, denied claims, build surfaces, and known limitations.

```json
{
  "public_product": "Sonic Ninja Browser Intelligence",
  "safe_claims": ["local-first", "browser side panel", "offline AI modes", "research automation"],
  "requires_proof": ["test counts", "packaged downloads", "security claims", "worker deployment"]
}
```

## Page 10 — Bridge to NOVA Root

The public browser repo should not expose private root internals. It can expose a public-safe bridge manifest that says: this product can be governed by NOVA/CAIN/ORO internally, but the public user only receives product documentation, install guides, and safe capability descriptions. The bridge is a boundary, not a tunnel.

Private root owns: organism routing, internal gate logic, release approval, receipts, and internal cyber review. Public repo owns: product surface, install flows, user docs, build instructions, and public roadmap.

## Page 11 — Marketing Foundation

The marketing foundation should say: "Your local-first AI browser workspace for reading, researching, remembering, and organizing the web." Add secondary pillars: Offline AI, Memory Palace, Sentry Awareness, Research Agents, Knowledge Graph, Export Tools, Developer Extensibility.

Avoid overloading first-time users with every internal name. NOVA/CAIN/ORO can stay internal. Public users need Sonic Ninja / Vigil AI, clear install steps, screenshots, and examples.

## Page 12 — Release Acceptance

The public release is ready when the repo contains install docs, safe product claims, privacy boundary, security boundary, feature manifest, and a launch checklist. The next production step is packaging screenshots, confirming build artifacts, and turning the public docs into a GitHub release page.
