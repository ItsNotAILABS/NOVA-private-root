// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Neural Terminal
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';

const DOMAIN_COLOR = '#4fa';

const S = {
  root: {
    height: '100%',
    display: 'grid' as const,
    gridTemplateColumns: '300px 1fr',
    gap: 2,
    background: '#050a14',
    fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
  },
  panel: {
    background: 'rgba(5, 15, 30, 0.9)',
    borderRight: `1px solid ${DOMAIN_COLOR}33`,
    padding: '12px',
    overflow: 'auto' as const,
  },
  terminal: {
    background: '#020408',
    fontFamily: 'monospace',
    fontSize: 11,
    padding: '12px',
    overflow: 'auto' as const,
  },
  header: {
    fontSize: 10,
    color: DOMAIN_COLOR,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.12em',
    marginBottom: 12,
    display: 'flex' as const,
    alignItems: 'center' as const,
    gap: 8,
    borderBottom: `1px solid ${DOMAIN_COLOR}44`,
    paddingBottom: 8,
  },
  packageCard: {
    background: 'rgba(10, 20, 40, 0.8)',
    border: `1px solid ${DOMAIN_COLOR}33`,
    borderRadius: 6,
    padding: '10px 12px',
    marginBottom: 8,
  },
  packageName: {
    fontSize: 11,
    fontWeight: 'bold' as const,
    color: '#fff',
    marginBottom: 4,
  },
  packageModel: {
    fontSize: 9,
    color: DOMAIN_COLOR,
    marginBottom: 6,
    fontFamily: 'monospace',
  },
  capList: {
    listStyle: 'none' as const,
    padding: 0,
    margin: 0,
  },
  capItem: {
    fontSize: 9,
    color: '#6a8aaa',
    padding: '2px 0',
  },
  metric: {
    marginTop: 8,
    display: 'flex' as const,
    justifyContent: 'space-between' as const,
    alignItems: 'center' as const,
  },
  metricLabel: {
    fontSize: 8,
    color: '#5a7a9a',
    textTransform: 'uppercase' as const,
  },
  metricBar: {
    width: 120,
    height: 4,
    background: '#0a1a2a',
    borderRadius: 2,
    overflow: 'hidden' as const,
  },
  metricFill: (value: number) => ({
    width: `${value * 100}%`,
    height: '100%',
    background: value > 0.8 ? DOMAIN_COLOR : value > 0.5 ? '#fa4' : '#4af',
    borderRadius: 2,
  }),
  line: (type: string) => ({
    fontSize: 10,
    lineHeight: 1.7,
    color: type === 'SYS' ? '#555' : type === 'DATA' ? DOMAIN_COLOR : type === 'ALERT' ? '#f44' : '#6ac',
    marginBottom: 1,
  }),
  ts: { color: '#3a5a7a', marginRight: 8 },
  src: { color: '#6ac', marginRight: 8 },
  cursor: {
    display: 'inline-block' as const,
    width: 8,
    height: 14,
    background: DOMAIN_COLOR,
    animation: 'blink 1s infinite',
    verticalAlign: 'middle' as const,
  },
  callCard: {
    background: 'rgba(10, 20, 40, 0.6)',
    border: `1px solid ${DOMAIN_COLOR}22`,
    borderRadius: 4,
    padding: '6px 8px',
    marginBottom: 4,
    fontSize: 9,
  },
  callName: {
    color: '#aaa',
    fontWeight: 'bold' as const,
  },
  callEndpoint: {
    color: DOMAIN_COLOR,
    fontFamily: 'monospace',
    fontSize: 8,
  },
};

interface Package {
  id: string;
  name: string;
  model: string;
  capabilities: string[];
  coherence: number;
}

interface LogEntry {
  id: number;
  time: string;
  source: string;
  type: string;
  message: string;
}

