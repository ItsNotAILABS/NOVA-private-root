// ═══════════════════════════════════════════════════════════════════════════════
// PHOENIX ENGINE — Rebirth and Resurrection System (BUILD №52)
// ═══════════════════════════════════════════════════════════════════════════════
//
// PURPOSE:
// Autonomous death-rebirth cycle management engine. Handles system resurrection,
// state restoration from ashes, and φ-improved reincarnation.
//
// CAPABILITIES:
// - Death detection and ash preservation
// - State resurrection with improvements
// - φ-enhanced rebirth (better than before)
// - Immortality through cyclic renewal
// - Resurrection memory retention
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;

export interface SystemSnapshot {
  id: string;
  state: any;
  health: number;
  timestamp: number;
  generation: number;
}

export interface Ashes {
  systemId: string;
  snapshot: SystemSnapshot;
  deathCause: string;
  deathTimestamp: number;
  resurrectible: boolean;
}

export interface Phoenix {
  id: string;
  currentState: SystemSnapshot;
  previousLives: SystemSnapshot[];
  deathCount: number;
  rebirthCount: number;
  improvement: number; // Cumulative improvement factor
  immortal: boolean;
}

export class PhoenixEngine {
  private phoenixes: Map<string, Phoenix> = new Map();
  private ashHeap: Map<string, Ashes> = new Map();

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — Death Detection
  // ═══════════════════════════════════════════════════════════════════════════

  public detectDeath(systemId: string, health: number, threshold: number = 0.1): boolean {
    return health <= threshold;
  }

  public preserveAsAshes(systemId: string, snapshot: SystemSnapshot, cause: string): Ashes {
    const ashes: Ashes = {
      systemId,
      snapshot,
      deathCause: cause,
      deathTimestamp: Date.now(),
      resurrectible: true
    };

    this.ashHeap.set(systemId, ashes);

    // Update phoenix if exists
    const phoenix = this.phoenixes.get(systemId);
    if (phoenix) {
      phoenix.previousLives.push(snapshot);
      phoenix.deathCount++;
      this.phoenixes.set(systemId, phoenix);
    }

    return ashes;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — Resurrection
  // ═══════════════════════════════════════════════════════════════════════════

  public resurrect(systemId: string): Phoenix {
    const ashes = this.ashHeap.get(systemId);
    if (!ashes) {
      throw new Error(`No ashes found for system ${systemId}`);
    }

    if (!ashes.resurrectible) {
      throw new Error(`System ${systemId} is not resurrectible`);
    }

    // φ-enhanced rebirth
    const improvementFactor = Math.pow(PHI, ashes.snapshot.generation + 1) / Math.pow(PHI, ashes.snapshot.generation);

    const reborn: SystemSnapshot = {
      id: ashes.snapshot.id,
      state: this.improveState(ashes.snapshot.state, improvementFactor),
      health: Math.min(1.0, ashes.snapshot.health * PHI), // Health multiplied by φ
      timestamp: Date.now(),
      generation: ashes.snapshot.generation + 1
    };

    // Create or update phoenix
    let phoenix = this.phoenixes.get(systemId);

    if (!phoenix) {
      phoenix = {
        id: systemId,
        currentState: reborn,
        previousLives: [ashes.snapshot],
        deathCount: 1,
        rebirthCount: 1,
        improvement: improvementFactor,
        immortal: false
      };
    } else {
      phoenix.currentState = reborn;
      phoenix.rebirthCount++;
      phoenix.improvement *= improvementFactor;

      // Immortality achieved after φ² rebirths (≈7 rebirths)
      if (phoenix.rebirthCount >= Math.pow(PHI, 2)) {
        phoenix.immortal = true;
      }
    }

    this.phoenixes.set(systemId, phoenix);
    this.ashHeap.delete(systemId); // Remove from ash heap

    return phoenix;
  }

  private improveState(state: any, improvementFactor: number): any {
    // Apply φ-improvement to numeric values
    if (typeof state === 'number') {
      return state * improvementFactor;
    }

    if (Array.isArray(state)) {
      return state.map(s => this.improveState(s, improvementFactor));
    }

    if (typeof state === 'object' && state !== null) {
      const improved: any = {};
      Object.keys(state).forEach(key => {
        improved[key] = this.improveState(state[key], improvementFactor);
      });
      return improved;
    }

    return state;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — Cyclic Renewal
  // ═══════════════════════════════════════════════════════════════════════════

  public autoRenew(systemId: string, currentHealth: number): Phoenix | null {
    if (this.detectDeath(systemId, currentHealth)) {
      const phoenix = this.phoenixes.get(systemId);

      const snapshot: SystemSnapshot = phoenix
        ? phoenix.currentState
        : {
            id: systemId,
            state: {},
            health: currentHealth,
            timestamp: Date.now(),
            generation: 0
          };

      this.preserveAsAshes(systemId, snapshot, 'AUTO_RENEWAL');
      return this.resurrect(systemId);
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — Memory Retention
  // ═══════════════════════════════════════════════════════════════════════════

  public getLifeHistory(systemId: string): SystemSnapshot[] {
    const phoenix = this.phoenixes.get(systemId);
    if (!phoenix) {
      return [];
    }

    return [...phoenix.previousLives, phoenix.currentState];
  }

  public getTotalLifespan(systemId: string): number {
    const history = this.getLifeHistory(systemId);
    if (history.length === 0) return 0;

    const firstBirth = history[0].timestamp;
    const now = Date.now();

    return now - firstBirth;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — Immortality Status
  // ═══════════════════════════════════════════════════════════════════════════

  public isImmortal(systemId: string): boolean {
    const phoenix = this.phoenixes.get(systemId);
    return phoenix?.immortal || false;
  }

  public grantImmortality(systemId: string): void {
    const phoenix = this.phoenixes.get(systemId);
    if (phoenix) {
      phoenix.immortal = true;
      this.phoenixes.set(systemId, phoenix);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 6 — Diagnostics
  // ═══════════════════════════════════════════════════════════════════════════

  public getPhoenix(systemId: string): Phoenix | undefined {
    return this.phoenixes.get(systemId);
  }

  public getAllPhoenixes(): Phoenix[] {
    return Array.from(this.phoenixes.values());
  }

  public getAshes(systemId: string): Ashes | undefined {
    return this.ashHeap.get(systemId);
  }

  public getStatistics(): {
    totalPhoenixes: number;
    immortalCount: number;
    avgRebirths: number;
    avgImprovement: number;
    ashHeapSize: number;
    totalDeaths: number;
  } {
    const phoenixes = this.getAllPhoenixes();

    return {
      totalPhoenixes: phoenixes.length,
      immortalCount: phoenixes.filter(p => p.immortal).length,
      avgRebirths: phoenixes.length > 0
        ? phoenixes.reduce((acc, p) => acc + p.rebirthCount, 0) / phoenixes.length
        : 0,
      avgImprovement: phoenixes.length > 0
        ? phoenixes.reduce((acc, p) => acc + p.improvement, 0) / phoenixes.length
        : 0,
      ashHeapSize: this.ashHeap.size,
      totalDeaths: phoenixes.reduce((acc, p) => acc + p.deathCount, 0)
    };
  }
}

// Singleton instance
export const phoenixEngine = new PhoenixEngine();
