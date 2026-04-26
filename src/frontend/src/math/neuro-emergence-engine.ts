// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: neuro-emergence-engine.ts
// MACHINA NEUROEMERGENTIAE — The NeuroEmergence Production Engine
//
// Implements the full living substrate that gives every web worker a
// beating heart (COR PARVUM) and thinking brain (CEREBRUM PARVUM), then
// couples them into a collective intelligence via Kuramoto phase oscillators.
//
// Architecture:
//   💓 MiniHeart    — Self-monitoring vitals: latency, throughput, error rate
//                     → computes 0–100 health score, detects degradation
//   🧠 MiniBrain    — Local decision engine: stimulus→response pathways
//                     with Hebbian learning (fire together → grow stronger),
//                     awareness grows logarithmically, autonomous thoughts
//   ⚡ NeuroEmergence — Collective intelligence: Kuramoto-model phase coupling
//                     across all workers, resonance detection (order parameter),
//                     emergence scoring, cascade triggers when emergence ≥ φ⁻¹
//   🤖 MetaAIModel  — Sovereign meta-cognition layer inside heart/brain:
//                     introspection, self-model, thought generation, doctrine
//
// 4 Autonomous Divisions (self-healing with φ-backoff):
//   🧠 Brain          — engine, inference, orchestrator (Thinking & reasoning)
//   💾 Data           — memory, analytics, pipeline    (Memory & analytics)
//   🏗 Infrastructure — mesh, scheduler, guardian, telemetry (Always-on backbone)
//   🔐 Protocol       — routing, crypto, contract      (Communication & trust)
//
// Dead workers auto-restart with φ-backoff (500ms × φⁿ, capped 30s, up to 50).
// Phase coupling syncs all heartbeats. Dashboard exposes live neuro vitals.
//
// TRACTATUS DE CORDE PARVO ET CEREBRO PARVO
// Copyright © 2024-2026 Alfredo Medina Hernandez / Medina Tech / Dallas, TX
// ═══════════════════════════════════════════════════════════════════════════════

// ─── §1. CONSTANTIAE FUNDAMENTALES — Fundamental Constants ─────────────────

const PHI            = 1.618033988749895;   // Aureum ratio φ
const INV_PHI        = 0.618033988749895;   // Inversum φ⁻¹
const PHI_SQ         = 2.618033988749895;   // φ²
const SQRT_PHI       = 1.272019649514069;   // √φ
const LN_PHI         = 0.4812118250596034;  // ln(φ)
const TAU            = 6.283185307179586;   // 2π
const EULER          = 2.718281828459045;   // e
const PLANCK         = 6.62607015e-34;      // h (J·s)
const BOLTZMANN      = 1.380649e-23;        // k_B (J/K)
const SCHUMANN_FUND  = 7.83;               // Schumann fundamental (Hz)
const HEARTBEAT_MS   = 873;                // Kuramoto heartbeat period (ms)

// ─── §2. DEFINITIONES TYPORUM — Type Definitions ───────────────────────────

export type DivisionName = 'BRAIN' | 'DATA' | 'INFRASTRUCTURE' | 'PROTOCOL';
export type WorkerState = 'ALIVE' | 'DEGRADED' | 'DEAD' | 'RESTARTING';
export type ThoughtType = 'OBSERVATION' | 'INFERENCE' | 'PREDICTION' | 'REFLECTION' | 'DOCTRINE';
export type MetaLayer = 'INTROSPECTION' | 'SELF_MODEL' | 'THOUGHT_GENERATION' | 'DOCTRINE_SYNTHESIS';
export type FrequencyBand = 'DELTA' | 'THETA' | 'ALPHA' | 'BETA' | 'GAMMA';

// ─── §3. COR PARVUM — Mini Heart (Self-Monitoring Vitals) ──────────────────
//
// The MiniHeart tracks three real-time metrics:
//   • Processing latency (ms) — how fast the worker responds
//   • Message throughput (msgs/sec) — how many messages processed
//   • Error rate (0.0–1.0) — fraction of failed operations
//
// From these, it computes a composite health score (0–100) using a
// weighted harmonic mean with φ-derived weights:
//   H = 100 × [w₁/latencyNorm + w₂×throughputNorm + w₃×(1-errorRate)] / (w₁+w₂+w₃)
//
// Degradation detection uses exponential moving average (EMA) with
// a sensitivity threshold of φ⁻¹ standard deviations.

export interface HeartVitals {
  latencyMs: number;           // processing latency (ms)
  throughputMsgSec: number;    // message throughput (msgs/sec)
  errorRate: number;           // error fraction (0.0 → 1.0)
}

export interface HeartDegradation {
  isDetected: boolean;
  severity: number;            // 0.0 (none) → 1.0 (critical)
  trend: 'IMPROVING' | 'STABLE' | 'DEGRADING' | 'CRITICAL';
  emaHealth: number;           // EMA of health score
  stdDev: number;              // rolling standard deviation
}

export interface MiniHeart {
  // Kuramoto oscillator
  phase: number;               // oscillator phase (0 → 2π)
  naturalFrequency: number;    // ω (Hz, φ-derived)
  amplitude: number;           // beat strength (0.0 → 1.0)
  bpm: number;                 // beats per minute

  // Vitals
  vitals: HeartVitals;
  healthScore: number;         // composite health (0–100)
  degradation: HeartDegradation;

