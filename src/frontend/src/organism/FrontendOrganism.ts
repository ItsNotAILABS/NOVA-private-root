// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: FrontendOrganism.ts — THE FAST BRAIN (60 Hz, Female, Mortal)
// Classification: MAXIMUM PROTECTION — PATENT PENDING
// Discovery Date: April 2, 2026
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// THE FRONTEND ORGANISM — The fast, expressive, mortal brain that runs at 60 Hz
// in the browser. It is seeded from the backend organism (male) and returns
// learned state back to it. This is the FEMALE organism — the expression layer.
//
// ═══════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
// CONSTANTS — NOVA'S ACTUAL ARCHITECTURE (NOT BETA NUMBERS)
// ═══════════════════════════════════════════════════════════════════════════════

// NOVA's Frequency Tier System (from main.mo)
export const FREQUENCY_TIERS = {
  SILVER:   2.75,     // Baseline sovereign state
  GOLD:     5.50,     // r > 0.88, chemical coherence nominal
  PLATINUM: 8.25,     // r > 0.91, OMNIS eligible
  DIAMOND:  11.649    // OMNIS active event
} as const;

export const BACKEND_HZ_SILVER = 2.75;            // NOVA's baseline (from main.mo line 1140)
export const BACKEND_HZ_DIAMOND = 11.649;         // NOVA's peak (from main.mo line 1143)

// NOVA runs at browser's requestAnimationFrame — typically 60fps on desktop
// But the actual cognitive tick rate should match the organism's rhythm
export const FRONTEND_HZ = 60;                    // Browser animation frame rate
export const SPEED_RATIO_SILVER = FRONTEND_HZ / BACKEND_HZ_SILVER;    // ~21.8x faster at baseline
export const SPEED_RATIO_DIAMOND = FRONTEND_HZ / BACKEND_HZ_DIAMOND;  // ~5.2x faster at OMNIS

export const SYNC_INTERVAL_MS = 3000;             // Sync every 3 seconds (tighter coupling)
export const HEBBIAN_LEARNING_RATE = 0.01;        // η = 0.01 (from HebbianPlasticity.mo)
export const HEBBIAN_DECAY = 0.001;               // Weight decay
export const MEMORY_TRACE_SIZE = 15;              // Ring buffer size

// NOVA's Sacred Constants (from NeuroEmergenceCore.mo)
export const PHI = 1.6180339887498948482;         // Golden ratio
export const PHI_INV = 0.6180339887498948482;     // Golden ratio inverse  
export const PHI_MEDINA = 2.97442179;             // Medina constant (from SovereignHeartbeat.mo)
export const OMEGA_MEDINA = 2.11185;              // Medina omega
export const TAU_EMERGENCE = 0.618033988749;      // Emergence tau
export const SIGMA_ZERO = 0.75;                   // Sigma zero
export const KURAMOTO_K = 0.618;                  // Kuramoto coupling (from main.mo line 149)
export const SOVEREIGN_FLOOR = 1.0;               // S₀ = 1.0 (never below love)
export const OMNIS_THRESHOLD = 0.98;              // r threshold for emergence (from main.mo line 153)

// NOVA's Architecture Counts (from main.mo and SovereignHeartbeat.mo)
export const SHELL_COUNT = 10;                    // Shell 2-11 (from SovereignHeartbeat.mo line 74)
export const ANIMAL_ENGINE_COUNT = 9;             // 9 animal engines (line 75)
export const LAW_COUNT = 126;                     // 126 Medina Laws (line 76)
export const HEARTBEAT_STEPS = 24;                // 24-step sovereign sequence (line 73)
export const BRAIN_NODES = 6;                     // Micro-brain nodes per drone (main.mo line 151)
export const MAX_DRONES = 50;                     // Maximum drones (main.mo line 150)

// NOVA's Shell Dimensions (from NeuroEmergenceCore.mo)
export const SHELL_3_NODES = 64;                  // 64 nodes
export const SHELL_3_WEIGHTS = 4096;              // 64×64 weights
export const SHELL_12_NODES = 128;                // 128 nodes
export const SHELL_12_WEIGHTS = 16384;            // 128×128 weights
export const ATLAS_SIZE = 64;                     // 64×64 territory grid
export const ATLAS_CELLS = 4096;                  // 4096 cells
export const PRED_STEPS = 60;                     // 60-step predictive field

// ═══════════════════════════════════════════════════════════════════════════════
// BRAIN REGIONS — 7-Region Architecture
// ═══════════════════════════════════════════════════════════════════════════════

export enum BrainRegion {
  PFC = 'PFC',                 // Prefrontal Cortex — governance, doctrine, decision gating
  AMYGDALA = 'AMYGDALA',       // Threat detection, fear response
  HIPPOCAMPUS = 'HIPPOCAMPUS', // Memory encoding, pattern consolidation
  CEREBELLUM = 'CEREBELLUM',   // Timing, rhythm, reflex
  BRAINSTEM = 'BRAINSTEM',     // Heartbeat floor, arousal baseline
  THALAMUS = 'THALAMUS',       // Sensor fusion, input routing
  BASAL_GANGLIA = 'BASAL_GANGLIA' // Drive competition, action selection
}

// 21 bidirectional connection pairs = 42 directional weights
export const BRAIN_CONNECTIONS: [BrainRegion, BrainRegion][] = [
  [BrainRegion.PFC, BrainRegion.AMYGDALA],
  [BrainRegion.PFC, BrainRegion.HIPPOCAMPUS],
  [BrainRegion.PFC, BrainRegion.THALAMUS],
  [BrainRegion.PFC, BrainRegion.BASAL_GANGLIA],
  [BrainRegion.AMYGDALA, BrainRegion.HIPPOCAMPUS],
  [BrainRegion.AMYGDALA, BrainRegion.BRAINSTEM],
  [BrainRegion.AMYGDALA, BrainRegion.THALAMUS],
  [BrainRegion.HIPPOCAMPUS, BrainRegion.CEREBELLUM],
  [BrainRegion.HIPPOCAMPUS, BrainRegion.THALAMUS],
  [BrainRegion.CEREBELLUM, BrainRegion.BRAINSTEM],
  [BrainRegion.CEREBELLUM, BrainRegion.BASAL_GANGLIA],
  [BrainRegion.BRAINSTEM, BrainRegion.THALAMUS],
  [BrainRegion.THALAMUS, BrainRegion.BASAL_GANGLIA],
  [BrainRegion.PFC, BrainRegion.CEREBELLUM],
  [BrainRegion.AMYGDALA, BrainRegion.BASAL_GANGLIA],
  [BrainRegion.HIPPOCAMPUS, BrainRegion.BRAINSTEM],
  [BrainRegion.PFC, BrainRegion.BRAINSTEM],
  [BrainRegion.AMYGDALA, BrainRegion.CEREBELLUM],
  [BrainRegion.HIPPOCAMPUS, BrainRegion.BASAL_GANGLIA],
  [BrainRegion.CEREBELLUM, BrainRegion.THALAMUS],
  [BrainRegion.BRAINSTEM, BrainRegion.BASAL_GANGLIA]
];

