// ─── NOVA / PARALLAX — Full Neurochemistry Engine ────────────────────────────
// Full port of MedinaMathFoundation neurochemDecay + neurochemFullDecay
// 21-species neurochemical system with proper half-lives, Michaelis-Menten
// kinetics, cross-modulation, and metal pipeline.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, LN2, sigmoid, sf, SOVEREIGN_FLOOR } from './core';

// ── Half-life constants (beats, from MedinaMathFoundation.mo) ────────────────
export const HALFLIFE: Readonly<Record<string, number>> = {
  dopamine:       20.0,
  serotonin:      40.0,
  norepinephrine: 17.5,
  epinephrine:    11.5,
  acetylcholine:  17.5,
  gaba:           15.4,
  glycine:        20.0,
  glutamate:      12.6,
  oxytocin:       23.1,
  vasopressin:    34.7,
  endorphin:      27.7,
  substanceP:     13.9,
  npy:            23.1,
  adenosine:      34.7,
  anandamide:     23.1,
  twoAG:          20.0,
  nitricOxide:     9.9,
  bdnf:           46.2,
  ngf:            69.3,
  cortisol:       57.8,
  testosterone:   86.6,
};

// λ = ln(2) / t½   (decay rate from half-life)
export function halfLifeToDecayRate(halfLife: number): number {
  return LN2 / Math.max(0.1, halfLife);
}

// ── Full 21-species neurochemical state ───────────────────────────────────────
export interface NeurochemFull {
  dopamine:       number;  // reward, motivation
  serotonin:      number;  // mood, social
  norepinephrine: number;  // arousal, alertness
  epinephrine:    number;  // fight/flight
  acetylcholine:  number;  // learning, memory
  gaba:           number;  // inhibitory, calm
  glycine:        number;  // inhibitory, motor
  glutamate:      number;  // excitatory, plasticity
  oxytocin:       number;  // bonding, trust
  vasopressin:    number;  // social memory, loyalty
  endorphin:      number;  // pain relief, reward
  substanceP:     number;  // pain transmission
  npy:            number;  // stress buffering, hunger
  adenosine:      number;  // sleep pressure, fatigue
  anandamide:     number;  // bliss, creativity
  twoAG:          number;  // endocannabinoid
  nitricOxide:    number;  // vasodilation, signaling
  bdnf:           number;  // neuroplasticity, growth
  ngf:            number;  // neuron survival
  cortisol:       number;  // stress response
  testosterone:   number;  // dominance, drive
}

// ── Stimuli inputs ────────────────────────────────────────────────────────────
export interface NeurochemStimuli {
  reward:   number;  // ∈ [0,1]
  threat:   number;  // ∈ [0,1]
  social:   number;  // ∈ [0,1]
  learning: number;  // ∈ [0,1]
  arousal:  number;  // ∈ [0,1]
  flow:     number;  // ∈ [0,1] — cognitive flow state
  pain:     number;  // ∈ [0,1]
  fatigue:  number;  // ∈ [0,1]
}

// Baselines (homeostatic equilibria)
export const NEURO_BASELINES: NeurochemFull = {
  dopamine:       0.55, serotonin:     0.60, norepinephrine: 0.45,
  epinephrine:    0.20, acetylcholine: 0.50, gaba:           0.65,
  glycine:        0.55, glutamate:     0.50, oxytocin:       0.40,
  vasopressin:    0.45, endorphin:     0.50, substanceP:     0.30,
  npy:            0.50, adenosine:     0.35, anandamide:     0.35,
  twoAG:          0.40, nitricOxide:   0.45, bdnf:           0.60,
  ngf:            0.55, cortisol:      0.40, testosterone:   0.50,
};

// ── Single-species Michaelis-Menten / ODE step ────────────────────────────────
// dC/dt = P·stim·(1 − C/Cmax) − λ·(C − Cbase)
// Euler integration with dt
export function neurochemDecayStep(
  current:    number,
  baseline:   number,
  maximum:    number,
  decayRate:  number,
  production: number,
  stimulus:   number,
  dt:         number
): number {
  const productionTerm = production * stimulus * (1 - current / maximum);
  const decayTerm      = decayRate * (current - baseline);
  return clamp(current + (productionTerm - decayTerm) * dt, 0, maximum);
}

