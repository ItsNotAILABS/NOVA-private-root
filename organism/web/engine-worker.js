// ═══════════════════════════════════════════════════════════════════════════════
// ANIMA MICRO — Master Engine Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// 40 micro-workers pulsing at φHz — Leaky Integrate-and-Fire neurons,
// Kuramoto heart oscillators, Schumann-resonant brain clocks.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI            = 1.618033988749895;
const INV_PHI        = 0.618033988749895;
const TAU            = 6.283185307179586;
const SCHUMANN       = 7.83;              // Earth resonance (Hz)
const HEARTBEAT_MS   = 873;               // ~69 bpm resting heart
const GOLDEN_PULSE_MS = 618;              // φ-aligned tick interval
const PLANCK         = 6.62607015e-34;    // Planck constant (J·s)
const BOLTZMANN      = 1.380649e-23;      // Boltzmann constant (J/K)

// ─── DOMAIN DEFINITIONS ────────────────────────────────────────────────────────
// Each domain hosts 4 micro-workers. 10 domains × 4 = 40 workers.
const DOMAINS = [
  { domain: 'CONSENSUS',      names: ['Pactum',     'Suffragium',  'Quorum',      'Validatio']   },
  { domain: 'ENCRYPTION',     names: ['Arcanum',    'Clavis',      'Sigillum',    'Crypta']      },
  { domain: 'MEMORY',         names: ['Memoria',    'Thesaurus',   'Recordatio',  'Archivum']    },
  { domain: 'ROUTING',        names: ['Itinerarius','Viaticus',    'Cursor',      'Navigator']   },
  { domain: 'ORCHESTRATION',  names: ['Magister',   'Compositor',  'Harmonia',    'Tempus']      },
  { domain: 'COMPUTATION',    names: ['Calculator', 'Numerator',   'Logicus',     'Analyticus']  },
  { domain: 'EVOLUTION',      names: ['Mutatio',    'Selectio',    'Adaptatio',   'Genesis']     },
  { domain: 'COMMUNICATION',  names: ['Nuntius',    'Interpres',   'Legatus',     'Orator']      },
  { domain: 'GOVERNANCE',     names: ['Rex',        'Consul',      'Senator',     'Praetor']     },
  { domain: 'NEURAL',         names: ['Neuron',     'Synapticus',  'Cortex',      'Dendriticus'] },
];

// ─── MICRO WORKER FACTORY ───────────────────────────────────────────────────────

/**
 * Build a fresh brain state — Leaky Integrate-and-Fire neuron model.
 */
function makeBrain() {
  return {
    phase:         0,
    frequency:     SCHUMANN,
    membrane:      -70,        // mV resting potential
    threshold:     -55,        // mV spike threshold
    fired:         false,
    dopamine:      0.5,
    serotonin:     0.5,
    acetylcholine: 0.5,
  };
}

/**
 * Build a fresh heart state — Kuramoto-style oscillator.
 */
function makeHeart() {
  return {
    phase:       0,
    frequency:   PHI,
    bpm:         97,
    amplitude:   0.8,
    healthScore: 95,
    beatCount:   0,
    isBeating:   true,
  };
}

/**
 * Generate the full roster of 40 ANIMA MICRO workers.
 */
function buildWorkers() {
  const workers = [];
  let id = 1;
  for (const { domain, names } of DOMAINS) {
    for (const name of names) {
      workers.push({
        id:           id,
        name:         name,
        nomenLatinum: name,      // Latin designation mirrors display name
        domain:       domain,
        brain:        makeBrain(),
        heart:        makeHeart(),
        status:       'ACTIVE',
        tickCount:    0,
        lastPulse:    Date.now(),
      });
      id++;
    }
  }
  return workers;
}

const MICRO_WORKERS = buildWorkers();

// ─── BRAIN TICK — Leaky Integrate-and-Fire ──────────────────────────────────────

/**
 * Advance one LIF neuron step for the given worker.
 * Membrane potential rises from neuromodulator drive; when it crosses
 * the threshold a spike is emitted and the membrane resets.
 *
 * @param {object} w - A micro-worker object.
 * @returns {string|null} A thought string on spike, null otherwise.
 */
function tickBrain(w) {
  const b = w.brain;
  let thought = null;

  // Neuromodulator drive pushes membrane towards or away from threshold
  b.membrane += (b.dopamine + b.serotonin) * 2 - 1;

  // Spike detection
  if (b.membrane > b.threshold) {
    b.fired = true;
    thought = w.name + ':SPIKE@' + w.tickCount;
    b.membrane = -70; // post-spike reset
  } else {
    b.fired = false;
  }

  // Advance Schumann-resonant phase clock
  b.phase = (b.phase + SCHUMANN * TAU / 1000 * GOLDEN_PULSE_MS) % TAU;

  return thought;
}

// ─── HEART TICK — Kuramoto Oscillator ───────────────────────────────────────────

