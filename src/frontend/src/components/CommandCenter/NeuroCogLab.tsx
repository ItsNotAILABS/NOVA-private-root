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
// NEUROTRANSMITTER RECEPTOR TYPES & KINETICS
// ═══════════════════════════════════════════════════════════════════════════════
// Receptors are the molecular targets of neurotransmitters. They can be:
// 1. Ionotropic (ligand-gated ion channels): fast, direct ion flux
//    - NMDA, AMPA, GABAA, 5-HT3, nicotinic ACh receptors
//    - Time scale: 1-10 ms
// 2. Metabotropic (G-protein coupled): slower, second messenger cascades
//    - D1-5, 5-HT1/2/4/6/7, muscarinic ACh, GABAB, mGluRs
//    - Time scale: 100 ms - seconds
//
// Receptor binding follows law of mass action:
//   R + L ⇌ RL
//   [RL]/[R]total = [L]/([L] + Kd)
// where Kd = koff/kon is the dissociation constant
//
interface ReceptorKinetics {
  type: string;
  Kd: number;      // Dissociation constant (μM)
  Bmax: number;    // Maximum binding sites
  kon: number;     // Association rate (μM⁻¹·s⁻¹)
  koff: number;    // Dissociation rate (s⁻¹)
  efficacy: number; // [0,1] intrinsic activity
}

// Dopamine receptors
const DA_RECEPTORS: Record<string, ReceptorKinetics> = {
  D1: { type: 'Gs-coupled', Kd: 0.3, Bmax: 1.0, kon: 5e6, koff: 1.5, efficacy: 0.9 },
  D2: { type: 'Gi-coupled', Kd: 0.5, Bmax: 0.8, kon: 3e6, koff: 1.5, efficacy: 0.85 },
  D3: { type: 'Gi-coupled', Kd: 0.2, Bmax: 0.4, kon: 7e6, koff: 1.4, efficacy: 0.8 },
  D4: { type: 'Gi-coupled', Kd: 0.4, Bmax: 0.3, kon: 4e6, koff: 1.6, efficacy: 0.75 },
  D5: { type: 'Gs-coupled', Kd: 0.25, Bmax: 0.5, kon: 6e6, koff: 1.5, efficacy: 0.88 },
};

// Serotonin receptors
const SER_RECEPTORS: Record<string, ReceptorKinetics> = {
  '5HT1A': { type: 'Gi-coupled', Kd: 0.6, Bmax: 1.0, kon: 3e6, koff: 1.8, efficacy: 0.9 },
  '5HT1B': { type: 'Gi-coupled', Kd: 0.5, Bmax: 0.7, kon: 3.5e6, koff: 1.75, efficacy: 0.85 },
  '5HT2A': { type: 'Gq-coupled', Kd: 0.8, Bmax: 0.9, kon: 2.5e6, koff: 2.0, efficacy: 0.92 },
  '5HT2C': { type: 'Gq-coupled', Kd: 0.7, Bmax: 0.6, kon: 2.8e6, koff: 1.96, efficacy: 0.88 },
  '5HT3': { type: 'Ionotropic', Kd: 0.3, Bmax: 0.5, kon: 8e6, koff: 2.4, efficacy: 1.0 },
  '5HT4': { type: 'Gs-coupled', Kd: 0.4, Bmax: 0.4, kon: 5e6, koff: 2.0, efficacy: 0.8 },
  '5HT6': { type: 'Gs-coupled', Kd: 0.35, Bmax: 0.3, kon: 6e6, koff: 2.1, efficacy: 0.75 },
  '5HT7': { type: 'Gs-coupled', Kd: 0.45, Bmax: 0.5, kon: 4.5e6, koff: 2.025, efficacy: 0.82 },
};

// GABA receptors
const GABA_RECEPTORS: Record<string, ReceptorKinetics> = {
  GABAA: { type: 'Cl- channel', Kd: 0.15, Bmax: 1.2, kon: 1e7, koff: 1.5, efficacy: 1.0 },
  GABAB: { type: 'Gi-coupled', Kd: 0.5, Bmax: 0.6, kon: 4e6, koff: 2.0, efficacy: 0.85 },
};

// Glutamate receptors
const GLU_RECEPTORS: Record<string, ReceptorKinetics> = {
  NMDA: { type: 'Ca2+/Na+ channel', Kd: 1.2, Bmax: 1.0, kon: 2e6, koff: 2.4, efficacy: 1.0 },
  AMPA: { type: 'Na+/K+ channel', Kd: 0.5, Bmax: 1.5, kon: 5e6, koff: 2.5, efficacy: 1.0 },
  Kainate: { type: 'Na+/K+ channel', Kd: 0.8, Bmax: 0.7, kon: 3e6, koff: 2.4, efficacy: 0.9 },
  mGluR1: { type: 'Gq-coupled', Kd: 1.5, Bmax: 0.5, kon: 1.5e6, koff: 2.25, efficacy: 0.85 },
  mGluR2: { type: 'Gi-coupled', Kd: 1.0, Bmax: 0.6, kon: 2e6, koff: 2.0, efficacy: 0.8 },
};

// ═══════════════════════════════════════════════════════════════════════════════
// NEUROTRANSMITTER SYNTHESIS PATHWAYS
// ═══════════════════════════════════════════════════════════════════════════════
// Neurotransmitter synthesis occurs in neuronal cell bodies and terminals.
// Rate-limiting enzymes control synthesis speed:
//   - Tyrosine hydroxylase (TH): rate-limiting for catecholamines (DA, NE, EPI)
//   - Tryptophan hydroxylase (TPH): rate-limiting for serotonin
//   - Choline acetyltransferase (ChAT): synthesizes acetylcholine
//
// Synthesis requires:
//   1. Precursor amino acids (tyrosine, tryptophan) from diet/BBB transport
//   2. Cofactors (BH4, Fe²⁺, Cu²⁺, pyridoxal phosphate)
//   3. ATP energy
//   4. Molecular oxygen (for hydroxylation steps)
//
// Regulation occurs via:
//   - End-product inhibition (DA inhibits TH)
//   - Phosphorylation (PKA/CaMKII activate TH)
//   - Cofactor availability (BH4 levels)
//   - Precursor availability (tryptophan competes with other large neutral amino acids)
//
interface SynthesisPathway {
  precursor: string;
  steps: { enzyme: string; product: string; rateConstant: number }[];
  cofactors: string[];
}

const DA_SYNTHESIS: SynthesisPathway = {
  precursor: 'Tyrosine',
  steps: [
    { enzyme: 'Tyrosine hydroxylase', product: 'L-DOPA', rateConstant: 0.05 },
    { enzyme: 'DOPA decarboxylase', product: 'Dopamine', rateConstant: 0.12 },
  ],
  cofactors: ['BH4', 'Fe2+', 'O2', 'Pyridoxal phosphate'],
};

const NE_SYNTHESIS: SynthesisPathway = {
  precursor: 'Dopamine',
  steps: [
    { enzyme: 'Dopamine β-hydroxylase', product: 'Norepinephrine', rateConstant: 0.08 },
  ],
  cofactors: ['Ascorbate', 'Cu2+', 'O2'],
};

const EPI_SYNTHESIS: SynthesisPathway = {
  precursor: 'Norepinephrine',
  steps: [
    { enzyme: 'PNMT', product: 'Epinephrine', rateConstant: 0.06 },
  ],
  cofactors: ['S-adenosylmethionine'],
};

const SER_SYNTHESIS: SynthesisPathway = {
  precursor: 'Tryptophan',
  steps: [
    { enzyme: 'Tryptophan hydroxylase', product: '5-HTP', rateConstant: 0.04 },
    { enzyme: '5-HTP decarboxylase', product: 'Serotonin', rateConstant: 0.10 },
  ],
  cofactors: ['BH4', 'Fe2+', 'O2', 'Pyridoxal phosphate'],
};

const ACH_SYNTHESIS: SynthesisPathway = {
  precursor: 'Choline + Acetyl-CoA',
  steps: [
    { enzyme: 'Choline acetyltransferase', product: 'Acetylcholine', rateConstant: 0.15 },
  ],
  cofactors: [],
};

// ═══════════════════════════════════════════════════════════════════════════════
// REUPTAKE TRANSPORTER KINETICS
// ═══════════════════════════════════════════════════════════════════════════════
// Neurotransmitter reuptake is the primary mechanism for signal termination.
// Transporters are Na⁺-dependent symporters that use the Na⁺ gradient to drive
// NT uptake against its concentration gradient.
//
// Key transporters:
//   - DAT (dopamine transporter): SLC6A3, 12 transmembrane domains
//   - SERT (serotonin transporter): SLC6A4, target of SSRIs
//   - NET (norepinephrine transporter): SLC6A2
//   - GAT1 (GABA transporter): SLC6A1
//   - EAAT1-5 (glutamate transporters): SLC1A family
//
// Michaelis-Menten kinetics:
//   V = Vmax·[NT] / (Km + [NT])
// where Km is the concentration at half-maximal velocity
//
// Pharmacology:
//   - Cocaine blocks DAT, SERT, NET → ↑synaptic monoamines
//   - SSRIs (fluoxetine, sertraline) block SERT → ↑5-HT
//   - Methylphenidate blocks DAT/NET → ↑DA/NE (ADHD treatment)
//   - Amphetamine reverses DAT → releases DA into synapse
//
interface TransporterKinetics {
  name: string;
  Km: number;      // Michaelis constant (μM)
  Vmax: number;    // Maximum velocity (μM/s)
  turnover: number; // molecules/s
}

const TRANSPORTERS: Record<string, TransporterKinetics> = {
  DAT: { name: 'Dopamine transporter', Km: 0.6, Vmax: 4.0, turnover: 60 },
  SERT: { name: 'Serotonin transporter', Km: 0.3, Vmax: 2.5, turnover: 50 },
  NET: { name: 'Norepinephrine transporter', Km: 0.5, Vmax: 3.0, turnover: 55 },
  VMAT2: { name: 'Vesicular monoamine transporter', Km: 1.2, Vmax: 5.0, turnover: 80 },
  VAChT: { name: 'Vesicular ACh transporter', Km: 1.5, Vmax: 6.0, turnover: 100 },
  GAT1: { name: 'GABA transporter', Km: 0.8, Vmax: 3.5, turnover: 70 },
  EAAT1: { name: 'Glutamate transporter', Km: 1.0, Vmax: 4.5, turnover: 75 },
};

// ═══════════════════════════════════════════════════════════════════════════════
// DEGRADATION ENZYME KINETICS
// ═══════════════════════════════════════════════════════════════════════════════
// Enzymatic degradation is critical for neurotransmitter clearance and recycling.
//
// Monoamine Oxidase (MAO):
//   - MAO-A: preferentially degrades 5-HT, NE, EPI (also DA)
//   - MAO-B: preferentially degrades DA, phenylethylamine
//   - Location: outer mitochondrial membrane
//   - Reaction: RCH2NH2 + O2 + H2O → RCHO + NH3 + H2O2
//   - Pharmacology: MAO inhibitors (selegiline, phenelzine) → ↑monoamines
//
// Catechol-O-Methyltransferase (COMT):
//   - Methylates catecholamines (DA, NE, EPI) using SAM as methyl donor
//   - Two forms: membrane-bound (MB-COMT) and soluble (S-COMT)
//   - Val158Met polymorphism affects COMT activity → individual differences in PFC DA
//   - Inhibitors: entacapone, tolcapone (Parkinson's disease)
//
// Acetylcholinesterase (AChE):
//   - Among fastest enzymes known: kcat ≈ 25,000 s⁻¹ (diffusion-limited)
//   - Hydrolyzes ACh → choline + acetate in <1 ms
//   - Located in synaptic cleft, tightly associated with basal lamina
//   - Inhibitors: donepezil (Alzheimer's), sarin nerve gas (irreversible)
//
// Fatty Acid Amide Hydrolase (FAAH):
//   - Degrades endocannabinoid anandamide
//   - Serine hydrolase family
//   - Inhibition → ↑anandamide → analgesia, anxiolysis
//
interface EnzymeKinetics {
  name: string;
  Km: number;      // Michaelis constant (μM)
  kcat: number;    // Catalytic rate constant (s⁻¹)
  location: string;
}

const DEGRADATION_ENZYMES: Record<string, EnzymeKinetics> = {
  MAOA: { name: 'Monoamine oxidase A', Km: 0.4, kcat: 8.0, location: 'Outer mitochondrial membrane' },
  MAOB: { name: 'Monoamine oxidase B', Km: 0.3, kcat: 6.5, location: 'Outer mitochondrial membrane' },
  COMT: { name: 'Catechol-O-methyltransferase', Km: 0.8, kcat: 4.0, location: 'Cytoplasm/synaptic cleft' },
  AChE: { name: 'Acetylcholinesterase', Km: 0.05, kcat: 25000, location: 'Synaptic cleft' },
  BuChE: { name: 'Butyrylcholinesterase', Km: 0.15, kcat: 15000, location: 'Plasma' },
  FAAH: { name: 'Fatty acid amide hydrolase', Km: 1.5, kcat: 12.0, location: 'Postsynaptic membrane' },
  MAGL: { name: 'Monoacylglycerol lipase', Km: 2.0, kcat: 10.0, location: 'Presynaptic terminal' },
};

// ═══════════════════════════════════════════════════════════════════════════════
// SECOND MESSENGER CASCADES
// ═══════════════════════════════════════════════════════════════════════════════
// Second messengers transduce extracellular signals into intracellular responses.
// Key cascades:
//
// 1. cAMP/PKA pathway (Gs-coupled receptors):
//    Receptor → Gs → adenylyl cyclase → ↑cAMP → PKA → phosphorylate targets
//    - D1, β-adrenergic, 5-HT4/6/7 receptors activate
//    - D2, α2-adrenergic, 5-HT1A inhibit (via Gi)
//    - PKA phosphorylates CREB → gene transcription
//
// 2. IP3/DAG/Ca²⁺ pathway (Gq-coupled receptors):
//    Receptor → Gq → PLC → IP3 + DAG
//    - IP3 → IP3R on ER → Ca²⁺ release
//    - DAG + Ca²⁺ → PKC activation
//    - 5-HT2A/2C, α1-adrenergic, M1/M3 muscarinic, mGluR1/5
//
// 3. Ca²⁺/calmodulin pathway:
//    Ca²⁺ → calmodulin → CaMKII activation
//    - CaMKII autophosphorylates → persistent activity
//    - Critical for LTP (long-term potentiation)
//    - Phosphorylates AMPA receptors → insert into membrane
//
// 4. NO/cGMP pathway:
//    NMDA activation → Ca²⁺ → nNOS → NO → diffuses to neighbors
//    NO → sGC → ↑cGMP → PKG activation
//    - Retrograde messenger (postsynaptic → presynaptic)
//    - Vasodilation (neurovascular coupling)
//
interface SecondMessengerState {
  cAMP: number;      // Cyclic AMP (μM)
  cGMP: number;      // Cyclic GMP (μM)
  IP3: number;       // Inositol 1,4,5-trisphosphate (μM)
  DAG: number;       // Diacylglycerol (μM)
  Ca2: number;       // Intracellular calcium (μM)
  PKA: number;       // Protein kinase A activity [0,1]
  PKC: number;       // Protein kinase C activity [0,1]
  CaMKII: number;    // Ca2+/calmodulin-dependent kinase II [0,1]
  CREB: number;      // cAMP response element-binding protein [0,1]
  deltaFosB: number; // ΔFosB accumulation [0,1]
}

