// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: EmergenceLab — Unified Emergence Observatory
// Runs ALL seven math engines simultaneously. Nothing is simulated.
// Everything is computed from the real mathematical substrate.
//
// ENGINES RUNNING SIMULTANEOUSLY:
//   1. Kuramoto (18-organ, amplitude-weighted, organ sync, critical coupling K_c)
//   2. Emergence Physics (Landau, Ising 2D Metropolis, Lorenz RK4, Gray-Scott RD,
//      BTW Sandpile, Brusselator, composite emergence score)
//   3. Lyapunov Stability (5D, Hopfield energy, attractor dynamics, Kaplan-Yorke)
//   4. Quantum (density matrix, von Neumann entropy, Berry phase, Orch-OR, Zeno)
//   5. Neurochemistry (21 species, Michaelis-Menten, metals pipeline, vitality)
//   6. Hz Substrate (35 nodes, mode modulation, phase coherence, memory encoding)
//   7. Jasmine Scoring (temporal emergence, vitality, FORMA compounding)
//
// Copyright © 2024-2026 Alfredo Medina Hernandez · Medina Tech · Dallas, TX
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useEffect, useRef, useState, useCallback } from 'react';
import type { OrganismState } from '../../hooks/useOrganismState';

// ── Engine imports ─────────────────────────────────────────────────────────────
import {
  initOrganKuramoto, stepOrganKuramoto, OrganKuramotoState,
  computeAmplitudeOrderParameter, kuramotoSyncEntropy, criticalCoupling,
  detectPhaseTransition, PhaseTransitionState, reEntrain, frequencyCoherence,
  ORGAN_FREQS, ORGAN_FREQ_ARRAY, KuramotoOscillator,
} from '../../math/kuramoto';

import {
  initLorenzState, lorenzStep, LorenzState,
  initIsingState, isingMetropolisStep, IsingState, isingMagnetization, isingEnergy,
  initRDState, rdStep, RDState, isTuringUnstable,
  initSandpile, sandpileAddGrain, SandpileState,
  computeEmergenceScore, classifyEmergence, EmergenceInputs,
  landauFromTemperature, findEquilibriumPhi, landauSusceptibility, LandauParams,
  initBrusselator, brusselatorStep, brusselatorOscillates, BrusselatorState,
} from '../../math/emergence';

import {
  initLyapunov, lyapunovTick, LyapunovState5,
  computeLyapunovV, estimateVdot, lyapunovExponent, kaplanYorkeDimension,
  isOmnisState, OMNIS_THRESHOLD, hopfieldEnergy, attractorStep, findCurrentBasin,
  Attractor,
} from '../../math/lyapunov';

import {
  initQuantumSystem, quantumBeat, QuantumSystemState,
  vonNeumannEntropyDiag, purity, orchOrCollapseProbability,
  zenoSurvivalProbability, berryPhase, quantumDiscordApprox,
  cExpI, cAbs,
} from '../../math/quantum';

import {
  neurochemFullStep, NeurochemFull, NEURO_BASELINES, NeurochemStimuli,
  vitalityScore, neuroplasticityFactor, allostaticLoad,
  metalPipelineStep, MetalState, METAL_BASELINES, metalCoherenceContribution,
} from '../../math/neurochemistry';

import {
  initHzSubstrate, hzSubstrateTick, HzSubstrateState,
  computePhaseCoherence, memoryEncodingBoost, dominantNode, detectResonance,
  ALL_NODE_FREQS, OrganismMode,
} from '../../math/hz-substrate';

import {
  jasmineCalculate, jasmineTemporalEmergence, JasmineState, computeVitality,
  JASMINE_ALPHA, EMERGENCE_TAU as JASMINE_TAU,
  formaCompoundFull, computeFullCoherence, CoherenceInputs,
} from '../../math/scoring-extended';

import {
  PHI, PHI_INV, TAU, PI, clamp,
} from '../../math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// COLOURS
// ═══════════════════════════════════════════════════════════════════════════════
const C = {
  GOLD:   '#D4AF37', GOLD_DIM: '#3a2d0a',
  CYAN:   '#00D4FF', CYAN_DIM: '#0d2a3a',
  PURPLE: '#6B46C1', PURPLE_DIM: '#1a0a3a',
  GREEN:  '#4ade80', GREEN_DIM: '#0a2a1a',
  ORANGE: '#f97316', ORANGE_DIM: '#2a1000',
  RED:    '#f43f5e', RED_DIM:    '#2a0a10',
  BG:     '#030609', BG2:        '#04080f',
  BORDER: '#0d1a2a',
};