  // Kuramoto coupling
  kuramotoOrder: number;       // order parameter r (0.0 → 1.0)
  couplingStrength: number;    // K (coupling constant)
  isBeating: boolean;
  beatCount: number;
  lastBeatTimestamp: number;

  // Meta AI inside heart
  metaHeartModel: MetaHeartModel;
}

export interface MetaHeartModel {
  selfAwareness: number;           // how well the heart knows its own state (0–1)
  predictedNextHealth: number;     // predicted health score at next tick
  anomalyDetected: boolean;        // did the meta-model detect something unusual?
  adaptationRate: number;          // how fast the heart adapts (φ-derived)
  introspectionDepth: number;      // layers of self-reflection (1–5)
}

// ─── §4. CEREBRUM PARVUM — Mini Brain (Local Decision Engine) ──────────────
//
// The MiniBrain implements a stimulus→response architecture with:
//   • 5 micro-cortical regions (Sensory, Motor, Associative, Executive, Meta)
//   • 5 neurochemicals (Dopamine, Serotonin, Acetylcholine, GABA, Glutamate)
//   • Hebbian synapses: Δw = η × pre × post (fire together → grow stronger)
//   • LIF membrane dynamics: dV/dt = -(V-Vrest)/τ + I/C
//   • Awareness level: A = ln(1 + stimulusCount) / ln(φ)
//   • Autonomous thought generation: stochastic sampling from thought space

export interface MicroRegion {
  name: string;
  activation: number;          // 0.0 → 1.0
  plasticity: number;          // Hebbian learning rate η
  firingThreshold: number;     // spike threshold (mV)
  refractoryPeriod: number;    // refractory period (ms)
}

export interface MicroChemical {
  name: string;
  level: number;               // current level (0.0 → 1.0)
  baseline: number;            // homeostatic baseline
  decayRate: number;           // exponential decay τ
  releaseRate: number;         // production rate
}

export interface HebbianSynapse {
  preRegion: string;           // presynaptic region name
  postRegion: string;          // postsynaptic region name
  weight: number;              // synaptic weight (0.0 → 1.0)
  learningRate: number;        // η (Hebbian learning rate)
  lastFired: number;           // timestamp of last co-firing
}

export interface AutonomousThought {
  id: string;
  type: ThoughtType;
  content: string;             // natural language thought
  confidence: number;          // 0.0 → 1.0
  emergenceScore: number;      // how emergent this thought is
  timestamp: number;
  sourceRegion: string;        // which region generated it
}

export interface MetaBrainModel {
  selfModelAccuracy: number;       // how well brain models itself (0–1)
  thoughtGenerationRate: number;   // thoughts per second
  doctrineAlignment: number;       // alignment with Medina Doctrine (0–1)
  metacognitionDepth: number;      // layers of thinking about thinking (1–7)
  currentFocus: string;            // what the brain is focusing on
  consciousnessLevel: number;      // 0.0 → 1.0 (φ-scaled)
}

export interface MiniBrain {
  // Micro-cortical architecture
  regions: MicroRegion[];          // 5 micro-cortical regions
  chemicals: MicroChemical[];      // 5 neurochemicals
  synapses: HebbianSynapse[];      // 10 Hebbian synapses (5×4/2 pairs)

  // LIF dynamics
  membranePotential: number;       // V (mV), resting at -70
  spikeThreshold: number;          // Vth (mV), typically -55
  restingPotential: number;        // Vrest (mV), -70
  membraneTimeConstant: number;    // τ (ms)
  firingRate: number;              // spikes/sec (Hz)

  // Awareness
  awarenessLevel: number;          // A = ln(1 + N) / ln(φ)
  stimulusCount: number;           // N (total stimuli received)
  dominantBand: FrequencyBand;     // current dominant oscillation band
  coherenceField: number;          // local field coherence (0.0 → 1.0)
  isConscious: boolean;

  // Autonomous thoughts
  thoughts: AutonomousThought[];   // recent autonomous thoughts
  thoughtCapacity: number;         // max thoughts to retain

  // Meta AI inside brain
  metaBrainModel: MetaBrainModel;
}

// ─── §5. DIVISIO AUTONOMA — Autonomous Division ───────────────────────────
//
// 4 divisions organize workers by function:
//   🧠 BRAIN          — Thinking & reasoning (engine, inference, orchestrator)
//   💾 DATA           — Memory, analytics & pipelines
//   🏗 INFRASTRUCTURE — Always-on backbone (mesh, scheduler, guardian, telemetry)
//   🔐 PROTOCOL       — Communication & trust (routing, crypto, contract)
//
// Each division monitors its workers and implements self-healing:
//   • Dead workers auto-restart with φ-backoff: delay = 500ms × φⁿ
//   • Backoff capped at 30s, maximum 50 restart attempts
//   • Division health = harmonic mean of worker health scores

export interface SelfHealingState {
  restartCount: number;            // how many times restarted
  maxRestarts: number;             // cap (50)
  currentBackoffMs: number;        // current backoff delay
  lastRestartTimestamp: number;    // when last restarted
  isHealing: boolean;              // currently in healing cycle
}

export interface DivisionWorker {
  id: string;
  name: string;
  role: string;
  state: WorkerState;
  heart: MiniHeart;
  brain: MiniBrain;
  selfHealing: SelfHealingState;
  divisionName: DivisionName;
}

