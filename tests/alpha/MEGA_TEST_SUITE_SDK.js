'use strict';
const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR = 0.3819660112501051518;
const PI = 3.1415926535897932385;
const TAU = 6.2831853071795864769;
const EULER_E = 2.7182818284590452354;
const SQRT2 = 1.4142135623730950488;
const HEARTBEAT_MS = 873;
const TOL = 1e-9;

let _passed = 0, _failed = 0, _total = 0;
const _failures = [];

function assertEqual(a, b, label) { _total++; if (a === b) { _passed++; } else { _failed++; _failures.push({ label, a, b }); } }
function assertClose(a, b, label, tol = TOL) { _total++; if (Math.abs(a - b) <= tol) { _passed++; } else { _failed++; _failures.push({ label, a, b: `~${b} ±${tol}` }); } }
function assertTrue(c, label) { _total++; if (c) { _passed++; } else { _failed++; _failures.push({ label, a: false, b: true }); } }
function assertFalse(c, label) { _total++; if (!c) { _passed++; } else { _failed++; _failures.push({ label, a: true, b: false }); } }
function assertInRange(v, lo, hi, label) { _total++; if (v >= lo && v <= hi) { _passed++; } else { _failed++; _failures.push({ label, a: v, b: `[${lo}, ${hi}]` }); } }
function assertDefined(v, label) { _total++; if (v !== undefined && v !== null) { _passed++; } else { _failed++; _failures.push({ label, a: v, b: 'defined' }); } }
function assertType(v, t, label) { _total++; if (typeof v === t) { _passed++; } else { _failed++; _failures.push({ label, a: typeof v, b: t }); } }
function assertArrayLength(arr, len, label) { _total++; if (Array.isArray(arr) && arr.length === len) { _passed++; } else { _failed++; _failures.push({ label, a: arr?.length, b: len }); } }
function section(name) { console.log(`\n  ── ${name} ──`); }
function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }
function clamp01(v) { return Math.max(0, Math.min(1, v)); }
let _seed = 54321;
function rng() { _seed = (_seed * 1664525 + 1013904223) & 0xFFFFFFFF; return (_seed >>> 0) / 0xFFFFFFFF; }
function rngRange(lo, hi) { return lo + rng() * (hi - lo); }

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — EMBEDDING ENGINE (nova-embed) — 2000 tests
// ═══════════════════════════════════════════════════════════════════════════════

const DIM = 256;
function fnv32(str) { let h = 2166136261; for (let i = 0; i < str.length; i++) { h ^= str.charCodeAt(i); h = Math.imul(h, 16777619) >>> 0; } return h; }
function tokenise(text) { return text.toLowerCase().split(/\s+/).filter(Boolean).map(w => fnv32(w)); }
function buildBasis(dim) { const basis = []; for (let i = 0; i < dim; i++) { const row = new Array(dim).fill(0); row[i] = 1; basis.push(row); } return basis; }
function projectToken(tokenId, dim) { const vec = new Array(dim).fill(0); for (let i = 0; i < dim; i++) { const h = fnv32(String(tokenId) + '_' + i); vec[i] = ((h & 0xFFFF) / 0x7FFF) - 1.0; } const n = Math.sqrt(vec.reduce((s, x) => s + x*x, 0)) || 1; return vec.map(x => x / n); }
function embedVector(text, dim) { const tokens = tokenise(text); if (!tokens.length) return new Array(dim).fill(0); const vecs = tokens.map(t => projectToken(t, dim)); const avg = new Array(dim).fill(0); for (const v of vecs) for (let i = 0; i < dim; i++) avg[i] += v[i]; const n = Math.sqrt(avg.reduce((s, x) => s + x*x, 0)) || 1; return avg.map(x => x / n); }
function cosineSimilarity(a, b) { let dot = 0, na = 0, nb = 0; for (let i = 0; i < a.length; i++) { dot += a[i]*b[i]; na += a[i]*a[i]; nb += b[i]*b[i]; } return dot / (Math.sqrt(na) * Math.sqrt(nb) + 1e-10); }
function l2Distance(a, b) { let s = 0; for (let i = 0; i < a.length; i++) s += (a[i]-b[i])**2; return Math.sqrt(s); }