// ═══════════════════════════════════════════════════════════════════════════════
// GENE EXPRESSION DYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════
// Gene expression provides long-term plasticity through protein synthesis.
//
// Transcription factors:
//   - CREB (cAMP Response Element-Binding protein): master regulator
//     Phosphorylated by PKA, CaMKII, MAPK → binds CRE sequences
//     Induces: BDNF, c-Fos, Arc, Nr4a1, Homer1a
//   - ΔFosB: accumulates with repeated stimulation (addiction marker)
//     Half-life 6-8 days (unusually stable for transcription factor)
//     Binds AP-1 sites, alters chromatin structure
//   - NF-κB: inflammatory signaling, synaptic plasticity
//
// Immediate early genes (IEGs):
//   - c-Fos, Arc, Zif268, Homer1a
//   - Rapid induction (<30 min), transient expression
//   - Activity markers: used for mapping active neurons
//   - c-Fos: transcription factor, forms AP-1 with Jun
//   - Arc: traffics to dendrites, regulates AMPA endocytosis
//   - Zif268 (Egr1): required for memory consolidation
//
// BDNF (Brain-Derived Neurotrophic Factor):
//   - TrkB receptor signaling → MAPK, PI3K, PLCγ
//   - Promotes: synaptogenesis, dendritic branching, LTP
//   - Complex promoter: 9 promoters in rodents (4 main ones)
//   - Activity-dependent: Promoter IV induced by Ca²⁺/CREB
//   - Val66Met polymorphism: affects activity-dependent secretion
//
// Protein synthesis:
//   - mRNA transcription: 10-30 min
//   - Translation: 1-5 min per protein
//   - Total delay: 30-60 min for full protein expression
//   - Local translation: dendrites have ribosomes for rapid synthesis
//   - mTOR pathway: regulates translation initiation
//
interface GeneExpressionState {
  BDNF_mRNA: number;     // Brain-derived neurotrophic factor mRNA
  cFos: number;          // Immediate early gene
  Arc: number;           // Activity-regulated cytoskeleton-associated protein
  Homer1a: number;       // Synaptic scaffolding protein
  Zif268: number;        // Zinc finger protein (Egr1)
  transcriptionDelay: number; // Time delay for protein synthesis (min)
}

// ═══════════════════════════════════════════════════════════════════════════════
// 66-PAIR CROSSTALK MATRIX (EXPANDED WITH RECEPTOR-LEVEL INTERACTIONS)
// Each pair: [sourceIdx, targetIdx, weight, sign, receptorType, timeCourse]
// Positive sign = facilitation, negative = inhibition
// timeCourse: 'fast' (<100ms), 'medium' (100ms-1s), 'slow' (>1s), 'genomic' (>30min)
// ═══════════════════════════════════════════════════════════════════════════════
const NT_NAMES = [
  'dopamine', 'serotonin', 'norepinephrine', 'epinephrine', 'acetylcholine',
  'gaba', 'glycine', 'glutamate', 'oxytocin', 'vasopressin',
  'endorphin', 'substanceP', 'npy', 'adenosine', 'anandamide',
  'twoAG', 'nitricOxide', 'bdnf', 'ngf', 'cortisol', 'testosterone',
];

type CrosstalkEntry = [number, number, number, number, string, string];
// [sourceIdx, targetIdx, weight, sign, receptorType, timeCourse]

const CROSSTALK_66: CrosstalkEntry[] = [
  // ── DOPAMINE INTERACTIONS ──
  [0, 1, 0.3, 1, 'D2→5HT1A', 'medium'],   // DA → SER via D2 autoreceptor feedback
  [0, 11, 0.2, -1, 'D1→μ-opioid', 'fast'], // DA ⊣ SubP reward inhibits pain
  [0, 17, 0.4, 1, 'D1→TrkB', 'genomic'],  // DA → BDNF via CREB phosphorylation
  [0, 7, 0.25, 1, 'D1→NMDA', 'medium'],   // DA → GLU D1 enhances NMDA currents
  [0, 5, 0.15, 1, 'D2→GABA', 'fast'],     // DA → GABA indirect pathway
  // ── SEROTONIN INTERACTIONS ──
  [1, 0, 0.2, 1, '5HT2A→D2', 'medium'],   // SER → DA serotonergic modulation
  [1, 5, 0.3, 1, '5HT1A→GABA', 'medium'], // SER → GABA anxiolytic effect
  [1, 19, 0.3, -1, '5HT1A→GR', 'slow'],   // SER ⊣ CORT mood buffers HPA axis
  [1, 7, 0.2, -1, '5HT1B→GLU', 'fast'],   // SER ⊣ GLU presynaptic inhibition
  [1, 4, 0.18, 1, '5HT4→mAChR', 'medium'], // SER → ACh cognitive enhancement
  // ── NOREPINEPHRINE INTERACTIONS ──
  [2, 3, 0.5, 1, 'β-AR→PNMT', 'medium'],  // NE → EPI enzymatic conversion pathway
  [2, 4, 0.3, 1, 'α1→nAChR', 'fast'],     // NE → ACh arousal → attention
  [2, 13, 0.2, -1, 'α1→A1', 'medium'],    // NE ⊣ ADO arousal inhibits sleep
  [2, 7, 0.28, 1, 'β-AR→AMPA', 'medium'], // NE → GLU β-adrenergic potentiation
  [2, 17, 0.35, 1, 'β-AR→TrkB', 'genomic'], // NE → BDNF via β-AR signaling
  // ── EPINEPHRINE INTERACTIONS ──
  [3, 2, 0.4, 1, 'β2→α2', 'fast'],        // EPI → NE reciprocal feedback
  [3, 19, 0.5, 1, 'β→CRH', 'slow'],       // EPI → CORT HPA axis activation
  [3, 7, 0.3, 1, 'β1→NMDA', 'medium'],    // EPI → GLU metabolic excitation
  [3, 0, 0.22, 1, 'β2→D1', 'medium'],     // EPI → DA stress-reward coupling
  // ── ACETYLCHOLINE INTERACTIONS ──
  [4, 17, 0.5, 1, 'M1→TrkB', 'genomic'],  // ACh → BDNF muscarinic learning
  [4, 7, 0.3, 1, 'nAChR→NMDA', 'fast'],   // ACh → GLU nicotinic facilitation
  [4, 13, 0.2, -1, 'M1→A1', 'medium'],    // ACh ⊣ ADO attention vs sleep
  [4, 0, 0.25, 1, 'nAChR→D2', 'fast'],    // ACh → DA cholinergic interneurons
  [4, 5, 0.15, -1, 'M2→GABA', 'medium'],  // ACh ⊣ GABA disinhibition
  // ── GABA INTERACTIONS ──
  [5, 7, 0.6, -1, 'GABAA→NMDA', 'fast'],  // GABA ⊣ GLU shunting inhibition
  [5, 19, 0.3, -1, 'GABAA→GR', 'slow'],   // GABA ⊣ CORT inhibits HPA
  [5, 13, 0.2, 1, 'GABAA→A1', 'medium'],  // GABA → ADO sleep pressure
  [5, 0, 0.18, -1, 'GABAA→D1', 'fast'],   // GABA ⊣ DA direct inhibition
  [5, 2, 0.16, -1, 'GABAB→α2', 'medium'], // GABA ⊣ NE presynaptic inhibition
  // ── GLYCINE INTERACTIONS ──
  [6, 7, 0.4, -1, 'GlyR→NMDA', 'fast'],   // GLY ⊣ GLU strychnine-sensitive
  [6, 5, 0.2, 1, 'GlyR→GABAA', 'fast'],   // GLY → GABA co-release
  [6, 11, 0.15, -1, 'GlyR→NK1', 'medium'], // GLY ⊣ SubP spinal modulation
  // ── GLUTAMATE INTERACTIONS ──
  [7, 17, 0.5, 1, 'NMDA→TrkB', 'genomic'], // GLU → BDNF activity-dependent
  [7, 4, 0.3, 1, 'NMDA→nAChR', 'medium'],  // GLU → ACh reciprocal
  [7, 5, 0.3, -1, 'AMPA→GABA', 'fast'],    // GLU ⊣ GABA feedforward inhibition
  [7, 0, 0.28, 1, 'NMDA→D1', 'medium'],    // GLU → DA excitatory drive
  [7, 16, 0.35, 1, 'NMDA→nNOS', 'fast'],   // GLU → NO calcium-dependent
  // ── OXYTOCIN INTERACTIONS ──
  [8, 1, 0.4, 1, 'OXTR→5HT1A', 'medium'],  // OXT → SER bonding → mood
  [8, 19, 0.4, -1, 'OXTR→CRH', 'slow'],    // OXT ⊣ CORT anti-stress
  [8, 0, 0.2, 1, 'OXTR→D2', 'medium'],     // OXT → DA social reward
  [8, 17, 0.3, 1, 'OXTR→TrkB', 'genomic'], // OXT → BDNF social plasticity
  // ── VASOPRESSIN INTERACTIONS ──
  [9, 8, 0.3, 1, 'V1a→OXTR', 'medium'],    // VP → OXT receptor crosstalk
  [9, 2, 0.2, 1, 'V1a→α1', 'fast'],        // VP → NE social vigilance
  [9, 19, 0.25, 1, 'V1b→CRH', 'slow'],     // VP → CORT HPA modulation
  // ── ENDORPHIN INTERACTIONS ──
  [10, 11, 0.6, -1, 'μ→NK1', 'fast'],      // END ⊣ SubP opioid analgesia
  [10, 0, 0.3, 1, 'μ→D2', 'medium'],       // END → DA reward pathway
  [10, 1, 0.2, 1, 'μ→5HT', 'medium'],      // END → SER mood elevation
  [10, 5, 0.25, 1, 'μ→GABA', 'fast'],      // END → GABA disinhibition
  // ── SUBSTANCE P INTERACTIONS ──
  [11, 10, 0.2, -1, 'NK1→μ', 'medium'],    // SubP ⊣ END pain vs relief
  [11, 19, 0.3, 1, 'NK1→CRH', 'slow'],     // SubP → CORT pain → stress
  [11, 7, 0.22, 1, 'NK1→NMDA', 'medium'],  // SubP → GLU pain amplification
  // ── NPY INTERACTIONS ──
  [12, 19, 0.4, -1, 'Y1→CRH', 'slow'],     // NPY ⊣ CORT anxiolytic buffer
  [12, 5, 0.2, 1, 'Y1→GABA', 'medium'],    // NPY → GABA calming
  [12, 2, 0.18, -1, 'Y2→α2', 'medium'],    // NPY ⊣ NE presynaptic inhibition
  // ── ADENOSINE INTERACTIONS ──
  [13, 2, 0.5, -1, 'A1→α1', 'medium'],     // ADO ⊣ NE sleep vs arousal
  [13, 4, 0.3, -1, 'A1→nAChR', 'medium'],  // ADO ⊣ ACh sleep vs attention
  [13, 5, 0.3, 1, 'A1→GABAA', 'medium'],   // ADO → GABA sleep synergy
  [13, 7, 0.28, -1, 'A1→NMDA', 'fast'],    // ADO ⊣ GLU neuroprotection
  [13, 0, 0.35, -1, 'A2A→D2', 'fast'],     // ADO ⊣ DA antagonistic interaction
  // ── ANANDAMIDE INTERACTIONS ──
  [14, 0, 0.3, 1, 'CB1→D2', 'medium'],     // ANA → DA bliss → reward
  [14, 1, 0.4, 1, 'CB1→5HT', 'medium'],    // ANA → SER mood enhancement
  [14, 17, 0.3, 1, 'CB1→TrkB', 'genomic'], // ANA → BDNF synaptic plasticity
  [14, 7, 0.25, -1, 'CB1→GLU', 'fast'],    // ANA ⊣ GLU retrograde signaling
  [14, 5, 0.22, -1, 'CB1→GABA', 'fast'],   // ANA ⊣ GABA DSI/DSE
  // ── 2-AG INTERACTIONS ──
  [15, 14, 0.3, 1, 'CB1→CB1', 'fast'],     // 2-AG → ANA endocannabinoid synergy
  [15, 5, 0.2, 1, 'CB1→GABA', 'fast'],     // 2-AG → GABA relaxation
  [15, 10, 0.2, 1, 'CB1→μ', 'medium'],     // 2-AG → END pain relief
  [15, 7, 0.24, -1, 'CB1→GLU', 'fast'],    // 2-AG ⊣ GLU synaptic depression
  // ── NITRIC OXIDE INTERACTIONS ──
  [16, 7, 0.3, 1, 'sGC→NMDA', 'fast'],     // NO → GLU retrograde messenger
  [16, 0, 0.2, 1, 'sGC→D1', 'medium'],     // NO → DA vasodilation → reward
  [16, 17, 0.28, 1, 'sGC→TrkB', 'slow'],   // NO → BDNF plasticity signaling
  // ── BDNF INTERACTIONS ──
  [17, 18, 0.5, 1, 'TrkB→TrkA', 'genomic'], // BDNF → NGF neurotrophin synergy
  [17, 7, 0.3, 1, 'TrkB→NMDA', 'medium'],   // BDNF → GLU receptor trafficking
  [17, 4, 0.2, 1, 'TrkB→nAChR', 'genomic'], // BDNF → ACh cholinergic function
  [17, 1, 0.25, 1, 'TrkB→5HT', 'slow'],     // BDNF → SER serotonergic tone
  [17, 5, 0.18, 1, 'TrkB→GABA', 'genomic'], // BDNF → GABA GABAergic maturation
  // ── NGF INTERACTIONS ──
  [18, 17, 0.4, 1, 'TrkA→TrkB', 'genomic'], // NGF → BDNF reciprocal
  [18, 4, 0.2, 1, 'TrkA→nAChR', 'genomic'], // NGF → ACh cholinergic survival
  // ── CORTISOL INTERACTIONS ──
  [19, 1, 0.5, -1, 'GR→5HT1A', 'slow'],     // CORT ⊣ SER chronic stress
  [19, 5, 0.3, -1, 'GR→GABAA', 'slow'],     // CORT ⊣ GABA anxiogenesis
  [19, 17, 0.4, -1, 'GR→TrkB', 'genomic'],  // CORT ⊣ BDNF chronic stress inhibits
  [19, 2, 0.3, 1, 'GR→α1', 'medium'],       // CORT → NE HPA activation
  [19, 7, 0.28, 1, 'GR→GLU', 'slow'],       // CORT → GLU excitotoxicity
  [19, 8, 0.32, -1, 'GR→OXTR', 'slow'],     // CORT ⊣ OXT stress vs bonding
  // ── TESTOSTERONE INTERACTIONS ──
  [20, 0, 0.3, 1, 'AR→D1', 'genomic'],      // TEST → DA dominance → reward
  [20, 2, 0.2, 1, 'AR→α1', 'medium'],       // TEST → NE drive → arousal
  [20, 19, 0.2, -1, 'AR→GR', 'slow'],       // TEST ⊣ CORT resilience
  [20, 1, 0.18, -1, 'AR→5HT', 'slow'],      // TEST ⊣ SER aggression modulation
  [20, 7, 0.22, 1, 'AR→NMDA', 'medium'],    // TEST → GLU excitatory drive
  // ── ADDITIONAL CROSS-SYSTEM INTERACTIONS ──
  [0, 8, 0.2, 1, 'D1→OXTR', 'medium'],      // DA → OXT reward → bonding
  [1, 14, 0.3, 1, '5HT2A→CB1', 'medium'],   // SER → ANA psychedelic synergy
  [4, 0, 0.2, 1, 'M5→D2', 'fast'],          // ACh → DA striatal modulation
  [7, 2, 0.2, 1, 'AMPA→β-AR', 'fast'],      // GLU → NE locus coeruleus
  [10, 8, 0.2, 1, 'μ→OXTR', 'medium'],      // END → OXT relief → bonding
];

