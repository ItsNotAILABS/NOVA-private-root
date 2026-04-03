// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: EnemyOrganismCommander — SMART Enemy with Full IRONCLAD Architecture
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                    ENEMY ORGANISM COMMANDER — TRUE COGNITIVE ADVERSARY                                    ║
// ╠══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                                          ║
// ║  The enemies aren't just scripts — they're ORGANISMS using the SAME architecture.                        ║
// ║                                                                                                          ║
// ║  Each enemy commander:                                                                                   ║
// ║    • Has a brain substrate (same as NOVA)                                                               ║
// ║    • Has a visual cortex (sees through their drones)                                                    ║
// ║    • Has cognitive abilities (learning, adaptation, decision-making)                                     ║
// ║    • Commands their swarm through the SAME Kuramoto/Hebbian mechanisms                                  ║
// ║                                                                                                          ║
// ║  This creates TRUE competition — organism vs organism.                                                   ║
// ║  NOVA must evolve or be destroyed.                                                                       ║
// ║                                                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { DroneMind, SwarmCoordinator } from './drone-mind';
import type { DroneState, DroneClass } from '../types/organism';
import { OrganismVisualCortex, type VisualField, type ThreatRegion, type PerceivedObject } from './OrganismVisualCortex';
import { RealSpecDroneFleet, createRealSpecDrone, type RealSpecDroneState } from './RealSpecDrone';
import type { CompetitorDoctrine, CompetitorLevel, CompetitorFaction } from './CompetitorSwarmSystem';

// ═══════════════════════════════════════════════════════════════════════════════
// COMMANDER COGNITIVE STATE — The Enemy's "Brain"
// ═══════════════════════════════════════════════════════════════════════════════

export interface CommanderCognitiveState {
  // Identity
  id: string;
  name: string;
  level: CompetitorLevel;
  
  // Kuramoto oscillator state (same as NOVA)
  phase: number;
  omega: number;         // Natural frequency
  coherence: number;     // Internal coherence
  
  // Neurochemical state (same as NOVA drones)
  dopamine: number;      // Reward/motivation
  cortisol: number;      // Stress/threat
  norepinephrine: number; // Arousal/alertness
  oxytocin: number;      // Social bonding with swarm
  
  // Energy and health
  energy: number;
  health: number;
  morale: number;
  
  // 6-node micro-brain (same architecture as drone minds)
  brainWeights: number[];      // 36 Hebbian weights
  brainActivation: number[];   // [SENSOR, MEMORY, EXECUTIVE, EMOTIONAL, MOTOR, OUTPUT]
  
  // Quantum channels
  qAlpha: number;        // Spatial/sensor
  qBeta: number;         // Temporal/memory
  qGamma: number;        // Relational
  qDelta: number;        // Executive-motor
  qCoherence: number;    // Overall quantum coherence
  
  // Memory
  shortTermMemory: MemoryItem[];
  longTermMemory: MemoryItem[];
  workingMemoryCapacity: number;
  
  // Learning state
  hebbianLearningRate: number;
  adaptationSpeed: number;
  patternRecognition: PatternLibrary;
  
  // Emotional state (affects decisions)
  fear: number;          // Retreat tendency
  aggression: number;    // Attack tendency
  confidence: number;    // Risk tolerance
  frustration: number;   // Increases with failures
}

export interface MemoryItem {
  id: string;
  type: 'Event' | 'Pattern' | 'Tactic' | 'Outcome';
  content: string;
  timestamp: number;
  importance: number;
  emotionalValence: number;  // -1 (negative) to +1 (positive)
  decayRate: number;
  strength: number;
}

export interface PatternLibrary {
  // Recognized enemy (NOVA) patterns
  novaFormations: RecognizedPattern[];
  novaTactics: RecognizedPattern[];
  novaWeaknesses: RecognizedPattern[];
  
  // Successful own tactics
  successfulTactics: RecognizedPattern[];
  failedTactics: RecognizedPattern[];
}

export interface RecognizedPattern {
  name: string;
  description: string;
  frequency: number;
  confidence: number;
  lastSeen: number;
  counter?: string;
  outcome?: 'Success' | 'Failure' | 'Neutral';
}

// ═══════════════════════════════════════════════════════════════════════════════
// ENEMY ORGANISM COMMANDER — The SMART Enemy
// ═══════════════════════════════════════════════════════════════════════════════

export class EnemyOrganismCommander {
  // Identity
  public readonly id: string;
  public readonly faction: CompetitorFaction;
  public readonly level: CompetitorLevel;
  public readonly doctrine: CompetitorDoctrine;
  
  // Cognitive state
  private cognitiveState: CommanderCognitiveState;
  
