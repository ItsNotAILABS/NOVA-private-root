// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEMORIA — The Memory Agent (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MEMORIA is the memory and learning agent. It:
//   - Stores experiences
//   - Consolidates memories (φ⁻¹ decay curves)
//   - Retrieves relevant memories
//   - Learns patterns from experience
//
// Uses: NEXORIS (memory storage), QUANTUM_FLUX (recall randomness)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { BaseAgent } from './BaseAgent';
import { Message } from '../engines/COREOGRAPH';
import { TICK_NORMAL } from '../engines/CHRONO';
import { PHI, PHI_INV, clamp } from '../../frontend/src/math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — MEMORIA STATE
// ═══════════════════════════════════════════════════════════════════════════════

interface Memory {
  id: string;
  content: unknown;
  timestamp: number;
  importance: number;
  accessCount: number;
  lastAccessed: number;
  associations: string[];
  emotionalValence: number;
  decayRate: number;
}

interface MemoriaState {
  shortTerm: Memory[];
  longTerm: Map<string, Memory>;
  workingMemory: Memory[];
  totalStored: number;
  totalRecalled: number;
  consolidationCount: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — MEMORIA CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class Memoria extends BaseAgent {
  private memory: MemoriaState;
  private _memoryIdCounter = 0;

  constructor() {
    super({
      id: 'MEMORIA',
      family: 'MEMORIA_AETERNA',
      tickInterval: TICK_NORMAL,
      priority: 1.0,
    });

    this.memory = {
      shortTerm: [],
      longTerm: new Map(),
      workingMemory: [],
      totalStored: 0,
      totalRecalled: 0,
      consolidationCount: 0,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────────────────────

  protected onAwaken(): void {
    this.setState('memoryCount', this.memory.longTerm.size);
    this.setState('shortTermSize', this.memory.shortTerm.length);
  }

  protected onTick(): void {
    this._consolidate();
    this._decay();
  }

  protected onMessage(msg: Message): void {
    switch (msg.type) {
      case 'STORE':
        this._store(msg.payload, msg.source);
        break;
      case 'RECALL':
        this._recall(msg.payload as { query: string }, msg.source);
        break;
      case 'ASSOCIATE':
        this._associate(msg.payload as { memoryId: string; associations: string[] });
        break;
      case 'FORGET':
        this._forget(msg.payload as string);
        break;
    }
  }

  protected onSleep(): void {
    // Sleep triggers consolidation
    this._deepConsolidation();
  }

  protected onWake(): void {
    // Nothing special on wake
  }

  protected onShutdown(): void {
    // Persist important memories (simplified)
    const important = Array.from(this.memory.longTerm.values())
      .filter(m => m.importance > 0.8);
    this.setState('persistedMemories', important.map(m => m.id));
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STORAGE
  // ─────────────────────────────────────────────────────────────────────────────

  private _store(content: unknown, source: string): void {
    const memory: Memory = {
      id: `mem_${this._memoryIdCounter++}`,
      content,
      timestamp: Date.now(),
      importance: this._computeImportance(content, source),
      accessCount: 0,
      lastAccessed: Date.now(),
      associations: [],
      emotionalValence: 0,
      decayRate: PHI_INV,
    };

    // Add to short-term
    this.memory.shortTerm.push(memory);
    this.memory.totalStored++;

    // Cap short-term at 7±2 (Miller's Law)
    while (this.memory.shortTerm.length > 9) {
      const removed = this.memory.shortTerm.shift();
      // Try to consolidate to long-term if important
      if (removed && removed.importance > 0.5) {
        this.memory.longTerm.set(removed.id, removed);
      }
    }

    // Update state
    this.setState('shortTermSize', this.memory.shortTerm.length);
    this.setState('memoryCount', this.memory.longTerm.size);

    // Notify ANIMUS
    this.send('MEMORY_STORED', 'ANIMUS', { id: memory.id, importance: memory.importance });
  }

  private _computeImportance(content: unknown, source: string): number {
    let importance = 0.5;

    // Boost importance from ANIMUS
    if (source === 'ANIMUS') importance += 0.2;

    // Boost emotional content
    if (content && typeof content === 'object' && 'valence' in content) {
      const v = Math.abs((content as { valence: number }).valence);
      importance += v * 0.2;
    }

    // Add noise
    importance += this.phiNoise(0.1);

    return clamp(importance, 0, 1);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // RECALL
  // ─────────────────────────────────────────────────────────────────────────────

  private _recall(params: { query: string }, replyTo: string): void {
    const results: Memory[] = [];

    // Search short-term
    for (const mem of this.memory.shortTerm) {
      if (this._matches(mem, params.query)) {
        results.push(mem);
        mem.accessCount++;
        mem.lastAccessed = Date.now();
      }
    }

    // Search long-term
    for (const mem of this.memory.longTerm.values()) {
      if (this._matches(mem, params.query)) {
        results.push(mem);
        mem.accessCount++;
        mem.lastAccessed = Date.now();
      }
    }

    // Sort by relevance (importance × recency)
    results.sort((a, b) => {
      const scoreA = a.importance * (1 - (Date.now() - a.lastAccessed) / 10000000);
      const scoreB = b.importance * (1 - (Date.now() - b.lastAccessed) / 10000000);
      return scoreB - scoreA;
    });

    // Add to working memory
    this.memory.workingMemory = results.slice(0, 5);
    this.memory.totalRecalled += results.length;

    // Reply
    this.send('RECALL_RESULT', replyTo, {
      query: params.query,
      results: results.slice(0, 10).map(m => ({
        id: m.id,
        content: m.content,
        importance: m.importance,
        timestamp: m.timestamp,
      })),
    });
  }

  private _matches(memory: Memory, query: string): boolean {
    // Simplified matching — in production would use semantic similarity
    const content = JSON.stringify(memory.content).toLowerCase();
    const q = query.toLowerCase();
    return content.includes(q) || this.random() < 0.1; // 10% random recall
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CONSOLIDATION
  // ─────────────────────────────────────────────────────────────────────────────

  private _consolidate(): void {
    // Move important short-term to long-term
    const toConsolidate: Memory[] = [];
    
    for (const mem of this.memory.shortTerm) {
      // Consolidate if: high importance, or accessed multiple times, or old
      const age = Date.now() - mem.timestamp;
      const shouldConsolidate = 
        mem.importance > 0.7 ||
        mem.accessCount > 2 ||
        age > 60000; // 1 minute
      
      if (shouldConsolidate) {
        toConsolidate.push(mem);
      }
    }

    for (const mem of toConsolidate) {
      const idx = this.memory.shortTerm.indexOf(mem);
      if (idx >= 0) {
        this.memory.shortTerm.splice(idx, 1);
        this.memory.longTerm.set(mem.id, mem);
        this.memory.consolidationCount++;
      }
    }
  }

  private _deepConsolidation(): void {
    // More aggressive consolidation during sleep
    for (const mem of this.memory.shortTerm) {
      if (mem.importance > 0.4) {
        mem.importance += 0.1; // Boost importance during sleep
        this.memory.longTerm.set(mem.id, mem);
      }
    }
    this.memory.shortTerm = [];
    this.memory.consolidationCount += 10;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DECAY
  // ─────────────────────────────────────────────────────────────────────────────

  private _decay(): void {
    // Apply φ⁻¹ decay to long-term memories
    const toRemove: string[] = [];

    for (const [id, mem] of this.memory.longTerm) {
      mem.importance *= (1 - mem.decayRate * 0.001);
      
      // Remove if importance drops too low
      if (mem.importance < 0.1) {
        toRemove.push(id);
      }
    }

    for (const id of toRemove) {
      this.memory.longTerm.delete(id);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ASSOCIATION
  // ─────────────────────────────────────────────────────────────────────────────

  private _associate(params: { memoryId: string; associations: string[] }): void {
    const mem = this.memory.longTerm.get(params.memoryId);
    if (mem) {
      mem.associations = [...new Set([...mem.associations, ...params.associations])];
      // Associations boost importance
      mem.importance = clamp(mem.importance + 0.05 * params.associations.length, 0, 1);
    }
  }

  private _forget(memoryId: string): void {
    this.memory.longTerm.delete(memoryId);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────────────────────

  getMemoriaState(): {
    shortTermSize: number;
    longTermSize: number;
    workingMemorySize: number;
    totalStored: number;
    totalRecalled: number;
    consolidationCount: number;
  } {
    return {
      shortTermSize: this.memory.shortTerm.length,
      longTermSize: this.memory.longTerm.size,
      workingMemorySize: this.memory.workingMemory.length,
      totalStored: this.memory.totalStored,
      totalRecalled: this.memory.totalRecalled,
      consolidationCount: this.memory.consolidationCount,
    };
  }
}
