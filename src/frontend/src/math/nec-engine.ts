// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// Neural Emergence Core (NEC) simulation engine — TypeScript port of the Motoko NeuralEmergenceCore module.
// Pure functional, no React.

export type RegionCategory = 'Cortical' | 'Subcortical' | 'Brainstem' | 'Cerebellar' | 'Limbic';
export type APPhase = 'Resting' | 'Rising' | 'Repolarizing' | 'Hyperpolarizing' | 'Refractory';

export interface IonChannels {
  na: number;
  k: number;
  ca: number;
  cl: number;
}

export interface LIFState {
  voltage: number;
  membraneCap: number;
  leakCond: number;
  spikeThreshold: number;
  refractoryTicks: number;
  spikeRate: number;
  excInput: number;
  inhInput: number;
}

export interface RegionState {
  id: number;
  name: string;
  category: RegionCategory;
  activation: number;
  deficit: number;
  hebbianWeight: number;
  lif: LIFState;
  channels: IonChannels;
  apPhase: APPhase;
  lfp: number;
  deltaPower: number;
  thetaPower: number;
  alphaPower: number;
  betaPower: number;
  gammaPower: number;
}

export interface NECChemState {
  dopamine: number;
  serotonin: number;
  norepinephrine: number;
  acetylcholine: number;
  gaba: number;
  glutamate: number;
  endorphin: number;
  adenosine: number;
  ldopa: number;
  dopac: number;
  substanceP: number;
  npy: number;
  vip: number;
  crh: number;
  crf: number;
  cck: number;
  enkephalin: number;
  dynorphin: number;
  galanin: number;
  estradiol: number;
  testosterone: number;
  dhea: number;
  progesterone: number;
  allopregnanolone: number;
  taurine: number;
  glycine: number;
  dSerine: number;
  aspartate: number;
  nitricOxide: number;
  carbonMonoxide: number;
  hydrogenSulfide: number;
  atp: number;
  adp: number;
  tyramine: number;
  tryptamine: number;
  aea: number;
  twoAG: number;
  bdnf: number;
  ngf: number;
  cortisol: number;
  epinephrine: number;
  vasopressin: number;
  oxytocin: number;
  melatonin: number;
  histamine: number;
  noSynthase: number;
}

export interface FiberTract {
  id: number;
  name: string;
  sourceRegion: number;
  targetRegion: number;
  conductionVel: number;
  myelinationRatio: number;
  axonalDensity: number;
  synapticDelayMs: number;
  signalStrength: number;
}

export interface NECState {
  beat: number;
  regions: RegionState[];
  chem: NECChemState;
  tracts: FiberTract[];
  globalCoherence: number;
  emergenceIndex: number;
}

// ── Region definitions (100 regions) ─────────────────────────────────────────

