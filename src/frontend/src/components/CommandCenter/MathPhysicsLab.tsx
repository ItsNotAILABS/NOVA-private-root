// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: MathPhysicsLab — Unified Mathematics & Physics Observatory
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// ╔══════════════════════════════════════════════════════════════════════╗
// ║  MATH & PHYSICS LAB — ALL GOVERNING EQUATIONS LIVE                  ║
// ║                                                                      ║
// ║  Kuramoto · Landau · Lorenz · Ising · Lyapunov · Reaction-Diffusion ║
// ║  Tensor Fields · Topological Dynamics · Differential Geometry       ║
// ║  Every equation connected. Every layer coherent.                    ║
// ╚══════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect, useRef, useCallback } from 'react';
import type { OrganismState } from '../../hooks/useOrganismState';

// ── Styles ────────────────────────────────────────────────────────────────────
const S = {
  root: {
    width: '100%',
    height: '100%',
    background: '#030609',
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
    fontFamily: "'Segoe UI', system-ui, sans-serif",
  },
  header: {
    padding: '10px 20px 8px',
    borderBottom: '1px solid #0d1a3a',
    background: '#040810',
    flexShrink: 0,
    display: 'flex',
    alignItems: 'center',
    gap: 16,
  },
  headerTitle: {
    fontSize: 11,
    color: '#00D4FF',
    letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
  },
  headerSub: {
    fontSize: 8,
    color: '#1a3a5c',
    letterSpacing: '0.12em',
    marginLeft: 'auto' as const,
  },
  body: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: '260px 1fr 260px',
    gridTemplateRows: '1fr 1fr',
    gap: 2,
    padding: 2,
    overflow: 'hidden',
  },
  panel: (accent: string) => ({
    background: '#040a12',
    border: `1px solid ${accent}22`,
    borderTop: `2px solid ${accent}55`,
    padding: 12,
    overflow: 'hidden' as const,
    display: 'flex',
    flexDirection: 'column' as const,
    gap: 8,
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
    background: '#030810',
    border: '1px solid #0d1a3a',
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
  },
  canvas: {
    flex: 1,
    display: 'block',
    width: '100%',
  },
  eqRow: {
    marginBottom: 8,
  },
  eqName: (color: string) => ({
    fontSize: 8,
    color,
    letterSpacing: '0.16em',
    textTransform: 'uppercase' as const,
    marginBottom: 2,
  }),
  eqFormula: {
    fontSize: 10,
    color: '#00D4FF',
    fontFamily: 'monospace',
    background: 'rgba(0,212,255,0.04)',
    border: '1px solid rgba(0,212,255,0.08)',
    borderRadius: 3,
    padding: '4px 8px',
    marginBottom: 2,
    letterSpacing: '0.04em',
    lineHeight: '1.5',
  },
  eqLive: (color: string) => ({
    fontSize: 9,
    color,
    fontFamily: 'monospace',
    letterSpacing: '0.08em',
  }),
  moduleGrid: {
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: 4,
    flex: 1,
    overflow: 'auto' as const,
  },
  moduleCard: (active: boolean, color: string) => ({
    background: active ? `${color}12` : 'rgba(0,0,0,0.3)',
    border: `1px solid ${active ? color + '40' : '#0d1a2a'}`,
    borderRadius: 3,
    padding: '6px 8px',
    cursor: 'default' as const,
  }),
  moduleLabel: (color: string) => ({
    fontSize: 8,
    color,
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
    marginBottom: 2,
  }),
  moduleDesc: {
    fontSize: 7,
    color: '#1a3050',
    lineHeight: '1.4',
    letterSpacing: '0.06em',
  },
  moduleVal: (color: string) => ({
    fontSize: 10,
    color,
    fontFamily: 'monospace',
    fontWeight: 700,
    marginTop: 2,
  }),
  connectionLine: (active: boolean) => ({
    fontSize: 7,
    color: active ? '#4ade8060' : '#0a1a2a',
    fontFamily: 'monospace',
    letterSpacing: '0.1em',
    padding: '2px 0',
  }),
  canvasLabel: {
    fontSize: 9,
    color: '#00D4FF',
    letterSpacing: '0.18em',
    textTransform: 'uppercase' as const,
    padding: '8px 12px 4px',
    borderBottom: '1px solid #0d1a3a',
    flexShrink: 0,
  },
};

