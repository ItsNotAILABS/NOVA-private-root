// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Terminal Hub
// Master terminal orchestrator with tabbed navigation across all 15 domains
// 40 multimodal calls · 30 AI organism packages · 15 sovereign terminals
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import { TERMINAL_TABS } from './types';
import type { TerminalDomain } from './types';
import { MULTIMODAL_CALLS, getCallsByDomain } from './calls';
import { MULTIMODAL_PACKAGES, getPackagesByDomain } from './packages';

// Terminal component imports
import { DefenseTerminal } from './DefenseTerminal';
import { MemoryTerminal } from './MemoryTerminal';
import { GovernanceTerminal } from './GovernanceTerminal';
import { NeuralTerminal } from './NeuralTerminal';
import { QuantumTerminal } from './QuantumTerminal';
import { EconomicTerminal } from './EconomicTerminal';
import { SwarmTerminal } from './SwarmTerminal';
import { CognitiveTerminal } from './CognitiveTerminal';
import { SensorTerminal } from './SensorTerminal';
import { FrequencyTerminal } from './FrequencyTerminal';
import { SovereigntyTerminal } from './SovereigntyTerminal';
import { IntegrationTerminal } from './IntegrationTerminal';
import { PackagingTerminal } from './PackagingTerminal';
import { IntelligenceTerminal } from './IntelligenceTerminal';
import { MathTerminal } from './MathTerminal';

const TERMINAL_MAP: Record<TerminalDomain, React.FC> = {
  DEFENSE: DefenseTerminal,
  MEMORY: MemoryTerminal,
  GOVERNANCE: GovernanceTerminal,
  NEURAL: NeuralTerminal,
  QUANTUM: QuantumTerminal,
  ECONOMIC: EconomicTerminal,
  SWARM: SwarmTerminal,
  COGNITIVE: CognitiveTerminal,
  SENSOR: SensorTerminal,
  FREQUENCY: FrequencyTerminal,
  SOVEREIGNTY: SovereigntyTerminal,
  INTEGRATION: IntegrationTerminal,
  PACKAGING: PackagingTerminal,
  INTELLIGENCE: IntelligenceTerminal,
  MATH: MathTerminal,
};

const S = {
  root: {
    width: '100%',
    height: '100%',
    display: 'flex' as const,
    flexDirection: 'column' as const,
    background: '#050a14',
    overflow: 'hidden' as const,
  },
  topBar: {
    display: 'flex' as const,
    alignItems: 'center' as const,
    gap: 2,
    padding: '6px 12px',
    background: '#070e1e',
    borderBottom: '1px solid #1a3a5c',
    flexShrink: 0,
    flexWrap: 'wrap' as const,
  },
  brand: {
    fontSize: 10,
    color: '#4af',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    marginRight: 8,
    whiteSpace: 'nowrap' as const,
  },
  stats: {
    fontSize: 8,
    color: '#3a6080',
    marginRight: 12,
    whiteSpace: 'nowrap' as const,
  },
  tabBtn: (active: boolean, color: string) => ({
    padding: '3px 8px',
    fontSize: 8,
    background: active ? `${color}22` : 'transparent',
    color: active ? color : '#3a6080',
    border: `1px solid ${active ? color : 'transparent'}`,
    borderRadius: 3,
    cursor: 'pointer' as const,
    letterSpacing: '0.04em',
    textTransform: 'uppercase' as const,
    display: 'flex' as const,
    alignItems: 'center' as const,
    gap: 4,
    whiteSpace: 'nowrap' as const,
    transition: 'all 0.15s ease',
  }),
  content: {
    flex: 1,
    overflow: 'hidden' as const,
  },
  overviewRoot: {
    width: '100%',
    height: '100%',
    overflow: 'auto' as const,
    padding: 16,
  },
  overviewHeader: {
    fontSize: 14,
    color: '#4af',
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    marginBottom: 4,
  },
  overviewSubheader: {
    fontSize: 10,
    color: '#3a6080',
    marginBottom: 20,
  },
  overviewGrid: {
    display: 'grid' as const,
    gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))',
    gap: 12,
  },
  domainCard: (color: string) => ({
    background: 'rgba(10, 20, 40, 0.8)',
    border: `1px solid ${color}33`,
    borderRadius: 8,
    padding: '14px 16px',
    cursor: 'pointer' as const,
    transition: 'all 0.2s ease',
  }),
  domainIcon: (color: string) => ({
    fontSize: 18,
    color,
    marginRight: 8,
  }),
  domainName: {
    fontSize: 12,
    fontWeight: 'bold' as const,
    color: '#fff',
  },
  domainDesc: {
    fontSize: 9,
    color: '#6a8aaa',
    marginTop: 4,
    marginBottom: 8,
  },
  domainStats: {
    display: 'flex' as const,
    gap: 16,
    fontSize: 9,
    color: '#5a7a9a',
  },
  domainStatValue: (color: string) => ({
    color,
    fontWeight: 'bold' as const,
    fontFamily: 'monospace',
  }),
};

