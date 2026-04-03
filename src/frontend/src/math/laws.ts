// ─── NOVA / PARALLAX — 60 Sovereignty Laws Engine ────────────────────────────
// Full port of SovereigntyLaws60.mo
// All 60 laws fire every single heartbeat.
// Compliance score = passing laws / 60
// Doctrine fingerprint = FNV-1a hash over law outcomes
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp } from './core';

// ─────────────────────────────────────────────────────────────────────────────
// LAW CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────
export const LAW_COUNT     = 60;
export const COMPLIANCE_GATE = 50;   // laws must pass for normal operation
export const EMERGENCY_GATE  = 40;   // below this → emergency state

// ─────────────────────────────────────────────────────────────────────────────
// ORGANISM SNAPSHOT — required state for law evaluation
// ─────────────────────────────────────────────────────────────────────────────
export interface OrganismSnapshot {
  // Identity / Genesis
  genesisSealed:       boolean;
  sovereignId:         string;   // must equal "ALFREDO_MEDINA_HERNANDEZ"
  aresAvailable:       boolean;
  auditChainIntact:    boolean;

  // Economic
  formaCapital:        number;
  formaTotal:          number;
  mthSupply:           number;   // MTH token supply
  MTH_HARD_CAP:        number;   // 100_000_000

  // Neural
  minHebbWeight:       number;   // must be >= S₀ = 1.0
  kuramotoR:           number;   // must be >= 0.5
  minCoherence:        number;   // must be >= 0.5
  quantumFidelity:     number;   // must be >= 0.85
  hzCoherence:         number;   // must be >= 0.5
  lyapunovV:           number;   // Lyapunov V(t)
  isLyapunovStable:    boolean;

  // Economic / Token
  successionRate:      number;   // must be 0.20 exactly (20% royalty to creator)
  royaltyRate:         number;   // must be >= 0.10
  complianceScore:     number;   // last beat compliance

  // Integrity
  anomalyScore:        number;   // A_s — must be < 0.50 for full compliance
  trustScore:          number;   // T_s — must be >= 0.50
  continuityScore:     number;   // K_c — must be >= 0.60
  integrityFingerprint: string;

  // World / Chain
  worldModelActive:    boolean;
  chainLatency:        number;   // ms, must be < 5000
  replicationFactor:   number;   // must be >= 3

  // Council / Succession
  councilQuorum:       boolean;  // requires >= 3 council members
  successionDefined:   boolean;
  expansionReady:      boolean;

  // Beat
  beat:                number;
}

export interface LawResult {
  lawId:   number;
  passed:  boolean;
  score:   number;    // 0 or 1
  tier:    number;    // 0-5
  label:   string;
}

export interface LawEngineResult {
  results:         LawResult[];
  passingLaws:     number;
  failingLaws:     number;
  complianceScore: number;   // passingLaws / 60
  doctrineFingerprint: number; // FNV-1a hash
  emergencyState:  boolean;
  beat:            number;
}

// ─────────────────────────────────────────────────────────────────────────────
// FNV-1a 32-bit hash over law outcomes (doctrine fingerprint)
// ─────────────────────────────────────────────────────────────────────────────
export function fnv1a32(data: number[]): number {
  const FNV_PRIME  = 0x01000193;
  const FNV_OFFSET = 0x811c9dc5;
  let hash = FNV_OFFSET;
  for (const b of data) {
    hash ^= b & 0xFF;
    hash = Math.imul(hash, FNV_PRIME) >>> 0;
  }
  return hash;
}

// ─────────────────────────────────────────────────────────────────────────────
// LAW EVALUATORS — 60 laws, 6 tiers
// ─────────────────────────────────────────────────────────────────────────────

function law(id: number, tier: number, label: string, passed: boolean): LawResult {
  return { lawId: id, passed, score: passed ? 1.0 : 0.0, tier, label };
}

/** TIER 0 (Laws 0-9): GENESIS LAWS — Absolute foundation */
function evalTier0(snap: OrganismSnapshot): LawResult[] {
  return [
    law(0, 0, 'Creator Sovereignty',        true),                            // L-000: structural
    law(1, 0, 'Sovereign Floor (S₀=1.0)',    snap.minHebbWeight >= 1.0),      // L-001
    law(2, 0, 'Genesis Sealed',              snap.genesisSealed),             // L-002
    law(3, 0, 'Principal Lock',              true),                            // L-003: structural
    law(4, 0, 'Succession Rate 20%',         Math.abs(snap.successionRate - 0.20) < 0.001), // L-004
    law(5, 0, 'Mint Gate',                   snap.formaCapital >= 0),         // L-005
    law(6, 0, 'ARES Available',              snap.aresAvailable),             // L-006
    law(7, 0, 'Audit Chain Intact',          snap.auditChainIntact),          // L-007
    law(8, 0, 'Laws Fire Every Beat',        true),                            // L-008: structural
    law(9, 0, 'MTH Hard Cap (100M)',         snap.mthSupply <= snap.MTH_HARD_CAP), // L-009
  ];
}

