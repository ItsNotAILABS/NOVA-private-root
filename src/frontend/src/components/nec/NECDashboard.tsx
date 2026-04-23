// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// Neural Emergence Core (NEC) — Live Brain Dashboard.
// Full-page dark-themed reactive simulation view. No external CSS or Tailwind.

import React, { useState, useEffect, useRef, useCallback, useMemo } from 'react';
import {
  initNEC, tickNEC, summarizeNEC,
  type NECState, type RegionCategory, type FiberTract,
} from '../../math/nec-engine';

// ── Theme constants ───────────────────────────────────────────────────────────
const BG     = '#050a14';
const BG2    = '#070e1e';
const BORDER = '#1a3a5c';
const TEXT   = '#9bf';
const ACCENT = '#4af';

// ── Category colour map ───────────────────────────────────────────────────────
const CAT_COLOR: Record<RegionCategory, string> = {
  Cortical:    '#4af',
  Subcortical: '#4f8',
  Brainstem:   '#fa6',
  Cerebellar:  '#c6f',
  Limbic:      '#f6a',
};

// ── Band colour map ───────────────────────────────────────────────────────────
const BAND_META = [
  { key: 'delta', label: 'δ Delta',  color: '#335577' },
  { key: 'theta', label: 'θ Theta',  color: '#447755' },
  { key: 'alpha', label: 'α Alpha',  color: '#664499' },
  { key: 'beta',  label: 'β Beta',   color: '#775533' },
  { key: 'gamma', label: 'γ Gamma',  color: '#cc4444' },
] as const;

// ── Key neurochemicals for panel ──────────────────────────────────────────────
const CHEM_KEYS = [
  'dopamine', 'serotonin', 'norepinephrine', 'acetylcholine', 'gaba',
  'glutamate', 'endorphin', 'adenosine', 'bdnf', 'oxytocin',
  'cortisol', 'histamine', 'melatonin', 'nitricOxide', 'atp',
] as const;
type ChemKey = typeof CHEM_KEYS[number];

// ── SVG region position helper ────────────────────────────────────────────────
function regionXY(id: number): [number, number] {
  return [(id % 10) * 38 + 20, Math.floor(id / 10) * 18 + 10];
}

// ── Sparkline component ───────────────────────────────────────────────────────
function Sparkline({ data, width, height, color }: { data: number[]; width: number; height: number; color: string }) {
  if (data.length < 2) return null;
  const min = Math.min(...data);
  const max = Math.max(...data) || min + 1;
  const pts = data.map((v, i) => {
    const x = (i / (data.length - 1)) * width;
    const y = height - ((v - min) / (max - min)) * height;
    return `${x.toFixed(1)},${y.toFixed(1)}`;
  }).join(' ');
  return (
    <svg width={width} height={height} style={{ display: 'block' }}>
      <polyline points={pts} fill="none" stroke={color} strokeWidth={1.2} />
    </svg>
  );
}

// ── Mini bar ──────────────────────────────────────────────────────────────────
function MiniBar({ value, color, label, showVal = true }: { value: number; color: string; label: string; showVal?: boolean }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 3 }}>
      <span style={{ fontSize: 9, color: TEXT, width: 110, flexShrink: 0, opacity: 0.8 }}>{label}</span>
      <div style={{ flex: 1, height: 8, background: '#0c1828', borderRadius: 2, overflow: 'hidden' }}>
        <div style={{ width: `${(value * 100).toFixed(1)}%`, height: '100%', background: color, transition: 'width 0.4s ease' }} />
      </div>
      {showVal && <span style={{ fontSize: 8, color: ACCENT, width: 32, textAlign: 'right' }}>{value.toFixed(2)}</span>}
    </div>
  );
}

// ── Coherence bar ─────────────────────────────────────────────────────────────
function CoherenceBar({ value, label }: { value: number; label: string }) {
  const pct = (value * 100).toFixed(1);
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9, color: TEXT }}>
        <span>{label}</span><span style={{ color: ACCENT }}>{pct}%</span>
      </div>
      <div style={{ height: 10, background: '#0c1828', borderRadius: 3, overflow: 'hidden' }}>
        <div style={{ width: `${pct}%`, height: '100%', background: `hsl(${200 - value * 120}, 70%, 45%)`, transition: 'width 0.4s ease' }} />
      </div>
    </div>
  );
}

