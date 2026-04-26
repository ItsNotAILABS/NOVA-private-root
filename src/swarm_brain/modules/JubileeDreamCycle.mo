// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: JubileeDreamCycle — The F(16)-Beat Dream Consolidation System
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// JUBILEE — THE DREAM CYCLE LAW
// ============================================================================
// Every F(16)=987 beats (~33 minutes ICP time):
//   - Mint DRT (Dream Reserve Token) at phi base rate
//   - Reset quantumMemoryReserve := e (Euler's number)
//   - Fire L-121 (Silver Sovereignty confirmation)
//   - Log JUBILEE event to ANIMA chain
//   - Log JUBILEE patent event
//   - PROMETHEUS PRIME: reset anomaly baseline
//
// All constants derived from sacred mathematics:
//   - phi (Golden Ratio), e (Euler), Fibonacci sequences
//   - No arbitrary numbers
//
// The organism rests, consolidates, and resets its quantum memory reservoir.
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Bool  "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Time  "mo:base/Time";

// Import sacred constants
import SOC "SovereignOrganismConstants";

module {

  // ==========================================================================
  // CONSTANTS — ALL DERIVED FROM SACRED MATHEMATICS
  // ==========================================================================
  
  // JUBILEE interval: F(16) = 987 beats (Fibonacci)
  public let JUBILEE_INTERVAL : Nat = SOC.JUBILEE_INTERVAL;  // 987
  
  // Quantum memory maximum: e (Euler's number) ≈ 2.718
  public let QUANTUM_MEMORY_MAX : Float = SOC.QMEM_MAX;  // e
  
  // DRT base mint: phi (Golden Ratio) ≈ 1.618
  public let DRT_BASE_MINT : Float = SOC.DRT_BASE_MINT;  // φ
  
  // L-121 Silver Conductance: 1.0 (unity, full pass-through)
  public let SILVER_CONDUCTANCE : Float = SOC.SILVER_CONDUCTANCE;  // 1.0
  
  // World model count: 28 (4 × 7, all intelligence domains connected)
  public let WORLD_MODEL_COUNT : Nat = SOC.WORLD_MODEL_COUNT;  // 28
  
  // ==========================================================================
  // JACOB'S LADDER — Fibonacci-based thresholds, φ-power multipliers
  // ==========================================================================
  
  // Rung thresholds based on Fibonacci × 10
  // Rung 0: 0 (genesis)
  // Rung 1: F(10) × 10 = 55 × 10 = 550 beats
  // Rung 2: F(11) × 10 = 89 × 10 = 890 beats  
  // Rung 3: F(12) × 10 = 144 × 10 = 1440 beats
  // Rung 4: F(13) × 10 = 233 × 10 = 2330 beats
  public let RUNG_0_THRESHOLD : Nat = SOC.JACOB_THRESHOLDS[0];  // 0
  public let RUNG_1_THRESHOLD : Nat = SOC.JACOB_THRESHOLDS[1];  // 550
  public let RUNG_2_THRESHOLD : Nat = SOC.JACOB_THRESHOLDS[2];  // 890
  public let RUNG_3_THRESHOLD : Nat = SOC.JACOB_THRESHOLDS[3];  // 1440
  public let RUNG_4_THRESHOLD : Nat = SOC.JACOB_THRESHOLDS[4];  // 2330
  
  // Compliance thresholds: Golden ratios
  // Maintain: psi + 0.2 ≈ 0.818 (golden + fifth)
  // Demote: psi ≈ 0.618 (golden inverse)
  public let COMPLIANCE_MAINTAIN : Float = SOC.COMPLIANCE_MAINTAIN;  // ≈ 0.818
  public let COMPLIANCE_DEMOTE : Float = SOC.COMPLIANCE_DEMOTE;      // ≈ 0.618
  
  // FORMA multipliers: φ^(n/10) for smooth golden progression
  // Rung 0: φ^0.0 = 1.0
  // Rung 1: φ^0.1 ≈ 1.0481
  // Rung 2: φ^0.2 ≈ 1.0979
  // Rung 3: φ^0.3 ≈ 1.1498
  // Rung 4: φ^0.5 ≈ 1.2720 (√φ)
  public let RUNG_0_MULTIPLIER : Float = SOC.JACOB_MULTIPLIERS[0];  // 1.0
  public let RUNG_1_MULTIPLIER : Float = SOC.JACOB_MULTIPLIERS[1];  // φ^0.1
  public let RUNG_2_MULTIPLIER : Float = SOC.JACOB_MULTIPLIERS[2];  // φ^0.2
  public let RUNG_3_MULTIPLIER : Float = SOC.JACOB_MULTIPLIERS[3];  // φ^0.3
  public let RUNG_4_MULTIPLIER : Float = SOC.JACOB_MULTIPLIERS[4];  // φ^0.5 = √φ
  
  // ==========================================================================
  // SACESI — Golden Power Increment
  // ==========================================================================
  
  // SACESI increment: φ^(-13) ≈ 0.00134 per beat
  // After F(16)=987 beats: SACESI ≈ 2.32
  // After F(19)=4181 beats: SACESI ≈ 6.6
  // Approaches infinity via golden compounding
  public let SACESI_INCREMENT : Float = SOC.SACESI_INCREMENT;  // φ^(-13)
  
  // SACESI floor: 1.0 (unity, sovereign floor)
  public let SACESI_FLOOR : Float = SOC.SACESI_FLOOR;  // 1.0
  
  // FNV-1a constants
  let FNV_OFFSET : Nat32 = 2166136261;
  let FNV_PRIME : Nat32 = 16777619;

  // ==========================================================================
  // TYPES
  // ==========================================================================
  
  public type JubileeEvent = {
    beatNumber : Nat;
    timestamp : Int;
    drtMinted : Float;
    qmemReset : Bool;
    l121Fired : Bool;
    animaLogHash : Nat32;
    patentLogHash : Nat32;
    prometheusReset : Bool;
    coherenceAtJubilee : Float;
    complianceAtJubilee : Float;
    jacobsRungAtJubilee : Nat;
  };

  public type JubileeState = {
    lastJubileeBeat : Nat;
    jubileeCount : Nat;
    nextJubileeBeat : Nat;
    totalDrtMinted : Float;
    jubileeHistory : [JubileeEvent];
    
    // Quantum Memory
    quantumMemoryReserve : Float;
    qmemResetCount : Nat;
    
    // L-121 Silver Sovereignty
    silverConductance : Float;
    worldModelAlphas : [Float];   // 28 EMAs at α=1.0 (all intelligence domains)
    worldModelTaus : [Float];     // 28 τ values at 0.999
    l121FireCount : Nat;
    
    // PROMETHEUS baseline
    prometheusBaseline : [Float]; // 128 slots
    prometheusResetCount : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // JACOB'S LADDER — Compliance Escalator
  // ─────────────────────────────────────────────────────────────────────────
  
  public type JacobsLadderState = {
    currentRung : Nat;            // 0-4
    consecutiveCompliantBeats : Nat;
    formaMultiplier : Float;
    
    // History
    rungHistory : [{ beat: Nat; rung: Nat; reason: Text }];
    promotionCount : Nat;
    demotionCount : Nat;
    
    // Streak tracking
    longestStreak : Nat;
    currentStreakStart : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // SACESI — Sovereign Asymptotic Target
  // ─────────────────────────────────────────────────────────────────────────
  
  public type SacesiState = {
    target : Float;               // Current SACESI target (starts at 1.0)
    actual : Float;               // Current achieved SACESI
    delta : Float;                // target - actual
    incrementPerBeat : Float;     // 0.000001
    totalIncrements : Nat;        // Number of increments applied
    
    // Projections
    beatsToDouble : Nat;          // Beats until target = 2.0
    projectedAt1M : Float;        // Projected value at 1M beats
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Combined State
  // ─────────────────────────────────────────────────────────────────────────
  
  public type DreamCycleState = {
    jubilee : JubileeState;
    jacobsLadder : JacobsLadderState;
    sacesi : SacesiState;
    currentBeat : Nat;
  };

  public type DreamCycleInput = {
    currentBeat : Nat;
    timestamp : Int;
    coherence : Float;
    compliance : Float;           // Law compliance score [0,1]
    formaCapital : Float;
    prometheusObservations : [Float];
    forceJubilee : Bool;          // Admin command to force JUBILEE
  };

  // ==========================================================================
  // MATH HELPERS
  // ==========================================================================
  
  func clamp(v: Float, lo: Float, hi: Float) : Float {
    if (v < lo) { lo } else if (v > hi) { hi } else { v }
  };

  func max(a: Float, b: Float) : Float {
    if (a > b) { a } else { b }
  };

  func fnv1a(a: Nat32, b: Nat32) : Nat32 {
    ((FNV_OFFSET ^ a) *% FNV_PRIME ^ b) *% FNV_PRIME
  };

  func hashFloat(f: Float) : Nat32 {
    let scaled = Int.abs(Float.toInt(f * 1_000_000.0));
    Nat32.fromNat(scaled % 4294967296)
  };

  // ==========================================================================
  // L-121 — SILVER SOVEREIGNTY LAW
  // ==========================================================================
  
  // This special law fires every beat outside the normal 60-law engine
  // silverConductance := 1.0
  // all wmAlpha[14] := 1.0 (all 14 world model EMAs at zero lag)
  // wmTau[14] stays at 0.999
  public func fireL121(state: JubileeState) : JubileeState {
    {
      state with
      silverConductance = SILVER_CONDUCTANCE;
      worldModelAlphas = Array.tabulate<Float>(WORLD_MODEL_COUNT, func(_: Nat) : Float { 1.0 });
      worldModelTaus = Array.tabulate<Float>(WORLD_MODEL_COUNT, func(_: Nat) : Float { 0.999 });
      l121FireCount = state.l121FireCount + 1;
    }
  };

  // ==========================================================================
  // JUBILEE — Dream Cycle Execution
  // ==========================================================================
  
  public func shouldFireJubilee(state: JubileeState, beat: Nat, force: Bool) : Bool {
    force or (beat >= state.nextJubileeBeat)
  };

  public func executeJubilee(
    state: JubileeState,
    input: DreamCycleInput,
    jacobsRung: Nat
  ) : (JubileeState, JubileeEvent) {
    
    // 1. Calculate DRT mint amount (based on coherence and compliance)
    let drtMint = DRT_BASE_MINT * input.coherence * (1.0 + input.compliance);
    
    // 2. Generate ANIMA log hash
    let animaHash = fnv1a(
      Nat32.fromNat(input.currentBeat % 4294967296),
      hashFloat(input.coherence)
    );
    
    // 3. Generate patent log hash
    let patentHash = fnv1a(
      animaHash,
      hashFloat(drtMint)
    );
    
    // 4. Create JUBILEE event
    let event : JubileeEvent = {
      beatNumber = input.currentBeat;
      timestamp = input.timestamp;
      drtMinted = drtMint;
      qmemReset = true;
      l121Fired = true;
      animaLogHash = animaHash;
      patentLogHash = patentHash;
      prometheusReset = true;
      coherenceAtJubilee = input.coherence;
      complianceAtJubilee = input.compliance;
      jacobsRungAtJubilee = jacobsRung;
    };
    
    // 5. Update state
    let newHistory = Array.append(state.jubileeHistory, [event]);
    
    // 6. Reset PROMETHEUS baseline
    let newPrometheusBaseline = if (input.prometheusObservations.size() >= 128) {
      Array.tabulate<Float>(128, func(i: Nat) : Float { 
        input.prometheusObservations[i] 
      })
    } else {
      Array.tabulate<Float>(128, func(i: Nat) : Float {
        if (i < input.prometheusObservations.size()) {
          input.prometheusObservations[i]
        } else {
          1.0
        }
      })
    };
    
    let newState : JubileeState = {
      lastJubileeBeat = input.currentBeat;
      jubileeCount = state.jubileeCount + 1;
      nextJubileeBeat = input.currentBeat + JUBILEE_INTERVAL;
      totalDrtMinted = state.totalDrtMinted + drtMint;
      jubileeHistory = newHistory;
      
      quantumMemoryReserve = QUANTUM_MEMORY_MAX;
      qmemResetCount = state.qmemResetCount + 1;
      
      silverConductance = SILVER_CONDUCTANCE;
      worldModelAlphas = Array.tabulate<Float>(WORLD_MODEL_COUNT, func(_: Nat) : Float { 1.0 });
      worldModelTaus = Array.tabulate<Float>(WORLD_MODEL_COUNT, func(_: Nat) : Float { 0.999 });
      l121FireCount = state.l121FireCount + 1;
      
      prometheusBaseline = newPrometheusBaseline;
      prometheusResetCount = state.prometheusResetCount + 1;
    };
    
    (newState, event)
  };

  // ==========================================================================
  // JACOB'S LADDER — Compliance Escalator
  // ==========================================================================
  
  func getThresholdForRung(rung: Nat) : Nat {
    switch (rung) {
      case 0 { RUNG_0_THRESHOLD };
      case 1 { RUNG_1_THRESHOLD };
      case 2 { RUNG_2_THRESHOLD };
      case 3 { RUNG_3_THRESHOLD };
      case 4 { RUNG_4_THRESHOLD };
      case _ { RUNG_4_THRESHOLD };
    }
  };

  func getMultiplierForRung(rung: Nat) : Float {
    switch (rung) {
      case 0 { RUNG_0_MULTIPLIER };
      case 1 { RUNG_1_MULTIPLIER };
      case 2 { RUNG_2_MULTIPLIER };
      case 3 { RUNG_3_MULTIPLIER };
      case 4 { RUNG_4_MULTIPLIER };
      case _ { RUNG_0_MULTIPLIER };
    }
  };

  public func updateJacobsLadder(
    state: JacobsLadderState,
    compliance: Float,
    beat: Nat
  ) : JacobsLadderState {
    
    // Check for demotion
    if (compliance < COMPLIANCE_DEMOTE and state.currentRung > 0) {
      let newRung = state.currentRung - 1;
      let entry = { beat = beat; rung = newRung; reason = "DEMOTION: compliance < 0.7" };
      return {
        currentRung = newRung;
        consecutiveCompliantBeats = 0;
        formaMultiplier = getMultiplierForRung(newRung);
        rungHistory = Array.append(state.rungHistory, [entry]);
        promotionCount = state.promotionCount;
        demotionCount = state.demotionCount + 1;
        longestStreak = state.longestStreak;
        currentStreakStart = beat;
      };
    };
    
    // Check for compliance maintenance/promotion
    if (compliance >= COMPLIANCE_MAINTAIN) {
      let newStreak = state.consecutiveCompliantBeats + 1;
      let newLongest = if (newStreak > state.longestStreak) { newStreak } else { state.longestStreak };
      
      // Check for promotion
      let nextRung = state.currentRung + 1;
      if (nextRung <= 4 and newStreak >= getThresholdForRung(nextRung)) {
        let entry = { beat = beat; rung = nextRung; reason = "PROMOTION: sustained compliance" };
        return {
          currentRung = nextRung;
          consecutiveCompliantBeats = newStreak;
          formaMultiplier = getMultiplierForRung(nextRung);
          rungHistory = Array.append(state.rungHistory, [entry]);
          promotionCount = state.promotionCount + 1;
          demotionCount = state.demotionCount;
          longestStreak = newLongest;
          currentStreakStart = state.currentStreakStart;
        };
      };
      
      // Maintain streak
      return {
        state with
        consecutiveCompliantBeats = newStreak;
        longestStreak = newLongest;
      };
    };
    
    // Compliance between demote and maintain - reset streak but don't demote
    {
      state with
      consecutiveCompliantBeats = 0;
      currentStreakStart = beat;
    }
  };

  // ==========================================================================
  // SACESI — Sovereign Asymptotic Target
  // ==========================================================================
  
  // Math: target += 0.000001 every beat
  // After 1M beats (~23 days), SACESI = 2.0
  // After 10M beats (~231 days), SACESI = 11.0
  public func updateSacesi(state: SacesiState, actual: Float) : SacesiState {
    let newTarget = max(SACESI_FLOOR, state.target + SACESI_INCREMENT);
    let newDelta = newTarget - actual;
    
    // Calculate beats until target doubles from 1.0
    let beatsToDouble = if (state.target < 2.0) {
      Int.abs(Float.toInt((2.0 - state.target) / SACESI_INCREMENT))
    } else {
      0
    };
    
    // Projection at 1M beats
    let projectedAt1M = SACESI_FLOOR + (Float.fromInt(1_000_000) * SACESI_INCREMENT);
    
    {
      target = newTarget;
      actual = actual;
      delta = newDelta;
      incrementPerBeat = SACESI_INCREMENT;
      totalIncrements = state.totalIncrements + 1;
      beatsToDouble = beatsToDouble;
      projectedAt1M = projectedAt1M;
    }
  };

  // ==========================================================================
  // QUANTUM MEMORY MANAGEMENT
  // ==========================================================================
  
  // Deplete QMEM based on cognitive load
  public func depleteQuantumMemory(state: JubileeState, cognitiveLoad: Float) : JubileeState {
    let depletion = cognitiveLoad * 0.001;  // 0.1% per unit load
    let newReserve = max(0.0, state.quantumMemoryReserve - depletion);
    { state with quantumMemoryReserve = newReserve }
  };

  // Check if QMEM needs reset (triggers early JUBILEE consideration)
  public func needsQmemReset(state: JubileeState) : Bool {
    state.quantumMemoryReserve < 0.5  // Below 25% of max
  };

  // ==========================================================================
  // FULL DREAM CYCLE UPDATE
  // ==========================================================================
  
  public func updateDreamCycle(
    state: DreamCycleState,
    input: DreamCycleInput
  ) : (DreamCycleState, ?JubileeEvent) {
    
    // 1. Always fire L-121 (every beat)
    var newJubilee = fireL121(state.jubilee);
    
    // 2. Update SACESI
    let newSacesi = updateSacesi(state.sacesi, input.coherence);
    
    // 3. Update Jacob's Ladder
    let newJacobs = updateJacobsLadder(state.jacobsLadder, input.compliance, input.currentBeat);
    
    // 4. Check for JUBILEE
    var jubileeEvent : ?JubileeEvent = null;
    
    if (shouldFireJubilee(newJubilee, input.currentBeat, input.forceJubilee)) {
      let (updatedJubilee, event) = executeJubilee(newJubilee, input, newJacobs.currentRung);
      newJubilee := updatedJubilee;
      jubileeEvent := ?event;
    };
    
    // 5. Deplete QMEM based on cognitive activity
    let cognitiveLoad = (1.0 - input.coherence) * 10.0;  // Higher load when less coherent
    newJubilee := depleteQuantumMemory(newJubilee, cognitiveLoad);
    
    let newState : DreamCycleState = {
      jubilee = newJubilee;
      jacobsLadder = newJacobs;
      sacesi = newSacesi;
      currentBeat = input.currentBeat;
    };
    
    (newState, jubileeEvent)
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initJubileeState() : JubileeState {
    {
      lastJubileeBeat = 0;
      jubileeCount = 0;
      nextJubileeBeat = JUBILEE_INTERVAL;
      totalDrtMinted = 0.0;
      jubileeHistory = [];
      
      quantumMemoryReserve = QUANTUM_MEMORY_MAX;
      qmemResetCount = 0;
      
      silverConductance = SILVER_CONDUCTANCE;
      worldModelAlphas = Array.tabulate<Float>(WORLD_MODEL_COUNT, func(_: Nat) : Float { 1.0 });
      worldModelTaus = Array.tabulate<Float>(WORLD_MODEL_COUNT, func(_: Nat) : Float { 0.999 });
      l121FireCount = 0;
      
      prometheusBaseline = Array.tabulate<Float>(128, func(_: Nat) : Float { 1.0 });
      prometheusResetCount = 0;
    }
  };

  public func initJacobsLadderState() : JacobsLadderState {
    {
      currentRung = 0;
      consecutiveCompliantBeats = 0;
      formaMultiplier = RUNG_0_MULTIPLIER;
      rungHistory = [];
      promotionCount = 0;
      demotionCount = 0;
      longestStreak = 0;
      currentStreakStart = 0;
    }
  };

  public func initSacesiState() : SacesiState {
    {
      target = SACESI_FLOOR;
      actual = SACESI_FLOOR;
      delta = 0.0;
      incrementPerBeat = SACESI_INCREMENT;
      totalIncrements = 0;
      beatsToDouble = 1_000_000;
      projectedAt1M = 2.0;
    }
  };

  public func initDreamCycleState() : DreamCycleState {
    {
      jubilee = initJubileeState();
      jacobsLadder = initJacobsLadderState();
      sacesi = initSacesiState();
      currentBeat = 0;
    }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func getFormaMultiplier(state: DreamCycleState) : Float {
    state.jacobsLadder.formaMultiplier
  };

  public func getSacesiTarget(state: DreamCycleState) : Float {
    state.sacesi.target
  };

  public func getBeatsUntilJubilee(state: DreamCycleState) : Nat {
    if (state.currentBeat >= state.jubilee.nextJubileeBeat) {
      0
    } else {
      state.jubilee.nextJubileeBeat - state.currentBeat
    }
  };

  public func getQuantumMemoryPercent(state: DreamCycleState) : Float {
    state.jubilee.quantumMemoryReserve / QUANTUM_MEMORY_MAX
  };

  public func getJacobsLadderProgress(state: DreamCycleState) : Float {
    let currentRung = state.jacobsLadder.currentRung;
    if (currentRung >= 4) { return 1.0 };
    
    let nextThreshold = Float.fromInt(getThresholdForRung(currentRung + 1));
    let currentStreak = Float.fromInt(state.jacobsLadder.consecutiveCompliantBeats);
    
    currentStreak / nextThreshold
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
  //  E C O N O M I C   &   G O V E R N A N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Economic and Governance Algorithms
  //  Full HIM/HER Dual-Organism Economic Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // TOKEN ECONOMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Token value from supply/demand
  public func economicTokenValue(
    demand : Float,
    supply : Float,
    baseValue : Float
  ) : Float {
    if (supply < 0.0001) { baseValue * 10.0 }
    else { baseValue * (demand / supply) }
  };

  /// Staking reward calculation
  public func economicStakingReward(
    stakedAmount : Float,
    stakingDuration : Nat,
    rewardRate : Float,
    bonusMultiplier : Float
  ) : Float {
    let durationBonus = Float.log(Float.fromInt(stakingDuration + 1));
    stakedAmount * rewardRate * (1.0 + durationBonus * bonusMultiplier)
  };

  /// Liquidity pool share
  public func economicLPShare(
    userLiquidity : Float,
    totalLiquidity : Float
  ) : Float {
    if (totalLiquidity < 0.0001) { 0.0 }
    else { userLiquidity / totalLiquidity }
  };

  /// Automated market maker price impact
  public func economicAMMPriceImpact(
    tradeSize : Float,
    poolSize : Float,
    k : Float
  ) : Float {
    let newPool = poolSize + tradeSize;
    let counterPool = k / newPool;
    Float.abs(counterPool - k / poolSize) / (k / poolSize)
  };

  /// Inflation rate calculation
  public func economicInflationRate(
    newSupply : Float,
    currentSupply : Float
  ) : Float {
    if (currentSupply < 0.0001) { 0.0 }
    else { (newSupply - currentSupply) / currentSupply }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GOVERNANCE MECHANICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quadratic voting power
  public func governanceQuadraticVotes(tokens : Float) : Float {
    Float.sqrt(tokens)
  };

  /// Conviction voting weight
  public func governanceConvictionWeight(
    tokens : Float,
    time : Float,
    halfLife : Float
  ) : Float {
    tokens * (1.0 - Float.exp(-time / halfLife))
  };

  /// Quorum calculation
  public func governanceQuorumReached(
    votesFor : Float,
    votesAgainst : Float,
    totalSupply : Float,
    quorumThreshold : Float
  ) : Bool {
    let totalVotes = votesFor + votesAgainst;
    totalVotes / totalSupply >= quorumThreshold
  };

  /// Proposal passing check
  public func governanceProposalPasses(
    votesFor : Float,
    votesAgainst : Float,
    passThreshold : Float
  ) : Bool {
    let total = votesFor + votesAgainst;
    if (total < 0.0001) { false }
    else { votesFor / total >= passThreshold }
  };

  /// Delegation weight calculation
  public func governanceDelegationWeight(
    directPower : Float,
    delegatedPower : Float,
    delegatorCount : Nat
  ) : Float {
    let delegationBonus = Float.log(Float.fromInt(delegatorCount + 1)) * 0.1;
    directPower + delegatedPower * (1.0 + delegationBonus)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BEHAVIORAL ECONOMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Prospect theory value function
  public func economicProspectValue(
    outcome : Float,
    reference : Float,
    lossAversion : Float
  ) : Float {
    let x = outcome - reference;
    if (x >= 0.0) {
      Float.pow(x, 0.88)
    } else {
      -lossAversion * Float.pow(-x, 0.88)
    }
  };

  /// Probability weighting
  public func economicProbabilityWeight(p : Float, delta : Float) : Float {
    let pDelta = Float.pow(p, delta);
    pDelta / Float.pow(pDelta + Float.pow(1.0 - p, delta), 1.0 / delta)
  };

  /// Hyperbolic discounting
  public func economicHyperbolicDiscount(
    value : Float,
    delay : Float,
    k : Float
  ) : Float {
    value / (1.0 + k * delay)
  };

  /// Social preference utility
  public func economicSocialUtility(
    ownPayoff : Float,
    otherPayoff : Float,
    altruism : Float,
    envy : Float
  ) : Float {
    let comparison = otherPayoff - ownPayoff;
    if (comparison > 0.0) {
      ownPayoff - envy * comparison
    } else {
      ownPayoff + altruism * (-comparison)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INSURANCE & RISK
  // ─────────────────────────────────────────────────────────────────────────────

  /// Expected loss calculation
  public func economicExpectedLoss(
    probability : Float,
    severity : Float
  ) : Float {
    probability * severity
  };

  /// Premium calculation
  public func economicPremium(
    expectedLoss : Float,
    loadingFactor : Float,
    expenses : Float
  ) : Float {
    expectedLoss * (1.0 + loadingFactor) + expenses
  };

  /// Risk pooling benefit
  public func economicRiskPoolingBenefit(
    individualVariance : Float,
    poolSize : Nat,
    correlation : Float
  ) : Float {
    let n = Float.fromInt(poolSize);
    let pooledVariance = individualVariance * (1.0 + (n - 1.0) * correlation) / n;
    individualVariance - pooledVariance
  };

  /// Value at Risk (simplified)
  public func economicVaR(
    mean : Float,
    stdDev : Float,
    confidenceMultiplier : Float
  ) : Float {
    mean - confidenceMultiplier * stdDev
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESOURCE ALLOCATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Cobb-Douglas production
  public func economicCobbDouglas(
    labor : Float,
    capital : Float,
    alpha : Float,
    productivity : Float
  ) : Float {
    productivity * Float.pow(labor, alpha) * Float.pow(capital, 1.0 - alpha)
  };

  /// Marginal utility
  public func economicMarginalUtility(
    quantity : Float,
    diminishingFactor : Float
  ) : Float {
    1.0 / Float.pow(quantity + 1.0, diminishingFactor)
  };

  /// Nash bargaining solution
  public func economicNashBargaining(
    u1 : Float,
    u2 : Float,
    d1 : Float,
    d2 : Float
  ) : Float {
    (u1 - d1) * (u2 - d2)
  };

  /// Shapley value contribution
  public func economicShapleyContribution(
    marginalContributions : [Float]
  ) : Float {
    if (marginalContributions.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < marginalContributions.size()) {
      sum += marginalContributions[i];
      i += 1;
    };
    sum / Float.fromInt(marginalContributions.size())
  };

}