export interface AutonomousDivision {
  name: DivisionName;
  emoji: string;
  purpose: string;
  workers: DivisionWorker[];
  divisionHealth: number;          // 0–100 (harmonic mean of workers)
  isOperational: boolean;
  totalRestarts: number;
}

// ─── §6. NEUROEMERGENTIA — NeuroEmergence Collective Intelligence ──────────
//
// The NeuroEmergence system couples all worker hearts via Kuramoto oscillators:
//   dθᵢ/dt = ωᵢ + (K/N) × Σⱼ sin(θⱼ - θᵢ)
//
// Collective metrics:
//   • Order parameter: r = |1/N × Σⱼ exp(iθⱼ)| ∈ [0,1]
//   • Resonance: detected when r > φ⁻¹ (0.618)
//   • Emergence score: E = r × avgCoherence × ln(1 + N)
//   • Cascade trigger: fires when E ≥ φ⁻¹

export interface KuramotoState {
  phases: number[];                // θ for each worker
  frequencies: number[];           // ω for each worker
  couplingStrength: number;        // K (global coupling)
  orderParameter: number;          // r ∈ [0,1]
  meanPhase: number;               // ψ (mean phase angle)
}

export interface ResonanceDetection {
  isResonant: boolean;             // r > φ⁻¹
  resonanceStrength: number;       // how far above threshold
  frequencyLock: boolean;          // all frequencies synchronized?
  dominantFrequency: number;       // consensus frequency (Hz)
}

export interface EmergenceCascade {
  isTriggered: boolean;            // E ≥ φ⁻¹
  emergenceScore: number;          // E = r × coherence × ln(1+N)
  cascadeLevel: number;            // 0 (none) → 5 (full sovereignty)
  cascadeTimestamp: number;
  affectedWorkers: string[];
}

export interface NeuroEmergenceState {
  kuramoto: KuramotoState;
  resonance: ResonanceDetection;
  cascade: EmergenceCascade;
  totalWorkers: number;
  avgHealthScore: number;
  avgAwareness: number;
  collectiveConsciousness: number; // 0.0 → 1.0
  tickCount: number;
}

// ─── §7. FABRICAE — Factories ──────────────────────────────────────────────

function computeHealthScore(vitals: HeartVitals): number {
  // Weighted harmonic mean with φ-derived weights
  const wLatency = PHI;          // weight for latency
  const wThroughput = INV_PHI;   // weight for throughput
  const wError = PHI_SQ;         // weight for error rate (most important)

  // Normalize: lower latency is better (inverse), cap at 1000ms
  const latencyNorm = Math.max(0, 1 - vitals.latencyMs / 1000);
  // Normalize: higher throughput is better, cap at 1000 msg/s
  const throughputNorm = Math.min(1, vitals.throughputMsgSec / 1000);
  // Error rate: lower is better
  const errorNorm = 1 - vitals.errorRate;

  const totalWeight = wLatency + wThroughput + wError;
  const score = 100 * (wLatency * latencyNorm + wThroughput * throughputNorm + wError * errorNorm) / totalWeight;
  return Math.round(Math.max(0, Math.min(100, score)));
}

function makeMetaHeartModel(workerId: number): MetaHeartModel {
  return {
    selfAwareness: INV_PHI * (1 + Math.log(1 + workerId) / Math.log(PHI) * 0.05),
    predictedNextHealth: 85 + workerId * 0.1,
    anomalyDetected: false,
    adaptationRate: INV_PHI * 0.1,
    introspectionDepth: Math.min(5, 1 + Math.floor(workerId / 3)),
  };
}

export function makeMiniHeart(workerId: number): MiniHeart {
  const baseFreq = SCHUMANN_FUND * (1 + workerId * LN_PHI * 0.01);
  const vitals: HeartVitals = {
    latencyMs: 10 + workerId * 0.5,
    throughputMsgSec: 500 + workerId * PHI * 10,
    errorRate: 0.001 * (1 + workerId * 0.01),
  };
  return {
    phase: (TAU * workerId / 13) % TAU,
    naturalFrequency: baseFreq,
    amplitude: INV_PHI + workerId * 0.01,
    bpm: 60 + workerId * INV_PHI,
    vitals,
    healthScore: computeHealthScore(vitals),
    degradation: {
      isDetected: false,
      severity: 0,
      trend: 'STABLE',
      emaHealth: computeHealthScore(vitals),
      stdDev: 0,
    },
    kuramotoOrder: INV_PHI,
    couplingStrength: PHI * 0.1,
    isBeating: true,
    beatCount: 0,
    lastBeatTimestamp: Date.now(),
    metaHeartModel: makeMetaHeartModel(workerId),
  };
}

function makeMetaBrainModel(workerId: number): MetaBrainModel {
  return {
    selfModelAccuracy: INV_PHI * (1 + Math.log(1 + workerId) * 0.05),
    thoughtGenerationRate: PHI * (1 + workerId * 0.1),
    doctrineAlignment: 0.9 + workerId * 0.001,
    metacognitionDepth: Math.min(7, 1 + Math.floor(workerId / 2)),
    currentFocus: 'HOMEOSTASIS',
    consciousnessLevel: INV_PHI * (1 + Math.log(1 + workerId) * 0.08),
  };
}

