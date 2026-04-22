// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Sensor Terminal
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';

const DOMAIN_COLOR = '#af4';

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
    id: 'PKG-21',
    name: 'World Organism Bridge',
    model: 'R-MODEL-WORLD-ORGANISM-BRIDGE',
    capabilities: [
      'ecological-sensing',
      'world-integration',
      'environmental-coupling',
      'field-coherence-monitoring',
    ],
    coherence: 0.91,
  },
  {
    id: 'PKG-22',
    name: 'Health Monitor Organism',
    model: 'R-MODEL-HEALTH-MONITOR',
    capabilities: [
      'vital-monitoring',
      'subsystem-health',
      'anomaly-detection',
      'recovery-management',
    ],
    coherence: 0.95,
  },
];

const CALLS = [
  { id: 'C-27', name: 'Ecological State', endpoint: 'get_ecological_state()' },
  { id: 'C-28', name: 'Organism Health Report', endpoint: 'get_organism_health_report()' },
];

function ts(): string {
  return new Date().toLocaleTimeString('en-US', { hour12: false });
}

function buildBootMessages(): LogEntry[] {
  const t = ts();
  return [
    { id: 1, time: t, source: 'BOOT', type: 'SYS', message: 'Sensor Terminal v1.0.0 initialized' },
    { id: 2, time: t, source: 'BOOT', type: 'SYS', message: 'Field scanner online — ecological coupling active' },
    { id: 3, time: t, source: 'BOOT', type: 'SYS', message: 'IoT device mesh linked — 256 sensors registered' },
    { id: 4, time: t, source: 'BOOT', type: 'SYS', message: 'Hybrid hub initialized — world-organism bridge established' },
    { id: 5, time: t, source: 'WORLD', type: 'DATA', message: 'Ecological coupling: 0.947 | Field coherence: NOMINAL | Sensors: ACTIVE' },
    { id: 6, time: t, source: 'HEALTH', type: 'DATA', message: 'Vital signs: ALL GREEN | Subsystems: 12/12 healthy | Anomalies: 0' },
    { id: 7, time: t, source: 'WORLD', type: 'DATA', message: 'Environmental integration: 98.3% | IoT devices: 256 online' },
    { id: 8, time: t, source: 'HEALTH', type: 'DATA', message: 'Recovery protocols: STANDBY | Vital monitoring frequency: 100Hz' },
  ];
}

function generateLogEntry(id: number): LogEntry {
  const sources = ['WORLD', 'HEALTH', 'SENSOR', 'SYSTEM'];
  const source = sources[Math.floor(Math.random() * sources.length)];
  const entries: Record<string, string[]> = {
    WORLD: [
      `Ecological scan #${(id * 17) % 999} — field coherence ${(0.93 + Math.random() * 0.06).toFixed(4)}`,
      `Environmental coupling pulse — ${Math.floor(Math.random() * 8) + 1} biomes synchronized`,
      `World integration update — ${Math.floor(Math.random() * 256)} IoT sensors polled — ${Math.random() > 0.1 ? 'ALL OK' : 'DRIFT DETECTED'}`,
    ],
    HEALTH: [
      `Vital monitoring — subsystem ${Math.floor(Math.random() * 12) + 1}/12 — status ${Math.random() > 0.1 ? 'HEALTHY' : 'DEGRADED'}`,
      `Anomaly detection sweep — ${Math.floor(Math.random() * 3)} anomalies flagged — severity ${Math.random() > 0.7 ? 'LOW' : 'NONE'}`,
      `Recovery readiness: ${(97 + Math.random() * 2.5).toFixed(1)}% — MTTR ${(Math.random() * 5 + 1).toFixed(1)}s`,
    ],
    SENSOR: [
      `IoT device S-${String(Math.floor(Math.random() * 256) + 1).padStart(3, '0')} heartbeat — signal ${(Math.random() * 10 + 90).toFixed(1)}%`,
      `Hybrid hub throughput: ${(Math.random() * 500 + 200).toFixed(0)} msg/s — buffer ${Math.random() > 0.2 ? 'CLEAR' : 'FILLING'}`,
      `Field scanner sweep — sector ${Math.floor(Math.random() * 16) + 1} — ${Math.random() > 0.3 ? 'NOMINAL' : 'ATTENTION'}`,
    ],
    SYSTEM: [
      `Heartbeat OK — latency ${(Math.random() * 5 + 1).toFixed(1)}ms`,
      `Sensor subsystem coherence: ${(0.88 + Math.random() * 0.1).toFixed(3)}`,
    ],
  };
  const pool = entries[source];
  const message = pool[Math.floor(Math.random() * pool.length)];
  const type = source === 'SYSTEM' ? 'SYS' : Math.random() > 0.9 ? 'ALERT' : 'DATA';
  return { id, time: ts(), source, type, message };
}

export function SensorTerminal() {
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
          <span style={{ fontSize: 14 }}>◎</span> Sensor Packages
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
          <span style={{ fontSize: 14 }}>◎</span> Sensor Terminal Stream
        </div>

        {logs.map(entry => (
          <div key={entry.id} style={S.line(entry.type)}>
            <span style={S.ts}>[{entry.time}]</span>
            <span style={S.src}>{entry.source}:</span>
            <span>{entry.message}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>SENSOR&gt;</span>
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