/**
 * Advance one Kuramoto oscillator step for the given worker.
 * Phase advances at φ-scaled rate; amplitude and BPM derive from phase.
 *
 * @param {object} w - A micro-worker object.
 */
function tickHeart(w) {
  const h = w.heart;

  // Phase advance — golden-ratio frequency
  h.phase = (h.phase + PHI * TAU / 1000 * GOLDEN_PULSE_MS) % TAU;

  // Sinusoidal amplitude envelope
  h.amplitude = 0.5 + 0.5 * Math.sin(h.phase);

  // BPM modulated by amplitude and φ
  h.bpm = Math.round(60 + h.amplitude * 40 * PHI);

  // Beat bookkeeping
  h.beatCount++;

  // Health score — exponential moving average towards nominal 95
  h.healthScore = h.healthScore * 0.98 + 95 * 0.02;
}

// ─── TICK ALL ───────────────────────────────────────────────────────────────────

/**
 * Master tick — advances brain and heart for every micro-worker.
 * Collects any spike thoughts for downstream logging.
 *
 * @returns {{ thoughts: string[], timestamp: number }}
 */
function tickAll() {
  const thoughts = [];
  const now = Date.now();

  for (let i = 0; i < MICRO_WORKERS.length; i++) {
    const w = MICRO_WORKERS[i];
    w.tickCount++;
    w.lastPulse = now;

    const thought = tickBrain(w);
    if (thought) thoughts.push(thought);

    tickHeart(w);
  }

  return { thoughts: thoughts, timestamp: now };
}

// ─── KURAMOTO ORDER PARAMETER ───────────────────────────────────────────────────

/**
 * Compute collective synchrony r = |1/N Σ e^(iθ)|.
 * r ≈ 1 → perfect phase lock; r ≈ 0 → incoherent.
 *
 * @returns {number} Order parameter r ∈ [0, 1].
 */
function computeKuramotoOrder() {
  let sumCos = 0;
  let sumSin = 0;
  const N = MICRO_WORKERS.length;

  for (let i = 0; i < N; i++) {
    const theta = MICRO_WORKERS[i].heart.phase;
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }

  return Math.sqrt(sumCos * sumCos + sumSin * sumSin) / N;
}

// ─── STATUS / VITALS SNAPSHOT ───────────────────────────────────────────────────

/**
 * Build a lightweight status snapshot of all 40 workers.
 */
function getStatus() {
  return MICRO_WORKERS.map(function (w) {
    return {
      id:        w.id,
      name:      w.name,
      domain:    w.domain,
      status:    w.status,
      tickCount: w.tickCount,
      brain: {
        membrane: w.brain.membrane,
        phase:    w.brain.phase,
        fired:    w.brain.fired,
      },
      heart: {
        bpm:         w.heart.bpm,
        amplitude:   w.heart.amplitude,
        healthScore: w.heart.healthScore,
        beatCount:   w.heart.beatCount,
      },
    };
  });
}

/**
 * Compute aggregated vitals across the whole micro-swarm.
 */
function getVitals() {
  let totalBeats   = 0;
  let totalHealth  = 0;
  let totalTicks   = 0;
  const N = MICRO_WORKERS.length;

  for (let i = 0; i < N; i++) {
    totalBeats  += MICRO_WORKERS[i].heart.beatCount;
    totalHealth += MICRO_WORKERS[i].heart.healthScore;
    totalTicks  += MICRO_WORKERS[i].tickCount;
  }

  return {
    workerCount:   N,
    totalBeats:    totalBeats,
    avgHealth:     totalHealth / N,
    avgTicks:      totalTicks / N,
    kuramotoOrder: computeKuramotoOrder(),
    timestamp:     Date.now(),
  };
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────

self.onmessage = function (e) {
  var msg = e.data;
  if (!msg || !msg.type) return;

  switch (msg.type) {
    case 'GET_STATUS':
      self.postMessage({ type: 'STATUS', payload: getStatus() });
      break;

    case 'GET_VITALS':
      self.postMessage({ type: 'VITALS', payload: getVitals() });
      break;

    case 'TICK': {
      var result = tickAll();
      self.postMessage({ type: 'TICK_RESULT', payload: result });
      break;
    }

    default:
      self.postMessage({ type: 'ERROR', payload: 'Unknown command: ' + msg.type });
      break;
  }
};

// ─── STARTUP ────────────────────────────────────────────────────────────────────

console.log(
  'ANIMA MICRO ENGINE — 40 micro-workers awakened at \u03C6Hz | '
  + 'interval=' + GOLDEN_PULSE_MS + 'ms | '
  + 'Schumann=' + SCHUMANN + 'Hz'
);

// Main heartbeat loop — φ-aligned 618 ms cadence
const _engineInterval = setInterval(tickAll, GOLDEN_PULSE_MS);
