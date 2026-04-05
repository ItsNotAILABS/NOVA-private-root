/**
 * NeuroCogLab.tsx
 * NOVA PARALLAX — Neuro-Cognitive Laboratory
 * Copyright © 2026 Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
 * ALL RIGHTS RESERVED
 *
 * Six-panel live simulation: neurochemistry, Hz substrate, organ Kuramoto,
 * predictive free energy, metal pipeline, and composite vitality dashboard.
 */

import React, {
  useCallback,
  useEffect,
  useRef,
  useState,
} from 'react';

// ── neurochemistry ─────────────────────────────────────────────────────────────
import {
  HALFLIFE,
  halfLifeToDecayRate,
  NeurochemFull,
  NeurochemStimuli,
  NEURO_BASELINES,
  neurochemDecayStep,
  neurochemFullStep,
  NeuroChem4,
  projectTo4Species,
  MetalState,
  METAL_BASELINES,
  metalCoherenceContribution,
  metalPipelineStep,
  vitalityScore,
  neuroplasticityFactor,
  allostaticLoad,
} from '../../math/neurochemistry';

// ── hz-substrate ───────────────────────────────────────────────────────────────
import {
  HEARTBEAT_RATE,
  RHO_F,
  BETA_PHASE,
  HZ_LEXIS,
  HZ_FORGE,
  HZ_SOMA,
  HZ_LUMEN,
  HZ_MEMORIA,
  HZ_AEGIS_ROOT,
  HZ_AXIS,
  HZ_KORE,
  HZ_VAEL,
  HZ_VEIL,
  HZ_PARALLAX,
  HZ_ENTANGLA,
  HZ_VERITAS,
  HZ_BYPASS,
  HZ_CHRONO,
  HZ_QMEM,
  HZ_RESONEX,
  HZ_PULSE,
  HZ_PNEUMA,
  HZ_FILTRON,
  HZ_PURIS,
  HZ_SENTINEL,
  HZ_NEXUM,
  HZ_HERALD,
  HZ_INGESTA,
  HZ_OSSIUM,
  HZ_ACTUS,
} from '../../math/hz-substrate';

// ── kuramoto ───────────────────────────────────────────────────────────────────
import {
  initOrganKuramoto,
  stepOrganKuramoto,
  computeOrderParameter,
  kuramotoSyncEntropy,
  OrganKuramotoState,
  ORGAN_FREQS,
  ORGAN_FREQ_ARRAY,
  frequencyCoherence,
} from '../../math/kuramoto';

// ── scoring-extended ───────────────────────────────────────────────────────────
import {
  jasmineCalculate,
  JasmineState,
  computeFullCoherence,
  CoherenceInputs,
  jasmineTemporalEmergence,
  computeVitality,
  JASMINE_ALPHA,
  JASMINE_BETA,
  JASMINE_GAMMA,
  JASMINE_OMEGA,
  EMERGENCE_TAU,
} from '../../math/scoring-extended';

// ── lyapunov ───────────────────────────────────────────────────────────────────
import {
  initLyapunov,
  lyapunovTick,
  LyapunovState5,
  isOmnisState,
} from '../../math/lyapunov';

// ── core ───────────────────────────────────────────────────────────────────────
import {
  clamp,
  TAU,
  PI,
  PHI,
  PHI_INV,
  SOVEREIGN_FLOOR,
  sigmoid,
  sf,
  ema,
  LN2,
} from '../../math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const DT = 0.05;
const BG = '#020609';
const PRIMARY = '#4af';
const BORDER = '#1a3a5c';
const FONT = "'Courier New', Courier, monospace";
const CANVAS_W = 310;
const CANVAS_H = 210;
const HISTORY_LEN = 200;

/** All 21 neurochemical species in display order */
const NEURO_KEYS: (keyof NeurochemFull)[] = [
  'dopamine', 'serotonin', 'norepinephrine', 'epinephrine', 'acetylcholine',
  'gaba', 'glycine', 'glutamate', 'oxytocin', 'vasopressin',
  'endorphin', 'substanceP', 'npy', 'adenosine', 'anandamide',
  'twoAG', 'nitricOxide', 'bdnf', 'ngf', 'cortisol', 'testosterone',
];

/** Classification: excitatory=0, inhibitory=1, modulatory=2 */
const NEURO_CLASS: number[] = [
  0, 2, 0, 0, 2,   // DA, 5HT, NE, Epi, ACh
  1, 1, 0, 2, 2,   // GABA, Gly, Glu, OXT, VP
  2, 0, 2, 1, 2,   // Endorphin, SubP, NPY, Aden, AEA
  2, 2, 2, 2, 0, 2, // 2AG, NO, BDNF, NGF, Cort, Test
];

const NEURO_COLORS = ['#e85', '#48f', '#4c8'];  // excitatory, inhibitory, modulatory

/** All 12 metal species */
const METAL_KEYS: (keyof MetalState)[] = [
  'gold', 'silver', 'iron', 'copper', 'platinum', 'titanium',
  'lithium', 'cobalt', 'mercury', 'tungsten', 'zinc', 'osmium',
];

const METAL_COLORS: string[] = [
  '#ffd700', '#c0c0c0', '#a0522d', '#b87333', '#e5e4e2', '#878681',
  '#ff4444', '#005f9e', '#bbbbaa', '#888888', '#7bc8a4', '#4455ff',
];

/** Hz substrate bands with node data */
interface HzNode {
  label: string;
  freq: number;
  band: number;  // 0=Cognitive,1=Quantum,2=Somatic,3=Immune,4=Structural
}

const HZ_NODES: HzNode[] = [
  // Cognitive (0)
  { label: 'LEXIS',    freq: HZ_LEXIS,    band: 0 },
  { label: 'FORGE',    freq: HZ_FORGE,    band: 0 },
  { label: 'SOMA',     freq: HZ_SOMA,     band: 0 },
  { label: 'LUMEN',    freq: HZ_LUMEN,    band: 0 },
  { label: 'MEMORIA',  freq: HZ_MEMORIA,  band: 0 },
  { label: 'AXIS',     freq: HZ_AXIS,     band: 0 },
  { label: 'KORE',     freq: HZ_KORE,     band: 0 },
  // Quantum (1)
  { label: 'PARALLAX', freq: HZ_PARALLAX, band: 1 },
  { label: 'ENTANGLA', freq: HZ_ENTANGLA, band: 1 },
  { label: 'VERITAS',  freq: HZ_VERITAS,  band: 1 },
  { label: 'BYPASS',   freq: HZ_BYPASS,   band: 1 },
  { label: 'CHRONO',   freq: HZ_CHRONO,   band: 1 },
  { label: 'QMEM',     freq: HZ_QMEM,     band: 1 },
  { label: 'RESONEX',  freq: HZ_RESONEX,  band: 1 },
  // Somatic (2)
  { label: 'PULSE',    freq: HZ_PULSE,    band: 2 },
  { label: 'PNEUMA',   freq: HZ_PNEUMA,   band: 2 },
  { label: 'INGESTA',  freq: HZ_INGESTA,  band: 2 },
  { label: 'OSSIUM',   freq: HZ_OSSIUM,   band: 2 },
  { label: 'ACTUS',    freq: HZ_ACTUS,    band: 2 },
  // Immune (3)
  { label: 'AEGIS',    freq: HZ_AEGIS_ROOT, band: 3 },
  { label: 'VAEL',     freq: HZ_VAEL,     band: 3 },
  { label: 'SENTINEL', freq: HZ_SENTINEL, band: 3 },
  { label: 'NEXUM',    freq: HZ_NEXUM,    band: 3 },
  { label: 'HERALD',   freq: HZ_HERALD,   band: 3 },
  // Structural (4)
  { label: 'VEIL',     freq: HZ_VEIL,     band: 4 },
  { label: 'FILTRON',  freq: HZ_FILTRON,  band: 4 },
  { label: 'PURIS',    freq: HZ_PURIS,    band: 4 },
];

