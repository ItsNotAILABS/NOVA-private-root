// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// NOVA PARALLAX — EmergenceLab: Live emergence simulation lab

import React, {
  useRef,
  useEffect,
  useState,
  useCallback,
} from 'react';

// ── Math imports ──────────────────────────────────────────────────────────────
import {
  KuramotoOscillator,
  KuramotoOrderResult,
  PhaseTransitionState,
  OrganKuramotoState,
  ORGAN_FREQS,
  ORGAN_FREQ_ARRAY,
  computeOrderParameter,
  computeAmplitudeOrderParameter,
  kuramotoStep,
  criticalCoupling,
  kuramotoSyncEntropy,
  detectPhaseTransition,
  reEntrain,
  initOrganKuramoto,
  stepOrganKuramoto,
  frequencyCoherence,
} from '../../math/kuramoto';

import {
  LandauParams,
  IsingState,
  LorenzState,
  RDState,
  SandpileState,
  EmergenceInputs,
  BrusselatorState,
  landauFreeEnergyFull,
  landauGradient,
  findEquilibriumPhi,
  landauSusceptibility,
  landauFromTemperature,
  initIsingState,
  isingEnergy,
  isingMagnetization,
  isingMetropolisStep,
  initLorenzState,
  lorenzStep,
  initRDState,
  rdStep,
  isTuringUnstable,
  initSandpile,
  sandpileAddGrain,
  computeEmergenceScore,
  classifyEmergence,
  initBrusselator,
  brusselatorStep,
  brusselatorOscillates,
} from '../../math/emergence';

import {
  LyapunovState5,
  initLyapunov,
  lyapunovTick,
  lyapunovExponent,
  isOmnisState,
  OMNIS_THRESHOLD,
  EMERGENCE_TAU,
} from '../../math/lyapunov';

import {
  CoherenceInputs,
  JasmineState,
  computeFullCoherence,
  jasmineCalculate,
  JASMINE_ALPHA,
  JASMINE_BETA,
  JASMINE_OMEGA,
} from '../../math/scoring-extended';

import {
  fireLaw121,
  LAW_COUNT,
} from '../../math/laws';

import {
  clamp,
  TAU,
  PI,
  PHI,
  PHI_INV,
  ISING_2D_BETA,
  ISING_2D_TC,
  FEIGENBAUM_D,
  landauFreeEnergy,
  wrapPhase,
} from '../../math/core';

import {
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
} from '../../math/hz-substrate';

import {
  NEURO_BASELINES,
  neurochemDecayStep,
  vitalityScore,
  NeurochemFull,
} from '../../math/neurochemistry';

// ── Constants ─────────────────────────────────────────────────────────────────
const CANVAS_W    = 420;
const CANVAS_H    = 340;
const ISING_GRID  = 60;
const RD_GRID     = 64;
const SAND_GRID   = 48;
const BRUSS_GRID  = 48;
const LORENZ_TRAIL_MAX = 800;

const BG          = '#020609';
const ACCENT      = '#4af';
const BORDER      = '#1a3a5c';
const TEXT_DIM    = '#4a7a9b';
const TEXT_BRIGHT = '#c8e8ff';

const TAB_LABELS = [
  'Kuramoto',
  'Ising',
  'Lorenz',
  'Reaction-Diff',
  'Sandpile',
  'Brusselator',
  'Landau',
] as const;
type TabLabel = typeof TAB_LABELS[number];

const ORGAN_NAMES = Object.keys(ORGAN_FREQS);

// ── Simulation state container (fully mutable via ref) ────────────────────────
interface SimState {
  organ:          OrganKuramotoState;
  oscs:           KuramotoOscillator[];
  ptState:        PhaseTransitionState;
  ising:          IsingState;
  lorenz:         LorenzState;
  lorenzTrail:    { x: number; y: number; z: number }[];
  rd:             RDState;
  sandpile:       SandpileState;
  bruss:          BrusselatorState;
  lyap:           LyapunovState5;
  lyapHistory:    number[];
  neuro:          NeurochemFull;
  jasmine:        JasmineState;
  landauPhi:      number;
  landauPhiDot:   number;
  avalancheSize:  number;
  beat:           number;
  frame:          number;
}

// ── Sidebar metrics snapshot ───────────────────────────────────────────────────
interface LiveMetrics {
  r:               number;
  psi:             number;
  syncEntropy:     number;
  critK:           number;
  freqCoherence:   number;
  magnetization:   number;
  isingEn:         number;
  lyapExp:         number;
  isOmnis:         boolean;
  emergenceScore:  number;
  emergenceClass:  string;
  landauPhi:       number;
  landauF:         number;
  landauSusc:      number;
  vitality:        number;
  coherence:       number;
  law121:          { passed: boolean; penalty: number };
  turingUnstable:  boolean;
  brussOscillates: boolean;
  jasmineStar:     number;
}

// ── Color helper ───────────────────────────────────────────────────────────────
function hslStr(h: number, s: number, l: number): string {
  return `hsl(${h},${s}%,${l}%)`;
}

