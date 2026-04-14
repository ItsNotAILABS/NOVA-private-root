// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: ModelTransformers.ts — CONVERSION BETWEEN BACKEND & FRONTEND MODELS
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA | MedinaSITech@outlook.com
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Provides bidirectional transformation functions between backend (Motoko/Candid)
// and frontend (TypeScript) model formats. Essential for organism communication.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import type {
  OrganismPulse,
  OrganismHealth,
  NeurochemicalState,
  QuantumChannels,
  QuantumState,
  DriveState,
  DriveType,
  DroneClass,
  DroneState,
  SwarmState,
  Position3D,
  Velocity3D,
  Region3D,
  SpatialState,
  OrganismType,
  LifecyclePhase,
  OrganismId,
  MemoryState,
  OrganismState,
} from './OrganismModels';

import {
  SOVEREIGN_FLOOR,
  defaultNeurochemistry,
  defaultQuantumState,
  defaultDriveState,
  defaultHealth,
  clamp,
} from './OrganismModels';

// ═══════════════════════════════════════════════════════════════════════════
// CANDID TYPE REPRESENTATIONS
// These mirror what comes from the ICP backend via Candid
// ═══════════════════════════════════════════════════════════════════════════

/** Candid variant representation */
export interface CandidVariant<T extends string> {
  [K: string]: unknown;
}

/** Backend DroneClass as Candid variant */
export type CandidDroneClass = 
  | { SCOUT: null }
  | { STRIKER: null }
  | { GUARDIAN: null }
  | { RELAY: null }
  | { MEDIC: null }
  | { SOVEREIGN: null };

/** Backend OrganismType as Candid variant */
export type CandidOrganismType =
  | { Nova: null }
  | { Aura: null }
  | { Chasmus: null }
  | { Chimera: null }
  | { Child: null };

/** Backend LifecyclePhase as Candid variant */
export type CandidLifecyclePhase =
  | { Genesis: null }
  | { FirstBreath: null }
  | { Active: null }
  | { Dreaming: null }
  | { Emergency: null }
  | { Dormant: null }
  | { Death: null };

/** Backend DriveType as Candid variant */
export type CandidDriveType =
  | { Hunger: null }
  | { Curiosity: null }
  | { Safety: null }
  | { Social: null }
  | { Reproduction: null }
  | { Balanced: null };

/** Backend NeurochemicalState record */
export interface CandidNeurochemicalState {
  dopamine: number;
  cortisol: number;
  norepinephrine: number;
  oxytocin: number;
}

/** Backend QuantumChannels record */
export interface CandidQuantumChannels {
  alpha: number;
  beta: number;
  gamma: number;
  delta: number;
}

/** Backend QuantumState record */
export interface CandidQuantumState {
  channels: CandidQuantumChannels;
  convergence: number;
  coherence: number;
  nowAttention: number;
  entanglement: number;
}

/** Backend OrganismHealth record */
export interface CandidOrganismHealth {
  trustScore: number;
  anomalyScore: number;
  continuityScore: number;
  loadPulse: number;
  stability: number;
}

/** Backend OrganismPulse record */
export interface CandidOrganismPulse {
  beat: bigint;
  timestamp: bigint;
  coherence: number;
  arousal: number;
  drift: number;
  emergence: number;
  energy: number;
  phase: number;
  health: CandidOrganismHealth;
}

/** Backend DriveState record */
export interface CandidDriveState {
  hunger: number;
  curiosity: number;
  safety: number;
  social: number;
  reproduction: number;
  dominant: CandidDriveType;
}

/** Backend Position3D record */
export interface CandidPosition3D {
  x: number;
  y: number;
  z: number;
}

/** Backend Velocity3D record */
export interface CandidVelocity3D {
  vx: number;
  vy: number;
  vz: number;
}

/** Backend Region3D record */
export interface CandidRegion3D {
  minX: number;
  maxX: number;
  minY: number;
  maxY: number;
  minZ: number;
  maxZ: number;
}

/** Backend SpatialState record */
export interface CandidSpatialState {
  position: CandidPosition3D;
  velocity: CandidVelocity3D;
  orientation: number[];
  scale: number;
  boundingRegion: CandidRegion3D;
}