const REGION_DEFS: Array<{ id: number; name: string; category: RegionCategory }> = [
  // Cortical (0–43 = 44 regions)
  { id: 0,  name: 'BA1 Primary Somatosensory',       category: 'Cortical' },
  { id: 1,  name: 'BA2 Somatosensory Assoc',          category: 'Cortical' },
  { id: 2,  name: 'BA3 Primary Somatosensory II',     category: 'Cortical' },
  { id: 3,  name: 'BA4 Primary Motor',                category: 'Cortical' },
  { id: 4,  name: 'BA5 Somatosensory Assoc II',       category: 'Cortical' },
  { id: 5,  name: 'BA6 Premotor',                     category: 'Cortical' },
  { id: 6,  name: 'BA7 Superior Parietal',            category: 'Cortical' },
  { id: 7,  name: 'BA8 Frontal Eye Field',            category: 'Cortical' },
  { id: 8,  name: 'BA9 Prefrontal DLPFC',             category: 'Cortical' },
  { id: 9,  name: 'BA10 Frontopolar',                 category: 'Cortical' },
  { id: 10, name: 'BA11 Orbitofrontal',               category: 'Cortical' },
  { id: 11, name: 'BA17 Primary Visual V1',           category: 'Cortical' },
  { id: 12, name: 'BA18 Visual Assoc V2',             category: 'Cortical' },
  { id: 13, name: 'BA19 Visual Assoc V3',             category: 'Cortical' },
  { id: 14, name: 'BA20 Inferior Temporal',           category: 'Cortical' },
  { id: 15, name: 'BA21 Middle Temporal',             category: 'Cortical' },
  { id: 16, name: 'BA22 Superior Temporal',           category: 'Cortical' },
  { id: 17, name: 'BA23 Posterior Cingulate',         category: 'Cortical' },
  { id: 18, name: 'BA24 Anterior Cingulate',          category: 'Cortical' },
  { id: 19, name: 'BA25 Subgenual Cingulate',         category: 'Cortical' },
  { id: 20, name: 'BA28 Entorhinal Cortex',           category: 'Cortical' },
  { id: 21, name: 'BA34 Piriform Cortex',             category: 'Cortical' },
  { id: 22, name: 'BA37 Fusiform',                    category: 'Cortical' },
  { id: 23, name: 'BA38 Temporal Pole',               category: 'Cortical' },
  { id: 24, name: 'BA39 Angular Gyrus',               category: 'Cortical' },
  { id: 25, name: 'BA40 Supramarginal Gyrus',         category: 'Cortical' },
  { id: 26, name: 'BA41 Primary Auditory',            category: 'Cortical' },
  { id: 27, name: 'BA42 Auditory Assoc',              category: 'Cortical' },
  { id: 28, name: 'BA43 Subcentral',                  category: 'Cortical' },
  { id: 29, name: 'BA44 Broca pars opercularis',      category: 'Cortical' },
  { id: 30, name: 'BA45 Broca pars triangularis',     category: 'Cortical' },
  { id: 31, name: 'BA46 DLPFC Mid',                   category: 'Cortical' },
  { id: 32, name: 'BA47 Inferior Frontal Gyrus',      category: 'Cortical' },
  { id: 33, name: 'Supplementary Motor Area',         category: 'Cortical' },
  { id: 34, name: 'Insula Anterior',                  category: 'Cortical' },
  { id: 35, name: 'Insula Posterior',                 category: 'Cortical' },
  { id: 36, name: 'Medial Prefrontal Cortex',         category: 'Cortical' },
  { id: 37, name: 'Lateral Orbitofrontal Cortex',     category: 'Cortical' },
  { id: 38, name: 'Ventromedial PFC',                 category: 'Cortical' },
  { id: 39, name: 'Retrosplenial Cortex',             category: 'Cortical' },
  { id: 40, name: 'Parahippocampal Gyrus',            category: 'Cortical' },
  { id: 41, name: 'Primary Olfactory Cortex',         category: 'Cortical' },
  { id: 42, name: 'Premotor Cortex II',               category: 'Cortical' },
  { id: 43, name: 'Paracentral Lobule',               category: 'Cortical' },
  // Extra Cortical to reach 46 total cortical
  { id: 44, name: 'Intraparietal Sulcus',             category: 'Cortical' },
  { id: 45, name: 'Precuneus',                        category: 'Cortical' },
  // Subcortical (46–66 = 21 regions)
  { id: 46, name: 'Caudate Nucleus',                  category: 'Subcortical' },
  { id: 47, name: 'Putamen',                          category: 'Subcortical' },
  { id: 48, name: 'Nucleus Accumbens',                category: 'Subcortical' },
  { id: 49, name: 'Globus Pallidus Internal',         category: 'Subcortical' },
  { id: 50, name: 'Globus Pallidus External',         category: 'Subcortical' },
  { id: 51, name: 'Subthalamic Nucleus',              category: 'Subcortical' },
  { id: 52, name: 'Thalamus Mediodorsal',             category: 'Subcortical' },
  { id: 53, name: 'Thalamus Ventral Anterior',        category: 'Subcortical' },
  { id: 54, name: 'Thalamus Ventral Lateral',         category: 'Subcortical' },
  { id: 55, name: 'Thalamus Pulvinar',                category: 'Subcortical' },
  { id: 56, name: 'Thalamus Lateral Geniculate',      category: 'Subcortical' },
  { id: 57, name: 'Thalamus Medial Geniculate',       category: 'Subcortical' },
  { id: 58, name: 'Hypothalamus Lateral',             category: 'Subcortical' },
  { id: 59, name: 'Hypothalamus Medial',              category: 'Subcortical' },
  { id: 60, name: 'Hypothalamus Arcuate',             category: 'Subcortical' },
  { id: 61, name: 'Hypothalamus Suprachiasmatic',     category: 'Subcortical' },
  { id: 62, name: 'Hypothalamus Paraventricular',     category: 'Subcortical' },
  { id: 63, name: 'Claustrum',                        category: 'Subcortical' },
  { id: 64, name: 'Nucleus Basalis Meynert',          category: 'Subcortical' },
  { id: 65, name: 'Habenula',                         category: 'Subcortical' },
  { id: 66, name: 'Septum Medial',                    category: 'Subcortical' },
  // Limbic (67–73 = 7 regions)
  { id: 67, name: 'Amygdala Basolateral',             category: 'Limbic' },
  { id: 68, name: 'Amygdala Central',                 category: 'Limbic' },
  { id: 69, name: 'Amygdala Medial',                  category: 'Limbic' },
  { id: 70, name: 'Hippocampus CA1',                  category: 'Limbic' },
  { id: 71, name: 'Hippocampus CA3',                  category: 'Limbic' },
  { id: 72, name: 'Hippocampus Dentate Gyrus',        category: 'Limbic' },
  { id: 73, name: 'Hippocampus Subiculum',            category: 'Limbic' },
  // Brainstem (74–91 = 18 regions)
  { id: 74, name: 'Locus Coeruleus',                  category: 'Brainstem' },
  { id: 75, name: 'Dorsal Raphe',                     category: 'Brainstem' },
  { id: 76, name: 'Median Raphe',                     category: 'Brainstem' },
  { id: 77, name: 'Substantia Nigra Pars Compacta',   category: 'Brainstem' },
  { id: 78, name: 'Substantia Nigra Pars Reticulata', category: 'Brainstem' },
  { id: 79, name: 'VTA Ventral Tegmental Area',       category: 'Brainstem' },
  { id: 80, name: 'Periaqueductal Gray',              category: 'Brainstem' },
  { id: 81, name: 'Superior Colliculus',              category: 'Brainstem' },
  { id: 82, name: 'Inferior Colliculus',              category: 'Brainstem' },
  { id: 83, name: 'Pedunculopontine Nucleus',         category: 'Brainstem' },
  { id: 84, name: 'Dorsal Motor Vagus',               category: 'Brainstem' },
  { id: 85, name: 'Nucleus Tractus Solitarius',       category: 'Brainstem' },
  { id: 86, name: 'Parabrachial Nucleus',             category: 'Brainstem' },
  { id: 87, name: 'Pontine Reticular Formation',      category: 'Brainstem' },
  { id: 88, name: 'Medullary Reticular Formation',    category: 'Brainstem' },
  { id: 89, name: 'Red Nucleus',                      category: 'Brainstem' },
  { id: 90, name: 'Cochlear Nucleus',                 category: 'Brainstem' },
  { id: 91, name: 'Cranial Nerve VII Nucleus',        category: 'Brainstem' },
  // Cerebellar (92–99 = 8 regions)
  { id: 92, name: 'Cerebellar Molecular Layer',       category: 'Cerebellar' },
  { id: 93, name: 'Cerebellar Purkinje Layer',        category: 'Cerebellar' },
  { id: 94, name: 'Cerebellar Granule Layer',         category: 'Cerebellar' },
  { id: 95, name: 'Cerebellar Dentate Nucleus',       category: 'Cerebellar' },
  { id: 96, name: 'Cerebellar Interposed Nucleus',    category: 'Cerebellar' },
  { id: 97, name: 'Cerebellar Fastigial Nucleus',     category: 'Cerebellar' },
  { id: 98, name: 'Cerebellar Vermis',                category: 'Cerebellar' },
  { id: 99, name: 'Cerebellar Flocculus',             category: 'Cerebellar' },
];