// ═══════════════════════════════════════════════════════════════════════════════
// DRIVE QUARTET — Detailed Hypothalamic Circuits
// ═══════════════════════════════════════════════════════════════════════════════
// The hypothalamus is the master regulator of homeostatic drives.
// It integrates peripheral signals (hormones, nutrients) with central state
// to maintain physiological balance.
//
// Hypothalamic nuclei:
//   - VMH (ventromedial): satiety, glucose sensing, aggression
//   - LH (lateral): feeding, reward seeking, arousal (orexin/MCH neurons)
//   - PVN (paraventricular): stress (CRH), autonomic, oxytocin/vasopressin
//   - SCN (suprachiasmatic): circadian pacemaker (~24h rhythms)
//   - SON (supraoptic): vasopressin/oxytocin release to posterior pituitary
//   - ARC (arcuate): leptin/ghrelin sensing, GnRH pulse generator
//   - MPOA (medial preoptic): sexual behavior, parenting
//   - DMH (dorsomedial): circadian feeding, stress, thermoregulation
//
// Hunger/satiety circuit:
//   - Arcuate nucleus:
//     * NPY/AgRP neurons: orexigenic (promote feeding)
//       - Inhibited by leptin (adiposity signal)
//       - Activated by ghrelin (stomach hunger signal)
//     * POMC/CART neurons: anorexigenic (suppress feeding)
//       - Activated by leptin, insulin
//       - Produce α-MSH → MC4R → satiety
//   - LH orexin/MCH neurons: promote wakefulness + feeding
//   - VMH SF-1 neurons: satiety, suppress feeding
//
// Thirst circuit:
//   - Osmoreceptors: detect blood osmolality
//   - Subfornical organ (SFO): senses angiotensin II (no BBB)
//   - Median preoptic nucleus (MnPO): integrates signals → thirst
//   - SON/PVN: release vasopressin (ADH) → kidney water retention
//
// Reproductive drive:
//   - MPOA: integrates sensory input, hormones → sexual behavior
//   - ARC GnRH neurons: pulsatile release → pituitary → LH/FSH → gonads
//   - Estrogen/testosterone: genomic + rapid membrane effects
//   - Oxytocin: bonding, orgasm, pair bonding (prairie vole studies)
//
// Aggression:
//   - VMH → periaqueductal gray (PAG): defensive aggression
//   - MPOA/anterior hypothalamus: testosterone-dependent aggression
//   - Amygdala → hypothalamus: threat assessment → defensive response
//   - Serotonin: generally inhibits impulsive aggression
//   - Testosterone: facilitates, but doesn't cause aggression
//
interface HypothalamicNuclei {
  VMH: number;  // Ventromedial hypothalamus (satiety center)
  LH: number;   // Lateral hypothalamus (feeding center)
  PVN: number;  // Paraventricular nucleus (stress/autonomic)
  SCN: number;  // Suprachiasmatic nucleus (circadian)
  SON: number;  // Supraoptic nucleus (vasopressin/oxytocin)
  ARC: number;  // Arcuate nucleus (appetite hormones)
  MPOA: number; // Medial preoptic area (sexual behavior)
  DMH: number;  // Dorsomedial hypothalamus (arousal)
}

interface DriveState {
  hunger:     number;  // [0,1] 0=sated, 1=starving
  thirst:     number;  // [0,1] 0=hydrated, 1=dehydrated
  libido:     number;  // [0,1] reproductive drive
  aggression: number;  // [0,1] defensive/territorial drive
  // Metabolic hormones
  leptin:     number;  // Adiposity signal (inhibits hunger)
  ghrelin:    number;  // Hunger hormone (promotes feeding)
  insulin:    number;  // Glucose homeostasis
  // Thirst hormones
  angiotensin2: number; // Renin-angiotensin system
  adh:        number;   // Antidiuretic hormone (vasopressin)
  // Sex hormones (more detail)
  estrogen:   number;
  progesterone: number;
  // Hypothalamic activity
  nuclei:     HypothalamicNuclei;
}

const DRIVE_BASELINES = { 
  hunger: 0.3, thirst: 0.25, libido: 0.4, aggression: 0.2,
  leptin: 0.6, ghrelin: 0.4, insulin: 0.5,
  angiotensin2: 0.3, adh: 0.4,
  estrogen: 0.5, progesterone: 0.3,
  nuclei: { VMH: 0.5, LH: 0.4, PVN: 0.3, SCN: 0.5, SON: 0.4, ARC: 0.5, MPOA: 0.4, DMH: 0.4 },
};

function initDrives(): DriveState {
  return { ...DRIVE_BASELINES, nuclei: { ...DRIVE_BASELINES.nuclei } };
}

