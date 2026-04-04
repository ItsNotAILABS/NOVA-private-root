// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: MathPhysicsLab — Deep Physics Visualization Engine
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// Six physics engines running simultaneously:
//   1. Ising 2D Metropolis — spin lattice phase transition
//   2. Lorenz RK4 attractor — deterministic chaos
//   3. Gray-Scott RD — Turing pattern formation
//   4. BTW Sandpile — self-organized criticality
//   5. Brusselator — chemical oscillator
//   6. Landau field — symmetry-breaking free energy
//   7. Information Geometry — Fisher metric, Wasserstein, RG flow
//   8. Lyapunov landscape — 5D stability + Kaplan-Yorke dimension
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useEffect, useRef, useState, useCallback } from 'react';

import {
  IsingState, initIsingState, isingMetropolisStep, isingMagnetization, isingEnergy,
  LorenzState, initLorenzState, lorenzStep,
  RDState, initRDState, rdStep, isTuringUnstable,
  SandpileState, initSandpile, sandpileAddGrain,
  BrusselatorState, initBrusselator, brusselatorStep, brusselatorOscillates,
  LandauParams, landauFromTemperature, landauFreeEnergyFull, landauGradient,
  findEquilibriumPhi, landauSusceptibility,
  EmergenceInputs, computeEmergenceScore, classifyEmergence,
  frequencyCoherence, kuramotoSyncEntropy,
} from '../../math/kuramoto';

import {
  LyapunovState5, initLyapunov, lyapunovTick, computeLyapunovV,
  estimateVdot, hopfieldEnergy, kaplanYorkeDimension, lyapunovExponent,
  OMNIS_THRESHOLD, isOmnisState,
} from '../../math/lyapunov';

import {
  geodesicStep, rgFlowStep, wasserstein1D, jseDivergenceExt,
  naturalGradient, formaCompoundFull, FORMA_GENESIS_FLOOR,
  jasmineCalculate, CoherenceInputs, computeFullCoherence,
  JASMINE_ALPHA, EMERGENCE_TAU,
} from '../../math/scoring-extended';

import {
  clamp, wrapPhase, PHI, PHI_INV, PI, TAU, sigmoid,
  landauFreeEnergy, klDivergence, fisherInfo,
  computeKuramotoOrder,
} from '../../math/core';

// ── Colour palette ────────────────────────────────────────────────────────────
const GOLD   = '#D4AF37';
const CYAN   = '#00D4FF';
const PURPLE = '#6B46C1';
const GREEN  = '#4ade80';
const ORANGE = '#f97316';
const RED    = '#f43f5e';
const BG     = '#030609';
const BG2    = '#050d14';
const BORDER = '#1a3a5c';
const MUTED  = '#4a6a8a';
const WHITE  = '#e2f0ff';

// ═══════════════════════════════════════════════════════════════════════════════
// STATE
// ═══════════════════════════════════════════════════════════════════════════════
interface PhysicsLabState {
  beat:       number;
  ising:      IsingState;
  lorenz:     LorenzState;
  lorenzTrail: [number,number,number][];
  rd:         RDState;
  sandpile:   SandpileState;
  brussel:    BrusselatorState;
  lyapunov:   LyapunovState5;
  // Landau
  temperature:   number;
  landauParams:  LandauParams;
  phiHistory:    number[];
  fHistory:      number[];
  // Information geometry
  infoP:     number[];
  infoQ:     number[];
  fisherMet: number;
  wassDist:  number;
  klDiv:     number;
  jseDiv:    number;
  rgCoupling: number;
  // Composite
  emergenceE: number;
  forma:      number;
  // Kaplan-Yorke
  lyapExpHistory: number[];
  kyDim:      number;
}

