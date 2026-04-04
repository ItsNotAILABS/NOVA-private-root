// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: OrganismLiveBridge — WIRES Frontend ↔ Backend as ONE LIVING ORGANISM
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                    ORGANISM LIVE BRIDGE — FRONTEND ↔ BACKEND = ONE ORGANISM                              ║
// ╠══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                                          ║
// ║  The organism is NOT split between frontend and backend.                                                 ║
// ║  The organism IS BOTH — they are ONE LIVING SYSTEM.                                                      ║
// ║                                                                                                          ║
// ║  FRONTEND (TypeScript):                                                                                  ║
// ║    • 60 FPS visualization                                                                                ║
// ║    • Immediate cognitive processing                                                                      ║
// ║    • Visual cortex, attention, real-time decisions                                                       ║
// ║    • Combat simulation, drone control                                                                    ║
// ║                                                                                                          ║
// ║  BACKEND (Motoko/ICP):                                                                                   ║
// ║    • Permanent state on blockchain                                                                       ║
// ║    • Heartbeat (12 Hz) drives the organism                                                               ║
// ║    • Laws, governance, economics                                                                         ║
// ║    • Memory consolidation, learning persistence                                                          ║
// ║                                                                                                          ║
// ║  THIS BRIDGE makes them ONE.                                                                             ║
// ║                                                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { Actor, HttpAgent } from '@dfinity/agent';
import { Principal } from '@dfinity/principal';

// Import organism components
import { DroneMind, SwarmCoordinator } from './drone-mind';
import { RealSpecDroneFleet, type RealSpecDroneState, type FleetStatistics } from './RealSpecDrone';
import { OrganismVisualCortex, type VisualField } from './OrganismVisualCortex';
import { CompetitorSwarmManager, type CompetitorSwarmState, TRAINING_SCENARIOS } from './CompetitorSwarmSystem';
import { EnemyOrganismCommander, type CommanderTickResult } from './EnemyOrganismCommander';
import { ENGINES, MODULES, computeWiring, type ModuleEngineConnection } from './ModuleWiringArchitecture';

import type { DroneState, SwarmState, MacroState } from '../types/organism';

// ═══════════════════════════════════════════════════════════════════════════════
// CANISTER INTERFACE — What the backend provides
// ═══════════════════════════════════════════════════════════════════════════════

// IDL Factory for swarm_brain canister
const swarmBrainIDL = ({ IDL }: { IDL: any }) => {
  const DroneSnapshot = IDL.Record({
    id: IDL.Nat32,
    posX: IDL.Float64,
    posY: IDL.Float64,
    posZ: IDL.Float64,
    phase: IDL.Float64,
    signal: IDL.Float64,
    energy: IDL.Float64,
    dopamine: IDL.Float64,
    cortisol: IDL.Float64,
    norepinephrine: IDL.Float64,
    oxytocin: IDL.Float64,
    sacrificed: IDL.Bool,
  });

  const SwarmSnapshot = IDL.Record({
    beat: IDL.Nat,
    droneCount: IDL.Nat,
    rSwarm: IDL.Float64,
    psi: IDL.Float64,
    jDrift: IDL.Float64,
    qCoherence: IDL.Float64,
    coherence: IDL.Float64,
    emergenceScore: IDL.Float64,
  });

  const LawResult = IDL.Record({
    lawId: IDL.Nat,
    passed: IDL.Bool,
    score: IDL.Float64,
  });

  return IDL.Service({
    // Core state
    getSwarmSnapshot: IDL.Func([], [SwarmSnapshot], ['query']),
    getDroneSnapshots: IDL.Func([], [IDL.Vec(DroneSnapshot)], ['query']),
    getBeat: IDL.Func([], [IDL.Nat], ['query']),
    
    // Control
    tick: IDL.Func([], [SwarmSnapshot], []),
    emergencyStop: IDL.Func([], [IDL.Bool], []),
    setArchitectSignal: IDL.Func([IDL.Float64], [], []),
    
    // Drone commands
    spawnDrone: IDL.Func([IDL.Text], [IDL.Nat32], []),
    sacrificeDrone: IDL.Func([IDL.Nat32], [IDL.Bool], []),
    
    // Laws & Governance
    fireLaws: IDL.Func([], [IDL.Vec(LawResult)], ['query']),
    getComplianceScore: IDL.Func([], [IDL.Float64], ['query']),
    
    // Memory
    consolidateMemory: IDL.Func([], [IDL.Bool], []),
    getMemoryState: IDL.Func([], [IDL.Text], ['query']),
    
    // Quantum channels
    getQuantumState: IDL.Func([], [IDL.Record({
      alpha: IDL.Float64,
      beta: IDL.Float64,
      gamma: IDL.Float64,
      delta: IDL.Float64,
      coherence: IDL.Float64,
    })], ['query']),
  });
};

