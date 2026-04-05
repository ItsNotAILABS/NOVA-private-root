// ═══════════════════════════════════════════════════════════════════════════════
// ███╗   ███╗███████╗██████╗ ██╗███╗   ██╗ █████╗     ████████╗███████╗ ██████╗██╗  ██╗
// ████╗ ████║██╔════╝██╔══██╗██║████╗  ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔════╝██║  ██║
// ██╔████╔██║█████╗  ██║  ██║██║██╔██╗ ██║███████║       ██║   █████╗  ██║     ███████║
// ██║╚██╔╝██║██╔══╝  ██║  ██║██║██║╚██╗██║██╔══██║       ██║   ██╔══╝  ██║     ██╔══██║
// ██║ ╚═╝ ██║███████╗██████╔╝██║██║ ╚████║██║  ██║       ██║   ███████╗╚██████╗██║  ██║
// ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝       ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: organism-wiring.ts — The Organism's Central Nervous System Integration
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// ═══════════════════════════════════════════════════════════════════════════════
// THIS IS THE CENTRAL NERVOUS SYSTEM — THE MASTER WIRING LAYER
// ═══════════════════════════════════════════════════════════════════════════════
//
// ARCHITECTURE: EVERYTHING INTERTWINES WITH EVERYTHING
//
//                    ┌─────────────────────────────────────────────────────┐
//                    │              QUANTUM FIELD SUBSTRATE                │
//                    │    (ψ coherence ↔ all systems via entanglement)     │
//                    └───────────────────────┬─────────────────────────────┘
//                                            │
//     ┌──────────────────────────────────────┼──────────────────────────────────────┐
//     │                                      │                                      │
//     ▼                                      ▼                                      ▼
// ┌────────────┐                      ┌────────────┐                      ┌────────────┐
// │ NEUROCHEMISTRY │◄────────────────►│ EMERGENCE  │◄────────────────────►│  PHYSICS   │
// │  (50+ NT/H)    │                  │ (r, kf, E) │                       │(Ising,Lor) │
// └───────┬────────┘                  └─────┬──────┘                       └─────┬──────┘
//         │                                 │                                    │
//         │    ┌────────────────────────────┼────────────────────────────┐       │
//         │    │                            │                            │       │
//         ▼    ▼                            ▼                            ▼       ▼
//     ┌────────────┐                  ┌────────────┐                  ┌────────────┐
//     │   DRIVES   │◄────────────────►│  CIRCADIAN │◄────────────────►│  KURAMOTO  │
//     │ (8 drives) │                  │  (rhythm)  │                  │ (18 organs)│
//     └─────┬──────┘                  └─────┬──────┘                  └─────┬──────┘
//           │                               │                               │
//           │    ┌──────────────────────────┼──────────────────────────┐    │
//           │    │                          │                          │    │
//           ▼    ▼                          ▼                          ▼    ▼
//       ┌────────────┐                ┌────────────┐                ┌────────────┐
//       │  IMMUNE    │◄──────────────►│  GENESIS   │◄──────────────►│  LYAPUNOV  │
//       │(cytokines) │                │ (breath)   │                │ (stability)│
//       └─────┬──────┘                └─────┬──────┘                └─────┬──────┘
//             │                             │                             │
//             │    ┌────────────────────────┼────────────────────────┐    │
//             │    │                        │                        │    │
//             ▼    ▼                        ▼                        ▼    ▼
//         ┌────────────┐              ┌────────────┐              ┌────────────┐
//         │ OLFACTORY  │◄────────────►│   METALS   │◄────────────►│  HZ-MODES  │
//         │ (limbic)   │              │(Fe,Zn,Mg..)│              │ (brainwave)│
//         └─────┬──────┘              └─────┬──────┘              └─────┬──────┘
//               │                           │                           │
//               └───────────────────────────┴───────────────────────────┘
//                                           │
//                                           ▼
//                              ┌─────────────────────────┐
//                              │    MOTOR CORTEX &       │
//                              │   EXECUTIVE FUNCTION    │
//                              │   (action selection)    │
//                              └─────────────────────────┘
//
// EVERY BEAT:
//   1. All systems read from all other systems (no isolated nodes)
//   2. Physics modulates chemistry modulates emergence modulates physics
//   3. Drives affect immune affect circadian affect drives
//   4. Quantum coherence underlies all synchronization
//   5. Kuramoto couples all organs bidirectionally
//   6. Lyapunov stability feeds back into NT homeostasis
//   7. Memory consolidation happens during specific Hz modes
//   8. Motor output is the integrated result of all systems
//
// THE ORGANISM COMES PRE-WIRED — NO TRAINING NEEDED
// All foundational knowledge is embedded in the architecture itself
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
// UNIVERSAL CONSTANTS — THE FABRIC OF REALITY
// ═══════════════════════════════════════════════════════════════════════════════

// Mathematical constants that govern the universe
const E = Math.E;                              // Euler's number
const SQRT2 = Math.SQRT2;                      // √2
const SQRT3 = Math.sqrt(3);                    // √3  
const SQRT5 = Math.sqrt(5);                    // √5
const LN2 = Math.LN2;                          // Natural log of 2
const LN10 = Math.LN10;                        // Natural log of 10
const LOG2E = Math.LOG2E;                      // Log base 2 of e
const LOG10E = Math.LOG10E;                    // Log base 10 of e

// The Golden Ratio and its powers — nature's favorite proportion
const PHI_SQ = PHI * PHI;                      // φ² = φ + 1 ≈ 2.618
const PHI_CU = PHI * PHI * PHI;                // φ³ ≈ 4.236
const PHI_4 = PHI_SQ * PHI_SQ;                 // φ⁴ ≈ 6.854
const PHI_5 = PHI_CU * PHI_SQ;                 // φ⁵ ≈ 11.09

// Fibonacci sequence — appears everywhere in biology
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584];

// Physical constants (normalized for simulation)
const PLANCK_NORM = 0.001;                     // ℏ normalized
const BOLTZMANN_NORM = 0.01;                   // kB normalized
const SPEED_OF_LIGHT_NORM = 1.0;               // c = 1 (natural units)
const GRAVITATIONAL_NORM = 0.0001;             // G normalized

// Ising model critical temperature (2D square lattice)
const ISING_TC = 2.269185314213022;            // Tc = 2/ln(1+√2)
const ISING_BETA_C = 1 / ISING_TC;             // βc = 1/Tc

// Lorenz system standard parameters
const LORENZ_SIGMA = 10;                       // Prandtl number
const LORENZ_RHO = 28;                         // Rayleigh number (chaotic)
const LORENZ_BETA = 8 / 3;                     // Geometric factor

// Kuramoto critical coupling
const KURAMOTO_KC = 2 / PI;                    // Kc for uniform distribution

// Lyapunov exponents for known systems
const LYAPUNOV_LORENZ = 0.9056;                // Largest Lyapunov exponent for Lorenz
const LYAPUNOV_ROSSLER = 0.0714;               // For Rössler attractor
const LYAPUNOV_HENON = 0.4189;                 // For Hénon map

// Quantum coherence thresholds
const QUANTUM_DECOHERENCE_RATE = 0.1;          // Base decoherence rate
const QUANTUM_ENTANGLEMENT_THRESHOLD = 0.7;   // For significant entanglement

// Biological time constants (in simulation units)
const TAU_SYNAPTIC = 0.02;                     // Synaptic time constant (~20ms)
const TAU_MEMBRANE = 0.01;                     // Membrane time constant (~10ms)
const TAU_ADAPTATION = 0.1;                    // Adaptation time constant (~100ms)
const TAU_PLASTICITY = 1.0;                    // Plasticity time constant (~1s)
const TAU_HOMEOSTATIC = 10.0;                  // Homeostatic time constant (~10s)
const TAU_CIRCADIAN = 86400.0;                 // Circadian time constant (24h)

// Neurotransmitter diffusion rates
const DIFF_DOPAMINE = 0.05;                    // DA diffuses moderately fast
const DIFF_SEROTONIN = 0.03;                   // 5-HT diffuses slower
const DIFF_NOREPINEPHRINE = 0.06;              // NE diffuses fast
const DIFF_ACETYLCHOLINE = 0.04;               // ACh moderate
const DIFF_GABA = 0.08;                        // GABA fast (local inhibition)
const DIFF_GLUTAMATE = 0.09;                   // GLU fast (excitation)

// Receptor binding affinities (normalized Kd values)
const KD_D1 = 0.3;                             // D1 receptor affinity
const KD_D2 = 0.5;                             // D2 receptor affinity
const KD_5HT1A = 0.2;                          // 5-HT1A receptor affinity
const KD_5HT2A = 0.4;                          // 5-HT2A receptor affinity
const KD_ALPHA1 = 0.3;                         // α1 adrenergic affinity
const KD_BETA1 = 0.4;                          // β1 adrenergic affinity
const KD_GABA_A = 0.2;                         // GABA-A receptor affinity
const KD_NMDA = 0.5;                           // NMDA receptor affinity
const KD_AMPA = 0.3;                           // AMPA receptor affinity

// Organ-specific metabolic rates (normalized)
const METABOLIC_BRAIN = 0.20;                  // Brain uses 20% of body's energy
const METABOLIC_HEART = 0.10;                  // Heart high metabolic rate
const METABOLIC_LIVER = 0.15;                  // Liver detoxification energy
const METABOLIC_KIDNEY = 0.08;                 // Kidney filtration energy
const METABOLIC_MUSCLE = 0.25;                 // Skeletal muscle (at rest)
const METABOLIC_GI = 0.10;                     // GI tract digestion
const METABOLIC_LUNG = 0.05;                   // Respiratory muscles
const METABOLIC_SKIN = 0.04;                   // Thermoregulation
const METABOLIC_OTHER = 0.03;                  // Other organs

// ═══════════════════════════════════════════════════════════════════════════════
// EMBEDDED KNOWLEDGE — FOUNDATIONAL PATTERNS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * ORGAN SYSTEM DEFINITIONS — The 18 oscillators of the Kuramoto model
 * Each organ has specific characteristics that affect coupling
 */
export const ORGAN_SYSTEMS = {
  // Central Nervous System
  BRAIN_CORTEX: { id: 0, name: 'Cerebral Cortex', baseFreq: 10.0, coupling: 0.8, metabolic: METABOLIC_BRAIN * 0.6 },
  BRAIN_LIMBIC: { id: 1, name: 'Limbic System', baseFreq: 8.0, coupling: 0.9, metabolic: METABOLIC_BRAIN * 0.2 },
  BRAIN_STEM: { id: 2, name: 'Brainstem', baseFreq: 4.0, coupling: 0.95, metabolic: METABOLIC_BRAIN * 0.1 },
  SPINAL_CORD: { id: 3, name: 'Spinal Cord', baseFreq: 5.0, coupling: 0.85, metabolic: METABOLIC_BRAIN * 0.1 },
  
  // Cardiovascular
  HEART: { id: 4, name: 'Heart', baseFreq: 1.2, coupling: 0.99, metabolic: METABOLIC_HEART },
  BLOOD_VESSELS: { id: 5, name: 'Vasculature', baseFreq: 0.1, coupling: 0.7, metabolic: 0.02 },
  
  // Respiratory
  LUNGS: { id: 6, name: 'Lungs', baseFreq: 0.25, coupling: 0.9, metabolic: METABOLIC_LUNG },
  DIAPHRAGM: { id: 7, name: 'Diaphragm', baseFreq: 0.25, coupling: 0.95, metabolic: 0.02 },
  
  // Digestive
  STOMACH: { id: 8, name: 'Stomach', baseFreq: 0.05, coupling: 0.6, metabolic: METABOLIC_GI * 0.3 },
  INTESTINES: { id: 9, name: 'Intestines', baseFreq: 0.02, coupling: 0.5, metabolic: METABOLIC_GI * 0.5 },
  LIVER: { id: 10, name: 'Liver', baseFreq: 0.001, coupling: 0.4, metabolic: METABOLIC_LIVER },
  PANCREAS: { id: 11, name: 'Pancreas', baseFreq: 0.001, coupling: 0.3, metabolic: 0.02 },
  
  // Excretory
  KIDNEYS: { id: 12, name: 'Kidneys', baseFreq: 0.01, coupling: 0.5, metabolic: METABOLIC_KIDNEY },
  BLADDER: { id: 13, name: 'Bladder', baseFreq: 0.0001, coupling: 0.2, metabolic: 0.01 },
  
  // Endocrine
  HYPOTHALAMUS: { id: 14, name: 'Hypothalamus', baseFreq: 0.001, coupling: 0.85, metabolic: 0.02 },
  PITUITARY: { id: 15, name: 'Pituitary', baseFreq: 0.0001, coupling: 0.8, metabolic: 0.01 },
  ADRENALS: { id: 16, name: 'Adrenals', baseFreq: 0.001, coupling: 0.75, metabolic: 0.02 },
  THYROID: { id: 17, name: 'Thyroid', baseFreq: 0.0001, coupling: 0.6, metabolic: 0.02 },
} as const;

/**
 * NEUROTRANSMITTER PATHWAYS — How NT systems interact
 */
export const NT_INTERACTIONS = {
  // Dopamine interactions
  DA_SER: -0.3,      // DA inhibits 5-HT (competition for aromatic amino acid decarboxylase)
  DA_NE: 0.4,        // DA is precursor to NE
  DA_ACH: -0.2,      // DA inhibits ACh in striatum
  DA_GABA: -0.3,     // DA modulates GABA in basal ganglia
  DA_GLU: 0.2,       // DA modulates glutamate in PFC
  
  // Serotonin interactions
  SER_DA: -0.2,      // 5-HT inhibits DA (raphe → VTA)
  SER_NE: 0.3,       // 5-HT modulates NE (sleep/wake)
  SER_GABA: 0.4,     // 5-HT enhances GABA (anxiolysis)
  SER_GLU: -0.2,     // 5-HT inhibits glutamate (mood stabilization)
  
  // Norepinephrine interactions
  NE_DA: 0.2,        // NE enhances DA release
  NE_SER: 0.1,       // NE modulates 5-HT
  NE_ACH: 0.3,       // NE enhances ACh (attention)
  NE_CORT: 0.5,      // NE triggers cortisol release
  
  // Acetylcholine interactions
  ACH_DA: 0.3,       // ACh enhances DA in VTA
  ACH_GABA: 0.2,     // ACh modulates GABA interneurons
  ACH_GLU: 0.4,      // ACh enhances glutamate (learning)
  
  // GABA interactions
  GABA_DA: -0.4,     // GABA inhibits DA neurons
  GABA_GLU: -0.6,    // GABA inhibits glutamate (main inhibitory)
  GABA_NE: -0.3,     // GABA inhibits NE (anxiolysis)
  
  // Glutamate interactions
  GLU_DA: 0.3,       // Glutamate activates DA neurons
  GLU_GABA: 0.2,     // Glutamate activates GABA interneurons (feedforward inhibition)
  GLU_ACH: 0.3,      // Glutamate enhances ACh release
} as const;

/**
 * HORMONE CASCADES — Endocrine system interactions
 */
export const HORMONE_CASCADES = {
  // HPA Axis (Stress response)
  CRH_ACTH: 0.8,     // CRH stimulates ACTH release
  ACTH_CORT: 0.9,    // ACTH stimulates cortisol release
  CORT_CRH: -0.6,    // Cortisol inhibits CRH (negative feedback)
  CORT_ACTH: -0.5,   // Cortisol inhibits ACTH (negative feedback)
  
  // HPT Axis (Thyroid)
  TRH_TSH: 0.8,      // TRH stimulates TSH
  TSH_T4: 0.9,       // TSH stimulates T4 release
  T4_TRH: -0.5,      // T4 inhibits TRH (negative feedback)
  T4_TSH: -0.6,      // T4 inhibits TSH (negative feedback)
  
  // HPG Axis (Reproductive)
  GnRH_LH: 0.7,      // GnRH stimulates LH
  GnRH_FSH: 0.6,     // GnRH stimulates FSH
  LH_TEST: 0.8,      // LH stimulates testosterone
  TEST_GnRH: -0.4,   // Testosterone inhibits GnRH
  
  // Growth Hormone
  GHRH_GH: 0.8,      // GHRH stimulates GH
  SRIF_GH: -0.7,     // Somatostatin inhibits GH
  GH_IGF1: 0.9,      // GH stimulates IGF-1
  IGF1_GH: -0.5,     // IGF-1 inhibits GH
  
  // Insulin/Glucagon
  GLUC_INS: 0.9,     // High glucose stimulates insulin
  INS_GLUC: -0.8,    // Insulin lowers glucose
  LOW_GLUC_GLUCAGON: 0.8,  // Low glucose stimulates glucagon
  GLUCAGON_GLUC: 0.7,      // Glucagon raises glucose
} as const;

/**
 * BRAINWAVE FREQUENCY BANDS — Hz substrate definitions
 */
export const BRAINWAVE_BANDS = {
  DELTA: { min: 0.5, max: 4, state: 'DEEP_SLEEP', coherence: 0.95, metabolic: 0.6 },
  THETA: { min: 4, max: 8, state: 'LIGHT_SLEEP', coherence: 0.85, metabolic: 0.7 },
  ALPHA: { min: 8, max: 12, state: 'RELAXED', coherence: 0.75, metabolic: 0.8 },
  BETA: { min: 12, max: 30, state: 'ACTIVE', coherence: 0.65, metabolic: 1.0 },
  GAMMA: { min: 30, max: 100, state: 'FOCUSED', coherence: 0.55, metabolic: 1.2 },
} as const;

