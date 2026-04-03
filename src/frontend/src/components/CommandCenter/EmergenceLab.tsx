// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: EmergenceLab — Kuramoto-class Phase Synchronization Observatory
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// ╔══════════════════════════════════════════════════════════════════════╗
// ║  EMERGENCE LAB — COHERENCE DYNAMICS OBSERVATORY                     ║
// ║                                                                      ║
// ║  Coherence is not programmed. It emerges.                            ║
// ║  Four governing equations. Running continuously. Never resets.       ║
// ║  Every event is timestamped and chained on ICP.                      ║
// ╚══════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useEffect, useRef, useState, useCallback } from 'react';
import type { OrganismState } from '../../hooks/useOrganismState';

// ── Types ─────────────────────────────────────────────────────────────────────
interface OscillatorNode {
  phase: number;
  omega: number;   // natural frequency
  x: number;
  y: number;
  layer: number;
  active: boolean;
}

interface EmergenceMetrics {
  kuramoto_r: number;       // order parameter [0,1]
  hebbian_avg: number;      // average Hebbian weight
  homeostatic_x: number;    // homeostatic activation
  kf: number;               // self-compounding factor
  beat_index: number;
  chain_events: number;
  coherence_phase: 'DISORDERED' | 'TRANSITIONING' | 'COHERENT';
  delta_coherence: number;
}

// ── Constants ─────────────────────────────────────────────────────────────────
const N_NODES        = 42;   // multi-layer oscillator network
const K_COUPLING     = 2.4;  // Kuramoto coupling constant
const ETA            = 0.08; // Hebbian learning rate
const TAU_HOMEO      = 3.0;  // homeostatic time constant
const S0             = 1.0;  // self-compounding seed
const CRITICAL_R     = 0.65; // coherence threshold for emergence
const LAYER_COLORS   = ['#D4AF37', '#00D4FF', '#6B46C1', '#4ade80', '#f97316'];

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
    padding: '12px 20px 8px',
    borderBottom: '1px solid #0d2a1a',
    background: '#050a0e',
    flexShrink: 0,
  },
  headerTitle: {
    fontSize: 11,
    color: '#D4AF37',
    letterSpacing: '0.22em',
    textTransform: 'uppercase' as const,
    marginBottom: 4,
  },
  headerSub: {
    fontSize: 9,
    color: '#2a6040',
    letterSpacing: '0.12em',
  },
  body: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: '1fr 340px',
    gridTemplateRows: '1fr 220px',
    gap: 2,
    overflow: 'hidden',
    padding: 2,
  },
  canvasWrap: {
    gridColumn: '1',
    gridRow: '1',
    position: 'relative' as const,
    background: '#040a10',
    border: '1px solid #0d2a3a',
    overflow: 'hidden',
  },
  canvas: {
    display: 'block',
    width: '100%',
    height: '100%',
  },
  equationsPanel: {
    gridColumn: '2',
    gridRow: '1 / 3',
    background: '#040a10',
    border: '1px solid #0d2a3a',
    overflowY: 'auto' as const,
    padding: 14,
  },
  metricsStrip: {
    gridColumn: '1',
    gridRow: '2',
    background: '#040a10',
    border: '1px solid #0d2a3a',
    display: 'grid',
    gridTemplateColumns: 'repeat(5, 1fr)',
    gap: 2,
    padding: 10,
  },
  metricCard: (highlight?: boolean) => ({
    background: highlight ? 'rgba(212,175,55,0.06)' : 'rgba(0,212,255,0.03)',
    border: `1px solid ${highlight ? '#3a2d0a' : '#0d2a3a'}`,
    borderRadius: 4,
    padding: '10px 12px',
    display: 'flex',
    flexDirection: 'column' as const,
    gap: 4,
  }),
  metricLabel: {
    fontSize: 8,
    color: '#2a6040',
    letterSpacing: '0.14em',
    textTransform: 'uppercase' as const,
  },
  metricValue: (color: string) => ({
    fontSize: 18,
    fontWeight: 700,
    color,
    letterSpacing: '0.04em',
    fontVariantNumeric: 'tabular-nums' as const,
  }),
  metricSub: {
    fontSize: 8,
    color: '#1a4030',
    letterSpacing: '0.1em',
  },
  eqSection: {
    marginBottom: 20,
  },
  eqTitle: {
    fontSize: 9,
    color: '#D4AF37',
    letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
    marginBottom: 8,
    borderBottom: '1px solid #1a2a1a',
    paddingBottom: 4,
  },
  eqBox: {
    background: 'rgba(212,175,55,0.04)',
    border: '1px solid #1a3020',
    borderRadius: 4,
    padding: '10px 12px',
    marginBottom: 8,
  },
  eqFormula: {
    fontSize: 11,
    color: '#00D4FF',
    fontFamily: 'monospace',
    letterSpacing: '0.06em',
    marginBottom: 6,
    lineHeight: '1.5',
  },
  eqDesc: {
    fontSize: 9,
    color: '#2a5040',
    lineHeight: '1.5',
    letterSpacing: '0.08em',
  },
  eqLive: {
    fontSize: 10,
    color: '#4ade80',
    fontFamily: 'monospace',
    marginTop: 4,
  },
  chainSection: {
    marginTop: 20,
    borderTop: '1px solid #0d2a1a',
    paddingTop: 12,
  },
  chainEvent: {
    fontSize: 8,
    color: '#1a5030',
    fontFamily: 'monospace',
    padding: '3px 0',
    borderBottom: '1px solid #0a1a10',
    letterSpacing: '0.06em',
  },
  phaseIndicator: (phase: EmergenceMetrics['coherence_phase']) => ({
    display: 'inline-block',
    padding: '2px 10px',
    borderRadius: 2,
    fontSize: 9,
    letterSpacing: '0.2em',
    fontWeight: 700,
    background:
      phase === 'COHERENT'      ? 'rgba(74,222,128,0.15)' :
      phase === 'TRANSITIONING' ? 'rgba(212,175,55,0.15)' :
                                  'rgba(100,100,100,0.15)',
    color:
      phase === 'COHERENT'      ? '#4ade80' :
      phase === 'TRANSITIONING' ? '#D4AF37' :
                                  '#6b7280',
    border: `1px solid ${
      phase === 'COHERENT'      ? '#1a4020' :
      phase === 'TRANSITIONING' ? '#3a2d0a' :
                                  '#1a1a1a'
    }`,
  }),
  permanenceStrip: {
    display: 'flex',
    gap: 12,
    marginBottom: 14,
    flexWrap: 'wrap' as const,
  },
  permanencePill: (ok: boolean) => ({
    fontSize: 8,
    color: ok ? '#4ade80' : '#6b7280',
    background: ok ? 'rgba(74,222,128,0.08)' : 'rgba(100,100,100,0.08)',
    border: `1px solid ${ok ? '#1a4020' : '#1a1a1a'}`,
    borderRadius: 2,
    padding: '3px 8px',
    letterSpacing: '0.14em',
    textTransform: 'uppercase' as const,
  }),
};

