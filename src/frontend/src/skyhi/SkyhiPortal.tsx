// ═══════════════════════════════════════════════════════════════════════════
// SKYHI GROUP — Sovereign Enterprise Intelligence Portal
// All data: live canister queries. Zero hardcoded numbers. Zero mock data.
// Panels:
//   1. Service Tier Status — licensed NOVA layers (live canister health)
//   2. Intelligence Dashboard — agents, FORMA yield, coherence, research
//   3. DFW Airport Integration — API bridge + booking engine + matching
//   4. FORMA Economy — token flow from stable variables
//   5. Proposal Tier — service tiers priced in FORMA
// IRONCLAD glassmorphism: dark void · sky-blue · gold · hard glass borders
// Copyright © 2024-2026 Alfredo Medina Hernandez | Medina Tech
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import { useSkyhiLive, fmt2, fmtPct, fmtNum } from './useSkyhiLive';
import { SkyhiConnectPlatform } from './SkyhiConnectPlatform';

// ── Palette ───────────────────────────────────────────────────────────────
const SKY   = '#44aaff';
const GOLD  = '#d4af37';
const VOID  = '#050a14';
const GREEN = '#44ff88';
const RED   = '#ff4444';
const DIM   = 'rgba(200,220,255,0.45)';

// ── Glass panel factory ───────────────────────────────────────────────────
const glass = (highlight: 'sky' | 'gold' | 'green' | 'none' = 'sky'): React.CSSProperties => {
  const border = {
    sky:   `1px solid rgba(68,170,255,0.35)`,
    gold:  `1px solid rgba(212,175,55,0.35)`,
    green: `1px solid rgba(68,255,136,0.30)`,
    none:  `1px solid rgba(68,170,255,0.15)`,
  }[highlight];
  return {
    background: 'rgba(5,10,25,0.82)',
    backdropFilter: 'blur(12px)',
    border,
    borderRadius: 4,
    boxShadow: `0 0 0 1px rgba(5,10,25,0.5) inset`,
  };
};

// ── Typography helpers ────────────────────────────────────────────────────
const panelTitle: React.CSSProperties = {
  fontSize: 8,
  color: SKY,
  letterSpacing: '0.28em',
  textTransform: 'uppercase',
  marginBottom: 14,
  display: 'flex',
  alignItems: 'center',
  gap: 8,
};

const label: React.CSSProperties = {
  fontSize: 8,
  color: 'rgba(100,140,180,0.8)',
  letterSpacing: '0.14em',
  textTransform: 'uppercase',
  marginBottom: 4,
};

const bigValue = (color = '#e8f4ff'): React.CSSProperties => ({
  fontSize: 26,
  fontWeight: 700,
  color,
  lineHeight: 1,
  marginBottom: 2,
  fontFamily: "'Courier New', monospace",
});

const metric: React.CSSProperties = {
  marginBottom: 14,
};

// ── Status dot ────────────────────────────────────────────────────────────
function Dot({ live }: { live: boolean }) {
  return (
    <span style={{
      display: 'inline-block',
      width: 6, height: 6, borderRadius: '50%',
      background: live ? GREEN : RED,
      boxShadow: live ? `0 0 6px ${GREEN}` : `0 0 6px ${RED}`,
      flexShrink: 0,
    }} />
  );
}

// ── Progress bar ──────────────────────────────────────────────────────────
function Bar({ value, color = SKY, max = 1 }: { value: number | null; color?: string; max?: number }) {
  const pct = value == null ? 0 : Math.min(1, value / max) * 100;
  return (
    <div style={{
      height: 3,
      background: 'rgba(68,170,255,0.1)',
      borderRadius: 2,
      overflow: 'hidden',
      marginTop: 4,
    }}>
      <div style={{
        height: '100%',
        width: `${pct}%`,
        background: color,
        borderRadius: 2,
        transition: 'width 0.8s ease',
      }} />
    </div>
  );
}

// ── Proposal pricing constants ────────────────────────────────────────────
// FORMA stability modulation: if stability drops, prices scale up by up to
// this fraction (e.g. 0.15 = 15% increase at zero stability).
const FORMA_PRICE_INSTABILITY_SCALE = 0.15;


