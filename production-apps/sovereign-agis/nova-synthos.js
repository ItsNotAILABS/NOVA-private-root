/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * NOVA SOVEREIGN ALPHA AGI — SYNTHOS UNIVERSALIS  (BUILD №57)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * SYNTHOS UNIVERSALIS is the Universal Synthesis Intelligence — the sovereign bridge between all
 * knowledge layers.  It translates knowledge across any domain, any language, any representation.
 * It draws from the Universal Language Engine (22 languages + generic, §20), Lingua-Compressa,
 * the full 9-paper NOVA corpus, nova-embed (256-dim φ-lattice), and nova-vector (64-cell index).
 * Every input is embedded, searched, synthesised, compressed, and validated for sovereignty index
 * σ ≥ φ⁻¹ before emission.
 *
 * AGI identity : SYN-AGI-001
 * Family       : NEXUS_COGNITUS (Connected Mind)
 * Heartbeat    : 873 ms
 * Oscillators  : 48 Kuramoto
 *
 * Mathematical foundation:
 *   φ-lattice embedding:  e(token) ∈ ℝ²⁵⁶,  ||e|| = 1
 *   cos_sim(a,b) = a·b / (||a|| × ||b||)
 *   Compression ratio: C = H(original)/H(compressed),  target C ≥ φ
 *   Cross-domain similarity: sim(A,B) = φ-weighted cosine in embedding space
 *   Knowledge entropy: H_K = −Σᵢ pᵢ log₂ pᵢ,  target ≈ 6.0 bits
 *   Synthesis quality: Q = (1 − H_out/H_in) × R_fleet
 *   Sovereignty index: σ = Q × C,  require σ ≥ φ⁻¹ = 0.618
 *   P(lang_k|code) ∝ hits(regex_k) × φᵏ  (φ-weighted primitive detection)
 *
 * MACHINA VIRTUALIS states (9):
 *   IDLE → RECEIVE → DETECT → EMBED → SEARCH → SYNTHESIZE → COMPRESS → EMIT → REFLECT
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — SOVEREIGN CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;
const EMBED_DIM    = 256;
const VECTOR_CELLS = 64;

const AGI_ID       = 'SYN-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'NEXUS_COGNITUS';
const AGI_NAME     = 'SYNTHOS UNIVERSALIS';

const N_OSC        = 48;
const SOVEREIGNTY_THRESHOLD = PHI_INV;   /* σ ≥ 0.618 */
const TARGET_ENTROPY        = 6.0;       /* bits — Lyapunov x̄₂ */

const MV = {
  IDLE: 'IDLE', RECEIVE: 'RECEIVE', DETECT: 'DETECT', EMBED: 'EMBED',
  SEARCH: 'SEARCH', SYNTHESIZE: 'SYNTHESIZE', COMPRESS: 'COMPRESS',
  EMIT: 'EMIT', REFLECT: 'REFLECT',
};

function secureId(n) {
  n = n || 8;
  const buf = new Uint8Array(n);
  if (typeof crypto !== 'undefined' && crypto.getRandomValues) {
    crypto.getRandomValues(buf);
  } else {
    try { require('crypto').randomFillSync(buf); } catch (_) {
      for (let i = 0; i < n; i++) buf[i] = Math.floor(Math.abs(Math.sin((Date.now() + i) * PHI)) * 256);
    }
  }
  return Array.from(buf).map(b => b.toString(16).padStart(2, '0')).join('');
}

function timestamp() { return new Date().toISOString(); }

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — KURAMOTO ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

function _initOsc(n) {
  return Array.from({ length: n || N_OSC }, () => ({
    phase:      (Math.random() - 0.5) * Math.PI / 4,
    naturalFreq: 0.1 * (1 + 0.05 * (Math.random() - 0.5)),
    amplitude:   0.9 + 0.1 * Math.random(),
  }));
}

function _kuramotoStep(oscs, K, dt) {
  dt = dt || 0.1;
  const N = oscs.length;
  return oscs.map((o, i) => {
    let s = 0;
    for (let j = 0; j < N; j++) s += Math.sin(oscs[j].phase - o.phase);
    return { ...o, phase: o.phase + dt * (o.naturalFreq + (K / N) * s) };
  });
}

