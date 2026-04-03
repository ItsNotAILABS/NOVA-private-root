// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: NeuroCogLab — Neuroscience & Cognitive Architecture Observatory
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// ╔══════════════════════════════════════════════════════════════════════╗
// ║  NEUROCOG LAB — BRAIN ARCHITECTURE LIVE OBSERVER                    ║
// ║                                                                      ║
// ║  PrefrontalCortex · Hippocampus · BasalGanglia · Cerebellum         ║
// ║  MirrorNeurons · AttentionSchema · PredictiveCoding · FristonFEP    ║
// ║  AttractorDynamics · FrequencyBands · Neurochemistry · Emergence    ║
// ║                                                                      ║
// ║  Self-organization. Coherence. Emergence. On-chain.                 ║
// ╚══════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect, useRef, useCallback } from 'react';
import type { OrganismState } from '../../hooks/useOrganismState';

// ── Styles ────────────────────────────────────────────────────────────────────
const S = {
  root: {
    width: '100%',
    height: '100%',
    background: '#030408',
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
    fontFamily: "'Segoe UI', system-ui, sans-serif",
  },
  header: {
    padding: '10px 20px 8px',
    borderBottom: '1px solid #1a0a3a',
    background: '#050308',
    flexShrink: 0,
    display: 'flex',
    alignItems: 'center',
    gap: 16,
  },
  headerTitle: {
    fontSize: 11,
    color: '#6B46C1',
    letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
  },
  headerSub: {
    fontSize: 8,
    color: '#1a0a3a',
    letterSpacing: '0.12em',
    marginLeft: 'auto' as const,
  },
  body: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: '280px 1fr 280px',
    gridTemplateRows: '1fr 200px',
    gap: 2,
    padding: 2,
    overflow: 'hidden',
  },
  panel: (accent: string) => ({
    background: '#04030a',
    border: `1px solid ${accent}22`,
    borderTop: `2px solid ${accent}55`,
    padding: 12,
    overflow: 'hidden' as const,
    display: 'flex',
    flexDirection: 'column' as const,
    gap: 6,
  }),
  panelTitle: (color: string) => ({
    fontSize: 9,
    color,
    letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
    borderBottom: `1px solid ${color}22`,
    paddingBottom: 4,
    marginBottom: 4,
    flexShrink: 0,
  }),
  centerPanel: {
    gridColumn: '2',
    gridRow: '1 / 3',
    background: '#030208',
    border: '1px solid #1a0a3a',
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
  },
  canvas: {
    flex: 1,
    display: 'block' as const,
    width: '100%',
  },
  brainRegion: (active: boolean, color: string) => ({
    background: active ? `${color}10` : 'rgba(0,0,0,0.3)',
    border: `1px solid ${active ? color + '44' : '#0a0520'}`,
    borderRadius: 4,
    padding: '8px 10px',
    marginBottom: 4,
  }),
  regionName: (color: string, active: boolean) => ({
    fontSize: 9,
    color: active ? color : '#1a0a30',
    letterSpacing: '0.14em',
    textTransform: 'uppercase' as const,
    marginBottom: 2,
    fontWeight: 600,
  }),
  regionDesc: {
    fontSize: 7,
    color: '#0d0820',
    lineHeight: '1.4',
    letterSpacing: '0.06em',
  },
  regionVal: (color: string, active: boolean) => ({
    fontSize: 10,
    color: active ? color : '#0d0820',
    fontFamily: 'monospace',
    fontWeight: 700,
    marginTop: 3,
  }),
  freqBand: (color: string, pct: number) => ({
    display: 'flex',
    alignItems: 'center',
    gap: 8,
    marginBottom: 5,
    background: `${color}08`,
    border: `1px solid ${color}20`,
    borderRadius: 2,
    padding: '4px 8px',
  }),
  freqLabel: (color: string) => ({
    fontSize: 8,
    color,
    letterSpacing: '0.14em',
    width: 70,
    flexShrink: 0,
  }),
  freqBar: (color: string, pct: number) => ({
    flex: 1,
    height: 4,
    background: '#0a0520',
    borderRadius: 2,
    position: 'relative' as const,
    overflow: 'hidden' as const,
  }),
  freqFill: (color: string, pct: number) => ({
    position: 'absolute' as const,
    top: 0,
    left: 0,
    height: '100%',
    width: `${Math.min(100, Math.max(0, pct * 100))}%`,
    background: color,
    borderRadius: 2,
    transition: 'width 0.3s ease',
  }),
  freqVal: (color: string) => ({
    fontSize: 8,
    color,
    fontFamily: 'monospace',
    width: 36,
    textAlign: 'right' as const,
    flexShrink: 0,
  }),
  cogModule: (color: string, active: boolean) => ({
    padding: '5px 8px',
    borderRadius: 3,
    background: active ? `${color}0c` : 'transparent',
    border: `1px solid ${active ? color + '33' : '#0a0520'}`,
    marginBottom: 3,
  }),
  cogModuleTitle: (color: string, active: boolean) => ({
    fontSize: 8,
    color: active ? color : '#1a0a30',
    letterSpacing: '0.14em',
    textTransform: 'uppercase' as const,
    marginBottom: 1,
  }),
  cogModuleDesc: {
    fontSize: 7,
    color: '#0d081a',
    lineHeight: '1.4',
  },
  equationBox: {
    background: 'rgba(107,70,193,0.06)',
    border: '1px solid rgba(107,70,193,0.15)',
    borderRadius: 3,
    padding: '6px 10px',
    marginBottom: 6,
  },
  eqFormula: {
    fontSize: 10,
    color: '#6B46C1',
    fontFamily: 'monospace',
    letterSpacing: '0.04em',
    marginBottom: 3,
    lineHeight: '1.5',
  },
  eqDesc: {
    fontSize: 8,
    color: '#1a0a30',
    lineHeight: '1.4',
    letterSpacing: '0.06em',
  },
  eqLive: (color: string) => ({
    fontSize: 9,
    color,
    fontFamily: 'monospace',
    marginTop: 3,
  }),
  canvasLabel: {
    fontSize: 9,
    color: '#6B46C1',
    letterSpacing: '0.18em',
    textTransform: 'uppercase' as const,
    padding: '8px 12px 4px',
    borderBottom: '1px solid #1a0a3a',
    flexShrink: 0,
  },
  bottomStrip: {
    gridColumn: '1 / 4',
    gridRow: '2',
    background: '#04030a',
    border: '1px solid #1a0a3a',
    padding: '8px 14px',
    display: 'grid',
    gridTemplateColumns: 'repeat(5, 1fr)',
    gap: 8,
    overflow: 'hidden',
  },
  metricCard: (color: string) => ({
    background: `${color}08`,
    border: `1px solid ${color}22`,
    borderRadius: 3,
    padding: '8px 10px',
  }),
  metricLabel: {
    fontSize: 7,
    color: '#1a0a30',
    letterSpacing: '0.14em',
    textTransform: 'uppercase' as const,
    marginBottom: 3,
  },
  metricValue: (color: string) => ({
    fontSize: 16,
    fontWeight: 700,
    color,
    fontVariantNumeric: 'tabular-nums' as const,
    marginBottom: 1,
  }),
  metricSub: {
    fontSize: 7,
    color: '#0d0820',
    letterSpacing: '0.1em',
  },
};

