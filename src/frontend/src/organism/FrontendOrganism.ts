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
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const FRONTEND_HZ = 60;                    // 60 frames per second
export const BACKEND_HZ = 1.5;                    // Backend heartbeat
export const SPEED_RATIO = FRONTEND_HZ / BACKEND_HZ;  // ~40x faster
export const SYNC_INTERVAL_MS = 5000;             // Sync every 5 seconds
export const HEBBIAN_LEARNING_RATE = 0.01;        // η = 0.01
export const HEBBIAN_DECAY = 0.001;               // Weight decay
export const MEMORY_TRACE_SIZE = 15;              // Ring buffer size
export const PHI = 1.6180339887498948482;         // Golden ratio
export const PHI_MEDINA = 2.97442179;             // Medina constant

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
      parentHeartbeat: this.parentHeartbeat
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
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLETON INSTANCE
// ═══════════════════════════════════════════════════════════════════════════════

export const frontendOrganism = new FrontendOrganism();

export default FrontendOrganism;
