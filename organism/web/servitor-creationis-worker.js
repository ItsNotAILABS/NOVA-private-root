// ═══════════════════════════════════════════════════════════════════════════════
// SERVITOR CREATIONIS — Creation Worker (BUILD №52)
// GOL-CREAT-001 · CREATIONIS_AETERNA
// ═══════════════════════════════════════════════════════════════════════════════
//
// KERNEL ID:       GOL-CREAT-001
// FAMILY:          CREATIONIS_AETERNA (Eternal Creation)
// COR_PARVUM:      873ms MiniHeart Kuramoto φ-oscillator
// CEREBRUM:        CEREBRUM_COMPOSITUM (composite brain from fleet coherence)
// MACHINA:         MACHINA_VIRTUALIS (Turing-capable state machine)
//
// PURPOSE:
// Autonomous generative synthesis and creative emergence worker.
// Generates novel artifacts through φ-weighted combinatorial explosion.
//
// ARCHITECTURE:
// COR_PARVUM (873ms) → CEREBRUM_COMPOSITUM → MACHINA_VIRTUALIS → emit
//
// STATE MACHINE:
// IDLE → IDEATE → COMBINE → GENERATE → REFINE → EMIT
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const NOVELTY_THRESHOLD = PHI - 1; // φ - 1 = 0.618 (golden ratio novelty)
const COR_PARVUM_MS = 873;

let state = 'IDLE';
let beat = 0;
let creations = [];

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
// Section 3 — Generative Synthesis Engine
// ═══════════════════════════════════════════════════════════════════════════════

function calculateNovelty(creation, existingCreations) {
  if (existingCreations.length === 0) return 1.0;

  // Calculate Hamming distance to nearest neighbor
  let minDistance = Infinity;

  existingCreations.forEach(existing => {
    let distance = 0;
    const keys = new Set([...Object.keys(creation.attributes), ...Object.keys(existing.attributes)]);

    keys.forEach(key => {
      if (creation.attributes[key] !== existing.attributes[key]) {
        distance++;
      }
    });

    minDistance = Math.min(minDistance, distance);
  });

  // Normalize by attribute count
  const novelty = minDistance / Math.max(Object.keys(creation.attributes).length, 1);
  return Math.min(1.0, novelty);
}

function combineElements(elements) {
  // φ-weighted combinatorial synthesis
  const combined = {};
  let totalWeight = 0;

  elements.forEach((element, index) => {
    const weight = 1 / Math.pow(PHI, index);
    totalWeight += weight;

    Object.entries(element).forEach(([key, value]) => {
      if (!combined[key]) {
        combined[key] = { values: [], weights: [] };
      }
      combined[key].values.push(value);
      combined[key].weights.push(weight);
    });
  });

  // Select values based on φ-weighted probability
  const result = {};
  Object.entries(combined).forEach(([key, data]) => {
    const randomThreshold = Math.random();
    let cumulative = 0;

    for (let i = 0; i < data.values.length; i++) {
      cumulative += data.weights[i] / totalWeight;
      if (cumulative >= randomThreshold) {
        result[key] = data.values[i];
        break;
      }
    }

    if (!result[key]) {
      result[key] = data.values[data.values.length - 1];
    }
  });

  return result;
}

function generateArtifact(seed) {
  // Generate new artifact from seed
  const creation = {
    id: `CREAT-${Date.now()}-${beat}`,
    attributes: combineElements(seed.elements || [{}]),
    timestamp: Date.now(),
    beat
  };

  const novelty = calculateNovelty(creation, creations);
  creation.novelty = novelty;
  creation.isNovel = novelty >= NOVELTY_THRESHOLD;

  return creation;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section 4 — Message Handler
// ═══════════════════════════════════════════════════════════════════════════════

self.onmessage = function(e) {
  const { type, data } = e.data;

  switch(type) {
    case 'CREATE':
      transition('IDEATE');

      const heart = corParvum();

      transition('COMBINE');
      const seed = data.seed || { elements: [{ trait: 'default' }] };

      transition('GENERATE');
      const artifact = generateArtifact(seed);

      transition('REFINE');
      creations.push(artifact);
      if (creations.length > 500) creations.shift();

      self.postMessage({
        type: 'ARTIFACT_CREATED',
        artifact,
        totalCreations: creations.length,
        beat: heart.beat,
        coherence: heart.coherence
      });

      transition('EMIT');
      setTimeout(() => transition('IDLE'), COR_PARVUM_MS);
      break;

    case 'GET_STATUS':
      self.postMessage({
        type: 'STATUS',
        kernelId: 'GOL-CREAT-001',
        family: 'CREATIONIS_AETERNA',
        state,
        beat,
        artifactsCreated: creations.length,
        corParvumMs: COR_PARVUM_MS
      });
      break;

    case 'RESET':
      creations = [];
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
  kernelId: 'GOL-CREAT-001',
  family: 'CREATIONIS_AETERNA'
});