export { REGION_DEFS };

// ── Fiber tract definitions ───────────────────────────────────────────────────

const FIBER_TRACTS: FiberTract[] = [
  { id: 0, name: 'Corpus Callosum',                   sourceRegion: 8,  targetRegion: 9,  conductionVel: 70, myelinationRatio: 0.95, axonalDensity: 0.95, synapticDelayMs: 1.0, signalStrength: 0.5 },
  { id: 1, name: 'Internal Capsule',                  sourceRegion: 3,  targetRegion: 44, conductionVel: 60, myelinationRatio: 0.90, axonalDensity: 0.88, synapticDelayMs: 1.5, signalStrength: 0.5 },
  { id: 2, name: 'Arcuate Fasciculus',                sourceRegion: 29, targetRegion: 21, conductionVel: 50, myelinationRatio: 0.85, axonalDensity: 0.80, synapticDelayMs: 2.0, signalStrength: 0.5 },
  { id: 3, name: 'Superior Longitudinal Fasciculus',  sourceRegion: 8,  targetRegion: 6,  conductionVel: 45, myelinationRatio: 0.80, axonalDensity: 0.75, synapticDelayMs: 2.5, signalStrength: 0.5 },
  { id: 4, name: 'Inferior Longitudinal Fasciculus',  sourceRegion: 14, targetRegion: 11, conductionVel: 40, myelinationRatio: 0.75, axonalDensity: 0.72, synapticDelayMs: 3.0, signalStrength: 0.5 },
  { id: 5, name: 'Uncinate Fasciculus',               sourceRegion: 10, targetRegion: 65, conductionVel: 35, myelinationRatio: 0.70, axonalDensity: 0.68, synapticDelayMs: 3.5, signalStrength: 0.5 },
  { id: 6, name: 'Fornix',                            sourceRegion: 68, targetRegion: 56, conductionVel: 30, myelinationRatio: 0.65, axonalDensity: 0.60, synapticDelayMs: 4.0, signalStrength: 0.5 },
  { id: 7, name: 'Cingulum',                          sourceRegion: 18, targetRegion: 20, conductionVel: 45, myelinationRatio: 0.78, axonalDensity: 0.74, synapticDelayMs: 2.3, signalStrength: 0.5 },
  { id: 8, name: 'Optic Radiation',                   sourceRegion: 53, targetRegion: 11, conductionVel: 55, myelinationRatio: 0.88, axonalDensity: 0.85, synapticDelayMs: 1.8, signalStrength: 0.5 },
  { id: 9, name: 'Corticospinal Tract',               sourceRegion: 3,  targetRegion: 85, conductionVel: 70, myelinationRatio: 0.92, axonalDensity: 0.90, synapticDelayMs: 1.2, signalStrength: 0.5 },
];