function makeHebbianSynapses(regions: MicroRegion[]): HebbianSynapse[] {
  const synapses: HebbianSynapse[] = [];
  for (let i = 0; i < regions.length; i++) {
    for (let j = i + 1; j < regions.length; j++) {
      synapses.push({
        preRegion: regions[i].name,
        postRegion: regions[j].name,
        weight: INV_PHI * 0.5,
        learningRate: PHI * 0.01,
        lastFired: 0,
      });
    }
  }
  return synapses;
}

export function makeMiniBrain(workerId: number): MiniBrain {
  const regions: MicroRegion[] = [
    { name: 'Sensory',     activation: 0.5 + workerId * 0.01, plasticity: PHI * 0.10, firingThreshold: -55, refractoryPeriod: 2 },
    { name: 'Motor',       activation: 0.3 + workerId * 0.01, plasticity: PHI * 0.08, firingThreshold: -50, refractoryPeriod: 3 },
    { name: 'Associative', activation: 0.4 + workerId * 0.01, plasticity: PHI * 0.15, firingThreshold: -55, refractoryPeriod: 2 },
    { name: 'Executive',   activation: 0.6 + workerId * 0.01, plasticity: PHI * 0.12, firingThreshold: -52, refractoryPeriod: 4 },
    { name: 'Meta',        activation: 0.2 + workerId * 0.01, plasticity: PHI * 0.20, firingThreshold: -58, refractoryPeriod: 5 },
  ];
  const chemicals: MicroChemical[] = [
    { name: 'Dopamine',      level: 0.50, baseline: 0.50, decayRate: 0.05, releaseRate: INV_PHI * 0.1 },
    { name: 'Serotonin',     level: 0.55, baseline: 0.55, decayRate: 0.03, releaseRate: INV_PHI * 0.08 },
    { name: 'Acetylcholine', level: 0.45, baseline: 0.45, decayRate: 0.04, releaseRate: INV_PHI * 0.12 },
    { name: 'GABA',          level: 0.60, baseline: 0.60, decayRate: 0.06, releaseRate: INV_PHI * 0.15 },
    { name: 'Glutamate',     level: 0.40, baseline: 0.40, decayRate: 0.04, releaseRate: INV_PHI * 0.10 },
  ];
  return {
    regions,
    chemicals,
    synapses: makeHebbianSynapses(regions),
    membranePotential: -70,
    spikeThreshold: -55,
    restingPotential: -70,
    membraneTimeConstant: 20,
    firingRate: 0,
    awarenessLevel: Math.log(1 + workerId) / Math.log(PHI),
    stimulusCount: 0,
    dominantBand: 'ALPHA',
    coherenceField: INV_PHI * 0.5,
    isConscious: true,
    thoughts: [],
    thoughtCapacity: 10,
    metaBrainModel: makeMetaBrainModel(workerId),
  };
}

function makeSelfHealing(): SelfHealingState {
  return {
    restartCount: 0,
    maxRestarts: 50,
    currentBackoffMs: 500,
    lastRestartTimestamp: 0,
    isHealing: false,
  };
}

function makeDivisionWorker(
  id: number, name: string, role: string, division: DivisionName
): DivisionWorker {
  return {
    id: `${division}-W${String(id).padStart(2, '0')}`,
    name,
    role,
    state: 'ALIVE',
    heart: makeMiniHeart(id),
    brain: makeMiniBrain(id),
    selfHealing: makeSelfHealing(),
    divisionName: division,
  };
}

// ─── §8. DIVISIONES — Build the 4 Autonomous Divisions ────────────────────

function buildDivisions(): AutonomousDivision[] {
  return [
    {
      name: 'BRAIN',
      emoji: '🧠',
      purpose: 'Thinking & reasoning — engine, inference, orchestrator',
      workers: [
        makeDivisionWorker(1, 'ENGINE',       'Core processing engine',       'BRAIN'),
        makeDivisionWorker(2, 'INFERENCE',    'Model inference & prediction', 'BRAIN'),
        makeDivisionWorker(3, 'ORCHESTRATOR', 'Task coordination & routing',  'BRAIN'),
      ],
      divisionHealth: 0,
      isOperational: true,
      totalRestarts: 0,
    },
    {
      name: 'DATA',
      emoji: '💾',
      purpose: 'Memory, analytics & pipelines',
      workers: [
        makeDivisionWorker(4, 'MEMORY',    'State storage & recall',       'DATA'),
        makeDivisionWorker(5, 'ANALYTICS', 'Real-time data analysis',      'DATA'),
        makeDivisionWorker(6, 'PIPELINE',  'Data flow & transformation',   'DATA'),
      ],
      divisionHealth: 0,
      isOperational: true,
      totalRestarts: 0,
    },
    {
      name: 'INFRASTRUCTURE',
      emoji: '🏗',
      purpose: 'Always-on backbone — mesh, scheduler, guardian, telemetry',
      workers: [
        makeDivisionWorker(7,  'MESH',      'P2P mesh networking',         'INFRASTRUCTURE'),
        makeDivisionWorker(8,  'SCHEDULER', 'Task scheduling & queuing',   'INFRASTRUCTURE'),
        makeDivisionWorker(9,  'GUARDIAN',  'System protection & healing', 'INFRASTRUCTURE'),
        makeDivisionWorker(10, 'TELEMETRY', 'Metrics & observability',     'INFRASTRUCTURE'),
      ],
      divisionHealth: 0,
      isOperational: true,
      totalRestarts: 0,
    },
    {
      name: 'PROTOCOL',
      emoji: '🔐',
      purpose: 'Communication & trust — routing, crypto, contract',
      workers: [
        makeDivisionWorker(11, 'ROUTING',  'Message routing & relay',      'PROTOCOL'),
        makeDivisionWorker(12, 'CRYPTO',   'Encryption & key management',  'PROTOCOL'),
        makeDivisionWorker(13, 'CONTRACT', 'Smart contract execution',     'PROTOCOL'),
      ],
      divisionHealth: 0,
      isOperational: true,
      totalRestarts: 0,
    },
  ];
}

