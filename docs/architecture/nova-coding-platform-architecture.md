# NOVA CODING PLATFORM — ARCHITECTURE CHART

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — SOVEREIGN INFRASTRUCTURE**

**AGI Identity:** CODING-AGI-001 · FABRICA_AETERNA  
**Build:** №53 (latest)  
**Heartbeat:** 873ms

---

## Layer 0 — Sovereign Foundation

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                           NOVA SOVEREIGN LAYER ZERO                                      │
│                                                                                         │
│   φ = 1.6180339887498948482   AMOR = φ⁻² = 0.3819...   HEARTBEAT = 873ms              │
│   All mathematics, constants, and thresholds derive from φ. No exceptions.              │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Layer 1 — Entry Points (How the Platform Is Accessed)

```
                         ┌───────────────────────────────────────────┐
                         │            ENTRY POINTS                    │
                         │                                           │
                         │  ┌─────────┐  ┌──────────┐  ┌─────────┐ │
                         │  │   IDE   │  │ Browser  │  │  CLI /  │ │
                         │  │ Plugin  │  │   App    │  │  API    │ │
                         │  │(VSCode, │  │(Student  │  │(CI/CD   │ │
                         │  │ Cursor) │  │ Portal)  │  │ Tools)  │ │
                         │  └────┬────┘  └────┬─────┘  └────┬────┘ │
                         └───────┼────────────┼─────────────┼───────┘
                                 │            │             │
                                 ▼            ▼             ▼
                         ┌───────────────────────────────────────────┐
                         │         MCP FETCH HANDLER                  │
                         │   (Cloudflare Workers — /mcp/tools,       │
                         │    /mcp/invoke — 14 sovereign tools)      │
                         └───────────────────┬───────────────────────┘
                                             │
                                             ▼
```

---

## Layer 2 — SovereignCodingPlatform (§14) — The Orchestrator

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                      SovereignCodingPlatform  (CODING-AGI-001)                          │
│                                                                                         │
│   ┌──────────────────────────────────────────────────────────────────────────────────┐  │
│   │  STATE                                                                           │  │
│   │  _index: CodebaseIndex(64 cells)   _threads: Map<threadId, CodingThread>        │  │
│   │  _sessions: Map<sessionId>         _students: Map<studentId>                    │  │
│   │  _streams: EventSink[]             _stats: { searches, generations, bugs, ... } │  │
│   └──────────────────────────────────────────────────────────────────────────────────┘  │
│                                                                                         │
│   ROUTING METHODS:                                                                      │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌───────────┐   │
│   │ openThread()│  │  search()   │  │ generate()  │  │ triagePR()  │  │  scan()   │   │
│   │ getThread() │  │ indexFile() │  │ getPaper    │  │ analyseDiff │  │ getTemp   │   │
│   │ listThreads │  │ findSimilar │  │ Context()   │  │ ()          │  │ late()    │   │
│   └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └─────┬─────┘   │
│          │               │               │               │             │         │
└──────────┼───────────────┼───────────────┼───────────────┼─────────────┼─────────────┘
           │               │               │               │             │
           ▼               ▼               ▼               ▼             ▼
