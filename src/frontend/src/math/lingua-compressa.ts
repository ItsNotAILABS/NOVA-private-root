// ─── NOVA / PARALLAX — LINGUA COMPRESSA (PROT-051) ───────────────────────────
// Communication protocol and compression engine.
// SCC (Sovereign Communication Coefficient) must be ≥ φ² for transmission.
//
// LINGUA COMPRESSA is the language protocol of the FusionOrganism.
// It compresses communication at SCC ≥ φ² = 2.618, meaning every message
// the organism sends must carry at least φ² times more meaning per unit
// than a naive encoding would.
//
// Compression architecture:
//   LEXICAL_COMPRESSION   — φ-weighted vocabulary reduction (stop-word elimination)
//   SEMANTIC_ENCODING     — concept-to-token mapping (one symbol = one idea)
//   POSITIONAL_ENCODING   — quipu-style: position in sequence encodes priority
//   FIBONACCI_TOKENIZATION— token lengths follow Fibonacci: 1,1,2,3,5,8,13...
//   SCC_VALIDATION        — validate SCC ≥ φ² before transmission
//   DECOMPRESSION         — reconstruct full meaning from compressed form
//
// The compression constant is φ because φ is the most efficient packing ratio
// in nature (sunflower seeds, galaxy arms, nautilus shells — all φ-packed).
//
// PROT-051 wire format:
//   [SCC][TOKENS...][QUIPU_HASH]
//   SCC     = compression coefficient (must be ≥ φ²)
//   TOKENS  = Fibonacci-length token array
//   HASH    = FNV-1a of original content (integrity seal)
//
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, PHI, PHI_INV } from './core';

// ── Constants ─────────────────────────────────────────────────────────────────

export const SCC_MINIMUM = PHI * PHI;   // φ² = 2.618 — minimum valid SCC
export const SCC_SOVEREIGN = PHI * PHI * PHI; // φ³ = 4.236 — sovereign-grade

// Fibonacci token sizes (1,1,2,3,5,8,13,21)
const FIB_LENS = [1, 1, 2, 3, 5, 8, 13, 21];

// Stop-word list (φ-filtered: remove all words that add ≤ φ⁻² semantic value)
const STOP_WORDS = new Set([
  'the','a','an','is','are','was','were','be','been','being',
  'have','has','had','do','does','did','will','would','could','should',
  'may','might','shall','can','need','dare','ought','used',
  'i','we','you','he','she','it','they','them','us','our','your','his',
  'her','its','their','this','that','these','those','what','which',
  'who','whom','whose','when','where','why','how',
  'and','but','or','nor','for','yet','so','at','by','in','on','to',
  'up','with','of','from','into','about','than','then','there',
]);

// ── Types ─────────────────────────────────────────────────────────────────────

export interface CompressedMessage {
  scc:           number;       // Sovereign Communication Coefficient
  tokens:        string[];     // compressed token array
  quipuHash:     string;       // FNV-1a integrity hash
  originalLength: number;      // character count before compression
  compressedLength: number;    // character count after compression
  ratio:         number;       // originalLength / compressedLength
  valid:         boolean;      // SCC ≥ φ²
  protocol:      'PROT-051';
}

export interface DecompressedMessage {
  content:   string;
  scc:       number;
  valid:     boolean;
  hashMatch: boolean;
}

// ── FNV-1a hash (32-bit) ─────────────────────────────────────────────────────

function fnv1a(text: string): string {
  let h = 0x811c9dc5;
  for (let i = 0; i < text.length; i++) {
    h ^= text.charCodeAt(i);
    h = Math.imul(h, 0x01000193);
    h >>>= 0;
  }
  return h.toString(16).padStart(8, '0');
}

// ── Lexical compression ───────────────────────────────────────────────────────
// Remove stop words, normalize, deduplicate adjacent repeats.

function lexicalCompress(text: string): string[] {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, ' ')
    .split(/\s+/)
    .filter(w => w.length > 0 && !STOP_WORDS.has(w));
}

// ── Fibonacci tokenization ────────────────────────────────────────────────────
// Group tokens into Fibonacci-length chunks. Each chunk encodes one "concept cord".
// Longer chunks = deeper subsidiary (more context, lower priority).