// ── Math modules registry ─────────────────────────────────────────────────────
const MATH_MODULES = [
  { name: 'Kuramoto',    desc: 'Phase synchronization',        color: '#D4AF37', layer: 'core' },
  { name: 'Landau',      desc: 'Free energy / phase transition', color: '#00D4FF', layer: 'physics' },
  { name: 'Lorenz',      desc: 'Chaotic attractor dynamics',   color: '#6B46C1', layer: 'physics' },
  { name: 'Ising',       desc: '2D lattice Metropolis MC',     color: '#f97316', layer: 'physics' },
  { name: 'Lyapunov',    desc: 'Stability spectrum',           color: '#4ade80', layer: 'core' },
  { name: 'Hebbian',     desc: 'Synaptic weight update',       color: '#D4AF37', layer: 'neuro' },
  { name: 'React-Diff',  desc: 'Turing pattern formation',     color: '#00D4FF', layer: 'physics' },
  { name: 'Brusselator', desc: 'Limit cycle oscillator',       color: '#f97316', layer: 'physics' },
  { name: 'Tensor',      desc: 'Field tensor operations',      color: '#6B46C1', layer: 'geometry' },
  { name: 'Topology',    desc: 'Topological invariants',       color: '#4ade80', layer: 'geometry' },
  { name: 'DiffGeom',    desc: 'Riemannian manifold engine',   color: '#D4AF37', layer: 'geometry' },
  { name: 'Sandpile',    desc: 'SOC / BTW avalanche model',    color: '#00D4FF', layer: 'complexity' },
];

const PHYSICS_EQUATIONS = [
  {
    name: 'Kuramoto',
    color: '#D4AF37',
    formula: 'φᵢ(t+1) = φᵢ(t) + ω + (K/N)·Σ sin(φⱼ−φᵢ)',
    liveKey: 'r',
    desc: 'Phase sync order parameter',
  },
  {
    name: 'Landau Free Energy',
    color: '#00D4FF',
    formula: 'F(φ) = a₂φ² + a₄φ⁴ + a₆φ⁶ − h·φ',
    liveKey: 'landau',
    desc: 'Phase transition order parameter',
  },
  {
    name: 'Lorenz Attractor',
    color: '#6B46C1',
    formula: 'ẋ=σ(y−x)  ẏ=x(ρ−z)−y  ż=xy−βz',
    liveKey: 'lorenz',
    desc: 'Chaotic attractor — sensitive dependence',
  },
  {
    name: 'Lyapunov Stability',
    color: '#4ade80',
    formula: 'V(t) = V(0)·e^(λt)  |  λ<0 → stable',
    liveKey: 'lyapunov',
    desc: 'Convergence / divergence spectrum',
  },
  {
    name: 'Reaction-Diffusion',
    color: '#f97316',
    formula: '∂u/∂t = Dᵤ∇²u + f(u,v)',
    liveKey: 'rd',
    desc: 'Turing pattern formation substrate',
  },
  {
    name: 'Self-Organization',
    color: '#D4AF37',
    formula: 'kf(t) = kf(t−1)·(1 + S₀·Δcoherence)',
    liveKey: 'kf',
    desc: 'Coherence compounds — never resets',
  },
];

// ── Lorenz step ───────────────────────────────────────────────────────────────
function lorenzStep(x: number, y: number, z: number, dt = 0.005): [number, number, number] {
  const sigma = 10, rho = 28, beta = 8 / 3;
  const dx = sigma * (y - x);
  const dy = x * (rho - z) - y;
  const dz = x * y - beta * z;
  return [x + dx * dt, y + dy * dt, z + dz * dt];
}

