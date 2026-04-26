// ─── NOVA / PARALLAX — FusionQuipu ───────────────────────────────────────────
// The canonical cross-engine append-only log.
// Every action across every paper engine writes a FusionQuipu record.
// This is the "digital quipu" as executable memory — the organism's string memory.
//
// FusionQuipu is the universal event log for the FusionOrganism.
// It wraps QuipuEngine (Paper VI) with:
//   - Cross-engine source tagging (which paper engine emitted this)
//   - φ-weighted severity scoring
//   - Compression via LINGUA COMPRESSA (SCC ≥ φ²)
//   - Executable lifecycle: PENDING → EXECUTING → SETTLED
//   - Integrity hash per record
//
// Every SERVITOR worker writes to FusionQuipu.
// Every production tick reads from FusionQuipu (the PENDING queue = instruction set).
//
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import {
  quipuAppend, quipuClaim, quipuSettle, quipuCancel,
  quipuGetPending, quipuGetBySpine, quipuGetByColor,
  quipuGetMetrics, quipuGetSubsidiaries, quipuReset,
  QuipuRecord, QuipuSpine, QuipuPendant,
} from '../math/quipu-engine';
import { compress, validateSCC, CompressedMessage } from '../math/lingua-compressa';
import { clamp, PHI, PHI_INV } from '../math/core';

// ── Paper Engine Tags (which engine emitted this record) ─────────────────────

export type PaperEngine =
  | 'ANTIFRAGILITY'       // Paper II+III
  | 'FRACTAL_SOVEREIGNTY' // Paper IV (Kuramoto)
  | 'BEHAVIORAL_ECON'     // Paper V (L-72–79)
  | 'QUIPU_ENGINE'        // Paper VI — QuipuEngine
  | 'QHAPAQ_NAN'          // Paper VI — QhapaqNanMesh
  | 'TAWANTINSUYU'        // Paper VI — TawantinsuyuHub
  | 'TERRACE_BENCH'       // Paper VI — TerraceBench
  | 'LINGUA_COMPRESSA'    // PROT-051
  | 'FUSION_ORGANISM'     // Master orchestrator
  | 'SOVEREIGN';          // agi_main / sovereign_factory

// ── FusionQuipu Record (enriched quipu record) ────────────────────────────────

export interface FusionRecord {
  quipu:         QuipuRecord;
  engine:        PaperEngine;
  severity:      number;         // [0,1] φ-weighted importance
  compressed:    CompressedMessage; // LINGUA COMPRESSA encoded reason
  sccValid:      boolean;           // compression meets SCC ≥ φ² threshold
  engineVersion: string;
}

// ── Internal state ────────────────────────────────────────────────────────────

let fusionRecords: FusionRecord[] = [];
let engineEmitCounts: Partial<Record<PaperEngine, number>> = {};
let totalSovereignRecords = 0;

// ── Write a new FusionQuipu record ────────────────────────────────────────────

export function fusionLog(
  engine:   PaperEngine,
  spine:    QuipuSpine,
  pendant:  QuipuPendant,
  depth:    number,
  value:    number,
  colorTag: string,
  reason:   string,
  parentId  = 0,
): FusionRecord | null {
  const compressed = compress(reason);
  const { valid: sccValid } = validateSCC(compressed);
  const severity = clamp(value * PHI_INV, 0, 1);

  const quipu = quipuAppend(spine, pendant, depth, value, colorTag, engine, reason, parentId);
  if (!quipu) return null;

  const record: FusionRecord = {
    quipu,
    engine,
    severity,
    compressed,
    sccValid,
    engineVersion: 'FUSION-BUILD30',
  };

  fusionRecords.push(record);
  engineEmitCounts[engine] = (engineEmitCounts[engine] || 0) + 1;
  if (engine === 'SOVEREIGN') totalSovereignRecords++;

  // Keep fusion records in sync with quipu cap
  if (fusionRecords.length > 4096) fusionRecords.shift();

  return record;
}

