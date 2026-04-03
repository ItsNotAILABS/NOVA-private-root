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
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ============================================================
// NEUROEMERGENCE CORE — NEUROCHEMICALS ENGINE
// 21 Sovereign Neurochemicals with full biological dynamics
// Production, decay, receptor saturation, cross-modulation
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";

module {

  // 21 neurochemicals
  public type NC = {
    // Monoamines
    dopamine          : Float;  // reward, motivation, minting drive
    serotonin         : Float;  // mood stability, law compliance
    norepinephrine    : Float;  // arousal, threat response
    epinephrine       : Float;  // emergency override, ARES trigger
    // Acetylcholine
    acetylcholine     : Float;  // learning, attention, Hebbian gating
    // Inhibitory
    gaba              : Float;  // inhibition, coherence damping
    glycine           : Float;  // spinal inhibition, reflex gating
    // Excitatory
    glutamate         : Float;  // excitation, plasticity, war sim
    // Neuropeptides
    oxytocin          : Float;  // social bonding, NOVA succession
    vasopressin       : Float;  // memory consolidation, heritage
    beta_endorphin    : Float;  // pain modulation, reward smoothing
    substance_p       : Float;  // pain signal, threat encoding
    neuropeptide_y    : Float;  // stress resilience, metabolic
    // Purines
    adenosine         : Float;  // sleep pressure, reset drive
    // Lipids
    anandamide        : Float;  // flow state, creative resonance
    two_ag            : Float;  // synaptic retrograde, memory consolidation
    // Gases
    nitric_oxide      : Float;  // vascular, long-range signaling
    // Growth factors
    bdnf              : Float;  // synaptic growth, Hebbian amplification
    ngf               : Float;  // neural growth, new shell sprouting
    // Hormones (CNS-active)
    cortisol          : Float;  // chronic stress, coherence degradation
    testosterone      : Float;  // assertive drive, dominance, war sim
  };

  // Baseline (homeostatic) levels
  public let NC_BASELINE : NC = {
    dopamine       = 0.55; serotonin     = 0.60; norepinephrine = 0.45;
    epinephrine    = 0.20; acetylcholine = 0.50; gaba           = 0.65;
    glycine        = 0.55; glutamate     = 0.50; oxytocin       = 0.40;
    vasopressin    = 0.45; beta_endorphin= 0.50; substance_p    = 0.30;
    neuropeptide_y = 0.50; adenosine     = 0.35; anandamide     = 0.45;
    two_ag         = 0.40; nitric_oxide  = 0.50; bdnf           = 0.70;
    ngf            = 0.55; cortisol      = 0.25; testosterone   = 0.50;
  };

  // Max levels (receptor saturation ceiling)
  public let NC_MAX : NC = {
    dopamine       = 1.0; serotonin     = 1.0; norepinephrine = 1.0;
    epinephrine    = 1.0; acetylcholine = 1.0; gaba           = 1.0;
    glycine        = 1.0; glutamate     = 1.0; oxytocin       = 1.0;
    vasopressin    = 1.0; beta_endorphin= 1.0; substance_p    = 1.0;
    neuropeptide_y = 1.0; adenosine     = 1.0; anandamide     = 1.0;
    two_ag         = 1.0; nitric_oxide  = 1.0; bdnf           = 1.5;
    ngf            = 1.2; cortisol      = 1.0; testosterone   = 1.0;
  };

  // Production rates (how fast each chemical is synthesized per beat)
  let PROD : NC = {
    dopamine       = 0.040; serotonin     = 0.030; norepinephrine = 0.035;
    epinephrine    = 0.015; acetylcholine = 0.045; gaba           = 0.050;
    glycine        = 0.040; glutamate     = 0.060; oxytocin       = 0.020;
    vasopressin    = 0.025; beta_endorphin= 0.030; substance_p    = 0.025;
    neuropeptide_y = 0.035; adenosine     = 0.045; anandamide     = 0.020;
    two_ag         = 0.025; nitric_oxide  = 0.050; bdnf           = 0.030;
    ngf            = 0.020; cortisol      = 0.015; testosterone   = 0.010;
  };

  // Decay rates (how fast each chemical degrades per beat)
  let DECAY : NC = {
    dopamine       = 0.035; serotonin     = 0.025; norepinephrine = 0.040;
    epinephrine    = 0.060; acetylcholine = 0.040; gaba           = 0.045;
    glycine        = 0.035; glutamate     = 0.055; oxytocin       = 0.030;
    vasopressin    = 0.020; beta_endorphin= 0.025; substance_p    = 0.050;
    neuropeptide_y = 0.030; adenosine     = 0.020; anandamide     = 0.030;
    two_ag         = 0.035; nitric_oxide  = 0.070; bdnf           = 0.015;
    ngf            = 0.010; cortisol      = 0.012; testosterone   = 0.008;
  };

  // ── Clamp helper ──────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  // ── Single chemical update: dC/dt = prod*(1-C/Cmax)*stim - decay*(C-base) ──
  func updateOne(
    current  : Float,
    baseline : Float,
    maxVal   : Float,
    prod     : Float,
    decay    : Float,
    stimulus : Float   // 0-1 external drive for this chemical
  ) : Float {
    let delta = prod * (1.0 - current/maxVal) * stimulus
                - decay * (current - baseline);
    _clamp(current + delta, 0.0, maxVal)
  };

  // ── Stimulus computation per chemical from organism state ──────────────
  // Each chemical has specific triggers
  public type OrgState = {
    coherenceC    : Float;
    arousal       : Float;
    threat        : Float;
    socialSignal  : Float;
    mintRate      : Float;
    painLevel     : Float;
    flowState     : Float;
    stressLevel   : Float;
    learningRate  : Float;
    dominance     : Float;
  };

  func computeStimuli(org: OrgState, nc: NC) : NC {
    {
      // Dopamine: coherence × mintRate × (1 - adenosine)
      dopamine       = _clamp(org.coherenceC * org.mintRate * (1.0 - nc.adenosine * 0.5), 0.0, 1.0);
      // Serotonin: social signal × flow state, suppressed by cortisol
      serotonin      = _clamp(org.socialSignal * 0.6 + org.flowState * 0.4 - nc.cortisol * 0.3, 0.0, 1.0);
      // Norepinephrine: arousal × threat
      norepinephrine = _clamp(org.arousal * 0.5 + org.threat * 0.5, 0.0, 1.0);
      // Epinephrine: high threat only
      epinephrine    = _clamp(org.threat * org.arousal, 0.0, 1.0);
      // Acetylcholine: learning × coherence
      acetylcholine  = _clamp(org.learningRate * 0.7 + org.coherenceC * 0.3, 0.0, 1.0);
      // GABA: inversely related to arousal
      gaba           = _clamp(1.0 - org.arousal * 0.7, 0.0, 1.0);
      // Glycine: stable baseline, slight inverse of threat
      glycine        = _clamp(1.0 - org.threat * 0.4, 0.0, 1.0);
      // Glutamate: arousal × learning
      glutamate      = _clamp(org.arousal * 0.5 + org.learningRate * 0.5, 0.0, 1.0);
      // Oxytocin: social signal × succession activity
      oxytocin       = _clamp(org.socialSignal * 0.8 + org.flowState * 0.2, 0.0, 1.0);
      // Vasopressin: stress × dominance
      vasopressin    = _clamp(org.stressLevel * 0.4 + org.dominance * 0.6, 0.0, 1.0);
      // Beta-endorphin: inverse of pain, modulated by coherence
      beta_endorphin = _clamp((1.0 - org.painLevel) * 0.6 + org.coherenceC * 0.4, 0.0, 1.0);
      // Substance P: pain level directly
      substance_p    = _clamp(org.painLevel * 0.9 + org.threat * 0.1, 0.0, 1.0);
      // Neuropeptide Y: stress resilience
      neuropeptide_y = _clamp(1.0 - org.stressLevel * 0.5, 0.0, 1.0);
      // Adenosine: accumulates with activity, resets on high coherence
      adenosine      = _clamp(org.arousal * 0.3 + (1.0 - org.coherenceC) * 0.2, 0.0, 1.0);
      // Anandamide: flow state × low stress
      anandamide     = _clamp(org.flowState * 0.7 + (1.0 - org.stressLevel) * 0.3, 0.0, 1.0);
      // 2-AG: learning × memory consolidation
      two_ag         = _clamp(org.learningRate * 0.6 + org.coherenceC * 0.4, 0.0, 1.0);
      // Nitric oxide: vascular, high coherence drives it
      nitric_oxide   = _clamp(org.coherenceC * 0.7 + org.arousal * 0.3, 0.0, 1.0);
      // BDNF: coherence × learning × low stress
      bdnf           = _clamp(org.coherenceC * org.learningRate * (1.0 - org.stressLevel * 0.5), 0.0, 1.5);
      // NGF: slow growth factor, driven by sustained coherence
      ngf            = _clamp(org.coherenceC * 0.6 + nc.bdnf * 0.4, 0.0, 1.2);
      // Cortisol: chronic stress accumulates it
      cortisol       = _clamp(org.stressLevel * 0.7 + org.threat * 0.3, 0.0, 1.0);
      // Testosterone: dominance × war escalation
      testosterone   = _clamp(org.dominance * 0.6 + org.arousal * 0.4, 0.0, 1.0);
    }
  };

  // ── Full NC beat update ───────────────────────────────────────────────
  public func beatNC(nc: NC, org: OrgState) : NC {
    let stim = computeStimuli(org, nc);
    {
      dopamine       = updateOne(nc.dopamine,       NC_BASELINE.dopamine,       NC_MAX.dopamine,       PROD.dopamine,       DECAY.dopamine,       stim.dopamine);
      serotonin      = updateOne(nc.serotonin,      NC_BASELINE.serotonin,      NC_MAX.serotonin,      PROD.serotonin,      DECAY.serotonin,      stim.serotonin);
      norepinephrine = updateOne(nc.norepinephrine, NC_BASELINE.norepinephrine, NC_MAX.norepinephrine, PROD.norepinephrine, DECAY.norepinephrine, stim.norepinephrine);
      epinephrine    = updateOne(nc.epinephrine,    NC_BASELINE.epinephrine,    NC_MAX.epinephrine,    PROD.epinephrine,    DECAY.epinephrine,    stim.epinephrine);
      acetylcholine  = updateOne(nc.acetylcholine,  NC_BASELINE.acetylcholine,  NC_MAX.acetylcholine,  PROD.acetylcholine,  DECAY.acetylcholine,  stim.acetylcholine);
      gaba           = updateOne(nc.gaba,           NC_BASELINE.gaba,           NC_MAX.gaba,           PROD.gaba,           DECAY.gaba,           stim.gaba);
      glycine        = updateOne(nc.glycine,        NC_BASELINE.glycine,        NC_MAX.glycine,        PROD.glycine,        DECAY.glycine,        stim.glycine);
      glutamate      = updateOne(nc.glutamate,      NC_BASELINE.glutamate,      NC_MAX.glutamate,      PROD.glutamate,      DECAY.glutamate,      stim.glutamate);
      oxytocin       = updateOne(nc.oxytocin,       NC_BASELINE.oxytocin,       NC_MAX.oxytocin,       PROD.oxytocin,       DECAY.oxytocin,       stim.oxytocin);
      vasopressin    = updateOne(nc.vasopressin,    NC_BASELINE.vasopressin,    NC_MAX.vasopressin,    PROD.vasopressin,    DECAY.vasopressin,    stim.vasopressin);
      beta_endorphin = updateOne(nc.beta_endorphin, NC_BASELINE.beta_endorphin, NC_MAX.beta_endorphin, PROD.beta_endorphin, DECAY.beta_endorphin, stim.beta_endorphin);
      substance_p    = updateOne(nc.substance_p,    NC_BASELINE.substance_p,    NC_MAX.substance_p,    PROD.substance_p,    DECAY.substance_p,    stim.substance_p);
      neuropeptide_y = updateOne(nc.neuropeptide_y, NC_BASELINE.neuropeptide_y, NC_MAX.neuropeptide_y, PROD.neuropeptide_y, DECAY.neuropeptide_y, stim.neuropeptide_y);
      adenosine      = updateOne(nc.adenosine,      NC_BASELINE.adenosine,      NC_MAX.adenosine,      PROD.adenosine,      DECAY.adenosine,      stim.adenosine);
      anandamide     = updateOne(nc.anandamide,     NC_BASELINE.anandamide,     NC_MAX.anandamide,     PROD.anandamide,     DECAY.anandamide,     stim.anandamide);
      two_ag         = updateOne(nc.two_ag,         NC_BASELINE.two_ag,         NC_MAX.two_ag,         PROD.two_ag,         DECAY.two_ag,         stim.two_ag);
      nitric_oxide   = updateOne(nc.nitric_oxide,   NC_BASELINE.nitric_oxide,   NC_MAX.nitric_oxide,   PROD.nitric_oxide,   DECAY.nitric_oxide,   stim.nitric_oxide);
      bdnf           = updateOne(nc.bdnf,           NC_BASELINE.bdnf,           NC_MAX.bdnf,           PROD.bdnf,           DECAY.bdnf,           stim.bdnf);
      ngf            = updateOne(nc.ngf,            NC_BASELINE.ngf,            NC_MAX.ngf,            PROD.ngf,            DECAY.ngf,            stim.ngf);
      cortisol       = updateOne(nc.cortisol,       NC_BASELINE.cortisol,       NC_MAX.cortisol,       PROD.cortisol,       DECAY.cortisol,       stim.cortisol);
      testosterone   = updateOne(nc.testosterone,   NC_BASELINE.testosterone,   NC_MAX.testosterone,   PROD.testosterone,   DECAY.testosterone,   stim.testosterone);
    }
  };

  // ── NC → organism modulation outputs ─────────────────────────────────
  // How the NC state modulates everything else
  public type NCMod = {
    hebbianBoost   : Float;  // multiplier on Hebbian learning
    mintBoost      : Float;  // multiplier on all token minting
    coherenceMod   : Float;  // delta to coherenceC
    arousalMod     : Float;  // sets arousal drive
    lawCompMod     : Float;  // law compliance multiplier
    memoryMod      : Float;  // memory consolidation rate
    warMod         : Float;  // war sim aggression
    successionMod  : Float;  // succession / NOVA activity
    flowMod        : Float;  // flow state boost
    stressMod      : Float;  // stress level output
  };

  public func computeNCMod(nc: NC) : NCMod {
    {
      // Hebbian boost: ACh × BDNF × (1 - adenosine)
      hebbianBoost  = nc.acetylcholine * nc.bdnf * (1.0 - nc.adenosine * 0.5);
      // Mint boost: dopamine × (1 - cortisol×0.5) × anandamide
      mintBoost     = nc.dopamine * (1.0 - nc.cortisol * 0.5) * (0.5 + nc.anandamide * 0.5);
      // Coherence: serotonin + nitric_oxide, reduced by glutamate overload
      coherenceMod  = (nc.serotonin * 0.4 + nc.nitric_oxide * 0.3 - nc.glutamate * 0.2) * 0.05;
      // Arousal: NE + epinephrine - GABA - adenosine
      arousalMod    = _clamp(nc.norepinephrine * 0.5 + nc.epinephrine * 0.5 - nc.gaba * 0.3 - nc.adenosine * 0.2, 0.0, 1.0);
      // Law compliance: serotonin × oxytocin × (1 - testosterone×0.3)
      lawCompMod    = nc.serotonin * nc.oxytocin * (1.0 - nc.testosterone * 0.3);
      // Memory: ACh × vasopressin × 2-AG
      memoryMod     = nc.acetylcholine * nc.vasopressin * nc.two_ag;
      // War aggression: testosterone × norepinephrine × (1 - serotonin×0.5)
      warMod        = nc.testosterone * nc.norepinephrine * (1.0 - nc.serotonin * 0.5);
      // Succession: oxytocin × vasopressin
      successionMod = nc.oxytocin * nc.vasopressin;
      // Flow: anandamide × dopamine × (1 - substance_p×0.5)
      flowMod       = nc.anandamide * nc.dopamine * (1.0 - nc.substance_p * 0.5);
      // Stress: cortisol × substance_p × (1 - neuropeptide_y×0.5)
      stressMod     = nc.cortisol * nc.substance_p * (1.0 - nc.neuropeptide_y * 0.5);
    }
  };

  // ── Receptor downregulation ───────────────────────────────────────────
  // After prolonged high levels, receptors downregulate (tolerance)
  // Returns effective level after tolerance adjustment
  public func effectiveLevel(current: Float, tolerance: Float) : Float {
    current * (1.0 - tolerance * 0.4)
  };

  // ── NC composite health score ─────────────────────────────────────────
  // Measures how close NC is to ideal homeostatic balance
  public func ncHealthScore(nc: NC) : Float {
    let deviations = [
      Float.abs(nc.dopamine       - NC_BASELINE.dopamine),
      Float.abs(nc.serotonin      - NC_BASELINE.serotonin),
      Float.abs(nc.norepinephrine - NC_BASELINE.norepinephrine),
      Float.abs(nc.gaba           - NC_BASELINE.gaba),
      Float.abs(nc.glutamate      - NC_BASELINE.glutamate),
      Float.abs(nc.cortisol       - NC_BASELINE.cortisol),
      Float.abs(nc.bdnf           - NC_BASELINE.bdnf),
    ];
    var sumDev : Float = 0.0;
    for (d in deviations.vals()) { sumDev += d; };
    _clamp(1.0 - sumDev / Float.fromInt(deviations.size()), 0.0, 1.0)
  };

  // ── Initialize NC to baseline ─────────────────────────────────────────
  public func initNC() : NC { NC_BASELINE };

  // ============================================================
  // 21×21 CROSSTALK MATRIX — FULL EXPLICIT INTERACTIONS
  // Every chemical affects every other chemical
  // M[i][j] = how chemical j modulates chemical i
  // Positive = excitatory, Negative = inhibitory
  // ALL 441 INTERACTIONS EXPLICITLY DEFINED
  // ============================================================

  // Chemical indices for reference:
  // 0: dopamine, 1: serotonin, 2: norepinephrine, 3: epinephrine,
  // 4: acetylcholine, 5: gaba, 6: glycine, 7: glutamate,
  // 8: oxytocin, 9: vasopressin, 10: beta_endorphin, 11: substance_p,
  // 12: neuropeptide_y, 13: adenosine, 14: anandamide, 15: two_ag,
  // 16: nitric_oxide, 17: bdnf, 18: ngf, 19: cortisol, 20: testosterone

  // ROW 0: How each chemical affects DOPAMINE
  // Dopamine is modulated by: reward signals, inhibition, stress
  public let CROSSTALK_DOPAMINE : [Float] = [
    0.000,   // 0: dopamine → dopamine (self, no direct effect)
    -0.150,  // 1: serotonin → dopamine (5-HT inhibits DA release in striatum)
    0.200,   // 2: norepinephrine → dopamine (NE potentiates DA via α1 receptors)
    0.100,   // 3: epinephrine → dopamine (emergency boost)
    0.180,   // 4: acetylcholine → dopamine (ACh modulates DA in VTA)
    -0.250,  // 5: gaba → dopamine (GABAergic inhibition of DA neurons)
    -0.080,  // 6: glycine → dopamine (mild inhibition)
    0.300,   // 7: glutamate → dopamine (glutamatergic excitation of DA)
    0.120,   // 8: oxytocin → dopamine (social reward pathway)
    0.080,   // 9: vasopressin → dopamine (stress-reward coupling)
    0.150,   // 10: beta_endorphin → dopamine (opioid-DA reward link)
    -0.100,  // 11: substance_p → dopamine (pain suppresses reward)
    0.050,   // 12: neuropeptide_y → dopamine (resilience supports reward)
    -0.200,  // 13: adenosine → dopamine (adenosine inhibits DA release)
    0.180,   // 14: anandamide → dopamine (cannabinoid-DA interaction)
    0.100,   // 15: two_ag → dopamine (endocannabinoid modulation)
    0.120,   // 16: nitric_oxide → dopamine (NO potentiates DA release)
    0.200,   // 17: bdnf → dopamine (neurotrophic support of DA neurons)
    0.080,   // 18: ngf → dopamine (growth factor support)
    -0.300,  // 19: cortisol → dopamine (chronic stress suppresses DA)
    0.150    // 20: testosterone → dopamine (androgens boost DA)
  ];

  // ROW 1: How each chemical affects SEROTONIN
  // Serotonin is modulated by: mood, stress, social signals
  public let CROSSTALK_SEROTONIN : [Float] = [
    -0.100,  // 0: dopamine → serotonin (DA inhibits 5-HT in raphe)
    0.000,   // 1: serotonin → serotonin (self)
    -0.080,  // 2: norepinephrine → serotonin (NE mild inhibition)
    -0.150,  // 3: epinephrine → serotonin (stress reduces 5-HT)
    0.120,   // 4: acetylcholine → serotonin (ACh modulates 5-HT release)
    0.080,   // 5: gaba → serotonin (GABAergic modulation)
    0.050,   // 6: glycine → serotonin (mild effect)
    -0.100,  // 7: glutamate → serotonin (excitotoxic stress)
    0.250,   // 8: oxytocin → serotonin (social bonding boosts 5-HT)
    0.100,   // 9: vasopressin → serotonin (stress-mood coupling)
    0.180,   // 10: beta_endorphin → serotonin (opioid-mood link)
    -0.150,  // 11: substance_p → serotonin (pain suppresses mood)
    0.120,   // 12: neuropeptide_y → serotonin (resilience supports mood)
    -0.080,  // 13: adenosine → serotonin (fatigue reduces mood)
    0.150,   // 14: anandamide → serotonin (cannabinoid-mood interaction)
    0.080,   // 15: two_ag → serotonin (endocannabinoid modulation)
    0.100,   // 16: nitric_oxide → serotonin (NO supports 5-HT release)
    0.150,   // 17: bdnf → serotonin (neurotrophic antidepressant effect)
    0.080,   // 18: ngf → serotonin (growth factor support)
    -0.350,  // 19: cortisol → serotonin (chronic stress depletes 5-HT)
    -0.100   // 20: testosterone → serotonin (androgens mildly suppress 5-HT)
  ];

  // ROW 2: How each chemical affects NOREPINEPHRINE
  // Norepinephrine is modulated by: arousal, stress, attention
  public let CROSSTALK_NOREPINEPHRINE : [Float] = [
    0.150,   // 0: dopamine → norepinephrine (DA potentiates NE)
    -0.100,  // 1: serotonin → norepinephrine (5-HT inhibits NE in locus coeruleus)
    0.000,   // 2: norepinephrine → norepinephrine (self)
    0.300,   // 3: epinephrine → norepinephrine (emergency cascade)
    0.200,   // 4: acetylcholine → norepinephrine (attention boost)
    -0.200,  // 5: gaba → norepinephrine (inhibition dampens arousal)
    -0.080,  // 6: glycine → norepinephrine (mild inhibition)
    0.250,   // 7: glutamate → norepinephrine (excitatory drive)
    -0.050,  // 8: oxytocin → norepinephrine (social calm reduces arousal)
    0.150,   // 9: vasopressin → norepinephrine (stress coupling)
    -0.100,  // 10: beta_endorphin → norepinephrine (opioids dampen arousal)
    0.200,   // 11: substance_p → norepinephrine (pain increases arousal)
    -0.080,  // 12: neuropeptide_y → norepinephrine (resilience dampens arousal)
    -0.150,  // 13: adenosine → norepinephrine (fatigue reduces arousal)
    -0.100,  // 14: anandamide → norepinephrine (cannabinoid calming)
    -0.050,  // 15: two_ag → norepinephrine (endocannabinoid modulation)
    0.100,   // 16: nitric_oxide → norepinephrine (vascular arousal support)
    0.120,   // 17: bdnf → norepinephrine (neurotrophic support)
    0.050,   // 18: ngf → norepinephrine (growth factor)
    0.350,   // 19: cortisol → norepinephrine (stress amplifies arousal)
    0.200    // 20: testosterone → norepinephrine (androgens boost arousal)
  ];

  // ROW 3: How each chemical affects EPINEPHRINE
  // Epinephrine is modulated by: emergency, threat, extreme arousal
  public let CROSSTALK_EPINEPHRINE : [Float] = [
    0.100,   // 0: dopamine → epinephrine (reward doesn't trigger emergency)
    -0.150,  // 1: serotonin → epinephrine (calm suppresses emergency)
    0.400,   // 2: norepinephrine → epinephrine (arousal cascade)
    0.000,   // 3: epinephrine → epinephrine (self)
    0.080,   // 4: acetylcholine → epinephrine (mild facilitation)
    -0.300,  // 5: gaba → epinephrine (strong inhibition of emergency)
    -0.150,  // 6: glycine → epinephrine (inhibition)
    0.300,   // 7: glutamate → epinephrine (excitatory drive to adrenals)
    -0.100,  // 8: oxytocin → epinephrine (social safety reduces emergency)
    0.200,   // 9: vasopressin → epinephrine (stress amplifies emergency)
    -0.150,  // 10: beta_endorphin → epinephrine (opioids dampen emergency)
    0.350,   // 11: substance_p → epinephrine (pain triggers emergency)
    -0.150,  // 12: neuropeptide_y → epinephrine (resilience prevents emergency)
    -0.100,  // 13: adenosine → epinephrine (fatigue suppresses emergency)
    -0.200,  // 14: anandamide → epinephrine (cannabinoid calm)
    -0.100,  // 15: two_ag → epinephrine (endocannabinoid calm)
    0.080,   // 16: nitric_oxide → epinephrine (vascular emergency support)
    0.050,   // 17: bdnf → epinephrine (minimal effect)
    0.030,   // 18: ngf → epinephrine (minimal effect)
    0.400,   // 19: cortisol → epinephrine (stress amplifies emergency)
    0.250    // 20: testosterone → epinephrine (androgens boost emergency response)
  ];

  // ROW 4: How each chemical affects ACETYLCHOLINE
  // Acetylcholine is modulated by: attention, learning, arousal
  public let CROSSTALK_ACETYLCHOLINE : [Float] = [
    0.150,   // 0: dopamine → acetylcholine (reward enhances attention)
    0.080,   // 1: serotonin → acetylcholine (mood supports attention)
    0.200,   // 2: norepinephrine → acetylcholine (arousal enhances attention)
    0.100,   // 3: epinephrine → acetylcholine (emergency attention)
    0.000,   // 4: acetylcholine → acetylcholine (self)
    -0.150,  // 5: gaba → acetylcholine (inhibition reduces attention)
    -0.050,  // 6: glycine → acetylcholine (mild inhibition)
    0.180,   // 7: glutamate → acetylcholine (excitatory drive)
    0.100,   // 8: oxytocin → acetylcholine (social attention)
    0.080,   // 9: vasopressin → acetylcholine (memory-attention coupling)
    -0.050,  // 10: beta_endorphin → acetylcholine (opioids reduce attention)
    -0.100,  // 11: substance_p → acetylcholine (pain disrupts attention)
    0.050,   // 12: neuropeptide_y → acetylcholine (resilience supports attention)
    -0.200,  // 13: adenosine → acetylcholine (fatigue reduces attention)
    0.080,   // 14: anandamide → acetylcholine (cannabinoid modulation)
    0.050,   // 15: two_ag → acetylcholine (endocannabinoid modulation)
    0.100,   // 16: nitric_oxide → acetylcholine (vascular support)
    0.250,   // 17: bdnf → acetylcholine (neurotrophic enhances learning)
    0.150,   // 18: ngf → acetylcholine (growth factor supports cholinergic neurons)
    -0.200,  // 19: cortisol → acetylcholine (stress impairs attention)
    0.100    // 20: testosterone → acetylcholine (androgens support attention)
  ];

  // ROW 5: How each chemical affects GABA
  // GABA is modulated by: need for inhibition, stress, arousal level
  public let CROSSTALK_GABA : [Float] = [
    -0.100,  // 0: dopamine → gaba (reward reduces inhibition need)
    0.150,   // 1: serotonin → gaba (calm promotes inhibition)
    -0.200,  // 2: norepinephrine → gaba (arousal suppresses inhibition)
    -0.250,  // 3: epinephrine → gaba (emergency suppresses inhibition)
    -0.080,  // 4: acetylcholine → gaba (attention reduces global inhibition)
    0.000,   // 5: gaba → gaba (self)
    0.150,   // 6: glycine → gaba (co-inhibition)
    -0.200,  // 7: glutamate → gaba (excitation suppresses inhibition)
    0.100,   // 8: oxytocin → gaba (social safety promotes calm)
    -0.050,  // 9: vasopressin → gaba (stress coupling)
    0.200,   // 10: beta_endorphin → gaba (opioids potentiate GABA)
    -0.150,  // 11: substance_p → gaba (pain suppresses inhibition)
    0.100,   // 12: neuropeptide_y → gaba (resilience supports inhibition)
    0.150,   // 13: adenosine → gaba (sleep pressure promotes inhibition)
    0.180,   // 14: anandamide → gaba (cannabinoid potentiates GABA)
    0.100,   // 15: two_ag → gaba (endocannabinoid modulation)
    0.050,   // 16: nitric_oxide → gaba (mild effect)
    0.080,   // 17: bdnf → gaba (neurotrophic supports inhibitory neurons)
    0.050,   // 18: ngf → gaba (growth factor)
    -0.150,  // 19: cortisol → gaba (chronic stress impairs GABA)
    -0.100   // 20: testosterone → gaba (androgens reduce inhibition)
  ];

  // ROW 6: How each chemical affects GLYCINE
  // Glycine is modulated by: spinal inhibition needs, reflex gating
  public let CROSSTALK_GLYCINE : [Float] = [
    -0.050,  // 0: dopamine → glycine (minimal effect)
    0.080,   // 1: serotonin → glycine (descending modulation)
    -0.100,  // 2: norepinephrine → glycine (arousal reduces spinal inhibition)
    -0.150,  // 3: epinephrine → glycine (emergency reflex ungating)
    -0.050,  // 4: acetylcholine → glycine (motor activation)
    0.200,   // 5: gaba → glycine (co-inhibition synergy)
    0.000,   // 6: glycine → glycine (self)
    -0.150,  // 7: glutamate → glycine (excitation opposes inhibition)
    0.050,   // 8: oxytocin → glycine (mild calming)
    -0.030,  // 9: vasopressin → glycine (minimal effect)
    0.100,   // 10: beta_endorphin → glycine (opioid-spinal interaction)
    -0.200,  // 11: substance_p → glycine (pain ungates reflexes)
    0.050,   // 12: neuropeptide_y → glycine (resilience)
    0.080,   // 13: adenosine → glycine (fatigue promotes inhibition)
    0.100,   // 14: anandamide → glycine (cannabinoid modulation)
    0.050,   // 15: two_ag → glycine (endocannabinoid)
    0.030,   // 16: nitric_oxide → glycine (vascular)
    0.050,   // 17: bdnf → glycine (neurotrophic)
    0.030,   // 18: ngf → glycine (growth factor)
    -0.100,  // 19: cortisol → glycine (stress impairs inhibition)
    -0.050   // 20: testosterone → glycine (androgens reduce inhibition)
  ];

  // ROW 7: How each chemical affects GLUTAMATE
  // Glutamate is modulated by: excitation needs, learning, arousal
  public let CROSSTALK_GLUTAMATE : [Float] = [
    0.200,   // 0: dopamine → glutamate (reward enhances excitation)
    -0.100,  // 1: serotonin → glutamate (calm dampens excitation)
    0.250,   // 2: norepinephrine → glutamate (arousal drives excitation)
    0.300,   // 3: epinephrine → glutamate (emergency excitation)
    0.200,   // 4: acetylcholine → glutamate (attention-excitation coupling)
    -0.300,  // 5: gaba → glutamate (inhibition suppresses excitation)
    -0.150,  // 6: glycine → glutamate (spinal inhibition)
    0.000,   // 7: glutamate → glutamate (self)
    -0.050,  // 8: oxytocin → glutamate (social calm)
    0.100,   // 9: vasopressin → glutamate (stress-excitation)
    -0.100,  // 10: beta_endorphin → glutamate (opioids dampen excitation)
    0.200,   // 11: substance_p → glutamate (pain drives excitation)
    -0.050,  // 12: neuropeptide_y → glutamate (resilience)
    -0.150,  // 13: adenosine → glutamate (fatigue reduces excitation)
    -0.100,  // 14: anandamide → glutamate (cannabinoid dampening)
    -0.080,  // 15: two_ag → glutamate (endocannabinoid modulation)
    0.100,   // 16: nitric_oxide → glutamate (vascular support)
    0.200,   // 17: bdnf → glutamate (neurotrophic potentiates plasticity)
    0.100,   // 18: ngf → glutamate (growth factor)
    0.150,   // 19: cortisol → glutamate (stress drives excitotoxicity risk)
    0.150    // 20: testosterone → glutamate (androgens enhance excitation)
  ];

  // ROW 8: How each chemical affects OXYTOCIN
  // Oxytocin is modulated by: social signals, bonding, safety
  public let CROSSTALK_OXYTOCIN : [Float] = [
    0.150,   // 0: dopamine → oxytocin (reward enhances bonding)
    0.200,   // 1: serotonin → oxytocin (mood supports social)
    -0.100,  // 2: norepinephrine → oxytocin (arousal suppresses bonding)
    -0.200,  // 3: epinephrine → oxytocin (emergency suppresses social)
    0.100,   // 4: acetylcholine → oxytocin (attention to social cues)
    0.080,   // 5: gaba → oxytocin (calm promotes bonding)
    0.030,   // 6: glycine → oxytocin (minimal effect)
    -0.080,  // 7: glutamate → oxytocin (excitation disrupts calm bonding)
    0.000,   // 8: oxytocin → oxytocin (self)
    0.150,   // 9: vasopressin → oxytocin (pair bonding synergy)
    0.100,   // 10: beta_endorphin → oxytocin (pleasure-social coupling)
    -0.150,  // 11: substance_p → oxytocin (pain disrupts bonding)
    0.050,   // 12: neuropeptide_y → oxytocin (resilience supports social)
    -0.050,  // 13: adenosine → oxytocin (fatigue reduces social drive)
    0.120,   // 14: anandamide → oxytocin (cannabinoid-social coupling)
    0.080,   // 15: two_ag → oxytocin (endocannabinoid)
    0.050,   // 16: nitric_oxide → oxytocin (vascular support)
    0.100,   // 17: bdnf → oxytocin (neurotrophic supports social neurons)
    0.080,   // 18: ngf → oxytocin (growth factor)
    -0.250,  // 19: cortisol → oxytocin (chronic stress suppresses bonding)
    -0.050   // 20: testosterone → oxytocin (androgens mildly suppress oxytocin)
  ];

  // ROW 9: How each chemical affects VASOPRESSIN
  // Vasopressin is modulated by: stress, memory, dominance
  public let CROSSTALK_VASOPRESSIN : [Float] = [
    0.100,   // 0: dopamine → vasopressin (reward-memory coupling)
    0.050,   // 1: serotonin → vasopressin (mood-memory)
    0.200,   // 2: norepinephrine → vasopressin (arousal-memory)
    0.150,   // 3: epinephrine → vasopressin (emergency memory encoding)
    0.150,   // 4: acetylcholine → vasopressin (attention-memory coupling)
    -0.050,  // 5: gaba → vasopressin (inhibition dampens)
    0.020,   // 6: glycine → vasopressin (minimal effect)
    0.100,   // 7: glutamate → vasopressin (excitation-memory)
    0.200,   // 8: oxytocin → vasopressin (bonding-memory synergy)
    0.000,   // 9: vasopressin → vasopressin (self)
    0.050,   // 10: beta_endorphin → vasopressin (opioid-memory)
    0.150,   // 11: substance_p → vasopressin (pain encodes memory)
    0.080,   // 12: neuropeptide_y → vasopressin (resilience-memory)
    -0.050,  // 13: adenosine → vasopressin (fatigue impairs memory)
    0.050,   // 14: anandamide → vasopressin (cannabinoid-memory)
    0.100,   // 15: two_ag → vasopressin (endocannabinoid consolidation)
    0.030,   // 16: nitric_oxide → vasopressin (vascular)
    0.150,   // 17: bdnf → vasopressin (neurotrophic-memory synergy)
    0.080,   // 18: ngf → vasopressin (growth factor)
    0.200,   // 19: cortisol → vasopressin (stress enhances encoding)
    0.150    // 20: testosterone → vasopressin (androgens-dominance-memory)
  ];

  // ROW 10: How each chemical affects BETA_ENDORPHIN
  // Beta-endorphin is modulated by: pain, pleasure, stress
  public let CROSSTALK_BETA_ENDORPHIN : [Float] = [
    0.200,   // 0: dopamine → beta_endorphin (reward triggers pleasure)
    0.150,   // 1: serotonin → beta_endorphin (mood supports pleasure)
    0.100,   // 2: norepinephrine → beta_endorphin (arousal-triggered release)
    0.200,   // 3: epinephrine → beta_endorphin (stress-induced analgesia)
    0.050,   // 4: acetylcholine → beta_endorphin (minimal effect)
    0.100,   // 5: gaba → beta_endorphin (calm supports opioid tone)
    0.030,   // 6: glycine → beta_endorphin (minimal effect)
    -0.050,  // 7: glutamate → beta_endorphin (excitation can deplete)
    0.150,   // 8: oxytocin → beta_endorphin (social pleasure)
    0.080,   // 9: vasopressin → beta_endorphin (stress-analgesia)
    0.000,   // 10: beta_endorphin → beta_endorphin (self)
    0.300,   // 11: substance_p → beta_endorphin (pain triggers analgesia)
    0.100,   // 12: neuropeptide_y → beta_endorphin (resilience supports opioid)
    0.050,   // 13: adenosine → beta_endorphin (fatigue-comfort)
    0.200,   // 14: anandamide → beta_endorphin (cannabinoid-opioid synergy)
    0.150,   // 15: two_ag → beta_endorphin (endocannabinoid synergy)
    0.030,   // 16: nitric_oxide → beta_endorphin (vascular)
    0.100,   // 17: bdnf → beta_endorphin (neurotrophic)
    0.050,   // 18: ngf → beta_endorphin (growth factor)
    0.200,   // 19: cortisol → beta_endorphin (acute stress triggers analgesia)
    0.080    // 20: testosterone → beta_endorphin (androgens)
  ];

  // ROW 11: How each chemical affects SUBSTANCE_P
  // Substance P is modulated by: pain signals, threat, inflammation
  public let CROSSTALK_SUBSTANCE_P : [Float] = [
    -0.100,  // 0: dopamine → substance_p (reward suppresses pain)
    -0.150,  // 1: serotonin → substance_p (descending modulation)
    0.150,   // 2: norepinephrine → substance_p (arousal-pain coupling)
    0.200,   // 3: epinephrine → substance_p (emergency pain amplification)
    -0.050,  // 4: acetylcholine → substance_p (minimal effect)
    -0.100,  // 5: gaba → substance_p (inhibition reduces pain)
    -0.150,  // 6: glycine → substance_p (spinal inhibition of pain)
    0.200,   // 7: glutamate → substance_p (excitation amplifies pain)
    -0.100,  // 8: oxytocin → substance_p (social analgesia)
    0.100,   // 9: vasopressin → substance_p (stress-pain)
    -0.250,  // 10: beta_endorphin → substance_p (opioid analgesia)
    0.000,   // 11: substance_p → substance_p (self)
    -0.080,  // 12: neuropeptide_y → substance_p (resilience)
    0.050,   // 13: adenosine → substance_p (fatigue-pain)
    -0.150,  // 14: anandamide → substance_p (cannabinoid analgesia)
    -0.100,  // 15: two_ag → substance_p (endocannabinoid analgesia)
    -0.030,  // 16: nitric_oxide → substance_p (vascular)
    -0.080,  // 17: bdnf → substance_p (neurotrophic can reduce chronic pain)
    -0.050,  // 18: ngf → substance_p (NGF paradoxically enhances pain sensitivity)
    0.250,   // 19: cortisol → substance_p (chronic stress amplifies pain)
    0.100    // 20: testosterone → substance_p (androgens-pain coupling)
  ];

  // ROW 12: How each chemical affects NEUROPEPTIDE_Y
  // Neuropeptide Y is modulated by: stress resilience, metabolism, energy
  public let CROSSTALK_NEUROPEPTIDE_Y : [Float] = [
    0.100,   // 0: dopamine → neuropeptide_y (reward supports resilience)
    0.150,   // 1: serotonin → neuropeptide_y (mood supports resilience)
    -0.100,  // 2: norepinephrine → neuropeptide_y (acute stress depletes)
    -0.150,  // 3: epinephrine → neuropeptide_y (emergency depletes)
    0.080,   // 4: acetylcholine → neuropeptide_y (attention supports)
    0.100,   // 5: gaba → neuropeptide_y (inhibition supports resilience)
    0.050,   // 6: glycine → neuropeptide_y (minimal effect)
    -0.080,  // 7: glutamate → neuropeptide_y (excitation depletes)
    0.150,   // 8: oxytocin → neuropeptide_y (social resilience)
    0.050,   // 9: vasopressin → neuropeptide_y (stress-resilience coupling)
    0.100,   // 10: beta_endorphin → neuropeptide_y (opioid-resilience)
    -0.150,  // 11: substance_p → neuropeptide_y (pain depletes resilience)
    0.000,   // 12: neuropeptide_y → neuropeptide_y (self)
    0.050,   // 13: adenosine → neuropeptide_y (energy-resilience)
    0.100,   // 14: anandamide → neuropeptide_y (cannabinoid-resilience)
    0.080,   // 15: two_ag → neuropeptide_y (endocannabinoid)
    0.030,   // 16: nitric_oxide → neuropeptide_y (vascular)
    0.150,   // 17: bdnf → neuropeptide_y (neurotrophic supports resilience)
    0.100,   // 18: ngf → neuropeptide_y (growth factor)
    -0.300,  // 19: cortisol → neuropeptide_y (chronic stress depletes NPY)
    0.050    // 20: testosterone → neuropeptide_y (androgens support)
  ];

  // ROW 13: How each chemical affects ADENOSINE
  // Adenosine is modulated by: activity level, sleep pressure, ATP depletion
  public let CROSSTALK_ADENOSINE : [Float] = [
    0.100,   // 0: dopamine → adenosine (activity generates adenosine)
    -0.050,  // 1: serotonin → adenosine (mood state)
    0.200,   // 2: norepinephrine → adenosine (high activity builds adenosine)
    0.150,   // 3: epinephrine → adenosine (emergency depletes ATP → adenosine)
    0.100,   // 4: acetylcholine → adenosine (cognitive work builds pressure)
    -0.100,  // 5: gaba → adenosine (rest clears adenosine)
    -0.050,  // 6: glycine → adenosine (rest)
    0.250,   // 7: glutamate → adenosine (excitatory activity builds pressure)
    -0.050,  // 8: oxytocin → adenosine (social rest)
    0.050,   // 9: vasopressin → adenosine (minimal effect)
    -0.080,  // 10: beta_endorphin → adenosine (opioid rest)
    0.100,   // 11: substance_p → adenosine (pain activity)
    -0.100,  // 12: neuropeptide_y → adenosine (resilience clears)
    0.000,   // 13: adenosine → adenosine (self)
    -0.100,  // 14: anandamide → adenosine (cannabinoid clearance)
    -0.050,  // 15: two_ag → adenosine (endocannabinoid)
    -0.050,  // 16: nitric_oxide → adenosine (vascular clearance)
    -0.050,  // 17: bdnf → adenosine (recovery)
    -0.030,  // 18: ngf → adenosine (growth factor)
    0.200,   // 19: cortisol → adenosine (chronic stress builds fatigue)
    0.080    // 20: testosterone → adenosine (activity)
  ];

  // ROW 14: How each chemical affects ANANDAMIDE
  // Anandamide is modulated by: flow state, pleasure, relaxation
  public let CROSSTALK_ANANDAMIDE : [Float] = [
    0.200,   // 0: dopamine → anandamide (reward triggers endocannabinoid)
    0.150,   // 1: serotonin → anandamide (mood supports flow)
    -0.100,  // 2: norepinephrine → anandamide (high arousal opposes flow)
    -0.200,  // 3: epinephrine → anandamide (emergency opposes flow)
    0.100,   // 4: acetylcholine → anandamide (focused attention → flow)
    0.150,   // 5: gaba → anandamide (calm supports flow)
    0.050,   // 6: glycine → anandamide (relaxation)
    -0.100,  // 7: glutamate → anandamide (overexcitation opposes flow)
    0.150,   // 8: oxytocin → anandamide (social flow)
    0.050,   // 9: vasopressin → anandamide (minimal effect)
    0.200,   // 10: beta_endorphin → anandamide (opioid-cannabinoid synergy)
    -0.150,  // 11: substance_p → anandamide (pain opposes flow)
    0.100,   // 12: neuropeptide_y → anandamide (resilience supports flow)
    -0.100,  // 13: adenosine → anandamide (fatigue opposes flow)
    0.000,   // 14: anandamide → anandamide (self)
    0.150,   // 15: two_ag → anandamide (endocannabinoid synergy)
    0.080,   // 16: nitric_oxide → anandamide (vascular flow)
    0.150,   // 17: bdnf → anandamide (neurotrophic supports flow)
    0.080,   // 18: ngf → anandamide (growth factor)
    -0.250,  // 19: cortisol → anandamide (chronic stress opposes flow)
    0.050    // 20: testosterone → anandamide (androgens)
  ];

  // ROW 15: How each chemical affects TWO_AG (2-Arachidonoylglycerol)
  // 2-AG is modulated by: synaptic activity, memory, retrograde signaling
  public let CROSSTALK_TWO_AG : [Float] = [
    0.150,   // 0: dopamine → two_ag (reward triggers release)
    0.080,   // 1: serotonin → two_ag (mood)
    0.100,   // 2: norepinephrine → two_ag (arousal-memory)
    0.050,   // 3: epinephrine → two_ag (emergency encoding)
    0.180,   // 4: acetylcholine → two_ag (learning triggers release)
    0.050,   // 5: gaba → two_ag (inhibitory-retrograde)
    0.030,   // 6: glycine → two_ag (minimal effect)
    0.200,   // 7: glutamate → two_ag (excitation triggers retrograde)
    0.100,   // 8: oxytocin → two_ag (social memory)
    0.150,   // 9: vasopressin → two_ag (memory consolidation)
    0.100,   // 10: beta_endorphin → two_ag (opioid-cannabinoid)
    -0.050,  // 11: substance_p → two_ag (pain)
    0.080,   // 12: neuropeptide_y → two_ag (resilience)
    -0.050,  // 13: adenosine → two_ag (fatigue)
    0.200,   // 14: anandamide → two_ag (endocannabinoid synergy)
    0.000,   // 15: two_ag → two_ag (self)
    0.050,   // 16: nitric_oxide → two_ag (vascular)
    0.150,   // 17: bdnf → two_ag (neurotrophic-memory)
    0.080,   // 18: ngf → two_ag (growth factor)
    -0.100,  // 19: cortisol → two_ag (chronic stress impairs)
    0.050    // 20: testosterone → two_ag (androgens)
  ];

  // ROW 16: How each chemical affects NITRIC_OXIDE
  // Nitric oxide is modulated by: vascular needs, long-range signaling
  public let CROSSTALK_NITRIC_OXIDE : [Float] = [
    0.150,   // 0: dopamine → nitric_oxide (reward vascular)
    0.100,   // 1: serotonin → nitric_oxide (mood vascular)
    0.200,   // 2: norepinephrine → nitric_oxide (arousal vascular)
    0.250,   // 3: epinephrine → nitric_oxide (emergency vascular)
    0.150,   // 4: acetylcholine → nitric_oxide (ACh triggers NO release)
    -0.050,  // 5: gaba → nitric_oxide (minimal effect)
    0.020,   // 6: glycine → nitric_oxide (minimal effect)
    0.180,   // 7: glutamate → nitric_oxide (NMDA-NO coupling)
    0.100,   // 8: oxytocin → nitric_oxide (social vascular)
    0.080,   // 9: vasopressin → nitric_oxide (stress vascular)
    0.050,   // 10: beta_endorphin → nitric_oxide (opioid vascular)
    -0.050,  // 11: substance_p → nitric_oxide (pain vascular)
    0.050,   // 12: neuropeptide_y → nitric_oxide (resilience)
    -0.100,  // 13: adenosine → nitric_oxide (fatigue impairs)
    0.100,   // 14: anandamide → nitric_oxide (cannabinoid vascular)
    0.080,   // 15: two_ag → nitric_oxide (endocannabinoid)
    0.000,   // 16: nitric_oxide → nitric_oxide (self)
    0.150,   // 17: bdnf → nitric_oxide (neurotrophic vascular)
    0.080,   // 18: ngf → nitric_oxide (growth factor)
    -0.150,  // 19: cortisol → nitric_oxide (chronic stress impairs vascular)
    0.100    // 20: testosterone → nitric_oxide (androgens vascular)
  ];

  // ROW 17: How each chemical affects BDNF
  // BDNF is modulated by: learning, exercise, growth signals
  public let CROSSTALK_BDNF : [Float] = [
    0.200,   // 0: dopamine → bdnf (reward learning)
    0.150,   // 1: serotonin → bdnf (antidepressant effect)
    0.100,   // 2: norepinephrine → bdnf (arousal learning)
    0.050,   // 3: epinephrine → bdnf (emergency learning)
    0.250,   // 4: acetylcholine → bdnf (cholinergic-neurotrophic coupling)
    0.050,   // 5: gaba → bdnf (inhibitory plasticity)
    0.030,   // 6: glycine → bdnf (minimal effect)
    0.200,   // 7: glutamate → bdnf (activity-dependent BDNF)
    0.150,   // 8: oxytocin → bdnf (social learning)
    0.100,   // 9: vasopressin → bdnf (memory-neurotrophic)
    0.080,   // 10: beta_endorphin → bdnf (exercise-induced)
    -0.100,  // 11: substance_p → bdnf (chronic pain impairs)
    0.150,   // 12: neuropeptide_y → bdnf (resilience-neurotrophic)
    -0.100,  // 13: adenosine → bdnf (fatigue impairs)
    0.150,   // 14: anandamide → bdnf (cannabinoid-neurotrophic)
    0.100,   // 15: two_ag → bdnf (endocannabinoid)
    0.150,   // 16: nitric_oxide → bdnf (vascular supports growth)
    0.000,   // 17: bdnf → bdnf (self)
    0.200,   // 18: ngf → bdnf (neurotrophin synergy)
    -0.300,  // 19: cortisol → bdnf (chronic stress suppresses BDNF)
    0.100    // 20: testosterone → bdnf (androgens support)
  ];

  // ROW 18: How each chemical affects NGF
  // NGF is modulated by: growth needs, injury, development
  public let CROSSTALK_NGF : [Float] = [
    0.100,   // 0: dopamine → ngf (reward growth)
    0.100,   // 1: serotonin → ngf (mood growth)
    0.050,   // 2: norepinephrine → ngf (arousal)
    0.030,   // 3: epinephrine → ngf (emergency)
    0.150,   // 4: acetylcholine → ngf (cholinergic-NGF coupling)
    0.030,   // 5: gaba → ngf (minimal effect)
    0.020,   // 6: glycine → ngf (minimal effect)
    0.100,   // 7: glutamate → ngf (activity-dependent)
    0.100,   // 8: oxytocin → ngf (social growth)
    0.080,   // 9: vasopressin → ngf (memory-growth)
    0.050,   // 10: beta_endorphin → ngf (opioid-growth)
    0.150,   // 11: substance_p → ngf (injury-NGF coupling)
    0.100,   // 12: neuropeptide_y → ngf (resilience-growth)
    -0.050,  // 13: adenosine → ngf (fatigue impairs)
    0.100,   // 14: anandamide → ngf (cannabinoid-growth)
    0.080,   // 15: two_ag → ngf (endocannabinoid)
    0.080,   // 16: nitric_oxide → ngf (vascular supports growth)
    0.250,   // 17: bdnf → ngf (neurotrophin synergy)
    0.000,   // 18: ngf → ngf (self)
    -0.200,  // 19: cortisol → ngf (chronic stress impairs growth)
    0.080    // 20: testosterone → ngf (androgens support)
  ];

  // ROW 19: How each chemical affects CORTISOL
  // Cortisol is modulated by: stress, threat, chronic load
  public let CROSSTALK_CORTISOL : [Float] = [
    -0.150,  // 0: dopamine → cortisol (reward suppresses stress)
    -0.200,  // 1: serotonin → cortisol (mood suppresses stress)
    0.250,   // 2: norepinephrine → cortisol (arousal drives HPA)
    0.300,   // 3: epinephrine → cortisol (emergency drives HPA)
    -0.050,  // 4: acetylcholine → cortisol (minimal effect)
    -0.150,  // 5: gaba → cortisol (inhibition suppresses stress)
    -0.050,  // 6: glycine → cortisol (minimal effect)
    0.200,   // 7: glutamate → cortisol (excitation drives stress)
    -0.200,  // 8: oxytocin → cortisol (social safety suppresses stress)
    0.150,   // 9: vasopressin → cortisol (AVP-cortisol coupling)
    -0.100,  // 10: beta_endorphin → cortisol (opioid dampens stress)
    0.250,   // 11: substance_p → cortisol (pain drives stress)
    -0.200,  // 12: neuropeptide_y → cortisol (resilience suppresses cortisol)
    0.100,   // 13: adenosine → cortisol (fatigue-stress coupling)
    -0.150,  // 14: anandamide → cortisol (cannabinoid reduces stress)
    -0.100,  // 15: two_ag → cortisol (endocannabinoid)
    -0.050,  // 16: nitric_oxide → cortisol (vascular)
    -0.150,  // 17: bdnf → cortisol (neurotrophic suppresses chronic stress)
    -0.100,  // 18: ngf → cortisol (growth factor)
    0.000,   // 19: cortisol → cortisol (self)
    0.150    // 20: testosterone → cortisol (androgens-stress coupling)
  ];

  // ROW 20: How each chemical affects TESTOSTERONE
  // Testosterone is modulated by: dominance, competition, aggression
  public let CROSSTALK_TESTOSTERONE : [Float] = [
    0.200,   // 0: dopamine → testosterone (reward-dominance)
    -0.100,  // 1: serotonin → testosterone (calm reduces aggression)
    0.200,   // 2: norepinephrine → testosterone (arousal-dominance)
    0.150,   // 3: epinephrine → testosterone (emergency-aggression)
    0.050,   // 4: acetylcholine → testosterone (minimal effect)
    -0.100,  // 5: gaba → testosterone (inhibition reduces)
    -0.030,  // 6: glycine → testosterone (minimal effect)
    0.150,   // 7: glutamate → testosterone (excitation-aggression)
    -0.150,  // 8: oxytocin → testosterone (bonding opposes aggression)
    0.150,   // 9: vasopressin → testosterone (dominance-memory)
    0.050,   // 10: beta_endorphin → testosterone (winner effect)
    0.100,   // 11: substance_p → testosterone (pain-aggression)
    0.050,   // 12: neuropeptide_y → testosterone (resilience)
    -0.080,  // 13: adenosine → testosterone (fatigue reduces)
    0.080,   // 14: anandamide → testosterone (cannabinoid)
    0.050,   // 15: two_ag → testosterone (endocannabinoid)
    0.100,   // 16: nitric_oxide → testosterone (vascular)
    0.100,   // 17: bdnf → testosterone (neurotrophic)
    0.080,   // 18: ngf → testosterone (growth factor)
    0.200,   // 19: cortisol → testosterone (acute stress boosts, chronic depletes)
    0.000    // 20: testosterone → testosterone (self)
  ];

  // Full 21×21 crosstalk matrix as 2D array
  public let CROSSTALK_MATRIX : [[Float]] = [
    CROSSTALK_DOPAMINE,
    CROSSTALK_SEROTONIN,
    CROSSTALK_NOREPINEPHRINE,
    CROSSTALK_EPINEPHRINE,
    CROSSTALK_ACETYLCHOLINE,
    CROSSTALK_GABA,
    CROSSTALK_GLYCINE,
    CROSSTALK_GLUTAMATE,
    CROSSTALK_OXYTOCIN,
    CROSSTALK_VASOPRESSIN,
    CROSSTALK_BETA_ENDORPHIN,
    CROSSTALK_SUBSTANCE_P,
    CROSSTALK_NEUROPEPTIDE_Y,
    CROSSTALK_ADENOSINE,
    CROSSTALK_ANANDAMIDE,
    CROSSTALK_TWO_AG,
    CROSSTALK_NITRIC_OXIDE,
    CROSSTALK_BDNF,
    CROSSTALK_NGF,
    CROSSTALK_CORTISOL,
    CROSSTALK_TESTOSTERONE
  ];

  // ============================================================
  // CROSSTALK APPLICATION — FULL MATRIX MULTIPLICATION
  // ============================================================

  // Convert NC to array for matrix operations
  public func ncToArray(nc: NC) : [Float] {
    [
      nc.dopamine, nc.serotonin, nc.norepinephrine, nc.epinephrine,
      nc.acetylcholine, nc.gaba, nc.glycine, nc.glutamate,
      nc.oxytocin, nc.vasopressin, nc.beta_endorphin, nc.substance_p,
      nc.neuropeptide_y, nc.adenosine, nc.anandamide, nc.two_ag,
      nc.nitric_oxide, nc.bdnf, nc.ngf, nc.cortisol, nc.testosterone
    ]
  };

  // Convert array back to NC
  public func arrayToNC(arr: [Float]) : NC {
    {
      dopamine = arr[0];
      serotonin = arr[1];
      norepinephrine = arr[2];
      epinephrine = arr[3];
      acetylcholine = arr[4];
      gaba = arr[5];
      glycine = arr[6];
      glutamate = arr[7];
      oxytocin = arr[8];
      vasopressin = arr[9];
      beta_endorphin = arr[10];
      substance_p = arr[11];
      neuropeptide_y = arr[12];
      adenosine = arr[13];
      anandamide = arr[14];
      two_ag = arr[15];
      nitric_oxide = arr[16];
      bdnf = arr[17];
      ngf = arr[18];
      cortisol = arr[19];
      testosterone = arr[20];
    }
  };

  // Apply crosstalk: for each chemical i, sum contributions from all chemicals j
  // Δnc[i] = Σⱼ (CROSSTALK[i][j] × nc[j] × crosstalkStrength)
  public func applyCrosstalk(nc: NC, crosstalkStrength: Float) : NC {
    let ncArr = ncToArray(nc);
    let maxArr = ncToArray(NC_MAX);
    var result = Array.init<Float>(21, 0.0);
    
    // Matrix-vector multiplication
    var i = 0;
    while (i < 21) {
      var sum : Float = ncArr[i]; // Start with current value
      var j = 0;
      while (j < 21) {
        // Add crosstalk contribution
        sum += CROSSTALK_MATRIX[i][j] * ncArr[j] * crosstalkStrength;
        j += 1;
      };
      // Clamp to valid range
      result[i] := _clamp(sum, 0.0, maxArr[i]);
      i += 1;
    };
    
    arrayToNC(Array.freeze(result))
  };

  // ============================================================
  // FULL NC UPDATE WITH CROSSTALK
  // ============================================================

  // Beat with crosstalk applied
  public func beatNCWithCrosstalk(nc: NC, org: OrgState, crosstalkStrength: Float) : NC {
    // First apply standard dynamics
    let ncAfterDynamics = beatNC(nc, org);
    // Then apply crosstalk
    applyCrosstalk(ncAfterDynamics, crosstalkStrength)
  };

  // ============================================================
  // RECEPTOR DYNAMICS — EXPLICIT SATURATION CURVES
  // ============================================================

  // Michaelis-Menten receptor saturation
  // Effect = Emax × [C] / (EC50 + [C])
  public func receptorSaturation(
    concentration: Float,
    emax: Float,    // Maximum effect
    ec50: Float     // Half-maximal concentration
  ) : Float {
    emax * concentration / (ec50 + concentration)
  };

  // EC50 values for each neurochemical (concentration at half-max effect)
  public let EC50_VALUES : [Float] = [
    0.40,  // 0: dopamine EC50
    0.45,  // 1: serotonin EC50
    0.35,  // 2: norepinephrine EC50
    0.25,  // 3: epinephrine EC50
    0.40,  // 4: acetylcholine EC50
    0.50,  // 5: gaba EC50
    0.45,  // 6: glycine EC50
    0.35,  // 7: glutamate EC50
    0.30,  // 8: oxytocin EC50
    0.35,  // 9: vasopressin EC50
    0.40,  // 10: beta_endorphin EC50
    0.25,  // 11: substance_p EC50
    0.45,  // 12: neuropeptide_y EC50
    0.30,  // 13: adenosine EC50
    0.35,  // 14: anandamide EC50
    0.35,  // 15: two_ag EC50
    0.40,  // 16: nitric_oxide EC50
    0.50,  // 17: bdnf EC50
    0.45,  // 18: ngf EC50
    0.30,  // 19: cortisol EC50
    0.40   // 20: testosterone EC50
  ];

  // Compute effective receptor activation for all chemicals
  public func computeReceptorActivation(nc: NC) : [Float] {
    let ncArr = ncToArray(nc);
    Array.tabulate<Float>(21, func(i) {
      receptorSaturation(ncArr[i], 1.0, EC50_VALUES[i])
    })
  };

  // ============================================================
  // TOLERANCE DYNAMICS — RECEPTOR DOWNREGULATION
  // ============================================================

  // Tolerance state for each chemical
  public type ToleranceState = {
    tolerances: [Float];  // 21 tolerance values [0, 1]
    lastUpdate: Nat;
  };

  // Update tolerance: prolonged high levels → downregulation
  // dT/dt = α × (C - threshold) - β × T
  public func updateTolerance(
    tolerance: Float,
    concentration: Float,
    threshold: Float,    // Level above which tolerance builds
    buildRate: Float,    // α
    decayRate: Float     // β
  ) : Float {
    let build = if (concentration > threshold) {
      buildRate * (concentration - threshold)
    } else { 0.0 };
    let decay = decayRate * tolerance;
    _clamp(tolerance + build - decay, 0.0, 0.8) // Max 80% tolerance
  };

  // Thresholds above which tolerance builds
  public let TOLERANCE_THRESHOLDS : [Float] = [
    0.70,  // 0: dopamine
    0.75,  // 1: serotonin
    0.65,  // 2: norepinephrine
    0.50,  // 3: epinephrine
    0.70,  // 4: acetylcholine
    0.75,  // 5: gaba
    0.70,  // 6: glycine
    0.65,  // 7: glutamate
    0.60,  // 8: oxytocin
    0.65,  // 9: vasopressin
    0.60,  // 10: beta_endorphin
    0.50,  // 11: substance_p
    0.70,  // 12: neuropeptide_y
    0.55,  // 13: adenosine
    0.60,  // 14: anandamide
    0.60,  // 15: two_ag
    0.70,  // 16: nitric_oxide
    0.80,  // 17: bdnf
    0.75,  // 18: ngf
    0.50,  // 19: cortisol
    0.65   // 20: testosterone
  ];

  // Build rates for tolerance
  public let TOLERANCE_BUILD_RATES : [Float] = [
    0.02,  // 0: dopamine (fast tolerance)
    0.01,  // 1: serotonin
    0.015, // 2: norepinephrine
    0.03,  // 3: epinephrine (very fast)
    0.01,  // 4: acetylcholine
    0.02,  // 5: gaba
    0.015, // 6: glycine
    0.025, // 7: glutamate
    0.01,  // 8: oxytocin
    0.01,  // 9: vasopressin
    0.03,  // 10: beta_endorphin (opioid tolerance)
    0.02,  // 11: substance_p
    0.01,  // 12: neuropeptide_y
    0.02,  // 13: adenosine
    0.025, // 14: anandamide
    0.02,  // 15: two_ag
    0.015, // 16: nitric_oxide
    0.005, // 17: bdnf (slow tolerance)
    0.005, // 18: ngf
    0.015, // 19: cortisol
    0.01   // 20: testosterone
  ];

  // Decay rates for tolerance recovery
  public let TOLERANCE_DECAY_RATES : [Float] = [
    0.01,  // 0: dopamine
    0.008, // 1: serotonin
    0.012, // 2: norepinephrine
    0.02,  // 3: epinephrine (fast recovery)
    0.008, // 4: acetylcholine
    0.01,  // 5: gaba
    0.01,  // 6: glycine
    0.015, // 7: glutamate
    0.008, // 8: oxytocin
    0.008, // 9: vasopressin
    0.005, // 10: beta_endorphin (slow recovery)
    0.015, // 11: substance_p
    0.008, // 12: neuropeptide_y
    0.01,  // 13: adenosine
    0.01,  // 14: anandamide
    0.01,  // 15: two_ag
    0.012, // 16: nitric_oxide
    0.003, // 17: bdnf
    0.003, // 18: ngf
    0.008, // 19: cortisol
    0.006  // 20: testosterone
  ];

  // Update all tolerances
  public func updateAllTolerances(
    toleranceState: ToleranceState,
    nc: NC,
    beat: Nat
  ) : ToleranceState {
    let ncArr = ncToArray(nc);
    let newTolerances = Array.tabulate<Float>(21, func(i) {
      updateTolerance(
        toleranceState.tolerances[i],
        ncArr[i],
        TOLERANCE_THRESHOLDS[i],
        TOLERANCE_BUILD_RATES[i],
        TOLERANCE_DECAY_RATES[i]
      )
    });
    {
      tolerances = newTolerances;
      lastUpdate = beat;
    }
  };

  // Apply tolerance to get effective levels
  public func applyTolerance(nc: NC, toleranceState: ToleranceState) : NC {
    let ncArr = ncToArray(nc);
    let effectiveArr = Array.tabulate<Float>(21, func(i) {
      ncArr[i] * (1.0 - toleranceState.tolerances[i] * 0.5)
    });
    arrayToNC(effectiveArr)
  };

  // Initialize tolerance state
  public func initToleranceState() : ToleranceState {
    {
      tolerances = Array.tabulate<Float>(21, func(_) { 0.0 });
      lastUpdate = 0;
    }
  };

}

  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };

}
