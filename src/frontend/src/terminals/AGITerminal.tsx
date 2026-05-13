// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — AGI Terminal
// Static Enterprise AI/AGI Registry — 250 models + 30 deployment actions
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState, useMemo } from 'react';
import { GO_ENTERPRISE_AI } from './goEnterprise';
import { GO_DEPLOYMENT_ACTIONS } from './goDeployment';

const DOMAIN_COLOR = '#f0a';

type Tab = 'enterprise' | 'deployment';

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
  tabBar: {
    display: 'flex' as const,
    gap: 4,
    marginBottom: 12,
  },
  tab: (active: boolean) => ({
    flex: 1,
    padding: '6px 8px',
    fontSize: 9,
    fontWeight: 'bold' as const,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.08em',
    color: active ? '#fff' : '#5a7a9a',
    background: active ? `${DOMAIN_COLOR}22` : 'transparent',
    border: `1px solid ${active ? DOMAIN_COLOR : DOMAIN_COLOR + '33'}`,
    borderRadius: 4,
    cursor: 'pointer' as const,
    textAlign: 'center' as const,
  }),
  familyHeader: {
    fontSize: 9,
    color: DOMAIN_COLOR,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
    padding: '8px 0 4px',
    borderBottom: `1px solid ${DOMAIN_COLOR}22`,
    marginBottom: 6,
    marginTop: 8,
  },
  tierBadge: (tier: string) => ({
    display: 'inline-block' as const,
    fontSize: 8,
    fontWeight: 'bold' as const,
    padding: '1px 5px',
    borderRadius: 3,
    marginLeft: 6,
    background: tier === 'SUPER_AI' ? '#f0a3' : tier === 'AGI' ? '#a0f3' : '#0af3',
    color: tier === 'SUPER_AI' ? '#f0a' : tier === 'AGI' ? '#a0f' : '#0af',
  }),
};

export function AGITerminal() {
  const terminalRef = useRef<HTMLDivElement>(null);
  const [tab, setTab] = useState<Tab>('enterprise');

  const grouped = useMemo(() => {
    const map = new Map<string, typeof GO_ENTERPRISE_AI>();
    for (const model of GO_ENTERPRISE_AI) {
      const list = map.get(model.family) ?? [];
      list.push(model);
      map.set(model.family, list);
    }
    return map;
  }, []);

  useEffect(() => {
    if (terminalRef.current) {
      terminalRef.current.scrollTop = terminalRef.current.scrollHeight;
    }
  }, []);

  return (
    <div style={S.root}>
      {/* Left Panel — Enterprise AI / Deployment */}
      <div style={S.panel}>
        <div style={S.tabBar}>
          <button style={S.tab(tab === 'enterprise')} onClick={() => setTab('enterprise')}>
            Enterprise AI
          </button>
          <button style={S.tab(tab === 'deployment')} onClick={() => setTab('deployment')}>
            Deployment Actions
          </button>
        </div>

        {tab === 'enterprise' && (
          <>
            <div style={S.header}>
              <span style={{ fontSize: 14 }}>🧠</span> Enterprise AI Models ({GO_ENTERPRISE_AI.length})
            </div>
            {[...grouped.entries()].map(([family, models]) => (
              <React.Fragment key={family}>
                <div style={S.familyHeader}>{family.replace(/_/g, ' ')} ({models.length})</div>
                {models.map(model => (
                  <div key={model.id} style={S.packageCard}>
                    <div style={S.packageName}>
                      {model.name}
                      <span style={S.tierBadge(model.tier)}>{model.tier}</span>
                    </div>
                    <div style={S.packageModel}>{model.id} — {model.family}</div>
                    <div style={{ fontSize: 9, color: '#7a9aba', marginBottom: 6 }}>{model.description}</div>
                    <ul style={S.capList}>
                      {model.capabilities.slice(0, 4).map((cap, i) => (
                        <li key={i} style={S.capItem}>▸ {cap}</li>
                      ))}
                    </ul>
                    <div style={S.metric}>
                      <span style={S.metricLabel}>Capabilities</span>
                      <div style={S.metricBar}>
                        <div style={S.metricFill(model.capabilities.length / 6)} />
                      </div>
                    </div>
                  </div>
                ))}
              </React.Fragment>
            ))}
          </>
        )}

        {tab === 'deployment' && (
          <>
            <div style={S.header}>
              <span style={{ fontSize: 14 }}>🚀</span> Deployment Actions ({GO_DEPLOYMENT_ACTIONS.length})
            </div>
            {GO_DEPLOYMENT_ACTIONS.map(action => (
              <div key={action.id} style={S.packageCard}>
                <div style={S.packageName}>{action.name}</div>
                <div style={S.packageModel}>{action.id} — {action.target}</div>
                <div style={{ fontSize: 9, color: '#7a9aba', marginBottom: 6 }}>{action.description}</div>
                <ul style={S.capList}>
                  {action.capabilities.slice(0, 4).map((cap, i) => (
                    <li key={i} style={S.capItem}>▸ {cap}</li>
                  ))}
                </ul>
                <div style={S.metric}>
                  <span style={S.metricLabel}>Outputs</span>
                  <div style={S.metricBar}>
                    <div style={S.metricFill(action.outputs.length / 5)} />
                  </div>
                </div>
              </div>
            ))}
          </>
        )}
      </div>

      {/* Right Panel — Terminal Output */}
      <div style={S.terminal} ref={terminalRef}>
        <div style={S.header}>
          <span style={{ fontSize: 14 }}>🧠</span> AGI Terminal — Enterprise Registry
          <span style={{ marginLeft: 'auto', fontSize: 9, color: '#4f4' }}>● REGISTRY LOADED</span>
        </div>

        <div style={S.line('SYS')}>
          <span style={S.ts}>[INIT]</span>
          <span style={S.src}>AGI:</span>
          <span>Enterprise AI/AGI Registry initialized — {GO_ENTERPRISE_AI.length} models, {GO_DEPLOYMENT_ACTIONS.length} deployment actions</span>
        </div>

        {GO_ENTERPRISE_AI.map(model => (
          <div key={model.id} style={S.line('DATA')}>
            <span style={S.ts}>[{model.id}]</span>
            <span style={S.src}>{model.family}:</span>
            <span>{model.name} [{model.tier}] — {model.description.slice(0, 80)}</span>
          </div>
        ))}

        <div style={S.line('SYS')}>
          <span style={S.ts}>[----]</span>
          <span style={S.src}>DEPLOY:</span>
          <span>─── Deployment Action Registry ───</span>
        </div>

        {GO_DEPLOYMENT_ACTIONS.map(action => (
          <div key={action.id} style={S.line('INFO')}>
            <span style={S.ts}>[{action.id}]</span>
            <span style={S.src}>{action.target}:</span>
            <span>{action.name} — {action.description.slice(0, 80)}</span>
          </div>
        ))}

        <div style={S.line('INFO')}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>AGI&gt;</span>
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
