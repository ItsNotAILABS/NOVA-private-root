// Swarm state hook — self-hosted local simulation
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.

import { useState, useEffect, useRef, useCallback } from 'react';

// ─── CONSTANTS ────────────────────────────────────────────────────────────────
const MAX_DRONES   = 12;
const HELIX_ALPHA  = 0.01;   // Hebbian inter-drone learning rate
const W_CEIL       = 2.0;    // Hebbian weight ceiling
const KURAMOTO_K   = 0.618;  // Kuramoto coupling constant
const BRAIN_NODES  = 6;      // 0=SENSOR 1=MEMORY 2=EXECUTIVE 3=EMOTIONAL 4=MOTOR 5=OUTPUT
const STDP_ALPHA   = 0.005;  // STDP learning rate
const STDP_DECAY   = 0.001;  // STDP weight decay
const DT           = 0.05;   // ODE integration step (beats)
// Quantum cognitive channel update time-constant (beats) — matches swarm_quantum CHAN_TAU
const CHAN_TAU      = 10.0;
// Now-attention pull rate
const NOW_RATE      = 0.05;
// Law 24: Faction Resistance thresholds — mirrors swarm_brain constants
const FACTION_DOMINANCE_THRESHOLD = 0.7;  // signal dominance ratio above which resistance fires
const FACTION_NOR_MULTIPLIER      = 1.3;  // norepinephrine surge multiplier for non-dominant drones
const FACTION_SIGNAL_MULTIPLIER   = 1.1;  // signal boost multiplier for non-dominant drones

// ─── MATH PRIMITIVES ─────────────────────────────────────────────────────────
function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }
function sf(x) { return Math.max(1.0, x); }   // sovereign floor
function sigmoid(x) { return 1.0 / (1.0 + Math.exp(-clamp(x, -10, 10))); }

// ─── NEUROCHEMICAL BASELINES ─────────────────────────────────────────────────
const CHEM_BASELINES = {
  SCOUT:     [1.0, 1.0, 1.5, 1.0],
  STRIKER:   [1.0, 1.3, 1.2, 1.0],
  GUARDIAN:  [1.0, 1.1, 1.0, 1.5],
  RELAY:     [1.5, 1.0, 1.0, 1.0],
  MEDIC:     [1.0, 1.0, 1.0, 1.5],
  SOVEREIGN: [1.2, 1.2, 1.2, 1.2],
};

// ─── DRONE FACTORY ───────────────────────────────────────────────────────────
function makeDrone(id) {
  const classes = ['SCOUT', 'STRIKER', 'GUARDIAN', 'RELAY', 'MEDIC', 'SOVEREIGN'];
  const cls = id === 0 ? 'SOVEREIGN' : classes[id % classes.length];
  const [dopBase, corBase, norBase, oxyBase] = CHEM_BASELINES[cls];
  const angle  = (id / MAX_DRONES) * Math.PI * 2;
  const radius = 30 + Math.random() * 20;

  // Initial 6×6 brain weight matrix (rows=to, cols=from)
  const brainWeights = Array.from({ length: BRAIN_NODES * BRAIN_NODES }, () =>
    0.5 + Math.random() * 0.5
  );

  return {
    id,
    cls,
    posX: Math.cos(angle) * radius,
    posY: (Math.random() - 0.5) * 8,
    posZ: Math.sin(angle) * radius,
    velX: 0,
    velZ: 0,
    phase: id * 0.2,
    omega: 0.8 + Math.random() * 0.4,
    signal: 1.0,
    energy: 1.5,
    dopamine:       sf(dopBase),
    cortisol:       sf(corBase),
    norepinephrine: sf(norBase),
    oxytocin:       sf(oxyBase),
    activation: 1.0,
    sacrificed: false,
    lastBeat: 0,
    // 6-node micro-brain
    brainWeights,
    brainActivation: Array(BRAIN_NODES).fill(0.5),
    // Four 360-degree quantum cognitive channels
    // ALPHA=spatial/sensor  BETA=temporal/memory
    // GAMMA=relational      DELTA=executive-motor
    qAlpha: 0.5,
    qBeta:  0.5,
    qGamma: 0.5,
    qDelta: 0.5,
    // Convergence: how much all 4 channels agree (0=diverge, 1=fully aligned)
    qConvergence: 0.0,
    // Quantum coherence (internal+swarm alignment)
    qCoherence: 0.5,
    // Present-moment attention weight [0,1]
    nowAttention: 1.0,
  };
}

// ─── KURAMOTO ORDER PARAMETER ─────────────────────────────────────────────────
function computeRSwarm(drones) {
  const active = drones.filter(d => !d.sacrificed);
  if (!active.length) return 0.88;
  const n = active.length;
  const sumCos = active.reduce((s, d) => s + Math.cos(d.phase), 0) / n;
  const sumSin = active.reduce((s, d) => s + Math.sin(d.phase), 0) / n;
  return clamp(Math.sqrt(sumCos * sumCos + sumSin * sumSin), 0.5, 1.0);
}

// ─── JASMINE LYAPUNOV DRIFT ───────────────────────────────────────────────────
function computeJDrift(drones) {
  const active = drones.filter(d => !d.sacrificed);
  if (!active.length) return 0;
  const n = active.length;
  const meanPhase = active.reduce((s, d) => s + d.phase, 0) / n;
  const meanCort  = active.reduce((s, d) => s + d.cortisol, 0) / n;
  const meanSig   = active.reduce((s, d) => s + d.signal, 0) / n;
  const j1 = active.reduce((s, d) => s + 0.4 * (d.phase - meanPhase) ** 2, 0) / n;
  const j2 = active.reduce((s, d) => s + 0.3 * (d.cortisol - meanCort) ** 2, 0) / n;
  const j3 = active.reduce((s, d) => s + 0.3 * (d.signal - meanSig) ** 2, 0) / n;
  return j1 + j2 + j3;
}