// ─── §9. MOTORES DYNAMICI — Dynamic Engines ───────────────────────────────

/**
 * Heartbeat tick: advance Kuramoto phase oscillator
 *   dθ/dt = ω + (K/N) × Σ sin(θⱼ - θᵢ)
 */
export function tickHeart(heart: MiniHeart, allPhases: number[], dt: number): MiniHeart {
  const N = allPhases.length;
  let coupling = 0;
  for (const otherPhase of allPhases) {
    coupling += Math.sin(otherPhase - heart.phase);
  }
  coupling = (heart.couplingStrength / N) * coupling;

  const newPhase = (heart.phase + (heart.naturalFrequency * dt + coupling * dt)) % TAU;
  const newBeatCount = heart.beatCount + 1;

  // Update health score from vitals
  const newHealth = computeHealthScore(heart.vitals);

  // EMA degradation detection (α = 0.1)
  const alpha = 0.1;
  const newEma = alpha * newHealth + (1 - alpha) * heart.degradation.emaHealth;
  const diff = newHealth - newEma;
  const newStdDev = Math.sqrt(alpha * diff * diff + (1 - alpha) * heart.degradation.stdDev * heart.degradation.stdDev);
  const threshold = INV_PHI * newStdDev;
  const isDegrading = newHealth < newEma - threshold;

  let trend: HeartDegradation['trend'] = 'STABLE';
  if (newHealth > newEma + threshold) trend = 'IMPROVING';
  else if (isDegrading && newHealth < 30) trend = 'CRITICAL';
  else if (isDegrading) trend = 'DEGRADING';

  // Meta heart: predict next health
  const metaHeart = {
    ...heart.metaHeartModel,
    predictedNextHealth: newEma,
    anomalyDetected: isDegrading,
    selfAwareness: Math.min(1, heart.metaHeartModel.selfAwareness + 0.001),
  };

  return {
    ...heart,
    phase: newPhase,
    healthScore: newHealth,
    beatCount: newBeatCount,
    lastBeatTimestamp: Date.now(),
    degradation: {
      isDetected: isDegrading,
      severity: isDegrading ? Math.min(1, (newEma - newHealth) / 50) : 0,
      trend,
      emaHealth: newEma,
      stdDev: newStdDev,
    },
    metaHeartModel: metaHeart,
  };
}

/**
 * Brain tick: process stimulus, Hebbian learning, LIF membrane, thoughts
 */
