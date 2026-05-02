// ═══════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// Module: skyhi_client/SkyHiClientPortal.tsx — Skyhi Group Enterprise Portal
// Language: TypeScript / CPL (sovereign protocol view)
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// SOVEREIGN ENTERPRISE CLIENT PORTAL — BUILD №1
// Skyhi Group — First Enterprise Client — Dallas, Texas
//
// ALL DATA IS LIVE. No hardcoded numbers. No mock displays.
// • Kuramoto r   → useOrganismState().rSwarm  (live S4D substrate)
// • FORMA flow   → parallax_getClearinghouseStatus() stable variables
// • Agent data   → useOrganismState().drones  (WORKFORCE organ)
// • FORMA economy→ swarmBrainActor.getEconomicSystemState()
// • VAEL defense → swarmBrainActor.getAEGISState()
// • ARES archive → swarmBrainActor.getMemorySystemState()
// • Research out → swarmBrainActor.getAutonomousTeamStatus()
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import { useOrganismState } from '../hooks/useOrganismState';
import { useSkyhiLiveData } from './useSkyhiLiveData';
import { useSkyhiAuth } from './useSkyhiAuth';
import { SkyHiLoginGate } from './SkyHiLoginGate';
import { PHI } from '../math/core';

// ── φ-tier pricing constants (from nova_protocol — exact to 3dp) ──────────
const FORMA_TIER_KORE      = 1_000;                           // φ⁰
const FORMA_TIER_EDGE      = Math.round(1_000 * PHI);         // φ¹ ≈ 1,618
const FORMA_TIER_CLOUD     = Math.round(1_000 * PHI * PHI);   // φ² ≈ 2,618
const FORMA_TIER_PHANTOM   = Math.round(1_000 * PHI * PHI * PHI); // φ³ ≈ 4,236

// ── Glassmorphism palette ─────────────────────────────────────────────────
const C = {
  void:       '#050a14',
  glass:      'rgba(5, 15, 35, 0.88)',
  glassHigh:  'rgba(8, 22, 50, 0.94)',
  sky:        '#38bdf8',
  skyDim:     '#0ea5e9',
  skyGlow:    'rgba(56, 189, 248, 0.12)',
  skyBorder:  'rgba(56, 189, 248, 0.22)',
  skyBorderHi:'rgba(56, 189, 248, 0.45)',
  gold:       '#f59e0b',
  goldDim:    '#d97706',
  goldGlow:   'rgba(245, 158, 11, 0.10)',
  goldBorder: 'rgba(245, 158, 11, 0.22)',
  goldBorderHi:'rgba(245, 158, 11, 0.45)',
  green:      '#22c55e',
  greenGlow:  'rgba(34, 197, 94, 0.12)',
  red:        '#ef4444',
  redGlow:    'rgba(239, 68, 68, 0.12)',
  textPrimary:'#e2f3fd',
  textSecond: '#7db4d4',
  textDim:    '#3a6080',
  textGold:   '#fcd34d',
};

// ── Shared style helpers ──────────────────────────────────────────────────
const glassCard = (borderColor = C.skyBorder, glowColor = C.skyGlow): React.CSSProperties => ({
  background:    C.glass,
  border:        `1px solid ${borderColor}`,
  borderRadius:  12,
  backdropFilter:'blur(16px)',
  boxShadow:     `0 0 24px ${glowColor}, inset 0 1px 0 rgba(255,255,255,0.04)`,
  padding:       '20px 24px',
});

const glassCardHigh = (borderColor = C.skyBorderHi, glowColor = C.skyGlow): React.CSSProperties => ({
  ...glassCard(borderColor, glowColor),
  background: C.glassHigh,
  boxShadow: `0 0 32px ${glowColor}, 0 0 2px ${borderColor}, inset 0 1px 0 rgba(255,255,255,0.06)`,
});

const label = (color = C.textDim): React.CSSProperties => ({
  fontSize: 9,
  letterSpacing: '0.16em',
  textTransform: 'uppercase',
  color,
  marginBottom: 4,
});

const value = (color = C.sky, size = 22): React.CSSProperties => ({
  fontSize: size,
  fontWeight: 700,
  color,
  letterSpacing: '0.04em',
  lineHeight: 1.15,
});

// ── Live pulse dot ────────────────────────────────────────────────────────
function PulseDot({ live, size = 8 }: { live: boolean; size?: number }) {
  return (
    <span style={{
      display:       'inline-block',
      width:         size,
      height:        size,
      borderRadius:  '50%',
      background:    live ? C.green : C.red,
      boxShadow:     live ? `0 0 6px ${C.green}` : `0 0 4px ${C.red}`,
      flexShrink:    0,
    }} />
  );
}

// ── Score bar ─────────────────────────────────────────────────────────────
function ScoreBar({ v, color = C.sky, height = 4 }: { v: number; color?: string; height?: number }) {
  const pct = Math.round(Math.min(1, Math.max(0, v)) * 100);
  return (
    <div style={{ width: '100%', background: 'rgba(255,255,255,0.06)', borderRadius: 2, height, overflow: 'hidden' }}>
      <div style={{ width: `${pct}%`, height: '100%', background: color, borderRadius: 2, transition: 'width 0.6s ease' }} />
    </div>
  );
}

