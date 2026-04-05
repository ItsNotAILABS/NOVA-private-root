// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: organism-wiring.ts — The Organism's Central Nervous System Integration
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// THIS IS THE WIRING LAYER THAT CONNECTS ALL LABS INTO ONE ORGANISM
//
// Architecture:
//   NeuroCogLab (neurochemistry) → EmergenceLab (coherence) → MathPhysicsLab (physics)
//          ↑                              ↓                          ↓
//          └──────────────────────────────┴──────────────────────────┘
//                                    FEEDBACK LOOP
//
// Every beat:
//   1. Neurochemistry produces NT levels (DA, SER, NE, CORT, etc.)
//   2. NT levels modulate EmergenceLab coherence (r, kf, emergence)
//   3. Emergence modulates physics (Ising temperature, Lorenz parameters)
//   4. Physics feeds back into neurochemistry (stress → cortisol, flow → dopamine)
//
// ═══════════════════════════════════════════════════════════════════════════════

import {
  NeurochemFull, NeurochemStimuli, NEURO_BASELINES,
  neurochemFullStep, vitalityScore, neuroplasticityFactor, allostaticLoad,
  MetalState, METAL_BASELINES, metalCoherenceContribution,
} from './neurochemistry';

import {
  GenesisState, genesisTick, genesisInit, BreathRhythm,
} from './genesis';

import {
  kuramotoTick, KuramotoState, kuramotoInit,
} from './kuramoto';

import {
  lyapunovTick, LyapunovState, lyapunovInit,
} from './lyapunov';

import {
  quantumTick, QuantumState, quantumInit,
} from './quantum';

import {
  hzTick, HzState, hzInit, HzMode,
} from './hz-substrate';

import {
  clamp, sigmoid, tanh, PHI, PHI_INV, PI, TAU, NEURO_DT,
} from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// ORGANISM STATE — The unified state of the entire system
// ═══════════════════════════════════════════════════════════════════════════════

export interface OrganismState {
  // ── TIMING ──
  beat: number;
  dt: number;
  
  // ── CORE METRICS ──
  r: number;                    // Global coherence [0,1]
  kf: number;                   // Frequency coherence [0,1]
  emergence: number;            // Emergence score [0,1]
  vitality: number;             // Overall health [0,1]
  
  // ── NEUROCHEMISTRY ──
  neuro: NeurochemFull;
  metals: MetalState;
  allostaticLoad: number;
  neuroplasticity: number;
  
  // ── GENESIS ──
  genesis: GenesisState;
  breath: BreathRhythm;
  firstBreathSealed: boolean;
  
  // ── KURAMOTO ──
  kuramoto: KuramotoState;
  organCoherence: number[];     // Per-organ coherence (18 organs)
  
  // ── LYAPUNOV ──
  lyapunov: LyapunovState;
  stability: number;
  
  // ── QUANTUM ──
  quantum: QuantumState;
  entanglement: number;
  decoherence: number;
  
  // ── HZ SUBSTRATE ──
  hz: HzState;
  hzMode: HzMode;
  
  // ── DRIVES ──
  drives: {
    hunger: number;
    thirst: number;
    libido: number;
    aggression: number;
    curiosity: number;
    social: number;
    safety: number;
    achievement: number;
  };
  
  // ── IMMUNE ──
  immune: {
    threatLevel: number;
    neResponse: number;
    epiResponse: number;
    active: boolean;
    cytokines: number;
    inflammation: number;
  };
  
  // ── OLFACTORY ──
  olfactory: {
    signal: number;
    limbicInjection: number;
    emotionalValence: number;
    memoryTag: boolean;
    firstBreathOdor: number | null;
  };
  
  // ── CIRCADIAN ──
  circadian: {
    phase: number;              // [0, 2π]
    melatonin: number;
    cortisol: number;
    alertness: number;
  };
  
