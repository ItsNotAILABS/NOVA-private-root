// ═══════════════════════════════════════════════════════════════════════════════
// METAMORPHOSIS ENGINE — Transformation Intelligence (BUILD №52)
// ═══════════════════════════════════════════════════════════════════════════════
//
// PURPOSE:
// Autonomous state transformation engine managing all metamorphic transitions
// across NOVA. Transforms systems from one state to another through φ-guided
// phase transitions.
//
// CAPABILITIES:
// - Stage-based transformation pipelines (Larva → Pupa → Imago)
// - φ-weighted transformation gradients
// - Reversible and irreversible transitions
// - Metamorphic memory (remembers past states)
// - Catastrophe theory state jumps
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;

export interface TransformationStage {
  stage: 'LARVA' | 'PUPA' | 'IMAGO' | 'CHRYSALIS';
  progress: number; // [0,1]
  energy: number;
  reversible: boolean;
}

export interface MetamorphicState {
  id: string;
  currentStage: TransformationStage;
  previousStates: TransformationStage[];
  transformationCount: number;
  createdAt: number;
  lastTransformed: number;
}

export class MetamorphosisEngine {
  private states: Map<string, MetamorphicState> = new Map();

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — Stage Transitions
  // ═══════════════════════════════════════════════════════════════════════════

  public initializeState(id: string, initialStage: TransformationStage['stage'] = 'LARVA'): MetamorphicState {
    const state: MetamorphicState = {
      id,
      currentStage: {
        stage: initialStage,
        progress: 0,
        energy: 1.0,
        reversible: true
      },
      previousStates: [],
      transformationCount: 0,
      createdAt: Date.now(),
      lastTransformed: Date.now()
    };

    this.states.set(id, state);
    return state;
  }

  public transform(id: string, targetStage: TransformationStage['stage'], energy: number = 1.0): MetamorphicState {
    const state = this.states.get(id);
    if (!state) {
      throw new Error(`MetamorphicState ${id} not found`);
    }

    // Save current state to history
    state.previousStates.push({ ...state.currentStage });

    // Calculate transformation progress using φ
    const stageOrder = ['LARVA', 'PUPA', 'CHRYSALIS', 'IMAGO'];
    const currentIndex = stageOrder.indexOf(state.currentStage.stage);
    const targetIndex = stageOrder.indexOf(targetStage);

    const distance = Math.abs(targetIndex - currentIndex);
    const transformationCost = 1 / Math.pow(PHI, distance); // Closer = cheaper

    // Apply transformation
    state.currentStage = {
      stage: targetStage,
      progress: 0,
      energy: energy * transformationCost,
      reversible: targetStage !== 'IMAGO' // IMAGO is irreversible (adult form)
    };

    state.transformationCount++;
    state.lastTransformed = Date.now();

    this.states.set(id, state);
    return state;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — φ-Gradient Transformation
  // ═══════════════════════════════════════════════════════════════════════════

  public advanceProgress(id: string, increment: number = 0.1): MetamorphicState {
    const state = this.states.get(id);
    if (!state) {
      throw new Error(`MetamorphicState ${id} not found`);
    }

    // φ-weighted progress acceleration
    const acceleration = Math.pow(state.currentStage.progress, 1 / PHI);
    const newProgress = Math.min(1.0, state.currentStage.progress + (increment * (1 + acceleration)));

    state.currentStage.progress = newProgress;

    // Auto-transition when progress reaches 1.0
    if (newProgress >= 1.0) {
      const stageOrder = ['LARVA', 'PUPA', 'CHRYSALIS', 'IMAGO'];
      const currentIndex = stageOrder.indexOf(state.currentStage.stage);

      if (currentIndex < stageOrder.length - 1) {
        const nextStage = stageOrder[currentIndex + 1] as TransformationStage['stage'];
        return this.transform(id, nextStage, state.currentStage.energy);
      }
    }

    this.states.set(id, state);
    return state;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — Catastrophe Theory State Jumps
  // ═══════════════════════════════════════════════════════════════════════════

  public catastrophicJump(id: string): MetamorphicState {
    const state = this.states.get(id);
    if (!state) {
      throw new Error(`MetamorphicState ${id} not found`);
    }

    // Sudden irreversible state jump (cusp catastrophe)
    const stageOrder: TransformationStage['stage'][] = ['LARVA', 'PUPA', 'CHRYSALIS', 'IMAGO'];
    const currentIndex = stageOrder.indexOf(state.currentStage.stage);

    // Jump to final stage
    state.previousStates.push({ ...state.currentStage });
    state.currentStage = {
      stage: 'IMAGO',
      progress: 1.0,
      energy: state.currentStage.energy * PHI, // Energy amplification
      reversible: false
    };

    state.transformationCount++;
    state.lastTransformed = Date.now();

    this.states.set(id, state);
    return state;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — Metamorphic Memory
  // ═══════════════════════════════════════════════════════════════════════════

  public getHistory(id: string): TransformationStage[] {
    const state = this.states.get(id);
    if (!state) {
      throw new Error(`MetamorphicState ${id} not found`);
    }

    return state.previousStates;
  }

  public reverseTransformation(id: string): MetamorphicState | null {
    const state = this.states.get(id);
    if (!state) {
      throw new Error(`MetamorphicState ${id} not found`);
    }

    if (!state.currentStage.reversible) {
      return null; // Cannot reverse irreversible transformation
    }

    if (state.previousStates.length === 0) {
      return null; // No previous state to revert to
    }

    const previousState = state.previousStates.pop()!;
    state.currentStage = { ...previousState };
    state.transformationCount++;
    state.lastTransformed = Date.now();

    this.states.set(id, state);
    return state;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — Diagnostics
  // ═══════════════════════════════════════════════════════════════════════════

  public getState(id: string): MetamorphicState | undefined {
    return this.states.get(id);
  }

  public getAllStates(): MetamorphicState[] {
    return Array.from(this.states.values());
  }

  public getStatistics(): {
    totalStates: number;
    byStage: Record<string, number>;
    avgTransformations: number;
    irreversibleCount: number;
  } {
    const all = this.getAllStates();

    const byStage: Record<string, number> = {
      LARVA: 0,
      PUPA: 0,
      CHRYSALIS: 0,
      IMAGO: 0
    };

    let totalTransformations = 0;
    let irreversibleCount = 0;

    all.forEach(state => {
      byStage[state.currentStage.stage]++;
      totalTransformations += state.transformationCount;
      if (!state.currentStage.reversible) irreversibleCount++;
    });

    return {
      totalStates: all.length,
      byStage,
      avgTransformations: all.length > 0 ? totalTransformations / all.length : 0,
      irreversibleCount
    };
  }
}

// Singleton instance
export const metamorphosisEngine = new MetamorphosisEngine();
