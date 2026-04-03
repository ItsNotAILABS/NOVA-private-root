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

}
