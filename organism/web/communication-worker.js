// ═══════════════════════════════════════════════════════════════════════════════
// COMMUNICATOR OPERANS — NLP-lite Text Analysis Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// Tokenization, sentiment, named-entity recognition, summarize, word frequency.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI          = 1.618033988749895;
const INV_PHI      = 0.618033988749895;
const TAU          = 6.283185307179586;
const HEARTBEAT_MS = 873;

// ─── MINI HEART — Kuramoto Phase Oscillator ─────────────────────────────────────
const MiniHeart = {
  phase: Math.random() * TAU,
  freq: TAU / HEARTBEAT_MS,
  tick() {
    this.phase = (this.phase + this.freq * HEARTBEAT_MS * 0.001) % TAU;
    return { phase: this.phase, pulse: Math.sin(this.phase) };
  }
};

// ─── STATE ──────────────────────────────────────────────────────────────────────
let tickCount = 0;
let textsProcessed = 0;

// ─── SENTIMENT LEXICONS ─────────────────────────────────────────────────────────
const POSITIVE = new Set([
  'good', 'great', 'excellent', 'amazing', 'wonderful', 'fantastic', 'love',
  'happy', 'joy', 'beautiful', 'best', 'brilliant', 'perfect', 'awesome',
  'outstanding', 'superb', 'positive', 'success', 'win', 'bright', 'nice',
  'glad', 'pleased', 'delightful', 'impressive', 'marvelous', 'enjoy',
  'thriving', 'optimistic', 'grateful', 'hope', 'kind', 'gentle', 'calm'
]);
const NEGATIVE = new Set([
  'bad', 'terrible', 'awful', 'horrible', 'hate', 'ugly', 'worst', 'fail',
  'sad', 'angry', 'disgusting', 'poor', 'wrong', 'broken', 'negative',
  'destroy', 'kill', 'pain', 'suffer', 'fear', 'dark', 'evil', 'cruel',
  'disaster', 'tragic', 'miserable', 'dreadful', 'hopeless', 'violent',
  'corrupt', 'toxic', 'danger', 'threat', 'loss', 'grief', 'despair'
]);

// ─── TOKENIZE ───────────────────────────────────────────────────────────────────
function tokenize(text) {
  if (typeof text !== 'string') return [];
  return text.toLowerCase().replace(/[^\w\s'-]/g, '').split(/\s+/).filter(t => t.length > 0);
}

// ─── SENTIMENT SCORE ────────────────────────────────────────────────────────────
// Returns score from -1 (negative) to +1 (positive)
function sentimentScore(text) {
  const tokens = tokenize(text);
  if (tokens.length === 0) return { score: 0, positive: 0, negative: 0, tokens: 0 };
  let pos = 0, neg = 0;
  for (const t of tokens) {
    if (POSITIVE.has(t)) pos++;
    if (NEGATIVE.has(t)) neg++;
  }
  const total = pos + neg;
  const score = total === 0 ? 0 : (pos - neg) / total;
  textsProcessed++;
  return { score, positive: pos, negative: neg, tokens: tokens.length };
}

// ─── NAMED ENTITY RECOGNITION ───────────────────────────────────────────────────
// Simple heuristic: capitalized words not at sentence start, multi-word caps, numbers with context
function namedEntityRecognition(text) {
  if (typeof text !== 'string') return [];
  const entities = [];
  const seen = new Set();

  // Capitalized word sequences (potential names, places, organizations)
  const capPattern = /(?:^|[.!?]\s+)?([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)/g;
  let match;
  while ((match = capPattern.exec(text)) !== null) {
    const entity = match[1].trim();
    if (entity.length > 1 && !seen.has(entity)) {
      seen.add(entity);
      entities.push({ text: entity, type: 'ENTITY', position: match.index });
    }
  }

  // Numbers with optional units (dates, quantities)
  const numPattern = /\b(\d+(?:\.\d+)?(?:\s*(?:km|m|kg|lb|USD|EUR|%|ms|Hz|GB|MB))?)\b/g;
  while ((match = numPattern.exec(text)) !== null) {
    entities.push({ text: match[1], type: 'QUANTITY', position: match.index });
  }

  textsProcessed++;
  return entities;
}

// ─── SUMMARIZE ──────────────────────────────────────────────────────────────────
// Extracts most important sentences based on word frequency scoring
function summarize(text, maxWords) {
  if (typeof text !== 'string') return '';
  const limit = maxWords || 50;
  const sentences = text.split(/[.!?]+/).map(s => s.trim()).filter(s => s.length > 0);
  if (sentences.length === 0) return '';

  // Score sentences by word frequency
  const freq = wordFrequency(text);
  const scored = sentences.map(s => {
    const words = tokenize(s);
    const score = words.reduce((sum, w) => sum + (freq[w] || 0), 0) / (words.length || 1);
    return { sentence: s, score, wordCount: words.length };
  });
  scored.sort((a, b) => b.score - a.score);

  // Take top sentences up to maxWords
  let totalWords = 0;
  const selected = [];
  for (const s of scored) {
    if (totalWords + s.wordCount > limit) break;
    selected.push(s.sentence);
    totalWords += s.wordCount;
  }
  textsProcessed++;
  return selected.join('. ') + (selected.length > 0 ? '.' : '');
}

// ─── WORD FREQUENCY ─────────────────────────────────────────────────────────────
function wordFrequency(text) {
  const tokens = tokenize(text);
  const freq = {};
  for (const t of tokens) {
    freq[t] = (freq[t] || 0) + 1;
  }
  return freq;
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────
self.onmessage = function (e) {
  const { cmd, text, data, maxWords } = e.data || {};
  const input = text || data || '';
  switch (cmd) {
    case 'TOKENIZE':
      self.postMessage({ cmd, tokens: tokenize(input) });
      break;
    case 'SENTIMENT':
      self.postMessage({ cmd, result: sentimentScore(input) });
      break;
    case 'NER':
      self.postMessage({ cmd, entities: namedEntityRecognition(input) });
      break;
    case 'SUMMARIZE':
      self.postMessage({ cmd, summary: summarize(input, maxWords) });
      break;
    case 'WORD_FREQ':
      self.postMessage({ cmd, frequencies: wordFrequency(input) });
      break;
    case 'GET_STATUS': {
      const heart = MiniHeart.tick();
      self.postMessage({
        cmd, status: {
          worker: 'COMMUNICATOR_OPERANS', tickCount, heartPhase: heart.phase,
          textsProcessed, positiveWords: POSITIVE.size, negativeWords: NEGATIVE.size
        }
      });
      break;
    }
    default:
      self.postMessage({ cmd, error: 'Unknown command: ' + cmd });
  }
};

// ─── HEARTBEAT ──────────────────────────────────────────────────────────────────
setInterval(() => {
  tickCount++;
  const heart = MiniHeart.tick();
  self.postMessage({ type: 'heartbeat', worker: 'COMMUNICATOR_OPERANS', tick: tickCount, heart });
}, HEARTBEAT_MS);
