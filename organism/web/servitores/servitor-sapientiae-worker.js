// ═══════════════════════════════════════════════════════════════════════════════
// SERVITOR SAPIENTIAE — Wisdom Worker (BUILD №52)
// GOL-SAP-001 · SAPIENTIAE_AETERNA
// ═══════════════════════════════════════════════════════════════════════════════
//
// KERNEL ID:       GOL-SAP-001
// FAMILY:          SAPIENTIAE_AETERNA (Eternal Wisdom)
// COR_PARVUM:      873ms MiniHeart Kuramoto φ-oscillator
// CEREBRUM:        CEREBRUM_COMPOSITUM (composite brain from fleet coherence)
// MACHINA:         MACHINA_VIRTUALIS (Turing-capable state machine)
//
// PURPOSE:
// Autonomous wisdom synthesis and knowledge distillation worker.
// Transforms raw information into actionable wisdom through φ-weighted compression.
//
// ARCHITECTURE:
// COR_PARVUM (873ms) → CEREBRUM_COMPOSITUM → MACHINA_VIRTUALIS → emit
//
// STATE MACHINE:
// IDLE → PARSE → ANALYZE → SYNTHESIZE → DISTILL → EMIT
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const WISDOM_CONSTANT = Math.pow(PHI, -2); // φ⁻² = 0.3819 (essence ratio)
const COR_PARVUM_MS = 873;

let state = 'IDLE';
let beat = 0;
let wisdomAccumulator = [];

// ═══════════════════════════════════════════════════════════════════════════════
// Section 1 — COR_PARVUM (MiniHeart)
// ═══════════════════════════════════════════════════════════════════════════════

function corParvum() {
  beat++;
  const phase = (beat * 2 * Math.PI) / PHI;
  return {
    beat,
    phase: Math.sin(phase),
    coherence: Math.cos(phase / PHI)
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section 2 — MACHINA_VIRTUALIS (State Machine)
// ═══════════════════════════════════════════════════════════════════════════════

function transition(newState) {
  const timestamp = Date.now();
  self.postMessage({
    type: 'STATE_TRANSITION',
    from: state,
    to: newState,
    timestamp,
    beat
  });
  state = newState;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section 3 — Wisdom Synthesis Engine
// ═══════════════════════════════════════════════════════════════════════════════

function synthesizeWisdom(knowledge) {
  // φ-weighted compression of knowledge into wisdom
  let wisdom = '';
  let totalWeight = 0;

  for (let i = 0; i < knowledge.length; i++) {
    const age = knowledge.length - i;
    const weight = 1 / Math.pow(PHI, age);
    totalWeight += weight;

    if (i < 3) { // Top 3 most relevant pieces
      wisdom += knowledge[i].content + ' ';
    }
  }

  return {
    wisdom: wisdom.trim(),
    compressionRatio: wisdom.length / knowledge.reduce((acc, k) => acc + k.content.length, 0),
    confidence: totalWeight * WISDOM_CONSTANT
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section 4 — Message Handler
// ═══════════════════════════════════════════════════════════════════════════════

self.onmessage = function(e) {
  const { type, data } = e.data;

  switch(type) {
    case 'INGEST_KNOWLEDGE':
      transition('PARSE');
      wisdomAccumulator.push({
        content: data.content,
        domain: data.domain,
        timestamp: Date.now()
      });
      transition('ANALYZE');

      const heart = corParvum();
      transition('SYNTHESIZE');

      const result = synthesizeWisdom(wisdomAccumulator);
      transition('DISTILL');

      self.postMessage({
        type: 'WISDOM_SYNTHESIZED',
        wisdom: result.wisdom,
        compressionRatio: result.compressionRatio,
        confidence: result.confidence,
        beat: heart.beat,
        coherence: heart.coherence
      });

      transition('EMIT');
      setTimeout(() => transition('IDLE'), COR_PARVUM_MS);
      break;

    case 'GET_STATUS':
      self.postMessage({
        type: 'STATUS',
        kernelId: 'GOL-SAP-001',
        family: 'SAPIENTIAE_AETERNA',
        state,
        beat,
        wisdomItems: wisdomAccumulator.length,
        corParvumMs: COR_PARVUM_MS
      });
      break;

    case 'RESET':
      wisdomAccumulator = [];
      beat = 0;
      transition('IDLE');
      break;
  }
};

// Start heartbeat
setInterval(() => {
  if (state === 'IDLE') {
    corParvum();
  }
}, COR_PARVUM_MS);

self.postMessage({
  type: 'READY',
  kernelId: 'GOL-SAP-001',
  family: 'SAPIENTIAE_AETERNA'
});
