// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Packaging Terminal
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';

const DOMAIN_COLOR = '#a8f';

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
    id: 'PKG-PACKAGING-01',
    name: 'SDK Forge Organism (virtual)',
    model: 'R-MODEL-SDK-FORGE',
    capabilities: [
      'SDK generation',
      'Artifact packaging',
      'Replication',
      'Doctrine compliance',
    ],
    coherence: 0.91,
  },
  {
    id: 'PKG-PACKAGING-02',
    name: 'VZO Operating Organism (virtual)',
    model: 'R-MODEL-VZO-OS',
    capabilities: [
      'Kernel management',
      'Model routing',
      'Doctrine DNS',
      'Identity management',
    ],
    coherence: 0.88,
  },
];

const CALLS = [
  { id: 'V-01', name: 'Packaging Lab State', endpoint: 'get_packaging_lab_state()' },
  { id: 'V-02', name: 'VZO System State', endpoint: 'get_vzo_system_state()' },
  { id: 'V-03', name: 'VOIS Core State', endpoint: 'get_vois_core_state()' },
  { id: 'V-04', name: 'Node Grid State', endpoint: 'get_node_grid_state()' },
];

function ts(): string {
  return new Date().toLocaleTimeString('en-US', { hour12: false });
}

function buildBootMessages(): LogEntry[] {
  const t = ts();
  return [
    { id: 1, time: t, source: 'BOOT', type: 'SYS', message: 'Packaging Terminal v1.0.0 initialized' },
    { id: 2, time: t, source: 'BOOT', type: 'SYS', message: 'SDK Forge Organism linked — 8 packaging divisions loaded' },
    { id: 3, time: t, source: 'BOOT', type: 'SYS', message: 'VZO Operating Organism linked — 12 subsystems ONLINE' },
    { id: 4, time: t, source: 'FORGE', type: 'DATA', message: 'Divisions: Artifact Analysis | SDK Forge | QA Lab | Prototype Workshop' },
    { id: 5, time: t, source: 'FORGE', type: 'DATA', message: 'Divisions: Registry Research | Replication Lab | Cryptography Lab | Doctrine Compliance' },
    { id: 6, time: t, source: 'VZO', type: 'DATA', message: 'VZO kernel: ACTIVE | 12 subsystems nominal | VOIS: 40 agents deployed' },
    { id: 7, time: t, source: 'GRID', type: 'DATA', message: 'Node grid: 540 nodes ONLINE | Mesh integrity: 99.2%' },
    { id: 8, time: t, source: 'FORGE', type: 'ALERT', message: 'All packaging pipelines verified — artifact replication READY' },
  ];
}

function generateLogEntry(id: number): LogEntry {
  const sources = ['FORGE', 'VZO', 'VOIS', 'GRID', 'SYSTEM'];
  const source = sources[Math.floor(Math.random() * sources.length)];
  const divisions = ['Artifact Analysis', 'SDK Forge', 'QA Lab', 'Prototype Workshop', 'Registry Research', 'Replication Lab', 'Cryptography Lab', 'Doctrine Compliance'];
  const entries: Record<string, string[]> = {
    FORGE: [
      `${divisions[Math.floor(Math.random() * divisions.length)]} — cycle #${(id * 17) % 999} — output ${(90 + Math.random() * 9).toFixed(1)}%`,
      `SDK artifact build #${Math.floor(Math.random() * 9000 + 1000)} — ${Math.random() > 0.2 ? 'PASSED' : 'REVALIDATING'}`,
      `Replication index: ${(0.95 + Math.random() * 0.04).toFixed(3)} — doctrine compliance: VERIFIED`,
    ],
    VZO: [
      `VZO subsystem ${Math.floor(Math.random() * 12) + 1}/12 — health ${(95 + Math.random() * 4).toFixed(1)}%`,
      `Kernel routing cycle — ${Math.floor(Math.random() * 50 + 10)} model requests dispatched`,
      `Doctrine DNS resolve — ${Math.floor(Math.random() * 200 + 50)} lookups/s — cache hit ${(85 + Math.random() * 14).toFixed(0)}%`,
    ],
    VOIS: [
      `VOIS agent pool: ${Math.floor(Math.random() * 5 + 38)}/40 active — task queue ${Math.floor(Math.random() * 30 + 5)} pending`,
      `Agent #${Math.floor(Math.random() * 40) + 1} output — confidence ${(0.85 + Math.random() * 0.14).toFixed(3)}`,
      `Voice synthesis cycle — ${Math.floor(Math.random() * 20 + 5)} channels active`,
    ],
    GRID: [
      `Node grid pulse — ${Math.floor(Math.random() * 10 + 535)}/540 nodes responsive`,
      `Mesh integrity: ${(98 + Math.random() * 2).toFixed(1)}% — ${Math.floor(Math.random() * 3)} nodes rebalancing`,
      `Grid throughput: ${(Math.random() * 50 + 150).toFixed(0)} Gbps — load ${(Math.random() * 40 + 30).toFixed(0)}%`,
    ],
    SYSTEM: [
      `Heartbeat OK — latency ${(Math.random() * 5 + 1).toFixed(1)}ms`,
      `Packaging subsystem coherence: ${(0.86 + Math.random() * 0.12).toFixed(3)}`,
    ],
  };
  const pool = entries[source];
  const message = pool[Math.floor(Math.random() * pool.length)];
  const type = source === 'SYSTEM' ? 'SYS' : Math.random() > 0.9 ? 'ALERT' : 'DATA';
  return { id, time: ts(), source, type, message };
}

export function PackagingTerminal() {
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
          <span style={{ fontSize: 14 }}>▣</span> Packaging Packages
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
          <span style={{ fontSize: 14 }}>▣</span> Packaging Terminal Stream
        </div>

        {logs.map(entry => (
          <div key={entry.id} style={S.line(entry.type)}>
            <span style={S.ts}>[{entry.time}]</span>
            <span style={S.src}>{entry.source}:</span>
            <span>{entry.message}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>PACKAGING&gt;</span>
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
