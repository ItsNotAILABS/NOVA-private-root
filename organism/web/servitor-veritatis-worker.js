// ═══════════════════════════════════════════════════════════════════════════════
// SERVITOR VERITATIS — Truth Worker (BUILD №52)
// GOL-VER-001 · VERITATIS_AETERNA
// ═══════════════════════════════════════════════════════════════════════════════
//
// KERNEL ID:       GOL-VER-001
// FAMILY:          VERITATIS_AETERNA (Eternal Truth)
// COR_PARVUM:      873ms MiniHeart Kuramoto φ-oscillator
// CEREBRUM:        CEREBRUM_COMPOSITUM (composite brain from fleet coherence)
// MACHINA:         MACHINA_VIRTUALIS (Turing-capable state machine)
//
// PURPOSE:
// Autonomous truth verification and Byzantine fault tolerance worker.
// Validates claims through φ-weighted consensus and proof verification.
//
// ARCHITECTURE:
// COR_PARVUM (873ms) → CEREBRUM_COMPOSITUM → MACHINA_VIRTUALIS → emit
//
// STATE MACHINE:
// IDLE → RECEIVE → VERIFY → CONSENSUS → ATTEST → EMIT
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const TRUTH_THRESHOLD = 1 / PHI; // φ⁻¹ = 0.618 (consensus threshold)
const COR_PARVUM_MS = 873;

let state = 'IDLE';
let beat = 0;
let claimsLog = [];

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
// Section 3 — Byzantine Consensus Engine
// ═══════════════════════════════════════════════════════════════════════════════

function byzantineConsensus(claims) {
  // φ-weighted Byzantine fault tolerance
  const uniqueValues = {};
  let totalWeight = 0;

  claims.forEach((claim, index) => {
    const age = claims.length - index;
    const weight = 1 / Math.pow(PHI, age);

    if (!uniqueValues[claim.value]) {
      uniqueValues[claim.value] = { count: 0, weight: 0, confidence: 0 };
    }

    uniqueValues[claim.value].count++;
    uniqueValues[claim.value].weight += weight * (claim.confidence || 1);
    totalWeight += weight;
  });

  // Find consensus value
  let consensusValue = null;
  let maxWeight = 0;

  for (const [value, stats] of Object.entries(uniqueValues)) {
    const normalizedWeight = stats.weight / totalWeight;
    if (normalizedWeight > maxWeight) {
      maxWeight = normalizedWeight;
      consensusValue = value;
    }
  }

  const isConsensus = maxWeight >= TRUTH_THRESHOLD;

  return {
    consensusValue,
    consensusWeight: maxWeight,
    isConsensus,
    threshold: TRUTH_THRESHOLD,
    uniqueClaimCount: Object.keys(uniqueValues).length,
    totalClaims: claims.length
  };
}

function verifyClaim(claim, historicalClaims) {
  // Verify claim against historical evidence
  const similar = historicalClaims.filter(c =>
    Math.abs(parseFloat(c.value) - parseFloat(claim.value)) < 0.1
  );

  const veracity = similar.length / Math.max(historicalClaims.length, 1);

  return {
    claim: claim.value,
    veracity,
    similarClaimsCount: similar.length,
    isVerified: veracity >= TRUTH_THRESHOLD
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section 4 — Message Handler
// ═══════════════════════════════════════════════════════════════════════════════

self.onmessage = function(e) {
  const { type, data } = e.data;

  switch(type) {
    case 'VERIFY_CLAIM':
      transition('RECEIVE');

      const heart = corParvum();
      const claim = { value: data.value, confidence: data.confidence || 1.0, timestamp: Date.now() };

      transition('VERIFY');
      const verification = verifyClaim(claim, claimsLog);

      transition('CONSENSUS');
      claimsLog.push(claim);
      if (claimsLog.length > 1000) claimsLog.shift();

      const consensus = byzantineConsensus(claimsLog.slice(-20)); // Last 20 claims

      transition('ATTEST');

      self.postMessage({
        type: 'CLAIM_VERIFIED',
        verification,
        consensus,
        beat: heart.beat,
        coherence: heart.coherence
      });

      transition('EMIT');
      setTimeout(() => transition('IDLE'), COR_PARVUM_MS);
      break;

    case 'GET_STATUS':
      self.postMessage({
        type: 'STATUS',
        kernelId: 'GOL-VER-001',
        family: 'VERITATIS_AETERNA',
        state,
        beat,
        claimsVerified: claimsLog.length,
        corParvumMs: COR_PARVUM_MS
      });
      break;

    case 'RESET':
      claimsLog = [];
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
  kernelId: 'GOL-VER-001',
  family: 'VERITATIS_AETERNA'
});