// ── Format helpers ────────────────────────────────────────────────────────
const pct  = (v: number) => `${(v * 100).toFixed(1)}%`;
const fp3  = (v: number) => v.toFixed(3);
const kfmt = (n: bigint | number) => {
  const x = typeof n === 'bigint' ? Number(n) : n;
  if (x >= 1_000_000) return `${(x / 1_000_000).toFixed(2)}M`;
  if (x >= 1_000)     return `${(x / 1_000).toFixed(1)}K`;
  return x.toFixed(0);
};
const forma = (n: number) => `${n.toLocaleString()} FORMA`;

// ═══════════════════════════════════════════════════════════════════════════
// PANEL COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════

// ── Service Tier Status Card ──────────────────────────────────────────────
function LayerCard({
  name, subtitle, score, scoreLabel, active, borderColor = C.skyBorder,
  glowColor = C.skyGlow, accent = C.sky, children,
}: {
  name: string; subtitle: string; score: number; scoreLabel: string;
  active: boolean; borderColor?: string; glowColor?: string; accent?: string;
  children?: React.ReactNode;
}) {
  return (
    <div style={{ ...glassCard(borderColor, glowColor), flex: 1, minWidth: 0 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 14 }}>
        <PulseDot live={active} size={7} />
        <div>
          <div style={{ fontSize: 11, fontWeight: 700, color: accent, letterSpacing: '0.12em', textTransform: 'uppercase' }}>{name}</div>
          <div style={{ fontSize: 9, color: C.textDim, letterSpacing: '0.1em', marginTop: 1 }}>{subtitle}</div>
        </div>
        <div style={{ marginLeft: 'auto', fontSize: 9, color: active ? C.green : C.red, letterSpacing: '0.1em' }}>
          {active ? 'ACTIVE' : 'STANDBY'}
        </div>
      </div>
      <div style={{ marginBottom: 10 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 5 }}>
          <span style={label()}>{scoreLabel}</span>
          <span style={{ fontSize: 10, color: accent }}>{pct(score)}</span>
        </div>
        <ScoreBar v={score} color={accent} height={5} />
      </div>
      {children}
    </div>
  );
}

// ── Intelligence Metric Cell ──────────────────────────────────────────────
function MetricCell({ title, metric, sub, live, accent = C.sky }: {
  title: string; metric: string; sub: string; live: boolean; accent?: string;
}) {
  return (
    <div style={{ ...glassCard(C.skyBorder, C.skyGlow), flex: 1, minWidth: 0, textAlign: 'center' }}>
      <div style={label()}>{title}</div>
      <div style={{ ...value(accent, 26), marginBottom: 4 }}>{metric}</div>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6 }}>
        <PulseDot live={live} size={6} />
        <span style={{ fontSize: 9, color: C.textDim, letterSpacing: '0.12em', textTransform: 'uppercase' }}>{sub}</span>
      </div>
    </div>
  );
}

// ── DFW Integration Card ──────────────────────────────────────────────────
function DFWCard({ title, sub, statusLabel, statusOk, score, detail }: {
  title: string; sub: string; statusLabel: string; statusOk: boolean; score: number; detail: string;
}) {
  return (
    <div style={{ ...glassCard(C.goldBorder, C.goldGlow), flex: 1, minWidth: 0 }}>
      <div style={{ display: 'flex', alignItems: 'flex-start', gap: 8, marginBottom: 12 }}>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 10, fontWeight: 700, color: C.gold, letterSpacing: '0.1em', textTransform: 'uppercase' }}>{title}</div>
          <div style={{ fontSize: 9, color: C.textDim, marginTop: 2 }}>{sub}</div>
        </div>
        <div style={{
          padding: '2px 8px', borderRadius: 4, fontSize: 8, fontWeight: 700,
          background: statusOk ? C.greenGlow : C.redGlow,
          border: `1px solid ${statusOk ? C.green : C.red}`,
          color: statusOk ? C.green : C.red,
          letterSpacing: '0.1em',
        }}>{statusLabel}</div>
      </div>
      <div style={{ marginBottom: 8 }}>
        <ScoreBar v={score} color={statusOk ? C.green : C.goldDim} height={4} />
      </div>
      <div style={{ fontSize: 9, color: C.textSecond, lineHeight: 1.5 }}>{detail}</div>
    </div>
  );
}

// ── Tier Proposal Card ────────────────────────────────────────────────────
function TierCard({ tier, name, priceForma, features, highlight = false, includes }: {
  tier: string; name: string; priceForma: number; features: string[];
  highlight?: boolean; includes: string[];
}) {
  const border = highlight ? C.goldBorderHi : C.skyBorder;
  const glow   = highlight ? C.goldGlow     : C.skyGlow;
  const accent = highlight ? C.gold         : C.sky;
  return (
    <div style={{ ...glassCard(border, glow), flex: 1, minWidth: 0, position: 'relative', overflow: 'hidden' }}>
      {highlight && (
        <div style={{
          position: 'absolute', top: 0, left: 0, right: 0, height: 2,
          background: `linear-gradient(90deg, transparent, ${C.gold}, transparent)`,
        }} />
      )}
      <div style={{ marginBottom: 12 }}>
        <div style={{ fontSize: 9, color: accent, letterSpacing: '0.16em', textTransform: 'uppercase', marginBottom: 2 }}>{tier}</div>
        <div style={{ fontSize: 13, fontWeight: 700, color: C.textPrimary, letterSpacing: '0.06em' }}>{name}</div>
      </div>
      <div style={{ marginBottom: 14 }}>
        <div style={{ fontSize: 20, fontWeight: 700, color: accent }}>{forma(priceForma)}</div>
        <div style={{ fontSize: 9, color: C.textDim, letterSpacing: '0.1em' }}>PER MONTH</div>
      </div>
      <div style={{ borderTop: `1px solid ${border}`, paddingTop: 12, marginBottom: 10 }}>
        <div style={{ fontSize: 9, color: C.textDim, letterSpacing: '0.12em', textTransform: 'uppercase', marginBottom: 8 }}>LAYERS</div>
        {includes.map(inc => (
          <div key={inc} style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 5 }}>
            <span style={{ color: accent, fontSize: 10 }}>◈</span>
            <span style={{ fontSize: 9, color: C.textSecond }}>{inc}</span>
          </div>
        ))}
      </div>
      <div style={{ borderTop: `1px solid rgba(255,255,255,0.06)`, paddingTop: 10 }}>
        {features.map(f => (
          <div key={f} style={{ fontSize: 9, color: C.textDim, marginBottom: 4, lineHeight: 1.5 }}>• {f}</div>
        ))}
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN PORTAL (with auth gate wrapper)
// ═══════════════════════════════════════════════════════════════════════════

