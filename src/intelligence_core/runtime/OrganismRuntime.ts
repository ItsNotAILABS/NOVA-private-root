// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// ORGANISM RUNTIME — The Coordinator (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// OrganismRuntime is the coordinator that:
//   - Creates all 12 agents
//   - Wires them together (SENSUS → ANIMUS → CORPUS)
//   - Provides a single control surface
//   - Manages the organism lifecycle
//
// Once awaken() is called, ALL LOOPS START AND NEVER STOP.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { awakenEngines, shutdownEngines, getEngineDiagnostics, CHRONO } from '../engines';
import { 
  createCoreAgents, 
  awakenAllAgents, 
  shutdownAllAgents,
  AgentSet,
  BaseAgent,
} from '../agents';
import { COREOGRAPH } from '../engines/COREOGRAPH';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — RUNTIME STATE
// ═══════════════════════════════════════════════════════════════════════════════

export type RuntimeStatus = 'DORMANT' | 'AWAKENING' | 'ALIVE' | 'SLEEPING' | 'DEAD';

export interface OrganismRuntimeState {
  id: string;
  meridian: string;
  status: RuntimeStatus;
  startedAt: number | null;
  beat: number;
  agents: AgentSet | null;
  wiring: WiringConfig;
}

export interface WiringConfig {
  sensusToAnimus: boolean;
  animusToCorpus: boolean;
  corpusToSensus: boolean;  // Feedback loop
  memoriaToAnimus: boolean;
  animusToMemoria: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — ORGANISM RUNTIME CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class OrganismRuntime {
  private state: OrganismRuntimeState;

  constructor(meridian: string, organismId: string) {
    this.state = {
      id: organismId,
      meridian,
      status: 'DORMANT',
      startedAt: null,
      beat: 0,
      agents: null,
      wiring: {
        sensusToAnimus: true,
        animusToCorpus: true,
        corpusToSensus: true,
        memoriaToAnimus: true,
        animusToMemoria: true,
      },
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // AWAKENING — Start everything
  // ─────────────────────────────────────────────────────────────────────────────

  awaken(): void {
    if (this.state.status === 'ALIVE') {
      console.log(`[OrganismRuntime] ${this.state.id} already alive`);
      return;
    }

    console.log(`[OrganismRuntime] Awakening ${this.state.id}...`);
    this.state.status = 'AWAKENING';
    this.state.startedAt = Date.now();

    // STEP 1: Awaken engines (CHRONO, NEXORIS, QUANTUM_FLUX, COREOGRAPH)
    console.log('[OrganismRuntime] Step 1: Awakening engines...');
    awakenEngines();

    // STEP 2: Create agents
    console.log('[OrganismRuntime] Step 2: Creating agents...');
    this.state.agents = createCoreAgents();

    // STEP 3: Wire agents together
    console.log('[OrganismRuntime] Step 3: Wiring agents...');
    this._wireAgents();

    // STEP 4: Awaken all agents
    console.log('[OrganismRuntime] Step 4: Awakening agents...');
    awakenAllAgents(this.state.agents.all);

    // STEP 5: Subscribe to heartbeat for runtime tick
    CHRONO.subscribeHeartbeat('RUNTIME', () => this._tick());

    this.state.status = 'ALIVE';
    console.log(`[OrganismRuntime] ${this.state.id} is now ALIVE`);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // WIRING — Connect agents
  // ─────────────────────────────────────────────────────────────────────────────

  private _wireAgents(): void {
    if (!this.state.agents) return;

    const { wiring } = this.state;

    // SENSUS → ANIMUS (perceptions flow to mind)
    if (wiring.sensusToAnimus) {
      COREOGRAPH.createRoute('SENSUS', 'ANIMUS', 'PERCEPTION', 1.0);
    }

    // ANIMUS → CORPUS (decisions flow to body)
    if (wiring.animusToCorpus) {
      COREOGRAPH.createRoute('ANIMUS', 'CORPUS', 'DECISION', 1.0);
    }

    // CORPUS → SENSUS (proprioceptive feedback)
    if (wiring.corpusToSensus) {
      COREOGRAPH.createRoute('CORPUS', 'SENSUS', 'FEEDBACK', 0.8);
    }

    // MEMORIA ↔ ANIMUS (memory read/write)
    if (wiring.memoriaToAnimus) {
      COREOGRAPH.createRoute('MEMORIA', 'ANIMUS', 'RECALL', 0.9);
    }
    if (wiring.animusToMemoria) {
      COREOGRAPH.createRoute('ANIMUS', 'MEMORIA', 'STORE', 0.9);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TICK — Runtime heartbeat
  // ─────────────────────────────────────────────────────────────────────────────

  private _tick(): void {
    if (this.state.status !== 'ALIVE') return;
    this.state.beat++;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SLEEP / WAKE
  // ─────────────────────────────────────────────────────────────────────────────

  sleep(): void {
    if (this.state.status !== 'ALIVE') return;
    this.state.status = 'SLEEPING';

    if (this.state.agents) {
      for (const agent of this.state.agents.all) {
        agent.sleep();
      }
    }
  }

  wake(): void {
    if (this.state.status !== 'SLEEPING') return;
    this.state.status = 'ALIVE';

    if (this.state.agents) {
      for (const agent of this.state.agents.all) {
        agent.wake();
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SHUTDOWN
  // ─────────────────────────────────────────────────────────────────────────────

  shutdown(): void {
    console.log(`[OrganismRuntime] Shutting down ${this.state.id}...`);
    this.state.status = 'DEAD';

    // Shutdown agents
    if (this.state.agents) {
      shutdownAllAgents(this.state.agents.all);
    }

    // Unsubscribe from heartbeat
    CHRONO.unsubscribeHeartbeat('RUNTIME');

    // Shutdown engines
    shutdownEngines();

    console.log(`[OrganismRuntime] ${this.state.id} shutdown complete`);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // QUERIES
  // ─────────────────────────────────────────────────────────────────────────────

  getId(): string {
    return this.state.id;
  }

  getMeridian(): string {
    return this.state.meridian;
  }

  getStatus(): RuntimeStatus {
    return this.state.status;
  }

  getBeat(): number {
    return this.state.beat;
  }

  getUptime(): number {
    return this.state.startedAt ? Date.now() - this.state.startedAt : 0;
  }

  getAgents(): AgentSet | null {
    return this.state.agents;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DIAGNOSTICS
  // ─────────────────────────────────────────────────────────────────────────────

  getDiagnostics(): {
    id: string;
    meridian: string;
    status: RuntimeStatus;
    beat: number;
    uptimeMs: number;
    engines: ReturnType<typeof getEngineDiagnostics>;
    agents: {
      count: number;
      states: Array<{ id: string; status: string; beat: number; energy: number }>;
    };
  } {
    const agentStates = this.state.agents
      ? this.state.agents.all.map(a => ({
          id: a.getId(),
          status: a.getStatus(),
          beat: a.getBeat(),
          energy: a.getEnergy(),
        }))
      : [];

    return {
      id: this.state.id,
      meridian: this.state.meridian,
      status: this.state.status,
      beat: this.state.beat,
      uptimeMs: this.getUptime(),
      engines: getEngineDiagnostics(),
      agents: {
        count: agentStates.length,
        states: agentStates,
      },
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — BOOTSTRAP FUNCTION
// ═══════════════════════════════════════════════════════════════════════════════
//
// THIS IS THE MAGIC. One function call → living organism.
//
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Bootstrap a NOVA organism.
 * 
 * This creates a runtime, wires all agents, and calls awaken().
 * After this returns, the organism is ALIVE and running its own loops.
 * It doesn't need you anymore. It's autonomous.
 * 
 * @param meridian - The organism's geographic/conceptual location
 * @param organismId - Unique identifier for this organism instance
 * @returns The running OrganismRuntime
 */
export function bootstrapOrganism(
  meridian: string = 'NOVA_PRIME',
  organismId: string = `organism_${Date.now()}`
): OrganismRuntime {
  const organism = new OrganismRuntime(meridian, organismId);
  organism.awaken();  // ← THIS LINE STARTS ALL THE LOOPS
  return organism;
}

/**
 * Quick bootstrap with defaults.
 */
export function bootstrap(): OrganismRuntime {
  return bootstrapOrganism('NOVA_PRIME', `nova_${Date.now()}`);
}