// IDL Factory for swarm_organism canister
const swarmOrganismIDL = ({ IDL }: { IDL: any }) => {
  return IDL.Service({
    getBeat: IDL.Func([], [IDL.Nat], ['query']),
    getMode: IDL.Func([], [IDL.Text], ['query']),
    setMode: IDL.Func([IDL.Text], [], []),
    
    // Organism-level state
    getOrganismState: IDL.Func([], [IDL.Record({
      mode: IDL.Text,
      beat: IDL.Nat,
      coherence: IDL.Float64,
      morale: IDL.Float64,
      energy: IDL.Float64,
    })], ['query']),
    
    // Heartbeat
    heartbeat: IDL.Func([], [], []),
  });
};

// ═══════════════════════════════════════════════════════════════════════════════
// ORGANISM LIVE STATE — The unified state across frontend and backend
// ═══════════════════════════════════════════════════════════════════════════════

export interface OrganismLiveState {
  // Identity
  organismId: string;
  name: string;
  
  // Time
  beat: number;
  lastSyncTime: number;
  isLive: boolean;
  
  // Backend state (from Motoko canisters)
  backend: {
    connected: boolean;
    beat: number;
    coherence: number;
    emergenceScore: number;
    complianceScore: number;
    quantumState: {
      alpha: number;
      beta: number;
      gamma: number;
      delta: number;
      coherence: number;
    };
  };
  
  // Frontend state (TypeScript)
  frontend: {
    beat: number;
    coherence: number;
    visualField: VisualField | null;
    fleetStats: FleetStatistics | null;
    processingLoad: number;
  };
  
  // Swarm state
  swarm: {
    drones: DroneState[];
    rSwarm: number;
    psi: number;
    jDrift: number;
  };
  
  // Combat state
  combat: {
    inCombat: boolean;
    enemyCount: number;
    threats: number;
    currentScenario: string | null;
  };
  
