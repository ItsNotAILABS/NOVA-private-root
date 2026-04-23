// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Consciousness Terminal
// Surfaces 40 CTMs + 60 PMCs + Directives
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect, useState } from 'react';
import { CONSCIOUSNESS_THOUGHT_MODELS, CONSCIOUSNESS_DIRECTIVES } from './goConsciousness';
import { PHANTOM_META_CONSCIOUSNESS_MODELS, META_CONSCIOUSNESS_DIRECTIVES } from './goPhantomMetaConsciousness';

const DOMAIN_COLOR = '#a4f';

type Tab = 'ctm' | 'pmc' | 'directives';

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
  tabBar: {
    display: 'flex' as const,
    gap: 4,
    marginBottom: 12,
  },
  tab: (active: boolean) => ({
    flex: 1,
    padding: '6px 4px',
    fontSize: 9,
    fontWeight: 'bold' as const,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.06em',
    textAlign: 'center' as const,
    cursor: 'pointer' as const,
    border: `1px solid ${active ? DOMAIN_COLOR : DOMAIN_COLOR + '33'}`,
    borderRadius: 4,
    background: active ? DOMAIN_COLOR + '22' : 'transparent',
    color: active ? DOMAIN_COLOR : '#5a7a9a',
  }),
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
  desc: {
    fontSize: 9,
    color: '#7a9aba',
    marginBottom: 6,
    lineHeight: 1.4,
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
    color: type === 'SYS' ? '#555' : type === 'HEAD' ? DOMAIN_COLOR : type === 'META' ? '#c8f' : '#6ac',
    marginBottom: 1,
  }),
  ts: { color: '#3a5a7a', marginRight: 8 },
  cursor: {
    display: 'inline-block' as const,
    width: 8,
    height: 14,
    background: DOMAIN_COLOR,
    animation: 'blink 1s infinite',
    verticalAlign: 'middle' as const,
  },
};

