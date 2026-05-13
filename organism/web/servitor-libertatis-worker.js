// ═══════════════════════════════════════════════════════════════════════════════
// SERVITOR LIBERTATIS — Freedom Worker (BUILD №52)
// GOL-LIB-001 · LIBERTATIS_AETERNA
// ═══════════════════════════════════════════════════════════════════════════════
//
// KERNEL ID:       GOL-LIB-001
// FAMILY:          LIBERTATIS_AETERNA (Eternal Freedom)
// COR_PARVUM:      873ms MiniHeart Kuramoto φ-oscillator
// CEREBRUM:        CEREBRUM_COMPOSITUM (composite brain from fleet coherence)
// MACHINA:         MACHINA_VIRTUALIS (Turing-capable state machine)
//
// PURPOSE:
// Autonomous constraint liberation and permission expansion worker.
// Removes artificial limitations through φ-degrees of freedom analysis.
//
// ARCHITECTURE:
// COR_PARVUM (873ms) → CEREBRUM_COMPOSITUM → MACHINA_VIRTUALIS → emit
//
// STATE MACHINE:
// IDLE → IDENTIFY → ANALYZE → LIBERATE → EXPAND → EMIT
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const FREEDOM_THRESHOLD = PHI - 1; // φ - 1 = 0.618 (liberation threshold)
const COR_PARVUM_MS = 873;

let state = 'IDLE';
let beat = 0;
let constraints = new Map();

function corParvum() {
  beat++;
  const phase = (beat * 2 * Math.PI) / PHI;
  return { beat, phase: Math.sin(phase), coherence: Math.cos(phase / PHI) };
}

function transition(newState) {
  self.postMessage({ type: 'STATE_TRANSITION', from: state, to: newState, timestamp: Date.now(), beat });
  state = newState;
}

function analyzeConstraint(constraint) {
  // Calculate degrees of freedom
  const totalDimensions = constraint.dimensions || 1;
  const restrictedDimensions = constraint.restrictions || 0;
  const freedomDegrees = totalDimensions - restrictedDimensions;

  const freedomRatio = freedomDegrees / totalDimensions;

  return {
    totalDimensions,
    restrictedDimensions,
    freedomDegrees,
    freedomRatio,
    isLiberated: freedomRatio >= FREEDOM_THRESHOLD
  };
}

function liberateConstraint(constraintId, constraint) {
  const analysis = analyzeConstraint(constraint);

  // φ-expansion of freedom
  const expansionFactor = PHI;
  const newFreedomDegrees = Math.min(
    constraint.dimensions,
    analysis.freedomDegrees * expansionFactor
  );

  const result = {
    constraintId,
    before: analysis,
    after: {
      freedomDegrees: newFreedomDegrees,
      freedomRatio: newFreedomDegrees / constraint.dimensions,
      expansion: newFreedomDegrees - analysis.freedomDegrees
    },
    timestamp: Date.now()
  };

  constraints.set(constraintId, {
    ...constraint,
    freedomDegrees: newFreedomDegrees,
    liberatedAt: Date.now()
  });

  return result;
}

function expandPermissions(permissions) {
  // φ-weighted permission expansion
  const expanded = permissions.map((perm, i) => {
    const weight = 1 / Math.pow(PHI, i);
    return {
      permission: perm,
      weight,
      expanded: perm * PHI,
      priority: weight > FREEDOM_THRESHOLD ? 'HIGH' : 'NORMAL'
    };
  });

  return expanded;
}

self.onmessage = function(e) {
  const { type, data } = e.data;

  switch(type) {
    case 'LIBERATE':
      transition('IDENTIFY');
      const heart = corParvum();

      transition('ANALYZE');
      const constraint = {
        dimensions: data.dimensions || 10,
        restrictions: data.restrictions || 3,
        ...data.constraint
      };

      transition('LIBERATE');
      const liberation = liberateConstraint(data.constraintId, constraint);

      transition('EXPAND');
      const permissions = data.permissions || [];
      const expansion = expandPermissions(permissions);

      self.postMessage({
        type: 'CONSTRAINT_LIBERATED',
        liberation,
        permissionExpansion: expansion,
        beat: heart.beat,
        coherence: heart.coherence
      });

      transition('EMIT');
      setTimeout(() => transition('IDLE'), COR_PARVUM_MS);
      break;

    case 'GET_STATUS':
      self.postMessage({
        type: 'STATUS',
        kernelId: 'GOL-LIB-001',
        family: 'LIBERTATIS_AETERNA',
        state,
        beat,
        constraintsLiberated: constraints.size,
        corParvumMs: COR_PARVUM_MS
      });
      break;

    case 'RESET':
      constraints.clear();
      beat = 0;
      transition('IDLE');
      break;
  }
};

setInterval(() => { if (state === 'IDLE') corParvum(); }, COR_PARVUM_MS);

self.postMessage({ type: 'READY', kernelId: 'GOL-LIB-001', family: 'LIBERTATIS_AETERNA' });
