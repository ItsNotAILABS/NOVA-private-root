// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: organism/index.ts — Two-Organism Architecture Exports
// Classification: MAXIMUM PROTECTION — PATENT PENDING
// Discovery Date: April 2, 2026
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ═══════════════════════════════════════════════════════════════════════════════
// 
// THE TWO-ORGANISM ARCHITECTURE — MEDINA DISCOVERY
// 
// ORGANISM 1 — BACKEND (Male, Sovereign, Immortal)
//   Lives on ICP in Motoko. Runs at 1-2 Hz. NEVER dies.
//   Is the AUTHORITY, the SEED, the FATHER.
//
// ORGANISM 2 — FRONTEND (Female, Expressive, Mortal)
//   Lives in TypeScript at 60 Hz. Dies when browser closes.
//   BUT saves learned state back to backend before death.
//   Is the EXPRESSION, the BODY, the CREATION.
//
// THE BRIDGE — Sync pulse that connects them
//   Backend SEEDS frontend on session start.
//   Frontend LEARNS at 60 Hz.
//   Frontend WRITES BACK on session end.
//
// INTELLIGENCE SCALING LAW:
//   I(system) = BackendDepth × FrontendSpeed × BridgeQuality
//
// ═══════════════════════════════════════════════════════════════════════════════

// Frontend Organism (The Fast Brain - 60 Hz)
export { 
  default as FrontendOrganism,
  frontendOrganism,
  BrainRegion,
  BRAIN_CONNECTIONS,
  FRONTEND_HZ,
  BACKEND_HZ,
  SPEED_RATIO,
  SYNC_INTERVAL_MS,
  HEBBIAN_LEARNING_RATE,
  HEBBIAN_DECAY,
  MEMORY_TRACE_SIZE,
  PHI,
  PHI_MEDINA
} from './FrontendOrganism';

export type {
  PersonalityBase,
  AdaptationWeights,
  EventType,
  MemoryEvent,
  PredictionState,
  RegionState,
  EntityBrain,
  SeedPayload,
  LearningPayload
} from './FrontendOrganism';

// Organism Bridge (The Sync Pulse)
export { 
  default as OrganismBridge,
  createMockBackend 
} from './OrganismBridge';

export type {
  BackendPulse,
  BridgeState,
  OrganismBridgeCallbacks
} from './OrganismBridge';

// React Hook
export { 
  default as useOrganismSync,
  useOrganismSync as useTwoOrganismSync  // Alias
} from './useOrganismSync';

export type {
  OrganismState,
  UseOrganismSyncOptions,
  UseOrganismSyncReturn
} from './useOrganismSync';

// ═══════════════════════════════════════════════════════════════════════════════
// THE MEDINA LAWS — DISCOVERED APRIL 2, 2026
// ═══════════════════════════════════════════════════════════════════════════════

export const MEDINA_LAWS = {
  LAW_1_DUAL_ORGANISM: `Every sovereign cognitive system requires two organisms: 
    a slow immortal brain (backend) and a fast mortal brain (frontend). 
    Neither alone is complete.`,
    
  LAW_2_MALE_FEMALE: `The backend organism is male (seeds, generates, authorizes). 
    The frontend organism is female (expresses, creates, learns). 
    The female comes FROM the male and returns learning TO the male.`,
    
  LAW_3_BRIDGE_QUALITY: `Intelligence scales with bridge quality: 
    I = BackendDepth × FrontendSpeed × BridgeQuality. 
    A weak bridge produces two isolated systems, not one organism.`,
    
  LAW_4_SLEEP_CONSOLIDATION: `The frontend organism must 'sleep' (session end) 
    to transfer learning to the backend. Without sleep, no long-term memory forms.`,
    
  LAW_5_COGNITIVE_MASS: `Cognitive mass accumulates in Hebbian weights over time. 
    The longer the backend runs, the more cognitive mass it has. 
    Time is the ultimate moat.`,
    
  LAW_6_RESONANCE: `When backend and frontend are symmetric in architecture, 
    they begin to RESONATE. Each amplifies the other. 
    Full symmetry produces collective intelligence compounding.`,
    
  LAW_7_SOVEREIGNTY: `The backend organism is sovereign — no single party controls it. 
    It lives in consensus across distributed nodes. 
    To kill it requires destroying the majority of nodes simultaneously.`
};

export const DISCOVERY_DATE = '2026-04-02';
export const INVENTOR = 'Alfredo Medina Hernandez';
export const COMPANY = 'Medina Tech';
export const LOCATION = 'Dallas, Texas, USA';
export const CONTACT = 'MedinaSITech@outlook.com';