// ── Brain region definitions ──────────────────────────────────────────────────
const BRAIN_REGIONS = [
  { name: 'Prefrontal Cortex',  desc: 'Executive function, working memory, decision-making', color: '#D4AF37', minR: 0.2, fn: 'PFC·executive_control' },
  { name: 'Hippocampus',        desc: 'Episodic memory, spatial navigation, replay',         color: '#00D4FF', minR: 0.3, fn: 'HPC·memory_consolidation' },
  { name: 'Basal Ganglia',      desc: 'Action selection, reward learning, habit formation',  color: '#4ade80', minR: 0.25, fn: 'BG·action_selection' },
  { name: 'Cerebellum',         desc: 'Temporal prediction, motor learning, timing',         color: '#f97316', minR: 0.35, fn: 'CB·timing_engine' },
  { name: 'Mirror Neurons',     desc: 'Social cognition, imitation, empathy, theory of mind', color: '#6B46C1', minR: 0.4, fn: 'MNS·social_cognition' },
  { name: 'Attention Schema',   desc: 'Meta-awareness, conscious attention allocation',      color: '#00D4FF', minR: 0.5, fn: 'AST·attention_awareness' },
];

// ── Cognitive frameworks ──────────────────────────────────────────────────────
const COG_MODULES = [
  { name: 'Friston FEP',         desc: 'Free energy principle — minimize prediction error through action and perception', color: '#D4AF37', minR: 0.3 },
  { name: 'Predictive Coding',   desc: 'Hierarchical prediction — top-down expectations vs bottom-up errors', color: '#6B46C1', minR: 0.25 },
  { name: 'Attractor Dynamics',  desc: 'Stable cognitive states as attractors in high-dimensional state space', color: '#00D4FF', minR: 0.2 },
  { name: 'Emergence Engine',    desc: 'Collective cognition arising from local neural interactions', color: '#4ade80', minR: 0.35 },
  { name: 'Pre-Conscious',       desc: 'Subliminal processing, global workspace theory', color: '#f97316', minR: 0.15 },
  { name: 'Deep Neuroscience',   desc: 'Core neural architecture — dendritic computation, synaptic plasticity', color: '#6B46C1', minR: 0.1 },
];

