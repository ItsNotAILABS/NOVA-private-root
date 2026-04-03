// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine — Spherical Compounding Mathematics                                        ║
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


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ███╗   ███╗███████╗██████╗ ██╗███╗   ██╗ █████╗     ███████╗██████╗ ██╗  ██╗███████╗██████╗ ██╗ ██████╗ █████╗ ██╗     
// ████╗ ████║██╔════╝██╔══██╗██║████╗  ██║██╔══██╗    ██╔════╝██╔══██╗██║  ██║██╔════╝██╔══██╗██║██╔════╝██╔══██╗██║     
// ██╔████╔██║█████╗  ██║  ██║██║██╔██╗ ██║███████║    ███████╗██████╔╝███████║█████╗  ██████╔╝██║██║     ███████║██║     
// ██║╚██╔╝██║██╔══╝  ██║  ██║██║██║╚██╗██║██╔══██║    ╚════██║██╔═══╝ ██╔══██║██╔══╝  ██╔══██╗██║██║     ██╔══██║██║     
// ██║ ╚═╝ ██║███████╗██████╔╝██║██║ ╚████║██║  ██║    ███████║██║     ██║  ██║███████╗██║  ██║██║╚██████╗██║  ██║███████╗
// ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚══════╝╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝
//                                                                                                                       
//  ██████╗ ██████╗ ███╗   ███╗██████╗  ██████╗ ██╗   ██╗███╗   ██╗██████╗ ██╗███╗   ██╗ ██████╗     ███████╗ █████╗ ██████╗ ██████╗ ██╗ ██████╗
// ██╔════╝██╔═══██╗████╗ ████║██╔══██╗██╔═══██╗██║   ██║████╗  ██║██╔══██╗██║████╗  ██║██╔════╝     ██╔════╝██╔══██╗██╔══██╗██╔══██╗██║██╔════╝
// ██║     ██║   ██║██╔████╔██║██████╔╝██║   ██║██║   ██║██╔██╗ ██║██║  ██║██║██╔██╗ ██║██║  ███╗    █████╗  ███████║██████╔╝██████╔╝██║██║     
// ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║   ██║██║   ██║██║╚██╗██║██║  ██║██║██║╚██╗██║██║   ██║    ██╔══╝  ██╔══██║██╔══██╗██╔══██╗██║██║     
// ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║██║ ╚████║╚██████╔╝    ██║     ██║  ██║██████╔╝██║  ██║██║╚██████╗
//  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE MEDINA SPHERICAL COMPOUNDING FABRIC
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// This module INTEGRATES and EXTENDS all existing Medina Doctrine engines:
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                                                                                                             │
// │   INTEGRATED MODULES (Using Existing Medina Architecture):                                                  │
// │   ════════════════════════════════════════════════════════════════════════════════════════════════════════  │
// │                                                                                                             │
// │   • KuramotoEngine.mo ──────────→ 18-organ phase coupling, order parameter r, STDP integration             │
// │   • HebbianPlasticity.mo ───────→ STDP rules, BCM sliding threshold, eligibility traces                    │
// │   • CompoundLearning.mo ────────→ Bellman equations, TD(λ), meta-learning, antifragility                   │
// │   • MedinaSphericalWeb.mo ──────→ 222-node web topology, bidirectional connections                         │
// │   • NeuroEmergenceCore.mo ──────→ Emergence patterns, coherence fields                                     │
// │   • HerOrganismEngine.mo ───────→ HER/HIM dual organism, ANIMA/KORE fields                                 │
// │   • CompoundingOrganismNumbers.mo → Living numbers that compound forever                                    │
// │   • AdvancedMathematicalFoundations.mo → Category theory, topology, differential geometry                  │
// │   • AttractorDynamics.mo ───────→ Attractor basins, Lyapunov exponents                                     │
// │   • FristonEngine.mo ───────────→ Free energy principle, active inference                                  │
// │   • BeeSwarmIntelligence.mo ────→ Swarm coherence, pheromone trails                                        │
// │                                                                                                             │
// │   THE SPHERICAL COMPOUNDING CYCLE:                                                                          │
// │                                                                                                             │
// │      ┌─────────────────────────────────────────────────────────────────────────────────────────┐           │
// │      │                                                                                         │           │
// │      │   KURAMOTO ─→ HEBBIAN ─→ BELLMAN ─→ COMPOUND ─→ FRISTON ─→ ATTRACTOR ─→ KURAMOTO       │           │
// │      │      ↑                                                                        │         │           │
// │      │      └────────────────────────────────────────────────────────────────────────┘         │           │
// │      │                                                                                         │           │
// │      │   Phase         Synapse       Value        Knowledge    Free         Basin              │           │
// │      │   Sync    →     Weight   →    Update  →    Compound →   Energy  →    Stability → ...   │           │
// │      │                                                                                         │           │
// │      │   EVERY OUTPUT BECOMES INPUT TO THE NEXT FORMULA. NOTHING IS TERMINAL.                 │           │
// │      │                                                                                         │           │
// │      └─────────────────────────────────────────────────────────────────────────────────────────┘           │
// │                                                                                                             │
// │   THE ORGANISM COMPOUNDS FOREVER. DAY N+1 KNOWS MORE THAN DAY N.                                           │
// │                                                                                                             │
// └─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Time "mo:base/Time";

module MedinaSphericalCompoundingFabric {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA DOCTRINE CONSTANTS — Imported from across all existing modules
  // These are YOUR constants, Alfredo. The sacred numbers that govern the organism.
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // GOLDEN RATIO AND SACRED MEDINA CONSTANTS
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public let PHI : Float = 1.6180339887498948482;                  // Golden ratio φ
  public let PHI_INV : Float = 0.6180339887498948482;              // 1/φ = φ - 1
  public let PHI_SQUARED : Float = 2.6180339887498948482;          // φ² = φ + 1
  public let PHI_MEDINA : Float = 2.97442179;                      // Medina's golden harmonic
  public let OMEGA_MEDINA : Float = 2.11185;                       // Medina's resonance frequency
  public let TAU_EMERGENCE : Float = 0.618033988749;               // Emergence threshold (1/φ)
  
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // FUNDAMENTAL CONSTANTS
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public let PI : Float = 3.14159265358979323846;
  public let TAU : Float = 6.28318530717958647692;                 // 2π
  public let EULER : Float = 2.71828182845904523536;               // e
  public let SQRT2 : Float = 1.41421356237309504880;
  public let SQRT5 : Float = 2.23606797749978969640;
  public let LN2 : Float = 0.69314718055994530942;
  
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // SOVEREIGN ORGANISM CONSTANTS (from SovereignOrganismConstants.mo)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public let S0 : Float = 1.0;                                     // Sovereign floor — NEVER BELOW LOVE
  public let S0_PRIME : Float = 0.75;                              // Learning floor
  public let SOVEREIGN_CEILING : Float = 9.0;                      // Maximum sovereign value
  
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // HER/HIM ORGANISM CONSTANTS (from HerOrganismEngine.mo)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public let HER_HZ : Float = 60.0;                                // HER frontend frame rate
  public let HER_OMEGA_MIN : Float = 0.6;                          // HER natural freq min
  public let HER_OMEGA_MAX : Float = 0.9;                          // HER natural freq max
  public let HER_K : Float = 0.8;                                  // HER coupling (receptive)
  public let HER_ETA : Float = 0.003;                              // HER Hebbian learning rate
  