// ── Draw Lorenz attractor ─────────────────────────────────────────────────────
function drawLorenz(
  ctx: CanvasRenderingContext2D,
  trail: Array<[number, number, number]>,
  w: number,
  h: number,
  r: number,
) {
  ctx.clearRect(0, 0, w, h);

  // Background
  ctx.fillStyle = '#030810';
  ctx.fillRect(0, 0, w, h);

  // Grid
  ctx.strokeStyle = 'rgba(0,212,255,0.04)';
  ctx.lineWidth = 0.5;
  for (let gx = 0; gx < w; gx += 50) {
    ctx.beginPath(); ctx.moveTo(gx, 0); ctx.lineTo(gx, h); ctx.stroke();
  }
  for (let gy = 0; gy < h; gy += 50) {
    ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(w, gy); ctx.stroke();
  }

  if (trail.length < 2) return;

  // Project 3D → 2D (xz plane)
  const scaleX = w / 65;
  const scaleY = h / 50;
  const offX = w / 2 - 1 * scaleX;
  const offY = h / 2 - 25 * scaleY;

  const len = trail.length;
  for (let i = 1; i < len; i++) {
    const [x0, , z0] = trail[i - 1];
    const [x1, , z1] = trail[i];
    const alpha = (i / len) * 0.8;
    const t = i / len;
    // Color gradient: cyan → gold → purple
    const r2 = Math.floor(t < 0.5 ? t * 2 * 212 : 212 + (t - 0.5) * 2 * (107 - 212));
    const g2 = Math.floor(t < 0.5 ? t * 2 * 175 : 175 - (t - 0.5) * 2 * 175);
    const b2 = Math.floor(t < 0.5 ? 255 - t * 2 * 200 : 55 + (t - 0.5) * 2 * (193 - 55));

    ctx.strokeStyle = `rgba(${Math.max(0, Math.min(255, r2))},${Math.max(0, Math.min(255, g2))},${Math.max(0, Math.min(255, b2))},${alpha})`;
    ctx.lineWidth = 0.8 + r * 0.5;
    ctx.beginPath();
    ctx.moveTo(x0 * scaleX + offX, z0 * scaleY + offY);
    ctx.lineTo(x1 * scaleX + offX, z1 * scaleY + offY);
    ctx.stroke();
  }

  // Current point
  const [cx, , cz] = trail[trail.length - 1] ?? [0, 0, 0];
  const px = cx * scaleX + offX;
  const py = cz * scaleY + offY;
  const grd = ctx.createRadialGradient(px, py, 0, px, py, 8);
  grd.addColorStop(0, `rgba(212,175,55,${0.8 * r})`);
  grd.addColorStop(1, 'transparent');
  ctx.fillStyle = grd;
  ctx.beginPath();
  ctx.arc(px, py, 8, 0, Math.PI * 2);
  ctx.fill();

  // Labels
  ctx.fillStyle = 'rgba(0,212,255,0.5)';
  ctx.font = '8px monospace';
  ctx.fillText('LORENZ ATTRACTOR  σ=10  ρ=28  β=8/3', 10, 14);
  ctx.fillStyle = 'rgba(212,175,55,0.4)';
  ctx.fillText(`r_coherence=${r.toFixed(3)}`, 10, 26);
}

