// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Autonomous Operations Terminal
// Surfaces 430 Autonomous Profiles + Fibonacci Compressor Model
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState, useRef, useEffect, useMemo } from 'react';
import { AUTONOMOUS_PROFILES, getAutonomousSummary } from './goAutonomousOps';
import { FIBONACCI_COMPRESSOR } from './goFibonacciCompressor';
import type { AutonomyLevel } from './types';

const DOMAIN_COLOR = '#4f8';
const PAGE_SIZE = 20;

const AUTONOMY_FILTERS: Array<{ label: string; value: AutonomyLevel | 'ALL' }> = [
  { label: 'All', value: 'ALL' },
  { label: 'Full Auto', value: 'FULL_AUTO' },
  { label: 'Sovereign', value: 'SOVEREIGN' },
  { label: 'Supervised', value: 'SUPERVISED_AUTO' },
  { label: 'Semi-Auto', value: 'SEMI_AUTO' },
];

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
  card: {
    background: 'rgba(10, 20, 40, 0.8)',
    border: `1px solid ${DOMAIN_COLOR}33`,
    borderRadius: 6,
    padding: '10px 12px',
    marginBottom: 8,
  },
  cardName: {
    fontSize: 11,
    fontWeight: 'bold' as const,
    color: '#fff',
    marginBottom: 4,
  },
  cardModel: {
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
  badge: (level: string) => ({
    display: 'inline-block' as const,
    fontSize: 8,
    fontWeight: 'bold' as const,
    padding: '2px 6px',
    borderRadius: 3,
    marginRight: 4,
    color: '#000',
    background:
      level === 'SOVEREIGN' ? '#f4a' :
      level === 'FULL_AUTO' ? DOMAIN_COLOR :
      level === 'SUPERVISED_AUTO' ? '#4af' : '#fa4',
  }),
  tabBar: {
    display: 'flex' as const,
    gap: 0,
    marginBottom: 12,
  },
  tab: (active: boolean) => ({
    flex: 1,
    fontSize: 9,
    fontWeight: 'bold' as const,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.08em',
    padding: '6px 8px',
    border: `1px solid ${DOMAIN_COLOR}33`,
    background: active ? `${DOMAIN_COLOR}22` : 'transparent',
    color: active ? DOMAIN_COLOR : '#5a7a9a',
    cursor: 'pointer' as const,
    textAlign: 'center' as const,
  }),
  filterBar: {
    display: 'flex' as const,
    flexWrap: 'wrap' as const,
    gap: 4,
    marginBottom: 10,
  },
  filterBtn: (active: boolean) => ({
    fontSize: 8,
    padding: '3px 6px',
    borderRadius: 3,
    border: `1px solid ${DOMAIN_COLOR}44`,
    background: active ? `${DOMAIN_COLOR}33` : 'transparent',
    color: active ? DOMAIN_COLOR : '#5a7a9a',
    cursor: 'pointer' as const,
  }),
  pager: {
    display: 'flex' as const,
    justifyContent: 'space-between' as const,
    alignItems: 'center' as const,
    marginTop: 8,
    fontSize: 9,
    color: '#5a7a9a',
  },
  pagerBtn: (enabled: boolean) => ({
    fontSize: 9,
    padding: '3px 8px',
    border: `1px solid ${DOMAIN_COLOR}44`,
    borderRadius: 3,
    background: enabled ? `${DOMAIN_COLOR}22` : 'transparent',
    color: enabled ? DOMAIN_COLOR : '#333',
    cursor: enabled ? 'pointer' as const : 'default' as const,
  }),
  narrative: {
    fontSize: 9,
    color: '#7a9aba',
    lineHeight: 1.4,
    marginBottom: 4,
    overflow: 'hidden' as const,
    textOverflow: 'ellipsis' as const,
    display: '-webkit-box' as const,
    WebkitLineClamp: 2,
    WebkitBoxOrient: 'vertical' as const,
  },
  line: (type: string) => ({
    fontSize: 10,
    lineHeight: 1.7,
    color:
      type === 'SYS' ? '#555' :
      type === 'DATA' ? DOMAIN_COLOR :
      type === 'ALERT' ? '#f44' :
      type === 'HEAD' ? '#fff' : '#6ac',
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
};

function ts(): string {
  const d = new Date();
  return `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}:${String(d.getSeconds()).padStart(2, '0')}`;
}

function truncate(s: string, n: number): string {
  return s.length > n ? s.slice(0, n) + '…' : s;
}

export function AutonomousTerminal() {
  const terminalRef = useRef<HTMLDivElement>(null);
  const [activeTab, setActiveTab] = useState<'profiles' | 'fibonacci'>('profiles');
  const [autonomyFilter, setAutonomyFilter] = useState<AutonomyLevel | 'ALL'>('ALL');
  const [page, setPage] = useState(0);

  const summary = useMemo(() => getAutonomousSummary(), []);

  const filteredProfiles = useMemo(() => {
    if (autonomyFilter === 'ALL') return AUTONOMOUS_PROFILES;
    return AUTONOMOUS_PROFILES.filter(p => p.autonomyLevel === autonomyFilter);
  }, [autonomyFilter]);

  const totalPages = Math.ceil(filteredProfiles.length / PAGE_SIZE);
  const pagedProfiles = filteredProfiles.slice(page * PAGE_SIZE, (page + 1) * PAGE_SIZE);

  // Reset page when filter changes
  useEffect(() => { setPage(0); }, [autonomyFilter]);

  // Terminal lines — built once
  const terminalLines = useMemo(() => {
    const lines: Array<{ type: string; source: string; message: string }> = [];
    const t = ts();

    lines.push({ type: 'SYS', source: 'BOOT', message: '═══ AUTONOMOUS OPERATIONS TERMINAL ═══' });
    lines.push({ type: 'DATA', source: 'STATS', message: `Total profiles: ${summary.total} | Full-Auto: ${summary.fullAuto} | Sovereign: ${summary.sovereign}` });
    lines.push({ type: 'DATA', source: 'STATS', message: `24H-Continuous: ${summary.continuous} | Always-On: ${summary.alwaysOn} | PHI-Cycle: ${summary.phiCycle} | Event-Driven: ${summary.eventDriven}` });
    lines.push({ type: 'SYS', source: 'LOAD', message: '───────────────────────────────────────' });

    // First 50 profiles
    const first50 = AUTONOMOUS_PROFILES.slice(0, 50);
    first50.forEach((p, i) => {
      lines.push({ type: 'HEAD', source: p.modelId, message: `${p.modelName} [${p.autonomyLevel}/${p.runMode}]` });
      lines.push({ type: 'INFO', source: p.modelId, message: `  narrative: ${truncate(p.narrative, 120)}` });
      lines.push({ type: 'INFO', source: p.modelId, message: `  mission: ${truncate(p.mission, 100)}` });
      if (p.scripts.length > 0) {
        lines.push({ type: 'DATA', source: p.modelId, message: `  scripts: ${p.scripts.map(s => s.name).join(', ')}` });
      }
      if (i < 49) {
        lines.push({ type: 'SYS', source: '---', message: '' });
      }
    });

    lines.push({ type: 'SYS', source: 'LOAD', message: '───────────────────────────────────────' });
    lines.push({ type: 'SYS', source: 'FIB', message: '═══ FIBONACCI COMPRESSOR ═══' });
    lines.push({ type: 'HEAD', source: FIBONACCI_COMPRESSOR.id, message: `${FIBONACCI_COMPRESSOR.name} [${FIBONACCI_COMPRESSOR.autonomyLevel}/${FIBONACCI_COMPRESSOR.runMode}]` });
    lines.push({ type: 'INFO', source: FIBONACCI_COMPRESSOR.id, message: `  ${truncate(FIBONACCI_COMPRESSOR.description, 140)}` });
    lines.push({ type: 'DATA', source: FIBONACCI_COMPRESSOR.id, message: `  levels: ${FIBONACCI_COMPRESSOR.compressionLevels.join(' → ')}` });
    lines.push({ type: 'DATA', source: FIBONACCI_COMPRESSOR.id, message: `  wire-targets: ${FIBONACCI_COMPRESSOR.wireTargets.join(', ')}` });
    lines.push({ type: 'DATA', source: FIBONACCI_COMPRESSOR.id, message: `  φ resonance: ${FIBONACCI_COMPRESSOR.phiResonance} | sequence: [${FIBONACCI_COMPRESSOR.fibonacciSequence.join(', ')}]` });
    lines.push({ type: 'DATA', source: FIBONACCI_COMPRESSOR.id, message: `  capabilities: ${FIBONACCI_COMPRESSOR.capabilities.length} | inputs: ${FIBONACCI_COMPRESSOR.inputFormats.join(', ')}` });
    lines.push({ type: 'SYS', source: 'DONE', message: `Loaded ${summary.total} autonomous profiles + Fibonacci compressor` });

    return lines;
  }, [summary]);

  useEffect(() => {
    if (terminalRef.current) {
      terminalRef.current.scrollTop = terminalRef.current.scrollHeight;
    }
  }, [terminalLines]);

  return (
    <div style={S.root}>
      {/* Left Panel */}
      <div style={S.panel}>
        <div style={S.header}>
          <span style={{ fontSize: 14 }}>⚙</span> Autonomous Ops
        </div>

        {/* Tab switcher */}
        <div style={S.tabBar}>
          <button style={S.tab(activeTab === 'profiles')} onClick={() => setActiveTab('profiles')}>
            Autonomous Profiles
          </button>
          <button style={S.tab(activeTab === 'fibonacci')} onClick={() => setActiveTab('fibonacci')}>
            Fibonacci Compressor
          </button>
        </div>

        {activeTab === 'profiles' && (
          <>
            {/* Autonomy filter */}
            <div style={S.filterBar}>
              {AUTONOMY_FILTERS.map(f => (
                <button
                  key={f.value}
                  style={S.filterBtn(autonomyFilter === f.value)}
                  onClick={() => setAutonomyFilter(f.value)}
                >
                  {f.label}
                </button>
              ))}
            </div>

            <div style={{ fontSize: 9, color: '#5a7a9a', marginBottom: 8 }}>
              Showing {filteredProfiles.length} profiles
            </div>

            {/* Profile cards */}
            {pagedProfiles.map(p => (
              <div key={p.modelId} style={S.card}>
                <div style={S.cardName}>{p.modelName}</div>
                <div style={S.cardModel}>{p.modelId}</div>
                <div style={S.narrative}>{p.narrative}</div>
                <div style={{ marginBottom: 4 }}>
                  <span style={S.badge(p.autonomyLevel)}>{p.autonomyLevel}</span>
                  <span style={{ fontSize: 8, color: '#5a7a9a' }}>{p.runMode}</span>
                </div>
                {p.businessStrings.length > 0 && (
                  <ul style={S.capList}>
                    {p.businessStrings.slice(0, 2).map((bs, i) => (
                      <li key={i} style={S.capItem}>▸ {bs.capability}: {bs.value}</li>
                    ))}
                  </ul>
                )}
              </div>
            ))}

            {/* Pagination */}
            {totalPages > 1 && (
              <div style={S.pager}>
                <button
                  style={S.pagerBtn(page > 0)}
                  onClick={() => page > 0 && setPage(page - 1)}
                >
                  ◀ Prev
                </button>
                <span>{page + 1} / {totalPages}</span>
                <button
                  style={S.pagerBtn(page < totalPages - 1)}
                  onClick={() => page < totalPages - 1 && setPage(page + 1)}
                >
                  Next ▶
                </button>
              </div>
            )}
          </>
        )}

        {activeTab === 'fibonacci' && (
          <>
            <div style={S.card}>
              <div style={S.cardName}>{FIBONACCI_COMPRESSOR.name}</div>
              <div style={S.cardModel}>{FIBONACCI_COMPRESSOR.id} — {FIBONACCI_COMPRESSOR.status}</div>
              <div style={S.narrative}>{FIBONACCI_COMPRESSOR.description}</div>
              <div style={{ marginBottom: 4 }}>
                <span style={S.badge(FIBONACCI_COMPRESSOR.autonomyLevel)}>
                  {FIBONACCI_COMPRESSOR.autonomyLevel}
                </span>
                <span style={{ fontSize: 8, color: '#5a7a9a' }}>{FIBONACCI_COMPRESSOR.runMode}</span>
              </div>
            </div>

            {/* Compression Levels */}
            <div style={{ ...S.header, marginTop: 12 }}>
              <span style={{ fontSize: 14 }}>📐</span> Compression Levels
            </div>
            {FIBONACCI_COMPRESSOR.compressionLevels.map(level => (
              <div key={level} style={{ fontSize: 9, color: DOMAIN_COLOR, padding: '3px 0', fontFamily: 'monospace' }}>
                ▸ {level}
              </div>
            ))}

            {/* Wire Targets */}
            <div style={{ ...S.header, marginTop: 12 }}>
              <span style={{ fontSize: 14 }}>⚡</span> Wire Targets
            </div>
            {FIBONACCI_COMPRESSOR.wireTargets.map(target => (
              <div key={target} style={{ fontSize: 9, color: '#6a8aaa', padding: '2px 0', fontFamily: 'monospace' }}>
                → {target}
              </div>
            ))}

            {/* Phi / Fibonacci info */}
            <div style={{ ...S.header, marginTop: 12 }}>
              <span style={{ fontSize: 14 }}>φ</span> Fibonacci Info
            </div>
            <div style={{ fontSize: 9, color: '#7a9aba', lineHeight: 1.6 }}>
              <div>φ Resonance: {FIBONACCI_COMPRESSOR.phiResonance}</div>
              <div>Sequence: [{FIBONACCI_COMPRESSOR.fibonacciSequence.join(', ')}]</div>
              <div>Capabilities: {FIBONACCI_COMPRESSOR.capabilities.length}</div>
              <div>Inputs: {FIBONACCI_COMPRESSOR.inputFormats.join(', ')}</div>
              <div>Outputs: {FIBONACCI_COMPRESSOR.outputFormats.join(', ')}</div>
            </div>
          </>
        )}
      </div>

      {/* Right Panel — Terminal Stream */}
      <div style={S.terminal} ref={terminalRef}>
        <div style={S.header}>
          <span style={{ fontSize: 14 }}>⚙</span> Autonomous Operations Stream
          <span style={{ marginLeft: 'auto', fontSize: 9, color: DOMAIN_COLOR }}>● {summary.total} PROFILES</span>
        </div>

        {terminalLines.map((entry, i) => (
          <div key={i} style={S.line(entry.type)}>
            <span style={S.ts}>[{ts()}]</span>
            <span style={S.src}>{entry.source}:</span>
            <span>{entry.message}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>AUTONOMOUS&gt;</span>
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
