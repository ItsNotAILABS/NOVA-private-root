// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Packaging Research Lab Terminal
// Layer 38 | 2,000-Node Micro-Dimensional Grid | Third Synthesizer ⊕ Coupling
// ═══════════════════════════════════════════════════════════════════════════════
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// CONFIDENTIAL AND PROPRIETARY — Medina Doctrine
//
// 8 PHI-aligned research divisions × 250 nodes each = 2,000 nodes
// 5-Dimensional field: Temporal, Spatial, Organizational, Causal, Coherence
// Third Synthesizer ⊕ operator: transform-and-retain (never drops)
//
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';

// ── Types ──

interface DivisionData {
  name: string;
  shortName: string;
  coherence: number;
  experiments: number;
  findings: number;
  activeNodes: number;
  totalNodes: number;
  fieldStrength: number;
  color: string;
}

interface DimensionalField {
  temporal: number;
  spatial: number;
  organizational: number;
  causal: number;
  coherence: number;
}

interface SynthesizerState {
  psi: number;
  retained: number;
  transforms: number;
}

interface LabTerminalProps {
  beat: number;
  rSwarm: number;
}

// ── Constants ──

const DIVISIONS: Array<{ name: string; shortName: string; color: string }> = [
  { name: 'Artifact Analysis', shortName: 'ART', color: '#4af' },
  { name: 'SDK Forge',         shortName: 'FRG', color: '#f84' },
  { name: 'Quality Assurance', shortName: 'QAL', color: '#4f8' },
  { name: 'Prototype Workshop', shortName: 'PRT', color: '#fa4' },
  { name: 'Registry Research', shortName: 'REG', color: '#a4f' },
  { name: 'Replication Lab',   shortName: 'RPL', color: '#4ff' },
  { name: 'Cryptography Lab',  shortName: 'CRY', color: '#f4a' },
  { name: 'Doctrine Compliance', shortName: 'DOC', color: '#8f4' },
];

const DIMENSION_NAMES = ['Temporal', 'Spatial', 'Organizational', 'Causal', 'Coherence'];
const DIMENSION_COLORS = ['#4af', '#f84', '#fa4', '#a4f', '#4f8'];
const PHI = 1.618033988749895;

// ── Styles ──

