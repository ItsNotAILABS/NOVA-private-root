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

}