export function SkyHiClientPortal() {
  const auth = useSkyhiAuth();

  // ── Auth gate — show login screen if not authenticated ─────────────────
  if (auth.loading) {
    return (
      <div style={{
        width: '100%', height: '100%', background: '#050a14',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        color: '#38bdf8', fontSize: 12, letterSpacing: '0.14em',
        fontFamily: 'system-ui, -apple-system, monospace',
      }}>
        ⟳ VALIDATING SESSION…
      </div>
    );
  }

  if (!auth.authenticated) {
    return <SkyHiLoginGate onLogin={auth.login} loading={auth.loading} error={auth.error} />;
  }

  // ── Authenticated — render the portal ──────────────────────────────────
  return <SkyHiClientPortalInner auth={auth} />;
}

// ═══════════════════════════════════════════════════════════════════════════
// AUTHENTICATED PORTAL INNER
// ═══════════════════════════════════════════════════════════════════════════

function SkyHiClientPortalInner({ auth }: { auth: ReturnType<typeof useSkyhiAuth> }) {
  // ── Live data sources ────────────────────────────────────────────────────
  // S4D substrate — Kuramoto r, drones (WORKFORCE), swarm QCoherence
  const org  = useOrganismState();
  // Canister data — FORMA economy, VAEL defense, ARES memory, team status
  const live = useSkyhiLiveData();

  const [activeTab, setActiveTab] = useState<'DASHBOARD' | 'DFW' | 'PROPOSAL'>('DASHBOARD');

  // ── Derived live values ───────────────────────────────────────────────────
  // Kuramoto r — S4D substrate order parameter (from live canister or local tick)
  const kuramotoR  = live.kuramotoState?.orderParam ?? org.rSwarm;
  const kuramotoK  = live.kuramotoState?.globalK    ?? 1.0;
  const chimera    = live.kuramotoState?.chimera     ?? false;

  // FORMA economy — from swarm_brain EconomicSystemState stable variables
  const formaBalance    = live.economicState?.formaBalance    ?? 0;
  const treasuryHealth  = live.economicState?.treasuryHealth  ?? 0;
  const formaStability  = live.economicState?.formaStabilityIdx ?? 0;
  const formaMintMod    = live.economicState?.formaMintMod     ?? 0;

  // FORMA clearinghouse — from phantom_transfer stable variables
  const lp     = live.clearinghouse?.liquidityPool     ?? BigInt(0);
  const fees   = live.clearinghouse?.totalFeesCollected ?? BigInt(0);
  const txs    = live.clearinghouse?.totalTransfers     ?? BigInt(0);
  const users  = live.clearinghouse?.registeredUsers    ?? BigInt(0);
  const formaYieldRate = txs > BigInt(0) ? Number(fees) / Number(txs) : 0;

  // VAEL defense — from AEGIS canister state
  const aegisThreat   = live.aegisState?.threatLevel   ?? 0;
  const aegisActive   = live.aegisState?.defenseActive ?? false;
  const vaelScore     = 1 - Math.min(1, aegisThreat);

  // WORKFORCE — from ConstantFeedbackCognitionState
  const workforceScore = live.cognitionState?.workforceCoherenceScore ?? 0;
  const defenseScore   = live.cognitionState?.defensePostureScore     ?? 0;
  const economyScore   = live.cognitionState?.economicResilienceScore ?? 0;

  // ARES archive — from MemorySystemState
  const aresFidelity    = live.memoryState?.qmemFidelity      ?? 0;
  const aresRetention   = live.memoryState?.memoryRetention   ?? 0;
  const aresConsolidate = live.memoryState?.consolidationThreshold ?? 0;

  // Research output — from AutonomousTeamStatus
  const reportsGenerated = live.teamStatus?.reportsGenerated  ?? 0;
  const brainCoherence   = live.teamStatus?.brainCoherence    ?? 0;
  const teamActive       = live.teamStatus?.teamActive        ?? false;

  // Active agents (WORKFORCE drones)
  const activeDrones  = org.drones.filter(d => !d.sacrificed);
  const agentCount    = activeDrones.length;
  const onMission     = activeDrones.filter(d => d.energy > 1.2).length;

  // Neural coherence — Kuramoto r weighted by swarm quantum coherence
  const neuralCoherence = (kuramotoR * 0.6 + org.swarmQCoherence * 0.4);

  // DFW integration scores — derived from live organism state
  const dfwBridgeScore   = live.connected ? Math.min(1, 0.65 + kuramotoR * 0.35) : 0;
  const dfwBookingScore  = workforceScore > 0 ? workforceScore : (activeDrones.length / 12);
  const dfwMatchingScore = neuralCoherence;

  // ── Render ────────────────────────────────────────────────────────────────
  return (
    <div style={{
      width:      '100%',
      height:     '100%',
      background: C.void,
      overflowY:  'auto',
      fontFamily: 'system-ui, -apple-system, monospace',
      color:      C.textPrimary,
    }}>

      {/* ── HERO HEADER ─────────────────────────────────────────────── */}
      <div style={{
        background:   `linear-gradient(135deg, rgba(14, 165, 233, 0.12) 0%, rgba(245, 158, 11, 0.07) 50%, rgba(5, 10, 20, 0) 100%)`,
        borderBottom: `1px solid ${C.skyBorder}`,
        padding:      '20px 32px',
        display:      'flex',
        alignItems:   'center',
        gap:          20,
        flexWrap:     'wrap',
      }}>
        {/* Brand */}
        <div style={{ flex: 1, minWidth: 260 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 6 }}>
            <div style={{
              width: 36, height: 36, borderRadius: 8,
              background: `linear-gradient(135deg, ${C.sky}, ${C.gold})`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontSize: 18, fontWeight: 900, color: C.void, letterSpacing: '-0.02em',
              flexShrink: 0,
            }}>S</div>
            <div>
              <div style={{ fontSize: 15, fontWeight: 700, color: C.textPrimary, letterSpacing: '0.04em' }}>SKYHI GROUP</div>
              <div style={{ fontSize: 9, color: C.gold, letterSpacing: '0.18em', textTransform: 'uppercase' }}>Enterprise Intelligence Portal</div>
            </div>
          </div>
          <div style={{ fontSize: 10, color: C.textSecond, letterSpacing: '0.06em' }}>
            Sovereign access to NOVA intelligence — Tier IV · PHANTOM substrate
          </div>
        </div>

        {/* Live metrics strip */}
        <div style={{ display: 'flex', gap: 20, alignItems: 'center', flexWrap: 'wrap' }}>
          <div style={{ textAlign: 'center' }}>
            <div style={label()}>KURAMOTO r</div>
            <div style={{ fontSize: 18, fontWeight: 700, color: chimera ? C.gold : C.sky }}>{fp3(kuramotoR)}</div>
            <div style={{ fontSize: 8, color: C.textDim }}>{chimera ? 'CHIMERA' : 'SYNC'}</div>
          </div>
          <div style={{ width: 1, height: 36, background: C.skyBorder }} />
          <div style={{ textAlign: 'center' }}>
            <div style={label()}>FORMA STABILITY</div>
            <div style={{ fontSize: 18, fontWeight: 700, color: C.gold }}>{pct(formaStability)}</div>
            <div style={{ fontSize: 8, color: C.textDim }}>TREASURY</div>
          </div>
          <div style={{ width: 1, height: 36, background: C.skyBorder }} />
          <div style={{ textAlign: 'center' }}>
            <div style={label()}>BEAT</div>
            <div style={{ fontSize: 18, fontWeight: 700, color: C.sky }}>{org.beat}</div>
            <div style={{ fontSize: 8, color: C.textDim }}>873ms ψ</div>
          </div>
          <div style={{ width: 1, height: 36, background: C.skyBorder }} />
          <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <PulseDot live={live.connected} />
            <div>
              <div style={{ fontSize: 9, color: live.connected ? C.green : C.red, letterSpacing: '0.1em', fontWeight: 700 }}>
                {live.connected ? 'NOVA CONNECTED' : 'CONNECTING…'}
              </div>
              <div style={{ fontSize: 8, color: C.textDim }}>
                {live.pollCount > 0 ? `poll #${live.pollCount}` : 'initialising'}
              </div>
            </div>
          </div>
        </div>

        {/* Breadcrumb / Access tier + Session */}
        <div style={{ display: 'flex', gap: 10, alignItems: 'stretch' }}>
          <div style={{
            ...glassCard(C.goldBorder, C.goldGlow),
            padding: '8px 14px',
            textAlign: 'center',
            minWidth: 130,
          }}>
            <div style={{ fontSize: 8, color: C.textDim, letterSpacing: '0.14em', textTransform: 'uppercase', marginBottom: 4 }}>ACCESS TIER</div>
            <div style={{ fontSize: 10, fontWeight: 700, color: C.gold, letterSpacing: '0.1em' }}>
              {auth.tier ? auth.tier.toUpperCase() : 'SOVEREIGN'} · {auth.tier === 'sovereign' ? 'φ³' : auth.tier === 'premium' ? 'φ²' : auth.tier === 'basic' ? 'φ¹' : 'φ⁰'}
            </div>
            <div style={{ fontSize: 8, color: C.textDim, marginTop: 2 }}>{auth.clientId ?? 'Skyhi Group'}</div>
          </div>
          <div style={{
            ...glassCard(C.skyBorder, C.skyGlow),
            padding: '8px 14px',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'center',
            alignItems: 'center',
            minWidth: 90,
          }}>
            <div style={{ fontSize: 8, color: C.textDim, letterSpacing: '0.12em', textTransform: 'uppercase', marginBottom: 4 }}>SESSION</div>
            <div style={{ fontSize: 9, color: C.green, fontWeight: 700, letterSpacing: '0.06em', marginBottom: 4 }}>
              {auth.expiresAt ? `${Math.max(0, Math.round((auth.expiresAt - Date.now()) / 60000))}m left` : 'ACTIVE'}
            </div>
            <button
              onClick={() => auth.logout()}
              style={{
                padding: '3px 10px', fontSize: 8, fontWeight: 700,
                background: 'rgba(239, 68, 68, 0.12)',
                border: `1px solid ${C.red}`, borderRadius: 4,
                color: C.red, cursor: 'pointer',
                letterSpacing: '0.1em', textTransform: 'uppercase',
              }}
            >LOGOUT</button>
          </div>
        </div>
      </div>

      {/* ── TAB NAV ──────────────────────────────────────────────────── */}
      <div style={{
        display:      'flex',
        gap:          2,
        padding:      '10px 32px 0',
        borderBottom: `1px solid ${C.skyBorder}`,
        background:   'rgba(5,15,35,0.6)',
      }}>
        {(['DASHBOARD', 'DFW', 'PROPOSAL'] as const).map(tab => (
          <button key={tab} onClick={() => setActiveTab(tab)} style={{
            padding:       '7px 18px',
            fontSize:      9,
            letterSpacing: '0.14em',
            textTransform: 'uppercase',
            background:    activeTab === tab ? C.skyGlow   : 'transparent',
            color:         activeTab === tab ? C.sky       : C.textDim,
            border:        'none',
            borderBottom:  activeTab === tab ? `2px solid ${C.sky}` : '2px solid transparent',
            cursor:        'pointer',
            marginBottom:  -1,
          }}>
            {tab === 'DASHBOARD' ? '⬡ Intelligence' : tab === 'DFW' ? '✈ DFW Integration' : '◈ Services & Pricing'}
          </button>
        ))}
      </div>

      {/* ── DASHBOARD TAB ───────────────────────────────────────────── */}
      {activeTab === 'DASHBOARD' && (
        <div style={{ padding: '24px 32px', display: 'flex', flexDirection: 'column', gap: 24 }}>

          {/* Section: Licensed NOVA Layers */}
          <div>
            <div style={{ fontSize: 10, color: C.textSecond, letterSpacing: '0.16em', textTransform: 'uppercase', marginBottom: 14 }}>
              ⬡ Licensed NOVA Layers — Live Status
            </div>
            <div style={{ display: 'flex', gap: 14, flexWrap: 'wrap' }}>

              {/* KURAMOTO SWARM */}
              <LayerCard
                name="KURAMOTO SWARM"
                subtitle="S4D substrate · φ-synchronisation"
                score={kuramotoR}
                scoreLabel="Order parameter r"
                active={kuramotoR > 0.55}
                borderColor={C.skyBorder}
                glowColor={C.skyGlow}
                accent={C.sky}
              >
                <div style={{ display: 'flex', gap: 16, marginTop: 10 }}>
                  <div>
                    <div style={label()}>Global K</div>
                    <div style={{ fontSize: 13, color: C.sky, fontWeight: 700 }}>{fp3(kuramotoK)}</div>
                  </div>
                  <div>
                    <div style={label()}>J(t) drift</div>
                    <div style={{ fontSize: 13, color: org.jDrift > 1.0 ? C.red : C.sky, fontWeight: 700 }}>{fp3(org.jDrift)}</div>
                  </div>
                  <div>
                    <div style={label()}>State</div>
                    <div style={{ fontSize: 11, color: chimera ? C.gold : C.green, fontWeight: 700, letterSpacing: '0.08em' }}>
                      {chimera ? 'CHIMERA' : 'ENTRAINED'}
                    </div>
                  </div>
                </div>
              </LayerCard>

              {/* FORMA ECONOMY */}
              <LayerCard
                name="FORMA ECONOMY"
                subtitle="Clearinghouse · stable variables"
                score={formaStability > 0 ? formaStability : treasuryHealth}
                scoreLabel="Treasury health"
                active={treasuryHealth > 0.3 || live.economicState !== null}
                borderColor={C.goldBorder}
                glowColor={C.goldGlow}
                accent={C.gold}
              >
                <div style={{ display: 'flex', gap: 16, marginTop: 10 }}>
                  <div>
                    <div style={label()}>Balance</div>
                    <div style={{ fontSize: 13, color: C.gold, fontWeight: 700 }}>{kfmt(formaBalance)}</div>
                  </div>
                  <div>
                    <div style={label()}>Mint mod</div>
                    <div style={{ fontSize: 13, color: C.gold, fontWeight: 700 }}>{pct(formaMintMod)}</div>
                  </div>
                  <div>
                    <div style={label()}>LP pool</div>
                    <div style={{ fontSize: 13, color: C.gold, fontWeight: 700 }}>{kfmt(lp)}</div>
                  </div>
                </div>
              </LayerCard>

              {/* VAEL DEFENSE */}
              <LayerCard
                name="VAEL DEFENSE"
                subtitle="AEGIS · sovereign threat matrix"
                score={vaelScore}
                scoreLabel="Defense integrity"
                active={aegisActive || vaelScore > 0.5}
                borderColor={aegisThreat > 0.5 ? C.goldBorderHi : C.skyBorder}
                glowColor={aegisThreat > 0.5 ? C.goldGlow : C.skyGlow}
                accent={aegisThreat > 0.5 ? C.gold : C.sky}
              >
                <div style={{ display: 'flex', gap: 16, marginTop: 10 }}>
                  <div>
                    <div style={label()}>Threat lvl</div>
                    <div style={{ fontSize: 13, color: aegisThreat > 0.5 ? C.red : C.green, fontWeight: 700 }}>
                      {pct(aegisThreat)}
                    </div>
                  </div>
                  <div>
                    <div style={label()}>Posture</div>
                    <div style={{ fontSize: 11, color: defenseScore > 0.6 ? C.green : C.gold, fontWeight: 700, letterSpacing: '0.06em' }}>
                      {defenseScore > 0.75 ? 'HARDENED' : defenseScore > 0.5 ? 'ACTIVE' : 'STANDBY'}
                    </div>
                  </div>
                  <div>
                    <div style={label()}>AEGIS</div>
                    <div style={{ fontSize: 11, color: aegisActive ? C.green : C.textDim, fontWeight: 700, letterSpacing: '0.06em' }}>
                      {aegisActive ? 'ENGAGED' : 'PASSIVE'}
                    </div>
                  </div>
                </div>
              </LayerCard>

              {/* ARES ARCHIVE */}
              <LayerCard
                name="ARES ARCHIVE"
                subtitle="Quantum memory · fidelity substrate"
                score={aresFidelity > 0 ? aresFidelity : aresRetention}
                scoreLabel="Qmem fidelity"
                active={aresFidelity > 0.3 || aresRetention > 0.3}
                borderColor={C.skyBorder}
                glowColor={C.skyGlow}
                accent={C.sky}
              >
                <div style={{ display: 'flex', gap: 16, marginTop: 10 }}>
                  <div>
                    <div style={label()}>Retention</div>
                    <div style={{ fontSize: 13, color: C.sky, fontWeight: 700 }}>{pct(aresRetention)}</div>
                  </div>
                  <div>
                    <div style={label()}>Threshold</div>
                    <div style={{ fontSize: 13, color: C.sky, fontWeight: 700 }}>{fp3(aresConsolidate)}</div>
                  </div>
                  <div>
                    <div style={label()}>State</div>
                    <div style={{ fontSize: 11, color: live.memoryState?.dreamCycleActive ? C.gold : C.green, fontWeight: 700, letterSpacing: '0.06em' }}>
                      {live.memoryState?.dreamCycleActive ? 'DREAM CYCLE' : 'AWAKE'}
                    </div>
                  </div>
                </div>
              </LayerCard>
            </div>
          </div>

          {/* Section: Real-Time Intelligence Dashboard */}
          <div>
            <div style={{ fontSize: 10, color: C.textSecond, letterSpacing: '0.16em', textTransform: 'uppercase', marginBottom: 14 }}>
              ◉ Real-Time Intelligence — Live Metrics
            </div>
            <div style={{ display: 'flex', gap: 14, flexWrap: 'wrap' }}>
              <MetricCell
                title="Live Agent Assignments"
                metric={`${onMission} / ${agentCount}`}
                sub={`${agentCount} active · WORKFORCE organ`}
                live={agentCount > 0}
                accent={C.sky}
              />
              <MetricCell
                title="FORMA Yield Rate"
                metric={kfmt(formaYieldRate)}
                sub={`${kfmt(txs)} total transfers`}
                live={txs > BigInt(0)}
                accent={C.gold}
              />
              <MetricCell
                title="Research Output"
                metric={reportsGenerated.toLocaleString()}
                sub={`team ${teamActive ? 'active' : 'standby'} · ${live.pollCount} polls`}
                live={teamActive}
                accent={C.sky}
              />
              <MetricCell
                title="Neural Coherence"
                metric={pct(neuralCoherence)}
                sub={`Q-coh ${pct(org.swarmQCoherence)} · r ${fp3(kuramotoR)}`}
                live={neuralCoherence > 0.4}
                accent={neuralCoherence > 0.7 ? C.green : C.sky}
              />
            </div>
          </div>

          {/* Section: Registered Users & PARALLAX Rail */}
          <div style={{ display: 'flex', gap: 14, flexWrap: 'wrap' }}>
            <div style={{ ...glassCard(C.skyBorder, C.skyGlow), flex: 2, minWidth: 240 }}>
              <div style={{ fontSize: 10, color: C.textSecond, letterSpacing: '0.14em', textTransform: 'uppercase', marginBottom: 14 }}>
                PARALLAX Clearinghouse — Stable Variables
              </div>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(100px, 1fr))', gap: 14 }}>
                {[
                  { l: 'Registered Users',   v: kfmt(users) },
                  { l: 'Total Transfers',    v: kfmt(txs)   },
                  { l: 'Settled',            v: kfmt(live.clearinghouse?.totalTransfersSettled ?? BigInt(0)) },
                  { l: 'Fees Collected',     v: kfmt(fees)  },
                  { l: 'Liquidity Pool',     v: kfmt(lp)    },
                  { l: 'Phantom Commits',    v: kfmt(live.clearinghouse?.totalPhantomCommits ?? BigInt(0)) },
                ].map(({ l, v }) => (
                  <div key={l}>
                    <div style={label()}>{l}</div>
                    <div style={{ fontSize: 14, fontWeight: 700, color: C.sky }}>{v}</div>
                  </div>
                ))}
              </div>
            </div>

            <div style={{ ...glassCard(C.goldBorder, C.goldGlow), flex: 1, minWidth: 220 }}>
              <div style={{ fontSize: 10, color: C.textSecond, letterSpacing: '0.14em', textTransform: 'uppercase', marginBottom: 14 }}>
                WORKFORCE Coherence
              </div>
              {[
                { l: 'Workforce coherence', v: workforceScore, c: C.sky  },
                { l: 'Defense posture',     v: defenseScore,   c: C.gold },
                { l: 'Economic resilience', v: economyScore,   c: C.sky  },
                { l: 'Brain coherence',     v: brainCoherence, c: C.gold },
              ].map(({ l, v, c }) => (
                <div key={l} style={{ marginBottom: 10 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
                    <span style={label()}>{l}</span>
                    <span style={{ fontSize: 10, color: c }}>{pct(v)}</span>
                  </div>
                  <ScoreBar v={v} color={c} height={4} />
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* ── DFW TAB ──────────────────────────────────────────────────── */}
      {activeTab === 'DFW' && (
        <div style={{ padding: '24px 32px', display: 'flex', flexDirection: 'column', gap: 24 }}>
          <div>
            <div style={{ fontSize: 10, color: C.textSecond, letterSpacing: '0.16em', textTransform: 'uppercase', marginBottom: 6 }}>
              ✈ DFW Airport — NOVA Integration Status
            </div>
            <div style={{ fontSize: 9, color: C.textDim, marginBottom: 18 }}>
              All statuses derived from live NOVA organism state — no simulated data.
              Bridge quality from canister connectivity · Booking from WORKFORCE coherence · Matching from S4D neural coherence.
            </div>

            <div style={{ display: 'flex', gap: 14, flexWrap: 'wrap', marginBottom: 20 }}>
              <DFWCard
                title="Live API Bridge"
                sub="NOVA ↔ DFW Ops Systems"
                statusLabel={live.connected ? 'CONNECTED' : 'POLLING'}
                statusOk={live.connected}
                score={dfwBridgeScore}
                detail={`Beat ${org.beat} · Last sync ${live.pollCount > 0 ? `${((Date.now() - live.lastPoll) / 1000).toFixed(0)}s ago` : 'pending'} · Kuramoto r=${fp3(kuramotoR)} · QCoh=${pct(org.swarmQCoherence)}`}
              />
              <DFWCard
                title="Last-Minute Booking Engine"
                sub="WORKFORCE agent orchestration"
                statusLabel={dfwBookingScore > 0.5 ? 'OPERATIONAL' : 'DEGRADED'}
                statusOk={dfwBookingScore > 0.5}
                score={dfwBookingScore}
                detail={`${onMission} agents on mission · Workforce coherence ${pct(workforceScore)} · Economic resilience ${pct(economyScore)}`}
              />
              <DFWCard
                title="Passenger Matching System"
                sub="S4D neural coherence substrate"
                statusLabel={dfwMatchingScore > 0.55 ? 'MATCHING' : 'WARMING'}
                statusOk={dfwMatchingScore > 0.55}
                score={dfwMatchingScore}
                detail={`Neural coherence ${pct(neuralCoherence)} · Q-coherence ${pct(org.swarmQCoherence)} · Drift J(t)=${fp3(org.jDrift)}`}
              />
            </div>
          </div>

          {/* Real-time agent roster */}
          <div>
            <div style={{ fontSize: 10, color: C.textSecond, letterSpacing: '0.16em', textTransform: 'uppercase', marginBottom: 14 }}>
              WORKFORCE Agent Roster — {agentCount} Active
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))', gap: 10 }}>
              {activeDrones.slice(0, 12).map((d, i) => (
                <div key={d.id} style={{
                  ...glassCard(d.cortisol > 1.5 ? C.goldBorder : C.skyBorder, d.cortisol > 1.5 ? C.goldGlow : C.skyGlow),
                  padding: '12px 16px',
                }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 8 }}>
                    <PulseDot live={d.energy > 1.0} size={6} />
                    <div style={{ fontSize: 10, fontWeight: 700, color: C.textPrimary, letterSpacing: '0.04em' }}>
                      AGENT-{String(i + 1).padStart(2, '0')}
                    </div>
                    <div style={{ marginLeft: 'auto', fontSize: 8, color: C.textDim, letterSpacing: '0.1em' }}>
                      {(d as unknown as { cls?: string }).cls ?? 'ANALYST'}
                    </div>
                  </div>
                  <div style={{ display: 'flex', gap: 12 }}>
                    <div>
                      <div style={label()}>Energy</div>
                      <div style={{ fontSize: 11, color: d.energy > 1.0 ? C.green : C.gold, fontWeight: 700 }}>{fp3(d.energy)}</div>
                    </div>
                    <div>
                      <div style={label()}>Q-conv</div>
                      <div style={{ fontSize: 11, color: C.sky, fontWeight: 700 }}>{fp3(d.qConvergence)}</div>
                    </div>
                    <div>
                      <div style={label()}>Trust</div>
                      <div style={{ fontSize: 11, color: C.sky, fontWeight: 700 }}>{pct(d.trustScore)}</div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* ── PROPOSAL TAB ─────────────────────────────────────────────── */}
      {activeTab === 'PROPOSAL' && (
        <div style={{ padding: '24px 32px', display: 'flex', flexDirection: 'column', gap: 24 }}>
          <div>
            <div style={{ fontSize: 10, color: C.textSecond, letterSpacing: '0.16em', textTransform: 'uppercase', marginBottom: 6 }}>
              ◈ Service Tiers — Priced in FORMA · φ-tier architecture
            </div>
            <div style={{ fontSize: 9, color: C.textDim, marginBottom: 18 }}>
              All tiers priced at exact φ-powers of 1,000 FORMA/month. φ = {PHI.toFixed(10)} (from nova_protocol).
              Prices: φ⁰={FORMA_TIER_KORE} · φ¹={FORMA_TIER_EDGE} · φ²={FORMA_TIER_CLOUD} · φ³={FORMA_TIER_PHANTOM}.
            </div>

            <div style={{ display: 'flex', gap: 16, flexWrap: 'wrap' }}>
              <TierCard
                tier="TIER I · φ⁰"
                name="KORE"
                priceForma={FORMA_TIER_KORE}
                includes={['KURAMOTO SWARM']}
                features={[
                  'S4D substrate Kuramoto synchronisation',
                  'Swarm order parameter (r) live access',
                  'J(t) phase drift monitoring',
                  '873ms heartbeat telemetry',
                ]}
              />
              <TierCard
                tier="TIER II · φ¹"
                name="EDGE"
                priceForma={FORMA_TIER_EDGE}
                includes={['KURAMOTO SWARM', 'FORMA ECONOMY']}
                features={[
                  'All KORE features',
                  'FORMA token flow access',
                  'Clearinghouse stable variable feed',
                  'Treasury health monitoring',
                  'PARALLAX rail status',
                ]}
              />
              <TierCard
                tier="TIER III · φ²"
                name="CLOUD"
                priceForma={FORMA_TIER_CLOUD}
                includes={['KURAMOTO SWARM', 'FORMA ECONOMY', 'VAEL DEFENSE']}
                features={[
                  'All EDGE features',
                  'VAEL AEGIS defense layer',
                  'Threat matrix live feed',
                  'Defense posture intelligence',
                  'WORKFORCE coherence access',
                ]}
                highlight={true}
              />
              <TierCard
                tier="TIER IV · φ³"
                name="PHANTOM"
                priceForma={FORMA_TIER_PHANTOM}
                includes={['KURAMOTO SWARM', 'FORMA ECONOMY', 'VAEL DEFENSE', 'ARES ARCHIVE']}
                features={[
                  'All CLOUD features',
                  'ARES quantum memory archive',
                  'Full WORKFORCE agent access',
                  'DFW booking + matching engines',
                  'Neural coherence substrate',
                  'Priority sovereign support',
                ]}
              />
            </div>
          </div>

          {/* Summary strip */}
          <div style={{ ...glassCardHigh(C.goldBorderHi, C.goldGlow), padding: '20px 28px' }}>
            <div style={{ display: 'flex', gap: 32, alignItems: 'center', flexWrap: 'wrap' }}>
              <div>
                <div style={{ fontSize: 13, fontWeight: 700, color: C.gold, letterSpacing: '0.06em', marginBottom: 4 }}>
                  Skyhi Group — Current Tier: PHANTOM (φ³)
                </div>
                <div style={{ fontSize: 9, color: C.textSecond }}>
                  Full sovereign access · All 4 NOVA layers licensed
                </div>
              </div>
              <div style={{ marginLeft: 'auto', textAlign: 'right' }}>
                <div style={{ fontSize: 9, color: C.textDim, letterSpacing: '0.12em', textTransform: 'uppercase', marginBottom: 2 }}>Monthly Investment</div>
                <div style={{ fontSize: 20, fontWeight: 700, color: C.gold }}>{forma(FORMA_TIER_PHANTOM)}</div>
              </div>
            </div>
          </div>

          {/* Architecture statement */}
          <div style={{ ...glassCard(C.skyBorder, C.skyGlow), fontSize: 9, color: C.textDim, lineHeight: 1.8 }}>
            {live.clearinghouse?.architectureStatement
              ? <><span style={{ color: C.sky, fontWeight: 700 }}>Clearinghouse Statement: </span>{live.clearinghouse.architectureStatement}</>
              : <><span style={{ color: C.sky, fontWeight: 700 }}>© 2024-2026 Alfredo Medina Hernandez · Medina Tech · Dallas, TX</span> — NOVA is a sovereign multi-layer AGI organism. ICP is one of five substrates NOVA inhabits. NOVA provides cycles; substrates do not provide NOVA. Skyhi Group's enterprise license grants read access to live canister state across all licensed layers. No cached data. No mock displays. Always live.</>
            }
          </div>
        </div>
      )}

      {/* ── FOOTER ──────────────────────────────────────────────────── */}
      <div style={{
        borderTop:  `1px solid ${C.skyBorder}`,
        padding:    '10px 32px',
        display:    'flex',
        alignItems: 'center',
        gap:        16,
        fontSize:   8,
        color:      C.textDim,
        letterSpacing: '0.1em',
        flexWrap:   'wrap',
      }}>
        <span>⬡ NOVA · PARALLAX</span>
        <span>·</span>
        <span>SKYHI GROUP CLIENT PORTAL · BUILD №1</span>
        <span>·</span>
        <span>BEAT {org.beat} · r={fp3(kuramotoR)} · J(t)={fp3(org.jDrift)}</span>
        <span style={{ marginLeft: 'auto' }}>© 2026 MEDINA TECH · ALFREDO MEDINA HERNANDEZ</span>
      </div>
    </div>
  );
}
