// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Intelligence Terminal
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';

const DOMAIN_COLOR = '#4ff';

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
    id: 'PKG-29',
    name: 'Internal AI Workforce Organism',
    model: 'R-MODEL-AUTONOMOUS-ANALYST',
    capabilities: [
      'Team orchestration',
      'Task management',
      'Output quality control',
      'Workforce health monitoring',
    ],
    coherence: 0.93,
  },
];

const CALLS = [
  { id: 'C-38', name: 'Autonomous Team Status', endpoint: 'get_autonomous_team_status()' },
  { id: 'C-39', name: 'Organism Teams State', endpoint: 'get_organism_teams_state()' },
];

function ts(): string {
  return new Date().toLocaleTimeString('en-US', { hour12: false });
}

function buildBootMessages(): LogEntry[] {
  const t = ts();
  return [
    { id: 1, time: t, source: 'BOOT', type: 'SYS', message: 'Intelligence Terminal v1.0.0 initialized' },
    { id: 2, time: t, source: 'BOOT', type: 'SYS', message: 'Internal AI Workforce Organism linked — analyst teams DEPLOYED' },
    { id: 3, time: t, source: 'WORKFORCE', type: 'DATA', message: 'Internal AI analyst teams: ACTIVE | Task queues: PROCESSING' },
    { id: 4, time: t, source: 'WORKFORCE', type: 'DATA', message: 'Workforce health: NOMINAL | Active agents: 24 | Idle: 4' },
    { id: 5, time: t, source: 'ANALYST', type: 'DATA', message: 'Output confidence: 94.7% | Quality gate: PASSING' },
    { id: 6, time: t, source: 'ANALYST', type: 'DATA', message: 'Team roster: Alpha, Beta, Gamma, Delta, Epsilon — all reporting' },
    { id: 7, time: t, source: 'WORKFORCE', type: 'DATA', message: 'Task queue depth: 17 pending | 342 completed today | 0 failed' },
    { id: 8, time: t, source: 'ANALYST', type: 'ALERT', message: 'Workforce health check complete — all teams operational' },
  ];
}

function generateLogEntry(id: number): LogEntry {
  const sources = ['WORKFORCE', 'ANALYST', 'TASKQ', 'SYSTEM'];
  const source = sources[Math.floor(Math.random() * sources.length)];
  const teams = ['Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon'];
  const entries: Record<string, string[]> = {
    WORKFORCE: [
      `Workforce pulse — ${Math.floor(Math.random() * 6 + 22)}/28 agents active — health ${(92 + Math.random() * 7).toFixed(1)}%`,
      `Agent rotation cycle #${(id * 17) % 999} — ${Math.floor(Math.random() * 3)} agents recycled`,
      `Workforce capacity: ${(Math.random() * 20 + 75).toFixed(0)}% utilized — scaling ${Math.random() > 0.7 ? 'UP' : 'STABLE'}`,
    ],
    ANALYST: [
      `Team ${teams[Math.floor(Math.random() * teams.length)]} — output confidence ${(0.88 + Math.random() * 0.11).toFixed(3)}`,
      `Quality control pass #${(id * 31) % 500} — ${Math.random() > 0.15 ? 'APPROVED' : 'UNDER REVIEW'}`,
      `Team roster check — ${Math.floor(Math.random() * 5 + 1)} teams reporting — all healthy`,
    ],
    TASKQ: [
      `Task queue: ${Math.floor(Math.random() * 25 + 5)} pending | ${Math.floor(Math.random() * 100 + 300)} completed | ${Math.floor(Math.random() * 2)} failed`,
      `Priority dispatch — task #${Math.floor(Math.random() * 9000 + 1000)} assigned to Team ${teams[Math.floor(Math.random() * teams.length)]}`,
      `Queue throughput: ${(Math.random() * 5 + 8).toFixed(1)} tasks/min — avg latency ${(Math.random() * 200 + 50).toFixed(0)}ms`,
    ],
    SYSTEM: [
      `Heartbeat OK — latency ${(Math.random() * 5 + 1).toFixed(1)}ms`,
      `Intelligence subsystem coherence: ${(0.90 + Math.random() * 0.08).toFixed(3)}`,
    ],
  };
  const pool = entries[source];
  const message = pool[Math.floor(Math.random() * pool.length)];
  const type = source === 'SYSTEM' ? 'SYS' : Math.random() > 0.9 ? 'ALERT' : 'DATA';
  return { id, time: ts(), source, type, message };
}

export function IntelligenceTerminal() {
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
          <span style={{ fontSize: 14 }}>◉</span> Intelligence Packages
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
          <span style={{ fontSize: 14 }}>◉</span> Intelligence Terminal Stream
        </div>

        {logs.map(entry => (
          <div key={entry.id} style={S.line(entry.type)}>
            <span style={S.ts}>[{entry.time}]</span>
            <span style={S.src}>{entry.source}:</span>
            <span>{entry.message}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>INTELLIGENCE&gt;</span>
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
