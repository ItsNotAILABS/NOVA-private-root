// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Unified Defense Command Terminal
// ═══════════════════════════════════════════════════════════════════════════════
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// CONFIDENTIAL AND PROPRIETARY — Medina Doctrine
//
// THE BIG TERMINAL — Unified defense view across all defense layers:
//   Layer  9: Anti-Organism Defense (15 Blue + 15 Red stack, 6 Anti-Families)
//   Layer 10: War Command Offense (Crusaders, Honey Traps, Decoys)
//   Layer 16: Chimera Defense Division (21 organisms, 481 compliance controls)
//   Layer 17: Umbra Sovereign Shadow (11 shadow components)
//   Cyber Defense: Honeypots, Canaries, Threat Tracking
//   Frequency Warfare, Electromagnetic Warfare, AEGIS, VAEL
//
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';

// ── Types ──

interface ThreatLevel {
  name: string;
  level: number;
  status: 'CLEAR' | 'CAUTION' | 'ELEVATED' | 'CRITICAL';
  color: string;
}

interface DefenseLayer {
  name: string;
  layer: number;
  coherence: number;
  active: boolean;
  organisms: number;
  color: string;
}

interface HoneypotStatus {
  type: string;
  active: boolean;
  traps: number;
  color: string;
}

interface WarfareUnit {
  name: string;
  count: number;
  maxCount: number;
  status: string;
  color: string;
}

interface DefenseTerminalProps {
  beat: number;
  rSwarm: number;
}

// ── Constants ──

const PHI = 1.618033988749895;

const DEFENSE_LAYERS: DefenseLayer[] = [
  { name: 'Anti-Organism Defense',   layer: 9,  coherence: 0, active: true, organisms: 30, color: '#f44' },
  { name: 'War Command Offense',     layer: 10, coherence: 0, active: true, organisms: 8,  color: '#f84' },
  { name: 'Chimera Defense Division', layer: 16, coherence: 0, active: true, organisms: 21, color: '#fa4' },
  { name: 'Umbra Sovereign Shadow',  layer: 17, coherence: 0, active: true, organisms: 11, color: '#a4f' },
  { name: 'AEGIS Shield System',     layer: 0,  coherence: 0, active: true, organisms: 6,  color: '#4af' },
  { name: 'VAEL Complete Defense',   layer: 0,  coherence: 0, active: true, organisms: 8,  color: '#4ff' },
  { name: 'Frequency Warfare',       layer: 0,  coherence: 0, active: true, organisms: 4,  color: '#f4a' },
  { name: 'EM Warfare Engine',       layer: 0,  coherence: 0, active: true, organisms: 5,  color: '#8f4' },
];

const ANTI_FAMILIES = [
  { name: 'Counterfeit Axis',         threat: 0, color: '#f44' },
  { name: 'Gate-Capture Priesthood',   threat: 0, color: '#f84' },
  { name: 'Resonance Siphon',         threat: 0, color: '#fa4' },
  { name: 'Narrative Inversion',       threat: 0, color: '#a4f' },
  { name: 'Continuity Fracture',       threat: 0, color: '#4af' },
  { name: 'CONTAINMENT BREAKER',      threat: 0, color: '#f00' },
];

const HONEYPOT_TYPES = ['SSH', 'HTTP', 'Database', 'Medical', 'SCADA', 'Financial', 'ICP Canister', 'DNS', 'SMTP', 'IoT'];

// ── Styles ──