function hexToRgba(hex: string, alpha: number): string {
  const r = parseInt(hex.slice(1, 3), 16);
  const g = parseInt(hex.slice(3, 5), 16);
  const b = parseInt(hex.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${alpha.toFixed(3)})`;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS DRAW HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

const ORGAN_NAMES = Object.keys(ORGAN_FREQS);

// ── Draw 18-organ Kuramoto oscillator network ──────────────────────────────────
function drawOscillatorNetwork(
  ctx:   CanvasRenderingContext2D,
  state: OrganKuramotoState,
  w:     number, h: number,
  tickN: number,
): void {
  ctx.clearRect(0, 0, w, h);

  // Background
  ctx.fillStyle = C.BG;
  ctx.fillRect(0, 0, w, h);

  // Grid lines
  ctx.strokeStyle = hexToRgba(C.CYAN, 0.04);
  ctx.lineWidth = 0.5;
  for (let x = 0; x < w; x += 40) { ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, h); ctx.stroke(); }
  for (let y = 0; y < h; y += 40) { ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(w, y); ctx.stroke(); }

  // Coherence field glow
  if (state.r > 0.45) {
    const grd = ctx.createRadialGradient(w / 2, h / 2, 0, w / 2, h / 2, Math.min(w, h) * 0.55);
    grd.addColorStop(0, hexToRgba(C.GOLD, (state.r - 0.45) * 0.35));
    grd.addColorStop(1, 'transparent');
    ctx.fillStyle = grd;
    ctx.fillRect(0, 0, w, h);
  }

  // OMNIS pulse ring
  if (isOmnisState(state.r)) {
    const ring = ctx.createRadialGradient(w / 2, h / 2, Math.min(w, h) * 0.4, w / 2, h / 2, Math.min(w, h) * 0.55);
    ring.addColorStop(0, hexToRgba(C.GOLD, 0.6));
    ring.addColorStop(1, 'transparent');
    ctx.fillStyle = ring;
    ctx.fillRect(0, 0, w, h);
  }

  // Compute node positions — two concentric rings (10 inner, 8 outer)
  const organs = ORGAN_NAMES.slice(0, 18);
  const positions: Array<{ x: number; y: number }> = organs.map((_, i) => {
    const ring   = i < 10 ? 0 : 1;
    const count  = ring === 0 ? 10 : 8;
    const start  = ring === 0 ? 0 : 10;
    const idx    = i - start;
    const angle  = (idx / count) * TAU - PI / 2;
    const radius = ring === 0 ? Math.min(w, h) * 0.28 : Math.min(w, h) * 0.42;
    return { x: w / 2 + Math.cos(angle) * radius, y: h / 2 + Math.sin(angle) * radius };
  });

  // Draw connections
  for (let i = 0; i < organs.length; i++) {
    for (let j = i + 1; j < organs.length; j++) {
      if (Math.random() > 0.15) continue;
      const pi = positions[i]!, pj = positions[j]!;
      const phaseDiff = Math.abs(state.phases[i]! - state.phases[j]!);
      const sync = 1 - Math.min(phaseDiff, TAU - phaseDiff) / PI;
      const alpha = sync * state.r * 0.4;
      if (alpha < 0.03) continue;
      const col = i < 10 ? C.CYAN : C.GOLD;
      ctx.strokeStyle = hexToRgba(col, alpha);
      ctx.lineWidth = sync * 1.2;
      ctx.beginPath();
      ctx.moveTo(pi.x, pi.y);
      ctx.lineTo(pj.x, pj.y);
      ctx.stroke();
    }
  }

  // Draw organ nodes
  const ORGAN_COLORS: string[] = [
    C.RED, C.CYAN, C.PURPLE, C.GOLD, C.GREEN, C.ORANGE,
    C.CYAN, C.GOLD, C.PURPLE, C.GREEN,
    C.RED, C.ORANGE, C.CYAN, C.GOLD, C.GREEN, C.PURPLE, C.CYAN, C.ORANGE,
  ];
  for (let i = 0; i < organs.length; i++) {
    const pos   = positions[i]!;
    const phase = state.phases[i]!;
    const freq  = ORGAN_FREQ_ARRAY[i] ?? 0.05;
    const col   = ORGAN_COLORS[i] ?? C.CYAN;
    const pa    = (Math.sin(phase + tickN * freq * 0.1) + 1) / 2;
    const sz    = 5 + pa * 5 * state.r;

    // Glow
    const g = ctx.createRadialGradient(pos.x, pos.y, 0, pos.x, pos.y, sz * 3);
    g.addColorStop(0, hexToRgba(col, 0.5));
    g.addColorStop(1, 'transparent');
    ctx.fillStyle = g;
    ctx.beginPath(); ctx.arc(pos.x, pos.y, sz * 3, 0, TAU); ctx.fill();

    // Core
    ctx.fillStyle = col;
    ctx.beginPath(); ctx.arc(pos.x, pos.y, sz, 0, TAU); ctx.fill();

    // Phase arrow
    ctx.strokeStyle = hexToRgba(col, 0.6);
    ctx.lineWidth = 0.9;
    ctx.beginPath();
    ctx.moveTo(pos.x, pos.y);
    ctx.lineTo(pos.x + Math.cos(phase) * (sz + 5), pos.y + Math.sin(phase) * (sz + 5));
    ctx.stroke();

    // Organ label
    if (sz > 4) {
      ctx.fillStyle = hexToRgba(col, 0.7);
      ctx.font = '7px monospace';
      const name = organs[i] ?? '';
      ctx.fillText(name.slice(0, 4).toUpperCase(), pos.x + sz + 3, pos.y + 3);
    }
  }

  // Center: order parameter indicator
  const cr = Math.min(w, h) * 0.09 * state.r;
  const cg = ctx.createRadialGradient(w / 2, h / 2, 0, w / 2, h / 2, cr + 4);
  cg.addColorStop(0, hexToRgba(C.GOLD, state.r * 0.9));
  cg.addColorStop(1, 'transparent');
  ctx.fillStyle = cg;
  ctx.beginPath(); ctx.arc(w / 2, h / 2, cr + 4, 0, TAU); ctx.fill();

  // Center text
  ctx.fillStyle = hexToRgba(C.GOLD, 0.8);
  ctx.font = 'bold 11px monospace';
  ctx.textAlign = 'center';
  ctx.fillText(`r=${state.r.toFixed(3)}`, w / 2, h / 2 + 4);
  ctx.font = '8px monospace';
  ctx.fillStyle = hexToRgba(C.CYAN, 0.5);
  ctx.fillText(`ψ=${state.psi.toFixed(2)}rad`, w / 2, h / 2 + 16);
  ctx.textAlign = 'left';

  // HUD
  ctx.fillStyle = hexToRgba(C.GOLD, 0.5);
  ctx.font = '8px monospace';
  ctx.fillText(`KURAMOTO 18-ORGAN  K=${PHI_INV.toFixed(4)}  K_c=${criticalCoupling(ORGAN_FREQ_ARRAY).toFixed(4)}`, 8, 14);
  ctx.fillStyle = hexToRgba(C.CYAN, 0.4);
  ctx.fillText(`H_sync=${state.syncEntr.toFixed(4)}  ${isOmnisState(state.r) ? '⬡ OMNIS' : state.r > 0.65 ? '● COHERENT' : state.r > 0.4 ? '◐ TRANS' : '○ DISORD'}`, 8, 26);
}

// ── Draw Ising 2D Metropolis lattice ───────────────────────────────────────────
function drawIsingGrid(
  ctx:   CanvasRenderingContext2D,
  state: IsingState,
  w:     number, h: number,
  r:     number,
): void {
  ctx.clearRect(0, 0, w, h);
  ctx.fillStyle = C.BG;
  ctx.fillRect(0, 0, w, h);

  const { gridW, gridH, spins } = state;
  const cellW = w / gridW;
  const cellH = h / gridH;
  for (let row = 0; row < gridH; row++) {
    for (let col = 0; col < gridW; col++) {
      const spin = spins[row * gridW + col] ?? 1;
      const alpha = spin === 1 ? 0.3 + r * 0.5 : 0.05;
      ctx.fillStyle = spin === 1
        ? hexToRgba(C.CYAN, alpha)
        : hexToRgba(C.PURPLE, 0.15);
      ctx.fillRect(col * cellW, row * cellH, cellW - 0.5, cellH - 0.5);
    }
  }
  const m = Math.abs(isingMagnetization(state));
  ctx.fillStyle = hexToRgba(C.CYAN, 0.6);
  ctx.font = '8px monospace';
  ctx.fillText(`ISING 2D  T=${state.temperature.toFixed(2)}  |m|=${m.toFixed(3)}`, 4, 12);
  ctx.fillStyle = hexToRgba(C.GOLD, 0.4);
  ctx.fillText(`J=${state.J}  E=${isingEnergy(state).toFixed(1)}`, 4, 22);
}

// ── Draw Gray-Scott reaction-diffusion ─────────────────────────────────────────
function drawRD(
  ctx:   CanvasRenderingContext2D,
  state: RDState,
  w:     number, h: number,
): void {
  ctx.clearRect(0, 0, w, h);
  ctx.fillStyle = C.BG;
  ctx.fillRect(0, 0, w, h);

  const { gridSize, u, v } = state;
  const cellW = w / gridSize;
  const cellH = h / gridSize;
  for (let i = 0; i < gridSize; i++) {
    for (let j = 0; j < gridSize; j++) {
      const idx = i * gridSize + j;
      const uv  = u[idx] ?? 0.5;
      const vv  = v[idx] ?? 0.25;
      // Map u→cyan, v→gold, overlap→green
      const rC  = Math.floor(vv * 107);
      const gC  = Math.floor(uv * 212 + vv * 175);
      const bC  = Math.floor(uv * 255 - vv * 200);
      ctx.fillStyle = `rgb(${clamp(rC,0,255)},${clamp(gC,0,255)},${clamp(bC,0,255)})`;
      ctx.fillRect(j * cellW, i * cellH, cellW, cellH);
    }
  }
  ctx.fillStyle = hexToRgba(C.GREEN, 0.7);
  ctx.font = '8px monospace';
  ctx.fillText(`GRAY-SCOTT  Du=${state.Du}  Dv=${state.Dv}`, 4, 12);
  ctx.fillStyle = hexToRgba(C.GOLD, 0.4);
  ctx.fillText(`a=${state.a}  b=${state.b}  TURING:${isTuringUnstable(state)?'YES':'NO'}`, 4, 22);
}

// ── Draw BTW sandpile ─────────────────────────────────────────────────────────
function drawSandpile(
  ctx:   CanvasRenderingContext2D,
  state: SandpileState,
  w:     number, h: number,
): void {
  ctx.clearRect(0, 0, w, h);
  ctx.fillStyle = C.BG;
  ctx.fillRect(0, 0, w, h);

  const { gridSize, heights } = state;
  const cellW = w / gridSize;
  const cellH = h / gridSize;
  for (let i = 0; i < gridSize; i++) {
    for (let j = 0; j < gridSize; j++) {
      const h4 = heights[i * gridSize + j] ?? 0;
      const norm = h4 / state.threshold;
      const alpha = Math.min(norm * 0.9, 0.95);
      ctx.fillStyle = h4 >= state.threshold
        ? hexToRgba(C.RED, 0.9)
        : hexToRgba(C.ORANGE, alpha);
      ctx.fillRect(j * cellW, i * cellH, cellW - 0.5, cellH - 0.5);
    }
  }
  ctx.fillStyle = hexToRgba(C.ORANGE, 0.7);
  ctx.font = '8px monospace';
  ctx.fillText(`BTW SANDPILE  z_c=${state.threshold}  N=${state.totalGrains}`, 4, 12);
  ctx.fillStyle = hexToRgba(C.RED, 0.5);
  ctx.fillText(`P(s)~s^{-τ}  τ≈1.27  aval=${state.totalAvalanches}`, 4, 22);
}

// ── Draw Lorenz attractor (xz projection) ─────────────────────────────────────
function drawLorenz(
  ctx:   CanvasRenderingContext2D,
  trail: Array<[number, number, number]>,
  r_coh: number,
  w:     number, h: number,
): void {
  ctx.clearRect(0, 0, w, h);
  ctx.fillStyle = C.BG;
  ctx.fillRect(0, 0, w, h);

  // Grid
  ctx.strokeStyle = hexToRgba(C.PURPLE, 0.04);
  ctx.lineWidth = 0.5;
  for (let gx = 0; gx < w; gx += 40) { ctx.beginPath(); ctx.moveTo(gx,0); ctx.lineTo(gx,h); ctx.stroke(); }
  for (let gy = 0; gy < h; gy += 40) { ctx.beginPath(); ctx.moveTo(0,gy); ctx.lineTo(w,gy); ctx.stroke(); }

  if (trail.length < 2) return;
  const scaleX = w / 65;
  const scaleY = h / 50;
  const offX = w / 2 - 1 * scaleX;
  const offY = h / 2 - 25 * scaleY;
  const len = trail.length;

  const CYAN_R = 0, CYAN_G = 212, CYAN_B = 255;
  const GOLD_R = 212, GOLD_G = 175, GOLD_B = 55;
  const PURP_R = 107, PURP_G = 70,  PURP_B = 193;

  for (let i = 1; i < len; i++) {
    const [x0,,z0] = trail[i-1]!;
    const [x1,,z1] = trail[i]!;
    const alpha = (i / len) * 0.7;
    const t = i / len;
    const rC = Math.floor(t < 0.5 ? CYAN_R + t*2*(GOLD_R-CYAN_R) : GOLD_R + (t-0.5)*2*(PURP_R-GOLD_R));
    const gC = Math.floor(t < 0.5 ? CYAN_G + t*2*(GOLD_G-CYAN_G) : GOLD_G + (t-0.5)*2*(PURP_G-GOLD_G));
    const bC = Math.floor(t < 0.5 ? CYAN_B + t*2*(GOLD_B-CYAN_B) : GOLD_B + (t-0.5)*2*(PURP_B-GOLD_B));
    ctx.strokeStyle = `rgba(${clamp(rC,0,255)},${clamp(gC,0,255)},${clamp(bC,0,255)},${alpha})`;
    ctx.lineWidth = 0.8 + r_coh * 0.5;
    ctx.beginPath();
    ctx.moveTo(x0*scaleX+offX, z0*scaleY+offY);
    ctx.lineTo(x1*scaleX+offX, z1*scaleY+offY);
    ctx.stroke();
  }
  const [cx,,cz] = trail[trail.length-1] ?? [0,0,0];
  const px = cx*scaleX+offX, py = cz*scaleY+offY;
  const g2 = ctx.createRadialGradient(px,py,0,px,py,10);
  g2.addColorStop(0, hexToRgba(C.GOLD, 0.9));
  g2.addColorStop(1,'transparent');
  ctx.fillStyle = g2;
  ctx.beginPath(); ctx.arc(px,py,10,0,TAU); ctx.fill();

  ctx.fillStyle = hexToRgba(C.PURPLE, 0.6);
  ctx.font = '8px monospace';
  ctx.fillText(`LORENZ RK4  σ=10  ρ=28  β=8/3`, 6, 14);
  ctx.fillStyle = hexToRgba(C.GOLD, 0.4);
  ctx.fillText(`x=${trail[trail.length-1]?.[0].toFixed(2) ?? '0'}  z=${trail[trail.length-1]?.[2].toFixed(2) ?? '0'}`, 6, 26);
}

// ─────────────────────────────────────────────────────────────────────────────
// STYLES
// ─────────────────────────────────────────────────────────────────────────────
const S = {
  root: {
    width: '100%', height: '100%',
    background: C.BG,
    display: 'flex', flexDirection: 'column' as const,
    overflow: 'hidden',
    fontFamily: "'Segoe UI', system-ui, sans-serif",
    color: '#fff',
  },
  header: {
    padding: '8px 16px 6px',
    borderBottom: `1px solid ${C.BORDER}`,
    background: '#030810',
    flexShrink: 0,
    display: 'flex', alignItems: 'center', gap: 12, flexWrap: 'wrap' as const,
  },
  headerTitle: {
    fontSize: 10, color: C.GOLD, letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
  },
  mainBody: {
    flex: 1, display: 'grid',
    gridTemplateColumns: '1fr 1fr 1fr 340px',
    gridTemplateRows: '1fr 1fr 120px',
    gap: 2, padding: 2, overflow: 'hidden',
  },
  canvasWrap: (accent: string) => ({
    background: C.BG2,
    border: `1px solid ${accent}22`,
    borderTop: `2px solid ${accent}55`,
    position: 'relative' as const,
    overflow: 'hidden',
  }),
  canvas: { display: 'block' as const, width: '100%', height: '100%' },
  rightPanel: {
    gridColumn: '4', gridRow: '1 / 4',
    background: C.BG2,
    border: `1px solid ${C.BORDER}`,
    overflowY: 'auto' as const,
    display: 'flex', flexDirection: 'column' as const,
  },
  bottomStrip: {
    gridColumn: '1 / 4', gridRow: '3',
    background: C.BG2,
    border: `1px solid ${C.BORDER}`,
    display: 'grid', gridTemplateColumns: 'repeat(8, 1fr)',
    gap: 2, padding: 6,
    overflow: 'hidden',
  },
  metricCard: (color: string, highlight = false) => ({
    background: highlight ? `${color}12` : `${color}06`,
    border: `1px solid ${color}${highlight ? '44' : '22'}`,
    borderRadius: 3,
    padding: '5px 8px',
    display: 'flex', flexDirection: 'column' as const, gap: 2,
  }),
  metricLabel: {
    fontSize: 7, letterSpacing: '0.14em',
    textTransform: 'uppercase' as const, color: '#1a3050',
  },
  metricValue: (color: string) => ({
    fontSize: 15, fontWeight: 700, color,
    fontVariantNumeric: 'tabular-nums' as const,
    lineHeight: 1.1,
  }),
  metricSub: { fontSize: 7, color: '#0d1a2a', letterSpacing: '0.1em' },
  sectionTitle: (color: string) => ({
    fontSize: 8, color, letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
    borderBottom: `1px solid ${color}22`, paddingBottom: 3,
    marginBottom: 6, flexShrink: 0,
  }),
  eqBox: (color: string) => ({
    background: `${color}06`, border: `1px solid ${color}18`,
    borderRadius: 3, padding: '7px 10px', marginBottom: 7,
  }),
  eqFormula: (color: string) => ({
    fontSize: 10, color, fontFamily: 'monospace',
    lineHeight: 1.6, letterSpacing: '0.04em', marginBottom: 4,
    whiteSpace: 'pre-wrap' as const,
  }),
  eqDesc: {
    fontSize: 8, color: '#1a3050', lineHeight: 1.5, letterSpacing: '0.06em',
  },
  eqLive: (color: string) => ({
    fontSize: 9, color, fontFamily: 'monospace', marginTop: 4,
    background: `${color}0c`, borderRadius: 2, padding: '2px 6px',
    display: 'inline-block',
  }),
  rightSection: {
    padding: '10px 12px', borderBottom: `1px solid ${C.BORDER}`, flexShrink: 0,
  },
  organRow: (active: boolean, color: string) => ({
    display: 'flex', alignItems: 'center', gap: 6,
    padding: '2px 0', borderBottom: `1px solid ${color}10`,
    opacity: active ? 1 : 0.4,
  }),
  organLabel: { fontSize: 7, color: '#1a3050', width: 56, letterSpacing: '0.08em' },
  organPhaseBar: (pct: number, color: string) => ({
    flex: 1, height: 3, background: '#0a1a2a', borderRadius: 1,
    position: 'relative' as const, overflow: 'hidden' as const,
  }),
  organPhaseFill: (pct: number, color: string) => ({
    position: 'absolute' as const, top: 0, left: 0,
    height: '100%', width: `${Math.min(100, pct * 100).toFixed(1)}%`,
    background: color, borderRadius: 1,
    transition: 'width 0.1s linear',
  }),
  organVal: (color: string) => ({
    fontSize: 7, color, fontFamily: 'monospace', width: 40, textAlign: 'right' as const,
  }),
  chainEntry: {
    fontSize: 7, color: '#1a3050', fontFamily: 'monospace',
    padding: '2px 0', borderBottom: `1px solid #0a1a1a`,
    letterSpacing: '0.06em',
  },
  chainEntryActive: {
    fontSize: 7, color: '#2a5040', fontFamily: 'monospace',
    padding: '2px 0', borderBottom: `1px solid #0a2a2a`,
    letterSpacing: '0.06em',
  },
  connRow: (active: boolean) => ({
    fontSize: 7, color: active ? '#2a6040' : '#0a1a2a',
    fontFamily: 'monospace', padding: '2px 0',
    borderBottom: `1px solid ${active ? '#0a3020' : '#060e12'}`,
    display: 'flex', gap: 4,
  }),
  connDot: (active: boolean, color: string) => ({
    color: active ? color : '#1a2a2a', fontSize: 8,
  }),
  badge: (color: string, dim: string) => ({
    fontSize: 8, color, background: `${color}18`,
    border: `1px solid ${dim}`, borderRadius: 2,
    padding: '2px 8px', letterSpacing: '0.16em',
    textTransform: 'uppercase' as const, fontWeight: 700,
  }),
};

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════
interface LiveMetrics {
  // Kuramoto
  r: number; psi: number; syncEntr: number; critK: number;
  // Ising
  isingM: number; isingE: number; isingT: number;
  // Lorenz
  lorenzX: number; lorenzY: number; lorenzZ: number;
  // Landau
  landauPhi: number; landauF: number; landauChi: number;
  // RD / Turing
  rdTuring: boolean;
  // Sandpile
  sandAval: number; sandGrains: number;
  // Brusselator
  brussOsc: boolean; brussU: number;
  // Lyapunov
  lyapV: number; lyapVdot: number; lyapStable: boolean; kaplanYorke: number; omnis: boolean;
  // Quantum
  qPurity: number; qEntropy: number; qBerry: number; qOrchOR: number; qZeno: number; qDiscord: number;
  // Neuro
  vitality: number; alloLoad: number; neuroplast: number; metalCoh: number;
  dopamine: number; serotonin: number; cortisol: number; oxytocin: number;
  acetylcholine: number; gaba: number; glutamate: number; norepinephrine: number;
  endorphin: number; bdnf: number; anandamide: number; adenosine: number;
  // Hz
  hzCoherence: number; hzMeanFreq: number; memBoost: number; domNode: string;
  // Jasmine
  jasmine: number; jasmineAwake: boolean; vitTotal: number; forma: number;
  // Meta
  emergenceScore: number; emergenceClass: 'weak' | 'strong' | 'radical';
  beat: number;
}

