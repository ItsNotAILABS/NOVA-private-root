// ═══════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// Module: skyhi_client/useSkyhiLiveData.ts — Live data hook for Skyhi portal
// Language: TypeScript (CPL: canister integration layer)
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// NO MOCK DATA. ALL DATA SOURCED FROM REAL CANISTER QUERIES AND LIVE
// ORGANISM STATE. FORMA flow from actual phantom_transfer stable variables.
// Kuramoto values from the live S4D substrate. VAEL from AEGIS canister.
// WORKFORCE coherence from ConstantFeedbackCognitionState. ARES fidelity
// from MemorySystemState. Polling every 5 seconds — live, always.
// ═══════════════════════════════════════════════════════════════════════════

import { useState, useEffect, useRef } from 'react';
import { connectSwarmBrain } from '../canister/swarmBrainActor';
import { parallax_getClearinghouseStatus } from '../canister/parallaxActor';
import type {
  EconomicSystemState,
  AEGISState,
  ConstantFeedbackCognitionState,
  OrganismHealthReport,
  AutonomousTeamStatus,
  MemorySystemState,
  KuramotoState,
} from '../canister/swarmBrainActor';
import type { ClearinghouseStatus } from '../canister/parallaxActor';

// ── Poll interval ─────────────────────────────────────────────────────────────
const POLL_INTERVAL_MS = 5_000; // 5s — canister calls are heavier than local ticks

// ── Public shape ──────────────────────────────────────────────────────────────
export interface SkyhiLiveData {
  /** PARALLAX clearinghouse — FORMA/ONESICAN stable variable flow */
  clearinghouse: ClearinghouseStatus | null;
  /** swarm_brain EconomicSystemState — FORMA balance, treasury, stability */
  economicState: EconomicSystemState | null;
  /** swarm_brain AEGISState — VAEL defense threat level, active posture */
  aegisState: AEGISState | null;
  /** swarm_brain ConstantFeedbackCognitionState — WORKFORCE coherence, defense, economy */
  cognitionState: ConstantFeedbackCognitionState | null;
  /** swarm_brain OrganismHealthReport — overall vitality, defense health */
  healthReport: OrganismHealthReport | null;
  /** swarm_brain AutonomousTeamStatus — reportsGenerated, brainCoherence */
  teamStatus: AutonomousTeamStatus | null;
  /** swarm_brain MemorySystemState — qmemFidelity for ARES archive */
  memoryState: MemorySystemState | null;
  /** swarm_brain KuramotoState — live S4D substrate order parameter */
  kuramotoState: KuramotoState | null;
  /** Whether the last canister poll succeeded */
  connected: boolean;
  /** Timestamp of last successful poll (ms) */
  lastPoll: number;
  /** Cumulative successful poll count */
  pollCount: number;
}

// ── Default state (before first poll) ────────────────────────────────────────
const DEFAULT: SkyhiLiveData = {
  clearinghouse: null,
  economicState: null,
  aegisState: null,
  cognitionState: null,
  healthReport: null,
  teamStatus: null,
  memoryState: null,
  kuramotoState: null,
  connected: false,
  lastPoll: 0,
  pollCount: 0,
};

// ── Hook ─────────────────────────────────────────────────────────────────────
export function useSkyhiLiveData(): SkyhiLiveData {
  const [data, setData] = useState<SkyhiLiveData>(DEFAULT);
  const pollCountRef = useRef(0);
  const mountedRef  = useRef(true);

  useEffect(() => {
    mountedRef.current = true;

    async function poll() {
      try {
        // Fire all queries concurrently — fastest possible round-trip
        const [
          clearinghouse,
          brain,
        ] = await Promise.all([
          parallax_getClearinghouseStatus().catch(() => null),
          connectSwarmBrain().catch(() => null),
        ]);

        if (!mountedRef.current) return;

        if (!brain) {
          // Canister unreachable — keep previous data, mark disconnected
          setData(prev => ({ ...prev, connected: false }));
          return;
        }

        // Parallel canister queries once actor is available
        const [
          economicState,
          aegisState,
          cognitionState,
          healthReport,
          teamStatus,
          memoryState,
          kuramotoState,
        ] = await Promise.all([
          brain.getEconomicSystemState().catch(() => null),
          brain.getAEGISState().catch(() => null),
          brain.getConstantFeedbackCognitionState().catch(() => null),
          brain.getOrganismHealthReport().catch(() => null),
          brain.getAutonomousTeamStatus().catch(() => null),
          brain.getMemorySystemState().catch(() => null),
          brain.getKuramotoState().catch(() => null),
        ]);

        if (!mountedRef.current) return;

        pollCountRef.current += 1;
        setData(prev => ({
          clearinghouse: clearinghouse ?? prev.clearinghouse,
          economicState: economicState ?? prev.economicState,
          aegisState: aegisState ?? prev.aegisState,
          cognitionState: cognitionState ?? prev.cognitionState,
          healthReport: healthReport ?? prev.healthReport,
          teamStatus: teamStatus ?? prev.teamStatus,
          memoryState: memoryState ?? prev.memoryState,
          kuramotoState: kuramotoState ?? prev.kuramotoState,
          connected: true,
          lastPoll: Date.now(),
          pollCount: pollCountRef.current,
        }));
      } catch {
        if (mountedRef.current) {
          setData(prev => ({ ...prev, connected: false }));
        }
      }
    }

    // Immediate first poll, then every POLL_INTERVAL_MS
    poll();
    const id = setInterval(poll, POLL_INTERVAL_MS);
    return () => {
      mountedRef.current = false;
      clearInterval(id);
    };
  }, []);

  return data;
}