function OverviewPanel({ onSelect }: { onSelect: (domain: TerminalDomain) => void }) {
  return (
    <div style={S.overviewRoot}>
      <div style={S.overviewHeader}>◉ NOVA Terminal System</div>
      <div style={S.overviewSubheader}>
        {MULTIMODAL_CALLS.length} Multimodal Calls · {MULTIMODAL_PACKAGES.length} AI Organism Packages · {TERMINAL_TABS.length} Sovereign Terminals
      </div>
      <div style={S.overviewGrid}>
        {TERMINAL_TABS.map(tab => {
          const calls = getCallsByDomain(tab.id);
          const packages = getPackagesByDomain(tab.id);
          return (
            <div
              key={tab.id}
              style={S.domainCard(tab.color)}
              onClick={() => onSelect(tab.id)}
              onMouseEnter={e => {
                (e.currentTarget as HTMLDivElement).style.borderColor = tab.color;
                (e.currentTarget as HTMLDivElement).style.background = 'rgba(15, 30, 60, 0.9)';
              }}
              onMouseLeave={e => {
                (e.currentTarget as HTMLDivElement).style.borderColor = `${tab.color}33`;
                (e.currentTarget as HTMLDivElement).style.background = 'rgba(10, 20, 40, 0.8)';
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', marginBottom: 4 }}>
                <span style={S.domainIcon(tab.color)}>{tab.icon}</span>
                <span style={S.domainName}>{tab.label}</span>
              </div>
              <div style={S.domainDesc}>{tab.description}</div>
              <div style={S.domainStats}>
                <span>
                  Calls: <span style={S.domainStatValue(tab.color)}>{calls.length}</span>
                </span>
                <span>
                  Packages: <span style={S.domainStatValue(tab.color)}>{packages.length}</span>
                </span>
                <span>
                  Ring: <span style={S.domainStatValue(tab.color)}>
                    {calls[0]?.ring || 'N/A'}
                  </span>
                </span>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

export function TerminalHub() {
  const [activeDomain, setActiveDomain] = useState<TerminalDomain | null>(null);

  const ActiveTerminal = activeDomain ? TERMINAL_MAP[activeDomain] : null;

  return (
    <div style={S.root}>
      {/* Tab bar */}
      <div style={S.topBar}>
        <span style={S.brand}>◉ Terminals</span>
        <span style={S.stats}>
          {MULTIMODAL_CALLS.length}C · {MULTIMODAL_PACKAGES.length}P · {TERMINAL_TABS.length}T
        </span>

        {/* Overview button */}
        <button
          onClick={() => setActiveDomain(null)}
          style={S.tabBtn(activeDomain === null, '#4af')}
        >
          ◈ Overview
        </button>

        {/* Domain tabs */}
        {TERMINAL_TABS.map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveDomain(tab.id)}
            style={S.tabBtn(activeDomain === tab.id, tab.color)}
          >
            <span>{tab.icon}</span> {tab.label}
          </button>
        ))}
      </div>

      {/* Terminal content */}
      <div style={S.content}>
        {ActiveTerminal ? <ActiveTerminal /> : <OverviewPanel onSelect={setActiveDomain} />}
      </div>
    </div>
  );
}