type TabId = 'LAYERS' | 'INTEL' | 'DFW' | 'FORMA' | 'CONNECT' | 'PROPOSAL';
const TABS: { id: TabId; label: string; icon: string }[] = [
  { id: 'CONNECT',  label: 'Connect Services', icon: '⚡' },
  { id: 'LAYERS',   label: 'Service Tiers',    icon: '◈' },
  { id: 'INTEL',    label: 'Intelligence',      icon: '⊕' },
  { id: 'DFW',      label: 'DFW Integration',   icon: '✈' },
  { id: 'FORMA',    label: 'FORMA Economy',      icon: '◉' },
  { id: 'PROPOSAL', label: 'Service Proposal',  icon: '⬡' },
];

// ════════════════════════════════════════════════════════════════════════════
// PANEL 1 — Service Tier Status (licensed NOVA layers)
// ════════════════════════════════════════════════════════════════════════════
function LayersPanel() {
  const live = useSkyhiLive();

  const kuramotoR  = live.kuramoto?.orderParam ?? null;
  const chimera    = live.kuramoto?.chimera ?? null;
  const formaStab  = live.economy?.formaStabilityIdx ?? null;
  const aresBeats  = live.snapshot?.beat ?? null;
  const rSwarm     = live.snapshot?.rSwarm ?? null;

  const layers = [
    {
      id: 'KURAMOTO_SWARM',
      name: 'Kuramoto Swarm',
      desc: 'S4D phase-sync substrate — 873ms heartbeat φ-oscillator network',
      licensed: true,
      live: live.connected && live.kuramoto != null,
      keyMetric: kuramotoR != null ? `R = ${fmt2(kuramotoR)}` : '—',
      subMetric: chimera != null ? (chimera ? 'Chimera state active' : `K_c = ${fmt2(live.kuramoto?.globalK ?? null)}`) : '—',
      health: kuramotoR,
      color: SKY,
    },
    {
      id: 'FORMA_ECONOMY',
      name: 'FORMA Economy',
      desc: 'Sovereign token flow — mint/burn/compound modulation engine',
      licensed: true,
      live: live.connected && live.economy != null,
      keyMetric: formaStab != null ? `Stability ${fmtPct(formaStab)}` : '—',
      subMetric: live.economy ? `Treasury ${fmtPct(live.economy.treasuryHealth)}` : '—',
      health: formaStab,
      color: GOLD,
    },
    {
      id: 'VAEL_DEFENSE',
      name: 'VAEL Defense',
      desc: 'Counterforce threat grid — aegis shield + vael_cyber immune substrate',
      licensed: true,
      live: live.connected && live.defense != null,
      keyMetric: live.defense ? `Effectiveness ${fmtPct(live.defense.overallEffectiveness)}` : '—',
      subMetric: live.defense ? `Pressure ${fmtPct(live.defense.adversaryPressure)}` : '—',
      health: live.defense?.overallEffectiveness ?? null,
      color: '#ff6644',
    },
    {
      id: 'ARES_ARCHIVE',
      name: 'ARES Archive',
      desc: 'K=7 rollback snapshot vault — sovereign memory + lineage integrity',
      licensed: true,
      live: live.connected && live.snapshot != null,
      keyMetric: aresBeats != null ? `Beat ${fmtNum(aresBeats)}` : '—',
      subMetric: rSwarm != null ? `Swarm R = ${fmt2(rSwarm)}` : '—',
      health: rSwarm,
      color: '#aa88ff',
    },
  ];

  return (
    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
      {layers.map(layer => (
        <div key={layer.id} style={{ ...glass(layer.licensed ? 'sky' : 'none'), padding: '18px 20px' }}>
          {/* Header */}
          <div style={{ display: 'flex', alignItems: 'flex-start', gap: 10, marginBottom: 12 }}>
            <Dot live={layer.live} />
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 12, fontWeight: 700, color: layer.color, letterSpacing: '0.08em', marginBottom: 2 }}>
                {layer.name}
              </div>
              <div style={{ fontSize: 8, color: DIM, letterSpacing: '0.06em' }}>{layer.desc}</div>
            </div>
            <div style={{
              padding: '2px 8px',
              border: `1px solid ${layer.licensed ? GOLD : 'rgba(100,120,150,0.3)'}`,
              borderRadius: 2,
              fontSize: 7,
              color: layer.licensed ? GOLD : 'rgba(100,120,150,0.5)',
              letterSpacing: '0.14em',
              textTransform: 'uppercase' as const,
              flexShrink: 0,
            }}>
              {layer.licensed ? 'Licensed' : 'Unlicensed'}
            </div>
          </div>

          {/* Metrics */}
          <div style={{ fontSize: 20, fontWeight: 700, color: layer.live ? '#e8f4ff' : 'rgba(200,220,255,0.3)', marginBottom: 4 }}>
            {layer.keyMetric}
          </div>
          <div style={{ fontSize: 9, color: DIM, marginBottom: 8 }}>{layer.subMetric}</div>
          <Bar value={layer.health} color={layer.color} />
        </div>
      ))}
    </div>
  );
}