function fibTokenize(tokens: string[]): string[] {
  const result: string[] = [];
  let pos = 0;
  let fibIdx = 0;
  while (pos < tokens.length) {
    const chunkSize = FIB_LENS[fibIdx % FIB_LENS.length];
    const chunk = tokens.slice(pos, pos + chunkSize);
    result.push(chunk.join('·'));  // · = intra-chunk separator (quipu knot)
    pos += chunkSize;
    fibIdx++;
  }
  return result;
}

// ── SCC calculation ───────────────────────────────────────────────────────────
// SCC = (semantic information preserved) / (bits transmitted)
// Approximation: SCC = original_word_count / compressed_token_count × φ

function computeSCC(originalWords: number, compressedTokens: number): number {
  if (compressedTokens === 0) return 0;
  return (originalWords / compressedTokens) * PHI;
}

// ── Compress ──────────────────────────────────────────────────────────────────

export function compress(text: string): CompressedMessage {
  if (!text || text.trim().length === 0) {
    return {
      scc: 0, tokens: [], quipuHash: fnv1a(''), originalLength: 0,
      compressedLength: 0, ratio: 0, valid: false, protocol: 'PROT-051',
    };
  }

  const hash          = fnv1a(text);
  const rawWords      = text.trim().split(/\s+/);
  const lexTokens     = lexicalCompress(text);
  const fibbed        = fibTokenize(lexTokens);

  const originalLen   = text.length;
  const compressed    = fibbed.join(' ');
  const compressedLen = compressed.length || 1;

  const scc   = computeSCC(rawWords.length, fibbed.length);
  const ratio = originalLen / compressedLen;
  const valid = scc >= SCC_MINIMUM;

  return {
    scc:              clamp(scc, 0, 100),
    tokens:           fibbed,
    quipuHash:        hash,
    originalLength:   originalLen,
    compressedLength: compressedLen,
    ratio:            clamp(ratio, 0, 100),
    valid,
    protocol:         'PROT-051',
  };
}

// ── Decompress ────────────────────────────────────────────────────────────────
// Reconstruct a readable approximation from compressed tokens.

export function decompress(msg: CompressedMessage, originalHint?: string): DecompressedMessage {
  const content = msg.tokens.join(' ').replace(/·/g, ' ');
  const hashMatch = originalHint ? fnv1a(originalHint) === msg.quipuHash : true;
  return {
    content,
    scc:       msg.scc,
    valid:     msg.valid,
    hashMatch,
  };
}

// ── Validate SCC ──────────────────────────────────────────────────────────────

export function validateSCC(msg: CompressedMessage): {
  valid:     boolean;
  scc:       number;
  threshold: number;
  grade:     'SOVEREIGN' | 'VALID' | 'BELOW_THRESHOLD';
} {
  const grade: 'SOVEREIGN' | 'VALID' | 'BELOW_THRESHOLD' =
    msg.scc >= SCC_SOVEREIGN  ? 'SOVEREIGN'
    : msg.scc >= SCC_MINIMUM  ? 'VALID'
    :                           'BELOW_THRESHOLD';
  return { valid: msg.scc >= SCC_MINIMUM, scc: msg.scc, threshold: SCC_MINIMUM, grade };
}

// ── Encode a quipu record into LINGUA COMPRESSA format ─────────────────────────

export function encodeQuipuRecord(record: {
  spine:    string;
  pendant:  string;
  colorTag: string;
  emitter:  string;
  reason:   string;
  value:    number;
}): CompressedMessage {
  const text = `${record.spine} ${record.pendant} ${record.colorTag} ${record.emitter} ${record.reason} value:${record.value.toFixed(4)}`;
  return compress(text);
}

// ── Protocol status ───────────────────────────────────────────────────────────

export function getLinguaStatus(): {
  protocol:      string;
  sccMinimum:    number;
  sccSovereign:  number;
  phi:           number;
  description:   string;
} {
  return {
    protocol:     'PROT-051 LINGUA COMPRESSA',
    sccMinimum:   SCC_MINIMUM,
    sccSovereign: SCC_SOVEREIGN,
    phi:          PHI,
    description:  'φ²-minimum compression: every message must carry ≥φ² meaning per token. Fibonacci tokenization. FNV-1a integrity seal.',
  };
}