// ── Helpers ───────────────────────────────────────────────────────────────────

function clamp(v: number, lo: number, hi: number): number {
  return v < lo ? lo : v > hi ? hi : v;
}

function sigmoid(x: number): number {
  return 1 / (1 + Math.exp(-x));
}

function defaultLIF(): LIFState {
  return {
    voltage: -65,
    membraneCap: 100,
    leakCond: 10,
    spikeThreshold: -50,
    refractoryTicks: 0,
    spikeRate: 5,
    excInput: 0.5,
    inhInput: 0.3,
  };
}

function defaultChannels(): IonChannels {
  return { na: 0.3, k: 0.4, ca: 0.1, cl: 0.2 };
}

function defaultRegion(def: { id: number; name: string; category: RegionCategory }): RegionState {
  return {
    id: def.id,
    name: def.name,
    category: def.category,
    activation: 0.5,
    deficit: 0,
    hebbianWeight: 0.5,
    lif: defaultLIF(),
    channels: defaultChannels(),
    apPhase: 'Resting',
    lfp: 0,
    deltaPower: 0.15,
    thetaPower: 0.15,
    alphaPower: 0.15,
    betaPower: 0.15,
    gammaPower: 0.15,
  };
}

function defaultChem(): NECChemState {
  return {
    dopamine: 0.55,
    serotonin: 0.60,
    norepinephrine: 0.45,
    acetylcholine: 0.50,
    gaba: 0.65,
    glutamate: 0.50,
    endorphin: 0.50,
    adenosine: 0.35,
    ldopa: 0.40,
    dopac: 0.38,
    substanceP: 0.42,
    npy: 0.45,
    vip: 0.40,
    crh: 0.35,
    crf: 0.35,
    cck: 0.40,
    enkephalin: 0.48,
    dynorphin: 0.44,
    galanin: 0.40,
    estradiol: 0.45,
    testosterone: 0.42,
    dhea: 0.40,
    progesterone: 0.38,
    allopregnanolone: 0.36,
    taurine: 0.50,
    glycine: 0.48,
    dSerine: 0.42,
    aspartate: 0.45,
    nitricOxide: 0.38,
    carbonMonoxide: 0.32,
    hydrogenSulfide: 0.30,
    atp: 0.55,
    adp: 0.40,
    tyramine: 0.35,
    tryptamine: 0.38,
    aea: 0.42,
    twoAG: 0.45,
    bdnf: 0.55,
    ngf: 0.50,
    cortisol: 0.40,
    epinephrine: 0.38,
    vasopressin: 0.42,
    oxytocin: 0.48,
    melatonin: 0.35,
    histamine: 0.40,
    noSynthase: 0.38,
  };
}

