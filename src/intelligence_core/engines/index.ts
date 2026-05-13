// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA ENGINES — Core System Foundation (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE 4 CORE ENGINES — The "physics" of the organism:
//
//   CHRONO       — Time/scheduling engine (heartbeat, timers, phase sync)
//   NEXORIS      — State management engine (memory, attractors, coherence)
//   QUANTUM_FLUX — Entropy/randomness engine (stochastic processes, noise)
//   COREOGRAPH   — Orchestration engine (inter-agent messaging, routing)
//
// These engines form the foundation. All Agent Organs USE these engines.
// The engines are ALWAYS ON once awakened — they never stop until shutdown.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

export { CHRONO, ChronoEngine } from './CHRONO';
export type { ChronoState, ChronoTimer } from './CHRONO';
export { 
  HEARTBEAT_MS, 
  HEARTBEAT_HZ,
  TICK_ULTRA_FAST,
  TICK_FAST,
  TICK_NORMAL,
  TICK_SLOW,
  TICK_GLACIAL,
  TICK_GEOLOGICAL,
} from './CHRONO';

export { NEXORIS, NexorisEngine } from './NEXORIS';
export type { NexorisState, StateSlice, StateValue, StateTransition } from './NEXORIS';

export { QUANTUM_FLUX, QuantumFluxEngine } from './QUANTUM_FLUX';
export type { QuantumFluxState, EntropyPool } from './QUANTUM_FLUX';

export { COREOGRAPH, CoreographEngine } from './COREOGRAPH';
export type { 
  CoreographState, 
  Message, 
  MessagePriority, 
  Route, 
  AgentHandle 
} from './COREOGRAPH';

// ═══════════════════════════════════════════════════════════════════════════════
// COMBINED ENGINE DIAGNOSTICS
// ═══════════════════════════════════════════════════════════════════════════════

import { CHRONO } from './CHRONO';
import { NEXORIS } from './NEXORIS';
import { QUANTUM_FLUX } from './QUANTUM_FLUX';
import { COREOGRAPH } from './COREOGRAPH';

export interface EngineDiagnostics {
  chrono: ReturnType<typeof CHRONO.getDiagnostics>;
  nexoris: ReturnType<typeof NEXORIS.getDiagnostics>;
  quantumFlux: ReturnType<typeof QUANTUM_FLUX.getDiagnostics>;
  coreograph: ReturnType<typeof COREOGRAPH.getDiagnostics>;
  allRunning: boolean;
}

export function getEngineDiagnostics(): EngineDiagnostics {
  return {
    chrono: CHRONO.getDiagnostics(),
    nexoris: NEXORIS.getDiagnostics(),
    quantumFlux: QUANTUM_FLUX.getDiagnostics(),
    coreograph: COREOGRAPH.getDiagnostics(),
    allRunning: CHRONO.isRunning(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// ENGINE AWAKENING — Start all engines together
// ═══════════════════════════════════════════════════════════════════════════════

export function awakenEngines(): void {
  // Start the heartbeat (CHRONO drives everything)
  CHRONO.awaken();
  
  // Subscribe engines to heartbeat
  CHRONO.subscribeHeartbeat('NEXORIS', () => NEXORIS.tick());
  CHRONO.subscribeHeartbeat('QUANTUM_FLUX', () => QUANTUM_FLUX.tick());
  CHRONO.subscribeHeartbeat('COREOGRAPH', () => COREOGRAPH.tick());
}

export function shutdownEngines(): void {
  CHRONO.shutdown();
}
