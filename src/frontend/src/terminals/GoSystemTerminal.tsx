// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — GO System Terminal
// Static registry surface: 80 AI models, 50 MCP servers, 100 scrapers, 50 workflows
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';
import { GO_MODELS } from './goModels';
import { GO_SYSTEM } from './goSystem';
import { GO_MCP_SERVERS } from './goMcpServers';
import { GO_SCRAPERS, GO_WORKFLOWS } from './goMarketplace';

const DOMAIN_COLOR = '#0af';

type Tab = 'Models' | 'MCP Servers' | 'Scrapers' | 'Workflows';
const TABS: Tab[] = ['Models', 'MCP Servers', 'Scrapers', 'Workflows'];

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
    width: `${Math.min(value, 1) * 100}%`,
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
  tabRow: {
    display: 'flex' as const,
    gap: 4,
    marginBottom: 10,
  },
  tab: (active: boolean) => ({
    fontSize: 9,
    padding: '4px 8px',
    border: `1px solid ${active ? DOMAIN_COLOR : DOMAIN_COLOR + '33'}`,
    borderRadius: 4,
    background: active ? DOMAIN_COLOR + '22' : 'transparent',
    color: active ? DOMAIN_COLOR : '#5a7a9a',
    cursor: 'pointer' as const,
    fontWeight: (active ? 'bold' : 'normal') as 'bold' | 'normal',
  }),
};

function buildTerminalLines() {
  const lines: { id: string; type: string; source: string; message: string }[] = [];
  let idx = 0;
  const push = (type: string, source: string, message: string) => {
    lines.push({ id: `go-${idx++}`, type, source, message });
  };

  push('SYS', 'BOOT', '═══ GO SYSTEM TERMINAL INITIALIZED ═══');
  push('DATA', 'COMPANY', `${GO_SYSTEM.fullName}`);
  push('DATA', 'COMPANY', `Tier: ${GO_SYSTEM.tier} | Divisions: ${GO_SYSTEM.divisions.length}`);
  push('SYS', 'REGISTRY', `Loading ${GO_MODELS.length} AI models...`);

  for (const m of GO_MODELS) {
    push('INFO', m.family, `[${m.id}] ${m.name} — ${m.description}`);
  }

  push('SYS', 'REGISTRY', `Loading ${GO_MCP_SERVERS.length} MCP servers...`);
  for (const s of GO_MCP_SERVERS) {
    push('DATA', 'MCP', `[${s.id}] ${s.name} (${s.transport}) — ${s.description}`);
  }

  push('SYS', 'REGISTRY', `Loading ${GO_SCRAPERS.length} scrapers...`);
  for (const sc of GO_SCRAPERS) {
    push('INFO', 'SCRAPER', `[${sc.id}] ${sc.name} — ${sc.category}`);
  }

  push('SYS', 'REGISTRY', `Loading ${GO_WORKFLOWS.length} workflows...`);
  for (const w of GO_WORKFLOWS) {
    push('INFO', 'WORKFLOW', `[${w.id}] ${w.name} — ${w.type} (${w.schedule})`);
  }

  push('SYS', 'BOOT', '═══ ALL REGISTRIES LOADED ═══');
  return lines;
}

