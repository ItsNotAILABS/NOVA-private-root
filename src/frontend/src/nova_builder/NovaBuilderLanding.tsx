// ═══════════════════════════════════════════════════════════════════════════
// NOVA BUILDER — Landing Page (Build №42)
// Language: CPL (TypeScript + JSX substrate)
// Powered by NOVA organism · Non-Profit Sovereign Builder · 2026
// ═══════════════════════════════════════════════════════════════════════════

import React, { useEffect, useRef, useState } from 'react';

interface NovaBuilderLandingProps {
  onLaunch: () => void;
}

// ── Proof-of-Impact stories (why NOVA BUILDER exists) ────────────────────
const STORIES = [
  {
    headline: 'CaffeineAI can disappear at any time',
    detail:   '"Caffeine Labs reserves the right to modify or discontinue ... at any time without notice." — Their ToS.',
    impact:   'Canister count froze at 1,149,000. Cycles burn dropped to $5K/day.',
    fix:      'NOVA BUILDER runs on ICP canisters. It cannot be shut down.',
    color:    '#f44',
    icon:     '⚠',
  },
  {
    headline: 'The 3-app limit killed 95% of builders',
    detail:   '"What broke it was limiting to 3 apps per account." — Henn91, ICP community.',
    impact:   'Experimental builders left. Only real devs remained. Network growth stopped.',
    fix:      'NOVA BUILDER has no account limits. Ever. Limited only by cycles pool.',
    color:    '#fa0',
    icon:     '⬡',
  },
  {
    headline: 'Weak burn = staking rewards collapse',
    detail:   'Fewer canisters → fewer cycles burned → weak deflationary pressure → ICP price suffers.',
    impact:   'Neuron holders see eroding returns. The tokenomic model depends on burn.',
    fix:      'Every NOVA BUILDER deploy burns cycles directly — φ-scaled ICP deflation.',
    color:    '#4af',
    icon:     'φ',
  },
  {
    headline: 'The fix is a protocol — not a policy',
    detail:   'DFINITY policy changes are slow and reversible. Sovereign infrastructure is not.',
    impact:   'UTOPIA hybrid model worsens imbalance: infra grows but cycles burn does not.',
    fix:      'NOVA BUILDER is non-profit, community-governed, and lives on-chain forever.',
    color:    '#4f4',
    icon:     '⊕',
  },
];

const STATS = [
  { label: 'Account Limit',   value: 'NONE',    unit: 'EVER',      color: '#4f4' },
  { label: 'Cycles per Build', value: '1B',      unit: 'BURNED',    color: '#4af' },
  { label: 'Shutdown Risk',   value: '0%',      unit: 'ON-CHAIN',  color: '#4f4' },
  { label: 'Governance',      value: 'NOVA DAO', unit: 'COMMUNITY', color: '#fa0' },
];

