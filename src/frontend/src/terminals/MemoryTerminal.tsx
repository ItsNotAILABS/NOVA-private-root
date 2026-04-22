// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Memory Terminal
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';

const DOMAIN_COLOR = '#a4f';

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
    id: 'PKG-04',
    name: 'Memory Temple Organism',
    model: 'nova-temple-v4.2',
    capabilities: [
      'Hierarchical memory graph',
      'Consolidation scheduling',
      'Lineage depth tracking',
      'No-drop persistence guarantee',
    ],
    coherence: 0.96,
  },
  {
    id: 'PKG-05',
    name: 'Memory Palace Navigator',
    model: 'nova-palace-v3.0',
    capabilities: [
      'Spatial coordinate mapping',
      'Associative recall pathways',
      'Palace room indexing',
      'Cross-reference linking',
    ],
    coherence: 0.89,
  },
];

const CALLS = [
  { id: 'C-05', name: 'Memory Temple State', endpoint: 'get_memory_temple_state()' },
  { id: 'C-06', name: 'Memory System State', endpoint: 'get_memory_system_state()' },
  { id: 'C-07', name: 'Memory State', endpoint: 'get_memory_state()' },
];

function ts(): string {
  return new Date().toLocaleTimeString('en-US', { hour12: false });
}

function buildBootMessages(): LogEntry[] {
  const t = ts();
  return [
    { id: 1, time: t, source: 'BOOT', type: 'SYS', message: 'Memory Terminal v1.0.0 initialized' },
    { id: 2, time: t, source: 'BOOT', type: 'SYS', message: 'Memory Temple Organism linked — graph loaded' },
    { id: 3, time: t, source: 'BOOT', type: 'SYS', message: 'Memory Palace Navigator linked — coordinates synced' },
    { id: 4, time: t, source: 'TEMPLE', type: 'DATA', message: 'Memory graph nodes: 14,892 | Edges: 48,210 | Depth: 7' },
    { id: 5, time: t, source: 'TEMPLE', type: 'DATA', message: 'Consolidation metrics — ratio: 0.943 | pending: 23 shards' },
    { id: 6, time: t, source: 'PALACE', type: 'DATA', message: 'Palace coordinates: (Φ:42.1, Θ:18.7, Ψ:91.3) — room 7F active' },
    { id: 7, time: t, source: 'TEMPLE', type: 'DATA', message: 'Lineage depth: 7 | No-drop status: ENFORCED' },
    { id: 8, time: t, source: 'SYSTEM', type: 'SYS', message: 'All memory subsystems nominal — persistence guaranteed' },
  ];
}

function generateLogEntry(id: number): LogEntry {
  const sources = ['TEMPLE', 'PALACE', 'SYSTEM'];
  const source = sources[Math.floor(Math.random() * sources.length)];
  const entries: Record<string, string[]> = {
    TEMPLE: [
      `Consolidation cycle #${(id * 13) % 999} — merged ${Math.floor(Math.random() * 50 + 5)} fragments`,
      `Graph node added — id:N-${(id * 37) % 99999} | edges: ${Math.floor(Math.random() * 8 + 1)}`,
      `Lineage depth: ${Math.floor(Math.random() * 3 + 6)} | no-drop: ACTIVE`,
      `Memory shard ${String(Math.floor(Math.random() * 999)).padStart(3, '0')} — integrity ${(97 + Math.random() * 2.9).toFixed(1)}%`,
    ],
    PALACE: [
      `Navigator moved to room ${String.fromCharCode(65 + Math.floor(Math.random() * 8))}${Math.floor(Math.random() * 9) + 1} — ${Math.floor(Math.random() * 40 + 5)} associations`,
      `Coordinate update: (Φ:${(Math.random() * 90).toFixed(1)}, Θ:${(Math.random() * 90).toFixed(1)}, Ψ:${(Math.random() * 180).toFixed(1)})`,
      `Cross-reference link established — pathway strength ${(0.7 + Math.random() * 0.29).toFixed(3)}`,
      `Recall query resolved — latency ${(Math.random() * 8 + 1).toFixed(1)}ms | hits: ${Math.floor(Math.random() * 12 + 1)}`,
    ],
    SYSTEM: [
      `Heartbeat OK — memory subsystem latency ${(Math.random() * 3 + 0.5).toFixed(1)}ms`,
      `Memory coherence index: ${(0.90 + Math.random() * 0.09).toFixed(3)}`,
    ],
  };
  const pool = entries[source];
  const message = pool[Math.floor(Math.random() * pool.length)];
  const type = source === 'SYSTEM' ? 'SYS' : Math.random() > 0.95 ? 'ALERT' : 'DATA';
  return { id, time: ts(), source, type, message };
}

export function MemoryTerminal() {
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
    }, 2400);
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
          <span style={{ fontSize: 14 }}>◈</span> Memory Packages
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
          <span style={{ fontSize: 14 }}>◈</span> Memory Terminal Stream
        </div>

        {logs.map(entry => (
          <div key={entry.id} style={S.line(entry.type)}>
            <span style={S.ts}>[{entry.time}]</span>
            <span style={S.src}>{entry.source}:</span>
            <span>{entry.message}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>MEMORY&gt;</span>
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