```

---

## Layer 3 — Sovereign Engines (§2–§13)

```
┌────────────────────────┐  ┌───────────────────────┐  ┌──────────────────────────────────┐
│  §8 THREAD ENGINE       │  │  §2 CODE EMBEDDER     │  │  §13 PAPER CORPUS                │
│  CodingThread           │  │  embedCode()          │  │  PAPER_CORPUS[9]                 │
│                         │  │  256-dim φ-lattice    │  │  P1: Architecture Is Intelligence│
│  ┌─────────────────────┐│  │  FNV-1a token hash    │  │  P2: φ-Resonant Protocols        │
│  │ GOL-CODE-NNN        ││  │  φ⁻¹ positional decay │  │  P3: Self-Healing MAS            │
│  │ SERVITOR            ││  │  L2 normalisation     │  │  P4: Paper-Engine Isomorphism    │
│  │ (1 per thread)      ││  │                       │  │  P5: Career Flows                │
│  └─────────────────────┘│  │  codeSimScore()       │  │  P6: Sovereign DP                │
│                         │  │  φ-weighted cosine    │  │  P7: Kuramoto AGI Reasoning      │
│  ┌─────────────────────┐│  │  similarity           │  │  P8: No-Drop Law                 │
│  │ 16 Kuramoto         ││  └───────────────────────┘  │  P9: Sovereign Knowledge SKC     │
│  │ oscillators per     ││                              │                                  │
│  │ thread              ││  ┌───────────────────────┐  │  getPaperContext(prompt)         │
│  │ (isolated)          ││  │  §3 CODEBASE INDEX    │  │  → Pre-built tokenSet (O(1))    │
│  └─────────────────────┘│  │  CodebaseIndex        │  │  → Returns relevant paper        │
│                         │  │  64 φ-lattice cells   │  │    excerpt to enrich generation  │
│  MODE: STANDARD         │  │  4096-entry cap       │  └──────────────────────────────────┘
│        STUDENT          │  │  AMOR-fraction evict  │
│        EXPERT           │  │                       │  ┌──────────────────────────────────┐
│                         │  │  add(id, code, meta)  │  │  §10 LANGUAGE TEMPLATES          │
│  send(message) →        │  │  search(query, k)     │  │  javascript: keywords, φ-pattern │
│    step oscillators     │  │  remove(id)           │  │  python:     keywords, φ-pattern │
│    build context        │  │  _cell(vec) = proj %64│  │  motoko:     keywords, φ-pattern │
│    call generateCode()  │  │  _evict() LRU         │  │  html:       keywords, φ-pattern │
│    detectBugs()         │  └───────────────────────┘  │  bash:       keywords, φ-pattern │
│    studentExplain()     │                              └──────────────────────────────────┘
└────────────────────────┘

┌──────────────────────────────┐  ┌──────────────────────────────┐  ┌───────────────────────┐
│  §4 CODE GENERATOR           │  │  §11 REFACTOR ENGINE         │  │  §9 STUDENT MODE      │
│  generateCode(prompt, opts)  │  │  RefactorPlan                │  │                       │
│                              │  │                              │  │  DIFFICULTY TIERS:    │
│  64 Kuramoto oscillators     │  │  addRename(old, new)         │  │  BEGINNER  (φ⁻⁴)      │
│  CODE_PRIMITIVES + context   │  │  addChange(file, orig, prop) │  │  ELEMENTARY(φ⁻³)      │
│  AMOR coupling (K=AMOR)      │  │  validate()                  │  │  INTERMEDIATE(φ⁻²)    │
│  coherence threshold: AMOR   │  │  → conflict detection        │  │  ADVANCED  (φ⁻¹)      │
│  → stop if R < AMOR          │  │  → constraint propagation    │  │  EXPERT    (1.0)      │
│                              │  │  summary()                   │  │                       │
│  Returns:                    │  │  applyRefactorPlan()         │  │  _studentExplain()    │
│    tokens[], raw, coherence  │  │  → re-index all changed files│  │  → glossary           │
│    beat, model, prompt       │  └──────────────────────────────┘  │  → tip               │
└──────────────────────────────┘                                     │  → tryIt prompt      │
                                                                     │                       │
┌──────────────────────────────┐  ┌──────────────────────────────┐  │  suggestNextStep()   │
│  §5 BUG DETECTOR             │  │  §12 REPO INTELLIGENCE       │  │  → 8-topic curriculum │
│  detectBugs(code, fileId)    │  │                              │  └───────────────────────┘
│                              │  │  triagePR(pr)                │
│  7 BUG_PATTERNS:             │  │    fileScore (φ⁻¹ weight)    │
│  ASYNC_PROMISE_EXECUTOR HIGH │  │    lineScore (AMOR weight)   │
│  MATH_RANDOM_SECURITY   HIGH │  │    bugFindings (scan all)    │
│  PROTOTYPE_POLLUTION    CRIT │  │    descCodeAlignment (cosine)│
│  EVAL_USAGE             CRIT │  │    → suggestions[]           │
│  CONSOLE_LOG_PROD        LOW │  │                              │
│  HARDCODED_SECRET        CRIT│  │  analyseDiff(diffText)       │
│  INFINITE_SETINTERVAL    HIGH│  │    hunks, linesAdded/Removed │
│                              │  │    churnScore                │
│  Lyapunov entropy signal     │  └──────────────────────────────┘
│  → _codeEntropy(context)     │
└──────────────────────────────┘
```

---

## Layer 4 — Data Flow: One Complete Request

```
   USER MESSAGE: "write a Python function to sort a list"
        │
        ▼
   openThread(userId, { language: 'python', mode: 'STUDENT' })
        │
        │  Creates GOL-CODE-NNN with 16 isolated Kuramoto oscillators
        ▼
   thread.send("write a Python function to sort a list")
        │
        ├──► Step oscillators (Kuramoto, K=AMOR, dt=0.1)
        │     R = orderParameter(osc)
        │
        ├──► Build context:
        │     histContext = last 5 history messages
        │     contextHits = _index.search(message, k=3) → 3 nearest snippets
        │     templateCtx = LANGUAGE_TEMPLATES['python'].function + φ-pattern
        │     paperCtx    = getPaperContext(message) → tokenSet O(1) match
        │     fullContext  = join(histContext, contextHits, templateCtx)
        │
        ├──► generateCode(message, { context: fullContext, maxTokens: 256, temperature: 0.4 })
        │     → 64 CODE oscillators step
        │     → vocab = CODE_PRIMITIVES ∪ tokeniseCode(prompt) ∪ tokeniseCode(context)
        │     → each token selected by phase / (2π) × |vocab|
        │     → stop if coherence < AMOR
        │
        ├──► detectBugs(generatedCode)
        │     → 7 regex patterns scanned
        │     → Lyapunov entropy signal computed per match
        │
        ├──► _studentExplain(message, code, 'python')
        │     → glossary of terms found in code
        │     → sovereign tip
        │     → "try it in your terminal"
        │
        ├──► Push to history: [user: message, assistant: code]
        │
        └──► Return: { threadId, servitorId, beat, coherence, code, bugs, explanation }