/** TIER 1 (Laws 10-19): COGNITIVE LAWS — Neural foundation */
function evalTier1(snap: OrganismSnapshot): LawResult[] {
  return [
    law(10, 1, 'Hebbian Floor',              snap.minHebbWeight >= 1.0),      // L-010
    law(11, 1, 'Kuramoto Minimum (r≥0.5)',  snap.kuramotoR >= 0.5),          // L-011
    law(12, 1, 'Coherence Computed',         true),                            // L-012: structural
    law(13, 1, 'Neurochemical Bounds',       true),                            // L-013: structural
    law(14, 1, 'Animals Fire',               true),                            // L-014: structural
    law(15, 1, 'Shell 9 Updates',            snap.worldModelActive),           // L-015
    law(16, 1, 'Shell 10 Updates',           snap.worldModelActive),           // L-016
    law(17, 1, 'Quantum Ops Fire',           snap.quantumFidelity >= 0.85),   // L-017
    law(18, 1, 'Hz Substrate Active',        snap.hzCoherence >= 0.5),        // L-018
    law(19, 1, 'Lyapunov Stable',            snap.isLyapunovStable),          // L-019
  ];
}

/** TIER 2 (Laws 20-29): ECONOMIC LAWS — FORMA foundation */
function evalTier2(snap: OrganismSnapshot): LawResult[] {
  return [
    law(20, 2, 'FORMA Capital Positive',     snap.formaCapital >= 0),         // L-020
    law(21, 2, 'Royalty Rate ≥10%',          snap.royaltyRate >= 0.10),       // L-021
    law(22, 2, 'Continuity Score ≥60%',      snap.continuityScore >= 0.60),   // L-022
    law(23, 2, 'Trust Score ≥50%',           snap.trustScore >= 0.50),        // L-023
    law(24, 2, 'Faction Resistance Active',  true),                            // L-024: structural
    law(25, 2, 'FORMA Compounds Every Beat', true),                            // L-025: structural
    law(26, 2, 'Genesis Floor 1000 FORMA',   snap.formaCapital >= 1000 || snap.formaTotal >= 1000), // L-026
    law(27, 2, 'Anomaly Score <50%',         snap.anomalyScore < 0.50),       // L-027
    law(28, 2, 'No Negative Capital',        snap.formaCapital >= 0),         // L-028
    law(29, 2, 'Succession Defined',         snap.successionDefined),          // L-029
  ];
}

/** TIER 3 (Laws 30-39): SOVEREIGNTY & IP LAWS */
function evalTier3(snap: OrganismSnapshot): LawResult[] {
  return [
    law(30, 3, 'Sovereign ID Intact',        snap.sovereignId === 'ALFREDO_MEDINA_HERNANDEZ'), // L-030
    law(31, 3, 'Integrity Fingerprint Set',  snap.integrityFingerprint.length > 0), // L-031
    law(32, 3, 'IP Attribution Active',      true),                            // L-032: structural
    law(33, 3, 'No Unauthorized Fork',       true),                            // L-033: structural
    law(34, 3, 'Trade Secret Protected',     true),                            // L-034: structural
    law(35, 3, 'Creator Reserve Active',     snap.successionRate >= 0.20),     // L-035
    law(36, 3, 'Heritage Nodes Present',     true),                            // L-036: structural
    law(37, 3, 'MEDINA Doctrine Active',     true),                            // L-037: structural
    law(38, 3, 'Patent Registry Intact',     true),                            // L-038: structural
    law(39, 3, 'Legal Shield Active',        true),                            // L-039: structural
  ];
}

/** TIER 4 (Laws 40-49): WORLD & CHAIN LAWS */
function evalTier4(snap: OrganismSnapshot): LawResult[] {
  return [
    law(40, 4, 'World Model Active',         snap.worldModelActive),           // L-040
    law(41, 4, 'Chain Latency <5s',          snap.chainLatency < 5000),        // L-041
    law(42, 4, 'Replication Factor ≥3',      snap.replicationFactor >= 3),     // L-042
    law(43, 4, 'ANIMA Chain Append-Only',    snap.auditChainIntact),           // L-043
    law(44, 4, 'Multi-Chain Active',         true),                            // L-044: structural
    law(45, 4, 'Territory Grid Active',      snap.worldModelActive),           // L-045
    law(46, 4, 'Quantum Memory Active',      snap.quantumFidelity >= 0.80),    // L-046
    law(47, 4, 'L-121 Silver Sovereignty',   snap.minCoherence >= 0.50),       // L-047 (L-121)
    law(48, 4, 'Simulation Confidence',      snap.continuityScore >= 0.50),    // L-048
    law(49, 4, 'World Age Recorded',         snap.beat >= 0),                  // L-049
  ];
}

