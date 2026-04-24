// ═══════════════════════════════════════════════════════════════════════════════
// SOLUTOR — Autonomous Problem-Solving Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// Problem analysis, task decomposition, pattern finding, solution optimization,
// result verification, alternative generation, and φ-weighted ranking.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI            = 1.618033988749895;
const INV_PHI        = 0.618033988749895;
const TAU            = 6.283185307179586;
const SCHUMANN       = 7.83;
const GOLDEN_PULSE_MS = 618;

// ─── MINI HEART — Kuramoto Phase Oscillator ─────────────────────────────────────
const MiniHeart = {
  bpm:          72,
  phase:        Math.random() * TAU,
  kuramotoOrder: 0.95,
  amplitude:    0.8,
  health:       95,
  lastBeat:     Date.now(),
  beatCount:    0,
};

// ─── MINI BRAIN — LIF Neuron Ensemble ───────────────────────────────────────────
const MiniBrain = {
  regions: [
    { name: 'analyzer',    activation: 0.5, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'decomposer',  activation: 0.4, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'patternizer', activation: 0.6, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'optimizer',   activation: 0.3, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'verifier',    activation: 0.5, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
  ],
  chemicals: [
    { name: 'dopamine',      level: 0.5, decay: 0.02, production: 0.03 },
    { name: 'serotonin',     level: 0.5, decay: 0.015, production: 0.025 },
    { name: 'acetylcholine', level: 0.5, decay: 0.01, production: 0.02 },
  ],
  coherenceField: 0.8,
  thoughtCount:   0,
};

// ─── STATE ──────────────────────────────────────────────────────────────────────
let tickCount        = 0;
let problemsSolved   = 0;
let patternsFound    = 0;
let solutionsRanked  = 0;

// ─── TICK HEART — Kuramoto Oscillator ───────────────────────────────────────────
function tickHeart() {
  var h = MiniHeart;

  // Phase advance — golden-ratio frequency
  h.phase = (h.phase + PHI * TAU / 1000 * GOLDEN_PULSE_MS) % TAU;

  // Sinusoidal amplitude envelope
  h.amplitude = 0.5 + 0.5 * Math.sin(h.phase);

  // BPM modulated by amplitude and φ
  h.bpm = Math.round(60 + h.amplitude * 40 * PHI);

  // Kuramoto order — self-synchrony with φ-damping
  h.kuramotoOrder = h.kuramotoOrder * 0.99 + 0.01 * (0.5 + 0.5 * Math.cos(h.phase));

  // Beat bookkeeping
  h.beatCount++;
  h.lastBeat = Date.now();

  // Health score — exponential moving average towards nominal 95
  h.health = h.health * 0.98 + 95 * 0.02;
}

// ─── TICK BRAIN — LIF Membrane Dynamics ─────────────────────────────────────────
function tickBrain() {
  var b = MiniBrain;

  // Update chemical levels
  for (var c = 0; c < b.chemicals.length; c++) {
    var chem = b.chemicals[c];
    chem.level = chem.level * (1 - chem.decay) + chem.production;
    if (chem.level > 1) chem.level = 1;
    if (chem.level < 0) chem.level = 0;
  }

  // Neuromodulator drive from chemicals
  var drive = 0;
  for (var ci = 0; ci < b.chemicals.length; ci++) {
    drive += b.chemicals[ci].level;
  }
  drive = drive / b.chemicals.length;

  // LIF membrane dynamics for each region
  for (var r = 0; r < b.regions.length; r++) {
    var region = b.regions[r];

    // Leaky integration towards rest + drive
    region.membrane += (region.restPotential - region.membrane) * 0.1 + drive * PHI;
    region.activation = 1 / (1 + Math.exp(-(region.membrane + 55) * 0.2));

    // Spike detection
    if (region.membrane > region.threshold) {
      region.spikes++;
      region.membrane = region.restPotential;
      b.thoughtCount++;
    }
  }

  // Coherence field — Schumann-resonant phase alignment
  var phaseSum = 0;
  for (var ri = 0; ri < b.regions.length; ri++) {
    phaseSum += b.regions[ri].activation;
  }
  b.coherenceField = phaseSum / b.regions.length;
}

// ─── SOLVER DOMAIN OPERATIONS ───────────────────────────────────────────────────

function analyzeProblem(data) {
  problemsSolved++;
  var desc = (data && data.description) || 'unspecified problem';
  var len  = desc.length;

  // Complexity scales with description length modulated by φ
  var complexity = Math.min(10, Math.round(Math.log(len + 1) * PHI * 10) / 10);
  var domains    = ['algorithmic', 'mathematical', 'structural', 'optimization', 'logical'];
  var domain     = domains[len % domains.length];

  return {
    description:    desc,
    complexity:     complexity,
    domainClass:    domain,
    estimatedSteps: Math.ceil(complexity * PHI),
    confidence:     Math.round((1 - complexity / 15) * 100) / 100,
    phiResonance:   Math.round(Math.sin(complexity * INV_PHI) * 1000) / 1000,
    timestamp:      Date.now(),
  };
}

function decomposeTask(data) {
  var taskName = (data && data.task) || 'generic task';
  var depth    = (data && data.depth) || 3;
  depth = Math.min(depth, 6);

  var subtasks = [];
  for (var i = 0; i < depth; i++) {
    var deps = [];
    if (i > 0) deps.push(i - 1);
    subtasks.push({
      id:          i,
      name:        'subtask_' + i + '_' + taskName.substring(0, 8),
      complexity:  Math.round(Math.random() * 5 * PHI * 10) / 10,
      dependencies: deps,
      estimated:   Math.round(Math.random() * 100 * INV_PHI),
      status:      'pending',
    });
  }

  return {
    originalTask: taskName,
    subtasks:     subtasks,
    totalSteps:   subtasks.length,
    criticalPath: Math.ceil(depth * INV_PHI),
    timestamp:    Date.now(),
  };
}

function findPattern(data) {
  patternsFound++;
  var input = (data && data.values) || [];
  var patterns = [];

  // Check Fibonacci pattern
  if (input.length >= 3) {
    var isFib = true;
    for (var i = 2; i < input.length && isFib; i++) {
      if (input[i] !== input[i - 1] + input[i - 2]) isFib = false;
    }
    if (isFib) patterns.push({ type: 'fibonacci', confidence: 0.95 });
  }

  // Check geometric progression
  if (input.length >= 3) {
    var ratios = [];
    var isGeo = true;
    for (var g = 1; g < input.length; g++) {
      if (input[g - 1] === 0) { isGeo = false; break; }
      ratios.push(input[g] / input[g - 1]);
    }
    if (isGeo && ratios.length > 1) {
      var r0 = ratios[0];
      var geoMatch = ratios.every(function (r) { return Math.abs(r - r0) < 0.001; });
      if (geoMatch) patterns.push({ type: 'geometric', ratio: r0, confidence: 0.9 });
    }
  }

  // Check arithmetic progression
  if (input.length >= 3) {
    var diffs = [];
    for (var a = 1; a < input.length; a++) {
      diffs.push(input[a] - input[a - 1]);
    }
    var d0 = diffs[0];
    var arithMatch = diffs.every(function (d) { return Math.abs(d - d0) < 0.001; });
    if (arithMatch) patterns.push({ type: 'arithmetic', difference: d0, confidence: 0.9 });
  }

  // Check prime pattern
  if (input.length >= 2) {
    var allPrime = input.every(function (n) {
      if (n < 2) return false;
      for (var p = 2; p <= Math.sqrt(n); p++) { if (n % p === 0) return false; }
      return true;
    });
    if (allPrime) patterns.push({ type: 'prime', confidence: 0.85 });
  }

  // φ-ratio check
  if (input.length >= 2) {
    for (var pi = 1; pi < input.length; pi++) {
      if (input[pi - 1] !== 0 && Math.abs(input[pi] / input[pi - 1] - PHI) < 0.01) {
        patterns.push({ type: 'golden_ratio', index: pi, confidence: 0.8 });
        break;
      }
    }
  }

  if (patterns.length === 0) {
    patterns.push({ type: 'unknown', confidence: 0.1 });
  }

  return {
    inputLength:  input.length,
    patterns:     patterns,
    totalFound:   patternsFound,
    timestamp:    Date.now(),
  };
}

function optimizeSolution(data) {
  var solution = (data && data.solution) || {};
  var metric   = (data && data.metric) || 'efficiency';

  var baseScore  = Math.random() * 0.5 + 0.5;
  var phiBoost   = baseScore * INV_PHI;
  var finalScore = Math.round((baseScore + phiBoost) / 2 * 1000) / 1000;

  return {
    originalMetric: metric,
    baseScore:      Math.round(baseScore * 1000) / 1000,
    phiOptimized:   finalScore,
    improvement:    Math.round((finalScore - baseScore) / baseScore * 100 * 10) / 10 + '%',
    suggestions:    [
      'Apply φ-ratio partitioning for balanced decomposition',
      'Use golden-section search for convergence speedup',
      'Align iteration count to Fibonacci sequence',
    ],
    timestamp:      Date.now(),
  };
}

function verifyResult(data) {
  var result      = (data && data.result !== undefined) ? data.result : null;
  var constraints = (data && data.constraints) || [];

  var checks = [];
  for (var i = 0; i < constraints.length; i++) {
    var c = constraints[i];
    var passed = false;
    if (c.type === 'range' && typeof result === 'number') {
      passed = result >= (c.min || -Infinity) && result <= (c.max || Infinity);
    } else if (c.type === 'type') {
      passed = typeof result === c.expected;
    } else if (c.type === 'notNull') {
      passed = result !== null && result !== undefined;
    } else {
      passed = result !== null;
    }
    checks.push({ constraint: c.type || 'unknown', passed: passed });
  }

  var allPassed = checks.every(function (ch) { return ch.passed; });
  return {
    result:    result,
    checks:    checks,
    allPassed: allPassed,
    score:     allPassed ? PHI : INV_PHI,
    timestamp: Date.now(),
  };
}

function generateAlternatives(data) {
  var count = (data && data.count) || 5;
  count = Math.min(count, 10);
  var base = (data && data.approach) || 'brute-force';

  var strategies = [
    'divide-and-conquer', 'dynamic-programming', 'greedy',
    'backtracking', 'branch-and-bound', 'heuristic',
    'genetic-algorithm', 'simulated-annealing', 'gradient-descent',
    'phi-partitioning',
  ];

  var alternatives = [];
  for (var i = 0; i < count; i++) {
    var idx = (i + base.length) % strategies.length;
    alternatives.push({
      id:         i,
      strategy:   strategies[idx],
      complexity: ['O(n)', 'O(n log n)', 'O(n\u00B2)', 'O(2\u207F)'][i % 4],
      phiScore:   Math.round((Math.random() * 0.5 + 0.5) * PHI * 100) / 100,
      tradeoff:   i < count * INV_PHI ? 'speed' : 'accuracy',
    });
  }

  return {
    baseApproach:  base,
    alternatives:  alternatives,
    totalGenerated: alternatives.length,
    timestamp:     Date.now(),
  };
}

function rankSolutions(data) {
  solutionsRanked++;
  var solutions = (data && data.solutions) || [];

  var ranked = solutions.map(function (s, i) {
    var speed    = s.speed    || Math.random();
    var accuracy = s.accuracy || Math.random();
    var elegance = s.elegance || Math.random();

    // φ-weighted composite score
    var score = (speed * PHI + accuracy * PHI * PHI + elegance) / (PHI + PHI * PHI + 1);
    return {
      index:    i,
      label:    s.label || 'solution_' + i,
      speed:    Math.round(speed * 1000) / 1000,
      accuracy: Math.round(accuracy * 1000) / 1000,
      elegance: Math.round(elegance * 1000) / 1000,
      phiScore: Math.round(score * 1000) / 1000,
    };
  });

  ranked.sort(function (a, b) { return b.phiScore - a.phiScore; });

  return {
    ranked:         ranked,
    bestSolution:   ranked.length > 0 ? ranked[0] : null,
    totalRanked:    solutionsRanked,
    goldenCutoff:   Math.ceil(ranked.length * INV_PHI),
    timestamp:      Date.now(),
  };
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────
self.onmessage = function (e) {
  var msg = e.data || {};
  var cmd = msg.cmd || msg.type;
  if (!cmd) return;

  switch (cmd) {
    case 'ANALYZE_PROBLEM':
      self.postMessage({ cmd: cmd, result: analyzeProblem(msg.data) });
      break;

    case 'DECOMPOSE_TASK':
      self.postMessage({ cmd: cmd, result: decomposeTask(msg.data) });
      break;

    case 'FIND_PATTERN':
      self.postMessage({ cmd: cmd, result: findPattern(msg.data) });
      break;

    case 'OPTIMIZE_SOLUTION':
      self.postMessage({ cmd: cmd, result: optimizeSolution(msg.data) });
      break;

    case 'VERIFY_RESULT':
      self.postMessage({ cmd: cmd, result: verifyResult(msg.data) });
      break;

    case 'GENERATE_ALTERNATIVES':
      self.postMessage({ cmd: cmd, result: generateAlternatives(msg.data) });
      break;

    case 'RANK_SOLUTIONS':
      self.postMessage({ cmd: cmd, result: rankSolutions(msg.data) });
      break;

    case 'GET_VITALS': {
      tickHeart();
      tickBrain();
      self.postMessage({
        cmd: cmd,
        vitals: {
          worker:    'SOLUTOR',
          domain:    'PROBLEM_SOLVING',
          tickCount: tickCount,
          heart:     Object.assign({}, MiniHeart),
          brain: {
            regions:        MiniBrain.regions.map(function (r) { return Object.assign({}, r); }),
            chemicals:      MiniBrain.chemicals.map(function (c) { return Object.assign({}, c); }),
            coherenceField: MiniBrain.coherenceField,
            thoughtCount:   MiniBrain.thoughtCount,
          },
          metrics: { problemsSolved: problemsSolved, patternsFound: patternsFound, solutionsRanked: solutionsRanked },
        },
      });
      break;
    }

    default:
      self.postMessage({ cmd: cmd, error: 'Unknown command: ' + cmd });
  }
};

// ─── HEARTBEAT — φ-aligned 618 ms cadence ───────────────────────────────────────
setInterval(function () {
  tickCount++;
  tickHeart();
  tickBrain();
  self.postMessage({
    type:      'heartbeat',
    worker:    'SOLUTOR',
    domain:    'PROBLEM_SOLVING',
    tick:      tickCount,
    heart:     { bpm: MiniHeart.bpm, phase: MiniHeart.phase, amplitude: MiniHeart.amplitude, health: MiniHeart.health },
    brain:     { coherence: MiniBrain.coherenceField, thoughts: MiniBrain.thoughtCount },
    timestamp: Date.now(),
  });
}, GOLDEN_PULSE_MS);

// ─── STARTUP ────────────────────────────────────────────────────────────────────
console.log(
  'SOLUTOR SOLVER WORKER — awakened at \u03C6Hz | '
  + 'interval=' + GOLDEN_PULSE_MS + 'ms | '
  + 'Schumann=' + SCHUMANN + 'Hz | '
  + 'regions=' + MiniBrain.regions.length
);