function initPhysicsLab(): PhysicsLabState {
  const lp = landauFromTemperature(2.5);
  return {
    beat: 0,
    ising:    initIsingState(32, 32, 2.8),
    lorenz:   initLorenzState(),
    lorenzTrail: [],
    rd:       initRDState(32),
    sandpile: initSandpile(24),
    brussel:  initBrusselator(20, 1.0, 3.0),
    lyapunov: initLyapunov(),
    temperature: 2.8,
    landauParams: lp,
    phiHistory: [],
    fHistory: [],
    infoP: Array.from({ length: 8 }, (_, i) => 0.05 + i * 0.1),
    infoQ: Array.from({ length: 8 }, () => 0.125),
    fisherMet: 0,
    wassDist: 0,
    klDiv: 0,
    jseDiv: 0,
    rgCoupling: 1.0,
    emergenceE: 0,
    forma: FORMA_GENESIS_FLOOR,
    lyapExpHistory: [],
    kyDim: 1.0,
  };
}

function tickPhysics(prev: PhysicsLabState): PhysicsLabState {
  const beat = prev.beat + 1;

  // ── Ising ────────────────────────────────────────────────────────────────
  let ising = prev.ising;
  // Slowly cool the system toward Tc = 2.269
  const targetT = beat < 200 ? 2.8 - beat * 0.003 : 2.269 + Math.sin(beat * 0.01) * 0.3;
  ising = { ...ising, temperature: Math.max(0.5, targetT) };
  for (let s = 0; s < 5; s++) {
    const idx = Math.floor(Math.random() * ising.grid.length);
    ising = isingMetropolisStep(ising, Math.random(), idx);
  }
  const mag = isingMagnetization(ising);

  // ── Lorenz ────────────────────────────────────────────────────────────────
  const lorenz = lorenzStep(prev.lorenz, 0.01);
  const trail: [number,number,number][] = [
    ...prev.lorenzTrail.slice(-1499),
    [lorenz.x, lorenz.y, lorenz.z],
  ];

  // ── Gray-Scott RD ────────────────────────────────────────────────────────
  const rd = rdStep(prev.rd, 1.0);

  // ── Sandpile ──────────────────────────────────────────────────────────────
  const center = Math.floor(Math.sqrt(prev.sandpile.grid.length) / 2);
  const spIdx = center * Math.floor(Math.sqrt(prev.sandpile.grid.length)) + center;
  const sandpile = sandpileAddGrain(prev.sandpile, spIdx);

  // ── Brusselator ───────────────────────────────────────────────────────────
  const brussel = brusselatorStep(prev.brussel, 0.02);

  // ── Landau ────────────────────────────────────────────────────────────────
  const temperature = Math.max(0.5, prev.temperature + Math.sin(beat * 0.02) * 0.05);
  const landauParams = landauFromTemperature(temperature);
  const phiStar = findEquilibriumPhi(landauParams);
  const fStar = landauFreeEnergyFull(phiStar, landauParams);
  const phiHistory = [...prev.phiHistory.slice(-199), phiStar];
  const fHistory = [...prev.fHistory.slice(-199), fStar];

  // ── Lyapunov ─────────────────────────────────────────────────────────────
  const { r: kuramR } = computeKuramotoOrder(
    Array.from({ length: 12 }, (_, i) => (beat * HIERARCHY_FREQS[i]) % TAU)
  );
  const lyapunov = lyapunovTick(
    prev.lyapunov, kuramR, Math.abs(mag), ising.temperature / 3,
    clamp(1 - Math.abs(fStar), 0, 1), clamp(Math.abs(mag) + kuramR * 0.3, 0, 1)
  );
  const lyapExpHistory = [...prev.lyapExpHistory.slice(-49), lyapunov.V];
  const lyapExp = lyapunovExponent(lyapExpHistory, 20);
  const kyDim = kaplanYorkeDimension([lyapExp, lyapExp * 0.6, -lyapExp]);

  // ── Information Geometry ────────────────────────────────────────────────
  // Slowly evolve P toward Q via gradient descent
  const pSum = prev.infoP.reduce((a, b) => a + b, 0.001);
  const infoP = prev.infoP.map((p, i) => {
    const grad = p > 0 ? Math.log(p / Math.max(prev.infoQ[i], 0.001)) : 0;
    return Math.max(0.001, p - 0.001 * grad);
  });
  const pSum2 = infoP.reduce((a, b) => a + b, 0.001);
  const pNorm = infoP.map(p => p / pSum2);
  const qNorm = prev.infoQ.map((q, i) => {
    const distort = Math.sin(beat * 0.05 + i) * 0.02;
    return Math.max(0.001, q + distort);
  });
  const qSum = qNorm.reduce((a, b) => a + b, 0.001);
  const qNormalized = qNorm.map(q => q / qSum);

  const fisherMet = pNorm.reduce((s, p) => s + fisherInfo(p), 0) / pNorm.length;
  const wassDist = wasserstein1D(pNorm, qNormalized);
  const klDiv = klDivergence(pNorm, qNormalized);
  const jseDiv = jseDivergenceExt(pNorm, qNormalized);
  const rgCoupling = clamp(prev.rgCoupling * (1 + (kuramR - 0.5) * 0.01), 0.1, 5.0);

  // ── Composite Emergence ─────────────────────────────────────────────────
  const lorenzNorm = Math.sqrt(lorenz.x ** 2 + lorenz.y ** 2 + lorenz.z ** 2);
  const emergInputs: EmergenceInputs = {
    r: kuramR, syncEntropy: kuramotoSyncEntropy(kuramR),
    magnetization: Math.abs(mag), phiStar: Math.abs(phiStar),
    lorenzNorm, lyapunovV: lyapunov.V,
  };
  const emergenceE = computeEmergenceScore(emergInputs);
  const forma = formaCompoundFull(prev.forma, kuramR, beat, 0.20, 2);

  return {
    beat, ising, lorenz, lorenzTrail: trail, rd, sandpile, brussel,
    lyapunov, temperature, landauParams, phiHistory, fHistory,
    infoP: pNorm, infoQ: qNormalized,
    fisherMet, wassDist, klDiv, jseDiv, rgCoupling,
    emergenceE, forma, lyapExpHistory, kyDim,
  };
}