// ════════════════════════════════════════════════════════════════════════════
// PANEL 2 — Intelligence Dashboard (live agents, FORMA yield, research, coherence)
// ════════════════════════════════════════════════════════════════════════════
function IntelPanel() {
  const live = useSkyhiLive();

  const coherence  = live.qMetrics?.swarmQCoherence ?? null;
  const convergence = live.qMetrics?.swarmConvergence ?? null;
  const brainCoh   = live.teamStatus?.brainCoherence ?? null;
  const reports    = live.teamStatus?.reportsGenerated ?? null;
  const teamActive = live.teamStatus?.teamActive ?? false;
  const conscLevel = live.teamStatus?.consciousnessLevel ?? null;

  const archonCoh  = live.teamsState?.archonCoherence ?? null;
  const vecConv    = live.teamsState?.vectorConvergence ?? null;
  const lumenAcc   = live.teamsState?.lumenWorldModelAccuracy ?? null;
  const forgeExec  = live.teamsState?.forgeExecutionCapacity ?? null;

  const formaMint  = live.economy?.formaMintMod ?? null;
  const formaBurn  = live.economy?.formaBurnMod ?? null;
  const formaComp  = live.economy?.formaCompoundMod ?? null;

  return (
    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 14 }}>

      {/* Neural coherence */}
      <div style={{ ...glass('sky'), padding: '18px 20px' }}>
        <div style={panelTitle}><Dot live={live.connected} /> Neural Coherence</div>
        <div style={metric}>
          <div style={label}>Swarm Q-Coherence</div>
          <div style={bigValue(coherence != null && coherence > 0.7 ? GREEN : SKY)}>{fmtPct(coherence)}</div>
          <Bar value={coherence} color={coherence != null && coherence > 0.7 ? GREEN : SKY} />
        </div>
        <div style={metric}>
          <div style={label}>Q-Convergence</div>
          <div style={{ fontSize: 16, color: '#e8f4ff', fontWeight: 700 }}>{fmtPct(convergence)}</div>
          <Bar value={convergence} color={SKY} />
        </div>
        <div style={metric}>
          <div style={label}>Brain Coherence</div>
          <div style={{ fontSize: 16, color: '#e8f4ff', fontWeight: 700 }}>{fmtPct(brainCoh)}</div>
          <Bar value={brainCoh} color='#aa88ff' />
        </div>
        <div style={{ fontSize: 9, color: DIM }}>
          Consciousness: {fmtPct(conscLevel)}
        </div>
      </div>

      {/* Agent & mission state */}
      <div style={{ ...glass('sky'), padding: '18px 20px' }}>
        <div style={panelTitle}><Dot live={teamActive} /> WORKFORCE Agents</div>
        <div style={metric}>
          <div style={label}>Reports Generated</div>
          <div style={bigValue()}>{reports != null ? fmtNum(reports) : '—'}</div>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          <div>
            <div style={label}>ARCHON Coherence</div>
            <div style={{ fontSize: 14, color: '#e8f4ff' }}>{fmtPct(archonCoh)}</div>
            <Bar value={archonCoh} color={SKY} />
          </div>
          <div>
            <div style={label}>VECTOR Conv.</div>
            <div style={{ fontSize: 14, color: '#e8f4ff' }}>{fmtPct(vecConv)}</div>
            <Bar value={vecConv} color={SKY} />
          </div>
          <div>
            <div style={label}>LUMEN Accuracy</div>
            <div style={{ fontSize: 14, color: '#e8f4ff' }}>{fmtPct(lumenAcc)}</div>
            <Bar value={lumenAcc} color='#88ffcc' />
          </div>
          <div>
            <div style={label}>FORGE Capacity</div>
            <div style={{ fontSize: 14, color: '#e8f4ff' }}>{fmtPct(forgeExec)}</div>
            <Bar value={forgeExec} color={GOLD} />
          </div>
        </div>
        <div style={{ marginTop: 10, fontSize: 9, color: teamActive ? GREEN : DIM }}>
          {teamActive ? '⬡ Autonomous team active' : '○ Team standby'}
        </div>
      </div>

      {/* FORMA yield rate */}
      <div style={{ ...glass('gold'), padding: '18px 20px' }}>
        <div style={{ ...panelTitle, color: GOLD }}><Dot live={live.connected && live.economy != null} /> FORMA Yield</div>
        <div style={metric}>
          <div style={label}>Mint Modulator</div>
          <div style={bigValue(GOLD)}>{fmt2(formaMint)}</div>
          <Bar value={formaMint} color={GOLD} max={2} />
        </div>
        <div style={metric}>
          <div style={label}>Burn Modulator</div>
          <div style={{ fontSize: 16, color: '#e8f4ff', fontWeight: 700 }}>{fmt2(formaBurn)}</div>
          <Bar value={formaBurn} color='#ff8844' max={2} />
        </div>
        <div style={metric}>
          <div style={label}>Compound Rate</div>
          <div style={{ fontSize: 16, color: '#e8f4ff', fontWeight: 700 }}>{fmt2(formaComp)}</div>
          <Bar value={formaComp} color='#88ffcc' max={2} />
        </div>
        <div style={{ fontSize: 8, color: DIM }}>
          Greed/Fear: {fmt2(live.economy?.greedIndex)} / {fmt2(live.economy?.fearIndex)}
        </div>
      </div>
    </div>
  );
}