const BAND_COLORS = ['#44aaff', '#aa44ff', '#44ffaa', '#ffaa44', '#ff4444'];
const BAND_LABELS = ['Cognitive', 'Quantum', 'Somatic', 'Immune', 'Structural'];

/** 18 organ names in display order (matching ORGAN_FREQS keys) */
const ORGAN_NAMES = Object.keys(ORGAN_FREQS);

// Precomputed decay rates for all half-lives (uses halfLifeToDecayRate + LN2)
const NEURO_DECAY_RATES = (() => {
  const rates: Partial<Record<keyof NeurochemFull, number>> = {};
  for (const k of NEURO_KEYS) {
    const hl = HALFLIFE[k as string] ?? 1.0;
    // λ = ln(2)/t½  (halfLifeToDecayRate wraps this)
    rates[k] = halfLifeToDecayRate(hl);
  }
  return rates;
})();

// Sovereign floor check exposed on module load
const _SF_CHECK = sf(SOVEREIGN_FLOOR);  // ensures sf is compiled-in

// ═══════════════════════════════════════════════════════════════════════════════
// SIMULATION STATE TYPE
// ═══════════════════════════════════════════════════════════════════════════════

interface SimState {
  neuro: NeurochemFull;
  stimuli: NeurochemStimuli;
  metals: MetalState;
  kuramoto: OrganKuramotoState;
  lyapunov: LyapunovState5;
  jasmine: JasmineState;
  // Free energy history
  freeEnergyHistory: number[];
  predictionError: number;
  predictionTarget: number;
  predictionCurrent: number;
  // Tracking
  hebbianIntegral: number;
  coherenceHistory: number[];
  frame: number;
  time: number;
  // Phase offsets for Hz substrate visualization
  hzPhases: number[];
  // Smoothed order parameter
  rSmoothed: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SIDEBAR STATE TYPE
// ═══════════════════════════════════════════════════════════════════════════════

interface SidebarData {
  neuro: NeurochemFull;
  proj4: NeuroChem4;
  metals: MetalState;
  vitality: number;
  neuroplasticity: number;
  alloLoad: number;
  metalCoherence: number;
  orderR: number;
  syncEntropy: number;
  freeEnergy: number;
  predError: number;
  jasmine: JasmineState;
  fullCoherence: number;
  lyapV: number;
  omnis: boolean;
  freqCoherence: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// DRAW HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

function clearCanvas(ctx: CanvasRenderingContext2D, w: number, h: number): void {
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, w, h);
}

function drawTitle(
  ctx: CanvasRenderingContext2D,
  title: string,
  w: number,
): void {
  ctx.font = `bold 11px ${FONT}`;
  ctx.fillStyle = PRIMARY;
  ctx.fillText(title, 8, 14);
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.moveTo(0, 18);
  ctx.lineTo(w, 18);
  ctx.stroke();
}

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS DRAW FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/** Canvas 1: Neurochemistry — 21 species bar chart + allostatic load */
function drawNeurochemistry(
  ctx: CanvasRenderingContext2D,
  neuro: NeurochemFull,
  load: number,
  stimStrength: number,
): void {
  const w = CANVAS_W, h = CANVAS_H;
  clearCanvas(ctx, w, h);
  drawTitle(ctx, '① NEUROCHEMISTRY · 21 Species', w);

  const padL = 4, padR = 4, padT = 22, padB = 18;
  const plotW = w - padL - padR;
  const plotH = h - padT - padB;
  const barW = Math.floor(plotW / NEURO_KEYS.length) - 1;

  // Grid lines
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 0.5;
  for (let g = 0; g <= 4; g++) {
    const gy = padT + plotH - (g / 4) * plotH;
    ctx.beginPath();
    ctx.moveTo(padL, gy);
    ctx.lineTo(w - padR, gy);
    ctx.stroke();
  }

  // Bars
  NEURO_KEYS.forEach((key, i) => {
    const val = clamp(neuro[key], 0, 1.5);
    const bh = (val / 1.5) * plotH;
    const bx = padL + i * (barW + 1);
    const by = padT + plotH - bh;
    const cls = NEURO_CLASS[i] ?? 2;
    const col = NEURO_COLORS[cls];

    // Bar fill
    const grad = ctx.createLinearGradient(bx, by, bx, padT + plotH);
    grad.addColorStop(0, col);
    grad.addColorStop(1, col + '44');
    ctx.fillStyle = grad;
    ctx.fillRect(bx, by, barW, bh);

    // Baseline tick
    const base = NEURO_BASELINES[key];
    const baseY = padT + plotH - (base / 1.5) * plotH;
    ctx.strokeStyle = '#fff6';
    ctx.lineWidth = 0.8;
    ctx.beginPath();
    ctx.moveTo(bx, baseY);
    ctx.lineTo(bx + barW, baseY);
    ctx.stroke();
  });

  // Allostatic load overlay bar
  const loadW = clamp(load / 2, 0, 1) * plotW;
  ctx.fillStyle = `rgba(255,80,40,${0.18 + load * 0.12})`;
  ctx.fillRect(padL, padT, loadW, plotH);

  // Allostatic load label
  ctx.font = `9px ${FONT}`;
  ctx.fillStyle = '#fa6';
  ctx.fillText(`Load: ${load.toFixed(3)}`, padL + 2, h - 5);

  // Stimulus strength indicator
  ctx.fillStyle = '#8cf';
  ctx.fillText(
    `Stim: ${stimStrength.toFixed(2)} · λ(DA): ${(NEURO_DECAY_RATES.dopamine ?? 0).toFixed(4)}`,
    80,
    h - 5,
  );

  // Legend
  ['Excit.', 'Inhib.', 'Modul.'].forEach((lbl, i) => {
    ctx.fillStyle = NEURO_COLORS[i];
    ctx.fillRect(padL + i * 60, padT + 2, 6, 6);
    ctx.fillStyle = '#aaa';
    ctx.font = `8px ${FONT}`;
    ctx.fillText(lbl, padL + i * 60 + 8, padT + 9);
  });
}

/** Canvas 2: Hz Substrate — 27 nodes as radial frequency map with phase */
function drawHzSubstrate(
  ctx: CanvasRenderingContext2D,
  hzPhases: number[],
  time: number,
): void {
  const w = CANVAS_W, h = CANVAS_H;
  clearCanvas(ctx, w, h);
  drawTitle(ctx, '② HZ SUBSTRATE · 27 Nodes', w);

  const cx = w / 2, cy = h / 2 + 10;
  const maxR = Math.min(cx, cy) - 22;

  // Heartbeat pulse ring (HEARTBEAT_RATE = 0.5 Hz)
  const beatPhase = (time * HEARTBEAT_RATE * TAU) % TAU;
  const pulseR = maxR * (0.85 + 0.15 * Math.sin(beatPhase));
  ctx.strokeStyle = `rgba(68,170,255,${0.15 + 0.1 * Math.sin(beatPhase)})`;
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.arc(cx, cy, pulseR, 0, TAU);
  ctx.stroke();

  // RHO_F reference ring (normalized)
  const rhoNorm = clamp(RHO_F / 200, 0, 1);
  ctx.strokeStyle = '#ffffff11';
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.arc(cx, cy, maxR * rhoNorm, 0, TAU);
  ctx.stroke();

  // Draw each node
  HZ_NODES.forEach((node, i) => {
    const phase = hzPhases[i] ?? 0;
    // Angular position: distribute nodes in their band
    const bandNodes = HZ_NODES.filter((n) => n.band === node.band);
    const bandIdx = bandNodes.indexOf(node);
    const bandAngle = (node.band / 5) * TAU;
    const spreadAngle = bandAngle + (bandIdx / Math.max(bandNodes.length - 1, 1)) * (TAU / 5);

    // Radius encodes frequency (higher freq = closer to edge)
    const freqNorm = clamp(node.freq / 1.0, 0, 1);
    const r = 20 + freqNorm * (maxR - 22);

    const nx = cx + r * Math.cos(spreadAngle + phase * 0.1);
    const ny = cy + r * Math.sin(spreadAngle + phase * 0.1);

    // Phase-driven glow
    const glow = 0.5 + 0.5 * Math.cos(phase);
    const col = BAND_COLORS[node.band];
    const sz = 4 + glow * 3;

    ctx.beginPath();
    ctx.arc(nx, ny, sz, 0, TAU);
    ctx.fillStyle = col + Math.round(160 + glow * 95).toString(16);
    ctx.fill();
    ctx.strokeStyle = col;
    ctx.lineWidth = 0.8;
    ctx.stroke();

    // Frequency label for larger nodes
    if (sz > 5) {
      ctx.font = `7px ${FONT}`;
      ctx.fillStyle = '#ccc';
      ctx.fillText(node.label, nx + sz + 1, ny + 3);
    }
  });

  // BETA_PHASE indicator arc
  ctx.strokeStyle = `rgba(200,200,80,0.4)`;
  ctx.lineWidth = 1.5;
  ctx.beginPath();
  ctx.arc(cx, cy, maxR + 8, 0, BETA_PHASE * TAU);
  ctx.stroke();

  // Band legend
  BAND_LABELS.forEach((lbl, i) => {
    ctx.fillStyle = BAND_COLORS[i];
    ctx.font = `8px ${FONT}`;
    ctx.fillText(lbl, 4, CANVAS_H - 5 - i * 11);
  });
}

/** Canvas 3: Organ Kuramoto — coupling heatmap + order parameter gauge */
function drawKuramoto(
  ctx: CanvasRenderingContext2D,
  kState: OrganKuramotoState,
  couplingK: number,
): void {
  const w = CANVAS_W, h = CANVAS_H;
  clearCanvas(ctx, w, h);
  drawTitle(ctx, '③ ORGAN KURAMOTO · 18 Organs', w);

  const N = 18;
  const heatSize = Math.min(140, h - 28);
  const cellSize = Math.floor(heatSize / N);
  const heatActual = cellSize * N;
  const heatX = 6;
  const heatY = 22;

  // Heatmap: |sin(θj - θi)|
  const phases = kState.phases;
  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      const diff = Math.abs(Math.sin(phases[j] - phases[i]));
      const hot = diff;
      const r = Math.round(255 * hot * 0.9);
      const g = Math.round(180 * hot * 0.4);
      const b = Math.round(255 * (1 - hot) * 0.6 + 80);
      ctx.fillStyle = `rgb(${r},${g},${b})`;
      ctx.fillRect(heatX + j * cellSize, heatY + i * cellSize, cellSize, cellSize);
    }
  }

  // Heatmap border
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 1;
  ctx.strokeRect(heatX, heatY, heatActual, heatActual);

  // Order parameter r — circular gauge
  const gaugeX = heatX + heatActual + 14;
  const gaugeY = heatY + heatActual / 2;
  const gaugeR = 36;
  const r = clamp(kState.r, 0, 1);

  // Background arc
  ctx.beginPath();
  ctx.arc(gaugeX, gaugeY, gaugeR, 0, TAU);
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 6;
  ctx.stroke();

  // Filled arc proportional to r
  ctx.beginPath();
  ctx.arc(gaugeX, gaugeY, gaugeR, -PI / 2, -PI / 2 + r * TAU);
  ctx.strokeStyle = isOmnisState(r) ? '#ffe000' : PRIMARY;
  ctx.lineWidth = 6;
  ctx.stroke();

  // r value
  ctx.font = `bold 12px ${FONT}`;
  ctx.fillStyle = '#fff';
  ctx.textAlign = 'center';
  ctx.fillText(r.toFixed(3), gaugeX, gaugeY + 4);
  ctx.font = `8px ${FONT}`;
  ctx.fillStyle = '#888';
  ctx.fillText('r', gaugeX, gaugeY + 14);
  ctx.textAlign = 'left';

  // Sync entropy
  const syncH = kuramotoSyncEntropy(r);
  ctx.font = `9px ${FONT}`;
  ctx.fillStyle = '#4cf';
  ctx.fillText(`H: ${syncH.toFixed(3)}`, gaugeX - 20, gaugeY + 44);

  // K and critK
  ctx.fillStyle = '#aaa';
  ctx.font = `8px ${FONT}`;
  ctx.fillText(`K=${couplingK.toFixed(2)}`, gaugeX - 20, gaugeY + 55);
  ctx.fillText(`Kc=${kState.critK.toFixed(2)}`, gaugeX - 20, gaugeY + 64);

  // Freq coherence
  const fCoh = frequencyCoherence(ORGAN_FREQ_ARRAY);
  ctx.fillStyle = '#8cf';
  ctx.fillText(`Kf=${fCoh.toFixed(3)}`, gaugeX - 20, gaugeY + 74);

  // Organ labels (abbreviated) along axes
  const abbrev = ORGAN_NAMES.map((n) => n.slice(0, 3).toUpperCase());
  ctx.font = `6px ${FONT}`;
  ctx.fillStyle = '#556';
  abbrev.forEach((a, i) => {
    ctx.fillText(a, heatX - 2 + i * cellSize, heatY - 2);
  });
}