// ── Public API ────────────────────────────────────────────────────────────────

export function initNEC(): NECState {
  return {
    beat: 0,
    regions: REGION_DEFS.map(defaultRegion),
    chem: defaultChem(),
    tracts: FIBER_TRACTS.map(t => ({ ...t })),
    globalCoherence: 0.5,
    emergenceIndex: 0.5,
  };
}

function tickRegion(r: RegionState, beat: number, chem: NECChemState): RegionState {
  const dt = 0.873;
  let lif = { ...r.lif };
  let apPhase = r.apPhase;
  let activation = r.activation;

  // Neurochemical modulation of excInput by category
  let chemMod = 0;
  if (r.category === 'Cortical') {
    chemMod = (chem.glutamate - 0.5) * 0.4 + (chem.dopamine - 0.5) * 0.3 - (chem.gaba - 0.5) * 0.3;
  } else if (r.category === 'Subcortical') {
    chemMod = (chem.dopamine - 0.5) * 0.5 + (chem.acetylcholine - 0.5) * 0.2 - (chem.adenosine - 0.35) * 0.2;
  } else if (r.category === 'Limbic') {
    chemMod = (chem.serotonin - 0.5) * 0.4 + (chem.oxytocin - 0.5) * 0.3 + (chem.cortisol - 0.4) * -0.2;
  } else if (r.category === 'Brainstem') {
    chemMod = (chem.norepinephrine - 0.5) * 0.4 + (chem.epinephrine - 0.4) * 0.3;
  } else if (r.category === 'Cerebellar') {
    chemMod = (chem.gaba - 0.5) * -0.3 + (chem.glutamate - 0.5) * 0.3;
  }

  const excInput = clamp(lif.excInput + chemMod * 0.05, 0, 2);
  lif = { ...lif, excInput };

  // LIF Euler step
  const dV = dt * (-lif.leakCond * (lif.voltage - (-65)) + lif.excInput - lif.inhInput) / lif.membraneCap;

  let voltage = lif.voltage + dV;
  let refractoryTicks = lif.refractoryTicks;
  let spikeRate = lif.spikeRate;

  if (refractoryTicks > 0) {
    voltage = -65;
    refractoryTicks -= 1;
    apPhase = 'Refractory';
  } else if (voltage >= lif.spikeThreshold) {
    voltage = 40;
    refractoryTicks = 5;
    apPhase = 'Rising';
    spikeRate = Math.min(spikeRate + 1, 200);
  } else if (apPhase === 'Rising') {
    apPhase = 'Repolarizing';
    voltage = -70;
  } else if (apPhase === 'Repolarizing') {
    apPhase = 'Hyperpolarizing';
    voltage = -75;
  } else if (apPhase === 'Hyperpolarizing') {
    apPhase = 'Resting';
    voltage = -65;
  }

  // LFP
  const lfp = 200 * (activation - 0.5) + 50 * Math.sin(beat * 0.1 + r.id * 0.1);

  // Frequency bands based on spikeRate
  const sr = spikeRate;
  const deltaPower  = clamp(1 - sr / 10, 0, 1) * 0.3 + 0.05;
  const thetaPower  = clamp(sr < 20 ? sr / 20 : 1 - (sr - 20) / 80, 0, 1) * 0.25 + 0.05;
  const alphaPower  = clamp(sr < 15 ? sr / 15 : 1 - (sr - 15) / 85, 0, 1) * 0.25 + 0.05;
  const betaPower   = clamp(sr > 15 && sr < 60 ? (sr - 15) / 45 : sr >= 60 ? 1 - (sr - 60) / 40 : 0, 0, 1) * 0.3 + 0.05;
  const gammaPower  = clamp((sr - 40) / 60, 0, 1) * 0.35 + 0.05;

  // Activation update
  activation = clamp(activation * 0.95 + (voltage - (-65)) / 115 * 0.05, 0, 1);

  // Hebbian: small nudge toward correlated neighbours (simplified)
  const hebbianWeight = clamp(r.hebbianWeight + 0.001 * (activation - 0.5), 0, 1);

  return {
    ...r,
    lif: { ...lif, voltage, refractoryTicks, spikeRate },
    apPhase,
    lfp,
    deltaPower,
    thetaPower,
    alphaPower,
    betaPower,
    gammaPower,
    activation,
    hebbianWeight,
  };
}

