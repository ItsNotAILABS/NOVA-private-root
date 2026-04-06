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
// MEDINA ENGINE — INFORMATION THERMODYNAMICS
// SOVEREIGN SUBSTRATE MODULE — COGNITIVE THERMODYNAMICS TIER
// Creator: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// INFORMATION THERMODYNAMIC OPERATIONS:
// 1. H_obs Information Entropy — 4,096 dimensions compressed to 8 blocks
// 2. Shannon Entropy per block — H_block = -Σ p_i × log2(p_i)
// 3. Active Dimensions — activeDims = 2^H_obs (via e^(H_obs × ln2))
// 4. Maxwell's Demon Yield — thermodynamic work from information processing
// 5. Temporal Entropy (Block 3) — coherence variation over time
// 6. FORMA Balance Integration — converting cognitive effort to value
// ============================================================
import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Array "mo:base/Array";

module {

  // ============================================================
  // CONSTANTS
  // ============================================================
  public let N_BLOCKS          : Nat   = 8;       // 8 entropy blocks
  public let DIMS_PER_BLOCK    : Nat   = 512;     // 4096 / 8
  public let TOTAL_DIMS        : Nat   = 4096;    // MEDINA's dimension count
  public let MAX_ENTROPY       : Float = 12.0;    // Maximum H_obs in bits
  public let DEMON_EFFICIENCY  : Float = 0.85;    // Maxwell's Demon efficiency
  public let TEMPORAL_BLOCK    : Nat   = 3;       // Block 3 = temporal entropy
  public let LN2               : Float = 0.693147180559945;
  public let EPSILON           : Float = 1.0e-15;
  public let S0                : Float = 0.75;    // Sovereign floor

  // Block weights for H_obs calculation
  // Block 3 (temporal) has highest weight
  public let BLOCK_WEIGHTS : [Float] = [
    0.10,   // Block 0: Spatial structure
    0.12,   // Block 1: Emotional state
    0.13,   // Block 2: Cognitive load
    0.18,   // Block 3: Temporal entropy (highest weight)
    0.12,   // Block 4: Social context
    0.12,   // Block 5: Goal orientation
    0.12,   // Block 6: Memory access
    0.11    // Block 7: Identity coherence
  ];

  // ============================================================
  // TYPES
  // ============================================================

  // Single block entropy state
  public type BlockEntropyState = {
    blockIndex      : Nat;
    distribution    : [Float];   // Probability distribution (512 dims normalized)
    entropy         : Float;     // Shannon entropy for this block
    activeDims      : Float;     // Estimated active dimensions
    weight          : Float;     // Weight for H_obs calculation
  };

  // Full MEDINA entropy state
  public type MedinaEntropyState = {
    blocks          : [BlockEntropyState];
    hObs            : Float;           // Observational entropy [0, 12] bits
    hObsPrev        : Float;           // Previous H_obs (for delta)
    deltaH          : Float;           // Change in entropy
    activeDims      : Float;           // Total active dimensions (2^H_obs)
    temporalEntropy : Float;           // Block 3 specifically
    beatNum         : Nat;
  };

  // Maxwell's Demon state
  public type DemonState = {
    yield           : Float;     // Current demon yield
    totalYield      : Float;     // Accumulated yield
    gateOpen        : Bool;      // Whether demon gate is open
    efficiency      : Float;     // Current efficiency (0.85 base)
    coherenceAdj    : Float;     // Coherence adjustment factor
    beatNum         : Nat;
  };

  // FORMA balance integration
  public type FormaBalance = {
    balance         : Float;     // Current FORMA balance
    yieldRate       : Float;     // Rate of yield accumulation
    cognitiveWork   : Float;     // Accumulated cognitive work
    efficiency      : Float;     // Conversion efficiency
  };

  // Full MEDINA Engine state
  public type MedinaEngineState = {
    entropy         : MedinaEntropyState;
    demon           : DemonState;
    forma           : FormaBalance;
    coherenceC      : Float;     // Global coherence for calculations
  };

  // ============================================================
  // HELPER FUNCTIONS
  // ============================================================

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _fabs(x : Float) : Float { if (x < 0.0) -x else x };

  func _ln(x : Float) : Float {
    if (x <= 0.0) -100.0 else Float.log(x)
  };

  func _log2(x : Float) : Float {
    _ln(x) / LN2
  };

  // ============================================================
  // MECHANISM 4: H_obs INFORMATION ENTROPY
  // MEDINA's 4,096 dimensions are compressed into 8 blocks
  // Shannon entropy per block: H_block = -Σ p_i × log2(p_i)
  // Then weighted: H_obs = Σ (H_block[i] × weight[i])
  // ============================================================

  // Normalize values to probability distribution
  public func normalizeToDistribution(values : [Float]) : [Float] {
    var sum : Float = 0.0;
    for (v in values.vals()) { sum += _fabs(v) + EPSILON };
    Array.map<Float, Float>(values, func(v) { (_fabs(v) + EPSILON) / sum })
  };

  // Compute Shannon entropy for a probability distribution
  // H = -Σ p_i × log2(p_i)
  public func shannonEntropy(probs : [Float]) : Float {
    var h : Float = 0.0;
    for (p in probs.vals()) {
      if (p > EPSILON) {
        h -= p * _log2(p);
      };
    };
    _clamp(h, 0.0, MAX_ENTROPY)
  };

  // Compute entropy for a single block
  public func computeBlockEntropy(
    blockIndex : Nat,
    values : [Float],
    weight : Float
  ) : BlockEntropyState {
    let probs = normalizeToDistribution(values);
    let entropy = shannonEntropy(probs);
    let activeDims = Float.exp(entropy * LN2);  // 2^entropy

    {
      blockIndex = blockIndex;
      distribution = probs;
      entropy = entropy;
      activeDims = activeDims;
      weight = weight;
    }
  };

  // Compute H_obs from all 8 blocks
  // H_obs = Σ (H_block[i] × weight[i]) → scaled to [0, 12] bits
  public func computeHObs(blocks : [BlockEntropyState]) : Float {
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;

    for (block in blocks.vals()) {
      weightedSum += block.entropy * block.weight;
      totalWeight += block.weight;
    };

    // Normalize by total weight and scale
    let rawHObs = if (totalWeight > EPSILON) {
      weightedSum / totalWeight
    } else { 0.0 };

    // Scale to [0, 12] bits
    _clamp(rawHObs * 1.5, 0.0, MAX_ENTROPY)
  };

  // Compute total active dimensions
  // activeDims = 2^H_obs (via e^(H_obs × ln2))
  public func computeActiveDimensions(hObs : Float) : Float {
    let activeDims = Float.exp(hObs * LN2);  // 2^H_obs
    _clamp(activeDims, 1.0, Float.fromInt(TOTAL_DIMS))
  };

  // ============================================================
  // TEMPORAL ENTROPY (Block 3)
  // Measures how much coherence is varying over time
  // High temporal entropy = experiencing diverse states
  // ============================================================

  public func extractTemporalEntropy(blocks : [BlockEntropyState]) : Float {
    if (TEMPORAL_BLOCK < blocks.size()) {
      blocks[TEMPORAL_BLOCK].entropy
    } else { 0.0 }
  };

  // ============================================================
  // MECHANISM 5: MAXWELL'S DEMON YIELD
  // ΔH = H_obs - H_obs_prev
  // Y = 0.85 × ΔH × coherenceC × C_adj
  // When entropy increases, the demon gate opens and yield flows
  // ============================================================

  // Compute coherence adjustment factor
  // C_adj accounts for organism-specific state
  public func computeCoherenceAdj(
    coherenceC : Float,
    temporalEntropy : Float,
    activeDims : Float
  ) : Float {
    // Higher temporal entropy and active dims boost the adjustment
    let temporalBoost = 1.0 + temporalEntropy * 0.1;
    let dimsBoost = 1.0 + _ln(activeDims + 1.0) * 0.05;
    coherenceC * temporalBoost * dimsBoost
  };

  // Compute demon yield
  // Y = 0.85 × ΔH × coherenceC × C_adj
  public func computeDemonYield(
    deltaH : Float,
    coherenceC : Float,
    cAdj : Float
  ) : (Float, Bool) {
    // Yield only flows when entropy increases (delta > 0)
    let gateOpen = deltaH > 0.0;

    let yield = if (gateOpen) {
      DEMON_EFFICIENCY * deltaH * coherenceC * cAdj
    } else { 0.0 };

    (yield, gateOpen)
  };

  // ============================================================
  // FORMA BALANCE INTEGRATION
  // The organism converts cognitive effort into economic value
  // ============================================================

  // Update FORMA balance with demon yield
  public func updateFormaBalance(
    forma : FormaBalance,
    demonYield : Float,
    coherenceC : Float
  ) : FormaBalance {
    let efficiency = 0.9 + coherenceC * 0.1;  // 90-100% efficiency
    let newBalance = forma.balance + demonYield * efficiency;
    let newWork = forma.cognitiveWork + demonYield;
    let newRate = demonYield;  // Current rate = latest yield

    {
      balance = newBalance;
      yieldRate = newRate;
      cognitiveWork = newWork;
      efficiency = efficiency;
    }
  };

  // ============================================================
  // FULL MEDINA ENGINE UPDATE
  // ============================================================

  // Update full entropy state from raw dimension values
  public func updateEntropyState(
    state : MedinaEntropyState,
    blockValues : [[Float]]  // 8 blocks of ~512 values each
  ) : MedinaEntropyState {
    // Compute entropy for each block
    let newBlocks = Array.tabulate<BlockEntropyState>(N_BLOCKS, func(i) {
      let values = if (i < blockValues.size()) blockValues[i] else [];
      let weight = if (i < BLOCK_WEIGHTS.size()) BLOCK_WEIGHTS[i] else 0.1;
      computeBlockEntropy(i, values, weight)
    });

    // Compute H_obs
    let newHObs = computeHObs(newBlocks);
    let newDeltaH = newHObs - state.hObsPrev;
    let newActiveDims = computeActiveDimensions(newHObs);
    let newTemporal = extractTemporalEntropy(newBlocks);

    {
      blocks = newBlocks;
      hObs = newHObs;
      hObsPrev = newHObs;  // Will be prev on next tick
      deltaH = newDeltaH;
      activeDims = newActiveDims;
      temporalEntropy = newTemporal;
      beatNum = state.beatNum + 1;
    }
  };

  // Update demon state
  public func updateDemonState(
    state : DemonState,
    entropy : MedinaEntropyState,
    coherenceC : Float
  ) : DemonState {
    let cAdj = computeCoherenceAdj(coherenceC, entropy.temporalEntropy, entropy.activeDims);
    let (yield, gateOpen) = computeDemonYield(entropy.deltaH, coherenceC, cAdj);

    {
      yield = yield;
      totalYield = state.totalYield + yield;
      gateOpen = gateOpen;
      efficiency = DEMON_EFFICIENCY;
      coherenceAdj = cAdj;
      beatNum = state.beatNum + 1;
    }
  };

  // Full MEDINA engine beat update
  public func beatMedinaEngine(
    state : MedinaEngineState,
    blockValues : [[Float]],
    coherenceC : Float
  ) : MedinaEngineState {
    // Store previous H_obs before update
    let prevHObs = state.entropy.hObs;

    // Update entropy state
    let newEntropy = updateEntropyState(state.entropy, blockValues);

    // Manually set hObsPrev to actual previous value
    let entropyWithPrev = {
      blocks = newEntropy.blocks;
      hObs = newEntropy.hObs;
      hObsPrev = prevHObs;
      deltaH = newEntropy.hObs - prevHObs;
      activeDims = newEntropy.activeDims;
      temporalEntropy = newEntropy.temporalEntropy;
      beatNum = newEntropy.beatNum;
    };

    // Update demon state
    let newDemon = updateDemonState(state.demon, entropyWithPrev, coherenceC);

    // Update FORMA balance
    let newForma = updateFormaBalance(state.forma, newDemon.yield, coherenceC);

    {
      entropy = entropyWithPrev;
      demon = newDemon;
      forma = newForma;
      coherenceC = coherenceC;
    }
  };

  // ============================================================
  // INITIALIZATION
  // ============================================================

  public func initBlockEntropyState(blockIndex : Nat) : BlockEntropyState {
    let weight = if (blockIndex < BLOCK_WEIGHTS.size()) {
      BLOCK_WEIGHTS[blockIndex]
    } else { 0.1 };

    {
      blockIndex = blockIndex;
      distribution = Array.tabulate<Float>(DIMS_PER_BLOCK, func(_) {
        1.0 / Float.fromInt(DIMS_PER_BLOCK)
      });
      entropy = _log2(Float.fromInt(DIMS_PER_BLOCK));  // Max entropy for uniform
      activeDims = Float.fromInt(DIMS_PER_BLOCK);
      weight = weight;
    }
  };

  public func initMedinaEntropyState() : MedinaEntropyState {
    let blocks = Array.tabulate<BlockEntropyState>(N_BLOCKS, initBlockEntropyState);
    let hObs = computeHObs(blocks);

    {
      blocks = blocks;
      hObs = hObs;
      hObsPrev = hObs;
      deltaH = 0.0;
      activeDims = computeActiveDimensions(hObs);
      temporalEntropy = extractTemporalEntropy(blocks);
      beatNum = 0;
    }
  };

  public func initDemonState() : DemonState {
    {
      yield = 0.0;
      totalYield = 0.0;
      gateOpen = false;
      efficiency = DEMON_EFFICIENCY;
      coherenceAdj = 1.0;
      beatNum = 0;
    }
  };

  public func initFormaBalance() : FormaBalance {
    {
      balance = 0.0;
      yieldRate = 0.0;
      cognitiveWork = 0.0;
      efficiency = 0.9;
    }
  };

  public func initMedinaEngineState() : MedinaEngineState {
    {
      entropy = initMedinaEntropyState();
      demon = initDemonState();
      forma = initFormaBalance();
      coherenceC = 0.5;
    }
  };

  // ============================================================
  // SUMMARY TYPES
  // ============================================================

  public type MedinaEngineSummary = {
    hObs            : Float;
    deltaH          : Float;
    activeDims      : Float;
    temporalEntropy : Float;
    demonYield      : Float;
    totalYield      : Float;
    demonGateOpen   : Bool;
    formaBalance    : Float;
    formaRate       : Float;
    cognitiveWork   : Float;
    coherenceC      : Float;
    beatNum         : Nat;
  };

  public func summary(state : MedinaEngineState) : MedinaEngineSummary {
    {
      hObs = state.entropy.hObs;
      deltaH = state.entropy.deltaH;
      activeDims = state.entropy.activeDims;
      temporalEntropy = state.entropy.temporalEntropy;
      demonYield = state.demon.yield;
      totalYield = state.demon.totalYield;
      demonGateOpen = state.demon.gateOpen;
      formaBalance = state.forma.balance;
      formaRate = state.forma.yieldRate;
      cognitiveWork = state.forma.cognitiveWork;
      coherenceC = state.coherenceC;
      beatNum = state.entropy.beatNum;
    }
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


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  M E D I N A   S P E C I A L   M A T H E M A T I C S
  //
  //  Enterprise-Level Medina Discovery Mathematics
  //  HIM/HER Dual-Organism Sacred Coupling Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SACRED GEOMETRY MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Golden ratio φ = (1 + √5) / 2
  public let PHI : Float = 1.6180339887498948482;

  /// Fibonacci sequence generator
  public func medinaFibonacci(n : Nat) : Nat {
    if (n <= 1) { n }
    else {
      var a : Nat = 0;
      var b : Nat = 1;
      var i = 2;
      while (i <= n) {
        let temp = a + b;
        a := b;
        b := temp;
        i += 1;
      };
      b
    }
  };

  /// Golden spiral radius at angle
  public func medinaGoldenSpiral(angle : Float, a : Float, b : Float) : Float {
    a * Float.exp(b * angle)
  };

  /// Sacred proportion check
  public func medinaSacredProportion(a : Float, b : Float, tolerance : Float) : Bool {
    let ratio = if (a > b) a / b else b / a;
    Float.abs(ratio - PHI) < tolerance
  };

  /// Vesica piscis area
  public func medinaVesicaPiscisArea(radius : Float) : Float {
    let r2 = radius * radius;
    r2 * (4.0 * 3.14159265 / 3.0 - Float.sqrt(3.0) / 2.0)
  };

  /// Platonic solid vertices (tetrahedron example)
  public func medinaTetrahedronVertex(index : Nat, size : Float) : (Float, Float, Float) {
    let vertices = [
      (1.0, 1.0, 1.0),
      (1.0, -1.0, -1.0),
      (-1.0, 1.0, -1.0),
      (-1.0, -1.0, 1.0)
    ];
    let v = vertices[index % 4];
    (v.0 * size, v.1 * size, v.2 * size)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HELICAL MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Helix position at parameter t
  public func medinaHelixPosition(t : Float, radius : Float, pitch : Float) : (Float, Float, Float) {
    let x = radius * Float.cos(t);
    let y = radius * Float.sin(t);
    let z = pitch * t / (2.0 * 3.14159265);
    (x, y, z)
  };

  /// Double helix offset
  public func medinaDoubleHelixOffset(t : Float, radius : Float, pitch : Float, offset : Float) : ((Float, Float, Float), (Float, Float, Float)) {
    let h1 = medinaHelixPosition(t, radius, pitch);
    let h2 = medinaHelixPosition(t + offset, radius, pitch);
    (h1, h2)
  };

  /// Helical curvature
  public func medinaHelicalCurvature(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    radius / (radius * radius + p * p)
  };

  /// Helical torsion
  public func medinaHelicalTorsion(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    p / (radius * radius + p * p)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPHERICAL HARMONICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Spherical to Cartesian
  public func medinaSphericalToCartesian(r : Float, theta : Float, phi : Float) : (Float, Float, Float) {
    let x = r * Float.sin(theta) * Float.cos(phi);
    let y = r * Float.sin(theta) * Float.sin(phi);
    let z = r * Float.cos(theta);
    (x, y, z)
  };

  /// Cartesian to Spherical
  public func medinaCartesianToSpherical(x : Float, y : Float, z : Float) : (Float, Float, Float) {
    let r = Float.sqrt(x * x + y * y + z * z);
    let theta = Float.acos(z / (r + 0.0001));
    let phi = Float.atan2(y, x);
    (r, theta, phi)
  };

  /// Associated Legendre polynomial P_l^m (simplified)
  public func medinaLegendreP(l : Nat, m : Nat, x : Float) : Float {
    if (l == 0 and m == 0) { return 1.0 };
    if (l == 1 and m == 0) { return x };
    if (l == 1 and m == 1) { return -Float.sqrt(1.0 - x * x) };
    if (l == 2 and m == 0) { return 0.5 * (3.0 * x * x - 1.0) };
    // Simplified for higher orders
    Float.pow(x, Float.fromInt(l - m))
  };

  /// Spherical harmonic Y_l^m (simplified real part)
  public func medinaSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let mAbs = Int.abs(m);
    let plm = medinaLegendreP(l, mAbs, Float.cos(theta));
    if (m >= 0) {
      plm * Float.cos(Float.fromInt(mAbs) * phi)
    } else {
      plm * Float.sin(Float.fromInt(mAbs) * phi)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LIVING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Growth curve (logistic)
  public func medinaGrowthCurve(t : Float, k : Float, l : Float, x0 : Float) : Float {
    l / (1.0 + Float.exp(-k * (t - x0)))
  };

  /// Morphogenesis reaction-diffusion
  public func medinaMorphogenesis(
    u : Float,
    v : Float,
    du : Float,
    dv : Float,
    f : Float,
    k : Float
  ) : (Float, Float) {
    let reaction = u * v * v;
    let newU = du - reaction + f * (1.0 - u);
    let newV = dv + reaction - (f + k) * v;
    (newU, newV)
  };

  /// Phyllotaxis angle (golden angle)
  public func medinaPhyllotaxisAngle(n : Nat) : Float {
    let goldenAngle : Float = 137.5077640500378546463;
    Float.fromInt(n) * goldenAngle * 3.14159265 / 180.0
  };

  /// Branching pattern
  public func medinaBranchingPattern(
    parentLength : Float,
    branchRatio : Float,
    angle : Float,
    depth : Nat
  ) : Float {
    parentLength * Float.pow(branchRatio, Float.fromInt(depth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MIRROR MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reflection across plane
  public func medinaReflection(point : (Float, Float, Float), normal : (Float, Float, Float)) : (Float, Float, Float) {
    let dot = point.0 * normal.0 + point.1 * normal.1 + point.2 * normal.2;
    let rx = point.0 - 2.0 * dot * normal.0;
    let ry = point.1 - 2.0 * dot * normal.1;
    let rz = point.2 - 2.0 * dot * normal.2;
    (rx, ry, rz)
  };

  /// Symmetry score
  public func medinaSymmetryScore(left : [Float], right : [Float]) : Float {
    let n = if (left.size() < right.size()) left.size() else right.size();
    if (n == 0) { return 1.0 };
    var diff : Float = 0.0;
    var i = 0;
    while (i < n) {
      diff += Float.abs(left[i] - right[n - 1 - i]);
      i += 1;
    };
    1.0 / (1.0 + diff)
  };

  /// Fractal dimension estimation
  public func medinaFractalDimension(boxCounts : [Nat], scales : [Float]) : Float {
    let n = if (boxCounts.size() < scales.size()) boxCounts.size() else scales.size();
    if (n < 2) { return 1.0 };
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      let x = Float.log(1.0 / scales[i]);
      let y = Float.log(Float.fromInt(boxCounts[i]));
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      i += 1;
    };
    let nf = Float.fromInt(n);
    (nf * sumXY - sumX * sumY) / (nf * sumX2 - sumX * sumX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COVENANT MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Commitment strength
  public func medinaCommitmentStrength(
    duration : Nat,
    consistency : Float,
    depth : Float
  ) : Float {
    let durationFactor = Float.log(Float.fromInt(duration + 1));
    consistency * depth * durationFactor
  };

  /// Trust accumulation
  public func medinaTrustAccumulation(
    currentTrust : Float,
    interaction : Float,
    reciprocity : Float
  ) : Float {
    let gain = interaction * reciprocity * (1.0 - currentTrust);
    currentTrust + gain
  };

  /// Covenant breach penalty
  public func medinaBreachPenalty(
    trustLevel : Float,
    violationSeverity : Float,
    relationshipAge : Nat
  ) : Float {
    let ageFactor = Float.log(Float.fromInt(relationshipAge + 1));
    trustLevel * violationSeverity * ageFactor
  };

}