// ── Full 21-species decay step with cross-modulation ─────────────────────────
// Cross-modulation:
//   cortisolInhibition = 1 − cortisol·0.3   (stress suppresses reward/bonding)
//   dopamineModulation = 1 + dopamine·0.2   (reward boosts acetylcholine)
export function neurochemFullStep(
  state:   NeurochemFull,
  stimuli: NeurochemStimuli,
  dt:      number = 0.05
): NeurochemFull {
  const cortisolInhib  = clamp(1 - state.cortisol * 0.3, 0.1, 1.5);
  const dopamineMod    = clamp(1 + state.dopamine * 0.2, 0.5, 2.0);
  const adenosinePress = clamp(state.adenosine * 0.4, 0, 0.8);

  const step = (
    key:        keyof NeurochemFull,
    baseline:   number,
    production: number,
    stimulus:   number
  ) => neurochemDecayStep(
    state[key], baseline, 1.0,
    halfLifeToDecayRate(HALFLIFE[key] ?? 20),
    production, stimulus, dt
  );

  return {
    dopamine:       step('dopamine',       0.55, 0.04, stimuli.reward * cortisolInhib + stimuli.flow * 0.5),
    serotonin:      step('serotonin',      0.60, 0.03, stimuli.social * cortisolInhib),
    norepinephrine: step('norepinephrine', 0.45, 0.035, stimuli.threat * 0.5 + stimuli.arousal * 0.5),
    epinephrine:    step('epinephrine',    0.20, 0.015, stimuli.threat * stimuli.arousal),
    acetylcholine:  step('acetylcholine',  0.50, 0.045, stimuli.learning * dopamineMod),
    gaba:           step('gaba',           0.65, 0.05, 1 - stimuli.arousal * 0.7),
    glycine:        step('glycine',        0.55, 0.04, 1 - stimuli.threat * 0.4),
    glutamate:      step('glutamate',      0.50, 0.06, stimuli.arousal * 0.5 + stimuli.learning * 0.5),
    oxytocin:       step('oxytocin',       0.40, 0.02, stimuli.social * cortisolInhib),
    vasopressin:    step('vasopressin',    0.45, 0.015, stimuli.social * 0.5 + stimuli.threat * 0.3),
    endorphin:      step('endorphin',      0.50, 0.025, stimuli.pain + stimuli.flow * 0.4),
    substanceP:     step('substanceP',     0.30, 0.02, stimuli.pain),
    npy:            step('npy',            0.50, 0.025, stimuli.fatigue * 0.5 + cortisolInhib * 0.3),
    adenosine:      step('adenosine',      0.35, 0.03, stimuli.fatigue),
    anandamide:     step('anandamide',     0.35, 0.015, stimuli.flow * 0.6 + stimuli.reward * 0.3),
    twoAG:          step('twoAG',          0.40, 0.012, stimuli.flow * 0.5),
    nitricOxide:    step('nitricOxide',    0.45, 0.02, stimuli.arousal * 0.4 + stimuli.social * 0.3),
    bdnf:           step('bdnf',           0.60, 0.018, stimuli.learning * dopamineMod + stimuli.flow * 0.3),
    ngf:            step('ngf',            0.55, 0.012, stimuli.learning * 0.6),
    cortisol:       step('cortisol',       0.40, 0.04, stimuli.threat + stimuli.fatigue * 0.5 - stimuli.flow * 0.3),
    testosterone:   step('testosterone',   0.50, 0.01, stimuli.reward * 0.4 + stimuli.threat * 0.2),
  };
}

// ── Neurochemical vector → 4-species projection ───────────────────────────────
// Project full 21-species state to the 4-species used in drone minds:
// DOPAMINE, CORTISOL, NOREPINEPHRINE, OXYTOCIN (with sovereign floor S₀=1.0)
export interface NeuroChem4 {
  dopamine:       number;
  cortisol:       number;
  norepinephrine: number;
  oxytocin:       number;
}

export function projectTo4Species(full: NeurochemFull): NeuroChem4 {
  // Scale from [0,1] to [1,2] range (sovereign floor is 1.0)
  // These map to the 4-species ODE system used in drone cognition
  return {
    dopamine:       sf(1 + full.dopamine),
    cortisol:       sf(1 + full.cortisol),
    norepinephrine: sf(1 + full.norepinephrine * 0.8 + full.epinephrine * 0.2),
    oxytocin:       sf(1 + full.oxytocin * 0.7 + full.vasopressin * 0.3),
  };
}

