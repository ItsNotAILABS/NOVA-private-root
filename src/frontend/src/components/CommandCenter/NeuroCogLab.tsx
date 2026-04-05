// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: NeuroCogLab — 21-Species Neurochemistry + Drive Architecture
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// ENGINE ARCHITECTURE:
//   1. 21-SPECIES NEUROCHEMISTRY — full Michaelis-Menten ODE
//   2. 66-PAIR CROSSTALK MATRIX — neurotransmitter interactions
//   3. OLFACTORY LIMBIC PATHWAY — thalamic bypass direct injection
//   4. PAC SYNCHRONY — phase-amplitude coupling drive modulation
//   5. AEGIS IMMUNE SYSTEM — threat detection + NE/EPI surge
//   6. DRIVE QUARTET — hunger, thirst, libido, aggression homeostasis
//   7. METAL PIPELINE — gold, silver, platinum coherence contribution
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useEffect, useRef, useState, useCallback } from 'react';

import {
  NeurochemFull, NeurochemStimuli, NEURO_BASELINES, HALFLIFE,
  neurochemFullStep, neurochemDecayStep, projectTo4Species,
  vitalityScore, neuroplasticityFactor, allostaticLoad,
  MetalState, METAL_BASELINES, metalCoherenceContribution, metalPipelineStep,
} from '../../math/neurochemistry';

import {
  clamp, sigmoid, tanh, PHI, PHI_INV, PI, TAU, NEURO_DT, sf,
} from '../../math/core';

// ── Colour palette ────────────────────────────────────────────────────────────
const GOLD   = '#D4AF37';
const CYAN   = '#00D4FF';
const PURPLE = '#6B46C1';
const GREEN  = '#4ade80';
const ORANGE = '#f97316';
const RED    = '#f43f5e';
const PINK   = '#ec4899';
const BG     = '#030609';
const BG2    = '#050d14';
const BORDER = '#1a3a5c';
const MUTED  = '#4a6a8a';
const WHITE  = '#e2f0ff';

// ═══════════════════════════════════════════════════════════════════════════════
// 66-PAIR CROSSTALK MATRIX
// Each pair: [sourceIdx, targetIdx, weight, sign]
// Positive sign = facilitation, negative = inhibition
// ═══════════════════════════════════════════════════════════════════════════════
const NT_NAMES = [
  'dopamine', 'serotonin', 'norepinephrine', 'epinephrine', 'acetylcholine',
  'gaba', 'glycine', 'glutamate', 'oxytocin', 'vasopressin',
  'endorphin', 'substanceP', 'npy', 'adenosine', 'anandamide',
  'twoAG', 'nitricOxide', 'bdnf', 'ngf', 'cortisol', 'testosterone',
];

