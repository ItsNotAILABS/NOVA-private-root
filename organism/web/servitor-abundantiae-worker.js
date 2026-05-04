// ═══════════════════════════════════════════════════════════════════════════════
// SERVITOR ABUNDANTIAE — Abundance Worker (BUILD №52)
// GOL-ABUN-001 · ABUNDANTIAE_AETERNA
// ═══════════════════════════════════════════════════════════════════════════════
//
// KERNEL ID:       GOL-ABUN-001
// FAMILY:          ABUNDANTIAE_AETERNA (Eternal Abundance)
// COR_PARVUM:      873ms MiniHeart Kuramoto φ-oscillator
// CEREBRUM:        CEREBRUM_COMPOSITUM (composite brain from fleet coherence)
// MACHINA:         MACHINA_VIRTUALIS (Turing-capable state machine)
//
// PURPOSE:
// Autonomous resource multiplication and exponential growth worker.
// Generates abundance through φ-compounding and value multiplication.
//
// ARCHITECTURE:
// COR_PARVUM (873ms) → CEREBRUM_COMPOSITUM → MACHINA_VIRTUALIS → emit
//
// STATE MACHINE:
// IDLE → ASSESS → MULTIPLY → COMPOUND → DISTRIBUTE → EMIT
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const ABUNDANCE_RATE = PHI; // φ = 1.618 (growth multiplier)
const COR_PARVUM_MS = 873;

let state = 'IDLE';
let beat = 0;
let resources = new Map();

function corParvum() {
  beat++;
  const phase = (beat * 2 * Math.PI) / PHI;
  return { beat, phase: Math.sin(phase), coherence: Math.cos(phase / PHI) };
}

function transition(newState) {
  self.postMessage({ type: 'STATE_TRANSITION', from: state, to: newState, timestamp: Date.now(), beat });
  state = newState;
}

function multiplyResource(resourceId, currentAmount) {
  const resource = resources.get(resourceId) || {
    id: resourceId,
    initialAmount: currentAmount,
    currentAmount,
    multiplicationCount: 0,
    createdAt: Date.now()
  };

  // φ-compound growth
  const timeFactor = Math.pow(PHI, resource.multiplicationCount / 10);
  const newAmount = currentAmount * ABUNDANCE_RATE * timeFactor;

  resource.currentAmount = newAmount;
  resource.multiplicationCount++;
  resource.lastMultiplication = Date.now();

  resources.set(resourceId, resource);

  return {
    resourceId,
    previousAmount: currentAmount,
    newAmount,
    growth: newAmount - currentAmount,
    growthRate: (newAmount - currentAmount) / currentAmount,
    timeFactor,
    totalMultiplications: resource.multiplicationCount
  };
}

function distributeAbundance(amount, recipients) {
  // φ-weighted distribution
  const weights = recipients.map((_, i) => 1 / Math.pow(PHI, i));
  const totalWeight = weights.reduce((acc, w) => acc + w, 0);

  return recipients.map((recipient, i) => ({
    recipient: recipient.id,
    allocation: (amount * weights[i]) / totalWeight,
    weight: weights[i]
  }));
}

self.onmessage = function(e) {
  const { type, data } = e.data;

  switch(type) {
    case 'MULTIPLY':
      transition('ASSESS');
      const heart = corParvum();

      transition('MULTIPLY');
      const result = multiplyResource(data.resourceId, data.amount);

      transition('COMPOUND');

      transition('DISTRIBUTE');
      const distribution = data.recipients
        ? distributeAbundance(result.newAmount, data.recipients)
        : null;

      self.postMessage({
        type: 'RESOURCE_MULTIPLIED',
        multiplication: result,
        distribution,
        beat: heart.beat,
        coherence: heart.coherence
      });

      transition('EMIT');
      setTimeout(() => transition('IDLE'), COR_PARVUM_MS);
      break;

    case 'GET_STATUS':
      self.postMessage({
        type: 'STATUS',
        kernelId: 'GOL-ABUN-001',
        family: 'ABUNDANTIAE_AETERNA',
        state,
        beat,
        resourcesManaged: resources.size,
        corParvumMs: COR_PARVUM_MS
      });
      break;

    case 'RESET':
      resources.clear();
      beat = 0;
      transition('IDLE');
      break;
  }
};

setInterval(() => { if (state === 'IDLE') corParvum(); }, COR_PARVUM_MS);

self.postMessage({ type: 'READY', kernelId: 'GOL-ABUN-001', family: 'ABUNDANTIAE_AETERNA' });