// Hierarchy freqs for Kuramoto order
const HIERARCHY_FREQS = Array.from({ length: 12 }, (_, k) => 0.000384 * Math.pow(PHI, k));

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS DRAWERS
// ═══════════════════════════════════════════════════════════════════════════════

function drawIsingFull(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const gW = s.ising.gridW, gH = s.ising.gridH;
  const cW = (W - 2) / gW, cH = (H - 24) / gH;
  s.ising.grid.forEach((spin, idx) => {
    const col = idx % gW, row = Math.floor(idx / gW);
    ctx.fillStyle = spin > 0 ? CYAN : '#071a2a';
    ctx.fillRect(1 + col * cW, 1 + row * cH, cW - 0.5, cH - 0.5);
  });
  const mag = isingMagnetization(s.ising);
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`T=${s.ising.temperature.toFixed(3)}  m=${mag.toFixed(4)}  E=${isingEnergy(s.ising).toFixed(1)}`, 4, H - 6);
  // Phase boundary line at Tc = 2.269
  if (Math.abs(s.ising.temperature - 2.269) < 0.15) {
    ctx.strokeStyle = GOLD; ctx.lineWidth = 1.5;
    ctx.globalAlpha = 0.5;
    ctx.beginPath(); ctx.moveTo(0, 4); ctx.lineTo(W, 4); ctx.stroke();
    ctx.globalAlpha = 1;
    ctx.fillStyle = GOLD; ctx.font = 'bold 9px monospace';
    ctx.textAlign = 'center'; ctx.fillText('T≈Tc', W/2, 13);
  }
}