// ── Styles ────────────────────────────────────────────────────────────────
const S = {
  root: {
    width: '100%',
    height: '100%',
    background: '#030810',
    color: '#c8d8f0',
    fontFamily: "'SF Mono', 'Fira Code', monospace",
    overflowY: 'auto' as const,
    display: 'flex',
    flexDirection: 'column' as const,
    alignItems: 'center',
  },
  hero: {
    width: '100%',
    maxWidth: 960,
    padding: '60px 24px 40px',
    textAlign: 'center' as const,
  },
  badge: {
    display: 'inline-block',
    padding: '4px 14px',
    background: 'rgba(68,255,68,0.1)',
    border: '1px solid #4f4',
    borderRadius: 3,
    fontSize: 9,
    color: '#4f4',
    letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
    marginBottom: 24,
  },
  title: {
    fontSize: 36,
    fontWeight: 700,
    color: '#e8f4ff',
    letterSpacing: '-0.01em',
    margin: '0 0 8px',
  },
  titleAccent: {
    color: '#4af',
  },
  subtitle: {
    fontSize: 14,
    color: '#6a9cc0',
    marginBottom: 12,
    lineHeight: 1.6,
  },
  missionLine: {
    fontSize: 11,
    color: '#3a6080',
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    marginBottom: 32,
  },
  statsRow: {
    display: 'flex',
    gap: 16,
    justifyContent: 'center',
    flexWrap: 'wrap' as const,
    marginBottom: 40,
  },
  statCard: (color: string) => ({
    background: `rgba(${color === '#4f4' ? '68,255,68' : color === '#4af' ? '68,170,255' : color === '#fa0' ? '255,170,0' : '68,170,255'},0.06)`,
    border: `1px solid ${color}33`,
    borderRadius: 6,
    padding: '12px 20px',
    textAlign: 'center' as const,
    minWidth: 110,
  }),
  statValue: (color: string) => ({
    fontSize: 20,
    fontWeight: 700,
    color,
    display: 'block',
  }),
  statLabel: {
    fontSize: 8,
    color: '#3a6080',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    display: 'block',
    marginTop: 2,
  },
  statUnit: {
    fontSize: 7,
    color: '#2a4060',
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    display: 'block',
  },
  launchBtn: {
    padding: '14px 48px',
    background: 'linear-gradient(135deg, #0a2040 0%, #0d3060 100%)',
    border: '1px solid #4af',
    borderRadius: 4,
    color: '#4af',
    fontSize: 13,
    fontFamily: 'inherit',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    cursor: 'pointer',
    marginBottom: 8,
  },
  launchSub: {
    fontSize: 9,
    color: '#2a4060',
    letterSpacing: '0.1em',
  },
  section: {
    width: '100%',
    maxWidth: 960,
    padding: '0 24px 48px',
  },
  sectionTitle: {
    fontSize: 10,
    color: '#3a6080',
    letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
    marginBottom: 16,
    borderBottom: '1px solid #0a2040',
    paddingBottom: 8,
  },
  storyGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(420px, 1fr))',
    gap: 16,
  },
  storyCard: (color: string) => ({
    background: '#050d1a',
    border: `1px solid ${color}22`,
    borderLeft: `3px solid ${color}`,
    borderRadius: 6,
    padding: '16px 20px',
  }),
  storyIcon: (color: string) => ({
    fontSize: 20,
    color,
    marginBottom: 8,
    display: 'block',
  }),
  storyHeadline: {
    fontSize: 12,
    color: '#c8d8f0',
    fontWeight: 600,
    marginBottom: 8,
  },
  storyDetail: {
    fontSize: 10,
    color: '#4a6880',
    lineHeight: 1.5,
    marginBottom: 6,
    fontStyle: 'italic' as const,
  },
  storyImpact: {
    fontSize: 10,
    color: '#6a8ca0',
    lineHeight: 1.5,
    marginBottom: 8,
  },
  storyFix: (color: string) => ({
    fontSize: 10,
    color,
    lineHeight: 1.5,
    fontWeight: 600,
  }),
  compareTable: {
    width: '100%',
    borderCollapse: 'collapse' as const,
    fontSize: 10,
  },
  thRow: {
    background: '#070e1e',
  },
  th: {
    padding: '8px 12px',
    textAlign: 'left' as const,
    color: '#3a6080',
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    fontWeight: 400,
    borderBottom: '1px solid #0a2040',
  },
  td: (highlight?: boolean) => ({
    padding: '8px 12px',
    color: highlight ? '#4f4' : '#6a9cc0',
    borderBottom: '1px solid #050d1a',
  }),
  footer: {
    width: '100%',
    maxWidth: 960,
    padding: '16px 24px 32px',
    textAlign: 'center' as const,
    fontSize: 8,
    color: '#1a3050',
    letterSpacing: '0.1em',
  },
};

// ── Comparison data ───────────────────────────────────────────────────────
const COMPARISON = [
  { dim: 'Shutdown risk',       caffeine: '"At any time without notice"', nova: 'Impossible — ICP canisters', highlight: true },
  { dim: 'Account limit',       caffeine: '3 apps per account',           nova: 'Unlimited — cycles pool only', highlight: true },
  { dim: 'Economic model',      caffeine: 'VC-funded startup',            nova: 'Non-profit cycles subsidy', highlight: false },
  { dim: 'Cycles burn',         caffeine: 'Zero (off-chain service)',     nova: 'Every build burns cycles → ICP deflation', highlight: true },
  { dim: 'Governance',          caffeine: 'Caffeine Labs unilateral',     nova: 'nova_governance — community DAO', highlight: false },
  { dim: 'Availability',        caffeine: 'Centralized servers',          nova: 'ICP subnet — 99.9%+ uptime', highlight: false },
  { dim: 'Builder trust',       caffeine: 'Must trust Caffeine Labs',     nova: 'Trustless — code on-chain, open', highlight: false },
  { dim: 'ICP economic impact', caffeine: 'None',                         nova: 'Direct burn → deflationary pressure', highlight: true },
];