const PACKAGES: Package[] = [
  {
    id: 'PKG-08',
    name: 'Neural Core Mesh',
    model: 'nova-mesh-v5.0',
    capabilities: [
      'Mesh coherence monitoring',
      'Wiring density optimization',
      'Synaptic weight balancing',
      'Core interconnect routing',
    ],
    coherence: 0.95,
  },
  {
    id: 'PKG-09',
    name: 'Neurochemical Crosstalk',
    model: 'nova-nchem-v2.3',
    capabilities: [
      'Transmitter level regulation',
      'Crosstalk matrix computation',
      'Receptor binding simulation',
      'Neuromodulation scheduling',
    ],
    coherence: 0.90,
  },
  {
    id: 'PKG-10',
    name: 'Brain Region Intelligence',
    model: 'nova-brainreg-v3.7',
    capabilities: [
      '96 brain region mapping',
      'Regional activity profiling',
      'Inter-region signal routing',
      'Functional area clustering',
    ],
    coherence: 0.93,
  },
];

const CALLS = [
  { id: 'C-11', name: 'Neural Core', endpoint: 'get_neural_core_state()' },
  { id: 'C-12', name: 'Brain Regions', endpoint: 'get_brain_regions()' },
  { id: 'C-13', name: 'Neurotransmitter', endpoint: 'get_neurotransmitter_levels()' },
  { id: 'C-14', name: 'Neurochemical', endpoint: 'get_neurochemical_state()' },
];

const TRANSMITTERS = ['Dopamine', 'Serotonin', 'GABA', 'Glutamate', 'Acetylcholine', 'Norepinephrine'];
const REGIONS = [
  'Prefrontal', 'Hippocampus', 'Amygdala', 'Thalamus', 'Cerebellum',
  'Basal Ganglia', 'Cingulate', 'Insula', 'Parietal', 'Temporal',
];

function ts(): string {
  return new Date().toLocaleTimeString('en-US', { hour12: false });
}

function buildBootMessages(): LogEntry[] {
  const t = ts();
  return [
    { id: 1, time: t, source: 'BOOT', type: 'SYS', message: 'Neural Terminal v1.0.0 initialized' },
    { id: 2, time: t, source: 'BOOT', type: 'SYS', message: 'Neural Core Mesh linked — 96 regions mapped' },
    { id: 3, time: t, source: 'BOOT', type: 'SYS', message: 'Neurochemical Crosstalk linked — transmitter bus active' },
    { id: 4, time: t, source: 'BOOT', type: 'SYS', message: 'Brain Region Intelligence linked — profiling started' },
    { id: 5, time: t, source: 'MESH', type: 'DATA', message: 'Mesh coherence: 0.951 | Wiring density: 0.873 | Active cores: 96/96' },
    { id: 6, time: t, source: 'NCHEM', type: 'DATA', message: 'Transmitter levels — DA:0.72 5HT:0.68 GABA:0.81 Glu:0.79 ACh:0.65 NE:0.71' },
    { id: 7, time: t, source: 'BRAIN', type: 'DATA', message: '96 brain regions online — crosstalk matrix 96×96 computed' },
    { id: 8, time: t, source: 'SYSTEM', type: 'SYS', message: 'All neural subsystems nominal — mesh fully connected' },
  ];
}