const S = {
  root: {
    height: '100%',
    display: 'grid',
    gridTemplateRows: 'auto 1fr auto',
    background: '#030208',
    fontFamily: "'Courier New', monospace",
    color: '#c0d0e0',
    overflow: 'hidden',
  } as React.CSSProperties,

  header: {
    background: 'linear-gradient(180deg, rgba(40, 5, 5, 0.95), rgba(20, 5, 15, 0.95))',
    borderBottom: '1px solid #5a1a1a',
    padding: '10px 16px',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
  } as React.CSSProperties,

  headerTitle: {
    fontSize: 12,
    fontWeight: 'bold',
    color: '#f44',
    letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
  },

  headerStatus: {
    display: 'flex',
    gap: 16,
    fontSize: 9,
    alignItems: 'center',
  } as React.CSSProperties,

  body: {
    display: 'grid',
    gridTemplateColumns: '260px 1fr 240px',
    gap: 1,
    overflow: 'hidden',
    background: '#080410',
  } as React.CSSProperties,

  // Left Panel: Defense Layers + Anti-Families
  leftPanel: {
    background: 'rgba(10, 5, 20, 0.9)',
    borderRight: '1px solid #2a1a3a',
    padding: '10px',
    overflow: 'auto',
  } as React.CSSProperties,

  sectionLabel: {
    fontSize: 8,
    color: '#5a3a3a',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.15em',
    marginBottom: 8,
    borderBottom: '1px solid #2a1a1a',
    paddingBottom: 4,
  } as React.CSSProperties,

  layerCard: (color: string) => ({
    background: 'rgba(15, 5, 10, 0.6)',
    border: `1px solid ${color}30`,
    borderRadius: 4,
    padding: '6px 8px',
    marginBottom: 4,
  }),

  layerHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 4,
  } as React.CSSProperties,

  layerName: (color: string) => ({
    fontSize: 8,
    fontWeight: 'bold',
    color,
    letterSpacing: '0.05em',
  }),

  layerBadge: (active: boolean) => ({
    fontSize: 7,
    padding: '1px 6px',
    borderRadius: 6,
    background: active ? 'rgba(0, 80, 0, 0.3)' : 'rgba(80, 0, 0, 0.3)',
    color: active ? '#4f8' : '#f44',
    border: `1px solid ${active ? '#4f8' : '#f44'}`,
  }),

  coherenceBar: {
    height: 3,
    background: '#0a0510',
    borderRadius: 2,
    overflow: 'hidden',
  } as React.CSSProperties,

  coherenceFill: (value: number, color: string) => ({
    width: `${Math.min(value * 100, 100)}%`,
    height: '100%',
    background: color,
    borderRadius: 2,
    transition: 'width 0.5s ease-out',
  }),

  threatCard: (color: string, level: number) => ({
    background: level > 0.7 ? 'rgba(60, 5, 5, 0.6)' : 'rgba(10, 5, 15, 0.4)',
    border: `1px solid ${level > 0.7 ? '#f44' : color + '30'}`,
    borderRadius: 3,
    padding: '5px 8px',
    marginBottom: 3,
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    fontSize: 8,
  }),

  // Center: Terminal
  centerPanel: {
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
  } as React.CSSProperties,

  statusBar: {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, 1fr)',
    gap: 4,
    padding: '8px 12px',
    background: 'rgba(5, 3, 10, 0.95)',
    borderBottom: '1px solid #2a1a3a',
  } as React.CSSProperties,

  statusItem: (color: string) => ({
    background: 'rgba(10, 5, 20, 0.6)',
    border: `1px solid ${color}40`,
    borderRadius: 4,
    padding: '6px 8px',
    textAlign: 'center' as const,
  }),

  statusValue: (color: string) => ({
    fontSize: 16,
    fontWeight: 'bold',
    color,
    fontFamily: 'monospace',
  }),

  statusLabel: {
    fontSize: 7,
    color: '#4a3a5a',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
    marginTop: 2,
  } as React.CSSProperties,

  terminalPanel: {
    flex: 1,
    padding: '10px 12px',
    overflow: 'auto',
    background: '#020108',
  } as React.CSSProperties,

  terminalLine: (type: string) => ({
    fontSize: 9,
    lineHeight: 1.7,
    color:
      type === 'header' ? '#f44' :
      type === 'alert' ? '#f44' :
      type === 'warning' ? '#fa4' :
      type === 'defense' ? '#4af' :
      type === 'success' ? '#4f8' :
      type === 'shadow' ? '#a4f' :
      '#5a4a6a',
    marginBottom: 1,
    fontFamily: 'monospace',
  }),

  cursor: {
    display: 'inline-block',
    width: 7,
    height: 12,
    background: '#f44',
    animation: 'defBlink 1s infinite',
    verticalAlign: 'middle',
    marginLeft: 4,
  } as React.CSSProperties,

  // Right Panel: Warfare + Honeypots
  rightPanel: {
    background: 'rgba(10, 5, 20, 0.9)',
    borderLeft: '1px solid #2a1a3a',
    padding: '10px',
    overflow: 'auto',
  } as React.CSSProperties,

  warfareUnit: (color: string) => ({
    background: 'rgba(15, 5, 10, 0.5)',
    border: `1px solid ${color}30`,
    borderRadius: 4,
    padding: '6px 8px',
    marginBottom: 4,
  }),

  unitHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    fontSize: 8,
    marginBottom: 4,
  } as React.CSSProperties,

  unitBar: {
    height: 4,
    background: '#0a0510',
    borderRadius: 2,
    overflow: 'hidden',
  } as React.CSSProperties,

  unitFill: (ratio: number, color: string) => ({
    width: `${Math.min(ratio * 100, 100)}%`,
    height: '100%',
    background: color,
    borderRadius: 2,
  }),

  honeypotDot: (active: boolean) => ({
    display: 'inline-block',
    width: 6,
    height: 6,
    borderRadius: '50%',
    background: active ? '#4f8' : '#2a1a1a',
    border: `1px solid ${active ? '#4f8' : '#3a2a2a'}`,
    marginRight: 4,
    marginBottom: 2,
  }),

  footer: {
    background: 'linear-gradient(180deg, rgba(20, 5, 15, 0.95), rgba(30, 5, 5, 0.95))',
    borderTop: '1px solid #5a1a1a',
    padding: '6px 16px',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    fontSize: 8,
    color: '#4a2a3a',
  } as React.CSSProperties,
};

