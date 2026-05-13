// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// CORPUS — The Body Agent (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// CORPUS is the execution and action agent. It:
//   - Executes decisions from ANIMUS (every 50ms)
//   - Manages physical state (energy, health, position)
//   - Handles motor commands
//   - Reports execution status back to ANIMUS
//
// Uses: CHRONO (timing), NEXORIS (body state), QUANTUM_FLUX (stochastic execution)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { BaseAgent, AgentConfig } from './BaseAgent';
import { Message } from '../engines/COREOGRAPH';
import { TICK_ULTRA_FAST } from '../engines/CHRONO';
import { PHI, PHI_INV, clamp } from '../../frontend/src/math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CORPUS STATE
// ═══════════════════════════════════════════════════════════════════════════════

interface BodyState {
  health: number;           // 0-1
  stamina: number;          // 0-1, depletes with action
  position: { x: number; y: number; z: number };
  velocity: { x: number; y: number; z: number };
  actionQueue: Action[];
  currentAction: Action | null;
  completedActions: number;
  failedActions: number;
}

interface Action {
  id: string;
  type: string;
  params: Record<string, unknown>;
  priority: number;
  startedAt: number | null;
  progress: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — CORPUS CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class Corpus extends BaseAgent {
  private body: BodyState;
  private _actionIdCounter = 0;

  constructor() {
    super({
      id: 'CORPUS',
      family: 'CORPUS_VIVUM',
      tickInterval: TICK_ULTRA_FAST,
      priority: 1.2, // High priority for execution
    });

    this.body = {
      health: 1.0,
      stamina: 1.0,
      position: { x: 0, y: 0, z: 0 },
      velocity: { x: 0, y: 0, z: 0 },
      actionQueue: [],
      currentAction: null,
      completedActions: 0,
      failedActions: 0,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────────────────────

  protected onAwaken(): void {
    this.setState('health', this.body.health);
    this.setState('stamina', this.body.stamina);
    this.setState('position', this.body.position);
  }

  protected onTick(): void {
    // Execute current action
    this._executeAction();

    // Regenerate stamina (φ-rate)
    if (!this.body.currentAction) {
      this.body.stamina = clamp(this.body.stamina + 0.01 * PHI_INV, 0, 1);
    }

    // Update position from velocity
    this.body.position.x += this.body.velocity.x;
    this.body.position.y += this.body.velocity.y;
    this.body.position.z += this.body.velocity.z;

    // Velocity decay
    this.body.velocity.x *= 0.9;
    this.body.velocity.y *= 0.9;
    this.body.velocity.z *= 0.9;

    // Sync state
    this.setState('stamina', this.body.stamina);
    this.setState('position', this.body.position);
  }

  protected onMessage(msg: Message): void {
    switch (msg.type) {
      case 'DECISION':
        this._handleDecision(msg.payload as { decision: string; confidence: number });
        break;
      case 'MOVE':
        this._queueAction('MOVE', msg.payload as Record<string, unknown>);
        break;
      case 'ACTION':
        this._queueAction((msg.payload as { type: string }).type, msg.payload as Record<string, unknown>);
        break;
      case 'QUERY_BODY':
        this.send('BODY_STATE', msg.source, this._getBodyState());
        break;
    }
  }

  protected onSleep(): void {
    // Pause current action
    if (this.body.currentAction) {
      this.body.currentAction = null;
    }
  }

  protected onWake(): void {
    // Resume from queue if any
  }

  protected onShutdown(): void {
    this.body.actionQueue = [];
    this.body.currentAction = null;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ACTION EXECUTION
  // ─────────────────────────────────────────────────────────────────────────────

  private _executeAction(): void {
    // Start new action if none active
    if (!this.body.currentAction && this.body.actionQueue.length > 0) {
      // Sort by priority
      this.body.actionQueue.sort((a, b) => b.priority - a.priority);
      this.body.currentAction = this.body.actionQueue.shift() ?? null;
      if (this.body.currentAction) {
        this.body.currentAction.startedAt = Date.now();
        this.body.currentAction.progress = 0;
      }
    }

    if (!this.body.currentAction) return;

    // Check stamina
    if (this.body.stamina < 0.05) {
      // Too tired — fail action
      this._failAction('EXHAUSTED');
      return;
    }

    // Execute based on type
    const action = this.body.currentAction;
    switch (action.type) {
      case 'PROCEED':
        this._executeProceed(action);
        break;
      case 'MOVE':
        this._executeMove(action);
        break;
      case 'WAIT':
        this._executeWait(action);
        break;
      case 'EXPLORE':
        this._executeExplore(action);
        break;
      case 'RETREAT':
        this._executeRetreat(action);
        break;
      case 'COMMUNICATE':
        this._executeCommunicate(action);
        break;
      default:
        this._executeGeneric(action);
    }

    // Deplete stamina
    this.body.stamina = clamp(this.body.stamina - 0.005, 0, 1);
  }

  private _executeProceed(action: Action): void {
    action.progress += 0.1;
    this.body.velocity.x += this.phiNoise(0.1);
    this.body.velocity.y += this.phiNoise(0.1);
    if (action.progress >= 1) this._completeAction();
  }

  private _executeMove(action: Action): void {
    const target = action.params as { x?: number; y?: number; z?: number };
    const dx = (target.x ?? 0) - this.body.position.x;
    const dy = (target.y ?? 0) - this.body.position.y;
    const dz = (target.z ?? 0) - this.body.position.z;
    const dist = Math.sqrt(dx * dx + dy * dy + dz * dz);

    if (dist < 0.1) {
      this._completeAction();
      return;
    }

    const speed = 0.1;
    this.body.velocity.x = (dx / dist) * speed;
    this.body.velocity.y = (dy / dist) * speed;
    this.body.velocity.z = (dz / dist) * speed;
    action.progress = 1 - (dist / 10);
  }

  private _executeWait(action: Action): void {
    action.progress += 0.02;
    if (action.progress >= 1) this._completeAction();
  }

  private _executeExplore(action: Action): void {
    // Random movement
    this.body.velocity.x += this.gaussian(0, 0.2);
    this.body.velocity.y += this.gaussian(0, 0.2);
    action.progress += 0.05;
    if (action.progress >= 1) this._completeAction();
  }

  private _executeRetreat(action: Action): void {
    // Move opposite to current velocity
    this.body.velocity.x = -Math.abs(this.body.velocity.x) * 0.5 - 0.1;
    this.body.velocity.y = -Math.abs(this.body.velocity.y) * 0.5;
    action.progress += 0.1;
    if (action.progress >= 1) this._completeAction();
  }

  private _executeCommunicate(action: Action): void {
    // Broadcast communication
    this.broadcast('COMMUNICATION', {
      from: this.config.id,
      content: action.params,
    });
    action.progress = 1;
    this._completeAction();
  }

  private _executeGeneric(action: Action): void {
    action.progress += 0.1;
    if (action.progress >= 1) this._completeAction();
  }

  private _completeAction(): void {
    if (this.body.currentAction) {
      this.body.completedActions++;
      this.send('ACTION_COMPLETE', 'ANIMUS', {
        action: this.body.currentAction.type,
        success: true,
      });
      this.body.currentAction = null;
    }
  }

  private _failAction(reason: string): void {
    if (this.body.currentAction) {
      this.body.failedActions++;
      this.send('ACTION_FAILED', 'ANIMUS', {
        action: this.body.currentAction.type,
        reason,
      });
      this.body.currentAction = null;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ACTION QUEUE
  // ─────────────────────────────────────────────────────────────────────────────

  private _handleDecision(decision: { decision: string; confidence: number }): void {
    this._queueAction(decision.decision, { confidence: decision.confidence }, decision.confidence);
  }

  private _queueAction(type: string, params: Record<string, unknown>, priority: number = 1): void {
    const action: Action = {
      id: `action_${this._actionIdCounter++}`,
      type,
      params,
      priority,
      startedAt: null,
      progress: 0,
    };
    this.body.actionQueue.push(action);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────────────────────

  private _getBodyState(): object {
    return {
      health: this.body.health,
      stamina: this.body.stamina,
      position: { ...this.body.position },
      velocity: { ...this.body.velocity },
      queueDepth: this.body.actionQueue.length,
      currentAction: this.body.currentAction?.type ?? null,
      completedActions: this.body.completedActions,
      failedActions: this.body.failedActions,
    };
  }

  getBodyState(): Readonly<BodyState> {
    return {
      ...this.body,
      position: { ...this.body.position },
      velocity: { ...this.body.velocity },
      actionQueue: [...this.body.actionQueue],
    };
  }
}