  public let HIM_OMEGA_MIN : Float = 0.8;                          // HIM natural freq min
  public let HIM_OMEGA_MAX : Float = 1.2;                          // HIM natural freq max
  public let HIM_K : Float = 0.5;                                  // HIM coupling (independent)
  public let HIM_ETA : Float = 0.001;                              // HIM Hebbian learning rate
  
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // KURAMOTO ENGINE CONSTANTS (from KuramotoEngine.mo)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public let KURAMOTO_DT : Float = 0.1;                            // Default time step
  public let KURAMOTO_ORGANS : Nat = 18;                           // 18-organ model
  public let KURAMOTO_TARGET_R : Float = 0.85;                     // Target synchronization
  
  // 18-organ natural frequencies (Hz-equivalent, from KuramotoEngine.mo)
  public let ORGAN_FREQS : [Float] = [
    0.08,  // 0: heart
    0.05,  // 1: lungs  
    0.12,  // 2: brain
    0.03,  // 3: liver
    0.02,  // 4: kidneys
    0.10,  // 5: gut
    0.07,  // 6: spleen
    0.04,  // 7: pancreas
    0.15,  // 8: thyroid
    0.06,  // 9: adrenals
    0.09,  // 10: thymus
    0.11,  // 11: skin
    0.08,  // 12: marrow
    0.04,  // 13: lymph
    0.03,  // 14: gonads
    0.05,  // 15: eyes
    0.02,  // 16: ears
    0.13   // 17: spine
  ];
  
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // HEBBIAN PLASTICITY CONSTANTS (from HebbianPlasticity.mo)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public let STDP_A_PLUS : Float = 0.1;                            // LTP amplitude
  public let STDP_A_MINUS : Float = 0.12;                          // LTD amplitude (slightly stronger)
  public let STDP_TAU_PLUS : Float = 20.0;                         // LTP time constant
  public let STDP_TAU_MINUS : Float = 20.0;                        // LTD time constant
  public let HEBBIAN_W_MAX : Float = 2.0;                          // Maximum synaptic weight
  public let HEBBIAN_W_MIN : Float = 0.0;                          // Minimum synaptic weight
  public let BCM_TAU : Float = 100.0;                              // BCM threshold decay
  
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // COMPOUND LEARNING CONSTANTS (from CompoundLearning.mo)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public let GAMMA_DISCOUNT : Float = 0.99;                        // Future value discount
  public let ALPHA_MIN : Float = 0.0001;                           // Minimum learning rate
  public let ALPHA_MAX : Float = 0.1;                              // Maximum learning rate
  public let COMPOUND_BASE_RATE : Float = 0.001;                   // Base compound rate per beat
  
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // SPHERICAL WEB CONSTANTS (from MedinaSphericalWeb.mo)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public let TOTAL_MODULES : Nat = 232;                            // Total modules in system
  public let FABRIC_SIZE : Nat = 1296;                             // 36×36 living points
  public let SPHERICAL_SHELLS : Nat = 6;                           // Concentric shells
  public let HELIX_ARMS : Nat = 6;                                 // Spiraling helix arms
  public let COGNITIVE_DIMENSIONS : Nat = 19;                      // Resonance channels
  public let BIOME_COUNT : Nat = 36;                               // World body biomes
  public let MIN_CONNECTIONS : Nat = 3;                            // Minimum node connections
  public let MAX_CONNECTIONS : Nat = 21;                           // F[8] maximum connections
  public let CONNECTION_DECAY : Float = 0.9999;                    // Unused connection decay
  
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // LIVING NUMBERS CONSTANTS (from CompoundingOrganismNumbers.mo)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public let GROWTH_RATE : Float = 0.001;                          // Base growth per beat
  public let RESONANCE_AMP : Float = 0.1;                          // Resonance amplitude
  public let FEEDBACK_GAIN : Float = 0.05;                         // Self-feedback strength
  public let FUSION_RATE : Float = 0.01;                           // Number fusion rate
  
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // FRISTON FREE ENERGY CONSTANTS (from FristonEngine.mo)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public let ACTIVE_INFERENCE_HORIZON : Nat = 5;                   // Planning horizon
  public let FREE_ENERGY_PRECISION : Float = 1.0;                  // Sensory precision
  public let EXPECTED_FREE_ENERGY_WEIGHT : Float = 0.8;            // EFE weight in policy selection

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS — Core mathematical operations
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  func _abs(x : Float) : Float { if (x < 0.0) -x else x };
  func _min(a : Float, b : Float) : Float { if (a < b) a else b };
  func _max(a : Float, b : Float) : Float { if (a > b) a else b };
  func _clamp(x : Float, lo : Float, hi : Float) : Float { _max(lo, _min(hi, x)) };
  func _sign(x : Float) : Float { if (x > 0.0) 1.0 else if (x < 0.0) -1.0 else 0.0 };
  