const CROSSTALK_66: [number, number, number, number][] = [
  // DA interactions
  [0, 1, 0.3, 1],   // DA → SER (reward → mood)
  [0, 11, 0.2, -1], // DA ⊣ SubP (reward inhibits pain)
  [0, 17, 0.4, 1],  // DA → BDNF (reward → plasticity)
  // SER interactions
  [1, 0, 0.2, 1],   // SER → DA
  [1, 5, 0.3, 1],   // SER → GABA (mood → calm)
  [1, 19, 0.3, -1], // SER ⊣ CORT (mood buffers stress)
  // NE interactions
  [2, 3, 0.5, 1],   // NE → EPI (arousal → fight/flight)
  [2, 4, 0.3, 1],   // NE → ACh (arousal → attention)
  [2, 13, 0.2, -1], // NE ⊣ ADO (arousal inhibits sleep)
  // EPI interactions
  [3, 2, 0.4, 1],   // EPI → NE (reciprocal)
  [3, 19, 0.5, 1],  // EPI → CORT (stress hormone)
  [3, 7, 0.3, 1],   // EPI → GLU (excitation)
  // ACh interactions
  [4, 17, 0.5, 1],  // ACh → BDNF (learning → plasticity)
  [4, 7, 0.3, 1],   // ACh → GLU (attention → excitation)
  [4, 13, 0.2, -1], // ACh ⊣ ADO (attention vs sleep)
  // GABA interactions
  [5, 7, 0.6, -1],  // GABA ⊣ GLU (inhibition vs excitation)
  [5, 19, 0.3, -1], // GABA ⊣ CORT (calm buffers stress)
  [5, 13, 0.2, 1],  // GABA → ADO (calm → sleep pressure)
  // GLY interactions
  [6, 7, 0.4, -1],  // GLY ⊣ GLU (motor inhibition)
  [6, 5, 0.2, 1],   // GLY → GABA (synergistic)
  // GLU interactions
  [7, 17, 0.5, 1],  // GLU → BDNF (excitation → growth)
  [7, 4, 0.3, 1],   // GLU → ACh (reciprocal)
  [7, 5, 0.3, -1],  // GLU ⊣ GABA (reciprocal inhibition)
  // OXT interactions
  [8, 1, 0.4, 1],   // OXT → SER (bonding → mood)
  [8, 19, 0.4, -1], // OXT ⊣ CORT (bonding buffers stress)
  [8, 0, 0.2, 1],   // OXT → DA (social reward)
  // VP interactions
  [9, 8, 0.3, 1],   // VP → OXT (vasopressin synergy)
  [9, 2, 0.2, 1],   // VP → NE (social vigilance)
  // END interactions
  [10, 11, 0.6, -1], // END ⊣ SubP (endorphin blocks pain)
  [10, 0, 0.3, 1],   // END → DA (endorphin reward)
  [10, 1, 0.2, 1],   // END → SER (mood)
  // SubP interactions
  [11, 10, 0.2, -1], // SubP ⊣ END (pain vs relief)
  [11, 19, 0.3, 1],  // SubP → CORT (pain → stress)
  // NPY interactions
  [12, 19, 0.4, -1], // NPY ⊣ CORT (stress buffer)
  [12, 5, 0.2, 1],   // NPY → GABA (calming)
  // ADO interactions
  [13, 2, 0.5, -1],  // ADO ⊣ NE (sleep vs arousal)
  [13, 4, 0.3, -1],  // ADO ⊣ ACh (sleep vs attention)
  [13, 5, 0.3, 1],   // ADO → GABA (sleep synergy)
  // ANA interactions
  [14, 0, 0.3, 1],   // ANA → DA (bliss → reward)
  [14, 1, 0.4, 1],   // ANA → SER (bliss → mood)
  [14, 17, 0.3, 1],  // ANA → BDNF (creativity → growth)
  // 2-AG interactions
  [15, 14, 0.3, 1],  // 2-AG → ANA (endocannabinoid synergy)
  [15, 5, 0.2, 1],   // 2-AG → GABA (relaxation)
  [15, 10, 0.2, 1],  // 2-AG → END (pain relief)
  // NO interactions
  [16, 7, 0.3, 1],   // NO → GLU (signaling)
  [16, 0, 0.2, 1],   // NO → DA (vasodilation → reward)
  // BDNF interactions
  [17, 18, 0.5, 1],  // BDNF → NGF (neurotrophin synergy)
  [17, 7, 0.3, 1],   // BDNF → GLU (plasticity → excitation)
  [17, 4, 0.2, 1],   // BDNF → ACh (growth → learning)
  // NGF interactions
  [18, 17, 0.4, 1],  // NGF → BDNF (reciprocal)
  [18, 4, 0.2, 1],   // NGF → ACh (survival → learning)
  // CORT interactions
  [19, 1, 0.5, -1],  // CORT ⊣ SER (stress vs mood)
  [19, 5, 0.3, -1],  // CORT ⊣ GABA (stress vs calm)
  [19, 17, 0.4, -1], // CORT ⊣ BDNF (chronic stress inhibits growth)
  [19, 2, 0.3, 1],   // CORT → NE (stress → arousal)
  // TEST interactions
  [20, 0, 0.3, 1],   // TEST → DA (dominance → reward)
  [20, 2, 0.2, 1],   // TEST → NE (drive → arousal)
  [20, 19, 0.2, -1], // TEST ⊣ CORT (resilience)
  // Additional cross-system interactions
  [0, 8, 0.2, 1],    // DA → OXT (reward → bonding)
  [1, 14, 0.3, 1],   // SER → ANA (mood → bliss)
  [4, 0, 0.2, 1],    // ACh → DA (learning → reward)
  [7, 2, 0.2, 1],    // GLU → NE (excitation → arousal)
  [10, 8, 0.2, 1],   // END → OXT (relief → bonding)
  [17, 1, 0.2, 1],   // BDNF → SER (growth → mood)
];

// ═══════════════════════════════════════════════════════════════════════════════
// DRIVE QUARTET — Homeostatic motivational circuits
// ═══════════════════════════════════════════════════════════════════════════════
interface DriveState {
  hunger:     number;  // [0,1] 0=sated, 1=starving
  thirst:     number;  // [0,1] 0=hydrated, 1=dehydrated
  libido:     number;  // [0,1] reproductive drive
  aggression: number;  // [0,1] defensive/territorial drive
}