function tickTracts(tracts: FiberTract[], regions: RegionState[]): FiberTract[] {
  return tracts.map(t => {
    const src = regions[t.sourceRegion];
    const tgt = regions[t.targetRegion];
    if (!src || !tgt) return t;
    const propagated = src.activation * t.myelinationRatio * t.axonalDensity;
    const newStrength = clamp(t.signalStrength * 0.9 + propagated * 0.1, 0, 1);
    return { ...t, signalStrength: newStrength };
  });
}

function tickChem(chem: NECChemState, regions: RegionState[]): NECChemState {
  const meanAct = regions.reduce((s, r) => s + r.activation, 0) / regions.length;
  const decay = 0.001;
  const base = defaultChem();
  const result: NECChemState = {} as NECChemState;
  for (const key of Object.keys(chem) as Array<keyof NECChemState>) {
    const baseline = base[key];
    const current = chem[key];
    // Decay toward baseline, slight modulation by mean activity
    result[key] = clamp(current - decay * (current - baseline) + 0.0005 * (meanAct - 0.5), 0, 1);
  }
  return result;
}

export function tickNEC(state: NECState, beat: number): NECState {
  const regions = state.regions.map(r => tickRegion(r, beat, state.chem));
  const tracts = tickTracts(state.tracts, regions);
  const chem = tickChem(state.chem, regions);

  const meanActivation = regions.reduce((s, r) => s + r.activation, 0) / regions.length;
  const globalCoherence = clamp(meanActivation, 0, 1);
  const emergenceIndex = sigmoid((globalCoherence - 0.5) * 5);

  return {
    beat,
    regions,
    chem,
    tracts,
    globalCoherence,
    emergenceIndex,
  };
}

export interface NECSummary {
  beat: number;
  globalCoherence: number;
  emergenceIndex: number;
  topRegion: { name: string; activation: number };
  meanSpikeRate: number;
  meanLFP: number;
  bandMeans: { delta: number; theta: number; alpha: number; beta: number; gamma: number };
  topChemicals: Array<{ name: string; value: number }>;
}

export function summarizeNEC(state: NECState): NECSummary {
  const { regions, chem, beat, globalCoherence, emergenceIndex } = state;

  const topRegion = regions.reduce((best, r) => r.activation > best.activation ? r : best, regions[0]);
  const meanSpikeRate = regions.reduce((s, r) => s + r.lif.spikeRate, 0) / regions.length;
  const meanLFP = regions.reduce((s, r) => s + r.lfp, 0) / regions.length;

  const bandMeans = {
    delta: regions.reduce((s, r) => s + r.deltaPower, 0) / regions.length,
    theta: regions.reduce((s, r) => s + r.thetaPower, 0) / regions.length,
    alpha: regions.reduce((s, r) => s + r.alphaPower, 0) / regions.length,
    beta:  regions.reduce((s, r) => s + r.betaPower,  0) / regions.length,
    gamma: regions.reduce((s, r) => s + r.gammaPower,  0) / regions.length,
  };

  const KEY_CHEMS: Array<keyof NECChemState> = [
    'dopamine', 'serotonin', 'norepinephrine', 'acetylcholine', 'gaba',
    'glutamate', 'endorphin', 'adenosine', 'bdnf', 'oxytocin',
    'cortisol', 'histamine', 'melatonin', 'nitricOxide', 'atp',
  ];
  const topChemicals = KEY_CHEMS
    .map(k => ({ name: k, value: chem[k] }))
    .sort((a, b) => b.value - a.value)
    .slice(0, 5);

  return {
    beat,
    globalCoherence,
    emergenceIndex,
    topRegion: { name: topRegion.name, activation: topRegion.activation },
    meanSpikeRate,
    meanLFP,
    bandMeans,
    topChemicals,
  };
}