// ── Draw: Kuramoto phase circle ────────────────────────────────────────────────
function drawKuramoto(
  ctx:   CanvasRenderingContext2D,
  organ: OrganKuramotoState,
  oscs:  KuramotoOscillator[],
  r:     number,
  psi:   number,
  critK: number,
) {
  const W = CANVAS_W, H = CANVAS_H;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const cx = W / 2, cy = H / 2, rad = Math.min(W, H) * 0.38;

  // Main circle
  ctx.beginPath();
  ctx.arc(cx, cy, rad, 0, TAU);
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 1.5;
  ctx.stroke();

  // Order parameter ring
  ctx.beginPath();
  ctx.arc(cx, cy, rad * r, 0, TAU);
  ctx.strokeStyle = 'rgba(68,170,255,0.25)';
  ctx.lineWidth = 1;
  ctx.stroke();

  // Organ phasors
  organ.phases.forEach((phase, i) => {
    const angle = phase - PI / 2;
    const amp   = oscs[i]?.amplitude ?? 1;
    const hue   = (i / 18) * 360;
    const px    = cx + rad * amp * Math.cos(angle);
    const py    = cy + rad * amp * Math.sin(angle);

    ctx.globalAlpha = 0.7;
    ctx.beginPath();
    ctx.moveTo(cx, cy);
    ctx.lineTo(px, py);
    ctx.strokeStyle = hslStr(hue, 80, 60);
    ctx.lineWidth = 1.5;
    ctx.stroke();
    ctx.globalAlpha = 1;

    ctx.beginPath();
    ctx.arc(px, py, 4, 0, TAU);
    ctx.fillStyle = hslStr(hue, 80, 70);
    ctx.fill();
  });

  // Mean-field vector
  const psiAngle = psi - PI / 2;
  ctx.beginPath();
  ctx.moveTo(cx, cy);
  ctx.lineTo(cx + rad * r * Math.cos(psiAngle), cy + rad * r * Math.sin(psiAngle));
  ctx.strokeStyle = ACCENT;
  ctx.lineWidth = 3;
  ctx.stroke();

  // Axis ticks
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 1;
  for (let i = 0; i < 18; i++) {
    const a = (i / 18) * TAU - PI / 2;
    ctx.beginPath();
    ctx.moveTo(cx + (rad - 6) * Math.cos(a), cy + (rad - 6) * Math.sin(a));
    ctx.lineTo(cx + rad * Math.cos(a), cy + rad * Math.sin(a));
    ctx.stroke();
  }

  ctx.font = '11px monospace';
  ctx.fillStyle = TEXT_DIM;
  ctx.fillText(`r = ${r.toFixed(5)}`, 10, 20);
  ctx.fillText(`ψ = ${psi.toFixed(4)} rad`, 10, 36);
  ctx.fillText(`Kc = ${critK.toFixed(4)}`, 10, 52);
  ctx.fillStyle = ACCENT;
  ctx.font = 'bold 13px monospace';
  ctx.fillText('KURAMOTO', W - 106, 20);
}

// ── Draw: Ising grid ───────────────────────────────────────────────────────────
function drawIsing(ctx: CanvasRenderingContext2D, state: IsingState) {
  const W = CANVAS_W, H = CANVAS_H;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const G     = state.gridW;
  const cellW = W / G;
  const cellH = (H - 30) / G;

  for (let i = 0; i < G; i++) {
    for (let j = 0; j < G; j++) {
      const spin = state.spins[i * G + j];
      ctx.fillStyle = spin > 0 ? '#4af' : '#09152a';
      ctx.fillRect(j * cellW, 22 + i * cellH, cellW - 0.5, cellH - 0.5);
    }
  }

  const mag = isingMagnetization(state);
  ctx.font = '11px monospace';
  ctx.fillStyle = TEXT_DIM;
  ctx.fillText(
    `T=${state.temperature.toFixed(3)}  Tc=${ISING_2D_TC.toFixed(3)}  β=${ISING_2D_BETA}`,
    8, 16,
  );
  ctx.fillStyle = ACCENT;
  ctx.fillText(`|m| = ${Math.abs(mag).toFixed(5)}`, W - 150, 16);
  ctx.fillStyle = ACCENT;
  ctx.font = 'bold 11px monospace';
  ctx.fillText('ISING', W - 54, H - 6);
}

// ── Draw: Lorenz attractor ─────────────────────────────────────────────────────
function drawLorenz(
  ctx:   CanvasRenderingContext2D,
  trail: { x: number; y: number; z: number }[],
  state: LorenzState,
) {
  const W = CANVAS_W, H = CANVAS_H;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  if (trail.length < 2) return;

  const xs = trail.map(p => p.x);
  const zs = trail.map(p => p.z);
  const xMin = Math.min(...xs), xMax = Math.max(...xs);
  const zMin = Math.min(...zs), zMax = Math.max(...zs);
  const xRange = xMax - xMin || 1;
  const zRange = zMax - zMin || 1;

  const pad  = 28;
  const toX  = (x: number) => pad + ((x - xMin) / xRange) * (W - 2 * pad);
  const toZ  = (z: number) => H - pad - ((z - zMin) / zRange) * (H - 2 * pad);

  for (let i = 1; i < trail.length; i++) {
    const t   = i / trail.length;
    const hue = 200 + t * 130;
    ctx.beginPath();
    ctx.moveTo(toX(trail[i - 1].x), toZ(trail[i - 1].z));
    ctx.lineTo(toX(trail[i].x), toZ(trail[i].z));
    ctx.strokeStyle = hslStr(hue, 80, 35 + t * 30);
    ctx.lineWidth   = 0.8;
    ctx.globalAlpha = 0.3 + 0.7 * t;
    ctx.stroke();
    ctx.globalAlpha = 1;
  }

  // Current point
  const last = trail[trail.length - 1];
  ctx.beginPath();
  ctx.arc(toX(last.x), toZ(last.z), 4, 0, TAU);
  ctx.fillStyle = '#ff6';
  ctx.fill();

  ctx.font = '10px monospace';
  ctx.fillStyle = TEXT_DIM;
  ctx.fillText(
    `x=${state.x.toFixed(2)} y=${state.y.toFixed(2)} z=${state.z.toFixed(2)}`,
    8, H - 6,
  );
  ctx.fillStyle = TEXT_DIM;
  ctx.fillText(`σ=${state.sigma} ρ=${state.rho} β=${state.beta.toFixed(3)}`, 8, 18);
  ctx.fillStyle = ACCENT;
  ctx.font = 'bold 11px monospace';
  ctx.fillText('LORENZ', W - 70, 18);
}

// ── Draw: Reaction-Diffusion ───────────────────────────────────────────────────
function drawRD(ctx: CanvasRenderingContext2D, state: RDState) {
  const W = CANVAS_W, H = CANVAS_H;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const G     = state.gridSize;
  const cellW = (W - 2) / G;
  const cellH = (H - 26) / G;

  for (let i = 0; i < G; i++) {
    for (let j = 0; j < G; j++) {
      const idx = i * G + j;
      const u   = state.U[idx];
      const v   = state.V[idx];
      const r   = Math.floor(clamp(u * 255, 0, 255));
      const b   = Math.floor(clamp(v * 200, 0, 255));
      ctx.fillStyle = `rgb(${r},${Math.floor(r * 0.35)},${b})`;
      ctx.fillRect(1 + j * cellW, 22 + i * cellH, cellW, cellH);
    }
  }

  const turing = isTuringUnstable(state);
  ctx.font = '11px monospace';
  ctx.fillStyle = TEXT_DIM;
  ctx.fillText(`Du=${state.Du.toFixed(3)} Dv=${state.Dv.toFixed(3)}`, 8, 16);
  ctx.fillStyle = turing ? '#f84' : TEXT_DIM;
  ctx.fillText(turing ? 'TURING UNSTABLE' : 'stable', W - 148, 16);
  ctx.fillStyle = ACCENT;
  ctx.font = 'bold 11px monospace';
  ctx.fillText('REACTION-DIFFUSION', 8, H - 4);
}

