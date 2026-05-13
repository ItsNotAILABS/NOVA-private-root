// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: sovereignFlip.ts — The 4-Phase Sovereign Version Engine
//
// Phase 1: RECOGNIZE — Name the model and its intelligence type
// Phase 2: REDUCE — Find the primitive function beneath it
// Phase 3: REBUILD — Build sovereign version
// Phase 4: REINSERT — Wire back into organism/package/deploy
//
// This is not theoretical. This engine tracks every F-MODEL through
// its sovereign conversion lifecycle.
// ═══════════════════════════════════════════════════════════════════════════════

import type { FModel, SovereignStatus } from './FModelRegistry';
import type { PrimitiveFunction } from './primitives';
import { PRIMITIVES } from './primitives';

// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN FLIP PHASES
// ═══════════════════════════════════════════════════════════════════════════════

export type FlipPhase =
  | 'RECOGNIZE'   // Phase 1: Model identified and intelligence type classified
  | 'REDUCE'      // Phase 2: Primitive function extracted
  | 'REBUILD'     // Phase 3: Sovereign version being built
  | 'REINSERT';   // Phase 4: Wired back into organism

/** Anti-collapse reinsert targets — where sovereign versions must go */
export type ReinsertTarget =
  | 'DOCTRINE'    // Goes back into doctrine truth
  | 'MECHANISM'   // Goes back into operational mechanism
  | 'RUNTIME'     // Goes back into runtime truth
  | 'COMPANY'     // Goes back into company/organism
  | 'IP_COUNSEL'; // Goes back into IP/counsel

/** Complete sovereign flip record for one F-MODEL */
export interface SovereignFlipRecord {
  /** F-MODEL ID */
  modelId: string;
  /** Technology name */
  technology: string;
  /** Current flip phase */
  phase: FlipPhase;
  /** Primary primitive identified in Phase 2 */
  primaryPrimitive: PrimitiveFunction;
  /** Sovereign operator name (from Phase 3) */
  sovereignOperator: string;
  /** Reinsert targets (Phase 4) */
  reinsertTargets: ReinsertTarget[];
  /** Sovereign status */
  status: SovereignStatus;
  /** What the sovereign version replaces */
  replaces: string;
  /** What the sovereign version provides that the original doesn't */
  sovereignAdvantage: string;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN FLIP ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

/** Determine the flip phase for a model based on its sovereign status */
export function getFlipPhase(model: FModel): FlipPhase {
  switch (model.sovereignStatus) {
    case 'NATIVE':   return 'REINSERT';
    case 'FLIPPED':  return 'REINSERT';
    case 'PARTIAL':  return 'REBUILD';
    case 'MAPPED':   return 'REDUCE';
    case 'EXTERNAL': return 'RECOGNIZE';
  }
}

/** Get the sovereign operator for a primitive */
export function getSovereignOperator(primitive: PrimitiveFunction): string {
  return PRIMITIVES[primitive].sovereignOperator;
}

/** Determine reinsert targets based on model properties */
export function getReinsertTargets(model: FModel): ReinsertTarget[] {
  const targets: ReinsertTarget[] = [];

  // All models must go into mechanism (they are operational)
  targets.push('MECHANISM');
  targets.push('RUNTIME');

  // Doctrine-ring models also go into doctrine
  if (model.ringAffinity === 'N1' || model.ringAffinity === 'N2') {
    targets.push('DOCTRINE');
  }

  // Economic models go into company
  if (model.ringAffinity === 'N9') {
    targets.push('COMPANY');
  }

  // All models eventually need IP protection
  targets.push('IP_COUNSEL');

  return targets;
}

/** Generate a complete flip record for a model */
export function generateFlipRecord(model: FModel): SovereignFlipRecord {
  return {
    modelId: model.id,
    technology: model.technology,
    phase: getFlipPhase(model),
    primaryPrimitive: model.primitive,
    sovereignOperator: model.sovereignReplacement,
    reinsertTargets: getReinsertTargets(model),
    status: model.sovereignStatus,
    replaces: model.technology,
    sovereignAdvantage: getSovereignAdvantage(model),
  };
}

/** Describe what sovereignty provides over the external dependency */
function getSovereignAdvantage(model: FModel): string {
  switch (model.primitive) {
    case 'RELATION':
      return 'Sovereign structural control — no external DOM dependency, PHI-geometric layout';
    case 'VISIBILITY':
      return 'Sovereign visual priority — AEGIS-protected display, doctrine-controlled visibility';
    case 'FLOW':
      return 'Sovereign data routing — no external fetch/socket dependency, canister-native flow';
    case 'STATE':
      return 'Sovereign state retention — stable memory persistence, NO-DROP memory law';
    case 'SYNCHRONIZATION':
      return 'Sovereign timing — PHI-harmonic synchronization, Kuramoto-coupled phases';
    case 'PROJECTION':
      return 'Sovereign rendering — organism-native projection, Shell 12→8→3 pipeline';
    case 'TRANSFORMATION':
      return 'Sovereign compilation — Third Synthesizer transform-and-retain, never erase';
    case 'VERIFICATION':
      return 'Sovereign testing — Veritas stabilizer verification, organism immune system';
    case 'ENCAPSULATION':
      return 'Sovereign isolation — AEGIS membrane boundaries, Umbra shadow protection';
  }
}

/** Get flip progress summary */
export function getFlipProgress(models: FModel[]): {
  recognized: number;
  reduced: number;
  rebuilding: number;
  reinserted: number;
  total: number;
} {
  let recognized = 0;
  let reduced = 0;
  let rebuilding = 0;
  let reinserted = 0;

  for (const model of models) {
    const phase = getFlipPhase(model);
    switch (phase) {
      case 'RECOGNIZE': recognized++; break;
      case 'REDUCE': reduced++; break;
      case 'REBUILD': rebuilding++; break;
      case 'REINSERT': reinserted++; break;
    }
  }

  return { recognized, reduced, rebuilding, reinserted, total: models.length };
}