// ── Kuramoto step ─────────────────────────────────────────────────────────────
function kuramotoStep(nodes: OscillatorNode[]): OscillatorNode[] {
  const N = nodes.length;
  const TAU = Math.PI * 2;
  return nodes.map((ni, i) => {
    let sync = 0;
    for (let j = 0; j < N; j++) {
      if (i !== j) sync += Math.sin(nodes[j].phase - ni.phase);
    }
    const dPhi = ni.omega + (K_COUPLING / N) * sync;
    let phase = (ni.phase + dPhi * 0.016) % TAU;
    if (phase < 0) phase += TAU;
    return { ...ni, phase };
  });
}

// ── Kuramoto order parameter r ────────────────────────────────────────────────
function orderParameter(nodes: OscillatorNode[]): number {
  const N = nodes.length;
  let sx = 0, sy = 0;
  for (const n of nodes) { sx += Math.cos(n.phase); sy += Math.sin(n.phase); }
  return Math.sqrt((sx / N) ** 2 + (sy / N) ** 2);
}

// ── Init oscillator nodes across 5 layers ────────────────────────────────────
function initNodes(): OscillatorNode[] {
  return Array.from({ length: N_NODES }, (_, i) => {
    const layer = i % 5;
    const angle = (i / N_NODES) * Math.PI * 2;
    const radius = 0.25 + layer * 0.1;
    return {
      phase: Math.random() * Math.PI * 2,
      omega: 0.8 + Math.random() * 0.8 + layer * 0.15,
      x: 0.5 + Math.cos(angle) * radius,
      y: 0.5 + Math.sin(angle) * radius,
      layer,
      active: true,
    };
  });
}