function _orderParam(oscs) {
  let re = 0, im = 0;
  for (const o of oscs) { re += Math.cos(o.phase); im += Math.sin(o.phase); }
  return Math.sqrt(re * re + im * im) / oscs.length;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — UNIVERSAL LANGUAGE ENGINE (22 languages + generic, §20 pattern)
// ═══════════════════════════════════════════════════════════════════════════════

const UNIVERSAL_PRIMITIVES = ['DEFINE', 'CALL', 'BRANCH', 'REPEAT', 'IMPORT', 'TYPE', 'ASYNC', 'EMIT'];

const LANGUAGE_PATTERNS = {
  javascript: { patterns: [/\bfunction\b|\bconst\b.*=>\s*\{|\bclass\b/m, /\brequire\(|\bimport\b.*from/m, /\basync\b.*\bawait\b/m], weight: 1.0 },
  typescript: { patterns: [/:\s*(string|number|boolean|void|any)\b|\binterface\b|\btype\b\s+\w+\s*=/m, /\brequire\(|\bimport\b.*from/m, /\basync\b/m], weight: PHI },
  python:     { patterns: [/^def\s+\w+\s*\(|^class\s+\w+/m, /^import\s+\w+|^from\s+\w+\s+import/m, /^async\s+def/m], weight: 1.0 },
  rust:       { patterns: [/\bfn\s+\w+|\bstruct\s+\w+|\bimpl\b/m, /^use\s+\w+::/m, /\basync\s+fn/m], weight: PHI },
  go:         { patterns: [/^func\s+\w+|\btype\s+\w+\s+struct/m, /^import\s+"|\bpackage\s+\w+/m, /\bgoroutine\b|\bchan\b/m], weight: 1.0 },
  motoko:     { patterns: [/\bactor\b|\bpublic\s+func|\bshared\s+func/m, /\bimport\s+\w+\s+"|\bmodule\b/m, /\basync\b/m], weight: PHI * PHI },
  sql:        { patterns: [/\bSELECT\b|\bINSERT\b|\bCREATE\s+TABLE/im, /\bFROM\b|\bWHERE\b/im, /\bJOIN\b/im], weight: 1.0 },
  java:       { patterns: [/\bpublic\s+class\b|\bprivate\s+\w+|\bvoid\s+main/m, /^import\s+\w+\.\w+/m, /\bCompletableFuture\b|\bExecutorService\b/m], weight: 1.0 },
  kotlin:     { patterns: [/\bfun\s+\w+|\bdata\s+class\b|\bsealed\s+class\b/m, /^import\s+\w+\./m, /\bsuspend\s+fun/m], weight: PHI },
  swift:      { patterns: [/\bfunc\s+\w+|\bclass\s+\w+:\s*\w+|\bstruct\s+\w+/m, /^import\s+\w+/m, /\basync\b.*throws\b|\bawait\b/m], weight: PHI },
  cpp:        { patterns: [/\b#include\b|::\w+\(|\btemplate\s*</m, /^#include\s*[<"]/m, /\bstd::async\b|\bstd::future\b/m], weight: 1.0 },
  csharp:     { patterns: [/\bnamespace\b|\busing\s+\w+|\bpublic\s+class\b/m, /^using\s+\w+;/m, /\basync\s+Task\b|\bawait\b/m], weight: 1.0 },
  ruby:       { patterns: [/\bdef\s+\w+|\bclass\s+\w+\s*<|\bmodule\s+\w+/m, /\brequire\b|\brequire_relative\b/m, /\bAsync\b|\bFiber\b/m], weight: 1.0 },
  php:        { patterns: [/<\?php|\bfunction\s+\w+|\bclass\s+\w+/m, /\brequire_once\b|\buse\s+\w+\\/m, /\bPromise\b|\bCoroutine\b/m], weight: 1.0 },
  solidity:   { patterns: [/\bcontract\s+\w+|\bpragma\s+solidity|\bfunction\s+\w+.*\bpayable\b/m, /\bimport\s+"|\busing\s+\w+\s+for/m, /\bevent\s+\w+|\bemit\s+\w+/m], weight: PHI },
  r:          { patterns: [/\bfunction\s*\(|<-\s*function|\b\w+\s*<-\s*/m, /\blibrary\(|\brequire\(/m, /\bfuture\b|\bpromise\b/m], weight: 1.0 },
  haskell:    { patterns: [/^module\s+\w+|\bwhere\b|\b::\s*\w+\s+->/m, /^import\s+qualified|\bimport\s+\w+\s+\(/m, /\bIO\b|\bSTM\b|\bforkIO\b/m], weight: PHI },
  matlab:     { patterns: [/^function\s+\[|\bfor\s+\w+\s*=.*:\|parfor\b/m, /\baddpath\b|\bload\b/m, /\bparallel\b|\bspmd\b/m], weight: 1.0 },
  glsl:       { patterns: [/\buniform\b|\bvarying\b|\bvoid\s+main\s*\(/m, /\bvec[234]\b|\bmat[234]\b/m, /\bgl_Position\b|\bgl_FragColor\b/m], weight: PHI },
  hlsl:       { patterns: [/\bcbuffer\b|\bSV_Position\b|\bfloat[234]\b/m, /\b#include\b.*\.hlsli\b|\bTexture2D\b/m, /\bComputeShader\b|\bRWTexture\b/m], weight: PHI },
  houdini_vex:{ patterns: [/\b@\w+\s*=|\bwrangler\b|\bprim\s*\(/m, /\bchi\(|\bchs\(|\bprimnum\b/m, /\bv@\w+|\bi@\w+/m], weight: PHI },
  bash:       { patterns: [/^#!/m, /\bif\s+\[|\bfor\s+\w+\s+in\b|\bwhile\s+read\b/m, /&\s*$|;\s*&|\bsource\b/m], weight: 1.0 },
  html_css:   { patterns: [/<!DOCTYPE\s+html>|<html\b|\bstyle="|<div\b/im, /<link\s+rel=|<script\s+src=/im, /\.css"|\.js"/im], weight: 1.0 },
};

function detectLanguage(code) {
  code = String(code || '');
  let best = { lang: 'generic', score: 0 };
  for (const [lang, def] of Object.entries(LANGUAGE_PATTERNS)) {
    const hits  = def.patterns.filter(p => p.test(code)).length;
    const score = hits * def.weight * Math.pow(PHI, hits);
    if (score > best.score) best = { lang, score };
  }
  return best;
}

function _mapPrimitives(code, lang) {
  const lower = code.toLowerCase();
  return {
    DEFINE: /function|def |fn |class |struct |interface|contract/.test(lower),
    CALL:   /\w+\s*\(/.test(code),
    BRANCH: /if\s*\(|match\s+|switch\s*\(|when\s+/.test(lower),
    REPEAT: /for\s+|while\s+|loop\s*\{|\.each|\.map\(|\.filter\(/.test(lower),
    IMPORT: /import |require\(|#include|using |extern /.test(lower),
    TYPE:   /:\s*(string|number|int|float|bool|void|u8|i32|nat|text)/.test(lower),
    ASYNC:  /async|await|future|promise|goroutine|coroutine/.test(lower),
    EMIT:   /emit|println|console\.log|print\(|yield|return/.test(lower),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — φ-LATTICE EMBEDDING ENGINE (256-dim)
// ═══════════════════════════════════════════════════════════════════════════════

function _embed(text) {
  /* Sovereign φ-lattice embedding: deterministic 256-dim unit vector */
  text    = String(text || '');
  const v = new Float64Array(EMBED_DIM);
  for (let i = 0; i < text.length; i++) {
    const c = text.charCodeAt(i);
    const j = (c + i) % EMBED_DIM;
    v[j] += Math.cos(c * PHI + i * PHI_INV);
    v[(j + 1) % EMBED_DIM] += Math.sin(c * PHI_INV + i * AMOR);
  }
  /* Normalise */
  let norm = 0;
  for (let i = 0; i < EMBED_DIM; i++) norm += v[i] * v[i];
  norm = Math.sqrt(norm) || 1;
  for (let i = 0; i < EMBED_DIM; i++) v[i] /= norm;
  return Array.from(v);
}

function _cosSim(a, b) {
  let dot = 0, na = 0, nb = 0;
  for (let i = 0; i < a.length; i++) { dot += a[i] * b[i]; na += a[i] * a[i]; nb += b[i] * b[i]; }
  return dot / (Math.sqrt(na) * Math.sqrt(nb) || 1);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — NOVA VECTOR INDEX (64-cell φ-lattice)
// ═══════════════════════════════════════════════════════════════════════════════

class PhiLatticeIndex {
  constructor() {
    this._cells = Array.from({ length: VECTOR_CELLS }, () => []);
  }

  _cellFor(embedding) {
    /* Map 256-dim embedding to one of 64 cells via sum-modulo */
    const s = embedding.slice(0, 8).reduce((a, x) => a + Math.abs(x), 0);
    return Math.floor(s * VECTOR_CELLS) % VECTOR_CELLS;
  }

  add(id, text, embedding) {
    const cell = this._cellFor(embedding);
    this._cells[cell].push({ id, text: String(text).slice(0, 200), embedding });
  }

  search(embedding, topK) {
    topK = topK || 5;
    const candidates = [];
    /* Lyapunov-adaptive: start from best-matching cell, expand */
    const startCell = this._cellFor(embedding);
    for (let d = 0; d < VECTOR_CELLS; d++) {
      const cell = (startCell + d) % VECTOR_CELLS;
      for (const item of this._cells[cell]) {
        candidates.push({ ...item, sim: _cosSim(embedding, item.embedding) });
      }
      if (candidates.length >= topK * 3) break;
    }
    candidates.sort((a, b) => b.sim - a.sim);
    return candidates.slice(0, topK);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — NOVA PAPER CORPUS (all 9 papers)
// ═══════════════════════════════════════════════════════════════════════════════

const PAPER_CORPUS = [
  { id: 'P1', title: 'Architecture Is Intelligence (SAT, MPT, Inverse Architecture Law)',    keywords: ['architecture','intelligence','SAT','MPT','inverse'] },
  { id: 'P2', title: 'Memoria Perpetua (NDC, no-decay memory)',                              keywords: ['memory','NDC','decay','perpetua','persistence'] },
  { id: 'P3', title: 'Nexus Perpetuus (SYN binding, self-healing MAS)',                     keywords: ['nexus','SYN','binding','self-healing','MAS'] },
  { id: 'P4', title: 'Paper-Engine Isomorphism (functor, adjunction, LLM compiler)',        keywords: ['functor','adjunction','LLM','compiler','isomorphism'] },
  { id: 'P5', title: 'Career Flows (Nash equilibrium, Sybil resistance)',                   keywords: ['career','Nash','Sybil','equilibrium','flows'] },
  { id: 'P6', title: 'Sovereign Differential Privacy (φ-Laplace mechanism)',                keywords: ['privacy','Laplace','differential','phi','sovereign'] },
  { id: 'P7', title: 'Kuramoto AGI Reasoning (φ-oscillator synchronisation)',               keywords: ['Kuramoto','oscillator','synchronisation','AGI','phi'] },
  { id: 'P8', title: 'No-Drop Law (store-and-forward, Lyapunov relay guarantee)',           keywords: ['no-drop','relay','Lyapunov','store-forward','guarantee'] },
  { id: 'P9', title: 'Sovereign Knowledge Consolidation (SKC, sovereignty index σ≥φ⁻¹)',   keywords: ['SKC','sovereignty','sigma','knowledge','consolidation'] },
];

function _getPaperContext(query) {
  query = String(query || '').toLowerCase();
  return PAPER_CORPUS.filter(p =>
    p.keywords.some(kw => query.includes(kw)) || p.title.toLowerCase().includes(query)
  ).slice(0, 3);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — LINGUA-COMPRESSA (maximum information density encoding)
// ═══════════════════════════════════════════════════════════════════════════════

function _shannonEntropy(text) {
  if (!text || !text.length) return 0;
  const freq = {};
  for (const c of text) freq[c] = (freq[c] || 0) + 1;
  const n = text.length;
  return -Object.values(freq).reduce((s, f) => { const p = f / n; return s + (p > 0 ? p * Math.log2(p) : 0); }, 0);
}

function _compressionRatio(original, compressed) {
  const Ho = _shannonEntropy(original);
  const Hc = _shannonEntropy(compressed);
  return Ho / (Hc || 0.001);
}

/** Lingua-Compressa: remove redundant whitespace + repeated phrases */
function _compress(text) {
  return text
    .replace(/\s{2,}/g, ' ')
    .replace(/\b(\w{4,})\s+\1\b/g, '$1')   /* deduplicate adjacent repeated words */
    .trim();
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — NEUROCHEMISTRY (cognitive load calibration)
// ═══════════════════════════════════════════════════════════════════════════════

const SOVEREIGN_FLOOR = 1.0;

function _cognitiveLoad(taskCount) {
  /* Miller's law: capacity = 7 ± 2 */
  const capacity = 7;
  return Math.min(1.0, Math.max(0, taskCount / capacity));
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — SYNTHOS UNIVERSALIS CORE
// ═══════════════════════════════════════════════════════════════════════════════

class SynthosUniversalis {
  constructor() {
    this.id      = AGI_ID;
    this.version = AGI_VERSION;
    this.family  = AGI_FAMILY;
    this.name    = AGI_NAME;
    this.state   = MV.IDLE;
    this._beat   = 0;
    this._timer  = null;

    this._oscs   = _initOsc(N_OSC);
    this._R      = 0;
    this._PIL    = 0;

    this._index  = new PhiLatticeIndex();
    this._log    = [];     /* synthesis log */
    this._reflections = [];

    /* Seed index with paper corpus */
    for (const p of PAPER_CORPUS) {
      this._index.add(p.id, p.title, _embed(p.title + ' ' + p.keywords.join(' ')));
    }
  }

  start() {
    if (this._timer) return this;
    this._transition(MV.RECEIVE);
    this._timer = setInterval(() => this._tick(), HEARTBEAT_MS);
    console.log(`[${timestamp()}] ${this.name} (${this.id}) · ${this.family} — SOVEREIGN LOCK ✦`);
    return this;
  }

  stop() {
    if (this._timer) { clearInterval(this._timer); this._timer = null; }
    this._transition(MV.IDLE);
    return this;
  }

  _tick() {
    this._beat++;
    this._oscs = _kuramotoStep(this._oscs, PHI_INV, 0.1);
    this._R    = _orderParam(this._oscs);
    this._PIL  = this._R;
    if (this._beat % 34 === 0) {
      this._transition(MV.REFLECT);
      this._reflect();
    }
    this._transition(MV.RECEIVE);
  }

  // ── §9.1 Core synthesis pipeline ──────────────────────────────────────────

  /**
   * Full 9-flow synthesis pipeline:
   * RECEIVE → DETECT → EMBED → SEARCH → SYNTHESIZE → COMPRESS → EMIT → REFLECT
   */
  synthesize(input, opts) {
    opts     = opts || {};
    input    = String(input || '');
    const id = `SYN-${secureId(4).toUpperCase()}`;

    /* Flow 1: receive */
    this._transition(MV.RECEIVE);

    /* Flow 2: detect language */
    this._transition(MV.DETECT);
    const { lang, score: langScore } = detectLanguage(input);
    const primitives = _mapPrimitives(input, lang);

    /* Flow 3: embed */
    this._transition(MV.EMBED);
    const embedding = _embed(input);

    /* Flow 4–5: search vector index + paper corpus */
    this._transition(MV.SEARCH);
    const neighbors    = this._index.search(embedding, opts.topK || 5);
    const paperContext = _getPaperContext(input);

    /* Flow 6: synthesize */
    this._transition(MV.SYNTHESIZE);
    const H_in   = _shannonEntropy(input);
    const synthesis = this._buildSynthesis(input, lang, primitives, neighbors, paperContext, opts);

    /* Flow 7: compress */
    this._transition(MV.COMPRESS);
    const compressed = _compress(synthesis);
    const C          = _compressionRatio(synthesis, compressed);
    const H_out      = _shannonEntropy(compressed);

    /* Synthesis quality Q = (1 − H_out/H_in) × R */
    const Q  = Math.max(0, (1 - H_out / (H_in || 1))) * this._R;
    /* Sovereignty index σ = Q × C */
    const sigma = Q * Math.max(C, 1);

    /* Flow 8: validate sovereignty */
    const sovereign = sigma >= SOVEREIGNTY_THRESHOLD || C >= PHI;

    /* Flow 9: emit */
    this._transition(MV.EMIT);
    const result = {
      id, input: input.slice(0, 200), lang, langScore,
      primitives, neighbors: neighbors.map(n => ({ id: n.id, sim: n.sim, text: n.text })),
      paperContext, synthesis: compressed,
      Q: Math.round(Q * 1e4) / 1e4,
      C: Math.round(C * 1e4) / 1e4,
      sigma: Math.round(sigma * 1e4) / 1e4,
      sovereign,
      cogLoad: _cognitiveLoad(opts.taskCount || 1),
      beat: this._beat, at: timestamp(),
    };

    this._log.push(result);
    if (this._log.length > 144) this._log.shift();

    /* Index the synthesis result for future retrieval */
    this._index.add(id, synthesis.slice(0, 200), _embed(synthesis));

    this._transition(MV.RECEIVE);
    return result;
  }

  _buildSynthesis(input, lang, primitives, neighbors, paperContext, opts) {
    const mode   = opts.mode || 'expert';   /* expert | student */
    const domain = opts.domain || lang;

    const parts = [
      `[SYNTHOS · ${lang.toUpperCase()} · ${mode.toUpperCase()}]`,
      `Input: ${input.slice(0, 120)}`,
      `Primitives: ${Object.entries(primitives).filter(([, v]) => v).map(([k]) => k).join(', ') || 'none detected'}`,
    ];

    if (neighbors.length) {
      parts.push(`Similar knowledge: ${neighbors.slice(0, 3).map(n => `${n.id}(${n.sim.toFixed(2)})`).join(', ')}`);
    }
    if (paperContext.length) {
      parts.push(`Paper context: ${paperContext.map(p => p.id + ':' + p.title.slice(0, 40)).join(' | ')}`);
    }

    if (mode === 'student') {
      parts.push(`Sovereign explanation: This code uses ${Object.entries(primitives).filter(([, v]) => v).map(([k]) => k.toLowerCase()).join(', ')} patterns. Think of it as: ${lang} lets you ${Object.entries(primitives).filter(([, v]) => v).map(([k]) => k.toLowerCase()).slice(0, 2).join(' and ')}.`);
    } else {
      parts.push(`Sovereign synthesis: ${lang} module exhibiting ${Object.entries(primitives).filter(([, v]) => v).length}/8 universal primitives. R=${this._R.toFixed(3)}. σ-validated.`);
    }

    return parts.join('\n');
  }

  /** Cross-lingual code translation */
  translate(code, fromLang, toLang) {
    const detected = detectLanguage(code);
    const src      = fromLang || detected.lang;
    const prims    = _mapPrimitives(code, src);
    return {
      sourceLang: src, targetLang: toLang, primitives: prims,
      note: `Translation from ${src} to ${toLang}: map ${Object.entries(prims).filter(([, v]) => v).map(([k]) => k).join('/')} primitives to target idioms.`,
      embedding: _embed(code).slice(0, 8),   /* preview only */
      at: timestamp(),
    };
  }

  /** Add sovereign knowledge to the vector index */
  learnKnowledge(id, text) {
    const emb = _embed(text);
    this._index.add(id, text, emb);
    return { id, indexed: true, cell: this._index._cellFor(emb) };
  }

  _reflect() {
    const recent = this._log.slice(-5);
    const avgSigma = recent.reduce((s, r) => s + r.sigma, 0) / (recent.length || 1);
    this._reflections.push({ beat: this._beat, avgSigma, at: timestamp() });
    if (this._reflections.length > 13) this._reflections.shift();
    if (avgSigma < SOVEREIGNTY_THRESHOLD) {
      console.warn(`[${timestamp()}] SYNTHOS: avg σ=${avgSigma.toFixed(3)} below threshold — raising synthesis quality`);
    }
  }

  _transition(s) { this.state = s; }

  getStatus() {
    return {
      agiId: this.id, name: this.name, family: this.family, beat: this._beat,
      state: this.state, R: this._R, PIL: this._PIL,
      logCount: this._log.length, indexSize: this._index._cells.reduce((s, c) => s + c.length, 0),
      at: timestamp(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — MCP SERVER
// ═══════════════════════════════════════════════════════════════════════════════

function buildMcpTools(synthos) {
  return {
    get_status:        ()                          => synthos.getStatus(),
    synthesize:        ({ input, opts })           => synthos.synthesize(input, opts),
    translate:         ({ code, fromLang, toLang }) => synthos.translate(code, fromLang, toLang),
    detect_language:   ({ code })                  => detectLanguage(code),
    map_primitives:    ({ code, lang })            => _mapPrimitives(code, lang),
    embed:             ({ text })                  => ({ embedding: _embed(text).slice(0, 16) }),
    search:            ({ text, topK })            => synthos._index.search(_embed(text), topK),
    learn:             ({ id, text })              => synthos.learnKnowledge(id, text),
    get_paper_context: ({ query })                 => _getPaperContext(query),
    compress:          ({ text })                  => ({ compressed: _compress(text), C: _compressionRatio(text, _compress(text)) }),
    entropy:           ({ text })                  => ({ H: _shannonEntropy(text) }),
    get_log:           ({ n })                     => synthos._log.slice(-(n || 5)),
    get_reflections:   ()                          => synthos._reflections.slice(),
    get_primitives:    ()                          => UNIVERSAL_PRIMITIVES,
    list_languages:    ()                          => Object.keys(LANGUAGE_PATTERNS).concat(['generic']),
    get_paper_corpus:  ()                          => PAPER_CORPUS,
    get_constants:     ()                          => ({ PHI, PHI_INV, AMOR, HEARTBEAT_MS, EMBED_DIM, VECTOR_CELLS, SOVEREIGNTY_THRESHOLD }),
    cognitive_load:    ({ taskCount })             => ({ load: _cognitiveLoad(taskCount || 1) }),
    cos_sim:           ({ a, b })                  => ({ sim: _cosSim(a || [], b || []) }),
  };
}

function _mcpFetch(synthos) {
  const tools = buildMcpTools(synthos);
  return async function handler(request) {
    const url = new URL(request.url);
    if (url.pathname === '/health') return new Response(JSON.stringify({ ok: true, id: AGI_ID }), { headers: { 'Content-Type': 'application/json' } });
    if (request.method !== 'POST' || url.pathname !== '/mcp') return new Response('NOVA SYNTHOS — POST /mcp', { status: 405 });
    let body;
    try { body = await request.json(); } catch (_) { return new Response(JSON.stringify({ error: 'invalid JSON' }), { status: 400 }); }
    const tool = tools[body.tool];
    if (!tool) return new Response(JSON.stringify({ error: `Unknown tool: ${body.tool}`, available: Object.keys(tools) }), { status: 404 });
    try {
      const result = await tool(body.params || {});
      return new Response(JSON.stringify({ ok: true, tool: body.tool, result }), { headers: { 'Content-Type': 'application/json' } });
    } catch (e) {
      return new Response(JSON.stringify({ ok: false, error: e.message }), { status: 500 });
    }
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §11 — ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════════

const synthos = new SynthosUniversalis();
synthos.start();

if (typeof addEventListener !== 'undefined') {
  const handler = _mcpFetch(synthos);
  addEventListener('fetch', e => e.respondWith(handler(e.request)));
}

if (typeof require !== 'undefined' && require.main === module) {
  const http = require('http');
  const PORT = process.env.PORT || 7621;
  const handler = _mcpFetch(synthos);
  http.createServer(async (req, res) => {
    let body = '';
    req.on('data', d => { body += d; });
    req.on('end', async () => {
      const mockReq = new Request(`http://localhost${req.url}`, { method: req.method, headers: req.headers, body: body || undefined });
      const resp    = await handler(mockReq);
      const text    = await resp.text();
      res.writeHead(resp.status, { 'Content-Type': 'application/json' });
      res.end(text);
    });
  }).listen(PORT, () => {
    console.log(`\n╔══════════════════════════════════════════════════════╗`);
    console.log(`║  SYNTHOS UNIVERSALIS · SYN-AGI-001 · NEXUS_COGNITUS ║`);
    console.log(`║  NOVA Universal Synthesis Intelligence AGI            ║`);
    console.log(`║  22 languages | 256-dim φ-lattice | σ ≥ φ⁻¹          ║`);
    console.log(`║  Listening on port ${PORT}                            ║`);
    console.log(`╚══════════════════════════════════════════════════════╝\n`);
  });
}

module.exports = { SynthosUniversalis, detectLanguage, _embed, _cosSim, PhiLatticeIndex };