// ── Metal Pipeline (from MedinaMathFoundation.mo metalPipeline) ───────────────
// Metals are performance enhancers / sovereign resources:
// GOLD=coherence, SILVER=conductance, IRON=strength, COPPER=transmission,
// PLATINUM=precision, TITANIUM=resilience, LITHIUM=stability,
// COBALT=rotation(degrees), MERCURY=fluidity, TUNGSTEN=density
// ZINC=growth, OSMIUM=mass
export interface MetalState {
  gold:      number;  // coherence amplifier ∈ [0,10]
  silver:    number;  // conductance (L-121 sovereignty law) ∈ [0,10]
  iron:      number;  // structural strength ∈ [0,10]
  copper:    number;  // signal transmission ∈ [0,10]
  platinum:  number;  // precision ∈ [0,10]
  titanium:  number;  // resilience ∈ [0,10]
  lithium:   number;  // stability ∈ [0,10]
  cobalt:    number;  // rotation ∈ [0,360°]
  mercury:   number;  // fluidity ∈ [0,10]
  tungsten:  number;  // density / inertia ∈ [0,10]
  zinc:      number;  // growth factor ∈ [0,10]
  osmium:    number;  // mass/momentum ∈ [0,10]
}

export const METAL_BASELINES: MetalState = {
  gold: 5, silver: 5, iron: 5, copper: 5, platinum: 5, titanium: 5,
  lithium: 5, cobalt: 180, mercury: 5, tungsten: 5, zinc: 5, osmium: 5,
};

// Metal → coherence contribution
// C_metal = (gold/10)·0.15 + (silver/10)·0.10 + (platinum/10)·0.05
export function metalCoherenceContribution(metals: MetalState): number {
  return clamp(
    (metals.gold / 10) * 0.15 +
    (metals.silver / 10) * 0.10 +
    (metals.platinum / 10) * 0.05,
    0, 0.30
  );
}

// Metal pipeline step: metals slowly regenerate toward baseline
export function metalPipelineStep(metals: MetalState, dt: number = 0.05): MetalState {
  const recover = (v: number, base: number, max: number, rate: number = 0.01) =>
    clamp(v + (base - v) * rate * dt, 0, max);
  return {
    gold:     recover(metals.gold,     5, 10),
    silver:   recover(metals.silver,   5, 10),
    iron:     recover(metals.iron,     5, 10),
    copper:   recover(metals.copper,   5, 10),
    platinum: recover(metals.platinum, 5, 10),
    titanium: recover(metals.titanium, 5, 10),
    lithium:  recover(metals.lithium,  5, 10),
    cobalt:   recover(metals.cobalt, 180, 360, 0.005),
    mercury:  recover(metals.mercury,  5, 10),
    tungsten: recover(metals.tungsten, 5, 10),
    zinc:     recover(metals.zinc,     5, 10),
    osmium:   recover(metals.osmium,   5, 10),
  };
}

// ── Vitality score (from MedinaMathFoundation.mo computeVitality) ─────────────
// V_vital = w₁·dopamine + w₂·(1-cortisol) + w₃·oxytocin + w₄·bdnf + w₅·anandamide
//           − w₆·adenosine − w₇·substanceP
export function vitalityScore(chem: NeurochemFull): number {
  return clamp(
    0.25 * chem.dopamine +
    0.20 * (1 - chem.cortisol) +
    0.15 * chem.oxytocin +
    0.15 * chem.bdnf +
    0.10 * chem.anandamide -
    0.10 * chem.adenosine -
    0.05 * chem.substanceP,
    0, 1
  );
}

// ── Neuroplasticity factor (BDNF + NGF gate learning) ────────────────────────
// η_neuro = η_base · (1 + BDNF·0.5 + NGF·0.3)
export function neuroplasticityFactor(chem: NeurochemFull, baseRate: number = 0.005): number {
  return baseRate * clamp(1 + chem.bdnf * 0.5 + chem.ngf * 0.3, 0.5, 3.0);
}

// ── Allostatic load (cumulative stress burden) ─────────────────────────────────
// L_allostatic = cortisol·0.40 + epinephrine·0.25 + norepinephrine·0.20 + substanceP·0.15
export function allostaticLoad(chem: NeurochemFull): number {
  return clamp(
    chem.cortisol * 0.40 +
    chem.epinephrine * 0.25 +
    chem.norepinephrine * 0.20 +
    chem.substanceP * 0.15,
    0, 1
  );
}