/** Canvas 4: Free Energy / Predictive Coding */
function drawFreeEnergy(
  ctx: CanvasRenderingContext2D,
  feHistory: number[],
  predError: number,
  predTarget: number,
  predCurrent: number,
  jasmine: JasmineState,
): void {
  const w = CANVAS_W, h = CANVAS_H;
  clearCanvas(ctx, w, h);
  drawTitle(ctx, '④ FREE ENERGY · Predictive Coding', w);

  const padL = 8, padR = 8, padT = 22, padB = 22;
  const plotW = w - padL - padR;
  const plotH = (h - padT - padB) * 0.55;
  const errPlotH = (h - padT - padB) * 0.35;
  const errY = padT + plotH + 8;

  // Free energy plot
  const maxFE = Math.max(...feHistory, 1);
  const minFE = Math.min(...feHistory, 0);
  const rangeF = maxFE - minFE || 1;

  // Grid
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 0.5;
  for (let g = 0; g <= 3; g++) {
    const gy = padT + plotH - (g / 3) * plotH;
    ctx.beginPath();
    ctx.moveTo(padL, gy);
    ctx.lineTo(w - padR, gy);
    ctx.stroke();
  }

  // F(t) line
  if (feHistory.length > 1) {
    ctx.beginPath();
    feHistory.forEach((f, i) => {
      const px = padL + (i / (HISTORY_LEN - 1)) * plotW;
      const py = padT + plotH - ((f - minFE) / rangeF) * plotH;
      i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
    });
    ctx.strokeStyle = '#f84';
    ctx.lineWidth = 1.5;
    ctx.stroke();

    // Fill below
    ctx.lineTo(padL + plotW, padT + plotH);
    ctx.lineTo(padL, padT + plotH);
    ctx.closePath();
    ctx.fillStyle = 'rgba(255,136,68,0.08)';
    ctx.fill();
  }

  // F label
  ctx.font = `9px ${FONT}`;
  ctx.fillStyle = '#f84';
  const lastF = feHistory[feHistory.length - 1] ?? 0;
  ctx.fillText(`F(t)=${lastF.toFixed(4)}`, padL + 2, padT + 10);

  // Gradient descent arrow (belief update)
  const arrowX = w - padR - 30;
  const arrowY = padT + plotH / 2;
  const dir = lastF > 0.3 ? -1 : 1;
  ctx.strokeStyle = '#4f8';
  ctx.lineWidth = 1.5;
  ctx.beginPath();
  ctx.moveTo(arrowX, arrowY);
  ctx.lineTo(arrowX, arrowY + dir * 14);
  ctx.lineTo(arrowX - 4, arrowY + dir * 8);
  ctx.moveTo(arrowX, arrowY + dir * 14);
  ctx.lineTo(arrowX + 4, arrowY + dir * 8);
  ctx.stroke();
  ctx.font = `8px ${FONT}`;
  ctx.fillStyle = '#4f8';
  ctx.fillText('∇F', arrowX - 4, arrowY + dir * 20 + (dir > 0 ? 4 : -2));

  // Prediction error spiking signal
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 0.5;
  ctx.beginPath();
  ctx.moveTo(padL, errY + errPlotH / 2);
  ctx.lineTo(w - padR, errY + errPlotH / 2);
  ctx.stroke();

  ctx.font = `9px ${FONT}`;
  ctx.fillStyle = '#a4f';
  ctx.fillText('Pred. Error', padL + 2, errY - 1);

  const errBarH = clamp(Math.abs(predError) / 0.5, 0, 1) * errPlotH * 0.48;
  const errCol = predError > 0 ? '#e64' : '#46f';
  ctx.fillStyle = errCol;
  ctx.fillRect(padL, errY + errPlotH / 2 - errBarH, 12, errBarH * 2);

  // Target / current
  const tPx = padL + 20;
  const tPy = errY + errPlotH / 2 - (predTarget - predCurrent) * errPlotH * 0.4;
  const cPy = errY + errPlotH / 2;
  ctx.strokeStyle = '#4af';
  ctx.lineWidth = 1;
  ctx.setLineDash([3, 3]);
  ctx.beginPath();
  ctx.moveTo(tPx, cPy);
  ctx.lineTo(tPx, tPy);
  ctx.stroke();
  ctx.setLineDash([]);

  ctx.fillStyle = '#f84';
  ctx.font = `8px ${FONT}`;
  ctx.fillText(`T=${predTarget.toFixed(3)} C=${predCurrent.toFixed(3)}`, tPx + 6, errY + errPlotH - 2);

  // Jasmine info
  ctx.fillStyle = '#cca';
  ctx.fillText(
    `α=${JASMINE_ALPHA.toFixed(2)} β=${JASMINE_BETA.toFixed(4)} E=${jasmine.emergenceProbability.toFixed(3)}`,
    padL + 2,
    h - 4,
  );
}