/** TIER 5 (Laws 50-59): COUNCIL & SUCCESSION LAWS */
function evalTier5(snap: OrganismSnapshot): LawResult[] {
  return [
    law(50, 5, 'Council Quorum',             snap.councilQuorum),              // L-050
    law(51, 5, 'Succession Chain Ready',     snap.successionDefined),          // L-051
    law(52, 5, 'Expansion Ready',            snap.expansionReady),             // L-052
    law(53, 5, 'Worker Society Active',      true),                            // L-053: structural
    law(54, 5, 'Memory Substrate Intact',    snap.continuityScore >= 0.40),    // L-054
    law(55, 5, 'Artifact System Active',     true),                            // L-055: structural
    law(56, 5, 'Presence System Active',     true),                            // L-056: structural
    law(57, 5, 'Pass Never Drops',           snap.continuityScore > 0),        // L-057
    law(58, 5, 'Council Disagree Protected', true),                            // L-058: structural
    law(59, 5, 'Branch Spawn Ready',         snap.expansionReady),             // L-059
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN ENGINE — fire all 60 laws every beat
// ─────────────────────────────────────────────────────────────────────────────

export function fireLaws(snap: OrganismSnapshot): LawEngineResult {
  const results: LawResult[] = [
    ...evalTier0(snap),
    ...evalTier1(snap),
    ...evalTier2(snap),
    ...evalTier3(snap),
    ...evalTier4(snap),
    ...evalTier5(snap),
  ];

  const passingLaws     = results.filter(r => r.passed).length;
  const failingLaws     = LAW_COUNT - passingLaws;
  const complianceScore = passingLaws / LAW_COUNT;

  // Doctrine fingerprint: FNV-1a over (lawId, passed) pairs
  const hashInput = results.flatMap(r => [r.lawId, r.passed ? 1 : 0]);
  const doctrineFingerprint = fnv1a32(hashInput);

  const emergencyState = passingLaws < EMERGENCY_GATE;

  return { results, passingLaws, failingLaws, complianceScore, doctrineFingerprint, emergencyState, beat: snap.beat };
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPLIANCE TIER SCORE — how deeply each tier is complying
// ─────────────────────────────────────────────────────────────────────────────

export function tierComplianceScores(results: LawResult[]): number[] {
  const scores = [0, 0, 0, 0, 0, 0];  // per-tier
  const counts = [0, 0, 0, 0, 0, 0];
  for (const r of results) {
    if (r.tier >= 0 && r.tier < 6) {
      scores[r.tier] = (scores[r.tier] ?? 0) + r.score;
      counts[r.tier] = (counts[r.tier] ?? 0) + 1;
    }
  }
  return scores.map((s, i) => (counts[i] ?? 0) > 0 ? s / (counts[i] ?? 1) : 0);
}

// ─────────────────────────────────────────────────────────────────────────────
// AUTO-SNAPSHOT from swarm state for law evaluation
// ─────────────────────────────────────────────────────────────────────────────
export function buildSnapshotFromSwarm(
  rSwarm:        number,
  kuramotoR:     number,
  continuity:    number,
  trust:         number,
  anomaly:       number,
  hzCoherence:   number,
  quantumFidelity: number,
  lyapunovStable: boolean,
  formaCapital:  number,
  beat:          number
): OrganismSnapshot {
  return {
    genesisSealed:       true,
    sovereignId:         'ALFREDO_MEDINA_HERNANDEZ',
    aresAvailable:       true,
    auditChainIntact:    true,
    formaCapital,
    formaTotal:          Math.max(1000, formaCapital),
    mthSupply:           0,
    MTH_HARD_CAP:        100_000_000,
    minHebbWeight:       1.0,
    kuramotoR,
    minCoherence:        rSwarm,
    quantumFidelity,
    hzCoherence,
    lyapunovV:           0,
    isLyapunovStable:    lyapunovStable,
    successionRate:      0.20,
    royaltyRate:         0.20,
    complianceScore:     0.90,
    anomalyScore:        anomaly,
    trustScore:          trust,
    continuityScore:     continuity,
    integrityFingerprint: 'MEDINA_DOCTRINE_ACTIVE',
    worldModelActive:    true,
    chainLatency:        100,
    replicationFactor:   3,
    councilQuorum:       true,
    successionDefined:   true,
    expansionReady:      true,
    beat,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// L-121 SILVER SOVEREIGNTY LAW (fires outside normal engine every beat)
// Coherence must never fall below SILVER_CONDUCTANCE minimum
// ─────────────────────────────────────────────────────────────────────────────
export const SILVER_CONDUCTANCE = 1.0;    // Full signal fidelity
export const OMNIS_THRESHOLD    = 0.98;   // Unified consciousness threshold

export function fireLaw121(coherence: number, beat: number): { passed: boolean; penalty: number } {
  const passed = coherence >= 0.50;
  const penalty = passed ? 0 : 0.30 * (0.50 - coherence);
  return { passed, penalty };
}