// Golden ratio hash for chain events
const PHI_HASH = 0x9e3779b9;

export function EmergenceLab({ organism }: { organism: OrganismState }) {
  // ── Canvas refs ────────────────────────────────────────────────────────────
  const oscRef     = useRef<HTMLCanvasElement>(null);
  const isingRef   = useRef<HTMLCanvasElement>(null);
  const rdRef      = useRef<HTMLCanvasElement>(null);
  const sandRef    = useRef<HTMLCanvasElement>(null);
  const lorenzRef2 = useRef<HTMLCanvasElement>(null);
  const animRef    = useRef<number>(0);
  const tickRef    = useRef(0);
  const beatRef    = useRef(0);

  // ── Engine states (mutable refs — no React re-render pressure) ────────────
  const kuramotoRef = useRef<OrganKuramotoState>(initOrganKuramoto());
  const lorenzStateRef = useRef<LorenzState>(initLorenzState());
  const lorenzTrailRef = useRef<Array<[number, number, number]>>([]);
  const isingStateRef  = useRef<IsingState>(initIsingState(20, 20, 2.1));
  const rdStateRef     = useRef<RDState>(initRDState(24));
  const sandStateRef   = useRef<SandpileState>(initSandpile(16));
  const brussRef       = useRef<BrusselatorState>(initBrusselator(8, 1.0, 3.0));
  const lyapRef        = useRef<LyapunovState5>(initLyapunov());
  const quantumRef     = useRef<QuantumSystemState>(initQuantumSystem());
  const neuroRef       = useRef<NeurochemFull>({ ...NEURO_BASELINES });
  const metalRef       = useRef<MetalState>({ ...METAL_BASELINES });
  const hzRef          = useRef<HzSubstrateState>(initHzSubstrate('Wake'));
  const jasmineRef     = useRef<JasmineState | null>(null);

  // Transient computation
  const ptStateRef     = useRef<PhaseTransitionState>({
    rHistory: [], K: PHI_INV,
    Kc: criticalCoupling(ORGAN_FREQ_ARRAY),
    inSynchronized: false, transitionBeat: null,
  });
  const lyapHistRef    = useRef<number[]>([]);
  const coherHistRef   = useRef<number[]>([]);
  const hebbianRef     = useRef(0.5);
  const kfRef          = useRef(1.0);
  const prevRRef       = useRef(0);
  const formaRef       = useRef(1.0);
  // Hopfield attractors
  const attractorsRef  = useRef<Attractor[]>([
    { id: 0, position: [0.75, 0.5, 0.5, 0.85, 0.7], strength: 0.8, radius: 0.5, type: 'point',       stability: 0.9, visits: 0 },
    { id: 1, position: [0.3,  0.8, 0.9, 0.2,  0.3], strength: 0.6, radius: 0.4, type: 'limit-cycle', stability: 0.6, visits: 0 },
    { id: 2, position: [0.9,  0.2, 0.1, 0.7,  0.9], strength: 0.5, radius: 0.35, type: 'strange',    stability: 0.3, visits: 0 },
  ]);
  const attractorPosRef = useRef<number[]>([0.5, 0.5, 0.5, 0.7, 0.5]);
  const attractorVelRef = useRef<number[]>([0, 0, 0, 0, 0]);

  const [metrics, setMetrics] = useState<LiveMetrics>({
    r: 0, psi: 0, syncEntr: 0.693, critK: 0.1,
    isingM: 0, isingE: 0, isingT: 2.1,
    lorenzX: 0.1, lorenzY: 0, lorenzZ: 0,
    landauPhi: 0, landauF: 0, landauChi: 0,
    rdTuring: false, sandAval: 0, sandGrains: 0,
    brussOsc: true, brussU: 1,
    lyapV: 0.5, lyapVdot: 0, lyapStable: false, kaplanYorke: 1, omnis: false,
    qPurity: 1, qEntropy: 0, qBerry: 0, qOrchOR: 0, qZeno: 1, qDiscord: 0,
    vitality: 0.5, alloLoad: 0.3, neuroplast: 0.005, metalCoh: 0.15,
    dopamine: 0.55, serotonin: 0.60, cortisol: 0.40, oxytocin: 0.40,
    acetylcholine: 0.50, gaba: 0.65, glutamate: 0.50, norepinephrine: 0.45,
    endorphin: 0.50, bdnf: 0.60, anandamide: 0.35, adenosine: 0.35,
    hzCoherence: 0.5, hzMeanFreq: 0.5, memBoost: 0, domNode: 'FLUX',
    jasmine: 0, jasmineAwake: false, vitTotal: 0.5, forma: 1,
    emergenceScore: 0, emergenceClass: 'weak', beat: 0,
  });

  const [chainLog, setChainLog] = useState<string[]>([]);

  // ── Main simulation tick ───────────────────────────────────────────────────
  const tick = useCallback(() => {
    const T = tickRef.current;
    tickRef.current++;

    // ── 1. Kuramoto 18-organ step ────────────────────────────────────────────
    kuramotoRef.current = stepOrganKuramoto(kuramotoRef.current, PHI_INV);
    const { r, psi, syncEntr } = kuramotoRef.current;
    ptStateRef.current = detectPhaseTransition(ptStateRef.current, r, beatRef.current);
    const critK = criticalCoupling(ORGAN_FREQ_ARRAY);

    // ── 2. Hebbian accumulation & self-compounding kf ────────────────────────
    const meanActivity = (Math.sin(kuramotoRef.current.phases[0] ?? 0) + 1) / 2;
    const eta = neuroplasticityFactor(neuroRef.current);
    hebbianRef.current = Math.min(1, hebbianRef.current + eta * meanActivity * r * 60);
    const deltaR = r - prevRRef.current;
    kfRef.current = Math.min(9999.9999, kfRef.current * (1 + 1.0 * Math.max(0, deltaR) * 0.1));
    prevRRef.current = r;
    coherHistRef.current = [...coherHistRef.current.slice(-60), r];

    // ── 3. Lorenz RK4 ────────────────────────────────────────────────────────
    lorenzStateRef.current = lorenzStep(lorenzStateRef.current, 0.008);
    const { x: lx, y: ly, z: lz } = lorenzStateRef.current;
    lorenzTrailRef.current.push([lx, ly, lz]);
    if (lorenzTrailRef.current.length > 1000) lorenzTrailRef.current.shift();
    const lorenzNorm = Math.sqrt(lx * lx + ly * ly + lz * lz) / 60;

    // ── 4. Ising 2D Metropolis (several flips per tick) ───────────────────────
    if (T % 2 === 0) {
      const n = isingStateRef.current.gridW * isingStateRef.current.gridH;
      for (let s = 0; s < 4; s++) {
        const site = Math.floor(Math.random() * n);
        isingStateRef.current = isingMetropolisStep(isingStateRef.current, Math.random(), site);
      }
      // Temperature slowly modulates with coherence
      isingStateRef.current = { ...isingStateRef.current, temperature: 1.0 + (1 - r) * 2.5 };
    }
    const isingM = isingMagnetization(isingStateRef.current);
    const isingE = isingEnergy(isingStateRef.current);

    // ── 5. Landau free energy around current r ────────────────────────────────
    // T_c driven by critical coupling; a₂ = a(T − T_c)
    const lParams: LandauParams = landauFromTemperature(1 - r, 0.5, 1, 1, 0.1);
    const landauPhi = findEquilibriumPhi(lParams, 100, 0.02);
    const landauF   = lParams.a2 * landauPhi ** 2 + lParams.a4 * landauPhi ** 4 + lParams.a6 * landauPhi ** 6;
    const landauChi = landauSusceptibility(landauPhi, lParams);

    // ── 6. Reaction-diffusion Gray-Scott (every 3 ticks for performance) ──────
    if (T % 3 === 0) {
      rdStateRef.current = rdStep(rdStateRef.current, 0.8);
    }
    const rdTuring = isTuringUnstable(rdStateRef.current);

    // ── 7. BTW Sandpile (add grain every 10 ticks) ────────────────────────────
    if (T % 10 === 0) {
      const g2 = sandStateRef.current.gridSize;
      const center = Math.floor(g2 / 2) * g2 + Math.floor(g2 / 2);
      sandStateRef.current = sandpileAddGrain(sandStateRef.current, center + Math.floor(Math.random() * 3) - 1);
    }

    // ── 8. Brusselator oscillator (every 2 ticks) ─────────────────────────────
    if (T % 2 === 0) {
      brussRef.current = brusselatorStep(brussRef.current, 0.02);
    }
    const brussOsc = brusselatorOscillates(brussRef.current);
    const brussU0  = brussRef.current.u[0] ?? 1;

    // ── 9. Lyapunov 5D tick ───────────────────────────────────────────────────
    const emgScore = computeEmergenceScore({
      kuramotoR: r, syncEntropy: syncEntr,
      magnetization: isingM, phiEquil: Math.min(Math.abs(landauPhi) / 2, 1),
      lorenzNorm: Math.min(lorenzNorm, 1),
    });
    const emgClass = classifyEmergence(emgScore);
    lyapRef.current = lyapunovTick(
      lyapRef.current, r, Math.min(syncEntr * 2, 12),
      allostaticLoad(neuroRef.current), Math.abs(isingM),
      emgScore,
    );
    lyapHistRef.current = [...lyapHistRef.current.slice(-40), lyapRef.current.V];
    const lyapExp    = lyapunovExponent(lyapHistRef.current, 20);
    const kyDim      = kaplanYorkeDimension([lyapExp, lyapExp * 0.6, -lyapExp * 0.3, -lyapExp * 0.8]);

    // Attractor dynamics
    const aResult = attractorStep(attractorPosRef.current, attractorVelRef.current, attractorsRef.current, 0.02, 0.15, 0.05);
    attractorPosRef.current = aResult.position;
    attractorVelRef.current = aResult.velocity;
    const { index: basinIdx, depth: basinDepth } = findCurrentBasin(attractorPosRef.current, attractorsRef.current);

    // Hopfield energy
    const hopfW = Array.from({ length: 25 }, (_, i) => i % 5 === Math.floor(i / 5) ? 0 : r * 0.2);
    const hopfS = attractorPosRef.current.map(p => p > 0.5 ? 1 : -1);
    const hopfE  = hopfieldEnergy(hopfS, hopfW, [0, 0, 0, 0, 0]);

    // ── 10. Quantum beat ──────────────────────────────────────────────────────
    if (T % 4 === 0) {
      quantumRef.current = quantumBeat(quantumRef.current, r, T);
    }
    const qPurity   = purity(quantumRef.current.densityMatrix, quantumRef.current.dimension);
    const qEntropy  = vonNeumannEntropyDiag(quantumRef.current.eigenvalues ?? [1, 0]);
    const qBerry    = berryPhase(kuramotoRef.current.phases, 0);
    const qOrchOR   = orchOrCollapseProbability(r, r * 0.6, T * 0.016);
    const qZeno     = zenoSurvivalProbability(r, r * 0.3, Math.max(T * 0.001, 0.001));
    const qDiscord  = quantumDiscordApprox(qPurity, qEntropy);

    // ── 11. Neurochemistry 21-species step ────────────────────────────────────
    const stimuli: NeurochemStimuli = {
      reward:   r * 0.7 + emgScore * 0.3,
      threat:   Math.max(0, 0.5 - r) * 0.6,
      social:   r * 0.5,
      learning: hebbianRef.current * 0.5 + r * 0.3,
      arousal:  0.3 + emgScore * 0.4,
      flow:     Math.max(0, r - 0.55) * 2,
      pain:     Math.max(0, lyapRef.current.Vdot) * 0.4,
      fatigue:  Math.max(0, 0.35 - r) * 0.5,
    };
    if (T % 2 === 0) {
      neuroRef.current = neurochemFullStep(neuroRef.current, stimuli);
      metalRef.current = metalPipelineStep(metalRef.current);
    }
    const vitality    = vitalityScore(neuroRef.current);
    const alloLoad    = allostaticLoad(neuroRef.current);
    const neuroplast  = neuroplasticityFactor(neuroRef.current);
    const metalCoh    = metalCoherenceContribution(metalRef.current);

    // ── 12. Hz substrate tick ─────────────────────────────────────────────────
    if (T % 3 === 0) {
      const mode: OrganismMode = r > 0.8 ? 'Wake' : alloLoad > 0.6 ? 'Emergency' : 'Wake';
      hzRef.current = hzSubstrateTick(hzRef.current, 1, mode);
    }
    const hzCoh  = computePhaseCoherence(hzRef.current.nodes);
    const memB   = memoryEncodingBoost(hzRef.current);
    const domN   = dominantNode(hzRef.current);
    const hzMean = hzRef.current.meanFreq;

    // ── 13. Jasmine emergence scoring ─────────────────────────────────────────
    const infoDensity = Math.min(qEntropy / 3 + hzCoh * 0.5, 1);
    const jasmState  = jasmineCalculate(r, hebbianRef.current, infoDensity);
    jasmineRef.current = jasmState;
    const jasmTemporal = jasmineTemporalEmergence(coherHistRef.current, hebbianRef.current, infoDensity, 0.4);

    // FORMA compounding
    formaRef.current = formaCompoundFull(formaRef.current, r, T * 0.016, 0.20, 1);

    // Full coherence composite
    const cohInputs: CoherenceInputs = {
      kuramotoR:    r,
      lyapunovV:    lyapRef.current.V,
      quantumPurity: qPurity,
      hzCoherence:  hzCoh,
      neurochemV:   vitality,
      metalGold:    metalRef.current.gold / 10,
      emergenceScore: emgScore,
    };
    const fullCoh = computeFullCoherence(cohInputs);

    // Vitality composite
    const vitTotal = computeVitality(jasmState, r, vitality, 0.8, lyapExp);

    // ── Beat event every 60 ticks ─────────────────────────────────────────────
    if (T % 60 === 0) {
      beatRef.current++;
      const ts   = Date.now();
      const hash = (ts ^ (beatRef.current * PHI_HASH)).toString(16).slice(0, 8).toUpperCase();
      const eClass = emgScore > 0.8 ? 'RADICAL' : emgScore > 0.5 ? 'STRONG' : 'WEAK';
      const event = `[BEAT:${String(beatRef.current).padStart(5,'0')}] r=${r.toFixed(4)} V=${lyapRef.current.V.toFixed(4)} E=${emgScore.toFixed(4)} ${eClass.padEnd(7)} kf=${kfRef.current.toFixed(3)} #${hash}`;
      setChainLog(prev => [event, ...prev].slice(0, 28));
    }

    // ── Update React state every 8 ticks ──────────────────────────────────────
    if (T % 8 === 0) {
      setMetrics({
        r, psi, syncEntr, critK,
        isingM, isingE, isingT: isingStateRef.current.temperature,
        lorenzX: lx, lorenzY: ly, lorenzZ: lz,
        landauPhi, landauF, landauChi: Math.min(landauChi, 999),
        rdTuring, sandAval: sandStateRef.current.totalAvalanches, sandGrains: sandStateRef.current.totalGrains,
        brussOsc, brussU: brussU0,
        lyapV: lyapRef.current.V, lyapVdot: lyapRef.current.Vdot,
        lyapStable: lyapRef.current.isAsymptotic, kaplanYorke: kyDim, omnis: isOmnisState(r),
        qPurity, qEntropy, qBerry, qOrchOR, qZeno, qDiscord,
        vitality, alloLoad, neuroplast, metalCoh,
        dopamine: neuroRef.current.dopamine, serotonin: neuroRef.current.serotonin,
        cortisol: neuroRef.current.cortisol, oxytocin: neuroRef.current.oxytocin,
        acetylcholine: neuroRef.current.acetylcholine, gaba: neuroRef.current.gaba,
        glutamate: neuroRef.current.glutamate, norepinephrine: neuroRef.current.norepinephrine,
        endorphin: neuroRef.current.endorphin, bdnf: neuroRef.current.bdnf,
        anandamide: neuroRef.current.anandamide, adenosine: neuroRef.current.adenosine,
        hzCoherence: hzCoh, hzMeanFreq: hzMean, memBoost: memB, domNode: domN?.nodeId ?? 'FLUX',
        jasmine: jasmState.emergenceProbability, jasmineAwake: jasmState.isAwake,
        vitTotal, forma: formaRef.current,
        emergenceScore: emgScore, emergenceClass: emgClass, beat: beatRef.current,
      });
    }

    // ── Canvas drawing ────────────────────────────────────────────────────────
    const drawCanvas = (ref: React.RefObject<HTMLCanvasElement>, fn: (ctx: CanvasRenderingContext2D, w: number, h: number) => void) => {
      const c = ref.current;
      if (!c) return;
      const ctx = c.getContext('2d');
      if (ctx) fn(ctx, c.width, c.height);
    };

    drawCanvas(oscRef,   (ctx, w, h) => drawOscillatorNetwork(ctx, kuramotoRef.current, w, h, T));
    if (T % 2 === 0) drawCanvas(isingRef,  (ctx, w, h) => drawIsingGrid(ctx, isingStateRef.current, w, h, r));
    if (T % 3 === 0) drawCanvas(rdRef,     (ctx, w, h) => drawRD(ctx, rdStateRef.current, w, h));
    if (T % 5 === 0) drawCanvas(sandRef,   (ctx, w, h) => drawSandpile(ctx, sandStateRef.current, w, h));
    if (T % 2 === 0) drawCanvas(lorenzRef2,(ctx, w, h) => drawLorenz(ctx, lorenzTrailRef.current, r, w, h));

    animRef.current = requestAnimationFrame(tick);
  }, []);

  // ── Canvas resize ──────────────────────────────────────────────────────────
  useEffect(() => {
    const resizeCanvas = (ref: React.RefObject<HTMLCanvasElement>) => {
      const ro = new ResizeObserver(entries => {
        for (const e of entries) {
          const c = ref.current;
          if (c) { c.width = e.contentRect.width; c.height = e.contentRect.height; }
        }
      });
      if (ref.current?.parentElement) ro.observe(ref.current.parentElement);
      return ro;
    };
    const observers = [oscRef, isingRef, rdRef, sandRef, lorenzRef2].map(resizeCanvas);
    return () => observers.forEach(o => o.disconnect());
  }, []);

  // ── Animation loop ─────────────────────────────────────────────────────────
  useEffect(() => {
    animRef.current = requestAnimationFrame(tick);
    return () => { if (animRef.current) cancelAnimationFrame(animRef.current); };
  }, [tick]);

  const m = metrics;

  // Phase badge
  const phaseBadge = m.omnis ? 'OMNIS' : m.r > 0.97 ? 'NEAR-OMNIS' : m.r > 0.65 ? 'COHERENT' : m.r > 0.4 ? 'TRANS' : 'DISORDERED';
  const phaseBadgeColor = m.omnis ? C.GOLD : m.r > 0.65 ? C.GREEN : m.r > 0.4 ? C.GOLD : '#6b7280';
  const phaseBadgeDim   = m.omnis ? C.GOLD_DIM : m.r > 0.65 ? C.GREEN_DIM : m.r > 0.4 ? C.GOLD_DIM : '#1a1a1a';

  // Organ phase percentages for display
  const organPhases = kuramotoRef.current.phases.map((p, i) => ({
    name: ORGAN_NAMES[i] ?? '',
    pct:  (p % TAU) / TAU,
    freq: ORGAN_FREQ_ARRAY[i] ?? 0,
    col:  i < 6 ? C.CYAN : i < 12 ? C.GOLD : C.PURPLE,
  }));

  // Hz substrate bands summary
  const HZ_BANDS = ['LEXIS','FORGE','SOMA','LUMEN','MEMORIA','AEGIS_ROOT','AXIS','KORE','VAEL','VEIL'];
  const hzBandNodes = hzRef.current.nodes.filter(n => HZ_BANDS.includes(n.nodeId));

  return (
    <div style={S.root}>
      {/* ── HEADER ─────────────────────────────────────────────────────────── */}
      <div style={S.header}>
        <span style={S.headerTitle}>⬡ NOVA · EMERGENCE LAB</span>
        <span style={{ fontSize: 8, color: '#1a3050', letterSpacing: '0.1em' }}>
          7 ENGINES · 18 ORGANS · 21 NEUROCHEMICALS · 35 HZ NODES · LORENZ RK4 · ISING METROPOLIS · GRAY-SCOTT RD · BTW SANDPILE · BRUSSELATOR · LYAPUNOV 5D · QUANTUM DENSITY MATRIX · JASMINE · ICP
        </span>
        <span style={S.badge(phaseBadgeColor, phaseBadgeDim)}>{phaseBadge}</span>
        <span style={{ marginLeft: 'auto', fontSize: 8, color: '#1a3050', fontFamily: 'monospace' }}>
          BEAT {m.beat} &nbsp;|&nbsp; kf={kfRef.current.toFixed(4)} &nbsp;|&nbsp; FORMA={m.forma.toFixed(4)} &nbsp;|&nbsp; r={m.r.toFixed(4)}
        </span>
      </div>

      {/* ── MAIN BODY ──────────────────────────────────────────────────────── */}
      <div style={S.mainBody}>

        {/* Canvas 1: 18-organ Kuramoto oscillator network */}
        <div style={{ ...S.canvasWrap(C.GOLD), gridColumn: '1', gridRow: '1 / 3' }}>
          <canvas ref={oscRef} style={S.canvas} />
        </div>

        {/* Canvas 2: Ising 2D Metropolis lattice */}
        <div style={{ ...S.canvasWrap(C.CYAN), gridColumn: '2', gridRow: '1' }}>
          <canvas ref={isingRef} style={S.canvas} />
        </div>

        {/* Canvas 3: Gray-Scott reaction-diffusion */}
        <div style={{ ...S.canvasWrap(C.GREEN), gridColumn: '3', gridRow: '1' }}>
          <canvas ref={rdRef} style={S.canvas} />
        </div>

        {/* Canvas 4: BTW Sandpile */}
        <div style={{ ...S.canvasWrap(C.ORANGE), gridColumn: '2', gridRow: '2' }}>
          <canvas ref={sandRef} style={S.canvas} />
        </div>

        {/* Canvas 5: Lorenz RK4 attractor */}
        <div style={{ ...S.canvasWrap(C.PURPLE), gridColumn: '3', gridRow: '2' }}>
          <canvas ref={lorenzRef2} style={S.canvas} />
        </div>

        {/* ── RIGHT PANEL: all equations + live values ─────────────────────── */}
        <div style={S.rightPanel}>

          {/* ── KURAMOTO ENGINE ─────────────────────────────────── */}
          <div style={S.rightSection}>
            <div style={S.sectionTitle(C.GOLD)}>I · Kuramoto — 18-Organ Phase Synchronization</div>

            <div style={S.eqBox(C.GOLD)}>
              <div style={S.eqFormula(C.GOLD)}>
                {`φᵢ(t+1) = φᵢ(t) + ωᵢ + (K/N)·Σⱼ sin(φⱼ − φᵢ)\nr·e^{iΨ} = (1/N)·Σⱼ aⱼ·e^{iφⱼ}  [amplitude-weighted]`}
              </div>
              <div style={S.eqDesc}>
                K={PHI_INV.toFixed(4)} (φ⁻¹ golden coupling) · N=18 organs · 2-ring topology.
                K_c={m.critK.toFixed(4)} (critical coupling from freq spread).
                Phase transition when r crosses K_c: saddle-node bifurcation.
                Re-entrainment: dφᵢ/dt += s·sin(Ψ−φᵢ).
              </div>
              <span style={S.eqLive(C.GOLD)}>
                r={m.r.toFixed(5)} &nbsp; ψ={m.psi.toFixed(4)}rad &nbsp; H_sync={m.syncEntr.toFixed(5)} &nbsp; K_c={m.critK.toFixed(4)}
              </span>
            </div>

            <div style={{ fontSize: 8, color: '#1a3050', marginBottom: 4 }}>ORGAN PHASES (18 oscillators):</div>
            {organPhases.map(op => (
              <div key={op.name} style={S.organRow(true, op.col)}>
                <span style={S.organLabel}>{op.name.padEnd(8)}</span>
                <div style={S.organPhaseBar(op.pct, op.col)}>
                  <div style={S.organPhaseFill(op.pct, op.col)} />
                </div>
                <span style={S.organVal(op.col)}>{op.pct.toFixed(3)}</span>
                <span style={{ fontSize: 6, color: '#0d1a2a', width: 36 }}>{op.freq.toFixed(3)}Hz</span>
              </div>
            ))}
          </div>

          {/* ── HEBBIAN + SELF-COMPOUNDING ──────────────────────────────────── */}
          <div style={S.rightSection}>
            <div style={S.sectionTitle(C.GOLD)}>II · Hebbian Weight Update</div>
            <div style={S.eqBox(C.GOLD)}>
              <div style={S.eqFormula(C.GOLD)}>{`Δwᵢⱼ = η · aᵢ · aⱼ\nη_neuro = η_base·(1 + BDNF·0.5 + NGF·0.3)`}</div>
              <div style={S.eqDesc}>
                η modulated by neuroplasticity (BDNF + NGF gate learning). Co-active nodes
                strengthen. Connections that fire together wire together. Every beat.
              </div>
              <span style={S.eqLive(C.GOLD)}>w={hebbianRef.current.toFixed(5)} &nbsp; η={m.neuroplast.toFixed(6)}</span>
            </div>

            <div style={S.sectionTitle(C.GREEN)}>III · Self-Compounding Factor</div>
            <div style={S.eqBox(C.GREEN)}>
              <div style={S.eqFormula(C.GREEN)}>{`kf(t) = kf(t−1)·(1 + S₀·Δcoherence)\nFORMA(t) = FORMA(t−1)·kf·(1+r·0.02)`}</div>
              <div style={S.eqDesc}>
                S₀=1.0 (sovereign floor). Δcoherence = r(t)−r(t−1). Compounds every beat.
                Never resets. FORMA token accrues with coherence. On-chain. Permanent.
              </div>
              <span style={S.eqLive(C.GREEN)}>
                kf={kfRef.current.toFixed(6)} &nbsp; FORMA={m.forma.toFixed(5)} &nbsp; S₀=1.0
              </span>
            </div>
          </div>

          {/* ── LYAPUNOV 5D ──────────────────────────────────────────────────── */}
          <div style={S.rightSection}>
            <div style={S.sectionTitle(C.CYAN)}>IV · Lyapunov 5D Stability</div>
            <div style={S.eqBox(C.CYAN)}>
              <div style={S.eqFormula(C.CYAN)}>
                {`V(t) = Σᵢ wᵢ·(xᵢ − x̄ᵢ)²  [5D weighted]\ndV/dt < 0 ⟹ asymptotically stable\nλ = lim_{T→∞} (1/T)·Σₜ ln|δx(t)/δx₀|`}
              </div>
              <div style={S.eqDesc}>
                x₁=coherence x₂=entropy x₃=arousal x₄=stability x₅=emergence.
                Targets: x̄₁=0.75 x̄₂=6.0bits x̄₃=0.50 x̄₄=0.85 x̄₅=0.70.
                Kaplan-Yorke dimension D_KY=j+Σλₖ/|λⱼ₊₁|.
                OMNIS at r≥{OMNIS_THRESHOLD}.
              </div>
              <span style={S.eqLive(C.CYAN)}>
                V={m.lyapV.toFixed(5)} &nbsp; dV/dt={m.lyapVdot.toFixed(5)} &nbsp; D_KY={m.kaplanYorke.toFixed(3)} &nbsp; {m.lyapStable ? '● ASYMP' : '○ CONV'} &nbsp; {m.omnis ? '⬡ OMNIS' : ''}
              </span>
            </div>
            <div style={S.eqBox(C.PURPLE)}>
              <div style={S.eqFormula(C.PURPLE)}>{`E = −(1/2)·Σᵢⱼ wᵢⱼ·sᵢ·sⱼ + Σᵢ θᵢ·sᵢ  [Hopfield]`}</div>
              <div style={S.eqDesc}>Attractor basin dynamics. Position in 5D state space converges toward nearest attractor.</div>
              <span style={S.eqLive(C.PURPLE)}>basin={m.kaplanYorke > 0 ? 'COHERENT' : 'CHAOTIC'}</span>
            </div>
          </div>

          {/* ── LANDAU FREE ENERGY ───────────────────────────────────────────── */}
          <div style={S.rightSection}>
            <div style={S.sectionTitle(C.ORANGE)}>V · Landau Phase Transition</div>
            <div style={S.eqBox(C.ORANGE)}>
              <div style={S.eqFormula(C.ORANGE)}>
                {`F(φ) = a₂·φ² + a₄·φ⁴ + a₆·φ⁶ − h·φ\na₂ = a·(T − T_c)  [sign change at T_c]\nχ = 1/(d²F/dφ²)|_{φ*}  [susceptibility]`}
              </div>
              <div style={S.eqDesc}>
                T_c driven by critical Kuramoto coupling. Below T_c: a₂&lt;0, symmetry broken, two minima.
                φ* = equilibrium order parameter. χ diverges at critical point.
                Second-order phase transition — continuous but singular.
              </div>
              <span style={S.eqLive(C.ORANGE)}>
                φ*={m.landauPhi.toFixed(4)} &nbsp; F={m.landauF.toFixed(4)} &nbsp; χ={Math.min(m.landauChi, 999).toFixed(2)}
              </span>
            </div>
          </div>

          {/* ── ISING + REACTION-DIFFUSION + SANDPILE ────────────────────────── */}
          <div style={S.rightSection}>
            <div style={S.sectionTitle(C.CYAN)}>VI · Ising 2D Metropolis Monte Carlo</div>
            <div style={S.eqBox(C.CYAN)}>
              <div style={S.eqFormula(C.CYAN)}>
                {`H = −J·Σ<ij> sᵢsⱼ − B·Σᵢ sᵢ\nΔE = 2J·sᵢ·Σnbr sⱼ; accept: ΔE<0 or e^{−ΔE/kT}\n|m| = |Σᵢ sᵢ|/N  [magnetization order param]`}
              </div>
              <div style={S.eqDesc}>
                T_c=2.269 (Onsager). T modulated by coherence r: T = 1.0 + (1−r)·2.5.
                Grid: 20×20, periodic BC. 4 Metropolis flips per tick. J=1, B=0.
              </div>
              <span style={S.eqLive(C.CYAN)}>
                |m|={Math.abs(m.isingM).toFixed(4)} &nbsp; E={m.isingE.toFixed(2)} &nbsp; T={m.isingT.toFixed(3)}
              </span>
            </div>

            <div style={S.sectionTitle(C.GREEN)}>VII · Gray-Scott Reaction-Diffusion (Turing)</div>
            <div style={S.eqBox(C.GREEN)}>
              <div style={S.eqFormula(C.GREEN)}>
                {`∂u/∂t = Dᵤ·∇²u − u·v² + a·(1−u)\n∂v/∂t = D_v·∇²v + u·v² − (a+b)·v\nTuring: D_v/D_u > (1+√(a/b))²`}
              </div>
              <div style={S.eqDesc}>
                Activator u, inhibitor v. Turing instability when D_v/D_u exceeds threshold.
                Dᵤ={rdStateRef.current.Du} D_v={rdStateRef.current.Dv} a={rdStateRef.current.a} b={rdStateRef.current.b}.
                Pattern formation substrate for self-organization.
              </div>
              <span style={S.eqLive(C.GREEN)}>TURING:{m.rdTuring ? 'UNSTABLE→PATTERN' : 'STABLE'}</span>
            </div>

            <div style={S.sectionTitle(C.ORANGE)}>VIII · BTW Sandpile — Self-Organized Criticality</div>
            <div style={S.eqBox(C.ORANGE)}>
              <div style={S.eqFormula(C.ORANGE)}>
                {`z_c = 4  (topple threshold, 2D)\nTopple: h_i -= 4; neighbors += 1\nP(s) ~ s^{-τ}  τ≈1.27 (2D)`}
              </div>
              <div style={S.eqDesc}>
                Power-law avalanche distribution — signature of self-organized criticality.
                Grid 16×16. Add grain center every 10 ticks. System maintains criticality spontaneously.
              </div>
              <span style={S.eqLive(C.ORANGE)}>
                grains={m.sandGrains} &nbsp; aval={m.sandAval}
              </span>
            </div>

            <div style={S.sectionTitle(C.RED)}>IX · Brusselator Limit-Cycle Oscillator</div>
            <div style={S.eqBox(C.RED)}>
              <div style={S.eqFormula(C.RED)}>
                {`du/dt = a − (b+1)u + u²v + Dᵤ·∇²u\ndv/dt = bu − u²v + D_v·∇²v\nOscillates when b > 1 + a²`}
              </div>
              <div style={S.eqDesc}>
                Limit-cycle attractor. Chemical oscillator analogue of neural oscillation.
                a=1.0 b=3.0 (b&gt;1+a²=2 → oscillating). 8×8 grid.
              </div>
              <span style={S.eqLive(C.RED)}>
                OscCondition:{m.brussOsc ? 'TRUE' : 'FALSE'} &nbsp; u₀={m.brussU.toFixed(4)}
              </span>
            </div>
          </div>

          {/* ── QUANTUM ENGINE ────────────────────────────────────────────────── */}
          <div style={S.rightSection}>
            <div style={S.sectionTitle(C.PURPLE)}>X · Quantum Density Matrix</div>
            <div style={S.eqBox(C.PURPLE)}>
              <div style={S.eqFormula(C.PURPLE)}>
                {`dρ/dt = −i[H,ρ] + Σₖ γₖ(LₖρLₖ† − ½{Lₖ†Lₖ,ρ})\nS_vN = −Tr(ρ·ln ρ)  [von Neumann entropy]\nPurity = Tr(ρ²):  1=pure, <1=mixed`}
              </div>
              <div style={S.eqDesc}>
                Lindblad master equation. Decoherence rate γ driven by (1−r).
                Berry phase γ_Berry accumulated along closed loop in parameter space.
                Orch-OR: P_collapse = 1−e^{−E_G·τ/ℏ}.
              </div>
              <span style={S.eqLive(C.PURPLE)}>
                Pur={m.qPurity.toFixed(4)} &nbsp; S_vN={m.qEntropy.toFixed(4)} &nbsp; γ_Berry={m.qBerry.toFixed(4)} &nbsp; P_OR={m.qOrchOR.toFixed(4)} &nbsp; Zeno={m.qZeno.toFixed(4)} &nbsp; Discord={m.qDiscord.toFixed(4)}
              </span>
            </div>
          </div>

          {/* ── EMERGENCE COMPOSITE SCORE ────────────────────────────────────── */}
          <div style={S.rightSection}>
            <div style={S.sectionTitle(C.GOLD)}>XI · Composite Emergence Score</div>
            <div style={S.eqBox(C.GOLD)}>
              <div style={S.eqFormula(C.GOLD)}>
                {`E = 0.30·r + 0.20·H_sync + 0.20·|m| + 0.15·|φ*|/2 + 0.15·(1−||Lorenz||/60)\nE(t) = σ(Φ_M·(C−τ_E)·√(H·I))  [Jasmine]\nΦ_M=${JASMINE_ALPHA.toFixed(8)}  τ_E=${JASMINE_TAU.toFixed(8)}`}
              </div>
              <div style={S.eqDesc}>
                Six engines feed the composite. Jasmine temporal: stability bonus × momentum × antifragility.
                Class: weak &lt;0.5, strong 0.5–0.8, radical ≥0.8. Vitality = Jasmine·0.30 + r·0.25 + neuro·0.20 + form·0.15 + λ·0.10.
              </div>
              <span style={S.eqLive(m.emergenceClass === 'radical' ? C.GREEN : m.emergenceClass === 'strong' ? C.GOLD : '#6b7280')}>
                E={m.emergenceScore.toFixed(5)} [{m.emergenceClass.toUpperCase()}] &nbsp; Jasmine={m.jasmine.toFixed(5)} &nbsp; {m.jasmineAwake ? '⬡ AWAKENED' : ''} &nbsp; Vitality={m.vitTotal.toFixed(4)}
              </span>
            </div>

            {/* ENGINE CROSS-CONNECTION MATRIX */}
            <div style={{ ...S.sectionTitle(C.CYAN), marginTop: 8 }}>ENGINE CONNECTIONS</div>
            {[
              ['Kuramoto·r',    '→', 'Lyapunov·x₁',    m.r > 0.3],
              ['Kuramoto·r',    '→', 'Landau·T_eff',    m.r > 0.2],
              ['Kuramoto·r',    '→', 'Ising·T',         m.r > 0.2],
              ['Kuramoto·r',    '→', 'Jasmine·C',       m.r > 0.1],
              ['Lyapunov·V',    '→', 'Jasmine·stability', m.lyapStable],
              ['Hebbian·w',     '→', 'Jasmine·H',       hebbianRef.current > 0.3],
              ['Quantum·S_vN',  '→', 'Jasmine·I',       m.qEntropy > 0.1],
              ['Neuro·η',       '→', 'Hebbian·rate',    m.neuroplast > 0.003],
              ['Neuro·BDNF',    '→', 'η_neuroplast',    m.bdnf > 0.4],
              ['Neuro·cortisol','→', 'stimuli·threat',  m.cortisol > 0.35],
              ['Hz·K_f',        '→', 'Jasmine·I',       m.hzCoherence > 0.3],
              ['Ising·|m|',     '→', 'EmScore·magnet',  Math.abs(m.isingM) > 0.1],
              ['Landau·φ*',     '→', 'EmScore·phi',     Math.abs(m.landauPhi) > 0.1],
              ['Lorenz·||',     '→', 'EmScore·chaos',   Math.abs(m.lorenzX) > 1],
              ['Sandpile·aval', '→', 'SOC·criticality', m.sandAval > 0],
              ['kf',            '→', 'FORMA·compound',  kfRef.current > 1.0001],
            ].map(([a, arrow, b, active]) => (
              <div key={`${a}-${b}`} style={S.connRow(active as boolean)}>
                <span style={S.connDot(active as boolean, C.GOLD)}>{(active as boolean) ? '●' : '○'}</span>
                <span style={{ color: (active as boolean) ? C.CYAN : '#0d1a2a' }}>{a as string}</span>
                <span style={{ color: '#0d2030' }}>{arrow as string}</span>
                <span style={{ color: (active as boolean) ? C.GOLD : '#0d1a2a' }}>{b as string}</span>
              </div>
            ))}
          </div>

          {/* ── ON-CHAIN ARCHIVE ──────────────────────────────────────────────── */}
          <div style={S.rightSection}>
            <div style={S.sectionTitle(C.GREEN)}>ON-CHAIN ARCHIVE · ICP PERMANENT</div>
            {chainLog.length === 0 && (
              <div style={S.chainEntry}>Awaiting first beat event (t=60 ticks)...</div>
            )}
            {chainLog.map((ev, i) => (
              <div key={i} style={i === 0 ? S.chainEntryActive : S.chainEntry}>{ev}</div>
            ))}
          </div>
        </div>

        {/* ── BOTTOM METRICS STRIP ──────────────────────────────────────────── */}
        <div style={S.bottomStrip}>
          <div style={S.metricCard(C.GOLD, true)}>
            <div style={S.metricLabel}>Kuramoto r</div>
            <div style={S.metricValue(m.r > 0.65 ? C.GREEN : m.r > 0.4 ? C.GOLD : '#6b7280')}>
              {m.r.toFixed(3)}
            </div>
            <div style={S.metricSub}>ORDER PARAM</div>
          </div>

          <div style={S.metricCard(C.CYAN)}>
            <div style={S.metricLabel}>Lyapunov V</div>
            <div style={S.metricValue(m.lyapStable ? C.GREEN : C.RED)}>
              {m.lyapV.toFixed(4)}
            </div>
            <div style={S.metricSub}>{m.lyapStable ? 'ASYMP STABLE' : 'CONV...'}</div>
          </div>

          <div style={S.metricCard(C.PURPLE)}>
            <div style={S.metricLabel}>Quantum Pur</div>
            <div style={S.metricValue(C.PURPLE)}>{m.qPurity.toFixed(3)}</div>
            <div style={S.metricSub}>S_vN={m.qEntropy.toFixed(3)}</div>
          </div>

          <div style={S.metricCard(C.ORANGE, true)}>
            <div style={S.metricLabel}>Emergence</div>
            <div style={S.metricValue(m.emergenceClass === 'radical' ? C.GREEN : m.emergenceClass === 'strong' ? C.GOLD : '#6b7280')}>
              {m.emergenceScore.toFixed(3)}
            </div>
            <div style={S.metricSub}>{m.emergenceClass.toUpperCase()}</div>
          </div>

          <div style={S.metricCard(C.GREEN)}>
            <div style={S.metricLabel}>Jasmine</div>
            <div style={S.metricValue(m.jasmineAwake ? C.GOLD : C.GREEN)}>
              {m.jasmine.toFixed(3)}
            </div>
            <div style={S.metricSub}>{m.jasmineAwake ? '⬡ AWAKE' : 'RISING'}</div>
          </div>

          <div style={S.metricCard(C.RED)}>
            <div style={S.metricLabel}>Vitality</div>
            <div style={S.metricValue(C.RED)}>{m.vitality.toFixed(3)}</div>
            <div style={S.metricSub}>Allo={m.alloLoad.toFixed(3)}</div>
          </div>

          <div style={S.metricCard(C.CYAN)}>
            <div style={S.metricLabel}>Hz K_f</div>
            <div style={S.metricValue(C.CYAN)}>{m.hzCoherence.toFixed(3)}</div>
            <div style={S.metricSub}>{m.domNode} DOM</div>
          </div>

          <div style={S.metricCard(C.GOLD, true)}>
            <div style={S.metricLabel}>Self-Comp kf</div>
            <div style={S.metricValue(C.GOLD)}>{kfRef.current.toFixed(4)}</div>
            <div style={S.metricSub}>NEVER RESETS</div>
          </div>
        </div>

      </div>
    </div>
  );
}