const S = {
  root: {
    height: '100%',
    display: 'grid',
    gridTemplateColumns: '1fr',
    gridTemplateRows: 'auto 1fr auto',
    background: '#020408',
    fontFamily: "'Courier New', monospace",
    color: '#c0d0e0',
    overflow: 'hidden',
  } as React.CSSProperties,

  header: {
    background: 'rgba(5, 15, 35, 0.95)',
    borderBottom: '1px solid #1a3a5c',
    padding: '10px 16px',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
  } as React.CSSProperties,

  headerTitle: {
    fontSize: 11,
    fontWeight: 'bold',
    color: '#4af',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
  },

  headerMetric: {
    fontSize: 9,
    color: '#6a8aba',
    display: 'flex',
    gap: 16,
    alignItems: 'center',
  } as React.CSSProperties,

  body: {
    display: 'grid',
    gridTemplateColumns: '280px 1fr 240px',
    gap: 1,
    overflow: 'hidden',
    background: '#0a0f18',
  } as React.CSSProperties,

  // Left Panel: Division Grid
  leftPanel: {
    background: 'rgba(5, 15, 30, 0.9)',
    borderRight: '1px solid #1a2a3c',
    padding: '10px',
    overflow: 'auto',
  } as React.CSSProperties,

  sectionLabel: {
    fontSize: 8,
    color: '#3a6a9a',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.15em',
    marginBottom: 8,
    borderBottom: '1px solid #1a2a3c',
    paddingBottom: 4,
  } as React.CSSProperties,

  divisionCard: (color: string, isActive: boolean) => ({
    background: isActive ? 'rgba(10, 30, 60, 0.6)' : 'rgba(5, 10, 20, 0.4)',
    border: `1px solid ${isActive ? color + '60' : '#1a2a3c'}`,
    borderRadius: 4,
    padding: '8px 10px',
    marginBottom: 6,
    cursor: 'pointer',
    transition: 'border-color 0.3s',
  }),

  divisionHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 6,
  } as React.CSSProperties,

  divisionName: (color: string) => ({
    fontSize: 9,
    fontWeight: 'bold',
    color,
    letterSpacing: '0.08em',
  }),

  nodeCount: {
    fontSize: 8,
    color: '#5a8aba',
    fontFamily: 'monospace',
  },

  coherenceBar: {
    height: 3,
    background: '#0a1520',
    borderRadius: 2,
    overflow: 'hidden',
    marginBottom: 4,
  } as React.CSSProperties,

  coherenceFill: (value: number, color: string) => ({
    width: `${Math.min(value * 100, 100)}%`,
    height: '100%',
    background: color,
    borderRadius: 2,
    transition: 'width 0.5s ease-out',
  }),

  divisionStats: {
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: 4,
    fontSize: 8,
    color: '#4a6a8a',
  } as React.CSSProperties,

  statValue: (color: string) => ({
    color,
    fontWeight: 'bold',
    fontFamily: 'monospace',
  }),

  // Center Panel: Terminal + Node Grid Visualization
  centerPanel: {
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
  } as React.CSSProperties,

  nodeGridViz: {
    padding: '10px 12px',
    borderBottom: '1px solid #1a2a3c',
    background: 'rgba(3, 8, 16, 0.9)',
  } as React.CSSProperties,

  gridTitle: {
    fontSize: 9,
    color: '#3a6a9a',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.12em',
    marginBottom: 8,
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
  } as React.CSSProperties,

  nodeRow: {
    display: 'flex',
    gap: 2,
    marginBottom: 3,
    alignItems: 'center',
  } as React.CSSProperties,

  nodeRowLabel: {
    width: 28,
    fontSize: 7,
    color: '#3a5a7a',
    textAlign: 'right' as const,
    marginRight: 6,
    fontFamily: 'monospace',
  } as React.CSSProperties,

  nodeBlock: (active: boolean, color: string) => ({
    width: 3,
    height: 8,
    background: active ? color + '90' : '#0a1520',
    borderRadius: 1,
    transition: 'background 0.3s',
  }),

  terminalPanel: {
    flex: 1,
    padding: '10px 12px',
    overflow: 'auto',
    background: '#020408',
  } as React.CSSProperties,

  terminalLine: (type: string) => ({
    fontSize: 9,
    lineHeight: 1.7,
    color:
      type === 'header' ? '#4af' :
      type === 'data' ? '#6a8aba' :
      type === 'success' ? '#4f8' :
      type === 'warning' ? '#fa4' :
      type === 'phi' ? '#f4a' :
      '#5a7a9a',
    marginBottom: 1,
    fontFamily: 'monospace',
  }),

  cursor: {
    display: 'inline-block',
    width: 7,
    height: 12,
    background: '#4af',
    animation: 'labBlink 1s infinite',
    verticalAlign: 'middle',
    marginLeft: 4,
  } as React.CSSProperties,

  // Right Panel: 5D Field + Synthesizer
  rightPanel: {
    background: 'rgba(5, 15, 30, 0.9)',
    borderLeft: '1px solid #1a2a3c',
    padding: '10px',
    overflow: 'auto',
  } as React.CSSProperties,

  fieldDimension: (color: string) => ({
    marginBottom: 10,
  }),

  fieldLabel: (color: string) => ({
    fontSize: 8,
    color,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
    marginBottom: 3,
    display: 'flex',
    justifyContent: 'space-between',
  }),

  fieldBar: {
    height: 6,
    background: '#0a1520',
    borderRadius: 3,
    overflow: 'hidden',
  } as React.CSSProperties,

  fieldFill: (value: number, color: string) => ({
    width: `${Math.min(value * 100, 100)}%`,
    height: '100%',
    background: `linear-gradient(90deg, ${color}40, ${color})`,
    borderRadius: 3,
    transition: 'width 0.8s ease-out',
  }),

  synthBox: {
    background: 'rgba(10, 25, 50, 0.6)',
    border: '1px solid #2a4a6a',
    borderRadius: 4,
    padding: '10px',
    marginBottom: 10,
  } as React.CSSProperties,

  synthLabel: {
    fontSize: 8,
    color: '#f4a',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.12em',
    marginBottom: 8,
  } as React.CSSProperties,

  synthValue: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#fff',
    fontFamily: 'monospace',
    textAlign: 'center' as const,
    marginBottom: 4,
  } as React.CSSProperties,

  synthDetail: {
    fontSize: 8,
    color: '#5a8aba',
    textAlign: 'center' as const,
  } as React.CSSProperties,

  // Footer
  footer: {
    background: 'rgba(5, 15, 35, 0.95)',
    borderTop: '1px solid #1a3a5c',
    padding: '6px 16px',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    fontSize: 8,
    color: '#3a5a7a',
  } as React.CSSProperties,
};

