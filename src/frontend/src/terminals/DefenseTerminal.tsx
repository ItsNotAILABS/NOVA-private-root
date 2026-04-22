// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Defense Terminal
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';

const DOMAIN_COLOR = '#f44';

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
    id: 'PKG-01',
    name: 'AEGIS Shield Organism',
    model: 'nova-defense-v3.1',
    capabilities: [
      'Perimeter shield modulation',
      'Threat vector analysis',
      'Adaptive barrier generation',
      'Energy redistribution',
    ],
    coherence: 0.94,
  },
  {
    id: 'PKG-02',
    name: 'War Command Organism',
    model: 'nova-warcom-v2.8',
    capabilities: [
      'Mission orchestration',
      'Tactical offense/defense switching',
      'Resource allocation under fire',
      'Multi-front coordination',
    ],
    coherence: 0.87,
  },
  {
    id: 'PKG-03',
    name: 'Counterforce Intelligence Organism',
    model: 'nova-cfi-v1.5',
    capabilities: [
      'Scout deployment & tracking',
      'Trap network management',
      'Hunter unit dispatch',
      'Intelligence synthesis',
    ],
    coherence: 0.91,
  },
];

const CALLS = [
  { id: 'C-01', name: 'AEGIS State', endpoint: 'get_aegis_state()' },
  { id: 'C-02', name: 'War Defense Mode', endpoint: 'get_war_defense_mode()' },
  { id: 'C-03', name: 'Counterforce Status', endpoint: 'get_counterforce_status()' },
  { id: 'C-04', name: 'Offense Defense Status', endpoint: 'get_offense_defense_status()' },
];

function ts(): string {
  return new Date().toLocaleTimeString('en-US', { hour12: false });
}

function buildBootMessages(): LogEntry[] {
  const t = ts();
  return [
    { id: 1, time: t, source: 'BOOT', type: 'SYS', message: 'Defense Terminal v1.0.0 initialized' },
    { id: 2, time: t, source: 'BOOT', type: 'SYS', message: 'AEGIS Shield Organism linked — perimeter online' },
    { id: 3, time: t, source: 'BOOT', type: 'SYS', message: 'War Command Organism linked — defense posture ACTIVE' },
    { id: 4, time: t, source: 'BOOT', type: 'SYS', message: 'Counterforce Intelligence Organism linked — scouts deployed' },
    { id: 5, time: t, source: 'AEGIS', type: 'DATA', message: 'Shield status: NOMINAL | Barrier strength: 97.3%' },
    { id: 6, time: t, source: 'WARCOM', type: 'DATA', message: 'Defense posture: ELEVATED | Threat level: AMBER' },
    { id: 7, time: t, source: 'CFI', type: 'DATA', message: 'Active missions: 4 | Scouts: 12 | Traps: 8 | Hunters: 3' },
    { id: 8, time: t, source: 'AEGIS', type: 'ALERT', message: 'Perimeter breach attempt — sector 7G — REPELLED' },
  ];
}

function generateLogEntry(id: number): LogEntry {
  const sources = ['AEGIS', 'WARCOM', 'CFI', 'SYSTEM'];
  const source = sources[Math.floor(Math.random() * sources.length)];
  const entries: Record<string, string[]> = {
    AEGIS: [
      `Shield modulation cycle #${(id * 17) % 999} complete — efficiency ${(92 + Math.random() * 7).toFixed(1)}%`,
      `Barrier sector ${Math.floor(Math.random() * 12) + 1} reinforced — energy draw ${(Math.random() * 40 + 10).toFixed(0)} TW`,
      `Threat vector scan — ${Math.floor(Math.random() * 3)} anomalies detected`,
    ],
    WARCOM: [
      `Offense/defense ratio: ${(Math.random() * 0.4 + 0.3).toFixed(2)} — posture stable`,
      `Mission #${(id * 31) % 500} status: ${Math.random() > 0.3 ? 'GREEN' : 'AMBER'}`,
      `Resource reallocation — ${Math.floor(Math.random() * 20 + 5)} units repositioned`,
    ],
    CFI: [
      `Scout unit S-${String(Math.floor(Math.random() * 99) + 1).padStart(2, '0')} reporting — sector clear`,
      `Trap network integrity: ${(95 + Math.random() * 4).toFixed(1)}% — ${Math.floor(Math.random() * 3)} triggers armed`,
      `Hunter pack H-${Math.floor(Math.random() * 5) + 1} — pursuit vector locked`,
    ],
    SYSTEM: [
      `Heartbeat OK — latency ${(Math.random() * 5 + 1).toFixed(1)}ms`,
      `Defense subsystem coherence: ${(0.88 + Math.random() * 0.1).toFixed(3)}`,
    ],
  };
  const pool = entries[source];
  const message = pool[Math.floor(Math.random() * pool.length)];
  const type = source === 'SYSTEM' ? 'SYS' : Math.random() > 0.9 ? 'ALERT' : 'DATA';
  return { id, time: ts(), source, type, message };
}

export function DefenseTerminal() {
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
          <span style={{ fontSize: 14 }}>⛊</span> Defense Packages
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
          <span style={{ fontSize: 14 }}>⛊</span> Defense Terminal Stream
        </div>

        {logs.map(entry => (
          <div key={entry.id} style={S.line(entry.type)}>
            <span style={S.ts}>[{entry.time}]</span>
            <span style={S.src}>{entry.source}:</span>
            <span>{entry.message}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>DEFENSE&gt;</span>
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