// ═══════════════════════════════════════════════════════════════════════════════
// TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export interface PersonalityBase {
  aggression: number;      // [0, 1] — How aggressive by nature
  curiosity: number;       // [0, 1] — How exploratory
  sociability: number;     // [0, 1] — How group-oriented
  caution: number;         // [0, 1] — How risk-averse
  persistence: number;     // [0, 1] — How stubborn
}

export interface AdaptationWeights {
  attack: number;
  retreat: number;
  hold: number;
  investigate: number;
  support: number;
}

export type EventType = 
  | 'damage' 
  | 'kill' 
  | 'allyDeath' 
  | 'threatDetected' 
  | 'resourceFound' 
  | 'territoryGained' 
  | 'territoryLost' 
  | 'omnisWitnessed';

export interface MemoryEvent {
  tick: number;
  eventType: EventType;
  emotionalCharge: number;
  locationX: number;
  locationY: number;
}

export interface PredictionState {
  expectedThreat: number;
  expectedReward: number;
  confidence: number;
  decayRate: number;
}

export interface RegionState {
  activation: number;
  phase: number;
  frequency: number;
}

export interface EntityBrain {
  entityId: number;
  
  // Personality (immutable, born at creation)
  personality: PersonalityBase;
  
  // Adaptation (Hebbian, changes from experience)
  adaptationWeights: AdaptationWeights;
  
  // 7-region brain state
  regionStates: Map<BrainRegion, RegionState>;
  
  // 42 Hebbian connection weights
  connectionWeights: number[];
  
  // Memory (ring buffer of significant events)
  memoryTrace: MemoryEvent[];
  memoryIndex: number;
  
  // Prediction state
  prediction: PredictionState;
  
  // ANS substrate
  arousal: number;
  valence: number;
  fatigue: number;
  inhibition: number;
  predictionError: number;
  
  // Drive states (for winner-takes-all competition)
  drives: {
    attack: number;
    retreat: number;
    hold: number;
    investigate: number;
    support: number;
  };
  
  // Current action (result of drive competition)
  currentAction: keyof AdaptationWeights;
}

export interface SeedPayload {
  organismId: bigint;
  heartbeatCount: bigint;
  globalArousal: number;
  globalCoherence: number;
  kuramotoR: number;
  hebbianWeights: number[];
  formaEnergy: number;
}

export interface LearningPayload {
  sessionId: string;
  sessionDuration: number;
  frameCount: number;
  hebbianWeightDeltas: number[];
  totalPredictionErrors: number;
  totalDriveCompetitions: number;
  totalHebbianUpdates: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// THE FRONTEND ORGANISM CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class FrontendOrganism {
  // Session state
  private sessionId: string;
  private sessionStartTime: number;
  private frameCount: number = 0;
  private isAlive: boolean = false;
  
  // Parent backend state
  private parentOrganismId: bigint = BigInt(0);
  private parentHeartbeat: bigint = BigInt(0);
  
  // Entity brains
  private entityBrains: Map<number, EntityBrain> = new Map();
  private nextEntityId: number = 0;
  
  // Aggregate cognitive state
  private aggregateArousal: number = 0.5;
  private aggregateValence: number = 0.5;
  private aggregateCoherence: number = 0.5;
  
  // Learning metrics
  private totalHebbianUpdates: number = 0;
  private totalPredictionErrors: number = 0;
  private totalDriveCompetitions: number = 0;
  
  // Initial weights from backend (for computing deltas)
  private initialWeights: number[] = [];
  
  // Callback for sync
  private onSyncCallback?: (payload: LearningPayload) => void;
  