  // Visual system — sees through drone cameras
  private visualCortex: OrganismVisualCortex;
  private currentVisualField: VisualField | null = null;
  
  // The swarm this commander controls
  private fleet: RealSpecDroneFleet;
  private swarmCoordinator: SwarmCoordinator;
  
  // Combat state
  private currentObjective: CombatObjective | null = null;
  private tacticalPlan: TacticalPlan | null = null;
  private beatCount: number = 0;
  
  // Learning and adaptation
  private combatHistory: CombatEvent[] = [];
  private adaptationCooldown: number = 0;
  
  constructor(
    id: string,
    faction: CompetitorFaction,
    level: CompetitorLevel,
    doctrine: CompetitorDoctrine,
    droneCount: number,
    startPosition: { x: number; y: number; z: number }
  ) {
    this.id = id;
    this.faction = faction;
    this.level = level;
    this.doctrine = doctrine;
    
    // Initialize cognitive state based on level
    this.cognitiveState = this.initializeCognition(level);
    
    // Initialize fleet
    this.fleet = new RealSpecDroneFleet(id);
    
    // Spawn drones based on level (higher levels get better drones)
    this.spawnDrones(droneCount, startPosition);
    
    // Initialize visual cortex
    this.visualCortex = new OrganismVisualCortex(id, this.fleet);
    
    // Initialize swarm coordinator with same drone count
    this.swarmCoordinator = new SwarmCoordinator(droneCount);
  }
  
  /**
   * Initialize cognitive state based on difficulty level
   */
  private initializeCognition(level: CompetitorLevel): CommanderCognitiveState {
    // Base values scaled by level
    const levelMultipliers: Record<CompetitorLevel, number> = {
      'RECRUIT': 0.3,
      'MILITIA': 0.5,
      'REGULAR': 0.7,
      'VETERAN': 0.85,
      'ELITE': 1.0,
      'APEX': 1.2,
      'NEMESIS': 1.5
    };
    
    const mult = levelMultipliers[level];
    
    // Initialize 6-node brain weights (36 total)
    const brainWeights = Array(36).fill(0).map(() => 0.5 + Math.random() * 0.5);
    
    return {
      id: this.id,
      name: `Commander_${this.faction}_${level}`,
      level,
      
      // Kuramoto
      phase: Math.random() * Math.PI * 2,
      omega: 0.8 + Math.random() * 0.4,
      coherence: 0.5 * mult,
      
      // Neurochemistry
      dopamine: 1.0,
      cortisol: 1.0,
      norepinephrine: 1.0,
      oxytocin: 1.0,
      
      // Resources
      energy: 1.5,
      health: 1.0,
      morale: 1.0,
      
      // Brain
      brainWeights,
      brainActivation: [0.5, 0.5, 0.5, 0.5, 0.5, 0.5],
      
      // Quantum channels
      qAlpha: 0.5,
      qBeta: 0.5,
      qGamma: 0.5,
      qDelta: 0.5,
      qCoherence: 0.5 * mult,
      
      // Memory (higher levels = better memory)
      shortTermMemory: [],
      longTermMemory: [],
      workingMemoryCapacity: Math.floor(5 + mult * 4),  // 5-9 items
      
      // Learning
      hebbianLearningRate: 0.01 * mult,
      adaptationSpeed: 0.1 * mult,
      patternRecognition: {
        novaFormations: [],
        novaTactics: [],
        novaWeaknesses: [],
        successfulTactics: [],
        failedTactics: []
      },
      
      // Emotions
      fear: 0.2,
      aggression: 0.5 * mult,
      confidence: 0.5 * mult,
      frustration: 0
    };
  }
  
  /**
   * Spawn drones for this commander's swarm
   */
  private spawnDrones(count: number, center: { x: number; y: number; z: number }): void {
    // Higher level commanders get better drone mix
    const droneTypes = this.getDroneTypesForLevel(this.level);
    
    for (let i = 0; i < count; i++) {
      const angle = (i / count) * Math.PI * 2;
      const radius = 20 + Math.random() * 30;
      const position = {
        x: center.x + Math.cos(angle) * radius,
        y: center.y + Math.random() * 20,
        z: center.z + Math.sin(angle) * radius
      };
      
      // Assign drone type based on index
      const typeIndex = i % droneTypes.length;
      const droneType = droneTypes[typeIndex];
      
      this.fleet.spawnDrone(droneType as any, position);
    }
  }
  