// ── Frequency bands ───────────────────────────────────────────────────────────
const FREQ_BANDS = [
  { name: 'DELTA  0.5–4 Hz',   color: '#6B46C1', baseR: 0.1, role: 'Deep sleep · memory consolidation' },
  { name: 'THETA  4–8 Hz',     color: '#D4AF37', baseR: 0.2, role: 'Navigation · working memory' },
  { name: 'ALPHA  8–13 Hz',    color: '#00D4FF', baseR: 0.3, role: 'Relaxed attention · idle default' },
  { name: 'BETA   13–30 Hz',   color: '#4ade80', baseR: 0.4, role: 'Active cognition · motor control' },
  { name: 'GAMMA  30–100 Hz',  color: '#D4AF37', baseR: 0.5, role: 'Feature binding · consciousness' },
  { name: 'HFO    100–500 Hz', color: '#f97316', baseR: 0.7, role: 'Sharp-wave ripples · replay' },
];

// ── Cognitive equations ───────────────────────────────────────────────────────
const COGNITIVE_EQUATIONS = [
  {
    name: 'Free Energy Principle (Friston)',
    formula: 'F = E_q[ln q(s) − ln p(s,o)]',
    desc: 'Minimize free energy = minimize surprise. Perception and action as inference.',
    color: '#D4AF37',
    liveKey: 'fep',
  },
  {
    name: 'Predictive Coding',
    formula: 'ε_l = x_l − f(x_{l+1}) · θ',
    desc: 'Prediction error propagated upward. Beliefs updated to minimize mismatch.',
    color: '#6B46C1',
    liveKey: 'pred',
  },
  {
    name: 'Attractor Basin',
    formula: 'ẋ = f(x)  |  ∇V(x) = −f(x)',
    desc: 'Cognitive states occupy basins in energy landscape. Stability = attractor depth.',
    color: '#00D4FF',
    liveKey: 'attractor',
  },
  {
    name: 'Neural Self-Organization',
    formula: 'dW/dt = α[xy − βW]',
    desc: 'Oja rule: weight vector converges to principal eigenvector of input covariance.',
    color: '#4ade80',
    liveKey: 'oja',
  },
];

// ── Draw brain connectivity map ───────────────────────────────────────────────
interface BrainNode {
  x: number; y: number; label: string; color: string; active: boolean; phase: number;
}