export function GoSystemTerminal() {
  const terminalRef = useRef<HTMLDivElement>(null);
  const [activeTab, setActiveTab] = useState<Tab>('Models');
  const [lines] = useState(buildTerminalLines);

  useEffect(() => {
    if (terminalRef.current) {
      terminalRef.current.scrollTop = terminalRef.current.scrollHeight;
    }
  }, [lines]);

  return (
    <div style={S.root}>
      {/* Left Panel — Registry Cards */}
      <div style={S.panel}>
        <div style={S.header}>
          <span style={{ fontSize: 14 }}>⚙</span> GO System Registry
        </div>

        {/* Tab switcher */}
        <div style={S.tabRow}>
          {TABS.map(t => (
            <div key={t} style={S.tab(t === activeTab)} onClick={() => setActiveTab(t)}>
              {t}
            </div>
          ))}
        </div>

        {/* Models tab */}
        {activeTab === 'Models' && GO_MODELS.map(m => (
          <div key={m.id} style={S.packageCard}>
            <div style={S.packageName}>{m.name}</div>
            <div style={S.packageModel}>{m.id} — {m.family}</div>
            <div style={{ fontSize: 9, color: '#8aa', marginBottom: 6 }}>{m.description}</div>
            <ul style={S.capList}>
              {m.capabilities.slice(0, 4).map((cap, i) => (
                <li key={i} style={S.capItem}>▸ {cap}</li>
              ))}
            </ul>
            <div style={S.metric}>
              <span style={S.metricLabel}>Capabilities</span>
              <div style={S.metricBar}>
                <div style={S.metricFill(m.capabilities.length / 6)} />
              </div>
            </div>
          </div>
        ))}

        {/* MCP Servers tab */}
        {activeTab === 'MCP Servers' && GO_MCP_SERVERS.map(s => (
          <div key={s.id} style={S.packageCard}>
            <div style={S.packageName}>{s.name}</div>
            <div style={S.packageModel}>{s.id} — {s.transport}</div>
            <div style={{ fontSize: 9, color: '#8aa', marginBottom: 6 }}>{s.description}</div>
            <ul style={S.capList}>
              {s.capabilities.slice(0, 4).map((cap, i) => (
                <li key={i} style={S.capItem}>▸ {cap}</li>
              ))}
            </ul>
            <div style={S.metric}>
              <span style={S.metricLabel}>Commands</span>
              <div style={S.metricBar}>
                <div style={S.metricFill(s.commands.length / 10)} />
              </div>
            </div>
          </div>
        ))}

        {/* Scrapers tab */}
        {activeTab === 'Scrapers' && GO_SCRAPERS.map(sc => (
          <div key={sc.id} style={S.packageCard}>
            <div style={S.packageName}>{sc.name}</div>
            <div style={S.packageModel}>{sc.id} — {sc.category}</div>
            <div style={{ fontSize: 9, color: '#8aa', marginBottom: 6 }}>{sc.description}</div>
            <ul style={S.capList}>
              {sc.capabilities.slice(0, 4).map((cap, i) => (
                <li key={i} style={S.capItem}>▸ {cap}</li>
              ))}
            </ul>
            <div style={S.metric}>
              <span style={S.metricLabel}>Sources</span>
              <div style={S.metricBar}>
                <div style={S.metricFill(sc.targetSources.length / 4)} />
              </div>
            </div>
          </div>
        ))}

        {/* Workflows tab */}
        {activeTab === 'Workflows' && GO_WORKFLOWS.map(w => (
          <div key={w.id} style={S.packageCard}>
            <div style={S.packageName}>{w.name}</div>
            <div style={S.packageModel}>{w.id} — {w.type}</div>
            <div style={{ fontSize: 9, color: '#8aa', marginBottom: 6 }}>{w.description}</div>
            <ul style={S.capList}>
              {w.steps.slice(0, 4).map((step, i) => (
                <li key={i} style={S.capItem}>▸ {step}</li>
              ))}
            </ul>
            <div style={S.metric}>
              <span style={S.metricLabel}>Schedule</span>
              <span style={{ fontSize: 8, color: DOMAIN_COLOR, fontFamily: 'monospace' }}>{w.schedule}</span>
            </div>
          </div>
        ))}
      </div>

      {/* Right Panel — Terminal Stream */}
      <div style={S.terminal} ref={terminalRef}>
        <div style={S.header}>
          <span style={{ fontSize: 14 }}>⚙</span> GO System Terminal Stream
          <span style={{ marginLeft: 'auto', fontSize: 9, color: '#4f4' }}>● REGISTRY</span>
        </div>

        {lines.map(entry => (
          <div key={entry.id} style={S.line(entry.type)}>
            <span style={S.ts}>[GO]</span>
            <span style={S.src}>{entry.source}:</span>
            <span>{entry.message}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>GO&gt;</span>
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
