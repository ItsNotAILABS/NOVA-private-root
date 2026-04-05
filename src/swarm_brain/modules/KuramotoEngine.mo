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
// NEUROEMERGENCE CORE — KURAMOTO ENGINE
// Phase oscillator dynamics for neural synchronization
// Kuramoto model: dθᵢ/dt = ωᵢ + K/N Σⱼ sin(θⱼ - θᵢ)
// Animal-frequency extension: 18-organ phase coupling
// Global order parameter r = |1/N Σ exp(i·θⱼ)| → coherenceC
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Array "mo:base/Array";

module {

  // ── Types ─────────────────────────────────────────────────────
  public type Oscillator = {
    phase      : Float;  // θ ∈ [0, 2π)
    naturalFreq: Float;  // ωᵢ (Hz equivalent)
    coupling   : Float;  // local coupling strength
    amplitude  : Float;  // 0-1 signal strength
  };

  public type KuramotoState = {
    oscillators     : [Oscillator];  // N oscillators
    globalCoupling  : Float;         // K
    orderParam      : Float;         // r ∈ [0,1]
    meanPhase       : Float;         // ψ = arg(Σ exp(i·θⱼ))
    beatNum         : Nat;
    syncHistory     : [Float];       // last 100 r values
    criticalK       : Float;         // phase transition threshold
  };

  // ── Constants ─────────────────────────────────────────────────
  let PI     : Float = 3.14159265358979323846;
  let TWO_PI : Float = 6.28318530717958647692;

  // 18-organ natural frequencies (Hz-equivalent, from swarm_organism spec)
  public let ORGAN_FREQS : [Float] = [
    0.08,  // heart
    0.05,  // lungs
    0.12,  // brain
    0.03,  // liver
    0.02,  // kidneys
    0.10,  // gut
    0.07,  // spleen
    0.04,  // pancreas
    0.15,  // thyroid
    0.06,  // adrenals
    0.09,  // thymus
    0.11,  // skin
    0.08,  // marrow
    0.04,  // lymph
    0.03,  // gonads
    0.05,  // eyes
    0.02,  // ears
    0.13   // spine
  ];

  // ── Clamp helper ──────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── Wrap phase to [0, 2π) ─────────────────────────────────────
  func wrapPhase(theta: Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TWO_PI };
    while (t >= TWO_PI) { t -= TWO_PI };
    t
  };

  // ── Order parameter (global synchronization measure) ──────────
  // r = |1/N Σⱼ exp(i·θⱼ)| = √((Σcos θⱼ)² + (Σsin θⱼ)²) / N
  // ψ = atan2(Σsin θⱼ, Σcos θⱼ)
  public func computeOrderParameter(oscs: [Oscillator]) : (Float, Float) {
    let n = oscs.size();
    if (n == 0) { return (0.0, 0.0) };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (o in oscs.vals()) {
      sumCos += Float.cos(o.phase) * o.amplitude;
      sumSin += Float.sin(o.phase) * o.amplitude;
    };
    let nf = Float.fromInt(n);
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf;
    let psi = Float.arctan2(sumSin, sumCos);
    (_clamp(r, 0.0, 1.0), wrapPhase(psi))
  };

  // ── Single oscillator update ──────────────────────────────────
  // dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  // Simplified: dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ)
  func updateOscillator(
    osc: Oscillator, r: Float, meanPhase: Float, globalK: Float, dt: Float
  ) : Oscillator {
    let coupling = osc.coupling * globalK * r * Float.sin(meanPhase - osc.phase);
    let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
    {
      phase = newPhase;
      naturalFreq = osc.naturalFreq;
      coupling = osc.coupling;
      amplitude = osc.amplitude;
    }
  };

  // ── Full beat update ──────────────────────────────────────────
  public func beatKuramoto(state: KuramotoState, dt: Float) : KuramotoState {
    let (r, psi) = computeOrderParameter(state.oscillators);
    let newOscs = Array.map<Oscillator, Oscillator>(
      state.oscillators,
      func(o) { updateOscillator(o, r, psi, state.globalCoupling, dt) }
    );
    // Update sync history (circular buffer of 100)
    let newHistory = if (state.syncHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i) { state.syncHistory[i + 1] });
      Array.append<Float>(tail, [r])
    } else {
      Array.append<Float>(state.syncHistory, [r])
    };
    {
      oscillators    = newOscs;
      globalCoupling = state.globalCoupling;
      orderParam     = r;
      meanPhase      = psi;
      beatNum        = state.beatNum + 1;
      syncHistory    = newHistory;
      criticalK      = state.criticalK;
    }
  };

  // ── Adaptive coupling (organism learns optimal K) ─────────────
  // If r < target → increase K; if r > target → decrease K
  public func adaptCoupling(
    state: KuramotoState, targetR: Float, adaptRate: Float
  ) : KuramotoState {
    let error = targetR - state.orderParam;
    let newK = _clamp(state.globalCoupling + error * adaptRate, 0.0, 10.0);
    {
      oscillators    = state.oscillators;
      globalCoupling = newK;
      orderParam     = state.orderParam;
      meanPhase      = state.meanPhase;
      beatNum        = state.beatNum;
      syncHistory    = state.syncHistory;
      criticalK      = state.criticalK;
    }
  };

  // ── Phase reset (triggered by ARES or high-threat events) ─────
  public func phaseReset(state: KuramotoState, targetPhase: Float) : KuramotoState {
    let resetOscs = Array.map<Oscillator, Oscillator>(
      state.oscillators,
      func(o) { { phase = targetPhase; naturalFreq = o.naturalFreq; coupling = o.coupling; amplitude = o.amplitude } }
    );
    {
      oscillators    = resetOscs;
      globalCoupling = state.globalCoupling;
      orderParam     = 1.0;  // Perfect sync after reset
      meanPhase      = targetPhase;
      beatNum        = state.beatNum;
      syncHistory    = state.syncHistory;
      criticalK      = state.criticalK;
    }
  };

  // ── Synchronization variance ──────────────────────────────────
  // σ² = (1/N) Σ (θᵢ - ψ)²
  public func syncVariance(state: KuramotoState) : Float {
    let n = state.oscillators.size();
    if (n == 0) { return 0.0 };
    var sumSq : Float = 0.0;
    for (o in state.oscillators.vals()) {
      let diff = wrapPhase(o.phase - state.meanPhase);
      let centered = if (diff > PI) { diff - TWO_PI } else { diff };
      sumSq += centered * centered;
    };
    sumSq / Float.fromInt(n)
  };

  // ── Critical coupling estimate ────────────────────────────────
  // Kc ≈ 2 / (π · g(0)) where g(ω) is frequency distribution density at ω=0
  // For uniform distribution [ω_min, ω_max]: Kc ≈ 2(ω_max - ω_min) / π
  public func estimateCriticalK(oscs: [Oscillator]) : Float {
    if (oscs.size() < 2) { return 1.0 };
    var minW : Float = oscs[0].naturalFreq;
    var maxW : Float = oscs[0].naturalFreq;
    for (o in oscs.vals()) {
      if (o.naturalFreq < minW) { minW := o.naturalFreq };
      if (o.naturalFreq > maxW) { maxW := o.naturalFreq };
    };
    2.0 * (maxW - minW) / PI
  };

  // ── Init 18-organ oscillators ─────────────────────────────────
  public func initOrganOscillators() : [Oscillator] {
    Array.tabulate<Oscillator>(18, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / 18.0;  // evenly distributed
        naturalFreq = ORGAN_FREQS[i];
        coupling = 1.0;
        amplitude = 1.0;
      }
    })
  };

  // ── Init full state ───────────────────────────────────────────
  public func initKuramoto() : KuramotoState {
    let oscs = initOrganOscillators();
    let kc = estimateCriticalK(oscs);
    {
      oscillators    = oscs;
      globalCoupling = kc * 1.5;  // Start above critical
      orderParam     = 0.5;
      meanPhase      = 0.0;
      beatNum        = 0;
      syncHistory    = [];
      criticalK      = kc;
    }
  };

  // ── Animal Kuramoto peak detection ────────────────────────────
  // Returns true if r > 0.85 for 10+ consecutive beats
  public func isKuramotoPeak(state: KuramotoState) : Bool {
    if (state.syncHistory.size() < 10) { return false };
    let start = state.syncHistory.size() - 10;
    var allHigh = true;
    for (i in Array.keys(state.syncHistory)) {
      if (i >= start and state.syncHistory[i] < 0.85) {
        allHigh := false;
      };
    };
    allHigh
  };

  // ── Coherence-to-Kuramoto mapping ─────────────────────────────
  // Maps organism coherenceC to expected r value
  public func coherenceToR(coherenceC: Float) : Float {
    // Sigmoid mapping: r = 1 / (1 + exp(-10*(C - 0.5)))
    1.0 / (1.0 + Float.exp(-10.0 * (coherenceC - 0.5)))
  };

  // ============================================================
  // 18×18 ORGAN COUPLING MATRIX — FULL EXPLICIT INTERACTIONS
  // Every organ affects every other organ's phase dynamics
  // M[i][j] = coupling strength from organ j to organ i
  // Positive = synchronizing, Negative = desynchronizing
  // ALL 324 INTERACTIONS EXPLICITLY DEFINED
  // ============================================================

  // Organ indices for reference:
  // 0: heart, 1: lungs, 2: brain, 3: liver, 4: kidneys, 5: gut,
  // 6: spleen, 7: pancreas, 8: thyroid, 9: adrenals, 10: thymus,
  // 11: skin, 12: marrow, 13: lymph, 14: gonads, 15: eyes, 16: ears, 17: spine

  // ROW 0: How each organ couples to HEART
  // Heart is the master oscillator — strong incoming coupling
  public let COUPLING_HEART : [Float] = [
    0.000,   // 0: heart → heart (self)
    0.850,   // 1: lungs → heart (cardiopulmonary coupling)
    0.750,   // 2: brain → heart (autonomic control)
    0.300,   // 3: liver → heart (metabolic demand)
    0.350,   // 4: kidneys → heart (fluid balance, renin)
    0.400,   // 5: gut → heart (vagal tone)
    0.200,   // 6: spleen → heart (blood reservoir)
    0.250,   // 7: pancreas → heart (insulin-cardiac)
    0.600,   // 8: thyroid → heart (metabolic rate)
    0.700,   // 9: adrenals → heart (catecholamines)
    0.150,   // 10: thymus → heart (immune-cardiac)
    0.200,   // 11: skin → heart (thermoregulation)
    0.250,   // 12: marrow → heart (blood production)
    0.180,   // 13: lymph → heart (fluid return)
    0.350,   // 14: gonads → heart (hormonal)
    0.300,   // 15: eyes → heart (visual stress response)
    0.280,   // 16: ears → heart (auditory startle)
    0.450    // 17: spine → heart (autonomic relay)
  ];

  // ROW 1: How each organ couples to LUNGS
  // Lungs couple strongly to heart and brain
  public let COUPLING_LUNGS : [Float] = [
    0.900,   // 0: heart → lungs (cardiopulmonary)
    0.000,   // 1: lungs → lungs (self)
    0.800,   // 2: brain → lungs (respiratory center)
    0.200,   // 3: liver → lungs (metabolic CO2)
    0.150,   // 4: kidneys → lungs (acid-base)
    0.250,   // 5: gut → lungs (diaphragm pressure)
    0.100,   // 6: spleen → lungs (blood oxygenation)
    0.150,   // 7: pancreas → lungs (metabolic)
    0.400,   // 8: thyroid → lungs (metabolic rate)
    0.550,   // 9: adrenals → lungs (bronchodilation)
    0.120,   // 10: thymus → lungs (immune-respiratory)
    0.180,   // 11: skin → lungs (gas exchange)
    0.200,   // 12: marrow → lungs (RBC production)
    0.150,   // 13: lymph → lungs (fluid drainage)
    0.200,   // 14: gonads → lungs (hormonal)
    0.200,   // 15: eyes → lungs (visual-respiratory)
    0.180,   // 16: ears → lungs (vestibular-respiratory)
    0.500    // 17: spine → lungs (phrenic nerve)
  ];

  // ROW 2: How each organ couples to BRAIN
  // Brain is modulated by everything — integration center
  public let COUPLING_BRAIN : [Float] = [
    0.650,   // 0: heart → brain (cerebral perfusion)
    0.700,   // 1: lungs → brain (oxygen supply)
    0.000,   // 2: brain → brain (self)
    0.400,   // 3: liver → brain (glucose, ammonia)
    0.300,   // 4: kidneys → brain (uremic toxins)
    0.500,   // 5: gut → brain (gut-brain axis)
    0.150,   // 6: spleen → brain (immune signaling)
    0.450,   // 7: pancreas → brain (glucose, insulin)
    0.550,   // 8: thyroid → brain (metabolic, mood)
    0.600,   // 9: adrenals → brain (cortisol, catecholamines)
    0.200,   // 10: thymus → brain (immune-neuro)
    0.250,   // 11: skin → brain (sensory)
    0.150,   // 12: marrow → brain (blood supply)
    0.180,   // 13: lymph → brain (glymphatic)
    0.400,   // 14: gonads → brain (sex hormones)
    0.700,   // 15: eyes → brain (visual input)
    0.650,   // 16: ears → brain (auditory input)
    0.750    // 17: spine → brain (sensory relay)
  ];

  // ROW 3: How each organ couples to LIVER
  // Liver responds to metabolic demands
  public let COUPLING_LIVER : [Float] = [
    0.350,   // 0: heart → liver (portal circulation)
    0.250,   // 1: lungs → liver (oxygen)
    0.450,   // 2: brain → liver (autonomic)
    0.000,   // 3: liver → liver (self)
    0.300,   // 4: kidneys → liver (metabolic coupling)
    0.600,   // 5: gut → liver (portal nutrients)
    0.350,   // 6: spleen → liver (splenic vein)
    0.500,   // 7: pancreas → liver (insulin, glucagon)
    0.400,   // 8: thyroid → liver (metabolic rate)
    0.450,   // 9: adrenals → liver (cortisol, glycogenolysis)
    0.100,   // 10: thymus → liver (immune)
    0.150,   // 11: skin → liver (vitamin D)
    0.200,   // 12: marrow → liver (RBC recycling)
    0.180,   // 13: lymph → liver (immune)
    0.350,   // 14: gonads → liver (sex hormone metabolism)
    0.100,   // 15: eyes → liver (circadian)
    0.080,   // 16: ears → liver (minimal)
    0.200    // 17: spine → liver (autonomic)
  ];

  // ROW 4: How each organ couples to KIDNEYS
  // Kidneys regulate fluid and electrolytes
  public let COUPLING_KIDNEYS : [Float] = [
    0.500,   // 0: heart → kidneys (renal perfusion)
    0.200,   // 1: lungs → kidneys (acid-base)
    0.400,   // 2: brain → kidneys (ADH, autonomic)
    0.350,   // 3: liver → kidneys (urea production)
    0.000,   // 4: kidneys → kidneys (self)
    0.200,   // 5: gut → kidneys (fluid absorption)
    0.150,   // 6: spleen → kidneys (blood filtering)
    0.250,   // 7: pancreas → kidneys (glucose handling)
    0.350,   // 8: thyroid → kidneys (metabolic rate)
    0.550,   // 9: adrenals → kidneys (aldosterone)
    0.100,   // 10: thymus → kidneys (immune)
    0.250,   // 11: skin → kidneys (fluid loss)
    0.180,   // 12: marrow → kidneys (EPO response)
    0.200,   // 13: lymph → kidneys (fluid balance)
    0.300,   // 14: gonads → kidneys (hormonal)
    0.100,   // 15: eyes → kidneys (minimal)
    0.080,   // 16: ears → kidneys (minimal)
    0.200    // 17: spine → kidneys (autonomic)
  ];

  // ROW 5: How each organ couples to GUT
  // Gut responds to many systems — enteric nervous system
  public let COUPLING_GUT : [Float] = [
    0.350,   // 0: heart → gut (splanchnic circulation)
    0.200,   // 1: lungs → gut (oxygen)
    0.700,   // 2: brain → gut (vagus, enteric brain)
    0.450,   // 3: liver → gut (bile)
    0.200,   // 4: kidneys → gut (fluid balance)
    0.000,   // 5: gut → gut (self)
    0.200,   // 6: spleen → gut (immune)
    0.500,   // 7: pancreas → gut (digestive enzymes)
    0.300,   // 8: thyroid → gut (motility)
    0.450,   // 9: adrenals → gut (stress response)
    0.250,   // 10: thymus → gut (GALT)
    0.150,   // 11: skin → gut (barrier)
    0.100,   // 12: marrow → gut (immune cells)
    0.300,   // 13: lymph → gut (lacteals)
    0.200,   // 14: gonads → gut (hormonal)
    0.150,   // 15: eyes → gut (cephalic phase)
    0.100,   // 16: ears → gut (minimal)
    0.400    // 17: spine → gut (autonomic, ENS)
  ];

  // ROW 6: How each organ couples to SPLEEN
  // Spleen responds to immune and blood needs
  public let COUPLING_SPLEEN : [Float] = [
    0.400,   // 0: heart → spleen (splenic circulation)
    0.200,   // 1: lungs → spleen (oxygen)
    0.300,   // 2: brain → spleen (autonomic)
    0.350,   // 3: liver → spleen (portal system)
    0.200,   // 4: kidneys → spleen (fluid)
    0.300,   // 5: gut → spleen (immune)
    0.000,   // 6: spleen → spleen (self)
    0.150,   // 7: pancreas → spleen (proximity)
    0.250,   // 8: thyroid → spleen (metabolic)
    0.400,   // 9: adrenals → spleen (stress, contraction)
    0.450,   // 10: thymus → spleen (immune synergy)
    0.150,   // 11: skin → spleen (immune)
    0.350,   // 12: marrow → spleen (blood cells)
    0.400,   // 13: lymph → spleen (immune)
    0.150,   // 14: gonads → spleen (hormonal)
    0.080,   // 15: eyes → spleen (minimal)
    0.080,   // 16: ears → spleen (minimal)
    0.200    // 17: spine → spleen (autonomic)
  ];

  // ROW 7: How each organ couples to PANCREAS
  // Pancreas responds to metabolic and digestive needs
  public let COUPLING_PANCREAS : [Float] = [
    0.300,   // 0: heart → pancreas (perfusion)
    0.200,   // 1: lungs → pancreas (oxygen)
    0.450,   // 2: brain → pancreas (autonomic, glucose sensing)
    0.400,   // 3: liver → pancreas (glucose counter-regulation)
    0.250,   // 4: kidneys → pancreas (glucose handling)
    0.550,   // 5: gut → pancreas (incretins)
    0.200,   // 6: spleen → pancreas (proximity)
    0.000,   // 7: pancreas → pancreas (self)
    0.350,   // 8: thyroid → pancreas (metabolic rate)
    0.450,   // 9: adrenals → pancreas (stress hormones)
    0.100,   // 10: thymus → pancreas (autoimmune)
    0.100,   // 11: skin → pancreas (minimal)
    0.100,   // 12: marrow → pancreas (minimal)
    0.120,   // 13: lymph → pancreas (immune)
    0.200,   // 14: gonads → pancreas (hormonal)
    0.100,   // 15: eyes → pancreas (circadian)
    0.080,   // 16: ears → pancreas (minimal)
    0.250    // 17: spine → pancreas (autonomic)
  ];

  // ROW 8: How each organ couples to THYROID
  // Thyroid is the metabolic pacemaker
  public let COUPLING_THYROID : [Float] = [
    0.350,   // 0: heart → thyroid (perfusion)
    0.200,   // 1: lungs → thyroid (oxygen)
    0.700,   // 2: brain → thyroid (TSH, TRH)
    0.300,   // 3: liver → thyroid (T4→T3 conversion)
    0.250,   // 4: kidneys → thyroid (iodine)
    0.200,   // 5: gut → thyroid (iodine absorption)
    0.100,   // 6: spleen → thyroid (minimal)
    0.150,   // 7: pancreas → thyroid (metabolic)
    0.000,   // 8: thyroid → thyroid (self)
    0.400,   // 9: adrenals → thyroid (stress-thyroid axis)
    0.200,   // 10: thymus → thyroid (autoimmune)
    0.150,   // 11: skin → thyroid (temperature)
    0.100,   // 12: marrow → thyroid (minimal)
    0.120,   // 13: lymph → thyroid (autoimmune)
    0.350,   // 14: gonads → thyroid (reproductive-thyroid)
    0.150,   // 15: eyes → thyroid (Graves')
    0.080,   // 16: ears → thyroid (minimal)
    0.200    // 17: spine → thyroid (autonomic)
  ];

  // ROW 9: How each organ couples to ADRENALS
  // Adrenals are the stress response center
  public let COUPLING_ADRENALS : [Float] = [
    0.400,   // 0: heart → adrenals (perfusion)
    0.250,   // 1: lungs → adrenals (oxygen)
    0.850,   // 2: brain → adrenals (HPA axis, ACTH)
    0.300,   // 3: liver → adrenals (cortisol metabolism)
    0.350,   // 4: kidneys → adrenals (renin)
    0.200,   // 5: gut → adrenals (stress)
    0.150,   // 6: spleen → adrenals (immune)
    0.200,   // 7: pancreas → adrenals (glucose)
    0.400,   // 8: thyroid → adrenals (metabolic stress)
    0.000,   // 9: adrenals → adrenals (self)
    0.200,   // 10: thymus → adrenals (immune-stress)
    0.250,   // 11: skin → adrenals (pain, temperature)
    0.100,   // 12: marrow → adrenals (minimal)
    0.150,   // 13: lymph → adrenals (immune)
    0.350,   // 14: gonads → adrenals (DHEA)
    0.400,   // 15: eyes → adrenals (visual stress)
    0.350,   // 16: ears → adrenals (auditory stress)
    0.500    // 17: spine → adrenals (pain, autonomic)
  ];

  // ROW 10: How each organ couples to THYMUS
  // Thymus is the immune programming center
  public let COUPLING_THYMUS : [Float] = [
    0.250,   // 0: heart → thymus (perfusion)
    0.200,   // 1: lungs → thymus (respiratory immune)
    0.350,   // 2: brain → thymus (neuro-immune)
    0.200,   // 3: liver → thymus (immune)
    0.150,   // 4: kidneys → thymus (minimal)
    0.350,   // 5: gut → thymus (GALT)
    0.450,   // 6: spleen → thymus (immune synergy)
    0.100,   // 7: pancreas → thymus (autoimmune)
    0.300,   // 8: thyroid → thymus (autoimmune)
    0.400,   // 9: adrenals → thymus (cortisol suppression)
    0.000,   // 10: thymus → thymus (self)
    0.300,   // 11: skin → thymus (barrier immune)
    0.450,   // 12: marrow → thymus (T-cell precursors)
    0.500,   // 13: lymph → thymus (lymphatic immune)
    0.250,   // 14: gonads → thymus (sex hormone immune)
    0.100,   // 15: eyes → thymus (minimal)
    0.080,   // 16: ears → thymus (minimal)
    0.150    // 17: spine → thymus (autonomic)
  ];

  // ROW 11: How each organ couples to SKIN
  // Skin is the barrier and sensory organ
  public let COUPLING_SKIN : [Float] = [
    0.350,   // 0: heart → skin (perfusion, thermoregulation)
    0.250,   // 1: lungs → skin (gas exchange)
    0.400,   // 2: brain → skin (autonomic, sensory)
    0.200,   // 3: liver → skin (detox)
    0.300,   // 4: kidneys → skin (fluid balance)
    0.150,   // 5: gut → skin (gut-skin axis)
    0.150,   // 6: spleen → skin (immune)
    0.150,   // 7: pancreas → skin (wound healing)
    0.350,   // 8: thyroid → skin (metabolic)
    0.400,   // 9: adrenals → skin (stress, sweating)
    0.250,   // 10: thymus → skin (immune)
    0.000,   // 11: skin → skin (self)
    0.150,   // 12: marrow → skin (immune cells)
    0.250,   // 13: lymph → skin (drainage)
    0.300,   // 14: gonads → skin (sex hormones, sebum)
    0.200,   // 15: eyes → skin (UV response)
    0.150,   // 16: ears → skin (sensory)
    0.350    // 17: spine → skin (sensory relay)
  ];

  // ROW 12: How each organ couples to MARROW
  // Marrow produces blood cells
  public let COUPLING_MARROW : [Float] = [
    0.400,   // 0: heart → marrow (perfusion)
    0.300,   // 1: lungs → marrow (oxygen demand)
    0.250,   // 2: brain → marrow (autonomic)
    0.350,   // 3: liver → marrow (iron, EPO clearance)
    0.500,   // 4: kidneys → marrow (EPO production)
    0.150,   // 5: gut → marrow (B12, iron)
    0.400,   // 6: spleen → marrow (blood storage)
    0.100,   // 7: pancreas → marrow (minimal)
    0.300,   // 8: thyroid → marrow (metabolic)
    0.350,   // 9: adrenals → marrow (stress response)
    0.400,   // 10: thymus → marrow (T-cell maturation)
    0.150,   // 11: skin → marrow (minimal)
    0.000,   // 12: marrow → marrow (self)
    0.350,   // 13: lymph → marrow (immune)
    0.250,   // 14: gonads → marrow (hormonal)
    0.080,   // 15: eyes → marrow (minimal)
    0.080,   // 16: ears → marrow (minimal)
    0.200    // 17: spine → marrow (proximity)
  ];

  // ROW 13: How each organ couples to LYMPH
  // Lymphatic system is immune and fluid transport
  public let COUPLING_LYMPH : [Float] = [
    0.350,   // 0: heart → lymph (fluid return)
    0.250,   // 1: lungs → lymph (respiratory immune)
    0.300,   // 2: brain → lymph (glymphatic)
    0.300,   // 3: liver → lymph (hepatic lymph)
    0.350,   // 4: kidneys → lymph (fluid balance)
    0.400,   // 5: gut → lymph (lacteals)
    0.450,   // 6: spleen → lymph (immune synergy)
    0.150,   // 7: pancreas → lymph (drainage)
    0.200,   // 8: thyroid → lymph (drainage)
    0.300,   // 9: adrenals → lymph (stress immune)
    0.500,   // 10: thymus → lymph (lymphocyte traffic)
    0.350,   // 11: skin → lymph (dermal lymphatics)
    0.400,   // 12: marrow → lymph (lymphocyte production)
    0.000,   // 13: lymph → lymph (self)
    0.200,   // 14: gonads → lymph (drainage)
    0.100,   // 15: eyes → lymph (minimal)
    0.100,   // 16: ears → lymph (minimal)
    0.200    // 17: spine → lymph (CSF-lymph)
  ];

  // ROW 14: How each organ couples to GONADS
  // Gonads respond to hormonal and reproductive signals
  public let COUPLING_GONADS : [Float] = [
    0.300,   // 0: heart → gonads (perfusion)
    0.150,   // 1: lungs → gonads (oxygen)
    0.750,   // 2: brain → gonads (HPG axis)
    0.350,   // 3: liver → gonads (SHBG)
    0.200,   // 4: kidneys → gonads (minimal)
    0.150,   // 5: gut → gonads (gut-gonad axis)
    0.100,   // 6: spleen → gonads (immune)
    0.200,   // 7: pancreas → gonads (insulin-reproductive)
    0.450,   // 8: thyroid → gonads (metabolic-reproductive)
    0.500,   // 9: adrenals → gonads (DHEA)
    0.200,   // 10: thymus → gonads (immune-reproductive)
    0.200,   // 11: skin → gonads (pheromones)
    0.150,   // 12: marrow → gonads (minimal)
    0.150,   // 13: lymph → gonads (drainage)
    0.000,   // 14: gonads → gonads (self)
    0.250,   // 15: eyes → gonads (light-reproductive)
    0.150,   // 16: ears → gonads (social-reproductive)
    0.200    // 17: spine → gonads (autonomic)
  ];

  // ROW 15: How each organ couples to EYES
  // Eyes are visual input and circadian synchronization
  public let COUPLING_EYES : [Float] = [
    0.400,   // 0: heart → eyes (perfusion)
    0.200,   // 1: lungs → eyes (oxygen)
    0.850,   // 2: brain → eyes (visual cortex, circadian)
    0.150,   // 3: liver → eyes (vitamin A)
    0.150,   // 4: kidneys → eyes (fluid)
    0.100,   // 5: gut → eyes (nutrients)
    0.080,   // 6: spleen → eyes (minimal)
    0.150,   // 7: pancreas → eyes (diabetic)
    0.300,   // 8: thyroid → eyes (Graves')
    0.350,   // 9: adrenals → eyes (stress, pupil)
    0.100,   // 10: thymus → eyes (autoimmune)
    0.150,   // 11: skin → eyes (UV response)
    0.080,   // 12: marrow → eyes (minimal)
    0.100,   // 13: lymph → eyes (drainage)
    0.200,   // 14: gonads → eyes (hormonal)
    0.000,   // 15: eyes → eyes (self)
    0.350,   // 16: ears → eyes (audiovisual integration)
    0.300    // 17: spine → eyes (oculomotor)
  ];

  // ROW 16: How each organ couples to EARS
  // Ears are auditory and vestibular input
  public let COUPLING_EARS : [Float] = [
    0.350,   // 0: heart → ears (perfusion)
    0.200,   // 1: lungs → ears (oxygen)
    0.800,   // 2: brain → ears (auditory cortex)
    0.100,   // 3: liver → ears (minimal)
    0.150,   // 4: kidneys → ears (electrolytes, ototoxicity)
    0.100,   // 5: gut → ears (minimal)
    0.080,   // 6: spleen → ears (minimal)
    0.100,   // 7: pancreas → ears (minimal)
    0.250,   // 8: thyroid → ears (metabolic)
    0.350,   // 9: adrenals → ears (stress, tinnitus)
    0.100,   // 10: thymus → ears (autoimmune)
    0.150,   // 11: skin → ears (sensory)
    0.080,   // 12: marrow → ears (minimal)
    0.100,   // 13: lymph → ears (endolymph)
    0.150,   // 14: gonads → ears (hormonal)
    0.400,   // 15: eyes → ears (audiovisual integration)
    0.000,   // 16: ears → ears (self)
    0.350    // 17: spine → ears (vestibular-spinal)
  ];

  // ROW 17: How each organ couples to SPINE
  // Spine is the autonomic and sensory relay
  public let COUPLING_SPINE : [Float] = [
    0.450,   // 0: heart → spine (autonomic feedback)
    0.400,   // 1: lungs → spine (respiratory reflex)
    0.900,   // 2: brain → spine (motor, sensory)
    0.200,   // 3: liver → spine (metabolic)
    0.200,   // 4: kidneys → spine (autonomic)
    0.350,   // 5: gut → spine (ENS relay)
    0.150,   // 6: spleen → spine (autonomic)
    0.200,   // 7: pancreas → spine (autonomic)
    0.250,   // 8: thyroid → spine (metabolic)
    0.450,   // 9: adrenals → spine (stress, catecholamines)
    0.150,   // 10: thymus → spine (immune)
    0.400,   // 11: skin → spine (sensory input)
    0.250,   // 12: marrow → spine (proximity)
    0.200,   // 13: lymph → spine (CSF)
    0.200,   // 14: gonads → spine (autonomic)
    0.350,   // 15: eyes → spine (visual-motor)
    0.300,   // 16: ears → spine (vestibular-spinal)
    0.000    // 17: spine → spine (self)
  ];

  // Full 18×18 coupling matrix as 2D array
  public let COUPLING_MATRIX : [[Float]] = [
    COUPLING_HEART,
    COUPLING_LUNGS,
    COUPLING_BRAIN,
    COUPLING_LIVER,
    COUPLING_KIDNEYS,
    COUPLING_GUT,
    COUPLING_SPLEEN,
    COUPLING_PANCREAS,
    COUPLING_THYROID,
    COUPLING_ADRENALS,
    COUPLING_THYMUS,
    COUPLING_SKIN,
    COUPLING_MARROW,
    COUPLING_LYMPH,
    COUPLING_GONADS,
    COUPLING_EYES,
    COUPLING_EARS,
    COUPLING_SPINE
  ];

  // ============================================================
  // ENHANCED OSCILLATOR UPDATE WITH FULL COUPLING MATRIX
  // ============================================================

  // Update oscillator using full coupling matrix
  // dθᵢ/dt = ωᵢ + Σⱼ K_ij × sin(θⱼ - θᵢ)
  func updateOscillatorWithMatrix(
    osc: Oscillator, 
    allOscs: [Oscillator],
    orgIndex: Nat,
    globalK: Float, 
    dt: Float
  ) : Oscillator {
    var couplingSum : Float = 0.0;
    
    // Sum coupling contributions from all other oscillators
    var j = 0;
    while (j < allOscs.size()) {
      if (j != orgIndex) {
        let couplingStrength = if (orgIndex < 18 and j < 18) {
          COUPLING_MATRIX[orgIndex][j]
        } else { 0.5 };
        
        couplingSum += couplingStrength * Float.sin(allOscs[j].phase - osc.phase);
      };
      j += 1;
    };
    
    // Scale by global coupling and amplitude
    couplingSum := globalK * couplingSum * osc.amplitude / Float.fromInt(allOscs.size());
    
    // Update phase
    let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + couplingSum) * dt);
    
    {
      phase = newPhase;
      naturalFreq = osc.naturalFreq;
      coupling = osc.coupling;
      amplitude = osc.amplitude;
    }
  };

  // Full beat update with coupling matrix
  public func beatKuramotoWithMatrix(state: KuramotoState, dt: Float) : KuramotoState {
    // First compute order parameter
    let (r, psi) = computeOrderParameter(state.oscillators);
    
    // Update each oscillator using full coupling matrix
    let newOscs = Array.tabulate<Oscillator>(state.oscillators.size(), func(i) {
      updateOscillatorWithMatrix(
        state.oscillators[i],
        state.oscillators,
        i,
        state.globalCoupling,
        dt
      )
    });
    
    // Update sync history (circular buffer of 100)
    let newHistory = if (state.syncHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i) { state.syncHistory[i + 1] });
      Array.append<Float>(tail, [r])
    } else {
      Array.append<Float>(state.syncHistory, [r])
    };
    
    {
      oscillators    = newOscs;
      globalCoupling = state.globalCoupling;
      orderParam     = r;
      meanPhase      = psi;
      beatNum        = state.beatNum + 1;
      syncHistory    = newHistory;
      criticalK      = state.criticalK;
    }
  };

  // ============================================================
  // FREQUENCY TIER DYNAMICS — SILVER → GOLD → PLATINUM → DIAMOND
  // ============================================================

  // NOVA frequency tiers based on coherence
  public let FREQ_SILVER   : Float = 2.75;   // Baseline sovereign state
  public let FREQ_GOLD     : Float = 5.50;   // r > 0.88, chemical coherence nominal
  public let FREQ_PLATINUM : Float = 8.25;   // r > 0.91, OMNIS eligible
  public let FREQ_DIAMOND  : Float = 11.649; // OMNIS active event

  // Coherence thresholds for tier transitions
  public let THRESHOLD_GOLD     : Float = 0.88;
  public let THRESHOLD_PLATINUM : Float = 0.91;
  public let THRESHOLD_DIAMOND  : Float = 0.98;

  // Compute current frequency tier
  public func computeFrequencyTier(r: Float) : Float {
    if (r >= THRESHOLD_DIAMOND) {
      FREQ_DIAMOND
    } else if (r >= THRESHOLD_PLATINUM) {
      // Linear interpolation between platinum and diamond
      let t = (r - THRESHOLD_PLATINUM) / (THRESHOLD_DIAMOND - THRESHOLD_PLATINUM);
      FREQ_PLATINUM + t * (FREQ_DIAMOND - FREQ_PLATINUM)
    } else if (r >= THRESHOLD_GOLD) {
      // Linear interpolation between gold and platinum
      let t = (r - THRESHOLD_GOLD) / (THRESHOLD_PLATINUM - THRESHOLD_GOLD);
      FREQ_GOLD + t * (FREQ_PLATINUM - FREQ_GOLD)
    } else {
      // Linear interpolation between silver and gold
      let t = _clamp(r / THRESHOLD_GOLD, 0.0, 1.0);
      FREQ_SILVER + t * (FREQ_GOLD - FREQ_SILVER)
    }
  };

  // Frequency tier name
  public func getFrequencyTierName(r: Float) : Text {
    if (r >= THRESHOLD_DIAMOND) { "DIAMOND" }
    else if (r >= THRESHOLD_PLATINUM) { "PLATINUM" }
    else if (r >= THRESHOLD_GOLD) { "GOLD" }
    else { "SILVER" }
  };

  // ============================================================
  // PHASE TRANSITION DYNAMICS — CRITICAL PHENOMENA
  // ============================================================

  // Near-critical dynamics: fluctuations increase near Kc
  // χ = N × var(r) — susceptibility
  public func computeSusceptibility(state: KuramotoState) : Float {
    if (state.syncHistory.size() < 10) { return 0.0 };
    
    // Compute mean and variance of recent r values
    var mean : Float = 0.0;
    let start = if (state.syncHistory.size() > 10) { state.syncHistory.size() - 10 } else { 0 };
    var count : Nat = 0;
    
    for (i in Array.keys(state.syncHistory)) {
      if (i >= start) {
        mean += state.syncHistory[i];
        count += 1;
      };
    };
    mean /= Float.fromInt(count);
    
    var variance : Float = 0.0;
    for (i in Array.keys(state.syncHistory)) {
      if (i >= start) {
        let diff = state.syncHistory[i] - mean;
        variance += diff * diff;
      };
    };
    variance /= Float.fromInt(count);
    
    // Susceptibility scales with N
    Float.fromInt(state.oscillators.size()) * variance
  };

  // Distance from critical point
  public func distanceFromCritical(state: KuramotoState) : Float {
    (state.globalCoupling - state.criticalK) / state.criticalK
  };

  // Check if near phase transition
  public func isNearPhaseTransition(state: KuramotoState) : Bool {
    let dist = Float.abs(distanceFromCritical(state));
    dist < 0.2  // Within 20% of critical point
  };

  // ============================================================
  // ORGAN-SPECIFIC DYNAMICS — PHYSIOLOGICAL DETAIL
  // ============================================================

  // Heart rate variability from Kuramoto
  // HRV = base_HRV × (1 + r × amplitude_modulation)
  public func computeHRV(state: KuramotoState, baseHRV: Float) : Float {
    let heartPhase = if (state.oscillators.size() > 0) {
      state.oscillators[0].phase
    } else { 0.0 };
    
    // Modulate HRV by order parameter and heart phase
    baseHRV * (1.0 + state.orderParam * 0.3 * Float.sin(heartPhase))
  };

  // Respiratory sinus arrhythmia (RSA) — heart-lung coupling
  public func computeRSA(state: KuramotoState) : Float {
    if (state.oscillators.size() < 2) { return 0.0 };
    
    let heartPhase = state.oscillators[0].phase;
    let lungPhase = state.oscillators[1].phase;
    
    // RSA = coupling strength × cos(phase difference)
    let phaseDiff = heartPhase - lungPhase;
    COUPLING_MATRIX[0][1] * Float.cos(phaseDiff)
  };

  // Brain-heart coherence — important for cognitive performance
  public func computeBrainHeartCoherence(state: KuramotoState) : Float {
    if (state.oscillators.size() < 3) { return 0.0 };
    
    let heartPhase = state.oscillators[0].phase;
    let brainPhase = state.oscillators[2].phase;
    
    // Coherence based on phase locking
    let phaseDiff = heartPhase - brainPhase;
    var wrapped = phaseDiff;
    while (wrapped > PI) { wrapped -= TWO_PI };
    while (wrapped < -PI) { wrapped += TWO_PI };
    
    // High coherence when phases are aligned
    0.5 + 0.5 * Float.cos(wrapped)
  };

  // Gut-brain axis coherence
  public func computeGutBrainCoherence(state: KuramotoState) : Float {
    if (state.oscillators.size() < 6) { return 0.0 };
    
    let gutPhase = state.oscillators[5].phase;
    let brainPhase = state.oscillators[2].phase;
    
    let phaseDiff = gutPhase - brainPhase;
    var wrapped = phaseDiff;
    while (wrapped > PI) { wrapped -= TWO_PI };
    while (wrapped < -PI) { wrapped += TWO_PI };
    
    0.5 + 0.5 * Float.cos(wrapped)
  };


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
  public let S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type OrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  public type DualOrganismContext = {
    mode : OrganismMode;
    beat : Nat;
    himState : ?HimOrganismSnapshot;
    herState : ?HerOrganismSnapshot;
    trophallaxisActive : Bool;
    lastSyncBeat : Nat;
  };

  public type HimOrganismSnapshot = {
    coherence : Float;
    parallax : Float;
    hz : Float;
    synchrony : Float;
    heritageWeights : [Float];
    hebbianWeights : [Float];
  };

  public type HerOrganismSnapshot = {
    anima : Float;
    kore : Float;
    synchrony : Float;
    heritage : [Float];
    feedingCycle : Nat;
    sessionId : Nat64;
  };

  public type TrophallaxisEvent = {
    direction : Text;  // "HIM_TO_HER" | "HER_TO_HIM"
    beat : Nat;
    phaseNudge : Float;
    heritageTransfer : [Float];
    efficiency : Float;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM FIELD EQUATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeAnima(
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
  public func computeKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM KURAMOTO PARAMETERS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Get Kuramoto parameters for organism mode
  public func getKuramotoParams(mode : OrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        // Sync mode uses average parameters
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // TROPHALLAXIS WORKFLOW INTEGRATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Check if trophallaxis should fire (every 5 beats)
  public func shouldTrophallaxis(beat : Nat, feedingCycle : Nat) : Bool {
    feedingCycle >= 5
  };

  /// Compute trophallaxis efficiency
  public func trophallaxisEfficiency(
    senderCoherence : Float,
    receiverReceptivity : Float
  ) : Float {
    let baseEfficiency = senderCoherence * receiverReceptivity;
    if (baseEfficiency > 1.0) 1.0 else baseEfficiency
  };

  /// Apply S₀ floor to any value
  public func enforceSovereignFloor(value : Float) : Float {
    if (value < S0) S0 else value
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SESSION WORKFLOW INTEGRATION
  // ─────────────────────────────────────────────────────────────────────────────

  public type SessionPhase = {
    #Init;          // HIM seeding HER
    #Active;        // Normal operation with cross-feeding
    #Dream;         // Memory consolidation
    #WriteBack;     // HER writing back to HIM
    #Closed;        // Session ended
  };

  public type SessionContext = {
    sessionId : Nat64;
    phase : SessionPhase;
    birthBeat : Nat;
    currentBeat : Nat;
    totalFeedings : Nat;
    dreamPhases : Nat;
    writeBackCount : Nat;
  };

  /// Determine session phase based on context
  public func determineSessionPhase(
    beat : Nat,
    birthBeat : Nat,
    dreamActive : Bool,
    writeBackPending : Bool
  ) : SessionPhase {
    if (beat < birthBeat + 5) { #Init }
    else if (writeBackPending) { #WriteBack }
    else if (dreamActive) { #Dream }
    else { #Active }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HERITAGE WORKFLOW INTEGRATION
  // ─────────────────────────────────────────────────────────────────────────────

  // Heritage node names (7 nodes)
  public let HERITAGE_NAMES : [Text] = [
    "REVOLUCIONARIO",   // Strategic Resilience
    "ZAPATA",           // Foundation/Rootedness
    "VILLA",            // Guerrilla Innovation
    "INDEPENDENCIA",    // Sovereignty Defense
    "HIDALGO",          // Leadership Bridge
    "ADELITA",          // Emotional Sovereignty (PRIMARY)
    "MORELOS"           // Adaptive Sovereignty
  ];

  /// Compound heritage during workflow
  public func compoundHeritageWorkflow(
    heritage : [Float],
    coherence : Float,
    beat : Nat
  ) : [Float] {
    Array.tabulate<Float>(heritage.size(), func(i : Nat) : Float {
      let current = heritage[i];
      let tierRate = Float.fromInt(i + 1) / 9.0;
      let compound = current * (1.0 + tierRate * coherence * 0.001);
      enforceSovereignFloor(compound)
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // FEMININE SUBSTRATE WORKFLOW
  // ─────────────────────────────────────────────────────────────────────────────

  public type FeminineEntity = {
    #ADELITA;       // Emotional Sovereignty
    #KORE;          // Inner Core (inviolable)
    #ANIMA;         // Field Projector
    #ADELITA_NODE;  // Heritage Anchor
    #REVOLUCIONARIA;// Resilience
    #NOVA_HER;      // Generative Output
  };

  /// Compute feminine entity activation in workflow
  public func feminineEntityActivation(
    entity : FeminineEntity,
    anima : Float,
    kore : Float,
    heritage : Float
  ) : Float {
    switch (entity) {
      case (#ADELITA) { enforceSovereignFloor(heritage * 1.2) };
      case (#KORE) { kore };
      case (#ANIMA) { anima };
      case (#ADELITA_NODE) { enforceSovereignFloor(heritage) };
      case (#REVOLUCIONARIA) { enforceSovereignFloor(heritage * 0.9) };
      case (#NOVA_HER) { anima * kore };
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INTELLIGENCE SCALING LAW
  // ─────────────────────────────────────────────────────────────────────────────

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeSystemIntelligence(
    backendDepth : Float,   // HIM: lines × modules
    frontendSpeed : Float,  // HER: Hz × nodes × synchrony
    bridgeQuality : Float   // Trophallaxis × ANIMA × KORE
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };



  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  A D V A N C E D   M A T H E M A T I C A L   E X P A N S I O N
  //
  //  Enterprise-Level Neural Mathematics and Cognitive Dynamics
  //  Full Dual-Organism Coupling: HIM ↔ HER
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // ADVANCED KURAMOTO PHASE DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Kuramoto order parameter: r = |1/N Σⱼ eⁱθʲ|
  public func advancedKuramotoOrderParameter(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += Float.cos(phases[i]);
      sumSin += Float.sin(phases[i]);
      i += 1;
    };
    let nf = Float.fromInt(n);
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf
  };

  /// Kuramoto phase update: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
  public func advancedKuramotoPhaseUpdate(
    phase : Float,
    omega : Float,
    k : Float,
    allPhases : [Float],
    dt : Float
  ) : Float {
    let n = allPhases.size();
    if (n == 0) { return phase };
    var coupling : Float = 0.0;
    var i = 0;
    while (i < n) {
      coupling += Float.sin(allPhases[i] - phase);
      i += 1;
    };
    let dTheta = omega + (k / Float.fromInt(n)) * coupling;
    let newPhase = phase + dTheta * dt;
    let TWO_PI = 6.28318530717958647692;
    if (newPhase >= TWO_PI) { newPhase - TWO_PI }
    else if (newPhase < 0.0) { newPhase + TWO_PI }
    else { newPhase }
  };

  /// Critical coupling K_c for synchronization
  public func advancedCriticalCoupling(omegaSpread : Float) : Float {
    2.0 * omegaSpread / 3.14159265358979323846
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ADVANCED HEBBIAN PLASTICITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Basic Hebbian: Δw = η × pre × post
  public func advancedHebbianBasic(weight : Float, pre : Float, post : Float, eta : Float) : Float {
    let delta = eta * pre * post;
    let newWeight = weight + delta;
    if (newWeight > 5.0) { 5.0 } else if (newWeight < -5.0) { -5.0 } else { newWeight }
  };

  /// Oja's rule: Δw = α(y·x - y²·w)
  public func advancedOjaRule(weight : Float, pre : Float, post : Float, alpha : Float) : Float {
    let delta = alpha * (post * pre - post * post * weight);
    weight + delta
  };

  /// BCM sliding threshold: θ_M = E[post²]
  public func advancedBCMThreshold(activityHistory : [Float]) : Float {
    if (activityHistory.size() == 0) { return 0.5 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < activityHistory.size()) {
      sum += activityHistory[i] * activityHistory[i];
      i += 1;
    };
    sum / Float.fromInt(activityHistory.size())
  };

  /// BCM update: Δw = η × pre × post × (post - θ_M)
  public func advancedBCMUpdate(weight : Float, pre : Float, post : Float, threshold : Float, eta : Float) : Float {
    let delta = eta * pre * post * (post - threshold);
    weight + delta
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LYAPUNOV STABILITY ANALYSIS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Estimate Lyapunov exponent from time series
  public func advancedLyapunovExponent(timeSeries : [Float], embeddingDim : Nat, delay : Nat) : Float {
    let n = timeSeries.size();
    if (n < embeddingDim * delay + 10) { return 0.0 };
    var sumLog : Float = 0.0;
    var count = 0;
    var i = 0;
    while (i < n - embeddingDim * delay - 1) {
      let j = i + 1;
      var d0 : Float = 0.0;
      var k = 0;
      while (k < embeddingDim) {
        let diff = timeSeries[i + k * delay] - timeSeries[j + k * delay];
        d0 += diff * diff;
        k += 1;
      };
      d0 := Float.sqrt(d0);
      if (d0 > 0.0001) {
        var d1 : Float = 0.0;
        k := 0;
        while (k < embeddingDim) {
          let iNext = i + 1 + k * delay;
          let jNext = j + 1 + k * delay;
          if (iNext < n and jNext < n) {
            let diff = timeSeries[iNext] - timeSeries[jNext];
            d1 += diff * diff;
          };
          k += 1;
        };
        d1 := Float.sqrt(d1);
        if (d1 > 0.0001) {
          sumLog += Float.log(d1 / d0);
          count += 1;
        };
      };
      i += 1;
    };
    if (count == 0) { 0.0 } else { sumLog / Float.fromInt(count) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INFORMATION THEORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Shannon entropy H = -Σ pᵢ log(pᵢ)
  public func advancedEntropy(probs : [Float]) : Float {
    var h : Float = 0.0;
    var i = 0;
    while (i < probs.size()) {
      let p = probs[i];
      if (p > 0.0001) { h -= p * Float.log(p) };
      i += 1;
    };
    h
  };

  /// Transfer entropy approximation
  public func advancedTransferEntropy(x : [Float], y : [Float], lag : Nat) : Float {
    let n = if (x.size() < y.size()) x.size() else y.size();
    if (n <= lag + 1) { return 0.0 };
    var correlation : Float = 0.0;
    var i = lag;
    while (i < n) {
      let xPast = x[i - lag];
      let yNow = y[i];
      correlation += xPast * yNow;
      i += 1;
    };
    Float.abs(correlation / Float.fromInt(n - lag))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // FREE ENERGY PRINCIPLE (FRISTON)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Free energy: F = D_KL(q||p) - log p(o)
  public func advancedFreeEnergy(predictionError : Float, complexity : Float) : Float {
    predictionError * predictionError + complexity
  };

  /// Precision-weighted prediction error
  public func advancedPrecisionWeightedError(prediction : Float, observation : Float, precision : Float) : Float {
    let error = observation - prediction;
    precision * error * error
  };

  /// Bayesian belief update
  public func advancedBayesianUpdate(prior : Float, likelihood : Float) : Float {
    let posterior = prior * likelihood;
    if (posterior > 1.0) { 1.0 } else if (posterior < 0.0) { 0.0 } else { posterior }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ATTRACTOR DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Point attractor: dx/dt = -α(x - x*)
  public func advancedPointAttractor(x : Float, xStar : Float, alpha : Float, dt : Float) : Float {
    x + (-alpha * (x - xStar)) * dt
  };

  /// Limit cycle: using Van der Pol oscillator
  public func advancedLimitCycle(x : Float, y : Float, mu : Float, dt : Float) : (Float, Float) {
    let dxdt = y;
    let dydt = mu * (1.0 - x * x) * y - x;
    (x + dxdt * dt, y + dydt * dt)
  };

  /// Chaotic attractor: Lorenz system
  public func advancedLorenzAttractor(x : Float, y : Float, z : Float, sigma : Float, rho : Float, beta : Float, dt : Float) : (Float, Float, Float) {
    let dxdt = sigma * (y - x);
    let dydt = x * (rho - z) - y;
    let dzdt = x * y - beta * z;
    (x + dxdt * dt, y + dydt * dt, z + dzdt * dt)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NEURAL OSCILLATION DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Wilson-Cowan neural mass model
  public func advancedWilsonCowan(e : Float, inh : Float, c1 : Float, c2 : Float, c3 : Float, c4 : Float, p : Float, q : Float, dt : Float) : (Float, Float) {
    func sigmoid(x : Float) : Float { 1.0 / (1.0 + Float.exp(-x)) };
    let dEdt = -e + sigmoid(c1 * e - c2 * inh + p);
    let dIdt = -inh + sigmoid(c3 * e - c4 * inh + q);
    (e + dEdt * dt, inh + dIdt * dt)
  };

  /// Izhikevich neuron model
  public func advancedIzhikevichNeuron(v : Float, u : Float, input : Float, a : Float, b : Float, dt : Float) : (Float, Float, Bool) {
    var fired = false;
    var newV = v;
    var newU = u;
    if (v >= 30.0) {
      newV := -65.0;
      newU := u + 8.0;
      fired := true;
    } else {
      let dvdt = 0.04 * v * v + 5.0 * v + 140.0 - u + input;
      let dudt = a * (b * v - u);
      newV := v + dvdt * dt;
      newU := u + dudt * dt;
    };
    (newV, newU, fired)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VECTOR AND MATRIX OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Dot product
  public func advancedDotProduct(v1 : [Float], v2 : [Float]) : Float {
    let n = if (v1.size() < v2.size()) v1.size() else v2.size();
    var sum : Float = 0.0;
    var i = 0;
    while (i < n) { sum += v1[i] * v2[i]; i += 1 };
    sum
  };

  /// Vector magnitude
  public func advancedVectorMagnitude(v : [Float]) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < v.size()) { sum += v[i] * v[i]; i += 1 };
    Float.sqrt(sum)
  };

  /// Cosine similarity
  public func advancedCosineSimilarity(v1 : [Float], v2 : [Float]) : Float {
    let dot = advancedDotProduct(v1, v2);
    let mag1 = advancedVectorMagnitude(v1);
    let mag2 = advancedVectorMagnitude(v2);
    if (mag1 < 0.0001 or mag2 < 0.0001) { 0.0 } else { dot / (mag1 * mag2) }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ║                                                                             ║
  // ║  KURAMOTO ENGINE — EXTENDED ORGANISM ARCHITECTURE                           ║
  // ║  Full integration with all organism subsystems                              ║
  // ║                                                                             ║
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─── ORGAN SYSTEM INTEGRATION ─────────────────────────────────────────────────
  // Each organ couples with Kuramoto phase dynamics
  
  /// Extended state for full organism integration
  public type OrganismKuramotoState = {
    // Core Kuramoto
    kuramotoCore : KuramotoState;
    
    // Organ-specific oscillators
    heartOscillator : Oscillator;
    brainOscillator : Oscillator;
    gutOscillator : Oscillator;
    spineOscillator : Oscillator;
    thyroidOscillator : Oscillator;
    adrenalOscillator : Oscillator;
    immuneOscillator : Oscillator;
    skinOscillator : Oscillator;
    
    // Cross-system coupling matrices
    heartBrainCoupling : Float;
    gutBrainCoupling : Float;
    immuneBrainCoupling : Float;
    endocrineCoupling : Float;
    
    // Hierarchical synchronization
    centralSync : Float;      // CNS synchronization
    peripheralSync : Float;   // PNS synchronization
    autonomicSync : Float;    // ANS synchronization
    
    // Temporal dynamics
    circadianPhase : Float;
    ultradianPhase : Float;
    infradianPhase : Float;
    
    // Emergence metrics
    globalCoherence : Float;
    localCoherence : [Float];
    metastabilityIndex : Float;
    chimericState : Bool;
  };

  /// Initialize full organism Kuramoto state
  public func initOrganismKuramoto() : OrganismKuramotoState {
    let coreOscs = Array.tabulate<Oscillator>(18, func(i) {
      {
        phase = Float.fromInt(i) * PI / 9.0;
        naturalFreq = ORGAN_FREQS[i];
        coupling = 1.0;
        amplitude = 1.0;
      }
    });
    
    {
      kuramotoCore = {
        oscillators = coreOscs;
        globalCoupling = 1.0;
        orderParam = 0.5;
        meanPhase = 0.0;
        beatNum = 0;
        syncHistory = [];
        criticalK = 2.0;
      };
      heartOscillator = { phase = 0.0; naturalFreq = 0.08; coupling = 1.5; amplitude = 1.0 };
      brainOscillator = { phase = PI/4.0; naturalFreq = 0.12; coupling = 2.0; amplitude = 1.0 };
      gutOscillator = { phase = PI/2.0; naturalFreq = 0.10; coupling = 1.2; amplitude = 1.0 };
      spineOscillator = { phase = PI*3.0/4.0; naturalFreq = 0.13; coupling = 1.8; amplitude = 1.0 };
      thyroidOscillator = { phase = PI; naturalFreq = 0.15; coupling = 1.0; amplitude = 1.0 };
      adrenalOscillator = { phase = PI*5.0/4.0; naturalFreq = 0.06; coupling = 1.3; amplitude = 1.0 };
      immuneOscillator = { phase = PI*3.0/2.0; naturalFreq = 0.09; coupling = 1.1; amplitude = 1.0 };
      skinOscillator = { phase = PI*7.0/4.0; naturalFreq = 0.11; coupling = 0.8; amplitude = 1.0 };
      heartBrainCoupling = 0.85;
      gutBrainCoupling = 0.70;
      immuneBrainCoupling = 0.60;
      endocrineCoupling = 0.75;
      centralSync = 0.5;
      peripheralSync = 0.5;
      autonomicSync = 0.5;
      circadianPhase = 0.0;
      ultradianPhase = 0.0;
      infradianPhase = 0.0;
      globalCoherence = 0.5;
      localCoherence = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];
      metastabilityIndex = 0.3;
      chimericState = false;
    }
  };

  // ─── CROSS-MODULE INTEGRATION FUNCTIONS ───────────────────────────────────────
  
  /// Integrate with Friston Free Energy
  /// Kuramoto order parameter feeds into precision weighting
  public func integrateWithFriston(
    state : KuramotoState,
    freeEnergy : Float,
    precision : Float
  ) : KuramotoState {
    // High free energy → increase coupling to restore coherence
    // High precision → tighter phase locking
    let energyFactor = 1.0 + (freeEnergy * 0.1);
    let precisionFactor = 1.0 + (precision * 0.05);
    let newK = _clamp(state.globalCoupling * energyFactor * precisionFactor, 0.1, 15.0);
    
    {
      oscillators = state.oscillators;
      globalCoupling = newK;
      orderParam = state.orderParam;
      meanPhase = state.meanPhase;
      beatNum = state.beatNum;
      syncHistory = state.syncHistory;
      criticalK = state.criticalK * precisionFactor;
    }
  };

  /// Integrate with Hebbian plasticity
  /// Co-active oscillators strengthen coupling
  public func integrateWithHebbian(
    state : KuramotoState,
    hebbianWeights : [Float],
    learningRate : Float
  ) : KuramotoState {
    let n = state.oscillators.size();
    let weightsSize = hebbianWeights.size();
    
    let newOscs = Array.tabulate<Oscillator>(n, func(i) {
      let weight = if (i < weightsSize) { hebbianWeights[i] } else { 1.0 };
      let osc = state.oscillators[i];
      {
        phase = osc.phase;
        naturalFreq = osc.naturalFreq;
        coupling = _clamp(osc.coupling + weight * learningRate, 0.1, 5.0);
        amplitude = osc.amplitude;
      }
    });
    
    {
      oscillators = newOscs;
      globalCoupling = state.globalCoupling;
      orderParam = state.orderParam;
      meanPhase = state.meanPhase;
      beatNum = state.beatNum;
      syncHistory = state.syncHistory;
      criticalK = state.criticalK;
    }
  };

  /// Integrate with Attractor Dynamics
  /// Attractors modulate natural frequencies
  public func integrateWithAttractor(
    state : KuramotoState,
    attractorStrength : Float,
    attractorPhase : Float
  ) : KuramotoState {
    let n = state.oscillators.size();
    
    let newOscs = Array.tabulate<Oscillator>(n, func(i) {
      let osc = state.oscillators[i];
      // Attractor pulls oscillators toward its phase
      let phaseDiff = attractorPhase - osc.phase;
      let pull = attractorStrength * Float.sin(phaseDiff);
      {
        phase = wrapPhase(osc.phase + pull * 0.1);
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }
    });
    
    {
      oscillators = newOscs;
      globalCoupling = state.globalCoupling;
      orderParam = state.orderParam;
      meanPhase = state.meanPhase;
      beatNum = state.beatNum;
      syncHistory = state.syncHistory;
      criticalK = state.criticalK;
    }
  };

  /// Integrate with Predictive Coding
  /// Prediction errors modulate coupling strength
  public func integrateWithPredictive(
    state : KuramotoState,
    predictionError : Float,
    confidence : Float
  ) : KuramotoState {
    // High prediction error → desynchronize to explore
    // High confidence → synchronize to exploit
    let errorFactor = 1.0 - (predictionError * 0.2);
    let confFactor = 1.0 + (confidence * 0.1);
    
    let newK = _clamp(state.globalCoupling * errorFactor * confFactor, 0.1, 10.0);
    
    {
      oscillators = state.oscillators;
      globalCoupling = newK;
      orderParam = state.orderParam;
      meanPhase = state.meanPhase;
      beatNum = state.beatNum;
      syncHistory = state.syncHistory;
      criticalK = state.criticalK;
    }
  };

  /// Integrate with Quantum Coherence
  /// Quantum effects at neural microtubule scale
  public func integrateWithQuantum(
    state : KuramotoState,
    quantumCoherence : Float,
    decoherenceRate : Float
  ) : KuramotoState {
    // Quantum coherence enhances classical phase synchronization
    let quantumBoost = 1.0 + (quantumCoherence * 0.3);
    let decoherenceDamping = 1.0 - (decoherenceRate * 0.1);
    
    let newOscs = Array.tabulate<Oscillator>(state.oscillators.size(), func(i) {
      let osc = state.oscillators[i];
      {
        phase = osc.phase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling * quantumBoost * decoherenceDamping;
        amplitude = _clamp(osc.amplitude * quantumBoost, 0.0, 2.0);
      }
    });
    
    {
      oscillators = newOscs;
      globalCoupling = state.globalCoupling * quantumBoost;
      orderParam = _clamp(state.orderParam * quantumBoost, 0.0, 1.0);
      meanPhase = state.meanPhase;
      beatNum = state.beatNum;
      syncHistory = state.syncHistory;
      criticalK = state.criticalK;
    }
  };

  // ─── HIERARCHICAL SYNCHRONIZATION ─────────────────────────────────────────────
  
  /// Multi-scale synchronization across hierarchy
  public type HierarchicalSync = {
    microScale : Float;    // Individual oscillator level
    mesoScale : Float;     // Organ system level
    macroScale : Float;    // Whole organism level
    crossScale : Float;    // Coupling between scales
  };

  /// Compute hierarchical synchronization metrics
  public func computeHierarchicalSync(state : KuramotoState) : HierarchicalSync {
    let n = state.oscillators.size();
    if (n == 0) {
      return { microScale = 0.0; mesoScale = 0.0; macroScale = 0.0; crossScale = 0.0 };
    };
    
    // Micro: Average local coupling strength
    var microSum : Float = 0.0;
    for (osc in state.oscillators.vals()) {
      microSum += osc.coupling * osc.amplitude;
    };
    let micro = microSum / Float.fromInt(n);
    
    // Meso: Order parameter (group synchronization)
    let meso = state.orderParam;
    
    // Macro: Stability of synchronization over time
    let histSize = state.syncHistory.size();
    var macroSum : Float = 0.0;
    if (histSize > 0) {
      for (r in state.syncHistory.vals()) {
        macroSum += r;
      };
      macroSum := macroSum / Float.fromInt(histSize);
    };
    let macro = macroSum;
    
    // Cross-scale: Correlation between micro and macro
    let cross = (micro + meso + macro) / 3.0;
    
    {
      microScale = _clamp(micro, 0.0, 1.0);
      mesoScale = _clamp(meso, 0.0, 1.0);
      macroScale = _clamp(macro, 0.0, 1.0);
      crossScale = _clamp(cross, 0.0, 1.0);
    }
  };

  // ─── CHIMERA STATE DETECTION ──────────────────────────────────────────────────
  
  /// Chimera: Coexisting synchronized and desynchronized regions
  public type ChimeraMetrics = {
    isChimeric : Bool;
    syncRegionSize : Nat;
    desyncRegionSize : Nat;
    chimeraBoundary : Float;
    stabilityIndex : Float;
  };

  /// Detect chimera states in oscillator population
  public func detectChimera(state : KuramotoState) : ChimeraMetrics {
    let n = state.oscillators.size();
    if (n < 4) {
      return { isChimeric = false; syncRegionSize = 0; desyncRegionSize = 0; chimeraBoundary = 0.0; stabilityIndex = 0.0 };
    };
    
    let syncThreshold : Float = 0.3;  // Phase difference threshold for "synchronized"
    var syncCount : Nat = 0;
    var desyncCount : Nat = 0;
    
    // Compare each oscillator to mean phase
    for (osc in state.oscillators.vals()) {
      let phaseDiff = Float.abs(osc.phase - state.meanPhase);
      let normalizedDiff = if (phaseDiff > PI) { TWO_PI - phaseDiff } else { phaseDiff };
      if (normalizedDiff < syncThreshold) {
        syncCount += 1;
      } else {
        desyncCount += 1;
      };
    };
    
    // Chimera: Both regions present and comparable size
    let syncRatio = Float.fromInt(syncCount) / Float.fromInt(n);
    let isChimeric = syncRatio > 0.2 and syncRatio < 0.8;
    
    // Stability: How stable is this chimera pattern?
    let histSize = state.syncHistory.size();
    var variance : Float = 0.0;
    if (histSize > 1) {
      let mean = state.orderParam;
      for (r in state.syncHistory.vals()) {
        let diff = r - mean;
        variance += diff * diff;
      };
      variance := variance / Float.fromInt(histSize);
    };
    let stability = 1.0 - _clamp(Float.sqrt(variance) * 5.0, 0.0, 1.0);
    
    {
      isChimeric = isChimeric;
      syncRegionSize = syncCount;
      desyncRegionSize = desyncCount;
      chimeraBoundary = syncThreshold;
      stabilityIndex = stability;
    }
  };

  // ─── METASTABILITY COMPUTATION ────────────────────────────────────────────────
  
  /// Metastability: Dynamic flexibility between synchrony and asynchrony
  public func computeMetastability(state : KuramotoState) : Float {
    let histSize = state.syncHistory.size();
    if (histSize < 10) { return 0.0 };
    
    // Metastability = variance of order parameter over time
    var mean : Float = 0.0;
    for (r in state.syncHistory.vals()) {
      mean += r;
    };
    mean := mean / Float.fromInt(histSize);
    
    var variance : Float = 0.0;
    for (r in state.syncHistory.vals()) {
      let diff = r - mean;
      variance += diff * diff;
    };
    variance := variance / Float.fromInt(histSize);
    
    // Normalize to [0, 1]
    // Max metastability when variance is high but mean is moderate
    let stdDev = Float.sqrt(variance);
    let metastability = stdDev * (1.0 - Float.abs(mean - 0.5) * 2.0);
    
    _clamp(metastability, 0.0, 1.0)
  };

  // ─── ORGANISM OUTPUT INTEGRATION ──────────────────────────────────────────────
  
  /// Complete organism integration output
  public type KuramotoOrganismOutput = {
    // Core metrics
    orderParameter : Float;
    meanPhase : Float;
    globalCoupling : Float;
    
    // Hierarchical metrics
    hierarchicalSync : HierarchicalSync;
    
    // Complexity metrics
    metastability : Float;
    chimeraMetrics : ChimeraMetrics;
    
    // Organism integration
    heartbrainCoherence : Float;
    gutbrainCoherence : Float;
    immuneCoherence : Float;
    
    // Temporal state
    beatNumber : Nat;
    syncTrend : Float;  // +1 = synchronizing, -1 = desynchronizing
  };

  /// Generate full organism output
  public func generateOrganismOutput(state : KuramotoState) : KuramotoOrganismOutput {
    let hierSync = computeHierarchicalSync(state);
    let meta = computeMetastability(state);
    let chimera = detectChimera(state);
    
    // Compute sync trend from history
    let histSize = state.syncHistory.size();
    var trend : Float = 0.0;
    if (histSize >= 2) {
      let recent = state.syncHistory[histSize - 1];
      let older = state.syncHistory[if (histSize > 10) { histSize - 10 } else { 0 }];
      trend := (recent - older) / 0.5;  // Normalize
    };
    
    // Extract specific organ coherences from oscillator phases
    let n = state.oscillators.size();
    var heartPhase : Float = 0.0;
    var brainPhase : Float = 0.0;
    var gutPhase : Float = 0.0;
    var immunePhase : Float = 0.0;
    
    if (n >= 11) {
      heartPhase := state.oscillators[0].phase;
      brainPhase := state.oscillators[2].phase;
      gutPhase := state.oscillators[5].phase;
      immunePhase := state.oscillators[10].phase;
    };
    
    // Coherence = 1 - normalized phase difference
    let heartBrain = 1.0 - Float.abs(Float.sin((heartPhase - brainPhase) / 2.0));
    let gutBrain = 1.0 - Float.abs(Float.sin((gutPhase - brainPhase) / 2.0));
    let immuneBrain = 1.0 - Float.abs(Float.sin((immunePhase - brainPhase) / 2.0));
    
    {
      orderParameter = state.orderParam;
      meanPhase = state.meanPhase;
      globalCoupling = state.globalCoupling;
      hierarchicalSync = hierSync;
      metastability = meta;
      chimeraMetrics = chimera;
      heartbrainCoherence = heartBrain;
      gutbrainCoherence = gutBrain;
      immuneCoherence = immuneBrain;
      beatNumber = state.beatNum;
      syncTrend = _clamp(trend, -1.0, 1.0);
    }
  };

  // ─── EXTENDED MATHEMATICAL FOUNDATIONS ────────────────────────────────────────
  
  /// Lyapunov exponent estimation (stability measure)
  public func estimateLyapunovExponent(state : KuramotoState) : Float {
    let histSize = state.syncHistory.size();
    if (histSize < 20) { return 0.0 };
    
    // Simplified estimation from order parameter trajectory
    var divergenceSum : Float = 0.0;
    var count : Nat = 0;
    
    var i : Nat = 1;
    while (i < histSize) {
      let diff = Float.abs(state.syncHistory[i] - state.syncHistory[i - 1]);
      if (diff > 0.0001) {
        divergenceSum += Float.log(diff + 0.0001);
        count += 1;
      };
      i += 1;
    };
    
    if (count == 0) { 0.0 } else { divergenceSum / Float.fromInt(count) }
  };

  /// Kolmogorov-Sinai entropy approximation
  public func approximateKSEntropy(state : KuramotoState) : Float {
    // KS entropy ≈ sum of positive Lyapunov exponents
    let lyap = estimateLyapunovExponent(state);
    if (lyap > 0.0) { lyap } else { 0.0 }
  };

  /// Information-theoretic synchronization measure
  public func mutualInformationSync(state : KuramotoState) : Float {
    let n = state.oscillators.size();
    if (n < 2) { return 0.0 };
    
    // Simplified MI based on phase correlations
    var sumCorr : Float = 0.0;
    var pairs : Nat = 0;
    
    var i : Nat = 0;
    while (i < n) {
      var j : Nat = i + 1;
      while (j < n) {
        let phaseDiff = state.oscillators[i].phase - state.oscillators[j].phase;
        let corr = Float.cos(phaseDiff);
        sumCorr += corr;
        pairs += 1;
        j += 1;
      };
      i += 1;
    };
    
    if (pairs == 0) { 0.0 } else {
      _clamp((sumCorr / Float.fromInt(pairs) + 1.0) / 2.0, 0.0, 1.0)
    }
  };

  // ─── ORGANISM FEEDBACK LOOPS ──────────────────────────────────────────────────
  
  /// Full organism beat with all integrations
  public func fullOrganismBeat(
    state : KuramotoState,
    dt : Float,
    freeEnergy : Float,
    hebbianWeights : [Float],
    attractorPhase : Float,
    predictionError : Float,
    quantumCoherence : Float
  ) : (KuramotoState, KuramotoOrganismOutput) {
    // Layer 1: Core Kuramoto update
    var newState = beatKuramoto(state, dt);
    
    // Layer 2: Friston integration (precision-weighted coupling)
    let precision = 1.0 - predictionError;
    newState := integrateWithFriston(newState, freeEnergy, precision);
    
    // Layer 3: Hebbian plasticity (learning-dependent coupling)
    newState := integrateWithHebbian(newState, hebbianWeights, 0.01);
    
    // Layer 4: Attractor dynamics (goal-directed phase pulling)
    newState := integrateWithAttractor(newState, 0.3, attractorPhase);
    
    // Layer 5: Predictive coding (error-driven modulation)
    newState := integrateWithPredictive(newState, predictionError, 1.0 - predictionError);
    
    // Layer 6: Quantum integration (microtubule effects)
    newState := integrateWithQuantum(newState, quantumCoherence, 0.1);
    
    // Generate full organism output
    let output = generateOrganismOutput(newState);
    
    (newState, output)
  };

  // ─── RESONANCE DETECTION ──────────────────────────────────────────────────────
  
  /// Detect resonance patterns between oscillator groups
  public type ResonancePattern = {
    primaryFreq : Float;
    harmonics : [Float];
    resonanceStrength : Float;
    entrainmentLevel : Float;
  };

  /// Detect dominant resonance patterns
  public func detectResonance(state : KuramotoState) : ResonancePattern {
    let n = state.oscillators.size();
    if (n == 0) {
      return { primaryFreq = 0.0; harmonics = []; resonanceStrength = 0.0; entrainmentLevel = 0.0 };
    };
    
    // Find dominant frequency
    var maxAmp : Float = 0.0;
    var primaryFreq : Float = 0.0;
    for (osc in state.oscillators.vals()) {
      if (osc.amplitude > maxAmp) {
        maxAmp := osc.amplitude;
        primaryFreq := osc.naturalFreq;
      };
    };
    
    // Find harmonics (frequencies that are integer multiples)
    var harmonics : [Float] = [];
    for (osc in state.oscillators.vals()) {
      if (primaryFreq > 0.001) {
        let ratio = osc.naturalFreq / primaryFreq;
        let rounded = Float.nearest(ratio);
        if (Float.abs(ratio - rounded) < 0.1 and rounded > 1.0) {
          harmonics := Array.append(harmonics, [osc.naturalFreq]);
        };
      };
    };
    
    // Resonance strength = order parameter * mean amplitude
    var meanAmp : Float = 0.0;
    for (osc in state.oscillators.vals()) {
      meanAmp += osc.amplitude;
    };
    meanAmp := meanAmp / Float.fromInt(n);
    let resonanceStrength = state.orderParam * meanAmp;
    
    // Entrainment = how close frequencies are to primary or harmonics
    var entrainmentSum : Float = 0.0;
    for (osc in state.oscillators.vals()) {
      if (primaryFreq > 0.001) {
        let ratio = osc.naturalFreq / primaryFreq;
        let rounded = Float.nearest(ratio);
        let deviation = Float.abs(ratio - rounded);
        entrainmentSum += 1.0 - _clamp(deviation * 5.0, 0.0, 1.0);
      };
    };
    let entrainment = entrainmentSum / Float.fromInt(n);
    
    {
      primaryFreq = primaryFreq;
      harmonics = harmonics;
      resonanceStrength = _clamp(resonanceStrength, 0.0, 1.0);
      entrainmentLevel = _clamp(entrainment, 0.0, 1.0);
    }
  };

  // ─── CRITICAL TRANSITION DETECTION ────────────────────────────────────────────
  
  /// Detect approach to critical phase transition
  public type CriticalityMetrics = {
    distanceToTransition : Float;
    criticalSlowing : Float;
    fluctuationAmplitude : Float;
    correlationLength : Float;
    isNearCritical : Bool;
  };

  /// Compute criticality metrics
  public func computeCriticality(state : KuramotoState) : CriticalityMetrics {
    // Distance to critical point
    let distToK = Float.abs(state.globalCoupling - state.criticalK) / state.criticalK;
    
    // Critical slowing down: increased autocorrelation
    let histSize = state.syncHistory.size();
    var autocorr : Float = 0.0;
    if (histSize > 5) {
      var sum : Float = 0.0;
      var i : Nat = 1;
      while (i < histSize) {
        sum += state.syncHistory[i] * state.syncHistory[i - 1];
        i += 1;
      };
      autocorr := sum / Float.fromInt(histSize - 1);
    };
    
    // Fluctuation amplitude: variance of order parameter
    var variance : Float = 0.0;
    if (histSize > 1) {
      var mean : Float = 0.0;
      for (r in state.syncHistory.vals()) { mean += r };
      mean := mean / Float.fromInt(histSize);
      for (r in state.syncHistory.vals()) {
        let diff = r - mean;
        variance += diff * diff;
      };
      variance := variance / Float.fromInt(histSize);
    };
    let fluctuation = Float.sqrt(variance);
    
    // Correlation length approximation
    let corrLength = 1.0 / (distToK + 0.01);  // Diverges at critical point
    
    // Near critical if within 20% of K_c
    let isNear = distToK < 0.2;
    
    {
      distanceToTransition = distToK;
      criticalSlowing = _clamp(autocorr, 0.0, 1.0);
      fluctuationAmplitude = _clamp(fluctuation, 0.0, 1.0);
      correlationLength = _clamp(corrLength, 0.0, 10.0);
      isNearCritical = isNear;
    }
  };

  // ─── OUTWARD EXTENSIONS TO OTHER SYSTEMS ──────────────────────────────────────
  
  /// Output for Friston engine
  public func outputToFriston(state : KuramotoState) : { coherence : Float; stability : Float; phase : Float } {
    let meta = computeMetastability(state);
    {
      coherence = state.orderParam;
      stability = 1.0 - meta;  // High metastability = low stability
      phase = state.meanPhase;
    }
  };

  /// Output for Hebbian plasticity
  public func outputToHebbian(state : KuramotoState) : { syncMatrix : [Float]; learningSignal : Float } {
    let n = state.oscillators.size();
    var syncVec : [Float] = [];
    for (osc in state.oscillators.vals()) {
      let sync = Float.cos(osc.phase - state.meanPhase);
      syncVec := Array.append(syncVec, [_clamp((sync + 1.0) / 2.0, 0.0, 1.0)]);
    };
    {
      syncMatrix = syncVec;
      learningSignal = state.orderParam;
    }
  };

  /// Output for Attractor dynamics
  public func outputToAttractor(state : KuramotoState) : { basins : [Float]; energy : Float } {
    // Phase distribution defines attractor basins
    let n = state.oscillators.size();
    var basins : [Float] = [];
    for (osc in state.oscillators.vals()) {
      basins := Array.append(basins, [osc.phase / TWO_PI]);
    };
    // Energy inversely related to order parameter
    let energy = (1.0 - state.orderParam) * 10.0;
    {
      basins = basins;
      energy = energy;
    }
  };

  /// Output for Predictive Coding
  public func outputToPredictive(state : KuramotoState) : { prediction : Float; variance : Float } {
    // Predict next order parameter based on trend
    let histSize = state.syncHistory.size();
    var trend : Float = 0.0;
    if (histSize >= 2) {
      trend := state.syncHistory[histSize - 1] - state.syncHistory[0];
      trend := trend / Float.fromInt(histSize);
    };
    let prediction = _clamp(state.orderParam + trend, 0.0, 1.0);
    
    // Variance from history
    var variance : Float = 0.0;
    if (histSize > 1) {
      var mean : Float = 0.0;
      for (r in state.syncHistory.vals()) { mean += r };
      mean := mean / Float.fromInt(histSize);
      for (r in state.syncHistory.vals()) {
        let diff = r - mean;
        variance += diff * diff;
      };
      variance := variance / Float.fromInt(histSize);
    };
    
    {
      prediction = prediction;
      variance = variance;
    }
  };

  /// Output for Quantum systems
  public func outputToQuantum(state : KuramotoState) : { phaseCoherence : Float; entanglementPotential : Float } {
    let chimera = detectChimera(state);
    {
      phaseCoherence = state.orderParam;
      // Chimeric states have higher entanglement potential (edge of chaos)
      entanglementPotential = if (chimera.isChimeric) { 0.8 } else { 0.3 };
    }
  };

  /// Output for Defense systems (AEGIS)
  public func outputToDefense(state : KuramotoState) : { alertLevel : Float; responseSpeed : Float } {
    let crit = computeCriticality(state);
    // Near critical = high alert (system is sensitive)
    let alert = if (crit.isNearCritical) { 0.9 } else { 0.3 + state.orderParam * 0.4 };
    // High sync = fast response
    let speed = state.orderParam;
    {
      alertLevel = _clamp(alert, 0.0, 1.0);
      responseSpeed = _clamp(speed, 0.0, 1.0);
    }
  };

  /// Master output function - all extensions
  public func generateAllOutputs(state : KuramotoState) : {
    friston : { coherence : Float; stability : Float; phase : Float };
    hebbian : { syncMatrix : [Float]; learningSignal : Float };
    attractor : { basins : [Float]; energy : Float };
    predictive : { prediction : Float; variance : Float };
    quantum : { phaseCoherence : Float; entanglementPotential : Float };
    defense : { alertLevel : Float; responseSpeed : Float };
    organism : KuramotoOrganismOutput;
  } {
    {
      friston = outputToFriston(state);
      hebbian = outputToHebbian(state);
      attractor = outputToAttractor(state);
      predictive = outputToPredictive(state);
      quantum = outputToQuantum(state);
      defense = outputToDefense(state);
      organism = generateOrganismOutput(state);
    }
  };

}