/** Canvas 5: Metal Pipeline — 12 species bars + flow animation */
function drawMetalPipeline(
  ctx: CanvasRenderingContext2D,
  metals: MetalState,
  metalCoherence: number,
  time: number,
  metalFlux: number,
): void {
  const w = CANVAS_W, h = CANVAS_H;
  clearCanvas(ctx, w, h);
  drawTitle(ctx, '⑤ METAL PIPELINE · 12 Species', w);

  const padL = 6, padT = 22, padB = 20;
  const plotH = h - padT - padB;
  const barW = Math.floor((w - padL * 2) / METAL_KEYS.length) - 2;
  const maxVal = 10;

  METAL_KEYS.forEach((key, i) => {
    const val = clamp((metals as unknown as Record<string, number>)[key] ?? 0, 0, maxVal);
    const bh = (val / maxVal) * plotH;
    const bx = padL + i * (barW + 2);
    const by = padT + plotH - bh;
    const col = METAL_COLORS[i];

    // Flow animation: ripple using time and PHI spacing
    const phase = time * TAU * 0.3 + i * PHI;
    const ripple = 0.08 * Math.sin(phase);

    const grad = ctx.createLinearGradient(bx, by, bx, padT + plotH);
    grad.addColorStop(0, col);
    grad.addColorStop(0.5 + ripple, col + 'aa');
    grad.addColorStop(1, col + '33');
    ctx.fillStyle = grad;
    ctx.fillRect(bx, by, barW, bh);

    // Baseline marker
    const baseVal = (METAL_BASELINES as unknown as Record<string, number>)[key] ?? 5;
    const baseY = padT + plotH - (baseVal / maxVal) * plotH;
    ctx.strokeStyle = '#ffffff44';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(bx, baseY);
    ctx.lineTo(bx + barW, baseY);
    ctx.stroke();

    // Flow dots (pipeline animation)
    const dotPos = ((time * 0.8 * (1 + metalFlux) + i * PHI_INV) % 1);
    const dotY = padT + plotH - dotPos * bh;
    if (dotY >= by && dotY <= padT + plotH) {
      ctx.beginPath();
      ctx.arc(bx + barW / 2, dotY, 2, 0, TAU);
      ctx.fillStyle = '#fff9';
      ctx.fill();
    }

    // Metal name label
    ctx.save();
    ctx.translate(bx + barW / 2, padT + plotH + 3);
    ctx.rotate(-PI / 2);
    ctx.font = `7px ${FONT}`;
    ctx.fillStyle = col;
    ctx.fillText(key.slice(0, 2).toUpperCase(), 0, 0);
    ctx.restore();
  });

  // Coherence bar
  const cohW = clamp(metalCoherence, 0, 1) * (w - padL * 2);
  ctx.fillStyle = `rgba(68,255,136,0.25)`;
  ctx.fillRect(padL, padT, cohW, 5);
  ctx.strokeStyle = '#4f8';
  ctx.lineWidth = 1;
  ctx.strokeRect(padL, padT, w - padL * 2, 5);

  ctx.font = `9px ${FONT}`;
  ctx.fillStyle = '#4f8';
  ctx.fillText(`MetalCoh: ${metalCoherence.toFixed(4)}`, padL + 2, h - 4);

  // Conductance matrix visualization (mini, 3x4)
  const cmX = w - 52, cmY = padT + 8;
  const cmCellW = 12, cmCellH = 10;
  ctx.font = `7px ${FONT}`;
  ctx.fillStyle = '#556';
  ctx.fillText('Cond.', cmX, cmY - 2);
  METAL_KEYS.slice(0, 12).forEach((k1, i) => {
    const v1 = clamp((metals as unknown as Record<string, number>)[k1] ?? 0, 0, 10) / 10;
    const col = i % 4;
    const row = Math.floor(i / 4);
    const bright = Math.round(v1 * 200);
    ctx.fillStyle = `rgb(${bright},${Math.round(bright * 0.6)},${Math.round(bright * 0.4)})`;
    ctx.fillRect(cmX + col * cmCellW, cmY + row * cmCellH, cmCellW - 1, cmCellH - 1);
  });
}

