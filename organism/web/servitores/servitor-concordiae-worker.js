// ═══════════════════════════════════════════════════════════════════════════════
// SERVITOR CONCORDIAE — Harmony Worker (BUILD №52)
// GOL-CONC-001 · CONCORDIAE_AETERNA
// ═══════════════════════════════════════════════════════════════════════════════
//
// KERNEL ID:       GOL-CONC-001
// FAMILY:          CONCORDIAE_AETERNA (Eternal Harmony)
// COR_PARVUM:      873ms MiniHeart Kuramoto φ-oscillator
// CEREBRUM:        CEREBRUM_COMPOSITUM (composite brain from fleet coherence)
// MACHINA:         MACHINA_VIRTUALIS (Turing-capable state machine)
//
// PURPOSE:
// Autonomous conflict resolution and Kuramoto synchronization worker.
// Harmonizes disparate systems through φ-phase coupling.
//
// ARCHITECTURE:
// COR_PARVUM (873ms) → CEREBRUM_COMPOSITUM → MACHINA_VIRTUALIS → emit
//
// STATE MACHINE:
// IDLE → DETECT → MEDIATE → SYNCHRONIZE → HARMONIZE → EMIT
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const COUPLING_STRENGTH = 1 / PHI; // φ⁻¹ = 0.618 (Kuramoto coupling)
const COR_PARVUM_MS = 873;

let state = 'IDLE';
let beat = 0;
let oscillators = new Map();

function corParvum() {
  beat++;
  const phase = (beat * 2 * Math.PI) / PHI;
  return { beat, phase: Math.sin(phase), coherence: Math.cos(phase / PHI) };
}

function transition(newState) {
  self.postMessage({ type: 'STATE_TRANSITION', from: state, to: newState, timestamp: Date.now(), beat });
  state = newState;
}

function kuramotoUpdate(oscillatorId, naturalFreq, neighbors) {
  const osc = oscillators.get(oscillatorId) || {
    id: oscillatorId,
    phase: Math.random() * 2 * Math.PI,
    frequency: naturalFreq,
    createdAt: Date.now()
  };

  // Kuramoto coupling: dθ/dt = ω + K/N Σ sin(θⱼ - θᵢ)
  let coupling = 0;

  neighbors.forEach(neighbor => {
    const neighborOsc = oscillators.get(neighbor.id);
    if (neighborOsc) {
      coupling += Math.sin(neighborOsc.phase - osc.phase);
    }
  });

  const dt = COR_PARVUM_MS / 1000; // Convert to seconds
  const avgCoupling = neighbors.length > 0 ? coupling / neighbors.length : 0;

  osc.phase += (osc.frequency + COUPLING_STRENGTH * avgCoupling) * dt;
  osc.phase = osc.phase % (2 * Math.PI);
  osc.lastUpdate = Date.now();

  oscillators.set(oscillatorId, osc);

  return osc;
}

function calculateCoherence(oscillatorIds) {
  if (oscillatorIds.length === 0) return 0;

  let sumSin = 0;
  let sumCos = 0;

  oscillatorIds.forEach(id => {
    const osc = oscillators.get(id);
    if (osc) {
      sumSin += Math.sin(osc.phase);
      sumCos += Math.cos(osc.phase);
    }
  });

  const n = oscillatorIds.length;
  const r = Math.sqrt(sumSin * sumSin + sumCos * sumCos) / n;

  return r; // [0,1] where 1 = perfect synchronization
}

self.onmessage = function(e) {
  const { type, data } = e.data;

  switch(type) {
    case 'SYNCHRONIZE':
      transition('DETECT');
      const heart = corParvum();

      transition('MEDIATE');
      const oscillatorId = data.oscillatorId;
      const naturalFreq = data.naturalFreq || 1.0;
      const neighbors = data.neighbors || [];

      transition('SYNCHRONIZE');
      const updated = kuramotoUpdate(oscillatorId, naturalFreq, neighbors);

      transition('HARMONIZE');
      const allIds = Array.from(oscillators.keys());
      const coherence = calculateCoherence(allIds);

      self.postMessage({
        type: 'OSCILLATOR_SYNCHRONIZED',
        oscillator: {
          id: updated.id,
          phase: updated.phase,
          frequency: updated.frequency
        },
        coherence,
        totalOscillators: oscillators.size,
        beat: heart.beat
      });

      transition('EMIT');
      setTimeout(() => transition('IDLE'), COR_PARVUM_MS);
      break;

    case 'GET_STATUS':
      const currentCoherence = calculateCoherence(Array.from(oscillators.keys()));

      self.postMessage({
        type: 'STATUS',
        kernelId: 'GOL-CONC-001',
        family: 'CONCORDIAE_AETERNA',
        state,
        beat,
        oscillatorCount: oscillators.size,
        coherence: currentCoherence,
        corParvumMs: COR_PARVUM_MS
      });
      break;

    case 'RESET':
      oscillators.clear();
      beat = 0;
      transition('IDLE');
      break;
  }
};

setInterval(() => { if (state === 'IDLE') corParvum(); }, COR_PARVUM_MS);

self.postMessage({ type: 'READY', kernelId: 'GOL-CONC-001', family: 'CONCORDIAE_AETERNA' });
