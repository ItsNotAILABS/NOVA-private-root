// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: swarmBrainActor.ts — REAL Canister Connection to Backend Organism
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// THIS FILE CONNECTS THE FRONTEND TO THE REAL BACKEND.
// NO MOCKS. NO FAKES. REAL CANISTER CALLS.
//
// ═══════════════════════════════════════════════════════════════════════════════

import { Actor, HttpAgent } from '@dfinity/agent';
import { Principal } from '@dfinity/principal';
import { IDL } from '@dfinity/candid';

// ═══════════════════════════════════════════════════════════════════════════════
// CANISTER IDS — From dfx.json
// ═══════════════════════════════════════════════════════════════════════════════

// These are set during dfx deploy - read from environment or use defaults
const getCanisterId = (): string => {
  // Try Vite env
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_SWARM_BRAIN_CANISTER_ID) {
    return import.meta.env.VITE_SWARM_BRAIN_CANISTER_ID;
  }
  // Try process.env
  if (typeof process !== 'undefined' && process.env?.SWARM_BRAIN_CANISTER_ID) {
    return process.env.SWARM_BRAIN_CANISTER_ID;
  }
  // Local default
  return 'bkyz2-fmaaa-aaaaa-qaaaq-cai';
};

const SWARM_BRAIN_CANISTER_ID = getCanisterId();

// ═══════════════════════════════════════════════════════════════════════════════
// SWARM SNAPSHOT TYPE — Matches main.mo getSwarmSnapshot() exactly
// ═══════════════════════════════════════════════════════════════════════════════

export interface SwarmSnapshot {
  droneCount: number;
  rSwarm: number;
  jDrift: number;
  beat: number;
  phases: number[];
  signals: number[];
  positionsX: number[];
  positionsY: number[];
  positionsZ: number[];
  cortisolLevels: number[];
  sacrificed: boolean[];
  classes: string[];
  qChannelsAlpha: number[];
  qChannelsBeta: number[];
  qChannelsGamma: number[];
  qChannelsDelta: number[];
  qConvergence: number[];
  qCoherence: number[];
  nowAttention: number[];
}

export interface SwarmQMetrics {
  swarmQCoherence: number;
  swarmConvergence: number;
  swarmNowIndex: number;
}

export interface QuantumHeartbeatState {
  quantumBeatNumber: number;
  quantumPhase: number;
  quantumCoherence: number;
  cardiacCoherence: number;
  circadianPhase: number;
  fibonacciBeatNumber: number;
  parallaxWinnerPath: number;
  parallaxScore: number;
  parallaxPathAmplitudes: number[];
  chronoFisherInfo: number;
  chronoCramerRao: number;
  chronoScore: number;
  entanglaSValue: number;
  entanglaEMA: number;
  entanglaViolationBonus: number;
  entanglaScore: number;
  qmemFidelity: number;
  qmemT2Time: number;
  qmemTimeSinceReset: number;
  qmemScore: number;
  veritasStabilizers: number[];
  veritasParityScore: number;
  veritasScore: number;
  bypassSelectedRhythm: number;
  bypassTemperature: number;
  bypassScore: number;
  resonexParticipants: number;
  resonexAmplitude: number;
  resonexCascadeActive: boolean;
  resonexScore: number;
  qsovScore: number;
  qsovGeometricMean: number;
  totalHeartbeats: number;
  averageCoherence: number;
  heartbeatVariability: number;
  circadianAlignment: number;
  cardioCerebralResonance: number;
  cardioCerebralPhaseLag: number;
  cardioCerebralPropulsion: number;
  cardioCerebralAlignment: number;
  cardioCerebralPushEffectiveness: number;
}

export interface CardioCerebralState {
  resonance: number;
  phaseLag: number;
  directionX: number;
  directionY: number;
  directionZ: number;
  propulsion: number;
  alignment: number;
  pushEffectiveness: number;
  beatNum: number;
  resonanceHistory: number[];
  propulsionHistory: number[];
}