// ── Sovereign executive record (starts as EXECUTING immediately) ───────────────

export function fusionExecutive(
  engine:   PaperEngine,
  spine:    QuipuSpine,
  pendant:  QuipuPendant,
  value:    number,
  colorTag: string,
  reason:   string,
): FusionRecord | null {
  const rec = fusionLog(engine, spine, pendant, 0, value, colorTag, reason, 0);
  if (!rec) return null;
  // Immediately claim and mark executing (sovereign records skip PENDING)
  quipuClaim(rec.quipu.id, `${engine}::SOVEREIGN`);
  return rec;
}

// ── Lifecycle: claim, settle, cancel ─────────────────────────────────────────

export function fusionClaim(fusionId: number, executor: PaperEngine): boolean {
  const rec = fusionRecords.find(r => r.quipu.id === fusionId);
  if (!rec) return false;
  return quipuClaim(fusionId, executor);
}

export function fusionSettle(fusionId: number, outcome: string): boolean {
  return quipuSettle(fusionId, outcome);
}

export function fusionCancel(fusionId: number, reason: string): boolean {
  return quipuCancel(fusionId, reason);
}

// ── Query API ─────────────────────────────────────────────────────────────────

export function fusionGetPending(limit = 20): FusionRecord[] {
  const pendingIds = new Set(quipuGetPending(limit).map(r => r.id));
  return fusionRecords.filter(fr => pendingIds.has(fr.quipu.id));
}

export function fusionGetByEngine(engine: PaperEngine, limit = 50): FusionRecord[] {
  return fusionRecords.filter(fr => fr.engine === engine).slice(-limit);
}

export function fusionGetBySpine(spine: QuipuSpine, limit = 50): FusionRecord[] {
  const records = quipuGetBySpine(spine, limit);
  const ids = new Set(records.map(r => r.id));
  return fusionRecords.filter(fr => ids.has(fr.quipu.id));
}

export function fusionGetByColor(colorTag: string, limit = 50): FusionRecord[] {
  const records = quipuGetByColor(colorTag, limit);
  const ids = new Set(records.map(r => r.id));
  return fusionRecords.filter(fr => ids.has(fr.quipu.id));
}

export function fusionGetSubsidiaries(parentId: number): FusionRecord[] {
  const children = quipuGetSubsidiaries(parentId);
  const ids = new Set(children.map(r => r.id));
  return fusionRecords.filter(fr => ids.has(fr.quipu.id));
}

// ── Metrics and status ────────────────────────────────────────────────────────

export function fusionGetStatus(): {
  totalFusionRecords:    number;
  sovereignRecords:      number;
  engineEmitCounts:      Partial<Record<PaperEngine, number>>;
  sccValidRatio:         number;   // fraction of records with SCC ≥ φ²
  quipuMetrics:          ReturnType<typeof quipuGetMetrics>;
  phi:                   number;
  architecture:          string;
  lifecycle:             string;
} {
  const sccValid = fusionRecords.filter(r => r.sccValid).length;
  const sccRatio = fusionRecords.length > 0 ? sccValid / fusionRecords.length : 0;

  return {
    totalFusionRecords:  fusionRecords.length,
    sovereignRecords:    totalSovereignRecords,
    engineEmitCounts:    { ...engineEmitCounts },
    sccValidRatio:       clamp(sccRatio, 0, 1),
    quipuMetrics:        quipuGetMetrics(),
    phi:                 PHI,
    architecture:        'FUSION_QUIPU: SPINE(domain)→PENDANT(type)→SUBSIDIARY(depth)→KNOT(value)|COLOR(tag)',
    lifecycle:           'PENDING → EXECUTING → SETTLED | CANCELLED',
  };
}

// ── Reset (for test / terrace bench isolation) ─────────────────────────────────

export function fusionQuipuReset(): void {
  fusionRecords = [];
  engineEmitCounts = {};
  totalSovereignRecords = 0;
  quipuReset();
}