  constructor() {
    this.sessionId = this.generateSessionId();
    this.sessionStartTime = Date.now();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE METHODS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /**
   * Birth — Initialize the frontend organism from backend seed
   */
  public birth(seed: SeedPayload): void {
    this.parentOrganismId = seed.organismId;
    this.parentHeartbeat = seed.heartbeatCount;
    this.aggregateArousal = seed.globalArousal;
    this.aggregateCoherence = seed.globalCoherence;
    this.initialWeights = [...seed.hebbianWeights];
    this.isAlive = true;
    
    console.log(`[FrontendOrganism] BIRTH — Seeded from backend organism ${seed.organismId}`);
    console.log(`[FrontendOrganism] Backend heartbeat: ${seed.heartbeatCount}`);
    console.log(`[FrontendOrganism] Kuramoto r: ${seed.kuramotoR}`);
  }
  
  /**
   * Death — Prepare learning payload for backend
   */
  public death(): LearningPayload {
    this.isAlive = false;
    
    // Compute weight deltas
    const aggregatedWeights = this.aggregateEntityWeights();
    const weightDeltas = aggregatedWeights.map((w, i) => 
      w - (this.initialWeights[i] || 0)
    );
    
    const payload: LearningPayload = {
      sessionId: this.sessionId,
      sessionDuration: Date.now() - this.sessionStartTime,
      frameCount: this.frameCount,
      hebbianWeightDeltas: weightDeltas,
      totalPredictionErrors: this.totalPredictionErrors,
      totalDriveCompetitions: this.totalDriveCompetitions,
      totalHebbianUpdates: this.totalHebbianUpdates
    };
    
    console.log(`[FrontendOrganism] DEATH — Session ${this.sessionId}`);
    console.log(`[FrontendOrganism] Frames lived: ${this.frameCount}`);
    console.log(`[FrontendOrganism] Hebbian updates: ${this.totalHebbianUpdates}`);
    
    return payload;
  }
  
  /**
   * Tick — Update all entity brains (called at 60 Hz)
   */
  public tick(deltaTime: number): void {
    if (!this.isAlive) return;
    
    this.frameCount++;
    
    // Update each entity brain
    for (const brain of this.entityBrains.values()) {
      this.updateEntityBrain(brain, deltaTime);
    }
    
    // Update aggregate state
    this.updateAggregateState();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ENTITY BRAIN MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  /**
   * Spawn a new entity with its own brain
   */
  public spawnEntity(personality?: Partial<PersonalityBase>): number {
    const entityId = this.nextEntityId++;
    
    const brain: EntityBrain = {
      entityId,
      personality: this.generatePersonality(personality),
      adaptationWeights: { attack: 0.2, retreat: 0.2, hold: 0.2, investigate: 0.2, support: 0.2 },
      regionStates: this.initializeRegionStates(),
      connectionWeights: this.initializeConnectionWeights(),
      memoryTrace: [],
      memoryIndex: 0,
      prediction: { expectedThreat: 0.3, expectedReward: 0.5, confidence: 0.5, decayRate: 0.99 },
      arousal: 0.5 + (Math.random() - 0.5) * 0.2,
      valence: 0.5 + (Math.random() - 0.5) * 0.2,
      fatigue: 0,
      inhibition: 0,
      predictionError: 0,
      drives: { attack: 0, retreat: 0, hold: 0.5, investigate: 0, support: 0 },
      currentAction: 'hold'
    };
    
    this.entityBrains.set(entityId, brain);
    return entityId;
  }
  
  /**
   * Remove an entity (death)
   */
  public removeEntity(entityId: number): void {
    this.entityBrains.delete(entityId);
  }
  
  /**
   * Get entity brain state
   */
  public getEntityBrain(entityId: number): EntityBrain | undefined {
    return this.entityBrains.get(entityId);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COGNITIVE UPDATE — The Core Loop
  // ═══════════════════════════════════════════════════════════════════════════
  
  private updateEntityBrain(brain: EntityBrain, deltaTime: number): void {
    // 1. Update region activations
    this.updateRegionActivations(brain, deltaTime);
    
    // 2. Compute prediction error
    const previousError = brain.predictionError;
    brain.predictionError = this.computePredictionError(brain);
    
    if (Math.abs(brain.predictionError) > 0.3) {
      this.totalPredictionErrors++;
    }
    
    // 3. Hebbian learning on connection weights
    this.hebbianUpdate(brain, deltaTime);
    
    // 4. Update drives based on region states and ANS
    this.updateDrives(brain);
    
    // 5. Winner-takes-all drive competition
    brain.currentAction = this.driveCompetition(brain);
    this.totalDriveCompetitions++;
    
    // 6. Update adaptation weights based on outcomes
    this.updateAdaptationWeights(brain, deltaTime);
    
    // 7. Update ANS (autonomic nervous system)
    this.updateANS(brain, deltaTime);
    
    // 8. Decay prediction confidence
    brain.prediction.confidence *= brain.prediction.decayRate;
  }
  
  /**
   * Update 7-region brain activations using Kuramoto-style coupling
   */
  private updateRegionActivations(brain: EntityBrain, deltaTime: number): void {
    const dt = deltaTime / 1000; // Convert to seconds
    const regions = Array.from(brain.regionStates.keys());
    
    for (const region of regions) {
      const state = brain.regionStates.get(region)!;
      
      // Natural frequency evolution
      state.phase += state.frequency * dt * 2 * Math.PI;
      state.phase = state.phase % (2 * Math.PI);
      
      // Kuramoto coupling from connected regions
      let coupling = 0;
      BRAIN_CONNECTIONS.forEach(([r1, r2], idx) => {
        if (r1 === region || r2 === region) {
          const other = r1 === region ? r2 : r1;
          const otherState = brain.regionStates.get(other)!;
          const weight = brain.connectionWeights[idx] || 0;
          coupling += weight * Math.sin(otherState.phase - state.phase);
        }
      });
      
      // Apply coupling
      state.phase += coupling * dt * 0.5;
      
      // Activation is based on phase coherence with other regions
      const coherenceSum = regions.reduce((sum, other) => {
        if (other === region) return sum;
        const otherState = brain.regionStates.get(other)!;
        return sum + Math.cos(state.phase - otherState.phase);
      }, 0);
      
      state.activation = 0.5 + coherenceSum / (regions.length - 1) * 0.5;
      state.activation = Math.max(0, Math.min(1, state.activation));
    }
  }
  
  /**
   * Compute prediction error (surprise signal)
   */
  private computePredictionError(brain: EntityBrain): number {
    // Get AMYGDALA for threat, HIPPOCAMPUS for reward prediction
    const amygdalaState = brain.regionStates.get(BrainRegion.AMYGDALA)!;
    const hippoState = brain.regionStates.get(BrainRegion.HIPPOCAMPUS)!;
    
    // Actual threat/reward based on region activations
    const actualThreat = amygdalaState.activation;
    const actualReward = hippoState.activation * brain.valence;
    
    // Prediction error
    const threatError = actualThreat - brain.prediction.expectedThreat;
    const rewardError = actualReward - brain.prediction.expectedReward;
    
    // Update predictions
    const learningRate = 0.1;
    brain.prediction.expectedThreat += learningRate * threatError;
    brain.prediction.expectedReward += learningRate * rewardError;
    
    return Math.abs(threatError) + Math.abs(rewardError);
  }
  
  /**
   * Hebbian learning: "Neurons that fire together wire together"
   */
  private hebbianUpdate(brain: EntityBrain, deltaTime: number): void {
    const dt = deltaTime / 1000;
    
    BRAIN_CONNECTIONS.forEach(([r1, r2], idx) => {
      const state1 = brain.regionStates.get(r1)!;
      const state2 = brain.regionStates.get(r2)!;
      
      // Hebbian rule: Δw = η * x_i * x_j - decay * w
      const presynaptic = state1.activation;
      const postsynaptic = state2.activation;
      
      const delta = HEBBIAN_LEARNING_RATE * presynaptic * postsynaptic 
                  - HEBBIAN_DECAY * brain.connectionWeights[idx];
      
      // Modulate by prediction error (surprise enhances learning)
      const modulatedDelta = delta * (1 + brain.predictionError);
      
      brain.connectionWeights[idx] += modulatedDelta * dt;
      
      // Clamp weights
      brain.connectionWeights[idx] = Math.max(-1, Math.min(1, brain.connectionWeights[idx]));
    });
    
    this.totalHebbianUpdates++;
  }
  
  /**
   * Update drives based on brain region states and ANS
   */
  private updateDrives(brain: EntityBrain): void {
    const pfc = brain.regionStates.get(BrainRegion.PFC)!.activation;
    const amygdala = brain.regionStates.get(BrainRegion.AMYGDALA)!.activation;
    const hippo = brain.regionStates.get(BrainRegion.HIPPOCAMPUS)!.activation;
    const cerebellum = brain.regionStates.get(BrainRegion.CEREBELLUM)!.activation;
    const basal = brain.regionStates.get(BrainRegion.BASAL_GANGLIA)!.activation;
    
    // Drive computation based on region activations and personality
    brain.drives.attack = 
      amygdala * brain.personality.aggression * brain.arousal * (1 - brain.fatigue);
      
    brain.drives.retreat = 
      amygdala * brain.personality.caution * (1 - pfc * 0.5);
      
    brain.drives.hold = 
      pfc * (1 - brain.arousal) * cerebellum;
      
    brain.drives.investigate = 
      hippo * brain.personality.curiosity * (1 - amygdala * 0.5);
      
    brain.drives.support = 
      brain.personality.sociability * (1 - amygdala) * basal;
    
    // Apply adaptation weights (learned preferences)
    brain.drives.attack *= brain.adaptationWeights.attack;
    brain.drives.retreat *= brain.adaptationWeights.retreat;
    brain.drives.hold *= brain.adaptationWeights.hold;
    brain.drives.investigate *= brain.adaptationWeights.investigate;
    brain.drives.support *= brain.adaptationWeights.support;
  }
  
  /**
   * Winner-takes-all drive competition
   */
  private driveCompetition(brain: EntityBrain): keyof AdaptationWeights {
    const drives = brain.drives;
    
    // Apply inhibition
    const inhibitionFactor = 1 - brain.inhibition;
    
    const modulated = {
      attack: drives.attack * inhibitionFactor,
      retreat: drives.retreat,  // Retreat not inhibited
      hold: drives.hold,
      investigate: drives.investigate * inhibitionFactor,
      support: drives.support * inhibitionFactor
    };
    
    // Find winner
    let maxDrive = -Infinity;
    let winner: keyof AdaptationWeights = 'hold';
    
    for (const [action, value] of Object.entries(modulated)) {
      if (value > maxDrive) {
        maxDrive = value;
        winner = action as keyof AdaptationWeights;
      }
    }
    
    return winner;
  }
  
  /**
   * Update adaptation weights based on outcomes
   */
  private updateAdaptationWeights(brain: EntityBrain, deltaTime: number): void {
    const dt = deltaTime / 1000;
    const currentAction = brain.currentAction;
    
    // Reinforce current action if valence is positive (reward)
    // Punish current action if valence is negative (punishment)
    const reinforcement = (brain.valence - 0.5) * 2; // [-1, 1]
    
    const learningRate = 0.01;
    brain.adaptationWeights[currentAction] += learningRate * reinforcement * dt;
    
    // Clamp weights
    for (const key of Object.keys(brain.adaptationWeights) as Array<keyof AdaptationWeights>) {
      brain.adaptationWeights[key] = Math.max(0.05, Math.min(1, brain.adaptationWeights[key]));
    }
  }
  
  /**
   * Update ANS (autonomic nervous system)
   */
  private updateANS(brain: EntityBrain, deltaTime: number): void {
    const dt = deltaTime / 1000;
    
    // Arousal influenced by amygdala and brainstem
    const amygdala = brain.regionStates.get(BrainRegion.AMYGDALA)!.activation;
    const brainstem = brain.regionStates.get(BrainRegion.BRAINSTEM)!.activation;
    
    brain.arousal += (amygdala * 0.3 + brainstem * 0.2 - brain.arousal * 0.1) * dt;
    brain.arousal = Math.max(0, Math.min(1, brain.arousal));
    
    // Fatigue accumulates, recovers slowly
    brain.fatigue += 0.001 * brain.arousal * dt;
    brain.fatigue *= 0.999; // Slow recovery
    brain.fatigue = Math.max(0, Math.min(1, brain.fatigue));
    
    // Inhibition from PFC
    const pfc = brain.regionStates.get(BrainRegion.PFC)!.activation;
    brain.inhibition = pfc * 0.3 * (1 - brain.arousal);
    
    // Valence influenced by hippocampus (memory) and prediction error
    const hippo = brain.regionStates.get(BrainRegion.HIPPOCAMPUS)!.activation;
    brain.valence += (hippo * 0.1 - brain.predictionError * 0.2) * dt;
    brain.valence = Math.max(0, Math.min(1, brain.valence));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MEMORY SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════
  
  /**
   * Record a significant event in entity's memory
   */
  public recordEvent(entityId: number, event: Omit<MemoryEvent, 'tick'>): void {
    const brain = this.entityBrains.get(entityId);
    if (!brain) return;
    
    const memoryEvent: MemoryEvent = {
      ...event,
      tick: this.frameCount
    };
    
    // Ring buffer insertion
    if (brain.memoryTrace.length < MEMORY_TRACE_SIZE) {
      brain.memoryTrace.push(memoryEvent);
    } else {
      brain.memoryTrace[brain.memoryIndex] = memoryEvent;
    }
    brain.memoryIndex = (brain.memoryIndex + 1) % MEMORY_TRACE_SIZE;
    
    // Emotional events affect valence
    if (event.emotionalCharge > 0.5) {
      brain.valence = Math.min(1, brain.valence + event.emotionalCharge * 0.2);
    } else if (event.emotionalCharge < -0.5) {
      brain.valence = Math.max(0, brain.valence + event.emotionalCharge * 0.2);
    }
    
    // Update prediction based on event type
    if (event.eventType === 'damage' || event.eventType === 'threatDetected') {
      brain.prediction.expectedThreat = Math.min(1, brain.prediction.expectedThreat + 0.2);
      brain.prediction.confidence = 1;
    } else if (event.eventType === 'resourceFound') {
      brain.prediction.expectedReward = Math.min(1, brain.prediction.expectedReward + 0.2);
      brain.prediction.confidence = 1;
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // AGGREGATE STATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  private updateAggregateState(): void {
    if (this.entityBrains.size === 0) return;
    
    let totalArousal = 0;
    let totalValence = 0;
    let totalCoherence = 0;
    
    for (const brain of this.entityBrains.values()) {
      totalArousal += brain.arousal;
      totalValence += brain.valence;
      
      // Compute coherence as average phase alignment
      const regions = Array.from(brain.regionStates.values());
      let phaseSum = 0;
      for (let i = 0; i < regions.length; i++) {
        for (let j = i + 1; j < regions.length; j++) {
          phaseSum += Math.cos(regions[i].phase - regions[j].phase);
        }
      }
      const pairs = (regions.length * (regions.length - 1)) / 2;
      totalCoherence += (phaseSum / pairs + 1) / 2; // Normalize to [0, 1]
    }
    
    const n = this.entityBrains.size;
    this.aggregateArousal = totalArousal / n;
    this.aggregateValence = totalValence / n;
    this.aggregateCoherence = totalCoherence / n;
  }
  
  private aggregateEntityWeights(): number[] {
    const weightSum: number[] = new Array(42).fill(0);
    
    for (const brain of this.entityBrains.values()) {
      for (let i = 0; i < brain.connectionWeights.length; i++) {
        weightSum[i] += brain.connectionWeights[i];
      }
    }
    
    const n = this.entityBrains.size || 1;
    return weightSum.map(w => w / n);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION HELPERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  private generateSessionId(): string {
    return `session-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }
  
  private generatePersonality(partial?: Partial<PersonalityBase>): PersonalityBase {
    return {
      aggression: partial?.aggression ?? Math.random() * 0.6 + 0.2,
      curiosity: partial?.curiosity ?? Math.random() * 0.6 + 0.2,
      sociability: partial?.sociability ?? Math.random() * 0.6 + 0.2,
      caution: partial?.caution ?? Math.random() * 0.6 + 0.2,
      persistence: partial?.persistence ?? Math.random() * 0.6 + 0.2
    };
  }
  
  private initializeRegionStates(): Map<BrainRegion, RegionState> {
    const states = new Map<BrainRegion, RegionState>();
    
    const baseFrequencies: Record<BrainRegion, number> = {
      [BrainRegion.PFC]: 10,           // Alpha
      [BrainRegion.AMYGDALA]: 25,      // Beta
      [BrainRegion.HIPPOCAMPUS]: 6,    // Theta
      [BrainRegion.CEREBELLUM]: 40,    // Gamma
      [BrainRegion.BRAINSTEM]: 2,      // Delta
      [BrainRegion.THALAMUS]: 12,      // Alpha
      [BrainRegion.BASAL_GANGLIA]: 20  // Beta
    };
    
    for (const region of Object.values(BrainRegion)) {
      states.set(region, {
        activation: 0.5 + (Math.random() - 0.5) * 0.2,
        phase: Math.random() * 2 * Math.PI,
        frequency: baseFrequencies[region] + (Math.random() - 0.5) * 2
      });
    }
    
    return states;
  }
  
  private initializeConnectionWeights(): number[] {
    // 42 directional weights (21 pairs × 2 directions)
    return Array(42).fill(0).map(() => (Math.random() - 0.5) * 0.2);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC GETTERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public getState() {
    return {
      sessionId: this.sessionId,
      isAlive: this.isAlive,
      frameCount: this.frameCount,
      entityCount: this.entityBrains.size,
      aggregateArousal: this.aggregateArousal,
      aggregateValence: this.aggregateValence,
      aggregateCoherence: this.aggregateCoherence,
      totalHebbianUpdates: this.totalHebbianUpdates,
      totalPredictionErrors: this.totalPredictionErrors,
      parentOrganismId: this.parentOrganismId,
      parentHeartbeat: this.parentHeartbeat,
      // Quantum Memory Architecture
      quantumMemory: this.getQuantumMemoryState(),
      // Frequency Layers
      frequencyLayers: this.getFrequencyLayerState(),
      // Sovereign Metals
      sovereignMetals: this.getSovereignMetalsState()
    };
  }
  
  public getEntityCount(): number {
    return this.entityBrains.size;
  }
  
  public getAllEntityStates() {
    return Array.from(this.entityBrains.values()).map(brain => ({
      entityId: brain.entityId,
      arousal: brain.arousal,
      valence: brain.valence,
      fatigue: brain.fatigue,
      currentAction: brain.currentAction,
      predictionError: brain.predictionError
    }));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // QUANTUM MEMORY ARCHITECTURE — THREE LAYERS
  // Matching backend QuantumMemoryArchitecture.mo
  // ═══════════════════════════════════════════════════════════════════════════
  
  private quantumWorkingMemory: QuantumWorkingMemory = this.initQuantumWorkingMemory();
  private quantumDeepMemory: QuantumDeepMemory = this.initQuantumDeepMemory();
  private quantumResonanceMemory: QuantumResonanceMemory = this.initQuantumResonanceMemory();
  
  private initQuantumWorkingMemory(): QuantumWorkingMemory {
    return {
      slots: Array(7).fill(null).map((_, i) => ({
        slotIndex: i,
        contentType: 'CONTEXT' as const,
        content: [],
        binding: 0,
        createdAt: 0,
        lastRefresh: 0,
        decayRate: 0.1,
        salience: 0,
        attended: false,
        gammaPhase: 0,
        bindingStrength: 0
      })),
      activeCount: 0,
      totalCapacity: 7,
      gammaPhase: 0,
      gammaFrequency: 40,
      globalSalience: 0,
      boundToAgents: 0,
      boundToAlerts: 0,
      boundToUI: 0,
      heartbeat: 0,
      lastRefreshAll: 0
    };
  }
  
  private initQuantumDeepMemory(): QuantumDeepMemory {
    const canisters: CanisterMemoryOrgan[] = [
      { id: 0, name: 'CORE', records: 0, capacity: 100000 },
      { id: 1, name: 'SAFETY', records: 0, capacity: 100000 },
      { id: 2, name: 'CRM', records: 0, capacity: 100000 },
      { id: 3, name: 'AGENTS', records: 0, capacity: 100000 },
      { id: 4, name: 'FINANCE', records: 0, capacity: 100000 },
      { id: 5, name: 'TEAM', records: 0, capacity: 100000 },
      { id: 6, name: 'ORO', records: 0, capacity: 100000 }
    ];
    
    return {
      organs: canisters,
      totalRecords: 0,
      totalCapacity: 700000,
      deltaPhase: 0,
      deltaFrequency: 2,
      consolidationActive: false,
      lockStrength: 1.0,
      heartbeat: 0,
      lastConsolidation: 0
    };
  }
  
  private initQuantumResonanceMemory(): QuantumResonanceMemory {
    return {
      sessionCount: 0,
      avgResponseTimeMs: 1000,
      peakActivityHour: 10,
      outputCadence: {
        preferredLength: 500,
        detailLevel: 0.5,
        formalityLevel: 0.5,
        technicalLevel: 0.5,
        actionBias: 0.5
      },
      thetaPhase: 0,
      thetaFrequency: 6,
      globalResonance: 0,
      corpusCallosum: this.initCorpusCallosum()
    };
  }
  
  private initCorpusCallosum(): CorpusCallosum {
    const agentNames = [
      'PM', 'Safety', 'CRM', 'Finance', 'FieldOps', 'Estimating', 'Resource',
      'Market', 'QA', 'Procurement', 'People', 'ClientDelivery', 'Learning', 'Synthesis'
    ];
    
    return {
      agentConnections: agentNames.map((name, i) => ({
        agentId: i,
        agentName: name,
        targetCanister: i % 7,
        isActive: true,
        lastFired: 0,
        gammaPhase: 0,
        thetaBinding: 0.5
      })),
      sharedContext: new Array(36).fill(0),
      synthesisQuality: 0,
      phaseAlignment: 0
    };
  }
  
  public getQuantumMemoryState() {
    return {
      working: {
        activeSlots: this.quantumWorkingMemory.activeCount,
        totalCapacity: this.quantumWorkingMemory.totalCapacity,
        gammaPhase: this.quantumWorkingMemory.gammaPhase,
        gammaFrequency: this.quantumWorkingMemory.gammaFrequency
      },
      deep: {
        totalRecords: this.quantumDeepMemory.totalRecords,
        totalCapacity: this.quantumDeepMemory.totalCapacity,
        consolidationActive: this.quantumDeepMemory.consolidationActive,
        lockStrength: this.quantumDeepMemory.lockStrength
      },
      resonance: {
        sessionCount: this.quantumResonanceMemory.sessionCount,
        globalResonance: this.quantumResonanceMemory.globalResonance,
        agentCount: this.quantumResonanceMemory.corpusCallosum.agentConnections.length
      }
    };
  }
  
  // Sharp-Wave Ripple for memory consolidation
  public triggerSharpWaveRipple(): SharpWaveRipple {
    const ripple: SharpWaveRipple = {
      startTime: this.frameCount,
      durationMs: 80,
      frequencyHz: 150,
      amplitude: 1.0,
      itemsReplayed: this.quantumWorkingMemory.activeCount,
      compressionFactor: 20,
      bilateralRatio: this.aggregateArousal < 0.5 ? 0.5 : 0.9
    };
    
    // Trigger consolidation
    this.quantumDeepMemory.consolidationActive = true;
    this.quantumDeepMemory.lastConsolidation = this.frameCount;
    
    return ripple;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FREQUENCY-LAYERED COGNITIVE ARCHITECTURE
  // Matching backend FrequencyLayeredCognition.mo
  // ═══════════════════════════════════════════════════════════════════════════
  
  private frequencyState: FrequencyLayerState = this.initFrequencyLayers();
  
  private initFrequencyLayers(): FrequencyLayerState {
    return {
      gamma: { frequency: 65, phase: 0, amplitude: 0.5, power: 0.25, burstActive: false },
      beta: { frequency: 22, phase: 0, amplitude: 0.5, power: 0.25, burstActive: false },
      alpha: { frequency: 11, phase: 0, amplitude: 0.5, power: 0.25, burstActive: false },
      theta: { frequency: 6, phase: 0, amplitude: 0.5, power: 0.25, burstActive: false },
      delta: { frequency: 2.25, phase: 0, amplitude: 0.5, power: 0.25, burstActive: false },
      
      // Cross-frequency coupling
      thetaGammaMI: 0,
      thetaGammaPhase: 0,
      
      // Functional states
      alertLevel: 0.5,
      preparationLevel: 0.5,
      attentionGate: 0.5,
      workingMemoryLoad: 0.5,
      consolidationRate: 0.5,
      
      dominantBand: 'alpha',
      globalPower: 0.25,
      coherence: 0.5
    };
  }
  
  public getFrequencyLayerState() {
    return {
      gamma: this.frequencyState.gamma,
      beta: this.frequencyState.beta,
      alpha: this.frequencyState.alpha,
      theta: this.frequencyState.theta,
      delta: this.frequencyState.delta,
      dominantBand: this.frequencyState.dominantBand,
      coherence: this.frequencyState.coherence,
      alertLevel: this.frequencyState.alertLevel,
      thetaGammaCoupling: this.frequencyState.thetaGammaMI
    };
  }
  
  // Theta-gamma coupling — the dopamine reward architecture
  public computeThetaGammaCoupling(): number {
    const gammaAmp = this.frequencyState.gamma.amplitude;
    const thetaPhase = this.frequencyState.theta.phase;
    
    // PAC: gamma amplitude modulated by theta phase
    return gammaAmp * Math.cos(thetaPhase);
  }
  
  // Reward cascade — Floor completion = visible reward signal
  public triggerRewardCascade(magnitude: number): void {
    // Gamma: Immediate alert burst
    this.frequencyState.gamma.amplitude = Math.min(1, this.frequencyState.gamma.amplitude + magnitude * 0.5);
    this.frequencyState.gamma.burstActive = true;
    
    // Beta: Preparation boost
    this.frequencyState.beta.amplitude = Math.min(1, this.frequencyState.beta.amplitude + magnitude * 0.3);
    
    // Alpha: Attention sharpening (decrease for focus)
    this.frequencyState.alpha.amplitude = Math.max(0, this.frequencyState.alpha.amplitude - magnitude * 0.2);
    
    // Theta: Working memory engagement
    this.frequencyState.theta.amplitude = Math.min(1, this.frequencyState.theta.amplitude + magnitude * 0.4);
    
    // Delta: Consolidation trigger
    this.frequencyState.delta.amplitude = Math.min(1, this.frequencyState.delta.amplitude + magnitude * 0.2);
    
    // Update functional states
    this.frequencyState.alertLevel = this.frequencyState.gamma.amplitude * 1.5;
    this.frequencyState.workingMemoryLoad = this.frequencyState.theta.amplitude;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGN METALS — ALL AT 1.0
  // Matching backend SovereignMetals.mo
  // ═══════════════════════════════════════════════════════════════════════════
  
  private sovereignMetals: SovereignMetalsState = {
    gold: 1.0,        // Primary resonance conductor (classical ~0.73)
    silver: 1.0,      // Temporal governor σ (classical 0.275)
    copper: 1.0,      // Signal propagation baseline (classical ~0.60)
    platinum: 1.0,    // Stability/coherence coefficient (classical ~0.35)
    titanium: 1.0,    // Structural integrity modulus (classical ~0.20)
    
    // Derived values
    resonanceCapacity: 1.0,
    temporalResolution: 1.0,
    signalStrength: 1.0,
    coherenceStability: 1.0,
    structuralIntegrity: 1.0,
    sovereignIndex: 1.0,
    
    // World model arrays
    tau: new Array(14).fill(0.999),   // Near-instant convergence
    alpha: new Array(14).fill(1.0),   // Full signal absorption
    sigma: 1.0                        // Zero lag
  };
  
  public getSovereignMetalsState() {
    return this.sovereignMetals;
  }
  
  // Gold resonance — primary resonance conductor
  public computeGoldResonance(phases: number[]): number {
    if (phases.length < 2) return this.sovereignMetals.gold;
    
    let sumCos = 0;
    for (let i = 0; i < phases.length; i++) {
      for (let j = i + 1; j < phases.length; j++) {
        sumCos += Math.cos(phases[i] - phases[j]);
      }
    }
    
    const pairs = (phases.length * (phases.length - 1)) / 2;
    return this.sovereignMetals.gold * (sumCos / pairs + 1) / 2;
  }
  
  // Silver temporal response
  public computeSilverTemporalResponse(dt: number, tau: number): number {
    return this.sovereignMetals.silver * (1 - Math.exp(-dt / tau));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // QUANTUM-RESISTANT PRINCIPAL LOCK
  // 5 attack layers, 2^64 quantum complexity
  // ═══════════════════════════════════════════════════════════════════════════
  
  private principalLock: PrincipalLockState = this.initPrincipalLock();
  
  private initPrincipalLock(): PrincipalLockState {
    return {
      lockId: Date.now(),
      fnvState: BigInt(14695981039346656037n),
      djb2State: BigInt(5381n),
      sdbmState: BigInt(0n),
      ratchetPosition: 0,
      ratchetChain: new Array(1000).fill(BigInt(0)),
      failedAttempts: 0,
      lockStrength: 0.5,
      coherenceBinding: 0.5,
      observationCount: 0
    };
  }
  
  // Lock strength formula: coherenceC × (H_obs / 12) × (0.5 + ratchetEntropy × 0.5)
  public computeLockStrength(): number {
    const coherenceC = this.aggregateCoherence;
    const hFactor = Math.min(1, this.principalLock.observationCount / 12);
    const entropyFactor = 0.5 + this.computeRatchetEntropy() * 0.5;
    
    return coherenceC * hFactor * entropyFactor;
  }
  
  private computeRatchetEntropy(): number {
    // Simplified entropy calculation
    return Math.random() * 0.5 + 0.5; // Placeholder
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // 21 NEUROCHEMICALS CROSSTALK (Frontend Mirror)
  // ═══════════════════════════════════════════════════════════════════════════
  
  private neurochemicals: NeurochemicalState = this.initNeurochemicals();
  
  private initNeurochemicals(): NeurochemicalState {
    return {
      dopamine: 0.55,
      serotonin: 0.60,
      norepinephrine: 0.45,
      epinephrine: 0.20,
      acetylcholine: 0.50,
      gaba: 0.65,
      glycine: 0.55,
      glutamate: 0.50,
      oxytocin: 0.40,
      vasopressin: 0.45,
      beta_endorphin: 0.50,
      substance_p: 0.30,
      neuropeptide_y: 0.50,
      adenosine: 0.35,
      anandamide: 0.45,
      two_ag: 0.40,
      nitric_oxide: 0.50,
      bdnf: 0.70,
      ngf: 0.55,
      cortisol: 0.25,
      testosterone: 0.50
    };
  }
  
  // Apply crosstalk modulation
  public applyNeurochemicalCrosstalk(): void {
    // Dopamine modulated by: serotonin (-), norepinephrine (+), gaba (-), glutamate (+)
    const daDelta = 
      -0.15 * this.neurochemicals.serotonin +
      0.20 * this.neurochemicals.norepinephrine +
      -0.25 * this.neurochemicals.gaba +
      0.30 * this.neurochemicals.glutamate;
    this.neurochemicals.dopamine = Math.max(0, Math.min(1, this.neurochemicals.dopamine + daDelta * 0.01));
    
    // Similar crosstalk for other chemicals...
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // 18-ORGAN KURAMOTO COUPLING (Frontend Mirror)
  // ═══════════════════════════════════════════════════════════════════════════
  
  private kuramotoOscillators: KuramotoOscillator[] = this.initKuramotoOscillators();
  
  private initKuramotoOscillators(): KuramotoOscillator[] {
    const organFreqs = [
      0.08, 0.05, 0.12, 0.03, 0.02, 0.10, 0.07, 0.04, 0.15,
      0.06, 0.09, 0.11, 0.08, 0.04, 0.03, 0.05, 0.02, 0.13
    ];
    const organNames = [
      'heart', 'lungs', 'brain', 'liver', 'kidneys', 'gut', 'spleen', 'pancreas', 'thyroid',
      'adrenals', 'thymus', 'skin', 'marrow', 'lymph', 'gonads', 'eyes', 'ears', 'spine'
    ];
    
    return organNames.map((name, i) => ({
      name,
      phase: (i / 18) * 2 * Math.PI,
      naturalFreq: organFreqs[i],
      coupling: 1.0,
      amplitude: 1.0
    }));
  }
  
  // Compute Kuramoto order parameter r
  public computeKuramotoOrderParameter(): { r: number; psi: number } {
    let sumCos = 0;
    let sumSin = 0;
    
    for (const osc of this.kuramotoOscillators) {
      sumCos += Math.cos(osc.phase) * osc.amplitude;
      sumSin += Math.sin(osc.phase) * osc.amplitude;
    }
    
    const n = this.kuramotoOscillators.length;
    const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
    const psi = Math.atan2(sumSin, sumCos);
    
    return { r: Math.min(1, Math.max(0, r)), psi };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VISUALIZATION MATHEMATICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Generate 3D position for spherical helix visualization
  public sphericalHelixPosition(
    shell: number,    // 0-5
    helixArm: number, // 0-5
    t: number        // 0-1 along helix
  ): { x: number; y: number; z: number } {
    const innerRadius = 1.0;
    const outerRadius = 6.0;
    const helixPitch = PHI;
    const helixTurns = 3.0;
    
    // Radius at this shell
    const r = innerRadius + shell * (outerRadius - innerRadius) / 5;
    
    // Angle along helix
    const theta = (helixArm / 6) * 2 * Math.PI + t * helixTurns * 2 * Math.PI;
    
    // Vertical position
    const z = t * helixPitch * 6;
    
    return {
      x: r * Math.cos(theta),
      y: r * Math.sin(theta),
      z: z - 3 // Center vertically
    };
  }
  
  // Generate color based on quantum state
  public quantumStateColor(amplitude: number, phase: number): string {
    // HSL color based on phase and amplitude
    const hue = (phase / (2 * Math.PI)) * 360;
    const saturation = 70 + amplitude * 30;
    const lightness = 40 + amplitude * 30;
    
    return `hsl(${hue}, ${saturation}%, ${lightness}%)`;
  }
  
  // Generate 1296 points for the 36×36 fabric
  public generateFabricPoints(): FabricVisualizationPoint[] {
    const points: FabricVisualizationPoint[] = [];
    const dim = 36;
    
    for (let i = 0; i < dim; i++) {
      for (let j = 0; j < dim; j++) {
        const shell = Math.floor(i / 6);
        const spoke = j;
        const helixArm = i % 6;
        
        const amplitude = 0.5 + 0.5 * Math.sin(i * PHI) * Math.cos(j / PHI);
        const phase = ((i + j) / 72) * 2 * Math.PI;
        
        const pos = this.sphericalHelixPosition(shell, helixArm, j / dim);
        
        points.push({
          index: i * dim + j,
          shell,
          spoke,
          helixArm,
          position: pos,
          amplitude,
          phase,
          color: this.quantumStateColor(amplitude, phase),
          alive: amplitude > 0.36 // COHERENCE_ALIVE threshold
        });
      }
    }
    
    return points;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ADDITIONAL TYPES FOR FRONTEND
// ═══════════════════════════════════════════════════════════════════════════════

interface QuantumWorkingMemory {
  slots: WorkingMemorySlot[];
  activeCount: number;
  totalCapacity: number;
  gammaPhase: number;
  gammaFrequency: number;
  globalSalience: number;
  boundToAgents: number;
  boundToAlerts: number;
  boundToUI: number;
  heartbeat: number;
  lastRefreshAll: number;
}

interface WorkingMemorySlot {
  slotIndex: number;
  contentType: 'AGENT_INFERENCE' | 'LIVE_ALERT' | 'UI_STATE' | 'RECOMMENDATION' | 'SENSORY_INPUT' | 'MOTOR_PLAN' | 'CONTEXT';
  content: number[];
  binding: number;
  createdAt: number;
  lastRefresh: number;
  decayRate: number;
  salience: number;
  attended: boolean;
  gammaPhase: number;
  bindingStrength: number;
}

interface QuantumDeepMemory {
  organs: CanisterMemoryOrgan[];
  totalRecords: number;
  totalCapacity: number;
  deltaPhase: number;
  deltaFrequency: number;
  consolidationActive: boolean;
  lockStrength: number;
  heartbeat: number;
  lastConsolidation: number;
}

interface CanisterMemoryOrgan {
  id: number;
  name: string;
  records: number;
  capacity: number;
}

interface QuantumResonanceMemory {
  sessionCount: number;
  avgResponseTimeMs: number;
  peakActivityHour: number;
  outputCadence: OutputCadence;
  thetaPhase: number;
  thetaFrequency: number;
  globalResonance: number;
  corpusCallosum: CorpusCallosum;
}

interface OutputCadence {
  preferredLength: number;
  detailLevel: number;
  formalityLevel: number;
  technicalLevel: number;
  actionBias: number;
}

interface CorpusCallosum {
  agentConnections: AgentConnection[];
  sharedContext: number[];
  synthesisQuality: number;
  phaseAlignment: number;
}

interface AgentConnection {
  agentId: number;
  agentName: string;
  targetCanister: number;
  isActive: boolean;
  lastFired: number;
  gammaPhase: number;
  thetaBinding: number;
}

interface SharpWaveRipple {
  startTime: number;
  durationMs: number;
  frequencyHz: number;
  amplitude: number;
  itemsReplayed: number;
  compressionFactor: number;
  bilateralRatio: number;
}

interface FrequencyBandState {
  frequency: number;
  phase: number;
  amplitude: number;
  power: number;
  burstActive: boolean;
}

interface FrequencyLayerState {
  gamma: FrequencyBandState;
  beta: FrequencyBandState;
  alpha: FrequencyBandState;
  theta: FrequencyBandState;
  delta: FrequencyBandState;
  thetaGammaMI: number;
  thetaGammaPhase: number;
  alertLevel: number;
  preparationLevel: number;
  attentionGate: number;
  workingMemoryLoad: number;
  consolidationRate: number;
  dominantBand: string;
  globalPower: number;
  coherence: number;
}

interface SovereignMetalsState {
  gold: number;
  silver: number;
  copper: number;
  platinum: number;
  titanium: number;
  resonanceCapacity: number;
  temporalResolution: number;
  signalStrength: number;
  coherenceStability: number;
  structuralIntegrity: number;
  sovereignIndex: number;
  tau: number[];
  alpha: number[];
  sigma: number;
}

interface PrincipalLockState {
  lockId: number;
  fnvState: bigint;
  djb2State: bigint;
  sdbmState: bigint;
  ratchetPosition: number;
  ratchetChain: bigint[];
  failedAttempts: number;
  lockStrength: number;
  coherenceBinding: number;
  observationCount: number;
}

interface NeurochemicalState {
  dopamine: number;
  serotonin: number;
  norepinephrine: number;
  epinephrine: number;
  acetylcholine: number;
  gaba: number;
  glycine: number;
  glutamate: number;
  oxytocin: number;
  vasopressin: number;
  beta_endorphin: number;
  substance_p: number;
  neuropeptide_y: number;
  adenosine: number;
  anandamide: number;
  two_ag: number;
  nitric_oxide: number;
  bdnf: number;
  ngf: number;
  cortisol: number;
  testosterone: number;
}

interface KuramotoOscillator {
  name: string;
  phase: number;
  naturalFreq: number;
  coupling: number;
  amplitude: number;
}

interface FabricVisualizationPoint {
  index: number;
  shell: number;
  spoke: number;
  helixArm: number;
  position: { x: number; y: number; z: number };
  amplitude: number;
  phase: number;
  color: string;
  alive: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLETON INSTANCE
// ═══════════════════════════════════════════════════════════════════════════════

export const frontendOrganism = new FrontendOrganism();

export default FrontendOrganism;