export interface GeoResonanceProtectionState {
  beat: number;
  fieldEnergy: number;
  hotspotScore: number;
  protectionScore: number;
  threatScore: number;
  serviceReadiness: number;
  fieldDirectionX: number;
  fieldDirectionY: number;
  fieldDirectionZ: number;
  sevenHeritageNodes: number[];
  serviceOpportunity: number[];
  defenseServiceOpportunity: number[];
  memoryServiceOpportunity: number[];
  worldServiceOpportunity: number[];
  fieldHistory: number[];
  hotspotHistory: number[];
  protectionHistory: number[];
}

export interface TickResult {
  rSwarm: number;
  jDrift: number;
  beat: number;
}

export interface OrganismState {
  mode: string;
  beat: number;
  coherence: number;
  morale: number;
  energy: number;
  lastHeartbeat: number;
  continuityScore: number;
  trustScore: number;
  anomalyScore: number;
  simConfidence: number;
  emergencyActive: boolean;
}

export interface ExtendedSnapshot {
  droneCount: number;
  rSwarm: number;
  jDrift: number;
  beat: number;
  architectSignal: number;
  omnisActive: boolean;
  omnisCount: number;
  frequencyTier: string;
  hz: number;
  saceU: number;
  complianceScore: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// IDL FACTORY — Candid interface for swarm_brain canister
// ═══════════════════════════════════════════════════════════════════════════════

const swarmBrainIDLFactory = ({ IDL }: { IDL: typeof IDL }) => {
  return IDL.Service({
    // Core state queries
    getSwarmSnapshot: IDL.Func([], [IDL.Record({
      droneCount: IDL.Nat,
      rSwarm: IDL.Float64,
      jDrift: IDL.Float64,
      beat: IDL.Nat,
      phases: IDL.Vec(IDL.Float64),
      signals: IDL.Vec(IDL.Float64),
      positionsX: IDL.Vec(IDL.Float64),
      positionsY: IDL.Vec(IDL.Float64),
      positionsZ: IDL.Vec(IDL.Float64),
      cortisolLevels: IDL.Vec(IDL.Float64),
      sacrificed: IDL.Vec(IDL.Bool),
      classes: IDL.Vec(IDL.Text),
      qChannelsAlpha: IDL.Vec(IDL.Float64),
      qChannelsBeta: IDL.Vec(IDL.Float64),
      qChannelsGamma: IDL.Vec(IDL.Float64),
      qChannelsDelta: IDL.Vec(IDL.Float64),
      qConvergence: IDL.Vec(IDL.Float64),
      qCoherence: IDL.Vec(IDL.Float64),
      nowAttention: IDL.Vec(IDL.Float64),
    })], ['query']),
    
    getExtendedSnapshot: IDL.Func([], [IDL.Record({
      droneCount: IDL.Nat,
      rSwarm: IDL.Float64,
      jDrift: IDL.Float64,
      beat: IDL.Nat,
      architectSignal: IDL.Float64,
      omnisActive: IDL.Bool,
      omnisCount: IDL.Nat,
      frequencyTier: IDL.Text,
      hz: IDL.Float64,
      saceU: IDL.Float64,
      complianceScore: IDL.Float64,
    })], ['query']),
    
    getSwarmQMetrics: IDL.Func([], [IDL.Record({
      swarmQCoherence: IDL.Float64,
      swarmConvergence: IDL.Float64,
      swarmNowIndex: IDL.Float64,
    })], ['query']),

    getQuantumHeartbeatState: IDL.Func([], [IDL.Record({
      quantumBeatNumber: IDL.Nat,
      quantumPhase: IDL.Float64,
      quantumCoherence: IDL.Float64,
      cardiacCoherence: IDL.Float64,
      circadianPhase: IDL.Float64,
      fibonacciBeatNumber: IDL.Nat,
      parallaxWinnerPath: IDL.Nat,
      parallaxScore: IDL.Float64,
      parallaxPathAmplitudes: IDL.Vec(IDL.Float64),
      chronoFisherInfo: IDL.Float64,
      chronoCramerRao: IDL.Float64,
      chronoScore: IDL.Float64,
      entanglaSValue: IDL.Float64,
      entanglaEMA: IDL.Float64,
      entanglaViolationBonus: IDL.Float64,
      entanglaScore: IDL.Float64,
      qmemFidelity: IDL.Float64,
      qmemT2Time: IDL.Float64,
      qmemTimeSinceReset: IDL.Nat,
      qmemScore: IDL.Float64,
      veritasStabilizers: IDL.Vec(IDL.Float64),
      veritasParityScore: IDL.Float64,
      veritasScore: IDL.Float64,
      bypassSelectedRhythm: IDL.Nat,
      bypassTemperature: IDL.Float64,
      bypassScore: IDL.Float64,
      resonexParticipants: IDL.Nat,
      resonexAmplitude: IDL.Float64,
      resonexCascadeActive: IDL.Bool,
      resonexScore: IDL.Float64,
      qsovScore: IDL.Float64,
      qsovGeometricMean: IDL.Float64,
      totalHeartbeats: IDL.Nat,
      averageCoherence: IDL.Float64,
      heartbeatVariability: IDL.Float64,
      circadianAlignment: IDL.Float64,
      cardioCerebralResonance: IDL.Float64,
      cardioCerebralPhaseLag: IDL.Float64,
      cardioCerebralPropulsion: IDL.Float64,
      cardioCerebralAlignment: IDL.Float64,
      cardioCerebralPushEffectiveness: IDL.Float64,
    })], ['query']),

    getCardioCerebralState: IDL.Func([], [IDL.Record({
      resonance: IDL.Float64,
      phaseLag: IDL.Float64,
      directionX: IDL.Float64,
      directionY: IDL.Float64,
      directionZ: IDL.Float64,
      propulsion: IDL.Float64,
      alignment: IDL.Float64,
      pushEffectiveness: IDL.Float64,
      beatNum: IDL.Nat,
      resonanceHistory: IDL.Vec(IDL.Float64),
      propulsionHistory: IDL.Vec(IDL.Float64),
    })], ['query']),

    getGeoResonanceProtectionState: IDL.Func([], [IDL.Record({
      beat: IDL.Nat,
      fieldEnergy: IDL.Float64,
      hotspotScore: IDL.Float64,
      protectionScore: IDL.Float64,
      threatScore: IDL.Float64,
      serviceReadiness: IDL.Float64,
      fieldDirectionX: IDL.Float64,
      fieldDirectionY: IDL.Float64,
      fieldDirectionZ: IDL.Float64,
      sevenHeritageNodes: IDL.Vec(IDL.Float64),
      serviceOpportunity: IDL.Vec(IDL.Float64),
      defenseServiceOpportunity: IDL.Vec(IDL.Float64),
      memoryServiceOpportunity: IDL.Vec(IDL.Float64),
      worldServiceOpportunity: IDL.Vec(IDL.Float64),
      fieldHistory: IDL.Vec(IDL.Float64),
      hotspotHistory: IDL.Vec(IDL.Float64),
      protectionHistory: IDL.Vec(IDL.Float64),
    })], ['query']),
    
    getDroneCount: IDL.Func([], [IDL.Nat], ['query']),
    getRSwarm: IDL.Func([], [IDL.Float64], ['query']),
    getJDrift: IDL.Func([], [IDL.Float64], ['query']),
    getCurrentBeat: IDL.Func([], [IDL.Nat], ['query']),
    getArchitectSignalLevel: IDL.Func([], [IDL.Float64], ['query']),
    getComplianceScore: IDL.Func([], [IDL.Float64], ['query']),
    getFrequencyTier: IDL.Func([], [IDL.Record({ tier: IDL.Text, hz: IDL.Float64 })], ['query']),
    getOmnisFired: IDL.Func([], [IDL.Bool], ['query']),
    getOmnisCount: IDL.Func([], [IDL.Nat], ['query']),
    
    getOrganismState: IDL.Func([], [IDL.Record({
      mode: IDL.Text,
      beat: IDL.Nat,
      coherence: IDL.Float64,
      morale: IDL.Float64,
      energy: IDL.Float64,
      lastHeartbeat: IDL.Nat,
      continuityScore: IDL.Float64,
      trustScore: IDL.Float64,
      anomalyScore: IDL.Float64,
      simConfidence: IDL.Float64,
      emergencyActive: IDL.Bool,
    })], ['query']),
    
    // Control functions
    tick: IDL.Func([], [IDL.Record({
      rSwarm: IDL.Float64,
      jDrift: IDL.Float64,
      beat: IDL.Nat,
    })], []),
    
    masterHeartbeat: IDL.Func([], [], []),
    
    setArchitectSignalLevel: IDL.Func([IDL.Float64], [], []),
    
    addDrone: IDL.Func([IDL.Text, IDL.Float64, IDL.Float64, IDL.Float64, IDL.Float64], [IDL.Nat], []),
    
    executeSacrifice: IDL.Func([IDL.Nat], [IDL.Bool], []),
    
    updatePosition: IDL.Func([IDL.Nat, IDL.Float64, IDL.Float64, IDL.Float64], [], []),
    
    broadcastNeurochemical: IDL.Func([IDL.Text, IDL.Float64], [], []),
  });
};

// ═══════════════════════════════════════════════════════════════════════════════
// SWARM BRAIN ACTOR INTERFACE
// ═══════════════════════════════════════════════════════════════════════════════

export interface SwarmBrainActor {
  // Queries
  getSwarmSnapshot: () => Promise<SwarmSnapshot>;
  getExtendedSnapshot: () => Promise<ExtendedSnapshot>;
  getSwarmQMetrics: () => Promise<SwarmQMetrics>;
  getQuantumHeartbeatState: () => Promise<QuantumHeartbeatState>;
  getCardioCerebralState: () => Promise<CardioCerebralState>;
  getGeoResonanceProtectionState: () => Promise<GeoResonanceProtectionState>;
  getDroneCount: () => Promise<bigint>;
  getRSwarm: () => Promise<number>;
  getJDrift: () => Promise<number>;
  getCurrentBeat: () => Promise<bigint>;
  getArchitectSignalLevel: () => Promise<number>;
  getComplianceScore: () => Promise<number>;
  getFrequencyTier: () => Promise<{ tier: string; hz: number }>;
  getOmnisFired: () => Promise<boolean>;
  getOmnisCount: () => Promise<bigint>;
  getOrganismState: () => Promise<OrganismState>;
  