function tickDrives(prev: DriveState, neuro: NeurochemFull, dt: number): DriveState {
  // ── HUNGER CIRCUIT ──
  // Arcuate nucleus: NPY/AgRP neurons (orexigenic) vs POMC/CART neurons (anorexigenic)
  const ARC_orexigenic = neuro.npy * 0.7 + prev.ghrelin * 0.3;
  const ARC_anorexigenic = prev.leptin * 0.6 + neuro.cortisol * 0.2; // Chronic stress affects appetite
  const ARC = clamp(ARC_orexigenic - ARC_anorexigenic, 0, 1);
  
  // Lateral hypothalamus: orexin/MCH neurons drive feeding
  const LH = clamp(ARC * 0.7 + (1 - prev.leptin) * 0.3, 0, 1);
  
  // Ventromedial hypothalamus: satiety center
  const VMH = clamp(prev.leptin * 0.6 + prev.insulin * 0.3 + neuro.serotonin * 0.1, 0, 1);
  
  // Hunger drive: LH activation minus VMH inhibition
  const hungerTarget = LH * 0.7 - VMH * 0.5;
  const hunger = clamp(prev.hunger + (hungerTarget - prev.hunger) * 0.03 * dt, 0, 1);
  
  // Ghrelin: rises with fasting, suppressed by feeding
  const ghrelinDelta = 0.001 * (1 - prev.ghrelin) - 0.002 * hunger;
  const ghrelin = clamp(prev.ghrelin + ghrelinDelta * dt, 0, 1);
  
  // Leptin: proportional to energy stores (simplified)
  const leptinTarget = 1 - hunger * 0.8;
  const leptin = clamp(prev.leptin + (leptinTarget - prev.leptin) * 0.01 * dt, 0, 1);
  
  // ── THIRST CIRCUIT ──
  // Supraoptic nucleus: vasopressin secretion
  const SON = clamp(neuro.vasopressin * 0.8 + prev.angiotensin2 * 0.2, 0, 1);
  
  // Subfornical organ (SFO) → PVN circuit (angiotensin-sensitive)
  const PVN_thirst = prev.angiotensin2 * 0.6 + SON * 0.4;
  
  // Thirst drive: rises with dehydration, angiotensin, vasopressin
  const thirstDelta = 0.0012 * (1 - prev.thirst) + PVN_thirst * 0.0008;
  const thirst = clamp(prev.thirst + thirstDelta * dt, 0, 1);
  
  // Angiotensin II: rises with dehydration
  const angiotensin2 = clamp(prev.angiotensin2 + (thirst * 0.002 - 0.001) * dt, 0, 1);
  
  // ADH (antidiuretic hormone): same as vasopressin
  const adh = neuro.vasopressin;
  
  // ── LIBIDO CIRCUIT ──
  // Medial preoptic area: integrates sexual stimuli
  const MPOA = clamp(
    neuro.testosterone * 0.4 + prev.estrogen * 0.3 + neuro.oxytocin * 0.2 + neuro.dopamine * 0.1,
    0, 1
  );
  
  // Libido: testosterone primary driver, estrogen/progesterone modulate
  const libidoTarget = neuro.testosterone * 0.5 + prev.estrogen * 0.25 
                     + neuro.oxytocin * 0.15 + MPOA * 0.1;
  const libido = clamp(prev.libido + (libidoTarget - prev.libido) * 0.04 * dt, 0, 1);
  
  // Sex hormone dynamics (simplified cyclic model)
  const estrogenTarget = 0.5 + 0.3 * Math.sin(prev.nuclei.SCN * TAU); // Menstrual cycle approximation
  const estrogen = clamp(prev.estrogen + (estrogenTarget - prev.estrogen) * 0.02 * dt, 0, 1);
  const progesterone = clamp(0.3 + 0.4 * Math.sin(prev.nuclei.SCN * TAU - PI/2), 0, 1);
  
  // ── AGGRESSION CIRCUIT ──
  // Dorsomedial hypothalamus + periaqueductal gray (PAG)
  const DMH = clamp(neuro.testosterone * 0.5 + neuro.cortisol * 0.3 - neuro.serotonin * 0.4, 0, 1);
  
  // Amygdala → hypothalamus → PAG aggression circuit
  const aggrTarget = (neuro.testosterone * 0.35 + neuro.cortisol * 0.25 + DMH * 0.2)
                   - (neuro.serotonin * 0.35 + neuro.oxytocin * 0.25 + neuro.gaba * 0.1);
  const aggression = clamp(prev.aggression + (aggrTarget - prev.aggression) * 0.06 * dt, 0, 1);
  
  // ── CIRCADIAN REGULATION ──
  // Suprachiasmatic nucleus: master circadian pacemaker
  const SCN = clamp(Math.sin(prev.nuclei.SCN + 0.001 * dt) * 0.5 + 0.5, 0, 1);
  
  // Paraventricular nucleus: integrates stress/autonomic
  const PVN = clamp(neuro.cortisol * 0.5 + neuro.norepinephrine * 0.3 + PVN_thirst * 0.2, 0, 1);
  
  const insulin = clamp(0.5 + hunger * 0.3 - prev.ghrelin * 0.2, 0, 1);

  return {
    hunger, thirst, libido, aggression,
    leptin, ghrelin, insulin,
    angiotensin2, adh,
    estrogen, progesterone,
    nuclei: { VMH, LH, PVN, SCN, SON, ARC, MPOA, DMH },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// AEGIS IMMUNE SYSTEM — Neuroimmune Integration
// ═══════════════════════════════════════════════════════════════════════════════
interface InnateImmunity {
  macrophages: number;  // Phagocytic cells
  nkCells: number;      // Natural killer cells
  complement: number;   // Complement cascade activation
  neutrophils: number;  // Rapid responders
  dendritic: number;    // Antigen presentation
}

interface AdaptiveImmunity {
  tCells: number;       // T lymphocytes
  bCells: number;       // B lymphocytes
  antibodies: number;   // Immunoglobulin levels
  memoryBCells: number; // Immune memory
}

interface Cytokines {
  IL1beta: number;  // Pro-inflammatory
  IL6: number;      // Pro-inflammatory
  TNFalpha: number; // Pro-inflammatory
  IL10: number;     // Anti-inflammatory
  IFNgamma: number; // Antiviral
  IL4: number;      // Th2 response
}

interface HPAAxis {
  CRH: number;   // Corticotropin-releasing hormone (hypothalamus)
  ACTH: number;  // Adrenocorticotropic hormone (pituitary)
  cortisol: number; // Glucocorticoid (adrenal)
  feedback: number; // Negative feedback strength
}

interface AegisState {
  threatLevel:   number;  // [0,1] detected threat
  neResponse:    number;  // NE surge magnitude
  epiResponse:   number;  // EPI surge magnitude
  immuneActive:  boolean;
  lastThreatBeat: number;
  innate:        InnateImmunity;
  adaptive:      AdaptiveImmunity;
  cytokines:     Cytokines;
  hpa:           HPAAxis;
  vagusActivity: number;  // Vagus nerve anti-inflammatory reflex
  microbiomeDiversity: number; // Gut microbiome health
  sicknessResponse: number; // Behavioral changes during infection
}

function initAegis(): AegisState {
  return {
    threatLevel: 0,
    neResponse: 0,
    epiResponse: 0,
    immuneActive: false,
    lastThreatBeat: 0,
    innate: { macrophages: 0.5, nkCells: 0.5, complement: 0.3, neutrophils: 0.4, dendritic: 0.5 },
    adaptive: { tCells: 0.5, bCells: 0.5, antibodies: 0.4, memoryBCells: 0.3 },
    cytokines: { IL1beta: 0.1, IL6: 0.1, TNFalpha: 0.1, IL10: 0.3, IFNgamma: 0.1, IL4: 0.2 },
    hpa: { CRH: 0.2, ACTH: 0.2, cortisol: 0.3, feedback: 0.5 },
    vagusActivity: 0.6,
    microbiomeDiversity: 0.7,
    sicknessResponse: 0,
  };
}

function tickAegis(
  prev: AegisState,
  externalThreat: number,
  neuro: NeurochemFull,
  beat: number,
  dt: number
): AegisState {
  // ── THREAT DETECTION ──
  // Integrate external threat + internal stress signals
  const internalStress = prev.hpa.cortisol * 0.5 + prev.cytokines.IL6 * 0.3;
  const threatLevel = clamp(externalThreat * 0.6 + internalStress * 0.4, 0, 1);
  const immuneActive = threatLevel > 0.35 || prev.cytokines.IL1beta > 0.4;

  // ── INNATE IMMUNITY ──
  // Macrophages: respond to pathogen-associated molecular patterns (PAMPs)
  const macrophages = clamp(
    prev.innate.macrophages + (threatLevel * 0.03 - 0.01) * dt,
    0, 1
  );
  
  // NK cells: cytotoxic response to virally infected/tumor cells
  const nkCells = clamp(
    prev.innate.nkCells + (threatLevel * 0.025 + prev.cytokines.IFNgamma * 0.02 - 0.01) * dt,
    0, 1
  );
  
  // Complement: cascade amplification
  const complement = clamp(
    prev.innate.complement + (macrophages * 0.02 - 0.008) * dt,
    0, 1
  );
  
  // Neutrophils: rapid first responders
  const neutrophils = clamp(
    prev.innate.neutrophils + (threatLevel * 0.04 - 0.015) * dt,
    0, 1
  );
  
  // Dendritic cells: link innate → adaptive immunity
  const dendritic = clamp(
    prev.innate.dendritic + ((macrophages + neutrophils) * 0.015 - 0.01) * dt,
    0, 1
  );

  // ── ADAPTIVE IMMUNITY ──
  // T cells: activated by dendritic cell antigen presentation
  const tCells = clamp(
    prev.adaptive.tCells + (dendritic * 0.02 + prev.cytokines.IL4 * 0.01 - 0.008) * dt,
    0, 1
  );
  
  // B cells: antibody production
  const bCells = clamp(
    prev.adaptive.bCells + (tCells * 0.018 - 0.007) * dt,
    0, 1
  );
  
  // Antibodies: humoral immunity
  const antibodies = clamp(
    prev.adaptive.antibodies + (bCells * 0.025 - 0.01) * dt,
    0, 1
  );
  
  // Memory B cells: long-term immunity
  const memoryBCells = clamp(
    prev.adaptive.memoryBCells + (bCells * 0.005) * dt,
    0, 0.9
  );

  // ── CYTOKINE SIGNALING ──
  // IL-1β: pyrogenic, induces fever and sickness behavior
  const IL1beta = clamp(
    prev.cytokines.IL1beta + (macrophages * 0.03 + threatLevel * 0.02 - 0.015) * dt,
    0, 1
  );
  
  // IL-6: acute phase response, crosses BBB → hypothalamus
  const IL6 = clamp(
    prev.cytokines.IL6 + (macrophages * 0.025 + IL1beta * 0.02 - 0.012) * dt,
    0, 1
  );
  
  // TNF-α: pro-inflammatory, potent at low concentrations
  const TNFalpha = clamp(
    prev.cytokines.TNFalpha + (macrophages * 0.028 + neutrophils * 0.015 - 0.014) * dt,
    0, 1
  );
  
  // IL-10: anti-inflammatory, resolves immune response
  const IL10 = clamp(
    prev.cytokines.IL10 + (prev.hpa.cortisol * 0.02 + prev.vagusActivity * 0.015 - IL6 * 0.01) * dt,
    0, 1
  );
  
  // IFN-γ: antiviral, activates macrophages
  const IFNgamma = clamp(
    prev.cytokines.IFNgamma + (tCells * 0.022 + nkCells * 0.018 - 0.01) * dt,
    0, 1
  );
  
  // IL-4: Th2 response, anti-inflammatory
  const IL4 = clamp(
    prev.cytokines.IL4 + (tCells * 0.015 - TNFalpha * 0.01) * dt,
    0, 1
  );

  // ── HPA AXIS ──
  // Cytokines (IL-1β, IL-6, TNF-α) → hypothalamus → CRH
  const cytokineDrive = IL1beta * 0.4 + IL6 * 0.35 + TNFalpha * 0.25;
  const CRH = clamp(
    prev.hpa.CRH + (cytokineDrive * 0.03 + neuro.norepinephrine * 0.02 - prev.hpa.feedback * 0.015) * dt,
    0, 1
  );
  
  // CRH → anterior pituitary → ACTH
  const ACTH = clamp(
    prev.hpa.ACTH + (CRH * 0.04 - prev.hpa.feedback * 0.02) * dt,
    0, 1
  );
  
  // ACTH → adrenal cortex → cortisol
  const cortisol = clamp(
    prev.hpa.cortisol + (ACTH * 0.05 - 0.02) * dt,
    0, 1
  );
  
  // Negative feedback: cortisol → hippocampus/hypothalamus/pituitary → suppress HPA
  const feedback = clamp(cortisol * 0.8 + IL10 * 0.2, 0, 1);

  // ── VAGUS NERVE ANTI-INFLAMMATORY REFLEX ──
  // Vagus nerve stimulation → acetylcholine → α7 nicotinic receptors on macrophages → suppress cytokines
  const vagusActivity = clamp(
    prev.vagusActivity + (neuro.acetylcholine * 0.015 - TNFalpha * 0.02) * dt,
    0, 1
  );

  // ── MICROBIOME-GUT-BRAIN AXIS ──
  // Diverse microbiome → SCFAs (butyrate, propionate) → anti-inflammatory
  const microbiomeDiversity = clamp(
    prev.microbiomeDiversity + (IL10 * 0.008 - (IL6 + TNFalpha) * 0.005) * dt,
    0, 1
  );

  // ── SICKNESS BEHAVIOR ──
  // IL-1β, IL-6, TNF-α → hypothalamus → lethargy, anhedonia, social withdrawal
  const sicknessResponse = clamp(
    (IL1beta * 0.4 + IL6 * 0.35 + TNFalpha * 0.25) - neuro.dopamine * 0.3,
    0, 1
  );

  // ── NE/EPI SURGE (FIGHT-OR-FLIGHT) ──
  // Locus coeruleus (NE) + adrenal medulla (EPI) activated by threat
  const neResponse  = immuneActive ? clamp(threatLevel * 1.3 + CRH * 0.5, 0, 1) : prev.neResponse * 0.92;
  const epiResponse = immuneActive ? clamp(threatLevel * 1.1 + ACTH * 0.4, 0, 1) : prev.epiResponse * 0.88;

  const lastThreatBeat = immuneActive ? beat : prev.lastThreatBeat;

  return {
    threatLevel,
    neResponse,
    epiResponse,
    immuneActive,
    lastThreatBeat,
    innate: { macrophages, nkCells, complement, neutrophils, dendritic },
    adaptive: { tCells, bCells, antibodies, memoryBCells },
    cytokines: { IL1beta, IL6, TNFalpha, IL10, IFNgamma, IL4 },
    hpa: { CRH, ACTH, cortisol, feedback },
    vagusActivity,
    microbiomeDiversity,
    sicknessResponse,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// OLFACTORY LIMBIC PATHWAY — Direct thalamic bypass
// ═══════════════════════════════════════════════════════════════════════════════
interface OlfactoryReceptorLayer {
  ORN_activation: number[];  // ~400 receptor types in humans (simplified to 20 channels)
  glomerular: number[];      // Glomerular layer (1000:1 convergence ORN→mitral)
  mitral: number[];          // Mitral cells (principal output neurons)
  tufted: number[];          // Tufted cells (parallel processing)
  granule: number;           // Granule cells (inhibitory interneurons)
}

interface LimbicTargets {
  piriform: number;      // Primary olfactory cortex (direct, no thalamus!)
  entorhinal: number;    // Entorhinal cortex → hippocampus (memory)
  amygdala: number;      // Amygdala (emotion)
  orbitofrontal: number; // OFC (conscious perception, hedonic value)
  hippocampus: number;   // Episodic memory encoding
}

interface OlfactoryState {
  signal:       number;  // current olfactory input [0,1]
  receptorLayer: OlfactoryReceptorLayer;
  limbicTargets: LimbicTargets;
  limbicInjection: number; // direct amygdala/hippocampus injection
  emotionalValence: number; // positive/negative [-1,1]
  memoryTag:    boolean;   // strong memory encoding flag
  proustianRecall: number; // involuntary memory triggered by scent
}

function initOlfactory(): OlfactoryState {
  return {
    signal: 0,
    receptorLayer: {
      ORN_activation: new Array(20).fill(0),
      glomerular: new Array(20).fill(0),
      mitral: new Array(20).fill(0),
      tufted: new Array(20).fill(0),
      granule: 0,
    },
    limbicTargets: { piriform: 0, entorhinal: 0, amygdala: 0, orbitofrontal: 0, hippocampus: 0 },
    limbicInjection: 0,
    emotionalValence: 0,
    memoryTag: false,
    proustianRecall: 0,
  };
}

function tickOlfactory(
  prev: OlfactoryState,
  externalOlfactory: number,
  neuro: NeurochemFull,
  secondMessengers: SecondMessengerState,
  dt: number
): OlfactoryState {
  const signal = clamp(externalOlfactory, 0, 1);
  
  // ── OLFACTORY RECEPTOR NEURONS (ORNs) ──
  // Each ORN type binds specific odorant molecules
  // Simplified: 20 channels representing different odor categories
  const ORN_activation = prev.receptorLayer.ORN_activation.map((prev_orn, i) => {
    const stimPattern = Math.sin(signal * TAU + i * 0.3); // Unique activation pattern per receptor
    const activation = clamp(stimPattern * signal * 1.2, 0, 1);
    return clamp(prev_orn + (activation - prev_orn) * 0.15 * dt, 0, 1);
  });
  
  // ── GLOMERULAR LAYER ──
  // ~1000:1 convergence: many ORNs of same type → single glomerulus
  // Lateral inhibition sharpens odor representation
  const glomerular = ORN_activation.map((orn, i) => {
    const lateral_inhibition = ORN_activation.reduce((sum, other, j) => 
      i !== j ? sum + other * 0.05 : sum, 0
    );
    return clamp(orn * 1.5 - lateral_inhibition, 0, 1);
  });
  
  // ── MITRAL CELLS ──
  // Principal projection neurons: glomerulus → piriform cortex, amygdala, entorhinal
  const mitral = glomerular.map((glom, i) => {
    const granule_inhibition = prev.receptorLayer.granule * 0.3;
    return clamp(glom * 1.2 - granule_inhibition, 0, 1);
  });
  
  // ── TUFTED CELLS ──
  // Parallel processing pathway, faster than mitral cells
  const tufted = glomerular.map((glom) => clamp(glom * 0.8, 0, 1));
  
  // ── GRANULE CELLS ──
  // GABAergic interneurons providing feedback inhibition
  const granule = clamp(
    prev.receptorLayer.granule + (neuro.gaba * 0.02 + mitral.reduce((a,b)=>a+b,0)/mitral.length * 0.03 - 0.015) * dt,
    0, 1
  );
  
  // ── LIMBIC TARGETS ──
  // Piriform cortex: primary olfactory cortex (3-layer paleocortex)
  // DIRECT pathway, bypasses thalamus (unique among sensory systems!)
  const mitralAvg = mitral.reduce((a,b)=>a+b,0) / mitral.length;
  const ttuftedAvg = tufted.reduce((a,b)=>a+b,0) / tufted.length;
  
  const piriform = clamp(
    prev.limbicTargets.piriform + (mitralAvg * 0.6 + ttuftedAvg * 0.4 - 0.2) * dt,
    0, 1
  );
  
  // Entorhinal cortex: gateway to hippocampus for memory formation
  const entorhinal = clamp(
    prev.limbicTargets.entorhinal + (piriform * 0.5 + neuro.acetylcholine * 0.3 - 0.15) * dt,
    0, 1
  );
  
  // Amygdala: emotional tagging (valence + arousal)
  const amygdala = clamp(
    prev.limbicTargets.amygdala + (
      mitralAvg * 0.4 + 
      neuro.norepinephrine * 0.3 +  // Arousal
      neuro.dopamine * 0.2 -         // Reward
      neuro.serotonin * 0.15 +       // Mood
      0.1
    ) * dt - 0.2,
    0, 1
  );
  
  // Orbitofrontal cortex: conscious odor perception + hedonic evaluation
  const orbitofrontal = clamp(
    prev.limbicTargets.orbitofrontal + (
      piriform * 0.5 + 
      neuro.dopamine * 0.3 +   // Reward value
      secondMessengers.CREB * 0.2 - 
      0.15
    ) * dt,
    0, 1
  );
  
  // Hippocampus: episodic memory encoding
  // Olfaction → hippocampus is exceptionally strong (Proust effect)
  const hippocampus = clamp(
    prev.limbicTargets.hippocampus + (
      entorhinal * 0.6 + 
      neuro.acetylcholine * 0.3 +  // Cholinergic modulation
      neuro.bdnf * 0.2 -            // Neurotrophin support
      0.15
    ) * dt,
    0, 1
  );
  
  // ── LIMBIC INJECTION ──
  // Direct amygdala + hippocampus activation (thalamic bypass)
  const limbicInjection = amygdala * 0.6 + hippocampus * 0.4;
  
  // ── EMOTIONAL VALENCE ──
  // Odors have strong positive/negative associations
  const emotionalValence = clamp(
    (neuro.dopamine * 0.3 + neuro.serotonin * 0.25 + neuro.oxytocin * 0.15)
    - (neuro.cortisol * 0.35 + neuro.substanceP * 0.2 + amygdala * 0.1),
    -1, 1
  );
  
  // ── MEMORY TAG ──
  // Strong memory encoding when: signal + attention + plasticity + emotion
  const memoryTag = (
    signal > 0.5 && 
    neuro.acetylcholine > 0.5 && 
    neuro.bdnf > 0.4 && 
    Math.abs(emotionalValence) > 0.5 &&
    hippocampus > 0.6
  );
  
  // ── PROUSTIAN RECALL ──
  // Involuntary autobiographical memory triggered by scent
  // Requires: familiar odor pattern + hippocampal reactivation
  const odorFamiliarity = mitral.reduce((sum, m, i) => 
    sum + m * prev.receptorLayer.mitral[i], 0
  ) / mitral.length;  // Pattern overlap with previous state
  
  const proustianRecall = clamp(
    odorFamiliarity * hippocampus * emotionalValence * signal,
    0, 1
  );

  return {
    signal,
    receptorLayer: { ORN_activation, glomerular, mitral, tufted, granule },
    limbicTargets: { piriform, entorhinal, amygdala, orbitofrontal, hippocampus },
    limbicInjection,
    emotionalValence,
    memoryTag,
    proustianRecall,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// PAC SYNCHRONY DRIVE MODULATION — Cross-frequency coupling
// ═══════════════════════════════════════════════════════════════════════════════
// Phase-amplitude coupling (PAC) reflects hierarchical organization of brain rhythms.
// Low-frequency phase modulates high-frequency amplitude → temporal coordination.
//
// Neural oscillations arise from:
//   1. Intrinsic membrane properties (h-current, persistent Na⁺)
//   2. Synaptic feedback loops (E-I networks)
//   3. Gap junction coupling
//   4. Thalamo-cortical resonance
//
// Frequency bands & functions:
//   - Delta (0.5-4 Hz): deep sleep, motivation, error detection
//   - Theta (4-8 Hz): hippocampal navigation, memory encoding, REM sleep
//   - Alpha (8-13 Hz): thalamo-cortical idling, inhibition, attention gating
//   - Beta (13-30 Hz): motor planning, active cognition, top-down control
//   - Gamma low (30-50 Hz): local cortical processing, feedforward
//   - Gamma high (50-100 Hz): consciousness, attention, feature binding
//   - Ripple (100-250 Hz): hippocampal memory replay during sleep
//
// Cross-frequency coupling mechanisms:
//   1. Phase-amplitude coupling (PAC):
//      High-frequency amplitude modulated by low-frequency phase
//      Example: gamma (30-100 Hz) amplitude highest at theta (4-8 Hz) trough
//      Modulation Index: MI = |⟨A_high · e^(i·φ_low)⟩|
//
//   2. Phase-locking value (PLV):
//      Consistency of phase relationship between two signals
//      PLV = |⟨e^(i·Δφ)⟩| where Δφ = φ1 - φ2
//      PLV = 1: perfect phase locking, PLV = 0: random phases
//
//   3. n:m phase locking:
//      n cycles of fast rhythm per m cycles of slow
//      Example: 3:1 gamma:theta = 3 gamma cycles per theta cycle
//
// Functional significance:
//   - Working memory: theta-gamma coupling in PFC
//   - Sensorimotor integration: beta-gamma coupling
//   - Learning: beta oscillations during feedback processing
//   - Cognitive control: PFC theta coordinates task-relevant processing
//
interface OscillationBands {
  delta: number;    // 0.5-4 Hz (deep sleep, motivation)
  theta: number;    // 4-8 Hz (memory encoding, navigation)
  alpha: number;    // 8-13 Hz (relaxed wakefulness, inhibition)
  beta: number;     // 13-30 Hz (active thinking, motor control)
  gamma_low: number;  // 30-50 Hz (local processing)
  gamma_high: number; // 50-100 Hz (consciousness, binding)
  ripple: number;   // 100-250 Hz (hippocampal memory consolidation)
}

interface CrossFrequencyCoupling {
  gamma_theta_PLV: number;  // Phase-locking value γ→θ
  beta_alpha_PLV: number;   // Phase-locking value β→α
  gamma_theta_MI: number;   // Modulation index γ amplitude by θ phase
  beta_alpha_MI: number;    // Modulation index β amplitude by α phase
}

interface PACDriveState {
  kfHz:          number;  // hierarchy synchrony [0,1]
  driveBoost:    number;  // multiplicative boost to drives
  coherenceGate: number;  // gates action execution
  oscillations:  OscillationBands;
  coupling:      CrossFrequencyCoupling;
  phase_theta:   number;  // Current phase of theta oscillation [0, 2π]
  phase_alpha:   number;  // Current phase of alpha oscillation [0, 2π]
}

function initPACDrive(): PACDriveState {
  return {
    kfHz: 0,
    driveBoost: 1.0,
    coherenceGate: 0.5,
    oscillations: { delta: 0.2, theta: 0.3, alpha: 0.5, beta: 0.3, gamma_low: 0.4, gamma_high: 0.3, ripple: 0.1 },
    coupling: { gamma_theta_PLV: 0, beta_alpha_PLV: 0, gamma_theta_MI: 0, beta_alpha_MI: 0 },
    phase_theta: 0,
    phase_alpha: 0,
  };
}

function tickPACDrive(
  kfHz: number,
  neuro: NeurochemFull,
  prev: PACDriveState,
  dt: number
): PACDriveState {
  // ── OSCILLATION BAND DYNAMICS ──
  // Delta (0.5-4 Hz): deep sleep, subcortical motivation
  const delta = clamp(
    prev.oscillations.delta + (neuro.adenosine * 0.02 - neuro.norepinephrine * 0.015) * dt,
    0, 1
  );
  
  // Theta (4-8 Hz): hippocampal memory, navigation, REM sleep
  const theta = clamp(
    prev.oscillations.theta + (neuro.acetylcholine * 0.025 + neuro.glutamate * 0.015 - 0.01) * dt,
    0, 1
  );
  
  // Alpha (8-13 Hz): thalamo-cortical idling, inhibition
  const alpha = clamp(
    prev.oscillations.alpha + (neuro.gaba * 0.02 - neuro.glutamate * 0.015 + 0.005) * dt,
    0, 1
  );
  
  // Beta (13-30 Hz): motor control, active cognition
  const beta = clamp(
    prev.oscillations.beta + (neuro.dopamine * 0.02 + neuro.norepinephrine * 0.015 - 0.008) * dt,
    0, 1
  );
  
  // Gamma low (30-50 Hz): local cortical processing
  const gamma_low = clamp(
    prev.oscillations.gamma_low + (neuro.glutamate * 0.03 - neuro.gaba * 0.01) * dt,
    0, 1
  );
  
  // Gamma high (50-100 Hz): consciousness binding, attention
  const gamma_high = clamp(
    prev.oscillations.gamma_high + (neuro.acetylcholine * 0.025 + neuro.dopamine * 0.02 - 0.012) * dt,
    0, 1
  );
  
  // Ripple (100-250 Hz): hippocampal sharp-wave ripples (memory consolidation)
  const ripple = clamp(
    prev.oscillations.ripple + (theta * 0.015 + neuro.bdnf * 0.01 - 0.008) * dt,
    0, 1
  );

  // ── PHASE EVOLUTION ──
  // Theta: ~6 Hz = 37.7 rad/s
  const theta_freq = 4 + theta * 4; // 4-8 Hz range
  const phase_theta = (prev.phase_theta + TAU * theta_freq * dt * 0.001) % TAU;
  
  // Alpha: ~10 Hz = 62.8 rad/s
  const alpha_freq = 8 + alpha * 5; // 8-13 Hz range
  const phase_alpha = (prev.phase_alpha + TAU * alpha_freq * dt * 0.001) % TAU;

  // ── CROSS-FREQUENCY COUPLING ──
  // Gamma-Theta coupling: high-frequency amplitude modulated by low-frequency phase
  // Modulation Index: MI = |⟨A_high · e^(i·φ_low)⟩|
  const gamma_amplitude = (gamma_low + gamma_high) / 2;
  const gamma_theta_MI = clamp(
    gamma_amplitude * Math.abs(Math.cos(phase_theta)),
    0, 1
  );
  
  // Phase-Locking Value: consistency of phase relationship
  const gamma_theta_PLV = clamp(
    prev.coupling.gamma_theta_PLV + (gamma_theta_MI * 0.02 - 0.01) * dt,
    0, 1
  );
  
  // Beta-Alpha coupling: motor planning modulated by attention rhythm
  const beta_alpha_MI = clamp(
    beta * Math.abs(Math.cos(phase_alpha)),
    0, 1
  );
  
  const beta_alpha_PLV = clamp(
    prev.coupling.beta_alpha_PLV + (beta_alpha_MI * 0.018 - 0.009) * dt,
    0, 1
  );

  // ── DRIVE MODULATION ──
  // Higher PAC = better coordination of neural ensembles → stronger drive expression
  const pac_strength = (gamma_theta_PLV + beta_alpha_PLV) / 2;
  const driveBoost = 1.0 + (kfHz * 0.4 + pac_strength * 0.3);
  
  // Coherence gate: only execute drives when neural synchrony is sufficient
  const coherenceGate = kfHz * 0.6 + pac_strength * 0.4;

  return {
    kfHz,
    driveBoost,
    coherenceGate,
    oscillations: { delta, theta, alpha, beta, gamma_low, gamma_high, ripple },
    coupling: { gamma_theta_PLV, beta_alpha_PLV, gamma_theta_MI, beta_alpha_MI },
    phase_theta,
    phase_alpha,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// METAL SUBSYSTEMS — Noble/transition metals in neural processes
// ═══════════════════════════════════════════════════════════════════════════════
interface MetalDetailed {
  // Gold (Au): Mitochondrial electron transport, sovereign coherence base
  gold: number;
  goldETC: number;        // Electron transport chain enhancement
  goldCoherence: number;  // Quantum coherence contribution
  
  // Silver (Ag): Antimicrobial, rapid signaling
  silver: number;
  silverAntimicrobial: number;
  silverConductance: number;
  
  // Platinum (Pt): Catalytic, rare multiplicative events
  platinum: number;
  platinumCatalysis: number;
  platinumResonance: number;
  
  // Copper (Cu): Cofactor for neurotransmitter synthesis
  copper: number;
  copperDBH: number;      // Dopamine β-hydroxylase
  copperSOD: number;      // Superoxide dismutase (antioxidant)
  
  // Zinc (Zn): Synaptic modulation, NMDA receptor gating
  zinc: number;
  zincNMDA: number;       // Voltage-independent NMDA block
  zincMT: number;         // Metallothionein buffering
  
  // Iron (Fe): Oxygen transport, tyrosine hydroxylase cofactor
  iron: number;
  ironHeme: number;       // Hemoglobin oxygen carrying
  ironTH: number;         // Tyrosine hydroxylase (DA synthesis)
  ironOxidative: number;  // Fenton reaction risk
}

function initMetalDetailed(): MetalDetailed {
  return {
    gold: 0.5, goldETC: 0.3, goldCoherence: 0.4,
    silver: 0.4, silverAntimicrobial: 0.5, silverConductance: 0.6,
    platinum: 0.3, platinumCatalysis: 0.4, platinumResonance: 0.3,
    copper: 0.6, copperDBH: 0.5, copperSOD: 0.6,
    zinc: 0.7, zincNMDA: 0.6, zincMT: 0.7,
    iron: 0.6, ironHeme: 0.8, ironTH: 0.5, ironOxidative: 0.2,
  };
}

function tickMetalDetailed(
  prev: MetalDetailed,
  neuro: NeurochemFull,
  pacDrive: PACDriveState,
  dt: number
): MetalDetailed {
  // ── GOLD (Au) ──
  // Electron transport chain: Au nanoparticles enhance complex IV activity
  const goldETC = clamp(
    prev.goldETC + (prev.gold * 0.015 - 0.005) * dt,
    0, 1
  );
  
  // Quantum coherence: Au provides stable resonance for microtubule oscillations
  const goldCoherence = clamp(
    prev.goldCoherence + (pacDrive.kfHz * 0.02 + goldETC * 0.01 - 0.008) * dt,
    0, 1
  );
  
  const gold = clamp((goldETC + goldCoherence) / 2, 0, 1);
  
  // ── SILVER (Ag) ──
  // Antimicrobial: oligodynamic effect
  const silverAntimicrobial = clamp(
    prev.silverAntimicrobial + (prev.silver * 0.012 - 0.006) * dt,
    0, 1
  );
  
  // Electrical conductance: rapid signaling enhancement
  const silverConductance = clamp(
    prev.silverConductance + (neuro.norepinephrine * 0.01 + pacDrive.oscillations.gamma_high * 0.015) * dt,
    0, 1
  );
  
  const silver = clamp((silverAntimicrobial + silverConductance) / 2, 0, 1);
  
  // ── PLATINUM (Pt) ──
  // Catalytic activity: redox reactions
  const platinumCatalysis = clamp(
    prev.platinumCatalysis + (neuro.nitricOxide * 0.018 - 0.008) * dt,
    0, 1
  );
  
  // Resonance: rare multiplicative coherence events
  const platinumResonance = clamp(
    prev.platinumResonance + (pacDrive.coupling.gamma_theta_PLV * 0.02 - 0.01) * dt,
    0, 1
  );
  
  const platinum = clamp(platinumCatalysis * platinumResonance, 0, 1); // Multiplicative
  
  // ── COPPER (Cu) ──
  // Dopamine β-hydroxylase: DA → NE conversion
  const copperDBH = clamp(
    prev.copperDBH + (neuro.dopamine * 0.02 - 0.01) * dt,
    0, 1
  );
  
  // Superoxide dismutase: Cu/Zn-SOD antioxidant defense
  const copperSOD = clamp(
    prev.copperSOD + (prev.copper * 0.015 - prev.ironOxidative * 0.01) * dt,
    0, 1
  );
  
  const copper = clamp((copperDBH + copperSOD) / 2, 0, 1);
  
  // ── ZINC (Zn) ──
  // NMDA receptor modulation: voltage-independent block at high [Zn2+]
  const zincNMDA = clamp(
    prev.zincNMDA + (prev.zinc * 0.02 - neuro.glutamate * 0.015) * dt,
    0, 1
  );
  
  // Metallothionein buffering: protects against oxidative stress
  const zincMT = clamp(
    prev.zincMT + (prev.zinc * 0.018 + neuro.bdnf * 0.01 - 0.008) * dt,
    0, 1
  );
  
  const zinc = clamp((zincNMDA + zincMT) / 2, 0, 1);
  
  // ── IRON (Fe) ──
  // Hemoglobin: oxygen transport (peripheral, but affects brain oxygenation)
  const ironHeme = clamp(
    prev.ironHeme + (prev.iron * 0.01 - 0.003) * dt,
    0.5, 1  // Maintain high baseline
  );
  
  // Tyrosine hydroxylase: rate-limiting enzyme for catecholamine synthesis
  const ironTH = clamp(
    prev.ironTH + (prev.iron * 0.02 + neuro.dopamine * 0.01 - 0.01) * dt,
    0, 1
  );
  
  // Oxidative stress: Fenton reaction (Fe²⁺ + H₂O₂ → Fe³⁺ + •OH + OH⁻)
  const ironOxidative = clamp(
    prev.ironOxidative + (prev.iron * 0.008 - copperSOD * 0.015 - prev.zincMT * 0.01) * dt,
    0, 1
  );
  
  const iron = clamp((ironHeme + ironTH) / 2 - ironOxidative * 0.3, 0, 1);

  return {
    gold, goldETC, goldCoherence,
    silver, silverAntimicrobial, silverConductance,
    platinum, platinumCatalysis, platinumResonance,
    copper, copperDBH, copperSOD,
    zinc, zincNMDA, zincMT,
    iron, ironHeme, ironTH, ironOxidative,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECOND MESSENGER CASCADE DYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════
function initSecondMessengers(): SecondMessengerState {
  return {
    cAMP: 0.3,
    cGMP: 0.2,
    IP3: 0.15,
    DAG: 0.18,
    Ca2: 0.1,  // Baseline intracellular [Ca²⁺] ~100 nM
    PKA: 0.2,
    PKC: 0.15,
    CaMKII: 0.2,
    CREB: 0.25,
    deltaFosB: 0.1,
  };
}

function tickSecondMessengers(
  prev: SecondMessengerState,
  neuro: NeurochemFull,
  pacDrive: PACDriveState,
  dt: number
): SecondMessengerState {
  // ── cAMP (Cyclic AMP) ──
  // Activated by Gs-coupled receptors (D1, 5-HT4/6/7, β-ARs)
  const Gs_activation = neuro.dopamine * 0.3 + neuro.serotonin * 0.2 + neuro.norepinephrine * 0.25;
  // Inhibited by Gi-coupled receptors (D2, 5-HT1A, α2-ARs, A1)
  const Gi_activation = neuro.dopamine * 0.2 + neuro.serotonin * 0.15 + neuro.adenosine * 0.3;
  
  const cAMP = clamp(
    prev.cAMP + (Gs_activation * 0.04 - Gi_activation * 0.03 - prev.cAMP * 0.02) * dt,
    0, 1
  );
  
  // ── cGMP (Cyclic GMP) ──
  // Activated by nitric oxide → soluble guanylate cyclase
  const cGMP = clamp(
    prev.cGMP + (neuro.nitricOxide * 0.05 - prev.cGMP * 0.025) * dt,
    0, 1
  );
  
  // ── IP3 (Inositol 1,4,5-trisphosphate) ──
  // Gq-coupled receptors (5-HT2A/2C, mGluR1, M1/M3) → PLC → IP3
  const Gq_activation = neuro.serotonin * 0.25 + neuro.glutamate * 0.2 + neuro.acetylcholine * 0.2;
  const IP3 = clamp(
    prev.IP3 + (Gq_activation * 0.045 - prev.IP3 * 0.03) * dt,
    0, 1
  );
  
  // ── DAG (Diacylglycerol) ──
  // Co-produced with IP3 by PLC
  const DAG = clamp(
    prev.DAG + (Gq_activation * 0.04 - prev.DAG * 0.025) * dt,
    0, 1
  );
  
  // ── Ca²⁺ (Intracellular Calcium) ──
  // IP3 → IP3R → ER Ca²⁺ release
  // NMDA receptors → Ca²⁺ influx
  // L-type Ca²⁺ channels → depolarization-induced influx
  const Ca2 = clamp(
    prev.Ca2 + (
      IP3 * 0.06 +                    // IP3-induced release
      neuro.glutamate * 0.05 +        // NMDA influx
      pacDrive.oscillations.gamma_high * 0.03 -  // High-frequency spiking
      prev.Ca2 * 0.04                  // Pumps/exchangers
    ) * dt,
    0, 1
  );
  
  // ── PKA (Protein Kinase A) ──
  // Activated by cAMP
  const PKA = clamp(
    prev.PKA + (cAMP * 0.05 - prev.PKA * 0.025) * dt,
    0, 1
  );
  
  // ── PKC (Protein Kinase C) ──
  // Activated by DAG + Ca²⁺
  const PKC = clamp(
    prev.PKC + ((DAG * Ca2) * 0.06 - prev.PKC * 0.03) * dt,
    0, 1
  );
  
  // ── CaMKII (Ca²⁺/Calmodulin-Dependent Kinase II) ──
  // Activated by Ca²⁺-calmodulin complex
  // Autophosphorylates → persistent activity (molecular memory)
  const CaMKII = clamp(
    prev.CaMKII + (
      Ca2 * 0.07 +                    // Ca²⁺ activation
      prev.CaMKII * 0.02 -             // Autophosphorylation (positive feedback)
      prev.CaMKII * 0.025              // Phosphatase deactivation
    ) * dt,
    0, 1
  );
  
  // ── CREB (cAMP Response Element-Binding Protein) ──
  // Phosphorylated by PKA, CaMKII → binds CRE → gene transcription
  // Key for BDNF, c-Fos, Arc expression
  const CREB = clamp(
    prev.CREB + (
      PKA * 0.04 +
      CaMKII * 0.04 +
      neuro.bdnf * 0.02 -             // Positive feedback
      0.015
    ) * dt,
    0, 1
  );
  
  // ── ΔFosB (Delta FosB) ──
  // Transcription factor accumulating with repeated stimulation
  // Key molecular mechanism of addiction, habit formation
  // Half-life ~6-8 days (very slow decay)
  const deltaFosB = clamp(
    prev.deltaFosB + (
      CREB * 0.008 +                  // Gene transcription
      neuro.dopamine * 0.005 +        // D1 receptor stimulation
      pacDrive.driveBoost * 0.003 -
      prev.deltaFosB * 0.0002         // Very slow degradation
    ) * dt,
    0, 1
  );

  return { cAMP, cGMP, IP3, DAG, Ca2, PKA, PKC, CaMKII, CREB, deltaFosB };
}

// ═══════════════════════════════════════════════════════════════════════════════
// GENE EXPRESSION DYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════
function initGeneExpression(): GeneExpressionState {
  return {
    BDNF_mRNA: 0.3,
    cFos: 0.1,
    Arc: 0.15,
    Homer1a: 0.12,
    Zif268: 0.18,
    transcriptionDelay: 30,  // 30 minutes typical delay
  };
}

function tickGeneExpression(
  prev: GeneExpressionState,
  secondMessengers: SecondMessengerState,
  neuro: NeurochemFull,
  dt: number
): GeneExpressionState {
  // ── BDNF mRNA ──
  // Transcribed by CREB binding to CRE in BDNF promoter IV
  // Time delay: ~30-60 min for protein synthesis
  const BDNF_mRNA = clamp(
    prev.BDNF_mRNA + (
      secondMessengers.CREB * 0.025 +
      secondMessengers.Ca2 * 0.02 -   // Ca²⁺-dependent transcription
      0.01
    ) * dt,
    0, 1
  );
  
  // ── c-Fos ──
  // Immediate early gene (IEG), rapid induction <30 min
  // Marker of neural activity
  const cFos = clamp(
    prev.cFos + (
      secondMessengers.CREB * 0.05 +
      secondMessengers.PKA * 0.04 +
      neuro.glutamate * 0.03 -
      prev.cFos * 0.04              // Rapid degradation
    ) * dt,
    0, 1
  );
  
  // ── Arc (Activity-Regulated Cytoskeleton-Associated Protein) ──
  // IEG, critical for synaptic plasticity and memory consolidation
  const Arc = clamp(
    prev.Arc + (
      secondMessengers.CaMKII * 0.045 +
      secondMessengers.CREB * 0.03 +
      neuro.bdnf * 0.02 -
      prev.Arc * 0.035
    ) * dt,
    0, 1
  );
  
  // ── Homer1a ──
  // IEG, modulates mGluR signaling and synaptic structure
  const Homer1a = clamp(
    prev.Homer1a + (
      neuro.glutamate * 0.04 +
      secondMessengers.PKC * 0.025 -
      prev.Homer1a * 0.03
    ) * dt,
    0, 1
  );
  
  // ── Zif268 (Egr1) ──
  // Zinc finger transcription factor, consolidation of long-term memory
  const Zif268 = clamp(
    prev.Zif268 + (
      secondMessengers.CREB * 0.035 +
      cFos * 0.025 +
      Arc * 0.02 -
      prev.Zif268 * 0.028
    ) * dt,
    0, 1
  );

  return { BDNF_mRNA, cFos, Arc, Homer1a, Zif268, transcriptionDelay: 30 };
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN LAB STATE
// ═══════════════════════════════════════════════════════════════════════════════
interface LabState {
  beat:       number;
  neuro:      NeurochemFull;
  metals:     MetalDetailed;  // Changed to MetalDetailed
  drives:     DriveState;
  aegis:      AegisState;
  olfactory:  OlfactoryState;
  pacDrive:   PACDriveState;
  secondMessengers: SecondMessengerState;  // New
  geneExpression: GeneExpressionState;     // New
  vitality:   number;
  neuroplast: number;
  alloLoad:   number;
  crosstalkHistory: number[][];  // 21×21 interaction strength matrix over time
  shannonEntropy: number;        // New comprehensive metric
  kolmogorovComplexity: number;  // New
  freeEnergy: number;            // New (Friston's free energy principle)
  integratedInformation: number; // New (Φ - consciousness measure)
}

function initLabState(): LabState {
  return {
    beat: 0,
    neuro: { ...NEURO_BASELINES },
    metals: initMetalDetailed(),
    drives: initDrives(),
    aegis: initAegis(),
    olfactory: initOlfactory(),
    pacDrive: initPACDrive(),
    secondMessengers: initSecondMessengers(),
    geneExpression: initGeneExpression(),
    vitality: 0.5,
    neuroplast: 0.005,
    alloLoad: 0.3,
    crosstalkHistory: [],
    shannonEntropy: 0,
    kolmogorovComplexity: 0,
    freeEnergy: 0.5,
    integratedInformation: 0.3,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPREHENSIVE METRICS COMPUTATION
// ═══════════════════════════════════════════════════════════════════════════════
function computeMetrics(
  neuro: NeurochemFull,
  secondMessengers: SecondMessengerState,
  pacDrive: PACDriveState,
  aegis: AegisState
): { shannonEntropy: number; kolmogorovComplexity: number; freeEnergy: number; integratedInformation: number } {
  // ── SHANNON ENTROPY ──
  // H = -Σ p(x) log₂ p(x)
  // Measures diversity/uncertainty in NT distribution
  const neuroValues = Object.values(neuro);
  const total = neuroValues.reduce((sum, val) => sum + val, 0);
  const probabilities = neuroValues.map(v => v / (total + 1e-10));
  const shannonEntropy = -probabilities.reduce((sum, p) => {
    return p > 0 ? sum + p * Math.log2(p) : sum;
  }, 0) / Math.log2(21);  // Normalize by max entropy
  
  // ── KOLMOGOROV COMPLEXITY (ESTIMATE) ──
  // Approximate via compressibility of state sequence
  // Higher complexity = less compressible = more information
  const stateString = neuroValues.map(v => Math.floor(v * 10).toString()).join('');
  const repeats = stateString.match(/(.+)\1+/g)?.length ?? 0;
  const kolmogorovComplexity = 1 - (repeats / (stateString.length + 1));
  
  // ── FREE ENERGY (Friston's Free Energy Principle) ──
  // F = Complexity - Accuracy
  // Complexity = -ln P(observations)
  // Accuracy = expected surprise under posterior beliefs
  const prediction_error = Math.abs(
    neuro.dopamine - (secondMessengers.CREB * 0.5 + pacDrive.driveBoost * 0.3)
  );
  const complexity = shannonEntropy;
  const accuracy = 1 - prediction_error;
  const freeEnergy = clamp(complexity - accuracy, 0, 1);
  
  // ── INTEGRATED INFORMATION (Φ) ──
  // Tononi's measure of consciousness
  // Φ = effective information - sum of parts
  // Simplified: connectivity × diversity - decomposability
  const connectivity = (
    pacDrive.coupling.gamma_theta_PLV + 
    pacDrive.coupling.beta_alpha_PLV
  ) / 2;
  const diversity = shannonEntropy;
  const decomposability = aegis.sicknessResponse * 0.3 + (1 - pacDrive.coherenceGate) * 0.4;
  const integratedInformation = clamp(
    connectivity * diversity - decomposability,
    0, 1
  );

  return { shannonEntropy, kolmogorovComplexity, freeEnergy, integratedInformation };
}

function tick(prev: LabState): LabState {
  const beat = prev.beat + 1;
  const dt = NEURO_DT;

  // External inputs (simulated)
  const externalThreat = Math.sin(beat * 0.02) * 0.3 + 0.3;
  const externalOlfactory = Math.sin(beat * 0.05 + 1.5) * 0.4 + 0.5;
  const kfHzSimulated = 0.4 + Math.sin(beat * 0.01) * 0.3 + (beat > 200 ? 0.2 : 0);

  // 1. SECOND MESSENGERS (needs previous neuro for input)
  const secondMessengers = tickSecondMessengers(
    prev.secondMessengers,
    prev.neuro,
    prev.pacDrive,
    dt
  );

  // 2. GENE EXPRESSION
  const geneExpression = tickGeneExpression(
    prev.geneExpression,
    secondMessengers,
    prev.neuro,
    dt
  );

  // 3. PAC DRIVE (with updated dynamics)
  const pacDrive = tickPACDrive(kfHzSimulated, prev.neuro, prev.pacDrive, dt);

  // 4. AEGIS IMMUNE SYSTEM (with full neuroimmune integration)
  const aegis = tickAegis(prev.aegis, externalThreat, prev.neuro, beat, dt);

  // 5. OLFACTORY PATHWAY (with second messengers)
  const olfactory = tickOlfactory(
    prev.olfactory,
    externalOlfactory,
    prev.neuro,
    secondMessengers,
    dt
  );

  // 6. NEUROCHEMISTRY BASE STIMULI
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

  // 7. CROSSTALK MODULATION
  // Apply 66-pair crosstalk: for each pair, modulate target based on source level
  let neuro = neurochemFullStep(prev.neuro, baseStim, dt);
  const neuroArray = Object.values(neuro);
  const crosstalkMatrix: number[][] = Array.from({ length: 21 }, () => new Array(21).fill(0));
  
  CROSSTALK_66.forEach(([srcIdx, tgtIdx, weight, sign, receptorType, timeCourse]) => {
    const srcLevel = neuroArray[srcIdx] ?? 0.5;
    // Time course modulates effective weight
    const timeModulator = timeCourse === 'fast' ? 1.2 : 
                         timeCourse === 'medium' ? 1.0 :
                         timeCourse === 'slow' ? 0.7 :
                         0.3;  // genomic
    const modulation = srcLevel * weight * sign * timeModulator * 0.01;
    const tgtName = NT_NAMES[tgtIdx];
    if (tgtName && tgtName in neuro) {
      (neuro as any)[tgtName] = clamp((neuro as any)[tgtName] + modulation, 0.01, 2.0);
    }
    crosstalkMatrix[srcIdx][tgtIdx] = Math.abs(srcLevel * weight * timeModulator);
  });

  // 8. AEGIS NE/EPI/CYTOKINE INJECTION
  if (aegis.immuneActive) {
    neuro.norepinephrine = clamp(neuro.norepinephrine + aegis.neResponse * 0.05, 0, 2);
    neuro.epinephrine = clamp(neuro.epinephrine + aegis.epiResponse * 0.05, 0, 2);
  }
  // Cytokine → cortisol via HPA axis (already modeled in aegis.hpa.cortisol)
  neuro.cortisol = clamp(neuro.cortisol * 0.7 + aegis.hpa.cortisol * 0.3, 0, 2);

  // 9. OLFACTORY LIMBIC INJECTION
  if (olfactory.limbicInjection > 0.3) {
    // Direct amygdala activation: boost DA, OXT, or CORT depending on valence
    if (olfactory.emotionalValence > 0) {
      neuro.dopamine = clamp(neuro.dopamine + olfactory.limbicInjection * 0.03, 0, 2);
      neuro.oxytocin = clamp(neuro.oxytocin + olfactory.limbicInjection * 0.025, 0, 2);
    } else {
      neuro.cortisol = clamp(neuro.cortisol + olfactory.limbicInjection * 0.04, 0, 2);
      neuro.substanceP = clamp(neuro.substanceP + olfactory.limbicInjection * 0.02, 0, 2);
    }
  }

  // 10. GENE EXPRESSION → PROTEIN FEEDBACK
  // BDNF mRNA → BDNF protein (with delay)
  neuro.bdnf = clamp(
    neuro.bdnf * 0.8 + geneExpression.BDNF_mRNA * 0.2,  // Delayed synthesis
    0, 2
  );

  // 11. METAL PIPELINE (detailed subsystems)
  const metals = tickMetalDetailed(prev.metals, neuro, pacDrive, dt);

  // 12. DRIVE SYSTEMS (with detailed hypothalamic circuits)
  const drives = tickDrives(prev.drives, neuro, dt);

  // 13. NEUROCHEMISTRY DECAY
  neuro = neurochemDecayStep(neuro, dt);

  // 14. METAL PIPELINE (legacy compatibility for metal coherence)
  const legacyMetalState: MetalState = {
    gold: metals.gold,
    silver: metals.silver,
    platinum: metals.platinum,
  };
  const updatedLegacyMetals = metalPipelineStep(legacyMetalState, pacDrive.kfHz, dt);

  // 15. AGGREGATE METRICS
  const vitality = vitalityScore(neuro);
  const neuroplast = neuroplasticityFactor(neuro);
  const alloLoad = allostaticLoad(neuro);

  // 16. COMPREHENSIVE METRICS
  const comprehensiveMetrics = computeMetrics(neuro, secondMessengers, pacDrive, aegis);

  // 17. CROSSTALK HISTORY (keep last 100 timesteps)
  const crosstalkHistory = [...prev.crosstalkHistory, crosstalkMatrix].slice(-100);

  return {
    beat,
    neuro,
    metals,
    drives,
    aegis,
    olfactory,
    pacDrive,
    secondMessengers,
    geneExpression,
    vitality,
    neuroplast,
    alloLoad,
    crosstalkHistory,
    ...comprehensiveMetrics,
  };
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
// ADDITIONAL CANVAS DRAWERS
// ═══════════════════════════════════════════════════════════════════════════════

function drawSynthesisPathways(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  ctx.fillStyle = MUTED;
  ctx.font = 'bold 11px monospace';
  ctx.textAlign = 'left';
  ctx.fillText('NT SYNTHESIS PATHWAYS', 8, 16);
  
  const pathways = [
    { name: 'DA', steps: ['Tyr', 'TH→', 'L-DOPA', 'DDC→', 'DA'], color: GREEN, y: 35 },
    { name: 'NE', steps: ['DA', 'DBH→', 'NE'], color: ORANGE, y: 55 },
    { name: 'EPI', steps: ['NE', 'PNMT→', 'EPI'], color: RED, y: 75 },
    { name: '5-HT', steps: ['Trp', 'TPH→', '5-HTP', 'DDC→', '5-HT'], color: PURPLE, y: 95 },
    { name: 'ACh', steps: ['Choline+AcCoA', 'ChAT→', 'ACh'], color: CYAN, y: 115 },
  ];
  
  pathways.forEach(({ name, steps, color, y }) => {
    ctx.fillStyle = WHITE;
    ctx.font = '9px monospace';
    ctx.fillText(name + ':', 12, y);
    
    let x = 45;
    steps.forEach((step, i) => {
      if (step.includes('→')) {
        ctx.fillStyle = MUTED;
        ctx.font = '8px monospace';
      } else {
        ctx.fillStyle = color;
        ctx.font = 'bold 9px monospace';
      }
      ctx.fillText(step, x, y);
      x += ctx.measureText(step).width + 3;
    });
  });
  
  // Cofactor annotations
  ctx.fillStyle = GOLD;
  ctx.font = '8px monospace';
  ctx.fillText('Cofactors: BH4, Fe²⁺, O₂, PLP, Cu²⁺, SAM', 12, H - 10);
}

function drawReceptorBindingCurves(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  ctx.fillStyle = WHITE;
  ctx.font = 'bold 10px monospace';
  ctx.textAlign = 'left';
  ctx.fillText('RECEPTOR BINDING SATURATION', 8, 14);
  
  const graphX = 10, graphY = 25, graphW = W - 20, graphH = H - 45;
  
  // Axes
  ctx.strokeStyle = MUTED;
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.moveTo(graphX, graphY + graphH);
  ctx.lineTo(graphX + graphW, graphY + graphH);
  ctx.moveTo(graphX, graphY);
  ctx.lineTo(graphX, graphY + graphH);
  ctx.stroke();
  
  // Labels
  ctx.fillStyle = MUTED;
  ctx.font = '8px monospace';
  ctx.fillText('[NT]', graphX + graphW - 25, graphY + graphH + 12);
  ctx.save();
  ctx.translate(graphX - 6, graphY + graphH / 2);
  ctx.rotate(-Math.PI / 2);
  ctx.fillText('Occupancy', 0, 0);
  ctx.restore();
  
  // Michaelis-Menten curves for different receptors
  const receptors = [
    { name: 'D1', Kd: 0.3, color: GREEN },
    { name: 'D2', Kd: 0.5, color: CYAN },
    { name: '5HT2A', Kd: 0.8, color: PURPLE },
    { name: 'NMDA', Kd: 1.2, color: ORANGE },
  ];
  
  receptors.forEach(({ name, Kd, color }) => {
    ctx.strokeStyle = color;
    ctx.lineWidth = 2;
    ctx.globalAlpha = 0.7;
    ctx.beginPath();
    
    for (let i = 0; i <= 100; i++) {
      const ligand = (i / 100) * 3;  // 0 to 3 μM
      const occupancy = ligand / (ligand + Kd);  // Michaelis-Menten equation
      const x = graphX + (i / 100) * graphW;
      const y = graphY + graphH - (occupancy * graphH);
      i === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
    }
    ctx.stroke();
    ctx.globalAlpha = 1;
    
    // Label
    ctx.fillStyle = color;
    ctx.font = '8px monospace';
    const labelX = graphX + graphW * 0.7;
    const labelOccupancy = 2 / (2 + Kd);
    const labelY = graphY + graphH - (labelOccupancy * graphH);
    ctx.fillText(name, labelX + 5, labelY);
  });
  
  ctx.fillStyle = GOLD;
  ctx.font = '8px monospace';
  ctx.fillText('θ = [L]/([L]+Kd)', 12, H - 5);
}

function drawSecondMessengerCascade(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  ctx.fillStyle = CYAN;
  ctx.font = 'bold 10px monospace';
  ctx.fillText('SECOND MESSENGER CASCADE TIMELINE', 8, 14);
  
  const timeline = [
    { name: 'Receptor activation', time: 0, y: 30, color: WHITE },
    { name: 'G-protein activation', time: 10, y: 50, color: CYAN },
    { name: 'cAMP/IP3 production', time: 100, y: 70, color: GREEN },
    { name: 'PKA/PKC activation', time: 500, y: 90, color: PURPLE },
    { name: 'CREB phosphorylation', time: 2000, y: 110, color: ORANGE },
    { name: 'Gene transcription', time: 30000, y: 130, color: GOLD },
    { name: 'Protein synthesis', time: 60000, y: 150, color: PINK },
  ];
  
  timeline.forEach(({ name, time, y, color }) => {
    const x = 12 + Math.log10(time + 1) * 30;
    
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(x, y, 4, 0, TAU);
    ctx.fill();
    
    ctx.fillStyle = WHITE;
    ctx.font = '8px monospace';
    ctx.fillText(name, x + 8, y + 3);
    
    ctx.fillStyle = MUTED;
    ctx.font = '7px monospace';
    ctx.fillText(`${time}ms`, x + 8, y + 12);
  });
  
  // Current state indicators
  ctx.fillStyle = GREEN;
  ctx.font = '9px monospace';
  ctx.fillText(`cAMP: ${s.secondMessengers.cAMP.toFixed(2)}`, W - 150, 30);
  ctx.fillText(`Ca²⁺: ${s.secondMessengers.Ca2.toFixed(2)}`, W - 150, 45);
  ctx.fillText(`PKA: ${s.secondMessengers.PKA.toFixed(2)}`, W - 150, 60);
  ctx.fillText(`CREB: ${s.secondMessengers.CREB.toFixed(2)}`, W - 150, 75);
  ctx.fillText(`ΔFosB: ${s.secondMessengers.deltaFosB.toFixed(2)}`, W - 150, 90);
}

function drawHPAAxisFeedbackLoop(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  ctx.fillStyle = RED;
  ctx.font = 'bold 10px monospace';
  ctx.fillText('HPA AXIS FEEDBACK LOOP', 8, 14);
  
  const cx = W / 2, cy = H / 2;
  const radius = Math.min(W, H) * 0.3;
  
  // Circular flow: CRH → ACTH → Cortisol → Feedback
  const nodes = [
    { label: 'CRH', angle: -Math.PI / 2, value: s.aegis.hpa.CRH, color: ORANGE },
    { label: 'ACTH', angle: Math.PI / 6, value: s.aegis.hpa.ACTH, color: PURPLE },
    { label: 'CORT', angle: (2 * Math.PI) / 3, value: s.aegis.hpa.cortisol, color: RED },
    { label: 'Feedback', angle: (4 * Math.PI) / 3, value: s.aegis.hpa.feedback, color: CYAN },
  ];
  
  nodes.forEach(({ label, angle, value, color }, i) => {
    const x = cx + Math.cos(angle) * radius;
    const y = cy + Math.sin(angle) * radius;
    
    // Node circle
    ctx.fillStyle = color;
    ctx.globalAlpha = 0.7;
    ctx.beginPath();
    ctx.arc(x, y, 5 + value * 15, 0, TAU);
    ctx.fill();
    ctx.globalAlpha = 1;
    
    // Label
    ctx.fillStyle = WHITE;
    ctx.font = 'bold 10px monospace';
    ctx.textAlign = 'center';
    ctx.fillText(label, x, y - 25);
    
    ctx.font = '8px monospace';
    ctx.fillText(value.toFixed(2), x, y + 30);
    
    // Arrow to next node
    const nextAngle = nodes[(i + 1) % nodes.length].angle;
    const arrowStartX = cx + Math.cos(angle) * (radius - 25);
    const arrowStartY = cy + Math.sin(angle) * (radius - 25);
    const arrowEndX = cx + Math.cos(nextAngle) * (radius + 25);
    const arrowEndY = cy + Math.sin(nextAngle) * (radius + 25);
    
    ctx.strokeStyle = i === 3 ? CYAN : MUTED;  // Negative feedback in cyan
    ctx.lineWidth = i === 3 ? 2 : 1;
    ctx.globalAlpha = 0.5;
    ctx.beginPath();
    ctx.moveTo(arrowStartX, arrowStartY);
    ctx.lineTo(arrowEndX, arrowEndY);
    ctx.stroke();
    ctx.globalAlpha = 1;
  });
  
  ctx.fillStyle = GOLD;
  ctx.font = '8px monospace';
  ctx.textAlign = 'center';
  ctx.fillText('Hypothalamus → Pituitary → Adrenal', cx, cy);
}

function drawMicrobiomeDiversity(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  ctx.fillStyle = GREEN;
  ctx.font = 'bold 10px monospace';
  ctx.fillText('MICROBIOME-GUT-BRAIN AXIS', 8, 14);
  
  const barY = 30, barH = 25;
  const diversity = s.aegis.microbiomeDiversity;
  
  // Diversity bar
  ctx.fillStyle = MUTED;
  ctx.fillRect(12, barY, W - 24, barH);
  
  const gradient = ctx.createLinearGradient(12, barY, 12 + (W - 24) * diversity, barY);
  gradient.addColorStop(0, RED);
  gradient.addColorStop(0.5, ORANGE);
  gradient.addColorStop(1, GREEN);
  
  ctx.fillStyle = gradient;
  ctx.fillRect(12, barY, (W - 24) * diversity, barH);
  
  ctx.strokeStyle = BORDER;
  ctx.lineWidth = 1;
  ctx.strokeRect(12, barY, W - 24, barH);
  
  ctx.fillStyle = WHITE;
  ctx.font = '9px monospace';
  ctx.textAlign = 'center';
  ctx.fillText(`Diversity: ${(diversity * 100).toFixed(0)}%`, W / 2, barY + 17);
  
  // Cytokine influence
  ctx.fillStyle = WHITE;
  ctx.font = '8px monospace';
  ctx.textAlign = 'left';
  let y = barY + barH + 18;
  ctx.fillText(`IL-10 (anti-inflam): ${s.aegis.cytokines.IL10.toFixed(2)}`, 12, y);
  y += 12;
  ctx.fillText(`IL-6 (pro-inflam): ${s.aegis.cytokines.IL6.toFixed(2)}`, 12, y);
  y += 12;
  ctx.fillText(`TNF-α: ${s.aegis.cytokines.TNFalpha.toFixed(2)}`, 12, y);
  y += 12;
  ctx.fillText(`Vagus activity: ${s.aegis.vagusActivity.toFixed(2)}`, 12, y);
  
  ctx.fillStyle = MUTED;
  ctx.font = '7px monospace';
  ctx.fillText('SCFAs → BBB → Neurotransmitters', 12, H - 8);
}

function drawCircadianOscillator(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  ctx.fillStyle = PURPLE;
  ctx.font = 'bold 10px monospace';
  ctx.fillText('CIRCADIAN RHYTHM (SCN)', 8, 14);
  
  const cx = W / 2, cy = H / 2, radius = Math.min(W, H) * 0.35;
  
  // 24-hour clock face
  for (let hour = 0; hour < 24; hour++) {
    const angle = (hour / 24) * TAU - Math.PI / 2;
    const x1 = cx + Math.cos(angle) * (radius - 10);
    const y1 = cy + Math.sin(angle) * (radius - 10);
    const x2 = cx + Math.cos(angle) * radius;
    const y2 = cy + Math.sin(angle) * radius;
    
    ctx.strokeStyle = hour % 6 === 0 ? WHITE : MUTED;
    ctx.lineWidth = hour % 6 === 0 ? 2 : 1;
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();
    
    if (hour % 6 === 0) {
      ctx.fillStyle = WHITE;
      ctx.font = '9px monospace';
      ctx.textAlign = 'center';
      const tx = cx + Math.cos(angle) * (radius + 12);
      const ty = cy + Math.sin(angle) * (radius + 12);
      ctx.fillText(`${hour}h`, tx, ty + 3);
    }
  }
  
  // Current phase (based on SCN activity)
  const phase = s.drives.nuclei.SCN * TAU;
  const handAngle = phase - Math.PI / 2;
  const handX = cx + Math.cos(handAngle) * (radius - 15);
  const handY = cy + Math.sin(handAngle) * (radius - 15);
  
  ctx.strokeStyle = GOLD;
  ctx.lineWidth = 3;
  ctx.beginPath();
  ctx.moveTo(cx, cy);
  ctx.lineTo(handX, handY);
  ctx.stroke();
  
  ctx.fillStyle = GOLD;
  ctx.beginPath();
  ctx.arc(handX, handY, 5, 0, TAU);
  ctx.fill();
  
  // Phase labels
  ctx.fillStyle = WHITE;
  ctx.font = '8px monospace';
  ctx.textAlign = 'center';
  ctx.fillText('Wake', cx, cy - radius - 8);
  ctx.fillText('Sleep', cx, cy + radius + 14);
  
  ctx.fillStyle = CYAN;
  ctx.fillText(`Phase: ${(s.drives.nuclei.SCN * 24).toFixed(1)}h`, cx, cy + 5);
}

function drawSleepStageEEG(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  ctx.fillStyle = CYAN;
  ctx.font = 'bold 10px monospace';
  ctx.fillText('SLEEP STAGE EEG PATTERNS', 8, 14);
  
  const stages = [
    { name: 'Wake (β)', freq: 20, amp: 10, y: 30, color: ORANGE },
    { name: 'N1 (θ)', freq: 6, amp: 15, y: 55, color: GREEN },
    { name: 'N2 (σ)', freq: 12, amp: 20, y: 80, color: CYAN },
    { name: 'N3 (δ)', freq: 2, amp: 30, y: 105, color: PURPLE },
    { name: 'REM (β+θ)', freq: 18, amp: 12, y: 130, color: PINK },
  ];
  
  stages.forEach(({ name, freq, amp, y, color }) => {
    ctx.strokeStyle = color;
    ctx.lineWidth = 1.5;
    ctx.globalAlpha = 0.8;
    ctx.beginPath();
    
    for (let x = 0; x < W - 120; x++) {
      const t = x * 0.05;
      const wave = Math.sin(t * freq * 0.1 + s.beat * 0.1) * amp;
      const py = y + wave;
      x === 0 ? ctx.moveTo(x + 80, py) : ctx.lineTo(x + 80, py);
    }
    ctx.stroke();
    ctx.globalAlpha = 1;
    
    ctx.fillStyle = WHITE;
    ctx.font = '9px monospace';
    ctx.textAlign = 'left';
    ctx.fillText(name, 12, y + 4);
  });
  
  // Current state
  const sleepPressure = s.neuro.adenosine;
  ctx.fillStyle = GOLD;
  ctx.font = '8px monospace';
  ctx.fillText(`Adenosine (sleep pressure): ${sleepPressure.toFixed(2)}`, 12, H - 8);
}

function drawSynapticPlasticitySTDP(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  ctx.fillStyle = GREEN;
  ctx.font = 'bold 10px monospace';
  ctx.fillText('SPIKE-TIMING DEPENDENT PLASTICITY', 8, 14);
  
  const graphX = 40, graphY = 30, graphW = W - 80, graphH = H - 60;
  const centerY = graphY + graphH / 2;
  
  // Axes
  ctx.strokeStyle = WHITE;
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.moveTo(graphX, graphY);
  ctx.lineTo(graphX, graphY + graphH);
  ctx.moveTo(graphX, centerY);
  ctx.lineTo(graphX + graphW, centerY);
  ctx.stroke();
  
  // Labels
  ctx.fillStyle = WHITE;
  ctx.font = '8px monospace';
  ctx.textAlign = 'center';
  ctx.fillText('Δt (ms)', graphX + graphW / 2, graphY + graphH + 12);
  ctx.save();
  ctx.translate(graphX - 25, centerY);
  ctx.rotate(-Math.PI / 2);
  ctx.fillText('ΔW', 0, 0);
  ctx.restore();
  
  // STDP curve: potentiation before spike, depression after
  ctx.strokeStyle = GREEN;
  ctx.lineWidth = 2;
  ctx.globalAlpha = 0.8;
  ctx.beginPath();
  
  for (let i = 0; i <= 100; i++) {
    const dt = (i / 50 - 1) * 50;  // -50 to +50 ms
    const dw = dt < 0 
      ? Math.exp(dt / 20) * 0.6    // LTP: pre before post
      : -Math.exp(-dt / 20) * 0.4; // LTD: post before pre
    
    const x = graphX + (i / 100) * graphW;
    const y = centerY - (dw * graphH / 2);
    i === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
  }
  ctx.stroke();
  ctx.globalAlpha = 1;
  
  // Region labels
  ctx.fillStyle = GREEN;
  ctx.font = '9px monospace';
  ctx.fillText('LTP', graphX + graphW * 0.25, graphY + 15);
  ctx.fillStyle = RED;
  ctx.fillText('LTD', graphX + graphW * 0.75, graphY + graphH - 8);
  
  ctx.fillStyle = GOLD;
  ctx.font = '8px monospace';
  ctx.fillText('Pre→Post: strengthen  |  Post→Pre: weaken', graphX, graphY + graphH + 25);
  
  // Current plasticity
  ctx.fillStyle = CYAN;
  ctx.fillText(`Neuroplasticity: ${(s.neuroplast * 100).toFixed(1)}%`, W - 150, 25);
  ctx.fillText(`BDNF: ${s.neuro.bdnf.toFixed(2)}`, W - 150, 38);
  ctx.fillText(`CaMKII: ${s.secondMessengers.CaMKII.toFixed(2)}`, W - 150, 51);
}

function drawNeurovascularCoupling(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  ctx.fillStyle = RED;
  ctx.font = 'bold 10px monospace';
  ctx.fillText('NEUROVASCULAR COUPLING (BOLD)', 8, 14);
  
  // Neural activity → blood flow with ~4-6s delay
  const activityHistory = Math.sin(s.beat * 0.05) * 0.5 + 0.5;
  const boldDelay = Math.sin((s.beat - 50) * 0.05) * 0.5 + 0.5;
  
  const graphX = 12, graphY = 30, graphW = W - 24, graphH = (H - 60) / 2;
  
  // Neural activity trace
  ctx.strokeStyle = CYAN;
  ctx.lineWidth = 2;
  ctx.beginPath();
  for (let x = 0; x < graphW; x++) {
    const activity = Math.sin((x - s.beat * 2) * 0.05) * 0.5 + 0.5;
    const y = graphY + graphH - (activity * graphH);
    x === 0 ? ctx.moveTo(graphX + x, y) : ctx.lineTo(graphX + x, y);
  }
  ctx.stroke();
  
  ctx.fillStyle = CYAN;
  ctx.font = '9px monospace';
  ctx.fillText('Neural Activity', graphX, graphY - 5);
  
  // BOLD response (delayed)
  const boldY = graphY + graphH + 30;
  ctx.strokeStyle = RED;
  ctx.lineWidth = 2;
  ctx.beginPath();
  for (let x = 0; x < graphW; x++) {
    const bold = Math.sin((x - (s.beat - 50) * 2) * 0.05) * 0.5 + 0.5;
    const y = boldY + graphH - (bold * graphH);
    x === 0 ? ctx.moveTo(graphX + x, y) : ctx.lineTo(graphX + x, y);
  }
  ctx.stroke();
  
  ctx.fillStyle = RED;
  ctx.font = '9px monospace';
  ctx.fillText('BOLD Signal (4-6s delay)', graphX, boldY - 5);
  
  // Mechanism
  ctx.fillStyle = MUTED;
  ctx.font = '7px monospace';
  ctx.fillText('GLU → NO → vasodilation → ↑CBF → ↑O₂ → ↑deoxy-Hb', graphX, H - 8);
}

function drawBloodBrainBarrier(canvas: HTMLCanvasElement, s: LabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  ctx.fillStyle = PURPLE;
  ctx.font = 'bold 10px monospace';
  ctx.fillText('BLOOD-BRAIN BARRIER PERMEABILITY', 8, 14);
  
  const bbbY = H / 2;
  
  // BBB structure
  ctx.strokeStyle = WHITE;
  ctx.lineWidth = 3;
  ctx.beginPath();
  ctx.moveTo(0, bbbY);
  ctx.lineTo(W, bbbY);
  ctx.stroke();
  
  ctx.fillStyle = WHITE;
  ctx.font = '9px monospace';
  ctx.textAlign = 'center';
  ctx.fillText('BLOOD', W / 2, bbbY - 35);
  ctx.fillText('BRAIN', W / 2, bbbY + 45);
  
  // Molecules trying to cross
  const molecules = [
    { name: 'O₂/CO₂', permeable: true, x: 50, color: GREEN },
    { name: 'Glucose', permeable: true, x: 120, color: GREEN },
    { name: 'Amino acids', permeable: true, x: 190, color: GREEN },
    { name: 'Large proteins', permeable: false, x: 260, color: RED },
    { name: 'IL-6 (small)', permeable: true, x: 330, color: ORANGE },
    { name: 'Bacteria', permeable: false, x: 400, color: RED },
  ];
  
  molecules.forEach(({ name, permeable, x, color }) => {
    const y = permeable ? bbbY + 25 : bbbY - 25;
    
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(x, bbbY - 20, 5, 0, TAU);
    ctx.fill();
    
    if (permeable) {
      ctx.strokeStyle = color;
      ctx.lineWidth = 1;
      ctx.globalAlpha = 0.5;
      ctx.beginPath();
      ctx.moveTo(x, bbbY - 15);
      ctx.lineTo(x, y);
      ctx.stroke();
      ctx.globalAlpha = 1;
      
      ctx.fillStyle = color;
      ctx.beginPath();
      ctx.arc(x, y, 4, 0, TAU);
      ctx.fill();
    }
    
    ctx.fillStyle = WHITE;
    ctx.font = '7px monospace';
    ctx.textAlign = 'center';
    ctx.fillText(name, x, bbbY - 30);
  });
  
  ctx.fillStyle = GOLD;
  ctx.font = '8px monospace';
  ctx.textAlign = 'left';
  ctx.fillText('Tight junctions + astrocyte end-feet maintain selectivity', 12, H - 10);
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
  const synthesisRef = useRef<HTMLCanvasElement>(null);
  const receptorRef  = useRef<HTMLCanvasElement>(null);
  const messengerRef = useRef<HTMLCanvasElement>(null);
  const hpaRef       = useRef<HTMLCanvasElement>(null);
  const microbiomeRef = useRef<HTMLCanvasElement>(null);
  const circadianRef = useRef<HTMLCanvasElement>(null);
  const sleepRef     = useRef<HTMLCanvasElement>(null);
  const stdpRef      = useRef<HTMLCanvasElement>(null);
  const boldRef      = useRef<HTMLCanvasElement>(null);
  const bbbRef       = useRef<HTMLCanvasElement>(null);

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
    if (synthesisRef.current) drawSynthesisPathways(synthesisRef.current, simRef.current);
    if (receptorRef.current)  drawReceptorBindingCurves(receptorRef.current, simRef.current);
    if (messengerRef.current) drawSecondMessengerCascade(messengerRef.current, simRef.current);
    if (hpaRef.current)       drawHPAAxisFeedbackLoop(hpaRef.current, simRef.current);
    if (microbiomeRef.current) drawMicrobiomeDiversity(microbiomeRef.current, simRef.current);
    if (circadianRef.current) drawCircadianOscillator(circadianRef.current, simRef.current);
    if (sleepRef.current)     drawSleepStageEEG(sleepRef.current, simRef.current);
    if (stdpRef.current)      drawSynapticPlasticitySTDP(stdpRef.current, simRef.current);
    if (boldRef.current)      drawNeurovascularCoupling(boldRef.current, simRef.current);
    if (bbbRef.current)       drawBloodBrainBarrier(bbbRef.current, simRef.current);
    
    if (tickCnt.current % 8 === 0) setUi({ ...simRef.current });
    frameRef.current = requestAnimationFrame(animate);
  }, []);

  useEffect(() => {
    frameRef.current = requestAnimationFrame(animate);
    return () => cancelAnimationFrame(frameRef.current);
  }, [animate]);

  useEffect(() => {
    const refs = [
      ntRef, crosstalkRef, drivesRef, aegisRef, olfactoryRef,
      synthesisRef, receptorRef, messengerRef, hpaRef, microbiomeRef,
      circadianRef, sleepRef, stdpRef, boldRef, bbbRef
    ];
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
    gridExpanded: { display:'grid', gridTemplateColumns:'repeat(3, 1fr)', gridAutoRows:'minmax(120px, auto)', gap:2, padding:2, overflow:'auto' },
    cell: { position:'relative' as const, background:BG, overflow:'hidden' },
    canvas: { width:'100%', height:'100%', display:'block' },
    label: { position:'absolute' as const, top:3, left:5, fontSize:8, color:MUTED, pointerEvents:'none' as const, zIndex:1 },
    bottom: { background:BG2, borderTop:`1px solid ${BORDER}`, padding:'6px 12px', display:'flex', gap:16, fontSize:9, color:WHITE, fontFamily:'monospace', overflowX:'auto' as const },
    bottomExpanded: { background:BG2, borderTop:`1px solid ${BORDER}`, padding:'8px 12px', display:'grid', gridTemplateColumns:'repeat(auto-fit, minmax(280px, 1fr))', gap:'12px 16px', fontSize:8, color:WHITE, fontFamily:'monospace', overflowY:'auto', maxHeight:200 },
    eqSec: (c:string) => ({ borderLeft:`2px solid ${c}`, paddingLeft:8, minWidth:200 }),
    eqTitle: (c:string) => ({ color:c, fontWeight:'bold', marginBottom:2, fontSize:9 }),
  };

  return (
    <div style={S.root}>
      <header style={S.header}>
        <div style={S.title}>⬡ NOVA · NEUROCOG LAB · FULL COMPLEXITY</div>
        {[
          { label:'Beat',       val:String(ui.beat),               color:CYAN   },
          { label:'DA',         val:ui.neuro.dopamine.toFixed(2),  color:GREEN  },
          { label:'SER',        val:ui.neuro.serotonin.toFixed(2), color:PURPLE },
          { label:'CORT',       val:ui.neuro.cortisol.toFixed(2),  color:RED    },
          { label:'BDNF',       val:ui.neuro.bdnf.toFixed(2),      color:GOLD   },
          { label:'cAMP',       val:ui.secondMessengers.cAMP.toFixed(2), color:CYAN },
          { label:'CREB',       val:ui.secondMessengers.CREB.toFixed(2), color:ORANGE },
          { label:'Φ',          val:ui.integratedInformation.toFixed(2), color:PURPLE },
          { label:'H(entropy)', val:ui.shannonEntropy.toFixed(2), color:GREEN },
          { label:'Vitality',   val:ui.vitality.toFixed(3),        color:GREEN  },
          { label:'Neuroplast', val:(ui.neuroplast*100).toFixed(1),color:CYAN   },
          { label:'AlloLoad',   val:ui.alloLoad.toFixed(3),        color:ORANGE },
          { label:'Au/Ag/Pt',   val:`${ui.metals.gold.toFixed(1)}/${ui.metals.silver.toFixed(1)}/${ui.metals.platinum.toFixed(1)}`, color:GOLD },
          { label:'AEGIS',      val:ui.aegis.immuneActive?'ON':'OFF', color:ui.aegis.immuneActive?RED:MUTED },
        ].map(({ label, val, color }) => (
          <div key={label} style={S.stat}>
            <span style={S.statLabel}>{label}</span>
            <span style={S.statVal(color)}>{val}</span>
          </div>
        ))}
      </header>

      <div style={S.gridExpanded}>
        <div style={{...S.cell, gridRow:'1/3'}}>
          <canvas ref={ntRef} style={S.canvas} />
        </div>
        <div style={S.cell}>
          <canvas ref={crosstalkRef} style={S.canvas} />
        </div>
        <div style={S.cell}>
          <canvas ref={messengerRef} style={S.canvas} />
        </div>
        <div style={S.cell}>
          <canvas ref={drivesRef} style={S.canvas} />
        </div>
        <div style={S.cell}>
          <canvas ref={hpaRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'1/2'}}>
          <canvas ref={aegisRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'2/3'}}>
          <canvas ref={olfactoryRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'3/4'}}>
          <canvas ref={synthesisRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'1/2'}}>
          <canvas ref={receptorRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'2/3'}}>
          <canvas ref={microbiomeRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'3/4'}}>
          <canvas ref={circadianRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'1/2'}}>
          <canvas ref={sleepRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'2/3'}}>
          <canvas ref={stdpRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'3/4'}}>
          <canvas ref={boldRef} style={S.canvas} />
        </div>
        <div style={{...S.cell, gridColumn:'1/-1'}}>
          <canvas ref={bbbRef} style={S.canvas} />
        </div>
      </div>

      <div style={S.bottomExpanded}>
        <div style={S.eqSec(CYAN)}>
          <div style={S.eqTitle(CYAN)}>HODGKIN-HUXLEY EQUATIONS</div>
          <div>Cm·dV/dt = -gNa·m³h(V-ENa) - gK·n⁴(V-EK) - gL(V-EL) + I</div>
          <div>dm/dt = αm(V)(1-m) - βm(V)m</div>
          <div>dh/dt = αh(V)(1-h) - βh(V)h</div>
          <div>dn/dt = αn(V)(1-n) - βn(V)n</div>
        </div>
        <div style={S.eqSec(PURPLE)}>
          <div style={S.eqTitle(PURPLE)}>CABLE THEORY</div>
          <div>λ = √(rm/ri)  [length constant]</div>
          <div>τm = rm·cm  [membrane time constant]</div>
          <div>∂²V/∂x² = (ri/rm)V + (ri·cm)∂V/∂t</div>
        </div>
        <div style={S.eqSec(ORANGE)}>
          <div style={S.eqTitle(ORANGE)}>STDP (SPIKE-TIMING)</div>
          <div>ΔW = A+·exp(-Δt/τ+)  if Δt {'>'} 0  [LTP]</div>
          <div>ΔW = -A-·exp(Δt/τ-)  if Δt {'<'} 0  [LTD]</div>
          <div>W(t+1) = W(t) + η·ΔW</div>
        </div>
        <div style={S.eqSec(RED)}>
          <div style={S.eqTitle(RED)}>BCM PLASTICITY RULE</div>
          <div>dW/dt = η·y(y - θm)(x - θpre)</div>
          <div>θm = E[y²]  [sliding threshold]</div>
          <div>Bidirectional: LTP if y{'>'} θm, LTD if y{'<'} θm</div>
        </div>
        <div style={S.eqSec(GREEN)}>
          <div style={S.eqTitle(GREEN)}>HOMEOSTATIC SCALING</div>
          <div>W → α·W  where α = (⟨y⟩target/⟨y⟩actual)</div>
          <div>Maintains firing rate stability</div>
        </div>
        <div style={S.eqSec(GOLD)}>
          <div style={S.eqTitle(GOLD)}>RECEPTOR BINDING</div>
          <div>[LR] = Bmax·[L] / ([L] + Kd)</div>
          <div>Kd = koff/kon  [dissociation constant]</div>
          <div>Occupancy θ = [L]/([L]+Kd)</div>
        </div>
        <div style={S.eqSec(PINK)}>
          <div style={S.eqTitle(PINK)}>SECOND MESSENGERS</div>
          <div>d[cAMP]/dt = Vmax·[ATP]/(Km+[ATP]) - kPDE·[cAMP]</div>
          <div>[Ca²⁺]i = [Ca²⁺]rest + Δ[Ca²⁺]influx - Jpump</div>
        </div>
        <div style={S.eqSec(CYAN)}>
          <div style={S.eqTitle(CYAN)}>GENE EXPRESSION</div>
          <div>d[mRNA]/dt = ktrans·[TF] - kdeg·[mRNA]</div>
          <div>d[Protein]/dt = ktransl·[mRNA] - kdeg·[Protein]</div>
          <div>Delay τ ~ 30-60 min for protein synthesis</div>
        </div>
        <div style={S.eqSec(PURPLE)}>
          <div style={S.eqTitle(PURPLE)}>FREE ENERGY (FRISTON)</div>
          <div>F = Complexity - Accuracy</div>
          <div>F ≈ -ln P(observations|model)</div>
          <div>Minimize F → Active inference</div>
        </div>
        <div style={S.eqSec(ORANGE)}>
          <div style={S.eqTitle(ORANGE)}>INTEGRATED INFO (Φ)</div>
          <div>Φ = EI(system) - Σ EI(parts)</div>
          <div>EI = H(Xt+1) - H(Xt+1|Xt)</div>
          <div>Consciousness ∝ Φ</div>
        </div>
        <div style={S.eqSec(RED)}>
          <div style={S.eqTitle(RED)}>HPA AXIS DYNAMICS</div>
          <div>Cytokines → CRH → ACTH → Cortisol</div>
          <div>Negative feedback: CORT ⊣ CRH/ACTH</div>
          <div>τ ~ 10-30 min response time</div>
        </div>
        <div style={S.eqSec(GREEN)}>
          <div style={S.eqTitle(GREEN)}>PAC MODULATION</div>
          <div>MI = |⟨Ahigh·e^(iφlow)⟩|</div>
          <div>PLV = |⟨e^(i(φ1-φ2))⟩|</div>
          <div>γ amplitude ← θ phase nesting</div>
        </div>
        <div style={S.eqSec(GOLD)}>
          <div style={S.eqTitle(GOLD)}>METAL SUBSYSTEMS</div>
          <div>Au: ETC Complex IV, quantum coherence</div>
          <div>Cu: DBH (DA→NE), SOD (antioxidant)</div>
          <div>Zn: NMDA block, metallothionein</div>
          <div>Fe: TH (Tyr→L-DOPA), O₂ transport</div>
        </div>
        <div style={S.eqSec(PINK)}>
          <div style={S.eqTitle(PINK)}>OLFACTORY PATHWAY</div>
          <div>ORN → Glomerulus (1000:1) → Mitral</div>
          <div>→ Piriform cortex (NO THALAMUS!)</div>
          <div>→ Entorhinal → Hippocampus (memory)</div>
          <div>→ Amygdala (emotion)</div>
        </div>
        <div style={S.eqSec(CYAN)}>
          <div style={S.eqTitle(CYAN)}>MICROBIOME-GUT-BRAIN</div>
          <div>SCFAs (butyrate) → BBB → 5-HT synthesis</div>
          <div>Vagus nerve: gut → brainstem</div>
          <div>Dysbiosis → ↑cytokines → sickness behavior</div>
        </div>
        <div style={S.eqSec(PURPLE)}>
          <div style={S.eqTitle(PURPLE)}>NEUROTRANSMITTER SYNTHESIS</div>
          <div>Tyr →[TH]→ L-DOPA →[DDC]→ DA →[DBH]→ NE →[PNMT]→ EPI</div>
          <div>Trp →[TPH]→ 5-HTP →[DDC]→ 5-HT</div>
          <div>Choline+AcCoA →[ChAT]→ ACh</div>
        </div>
        <div style={S.eqSec(ORANGE)}>
          <div style={S.eqTitle(ORANGE)}>DEGRADATION KINETICS</div>
          <div>MAO-A/B: monoamine → aldehyde + NH₃</div>
          <div>COMT: catechol → O-methyl derivative</div>
          <div>AChE: ACh → choline + acetate (kcat=25000/s!)</div>
        </div>
        <div style={S.eqSec(RED)}>
          <div style={S.eqTitle(RED)}>CROSSTALK MATRIX</div>
          <div>66 pairs: receptor-level interactions</div>
          <div>Time courses: fast ({'<'}100ms), medium, slow, genomic (30min+)</div>
          <div>Example: D2→5HT1A, NMDA→BDNF→TrkB</div>
        </div>
        <div style={S.eqSec(GREEN)}>
          <div style={S.eqTitle(GREEN)}>COMPREHENSIVE METRICS</div>
          <div>Shannon H={ui.shannonEntropy.toFixed(2)} | K≈{ui.kolmogorovComplexity.toFixed(2)}</div>
          <div>FreeEnergy F={ui.freeEnergy.toFixed(2)} | Φ={ui.integratedInformation.toFixed(2)}</div>
          <div>Vitality={ui.vitality.toFixed(3)} | Allostatic Load={ui.alloLoad.toFixed(3)}</div>
        </div>
      </div>
    </div>
  );
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