const DRIVE_BASELINES = { hunger: 0.3, thirst: 0.25, libido: 0.4, aggression: 0.2 };

function initDrives(): DriveState {
  return { ...DRIVE_BASELINES };
}

function tickDrives(prev: DriveState, neuro: NeurochemFull, dt: number): DriveState {
  // Hunger: increases over time, NPY promotes, leptin (not modeled) would inhibit
  const hungerDelta = 0.002 - neuro.npy * 0.001;
  const hunger = clamp(prev.hunger + hungerDelta * dt, 0, 1);

  // Thirst: increases over time, vasopressin modulates
  const thirstDelta = 0.0015 + neuro.vasopressin * 0.0005;
  const thirst = clamp(prev.thirst + thirstDelta * dt, 0, 1);

  // Libido: driven by testosterone, modulated by oxytocin
  const libidoTarget = neuro.testosterone * 0.6 + neuro.oxytocin * 0.3;
  const libido = clamp(prev.libido + (libidoTarget - prev.libido) * 0.05 * dt, 0, 1);

  // Aggression: driven by testosterone + cortisol, inhibited by serotonin + oxytocin
  const aggrTarget = (neuro.testosterone * 0.4 + neuro.cortisol * 0.3) 
                   - (neuro.serotonin * 0.3 + neuro.oxytocin * 0.2);
  const aggression = clamp(prev.aggression + (aggrTarget - prev.aggression) * 0.08 * dt, 0, 1);

  return { hunger, thirst, libido, aggression };
}

// ═══════════════════════════════════════════════════════════════════════════════
// AEGIS IMMUNE SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════
interface AegisState {
  threatLevel:   number;  // [0,1] detected threat
  neResponse:    number;  // NE surge magnitude
  epiResponse:   number;  // EPI surge magnitude
  immuneActive:  boolean;
  lastThreatBeat: number;
}

function initAegis(): AegisState {
  return { threatLevel: 0, neResponse: 0, epiResponse: 0, immuneActive: false, lastThreatBeat: 0 };
}

function tickAegis(
  prev: AegisState,
  externalThreat: number,
  cortisol: number,
  beat: number
): AegisState {
  // Threat accumulation: external + cortisol signal
  const threatLevel = clamp(externalThreat * 0.7 + cortisol * 0.3, 0, 1);
  const immuneActive = threatLevel > 0.4;

  // NE/EPI surge when threat detected
  const neResponse  = immuneActive ? clamp(threatLevel * 1.5, 0, 1) : prev.neResponse * 0.95;
  const epiResponse = immuneActive ? clamp(threatLevel * 1.2, 0, 1) : prev.epiResponse * 0.90;

  const lastThreatBeat = immuneActive ? beat : prev.lastThreatBeat;

  return { threatLevel, neResponse, epiResponse, immuneActive, lastThreatBeat };
}

// ═══════════════════════════════════════════════════════════════════════════════
// OLFACTORY LIMBIC PATHWAY
// Direct-to-amygdala injection bypassing thalamus (like real olfactory pathway)
// ═══════════════════════════════════════════════════════════════════════════════
interface OlfactoryState {
  signal:       number;  // current olfactory input [0,1]
  limbicInjection: number; // direct amygdala/hippocampus injection
  emotionalValence: number; // positive/negative [-1,1]
  memoryTag:    boolean;   // strong memory encoding flag
}

function initOlfactory(): OlfactoryState {
  return { signal: 0, limbicInjection: 0, emotionalValence: 0, memoryTag: false };
}

function tickOlfactory(
  prev: OlfactoryState,
  externalOlfactory: number,
  neuro: NeurochemFull
): OlfactoryState {
  const signal = clamp(externalOlfactory, 0, 1);
  
  // Direct limbic injection proportional to signal strength
  const limbicInjection = signal * 0.8;
  
  // Emotional valence: DA/SER positive, CORT/SubP negative
  const emotionalValence = clamp(
    (neuro.dopamine * 0.4 + neuro.serotonin * 0.3) 
    - (neuro.cortisol * 0.4 + neuro.substanceP * 0.2),
    -1, 1
  );
  
  // Memory tag if signal strong + high ACh (attention) + BDNF (plasticity)
  const memoryTag = signal > 0.6 && neuro.acetylcholine > 0.5 && neuro.bdnf > 0.5;

  return { signal, limbicInjection, emotionalValence, memoryTag };
}

