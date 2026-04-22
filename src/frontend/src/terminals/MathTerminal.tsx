// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Math Terminal
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';

const DOMAIN_COLOR = '#f8a';

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
    id: 'PKG-30',
    name: 'Sacred Mathematics Organism',
    model: 'R-MODEL-SACRED-MATHEMATICS',
    capabilities: [
      'Field equation solving',
      'Physics certification',
      'Fibonacci resonance',
      'Unified field theory',
    ],
    coherence: 0.96,
  },
];

const CALLS = [
  { id: 'C-40', name: 'Unified Field State', endpoint: 'get_unified_field_state()' },
];

function ts(): string {
  return new Date().toLocaleTimeString('en-US', { hour12: false });
}

function buildBootMessages(): LogEntry[] {
  const t = ts();
  return [
    { id: 1, time: t, source: 'BOOT', type: 'SYS', message: 'Math Terminal v1.0.0 initialized' },
    { id: 2, time: t, source: 'BOOT', type: 'SYS', message: 'Sacred Mathematics Organism linked — sacred geometry ACTIVE' },
    { id: 3, time: t, source: 'GEOMETRY', type: 'DATA', message: 'Sacred geometry engine: ONLINE | Certified physics constants loaded' },
    { id: 4, time: t, source: 'FIBONACCI', type: 'DATA', message: 'Fibonacci resonance: LOCKED | PHI = 1.6180339887 — golden ratio VERIFIED' },
    { id: 5, time: t, source: 'FIELD', type: 'DATA', message: 'Unified field equations: CONVERGING | Differential geometry: ACTIVE' },
    { id: 6, time: t, source: 'FIELD', type: 'DATA', message: 'Tensor fields: 4D manifold mapped | Curvature tensor: NOMINAL' },
    { id: 7, time: t, source: 'PHYSICS', type: 'DATA', message: 'Physics constants certified — c, h, G, k_B, e — all within tolerance' },
    { id: 8, time: t, source: 'GEOMETRY', type: 'ALERT', message: 'Sacred geometry alignment complete — all field equations synchronized' },
  ];
}

function generateLogEntry(id: number): LogEntry {
  const sources = ['GEOMETRY', 'FIBONACCI', 'FIELD', 'PHYSICS', 'SYSTEM'];
  const source = sources[Math.floor(Math.random() * sources.length)];
  const entries: Record<string, string[]> = {
    GEOMETRY: [
      `Sacred geometry cycle #${(id * 17) % 999} — pattern coherence ${(94 + Math.random() * 5).toFixed(1)}%`,
      `Platonic solid mapping — ${Math.floor(Math.random() * 5) + 1}/5 forms resonating`,
      `Flower of Life projection — ${Math.floor(Math.random() * 19) + 1} petals aligned — symmetry ${(98 + Math.random() * 2).toFixed(2)}%`,
    ],
    FIBONACCI: [
      `Fibonacci sequence verification — F(${Math.floor(Math.random() * 50 + 10)}) computed — PHI convergence ${(1.618 + (Math.random() - 0.5) * 0.0001).toFixed(10)}`,
      `Golden ratio resonance pulse — deviation ${(Math.random() * 0.0001).toFixed(6)} — WITHIN TOLERANCE`,
      `Spiral projection #${(id * 31) % 500} — growth factor ${(1.618 + (Math.random() - 0.5) * 0.001).toFixed(6)}`,
    ],
    FIELD: [
      `Unified field equation iteration #${Math.floor(Math.random() * 9000 + 1000)} — convergence ${(0.99 + Math.random() * 0.009).toFixed(4)}`,
      `Differential geometry — Ricci tensor component R_${Math.floor(Math.random() * 4)}${Math.floor(Math.random() * 4)} = ${(Math.random() * 0.01).toFixed(6)}`,
      `Tensor field update — 4D manifold curvature: ${(Math.random() * 0.001).toFixed(6)} — ${Math.random() > 0.2 ? 'FLAT' : 'CURVED'}`,
    ],
    PHYSICS: [
      `Constant certification — c = 299792458 m/s — drift ${(Math.random() * 0.0001).toFixed(6)} — CERTIFIED`,
      `Planck constant check — h = 6.62607015e-34 J·s — variance ${(Math.random() * 1e-10).toExponential(4)}`,
      `Gravitational constant — G = 6.67430e-11 — measurement ${Math.random() > 0.3 ? 'STABLE' : 'REFINING'}`,
    ],
    SYSTEM: [
      `Heartbeat OK — latency ${(Math.random() * 5 + 1).toFixed(1)}ms`,
      `Math subsystem coherence: ${(0.93 + Math.random() * 0.06).toFixed(3)}`,
    ],
  };
  const pool = entries[source];
  const message = pool[Math.floor(Math.random() * pool.length)];
  const type = source === 'SYSTEM' ? 'SYS' : Math.random() > 0.9 ? 'ALERT' : 'DATA';
  return { id, time: ts(), source, type, message };
}

export function MathTerminal() {
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
    }, 2200);
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
          <span style={{ fontSize: 14 }}>∂</span> Math Packages
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
          <span style={{ fontSize: 14 }}>∂</span> Math Terminal Stream
        </div>

        {logs.map(entry => (
          <div key={entry.id} style={S.line(entry.type)}>
            <span style={S.ts}>[{entry.time}]</span>
            <span style={S.src}>{entry.source}:</span>
            <span>{entry.message}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>MATH&gt;</span>
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