// ── Simulation ──

function simulateDefenseLayers(beat: number, rSwarm: number): DefenseLayer[] {
  return DEFENSE_LAYERS.map((layer, i) => ({
    ...layer,
    coherence: Math.min(1, Math.max(0.3, 0.6 + rSwarm * 0.3 + Math.sin(beat * PHI * 0.1 + i * 0.7) * 0.1)),
    active: true,
  }));
}

function simulateAntiFamilies(beat: number): Array<{ name: string; threat: number; color: string }> {
  return ANTI_FAMILIES.map((af, i) => ({
    ...af,
    // Family 6 (CONTAINMENT BREAKER) always highest threat
    threat: i === 5
      ? Math.min(1, 0.4 + Math.sin(beat * 0.03) * 0.3 + 0.2)
      : Math.min(1, Math.max(0, 0.1 + Math.sin(beat * 0.05 + i * 1.2) * 0.2)),
  }));
}

function simulateWarfareUnits(beat: number): WarfareUnit[] {
  return [
    { name: 'Crusaders',    count: Math.min(144, 80 + Math.floor(Math.sin(beat * 0.02) * 30 + 30)), maxCount: 144, status: 'DEPLOYED', color: '#f84' },
    { name: 'Honey Traps',  count: Math.min(24,  12 + Math.floor(Math.cos(beat * 0.03) * 6 + 6)),   maxCount: 24,  status: 'ACTIVE',   color: '#fa4' },
    { name: 'Decoy Fleet',  count: Math.min(36,  20 + Math.floor(Math.sin(beat * 0.04) * 8 + 8)),   maxCount: 36,  status: 'PATROL',   color: '#a4f' },
    { name: 'Canaries',     count: Math.min(20,  10 + Math.floor(Math.cos(beat * 0.02) * 5 + 5)),   maxCount: 20,  status: 'WATCHING', color: '#4f8' },
    { name: 'Shield Drones', count: Math.min(64,  40 + Math.floor(Math.sin(beat * 0.05) * 12 + 12)), maxCount: 64,  status: 'ORBIT',    color: '#4af' },
  ];
}

function simulateHoneypots(beat: number): HoneypotStatus[] {
  return HONEYPOT_TYPES.map((type, i) => ({
    type,
    active: (beat + i * 7) % 11 !== 0,  // occasional deactivation
    traps: Math.floor((beat * (i + 1)) % 50),
    color: '#4f8',
  }));
}

// ── Component ──

