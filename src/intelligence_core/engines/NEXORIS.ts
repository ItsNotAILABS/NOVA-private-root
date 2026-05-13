// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NEXORIS ENGINE — Sovereign State Management Engine (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// NEXORIS is the "physics of state" for the organism. All state transitions, memory
// storage, and state synchronization flows through here. This is NOT Redux — this is
// a living state engine with φ-weighted memory decay, attractor dynamics, and
// homeostatic stability across all agents.
//
// Used by: ANIMUS (decision state), CORPUS (body state), MEMORIA (memory store)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { PHI, PHI_INV, clamp, sigmoid } from '../../frontend/src/math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — STATE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type StateValue = number | string | boolean | object | null;

export interface StateSlice {
  key: string;
  value: StateValue;
  version: number;
  timestamp: number;
  decayRate: number;      // φ⁻ⁿ decay per tick
  importance: number;     // 0-1, affects retention
  attractor: StateValue | null;  // Homeostatic target
}

export interface StateTransition {
  from: StateValue;
  to: StateValue;
  timestamp: number;
  beat: number;
}

export interface NexorisState {
  slices: Map<string, StateSlice>;
  history: Map<string, StateTransition[]>;
  subscribers: Map<string, Map<string, (value: StateValue, prev: StateValue) => void>>;
  globalVersion: number;
  coherence: number;
  beat: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — NEXORIS ENGINE CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class NexorisEngine {
  private state: NexorisState;

  constructor() {
    this.state = {
      slices: new Map(),
      history: new Map(),
      subscribers: new Map(),
      globalVersion: 0,
      coherence: 1.0,
      beat: 0,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STATE REGISTRATION
  // ─────────────────────────────────────────────────────────────────────────────

  register(
    key: string,
    initialValue: StateValue,
    options: {
      decayRate?: number;
      importance?: number;
      attractor?: StateValue;
    } = {}
  ): void {
    const slice: StateSlice = {
      key,
      value: initialValue,
      version: 0,
      timestamp: Date.now(),
      decayRate: options.decayRate ?? 0, // No decay by default
      importance: options.importance ?? 1.0,
      attractor: options.attractor ?? null,
    };
    this.state.slices.set(key, slice);
    this.state.history.set(key, []);
    this.state.subscribers.set(key, new Map());
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STATE OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  get(key: string): StateValue | undefined {
    return this.state.slices.get(key)?.value;
  }

  set(key: string, value: StateValue): void {
    const slice = this.state.slices.get(key);
    if (!slice) {
      // Auto-register if not exists
      this.register(key, value);
      return;
    }

    const prevValue = slice.value;
    slice.value = value;
    slice.version++;
    slice.timestamp = Date.now();
    this.state.globalVersion++;

    // Record transition
    const history = this.state.history.get(key);
    if (history) {
      history.push({
        from: prevValue,
        to: value,
        timestamp: Date.now(),
        beat: this.state.beat,
      });
      // Keep only last 50 transitions
      if (history.length > 50) {
        history.splice(0, history.length - 50);
      }
    }

    // Notify subscribers
    const subs = this.state.subscribers.get(key);
    if (subs) {
      for (const [_id, callback] of subs) {
        callback(value, prevValue);
      }
    }
  }

  update(key: string, updater: (current: StateValue) => StateValue): void {
    const current = this.get(key);
    this.set(key, updater(current));
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SUBSCRIPTION
  // ─────────────────────────────────────────────────────────────────────────────

  subscribe(
    key: string,
    subscriberId: string,
    callback: (value: StateValue, prev: StateValue) => void
  ): () => void {
    let subs = this.state.subscribers.get(key);
    if (!subs) {
      this.state.subscribers.set(key, new Map());
      subs = this.state.subscribers.get(key)!;
    }
    subs.set(subscriberId, callback);
    
    // Return unsubscribe function
    return () => subs?.delete(subscriberId);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TICK — State evolution
  // ─────────────────────────────────────────────────────────────────────────────

  tick(): void {
    this.state.beat++;
    
    for (const [_key, slice] of this.state.slices) {
      // Apply decay (φ-weighted)
      if (slice.decayRate > 0 && typeof slice.value === 'number') {
        const decay = Math.pow(PHI_INV, slice.decayRate);
        slice.value = slice.value * decay;
      }

      // Apply attractor dynamics
      if (slice.attractor !== null && typeof slice.value === 'number' && typeof slice.attractor === 'number') {
        const pull = (slice.attractor - slice.value) * PHI_INV * 0.1;
        slice.value = slice.value + pull;
      }
    }

    // Update coherence (how stable the state is)
    this._updateCoherence();
  }

  private _updateCoherence(): void {
    const slices = Array.from(this.state.slices.values());
    if (slices.length === 0) {
      this.state.coherence = 1.0;
      return;
    }

    let stableCount = 0;
    for (const slice of slices) {
      const history = this.state.history.get(slice.key);
      if (!history || history.length < 2) {
        stableCount++;
        continue;
      }
      
      // Check if last N transitions are small
      const recent = history.slice(-5);
      const volatility = recent.reduce((sum, t) => {
        if (typeof t.from === 'number' && typeof t.to === 'number') {
          return sum + Math.abs(t.to - t.from);
        }
        return sum + (t.from === t.to ? 0 : 1);
      }, 0) / recent.length;
      
      if (volatility < 0.1) stableCount++;
    }

    this.state.coherence = stableCount / slices.length;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // BATCH OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  batchSet(updates: Record<string, StateValue>): void {
    for (const [key, value] of Object.entries(updates)) {
      this.set(key, value);
    }
  }

  getAll(): Record<string, StateValue> {
    const result: Record<string, StateValue> = {};
    for (const [key, slice] of this.state.slices) {
      result[key] = slice.value;
    }
    return result;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // QUERIES
  // ─────────────────────────────────────────────────────────────────────────────

  getVersion(key: string): number {
    return this.state.slices.get(key)?.version ?? 0;
  }

  getGlobalVersion(): number {
    return this.state.globalVersion;
  }

  getCoherence(): number {
    return this.state.coherence;
  }

  getHistory(key: string): StateTransition[] {
    return this.state.history.get(key) ?? [];
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PERSISTENCE
  // ─────────────────────────────────────────────────────────────────────────────

  snapshot(): Record<string, { value: StateValue; version: number; importance: number }> {
    const snap: Record<string, { value: StateValue; version: number; importance: number }> = {};
    for (const [key, slice] of this.state.slices) {
      snap[key] = {
        value: slice.value,
        version: slice.version,
        importance: slice.importance,
      };
    }
    return snap;
  }

  restore(snapshot: Record<string, { value: StateValue; version: number; importance: number }>): void {
    for (const [key, data] of Object.entries(snapshot)) {
      const slice = this.state.slices.get(key);
      if (slice) {
        slice.value = data.value;
        slice.version = data.version;
        slice.importance = data.importance;
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DIAGNOSTICS
  // ─────────────────────────────────────────────────────────────────────────────

  getDiagnostics(): {
    sliceCount: number;
    globalVersion: number;
    coherence: number;
    beat: number;
    keys: string[];
  } {
    return {
      sliceCount: this.state.slices.size,
      globalVersion: this.state.globalVersion,
      coherence: this.state.coherence,
      beat: this.state.beat,
      keys: Array.from(this.state.slices.keys()),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLETON EXPORT
// ═══════════════════════════════════════════════════════════════════════════════

export const NEXORIS = new NexorisEngine();