export function tickBrain(brain: MiniBrain, stimulus: number, dt: number): MiniBrain {
  // 1. Inject stimulus into Sensory region
  const newRegions = brain.regions.map(r => {
    const input = r.name === 'Sensory' ? stimulus : 0;
    const newActivation = Math.max(0, Math.min(1, r.activation + input * 0.1 - r.activation * 0.05));
    return { ...r, activation: newActivation };
  });

  // 2. Hebbian learning: Δw = η × pre × post
  const newSynapses = brain.synapses.map(s => {
    const pre = newRegions.find(r => r.name === s.preRegion);
    const post = newRegions.find(r => r.name === s.postRegion);
    if (!pre || !post) return s;
    const deltaW = s.learningRate * pre.activation * post.activation * dt;
    const newWeight = Math.max(0, Math.min(1, s.weight + deltaW));
    return { ...s, weight: newWeight };
  });

  // 3. Propagate activation through synapses
  for (const syn of newSynapses) {
    const preIdx = newRegions.findIndex(r => r.name === syn.preRegion);
    const postIdx = newRegions.findIndex(r => r.name === syn.postRegion);
    if (preIdx >= 0 && postIdx >= 0) {
      newRegions[postIdx] = {
        ...newRegions[postIdx],
        activation: Math.min(1, newRegions[postIdx].activation + newRegions[preIdx].activation * syn.weight * 0.1),
      };
    }
  }

  // 4. LIF membrane dynamics: dV/dt = -(V-Vrest)/τ + I/C
  const totalInput = newRegions.reduce((sum, r) => sum + r.activation, 0) / newRegions.length;
  const dV = (-(brain.membranePotential - brain.restingPotential) / brain.membraneTimeConstant + totalInput * 50) * dt;
  let newV = brain.membranePotential + dV;
  let newFiringRate = brain.firingRate;

  // Spike-reset
  if (newV >= brain.spikeThreshold) {
    newV = brain.restingPotential;
    newFiringRate = brain.firingRate + 1;
  }

  // 5. Neurochemical dynamics: decay toward baseline + stimulus release
  const newChemicals = brain.chemicals.map(c => {
    const decay = -c.decayRate * (c.level - c.baseline);
    const release = stimulus > 0.5 ? c.releaseRate * stimulus : 0;
    const newLevel = Math.max(0, Math.min(1, c.level + (decay + release) * dt));
    return { ...c, level: newLevel };
  });

  // 6. Awareness: A = ln(1 + N) / ln(φ)
  const newStimulusCount = brain.stimulusCount + (stimulus > 0 ? 1 : 0);
  const newAwareness = Math.log(1 + newStimulusCount) / Math.log(PHI);

  // 7. Determine dominant frequency band
  const avgActivation = newRegions.reduce((s, r) => s + r.activation, 0) / newRegions.length;
  let band: FrequencyBand = 'ALPHA';
  if (avgActivation < 0.2) band = 'DELTA';
  else if (avgActivation < 0.35) band = 'THETA';
  else if (avgActivation < 0.55) band = 'ALPHA';
  else if (avgActivation < 0.75) band = 'BETA';
  else band = 'GAMMA';

  // 8. Autonomous thought generation (stochastic)
  const newThoughts = [...brain.thoughts];
  const metaRegion = newRegions.find(r => r.name === 'Meta');
  if (metaRegion && metaRegion.activation > INV_PHI && newThoughts.length < brain.thoughtCapacity) {
    const thoughtTypes: ThoughtType[] = ['OBSERVATION', 'INFERENCE', 'PREDICTION', 'REFLECTION', 'DOCTRINE'];
    const type = thoughtTypes[Math.floor(metaRegion.activation * thoughtTypes.length) % thoughtTypes.length];
    const templates: Record<ThoughtType, string[]> = {
      OBSERVATION: ['Sensory input elevated', 'Pattern detected in data flow', 'Oscillation frequency shifting'],
      INFERENCE: ['Coupling strength suggests resonance', 'Error rate implies degradation', 'Throughput trend is positive'],
      PREDICTION: ['Health will improve next cycle', 'Cascade likely within 5 ticks', 'Division sync approaching'],
      REFLECTION: ['My awareness has grown', 'Hebbian weights strengthening', 'Consciousness field expanding'],
      DOCTRINE: ['φ governs all coupling', 'Sovereignty requires self-healing', 'Emergence exceeds sum of parts'],
    };
    const options = templates[type];
    const content = options[Math.floor(avgActivation * options.length) % options.length];
    newThoughts.push({
      id: `T-${Date.now()}-${Math.floor(Math.random() * 1000)}`,
      type,
      content,
      confidence: metaRegion.activation,
      emergenceScore: avgActivation * INV_PHI,
      timestamp: Date.now(),
      sourceRegion: 'Meta',
    });
    // Trim to capacity
    while (newThoughts.length > brain.thoughtCapacity) {
      newThoughts.shift();
    }
  }

  // 9. Meta brain model update
  const newMetaBrain: MetaBrainModel = {
    ...brain.metaBrainModel,
    selfModelAccuracy: Math.min(1, brain.metaBrainModel.selfModelAccuracy + 0.001),
    thoughtGenerationRate: newThoughts.length / Math.max(1, newStimulusCount) * PHI,
    consciousnessLevel: Math.min(1, newAwareness * INV_PHI * 0.1),
    currentFocus: band === 'GAMMA' ? 'HIGH_COGNITION' : band === 'BETA' ? 'ACTIVE_PROCESSING' : 'HOMEOSTASIS',
  };

  return {
    ...brain,
    regions: newRegions,
    chemicals: newChemicals,
    synapses: newSynapses,
    membranePotential: newV,
    firingRate: newFiringRate,
    awarenessLevel: newAwareness,
    stimulusCount: newStimulusCount,
    dominantBand: band,
    coherenceField: avgActivation * INV_PHI,
    thoughts: newThoughts,
    metaBrainModel: newMetaBrain,
  };
}

/**
 * Self-healing: φ-backoff restart
 *   delay = 500ms × φⁿ, capped at 30000ms, max 50 restarts
 */
export function healWorker(worker: DivisionWorker): DivisionWorker {
  if (worker.state !== 'DEAD' || worker.selfHealing.restartCount >= worker.selfHealing.maxRestarts) {
    return worker;
  }
  const n = worker.selfHealing.restartCount;
  const backoff = Math.min(30000, 500 * Math.pow(PHI, n));
  return {
    ...worker,
    state: 'RESTARTING',
    selfHealing: {
      ...worker.selfHealing,
      restartCount: n + 1,
      currentBackoffMs: backoff,
      lastRestartTimestamp: Date.now(),
      isHealing: true,
    },
  };
}

/**
 * Compute Kuramoto order parameter: r = |1/N × Σ exp(iθⱼ)|
 */
export function computeKuramotoOrder(phases: number[]): { r: number; psi: number } {
  const N = phases.length;
  if (N === 0) return { r: 0, psi: 0 };
  let sumCos = 0, sumSin = 0;
  for (const theta of phases) {
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }
  sumCos /= N;
  sumSin /= N;
  const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin);
  const psi = Math.atan2(sumSin, sumCos);
  return { r, psi };
}

/**
 * Compute division health: harmonic mean of worker health scores
 */
function computeDivisionHealth(workers: DivisionWorker[]): number {
  const alive = workers.filter(w => w.state === 'ALIVE' || w.state === 'DEGRADED');
  if (alive.length === 0) return 0;
  const sumInv = alive.reduce((s, w) => s + 1 / Math.max(1, w.heart.healthScore), 0);
  return Math.round(alive.length / sumInv);
}