// ─── 6-NODE BRAIN FORWARD PASS ────────────────────────────────────────────────
// Nodes: 0=SENSOR 1=MEMORY 2=EXECUTIVE 3=EMOTIONAL 4=MOTOR 5=OUTPUT
// Neurochemicals gate each node's bias. Two settling passes (recurrent).
function brainForwardPass(drone, architectSignal) {
  const { dopamine: D, cortisol: C, norepinephrine: N, oxytocin: O, brainWeights } = drone;
  // Neurochemical biases (each chem's excess above 1.0 modulates its node)
  const bias = [
    N * 0.25,                          // SENSOR:     arousal sharpens sensing
    D * 0.20,                          // MEMORY:     dopamine consolidates
    D * 0.15 - C * 0.10,              // EXECUTIVE:  reward enables, stress impairs
    C * 0.30 + N * 0.20,              // EMOTIONAL:  stress + arousal
    N * 0.35,                          // MOTOR:      arousal drives action
    O * 0.20 + architectSignal * 0.30, // OUTPUT:     cohesion + external command
  ];
  let act = [...drone.brainActivation];
  // 2 forward settling passes through the 6×6 recurrent matrix
  for (let pass = 0; pass < 2; pass++) {
    const next = Array(BRAIN_NODES).fill(0);
    for (let i = 0; i < BRAIN_NODES; i++) {
      let sum = bias[i];
      for (let j = 0; j < BRAIN_NODES; j++) {
        sum += brainWeights[i * BRAIN_NODES + j] * act[j];
      }
      next[i] = sigmoid(sum);
    }
    act = next;
  }
  return act; // [activation_0 .. activation_5]
}

// ─── STDP WEIGHT UPDATE ───────────────────────────────────────────────────────
// Δw_ij = α · (pre · post) − decay · w_ij   (BCM-like unsupervised Hebbian)
function stdpUpdate(weights, activations) {
  return weights.map((w, idx) => {
    const i = Math.floor(idx / BRAIN_NODES);
    const j = idx % BRAIN_NODES;
    const dw = STDP_ALPHA * activations[i] * activations[j] - STDP_DECAY * w;
    return clamp(w + dw, 0.1, 3.0);
  });
}

// ─── COUPLED NEUROCHEMICAL ODEs ───────────────────────────────────────────────
// 4-species system: DOPAMINE, CORTISOL, NOREPINEPHRINE, OXYTOCIN
// Euler integration with dt = DT
function neurochemStep(drone, rSwarm, jDrift, meanHebb) {
  const { dopamine: D, cortisol: C, norepinephrine: N, oxytocin: O, cls, energy } = drone;
  const [dopBase, corBase, norBase, oxyBase] = CHEM_BASELINES[cls] || [1, 1, 1, 1];

  // DOPAMINE: reward signal ← swarm coherence × energy
  const dD = (0.5 * rSwarm * clamp(energy, 0, 2) - 0.15 * (D - dopBase)) * DT;

  // CORTISOL: stress ← Jasmine drift, antagonized by oxytocin
  const corExcess = Math.max(0, C - 1.0);
  const dC = (0.8 * jDrift - 0.20 * O * corExcess - 0.10 * (C - corBase)) * DT;

  // NOREPINEPHRINE: arousal ← cortisol above class baseline
  const dN = (0.6 * Math.max(0, C - corBase) - 0.25 * (N - norBase)) * DT;

  // OXYTOCIN: bonding ← Hebbian proximity + coherence
  const dO = (0.4 * meanHebb + 0.3 * rSwarm - 0.20 * (O - oxyBase)) * DT;

  return {
    dopamine:       sf(D + dD),
    cortisol:       sf(C + dC),
    norepinephrine: sf(N + dN),
    oxytocin:       sf(O + dO),
  };
}

// ─── ENERGY MODEL ─────────────────────────────────────────────────────────────
// Replenish over time; deplete from signaling, neural activity, movement
function energyStep(drone) {
  const REPLENISH   = 0.015;
  const SIGNAL_COST = 0.003;
  const BRAIN_COST  = 0.002;
  const MOVE_COST   = 0.005;
  const meanAct = drone.brainActivation.reduce((s, a) => s + a, 0) / BRAIN_NODES;
  const speed   = Math.sqrt(drone.velX ** 2 + drone.velZ ** 2);
  const newE = drone.energy
    + REPLENISH
    - SIGNAL_COST * drone.signal
    - BRAIN_COST  * meanAct
    - MOVE_COST   * speed;
  return clamp(newE, 0.2, 2.0);
}