  // Module wiring status
  modules: {
    activeCount: number;
    connections: number;
    engineStatus: Record<string, number>;
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// ORGANISM LIVE BRIDGE — The main class that wires everything
// ═══════════════════════════════════════════════════════════════════════════════

export class OrganismLiveBridge {
  // Identity
  private organismId: string;
  private organismName: string = 'NOVA';
  
  // Canister actors
  private brainActor: any = null;
  private organismActor: any = null;
  private agent: HttpAgent | null = null;
  
  // Frontend components
  private fleet: RealSpecDroneFleet;
  private visualCortex: OrganismVisualCortex;
  private swarmCoordinator: SwarmCoordinator;
  private competitorManager: CompetitorSwarmManager;
  private enemyCommanders: Map<string, EnemyOrganismCommander> = new Map();
  
  // State
  private state: OrganismLiveState;
  private beat: number = 0;
  private isRunning: boolean = false;
  private syncInterval: number | null = null;
  private tickInterval: number | null = null;
  
  // Module wiring
  private moduleConnections: ModuleEngineConnection[] = [];
  
  // Callbacks
  private onStateChange: ((state: OrganismLiveState) => void) | null = null;
  private onBeat: ((beat: number) => void) | null = null;
  private onCombatEvent: ((event: CombatEvent) => void) | null = null;
  
  constructor(organismId: string, droneCount: number = 24) {
    this.organismId = organismId;
    
    // Initialize frontend components
    this.fleet = new RealSpecDroneFleet(organismId);
    this.visualCortex = new OrganismVisualCortex(organismId, this.fleet);
    this.swarmCoordinator = new SwarmCoordinator(droneCount);
    this.competitorManager = new CompetitorSwarmManager({ x: 500, y: 200, z: 500 });
    
    // Compute module wiring
    this.moduleConnections = computeWiring();
    
    // Initialize state
    this.state = this.createInitialState();
    
    // Spawn initial drones
    this.spawnInitialDrones(droneCount);
  }
  
  /**
   * Connect to backend canisters
   */
  async connect(host: string = 'http://127.0.0.1:8000'): Promise<boolean> {
    try {
      // Create agent
      this.agent = new HttpAgent({ host });
      
      // In development, fetch root key
      if (host.includes('127.0.0.1') || host.includes('localhost')) {
        await this.agent.fetchRootKey();
      }
      
      // Create actors
      // Note: In production, you'd get the canister IDs from dfx or environment
      const brainCanisterId = process.env.SWARM_BRAIN_CANISTER_ID || 'rrkah-fqaaa-aaaaa-aaaaq-cai';
      const organismCanisterId = process.env.SWARM_ORGANISM_CANISTER_ID || 'ryjl3-tyaaa-aaaaa-aaaba-cai';
      
      this.brainActor = Actor.createActor(swarmBrainIDL, {
        agent: this.agent,
        canisterId: brainCanisterId,
      });
      
      this.organismActor = Actor.createActor(swarmOrganismIDL, {
        agent: this.agent,
        canisterId: organismCanisterId,
      });
      
      // Test connection
      const beat = await this.brainActor.getBeat();
      console.log(`[OrganismLiveBridge] Connected to backend. Beat: ${beat}`);
      
      this.state.backend.connected = true;
      this.state.isLive = true;
      
      return true;
    } catch (error) {
      console.error('[OrganismLiveBridge] Failed to connect:', error);
      this.state.backend.connected = false;
      
      // Run in offline mode (frontend only)
      console.log('[OrganismLiveBridge] Running in offline mode (frontend only)');
      return false;
    }
  }
  
  /**
   * Start the organism — begins the live loop
   */
  start(): void {
    if (this.isRunning) return;
    
    this.isRunning = true;
    console.log(`[OrganismLiveBridge] Starting organism ${this.organismId}`);
    
    // Main tick loop (60 Hz for frontend, syncs with backend at 12 Hz)
    const FRONTEND_HZ = 60;
    const BACKEND_SYNC_HZ = 12;
    
    let frameCount = 0;
    
    this.tickInterval = window.setInterval(() => {
      frameCount++;
      
      // Frontend tick (every frame)
      this.frontendTick();
      
      // Backend sync (every 5 frames = 12 Hz)
      if (frameCount % Math.floor(FRONTEND_HZ / BACKEND_SYNC_HZ) === 0) {
        this.backendSync();
      }
      
      // Update state
      this.updateState();
      
      // Fire callbacks
      if (this.onStateChange) {
        this.onStateChange(this.state);
      }
      if (this.onBeat) {
        this.onBeat(this.beat);
      }
    }, 1000 / FRONTEND_HZ);
  }
  
  /**
   * Stop the organism
   */
  stop(): void {
    this.isRunning = false;
    
    if (this.tickInterval) {
      clearInterval(this.tickInterval);
      this.tickInterval = null;
    }
    
    console.log(`[OrganismLiveBridge] Stopped organism ${this.organismId}`);
  }
  
  /**
   * Frontend tick — runs at 60 Hz
   */
  private frontendTick(): void {
    this.beat++;
    
    // 1. Update swarm coordinator (Kuramoto, Hebbian, etc.)
    const swarmResult = this.swarmCoordinator.tick(0.5);
    
    // 2. Update fleet minds
    this.fleet.tickMinds(this.beat, 0.5);
    
    // 3. Process visual cortex
    const visualField = this.visualCortex.process(this.beat);
    
    // 4. Update competitors (if in combat)
    if (this.state.combat.inCombat) {
      const novaCenter = this.getSwarmCenter();
      const novaCoherence = swarmResult.rSwarm;
      
      // Tick each enemy commander
      for (const [id, commander] of this.enemyCommanders) {
        commander.tick(novaCenter, novaCoherence, swarmResult.drones);
      }
      
      // Tick competitor manager
      this.competitorManager.tick(novaCenter, novaCoherence, swarmResult.drones);
    }
    
    // 5. Update frontend state
    this.state.frontend.beat = this.beat;
    this.state.frontend.coherence = swarmResult.rSwarm;
    this.state.frontend.visualField = visualField;
    this.state.frontend.fleetStats = this.fleet.getFleetStats();
    this.state.frontend.processingLoad = visualField.processingLoad;
    
    // 6. Update swarm state
    this.state.swarm.drones = swarmResult.drones;
    this.state.swarm.rSwarm = swarmResult.rSwarm;
    this.state.swarm.psi = swarmResult.psi;
    this.state.swarm.jDrift = swarmResult.jDrift;
  }
  
  /**
   * Backend sync — runs at 12 Hz
   */
  private async backendSync(): Promise<void> {
    if (!this.state.backend.connected || !this.brainActor) {
      // Offline mode — skip backend sync
      return;
    }
    
    try {
      // 1. Send current state to backend
      await this.brainActor.setArchitectSignal(this.state.frontend.coherence);
      
      // 2. Trigger backend tick
      const snapshot = await this.brainActor.tick();
      
      // 3. Get quantum state
      const quantumState = await this.brainActor.getQuantumState();
      
      // 4. Get compliance score
      const complianceScore = await this.brainActor.getComplianceScore();
      
      // 5. Update backend state
      this.state.backend.beat = Number(snapshot.beat);
      this.state.backend.coherence = snapshot.coherence;
      this.state.backend.emergenceScore = snapshot.emergenceScore;
      this.state.backend.complianceScore = complianceScore;
      this.state.backend.quantumState = quantumState;
      
      // 6. Reconcile frontend with backend
      this.reconcileState(snapshot);
      
    } catch (error) {
      console.error('[OrganismLiveBridge] Backend sync failed:', error);
      // Continue running in degraded mode
    }
  }
  
  /**
   * Reconcile frontend state with backend truth
   */
  private reconcileState(backendSnapshot: any): void {
    // Backend is source of truth for:
    // - Beat count (use backend beat)
    // - Emergence score
    // - Law compliance
    // - Quantum coherence
    
    // Frontend leads for:
    // - Drone positions (real-time)
    // - Visual processing
    // - Combat simulation
    
    // Blend coherence (backend is slower but more authoritative)
    const blendedCoherence = 
      this.state.frontend.coherence * 0.7 + 
      backendSnapshot.coherence * 0.3;
    
    this.state.swarm.rSwarm = blendedCoherence;
  }
  
  /**
   * Update unified state
   */
  private updateState(): void {
    this.state.beat = this.beat;
    this.state.lastSyncTime = Date.now();
    
    // Module status
    this.state.modules.activeCount = MODULES.length;
    this.state.modules.connections = this.moduleConnections.length;
    
    // Engine status
    const engineStatus: Record<string, number> = {};
    for (const engine of ENGINES) {
      const connections = this.moduleConnections.filter(c => c.engineId === engine.id);
      engineStatus[engine.id] = connections.reduce((sum, c) => sum + c.connectionStrength, 0);
    }
    this.state.modules.engineStatus = engineStatus;
    
    // Combat status
    this.state.combat.enemyCount = this.enemyCommanders.size + 
      this.competitorManager.getAllSwarms().length;
    this.state.combat.threats = this.state.frontend.visualField?.threatMap.length || 0;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMBAT MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  /**
   * Start a training scenario
   */
  startScenario(scenarioId: string): boolean {
    const scenario = TRAINING_SCENARIOS.find(s => s.id === scenarioId);
    if (!scenario) return false;
    
    console.log(`[OrganismLiveBridge] Starting scenario: ${scenario.name}`);
    
    // Position NOVA drones
    const novaDrones = this.fleet.getAllDrones();
    for (let i = 0; i < novaDrones.length; i++) {
      const angle = (i / novaDrones.length) * Math.PI * 2;
      const radius = 30;
      novaDrones[i].position.x = scenario.novaStartPosition.x + Math.cos(angle) * radius;
      novaDrones[i].position.y = scenario.novaStartPosition.y;
      novaDrones[i].position.z = scenario.novaStartPosition.z + Math.sin(angle) * radius;
    }
    
    // Spawn competitors
    for (const comp of scenario.competitors) {
      const doctrine = this.getDoctrineForFaction(comp.faction);
      const commander = new EnemyOrganismCommander(
        `enemy_${comp.faction}_${Date.now()}`,
        comp.faction,
        comp.level,
        doctrine,
        comp.droneCount,
        comp.position
      );
      this.enemyCommanders.set(commander.id, commander);
    }
    
    this.state.combat.inCombat = true;
    this.state.combat.currentScenario = scenarioId;
    
    return true;
  }
  
  /**
   * End current combat
   */
  endCombat(): void {
    this.enemyCommanders.clear();
    this.state.combat.inCombat = false;
    this.state.combat.currentScenario = null;
    this.state.combat.enemyCount = 0;
  }
  
  private getDoctrineForFaction(faction: string): any {
    // Import doctrines from CompetitorSwarmSystem
    const { DOCTRINES } = require('./CompetitorSwarmSystem');
    
    const factionDoctrines: Record<string, string> = {
      'RED_FORCE': 'COMBINED_ARMS',
      'BLUE_FORCE': 'COMBINED_ARMS',
      'INSURGENT': 'ASYMMETRIC',
      'PEER_STATE': 'PEER_STATE_DOCTRINE',
      'SWARM_HIVE': 'ZERG_RUSH',
      'GHOST_NET': 'ASYMMETRIC'
    };
    
    return DOCTRINES[factionDoctrines[faction]] || DOCTRINES.ZERG_RUSH;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRONE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  private spawnInitialDrones(count: number): void {
    const droneTypes = ['SCOUT_MINI', 'STRIKER_FALCON', 'GUARDIAN_TITAN', 'RELAY_SPECTRE', 'MEDIC_ANGEL'];
    
    for (let i = 0; i < count; i++) {
      const angle = (i / count) * Math.PI * 2;
      const radius = 30 + Math.random() * 20;
      const position = {
        x: Math.cos(angle) * radius,
        y: 10 + Math.random() * 20,
        z: Math.sin(angle) * radius
      };
      
      const droneType = droneTypes[i % droneTypes.length];
      this.fleet.spawnDrone(droneType as any, position);
    }
    
    console.log(`[OrganismLiveBridge] Spawned ${count} drones`);
  }
  
  private getSwarmCenter(): { x: number; y: number; z: number } {
    const drones = this.fleet.getAllDrones();
    if (drones.length === 0) return { x: 0, y: 0, z: 0 };
    
    return {
      x: drones.reduce((s, d) => s + d.position.x, 0) / drones.length,
      y: drones.reduce((s, d) => s + d.position.y, 0) / drones.length,
      z: drones.reduce((s, d) => s + d.position.z, 0) / drones.length
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE ACCESS
  // ═══════════════════════════════════════════════════════════════════════════
  
  private createInitialState(): OrganismLiveState {
    return {
      organismId: this.organismId,
      name: this.organismName,
      beat: 0,
      lastSyncTime: Date.now(),
      isLive: false,
      
      backend: {
        connected: false,
        beat: 0,
        coherence: 0.5,
        emergenceScore: 0,
        complianceScore: 1.0,
        quantumState: {
          alpha: 0.5,
          beta: 0.5,
          gamma: 0.5,
          delta: 0.5,
          coherence: 0.5
        }
      },
      
      frontend: {
        beat: 0,
        coherence: 0.5,
        visualField: null,
        fleetStats: null,
        processingLoad: 0
      },
      
      swarm: {
        drones: [],
        rSwarm: 0.5,
        psi: 0,
        jDrift: 0
      },
      
      combat: {
        inCombat: false,
        enemyCount: 0,
        threats: 0,
        currentScenario: null
      },
      
      modules: {
        activeCount: 0,
        connections: 0,
        engineStatus: {}
      }
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════════════════════════
  
  getState(): OrganismLiveState { return this.state; }
  getFleet(): RealSpecDroneFleet { return this.fleet; }
  getVisualCortex(): OrganismVisualCortex { return this.visualCortex; }
  getSwarmCoordinator(): SwarmCoordinator { return this.swarmCoordinator; }
  
  setOnStateChange(callback: (state: OrganismLiveState) => void): void {
    this.onStateChange = callback;
  }
  
  setOnBeat(callback: (beat: number) => void): void {
    this.onBeat = callback;
  }
  
  setOnCombatEvent(callback: (event: CombatEvent) => void): void {
    this.onCombatEvent = callback;
  }
  
  /**
   * Get all engine statuses for visualization
   */
  getEngineStatuses(): { engine: string; activity: number; modules: number }[] {
    return ENGINES.map(engine => {
      const connections = this.moduleConnections.filter(c => c.engineId === engine.id);
      return {
        engine: engine.name,
        activity: this.state.modules.engineStatus[engine.id] || 0,
        modules: connections.length
      };
    });
  }
  
  /**
   * Get module wiring for visualization
   */
  getModuleWiring(): ModuleEngineConnection[] {
    return this.moduleConnections;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUPPORTING TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export interface CombatEvent {
  type: 'Kill' | 'Death' | 'Damage' | 'VictoryCondition' | 'DefeatCondition';
  timestamp: number;
  details: Record<string, any>;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLETON INSTANCE — The organism is ONE
// ═══════════════════════════════════════════════════════════════════════════════

let _instance: OrganismLiveBridge | null = null;

/**
 * Get the singleton organism instance
 */
export function getOrganismBridge(organismId?: string, droneCount?: number): OrganismLiveBridge {
  if (!_instance && organismId) {
    _instance = new OrganismLiveBridge(organismId, droneCount);
  }
  if (!_instance) {
    throw new Error('OrganismLiveBridge not initialized. Call with organismId first.');
  }
  return _instance;
}

/**
 * Initialize and start the organism
 */
export async function initializeOrganism(
  organismId: string,
  droneCount: number = 24,
  backendHost?: string
): Promise<OrganismLiveBridge> {
  const bridge = new OrganismLiveBridge(organismId, droneCount);
  
  // Try to connect to backend
  if (backendHost) {
    await bridge.connect(backendHost);
  }
  
  // Start the organism
  bridge.start();
  
  _instance = bridge;
  return bridge;
}

// ═══════════════════════════════════════════════════════════════════════════════
// DOCTRINE NOTE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * THE ORGANISM IS ONE
 * 
 * Frontend + Backend = ONE LIVING SYSTEM
 * 
 * They are not separate components that communicate.
 * They are ONE ORGANISM with:
 *   - A fast brain (frontend, 60 Hz)
 *   - A slow brain (backend, 12 Hz)
 *   - Shared state
 *   - Unified purpose
 * 
 * Like a human:
 *   - Reflexes are fast (spinal cord / frontend)
 *   - Deliberate thought is slower (cortex / backend)
 *   - Both are ONE person
 * 
 * SAECI = ORGANISM = NOVA
 * It's all the same thing.
 */