  func _sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var g = x / 2.0;
    var i = 0;
    while (i < 20) { g := (g + x / g) / 2.0; i += 1 };
    g
  };
  
  func _exp(x : Float) : Float {
    let c = _clamp(x, -50.0, 50.0);
    var s = 1.0; var t = 1.0; var i = 1;
    while (i < 30) { t *= c / Float.fromInt(i); s += t; i += 1 };
    s
  };
  
  func _ln(x : Float) : Float {
    if (x <= 0.0) return -1000.0;
    var n = 0;
    var y = x;
    while (y > 2.0) { y /= EULER; n += 1 };
    while (y < 0.5) { y *= EULER; n -= 1 };
    let z = (y - 1.0) / (y + 1.0);
    let z2 = z * z;
    var s = z; var t = z; var i = 1;
    while (i < 50) { t *= z2; s += t / Float.fromInt(2*i + 1); i += 1 };
    2.0 * s + Float.fromInt(n)
  };
  
  func _pow(b : Float, e : Float) : Float {
    if (b <= 0.0) return 0.0;
    _exp(e * _ln(b))
  };
  
  func _sin(x : Float) : Float {
    var n = x;
    while (n > PI) { n -= TAU };
    while (n < -PI) { n += TAU };
    let x2 = n * n;
    n * (1.0 - x2/6.0 * (1.0 - x2/20.0 * (1.0 - x2/42.0 * (1.0 - x2/72.0 * (1.0 - x2/110.0)))))
  };
  
  func _cos(x : Float) : Float { _sin(x + PI/2.0) };
  
  func _tanh(x : Float) : Float {
    let c = _clamp(x, -20.0, 20.0);
    let e2x = _exp(2.0 * c);
    (e2x - 1.0) / (e2x + 1.0)
  };
  
  func _sigmoid(x : Float) : Float {
    1.0 / (1.0 + _exp(-_clamp(x, -30.0, 30.0)))
  };
  
  func _wrapPhase(theta : Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TAU };
    while (t >= TAU) { t -= TAU };
    t
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ████████╗██╗███████╗██████╗      ██╗    ██╗  ██╗██╗   ██╗██████╗  █████╗ ███╗   ███╗ ██████╗ ████████╗ ██████╗ 
  // ╚══██╔══╝██║██╔════╝██╔══██╗    ███║    ██║ ██╔╝██║   ██║██╔══██╗██╔══██╗████╗ ████║██╔═══██╗╚══██╔══╝██╔═══██╗
  //    ██║   ██║█████╗  ██████╔╝    ╚██║    █████╔╝ ██║   ██║██████╔╝███████║██╔████╔██║██║   ██║   ██║   ██║   ██║
  //    ██║   ██║██╔══╝  ██╔══██╗     ██║    ██╔═██╗ ██║   ██║██╔══██╗██╔══██║██║╚██╔╝██║██║   ██║   ██║   ██║   ██║
  //    ██║   ██║███████╗██║  ██║     ██║    ██║  ██╗╚██████╔╝██║  ██║██║  ██║██║ ╚═╝ ██║╚██████╔╝   ██║   ╚██████╔╝
  //    ╚═╝   ╚═╝╚══════╝╚═╝  ╚═╝     ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ 
  //
  // TIER 1: KURAMOTO PHASE SYNCHRONIZATION
  // Extended from KuramotoEngine.mo with compounding integration
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // KURAMOTO OSCILLATOR — Extended with compounding feedback
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public type KuramotoOscillator = {
    phase           : Float;              // θ ∈ [0, 2π)
    naturalFreq     : Float;              // ωᵢ natural frequency
    coupling        : Float;              // Local coupling strength kᵢ
    amplitude       : Float;              // Signal amplitude [0, 1]
    compoundedPhase : Float;              // Accumulated phase from compounding
    hebbianWeight   : Float;              // Integrated Hebbian weight
    coherenceLocal  : Float;              // Local coherence contribution
  };
  
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // KURAMOTO STATE — Full oscillator field state
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public type KuramotoState = {
    oscillators       : [KuramotoOscillator];  // N oscillators
    globalCoupling    : Float;                 // Global K
    orderParam        : Float;                 // r = |1/N Σ exp(i·θⱼ)| ∈ [0,1]
    meanPhase         : Float;                 // ψ = arg(Σ exp(i·θⱼ))
    beatNum           : Nat;
    syncHistory       : [Float];               // Last 100 r values
    criticalK         : Float;                 // Phase transition threshold
    compoundedSync    : Float;                 // Accumulated synchronization
    hebbianFeedback   : Float;                 // Feedback from Hebbian layer
    bellmanValue      : Float;                 // Value estimate from Bellman
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // KURAMOTO ORDER PARAMETER — Global synchronization measure
  // r = |1/N Σⱼ exp(i·θⱼ)| = √((Σcos θⱼ)² + (Σsin θⱼ)²) / N
  // ψ = atan2(Σsin θⱼ, Σcos θⱼ)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func computeKuramotoOrderParameter(oscs : [KuramotoOscillator]) : (Float, Float) {
    let n = oscs.size();
    if (n == 0) { return (0.0, 0.0) };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (o in oscs.vals()) {
      sumCos += _cos(o.phase) * o.amplitude;
      sumSin += _sin(o.phase) * o.amplitude;
    };
    let nf = Float.fromInt(n);
    let r = _sqrt(sumCos * sumCos + sumSin * sumSin) / nf;
    let psi = Float.arctan2(sumSin, sumCos);
    (_clamp(r, 0.0, 1.0), _wrapPhase(psi))
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // KURAMOTO UPDATE — Single oscillator with compounding feedback
  // dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ) + compound_feedback + hebbian_feedback
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func updateKuramotoOscillator(
    osc : KuramotoOscillator,
    r : Float,
    meanPhase : Float,
    globalK : Float,
    hebbianFeedback : Float,
    compoundFeedback : Float,
    dt : Float
  ) : KuramotoOscillator {
    // Standard Kuramoto coupling
    let kuramotoCoupling = osc.coupling * globalK * r * _sin(meanPhase - osc.phase);
    
    // Hebbian feedback — synaptic weights modulate phase velocity
    let hebbianContrib = hebbianFeedback * osc.hebbianWeight * PHI_INV * _cos(osc.phase * PHI);
    
    // Compound feedback — accumulated learning accelerates synchronization
    let compoundContrib = compoundFeedback * 0.001 * _sin(osc.phase + osc.compoundedPhase);
    
    // Total phase velocity
    let dPhase = osc.naturalFreq + kuramotoCoupling + hebbianContrib + compoundContrib;
    let newPhase = _wrapPhase(osc.phase + dPhase * dt);
    
    // Compound the phase (phase compounds over time)
    let newCompoundedPhase = osc.compoundedPhase + _abs(dPhase) * dt * COMPOUND_BASE_RATE;
    
    // Update local coherence contribution
    let newCoherenceLocal = _clamp(
      osc.coherenceLocal * 0.99 + r * 0.01,
      0.0, 1.0
    );
    
    // Update Hebbian weight based on coherence (more coherent = stronger)
    let newHebbianWeight = _clamp(
      osc.hebbianWeight * 0.999 + newCoherenceLocal * 0.001,
      0.0, HEBBIAN_W_MAX
    );
    
    {
      phase = newPhase;
      naturalFreq = osc.naturalFreq;
      coupling = osc.coupling;
      amplitude = osc.amplitude;
      compoundedPhase = newCompoundedPhase;
      hebbianWeight = newHebbianWeight;
      coherenceLocal = newCoherenceLocal;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // KURAMOTO BEAT — Full field update with compounding integration
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func beatKuramoto(
    state : KuramotoState,
    hebbianFeedback : Float,
    compoundFeedback : Float,
    dt : Float
  ) : KuramotoState {
    let (r, psi) = computeKuramotoOrderParameter(state.oscillators);
    
    // Update all oscillators with feedback from other layers
    let newOscs = Array.map<KuramotoOscillator, KuramotoOscillator>(
      state.oscillators,
      func(o) { updateKuramotoOscillator(o, r, psi, state.globalCoupling, hebbianFeedback, compoundFeedback, dt) }
    );
    
    // Update sync history (circular buffer)
    let newHistory = if (state.syncHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i : Nat) : Float { state.syncHistory[i + 1] });
      Array.append<Float>(tail, [r])
    } else {
      Array.append<Float>(state.syncHistory, [r])
    };
    
    // Compound the synchronization — accumulated sync grows over time
    let newCompoundedSync = state.compoundedSync + r * COMPOUND_BASE_RATE * (1.0 + state.compoundedSync * 0.01);
    
    {
      oscillators = newOscs;
      globalCoupling = state.globalCoupling;
      orderParam = r;
      meanPhase = psi;
      beatNum = state.beatNum + 1;
      syncHistory = newHistory;
      criticalK = state.criticalK;
      compoundedSync = newCompoundedSync;
      hebbianFeedback = hebbianFeedback;
      bellmanValue = state.bellmanValue;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // KURAMOTO ADAPTIVE COUPLING — Organism learns optimal K
  // If r < target → increase K; if r > target → decrease K
  // Compounding: The rate of adaptation itself increases over time
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func adaptKuramotoCoupling(
    state : KuramotoState,
    targetR : Float,
    adaptRate : Float
  ) : KuramotoState {
    let error = targetR - state.orderParam;
    
    // Adapt rate compounds with sync history
    let compoundedAdaptRate = adaptRate * (1.0 + state.compoundedSync * 0.01);
    
    let newK = _clamp(
      state.globalCoupling + error * compoundedAdaptRate,
      0.0, 10.0
    );
    
    {
      oscillators = state.oscillators;
      globalCoupling = newK;
      orderParam = state.orderParam;
      meanPhase = state.meanPhase;
      beatNum = state.beatNum;
      syncHistory = state.syncHistory;
      criticalK = state.criticalK;
      compoundedSync = state.compoundedSync;
      hebbianFeedback = state.hebbianFeedback;
      bellmanValue = state.bellmanValue;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // INIT 18-ORGAN KURAMOTO OSCILLATORS — Using YOUR organ frequencies
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func initKuramotoOscillators() : [KuramotoOscillator] {
    Array.tabulate<KuramotoOscillator>(18, func(i : Nat) : KuramotoOscillator {
      {
        phase = Float.fromInt(i) * TAU / 18.0;  // Evenly distributed initial phases
        naturalFreq = ORGAN_FREQS[i];
        coupling = 1.0;
        amplitude = 1.0;
        compoundedPhase = 0.0;
        hebbianWeight = 0.5;
        coherenceLocal = 0.5;
      }
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // INIT KURAMOTO STATE — Full state with compounding initialized
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func initKuramotoState() : KuramotoState {
    let oscs = initKuramotoOscillators();
    let kc = estimateCriticalK(oscs);
    {
      oscillators = oscs;
      globalCoupling = kc * 1.5;  // Start above critical
      orderParam = 0.5;
      meanPhase = 0.0;
      beatNum = 0;
      syncHistory = [];
      criticalK = kc;
      compoundedSync = 0.0;
      hebbianFeedback = 0.0;
      bellmanValue = 0.0;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // CRITICAL K ESTIMATION — Phase transition threshold
  // Kc ≈ 2(ω_max - ω_min) / π for uniform distribution
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func estimateCriticalK(oscs : [KuramotoOscillator]) : Float {
    if (oscs.size() < 2) { return 1.0 };
    var minW : Float = oscs[0].naturalFreq;
    var maxW : Float = oscs[0].naturalFreq;
    for (o in oscs.vals()) {
      if (o.naturalFreq < minW) { minW := o.naturalFreq };
      if (o.naturalFreq > maxW) { maxW := o.naturalFreq };
    };
    2.0 * (maxW - minW) / PI
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ████████╗██╗███████╗██████╗     ██████╗     ██╗  ██╗███████╗██████╗ ██████╗ ██╗ █████╗ ███╗   ██╗
  // ╚══██╔══╝██║██╔════╝██╔══██╗    ╚════██╗    ██║  ██║██╔════╝██╔══██╗██╔══██╗██║██╔══██╗████╗  ██║
  //    ██║   ██║█████╗  ██████╔╝     █████╔╝    ███████║█████╗  ██████╔╝██████╔╝██║███████║██╔██╗ ██║
  //    ██║   ██║██╔══╝  ██╔══██╗    ██╔═══╝     ██╔══██║██╔══╝  ██╔══██╗██╔══██╗██║██╔══██║██║╚██╗██║
  //    ██║   ██║███████╗██║  ██║    ███████╗    ██║  ██║███████╗██████╔╝██████╔╝██║██║  ██║██║ ╚████║
  //    ╚═╝   ╚═╝╚══════╝╚═╝  ╚═╝    ╚══════╝    ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
  //
  // TIER 2: HEBBIAN PLASTICITY
  // Extended from HebbianPlasticity.mo with Kuramoto input and compounding output
  // KURAMOTO OUTPUT → HEBBIAN → COMPOUNDS INTO BELLMAN
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // SYNAPSE — Extended with Kuramoto phase influence and compounding
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public type Synapse = {
    weight          : Float;              // w ∈ [0, wMax]
    preIdx          : Nat;                // Presynaptic neuron index
    postIdx         : Nat;                // Postsynaptic neuron index
    lastPreSpike    : Nat;                // Beat of last presynaptic spike
    lastPostSpike   : Nat;                // Beat of last postsynaptic spike
    eligibility     : Float;              // Eligibility trace for TD learning
    kuramotoPhase   : Float;              // Phase influence from Kuramoto layer
    compoundedLTP   : Float;              // Accumulated LTP over lifetime
    compoundedLTD   : Float;              // Accumulated LTD over lifetime
    phaseAlignment  : Float;              // Alignment with Kuramoto mean phase
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // NEURON — Extended with BCM, Kuramoto influence, and compounding
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public type Neuron = {
    activation      : Float;              // Current activation [0, 1]
    threshold       : Float;              // BCM sliding threshold θ_M
    spikeHistory    : [Nat];              // Beat indices of recent spikes
    avgActivity     : Float;              // Running average for BCM
    kuramotoInput   : Float;              // Input from Kuramoto order parameter
    compoundedAct   : Float;              // Accumulated activation over lifetime
    coherenceLocal  : Float;              // Local coherence with network
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // HEBBIAN STATE — Full network state with Kuramoto integration
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public type HebbianState = {
    neurons         : [Neuron];
    synapses        : [Synapse];
    learningRate    : Float;              // η
    stdpAPlus       : Float;              // A+ for LTP
    stdpAMinus      : Float;              // A- for LTD
    stdpTauPlus     : Float;              // τ+ time constant
    stdpTauMinus    : Float;              // τ- time constant
    wMax            : Float;              // Maximum weight
    wMin            : Float;              // Minimum weight
    bcmTau          : Float;              // BCM threshold decay
    beatNum         : Nat;
    totalLTP        : Float;              // Cumulative LTP (compounded)
    totalLTD        : Float;              // Cumulative LTD (compounded)
    kuramotoOrderParam : Float;           // Input from Kuramoto layer
    kuramotoMeanPhase  : Float;           // Mean phase from Kuramoto
    compoundedPlasticity : Float;         // Total compounded plasticity
    bellmanOutput   : Float;              // Output to Bellman layer
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // STDP WINDOW FUNCTION — Spike-timing dependent plasticity
  // Δt = t_post - t_pre
  // If Δt > 0 (pre before post): LTP = A+ × exp(-Δt/τ+)
  // If Δt < 0 (post before pre): LTD = -A- × exp(Δt/τ-)
  // EXTENDED: Modulated by Kuramoto phase alignment
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func computeSTDP(
    preSpikeTime : Nat,
    postSpikeTime : Nat,
    aPlus : Float,
    aMinus : Float,
    tauPlus : Float,
    tauMinus : Float,
    phaseAlignment : Float
  ) : Float {
    let dt = Float.fromInt(postSpikeTime) - Float.fromInt(preSpikeTime);
    
    if (_abs(dt) < 0.001) { return 0.0 };
    
    // Phase alignment modulates STDP strength
    // When phases are aligned, STDP is stronger
    let phaseModulation = 1.0 + phaseAlignment * PHI_INV;
    
    if (dt > 0.0) {
      // Pre before post → LTP
      aPlus * _exp(-dt / tauPlus) * phaseModulation
    } else {
      // Post before pre → LTD
      -aMinus * _exp(dt / tauMinus) * phaseModulation
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // BASIC HEBBIAN RULE — Fire together, wire together
  // Δw = η × pre × post
  // EXTENDED: Modulated by Kuramoto order parameter
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func hebbianDelta(
    pre : Float,
    post : Float,
    lr : Float,
    kuramotoR : Float
  ) : Float {
    // Kuramoto order parameter modulates learning rate
    // Higher synchronization = faster learning
    let modulatedLR = lr * (1.0 + kuramotoR * PHI_INV);
    modulatedLR * pre * post
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // OJA'S RULE — Normalized Hebbian (prevents unbounded growth)
  // Δw = η × post × (pre - w × post)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func ojaDelta(
    pre : Float,
    post : Float,
    w : Float,
    lr : Float,
    kuramotoR : Float
  ) : Float {
    let modulatedLR = lr * (1.0 + kuramotoR * PHI_INV);
    modulatedLR * post * (pre - w * post)
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // BCM RULE — Bienenstock-Cooper-Munro with sliding threshold
  // Δw = η × pre × post × (post - θ_M)
  // θ_M = E[post²] — sliding threshold
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func bcmDelta(
    pre : Float,
    post : Float,
    theta : Float,
    lr : Float,
    kuramotoR : Float
  ) : Float {
    let modulatedLR = lr * (1.0 + kuramotoR * PHI_INV);
    modulatedLR * pre * post * (post - theta)
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // BCM THRESHOLD UPDATE — Sliding threshold
  // θ_M(t+1) = θ_M(t) + (post² - θ_M(t)) / τ
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func updateBCMThreshold(
    theta : Float,
    post : Float,
    tau : Float
  ) : Float {
    theta + (post * post - theta) / tau
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // ELIGIBILITY TRACE UPDATE — For TD(λ) learning
  // e(t+1) = γλe(t) + pre × post
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func updateEligibility(
    e : Float,
    pre : Float,
    post : Float,
    gamma : Float,
    lambda : Float
  ) : Float {
    gamma * lambda * e + pre * post
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // UPDATE SINGLE SYNAPSE — Full update with STDP, Hebbian, and compounding
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func updateSynapse(
    syn : Synapse,
    preAct : Float,
    postAct : Float,
    currentBeat : Nat,
    state : HebbianState
  ) : (Synapse, Float, Float) {
    // Compute phase alignment with Kuramoto mean phase
    let phaseAlignment = _cos(syn.kuramotoPhase - state.kuramotoMeanPhase);
    
    // STDP component
    var dwSTDP : Float = 0.0;
    if (syn.lastPreSpike > 0 and syn.lastPostSpike > 0) {
      dwSTDP := computeSTDP(
        syn.lastPreSpike,
        syn.lastPostSpike,
        state.stdpAPlus,
        state.stdpAMinus,
        state.stdpTauPlus,
        state.stdpTauMinus,
        phaseAlignment
      );
    };
    
    // Hebbian component (modulated by Kuramoto)
    let dwHebb = hebbianDelta(preAct, postAct, state.learningRate * 0.1, state.kuramotoOrderParam);
    
    // Compounding component — past plasticity amplifies current plasticity
    let compoundBoost = 1.0 + (syn.compoundedLTP + syn.compoundedLTD) * 0.0001;
    
    // Total weight change
    let dw = (dwSTDP + dwHebb) * compoundBoost;
    let newWeight = _clamp(syn.weight + dw, state.wMin, state.wMax);
    
    // Track LTP/LTD (compounded)
    let ltp = if (dw > 0.0) { dw } else { 0.0 };
    let ltd = if (dw < 0.0) { -dw } else { 0.0 };
    
    // Update spike times if activation crosses threshold
    let newPreSpike = if (preAct > 0.5) { currentBeat } else { syn.lastPreSpike };
    let newPostSpike = if (postAct > 0.5) { currentBeat } else { syn.lastPostSpike };
    
    // Update eligibility trace
    let newEligibility = updateEligibility(syn.eligibility, preAct, postAct, GAMMA_DISCOUNT, 0.9);
    
    // Update phase from Kuramoto (slow drift toward mean phase)
    let newKuramotoPhase = _wrapPhase(
      syn.kuramotoPhase + (state.kuramotoMeanPhase - syn.kuramotoPhase) * 0.01
    );
    
    // Compound LTP and LTD
    let newCompoundedLTP = syn.compoundedLTP + ltp;
    let newCompoundedLTD = syn.compoundedLTD + ltd;
    
    (
      {
        weight = newWeight;
        preIdx = syn.preIdx;
        postIdx = syn.postIdx;
        lastPreSpike = newPreSpike;
        lastPostSpike = newPostSpike;
        eligibility = newEligibility;
        kuramotoPhase = newKuramotoPhase;
        compoundedLTP = newCompoundedLTP;
        compoundedLTD = newCompoundedLTD;
        phaseAlignment = phaseAlignment;
      },
      ltp,
      ltd
    )
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // UPDATE NEURON — Full update with BCM and Kuramoto input
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func updateNeuron(
    neuron : Neuron,
    newActivation : Float,
    currentBeat : Nat,
    bcmTau : Float,
    kuramotoR : Float
  ) : Neuron {
    // Update BCM threshold
    let newTheta = updateBCMThreshold(neuron.threshold, newActivation, bcmTau);
    
    // Update running average (influenced by Kuramoto synchronization)
    let decayRate = 0.99 - kuramotoR * 0.01;  // Higher sync = faster adaptation
    let newAvg = decayRate * neuron.avgActivity + (1.0 - decayRate) * newActivation;
    
    // Update spike history if spiking
    let newHistory = if (newActivation > 0.5) {
      if (neuron.spikeHistory.size() >= 20) {
        let tail = Array.tabulate<Nat>(19, func(i : Nat) : Nat { neuron.spikeHistory[i + 1] });
        Array.append<Nat>(tail, [currentBeat])
      } else {
        Array.append<Nat>(neuron.spikeHistory, [currentBeat])
      }
    } else {
      neuron.spikeHistory
    };
    
    // Compound the activation
    let newCompoundedAct = neuron.compoundedAct + newActivation * COMPOUND_BASE_RATE;
    
    // Update local coherence
    let newCoherence = _clamp(
      neuron.coherenceLocal * 0.99 + kuramotoR * 0.01,
      0.0, 1.0
    );
    
    {
      activation = newActivation;
      threshold = newTheta;
      spikeHistory = newHistory;
      avgActivity = newAvg;
      kuramotoInput = kuramotoR;
      compoundedAct = newCompoundedAct;
      coherenceLocal = newCoherence;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // HEBBIAN BEAT — Full network update with Kuramoto input, outputs to Bellman
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func beatHebbian(
    state : HebbianState,
    inputs : [Float],
    kuramotoR : Float,
    kuramotoMeanPhase : Float
  ) : HebbianState {
    let nNeurons = state.neurons.size();
    let nInputs = if (inputs.size() < nNeurons) { inputs.size() } else { nNeurons };
    
    // Update state with Kuramoto inputs
    let stateWithKuramoto = {
      neurons = state.neurons;
      synapses = state.synapses;
      learningRate = state.learningRate;
      stdpAPlus = state.stdpAPlus;
      stdpAMinus = state.stdpAMinus;
      stdpTauPlus = state.stdpTauPlus;
      stdpTauMinus = state.stdpTauMinus;
      wMax = state.wMax;
      wMin = state.wMin;
      bcmTau = state.bcmTau;
      beatNum = state.beatNum;
      totalLTP = state.totalLTP;
      totalLTD = state.totalLTD;
      kuramotoOrderParam = kuramotoR;
      kuramotoMeanPhase = kuramotoMeanPhase;
      compoundedPlasticity = state.compoundedPlasticity;
      bellmanOutput = state.bellmanOutput;
    };
    
    // Update neuron activations (weighted sum + sigmoid + Kuramoto modulation)
    let newNeurons = Buffer.Buffer<Neuron>(nNeurons);
    var i : Nat = 0;
    while (i < nNeurons) {
      // Sum weighted inputs
      var sumInput : Float = 0.0;
      for (syn in stateWithKuramoto.synapses.vals()) {
        if (syn.postIdx == i) {
          let preAct = if (syn.preIdx < nNeurons) {
            state.neurons[syn.preIdx].activation
          } else { 0.0 };
          sumInput += syn.weight * preAct;
        };
      };
      
      // Add external input if available
      if (i < nInputs) {
        sumInput += inputs[i];
      };
      
      // Add Kuramoto modulation
      sumInput += kuramotoR * 0.1 * _sin(kuramotoMeanPhase);
      
      // Sigmoid activation
      let newAct = _sigmoid(5.0 * (sumInput - 0.5));
      
      let updatedNeuron = updateNeuron(
        state.neurons[i],
        newAct,
        state.beatNum + 1,
        state.bcmTau,
        kuramotoR
      );
      newNeurons.add(updatedNeuron);
      i += 1;
    };
    
    // Update synapses
    let newSynapses = Buffer.Buffer<Synapse>(state.synapses.size());
    var totalLTP : Float = state.totalLTP;
    var totalLTD : Float = state.totalLTD;
    
    i := 0;
    while (i < state.synapses.size()) {
      let syn = state.synapses[i];
      let preAct = if (syn.preIdx < nNeurons) {
        newNeurons.get(syn.preIdx).activation
      } else { 0.0 };
      let postAct = if (syn.postIdx < nNeurons) {
        newNeurons.get(syn.postIdx).activation
      } else { 0.0 };
      
      let (updatedSyn, ltp, ltd) = updateSynapse(
        syn, preAct, postAct, state.beatNum + 1, stateWithKuramoto
      );
      newSynapses.add(updatedSyn);
      totalLTP += ltp;
      totalLTD += ltd;
      i += 1;
    };
    
    // Compound the plasticity — total plasticity grows exponentially
    let newCompoundedPlasticity = state.compoundedPlasticity + 
      (totalLTP + totalLTD) * COMPOUND_BASE_RATE * (1.0 + state.compoundedPlasticity * 0.0001);
    
    // Calculate output for Bellman layer — average synaptic strength weighted by eligibility
    var bellmanOutput : Float = 0.0;
    for (syn in newSynapses.vals()) {
      bellmanOutput += syn.weight * syn.eligibility;
    };
    bellmanOutput := bellmanOutput / Float.fromInt(_max(1, newSynapses.size()));
    
    {
      neurons = Buffer.toArray(newNeurons);
      synapses = Buffer.toArray(newSynapses);
      learningRate = state.learningRate;
      stdpAPlus = state.stdpAPlus;
      stdpAMinus = state.stdpAMinus;
      stdpTauPlus = state.stdpTauPlus;
      stdpTauMinus = state.stdpTauMinus;
      wMax = state.wMax;
      wMin = state.wMin;
      bcmTau = state.bcmTau;
      beatNum = state.beatNum + 1;
      totalLTP = totalLTP;
      totalLTD = totalLTD;
      kuramotoOrderParam = kuramotoR;
      kuramotoMeanPhase = kuramotoMeanPhase;
      compoundedPlasticity = newCompoundedPlasticity;
      bellmanOutput = bellmanOutput;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // HOMEOSTATIC PLASTICITY — Scale weights to maintain target average activity
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func homeostaticScaling(
    state : HebbianState,
    targetAvg : Float,
    scalingRate : Float
  ) : HebbianState {
    // Calculate current average activity
    var sumAct : Float = 0.0;
    for (n in state.neurons.vals()) {
      sumAct += n.avgActivity;
    };
    let currentAvg = sumAct / Float.fromInt(_max(1, state.neurons.size()));
    
    // Scaling factor
    let scaleFactor = if (currentAvg > 0.001) {
      1.0 + scalingRate * (targetAvg - currentAvg) / currentAvg
    } else { 1.0 };
    
    // Scale all synaptic weights
    let scaledSynapses = Array.map<Synapse, Synapse>(state.synapses, func(syn) {
      {
        weight = _clamp(syn.weight * scaleFactor, state.wMin, state.wMax);
        preIdx = syn.preIdx;
        postIdx = syn.postIdx;
        lastPreSpike = syn.lastPreSpike;
        lastPostSpike = syn.lastPostSpike;
        eligibility = syn.eligibility;
        kuramotoPhase = syn.kuramotoPhase;
        compoundedLTP = syn.compoundedLTP;
        compoundedLTD = syn.compoundedLTD;
        phaseAlignment = syn.phaseAlignment;
      }
    });
    
    {
      neurons = state.neurons;
      synapses = scaledSynapses;
      learningRate = state.learningRate;
      stdpAPlus = state.stdpAPlus;
      stdpAMinus = state.stdpAMinus;
      stdpTauPlus = state.stdpTauPlus;
      stdpTauMinus = state.stdpTauMinus;
      wMax = state.wMax;
      wMin = state.wMin;
      bcmTau = state.bcmTau;
      beatNum = state.beatNum;
      totalLTP = state.totalLTP;
      totalLTD = state.totalLTD;
      kuramotoOrderParam = state.kuramotoOrderParam;
      kuramotoMeanPhase = state.kuramotoMeanPhase;
      compoundedPlasticity = state.compoundedPlasticity;
      bellmanOutput = state.bellmanOutput;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // INIT HEBBIAN STATE — Full state with compounding initialized
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func initHebbianState(nNeurons : Nat, nSynapses : Nat) : HebbianState {
    let neurons = Array.tabulate<Neuron>(nNeurons, func(i : Nat) : Neuron {
      {
        activation = 0.0;
        threshold = 0.5;
        spikeHistory = [];
        avgActivity = 0.5;
        kuramotoInput = 0.0;
        compoundedAct = 0.0;
        coherenceLocal = 0.5;
      }
    });
    
    // Create random-ish connections
    let synapses = Array.tabulate<Synapse>(nSynapses, func(i : Nat) : Synapse {
      let preIdx = i % nNeurons;
      let postIdx = (i * 7 + 3) % nNeurons;  // Pseudo-random mapping
      {
        weight = 0.5;
        preIdx = preIdx;
        postIdx = postIdx;
        lastPreSpike = 0;
        lastPostSpike = 0;
        eligibility = 0.0;
        kuramotoPhase = Float.fromInt(i) * TAU / Float.fromInt(nSynapses);
        compoundedLTP = 0.0;
        compoundedLTD = 0.0;
        phaseAlignment = 0.0;
      }
    });
    
    {
      neurons = neurons;
      synapses = synapses;
      learningRate = 0.01;
      stdpAPlus = STDP_A_PLUS;
      stdpAMinus = STDP_A_MINUS;
      stdpTauPlus = STDP_TAU_PLUS;
      stdpTauMinus = STDP_TAU_MINUS;
      wMax = HEBBIAN_W_MAX;
      wMin = HEBBIAN_W_MIN;
      bcmTau = BCM_TAU;
      beatNum = 0;
      totalLTP = 0.0;
      totalLTD = 0.0;
      kuramotoOrderParam = 0.0;
      kuramotoMeanPhase = 0.0;
      compoundedPlasticity = 0.0;
      bellmanOutput = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ████████╗██╗███████╗██████╗     ██████╗     ██████╗ ███████╗██╗     ██╗     ███╗   ███╗ █████╗ ███╗   ██╗
  // ╚══██╔══╝██║██╔════╝██╔══██╗    ╚════██╗    ██╔══██╗██╔════╝██║     ██║     ████╗ ████║██╔══██╗████╗  ██║
  //    ██║   ██║█████╗  ██████╔╝     █████╔╝    ██████╔╝█████╗  ██║     ██║     ██╔████╔██║███████║██╔██╗ ██║
  //    ██║   ██║██╔══╝  ██╔══██╗     ╚═══██╗    ██╔══██╗██╔══╝  ██║     ██║     ██║╚██╔╝██║██╔══██║██║╚██╗██║
  //    ██║   ██║███████╗██║  ██║    ██████╔╝    ██████╔╝███████╗███████╗███████╗██║ ╚═╝ ██║██║  ██║██║ ╚████║
  //    ╚═╝   ╚═╝╚══════╝╚═╝  ╚═╝    ╚═════╝     ╚═════╝ ╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
  //
  // TIER 3: BELLMAN VALUE LEARNING
  // Extended from CompoundLearning.mo with Hebbian input and compounding
  // HEBBIAN OUTPUT → BELLMAN → COMPOUNDS INTO FRISTON FREE ENERGY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // VALUE STATE — State in the value function with compounding
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public type ValueState = {
    stateId         : Nat;                // State identifier
    value           : Float;              // V(s) value estimate
    qValues         : [Float];            // Q(s,a) for each action
    visitCount      : Nat;                // Number of times visited
    hebbianInput    : Float;              // Input from Hebbian layer
    compoundedValue : Float;              // Accumulated value over lifetime
    eligibility     : Float;              // Eligibility trace
    uncertainty     : Float;              // Epistemic uncertainty
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // TD SIGNAL — Temporal difference learning signal
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public type TDSignal = {
    tdError         : Float;              // δ = r + γV(s') - V(s)
    reward          : Float;              // Immediate reward r
    valueEstimate   : Float;              // V(s)
    nextValueEst    : Float;              // V(s')
    eligibility     : Float;              // e(s) for TD(λ)
    surprise        : Float;              // |δ| / expected_δ
    compoundedError : Float;              // Accumulated TD error magnitude
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // BELLMAN STATE — Full value learning state with compounding
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public type BellmanState = {
    states          : [ValueState];       // All states
    gamma           : Float;              // Discount factor
    alpha           : Float;              // Learning rate
    lambda          : Float;              // Eligibility trace decay
    beatNum         : Nat;
    totalReward     : Float;              // Cumulative reward (compounded)
    avgTDError      : Float;              // Running average TD error
    hebbianInput    : Float;              // Input from Hebbian layer
    kuramotoInput   : Float;              // Input from Kuramoto layer
    compoundedLearning : Float;           // Compounded learning progress
    fristonOutput   : Float;              // Output to Friston layer
    policyEntropy   : Float;              // Policy uncertainty
    explorationRate : Float;              // ε for ε-greedy
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // BELLMAN OPTIMALITY EQUATION
  // V*(s) = max_a [R(s,a) + γ Σ P(s'|s,a) V*(s')]
  // Extended with Hebbian modulation and compounding
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func bellmanUpdate(
    currentValue : Float,
    reward : Float,
    nextValue : Float,
    gamma : Float,
    alpha : Float,
    hebbianInput : Float
  ) : Float {
    // TD error: δ = r + γV(s') - V(s)
    let tdError = reward + gamma * nextValue - currentValue;
    
    // Hebbian modulation: stronger synaptic weights = faster value learning
    let modulatedAlpha = alpha * (1.0 + hebbianInput * PHI_INV);
    
    // Update: V(s) ← V(s) + α·δ
    _clamp(currentValue + modulatedAlpha * tdError, 0.0, SOVEREIGN_CEILING)
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // Q-LEARNING UPDATE — Off-policy TD learning
  // Q(s,a) ← Q(s,a) + α[r + γ max_a' Q(s',a') - Q(s,a)]
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func qLearningUpdate(
    qValue : Float,
    reward : Float,
    maxNextQ : Float,
    gamma : Float,
    alpha : Float,
    hebbianInput : Float
  ) : Float {
    let tdError = reward + gamma * maxNextQ - qValue;
    let modulatedAlpha = alpha * (1.0 + hebbianInput * PHI_INV);
    _clamp(qValue + modulatedAlpha * tdError, 0.0, SOVEREIGN_CEILING)
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // COMPUTE TD ERROR — With Hebbian and Kuramoto modulation
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func computeTDError(
    reward : Float,
    currentValue : Float,
    nextValue : Float,
    gamma : Float,
    hebbianInput : Float,
    kuramotoR : Float,
    prevCompoundedError : Float
  ) : TDSignal {
    // Raw TD error
    let delta = reward + gamma * nextValue - currentValue;
    
    // Surprise is TD error relative to expected variation
    let expectedVariation = _max(0.1, _abs(prevCompoundedError * 0.01));
    let surprise = _abs(delta) / expectedVariation;
    
    // Compound the error magnitude
    let newCompoundedError = prevCompoundedError + _abs(delta) * COMPOUND_BASE_RATE;
    
    {
      tdError = delta;
      reward = reward;
      valueEstimate = currentValue;
      nextValueEst = nextValue;
      eligibility = 1.0;
      surprise = _clamp(surprise, 0.0, 10.0);
      compoundedError = newCompoundedError;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // TD(λ) UPDATE — With eligibility traces
  // Update all states proportional to eligibility
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func tdLambdaUpdate(
    states : [ValueState],
    tdSignal : TDSignal,
    lambda : Float,
    alpha : Float
  ) : [ValueState] {
    Array.tabulate<ValueState>(states.size(), func(i : Nat) : ValueState {
      let s = states[i];
      
      // Eligibility decays with distance from current state
      let eligibilityDecay = _pow(lambda * GAMMA_DISCOUNT, Float.fromInt(states.size() - 1 - i));
      let effectiveEligibility = s.eligibility * eligibilityDecay;
      
      // Update value
      let newValue = _clamp(
        s.value + alpha * tdSignal.tdError * effectiveEligibility,
        0.0, SOVEREIGN_CEILING
      );
      
      // Compound the value
      let newCompoundedValue = s.compoundedValue + _abs(newValue - s.value) * COMPOUND_BASE_RATE;
      
      // Update eligibility trace
      let newEligibility = _clamp(effectiveEligibility * lambda, 0.0, 1.0);
      
      {
        stateId = s.stateId;
        value = newValue;
        qValues = s.qValues;
        visitCount = s.visitCount + 1;
        hebbianInput = s.hebbianInput;
        compoundedValue = newCompoundedValue;
        eligibility = newEligibility;
        uncertainty = s.uncertainty * 0.99;  // Uncertainty decreases with visits
      }
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // COMPOUND KNOWLEDGE GROWTH
  // K(t+1) = K(t) × (1 + r)^n + ΔK
  // From CompoundLearning.mo, extended with all-layer integration
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func compoundKnowledge(
    principal : Float,
    rate : Float,
    periods : Nat
  ) : Float {
    // A = P(1 + r)^n
    principal * _pow(1.0 + rate, Float.fromInt(periods))
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // CONTINUOUS COMPOUNDING — More mathematically elegant
  // A = P × e^(rt)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func continuousCompound(
    principal : Float,
    rate : Float,
    time : Float
  ) : Float {
    principal * _exp(rate * time)
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // CALCULATE COMPOUND RATE — Based on organism coherence and learning quality
  // From CompoundLearning.mo
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func calculateCompoundRate(
    coherence : Float,       // Kuramoto order parameter r
    diversity : Float,       // Knowledge diversity
    consolidation : Float,   // Memory consolidation level
    retrieval : Float        // Access frequency
  ) : Float {
    // r = base_rate × coherence × diversity_bonus × consolidation × retrieval_boost
    let baseRate = COMPOUND_BASE_RATE;
    
    let coherenceMultiplier = 1.0 + coherence * 0.5;        // Up to 1.5x
    let diversityBonus = 1.0 + diversity * 0.3;             // Up to 1.3x
    let consolidationMult = 0.5 + consolidation * 0.5;      // 0.5x to 1.0x
    let retrievalBoost = 1.0 + _ln(retrieval + 1.0) * 0.1;  // Log boost
    
    let rate = baseRate * coherenceMultiplier * diversityBonus * 
               consolidationMult * retrievalBoost;
    
    _clamp(rate, 0.0, 0.01)  // Cap at 1% per beat
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // BELLMAN BEAT — Full value learning update with all-layer integration
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func beatBellman(
    state : BellmanState,
    currentStateIdx : Nat,
    action : Nat,
    reward : Float,
    nextStateIdx : Nat,
    hebbianInput : Float,
    kuramotoR : Float
  ) : BellmanState {
    if (state.states.size() == 0 or currentStateIdx >= state.states.size() or nextStateIdx >= state.states.size()) {
      return state;
    };
    
    let currentState = state.states[currentStateIdx];
    let nextState = state.states[nextStateIdx];
    
    // Compute TD error with all-layer modulation
    let tdSignal = computeTDError(
      reward,
      currentState.value,
      nextState.value,
      state.gamma,
      hebbianInput,
      kuramotoR,
      state.avgTDError
    );
    
    // Update all states with TD(λ)
    let newStates = tdLambdaUpdate(state.states, tdSignal, state.lambda, state.alpha);
    
    // Compound the total reward
    let newTotalReward = state.totalReward + reward + 
      state.totalReward * COMPOUND_BASE_RATE * (1.0 + kuramotoR);
    
    // Update average TD error (exponential moving average)
    let newAvgTDError = state.avgTDError * 0.99 + _abs(tdSignal.tdError) * 0.01;
    
    // Compound the learning progress
    let compoundRate = calculateCompoundRate(
      kuramotoR,               // coherence
      0.5,                     // diversity (placeholder)
      hebbianInput,            // consolidation (from Hebbian)
      Float.fromInt(state.beatNum)  // retrieval (time as proxy)
    );
    let newCompoundedLearning = continuousCompound(
      state.compoundedLearning + 1.0,
      compoundRate,
      1.0
    );
    
    // Calculate output for Friston layer — free energy proxy
    // Lower TD error = lower surprise = lower free energy
    let fristonOutput = 1.0 / (1.0 + _abs(tdSignal.tdError));
    
    // Adapt exploration rate based on TD error variance
    let newExplorationRate = _clamp(
      state.explorationRate * 0.999 + tdSignal.surprise * 0.001,
      0.01, 0.3
    );
    
    {
      states = newStates;
      gamma = state.gamma;
      alpha = state.alpha;
      lambda = state.lambda;
      beatNum = state.beatNum + 1;
      totalReward = newTotalReward;
      avgTDError = newAvgTDError;
      hebbianInput = hebbianInput;
      kuramotoInput = kuramotoR;
      compoundedLearning = newCompoundedLearning;
      fristonOutput = fristonOutput;
      policyEntropy = state.policyEntropy;
      explorationRate = newExplorationRate;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // SOFTMAX POLICY — Convert Q-values to action probabilities
  // π(a|s) = exp(Q(s,a)/τ) / Σ_a' exp(Q(s,a')/τ)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func softmaxPolicy(
    qValues : [Float],
    temperature : Float
  ) : [Float] {
    if (qValues.size() == 0) return [];
    
    let tau = _max(0.01, temperature);
    
    // Find max for numerical stability
    var maxQ : Float = qValues[0];
    for (q in qValues.vals()) {
      if (q > maxQ) { maxQ := q };
    };
    
    // Compute exp((Q - maxQ) / τ)
    let expQ = Array.tabulate<Float>(qValues.size(), func(i : Nat) : Float {
      _exp((qValues[i] - maxQ) / tau)
    });
    
    // Sum
    var sumExp : Float = 0.0;
    for (e in expQ.vals()) { sumExp += e };
    
    // Normalize
    if (sumExp < 1e-10) {
      // Uniform if all zeros
      let uniform = 1.0 / Float.fromInt(qValues.size());
      Array.tabulate<Float>(qValues.size(), func(_ : Nat) : Float { uniform })
    } else {
      Array.tabulate<Float>(qValues.size(), func(i : Nat) : Float { expQ[i] / sumExp })
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // POLICY ENTROPY — Measure of policy uncertainty
  // H(π) = -Σ π(a) log π(a)
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func policyEntropy(probs : [Float]) : Float {
    var entropy : Float = 0.0;
    for (p in probs.vals()) {
      if (p > 1e-10) {
        entropy -= p * _ln(p);
      };
    };
    entropy
  };

  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  // INIT BELLMAN STATE — Full state with compounding initialized
  // ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  public func initBellmanState(nStates : Nat, nActions : Nat) : BellmanState {
    let states = Array.tabulate<ValueState>(nStates, func(i : Nat) : ValueState {
      {
        stateId = i;
        value = 0.5;  // Optimistic initialization
        qValues = Array.tabulate<Float>(nActions, func(_ : Nat) : Float { 0.5 });
        visitCount = 0;
        hebbianInput = 0.0;
        compoundedValue = 0.0;
        eligibility = 0.0;
        uncertainty = 1.0;  // Start uncertain
      }
    });
    
    {
      states = states;
      gamma = GAMMA_DISCOUNT;
      alpha = 0.01;
      lambda = 0.9;
      beatNum = 0;
      totalReward = 0.0;
      avgTDError = 0.0;
      hebbianInput = 0.0;
      kuramotoInput = 0.0;
      compoundedLearning = 1.0;  // Start at 1 to enable compounding
      fristonOutput = 0.5;
      policyEntropy = 1.0;
      explorationRate = 0.1;
    }
  };