export function DefenseTerminal({ beat, rSwarm }: DefenseTerminalProps) {
  const terminalRef = useRef<HTMLDivElement>(null);
  const [viewMode, setViewMode] = useState<'overview' | 'threats' | 'warfare'>('overview');

  const layers = simulateDefenseLayers(beat, rSwarm);
  const antiFamilies = simulateAntiFamilies(beat);
  const warfareUnits = simulateWarfareUnits(beat);
  const honeypots = simulateHoneypots(beat);

  const overallDefense = layers.reduce((sum, l) => sum + l.coherence, 0) / layers.length;
  const maxThreat = Math.max(...antiFamilies.map(af => af.threat));
  const totalCrusaders = warfareUnits[0].count;
  const activeHoneypots = honeypots.filter(h => h.active).length;

  useEffect(() => {
    if (terminalRef.current) {
      terminalRef.current.scrollTop = terminalRef.current.scrollHeight;
    }
  }, [beat]);

  const threatStatus = maxThreat > 0.7 ? 'CRITICAL' : maxThreat > 0.4 ? 'ELEVATED' : maxThreat > 0.2 ? 'CAUTION' : 'CLEAR';
  const threatColor = maxThreat > 0.7 ? '#f44' : maxThreat > 0.4 ? '#fa4' : maxThreat > 0.2 ? '#ff8' : '#4f8';

  // Terminal log
  const logLines: Array<{ type: string; text: string }> = [
    { type: 'header', text: '╔═══════════════════════════════════════════════════════════════╗' },
    { type: 'header', text: '║  DEFENSE COMMAND TERMINAL — UNIFIED THREAT ASSESSMENT        ║' },
    { type: 'header', text: '║  Layers 9, 10, 16, 17 + AEGIS + VAEL + Freq/EM Warfare      ║' },
    { type: 'header', text: '╚═══════════════════════════════════════════════════════════════╝' },
    { type: 'data', text: '' },
    { type: 'defense', text: `[BEAT ${beat}] Defense Readiness: ${(overallDefense * 100).toFixed(1)}%` },
    { type: threatStatus === 'CRITICAL' ? 'alert' : threatStatus === 'ELEVATED' ? 'warning' : 'success', text: `  Threat Level: ${threatStatus}  (max: ${(maxThreat * 100).toFixed(1)}%)` },
    { type: 'data', text: `  Active Honeypots: ${activeHoneypots}/${honeypots.length}` },
    { type: 'data', text: `  Crusaders Deployed: ${totalCrusaders}/144` },
    { type: 'data', text: '' },
    { type: 'defense', text: '── Defense Layer Status ──' },
    ...layers.map(l => ({
      type: 'defense',
      text: `  [L${String(l.layer).padStart(2, '0')}] ${l.name.padEnd(26)} COH=${l.coherence.toFixed(3)}  ORG=${l.organisms}  ${l.active ? '●' : '○'}`,
    })),
    { type: 'data', text: '' },
    { type: 'alert', text: '── Anti-Family Threat Matrix ──' },
    ...antiFamilies.map((af, i) => ({
      type: af.threat > 0.5 ? 'alert' : af.threat > 0.2 ? 'warning' : 'data',
      text: `  [${i + 1}] ${af.name.padEnd(26)} ${threatBar(af.threat)}  ${(af.threat * 100).toFixed(0)}%${i === 5 ? '  ⚠ CRITICAL' : ''}`,
    })),
    { type: 'data', text: '' },
    { type: 'shadow', text: '── Warfare Deployment ──' },
    ...warfareUnits.map(u => ({
      type: 'defense',
      text: `  ${u.name.padEnd(16)} ${String(u.count).padStart(3)}/${u.maxCount}  [${u.status}]`,
    })),
  ];

  return (
    <div style={S.root}>
      {/* Header */}
      <div style={S.header}>
        <span style={S.headerTitle}>⬡ Defense Command Terminal</span>
        <div style={S.headerStatus}>
          <span style={{ color: threatColor, fontWeight: 'bold' }}>THREAT: {threatStatus}</span>
          <span style={{ color: '#5a3a5a' }}>|</span>
          <span style={{ color: '#4f8' }}>DEF: {(overallDefense * 100).toFixed(0)}%</span>
          <span style={{ color: '#5a3a5a' }}>|</span>
          <span style={{ color: '#f84' }}>CRU: {totalCrusaders}/144</span>
          <span style={{ color: '#5a3a5a' }}>|</span>
          <span style={{ color: '#4af' }}>BEAT: {beat}</span>
        </div>
      </div>

      {/* Body */}
      <div style={S.body}>
        {/* Left: Defense Layers + Anti-Families */}
        <div style={S.leftPanel}>
          <div style={S.sectionLabel}>Defense Layers</div>
          {layers.map((layer, i) => (
            <div key={i} style={S.layerCard(layer.color)}>
              <div style={S.layerHeader}>
                <span style={S.layerName(layer.color)}>
                  {layer.layer > 0 ? `L${layer.layer} ` : ''}{layer.name}
                </span>
                <span style={S.layerBadge(layer.active)}>
                  {layer.active ? 'ON' : 'OFF'}
                </span>
              </div>
              <div style={S.coherenceBar}>
                <div style={S.coherenceFill(layer.coherence, layer.color)} />
              </div>
            </div>
          ))}

          <div style={{ ...S.sectionLabel, marginTop: 12 }}>6 Anti-Families</div>
          {antiFamilies.map((af, i) => (
            <div key={i} style={S.threatCard(af.color, af.threat)}>
              <span style={{ color: af.threat > 0.5 ? '#f44' : af.color }}>
                {i === 5 ? '⚠ ' : ''}{af.name}
              </span>
              <span style={{ color: af.threat > 0.5 ? '#f44' : '#5a4a6a', fontFamily: 'monospace' }}>
                {(af.threat * 100).toFixed(0)}%
              </span>
            </div>
          ))}
        </div>

        {/* Center: Status Bar + Terminal */}
        <div style={S.centerPanel}>
          {/* Status Dashboard */}
          <div style={S.statusBar}>
            <div style={S.statusItem('#f44')}>
              <div style={S.statusValue(threatColor)}>{threatStatus}</div>
              <div style={S.statusLabel}>Threat Level</div>
            </div>
            <div style={S.statusItem('#4f8')}>
              <div style={S.statusValue('#4f8')}>{(overallDefense * 100).toFixed(0)}%</div>
              <div style={S.statusLabel}>Defense Ready</div>
            </div>
            <div style={S.statusItem('#f84')}>
              <div style={S.statusValue('#f84')}>{totalCrusaders}</div>
              <div style={S.statusLabel}>Crusaders</div>
            </div>
            <div style={S.statusItem('#4af')}>
              <div style={S.statusValue('#4af')}>{activeHoneypots}</div>
              <div style={S.statusLabel}>Honeypots</div>
            </div>
          </div>

          {/* Terminal */}
          <div style={S.terminalPanel} ref={terminalRef}>
            {logLines.map((line, i) => (
              <div key={i} style={S.terminalLine(line.type)}>
                {line.text}
              </div>
            ))}
            <div style={S.terminalLine('data')}>
              <span style={{ color: '#f44' }}>DEF&gt;</span>
              <span style={S.cursor} />
            </div>
          </div>
        </div>

        {/* Right: Warfare Units + Honeypots */}
        <div style={S.rightPanel}>
          <div style={S.sectionLabel}>Warfare Units</div>
          {warfareUnits.map((unit, i) => (
            <div key={i} style={S.warfareUnit(unit.color)}>
              <div style={S.unitHeader}>
                <span style={{ color: unit.color, fontWeight: 'bold' }}>{unit.name}</span>
                <span style={{ color: '#5a4a6a' }}>{unit.count}/{unit.maxCount} [{unit.status}]</span>
              </div>
              <div style={S.unitBar}>
                <div style={S.unitFill(unit.count / unit.maxCount, unit.color)} />
              </div>
            </div>
          ))}

          <div style={{ ...S.sectionLabel, marginTop: 12 }}>Honeypot Grid</div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 2, marginBottom: 8 }}>
            {honeypots.map((hp, i) => (
              <div key={i} title={`${hp.type}: ${hp.active ? 'ACTIVE' : 'OFFLINE'} (${hp.traps} traps)`}>
                <span style={S.honeypotDot(hp.active)} />
              </div>
            ))}
          </div>
          <div style={{ fontSize: 8, color: '#4a3a5a' }}>
            {honeypots.map((hp, i) => (
              <div key={i} style={{ marginBottom: 2, color: hp.active ? '#4f8' : '#3a2a2a' }}>
                {hp.active ? '●' : '○'} {hp.type} — {hp.traps} traps
              </div>
            ))}
          </div>

          {/* Compliance */}
          <div style={{ ...S.sectionLabel, marginTop: 12 }}>Compliance (481 Controls)</div>
          {[
            { name: 'SOC2', controls: 64, color: '#4af' },
            { name: 'FedRAMP', controls: 325, color: '#fa4' },
            { name: 'HIPAA', controls: 54, color: '#4f8' },
            { name: 'ITAR', controls: 38, color: '#f4a' },
          ].map((c, i) => (
            <div key={i} style={{ fontSize: 8, color: c.color, marginBottom: 3, display: 'flex', justifyContent: 'space-between' }}>
              <span>{c.name}</span>
              <span>{c.controls} controls</span>
            </div>
          ))}
        </div>
      </div>

      {/* Footer */}
      <div style={S.footer}>
        <span>LAYERS 9/10/16/17 | ANTI-ORG DEFENSE | WAR COMMAND | CHIMERA | UMBRA | AEGIS | VAEL</span>
        <span>CONTAINMENT BREAKER: w₆ = 10.0 | NO-DROP LAW | PHI-COUPLED</span>
      </div>

      <style>{`
        @keyframes defBlink {
          0%, 50% { opacity: 1; }
          51%, 100% { opacity: 0; }
        }
      `}</style>
    </div>
  );
}

// ── Helper: ASCII threat bar ──

function threatBar(value: number): string {
  const width = 15;
  const filled = Math.round(value * width);
  const char = value > 0.7 ? '█' : value > 0.4 ? '▓' : '░';
  return char.repeat(filled) + '·'.repeat(width - filled);
}
