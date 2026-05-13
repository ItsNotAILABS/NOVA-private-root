// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// ANIMUS — The Mind Agent (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ANIMUS is the reasoning and decision-making agent. It:
//   - Thinks (reasoning loop every 100ms)
//   - Dreams (background processing every 5000ms)
//   - Reflects (self-analysis every 30000ms)
//   - Makes decisions based on NEXORIS state
//   - Communicates decisions to CORPUS for execution
//
// Uses: CHRONO (timing), NEXORIS (decision state), COREOGRAPH (commands)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { BaseAgent, AgentConfig } from './BaseAgent';
import { Message } from '../engines/COREOGRAPH';
import { CHRONO, TICK_ULTRA_FAST } from '../engines/CHRONO';
import { PHI, PHI_INV, sigmoid, clamp } from '../../frontend/src/math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — ANIMUS STATE
// ═══════════════════════════════════════════════════════════════════════════════

interface ThoughtState {
  currentGoal: string | null;
  attention: number;        // 0-1, focus level
  arousal: number;          // 0-1, alertness
  valence: number;          // -1 to 1, emotional state
  decisionConfidence: number;
  lastDecision: string | null;
  thoughtCount: number;
  dreamCount: number;
  reflectionCount: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — ANIMUS CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class Animus extends BaseAgent {
  private thought: ThoughtState;
  private _thinkTimerId: string = '';
  private _dreamTimerId: string = '';
  private _reflectTimerId: string = '';

  constructor() {
    super({
      id: 'ANIMUS',
      family: 'MENS_AETERNA',
      tickInterval: TICK_ULTRA_FAST,
      priority: 1.4, // Executive priority
    });

    this.thought = {
      currentGoal: null,
      attention: 0.5,
      arousal: 0.5,
      valence: 0.0,
      decisionConfidence: 0.5,
      lastDecision: null,
      thoughtCount: 0,
      dreamCount: 0,
      reflectionCount: 0,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────────────────────

  protected onAwaken(): void {
    // Initialize state
    this.setState('goal', null);
    this.setState('attention', this.thought.attention);
    this.setState('arousal', this.thought.arousal);
    this.setState('valence', this.thought.valence);

    // Start thinking loops
    this._thinkTimerId = `${this.config.id}_THINK`;
    this._dreamTimerId = `${this.config.id}_DREAM`;
    this._reflectTimerId = `${this.config.id}_REFLECT`;

    CHRONO.registerTimer(this._thinkTimerId, () => this._think(), 100);
    CHRONO.registerTimer(this._dreamTimerId, () => this._dream(), 5000);
    CHRONO.registerTimer(this._reflectTimerId, () => this._reflect(), 30000);
  }

  protected onTick(): void {
    // Main tick — update attention based on activity
    const inboxSize = this._getInboxSize();
    if (inboxSize > 0) {
      this.thought.arousal = clamp(this.thought.arousal + 0.05, 0, 1);
    } else {
      this.thought.arousal = clamp(this.thought.arousal - 0.01, 0.2, 1);
    }

    // Sync state to NEXORIS
    this.setState('arousal', this.thought.arousal);
    this.setState('attention', this.thought.attention);
  }

  protected onMessage(msg: Message): void {
    // Handle incoming messages
    switch (msg.type) {
      case 'PERCEPTION':
        this._processPerception(msg.payload);
        break;
      case 'GOAL_REQUEST':
        this._setGoal(msg.payload as string);
        break;
      case 'QUERY_STATE':
        this.send('STATE_RESPONSE', msg.source, this._getPublicState());
        break;
      default:
        // Unknown message type — log and increase arousal
        this.thought.arousal = clamp(this.thought.arousal + 0.02, 0, 1);
    }
  }

  protected onSleep(): void {
    CHRONO.pauseTimer(this._thinkTimerId);
    CHRONO.pauseTimer(this._dreamTimerId);
    CHRONO.pauseTimer(this._reflectTimerId);
  }

  protected onWake(): void {
    CHRONO.resumeTimer(this._thinkTimerId);
    CHRONO.resumeTimer(this._dreamTimerId);
    CHRONO.resumeTimer(this._reflectTimerId);
  }

  protected onShutdown(): void {
    CHRONO.unregisterTimer(this._thinkTimerId);
    CHRONO.unregisterTimer(this._dreamTimerId);
    CHRONO.unregisterTimer(this._reflectTimerId);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // THINKING — The reasoning loop (100ms)
  // ─────────────────────────────────────────────────────────────────────────────

  private _think(): void {
    this.thought.thoughtCount++;

    // Compute decision confidence based on state coherence
    const coherence = this._computeCoherence();
    this.thought.decisionConfidence = sigmoid((coherence - 0.5) * 4);

    // If we have a goal and high confidence, make a decision
    if (this.thought.currentGoal && this.thought.decisionConfidence > 0.7) {
      const decision = this._reason(this.thought.currentGoal);
      if (decision) {
        this.thought.lastDecision = decision;
        this.send('DECISION', 'CORPUS', { decision, confidence: this.thought.decisionConfidence });
      }
    }

    // Attention decay
    this.thought.attention = clamp(
      this.thought.attention + this.phiNoise(0.05) - 0.01,
      0.1, 1.0
    );
  }

  private _reason(goal: string): string | null {
    // Simplified reasoning — in production would be much more complex
    const options = [
      'PROCEED',
      'WAIT',
      'EXPLORE',
      'RETREAT',
      'COMMUNICATE',
    ];

    // φ-weighted selection based on arousal and valence
    const weights = options.map((_, i) => {
      const base = Math.pow(PHI_INV, i);
      const arousalMod = this.thought.arousal * (i < 2 ? 1.5 : 0.8);
      const valenceMod = this.thought.valence > 0 ? (i === 0 ? 1.3 : 1) : (i === 3 ? 1.3 : 1);
      return base * arousalMod * valenceMod;
    });

    // Pick option
    const totalWeight = weights.reduce((s, w) => s + w, 0);
    let r = this.random() * totalWeight;
    for (let i = 0; i < options.length; i++) {
      r -= weights[i]!;
      if (r <= 0) return options[i]!;
    }

    return options[0]!;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DREAMING — Background processing (5000ms)
  // ─────────────────────────────────────────────────────────────────────────────

  private _dream(): void {
    this.thought.dreamCount++;

    // Consolidate memories (simplified)
    const memory = this.getState('memory') as unknown[] | undefined;
    if (memory && memory.length > 100) {
      // Prune old memories, keeping important ones
      const pruned = memory.slice(-50);
      this.setState('memory', pruned);
    }

    // Valence drift toward neutral
    this.thought.valence *= 0.95;

    // Broadcast dream state for research
    this.broadcast('DREAM_STATE', {
      dreamCount: this.thought.dreamCount,
      valence: this.thought.valence,
    });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // REFLECTION — Self-analysis (30000ms)
  // ─────────────────────────────────────────────────────────────────────────────

  private _reflect(): void {
    this.thought.reflectionCount++;

    // Compute self-model metrics
    const selfModel = {
      decisionAccuracy: this._estimateDecisionAccuracy(),
      coherence: this._computeCoherence(),
      energyTrend: this._computeEnergyTrend(),
      thoughtsPerMinute: (this.thought.thoughtCount / (this.getBeat() + 1)) * 60,
    };

    // Adjust parameters based on reflection
    if (selfModel.coherence < 0.5) {
      // Low coherence — increase attention
      this.thought.attention = clamp(this.thought.attention + 0.1, 0, 1);
    }

    // Broadcast reflection for learning
    this.broadcast('REFLECTION', selfModel);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PERCEPTION PROCESSING
  // ─────────────────────────────────────────────────────────────────────────────

  private _processPerception(payload: unknown): void {
    // Increase attention when perceiving
    this.thought.attention = clamp(this.thought.attention + 0.1, 0, 1);

    // Update valence based on perception (simplified)
    if (payload && typeof payload === 'object' && 'valence' in payload) {
      const v = (payload as { valence: number }).valence;
      this.thought.valence = clamp(this.thought.valence + v * 0.3, -1, 1);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // GOAL MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────────

  private _setGoal(goal: string): void {
    this.thought.currentGoal = goal;
    this.setState('goal', goal);
    
    // Increase arousal when new goal
    this.thought.arousal = clamp(this.thought.arousal + 0.2, 0, 1);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────────

  private _computeCoherence(): number {
    // Coherence = alignment between attention, arousal, and decision confidence
    const attAro = 1 - Math.abs(this.thought.attention - this.thought.arousal);
    const aroConf = 1 - Math.abs(this.thought.arousal - this.thought.decisionConfidence);
    return (attAro + aroConf) / 2;
  }

  private _estimateDecisionAccuracy(): number {
    // Simplified — would track actual outcomes in production
    return this.thought.decisionConfidence * this.thought.attention;
  }

  private _computeEnergyTrend(): number {
    // Simplified — would compute from history
    return this._state.energy > 0.5 ? 1 : -1;
  }

  private _getInboxSize(): number {
    // Approximate via beat count
    return this.getBeat() % 10 < 3 ? 1 : 0;
  }

  private _getPublicState(): object {
    return {
      ...this.thought,
      energy: this._state.energy,
      phase: this._state.phase,
      beat: this._state.beat,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────────────────────

  getThoughtState(): Readonly<ThoughtState> {
    return { ...this.thought };
  }
}