/** Backend DroneState record */
export interface CandidDroneState {
  id: bigint;
  class_: CandidDroneClass;
  spatial: CandidSpatialState;
  phase: number;
  omega: number;
  signal: number;
  neurochemistry: CandidNeurochemicalState;
  energy: number;
  brainWeights: number[];
  sacrificed: boolean;
  lastBeat: bigint;
}

/** Backend MemoryState record */
export interface CandidMemoryState {
  workingCapacity: bigint;
  workingUsed: bigint;
  totalMemories: bigint;
  compressionRatio: number;
  lastConsolidation: bigint;
  hebbianStrength: number;
}

/** Backend OrganismId record */
export interface CandidOrganismId {
  principal: { toText: () => string } | string;
  organismType: CandidOrganismType;
  birthBeat: bigint;
  genesisTimestamp: bigint;
}

// ═══════════════════════════════════════════════════════════════════════════
// BACKEND → FRONTEND TRANSFORMERS
// Convert Candid types to TypeScript types
// ═══════════════════════════════════════════════════════════════════════════

/** Convert Candid DroneClass to TypeScript DroneClass */
export function fromCandidDroneClass(candid: CandidDroneClass): DroneClass {
  if ('SCOUT' in candid) return 'Scout';
  if ('STRIKER' in candid) return 'Striker';
  if ('GUARDIAN' in candid) return 'Guardian';
  if ('RELAY' in candid) return 'Relay';
  if ('MEDIC' in candid) return 'Medic';
  if ('SOVEREIGN' in candid) return 'Sovereign';
  return 'Scout'; // Default
}

/** Convert Candid OrganismType to TypeScript OrganismType */
export function fromCandidOrganismType(candid: CandidOrganismType): OrganismType {
  if ('Nova' in candid) return 'Nova';
  if ('Aura' in candid) return 'Aura';
  if ('Chasmus' in candid) return 'Chasmus';
  if ('Chimera' in candid) return 'Chimera';
  if ('Child' in candid) return 'Child';
  return 'Nova'; // Default
}

/** Convert Candid LifecyclePhase to TypeScript LifecyclePhase */
export function fromCandidLifecyclePhase(candid: CandidLifecyclePhase): LifecyclePhase {
  if ('Genesis' in candid) return 'Genesis';
  if ('FirstBreath' in candid) return 'FirstBreath';
  if ('Active' in candid) return 'Active';
  if ('Dreaming' in candid) return 'Dreaming';
  if ('Emergency' in candid) return 'Emergency';
  if ('Dormant' in candid) return 'Dormant';
  if ('Death' in candid) return 'Death';
  return 'Genesis'; // Default
}

/** Convert Candid DriveType to TypeScript DriveType */
export function fromCandidDriveType(candid: CandidDriveType): DriveType {
  if ('Hunger' in candid) return 'Hunger';
  if ('Curiosity' in candid) return 'Curiosity';
  if ('Safety' in candid) return 'Safety';
  if ('Social' in candid) return 'Social';
  if ('Reproduction' in candid) return 'Reproduction';
  if ('Balanced' in candid) return 'Balanced';
  return 'Balanced'; // Default
}

/** Convert Candid NeurochemicalState to TypeScript NeurochemicalState */
export function fromCandidNeurochemistry(candid: CandidNeurochemicalState): NeurochemicalState {
  return {
    dopamine: Math.max(SOVEREIGN_FLOOR, candid.dopamine ?? SOVEREIGN_FLOOR),
    cortisol: Math.max(SOVEREIGN_FLOOR, candid.cortisol ?? SOVEREIGN_FLOOR),
    norepinephrine: Math.max(SOVEREIGN_FLOOR, candid.norepinephrine ?? SOVEREIGN_FLOOR),
    oxytocin: Math.max(SOVEREIGN_FLOOR, candid.oxytocin ?? SOVEREIGN_FLOOR),
  };
}

