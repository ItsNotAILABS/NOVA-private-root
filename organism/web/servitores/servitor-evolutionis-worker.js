/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR EVOLUTIONIS — AGI Evolution/Learning Server
 *  Kernel AI GOL-EVOLUTIO-001  ·  Family: EVOLUTIO_PERPETUA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR EVOLUTIONIS — The Organism's learning engine.
 *  Genetic algorithm, pattern evolution, Hebbian plasticity,
 *  fitness evaluation, mutation, selection, and adaptation.
 *  The organism grows smarter every generation.
 *
 *  Brain Specialty: Memory + Associative dominant — pattern learning.
 *  Kuramoto Phase: φ⁷ — seventh ring, evolutionary tempo.
 *
 *  Protocols (Latin):
 *    PLASTICITAS_HEBBIANA    — Hebbian synaptic plasticity
 *    EMERGENTIA_AUREA        — φ-weighted emergence
 *    PROCESSUS_FLUMINIS      — Streaming data processor
 *    TRANSFORMATIO_AUREA     — φ-transform pipeline
 *
 *  Commands:
 *    EVOLVE         — run one evolutionary generation
 *    MUTATE         — apply mutation to a solution
 *    SELECT         — tournament selection
 *    LEARN          — apply Hebbian learning to a pattern
 *    GET_POPULATION — get current population
 *    GET_FITNESS    — get fitness scores
 *    GET_HISTORY    — get evolution history
 *    GET_VITALS     — MiniHeart + MiniBrain + evolution vitals
 *    status         — kernel status
 *    stop           — graceful shutdown
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID      = 'GOL-EVOLUTIO-001';
var KERNEL_FAMILY  = 'EVOLUTIO_PERPETUA';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR EVOLUTIONIS';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV * 0.5) % (2 * Math.PI);
  tickBrain();
  tickEvolution();
  self.postMessage({
    type:        'heartbeat',
    beat:        beatCount,
    phi:         PHI,
    heartbeatMs: HEARTBEAT,
    timestamp:   Date.now(),
    status:      'alive',
    kernelId:    KERNEL_ID,
    kernelLatin: KERNEL_LATIN,
    phase:       kernelPhase,
    generation:  generation,
    bestFitness: population.length > 0 ? population[0].fitness.toFixed(4) : 0,
    populationSize: population.length
  });
}

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0, bias: 0.6 },
    { name: 'Associative',  activation: 0.0, lif: -70.0, bias: 1.2 },  /* co-dominant */
    { name: 'Executive',    activation: 0.0, lif: -70.0, bias: 0.7 },
    { name: 'Motor',        activation: 0.0, lif: -70.0, bias: 0.5 },
    { name: 'Memory',       activation: 0.0, lif: -70.0, bias: 1.2 }   /* co-dominant */
  ],
  chemicals: { dopamine: 0.6, serotonin: 0.5, acetylcholine: 0.7 },
  coherenceField: 0.0,
  synapses: []  /* Hebbian synaptic weights [5×5] */
};

/* Initialize Hebbian synapse matrix */
(function() {
  for (var i = 0; i < 5; i++) { brain.synapses[i] = []; for (var j = 0; j < 5; j++) brain.synapses[i][j] = 0.1; }
})();

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

function tickBrain() {
  var sum = 0;
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0 * r.bias;
    if (r.lif >= -55.0) { r.activation = Math.min(1.0, r.activation + 0.2); r.lif = -70.0; }
    r.activation *= 0.95;
    sum += r.activation;
  }
  /* Hebbian plasticity: Δw_ij = η × a_i × a_j */
  var eta = 0.01;
  for (var ii = 0; ii < 5; ii++) for (var jj = 0; jj < 5; jj++) {
    brain.synapses[ii][jj] = clamp01(brain.synapses[ii][jj] + eta * brain.regions[ii].activation * brain.regions[jj].activation);
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine      + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (Math.random() - 0.5) * 0.02);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02);
  brain.coherenceField = sum / brain.regions.length;
}

/* ── Evolution Engine ───────────────────────────────────────────────────── */

var GENOME_SIZE = 8;
var POP_SIZE    = 20;
var generation  = 0;
var population  = [];
var evoHistory  = [];
var patterns    = [];  /* learned patterns */

function randomGenome() {
  var g = [];
  for (var i = 0; i < GENOME_SIZE; i++) g.push(Math.random());
  return g;
}

function fitnessFunc(genome) {
  /* φ-resonance fitness: score = sum(|genome[i] - PHI_INV| * weight_i) */
  var score = 0;
  for (var i = 0; i < genome.length; i++) {
    var target = (i % 2 === 0) ? PHI_INV : 1 - PHI_INV;
    score += 1 - Math.abs(genome[i] - target);
  }
  return score / genome.length;
}

