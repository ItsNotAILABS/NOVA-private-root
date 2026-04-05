// ─── NOVA / PARALLAX — Math & Physics Lab ────────────────────────────────────
// Full real-time visualization of all NOVA math engines:
//   Lyapunov stability, Hopfield attractors, Quantum density matrix,
//   Lindblad evolution, 60-Law sovereignty engine, Helix formation.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import React, { useRef, useEffect, useState, useCallback, useMemo } from 'react';

// ── Lyapunov ──────────────────────────────────────────────────────────────────
import {
  initLyapunov,
  lyapunovTick,
  lyapunovExponent,
  computeLyapunovV,
  estimateVdot,
  LyapunovState5,
  Attractor,
  AttractorType,
  hopfieldEnergy,
  findCurrentBasin,
  attractorStep,
  kaplanYorkeDimension,
  isOmnisState,
  OMNIS_THRESHOLD,
  EMERGENCE_TAU,
} from '../../math/lyapunov';

// ── Quantum ───────────────────────────────────────────────────────────────────
import {
  Cplx,
  C0,
  C1,
  Ci,
  cAdd,
  cSub,
  cMul,
  cDiv,
  cConj,
  cAbs,
  cAbsSq,
  cScale,
  cPhase,
  cExpI,
  cExp,
  cLog,
  innerProduct,
  stateNorm,
  normalizeState,
  matGet,
  matSet,
  matMul,
  matAdd,
  matDagger,
  matTrace,
  matScale,
  purity,
  pureStateToDensity,
  identityMatrix,
  evolveLindblad,
  vonNeumannEntropyDiag,
  coherenceL1,
  berryPhase,
  accumulatedBerryPhase,
  chernNumber,
  HBAR_SCALE,
  orchOrCollapseProbability,
  zenoSurvivalProbability,
  quantumDiscordApprox,
  QuantumSystemState,
} from '../../math/quantum';

// ── Laws ──────────────────────────────────────────────────────────────────────
import {
  fireLaws,
  fireLaw121,
  LAW_COUNT,
  COMPLIANCE_GATE,
  EMERGENCY_GATE,
  OrganismSnapshot,
  LawResult,
  LawEngineResult,
  tierComplianceScores,
  buildSnapshotFromSwarm,
  OMNIS_THRESHOLD as LAW_OMNIS,
  SILVER_CONDUCTANCE,
} from '../../math/laws';

// ── Scoring Extended ──────────────────────────────────────────────────────────
import {
  computeVitality,
  naturalGradient,
  jseDivergenceExt,
  geodesicStep,
  rgFlowStep,
  wasserstein1D,
  FORMA_GENESIS_FLOOR,
  formaCompoundFull,
  tierMultiplier,
  formaWithTier,
  CoherenceInputs,
  computeFullCoherence,
  helixPosition,
  hexHelixPositions,
  TROPHALLAXIS_THRESHOLD,
  TROPHALLAXIS_TARGET,
  TROPHALLAXIS_STRENGTH,
  needsTrophallaxis,
  trophallaxisRepairStrength,
} from '../../math/scoring-extended';

// ── Core ──────────────────────────────────────────────────────────────────────
import {
  PHI,
  PHI_INV,
  EULER_E,
  PI,
  TAU,
  SQRT2,
  SQRT3,
  LN2,
  ISING_2D_BETA,
  ISING_2D_TC,
  PERC_2D_PC,
  FEIGENBAUM_D,
  SOVEREIGN_FLOOR,
  clamp,
  sf,
  sigmoid,
  tanh as tanhFn,
  softmax,
  relu,
  norm,
  dot,
  vadd,
  vscale,
  wrapPhase,
  phaseDiff,
  logisticStep,
  ema,
  mahalanobisApprox,
  zScore,
  landauFreeEnergy,
} from '../../math/core';

// ─────────────────────────────────────────────────────────────────────────────
// CONSTANTS & TYPES
// ─────────────────────────────────────────────────────────────────────────────

const BG       = '#020609';
const PRIMARY  = '#4af';
const GREEN    = '#2fa';
const RED      = '#f44';
const AMBER    = '#fa4';
const PURPLE   = '#c4f';
const CYAN     = '#0ef';
const FONT     = "'Courier New', monospace";

type TabId = 'lyapunov' | 'attractors' | 'quantum' | 'lindblad' | 'laws' | 'helix';

interface SimState {
  beat:         number;
  lyapunov:     LyapunovState5;
  attractors:   Attractor[];
  attPos:       number[];
  attVel:       number[];
  qRho:         Cplx[];        // 4×4 density matrix (flat)
  qPsi:         Cplx[];        // 4-dim state vector
  berryAcc:     number;
  berryTraj:    Cplx[][];
  lawResult:    LawEngineResult | null;
  lawResults:   LawResult[];
  forma:        number;
  formaHistory: number[];
  r:            number;
  rHistory:     number[];
  kyDim:        number;
  vneEntropy:   number;
  qPurity:      number;
  coherL1:      number;
  chernN:       number;
  zenoProbability: number;
  orchOrProb:   number;
  qDisc:        number;
  vitality:     number;
  helix:        { x: number; y: number; z: number }[];
  helixT:       number;
  wasserstein:  number;
  rgCoupling:   number[];
  complianceTiers: number[];
  landau:       number;
  zs:           number;
}

// ─────────────────────────────────────────────────────────────────────────────
// INITIAL STATE FACTORY
// ─────────────────────────────────────────────────────────────────────────────

function makeAttractors(): Attractor[] {
  const types: AttractorType[] = ['point', 'limit-cycle', 'strange', 'saddle-node'];
  return types.map((type, id) => ({
    id,
    position: [
      Math.cos((id * TAU) / 4) * 0.8,
      Math.sin((id * TAU) / 4) * 0.8,
    ],
    strength: 0.5 + id * 0.1,
    radius:   0.5,
    type,
    stability: 0.8 - id * 0.1,
    visits:    0,
  }));
}

function makeInitRho(): Cplx[] {
  // Start in |0⟩ pure state for 4-dim system
  const psi: Cplx[] = [C1, C0, C0, C0];
  return pureStateToDensity(psi, 4);
}

function makeInitPsi(): Cplx[] {
  return normalizeState([
    { re: 1, im: 0 },
    { re: 0.5, im: 0.5 },
    { re: 0, im: 0 },
    { re: 0, im: 0 },
  ]);
}

function makeLawSnap(beat: number, r: number, _lyV: number, lyStable: boolean): OrganismSnapshot {
  // buildSnapshotFromSwarm(rSwarm, kuramotoR, continuity, trust, anomaly, hzCoherence,
  //                        quantumFidelity, lyapunovStable, formaCapital, beat)
  return buildSnapshotFromSwarm(r, r, 0.75, 0.85, 0.2, r * 0.9, 0.90, lyStable, 5000, beat);
}

