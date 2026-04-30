// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// BASE AGENT — Abstract Agent Foundation (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// BaseAgent is the foundation for all 12 Agent Organs. Each agent has:
//   - An ID and family name (Latin naming convention)
//   - A heartbeat subscription (873ms tick)
//   - State management via NEXORIS
//   - Communication via COREOGRAPH
//   - Entropy access via QUANTUM_FLUX
//
// Agents are AUTONOMOUS — once awakened, they run their own loops and make their own decisions.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { CHRONO, TICK_NORMAL } from '../engines/CHRONO';
import { NEXORIS, StateValue } from '../engines/NEXORIS';
import { COREOGRAPH, Message } from '../engines/COREOGRAPH';
import { QUANTUM_FLUX } from '../engines/QUANTUM_FLUX';
import { PHI, PHI_INV } from '../../frontend/src/math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — AGENT TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type AgentStatus = 'DORMANT' | 'AWAKENING' | 'ALIVE' | 'SLEEPING' | 'DEAD';

export interface AgentConfig {
  id: string;
  family: string;
  tickInterval: number;
  priority: number;
}

export interface AgentState {
  id: string;
  family: string;
  status: AgentStatus;
  beat: number;
  lastTickMs: number;
  phase: number;
  energy: number;        // 0-1, φ-decays if inactive
  coherence: number;     // Sync with other agents
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — BASE AGENT CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export abstract class BaseAgent {
  protected config: AgentConfig;
  protected _state: AgentState;
  protected _timerId: string;

  constructor(config: AgentConfig) {
    this.config = config;
    this._timerId = `AGENT_${config.id}`;
    
    this._state = {
      id: config.id,
      family: config.family,
      status: 'DORMANT',
      beat: 0,
      lastTickMs: Date.now(),
      phase: Math.random() * Math.PI * 2,
      energy: 1.0,
      coherence: 0.5,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────────────────────

  awaken(): void {
    if (this._state.status === 'ALIVE') return;
    
    this._state.status = 'AWAKENING';
    
    // Register with COREOGRAPH
    COREOGRAPH.registerAgent(this.config.id, (msg) => this._handleMessage(msg));
    COREOGRAPH.setAgentStatus(this.config.id, 'ALIVE');
    
    // Initialize state in NEXORIS
    this._initializeState();
    
    // Register timer with CHRONO
    CHRONO.registerTimer(
      this._timerId,
      () => this._tick(),
      this.config.tickInterval,
      PHI_INV * this.config.priority
    );
    
    this._state.status = 'ALIVE';
    this._state.lastTickMs = Date.now();
    
    // Call subclass initialization
    this.onAwaken();
  }

  sleep(): void {
    if (this._state.status !== 'ALIVE') return;
    
    this._state.status = 'SLEEPING';
    CHRONO.pauseTimer(this._timerId);
    COREOGRAPH.setAgentStatus(this.config.id, 'SLEEPING');
    
    this.onSleep();
  }

  wake(): void {
    if (this._state.status !== 'SLEEPING') return;
    
    this._state.status = 'ALIVE';
    CHRONO.resumeTimer(this._timerId);
    COREOGRAPH.setAgentStatus(this.config.id, 'ALIVE');
    
    this.onWake();
  }

  shutdown(): void {
    this._state.status = 'DEAD';
    CHRONO.unregisterTimer(this._timerId);
    COREOGRAPH.unregisterAgent(this.config.id);
    
    this.onShutdown();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TICK — The autonomous loop
  // ─────────────────────────────────────────────────────────────────────────────

  private _tick(): void {
    if (this._state.status !== 'ALIVE') return;
    
    this._state.beat++;
    this._state.lastTickMs = Date.now();
    
    // Energy decay (φ-weighted)
    this._state.energy = Math.max(0.1, this._state.energy * (1 - PHI_INV * 0.01));
    
    // Phase advancement
    this._state.phase = (this._state.phase + PHI_INV) % (Math.PI * 2);
    
    // Process inbox
    this._processInbox();
    
    // Call subclass tick
    this.onTick();
    
    // Restore energy if active
    if (this._state.beat % 10 === 0) {
      this._state.energy = Math.min(1.0, this._state.energy + 0.05);
    }
  }

  private _processInbox(): void {
    let msg = COREOGRAPH.popInbox(this.config.id);
    while (msg) {
      this._handleMessage(msg);
      msg = COREOGRAPH.popInbox(this.config.id);
    }
  }

  private _handleMessage(msg: Message): void {
    // Energy boost from communication
    this._state.energy = Math.min(1.0, this._state.energy + 0.01);
    
    // Call subclass message handler
    this.onMessage(msg);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STATE MANAGEMENT (via NEXORIS)
  // ─────────────────────────────────────────────────────────────────────────────

  protected _initializeState(): void {
    NEXORIS.register(`${this.config.id}:status`, this._state.status);
    NEXORIS.register(`${this.config.id}:energy`, this._state.energy);
    NEXORIS.register(`${this.config.id}:phase`, this._state.phase);
  }

  protected setState(key: string, value: StateValue): void {
    NEXORIS.set(`${this.config.id}:${key}`, value);
  }

  protected getState(key: string): StateValue | undefined {
    return NEXORIS.get(`${this.config.id}:${key}`);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // COMMUNICATION (via COREOGRAPH)
  // ─────────────────────────────────────────────────────────────────────────────

  protected send(type: string, target: string, payload: unknown): void {
    COREOGRAPH.send(type, this.config.id, target, payload);
  }

  protected broadcast(type: string, payload: unknown): void {
    COREOGRAPH.broadcast(type, this.config.id, payload);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // RANDOMNESS (via QUANTUM_FLUX)
  // ─────────────────────────────────────────────────────────────────────────────

  protected random(): number {
    return QUANTUM_FLUX.random();
  }

  protected gaussian(mean: number = 0, stddev: number = 1): number {
    return QUANTUM_FLUX.gaussian(mean, stddev);
  }

  protected phiNoise(amplitude: number = 1): number {
    return QUANTUM_FLUX.phiNoise(amplitude);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // QUERIES
  // ─────────────────────────────────────────────────────────────────────────────

  getId(): string {
    return this.config.id;
  }

  getFamily(): string {
    return this.config.family;
  }

  getStatus(): AgentStatus {
    return this._state.status;
  }

  getBeat(): number {
    return this._state.beat;
  }

  getEnergy(): number {
    return this._state.energy;
  }

  getPhase(): number {
    return this._state.phase;
  }

  getState(): Readonly<AgentState> {
    return { ...this._state };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ABSTRACT METHODS (implemented by subclasses)
  // ─────────────────────────────────────────────────────────────────────────────

  protected abstract onAwaken(): void;
  protected abstract onTick(): void;
  protected abstract onMessage(msg: Message): void;
  protected abstract onSleep(): void;
  protected abstract onWake(): void;
  protected abstract onShutdown(): void;
}