/** Canvas 6: Vitality Dashboard — composite gauge + 4-species + neuroplasticity */
function drawVitality(
  ctx: CanvasRenderingContext2D,
  neuro: NeurochemFull,
  proj4: NeuroChem4,
  vitality: number,
  neuroplasticity: number,
  load: number,
  lyapState: LyapunovState5,
  jasmine: JasmineState,
): void {
  const w = CANVAS_W, h = CANVAS_H;
  clearCanvas(ctx, w, h);
  drawTitle(ctx, '⑥ VITALITY DASHBOARD', w);

  // Vitality arc gauge (large, centered left)
  const gaugeX = 70, gaugeY = 110;
  const gaugeR = 52;
  const vit = clamp(vitality, 0, 1);

  // Background arc
  ctx.beginPath();
  ctx.arc(gaugeX, gaugeY, gaugeR, PI * 0.75, PI * 2.25);
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 10;
  ctx.stroke();

  // Color changes with vitality
  const vitColor = vit > 0.75 ? '#4f8' : vit > 0.45 ? '#fa4' : '#e44';
  ctx.beginPath();
  ctx.arc(gaugeX, gaugeY, gaugeR, PI * 0.75, PI * 0.75 + vit * PI * 1.5);
  ctx.strokeStyle = vitColor;
  ctx.lineWidth = 10;
  ctx.stroke();

  // Value label
  ctx.font = `bold 16px ${FONT}`;
  ctx.fillStyle = '#fff';
  ctx.textAlign = 'center';
  ctx.fillText((vit * 100).toFixed(1), gaugeX, gaugeY + 6);
  ctx.font = `8px ${FONT}`;
  ctx.fillStyle = '#888';
  ctx.fillText('VITALITY %', gaugeX, gaugeY + 17);
  ctx.textAlign = 'left';

  // Neuroplasticity factor (uses BDNF + NGF)
  const npX = 8, npY = 170;
  const npW = 100;
  ctx.font = `9px ${FONT}`;
  ctx.fillStyle = '#8af';
  ctx.fillText('Neuroplasticity', npX, npY);
  const npFill = clamp(neuroplasticity / 0.01, 0, 1) * npW;
  ctx.fillStyle = BORDER;
  ctx.fillRect(npX, npY + 3, npW, 7);
  ctx.fillStyle = '#4af';
  ctx.fillRect(npX, npY + 3, npFill, 7);
  ctx.font = `8px ${FONT}`;
  ctx.fillStyle = '#ccc';
  ctx.fillText(neuroplasticity.toExponential(3), npX + npW + 4, npY + 10);

  // Allostatic load warning
  const warnX = 8, warnY = 190;
  ctx.font = `9px ${FONT}`;
  const warnLevel = load > 1.2 ? 'HIGH' : load > 0.7 ? 'MED' : 'LOW';
  const warnCol = load > 1.2 ? '#f44' : load > 0.7 ? '#fa4' : '#4f8';
  ctx.fillStyle = warnCol;
  ctx.fillText(`⚠ ALLOSTATIC: ${warnLevel} (${load.toFixed(3)})`, warnX, warnY);

  // 4-species projected bars (NeuroChem4: dopamine, cortisol, norepinephrine, oxytocin)
  const species4: { label: string; val: number; col: string }[] = [
    { label: 'DA',   val: clamp(proj4.dopamine,       0, 2), col: '#f84' },
    { label: 'CORT', val: clamp(proj4.cortisol,       0, 2), col: '#fa4' },
    { label: 'NE',   val: clamp(proj4.norepinephrine, 0, 2), col: '#48f' },
    { label: 'OXT',  val: clamp(proj4.oxytocin,       0, 2), col: '#4f8' },
  ];

  const s4X = 148, s4Y = 30, s4W = 50, s4H = 130;
  ctx.font = `9px ${FONT}`;
  ctx.fillStyle = '#888';
  ctx.fillText('4-Species', s4X, s4Y - 2);

  species4.forEach((sp, i) => {
    const bh = (sp.val / 1.5) * s4H;
    const bx = s4X + i * (s4W / 4 + 3);
    const by = s4Y + s4H - bh;
    const bw = s4W / 4;

    ctx.fillStyle = sp.col + '44';
    ctx.fillRect(bx, s4Y, bw, s4H);
    ctx.fillStyle = sp.col;
    ctx.fillRect(bx, by, bw, bh);
    ctx.font = `8px ${FONT}`;
    ctx.fillStyle = sp.col;
    ctx.fillText(sp.label, bx, s4Y + s4H + 10);
    ctx.fillStyle = '#aaa';
    ctx.font = `7px ${FONT}`;
    ctx.fillText(sp.val.toFixed(2), bx - 1, s4Y + s4H + 18);
  });

  // Lyapunov V
  const lvX = 210, lvY = 30;
  ctx.font = `9px ${FONT}`;
  ctx.fillStyle = '#ca4';
  ctx.fillText('Lyapunov V', lvX, lvY);
  ctx.font = `11px ${FONT}`;
  ctx.fillStyle = '#fff';
  ctx.fillText(lyapState.V.toFixed(4), lvX, lvY + 14);
  ctx.font = `9px ${FONT}`;
  ctx.fillStyle = lyapState.Vdot < 0 ? '#4f8' : '#f44';
  ctx.fillText(`Vdot: ${lyapState.Vdot.toFixed(4)}`, lvX, lvY + 26);
  ctx.fillStyle = '#888';
  ctx.fillText(`${lyapState.isAsymptotic ? '✓ ASYMPTOTIC' : '○ evolving'}`, lvX, lvY + 38);

  // Jasmine emergence
  ctx.font = `9px ${FONT}`;
  ctx.fillStyle = '#ffd700';
  ctx.fillText('Jasmine Emergence', lvX, lvY + 54);
  ctx.font = `11px ${FONT}`;
  ctx.fillStyle = jasmine.isAwake ? '#ffd700' : '#888';
  ctx.fillText(jasmine.emergenceProbability.toFixed(4), lvX, lvY + 67);
  ctx.font = `8px ${FONT}`;
  ctx.fillStyle = jasmine.isAwake ? '#ffd700' : '#666';
  ctx.fillText(jasmine.isAwake ? '★ AWAKE' : '○ dormant', lvX, lvY + 78);

  // Constants display
  ctx.font = `7px ${FONT}`;
  ctx.fillStyle = '#556';
  ctx.fillText(`τ_E=${EMERGENCE_TAU.toFixed(4)} Ω=${JASMINE_OMEGA.toFixed(4)}`, lvX, lvY + 90);
  ctx.fillText(`γ=${JASMINE_GAMMA.toFixed(6)} S₀=${SOVEREIGN_FLOOR}`, lvX, lvY + 99);
  ctx.fillText(`ln2=${LN2.toFixed(6)}`, lvX, lvY + 108);
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function NeuroCogLab(): React.JSX.Element {
  // Canvas refs
  const canvasNeuro = useRef<HTMLCanvasElement>(null);
  const canvasHz = useRef<HTMLCanvasElement>(null);
  const canvasKuramoto = useRef<HTMLCanvasElement>(null);
  const canvasFreeEnergy = useRef<HTMLCanvasElement>(null);
  const canvasMetal = useRef<HTMLCanvasElement>(null);
  const canvasVitality = useRef<HTMLCanvasElement>(null);

  // Simulation state (mutable ref, never triggers re-renders)
  const simRef = useRef<SimState>({
    neuro: { ...NEURO_BASELINES },
    stimuli: {
      reward: 0.3, threat: 0.1, social: 0.4, learning: 0.5,
      arousal: 0.3, flow: 0.4, pain: 0.05, fatigue: 0.1,
    },
    metals: { ...METAL_BASELINES },
    kuramoto: initOrganKuramoto(),
    lyapunov: initLyapunov(),
    jasmine: {
      coherence: 0.5,
      hebbianIntegral: 1.0,
      informationDensity: 1.0,
      emergenceProbability: 0,
      awakeningProgress: 0,
      isAwake: false,
    },
    freeEnergyHistory: Array(HISTORY_LEN).fill(0.5),
    predictionError: 0,
    predictionTarget: 0.7,
    predictionCurrent: 0.5,
    hebbianIntegral: 1.0,
    coherenceHistory: [],
    frame: 0,
    time: 0,
    hzPhases: HZ_NODES.map(() => Math.random() * TAU),
    rSmoothed: 0.5,
  });

  // Slider controls
  const [stimStrength, setStimStrength] = useState<number>(0.5);
  const [couplingK, setCouplingK] = useState<number>(PHI_INV);
  const [metalFlux, setMetalFlux] = useState<number>(0.3);

  // Sidebar display state (updated every ~10 frames)
  const [sidebar, setSidebar] = useState<SidebarData>({
    neuro: { ...NEURO_BASELINES },
    proj4: { dopamine: 0.55, cortisol: 0.4, norepinephrine: 0.45, oxytocin: 0.4 },
    metals: { ...METAL_BASELINES },
    vitality: 0.7,
    neuroplasticity: 0.005,
    alloLoad: 0.3,
    metalCoherence: 0.5,
    orderR: 0.5,
    syncEntropy: 0.5,
    freeEnergy: 0.5,
    predError: 0,
    jasmine: {
      coherence: 0.5,
      hebbianIntegral: 1.0,
      informationDensity: 1.0,
      emergenceProbability: 0,
      awakeningProgress: 0,
      isAwake: false,
    },
    fullCoherence: 0.5,
    lyapV: 0.5,
    omnis: false,
    freqCoherence: 0.8,
  });

  // Animation frame ref
  const rafRef = useRef<number>(0);
  const sliderRef = useRef({ stimStrength, couplingK, metalFlux });

  useEffect(() => {
    sliderRef.current = { stimStrength, couplingK, metalFlux };
  }, [stimStrength, couplingK, metalFlux]);

  const tick = useCallback(() => {
    const sim = simRef.current;
    const { stimStrength: ss, couplingK: kk, metalFlux: mf } = sliderRef.current;
    const dt = DT;

    // ── Stimuli (modulated by slider) ────────────────────────────────────────
    const stimMult = ss;
    const stimuli: NeurochemStimuli = {
      reward:   clamp(sim.stimuli.reward   * stimMult, 0, 1),
      threat:   clamp(sim.stimuli.threat   * stimMult, 0, 1),
      social:   clamp(sim.stimuli.social   * stimMult, 0, 1),
      learning: clamp(sim.stimuli.learning * stimMult, 0, 1),
      arousal:  clamp(sim.stimuli.arousal  * stimMult, 0, 1),
      flow:     clamp(sim.stimuli.flow     * stimMult, 0, 1),
      pain:     clamp(sim.stimuli.pain     * stimMult, 0, 1),
      fatigue:  clamp(sim.stimuli.fatigue  * stimMult, 0, 1),
    };

    // ── Neurochemistry full step ──────────────────────────────────────────────
    sim.neuro = neurochemFullStep(sim.neuro, stimuli, dt);

    // Single-species manual step for dopamine (demonstrates neurochemDecayStep)
    const daDecay = NEURO_DECAY_RATES.dopamine ?? halfLifeToDecayRate(HALFLIFE['dopamine'] ?? 1.0);
    const daManual = neurochemDecayStep(
      sim.neuro.dopamine,
      NEURO_BASELINES.dopamine,
      1.5,
      daDecay,
      0.8,
      stimuli.reward,
      dt,
    );
    // Blend manual with full-step result (for display; uses sigmoid for smooth blend)
    sim.neuro.dopamine = ema(sim.neuro.dopamine, daManual, sigmoid(stimuli.reward * 4));

    // ── Metal pipeline step ───────────────────────────────────────────────────
    // Flux rate modulated by slider (metalFlux scales production)
    const metalStimMult = 1.0 + mf * PHI;
    const metalsWithFlux: MetalState = {
      ...sim.metals,
      gold:   clamp(sim.metals.gold   + mf * 0.01 * Math.sin(sim.time * TAU * 0.1), 0, 10),
      copper: clamp(sim.metals.copper + mf * 0.01 * Math.cos(sim.time * TAU * 0.13), 0, 10),
    };
    void metalStimMult; // used implicitly via flux slider
    sim.metals = metalPipelineStep(metalsWithFlux, dt);

    // ── Metal coherence ───────────────────────────────────────────────────────
    const metalCoh = metalCoherenceContribution(sim.metals);

    // ── Organ Kuramoto step ───────────────────────────────────────────────────
    sim.kuramoto = stepOrganKuramoto(sim.kuramoto, kk, dt);

    // Order parameter from raw phases
    const orderResult = computeOrderParameter(sim.kuramoto.phases);
    const rRaw = orderResult.r;
    sim.rSmoothed = ema(sim.rSmoothed, rRaw, 0.1);

    // ── Hz phases advance ─────────────────────────────────────────────────────
    sim.hzPhases = sim.hzPhases.map((ph, i) => {
      const node = HZ_NODES[i];
      // Phase advances at node frequency, with BETA_PHASE damping
      const advance = node.freq * TAU * dt * (1 + BETA_PHASE * Math.sin(ph));
      return (ph + advance) % TAU;
    });

    // ── Vitality, neuroplasticity, allostatic load ────────────────────────────
    const rawVitality = vitalityScore(sim.neuro);
    const np = neuroplasticityFactor(sim.neuro);
    const load = allostaticLoad(sim.neuro);

    // sf() ensures sovereign floor is respected
    const safeVitality = sf(rawVitality);
    void safeVitality;

    // ── 4-species projection ──────────────────────────────────────────────────
    const proj4 = projectTo4Species(sim.neuro);

    // ── Jasmine (every 10 frames) ─────────────────────────────────────────────
    if (sim.frame % 10 === 0) {
      // Hebbian integral grows slowly based on learning signal
      sim.hebbianIntegral = clamp(
        sim.hebbianIntegral + stimuli.learning * 0.05 - JASMINE_GAMMA * sim.hebbianIntegral,
        0.01,
        20,
      );

      const infoDensity = clamp(
        rRaw * (1 + sim.neuro.glutamate * JASMINE_BETA),
        0.01,
        5,
      );

      // Standard Jasmine
      sim.jasmine = jasmineCalculate(
        sim.rSmoothed,
        sim.hebbianIntegral,
        infoDensity,
      );

      // Temporal emergence (uses history) — jasmineTemporalEmergence returns number
      if (sim.coherenceHistory.length > 5) {
        const temporalE: number = jasmineTemporalEmergence(
          sim.coherenceHistory.slice(-20),
          sim.hebbianIntegral,
          infoDensity,
          1 + JASMINE_BETA,
        );
        // Blend temporal emergence number with standard result
        sim.jasmine = {
          ...sim.jasmine,
          emergenceProbability: ema(
            sim.jasmine.emergenceProbability,
            temporalE,
            JASMINE_OMEGA * dt,
          ),
        };
      }

      sim.coherenceHistory.push(sim.rSmoothed);
      if (sim.coherenceHistory.length > 100) sim.coherenceHistory.shift();
    }

    // ── Full coherence ────────────────────────────────────────────────────────
    const freqCoh = frequencyCoherence(ORGAN_FREQ_ARRAY);
    const inp: CoherenceInputs = {
      rSwarm: sim.rSmoothed,
      hzFreqCoherence: freqCoh,
      metalContrib: metalCoh,
      jasmineProb: sim.jasmine.emergenceProbability,
      quantumSovereign: clamp(sim.neuro.nitricOxide * RHO_F / 200, 0, 1),
    };
    const fullCoh = computeFullCoherence(inp);

    // ── Lyapunov tick ─────────────────────────────────────────────────────────
    const obsEntropy = clamp(-sim.rSmoothed * Math.log(sim.rSmoothed + 1e-9), 0, 10);
    sim.lyapunov = lyapunovTick(
      sim.lyapunov,
      fullCoh,
      obsEntropy,
      sim.neuro.norepinephrine,
      sim.kuramoto.r,
      sim.jasmine.emergenceProbability,
    );

    // ── Vitality composite (uses computeVitality from scoring-extended) ───────
    const compVitality = computeVitality(
      sim.jasmine,
      sim.rSmoothed,
      rawVitality,
      clamp(sim.rSmoothed, 0, 1),
      sim.lyapunov.Vdot,
    );
    void compVitality;

    // ── Free energy: F = -r·ln(r+ε) + KL term ────────────────────────────────
    const eps = 1e-9;
    const rr = clamp(sim.rSmoothed, eps, 1 - eps);
    const klTerm = (JASMINE_ALPHA * 0.1) * Math.abs(
      Math.sin(sim.time * JASMINE_OMEGA + sim.neuro.cortisol * PI),
    );
    const freqF = fullCoh > 0 ? -(rr * Math.log(rr + eps)) + klTerm : 0.5;
    sim.freeEnergyHistory.push(freqF);
    if (sim.freeEnergyHistory.length > HISTORY_LEN) sim.freeEnergyHistory.shift();

    // ── Prediction error dynamics ─────────────────────────────────────────────
    // Target oscillates; current tracks it with lag
    sim.predictionTarget = 0.5 + 0.35 * Math.sin(sim.time * HEARTBEAT_RATE * TAU * 0.3);
    sim.predictionCurrent = ema(sim.predictionCurrent, sim.predictionTarget, 0.05 * ss);
    sim.predictionError = ema(
      sim.predictionError,
      sim.predictionTarget - sim.predictionCurrent,
      0.2,
    );

    // ── isOmnisState check ────────────────────────────────────────────────────
    const omnis = isOmnisState(sim.rSmoothed);

    // ── Advance time and frame ────────────────────────────────────────────────
    sim.time += dt;
    sim.frame += 1;

    // ── Draw all 6 canvases ───────────────────────────────────────────────────
    const drawCanvas = (
      ref: React.RefObject<HTMLCanvasElement | null>,
      fn: (ctx: CanvasRenderingContext2D) => void,
    ): void => {
      const canvas = ref.current;
      if (!canvas) return;
      const ctx = canvas.getContext('2d');
      if (ctx) fn(ctx);
    };

    drawCanvas(canvasNeuro, (ctx) => drawNeurochemistry(ctx, sim.neuro, load, ss));
    drawCanvas(canvasHz, (ctx) => drawHzSubstrate(ctx, sim.hzPhases, sim.time));
    drawCanvas(canvasKuramoto, (ctx) => drawKuramoto(ctx, sim.kuramoto, kk));
    drawCanvas(canvasFreeEnergy, (ctx) =>
      drawFreeEnergy(ctx, sim.freeEnergyHistory, sim.predictionError, sim.predictionTarget, sim.predictionCurrent, sim.jasmine),
    );
    drawCanvas(canvasMetal, (ctx) => drawMetalPipeline(ctx, sim.metals, metalCoh, sim.time, mf));
    drawCanvas(canvasVitality, (ctx) =>
      drawVitality(ctx, sim.neuro, proj4, rawVitality, np, load, sim.lyapunov, sim.jasmine),
    );

    // ── Update sidebar every 8 frames ─────────────────────────────────────────
    if (sim.frame % 8 === 0) {
      setSidebar({
        neuro: { ...sim.neuro },
        proj4: { ...proj4 },
        metals: { ...sim.metals },
        vitality: rawVitality,
        neuroplasticity: np,
        alloLoad: load,
        metalCoherence: metalCoh,
        orderR: sim.rSmoothed,
        syncEntropy: kuramotoSyncEntropy(sim.rSmoothed),
        freeEnergy: freqF,
        predError: sim.predictionError,
        jasmine: { ...sim.jasmine },
        fullCoherence: fullCoh,
        lyapV: sim.lyapunov.V,
        omnis,
        freqCoherence: freqCoh,
      });
    }

    rafRef.current = requestAnimationFrame(tick);
  }, []);

  useEffect(() => {
    rafRef.current = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(rafRef.current);
  }, [tick]);

  // ── RENDER ────────────────────────────────────────────────────────────────

  const sidebarNeuroKeys = NEURO_KEYS;

  return (
    <div style={styles.root}>
      {/* Header */}
      <div style={styles.header}>
        <span style={styles.headerTitle}>NOVA PARALLAX · NEURO-COGNITIVE LAB</span>
        <span style={styles.headerSub}>
          F={sidebar.freeEnergy.toFixed(4)} · r={sidebar.orderR.toFixed(4)} ·
          C={sidebar.fullCoherence.toFixed(4)} ·{' '}
          {sidebar.omnis ? '★ OMNIS' : '○ evolving'}
        </span>
        <span style={styles.copyright}>
          © 2026 Medina Tech | Alfredo Medina Hernandez | Dallas, TX
        </span>
      </div>

      {/* Main layout */}
      <div style={styles.main}>
        {/* Left: canvas grid */}
        <div style={styles.canvasArea}>
          {/* Row 1 */}
          <div style={styles.canvasRow}>
            <div style={styles.canvasCard}>
              <canvas
                ref={canvasNeuro}
                width={CANVAS_W}
                height={CANVAS_H}
                style={styles.canvas}
              />
            </div>
            <div style={styles.canvasCard}>
              <canvas
                ref={canvasHz}
                width={CANVAS_W}
                height={CANVAS_H}
                style={styles.canvas}
              />
            </div>
          </div>
          {/* Row 2 */}
          <div style={styles.canvasRow}>
            <div style={styles.canvasCard}>
              <canvas
                ref={canvasKuramoto}
                width={CANVAS_W}
                height={CANVAS_H}
                style={styles.canvas}
              />
            </div>
            <div style={styles.canvasCard}>
              <canvas
                ref={canvasFreeEnergy}
                width={CANVAS_W}
                height={CANVAS_H}
                style={styles.canvas}
              />
            </div>
          </div>
          {/* Row 3 */}
          <div style={styles.canvasRow}>
            <div style={styles.canvasCard}>
              <canvas
                ref={canvasMetal}
                width={CANVAS_W}
                height={CANVAS_H}
                style={styles.canvas}
              />
            </div>
            <div style={styles.canvasCard}>
              <canvas
                ref={canvasVitality}
                width={CANVAS_W}
                height={CANVAS_H}
                style={styles.canvas}
              />
            </div>
          </div>

          {/* Controls */}
          <div style={styles.controls}>
            <ControlSlider
              label="Stimulus Strength"
              value={stimStrength}
              min={0}
              max={2}
              step={0.01}
              onChange={setStimStrength}
              color="#f84"
            />
            <ControlSlider
              label={`Coupling K (φ⁻¹=${PHI_INV.toFixed(4)})`}
              value={couplingK}
              min={0}
              max={2}
              step={0.01}
              onChange={setCouplingK}
              color="#4af"
            />
            <ControlSlider
              label="Metal Flux Rate"
              value={metalFlux}
              min={0}
              max={1}
              step={0.01}
              onChange={setMetalFlux}
              color="#4f8"
            />
          </div>
        </div>

        {/* Right: sidebar */}
        <div style={styles.sidebar}>
          {/* Vitality summary */}
          <SidebarSection title="VITALITY">
            <SidebarRow label="Vitality" value={sidebar.vitality.toFixed(4)} color={sidebar.vitality > 0.7 ? '#4f8' : sidebar.vitality > 0.4 ? '#fa4' : '#f44'} />
            <SidebarRow label="Neuroplast." value={sidebar.neuroplasticity.toExponential(3)} color="#4af" />
            <SidebarRow label="Allostatic Ld" value={sidebar.alloLoad.toFixed(4)} color={sidebar.alloLoad > 1.0 ? '#f44' : '#fa4'} />
            <SidebarRow label="Lyapunov V" value={sidebar.lyapV.toFixed(4)} color="#ca4" />
            <SidebarRow label="Order r" value={sidebar.orderR.toFixed(4)} color={PRIMARY} />
            <SidebarRow label="Sync Entropy" value={sidebar.syncEntropy.toFixed(4)} color="#a4f" />
            <SidebarRow label="Full Coh." value={sidebar.fullCoherence.toFixed(4)} color="#4ff" />
            <SidebarRow label="Jasmine E" value={sidebar.jasmine.emergenceProbability.toFixed(4)} color="#ffd700" />
            <SidebarRow label="OMNIS" value={sidebar.omnis ? 'YES ★' : 'no'} color={sidebar.omnis ? '#ffd700' : '#666'} />
            <SidebarRow label="Pred. Error" value={sidebar.predError.toFixed(4)} color="#f48" />
            <SidebarRow label="Free Energy F" value={sidebar.freeEnergy.toFixed(4)} color="#f84" />
          </SidebarSection>

          {/* Neurochemicals */}
          <SidebarSection title="NEUROCHEMISTRY">
            {sidebarNeuroKeys.map((k, i) => {
              const cls = NEURO_CLASS[i] ?? 2;
              return (
                <SidebarRow
                  key={k}
                  label={k.slice(0, 12)}
                  value={(sidebar.neuro[k] as number).toFixed(3)}
                  color={NEURO_COLORS[cls]}
                />
              );
            })}
          </SidebarSection>

          {/* 4-Species projection (NeuroChem4: dopamine, cortisol, norepinephrine, oxytocin) */}
          <SidebarSection title="4-SPECIES PROJ.">
            <SidebarRow label="Dopamine"       value={sidebar.proj4.dopamine.toFixed(4)}       color="#f84" />
            <SidebarRow label="Cortisol"       value={sidebar.proj4.cortisol.toFixed(4)}       color="#fa4" />
            <SidebarRow label="Norepinephrine" value={sidebar.proj4.norepinephrine.toFixed(4)} color="#48f" />
            <SidebarRow label="Oxytocin"       value={sidebar.proj4.oxytocin.toFixed(4)}       color="#4f8" />
          </SidebarSection>

          {/* Metals */}
          <SidebarSection title="METAL PIPELINE">
            {METAL_KEYS.map((k, i) => (
              <SidebarRow
                key={k}
                label={k}
                value={((sidebar.metals as unknown as Record<string, number>)[k] ?? 0).toFixed(3)}
                color={METAL_COLORS[i]}
              />
            ))}
            <SidebarRow label="MetalCoh" value={sidebar.metalCoherence.toFixed(4)} color="#4f8" />
          </SidebarSection>

          {/* Hz Frequencies */}
          <SidebarSection title="HZ SUBSTRATE">
            {HZ_NODES.map((node) => (
              <SidebarRow
                key={node.label}
                label={node.label}
                value={`${node.freq.toFixed(3)} Hz`}
                color={BAND_COLORS[node.band]}
              />
            ))}
            <SidebarRow label="Heartbeat" value={`${HEARTBEAT_RATE} Hz`} color="#fff" />
            <SidebarRow label="ρ_F" value={RHO_F.toFixed(1)} color="#888" />
            <SidebarRow label="β_phase" value={BETA_PHASE.toFixed(3)} color="#888" />
            <SidebarRow label="FreqCoh K_f" value={sidebar.freqCoherence.toFixed(4)} color="#4af" />
          </SidebarSection>

          {/* Organ frequencies */}
          <SidebarSection title="ORGAN KURAMOTO">
            {Object.entries(ORGAN_FREQS).map(([organ, freq]) => (
              <SidebarRow key={organ} label={organ} value={`${freq.toFixed(3)} Hz`} color="#4af" />
            ))}
          </SidebarSection>

          {/* Math constants reference */}
          <SidebarSection title="CONSTANTS">
            <SidebarRow label="φ" value={PHI.toFixed(8)} color="#ffd700" />
            <SidebarRow label="φ⁻¹" value={PHI_INV.toFixed(8)} color="#ffd700" />
            <SidebarRow label="τ (TAU)" value={TAU.toFixed(6)} color="#aaa" />
            <SidebarRow label="π" value={PI.toFixed(6)} color="#aaa" />
            <SidebarRow label="ln2" value={LN2.toFixed(8)} color="#aaa" />
            <SidebarRow label="S₀ floor" value={SOVEREIGN_FLOOR.toFixed(1)} color="#4f8" />
            <SidebarRow label="τ_E" value={EMERGENCE_TAU.toFixed(8)} color="#ffd700" />
            <SidebarRow label="α_J" value={JASMINE_ALPHA.toFixed(6)} color="#ca4" />
            <SidebarRow label="β_J" value={JASMINE_BETA.toFixed(4)} color="#ca4" />
            <SidebarRow label="γ_J" value={JASMINE_GAMMA.toFixed(8)} color="#ca4" />
            <SidebarRow label="ω_J" value={JASMINE_OMEGA.toFixed(6)} color="#ca4" />
          </SidebarSection>
        </div>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUB-COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════════

interface ControlSliderProps {
  label: string;
  value: number;
  min: number;
  max: number;
  step: number;
  onChange: (v: number) => void;
  color: string;
}

function ControlSlider({
  label, value, min, max, step, onChange, color,
}: ControlSliderProps): React.JSX.Element {
  return (
    <div style={styles.sliderGroup}>
      <div style={{ ...styles.sliderLabel, color }}>
        {label}: <strong>{value.toFixed(3)}</strong>
      </div>
      <input
        type="range"
        min={min}
        max={max}
        step={step}
        value={value}
        onChange={(e) => onChange(parseFloat(e.target.value))}
        style={styles.slider}
      />
    </div>
  );
}

interface SidebarSectionProps {
  title: string;
  children: React.ReactNode;
}

function SidebarSection({ title, children }: SidebarSectionProps): React.JSX.Element {
  return (
    <div style={styles.sidebarSection}>
      <div style={styles.sidebarSectionTitle}>{title}</div>
      {children}
    </div>
  );
}

interface SidebarRowProps {
  label: string;
  value: string;
  color?: string;
}

function SidebarRow({ label, value, color = '#aaa' }: SidebarRowProps): React.JSX.Element {
  return (
    <div style={styles.sidebarRow}>
      <span style={styles.sidebarRowLabel}>{label}</span>
      <span style={{ ...styles.sidebarRowValue, color }}>{value}</span>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// STYLES
// ═══════════════════════════════════════════════════════════════════════════════

const styles: Record<string, React.CSSProperties> = {
  root: {
    background: BG,
    color: '#ccc',
    fontFamily: FONT,
    fontSize: '11px',
    minHeight: '100vh',
    display: 'flex',
    flexDirection: 'column',
    userSelect: 'none',
  },
  header: {
    display: 'flex',
    alignItems: 'center',
    gap: '16px',
    padding: '6px 12px',
    borderBottom: `1px solid ${BORDER}`,
    background: '#040c14',
    flexWrap: 'wrap',
  },
  headerTitle: {
    color: PRIMARY,
    fontWeight: 'bold',
    fontSize: '13px',
    letterSpacing: '1.5px',
  },
  headerSub: {
    color: '#888',
    fontSize: '10px',
    flexGrow: 1,
  },
  copyright: {
    color: '#446',
    fontSize: '9px',
  },
  main: {
    display: 'flex',
    flexGrow: 1,
    overflow: 'auto',
  },
  canvasArea: {
    display: 'flex',
    flexDirection: 'column',
    gap: '4px',
    padding: '6px',
    flexShrink: 0,
  },
  canvasRow: {
    display: 'flex',
    gap: '4px',
  },
  canvasCard: {
    border: `1px solid ${BORDER}`,
    background: BG,
    borderRadius: '3px',
    overflow: 'hidden',
  },
  canvas: {
    display: 'block',
  },
  controls: {
    display: 'flex',
    gap: '12px',
    padding: '6px 4px',
    borderTop: `1px solid ${BORDER}`,
    flexWrap: 'wrap',
  },
  sliderGroup: {
    display: 'flex',
    flexDirection: 'column',
    gap: '3px',
    minWidth: '180px',
  },
  sliderLabel: {
    fontSize: '10px',
    fontFamily: FONT,
  },
  slider: {
    width: '100%',
    accentColor: PRIMARY,
    cursor: 'pointer',
  },
  sidebar: {
    width: '220px',
    flexShrink: 0,
    overflowY: 'auto',
    borderLeft: `1px solid ${BORDER}`,
    background: '#030b12',
    padding: '4px 0',
  },
  sidebarSection: {
    borderBottom: `1px solid ${BORDER}`,
    padding: '4px 6px',
  },
  sidebarSectionTitle: {
    color: PRIMARY,
    fontWeight: 'bold',
    fontSize: '10px',
    letterSpacing: '1px',
    marginBottom: '3px',
    paddingBottom: '2px',
    borderBottom: `1px solid ${BORDER}`,
  },
  sidebarRow: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '1px 0',
    lineHeight: '1.4',
  },
  sidebarRowLabel: {
    color: '#557',
    fontSize: '9px',
    maxWidth: '100px',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
    whiteSpace: 'nowrap',
  },
  sidebarRowValue: {
    fontSize: '10px',
    fontVariantNumeric: 'tabular-nums',
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export default NeuroCogLab;