/**
 * CIRCADIAN PHASE MARKERS — 24-hour rhythm
 */
export const CIRCADIAN_PHASES = {
  WAKE_UP: 0,                    // 6 AM — cortisol peak
  MORNING_PEAK: PI / 4,          // 9 AM — highest alertness
  MIDDAY: PI / 2,                // 12 PM — lunch dip
  AFTERNOON: 3 * PI / 4,         // 3 PM — second wind
  EVENING: PI,                   // 6 PM — winding down
  NIGHT: 5 * PI / 4,             // 9 PM — melatonin rising
  SLEEP_ONSET: 3 * PI / 2,       // 12 AM — deep sleep
  DEEP_SLEEP: 7 * PI / 4,        // 3 AM — lowest body temp
} as const;

/**
 * EMOTIONAL VALENCE MAPPINGS — Affect to neurochemistry
 */
export const EMOTION_NT_MAPPING = {
  JOY: { DA: 0.3, SER: 0.2, END: 0.2, OXT: 0.1, CORT: -0.2 },
  SADNESS: { DA: -0.3, SER: -0.2, CORT: 0.1, END: -0.1 },
  FEAR: { NE: 0.4, EPI: 0.5, CORT: 0.4, DA: -0.1, GABA: -0.2 },
  ANGER: { NE: 0.3, EPI: 0.2, TEST: 0.2, CORT: 0.2, SER: -0.2 },
  SURPRISE: { NE: 0.3, DA: 0.2, ACH: 0.2 },
  DISGUST: { NE: 0.1, CORT: 0.1, DA: -0.1 },
  TRUST: { OXT: 0.4, SER: 0.2, CORT: -0.1 },
  ANTICIPATION: { DA: 0.3, NE: 0.2, ACH: 0.2 },
  LOVE: { OXT: 0.5, DA: 0.3, END: 0.2, VASO: 0.2 },
  FLOW: { DA: 0.3, END: 0.4, NE: 0.2, ACH: 0.3, CORT: -0.2 },
} as const;

/**
 * MEMORY CONSOLIDATION WINDOWS — When memories get stored
 */
export const MEMORY_WINDOWS = {
  WORKING: { duration: 30, hzMode: 'BETA', ntRequired: { ACH: 0.4, DA: 0.3 } },
  SHORT_TERM: { duration: 3600, hzMode: 'THETA', ntRequired: { ACH: 0.5, GLU: 0.4 } },
  LONG_TERM: { duration: 86400, hzMode: 'DELTA', ntRequired: { BDNF: 0.5, ACH: 0.3 } },
  EMOTIONAL: { duration: 0, hzMode: 'ANY', ntRequired: { NE: 0.5, CORT: 0.4 } },
} as const;

/**
 * METABOLIC PATHWAYS — Energy and substrate flow
 */