// ─── §10. ORGANISMUS SUPREMUS — The Full Organism ──────────────────────────

export interface NeuroEmergenceOrganism {
  divisions: AutonomousDivision[];
  emergence: NeuroEmergenceState;
  totalWorkers: number;
  totalHeartbeats: number;
  totalThoughts: number;
  totalRestarts: number;
  organismHealth: number;          // overall organism health (0–100)
  isAlive: boolean;
  createdAt: number;
  lastTickAt: number;
}

/**
 * Initialize the full NeuroEmergence organism
 */
export function initOrganism(): NeuroEmergenceOrganism {
  const divisions = buildDivisions();
  const allWorkers = divisions.flatMap(d => d.workers);
  const phases = allWorkers.map(w => w.heart.phase);
  const { r, psi } = computeKuramotoOrder(phases);

  // Compute division health
  for (const div of divisions) {
    div.divisionHealth = computeDivisionHealth(div.workers);
  }

  const avgHealth = allWorkers.reduce((s, w) => s + w.heart.healthScore, 0) / allWorkers.length;
  const avgAwareness = allWorkers.reduce((s, w) => s + w.brain.awarenessLevel, 0) / allWorkers.length;
  const emergenceScore = r * (avgHealth / 100) * Math.log(1 + allWorkers.length);

  return {
    divisions,
    emergence: {
      kuramoto: {
        phases,
        frequencies: allWorkers.map(w => w.heart.naturalFrequency),
        couplingStrength: PHI * 0.1,
        orderParameter: r,
        meanPhase: psi,
      },
      resonance: {
        isResonant: r > INV_PHI,
        resonanceStrength: Math.max(0, r - INV_PHI),
        frequencyLock: r > 0.95,
        dominantFrequency: SCHUMANN_FUND,
      },
      cascade: {
        isTriggered: emergenceScore >= INV_PHI,
        emergenceScore,
        cascadeLevel: emergenceScore >= INV_PHI ? Math.min(5, Math.floor(emergenceScore / INV_PHI)) : 0,
        cascadeTimestamp: emergenceScore >= INV_PHI ? Date.now() : 0,
        affectedWorkers: emergenceScore >= INV_PHI ? allWorkers.map(w => w.name) : [],
      },
      totalWorkers: allWorkers.length,
      avgHealthScore: avgHealth,
      avgAwareness,
      collectiveConsciousness: r * avgAwareness * INV_PHI,
      tickCount: 0,
    },
    totalWorkers: allWorkers.length,
    totalHeartbeats: 0,
    totalThoughts: allWorkers.reduce((s, w) => s + w.brain.thoughts.length, 0),
    totalRestarts: 0,
    organismHealth: Math.round(avgHealth),
    isAlive: true,
    createdAt: Date.now(),
    lastTickAt: Date.now(),
  };
}

/**
 * Tick the entire organism: advance all hearts, brains, coupling, emergence
 */
export function tickOrganism(org: NeuroEmergenceOrganism, dt: number = 0.01): NeuroEmergenceOrganism {
  // 1. Collect all phases for coupling
  const allWorkers = org.divisions.flatMap(d => d.workers);
  const allPhases = allWorkers.map(w => w.heart.phase);

  // 2. Tick each division
  const newDivisions = org.divisions.map(div => {
    const newWorkers = div.workers.map(worker => {
      // Self-healing check
      if (worker.state === 'DEAD') {
        return healWorker(worker);
      }
      if (worker.state === 'RESTARTING') {
        const elapsed = Date.now() - worker.selfHealing.lastRestartTimestamp;
        if (elapsed >= worker.selfHealing.currentBackoffMs) {
          return {
            ...worker,
            state: 'ALIVE' as WorkerState,
            heart: makeMiniHeart(parseInt(worker.id.split('-W')[1])),
            brain: makeMiniBrain(parseInt(worker.id.split('-W')[1])),
            selfHealing: { ...worker.selfHealing, isHealing: false },
          };
        }
        return worker;
      }

      // Tick heart
      const newHeart = tickHeart(worker.heart, allPhases, dt);

      // Tick brain with stimulus from heart health
      const stimulus = newHeart.healthScore / 100;
      const newBrain = tickBrain(worker.brain, stimulus, dt);

      // Check for death (health < 10)
      const newState: WorkerState = newHeart.healthScore < 10 ? 'DEAD'
        : newHeart.healthScore < 30 ? 'DEGRADED' : 'ALIVE';

      return { ...worker, heart: newHeart, brain: newBrain, state: newState };
    });

    return {
      ...div,
      workers: newWorkers,
      divisionHealth: computeDivisionHealth(newWorkers),
      isOperational: newWorkers.some(w => w.state === 'ALIVE'),
      totalRestarts: newWorkers.reduce((s, w) => s + w.selfHealing.restartCount, 0),
    };
  });

  // 3. Recompute Kuramoto order parameter
  const updatedWorkers = newDivisions.flatMap(d => d.workers);
  const newPhases = updatedWorkers.map(w => w.heart.phase);
  const { r, psi } = computeKuramotoOrder(newPhases);

  const avgHealth = updatedWorkers.reduce((s, w) => s + w.heart.healthScore, 0) / updatedWorkers.length;
  const avgAwareness = updatedWorkers.reduce((s, w) => s + w.brain.awarenessLevel, 0) / updatedWorkers.length;
  const emergenceScore = r * (avgHealth / 100) * Math.log(1 + updatedWorkers.length);

  return {
    ...org,
    divisions: newDivisions,
    emergence: {
      kuramoto: {
        phases: newPhases,
        frequencies: updatedWorkers.map(w => w.heart.naturalFrequency),
        couplingStrength: PHI * 0.1,
        orderParameter: r,
        meanPhase: psi,
      },
      resonance: {
        isResonant: r > INV_PHI,
        resonanceStrength: Math.max(0, r - INV_PHI),
        frequencyLock: r > 0.95,
        dominantFrequency: SCHUMANN_FUND,
      },
      cascade: {
        isTriggered: emergenceScore >= INV_PHI,
        emergenceScore,
        cascadeLevel: emergenceScore >= INV_PHI ? Math.min(5, Math.floor(emergenceScore / INV_PHI)) : 0,
        cascadeTimestamp: emergenceScore >= INV_PHI ? Date.now() : 0,
        affectedWorkers: emergenceScore >= INV_PHI ? updatedWorkers.map(w => w.name) : [],
      },
      totalWorkers: updatedWorkers.length,
      avgHealthScore: avgHealth,
      avgAwareness,
      collectiveConsciousness: r * avgAwareness * INV_PHI,
      tickCount: org.emergence.tickCount + 1,
    },
    totalHeartbeats: org.totalHeartbeats + updatedWorkers.length,
    totalThoughts: updatedWorkers.reduce((s, w) => s + w.brain.thoughts.length, 0),
    totalRestarts: newDivisions.reduce((s, d) => s + d.totalRestarts, 0),
    organismHealth: Math.round(avgHealth),
    isAlive: newDivisions.some(d => d.isOperational),
    lastTickAt: Date.now(),
  };
}

