// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ============================================================
// NEURAL EMERGENCE CORE (NEC) — Full Expansion
// 100-region biophysical brain model with:
//   • Leaky Integrate-and-Fire (LIF) dynamics per region
//   • 50+ neurochemical state
//   • 10 white-matter fiber tracts
//   • Hebbian coupling, LFP, frequency-band power
//   • Purely functional tick pipeline
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array  "mo:base/Array";

module {

  // ══════════════════════════════════════════════════════════
  // TYPES
  // ══════════════════════════════════════════════════════════

  public type RegionCategory = { #Cortical; #Subcortical; #Brainstem; #Cerebellar; #Limbic };

  public type APPhase = { #Resting; #Rising; #Repolarizing; #Hyperpolarizing; #Refractory };

  public type IonChannels = {
    na_conductance   : Float;
    k_conductance    : Float;
    ca_conductance   : Float;
    cl_conductance   : Float;
  };

  public type LIFState = {
    voltage          : Float;
    membrane_cap     : Float;
    leak_cond        : Float;
    spike_threshold  : Float;
    refractory_ticks : Nat;
    spike_rate       : Float;
    exc_input        : Float;
    inh_input        : Float;
  };

  public type RegionState = {
    id               : Nat;
    name             : Text;
    category         : RegionCategory;
    activation       : Float;
    deficit          : Float;
    hebbian_weight   : Float;
    lif              : LIFState;
    channels         : IonChannels;
    ap_phase         : APPhase;
    lfp              : Float;
    delta_power      : Float;
    theta_power      : Float;
    alpha_power      : Float;
    beta_power       : Float;
    gamma_power      : Float;
  };

  public type NECChemState = {
    // Monoamines + primary neurotransmitters
    dopamine         : Float;
    serotonin        : Float;
    norepinephrine   : Float;
    acetylcholine    : Float;
    gaba             : Float;
    glutamate        : Float;
    endorphin        : Float;
    adenosine        : Float;
    // Monoamine metabolites
    ldopa            : Float;
    dopac            : Float;
    // Neuropeptides
    substance_p      : Float;
    npy              : Float;
    vip              : Float;
    crh              : Float;
    crf              : Float;
    cck              : Float;
    enkephalin       : Float;
    dynorphin        : Float;
    galanin          : Float;
    // Neuroactive steroids
    estradiol        : Float;
    testosterone     : Float;
    dhea             : Float;
    progesterone     : Float;
    allopregnanolone : Float;
    // Amino acid modulators
    taurine          : Float;
    glycine          : Float;
    d_serine         : Float;
    aspartate        : Float;
    // Gaseous transmitters
    nitric_oxide     : Float;
    carbon_monoxide  : Float;
    hydrogen_sulfide : Float;
    // Purines
    atp              : Float;
    adp              : Float;
    // Trace amines
    tyramine         : Float;
    tryptamine       : Float;
    // Endocannabinoids
    aea              : Float;
    two_ag           : Float;
    // Growth factors
    bdnf             : Float;
    ngf              : Float;
    // Stress / hormonal
    cortisol         : Float;
    epinephrine      : Float;
    vasopressin      : Float;
    oxytocin         : Float;
    melatonin        : Float;
    histamine        : Float;
    // Nitric oxide synthase
    no_synthase      : Float;
  };

  public type FiberTract = {
    id                 : Nat;
    name               : Text;
    source_region      : Nat;
    target_region      : Nat;
    conduction_vel     : Float;
    myelination_ratio  : Float;
    axonal_density     : Float;
    synaptic_delay_ms  : Float;
    signal_strength    : Float;
  };

  public type NECState = {
    beat             : Nat;
    regions          : [RegionState];
    chem             : NECChemState;
    tracts           : [FiberTract];
    global_coherence : Float;
    emergence_index  : Float;
  };

  public type NECSummary = {
    beat              : Nat;
    global_coherence  : Float;
    emergence_index   : Float;
    region_count      : Nat;
    tract_count       : Nat;
    top_region_name   : Text;
    top_region_act    : Float;
    mean_spike_rate   : Float;
    mean_lfp          : Float;
    dopamine          : Float;
    serotonin         : Float;
    norepinephrine    : Float;
    glutamate         : Float;
    gaba              : Float;
    mean_delta        : Float;
    mean_theta        : Float;
    mean_alpha        : Float;
    mean_beta         : Float;
    mean_gamma        : Float;
  };

  // ══════════════════════════════════════════════════════════
  // 100 BRAIN REGION DEFINITIONS
  // Indices 0-45:  Cortical (33 original + 13 extended)
  // Indices 46-66: Subcortical (21)
  // Indices 67-73: Limbic (7)
  // Indices 74-91: Brainstem (18)
  // Indices 92-99: Cerebellar (8)
  // ══════════════════════════════════════════════════════════

  public let REGION_DEFS : [{ id : Nat; name : Text; category : RegionCategory }] = [
    // ── Cortical (original 33) ────────────────────────────
    { id = 0;  name = "BA1 (Primary Somatosensory)";          category = #Cortical },
    { id = 1;  name = "BA2 (Somatosensory Assoc)";            category = #Cortical },
    { id = 2;  name = "BA3 (Primary Somatosensory II)";       category = #Cortical },
    { id = 3;  name = "BA4 (Primary Motor)";                  category = #Cortical },
    { id = 4;  name = "BA5 (Somatosensory Assoc II)";         category = #Cortical },
    { id = 5;  name = "BA6 (Premotor)";                       category = #Cortical },
    { id = 6;  name = "BA7 (Superior Parietal)";              category = #Cortical },
    { id = 7;  name = "BA8 (Frontal Eye Field)";              category = #Cortical },
    { id = 8;  name = "BA9 (Prefrontal DLPFC)";               category = #Cortical },
    { id = 9;  name = "BA10 (Frontopolar)";                   category = #Cortical },
    { id = 10; name = "BA11 (Orbitofrontal)";                 category = #Cortical },
    { id = 11; name = "BA17 (Primary Visual V1)";             category = #Cortical },
    { id = 12; name = "BA18 (Visual Assoc V2)";               category = #Cortical },
    { id = 13; name = "BA19 (Visual Assoc V3)";               category = #Cortical },
    { id = 14; name = "BA20 (Inferior Temporal)";             category = #Cortical },
    { id = 15; name = "BA21 (Middle Temporal)";               category = #Cortical },
    { id = 16; name = "BA22 (Superior Temporal)";             category = #Cortical },
    { id = 17; name = "BA23 (Posterior Cingulate)";           category = #Cortical },
    { id = 18; name = "BA24 (Anterior Cingulate)";            category = #Cortical },
    { id = 19; name = "BA25 (Subgenual Cingulate)";           category = #Cortical },
    { id = 20; name = "BA28 (Entorhinal Cortex)";             category = #Cortical },
    { id = 21; name = "BA34 (Piriform Cortex)";               category = #Cortical },
    { id = 22; name = "BA37 (Fusiform)";                      category = #Cortical },
    { id = 23; name = "BA38 (Temporal Pole)";                 category = #Cortical },
    { id = 24; name = "BA39 (Angular Gyrus)";                 category = #Cortical },
    { id = 25; name = "BA40 (Supramarginal Gyrus)";           category = #Cortical },
    { id = 26; name = "BA41 (Primary Auditory)";              category = #Cortical },
    { id = 27; name = "BA42 (Auditory Assoc)";                category = #Cortical },
    { id = 28; name = "BA43 (Subcentral)";                    category = #Cortical },
    { id = 29; name = "BA44 (Broca pars opercularis)";        category = #Cortical },
    { id = 30; name = "BA45 (Broca pars triangularis)";       category = #Cortical },
    { id = 31; name = "BA46 (DLPFC Mid)";                     category = #Cortical },
    { id = 32; name = "BA47 (Inferior Frontal Gyrus)";        category = #Cortical },
    // ── Cortical (extended 13) ────────────────────────────
    { id = 33; name = "BA26 (Ectosplenial Area)";             category = #Cortical },
    { id = 34; name = "BA27 (Parahippocampal Gyrus Ant)";     category = #Cortical },
    { id = 35; name = "BA29 (Retrosplenial Cortex)";          category = #Cortical },
    { id = 36; name = "BA30 (Cingulate Gyrus)";               category = #Cortical },
    { id = 37; name = "BA31 (Superior Cingulate)";            category = #Cortical },
    { id = 38; name = "BA32 (Anterior Paracingulate)";        category = #Cortical },
    { id = 39; name = "BA33 (Anterior Cingulate Sub)";        category = #Cortical },
    { id = 40; name = "BA35 (Perirhinal Cortex)";             category = #Cortical },
    { id = 41; name = "BA36 (Parahippocampal Cortex)";        category = #Cortical },
    { id = 42; name = "BA48 (Retrosubicular Area)";           category = #Cortical },
    { id = 43; name = "Insula Anterior";                      category = #Cortical },
    { id = 44; name = "Insula Posterior";                     category = #Cortical },
    { id = 45; name = "Supplementary Motor Area";             category = #Cortical },
    // ── Subcortical (21) ──────────────────────────────────
    { id = 46; name = "Caudate Nucleus";                      category = #Subcortical },
    { id = 47; name = "Putamen";                              category = #Subcortical },
    { id = 48; name = "Nucleus Accumbens";                    category = #Subcortical },
    { id = 49; name = "Globus Pallidus Internal";             category = #Subcortical },
    { id = 50; name = "Globus Pallidus External";             category = #Subcortical },
    { id = 51; name = "Subthalamic Nucleus";                  category = #Subcortical },
    { id = 52; name = "Thalamus Mediodorsal";                 category = #Subcortical },
    { id = 53; name = "Thalamus Ventral Anterior";            category = #Subcortical },
    { id = 54; name = "Thalamus Ventral Lateral";             category = #Subcortical },
    { id = 55; name = "Thalamus Pulvinar";                    category = #Subcortical },
    { id = 56; name = "Thalamus Lateral Geniculate";          category = #Subcortical },
    { id = 57; name = "Thalamus Medial Geniculate";           category = #Subcortical },
    { id = 58; name = "Hypothalamus Lateral";                 category = #Subcortical },
    { id = 59; name = "Hypothalamus Medial";                  category = #Subcortical },
    { id = 60; name = "Hypothalamus Arcuate";                 category = #Subcortical },
    { id = 61; name = "Hypothalamus Suprachiasmatic";         category = #Subcortical },
    { id = 62; name = "Hypothalamus Paraventricular";         category = #Subcortical },
    { id = 63; name = "Septum Medial";                        category = #Subcortical },
    { id = 64; name = "Nucleus Basalis Meynert";              category = #Subcortical },
    { id = 65; name = "Claustrum";                            category = #Subcortical },
    { id = 66; name = "Habenula";                             category = #Subcortical },
    // ── Limbic (7) ────────────────────────────────────────
    { id = 67; name = "Amygdala Basolateral";                 category = #Limbic },
    { id = 68; name = "Amygdala Central";                     category = #Limbic },
    { id = 69; name = "Amygdala Medial";                      category = #Limbic },
    { id = 70; name = "Hippocampus CA1";                      category = #Limbic },
    { id = 71; name = "Hippocampus CA3";                      category = #Limbic },
    { id = 72; name = "Hippocampus Dentate Gyrus";            category = #Limbic },
    { id = 73; name = "Hippocampus Subiculum";                category = #Limbic },
    // ── Brainstem (18) ────────────────────────────────────
    { id = 74; name = "Locus Coeruleus";                      category = #Brainstem },
    { id = 75; name = "Dorsal Raphe";                         category = #Brainstem },
    { id = 76; name = "Median Raphe";                         category = #Brainstem },
    { id = 77; name = "Substantia Nigra Pars Compacta";       category = #Brainstem },
    { id = 78; name = "Substantia Nigra Pars Reticulata";     category = #Brainstem },
    { id = 79; name = "VTA (Ventral Tegmental Area)";         category = #Brainstem },
    { id = 80; name = "Periaqueductal Gray";                  category = #Brainstem },
    { id = 81; name = "Superior Colliculus";                  category = #Brainstem },
    { id = 82; name = "Inferior Colliculus";                  category = #Brainstem },
    { id = 83; name = "Pedunculopontine Nucleus";             category = #Brainstem },
    { id = 84; name = "Dorsal Motor Vagus";                   category = #Brainstem },
    { id = 85; name = "Nucleus Tractus Solitarius";           category = #Brainstem },
    { id = 86; name = "Parabrachial Nucleus";                 category = #Brainstem },
    { id = 87; name = "Pontine Reticular Formation";          category = #Brainstem },
    { id = 88; name = "Medullary Reticular Formation";        category = #Brainstem },
    { id = 89; name = "Red Nucleus";                          category = #Brainstem },
    { id = 90; name = "Cranial Nerve VII Nucleus";            category = #Brainstem },
    { id = 91; name = "Cochlear Nucleus";                     category = #Brainstem },
    // ── Cerebellar (8) ────────────────────────────────────
    { id = 92; name = "Cerebellar Molecular Layer";           category = #Cerebellar },
    { id = 93; name = "Cerebellar Purkinje Layer";            category = #Cerebellar },
    { id = 94; name = "Cerebellar Granule Layer";             category = #Cerebellar },
    { id = 95; name = "Cerebellar Deep Nuclei (Dentate)";     category = #Cerebellar },
    { id = 96; name = "Cerebellar Deep Nuclei (Interposed)";  category = #Cerebellar },
    { id = 97; name = "Cerebellar Deep Nuclei (Fastigial)";   category = #Cerebellar },
    { id = 98; name = "Vermis";                               category = #Cerebellar },
    { id = 99; name = "Flocculus";                            category = #Cerebellar },
  ];

  // ══════════════════════════════════════════════════════════
  // INTERNAL HELPERS
  // ══════════════════════════════════════════════════════════

  func clampF(v : Float, lo : Float, hi : Float) : Float {
    if (v < lo) lo else if (v > hi) hi else v
  };

  func baselineLIF() : LIFState = {
    voltage          = -65.0;
    membrane_cap     = 100.0;
    leak_cond        = 10.0;
    spike_threshold  = -50.0;
    refractory_ticks = 0;
    spike_rate       = 5.0;
    exc_input        = 1.0;
    inh_input        = 0.5;
  };

  func baselineChannels() : IonChannels = {
    na_conductance = 0.3;
    k_conductance  = 0.4;
    ca_conductance = 0.1;
    cl_conductance = 0.2;
  };

  func baselineChem() : NECChemState = {
    dopamine         = 0.50;
    serotonin        = 0.50;
    norepinephrine   = 0.40;
    acetylcholine    = 0.60;
    gaba             = 0.70;
    glutamate        = 0.60;
    endorphin        = 0.30;
    adenosine        = 0.40;
    ldopa            = 0.20;
    dopac            = 0.15;
    substance_p      = 0.30;
    npy              = 0.35;
    vip              = 0.25;
    crh              = 0.20;
    crf              = 0.20;
    cck              = 0.25;
    enkephalin       = 0.30;
    dynorphin        = 0.25;
    galanin          = 0.20;
    estradiol        = 0.30;
    testosterone     = 0.30;
    dhea             = 0.25;
    progesterone     = 0.25;
    allopregnanolone = 0.20;
    taurine          = 0.40;
    glycine          = 0.45;
    d_serine         = 0.30;
    aspartate        = 0.35;
    nitric_oxide     = 0.20;
    carbon_monoxide  = 0.10;
    hydrogen_sulfide = 0.10;
    atp              = 0.80;
    adp              = 0.40;
    tyramine         = 0.10;
    tryptamine       = 0.10;
    aea              = 0.20;
    two_ag           = 0.25;
    bdnf             = 0.50;
    ngf              = 0.40;
    cortisol         = 0.30;
    epinephrine      = 0.20;
    vasopressin      = 0.25;
    oxytocin         = 0.35;
    melatonin        = 0.20;
    histamine        = 0.30;
    no_synthase      = 0.20;
  };

  // Decay all neurochemicals toward their physiological baselines
  func decayChem(c : NECChemState) : NECChemState {
    let d = 0.999;
    let b = baselineChem();
    {
      dopamine         = b.dopamine         + (c.dopamine         - b.dopamine)         * d;
      serotonin        = b.serotonin        + (c.serotonin        - b.serotonin)        * d;
      norepinephrine   = b.norepinephrine   + (c.norepinephrine   - b.norepinephrine)   * d;
      acetylcholine    = b.acetylcholine    + (c.acetylcholine    - b.acetylcholine)    * d;
      gaba             = b.gaba             + (c.gaba             - b.gaba)             * d;
      glutamate        = b.glutamate        + (c.glutamate        - b.glutamate)        * d;
      endorphin        = b.endorphin        + (c.endorphin        - b.endorphin)        * d;
      adenosine        = b.adenosine        + (c.adenosine        - b.adenosine)        * d;
      ldopa            = b.ldopa            + (c.ldopa            - b.ldopa)            * d;
      dopac            = b.dopac            + (c.dopac            - b.dopac)            * d;
      substance_p      = b.substance_p      + (c.substance_p      - b.substance_p)      * d;
      npy              = b.npy              + (c.npy              - b.npy)              * d;
      vip              = b.vip              + (c.vip              - b.vip)              * d;
      crh              = b.crh              + (c.crh              - b.crh)              * d;
      crf              = b.crf              + (c.crf              - b.crf)              * d;
      cck              = b.cck              + (c.cck              - b.cck)              * d;
      enkephalin       = b.enkephalin       + (c.enkephalin       - b.enkephalin)       * d;
      dynorphin        = b.dynorphin        + (c.dynorphin        - b.dynorphin)        * d;
      galanin          = b.galanin          + (c.galanin          - b.galanin)          * d;
      estradiol        = b.estradiol        + (c.estradiol        - b.estradiol)        * d;
      testosterone     = b.testosterone     + (c.testosterone     - b.testosterone)     * d;
      dhea             = b.dhea             + (c.dhea             - b.dhea)             * d;
      progesterone     = b.progesterone     + (c.progesterone     - b.progesterone)     * d;
      allopregnanolone = b.allopregnanolone + (c.allopregnanolone - b.allopregnanolone) * d;
      taurine          = b.taurine          + (c.taurine          - b.taurine)          * d;
      glycine          = b.glycine          + (c.glycine          - b.glycine)          * d;
      d_serine         = b.d_serine         + (c.d_serine         - b.d_serine)         * d;
      aspartate        = b.aspartate        + (c.aspartate        - b.aspartate)        * d;
      nitric_oxide     = b.nitric_oxide     + (c.nitric_oxide     - b.nitric_oxide)     * d;
      carbon_monoxide  = b.carbon_monoxide  + (c.carbon_monoxide  - b.carbon_monoxide)  * d;
      hydrogen_sulfide = b.hydrogen_sulfide + (c.hydrogen_sulfide - b.hydrogen_sulfide) * d;
      atp              = b.atp              + (c.atp              - b.atp)              * d;
      adp              = b.adp              + (c.adp              - b.adp)              * d;
      tyramine         = b.tyramine         + (c.tyramine         - b.tyramine)         * d;
      tryptamine       = b.tryptamine       + (c.tryptamine       - b.tryptamine)       * d;
      aea              = b.aea              + (c.aea              - b.aea)              * d;
      two_ag           = b.two_ag           + (c.two_ag           - b.two_ag)           * d;
      bdnf             = b.bdnf             + (c.bdnf             - b.bdnf)             * d;
      ngf              = b.ngf              + (c.ngf              - b.ngf)              * d;
      cortisol         = b.cortisol         + (c.cortisol         - b.cortisol)         * d;
      epinephrine      = b.epinephrine      + (c.epinephrine      - b.epinephrine)      * d;
      vasopressin      = b.vasopressin      + (c.vasopressin      - b.vasopressin)      * d;
      oxytocin         = b.oxytocin         + (c.oxytocin         - b.oxytocin)         * d;
      melatonin        = b.melatonin        + (c.melatonin        - b.melatonin)        * d;
      histamine        = b.histamine        + (c.histamine        - b.histamine)        * d;
      no_synthase      = b.no_synthase      + (c.no_synthase      - b.no_synthase)      * d;
    }
  };

  // ══════════════════════════════════════════════════════════
  // INIT NEC
  // ══════════════════════════════════════════════════════════

  public func initNEC() : NECState {
    let regions = Array.map<{ id : Nat; name : Text; category : RegionCategory }, RegionState>(
      REGION_DEFS,
      func(def) : RegionState {
        {
          id             = def.id;
          name           = def.name;
          category       = def.category;
          activation     = 0.5;
          deficit        = 0.0;
          hebbian_weight = 0.5;
          lif            = baselineLIF();
          channels       = baselineChannels();
          ap_phase       = #Resting;
          lfp            = 0.0;
          delta_power    = 0.0;
          theta_power    = 0.0;
          alpha_power    = 0.0;
          beta_power     = 0.0;
          gamma_power    = 0.0;
        }
      }
    );

    // 10 white-matter tracts (source/target are indices into regions array)
    let tracts : [FiberTract] = [
      // 0: Corpus Callosum — BA9(8) ↔ BA10(9) bilateral
      { id = 0; name = "Corpus Callosum";
        source_region = 8;  target_region = 9;
        conduction_vel = 70.0; myelination_ratio = 0.95; axonal_density = 0.90;
        synaptic_delay_ms = 100.0 / 70.0; signal_strength = 0.5 },
      // 1: Internal Capsule — BA4(3) → Caudate(46)
      { id = 1; name = "Internal Capsule";
        source_region = 3;  target_region = 46;
        conduction_vel = 60.0; myelination_ratio = 0.90; axonal_density = 0.85;
        synaptic_delay_ms = 100.0 / 60.0; signal_strength = 0.5 },
      // 2: Arcuate Fasciculus — BA44(29) → BA22(16)
      { id = 2; name = "Arcuate Fasciculus";
        source_region = 29; target_region = 16;
        conduction_vel = 50.0; myelination_ratio = 0.85; axonal_density = 0.80;
        synaptic_delay_ms = 100.0 / 50.0; signal_strength = 0.5 },
      // 3: Superior Longitudinal Fasciculus — BA9(8) → BA7(6)
      { id = 3; name = "Superior Longitudinal Fasciculus";
        source_region = 8;  target_region = 6;
        conduction_vel = 45.0; myelination_ratio = 0.80; axonal_density = 0.78;
        synaptic_delay_ms = 100.0 / 45.0; signal_strength = 0.5 },
      // 4: Inferior Longitudinal Fasciculus — BA20(14) → BA17(11)
      { id = 4; name = "Inferior Longitudinal Fasciculus";
        source_region = 14; target_region = 11;
        conduction_vel = 40.0; myelination_ratio = 0.75; axonal_density = 0.72;
        synaptic_delay_ms = 100.0 / 40.0; signal_strength = 0.5 },
      // 5: Uncinate Fasciculus — BA11(10) → Amygdala BL(67)
      { id = 5; name = "Uncinate Fasciculus";
        source_region = 10; target_region = 67;
        conduction_vel = 35.0; myelination_ratio = 0.70; axonal_density = 0.65;
        synaptic_delay_ms = 100.0 / 35.0; signal_strength = 0.5 },
      // 6: Fornix — Hippocampus CA1(70) → Hypothalamus Medial(59)
      { id = 6; name = "Fornix";
        source_region = 70; target_region = 59;
        conduction_vel = 30.0; myelination_ratio = 0.65; axonal_density = 0.60;
        synaptic_delay_ms = 100.0 / 30.0; signal_strength = 0.5 },
      // 7: Cingulum — BA24(18) → BA28(20)
      { id = 7; name = "Cingulum";
        source_region = 18; target_region = 20;
        conduction_vel = 45.0; myelination_ratio = 0.78; axonal_density = 0.74;
        synaptic_delay_ms = 100.0 / 45.0; signal_strength = 0.5 },
      // 8: Optic Radiation — Thalamus LGN(56) → BA17(11)
      { id = 8; name = "Optic Radiation";
        source_region = 56; target_region = 11;
        conduction_vel = 55.0; myelination_ratio = 0.88; axonal_density = 0.84;
        synaptic_delay_ms = 100.0 / 55.0; signal_strength = 0.5 },
      // 9: Corticospinal Tract — BA4(3) → Medullary Reticular(88)
      { id = 9; name = "Corticospinal Tract";
        source_region = 3;  target_region = 88;
        conduction_vel = 70.0; myelination_ratio = 0.92; axonal_density = 0.88;
        synaptic_delay_ms = 100.0 / 70.0; signal_strength = 0.5 },
    ];

    {
      beat             = 0;
      regions          = regions;
      chem             = baselineChem();
      tracts           = tracts;
      global_coherence = 0.5;
      emergence_index  = 0.0;
    }
  };

  // ══════════════════════════════════════════════════════════
  // TICK NEC  (873 ms heartbeat, dt = 0.873 s)
  // ══════════════════════════════════════════════════════════

  public func tickNEC(state : NECState, beat : Nat) : NECState {
    let dt     = 0.873;
    let v_rest = -65.0;
    let chem   = state.chem;
    let beatF  = Float.fromInt(beat);

    // ── Per-region update ─────────────────────────────────
    let newRegions = Array.map<RegionState, RegionState>(
      state.regions,
      func(r) : RegionState {
        let lif = r.lif;

        // Neurochemical modulation of synaptic inputs
        let (modExc, modInh) = switch (r.category) {
          case (#Cortical) {
            // Dopamine boosts excitatory; glutamate drives cortex; serotonin stabilizes inhibition
            let exc = lif.exc_input * (1.0 + 0.20 * chem.dopamine + 0.30 * chem.glutamate);
            let inh = lif.inh_input * (1.0 + 0.40 * chem.gaba) + 0.10 * chem.serotonin;
            (exc, inh)
          };
          case (#Limbic) {
            let exc = lif.exc_input * (1.0 + 0.15 * chem.dopamine + 0.20 * chem.glutamate);
            let inh = lif.inh_input * (1.0 + 0.30 * chem.gaba) + 0.05 * chem.serotonin;
            (exc, inh)
          };
          case (#Brainstem) {
            // Norepinephrine amplifies brainstem (Locus Coeruleus etc.)
            let exc = lif.exc_input * (1.0 + 0.50 * chem.norepinephrine + 0.20 * chem.glutamate);
            let inh = lif.inh_input * (1.0 + 0.20 * chem.gaba);
            (exc, inh)
          };
          case (#Subcortical) {
            let exc = lif.exc_input * (1.0 + 0.10 * chem.dopamine + 0.20 * chem.glutamate);
            let inh = lif.inh_input * (1.0 + 0.35 * chem.gaba);
            (exc, inh)
          };
          case (#Cerebellar) {
            let exc = lif.exc_input * (1.0 + 0.10 * chem.glutamate);
            let inh = lif.inh_input * (1.0 + 0.50 * chem.gaba);
            (exc, inh)
          };
        };

        // ── LIF Euler integration ─────────────────────────
        let (newLif, newPhase) : (LIFState, APPhase) =
          if (lif.refractory_ticks > 0) {
            // Refractory: clamp voltage, decrement counter
            (
              { lif with
                voltage          = v_rest;
                refractory_ticks = lif.refractory_ticks - 1;
                spike_rate       = lif.spike_rate * 0.97;
              },
              #Refractory
            )
          } else {
            let I        = modExc - modInh;
            let dv       = (( -lif.leak_cond * (lif.voltage - v_rest) ) + I) / lif.membrane_cap;
            let nextVolt = lif.voltage + dv * dt;

            if (nextVolt >= lif.spike_threshold) {
              // Action potential fired — spike, then hyperpolarize
              let newRate = clampF(lif.spike_rate + 15.0, 0.0, 200.0);
              (
                { lif with
                  voltage          = -70.0;
                  refractory_ticks = 5;
                  spike_rate       = newRate;
                },
                #Hyperpolarizing
              )
            } else {
              // Sub-threshold: determine AP phase, decay spike_rate
              let phase : APPhase =
                if (nextVolt > v_rest and nextVolt < lif.spike_threshold) { #Rising }
                else if (nextVolt < v_rest)                                { #Hyperpolarizing }
                else                                                        { #Resting };
              let decayedRate = if (lif.spike_rate > 5.0)
                                  lif.spike_rate * 0.98
                                  else lif.spike_rate;
              (
                { lif with voltage = nextVolt; spike_rate = decayedRate },
                phase
              )
            }
          };

        // ── Activation (maps spike_rate → 0–1) ────────────
        let targetAct    = newLif.spike_rate / 200.0;
        // Serotonin stabilises: reduces rate of change toward target
        let stabFactor   = 0.30 - 0.15 * chem.serotonin;
        let newAct       = clampF(r.activation + (targetAct - r.activation) * stabFactor, 0.0, 1.0);

        // ── LFP ───────────────────────────────────────────
        let newLFP = 200.0 * (newAct - 0.5) + 50.0 * Float.sin(beatF * 0.1);

        // ── Frequency-band power (from spike_rate) ────────
        let sr        = newLif.spike_rate;
        let newDelta  = if (sr < 4.0)                        newAct * 0.80 else 0.10;
        let newTheta  = if (sr >= 4.0  and sr < 8.0)         newAct * 0.70 else 0.15;
        let newAlpha  = if (sr >= 8.0  and sr < 12.0)        newAct * 0.90 else 0.20;
        let newBeta   = if (sr >= 12.0 and sr < 30.0)        newAct * 0.85 else 0.15;
        let newGamma  = if (sr >= 30.0)                      newAct * 0.95 else 0.10;

        // ── Hebbian weight update ─────────────────────────
        let rawHebb = r.hebbian_weight
                    + 0.001  * r.activation * newAct
                    - 0.0001 * r.hebbian_weight;
        let newHebb = clampF(rawHebb, 0.0, 1.0);

        {
          r with
          activation     = newAct;
          lif            = newLif;
          ap_phase       = newPhase;
          lfp            = newLFP;
          delta_power    = newDelta;
          theta_power    = newTheta;
          alpha_power    = newAlpha;
          beta_power     = newBeta;
          gamma_power    = newGamma;
          hebbian_weight = newHebb;
        }
      }
    );

    // ── White-matter tract propagation ────────────────────
    let nReg = newRegions.size();
    let newTracts = Array.map<FiberTract, FiberTract>(
      state.tracts,
      func(t) : FiberTract {
        let srcAct = if (t.source_region < nReg)
                       newRegions[t.source_region].activation
                       else 0.5;
        let newStr = t.signal_strength + 0.1 * (srcAct - t.signal_strength);
        { t with signal_strength = newStr }
      }
    );

    // ── Global coherence (mean activation) ────────────────
    let sumAct = Array.foldLeft<RegionState, Float>(
      newRegions, 0.0, func(acc, r) { acc + r.activation }
    );
    let nF       = Float.fromInt(nReg);
    let coherence = if (nF > 0.0) sumAct / nF else 0.0;

    // ── Emergence index ───────────────────────────────────
    let rawEmergence = coherence * (1.0 - chem.adenosine * 0.5) * (0.5 + 0.5 * chem.dopamine);
    let emergence    = clampF(rawEmergence, 0.0, 1.0);

    // ── Neurochemical decay toward baseline ───────────────
    let newChem = decayChem(chem);

    {
      beat             = beat;
      regions          = newRegions;
      chem             = newChem;
      tracts           = newTracts;
      global_coherence = coherence;
      emergence_index  = emergence;
    }
  };

  // ══════════════════════════════════════════════════════════
  // SUMMARIZE NEC
  // ══════════════════════════════════════════════════════════

  public func summarizeNEC(state : NECState) : NECSummary {
    let n  = state.regions.size();
    let nF = Float.fromInt(n);

    let sumSpike = Array.foldLeft<RegionState, Float>(
      state.regions, 0.0, func(acc, r) { acc + r.lif.spike_rate }
    );
    let sumLFP = Array.foldLeft<RegionState, Float>(
      state.regions, 0.0, func(acc, r) { acc + r.lfp }
    );
    let sumDelta = Array.foldLeft<RegionState, Float>(
      state.regions, 0.0, func(acc, r) { acc + r.delta_power }
    );
    let sumTheta = Array.foldLeft<RegionState, Float>(
      state.regions, 0.0, func(acc, r) { acc + r.theta_power }
    );
    let sumAlpha = Array.foldLeft<RegionState, Float>(
      state.regions, 0.0, func(acc, r) { acc + r.alpha_power }
    );
    let sumBeta = Array.foldLeft<RegionState, Float>(
      state.regions, 0.0, func(acc, r) { acc + r.beta_power }
    );
    let sumGamma = Array.foldLeft<RegionState, Float>(
      state.regions, 0.0, func(acc, r) { acc + r.gamma_power }
    );

    // Find top region by activation
    let firstRegion = state.regions[0];
    let (topAct, topName) = Array.foldLeft<RegionState, (Float, Text)>(
      state.regions,
      (firstRegion.activation, firstRegion.name),
      func((bestAct, bestName), r) {
        if (r.activation > bestAct) (r.activation, r.name)
        else (bestAct, bestName)
      }
    );

    let safeN = if (nF > 0.0) nF else 1.0;

    {
      beat             = state.beat;
      global_coherence = state.global_coherence;
      emergence_index  = state.emergence_index;
      region_count     = n;
      tract_count      = state.tracts.size();
      top_region_name  = topName;
      top_region_act   = topAct;
      mean_spike_rate  = sumSpike  / safeN;
      mean_lfp         = sumLFP    / safeN;
      dopamine         = state.chem.dopamine;
      serotonin        = state.chem.serotonin;
      norepinephrine   = state.chem.norepinephrine;
      glutamate        = state.chem.glutamate;
      gaba             = state.chem.gaba;
      mean_delta       = sumDelta  / safeN;
      mean_theta       = sumTheta  / safeN;
      mean_alpha       = sumAlpha  / safeN;
      mean_beta        = sumBeta   / safeN;
      mean_gamma       = sumGamma  / safeN;
    }
  };

} // module NeuralEmergenceCore