// ═══════════════════════════════════════════════════════════════════════════════
// PAC SYNCHRONY DRIVE MODULATION
// Phase-Amplitude Coupling modulates drive strength based on hierarchy sync
// ═══════════════════════════════════════════════════════════════════════════════
interface PACDriveState {
  kfHz:          number;  // hierarchy synchrony [0,1]
  driveBoost:    number;  // multiplicative boost to drives
  coherenceGate: number;  // gates action execution
}

function initPACDrive(): PACDriveState {
  return { kfHz: 0, driveBoost: 1.0, coherenceGate: 0.5 };
}

function tickPACDrive(kfHz: number): PACDriveState {
  // Drive boost: higher sync = stronger drive expression
  const driveBoost = 1.0 + kfHz * 0.5;
  
  // Coherence gate: only execute drives when sufficiently synchronized
  const coherenceGate = kfHz;
  
  return { kfHz, driveBoost, coherenceGate };
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN LAB STATE
// ═══════════════════════════════════════════════════════════════════════════════
interface LabState {
  beat:       number;
  neuro:      NeurochemFull;
  metals:     MetalState;
  drives:     DriveState;
  aegis:      AegisState;
  olfactory:  OlfactoryState;
  pacDrive:   PACDriveState;
  vitality:   number;
  neuroplast: number;
  alloLoad:   number;
  crosstalkHistory: number[][];  // 21×21 interaction strength matrix over time
}

function initLabState(): LabState {
  return {
    beat: 0,
    neuro: { ...NEURO_BASELINES },
    metals: { ...METAL_BASELINES },
    drives: initDrives(),
    aegis: initAegis(),
    olfactory: initOlfactory(),
    pacDrive: initPACDrive(),
    vitality: 0.5,
    neuroplast: 0.005,
    alloLoad: 0.3,
    crosstalkHistory: [],
  };
}

function tick(prev: LabState): LabState {
  const beat = prev.beat + 1;

  // External inputs (simulated)
  const externalThreat = Math.sin(beat * 0.02) * 0.3 + 0.3;
  const externalOlfactory = Math.sin(beat * 0.05 + 1.5) * 0.4 + 0.5;
  const kfHzSimulated = 0.4 + Math.sin(beat * 0.01) * 0.3 + (beat > 200 ? 0.2 : 0);

  // 1. PAC DRIVE
  const pacDrive = tickPACDrive(kfHzSimulated);

  // 2. AEGIS IMMUNE SYSTEM
  const aegis = tickAegis(prev.aegis, externalThreat, prev.neuro.cortisol, beat);

  // 3. OLFACTORY PATHWAY
  const olfactory = tickOlfactory(prev.olfactory, externalOlfactory, prev.neuro);

  // 4. NEUROCHEMISTRY BASE STIMULI
  const baseStim: NeurochemStimuli = {
    reward:   clamp(pacDrive.kfHz * 0.6 + olfactory.emotionalValence * 0.4, 0, 1),
    threat:   clamp(aegis.threatLevel + externalThreat * 0.3, 0, 1),
    social:   clamp(prev.neuro.oxytocin * 0.5 + prev.neuro.serotonin * 0.3, 0, 1),
    learning: clamp(olfactory.memoryTag ? 0.8 : prev.neuro.acetylcholine * 0.5, 0, 1),
    arousal:  clamp(aegis.neResponse + prev.drives.hunger * 0.3, 0, 1),
    flow:     clamp(pacDrive.kfHz > 0.7 ? pacDrive.kfHz : 0, 0, 1),
    pain:     clamp(prev.neuro.substanceP * 0.6, 0, 1),
    fatigue:  clamp(prev.neuro.adenosine * 0.7, 0, 1),
  };

  // 5. CROSSTALK MODULATION
  // Apply 66-pair crosstalk: for each pair, modulate target based on source level
  let neuro = neurochemFullStep(prev.neuro, baseStim, NEURO_DT);
  const neuroArray = Object.values(neuro);
  const crosstalkMatrix: number[][] = Array.from({ length: 21 }, () => new Array(21).fill(0));
  
  CROSSTALK_66.forEach(([srcIdx, tgtIdx, weight, sign]) => {
    const srcLevel = neuroArray[srcIdx] ?? 0.5;
    const modulation = srcLevel * weight * sign * 0.01; // small modulation per tick
    const tgtName = NT_NAMES[tgtIdx];
    if (tgtName && tgtName in neuro) {
      (neuro as any)[tgtName] = clamp((neuro as any)[tgtName] + modulation, 0.01, 2.0);
    }
    crosstalkMatrix[srcIdx][tgtIdx] = Math.abs(srcLevel * weight);
  });

  // 6. AEGIS NE/EPI INJECTION
  if (aegis.immuneActive) {
    neuro.norepinephrine = clamp(neuro.norepinephrine + aegis.neResponse * 0.05, 0, 2);
    neuro.epinephrine = clamp(neuro.epinephrine + aegis.epiResponse * 0.05, 0, 2);
  }

  // 7. OLFACTORY LIMBIC INJECTION
  if (olfactory.limbicInjection > 0.3) {
    // Direct amygdala activation: boost DA, OXT, or CORT depending on valence
    if (olfactory.emotionalValence > 0) {
      neuro.dopamine = clamp(neuro.dopamine + olfactory.limbicInjection * 0.03, 0, 2);
      neuro.oxytocin = clamp(neuro.oxytocin + olfactory.limbicInjection * 0.02, 0, 2);
    } else {
      neuro.cortisol = clamp(neuro.cortisol + olfactory.limbicInjection * 0.04, 0, 2);
    }
  }

  // 8. METAL PIPELINE
  const metals = metalPipelineStep(prev.metals, NEURO_DT);

  // 9. DRIVES
  const drives = tickDrives(prev.drives, neuro, NEURO_DT);

  // 10. METRICS
  const vitality = vitalityScore(neuro);
  const neuroplast = neuroplasticityFactor(neuro);
  const alloLoad = allostaticLoad(neuro);

  // 11. HISTORY
  const crosstalkHistory = [...prev.crosstalkHistory.slice(-99), crosstalkMatrix.flat()];

  return {
    beat, neuro, metals, drives, aegis, olfactory, pacDrive,
    vitality, neuroplast, alloLoad, crosstalkHistory,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS DRAWERS
// ═══════════════════════════════════════════════════════════════════════════════

function drawNeurotransmitters(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const N = NT_NAMES.length;
  const barW = (W - 20) / N;
  const maxH = H - 40;
  
  Object.entries(s.neuro).forEach(([name, val], i) => {
    const x = 10 + i * barW;
    const barH = clamp(val, 0, 2) / 2 * maxH;
    const baseline = NEURO_BASELINES[name as keyof NeurochemFull] ?? 0.5;
    const isElevated = val > baseline * 1.2;
    const isDepressed = val < baseline * 0.8;
    
    let color = CYAN;
    if (isElevated) color = GREEN;
    else if (isDepressed) color = RED;
    
    ctx.fillStyle = color;
    ctx.globalAlpha = 0.7;
    ctx.fillRect(x, H - 20 - barH, barW - 2, barH);
    ctx.globalAlpha = 1;
    
    // Baseline line
    const baseY = H - 20 - (baseline / 2 * maxH);
    ctx.strokeStyle = MUTED;
    ctx.lineWidth = 0.5;
    ctx.beginPath();
    ctx.moveTo(x, baseY);
    ctx.lineTo(x + barW - 2, baseY);
    ctx.stroke();
    
    // Label
    ctx.fillStyle = WHITE;
    ctx.font = '8px monospace';
    ctx.save();
    ctx.translate(x + barW / 2, H - 4);
    ctx.rotate(-Math.PI / 4);
    ctx.textAlign = 'right';
    ctx.fillText(name.slice(0, 4), 0, 0);
    ctx.restore();
  });
  
  ctx.fillStyle = MUTED;
  ctx.font = '9px monospace';
  ctx.textAlign = 'left';
  ctx.fillText('21-Species Neurochemistry (baseline=gray line)', 4, 12);
}

function drawCrosstalkMatrix(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const N = 21;
  const cellW = (W - 40) / N;
  const cellH = (H - 40) / N;
  
  if (s.crosstalkHistory.length === 0) return;
  const latest = s.crosstalkHistory[s.crosstalkHistory.length - 1];
  
  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      const strength = latest[i * N + j] ?? 0;
      const intensity = Math.min(strength * 3, 1);
      const r = Math.round(intensity * 212);
      const g = Math.round(intensity * 150);
      const b = Math.round(255 - intensity * 100);
      ctx.fillStyle = `rgb(${r},${g},${b})`;
      ctx.fillRect(20 + j * cellW, 20 + i * cellH, cellW - 0.5, cellH - 0.5);
    }
  }
  
  ctx.fillStyle = MUTED;
  ctx.font = '9px monospace';
  ctx.textAlign = 'left';
  ctx.fillText('66-Pair Crosstalk Matrix (21×21)', 4, 12);
}

function drawDrivesQuartet(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const drives = [
    { name: 'HUNGER',     val: s.drives.hunger,     color: ORANGE },
    { name: 'THIRST',     val: s.drives.thirst,     color: CYAN   },
    { name: 'LIBIDO',     val: s.drives.libido,     color: PINK   },
    { name: 'AGGRESSION', val: s.drives.aggression, color: RED    },
  ];
  
  const barW = (W - 40) / 4;
  drives.forEach((d, i) => {
    const x = 20 + i * barW;
    const barH = d.val * (H - 50);
    ctx.fillStyle = d.color;
    ctx.globalAlpha = 0.7;
    ctx.fillRect(x, H - 30 - barH, barW - 4, barH);
    ctx.globalAlpha = 1;
    
    ctx.fillStyle = WHITE;
    ctx.font = '10px monospace';
    ctx.textAlign = 'center';
    ctx.fillText(d.name, x + barW / 2, H - 12);
    ctx.fillText(d.val.toFixed(2), x + barW / 2, H - 2);
  });
  
  ctx.fillStyle = MUTED;
  ctx.font = '9px monospace';
  ctx.textAlign = 'left';
  ctx.fillText('Drive Quartet (Homeostatic Motivations)', 4, 12);
}

function drawAegisImmune(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  // Threat level arc
  const cx = W / 2, cy = H / 2;
  const R = Math.min(W, H) * 0.35;
  
  ctx.strokeStyle = s.aegis.immuneActive ? RED : MUTED;
  ctx.lineWidth = 8;
  ctx.globalAlpha = 0.3;
  ctx.beginPath();
  ctx.arc(cx, cy, R, 0, TAU);
  ctx.stroke();
  ctx.globalAlpha = 1;
  
  // Threat arc
  ctx.strokeStyle = RED;
  ctx.lineWidth = 12;
  ctx.globalAlpha = 0.8;
  ctx.beginPath();
  ctx.arc(cx, cy, R, -PI / 2, -PI / 2 + s.aegis.threatLevel * TAU);
  ctx.stroke();
  ctx.globalAlpha = 1;
  
  // NE/EPI bars
  const barY = cy + R + 20;
  const barW = 60;
  
  ctx.fillStyle = ORANGE;
  ctx.globalAlpha = 0.7;
  ctx.fillRect(cx - barW - 10, barY, barW, s.aegis.neResponse * 40);
  ctx.globalAlpha = 1;
  ctx.fillStyle = WHITE;
  ctx.font = '10px monospace';
  ctx.textAlign = 'center';
  ctx.fillText('NE', cx - barW / 2 - 10, barY + 50);
  
  ctx.fillStyle = RED;
  ctx.globalAlpha = 0.7;
  ctx.fillRect(cx + 10, barY, barW, s.aegis.epiResponse * 40);
  ctx.globalAlpha = 1;
  ctx.fillStyle = WHITE;
  ctx.fillText('EPI', cx + barW / 2 + 10, barY + 50);
  
  // Center text
  ctx.fillStyle = s.aegis.immuneActive ? RED : MUTED;
  ctx.font = 'bold 14px monospace';
  ctx.textAlign = 'center';
  ctx.fillText(s.aegis.immuneActive ? 'ACTIVE' : 'DORMANT', cx, cy - 6);
  ctx.font = '11px monospace';
  ctx.fillStyle = WHITE;
  ctx.fillText(`Threat: ${s.aegis.threatLevel.toFixed(2)}`, cx, cy + 10);
  
  ctx.fillStyle = MUTED;
  ctx.font = '9px monospace';
  ctx.textAlign = 'left';
  ctx.fillText('AEGIS Immune System', 4, 12);
}

function drawOlfactoryLimbic(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const cx = W / 2, cy = H / 2;
  
  // Olfactory signal wave
  ctx.strokeStyle = PURPLE;
  ctx.lineWidth = 2;
  ctx.globalAlpha = 0.8;
  ctx.beginPath();
  for (let x = 0; x < W; x += 2) {
    const phase = (x / W) * TAU * 3 + s.beat * 0.1;
    const amp = s.olfactory.signal * 30;
    const y = cy + Math.sin(phase) * amp;
    x === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
  }
  ctx.stroke();
  ctx.globalAlpha = 1;
  
  // Limbic injection indicator
  const injSize = s.olfactory.limbicInjection * 40 + 10;
  ctx.fillStyle = s.olfactory.emotionalValence > 0 ? GREEN : RED;
  ctx.globalAlpha = 0.6;
  ctx.beginPath();
  ctx.arc(cx, cy, injSize, 0, TAU);
  ctx.fill();
  ctx.globalAlpha = 1;
  
  // Memory tag
  if (s.olfactory.memoryTag) {
    ctx.strokeStyle = GOLD;
    ctx.lineWidth = 3;
    ctx.globalAlpha = 0.7;
    ctx.beginPath();
    ctx.arc(cx, cy, injSize + 8, 0, TAU);
    ctx.stroke();
    ctx.globalAlpha = 1;
    ctx.fillStyle = GOLD;
    ctx.font = 'bold 10px monospace';
    ctx.textAlign = 'center';
    ctx.fillText('⬡ MEMORY TAG', cx, cy - injSize - 15);
  }
  
  ctx.fillStyle = WHITE;
  ctx.font = '11px monospace';
  ctx.textAlign = 'center';
  ctx.fillText(`Signal: ${s.olfactory.signal.toFixed(2)}`, cx, cy - 8);
  ctx.fillText(`Valence: ${s.olfactory.emotionalValence.toFixed(2)}`, cx, cy + 6);
  
  ctx.fillStyle = MUTED;
  ctx.font = '9px monospace';
  ctx.textAlign = 'left';
  ctx.fillText('Olfactory → Limbic (Thalamic Bypass)', 4, 12);
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROPS & COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════
interface NeuroCogLabProps {
  organism?: { r?: number; beat?: number; [key: string]: unknown };
}

export function NeuroCogLab({ organism: _organism }: NeuroCogLabProps) {
  const ntRef        = useRef<HTMLCanvasElement>(null);
  const crosstalkRef = useRef<HTMLCanvasElement>(null);
  const drivesRef    = useRef<HTMLCanvasElement>(null);
  const aegisRef     = useRef<HTMLCanvasElement>(null);
  const olfactoryRef = useRef<HTMLCanvasElement>(null);

  const simRef = useRef<LabState>(initLabState());
  const tickCnt = useRef(0);
  const frameRef = useRef<number>(0);
  const [ui, setUi] = useState<LabState>(simRef.current);

  const animate = useCallback(() => {
    simRef.current = tick(simRef.current);
    tickCnt.current++;
    
    if (ntRef.current)        drawNeurotransmitters(ntRef.current, simRef.current);
    if (crosstalkRef.current) drawCrosstalkMatrix(crosstalkRef.current, simRef.current);
    if (drivesRef.current)    drawDrivesQuartet(drivesRef.current, simRef.current);
    if (aegisRef.current)     drawAegisImmune(aegisRef.current, simRef.current);
    if (olfactoryRef.current) drawOlfactoryLimbic(olfactoryRef.current, simRef.current);
    
    if (tickCnt.current % 8 === 0) setUi({ ...simRef.current });
    frameRef.current = requestAnimationFrame(animate);
  }, []);

  useEffect(() => {
    frameRef.current = requestAnimationFrame(animate);
    return () => cancelAnimationFrame(frameRef.current);
  }, [animate]);

  useEffect(() => {
    const refs = [ntRef, crosstalkRef, drivesRef, aegisRef, olfactoryRef];
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

  const metalCoh = metalCoherenceContribution(ui.metals);
  const fourSpecies = projectTo4Species(ui.neuro);

  const S = {
    root: { width:'100%', height:'100%', background:BG, display:'grid', gridTemplateRows:'auto 1fr auto', fontFamily:'monospace', overflow:'hidden' } as React.CSSProperties,
    header: { background:BG2, borderBottom:`1px solid ${BORDER}`, padding:'8px 16px', display:'flex', alignItems:'center', gap:16, flexWrap:'wrap' as const },
    title: { fontSize:14, fontWeight:'bold', color:GOLD, letterSpacing:'0.12em' },
    stat: { display:'flex', flexDirection:'column' as const, alignItems:'center', minWidth:60 },
    statLabel: { fontSize:9, color:MUTED, textTransform:'uppercase' as const },
    statVal: (c:string) => ({ fontSize:12, color:c, fontWeight:'bold' }),
    grid: { display:'grid', gridTemplateColumns:'2fr 1fr', gridTemplateRows:'1fr 1fr 1fr', gap:2, padding:2, overflow:'hidden' },
    cell: { position:'relative' as const, background:BG, overflow:'hidden' },
    canvas: { width:'100%', height:'100%', display:'block' },
    label: { position:'absolute' as const, top:3, left:5, fontSize:8, color:MUTED, pointerEvents:'none' as const, zIndex:1 },
    bottom: { background:BG2, borderTop:`1px solid ${BORDER}`, padding:'6px 12px', display:'flex', gap:16, fontSize:9, color:WHITE, fontFamily:'monospace', overflowX:'auto' as const },
    eqSec: (c:string) => ({ borderLeft:`2px solid ${c}`, paddingLeft:8, minWidth:200 }),
    eqTitle: (c:string) => ({ color:c, fontWeight:'bold', marginBottom:2 }),
  };

  return (
    <div style={S.root}>
      <header style={S.header}>
        <div style={S.title}>⬡ NOVA · NEUROCOG LAB</div>
        {[
          { label:'Beat',       val:String(ui.beat),               color:CYAN   },
          { label:'DA',         val:ui.neuro.dopamine.toFixed(2),  color:GREEN  },
          { label:'SER',        val:ui.neuro.serotonin.toFixed(2), color:PURPLE },
          { label:'CORT',       val:ui.neuro.cortisol.toFixed(2),  color:RED    },
          { label:'BDNF',       val:ui.neuro.bdnf.toFixed(2),      color:GOLD   },
          { label:'Vitality',   val:ui.vitality.toFixed(3),        color:GREEN  },
          { label:'Neuroplast', val:(ui.neuroplast*100).toFixed(1),color:CYAN   },
          { label:'AlloLoad',   val:ui.alloLoad.toFixed(3),        color:ORANGE },
          { label:'Metal Coh',  val:metalCoh.toFixed(3),           color:GOLD   },
          { label:'AEGIS',      val:ui.aegis.immuneActive?'ON':'OFF', color:ui.aegis.immuneActive?RED:MUTED },
        ].map(({ label, val, color }) => (
          <div key={label} style={S.stat}>
            <span style={S.statLabel}>{label}</span>
            <span style={S.statVal(color)}>{val}</span>
          </div>
        ))}
      </header>

      <div style={S.grid}>
        <div style={{...S.cell, gridRow:'1/3'}}>
          <canvas ref={ntRef} style={S.canvas} />
        </div>
        <div style={S.cell}>
          <canvas ref={crosstalkRef} style={S.canvas} />
        </div>
        <div style={S.cell}>
          <canvas ref={drivesRef} style={S.canvas} />
        </div>
        <div style={S.cell}>
          <canvas ref={aegisRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'1/-1'}}>
          <canvas ref={olfactoryRef} style={S.canvas} />
        </div>
      </div>

      <div style={S.bottom}>
        <div style={S.eqSec(CYAN)}>
          <div style={S.eqTitle(CYAN)}>21-SPECIES MICHAELIS-MENTEN</div>
          <div>dC/dt = P·stim·(1−C/Cmax) − λ·(C−Cbase)</div>
          <div>λ = ln(2)/t½   [decay from half-life]</div>
        </div>
        <div style={S.eqSec(PURPLE)}>
          <div style={S.eqTitle(PURPLE)}>66-PAIR CROSSTALK</div>
          <div>[src,tgt,w,sign]  tgt += src·w·sign·Δt</div>
          <div>Facilitation(+) / Inhibition(−)</div>
        </div>
        <div style={S.eqSec(ORANGE)}>
          <div style={S.eqTitle(ORANGE)}>DRIVE QUARTET</div>
          <div>Hunger, Thirst, Libido, Aggression</div>
          <div>Homeostatic regulation + PAC boost</div>
        </div>
        <div style={S.eqSec(RED)}>
          <div style={S.eqTitle(RED)}>AEGIS IMMUNE</div>
          <div>Threat → NE/EPI surge</div>
          <div>Active when threat{'>'} 0.4</div>
        </div>
        <div style={S.eqSec(GOLD)}>
          <div style={S.eqTitle(GOLD)}>OLFACTORY LIMBIC</div>
          <div>Signal → Amygdala (thalamic bypass)</div>
          <div>Memory tag: signal∧ACh∧BDNF</div>
        </div>
        <div style={S.eqSec(GREEN)}>
          <div style={S.eqTitle(GREEN)}>METAL PIPELINE</div>
          <div>Au={ui.metals.gold.toFixed(3)} Ag={ui.metals.silver.toFixed(3)} Pt={ui.metals.platinum.toFixed(3)}</div>
          <div>Coherence contrib={metalCoh.toFixed(4)}</div>
        </div>
        <div style={S.eqSec(PINK)}>
          <div style={S.eqTitle(PINK)}>4-SPECIES PROJECTION</div>
          <div>DA={fourSpecies.dopamine.toFixed(2)} C={fourSpecies.cortisol.toFixed(2)}</div>
          <div>NE={fourSpecies.norepinephrine.toFixed(2)} OXT={fourSpecies.oxytocin.toFixed(2)}</div>
        </div>
      </div>
    </div>
  );
}

export default NeuroCogLab;