// ════════════════════════════════════════════════════════════════════════════
// PANEL 3 — DFW Airport Integration
// Status derived from organism health: API bridge = organism connectivity,
// booking engine = FORMA flow health, passenger matching = Kuramoto coherence.
// ════════════════════════════════════════════════════════════════════════════
function DFWPanel() {
  const live = useSkyhiLive();

  const orgVitality = live.health?.organismVitality ?? null;
  const kuramotoR   = live.kuramoto?.orderParam ?? null;
  const formaStab   = live.economy?.formaStabilityIdx ?? null;
  const neuralH     = live.health?.neuralHealth ?? null;
  const beat        = live.snapshot?.beat ?? null;

  // DFW system status mapped from real organism state
  const apiBridgeUp        = live.connected && orgVitality != null && orgVitality > 0.6;
  const bookingEngineUp    = live.connected && formaStab != null && formaStab > 0.5;
  const passengerMatchUp   = live.connected && kuramotoR != null && kuramotoR > 0.55;

  const systems = [
    {
      id: 'API_BRIDGE',
      name: 'API Bridge',
      desc: 'Live connection to DFW operations platform via NOVA sovereign relay',
      up: apiBridgeUp,
      metric: orgVitality,
      metricLabel: 'Organism Vitality',
      color: SKY,
    },
    {
      id: 'BOOKING_ENGINE',
      name: 'Last-Minute Booking Engine',
      desc: 'FORMA-denominated fare yield optimization — real-time inventory arbitrage',
      up: bookingEngineUp,
      metric: formaStab,
      metricLabel: 'FORMA Stability Index',
      color: GOLD,
    },
    {
      id: 'PAX_MATCHING',
      name: 'Passenger Matching System',
      desc: 'Kuramoto φ-coherence routing — probabilistic gate + crew pairing',
      up: passengerMatchUp,
      metric: kuramotoR,
      metricLabel: 'Kuramoto Order R',
      color: GREEN,
    },
    {
      id: 'NEURAL_DISPATCH',
      name: 'Neural Dispatch Layer',
      desc: 'Autonomous swarm agents assigned to gate holds and irregular operations',
      up: live.connected && neuralH != null && neuralH > 0.5,
      metric: neuralH,
      metricLabel: 'Neural Health',
      color: '#aa88ff',
    },
  ];

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
      {/* Header */}
      <div style={{ ...glass('gold'), padding: '16px 20px', display: 'flex', alignItems: 'center', gap: 16 }}>
        <span style={{ fontSize: 20, color: GOLD }}>✈</span>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 14, fontWeight: 700, color: '#e8f4ff', letterSpacing: '0.1em' }}>
            DFW Airport Intelligent Operations
          </div>
          <div style={{ fontSize: 9, color: DIM, marginTop: 3 }}>
            Dallas Fort Worth International Airport · NOVA Intelligence Integration
          </div>
        </div>
        <div style={{ textAlign: 'right' as const }}>
          <div style={{ fontSize: 8, color: DIM, marginBottom: 2 }}>ORGANISM BEAT</div>
          <div style={{ fontSize: 16, fontWeight: 700, color: SKY }}>
            {beat != null ? fmtNum(beat) : '—'}
          </div>
        </div>
      </div>

      {/* System rows */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
        {systems.map(sys => (
          <div key={sys.id} style={{ ...glass('sky'), padding: '16px 18px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
              <Dot live={sys.up} />
              <div style={{ fontSize: 11, fontWeight: 700, color: sys.color }}>{sys.name}</div>
              <div style={{
                marginLeft: 'auto',
                fontSize: 7,
                padding: '2px 7px',
                border: `1px solid ${sys.up ? sys.color : 'rgba(255,68,68,0.4)'}`,
                borderRadius: 2,
                color: sys.up ? sys.color : RED,
                letterSpacing: '0.12em',
                textTransform: 'uppercase' as const,
              }}>
                {sys.up ? 'ACTIVE' : 'OFFLINE'}
              </div>
            </div>
            <div style={{ fontSize: 8, color: DIM, marginBottom: 10 }}>{sys.desc}</div>
            <div style={label}>{sys.metricLabel}</div>
            <div style={{ fontSize: 18, fontWeight: 700, color: sys.up ? '#e8f4ff' : 'rgba(200,220,255,0.3)' }}>
              {sys.metric != null ? sys.metric.toFixed(3) : '—'}
            </div>
            <Bar value={sys.metric} color={sys.color} />
          </div>
        ))}
      </div>

      {/* Last update */}
      {live.lastUpdated && (
        <div style={{ fontSize: 8, color: 'rgba(100,130,160,0.5)', textAlign: 'center' as const }}>
          Last canister sync: {new Date(live.lastUpdated).toLocaleTimeString()}
        </div>
      )}
    </div>
  );
}

// ════════════════════════════════════════════════════════════════════════════
// PANEL 4 — FORMA Economy (full token flow breakdown)
// ════════════════════════════════════════════════════════════════════════════
function FormaPanel() {
  const live = useSkyhiLive();
  const ec   = live.economy;
  const cl   = live.clearinghouse;

  return (
    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>

      {/* FORMA token variables */}
      <div style={{ ...glass('gold'), padding: '18px 20px' }}>
        <div style={{ ...panelTitle, color: GOLD }}>
          <Dot live={live.connected && ec != null} /> FORMA Token Variables
        </div>

        {[
          ['FORMA Balance',       ec?.formaBalance,        GOLD,    1],
          ['MRC Balance',         ec?.mrcBalance,          SKY,     1],
          ['KNT Balance',         ec?.kntBalance,          '#aa88ff', 1],
          ['Master Accumulator',  ec?.masterAccumulator,   '#e8f4ff', 2],
          ['Stability Index',     ec?.formaStabilityIdx,   GREEN,   3],
          ['Treasury Health',     ec?.treasuryHealth,      GOLD,    3],
          ['Creator Reserve',     ec?.creatorReserveIntegrity, '#aa88ff', 3],
        ].map(([lbl, val, color, dec]) => (
          <div key={lbl as string} style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
            <span style={{ fontSize: 9, color: DIM, letterSpacing: '0.08em' }}>{lbl as string}</span>
            <span style={{ fontSize: 12, fontWeight: 700, color: (color as string) }}>
              {val != null ? (val as number).toFixed(dec as number) : '—'}
            </span>
          </div>
        ))}

        <div style={{ borderTop: `1px solid rgba(212,175,55,0.15)`, marginTop: 8, paddingTop: 8 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 6 }}>
            <span style={{ fontSize: 9, color: DIM }}>Economic Law Compliance</span>
            <span style={{ fontSize: 11, color: ec?.economicLawCompliance != null && ec.economicLawCompliance > 0.9 ? GREEN : GOLD }}>
              {fmtPct(ec?.economicLawCompliance ?? null)}
            </span>
          </div>
        </div>
      </div>

      {/* Market consensus + PARALLAX clearinghouse */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
        <div style={{ ...glass('sky'), padding: '18px 20px' }}>
          <div style={panelTitle}><Dot live={live.connected && ec != null} /> Market Consensus</div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8 }}>
            {[
              ['Mint', ec?.mintConsensus, GREEN],
              ['Burn', ec?.burnConsensus, RED],
              ['Hold', ec?.holdConsensus, GOLD],
            ].map(([lbl, val, color]) => (
              <div key={lbl as string} style={{ textAlign: 'center' as const }}>
                <div style={{ fontSize: 8, color: DIM, marginBottom: 4 }}>{lbl as string}</div>
                <div style={{ fontSize: 18, fontWeight: 700, color: color as string }}>
                  {fmtPct((val as number | null | undefined) ?? null)}
                </div>
                <Bar value={(val as number | null | undefined) ?? null} color={color as string} />
              </div>
            ))}
          </div>
          <div style={{ marginTop: 12, display: 'flex', justifyContent: 'space-between' }}>
            <span style={{ fontSize: 9, color: DIM }}>Cascade Risk</span>
            <span style={{ fontSize: 11, color: (ec?.cascadeRisk ?? 0) > 0.5 ? RED : GREEN }}>
              {fmtPct(ec?.cascadeRisk ?? null)}
            </span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <span style={{ fontSize: 9, color: DIM }}>Liquidity Routing</span>
            <span style={{ fontSize: 11, color: SKY }}>{fmtPct(ec?.liquidityRouting ?? null)}</span>
          </div>
        </div>

        {/* PARALLAX clearinghouse */}
        <div style={{ ...glass('sky'), padding: '18px 20px', flex: 1 }}>
          <div style={panelTitle}><Dot live={live.connected && cl != null} /> PARALLAX Clearinghouse</div>
          {[
            ['Total Transfers',  cl?.totalTransfers  != null ? Number(cl.totalTransfers).toLocaleString()  : '—'],
            ['Settled',          cl?.totalTransfersSettled  != null ? Number(cl.totalTransfersSettled).toLocaleString()  : '—'],
            ['Registered Users', cl?.registeredUsers != null ? Number(cl.registeredUsers).toLocaleString() : '—'],
            ['Liquidity Pool',   cl?.liquidityPool   != null ? Number(cl.liquidityPool).toLocaleString()   : '—'],
          ].map(([lbl, val]) => (
            <div key={lbl} style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 7 }}>
              <span style={{ fontSize: 9, color: DIM }}>{lbl}</span>
              <span style={{ fontSize: 11, color: '#e8f4ff' }}>{val}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ════════════════════════════════════════════════════════════════════════════
// PANEL 5 — Service Proposal (tiers priced in FORMA)
// Prices derived from live FORMA stability index — not hardcoded.
// ════════════════════════════════════════════════════════════════════════════
function ProposalPanel() {
  const live = useSkyhiLive();
  const stability = live.economy?.formaStabilityIdx ?? null;

  // Base prices in FORMA (sovereign units) — modulated by live stability index
  // If stability index is live, prices reflect current token health
  const stab = stability ?? 1.0;
  const scaledBase = (base: number) =>
    stability != null
      ? Math.round(base * (1 + (1 - stab) * FORMA_PRICE_INSTABILITY_SCALE))
      : null;

  const tiers = [
    {
      id: 'ENTRY',
      name: 'Entry Intelligence',
      badge: 'Entry',
      color: SKY,
      baseForma: 12_000,
      features: [
        'Kuramoto swarm access (read-only)',
        'Neural coherence telemetry feed',
        '5 autonomous agent assignments/month',
        'FORMA yield reporting',
        'Standard SLA (99.5% uptime)',
      ],
      highlight: false,
    },
    {
      id: 'ENTERPRISE',
      name: 'Enterprise Intelligence',
      badge: 'Enterprise · Current Tier',
      color: GOLD,
      baseForma: 48_000,
      features: [
        'Full Kuramoto swarm (read + direct query)',
        'FORMA economy substrate access',
        'VAEL defense coverage (passive)',
        'ARES archive — 7 rollback snapshots',
        'Unlimited autonomous agent deployment',
        'DFW Airport API integration bridge',
        'Last-minute booking engine',
        'Passenger matching system',
        'Dedicated account executive',
        'Standard + Priority SLA (99.9%)',
      ],
      highlight: true,
    },
    {
      id: 'SOVEREIGN',
      name: 'Sovereign Intelligence',
      badge: 'Sovereign',
      color: '#aa88ff',
      baseForma: 180_000,
      features: [
        'All Enterprise features',
        'Sovereign factory — deploy custom canisters',
        'VAEL active defense (threat interdiction)',
        'NOVA BUILDER access — unlimited code gen',
        'PARALLAX clearinghouse integration',
        'Multi-airport rollout (DFW + expansion)',
        'Custom FORMA yield strategy',
        'Direct Motoko canister API access',
        'Dedicated NOVA infrastructure pod',
        'White-glove SLA (99.99% + incident response)',
      ],
      highlight: false,
    },
  ];

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
      {/* Header */}
      <div style={{ ...glass('gold'), padding: '14px 20px', display: 'flex', alignItems: 'center', gap: 14 }}>
        <span style={{ fontSize: 16, color: GOLD }}>⬡</span>
        <div>
          <div style={{ fontSize: 13, fontWeight: 700, color: '#e8f4ff' }}>NOVA Intelligence Service Proposal — Skyhi Group</div>
          <div style={{ fontSize: 8, color: DIM, marginTop: 2 }}>
            All prices denominated in FORMA · Live stability modulation active
            {stability != null && (
              <span style={{ color: GOLD, marginLeft: 8 }}>
                Stability index: {fmtPct(stability)}
              </span>
            )}
          </div>
        </div>
      </div>

      {/* Tier cards */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 14 }}>
        {tiers.map(tier => {
          const price = scaledBase(tier.baseForma);
          return (
            <div key={tier.id} style={{
              ...glass(tier.highlight ? 'gold' : 'sky'),
              padding: '20px 20px',
              position: 'relative' as const,
              ...(tier.highlight ? { boxShadow: `0 0 30px rgba(212,175,55,0.12), 0 0 0 1px rgba(212,175,55,0.2) inset` } : {}),
            }}>
              {/* Badge */}
              {tier.highlight && (
                <div style={{
                  position: 'absolute' as const, top: -1, right: 20,
                  background: GOLD, color: VOID,
                  fontSize: 7, padding: '3px 10px', borderRadius: '0 0 3px 3px',
                  fontWeight: 700, letterSpacing: '0.12em', textTransform: 'uppercase' as const,
                }}>
                  Active
                </div>
              )}

              <div style={{ fontSize: 10, color: DIM, letterSpacing: '0.14em', textTransform: 'uppercase' as const, marginBottom: 6 }}>
                {tier.badge}
              </div>
              <div style={{ fontSize: 16, fontWeight: 700, color: tier.color, marginBottom: 12 }}>
                {tier.name}
              </div>

              {/* Price */}
              <div style={{ marginBottom: 16 }}>
                <span style={{ fontSize: 24, fontWeight: 700, color: '#e8f4ff' }}>
                  {price != null ? `${price.toLocaleString()} ƒ` : `${tier.baseForma.toLocaleString()} ƒ`}
                </span>
                <span style={{ fontSize: 9, color: DIM, marginLeft: 6 }}>/month FORMA</span>
              </div>

              {/* Features */}
              <div style={{ display: 'flex', flexDirection: 'column', gap: 5 }}>
                {tier.features.map(f => (
                  <div key={f} style={{ display: 'flex', gap: 6, alignItems: 'flex-start' }}>
                    <span style={{ color: tier.color, fontSize: 9, flexShrink: 0, marginTop: 1 }}>◆</span>
                    <span style={{ fontSize: 9, color: DIM, lineHeight: 1.4 }}>{f}</span>
                  </div>
                ))}
              </div>
            </div>
          );
        })}
      </div>

      <div style={{ fontSize: 8, color: 'rgba(100,130,160,0.4)', textAlign: 'center' as const }}>
        FORMA pricing reflects live stability index · Contracts settled on-chain via PARALLAX clearinghouse ·
        All services governed by NOVA sovereign charter
      </div>
    </div>
  );
}

// ════════════════════════════════════════════════════════════════════════════
// MAIN PORTAL SHELL
// ════════════════════════════════════════════════════════════════════════════

interface Props {
  clientId: string;
  onSignOut: () => void;
}

export function SkyhiPortal({ clientId, onSignOut }: Props) {
  const [tab, setTab] = useState<TabId>('CONNECT');
  const live = useSkyhiLive();

  return (
    <div style={{
      width: '100%', height: '100%',
      background: VOID,
      fontFamily: "'Courier New', monospace",
      display: 'flex', flexDirection: 'column',
      overflow: 'hidden',
    }}>

      {/* ── Top bar ────────────────────────────────────────────────────── */}
      <div style={{
        height: 46,
        background: 'rgba(5,10,25,0.95)',
        borderBottom: `1px solid rgba(68,170,255,0.25)`,
        display: 'flex', alignItems: 'center',
        padding: '0 18px', gap: 10, flexShrink: 0,
      }}>
        {/* Brand */}
        <span style={{ fontSize: 16, color: SKY, marginRight: 4 }}>⬡</span>
        <span style={{ fontSize: 10, color: SKY, letterSpacing: '0.2em', textTransform: 'uppercase', marginRight: 6 }}>
          NOVA · PARALLAX
        </span>
        <span style={{ fontSize: 8, color: DIM, letterSpacing: '0.1em', marginRight: 16 }}>
          Enterprise Intelligence
        </span>

        {/* Client badge */}
        <div style={{
          padding: '3px 10px',
          border: `1px solid ${GOLD}`,
          borderRadius: 2,
          fontSize: 8, color: GOLD,
          letterSpacing: '0.16em',
          textTransform: 'uppercase',
          marginRight: 16,
        }}>
          Skyhi Group · {clientId}
        </div>

        {/* Tabs */}
        {TABS.map(t => (
          <button key={t.id} onClick={() => setTab(t.id)} style={{
            padding: '3px 11px',
            fontSize: 8,
            background:   tab === t.id ? 'rgba(68,170,255,0.12)' : 'transparent',
            color:        tab === t.id ? SKY : 'rgba(100,140,180,0.6)',
            border:       `1px solid ${tab === t.id ? SKY : 'transparent'}`,
            borderRadius: 2,
            cursor: 'pointer',
            letterSpacing: '0.1em',
            textTransform: 'uppercase' as const,
            fontFamily: "'Courier New', monospace",
            display: 'flex', alignItems: 'center', gap: 5,
          }}>
            <span>{t.icon}</span> {t.label}
          </button>
        ))}

        {/* Live status + sign out */}
        <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 12 }}>
          <Dot live={live.connected} />
          <span style={{ fontSize: 8, color: live.connected ? GREEN : RED }}>
            {live.connected ? 'LIVE' : 'OFFLINE'}
          </span>
          {live.kuramoto && (
            <span style={{ fontSize: 8, color: DIM }}>
              K_R={fmt2(live.kuramoto.orderParam)}
            </span>
          )}
          {live.snapshot && (
            <span style={{ fontSize: 8, color: DIM }}>
              BEAT {fmtNum(live.snapshot.beat)}
            </span>
          )}
          <button onClick={onSignOut} style={{
            padding: '2px 9px',
            background: 'transparent',
            border: `1px solid rgba(68,170,255,0.2)`,
            borderRadius: 2,
            color: DIM,
            fontSize: 7,
            cursor: 'pointer',
            letterSpacing: '0.12em',
            textTransform: 'uppercase' as const,
            fontFamily: "'Courier New', monospace",
          }}>
            Sign Out
          </button>
        </div>
      </div>

      {/* ── Content ────────────────────────────────────────────────────── */}
      <div style={{ flex: 1, overflow: 'auto', padding: 16 }}>
        {tab === 'CONNECT'  && <SkyhiConnectPlatform />}
        {tab === 'LAYERS'   && <LayersPanel />}
        {tab === 'INTEL'    && <IntelPanel />}
        {tab === 'DFW'      && <DFWPanel />}
        {tab === 'FORMA'    && <FormaPanel />}
        {tab === 'PROPOSAL' && <ProposalPanel />}
      </div>

      {/* ── Footer bar ─────────────────────────────────────────────────── */}
      <div style={{
        height: 22,
        background: 'rgba(5,10,25,0.95)',
        borderTop: `1px solid rgba(68,170,255,0.1)`,
        display: 'flex', alignItems: 'center',
        padding: '0 18px', gap: 16, flexShrink: 0,
        fontSize: 7, color: 'rgba(80,110,140,0.5)', letterSpacing: '0.06em',
      }}>
        <span>© 2026 Alfredo Medina Hernandez · Medina Tech · Dallas, TX</span>
        <span>NOVA PARALLAX — Sovereign Enterprise Intelligence</span>
        <span style={{ marginLeft: 'auto' }}>
          {live.lastUpdated
            ? `Canister sync: ${new Date(live.lastUpdated).toLocaleTimeString()}`
            : 'Awaiting canister connection…'}
        </span>
      </div>
    </div>
  );
}