function drawLorenzFull(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const trail = s.lorenzTrail;
  if (trail.length < 2) return;
  const xs = trail.map(p => p[0]), zs = trail.map(p => p[2]);
  const minX = Math.min(...xs), maxX = Math.max(...xs);
  const minZ = Math.min(...zs), maxZ = Math.max(...zs);
  const rX = maxX - minX || 1, rZ = maxZ - minZ || 1;
  const pad = 16;
  for (let i = 1; i < trail.length; i++) {
    const t = i / trail.length;
    const r = Math.round(t * 212), g = Math.round(t * 150), b = Math.round(255 - t * 60);
    ctx.strokeStyle = `rgba(${r},${g},${b},${0.2 + t * 0.8})`;
    ctx.lineWidth = t > 0.97 ? 2 : 0.8;
    ctx.beginPath();
    ctx.moveTo(pad + (trail[i-1][0]-minX)/(rX)*(W-2*pad), H-pad-(trail[i-1][2]-minZ)/(rZ)*(H-2*pad));
    ctx.lineTo(pad + (trail[i][0]-minX)/(rX)*(W-2*pad), H-pad-(trail[i][2]-minZ)/(rZ)*(H-2*pad));
    ctx.stroke();
  }
  const last = trail[trail.length-1];
  ctx.fillStyle = GOLD; ctx.beginPath();
  ctx.arc(pad+(last[0]-minX)/rX*(W-2*pad), H-pad-(last[2]-minZ)/rZ*(H-2*pad), 3, 0, TAU);
  ctx.fill();
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`x=${s.lorenz.x.toFixed(2)} y=${s.lorenz.y.toFixed(2)} z=${s.lorenz.z.toFixed(2)}`, 4, 12);
}

function drawRDFull(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const gS = s.rd.gridSize;
  const cW = W / gS, cH = H / gS;
  const u = s.rd.uField, v = s.rd.vField;
  if (!u || !v) return;
  for (let i = 0; i < gS * gS; i++) {
    const col = i % gS, row = Math.floor(i / gS);
    const uv = clamp(u[i], 0, 1), vv = clamp(v[i], 0, 1);
    const r = Math.round(uv * 30), g = Math.round(uv * 200 + vv * 55), b = Math.round(vv * 255);
    ctx.fillStyle = `rgb(${r},${g},${b})`;
    ctx.fillRect(col*cW, row*cH, cW, cH);
  }
  const turing = isTuringUnstable(s.rd);
  ctx.fillStyle = turing ? GREEN : MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Turing=${turing} f=${s.rd.f.toFixed(4)} k=${s.rd.k.toFixed(4)}`, 3, H-4);
}

function drawSandpile(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const gS = Math.round(Math.sqrt(s.sandpile.grid.length));
  const cW = W / gS, cH = H / gS;
  s.sandpile.grid.forEach((h, idx) => {
    const col = idx % gS, row = Math.floor(idx / gS);
    const intensity = Math.min(h / 4, 1);
    const r = Math.round(intensity * 212), g = Math.round(intensity * 175), b = 0;
    ctx.fillStyle = h >= 4 ? RED : `rgb(${r},${g},${b})`;
    ctx.fillRect(col*cW, row*cH, cW-0.5, cH-0.5);
  });
  const totalGrains = s.sandpile.grid.reduce((a, b) => a + b, 0);
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`BTW grains=${totalGrains} topplings=${s.sandpile.totalTopplings}`, 3, H-4);
}

function drawBrussPhase(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const gS = s.brussel.gridSize;
  const cW = W / gS, cH = H / gS;
  const X = s.brussel.X, Y = s.brussel.Y;
  if (!X || !Y) return;
  for (let i = 0; i < gS * gS; i++) {
    const col = i % gS, row = Math.floor(i / gS);
    const x = clamp(X[i]/3, 0, 1), y = clamp(Y[i]/3, 0, 1);
    const r = Math.round(x * 255), g = 60, b = Math.round(y * 255);
    ctx.fillStyle = `rgb(${r},${g},${b})`;
    ctx.fillRect(col*cW, row*cH, cW, cH);
  }
  const osc = brusselatorOscillates(s.brussel);
  ctx.fillStyle = osc ? GREEN : MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Brusselator osc=${osc} a=${s.brussel.a.toFixed(2)} b=${s.brussel.b.toFixed(2)}`, 3, H-4);
}