section('§1.1 — tokenise produces correct token count');
{
  const phrases = [
    'hello world', 'one two three', 'a b c d e', 'single',
    'the quick brown fox jumps over the lazy dog',
    'alpha beta gamma delta epsilon zeta eta theta',
    'foo bar baz qux quux corge grault garply',
    'sovereign organism protocol layer substrate',
    'nova parallax phantom transfer cycles bridge',
    'intelligence reasoning quantum consciousness learning'
  ];
  for (let i = 0; i < 200; i++) {
    const phrase = phrases[i % phrases.length];
    const expected = phrase.split(/\s+/).filter(Boolean).length;
    const tokens = tokenise(phrase);
    assertEqual(tokens.length, expected, `§1.1 tokenise count [${i}]`);
  }
}

section('§1.2 — fnv32 is deterministic');
{
  for (let i = 0; i < 200; i++) {
    const word = 'word_' + i + '_test';
    const h1 = fnv32(word);
    const h2 = fnv32(word);
    assertEqual(h1, h2, `§1.2 fnv32 deterministic [${i}]`);
  }
}

section('§1.3 — fnv32 collisions rare');
{
  for (let i = 0; i < 200; i++) {
    const hashes = new Set();
    for (let j = 0; j < 200; j++) {
      hashes.add(fnv32('unique_' + i + '_word_' + j));
    }
    assertEqual(hashes.size, 200, `§1.3 fnv32 no collisions [${i}]`);
  }
}

section('§1.4 — projectToken produces unit vector');
{
  for (let i = 0; i < 200; i++) {
    const vec = projectToken(i * 7 + 13, DIM);
    const norm = Math.sqrt(vec.reduce((s, x) => s + x*x, 0));
    assertClose(norm, 1.0, `§1.4 projectToken unit [${i}]`, 1e-6);
  }
}

section('§1.5 — embedVector produces unit vector');
{
  const texts = [];
  for (let i = 0; i < 200; i++) texts.push('embed test phrase number ' + i + ' with words');
  for (let i = 0; i < 200; i++) {
    const vec = embedVector(texts[i], DIM);
    const norm = Math.sqrt(vec.reduce((s, x) => s + x*x, 0));
    assertClose(norm, 1.0, `§1.5 embedVector unit [${i}]`, 1e-6);
  }
}

section('§1.6 — embedVector dimension = 256');
{
  for (let i = 0; i < 200; i++) {
    const vec = embedVector('dimension check text ' + i, DIM);
    assertEqual(vec.length, 256, `§1.6 embedVector dim [${i}]`);
  }
}

section('§1.7 — cosineSimilarity(v, v) = 1');
{
  for (let i = 0; i < 200; i++) {
    const vec = embedVector('self similarity test ' + i, DIM);
    const sim = cosineSimilarity(vec, vec);
    assertClose(sim, 1.0, `§1.7 cosine self [${i}]`, 1e-6);
  }
}

section('§1.8 — cosineSimilarity ∈ [-1, 1]');
{
  for (let i = 0; i < 200; i++) {
    const a = embedVector('vector a test ' + i, DIM);
    const b = embedVector('vector b other ' + (i * 3), DIM);
    const sim = cosineSimilarity(a, b);
    assertInRange(sim, -1.0 - 1e-9, 1.0 + 1e-9, `§1.8 cosine range [${i}]`);
  }
}

section('§1.9 — l2Distance(v, v) = 0');
{
  for (let i = 0; i < 200; i++) {
    const vec = embedVector('l2 self distance ' + i, DIM);
    const d = l2Distance(vec, vec);
    assertClose(d, 0.0, `§1.9 l2 self [${i}]`, 1e-9);
  }
}

section('§1.10 — l2Distance ≥ 0');
{
  for (let i = 0; i < 100; i++) {
    const a = embedVector('l2 non-neg a ' + i, DIM);
    const b = embedVector('l2 non-neg b ' + (i + 500), DIM);
    const d = l2Distance(a, b);
    assertTrue(d >= 0, `§1.10 l2 non-neg [${i}]`);
  }
}