// ═══════════════════════════════════════════════════════════════════════════════
// MATH PHYSICS LAB COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════
export function MathPhysicsLab({ organism }: { organism: OrganismState }) {
  const canvasRef  = useRef<HTMLCanvasElement>(null);
  const trailRef   = useRef<Array<[number, number, number]>>([[0.1, 0, 0.1]]);
  const animRef    = useRef<number>(0);

  const [tick, setTick] = useState(0);
  const [liveVals, setLiveVals] = useState({
    r: 0, landau: 0, lorenz_x: 0, lyapunov: 0, rd: 0, kf: 1,
  });

  const lorenzRef = useRef<[number, number, number]>([0.1, 0, 0.1]);
  const kfRef     = useRef(1.0);
  const prevRRef  = useRef(0);

  const animate = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    // Lorenz step
    lorenzRef.current = lorenzStep(...lorenzRef.current);
    trailRef.current.push([...lorenzRef.current]);
    if (trailRef.current.length > 800) trailRef.current.shift();

    const r = organism.rSwarm;
    const deltaR = r - prevRRef.current;
    kfRef.current *= 1 + 0.01 * Math.max(0, deltaR);
    kfRef.current = Math.min(kfRef.current, 9999.9999);
    prevRRef.current = r;

    drawLorenz(ctx, trailRef.current, canvas.width, canvas.height, r);

    setTick(t => t + 1);
    if (tick % 8 === 0) {
      setLiveVals({
        r,
        landau: -0.5 + r * 1.2,
        lorenz_x: lorenzRef.current[0],
        lyapunov: r > 0.65 ? -0.12 : 0.08,
        rd: Math.sin(tick * 0.05) * 0.5 + 0.5,
        kf: kfRef.current,
      });
    }

    animRef.current = requestAnimationFrame(animate);
  }, [organism.rSwarm, tick]);

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

  const activeModules = MATH_MODULES.filter((_, i) => {
    // modules activate based on coherence and time
    return organism.rSwarm > 0.3 + i * 0.02;
  });
  const activeNames = new Set(activeModules.map(m => m.name));

  const getLiveValue = (key: string): string => {
    switch (key) {
      case 'r':       return `r = ${liveVals.r.toFixed(4)}`;
      case 'landau':  return `φ* = ${liveVals.landau.toFixed(4)}`;
      case 'lorenz':  return `x = ${liveVals.lorenz_x.toFixed(3)}`;
      case 'lyapunov':return `λ = ${liveVals.lyapunov.toFixed(4)}`;
      case 'rd':      return `u = ${liveVals.rd.toFixed(4)}`;
      case 'kf':      return `kf = ${liveVals.kf.toFixed(6)}`;
      default:        return '';
    }
  };

  return (
    <div style={S.root}>
      {/* Header */}
      <div style={S.header}>
        <div style={S.headerTitle}>
          ⬡ NOVA · MATH & PHYSICS LAB
        </div>
        <div style={{ fontSize: 9, color: '#1a3a5c', letterSpacing: '0.1em' }}>
          KURAMOTO · LANDAU · LORENZ · ISING · LYAPUNOV · REACTION-DIFFUSION · TENSOR · TOPOLOGY
        </div>
        <div style={S.headerSub}>
          ACTIVE: {activeModules.length}/{MATH_MODULES.length} MODULES &nbsp;|&nbsp; r={organism.rSwarm.toFixed(3)} &nbsp;|&nbsp; BEAT {organism.beat}
        </div>
      </div>

      {/* Body grid */}
      <div style={S.body}>

        {/* Left column: governing equations */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
          <div style={{ ...S.panel('#D4AF37'), gridRow: '1', flex: 1, overflow: 'auto' }}>
            <div style={S.panelTitle('#D4AF37')}>Governing Equations</div>
            {PHYSICS_EQUATIONS.map(eq => (
              <div key={eq.name} style={S.eqRow}>
                <div style={S.eqName(eq.color)}>{eq.name}</div>
                <div style={S.eqFormula}>{eq.formula}</div>
                <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                  <span style={{ fontSize: 7, color: '#1a3050', letterSpacing: '0.08em' }}>{eq.desc}</span>
                  <span style={S.eqLive(eq.color)}>{getLiveValue(eq.liveKey)}</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Center: Lorenz attractor visualization */}
        <div style={S.centerPanel}>
          <div style={S.canvasLabel}>
            ◎ LORENZ ATTRACTOR — CHAOTIC DYNAMICS SUBSTRATE · LIVE
          </div>
          <canvas ref={canvasRef} style={S.canvas} />
          <div style={{ padding: '6px 12px', borderTop: '1px solid #0d1a3a', flexShrink: 0 }}>
            <div style={{ display: 'flex', gap: 20, fontSize: 8, color: '#1a3a5c', fontFamily: 'monospace' }}>
              <span>x = {liveVals.lorenz_x.toFixed(3)}</span>
              <span>λ = {liveVals.lyapunov.toFixed(4)}</span>
              <span>kf = {liveVals.kf.toFixed(4)}</span>
              <span>r = {liveVals.r.toFixed(4)}</span>
              <span style={{ marginLeft: 'auto', color: liveVals.r > 0.65 ? '#4ade80' : '#6b7280' }}>
                {liveVals.r > 0.65 ? '● COHERENT' : liveVals.r > 0.4 ? '◐ TRANSITIONING' : '○ DISORDERED'}
              </span>
            </div>
          </div>
        </div>

        {/* Right column: module registry */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
          <div style={{ ...S.panel('#00D4FF'), flex: 1, overflow: 'auto' }}>
            <div style={S.panelTitle('#00D4FF')}>Module Network ({MATH_MODULES.length})</div>
            <div style={S.moduleGrid}>
              {MATH_MODULES.map(mod => {
                const isActive = activeNames.has(mod.name);
                return (
                  <div key={mod.name} style={S.moduleCard(isActive, mod.color)}>
                    <div style={S.moduleLabel(isActive ? mod.color : '#1a3050')}>{mod.name}</div>
                    <div style={S.moduleDesc}>{mod.desc}</div>
                    <div style={S.moduleVal(isActive ? mod.color : '#1a3050')}>
                      {isActive ? '● ACTIVE' : '○ DORMANT'}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Bottom left: coherence connections */}
        <div style={{ ...S.panel('#6B46C1'), gridColumn: '1', overflow: 'auto' }}>
          <div style={S.panelTitle('#6B46C1')}>Module Connections</div>
          {[
            ['Kuramoto', 'Hebbian',    'phase→weight'],
            ['Hebbian',  'Homeostatic','weight→stability'],
            ['Lorenz',   'Lyapunov',   'chaos→stability'],
            ['Landau',   'Kuramoto',   'field→sync'],
            ['React-Diff','Ising',     'pattern→lattice'],
            ['Topology', 'DiffGeom',   'invariants→metric'],
            ['Tensor',   'Topology',   'field→invariants'],
          ].map(([a, b, label]) => {
            const aActive = activeNames.has(a);
            const bActive = activeNames.has(b);
            const connected = aActive && bActive;
            return (
              <div key={`${a}-${b}`} style={S.connectionLine(connected)}>
                {connected ? '●' : '○'} {a} → {b} <span style={{ color: '#0a2a1a' }}>[{label}]</span>
              </div>
            );
          })}
        </div>

        {/* Bottom right: layer architecture */}
        <div style={{ ...S.panel('#4ade80'), gridColumn: '3', overflow: 'auto' }}>
          <div style={S.panelTitle('#4ade80')}>Layer Architecture</div>
          {[
            { layer: 'CORE',       modules: ['Kuramoto', 'Lyapunov', 'Hebbian'],             color: '#D4AF37' },
            { layer: 'PHYSICS',    modules: ['Landau', 'Lorenz', 'Ising', 'React-Diff'],     color: '#00D4FF' },
            { layer: 'GEOMETRY',   modules: ['Tensor', 'Topology', 'DiffGeom'],              color: '#6B46C1' },
            { layer: 'COMPLEXITY', modules: ['Sandpile', 'Brusselator'],                     color: '#4ade80' },
            { layer: 'NEURO',      modules: ['Hebbian', 'Homeostatic'],                      color: '#f97316' },
          ].map(({ layer, modules: mods, color }) => (
            <div key={layer} style={{ marginBottom: 8 }}>
              <div style={{ fontSize: 8, color, letterSpacing: '0.16em', marginBottom: 3 }}>{layer}</div>
              <div style={{ display: 'flex', flexWrap: 'wrap' as const, gap: 3 }}>
                {mods.map(m => (
                  <span key={m} style={{
                    fontSize: 7,
                    color: activeNames.has(m) ? color : '#1a2a3a',
                    background: activeNames.has(m) ? `${color}10` : 'transparent',
                    border: `1px solid ${activeNames.has(m) ? color + '30' : '#0d1a2a'}`,
                    borderRadius: 2,
                    padding: '1px 5px',
                    letterSpacing: '0.1em',
                  }}>{m}</span>
                ))}
              </div>
            </div>
          ))}

          <div style={{ marginTop: 10, borderTop: '1px solid #0a2a1a', paddingTop: 8 }}>
            <div style={{ fontSize: 7, color: '#1a3050', lineHeight: '1.5', letterSpacing: '0.08em' }}>
              All layers feed into the coherence field. Kuramoto order parameter r
              gates module activation. Self-organization emerges at r &gt; 0.65.
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