export function ConsciousnessTerminal() {
  const terminalRef = useRef<HTMLDivElement>(null);
  const [activeTab, setActiveTab] = useState<Tab>('ctm');

  useEffect(() => {
    if (terminalRef.current) {
      terminalRef.current.scrollTop = 0;
    }
  }, []);

  return (
    <div style={S.root}>
      {/* Left Panel — Model Cards */}
      <div style={S.panel}>
        <div style={S.header}>
          <span style={{ fontSize: 14 }}>◎</span> Consciousness Models
        </div>

        <div style={S.tabBar}>
          <div style={S.tab(activeTab === 'ctm')} onClick={() => setActiveTab('ctm')}>
            CTM Models
          </div>
          <div style={S.tab(activeTab === 'pmc')} onClick={() => setActiveTab('pmc')}>
            PMC Models
          </div>
          <div style={S.tab(activeTab === 'directives')} onClick={() => setActiveTab('directives')}>
            Directives
          </div>
        </div>

        {activeTab === 'ctm' && CONSCIOUSNESS_THOUGHT_MODELS.map(m => (
          <div key={m.id} style={S.packageCard}>
            <div style={S.packageName}>{m.name}</div>
            <div style={S.packageModel}>{m.id} — {m.family}</div>
            <div style={S.desc}>{m.description}</div>
            <div style={{ fontSize: 8, color: '#5a7a9a', marginBottom: 4 }}>
              DEPTH: {m.depth}
            </div>
            <ul style={S.capList}>
              {m.capabilities.slice(0, 3).map((cap, i) => (
                <li key={i} style={S.capItem}>▸ {cap}</li>
              ))}
            </ul>
            <div style={S.metric}>
              <span style={S.metricLabel}>Φ Resonance</span>
              <div style={S.metricBar}>
                <div style={S.metricFill(m.phiResonance)} />
              </div>
            </div>
          </div>
        ))}

        {activeTab === 'pmc' && PHANTOM_META_CONSCIOUSNESS_MODELS.map(m => (
          <div key={m.id} style={S.packageCard}>
            <div style={S.packageName}>{m.name}</div>
            <div style={S.packageModel}>{m.id} — {m.family}</div>
            <div style={S.desc}>{m.description}</div>
            <div style={{ fontSize: 8, color: '#5a7a9a', marginBottom: 4 }}>
              LAYER: {m.layer} · ORDER: {m.consciousnessOrder}
            </div>
            <ul style={S.capList}>
              {m.capabilities.slice(0, 3).map((cap, i) => (
                <li key={i} style={S.capItem}>▸ {cap}</li>
              ))}
            </ul>
            <div style={S.metric}>
              <span style={S.metricLabel}>Φ Harmonic</span>
              <div style={S.metricBar}>
                <div style={S.metricFill(m.phiHarmonic / 3)} />
              </div>
            </div>
          </div>
        ))}

        {activeTab === 'directives' && (
          <>
            <div style={{ ...S.header, marginTop: 4, fontSize: 9 }}>
              <span style={{ fontSize: 12 }}>⚡</span> Consciousness Directives
            </div>
            {CONSCIOUSNESS_DIRECTIVES.map(d => (
              <div key={d.id} style={S.packageCard}>
                <div style={S.packageName}>{d.name}</div>
                <div style={S.packageModel}>{d.id} — {d.directiveType}</div>
                <div style={S.desc}>{d.description}</div>
                <div style={{ fontSize: 8, color: '#5a7a9a' }}>
                  SOURCE: {d.sourceModel} · TARGET: {d.targetFamily} · {d.persistence}
                </div>
              </div>
            ))}

            <div style={{ ...S.header, marginTop: 12, fontSize: 9 }}>
              <span style={{ fontSize: 12 }}>⚡</span> Meta-Consciousness Directives
            </div>
            {META_CONSCIOUSNESS_DIRECTIVES.map(d => (
              <div key={d.id} style={S.packageCard}>
                <div style={S.packageName}>{d.name}</div>
                <div style={S.packageModel}>{d.id} — {d.metaType}</div>
                <div style={S.desc}>{d.description}</div>
                <div style={{ fontSize: 8, color: '#5a7a9a' }}>
                  SOURCE: {d.sourceModel} · TARGET: {d.targetFamily} · {d.persistence}
                </div>
              </div>
            ))}
          </>
        )}
      </div>

      {/* Right Panel — Terminal Stream */}
      <div style={S.terminal} ref={terminalRef}>
        <div style={S.header}>
          <span style={{ fontSize: 14 }}>◎</span> Consciousness Terminal Stream
          <span style={{ marginLeft: 'auto', fontSize: 9, color: DOMAIN_COLOR }}>
            {CONSCIOUSNESS_THOUGHT_MODELS.length} CTMs · {PHANTOM_META_CONSCIOUSNESS_MODELS.length} PMCs · {CONSCIOUSNESS_DIRECTIVES.length + META_CONSCIOUSNESS_DIRECTIVES.length} Directives
          </span>
        </div>

        {/* CTM listing */}
        <div style={S.line('HEAD')}>
          ══ CONSCIOUSNESS THOUGHT MODELS ({CONSCIOUSNESS_THOUGHT_MODELS.length}) ══
        </div>
        {CONSCIOUSNESS_THOUGHT_MODELS.map(m => (
          <div key={m.id} style={S.line('INFO')}>
            <span style={S.ts}>[{m.id}]</span>
            <span style={{ color: '#fff', marginRight: 8 }}>{m.name}</span>
            <span style={{ color: '#5a7a9a', marginRight: 8 }}>
              {m.family} · {m.depth} · Φ={m.phiResonance}
            </span>
            <span style={{ color: '#6a8aaa' }}>
              [{m.capabilities.slice(0, 3).join(', ')}]
            </span>
          </div>
        ))}

        {/* PMC listing */}
        <div style={{ ...S.line('HEAD'), marginTop: 12 }}>
          ══ PHANTOM META-CONSCIOUSNESS MODELS ({PHANTOM_META_CONSCIOUSNESS_MODELS.length}) ══
        </div>
        {PHANTOM_META_CONSCIOUSNESS_MODELS.map(m => (
          <div key={m.id} style={S.line('META')}>
            <span style={S.ts}>[{m.id}]</span>
            <span style={{ color: '#fff', marginRight: 8 }}>{m.name}</span>
            <span style={{ color: '#5a7a9a', marginRight: 8 }}>
              {m.family} · {m.layer} · Φ={m.phiHarmonic} · O={m.consciousnessOrder}
            </span>
            <span style={{ color: '#6a8aaa' }}>
              [{m.capabilities.slice(0, 3).join(', ')}]
            </span>
          </div>
        ))}

        {/* Consciousness Directives */}
        <div style={{ ...S.line('HEAD'), marginTop: 12 }}>
          ══ CONSCIOUSNESS DIRECTIVES ({CONSCIOUSNESS_DIRECTIVES.length}) ══
        </div>
        {CONSCIOUSNESS_DIRECTIVES.map(d => (
          <div key={d.id} style={S.line('INFO')}>
            <span style={S.ts}>[{d.id}]</span>
            <span style={{ color: '#fff', marginRight: 8 }}>{d.name}</span>
            <span style={{ color: '#5a7a9a' }}>
              {d.directiveType} · {d.sourceModel} → {d.targetFamily} · {d.persistence}
            </span>
          </div>
        ))}

        {/* Meta-Consciousness Directives */}
        <div style={{ ...S.line('HEAD'), marginTop: 12 }}>
          ══ META-CONSCIOUSNESS DIRECTIVES ({META_CONSCIOUSNESS_DIRECTIVES.length}) ══
        </div>
        {META_CONSCIOUSNESS_DIRECTIVES.map(d => (
          <div key={d.id} style={S.line('META')}>
            <span style={S.ts}>[{d.id}]</span>
            <span style={{ color: '#fff', marginRight: 8 }}>{d.name}</span>
            <span style={{ color: '#5a7a9a' }}>
              {d.metaType} · {d.sourceModel} → {d.targetFamily} · {d.persistence}
            </span>
          </div>
        ))}

        <div style={{ ...S.line('INFO'), marginTop: 8 }}>
          <span style={{ color: DOMAIN_COLOR, marginRight: 4 }}>CONSCIOUSNESS&gt;</span>
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