export function NovaBuilderLanding({ onLaunch }: NovaBuilderLandingProps) {
  const [tick, setTick] = useState(0);

  // Pulse animation
  useEffect(() => {
    const t = setInterval(() => setTick(v => v + 1), 1618);
    return () => clearInterval(t);
  }, []);

  return (
    <div style={S.root}>
      {/* ── Hero ─────────────────────────────────────────────────────── */}
      <div style={S.hero}>
        <div style={S.badge}>⊕ NOVA BUILDER · BUILD №42 · NON-PROFIT</div>

        <h1 style={S.title}>
          The Sovereign{' '}
          <span style={S.titleAccent}>CaffeineAI</span>
          <br />Replacement
        </h1>

        <p style={S.subtitle}>
          Describe what you want to build in plain language.<br />
          NOVA's on-chain AGI generates the code, deploys the canister, burns cycles.<br />
          No account limits. No ToS. No shutdown clause. <strong style={{ color: '#4af' }}>A protocol — not a startup.</strong>
        </p>

        <div style={S.missionLine}>
          Non-Profit · Permissionless · Sovereign · Every Build Burns ICP Cycles
        </div>

        {/* Stats */}
        <div style={S.statsRow}>
          {STATS.map(s => (
            <div key={s.label} style={S.statCard(s.color)}>
              <span style={S.statValue(s.color)}>{s.value}</span>
              <span style={S.statLabel}>{s.label}</span>
              <span style={S.statUnit}>{s.unit}</span>
            </div>
          ))}
        </div>

        <button style={S.launchBtn} onClick={onLaunch}>
          ⊕ Launch NOVA BUILDER
        </button>
        <div style={S.launchSub}>
          Powered by NOVA organism · {tick % 2 === 0 ? '⬡' : '◉'} Cycle subsidy pool active
        </div>
      </div>

      {/* ── Why section ──────────────────────────────────────────────── */}
      <div style={S.section}>
        <div style={S.sectionTitle}>⚠ The Problem (What the ICP Community Missed)</div>
        <div style={S.storyGrid}>
          {STORIES.map(s => (
            <div key={s.headline} style={S.storyCard(s.color)}>
              <span style={S.storyIcon(s.color)}>{s.icon}</span>
              <div style={S.storyHeadline}>{s.headline}</div>
              <div style={S.storyDetail}>{s.detail}</div>
              <div style={S.storyImpact}>{s.impact}</div>
              <div style={S.storyFix(s.color)}>→ {s.fix}</div>
            </div>
          ))}
        </div>
      </div>

      {/* ── Comparison table ─────────────────────────────────────────── */}
      <div style={S.section}>
        <div style={S.sectionTitle}>◈ NOVA BUILDER vs CaffeineAI</div>
        <table style={S.compareTable}>
          <thead>
            <tr style={S.thRow}>
              <th style={S.th}>Dimension</th>
              <th style={S.th}>CaffeineAI</th>
              <th style={S.th}>NOVA BUILDER</th>
            </tr>
          </thead>
          <tbody>
            {COMPARISON.map(row => (
              <tr key={row.dim}>
                <td style={S.td()}>{row.dim}</td>
                <td style={{ ...S.td(), color: '#844' }}>{row.caffeine}</td>
                <td style={S.td(row.highlight)}>{row.nova}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* ── CTA ──────────────────────────────────────────────────────── */}
      <div style={{ ...S.section, textAlign: 'center' }}>
        <button style={S.launchBtn} onClick={onLaunch}>
          ⊕ Start Building — No Account Required
        </button>
        <div style={{ ...S.launchSub, marginTop: 8 }}>
          Every deploy burns cycles → direct ICP deflation → stronger staking returns
        </div>
      </div>

      {/* ── Footer ───────────────────────────────────────────────────── */}
      <div style={S.footer}>
        NOVA BUILDER — BUILD №42 · © 2024-2026 ALFREDO MEDINA HERNANDEZ · MEDINA TECH · DALLAS TX<br />
        NON-PROFIT · SOVEREIGN · POWERED BY NOVA ORGANISM · CANNOT BE SHUT DOWN<br />
        This canister runs on ICP. Its code is on-chain. Its mission is perpetual.
      </div>
    </div>
  );
}