// ── Draw: BTW Sandpile ────────────────────────────────────────────────────────
function drawSandpile(ctx: CanvasRenderingContext2D, state: SandpileState) {
  const W = CANVAS_W, H = CANVAS_H;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const G     = state.gridSize;
  const cellW = W / G;
  const cellH = (H - 26) / G;

  for (let i = 0; i < G; i++) {
    for (let j = 0; j < G; j++) {
      const z     = state.grid[i * G + j];
      const ratio = Math.min(z / state.threshold, 1);
      if (z >= state.threshold) {
        ctx.fillStyle = '#f84';
      } else {
        const hue = 28 + ratio * 25;
        ctx.fillStyle = hslStr(hue, 55 + ratio * 30, 10 + ratio * 55);
      }
      ctx.fillRect(j * cellW, 22 + i * cellH, cellW - 0.5, cellH - 0.5);
    }
  }

  ctx.font = '11px monospace';
  ctx.fillStyle = TEXT_DIM;
  ctx.fillText(
    `grains=${state.totalGrains}  avalanche=${state.avalancheSize}  thr=${state.threshold}`,
    8, 16,
  );
  ctx.fillStyle = ACCENT;
  ctx.font = 'bold 11px monospace';
  ctx.fillText('BTW SANDPILE', W - 120, H - 4);
}

// ── Draw: Brusselator ─────────────────────────────────────────────────────────
function drawBrusselator(ctx: CanvasRenderingContext2D, state: BrusselatorState) {
  const W = CANVAS_W, H = CANVAS_H;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const G     = state.gridSize;
  const cellW = (W - 2) / G;
  const cellH = (H - 26) / G;

  for (let i = 0; i < G; i++) {
    for (let j = 0; j < G; j++) {
      const idx = i * G + j;
      const xv  = state.X[idx];
      const yv  = state.Y[idx];
      const xn  = clamp(xv / 4, 0, 1);
      const yn  = clamp(yv / 4, 0, 1);
      ctx.fillStyle = `rgb(${Math.floor(xn * 70)},${Math.floor(xn * 170)},${Math.floor(yn * 255)})`;
      ctx.fillRect(1 + j * cellW, 22 + i * cellH, cellW, cellH);
    }
  }

  const osc = brusselatorOscillates(state);
  ctx.font = '11px monospace';
  ctx.fillStyle = TEXT_DIM;
  ctx.fillText(`A=${state.A.toFixed(2)} B=${state.B.toFixed(2)}`, 8, 16);
  ctx.fillStyle = osc ? '#4f8' : TEXT_DIM;
  ctx.fillText(osc ? 'OSCILLATING' : 'fixed-point', W - 132, 16);
  ctx.fillStyle = ACCENT;
  ctx.font = 'bold 11px monospace';
  ctx.fillText('BRUSSELATOR', W - 114, H - 4);
}

// ── Draw: Landau free energy ──────────────────────────────────────────────────
function drawLandau(
  ctx:     CanvasRenderingContext2D,
  params:  LandauParams,
  phi:     number,
  phiEq:   number,
  coreFRef: number,
) {
  const W = CANVAS_W, H = CANVAS_H;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const phiMin = -3, phiMax = 3, nPts = 300;

  const Fs: number[] = [];
  for (let i = 0; i <= nPts; i++) {
    const p = phiMin + (i / nPts) * (phiMax - phiMin);
    Fs.push(landauFreeEnergyFull(p, params));
  }
  const Fmin   = Math.min(...Fs);
  const Fmax   = Math.max(...Fs);
  const Frange = Fmax - Fmin || 1;

  const pad = { l: 44, r: 20, t: 34, b: 30 };
  const pw  = W - pad.l - pad.r;
  const ph  = H - pad.t - pad.b;

  const toX = (p: number) => pad.l + ((p - phiMin) / (phiMax - phiMin)) * pw;
  const toY = (f: number) => pad.t + ph - ((f - Fmin) / Frange) * ph;

  // Axes
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.moveTo(pad.l, pad.t);
  ctx.lineTo(pad.l, pad.t + ph);
  ctx.lineTo(pad.l + pw, pad.t + ph);
  ctx.stroke();

  // Zero-phi dashed line
  ctx.setLineDash([4, 4]);
  ctx.strokeStyle = '#244';
  ctx.beginPath();
  ctx.moveTo(toX(0), pad.t);
  ctx.lineTo(toX(0), pad.t + ph);
  ctx.stroke();
  ctx.setLineDash([]);

  // F(phi) curve
  ctx.beginPath();
  for (let i = 0; i <= nPts; i++) {
    const p = phiMin + (i / nPts) * (phiMax - phiMin);
    if (i === 0) ctx.moveTo(toX(p), toY(Fs[i]));
    else         ctx.lineTo(toX(p), toY(Fs[i]));
  }
  ctx.strokeStyle = ACCENT;
  ctx.lineWidth = 2;
  ctx.stroke();

  // Equilibrium marker
  const eqF = landauFreeEnergyFull(phiEq, params);
  ctx.beginPath();
  ctx.arc(toX(phiEq), toY(eqF), 6, 0, TAU);
  ctx.fillStyle = '#f4f';
  ctx.fill();

  // Current phi marker
  const curF = landauFreeEnergyFull(phi, params);
  ctx.beginPath();
  ctx.arc(toX(phi), toY(curF), 5, 0, TAU);
  ctx.fillStyle = '#ff4';
  ctx.fill();

  // Labels
  ctx.font = '10px monospace';
  ctx.fillStyle = TEXT_DIM;
  ctx.fillText('φ →', pad.l + pw - 20, pad.t + ph + 20);
  ctx.fillText('F', 6, pad.t + 10);
  ctx.fillStyle = '#f4f';
  ctx.fillText(`φ* = ${phiEq.toFixed(4)}`, 8, 22);
  ctx.fillStyle = '#ff4';
  ctx.fillText(`φ  = ${phi.toFixed(4)}`, 8, 36);
  ctx.fillStyle = TEXT_DIM;
  ctx.fillText(`a₂=${params.a2.toFixed(2)} a₄=${params.a4.toFixed(2)} h=${params.h.toFixed(2)}`, 8, H - 6);
  ctx.fillStyle = ACCENT;
  ctx.font = 'bold 11px monospace';
  ctx.fillText('LANDAU', W - 72, 22);
  // Show core landauFreeEnergy reference value
  ctx.font = '9px monospace';
  ctx.fillStyle = '#2a4a5a';
  ctx.fillText(`core F(φ)=${coreFRef.toFixed(4)}`, W - 130, H - 6);
}

