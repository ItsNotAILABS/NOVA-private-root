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


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// ███╗   ██╗███████╗██╗   ██╗██████╗  ██████╗  ██████╗██╗  ██╗███████╗███╗   ███╗██╗ ██████╗ █████╗ ██╗     
// ████╗  ██║██╔════╝██║   ██║██╔══██╗██╔═══██╗██╔════╝██║  ██║██╔════╝████╗ ████║██║██╔════╝██╔══██╗██║     
// ██╔██╗ ██║█████╗  ██║   ██║██████╔╝██║   ██║██║     ███████║█████╗  ██╔████╔██║██║██║     ███████║██║     
// ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║   ██║██║     ██╔══██║██╔══╝  ██║╚██╔╝██║██║██║     ██╔══██║██║     
// ██║ ╚████║███████╗╚██████╔╝██║  ██║╚██████╔╝╚██████╗██║  ██║███████╗██║ ╚═╝ ██║██║╚██████╗██║  ██║███████╗
// ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝
//                                                                                                            
//  ██████╗██████╗  ██████╗ ███████╗███████╗████████╗ █████╗ ██╗     ██╗  ██╗    ███╗   ███╗ █████╗ ████████╗██████╗ ██╗██╗  ██╗
// ██╔════╝██╔══██╗██╔═══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██║     ██║ ██╔╝    ████╗ ████║██╔══██╗╚══██╔══╝██╔══██╗██║╚██╗██╔╝
// ██║     ██████╔╝██║   ██║███████╗███████╗   ██║   ███████║██║     █████╔╝     ██╔████╔██║███████║   ██║   ██████╔╝██║ ╚███╔╝ 
// ██║     ██╔══██╗██║   ██║╚════██║╚════██║   ██║   ██╔══██║██║     ██╔═██╗     ██║╚██╔╝██║██╔══██║   ██║   ██╔══██╗██║ ██╔██╗ 
// ╚██████╗██║  ██║╚██████╔╝███████║███████║   ██║   ██║  ██║███████╗██║  ██╗    ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║██║██╔╝ ██╗
//  ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// 21×21 NEUROCHEMICAL CROSSTALK MATRIX — 441 COUPLED DIFFERENTIAL EQUATIONS
// Full Pharmacokinetics: Half-life, Reuptake, Receptor Saturation, Cross-Coupling
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — NEUROCHEMICAL PHARMACOKINETICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ══ THE 21 NEUROCHEMICALS ═══════════════════════════════════════════════════
//
//  0. DOPAMINE (DA)        — Reward, motivation, pleasure
//  1. SEROTONIN (5-HT)     — Mood, satiety, well-being
//  2. NOREPINEPHRINE (NE)  — Alertness, arousal, fight-or-flight
//  3. ACETYLCHOLINE (ACh)  — Learning, memory, attention
//  4. GABA                 — Inhibition, calm, anxiety reduction
//  5. GLUTAMATE (Glu)      — Excitation, learning, memory
//  6. ENDORPHIN (β-End)    — Pain relief, euphoria
//  7. OXYTOCIN (OT)        — Bonding, trust, social connection
//  8. CORTISOL (CORT)      — Stress response, metabolism
//  9. ADRENALINE (EPI)     — Fight-or-flight, energy burst
// 10. MELATONIN (MEL)      — Sleep, circadian rhythm
// 11. HISTAMINE (HA)       — Wakefulness, immune response
// 12. SUBSTANCE P (SP)     — Pain transmission, inflammation
// 13. ADENOSINE (ADO)      — Sleep pressure, energy regulation
// 14. ANANDAMIDE (AEA)     — Bliss, pain modulation, appetite
// 15. DYNORPHIN (DYN)      — Dysphoria, stress response
// 16. VASOPRESSIN (AVP)    — Social behavior, water balance
// 17. NEUROPEPTIDE Y (NPY) — Appetite, stress resilience
// 18. OREXIN (ORX)         — Wakefulness, appetite, reward
// 19. BDNF                 — Neuroplasticity, growth
// 20. NGF                  — Neuron survival, growth
//
// ══ PHARMACOKINETIC EQUATIONS ═══════════════════════════════════════════════
//
// For each neurochemical i:
//
// SYNTHESIS:
//   dS_i/dt = V_max_synth × [precursor] / (K_m_synth + [precursor]) - k_degrad × S_i
//
// RELEASE:
//   R_i = S_i × P_release × f(Ca²⁺) × f(action_potential)
//
// RECEPTOR BINDING (Michaelis-Menten):
//   B_i = B_max × [C_i] / (K_d + [C_i])
//   Where B_max = maximum binding, K_d = dissociation constant
//
// RECEPTOR SATURATION:
//   Sat_i = B_i / B_max = [C_i] / (K_d + [C_i])
//
// REUPTAKE (first-order):
//   dC_i/dt = -k_reuptake × [C_i] × (1 - transporter_saturation)
//
// ENZYMATIC DEGRADATION:
//   dC_i/dt = -V_max_degrad × [C_i] / (K_m_degrad + [C_i])
//
// HALF-LIFE DECAY:
//   C_i(t) = C_i(0) × e^(-ln(2) × t / t_half)
//   k_decay = ln(2) / t_half
//
// ══ CROSS-COUPLING MATRIX ═══════════════════════════════════════════════════
//
// The 21×21 matrix M where M[i][j] = effect of neurochemical j on neurochemical i
//
// dC_i/dt = f_intrinsic(C_i) + Σ_j M[i][j] × g(C_j)
//
// Where:
//   f_intrinsic = synthesis - degradation - reuptake
//   g(C_j) = nonlinear coupling function (sigmoid, Hill equation)
//   M[i][j] > 0: j enhances i
//   M[i][j] < 0: j inhibits i
//   M[i][j] = 0: no direct coupling
//
// ══ EXAMPLE COUPLINGS ═══════════════════════════════════════════════════════
//
// DA ↔ 5-HT: Mutual inhibition (serotonin-dopamine balance)
// NE → CORT: Norepinephrine stimulates cortisol release
// CORT → 5-HT: Cortisol reduces serotonin (stress → depression)
// GABA ⊣ Glu: GABA inhibits glutamate (excitation-inhibition balance)
// OT → DA: Oxytocin enhances dopamine (love → reward)
// EPI → NE: Adrenaline amplifies norepinephrine
// MEL ⊣ ORX: Melatonin inhibits orexin (sleep onset)
// ADO → MEL: Adenosine promotes melatonin (sleep pressure)
// BDNF → 5-HT: BDNF enhances serotonin synthesis
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module NeurochemicalCrosstalkMatrix {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let NUM_CHEMICALS : Nat = 21;
  public let MATRIX_SIZE : Nat = 441;  // 21 × 21
  
  public let PHI : Float = 1.6180339887498948482;
  public let E : Float = 2.7182818284590452354;
  public let LN2 : Float = 0.6931471805599453;
  public let S0 : Float = 1.0;  // Sovereign floor
  
  // ═══════════════════════════════════════════════════════════════════════════
  // NEUROCHEMICAL INDICES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let DA : Nat = 0;    // Dopamine
  public let SEROTONIN : Nat = 1;    // 5-HT
  public let NE : Nat = 2;    // Norepinephrine
  public let ACH : Nat = 3;   // Acetylcholine
  public let GABA : Nat = 4;  // GABA
  public let GLU : Nat = 5;   // Glutamate
  public let ENDORPHIN : Nat = 6;   // β-Endorphin
  public let OT : Nat = 7;    // Oxytocin
  public let CORT : Nat = 8;  // Cortisol
  public let EPI : Nat = 9;   // Adrenaline/Epinephrine
  public let MEL : Nat = 10;  // Melatonin
  public let HA : Nat = 11;   // Histamine
  public let SP : Nat = 12;   // Substance P
  public let ADO : Nat = 13;  // Adenosine
  public let AEA : Nat = 14;  // Anandamide
  public let DYN : Nat = 15;  // Dynorphin
  public let AVP : Nat = 16;  // Vasopressin
  public let NPY : Nat = 17;  // Neuropeptide Y
  public let ORX : Nat = 18;  // Orexin
  public let BDNF : Nat = 19; // Brain-derived neurotrophic factor
  public let NGF : Nat = 20;  // Nerve growth factor
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PHARMACOKINETIC PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Half-lives in "beats" (organism time units)
  // Based on biological half-lives scaled to organism rhythm
  public type HalfLifeParams = {
    halfLife : Float;          // t_1/2 in beats
    decayConstant : Float;     // k = ln(2) / t_1/2
  };
  
  public func getHalfLife(chemical : Nat) : HalfLifeParams {
    let halfLife = switch (chemical) {
      case (0) { 20.0 };     // DA: ~20 beats (fast turnover)
      case (1) { 50.0 };     // 5-HT: ~50 beats (moderate)
      case (2) { 15.0 };     // NE: ~15 beats (fast)
      case (3) { 10.0 };     // ACh: ~10 beats (very fast)
      case (4) { 30.0 };     // GABA: ~30 beats
      case (5) { 8.0 };      // Glu: ~8 beats (very fast)
      case (6) { 100.0 };    // Endorphin: ~100 beats (slow)
      case (7) { 80.0 };     // OT: ~80 beats
      case (8) { 200.0 };    // Cortisol: ~200 beats (slow)
      case (9) { 5.0 };      // EPI: ~5 beats (very fast)
      case (10) { 120.0 };   // Melatonin: ~120 beats
      case (11) { 25.0 };    // Histamine: ~25 beats
      case (12) { 15.0 };    // Substance P: ~15 beats
      case (13) { 10.0 };    // Adenosine: ~10 beats
      case (14) { 30.0 };    // Anandamide: ~30 beats
      case (15) { 60.0 };    // Dynorphin: ~60 beats
      case (16) { 90.0 };    // Vasopressin: ~90 beats
      case (17) { 70.0 };    // NPY: ~70 beats
      case (18) { 40.0 };    // Orexin: ~40 beats
      case (19) { 500.0 };   // BDNF: ~500 beats (very slow)
      case (20) { 400.0 };   // NGF: ~400 beats (very slow)
      case (_) { 50.0 };     // Default
    };
    { halfLife = halfLife; decayConstant = LN2 / halfLife }
  };
  
  // Michaelis-Menten parameters
  public type MichaelisMentenParams = {
    vMax : Float;      // Maximum velocity
    kM : Float;        // Michaelis constant (substrate concentration at half Vmax)
  };
  
  public func getSynthesisParams(chemical : Nat) : MichaelisMentenParams {
    let (vMax, kM) = switch (chemical) {
      case (0) { (0.8, 0.5) };   // DA
      case (1) { (0.6, 0.4) };   // 5-HT
      case (2) { (0.9, 0.6) };   // NE
      case (3) { (1.0, 0.3) };   // ACh
      case (4) { (0.7, 0.5) };   // GABA
      case (5) { (1.2, 0.4) };   // Glu (high synthesis rate)
      case (6) { (0.3, 0.6) };   // Endorphin
      case (7) { (0.4, 0.5) };   // OT
      case (8) { (0.5, 0.7) };   // Cortisol
      case (9) { (1.0, 0.4) };   // EPI
      case (10) { (0.3, 0.5) };  // Melatonin
      case (11) { (0.6, 0.4) };  // Histamine
      case (12) { (0.4, 0.5) };  // SP
      case (13) { (0.8, 0.3) };  // Adenosine
      case (14) { (0.3, 0.6) };  // Anandamide
      case (15) { (0.4, 0.5) };  // Dynorphin
      case (16) { (0.3, 0.6) };  // AVP
      case (17) { (0.5, 0.4) };  // NPY
      case (18) { (0.6, 0.5) };  // Orexin
      case (19) { (0.2, 0.8) };  // BDNF (slow synthesis)
      case (20) { (0.2, 0.8) };  // NGF (slow synthesis)
      case (_) { (0.5, 0.5) };
    };
    { vMax = vMax; kM = kM }
  };
  
  // Receptor binding parameters
  public type ReceptorParams = {
    bMax : Float;      // Maximum binding capacity
    kD : Float;        // Dissociation constant
    hillCoeff : Float; // Hill coefficient for cooperativity
  };
  
  public func getReceptorParams(chemical : Nat) : ReceptorParams {
    let (bMax, kD, hill) = switch (chemical) {
      case (0) { (1.0, 0.3, 1.0) };   // DA: D1/D2 receptors
      case (1) { (1.0, 0.4, 1.2) };   // 5-HT: 5-HT1A, 5-HT2A
      case (2) { (1.0, 0.35, 1.0) };  // NE: α/β adrenergic
      case (3) { (1.0, 0.25, 1.0) };  // ACh: muscarinic/nicotinic
      case (4) { (1.0, 0.5, 1.5) };   // GABA: GABA-A, GABA-B
      case (5) { (1.0, 0.3, 1.2) };   // Glu: NMDA, AMPA
      case (6) { (1.0, 0.6, 1.0) };   // Endorphin: μ-opioid
      case (7) { (0.8, 0.5, 1.0) };   // OT: OT receptor
      case (8) { (1.0, 0.7, 1.0) };   // Cortisol: GR/MR
      case (9) { (1.0, 0.3, 1.0) };   // EPI: α/β adrenergic
      case (10) { (0.6, 0.4, 1.0) };  // Melatonin: MT1/MT2
      case (11) { (0.8, 0.4, 1.0) };  // Histamine: H1-H4
      case (12) { (0.7, 0.5, 1.0) };  // SP: NK1
      case (13) { (1.0, 0.3, 1.0) };  // Adenosine: A1, A2A
      case (14) { (0.6, 0.5, 1.0) };  // Anandamide: CB1/CB2
      case (15) { (0.7, 0.6, 1.0) };  // Dynorphin: κ-opioid
      case (16) { (0.7, 0.5, 1.0) };  // AVP: V1a, V1b
      case (17) { (0.8, 0.5, 1.0) };  // NPY: Y1-Y5
      case (18) { (0.9, 0.4, 1.0) };  // Orexin: OX1R, OX2R
      case (19) { (0.5, 0.7, 1.0) };  // BDNF: TrkB
      case (20) { (0.5, 0.7, 1.0) };  // NGF: TrkA
      case (_) { (1.0, 0.5, 1.0) };
    };
    { bMax = bMax; kD = kD; hillCoeff = hill }
  };
  
  // Reuptake parameters
  public type ReuptakeParams = {
    kReuptake : Float;         // Reuptake rate constant
    transporterDensity : Float; // Transporter density [0, 1]
    maxReuptake : Float;        // Maximum reuptake rate
  };
  
  public func getReuptakeParams(chemical : Nat) : ReuptakeParams {
    let (k, density, max) = switch (chemical) {
      case (0) { (0.15, 0.8, 0.9) };   // DA: DAT
      case (1) { (0.12, 0.7, 0.85) };  // 5-HT: SERT
      case (2) { (0.18, 0.75, 0.9) };  // NE: NET
      case (3) { (0.05, 0.3, 0.5) };   // ACh: minimal reuptake (enzymatic)
      case (4) { (0.10, 0.6, 0.8) };   // GABA: GAT
      case (5) { (0.20, 0.9, 0.95) };  // Glu: EAAT (very efficient)
      case (6) { (0.02, 0.2, 0.3) };   // Endorphin: minimal
      case (7) { (0.03, 0.2, 0.3) };   // OT: minimal
      case (8) { (0.01, 0.1, 0.2) };   // Cortisol: no reuptake (slow clearance)
      case (9) { (0.20, 0.8, 0.9) };   // EPI: NET (same as NE)
      case (10) { (0.02, 0.2, 0.3) };  // Melatonin: minimal
      case (11) { (0.08, 0.5, 0.7) };  // Histamine: moderate
      case (12) { (0.04, 0.3, 0.4) };  // SP: minimal
      case (13) { (0.25, 0.9, 0.95) }; // Adenosine: ENT (very efficient)
      case (14) { (0.08, 0.5, 0.6) };  // Anandamide: FAAH
      case (15) { (0.03, 0.2, 0.3) };  // Dynorphin: minimal
      case (16) { (0.02, 0.2, 0.3) };  // AVP: minimal
      case (17) { (0.03, 0.2, 0.3) };  // NPY: minimal
      case (18) { (0.05, 0.3, 0.4) };  // Orexin: moderate
      case (19) { (0.01, 0.1, 0.15) }; // BDNF: very slow
      case (20) { (0.01, 0.1, 0.15) }; // NGF: very slow
      case (_) { (0.1, 0.5, 0.7) };
    };
    { kReuptake = k; transporterDensity = density; maxReuptake = max }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CROSSTALK COUPLING MATRIX
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Get coupling coefficient M[i][j] = effect of j on i
  // Positive = enhancement, Negative = inhibition, Zero = no coupling
  public func getCoupling(target : Nat, source : Nat) : Float {
    // This is the 21×21 crosstalk matrix
    // Each row represents how all chemicals affect one target
    
    switch (target) {
      // ════════════════════════════════════════════════════════════════════
      // DOPAMINE (target = 0) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (0) {
        switch (source) {
          case (0) { 0.0 };       // DA → DA: no self-coupling
          case (1) { -0.15 };     // 5-HT → DA: serotonin inhibits dopamine
          case (2) { 0.20 };      // NE → DA: norepinephrine enhances dopamine
          case (3) { 0.10 };      // ACh → DA: acetylcholine modulates DA
          case (4) { -0.25 };     // GABA → DA: GABA inhibits DA release
          case (5) { 0.30 };      // Glu → DA: glutamate enhances DA
          case (6) { 0.35 };      // Endorphin → DA: opioids enhance DA (reward)
          case (7) { 0.25 };      // OT → DA: oxytocin enhances DA (love=reward)
          case (8) { -0.10 };     // CORT → DA: stress reduces DA
          case (9) { 0.15 };      // EPI → DA: adrenaline enhances DA
          case (10) { -0.05 };    // MEL → DA: melatonin slightly inhibits
          case (11) { 0.05 };     // HA → DA: histamine slightly enhances
          case (12) { 0.0 };      // SP → DA: no direct coupling
          case (13) { -0.15 };    // ADO → DA: adenosine inhibits DA (sleepy)
          case (14) { 0.20 };     // AEA → DA: anandamide enhances DA
          case (15) { -0.20 };    // DYN → DA: dynorphin inhibits DA
          case (16) { 0.05 };     // AVP → DA: slight enhancement
          case (17) { -0.05 };    // NPY → DA: slight inhibition
          case (18) { 0.25 };     // ORX → DA: orexin enhances DA (motivation)
          case (19) { 0.15 };     // BDNF → DA: BDNF supports DA neurons
          case (20) { 0.10 };     // NGF → DA: NGF supports DA neurons
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // SEROTONIN (target = 1) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (1) {
        switch (source) {
          case (0) { -0.15 };     // DA → 5-HT: dopamine inhibits serotonin
          case (1) { 0.0 };       // 5-HT → 5-HT: autoreceptor regulation
          case (2) { 0.10 };      // NE → 5-HT: NE enhances 5-HT
          case (3) { 0.05 };      // ACh → 5-HT: slight enhancement
          case (4) { 0.10 };      // GABA → 5-HT: GABA modulates
          case (5) { -0.10 };     // Glu → 5-HT: glutamate inhibits
          case (6) { 0.15 };      // Endorphin → 5-HT: enhances
          case (7) { 0.20 };      // OT → 5-HT: oxytocin enhances mood
          case (8) { -0.30 };     // CORT → 5-HT: STRESS KILLS SEROTONIN
          case (9) { -0.10 };     // EPI → 5-HT: stress pathway
          case (10) { 0.15 };     // MEL → 5-HT: melatonin from serotonin
          case (11) { -0.05 };    // HA → 5-HT: slight inhibition
          case (12) { -0.10 };    // SP → 5-HT: pain inhibits mood
          case (13) { -0.05 };    // ADO → 5-HT: slight inhibition
          case (14) { 0.10 };     // AEA → 5-HT: cannabinoids enhance
          case (15) { -0.15 };    // DYN → 5-HT: dysphoria
          case (16) { 0.05 };     // AVP → 5-HT: slight enhancement
          case (17) { 0.10 };     // NPY → 5-HT: stress resilience
          case (18) { 0.05 };     // ORX → 5-HT: slight enhancement
          case (19) { 0.25 };     // BDNF → 5-HT: BDNF CRUCIAL for serotonin
          case (20) { 0.15 };     // NGF → 5-HT: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // NOREPINEPHRINE (target = 2) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (2) {
        switch (source) {
          case (0) { 0.15 };      // DA → NE: dopamine enhances NE
          case (1) { -0.10 };     // 5-HT → NE: serotonin inhibits
          case (2) { 0.0 };       // NE → NE: autoreceptors
          case (3) { 0.20 };      // ACh → NE: ACh enhances alertness
          case (4) { -0.30 };     // GABA → NE: GABA strongly inhibits
          case (5) { 0.35 };      // Glu → NE: glutamate excites
          case (6) { -0.10 };     // Endorphin → NE: opioids calm
          case (7) { -0.05 };     // OT → NE: oxytocin calms
          case (8) { 0.40 };      // CORT → NE: STRESS DRIVES NE
          case (9) { 0.50 };      // EPI → NE: adrenaline amplifies NE
          case (10) { -0.20 };    // MEL → NE: melatonin inhibits (sleep)
          case (11) { 0.25 };     // HA → NE: histamine enhances alertness
          case (12) { 0.15 };     // SP → NE: pain increases alertness
          case (13) { -0.20 };    // ADO → NE: adenosine inhibits (sleepy)
          case (14) { -0.10 };    // AEA → NE: cannabinoids calm
          case (15) { 0.15 };     // DYN → NE: stress chemical
          case (16) { 0.10 };     // AVP → NE: arousal
          case (17) { -0.10 };    // NPY → NE: stress buffer
          case (18) { 0.35 };     // ORX → NE: orexin DRIVES alertness
          case (19) { 0.10 };     // BDNF → NE: support
          case (20) { 0.10 };     // NGF → NE: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // ACETYLCHOLINE (target = 3) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (3) {
        switch (source) {
          case (0) { 0.20 };      // DA → ACh: dopamine enhances learning
          case (1) { 0.10 };      // 5-HT → ACh: slight enhancement
          case (2) { 0.25 };      // NE → ACh: alertness enhances attention
          case (3) { 0.0 };       // ACh → ACh: autoreceptors
          case (4) { -0.20 };     // GABA → ACh: inhibits
          case (5) { 0.25 };      // Glu → ACh: excites
          case (6) { -0.10 };     // Endorphin → ACh: opioids reduce
          case (7) { 0.10 };      // OT → ACh: social attention
          case (8) { -0.15 };     // CORT → ACh: stress impairs memory
          case (9) { 0.15 };      // EPI → ACh: alertness
          case (10) { -0.10 };    // MEL → ACh: sleep reduces attention
          case (11) { 0.20 };     // HA → ACh: wakefulness
          case (12) { 0.0 };      // SP → ACh: no direct
          case (13) { -0.15 };    // ADO → ACh: sleepiness
          case (14) { -0.05 };    // AEA → ACh: slight impairment
          case (15) { -0.10 };    // DYN → ACh: stress impairs
          case (16) { 0.05 };     // AVP → ACh: memory
          case (17) { 0.0 };      // NPY → ACh: neutral
          case (18) { 0.20 };     // ORX → ACh: wakefulness aids attention
          case (19) { 0.20 };     // BDNF → ACh: learning support
          case (20) { 0.15 };     // NGF → ACh: cholinergic support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // GABA (target = 4) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (4) {
        switch (source) {
          case (0) { -0.10 };     // DA → GABA: dopamine inhibits
          case (1) { 0.25 };      // 5-HT → GABA: serotonin enhances calm
          case (2) { -0.20 };     // NE → GABA: alertness opposes
          case (3) { -0.10 };     // ACh → GABA: attention opposes
          case (4) { 0.0 };       // GABA → GABA: autoreceptors
          case (5) { -0.40 };     // Glu → GABA: EXCITATION OPPOSES
          case (6) { 0.30 };      // Endorphin → GABA: opioids enhance calm
          case (7) { 0.20 };      // OT → GABA: oxytocin calms
          case (8) { -0.30 };     // CORT → GABA: stress reduces GABA
          case (9) { -0.35 };     // EPI → GABA: fight-flight opposes
          case (10) { 0.25 };     // MEL → GABA: sleep enhances GABA
          case (11) { -0.15 };    // HA → GABA: wakefulness opposes
          case (12) { -0.10 };    // SP → GABA: pain opposes calm
          case (13) { 0.20 };     // ADO → GABA: sleep pressure
          case (14) { 0.25 };     // AEA → GABA: cannabinoids enhance GABA
          case (15) { -0.15 };    // DYN → GABA: dysphoria
          case (16) { 0.05 };     // AVP → GABA: slight
          case (17) { 0.15 };     // NPY → GABA: stress resilience
          case (18) { -0.20 };    // ORX → GABA: wakefulness opposes
          case (19) { 0.15 };     // BDNF → GABA: support
          case (20) { 0.10 };     // NGF → GABA: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // GLUTAMATE (target = 5) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (5) {
        switch (source) {
          case (0) { 0.20 };      // DA → Glu: dopamine excites
          case (1) { -0.15 };     // 5-HT → Glu: serotonin inhibits
          case (2) { 0.30 };      // NE → Glu: alertness excites
          case (3) { 0.25 };      // ACh → Glu: attention enhances
          case (4) { -0.45 };     // GABA → Glu: INHIBITION OPPOSES
          case (5) { 0.0 };       // Glu → Glu: autoreceptors
          case (6) { -0.20 };     // Endorphin → Glu: opioids calm
          case (7) { -0.10 };     // OT → Glu: oxytocin calms
          case (8) { 0.25 };      // CORT → Glu: STRESS EXCITES
          case (9) { 0.35 };      // EPI → Glu: fight-flight excites
          case (10) { -0.20 };    // MEL → Glu: sleep inhibits
          case (11) { 0.20 };     // HA → Glu: wakefulness
          case (12) { 0.15 };     // SP → Glu: pain excites
          case (13) { -0.20 };    // ADO → Glu: sleep inhibits
          case (14) { -0.15 };    // AEA → Glu: cannabinoids inhibit
          case (15) { 0.20 };     // DYN → Glu: stress excites
          case (16) { 0.10 };     // AVP → Glu: arousal
          case (17) { -0.10 };    // NPY → Glu: buffer
          case (18) { 0.30 };     // ORX → Glu: wakefulness excites
          case (19) { 0.20 };     // BDNF → Glu: plasticity
          case (20) { 0.15 };     // NGF → Glu: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // ENDORPHIN (target = 6) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (6) {
        switch (source) {
          case (0) { 0.30 };      // DA → Endorphin: reward enhances
          case (1) { 0.15 };      // 5-HT → Endorphin: mood enhances
          case (2) { 0.20 };      // NE → Endorphin: exercise effect
          case (3) { 0.10 };      // ACh → Endorphin: slight
          case (4) { 0.15 };      // GABA → Endorphin: calm allows
          case (5) { 0.20 };      // Glu → Endorphin: activity triggers
          case (6) { 0.0 };       // Endorphin → Endorphin: autoreceptors
          case (7) { 0.25 };      // OT → Endorphin: love enhances
          case (8) { -0.15 };     // CORT → Endorphin: stress depletes
          case (9) { 0.20 };      // EPI → Endorphin: stress-induced analgesia
          case (10) { 0.05 };     // MEL → Endorphin: slight
          case (11) { 0.05 };     // HA → Endorphin: slight
          case (12) { 0.30 };     // SP → Endorphin: PAIN TRIGGERS ENDORPHIN
          case (13) { 0.05 };     // ADO → Endorphin: slight
          case (14) { 0.15 };     // AEA → Endorphin: cannabinoids enhance
          case (15) { -0.20 };    // DYN → Endorphin: counteracts
          case (16) { 0.10 };     // AVP → Endorphin: slight
          case (17) { 0.10 };     // NPY → Endorphin: resilience
          case (18) { 0.15 };     // ORX → Endorphin: activity
          case (19) { 0.15 };     // BDNF → Endorphin: support
          case (20) { 0.10 };     // NGF → Endorphin: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // OXYTOCIN (target = 7) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (7) {
        switch (source) {
          case (0) { 0.25 };      // DA → OT: reward enhances bonding
          case (1) { 0.20 };      // 5-HT → OT: mood enhances
          case (2) { -0.10 };     // NE → OT: stress reduces
          case (3) { 0.10 };      // ACh → OT: social attention
          case (4) { 0.15 };      // GABA → OT: calm allows bonding
          case (5) { 0.10 };      // Glu → OT: slight
          case (6) { 0.20 };      // Endorphin → OT: pleasure enhances
          case (7) { 0.0 };       // OT → OT: positive feedback loop
          case (8) { -0.25 };     // CORT → OT: STRESS KILLS OT
          case (9) { -0.15 };     // EPI → OT: stress reduces
          case (10) { 0.10 };     // MEL → OT: rest enhances
          case (11) { 0.0 };      // HA → OT: neutral
          case (12) { -0.10 };    // SP → OT: pain reduces
          case (13) { 0.05 };     // ADO → OT: slight
          case (14) { 0.15 };     // AEA → OT: bliss enhances
          case (15) { -0.20 };    // DYN → OT: dysphoria opposes
          case (16) { 0.30 };     // AVP → OT: VASOPRESSIN ENHANCES OT
          case (17) { 0.10 };     // NPY → OT: resilience
          case (18) { 0.05 };     // ORX → OT: slight
          case (19) { 0.15 };     // BDNF → OT: support
          case (20) { 0.10 };     // NGF → OT: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // CORTISOL (target = 8) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (8) {
        switch (source) {
          case (0) { -0.10 };     // DA → CORT: reward reduces stress
          case (1) { -0.20 };     // 5-HT → CORT: serotonin reduces stress
          case (2) { 0.35 };      // NE → CORT: NE DRIVES CORTISOL
          case (3) { 0.10 };      // ACh → CORT: arousal
          case (4) { -0.30 };     // GABA → CORT: calm reduces stress
          case (5) { 0.20 };      // Glu → CORT: excitation stress
          case (6) { -0.25 };     // Endorphin → CORT: opioids reduce stress
          case (7) { -0.20 };     // OT → CORT: bonding reduces stress
          case (8) { 0.0 };       // CORT → CORT: negative feedback
          case (9) { 0.45 };      // EPI → CORT: ADRENALINE DRIVES CORTISOL
          case (10) { -0.15 };    // MEL → CORT: sleep reduces
          case (11) { 0.10 };     // HA → CORT: immune stress
          case (12) { 0.25 };     // SP → CORT: PAIN DRIVES STRESS
          case (13) { -0.10 };    // ADO → CORT: sleep pressure
          case (14) { -0.15 };    // AEA → CORT: cannabinoids reduce
          case (15) { 0.30 };     // DYN → CORT: DYSPHORIA DRIVES STRESS
          case (16) { 0.15 };     // AVP → CORT: stress axis
          case (17) { -0.20 };    // NPY → CORT: RESILIENCE BUFFER
          case (18) { 0.15 };     // ORX → CORT: arousal stress
          case (19) { -0.15 };    // BDNF → CORT: neuroplasticity buffers
          case (20) { -0.10 };    // NGF → CORT: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // ADRENALINE/EPINEPHRINE (target = 9) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (9) {
        switch (source) {
          case (0) { 0.15 };      // DA → EPI: excitement
          case (1) { -0.15 };     // 5-HT → EPI: calm opposes
          case (2) { 0.40 };      // NE → EPI: NE AMPLIFIES EPI
          case (3) { 0.20 };      // ACh → EPI: sympathetic activation
          case (4) { -0.35 };     // GABA → EPI: calm opposes
          case (5) { 0.30 };      // Glu → EPI: excitation
          case (6) { -0.15 };     // Endorphin → EPI: opioids calm
          case (7) { -0.10 };     // OT → EPI: bonding calms
          case (8) { 0.35 };      // CORT → EPI: STRESS DRIVES EPI
          case (9) { 0.0 };       // EPI → EPI: autoreceptors
          case (10) { -0.25 };    // MEL → EPI: sleep opposes
          case (11) { 0.20 };     // HA → EPI: immune alertness
          case (12) { 0.25 };     // SP → EPI: pain triggers
          case (13) { -0.20 };    // ADO → EPI: sleep pressure opposes
          case (14) { -0.10 };    // AEA → EPI: cannabinoids calm
          case (15) { 0.25 };     // DYN → EPI: stress
          case (16) { 0.15 };     // AVP → EPI: arousal
          case (17) { -0.15 };    // NPY → EPI: buffer
          case (18) { 0.30 };     // ORX → EPI: wakefulness
          case (19) { 0.10 };     // BDNF → EPI: support
          case (20) { 0.05 };     // NGF → EPI: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // MELATONIN (target = 10) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (10) {
        switch (source) {
          case (0) { -0.10 };     // DA → MEL: reward reduces sleep
          case (1) { 0.30 };      // 5-HT → MEL: SEROTONIN → MELATONIN
          case (2) { -0.25 };     // NE → MEL: alertness opposes
          case (3) { -0.15 };     // ACh → MEL: attention opposes
          case (4) { 0.20 };      // GABA → MEL: calm promotes
          case (5) { -0.20 };     // Glu → MEL: excitation opposes
          case (6) { 0.10 };      // Endorphin → MEL: relaxation
          case (7) { 0.10 };      // OT → MEL: bonding relaxes
          case (8) { -0.20 };     // CORT → MEL: stress opposes sleep
          case (9) { -0.30 };     // EPI → MEL: fight-flight opposes
          case (10) { 0.0 };      // MEL → MEL: circadian rhythm
          case (11) { -0.25 };    // HA → MEL: wakefulness opposes
          case (12) { -0.10 };    // SP → MEL: pain opposes
          case (13) { 0.25 };     // ADO → MEL: SLEEP PRESSURE PROMOTES
          case (14) { 0.15 };     // AEA → MEL: relaxation
          case (15) { -0.10 };    // DYN → MEL: dysphoria
          case (16) { 0.05 };     // AVP → MEL: slight
          case (17) { 0.10 };     // NPY → MEL: resilience
          case (18) { -0.35 };    // ORX → MEL: WAKEFULNESS OPPOSES
          case (19) { 0.10 };     // BDNF → MEL: support
          case (20) { 0.05 };     // NGF → MEL: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // HISTAMINE (target = 11) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (11) {
        switch (source) {
          case (0) { 0.15 };      // DA → HA: arousal
          case (1) { -0.10 };     // 5-HT → HA: slight inhibition
          case (2) { 0.25 };      // NE → HA: alertness
          case (3) { 0.15 };      // ACh → HA: attention
          case (4) { -0.20 };     // GABA → HA: calm opposes
          case (5) { 0.20 };      // Glu → HA: excitation
          case (6) { -0.10 };     // Endorphin → HA: relaxation opposes
          case (7) { -0.05 };     // OT → HA: slight
          case (8) { 0.15 };      // CORT → HA: stress/immune
          case (9) { 0.20 };      // EPI → HA: alertness
          case (10) { -0.25 };    // MEL → HA: sleep opposes
          case (11) { 0.0 };      // HA → HA: autoreceptors
          case (12) { 0.15 };     // SP → HA: inflammation
          case (13) { -0.20 };    // ADO → HA: sleep opposes
          case (14) { -0.10 };    // AEA → HA: relaxation
          case (15) { 0.10 };     // DYN → HA: stress
          case (16) { 0.05 };     // AVP → HA: slight
          case (17) { 0.0 };      // NPY → HA: neutral
          case (18) { 0.30 };     // ORX → HA: WAKEFULNESS
          case (19) { 0.10 };     // BDNF → HA: support
          case (20) { 0.10 };     // NGF → HA: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // SUBSTANCE P (target = 12) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (12) {
        switch (source) {
          case (0) { -0.10 };     // DA → SP: reward reduces pain
          case (1) { -0.15 };     // 5-HT → SP: mood reduces pain
          case (2) { 0.20 };      // NE → SP: alertness amplifies
          case (3) { 0.10 };      // ACh → SP: attention to pain
          case (4) { -0.25 };     // GABA → SP: calm reduces pain
          case (5) { 0.30 };      // Glu → SP: excitation amplifies pain
          case (6) { -0.40 };     // Endorphin → SP: OPIOIDS BLOCK PAIN
          case (7) { -0.10 };     // OT → SP: bonding reduces pain
          case (8) { 0.25 };      // CORT → SP: stress amplifies
          case (9) { 0.20 };      // EPI → SP: arousal
          case (10) { -0.10 };    // MEL → SP: sleep reduces
          case (11) { 0.15 };     // HA → SP: inflammation
          case (12) { 0.0 };      // SP → SP: self-amplification
          case (13) { -0.10 };    // ADO → SP: slight
          case (14) { -0.20 };    // AEA → SP: cannabinoids reduce pain
          case (15) { 0.20 };     // DYN → SP: stress pain
          case (16) { 0.05 };     // AVP → SP: slight
          case (17) { -0.10 };    // NPY → SP: buffer
          case (18) { 0.10 };     // ORX → SP: arousal
          case (19) { -0.10 };    // BDNF → SP: neurotrophic
          case (20) { 0.15 };     // NGF → SP: pain sensitization
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // ADENOSINE (target = 13) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (13) {
        switch (source) {
          case (0) { -0.15 };     // DA → ADO: activity reduces sleep pressure
          case (1) { 0.10 };      // 5-HT → ADO: slight
          case (2) { -0.20 };     // NE → ADO: alertness opposes
          case (3) { -0.15 };     // ACh → ADO: activity
          case (4) { 0.15 };      // GABA → ADO: calm promotes
          case (5) { 0.25 };      // Glu → ADO: activity builds pressure
          case (6) { 0.10 };      // Endorphin → ADO: relaxation
          case (7) { 0.05 };      // OT → ADO: slight
          case (8) { -0.10 };     // CORT → ADO: stress opposes
          case (9) { -0.20 };     // EPI → ADO: fight-flight opposes
          case (10) { 0.20 };     // MEL → ADO: sleep promotes
          case (11) { -0.20 };    // HA → ADO: wakefulness opposes
          case (12) { 0.10 };     // SP → ADO: pain fatigue
          case (13) { 0.0 };      // ADO → ADO: accumulation
          case (14) { 0.10 };     // AEA → ADO: relaxation
          case (15) { 0.10 };     // DYN → ADO: fatigue
          case (16) { 0.0 };      // AVP → ADO: neutral
          case (17) { 0.05 };     // NPY → ADO: slight
          case (18) { -0.30 };    // ORX → ADO: WAKEFULNESS OPPOSES
          case (19) { -0.05 };    // BDNF → ADO: slight
          case (20) { -0.05 };    // NGF → ADO: slight
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // ANANDAMIDE (target = 14) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (14) {
        switch (source) {
          case (0) { 0.20 };      // DA → AEA: reward enhances bliss
          case (1) { 0.15 };      // 5-HT → AEA: mood enhances
          case (2) { -0.10 };     // NE → AEA: stress reduces
          case (3) { 0.10 };      // ACh → AEA: attention
          case (4) { 0.20 };      // GABA → AEA: calm promotes
          case (5) { -0.15 };     // Glu → AEA: excitation opposes
          case (6) { 0.25 };      // Endorphin → AEA: opioid-cannabinoid synergy
          case (7) { 0.15 };      // OT → AEA: bonding bliss
          case (8) { -0.20 };     // CORT → AEA: stress depletes
          case (9) { -0.15 };     // EPI → AEA: fight-flight opposes
          case (10) { 0.10 };     // MEL → AEA: rest promotes
          case (11) { -0.05 };    // HA → AEA: slight
          case (12) { 0.20 };     // SP → AEA: pain triggers endocannabinoids
          case (13) { 0.10 };     // ADO → AEA: relaxation
          case (14) { 0.0 };      // AEA → AEA: on-demand synthesis
          case (15) { -0.15 };    // DYN → AEA: dysphoria opposes
          case (16) { 0.05 };     // AVP → AEA: slight
          case (17) { 0.10 };     // NPY → AEA: resilience
          case (18) { -0.10 };    // ORX → AEA: arousal opposes
          case (19) { 0.15 };     // BDNF → AEA: plasticity
          case (20) { 0.10 };     // NGF → AEA: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // DYNORPHIN (target = 15) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (15) {
        switch (source) {
          case (0) { -0.20 };     // DA → DYN: reward opposes dysphoria
          case (1) { -0.15 };     // 5-HT → DYN: mood opposes
          case (2) { 0.25 };      // NE → DYN: stress promotes
          case (3) { 0.05 };      // ACh → DYN: slight
          case (4) { -0.20 };     // GABA → DYN: calm opposes
          case (5) { 0.25 };      // Glu → DYN: excitotoxicity
          case (6) { -0.25 };     // Endorphin → DYN: opioid balance
          case (7) { -0.15 };     // OT → DYN: bonding opposes
          case (8) { 0.35 };      // CORT → DYN: STRESS DRIVES DYSPHORIA
          case (9) { 0.25 };      // EPI → DYN: fight-flight
          case (10) { -0.10 };    // MEL → DYN: rest opposes
          case (11) { 0.10 };     // HA → DYN: immune stress
          case (12) { 0.30 };     // SP → DYN: PAIN DRIVES DYSPHORIA
          case (13) { 0.10 };     // ADO → DYN: fatigue
          case (14) { -0.15 };    // AEA → DYN: bliss opposes
          case (15) { 0.0 };      // DYN → DYN: self-amplification risk
          case (16) { 0.10 };     // AVP → DYN: stress
          case (17) { -0.20 };    // NPY → DYN: RESILIENCE OPPOSES
          case (18) { 0.15 };     // ORX → DYN: arousal
          case (19) { -0.15 };    // BDNF → DYN: plasticity opposes
          case (20) { -0.10 };    // NGF → DYN: support opposes
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // VASOPRESSIN (target = 16) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (16) {
        switch (source) {
          case (0) { 0.10 };      // DA → AVP: reward
          case (1) { 0.05 };      // 5-HT → AVP: slight
          case (2) { 0.20 };      // NE → AVP: arousal
          case (3) { 0.10 };      // ACh → AVP: attention
          case (4) { -0.10 };     // GABA → AVP: calm reduces
          case (5) { 0.15 };      // Glu → AVP: excitation
          case (6) { 0.10 };      // Endorphin → AVP: slight
          case (7) { 0.30 };      // OT → AVP: OT-AVP SYNERGY
          case (8) { 0.20 };      // CORT → AVP: stress axis
          case (9) { 0.15 };      // EPI → AVP: fight-flight
          case (10) { 0.05 };     // MEL → AVP: slight
          case (11) { 0.05 };     // HA → AVP: slight
          case (12) { 0.10 };     // SP → AVP: pain
          case (13) { 0.0 };      // ADO → AVP: neutral
          case (14) { 0.05 };     // AEA → AVP: slight
          case (15) { 0.15 };     // DYN → AVP: stress
          case (16) { 0.0 };      // AVP → AVP: autoreceptors
          case (17) { 0.10 };     // NPY → AVP: slight
          case (18) { 0.10 };     // ORX → AVP: arousal
          case (19) { 0.10 };     // BDNF → AVP: support
          case (20) { 0.10 };     // NGF → AVP: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // NEUROPEPTIDE Y (target = 17) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (17) {
        switch (source) {
          case (0) { 0.15 };      // DA → NPY: reward promotes resilience
          case (1) { 0.20 };      // 5-HT → NPY: mood promotes
          case (2) { -0.15 };     // NE → NPY: stress depletes
          case (3) { 0.10 };      // ACh → NPY: slight
          case (4) { 0.20 };      // GABA → NPY: calm promotes
          case (5) { -0.15 };     // Glu → NPY: excitation depletes
          case (6) { 0.15 };      // Endorphin → NPY: opioids enhance
          case (7) { 0.15 };      // OT → NPY: bonding enhances
          case (8) { -0.30 };     // CORT → NPY: STRESS DEPLETES RESILIENCE
          case (9) { -0.25 };     // EPI → NPY: fight-flight depletes
          case (10) { 0.15 };     // MEL → NPY: rest promotes
          case (11) { -0.05 };    // HA → NPY: slight
          case (12) { -0.15 };    // SP → NPY: pain depletes
          case (13) { 0.10 };     // ADO → NPY: rest
          case (14) { 0.15 };     // AEA → NPY: bliss promotes
          case (15) { -0.25 };    // DYN → NPY: DYSPHORIA DEPLETES
          case (16) { 0.10 };     // AVP → NPY: slight
          case (17) { 0.0 };      // NPY → NPY: positive feedback
          case (18) { -0.10 };    // ORX → NPY: appetite balance
          case (19) { 0.20 };     // BDNF → NPY: plasticity promotes
          case (20) { 0.15 };     // NGF → NPY: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // OREXIN (target = 18) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (18) {
        switch (source) {
          case (0) { 0.25 };      // DA → ORX: reward promotes wakefulness
          case (1) { -0.10 };     // 5-HT → ORX: mood balance
          case (2) { 0.25 };      // NE → ORX: alertness
          case (3) { 0.15 };      // ACh → ORX: attention
          case (4) { -0.25 };     // GABA → ORX: calm opposes
          case (5) { 0.25 };      // Glu → ORX: excitation
          case (6) { -0.10 };     // Endorphin → ORX: relaxation opposes
          case (7) { -0.05 };     // OT → ORX: slight
          case (8) { 0.15 };      // CORT → ORX: stress arousal
          case (9) { 0.20 };      // EPI → ORX: fight-flight
          case (10) { -0.35 };    // MEL → ORX: SLEEP OPPOSES WAKEFULNESS
          case (11) { 0.25 };     // HA → ORX: wakefulness synergy
          case (12) { 0.10 };     // SP → ORX: pain arousal
          case (13) { -0.30 };    // ADO → ORX: SLEEP PRESSURE OPPOSES
          case (14) { -0.10 };    // AEA → ORX: relaxation
          case (15) { 0.10 };     // DYN → ORX: stress arousal
          case (16) { 0.10 };     // AVP → ORX: arousal
          case (17) { 0.15 };     // NPY → ORX: appetite link
          case (18) { 0.0 };      // ORX → ORX: positive feedback risk
          case (19) { 0.10 };     // BDNF → ORX: support
          case (20) { 0.10 };     // NGF → ORX: support
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // BDNF (target = 19) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (19) {
        switch (source) {
          case (0) { 0.25 };      // DA → BDNF: reward promotes plasticity
          case (1) { 0.30 };      // 5-HT → BDNF: SEROTONIN KEY FOR BDNF
          case (2) { 0.15 };      // NE → BDNF: moderate arousal helps
          case (3) { 0.20 };      // ACh → BDNF: learning promotes
          case (4) { 0.10 };      // GABA → BDNF: balance helps
          case (5) { 0.20 };      // Glu → BDNF: activity promotes
          case (6) { 0.15 };      // Endorphin → BDNF: exercise effect
          case (7) { 0.15 };      // OT → BDNF: social enrichment
          case (8) { -0.35 };     // CORT → BDNF: STRESS KILLS BDNF
          case (9) { -0.15 };     // EPI → BDNF: acute stress inhibits
          case (10) { 0.10 };     // MEL → BDNF: sleep promotes
          case (11) { 0.05 };     // HA → BDNF: slight
          case (12) { -0.10 };    // SP → BDNF: pain stress
          case (13) { 0.10 };     // ADO → BDNF: rest promotes
          case (14) { 0.15 };     // AEA → BDNF: cannabinoid neuroplasticity
          case (15) { -0.25 };    // DYN → BDNF: DYSPHORIA INHIBITS
          case (16) { 0.05 };     // AVP → BDNF: slight
          case (17) { 0.20 };     // NPY → BDNF: resilience promotes
          case (18) { 0.10 };     // ORX → BDNF: activity
          case (19) { 0.0 };      // BDNF → BDNF: positive feedback
          case (20) { 0.20 };     // NGF → BDNF: neurotrophic synergy
          case (_) { 0.0 };
        }
      };
      
      // ════════════════════════════════════════════════════════════════════
      // NGF (target = 20) — affected by:
      // ════════════════════════════════════════════════════════════════════
      case (20) {
        switch (source) {
          case (0) { 0.15 };      // DA → NGF: activity promotes
          case (1) { 0.20 };      // 5-HT → NGF: mood promotes
          case (2) { 0.10 };      // NE → NGF: moderate arousal
          case (3) { 0.25 };      // ACh → NGF: CHOLINERGIC KEY FOR NGF
          case (4) { 0.10 };      // GABA → NGF: balance
          case (5) { 0.15 };      // Glu → NGF: activity
          case (6) { 0.10 };      // Endorphin → NGF: support
          case (7) { 0.15 };      // OT → NGF: social enrichment
          case (8) { -0.25 };     // CORT → NGF: stress inhibits
          case (9) { -0.10 };     // EPI → NGF: acute stress
          case (10) { 0.10 };     // MEL → NGF: sleep promotes
          case (11) { 0.05 };     // HA → NGF: immune
          case (12) { 0.15 };     // SP → NGF: pain sensitization link
          case (13) { 0.10 };     // ADO → NGF: rest
          case (14) { 0.10 };     // AEA → NGF: cannabinoid support
          case (15) { -0.15 };    // DYN → NGF: dysphoria inhibits
          case (16) { 0.05 };     // AVP → NGF: slight
          case (17) { 0.15 };     // NPY → NGF: resilience
          case (18) { 0.10 };     // ORX → NGF: activity
          case (19) { 0.25 };     // BDNF → NGF: NEUROTROPHIC SYNERGY
          case (20) { 0.0 };      // NGF → NGF: positive feedback
          case (_) { 0.0 };
        }
      };
      
      case (_) { 0.0 };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type NeurochemicalState = {
    index : Nat;
    name : Text;
    concentration : Float;        // Current level [0, ∞), clamped at S0 min
    synthesisRate : Float;        // Current synthesis rate
    releaseRate : Float;          // Current release rate
    reuptakeRate : Float;         // Current reuptake rate
    receptorOccupancy : Float;    // Fraction of receptors bound [0, 1]
    receptorSaturation : Float;   // Saturation level [0, 1]
    
    // Pharmacokinetic state
    halfLife : Float;
    decayConstant : Float;
    lastSynthesis : Nat;
    lastRelease : Nat;
    
    // Cross-coupling inputs
    totalCouplingInput : Float;   // Sum of all coupling effects
    
    // Energy
    synthesisEnergy : Float;      // Energy cost of synthesis
  };
  
  public type CrosstalkMatrixState = {
    // All 21 neurochemicals
    chemicals : [NeurochemicalState];
    
    // The 21×21 coupling matrix (flattened)
    couplingMatrix : [Float];
    
    // Aggregate metrics
    totalConcentration : Float;
    balanceIndex : Float;         // How balanced the system is [0, 1]
    excitationInhibitionRatio : Float;  // E/I balance
    stressLevel : Float;          // Stress chemical aggregate
    rewardLevel : Float;          // Reward chemical aggregate
    
    // Dynamics
    timeStep : Float;
    beatNum : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  func _abs(x : Float) : Float { if (x < 0.0) -x else x };
  
  func _exp(x : Float) : Float {
    let xc = _clamp(x, -20.0, 20.0);
    Float.exp(xc)
  };
  
  func _sqrt(x : Float) : Float {
    if (x <= 0.0) 0.0 else Float.sqrt(x)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PHARMACOKINETIC FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Michaelis-Menten kinetics: v = Vmax × [S] / (Km + [S])
  public func michaelisMenten(substrate : Float, vMax : Float, kM : Float) : Float {
    vMax * substrate / (kM + substrate)
  };
  
  // Hill equation for cooperative binding: B = Bmax × [C]^n / (Kd^n + [C]^n)
  public func hillBinding(conc : Float, bMax : Float, kD : Float, n : Float) : Float {
    let cn = Float.pow(_abs(conc) + 0.001, n);
    let kdn = Float.pow(kD, n);
    bMax * cn / (kdn + cn)
  };
  
  // Half-life decay: C(t) = C0 × e^(-k×t) where k = ln(2)/t_half
  public func halfLifeDecay(conc : Float, decayConstant : Float, dt : Float) : Float {
    conc * _exp(-decayConstant * dt)
  };
  
  // Reuptake rate with transporter saturation
  public func reuptakeRate(
    conc : Float,
    kReuptake : Float,
    transporterDensity : Float,
    maxReuptake : Float
  ) : Float {
    // Saturating transporter: rate = k × [C] × density × (1 - saturation)
    let saturation = conc / (conc + 1.0);  // Hyperbolic saturation
    kReuptake * conc * transporterDensity * (1.0 - saturation * 0.5)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COUPLING FUNCTION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Sigmoid coupling function: g(C) = tanh(C - 0.5) for nonlinear response
  public func couplingFunction(conc : Float) : Float {
    Float.tanh(conc - 0.5)
  };
  
  // Compute total coupling input to chemical i from all other chemicals
  public func computeCouplingInput(
    targetIdx : Nat,
    concentrations : [Float]
  ) : Float {
    var total : Float = 0.0;
    var j = 0;
    while (j < NUM_CHEMICALS) {
      if (j != targetIdx) {
        let coupling = getCoupling(targetIdx, j);
        let sourceConc = if (j < concentrations.size()) { concentrations[j] } else { 0.0 };
        total += coupling * couplingFunction(sourceConc);
      };
      j += 1;
    };
    total
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getChemicalName(idx : Nat) : Text {
    switch (idx) {
      case (0) { "Dopamine" };
      case (1) { "Serotonin" };
      case (2) { "Norepinephrine" };
      case (3) { "Acetylcholine" };
      case (4) { "GABA" };
      case (5) { "Glutamate" };
      case (6) { "Endorphin" };
      case (7) { "Oxytocin" };
      case (8) { "Cortisol" };
      case (9) { "Adrenaline" };
      case (10) { "Melatonin" };
      case (11) { "Histamine" };
      case (12) { "Substance P" };
      case (13) { "Adenosine" };
      case (14) { "Anandamide" };
      case (15) { "Dynorphin" };
      case (16) { "Vasopressin" };
      case (17) { "Neuropeptide Y" };
      case (18) { "Orexin" };
      case (19) { "BDNF" };
      case (20) { "NGF" };
      case (_) { "Unknown" };
    }
  };
  
  public func initNeurochemicalState(idx : Nat, currentBeat : Nat) : NeurochemicalState {
    let halfLifeParams = getHalfLife(idx);
    
    // Initial concentrations based on baseline levels
    let baseConc = switch (idx) {
      case (0) { 0.5 };   // DA
      case (1) { 0.6 };   // 5-HT
      case (2) { 0.4 };   // NE
      case (3) { 0.5 };   // ACh
      case (4) { 0.6 };   // GABA
      case (5) { 0.5 };   // Glu
      case (6) { 0.3 };   // Endorphin
      case (7) { 0.4 };   // OT
      case (8) { 0.3 };   // Cortisol (low baseline is healthy)
      case (9) { 0.2 };   // EPI (low baseline)
      case (10) { 0.3 };  // MEL (varies with time)
      case (11) { 0.4 };  // HA
      case (12) { 0.2 };  // SP (low baseline)
      case (13) { 0.4 };  // ADO
      case (14) { 0.3 };  // AEA
      case (15) { 0.2 };  // DYN (low is healthy)
      case (16) { 0.4 };  // AVP
      case (17) { 0.5 };  // NPY (resilience)
      case (18) { 0.4 };  // ORX
      case (19) { 0.5 };  // BDNF
      case (20) { 0.5 };  // NGF
      case (_) { 0.5 };
    };
    
    {
      index = idx;
      name = getChemicalName(idx);
      concentration = baseConc;
      synthesisRate = 0.0;
      releaseRate = 0.0;
      reuptakeRate = 0.0;
      receptorOccupancy = 0.0;
      receptorSaturation = 0.0;
      halfLife = halfLifeParams.halfLife;
      decayConstant = halfLifeParams.decayConstant;
      lastSynthesis = currentBeat;
      lastRelease = currentBeat;
      totalCouplingInput = 0.0;
      synthesisEnergy = 0.0;
    }
  };
  
  public func initCrosstalkMatrix(currentBeat : Nat) : CrosstalkMatrixState {
    // Initialize all 21 chemicals
    let chemicals = Array.tabulate<NeurochemicalState>(NUM_CHEMICALS, func(i) {
      initNeurochemicalState(i, currentBeat)
    });
    
    // Build the 21×21 coupling matrix (441 values)
    let matrix = Array.tabulate<Float>(MATRIX_SIZE, func(idx) {
      let i = idx / NUM_CHEMICALS;
      let j = idx % NUM_CHEMICALS;
      getCoupling(i, j)
    });
    
    {
      chemicals = chemicals;
      couplingMatrix = matrix;
      totalConcentration = 0.0;
      balanceIndex = 0.5;
      excitationInhibitionRatio = 1.0;
      stressLevel = 0.3;
      rewardLevel = 0.5;
      timeStep = 1.0;
      beatNum = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TICK UPDATE — SOLVE 441 COUPLED DIFFERENTIAL EQUATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func tickCrosstalkMatrix(
    state : CrosstalkMatrixState,
    externalInputs : [Float],     // External inputs to each chemical
    currentBeat : Nat
  ) : CrosstalkMatrixState {
    
    // Extract current concentrations
    let concentrations = Array.map<NeurochemicalState, Float>(
      state.chemicals,
      func(c) { c.concentration }
    );
    
    // Update each chemical
    let newChemicals = Array.tabulate<NeurochemicalState>(NUM_CHEMICALS, func(i) {
      let chem = state.chemicals[i];
      let synthParams = getSynthesisParams(i);
      let receptorParams = getReceptorParams(i);
      let reuptakeParams = getReuptakeParams(i);
      
      // 1. Compute coupling input from all other chemicals
      let couplingInput = computeCouplingInput(i, concentrations);
      
      // 2. External input
      let extInput = if (i < externalInputs.size()) { externalInputs[i] } else { 0.0 };
      
      // 3. Synthesis (Michaelis-Menten)
      let precursor = 1.0;  // Simplified: assume constant precursor
      let synthesis = michaelisMenten(precursor, synthParams.vMax, synthParams.kM);
      
      // 4. Reuptake
      let reuptake = reuptakeRate(
        chem.concentration,
        reuptakeParams.kReuptake,
        reuptakeParams.transporterDensity,
        reuptakeParams.maxReuptake
      );
      
      // 5. Half-life decay
      let decay = chem.concentration * chem.decayConstant * state.timeStep;
      
      // 6. Receptor binding (Hill equation)
      let binding = hillBinding(
        chem.concentration,
        receptorParams.bMax,
        receptorParams.kD,
        receptorParams.hillCoeff
      );
      let saturation = binding / receptorParams.bMax;
      
      // 7. Total change: dC/dt = synthesis - reuptake - decay + coupling + external
      let dC = (synthesis - reuptake - decay + couplingInput * 0.1 + extInput) * state.timeStep;
      
      // 8. Update concentration (clamp to sovereign floor)
      let newConc = _clamp(chem.concentration + dC, S0 * 0.1, 2.0);
      
      {
        index = chem.index;
        name = chem.name;
        concentration = newConc;
        synthesisRate = synthesis;
        releaseRate = synthesis * 0.8;  // ~80% of synthesis is released
        reuptakeRate = reuptake;
        receptorOccupancy = binding;
        receptorSaturation = saturation;
        halfLife = chem.halfLife;
        decayConstant = chem.decayConstant;
        lastSynthesis = if (synthesis > 0.01) { currentBeat } else { chem.lastSynthesis };
        lastRelease = currentBeat;
        totalCouplingInput = couplingInput;
        synthesisEnergy = synthesis * 0.1;
      }
    });
    
    // Compute aggregate metrics
    var totalConc : Float = 0.0;
    var stressSum : Float = 0.0;
    var rewardSum : Float = 0.0;
    var excitation : Float = 0.0;
    var inhibition : Float = 0.0;
    
    for (chem in newChemicals.vals()) {
      totalConc += chem.concentration;
      
      // Stress chemicals: Cortisol, Adrenaline, Dynorphin, Substance P
      if (chem.index == CORT or chem.index == EPI or chem.index == DYN or chem.index == SP) {
        stressSum += chem.concentration;
      };
      
      // Reward chemicals: Dopamine, Endorphin, Oxytocin, Anandamide
      if (chem.index == DA or chem.index == ENDORPHIN or chem.index == OT or chem.index == AEA) {
        rewardSum += chem.concentration;
      };
      
      // Excitation: Glutamate, Norepinephrine, Adrenaline, Orexin, Histamine
      if (chem.index == GLU or chem.index == NE or chem.index == EPI or chem.index == ORX or chem.index == HA) {
        excitation += chem.concentration;
      };
      
      // Inhibition: GABA, Serotonin, Melatonin, Adenosine
      if (chem.index == GABA or chem.index == SEROTONIN or chem.index == MEL or chem.index == ADO) {
        inhibition += chem.concentration;
      };
    };
    
    let eiRatio = if (inhibition > 0.01) { excitation / inhibition } else { 10.0 };
    
    // Balance index: closer to 1.0 E/I ratio = better balance
    let balance = 1.0 / (1.0 + _abs(eiRatio - 1.0));
    
    {
      chemicals = newChemicals;
      couplingMatrix = state.couplingMatrix;
      totalConcentration = totalConc;
      balanceIndex = balance;
      excitationInhibitionRatio = eiRatio;
      stressLevel = stressSum / 4.0;
      rewardLevel = rewardSum / 4.0;
      timeStep = state.timeStep;
      beatNum = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type CrosstalkDiagnostics = {
    overallBalance : Text;
    stressStatus : Text;
    rewardStatus : Text;
    eiRatio : Text;
    topChemical : Text;
    bottomChemical : Text;
    warnings : [Text];
  };
  
  public func diagnoseCrosstalk(state : CrosstalkMatrixState) : CrosstalkDiagnostics {
    let warnings = Buffer.Buffer<Text>(5);
    
    let balanceStatus = if (state.balanceIndex > 0.8) { "EXCELLENT balance" }
      else if (state.balanceIndex > 0.6) { "Good balance" }
      else if (state.balanceIndex > 0.4) { "Moderate imbalance" }
      else { "SEVERE imbalance" };
    
    let stressStatus = if (state.stressLevel > 0.7) { "HIGH STRESS — danger" }
      else if (state.stressLevel > 0.5) { "Elevated stress" }
      else if (state.stressLevel > 0.3) { "Moderate stress" }
      else { "Low stress — healthy" };
    
    let rewardStatus = if (state.rewardLevel > 0.7) { "HIGH reward — euphoria" }
      else if (state.rewardLevel > 0.5) { "Good reward" }
      else if (state.rewardLevel > 0.3) { "Low reward — anhedonia risk" }
      else { "VERY LOW reward — depression risk" };
    
    let eiStatus = if (state.excitationInhibitionRatio > 1.5) { "Hyperexcited — anxiety risk" }
      else if (state.excitationInhibitionRatio > 1.2) { "Slightly excited" }
      else if (state.excitationInhibitionRatio > 0.8) { "Balanced E/I" }
      else if (state.excitationInhibitionRatio > 0.5) { "Slightly inhibited" }
      else { "Hypo-aroused — depression risk" };
    
    // Find top and bottom chemicals
    var maxConc : Float = 0.0;
    var minConc : Float = 100.0;
    var topName = "";
    var bottomName = "";
    
    for (chem in state.chemicals.vals()) {
      if (chem.concentration > maxConc) {
        maxConc := chem.concentration;
        topName := chem.name;
      };
      if (chem.concentration < minConc) {
        minConc := chem.concentration;
        bottomName := chem.name;
      };
    };
    
    // Generate warnings
    if (state.stressLevel > 0.6) {
      warnings.add("High stress chemicals — activate calming protocols");
    };
    if (state.rewardLevel < 0.3) {
      warnings.add("Low reward chemicals — risk of anhedonia");
    };
    if (state.excitationInhibitionRatio > 1.5) {
      warnings.add("E/I imbalance toward excitation — anxiety/seizure risk");
    };
    if (state.excitationInhibitionRatio < 0.5) {
      warnings.add("E/I imbalance toward inhibition — depression/sedation risk");
    };
    
    // Check specific dangerous levels
    for (chem in state.chemicals.vals()) {
      if (chem.index == CORT and chem.concentration > 0.8) {
        warnings.add("CORTISOL CRITICAL — chronic stress damage");
      };
      if (chem.index == GLU and chem.concentration > 1.5) {
        warnings.add("GLUTAMATE EXCESS — excitotoxicity risk");
      };
      if (chem.index == SEROTONIN and chem.concentration < 0.3) {
        warnings.add("SEROTONIN LOW — depression risk");
      };
      if (chem.index == BDNF and chem.concentration < 0.3) {
        warnings.add("BDNF LOW — neuroplasticity impaired");
      };
    };
    
    {
      overallBalance = balanceStatus;
      stressStatus = stressStatus;
      rewardStatus = rewardStatus;
      eiRatio = eiStatus;
      topChemical = topName # " (" # Float.toText(maxConc) # ")";
      bottomChemical = bottomName # " (" # Float.toText(minConc) # ")";
      warnings = Buffer.toArray(warnings);
    }
  };

}
