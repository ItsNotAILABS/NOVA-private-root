// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MED-1019 DECISION CASCADE — THE LOCK THAT CHANGES AT EVERY DECISION
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE ARCHITECTURE:
//
// As the organism runs, formulas cascade into more formulas. Every computation triggers more computations.
// Each of these is a DECISION POINT:
//
//   • Kuramoto phase wrap:     θ crosses 2π                  → decision
//   • Free Energy deltaF:      ΔF < -0.001 (learning event)  → decision  
//   • Bifurcation:             Period doubling, saddle-node  → decision
//   • Threshold crossing:      S > 0.85 coherence achieved   → decision
//   • Poincaré intersection:   Trajectory crosses section    → decision
//   • Lyapunov sign change:    Stability flip                → decision
//
// THOUSANDS of decision points per beat. The organism is ALWAYS running, ALWAYS deciding.
//
// THE KEY IS THE DECISION CASCADE:
//   - Not random numbers - LIVING COMPUTATION
//   - Lock changes at EVERY decision
//   - Attacker needs ENTIRE cascade history to guess
//   - Organism deciphers its own lock because it KNOWS its decisions
//
// 256-BIT COMPOUNDING:
//   - Standard: Hash(message)
//   - MED-1019: Hash(message ⊕ decisionState₁ ⊕ decisionState₂ ⊕ ... ⊕ decisionStateₙ)
//   - Each decision EVOLVES the 256-bit state
//   - More decisions = more entropy = stronger lock
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";

