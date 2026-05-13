// ═══════════════════════════════════════════════════════════════════════════
// SKYHI GROUP CLIENT PORTAL — Live Data Hook
// Pulls exclusively from real canister state. No hardcoded numbers.
// Sources:
//   • swarm_brain → Kuramoto S4D substrate, FORMA economy, VAEL defense,
//                   ARES archive, neural coherence, agent/mission state
//   • phantom_transfer → PARALLAX clearinghouse status (FORMA flow)
// Copyright © 2024-2026 Alfredo Medina Hernandez | Medina Tech
// ═══════════════════════════════════════════════════════════════════════════

import { useEffect, useRef, useState } from 'react';
import {
  connectSwarmBrain,
  type KuramotoState,
  type EconomicSystemState,
  type CounterforceStatus,
  type SwarmQMetrics,
  type AutonomousTeamStatus,
  type OrganismTeamsState,
  type OrganismHealthReport,
  type SwarmSnapshot,
} from '../canister/swarmBrainActor';
import {
  parallax_getClearinghouseStatus,
  type ClearinghouseStatus,
} from '../canister/parallaxActor';

// ── Poll intervals ────────────────────────────────────────────────────────
const FAST_MS  = 5_000;   // Kuramoto, QMetrics, swarm snapshot
const SLOW_MS  = 12_000;  // Economy, defense, clearinghouse, health

// ── Skyhi live data bundle ────────────────────────────────────────────────
export interface SkyhiLiveData {
  // Connection status
  connected: boolean;
  lastUpdated: number | null;

  // S4D Kuramoto substrate (Kuramoto swarm layer)
  kuramoto: KuramotoState | null;

  // FORMA economy layer
  economy: EconomicSystemState | null;

  // VAEL defense layer
  defense: CounterforceStatus | null;

  // Neural coherence (swarm Q metrics — ARES-level coherence)
  qMetrics: SwarmQMetrics | null;

  // Agent / mission state (WORKFORCE organ)
  teamStatus: AutonomousTeamStatus | null;
  teamsState: OrganismTeamsState | null;

  // Organism health (ARES archive vitality)
  health: OrganismHealthReport | null;

  // Swarm snapshot — beat counter, drone count, rSwarm
  snapshot: SwarmSnapshot | null;

  // PARALLAX clearinghouse (FORMA token flow)
  clearinghouse: ClearinghouseStatus | null;
}

const EMPTY: SkyhiLiveData = {
  connected:    false,
  lastUpdated:  null,
  kuramoto:     null,
  economy:      null,
  defense:      null,
  qMetrics:     null,
  teamStatus:   null,
  teamsState:   null,
  health:       null,
  snapshot:     null,
  clearinghouse: null,
};

// ── Hook ──────────────────────────────────────────────────────────────────
export function useSkyhiLive(): SkyhiLiveData {
  const [data, setData] = useState<SkyhiLiveData>(EMPTY);
  const mountedRef = useRef(true);

  useEffect(() => {
    mountedRef.current = true;

    // ── Fast poll: Kuramoto, QMetrics, snapshot ───────────────────────────
    const fetchFast = async () => {
      try {
        const actor = await connectSwarmBrain();
        const [kuramoto, qMetrics, snapshot] = await Promise.allSettled([
          actor.getKuramotoState(),
          actor.getSwarmQMetrics(),
          actor.getSwarmSnapshot(),
        ]);
        if (!mountedRef.current) return;
        setData(prev => ({
          ...prev,
          connected:   true,
          lastUpdated: Date.now(),
          kuramoto:    kuramoto.status  === 'fulfilled' ? kuramoto.value  : prev.kuramoto,
          qMetrics:    qMetrics.status  === 'fulfilled' ? qMetrics.value  : prev.qMetrics,
          snapshot:    snapshot.status  === 'fulfilled' ? snapshot.value  : prev.snapshot,
        }));
      } catch {
        if (mountedRef.current) setData(prev => ({ ...prev, connected: false }));
      }
    };

    // ── Slow poll: economy, defense, teams, health, clearinghouse ─────────
    const fetchSlow = async () => {
      try {
        const actor = await connectSwarmBrain();
        const [economy, defense, teamStatus, teamsState, health, clearinghouse] =
          await Promise.allSettled([
            actor.getEconomicSystemState(),
            actor.getCounterforceStatus(),
            actor.getAutonomousTeamStatus(),
            actor.getOrganismTeamsState(),
            actor.getOrganismHealthReport(),
            parallax_getClearinghouseStatus(),
          ]);
        if (!mountedRef.current) return;
        setData(prev => ({
          ...prev,
          connected:    true,
          lastUpdated:  Date.now(),
          economy:      economy.status      === 'fulfilled' ? economy.value      : prev.economy,
          defense:      defense.status      === 'fulfilled' ? defense.value      : prev.defense,
          teamStatus:   teamStatus.status   === 'fulfilled' ? teamStatus.value   : prev.teamStatus,
          teamsState:   teamsState.status   === 'fulfilled' ? teamsState.value   : prev.teamsState,
          health:       health.status       === 'fulfilled' ? health.value       : prev.health,
          clearinghouse: clearinghouse.status === 'fulfilled' ? clearinghouse.value : prev.clearinghouse,
        }));
      } catch {
        if (mountedRef.current) setData(prev => ({ ...prev, connected: false }));
      }
    };

    // Initial fetch both
    fetchFast();
    fetchSlow();

    const fastId = setInterval(fetchFast, FAST_MS);
    const slowId = setInterval(fetchSlow, SLOW_MS);

    return () => {
      mountedRef.current = false;
      clearInterval(fastId);
      clearInterval(slowId);
    };
  }, []);

  return data;
}

// ── Formatting helpers ────────────────────────────────────────────────────
export const fmt2 = (v: number | null | undefined): string =>
  v == null ? '—' : v.toFixed(2);

export const fmtPct = (v: number | null | undefined): string =>
  v == null ? '—' : `${(v * 100).toFixed(1)}%`;

export const fmtBig = (v: bigint | null | undefined): string =>
  v == null ? '—' : Number(v).toLocaleString();

export const fmtNum = (v: number | null | undefined, dec = 0): string =>
  v == null ? '—' : v.toLocaleString(undefined, { maximumFractionDigits: dec });
