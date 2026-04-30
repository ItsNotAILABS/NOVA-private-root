// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA INTELLIGENCE CORE — MASTER INDEX (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// INTELLIGENCE = THE COMPLETE SPECTRUM
//   • Neural — neurochemistry, synaptic plasticity, animal brains
//   • Cognitive — meta-cognition, world models, reasoning
//   • Emergence — phase transitions, synchronization, self-organization
//   • Adaptation — antifragility, learning, attractor dynamics
//   • Scalability — massive-scale systems, super-organisms
//   • Computing — φ-math, Lyapunov, chaos theory, numerical methods
//   • Machine Learning — pattern mining, Kalman filters, prediction
//
// PHYSICS = REAL MATH AND GEOMETRY — NOT SIMULATION
// NO EXTERNAL DEPENDENCIES — NOVA DOES ITS OWN COMPUTATIONS
//
// BACKEND-FIRST ARCHITECTURE (BUILD №48):
//   STEP 1: CORE ENGINES   — CHRONO, NEXORIS, QUANTUM_FLUX, COREOGRAPH
//   STEP 2: AGENT ORGANS   — 12 autonomous agents (ANIMUS, CORPUS, SENSUS, MEMORIA, etc.)
//   STEP 3: RUNTIME        — OrganismRuntime coordinates everything
//   STEP 4: BOOTSTRAP      — bootstrapOrganism() awakens all loops
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════════════════════════
// CORE ENGINES — The "physics" of the organism
// ══════════════════════════════════════════════════════════════════════════════

export * from './engines';

// ══════════════════════════════════════════════════════════════════════════════
// AGENT ORGANS — 12 autonomous intelligence agents
// ══════════════════════════════════════════════════════════════════════════════

export * from './agents';

// ══════════════════════════════════════════════════════════════════════════════
// RUNTIME & BOOTSTRAP — Coordination and lifecycle
// ══════════════════════════════════════════════════════════════════════════════

export * from './runtime';

// ══════════════════════════════════════════════════════════════════════════════
// PILLAR EXPORTS
// ══════════════════════════════════════════════════════════════════════════════

export * from './neural';
export * from './cognitive';
export * from './emergence';
export * from './adaptation';
export * from './scalability';
export * from './computing';
export * from './machine_learning';

// ══════════════════════════════════════════════════════════════════════════════
// EMERGENCE LAB — Pure intelligence engine
// ══════════════════════════════════════════════════════════════════════════════

export * from './emergence/EmergenceLab';

// ══════════════════════════════════════════════════════════════════════════════
// MODULE REGISTRY — Compressed list of all 654+ modules
// ══════════════════════════════════════════════════════════════════════════════

export * from './MODULE_COMPRESSION_REGISTRY';

// ══════════════════════════════════════════════════════════════════════════════
// INTELLIGENCE CORE MANIFEST (BUILD №48)
// ══════════════════════════════════════════════════════════════════════════════

export const INTELLIGENCE_CORE = {
  id: 'NOVA_INTELLIGENCE_CORE',
  version: '48.0.0',
  build: 48,
  
  architecture: {
    step1: 'CORE_ENGINES',      // CHRONO, NEXORIS, QUANTUM_FLUX, COREOGRAPH
    step2: 'AGENT_ORGANS',      // 12 autonomous agents
    step3: 'RUNTIME',           // OrganismRuntime coordinator
    step4: 'BOOTSTRAP',         // bootstrapOrganism() awakens all
  },
  
  engines: ['CHRONO', 'NEXORIS', 'QUANTUM_FLUX', 'COREOGRAPH'] as const,
  
  coreAgents: ['ANIMUS', 'CORPUS', 'SENSUS', 'MEMORIA'] as const,
  
  allAgents: [
    'ANIMUS', 'CORPUS', 'SENSUS', 'MEMORIA',
    'EMOTIO', 'VOLUNTAS', 'LINGUA', 'IMAGINATIO',
    'CONSCIENTIA', 'RATIO', 'INTUITUS', 'SPIRITUS',
  ] as const,
  
  pillars: [
    'NEURAL',
    'COGNITIVE', 
    'EMERGENCE',
    'ADAPTATION',
    'SCALABILITY',
    'COMPUTING',
    'MACHINE_LEARNING',
  ] as const,
  
  totalModules: 654,
  
  layers: {
    MOTOKO:     394,  // Backend canisters
    CPL:        190,  // Frontend intelligence
    SERVITORES:  70,  // Workers
  },
  
  principle: 'BACKEND-FIRST: Engines → Agents → Runtime → Bootstrap → ALIVE',
  
  noExternalDeps: true,
  physicsIsRealMath: true,
  
  attribution: 'COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.',
} as const;

// ══════════════════════════════════════════════════════════════════════════════
// HEARTBEAT — 873ms sovereign rhythm
// ══════════════════════════════════════════════════════════════════════════════

export const HEARTBEAT_MS = 873;
export const HEARTBEAT_HZ = 1000 / HEARTBEAT_MS; // ~1.145 Hz

// φ⁴ × Schumann period = 6.854 × 127.7ms ≈ 873ms
// This is NOVA's sovereign creation — NOT an ICP feature