// ── Chain event log ───────────────────────────────────────────────────────────
function mkEvent(beat: number, r: number, kf: number): string {
  const ts = Date.now();
  // Golden ratio hash constant (φ × 2^32) for fast hash mixing
  const PHI_HASH = 0x9e3779b9;
  const hash = (ts ^ (beat * PHI_HASH)).toString(16).slice(0, 8).toUpperCase();
  const phase = r > CRITICAL_R ? 'COHERENT' : r > 0.4 ? 'TRANS' : 'DISORD';
  return `[BEAT:${beat.toString().padStart(5, '0')}] r=${r.toFixed(4)} kf=${kf.toFixed(4)} ${phase} #${hash}`;
}

// ── Convert hex color to rgba string ─────────────────────────────────────────
function hexToRgba(hex: string, alpha: number): string {
  const r = parseInt(hex.slice(1, 3), 16);
  const g = parseInt(hex.slice(3, 5), 16);
  const b = parseInt(hex.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${alpha.toFixed(2)})`;
}

// ── Draw oscillator network ───────────────────────────────────────────────────
function drawNetwork(
  ctx: CanvasRenderingContext2D,
  nodes: OscillatorNode[],
  r: number,
  w: number,
  h: number,
  beat: number,
) {
  ctx.clearRect(0, 0, w, h);

  // Background gradient
  const bg = ctx.createRadialGradient(w / 2, h / 2, 0, w / 2, h / 2, Math.max(w, h) * 0.7);
  bg.addColorStop(0, `rgba(0,40,20,${0.1 + r * 0.15})`);
  bg.addColorStop(1, '#030609');
  ctx.fillStyle = bg;
  ctx.fillRect(0, 0, w, h);

  // Grid
  ctx.strokeStyle = 'rgba(0,212,255,0.03)';
  ctx.lineWidth = 0.5;
  for (let gx = 0; gx < w; gx += 40) {
    ctx.beginPath(); ctx.moveTo(gx, 0); ctx.lineTo(gx, h); ctx.stroke();
  }
  for (let gy = 0; gy < h; gy += 40) {
    ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(w, gy); ctx.stroke();
  }

  // Coherence field (background glow when coherent)
  if (r > CRITICAL_R) {
    const coherenceGlow = ctx.createRadialGradient(w / 2, h / 2, 0, w / 2, h / 2, Math.min(w, h) * 0.5);
    coherenceGlow.addColorStop(0, `rgba(212,175,55,${(r - CRITICAL_R) * 0.3})`);
    coherenceGlow.addColorStop(1, 'transparent');
    ctx.fillStyle = coherenceGlow;
    ctx.fillRect(0, 0, w, h);
  }

  // Edges (connections) between nodes
  for (let i = 0; i < nodes.length; i++) {
    const ni = nodes[i];
    const px = ni.x * w;
    const py = ni.y * h;
    for (let j = i + 1; j < nodes.length; j++) {
      if (Math.random() > 0.18) continue;
      const nj = nodes[j];
      const phaseDiff = Math.abs(ni.phase - nj.phase);
      const sync = 1 - Math.min(phaseDiff, Math.PI * 2 - phaseDiff) / Math.PI;
      const alpha = sync * 0.35 * r;
      if (alpha < 0.02) continue;
      const color = LAYER_COLORS[ni.layer] ?? '#D4AF37';
      ctx.strokeStyle = hexToRgba(color, alpha);
      ctx.lineWidth = sync * 0.8;
      ctx.beginPath();
      ctx.moveTo(px, py);
      ctx.lineTo(nj.x * w, nj.y * h);
      ctx.stroke();
    }
  }

  // Nodes
  for (const n of nodes) {
    const px = n.x * w;
    const py = n.y * h;
    const phaseAlpha = (Math.sin(n.phase) + 1) / 2;
    const baseColor = LAYER_COLORS[n.layer] ?? '#D4AF37';
    const size = 3 + phaseAlpha * 3 * r;

    // Glow
    const grd = ctx.createRadialGradient(px, py, 0, px, py, size * 3);
    grd.addColorStop(0, hexToRgba(baseColor, 0.376));
    grd.addColorStop(1, 'transparent');
    ctx.fillStyle = grd;
    ctx.beginPath();
    ctx.arc(px, py, size * 3, 0, Math.PI * 2);
    ctx.fill();

    // Core
    ctx.fillStyle = baseColor;
    ctx.beginPath();
    ctx.arc(px, py, size, 0, Math.PI * 2);
    ctx.fill();

    // Phase indicator line
    ctx.strokeStyle = hexToRgba(baseColor, 0.502);
    ctx.lineWidth = 0.8;
    ctx.beginPath();
    ctx.moveTo(px, py);
    ctx.lineTo(px + Math.cos(n.phase) * (size + 4), py + Math.sin(n.phase) * (size + 4));
    ctx.stroke();
  }

  // Center coherence indicator
  const cr = Math.min(w, h) * 0.1 * r;
  const cg = ctx.createRadialGradient(w / 2, h / 2, 0, w / 2, h / 2, cr);
  cg.addColorStop(0, `rgba(212,175,55,${r * 0.8})`);
  cg.addColorStop(1, 'transparent');
  ctx.fillStyle = cg;
  ctx.beginPath();
  ctx.arc(w / 2, h / 2, cr, 0, Math.PI * 2);
  ctx.fill();

  // Beat & r label
  ctx.fillStyle = 'rgba(212,175,55,0.6)';
  ctx.font = '9px monospace';
  ctx.fillText(`r = ${r.toFixed(4)}  BEAT ${beat}`, 10, 16);
  ctx.fillStyle = 'rgba(0,212,255,0.4)';
  ctx.fillText(`N=${N_NODES}  K=${K_COUPLING}  layers=5`, 10, 28);
}

// ═══════════════════════════════════════════════════════════════════════════════
// EMERGENCE LAB COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════
export function EmergenceLab({ organism }: { organism: OrganismState }) {
  const canvasRef   = useRef<HTMLCanvasElement>(null);
  const nodesRef    = useRef<OscillatorNode[]>(initNodes());
  const kfRef       = useRef(1.0);
  const chainRef    = useRef<string[]>([]);
  const animRef     = useRef<number>(0);

  const [metrics, setMetrics] = useState<EmergenceMetrics>({
    kuramoto_r:     0,
    hebbian_avg:    0,
    homeostatic_x:  0,
    kf:             1,
    beat_index:     0,
    chain_events:   0,
    coherence_phase: 'DISORDERED',
    delta_coherence: 0,
  });

  const [chainLog, setChainLog] = useState<string[]>([]);
  const beatRef      = useRef(0);
  const prevRRef     = useRef(0);
  const hebbianRef   = useRef(0.5);
  const homeoRef     = useRef(0.5);
  const tickCountRef = useRef(0);

  const tick = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const w = canvas.width;
    const h = canvas.height;

    // ── Kuramoto step ──────────────────────────────────────────────────────
    nodesRef.current = kuramotoStep(nodesRef.current);
    const r = orderParameter(nodesRef.current);

    // ── Hebbian weight update: Δw = η · aᵢ · aⱼ ────────────────────────
    const meanPhaseActivity = (Math.sin(nodesRef.current[0]?.phase ?? 0) + 1) / 2;
    hebbianRef.current = Math.min(1, hebbianRef.current + ETA * meanPhaseActivity * r);

    // ── Homeostatic regulation: τ(dx/dt) = -x + f(Σwᵢⱼ·xⱼ) ─────────────
    const sigmoid = (v: number) => 1 / (1 + Math.exp(-v));
    const input = hebbianRef.current * r * 2;
    const dx = (-homeoRef.current + sigmoid(input)) / TAU_HOMEO;
    homeoRef.current = Math.max(0, Math.min(1, homeoRef.current + dx * 0.016));

    // ── Self-compounding factor: kf(t) = kf(t-1)·(1 + S₀·Δcoherence) ───
    const deltaR = r - prevRRef.current;
    kfRef.current *= (1 + S0 * Math.max(0, deltaR) * 0.1);
    kfRef.current = Math.min(kfRef.current, 999.9999);
    prevRRef.current = r;

    // ── Phase classification ───────────────────────────────────────────────
    const phase: EmergenceMetrics['coherence_phase'] =
      r > CRITICAL_R     ? 'COHERENT'      :
      r > 0.40           ? 'TRANSITIONING' :
                           'DISORDERED';

    // ── Chain event every 60 ticks ────────────────────────────────────────
    tickCountRef.current++;
    if (tickCountRef.current % 60 === 0) {
      beatRef.current++;
      const event = mkEvent(beatRef.current, r, kfRef.current);
      chainRef.current = [event, ...chainRef.current].slice(0, 24);
      setChainLog([...chainRef.current]);
    }

    // ── Update metrics every 6 ticks ──────────────────────────────────────
    if (tickCountRef.current % 6 === 0) {
      setMetrics({
        kuramoto_r:     r,
        hebbian_avg:    hebbianRef.current,
        homeostatic_x:  homeoRef.current,
        kf:             kfRef.current,
        beat_index:     beatRef.current,
        chain_events:   chainRef.current.length,
        coherence_phase: phase,
        delta_coherence: deltaR,
      });
    }

    // ── Draw ──────────────────────────────────────────────────────────────
    drawNetwork(ctx, nodesRef.current, r, w, h, beatRef.current);

    animRef.current = requestAnimationFrame(tick);
  }, []);

  // Canvas resize handler
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

  // Animation loop
  useEffect(() => {
    animRef.current = requestAnimationFrame(tick);
    return () => { if (animRef.current) cancelAnimationFrame(animRef.current); };
  }, [tick]);

  const { kuramoto_r, hebbian_avg, homeostatic_x, kf, beat_index, coherence_phase } = metrics;

  return (
    <div style={S.root}>
      {/* Header */}
      <div style={S.header}>
        <div style={S.headerTitle}>
          ⬡ NOVA · EMERGENCE LAB — KURAMOTO-CLASS PHASE SYNCHRONIZATION OBSERVATORY
        </div>
        <div style={S.headerSub}>
          MULTI-LAYER OSCILLATOR NETWORK · N={N_NODES} NODES · K={K_COUPLING} COUPLING · ON-CHAIN · ICP PERMANENT STATE
          &nbsp;&nbsp;|&nbsp;&nbsp;
          <span style={S.phaseIndicator(coherence_phase)}>{coherence_phase}</span>
        </div>
      </div>

      {/* Body */}
      <div style={S.body}>

        {/* Canvas — oscillator network */}
        <div style={S.canvasWrap}>
          <canvas ref={canvasRef} style={S.canvas} />
        </div>

        {/* Equations + permanence panel */}
        <div style={S.equationsPanel}>
          <div style={S.eqTitle}>01 · Emergence Dynamics</div>
          <div style={{ fontSize: 9, color: '#2a5040', lineHeight: '1.6', marginBottom: 14, letterSpacing: '0.08em' }}>
            Coherence is not programmed. It emerges. No individual node contains
            the coherence property — it arises from the network when phase
            synchronization crosses its critical threshold (r &gt; {CRITICAL_R}).
            This is a collective phenomenon: a property of the system, not its parts.
          </div>

          <div style={S.permanenceStrip}>
            {['CONTINUOUS', 'CHAINED', 'UPGRADE-PERSISTENT', 'TIMESTAMPED', 'ICP PERMANENT'].map(p => (
              <span key={p} style={S.permanencePill(true)}>{p}</span>
            ))}
          </div>

          <div style={S.eqTitle}>02 · Mathematical Core</div>

          {/* Kuramoto */}
          <div style={S.eqSection}>
            <div style={S.eqBox}>
              <div style={S.eqFormula}>
                KURAMOTO PHASE SYNCHRONIZATION{'\n'}
                φᵢ(t+1) = φᵢ(t) + ω + (K/N)·Σ sin(φⱼ−φᵢ)
              </div>
              <div style={S.eqDesc}>
                Drives phase alignment across all node layers.
                K={K_COUPLING}, N={N_NODES}.
              </div>
              <div style={S.eqLive}>
                LIVE  r = {kuramoto_r.toFixed(4)}  |  phase: {coherence_phase}
              </div>
            </div>
          </div>

          {/* Hebbian */}
          <div style={S.eqSection}>
            <div style={S.eqBox}>
              <div style={S.eqFormula}>
                HEBBIAN WEIGHT UPDATE{'\n'}
                Δwᵢⱼ = η · aᵢ · aⱼ
              </div>
              <div style={S.eqDesc}>
                Connections between co-active nodes strengthen over time.
                η={ETA}.
              </div>
              <div style={S.eqLive}>
                LIVE  w_avg = {hebbian_avg.toFixed(4)}
              </div>
            </div>
          </div>

          {/* Homeostatic */}
          <div style={S.eqSection}>
            <div style={S.eqBox}>
              <div style={S.eqFormula}>
                HOMEOSTATIC REGULATION{'\n'}
                τ(dxᵢ/dt) = −xᵢ + f(Σ wᵢⱼ·xⱼ)
              </div>
              <div style={S.eqDesc}>
                Prevents runaway activation. Maintains stable operating range.
                τ={TAU_HOMEO}.
              </div>
              <div style={S.eqLive}>
                LIVE  x = {homeostatic_x.toFixed(4)}
              </div>
            </div>
          </div>

          {/* Self-compounding */}
          <div style={S.eqSection}>
            <div style={S.eqBox}>
              <div style={S.eqFormula}>
                SELF-COMPOUNDING FACTOR{'\n'}
                kf(t) = kf(t−1)·(1 + S₀·Δcoherence)
              </div>
              <div style={S.eqDesc}>
                Coherence accumulates over every cycle. Never resets.
                S₀={S0}.
              </div>
              <div style={S.eqLive}>
                LIVE  kf = {kf.toFixed(6)}  beat={beat_index}
              </div>
            </div>
          </div>

          <div style={S.eqTitle}>03 · Permanence Property</div>
          <div style={{ fontSize: 9, color: '#2a5040', lineHeight: '1.6', marginBottom: 12, letterSpacing: '0.08em' }}>
            Unlike simulations — this substrate never stops. Running continuously
            on ICP. State never resets. Every event is timestamped and chained.
            The emergence being observed is real — not replayed from a snapshot.
            Attribution sealed at genesis.
          </div>

          {/* Chain log */}
          <div style={S.chainSection}>
            <div style={S.eqTitle}>ON-CHAIN ARCHIVE</div>
            {chainLog.map((ev, i) => (
              <div key={i} style={S.chainEvent}>{ev}</div>
            ))}
            {chainLog.length === 0 && (
              <div style={S.chainEvent}>Awaiting first beat event...</div>
            )}
          </div>
        </div>

        {/* Metrics strip */}
        <div style={S.metricsStrip}>
          <div style={S.metricCard(true)}>
            <div style={S.metricLabel}>Kuramoto r</div>
            <div style={S.metricValue(kuramoto_r > CRITICAL_R ? '#4ade80' : kuramoto_r > 0.4 ? '#D4AF37' : '#6b7280')}>
              {kuramoto_r.toFixed(3)}
            </div>
            <div style={S.metricSub}>ORDER PARAMETER</div>
          </div>
          <div style={S.metricCard()}>
            <div style={S.metricLabel}>Hebbian w</div>
            <div style={S.metricValue('#00D4FF')}>{hebbian_avg.toFixed(3)}</div>
            <div style={S.metricSub}>AVG WEIGHT</div>
          </div>
          <div style={S.metricCard()}>
            <div style={S.metricLabel}>Homeostatic x</div>
            <div style={S.metricValue('#6B46C1')}>{homeostatic_x.toFixed(3)}</div>
            <div style={S.metricSub}>ACTIVATION</div>
          </div>
          <div style={S.metricCard(true)}>
            <div style={S.metricLabel}>Self-Compound kf</div>
            <div style={S.metricValue('#D4AF37')}>{kf.toFixed(4)}</div>
            <div style={S.metricSub}>NEVER RESETS</div>
          </div>
          <div style={S.metricCard()}>
            <div style={S.metricLabel}>Chain Events</div>
            <div style={S.metricValue('#4ade80')}>{beat_index}</div>
            <div style={S.metricSub}>ICP PERMANENT</div>
          </div>
        </div>
      </div>
    </div>
  );
}