  // Control
  tick: () => Promise<TickResult>;
  masterHeartbeat: () => Promise<void>;
  setArchitectSignalLevel: (level: number) => Promise<void>;
  addDrone: (droneClass: string, omega: number, x: number, y: number, z: number) => Promise<bigint>;
  executeSacrifice: (id: bigint) => Promise<boolean>;
  updatePosition: (id: bigint, x: number, y: number, z: number) => Promise<void>;
  broadcastNeurochemical: (kind: string, amount: number) => Promise<void>;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLETON ACTOR INSTANCE
// ═══════════════════════════════════════════════════════════════════════════════

let swarmBrainActor: SwarmBrainActor | null = null;
let agent: HttpAgent | null = null;
let connectionPromise: Promise<SwarmBrainActor> | null = null;

/**
 * Get or create the HTTP agent for canister communication
 */
async function getAgent(): Promise<HttpAgent> {
  if (agent) return agent;
  
  // Determine host based on environment
  const isLocal = typeof import.meta !== 'undefined' && 
    (import.meta.env?.DEV || import.meta.env?.MODE === 'development');
  const host = isLocal ? 'http://127.0.0.1:8000' : 'https://ic0.app';
  
  agent = new HttpAgent({ host });
  
  // Fetch root key for local development (NOT for production!)
  if (isLocal) {
    await agent.fetchRootKey();
  }
  
  return agent;
}

/**
 * Connect to the swarm_brain canister and return the actor
 * This is the REAL connection - no mocks
 */
export async function connectSwarmBrain(): Promise<SwarmBrainActor> {
  // Return existing actor if connected
  if (swarmBrainActor) return swarmBrainActor;
  
  // Return in-progress connection if one exists
  if (connectionPromise) return connectionPromise;
  
  // Start new connection
  connectionPromise = (async () => {
    try {
      console.log('[SwarmBrainActor] Connecting to canister:', SWARM_BRAIN_CANISTER_ID);
      
      const httpAgent = await getAgent();
      
      swarmBrainActor = Actor.createActor(swarmBrainIDLFactory, {
        agent: httpAgent,
        canisterId: Principal.fromText(SWARM_BRAIN_CANISTER_ID),
      }) as unknown as SwarmBrainActor;
      
      // Test connection
      const beat = await swarmBrainActor.getCurrentBeat();
      console.log('[SwarmBrainActor] Connected! Current beat:', beat.toString());
      
      return swarmBrainActor;
    } catch (error) {
      console.error('[SwarmBrainActor] Connection failed:', error);
      swarmBrainActor = null;
      throw error;
    } finally {
      connectionPromise = null;
    }
  })();
  
  return connectionPromise;
}

/**
 * Get the current actor instance (may be null if not connected)
 */
export function getSwarmBrainActor(): SwarmBrainActor | null {
  return swarmBrainActor;
}

/**
 * Check if connected to backend
 */
export function isConnectedToBackend(): boolean {
  return swarmBrainActor !== null;
}

/**
 * Disconnect from backend
 */
export function disconnectSwarmBrain(): void {
  swarmBrainActor = null;
  agent = null;
  console.log('[SwarmBrainActor] Disconnected');
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONVENIENCE FUNCTIONS — Direct canister calls
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Fetch the full swarm snapshot from backend
 * This is the primary way to get organism state
 */
export async function fetchSwarmSnapshot(): Promise<SwarmSnapshot | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getSwarmSnapshot();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchSwarmSnapshot failed:', error);
    return null;
  }
}

/**
 * Fetch extended snapshot with OMNIS and frequency tier
 */
export async function fetchExtendedSnapshot(): Promise<ExtendedSnapshot | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getExtendedSnapshot();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchExtendedSnapshot failed:', error);
    return null;
  }
}