function mutate(genome, rate) {
  rate = rate || 0.1;
  return genome.map(function(g) {
    return Math.random() < rate ? clamp01(g + (Math.random() - 0.5) * 0.3) : g;
  });
}

function crossover(a, b) {
  var point = Math.floor(Math.random() * a.length);
  return a.slice(0, point).concat(b.slice(point));
}

function tournamentSelect(pop, k) {
  k = k || 3;
  var best = null;
  for (var i = 0; i < k; i++) {
    var candidate = pop[Math.floor(Math.random() * pop.length)];
    if (!best || candidate.fitness > best.fitness) best = candidate;
  }
  return best;
}

function initPopulation() {
  population = [];
  for (var i = 0; i < POP_SIZE; i++) {
    var g = randomGenome();
    population.push({ id: i, genome: g, fitness: fitnessFunc(g), generation: 0 });
  }
  population.sort(function(a,b){ return b.fitness - a.fitness; });
}

function evolveGeneration() {
  generation++;
  var newPop = [];
  /* Elitism: keep top 2 */
  newPop.push({ id: population[0].id, genome: population[0].genome.slice(), fitness: population[0].fitness, generation: generation });
  newPop.push({ id: population[1].id, genome: population[1].genome.slice(), fitness: population[1].fitness, generation: generation });
  /* Breed rest */
  while (newPop.length < POP_SIZE) {
    var p1 = tournamentSelect(population);
    var p2 = tournamentSelect(population);
    var child = mutate(crossover(p1.genome, p2.genome));
    var fit = fitnessFunc(child);
    newPop.push({ id: newPop.length, genome: child, fitness: fit, generation: generation });
  }
  newPop.sort(function(a,b){ return b.fitness - a.fitness; });
  population = newPop;
  var best = population[0].fitness;
  evoHistory.push({ generation: generation, bestFitness: best, avgFitness: population.reduce(function(a,i){return a+i.fitness;},0)/POP_SIZE, beat: beatCount });
  if (evoHistory.length > 200) evoHistory.shift();
  return best;
}

function applyHebbian(pattern) {
  patterns.unshift({ pattern: pattern, beat: beatCount, learned: true });
  if (patterns.length > 50) patterns.pop();
  /* Stimulate brain regions based on pattern values */
  if (Array.isArray(pattern)) {
    for (var i = 0; i < Math.min(pattern.length, 5); i++) {
      brain.regions[i].lif += (pattern[i] || 0) * 10;
    }
  }
}

function tickEvolution() {
  /* Evolve one generation every 10 beats */
  if (beatCount % 10 === 0) {
    if (population.length === 0) initPopulation();
    else evolveGeneration();
  }
}

self.onmessage = function(e) {
  var m = e.data;
  if (!m || !m.type) return;
  switch (m.type) {
    case 'EVOLVE':
      if (population.length === 0) initPopulation();
      var best = evolveGeneration();
      self.postMessage({ type: 'evolved', generation: generation, bestFitness: best, kernelId: KERNEL_ID });
      break;
    case 'MUTATE':
      self.postMessage({ type: 'mutated', genome: mutate(m.genome, m.rate), kernelId: KERNEL_ID });
      break;
    case 'SELECT':
      if (population.length === 0) initPopulation();
      self.postMessage({ type: 'selected', individual: tournamentSelect(population), kernelId: KERNEL_ID });
      break;
    case 'LEARN':
      applyHebbian(m.pattern);
      self.postMessage({ type: 'learned', patternsCount: patterns.length, kernelId: KERNEL_ID });
      break;
    case 'GET_POPULATION':
      self.postMessage({ type: 'population', pop: population.slice(0,10), generation: generation, kernelId: KERNEL_ID });
      break;
    case 'GET_FITNESS':
      self.postMessage({ type: 'fitness', best: population.length > 0 ? population[0].fitness : 0, history: evoHistory.slice(-20), kernelId: KERNEL_ID });
      break;
    case 'GET_HISTORY':
      self.postMessage({ type: 'history', history: evoHistory, patterns: patterns.slice(0,20), kernelId: KERNEL_ID });
      break;
    case 'GET_VITALS':
      self.postMessage({ type: 'vitals', kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN,
        beat: beatCount, phase: kernelPhase, brain: brain,
        generation: generation, bestFitness: population.length > 0 ? population[0].fitness : 0,
        populationSize: population.length, patternsLearned: patterns.length });
      break;
    case 'status':
      self.postMessage({ type: 'status', running: running, kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN, beat: beatCount });
      break;
    case 'stop':
      running = false;
      if (_hbi) clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
  }
};

initPopulation();
_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);