function generateLogEntry(id: number): LogEntry {
  const sources = ['MESH', 'NCHEM', 'BRAIN', 'SYSTEM'];
  const source = sources[Math.floor(Math.random() * sources.length)];
  const entries: Record<string, string[]> = {
    MESH: [
      `Coherence update: ${(0.90 + Math.random() * 0.09).toFixed(3)} | wiring density: ${(0.84 + Math.random() * 0.15).toFixed(3)}`,
      `Core C-${String(Math.floor(Math.random() * 96) + 1).padStart(2, '0')} — synaptic rebalance complete — Δw: ${(Math.random() * 0.05).toFixed(4)}`,
      `Interconnect route optimized — path length reduced by ${(Math.random() * 15 + 1).toFixed(1)}%`,
      `Mesh heartbeat — 96/96 cores responding — avg latency ${(Math.random() * 2 + 0.3).toFixed(1)}ms`,
    ],
    NCHEM: [
      `${TRANSMITTERS[Math.floor(Math.random() * TRANSMITTERS.length)]} level: ${(0.5 + Math.random() * 0.49).toFixed(3)} — ${Math.random() > 0.3 ? 'NOMINAL' : 'ELEVATED'}`,
      `Crosstalk matrix row ${Math.floor(Math.random() * 96)} updated — max coupling: ${(Math.random() * 0.3 + 0.05).toFixed(3)}`,
      `Receptor binding cycle #${(id * 7) % 999} — occupancy: ${(60 + Math.random() * 35).toFixed(1)}%`,
      `Neuromodulation pulse — target: ${REGIONS[Math.floor(Math.random() * REGIONS.length)]} — amplitude: ${(Math.random() * 0.8 + 0.2).toFixed(2)}`,
    ],
    BRAIN: [
      `Region ${REGIONS[Math.floor(Math.random() * REGIONS.length)]} — activity: ${(Math.random() * 100).toFixed(1)}% — ${Math.random() > 0.5 ? 'processing' : 'idle'}`,
      `Inter-region signal: ${REGIONS[Math.floor(Math.random() * REGIONS.length)]} → ${REGIONS[Math.floor(Math.random() * REGIONS.length)]} — strength ${(Math.random() * 0.9 + 0.1).toFixed(3)}`,
      `Functional cluster #${Math.floor(Math.random() * 12) + 1} — ${Math.floor(Math.random() * 8 + 3)} regions — coherence ${(0.7 + Math.random() * 0.29).toFixed(2)}`,
    ],
    SYSTEM: [
      `Heartbeat OK — neural subsystem latency ${(Math.random() * 3 + 0.3).toFixed(1)}ms`,
      `Neural coherence index: ${(0.90 + Math.random() * 0.09).toFixed(3)}`,
    ],
  };
  const pool = entries[source];
  const message = pool[Math.floor(Math.random() * pool.length)];
  const type = source === 'SYSTEM' ? 'SYS' : Math.random() > 0.93 ? 'ALERT' : 'DATA';
  return { id, time: ts(), source, type, message };
}

export function NeuralTerminal() {
  const terminalRef = useRef<HTMLDivElement>(null);
  const [logs, setLogs] = useState<LogEntry[]>(buildBootMessages);
  const nextId = useRef(100);

  useEffect(() => {
    const interval = setInterval(() => {
      setLogs(prev => {
        const entry = generateLogEntry(nextId.current++);
        const next = [...prev, entry];
        return next.length > 200 ? next.slice(-200) : next;
      });
    }, 1800);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    if (terminalRef.current) {
      terminalRef.current.scrollTop = terminalRef.current.scrollHeight;
    }
  }, [logs]);

  return (
    <div style={S.root}>
      {/* Left Panel — Packages */}
      <div style={S.panel}>
        <div style={S.header}>
          <span style={{ fontSize: 14 }}>⊛</span> Neural Packages
        </div>

        {PACKAGES.map(pkg => (
          <div key={pkg.id} style={S.packageCard}>
            <div style={S.packageName}>{pkg.name}</div>
            <div style={S.packageModel}>{pkg.id} — {pkg.model}</div>
            <ul style={S.capList}>
              {pkg.capabilities.map((cap, i) => (
                <li key={i} style={S.capItem}>▸ {cap}</li>
              ))}
            </ul>
            <div style={S.metric}>
              <span style={S.metricLabel}>Coherence</span>
              <div style={S.metricBar}>
                <div style={S.metricFill(pkg.coherence)} />
              </div>
            </div>
          </div>
        ))}

        {/* Calls */}
        <div style={{ ...S.header, marginTop: 12 }}>
          <span style={{ fontSize: 14 }}>⚡</span> Active Calls
        </div>
        {CALLS.map(c => (
          <div key={c.id} style={S.callCard}>
            <span style={S.callName}>{c.id} {c.name}</span>
            <div style={S.callEndpoint}>{c.endpoint}</div>
          </div>
        ))}
      </div>

      {/* Right Panel — Terminal Stream */}
      <div style={S.terminal} ref={terminalRef}>
        <div style={S.header}>
          <span style={{ fontSize: 14 }}>⊛</span> Neural Terminal Stream
        </div>

        {logs.map(entry => (
          <div key={entry.id} style={S.line(entry.type)}>
            <span style={S.ts}>[{entry.time}]</span>
            <span style={S.src}>{entry.source}:</span>
            <span>{entry.message}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>NEURAL&gt;</span>
          <span style={S.cursor} />
        </div>
      </div>

      <style>{`
        @keyframes blink {
          0%, 50% { opacity: 1; }
          51%, 100% { opacity: 0; }
        }
      `}</style>
    </div>
  );
}