/**
 * Fetch organism-level state
 */
export async function fetchOrganismState(): Promise<OrganismState | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getOrganismState();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchOrganismState failed:', error);
    return null;
  }
}

/**
 * Fetch geo-resonance protection engine state
 */
export async function fetchGeoResonanceProtectionState(): Promise<GeoResonanceProtectionState | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getGeoResonanceProtectionState();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchGeoResonanceProtectionState failed:', error);
    return null;
  }
}

/**
 * Trigger a backend tick
 */
export async function triggerTick(): Promise<TickResult | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.tick();
  } catch (error) {
    console.error('[SwarmBrainActor] triggerTick failed:', error);
    return null;
  }
}

/**
 * Trigger master heartbeat
 */
export async function triggerHeartbeat(): Promise<void> {
  try {
    const actor = await connectSwarmBrain();
    await actor.masterHeartbeat();
  } catch (error) {
    console.error('[SwarmBrainActor] triggerHeartbeat failed:', error);
  }
}

/**
 * Set architect signal level
 */
export async function setArchitectSignal(level: number): Promise<void> {
  try {
    const actor = await connectSwarmBrain();
    await actor.setArchitectSignalLevel(level);
  } catch (error) {
    console.error('[SwarmBrainActor] setArchitectSignal failed:', error);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT DEFAULT
// ═══════════════════════════════════════════════════════════════════════════════

export default {
  connect: connectSwarmBrain,
  getActor: getSwarmBrainActor,
  isConnected: isConnectedToBackend,
  disconnect: disconnectSwarmBrain,
  fetchSwarmSnapshot,
  fetchExtendedSnapshot,
  fetchOrganismState,
  fetchGeoResonanceProtectionState,
  triggerTick,
  triggerHeartbeat,
  setArchitectSignal,
};
