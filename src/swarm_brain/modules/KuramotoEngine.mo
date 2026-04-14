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
  let PHI    : Float = 1.6180339887498948;
  let PHI_INV: Float = 0.6180339887498948;
  let SQRT3  : Float = 1.7320508075688772;  // √3 = Vesica Piscis ratio

  // ══════════════════════════════════════════════════════════════════════════
  // SACRED GEOMETRY 12-NODE HIERARCHY
  // ══════════════════════════════════════════════════════════════════════════
  //
  // The 12 nodes have SPATIAL GEOMETRY:
  //   - 4 BODY nodes: TETRAHEDRON (simplest Platonic solid)
  //   - 8 BRAIN nodes: CUBE/OCTAHEDRON dual (mind duality)
  //
  // Coupling strength ∝ geometric adjacency:
  //   - Tetrahedron edges: 6 connections, coupling = φ
  //   - Cube edges: 12 connections, coupling = 1.0
  //   - Body↔Brain interface: 8 connections, coupling = √3 (Vesica Piscis)
  //
  // This creates the SACRED COUPLING MATRIX:
  //   K[i][j] = φ     if both in tetrahedron (body-body)
  //   K[i][j] = 1.0   if both in cube (brain-brain)
  //   K[i][j] = √3    if body↔brain interface (Vesica Piscis)
  //   K[i][j] = 0     if no geometric connection
  //
  // ══════════════════════════════════════════════════════════════════════════

  // Node type enumeration
  public type NodeType = {
    #Body;   // Tetrahedron node (0-3)
    #Brain;  // Cube node (4-11)
  };

  // 12-node sacred geometry layout
  // Body: 0=heart, 1=gut, 2=adrenals, 3=gonads
  // Brain: 4=prefrontal, 5=motor, 6=sensory, 7=visual, 
  //        8=auditory, 9=limbic, 10=memory, 11=executive
  public let NODE_TYPES : [NodeType] = [
    #Body,  // 0: heart
    #Body,  // 1: gut
    #Body,  // 2: adrenals
    #Body,  // 3: gonads
    #Brain, // 4: prefrontal
    #Brain, // 5: motor
    #Brain, // 6: sensory
    #Brain, // 7: visual
    #Brain, // 8: auditory
    #Brain, // 9: limbic
    #Brain, // 10: memory
    #Brain, // 11: executive
  ];

  // 12×12 Sacred Coupling Matrix
  // Encodes the geometric adjacency of the 12 nodes
  public let SACRED_COUPLING_MATRIX : [[Float]] = [
    // Row 0: heart (tetrahedron vertex)
    [0.0, PHI, PHI, PHI, SQRT3, 0.0, 0.0, 0.0, 0.0, SQRT3, 0.0, 0.0],
    // Row 1: gut (tetrahedron vertex)
    [PHI, 0.0, PHI, PHI, 0.0, 0.0, SQRT3, 0.0, 0.0, SQRT3, 0.0, 0.0],
    // Row 2: adrenals (tetrahedron vertex)
    [PHI, PHI, 0.0, PHI, 0.0, SQRT3, 0.0, 0.0, 0.0, SQRT3, 0.0, SQRT3],
    // Row 3: gonads (tetrahedron vertex)
    [PHI, PHI, PHI, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SQRT3, 0.0, 0.0],
    // Row 4: prefrontal (cube vertex)
    [SQRT3, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0],
    // Row 5: motor (cube vertex)
    [0.0, 0.0, SQRT3, 0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0],
    // Row 6: sensory (cube vertex)
    [0.0, SQRT3, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0],
    // Row 7: visual (cube vertex)
    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0],
    // Row 8: auditory (cube vertex)
    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0],
    // Row 9: limbic (cube vertex — emotional center)
    [SQRT3, SQRT3, SQRT3, SQRT3, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0],
    // Row 10: memory (cube vertex)
    [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0],
    // Row 11: executive (cube vertex)
    [0.0, 0.0, SQRT3, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0]
  ];

  // Get coupling strength between two nodes using sacred geometry
  public func getSacredCoupling(node_i: Nat, node_j: Nat) : Float {
    if (node_i >= 12 or node_j >= 12) { return 0.0 };
    SACRED_COUPLING_MATRIX[node_i][node_j]
  };

  // Total sacred coupling for a node (sum of all connections)
  public func totalSacredCoupling(node: Nat) : Float {
    if (node >= 12) { return 0.0 };
    var total : Float = 0.0;
    for (coupling in SACRED_COUPLING_MATRIX[node].vals()) {
      total += coupling;
    };
    total
  };

  // 12-node natural frequencies (octave geometric sequence)
  // fd(k) = 2.5 × 2^(k-4) Hz for k = 0..11
  // This creates octave relationships between nodes
  public let SACRED_NODE_FREQS : [Float] = [
    0.15625,  // 0: heart      = 2.5 × 2^(-4) = 2.5/16
    0.3125,   // 1: gut        = 2.5 × 2^(-3) = 2.5/8
    0.625,    // 2: adrenals   = 2.5 × 2^(-2) = 2.5/4
    1.25,     // 3: gonads     = 2.5 × 2^(-1) = 2.5/2
    2.5,      // 4: prefrontal = 2.5 × 2^0 = 2.5
    5.0,      // 5: motor      = 2.5 × 2^1 = 5
    10.0,     // 6: sensory    = 2.5 × 2^2 = 10
    20.0,     // 7: visual     = 2.5 × 2^3 = 20
    40.0,     // 8: auditory   = 2.5 × 2^4 = 40
    80.0,     // 9: limbic     = 2.5 × 2^5 = 80
    160.0,    // 10: memory    = 2.5 × 2^6 = 160
    320.0     // 11: executive = 2.5 × 2^7 = 320
  ];

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

  // ══════════════════════════════════════════════════════════════════════════
  // SACRED KURAMOTO UPDATE — Using geometric coupling matrix
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Standard Kuramoto: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  // Sacred Kuramoto:   dθᵢ/dt = ωᵢ + Σⱼ K[i][j] sin(θⱼ - θᵢ)
  //
  // The coupling matrix K[i][j] encodes:
  //   - φ for body-body (tetrahedron edges)
  //   - √3 for body-brain interface (Vesica Piscis)
  //   - 1.0 for brain-brain (cube edges)
  //
  // ══════════════════════════════════════════════════════════════════════════

  public type SacredOscillator = {
    phase      : Float;   // θ ∈ [0, 2π)
    naturalFreq: Float;   // ωᵢ (from SACRED_NODE_FREQS)
    nodeType   : NodeType;
    amplitude  : Float;   // Signal strength
    nodeIndex  : Nat;     // 0-11
  };

  public type SacredKuramotoState = {
    oscillators     : [SacredOscillator];  // 12 sacred nodes
    globalK         : Float;                // Base coupling strength
    orderParam      : Float;                // r ∈ [0,1]
    meanPhase       : Float;                // ψ
    bodyCoherence   : Float;                // Tetrahedron sync
    brainCoherence  : Float;                // Cube sync
    interfaceSync   : Float;                // Body↔Brain sync
    beatNum         : Nat;
  };

  // Update single sacred oscillator using geometric coupling
  func updateSacredOscillator(
    osc: SacredOscillator,
    allOscs: [SacredOscillator],
    globalK: Float,
    dt: Float
  ) : SacredOscillator {
    // Sum coupling influences from all connected nodes
    var dTheta : Float = osc.naturalFreq;  // Start with natural frequency
    
    var j = 0;
    while (j < 12) {
      if (j != osc.nodeIndex) {
        let coupling = getSacredCoupling(osc.nodeIndex, j);
        if (coupling > 0.0) {
          // Kuramoto coupling term: K[i][j] × sin(θⱼ - θᵢ)
          let phaseDiff = allOscs[j].phase - osc.phase;
          dTheta += globalK * coupling * Float.sin(phaseDiff);
        };
      };
      j += 1;
    };
    
    {
      phase = wrapPhase(osc.phase + dTheta * dt);
      naturalFreq = osc.naturalFreq;
      nodeType = osc.nodeType;
      amplitude = osc.amplitude;
      nodeIndex = osc.nodeIndex;
    }
  };

  // Compute body coherence (tetrahedron nodes 0-3)
  public func computeBodyCoherence(oscs: [SacredOscillator]) : Float {
    if (oscs.size() < 4) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < 4) {
      sumCos += Float.cos(oscs[i].phase);
      sumSin += Float.sin(oscs[i].phase);
      i += 1;
    };
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / 4.0
  };

  // Compute brain coherence (cube nodes 4-11)
  public func computeBrainCoherence(oscs: [SacredOscillator]) : Float {
    if (oscs.size() < 12) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 4;
    while (i < 12) {
      sumCos += Float.cos(oscs[i].phase);
      sumSin += Float.sin(oscs[i].phase);
      i += 1;
    };
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / 8.0
  };

  // Compute body-brain interface sync (connections with √3 coupling)
  public func computeInterfaceSync(oscs: [SacredOscillator]) : Float {
    if (oscs.size() < 12) { return 0.0 };
    // Average phase coherence across all body-brain connections
    var syncSum : Float = 0.0;
    var connections : Nat = 0;
    
    // Body nodes (0-3) connected to limbic (9) via √3
    var body = 0;
    while (body < 4) {
      let phaseDiff = Float.abs(oscs[body].phase - oscs[9].phase);
      syncSum += Float.cos(phaseDiff);  // cos(0) = 1 for perfect sync
      connections += 1;
      body += 1;
    };
    
    if (connections > 0) {
      (syncSum / Float.fromInt(connections) + 1.0) / 2.0  // Normalize to [0,1]
    } else { 0.5 }
  };

  // Initialize sacred 12-node Kuramoto system
  public func initSacredKuramoto() : SacredKuramotoState {
    let oscs = Array.tabulate<SacredOscillator>(12, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / 12.0;  // Evenly distributed initial phases
        naturalFreq = SACRED_NODE_FREQS[i];
        nodeType = NODE_TYPES[i];
        amplitude = 1.0;
        nodeIndex = i;
      }
    });
    
    {
      oscillators = oscs;
      globalK = PHI;  // Golden ratio base coupling
      orderParam = 0.0;
      meanPhase = 0.0;
      bodyCoherence = 0.0;
      brainCoherence = 0.0;
      interfaceSync = 0.0;
      beatNum = 0;
    }
  };

  // Tick sacred Kuramoto system
  public func tickSacredKuramoto(
    state: SacredKuramotoState,
    dt: Float,
    beat: Nat
  ) : SacredKuramotoState {
    // Update all oscillators
    let newOscs = Array.tabulate<SacredOscillator>(12, func(i) {
      updateSacredOscillator(state.oscillators[i], state.oscillators, state.globalK, dt)
    });
    
    // Compute order parameter for all 12 nodes
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (osc in newOscs.vals()) {
      sumCos += Float.cos(osc.phase);
      sumSin += Float.sin(osc.phase);
    };
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / 12.0;
    let psi = Float.arctan2(sumSin, sumCos);
    
    {
      oscillators = newOscs;
      globalK = state.globalK;
      orderParam = _clamp(r, 0.0, 1.0);
      meanPhase = wrapPhase(psi);
      bodyCoherence = computeBodyCoherence(newOscs);
      brainCoherence = computeBrainCoherence(newOscs);
      interfaceSync = computeInterfaceSync(newOscs);
      beatNum = beat;
    }
  };

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

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: ADVANCED MATHEMATICAL FOUNDATIONS — KURAMOTO-SAKAGUCHI EXTENSION
  // ═══════════════════════════════════════════════════════════════════════════════
  // The Kuramoto-Sakaguchi model adds a phase frustration parameter α:
  // dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ - α)
  // When α ≠ 0, the system exhibits frustration and can support traveling waves
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Extended Kuramoto state with Sakaguchi frustration
  public type KuramotoSakaguchiState = {
    oscillators     : [Oscillator];
    globalCoupling  : Float;
    frustration     : Float;           // α - phase lag parameter
    orderParam      : Float;
    meanPhase       : Float;
    beatNum         : Nat;
    syncHistory     : [Float];
    criticalK       : Float;
    // Extended observables
    groupVelocity   : Float;           // Ω - collective frequency
    susceptibility  : Float;           // χ - response to perturbation
    lyapunovExp     : Float;           // λ - stability measure
  };

  /// Initialize Kuramoto-Sakaguchi state
  public func initKuramotoSakaguchi(frustration : Float) : KuramotoSakaguchiState {
    let oscs = initOrganOscillators();
    let kc = estimateCriticalK(oscs);
    {
      oscillators    = oscs;
      globalCoupling = kc * 1.5;
      frustration    = frustration;
      orderParam     = 0.5;
      meanPhase      = 0.0;
      beatNum        = 0;
      syncHistory    = [];
      criticalK      = kc;
      groupVelocity  = 0.0;
      susceptibility = 1.0;
      lyapunovExp    = 0.0;
    }
  };

  /// Sakaguchi update with frustration
  func updateOscillatorSakaguchi(
    osc: Oscillator, r: Float, meanPhase: Float, globalK: Float, alpha: Float, dt: Float
  ) : Oscillator {
    // dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ - α)
    let phaseDiff = meanPhase - osc.phase - alpha;
    let coupling = osc.coupling * globalK * r * Float.sin(phaseDiff);
    let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
    {
      phase = newPhase;
      naturalFreq = osc.naturalFreq;
      coupling = osc.coupling;
      amplitude = osc.amplitude;
    }
  };

  /// Full beat update for Sakaguchi model
  public func beatKuramotoSakaguchi(state: KuramotoSakaguchiState, dt: Float) : KuramotoSakaguchiState {
    let (r, psi) = computeOrderParameter(state.oscillators);
    
    // Compute group velocity (collective rotation speed)
    let oldPsi = state.meanPhase;
    var dPsi = psi - oldPsi;
    if (dPsi > PI) { dPsi -= TWO_PI };
    if (dPsi < -PI) { dPsi += TWO_PI };
    let omega = dPsi / dt;
    
    // Update oscillators with frustration
    let newOscs = Array.map<Oscillator, Oscillator>(
      state.oscillators,
      func(o) { updateOscillatorSakaguchi(o, r, psi, state.globalCoupling, state.frustration, dt) }
    );
    
    // Susceptibility: χ = dr/dK ≈ Δr / ΔK (linearized response)
    let chi = if (state.globalCoupling > 0.01) { r / state.globalCoupling } else { 1.0 };
    
    // Estimate Lyapunov exponent from phase variance growth
    let variance = syncVarianceFromOscs(newOscs, psi);
    let oldVariance = syncVarianceFromOscs(state.oscillators, oldPsi);
    let lyap = if (oldVariance > 1e-10 and variance > 1e-10) {
      Float.log(variance / oldVariance) / (2.0 * dt)
    } else { 0.0 };
    
    // Update sync history
    let newHistory = if (state.syncHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i) { state.syncHistory[i + 1] });
      Array.append<Float>(tail, [r])
    } else {
      Array.append<Float>(state.syncHistory, [r])
    };
    
    {
      oscillators    = newOscs;
      globalCoupling = state.globalCoupling;
      frustration    = state.frustration;
      orderParam     = r;
      meanPhase      = psi;
      beatNum        = state.beatNum + 1;
      syncHistory    = newHistory;
      criticalK      = state.criticalK;
      groupVelocity  = omega;
      susceptibility = _clamp(chi, 0.0, 100.0);
      lyapunovExp    = _clamp(lyap, -10.0, 10.0);
    }
  };

  /// Helper: compute phase variance from oscillators
  func syncVarianceFromOscs(oscs: [Oscillator], psi: Float) : Float {
    let n = oscs.size();
    if (n == 0) { return 0.0 };
    var sumSq : Float = 0.0;
    for (o in oscs.vals()) {
      let diff = wrapPhase(o.phase - psi);
      let centered = if (diff > PI) { diff - TWO_PI } else { diff };
      sumSq += centered * centered;
    };
    sumSq / Float.fromInt(n)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: MULTI-POPULATION KURAMOTO — CHIMERA STATES & METACLUSTERS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Multiple coupled oscillator populations with inter- and intra-coupling
  // Enables emergent chimera states where coherent and incoherent regions coexist
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Population of oscillators with local order parameter
  public type OscillatorPopulation = {
    oscillators    : [Oscillator];
    localR         : Float;            // Local order parameter
    localPsi       : Float;            // Local mean phase
    intraCoupling  : Float;            // Coupling within population
    label          : Nat;              // Population identifier
  };

  /// Multi-population Kuramoto state
  public type MultiPopKuramotoState = {
    populations    : [OscillatorPopulation];
    interCoupling  : [[Float]];        // Inter-population coupling matrix
    globalR        : Float;
    globalPsi      : Float;
    beatNum        : Nat;
    chimeraIndex   : Float;            // Measures chimera-ness
    metastability  : Float;            // Temporal variability of order
  };

  /// Initialize multi-population system
  public func initMultiPopKuramoto(popCount: Nat, oscsPerPop: Nat, interK: Float) : MultiPopKuramotoState {
    // Create populations with different natural frequency distributions
    var pops : [OscillatorPopulation] = [];
    
    for (p in Array.keys(Array.tabulate<Nat>(popCount, func(i) { i }))) {
      // Each population has a different frequency band
      let baseFreq = 0.05 + Float.fromInt(p) * 0.03;
      let spread = 0.02;
      
      var oscs : [Oscillator] = [];
      for (i in Array.keys(Array.tabulate<Nat>(oscsPerPop, func(j) { j }))) {
        let phase = Float.fromInt(i) * TWO_PI / Float.fromInt(oscsPerPop);
        let freq = baseFreq + (Float.fromInt(i) - Float.fromInt(oscsPerPop) / 2.0) * spread / Float.fromInt(oscsPerPop);
        oscs := Array.append(oscs, [{
          phase = phase;
          naturalFreq = freq;
          coupling = 1.0;
          amplitude = 1.0;
        }]);
      };
      
      let (r, psi) = computeOrderParameter(oscs);
      pops := Array.append(pops, [{
        oscillators = oscs;
        localR = r;
        localPsi = psi;
        intraCoupling = 0.5;
        label = p;
      }]);
    };
    
    // Create inter-population coupling matrix (symmetric)
    let coupling = Array.tabulate<[Float]>(popCount, func(i) {
      Array.tabulate<Float>(popCount, func(j) {
        if (i == j) { 0.0 } else { interK }
      })
    });
    
    {
      populations = pops;
      interCoupling = coupling;
      globalR = 0.5;
      globalPsi = 0.0;
      beatNum = 0;
      chimeraIndex = 0.0;
      metastability = 0.0;
    }
  };

  /// Compute chimera index: variance of local order parameters
  public func computeChimeraIndex(state: MultiPopKuramotoState) : Float {
    let n = state.populations.size();
    if (n < 2) { return 0.0 };
    
    // Mean of local R values
    var meanR : Float = 0.0;
    for (pop in state.populations.vals()) {
      meanR += pop.localR;
    };
    meanR := meanR / Float.fromInt(n);
    
    // Variance of local R values
    var varR : Float = 0.0;
    for (pop in state.populations.vals()) {
      let diff = pop.localR - meanR;
      varR += diff * diff;
    };
    varR := varR / Float.fromInt(n);
    
    // High variance = chimera (some populations sync, others don't)
    Float.sqrt(varR)
  };

  /// Update multi-population system
  public func beatMultiPopKuramoto(state: MultiPopKuramotoState, dt: Float) : MultiPopKuramotoState {
    let popCount = state.populations.size();
    var newPops : [OscillatorPopulation] = [];
    
    // Update each population
    for (pIdx in Array.keys(state.populations)) {
      let pop = state.populations[pIdx];
      let (localR, localPsi) = computeOrderParameter(pop.oscillators);
      
      // Compute effective field from other populations
      var interFieldCos : Float = 0.0;
      var interFieldSin : Float = 0.0;
      for (qIdx in Array.keys(state.populations)) {
        if (pIdx != qIdx) {
          let otherPop = state.populations[qIdx];
          let coupling = state.interCoupling[pIdx][qIdx];
          interFieldCos += coupling * otherPop.localR * Float.cos(otherPop.localPsi);
          interFieldSin += coupling * otherPop.localR * Float.sin(otherPop.localPsi);
        };
      };
      let interR = Float.sqrt(interFieldCos * interFieldCos + interFieldSin * interFieldSin);
      let interPsi = Float.arctan2(interFieldSin, interFieldCos);
      
      // Update oscillators with both intra and inter coupling
      let newOscs = Array.map<Oscillator, Oscillator>(pop.oscillators, func(osc) {
        let intraForce = pop.intraCoupling * localR * Float.sin(localPsi - osc.phase);
        let interForce = interR * Float.sin(interPsi - osc.phase);
        let totalForce = intraForce + interForce;
        let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + totalForce) * dt);
        {
          phase = newPhase;
          naturalFreq = osc.naturalFreq;
          coupling = osc.coupling;
          amplitude = osc.amplitude;
        }
      });
      
      let (newR, newPsi) = computeOrderParameter(newOscs);
      newPops := Array.append(newPops, [{
        oscillators = newOscs;
        localR = newR;
        localPsi = newPsi;
        intraCoupling = pop.intraCoupling;
        label = pop.label;
      }]);
    };
    
    // Compute global order parameter from all oscillators
    var allOscs : [Oscillator] = [];
    for (pop in newPops.vals()) {
      allOscs := Array.append(allOscs, pop.oscillators);
    };
    let (globalR, globalPsi) = computeOrderParameter(allOscs);
    
    // Compute chimera index
    let chi = computeChimeraIndex({ 
      populations = newPops; 
      interCoupling = state.interCoupling; 
      globalR = globalR; 
      globalPsi = globalPsi; 
      beatNum = state.beatNum + 1; 
      chimeraIndex = 0.0; 
      metastability = 0.0 
    });
    
    // Metastability: temporal variance of global R (approx)
    let meta = Float.abs(globalR - state.globalR) * 10.0;
    
    {
      populations = newPops;
      interCoupling = state.interCoupling;
      globalR = globalR;
      globalPsi = globalPsi;
      beatNum = state.beatNum + 1;
      chimeraIndex = chi;
      metastability = _clamp(meta, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: HIERARCHICAL KURAMOTO — MULTI-SCALE OSCILLATOR DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Oscillators organized in a hierarchy: micro → meso → macro levels
  // Each level has its own timescale and influences adjacent levels
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Hierarchical level with its own timescale
  public type HierarchicalLevel = {
    oscillators    : [Oscillator];
    levelR         : Float;
    levelPsi       : Float;
    timeScale      : Float;            // τ - characteristic time
    upCoupling     : Float;            // Coupling to level above
    downCoupling   : Float;            // Coupling to level below
    levelIndex     : Nat;
  };

  /// Hierarchical Kuramoto state
  public type HierarchicalKuramotoState = {
    levels         : [HierarchicalLevel];
    crossLevelSync : [Float];          // Synchronization between adjacent levels
    totalR         : Float;
    beatNum        : Nat;
    timeSeparation : Float;            // Ratio of timescales between levels
  };

  /// Initialize hierarchical Kuramoto (3 levels: micro, meso, macro)
  public func initHierarchicalKuramoto(timeSep: Float) : HierarchicalKuramotoState {
    // Micro level: fast oscillators (neural spikes)
    let microOscs = Array.tabulate<Oscillator>(26, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / 26.0;
        naturalFreq = 0.1 + Float.fromInt(i % 5) * 0.02;
        coupling = 1.0;
        amplitude = 1.0;
      }
    });
    let (microR, microPsi) = computeOrderParameter(microOscs);
    
    // Meso level: medium oscillators (local field potentials)
    let mesoOscs = Array.tabulate<Oscillator>(12, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / 12.0;
        naturalFreq = 0.1 / timeSep + Float.fromInt(i % 3) * 0.01;
        coupling = 1.0;
        amplitude = 1.0;
      }
    });
    let (mesoR, mesoPsi) = computeOrderParameter(mesoOscs);
    
    // Macro level: slow oscillators (global brain states)
    let macroOscs = Array.tabulate<Oscillator>(6, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / 6.0;
        naturalFreq = 0.1 / (timeSep * timeSep) + Float.fromInt(i % 2) * 0.005;
        coupling = 1.0;
        amplitude = 1.0;
      }
    });
    let (macroR, macroPsi) = computeOrderParameter(macroOscs);
    
    let levels = [
      {
        oscillators = microOscs;
        levelR = microR;
        levelPsi = microPsi;
        timeScale = 1.0;
        upCoupling = 0.3;
        downCoupling = 0.0;
        levelIndex = 0;
      },
      {
        oscillators = mesoOscs;
        levelR = mesoR;
        levelPsi = mesoPsi;
        timeScale = timeSep;
        upCoupling = 0.2;
        downCoupling = 0.4;
        levelIndex = 1;
      },
      {
        oscillators = macroOscs;
        levelR = macroR;
        levelPsi = macroPsi;
        timeScale = timeSep * timeSep;
        upCoupling = 0.0;
        downCoupling = 0.3;
        levelIndex = 2;
      }
    ];
    
    {
      levels = levels;
      crossLevelSync = [0.5, 0.5];
      totalR = (microR + mesoR + macroR) / 3.0;
      beatNum = 0;
      timeSeparation = timeSep;
    }
  };

  /// Update hierarchical system with cross-scale interactions
  public func beatHierarchicalKuramoto(state: HierarchicalKuramotoState, dt: Float) : HierarchicalKuramotoState {
    let numLevels = state.levels.size();
    var newLevels : [HierarchicalLevel] = [];
    var crossSync : [Float] = [];
    
    for (lIdx in Array.keys(state.levels)) {
      let level = state.levels[lIdx];
      let effectiveDt = dt / level.timeScale;
      
      // Get influence from adjacent levels
      var upperField : Float = 0.0;
      var upperPhase : Float = 0.0;
      var lowerField : Float = 0.0;
      var lowerPhase : Float = 0.0;
      
      if (lIdx > 0) {
        let below = state.levels[lIdx - 1];
        lowerField := below.levelR * level.downCoupling;
        lowerPhase := below.levelPsi;
      };
      if (lIdx + 1 < numLevels) {
        let above = state.levels[lIdx + 1];
        upperField := above.levelR * level.upCoupling;
        upperPhase := above.levelPsi;
      };
      
      // Update oscillators with multi-scale coupling
      let (localR, localPsi) = computeOrderParameter(level.oscillators);
      let newOscs = Array.map<Oscillator, Oscillator>(level.oscillators, func(osc) {
        let localForce = 0.5 * localR * Float.sin(localPsi - osc.phase);
        let upperForce = upperField * Float.sin(upperPhase - osc.phase);
        let lowerForce = lowerField * Float.sin(lowerPhase - osc.phase);
        let totalForce = localForce + upperForce + lowerForce;
        let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + totalForce) * effectiveDt);
        {
          phase = newPhase;
          naturalFreq = osc.naturalFreq;
          coupling = osc.coupling;
          amplitude = osc.amplitude;
        }
      });
      
      let (newR, newPsi) = computeOrderParameter(newOscs);
      newLevels := Array.append(newLevels, [{
        oscillators = newOscs;
        levelR = newR;
        levelPsi = newPsi;
        timeScale = level.timeScale;
        upCoupling = level.upCoupling;
        downCoupling = level.downCoupling;
        levelIndex = level.levelIndex;
      }]);
      
      // Compute cross-level synchronization
      if (lIdx + 1 < numLevels) {
        let nextLevel = state.levels[lIdx + 1];
        let phaseDiff = Float.abs(newPsi - nextLevel.levelPsi);
        let sync = Float.cos(phaseDiff) * newR * nextLevel.levelR;
        crossSync := Array.append(crossSync, [_clamp((sync + 1.0) / 2.0, 0.0, 1.0)]);
      };
    };
    
    // Total order parameter (weighted by level size)
    var totalR : Float = 0.0;
    var totalWeight : Float = 0.0;
    for (level in newLevels.vals()) {
      let weight = Float.fromInt(level.oscillators.size());
      totalR += level.levelR * weight;
      totalWeight += weight;
    };
    totalR := totalR / totalWeight;
    
    {
      levels = newLevels;
      crossLevelSync = crossSync;
      totalR = totalR;
      beatNum = state.beatNum + 1;
      timeSeparation = state.timeSeparation;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: NOISE-DRIVEN KURAMOTO — STOCHASTIC SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  // Adding noise to the Kuramoto model reveals synchronization robustness
  // Langevin dynamics: dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ) + ση(t)
  // where η(t) is Gaussian white noise
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Stochastic Kuramoto state
  public type StochasticKuramotoState = {
    oscillators     : [Oscillator];
    globalCoupling  : Float;
    noiseStrength   : Float;           // σ - noise intensity
    orderParam      : Float;
    meanPhase       : Float;
    beatNum         : Nat;
    // Stochastic observables
    orderParamVar   : Float;           // Temporal variance of r
    phaseDiffusion  : Float;           // D - diffusion coefficient
    snr             : Float;           // Signal-to-noise ratio
    seed            : Nat;             // PRNG seed state
  };

  /// Simple linear congruential generator for pseudo-random numbers
  func lcgNext(seed: Nat) : (Nat, Float) {
    let a : Nat = 1103515245;
    let c : Nat = 12345;
    let m : Nat = 2147483648;  // 2^31
    let newSeed = (a * seed + c) % m;
    let uniform = Float.fromInt(newSeed) / Float.fromInt(m);
    (newSeed, uniform)
  };

  /// Box-Muller transform for Gaussian noise
  func gaussianNoise(seed: Nat) : (Nat, Float) {
    let (seed1, u1) = lcgNext(seed);
    let (seed2, u2) = lcgNext(seed1);
    // Avoid log(0)
    let u1Safe = if (u1 < 1e-10) { 1e-10 } else { u1 };
    let z = Float.sqrt(-2.0 * Float.log(u1Safe)) * Float.cos(TWO_PI * u2);
    (seed2, z)
  };

  /// Initialize stochastic Kuramoto
  public func initStochasticKuramoto(noiseStrength: Float, seed: Nat) : StochasticKuramotoState {
    let oscs = initOrganOscillators();
    {
      oscillators    = oscs;
      globalCoupling = 1.5;
      noiseStrength  = noiseStrength;
      orderParam     = 0.5;
      meanPhase      = 0.0;
      beatNum        = 0;
      orderParamVar  = 0.0;
      phaseDiffusion = 0.0;
      snr            = 1.0;
      seed           = seed;
    }
  };

  /// Update stochastic Kuramoto with noise injection
  public func beatStochasticKuramoto(state: StochasticKuramotoState, dt: Float) : StochasticKuramotoState {
    let (r, psi) = computeOrderParameter(state.oscillators);
    
    var currentSeed = state.seed;
    var newOscs : [Oscillator] = [];
    var totalNoiseSq : Float = 0.0;
    
    for (osc in state.oscillators.vals()) {
      // Generate Gaussian noise for this oscillator
      let (nextSeed, noise) = gaussianNoise(currentSeed);
      currentSeed := nextSeed;
      
      // Langevin update: dθ = (ω + K·r·sin(ψ-θ))dt + σ√dt·η
      let deterministicPart = osc.naturalFreq + state.globalCoupling * r * Float.sin(psi - osc.phase);
      let stochasticPart = state.noiseStrength * Float.sqrt(dt) * noise;
      let newPhase = wrapPhase(osc.phase + deterministicPart * dt + stochasticPart);
      
      totalNoiseSq += noise * noise;
      
      newOscs := Array.append(newOscs, [{
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }]);
    };
    
    let (newR, newPsi) = computeOrderParameter(newOscs);
    
    // Update order parameter variance (exponential moving average)
    let rDiff = newR - state.orderParam;
    let newVar = 0.9 * state.orderParamVar + 0.1 * rDiff * rDiff;
    
    // Phase diffusion: D ≈ σ²/2 for free diffusion
    let D = state.noiseStrength * state.noiseStrength / 2.0;
    
    // Signal-to-noise ratio: SNR = r / sqrt(var(r))
    let snr = if (newVar > 1e-10) { newR / Float.sqrt(newVar) } else { 100.0 };
    
    {
      oscillators    = newOscs;
      globalCoupling = state.globalCoupling;
      noiseStrength  = state.noiseStrength;
      orderParam     = newR;
      meanPhase      = newPsi;
      beatNum        = state.beatNum + 1;
      orderParamVar  = newVar;
      phaseDiffusion = D;
      snr            = _clamp(snr, 0.0, 100.0);
      seed           = currentSeed;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: ADAPTIVE FREQUENCY KURAMOTO — PLASTICITY IN NATURAL FREQUENCIES
  // ═══════════════════════════════════════════════════════════════════════════════
  // Oscillators can adapt their natural frequencies based on synchronization
  // Hebbian-like learning: ωᵢ → ωᵢ + ε·sin(ψ - θᵢ)
  // Leads to frequency clustering and enhanced synchronization
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Oscillator with plastic natural frequency
  public type PlasticOscillator = {
    phase          : Float;
    naturalFreq    : Float;
    baseFreq       : Float;            // Original frequency (for reference)
    coupling       : Float;
    amplitude      : Float;
    freqHistory    : [Float];          // Track frequency changes
  };

  /// Adaptive frequency Kuramoto state
  public type AdaptiveFreqKuramotoState = {
    oscillators    : [PlasticOscillator];
    globalCoupling : Float;
    freqPlasticity : Float;            // ε - frequency learning rate
    orderParam     : Float;
    meanPhase      : Float;
    beatNum        : Nat;
    freqSpread     : Float;            // Current spread of natural frequencies
    freqEntropy    : Float;            // Entropy of frequency distribution
  };

  /// Initialize adaptive frequency Kuramoto
  public func initAdaptiveFreqKuramoto(plasticity: Float) : AdaptiveFreqKuramotoState {
    let oscs = Array.tabulate<PlasticOscillator>(26, func(i) {
      let freq = 0.05 + Float.fromInt(i) * 0.01;
      {
        phase = Float.fromInt(i) * TWO_PI / 26.0;
        naturalFreq = freq;
        baseFreq = freq;
        coupling = 1.0;
        amplitude = 1.0;
        freqHistory = [freq];
      }
    });
    
    {
      oscillators    = oscs;
      globalCoupling = 1.5;
      freqPlasticity = plasticity;
      orderParam     = 0.5;
      meanPhase      = 0.0;
      beatNum        = 0;
      freqSpread     = 0.25;
      freqEntropy    = 1.0;
    }
  };

  /// Convert PlasticOscillator to regular Oscillator for order parameter computation
  func plasticToRegular(oscs: [PlasticOscillator]) : [Oscillator] {
    Array.map<PlasticOscillator, Oscillator>(oscs, func(po) {
      {
        phase = po.phase;
        naturalFreq = po.naturalFreq;
        coupling = po.coupling;
        amplitude = po.amplitude;
      }
    })
  };

  /// Update adaptive frequency Kuramoto
  public func beatAdaptiveFreqKuramoto(state: AdaptiveFreqKuramotoState, dt: Float) : AdaptiveFreqKuramotoState {
    let regularOscs = plasticToRegular(state.oscillators);
    let (r, psi) = computeOrderParameter(regularOscs);
    
    var newOscs : [PlasticOscillator] = [];
    var sumFreq : Float = 0.0;
    var sumFreqSq : Float = 0.0;
    
    for (osc in state.oscillators.vals()) {
      // Phase update
      let coupling = osc.coupling * state.globalCoupling * r * Float.sin(psi - osc.phase);
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
      
      // Frequency adaptation: ω += ε·sin(ψ - θ) (moves toward mean phase)
      let freqUpdate = state.freqPlasticity * Float.sin(psi - osc.phase);
      let newFreq = _clamp(osc.naturalFreq + freqUpdate * dt, 0.01, 0.5);
      
      // Update frequency history
      let newHistory = if (osc.freqHistory.size() >= 50) {
        let tail = Array.tabulate<Float>(49, func(i) { osc.freqHistory[i + 1] });
        Array.append<Float>(tail, [newFreq])
      } else {
        Array.append<Float>(osc.freqHistory, [newFreq])
      };
      
      sumFreq += newFreq;
      sumFreqSq += newFreq * newFreq;
      
      newOscs := Array.append(newOscs, [{
        phase = newPhase;
        naturalFreq = newFreq;
        baseFreq = osc.baseFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
        freqHistory = newHistory;
      }]);
    };
    
    let n = Float.fromInt(state.oscillators.size());
    let meanFreq = sumFreq / n;
    let variance = (sumFreqSq / n) - (meanFreq * meanFreq);
    let spread = Float.sqrt(Float.abs(variance));
    
    // Frequency entropy approximation (based on spread)
    let entropy = if (spread > 1e-6) { Float.log(spread * 10.0 + 1.0) } else { 0.0 };
    
    {
      oscillators    = newOscs;
      globalCoupling = state.globalCoupling;
      freqPlasticity = state.freqPlasticity;
      orderParam     = r;
      meanPhase      = psi;
      beatNum        = state.beatNum + 1;
      freqSpread     = spread;
      freqEntropy    = _clamp(entropy, 0.0, 5.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: KURAMOTO ON COMPLEX NETWORKS — TOPOLOGY-DEPENDENT SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  // Oscillators coupled through an arbitrary network adjacency matrix
  // dθᵢ/dt = ωᵢ + (K/kᵢ) Σⱼ Aᵢⱼ sin(θⱼ - θᵢ)
  // Network structure determines synchronization dynamics
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Network Kuramoto state
  public type NetworkKuramotoState = {
    oscillators    : [Oscillator];
    adjacency      : [[Float]];        // Weighted adjacency matrix
    degrees        : [Float];          // Node degrees (sum of edge weights)
    globalCoupling : Float;
    orderParam     : Float;
    meanPhase      : Float;
    beatNum        : Nat;
    // Network observables
    clusterCoeff   : Float;            // Local clustering coefficient
    pathLength     : Float;            // Average path length estimate
    modularity     : Float;            // Network modularity
  };

  /// Create small-world network (Watts-Strogatz-like)
  public func createSmallWorldNetwork(n: Nat, k: Nat, rewireProb: Float, seed: Nat) : [[Float]] {
    // Start with ring lattice
    var adj = Array.tabulate<[Float]>(n, func(i) {
      Array.tabulate<Float>(n, func(j) { 0.0 })
    });
    
    // Connect each node to k/2 neighbors on each side
    let halfK = k / 2;
    for (i in Array.keys(adj)) {
      for (d in Array.keys(Array.tabulate<Nat>(halfK, func(x) { x + 1 }))) {
        let j = (i + d + 1) % n;
        // Make mutable copy for assignment
        let row = Array.thaw<Float>(adj[i]);
        row[j] := 1.0;
        adj := Array.tabulate<[Float]>(n, func(idx) {
          if (idx == i) { Array.freeze(row) } else { adj[idx] }
        });
        
        // Symmetric
        let col = Array.thaw<Float>(adj[j]);
        col[i] := 1.0;
        adj := Array.tabulate<[Float]>(n, func(idx) {
          if (idx == j) { Array.freeze(col) } else { adj[idx] }
        });
      };
    };
    
    // Rewire edges with probability rewireProb
    var currentSeed = seed;
    for (i in Array.keys(adj)) {
      for (j in Array.keys(adj[i])) {
        if (adj[i][j] > 0.5 and i < j) {
          let (newSeed, rand) = lcgNext(currentSeed);
          currentSeed := newSeed;
          if (rand < rewireProb) {
            // Remove edge (i,j) and add edge to random node
            let (newSeed2, rand2) = lcgNext(currentSeed);
            currentSeed := newSeed2;
            let newJ = Nat.min(n - 1, Nat.max(0, Int.abs(Float.toInt(rand2 * Float.fromInt(n)))));
            
            if (newJ != i and newJ != j) {
              // Update adjacency
              let rowI = Array.thaw<Float>(adj[i]);
              rowI[j] := 0.0;
              rowI[newJ] := 1.0;
              adj := Array.tabulate<[Float]>(n, func(idx) {
                if (idx == i) { Array.freeze(rowI) } else { adj[idx] }
              });
              
              let rowJ = Array.thaw<Float>(adj[j]);
              rowJ[i] := 0.0;
              adj := Array.tabulate<[Float]>(n, func(idx) {
                if (idx == j) { Array.freeze(rowJ) } else { adj[idx] }
              });
              
              let rowNewJ = Array.thaw<Float>(adj[newJ]);
              rowNewJ[i] := 1.0;
              adj := Array.tabulate<[Float]>(n, func(idx) {
                if (idx == newJ) { Array.freeze(rowNewJ) } else { adj[idx] }
              });
            };
          };
        };
      };
    };
    
    adj
  };

  /// Compute node degrees from adjacency matrix
  public func computeDegrees(adj: [[Float]]) : [Float] {
    Array.map<[Float], Float>(adj, func(row) {
      var sum : Float = 0.0;
      for (w in row.vals()) { sum += w };
      if (sum < 0.01) { 0.01 } else { sum }  // Avoid division by zero
    })
  };

  /// Initialize network Kuramoto
  public func initNetworkKuramoto(n: Nat, networkType: Text) : NetworkKuramotoState {
    let adj = switch(networkType) {
      case "small-world" { createSmallWorldNetwork(n, 4, 0.1, 12345) };
      case _ { 
        // Default: fully connected
        Array.tabulate<[Float]>(n, func(i) {
          Array.tabulate<Float>(n, func(j) {
            if (i == j) { 0.0 } else { 1.0 }
          })
        })
      };
    };
    
    let degrees = computeDegrees(adj);
    
    let oscs = Array.tabulate<Oscillator>(n, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(n);
        naturalFreq = 0.05 + Float.fromInt(i % 10) * 0.01;
        coupling = 1.0;
        amplitude = 1.0;
      }
    });
    
    {
      oscillators    = oscs;
      adjacency      = adj;
      degrees        = degrees;
      globalCoupling = 1.5;
      orderParam     = 0.5;
      meanPhase      = 0.0;
      beatNum        = 0;
      clusterCoeff   = 0.0;
      pathLength     = 0.0;
      modularity     = 0.0;
    }
  };

  /// Update network Kuramoto
  public func beatNetworkKuramoto(state: NetworkKuramotoState, dt: Float) : NetworkKuramotoState {
    let n = state.oscillators.size();
    var newOscs : [Oscillator] = [];
    
    for (i in Array.keys(state.oscillators)) {
      let osc = state.oscillators[i];
      let degree = state.degrees[i];
      
      // Sum coupling from all neighbors
      var couplingSum : Float = 0.0;
      for (j in Array.keys(state.oscillators)) {
        let weight = state.adjacency[i][j];
        if (weight > 0.0) {
          let neighbor = state.oscillators[j];
          couplingSum += weight * Float.sin(neighbor.phase - osc.phase);
        };
      };
      
      // Normalized coupling: (K/degree) * sum
      let coupling = state.globalCoupling * couplingSum / degree;
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
      
      newOscs := Array.append(newOscs, [{
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }]);
    };
    
    let (r, psi) = computeOrderParameter(newOscs);
    
    // Approximate clustering coefficient
    var totalTriangles : Float = 0.0;
    var totalTriplets : Float = 0.0;
    for (i in Array.keys(state.adjacency)) {
      for (j in Array.keys(state.adjacency[i])) {
        if (state.adjacency[i][j] > 0.0) {
          for (k in Array.keys(state.adjacency[j])) {
            if (state.adjacency[j][k] > 0.0 and state.adjacency[k][i] > 0.0) {
              totalTriangles += 1.0;
            };
            if (k != i) { totalTriplets += 1.0 };
          };
        };
      };
    };
    let clustering = if (totalTriplets > 0.0) { totalTriangles / totalTriplets } else { 0.0 };
    
    {
      oscillators    = newOscs;
      adjacency      = state.adjacency;
      degrees        = state.degrees;
      globalCoupling = state.globalCoupling;
      orderParam     = r;
      meanPhase      = psi;
      beatNum        = state.beatNum + 1;
      clusterCoeff   = _clamp(clustering, 0.0, 1.0);
      pathLength     = state.pathLength;
      modularity     = state.modularity;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: SECOND-ORDER KURAMOTO — INERTIAL OSCILLATORS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Adding mass/inertia to oscillators: m·d²θᵢ/dt² + γ·dθᵢ/dt = ωᵢ + K·r·sin(ψ-θᵢ)
  // Exhibits hysteresis and bistability
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Inertial oscillator with velocity
  public type InertialOscillator = {
    phase       : Float;
    velocity    : Float;               // dθ/dt
    naturalFreq : Float;
    coupling    : Float;
    amplitude   : Float;
    mass        : Float;               // m - inertia
    damping     : Float;               // γ - friction
  };

  /// Second-order Kuramoto state
  public type InertialKuramotoState = {
    oscillators    : [InertialOscillator];
    globalCoupling : Float;
    orderParam     : Float;
    meanPhase      : Float;
    beatNum        : Nat;
    // Inertial observables
    kineticEnergy  : Float;            // (1/2)·m·v²
    totalEnergy    : Float;            // Kinetic + potential
    bistableRegion : Bool;             // In hysteresis zone
  };

  /// Initialize inertial Kuramoto
  public func initInertialKuramoto(mass: Float, damping: Float) : InertialKuramotoState {
    let oscs = Array.tabulate<InertialOscillator>(18, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / 18.0;
        velocity = 0.0;
        naturalFreq = ORGAN_FREQS[i];
        coupling = 1.0;
        amplitude = 1.0;
        mass = mass;
        damping = damping;
      }
    });
    
    {
      oscillators    = oscs;
      globalCoupling = 1.5;
      orderParam     = 0.5;
      meanPhase      = 0.0;
      beatNum        = 0;
      kineticEnergy  = 0.0;
      totalEnergy    = 0.0;
      bistableRegion = false;
    }
  };

  /// Convert InertialOscillator to regular for order parameter
  func inertialToRegular(oscs: [InertialOscillator]) : [Oscillator] {
    Array.map<InertialOscillator, Oscillator>(oscs, func(io) {
      {
        phase = io.phase;
        naturalFreq = io.naturalFreq;
        coupling = io.coupling;
        amplitude = io.amplitude;
      }
    })
  };

  /// Update inertial Kuramoto (Verlet integration)
  public func beatInertialKuramoto(state: InertialKuramotoState, dt: Float) : InertialKuramotoState {
    let regularOscs = inertialToRegular(state.oscillators);
    let (r, psi) = computeOrderParameter(regularOscs);
    
    var newOscs : [InertialOscillator] = [];
    var totalKE : Float = 0.0;
    var totalPE : Float = 0.0;
    
    for (osc in state.oscillators.vals()) {
      // Forces: natural frequency drive + coupling - damping
      let couplingForce = state.globalCoupling * r * Float.sin(psi - osc.phase);
      let dampingForce = -osc.damping * osc.velocity;
      let totalForce = osc.naturalFreq + couplingForce + dampingForce;
      
      // Acceleration: a = F/m
      let accel = totalForce / osc.mass;
      
      // Verlet integration
      let newVel = osc.velocity + accel * dt;
      let newPhase = wrapPhase(osc.phase + newVel * dt);
      
      // Kinetic energy
      let ke = 0.5 * osc.mass * newVel * newVel;
      totalKE += ke;
      
      // Potential energy (from coupling)
      let pe = -state.globalCoupling * r * Float.cos(psi - osc.phase);
      totalPE += pe;
      
      newOscs := Array.append(newOscs, [{
        phase = newPhase;
        velocity = newVel;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
        mass = osc.mass;
        damping = osc.damping;
      }]);
    };
    
    let (newR, newPsi) = computeOrderParameter(inertialToRegular(newOscs));
    
    // Check for bistable region (hysteresis indicator)
    let inBistable = state.globalCoupling > 0.5 and state.globalCoupling < 2.0 and 
                     Float.abs(newR - state.orderParam) < 0.01;
    
    {
      oscillators    = newOscs;
      globalCoupling = state.globalCoupling;
      orderParam     = newR;
      meanPhase      = newPsi;
      beatNum        = state.beatNum + 1;
      kineticEnergy  = totalKE;
      totalEnergy    = totalKE + totalPE;
      bistableRegion = inBistable;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 14: KURAMOTO WITH TIME DELAY — MEMORY EFFECTS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Coupling depends on past states: dθᵢ/dt = ωᵢ + K·r(t-τ)·sin(ψ(t-τ) - θᵢ)
  // Time delays can induce new synchronization patterns and multistability
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Delayed Kuramoto state
  public type DelayedKuramotoState = {
    oscillators    : [Oscillator];
    globalCoupling : Float;
    delay          : Nat;              // τ in beats
    orderParam     : Float;
    meanPhase      : Float;
    beatNum        : Nat;
    // History buffers
    rHistory       : [Float];          // Past r values
    psiHistory     : [Float];          // Past ψ values
    // Delay observables
    delayResonance : Bool;             // Delay matches natural period
    stabilityIndex : Float;            // Delay-induced stability
  };

  /// Initialize delayed Kuramoto
  public func initDelayedKuramoto(delay: Nat) : DelayedKuramotoState {
    let oscs = initOrganOscillators();
    // Initialize history with default values
    let initR = Array.tabulate<Float>(delay + 1, func(_) { 0.5 });
    let initPsi = Array.tabulate<Float>(delay + 1, func(_) { 0.0 });
    
    {
      oscillators    = oscs;
      globalCoupling = 1.5;
      delay          = delay;
      orderParam     = 0.5;
      meanPhase      = 0.0;
      beatNum        = 0;
      rHistory       = initR;
      psiHistory     = initPsi;
      delayResonance = false;
      stabilityIndex = 1.0;
    }
  };

  /// Update delayed Kuramoto
  public func beatDelayedKuramoto(state: DelayedKuramotoState, dt: Float) : DelayedKuramotoState {
    // Get delayed order parameter
    let delayIdx = if (state.rHistory.size() > state.delay) { 
      state.rHistory.size() - state.delay - 1 
    } else { 0 };
    let delayedR = state.rHistory[delayIdx];
    let delayedPsi = state.psiHistory[delayIdx];
    
    // Update oscillators using delayed field
    let newOscs = Array.map<Oscillator, Oscillator>(state.oscillators, func(osc) {
      let coupling = osc.coupling * state.globalCoupling * delayedR * Float.sin(delayedPsi - osc.phase);
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
      {
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }
    });
    
    let (r, psi) = computeOrderParameter(newOscs);
    
    // Update history (sliding window)
    let maxHistory = state.delay + 50;
    let newRHistory = if (state.rHistory.size() >= maxHistory) {
      let tail = Array.tabulate<Float>(maxHistory - 1, func(i) { state.rHistory[i + 1] });
      Array.append<Float>(tail, [r])
    } else {
      Array.append<Float>(state.rHistory, [r])
    };
    
    let newPsiHistory = if (state.psiHistory.size() >= maxHistory) {
      let tail = Array.tabulate<Float>(maxHistory - 1, func(i) { state.psiHistory[i + 1] });
      Array.append<Float>(tail, [psi])
    } else {
      Array.append<Float>(state.psiHistory, [psi])
    };
    
    // Check for delay resonance (delay ≈ natural period)
    let avgFreq = 0.07;  // Average organ frequency
    let naturalPeriod = 1.0 / avgFreq;
    let delayTime = Float.fromInt(state.delay) * dt;
    let resonance = Float.abs(delayTime - naturalPeriod) < 0.1 * naturalPeriod;
    
    // Stability index based on r fluctuations
    var rVar : Float = 0.0;
    if (newRHistory.size() > 1) {
      var meanR : Float = 0.0;
      for (rv in newRHistory.vals()) { meanR += rv };
      meanR := meanR / Float.fromInt(newRHistory.size());
      for (rv in newRHistory.vals()) {
        let diff = rv - meanR;
        rVar += diff * diff;
      };
      rVar := rVar / Float.fromInt(newRHistory.size());
    };
    let stability = 1.0 / (1.0 + rVar * 10.0);
    
    {
      oscillators    = newOscs;
      globalCoupling = state.globalCoupling;
      delay          = state.delay;
      orderParam     = r;
      meanPhase      = psi;
      beatNum        = state.beatNum + 1;
      rHistory       = newRHistory;
      psiHistory     = newPsiHistory;
      delayResonance = resonance;
      stabilityIndex = stability;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: KURAMOTO-BATTOGTOKH — NONLOCAL COUPLING
  // ═══════════════════════════════════════════════════════════════════════════════
  // Coupling strength depends on spatial distance: Gᵢⱼ = exp(-|i-j|/κ)
  // Exhibits chimera states more readily than uniform coupling
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Nonlocal Kuramoto state
  public type NonlocalKuramotoState = {
    oscillators    : [Oscillator];
    couplingRange  : Float;            // κ - characteristic length
    globalCoupling : Float;
    orderParam     : Float;
    meanPhase      : Float;
    beatNum        : Nat;
    // Spatial observables
    localOrderParams : [Float];        // r at each spatial position
    spatialCorrelation : Float;        // Spatial autocorrelation
    domainWallCount : Nat;             // Number of coherent/incoherent boundaries
  };

  /// Compute coupling kernel G(i,j) = exp(-|i-j|/κ)
  func nonlocalKernel(i: Nat, j: Nat, n: Nat, kappa: Float) : Float {
    let dist = Float.abs(Float.fromInt(i) - Float.fromInt(j));
    // Periodic boundary: also check wraparound distance
    let wrapDist = Float.fromInt(n) - dist;
    let minDist = Float.min(dist, wrapDist);
    Float.exp(-minDist / kappa)
  };

  /// Initialize nonlocal Kuramoto
  public func initNonlocalKuramoto(n: Nat, kappa: Float) : NonlocalKuramotoState {
    let oscs = Array.tabulate<Oscillator>(n, func(i) {
      // Alternating frequency pattern to encourage chimera
      let freq = if (i % 2 == 0) { 0.1 } else { 0.11 };
      {
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(n);
        naturalFreq = freq;
        coupling = 1.0;
        amplitude = 1.0;
      }
    });
    
    {
      oscillators     = oscs;
      couplingRange   = kappa;
      globalCoupling  = 1.5;
      orderParam      = 0.5;
      meanPhase       = 0.0;
      beatNum         = 0;
      localOrderParams = Array.tabulate<Float>(n, func(_) { 0.5 });
      spatialCorrelation = 0.0;
      domainWallCount = 0;
    }
  };

  /// Compute local order parameter at position i (using neighbors)
  func computeLocalR(oscs: [Oscillator], i: Nat, windowSize: Nat) : Float {
    let n = oscs.size();
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var count : Nat = 0;
    
    let halfWindow = windowSize / 2;
    for (di in Array.keys(Array.tabulate<Nat>(windowSize, func(x) { x }))) {
      let offset : Int = Int.sub(di, halfWindow);
      var j : Int = Int.add(i, offset);
      if (j < 0) { j := Int.add(j, n) };
      if (j >= n) { j := Int.rem(j, n) };
      let jNat = Int.abs(j);
      
      sumCos += Float.cos(oscs[jNat].phase);
      sumSin += Float.sin(oscs[jNat].phase);
      count += 1;
    };
    
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(count)
  };

  /// Update nonlocal Kuramoto
  public func beatNonlocalKuramoto(state: NonlocalKuramotoState, dt: Float) : NonlocalKuramotoState {
    let n = state.oscillators.size();
    var newOscs : [Oscillator] = [];
    var newLocalR : [Float] = [];
    
    for (i in Array.keys(state.oscillators)) {
      let osc = state.oscillators[i];
      
      // Compute weighted coupling sum
      var couplingSum : Float = 0.0;
      var normSum : Float = 0.0;
      for (j in Array.keys(state.oscillators)) {
        if (i != j) {
          let kernel = nonlocalKernel(i, j, n, state.couplingRange);
          let neighbor = state.oscillators[j];
          couplingSum += kernel * Float.sin(neighbor.phase - osc.phase);
          normSum += kernel;
        };
      };
      
      let coupling = if (normSum > 0.01) {
        state.globalCoupling * couplingSum / normSum
      } else { 0.0 };
      
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
      newOscs := Array.append(newOscs, [{
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }]);
    };
    
    // Compute local order parameters
    let windowSize = Nat.max(3, n / 10);
    for (i in Array.keys(newOscs)) {
      newLocalR := Array.append(newLocalR, [computeLocalR(newOscs, i, windowSize)]);
    };
    
    // Global order parameter
    let (r, psi) = computeOrderParameter(newOscs);
    
    // Count domain walls (transitions between high and low local R)
    var walls : Nat = 0;
    let threshold = 0.7;
    for (i in Array.keys(newLocalR)) {
      if (i > 0) {
        let prev = newLocalR[i - 1];
        let curr = newLocalR[i];
        if ((prev > threshold and curr < threshold) or (prev < threshold and curr > threshold)) {
          walls += 1;
        };
      };
    };
    
    // Spatial correlation (simplified)
    var spatialCorr : Float = 0.0;
    if (n > 2) {
      for (i in Array.keys(newLocalR)) {
        if (i > 0) {
          spatialCorr += newLocalR[i] * newLocalR[i - 1];
        };
      };
      spatialCorr := spatialCorr / Float.fromInt(n - 1);
    };
    
    {
      oscillators     = newOscs;
      couplingRange   = state.couplingRange;
      globalCoupling  = state.globalCoupling;
      orderParam      = r;
      meanPhase       = psi;
      beatNum         = state.beatNum + 1;
      localOrderParams = newLocalR;
      spatialCorrelation = spatialCorr;
      domainWallCount = walls;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: PHASE-AMPLITUDE COUPLING (PAC) — NEURAL CROSS-FREQUENCY DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  // The amplitude of fast oscillations is modulated by the phase of slow oscillations
  // Critical for neural information processing and memory consolidation
  // ═══════════════════════════════════════════════════════════════════════════════

  /// PAC-enabled oscillator
  public type PACOscillator = {
    phase         : Float;
    naturalFreq   : Float;
    amplitude     : Float;
    coupling      : Float;
    // PAC fields
    carrierFreq   : Float;             // Fast oscillation frequency
    carrierPhase  : Float;
    modulationIdx : Float;             // Strength of phase-amplitude coupling
  };

  /// PAC Kuramoto state
  public type PACKuramotoState = {
    slowOscillators : [Oscillator];    // Slow rhythm (e.g., theta 4-8 Hz)
    fastOscillators : [PACOscillator]; // Fast rhythm (e.g., gamma 30-100 Hz)
    globalCoupling  : Float;
    slowR           : Float;
    fastR           : Float;
    slowPsi         : Float;
    beatNum         : Nat;
    // PAC observables
    modulationIndex : Float;           // Strength of PAC
    preferredPhase  : Float;           // Phase of slow at which fast is max
    pacHistogram    : [Float];         // Amplitude vs slow phase bins
  };

  /// Initialize PAC system
  public func initPACKuramoto() : PACKuramotoState {
    // Slow oscillators (theta-like)
    let slowOscs = Array.tabulate<Oscillator>(8, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / 8.0;
        naturalFreq = 0.06 + Float.fromInt(i % 3) * 0.005;  // 4-8 Hz scaled
        coupling = 1.0;
        amplitude = 1.0;
      }
    });
    
    // Fast oscillators (gamma-like)
    let fastOscs = Array.tabulate<PACOscillator>(20, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / 20.0;
        naturalFreq = 0.4 + Float.fromInt(i % 5) * 0.02;  // 30-100 Hz scaled
        amplitude = 0.5;
        coupling = 1.0;
        carrierFreq = 0.5;
        carrierPhase = 0.0;
        modulationIdx = 0.3;
      }
    });
    
    {
      slowOscillators = slowOscs;
      fastOscillators = fastOscs;
      globalCoupling  = 1.5;
      slowR           = 0.5;
      fastR           = 0.5;
      slowPsi         = 0.0;
      beatNum         = 0;
      modulationIndex = 0.0;
      preferredPhase  = 0.0;
      pacHistogram    = Array.tabulate<Float>(18, func(_) { 0.0 });
    }
  };

  /// Update PAC system
  public func beatPACKuramoto(state: PACKuramotoState, dt: Float) : PACKuramotoState {
    // Update slow oscillators (standard Kuramoto)
    let (slowR, slowPsi) = computeOrderParameter(state.slowOscillators);
    let newSlowOscs = Array.map<Oscillator, Oscillator>(state.slowOscillators, func(osc) {
      let coupling = osc.coupling * state.globalCoupling * slowR * Float.sin(slowPsi - osc.phase);
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
      {
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }
    });
    let (newSlowR, newSlowPsi) = computeOrderParameter(newSlowOscs);
    
    // Update fast oscillators with amplitude modulation by slow phase
    var newFastOscs : [PACOscillator] = [];
    var phaseAmplitudes : [Float] = Array.tabulate<Float>(18, func(_) { 0.0 });
    
    for (fastOsc in state.fastOscillators.vals()) {
      // Amplitude modulation: A(t) = A₀ × (1 + m × cos(ψ_slow))
      let modulatedAmp = fastOsc.amplitude * (1.0 + fastOsc.modulationIdx * Float.cos(newSlowPsi));
      
      // Phase dynamics for fast oscillator
      var fastCouplingSum : Float = 0.0;
      for (other in state.fastOscillators.vals()) {
        fastCouplingSum += Float.sin(other.phase - fastOsc.phase) * other.amplitude;
      };
      let avgCoupling = fastCouplingSum / Float.fromInt(state.fastOscillators.size());
      let coupling = state.globalCoupling * 0.3 * avgCoupling;
      
      let newPhase = wrapPhase(fastOsc.phase + (fastOsc.naturalFreq + coupling) * dt);
      
      // Update carrier phase
      let newCarrierPhase = wrapPhase(fastOsc.carrierPhase + fastOsc.carrierFreq * dt);
      
      newFastOscs := Array.append(newFastOscs, [{
        phase = newPhase;
        naturalFreq = fastOsc.naturalFreq;
        amplitude = _clamp(modulatedAmp, 0.1, 2.0);
        coupling = fastOsc.coupling;
        carrierFreq = fastOsc.carrierFreq;
        carrierPhase = newCarrierPhase;
        modulationIdx = fastOsc.modulationIdx;
      }]);
      
      // Accumulate amplitude in phase bin
      let binIdx = Int.abs(Float.toInt(newSlowPsi / TWO_PI * 18.0)) % 18;
      let histMut = Array.thaw<Float>(phaseAmplitudes);
      histMut[binIdx] := histMut[binIdx] + modulatedAmp;
      phaseAmplitudes := Array.freeze(histMut);
    };
    
    // Compute fast order parameter
    let fastRegular = Array.map<PACOscillator, Oscillator>(newFastOscs, func(po) {
      { phase = po.phase; naturalFreq = po.naturalFreq; coupling = po.coupling; amplitude = po.amplitude }
    });
    let (newFastR, _) = computeOrderParameter(fastRegular);
    
    // Compute modulation index (MVL - mean vector length)
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (i in Array.keys(phaseAmplitudes)) {
      let angle = Float.fromInt(i) * TWO_PI / 18.0;
      sumCos += phaseAmplitudes[i] * Float.cos(angle);
      sumSin += phaseAmplitudes[i] * Float.sin(angle);
    };
    var totalAmp : Float = 0.0;
    for (a in phaseAmplitudes.vals()) { totalAmp += a };
    let mi = if (totalAmp > 0.01) {
      Float.sqrt(sumCos * sumCos + sumSin * sumSin) / totalAmp
    } else { 0.0 };
    
    let prefPhase = Float.arctan2(sumSin, sumCos);
    
    {
      slowOscillators = newSlowOscs;
      fastOscillators = newFastOscs;
      globalCoupling  = state.globalCoupling;
      slowR           = newSlowR;
      fastR           = newFastR;
      slowPsi         = newSlowPsi;
      beatNum         = state.beatNum + 1;
      modulationIndex = mi;
      preferredPhase  = prefPhase;
      pacHistogram    = phaseAmplitudes;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 17: KURAMOTO-DAIDO — HIGHER HARMONICS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Generalized coupling with higher harmonics: Σₘ Kₘ sin(m(θⱼ - θᵢ))
  // Allows for multi-cluster states and more complex synchronization patterns
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Higher harmonic Kuramoto state
  public type HigherHarmonicKuramotoState = {
    oscillators      : [Oscillator];
    harmonicCouplings : [Float];       // K₁, K₂, K₃, ... coupling strengths
    orderParams      : [Float];        // r₁, r₂, r₃, ... for each harmonic
    meanPhases       : [Float];        // ψ₁, ψ₂, ψ₃, ... for each harmonic
    beatNum          : Nat;
    // Higher harmonic observables
    dominantHarmonic : Nat;            // Which harmonic has highest r
    clusterNumber    : Nat;            // Estimated number of clusters
  };

  /// Compute order parameter for harmonic m: rₘ = |Σⱼ exp(i·m·θⱼ)|/N
  public func computeHarmonicOrderParam(oscs: [Oscillator], m: Nat) : (Float, Float) {
    let n = oscs.size();
    if (n == 0) { return (0.0, 0.0) };
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    let mf = Float.fromInt(m);
    
    for (osc in oscs.vals()) {
      sumCos += Float.cos(mf * osc.phase);
      sumSin += Float.sin(mf * osc.phase);
    };
    
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);
    let psi = Float.arctan2(sumSin, sumCos) / mf;
    (_clamp(r, 0.0, 1.0), wrapPhase(psi))
  };

  /// Initialize higher harmonic Kuramoto
  public func initHigherHarmonicKuramoto(maxHarmonic: Nat) : HigherHarmonicKuramotoState {
    let oscs = initOrganOscillators();
    
    // Coupling decreases with harmonic number
    let couplings = Array.tabulate<Float>(maxHarmonic, func(m) {
      1.5 / Float.fromInt(m + 1)
    });
    
    // Initialize order params
    var orderPs : [Float] = [];
    var meanPs : [Float] = [];
    for (m in Array.keys(couplings)) {
      let (r, psi) = computeHarmonicOrderParam(oscs, m + 1);
      orderPs := Array.append(orderPs, [r]);
      meanPs := Array.append(meanPs, [psi]);
    };
    
    {
      oscillators       = oscs;
      harmonicCouplings = couplings;
      orderParams       = orderPs;
      meanPhases        = meanPs;
      beatNum           = 0;
      dominantHarmonic  = 1;
      clusterNumber     = 1;
    }
  };

  /// Update higher harmonic Kuramoto
  public func beatHigherHarmonicKuramoto(state: HigherHarmonicKuramotoState, dt: Float) : HigherHarmonicKuramotoState {
    let maxM = state.harmonicCouplings.size();
    
    // Compute all harmonic order parameters
    var orderPs : [Float] = [];
    var meanPs : [Float] = [];
    for (m in Array.keys(state.harmonicCouplings)) {
      let (r, psi) = computeHarmonicOrderParam(state.oscillators, m + 1);
      orderPs := Array.append(orderPs, [r]);
      meanPs := Array.append(meanPs, [psi]);
    };
    
    // Update oscillators with multi-harmonic coupling
    let newOscs = Array.map<Oscillator, Oscillator>(state.oscillators, func(osc) {
      var totalCoupling : Float = 0.0;
      
      for (m in Array.keys(state.harmonicCouplings)) {
        let mf = Float.fromInt(m + 1);
        let Km = state.harmonicCouplings[m];
        let rm = orderPs[m];
        let psim = meanPs[m];
        totalCoupling += Km * rm * Float.sin(mf * (psim - osc.phase));
      };
      
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + totalCoupling) * dt);
      {
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }
    });
    
    // Recompute order params after update
    var newOrderPs : [Float] = [];
    var newMeanPs : [Float] = [];
    for (m in Array.keys(state.harmonicCouplings)) {
      let (r, psi) = computeHarmonicOrderParam(newOscs, m + 1);
      newOrderPs := Array.append(newOrderPs, [r]);
      newMeanPs := Array.append(newMeanPs, [psi]);
    };
    
    // Find dominant harmonic
    var maxR : Float = 0.0;
    var domHarm : Nat = 1;
    for (m in Array.keys(newOrderPs)) {
      if (newOrderPs[m] > maxR) {
        maxR := newOrderPs[m];
        domHarm := m + 1;
      };
    };
    
    // Estimate cluster number from dominant harmonic
    let clusters = domHarm;
    
    {
      oscillators       = newOscs;
      harmonicCouplings = state.harmonicCouplings;
      orderParams       = newOrderPs;
      meanPhases        = newMeanPs;
      beatNum           = state.beatNum + 1;
      dominantHarmonic  = domHarm;
      clusterNumber     = clusters;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 18: INTEGRATED KURAMOTO ORCHESTRATOR — UNIFIED CONTROL
  // ═══════════════════════════════════════════════════════════════════════════════
  // Master orchestrator that coordinates all Kuramoto variants
  // Selects optimal dynamics based on system state
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Unified Kuramoto control state
  public type UnifiedKuramotoControl = {
    standardState     : KuramotoState;
    sakaguchiState    : KuramotoSakaguchiState;
    hierarchicalState : HierarchicalKuramotoState;
    stochasticState   : StochasticKuramotoState;
    adaptiveState     : AdaptiveFreqKuramotoState;
    inertialState     : InertialKuramotoState;
    pacState          : PACKuramotoState;
    // Control parameters
    activeMode        : Text;          // Which variant is active
    transitionWeight  : Float;         // For blending between modes
    beatNum           : Nat;
  };

  /// Initialize unified controller
  public func initUnifiedKuramoto() : UnifiedKuramotoControl {
    {
      standardState     = initKuramoto();
      sakaguchiState    = initKuramotoSakaguchi(0.1);
      hierarchicalState = initHierarchicalKuramoto(3.0);
      stochasticState   = initStochasticKuramoto(0.05, 12345);
      adaptiveState     = initAdaptiveFreqKuramoto(0.01);
      inertialState     = initInertialKuramoto(1.0, 0.5);
      pacState          = initPACKuramoto();
      activeMode        = "standard";
      transitionWeight  = 1.0;
      beatNum           = 0;
    }
  };

  /// Get unified output from controller
  public func getUnifiedKuramotoOutput(control: UnifiedKuramotoControl) : {
    orderParam : Float;
    meanPhase : Float;
    mode : Text;
    coherenceLevel : Float;
    stability : Float;
  } {
    let (r, psi, stability) = switch(control.activeMode) {
      case "standard" { 
        (control.standardState.orderParam, control.standardState.meanPhase, 1.0 - syncVariance(control.standardState))
      };
      case "sakaguchi" { 
        (control.sakaguchiState.orderParam, control.sakaguchiState.meanPhase, control.sakaguchiState.susceptibility)
      };
      case "hierarchical" { 
        (control.hierarchicalState.totalR, 0.0, control.hierarchicalState.crossLevelSync[0])
      };
      case "stochastic" { 
        (control.stochasticState.orderParam, control.stochasticState.meanPhase, control.stochasticState.snr / 100.0)
      };
      case "adaptive" { 
        (control.adaptiveState.orderParam, control.adaptiveState.meanPhase, 1.0 - control.adaptiveState.freqEntropy / 5.0)
      };
      case "inertial" { 
        (control.inertialState.orderParam, control.inertialState.meanPhase, 
         if (control.inertialState.bistableRegion) { 0.5 } else { 0.9 })
      };
      case "pac" { 
        (control.pacState.slowR, control.pacState.slowPsi, control.pacState.modulationIndex)
      };
      case _ { (0.5, 0.0, 0.5) };
    };
    
    {
      orderParam = r;
      meanPhase = psi;
      mode = control.activeMode;
      coherenceLevel = r;
      stability = _clamp(stability, 0.0, 1.0);
    }
  };

  /// Update unified controller based on context
  public func beatUnifiedKuramoto(control: UnifiedKuramotoControl, dt: Float, context: { threatLevel : Float; learningRate : Float }) : UnifiedKuramotoControl {
    // Select mode based on context
    let newMode = if (context.threatLevel > 0.8) {
      "inertial"  // High threat: need stability
    } else if (context.learningRate > 0.5) {
      "adaptive"  // High learning: frequency plasticity
    } else if (context.threatLevel > 0.3) {
      "stochastic"  // Medium threat: noise robustness
    } else {
      "standard"  // Normal: efficient synchronization
    };
    
    // Update all states (even inactive ones at reduced rate)
    let newStandard = beatKuramoto(control.standardState, dt);
    let newSakaguchi = beatKuramotoSakaguchi(control.sakaguchiState, dt);
    let newHierarchical = beatHierarchicalKuramoto(control.hierarchicalState, dt);
    let newStochastic = beatStochasticKuramoto(control.stochasticState, dt);
    let newAdaptive = beatAdaptiveFreqKuramoto(control.adaptiveState, dt);
    let newInertial = beatInertialKuramoto(control.inertialState, dt);
    let newPac = beatPACKuramoto(control.pacState, dt);
    
    {
      standardState     = newStandard;
      sakaguchiState    = newSakaguchi;
      hierarchicalState = newHierarchical;
      stochasticState   = newStochastic;
      adaptiveState     = newAdaptive;
      inertialState     = newInertial;
      pacState          = newPac;
      activeMode        = newMode;
      transitionWeight  = if (newMode == control.activeMode) { 1.0 } else { 0.0 };
      beatNum           = control.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 19: SWARM INTEGRATION — MULTI-AGENT KURAMOTO SYNC
  // ═══════════════════════════════════════════════════════════════════════════════
  // Extends Kuramoto to swarm synchronization
  // Each agent is an oscillator, swarm coherence emerges from phase alignment
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Swarm agent with position and Kuramoto oscillator
  public type SwarmAgent = {
    id          : Nat;
    x           : Float;
    y           : Float;
    z           : Float;
    heading     : Float;               // Direction in x-y plane
    oscillator  : Oscillator;
    // Agent-specific
    velocity    : Float;
    perception  : Float;               // Communication range
    squadron    : Nat;
  };

  /// Swarm Kuramoto state
  public type SwarmKuramotoState = {
    agents         : [SwarmAgent];
    globalCoupling : Float;
    orderParam     : Float;
    meanPhase      : Float;
    beatNum        : Nat;
    // Swarm observables
    formationCoherence : Float;        // Spatial coherence
    velocityAlign      : Float;        // Velocity alignment
    squadronSync       : [Float];      // Per-squadron sync
  };

  /// Initialize swarm with N agents
  public func initSwarmKuramoto(n: Nat, squadrons: Nat) : SwarmKuramotoState {
    var agents : [SwarmAgent] = [];
    
    for (i in Array.keys(Array.tabulate<Nat>(n, func(x) { x }))) {
      // Random-ish initial positions (deterministic for reproducibility)
      let angle = Float.fromInt(i) * TWO_PI / Float.fromInt(n);
      let radius = 10.0 + Float.fromInt(i % 5);
      let x = radius * Float.cos(angle);
      let y = radius * Float.sin(angle);
      let z = Float.fromInt(i % 3) * 2.0;
      
      let osc : Oscillator = {
        phase = angle;
        naturalFreq = 0.1 + Float.fromInt(i % 10) * 0.005;
        coupling = 1.0;
        amplitude = 1.0;
      };
      
      agents := Array.append(agents, [{
        id = i;
        x = x;
        y = y;
        z = z;
        heading = angle;
        oscillator = osc;
        velocity = 1.0;
        perception = 15.0;
        squadron = i % squadrons;
      }]);
    };
    
    let oscs = Array.map<SwarmAgent, Oscillator>(agents, func(a) { a.oscillator });
    let (r, psi) = computeOrderParameter(oscs);
    
    {
      agents         = agents;
      globalCoupling = 1.5;
      orderParam     = r;
      meanPhase      = psi;
      beatNum        = 0;
      formationCoherence = 0.5;
      velocityAlign  = 0.5;
      squadronSync   = Array.tabulate<Float>(squadrons, func(_) { 0.5 });
    }
  };

  /// Distance between two agents
  func agentDistance(a: SwarmAgent, b: SwarmAgent) : Float {
    let dx = a.x - b.x;
    let dy = a.y - b.y;
    let dz = a.z - b.z;
    Float.sqrt(dx * dx + dy * dy + dz * dz)
  };

  /// Update swarm Kuramoto
  public func beatSwarmKuramoto(state: SwarmKuramotoState, dt: Float) : SwarmKuramotoState {
    let n = state.agents.size();
    var newAgents : [SwarmAgent] = [];
    
    for (agent in state.agents.vals()) {
      // Find neighbors within perception range
      var couplingSum : Float = 0.0;
      var neighborCount : Nat = 0;
      var avgHeadingCos : Float = 0.0;
      var avgHeadingSin : Float = 0.0;
      
      for (other in state.agents.vals()) {
        if (agent.id != other.id) {
          let dist = agentDistance(agent, other);
          if (dist < agent.perception) {
            // Phase coupling
            couplingSum += Float.sin(other.oscillator.phase - agent.oscillator.phase);
            // Heading alignment
            avgHeadingCos += Float.cos(other.heading);
            avgHeadingSin += Float.sin(other.heading);
            neighborCount += 1;
          };
        };
      };
      
      // Update oscillator phase
      let coupling = if (neighborCount > 0) {
        state.globalCoupling * couplingSum / Float.fromInt(neighborCount)
      } else { 0.0 };
      let newPhase = wrapPhase(agent.oscillator.phase + (agent.oscillator.naturalFreq + coupling) * dt);
      
      // Update heading based on phase (couples movement to oscillation)
      let headingInfluence = 0.1 * Float.sin(newPhase);
      var newHeading = agent.heading + headingInfluence * dt;
      
      // Also align heading with neighbors
      if (neighborCount > 0) {
        let targetHeading = Float.arctan2(avgHeadingSin, avgHeadingCos);
        let headingError = targetHeading - agent.heading;
        newHeading := newHeading + 0.05 * headingError * dt;
      };
      newHeading := wrapPhase(newHeading);
      
      // Update position based on heading
      let newX = agent.x + agent.velocity * Float.cos(newHeading) * dt;
      let newY = agent.y + agent.velocity * Float.sin(newHeading) * dt;
      
      newAgents := Array.append(newAgents, [{
        id = agent.id;
        x = newX;
        y = newY;
        z = agent.z;
        heading = newHeading;
        oscillator = {
          phase = newPhase;
          naturalFreq = agent.oscillator.naturalFreq;
          coupling = agent.oscillator.coupling;
          amplitude = agent.oscillator.amplitude;
        };
        velocity = agent.velocity;
        perception = agent.perception;
        squadron = agent.squadron;
      }]);
    };
    
    // Compute global order parameter
    let oscs = Array.map<SwarmAgent, Oscillator>(newAgents, func(a) { a.oscillator });
    let (r, psi) = computeOrderParameter(oscs);
    
    // Compute formation coherence (spread of positions)
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    for (a in newAgents.vals()) {
      sumX += a.x;
      sumY += a.y;
    };
    let centroidX = sumX / Float.fromInt(n);
    let centroidY = sumY / Float.fromInt(n);
    
    var spreadSq : Float = 0.0;
    for (a in newAgents.vals()) {
      let dx = a.x - centroidX;
      let dy = a.y - centroidY;
      spreadSq += dx * dx + dy * dy;
    };
    let spread = Float.sqrt(spreadSq / Float.fromInt(n));
    let formationCoh = 1.0 / (1.0 + spread / 10.0);
    
    // Velocity alignment
    var velAlignSum : Float = 0.0;
    for (a in newAgents.vals()) {
      velAlignSum += Float.cos(a.heading - psi);
    };
    let velAlign = Float.abs(velAlignSum / Float.fromInt(n));
    
    {
      agents         = newAgents;
      globalCoupling = state.globalCoupling;
      orderParam     = r;
      meanPhase      = psi;
      beatNum        = state.beatNum + 1;
      formationCoherence = formationCoh;
      velocityAlign  = velAlign;
      squadronSync   = state.squadronSync;  // Would compute per-squadron
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 20: FINAL OUTPUT INTERFACES — CONNECTION TO OTHER MODULES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Comprehensive Kuramoto output for organism integration
  public type ComprehensiveKuramotoOutput = {
    // Basic Kuramoto
    orderParameter     : Float;
    meanPhase          : Float;
    phaseVariance      : Float;
    
    // Multi-scale
    microCoherence     : Float;
    mesoCoherence      : Float;
    macroCoherence     : Float;
    crossScaleSync     : Float;
    
    // Chimera & clusters
    chimeraIndex       : Float;
    clusterCount       : Nat;
    dominantHarmonic   : Nat;
    
    // Stochastic
    noiseRobustness    : Float;
    signalToNoise      : Float;
    
    // Adaptive
    frequencyEntropy   : Float;
    frequencySpread    : Float;
    
    // PAC
    pacStrength        : Float;
    preferredPhase     : Float;
    
    // Swarm
    swarmCoherence     : Float;
    formationQuality   : Float;
    
    // Control
    activeMode         : Text;
    systemStability    : Float;
  };

  /// Generate comprehensive output from unified controller
  public func generateComprehensiveOutput(control: UnifiedKuramotoControl) : ComprehensiveKuramotoOutput {
    {
      orderParameter     = control.standardState.orderParam;
      meanPhase          = control.standardState.meanPhase;
      phaseVariance      = syncVariance(control.standardState);
      
      microCoherence     = if (control.hierarchicalState.levels.size() > 0) { control.hierarchicalState.levels[0].levelR } else { 0.5 };
      mesoCoherence      = if (control.hierarchicalState.levels.size() > 1) { control.hierarchicalState.levels[1].levelR } else { 0.5 };
      macroCoherence     = if (control.hierarchicalState.levels.size() > 2) { control.hierarchicalState.levels[2].levelR } else { 0.5 };
      crossScaleSync     = if (control.hierarchicalState.crossLevelSync.size() > 0) { control.hierarchicalState.crossLevelSync[0] } else { 0.5 };
      
      chimeraIndex       = 0.0;  // Would compute from multi-pop state
      clusterCount       = 1;
      dominantHarmonic   = 1;
      
      noiseRobustness    = 1.0 - control.stochasticState.orderParamVar;
      signalToNoise      = control.stochasticState.snr;
      
      frequencyEntropy   = control.adaptiveState.freqEntropy;
      frequencySpread    = control.adaptiveState.freqSpread;
      
      pacStrength        = control.pacState.modulationIndex;
      preferredPhase     = control.pacState.preferredPhase;
      
      swarmCoherence     = control.standardState.orderParam;  // Would use swarm state
      formationQuality   = 0.8;
      
      activeMode         = control.activeMode;
      systemStability    = if (control.inertialState.bistableRegion) { 0.5 } else { 0.9 };
    }
  };

  /// Export state for AEGIS defense integration
  public func exportForDefense(control: UnifiedKuramotoControl) : {
    coherenceLevel : Float;
    alertThreshold : Float;
    responseSpeed : Float;
    systemHealth : Float;
  } {
    let unified = getUnifiedKuramotoOutput(control);
    {
      coherenceLevel = unified.coherenceLevel;
      alertThreshold = 1.0 - unified.stability;
      responseSpeed = unified.orderParam;
      systemHealth = (unified.coherenceLevel + unified.stability) / 2.0;
    }
  };

  /// Export state for Hebbian learning integration
  public func exportForHebbian(control: UnifiedKuramotoControl) : {
    phaseCorrelations : [Float];
    learningSignal : Float;
    plasticityGate : Float;
  } {
    // Extract phase correlations from oscillators
    var correlations : [Float] = [];
    let oscs = control.standardState.oscillators;
    let n = oscs.size();
    
    for (i in Array.keys(oscs)) {
      for (j in Array.keys(oscs)) {
        if (j > i) {
          let corr = Float.cos(oscs[i].phase - oscs[j].phase);
          correlations := Array.append(correlations, [corr]);
        };
      };
    };
    
    {
      phaseCorrelations = correlations;
      learningSignal = control.standardState.orderParam;
      plasticityGate = if (control.adaptiveState.freqSpread < 0.1) { 0.9 } else { 0.3 };
    }
  };

  /// Export state for Friston free energy integration
  public func exportForFriston(control: UnifiedKuramotoControl) : {
    prediction : Float;
    predictionError : Float;
    freeEnergy : Float;
  } {
    // Prediction based on order parameter trend
    let history = control.standardState.syncHistory;
    var trend : Float = 0.0;
    if (history.size() >= 2) {
      trend := history[history.size() - 1] - history[0];
      trend := trend / Float.fromInt(history.size());
    };
    
    let prediction = _clamp(control.standardState.orderParam + trend, 0.0, 1.0);
    let predError = Float.abs(prediction - control.standardState.orderParam);
    let fe = predError * 10.0;  // Simplified free energy proxy
    
    {
      prediction = prediction;
      predictionError = predError;
      freeEnergy = fe;
    }
  };

  /// Export state for Quantum module integration
  public func exportForQuantum(control: UnifiedKuramotoControl) : {
    phaseCoherence : Float;
    entanglementPotential : Float;
    quantumAnalog : Float;
  } {
    // High coherence + edge of chaos = high entanglement potential
    let edgeOfChaos = Float.abs(control.standardState.orderParam - 0.5) < 0.2;
    let entPot = if (edgeOfChaos) { 0.8 } else { 0.3 };
    
    {
      phaseCoherence = control.standardState.orderParam;
      entanglementPotential = entPot;
      quantumAnalog = control.pacState.modulationIndex;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 21: KURAMOTO-SIVASHINSKY DYNAMICS — SPATIOTEMPORAL CHAOS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Coupling Kuramoto with spatiotemporal dynamics from Kuramoto-Sivashinsky PDE
  // ∂u/∂t = -u·∂u/∂x - ∂²u/∂x² - ∂⁴u/∂x⁴
  // Exhibits weak turbulence and pattern formation
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Spatiotemporal Kuramoto state with KS dynamics
  public type KuramotoSivashinskyState = {
    oscillators     : [Oscillator];
    field           : [Float];         // u(x) discretized
    fieldDerivative : [Float];         // ∂u/∂x
    globalCoupling  : Float;
    orderParam      : Float;
    meanPhase       : Float;
    beatNum         : Nat;
    // KS observables
    lyapunovDim     : Float;           // Kaplan-Yorke dimension
    spatialEntropy  : Float;           // Spatial complexity
    patternWavelength : Float;         // Dominant pattern scale
  };

  /// Initialize KS-Kuramoto coupled system
  public func initKuramotoSivashinsky(gridSize: Nat) : KuramotoSivashinskyState {
    let oscs = initOrganOscillators();
    
    // Initialize field with small perturbation
    let field = Array.tabulate<Float>(gridSize, func(i) {
      let x = Float.fromInt(i) / Float.fromInt(gridSize);
      0.1 * Float.sin(TWO_PI * x * 4.0) + 0.05 * Float.sin(TWO_PI * x * 7.0)
    });
    
    let deriv = Array.tabulate<Float>(gridSize, func(_) { 0.0 });
    
    {
      oscillators     = oscs;
      field           = field;
      fieldDerivative = deriv;
      globalCoupling  = 1.5;
      orderParam      = 0.5;
      meanPhase       = 0.0;
      beatNum         = 0;
      lyapunovDim     = 2.0;
      spatialEntropy  = 1.0;
      patternWavelength = 0.25;
    }
  };

  /// Compute derivatives using finite differences
  func computeKSDerivatives(field: [Float]) : { dx : [Float]; dxx : [Float]; dxxxx : [Float] } {
    let n = field.size();
    let h = 1.0 / Float.fromInt(n);  // Grid spacing
    
    var dx : [Float] = [];
    var dxx : [Float] = [];
    var dxxxx : [Float] = [];
    
    for (i in Array.keys(field)) {
      // Periodic boundary conditions
      let im2 = if (i >= 2) { i - 2 } else { n + i - 2 };
      let im1 = if (i >= 1) { i - 1 } else { n - 1 };
      let ip1 = if (i + 1 < n) { i + 1 } else { i + 1 - n };
      let ip2 = if (i + 2 < n) { i + 2 } else { i + 2 - n };
      
      // First derivative: central difference
      let first = (field[ip1] - field[im1]) / (2.0 * h);
      
      // Second derivative: central difference
      let second = (field[ip1] - 2.0 * field[i] + field[im1]) / (h * h);
      
      // Fourth derivative: central difference
      let fourth = (field[ip2] - 4.0 * field[ip1] + 6.0 * field[i] - 4.0 * field[im1] + field[im2]) / (h * h * h * h);
      
      dx := Array.append(dx, [first]);
      dxx := Array.append(dxx, [second]);
      dxxxx := Array.append(dxxxx, [fourth]);
    };
    
    { dx = dx; dxx = dxx; dxxxx = dxxxx }
  };

  /// Update KS-Kuramoto system
  public func beatKuramotoSivashinsky(state: KuramotoSivashinskyState, dt: Float) : KuramotoSivashinskyState {
    let n = state.field.size();
    
    // Compute KS derivatives
    let derivs = computeKSDerivatives(state.field);
    
    // Update field: ∂u/∂t = -u·∂u/∂x - ∂²u/∂x² - ∂⁴u/∂x⁴
    var newField : [Float] = [];
    for (i in Array.keys(state.field)) {
      let u = state.field[i];
      let du = -u * derivs.dx[i] - derivs.dxx[i] - derivs.dxxxx[i];
      newField := Array.append(newField, [u + du * dt]);
    };
    
    // Couple field to oscillators: field modulates natural frequencies
    let (r, psi) = computeOrderParameter(state.oscillators);
    let fieldMean = {
      var sum : Float = 0.0;
      for (f in newField.vals()) { sum += f };
      sum / Float.fromInt(n)
    };
    
    let newOscs = Array.map<Oscillator, Oscillator>(state.oscillators, func(osc) {
      // Field influences coupling strength
      let fieldInfluence = 1.0 + 0.1 * fieldMean;
      let coupling = osc.coupling * state.globalCoupling * fieldInfluence * r * Float.sin(psi - osc.phase);
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
      {
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }
    });
    
    let (newR, newPsi) = computeOrderParameter(newOscs);
    
    // Compute spatial entropy from field
    var fieldVariance : Float = 0.0;
    for (f in newField.vals()) {
      let diff = f - fieldMean;
      fieldVariance += diff * diff;
    };
    fieldVariance := fieldVariance / Float.fromInt(n);
    let spatialEnt = Float.log(fieldVariance + 1.0);
    
    // Estimate dominant wavelength using zero crossings
    var crossings : Nat = 0;
    for (i in Array.keys(newField)) {
      if (i > 0) {
        if ((newField[i] > 0.0 and newField[i-1] <= 0.0) or
            (newField[i] <= 0.0 and newField[i-1] > 0.0)) {
          crossings += 1;
        };
      };
    };
    let wavelength = if (crossings > 0) { 2.0 / Float.fromInt(crossings) } else { 1.0 };
    
    {
      oscillators     = newOscs;
      field           = newField;
      fieldDerivative = derivs.dx;
      globalCoupling  = state.globalCoupling;
      orderParam      = newR;
      meanPhase       = newPsi;
      beatNum         = state.beatNum + 1;
      lyapunovDim     = 2.0 + spatialEnt;
      spatialEntropy  = _clamp(spatialEnt, 0.0, 5.0);
      patternWavelength = wavelength;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 22: NEURAL FIELD KURAMOTO — CONTINUUM LIMIT
  // ═══════════════════════════════════════════════════════════════════════════════
  // Wilson-Cowan style neural field with Kuramoto coupling
  // Continuous spatial domain with integro-differential dynamics
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Neural field Kuramoto state
  public type NeuralFieldKuramotoState = {
    // Discretized neural field
    excitation    : [Float];           // E(x) - excitatory activity
    inhibition    : [Float];           // I(x) - inhibitory activity
    phase         : [Float];           // θ(x) - local phase
    orderField    : [Float];           // r(x) - local order parameter
    // Global
    globalR       : Float;
    globalPsi     : Float;
    beatNum       : Nat;
    // Field parameters
    tau_E         : Float;             // Excitatory time constant
    tau_I         : Float;             // Inhibitory time constant
    w_EE          : Float;             // E→E coupling
    w_EI          : Float;             // E→I coupling
    w_IE          : Float;             // I→E coupling
    w_II          : Float;             // I→I coupling
    sigmaE        : Float;             // E connectivity width
    sigmaI        : Float;             // I connectivity width
  };

  /// Sigmoid activation function
  func sigmoid(x: Float, threshold: Float, steepness: Float) : Float {
    1.0 / (1.0 + Float.exp(-steepness * (x - threshold)))
  };

  /// Gaussian connectivity kernel
  func gaussianKernel(dist: Float, sigma: Float) : Float {
    Float.exp(-(dist * dist) / (2.0 * sigma * sigma))
  };

  /// Initialize neural field Kuramoto
  public func initNeuralFieldKuramoto(gridSize: Nat) : NeuralFieldKuramotoState {
    let exc = Array.tabulate<Float>(gridSize, func(i) {
      0.2 + 0.1 * Float.sin(Float.fromInt(i) * TWO_PI / Float.fromInt(gridSize) * 3.0)
    });
    
    let inh = Array.tabulate<Float>(gridSize, func(i) {
      0.1 + 0.05 * Float.cos(Float.fromInt(i) * TWO_PI / Float.fromInt(gridSize) * 2.0)
    });
    
    let phase = Array.tabulate<Float>(gridSize, func(i) {
      Float.fromInt(i) * TWO_PI / Float.fromInt(gridSize)
    });
    
    let order = Array.tabulate<Float>(gridSize, func(_) { 0.5 });
    
    {
      excitation  = exc;
      inhibition  = inh;
      phase       = phase;
      orderField  = order;
      globalR     = 0.5;
      globalPsi   = 0.0;
      beatNum     = 0;
      tau_E       = 0.02;
      tau_I       = 0.05;
      w_EE        = 1.5;
      w_EI        = 1.0;
      w_IE        = 1.2;
      w_II        = 0.5;
      sigmaE      = 0.1;
      sigmaI      = 0.2;
    }
  };

  /// Compute spatial convolution
  func spatialConvolution(field: [Float], sigma: Float) : [Float] {
    let n = field.size();
    var result : [Float] = [];
    
    for (i in Array.keys(field)) {
      var conv : Float = 0.0;
      var norm : Float = 0.0;
      
      for (j in Array.keys(field)) {
        // Periodic distance
        let d1 = Float.abs(Float.fromInt(i) - Float.fromInt(j));
        let d2 = Float.fromInt(n) - d1;
        let dist = Float.min(d1, d2) / Float.fromInt(n);
        
        let kernel = gaussianKernel(dist, sigma);
        conv += kernel * field[j];
        norm += kernel;
      };
      
      result := Array.append(result, [conv / norm]);
    };
    
    result
  };

  /// Update neural field Kuramoto
  public func beatNeuralFieldKuramoto(state: NeuralFieldKuramotoState, dt: Float) : NeuralFieldKuramotoState {
    let n = state.excitation.size();
    
    // Compute spatial convolutions
    let E_conv = spatialConvolution(state.excitation, state.sigmaE);
    let I_conv = spatialConvolution(state.inhibition, state.sigmaI);
    
    // Update excitatory field: τ_E · dE/dt = -E + S(w_EE·E_conv - w_IE·I_conv)
    var newE : [Float] = [];
    for (i in Array.keys(state.excitation)) {
      let input = state.w_EE * E_conv[i] - state.w_IE * I_conv[i];
      let dE = (-state.excitation[i] + sigmoid(input, 0.5, 5.0)) / state.tau_E;
      newE := Array.append(newE, [_clamp(state.excitation[i] + dE * dt, 0.0, 1.0)]);
    };
    
    // Update inhibitory field: τ_I · dI/dt = -I + S(w_EI·E_conv - w_II·I_conv)
    var newI : [Float] = [];
    for (i in Array.keys(state.inhibition)) {
      let input = state.w_EI * E_conv[i] - state.w_II * I_conv[i];
      let dI = (-state.inhibition[i] + sigmoid(input, 0.4, 5.0)) / state.tau_I;
      newI := Array.append(newI, [_clamp(state.inhibition[i] + dI * dt, 0.0, 1.0)]);
    };
    
    // Update phase field with local Kuramoto coupling
    var newPhase : [Float] = [];
    var newOrder : [Float] = [];
    
    for (i in Array.keys(state.phase)) {
      // Local order parameter from neighbors
      let windowSize = 5;
      var sumCos : Float = 0.0;
      var sumSin : Float = 0.0;
      
      for (di in Array.keys(Array.tabulate<Nat>(windowSize * 2 + 1, func(x) { x }))) {
        let offset : Int = Int.sub(di, windowSize);
        var j : Int = Int.add(i, offset);
        if (j < 0) { j := Int.add(j, n) };
        if (j >= n) { j := Int.rem(j, n) };
        let jNat = Int.abs(j);
        
        sumCos += Float.cos(state.phase[jNat]);
        sumSin += Float.sin(state.phase[jNat]);
      };
      
      let localR = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(windowSize * 2 + 1);
      let localPsi = Float.arctan2(sumSin, sumCos);
      
      // Natural frequency modulated by excitation
      let omega = 0.1 + 0.2 * newE[i];
      
      // Kuramoto update
      let coupling = localR * Float.sin(localPsi - state.phase[i]);
      let dTheta = omega + coupling;
      
      newPhase := Array.append(newPhase, [wrapPhase(state.phase[i] + dTheta * dt)]);
      newOrder := Array.append(newOrder, [localR]);
    };
    
    // Global order parameter
    var globalSumCos : Float = 0.0;
    var globalSumSin : Float = 0.0;
    for (p in newPhase.vals()) {
      globalSumCos += Float.cos(p);
      globalSumSin += Float.sin(p);
    };
    let globalR = Float.sqrt(globalSumCos * globalSumCos + globalSumSin * globalSumSin) / Float.fromInt(n);
    let globalPsi = Float.arctan2(globalSumSin, globalSumCos);
    
    {
      excitation  = newE;
      inhibition  = newI;
      phase       = newPhase;
      orderField  = newOrder;
      globalR     = globalR;
      globalPsi   = globalPsi;
      beatNum     = state.beatNum + 1;
      tau_E       = state.tau_E;
      tau_I       = state.tau_I;
      w_EE        = state.w_EE;
      w_EI        = state.w_EI;
      w_IE        = state.w_IE;
      w_II        = state.w_II;
      sigmaE      = state.sigmaE;
      sigmaI      = state.sigmaI;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 23: QUANTUM-CLASSICAL KURAMOTO — SEMICLASSICAL DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Kuramoto model with quantum corrections
  // Phase represented on Bloch sphere, decoherence effects
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Quantum oscillator with Bloch sphere representation
  public type QuantumOscillator = {
    // Classical phase
    phase       : Float;
    naturalFreq : Float;
    coupling    : Float;
    amplitude   : Float;
    // Quantum corrections
    blochTheta  : Float;               // Polar angle on Bloch sphere
    blochPhi    : Float;               // Azimuthal angle
    purity      : Float;               // tr(ρ²) - quantum state purity
    coherence   : Float;               // Off-diagonal density matrix element
  };

  /// Quantum Kuramoto state
  public type QuantumKuramotoState = {
    oscillators   : [QuantumOscillator];
    globalCoupling : Float;
    orderParam    : Float;
    meanPhase     : Float;
    beatNum       : Nat;
    // Quantum observables
    totalPurity   : Float;
    entanglement  : Float;
    quantumCorr   : Float;
    decoherenceRate : Float;
  };

  /// Initialize quantum Kuramoto
  public func initQuantumKuramoto() : QuantumKuramotoState {
    let oscs = Array.tabulate<QuantumOscillator>(18, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / 18.0;
        naturalFreq = ORGAN_FREQS[i];
        coupling = 1.0;
        amplitude = 1.0;
        blochTheta = PI / 4.0;  // Superposition state
        blochPhi = Float.fromInt(i) * TWO_PI / 18.0;
        purity = 1.0;  // Pure state initially
        coherence = 0.7;
      }
    });
    
    {
      oscillators     = oscs;
      globalCoupling  = 1.5;
      orderParam      = 0.5;
      meanPhase       = 0.0;
      beatNum         = 0;
      totalPurity     = 1.0;
      entanglement    = 0.0;
      quantumCorr     = 0.0;
      decoherenceRate = 0.01;
    }
  };

  /// Update quantum Kuramoto with decoherence
  public func beatQuantumKuramoto(state: QuantumKuramotoState, dt: Float) : QuantumKuramotoState {
    // Compute classical order parameter
    let classicalOscs = Array.map<QuantumOscillator, Oscillator>(state.oscillators, func(qo) {
      { phase = qo.phase; naturalFreq = qo.naturalFreq; coupling = qo.coupling; amplitude = qo.amplitude }
    });
    let (r, psi) = computeOrderParameter(classicalOscs);
    
    var newOscs : [QuantumOscillator] = [];
    var totalPurity : Float = 0.0;
    var totalCoherence : Float = 0.0;
    
    for (qo in state.oscillators.vals()) {
      // Classical Kuramoto update
      let coupling = qo.coupling * state.globalCoupling * r * Float.sin(psi - qo.phase);
      let newPhase = wrapPhase(qo.phase + (qo.naturalFreq + coupling) * dt);
      
      // Quantum dynamics: Bloch sphere rotation
      // Hamiltonian causes precession
      let newBlochPhi = wrapPhase(qo.blochPhi + qo.naturalFreq * dt);
      
      // Decoherence: purity decays, coherence decays
      let newPurity = qo.purity - state.decoherenceRate * qo.purity * dt;
      let newCoherence = qo.coherence * Float.exp(-state.decoherenceRate * dt);
      
      // Bloch theta tends toward equator (maximum entropy state) under decoherence
      let thetaRelax = (PI / 2.0 - qo.blochTheta) * state.decoherenceRate * dt;
      let newBlochTheta = qo.blochTheta + thetaRelax;
      
      totalPurity += newPurity;
      totalCoherence += newCoherence;
      
      newOscs := Array.append(newOscs, [{
        phase = newPhase;
        naturalFreq = qo.naturalFreq;
        coupling = qo.coupling;
        amplitude = qo.amplitude;
        blochTheta = _clamp(newBlochTheta, 0.0, PI);
        blochPhi = newBlochPhi;
        purity = _clamp(newPurity, 0.5, 1.0);
        coherence = _clamp(newCoherence, 0.0, 1.0);
      }]);
    };
    
    let n = Float.fromInt(state.oscillators.size());
    
    // Quantum correlations: measure phase coherence weighted by quantum coherence
    var quantumCorrSum : Float = 0.0;
    for (i in Array.keys(newOscs)) {
      for (j in Array.keys(newOscs)) {
        if (j > i) {
          let phaseCorr = Float.cos(newOscs[i].phase - newOscs[j].phase);
          let coherenceWeight = newOscs[i].coherence * newOscs[j].coherence;
          quantumCorrSum += phaseCorr * coherenceWeight;
        };
      };
    };
    let numPairs = n * (n - 1.0) / 2.0;
    let quantumCorr = quantumCorrSum / numPairs;
    
    // Entanglement proxy: deviation from product state
    let entanglement = Float.abs(quantumCorr) * (totalCoherence / n);
    
    {
      oscillators     = newOscs;
      globalCoupling  = state.globalCoupling;
      orderParam      = r;
      meanPhase       = psi;
      beatNum         = state.beatNum + 1;
      totalPurity     = totalPurity / n;
      entanglement    = _clamp(entanglement, 0.0, 1.0);
      quantumCorr     = quantumCorr;
      decoherenceRate = state.decoherenceRate;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 24: THERMODYNAMIC KURAMOTO — FREE ENERGY LANDSCAPE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Kuramoto from thermodynamic perspective
  // Free energy: F = -K·r² + T·S where S is entropy
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Thermodynamic Kuramoto state
  public type ThermodynamicKuramotoState = {
    oscillators    : [Oscillator];
    globalCoupling : Float;
    temperature    : Float;            // T - effective temperature
    orderParam     : Float;
    meanPhase      : Float;
    beatNum        : Nat;
    // Thermodynamic observables
    freeEnergy     : Float;            // F
    entropy        : Float;            // S
    internalEnergy : Float;            // U
    heatCapacity   : Float;            // C = dU/dT
    susceptibility : Float;            // χ = dr/dh
  };

  /// Initialize thermodynamic Kuramoto
  public func initThermodynamicKuramoto(temperature: Float) : ThermodynamicKuramotoState {
    let oscs = initOrganOscillators();
    {
      oscillators    = oscs;
      globalCoupling = 1.5;
      temperature    = temperature;
      orderParam     = 0.5;
      meanPhase      = 0.0;
      beatNum        = 0;
      freeEnergy     = 0.0;
      entropy        = 1.0;
      internalEnergy = 0.0;
      heatCapacity   = 1.0;
      susceptibility = 1.0;
    }
  };

  /// Compute entropy from phase distribution
  func computePhaseEntropy(oscs: [Oscillator]) : Float {
    let n = oscs.size();
    let numBins = 12;
    var bins : [Nat] = Array.tabulate<Nat>(numBins, func(_) { 0 });
    
    // Bin phases
    for (osc in oscs.vals()) {
      let binIdx = Int.abs(Float.toInt(osc.phase / TWO_PI * Float.fromInt(numBins))) % numBins;
      let binsMut = Array.thaw<Nat>(bins);
      binsMut[binIdx] := binsMut[binIdx] + 1;
      bins := Array.freeze(binsMut);
    };
    
    // Compute entropy: S = -Σ pᵢ log(pᵢ)
    var entropy : Float = 0.0;
    for (count in bins.vals()) {
      if (count > 0) {
        let p = Float.fromInt(count) / Float.fromInt(n);
        entropy -= p * Float.log(p);
      };
    };
    
    // Normalize by maximum entropy
    entropy / Float.log(Float.fromInt(numBins))
  };

  /// Update thermodynamic Kuramoto
  public func beatThermodynamicKuramoto(state: ThermodynamicKuramotoState, dt: Float) : ThermodynamicKuramotoState {
    let (r, psi) = computeOrderParameter(state.oscillators);
    
    // Add thermal fluctuations
    var currentSeed : Nat = state.beatNum * 12345 + 67890;
    var newOscs : [Oscillator] = [];
    
    for (osc in state.oscillators.vals()) {
      let (nextSeed, noise) = gaussianNoise(currentSeed);
      currentSeed := nextSeed;
      
      // Langevin dynamics with temperature
      let deterministicPart = osc.naturalFreq + state.globalCoupling * r * Float.sin(psi - osc.phase);
      let stochasticPart = Float.sqrt(2.0 * state.temperature * dt) * noise;
      let newPhase = wrapPhase(osc.phase + deterministicPart * dt + stochasticPart);
      
      newOscs := Array.append(newOscs, [{
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }]);
    };
    
    let (newR, newPsi) = computeOrderParameter(newOscs);
    
    // Compute thermodynamic quantities
    // Internal energy: U = -K·r²/2
    let U = -state.globalCoupling * newR * newR / 2.0;
    
    // Entropy from phase distribution
    let S = computePhaseEntropy(newOscs);
    
    // Free energy: F = U - T·S
    let F = U - state.temperature * S;
    
    // Heat capacity (approximate from energy fluctuations)
    let energyFluct = Float.abs(U - state.internalEnergy);
    let C = if (state.temperature > 0.01) { energyFluct / state.temperature } else { 1.0 };
    
    // Susceptibility (approximate from order parameter response)
    let rFluct = Float.abs(newR - state.orderParam);
    let chi = if (state.globalCoupling > 0.01) { rFluct / (state.globalCoupling * 0.01) } else { 1.0 };
    
    {
      oscillators    = newOscs;
      globalCoupling = state.globalCoupling;
      temperature    = state.temperature;
      orderParam     = newR;
      meanPhase      = newPsi;
      beatNum        = state.beatNum + 1;
      freeEnergy     = F;
      entropy        = S;
      internalEnergy = U;
      heatCapacity   = _clamp(C, 0.01, 100.0);
      susceptibility = _clamp(chi, 0.01, 100.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 25: INFORMATION-THEORETIC KURAMOTO — TRANSFER ENTROPY
  // ═══════════════════════════════════════════════════════════════════════════════
  // Measuring information flow between oscillators
  // Transfer entropy: T_{Y→X} = H(Xₜ|X_{t-1}) - H(Xₜ|X_{t-1},Y_{t-1})
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Information-theoretic Kuramoto state
  public type InfoTheoreticKuramotoState = {
    oscillators      : [Oscillator];
    phaseHistories   : [[Float]];      // History for each oscillator
    globalCoupling   : Float;
    orderParam       : Float;
    meanPhase        : Float;
    beatNum          : Nat;
    // Information measures
    mutualInfo       : [[Float]];      // Pairwise mutual information
    transferEntropy  : [[Float]];      // Pairwise transfer entropy
    integrationInfo  : Float;          // Φ - integrated information
    complexityIndex  : Float;          // Tononi complexity
  };

  /// Initialize info-theoretic Kuramoto
  public func initInfoTheoreticKuramoto() : InfoTheoreticKuramotoState {
    let n = 18;
    let oscs = initOrganOscillators();
    
    // Initialize empty histories
    let histories = Array.tabulate<[Float]>(n, func(_) { [] });
    
    // Initialize info matrices
    let zeroMatrix = Array.tabulate<[Float]>(n, func(_) {
      Array.tabulate<Float>(n, func(_) { 0.0 })
    });
    
    {
      oscillators    = oscs;
      phaseHistories = histories;
      globalCoupling = 1.5;
      orderParam     = 0.5;
      meanPhase      = 0.0;
      beatNum        = 0;
      mutualInfo     = zeroMatrix;
      transferEntropy = zeroMatrix;
      integrationInfo = 0.0;
      complexityIndex = 0.0;
    }
  };

  /// Estimate mutual information between two phase time series
  func estimateMutualInfo(x: [Float], y: [Float]) : Float {
    if (x.size() < 10 or y.size() < 10) { return 0.0 };
    
    let n = Nat.min(x.size(), y.size());
    let numBins = 8;
    
    // Joint and marginal histograms
    var jointHist : [[Nat]] = Array.tabulate<[Nat]>(numBins, func(_) {
      Array.tabulate<Nat>(numBins, func(_) { 0 })
    });
    var xHist : [Nat] = Array.tabulate<Nat>(numBins, func(_) { 0 });
    var yHist : [Nat] = Array.tabulate<Nat>(numBins, func(_) { 0 });
    
    for (i in Array.keys(Array.tabulate<Nat>(n, func(j) { j }))) {
      let xBin = Int.abs(Float.toInt(x[i] / TWO_PI * Float.fromInt(numBins))) % numBins;
      let yBin = Int.abs(Float.toInt(y[i] / TWO_PI * Float.fromInt(numBins))) % numBins;
      
      // Update x marginal
      let xHistMut = Array.thaw<Nat>(xHist);
      xHistMut[xBin] := xHistMut[xBin] + 1;
      xHist := Array.freeze(xHistMut);
      
      // Update y marginal
      let yHistMut = Array.thaw<Nat>(yHist);
      yHistMut[yBin] := yHistMut[yBin] + 1;
      yHist := Array.freeze(yHistMut);
      
      // Update joint
      let jointRow = Array.thaw<Nat>(jointHist[xBin]);
      jointRow[yBin] := jointRow[yBin] + 1;
      jointHist := Array.tabulate<[Nat]>(numBins, func(idx) {
        if (idx == xBin) { Array.freeze(jointRow) } else { jointHist[idx] }
      });
    };
    
    // Compute MI = Σ p(x,y) log(p(x,y) / (p(x)p(y)))
    var mi : Float = 0.0;
    let nf = Float.fromInt(n);
    
    for (xi in Array.keys(xHist)) {
      for (yi in Array.keys(yHist)) {
        let pxy = Float.fromInt(jointHist[xi][yi]) / nf;
        let px = Float.fromInt(xHist[xi]) / nf;
        let py = Float.fromInt(yHist[yi]) / nf;
        
        if (pxy > 1e-10 and px > 1e-10 and py > 1e-10) {
          mi += pxy * Float.log(pxy / (px * py));
        };
      };
    };
    
    _clamp(mi, 0.0, 5.0)
  };

  /// Update info-theoretic Kuramoto
  public func beatInfoTheoreticKuramoto(state: InfoTheoreticKuramotoState, dt: Float) : InfoTheoreticKuramotoState {
    let (r, psi) = computeOrderParameter(state.oscillators);
    
    // Update oscillators
    let newOscs = Array.map<Oscillator, Oscillator>(state.oscillators, func(osc) {
      let coupling = osc.coupling * state.globalCoupling * r * Float.sin(psi - osc.phase);
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
      {
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }
    });
    
    let (newR, newPsi) = computeOrderParameter(newOscs);
    let n = state.oscillators.size();
    
    // Update phase histories (keep last 100 values)
    var newHistories : [[Float]] = [];
    for (i in Array.keys(newOscs)) {
      let oldHist = state.phaseHistories[i];
      let newHist = if (oldHist.size() >= 100) {
        let tail = Array.tabulate<Float>(99, func(j) { oldHist[j + 1] });
        Array.append<Float>(tail, [newOscs[i].phase])
      } else {
        Array.append<Float>(oldHist, [newOscs[i].phase])
      };
      newHistories := Array.append(newHistories, [newHist]);
    };
    
    // Compute pairwise mutual information (simplified - only update some pairs)
    var newMutualInfo = state.mutualInfo;
    var totalMI : Float = 0.0;
    
    // Only compute for a subset of pairs to save computation
    if (state.beatNum % 10 == 0 and n > 1) {
      for (i in Array.keys(Array.tabulate<Nat>(Nat.min(n, 6), func(x) { x }))) {
        for (j in Array.keys(Array.tabulate<Nat>(Nat.min(n, 6), func(x) { x }))) {
          if (j > i) {
            let mi = estimateMutualInfo(newHistories[i], newHistories[j]);
            totalMI += mi;
            
            // Update MI matrix
            let row = Array.thaw<Float>(newMutualInfo[i]);
            row[j] := mi;
            newMutualInfo := Array.tabulate<[Float]>(n, func(idx) {
              if (idx == i) { Array.freeze(row) } else { newMutualInfo[idx] }
            });
          };
        };
      };
    };
    
    // Integrated information proxy (Φ)
    // Φ ≈ total MI - sum of partition MIs (simplified)
    let numPairs = if (n > 1) { Float.fromInt(n * (n - 1) / 2) } else { 1.0 };
    let phi = totalMI / numPairs;
    
    // Complexity (Tononi): C = Σᵢ I(Xᵢ; X_rest)
    // Approximated as average MI
    let complexity = phi * newR;  // Scale by coherence
    
    {
      oscillators    = newOscs;
      phaseHistories = newHistories;
      globalCoupling = state.globalCoupling;
      orderParam     = newR;
      meanPhase      = newPsi;
      beatNum        = state.beatNum + 1;
      mutualInfo     = newMutualInfo;
      transferEntropy = state.transferEntropy;  // Would compute similarly
      integrationInfo = _clamp(phi, 0.0, 5.0);
      complexityIndex = _clamp(complexity, 0.0, 5.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 26: METASTABLE DYNAMICS — SADDLE POINT NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════════
  // Kuramoto system navigating between metastable states
  // Dwell time analysis and transition probabilities
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Metastable state representation
  public type MetastableState = {
    attractorR     : Float;            // Characteristic order parameter
    attractorPsi   : Float;            // Characteristic mean phase
    dwellTime      : Nat;              // Time spent in this state
    visitCount     : Nat;              // Number of visits
    basinRadius    : Float;            // Size of attraction basin
  };

  /// Metastable Kuramoto state
  public type MetastableKuramotoState = {
    oscillators     : [Oscillator];
    globalCoupling  : Float;
    orderParam      : Float;
    meanPhase       : Float;
    beatNum         : Nat;
    // Metastability
    knownStates     : [MetastableState];
    currentStateIdx : ?Nat;            // Which metastable state we're in
    transitionProbs : [[Float]];       // State transition matrix
    dwellTimeHist   : [Nat];           // Histogram of dwell times
  };

  /// Initialize metastable Kuramoto
  public func initMetastableKuramoto() : MetastableKuramotoState {
    let oscs = initOrganOscillators();
    
    // Define some known metastable states
    let states = [
      { attractorR = 0.9; attractorPsi = 0.0; dwellTime = 0; visitCount = 0; basinRadius = 0.1 },
      { attractorR = 0.5; attractorPsi = PI / 2.0; dwellTime = 0; visitCount = 0; basinRadius = 0.15 },
      { attractorR = 0.3; attractorPsi = PI; dwellTime = 0; visitCount = 0; basinRadius = 0.2 },
    ];
    
    let numStates = states.size();
    let transitions = Array.tabulate<[Float]>(numStates, func(_) {
      Array.tabulate<Float>(numStates, func(_) { 0.0 })
    });
    
    {
      oscillators     = oscs;
      globalCoupling  = 1.5;
      orderParam      = 0.5;
      meanPhase       = 0.0;
      beatNum         = 0;
      knownStates     = states;
      currentStateIdx = null;
      transitionProbs = transitions;
      dwellTimeHist   = [];
    }
  };

  /// Determine which metastable state we're closest to
  func findClosestState(r: Float, psi: Float, states: [MetastableState]) : ?Nat {
    var minDist : Float = 1e10;
    var closestIdx : ?Nat = null;
    
    for (i in Array.keys(states)) {
      let state = states[i];
      let rDist = Float.abs(r - state.attractorR);
      let psiDist = Float.abs(psi - state.attractorPsi);
      let dist = Float.sqrt(rDist * rDist + psiDist * psiDist);
      
      if (dist < minDist and dist < state.basinRadius) {
        minDist := dist;
        closestIdx := ?i;
      };
    };
    
    closestIdx
  };

  /// Update metastable Kuramoto
  public func beatMetastableKuramoto(state: MetastableKuramotoState, dt: Float) : MetastableKuramotoState {
    let (r, psi) = computeOrderParameter(state.oscillators);
    
    // Add noise to encourage transitions
    var currentSeed : Nat = state.beatNum * 54321 + 12345;
    var newOscs : [Oscillator] = [];
    
    for (osc in state.oscillators.vals()) {
      let (nextSeed, noise) = gaussianNoise(currentSeed);
      currentSeed := nextSeed;
      
      let coupling = osc.coupling * state.globalCoupling * r * Float.sin(psi - osc.phase);
      let noiseStrength = 0.05;
      let stochastic = noiseStrength * Float.sqrt(dt) * noise;
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt + stochastic);
      
      newOscs := Array.append(newOscs, [{
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }]);
    };
    
    let (newR, newPsi) = computeOrderParameter(newOscs);
    
    // Determine current metastable state
    let newStateIdx = findClosestState(newR, newPsi, state.knownStates);
    
    // Update state tracking
    var newKnownStates = state.knownStates;
    var newTransitions = state.transitionProbs;
    var newDwellHist = state.dwellTimeHist;
    
    switch (newStateIdx) {
      case (?newIdx) {
        // Update dwell time
        let oldState = newKnownStates[newIdx];
        let newDwell = switch (state.currentStateIdx) {
          case (?oldIdx) {
            if (oldIdx == newIdx) { oldState.dwellTime + 1 }
            else {
              // Transition occurred!
              // Update transition matrix
              let row = Array.thaw<Float>(newTransitions[oldIdx]);
              row[newIdx] := row[newIdx] + 1.0;
              newTransitions := Array.tabulate<[Float]>(state.knownStates.size(), func(idx) {
                if (idx == oldIdx) { Array.freeze(row) } else { newTransitions[idx] }
              });
              
              // Record old dwell time in histogram
              if (oldState.dwellTime > 0) {
                newDwellHist := Array.append(newDwellHist, [oldState.dwellTime]);
              };
              
              1  // Reset dwell time
            }
          };
          case null { 1 };
        };
        
        // Update known state
        let updatedState : MetastableState = {
          attractorR = oldState.attractorR;
          attractorPsi = oldState.attractorPsi;
          dwellTime = newDwell;
          visitCount = switch (state.currentStateIdx) {
            case (?oldIdx) { if (oldIdx == newIdx) { oldState.visitCount } else { oldState.visitCount + 1 } };
            case null { oldState.visitCount + 1 };
          };
          basinRadius = oldState.basinRadius;
        };
        
        newKnownStates := Array.tabulate<MetastableState>(state.knownStates.size(), func(idx) {
          if (idx == newIdx) { updatedState } else { newKnownStates[idx] }
        });
      };
      case null { /* Not in any known state */ };
    };
    
    {
      oscillators     = newOscs;
      globalCoupling  = state.globalCoupling;
      orderParam      = newR;
      meanPhase       = newPsi;
      beatNum         = state.beatNum + 1;
      knownStates     = newKnownStates;
      currentStateIdx = newStateIdx;
      transitionProbs = newTransitions;
      dwellTimeHist   = newDwellHist;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 27: MASTER OUTPUT — ALL KURAMOTO EXTENSIONS COMBINED
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Master Kuramoto state combining all extensions
  public type MasterKuramotoState = {
    // Core states
    standard        : KuramotoState;
    sakaguchi       : KuramotoSakaguchiState;
    hierarchical    : HierarchicalKuramotoState;
    stochastic      : StochasticKuramotoState;
    adaptive        : AdaptiveFreqKuramotoState;
    inertial        : InertialKuramotoState;
    delayed         : DelayedKuramotoState;
    nonlocal        : NonlocalKuramotoState;
    pac             : PACKuramotoState;
    higherHarmonic  : HigherHarmonicKuramotoState;
    // Advanced states
    ks              : KuramotoSivashinskyState;
    neuralField     : NeuralFieldKuramotoState;
    quantum         : QuantumKuramotoState;
    thermodynamic   : ThermodynamicKuramotoState;
    infoTheoretic   : InfoTheoreticKuramotoState;
    metastable      : MetastableKuramotoState;
    swarm           : SwarmKuramotoState;
    // Control
    activeMode      : Text;
    beatNum         : Nat;
  };

  /// Initialize master state
  public func initMasterKuramoto(swarmSize: Nat, squadrons: Nat) : MasterKuramotoState {
    {
      standard        = initKuramoto();
      sakaguchi       = initKuramotoSakaguchi(0.1);
      hierarchical    = initHierarchicalKuramoto(3.0);
      stochastic      = initStochasticKuramoto(0.05, 12345);
      adaptive        = initAdaptiveFreqKuramoto(0.01);
      inertial        = initInertialKuramoto(1.0, 0.5);
      delayed         = initDelayedKuramoto(5);
      nonlocal        = initNonlocalKuramoto(26, 3.0);
      pac             = initPACKuramoto();
      higherHarmonic  = initHigherHarmonicKuramoto(4);
      ks              = initKuramotoSivashinsky(64);
      neuralField     = initNeuralFieldKuramoto(32);
      quantum         = initQuantumKuramoto();
      thermodynamic   = initThermodynamicKuramoto(0.1);
      infoTheoretic   = initInfoTheoreticKuramoto();
      metastable      = initMetastableKuramoto();
      swarm           = initSwarmKuramoto(swarmSize, squadrons);
      activeMode      = "standard";
      beatNum         = 0;
    }
  };

  /// Update selected subsystem
  public func beatMasterKuramoto(state: MasterKuramotoState, dt: Float, mode: Text) : MasterKuramotoState {
    {
      standard        = if (mode == "standard" or mode == "all") { beatKuramoto(state.standard, dt) } else { state.standard };
      sakaguchi       = if (mode == "sakaguchi" or mode == "all") { beatKuramotoSakaguchi(state.sakaguchi, dt) } else { state.sakaguchi };
      hierarchical    = if (mode == "hierarchical" or mode == "all") { beatHierarchicalKuramoto(state.hierarchical, dt) } else { state.hierarchical };
      stochastic      = if (mode == "stochastic" or mode == "all") { beatStochasticKuramoto(state.stochastic, dt) } else { state.stochastic };
      adaptive        = if (mode == "adaptive" or mode == "all") { beatAdaptiveFreqKuramoto(state.adaptive, dt) } else { state.adaptive };
      inertial        = if (mode == "inertial" or mode == "all") { beatInertialKuramoto(state.inertial, dt) } else { state.inertial };
      delayed         = if (mode == "delayed" or mode == "all") { beatDelayedKuramoto(state.delayed, dt) } else { state.delayed };
      nonlocal        = if (mode == "nonlocal" or mode == "all") { beatNonlocalKuramoto(state.nonlocal, dt) } else { state.nonlocal };
      pac             = if (mode == "pac" or mode == "all") { beatPACKuramoto(state.pac, dt) } else { state.pac };
      higherHarmonic  = if (mode == "harmonic" or mode == "all") { beatHigherHarmonicKuramoto(state.higherHarmonic, dt) } else { state.higherHarmonic };
      ks              = if (mode == "ks" or mode == "all") { beatKuramotoSivashinsky(state.ks, dt) } else { state.ks };
      neuralField     = if (mode == "neural" or mode == "all") { beatNeuralFieldKuramoto(state.neuralField, dt) } else { state.neuralField };
      quantum         = if (mode == "quantum" or mode == "all") { beatQuantumKuramoto(state.quantum, dt) } else { state.quantum };
      thermodynamic   = if (mode == "thermo" or mode == "all") { beatThermodynamicKuramoto(state.thermodynamic, dt) } else { state.thermodynamic };
      infoTheoretic   = if (mode == "info" or mode == "all") { beatInfoTheoreticKuramoto(state.infoTheoretic, dt) } else { state.infoTheoretic };
      metastable      = if (mode == "metastable" or mode == "all") { beatMetastableKuramoto(state.metastable, dt) } else { state.metastable };
      swarm           = if (mode == "swarm" or mode == "all") { beatSwarmKuramoto(state.swarm, dt) } else { state.swarm };
      activeMode      = mode;
      beatNum         = state.beatNum + 1;
    }
  };

  /// Get unified output from master state
  public func getMasterOutput(state: MasterKuramotoState) : {
    // Core metrics
    orderParameter    : Float;
    meanPhase         : Float;
    coherenceLevel    : Float;
    stability         : Float;
    
    // Multi-scale
    microSync         : Float;
    mesoSync          : Float;
    macroSync         : Float;
    crossScaleCoherence : Float;
    
    // Advanced metrics
    chimericity       : Float;
    pacStrength       : Float;
    quantumCoherence  : Float;
    freeEnergy        : Float;
    entropy           : Float;
    integrationInfo   : Float;
    
    // Swarm metrics
    swarmSync         : Float;
    formationQuality  : Float;
    velocityAlignment : Float;
    
    // Mode info
    activeMode        : Text;
    beatNum           : Nat;
  } {
    {
      orderParameter    = state.standard.orderParam;
      meanPhase         = state.standard.meanPhase;
      coherenceLevel    = state.standard.orderParam;
      stability         = 1.0 - syncVariance(state.standard);
      
      microSync         = if (state.hierarchical.levels.size() > 0) { state.hierarchical.levels[0].levelR } else { 0.5 };
      mesoSync          = if (state.hierarchical.levels.size() > 1) { state.hierarchical.levels[1].levelR } else { 0.5 };
      macroSync         = if (state.hierarchical.levels.size() > 2) { state.hierarchical.levels[2].levelR } else { 0.5 };
      crossScaleCoherence = if (state.hierarchical.crossLevelSync.size() > 0) { state.hierarchical.crossLevelSync[0] } else { 0.5 };
      
      chimericity       = if (state.nonlocal.domainWallCount > 2) { 1.0 } else { 0.0 };
      pacStrength       = state.pac.modulationIndex;
      quantumCoherence  = state.quantum.totalPurity;
      freeEnergy        = state.thermodynamic.freeEnergy;
      entropy           = state.thermodynamic.entropy;
      integrationInfo   = state.infoTheoretic.integrationInfo;
      
      swarmSync         = state.swarm.orderParam;
      formationQuality  = state.swarm.formationCoherence;
      velocityAlignment = state.swarm.velocityAlign;
      
      activeMode        = state.activeMode;
      beatNum           = state.beatNum;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 28: RESONANCE ANALYSIS — ARNOL'D TONGUES & FREQUENCY LOCKING
  // ═══════════════════════════════════════════════════════════════════════════════
  // Analysis of resonance regions in parameter space
  // Arnol'd tongues: regions where oscillators lock to rational frequency ratios
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Resonance state for frequency locking analysis
  public type ResonanceState = {
    oscillators     : [Oscillator];
    drivingFreq     : Float;           // External driving frequency
    drivingAmp      : Float;           // External driving amplitude
    globalCoupling  : Float;
    orderParam      : Float;
    meanPhase       : Float;
    beatNum         : Nat;
    // Resonance observables
    lockingRatio    : (Nat, Nat);      // p:q frequency ratio
    detuning        : Float;           // δ = ω - ω_d
    tongueWidth     : Float;           // Width of Arnol'd tongue
    lockingStrength : Float;           // 0-1 measure of lock quality
    winding         : Float;           // Winding number
  };

  /// Initialize resonance analysis state
  public func initResonanceState(drivingFreq: Float, drivingAmp: Float) : ResonanceState {
    let oscs = initOrganOscillators();
    {
      oscillators     = oscs;
      drivingFreq     = drivingFreq;
      drivingAmp      = drivingAmp;
      globalCoupling  = 1.5;
      orderParam      = 0.5;
      meanPhase       = 0.0;
      beatNum         = 0;
      lockingRatio    = (1, 1);
      detuning        = 0.0;
      tongueWidth     = 0.0;
      lockingStrength = 0.0;
      winding         = 0.0;
    }
  };

  /// Detect frequency locking ratio (simplified - checks common ratios)
  func detectLockingRatio(freq: Float, drivingFreq: Float) : (Nat, Nat) {
    // Common ratios to check: 1:1, 1:2, 2:1, 2:3, 3:2, 1:3, 3:1
    let ratios : [(Nat, Nat)] = [(1,1), (1,2), (2,1), (2,3), (3,2), (1,3), (3,1), (3,4), (4,3)];
    
    var bestRatio = (1, 1);
    var bestError : Float = 1.0;
    
    for ((p, q) in ratios.vals()) {
      let targetRatio = Float.fromInt(p) / Float.fromInt(q);
      let actualRatio = if (drivingFreq > 1e-10) { freq / drivingFreq } else { 1.0 };
      let error = Float.abs(actualRatio - targetRatio);
      
      if (error < bestError and error < 0.1) {
        bestError := error;
        bestRatio := (p, q);
      };
    };
    
    bestRatio
  };

  /// Update resonance state with external driving
  public func beatResonanceState(state: ResonanceState, dt: Float) : ResonanceState {
    let (r, psi) = computeOrderParameter(state.oscillators);
    let drivingPhase = Float.fromInt(state.beatNum) * state.drivingFreq * dt;
    
    // Update oscillators with both internal coupling and external driving
    let newOscs = Array.map<Oscillator, Oscillator>(state.oscillators, func(osc) {
      // Internal Kuramoto coupling
      let internalCoupling = osc.coupling * state.globalCoupling * r * Float.sin(psi - osc.phase);
      
      // External periodic forcing
      let externalForcing = state.drivingAmp * Float.sin(drivingPhase - osc.phase);
      
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + internalCoupling + externalForcing) * dt);
      {
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }
    });
    
    let (newR, newPsi) = computeOrderParameter(newOscs);
    
    // Compute effective frequency
    var totalFreq : Float = 0.0;
    for (osc in newOscs.vals()) {
      totalFreq += osc.naturalFreq;
    };
    let meanFreq = totalFreq / Float.fromInt(newOscs.size());
    
    // Detuning
    let detuning = meanFreq - state.drivingFreq;
    
    // Detect locking ratio
    let ratio = detectLockingRatio(meanFreq, state.drivingFreq);
    
    // Locking strength: how close is mean phase to driving phase
    let phaseDiff = Float.abs(newPsi - drivingPhase);
    let lockStrength = Float.cos(phaseDiff);
    
    // Tongue width estimate (inversely proportional to detuning needed to break lock)
    let tongueWidth = if (Float.abs(lockStrength) > 0.5) {
      state.drivingAmp / (Float.abs(detuning) + 0.01)
    } else { 0.0 };
    
    // Winding number: asymptotic rotation rate
    let winding = meanFreq / state.drivingFreq;
    
    {
      oscillators     = newOscs;
      drivingFreq     = state.drivingFreq;
      drivingAmp      = state.drivingAmp;
      globalCoupling  = state.globalCoupling;
      orderParam      = newR;
      meanPhase       = newPsi;
      beatNum         = state.beatNum + 1;
      lockingRatio    = ratio;
      detuning        = detuning;
      tongueWidth     = _clamp(tongueWidth, 0.0, 10.0);
      lockingStrength = _clamp(lockStrength, -1.0, 1.0);
      winding         = winding;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 29: CLUSTER SYNCHRONIZATION — PARTIAL SYNC PATTERNS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Oscillators form clusters that synchronize internally
  // Different clusters may rotate at different speeds
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Cluster definition
  public type OscillatorCluster = {
    members     : [Nat];               // Indices of oscillators in cluster
    clusterR    : Float;               // Internal order parameter
    clusterPsi  : Float;               // Cluster mean phase
    centerFreq  : Float;               // Cluster rotation frequency
    stability   : Float;               // Cluster cohesion
  };

  /// Cluster synchronization state
  public type ClusterSyncState = {
    oscillators     : [Oscillator];
    clusters        : [OscillatorCluster];
    globalCoupling  : Float;
    intraCoupling   : Float;           // Coupling within clusters
    interCoupling   : Float;           // Coupling between clusters
    orderParam      : Float;
    meanPhase       : Float;
    beatNum         : Nat;
    // Cluster metrics
    numClusters     : Nat;
    clusterBalance  : Float;           // Evenness of cluster sizes
    interClusterSync : Float;          // Sync between clusters
  };

  /// K-means-like clustering based on phase
  func clusterOscillators(oscs: [Oscillator], k: Nat) : [OscillatorCluster] {
    let n = oscs.size();
    if (k == 0 or n == 0) { return [] };
    
    // Initialize cluster centers evenly distributed
    var centers : [Float] = Array.tabulate<Float>(k, func(i) {
      Float.fromInt(i) * TWO_PI / Float.fromInt(k)
    });
    
    // Assign oscillators to nearest cluster
    var assignments : [Nat] = Array.tabulate<Nat>(n, func(_) { 0 });
    
    for (_ in Array.keys(Array.tabulate<Nat>(5, func(x) { x }))) {  // 5 iterations
      // Assign to nearest center
      for (i in Array.keys(oscs)) {
        var minDist : Float = 1e10;
        var nearestCluster : Nat = 0;
        
        for (c in Array.keys(centers)) {
          var dist = Float.abs(oscs[i].phase - centers[c]);
          if (dist > PI) { dist := TWO_PI - dist };  // Circular distance
          
          if (dist < minDist) {
            minDist := dist;
            nearestCluster := c;
          };
        };
        
        let assignMut = Array.thaw<Nat>(assignments);
        assignMut[i] := nearestCluster;
        assignments := Array.freeze(assignMut);
      };
      
      // Update centers
      for (c in Array.keys(centers)) {
        var sumCos : Float = 0.0;
        var sumSin : Float = 0.0;
        var count : Nat = 0;
        
        for (i in Array.keys(oscs)) {
          if (assignments[i] == c) {
            sumCos += Float.cos(oscs[i].phase);
            sumSin += Float.sin(oscs[i].phase);
            count += 1;
          };
        };
        
        if (count > 0) {
          let newCenter = Float.arctan2(sumSin, sumCos);
          let centersMut = Array.thaw<Float>(centers);
          centersMut[c] := wrapPhase(newCenter);
          centers := Array.freeze(centersMut);
        };
      };
    };
    
    // Build cluster objects
    var clusters : [OscillatorCluster] = [];
    
    for (c in Array.keys(centers)) {
      var members : [Nat] = [];
      var sumCos : Float = 0.0;
      var sumSin : Float = 0.0;
      var sumFreq : Float = 0.0;
      
      for (i in Array.keys(oscs)) {
        if (assignments[i] == c) {
          members := Array.append(members, [i]);
          sumCos += Float.cos(oscs[i].phase);
          sumSin += Float.sin(oscs[i].phase);
          sumFreq += oscs[i].naturalFreq;
        };
      };
      
      let clusterSize = members.size();
      if (clusterSize > 0) {
        let clusterR = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(clusterSize);
        let clusterPsi = Float.arctan2(sumSin, sumCos);
        let centerFreq = sumFreq / Float.fromInt(clusterSize);
        
        clusters := Array.append(clusters, [{
          members = members;
          clusterR = clusterR;
          clusterPsi = clusterPsi;
          centerFreq = centerFreq;
          stability = clusterR;  // High R = stable cluster
        }]);
      };
    };
    
    clusters
  };

  /// Initialize cluster sync state
  public func initClusterSyncState(numClusters: Nat) : ClusterSyncState {
    let oscs = initOrganOscillators();
    let clusters = clusterOscillators(oscs, numClusters);
    
    {
      oscillators     = oscs;
      clusters        = clusters;
      globalCoupling  = 1.5;
      intraCoupling   = 2.0;   // Strong within clusters
      interCoupling   = 0.3;   // Weak between clusters
      orderParam      = 0.5;
      meanPhase       = 0.0;
      beatNum         = 0;
      numClusters     = numClusters;
      clusterBalance  = 1.0;
      interClusterSync = 0.0;
    }
  };

  /// Update cluster sync state
  public func beatClusterSyncState(state: ClusterSyncState, dt: Float) : ClusterSyncState {
    let n = state.oscillators.size();
    var newOscs : [Oscillator] = [];
    
    // Create lookup for which cluster each oscillator belongs to
    var clusterLookup : [?Nat] = Array.tabulate<?Nat>(n, func(_) { null });
    for (cIdx in Array.keys(state.clusters)) {
      let cluster = state.clusters[cIdx];
      for (memberIdx in cluster.members.vals()) {
        if (memberIdx < n) {
          let lookupMut = Array.thaw<?Nat>(clusterLookup);
          lookupMut[memberIdx] := ?cIdx;
          clusterLookup := Array.freeze(lookupMut);
        };
      };
    };
    
    // Update each oscillator
    for (i in Array.keys(state.oscillators)) {
      let osc = state.oscillators[i];
      var intraCoup : Float = 0.0;
      var interCoup : Float = 0.0;
      
      let myCluster = clusterLookup[i];
      
      for (j in Array.keys(state.oscillators)) {
        if (i != j) {
          let other = state.oscillators[j];
          let otherCluster = clusterLookup[j];
          
          let sameCluster = switch (myCluster, otherCluster) {
            case (?mc, ?oc) { mc == oc };
            case _ { false };
          };
          
          if (sameCluster) {
            intraCoup += Float.sin(other.phase - osc.phase);
          } else {
            interCoup += Float.sin(other.phase - osc.phase);
          };
        };
      };
      
      // Normalize and combine
      let intraForce = state.intraCoupling * intraCoup / Float.fromInt(n);
      let interForce = state.interCoupling * interCoup / Float.fromInt(n);
      let totalForce = intraForce + interForce;
      
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + totalForce) * dt);
      newOscs := Array.append(newOscs, [{
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }]);
    };
    
    // Re-cluster periodically
    let newClusters = if (state.beatNum % 20 == 0) {
      clusterOscillators(newOscs, state.numClusters)
    } else {
      // Just update cluster stats
      Array.map<OscillatorCluster, OscillatorCluster>(state.clusters, func(cluster) {
        var sumCos : Float = 0.0;
        var sumSin : Float = 0.0;
        for (idx in cluster.members.vals()) {
          if (idx < newOscs.size()) {
            sumCos += Float.cos(newOscs[idx].phase);
            sumSin += Float.sin(newOscs[idx].phase);
          };
        };
        let clusterR = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(Nat.max(1, cluster.members.size()));
        let clusterPsi = Float.arctan2(sumSin, sumCos);
        {
          members = cluster.members;
          clusterR = clusterR;
          clusterPsi = clusterPsi;
          centerFreq = cluster.centerFreq;
          stability = clusterR;
        }
      })
    };
    
    let (globalR, globalPsi) = computeOrderParameter(newOscs);
    
    // Compute cluster balance (how even are cluster sizes)
    var sizeSum : Float = 0.0;
    var sizeSqSum : Float = 0.0;
    for (cluster in newClusters.vals()) {
      let s = Float.fromInt(cluster.members.size());
      sizeSum += s;
      sizeSqSum += s * s;
    };
    let meanSize = sizeSum / Float.fromInt(Nat.max(1, newClusters.size()));
    let sizeVar = sizeSqSum / Float.fromInt(Nat.max(1, newClusters.size())) - meanSize * meanSize;
    let balance = 1.0 / (1.0 + sizeVar);
    
    // Inter-cluster sync: correlation of cluster mean phases
    var interSync : Float = 0.0;
    let nc = newClusters.size();
    if (nc > 1) {
      var sumCorr : Float = 0.0;
      var count : Nat = 0;
      for (i in Array.keys(newClusters)) {
        for (j in Array.keys(newClusters)) {
          if (j > i) {
            sumCorr += Float.cos(newClusters[i].clusterPsi - newClusters[j].clusterPsi);
            count += 1;
          };
        };
      };
      interSync := sumCorr / Float.fromInt(Nat.max(1, count));
    };
    
    {
      oscillators     = newOscs;
      clusters        = newClusters;
      globalCoupling  = state.globalCoupling;
      intraCoupling   = state.intraCoupling;
      interCoupling   = state.interCoupling;
      orderParam      = globalR;
      meanPhase       = globalPsi;
      beatNum         = state.beatNum + 1;
      numClusters     = state.numClusters;
      clusterBalance  = _clamp(balance, 0.0, 1.0);
      interClusterSync = _clamp(interSync, -1.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 30: EXPLOSIVE SYNCHRONIZATION — FIRST-ORDER TRANSITION
  // ═══════════════════════════════════════════════════════════════════════════════
  // Correlating natural frequency with degree creates explosive (first-order) sync
  // Exhibits hysteresis and discontinuous transition
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Explosive sync state
  public type ExplosiveSyncState = {
    oscillators      : [Oscillator];
    degrees          : [Float];        // Node connectivity
    adjacency        : [[Float]];
    globalCoupling   : Float;
    orderParam       : Float;
    meanPhase        : Float;
    beatNum          : Nat;
    // Explosion observables
    freqDegreCorr    : Float;          // Correlation between ω and k
    hysteresis       : Bool;           // In hysteresis region
    backwardR        : Float;          // R when decreasing K
    forwardR         : Float;          // R when increasing K
    transitionK      : Float;          // Critical coupling for transition
  };

  /// Initialize explosive sync (correlated freq-degree)
  public func initExplosiveSync(n: Nat, correlationStrength: Float) : ExplosiveSyncState {
    // Create scale-free-like network
    var adj = Array.tabulate<[Float]>(n, func(_) {
      Array.tabulate<Float>(n, func(_) { 0.0 })
    });
    
    // Simple preferential attachment approximation
    for (i in Array.keys(Array.tabulate<Nat>(n, func(x) { x }))) {
      if (i > 0) {
        // Connect to earlier nodes with probability proportional to degree
        var targetProbs : [Float] = [];
        var totalProb : Float = 0.0;
        for (j in Array.keys(Array.tabulate<Nat>(i, func(x) { x }))) {
          var degree : Float = 1.0;  // Base degree
          for (k in Array.keys(adj[j])) {
            if (adj[j][k] > 0.0) { degree += 1.0 };
          };
          targetProbs := Array.append(targetProbs, [degree]);
          totalProb += degree;
        };
        
        // Connect to 2-3 nodes
        let numConnections = 2 + i % 2;
        for (_ in Array.keys(Array.tabulate<Nat>(numConnections, func(x) { x }))) {
          // Select target (deterministic for reproducibility)
          var cumProb : Float = 0.0;
          let threshold = Float.fromInt(i * 12345 % 1000) / 1000.0 * totalProb;
          for (j in Array.keys(targetProbs)) {
            cumProb += targetProbs[j];
            if (cumProb >= threshold and adj[i][j] < 0.5) {
              // Add edge
              let rowI = Array.thaw<Float>(adj[i]);
              rowI[j] := 1.0;
              adj := Array.tabulate<[Float]>(n, func(idx) {
                if (idx == i) { Array.freeze(rowI) } else { adj[idx] }
              });
              
              let rowJ = Array.thaw<Float>(adj[j]);
              rowJ[i] := 1.0;
              adj := Array.tabulate<[Float]>(n, func(idx) {
                if (idx == j) { Array.freeze(rowJ) } else { adj[idx] }
              });
            };
          };
        };
      };
    };
    
    // Compute degrees
    let degrees = computeDegrees(adj);
    
    // Set natural frequencies correlated with degree
    let oscs = Array.tabulate<Oscillator>(n, func(i) {
      let degree = degrees[i];
      let baseFreq = 0.1;
      // Correlation: high degree = high frequency (or vice versa)
      let freq = baseFreq + correlationStrength * (degree - 2.0) * 0.01;
      {
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(n);
        naturalFreq = _clamp(freq, 0.01, 0.5);
        coupling = 1.0;
        amplitude = 1.0;
      }
    });
    
    // Compute freq-degree correlation
    var sumFreq : Float = 0.0;
    var sumDeg : Float = 0.0;
    var sumFreqDeg : Float = 0.0;
    var sumFreqSq : Float = 0.0;
    var sumDegSq : Float = 0.0;
    
    for (i in Array.keys(oscs)) {
      let f = oscs[i].naturalFreq;
      let d = degrees[i];
      sumFreq += f;
      sumDeg += d;
      sumFreqDeg += f * d;
      sumFreqSq += f * f;
      sumDegSq += d * d;
    };
    
    let nf = Float.fromInt(n);
    let meanF = sumFreq / nf;
    let meanD = sumDeg / nf;
    let cov = sumFreqDeg / nf - meanF * meanD;
    let stdF = Float.sqrt(sumFreqSq / nf - meanF * meanF);
    let stdD = Float.sqrt(sumDegSq / nf - meanD * meanD);
    let corr = if (stdF > 1e-10 and stdD > 1e-10) { cov / (stdF * stdD) } else { 0.0 };
    
    {
      oscillators     = oscs;
      degrees         = degrees;
      adjacency       = adj;
      globalCoupling  = 0.5;  // Start below transition
      orderParam      = 0.1;
      meanPhase       = 0.0;
      beatNum         = 0;
      freqDegreCorr   = corr;
      hysteresis      = false;
      backwardR       = 0.1;
      forwardR        = 0.1;
      transitionK     = 1.0;
    }
  };

  /// Update explosive sync
  public func beatExplosiveSync(state: ExplosiveSyncState, dt: Float) : ExplosiveSyncState {
    let n = state.oscillators.size();
    var newOscs : [Oscillator] = [];
    
    for (i in Array.keys(state.oscillators)) {
      let osc = state.oscillators[i];
      let degree = state.degrees[i];
      
      var couplingSum : Float = 0.0;
      for (j in Array.keys(state.oscillators)) {
        if (state.adjacency[i][j] > 0.0) {
          let neighbor = state.oscillators[j];
          couplingSum += Float.sin(neighbor.phase - osc.phase);
        };
      };
      
      // Normalize by degree
      let coupling = state.globalCoupling * couplingSum / degree;
      let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
      
      newOscs := Array.append(newOscs, [{
        phase = newPhase;
        naturalFreq = osc.naturalFreq;
        coupling = osc.coupling;
        amplitude = osc.amplitude;
      }]);
    };
    
    let (r, psi) = computeOrderParameter(newOscs);
    
    // Track forward/backward R for hysteresis detection
    let forwardR = if (state.globalCoupling > state.transitionK) { r } else { state.forwardR };
    let backwardR = if (state.globalCoupling < state.transitionK) { r } else { state.backwardR };
    
    // Hysteresis: different R values at same K depending on history
    let hysteresis = Float.abs(forwardR - backwardR) > 0.2;
    
    {
      oscillators     = newOscs;
      degrees         = state.degrees;
      adjacency       = state.adjacency;
      globalCoupling  = state.globalCoupling;
      orderParam      = r;
      meanPhase       = psi;
      beatNum         = state.beatNum + 1;
      freqDegreCorr   = state.freqDegreCorr;
      hysteresis      = hysteresis;
      backwardR       = backwardR;
      forwardR        = forwardR;
      transitionK     = state.transitionK;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 31: CHIMERA SWARM INTELLIGENCE — CORE PRODUCT ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // This is the CHIMERA SWARM INTELLIGENCE product — the flagship enterprise offering
  // Combines all Kuramoto dynamics with swarm coordination for autonomous systems
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Chimera Swarm Agent - autonomous entity with chimeric behavior
  public type ChimeraSwarmAgent = {
    // Identity
    id              : Nat;
    squadron        : Nat;
    role            : Text;            // "leader", "scout", "defender", "support"
    
    // Physical state
    position        : { x: Float; y: Float; z: Float };
    velocity        : { vx: Float; vy: Float; vz: Float };
    heading         : Float;
    altitude        : Float;
    
    // Kuramoto oscillator (internal clock)
    phase           : Float;
    naturalFreq     : Float;
    amplitude       : Float;
    
    // Chimera state
    coherenceMode   : Text;            // "coherent", "incoherent", "transitioning"
    localR          : Float;
    localPsi        : Float;
    
    // Communication
    perception      : Float;
    signalStrength  : Float;
    lastContact     : Nat;
    
    // Mission
    targetPosition  : { x: Float; y: Float; z: Float };
    missionState    : Text;
    threat          : Float;
  };

  /// Chimera Swarm Intelligence State
  public type ChimeraSwarmState = {
    // Swarm composition
    agents          : [ChimeraSwarmAgent];
    squadrons       : Nat;
    totalSize       : Nat;
    
    // Global coordination
    globalR         : Float;
    globalPsi       : Float;
    swarmCentroid   : { x: Float; y: Float; z: Float };
    swarmSpread     : Float;
    
    // Chimera dynamics
    coherentRegions : Nat;
    incoherentRegions : Nat;
    chimeraIndex    : Float;
    metastability   : Float;
    
    // Multi-scale sync
    microSync       : Float;           // Individual agents
    mesoSync        : Float;           // Squadron level
    macroSync       : Float;           // Swarm level
    
    // Performance
    missionProgress : Float;
    threatResponse  : Float;
    adaptability    : Float;
    
    // Parameters
    intraCoupling   : Float;
    interCoupling   : Float;
    chimeraThreshold : Float;
    
    beatNum         : Nat;
  };

  /// Initialize Chimera Swarm Intelligence
  public func initChimeraSwarm(size: Nat, squadrons: Nat) : ChimeraSwarmState {
    var agents : [ChimeraSwarmAgent] = [];
    let agentsPerSquadron = size / squadrons;
    
    for (i in Array.keys(Array.tabulate<Nat>(size, func(x) { x }))) {
      let squadron = i / agentsPerSquadron;
      let posInSquadron = i % agentsPerSquadron;
      
      // Determine role
      let role = if (posInSquadron == 0) { "leader" }
                 else if (posInSquadron < 3) { "scout" }
                 else if (posInSquadron < 6) { "defender" }
                 else { "support" };
      
      // Initial formation: squadrons in separate clusters
      let squadronAngle = Float.fromInt(squadron) * TWO_PI / Float.fromInt(squadrons);
      let squadronRadius = 50.0;
      let localAngle = Float.fromInt(posInSquadron) * TWO_PI / Float.fromInt(agentsPerSquadron);
      let localRadius = 10.0;
      
      let x = squadronRadius * Float.cos(squadronAngle) + localRadius * Float.cos(localAngle);
      let y = squadronRadius * Float.sin(squadronAngle) + localRadius * Float.sin(localAngle);
      let z = Float.fromInt(i % 5) * 2.0;  // Altitude variation
      
      agents := Array.append(agents, [{
        id = i;
        squadron = squadron;
        role = role;
        position = { x = x; y = y; z = z };
        velocity = { vx = 0.0; vy = 0.0; vz = 0.0 };
        heading = localAngle;
        altitude = z;
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(size);
        naturalFreq = 0.1 + Float.fromInt(i % 10) * 0.005;
        amplitude = 1.0;
        coherenceMode = "coherent";
        localR = 0.5;
        localPsi = 0.0;
        perception = 30.0;
        signalStrength = 1.0;
        lastContact = 0;
        targetPosition = { x = 0.0; y = 0.0; z = 10.0 };
        missionState = "patrol";
        threat = 0.0;
      }]);
    };
    
    {
      agents = agents;
      squadrons = squadrons;
      totalSize = size;
      globalR = 0.5;
      globalPsi = 0.0;
      swarmCentroid = { x = 0.0; y = 0.0; z = 5.0 };
      swarmSpread = squadronRadius;
      coherentRegions = squadrons;
      incoherentRegions = 0;
      chimeraIndex = 0.0;
      metastability = 0.0;
      microSync = 0.5;
      mesoSync = 0.7;
      macroSync = 0.3;
      missionProgress = 0.0;
      threatResponse = 0.9;
      adaptability = 0.8;
      intraCoupling = 2.0;
      interCoupling = 0.3;
      chimeraThreshold = 0.6;
      beatNum = 0;
    }
  };

  /// Update Chimera Swarm - core intelligence loop
  public func beatChimeraSwarm(state: ChimeraSwarmState, dt: Float, context: { threat: Float; target: { x: Float; y: Float; z: Float } }) : ChimeraSwarmState {
    let n = state.agents.size();
    var newAgents : [ChimeraSwarmAgent] = [];
    
    // First pass: compute local order parameters for each agent
    for (agent in state.agents.vals()) {
      var localSumCos : Float = 0.0;
      var localSumSin : Float = 0.0;
      var localCount : Nat = 0;
      
      for (other in state.agents.vals()) {
        if (agent.id != other.id) {
          let dx = other.position.x - agent.position.x;
          let dy = other.position.y - agent.position.y;
          let dz = other.position.z - agent.position.z;
          let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
          
          if (dist < agent.perception) {
            localSumCos += Float.cos(other.phase);
            localSumSin += Float.sin(other.phase);
            localCount += 1;
          };
        };
      };
      
      let localR = if (localCount > 0) {
        Float.sqrt(localSumCos*localSumCos + localSumSin*localSumSin) / Float.fromInt(localCount)
      } else { 0.0 };
      let localPsi = Float.arctan2(localSumSin, localSumCos);
      
      // Determine coherence mode
      let mode = if (localR > state.chimeraThreshold) { "coherent" }
                 else if (localR < state.chimeraThreshold - 0.2) { "incoherent" }
                 else { "transitioning" };
      
      // Phase dynamics with chimera-aware coupling
      let effectiveCoupling = switch (mode) {
        case "coherent" { state.intraCoupling };
        case "incoherent" { state.intraCoupling * 0.3 };
        case _ { state.intraCoupling * 0.6 };
      };
      
      var couplingSum : Float = 0.0;
      for (other in state.agents.vals()) {
        if (agent.id != other.id) {
          let dx = other.position.x - agent.position.x;
          let dy = other.position.y - agent.position.y;
          let dist = Float.sqrt(dx*dx + dy*dy);
          
          if (dist < agent.perception) {
            // Stronger coupling within squadron
            let couplingStrength = if (other.squadron == agent.squadron) {
              effectiveCoupling
            } else {
              state.interCoupling
            };
            couplingSum += couplingStrength * Float.sin(other.phase - agent.phase);
          };
        };
      };
      
      let newPhase = wrapPhase(agent.phase + (agent.naturalFreq + couplingSum / Float.fromInt(Nat.max(1, localCount))) * dt);
      
      // Movement dynamics
      // Heading influenced by phase (couples oscillation to movement)
      let phaseInfluence = 0.1 * Float.sin(newPhase);
      var newHeading = agent.heading + phaseInfluence * dt;
      
      // Flocking: separation + alignment + cohesion
      var sepX : Float = 0.0; var sepY : Float = 0.0;
      var alignX : Float = 0.0; var alignY : Float = 0.0;
      var cohX : Float = 0.0; var cohY : Float = 0.0;
      var neighborCount : Nat = 0;
      
      for (other in state.agents.vals()) {
        if (agent.id != other.id) {
          let dx = other.position.x - agent.position.x;
          let dy = other.position.y - agent.position.y;
          let dist = Float.sqrt(dx*dx + dy*dy);
          
          if (dist < agent.perception and dist > 0.1) {
            // Separation (avoid collision)
            if (dist < 5.0) {
              sepX -= dx / dist;
              sepY -= dy / dist;
            };
            
            // Alignment (match heading)
            alignX += Float.cos(other.heading);
            alignY += Float.sin(other.heading);
            
            // Cohesion (move toward centroid)
            cohX += dx;
            cohY += dy;
            
            neighborCount += 1;
          };
        };
      };
      
      if (neighborCount > 0) {
        let nf = Float.fromInt(neighborCount);
        alignX := alignX / nf;
        alignY := alignY / nf;
        cohX := cohX / nf;
        cohY := cohY / nf;
        
        // Target heading from flocking rules
        let sepWeight = 1.5;
        let alignWeight = 1.0;
        let cohWeight = 0.8;
        let targetX = sepWeight * sepX + alignWeight * alignX + cohWeight * cohX / 50.0;
        let targetY = sepWeight * sepY + alignWeight * alignY + cohWeight * cohY / 50.0;
        let targetHeading = Float.arctan2(targetY, targetX);
        
        // Blend toward target heading
        let headingError = targetHeading - newHeading;
        newHeading := newHeading + 0.1 * headingError * dt;
      };
      
      // Add mission target influence
      let toTargetX = context.target.x - agent.position.x;
      let toTargetY = context.target.y - agent.position.y;
      let targetDist = Float.sqrt(toTargetX*toTargetX + toTargetY*toTargetY);
      if (targetDist > 1.0) {
        let missionHeading = Float.arctan2(toTargetY, toTargetX);
        let missionInfluence = 0.05;  // Weak pull toward mission target
        newHeading := newHeading + missionInfluence * Float.sin(missionHeading - newHeading) * dt;
      };
      
      newHeading := wrapPhase(newHeading);
      
      // Update position
      let speed = 1.0 + 0.2 * agent.localR;  // Coherent agents move faster
      let newX = agent.position.x + speed * Float.cos(newHeading) * dt;
      let newY = agent.position.y + speed * Float.sin(newHeading) * dt;
      
      // Update threat level based on context
      let newThreat = _clamp(agent.threat * 0.9 + context.threat * 0.1, 0.0, 1.0);
      
      newAgents := Array.append(newAgents, [{
        id = agent.id;
        squadron = agent.squadron;
        role = agent.role;
        position = { x = newX; y = newY; z = agent.position.z };
        velocity = { vx = speed * Float.cos(newHeading); vy = speed * Float.sin(newHeading); vz = 0.0 };
        heading = newHeading;
        altitude = agent.position.z;
        phase = newPhase;
        naturalFreq = agent.naturalFreq;
        amplitude = agent.amplitude;
        coherenceMode = mode;
        localR = localR;
        localPsi = localPsi;
        perception = agent.perception;
        signalStrength = agent.signalStrength;
        lastContact = state.beatNum;
        targetPosition = context.target;
        missionState = if (context.threat > 0.5) { "defensive" } else { agent.missionState };
        threat = newThreat;
      }]);
    };
    
    // Compute global metrics
    var globalSumCos : Float = 0.0;
    var globalSumSin : Float = 0.0;
    var centX : Float = 0.0; var centY : Float = 0.0; var centZ : Float = 0.0;
    var coherentCount : Nat = 0;
    var incoherentCount : Nat = 0;
    
    for (agent in newAgents.vals()) {
      globalSumCos += Float.cos(agent.phase);
      globalSumSin += Float.sin(agent.phase);
      centX += agent.position.x;
      centY += agent.position.y;
      centZ += agent.position.z;
      
      if (agent.coherenceMode == "coherent") { coherentCount += 1 }
      else if (agent.coherenceMode == "incoherent") { incoherentCount += 1 };
    };
    
    let globalR = Float.sqrt(globalSumCos*globalSumCos + globalSumSin*globalSumSin) / Float.fromInt(n);
    let globalPsi = Float.arctan2(globalSumSin, globalSumCos);
    centX := centX / Float.fromInt(n);
    centY := centY / Float.fromInt(n);
    centZ := centZ / Float.fromInt(n);
    
    // Compute spread
    var spreadSum : Float = 0.0;
    for (agent in newAgents.vals()) {
      let dx = agent.position.x - centX;
      let dy = agent.position.y - centY;
      spreadSum += dx*dx + dy*dy;
    };
    let spread = Float.sqrt(spreadSum / Float.fromInt(n));
    
    // Chimera index: variance of local R values
    var localRSum : Float = 0.0;
    var localRSqSum : Float = 0.0;
    for (agent in newAgents.vals()) {
      localRSum += agent.localR;
      localRSqSum += agent.localR * agent.localR;
    };
    let meanLocalR = localRSum / Float.fromInt(n);
    let varLocalR = localRSqSum / Float.fromInt(n) - meanLocalR * meanLocalR;
    let chimeraIdx = Float.sqrt(Float.abs(varLocalR));
    
    // Multi-scale sync
    // Micro: average local R
    let microSync = meanLocalR;
    
    // Meso: squadron-level sync
    var squadronRSum : Float = 0.0;
    for (sq in Array.keys(Array.tabulate<Nat>(state.squadrons, func(x) { x }))) {
      var sqSumCos : Float = 0.0;
      var sqSumSin : Float = 0.0;
      var sqCount : Nat = 0;
      for (agent in newAgents.vals()) {
        if (agent.squadron == sq) {
          sqSumCos += Float.cos(agent.phase);
          sqSumSin += Float.sin(agent.phase);
          sqCount += 1;
        };
      };
      if (sqCount > 0) {
        let sqR = Float.sqrt(sqSumCos*sqSumCos + sqSumSin*sqSumSin) / Float.fromInt(sqCount);
        squadronRSum += sqR;
      };
    };
    let mesoSync = squadronRSum / Float.fromInt(state.squadrons);
    
    // Macro: global R
    let macroSync = globalR;
    
    // Metastability from R fluctuations
    let meta = Float.abs(globalR - state.globalR) * 10.0;
    
    // Mission progress (distance to target)
    let toTargetX = context.target.x - centX;
    let toTargetY = context.target.y - centY;
    let distToTarget = Float.sqrt(toTargetX*toTargetX + toTargetY*toTargetY);
    let missionProg = 1.0 / (1.0 + distToTarget / 100.0);
    
    {
      agents = newAgents;
      squadrons = state.squadrons;
      totalSize = n;
      globalR = globalR;
      globalPsi = globalPsi;
      swarmCentroid = { x = centX; y = centY; z = centZ };
      swarmSpread = spread;
      coherentRegions = coherentCount;
      incoherentRegions = incoherentCount;
      chimeraIndex = chimeraIdx;
      metastability = _clamp(meta, 0.0, 1.0);
      microSync = microSync;
      mesoSync = mesoSync;
      macroSync = macroSync;
      missionProgress = missionProg;
      threatResponse = if (context.threat > 0.5) { 0.9 } else { state.threatResponse };
      adaptability = (chimeraIdx + mesoSync) / 2.0;  // Balance chimera with coherence
      intraCoupling = state.intraCoupling;
      interCoupling = state.interCoupling;
      chimeraThreshold = state.chimeraThreshold;
      beatNum = state.beatNum + 1;
    }
  };

  /// Get Chimera Swarm output for integration with other systems
  public func getChimeraSwarmOutput(state: ChimeraSwarmState) : {
    // Swarm state
    globalCoherence   : Float;
    swarmPosition     : { x: Float; y: Float; z: Float };
    swarmVelocity     : Float;
    
    // Chimera dynamics
    chimeraIndex      : Float;
    coherentFraction  : Float;
    metastability     : Float;
    
    // Multi-scale
    microSync         : Float;
    mesoSync          : Float;
    macroSync         : Float;
    
    // Performance
    missionStatus     : Float;
    threatLevel       : Float;
    adaptiveCapacity  : Float;
    
    // Squadron status
    activeSquadrons   : Nat;
    formationQuality  : Float;
  } {
    {
      globalCoherence = state.globalR;
      swarmPosition = state.swarmCentroid;
      swarmVelocity = 1.0;  // Would compute from agent velocities
      chimeraIndex = state.chimeraIndex;
      coherentFraction = Float.fromInt(state.coherentRegions) / Float.fromInt(state.totalSize);
      metastability = state.metastability;
      microSync = state.microSync;
      mesoSync = state.mesoSync;
      macroSync = state.macroSync;
      missionStatus = state.missionProgress;
      threatLevel = 0.0;  // Would aggregate from agents
      adaptiveCapacity = state.adaptability;
      activeSquadrons = state.squadrons;
      formationQuality = 1.0 / (1.0 + state.swarmSpread / 50.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 32: DEFENSE INTEGRATION — KURAMOTO FOR SECURITY SYSTEMS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Kuramoto dynamics applied to defense and security
  // Phase coherence indicates system health, synchronization enables rapid response
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Defense Kuramoto state
  public type DefenseKuramotoState = {
    // Sensor nodes as oscillators
    sensorNodes     : [Oscillator];
    nodePositions   : [{ x: Float; y: Float }];
    nodeTypes       : [Text];          // "radar", "lidar", "acoustic", "optical"
    
    // Defense parameters
    alertLevel      : Float;
    responseReady   : Float;
    coverageCoherence : Float;
    
    // Kuramoto metrics
    globalR         : Float;
    globalPsi       : Float;
    sectorSync      : [Float];         // Sync per sector
    
    // Threat tracking
    detectedThreats : Nat;
    trackingQuality : Float;
    falsePositives  : Nat;
    
    beatNum         : Nat;
  };

  /// Initialize defense Kuramoto system
  public func initDefenseKuramoto(numSensors: Nat, sectors: Nat) : DefenseKuramotoState {
    // Place sensors in sectors around perimeter
    var nodes : [Oscillator] = [];
    var positions : [{ x: Float; y: Float }] = [];
    var types : [Text] = [];
    
    let sensorTypes = ["radar", "lidar", "acoustic", "optical"];
    
    for (i in Array.keys(Array.tabulate<Nat>(numSensors, func(x) { x }))) {
      let angle = Float.fromInt(i) * TWO_PI / Float.fromInt(numSensors);
      let radius = 100.0;
      
      nodes := Array.append(nodes, [{
        phase = angle;  // Initial phase aligned with position
        naturalFreq = 0.1 + Float.fromInt(i % 5) * 0.005;
        coupling = 1.0;
        amplitude = 1.0;
      }]);
      
      positions := Array.append(positions, [{
        x = radius * Float.cos(angle);
        y = radius * Float.sin(angle);
      }]);
      
      types := Array.append(types, [sensorTypes[i % 4]]);
    };
    
    let sectorSync = Array.tabulate<Float>(sectors, func(_) { 0.5 });
    
    {
      sensorNodes     = nodes;
      nodePositions   = positions;
      nodeTypes       = types;
      alertLevel      = 0.0;
      responseReady   = 0.9;
      coverageCoherence = 0.5;
      globalR         = 0.5;
      globalPsi       = 0.0;
      sectorSync      = sectorSync;
      detectedThreats = 0;
      trackingQuality = 0.0;
      falsePositives  = 0;
      beatNum         = 0;
    }
  };

  /// Update defense Kuramoto with threat context
  public func beatDefenseKuramoto(state: DefenseKuramotoState, dt: Float, threatVectors: [{ angle: Float; distance: Float; confidence: Float }]) : DefenseKuramotoState {
    let (r, psi) = computeOrderParameter(state.sensorNodes);
    
    // Update sensor oscillators
    // Sensors synchronize more strongly when threats detected
    let threatBoost = if (threatVectors.size() > 0) { 1.5 } else { 1.0 };
    
    let newNodes = Array.map<Oscillator, Oscillator>(state.sensorNodes, func(node) {
      let coupling = node.coupling * 1.5 * threatBoost * r * Float.sin(psi - node.phase);
      let newPhase = wrapPhase(node.phase + (node.naturalFreq + coupling) * dt);
      {
        phase = newPhase;
        naturalFreq = node.naturalFreq;
        coupling = node.coupling;
        amplitude = node.amplitude;
      }
    });
    
    let (newR, newPsi) = computeOrderParameter(newNodes);
    
    // Compute sector-wise synchronization
    let numSectors = state.sectorSync.size();
    var newSectorSync : [Float] = [];
    
    for (s in Array.keys(state.sectorSync)) {
      let sectorStart = Float.fromInt(s) * TWO_PI / Float.fromInt(numSectors);
      let sectorEnd = Float.fromInt(s + 1) * TWO_PI / Float.fromInt(numSectors);
      
      var sectorSumCos : Float = 0.0;
      var sectorSumSin : Float = 0.0;
      var sectorCount : Nat = 0;
      
      for (i in Array.keys(state.nodePositions)) {
        let nodeAngle = Float.arctan2(state.nodePositions[i].y, state.nodePositions[i].x);
        let normalizedAngle = wrapPhase(nodeAngle);
        
        if (normalizedAngle >= sectorStart and normalizedAngle < sectorEnd) {
          sectorSumCos += Float.cos(newNodes[i].phase);
          sectorSumSin += Float.sin(newNodes[i].phase);
          sectorCount += 1;
        };
      };
      
      let sectorR = if (sectorCount > 0) {
        Float.sqrt(sectorSumCos*sectorSumCos + sectorSumSin*sectorSumSin) / Float.fromInt(sectorCount)
      } else { 0.0 };
      
      newSectorSync := Array.append(newSectorSync, [sectorR]);
    };
    
    // Alert level based on threats and coherence
    let alertFromThreats = Float.fromInt(threatVectors.size()) * 0.2;
    let alertFromCoherence = (1.0 - newR) * 0.3;  // Low coherence = concern
    let newAlertLevel = _clamp(alertFromThreats + alertFromCoherence, 0.0, 1.0);
    
    // Response readiness: high R = fast coordinated response
    let newResponseReady = newR;
    
    // Coverage coherence: product of sector syncs
    var coverageProd : Float = 1.0;
    for (sSync in newSectorSync.vals()) {
      coverageProd := coverageProd * sSync;
    };
    let coverageCoh = Float.pow(coverageProd, 1.0 / Float.fromInt(numSectors));
    
    // Tracking quality depends on coherence and number of threats
    let trackQual = if (threatVectors.size() > 0) {
      newR * 0.8 + 0.2 * (1.0 / Float.fromInt(threatVectors.size()))
    } else { 0.0 };
    
    {
      sensorNodes     = newNodes;
      nodePositions   = state.nodePositions;
      nodeTypes       = state.nodeTypes;
      alertLevel      = newAlertLevel;
      responseReady   = newResponseReady;
      coverageCoherence = coverageCoh;
      globalR         = newR;
      globalPsi       = newPsi;
      sectorSync      = newSectorSync;
      detectedThreats = threatVectors.size();
      trackingQuality = trackQual;
      falsePositives  = state.falsePositives;
      beatNum         = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 33: FINAL UTILITY FUNCTIONS — COMPLETE API
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Serialize Kuramoto state for export
  public func serializeKuramotoState(state: KuramotoState) : Text {
    var result = "KuramotoState{";
    result := result # "r=" # Float.toText(state.orderParam);
    result := result # ",psi=" # Float.toText(state.meanPhase);
    result := result # ",K=" # Float.toText(state.globalCoupling);
    result := result # ",n=" # Nat.toText(state.oscillators.size());
    result := result # ",beat=" # Nat.toText(state.beatNum);
    result := result # "}";
    result
  };

  /// Compute energy functional: E = -K/N Σᵢⱼ cos(θⱼ - θᵢ)
  public func computeEnergy(state: KuramotoState) : Float {
    let n = state.oscillators.size();
    if (n < 2) { return 0.0 };
    
    var energy : Float = 0.0;
    for (i in Array.keys(state.oscillators)) {
      for (j in Array.keys(state.oscillators)) {
        if (j > i) {
          let phaseDiff = state.oscillators[i].phase - state.oscillators[j].phase;
          energy -= state.globalCoupling * Float.cos(phaseDiff) / Float.fromInt(n);
        };
      };
    };
    
    energy
  };

  /// Compute Lyapunov exponent estimate from order parameter history
  public func estimateLyapunov(state: KuramotoState) : Float {
    let history = state.syncHistory;
    if (history.size() < 20) { return 0.0 };
    
    // Look for exponential growth/decay in perturbations
    var sumLogRatio : Float = 0.0;
    var count : Nat = 0;
    
    for (i in Array.keys(history)) {
      if (i > 0 and i < history.size()) {
        let prev = history[i - 1];
        let curr = history[i];
        if (prev > 0.01 and curr > 0.01) {
          sumLogRatio += Float.log(curr / prev);
          count += 1;
        };
      };
    };
    
    if (count > 0) { sumLogRatio / Float.fromInt(count) } else { 0.0 }
  };

  /// Compute correlation dimension estimate
  public func estimateCorrelationDim(state: KuramotoState) : Float {
    // Simplified: use variance as proxy
    let variance = syncVariance(state);
    // D ≈ 1 + log(variance) / log(N)
    let n = Float.fromInt(state.oscillators.size());
    if (variance > 1e-10 and n > 1.0) {
      1.0 + Float.log(variance + 0.01) / Float.log(n)
    } else { 1.0 }
  };

  /// Phase portrait: return oscillator phases for visualization
  public func getPhasePortrait(state: KuramotoState) : [{ phase: Float; freq: Float; amp: Float }] {
    Array.map<Oscillator, { phase: Float; freq: Float; amp: Float }>(state.oscillators, func(osc) {
      { phase = osc.phase; freq = osc.naturalFreq; amp = osc.amplitude }
    })
  };

  /// Get frequency histogram
  public func getFrequencyHistogram(state: KuramotoState, bins: Nat) : [Nat] {
    var histogram = Array.tabulate<Nat>(bins, func(_) { 0 });
    
    // Find freq range
    var minFreq : Float = 1e10;
    var maxFreq : Float = 0.0;
    for (osc in state.oscillators.vals()) {
      if (osc.naturalFreq < minFreq) { minFreq := osc.naturalFreq };
      if (osc.naturalFreq > maxFreq) { maxFreq := osc.naturalFreq };
    };
    
    let range = maxFreq - minFreq;
    if (range < 1e-10) { return histogram };
    
    for (osc in state.oscillators.vals()) {
      let binIdx = Int.abs(Float.toInt((osc.naturalFreq - minFreq) / range * Float.fromInt(bins - 1)));
      let clampedIdx = if (binIdx >= bins) { bins - 1 } else { binIdx };
      let histMut = Array.thaw<Nat>(histogram);
      histMut[clampedIdx] := histMut[clampedIdx] + 1;
      histogram := Array.freeze(histMut);
    };
    
    histogram
  };

  /// Get phase histogram
  public func getPhaseHistogram(state: KuramotoState, bins: Nat) : [Nat] {
    var histogram = Array.tabulate<Nat>(bins, func(_) { 0 });
    
    for (osc in state.oscillators.vals()) {
      let binIdx = Int.abs(Float.toInt(osc.phase / TWO_PI * Float.fromInt(bins)));
      let clampedIdx = if (binIdx >= bins) { bins - 1 } else { binIdx };
      let histMut = Array.thaw<Nat>(histogram);
      histMut[clampedIdx] := histMut[clampedIdx] + 1;
      histogram := Array.freeze(histMut);
    };
    
    histogram
  };

  /// Compute instantaneous frequency for each oscillator
  public func getInstantaneousFrequencies(state: KuramotoState) : [Float] {
    let (r, psi) = computeOrderParameter(state.oscillators);
    
    Array.map<Oscillator, Float>(state.oscillators, func(osc) {
      osc.naturalFreq + state.globalCoupling * r * Float.sin(psi - osc.phase)
    })
  };

  /// Check if system is near phase transition
  public func isNearTransition(state: KuramotoState) : Bool {
    let (r, _) = computeOrderParameter(state.oscillators);
    let criticalR = 0.5;  // Near transition
    Float.abs(r - criticalR) < 0.15
  };

  /// Get synchronization summary
  public func getSyncSummary(state: KuramotoState) : {
    orderParameter : Float;
    variance : Float;
    energy : Float;
    nearCritical : Bool;
    lyapunov : Float;
    stability : Text;
  } {
    let variance = syncVariance(state);
    let energy = computeEnergy(state);
    let nearCrit = isNearTransition(state);
    let lyap = estimateLyapunov(state);
    
    let stability = if (lyap < -0.1) { "stable" }
                    else if (lyap > 0.1) { "unstable" }
                    else { "marginal" };
    
    {
      orderParameter = state.orderParam;
      variance = variance;
      energy = energy;
      nearCritical = nearCrit;
      lyapunov = lyap;
      stability = stability;
    }
  };

  /// Export to AEGIS defense system
  public func exportToAEGIS(state: KuramotoState) : {
    coherence : Float;
    stability : Float;
    alertLevel : Float;
    responseCapacity : Float;
  } {
    let summary = getSyncSummary(state);
    {
      coherence = state.orderParam;
      stability = 1.0 - summary.variance;
      alertLevel = if (summary.nearCritical) { 0.7 } else { 0.3 };
      responseCapacity = state.orderParam * (1.0 - summary.variance);
    }
  };

  /// Export to Hebbian learning system
  public func exportToHebbian(state: KuramotoState) : {
    correlationMatrix : [[Float]];
    learningGate : Float;
  } {
    let n = state.oscillators.size();
    let matrix = Array.tabulate<[Float]>(n, func(i) {
      Array.tabulate<Float>(n, func(j) {
        Float.cos(state.oscillators[i].phase - state.oscillators[j].phase)
      })
    });
    
    {
      correlationMatrix = matrix;
      learningGate = state.orderParam;
    }
  };

  /// Export to quantum systems
  public func exportToQuantumSystems(state: KuramotoState) : {
    phaseCoherence : Float;
    entanglementPotential : Float;
    quantumAnalog : Float;
  } {
    let crit = computeCriticality(state);
    {
      phaseCoherence = state.orderParam;
      entanglementPotential = if (crit.isNearCritical) { 0.8 } else { 0.3 };
      quantumAnalog = Float.abs(Float.cos(state.meanPhase));
    }
  };

  /// Complete Kuramoto orchestration output for NOVA integration
  public func orchestrateKuramoto(
    basic: KuramotoState,
    hierarchical: HierarchicalKuramotoState,
    stochastic: StochasticKuramotoState,
    swarm: SwarmKuramotoState,
    chimera: ChimeraSwarmState,
    defense: DefenseKuramotoState
  ) : {
    // Core
    globalCoherence : Float;
    systemStability : Float;
    
    // Multi-scale
    microLevel : Float;
    mesoLevel : Float;
    macroLevel : Float;
    
    // Noise
    noiseRobustness : Float;
    signalQuality : Float;
    
    // Swarm
    swarmCoherence : Float;
    formationQuality : Float;
    
    // Chimera
    chimeraIndex : Float;
    adaptability : Float;
    
    // Defense
    alertLevel : Float;
    responseReady : Float;
    
    // Overall
    systemHealth : Float;
    operationalStatus : Text;
  } {
    // Aggregate metrics
    let globalCoh = (basic.orderParam + hierarchical.totalR + swarm.orderParam + chimera.globalR) / 4.0;
    let stability = 1.0 - syncVariance(basic);
    
    let micro = if (hierarchical.levels.size() > 0) { hierarchical.levels[0].levelR } else { 0.5 };
    let meso = if (hierarchical.levels.size() > 1) { hierarchical.levels[1].levelR } else { 0.5 };
    let macro = if (hierarchical.levels.size() > 2) { hierarchical.levels[2].levelR } else { 0.5 };
    
    let noiseRob = 1.0 - stochastic.orderParamVar;
    let sigQual = stochastic.snr / 100.0;
    
    let health = (globalCoh + stability + noiseRob + defense.responseReady) / 4.0;
    let status = if (health > 0.8) { "optimal" }
                 else if (health > 0.5) { "operational" }
                 else if (health > 0.3) { "degraded" }
                 else { "critical" };
    
    {
      globalCoherence = globalCoh;
      systemStability = stability;
      microLevel = micro;
      mesoLevel = meso;
      macroLevel = macro;
      noiseRobustness = noiseRob;
      signalQuality = sigQual;
      swarmCoherence = swarm.orderParam;
      formationQuality = swarm.formationCoherence;
      chimeraIndex = chimera.chimeraIndex;
      adaptability = chimera.adaptability;
      alertLevel = defense.alertLevel;
      responseReady = defense.responseReady;
      systemHealth = health;
      operationalStatus = status;
    }
  };

}