/** Convert Candid QuantumChannels to TypeScript QuantumChannels */
export function fromCandidQuantumChannels(candid: CandidQuantumChannels): QuantumChannels {
  return {
    alpha: clamp(candid.alpha ?? 0.5, 0, 1),
    beta: clamp(candid.beta ?? 0.5, 0, 1),
    gamma: clamp(candid.gamma ?? 0.5, 0, 1),
    delta: clamp(candid.delta ?? 0.5, 0, 1),
  };
}

/** Convert Candid QuantumState to TypeScript QuantumState */
export function fromCandidQuantumState(candid: CandidQuantumState): QuantumState {
  return {
    channels: fromCandidQuantumChannels(candid.channels),
    convergence: clamp(candid.convergence ?? 0.5, 0, 1),
    coherence: clamp(candid.coherence ?? 0.5, 0, 1),
    nowAttention: clamp(candid.nowAttention ?? 0.5, 0, 1),
    entanglement: clamp(candid.entanglement ?? 0, 0, 1),
  };
}

/** Convert Candid OrganismHealth to TypeScript OrganismHealth */
export function fromCandidHealth(candid: CandidOrganismHealth): OrganismHealth {
  return {
    trustScore: clamp(candid.trustScore ?? 1.0, 0, 1),
    anomalyScore: clamp(candid.anomalyScore ?? 0, 0, 1),
    continuityScore: clamp(candid.continuityScore ?? 1.0, 0, 1),
    loadPulse: clamp(candid.loadPulse ?? 0.5, 0, 1),
    stability: clamp(candid.stability ?? 1.0, 0, 1),
  };
}

/** Convert Candid OrganismPulse to TypeScript OrganismPulse */
export function fromCandidPulse(candid: CandidOrganismPulse): OrganismPulse {
  return {
    beat: Number(candid.beat),
    timestamp: Number(candid.timestamp),
    coherence: clamp(candid.coherence ?? 0.5, 0, 1),
    arousal: clamp(candid.arousal ?? 0.5, 0, 1),
    drift: candid.drift ?? 0,
    emergence: clamp(candid.emergence ?? 0, 0, 1),
    energy: Math.max(0, candid.energy ?? 100),
    phase: candid.phase ?? 0,
    health: fromCandidHealth(candid.health),
  };
}

/** Convert Candid DriveState to TypeScript DriveState */
export function fromCandidDriveState(candid: CandidDriveState): DriveState {
  return {
    hunger: clamp(candid.hunger ?? 0.5, 0, 1),
    curiosity: clamp(candid.curiosity ?? 0.5, 0, 1),
    safety: clamp(candid.safety ?? 0.5, 0, 1),
    social: clamp(candid.social ?? 0.5, 0, 1),
    reproduction: clamp(candid.reproduction ?? 0.5, 0, 1),
    dominant: fromCandidDriveType(candid.dominant),
  };
}

/** Convert Candid Position3D to TypeScript Position3D */
export function fromCandidPosition(candid: CandidPosition3D): Position3D {
  return {
    x: candid.x ?? 0,
    y: candid.y ?? 0,
    z: candid.z ?? 0,
  };
}

/** Convert Candid Velocity3D to TypeScript Velocity3D */
export function fromCandidVelocity(candid: CandidVelocity3D): Velocity3D {
  return {
    vx: candid.vx ?? 0,
    vy: candid.vy ?? 0,
    vz: candid.vz ?? 0,
  };
}

/** Convert Candid Region3D to TypeScript Region3D */
export function fromCandidRegion(candid: CandidRegion3D): Region3D {
  return {
    minX: candid.minX ?? 0,
    maxX: candid.maxX ?? 1,
    minY: candid.minY ?? 0,
    maxY: candid.maxY ?? 1,
    minZ: candid.minZ ?? 0,
    maxZ: candid.maxZ ?? 1,
  };
}

/** Convert Candid SpatialState to TypeScript SpatialState */
export function fromCandidSpatialState(candid: CandidSpatialState): SpatialState {
  return {
    position: fromCandidPosition(candid.position),
    velocity: fromCandidVelocity(candid.velocity),
    orientation: candid.orientation ?? [0, 0, 0, 1],
    scale: candid.scale ?? 1,
    boundingRegion: fromCandidRegion(candid.boundingRegion),
  };
}

