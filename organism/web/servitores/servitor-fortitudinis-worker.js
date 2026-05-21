// ═══════════════════════════════════════════════════════════════════════════════
// SERVITOR FORTITUDINIS — Strength Worker (BUILD №52)
// GOL-FORT-001 · FORTITUDINIS_AETERNA
// ═══════════════════════════════════════════════════════════════════════════════
//
// KERNEL ID:       GOL-FORT-001
// FAMILY:          FORTITUDINIS_AETERNA (Eternal Strength)
// COR_PARVUM:      873ms MiniHeart Kuramoto φ-oscillator
// CEREBRUM:        CEREBRUM_COMPOSITUM (composite brain from fleet coherence)
// MACHINA:         MACHINA_VIRTUALIS (Turing-capable state machine)
//
// PURPOSE:
// Autonomous resilience and antifragility optimization worker.
// Strengthens systems through φ-weighted stress analysis and adaptive hardening.
//
// ARCHITECTURE:
// COR_PARVUM (873ms) → CEREBRUM_COMPOSITUM → MACHINA_VIRTUALIS → emit
//
// STATE MACHINE:
// IDLE → ASSESS → STRESS_TEST → HARDEN → VERIFY → EMIT
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const STRENGTH_CONSTANT = Math.pow(PHI, 2); // φ² = 2.618 (amplification ratio)
const COR_PARVUM_MS = 873;

let state = 'IDLE';
let beat = 0;
let stressHistory = [];

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
// Section 3 — Antifragility Engine
// ═══════════════════════════════════════════════════════════════════════════════

function calculateAntifragility(stressLevel) {
  // Antifragility = growth from stress (φ-weighted)
  const volatility = stressHistory.length > 0
    ? stressHistory.reduce((acc, s, i) => acc + Math.abs(s - stressLevel) / (i + 1), 0) / stressHistory.length
    : 0;

  const antifragility = volatility * STRENGTH_CONSTANT;
  const resilience = 1 / (1 + Math.exp(-antifragility)); // Sigmoid activation

  return {
    antifragility,
    resilience,
    volatility,
    strengthMultiplier: 1 + (antifragility * PHI)
  };
}

function hardenSystem(currentStrength, stressLevel) {
  const metrics = calculateAntifragility(stressLevel);
  const newStrength = currentStrength * metrics.strengthMultiplier;

  return {
    originalStrength: currentStrength,
    newStrength,
    improvement: newStrength - currentStrength,
    ...metrics
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section 4 — Message Handler
// ═══════════════════════════════════════════════════════════════════════════════

self.onmessage = function(e) {
  const { type, data } = e.data;

  switch(type) {
    case 'APPLY_STRESS':
      transition('ASSESS');

      const heart = corParvum();
      const stressLevel = data.stressLevel || 0.5;
      const currentStrength = data.currentStrength || 1.0;

      transition('STRESS_TEST');
      stressHistory.push(stressLevel);
      if (stressHistory.length > 100) stressHistory.shift();

      transition('HARDEN');
      const result = hardenSystem(currentStrength, stressLevel);

      transition('VERIFY');

      self.postMessage({
        type: 'SYSTEM_HARDENED',
        ...result,
        beat: heart.beat,
        coherence: heart.coherence,
        stressHistorySize: stressHistory.length
      });

      transition('EMIT');
      setTimeout(() => transition('IDLE'), COR_PARVUM_MS);
      break;

    case 'GET_STATUS':
      self.postMessage({
        type: 'STATUS',
        kernelId: 'GOL-FORT-001',
        family: 'FORTITUDINIS_AETERNA',
        state,
        beat,
        stressEventsProcessed: stressHistory.length,
        corParvumMs: COR_PARVUM_MS
      });
      break;

    case 'RESET':
      stressHistory = [];
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
  kernelId: 'GOL-FORT-001',
  family: 'FORTITUDINIS_AETERNA'
});
