// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Governance Terminal
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';

const DOMAIN_COLOR = '#fa4';

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
    id: 'PKG-06',
    name: 'Law Enforcement Organism',
    model: 'nova-lawenf-v2.4',
    capabilities: [
      'Law compliance scoring',
      'Compliance vector computation',
      'Gate status enforcement',
      'Violation detection & response',
    ],
    coherence: 0.92,
  },
  {
    id: 'PKG-07',
    name: 'Security Audit Organism',
    model: 'nova-secaudit-v1.9',
    capabilities: [
      'Exposure surface audit',
      'Incident counting & triage',
      'Continuous security scoring',
      'Regulatory alignment check',
    ],
    coherence: 0.88,
  },
];

const CALLS = [
  { id: 'C-08', name: 'Law Compliance', endpoint: 'get_law_compliance()' },
  { id: 'C-09', name: 'Laws Snapshot', endpoint: 'get_laws_snapshot()' },
  { id: 'C-10', name: 'Security Status', endpoint: 'get_security_status()' },
];

function ts(): string {
  return new Date().toLocaleTimeString('en-US', { hour12: false });
}

function buildBootMessages(): LogEntry[] {
  const t = ts();
  return [
    { id: 1, time: t, source: 'BOOT', type: 'SYS', message: 'Governance Terminal v1.0.0 initialized' },
    { id: 2, time: t, source: 'BOOT', type: 'SYS', message: 'Law Enforcement Organism linked — compliance engine online' },
    { id: 3, time: t, source: 'BOOT', type: 'SYS', message: 'Security Audit Organism linked — audit loop active' },
    { id: 4, time: t, source: 'LAWENF', type: 'DATA', message: 'Law scores: [L1: 0.98, L2: 0.95, L3: 0.97, L4: 0.93, L5: 0.99]' },
    { id: 5, time: t, source: 'LAWENF', type: 'DATA', message: 'Compliance vector: <0.97, 0.94, 0.96> — gate status: ALL OPEN' },
    { id: 6, time: t, source: 'SECAUD', type: 'DATA', message: 'Exposure audit: 0 critical | 2 medium | 5 low findings' },
    { id: 7, time: t, source: 'SECAUD', type: 'DATA', message: 'Incident count: 0 active | 14 resolved (last 24h)' },
    { id: 8, time: t, source: 'SYSTEM', type: 'SYS', message: 'Governance subsystems nominal — all gates enforced' },
  ];
}

function generateLogEntry(id: number): LogEntry {
  const sources = ['LAWENF', 'SECAUD', 'SYSTEM'];
  const source = sources[Math.floor(Math.random() * sources.length)];
  const entries: Record<string, string[]> = {
    LAWENF: [
      `Law compliance scan #${(id * 11) % 999} — aggregate score: ${(0.92 + Math.random() * 0.07).toFixed(3)}`,
      `Gate G-${Math.floor(Math.random() * 8) + 1} status: ${Math.random() > 0.1 ? 'OPEN' : 'RESTRICTED'} — throughput nominal`,
      `Compliance vector update: <${(0.90 + Math.random() * 0.09).toFixed(2)}, ${(0.90 + Math.random() * 0.09).toFixed(2)}, ${(0.90 + Math.random() * 0.09).toFixed(2)}>`,
      `Violation check — ${Math.random() > 0.85 ? '1 minor infraction flagged' : 'no violations detected'}`,
    ],
    SECAUD: [
      `Exposure surface scan — ${Math.floor(Math.random() * 3)} new findings | total: ${Math.floor(Math.random() * 20 + 5)}`,
      `Incident #${(id * 23) % 999} — severity: ${Math.random() > 0.7 ? 'MEDIUM' : 'LOW'} — ${Math.random() > 0.5 ? 'resolved' : 'triaging'}`,
      `Security score: ${(0.88 + Math.random() * 0.11).toFixed(3)} — trend: ${Math.random() > 0.3 ? 'STABLE' : 'IMPROVING'}`,
      `Regulatory alignment: ${(95 + Math.random() * 4.9).toFixed(1)}% — next audit in ${Math.floor(Math.random() * 48 + 1)}h`,
    ],
    SYSTEM: [
      `Heartbeat OK — governance latency ${(Math.random() * 4 + 0.5).toFixed(1)}ms`,
      `Governance coherence: ${(0.89 + Math.random() * 0.1).toFixed(3)}`,
    ],
  };
  const pool = entries[source];
  const message = pool[Math.floor(Math.random() * pool.length)];
  const type = source === 'SYSTEM' ? 'SYS' : Math.random() > 0.92 ? 'ALERT' : 'DATA';
  return { id, time: ts(), source, type, message };
}

export function GovernanceTerminal() {
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
    }, 2600);
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
          <span style={{ fontSize: 14 }}>⚖</span> Governance Packages
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
          <span style={{ fontSize: 14 }}>⚖</span> Governance Terminal Stream
        </div>

        {logs.map(entry => (
          <div key={entry.id} style={S.line(entry.type)}>
            <span style={S.ts}>[{entry.time}]</span>
            <span style={S.src}>{entry.source}:</span>
            <span>{entry.message}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>GOVERNANCE&gt;</span>
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