// ── Main Dashboard ────────────────────────────────────────────────────────────
export function NECDashboard() {
  const [necState, setNecState] = useState<NECState>(() => initNEC());
  const lfpHistory = useRef<number[]>([]);
  const [hoveredRegion, setHoveredRegion] = useState<number | null>(null);
  const [hoveredTract, setHoveredTract] = useState<number | null>(null);

  // Tick every 873ms
  useEffect(() => {
    let beat = 0;
    const id = setInterval(() => {
      beat += 1;
      setNecState(prev => tickNEC(prev, beat));
    }, 873);
    return () => clearInterval(id);
  }, []);

  // Track LFP history
  useEffect(() => {
    const meanLFP = necState.regions.reduce((s, r) => s + r.lfp, 0) / necState.regions.length;
    lfpHistory.current = [...lfpHistory.current.slice(-29), meanLFP];
  }, [necState]);

  const summary = useMemo(() => summarizeNEC(necState), [necState]);

  // Category mean spike rates
  const catSpikeRates = useMemo(() => {
    const cats: RegionCategory[] = ['Cortical', 'Subcortical', 'Brainstem', 'Cerebellar', 'Limbic'];
    return cats.map(cat => {
      const rs = necState.regions.filter(r => r.category === cat);
      const mean = rs.length ? rs.reduce((s, r) => s + r.lif.spikeRate, 0) / rs.length : 0;
      return { cat, mean };
    });
  }, [necState]);

  // Mean ion channels
  const meanChannels = useMemo(() => {
    const n = necState.regions.length || 1;
    return {
      na: necState.regions.reduce((s, r) => s + r.channels.na, 0) / n,
      k:  necState.regions.reduce((s, r) => s + r.channels.k,  0) / n,
      ca: necState.regions.reduce((s, r) => s + r.channels.ca, 0) / n,
      cl: necState.regions.reduce((s, r) => s + r.channels.cl, 0) / n,
    };
  }, [necState]);

  const maxSpikeRate = useMemo(() => Math.max(...catSpikeRates.map(c => c.mean), 1), [catSpikeRates]);

  // SVG tract path helper
  const tractPath = useCallback((t: FiberTract): string => {
    const [sx, sy] = regionXY(t.sourceRegion);
    const [tx2, ty] = regionXY(t.targetRegion);
    const mx = (sx + tx2) / 2;
    const my = Math.min(sy, ty) - 30;
    return `M${sx},${sy} Q${mx},${my} ${tx2},${ty}`;
  }, []);

  const tractColor = useCallback((strength: number): string => {
    const hue = Math.round(200 - strength * 200);
    return `hsl(${hue}, 80%, 50%)`;
  }, []);

  // ── Panel styles ──────────────────────────────────────────────────────────
  const panelStyle: React.CSSProperties = {
    background: BG2,
    border: `1px solid ${BORDER}`,
    borderRadius: 4,
    padding: 10,
  };

  const sectionTitle: React.CSSProperties = {
    fontSize: 9,
    color: ACCENT,
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
    marginBottom: 8,
    borderBottom: `1px solid ${BORDER}`,
    paddingBottom: 4,
  };

  return (
    <div style={{ background: BG, color: TEXT, fontFamily: 'monospace', fontSize: 11, padding: 12, minHeight: '100%', boxSizing: 'border-box' }}>

      {/* ── Section 1: Header Row ─────────────────────────────────────── */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(6, 1fr)', gap: 8, marginBottom: 10 }}>

        <div style={panelStyle}>
          <div style={{ fontSize: 8, color: '#3a6080', marginBottom: 4 }}>BEAT</div>
          <div style={{ fontSize: 22, color: ACCENT, fontWeight: 'bold' }}>{summary.beat}</div>
          <div style={{ fontSize: 8, color: TEXT, opacity: 0.6 }}>Neural Tick</div>
        </div>

        <div style={{ ...panelStyle, gridColumn: 'span 2' }}>
          <div style={{ fontSize: 8, color: '#3a6080', marginBottom: 6 }}>GLOBAL COHERENCE</div>
          <CoherenceBar value={summary.globalCoherence} label="Synchrony" />
          <div style={{ marginTop: 6 }}>
            <CoherenceBar value={summary.emergenceIndex} label="Emergence" />
          </div>
        </div>

        <div style={panelStyle}>
          <div style={{ fontSize: 8, color: '#3a6080', marginBottom: 4 }}>TOP REGION</div>
          <div style={{ fontSize: 9, color: ACCENT, lineHeight: 1.4 }}>{summary.topRegion.name}</div>
          <div style={{ fontSize: 8, color: TEXT, marginTop: 2 }}>Act: {summary.topRegion.activation.toFixed(3)}</div>
        </div>

        <div style={panelStyle}>
          <div style={{ fontSize: 8, color: '#3a6080', marginBottom: 4 }}>MEAN LFP</div>
          <div style={{ fontSize: 16, color: '#6cf' }}>{summary.meanLFP.toFixed(1)} <span style={{ fontSize: 8 }}>μV</span></div>
          <div style={{ fontSize: 8, color: TEXT, marginTop: 2 }}>Spike: {summary.meanSpikeRate.toFixed(1)} Hz</div>
        </div>

        <div style={panelStyle}>
          <div style={{ fontSize: 8, color: '#3a6080', marginBottom: 4 }}>EMERGENCE IDX</div>
          <div style={{ fontSize: 16, color: '#af4' }}>{(summary.emergenceIndex * 100).toFixed(1)}%</div>
          <div style={{ fontSize: 8, color: TEXT, marginTop: 2 }}>σ(Δ·5)</div>
        </div>
      </div>

      {/* ── Section 2: Brain Region Heatmap (10×10) ───────────────────── */}
      <div style={{ ...panelStyle, marginBottom: 10 }}>
        <div style={sectionTitle}>⊕ Brain Region Heatmap — 100 Regions</div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(10, 1fr)', gap: 3 }}>
          {necState.regions.map(r => {
            const hue = Math.round(200 - r.activation * 200);
            const opacity = 1 - r.deficit * 0.6;
            const isHovered = hoveredRegion === r.id;
            return (
              <div
                key={r.id}
                onMouseEnter={() => setHoveredRegion(r.id)}
                onMouseLeave={() => setHoveredRegion(null)}
                title={`${r.name}\nActivation: ${r.activation.toFixed(3)}\nSpike: ${r.lif.spikeRate.toFixed(1)} Hz\nLFP: ${r.lfp.toFixed(1)} μV\nPhase: ${r.apPhase}`}
                style={{
                  background: `hsl(${hue}, 90%, 40%)`,
                  opacity,
                  borderRadius: 2,
                  height: 24,
                  position: 'relative',
                  cursor: 'default',
                  border: isHovered ? `1px solid #fff` : '1px solid transparent',
                  transition: 'background 0.3s ease',
                  display: 'flex',
                  alignItems: 'flex-end',
                  justifyContent: 'flex-end',
                  padding: 1,
                }}
              >
                {/* Category dot */}
                <div style={{ width: 4, height: 4, borderRadius: '50%', background: CAT_COLOR[r.category], flexShrink: 0 }} />
              </div>
            );
          })}
        </div>
        {/* Legend */}
        <div style={{ display: 'flex', gap: 16, marginTop: 8, fontSize: 8 }}>
          {(Object.keys(CAT_COLOR) as RegionCategory[]).map(cat => (
            <span key={cat} style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
              <span style={{ width: 6, height: 6, borderRadius: '50%', background: CAT_COLOR[cat], display: 'inline-block' }} />
              {cat}
            </span>
          ))}
          <span style={{ marginLeft: 'auto', color: '#3a6080' }}>
            {hoveredRegion !== null ? necState.regions.find(r => r.id === hoveredRegion)?.name : 'Hover for details'}
          </span>
        </div>
      </div>

      {/* ── Section 3: Three-column panels ───────────────────────────── */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8, marginBottom: 10 }}>

        {/* Left: Frequency Band Spectrogram */}
        <div style={panelStyle}>
          <div style={sectionTitle}>∿ Frequency Bands</div>
          {BAND_META.map(b => {
            const val = summary.bandMeans[b.key as keyof typeof summary.bandMeans];
            return (
              <div key={b.key} style={{ marginBottom: 8 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9, color: TEXT, marginBottom: 2 }}>
                  <span>{b.label}</span>
                  <span style={{ color: ACCENT }}>{(val * 100).toFixed(1)}%</span>
                </div>
                <div style={{ height: 14, background: '#0c1828', borderRadius: 3, overflow: 'hidden' }}>
                  <div style={{
                    width: `${(val * 100).toFixed(1)}%`,
                    height: '100%',
                    background: b.color,
                    transition: 'width 0.4s ease',
                    display: 'flex',
                    alignItems: 'center',
                    paddingLeft: 4,
                  }} />
                </div>
              </div>
            );
          })}
        </div>

        {/* Center: Neurochemical Panel */}
        <div style={panelStyle}>
          <div style={sectionTitle}>⊛ Neurochemicals</div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0 12px' }}>
            {CHEM_KEYS.map((key: ChemKey) => {
              const val = necState.chem[key] as number;
              return (
                <MiniBar
                  key={key}
                  label={key}
                  value={val}
                  color={`hsl(${Math.round(val * 140 + 180)}, 70%, 45%)`}
                />
              );
            })}
          </div>
        </div>

        {/* Right: White Matter Connectivity SVG */}
        <div style={panelStyle}>
          <div style={sectionTitle}>◈ White Matter Connectivity</div>
          <div style={{ position: 'relative' }}>
            <svg
              width="100%"
              viewBox="0 0 400 200"
              style={{ background: '#030810', borderRadius: 3, display: 'block' }}
            >
              {/* Region dots */}
              {necState.regions.map(r => {
                const [x, y] = regionXY(r.id);
                return (
                  <circle
                    key={r.id}
                    cx={x} cy={y} r={2.5}
                    fill={CAT_COLOR[r.category]}
                    opacity={0.5}
                  />
                );
              })}

              {/* Fiber tracts */}
              {necState.tracts.map(t => {
                const isHov = hoveredTract === t.id;
                return (
                  <path
                    key={t.id}
                    d={tractPath(t)}
                    fill="none"
                    stroke={tractColor(t.signalStrength)}
                    strokeWidth={isHov ? 2.5 : 1.2}
                    strokeOpacity={isHov ? 1 : 0.7}
                    style={{ cursor: 'pointer', transition: 'stroke-width 0.2s' }}
                    onMouseEnter={() => setHoveredTract(t.id)}
                    onMouseLeave={() => setHoveredTract(null)}
                  >
                    <title>{t.name} — strength: {t.signalStrength.toFixed(3)}</title>
                  </path>
                );
              })}
            </svg>

            {/* Hovered tract label */}
            {hoveredTract !== null && (() => {
              const t = necState.tracts.find(tr => tr.id === hoveredTract);
              return t ? (
                <div style={{ fontSize: 8, color: ACCENT, marginTop: 4 }}>
                  {t.name} — {t.signalStrength.toFixed(3)} signal
                </div>
              ) : null;
            })()}

            {/* Tract list */}
            <div style={{ marginTop: 6 }}>
              {necState.tracts.map(t => (
                <div key={t.id} style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 2 }}>
                  <div style={{ width: 8, height: 2, background: tractColor(t.signalStrength), borderRadius: 1 }} />
                  <span style={{ fontSize: 8, color: TEXT, opacity: 0.7 }}>{t.name}</span>
                  <span style={{ fontSize: 8, color: ACCENT, marginLeft: 'auto' }}>{t.signalStrength.toFixed(2)}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* ── Section 4: Bottom Row ─────────────────────────────────────── */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8 }}>

        {/* Voltage / LFP Sparkline */}
        <div style={panelStyle}>
          <div style={sectionTitle}>∿ LFP Timeline (last 30 ticks)</div>
          <Sparkline data={lfpHistory.current} width={300} height={60} color="#4af" />
          <div style={{ fontSize: 8, color: '#3a6080', marginTop: 4 }}>
            Mean LFP: {summary.meanLFP.toFixed(2)} μV
          </div>
        </div>

        {/* Spike Rate per Category */}
        <div style={panelStyle}>
          <div style={sectionTitle}>⚡ Spike Rate by Category</div>
          {catSpikeRates.map(({ cat, mean }) => (
            <div key={cat} style={{ marginBottom: 5 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9, color: TEXT, marginBottom: 2 }}>
                <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
                  <span style={{ width: 6, height: 6, borderRadius: '50%', background: CAT_COLOR[cat], display: 'inline-block' }} />
                  {cat}
                </span>
                <span style={{ color: ACCENT }}>{mean.toFixed(1)} Hz</span>
              </div>
              <div style={{ height: 8, background: '#0c1828', borderRadius: 2, overflow: 'hidden' }}>
                <div style={{
                  width: `${((mean / maxSpikeRate) * 100).toFixed(1)}%`,
                  height: '100%',
                  background: CAT_COLOR[cat],
                  transition: 'width 0.4s ease',
                }} />
              </div>
            </div>
          ))}
        </div>

        {/* Ion Channel State */}
        <div style={panelStyle}>
          <div style={sectionTitle}>⊡ Ion Channel Conductances</div>
          <MiniBar label="Na⁺ (Sodium)"    value={meanChannels.na} color="#ff6b6b" />
          <MiniBar label="K⁺  (Potassium)" value={meanChannels.k}  color="#ffd93d" />
          <MiniBar label="Ca²⁺ (Calcium)"  value={meanChannels.ca} color="#6bcb77" />
          <MiniBar label="Cl⁻  (Chloride)" value={meanChannels.cl} color="#4d96ff" />
          <div style={{ fontSize: 8, color: '#3a6080', marginTop: 8 }}>
            Mean conductances across all 100 regions
          </div>
        </div>
      </div>

      {/* Footer */}
      <div style={{ marginTop: 10, fontSize: 7, color: '#246', textAlign: 'center' }}>
        NOVA · NEC Brain Simulation · © 2024-2026 Alfredo Medina Hernandez · Beat {necState.beat} · dt=0.873s
      </div>
    </div>
  );
}