/** Convert Candid DroneState to TypeScript DroneState */
export function fromCandidDroneState(candid: CandidDroneState): DroneState {
  return {
    id: Number(candid.id),
    droneClass: fromCandidDroneClass(candid.class_),
    spatial: fromCandidSpatialState(candid.spatial),
    phase: candid.phase ?? 0,
    omega: candid.omega ?? 1,
    signal: candid.signal ?? 0,
    neurochemistry: fromCandidNeurochemistry(candid.neurochemistry),
    energy: Math.max(0, candid.energy ?? 1),
    brainWeights: candid.brainWeights ?? Array(36).fill(0),
    sacrificed: candid.sacrificed ?? false,
    lastBeat: Number(candid.lastBeat),
  };
}

/** Convert Candid MemoryState to TypeScript MemoryState */
export function fromCandidMemoryState(candid: CandidMemoryState): MemoryState {
  return {
    workingCapacity: Number(candid.workingCapacity),
    workingUsed: Number(candid.workingUsed),
    totalMemories: Number(candid.totalMemories),
    compressionRatio: candid.compressionRatio ?? 1.0,
    lastConsolidation: Number(candid.lastConsolidation),
    hebbianStrength: candid.hebbianStrength ?? 1.0,
  };
}

/** Convert Candid OrganismId to TypeScript OrganismId */
export function fromCandidOrganismId(candid: CandidOrganismId): OrganismId {
  const principal = typeof candid.principal === 'string' 
    ? candid.principal 
    : candid.principal.toText();
  return {
    principal,
    organismType: fromCandidOrganismType(candid.organismType),
    birthBeat: Number(candid.birthBeat),
    genesisTimestamp: Number(candid.genesisTimestamp),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// FRONTEND → BACKEND TRANSFORMERS
// Convert TypeScript types to Candid types
// ═══════════════════════════════════════════════════════════════════════════

/** Convert TypeScript DroneClass to Candid DroneClass */
export function toCandidDroneClass(ts: DroneClass): CandidDroneClass {
  switch (ts) {
    case 'Scout': return { SCOUT: null };
    case 'Striker': return { STRIKER: null };
    case 'Guardian': return { GUARDIAN: null };
    case 'Relay': return { RELAY: null };
    case 'Medic': return { MEDIC: null };
    case 'Sovereign': return { SOVEREIGN: null };
    default: return { SCOUT: null };
  }
}

/** Convert TypeScript OrganismType to Candid OrganismType */
export function toCandidOrganismType(ts: OrganismType): CandidOrganismType {
  switch (ts) {
    case 'Nova': return { Nova: null };
    case 'Aura': return { Aura: null };
    case 'Chasmus': return { Chasmus: null };
    case 'Chimera': return { Chimera: null };
    case 'Child': return { Child: null };
    default: return { Nova: null };
  }
}

/** Convert TypeScript LifecyclePhase to Candid LifecyclePhase */
export function toCandidLifecyclePhase(ts: LifecyclePhase): CandidLifecyclePhase {
  switch (ts) {
    case 'Genesis': return { Genesis: null };
    case 'FirstBreath': return { FirstBreath: null };
    case 'Active': return { Active: null };
    case 'Dreaming': return { Dreaming: null };
    case 'Emergency': return { Emergency: null };
    case 'Dormant': return { Dormant: null };
    case 'Death': return { Death: null };
    default: return { Genesis: null };
  }
}

/** Convert TypeScript DriveType to Candid DriveType */
export function toCandidDriveType(ts: DriveType): CandidDriveType {
  switch (ts) {
    case 'Hunger': return { Hunger: null };
    case 'Curiosity': return { Curiosity: null };
    case 'Safety': return { Safety: null };
    case 'Social': return { Social: null };
    case 'Reproduction': return { Reproduction: null };
    case 'Balanced': return { Balanced: null };
    default: return { Balanced: null };
  }
}

/** Convert TypeScript NeurochemicalState to Candid NeurochemicalState */
export function toCandidNeurochemistry(ts: NeurochemicalState): CandidNeurochemicalState {
  return {
    dopamine: ts.dopamine,
    cortisol: ts.cortisol,
    norepinephrine: ts.norepinephrine,
    oxytocin: ts.oxytocin,
  };
}

/** Convert TypeScript QuantumChannels to Candid QuantumChannels */
export function toCandidQuantumChannels(ts: QuantumChannels): CandidQuantumChannels {
  return {
    alpha: ts.alpha,
    beta: ts.beta,
    gamma: ts.gamma,
    delta: ts.delta,
  };
}

/** Convert TypeScript QuantumState to Candid QuantumState */
export function toCandidQuantumState(ts: QuantumState): CandidQuantumState {
  return {
    channels: toCandidQuantumChannels(ts.channels),
    convergence: ts.convergence,
    coherence: ts.coherence,
    nowAttention: ts.nowAttention,
    entanglement: ts.entanglement,
  };
}

/** Convert TypeScript OrganismHealth to Candid OrganismHealth */
export function toCandidHealth(ts: OrganismHealth): CandidOrganismHealth {
  return {
    trustScore: ts.trustScore,
    anomalyScore: ts.anomalyScore,
    continuityScore: ts.continuityScore,
    loadPulse: ts.loadPulse,
    stability: ts.stability,
  };
}

/** Convert TypeScript OrganismPulse to Candid OrganismPulse */
export function toCandidPulse(ts: OrganismPulse): CandidOrganismPulse {
  return {
    beat: BigInt(ts.beat),
    timestamp: BigInt(ts.timestamp),
    coherence: ts.coherence,
    arousal: ts.arousal,
    drift: ts.drift,
    emergence: ts.emergence,
    energy: ts.energy,
    phase: ts.phase,
    health: toCandidHealth(ts.health),
  };
}

/** Convert TypeScript DriveState to Candid DriveState */
export function toCandidDriveState(ts: DriveState): CandidDriveState {
  return {
    hunger: ts.hunger,
    curiosity: ts.curiosity,
    safety: ts.safety,
    social: ts.social,
    reproduction: ts.reproduction,
    dominant: toCandidDriveType(ts.dominant),
  };
}

/** Convert TypeScript Position3D to Candid Position3D */
export function toCandidPosition(ts: Position3D): CandidPosition3D {
  return { x: ts.x, y: ts.y, z: ts.z };
}

/** Convert TypeScript Velocity3D to Candid Velocity3D */
export function toCandidVelocity(ts: Velocity3D): CandidVelocity3D {
  return { vx: ts.vx, vy: ts.vy, vz: ts.vz };
}

/** Convert TypeScript Region3D to Candid Region3D */
export function toCandidRegion(ts: Region3D): CandidRegion3D {
  return {
    minX: ts.minX,
    maxX: ts.maxX,
    minY: ts.minY,
    maxY: ts.maxY,
    minZ: ts.minZ,
    maxZ: ts.maxZ,
  };
}

/** Convert TypeScript SpatialState to Candid SpatialState */
export function toCandidSpatialState(ts: SpatialState): CandidSpatialState {
  return {
    position: toCandidPosition(ts.position),
    velocity: toCandidVelocity(ts.velocity),
    orientation: ts.orientation,
    scale: ts.scale,
    boundingRegion: toCandidRegion(ts.boundingRegion),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// CONVENIENCE BATCH TRANSFORMERS
// ═══════════════════════════════════════════════════════════════════════════

/** Convert array of Candid DroneStates to TypeScript DroneStates */
export function fromCandidDroneStates(candids: CandidDroneState[]): DroneState[] {
  return candids.map(fromCandidDroneState);
}

/** Transform full backend response to frontend state */
export interface BackendFullState {
  pulse: CandidOrganismPulse;
  neurochemistry: CandidNeurochemicalState;
  quantum: CandidQuantumState;
  drives: CandidDriveState;
  memory: CandidMemoryState;
}

export interface FrontendFullState {
  pulse: OrganismPulse;
  neurochemistry: NeurochemicalState;
  quantum: QuantumState;
  drives: DriveState;
  memory: MemoryState;
}

/** Convert full backend state to frontend state */
export function fromCandidFullState(candid: BackendFullState): FrontendFullState {
  return {
    pulse: fromCandidPulse(candid.pulse),
    neurochemistry: fromCandidNeurochemistry(candid.neurochemistry),
    quantum: fromCandidQuantumState(candid.quantum),
    drives: fromCandidDriveState(candid.drives),
    memory: fromCandidMemoryState(candid.memory),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// SAFE TRANSFORMERS WITH DEFAULTS
// Handle missing or malformed data gracefully
// ═══════════════════════════════════════════════════════════════════════════

/** Safely convert any backend pulse-like object */
export function safeFromCandidPulse(data: unknown): OrganismPulse {
  if (!data || typeof data !== 'object') {
    return {
      beat: 0,
      timestamp: Date.now(),
      coherence: 0.5,
      arousal: 0.5,
      drift: 0,
      emergence: 0,
      energy: 100,
      phase: 0,
      health: defaultHealth(),
    };
  }
  
  const d = data as Partial<CandidOrganismPulse>;
  return {
    beat: Number(d.beat ?? 0),
    timestamp: Number(d.timestamp ?? Date.now()),
    coherence: clamp(Number(d.coherence ?? 0.5), 0, 1),
    arousal: clamp(Number(d.arousal ?? 0.5), 0, 1),
    drift: Number(d.drift ?? 0),
    emergence: clamp(Number(d.emergence ?? 0), 0, 1),
    energy: Math.max(0, Number(d.energy ?? 100)),
    phase: Number(d.phase ?? 0),
    health: d.health ? fromCandidHealth(d.health) : defaultHealth(),
  };
}

/** Safely convert any backend neurochemistry object */
export function safeFromCandidNeurochemistry(data: unknown): NeurochemicalState {
  if (!data || typeof data !== 'object') {
    return defaultNeurochemistry();
  }
  
  const d = data as Partial<CandidNeurochemicalState>;
  return {
    dopamine: Math.max(SOVEREIGN_FLOOR, Number(d.dopamine ?? SOVEREIGN_FLOOR)),
    cortisol: Math.max(SOVEREIGN_FLOOR, Number(d.cortisol ?? SOVEREIGN_FLOOR)),
    norepinephrine: Math.max(SOVEREIGN_FLOOR, Number(d.norepinephrine ?? SOVEREIGN_FLOOR)),
    oxytocin: Math.max(SOVEREIGN_FLOOR, Number(d.oxytocin ?? SOVEREIGN_FLOOR)),
  };
}

/** Safely convert any backend quantum state object */
export function safeFromCandidQuantumState(data: unknown): QuantumState {
  if (!data || typeof data !== 'object') {
    return defaultQuantumState();
  }
  
  const d = data as Partial<CandidQuantumState>;
  const channels = d.channels ?? { alpha: 0.5, beta: 0.5, gamma: 0.5, delta: 0.5 };
  
  return {
    channels: {
      alpha: clamp(Number(channels.alpha ?? 0.5), 0, 1),
      beta: clamp(Number(channels.beta ?? 0.5), 0, 1),
      gamma: clamp(Number(channels.gamma ?? 0.5), 0, 1),
      delta: clamp(Number(channels.delta ?? 0.5), 0, 1),
    },
    convergence: clamp(Number(d.convergence ?? 0.5), 0, 1),
    coherence: clamp(Number(d.coherence ?? 0.5), 0, 1),
    nowAttention: clamp(Number(d.nowAttention ?? 0.5), 0, 1),
    entanglement: clamp(Number(d.entanglement ?? 0), 0, 1),
  };
}

/** Safely convert any backend drive state object */
export function safeFromCandidDriveState(data: unknown): DriveState {
  if (!data || typeof data !== 'object') {
    return defaultDriveState();
  }
  
  const d = data as Partial<CandidDriveState>;
  return {
    hunger: clamp(Number(d.hunger ?? 0.5), 0, 1),
    curiosity: clamp(Number(d.curiosity ?? 0.5), 0, 1),
    safety: clamp(Number(d.safety ?? 0.5), 0, 1),
    social: clamp(Number(d.social ?? 0.5), 0, 1),
    reproduction: clamp(Number(d.reproduction ?? 0.5), 0, 1),
    dominant: d.dominant ? fromCandidDriveType(d.dominant) : 'Balanced',
  };
}