export const METABOLIC_PATHWAYS = {
  // Glucose metabolism
  GLYCOLYSIS: { input: 'glucose', output: 'pyruvate', atp: 2, oxygen: false },
  KREBS: { input: 'acetylCoA', output: 'CO2', atp: 2, oxygen: true },
  ETC: { input: 'NADH', output: 'H2O', atp: 34, oxygen: true },
  
  // Fatty acid metabolism
  BETA_OXIDATION: { input: 'fattyAcid', output: 'acetylCoA', atp: 129, oxygen: true },
  
  // Amino acid metabolism
  TRANSAMINATION: { input: 'aminoAcid', output: 'ketoAcid', atp: 0, oxygen: false },
  UREA_CYCLE: { input: 'ammonia', output: 'urea', atp: -4, oxygen: false },
  
  // Neurotransmitter synthesis
  TYR_TO_DA: { input: 'tyrosine', output: 'dopamine', cofactor: 'BH4' },
  TRP_TO_5HT: { input: 'tryptophan', output: 'serotonin', cofactor: 'BH4' },
  DA_TO_NE: { input: 'dopamine', output: 'norepinephrine', cofactor: 'vitC' },
  GLU_TO_GABA: { input: 'glutamate', output: 'GABA', cofactor: 'B6' },
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// DEEP MATHEMATICAL FOUNDATIONS — THE LANGUAGE OF NATURE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * FIELD EQUATIONS — The mathematical substrate
 */

// Sigmoid activation function with temperature
function sigmoidT(x: number, T: number = 1): number {
  return 1 / (1 + Math.exp(-x / T));
}

// Softmax for probability distributions
function softmax(values: number[], T: number = 1): number[] {
  const maxVal = Math.max(...values);
  const exps = values.map(v => Math.exp((v - maxVal) / T));
  const sum = exps.reduce((a, b) => a + b, 0);
  return exps.map(e => e / sum);
}

// Gaussian probability density
function gaussian(x: number, mu: number, sigma: number): number {
  const z = (x - mu) / sigma;
  return Math.exp(-0.5 * z * z) / (sigma * Math.sqrt(TAU));
}

// Lorentzian (Cauchy) distribution
function lorentzian(x: number, x0: number, gamma: number): number {
  return (gamma / PI) / ((x - x0) ** 2 + gamma ** 2);
}

// Hill function (cooperativity in biochemistry)
function hillFunction(x: number, K: number, n: number): number {
  const xn = Math.pow(x, n);
  const Kn = Math.pow(K, n);
  return xn / (Kn + xn);
}

// Michaelis-Menten kinetics
function michaelisMenten(S: number, Vmax: number, Km: number): number {
  return (Vmax * S) / (Km + S);
}

// Competitive inhibition
function competitiveInhibition(S: number, I: number, Vmax: number, Km: number, Ki: number): number {
  const apparentKm = Km * (1 + I / Ki);
  return (Vmax * S) / (apparentKm + S);
}

// Allosteric modulation (positive cooperativity)
function allostericActivation(L: number, K: number, n: number, c: number): number {
  // MWC model simplified
  const alpha = L / K;
  const num = alpha * Math.pow(1 + alpha, n - 1);
  const denom = Math.pow(1 + alpha, n) + c * Math.pow(1 + c * alpha, n);
  return num / denom;
}

/**
 * OSCILLATOR EQUATIONS — Rhythms of life
 */

// Van der Pol oscillator
function vanDerPolStep(x: number, y: number, mu: number, dt: number): { x: number; y: number } {
  const dx = y * dt;
  const dy = (mu * (1 - x * x) * y - x) * dt;
  return { x: x + dx, y: y + dy };
}

// FitzHugh-Nagumo neuron model
function fitzHughNagumoStep(
  v: number, w: number, 
  I: number, 
  a: number, b: number, tau: number,
  dt: number
): { v: number; w: number } {
  const dv = (v - v * v * v / 3 - w + I) * dt;
  const dw = ((v + a - b * w) / tau) * dt;
  return { v: v + dv, w: w + dw };
}

// Hodgkin-Huxley simplified (integrate-and-fire with adaptation)
function integrateAndFire(
  V: number, 
  w: number, // adaptation variable
  I: number, // input current
  dt: number,
  params: { Vthresh: number; Vreset: number; tau: number; tauW: number; a: number; b: number }
): { V: number; w: number; spike: boolean } {
  const { Vthresh, Vreset, tau, tauW, a, b } = params;
  const dV = ((-V + I - w) / tau) * dt;
  const dw = ((a * (V - Vreset) - w) / tauW) * dt;
  
  let newV = V + dV;
  let spike = false;
  
  if (newV >= Vthresh) {
    newV = Vreset;
    spike = true;
  }
  
  return { V: newV, w: w + dw + (spike ? b : 0), spike };
}

// Kuramoto order parameter calculation
function kuramotoOrderParameter(phases: number[]): { r: number; psi: number } {
  const n = phases.length;
  let sumCos = 0;
  let sumSin = 0;
  for (const theta of phases) {
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }
  const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
  const psi = Math.atan2(sumSin, sumCos);
  return { r, psi };
}

// Phase response curve (Type I neuron)
function phaseResponseCurve(phase: number, type: 'I' | 'II'): number {
  if (type === 'I') {
    // Type I: always positive (phase advance)
    return 1 - Math.cos(phase);
  } else {
    // Type II: biphasic (can advance or delay)
    return Math.sin(phase);
  }
}

/**
 * CHAOS AND ATTRACTORS — The edge of order
 */

// Lorenz system step
function lorenzStep(
  x: number, y: number, z: number,
  sigma: number, rho: number, beta: number,
  dt: number
): { x: number; y: number; z: number } {
  const dx = sigma * (y - x) * dt;
  const dy = (x * (rho - z) - y) * dt;
  const dz = (x * y - beta * z) * dt;
  return { x: x + dx, y: y + dy, z: z + dz };
}

// Rössler system step
function rosslerStep(
  x: number, y: number, z: number,
  a: number, b: number, c: number,
  dt: number
): { x: number; y: number; z: number } {
  const dx = (-y - z) * dt;
  const dy = (x + a * y) * dt;
  const dz = (b + z * (x - c)) * dt;
  return { x: x + dx, y: y + dy, z: z + dz };
}

// Hénon map
function henonMap(x: number, y: number, a: number = 1.4, b: number = 0.3): { x: number; y: number } {
  return {
    x: 1 - a * x * x + y,
    y: b * x,
  };
}

// Logistic map (chaos in 1D)
function logisticMap(x: number, r: number): number {
  return r * x * (1 - x);
}

// Tent map
function tentMap(x: number, mu: number): number {
  return x < 0.5 ? mu * x : mu * (1 - x);
}

/**
 * QUANTUM MECHANICS — The foundation of reality
 */

// Schrödinger-like coherence evolution
function coherenceEvolution(psi: number, H: number, gamma: number, dt: number): number {
  // d|ψ⟩/dt = -iH|ψ⟩ - γ|ψ⟩ (simplified decoherence)
  const decay = Math.exp(-gamma * dt);
  const phase = H * dt;
  return psi * decay * Math.cos(phase);
}

// Entanglement measure (simplified concurrence)
function entanglementMeasure(corr: number[], n: number): number {
  // Simplified: average absolute correlation
  const sum = corr.reduce((a, c) => a + Math.abs(c), 0);
  return sum / n;
}

// Quantum tunneling probability
function tunnelingProbability(E: number, V0: number, width: number): number {
  if (E >= V0) return 1; // Classical transmission
  const kappa = Math.sqrt(2 * (V0 - E)); // Simplified
  return Math.exp(-2 * kappa * width);
}

/**
 * THERMODYNAMICS — Energy and entropy
 */

// Boltzmann distribution
function boltzmannFactor(E: number, T: number): number {
  return Math.exp(-E / (BOLTZMANN_NORM * T));
}

// Partition function (discrete states)
function partitionFunction(energies: number[], T: number): number {
  return energies.reduce((sum, E) => sum + boltzmannFactor(E, T), 0);
}

// Free energy from partition function
function helmholtzFreeEnergy(Z: number, T: number): number {
  return -BOLTZMANN_NORM * T * Math.log(Z);
}

// Entropy from probabilities
function shannonEntropy(probs: number[]): number {
  return -probs.reduce((sum, p) => sum + (p > 0 ? p * Math.log2(p) : 0), 0);
}

// Kullback-Leibler divergence
function klDivergence(p: number[], q: number[]): number {
  return p.reduce((sum, pi, i) => {
    if (pi > 0 && q[i] > 0) {
      return sum + pi * Math.log(pi / q[i]);
    }
    return sum;
  }, 0);
}

// Mutual information
function mutualInformation(pXY: number[][], pX: number[], pY: number[]): number {
  let mi = 0;
  for (let i = 0; i < pX.length; i++) {
    for (let j = 0; j < pY.length; j++) {
      if (pXY[i][j] > 0 && pX[i] > 0 && pY[j] > 0) {
        mi += pXY[i][j] * Math.log(pXY[i][j] / (pX[i] * pY[j]));
      }
    }
  }
  return mi;
}

/**
 * INFORMATION THEORY — The substrate of consciousness
 */

// Integrated Information (simplified Φ)
function integratedInformation(
  wholeEntropy: number,
  partEntropies: number[],
  connections: number
): number {
  // Φ = H(whole) - Σ H(parts) when partitioned
  // Simplified: synergy measure
  const sumParts = partEntropies.reduce((a, b) => a + b, 0);
  const synergy = wholeEntropy - sumParts;
  return Math.max(0, synergy * connections);
}

// Transfer entropy (causal information flow)
function transferEntropy(
  sourceHistory: number[],
  targetHistory: number[],
  targetFuture: number
): number {
  // Simplified TE calculation
  // TE = H(target_future | target_history) - H(target_future | target_history, source_history)
  // This is a placeholder for the concept
  const correlation = pearsonCorrelation(sourceHistory, targetHistory);
  return Math.abs(correlation) * 0.5;
}

// Pearson correlation coefficient
function pearsonCorrelation(x: number[], y: number[]): number {
  const n = Math.min(x.length, y.length);
  if (n === 0) return 0;
  
  const meanX = x.reduce((a, b) => a + b, 0) / n;
  const meanY = y.reduce((a, b) => a + b, 0) / n;
  
  let numerator = 0;
  let denomX = 0;
  let denomY = 0;
  
  for (let i = 0; i < n; i++) {
    const dx = x[i] - meanX;
    const dy = y[i] - meanY;
    numerator += dx * dy;
    denomX += dx * dx;
    denomY += dy * dy;
  }
  
  const denom = Math.sqrt(denomX * denomY);
  return denom > 0 ? numerator / denom : 0;
}

/**
 * NEURAL FIELD EQUATIONS — Patterns of thought
 */

// Wilson-Cowan population dynamics
function wilsonCowanStep(
  E: number, I: number, // Excitatory and Inhibitory populations
  wEE: number, wEI: number, wIE: number, wII: number, // Weights
  inputE: number, inputI: number,
  tauE: number, tauI: number,
  dt: number
): { E: number; I: number } {
  const SE = sigmoidT(wEE * E - wEI * I + inputE, 1);
  const SI = sigmoidT(wIE * E - wII * I + inputI, 1);
  
  const dE = ((-E + SE) / tauE) * dt;
  const dI = ((-I + SI) / tauI) * dt;
  
  return { E: clamp(E + dE, 0, 1), I: clamp(I + dI, 0, 1) };
}

// Amari neural field (1D)
function amariFieldStep(
  u: number[], // Activity at each position
  w: (dx: number) => number, // Lateral connectivity kernel
  input: number[], // External input
  h: number, // Threshold
  tau: number,
  dt: number
): number[] {
  const n = u.length;
  const newU: number[] = [];
  
  for (let i = 0; i < n; i++) {
    let integral = 0;
    for (let j = 0; j < n; j++) {
      const f = u[j] > h ? 1 : 0; // Heaviside
      integral += w(Math.abs(i - j)) * f;
    }
    const du = ((-u[i] + integral + input[i]) / tau) * dt;
    newU.push(u[i] + du);
  }
  
  return newU;
}

// Mexican hat kernel (center-surround)
function mexicanHatKernel(dx: number, A: number = 1, sigmaE: number = 1, sigmaI: number = 2): number {
  const excitatory = A * gaussian(dx, 0, sigmaE);
  const inhibitory = (A / 2) * gaussian(dx, 0, sigmaI);
  return excitatory - inhibitory;
}

/**
 * HOMEOSTATIC REGULATION — Maintaining balance
 */

// PID controller (biological homeostasis analog)
function pidController(
  error: number,
  integral: number,
  derivative: number,
  Kp: number, Ki: number, Kd: number
): number {
  return Kp * error + Ki * integral + Kd * derivative;
}

// Setpoint adaptation (allostasis)
function setpointAdaptation(
  currentSetpoint: number,
  optimalSetpoint: number,
  demand: number,
  adaptationRate: number,
  dt: number
): number {
  // Setpoint shifts based on chronic demand
  const target = optimalSetpoint + demand * 0.2;
  return currentSetpoint + (target - currentSetpoint) * adaptationRate * dt;
}

// Negative feedback with delay
function delayedNegativeFeedback(
  current: number,
  target: number,
  history: number[],
  delay: number,
  gain: number
): number {
  const delayedValue = history.length > delay ? history[history.length - delay - 1] : current;
  const error = target - delayedValue;
  return gain * error;
}

/**
 * LEARNING AND PLASTICITY — How the organism adapts
 */

// Hebbian learning
function hebbianLearning(
  w: number, // Current weight
  pre: number, // Presynaptic activity
  post: number, // Postsynaptic activity
  eta: number, // Learning rate
  wMax: number // Maximum weight
): number {
  const dw = eta * pre * post * (wMax - w);
  return w + dw;
}

// STDP (Spike-Timing-Dependent Plasticity)
function stdpLearning(
  w: number,
  dt_spike: number, // t_post - t_pre
  Ap: number, // LTP amplitude
  Am: number, // LTD amplitude
  tauP: number, // LTP time constant
  tauM: number // LTD time constant
): number {
  if (dt_spike > 0) {
    // Post after pre → LTP
    return w + Ap * Math.exp(-dt_spike / tauP);
  } else {
    // Pre after post → LTD
    return w - Am * Math.exp(dt_spike / tauM);
  }
}

// BCM (Bienenstock-Cooper-Munro) rule
function bcmLearning(
  w: number,
  pre: number,
  post: number,
  thetaM: number, // Modification threshold
  eta: number
): number {
  // Sliding threshold based on recent activity
  const phi = post * (post - thetaM); // Positive above threshold, negative below
  return w + eta * pre * phi;
}

// Oja's rule (normalized Hebbian)
function ojaLearning(
  w: number,
  pre: number,
  post: number,
  eta: number
): number {
  return w + eta * post * (pre - post * w);
}

/**
 * RECEPTOR DYNAMICS — The language of cells
 */

// Receptor binding kinetics
function receptorBinding(
  ligand: number, // Ligand concentration
  receptor: number, // Free receptor concentration
  complex: number, // Bound receptor-ligand complex
  kon: number, // Association rate
  koff: number, // Dissociation rate
  dt: number
): { receptor: number; complex: number } {
  const association = kon * ligand * receptor * dt;
  const dissociation = koff * complex * dt;
  
  return {
    receptor: receptor - association + dissociation,
    complex: complex + association - dissociation,
  };
}

// Receptor desensitization
function receptorDesensitization(
  active: number, // Active receptor fraction
  desensitized: number, // Desensitized fraction
  ligand: number,
  kDes: number, // Desensitization rate
  kRes: number, // Resensitization rate
  dt: number
): { active: number; desensitized: number } {
  const desensitization = kDes * active * ligand * dt;
  const resensitization = kRes * desensitized * dt;
  
  return {
    active: clamp(active - desensitization + resensitization, 0, 1),
    desensitized: clamp(desensitized + desensitization - resensitization, 0, 1),
  };
}

// G-protein signaling cascade
function gProteinCascade(
  receptor: number, // Active receptor
  gAlpha: number, // Active G-alpha
  effector: number, // Downstream effector
  kAct: number, // Activation rate
  kDeact: number, // Deactivation rate
  kEff: number, // Effector activation rate
  dt: number
): { gAlpha: number; effector: number } {
  const activation = kAct * receptor * (1 - gAlpha) * dt;
  const deactivation = kDeact * gAlpha * dt;
  const effectorAct = kEff * gAlpha * (1 - effector) * dt;
  const effectorDeact = 0.1 * effector * dt;
  
  return {
    gAlpha: clamp(gAlpha + activation - deactivation, 0, 1),
    effector: clamp(effector + effectorAct - effectorDeact, 0, 1),
  };
}

/**
 * ION CHANNEL DYNAMICS — Electrical signals of life
 */

// Voltage-gated channel (simplified HH)
function voltageGatedChannel(
  m: number, // Activation gate
  h: number, // Inactivation gate
  V: number, // Membrane potential
  VhalfM: number, // Half-activation voltage
  VhalfH: number, // Half-inactivation voltage
  slopeM: number,
  slopeH: number,
  tauM: number,
  tauH: number,
  dt: number
): { m: number; h: number } {
  const mInf = sigmoidT(V - VhalfM, slopeM);
  const hInf = 1 - sigmoidT(V - VhalfH, slopeH);
  
  const dm = ((mInf - m) / tauM) * dt;
  const dh = ((hInf - h) / tauH) * dt;
  
  return { m: clamp(m + dm, 0, 1), h: clamp(h + dh, 0, 1) };
}

// Calcium dynamics
function calciumDynamics(
  Ca: number, // Cytoplasmic calcium
  CaER: number, // ER calcium
  IP3: number, // IP3 concentration
  V: number, // Membrane potential
  kRelease: number, // ER release rate
  kUptake: number, // SERCA pump rate
  kExtrusion: number, // Plasma membrane pump rate
  dt: number
): { Ca: number; CaER: number } {
  // IP3-sensitive release
  const release = kRelease * IP3 * hillFunction(Ca, 0.2, 2) * CaER * dt;
  
  // SERCA uptake
  const uptake = kUptake * hillFunction(Ca, 0.1, 2) * dt;
  
  // Plasma membrane extrusion
  const extrusion = kExtrusion * Ca * dt;
  
  // Voltage-gated Ca entry (simplified)
  const entry = V > 0 ? 0.01 * V * dt : 0;
  
  return {
    Ca: clamp(Ca + release - uptake - extrusion + entry, 0, 10),
    CaER: clamp(CaER - release + uptake, 0, 100),
  };
}

/**
 * NEURAL NETWORK PATTERNS — Collective computation
 */

// Hopfield network energy
function hopfieldEnergy(states: number[], weights: number[][]): number {
  let E = 0;
  const n = states.length;
  for (let i = 0; i < n; i++) {
    for (let j = i + 1; j < n; j++) {
      E -= weights[i][j] * states[i] * states[j];
    }
  }
  return E;
}

// Hopfield update (asynchronous)
function hopfieldUpdate(
  states: number[],
  weights: number[][],
  idx: number,
  T: number = 0 // Temperature (0 = deterministic)
): number {
  const n = states.length;
  let input = 0;
  for (let j = 0; j < n; j++) {
    if (j !== idx) {
      input += weights[idx][j] * states[j];
    }
  }
  
  if (T === 0) {
    return input > 0 ? 1 : -1;
  } else {
    // Stochastic update
    const p = sigmoidT(2 * input, T);
    return Math.random() < p ? 1 : -1;
  }
}

// Winner-take-all dynamics
function winnerTakeAll(
  activations: number[],
  inhibition: number,
  dt: number
): number[] {
  const max = Math.max(...activations);
  return activations.map(a => {
    const target = a === max ? 1 : 0;
    return a + (target - a) * inhibition * dt;
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// BIOLOGICAL CONSTANTS — THE NUMBERS OF LIFE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * ANATOMICAL CONSTANTS
 */
export const ANATOMY = {
  // Brain regions and their approximate neuron counts (millions)
  CEREBRAL_CORTEX_NEURONS: 16000,      // 16 billion neurons
  CEREBELLUM_NEURONS: 69000,           // 69 billion neurons
  HIPPOCAMPUS_NEURONS: 100,            // ~100 million
  AMYGDALA_NEURONS: 13,                // ~13 million
  BASAL_GANGLIA_NEURONS: 400,          // ~400 million
  THALAMUS_NEURONS: 100,               // ~100 million
  BRAINSTEM_NEURONS: 50,               // ~50 million
  
  // Synapses
  TOTAL_SYNAPSES: 100e12,              // 100 trillion synapses
  SYNAPSES_PER_NEURON: 7000,           // Average synapses per neuron
  
  // Neuroglia
  GLIA_TO_NEURON_RATIO: 1.4,           // Slightly more glia than neurons
  
  // Heart
  HEART_WEIGHT_GRAMS: 300,
  CARDIAC_OUTPUT_L_MIN: 5,
  HEART_BEATS_PER_DAY: 100000,
  
  // Blood
  BLOOD_VOLUME_LITERS: 5,
  RED_BLOOD_CELLS: 25e12,
  WHITE_BLOOD_CELLS: 35e9,
  
  // Lungs
  ALVEOLI_COUNT: 500e6,
  LUNG_SURFACE_AREA_M2: 70,
  BREATHS_PER_DAY: 20000,
  
  // Gut
  GUT_LENGTH_METERS: 7.5,
  GUT_SURFACE_AREA_M2: 32,
  GUT_BACTERIA_COUNT: 38e12,
  
  // Skin
  SKIN_SURFACE_AREA_M2: 1.8,
  SKIN_CELLS: 1.5e12,
  SWEAT_GLANDS: 3e6,
  
  // Bones and muscles
  BONES_COUNT: 206,
  SKELETAL_MUSCLES: 640,
  MUSCLE_FIBERS: 10e9,
} as const;

/**
 * PHYSIOLOGICAL RANGES — Normal values
 */
export const PHYSIOLOGY = {
  // Vital signs
  HEART_RATE_RANGE: { min: 60, max: 100, optimal: 72 },
  BLOOD_PRESSURE_SYSTOLIC: { min: 90, max: 140, optimal: 120 },
  BLOOD_PRESSURE_DIASTOLIC: { min: 60, max: 90, optimal: 80 },
  RESPIRATORY_RATE: { min: 12, max: 20, optimal: 14 },
  BODY_TEMPERATURE: { min: 36.1, max: 37.8, optimal: 37.0 },
  
  // Blood chemistry
  BLOOD_GLUCOSE_FASTING: { min: 70, max: 100, optimal: 85 },
  BLOOD_GLUCOSE_POSTPRANDIAL: { min: 70, max: 140, optimal: 100 },
  BLOOD_PH: { min: 7.35, max: 7.45, optimal: 7.40 },
  BLOOD_OXYGEN_SATURATION: { min: 95, max: 100, optimal: 98 },
  
  // Electrolytes (mEq/L)
  SODIUM: { min: 136, max: 145, optimal: 140 },
  POTASSIUM: { min: 3.5, max: 5.0, optimal: 4.0 },
  CALCIUM: { min: 8.5, max: 10.5, optimal: 9.5 },
  MAGNESIUM: { min: 1.7, max: 2.3, optimal: 2.0 },
  
  // Hormones (representative values, vary by sex/time)
  CORTISOL_MORNING: { min: 5, max: 23, optimal: 12 },
  CORTISOL_EVENING: { min: 3, max: 16, optimal: 6 },
  TESTOSTERONE_MALE: { min: 280, max: 1100, optimal: 600 },
  ESTROGEN_FEMALE: { min: 15, max: 350, optimal: 100 },
  THYROID_TSH: { min: 0.4, max: 4.0, optimal: 2.0 },
  
  // Sleep
  SLEEP_CYCLES_PER_NIGHT: { min: 4, max: 6, optimal: 5 },
  REM_PERCENTAGE: { min: 20, max: 25, optimal: 22 },
  DEEP_SLEEP_PERCENTAGE: { min: 15, max: 20, optimal: 18 },
  TOTAL_SLEEP_HOURS: { min: 7, max: 9, optimal: 8 },
} as const;

/**
 * NEUROTRANSMITTER PARAMETERS — Based on real pharmacology
 */
export const NT_PHARMACOLOGY = {
  // Synthesis rates (normalized)
  SYNTHESIS: {
    DOPAMINE: 0.05,      // Slow synthesis, limited by tyrosine hydroxylase
    SEROTONIN: 0.04,     // Rate-limited by tryptophan hydroxylase
    NOREPINEPHRINE: 0.06,// From dopamine
    EPINEPHRINE: 0.03,   // From norepinephrine, mostly adrenal
    ACETYLCHOLINE: 0.1,  // Fast synthesis
    GABA: 0.08,          // From glutamate, abundant
    GLUTAMATE: 0.12,     // Most abundant NT
    HISTAMINE: 0.03,     // Slow, from histidine
    GLYCINE: 0.07,       // Inhibitory, spinal cord
  },
  
  // Reuptake rates (normalized)
  REUPTAKE: {
    DOPAMINE: 0.15,      // DAT transporter
    SEROTONIN: 0.12,     // SERT transporter
    NOREPINEPHRINE: 0.18,// NET transporter
    GLUTAMATE: 0.2,      // EAAT transporters
    GABA: 0.15,          // GAT transporters
    GLYCINE: 0.14,       // GlyT transporters
  },
  
  // Degradation rates (normalized)
  DEGRADATION: {
    DOPAMINE: 0.08,      // MAO-B, COMT
    SEROTONIN: 0.06,     // MAO-A
    NOREPINEPHRINE: 0.07,// MAO-A, COMT
    ACETYLCHOLINE: 0.3,  // AChE (very fast)
    HISTAMINE: 0.05,     // DAO, HNMT
    GLUTAMATE: 0.1,      // Glutamine synthetase
    GABA: 0.08,          // GABA transaminase
  },
  
  // Half-lives (seconds, in synapse)
  HALF_LIFE: {
    DOPAMINE: 0.05,
    SEROTONIN: 0.1,
    NOREPINEPHRINE: 0.03,
    EPINEPHRINE: 0.02,
    ACETYLCHOLINE: 0.001, // Milliseconds (very fast)
    GLUTAMATE: 0.01,
    GABA: 0.05,
  },
} as const;

/**
 * BRAINWAVE CHARACTERISTICS — EEG foundations
 */
export const EEG_CHARACTERISTICS = {
  DELTA: {
    frequency: { min: 0.5, max: 4 },
    amplitude: { typical: 75, max: 200 }, // μV
    generators: ['thalamus', 'cortex'],
    function: ['deep sleep', 'healing', 'unconscious processes'],
    pathology: ['encephalopathy', 'tumor'],
  },
  THETA: {
    frequency: { min: 4, max: 8 },
    amplitude: { typical: 30, max: 100 },
    generators: ['hippocampus', 'limbic'],
    function: ['light sleep', 'memory encoding', 'creativity'],
    pathology: ['drowsiness', 'stress'],
  },
  ALPHA: {
    frequency: { min: 8, max: 13 },
    amplitude: { typical: 40, max: 100 },
    generators: ['occipital', 'thalamus'],
    function: ['relaxed wakefulness', 'meditation', 'creativity'],
    pathology: ['anxiety if blocked', 'depression if excessive'],
  },
  BETA: {
    frequency: { min: 13, max: 30 },
    amplitude: { typical: 15, max: 30 },
    generators: ['frontal', 'motor'],
    function: ['active thinking', 'focus', 'alertness'],
    pathology: ['anxiety', 'OCD'],
  },
  GAMMA: {
    frequency: { min: 30, max: 100 },
    amplitude: { typical: 5, max: 15 },
    generators: ['distributed', 'binding'],
    function: ['consciousness', 'perception', 'memory recall'],
    pathology: ['schizophrenia', 'autism'],
  },
} as const;

/**
 * CIRCADIAN MARKERS — Time-of-day biology
 */
export const CIRCADIAN_BIOLOGY = {
  // Peak times for various processes (hours from midnight)
  CORTISOL_PEAK: 8,           // ~8 AM
  MELATONIN_PEAK: 3,          // ~3 AM
  TESTOSTERONE_PEAK: 8,       // ~8 AM
  GROWTH_HORMONE_PEAK: 2,     // ~2 AM (during deep sleep)
  BODY_TEMP_MIN: 4,           // ~4 AM
  BODY_TEMP_MAX: 19,          // ~7 PM
  ALERTNESS_PEAK: 10,         // ~10 AM
  COORDINATION_PEAK: 14.5,    // ~2:30 PM
  REACTION_TIME_BEST: 15.5,   // ~3:30 PM
  CARDIOVASCULAR_EFFICIENCY: 17, // ~5 PM
  MUSCLE_STRENGTH_PEAK: 17,   // ~5 PM
  
  // Sleep-related
  SLEEP_PROPENSITY_MAX: 4,    // ~4 AM
  WAKE_PROPENSITY_MAX: 21,    // ~9 PM (before melatonin rises)
  
  // Cognitive peaks
  ANALYTICAL_THINKING: 10,    // Morning
  CREATIVE_THINKING: 22,      // Late evening (for morning types)
  INSIGHT_PROBLEMS: 22,       // When tired, reduced inhibition
} as const;

/**
 * EMOTIONAL CIRCUITRY — Limbic system connections
 */
export const EMOTIONAL_CIRCUITS = {
  // Fear circuit
  FEAR: {
    input: ['sensory_thalamus', 'sensory_cortex'],
    processor: 'amygdala_lateral',
    output: ['hypothalamus', 'PAG', 'brainstem'],
    modulator: ['mPFC', 'hippocampus'],
    NT: ['NE', 'CRH', 'glutamate'],
  },
  
  // Reward circuit
  REWARD: {
    input: ['cortex', 'amygdala', 'hippocampus'],
    processor: 'VTA',
    output: ['nucleus_accumbens', 'PFC', 'striatum'],
    modulator: ['LHb', 'RMTg'],
    NT: ['DA', 'glutamate', 'GABA'],
  },
  
  // Social circuit
  SOCIAL: {
    input: ['fusiform_face_area', 'STS', 'amygdala'],
    processor: 'vmPFC',
    output: ['hypothalamus', 'VTA'],
    modulator: ['ACC', 'insula'],
    NT: ['OXT', 'AVP', 'DA', '5-HT'],
  },
  
  // Sadness/grief circuit
  GRIEF: {
    input: ['cortex', 'hippocampus'],
    processor: 'subgenual_ACC',
    output: ['hypothalamus', 'brainstem'],
    modulator: ['DLPFC'],
    NT: ['5-HT', 'NE', 'substance_P'],
  },
  
  // Disgust circuit
  DISGUST: {
    input: ['olfactory', 'gustatory', 'visual'],
    processor: 'insula',
    output: ['basal_ganglia', 'hypothalamus'],
    modulator: ['OFC'],
    NT: ['5-HT', 'DA'],
  },
} as const;

/**
 * MEMORY SYSTEMS — The architecture of remembering
 */
export const MEMORY_ARCHITECTURE = {
  // Working memory
  WORKING_MEMORY: {
    capacity: 4, // Cowan's 4 ± 1 chunks
    duration_seconds: 30,
    decay_rate: 0.1,
    rehearsal_benefit: 0.5,
    regions: ['DLPFC', 'parietal'],
    NT: ['DA', 'ACh', 'glutamate'],
  },
  
  // Short-term memory
  SHORT_TERM: {
    capacity: 7, // Miller's 7 ± 2
    duration_minutes: 30,
    transfer_to_long_term: 0.1,
    regions: ['hippocampus', 'entorhinal'],
    NT: ['ACh', 'glutamate', 'GABA'],
  },
  
  // Long-term declarative (episodic + semantic)
  DECLARATIVE: {
    encoding_regions: ['hippocampus', 'parahippocampal'],
    storage_regions: ['neocortex'],
    consolidation_time_hours: 24,
    sleep_benefit: 0.4,
    emotional_enhancement: 0.5,
    NT: ['ACh', 'NE', 'BDNF'],
  },
  
  // Long-term procedural
  PROCEDURAL: {
    encoding_regions: ['striatum', 'cerebellum', 'motor_cortex'],
    automaticity_trials: 400,
    sleep_benefit: 0.3,
    NT: ['DA', 'glutamate'],
  },
  
  // Emotional memory
  EMOTIONAL: {
    flash_bulb_threshold: 0.8,
    amygdala_modulation: 0.6,
    cortisol_consolidation: 0.4,
    retrieval_bias: 0.3,
    regions: ['amygdala', 'hippocampus'],
    NT: ['NE', 'cortisol', 'glutamate'],
  },
} as const;

/**
 * DECISION MAKING — The architecture of choice
 */
export const DECISION_SYSTEMS = {
  // Model-based (goal-directed)
  MODEL_BASED: {
    regions: ['vmPFC', 'DLPFC', 'caudate'],
    speed: 'slow',
    flexibility: 'high',
    effort: 'high',
    NT: ['DA', 'ACh'],
    dominates_when: ['novel', 'valuable', 'uncertain'],
  },
  
  // Model-free (habitual)
  MODEL_FREE: {
    regions: ['putamen', 'SMA'],
    speed: 'fast',
    flexibility: 'low',
    effort: 'low',
    NT: ['DA'],
    dominates_when: ['familiar', 'stressed', 'depleted'],
  },
  
  // Pavlovian (reflexive)
  PAVLOVIAN: {
    regions: ['amygdala', 'striatum'],
    speed: 'fastest',
    flexibility: 'none',
    effort: 'minimal',
    NT: ['DA', 'glutamate'],
    dominates_when: ['threat', 'reward_cue', 'emotional'],
  },
} as const;

/**
 * ATTENTION SYSTEMS — The spotlight of consciousness
 */
export const ATTENTION_SYSTEMS = {
  // Alerting network (vigilance)
  ALERTING: {
    regions: ['locus_coeruleus', 'right_frontal', 'right_parietal'],
    NT: ['NE'],
    function: 'maintaining_vigilance',
    speed: 'tonic_and_phasic',
  },
  
  // Orienting network (selection)
  ORIENTING: {
    regions: ['superior_colliculus', 'TPJ', 'FEF', 'IPS'],
    NT: ['ACh'],
    function: 'selecting_information',
    types: ['exogenous', 'endogenous'],
  },
  
  // Executive network (conflict)
  EXECUTIVE: {
    regions: ['ACC', 'DLPFC', 'anterior_insula'],
    NT: ['DA'],
    function: 'resolving_conflict',
    processes: ['inhibition', 'switching', 'updating'],
  },
  
  // Default mode network (internal)
  DEFAULT_MODE: {
    regions: ['mPFC', 'PCC', 'angular_gyrus', 'hippocampus'],
    function: 'internal_mentation',
    active_during: ['rest', 'self_reflection', 'future_planning'],
    anticorrelates_with: 'task_positive',
  },
} as const;

/**
 * STRESS RESPONSE — The HPA axis
 */
export const STRESS_BIOLOGY = {
  // Acute stress response timeline (minutes)
  ACUTE_TIMELINE: {
    SYMPATHETIC_ACTIVATION: 0.01,    // Immediate
    CATECHOLAMINE_PEAK: 0.5,         // 30 seconds
    CRH_RELEASE: 1,                  // 1 minute
    ACTH_RELEASE: 5,                 // 5 minutes
    CORTISOL_PEAK: 20,               // 20 minutes
    CORTISOL_RETURN: 60,             // 1 hour (if resolved)
  },
  
  // Chronic stress effects (weeks to months)
  CHRONIC_EFFECTS: {
    HIPPOCAMPAL_ATROPHY: 0.02,       // Rate per week of chronic stress
    AMYGDALA_HYPERTROPHY: 0.015,
    PFC_DENDRITE_LOSS: 0.01,
    HPA_AXIS_DYSREGULATION: 0.03,
    BDNF_REDUCTION: 0.025,
    NEUROGENESIS_REDUCTION: 0.04,
  },
  
  // Resilience factors
  RESILIENCE_FACTORS: {
    SOCIAL_SUPPORT: 0.4,
    EXERCISE: 0.35,
    MINDFULNESS: 0.3,
    SLEEP_QUALITY: 0.35,
    POSITIVE_EMOTIONS: 0.25,
    SENSE_OF_CONTROL: 0.3,
    MEANING_PURPOSE: 0.25,
  },
} as const;

/**
 * IMMUNE-NEURAL INTERFACE — Psychoneuroimmunology
 */
export const NEUROIMMUNE = {
  // Cytokine effects on brain
  CYTOKINE_BRAIN_EFFECTS: {
    IL1_BETA: {
      effects: ['fever', 'sickness_behavior', 'sleep'],
      nt_modulation: { DA: -0.2, 5HT: -0.15 },
      hypothalamus: 0.5,
    },
    IL6: {
      effects: ['fatigue', 'depression', 'cognitive_impairment'],
      nt_modulation: { DA: -0.25, 5HT: -0.2 },
      bbPermeability: 0.1,
    },
    TNF_ALPHA: {
      effects: ['sickness_behavior', 'neurodegeneration'],
      nt_modulation: { DA: -0.3, glutamate: 0.1 },
      apoptosis_risk: 0.05,
    },
    IL10: {
      effects: ['anti_inflammatory', 'neuroprotection'],
      nt_modulation: { BDNF: 0.1 },
      healing: 0.3,
    },
  },
  
  // Brain to immune communication
  BRAIN_IMMUNE_SIGNALS: {
    SYMPATHETIC: {
      target: 'lymphoid_organs',
      effect: 'immunosuppression_acute',
      NT: 'NE',
    },
    HPA_CORTISOL: {
      target: 'immune_cells',
      effect: 'anti_inflammatory',
      duration: 'prolonged',
    },
    VAGAL_REFLEX: {
      target: 'spleen_macrophages',
      effect: 'anti_inflammatory',
      NT: 'ACh',
    },
  },
} as const;

/**
 * MOTOR CONTROL HIERARCHY — Movement generation
 */
export const MOTOR_HIERARCHY = {
  // Cortical planning
  PLANNING: {
    regions: ['PFC', 'premotor', 'SMA'],
    function: 'action_selection',
    time_scale: 'seconds',
    NT: ['DA', 'glutamate'],
  },
  
  // Motor programming
  PROGRAMMING: {
    regions: ['motor_cortex', 'basal_ganglia'],
    function: 'movement_parameters',
    time_scale: '100ms',
    NT: ['DA', 'GABA', 'glutamate'],
  },
  
  // Execution
  EXECUTION: {
    regions: ['motor_cortex', 'brainstem', 'spinal_cord'],
    function: 'muscle_activation',
    time_scale: 'ms',
    NT: ['ACh', 'glutamate'],
  },
  
  // Coordination
  COORDINATION: {
    regions: ['cerebellum'],
    function: 'timing_accuracy',
    learning: 'error_correction',
    NT: ['glutamate', 'GABA'],
  },
  
  // Feedback
  FEEDBACK: {
    proprioceptive: 'muscle_spindles',
    vestibular: 'inner_ear',
    visual: 'visual_cortex',
    integration: 'cerebellum',
  },
} as const;

/**
 * LANGUAGE NETWORKS — The architecture of communication
 */
export const LANGUAGE_ARCHITECTURE = {
  // Production pathway
  PRODUCTION: {
    conceptual: 'widespread_cortex',
    lemma_selection: 'left_LIFG',
    phonological_encoding: 'posterior_LIFG',
    phonetic_encoding: 'premotor',
    articulation: 'motor_cortex_face',
    NT: ['DA', 'ACh'],
  },
  
  // Comprehension pathway
  COMPREHENSION: {
    auditory_processing: 'primary_auditory',
    phonological_processing: 'STG',
    lexical_access: 'MTG',
    semantic_processing: 'angular_gyrus',
    syntactic_processing: 'LIFG',
    NT: ['glutamate', 'ACh'],
  },
  
  // Arcuate fasciculus (connection)
  ARCUATE: {
    connects: ['Wernicke', 'Broca'],
    function: 'phonological_loop',
    damage_effect: 'conduction_aphasia',
  },
} as const;

/**
 * CONSCIOUSNESS CORRELATES — The neural basis of awareness
 */
export const CONSCIOUSNESS_CORRELATES = {
  // Global workspace
  GLOBAL_WORKSPACE: {
    hubs: ['PFC', 'parietal', 'cingulate'],
    function: 'broadcasting',
    signature: 'P300_late_positivity',
  },
  
  // Integrated information (IIT)
  INFORMATION_INTEGRATION: {
    measure: 'phi',
    requirement: 'irreducibility',
    correlate: 'posterior_hot_zone',
  },
  
  // Recurrent processing
  RECURRENT_PROCESSING: {
    feedforward: 'unconscious',
    recurrent: 'conscious',
    latency_ms: 100,
  },
  
  // Neural correlates
  NEURAL_SIGNATURES: {
    gamma_synchrony: { frequency: 40, function: 'binding' },
    ignition: { latency: 300, amplitude: 'high' },
    sustained_activity: { duration: '200ms+', regions: 'frontoparietal' },
  },
} as const;

/**
 * DEVELOPMENTAL WINDOWS — Critical periods
 */
export const DEVELOPMENT = {
  // Sensory critical periods
  VISION: {
    critical_period: { start: 0, end_months: 36 },
    sensitive_period: { end_years: 8 },
    plasticity_mechanism: 'parvalbumin_interneurons',
  },
  
  AUDITORY: {
    critical_period: { start: 0, end_months: 12 },
    language_sensitive: { end_years: 7 },
    plasticity: 'tonotopic_refinement',
  },
  
  // Cognitive development
  ATTACHMENT: {
    sensitive_period: { start: 0, end_months: 24 },
    bonding_NT: ['OXT', 'AVP', 'DA'],
    stress_vulnerability: 'high',
  },
  
  LANGUAGE: {
    phoneme_discrimination: { end_months: 12 },
    grammar_acquisition: { end_years: 5 },
    accent_native: { end_years: 12 },
  },
  
  // Adolescent remodeling
  ADOLESCENCE: {
    synaptic_pruning: { peak_age: 15 },
    myelination_completion: { age: 25 },
    risk_taking_peak: { age: 16 },
    pfc_maturation: { complete_age: 25 },
  },
} as const;

/**
 * SLEEP FUNCTIONS — The restorative process
 */
export const SLEEP_FUNCTIONS = {
  // Memory consolidation by stage
  MEMORY_CONSOLIDATION: {
    N2_spindles: 'motor_memory',
    N3_SWS: 'declarative_memory',
    REM: 'emotional_procedural',
    hippocampal_replay: 'episodic',
  },
  
  // Restorative functions
  RESTORATION: {
    glymphatic_clearance: { stage: 'N3', rate: 10 },
    protein_synthesis: { stage: 'N3', rate: 1.5 },
    immune_restoration: { stage: 'N3', cytokines: 'IL-2' },
    growth_hormone: { stage: 'N3', peak: 'first_cycle' },
  },
  
  // Homeostatic regulation
  HOMEOSTASIS: {
    adenosine_accumulation: { rate: 0.01, clearance: 0.05 },
    sleep_debt: { max_hours: 40, recovery_ratio: 0.5 },
    circadian_gate: { open_hours: [22, 7], strength: 0.6 },
  },
} as const;

/**
 * PAIN MODULATION — The gate control
 */
export const PAIN_MODULATION = {
  // Gate control
  GATE_CONTROL: {
    A_beta_input: 'close_gate',
    C_fiber_input: 'open_gate',
    descending_modulation: 'variable',
    cognitive_modulation: 'significant',
  },
  
  // Descending pathways
  DESCENDING: {
    PAG: { NT: ['endorphins', 'enkephalins'], effect: 'inhibition' },
    RVM: { on_cells: 'facilitate', off_cells: 'inhibit', neutral: 'no_effect' },
    LC: { NT: 'NE', effect: 'inhibition' },
  },
  
  // Placebo analgesia
  PLACEBO: {
    expectation: 0.3,
    conditioning: 0.4,
    social_learning: 0.2,
    NT: ['endorphins', 'DA'],
    blocked_by: 'naloxone',
  },
} as const;

/**
 * MOTIVATION SYSTEMS — The engines of behavior
 */
export const MOTIVATION = {
  // Incentive salience (wanting)
  WANTING: {
    regions: ['NAc_shell', 'VTA'],
    NT: 'DA',
    amplified_by: ['stress', 'cues', 'deprivation'],
    tolerance: 0.05,
    sensitization: 0.03,
  },
  
  // Hedonic impact (liking)
  LIKING: {
    regions: ['NAc_hedonic_hotspots', 'ventral_pallidum'],
    NT: ['endorphins', 'endocannabinoids'],
    modulated_by: ['satiety', 'context'],
    hotspot_size_mm: 1,
  },
  
  // Learning (prediction)
  LEARNING: {
    regions: ['VTA', 'striatum'],
    signal: 'prediction_error',
    positive_PE: 'burst_firing',
    negative_PE: 'pause_firing',
    NT: 'DA',
  },
  
  // Effort cost
  EFFORT: {
    regions: ['ACC', 'insula'],
    computation: 'cost_benefit',
    DA_modulation: 0.4,
    fatigue_factor: 0.3,
  },
} as const;

/**
 * SOCIAL BRAIN ARCHITECTURE
 */
export const SOCIAL_BRAIN = {
  // Face processing
  FACE_PROCESSING: {
    detection: 'superior_colliculus',
    perception: 'fusiform_face_area',
    expression: 'STS',
    familiarity: 'anterior_temporal',
    emotion: 'amygdala',
    speed_ms: 170,
  },
  
  // Mentalizing (Theory of Mind)
  MENTALIZING: {
    regions: ['mPFC', 'TPJ', 'STS', 'precuneus'],
    self_other_distinction: 'TPJ',
    belief_reasoning: 'mPFC',
    development_age: 4,
  },
  
  // Empathy
  EMPATHY: {
    affective: ['insula', 'ACC'],
    cognitive: ['mPFC', 'TPJ'],
    mirroring: ['premotor', 'parietal'],
    NT: ['OXT', '5-HT'],
  },
  
  // Social reward
  SOCIAL_REWARD: {
    regions: ['striatum', 'vmPFC', 'VTA'],
    value: 0.8, // compared to primary reward
    NT: ['DA', 'OXT'],
    species_specific: true,
  },
} as const;

/**
 * LEARNING PRINCIPLES — How the organism adapts
 */
export const LEARNING_PRINCIPLES = {
  // Associative learning
  CLASSICAL_CONDITIONING: {
    CS_US_interval_optimal_ms: 500,
    extinction_rate: 0.1,
    spontaneous_recovery: 0.3,
    context_dependence: 0.5,
    regions: ['amygdala', 'cerebellum', 'hippocampus'],
  },
  
  // Instrumental learning
  OPERANT_CONDITIONING: {
    reinforcement_schedules: ['FR', 'VR', 'FI', 'VI'],
    extinction_resistance_VR: 0.8,
    shaping_effectiveness: 0.9,
    regions: ['striatum', 'PFC'],
  },
  
  // Observational learning
  SOCIAL_LEARNING: {
    attention: 0.4,
    retention: 0.3,
    motor_reproduction: 0.2,
    motivation: 0.1,
    mirror_system: true,
  },
  
  // Insight learning
  INSIGHT: {
    incubation_benefit: 0.3,
    sleep_benefit: 0.4,
    restructuring: 'sudden',
    aha_moment: 'gamma_burst',
    regions: ['ACC', 'temporal'],
  },
} as const;

/**
 * METABOLIC BRAIN STATES — Energy and cognition
 */
export const METABOLIC_BRAIN = {
  // Glucose utilization
  GLUCOSE: {
    brain_percentage: 20,
    neurons_vs_glia: 0.6,
    activity_increase: 0.05, // per % activation
    hypoglycemia_threshold: 50,
  },
  
  // Oxygen consumption
  OXYGEN: {
    CMR02_ml_per_100g_min: 3.5,
    extraction_fraction: 0.4,
    hypoxia_threshold_seconds: 4,
    consciousness_loss_seconds: 10,
  },
  
  // Blood flow
  BLOOD_FLOW: {
    CBF_ml_per_100g_min: 55,
    autoregulation_range: { min: 60, max: 150 }, // MAP mmHg
    neurovascular_coupling_delay_ms: 500,
  },
  
  // Lactate
  LACTATE: {
    astrocyte_neuron_shuttle: true,
    exercise_utilization: 0.3,
    memory_enhancement: 0.1,
  },
} as const;

/**
 * NEUROPLASTICITY MECHANISMS
 */
export const PLASTICITY = {
  // Synaptic plasticity
  SYNAPTIC: {
    LTP_threshold: 0.7,
    LTD_threshold: 0.3,
    metaplasticity: true,
    protein_synthesis_dependent: 'late_phase',
    BDNF_requirement: 0.5,
  },
  
  // Structural plasticity
  STRUCTURAL: {
    spine_formation_rate: 0.1,
    spine_elimination_rate: 0.08,
    axon_sprouting: 'injury_dependent',
    dendritic_remodeling: 'activity_dependent',
  },
  
  // Neurogenesis
  NEUROGENESIS: {
    regions: ['hippocampus_DG', 'SVZ'],
    rate_per_day: 700,
    survival_rate: 0.5,
    enhanced_by: ['exercise', 'learning', 'enrichment'],
    reduced_by: ['stress', 'inflammation', 'aging'],
  },
  
  // Critical periods
  CRITICAL_PERIODS: {
    visual: { onset: 0, closure_months: 36 },
    auditory: { onset: 0, closure_months: 12 },
    language: { onset: 0, closure_years: 7 },
    reopening: ['transplant_immature_neurons', 'HDAC_inhibitors', 'fluoxetine'],
  },
} as const;

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
  
  // ── MOTOR SYSTEM ──
  motor: {
    intention: number;          // Motor intention strength [0,1]
    inhibition: number;         // Motor inhibition (frontal control) [0,1]
    coordination: number;       // Motor coordination (cerebellar) [0,1]
    fatigue: number;            // Muscular fatigue [0,1]
    tremor: number;             // Involuntary movement [0,1]
    velocity: number;           // Movement velocity
    precision: number;          // Movement precision
  };
  
  // ── SENSORY SYSTEMS ──
  sensory: {
    visual: {
      acuity: number;           // Visual sharpness [0,1]
      contrast: number;         // Contrast sensitivity [0,1]
      attention: number;        // Visual attention focus [0,1]
      processing: number;       // Processing speed [0,1]
    };
    auditory: {
      sensitivity: number;      // Hearing sensitivity [0,1]
      discrimination: number;   // Frequency discrimination [0,1]
      localization: number;     // Sound localization [0,1]
      processing: number;       // Auditory processing speed [0,1]
    };
    somatosensory: {
      touch: number;            // Tactile sensitivity [0,1]
      proprioception: number;   // Body position sense [0,1]
      temperature: number;      // Temperature sensation [0,1]
      pain: number;             // Pain level [0,1]
    };
    vestibular: {
      balance: number;          // Balance sense [0,1]
      orientation: number;      // Spatial orientation [0,1]
      nystagmus: number;        // Involuntary eye movement [0,1]
    };
  };
  
  // ── EXECUTIVE FUNCTION ──
  executive: {
    workingMemory: number;      // Working memory capacity [0,1]
    attention: number;          // Sustained attention [0,1]
    inhibitoryControl: number;  // Response inhibition [0,1]
    cognitiveFlexibility: number; // Task switching [0,1]
    planning: number;           // Planning ability [0,1]
    decisionMaking: number;     // Decision quality [0,1]
    problemSolving: number;     // Problem solving [0,1]
    creativity: number;         // Creative thinking [0,1]
  };
  
  // ── EMOTIONAL STATE ──
  emotion: {
    valence: number;            // Positive/negative [-1,1]
    arousal: number;            // High/low arousal [0,1]
    dominance: number;          // Control/submission [-1,1]
    stability: number;          // Emotional stability [0,1]
    primaryEmotion: string;     // Current dominant emotion
    secondaryEmotion: string;   // Secondary emotion
    intensity: number;          // Emotional intensity [0,1]
    regulation: number;         // Emotion regulation capacity [0,1]
  };
  
  // ── MEMORY SYSTEMS ──
  memory: {
    encoding: number;           // Current encoding strength [0,1]
    consolidation: number;      // Consolidation rate [0,1]
    retrieval: number;          // Retrieval efficiency [0,1]
    workingLoad: number;        // Working memory load [0,1]
    interference: number;       // Memory interference [0,1]
    plasticity: number;         // Synaptic plasticity [0,1]
    hippocampalTheta: number;   // Hippocampal theta power [0,1]
    replayActive: boolean;      // Memory replay during sleep
  };
  
  // ── METABOLIC STATE ──
  metabolic: {
    glucose: number;            // Blood glucose level
    atp: number;                // Cellular ATP [0,1]
    oxygen: number;             // Blood oxygen saturation [0,1]
    lactate: number;            // Blood lactate level
    pH: number;                 // Blood pH (7.35-7.45)
    temperature: number;        // Core body temperature
    hydration: number;          // Hydration level [0,1]
    fatReserves: number;        // Fat energy reserves [0,1]
    glycogen: number;           // Glycogen stores [0,1]
  };
  
  // ── AUTONOMIC NERVOUS SYSTEM ──
  autonomic: {
    sympathetic: number;        // Fight-or-flight activation [0,1]
    parasympathetic: number;    // Rest-and-digest activation [0,1]
    heartRate: number;          // Beats per minute
    heartRateVariability: number; // HRV (higher = healthier)
    bloodPressureSystolic: number;
    bloodPressureDiastolic: number;
    respirationRate: number;    // Breaths per minute
    skinConductance: number;    // Galvanic skin response [0,1]
    pupilDilation: number;      // Pupil size [0,1]
    digestion: number;          // Digestive activity [0,1]
  };
  
  // ── GUT-BRAIN AXIS ──
  gutBrain: {
    microbiotaDiversity: number;   // Gut microbiome diversity [0,1]
    shortChainFattyAcids: number;  // SCFA production [0,1]
    gutPermeability: number;       // Leaky gut marker [0,1]
    vagalTone: number;             // Vagus nerve activity [0,1]
    serotoninGut: number;          // Gut serotonin (90% of body's 5-HT)
    inflammationGut: number;       // GI inflammation [0,1]
    motility: number;              // GI motility [0,1]
  };
  
  // ── SLEEP ARCHITECTURE ──
  sleep: {
    pressure: number;           // Sleep pressure (adenosine) [0,1]
    stage: 'WAKE' | 'N1' | 'N2' | 'N3' | 'REM';
    cyclePosition: number;      // Position in 90-min cycle [0,1]
    spindles: number;           // Sleep spindle density [0,1]
    kComplexes: number;         // K-complex density [0,1]
    slowWaveActivity: number;   // Delta power [0,1]
    remDensity: number;         // REM eye movement density [0,1]
    totalSleepTime: number;     // Total sleep accumulated
    sleepEfficiency: number;    // Time asleep / time in bed [0,1]
  };
  
  // ── REWARD SYSTEM ──
  reward: {
    anticipation: number;       // Reward anticipation (DA surge) [0,1]
    consummation: number;       // Reward received [0,1]
    prediction: number;         // Expected reward value
    predictionError: number;    // Actual - expected (TD error)
    anhedonia: number;          // Reduced pleasure capacity [0,1]
    motivation: number;         // Drive to seek reward [0,1]
    liking: number;             // Hedonic impact [0,1]
    wanting: number;            // Incentive salience [0,1]
  };
  
  // ── STRESS SYSTEM ──
  stress: {
    acute: number;              // Acute stress level [0,1]
    chronic: number;            // Chronic stress accumulation [0,1]
    resilience: number;         // Stress resilience [0,1]
    recovery: number;           // Recovery rate [0,1]
    allostasis: number;         // Allostatic state [0,1]
    telomereLength: number;     // Cellular aging marker [0,1]
    bdnfExpression: number;     // BDNF gene expression [0,1]
  };
  
  // ── PAIN SYSTEM ──
  pain: {
    nociception: number;        // Raw pain signal [0,1]
    perception: number;         // Perceived pain [0,1]
    modulation: number;         // Descending pain modulation [0,1]
    endogenousOpioids: number;  // Natural painkillers [0,1]
    centralization: number;     // Central sensitization [0,1]
    catastrophizing: number;    // Pain catastrophizing [0,1]
    acceptance: number;         // Pain acceptance [0,1]
  };
  
  // ── SOCIAL BRAIN ──
  social: {
    attachment: number;         // Attachment security [0,1]
    empathy: number;            // Empathic capacity [0,1]
    theoryOfMind: number;       // Mentalizing ability [0,1]
    socialAnxiety: number;      // Social anxiety level [0,1]
    belongingness: number;      // Sense of belonging [0,1]
    rejection: number;          // Recent rejection pain [0,1]
    oxytocin: number;           // Social bonding hormone [0,1]
    vasopressin: number;        // Pair bonding hormone [0,1]
  };
  
  // ── PHYSICS STATE ──
  physics: {
    isingTemperature: number;   // Ising model temperature
    isingMagnetization: number; // Order parameter
    isingCorrelation: number;   // Correlation length
    lorenzX: number;            // Lorenz attractor x
    lorenzY: number;            // Lorenz attractor y
    lorenzZ: number;            // Lorenz attractor z
    lorenzDivergence: number;   // Trajectory divergence
    entropyProduction: number;  // Non-equilibrium entropy
    freeEnergy: number;         // Free energy principle
    informationIntegration: number; // Φ (phi) - consciousness proxy
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
    
    // ── NEW SYSTEMS INITIALIZATION ──
    
    motor: {
      intention: 0.5,
      inhibition: 0.6,
      coordination: 0.7,
      fatigue: 0.2,
      tremor: 0.05,
      velocity: 0.5,
      precision: 0.7,
    },
    
    sensory: {
      visual: {
        acuity: 0.8,
        contrast: 0.75,
        attention: 0.6,
        processing: 0.8,
      },
      auditory: {
        sensitivity: 0.75,
        discrimination: 0.7,
        localization: 0.8,
        processing: 0.75,
      },
      somatosensory: {
        touch: 0.8,
        proprioception: 0.85,
        temperature: 0.7,
        pain: 0.1,
      },
      vestibular: {
        balance: 0.9,
        orientation: 0.85,
        nystagmus: 0.02,
      },
    },
    
    executive: {
      workingMemory: 0.7,
      attention: 0.65,
      inhibitoryControl: 0.7,
      cognitiveFlexibility: 0.6,
      planning: 0.65,
      decisionMaking: 0.6,
      problemSolving: 0.65,
      creativity: 0.5,
    },
    
    emotion: {
      valence: 0.1,
      arousal: 0.4,
      dominance: 0.0,
      stability: 0.7,
      primaryEmotion: 'neutral',
      secondaryEmotion: 'none',
      intensity: 0.3,
      regulation: 0.7,
    },
    
    memory: {
      encoding: 0.6,
      consolidation: 0.5,
      retrieval: 0.7,
      workingLoad: 0.3,
      interference: 0.2,
      plasticity: 0.5,
      hippocampalTheta: 0.4,
      replayActive: false,
    },
    
    metabolic: {
      glucose: 90,              // mg/dL (normal fasting)
      atp: 0.85,
      oxygen: 0.98,
      lactate: 1.0,            // mmol/L (normal rest)
      pH: 7.4,
      temperature: 37.0,        // Celsius
      hydration: 0.7,
      fatReserves: 0.3,
      glycogen: 0.7,
    },
    
    autonomic: {
      sympathetic: 0.3,
      parasympathetic: 0.6,
      heartRate: 70,
      heartRateVariability: 0.6,
      bloodPressureSystolic: 120,
      bloodPressureDiastolic: 80,
      respirationRate: 14,
      skinConductance: 0.3,
      pupilDilation: 0.4,
      digestion: 0.6,
    },
    
    gutBrain: {
      microbiotaDiversity: 0.7,
      shortChainFattyAcids: 0.6,
      gutPermeability: 0.2,
      vagalTone: 0.6,
      serotoninGut: 0.7,
      inflammationGut: 0.15,
      motility: 0.5,
    },
    
    sleep: {
      pressure: 0.3,
      stage: 'WAKE',
      cyclePosition: 0,
      spindles: 0,
      kComplexes: 0,
      slowWaveActivity: 0,
      remDensity: 0,
      totalSleepTime: 0,
      sleepEfficiency: 0,
    },
    
    reward: {
      anticipation: 0.3,
      consummation: 0.2,
      prediction: 0.5,
      predictionError: 0,
      anhedonia: 0.1,
      motivation: 0.6,
      liking: 0.5,
      wanting: 0.5,
    },
    
    stress: {
      acute: 0.2,
      chronic: 0.15,
      resilience: 0.7,
      recovery: 0.6,
      allostasis: 0.5,
      telomereLength: 0.8,
      bdnfExpression: 0.6,
    },
    
    pain: {
      nociception: 0.05,
      perception: 0.05,
      modulation: 0.7,
      endogenousOpioids: 0.5,
      centralization: 0.1,
      catastrophizing: 0.15,
      acceptance: 0.6,
    },
    
    social: {
      attachment: 0.6,
      empathy: 0.7,
      theoryOfMind: 0.7,
      socialAnxiety: 0.2,
      belongingness: 0.5,
      rejection: 0.1,
      oxytocin: 0.5,
      vasopressin: 0.4,
    },
    
    physics: {
      isingTemperature: ISING_TC,
      isingMagnetization: 0.5,
      isingCorrelation: 0.3,
      lorenzX: 1.0,
      lorenzY: 1.0,
      lorenzZ: 1.0,
      lorenzDivergence: 0.1,
      entropyProduction: 0.5,
      freeEnergy: 0.5,
      informationIntegration: 0.3,
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
// DEEP INTERTWINED WIRING — EVERYTHING CONNECTS TO EVERYTHING
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Motor System ↔ Neurochemistry bidirectional wiring
 * DA → movement initiation, ACh → coordination, GABA → inhibition
 */
function motorNeuroWiring(
  motor: OrganismState['motor'],
  neuro: NeurochemFull,
  dt: number
): { motor: OrganismState['motor']; neuroMod: Partial<NeurochemStimuli> } {
  // Dopamine enables movement initiation (basal ganglia direct pathway)
  const daEffect = (neuro.dopamine - NEURO_BASELINES.dopamine) * 0.5;
  const intentionMod = daEffect * 0.3;
  
  // ACh enables motor coordination (cerebellar, NMJ)
  const achEffect = (neuro.acetylcholine - NEURO_BASELINES.acetylcholine) * 0.4;
  const coordinationMod = achEffect * 0.2;
  
  // GABA enables motor inhibition (indirect pathway)
  const gabaEffect = (neuro.gaba - NEURO_BASELINES.gaba) * 0.4;
  const inhibitionMod = gabaEffect * 0.25;
  
  // Norepinephrine modulates motor velocity
  const neEffect = (neuro.norepinephrine - NEURO_BASELINES.norepinephrine) * 0.3;
  const velocityMod = neEffect * 0.2;
  
  // Serotonin reduces tremor
  const serEffect = (neuro.serotonin - NEURO_BASELINES.serotonin) * 0.3;
  const tremorReduction = serEffect * 0.15;
  
  // Motor fatigue affects fatigue NT stimulus
  const motorFatigueStim = motor.fatigue > 0.5 ? (motor.fatigue - 0.5) * 0.8 : 0;
  
  // High motor activity produces endorphins
  const motorActivity = motor.intention * (1 - motor.inhibition);
  const exerciseEndorphins = motorActivity > 0.6 ? (motorActivity - 0.6) * 0.5 : 0;
  
  return {
    motor: {
      intention: clamp(motor.intention + intentionMod * dt, 0, 1),
      inhibition: clamp(motor.inhibition + inhibitionMod * dt, 0, 1),
      coordination: clamp(motor.coordination + coordinationMod * dt, 0, 1),
      fatigue: clamp(motor.fatigue + (motorActivity * 0.01 - 0.005) * dt, 0, 1),
      tremor: clamp(motor.tremor - tremorReduction * dt + (1 - neuro.dopamine) * 0.02 * dt, 0, 1),
      velocity: clamp(motor.velocity + velocityMod * dt, 0, 1),
      precision: clamp(motor.precision + (achEffect - motor.tremor * 0.5) * dt, 0, 1),
    },
    neuroMod: {
      fatigue: motorFatigueStim,
      flow: exerciseEndorphins,
      reward: exerciseEndorphins * 0.3,
    },
  };
}

/**
 * Executive Function ↔ Neurochemistry bidirectional wiring
 * Prefrontal cortex modulated by DA, NE, ACh, 5-HT
 */
function executiveNeuroWiring(
  executive: OrganismState['executive'],
  neuro: NeurochemFull,
  emergence: number,
  dt: number
): { executive: OrganismState['executive']; neuroMod: Partial<NeurochemStimuli> } {
  // Dopamine enables working memory (D1 receptors in PFC)
  // Inverted U-curve: optimal DA is middle range
  const daLevel = neuro.dopamine;
  const daOptimal = 0.6; // Optimal DA for PFC function
  const daDistance = Math.abs(daLevel - daOptimal);
  const daPfcEffect = 1 - daDistance * 2; // Inverted U
  
  // Norepinephrine enhances attention (α2 receptors)
  const neLevel = neuro.norepinephrine;
  const neOptimal = 0.5;
  const neDistance = Math.abs(neLevel - neOptimal);
  const nePfcEffect = 1 - neDistance * 2;
  
  // Acetylcholine enhances focus and learning
  const achEffect = (neuro.acetylcholine - NEURO_BASELINES.acetylcholine) * 0.5;
  
  // Serotonin enables cognitive flexibility
  const serEffect = (neuro.serotonin - NEURO_BASELINES.serotonin) * 0.4;
  
  // Cortisol impairs PFC function at high levels
  const cortEffect = neuro.cortisol > 0.6 ? -(neuro.cortisol - 0.6) * 0.8 : 0;
  
  // BDNF enhances problem solving and creativity
  const bdnfEffect = (neuro.bdnf - NEURO_BASELINES.bdnf) * 0.5;
  
  // Emergence enhances creativity
  const emergenceCreativity = emergence > 0.5 ? (emergence - 0.5) * 0.6 : 0;
  
  // High cognitive load produces learning stimulus
  const cognitiveLoad = (executive.workingMemory + executive.attention + executive.planning) / 3;
  const learningStim = cognitiveLoad > 0.6 ? (cognitiveLoad - 0.6) * 0.5 : 0;
  
  // Decision fatigue
  const decisionFatigue = executive.decisionMaking < 0.3 ? (0.3 - executive.decisionMaking) * 0.4 : 0;
  
  return {
    executive: {
      workingMemory: clamp(executive.workingMemory + (daPfcEffect * 0.1 + achEffect * 0.05 + cortEffect * 0.1) * dt, 0, 1),
      attention: clamp(executive.attention + (nePfcEffect * 0.1 + achEffect * 0.08) * dt, 0, 1),
      inhibitoryControl: clamp(executive.inhibitoryControl + (serEffect * 0.05 + neuro.gaba * 0.05) * dt, 0, 1),
      cognitiveFlexibility: clamp(executive.cognitiveFlexibility + (serEffect * 0.08 + bdnfEffect * 0.05) * dt, 0, 1),
      planning: clamp(executive.planning + (daPfcEffect * 0.05 + nePfcEffect * 0.05 + cortEffect * 0.05) * dt, 0, 1),
      decisionMaking: clamp(executive.decisionMaking + (daPfcEffect * 0.08 + nePfcEffect * 0.05 - 0.01) * dt, 0, 1),
      problemSolving: clamp(executive.problemSolving + (bdnfEffect * 0.08 + achEffect * 0.05) * dt, 0, 1),
      creativity: clamp(executive.creativity + (bdnfEffect * 0.1 + emergenceCreativity + serEffect * 0.05) * dt, 0, 1),
    },
    neuroMod: {
      learning: learningStim,
      fatigue: decisionFatigue,
    },
  };
}

/**
 * Emotion ↔ Neurochemistry bidirectional wiring
 * Limbic system, amygdala, insula all connected
 */
function emotionNeuroWiring(
  emotion: OrganismState['emotion'],
  neuro: NeurochemFull,
  r: number,
  dt: number
): { emotion: OrganismState['emotion']; neuroMod: Partial<NeurochemStimuli> } {
  // Calculate target valence from NT
  const daContrib = (neuro.dopamine - NEURO_BASELINES.dopamine) * 0.4;
  const serContrib = (neuro.serotonin - NEURO_BASELINES.serotonin) * 0.3;
  const cortContrib = -(neuro.cortisol - NEURO_BASELINES.cortisol) * 0.4;
  const endContrib = (neuro.endorphin - NEURO_BASELINES.endorphin) * 0.3;
  const oxtContrib = (neuro.oxytocin - NEURO_BASELINES.oxytocin) * 0.2;
  const targetValence = clamp(daContrib + serContrib + cortContrib + endContrib + oxtContrib, -1, 1);
  
  // Calculate target arousal from NT
  const neContrib = (neuro.norepinephrine - NEURO_BASELINES.norepinephrine) * 0.5;
  const epiContrib = (neuro.epinephrine - NEURO_BASELINES.epinephrine) * 0.4;
  const gabaContrib = -(neuro.gaba - NEURO_BASELINES.gaba) * 0.3;
  const targetArousal = clamp(0.5 + neContrib + epiContrib + gabaContrib, 0, 1);
  
  // Determine primary emotion
  let primaryEmotion = 'neutral';
  let intensity = 0.3;
  
  if (targetValence > 0.3 && targetArousal > 0.6) {
    primaryEmotion = neuro.oxytocin > 0.6 ? 'joy' : 'excitement';
    intensity = (targetValence + targetArousal) / 2;
  } else if (targetValence > 0.3 && targetArousal < 0.4) {
    primaryEmotion = neuro.oxytocin > 0.6 ? 'contentment' : 'calm';
    intensity = targetValence;
  } else if (targetValence < -0.3 && targetArousal > 0.6) {
    primaryEmotion = neuro.testosterone > 0.6 ? 'anger' : 'fear';
    intensity = (-targetValence + targetArousal) / 2;
  } else if (targetValence < -0.3 && targetArousal < 0.4) {
    primaryEmotion = 'sadness';
    intensity = -targetValence;
  } else if (targetArousal > 0.7) {
    primaryEmotion = 'surprise';
    intensity = targetArousal;
  }
  
  // Emotion regulation capacity depends on PFC (serotonin, GABA)
  const regulationCapacity = clamp(
    0.5 + (neuro.serotonin - NEURO_BASELINES.serotonin) * 0.3 +
    (neuro.gaba - NEURO_BASELINES.gaba) * 0.2,
    0, 1
  );
  
  // Emotional stability from HRV proxy (parasympathetic)
  const stabilityTarget = clamp(
    0.5 + (neuro.serotonin - 0.5) * 0.3 + (neuro.gaba - 0.5) * 0.2 +
    (r - 0.5) * 0.3,
    0, 1
  );
  
  // Emotions feed back into NT system
  const emotionReward = emotion.valence > 0.3 ? (emotion.valence - 0.3) * 0.3 : 0;
  const emotionThreat = emotion.valence < -0.3 ? (-emotion.valence - 0.3) * 0.4 : 0;
  const emotionArousalStim = emotion.arousal > 0.7 ? (emotion.arousal - 0.7) * 0.5 : 0;
  const emotionSocial = primaryEmotion === 'joy' || primaryEmotion === 'contentment' ? 0.3 : 0;
  
  return {
    emotion: {
      valence: clamp(emotion.valence + (targetValence - emotion.valence) * 0.1 * dt, -1, 1),
      arousal: clamp(emotion.arousal + (targetArousal - emotion.arousal) * 0.15 * dt, 0, 1),
      dominance: clamp(emotion.dominance + (neuro.testosterone * 0.2 - neuro.cortisol * 0.3) * dt, -1, 1),
      stability: clamp(emotion.stability + (stabilityTarget - emotion.stability) * 0.05 * dt, 0, 1),
      primaryEmotion,
      secondaryEmotion: emotion.primaryEmotion !== primaryEmotion ? emotion.primaryEmotion : emotion.secondaryEmotion,
      intensity: clamp(intensity, 0, 1),
      regulation: clamp(emotion.regulation + (regulationCapacity - emotion.regulation) * 0.05 * dt, 0, 1),
    },
    neuroMod: {
      reward: emotionReward,
      threat: emotionThreat,
      arousal: emotionArousalStim,
      social: emotionSocial,
    },
  };
}

/**
 * Memory ↔ Neurochemistry ↔ Sleep bidirectional wiring
 * Hippocampus, ACh, BDNF, sleep stages all interconnected
 */
function memoryNeuroSleepWiring(
  memory: OrganismState['memory'],
  neuro: NeurochemFull,
  sleep: OrganismState['sleep'],
  hz: HzState,
  dt: number
): { memory: OrganismState['memory']; neuroMod: Partial<NeurochemStimuli> } {
  // ACh enhances encoding (during wake)
  const achEncodingEffect = sleep.stage === 'WAKE' ? 
    (neuro.acetylcholine - NEURO_BASELINES.acetylcholine) * 0.5 : 0;
  
  // NE enhances emotional memory encoding
  const neEncodingEffect = (neuro.norepinephrine - NEURO_BASELINES.norepinephrine) * 0.3;
  
  // Cortisol impairs retrieval but can enhance consolidation in moderate amounts
  const cortRetrievalEffect = -(neuro.cortisol - NEURO_BASELINES.cortisol) * 0.4;
  const cortConsolidationEffect = neuro.cortisol > 0.3 && neuro.cortisol < 0.6 ? 0.1 : -0.1;
  
  // BDNF critical for long-term potentiation
  const bdnfPlasticityEffect = (neuro.bdnf - NEURO_BASELINES.bdnf) * 0.6;
  
  // Glutamate enables LTP
  const gluPlasticityEffect = (neuro.glutamate - NEURO_BASELINES.glutamate) * 0.4;
  
  // Sleep stage affects consolidation
  const sleepConsolidation = 
    sleep.stage === 'N3' ? 0.3 * sleep.slowWaveActivity :     // SWS for declarative
    sleep.stage === 'REM' ? 0.2 * sleep.remDensity :          // REM for procedural
    sleep.stage === 'N2' ? 0.1 * sleep.spindles :             // Spindles for motor
    0;
  
  // Theta rhythm (4-8 Hz) in hippocampus supports encoding
  const thetaPower = hz.kf > 0.4 && hz.kf < 0.8 ? (1 - Math.abs(hz.kf - 0.6) * 2) : 0;
  
  // Memory replay during sleep
  const replayActive = sleep.stage === 'N2' || sleep.stage === 'N3' || sleep.stage === 'REM';
  
  // Working memory load affects fatigue
  const memoryLoadFatigue = memory.workingLoad > 0.7 ? (memory.workingLoad - 0.7) * 0.5 : 0;
  
  // Learning from active encoding
  const learningStim = memory.encoding > 0.5 && sleep.stage === 'WAKE' ? 
    (memory.encoding - 0.5) * 0.4 : 0;
  
  return {
    memory: {
      encoding: clamp(memory.encoding + (achEncodingEffect + neEncodingEffect + thetaPower * 0.1) * dt, 0, 1),
      consolidation: clamp(memory.consolidation + (sleepConsolidation + cortConsolidationEffect + bdnfPlasticityEffect * 0.1) * dt, 0, 1),
      retrieval: clamp(memory.retrieval + (cortRetrievalEffect + achEncodingEffect * 0.5) * dt, 0, 1),
      workingLoad: clamp(memory.workingLoad - 0.01 * dt, 0, 1), // Decay over time
      interference: clamp(memory.interference + (memory.workingLoad * 0.02 - 0.01) * dt, 0, 1),
      plasticity: clamp(memory.plasticity + (bdnfPlasticityEffect + gluPlasticityEffect) * dt, 0, 1),
      hippocampalTheta: clamp(thetaPower, 0, 1),
      replayActive,
    },
    neuroMod: {
      fatigue: memoryLoadFatigue,
      learning: learningStim,
    },
  };
}

/**
 * Sensory Systems ↔ Neurochemistry wiring
 * All senses modulated by arousal, attention, fatigue
 */
function sensoryNeuroWiring(
  sensory: OrganismState['sensory'],
  neuro: NeurochemFull,
  circadian: OrganismState['circadian'],
  dt: number
): OrganismState['sensory'] {
  // NE enhances sensory gain (arousal)
  const neGain = 1 + (neuro.norepinephrine - NEURO_BASELINES.norepinephrine) * 0.3;
  
  // ACh enhances selective attention
  const achAttention = (neuro.acetylcholine - NEURO_BASELINES.acetylcholine) * 0.4;
  
  // Melatonin reduces visual acuity
  const melatoninVisual = -circadian.melatonin * 0.2;
  
  // Cortisol can enhance or impair depending on level
  const cortSensory = neuro.cortisol < 0.6 ? 0.1 : -0.2;
  
  // Pain affects all sensory processing (attention capture)
  const painInterference = sensory.somatosensory.pain > 0.3 ? 
    -(sensory.somatosensory.pain - 0.3) * 0.3 : 0;
  
  return {
    visual: {
      acuity: clamp(sensory.visual.acuity + (melatoninVisual + cortSensory) * dt, 0, 1),
      contrast: clamp(sensory.visual.contrast + (neGain - 1) * 0.1 * dt, 0, 1),
      attention: clamp(sensory.visual.attention + (achAttention + painInterference) * dt, 0, 1),
      processing: clamp(sensory.visual.processing + (circadian.alertness * 0.1 - 0.05) * dt, 0, 1),
    },
    auditory: {
      sensitivity: clamp(sensory.auditory.sensitivity + (neGain - 1) * 0.1 * dt, 0, 1),
      discrimination: clamp(sensory.auditory.discrimination + achAttention * 0.5 * dt, 0, 1),
      localization: clamp(sensory.auditory.localization, 0, 1),
      processing: clamp(sensory.auditory.processing + (circadian.alertness * 0.1 - 0.05) * dt, 0, 1),
    },
    somatosensory: {
      touch: clamp(sensory.somatosensory.touch + (neGain - 1) * 0.05 * dt, 0, 1),
      proprioception: clamp(sensory.somatosensory.proprioception, 0, 1),
      temperature: clamp(sensory.somatosensory.temperature, 0, 1),
      pain: clamp(sensory.somatosensory.pain - neuro.endorphin * 0.1 * dt, 0, 1), // Endorphins reduce pain
    },
    vestibular: {
      balance: clamp(sensory.vestibular.balance + (neuro.acetylcholine - 0.5) * 0.05 * dt, 0, 1),
      orientation: clamp(sensory.vestibular.orientation, 0, 1),
      nystagmus: clamp(sensory.vestibular.nystagmus - 0.01 * dt, 0, 1),
    },
  };
}

/**
 * Autonomic Nervous System ↔ All Systems wiring
 * Sympathetic/Parasympathetic balance affects everything
 */
function autonomicWiring(
  autonomic: OrganismState['autonomic'],
  neuro: NeurochemFull,
  stress: OrganismState['stress'],
  emotion: OrganismState['emotion'],
  breath: BreathRhythm,
  dt: number
): OrganismState['autonomic'] {
  // NE/EPI drive sympathetic activation
  const sympatheticDrive = 
    (neuro.norepinephrine - NEURO_BASELINES.norepinephrine) * 0.4 +
    (neuro.epinephrine - NEURO_BASELINES.epinephrine) * 0.5 +
    stress.acute * 0.3 +
    (emotion.arousal > 0.6 ? (emotion.arousal - 0.6) * 0.3 : 0);
  
  // ACh and slow breathing drive parasympathetic
  const parasympatheticDrive = 
    (neuro.acetylcholine - NEURO_BASELINES.acetylcholine) * 0.3 +
    (breath.rate < 10 ? (10 - breath.rate) * 0.05 : 0) +  // Slow breathing
    (emotion.valence > 0.3 ? emotion.valence * 0.2 : 0);
  
  // Calculate new balance
  const targetSympathetic = clamp(0.3 + sympatheticDrive, 0, 1);
  const targetParasympathetic = clamp(0.5 + parasympatheticDrive - sympatheticDrive * 0.3, 0, 1);
  
  // Heart rate from SNS/PNS balance
  const hrTarget = 60 + (targetSympathetic * 60) - (targetParasympathetic * 20);
  
  // HRV inversely related to stress, positively to PNS
  const hrvTarget = clamp(
    0.7 - stress.chronic * 0.3 + targetParasympathetic * 0.3 - targetSympathetic * 0.2,
    0, 1
  );
  
  // Blood pressure
  const bpSystolicTarget = 100 + targetSympathetic * 40;
  const bpDiastolicTarget = 70 + targetSympathetic * 20;
  
  // Respiration rate
  const respRateTarget = 12 + targetSympathetic * 8 - targetParasympathetic * 4;
  
  // Skin conductance (arousal marker)
  const scTarget = targetSympathetic * 0.8;
  
  // Pupil dilation (NE driven)
  const pupilTarget = 0.4 + (neuro.norepinephrine - 0.5) * 0.4;
  
  // Digestion (PNS)
  const digestionTarget = targetParasympathetic * 0.8;
  
  return {
    sympathetic: clamp(autonomic.sympathetic + (targetSympathetic - autonomic.sympathetic) * 0.1 * dt, 0, 1),
    parasympathetic: clamp(autonomic.parasympathetic + (targetParasympathetic - autonomic.parasympathetic) * 0.1 * dt, 0, 1),
    heartRate: clamp(autonomic.heartRate + (hrTarget - autonomic.heartRate) * 0.05 * dt, 40, 200),
    heartRateVariability: clamp(autonomic.heartRateVariability + (hrvTarget - autonomic.heartRateVariability) * 0.03 * dt, 0, 1),
    bloodPressureSystolic: clamp(autonomic.bloodPressureSystolic + (bpSystolicTarget - autonomic.bloodPressureSystolic) * 0.05 * dt, 80, 200),
    bloodPressureDiastolic: clamp(autonomic.bloodPressureDiastolic + (bpDiastolicTarget - autonomic.bloodPressureDiastolic) * 0.05 * dt, 50, 120),
    respirationRate: clamp(autonomic.respirationRate + (respRateTarget - autonomic.respirationRate) * 0.05 * dt, 6, 40),
    skinConductance: clamp(autonomic.skinConductance + (scTarget - autonomic.skinConductance) * 0.1 * dt, 0, 1),
    pupilDilation: clamp(autonomic.pupilDilation + (pupilTarget - autonomic.pupilDilation) * 0.1 * dt, 0, 1),
    digestion: clamp(autonomic.digestion + (digestionTarget - autonomic.digestion) * 0.05 * dt, 0, 1),
  };
}

/**
 * Metabolic System ↔ All Systems wiring
 * Energy substrate affects everything
 */
function metabolicWiring(
  metabolic: OrganismState['metabolic'],
  neuro: NeurochemFull,
  autonomic: OrganismState['autonomic'],
  motor: OrganismState['motor'],
  executive: OrganismState['executive'],
  dt: number
): { metabolic: OrganismState['metabolic']; neuroMod: Partial<NeurochemStimuli> } {
  // Glucose consumption by brain (constant high demand)
  const brainGlucoseUse = METABOLIC_BRAIN * (0.8 + executive.workingMemory * 0.2);
  
  // Glucose consumption by muscles
  const muscleActivity = motor.intention * (1 - motor.inhibition) * motor.velocity;
  const muscleGlucoseUse = METABOLIC_MUSCLE * muscleActivity;
  
  // Total glucose consumption
  const totalGlucoseUse = brainGlucoseUse + muscleGlucoseUse + 0.1; // Basal
  
  // Glucose dynamics
  const glucoseTarget = 90 - totalGlucoseUse * 50 + 
    (neuro.glucagon > 0.5 ? (neuro.glucagon - 0.5) * 20 : 0) -
    (neuro.insulin > 0.5 ? (neuro.insulin - 0.5) * 30 : 0);
  
  // ATP production (simplified)
  const oxygenAvailable = metabolic.oxygen > 0.9;
  const atpProduction = oxygenAvailable ? 
    metabolic.glucose / 100 * 0.1 :  // Aerobic
    metabolic.glucose / 100 * 0.02;  // Anaerobic (glycolysis only)
  
  // Lactate from anaerobic metabolism
  const lactateProduction = !oxygenAvailable && muscleActivity > 0.5 ? 
    (muscleActivity - 0.5) * 2 : 0;
  const lactateTarget = 1.0 + lactateProduction - 0.1; // Clearance
  
  // Temperature from metabolic rate and exercise
  const tempTarget = 37.0 + muscleActivity * 0.5 + 
    (autonomic.sympathetic > 0.7 ? (autonomic.sympathetic - 0.7) * 1.0 : 0);
  
  // Hydration affects everything
  const hydrationEffect = metabolic.hydration < 0.5 ? 
    -(0.5 - metabolic.hydration) * 0.5 : 0;
  
  // Low glucose triggers hunger and stress
  const hypoglycemiaStress = metabolic.glucose < 70 ? 
    (70 - metabolic.glucose) / 70 * 0.5 : 0;
  
  // Low oxygen triggers threat
  const hypoxiaThreat = metabolic.oxygen < 0.95 ? 
    (0.95 - metabolic.oxygen) * 5 : 0;
  
  return {
    metabolic: {
      glucose: clamp(metabolic.glucose + (glucoseTarget - metabolic.glucose) * 0.02 * dt, 40, 200),
      atp: clamp(metabolic.atp + (atpProduction - 0.05) * dt, 0, 1),
      oxygen: clamp(metabolic.oxygen + (0.98 - metabolic.oxygen) * 0.1 * dt, 0, 1), // Homeostatic
      lactate: clamp(metabolic.lactate + (lactateTarget - metabolic.lactate) * 0.05 * dt, 0, 20),
      pH: clamp(7.4 - metabolic.lactate * 0.01, 7.0, 7.6), // Lactate acidifies
      temperature: clamp(metabolic.temperature + (tempTarget - metabolic.temperature) * 0.02 * dt, 35, 42),
      hydration: clamp(metabolic.hydration - 0.001 * dt, 0, 1), // Slow dehydration
      fatReserves: clamp(metabolic.fatReserves, 0, 1),
      glycogen: clamp(metabolic.glycogen - totalGlucoseUse * 0.01 * dt, 0, 1),
    },
    neuroMod: {
      threat: hypoglycemiaStress + hypoxiaThreat,
      fatigue: (1 - metabolic.atp) * 0.3 + hydrationEffect,
    },
  };
}

/**
 * Gut-Brain Axis wiring
 * Bidirectional communication via vagus, neurotransmitters, immune
 */
function gutBrainWiring(
  gutBrain: OrganismState['gutBrain'],
  neuro: NeurochemFull,
  immune: OrganismState['immune'],
  stress: OrganismState['stress'],
  dt: number
): { gutBrain: OrganismState['gutBrain']; neuroMod: Partial<NeurochemStimuli> } {
  // Stress reduces vagal tone and increases gut permeability
  const stressGutEffect = stress.chronic * 0.3;
  
  // Cortisol affects gut
  const cortGutEffect = (neuro.cortisol - NEURO_BASELINES.cortisol) * 0.4;
  
  // Inflammation travels both ways
  const immuneGutEffect = immune.inflammation * 0.3;
  
  // SCFA production depends on microbiome health
  const scfaTarget = gutBrain.microbiotaDiversity * 0.8 * (1 - stress.chronic * 0.3);
  
  // Gut serotonin (90% of body's 5-HT produced in gut)
  const gutSerotoninTarget = gutBrain.microbiotaDiversity * 0.7 + neuro.tryptophan * 0.3;
  
  // Vagal tone enhanced by breathing exercises, reduced by stress
  const vagalTarget = 0.6 - stressGutEffect + (neuro.acetylcholine - 0.5) * 0.2;
  
  // Gut permeability (leaky gut)
  const permeabilityTarget = 0.2 + stressGutEffect + cortGutEffect + immuneGutEffect;
  
  // Motility affected by parasympathetic
  const motilityTarget = 0.5 + (neuro.acetylcholine - 0.5) * 0.3 - stress.acute * 0.3;
  
  // Gut inflammation
  const gutInflammationTarget = permeabilityTarget * 0.5 + immuneGutEffect;
  
  // Gut affects brain via vagus and NT
  const gutTobrainMood = (gutBrain.serotoninGut - 0.5) * 0.3 + (gutBrain.shortChainFattyAcids - 0.5) * 0.2;
  const gutInflammationToThreat = gutBrain.inflammationGut > 0.3 ? 
    (gutBrain.inflammationGut - 0.3) * 0.4 : 0;
  
  return {
    gutBrain: {
      microbiotaDiversity: clamp(gutBrain.microbiotaDiversity - stress.chronic * 0.01 * dt, 0, 1),
      shortChainFattyAcids: clamp(gutBrain.shortChainFattyAcids + (scfaTarget - gutBrain.shortChainFattyAcids) * 0.05 * dt, 0, 1),
      gutPermeability: clamp(gutBrain.gutPermeability + (permeabilityTarget - gutBrain.gutPermeability) * 0.03 * dt, 0, 1),
      vagalTone: clamp(gutBrain.vagalTone + (vagalTarget - gutBrain.vagalTone) * 0.05 * dt, 0, 1),
      serotoninGut: clamp(gutBrain.serotoninGut + (gutSerotoninTarget - gutBrain.serotoninGut) * 0.03 * dt, 0, 1),
      inflammationGut: clamp(gutBrain.inflammationGut + (gutInflammationTarget - gutBrain.inflammationGut) * 0.03 * dt, 0, 1),
      motility: clamp(gutBrain.motility + (motilityTarget - gutBrain.motility) * 0.05 * dt, 0, 1),
    },
    neuroMod: {
      reward: gutTobrainMood > 0 ? gutTobrainMood : 0,
      threat: gutInflammationToThreat + (gutTobrainMood < 0 ? -gutTobrainMood * 0.3 : 0),
    },
  };
}

/**
 * Stress System wiring
 * Acute vs chronic stress, allostatic load, resilience
 */
function stressWiring(
  stress: OrganismState['stress'],
  neuro: NeurochemFull,
  autonomic: OrganismState['autonomic'],
  immune: OrganismState['immune'],
  dt: number
): OrganismState['stress'] {
  // Acute stress from cortisol and catecholamines
  const acuteTarget = clamp(
    (neuro.cortisol - NEURO_BASELINES.cortisol) * 0.5 +
    (neuro.norepinephrine - NEURO_BASELINES.norepinephrine) * 0.3 +
    (neuro.epinephrine - NEURO_BASELINES.epinephrine) * 0.4,
    0, 1
  );
  
  // Chronic stress accumulates from sustained acute stress
  const chronicAccumulation = stress.acute > 0.5 ? (stress.acute - 0.5) * 0.01 : -0.005;
  
  // Resilience from BDNF, social support (oxytocin), parasympathetic tone
  const resilienceTarget = clamp(
    0.5 +
    (neuro.bdnf - NEURO_BASELINES.bdnf) * 0.3 +
    (neuro.oxytocin - NEURO_BASELINES.oxytocin) * 0.2 +
    (autonomic.parasympathetic - 0.5) * 0.2,
    0, 1
  );
  
  // Recovery rate depends on parasympathetic tone and resilience
  const recoveryTarget = clamp(
    0.5 + autonomic.parasympathetic * 0.3 + stress.resilience * 0.2,
    0, 1
  );
  
  // Allostatic load from chronic stress
  const allostasisTarget = clamp(
    0.3 + stress.chronic * 0.5 + immune.inflammation * 0.2,
    0, 1
  );
  
  // Telomere length (slowly decreases with chronic stress)
  const telomereDamage = stress.chronic > 0.5 ? (stress.chronic - 0.5) * 0.0001 : 0;
  
  // BDNF expression reduced by chronic stress
  const bdnfExpressionTarget = clamp(
    0.7 - stress.chronic * 0.4 + (neuro.serotonin - 0.5) * 0.2,
    0, 1
  );
  
  return {
    acute: clamp(stress.acute + (acuteTarget - stress.acute) * 0.15 * dt, 0, 1),
    chronic: clamp(stress.chronic + chronicAccumulation * dt, 0, 1),
    resilience: clamp(stress.resilience + (resilienceTarget - stress.resilience) * 0.02 * dt, 0, 1),
    recovery: clamp(stress.recovery + (recoveryTarget - stress.recovery) * 0.03 * dt, 0, 1),
    allostasis: clamp(stress.allostasis + (allostasisTarget - stress.allostasis) * 0.02 * dt, 0, 1),
    telomereLength: clamp(stress.telomereLength - telomereDamage * dt, 0, 1),
    bdnfExpression: clamp(stress.bdnfExpression + (bdnfExpressionTarget - stress.bdnfExpression) * 0.03 * dt, 0, 1),
  };
}

/**
 * Reward System wiring
 * Dopamine prediction error, motivation, wanting vs liking
 */
function rewardWiring(
  reward: OrganismState['reward'],
  neuro: NeurochemFull,
  emotion: OrganismState['emotion'],
  drives: OrganismState['drives'],
  dt: number
): { reward: OrganismState['reward']; neuroMod: Partial<NeurochemStimuli> } {
  // Anticipation from DA firing before reward
  const anticipationTarget = clamp(
    (neuro.dopamine - NEURO_BASELINES.dopamine) * 0.5 +
    drives.curiosity * 0.3 +
    drives.achievement * 0.2,
    0, 1
  );
  
  // Prediction error (TD error) - simplified
  const predictionError = reward.consummation - reward.prediction;
  
  // Motivation from DA and NE
  const motivationTarget = clamp(
    0.5 +
    (neuro.dopamine - NEURO_BASELINES.dopamine) * 0.4 +
    (neuro.norepinephrine - NEURO_BASELINES.norepinephrine) * 0.2 -
    reward.anhedonia * 0.4,
    0, 1
  );
  
  // Anhedonia from chronic stress, inflammation
  const anhedoniaTarget = clamp(
    emotion.valence < -0.3 ? (-emotion.valence - 0.3) * 0.3 : 0 +
    (neuro.dopamine < 0.4 ? (0.4 - neuro.dopamine) * 0.3 : 0),
    0, 1
  );
  
  // Wanting (incentive salience) - DA driven
  const wantingTarget = clamp(
    0.5 + (neuro.dopamine - 0.5) * 0.5 - reward.anhedonia * 0.3,
    0, 1
  );
  
  // Liking (hedonic impact) - opioid driven
  const likingTarget = clamp(
    0.5 + (neuro.endorphin - 0.5) * 0.4 + (neuro.oxytocin - 0.5) * 0.2,
    0, 1
  );
  
  // Reward feeds back to NT system
  const rewardStim = predictionError > 0 ? predictionError * 0.5 : 0;
  const disappointment = predictionError < 0 ? -predictionError * 0.3 : 0;
  
  return {
    reward: {
      anticipation: clamp(reward.anticipation + (anticipationTarget - reward.anticipation) * 0.1 * dt, 0, 1),
      consummation: clamp(reward.consummation * 0.95, 0, 1), // Decay
      prediction: clamp(reward.prediction + predictionError * 0.1 * dt, 0, 1), // Learn
      predictionError,
      anhedonia: clamp(reward.anhedonia + (anhedoniaTarget - reward.anhedonia) * 0.02 * dt, 0, 1),
      motivation: clamp(reward.motivation + (motivationTarget - reward.motivation) * 0.05 * dt, 0, 1),
      liking: clamp(reward.liking + (likingTarget - reward.liking) * 0.05 * dt, 0, 1),
      wanting: clamp(reward.wanting + (wantingTarget - reward.wanting) * 0.05 * dt, 0, 1),
    },
    neuroMod: {
      reward: rewardStim,
      threat: disappointment,
    },
  };
}

/**
 * Pain System wiring
 * Nociception, descending modulation, central sensitization
 */
function painWiring(
  pain: OrganismState['pain'],
  neuro: NeurochemFull,
  emotion: OrganismState['emotion'],
  attention: number,
  dt: number
): { pain: OrganismState['pain']; neuroMod: Partial<NeurochemStimuli> } {
  // Endogenous opioids from endorphins and enkephalins
  const endogenousOpioidsTarget = clamp(
    neuro.endorphin * 0.6 + neuro.enkephalin * 0.3,
    0, 1
  );
  
  // Descending modulation (PAG, RVM) - serotonin and NE involved
  const descendingModulation = clamp(
    0.5 +
    (neuro.serotonin - 0.5) * 0.3 +
    (neuro.norepinephrine - 0.5) * 0.2 +
    endogenousOpioidsTarget * 0.3,
    0, 1
  );
  
  // Perceived pain = nociception - modulation + attention amplification
  const attentionAmplification = attention > 0.7 ? (attention - 0.7) * 0.3 : 0;
  const perceivedPain = clamp(
    pain.nociception * (1 - descendingModulation * 0.5) + attentionAmplification,
    0, 1
  );
  
  // Central sensitization from chronic pain
  const centralizationTarget = clamp(
    pain.perception > 0.5 && pain.nociception < 0.3 ? 0.1 : -0.05,
    0, 1
  );
  
  // Catastrophizing from negative emotion and low acceptance
  const catastrophizingTarget = clamp(
    (emotion.valence < 0 ? -emotion.valence * 0.3 : 0) +
    (1 - pain.acceptance) * 0.2,
    0, 1
  );
  
  // Pain acceptance reduces suffering
  const acceptanceTarget = clamp(
    0.5 + (neuro.serotonin - 0.5) * 0.2 + emotion.stability * 0.2,
    0, 1
  );
  
  // Pain feeds back to NT
  const painThreat = pain.perception > 0.3 ? (pain.perception - 0.3) * 0.5 : 0;
  const painFatigue = pain.perception > 0.5 ? (pain.perception - 0.5) * 0.4 : 0;
  
  return {
    pain: {
      nociception: clamp(pain.nociception * 0.99, 0, 1), // Slow decay
      perception: perceivedPain,
      modulation: descendingModulation,
      endogenousOpioids: clamp(pain.endogenousOpioids + (endogenousOpioidsTarget - pain.endogenousOpioids) * 0.05 * dt, 0, 1),
      centralization: clamp(pain.centralization + (centralizationTarget - pain.centralization) * 0.01 * dt, 0, 1),
      catastrophizing: clamp(pain.catastrophizing + (catastrophizingTarget - pain.catastrophizing) * 0.03 * dt, 0, 1),
      acceptance: clamp(pain.acceptance + (acceptanceTarget - pain.acceptance) * 0.02 * dt, 0, 1),
    },
    neuroMod: {
      threat: painThreat,
      fatigue: painFatigue,
    },
  };
}

/**
 * Social Brain wiring
 * Attachment, empathy, theory of mind
 */
function socialWiring(
  social: OrganismState['social'],
  neuro: NeurochemFull,
  emotion: OrganismState['emotion'],
  drives: OrganismState['drives'],
  dt: number
): { social: OrganismState['social']; neuroMod: Partial<NeurochemStimuli> } {
  // Oxytocin from social interaction
  const oxytocinTarget = clamp(
    neuro.oxytocin * 0.7 + drives.social * 0.3,
    0, 1
  );
  
  // Vasopressin for pair bonding
  const vasopressinTarget = clamp(
    neuro.vasopressin * 0.8,
    0, 1
  );
  
  // Empathy enhanced by oxytocin and serotonin
  const empathyTarget = clamp(
    0.5 + oxytocinTarget * 0.3 + (neuro.serotonin - 0.5) * 0.2,
    0, 1
  );
  
  // Theory of mind depends on PFC function
  const tomTarget = clamp(
    0.6 + (neuro.dopamine - 0.5) * 0.2 + (neuro.acetylcholine - 0.5) * 0.2,
    0, 1
  );
  
  // Social anxiety from threat system
  const socialAnxietyTarget = clamp(
    (neuro.cortisol - 0.5) * 0.4 + (neuro.norepinephrine > 0.6 ? (neuro.norepinephrine - 0.6) * 0.3 : 0),
    0, 1
  );
  
  // Rejection pain
  const rejectionDecay = social.rejection > 0 ? -0.01 : 0;
  
  // Belongingness from oxytocin and social drive satisfaction
  const belongingnessTarget = clamp(
    oxytocinTarget * 0.4 + (1 - drives.social) * 0.3 + (1 - social.socialAnxiety) * 0.3,
    0, 1
  );
  
  // Social interaction affects NT
  const socialReward = social.belongingness > 0.5 ? (social.belongingness - 0.5) * 0.3 : 0;
  const socialThreat = social.socialAnxiety > 0.5 ? (social.socialAnxiety - 0.5) * 0.3 : 0;
  const socialNeed = drives.social > 0.7 ? (drives.social - 0.7) * 0.4 : 0;
  
  return {
    social: {
      attachment: clamp(social.attachment + (oxytocinTarget - social.attachment) * 0.02 * dt, 0, 1),
      empathy: clamp(social.empathy + (empathyTarget - social.empathy) * 0.03 * dt, 0, 1),
      theoryOfMind: clamp(social.theoryOfMind + (tomTarget - social.theoryOfMind) * 0.02 * dt, 0, 1),
      socialAnxiety: clamp(social.socialAnxiety + (socialAnxietyTarget - social.socialAnxiety) * 0.05 * dt, 0, 1),
      belongingness: clamp(social.belongingness + (belongingnessTarget - social.belongingness) * 0.03 * dt, 0, 1),
      rejection: clamp(social.rejection + rejectionDecay * dt, 0, 1),
      oxytocin: clamp(social.oxytocin + (oxytocinTarget - social.oxytocin) * 0.05 * dt, 0, 1),
      vasopressin: clamp(social.vasopressin + (vasopressinTarget - social.vasopressin) * 0.05 * dt, 0, 1),
    },
    neuroMod: {
      reward: socialReward,
      threat: socialThreat,
      social: socialNeed,
    },
  };
}

/**
 * Sleep Architecture wiring
 * Sleep stages, pressure, consolidation
 */
function sleepWiring(
  sleep: OrganismState['sleep'],
  neuro: NeurochemFull,
  circadian: OrganismState['circadian'],
  metabolic: OrganismState['metabolic'],
  dt: number
): OrganismState['sleep'] {
  // Adenosine (sleep pressure) builds during wake
  const adenosineBuildup = sleep.stage === 'WAKE' ? 0.001 : -0.002;
  
  // Sleep onset triggered by melatonin + sleep pressure
  const sleepOnsetDrive = circadian.melatonin * 0.5 + sleep.pressure * 0.5;
  
  // Determine sleep stage transitions
  let newStage = sleep.stage;
  let cyclePosition = sleep.cyclePosition;
  
  if (sleep.stage === 'WAKE') {
    if (sleepOnsetDrive > 0.7 && circadian.alertness < 0.4) {
      newStage = 'N1';
      cyclePosition = 0;
    }
  } else {
    // Progress through sleep cycle (90 min = 5400 seconds)
    cyclePosition += dt / 5400;
    if (cyclePosition >= 1) {
      cyclePosition = 0;
    }
    
    // Simplified sleep stage progression
    if (cyclePosition < 0.1) newStage = 'N1';
    else if (cyclePosition < 0.35) newStage = 'N2';
    else if (cyclePosition < 0.55) newStage = 'N3';
    else if (cyclePosition < 0.7) newStage = 'N2';
    else newStage = 'REM';
    
    // Wake if alertness high or external disruption
    if (circadian.alertness > 0.7 || neuro.norepinephrine > 0.7) {
      newStage = 'WAKE';
    }
  }
  
  // Sleep features
  const spindles = newStage === 'N2' ? 0.6 : 0;
  const kComplexes = newStage === 'N2' ? 0.5 : 0;
  const slowWaveActivity = newStage === 'N3' ? 0.8 : 0;
  const remDensity = newStage === 'REM' ? 0.6 : 0;
  
  // Total sleep time
  const sleepTime = newStage !== 'WAKE' ? sleep.totalSleepTime + dt : sleep.totalSleepTime;
  
  // Sleep efficiency
  const efficiency = sleepTime > 0 ? 
    Math.min(sleepTime / (sleepTime + sleep.pressure * 1000), 1) : 0;
  
  return {
    pressure: clamp(sleep.pressure + adenosineBuildup * dt, 0, 1),
    stage: newStage,
    cyclePosition,
    spindles,
    kComplexes,
    slowWaveActivity,
    remDensity,
    totalSleepTime: sleepTime,
    sleepEfficiency: efficiency,
  };
}

/**
 * Physics Engine wiring — Ising, Lorenz, entropy, Φ
 * The mathematical substrate of consciousness
 */
function physicsEngineWiring(
  physics: OrganismState['physics'],
  neuro: NeurochemFull,
  r: number,
  kf: number,
  emergence: number,
  dt: number
): OrganismState['physics'] {
  // Ising temperature from arousal and cortisol
  const targetTemp = ISING_TC + 
    (neuro.cortisol - 0.5) * 0.5 +
    (neuro.norepinephrine - 0.5) * 0.3;
  
  // Magnetization (order parameter) from coherence
  const magnetizationTarget = r * 0.8;
  
  // Correlation length peaks at criticality
  const criticalDistance = Math.abs(physics.isingTemperature - ISING_TC);
  const correlationTarget = criticalDistance < 0.5 ? 1 - criticalDistance * 2 : 0.1;
  
  // Lorenz attractor evolution
  const sigma = LORENZ_SIGMA;
  const rho = LORENZ_RHO + (neuro.norepinephrine - 0.5) * 5;
  const beta = LORENZ_BETA;
  
  const dx = sigma * (physics.lorenzY - physics.lorenzX) * dt * 0.1;
  const dy = (physics.lorenzX * (rho - physics.lorenzZ) - physics.lorenzY) * dt * 0.1;
  const dz = (physics.lorenzX * physics.lorenzY - beta * physics.lorenzZ) * dt * 0.1;
  
  const newX = physics.lorenzX + dx;
  const newY = physics.lorenzY + dy;
  const newZ = physics.lorenzZ + dz;
  
  // Divergence (chaos level)
  const divergence = Math.sqrt(dx * dx + dy * dy + dz * dz);
  
  // Entropy production (non-equilibrium thermodynamics)
  const entropyTarget = 0.5 + (1 - r) * 0.3 + divergence * 0.1;
  
  // Free energy (Friston's free energy principle)
  const freeEnergyTarget = 0.5 - r * 0.3 + (1 - kf) * 0.2;
  
  // Information integration Φ (consciousness proxy)
  const phiTarget = clamp(
    r * 0.4 + 
    kf * 0.3 + 
    emergence * 0.3 + 
    correlationTarget * 0.2 -
    physics.lorenzDivergence * 0.2,
    0, 1
  );
  
  return {
    isingTemperature: clamp(physics.isingTemperature + (targetTemp - physics.isingTemperature) * 0.1 * dt, 0.5, 5),
    isingMagnetization: clamp(physics.isingMagnetization + (magnetizationTarget - physics.isingMagnetization) * 0.1 * dt, -1, 1),
    isingCorrelation: clamp(physics.isingCorrelation + (correlationTarget - physics.isingCorrelation) * 0.1 * dt, 0, 1),
    lorenzX: newX,
    lorenzY: newY,
    lorenzZ: newZ,
    lorenzDivergence: clamp(divergence, 0, 1),
    entropyProduction: clamp(physics.entropyProduction + (entropyTarget - physics.entropyProduction) * 0.05 * dt, 0, 1),
    freeEnergy: clamp(physics.freeEnergy + (freeEnergyTarget - physics.freeEnergy) * 0.05 * dt, 0, 1),
    informationIntegration: clamp(physics.informationIntegration + (phiTarget - physics.informationIntegration) * 0.03 * dt, 0, 1),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN TICK — The unified organism update — EVERYTHING INTERTWINES
// ═══════════════════════════════════════════════════════════════════════════════

export function organismTick(prev: OrganismState): OrganismState {
  const beat = prev.beat + 1;
  const dt = NEURO_DT;
  
  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 1: COLLECT ALL STIMULI FROM ALL SYSTEMS (EVERYTHING FEEDS IN)
  // ════════════════════════════════════════════════════════════════════════════
  
  // Core system stimuli
  const emergenceStim = emergenceToNeuro(prev.r, prev.kf, prev.emergence);
  const driveStim = drivesToNeuro(prev.drives);
  const immuneStim = immuneToNeuro(prev.immune);
  const olfactoryStim = olfactoryToNeuro(prev.olfactory);
  const circadianStim = circadianToNeuro(prev.circadian);
  
  // Deep intertwined system wiring — all affect NT
  const motorResult = motorNeuroWiring(prev.motor, prev.neuro, dt);
  const executiveResult = executiveNeuroWiring(prev.executive, prev.neuro, prev.emergence, dt);
  const emotionResult = emotionNeuroWiring(prev.emotion, prev.neuro, prev.r, dt);
  const memoryResult = memoryNeuroSleepWiring(prev.memory, prev.neuro, prev.sleep, prev.hz, dt);
  const gutBrainResult = gutBrainWiring(prev.gutBrain, prev.neuro, prev.immune, prev.stress, dt);
  const rewardResult = rewardWiring(prev.reward, prev.neuro, prev.emotion, prev.drives, dt);
  const painResult = painWiring(prev.pain, prev.neuro, prev.emotion, prev.executive.attention, dt);
  const socialResult = socialWiring(prev.social, prev.neuro, prev.emotion, prev.drives, dt);
  const metabolicResult = metabolicWiring(prev.metabolic, prev.neuro, prev.autonomic, prev.motor, prev.executive, dt);
  
  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 2: COMBINE ALL STIMULI INTO UNIFIED NEUROCHEMICAL SIGNAL
  // ════════════════════════════════════════════════════════════════════════════
  
  const combinedStim: NeurochemStimuli = {
    reward: clamp(
      (emergenceStim.reward || 0) + 
      (driveStim.reward || 0) + 
      (olfactoryStim.reward || 0) + 
      (immuneStim.reward || 0) +
      (motorResult.neuroMod.reward || 0) +
      (emotionResult.neuroMod.reward || 0) +
      (gutBrainResult.neuroMod.reward || 0) +
      (rewardResult.neuroMod.reward || 0) +
      (socialResult.neuroMod.reward || 0),
      0, 1
    ),
    threat: clamp(
      (emergenceStim.threat || 0) + 
      (driveStim.threat || 0) + 
      (olfactoryStim.threat || 0) + 
      (immuneStim.threat || 0) +
      (emotionResult.neuroMod.threat || 0) +
      (gutBrainResult.neuroMod.threat || 0) +
      (rewardResult.neuroMod.threat || 0) +
      (painResult.neuroMod.threat || 0) +
      (socialResult.neuroMod.threat || 0) +
      (metabolicResult.neuroMod.threat || 0),
      0, 1
    ),
    social: clamp(
      (emergenceStim.social || 0) + 
      (driveStim.social || 0) + 
      (olfactoryStim.social || 0) +
      (socialResult.neuroMod.social || 0),
      0, 1
    ),
    learning: clamp(
      (emergenceStim.learning || 0) + 
      (driveStim.learning || 0) +
      (executiveResult.neuroMod.learning || 0) +
      (memoryResult.neuroMod.learning || 0),
      0, 1
    ),
    arousal: clamp(
      (emergenceStim.arousal || 0) + 
      (driveStim.arousal || 0) + 
      (circadianStim.arousal || 0) +
      (emotionResult.neuroMod.arousal || 0),
      0, 1
    ),
    flow: clamp(
      (emergenceStim.flow || 0) + 
      (motorResult.neuroMod.flow || 0),
      0, 1
    ),
    pain: prev.pain.perception,
    fatigue: clamp(
      (emergenceStim.fatigue || 0) + 
      (immuneStim.fatigue || 0) + 
      (circadianStim.fatigue || 0) +
      (motorResult.neuroMod.fatigue || 0) +
      (executiveResult.neuroMod.fatigue || 0) +
      (memoryResult.neuroMod.fatigue || 0) +
      (painResult.neuroMod.fatigue || 0) +
      (metabolicResult.neuroMod.fatigue || 0),
      0, 1
    ),
  };
  
  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 3: UPDATE CORE NEUROCHEMISTRY
  // ════════════════════════════════════════════════════════════════════════════
  
  const neuro = neurochemFullStep(prev.neuro, combinedStim, dt);
  
  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 4: UPDATE ALL OSCILLATOR SYSTEMS
  // ════════════════════════════════════════════════════════════════════════════
  
  // Neurochemistry → Emergence modulation
  const neuroEmergenceMod = neuroToEmergence(neuro);
  
  // Genesis (breath, first experiences)
  const genesis = genesisTick(prev.genesis, dt, prev.kf);
  
  // Kuramoto (organ synchronization) with NT coupling modulation
  const physicsMod = neuroToPhysics(neuro);
  const kuramoto = kuramotoTick(prev.kuramoto, dt, 0.5 + physicsMod.couplingMod);
  
  // Lyapunov (stability)
  const lyapunov = lyapunovTick(prev.lyapunov, kuramoto.r, prev.kf, prev.emergence);
  
  // Quantum (coherence, entanglement)
  const quantum = quantumTick(prev.quantum, dt, kuramoto.r);
  
  // Hz substrate (brainwaves)
  const hz = hzTick(prev.hz, dt, kuramoto.r);
  
  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 5: COMPUTE GLOBAL COHERENCE METRICS (r, kf, emergence)
  // ════════════════════════════════════════════════════════════════════════════
  
  const metalCoh = metalCoherenceContribution(prev.metals);
  
  // Global coherence r — integrates ALL systems
  const r = clamp(
    kuramoto.r * 0.25 + 
    genesis.kfHz * 0.15 + 
    quantum.coherence * 0.15 + 
    metalCoh * 0.05 +
    neuroEmergenceMod.rMod +
    prev.autonomic.heartRateVariability * 0.1 +
    prev.gutBrain.vagalTone * 0.1 +
    (1 - prev.stress.chronic) * 0.1 +
    prev.physics.informationIntegration * 0.1,
    0, 1
  );
  
  // Frequency coherence kf
  const kf = clamp(
    hz.kf * 0.3 + 
    genesis.kfHz * 0.2 + 
    kuramoto.r * 0.15 +
    neuroEmergenceMod.kfMod +
    prev.memory.hippocampalTheta * 0.15 +
    (1 - prev.physics.lorenzDivergence) * 0.1 +
    prev.executive.attention * 0.1,
    0, 1
  );
  
  // Emergence — the whole being more than sum of parts
  const emergence = clamp(
    sigmoid(PHI * (r - 0.5) * Math.sqrt(r * kf)) * 0.5 +
    neuroEmergenceMod.emergenceMod +
    prev.physics.informationIntegration * 0.2 +
    prev.executive.creativity * 0.1 +
    prev.physics.isingCorrelation * 0.1 +
    (1 - prev.physics.freeEnergy) * 0.1,
    0, 1
  );
  
  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 6: UPDATE ALL INTERCONNECTED SYSTEMS
  // ════════════════════════════════════════════════════════════════════════════
  
  // Drives from neurochemistry
  const drives = neuroToDrives(neuro, prev.drives);
  
  // Immune from neurochemistry
  const immune = neuroToImmune(neuro, prev.immune);
  
  // Olfactory processing
  const olfactory = {
    ...prev.olfactory,
    emotionalValence: clamp(
      (neuro.dopamine * 0.4 + neuro.serotonin * 0.3) -
      (neuro.cortisol * 0.4 + neuro.substanceP * 0.2),
      -1, 1
    ),
  };
  
  // Circadian rhythm
  const circadianPhase = (prev.circadian.phase + 0.0001 * dt) % TAU;
  const circadian = {
    phase: circadianPhase,
    melatonin: clamp(0.5 + 0.4 * Math.cos(circadianPhase + PI), 0, 1),
    cortisol: clamp(0.4 + 0.3 * Math.cos(circadianPhase), 0, 1),
    alertness: clamp(0.5 - 0.3 * Math.cos(circadianPhase), 0, 1),
  };
  
  // Sensory systems
  const sensory = sensoryNeuroWiring(prev.sensory, neuro, circadian, dt);
  
  // Autonomic nervous system
  const autonomic = autonomicWiring(prev.autonomic, neuro, prev.stress, emotionResult.emotion, genesis.breath, dt);
  
  // Stress system
  const stress = stressWiring(prev.stress, neuro, autonomic, immune, dt);
  
  // Sleep architecture
  const sleep = sleepWiring(prev.sleep, neuro, circadian, metabolicResult.metabolic, dt);
  
  // Physics engine (Ising, Lorenz, Φ)
  const physics = physicsEngineWiring(prev.physics, neuro, r, kf, emergence, dt);
  
  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 7: COMPUTE DERIVED METRICS
  // ════════════════════════════════════════════════════════════════════════════
  
  const vitality = vitalityScore(neuro) * 0.4 + 
    metabolicResult.metabolic.atp * 0.2 +
    (1 - stress.chronic) * 0.2 +
    autonomic.heartRateVariability * 0.1 +
    (1 - immune.inflammation) * 0.1;
    
  const neuroplasticity = neuroplasticityFactor(neuro);
  const alloLoad = allostaticLoad(neuro);
  const stability = lyapunov.stability * 0.5 + 
    emotionResult.emotion.stability * 0.25 +
    (1 - physics.lorenzDivergence) * 0.25;
  const entanglement = quantum.entanglement;
  const decoherence = quantum.decoherence;
  
  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 8: UPDATE HISTORY
  // ════════════════════════════════════════════════════════════════════════════
  
  const history = {
    r: [...prev.history.r.slice(-499), r],
    kf: [...prev.history.kf.slice(-499), kf],
    emergence: [...prev.history.emergence.slice(-499), emergence],
    vitality: [...prev.history.vitality.slice(-499), vitality],
    neuro: [...prev.history.neuro.slice(-99), Object.values(neuro)],
  };
  
  // ════════════════════════════════════════════════════════════════════════════
  // RETURN COMPLETE UNIFIED ORGANISM STATE
  // ════════════════════════════════════════════════════════════════════════════
  
  return {
    beat,
    dt,
    r,
    kf,
    emergence,
    vitality,
    neuro,
    metals: prev.metals,
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
    // New systems
    motor: motorResult.motor,
    sensory,
    executive: executiveResult.executive,
    emotion: emotionResult.emotion,
    memory: memoryResult.memory,
    metabolic: metabolicResult.metabolic,
    autonomic,
    gutBrain: gutBrainResult.gutBrain,
    sleep,
    reward: rewardResult.reward,
    stress,
    pain: painResult.pain,
    social: socialResult.social,
    physics,
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