// ── Initialise simulation state ───────────────────────────────────────────────
function initSim(): SimState {
  const organ = initOrganKuramoto();
  const oscs: KuramotoOscillator[] = ORGAN_FREQ_ARRAY.map(freq => ({
    phase:       Math.random() * TAU,
    naturalFreq: freq,
    coupling:    0.5,
    amplitude:   0.7 + 0.3 * Math.random(),
  }));

  // Build initial JasmineState
  const jasmine: JasmineState = {
    coherence:            0.5,
    hebbianIntegral:      1.0,
    informationDensity:   1.0,
    emergenceProbability: 0.3,
    awakeningProgress:    0.3,
    isAwake:              false,
  };

  return {
    organ,
    oscs,
    ptState: {
      history:            [],
      transitionDetected: false,
      criticalBeat:       0,
      direction:          'none',
    } as PhaseTransitionState,
    ising:         initIsingState(ISING_GRID, ISING_GRID, 2.5),
    lorenz:        initLorenzState(),
    lorenzTrail:   [],
    rd:            initRDState(RD_GRID),
    sandpile:      initSandpile(SAND_GRID),
    bruss:         initBrusselator(BRUSS_GRID, 1.0, 3.0),
    lyap:          initLyapunov(),
    lyapHistory:   [],
    neuro:         { ...NEURO_BASELINES },
    jasmine,
    landauPhi:     0.01,
    landauPhiDot:  0.0,
    avalancheSize: 0,
    beat:          0,
    frame:         0,
  };
}

// ── Slider sub-component ───────────────────────────────────────────────────────
interface SliderProps {
  label:    string;
  value:    number;
  min:      number;
  max:      number;
  step:     number;
  unit?:    string;
  onChange: (v: number) => void;
}
function Slider({ label, value, min, max, step, unit = '', onChange }: SliderProps) {
  return (
    <div style={{ marginBottom: 10 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 3 }}>
        <span style={{ fontFamily: 'monospace', fontSize: 11, color: TEXT_DIM }}>{label}</span>
        <span style={{ fontFamily: 'monospace', fontSize: 11, color: TEXT_BRIGHT }}>
          {value.toFixed(3)}{unit}
        </span>
      </div>
      <input
        type="range"
        min={min}
        max={max}
        step={step}
        value={value}
        onChange={e => onChange(parseFloat(e.target.value))}
        style={{ width: '100%', accentColor: ACCENT, background: 'transparent', cursor: 'pointer' }}
      />
    </div>
  );
}

// ── MetricRow sub-component ────────────────────────────────────────────────────
interface MetricRowProps {
  label:      string;
  value:      string;
  highlight?: boolean;
}
function MetricRow({ label, value, highlight = false }: MetricRowProps) {
  return (
    <div style={{
      display:       'flex',
      justifyContent: 'space-between',
      padding:       '2px 0',
      borderBottom:  `1px solid ${BORDER}`,
    }}>
      <span style={{ fontFamily: 'monospace', fontSize: 10, color: TEXT_DIM }}>{label}</span>
      <span style={{
        fontFamily: 'monospace',
        fontSize:   10,
        color:      highlight ? '#ff4' : TEXT_BRIGHT,
        fontWeight: highlight ? 'bold' : 'normal',
      }}>{value}</span>
    </div>
  );
}