function drawLandauCurve(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const pad = 20;
  const iW = W - 2*pad, iH = H - 2*pad;
  // Draw F(φ) curve
  const phiRange = 2.5;
  const steps = 200;
  ctx.strokeStyle = CYAN; ctx.lineWidth = 1.5; ctx.beginPath();
  let fMin = Infinity, fMax = -Infinity;
  const fVals = Array.from({length: steps}, (_, i) => {
    const phi = -phiRange + i * 2 * phiRange / steps;
    const f = landauFreeEnergyFull(phi, s.landauParams);
    if (f < fMin) fMin = f; if (f > fMax) fMax = f;
    return f;
  });
  const fRange = fMax - fMin || 1;
  fVals.forEach((f, i) => {
    const px = pad + i / steps * iW;
    const py = pad + iH - (f - fMin) / fRange * iH;
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
  // Mark φ*
  const phiStar = findEquilibriumPhi(s.landauParams);
  const pxStar = pad + ((phiStar + phiRange) / (2*phiRange)) * iW;
  const fStarV = landauFreeEnergyFull(phiStar, s.landauParams);
  const pyStar = pad + iH - (fStarV - fMin) / fRange * iH;
  ctx.fillStyle = GOLD; ctx.beginPath(); ctx.arc(pxStar, pyStar, 4, 0, TAU); ctx.fill();
  // Zero line
  const pyZero = pad + iH - (0 - fMin) / fRange * iH;
  ctx.strokeStyle = BORDER; ctx.lineWidth = 0.5;
  ctx.beginPath(); ctx.moveTo(pad, pyZero); ctx.lineTo(W-pad, pyZero); ctx.stroke();
  ctx.fillStyle = WHITE; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`T=${s.temperature.toFixed(3)}  φ*=${phiStar.toFixed(4)}  F=${fStarV.toFixed(4)}`, 4, 12);
  const sus = landauSusceptibility(phiStar, s.landauParams);
  ctx.fillText(`χ=${sus.toFixed(4)} a=${s.landauParams.a.toFixed(3)}`, 4, 24);
}

function drawInfoGeo(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const N = s.infoP.length;
  const barW = (W - 16) / N;
  // Draw P (cyan) and Q (orange) distributions
  s.infoP.forEach((p, i) => {
    const bh = p * (H - 40);
    ctx.fillStyle = CYAN; ctx.globalAlpha = 0.7;
    ctx.fillRect(8 + i * barW, H - 20 - bh, barW * 0.45, bh);
    const qh = (s.infoQ[i] ?? 0.125) * (H - 40);
    ctx.fillStyle = ORANGE;
    ctx.fillRect(8 + i * barW + barW * 0.5, H - 20 - qh, barW * 0.45, qh);
    ctx.globalAlpha = 1;
  });
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`W₁=${s.wassDist.toFixed(4)} KL=${s.klDiv.toFixed(4)} JSE=${s.jseDiv.toFixed(4)} g=${s.rgCoupling.toFixed(3)}`, 4, H-4);
  ctx.fillText(`Fisher g̃=${s.fisherMet.toFixed(4)}`, 4, 12);
}