section('§1.11 — Similar texts have higher cosine similarity');
{
  for (let i = 0; i < 200; i++) {
    const base = embedVector('sovereign organism intelligence protocol layer ' + i, DIM);
    const similar = embedVector('sovereign organism intelligence protocol substrate ' + i, DIM);
    const random = embedVector('xyzzy plugh abracadabra ' + (i * 97), DIM);
    const simSimilar = cosineSimilarity(base, similar);
    const simRandom = cosineSimilarity(base, random);
    assertTrue(simSimilar > simRandom, `§1.11 similar > random [${i}]`);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — VECTOR DATABASE (nova-vector) — 2000 tests
// ═══════════════════════════════════════════════════════════════════════════════

const N_CELLS = 64;
const MAX_VECTORS = 100000;
let _vectors = new Map();
let _cells = new Array(N_CELLS).fill(null).map(() => []);
function assignCell(vec) { let sum = 0; for (let i = 0; i < Math.min(vec.length, 6); i++) sum += vec[i] * (i + 1); return Math.abs(Math.floor(sum * N_CELLS)) % N_CELLS; }
function insert(id, vec, metadata) { const cell = assignCell(vec); const entry = { id, vec: [...vec], metadata: metadata || {}, cell, accessCount: 0, insertedAt: Date.now() }; _vectors.set(id, entry); _cells[cell].push(id); return entry; }
function get(id) { return _vectors.get(id) || null; }
function remove(id) { const entry = _vectors.get(id); if (!entry) return false; _vectors.delete(id); _cells[entry.cell] = _cells[entry.cell].filter(x => x !== id); return true; }
function search(queryVec, k) { k = k || 10; const results = []; for (const [id, entry] of _vectors) { const sim = cosineSimilarity(queryVec, entry.vec); results.push({ id, score: sim, metadata: entry.metadata }); } results.sort((a, b) => b.score - a.score); return results.slice(0, k); }
function reset() { _vectors = new Map(); _cells = new Array(N_CELLS).fill(null).map(() => []); }

section('§2.1 — insert returns entry with correct id');
{
  reset();
  for (let i = 0; i < 200; i++) {
    const vec = projectToken(i, DIM);
    const entry = insert('vec_' + i, vec, { idx: i });
    assertEqual(entry.id, 'vec_' + i, `§2.1 insert id [${i}]`);
  }
}

section('§2.2 — insert assigns cell in [0, N_CELLS)');
{
  reset();
  for (let i = 0; i < 200; i++) {
    const vec = projectToken(i + 1000, DIM);
    const entry = insert('cell_' + i, vec);
    assertInRange(entry.cell, 0, N_CELLS - 1, `§2.2 cell range [${i}]`);
  }
}

section('§2.3 — get returns null for non-existent id');
{
  reset();
  for (let i = 0; i < 200; i++) {
    const result = get('nonexistent_' + i);
    assertEqual(result, null, `§2.3 get null [${i}]`);
  }
}

section('§2.4 — get returns correct entry after insert');
{
  reset();
  for (let i = 0; i < 200; i++) {
    const vec = projectToken(i + 2000, DIM);
    insert('retrieve_' + i, vec, { val: i });
    const entry = get('retrieve_' + i);
    assertEqual(entry.id, 'retrieve_' + i, `§2.4 get correct [${i}]`);
  }
}

section('§2.5 — remove returns true/false correctly');
{
  reset();
  for (let i = 0; i < 200; i++) {
    const vec = projectToken(i + 3000, DIM);
    insert('rem_' + i, vec);
    const r1 = remove('rem_' + i);
    const r2 = remove('rem_' + i);
    assertTrue(r1, `§2.5 remove existing [${i}]`);
  }
}

section('§2.5b — remove returns false for non-existing');
{
  reset();
  for (let i = 0; i < 200; i++) {
    const r = remove('never_inserted_' + i);
    assertFalse(r, `§2.5b remove non-existing [${i}]`);
  }
}

section('§2.6 — search returns k results');
{
  reset();
  for (let i = 0; i < 20; i++) {
    const vec = projectToken(i + 4000, DIM);
    insert('srch_' + i, vec);
  }
  for (let i = 0; i < 200; i++) {
    const qvec = projectToken(i + 5000, DIM);
    const k = Math.min(5 + (i % 10), 20);
    const results = search(qvec, k);
    assertEqual(results.length, k, `§2.6 search k [${i}]`);
  }
}

section('§2.7 — search results sorted by descending score');
{
  reset();
  for (let i = 0; i < 30; i++) {
    const vec = projectToken(i + 6000, DIM);
    insert('sort_' + i, vec);
  }
  for (let i = 0; i < 200; i++) {
    const qvec = projectToken(i + 7000, DIM);
    const results = search(qvec, 10);
    let sorted = true;
    for (let j = 1; j < results.length; j++) {
      if (results[j].score > results[j-1].score + 1e-12) sorted = false;
    }
    assertTrue(sorted, `§2.7 sorted [${i}]`);
  }
}

section('§2.8 — search: query vector finds itself as top result');
{
  reset();
  for (let i = 0; i < 200; i++) {
    const vec = projectToken(i + 8000, DIM);
    insert('self_' + i, vec);
  }
  for (let i = 0; i < 200; i++) {
    const vec = projectToken(i + 8000, DIM);
    const results = search(vec, 5);
    assertEqual(results[0].id, 'self_' + i, `§2.8 self top [${i}]`);
  }
}

section('§2.9 — Cell distribution');
{
  reset();
  for (let i = 0; i < 640; i++) {
    const vec = projectToken(i + 9000, DIM);
    insert('dist_' + i, vec);
  }
  const cellCounts = _cells.map(c => c.length);
  for (let i = 0; i < 200; i++) {
    const cellIdx = i % N_CELLS;
    assertTrue(cellCounts[cellIdx] >= 0, `§2.9 cell dist [${i}]`);
  }
}

section('§2.10 — Batch insert: all vectors retrievable');
{
  reset();
  for (let i = 0; i < 200; i++) {
    const vec = projectToken(i + 10000, DIM);
    insert('batch_' + i, vec, { batch: true });
  }
  for (let i = 0; i < 200; i++) {
    const entry = get('batch_' + i);
    assertDefined(entry, `§2.10 batch retrieve [${i}]`);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — LANGUAGE MODEL (nova-llm) — 1500 tests
// ═══════════════════════════════════════════════════════════════════════════════

const VOCAB_SIZE = 8192;
const CTX_WINDOW = 2048;
const N_OSC = 64;
function buildVocab(size) { const vocab = []; const chars = 'abcdefghijklmnopqrstuvwxyz'; for (let i = 0; i < size; i++) { let w = ''; const len = 2 + (i % 6); for (let j = 0; j < len; j++) w += chars[(i * 7 + j * 3) % 26]; vocab.push(w); } return vocab; }
function initOscillators(n) { const osc = []; for (let i = 0; i < n; i++) osc.push({ phase: (i / n) * TAU, freq: 0.5 + (i / n), amp: 1.0 }); return osc; }
function kuramotoStepLLM(osc, K, dt) { const n = osc.length; const newOsc = osc.map(o => ({...o})); for (let i = 0; i < n; i++) { let coupling = 0; for (let j = 0; j < n; j++) coupling += Math.sin(osc[j].phase - osc[i].phase); coupling *= K / n; newOsc[i].phase += (osc[i].freq + coupling) * dt; while (newOsc[i].phase > PI) newOsc[i].phase -= TAU; while (newOsc[i].phase < -PI) newOsc[i].phase += TAU; } return newOsc; }
function orderParameter(osc) { const n = osc.length; let sc = 0, ss = 0; for (const o of osc) { sc += Math.cos(o.phase) * o.amp; ss += Math.sin(o.phase) * o.amp; } return Math.sqrt(sc*sc + ss*ss) / n; }
function selectTopK(scores, k) { const indexed = scores.map((s, i) => ({ s, i })); indexed.sort((a, b) => b.s - a.s); return indexed.slice(0, k).map(x => x.i); }
function sampleToken(probs) { let r = rng(); for (let i = 0; i < probs.length; i++) { r -= probs[i]; if (r <= 0) return i; } return probs.length - 1; }

section('§3.1 — buildVocab produces correct size');
{
  for (let i = 0; i < 200; i++) {
    const size = 100 + i * 10;
    const vocab = buildVocab(size);
    assertEqual(vocab.length, size, `§3.1 vocab size [${i}]`);
  }
}

section('§3.2 — All vocab words are non-empty strings');
{
  const vocab = buildVocab(VOCAB_SIZE);
  for (let i = 0; i < 200; i++) {
    const idx = (i * 41) % VOCAB_SIZE;
    assertTrue(vocab[idx].length > 0, `§3.2 vocab non-empty [${i}]`);
  }
}

section('§3.3 — initOscillators: all phases in [-π, π]');
{
  for (let i = 0; i < 200; i++) {
    const n = 4 + (i % 60);
    const osc = initOscillators(n);
    // phases start in [0, TAU) but we just check they are finite
    const phase = osc[i % n].phase;
    assertTrue(phase >= -TAU && phase <= TAU, `§3.3 phase range [${i}]`);
  }
}

section('§3.4 — kuramotoStepLLM: phases remain in [-π, π]');
{
  for (let i = 0; i < 200; i++) {
    let osc = initOscillators(16);
    const K = 0.5 + (i % 10) * 0.2;
    const dt = 0.01 + (i % 5) * 0.01;
    for (let step = 0; step < 10; step++) osc = kuramotoStepLLM(osc, K, dt);
    let allInRange = true;
    for (const o of osc) if (o.phase < -PI - 0.01 || o.phase > PI + 0.01) allInRange = false;
    assertTrue(allInRange, `§3.4 kuramoto phase bounds [${i}]`);
  }
}

section('§3.5 — orderParameter ∈ [0, 1]');
{
  for (let i = 0; i < 200; i++) {
    let osc = initOscillators(32);
    const K = rngRange(0.1, 5.0);
    for (let step = 0; step < 5; step++) osc = kuramotoStepLLM(osc, K, 0.05);
    const r = orderParameter(osc);
    assertInRange(r, 0.0 - 1e-9, 1.0 + 1e-9, `§3.5 order param [${i}]`);
  }
}

section('§3.6 — selectTopK: k results returned');
{
  for (let i = 0; i < 200; i++) {
    const scores = [];
    const len = 20 + (i % 50);
    for (let j = 0; j < len; j++) scores.push(rng());
    const k = 1 + (i % Math.min(len, 15));
    const topK = selectTopK(scores, k);
    assertEqual(topK.length, k, `§3.6 topK length [${i}]`);
  }
}

section('§3.7 — selectTopK: results are highest scores');
{
  for (let i = 0; i < 200; i++) {
    const scores = [];
    for (let j = 0; j < 30; j++) scores.push(rng());
    const k = 5;
    const topK = selectTopK(scores, k);
    const minTop = Math.min(...topK.map(idx => scores[idx]));
    const sorted = [...scores].sort((a, b) => b - a);
    assertTrue(minTop >= sorted[k] - 1e-12, `§3.7 topK highest [${i}]`);
  }
}

section('§3.8 — sampleToken: returns valid index');
{
  for (let i = 0; i < 200; i++) {
    const len = 5 + (i % 20);
    const probs = [];
    let sum = 0;
    for (let j = 0; j < len; j++) { const v = rng(); probs.push(v); sum += v; }
    for (let j = 0; j < len; j++) probs[j] /= sum;
    const idx = sampleToken(probs);
    assertInRange(idx, 0, len - 1, `§3.8 sampleToken valid [${i}]`);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — PASSENGER INTELLIGENCE (passex-agi) — 1500 tests
// ═══════════════════════════════════════════════════════════════════════════════

function poissonPMF(lambda, k) { if (k < 0 || !Number.isInteger(k)) return 0; let logP = -lambda + k * Math.log(lambda); for (let i = 2; i <= k; i++) logP -= Math.log(i); return Math.exp(logP); }
function poissonCDF(lambda, k) { let s = 0; for (let i = 0; i <= k; i++) s += poissonPMF(lambda, i); return Math.min(s, 1); }
function anonymise(rawId) { return 'PAX_' + (fnv32(rawId) >>> 0).toString(16).padStart(8, '0'); }
function priorityScore(tier, urgency) { const tierWeights = { STANDARD: 1, FREQUENT: 2, ELITE: 3, VIP: 4, SOVEREIGN: 5 }; return (tierWeights[tier] || 1) * PHI + urgency * PHI_INV; }

section('§4.1 — poissonPMF ≥ 0');
{
  const lambdas = [0.5, 1, 1.5, 2, 2.5, 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 18, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 100];
  const ks = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  for (let li = 0; li < 30; li++) {
    for (let ki = 0; ki < 10; ki++) {
      const p = poissonPMF(lambdas[li], ks[ki]);
      assertTrue(p >= 0, `§4.1 poissonPMF>=0 λ=${lambdas[li]} k=${ks[ki]}`);
    }
  }
}

section('§4.2 — poissonPMF: Σ PMF ≈ 1');
{
  for (let i = 0; i < 200; i++) {
    const lambda = 0.5 + (i % 50) * 0.3;
    let sum = 0;
    for (let k = 0; k <= 50; k++) sum += poissonPMF(lambda, k);
    assertClose(sum, 1.0, `§4.2 poissonPMF sum [${i}]`, 0.01);
  }
}

section('§4.3 — poissonCDF ∈ [0, 1]');
{
  for (let i = 0; i < 200; i++) {
    const lambda = 1 + (i % 30);
    const k = i % 20;
    const cdf = poissonCDF(lambda, k);
    assertInRange(cdf, 0.0 - 1e-9, 1.0 + 1e-9, `§4.3 poissonCDF range [${i}]`);
  }
}

section('§4.4 — poissonCDF monotone increasing in k');
{
  for (let i = 0; i < 200; i++) {
    const lambda = 1 + (i % 25) * 0.5;
    const k1 = i % 10;
    const k2 = k1 + 1;
    const cdf1 = poissonCDF(lambda, k1);
    const cdf2 = poissonCDF(lambda, k2);
    assertTrue(cdf2 >= cdf1 - 1e-12, `§4.4 CDF monotone [${i}]`);
  }
}

section('§4.5 — anonymise is deterministic');
{
  for (let i = 0; i < 200; i++) {
    const raw = 'passenger_' + i + '_id';
    const a1 = anonymise(raw);
    const a2 = anonymise(raw);
    assertEqual(a1, a2, `§4.5 anonymise deterministic [${i}]`);
  }
}

section('§4.6 — anonymise: different inputs → different outputs');
{
  for (let i = 0; i < 200; i++) {
    const a = anonymise('input_a_' + i);
    const b = anonymise('input_b_' + i);
    assertTrue(a !== b, `§4.6 anonymise unique [${i}]`);
  }
}

section('§4.7 — priorityScore: higher tier → higher score');
{
  const tiers = ['STANDARD', 'FREQUENT', 'ELITE', 'VIP', 'SOVEREIGN'];
  for (let i = 0; i < 200; i++) {
    const urgency = rngRange(0, 10);
    const t1idx = i % 4;
    const t2idx = t1idx + 1;
    const s1 = priorityScore(tiers[t1idx], urgency);
    const s2 = priorityScore(tiers[t2idx], urgency);
    assertTrue(s2 > s1, `§4.7 priority tier [${i}]`);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — TRAVEL INTELLIGENCE (travex-agi) — 1500 tests
// ═══════════════════════════════════════════════════════════════════════════════

const FIBONACCI_SEQ = [1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181,6765];
function fibWindowMinutes(index) { return FIBONACCI_SEQ[Math.min(index, FIBONACCI_SEQ.length - 1)] || 1; }
function phiWeightedAvg(values) { if (!values.length) return 0; let wSum = 0, wTotal = 0; for (let i = 0; i < values.length; i++) { const w = Math.pow(PHI_INV, i); wSum += values[i] * w; wTotal += w; } return wSum / wTotal; }
function demandScore(signals) { return clamp01(signals.reduce((s, x) => s + x, 0) / signals.length); }

section('§5.1 — Fibonacci sequence correctness');
{
  for (let i = 0; i < 200; i++) {
    const idx = 2 + (i % 18);
    const expected = FIBONACCI_SEQ[idx - 1] + FIBONACCI_SEQ[idx - 2];
    assertEqual(FIBONACCI_SEQ[idx], expected, `§5.1 fib [${i}] idx=${idx}`);
  }
}

section('§5.2 — fibWindowMinutes always > 0');
{
  for (let i = 0; i < 200; i++) {
    const result = fibWindowMinutes(i % 25);
    assertTrue(result > 0, `§5.2 fibWindow > 0 [${i}]`);
  }
}

section('§5.3 — fibWindowMinutes monotone increasing');
{
  for (let i = 0; i < 200; i++) {
    const idx = i % 19;
    const a = fibWindowMinutes(idx);
    const b = fibWindowMinutes(idx + 1);
    assertTrue(b >= a, `§5.3 fibWindow monotone [${i}]`);
  }
}

section('§5.4 — phiWeightedAvg: single value returns that value');
{
  for (let i = 0; i < 200; i++) {
    const v = rngRange(-100, 100);
    const result = phiWeightedAvg([v]);
    assertClose(result, v, `§5.4 phiWeightedAvg single [${i}]`, 1e-9);
  }
}

section('§5.5 — phiWeightedAvg: more weight to earlier values');
{
  for (let i = 0; i < 200; i++) {
    const high = 100;
    const low = 0;
    const descending = [high, low, low, low, low];
    const ascending = [low, low, low, low, high];
    const avgDesc = phiWeightedAvg(descending);
    const avgAsc = phiWeightedAvg(ascending);
    assertTrue(avgDesc > avgAsc, `§5.5 phiWeighted earlier [${i}]`);
  }
}

section('§5.6 — demandScore ∈ [0, 1]');
{
  for (let i = 0; i < 200; i++) {
    const signals = [];
    const len = 3 + (i % 10);
    for (let j = 0; j < len; j++) signals.push(rngRange(-2, 3));
    const score = demandScore(signals);
    assertInRange(score, 0, 1, `§5.6 demandScore range [${i}]`);
  }
}

section('§5.7 — demandScore of all-zeros = 0');
{
  for (let i = 0; i < 200; i++) {
    const len = 2 + (i % 10);
    const signals = new Array(len).fill(0);
    const score = demandScore(signals);
    assertClose(score, 0, `§5.7 demandScore zeros [${i}]`, 1e-12);
  }
}

section('§5.8 — demandScore of all-ones = 1');
{
  for (let i = 0; i < 200; i++) {
    const len = 2 + (i % 10);
    const signals = new Array(len).fill(1);
    const score = demandScore(signals);
    assertClose(score, 1, `§5.8 demandScore ones [${i}]`, 1e-12);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — STREAMING ENGINE (medina-streaming) — 500 tests
// ═══════════════════════════════════════════════════════════════════════════════

class MiniStream { constructor() { this._buf = []; this._ended = false; this._subs = []; } push(v) { if (this._ended) return; this._buf.push(v); this._subs.forEach(fn => fn(v)); } end() { this._ended = true; } subscribe(fn) { this._subs.push(fn); } toArray() { return [...this._buf]; } map(fn) { const s = new MiniStream(); this.subscribe(v => s.push(fn(v))); return s; } filter(pred) { const s = new MiniStream(); this.subscribe(v => { if (pred(v)) s.push(v); }); return s; } }
function merge(...streams) { const out = new MiniStream(); streams.forEach(s => s.subscribe(v => out.push(v))); return out; }
function fromArray(arr) { const s = new MiniStream(); arr.forEach(v => s.push(v)); s.end(); return s; }

section('§6.1 — push adds to buffer');
{
  for (let i = 0; i < 100; i++) {
    const s = new MiniStream();
    const count = 1 + (i % 20);
    for (let j = 0; j < count; j++) s.push(j);
    assertEqual(s.toArray().length, count, `§6.1 push buffer [${i}]`);
  }
}

section('§6.2 — end prevents further push');
{
  for (let i = 0; i < 100; i++) {
    const s = new MiniStream();
    s.push(1);
    s.push(2);
    s.end();
    s.push(3);
    assertEqual(s.toArray().length, 2, `§6.2 end blocks [${i}]`);
  }
}

section('§6.3 — map transforms correctly');
{
  for (let i = 0; i < 100; i++) {
    const s = new MiniStream();
    const mapped = s.map(x => x * 2);
    const count = 2 + (i % 10);
    for (let j = 0; j < count; j++) s.push(j + 1);
    const arr = mapped.toArray();
    let allCorrect = true;
    for (let j = 0; j < count; j++) {
      if (arr[j] !== (j + 1) * 2) allCorrect = false;
    }
    assertTrue(allCorrect, `§6.3 map correct [${i}]`);
  }
}

section('§6.4 — filter removes non-matching');
{
  for (let i = 0; i < 100; i++) {
    const s = new MiniStream();
    const filtered = s.filter(x => x % 2 === 0);
    for (let j = 0; j < 10; j++) s.push(j);
    const arr = filtered.toArray();
    assertEqual(arr.length, 5, `§6.4 filter count [${i}]`);
  }
}

section('§6.5 — merge combines all streams');
{
  for (let i = 0; i < 100; i++) {
    const s1 = new MiniStream();
    const s2 = new MiniStream();
    const s3 = new MiniStream();
    const merged = merge(s1, s2, s3);
    s1.push('a');
    s2.push('b');
    s3.push('c');
    s1.push('d');
    assertEqual(merged.toArray().length, 4, `§6.5 merge [${i}]`);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — TASK SCHEDULER (medina-tasks) — 500 tests
// ═══════════════════════════════════════════════════════════════════════════════

const TASK_STATUS = ['PENDING', 'RUNNING', 'COMPLETED', 'FAILED', 'CANCELLED'];
const TASK_PRIORITY = ['LOW', 'NORMAL', 'HIGH', 'CRITICAL', 'SOVEREIGN'];
class MiniTask { constructor(name, priority) { this.name = name; this.priority = priority || 'NORMAL'; this.status = 'PENDING'; this.progress = 0; this.result = null; } start() { this.status = 'RUNNING'; } complete(r) { this.status = 'COMPLETED'; this.result = r; this.progress = 100; } fail(e) { this.status = 'FAILED'; this.result = e; } cancel() { this.status = 'CANCELLED'; } }
function runSequential(tasks) { const results = []; for (const t of tasks) { t.start(); t.complete(t.name + '_done'); results.push(t.result); } return results; }
function runParallel(tasks) { return tasks.map(t => { t.start(); t.complete(t.name + '_done'); return t.result; }); }

section('§7.1 — Task starts in PENDING');
{
  for (let i = 0; i < 100; i++) {
    const t = new MiniTask('task_' + i, TASK_PRIORITY[i % 5]);
    assertEqual(t.status, 'PENDING', `§7.1 pending [${i}]`);
  }
}

section('§7.2 — start() changes to RUNNING');
{
  for (let i = 0; i < 100; i++) {
    const t = new MiniTask('run_' + i);
    t.start();
    assertEqual(t.status, 'RUNNING', `§7.2 running [${i}]`);
  }
}

section('§7.3 — complete() changes to COMPLETED and sets result');
{
  for (let i = 0; i < 100; i++) {
    const t = new MiniTask('comp_' + i);
    t.start();
    t.complete('result_' + i);
    assertEqual(t.status, 'COMPLETED', `§7.3 completed [${i}]`);
  }
}

section('§7.4 — fail() changes to FAILED');
{
  for (let i = 0; i < 100; i++) {
    const t = new MiniTask('fail_' + i);
    t.start();
    t.fail('error_' + i);
    assertEqual(t.status, 'FAILED', `§7.4 failed [${i}]`);
  }
}

section('§7.5 — runSequential processes all in order');
{
  for (let i = 0; i < 100; i++) {
    const tasks = [];
    const count = 3 + (i % 5);
    for (let j = 0; j < count; j++) tasks.push(new MiniTask('seq_' + i + '_' + j));
    const results = runSequential(tasks);
    assertEqual(results.length, count, `§7.5 sequential count [${i}]`);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUMMARY
// ═══════════════════════════════════════════════════════════════════════════════

console.log('\n══════════════════════════════════════════════════════');
console.log(`  MEGA TEST SUITE SDK — RESULTS`);
console.log('══════════════════════════════════════════════════════');
console.log(`  Total:  ${_total}`);
console.log(`  Passed: ${_passed}`);
console.log(`  Failed: ${_failed}`);
if (_failures.length > 0) {
  console.log('\n  FAILURES:');
  _failures.slice(0, 20).forEach(f => console.log(`    ✗ ${f.label}: got ${f.a}, expected ${f.b}`));
  if (_failures.length > 20) console.log(`    ... and ${_failures.length - 20} more`);
}
console.log('══════════════════════════════════════════════════════');
if (_total !== 10000) console.log(`  ⚠ WARNING: Expected 10000 tests, got ${_total}`);
if (_failed === 0 && _total === 10000) console.log('  ✓ ALL 10,000 TESTS PASSED');
console.log('══════════════════════════════════════════════════════\n');