// ── Simulated data generator (connects to canister in production) ──

function simulateDivisionData(beat: number, rSwarm: number): DivisionData[] {
  return DIVISIONS.map((div, i) => {
    const phase = Math.sin(beat * PHI * 0.1 + i * 0.618);
    const coherence = Math.min(1, Math.max(0.05, 0.5 + rSwarm * 0.3 + phase * 0.15));
    const activeFraction = coherence * 0.9 + 0.1;
    return {
      ...div,
      coherence,
      experiments: Math.floor((beat * (i + 1) * 7) % 500 + beat * 0.7),
      findings: Math.floor((beat * (i + 1) * 3) % 120 + beat * 0.15),
      activeNodes: Math.min(250, Math.max(25, Math.floor(activeFraction * 250))),
      totalNodes: 250,
      fieldStrength: Math.min(1, Math.max(0.05, 0.5 + rSwarm * 0.2 + Math.cos(beat * 0.05 + i) * 0.1)),
    };
  });
}

function simulateField(beat: number, rSwarm: number): DimensionalField {
  return {
    temporal: Math.min(1, Math.max(0.05, 0.5 + Math.sin(beat * PHI * 0.01) * 0.2 + rSwarm * 0.1)),
    spatial: Math.min(1, Math.max(0.05, 0.5 + Math.cos(beat * 0.618 * 0.01) * 0.2 + rSwarm * 0.1)),
    organizational: Math.min(1, Math.max(0.05, 0.5 + Math.sin(beat * PHI * 0.618 * 0.01) * 0.15 + rSwarm * 0.12)),
    causal: Math.min(1, Math.max(0.05, 0.5 + Math.cos(beat * PHI * 0.02) * 0.18 + rSwarm * 0.08)),
    coherence: Math.min(1, Math.max(0.05, 0.5 + rSwarm * 0.25 + Math.sin(beat * 0.001 * Math.PI * 2) * 0.1)),
  };
}

function simulateSynthesizer(beat: number, rSwarm: number): SynthesizerState {
  const psi = Math.min(1, Math.max(0.05, 0.5 * 0.97 + rSwarm * 0.03));
  return {
    psi,
    retained: psi * 0.97 + 0.01,
    transforms: beat,
  };
}

// ── Component ──

