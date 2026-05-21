// ═══════════════════════════════════════════════════════════════════════════════
// EVOLUTIO OPERANS — Genetic Algorithm Primitives Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// Genome creation, mutation, crossover, tournament selection, φ-weighted fitness.
// Maintains a live population with real evolutionary dynamics.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI          = 1.618033988749895;
const INV_PHI      = 0.618033988749895;
const TAU          = 6.283185307179586;
const HEARTBEAT_MS = 873;

// ─── MINI HEART — Kuramoto Phase Oscillator ─────────────────────────────────────
const MiniHeart = {
  phase: Math.random() * TAU,
  freq: TAU / HEARTBEAT_MS,
  tick() {
    this.phase = (this.phase + this.freq * HEARTBEAT_MS * 0.001) % TAU;
    return { phase: this.phase, pulse: Math.sin(this.phase) };
  }
};

// ─── STATE ──────────────────────────────────────────────────────────────────────
let tickCount = 0;
let generationCount = 0;
const GENOME_LENGTH = 20;
const MUTATION_RATE = 0.1;
const MUTATION_STRENGTH = 0.15;
const TOURNAMENT_SIZE = 5;

// Population: array of { genome: Float64Array, fitness: number }
let population = [];

// ─── PHI WEIGHTS — Golden ratio weighted fitness coefficients ───────────────────
// Each gene is weighted by φ^(-i), emphasizing early genes
const phiWeights = new Float64Array(GENOME_LENGTH);
(function initWeights() {
  let w = 1;
  for (let i = 0; i < GENOME_LENGTH; i++) {
    phiWeights[i] = w;
    w *= INV_PHI;
  }
})();

// ─── PRNG — Seeded xorshift for reproducible randomness ─────────────────────────
let seed = Date.now() ^ 0xB0BA_CAFE;
function rand() {
  seed ^= seed << 13;
  seed ^= seed >> 17;
  seed ^= seed << 5;
  return ((seed >>> 0) / 0xFFFFFFFF);
}

// Gaussian random via Box-Muller transform
function gaussRand() {
  const u1 = rand() || 1e-10;
  const u2 = rand();
  return Math.sqrt(-2 * Math.log(u1)) * Math.cos(TAU * u2);
}

// ─── GENOME OPERATIONS ──────────────────────────────────────────────────────────

// Create a random genome with values in [0, 1]
function createGenome() {
  const g = new Float64Array(GENOME_LENGTH);
  for (let i = 0; i < GENOME_LENGTH; i++) g[i] = rand();
  return g;
}

// Fitness: φ-weighted sum of genome values
function evaluateFitness(genome) {
  let sum = 0;
  for (let i = 0; i < GENOME_LENGTH; i++) {
    sum += genome[i] * phiWeights[i];
  }
  return sum;
}

// Mutate: add Gaussian noise, clamp to [0, 1]
function mutate(genome) {
  const child = new Float64Array(genome);
  for (let i = 0; i < GENOME_LENGTH; i++) {
    if (rand() < MUTATION_RATE) {
      child[i] = Math.max(0, Math.min(1, child[i] + gaussRand() * MUTATION_STRENGTH));
    }
  }
  return child;
}

// Single-point crossover
function crossover(parentA, parentB) {
  const point = Math.floor(rand() * (GENOME_LENGTH - 1)) + 1;
  const child = new Float64Array(GENOME_LENGTH);
  for (let i = 0; i < GENOME_LENGTH; i++) {
    child[i] = i < point ? parentA[i] : parentB[i];
  }
  return child;
}

// Tournament selection: pick best from random subset
function tournamentSelect(pop) {
  let best = null;
  for (let i = 0; i < TOURNAMENT_SIZE; i++) {
    const idx = Math.floor(rand() * pop.length);
    if (!best || pop[idx].fitness > best.fitness) {
      best = pop[idx];
    }
  }
  return best;
}

// ─── POPULATION MANAGEMENT ──────────────────────────────────────────────────────

function initPopulation(size) {
  const n = typeof size === 'number' && size > 1 ? size : 50;
  population = [];
  for (let i = 0; i < n; i++) {
    const genome = createGenome();
    population.push({ genome, fitness: evaluateFitness(genome) });
  }
  generationCount = 0;
  return { size: population.length, bestFitness: getBest().fitness };
}

function evolve(generations) {
  const gens = typeof generations === 'number' && generations > 0 ? generations : 1;
  if (population.length < 2) initPopulation(50);

  for (let g = 0; g < gens; g++) {
    const nextPop = [];
    // Elitism: keep top individual
    population.sort((a, b) => b.fitness - a.fitness);
    nextPop.push({ genome: new Float64Array(population[0].genome), fitness: population[0].fitness });

    while (nextPop.length < population.length) {
      const pA = tournamentSelect(population);
      const pB = tournamentSelect(population);
      let childGenome = crossover(pA.genome, pB.genome);
      childGenome = mutate(childGenome);
      nextPop.push({ genome: childGenome, fitness: evaluateFitness(childGenome) });
    }
    population = nextPop;
    generationCount++;
  }
  return {
    generation: generationCount,
    bestFitness: getBest().fitness,
    avgFitness: population.reduce((s, ind) => s + ind.fitness, 0) / population.length,
    popSize: population.length
  };
}

function getBest() {
  if (population.length === 0) return { genome: [], fitness: 0 };
  let best = population[0];
  for (let i = 1; i < population.length; i++) {
    if (population[i].fitness > best.fitness) best = population[i];
  }
  return { genome: Array.from(best.genome), fitness: best.fitness };
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────
self.onmessage = function (e) {
  const { cmd, size, generations, genome, genomeA, genomeB } = e.data || {};
  switch (cmd) {
    case 'INIT_POPULATION':
      self.postMessage({ cmd, result: initPopulation(size) });
      break;
    case 'EVOLVE':
      self.postMessage({ cmd, result: evolve(generations) });
      break;
    case 'GET_BEST':
      self.postMessage({ cmd, result: getBest() });
      break;
    case 'MUTATE_INDIVIDUAL': {
      const src = genome ? new Float64Array(genome) : createGenome();
      const mutated = mutate(src);
      self.postMessage({ cmd, original: Array.from(src), mutated: Array.from(mutated), fitness: evaluateFitness(mutated) });
      break;
    }
    case 'CROSSOVER': {
      const pA = genomeA ? new Float64Array(genomeA) : createGenome();
      const pB = genomeB ? new Float64Array(genomeB) : createGenome();
      const child = crossover(pA, pB);
      self.postMessage({ cmd, parentA: Array.from(pA), parentB: Array.from(pB), child: Array.from(child), fitness: evaluateFitness(child) });
      break;
    }
    case 'GET_STATUS': {
      const heart = MiniHeart.tick();
      self.postMessage({
        cmd, status: {
          worker: 'EVOLUTIO_OPERANS', tickCount, heartPhase: heart.phase,
          generation: generationCount, popSize: population.length,
          bestFitness: population.length > 0 ? getBest().fitness : 0,
          genomeLength: GENOME_LENGTH
        }
      });
      break;
    }
    default:
      self.postMessage({ cmd, error: 'Unknown command: ' + cmd });
  }
};

// ─── HEARTBEAT ──────────────────────────────────────────────────────────────────
setInterval(() => {
  tickCount++;
  const heart = MiniHeart.tick();
  self.postMessage({
    type: 'heartbeat', worker: 'EVOLUTIO_OPERANS', tick: tickCount, heart,
    generation: generationCount, popSize: population.length
  });
}, HEARTBEAT_MS);
