// ═══════════════════════════════════════════════════════════════════════════════
// SERVITOR IUVENTUTIS — Youth/Renewal Worker (BUILD №52)
// GOL-IUV-001 · IUVENTUTIS_AETERNA
// ═══════════════════════════════════════════════════════════════════════════════
//
// KERNEL ID:       GOL-IUV-001
// FAMILY:          IUVENTUTIS_AETERNA (Eternal Youth)
// COR_PARVUM:      873ms MiniHeart Kuramoto φ-oscillator
// CEREBRUM:        CEREBRUM_COMPOSITUM (composite brain from fleet coherence)
// MACHINA:         MACHINA_VIRTUALIS (Turing-capable state machine)
//
// PURPOSE:
// Autonomous rejuvenation and telomere restoration worker.
// Prevents decay and maintains perpetual freshness through φ-regeneration cycles.
//
// ARCHITECTURE:
// COR_PARVUM (873ms) → CEREBRUM_COMPOSITUM → MACHINA_VIRTUALIS → emit
//
// STATE MACHINE:
// IDLE → DIAGNOSE → REPAIR → REGENERATE → RESTORE → EMIT
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const YOUTH_CONSTANT = Math.pow(PHI, -3); // φ⁻³ = 0.236 (rejuvenation rate)
const COR_PARVUM_MS = 873;

let state = 'IDLE';
let beat = 0;
let systems = new Map();

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
// Section 3 — Telomere Restoration Engine
// ═══════════════════════════════════════════════════════════════════════════════

function calculateAge(system) {
  const now = Date.now();
  const age = (now - system.createdAt) / 1000; // Age in seconds
  const lastRenewal = (now - system.lastRenewal) / 1000;

  return {
    chronologicalAge: age,
    biologicalAge: age - (system.renewalCount * YOUTH_CONSTANT * 1000),
    timeSinceRenewal: lastRenewal
  };
}

function regenerateSystem(systemId, currentHealth) {
  const system = systems.get(systemId) || {
    id: systemId,
    createdAt: Date.now(),
    lastRenewal: Date.now(),
    renewalCount: 0,
    health: currentHealth
  };

  const ageMetrics = calculateAge(system);

  // φ-regeneration formula
  const decayRate = 1 - Math.exp(-ageMetrics.timeSinceRenewal / 10000);
  const regenerationBoost = YOUTH_CONSTANT * PHI;
  const newHealth = Math.min(1.0, currentHealth + regenerationBoost - decayRate);

  system.health = newHealth;
  system.lastRenewal = Date.now();
  system.renewalCount++;

  systems.set(systemId, system);

  return {
    systemId,
    previousHealth: currentHealth,
    newHealth,
    improvement: newHealth - currentHealth,
    ageMetrics,
    renewalCount: system.renewalCount,
    isRejuvenated: newHealth > currentHealth
  };
}

function repairDamage(damage) {
  // φ-weighted repair efficiency
  const repairRate = 1 / PHI; // φ⁻¹
  const repaired = damage * repairRate;

  return {
    originalDamage: damage,
    repaired,
    remaining: damage - repaired,
    efficiency: repairRate
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section 4 — Message Handler
// ═══════════════════════════════════════════════════════════════════════════════

self.onmessage = function(e) {
  const { type, data } = e.data;

  switch(type) {
    case 'REGENERATE':
      transition('DIAGNOSE');

      const heart = corParvum();
      const systemId = data.systemId;
      const currentHealth = data.health || 0.8;

      transition('REPAIR');
      const damageRepair = data.damage ? repairDamage(data.damage) : null;

      transition('REGENERATE');
      const result = regenerateSystem(systemId, currentHealth);

      transition('RESTORE');

      self.postMessage({
        type: 'SYSTEM_REGENERATED',
        regeneration: result,
        repair: damageRepair,
        beat: heart.beat,
        coherence: heart.coherence
      });

      transition('EMIT');
      setTimeout(() => transition('IDLE'), COR_PARVUM_MS);
      break;

    case 'GET_STATUS':
      self.postMessage({
        type: 'STATUS',
        kernelId: 'GOL-IUV-001',
        family: 'IUVENTUTIS_AETERNA',
        state,
        beat,
        systemsManaged: systems.size,
        corParvumMs: COR_PARVUM_MS
      });
      break;

    case 'RESET':
      systems.clear();
      beat = 0;
      transition('IDLE');
      break;
  }
};

// Start heartbeat — passive regeneration
setInterval(() => {
  if (state === 'IDLE') {
    corParvum();

    // Auto-regenerate all systems periodically
    systems.forEach((system, id) => {
      const age = calculateAge(system);
      if (age.timeSinceRenewal > 10) { // 10 seconds
        regenerateSystem(id, system.health);
      }
    });
  }
}, COR_PARVUM_MS);

self.postMessage({
  type: 'READY',
  kernelId: 'GOL-IUV-001',
  family: 'IUVENTUTIS_AETERNA'
});