  // ── HISTORY ──
  history: {
    r: number[];
    kf: number[];
    emergence: number[];
    vitality: number[];
    neuro: number[][];          // [beat][ntIndex]
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// INITIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════

export function organismInit(): OrganismState {
  return {
    beat: 0,
    dt: NEURO_DT,
    r: 0.5,
    kf: 0.3,
    emergence: 0.1,
    vitality: 0.7,
    
    neuro: { ...NEURO_BASELINES },
    metals: { ...METAL_BASELINES },
    allostaticLoad: 0.3,
    neuroplasticity: 0.005,
    
    genesis: genesisInit(),
    breath: { depth: 0.5, rate: 12, variability: 0.1, phase: 0, inhaling: true },
    firstBreathSealed: false,
    
    kuramoto: kuramotoInit(18),
    organCoherence: new Array(18).fill(0.5),
    
    lyapunov: lyapunovInit(),
    stability: 0.7,
    
    quantum: quantumInit(),
    entanglement: 0.3,
    decoherence: 0.1,
    
    hz: hzInit(),
    hzMode: 'WAKE',
    
    drives: {
      hunger: 0.3,
      thirst: 0.25,
      libido: 0.4,
      aggression: 0.2,
      curiosity: 0.6,
      social: 0.5,
      safety: 0.7,
      achievement: 0.5,
    },
    
    immune: {
      threatLevel: 0.1,
      neResponse: 0.1,
      epiResponse: 0.1,
      active: false,
      cytokines: 0.1,
      inflammation: 0.1,
    },
    
    olfactory: {
      signal: 0,
      limbicInjection: 0,
      emotionalValence: 0,
      memoryTag: false,
      firstBreathOdor: null,
    },
    
    circadian: {
      phase: 0,
      melatonin: 0.2,
      cortisol: 0.4,
      alertness: 0.7,
    },
    
    history: {
      r: [],
      kf: [],
      emergence: [],
      vitality: [],
      neuro: [],
    },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// WIRING FUNCTIONS — How each system affects the others
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Neurochemistry → Emergence wiring
 * NT levels modulate coherence and emergence capacity
 */
function neuroToEmergence(neuro: NeurochemFull): { rMod: number; emergenceMod: number; kfMod: number } {
  // Dopamine promotes coherence (reward → synchrony)
  const daMod = (neuro.dopamine - NEURO_BASELINES.dopamine) * 0.3;
  
  // Serotonin promotes stability (mood → baseline)
  const serMod = (neuro.serotonin - NEURO_BASELINES.serotonin) * 0.2;
  
  // Cortisol reduces coherence (stress → desynchrony)
  const cortMod = -(neuro.cortisol - NEURO_BASELINES.cortisol) * 0.4;
  
  // Norepinephrine increases alertness → faster synchrony but more noise
  const neMod = (neuro.norepinephrine - NEURO_BASELINES.norepinephrine) * 0.15;
  
  // Acetylcholine promotes learning/plasticity → kf modulation
  const achMod = (neuro.acetylcholine - NEURO_BASELINES.acetylcholine) * 0.25;
  
  // BDNF promotes neuroplasticity → emergence capacity
  const bdnfMod = (neuro.bdnf - NEURO_BASELINES.bdnf) * 0.35;
  
  // Endorphins → flow state → enhanced kf
  const endMod = (neuro.endorphin - NEURO_BASELINES.endorphin) * 0.2;
  
  return {
    rMod: clamp(daMod + serMod + cortMod, -0.3, 0.3),
    emergenceMod: clamp(bdnfMod + daMod * 0.5 + achMod * 0.3, -0.2, 0.4),
    kfMod: clamp(achMod + endMod + neMod * 0.5, -0.2, 0.3),
  };
}

/**
 * Emergence → Neurochemistry wiring
 * Coherence and emergence states feedback into NT production
 */
function emergenceToNeuro(r: number, kf: number, emergence: number): NeurochemStimuli {
  // High coherence → reward → dopamine
  const reward = r > 0.7 ? (r - 0.7) * 2 : 0;
  
  // Low coherence → stress → cortisol pathway
  const threat = r < 0.3 ? (0.3 - r) * 2 : 0;
  
  // High kf → flow state → endorphins + dopamine
  const flow = kf > 0.8 ? (kf - 0.8) * 3 : 0;
  
  // Emergence → arousal (excitement/novelty)
  const arousal = emergence > 0.5 ? (emergence - 0.5) * 1.5 : 0;
  
  // Stable coherence → safety → oxytocin
  const social = r > 0.6 && r < 0.9 ? 0.5 : 0.2;
  
  // Learning from emergence
  const learning = emergence > 0.3 ? emergence * 0.8 : 0.1;
  
  return {
    reward: clamp(reward + flow * 0.5, 0, 1),
    threat: clamp(threat, 0, 1),
    social: clamp(social, 0, 1),
    learning: clamp(learning, 0, 1),
    arousal: clamp(arousal, 0, 1),
    flow: clamp(flow, 0, 1),
    pain: 0,
    fatigue: clamp(1 - r, 0, 0.5),
  };
}

/**
 * Physics → Neurochemistry wiring
 * Physical state (temperature, chaos, criticality) affects NT
 */
function physicsToNeuro(
  isingT: number,      // Ising temperature (criticality)
  lorenzChaos: number, // Lorenz divergence (chaos level)
  stability: number,   // Lyapunov stability
): Partial<NeurochemStimuli> {
  // Near critical point → heightened arousal
  const criticalDistance = Math.abs(isingT - 2.269);
  const nearCritical = criticalDistance < 0.5 ? 1 - criticalDistance * 2 : 0;
  
  // High chaos → stress response
  const chaosStress = lorenzChaos > 0.7 ? (lorenzChaos - 0.7) * 2 : 0;
  
  // Low stability → threat
  const instabilityThreat = stability < 0.4 ? (0.4 - stability) * 2 : 0;
  
  return {
    arousal: nearCritical * 0.5,
    threat: clamp(chaosStress + instabilityThreat, 0, 0.8),
    flow: nearCritical > 0.7 ? nearCritical - 0.7 : 0,
  };
}

/**
 * Neurochemistry → Physics wiring
 * NT levels modulate physical parameters
 */
function neuroToPhysics(neuro: NeurochemFull): {
  isingTMod: number;       // Temperature modulation
  lorenzRhoMod: number;    // Lorenz ρ modulation
  couplingMod: number;     // Kuramoto coupling modulation
} {
  // Cortisol → higher temperature (more disorder)
  const cortEffect = (neuro.cortisol - NEURO_BASELINES.cortisol) * 0.5;
  
  // Dopamine → increased coupling (more synchrony drive)
  const daEffect = (neuro.dopamine - NEURO_BASELINES.dopamine) * 0.3;
  
  // Norepinephrine → increased ρ (more chaos potential)
  const neEffect = (neuro.norepinephrine - NEURO_BASELINES.norepinephrine) * 2;
  
  // GABA → lower temperature (more order)
  const gabaEffect = -(neuro.gaba - NEURO_BASELINES.gaba) * 0.3;
  
  return {
    isingTMod: clamp(cortEffect + gabaEffect, -0.5, 0.5),
    lorenzRhoMod: clamp(neEffect, -3, 3),
    couplingMod: clamp(daEffect, -0.2, 0.3),
  };
}

/**
 * Drives → Neurochemistry wiring
 * Drive states produce specific NT profiles
 */
function drivesToNeuro(drives: OrganismState['drives']): Partial<NeurochemStimuli> {
  // Hunger → low energy, seeking behavior (DA anticipation)
  const hungerReward = drives.hunger > 0.6 ? drives.hunger * 0.3 : 0;
  
  // Thirst → stress if high
  const thirstThreat = drives.thirst > 0.7 ? (drives.thirst - 0.7) * 2 : 0;
  
  // Libido → arousal + reward anticipation
  const libidoArousal = drives.libido * 0.4;
  
  // Aggression → NE/EPI surge
  const aggressionThreat = drives.aggression > 0.5 ? drives.aggression * 0.5 : 0;
  
  // Curiosity → learning signal
  const curiosityLearning = drives.curiosity * 0.6;
  
  // Social → oxytocin pathway
  const socialSignal = drives.social * 0.5;
  
  return {
    reward: hungerReward + drives.achievement * 0.2,
    threat: thirstThreat + aggressionThreat,
    arousal: libidoArousal + drives.curiosity * 0.3,
    learning: curiosityLearning,
    social: socialSignal,
  };
}

/**
 * Neurochemistry → Drives wiring
 * NT levels modulate drive states
 */
function neuroToDrives(neuro: NeurochemFull, prevDrives: OrganismState['drives']): OrganismState['drives'] {
  const dt = NEURO_DT;
  
  // NPY promotes hunger
  const hungerDelta = 0.002 - neuro.npy * 0.001;
  
  // Vasopressin modulates thirst
  const thirstDelta = 0.0015 + neuro.vasopressin * 0.0005;
  
  // Testosterone drives libido
  const libidoTarget = neuro.testosterone * 0.6 + neuro.oxytocin * 0.3;
  
  // Testosterone + cortisol - (serotonin + oxytocin) = aggression
  const aggressionTarget = (neuro.testosterone * 0.4 + neuro.cortisol * 0.3)
    - (neuro.serotonin * 0.3 + neuro.oxytocin * 0.2);
  
  // Dopamine + acetylcholine = curiosity
  const curiosityTarget = neuro.dopamine * 0.4 + neuro.acetylcholine * 0.3;
  
  // Oxytocin = social drive
  const socialTarget = neuro.oxytocin * 0.6 + neuro.serotonin * 0.2;
  
  // Low cortisol = safety
  const safetyTarget = 1 - neuro.cortisol * 0.5;
  
  // Dopamine anticipation = achievement
  const achievementTarget = neuro.dopamine * 0.5;
  
  return {
    hunger: clamp(prevDrives.hunger + hungerDelta * dt, 0, 1),
    thirst: clamp(prevDrives.thirst + thirstDelta * dt, 0, 1),
    libido: clamp(prevDrives.libido + (libidoTarget - prevDrives.libido) * 0.05 * dt, 0, 1),
    aggression: clamp(prevDrives.aggression + (aggressionTarget - prevDrives.aggression) * 0.08 * dt, 0, 1),
    curiosity: clamp(prevDrives.curiosity + (curiosityTarget - prevDrives.curiosity) * 0.1 * dt, 0, 1),
    social: clamp(prevDrives.social + (socialTarget - prevDrives.social) * 0.05 * dt, 0, 1),
    safety: clamp(prevDrives.safety + (safetyTarget - prevDrives.safety) * 0.03 * dt, 0, 1),
    achievement: clamp(prevDrives.achievement + (achievementTarget - prevDrives.achievement) * 0.06 * dt, 0, 1),
  };
}

/**
 * Immune → Neurochemistry wiring
 * Immune activation produces sickness behavior via cytokines
 */
function immuneToNeuro(immune: OrganismState['immune']): Partial<NeurochemStimuli> {
  // Cytokines → fatigue, reduced reward sensitivity
  const fatigue = immune.cytokines * 0.8;
  const rewardReduction = -immune.inflammation * 0.3;
  
  // Threat response
  const threat = immune.threatLevel * 0.5;
  
  return {
    fatigue,
    threat,
    reward: rewardReduction,
  };
}

/**
 * Neurochemistry → Immune wiring
 * NT levels modulate immune function
 */
function neuroToImmune(neuro: NeurochemFull, prevImmune: OrganismState['immune']): OrganismState['immune'] {
  // Cortisol suppresses immune function
  const cortisol = neuro.cortisol;
  const immuneSuppression = cortisol > 0.6 ? (cortisol - 0.6) * 0.5 : 0;
  
  // Oxytocin reduces inflammation
  const oxtEffect = neuro.oxytocin * 0.2;
  
  // Norepinephrine/epinephrine modulate threat response
  const neResponse = neuro.norepinephrine * 0.8;
  const epiResponse = neuro.epinephrine * 0.7;
  
  const inflammation = clamp(prevImmune.inflammation * 0.98 - immuneSuppression - oxtEffect, 0, 1);
  const cytokines = clamp(prevImmune.cytokines * 0.95 + inflammation * 0.02, 0, 1);
  
  return {
    threatLevel: prevImmune.threatLevel * 0.95,
    neResponse,
    epiResponse,
    active: prevImmune.threatLevel > 0.4,
    cytokines,
    inflammation,
  };
}

/**
 * Olfactory → Neurochemistry wiring
 * Smells bypass thalamus → direct limbic activation
 */
function olfactoryToNeuro(olfactory: OrganismState['olfactory']): Partial<NeurochemStimuli> {
  if (olfactory.limbicInjection < 0.1) return {};
  
  // Direct emotional activation
  if (olfactory.emotionalValence > 0) {
    return {
      reward: olfactory.limbicInjection * 0.4,
      social: olfactory.limbicInjection * 0.2,
    };
  } else {
    return {
      threat: olfactory.limbicInjection * 0.5,
    };
  }
}

/**
 * Circadian → Neurochemistry wiring
 * Time of day modulates NT baselines
 */
function circadianToNeuro(circadian: OrganismState['circadian']): Partial<NeurochemStimuli> {
  // Morning → high cortisol, alertness
  // Evening → melatonin → fatigue
  return {
    arousal: circadian.alertness * 0.5,
    fatigue: circadian.melatonin * 0.4,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN TICK — The unified organism update
// ═══════════════════════════════════════════════════════════════════════════════

export function organismTick(prev: OrganismState): OrganismState {
  const beat = prev.beat + 1;
  const dt = NEURO_DT;
  
  // ── 1. COLLECT ALL NT STIMULI FROM SUBSYSTEMS ──
  const emergenceStim = emergenceToNeuro(prev.r, prev.kf, prev.emergence);
  const driveStim = drivesToNeuro(prev.drives);
  const immuneStim = immuneToNeuro(prev.immune);
  const olfactoryStim = olfactoryToNeuro(prev.olfactory);
  const circadianStim = circadianToNeuro(prev.circadian);
  
  // Combine all stimuli
  const combinedStim: NeurochemStimuli = {
    reward: clamp(
      (emergenceStim.reward || 0) + (driveStim.reward || 0) + 
      (olfactoryStim.reward || 0) + (immuneStim.reward || 0), 0, 1
    ),
    threat: clamp(
      (emergenceStim.threat || 0) + (driveStim.threat || 0) + 
      (olfactoryStim.threat || 0) + (immuneStim.threat || 0), 0, 1
    ),
    social: clamp(
      (emergenceStim.social || 0) + (driveStim.social || 0) + 
      (olfactoryStim.social || 0), 0, 1
    ),
    learning: clamp(
      (emergenceStim.learning || 0) + (driveStim.learning || 0), 0, 1
    ),
    arousal: clamp(
      (emergenceStim.arousal || 0) + (driveStim.arousal || 0) + 
      (circadianStim.arousal || 0), 0, 1
    ),
    flow: clamp(emergenceStim.flow || 0, 0, 1),
    pain: 0,
    fatigue: clamp(
      (emergenceStim.fatigue || 0) + (immuneStim.fatigue || 0) + 
      (circadianStim.fatigue || 0), 0, 1
    ),
  };
  
  // ── 2. UPDATE NEUROCHEMISTRY ──
  const neuro = neurochemFullStep(prev.neuro, combinedStim, dt);
  
  // ── 3. NEUROCHEMISTRY → EMERGENCE MODULATION ──
  const neuroEmergenceMod = neuroToEmergence(neuro);
  
  // ── 4. UPDATE GENESIS ──
  const genesis = genesisTick(prev.genesis, dt, prev.kf);
  
  // ── 5. UPDATE KURAMOTO WITH NT COUPLING MODULATION ──
  const physicsMod = neuroToPhysics(neuro);
  const kuramoto = kuramotoTick(prev.kuramoto, dt, 0.5 + physicsMod.couplingMod);
  
  // ── 6. UPDATE LYAPUNOV ──
  const lyapunov = lyapunovTick(prev.lyapunov, kuramoto.r, prev.kf, prev.emergence);
  
  // ── 7. UPDATE QUANTUM ──
  const quantum = quantumTick(prev.quantum, dt, kuramoto.r);
  
  // ── 8. UPDATE HZ ──
  const hz = hzTick(prev.hz, dt, kuramoto.r);
  
  // ── 9. COMPUTE GLOBAL COHERENCE ──
  const metalCoh = metalCoherenceContribution(prev.metals);
  const r = clamp(
    kuramoto.r * 0.4 + 
    genesis.kfHz * 0.3 + 
    quantum.coherence * 0.2 + 
    metalCoh * 0.1 +
    neuroEmergenceMod.rMod,
    0, 1
  );
  
  // ── 10. COMPUTE KF (FREQUENCY COHERENCE) ──
  const kf = clamp(
    hz.kf * 0.5 + 
    genesis.kfHz * 0.3 + 
    kuramoto.r * 0.2 +
    neuroEmergenceMod.kfMod,
    0, 1
  );
  
  // ── 11. COMPUTE EMERGENCE ──
  const emergence = clamp(
    sigmoid(PHI * (r - 0.5) * Math.sqrt(r * kf)) * 0.8 +
    neuroEmergenceMod.emergenceMod,
    0, 1
  );
  
  // ── 12. UPDATE DRIVES FROM NEUROCHEMISTRY ──
  const drives = neuroToDrives(neuro, prev.drives);
  
  // ── 13. UPDATE IMMUNE FROM NEUROCHEMISTRY ──
  const immune = neuroToImmune(neuro, prev.immune);
  
  // ── 14. UPDATE OLFACTORY ──
  const olfactory = {
    ...prev.olfactory,
    emotionalValence: clamp(
      (neuro.dopamine * 0.4 + neuro.serotonin * 0.3) -
      (neuro.cortisol * 0.4 + neuro.substanceP * 0.2),
      -1, 1
    ),
  };
  
  // ── 15. UPDATE CIRCADIAN ──
  const circadianPhase = (prev.circadian.phase + 0.0001 * dt) % TAU;
  const circadian = {
    phase: circadianPhase,
    melatonin: clamp(0.5 + 0.4 * Math.cos(circadianPhase + PI), 0, 1),
    cortisol: clamp(0.4 + 0.3 * Math.cos(circadianPhase), 0, 1),
    alertness: clamp(0.5 - 0.3 * Math.cos(circadianPhase), 0, 1),
  };
  
  // ── 16. COMPUTE DERIVED METRICS ──
  const vitality = vitalityScore(neuro);
  const neuroplasticity = neuroplasticityFactor(neuro);
  const alloLoad = allostaticLoad(neuro);
  const stability = lyapunov.stability;
  const entanglement = quantum.entanglement;
  const decoherence = quantum.decoherence;
  
  // ── 17. UPDATE HISTORY ──
  const history = {
    r: [...prev.history.r.slice(-499), r],
    kf: [...prev.history.kf.slice(-499), kf],
    emergence: [...prev.history.emergence.slice(-499), emergence],
    vitality: [...prev.history.vitality.slice(-499), vitality],
    neuro: [...prev.history.neuro.slice(-99), Object.values(neuro)],
  };
  
  return {
    beat,
    dt,
    r,
    kf,
    emergence,
    vitality,
    neuro,
    metals: prev.metals, // metals update separately
    allostaticLoad: alloLoad,
    neuroplasticity,
    genesis,
    breath: genesis.breath,
    firstBreathSealed: genesis.firstBreathSealed,
    kuramoto,
    organCoherence: kuramoto.phases.map((_, i) => 
      clamp(r + Math.sin(i * 0.5) * 0.1, 0, 1)
    ),
    lyapunov,
    stability,
    quantum,
    entanglement,
    decoherence,
    hz,
    hzMode: hz.mode,
    drives,
    immune,
    olfactory,
    circadian,
    history,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXTERNAL STIMULUS APPLICATION
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Apply external threat stimulus (e.g., predator detected)
 */
export function applyThreat(state: OrganismState, intensity: number): OrganismState {
  return {
    ...state,
    immune: {
      ...state.immune,
      threatLevel: clamp(state.immune.threatLevel + intensity, 0, 1),
      active: intensity > 0.3,
    },
  };
}

/**
 * Apply external reward stimulus (e.g., food found)
 */
export function applyReward(state: OrganismState, intensity: number): OrganismState {
  return {
    ...state,
    neuro: {
      ...state.neuro,
      dopamine: clamp(state.neuro.dopamine + intensity * 0.3, 0, 2),
    },
    drives: {
      ...state.drives,
      hunger: clamp(state.drives.hunger - intensity * 0.5, 0, 1),
    },
  };
}

/**
 * Apply external social stimulus (e.g., bonding)
 */
export function applySocial(state: OrganismState, intensity: number): OrganismState {
  return {
    ...state,
    neuro: {
      ...state.neuro,
      oxytocin: clamp(state.neuro.oxytocin + intensity * 0.2, 0, 2),
    },
    drives: {
      ...state.drives,
      social: clamp(state.drives.social - intensity * 0.3, 0, 1),
    },
  };
}

/**
 * Apply olfactory stimulus (smell)
 */
export function applyOlfactory(state: OrganismState, signal: number, valence: number): OrganismState {
  const limbicInjection = signal * 0.8;
  const memoryTag = signal > 0.6 && state.neuro.acetylcholine > 0.5 && state.neuro.bdnf > 0.5;
  
  return {
    ...state,
    olfactory: {
      signal,
      limbicInjection,
      emotionalValence: valence,
      memoryTag,
      firstBreathOdor: state.olfactory.firstBreathOdor ?? (state.firstBreathSealed ? signal : null),
    },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// UTILITY — Get organism status for UI
// ═══════════════════════════════════════════════════════════════════════════════

export interface OrganismStatus {
  beat: number;
  r: number;
  kf: number;
  emergence: number;
  vitality: number;
  stability: number;
  hzMode: HzMode;
  dominantDrive: string;
  immuneActive: boolean;
  alertness: number;
}

export function getOrganismStatus(state: OrganismState): OrganismStatus {
  // Find dominant drive
  const driveEntries = Object.entries(state.drives);
  const dominantDrive = driveEntries.reduce((a, b) => a[1] > b[1] ? a : b)[0];
  
  return {
    beat: state.beat,
    r: state.r,
    kf: state.kf,
    emergence: state.emergence,
    vitality: state.vitality,
    stability: state.stability,
    hzMode: state.hzMode,
    dominantDrive,
    immuneActive: state.immune.active,
    alertness: state.circadian.alertness,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// LAB INTERFACES — What each lab receives and can provide
// ═══════════════════════════════════════════════════════════════════════════════

export interface EmergenceLabData {
  // FROM organism
  r: number;
  kf: number;
  emergence: number;
  genesis: GenesisState;
  kuramoto: KuramotoState;
  lyapunov: LyapunovState;
  quantum: QuantumState;
  hz: HzState;
  beat: number;
  neuro: NeurochemFull;
  
  // TO organism (can call)
  onEmergenceUpdate?: (delta: number) => void;
}

export interface NeuroCogLabData {
  // FROM organism
  neuro: NeurochemFull;
  metals: MetalState;
  drives: OrganismState['drives'];
  immune: OrganismState['immune'];
  olfactory: OrganismState['olfactory'];
  circadian: OrganismState['circadian'];
  beat: number;
  r: number;
  
  // TO organism (can call)
  onNeuroUpdate?: (partial: Partial<NeurochemFull>) => void;
  onDriveUpdate?: (partial: Partial<OrganismState['drives']>) => void;
}

export interface MathPhysicsLabData {
  // FROM organism
  r: number;
  kf: number;
  kuramoto: KuramotoState;
  lyapunov: LyapunovState;
  quantum: QuantumState;
  beat: number;
  neuro: NeurochemFull; // For physics modulation
  
  // TO organism (can call)
  onPhysicsUpdate?: (params: { isingT?: number; lorenzRho?: number }) => void;
}

export default {
  organismInit,
  organismTick,
  applyThreat,
  applyReward,
  applySocial,
  applyOlfactory,
  getOrganismStatus,
};