  /**
   * Get appropriate drone types for this level
   */
  private getDroneTypesForLevel(level: CompetitorLevel): string[] {
    switch (level) {
      case 'RECRUIT':
      case 'MILITIA':
        return ['SCOUT_MINI', 'SCOUT_MINI', 'STRIKER_FALCON'];
      case 'REGULAR':
        return ['SCOUT_MINI', 'STRIKER_FALCON', 'STRIKER_FALCON', 'RELAY_SPECTRE'];
      case 'VETERAN':
        return ['STRIKER_FALCON', 'STRIKER_FALCON', 'GUARDIAN_TITAN', 'RELAY_SPECTRE', 'MEDIC_ANGEL'];
      case 'ELITE':
      case 'APEX':
      case 'NEMESIS':
        return ['STRIKER_FALCON', 'GUARDIAN_TITAN', 'GUARDIAN_TITAN', 'RELAY_SPECTRE', 'MEDIC_ANGEL'];
      default:
        return ['SCOUT_MINI', 'STRIKER_FALCON'];
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN COGNITIVE LOOP — The commander "thinks"
  // ═══════════════════════════════════════════════════════════════════════════
  
  /**
   * Main update loop — the commander's cognitive cycle
   */
  tick(
    novaPosition: { x: number; y: number; z: number },
    novaCoherence: number,
    novaDrones: DroneState[]
  ): CommanderTickResult {
    this.beatCount++;
    
    // 1. PERCEPTION — See through drone cameras
    this.currentVisualField = this.visualCortex.process(this.beatCount);
    
    // 2. NEUROCHEMISTRY — Update emotional state based on situation
    this.updateNeurochemistry(novaCoherence, novaDrones);
    
    // 3. MEMORY — Process and store relevant information
    this.processMemory(novaDrones);
    
    // 4. PATTERN RECOGNITION — Identify NOVA's patterns (if capable)
    if (this.cognitiveState.level !== 'RECRUIT' && this.cognitiveState.level !== 'MILITIA') {
      this.recognizePatterns(novaDrones, novaCoherence);
    }
    
    // 5. BRAIN FORWARD PASS — Compute decision
    this.brainForwardPass();
    
    // 6. DECISION MAKING — Choose objective and tactics
    this.makeDecision(novaPosition, novaCoherence, novaDrones);
    
    // 7. COMMAND SWARM — Issue orders to drones
    this.commandSwarm(novaPosition, novaDrones);
    
    // 8. LEARNING — Update Hebbian weights based on outcomes
    this.hebbianLearning();
    
    // 9. UPDATE SWARM — Tick all drone minds
    this.fleet.tickMinds(this.beatCount, this.cognitiveState.coherence);
    
    // Return status for external monitoring
    return {
      commanderId: this.id,
      beat: this.beatCount,
      coherence: this.cognitiveState.coherence,
      morale: this.cognitiveState.morale,
      health: this.cognitiveState.health,
      currentObjective: this.currentObjective?.type || 'None',
      activeDrones: this.fleet.getAllDrones().length,
      emotionalState: {
        fear: this.cognitiveState.fear,
        aggression: this.cognitiveState.aggression,
        confidence: this.cognitiveState.confidence,
        frustration: this.cognitiveState.frustration
      }
    };
  }
  
  /**
   * Update neurochemistry based on situation
   */
  private updateNeurochemistry(novaCoherence: number, novaDrones: DroneState[]): void {
    const state = this.cognitiveState;
    const threats = this.currentVisualField?.threatMap || [];
    const myDrones = this.fleet.getAllDrones();
    const activeMine = myDrones.length;
    const activeEnemy = novaDrones.filter(d => !d.sacrificed).length;
    
    // Cortisol (stress) increases with threats and when outnumbered
    const threatLevel = threats.length > 0 ? 
      Math.max(...threats.map(t => t.threatLevel)) : 0;
    const outnumberedRatio = activeEnemy / Math.max(1, activeMine);
    state.cortisol = Math.min(2, state.cortisol * 0.95 + 
      (threatLevel * 0.3 + outnumberedRatio * 0.2));
    
    // Norepinephrine (arousal) increases in combat
    const inCombat = this.currentObjective?.type === 'Attack' || threats.length > 0;
    state.norepinephrine = Math.min(2, state.norepinephrine * 0.95 + 
      (inCombat ? 0.2 : 0.05));
    
    // Dopamine (reward) increases with success, decreases with failure
    const recentSuccess = this.combatHistory.slice(-10)
      .filter(e => e.outcome === 'Success').length;
    state.dopamine = Math.min(2, state.dopamine * 0.98 + 
      recentSuccess * 0.05);
    
    // Oxytocin (cohesion) tracks swarm coherence
    state.oxytocin = Math.min(2, state.oxytocin * 0.95 + 
      state.coherence * 0.1);
    
    // Update emotions from neurochemistry
    state.fear = Math.min(1, state.cortisol * 0.3 - state.dopamine * 0.1);
    state.aggression = Math.min(1, state.norepinephrine * 0.4 + 
      state.dopamine * 0.2 - state.fear * 0.2);
    state.confidence = Math.min(1, state.dopamine * 0.3 + 
      state.coherence * 0.3 - state.cortisol * 0.2);
    state.frustration = Math.min(1, state.frustration * 0.95 + 
      (1 - state.dopamine) * 0.05);
    
    // Morale is a combination
    state.morale = Math.max(0, Math.min(1,
      state.confidence * 0.4 + 
      state.oxytocin * 0.3 - 
      state.fear * 0.3 - 
      state.frustration * 0.2
    ));
  }
  
  /**
   * Process and store memories
   */
  private processMemory(novaDrones: DroneState[]): void {
    const state = this.cognitiveState;
    const now = this.beatCount;
    
    // Decay short-term memories
    state.shortTermMemory = state.shortTermMemory
      .map(m => ({ ...m, strength: m.strength * (1 - m.decayRate) }))
      .filter(m => m.strength > 0.1);
    
    // Transfer important short-term to long-term
    const important = state.shortTermMemory
      .filter(m => m.importance > 0.7 && m.strength > 0.5);
    for (const mem of important) {
      if (!state.longTermMemory.find(m => m.id === mem.id)) {
        state.longTermMemory.push({ ...mem, decayRate: 0.001 });
      }
    }
    
    // Limit short-term memory size
    while (state.shortTermMemory.length > state.workingMemoryCapacity) {
      // Remove least important
      state.shortTermMemory.sort((a, b) => a.importance - b.importance);
      state.shortTermMemory.shift();
    }
    
    // Store current situation as memory
    const activeMine = this.fleet.getAllDrones().length;
    const activeEnemy = novaDrones.filter(d => !d.sacrificed).length;
    
    state.shortTermMemory.push({
      id: `situation_${now}`,
      type: 'Event',
      content: `Beat ${now}: ${activeMine} drones vs ${activeEnemy} enemy. Coherence: ${state.coherence.toFixed(2)}`,
      timestamp: now,
      importance: 0.3,
      emotionalValence: state.morale > 0.5 ? 0.2 : -0.2,
      decayRate: 0.05,
      strength: 1.0
    });
  }
  
  /**
   * Recognize patterns in NOVA's behavior
   */
  private recognizePatterns(novaDrones: DroneState[], novaCoherence: number): void {
    const state = this.cognitiveState;
    const patterns = state.patternRecognition;
    const activeNova = novaDrones.filter(d => !d.sacrificed);
    
    if (activeNova.length < 3) return;
    
    // Calculate NOVA's formation spread
    const novaCenter = {
      x: activeNova.reduce((s, d) => s + d.posX, 0) / activeNova.length,
      y: activeNova.reduce((s, d) => s + d.posY, 0) / activeNova.length,
      z: activeNova.reduce((s, d) => s + d.posZ, 0) / activeNova.length
    };
    
    const spread = activeNova.reduce((s, d) => {
      const dist = Math.sqrt(
        (d.posX - novaCenter.x)**2 + 
        (d.posY - novaCenter.y)**2 + 
        (d.posZ - novaCenter.z)**2
      );
      return s + dist;
    }, 0) / activeNova.length;
    
    // Recognize formation patterns
    if (spread < 20 && novaCoherence > 0.8) {
      this.recordPattern(patterns.novaFormations, {
        name: 'Tight High-Coherence',
        description: 'NOVA is tightly grouped with high coherence',
        frequency: 1,
        confidence: 0.8,
        lastSeen: this.beatCount,
        counter: 'Area saturation attack or coherence disruption'
      });
    } else if (spread > 50 && novaCoherence < 0.6) {
      this.recordPattern(patterns.novaFormations, {
        name: 'Spread Low-Coherence',
        description: 'NOVA is spread out with low coherence',
        frequency: 1,
        confidence: 0.8,
        lastSeen: this.beatCount,
        counter: 'Isolate and destroy piecemeal'
      });
    }
    
    // Recognize movement patterns (approach vs retreat)
    const myCenter = this.getSwarmCenter();
    const distanceToMe = Math.sqrt(
      (novaCenter.x - myCenter.x)**2 + 
      (novaCenter.z - myCenter.z)**2
    );
    
    if (distanceToMe < 100 && this.combatHistory.length > 0) {
      const lastDist = this.combatHistory[this.combatHistory.length - 1]?.distance || distanceToMe;
      if (distanceToMe < lastDist - 10) {
        this.recordPattern(patterns.novaTactics, {
          name: 'Aggressive Approach',
          description: 'NOVA is closing distance aggressively',
          frequency: 1,
          confidence: 0.7,
          lastSeen: this.beatCount,
          counter: 'Prepare ambush or tactical retreat'
        });
      }
    }
    
    // Record combat event
    this.combatHistory.push({
      beat: this.beatCount,
      distance: distanceToMe,
      myDrones: this.fleet.getAllDrones().length,
      enemyDrones: activeNova.length,
      novaCoherence,
      myCoherence: state.coherence,
      outcome: 'Neutral'
    });
    
    // Limit history
    if (this.combatHistory.length > 100) {
      this.combatHistory.shift();
    }
  }
  
  /**
   * Record or update a recognized pattern
   */
  private recordPattern(library: RecognizedPattern[], pattern: RecognizedPattern): void {
    const existing = library.find(p => p.name === pattern.name);
    if (existing) {
      existing.frequency++;
      existing.confidence = Math.min(1, existing.confidence + 0.05);
      existing.lastSeen = pattern.lastSeen;
    } else {
      library.push(pattern);
    }
    
    // Limit library size
    if (library.length > 20) {
      library.sort((a, b) => b.frequency - a.frequency);
      library.pop();
    }
  }
  
  /**
   * Brain forward pass — 6-node neural network
   */
  private brainForwardPass(): void {
    const state = this.cognitiveState;
    const visual = this.currentVisualField;
    
    // Input to SENSOR node
    const threatInput = visual?.threatMap.length || 0;
    const objectInput = visual?.perceivedObjects.length || 0;
    state.brainActivation[0] = Math.tanh(
      threatInput * 0.2 + objectInput * 0.1 + state.norepinephrine * 0.3
    );
    
    // Input to MEMORY node
    const memoryLoad = state.shortTermMemory.length / state.workingMemoryCapacity;
    state.brainActivation[1] = Math.tanh(
      memoryLoad * 0.5 + state.qBeta * 0.3
    );
    
    // Input to EMOTIONAL node
    state.brainActivation[3] = Math.tanh(
      state.fear * 0.3 + state.aggression * 0.3 + 
      state.confidence * 0.2 - state.frustration * 0.2
    );
    
    // Forward pass through weights
    for (let i = 0; i < 6; i++) {
      let sum = 0;
      for (let j = 0; j < 6; j++) {
        sum += state.brainActivation[j] * state.brainWeights[i * 6 + j];
      }
      // Mix new activation with old (momentum)
      state.brainActivation[i] = state.brainActivation[i] * 0.3 + Math.tanh(sum) * 0.7;
    }
    
    // Update quantum coherence based on brain activity
    const avgActivation = state.brainActivation.reduce((a, b) => a + Math.abs(b), 0) / 6;
    state.qCoherence = state.qCoherence * 0.9 + avgActivation * 0.1;
    
    // Overall coherence
    state.coherence = state.coherence * 0.95 + 
      (state.qCoherence * 0.5 + state.morale * 0.5) * 0.05;
  }
  
  /**
   * Make tactical decisions based on cognitive state
   */
  private makeDecision(
    novaPosition: { x: number; y: number; z: number },
    novaCoherence: number,
    novaDrones: DroneState[]
  ): void {
    const state = this.cognitiveState;
    const myCenter = this.getSwarmCenter();
    const distanceToNova = Math.sqrt(
      (myCenter.x - novaPosition.x)**2 + 
      (myCenter.z - novaPosition.z)**2
    );
    
    const myStrength = this.fleet.getAllDrones().length * state.coherence * state.morale;
    const novaStrength = novaDrones.filter(d => !d.sacrificed).length * novaCoherence;
    const strengthRatio = myStrength / Math.max(1, novaStrength);
    
    // Get brain outputs for decision
    const executiveOutput = state.brainActivation[2];  // EXECUTIVE node
    const motorOutput = state.brainActivation[4];       // MOTOR node
    const outputNode = state.brainActivation[5];        // OUTPUT node
    
    // Decision based on combination of factors
    let objectiveType: CombatObjective['type'] = 'Patrol';
    
    // Check for morale collapse
    if (state.morale < 0.2 || state.fear > 0.8) {
      objectiveType = 'Retreat';
    }
    // Check for need to regroup
    else if (state.coherence < 0.4) {
      objectiveType = 'Regroup';
    }
    // Attack decision
    else if (
      strengthRatio > 1.2 && 
      state.aggression > 0.5 && 
      state.confidence > 0.4 &&
      executiveOutput > 0.3 &&
      distanceToNova < 200
    ) {
      objectiveType = 'Attack';
    }
    // Defend if threatened
    else if (distanceToNova < 100 && (this.currentVisualField?.threatMap.length || 0) > 0) {
      objectiveType = 'Defend';
    }
    // Aggressive patrol if confident
    else if (state.confidence > 0.6 && motorOutput > 0.2) {
      objectiveType = 'Hunt';
    }
    
    // Apply doctrine modifiers
    if (this.doctrine.aggression > 0.7 && objectiveType === 'Patrol') {
      objectiveType = 'Hunt';
    }
    if (this.doctrine.aggression < 0.3 && objectiveType === 'Attack') {
      objectiveType = 'Defend';
    }
    
    // Check for counter-tactics from pattern recognition
    const counterTactic = this.getCounterTactic();
    if (counterTactic && state.confidence > 0.5) {
      // Adjust objective based on learned counter
      if (counterTactic.includes('retreat') && objectiveType === 'Attack') {
        objectiveType = 'Flank';
      } else if (counterTactic.includes('saturation') && objectiveType === 'Defend') {
        objectiveType = 'Scatter';
      }
    }
    
    this.currentObjective = {
      type: objectiveType,
      target: novaPosition,
      priority: state.aggression * 0.5 + (1 - state.fear) * 0.5,
      startBeat: this.beatCount
    };
  }
  
  /**
   * Get counter-tactic from pattern library
   */
  private getCounterTactic(): string | null {
    const patterns = this.cognitiveState.patternRecognition;
    
    // Find most confident recent pattern
    const allPatterns = [
      ...patterns.novaFormations,
      ...patterns.novaTactics
    ].filter(p => p.lastSeen > this.beatCount - 50);
    
    if (allPatterns.length === 0) return null;
    
    allPatterns.sort((a, b) => b.confidence - a.confidence);
    return allPatterns[0].counter || null;
  }
  
  /**
   * Issue commands to the swarm
   */
  private commandSwarm(
    novaPosition: { x: number; y: number; z: number },
    novaDrones: DroneState[]
  ): void {
    if (!this.currentObjective) return;
    
    const drones = this.fleet.getAllDrones();
    const center = this.getSwarmCenter();
    
    switch (this.currentObjective.type) {
      case 'Attack':
        this.executeAttack(drones, novaPosition, novaDrones);
        break;
      case 'Defend':
        this.executeDefend(drones, novaPosition);
        break;
      case 'Retreat':
        this.executeRetreat(drones, novaPosition);
        break;
      case 'Regroup':
        this.executeRegroup(drones, center);
        break;
      case 'Hunt':
        this.executeHunt(drones, novaPosition);
        break;
      case 'Flank':
        this.executeFlank(drones, novaPosition);
        break;
      case 'Scatter':
        this.executeScatter(drones);
        break;
      case 'Patrol':
      default:
        this.executePatrol(drones, center);
        break;
    }
  }
  
  private executeAttack(
    drones: RealSpecDroneState[],
    target: { x: number; y: number; z: number },
    novaDrones: DroneState[]
  ): void {
    // Find priority target
    let attackTarget = target;
    if (this.doctrine.attackPatterns[0]?.execution.focusFire && novaDrones.length > 0) {
      const activeNova = novaDrones.filter(d => !d.sacrificed);
      if (activeNova.length > 0) {
        // Target weakest
        const weakest = activeNova.reduce((min, d) => d.energy < min.energy ? d : min);
        attackTarget = { x: weakest.posX, y: weakest.posY, z: weakest.posZ };
      }
    }
    
    const speed = 1.5 + this.cognitiveState.aggression * 0.5;
    
    for (const drone of drones) {
      const dx = attackTarget.x - drone.position.x;
      const dy = attackTarget.y - drone.position.y;
      const dz = attackTarget.z - drone.position.z;
      const dist = Math.sqrt(dx*dx + dy*dy + dz*dz);
      
      if (dist > 1) {
        drone.velocity.x = (dx / dist) * speed;
        drone.velocity.z = (dz / dist) * speed;
        drone.position.x += drone.velocity.x;
        drone.position.y += (dy / dist) * speed * 0.5;
        drone.position.z += drone.velocity.z;
      }
    }
  }
  
  private executeDefend(
    drones: RealSpecDroneState[],
    threatDirection: { x: number; y: number; z: number }
  ): void {
    const center = this.getSwarmCenter();
    const radius = 25;
    
    for (let i = 0; i < drones.length; i++) {
      const drone = drones[i];
      const angle = (i / drones.length) * Math.PI * 2;
      
      // Form defensive sphere
      const targetX = center.x + Math.cos(angle) * radius;
      const targetZ = center.z + Math.sin(angle) * radius;
      
      drone.velocity.x = (targetX - drone.position.x) * 0.15;
      drone.velocity.z = (targetZ - drone.position.z) * 0.15;
      drone.position.x += drone.velocity.x;
      drone.position.z += drone.velocity.z;
    }
  }
  
  private executeRetreat(
    drones: RealSpecDroneState[],
    threatPosition: { x: number; y: number; z: number }
  ): void {
    for (const drone of drones) {
      const dx = drone.position.x - threatPosition.x;
      const dz = drone.position.z - threatPosition.z;
      const dist = Math.sqrt(dx*dx + dz*dz);
      
      if (dist > 0.1) {
        drone.velocity.x = (dx / dist) * 2.0;
        drone.velocity.z = (dz / dist) * 2.0;
        drone.position.x += drone.velocity.x;
        drone.position.z += drone.velocity.z;
      }
    }
  }
  
  private executeRegroup(
    drones: RealSpecDroneState[],
    center: { x: number; y: number; z: number }
  ): void {
    for (const drone of drones) {
      const dx = center.x - drone.position.x;
      const dz = center.z - drone.position.z;
      
      drone.velocity.x = dx * 0.1;
      drone.velocity.z = dz * 0.1;
      drone.position.x += drone.velocity.x;
      drone.position.z += drone.velocity.z;
    }
  }
  
  private executeHunt(
    drones: RealSpecDroneState[],
    lastKnownPosition: { x: number; y: number; z: number }
  ): void {
    // Move toward last known position but spread out to search
    for (let i = 0; i < drones.length; i++) {
      const drone = drones[i];
      const angle = (i / drones.length) * Math.PI * 2;
      const searchRadius = 50;
      
      const searchTarget = {
        x: lastKnownPosition.x + Math.cos(angle + this.beatCount * 0.01) * searchRadius,
        z: lastKnownPosition.z + Math.sin(angle + this.beatCount * 0.01) * searchRadius
      };
      
      const dx = searchTarget.x - drone.position.x;
      const dz = searchTarget.z - drone.position.z;
      
      drone.velocity.x = dx * 0.05;
      drone.velocity.z = dz * 0.05;
      drone.position.x += drone.velocity.x;
      drone.position.z += drone.velocity.z;
    }
  }
  
  private executeFlank(
    drones: RealSpecDroneState[],
    target: { x: number; y: number; z: number }
  ): void {
    const center = this.getSwarmCenter();
    
    // Split into two groups for pincer movement
    const halfCount = Math.floor(drones.length / 2);
    
    for (let i = 0; i < drones.length; i++) {
      const drone = drones[i];
      const side = i < halfCount ? 1 : -1;
      
      // Move perpendicular to target direction first
      const dx = target.x - center.x;
      const dz = target.z - center.z;
      const dist = Math.sqrt(dx*dx + dz*dz);
      
      // Perpendicular direction
      const perpX = -dz / dist * side;
      const perpZ = dx / dist * side;
      
      // Move out then toward
      const flankDist = 60;
      const flankTarget = {
        x: target.x + perpX * flankDist,
        z: target.z + perpZ * flankDist
      };
      
      const toFlank = {
        x: flankTarget.x - drone.position.x,
        z: flankTarget.z - drone.position.z
      };
      
      drone.velocity.x = toFlank.x * 0.08;
      drone.velocity.z = toFlank.z * 0.08;
      drone.position.x += drone.velocity.x;
      drone.position.z += drone.velocity.z;
    }
  }
  
  private executeScatter(drones: RealSpecDroneState[]): void {
    const center = this.getSwarmCenter();
    
    for (const drone of drones) {
      // Move away from center
      const dx = drone.position.x - center.x;
      const dz = drone.position.z - center.z;
      const dist = Math.sqrt(dx*dx + dz*dz);
      
      if (dist > 0.1) {
        drone.velocity.x = (dx / dist) * 1.5 + (Math.random() - 0.5) * 0.5;
        drone.velocity.z = (dz / dist) * 1.5 + (Math.random() - 0.5) * 0.5;
        drone.position.x += drone.velocity.x;
        drone.position.z += drone.velocity.z;
      }
    }
  }
  
  private executePatrol(
    drones: RealSpecDroneState[],
    center: { x: number; y: number; z: number }
  ): void {
    const patrolRadius = 40;
    
    for (let i = 0; i < drones.length; i++) {
      const drone = drones[i];
      const angle = (this.beatCount * 0.01) + (i / drones.length) * Math.PI * 2;
      
      const targetX = center.x + Math.cos(angle) * patrolRadius;
      const targetZ = center.z + Math.sin(angle) * patrolRadius;
      
      drone.velocity.x = (targetX - drone.position.x) * 0.05;
      drone.velocity.z = (targetZ - drone.position.z) * 0.05;
      drone.position.x += drone.velocity.x;
      drone.position.z += drone.velocity.z;
    }
  }
  
  /**
   * Hebbian learning — update weights based on outcomes
   */
  private hebbianLearning(): void {
    const state = this.cognitiveState;
    
    // "Neurons that fire together wire together"
    for (let i = 0; i < 6; i++) {
      for (let j = 0; j < 6; j++) {
        const idx = i * 6 + j;
        const correlation = state.brainActivation[i] * state.brainActivation[j];
        
        // Modulated by dopamine (reward signal)
        const delta = state.hebbianLearningRate * correlation * state.dopamine;
        
        state.brainWeights[idx] = Math.max(0, Math.min(2, 
          state.brainWeights[idx] + delta
        ));
      }
    }
    
    // Normalize weights to prevent explosion
    const sum = state.brainWeights.reduce((a, b) => a + b, 0);
    if (sum > 50) {
      const scale = 50 / sum;
      for (let i = 0; i < state.brainWeights.length; i++) {
        state.brainWeights[i] *= scale;
      }
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════════════════════════════════════
  
  private getSwarmCenter(): { x: number; y: number; z: number } {
    const drones = this.fleet.getAllDrones();
    if (drones.length === 0) return { x: 0, y: 0, z: 0 };
    
    return {
      x: drones.reduce((s, d) => s + d.position.x, 0) / drones.length,
      y: drones.reduce((s, d) => s + d.position.y, 0) / drones.length,
      z: drones.reduce((s, d) => s + d.position.z, 0) / drones.length
    };
  }
  
  // Public getters
  getFleet(): RealSpecDroneFleet { return this.fleet; }
  getCognitiveState(): CommanderCognitiveState { return this.cognitiveState; }
  getVisualField(): VisualField | null { return this.currentVisualField; }
  getCurrentObjective(): CombatObjective | null { return this.currentObjective; }
  getCombatHistory(): CombatEvent[] { return this.combatHistory; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUPPORTING TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export interface CombatObjective {
  type: 'Attack' | 'Defend' | 'Retreat' | 'Regroup' | 'Patrol' | 'Hunt' | 'Flank' | 'Scatter';
  target: { x: number; y: number; z: number };
  priority: number;
  startBeat: number;
}

export interface TacticalPlan {
  formation: string;
  phases: TacticalPhase[];
  currentPhase: number;
}

export interface TacticalPhase {
  name: string;
  duration: number;
  action: string;
  condition?: string;
}

export interface CombatEvent {
  beat: number;
  distance: number;
  myDrones: number;
  enemyDrones: number;
  novaCoherence: number;
  myCoherence: number;
  outcome: 'Success' | 'Failure' | 'Neutral';
}

export interface CommanderTickResult {
  commanderId: string;
  beat: number;
  coherence: number;
  morale: number;
  health: number;
  currentObjective: string;
  activeDrones: number;
  emotionalState: {
    fear: number;
    aggression: number;
    confidence: number;
    frustration: number;
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// FACTORY — Create commanders at different levels
// ═══════════════════════════════════════════════════════════════════════════════

export function createEnemyCommander(
  id: string,
  faction: CompetitorFaction,
  level: CompetitorLevel,
  droneCount: number,
  position: { x: number; y: number; z: number },
  doctrine: CompetitorDoctrine
): EnemyOrganismCommander {
  return new EnemyOrganismCommander(
    id, faction, level, doctrine, droneCount, position
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// DOCTRINE NOTE — Why Smart Enemies Matter
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * WHY THE ENEMIES USE THE SAME ARCHITECTURE AS NOVA
 * 
 * If enemies are just scripts:
 *   - NOVA learns to exploit scripts
 *   - Tactics become pattern-matching, not strategy
 *   - No real intelligence emerges
 *   
 * If enemies are ORGANISMS with the same architecture:
 *   - NOVA must develop real tactics
 *   - Both sides learn and adapt
 *   - True emergence through competition
 *   
 * Each enemy commander has:
 *   - 6-node micro-brain (same as NOVA)
 *   - Hebbian learning (same mechanism)
 *   - Kuramoto phase coupling (same physics)
 *   - Neurochemistry (same emotional system)
 *   - Visual cortex (sees through their drones)
 *   - Pattern recognition (learns NOVA's tactics)
 *   
 * This creates GENUINE competitive pressure.
 * NOVA must EVOLVE to survive.
 * 
 * "You don't get strong fighting weak opponents."
 * — Every warrior ever
 */