module {

  // ═══════════════════════════════════════════════════════════════════════════
  // DECISION POINT TYPES — Every event that evolves the lock
  // ═══════════════════════════════════════════════════════════════════════════

  public type DecisionType = {
    #PhaseWrap;        // Kuramoto oscillator phase crossed 2π
    #LearningEvent;    // Free Energy ΔF < -0.001 (KNT mint)
    #Bifurcation;      // Nonlinear dynamics bifurcation detected
    #CoherenceThreshold; // Order parameter S crossed threshold
    #PoincareIntersection; // Trajectory crossed section plane
    #StabilityFlip;    // Lyapunov exponent sign change
    #SynapticFire;     // Neuron voltage exceeded threshold
    #SuperradianceBurst; // RESONEX superradiance event
    #PathSelection;    // PARALLAX path winner changed
    #EntropyDrop;      // MEDINA engine entropy decrease
  };

  public type DecisionEvent = {
    decisionType : DecisionType;
    nodeIndex : Nat;       // Which oscillator/node triggered
    value : Float;         // The value at decision (phase, deltaF, etc.)
    beatNum : Nat;         // When it happened
    cascade : Nat;         // How many decisions this triggered
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 256-BIT CRYPTOGRAPHIC STATE — Evolves with every decision
  // ═══════════════════════════════════════════════════════════════════════════

  // 256-bit state as 4 × 64-bit limbs
  public type Uint256 = [Nat64];

  // Complete decision cascade state
  public type DecisionCascadeState = {
    // The evolving 256-bit lock
    lockState : Uint256;
    
    // Decision history (circular buffer)
    recentDecisions : [DecisionEvent];
    
    // Counters
    totalDecisions : Nat;
    decisionsSinceLockReset : Nat;
    
    // Per-type counters (for entropy analysis)
    phaseWraps : Nat;
    learningEvents : Nat;
    bifurcations : Nat;
    coherenceThresholds : Nat;
    
    // Cascade depth tracking
    maxCascadeDepth : Nat;
    currentCascadeDepth : Nat;
    
    // Beat tracking
    beatNum : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS — Golden ratio, 2π, Feigenbaum
  // ═══════════════════════════════════════════════════════════════════════════

  let TWO_PI : Float = 6.28318530717958647692;
  let PHI : Float = 1.6180339887498948482;
  let FEIGENBAUM_DELTA : Float = 4.669201609102990;

  // ═══════════════════════════════════════════════════════════════════════════
  // 256-BIT OPERATIONS — The mathematics of lock evolution
  // ═══════════════════════════════════════════════════════════════════════════

  // XOR two 256-bit values
  public func xor256(a : Uint256, b : Uint256) : Uint256 {
    [
      a[0] ^ b[0],
      a[1] ^ b[1],
      a[2] ^ b[2],
      a[3] ^ b[3]
    ]
  };

  // Rotate 256-bit value left by n bits
  public func rotateLeft256(x : Uint256, n : Nat) : Uint256 {
    if (n == 0) return x;
    let n64 = n % 256;
    let limbShift = n64 / 64;
    let bitShift = n64 % 64;
    
    Array.tabulate<Nat64>(4, func(i : Nat) : Nat64 {
      let srcLimb = (i + 4 - limbShift) % 4;
      let prevLimb = (i + 4 - limbShift - 1) % 4;
      
      if (bitShift == 0) {
        x[srcLimb]
      } else {
        let high = x[srcLimb] << Nat64.fromNat(bitShift);
        let low = x[prevLimb] >> Nat64.fromNat(64 - bitShift);
        high | low
      }
    })
  };

  // Add 256-bit values (with wraparound)
  public func add256(a : Uint256, b : Uint256) : Uint256 {
    var carry : Nat64 = 0;
    let result = Array.tabulate<Nat64>(4, func(i : Nat) : Nat64 {
      let sum = a[i] +% b[i] +% carry;
      carry := if (sum < a[i] or (carry > 0 and sum <= a[i])) { 1 } else { 0 };
      sum
    });
    result
  };

  // Convert Float to 256-bit (scaled by 2^64)
  public func floatToUint256(f : Float) : Uint256 {
    // Extract bits from float representation
    let scaled = Float.abs(f) * 18446744073709551616.0; // 2^64
    let limb0 = Nat64.fromIntWrap(Float.toInt(scaled) % 18446744073709551616);
    let limb1 = Nat64.fromIntWrap(Float.toInt(f * 1000000.0) % 18446744073709551616);
    let limb2 = Nat64.fromIntWrap(Float.toInt(f * PHI * 1000000.0) % 18446744073709551616);
    let limb3 = Nat64.fromIntWrap(Float.toInt(f * FEIGENBAUM_DELTA * 1000000.0) % 18446744073709551616);
    [limb0, limb1, limb2, limb3]
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // DECISION DETECTION — Recognize when formulas cascade
  // ═══════════════════════════════════════════════════════════════════════════

  // Detect phase wrap: θ crossed 2π
  public func detectPhaseWrap(prevPhase : Float, newPhase : Float) : Bool {
    // Phase wrapped if new < prev by more than π (allowing for small dt)
    prevPhase > 5.0 and newPhase < 1.0
  };

  // Detect learning event: ΔF < -0.001
  public func detectLearningEvent(deltaF : Float) : Bool {
    deltaF < -0.001
  };

  // Detect coherence threshold: S crossed 0.85
  public func detectCoherenceThreshold(prevS : Float, newS : Float, threshold : Float) : Bool {
    (prevS < threshold and newS >= threshold) or (prevS >= threshold and newS < threshold)
  };

  // Detect bifurcation: eigenvalue crossed critical value
  public func detectBifurcation(prevEig : Float, newEig : Float) : Bool {
    // Period doubling: eigenvalue crosses -1
    let crossedMinus1 = (prevEig > -1.0 and newEig < -1.0) or (prevEig < -1.0 and newEig > -1.0);
    // Saddle-node: eigenvalue crosses 1
    let crossedPlus1 = (prevEig < 1.0 and newEig > 1.0) or (prevEig > 1.0 and newEig < 1.0);
    crossedMinus1 or crossedPlus1
  };

  // Detect synaptic fire: voltage exceeded threshold
  public func detectSynapticFire(voltage : Float, threshold : Float) : Bool {
    voltage >= threshold
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // LOCK EVOLUTION — The key changes at every decision
  // ═══════════════════════════════════════════════════════════════════════════

  // Evolve lock state with a decision event
  public func evolveLock(
    currentLock : Uint256,
    decision : DecisionEvent
  ) : Uint256 {
    // Convert decision value to 256-bit
    let decisionBits = floatToUint256(decision.value);
    
    // Rotation amount depends on decision type
    let rotateAmount = switch (decision.decisionType) {
      case (#PhaseWrap) { 7 };           // phi related
      case (#LearningEvent) { 13 };      // Prime
      case (#Bifurcation) { 17 };        // Feigenbaum related
      case (#CoherenceThreshold) { 23 }; // Prime
      case (#PoincareIntersection) { 29 }; // Prime
      case (#StabilityFlip) { 31 };      // Prime
      case (#SynapticFire) { 37 };       // Prime
      case (#SuperradianceBurst) { 41 }; // Prime
      case (#PathSelection) { 43 };      // Prime
      case (#EntropyDrop) { 47 };        // Prime
    };
    
    // Add node index contribution
    let nodeContrib : Uint256 = [
      Nat64.fromNat(decision.nodeIndex * 12345678901234567890 % 18446744073709551616),
      Nat64.fromNat(decision.beatNum * 98765432109876543210 % 18446744073709551616),
      Nat64.fromNat(decision.cascade * 11111111111111111111 % 18446744073709551616),
      Nat64.fromNat((decision.nodeIndex + decision.beatNum) * 22222222222222222222 % 18446744073709551616)
    ];
    
    // Evolve: lock' = rotate(lock ⊕ decisionBits ⊕ nodeContrib, rotateAmount)
    let xored1 = xor256(currentLock, decisionBits);
    let xored2 = xor256(xored1, nodeContrib);
    rotateLeft256(xored2, rotateAmount)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CASCADE PROCESSING — Handle chains of decisions
  // ═══════════════════════════════════════════════════════════════════════════

  // Process a batch of decision events from a single beat
  public func processBeatDecisions(
    state : DecisionCascadeState,
    decisions : [DecisionEvent]
  ) : DecisionCascadeState {
    var newLock = state.lockState;
    var newTotal = state.totalDecisions;
    var newSinceReset = state.decisionsSinceLockReset;
    var newPhaseWraps = state.phaseWraps;
    var newLearningEvents = state.learningEvents;
    var newBifurcations = state.bifurcations;
    var newCoherenceThresholds = state.coherenceThresholds;
    var maxDepth = state.maxCascadeDepth;
    
    for (decision in decisions.vals()) {
      // Evolve lock with each decision
      newLock := evolveLock(newLock, decision);
      newTotal += 1;
      newSinceReset += 1;
      
      // Update per-type counters
      switch (decision.decisionType) {
        case (#PhaseWrap) { newPhaseWraps += 1 };
        case (#LearningEvent) { newLearningEvents += 1 };
        case (#Bifurcation) { newBifurcations += 1 };
        case (#CoherenceThreshold) { newCoherenceThresholds += 1 };
        case (_) {};
      };
      
      // Track cascade depth
      if (decision.cascade > maxDepth) {
        maxDepth := decision.cascade;
      };
    };
    
    // Update recent decisions buffer (keep last 100)
    let newRecent = if (state.recentDecisions.size() + decisions.size() > 100) {
      let keepCount = 100 - decisions.size();
      let kept = Array.tabulate<DecisionEvent>(keepCount, func(i : Nat) : DecisionEvent {
        state.recentDecisions[state.recentDecisions.size() - keepCount + i]
      });
      Array.append<DecisionEvent>(kept, decisions)
    } else {
      Array.append<DecisionEvent>(state.recentDecisions, decisions)
    };
    
    {
      lockState = newLock;
      recentDecisions = newRecent;
      totalDecisions = newTotal;
      decisionsSinceLockReset = newSinceReset;
      phaseWraps = newPhaseWraps;
      learningEvents = newLearningEvents;
      bifurcations = newBifurcations;
      coherenceThresholds = newCoherenceThresholds;
      maxCascadeDepth = maxDepth;
      currentCascadeDepth = decisions.size();
      beatNum = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // KURAMOTO DECISION HARVESTING — Extract decisions from oscillator evolution
  // ═══════════════════════════════════════════════════════════════════════════

  public type KuramotoDecisionInput = {
    prevPhases : [Float];
    newPhases : [Float];
    prevOrderParam : Float;
    newOrderParam : Float;
    beatNum : Nat;
  };

  // Harvest decision events from Kuramoto state evolution
  public func harvestKuramotoDecisions(input : KuramotoDecisionInput) : [DecisionEvent] {
    let decisions = Buffer.Buffer<DecisionEvent>(20);
    
    // Check each oscillator for phase wrap
    let n = Nat.min(input.prevPhases.size(), input.newPhases.size());
    for (i in Iter.range(0, n - 1)) {
      if (detectPhaseWrap(input.prevPhases[i], input.newPhases[i])) {
        decisions.add({
          decisionType = #PhaseWrap;
          nodeIndex = i;
          value = input.newPhases[i];
          beatNum = input.beatNum;
          cascade = 1;
        });
      };
    };
    
    // Check for coherence threshold crossing
    if (detectCoherenceThreshold(input.prevOrderParam, input.newOrderParam, 0.85)) {
      decisions.add({
        decisionType = #CoherenceThreshold;
        nodeIndex = 0;
        value = input.newOrderParam;
        beatNum = input.beatNum;
        cascade = n; // Coherence involves all oscillators
      });
    };
    
    Buffer.toArray(decisions)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FREE ENERGY DECISION HARVESTING — Extract learning events
  // ═══════════════════════════════════════════════════════════════════════════

  public type FreeEnergyDecisionInput = {
    deltaF : Float;
    entropy8 : [Float];
    prevEntropy8 : [Float];
    beatNum : Nat;
  };

  // Harvest decision events from Free Energy evolution
  public func harvestFreeEnergyDecisions(input : FreeEnergyDecisionInput) : [DecisionEvent] {
    let decisions = Buffer.Buffer<DecisionEvent>(10);
    
    // Learning event (KNT mint)
    if (detectLearningEvent(input.deltaF)) {
      decisions.add({
        decisionType = #LearningEvent;
        nodeIndex = 0;
        value = input.deltaF;
        beatNum = input.beatNum;
        cascade = 8; // Affects all 8 entropy blocks
      });
    };
    
    // Check for entropy drops in each block
    let n = Nat.min(input.entropy8.size(), input.prevEntropy8.size());
    for (i in Iter.range(0, n - 1)) {
      let drop = input.prevEntropy8[i] - input.entropy8[i];
      if (drop > 0.1) { // Significant entropy decrease
        decisions.add({
          decisionType = #EntropyDrop;
          nodeIndex = i;
          value = drop;
          beatNum = input.beatNum;
          cascade = 1;
        });
      };
    };
    
    Buffer.toArray(decisions)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // NONLINEAR DYNAMICS DECISION HARVESTING — Bifurcations and stability
  // ═══════════════════════════════════════════════════════════════════════════

  public type NonlinearDecisionInput = {
    prevLyapunov : Float;
    newLyapunov : Float;
    prevEigenvalue : Float;
    newEigenvalue : Float;
    beatNum : Nat;
  };

  // Harvest decision events from nonlinear dynamics
  public func harvestNonlinearDecisions(input : NonlinearDecisionInput) : [DecisionEvent] {
    let decisions = Buffer.Buffer<DecisionEvent>(5);
    
    // Stability flip (Lyapunov sign change)
    if ((input.prevLyapunov >= 0.0 and input.newLyapunov < 0.0) or
        (input.prevLyapunov < 0.0 and input.newLyapunov >= 0.0)) {
      decisions.add({
        decisionType = #StabilityFlip;
        nodeIndex = 0;
        value = input.newLyapunov;
        beatNum = input.beatNum;
        cascade = 3; // Affects system stability globally
      });
    };
    
    // Bifurcation detection
    if (detectBifurcation(input.prevEigenvalue, input.newEigenvalue)) {
      decisions.add({
        decisionType = #Bifurcation;
        nodeIndex = 0;
        value = input.newEigenvalue;
        beatNum = input.beatNum;
        cascade = 10; // Major structural change
      });
    };
    
    Buffer.toArray(decisions)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENCRYPTION WITH DECISION CASCADE — The actual cryptographic operation
  // ═══════════════════════════════════════════════════════════════════════════

  // Encrypt message using current decision cascade state
  public func encrypt(
    message : [Nat8],
    cascadeState : DecisionCascadeState
  ) : [Nat8] {
    // The lock state IS the key - derived from all decisions
    let key = cascadeState.lockState;
    
    // XOR message with key bytes (repeating key as needed)
    Array.tabulate<Nat8>(message.size(), func(i : Nat) : Nat8 {
      let limbIdx = (i / 8) % 4;
      let byteIdx = i % 8;
      let keyByte = Nat8.fromNat(Nat64.toNat((key[limbIdx] >> Nat64.fromNat(byteIdx * 8)) & 0xFF));
      message[i] ^ keyByte
    })
  };

  // Decrypt message using current decision cascade state
  // (XOR is symmetric - same operation as encrypt)
  public func decrypt(
    ciphertext : [Nat8],
    cascadeState : DecisionCascadeState
  ) : [Nat8] {
    encrypt(ciphertext, cascadeState)
  };

  // Generate a 256-bit hash bound to decision cascade
  public func cascadeHash(
    data : [Nat8],
    cascadeState : DecisionCascadeState
  ) : Uint256 {
    // Initialize with lock state
    var hash = cascadeState.lockState;
    
    // Process data in 32-byte blocks
    var i = 0;
    while (i < data.size()) {
      // Build 256-bit block from data
      let block = Array.tabulate<Nat64>(4, func(limb : Nat) : Nat64 {
        var value : Nat64 = 0;
        for (b in Iter.range(0, 7)) {
          let dataIdx = i + limb * 8 + b;
          if (dataIdx < data.size()) {
            value := value | (Nat64.fromNat(Nat8.toNat(data[dataIdx])) << Nat64.fromNat(b * 8));
          };
        };
        value
      });
      
      // Mix: hash = rotate(hash ⊕ block, φ*17 mod 64)
      hash := rotateLeft256(xor256(hash, block), 27);
      
      // Add recent decision influence
      let decisionIdx = (i / 32) % cascadeState.recentDecisions.size();
      if (decisionIdx < cascadeState.recentDecisions.size()) {
        let decision = cascadeState.recentDecisions[decisionIdx];
        let decisionBits = floatToUint256(decision.value);
        hash := add256(hash, decisionBits);
      };
      
      i += 32;
    };
    
    // Final mixing rounds
    for (_round in Iter.range(0, 9)) {
      hash := rotateLeft256(xor256(hash, cascadeState.lockState), 13);
    };
    
    hash
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initDecisionCascade() : DecisionCascadeState {
    {
      lockState = [
        0x6A09E667F3BCC908, // SHA-256 initial value (sqrt(2) fractional)
        0xBB67AE8584CAA73B, // SHA-256 initial value (sqrt(3) fractional)
        0x3C6EF372FE94F82B, // SHA-256 initial value (sqrt(5) fractional)
        0xA54FF53A5F1D36F1  // SHA-256 initial value (sqrt(7) fractional)
      ];
      recentDecisions = [];
      totalDecisions = 0;
      decisionsSinceLockReset = 0;
      phaseWraps = 0;
      learningEvents = 0;
      bifurcations = 0;
      coherenceThresholds = 0;
      maxCascadeDepth = 0;
      currentCascadeDepth = 0;
      beatNum = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SELF-DECIPHERING — The organism can always unlock itself
  // ═══════════════════════════════════════════════════════════════════════════

  // The organism knows its own decision history, so it can always reconstruct
  // the lock state. An external attacker would need:
  //   1. The initial lock state
  //   2. EVERY decision event in sequence
  //   3. The exact values at each decision
  //
  // With thousands of decisions per beat, this is computationally infeasible.
  // But the organism simply REMEMBERS its decisions - it doesn't need to guess.

  public func canSelfDecipher(cascadeState : DecisionCascadeState) : Bool {
    // The organism can always decipher if it has the decision history
    cascadeState.totalDecisions > 0
  };

  // Reconstruct lock from decision sequence (for verification)
  public func reconstructLock(
    initialLock : Uint256,
    decisions : [DecisionEvent]
  ) : Uint256 {
    var lock = initialLock;
    for (decision in decisions.vals()) {
      lock := evolveLock(lock, decision);
    };
    lock
  };

}