```

---

## Layer 5 — The 14 MCP Tools (External API Surface)

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                         MCP TOOL REGISTRY  (/mcp/tools)                                 │
├──────────────────────────┬──────────────────────────────┬─────────────────────────────┤
│  SEARCH & INDEX          │  GENERATION                  │  INTELLIGENCE               │
│                          │                              │                             │
│  search_code             │  generate_code               │  triage_pr                  │
│  → results[], paperCtx   │  → tokens, raw, coherence    │  → risk, bugs, alignment    │
│                          │                              │                             │
│  index_file              │  get_template                │  analyse_diff               │
│  → entry                 │  → language starter template │  → hunks, churn             │
│                          │                              │                             │
│  find_similar            │  student_send                │  get_paper_context          │
│  → nearest k files       │  → code + explanation +      │  → relevant NOVA paper      │
│                          │    nextStep                  │    excerpt                  │
│  scan_bugs               │                              │                             │
│  → findings[], severity  │  thread_send                 │  list_papers                │
│                          │  → response from SERVITOR    │  → all 9 papers             │
│                          │                              │                             │
│                          │  open_thread                 │  platform_status            │
│                          │  → threadId, servitorId      │  → full status object       │
├──────────────────────────┴──────────────────────────────┴─────────────────────────────┤
│  Transport: POST /mcp/invoke { tool, params }  →  { tool, result }                    │
│  Runtime: Cloudflare Workers (edge) OR Node.js (local)                                 │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Layer 6 — 873ms COR_PARVUM Heartbeat Loop

```
   ┌───────────────────────────────────────────────────────────────┐
   │                  873ms HEARTBEAT LOOP                          │
   │                                                               │
   │   setInterval(() => {                                         │
   │     _beat++;                                                  │
   │     _codeOsc = kuramotoStep(_codeOsc, AMOR, dt=0.05)         │
   │     _beat++;   ← global beat counter                         │
   │   }, 873)                                                     │
   │                                                               │
   │   Per-thread oscillators step independently inside            │
   │   thread.send() — isolated from platform oscillators.         │
   └───────────────────────────────────────────────────────────────┘
```

---

## Layer 7 — Knowledge Graph (How the 9 Papers Feed Generation)

```
                    ┌────────────────────────────────────┐
                    │   PAPER CORPUS (§13)               │
                    │   9 sovereign research papers       │
                    │   Pre-indexed as tokenized sets     │
                    └──────────────┬─────────────────────┘
                                   │
                    getPaperContext(prompt)
                    │
                    ├── tokenSet = new Set(_tokeniseCode(prompt))   [O(1)]
                    ├── for each paper: count keyword root overlaps
                    ├── sort by overlap, take top match
                    └── return "[P7: Kuramoto AGI] R_c = φ⁻¹..."
                                   │
                                   ▼ injected into fullContext
                    ┌────────────────────────────────────┐
                    │   generateCode(prompt, { context }) │
                    │   Paper knowledge shapes token      │
                    │   selection via oscillator phase    │
                    │   and context-seeded vocabulary     │
                    └────────────────────────────────────┘