// ─── REYNOLDS BOIDS FLOCKING ──────────────────────────────────────────────────
// Separation · Alignment · Cohesion · Anchor-to-formation-center
function boidsUpdate(drone, allDrones, rSwarm) {
  const SEP_R    = 15.0;
  const COH_R    = 50.0;
  const MAX_SPD  = 0.45;
  const W_SEP    = 1.5, W_ALI = 0.8, W_COH = 0.6;
  const anchorK  = 0.005 + 0.02 * rSwarm; // tighter anchor when swarm is coherent

  let [sepX, sepZ] = [0, 0];
  let [aliX, aliZ] = [0, 0];
  let [cohX, cohZ] = [0, 0];
  let nSep = 0, nAli = 0, nCoh = 0;

  for (const o of allDrones) {
    if (o.sacrificed || o.id === drone.id) continue;
    const dx = drone.posX - o.posX;
    const dz = drone.posZ - o.posZ;
    const dist = Math.sqrt(dx * dx + dz * dz) + 0.001;
    if (dist < SEP_R) { sepX += dx / dist; sepZ += dz / dist; nSep++; }
    if (dist < COH_R) {
      aliX += o.velX; aliZ += o.velZ; nAli++;
      cohX += o.posX; cohZ += o.posZ; nCoh++;
    }
  }
  if (nSep) { sepX /= nSep; sepZ /= nSep; }
  if (nAli) { aliX /= nAli; aliZ /= nAli; }
  if (nCoh) { cohX = cohX / nCoh - drone.posX; cohZ = cohZ / nCoh - drone.posZ; }

  // Anchor: weak pull to orbit center
  const ancX = -drone.posX * anchorK;
  const ancZ = -drone.posZ * anchorK;

  const forceX = W_SEP * sepX + W_ALI * aliX + W_COH * cohX + ancX;
  const forceZ = W_SEP * sepZ + W_ALI * aliZ + W_COH * cohZ + ancZ;

  // Norepinephrine modulates speed — arousal makes drones move faster
  const norExcess = Math.max(0, drone.norepinephrine - 1.0);
  const speedMod  = clamp(0.5 + 0.8 * norExcess, 0.5, 2.0);

  let newVX = drone.velX * 0.85 + forceX * 0.05;
  let newVZ = drone.velZ * 0.85 + forceZ * 0.05;
  const speed = Math.sqrt(newVX * newVX + newVZ * newVZ);
  if (speed > MAX_SPD * speedMod) {
    newVX = newVX / speed * MAX_SPD * speedMod;
    newVZ = newVZ / speed * MAX_SPD * speedMod;
  }
  return {
    velX: newVX,
    velZ: newVZ,
    posX: drone.posX + newVX,
    posZ: drone.posZ + newVZ,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// ─── ORGANISM LAYER MATH ─────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

const GRID_W     = 20;
const GRID_CELLS = 400;

// Convert world position (range [-100, 100]) to a flat 20×20 grid cell index
function worldToCell(posX, posZ) {
  const gx = Math.min(GRID_W - 1, Math.floor(Math.max(0, (posX + 100) / 200 * GRID_W)));
  const gz = Math.min(GRID_W - 1, Math.floor(Math.max(0, (posZ + 100) / 200 * GRID_W)));
  return gz * GRID_W + gx;
}

// Shannon entropy of swarm signal distribution
function swarmEntropy(drones) {
  const active = drones.filter(d => !d.sacrificed);
  const total  = active.reduce((s, d) => s + d.signal, 0);
  if (total < 1e-6) return 0;
  return -active.reduce((h, d) => {
    const p = d.signal / total;
    return p > 1e-4 ? h + p * Math.log(p) : h;
  }, 0);
}

// Ising mean-field consensus: m = tanh(J · m), J=1.2
function isingConsensus(drones) {
  const active = drones.filter(d => !d.sacrificed);
  if (!active.length) return 0;
  const m = active.reduce((s, d) => s + (d.dopamine > 1.1 ? 1 : -1), 0) / active.length;
  return Math.tanh(1.2 * m);
}

// Assign behavior label from neurochemistry + class
function getBehavior(drone) {
  const { cls, cortisol, norepinephrine, dopamine, sacrificed } = drone;
  if (sacrificed) return 'IDLE';
  if (cortisol > 2.0) return 'RETREAT';
  switch (cls) {
    case 'SCOUT':    return norepinephrine > 1.4 ? 'FORAGE' : 'SCOUT';
    case 'STRIKER':  return (norepinephrine > 1.3 && cortisol < 1.6) ? 'ENGAGE' : (cortisol < 1.3 ? 'AMBUSH' : 'RETREAT');
    case 'GUARDIAN': return 'DEFEND';
    case 'RELAY':    return 'RELAY';
    case 'MEDIC':    return 'HEAL';
    case 'SOVEREIGN':return dopamine > 1.3 ? 'FORM' : 'DEFEND';
    default:         return 'SCOUT';
  }
}

// Elect team captain per class (highest signal drone in each class)
function electCaptains(drones) {
  const teams = ['SCOUT','STRIKER','GUARDIAN','RELAY','MEDIC'];
  const captains = {};
  for (const team of teams) {
    const members = drones.filter(d => !d.sacrificed && (d.cls === team || (team === 'SCOUT' && d.cls === 'SOVEREIGN')));
    if (members.length) {
      captains[team] = members.reduce((best, d) => d.signal > best.signal ? d : best, members[0]).id;
    } else {
      captains[team] = null;
    }
  }
  return captains;
}

// Team morale = mean activation per class
function teamMorale(drones) {
  const teams = ['SCOUT','STRIKER','GUARDIAN','RELAY','MEDIC'];
  const morale = {};
  for (const team of teams) {
    const members = drones.filter(d => !d.sacrificed && d.cls === team);
    morale[team] = members.length
      ? members.reduce((s, d) => s + d.activation, 0) / members.length
      : 1.0;
  }
  return morale;
}

// ─── BEE HIVE MIND ────────────────────────────────────────────────────────────

// Waggle dance: encode scout discovery as quality + angle vector
function computeWaggle(drones) {
  return drones.map(d => ({
    id:      d.id,
    quality: d.cls === 'SCOUT' || d.cls === 'SOVEREIGN' ? clamp(d.signal * d.energy - 1, 0, 1) : 0,
    angle:   d.phase % (2 * Math.PI),
    active:  (d.cls === 'SCOUT' || d.cls === 'SOVEREIGN') && d.signal > 1.2,
  }));
}

// Queen pheromone: decays exponentially, boosted by SOVEREIGN drone signal
function updateQueenPheromone(prev, drones) {
  const sovereign = drones.find(d => d.cls === 'SOVEREIGN' && !d.sacrificed);
  const boost = sovereign ? sovereign.signal * 0.05 : 0;
  return clamp(prev * Math.exp(-0.05) + boost, 0.5, 2.0);
}

// Quorum sensing: count scouts waggling the same "site" (phase bucket)
function quorumSensing(waggle, threshold = 3) {
  const buckets = {};
  waggle.filter(w => w.active).forEach(w => {
    const bucket = Math.floor(w.angle / (Math.PI / 4)); // 8 buckets
    buckets[bucket] = (buckets[bucket] || 0) + 1;
  });
  const best = Object.entries(buckets).sort((a, b) => b[1] - a[1])[0];
  return best
    ? { decided: best[1] >= threshold, direction: Number(best[0]) * (Math.PI / 4), votes: best[1] }
    : { decided: false, direction: 0, votes: 0 };
}

// Nectar grid: 20×20 cells, replenish slowly, depleted by forage behavior
function nectarStep(grid) {
  return grid.map(v => Math.min(1.0, v + 0.005));
}

function harvestNectar(grid, drones) {
  const newGrid = [...grid];
  drones.filter(d => !d.sacrificed && getBehavior(d) === 'FORAGE').forEach(d => {
    const c = worldToCell(d.posX, d.posZ);
    newGrid[c] = Math.max(0, newGrid[c] - 0.05);
  });
  return newGrid;
}

// Comb role assignment based on class + waggle quality
function assignCombRoles(drones, waggle) {
  return drones.map(d => {
    const w = waggle.find(x => x.id === d.id) || { quality: 0 };
    switch (d.cls) {
      case 'SOVEREIGN': return 'QUEEN_GUARD';
      case 'SCOUT':     return w.quality > 0.3 ? 'FORAGER' : 'SCOUT';
      case 'MEDIC':     return 'NURSE';
      case 'GUARDIAN':  return 'DEFENDER';
      case 'RELAY':     return 'BUILDER';
      case 'STRIKER':   return d.signal > 1.3 ? 'FORAGER' : 'DEFENDER';
      default:          return 'WORKER';
    }
  });
}

// ─── ANT MIND ─────────────────────────────────────────────────────────────────

// Pheromone evaporation
function pheromoneEvaporate(grid, rate = 0.05) {
  return grid.map(v => Math.max(0, v * (1 - rate)));
}

// Deposit pheromone at drone positions (foragers + scouts deposit food trail)
function pheromoneDeposit(grid, drones) {
  const newGrid = [...grid];
  drones.filter(d => !d.sacrificed && (getBehavior(d) === 'FORAGE' || getBehavior(d) === 'SCOUT')).forEach(d => {
    const c = worldToCell(d.posX, d.posZ);
    newGrid[c] = Math.min(5.0, newGrid[c] + 0.1 / Math.max(0.1, d.signal));
  });
  return newGrid;
}

// Danger pheromone: deposited by retreating/high-cortisol drones
function dangerDeposit(grid, drones) {
  const newGrid = [...grid];
  drones.filter(d => !d.sacrificed && d.cortisol > 1.5).forEach(d => {
    const c = worldToCell(d.posX, d.posZ);
    newGrid[c] = Math.min(5.0, newGrid[c] + (d.cortisol - 1.5) * 0.2);
  });
  return newGrid;
}

// Threshold-model ant role assignment
function antThresholdRole(drone, foodPher, dangerPher) {
  const c      = worldToCell(drone.posX, drone.posZ);
  const food   = foodPher[c]   || 0;
  const danger = dangerPher[c] || 0;
  const tasks  = [
    { role: 'FORAGER',  stim: food },
    { role: 'DEFENDER', stim: danger },
    { role: 'RELAY',    stim: 0.5 },
    { role: 'NURSE',    stim: drone.cortisol > 1.2 ? 0.8 : 0.2 },
    { role: 'SCOUT',    stim: 1.0 / (drone.signal + 0.5) },
  ];
  const theta = 1.0;
  const probs = tasks.map(t => (t.stim ** 2) / (t.stim ** 2 + theta ** 2 + 1e-6));
  const best  = tasks[probs.indexOf(Math.max(...probs))];
  return best.role;
}

// ─── ORGAN SYSTEMS ────────────────────────────────────────────────────────────

function organNervous(drones) {
  const active = drones.filter(d => !d.sacrificed);
  if (!active.length) return { state: 'IDLE', output: 1.0 };
  const mean = active.reduce((s, d) => s + d.signal, 0) / active.length;
  const variance = active.reduce((s, d) => s + (d.signal - mean) ** 2, 0) / active.length;
  const coherence = 1 / (1 + variance);
  return { state: coherence > 0.7 ? 'ROUTING_OPTIMAL' : 'ROUTING_DEGRADED', output: coherence };
}

function organImmune(drones) {
  const active = drones.filter(d => !d.sacrificed);
  const anomalies = active.filter(d => d.cortisol > 2.0).length;
  const fraction  = active.length ? anomalies / active.length : 0;
  return {
    state:    anomalies === 0 ? 'HEALTHY' : fraction < 0.2 ? 'MONITORING' : 'ALERT',
    output:   fraction,
    anomalies,
  };
}

function organMetabolic(drones) {
  const active = drones.filter(d => !d.sacrificed);
  if (!active.length) return { state: 'IDLE', output: 1.0 };
  const mean = active.reduce((s, d) => s + d.energy, 0) / active.length;
  const minE = active.reduce((m, d) => Math.min(m, d.energy), Infinity);
  return {
    state: minE < 0.5 ? 'CRITICAL_ENERGY' : mean < 1.0 ? 'LOW_ENERGY' : 'ENERGY_OK',
    output: mean,
    minEnergy: minE,
  };
}

function organSensory(waggle, nectarGrid) {
  const wqs   = waggle.map(w => w.quality);
  const meanQ = wqs.length ? wqs.reduce((s, q) => s + q, 0) / wqs.length : 0;
  const topN  = nectarGrid.length ? Math.max(...nectarGrid) : 0;
  const awareness = meanQ * 0.5 + topN * 0.5;
  return { state: awareness > 0.6 ? 'HIGH_AWARENESS' : 'LOW_AWARENESS', output: awareness };
}

function organReproductive(metabolic, rSwarm_, droneCount) {
  const shouldSpawn = metabolic.output > 1.5 && rSwarm_ > 0.8 && droneCount < 50;
  return { state: shouldSpawn ? 'SPAWN_RECOMMENDED' : 'HOLDING', output: shouldSpawn ? 1 : 0 };
}

// ─── FACTION RESISTANCE (Law 24) ─────────────────────────────────────────────
// If one drone dominates signal output (> 70% of total), all other drones
// receive an autonomy-pressure surge: NOR × 1.3 and signal × 1.1.
// Mirrors swarm_brain factionResistance() exactly.
function factionResistance(drones) {
  const active = drones.filter(d => !d.sacrificed);
  if (!active.length) return drones;
  const totalSig = active.reduce((s, d) => s + d.signal, 0);
  if (totalSig === 0) return drones;
  const dominant = active.reduce((best, d) => d.signal > best.signal ? d : best, active[0]);
  const dominance = dominant.signal / totalSig;
  if (dominance <= FACTION_DOMINANCE_THRESHOLD) return drones;
  return drones.map(d => {
    if (d.sacrificed || d.id === dominant.id) return d;
    return {
      ...d,
      norepinephrine: sf(d.norepinephrine * FACTION_NOR_MULTIPLIER),
      signal: sf(d.signal * FACTION_SIGNAL_MULTIPLIER),
    };
  });
}

// Derives the Four 360-degree channel values from the 6-node brain activations.
//   ALPHA (0): SENSOR node           — spatial / environmental awareness
//   BETA  (1): MEMORY node           — temporal / past-state recall
//   GAMMA (2): EXECUTIVE node        — relational / goal-directed reasoning
//   DELTA (3): mean(EMOTIONAL+MOTOR) — embodied action drive
//
// Convergence = 1 − 4·variance(ALPHA, BETA, GAMMA, DELTA)
//   When all four streams point the same way, convergence → 1 (single critical point).
//   When channels are maximally spread, convergence → 0.
//
// Q-Coherence = 0.5·convergence + 0.5·rSwarm
//   Blends internal 4-channel alignment with swarm-wide Kuramoto coherence.
//
// Now-attention exponentially tracks rSwarm·(1 − jDrift):
//   A stable, coherent swarm anchors each drone to the present moment.
function quantumStateUpdate(drone, rSwarm, jDrift) {
  // brainActivation indices: [0=SENSOR, 1=MEMORY, 2=EXECUTIVE, 3=EMOTIONAL, 4=MOTOR, 5=OUTPUT]
  // OUTPUT (index 5) is the convergence point — it is intentionally excluded as an
  // input channel here because it already carries the integrated signal, not a
  // raw perspective.
  const [alpha, beta, gamma, emo, motor] = drone.brainActivation;
  const delta = (emo + motor) / 2.0;

  // Smooth channel update toward brain-derived targets
  const newAlpha = drone.qAlpha + (alpha - drone.qAlpha) / CHAN_TAU;
  const newBeta  = drone.qBeta  + (beta  - drone.qBeta)  / CHAN_TAU;
  const newGamma = drone.qGamma + (gamma - drone.qGamma) / CHAN_TAU;
  const newDelta = drone.qDelta + (delta - drone.qDelta) / CHAN_TAU;

  // Convergence: 1 − 4·variance
  const mean = (newAlpha + newBeta + newGamma + newDelta) / 4.0;
  const variance = (
    (newAlpha - mean) ** 2 + (newBeta - mean) ** 2 +
    (newGamma - mean) ** 2 + (newDelta - mean) ** 2
  ) / 4.0;
  const newConvergence = clamp(1.0 - variance * 4.0, 0.0, 1.0);

  // Q-Coherence: internal convergence + swarm coherence
  const newQCoherence = 0.5 * newConvergence + 0.5 * rSwarm;

  // Now-attention: pull toward present-moment target
  const nowTarget = clamp(rSwarm * (1.0 - Math.min(1.0, jDrift)), 0.0, 1.0);
  const newNow = drone.nowAttention + NOW_RATE * (nowTarget - drone.nowAttention);

  return {
    qAlpha: newAlpha,
    qBeta:  newBeta,
    qGamma: newGamma,
    qDelta: newDelta,
    qConvergence: newConvergence,
    qCoherence:   newQCoherence,
    nowAttention: newNow,
  };
}
// ─── MAIN HOOK ────────────────────────────────────────────────────────────────
export function useSwarmState() {
  const [beat, setBeat]       = useState(0);
  const [rSwarm, setRSwarm]   = useState(0.88);
  const [jDrift, setJDrift]   = useState(0.0);
  const [drones, setDrones]   = useState(() =>
    Array.from({ length: MAX_DRONES }, (_, i) => makeDrone(i))
  );
  const [pendingActions, setPendingActions] = useState([]);
  const [auditLog, setAuditLog]             = useState([]);
  const [missionStatus, setMissionStatus]   = useState('IDLE');
  const [missionName, setMissionName]       = useState('');
  const [emergencyActive, setEmergencyActive] = useState(false);
  const [architectSignal, setArchitectSignal] = useState(1.0);
  const [commsLost, setCommsLost]           = useState(false);
  // Swarm-level quantum metrics (mean across drones)
  const [swarmQCoherence, setSwarmQCoherence]   = useState(0.5);
  const [swarmConvergence, setSwarmConvergence] = useState(0.0);

  // ─── ORGANISM STATE ─────────────────────────────────────────────────────────
  const [organism, setOrganism] = useState({
    mode:         'HYBRID',
    // Swarm math
    entropy:      0,
    isingM:       0,
    // Bee hive
    queenPheromone: 1.5,
    quorum:         { decided: false, direction: 0, votes: 0 },
    combRoles:      [],
    nectarGrid:     Array(GRID_CELLS).fill(0.5),
    waggle:         [],
    // Ant mind
    foodPher:       Array(GRID_CELLS).fill(0.1),
    dangerPher:     Array(GRID_CELLS).fill(0.0),
    antRoles:       [],
    // Teams
    captains:       { SCOUT: null, STRIKER: null, GUARDIAN: null, RELAY: null, MEDIC: null },
    morale:         { SCOUT: 1, STRIKER: 1, GUARDIAN: 1, RELAY: 1, MEDIC: 1 },
    // Organs
    organs: {
      NERVOUS:      { state: 'IDLE', output: 1 },
      IMMUNE:       { state: 'HEALTHY', output: 0, anomalies: 0 },
      METABOLIC:    { state: 'ENERGY_OK', output: 1, minEnergy: 1 },
      SENSORY:      { state: 'LOW_AWARENESS', output: 0 },
      REPRODUCTIVE: { state: 'HOLDING', output: 0 },
    },
  });

  // Inter-drone Hebbian weights (swarm-level, separate from intra-brain STDP)
  const swarmWeights = useRef(
    Array.from({ length: MAX_DRONES }, () => Array(MAX_DRONES).fill(0.1))
  );
  const jRisingRef       = useRef(0);
  const prevJRef         = useRef(0.0);
  const beatRef          = useRef(0);
  const nextReqId        = useRef(0);
  const pendingRef       = useRef([]);
  const latestDronesRef  = useRef([]); // always holds the most recent drones snapshot
  // Law 23: Observer Independence — comms-lost if no operator heartbeat for 60 s
  const COMMS_TIMEOUT_MS = 60_000;
  const lastHeartbeatRef = useRef(Date.now());

  const addLog = useCallback((kind, droneId, desc, r, j) => {
    setAuditLog(prev => {
      const entry = {
        seq: prev.length, kind, droneId,
        description: desc, rSwarm: r, jDrift: j,
        beat: beatRef.current, timestamp: Date.now(),
      };
      return [...prev.slice(-99), entry];
    });
  }, []);

  const queueAction = useCallback((droneId, action, reason, cortisol, jDrift_, rSwarm_) => {
    const windows = { SACRIFICE: 30, ENGAGE: 60, DISSOLVE: 15, ENTER_ZONE: 20, FORMATION_CHANGE: 10 };
    const req = {
      id: nextReqId.current++, droneId, action, reason, cortisol,
      jDrift: jDrift_, rSwarm: rSwarm_, beat: beatRef.current,
      deadline: Date.now() + (windows[action] || 30) * 1000,
      status: 'PENDING',
    };
    pendingRef.current = [...pendingRef.current, req];
    setPendingActions(prev => [...prev, req]);
    addLog('HITL_QUEUED', droneId, `${action}: ${reason}`, rSwarm_, jDrift_);
  }, [addLog]);

  const approve = useCallback((reqId) => {
    setPendingActions(prev => {
      const updated = prev.map(r => r.id === reqId ? { ...r, status: 'APPROVED' } : r);
      pendingRef.current = updated;
      return updated;
    });
    const req = pendingRef.current.find(r => r.id === reqId);
    if (req) {
      addLog('HITL_APPROVED', req.droneId, `APPROVED: ${req.action}`, req.rSwarm, req.jDrift);
      if (req.action === 'SACRIFICE') {
        setDrones(prev => prev.map(d =>
          d.id !== req.droneId ? d : { ...d, sacrificed: true, activation: 1.0 }
        ));
        addLog('DRONE_SACRIFICED', req.droneId, `Drone ${req.droneId} sacrificed`, req.rSwarm, req.jDrift);
      }
    }
  }, [addLog]);

  const deny = useCallback((reqId) => {
    setPendingActions(prev => {
      const updated = prev.map(r => r.id === reqId ? { ...r, status: 'DENIED' } : r);
      pendingRef.current = updated;
      return updated;
    });
    const req = pendingRef.current.find(r => r.id === reqId);
    if (req) addLog('HITL_DENIED', req.droneId, `DENIED: ${req.action}`, req.rSwarm, req.jDrift);
  }, [addLog]);

  const emergencyStop = useCallback(() => {
    setEmergencyActive(true);
    setMissionStatus('EMERGENCY_STOP');
    addLog('EMERGENCY_STOP', null, 'Emergency stop activated', 0, 0);
  }, [addLog]);

  const startMission = useCallback((name) => {
    if (emergencyActive) return;
    setMissionStatus('ACTIVE');
    setMissionName(name);
    addLog('MISSION_START', null, `Mission started: ${name}`, 0, 0);
  }, [emergencyActive, addLog]);

  // Law 23: Observer Independence — operator pings to keep comms alive.
  // Mission continues even if comms is lost (drones act autonomously),
  // but the operator is warned that they can no longer issue commands.
  const heartbeat = useCallback(() => {
    lastHeartbeatRef.current = Date.now();
    setCommsLost(false);
  }, []);

  // ─── SIMULATION TICK ────────────────────────────────────────────────────────
  useEffect(() => {
    const interval = setInterval(() => {
      if (emergencyActive) return;

      beatRef.current += 1;
      const b = beatRef.current;
      setBeat(b);

      // Law 23: Observer Independence — detect comms loss if no operator heartbeat
      if (Date.now() - lastHeartbeatRef.current > COMMS_TIMEOUT_MS) {
        setCommsLost(true);
      }

      setDrones(prev => {
        // ── Step 1: Kuramoto phase update ────────────────────────────────────
        let next = prev.map(d => {
          if (d.sacrificed) return d;
          const active = prev.filter(o => !o.sacrificed && o.id !== d.id);
          const kuramotoSum = active.reduce((s, o) => s + Math.sin(o.phase - d.phase), 0);
          const dTheta = d.omega + (KURAMOTO_K / prev.length) * kuramotoSum;
          return { ...d, phase: d.phase + dTheta * 0.1, lastBeat: b }; // dt = 0.1 matches swarm_brain
        });

        // ── Step 2: Inter-drone Hebbian learning (swarm weights) ─────────────
        for (let i = 0; i < next.length; i++) {
          for (let j = i + 1; j < next.length; j++) {
            if (next[i].sacrificed || next[j].sacrificed) continue;
            const dx = next[i].posX - next[j].posX;
            const dz = next[i].posZ - next[j].posZ;
            const dist = Math.sqrt(dx * dx + dz * dz) + 0.001;
            const proximity = 1.0 / (1.0 + dist / 10.0);
            const w = swarmWeights.current[i][j];
            const delta = HELIX_ALPHA * next[i].signal * next[j].signal * (1.0 - w / W_CEIL) * proximity;
            swarmWeights.current[i][j] = Math.min(W_CEIL, w + delta);
            swarmWeights.current[j][i] = swarmWeights.current[i][j];
          }
        }

        // ── Step 3: Compute collective metrics (needed for ODEs) ─────────────
        const r  = computeRSwarm(next);
        const jd = computeJDrift(next);
        setRSwarm(r);
        setJDrift(jd);

        // ── Step 4: Neurochemical ODEs + Brain pass + STDP + Energy + Boids ──
        next = next.map(d => {
          if (d.sacrificed) return d;

          // Mean Hebbian weight to active neighbors (drives oxytocin)
          const activeNeighbors = next.filter(o => !o.sacrificed && o.id !== d.id);
          const meanHebb = activeNeighbors.length > 0
            ? activeNeighbors.reduce((s, o) => s + swarmWeights.current[d.id][o.id], 0)
              / activeNeighbors.length
            : 0.1;

          // 4-species neurochemical ODE step
          const chem = neurochemStep(d, r, jd, meanHebb);

          // 6-node brain forward pass with updated neurochemicals
          const brainActivation = brainForwardPass({ ...d, ...chem }, architectSignal);

          // STDP: update intra-brain weights
          const brainWeights = stdpUpdate(d.brainWeights, brainActivation);

          // Signal = OUTPUT node activation × energy (Law 23 + brain output)
          const outputAct = brainActivation[5]; // OUTPUT node
          const newSignal = sf(outputAct * d.energy * architectSignal);

          // Energy model
          const energy = energyStep({ ...d, signal: newSignal, brainActivation });

          // Reynolds boids position + velocity
          const { velX, velZ, posX, posZ } = boidsUpdate(
            { ...d, velX: d.velX, velZ: d.velZ, norepinephrine: chem.norepinephrine },
            next, r
          );

          return {
            ...d,
            ...chem,
            brainActivation,
            brainWeights,
            signal: newSignal,
            energy,
            velX,
            velZ,
            posX,
            posZ,
            activation: sf(outputAct * energy),
            // Quantum cognitive state (4-360 model)
            ...quantumStateUpdate({ ...d, brainActivation }, r, jd),
          };
        });

        // ── Step 5: Jasmine correction ────────────────────────────────────────
        if (jd > prevJRef.current) {
          jRisingRef.current++;
        } else {
          jRisingRef.current = 0;
        }
        prevJRef.current = jd;

        if (jRisingRef.current >= 3) {
          jRisingRef.current = 0;
          const active = next.filter(x => !x.sacrificed);
          const meanPhase = active.reduce((s, x) => s + x.phase, 0) / (active.length || 1);
          next = next.map(d => {
            if (d.sacrificed) return d;
            return {
              ...d,
              phase:    d.phase * 0.9 + meanPhase * 0.1,
              oxytocin: sf(d.oxytocin + 0.05),
              cortisol: sf(d.cortisol - 0.03),
            };
          });
          addLog('JASMINE_CORRECT', null, `Jasmine fired r=${r.toFixed(3)} J=${jd.toFixed(3)}`, r, jd);
        }

        // ── Step 5b: Faction Resistance (Law 24) ─────────────────────────────
        // If one drone dominates signal (> 70%), other drones receive an
        // autonomy-pressure surge — mirrors swarm_brain.factionResistance().
        next = factionResistance(next);

        // ── Step 6: Sacrifice doctrine + OMNIS log ────────────────────────────
        next.forEach(d => {
          if (!d.sacrificed && d.cortisol > 1.5) {
            const alreadyQueued = pendingRef.current.some(
              p => p.droneId === d.id && p.action === 'SACRIFICE' && p.status === 'PENDING'
            );
            if (!alreadyQueued) {
              queueAction(d.id, 'SACRIFICE',
                `D${d.id} cortisol=${d.cortisol.toFixed(2)} exceeds threshold`,
                d.cortisol, jd, r
              );
            }
          }
        });

        if (r >= 0.98 && b % 10 === 0) {
          addLog('OMNIS_STATE', null, `OMNIS r=${r.toFixed(4)} energy=${
            (next.filter(x=>!x.sacrificed).reduce((s,x)=>s+x.energy,0)/next.filter(x=>!x.sacrificed).length).toFixed(2)
          }`, r, jd);
        }

        latestDronesRef.current = next; // keep ref in sync for organism tick

        // ── Step 7: Swarm-level quantum metrics ────────────────────────────────
        const active = next.filter(x => !x.sacrificed);
        if (active.length > 0) {
          const meanQCoh  = active.reduce((s, x) => s + x.qCoherence,   0) / active.length;
          const meanQConv = active.reduce((s, x) => s + x.qConvergence, 0) / active.length;
          setSwarmQCoherence(meanQCoh);
          setSwarmConvergence(meanQConv);
        }
        return next;
      });

      // ─── ORGANISM TICK ──────────────────────────────────────────────────────
      // Reads from latestDronesRef to avoid nested state updater pattern.
      setOrganism(prev => {
        const latestDrones = latestDronesRef.current;
        if (!latestDrones.length) return prev;
          // ── Bee Hive ──
          const waggle       = computeWaggle(latestDrones);
          const queenPhero   = updateQueenPheromone(prev.queenPheromone, latestDrones);
          const quorum       = quorumSensing(waggle);
          const newNectar    = harvestNectar(nectarStep(prev.nectarGrid), latestDrones);
          const combRoles    = assignCombRoles(latestDrones, waggle);

          // ── Ant Mind ──
          const evapFood     = pheromoneEvaporate(prev.foodPher);
          const evapDanger   = pheromoneEvaporate(prev.dangerPher);
          const newFoodPher  = pheromoneDeposit(evapFood, latestDrones);
          const newDangerPher= dangerDeposit(evapDanger, latestDrones);
          const antRoles     = latestDrones.map(d =>
            d.sacrificed ? 'IDLE' : antThresholdRole(d, newFoodPher, newDangerPher)
          );

          // ── Team AI ──
          const captains = electCaptains(latestDrones);
          const morale   = teamMorale(latestDrones);

          // ── Organ Systems ──
          const nervous      = organNervous(latestDrones);
          const immune       = organImmune(latestDrones);
          const metabolic    = organMetabolic(latestDrones);
          const r2           = computeRSwarm(latestDrones);
          const sensory      = organSensory(waggle, newNectar);
          const reproductive = organReproductive(metabolic, r2, latestDrones.length);

          // ── Swarm math ──
          const entropy = swarmEntropy(latestDrones);
          const isingM  = isingConsensus(latestDrones);

          return {
            mode:           prev.mode,
            entropy,
            isingM,
            queenPheromone: queenPhero,
            quorum,
            combRoles,
            nectarGrid:     newNectar,
            waggle,
            foodPher:       newFoodPher,
            dangerPher:     newDangerPher,
            antRoles,
            captains,
            morale,
            organs: {
              NERVOUS:      nervous,
              IMMUNE:       immune,
              METABOLIC:    metabolic,
              SENSORY:      sensory,
              REPRODUCTIVE: reproductive,
            },
          };
      });

      // Expire pending actions
      setPendingActions(prev => {
        const updated = prev.map(r =>
          r.status === 'PENDING' && Date.now() > r.deadline
            ? { ...r, status: 'EXPIRED' } : r
        );
        pendingRef.current = updated;
        return updated;
      });
    }, 500);

    return () => clearInterval(interval);
  }, [emergencyActive, architectSignal, queueAction, addLog]);

  return {
    beat,
    rSwarm,
    jDrift,
    drones,
    organism,
    pendingActions: pendingActions.filter(r => r.status === 'PENDING'),
    allActions: pendingActions,
    auditLog,
    missionStatus,
    missionName,
    emergencyActive,
    architectSignal,
    commsLost,
    swarmWeights: swarmWeights.current,
    // Swarm-level quantum metrics
    swarmQCoherence,
    swarmConvergence,
    approve,
    deny,
    emergencyStop,
    startMission,
    setArchitectSignal,
    setMissionStatus,
    heartbeat,
  };
}