function drawLyapunovLandscape(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const hist = s.lyapunov.Vhistory;
  if (hist.length < 2) return;
  const vMin = Math.min(...hist), vMax = Math.max(...hist, 0.01);
  const pad = 16;
  const iW = W - 2*pad, iH = H - 2*pad - 16;
  // V(t) time series
  ctx.strokeStyle = ORANGE; ctx.lineWidth = 1.5; ctx.beginPath();
  hist.forEach((v, i) => {
    const px = pad + i / (hist.length - 1) * iW;
    const py = pad + iH - (v - vMin) / (vMax - vMin) * iH;
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
  // OMNIS line
  if (isOmnisState(s.lyapunov.coherenceC)) {
    ctx.strokeStyle = GOLD; ctx.lineWidth = 1; ctx.globalAlpha = 0.5;
    const pyOmnis = pad + iH - (0.02 - vMin) / (vMax - vMin) * iH;
    ctx.beginPath(); ctx.moveTo(pad, pyOmnis); ctx.lineTo(W-pad, pyOmnis); ctx.stroke();
    ctx.globalAlpha = 1;
  }
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`V=${s.lyapunov.V.toFixed(4)} dV/dt=${s.lyapunov.Vdot.toFixed(4)} D_KY=${s.kyDim.toFixed(3)}`, 4, H-4);
  ctx.fillText(`stable=${s.lyapunov.isAsymptotic} beats=${s.lyapunov.stableBeats}`, 4, H-14);
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROPS
// ═══════════════════════════════════════════════════════════════════════════════
interface MathPhysicsLabProps {
  organism?: { r?: number; beat?: number; [key: string]: unknown };
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════
export function MathPhysicsLab({ organism: _organism }: MathPhysicsLabProps) {
  const isingRef    = useRef<HTMLCanvasElement>(null);
  const lorenzRef   = useRef<HTMLCanvasElement>(null);
  const rdRef       = useRef<HTMLCanvasElement>(null);
  const sandpileRef = useRef<HTMLCanvasElement>(null);
  const brusselRef  = useRef<HTMLCanvasElement>(null);
  const landauRef   = useRef<HTMLCanvasElement>(null);
  const infoGeoRef  = useRef<HTMLCanvasElement>(null);
  const lyapRef     = useRef<HTMLCanvasElement>(null);

  const simRef  = useRef<PhysicsLabState>(initPhysicsLab());
  const tickCnt = useRef(0);
  const frameRef = useRef<number>(0);
  const [ui, setUi] = useState<PhysicsLabState>(simRef.current);

  const animate = useCallback(() => {
    simRef.current = tickPhysics(simRef.current);
    tickCnt.current++;
    if (isingRef.current)    drawIsingFull(isingRef.current,    simRef.current);
    if (lorenzRef.current)   drawLorenzFull(lorenzRef.current,  simRef.current);
    if (rdRef.current)       drawRDFull(rdRef.current,          simRef.current);
    if (sandpileRef.current) drawSandpile(sandpileRef.current,  simRef.current);
    if (brusselRef.current)  drawBrussPhase(brusselRef.current, simRef.current);
    if (landauRef.current)   drawLandauCurve(landauRef.current, simRef.current);
    if (infoGeoRef.current)  drawInfoGeo(infoGeoRef.current,    simRef.current);
    if (lyapRef.current)     drawLyapunovLandscape(lyapRef.current, simRef.current);
    if (tickCnt.current % 8 === 0) setUi({ ...simRef.current });
    frameRef.current = requestAnimationFrame(animate);
  }, []);

  useEffect(() => {
    frameRef.current = requestAnimationFrame(animate);
    return () => cancelAnimationFrame(frameRef.current);
  }, [animate]);

  useEffect(() => {
    const refs = [isingRef, lorenzRef, rdRef, sandpileRef, brusselRef, landauRef, infoGeoRef, lyapRef];
    const obs = refs.map(ref => {
      const o = new ResizeObserver(entries => {
        for (const e of entries) {
          const el = e.target as HTMLCanvasElement;
          el.width  = e.contentRect.width  * (window.devicePixelRatio || 1);
          el.height = e.contentRect.height * (window.devicePixelRatio || 1);
        }
      });
      if (ref.current) o.observe(ref.current);
      return o;
    });
    return () => obs.forEach(o => o.disconnect());
  }, []);

  const emergLabel = classifyEmergence(ui.emergenceE);
  const eColor = emergLabel === 'radical' ? GOLD : emergLabel === 'strong' ? GREEN : MUTED;

  const S = {
    root: { width:'100%', height:'100%', background:BG, display:'grid', gridTemplateRows:'auto 1fr auto', fontFamily:'monospace', overflow:'hidden' } as React.CSSProperties,
    header: { background:BG2, borderBottom:`1px solid ${BORDER}`, padding:'8px 16px', display:'flex', alignItems:'center', gap:16, flexWrap:'wrap' as const },
    title: { fontSize:14, fontWeight:'bold', color:GOLD, letterSpacing:'0.12em' },
    stat: { display:'flex', flexDirection:'column' as const, alignItems:'center', minWidth:60 },
    statLabel: { fontSize:9, color:MUTED, textTransform:'uppercase' as const },
    statVal: (c:string) => ({ fontSize:12, color:c, fontWeight:'bold' }),
    grid: { display:'grid', gridTemplateColumns:'1fr 1fr 1fr 1fr', gridTemplateRows:'1fr 1fr', gap:2, padding:2, overflow:'hidden' },
    cell: { position:'relative' as const, background:BG, overflow:'hidden' },
    canvas: { width:'100%', height:'100%', display:'block' },
    label: { position:'absolute' as const, top:3, left:5, fontSize:8, color:MUTED, pointerEvents:'none' as const, zIndex:1 },
    eqRow: { background:BG2, borderTop:`1px solid ${BORDER}`, display:'flex', gap:16, padding:'6px 12px', overflowX:'auto' as const, fontSize:9, color:WHITE, fontFamily:'monospace' },
    eqSec: (c:string) => ({ borderLeft:`2px solid ${c}`, paddingLeft:8, minWidth:200 }),
    eqTitle: (c:string) => ({ color:c, fontWeight:'bold', marginBottom:2 }),
  };

  return (
    <div style={S.root}>
      <header style={S.header}>
        <div style={S.title}>⬡ NOVA · MATH PHYSICS LAB</div>
        {[
          { label:'Beat',     val:String(ui.beat),                   color:CYAN   },
          { label:'Ising T',  val:ui.ising.temperature.toFixed(3),   color:ui.ising.temperature < 2.4 ? GOLD : MUTED },
          { label:'Ising m',  val:isingMagnetization(ui.ising).toFixed(4), color:GREEN },
          { label:'Emergence',val:ui.emergenceE.toFixed(4),          color:eColor },
          { label:'FORMA',    val:ui.forma.toFixed(0),               color:GOLD   },
          { label:'Lyap V',   val:ui.lyapunov.V.toFixed(4),          color:ORANGE },
          { label:'D_KY',     val:ui.kyDim.toFixed(3),               color:PURPLE },
          { label:'φ*',       val:findEquilibriumPhi(ui.landauParams).toFixed(4), color:CYAN },
          { label:'Wass W₁',  val:ui.wassDist.toFixed(4),            color:ORANGE },
          { label:'RG g',     val:ui.rgCoupling.toFixed(3),          color:GREEN  },
        ].map(({ label, val, color }) => (
          <div key={label} style={S.stat}>
            <span style={S.statLabel}>{label}</span>
            <span style={S.statVal(color)}>{val}</span>
          </div>
        ))}
      </header>

      <div style={S.grid}>
        {[
          { ref: isingRef,    label: 'ISING 2D METROPOLIS'          },
          { ref: lorenzRef,   label: 'LORENZ ATTRACTOR (xz)'        },
          { ref: rdRef,       label: 'GRAY-SCOTT RD'                },
          { ref: sandpileRef, label: 'BTW SANDPILE (SOC)'           },
          { ref: brusselRef,  label: 'BRUSSELATOR OSCILLATOR'       },
          { ref: landauRef,   label: 'LANDAU F(φ) SYMMETRY BREAK'   },
          { ref: infoGeoRef,  label: 'INFO GEOMETRY P vs Q'         },
          { ref: lyapRef,     label: 'LYAPUNOV V(t) LANDSCAPE'      },
        ].map(({ ref, label }) => (
          <div key={label} style={S.cell}>
            <span style={S.label}>{label}</span>
            <canvas ref={ref as React.RefObject<HTMLCanvasElement>} style={S.canvas} />
          </div>
        ))}
      </div>

      <div style={S.eqRow}>
        <div style={S.eqSec(CYAN)}>
          <div style={S.eqTitle(CYAN)}>ISING 2D METROPOLIS</div>
          <div>H = −J·Σ⟨ij⟩ sᵢsⱼ   ΔE = 2J·sᵢ·Σneigh</div>
          <div>P_flip = e^{'{'}−ΔE/T{'}'}   T_c = 2.269 J/k_B</div>
          <div style={{color:GREEN}}>m={isingMagnetization(ui.ising).toFixed(4)} T={ui.ising.temperature.toFixed(3)}</div>
        </div>
        <div style={S.eqSec(ORANGE)}>
          <div style={S.eqTitle(ORANGE)}>LORENZ RK4 ATTRACTOR</div>
          <div>dX/dt=σ(Y−X)   σ=10</div>
          <div>dY/dt=X(ρ−Z)−Y   ρ=28</div>
          <div>dZ/dt=XY−βZ   β=8/3</div>
          <div style={{color:GREEN}}>x={ui.lorenz.x.toFixed(3)} y={ui.lorenz.y.toFixed(3)} z={ui.lorenz.z.toFixed(3)}</div>
        </div>
        <div style={S.eqSec(PURPLE)}>
          <div style={S.eqTitle(PURPLE)}>GRAY-SCOTT RD</div>
          <div>∂u/∂t = D_u∇²u − uv² + f(1−u)</div>
          <div>∂v/∂t = D_v∇²v + uv² − (f+k)v</div>
          <div style={{color:GREEN}}>Turing={String(isTuringUnstable(ui.rd))} f={ui.rd.f.toFixed(4)} k={ui.rd.k.toFixed(4)}</div>
        </div>
        <div style={S.eqSec(GOLD)}>
          <div style={S.eqTitle(GOLD)}>LANDAU FREE ENERGY</div>
          <div>F(φ) = a·φ² + b·φ⁴</div>
          <div>a = (T−Tc)/Tc   b = 1.0</div>
          <div>φ* = √(−a/2b) if a{'<'}0</div>
          <div style={{color:GOLD}}>φ*={findEquilibriumPhi(ui.landauParams).toFixed(4)} T={ui.temperature.toFixed(3)}</div>
        </div>
        <div style={S.eqSec(GREEN)}>
          <div style={S.eqTitle(GREEN)}>INFORMATION GEOMETRY</div>
          <div>W₁(P,Q) = ∫|F_P(x)−F_Q(x)|dx</div>
          <div>g̃ᵢⱼ = 1/(p(1−p))   [Fisher metric]</div>
          <div>KL(P||Q) = Σpᵢ·ln(pᵢ/qᵢ)</div>
          <div style={{color:GREEN}}>W₁={ui.wassDist.toFixed(4)} KL={ui.klDiv.toFixed(4)} g={ui.rgCoupling.toFixed(3)}</div>
        </div>
        <div style={S.eqSec(RED)}>
          <div style={S.eqTitle(RED)}>LYAPUNOV + KAPLAN-YORKE</div>
          <div>V = Σᵢ wᵢ(xᵢ−x̄ᵢ)²   dV/dt{'<'}0 → stable</div>
          <div>D_KY = k + Σᵢ₌₁ᵏ λᵢ/|λₖ₊₁|</div>
          <div style={{color:ORANGE}}>V={ui.lyapunov.V.toFixed(4)} D_KY={ui.kyDim.toFixed(3)} stable={String(ui.lyapunov.isAsymptotic)}</div>
        </div>
      </div>
    </div>
  );
}

export default MathPhysicsLab;