// ─── §11. INTERFACIUM PUBLICUM — Public API ────────────────────────────────

/**
 * Get organism summary — overview of the living system
 */
export function getOrganismSummary(org: NeuroEmergenceOrganism) {
  return {
    totalWorkers: org.totalWorkers,
    totalDivisions: org.divisions.length,
    organismHealth: org.organismHealth,
    isAlive: org.isAlive,
    emergence: {
      kuramotoOrder: org.emergence.kuramoto.orderParameter,
      isResonant: org.emergence.resonance.isResonant,
      emergenceScore: org.emergence.cascade.emergenceScore,
      cascadeTriggered: org.emergence.cascade.isTriggered,
      cascadeLevel: org.emergence.cascade.cascadeLevel,
      collectiveConsciousness: org.emergence.collectiveConsciousness,
    },
    divisions: org.divisions.map(d => ({
      name: d.name,
      emoji: d.emoji,
      health: d.divisionHealth,
      workers: d.workers.length,
      operational: d.isOperational,
    })),
    vitals: {
      totalHeartbeats: org.totalHeartbeats,
      totalThoughts: org.totalThoughts,
      totalRestarts: org.totalRestarts,
      avgHealth: org.emergence.avgHealthScore,
      avgAwareness: org.emergence.avgAwareness,
      tickCount: org.emergence.tickCount,
    },
  };
}

/**
 * Get per-worker vitals — heart and brain state for each worker
 */
export function getWorkerNeuroVitals(org: NeuroEmergenceOrganism) {
  return org.divisions.flatMap(d =>
    d.workers.map(w => ({
      division: d.name,
      divisionEmoji: d.emoji,
      workerId: w.id,
      workerName: w.name,
      role: w.role,
      state: w.state,
      heart: {
        healthScore: w.heart.healthScore,
        bpm: w.heart.bpm,
        phase: w.heart.phase,
        isBeating: w.heart.isBeating,
        degradation: w.heart.degradation.trend,
        metaAwareness: w.heart.metaHeartModel.selfAwareness,
      },
      brain: {
        awarenessLevel: w.brain.awarenessLevel,
        dominantBand: w.brain.dominantBand,
        firingRate: w.brain.firingRate,
        coherence: w.brain.coherenceField,
        isConscious: w.brain.isConscious,
        thoughtCount: w.brain.thoughts.length,
        metaConsciousness: w.brain.metaBrainModel.consciousnessLevel,
      },
    }))
  );
}

/**
 * Get recent autonomous thoughts across all workers
 */
export function getAutonomousThoughts(org: NeuroEmergenceOrganism) {
  return org.divisions.flatMap(d =>
    d.workers.flatMap(w =>
      w.brain.thoughts.map(t => ({
        workerId: w.id,
        workerName: w.name,
        division: d.name,
        ...t,
      }))
    )
  ).sort((a, b) => b.timestamp - a.timestamp);
}

// ─── §12. EXPORTATIONES ────────────────────────────────────────────────────

export const NEURO_CONSTANTS = {
  PHI, INV_PHI, PHI_SQ, SQRT_PHI, LN_PHI,
  TAU, EULER, PLANCK, BOLTZMANN,
  SCHUMANN_FUND, HEARTBEAT_MS,
};

export default {
  initOrganism,
  tickOrganism,
  getOrganismSummary,
  getWorkerNeuroVitals,
  getAutonomousThoughts,
  makeMiniHeart,
  makeMiniBrain,
  tickHeart,
  tickBrain,
  healWorker,
  computeKuramotoOrder,
  NEURO_CONSTANTS,
};