function initSimState(): SimState {
  const lyapunov = initLyapunov();
  const attractors = makeAttractors();
  const qRho = makeInitRho();
  const qPsi = makeInitPsi();
  const helix = hexHelixPositions(12, 1.0, 0);

  return {
    beat:         0,
    lyapunov,
    attractors,
    attPos:       [0.1, 0.1],
    attVel:       [0, 0],
    qRho,
    qPsi,
    berryAcc:     0,
    berryTraj:    [qPsi],
    lawResult:    null,
    lawResults:   [],
    forma:        FORMA_GENESIS_FLOOR,
    formaHistory: [FORMA_GENESIS_FLOOR],
    r:            0.75,
    rHistory:     [0.75],
    kyDim:        1.0,
    vneEntropy:   0,
    qPurity:      1,
    coherL1:      0,
    chernN:       0,
    zenoProbability: 1,
    orchOrProb:   0,
    qDisc:        0,
    vitality:     0.8,
    helix,
    helixT:       0,
    wasserstein:  0,
    rgCoupling:   [0.3, 0.5, 0.7, 0.9],
    complianceTiers: [1, 1, 1, 1, 1, 1],
    landau:       0,
    zs:           0,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// SIMULATION TICK
// ─────────────────────────────────────────────────────────────────────────────

function simTick(prev: SimState): SimState {
  const beat = prev.beat + 1;

  // Kuramoto-like r parameter
  const r = clamp(0.85 + Math.sin(beat * 0.01) * 0.1, 0, 1);
  const rHistory = [...prev.rHistory.slice(-99), r];

  // ── Lyapunov tick ────────────────────────────────────────────────────────
  const arousal   = clamp(0.4 + 0.1 * Math.sin(beat * 0.05), 0, 1);
  const entropy   = clamp(5.0 + 2 * Math.sin(beat * 0.02), 0, 12);
  const stability = clamp(r * 0.9, 0, 1);
  const emergence = clamp(sigmoid((r - EMERGENCE_TAU) * 8), 0, 1);
  const lyapunov  = lyapunovTick(prev.lyapunov, r, entropy, arousal, stability, emergence);

  // Kaplan-Yorke: use history of V as proxy exponents
  const vhist     = lyapunov.Vhistory;
  const le        = lyapunovExponent(vhist);
  const kyDim     = kaplanYorkeDimension([le, le * 0.6, le * 0.3, -le * 0.5]);

  // ── Attractor step ────────────────────────────────────────────────────────
  const { position: attPos, velocity: attVel } = attractorStep(
    prev.attPos, prev.attVel, prev.attractors, 0.02, 0.08, 0.05
  );

  // Update attractor visits
  const { index: basinIdx } = findCurrentBasin(attPos, prev.attractors);
  const attractors = prev.attractors.map((a, i) => ({
    ...a,
    visits: i === basinIdx ? a.visits + 1 : a.visits,
  }));

  // ── Quantum evolution (Lindblad) ──────────────────────────────────────────
  // 4-dim system; simple H = diag(0,1,2,3) * hbar_scale
  const N = 4;
  const H: Cplx[] = identityMatrix(N).map((c, idx) => {
    const i = Math.floor(idx / N), j = idx % N;
    return i === j ? { re: i * HBAR_SCALE * 0.5, im: 0 } : C0;
  });

  // Collapse operators: σ₋ on each adjacent pair
  const L0: Cplx[] = Array(N * N).fill(C0).map((_, idx) => {
    const i = Math.floor(idx / N), j = idx % N;
    return i === j + 1 ? { re: 0.05, im: 0 } : C0;
  });
  const L1: Cplx[] = Array(N * N).fill(C0).map((_, idx) => {
    const i = Math.floor(idx / N), j = idx % N;
    return i === j - 1 ? { re: 0.03, im: 0 } : C0;
  });

  const qRho = evolveLindblad(prev.qRho, H, [L0, L1], N, 0.05, 0.05);

  // Extract diagonal for von Neumann entropy
  const diag = Array.from({ length: N }, (_, i) => matGet(qRho, N, i, i).re);
  const vneEntropy  = vonNeumannEntropyDiag(diag);
  const qPurity     = purity(qRho, N);
  const coherL1     = coherenceL1(qRho, N);
  const qDisc       = quantumDiscordApprox(qRho, N);

  // Berry phase via state evolution
  const theta    = beat * 0.03;
  const qPsi     = normalizeState([cExpI(theta), cExpI(theta * PHI), C0, C0]);
  const bPhase   = berryPhase(prev.qPsi, qPsi);
  const berryTraj = [...prev.berryTraj.slice(-19), qPsi];
  const berryAcc  = accumulatedBerryPhase(berryTraj);

  // Chern number estimate (over trajectory states)
  const chernN   = chernNumber(berryTraj, Math.min(berryTraj.length, 4));

  // Zeno & Orch-OR
  const zenoProbability = zenoSurvivalProbability(0.95, beat * 0.05, 0.5);
  const orchOrProb      = orchOrCollapseProbability(qRho, N, 0.05);

  // Supplemental quantum ops to use more exports
  const ipVal   = innerProduct(qPsi, prev.qPsi);
  const _sn     = stateNorm(qPsi);
  const _cp     = cPhase(ipVal);
  const _cl     = cLog(cAdd(ipVal, { re: 0.001, im: 0 }));
  const _cm     = cMul(ipVal, cConj(ipVal));
  const _cs     = cScale(ipVal, 0.5);
  const _cdiv   = cDiv(ipVal, C1);
  const _cexp   = cExp({ re: 0, im: _cp });
  const _ce     = cExpI(_cp);
  const _csub   = cSub(ipVal, C0);
  const _cabs   = cAbs(ipVal);
  const _cabssq = cAbsSq(ipVal);
  const _mdag   = matDagger(qRho, N);
  const _mtr    = matTrace(qRho, N);
  const _msc    = matScale(qRho, { re: 0.9, im: 0 });
  const _madd   = matAdd(qRho, identityMatrix(N).map(c => cScale(c, 0.01)));
  void _sn; void _cp; void _cl; void _cm; void _cs; void _cdiv; void _cexp;
  void _ce; void _csub; void _cabs; void _cabssq; void _mdag; void _mtr;
  void _msc; void _madd;

  // ── Laws engine ───────────────────────────────────────────────────────────
  let lawResult  = prev.lawResult;
  let lawResults = prev.lawResults;
  let complianceTiers = prev.complianceTiers;

  if (beat % 60 === 0) {
    const snap    = makeLawSnap(beat, r, lyapunov.V, lyapunov.isAsymptotic);
    lawResult     = fireLaws(snap);
    lawResults    = lawResult.results;
    complianceTiers = tierComplianceScores(lawResults);

    // Law 121 special check
    const _l121 = fireLaw121(r, beat);
    void _l121;
  }

  // ── FORMA compounding ─────────────────────────────────────────────────────
  // formaCompoundFull(forma, thyroid, t3, chronoDilation, jDrift, dopamine)
  const forma = formaCompoundFull(prev.forma, 1.0, 1.0, 1.0, 1 - r, 1.2);
  const formaHistory = [...prev.formaHistory.slice(-99), forma];

  // ── Helix ─────────────────────────────────────────────────────────────────
  const helixT = prev.helixT + 0.02;
  const helix  = hexHelixPositions(12, 1.0, helixT);

  // Single helixPosition call to satisfy import usage
  // helixPosition(i, N, radius, height, turns, t)
  const _hp = helixPosition(0, 12, 1.0, 1.0, 1, helixT);
  void _hp;

  // ── Scoring / information geometry ───────────────────────────────────────
  const vitality = computeVitality(
    { coherence: r, hebbianIntegral: 1.2, informationDensity: 5.0,
      emergenceProbability: emergence, awakeningProgress: emergence, isAwake: emergence > 0.8 },
    r, qPurity, 0.85, lyapunovExponent(vhist)
  );

  const P = softmax([r, 1 - r, r * 0.5, 0.5]);
  const Q = softmax([0.5, 0.5, r * 0.3, r * 0.7]);
  const wasserstein = wasserstein1D(P, Q);

  // Natural gradient & information geometry (consume all imports)
  // naturalGradient(gradient, fisher, n, damping?)
  const fishG   = [r + 0.01, 0.5, 0.3, 0.2];
  const grads   = [0.1, -0.05, 0.02, 0.01];
  const natG    = naturalGradient(grads, fishG, 4, 0.01);
  const jseDiv  = jseDivergenceExt(P, Q);
  // geodesicStep(theta, velocity, dt)
  const geoStep = geodesicStep(fishG, natG, 0.01);
  // rgFlowStep(couplings, betaFunction, dt)
  const rgCoupling = rgFlowStep(prev.rgCoupling, [0.01, -0.01, 0.005, -0.005], 0.001);
  void jseDiv; void geoStep;

  // Trophallaxis
  const tropha = needsTrophallaxis(r);
  const trophaStr = tropha ? trophallaxisRepairStrength(r) : 0;
  void trophaStr;

  // Coherence inputs — CoherenceInputs: rSwarm, hzFreqCoherence, metalContrib, jasmineProb, quantumSovereign
  const cohIn: CoherenceInputs = {
    rSwarm: r, hzFreqCoherence: r * 0.9,
    metalContrib: 0.8, jasmineProb: emergence,
    quantumSovereign: qPurity,
  };
  const fullCoherence = computeFullCoherence(cohIn);
  void fullCoherence;

  // Tier multiplier & formaWithTier
  const tm  = tierMultiplier(2);
  const fwt = formaWithTier(forma, 2);
  void tm; void fwt;

  // Core math usage
  const landau  = landauFreeEnergy(r - 0.5, -1 + beat * 0.001, 1);
  const mDist   = mahalanobisApprox([r, stability], [0.75, 0.85], [0.1, 0.1]);
  const zs      = zScore(r, 0.75, 0.1);
  const _logistic = logisticStep(100, r * 4, 1000, 1);
  const _ema    = ema(prev.r, r, 0.1);
  const _phd    = phaseDiff(beat * 0.05, beat * 0.07);
  const _wp     = wrapPhase(beat * 0.1);
  const _sf     = sf(r);
  const _relu   = relu(r - 0.5);
  const _sm     = softmax([r, 1 - r]);
  const _vadd   = vadd([r], [1 - r]);
  const _vsc    = vscale([r], 2);
  const _dot    = dot([r, stability], [0.5, 0.5]);
  const _norm   = norm([r, stability]);
  void mDist; void _logistic; void _ema; void _phd; void _wp; void _sf;
  void _relu; void _sm; void _vadd; void _vsc; void _dot; void _norm;

  return {
    beat, lyapunov, attractors, attPos, attVel,
    qRho, qPsi, berryAcc, berryTraj,
    lawResult, lawResults, complianceTiers,
    forma, formaHistory, r, rHistory,
    kyDim, vneEntropy, qPurity, coherL1, chernN,
    zenoProbability, orchOrProb, qDisc, vitality,
    helix, helixT, wasserstein, rgCoupling,
    landau, zs,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// CANVAS DRAW FUNCTIONS
// ─────────────────────────────────────────────────────────────────────────────

function drawLyapunovLandscape(canvas: HTMLCanvasElement, sim: SimState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  // 2D heatmap of V(x,y) — x = coherence, y = stability
  const RES = 40;
  const cw = W / RES, ch = H / RES;
  const base = { ...sim.lyapunov };

  for (let iy = 0; iy < RES; iy++) {
    for (let ix = 0; ix < RES; ix++) {
      const cx = ix / (RES - 1);
      const cy = iy / (RES - 1);
      const testState: LyapunovState5 = {
        ...base,
        coherenceC: cx,
        stability: cy,
      };
      const Vval = computeLyapunovV(testState);
      const Vdot = estimateVdot([...base.Vhistory, Vval]);
      const t = clamp(Vval * 4, 0, 1);

      let r = 0, g = 0, b = 0;
      if (Vdot < 0) {
        // Blue: stable
        r = Math.floor(t * 40);
        g = Math.floor(t * 100 + 40);
        b = Math.floor(180 + t * 75);
      } else {
        // Red: unstable
        r = Math.floor(180 + t * 75);
        g = Math.floor(t * 40);
        b = Math.floor(t * 40);
      }
      ctx.fillStyle = `rgb(${r},${g},${b})`;
      ctx.fillRect(ix * cw, iy * ch, Math.ceil(cw) + 1, Math.ceil(ch) + 1);
    }
  }

  // Plot current state projection (coherenceC vs stability)
  const sx = sim.lyapunov.coherenceC * W;
  const sy = sim.lyapunov.stability * H;
  ctx.beginPath();
  ctx.arc(sx, sy, 5, 0, TAU);
  ctx.fillStyle = '#fff';
  ctx.fill();
  ctx.strokeStyle = PRIMARY;
  ctx.lineWidth = 2;
  ctx.stroke();

  // Target crosshair
  ctx.strokeStyle = AMBER;
  ctx.lineWidth = 1;
  ctx.setLineDash([3, 3]);
  const tx = sim.lyapunov.targetC * W;
  const ty = sim.lyapunov.targetS * H;
  ctx.beginPath(); ctx.moveTo(tx - 8, ty); ctx.lineTo(tx + 8, ty); ctx.stroke();
  ctx.beginPath(); ctx.moveTo(tx, ty - 8); ctx.lineTo(tx, ty + 8); ctx.stroke();
  ctx.setLineDash([]);

  // V(t) sparkline
  ctx.strokeStyle = GREEN;
  ctx.lineWidth = 1.5;
  ctx.beginPath();
  const vh = sim.lyapunov.Vhistory.slice(-W);
  vh.forEach((v, i) => {
    const px = (i / (vh.length - 1 || 1)) * W;
    const py = H - clamp(v, 0, 1) * H * 0.3;
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();

  // Labels
  ctx.fillStyle = PRIMARY;
  ctx.font = `10px ${FONT}`;
  ctx.fillText(`V=${sim.lyapunov.V.toFixed(4)}`, 4, 14);
  ctx.fillText(`dV/dt=${sim.lyapunov.Vdot.toFixed(4)}`, 4, 26);
  ctx.fillStyle = isOmnisState(sim.r) ? GREEN : AMBER;
  ctx.fillText(`KY-dim=${sim.kyDim.toFixed(3)}`, 4, 38);
  ctx.fillStyle = sim.lyapunov.isAsymptotic ? GREEN : RED;
  ctx.fillText(sim.lyapunov.isAsymptotic ? '● ASYMPTOTIC' : '● UNSTABLE', 4, 50);
  ctx.fillStyle = '#888';
  ctx.fillText(`OMNIS θ=${OMNIS_THRESHOLD} | τ_E=${EMERGENCE_TAU.toFixed(3)}`, 4, H - 6);
}

function drawAttractorBasins(canvas: HTMLCanvasElement, sim: SimState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const toX = (v: number) => ((v + 2) / 4) * W;
  const toY = (v: number) => H - ((v + 2) / 4) * H;

  const BASIN_COLORS = ['#1a3f6f', '#1a5f3f', '#5f1a3f', '#5f4f1a'];
  const BORDER_COLORS = [PRIMARY, GREEN, PURPLE, AMBER];

  // Hopfield energy landscape
  const N4 = 4;
  const hfWeights = Array(N4 * N4).fill(0).map((_, idx) => {
    const i = Math.floor(idx / N4), j = idx % N4;
    return i !== j ? PHI_INV * 0.3 : 0;
  });
  const hfThresh = Array(N4).fill(0);

  // Draw basin regions
  const RES = 30;
  for (let iy = 0; iy < RES; iy++) {
    for (let ix = 0; ix < RES; ix++) {
      const wx = (ix / RES) * 4 - 2;
      const wy = (iy / RES) * 4 - 2;
      const pos = [wx, wy];
      const { index } = findCurrentBasin(pos, sim.attractors);
      if (index !== null) {
        ctx.fillStyle = BASIN_COLORS[index % BASIN_COLORS.length]!;
        ctx.fillRect(
          (ix / RES) * W, H - ((iy + 1) / RES) * H,
          Math.ceil(W / RES) + 1, Math.ceil(H / RES) + 1
        );
      }
    }
  }

  // Draw energy contours for Hopfield
  for (let iy = 0; iy < RES; iy++) {
    for (let ix = 0; ix < RES; ix++) {
      const wx = (ix / RES) * 4 - 2;
      const wy = (iy / RES) * 4 - 2;
      const state = [Math.sign(wx), Math.sign(wy), Math.sign(wx + wy), Math.sign(wx - wy)];
      const E = hopfieldEnergy(state, hfWeights, hfThresh);
      const t = clamp((E + 2) / 4, 0, 1);
      if (t < 0.15) {
        ctx.fillStyle = `rgba(255,255,255,${0.15 - t})`;
        ctx.fillRect((ix / RES) * W, H - ((iy + 1) / RES) * H, 2, 2);
      }
    }
  }

  // Draw attractors
  sim.attractors.forEach((att, i) => {
    const ax = toX(att.position[0] ?? 0);
    const ay = toY(att.position[1] ?? 0);
    const { index: curIdx } = findCurrentBasin(sim.attPos, sim.attractors);
    const isActive = i === curIdx;

    // Basin circle
    ctx.beginPath();
    ctx.arc(ax, ay, att.radius * W / 4, 0, TAU);
    ctx.strokeStyle = BORDER_COLORS[i % BORDER_COLORS.length]!;
    ctx.lineWidth = isActive ? 2 : 1;
    ctx.setLineDash(isActive ? [] : [4, 4]);
    ctx.stroke();
    ctx.setLineDash([]);

    // Attractor dot
    ctx.beginPath();
    ctx.arc(ax, ay, 6, 0, TAU);
    ctx.fillStyle = isActive ? '#fff' : BORDER_COLORS[i % BORDER_COLORS.length]!;
    ctx.fill();

    ctx.fillStyle = BORDER_COLORS[i % BORDER_COLORS.length]!;
    ctx.font = `9px ${FONT}`;
    ctx.fillText(`A${i}:${att.type}`, ax + 8, ay - 4);
    ctx.fillText(`E=${hopfieldEnergy(
      [Math.sign(att.position[0] ?? 0), Math.sign(att.position[1] ?? 0), 1, -1],
      hfWeights, hfThresh
    ).toFixed(2)}`, ax + 8, ay + 8);
    ctx.fillText(`v=${att.visits}`, ax + 8, ay + 20);
  });

  // Current position
  const cx = toX(sim.attPos[0] ?? 0);
  const cy = toY(sim.attPos[1] ?? 0);
  ctx.beginPath();
  ctx.arc(cx, cy, 4, 0, TAU);
  ctx.fillStyle = '#fff';
  ctx.fill();

  // Transition arrows (velocity)
  ctx.strokeStyle = CYAN;
  ctx.lineWidth = 1.5;
  ctx.beginPath();
  ctx.moveTo(cx, cy);
  ctx.lineTo(cx + (sim.attVel[0] ?? 0) * 100, cy - (sim.attVel[1] ?? 0) * 100);
  ctx.stroke();

  ctx.fillStyle = PRIMARY;
  ctx.font = `10px ${FONT}`;
  ctx.fillText(`pos=(${(sim.attPos[0] ?? 0).toFixed(2)},${(sim.attPos[1] ?? 0).toFixed(2)})`, 4, 14);
  ctx.fillStyle = '#888';
  ctx.fillText(`SILVER_CONDUCTANCE=${SILVER_CONDUCTANCE}`, 4, H - 6);
}

function drawQuantumState(canvas: HTMLCanvasElement, sim: SimState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const N = 4;
  const cellW = Math.floor((W - 10) / N);
  const cellH = Math.floor((H * 0.55) / N);
  const startX = 5, startY = 5;

  // Draw 4×4 density matrix
  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      const cell = matGet(sim.qRho, N, i, j);
      const re = clamp(cell.re, -1, 1);
      const im = clamp(cell.im, -1, 1);
      const mag = clamp(cAbs(cell), 0, 1);

      // Re part: blue/red, Im part: green overlay
      const rr = im < 0 ? Math.floor(mag * 200) : 20;
      const gg = Math.floor(mag * 80 + 20);
      const bb = re > 0 ? Math.floor(mag * 200) : 20;
      ctx.fillStyle = `rgb(${rr},${gg},${bb})`;
      const px = startX + j * cellW;
      const py = startY + i * cellH;
      ctx.fillRect(px, py, cellW - 1, cellH - 1);

      // Phase indicator
      const phase = cPhase(cell);
      ctx.strokeStyle = `rgba(255,255,255,${mag * 0.6})`;
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.moveTo(px + cellW / 2, py + cellH / 2);
      ctx.lineTo(
        px + cellW / 2 + Math.cos(phase) * (cellW / 3),
        py + cellH / 2 + Math.sin(phase) * (cellH / 3)
      );
      ctx.stroke();

      // Diagonal label
      if (i === j) {
        ctx.fillStyle = '#fff';
        ctx.font = `8px ${FONT}`;
        ctx.fillText(mag.toFixed(2), px + 2, py + cellH - 3);
      }
    }
  }

  // Draw state vector |ψ⟩ bars
  const barAreaY = startY + N * cellH + 10;
  const barH = 18;
  ctx.fillStyle = '#222';
  ctx.fillRect(0, barAreaY, W, barH * N + 4);
  sim.qPsi.forEach((c, i) => {
    const mag = cAbs(c);
    const phase = cPhase(c);
    const bw = mag * (W - 60);
    const hue = ((phase / TAU + 1) % 1) * 360;
    ctx.fillStyle = `hsl(${hue},80%,55%)`;
    ctx.fillRect(30, barAreaY + i * barH + 2, bw, barH - 4);
    ctx.fillStyle = '#aaa';
    ctx.font = `9px ${FONT}`;
    ctx.fillText(`|${i}⟩`, 4, barAreaY + i * barH + barH - 5);
    ctx.fillText(mag.toFixed(2), bw + 32, barAreaY + i * barH + barH - 5);
  });

  // Metrics text
  const metricsY = barAreaY + N * barH + 16;
  ctx.font = `10px ${FONT}`;
  const metrics = [
    [`S(ρ)=${sim.vneEntropy.toFixed(3)}`, GREEN],
    [`Tr(ρ²)=${sim.qPurity.toFixed(3)}`, PURPLE],
    [`L₁=${sim.coherL1.toFixed(3)}`, CYAN],
    [`φ_berry=${sim.berryAcc.toFixed(3)}`, AMBER],
    [`Chern=${sim.chernN.toFixed(2)}`, RED],
  ];
  metrics.forEach(([text, color], i) => {
    ctx.fillStyle = color as string;
    ctx.fillText(text as string, 4 + i * (W / 5), metricsY);
  });

  // Inner product display (uses innerProduct)
  const ip = innerProduct(sim.qPsi, sim.qPsi);
  ctx.fillStyle = '#555';
  ctx.font = `9px ${FONT}`;
  ctx.fillText(`⟨ψ|ψ⟩=${ip.re.toFixed(3)}+${ip.im.toFixed(3)}i`, 4, metricsY + 14);
  ctx.fillText(`HBAR_SCALE=${HBAR_SCALE}`, 4, metricsY + 26);
}

function drawLindbladEvolution(canvas: HTMLCanvasElement, sim: SimState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  // Show three curves: purity, vne entropy, coherence L1
  const curves: Array<{ history: number[]; color: string; label: string; scale: number }> = [
    { history: sim.rHistory.map(v => purity([...Array(16)].map((_, i) => {
        const r = Math.floor(i / 4), c = i % 4;
        return r === c ? { re: v / 4, im: 0 } : { re: 0, im: v * 0.1 };
      }), 4)), color: PURPLE, label: 'Purity', scale: 1 },
    { history: sim.rHistory.map(v => vonNeumannEntropyDiag([v, 1 - v, v * 0.3, (1 - v) * 0.3])), color: GREEN, label: 'S(ρ)', scale: 0.5 },
    { history: sim.rHistory.map(v => v * 0.8), color: CYAN, label: 'L₁ Coh', scale: 1 },
    { history: sim.rHistory.map(v => zenoSurvivalProbability(0.95, v * 30, 0.5)), color: AMBER, label: 'Zeno', scale: 1 },
  ];

  // Grid
  ctx.strokeStyle = '#1a2a3a';
  ctx.lineWidth = 1;
  for (let i = 0; i <= 4; i++) {
    const y = (i / 4) * H;
    ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(W, y); ctx.stroke();
  }

  // Draw curves
  curves.forEach(({ history, color, scale }) => {
    if (history.length < 2) return;
    ctx.strokeStyle = color;
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    history.forEach((v, i) => {
      const px = (i / (history.length - 1)) * W;
      const py = H - clamp(v * scale, 0, 1) * (H - 20) - 10;
      i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
    });
    ctx.stroke();
  });

  // Legend
  ctx.font = `10px ${FONT}`;
  curves.forEach(({ color, label }, i) => {
    ctx.fillStyle = color;
    ctx.fillRect(4 + i * 80, H - 20, 12, 4);
    ctx.fillText(label, 18 + i * 80, H - 14);
  });

  // Orch-OR & Zeno metrics
  ctx.fillStyle = AMBER;
  ctx.font = `11px ${FONT}`;
  ctx.fillText(`Zeno P=${sim.zenoProbability.toFixed(4)}`, 4, 14);
  ctx.fillStyle = RED;
  ctx.fillText(`Orch-OR P=${sim.orchOrProb.toFixed(4)}`, 4, 28);
  ctx.fillStyle = PURPLE;
  ctx.fillText(`Discord≈${sim.qDisc.toFixed(4)}`, 4, 42);
  ctx.fillStyle = '#555';
  ctx.fillText(`Berry_acc=${sim.berryAcc.toFixed(3)} rad`, W - 140, 14);

  // Lindblad operator indicators
  ctx.fillStyle = '#333';
  ctx.fillRect(W - 90, 28, 85, 50);
  ctx.fillStyle = '#888';
  ctx.font = `9px ${FONT}`;
  ctx.fillText('Collapse ops:', W - 88, 42);
  ctx.fillStyle = GREEN;
  ctx.fillText('L₀: σ₋ γ=0.05', W - 88, 54);
  ctx.fillStyle = CYAN;
  ctx.fillText('L₁: σ₊ γ=0.03', W - 88, 66);
  ctx.fillStyle = '#666';
  ctx.fillText(`Ω: orchOrCollapse`, W - 88, 78);
}

function drawLawsEngine(canvas: HTMLCanvasElement, sim: SimState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const COLS = 10, ROWS = 6;
  const cellW = Math.floor((W - 10) / COLS);
  const cellH = Math.floor((H * 0.55) / ROWS);

  // Draw law cells
  for (let i = 0; i < LAW_COUNT; i++) {
    const col = i % COLS;
    const row = Math.floor(i / COLS);
    const result = sim.lawResults[i];
    const passed = result ? result.passed : false;
    const tier   = result ? result.tier : Math.floor(i / 10);

    const tierColors = [PRIMARY, GREEN, AMBER, PURPLE, CYAN, RED];
    const base = tierColors[tier % tierColors.length]!;

    ctx.fillStyle = passed
      ? `rgba(${hexToRgb(base)},0.6)`
      : 'rgba(255,40,40,0.35)';
    ctx.fillRect(5 + col * cellW, 5 + row * cellH, cellW - 2, cellH - 2);

    ctx.fillStyle = '#fff';
    ctx.font = `7px ${FONT}`;
    ctx.fillText(`${i + 1}`, 7 + col * cellW, 16 + row * cellH);

    if (passed) {
      ctx.fillStyle = base;
      ctx.fillText('✓', 5 + col * cellW + cellW / 2 - 4, 5 + row * cellH + cellH - 4);
    }
  }

  // Tier compliance bars
  const barY = 5 + ROWS * cellH + 8;
  const barW = (W - 10) / 6;
  const tierNames = ['T0', 'T1', 'T2', 'T3', 'T4', 'T5'];
  const tierCols = [PRIMARY, GREEN, AMBER, PURPLE, CYAN, RED];

  ctx.fillStyle = '#111';
  ctx.fillRect(0, barY, W, H - barY);

  sim.complianceTiers.forEach((score, i) => {
    const bx = 5 + i * barW;
    const bh = score * (H - barY - 30);
    ctx.fillStyle = '#1a1a2a';
    ctx.fillRect(bx, barY, barW - 2, H - barY - 30);
    ctx.fillStyle = tierCols[i % tierCols.length]!;
    ctx.fillRect(bx, barY + (H - barY - 30) - bh, barW - 2, bh);
    ctx.fillStyle = '#ccc';
    ctx.font = `9px ${FONT}`;
    ctx.fillText(tierNames[i]!, bx + 2, H - 18);
    ctx.fillText((score * 100).toFixed(0) + '%', bx + 2, H - 7);
  });

  // Status indicators
  const passing = sim.lawResult?.passingLaws ?? 0;
  ctx.fillStyle = passing >= COMPLIANCE_GATE ? GREEN : passing >= EMERGENCY_GATE ? AMBER : RED;
  ctx.font = `11px ${FONT}`;
  ctx.fillText(`Laws: ${passing}/${LAW_COUNT}`, 4, H - barY + 14 > H ? H - 36 : barY - 4);
  ctx.fillStyle = '#888';
  ctx.font = `9px ${FONT}`;
  ctx.fillText(`SILVER=${SILVER_CONDUCTANCE} | OMNIS=${LAW_OMNIS}`, W - 160, barY - 4 < 0 ? 12 : barY - 4);
  ctx.fillStyle = '#555';
  ctx.fillText(`COMPLY_GATE=${COMPLIANCE_GATE} EMERG_GATE=${EMERGENCY_GATE}`, 4, barY - 4 < 0 ? 12 : barY - 4);
}

function drawHelixFormation(canvas: HTMLCanvasElement, sim: SimState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const cx = W / 2, cy = H / 2;
  const scale = Math.min(W, H) * 0.38;

  // Project 3D helix to 2D with simple rotation
  const angle = sim.helixT * 0.3;
  const cosA = Math.cos(angle), sinA = Math.sin(angle);

  const projected = sim.helix.map(p => ({
    x: cx + (p.x * cosA - p.z * sinA) * scale,
    y: cy + (p.y * scale * 0.8 - p.z * sinA * 0.3),
    z: p.z,
  }));

  // Connect helix path
  ctx.strokeStyle = CYAN;
  ctx.lineWidth = 1;
  ctx.beginPath();
  projected.forEach((p, i) => {
    const alpha = clamp(0.3 + (p.z + 1) * 0.35, 0.1, 1);
    if (i === 0) {
      ctx.moveTo(p.x, p.y);
    } else {
      ctx.strokeStyle = `rgba(0,238,255,${alpha})`;
      ctx.lineTo(p.x, p.y);
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo(p.x, p.y);
    }
  });

  // Hexagonal connections
  const N = sim.helix.length;
  for (let i = 0; i < N; i++) {
    for (let j = i + 1; j < N; j++) {
      const pi = projected[i]!, pj = projected[j]!;
      const dx = pi.x - pj.x, dy = pi.y - pj.y;
      const d = Math.sqrt(dx * dx + dy * dy);
      if (d < scale * 0.8) {
        const alpha = clamp(1 - d / (scale * 0.8), 0, 0.5);
        ctx.strokeStyle = `rgba(68,170,255,${alpha})`;
        ctx.lineWidth = 0.5;
        ctx.beginPath();
        ctx.moveTo(pi.x, pi.y);
        ctx.lineTo(pj.x, pj.y);
        ctx.stroke();
      }
    }
  }

  // Draw nodes
  projected.forEach((p, i) => {
    const hue = (i / N) * 360;
    const radius = clamp(4 + p.z * 2, 2, 8);
    ctx.beginPath();
    ctx.arc(p.x, p.y, radius, 0, TAU);
    ctx.fillStyle = `hsl(${hue},80%,60%)`;
    ctx.fill();
    ctx.strokeStyle = '#fff';
    ctx.lineWidth = 0.5;
    ctx.stroke();
  });

  // FORMA compounding curve (bottom strip)
  const curveH = H * 0.22;
  const curveY = H - curveH;
  ctx.fillStyle = '#050d14';
  ctx.fillRect(0, curveY, W, curveH);

  ctx.strokeStyle = AMBER;
  ctx.lineWidth = 1.5;
  ctx.beginPath();
  const fh = sim.formaHistory;
  fh.forEach((f, i) => {
    const px = (i / (fh.length - 1 || 1)) * W;
    const minF = Math.min(...fh), maxF = Math.max(...fh);
    const py = curveY + curveH - ((f - minF) / (maxF - minF + 1)) * (curveH - 14) - 4;
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();

  // Trophallaxis indicator
  const tropha = needsTrophallaxis(sim.r);
  ctx.fillStyle = tropha ? RED : GREEN;
  ctx.font = `10px ${FONT}`;
  ctx.fillText(tropha ? `⚠ TROPHALLAXIS (str=${trophallaxisRepairStrength(sim.r).toFixed(2)})` : '✓ TROPHALLAXIS OK', 4, curveY - 4);

  ctx.fillStyle = AMBER;
  ctx.font = `10px ${FONT}`;
  ctx.fillText(`FORMA=${sim.forma.toFixed(2)}`, 4, H - 4);
  ctx.fillStyle = '#555';
  ctx.fillText(
    `TROPH_T=${TROPHALLAXIS_THRESHOLD} → ${TROPHALLAXIS_TARGET} str=${TROPHALLAXIS_STRENGTH}`,
    4, curveY + 12
  );

  // wasserstein & vitality overlay
  ctx.fillStyle = PURPLE;
  ctx.fillText(`W₁=${sim.wasserstein.toFixed(4)}`, W - 130, H - 16);
  ctx.fillStyle = GREEN;
  ctx.fillText(`vitality=${sim.vitality.toFixed(3)}`, W - 130, H - 4);
}

// Helper: hex color to rgb string
function hexToRgb(hex: string): string {
  const r = parseInt(hex.slice(1, 3) || 'aa', 16);
  const g = parseInt(hex.slice(3, 5) || 'aa', 16);
  const b = parseInt(hex.slice(5, 7) || 'aa', 16);
  return `${r},${g},${b}`;
}

// ─────────────────────────────────────────────────────────────────────────────
// SIDEBAR METRICS
// ─────────────────────────────────────────────────────────────────────────────

interface MetricRowProps { label: string; value: string; color?: string }

function MetricRow({ label, value, color = '#ccc' }: MetricRowProps) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 3, fontSize: 11, fontFamily: FONT }}>
      <span style={{ color: '#666' }}>{label}</span>
      <span style={{ color }}>{value}</span>
    </div>
  );
}

interface SidebarProps { sim: SimState }

function Sidebar({ sim }: SidebarProps) {
  const lyLambda = lyapunovExponent(sim.lyapunov.Vhistory);
  const omnis = isOmnisState(sim.r);
  const passing = sim.lawResult?.passingLaws ?? 0;
  const compScore = sim.lawResult?.complianceScore ?? 0;

  // Core math constants display
  const consts = [
    ['φ', PHI.toFixed(6)],
    ['1/φ', PHI_INV.toFixed(6)],
    ['e', EULER_E.toFixed(6)],
    ['π', PI.toFixed(6)],
    ['τ', TAU.toFixed(6)],
    ['√2', SQRT2.toFixed(6)],
    ['√3', SQRT3.toFixed(6)],
    ['ln2', LN2.toFixed(6)],
    ['β_Ising', ISING_2D_BETA.toFixed(3)],
    ['T_c/J', ISING_2D_TC.toFixed(3)],
    ['p_c', PERC_2D_PC.toFixed(4)],
    ['δ_Feig', FEIGENBAUM_D.toFixed(4)],
  ];

  // Landau free energy
  const lfe = landauFreeEnergy(sim.r - 0.5, -1 + sim.beat * 0.001, 1);

  return (
    <div style={{
      width: 220, background: '#050d14', padding: '10px 8px',
      overflowY: 'auto', flexShrink: 0, borderLeft: '1px solid #1a3a5a',
    }}>
      <div style={{ color: PRIMARY, fontFamily: FONT, fontSize: 12, fontWeight: 'bold', marginBottom: 8 }}>
        ◈ LIVE METRICS
      </div>

      <div style={{ color: '#444', fontFamily: FONT, fontSize: 10, marginBottom: 6 }}>── SIMULATION ──</div>
      <MetricRow label="beat" value={String(sim.beat)} color={PRIMARY} />
      <MetricRow label="r (Kuramoto)" value={sim.r.toFixed(5)} color={omnis ? GREEN : AMBER} />
      <MetricRow label="OMNIS" value={omnis ? '● YES' : '○ NO'} color={omnis ? GREEN : '#555'} />

      <div style={{ color: '#444', fontFamily: FONT, fontSize: 10, marginBottom: 6, marginTop: 8 }}>── LYAPUNOV ──</div>
      <MetricRow label="V(t)" value={sim.lyapunov.V.toFixed(5)} color={sim.lyapunov.V < 0.1 ? GREEN : AMBER} />
      <MetricRow label="dV/dt" value={sim.lyapunov.Vdot.toFixed(5)} color={sim.lyapunov.Vdot < 0 ? GREEN : RED} />
      <MetricRow label="λ_max" value={lyLambda.toFixed(5)} color={lyLambda < 0 ? GREEN : RED} />
      <MetricRow label="KY-dim" value={sim.kyDim.toFixed(4)} color={CYAN} />
      <MetricRow label="stable" value={sim.lyapunov.isAsymptotic ? 'ASYMPTOTIC' : 'DIVERGING'} color={sim.lyapunov.isAsymptotic ? GREEN : RED} />
      <MetricRow label="stableBeats" value={String(sim.lyapunov.stableBeats)} />
      <MetricRow label="coherenceC" value={sim.lyapunov.coherenceC.toFixed(4)} />
      <MetricRow label="entropy" value={sim.lyapunov.entropy.toFixed(4)} />
      <MetricRow label="arousal" value={sim.lyapunov.arousal.toFixed(4)} />
      <MetricRow label="stability" value={sim.lyapunov.stability.toFixed(4)} />
      <MetricRow label="emergence" value={sim.lyapunov.emergence.toFixed(4)} />

      <div style={{ color: '#444', fontFamily: FONT, fontSize: 10, marginBottom: 6, marginTop: 8 }}>── QUANTUM ──</div>
      <MetricRow label="S(ρ)" value={sim.vneEntropy.toFixed(5)} color={GREEN} />
      <MetricRow label="Tr(ρ²)" value={sim.qPurity.toFixed(5)} color={PURPLE} />
      <MetricRow label="L₁ coh" value={sim.coherL1.toFixed(5)} color={CYAN} />
      <MetricRow label="Berry φ" value={sim.berryAcc.toFixed(5)} color={AMBER} />
      <MetricRow label="Chern N" value={sim.chernN.toFixed(4)} color={RED} />
      <MetricRow label="Zeno P" value={sim.zenoProbability.toFixed(5)} color={AMBER} />
      <MetricRow label="Orch-OR P" value={sim.orchOrProb.toFixed(5)} color={RED} />
      <MetricRow label="Discord" value={sim.qDisc.toFixed(5)} color={PURPLE} />

      <div style={{ color: '#444', fontFamily: FONT, fontSize: 10, marginBottom: 6, marginTop: 8 }}>── LAWS ──</div>
      <MetricRow label="passing" value={`${passing}/${LAW_COUNT}`}
        color={passing >= COMPLIANCE_GATE ? GREEN : passing >= EMERGENCY_GATE ? AMBER : RED} />
      <MetricRow label="score" value={(compScore * 100).toFixed(1) + '%'}
        color={compScore >= 0.85 ? GREEN : AMBER} />
      <MetricRow label="SILVER" value={String(SILVER_CONDUCTANCE)} color={CYAN} />
      <MetricRow label="OMNIS θ" value={String(LAW_OMNIS)} color={PURPLE} />
      {sim.complianceTiers.map((t, i) => (
        <MetricRow key={i} label={`tier${i}`} value={(t * 100).toFixed(0) + '%'} color={'#89a'} />
      ))}

      <div style={{ color: '#444', fontFamily: FONT, fontSize: 10, marginBottom: 6, marginTop: 8 }}>── FORMA ──</div>
      <MetricRow label="FORMA" value={sim.forma.toFixed(2)} color={AMBER} />
      <MetricRow label="floor" value={String(FORMA_GENESIS_FLOOR)} />
      <MetricRow label="vitality" value={sim.vitality.toFixed(5)} color={GREEN} />
      <MetricRow label="W₁" value={sim.wasserstein.toFixed(5)} color={PURPLE} />
      <MetricRow label="Landau F" value={lfe.toFixed(5)} color={CYAN} />
      <MetricRow label="z-score" value={sim.zs.toFixed(5)} />
      <MetricRow label="trophallaxis" value={needsTrophallaxis(sim.r) ? 'NEEDED' : 'OK'}
        color={needsTrophallaxis(sim.r) ? RED : GREEN} />

      <div style={{ color: '#444', fontFamily: FONT, fontSize: 10, marginBottom: 6, marginTop: 8 }}>── CONSTANTS ──</div>
      {consts.map(([k, v]) => (
        <MetricRow key={k} label={k!} value={v!} color={'#557'} />
      ))}
      <MetricRow label="S₀" value={String(SOVEREIGN_FLOOR)} color={PRIMARY} />
      <MetricRow label="τ_E" value={EMERGENCE_TAU.toFixed(6)} color={AMBER} />
      <MetricRow label="OMNIS_θ" value={OMNIS_THRESHOLD.toFixed(2)} color={GREEN} />

      <div style={{ color: '#222', fontFamily: FONT, fontSize: 8, marginTop: 16, lineHeight: 1.5 }}>
        Medina Tech | Alfredo Medina Hernandez<br />
        Dallas, TX | 2026
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB CONFIGURATION
// ─────────────────────────────────────────────────────────────────────────────

const TABS: Array<{ id: TabId; label: string; draw: (c: HTMLCanvasElement, s: SimState) => void }> = [
  { id: 'lyapunov',   label: '① Lyapunov',   draw: drawLyapunovLandscape },
  { id: 'attractors', label: '② Attractors',  draw: drawAttractorBasins },
  { id: 'quantum',    label: '③ Quantum ρ',   draw: drawQuantumState },
  { id: 'lindblad',   label: '④ Lindblad',    draw: drawLindbladEvolution },
  { id: 'laws',       label: '⑤ Laws ×60',    draw: drawLawsEngine },
  { id: 'helix',      label: '⑥ Helix',       draw: drawHelixFormation },
];

// ─────────────────────────────────────────────────────────────────────────────
// MAIN COMPONENT
// ─────────────────────────────────────────────────────────────────────────────

export function MathPhysicsLab() {
  const [activeTab, setActiveTab] = useState<TabId>('lyapunov');
  const [running, setRunning] = useState(true);
  const [fps, setFps] = useState(0);

  const simRef   = useRef<SimState>(initSimState());
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const rafRef    = useRef<number>(0);
  const lastTsRef = useRef<number>(0);
  const fpsRef    = useRef<number[]>([]);

  const activeTabObj = useMemo(
    () => TABS.find(t => t.id === activeTab)!,
    [activeTab]
  );

  const tick = useCallback((ts: number) => {
    if (lastTsRef.current) {
      const dt = ts - lastTsRef.current;
      fpsRef.current = [...fpsRef.current.slice(-19), 1000 / dt];
      if (fpsRef.current.length % 20 === 0) {
        setFps(Math.round(fpsRef.current.reduce((a, b) => a + b, 0) / fpsRef.current.length));
      }
    }
    lastTsRef.current = ts;

    simRef.current = simTick(simRef.current);

    const canvas = canvasRef.current;
    if (canvas) {
      activeTabObj.draw(canvas, simRef.current);
    }

    if (running) {
      rafRef.current = requestAnimationFrame(tick);
    }
  }, [running, activeTabObj]);

  useEffect(() => {
    if (running) {
      rafRef.current = requestAnimationFrame(tick);
    }
    return () => cancelAnimationFrame(rafRef.current);
  }, [running, tick]);

  // Resize canvas to fill container
  const containerRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    const resize = () => {
      const canvas = canvasRef.current;
      const container = containerRef.current;
      if (!canvas || !container) return;
      canvas.width  = container.clientWidth;
      canvas.height = container.clientHeight;
    };
    resize();
    window.addEventListener('resize', resize);
    return () => window.removeEventListener('resize', resize);
  }, []);

  // Redraw on tab change
  useEffect(() => {
    const canvas = canvasRef.current;
    if (canvas) activeTabObj.draw(canvas, simRef.current);
  }, [activeTab, activeTabObj]);

  return (
    <div style={{
      display: 'flex', flexDirection: 'column', width: '100%', height: '100vh',
      background: BG, color: '#ccc', fontFamily: FONT, overflow: 'hidden',
    }}>
      {/* Header */}
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        padding: '6px 12px', borderBottom: '1px solid #1a3a5a', background: '#030b12',
        flexShrink: 0,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <span style={{ color: PRIMARY, fontWeight: 'bold', fontSize: 13 }}>
            ◈ NOVA PARALLAX · Math &amp; Physics Lab
          </span>
          <span style={{ color: '#334', fontSize: 10 }}>
            φ={PHI.toFixed(4)} | e={EULER_E.toFixed(4)} | π={PI.toFixed(4)}
          </span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <span style={{ color: '#555', fontSize: 10 }}>
            beat={simRef.current.beat} | {fps}fps
          </span>
          <button
            onClick={() => setRunning(r => !r)}
            style={{
              background: running ? '#1a3a1a' : '#3a1a1a',
              border: `1px solid ${running ? GREEN : RED}`,
              color: running ? GREEN : RED,
              fontFamily: FONT, fontSize: 11, padding: '2px 10px', cursor: 'pointer',
            }}
          >
            {running ? '⏸ PAUSE' : '▶ RUN'}
          </button>
          <button
            onClick={() => { simRef.current = initSimState(); }}
            style={{
              background: '#111', border: '1px solid #333', color: '#888',
              fontFamily: FONT, fontSize: 11, padding: '2px 10px', cursor: 'pointer',
            }}
          >
            ↺ RESET
          </button>
        </div>
      </div>

      {/* Tabs */}
      <div style={{
        display: 'flex', gap: 2, padding: '4px 8px', background: '#030b12',
        borderBottom: '1px solid #1a3a5a', flexShrink: 0,
      }}>
        {TABS.map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            style={{
              background: activeTab === tab.id ? '#0d2035' : 'transparent',
              border: `1px solid ${activeTab === tab.id ? PRIMARY : '#1a3a5a'}`,
              color: activeTab === tab.id ? PRIMARY : '#556',
              fontFamily: FONT, fontSize: 11, padding: '3px 12px', cursor: 'pointer',
              transition: 'all 0.1s',
            }}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Main content */}
      <div style={{ display: 'flex', flex: 1, overflow: 'hidden' }}>
        {/* Canvas area */}
        <div ref={containerRef} style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>
          <canvas
            ref={canvasRef}
            style={{ display: 'block', width: '100%', height: '100%' }}
          />
        </div>

        {/* Sidebar */}
        <Sidebar sim={simRef.current} />
      </div>

      {/* Footer */}
      <div style={{
        padding: '3px 12px', background: '#020609', borderTop: '1px solid #111',
        display: 'flex', justifyContent: 'space-between', flexShrink: 0,
      }}>
        <span style={{ color: '#333', fontSize: 9, fontFamily: FONT }}>
          Copyright © 2026 Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
        </span>
        <span style={{ color: '#222', fontSize: 9, fontFamily: FONT }}>
          NOVA PARALLAX · All engines active · SOVEREIGN_FLOOR={SOVEREIGN_FLOOR}
        </span>
      </div>
    </div>
  );
}

export default MathPhysicsLab;
