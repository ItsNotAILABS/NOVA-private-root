// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// CHRONO ENGINE — Sovereign Time & Scheduling Engine (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// CHRONO is the "physics of time" for the organism. All timing, scheduling, and temporal
// coordination flows through here. This is NOT setTimeout wrappers — this is a living
// time engine with φ-scaled intervals, Kuramoto phase synchronization, and heartbeat
// coordination across all agents.
//
// Used by: ANIMUS (timing), SENSUS (perception cycles), MEMORIA (consolidation windows)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { PHI, PHI_INV, wrapPhase, TAU } from '../../frontend/src/math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const HEARTBEAT_MS = 873; // φ⁴ × Schumann period
export const HEARTBEAT_HZ = 1000 / HEARTBEAT_MS; // ~1.145 Hz

// φ-scaled timing intervals (ms)
export const TICK_ULTRA_FAST  = Math.round(HEARTBEAT_MS / PHI / PHI / PHI); // ~206ms
export const TICK_FAST        = Math.round(HEARTBEAT_MS / PHI / PHI);       // ~333ms
export const TICK_NORMAL      = Math.round(HEARTBEAT_MS / PHI);             // ~540ms
export const TICK_SLOW        = HEARTBEAT_MS;                                // 873ms
export const TICK_GLACIAL     = Math.round(HEARTBEAT_MS * PHI);             // ~1413ms
export const TICK_GEOLOGICAL  = Math.round(HEARTBEAT_MS * PHI * PHI);       // ~2286ms

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — CHRONO STATE
// ═══════════════════════════════════════════════════════════════════════════════

export interface ChronoTimer {
  id: string;
  callback: () => void;
  intervalMs: number;
  lastTickMs: number;
  phase: number;         // Kuramoto phase for synchronization
  naturalFreq: number;   // Natural frequency (Hz)
  coupling: number;      // Coupling strength to global heartbeat
  active: boolean;
  tickCount: number;
}

export interface ChronoState {
  beat: number;
  startTimeMs: number;
  lastBeatMs: number;
  globalPhase: number;
  timers: Map<string, ChronoTimer>;
  subscribers: Map<string, () => void>;
  running: boolean;
  intervalHandle: ReturnType<typeof setInterval> | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — CHRONO ENGINE CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class ChronoEngine {
  private state: ChronoState;

  constructor() {
    this.state = {
      beat: 0,
      startTimeMs: Date.now(),
      lastBeatMs: Date.now(),
      globalPhase: 0,
      timers: new Map(),
      subscribers: new Map(),
      running: false,
      intervalHandle: null,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // AWAKENING — Start the heartbeat
  // ─────────────────────────────────────────────────────────────────────────────

  awaken(): void {
    if (this.state.running) return;
    
    this.state.running = true;
    this.state.startTimeMs = Date.now();
    this.state.lastBeatMs = Date.now();

    // Start the 873ms heartbeat — NEVER STOPS
    this.state.intervalHandle = setInterval(() => this._tick(), HEARTBEAT_MS);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TICK — The heartbeat pulse
  // ─────────────────────────────────────────────────────────────────────────────

  private _tick(): void {
    const now = Date.now();
    this.state.beat++;
    this.state.lastBeatMs = now;
    
    // Advance global phase (Kuramoto)
    this.state.globalPhase = wrapPhase(this.state.globalPhase + PHI_INV);

    // Tick all timers
    for (const [_id, timer] of this.state.timers) {
      if (!timer.active) continue;
      
      const elapsed = now - timer.lastTickMs;
      if (elapsed >= timer.intervalMs) {
        timer.lastTickMs = now;
        timer.tickCount++;
        
        // Phase synchronization with global heartbeat
        timer.phase = wrapPhase(
          timer.phase + 
          timer.naturalFreq * TAU * (elapsed / 1000) + 
          timer.coupling * Math.sin(this.state.globalPhase - timer.phase)
        );
        
        timer.callback();
      }
    }

    // Notify all heartbeat subscribers
    for (const [_id, callback] of this.state.subscribers) {
      callback();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TIMER REGISTRATION
  // ─────────────────────────────────────────────────────────────────────────────

  registerTimer(
    id: string,
    callback: () => void,
    intervalMs: number = TICK_NORMAL,
    coupling: number = PHI_INV
  ): void {
    const timer: ChronoTimer = {
      id,
      callback,
      intervalMs,
      lastTickMs: Date.now(),
      phase: Math.random() * TAU,
      naturalFreq: 1000 / intervalMs,
      coupling,
      active: true,
      tickCount: 0,
    };
    this.state.timers.set(id, timer);
  }

  unregisterTimer(id: string): void {
    this.state.timers.delete(id);
  }

  pauseTimer(id: string): void {
    const timer = this.state.timers.get(id);
    if (timer) timer.active = false;
  }

  resumeTimer(id: string): void {
    const timer = this.state.timers.get(id);
    if (timer) {
      timer.active = true;
      timer.lastTickMs = Date.now();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HEARTBEAT SUBSCRIPTION
  // ─────────────────────────────────────────────────────────────────────────────

  subscribeHeartbeat(id: string, callback: () => void): void {
    this.state.subscribers.set(id, callback);
  }

  unsubscribeHeartbeat(id: string): void {
    this.state.subscribers.delete(id);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // QUERIES
  // ─────────────────────────────────────────────────────────────────────────────

  getBeat(): number {
    return this.state.beat;
  }

  getPhase(): number {
    return this.state.globalPhase;
  }

  getElapsedMs(): number {
    return Date.now() - this.state.startTimeMs;
  }

  getTimerPhases(): Map<string, number> {
    const phases = new Map<string, number>();
    for (const [id, timer] of this.state.timers) {
      phases.set(id, timer.phase);
    }
    return phases;
  }

  computeSynchronization(): number {
    const phases: number[] = [];
    for (const [_id, timer] of this.state.timers) {
      phases.push(timer.phase);
    }
    if (phases.length === 0) return 1;
    
    // Kuramoto order parameter
    const sumCos = phases.reduce((s, p) => s + Math.cos(p), 0) / phases.length;
    const sumSin = phases.reduce((s, p) => s + Math.sin(p), 0) / phases.length;
    return Math.sqrt(sumCos * sumCos + sumSin * sumSin);
  }

  isRunning(): boolean {
    return this.state.running;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SHUTDOWN
  // ─────────────────────────────────────────────────────────────────────────────

  shutdown(): void {
    if (this.state.intervalHandle) {
      clearInterval(this.state.intervalHandle);
      this.state.intervalHandle = null;
    }
    this.state.running = false;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DIAGNOSTICS
  // ─────────────────────────────────────────────────────────────────────────────

  getDiagnostics(): {
    beat: number;
    running: boolean;
    globalPhase: number;
    timerCount: number;
    subscriberCount: number;
    synchronization: number;
    elapsedMs: number;
  } {
    return {
      beat: this.state.beat,
      running: this.state.running,
      globalPhase: this.state.globalPhase,
      timerCount: this.state.timers.size,
      subscriberCount: this.state.subscribers.size,
      synchronization: this.computeSynchronization(),
      elapsedMs: this.getElapsedMs(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLETON EXPORT
// ═══════════════════════════════════════════════════════════════════════════════

export const CHRONO = new ChronoEngine();