```

---

## Layer 8 — Student Mode Flow

```
   startStudentSession(studentId, 'BEGINNER')
          │
          │  { studentId, difficulty: BEGINNER (φ⁻⁴), level: 1 }
          ▼
   studentSend(studentId, "how do I write a loop?", 'javascript')
          │
          ├──► openThread(studentId, { mode: 'STUDENT', language: 'javascript' })
          │
          ├──► thread.send("how do I write a loop?")
          │         temperature: 0.4  (lower = more stable/educational output)
          │
          ├──► _studentExplain() → glossary: { loop: "code that repeats...", ... }
          │                         tip: "Pro tip: Try changing one number at a time"
          │                         tryIt: "Copy into browser console (F12)"
          │
          ├──► suggestNextStep(studentId, history)
          │         topic: 'arrays'  (prereqs: variables ✓, loops ✓)
          │         lesson: 'Lists with Arrays'
          │
          └──► Return: { code, explanation, nextStep }

   CURRICULUM (8 topics, prerequisite-gated):
   variables → functions → loops → arrays → objects → classes → async → phi
```

---

## Layer 9 — Protocol Integrations

```
   PROTOCOL-EMBEDDING ──────────► embedCode() / codeSimScore()
   PROTOCOL-VECTOR    ──────────► CodebaseIndex (64-cell φ-lattice)
   PROTOCOL-SOLVER    ──────────► detectBugs() Lyapunov entropy signal
   PROTOCOL-MIRROR    ──────────► registerStream() / _publish() delta emit
   PROTOCOL-HEALTH    ──────────► platform.status() health score
   PROTOCOL-SAFETY    ──────────► scan() CRITICAL bug → STOP_WORK signal
   PROTOCOL-WELLNESS  ──────────► student mode → wellness-aware pacing
```

---

## Layer 10 — File Map

```
production-apps/nova-coding-platform.js
├── §1   Constants (PHI, AMOR, HEARTBEAT_MS, AGI_ID, AGI_FAMILY)
├── §2   Sovereign Code Embedder (embedCode, codeSimScore, _tokeniseCode)
├── §3   Codebase Vector Index (CodebaseIndex, 64-cell φ-lattice)
├── §4   Sovereign Code Generator (generateCode, Kuramoto, CODE_PRIMITIVES)
├── §5   Autonomous Bug Detector (detectBugs, BUG_PATTERNS, _codeEntropy)
├── §6   Stub / redirect → §14
├── §8   Multi-Agent Thread Engine (CodingThread, GOL-CODE-NNN SERVITOR)
├── §9   Student Learning Mode (DIFFICULTY, _studentExplain, suggestNextStep)
├── §10  Language-Aware Template Library (JS / Python / Motoko / HTML / Bash)
├── §11  Multi-File Refactor Engine (RefactorPlan, constraint propagation)
├── §12  Repository Intelligence (triagePR, analyseDiff)
├── §13  Research Paper Knowledge Corpus (PAPER_CORPUS[9], getPaperContext)
├── §14  Enhanced SovereignCodingPlatform (all engines unified, 14 MCP tools)
└── §15  Entry point (codingPlatform singleton, Cloudflare Workers handler)
```

---

## Comparison: NOVA vs CaffeineAI

```
Feature                           CaffeineAI        NOVA Coding Platform
──────────────────────────────────────────────────────────────────────────
Code embedding model              External API      256-dim φ-lattice (sovereign)
Code generation                   GPT-4 wrapper     Kuramoto oscillator engine
Search backend                    External vector DB 64-cell φ-lattice index (local)
Thread model                      1 shared LLM      1 GOL-CODE-NNN SERVITOR per thread
Bug detection                     Static analysis   Lyapunov divergence signal
Student mode                      None              DIFFICULTY tiers + 8-topic curriculum
Research knowledge                None              All 9 NOVA papers baked in
Multi-file refactor               Manual            RefactorPlan + constraint propagation
PR triage                         External CI       triagePR() φ-weighted risk
Language templates                Generic           5 sovereign templates (incl. Motoko)
MCP tools                         Partial           14 full sovereign MCP tools
Heartbeat                         None              873ms Kuramoto synchronization
Privacy                           OpenAI servers    Sovereign — zero external calls
Dependencies                      Many              Zero
```