export function PackagingLabTerminal({ beat, rSwarm }: LabTerminalProps) {
  const terminalRef = useRef<HTMLDivElement>(null);
  const [selectedDiv, setSelectedDiv] = useState<number | null>(null);

  const divisions = simulateDivisionData(beat, rSwarm);
  const field = simulateField(beat, rSwarm);
  const synth = simulateSynthesizer(beat, rSwarm);
  const totalActive = divisions.reduce((sum, d) => sum + d.activeNodes, 0);
  const labCoherence = divisions.reduce((sum, d) => sum + d.coherence, 0) / 8;

  useEffect(() => {
    if (terminalRef.current) {
      terminalRef.current.scrollTop = terminalRef.current.scrollHeight;
    }
  }, [beat]);

  // Generate terminal log lines
  const logLines: Array<{ type: string; text: string }> = [
    { type: 'header', text: '╔═══════════════════════════════════════════════════════════╗' },
    { type: 'header', text: '║  PACKAGING RESEARCH LAB — 2,000-NODE GRID TERMINAL       ║' },
    { type: 'header', text: '║  Layer 38 | Third Synthesizer ⊕ Coupled                  ║' },
    { type: 'header', text: '╚═══════════════════════════════════════════════════════════╝' },
    { type: 'data', text: '' },
    { type: 'data', text: `[BEAT ${beat}] Grid Status: ${totalActive}/2000 nodes active` },
    { type: 'data', text: `  Lab Coherence:        ${labCoherence.toFixed(4)}` },
    { type: 'phi', text: `  Synthesizer Ψ:        ${synth.psi.toFixed(6)}` },
    { type: 'phi', text: `  Retained Signal:      ${synth.retained.toFixed(6)}` },
    { type: 'data', text: `  ⊕ Transforms:        ${synth.transforms}` },
    { type: 'data', text: '' },
    { type: 'success', text: '── 5-Dimensional Field ──' },
    { type: 'data', text: `  D0 Temporal:       ${field.temporal.toFixed(4)}  ${fieldBar(field.temporal)}` },
    { type: 'data', text: `  D1 Spatial:        ${field.spatial.toFixed(4)}  ${fieldBar(field.spatial)}` },
    { type: 'data', text: `  D2 Organizational: ${field.organizational.toFixed(4)}  ${fieldBar(field.organizational)}` },
    { type: 'data', text: `  D3 Causal:         ${field.causal.toFixed(4)}  ${fieldBar(field.causal)}` },
    { type: 'data', text: `  D4 Coherence:      ${field.coherence.toFixed(4)}  ${fieldBar(field.coherence)}` },
    { type: 'data', text: '' },
    { type: 'success', text: '── Division Grid Status ──' },
    ...divisions.map((d, i) => ({
      type: d.activeNodes >= 200 ? 'data' : 'warning',
      text: `  [${i}] ${d.shortName}  ${String(d.activeNodes).padStart(3)}/250  coh=${d.coherence.toFixed(3)}  exp=${d.experiments}  fld=${d.fieldStrength.toFixed(3)}`,
    })),
  ];

  return (
    <div style={S.root}>
      {/* Header */}
      <div style={S.header}>
        <span style={S.headerTitle}>◆ Packaging Research Lab — Layer 38</span>
        <div style={S.headerMetric}>
          <span>NODES: <span style={{ color: '#4f8', fontWeight: 'bold' }}>{totalActive}</span>/2000</span>
          <span>COH: <span style={{ color: labCoherence > 0.7 ? '#4f8' : labCoherence > 0.4 ? '#fa4' : '#f44', fontWeight: 'bold' }}>{labCoherence.toFixed(3)}</span></span>
          <span>Ψ: <span style={{ color: '#f4a', fontWeight: 'bold' }}>{synth.psi.toFixed(4)}</span></span>
          <span>BEAT: <span style={{ color: '#4af' }}>{beat}</span></span>
        </div>
      </div>

      {/* Body */}
      <div style={S.body}>
        {/* Left: Division Cards */}
        <div style={S.leftPanel}>
          <div style={S.sectionLabel}>8 Research Divisions × 250 Nodes</div>
          {divisions.map((div, i) => (
            <div
              key={i}
              style={S.divisionCard(div.color, selectedDiv === i)}
              onClick={() => setSelectedDiv(selectedDiv === i ? null : i)}
            >
              <div style={S.divisionHeader}>
                <span style={S.divisionName(div.color)}>◉ {div.name}</span>
                <span style={S.nodeCount}>{div.activeNodes}/{div.totalNodes}</span>
              </div>
              <div style={S.coherenceBar}>
                <div style={S.coherenceFill(div.coherence, div.color)} />
              </div>
              <div style={S.divisionStats}>
                <span>EXP <span style={S.statValue(div.color)}>{div.experiments}</span></span>
                <span>FND <span style={S.statValue('#fa4')}>{div.findings}</span></span>
                <span>FLD <span style={S.statValue('#4af')}>{div.fieldStrength.toFixed(2)}</span></span>
                <span>COH <span style={S.statValue(div.color)}>{div.coherence.toFixed(2)}</span></span>
              </div>
            </div>
          ))}
        </div>

        {/* Center: Node Grid Viz + Terminal */}
        <div style={S.centerPanel}>
          {/* Node Grid Visualization */}
          <div style={S.nodeGridViz}>
            <div style={S.gridTitle}>
              <span style={{ fontSize: 8, color: '#3a6a9a' }}>2,000-NODE MICRO-DIMENSIONAL GRID</span>
              <span style={{ fontSize: 8, color: '#4f8' }}>{totalActive} ACTIVE</span>
            </div>
            {divisions.map((div, i) => (
              <div key={i} style={S.nodeRow}>
                <span style={S.nodeRowLabel}>{div.shortName}</span>
                {Array.from({ length: 50 }, (_, j) => {
                  const nodeActive = j < Math.floor(div.activeNodes / 5);
                  return <div key={j} style={S.nodeBlock(nodeActive, div.color)} />;
                })}
              </div>
            ))}
          </div>

          {/* Terminal Output */}
          <div style={S.terminalPanel} ref={terminalRef}>
            {logLines.map((line, i) => (
              <div key={i} style={S.terminalLine(line.type)}>
                {line.text}
              </div>
            ))}
            <div style={S.terminalLine('data')}>
              <span style={{ color: '#4af' }}>LAB&gt;</span>
              <span style={S.cursor} />
            </div>
          </div>
        </div>

        {/* Right: 5D Field + Synthesizer */}
        <div style={S.rightPanel}>
          {/* Third Synthesizer */}
          <div style={S.sectionLabel}>Third Synthesizer ⊕</div>
          <div style={S.synthBox}>
            <div style={S.synthLabel}>Ψ State (Transform-and-Retain)</div>
            <div style={S.synthValue}>{synth.psi.toFixed(6)}</div>
            <div style={S.synthDetail}>
              Retained: {synth.retained.toFixed(6)} | ⊕ Count: {synth.transforms}
            </div>
          </div>

          {/* 5-Dimensional Field */}
          <div style={S.sectionLabel}>5-Dimensional Field</div>
          {DIMENSION_NAMES.map((dim, i) => {
            const values = [field.temporal, field.spatial, field.organizational, field.causal, field.coherence];
            return (
              <div key={i} style={S.fieldDimension(DIMENSION_COLORS[i])}>
                <div style={S.fieldLabel(DIMENSION_COLORS[i])}>
                  <span>D{i} {dim}</span>
                  <span>{values[i].toFixed(3)}</span>
                </div>
                <div style={S.fieldBar}>
                  <div style={S.fieldFill(values[i], DIMENSION_COLORS[i])} />
                </div>
              </div>
            );
          })}

          {/* Division Coherence Summary */}
          <div style={{ ...S.sectionLabel, marginTop: 16 }}>Division Coherences</div>
          {divisions.map((div, i) => (
            <div key={i} style={{ marginBottom: 6 }}>
              <div style={{ fontSize: 8, color: div.color, display: 'flex', justifyContent: 'space-between' }}>
                <span>{div.shortName}</span>
                <span>{div.coherence.toFixed(3)}</span>
              </div>
              <div style={S.coherenceBar}>
                <div style={S.coherenceFill(div.coherence, div.color)} />
              </div>
            </div>
          ))}

          {/* Grid Health */}
          <div style={{ ...S.sectionLabel, marginTop: 16 }}>Grid Health</div>
          <div style={{ fontSize: 9, color: totalActive >= 1600 ? '#4f8' : '#f44' }}>
            {totalActive >= 1600 ? '● HEALTHY' : '● DEGRADED'} — {totalActive}/2000 nodes
          </div>
        </div>
      </div>

      {/* Footer */}
      <div style={S.footer}>
        <span>LAYER 38 | PACKAGING RESEARCH LAB | 8 DIVISIONS × 250 NODES = 2,000 TOTAL</span>
        <span>PHI: φ={PHI.toFixed(6)} | SYNTH: ⊕ transform-and-retain</span>
      </div>

      <style>{`
        @keyframes labBlink {
          0%, 50% { opacity: 1; }
          51%, 100% { opacity: 0; }
        }
      `}</style>
    </div>
  );
}

// ── Helper: ASCII field bar ──

function fieldBar(value: number): string {
  const width = 20;
  const filled = Math.round(value * width);
  return '▓'.repeat(filled) + '░'.repeat(width - filled);
}