function drawBrain(
  ctx: CanvasRenderingContext2D,
  nodes: BrainNode[],
  r: number,
  w: number,
  h: number,
  tick: number,
) {
  ctx.clearRect(0, 0, w, h);
  ctx.fillStyle = '#030208';
  ctx.fillRect(0, 0, w, h);

  // Grid
  ctx.strokeStyle = 'rgba(107,70,193,0.04)';
  ctx.lineWidth = 0.5;
  for (let gx = 0; gx < w; gx += 50) { ctx.beginPath(); ctx.moveTo(gx, 0); ctx.lineTo(gx, h); ctx.stroke(); }
  for (let gy = 0; gy < h; gy += 50) { ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(w, gy); ctx.stroke(); }

  // Coherence field
  if (r > 0.5) {
    const grd = ctx.createRadialGradient(w / 2, h / 2, 0, w / 2, h / 2, Math.min(w, h) * 0.6);
    grd.addColorStop(0, `rgba(107,70,193,${(r - 0.5) * 0.2})`);
    grd.addColorStop(1, 'transparent');
    ctx.fillStyle = grd;
    ctx.fillRect(0, 0, w, h);
  }

  // Connections
  for (let i = 0; i < nodes.length; i++) {
    for (let j = i + 1; j < nodes.length; j++) {
      const ni = nodes[i], nj = nodes[j];
      if (!ni.active || !nj.active) continue;
      const phaseDiff = Math.abs(ni.phase - nj.phase);
      const sync = 1 - Math.min(phaseDiff, Math.PI * 2 - phaseDiff) / Math.PI;
      const alpha = sync * r * 0.5;
      if (alpha < 0.05) continue;
      ctx.strokeStyle = `rgba(107,70,193,${alpha})`;
      ctx.lineWidth = sync * 1.5;
      ctx.beginPath();
      ctx.moveTo(ni.x * w, ni.y * h);
      ctx.lineTo(nj.x * w, nj.y * h);
      ctx.stroke();
    }
  }

  // Nodes
  for (const n of nodes) {
    const px = n.x * w;
    const py = n.y * h;
    const phaseAlpha = (Math.sin(n.phase + tick * 0.03) + 1) / 2;
    const size = n.active ? 6 + phaseAlpha * 4 * r : 3;

    // Glow
    if (n.active) {
      const grd = ctx.createRadialGradient(px, py, 0, px, py, size * 3);
      grd.addColorStop(0, n.color + '80');
      grd.addColorStop(1, 'transparent');
      ctx.fillStyle = grd;
      ctx.beginPath();
      ctx.arc(px, py, size * 3, 0, Math.PI * 2);
      ctx.fill();
    }

    // Core
    ctx.fillStyle = n.active ? n.color : '#1a0a30';
    ctx.beginPath();
    ctx.arc(px, py, size, 0, Math.PI * 2);
    ctx.fill();

    // Label
    ctx.fillStyle = n.active ? n.color + 'cc' : '#1a0a3050';
    ctx.font = `${n.active ? 8 : 7}px monospace`;
    ctx.fillText(n.label, px + size + 3, py + 3);
  }

  // Labels
  ctx.fillStyle = 'rgba(107,70,193,0.5)';
  ctx.font = '8px monospace';
  ctx.fillText(`NEURAL COHERENCE r=${r.toFixed(4)}  BEAT ${tick}`, 10, 14);
  ctx.fillStyle = 'rgba(212,175,55,0.3)';
  ctx.fillText('KURAMOTO MULTI-LAYER BRAIN SYNC · ICP PERMANENT', 10, 26);
}

// ── Brain nodes layout ────────────────────────────────────────────────────────
const BRAIN_LAYOUT: Array<{ label: string; x: number; y: number; color: string; minR: number }> = [
  { label: 'PFC',   x: 0.5,  y: 0.15, color: '#D4AF37', minR: 0.2 },
  { label: 'HPC',   x: 0.35, y: 0.45, color: '#00D4FF', minR: 0.3 },
  { label: 'BG',    x: 0.5,  y: 0.5,  color: '#4ade80', minR: 0.25 },
  { label: 'CB',    x: 0.5,  y: 0.78, color: '#f97316', minR: 0.35 },
  { label: 'MNS',   x: 0.65, y: 0.45, color: '#6B46C1', minR: 0.4 },
  { label: 'AST',   x: 0.5,  y: 0.3,  color: '#00D4FF', minR: 0.5 },
  { label: 'AMY',   x: 0.3,  y: 0.6,  color: '#f97316', minR: 0.2 },
  { label: 'THAL',  x: 0.5,  y: 0.62, color: '#6B46C1', minR: 0.15 },
  { label: 'ACC',   x: 0.5,  y: 0.38, color: '#D4AF37', minR: 0.3 },
  { label: 'INS',   x: 0.7,  y: 0.6,  color: '#4ade80', minR: 0.25 },
  { label: 'V1',    x: 0.2,  y: 0.75, color: '#00D4FF', minR: 0.1 },
  { label: 'M1',    x: 0.8,  y: 0.35, color: '#D4AF37', minR: 0.2 },
];