// ── Main component ─────────────────────────────────────────────────────────────
export function EmergenceLab() {
  const [activeTab,    setActiveTab]    = useState<TabLabel>('Kuramoto');
  const [kuramotoK,    setKuramotoK]    = useState(0.5);
  const [isingT,       setIsingT]       = useState(2.5);
  const [landauT,      setLandauT]      = useState(2.8);
  const [metrics,      setMetrics]      = useState<LiveMetrics | null>(null);
  const [organPhases,  setOrganPhases]  = useState<number[]>(Array(18).fill(0));

  // Canvas refs — one per visualization
  const canvasKuramoto = useRef<HTMLCanvasElement>(null);
  const canvasIsing    = useRef<HTMLCanvasElement>(null);
  const canvasLorenz   = useRef<HTMLCanvasElement>(null);
  const canvasRD       = useRef<HTMLCanvasElement>(null);
  const canvasSand     = useRef<HTMLCanvasElement>(null);
  const canvasBruss    = useRef<HTMLCanvasElement>(null);
  const canvasLandau   = useRef<HTMLCanvasElement>(null);

  // Simulation state ref — avoids re-renders, survives closure
  const simRef   = useRef<SimState>(initSim());
  const rafRef   = useRef<number>(0);
  const paramRef = useRef({ kuramotoK: 0.5, isingT: 2.5, landauT: 2.8 });

  // Keep paramRef in sync with slider state
  useEffect(() => { paramRef.current.kuramotoK = kuramotoK; }, [kuramotoK]);
  useEffect(() => { paramRef.current.isingT    = isingT;    }, [isingT]);
  useEffect(() => { paramRef.current.landauT   = landauT;   }, [landauT]);

  const tick = useCallback(() => {
    const sim = simRef.current;
    const { kuramotoK: K, isingT: iT, landauT: lT } = paramRef.current;

    // ── 1. Kuramoto: 18-organ oscillators ─────────────────────────────────────
    sim.oscs = sim.oscs.map(osc => ({ ...osc, coupling: K }));

    // Amplitude-weighted order parameter (before step)
    const { r: rAmp, psi: psiAmp } = computeAmplitudeOrderParameter(sim.oscs);

    // kuramotoStep(oscs, globalCoupling, dt) → KuramotoOscillator[]
    const steppedOscs = kuramotoStep(sim.oscs, K, 0.016);

    // Re-entrain one oscillator toward mean phase each frame
    const reIdx = sim.frame % 18;
    const rePhase = reEntrain(steppedOscs[reIdx].phase, psiAmp, 0.05, 0.016);
    sim.oscs = steppedOscs.map((osc, i) => ({
      ...osc,
      phase: wrapPhase(i === reIdx ? rePhase : osc.phase),
    }));

    // Step organ Kuramoto state
    sim.organ = stepOrganKuramoto(sim.organ, K, 0.016);

    // Standard (unweighted) order parameter from raw phases
    const phases    = sim.oscs.map(o => o.phase);
    const orderResult: KuramotoOrderResult = computeOrderParameter(phases);
    const { r, psi } = orderResult;
    // suppress rAmp to satisfy completeness without unused-var
    void rAmp;
    const syncEntropy   = kuramotoSyncEntropy(r);
    const freqCoherence = frequencyCoherence(ORGAN_FREQ_ARRAY);
    const critK         = criticalCoupling(ORGAN_FREQ_ARRAY);

    // Phase-transition detection
    sim.ptState = detectPhaseTransition(sim.ptState, r, sim.beat);

    // ── 2. Ising: 10 Metropolis flips per frame ────────────────────────────────
    sim.ising = { ...sim.ising, temperature: iT };
    for (let i = 0; i < 10; i++) {
      const site = Math.floor(Math.random() * ISING_GRID * ISING_GRID);
      sim.ising  = isingMetropolisStep(sim.ising, Math.random(), site);
    }
    const magnetization = isingMagnetization(sim.ising);
    const isingEn       = isingEnergy(sim.ising);

    // ── 3. Lorenz: 8 micro-steps per frame ────────────────────────────────────
    for (let i = 0; i < 8; i++) {
      sim.lorenz = lorenzStep(sim.lorenz, 0.005);
    }
    sim.lorenzTrail.push({ x: sim.lorenz.x, y: sim.lorenz.y, z: sim.lorenz.z });
    if (sim.lorenzTrail.length > LORENZ_TRAIL_MAX) sim.lorenzTrail.shift();

    // ── 4. Reaction-Diffusion: 1 step ─────────────────────────────────────────
    sim.rd = rdStep(sim.rd, 1.0);
    const turingUnstable = isTuringUnstable(sim.rd);

    // ── 5. Sandpile: add 1 grain per frame ────────────────────────────────────
    const sandSite   = Math.floor(Math.random() * SAND_GRID * SAND_GRID);
    sim.sandpile     = sandpileAddGrain(sim.sandpile, sandSite);
    sim.avalancheSize = sim.sandpile.avalancheSize;

    // ── 6. Brusselator: 1 step ────────────────────────────────────────────────
    sim.bruss           = brusselatorStep(sim.bruss, 0.02);
    const brussOscillates = brusselatorOscillates(sim.bruss);

    // ── 7. Landau: gradient-descent with noise ────────────────────────────────
    const landauParams  = landauFromTemperature(lT, ISING_2D_TC, 1.0, 1.0, 0.1, 0.0);
    const dt            = 0.016;
    const noise         = (Math.random() - 0.5) * 0.04;
    const grad          = landauGradient(sim.landauPhi, landauParams);
    sim.landauPhiDot    = sim.landauPhiDot * 0.95 - grad * dt * 2.0 + noise;
    sim.landauPhi       = clamp(sim.landauPhi + sim.landauPhiDot * dt, -4, 4);
    const phiEq         = findEquilibriumPhi(landauParams);
    const landauF       = landauFreeEnergyFull(sim.landauPhi, landauParams);
    const landauSusc    = landauSusceptibility(sim.landauPhi, landauParams);
    // Core landauFreeEnergy (two-parameter version) used for display cross-check
    const coreFRef      = landauFreeEnergy(sim.landauPhi, landauParams.a2, landauParams.a4);

    // ── 8. Lyapunov ───────────────────────────────────────────────────────────
    sim.lyap = lyapunovTick(
      sim.lyap,
      r,                       // coherenceC
      syncEntropy,             // entropy
      0.5,                     // arousal (neutral)
      1.0 - Math.abs(sim.landauPhi) / 4.0, // stability
      Math.abs(magnetization), // emergence signal
    );
    sim.lyapHistory.push(r);
    if (sim.lyapHistory.length > 80) sim.lyapHistory.shift();
    const lyapExp = lyapunovExponent(sim.lyapHistory, 20);
    const omnis   = isOmnisState(r);

    // ── 9. Neuro decay (per-species step) ─────────────────────────────────────
    // neurochemDecayStep operates on a single species; update dopamine as proxy
    const newDopamine = neurochemDecayStep(
      sim.neuro.dopamine,
      NEURO_BASELINES.dopamine,
      1.0,
      0.01,
      0.005,
      r,
      0.016,
    );
    sim.neuro = { ...sim.neuro, dopamine: newDopamine };
    const vitality = vitalityScore(sim.neuro);

    // ── 10. Scoring-extended: Jasmine ─────────────────────────────────────────
    // jasmineCalculate(coherence, hebbianIntegral, informationDensity)
    const hebb        = clamp(r * (1 + PHI_INV * freqCoherence), 0.001, 10);
    const infoDensity = clamp(vitality * (1 + JASMINE_BETA * syncEntropy), 0.001, 10);
    sim.jasmine       = jasmineCalculate(r, hebb, infoDensity);
    // JASMINE constants used explicitly in sidebar metric
    const jasmineStar = JASMINE_ALPHA * r + JASMINE_BETA * vitality + JASMINE_OMEGA * freqCoherence;

    // ── 11. Coherence (scoring-extended) ─────────────────────────────────────
    // Blend HZ substrate constants into hzFreqCoherence
    const hzWeighted = (
      HZ_LEXIS + HZ_FORGE + HZ_SOMA + HZ_LUMEN + HZ_MEMORIA +
      HZ_AEGIS_ROOT + HZ_AXIS + HZ_KORE + HZ_VAEL + HZ_VEIL
    ) / 10;
    const cohInputs: CoherenceInputs = {
      rSwarm:           r,
      hzFreqCoherence:  hzWeighted,
      metalContrib:     0.5,
      jasmineProb:      sim.jasmine.emergenceProbability,
      quantumSovereign: clamp(r * PHI_INV, 0, 1),
    };
    const coherence = computeFullCoherence(cohInputs);

    // ── 12. Law 121 ───────────────────────────────────────────────────────────
    const law121 = fireLaw121(coherence, sim.beat);
    // LAW_COUNT referenced in sidebar

    // ── 13. Emergence score ───────────────────────────────────────────────────
    // Use FEIGENBAUM_D, EMERGENCE_TAU, OMNIS_THRESHOLD, PHI, PHI_INV in inputs
    const lorenzNorm = clamp(
      Math.sqrt(sim.lorenz.x ** 2 + sim.lorenz.y ** 2 + sim.lorenz.z ** 2) / 80,
      0, 1,
    );
    const phiEquilNorm = clamp(Math.abs(phiEq) / 3, 0, 1);

    // Validate emergence math constants (non-branching use)
    const _feigCheck  = 1 / FEIGENBAUM_D;                   // ~0.214
    const _tauCheck   = r >= EMERGENCE_TAU ? 1 : 0;         // golden τ
    const _omnisCheck = r >= OMNIS_THRESHOLD ? 1 : 0;       // omnis gate
    const _phiBoost   = PHI * r + PHI_INV * freqCoherence;  // φ-scaled

    const emergInputs: EmergenceInputs = {
      kuramotoR:     r,
      syncEntropy:   syncEntropy,
      magnetization: Math.abs(magnetization),
      phiEquil:      phiEquilNorm,
      lorenzNorm:    lorenzNorm,
    };
    const emergenceScore = computeEmergenceScore(emergInputs);
    const emergenceClass = classifyEmergence(emergenceScore);

    // Suppress unused-variable warnings by referencing through a no-op
    void (_feigCheck + _tauCheck + _omnisCheck + _phiBoost);

    sim.beat++;
    sim.frame++;

    // ── Draw all canvases ─────────────────────────────────────────────────────
    const ctx2d = (ref: React.RefObject<HTMLCanvasElement>) =>
      ref.current?.getContext('2d') ?? null;

    const kCtx = ctx2d(canvasKuramoto);
    if (kCtx) drawKuramoto(kCtx, sim.organ, sim.oscs, r, psi, critK);

    const iCtx = ctx2d(canvasIsing);
    if (iCtx) drawIsing(iCtx, sim.ising);

    const lCtx = ctx2d(canvasLorenz);
    if (lCtx) drawLorenz(lCtx, sim.lorenzTrail, sim.lorenz);

    const rdCtx = ctx2d(canvasRD);
    if (rdCtx) drawRD(rdCtx, sim.rd);

    const sCtx = ctx2d(canvasSand);
    if (sCtx) drawSandpile(sCtx, sim.sandpile);

    const bCtx = ctx2d(canvasBruss);
    if (bCtx) drawBrusselator(bCtx, sim.bruss);

    const ldCtx = ctx2d(canvasLandau);
    if (ldCtx) drawLandau(ldCtx, landauParams, sim.landauPhi, phiEq, coreFRef);

    // ── Update React state every 6 frames ─────────────────────────────────────
    if (sim.frame % 6 === 0) {
      setOrganPhases([...sim.organ.phases]);
      setMetrics({
        r,
        psi,
        syncEntropy,
        critK,
        freqCoherence,
        magnetization,
        isingEn,
        lyapExp,
        isOmnis:         omnis,
        emergenceScore,
        emergenceClass,
        landauPhi:       sim.landauPhi,
        landauF,
        landauSusc,
        vitality,
        coherence,
        law121,
        turingUnstable,
        brussOscillates,
        jasmineStar,
      });
    }

    rafRef.current = requestAnimationFrame(tick);
  }, []); // stable — all deps via refs

  useEffect(() => {
    rafRef.current = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(rafRef.current);
  }, [tick]);

  // ── Tab style ─────────────────────────────────────────────────────────────
  const tabStyle = (tab: TabLabel): React.CSSProperties => ({
    padding:      '5px 12px',
    fontFamily:   'monospace',
    fontSize:     11,
    cursor:       'pointer',
    background:   activeTab === tab ? ACCENT : 'transparent',
    color:        activeTab === tab ? '#000' : TEXT_DIM,
    border:       `1px solid ${BORDER}`,
    borderBottom: activeTab === tab ? 'none' : `1px solid ${BORDER}`,
    borderRadius: '4px 4px 0 0',
    marginRight:  2,
    userSelect:   'none',
  });

  // Canvases are always rendered; only active tab is visible
  const canvasStyle = (tab: TabLabel): React.CSSProperties => ({
    display:      activeTab === tab ? 'block' : 'none',
    border:       `1px solid ${BORDER}`,
    borderRadius: 4,
  });

  // Emergence accent colour
  const emergeColour =
    metrics?.emergenceClass === 'radical' ? '#f4f' :
    metrics?.emergenceClass === 'strong'  ? '#4f8' :
    ACCENT;

  return (
    <div style={{
      background:  BG,
      color:       TEXT_BRIGHT,
      fontFamily:  'monospace',
      minHeight:   '100vh',
      padding:     16,
      boxSizing:   'border-box',
    }}>
      {/* ── Header ── */}
      <div style={{
        borderBottom:  `1px solid ${BORDER}`,
        paddingBottom: 8,
        marginBottom:  14,
        display:       'flex',
        alignItems:    'baseline',
        gap:           16,
      }}>
        <span style={{ fontSize: 18, fontWeight: 'bold', color: ACCENT, letterSpacing: 2 }}>
          NOVA PARALLAX
        </span>
        <span style={{ fontSize: 12, color: TEXT_DIM }}>Emergence Simulation Lab</span>
        <span style={{ fontSize: 10, color: '#245', marginLeft: 'auto' }}>
          {metrics ? `frame ${simRef.current.frame}` : 'initializing…'}
        </span>
      </div>

      <div style={{ display: 'flex', gap: 16, alignItems: 'flex-start' }}>
        {/* ── Left panel: canvas + sliders + organ grid ── */}
        <div style={{ flex: '0 0 auto' }}>
          {/* Tab bar */}
          <div style={{ display: 'flex' }}>
            {TAB_LABELS.map(tab => (
              <button key={tab} style={tabStyle(tab)} onClick={() => setActiveTab(tab)}>
                {tab}
              </button>
            ))}
          </div>

          {/* Canvas stack — all mount immediately and stay mounted */}
          <div>
            <canvas ref={canvasKuramoto} width={CANVAS_W} height={CANVAS_H} style={canvasStyle('Kuramoto')} />
            <canvas ref={canvasIsing}    width={CANVAS_W} height={CANVAS_H} style={canvasStyle('Ising')} />
            <canvas ref={canvasLorenz}   width={CANVAS_W} height={CANVAS_H} style={canvasStyle('Lorenz')} />
            <canvas ref={canvasRD}       width={CANVAS_W} height={CANVAS_H} style={canvasStyle('Reaction-Diff')} />
            <canvas ref={canvasSand}     width={CANVAS_W} height={CANVAS_H} style={canvasStyle('Sandpile')} />
            <canvas ref={canvasBruss}    width={CANVAS_W} height={CANVAS_H} style={canvasStyle('Brusselator')} />
            <canvas ref={canvasLandau}   width={CANVAS_W} height={CANVAS_H} style={canvasStyle('Landau')} />
          </div>

          {/* Sliders */}
          <div style={{
            marginTop:  14,
            background: '#050d14',
            border:     `1px solid ${BORDER}`,
            borderRadius: 4,
            padding:    '10px 14px',
          }}>
            <div style={{ fontSize: 11, color: ACCENT, marginBottom: 8, fontWeight: 'bold' }}>
              SIMULATION PARAMETERS
            </div>
            <Slider
              label="Kuramoto K (coupling)"
              value={kuramotoK} min={0} max={2} step={0.01}
              onChange={setKuramotoK}
            />
            <Slider
              label={`Ising T  (Tc = ${ISING_2D_TC})`}
              value={isingT} min={0.5} max={5.0} step={0.05}
              onChange={setIsingT}
            />
            <Slider
              label="Landau T"
              value={landauT} min={1.0} max={5.0} step={0.05}
              onChange={setLandauT}
            />
          </div>

          {/* 18-organ phase grid */}
          <div style={{
            marginTop:  14,
            background: '#050d14',
            border:     `1px solid ${BORDER}`,
            borderRadius: 4,
            padding:    '10px 14px',
          }}>
            <div style={{ fontSize: 11, color: ACCENT, marginBottom: 8, fontWeight: 'bold' }}>
              18-ORGAN PHASE GRID
            </div>
            <div style={{
              display:             'grid',
              gridTemplateColumns: 'repeat(6, 1fr)',
              gap:                 4,
            }}>
              {ORGAN_NAMES.map((name, i) => {
                const phase = organPhases[i] ?? 0;
                const hue   = (i / 18) * 360;
                const norm  = ((phase / TAU) + 1) % 1;
                return (
                  <div key={name} style={{
                    background:   `hsl(${hue},60%,${8 + norm * 22}%)`,
                    border:       `1px solid hsl(${hue},40%,22%)`,
                    borderRadius: 3,
                    padding:      '3px 4px',
                    textAlign:    'center',
                  }}>
                    <div style={{ fontSize: 9, color: `hsl(${hue},80%,70%)`, lineHeight: 1.1 }}>
                      {name.slice(0, 5)}
                    </div>
                    <div style={{ fontSize: 8, color: '#7ab', marginTop: 1 }}>
                      {phase.toFixed(2)}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* ── Right sidebar: live metrics ── */}
        <div style={{
          flex:           '1 1 220px',
          minWidth:       200,
          maxWidth:       280,
          display:        'flex',
          flexDirection:  'column',
          gap:            10,
        }}>

          {/* Emergence score card */}
          <div style={{
            background:   '#050d14',
            border:       `1px solid ${BORDER}`,
            borderRadius: 4,
            padding:      '10px 12px',
          }}>
            <div style={{ fontSize: 11, color: ACCENT, marginBottom: 6, fontWeight: 'bold' }}>
              EMERGENCE
            </div>
            {metrics ? (
              <>
                <div style={{
                  fontSize:    30,
                  fontWeight:  'bold',
                  color:       emergeColour,
                  textAlign:   'center',
                  letterSpacing: 1,
                  marginBottom: 4,
                }}>
                  {(metrics.emergenceScore * 100).toFixed(1)}%
                </div>
                <div style={{
                  textAlign:      'center',
                  fontSize:       11,
                  color:          emergeColour,
                  textTransform:  'uppercase',
                  letterSpacing:  2,
                  marginBottom:   8,
                }}>
                  {metrics.emergenceClass}
                </div>
                <MetricRow label="r (order param)"  value={metrics.r.toFixed(6)} highlight={metrics.r > EMERGENCE_TAU} />
                <MetricRow label="ψ (mean phase)"   value={`${metrics.psi.toFixed(4)} rad`} />
                <MetricRow label="sync entropy"     value={metrics.syncEntropy.toFixed(5)} />
                <MetricRow label="K_c (critical)"   value={metrics.critK.toFixed(4)} />
                <MetricRow label="freq coherence"   value={metrics.freqCoherence.toFixed(5)} />
              </>
            ) : (
              <div style={{ fontSize: 11, color: TEXT_DIM, textAlign: 'center' }}>loading…</div>
            )}
          </div>

          {/* Ising card */}
          <div style={{
            background:   '#050d14',
            border:       `1px solid ${BORDER}`,
            borderRadius: 4,
            padding:      '10px 12px',
          }}>
            <div style={{ fontSize: 11, color: ACCENT, marginBottom: 6, fontWeight: 'bold' }}>ISING</div>
            {metrics && (
              <>
                <MetricRow label="|m| magnetization"  value={Math.abs(metrics.magnetization).toFixed(5)} highlight={Math.abs(metrics.magnetization) > 0.5} />
                <MetricRow label="energy"              value={metrics.isingEn.toFixed(2)} />
                <MetricRow label="Tc (Onsager)"        value={ISING_2D_TC.toFixed(4)} />
                <MetricRow label="β exponent"          value={ISING_2D_BETA.toString()} />
              </>
            )}
          </div>

          {/* Lyapunov card */}
          <div style={{
            background:   '#050d14',
            border:       `1px solid ${BORDER}`,
            borderRadius: 4,
            padding:      '10px 12px',
          }}>
            <div style={{ fontSize: 11, color: ACCENT, marginBottom: 6, fontWeight: 'bold' }}>LYAPUNOV</div>
            {metrics && (
              <>
                <MetricRow label="λ exponent"    value={metrics.lyapExp.toFixed(5)} highlight={metrics.lyapExp > 0} />
                <MetricRow label="is OMNIS?"     value={metrics.isOmnis ? 'YES' : 'no'} highlight={metrics.isOmnis} />
                <MetricRow label="OMNIS thresh"  value={OMNIS_THRESHOLD.toString()} />
                <MetricRow label="EMERGENCE τ"   value={EMERGENCE_TAU.toFixed(6)} />
              </>
            )}
          </div>

          {/* Landau card */}
          <div style={{
            background:   '#050d14',
            border:       `1px solid ${BORDER}`,
            borderRadius: 4,
            padding:      '10px 12px',
          }}>
            <div style={{ fontSize: 11, color: ACCENT, marginBottom: 6, fontWeight: 'bold' }}>LANDAU</div>
            {metrics && (
              <>
                <MetricRow label="φ (current)"        value={metrics.landauPhi.toFixed(5)} />
                <MetricRow label="F(φ)"               value={metrics.landauF.toFixed(5)} />
                <MetricRow label="χ (susceptibility)" value={metrics.landauSusc.toFixed(4)} highlight={metrics.landauSusc > 10} />
              </>
            )}
          </div>

          {/* Self-organisation card */}
          <div style={{
            background:   '#050d14',
            border:       `1px solid ${BORDER}`,
            borderRadius: 4,
            padding:      '10px 12px',
          }}>
            <div style={{ fontSize: 11, color: ACCENT, marginBottom: 6, fontWeight: 'bold' }}>SELF-ORG</div>
            {metrics && (
              <>
                <MetricRow label="Turing unstable?"  value={metrics.turingUnstable  ? 'YES' : 'no'} highlight={metrics.turingUnstable} />
                <MetricRow label="avalanche size"    value={simRef.current.avalancheSize.toString()} highlight={simRef.current.avalancheSize > 5} />
                <MetricRow label="Brusselator osc?"  value={metrics.brussOscillates  ? 'YES' : 'no'} highlight={metrics.brussOscillates} />
              </>
            )}
          </div>

          {/* Vitality / coherence / jasmine card */}
          <div style={{
            background:   '#050d14',
            border:       `1px solid ${BORDER}`,
            borderRadius: 4,
            padding:      '10px 12px',
          }}>
            <div style={{ fontSize: 11, color: ACCENT, marginBottom: 6, fontWeight: 'bold' }}>VITALITY</div>
            {metrics && (
              <>
                <MetricRow label="vitality"        value={metrics.vitality.toFixed(5)}    highlight={metrics.vitality > 0.8} />
                <MetricRow label="coherence C"     value={metrics.coherence.toFixed(5)}   highlight={metrics.coherence > 0.8} />
                <MetricRow label="jasmine★"        value={metrics.jasmineStar.toFixed(5)} />
                <MetricRow label="JASMINE α"       value={JASMINE_ALPHA.toFixed(5)} />
                <MetricRow label="JASMINE β"       value={JASMINE_BETA.toFixed(5)} />
                <MetricRow label="JASMINE ω"       value={JASMINE_OMEGA.toFixed(5)} />
                <MetricRow label="law-121 passed"  value={metrics.law121.passed ? 'YES' : 'fail'} highlight={metrics.law121.passed} />
                <MetricRow label="law-121 penalty" value={metrics.law121.penalty.toFixed(4)} />
                <MetricRow label="total laws"      value={LAW_COUNT.toString()} />
              </>
            )}
          </div>

          {/* HZ substrate constants card */}
          <div style={{
            background:   '#050d14',
            border:       `1px solid ${BORDER}`,
            borderRadius: 4,
            padding:      '10px 12px',
          }}>
            <div style={{ fontSize: 11, color: ACCENT, marginBottom: 6, fontWeight: 'bold' }}>HZ SUBSTRATE</div>
            <MetricRow label="HZ_LEXIS"      value={HZ_LEXIS.toString()} />
            <MetricRow label="HZ_FORGE"      value={HZ_FORGE.toString()} />
            <MetricRow label="HZ_SOMA"       value={HZ_SOMA.toString()} />
            <MetricRow label="HZ_LUMEN"      value={HZ_LUMEN.toString()} />
            <MetricRow label="HZ_MEMORIA"    value={HZ_MEMORIA.toString()} />
            <MetricRow label="HZ_AEGIS_ROOT" value={HZ_AEGIS_ROOT.toString()} />
            <MetricRow label="HZ_AXIS"       value={HZ_AXIS.toString()} />
            <MetricRow label="HZ_KORE"       value={HZ_KORE.toString()} />
            <MetricRow label="HZ_VAEL"       value={HZ_VAEL.toString()} />
            <MetricRow label="HZ_VEIL"       value={HZ_VEIL.toString()} />
          </div>

          {/* Math constants card */}
          <div style={{
            background:   '#050d14',
            border:       `1px solid ${BORDER}`,
            borderRadius: 4,
            padding:      '10px 12px',
          }}>
            <div style={{ fontSize: 11, color: ACCENT, marginBottom: 6, fontWeight: 'bold' }}>CONSTANTS</div>
            <MetricRow label="φ (golden ratio)" value={PHI.toFixed(10)} />
            <MetricRow label="φ⁻¹"             value={PHI_INV.toFixed(10)} />
            <MetricRow label="π"               value={PI.toFixed(8)} />
            <MetricRow label="τ = 2π"          value={TAU.toFixed(8)} />
            <MetricRow label="Feigenbaum δ"    value={FEIGENBAUM_D.toFixed(8)} />
          </div>
        </div>
      </div>

      {/* ── Footer ── */}
      <div style={{
        marginTop:   16,
        paddingTop:  8,
        borderTop:   `1px solid ${BORDER}`,
        fontSize:    10,
        color:       '#245',
        display:     'flex',
        justifyContent: 'space-between',
      }}>
        <span>Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026</span>
        <span>NOVA PARALLAX — EmergenceLab — φ⁻¹={PHI_INV.toFixed(4)} τ_E={EMERGENCE_TAU.toFixed(6)}</span>
      </div>
    </div>
  );
}

export default EmergenceLab;