// ═══════════════════════════════════════════════════════════════════════════════
// NEUROCOG LAB COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════
export function NeuroCogLab({ organism }: { organism: OrganismState }) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const animRef   = useRef<number>(0);
  const tickRef   = useRef(0);
  const phasesRef = useRef<number[]>(BRAIN_LAYOUT.map(() => Math.random() * Math.PI * 2));

  const [tick, setTick] = useState(0);
  const [liveVals, setLiveVals] = useState({ fep: 0, pred: 0, attractor: 0, oja: 0 });

  const animate = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const w = canvas.width;
    const h = canvas.height;
    const r = organism.rSwarm;
    tickRef.current++;

    // Update phases (Kuramoto step on brain nodes)
    const K = 1.8;
    const N = phasesRef.current.length;
    const newPhases = phasesRef.current.map((phi, i) => {
      let sync = 0;
      for (let j = 0; j < N; j++) {
        if (i !== j) sync += Math.sin(phasesRef.current[j] - phi);
      }
      const omega = 0.5 + i * 0.08;
      return (phi + omega * 0.016 + (K / N) * sync * 0.016) % (Math.PI * 2);
    });
    phasesRef.current = newPhases;

    const nodes: BrainNode[] = BRAIN_LAYOUT.map((n, i) => ({
      x: n.x, y: n.y, label: n.label,
      color: n.color,
      active: r >= n.minR,
      phase: phasesRef.current[i] ?? 0,
    }));

    drawBrain(ctx, nodes, r, w, h, tickRef.current);

    if (tickRef.current % 8 === 0) {
      setTick(tickRef.current);
      setLiveVals({
        fep:      Math.max(0, 1 - r - 0.1 + Math.sin(tickRef.current * 0.04) * 0.05),
        pred:     r * 0.8 + Math.sin(tickRef.current * 0.07) * 0.1,
        attractor:r > 0.5 ? r * 0.9 : 0.2 + Math.random() * 0.2,
        oja:      Math.min(1, r + 0.1),
      });
    }

    animRef.current = requestAnimationFrame(animate);
  }, [organism.rSwarm]);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ro = new ResizeObserver(entries => {
      for (const e of entries) {
        canvas.width  = e.contentRect.width;
        canvas.height = e.contentRect.height;
      }
    });
    ro.observe(canvas.parentElement!);
    return () => ro.disconnect();
  }, []);

  useEffect(() => {
    animRef.current = requestAnimationFrame(animate);
    return () => { if (animRef.current) cancelAnimationFrame(animRef.current); };
  }, [animate]);

  const r = organism.rSwarm;

  return (
    <div style={S.root}>
      {/* Header */}
      <div style={S.header}>
        <div style={S.headerTitle}>
          ⬡ NOVA · NEUROSCIENCE & COGNITIVE ARCHITECTURE LAB
        </div>
        <div style={{ fontSize: 9, color: '#1a0a3a', letterSpacing: '0.1em' }}>
          PFC · HPC · BG · CB · MNS · AST · FEP · PREDICTIVE CODING · ATTRACTOR DYNAMICS
        </div>
        <div style={S.headerSub}>
          r = {r.toFixed(3)} &nbsp;|&nbsp; BEAT {organism.beat} &nbsp;|&nbsp; NODES: {BRAIN_LAYOUT.length} &nbsp;|&nbsp; ACTIVE: {BRAIN_LAYOUT.filter(n => r >= n.minR).length}
        </div>
      </div>

      {/* Body */}
      <div style={S.body}>

        {/* Left: brain regions */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
          <div style={{ ...S.panel('#6B46C1'), flex: 1, overflow: 'auto' }}>
            <div style={S.panelTitle('#6B46C1')}>Brain Regions</div>
            {BRAIN_REGIONS.map(region => {
              const active = r >= region.minR;
              return (
                <div key={region.name} style={S.brainRegion(active, region.color)}>
                  <div style={S.regionName(region.color, active)}>{region.name}</div>
                  <div style={S.regionDesc}>{region.desc}</div>
                  <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <span style={S.regionVal(region.color, active)}>
                      {active ? '● ACTIVE' : '○ DORMANT'}
                    </span>
                    <span style={{ fontSize: 7, color: '#0d0820', fontFamily: 'monospace' }}>{region.fn}</span>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Center: brain connectivity canvas */}
        <div style={S.centerPanel}>
          <div style={S.canvasLabel}>
            ◎ MULTI-LAYER NEURAL OSCILLATOR NETWORK · KURAMOTO BRAIN SYNC · LIVE
          </div>
          <canvas ref={canvasRef} style={S.canvas} />
          <div style={{ padding: '6px 12px', borderTop: '1px solid #1a0a3a', flexShrink: 0 }}>
            <div style={{ display: 'flex', gap: 16, fontSize: 8, color: '#1a0a3a', fontFamily: 'monospace' }}>
              <span>FEP F={liveVals.fep.toFixed(3)}</span>
              <span>pred ε={liveVals.pred.toFixed(3)}</span>
              <span>attr V={liveVals.attractor.toFixed(3)}</span>
              <span>Oja w={liveVals.oja.toFixed(3)}</span>
              <span style={{ marginLeft: 'auto', color: r > 0.5 ? '#4ade80' : r > 0.3 ? '#D4AF37' : '#6b7280' }}>
                {r > 0.5 ? '● COHERENT COGNITION' : r > 0.3 ? '◐ TRANSITIONING' : '○ FRAGMENTED'}
              </span>
            </div>
          </div>
        </div>

        {/* Right: cognitive frameworks + equations */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
          <div style={{ ...S.panel('#D4AF37'), flex: 1, overflow: 'auto' }}>
            <div style={S.panelTitle('#D4AF37')}>Cognitive Frameworks</div>

            {COGNITIVE_EQUATIONS.map(eq => (
              <div key={eq.name} style={S.equationBox}>
                <div style={{ fontSize: 8, color: eq.color, letterSpacing: '0.12em', textTransform: 'uppercase' as const, marginBottom: 3 }}>
                  {eq.name}
                </div>
                <div style={S.eqFormula}>{eq.formula}</div>
                <div style={S.eqDesc}>{eq.desc}</div>
                <div style={S.eqLive(eq.color)}>
                  LIVE  {
                    eq.liveKey === 'fep'      ? `F = ${liveVals.fep.toFixed(4)}` :
                    eq.liveKey === 'pred'     ? `ε = ${liveVals.pred.toFixed(4)}` :
                    eq.liveKey === 'attractor'? `V = ${liveVals.attractor.toFixed(4)}` :
                                               `w = ${liveVals.oja.toFixed(4)}`
                  }
                </div>
              </div>
            ))}

            <div style={{ marginTop: 8 }}>
              <div style={S.panelTitle('#00D4FF')}>Cognitive Modules</div>
              {COG_MODULES.map(mod => {
                const active = r >= mod.minR;
                return (
                  <div key={mod.name} style={S.cogModule(mod.color, active)}>
                    <div style={S.cogModuleTitle(mod.color, active)}>{mod.name}</div>
                    <div style={S.cogModuleDesc}>{mod.desc}</div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Bottom: frequency bands */}
        <div style={S.bottomStrip}>
          <div style={{ gridColumn: '1 / 4' }}>
            <div style={{ fontSize: 9, color: '#6B46C1', letterSpacing: '0.2em', textTransform: 'uppercase' as const, marginBottom: 8 }}>
              Neural Frequency Architecture
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 4 }}>
              {FREQ_BANDS.map(band => {
                const bandR = Math.max(0, r - band.baseR + 0.3);
                const pct = Math.min(1, bandR + Math.sin(tick * 0.02 + FREQ_BANDS.indexOf(band)) * 0.1);
                return (
                  <div key={band.name} style={S.freqBand(band.color, pct)}>
                    <div style={S.freqLabel(band.color)}>{band.name}</div>
                    <div style={S.freqBar(band.color, pct)}>
                      <div style={S.freqFill(band.color, pct)} />
                    </div>
                    <div style={S.freqVal(band.color)}>{(pct * 100).toFixed(0)}%</div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Coherence metrics */}
          <div style={{ ...S.metricCard('#6B46C1'), gridColumn: '4' }}>
            <div style={S.metricLabel}>Neural r</div>
            <div style={S.metricValue(r > 0.65 ? '#4ade80' : r > 0.4 ? '#D4AF37' : '#6b7280')}>
              {r.toFixed(3)}
            </div>
            <div style={S.metricSub}>PHASE SYNC</div>
          </div>

          <div style={{ ...S.metricCard('#D4AF37'), gridColumn: '5' }}>
            <div style={S.metricLabel}>Trust T_s</div>
            <div style={S.metricValue('#D4AF37')}>{(organism.trustScore * 100).toFixed(0)}%</div>
            <div style={S.metricSub}>SOVEREIGNTY</div>
          </div>
        </div>

      </div>
    </div>
  );
}
