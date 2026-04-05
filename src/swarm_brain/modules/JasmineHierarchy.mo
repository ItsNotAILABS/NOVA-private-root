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


// ═══════════════════════════════════════════════════════════════════════════════
// JASMINE HIERARCHY — Balance Through All Levels
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// JASMINE'S LAW: J = r × √(N × σ_H × (1 - H))
//
// This law MUST be satisfied at EVERY level of the hierarchy:
//   Level 0: NEURON    — Individual synaptic weights within a brain node
//   Level 1: DRONE     — Mini-mind (6-node brain per drone)
//   Level 2: SWARM     — Collective of drones with Kuramoto coupling
//   Level 3: ORGANISM  — The central mind (swarm_brain)
//   Level 4: WORLD     — The world organism containing all swarms
//
// Jasmine's Law ensures:
//   • No level becomes too coherent (H→0, loses adaptability)
//   • No level becomes too chaotic (H→1, loses coordination)
//   • Balance propagates UP and DOWN the hierarchy
//   • The whole system stays at the "edge of chaos"
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";

module JasmineHierarchy {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — JASMINE LAW PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Medina constants
  public let PHI_MEDINA : Float = 2.97442179;
  public let OMEGA_MEDINA : Float = 2.11185;
  public let TAU_EMERGENCE : Float = 0.618033988749;
  
  // Jasmine thresholds per level
  public let J_MIN_NEURON : Float = 0.3;
  public let J_MIN_DRONE : Float = 0.5;
  public let J_MIN_SWARM : Float = 0.6;
  public let J_MIN_ORGANISM : Float = 0.7;
  public let J_MIN_WORLD : Float = 0.75;
  
  // Optimal Jasmine range (edge of chaos)
  public let J_OPTIMAL_LOW : Float = 0.72;
  public let J_OPTIMAL_HIGH : Float = 0.88;
  
  // Correction rates
  public let CORRECTION_RATE : Float = 0.1;
  public let CASCADE_DAMPING : Float = 0.9;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — HIERARCHY STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type HierarchyLevel = {
    #Neuron;
    #Drone;
    #Swarm;
    #Organism;
    #World;
  };
  
  public type JasmineState = {
    rOrder    : Float;    // Kuramoto order parameter [0,1]
    n         : Nat;      // Number of entities at this level
    sigmaH    : Float;    // Std dev of Hebbian weights
    entropy   : Float;    // Shannon entropy [0,1]
    jValue    : Float;    // Computed Jasmine value
    balanced  : Bool;     // Is J within acceptable range?
    level     : HierarchyLevel;
  };
  
  public type HierarchyState = {
    neuronJ   : JasmineState;
    droneJ    : JasmineState;
    swarmJ    : JasmineState;
    organismJ : JasmineState;
    worldJ    : JasmineState;
    
    // Hierarchy coherence (are all levels balanced?)
    hierarchyCoherent : Bool;
    
    // Cross-level coupling strength
    upwardCoupling    : Float;  // How much lower levels influence higher
    downwardCoupling  : Float;  // How much higher levels constrain lower
    
    lastBeat : Nat;
  };
  
  public type CorrectionSignal = {
    targetLevel : HierarchyLevel;
    direction   : {#IncreaseCoherence; #IncreaseEntropy};
    magnitude   : Float;
    source      : HierarchyLevel;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // JASMINE'S LAW COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Core Jasmine computation: J = r × √(N × σ_H × (1 - H))
  public func computeJ(
    rOrder: Float,
    n: Nat,
    sigmaH: Float,
    entropy: Float
  ) : Float {
    let nFloat = Float.fromInt(n);
    let inner = nFloat * sigmaH * (1.0 - entropy);
    if (inner <= 0.0) { return 0.0 };
    let sqrtInner = Float.sqrt(inner);
    rOrder * sqrtInner
  };
  
  // Get minimum J threshold for a given level
  public func getMinJ(level: HierarchyLevel) : Float {
    switch (level) {
      case (#Neuron) J_MIN_NEURON;
      case (#Drone) J_MIN_DRONE;
      case (#Swarm) J_MIN_SWARM;
      case (#Organism) J_MIN_ORGANISM;
      case (#World) J_MIN_WORLD;
    }
  };
  
  // Check if J is balanced
  public func isBalanced(jValue: Float, level: HierarchyLevel) : Bool {
    jValue >= getMinJ(level)
  };
  
  // Check if J is in optimal range
  public func isOptimal(jValue: Float) : Bool {
    jValue >= J_OPTIMAL_LOW and jValue <= J_OPTIMAL_HIGH
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // JASMINE STATE CREATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func createJasmineState(
    level: HierarchyLevel,
    rOrder: Float,
    n: Nat,
    sigmaH: Float,
    entropy: Float
  ) : JasmineState {
    let jValue = computeJ(rOrder, n, sigmaH, entropy);
    {
      rOrder = rOrder;
      n = n;
      sigmaH = sigmaH;
      entropy = entropy;
      jValue = jValue;
      balanced = isBalanced(jValue, level);
      level = level;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HIERARCHY COHERENCE CHECK
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func checkHierarchyCoherence(state: HierarchyState) : Bool {
    state.neuronJ.balanced and
    state.droneJ.balanced and
    state.swarmJ.balanced and
    state.organismJ.balanced and
    state.worldJ.balanced
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CORRECTION SIGNAL GENERATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Generate correction signals to rebalance the hierarchy
  public func generateCorrectionSignals(state: HierarchyState) : [CorrectionSignal] {
    var signals : [CorrectionSignal] = [];
    
    // Check each level and generate corrections
    let levels : [(JasmineState, HierarchyLevel)] = [
      (state.neuronJ, #Neuron),
      (state.droneJ, #Drone),
      (state.swarmJ, #Swarm),
      (state.organismJ, #Organism),
      (state.worldJ, #World)
    ];
    
    for ((js, level) in levels.vals()) {
      if (not js.balanced) {
        let minJ = getMinJ(level);
        let deficit = minJ - js.jValue;
        
        // Determine correction direction
        let direction = if (js.entropy > 0.7) {
          #IncreaseCoherence  // Too chaotic, need more sync
        } else if (js.entropy < 0.3) {
          #IncreaseEntropy    // Too rigid, need more exploration
        } else if (js.rOrder < 0.5) {
          #IncreaseCoherence  // Low synchronization
        } else {
          #IncreaseEntropy    // Default to adding flexibility
        };
        
        signals := Array.append(signals, [{
          targetLevel = level;
          direction = direction;
          magnitude = Float.abs(deficit) * CORRECTION_RATE;
          source = #Organism;  // Corrections originate from organism level
        }]);
      };
    };
    
    signals
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HIERARCHY COUPLING — Bidirectional Influence
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Upward influence: how lower levels affect higher
  // J_higher = J_higher + upwardCoupling × mean(J_lower_levels)
  public func applyUpwardCoupling(
    currentJ: Float,
    lowerLevelJs: [Float],
    coupling: Float
  ) : Float {
    if (lowerLevelJs.size() == 0) { return currentJ };
    
    var sum : Float = 0.0;
    for (j in lowerLevelJs.vals()) {
      sum += j;
    };
    let meanLower = sum / Float.fromInt(lowerLevelJs.size());
    
    currentJ + coupling * (meanLower - currentJ)
  };
  
  // Downward constraint: how higher levels constrain lower
  // J_lower = J_lower + downwardCoupling × (J_higher - J_lower)
  public func applyDownwardConstraint(
    currentJ: Float,
    higherLevelJ: Float,
    coupling: Float
  ) : Float {
    currentJ + coupling * (higherLevelJ - currentJ)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FULL HIERARCHY BEAT — Update all levels
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func beatHierarchy(
    state: HierarchyState,
    // Current measurements from each level
    neuronMeasure: {rOrder: Float; n: Nat; sigmaH: Float; entropy: Float},
    droneMeasure: {rOrder: Float; n: Nat; sigmaH: Float; entropy: Float},
    swarmMeasure: {rOrder: Float; n: Nat; sigmaH: Float; entropy: Float},
    organismMeasure: {rOrder: Float; n: Nat; sigmaH: Float; entropy: Float},
    worldMeasure: {rOrder: Float; n: Nat; sigmaH: Float; entropy: Float},
    beatNum: Nat
  ) : HierarchyState {
    
    // Step 1: Compute raw Jasmine values
    let neuronJ = createJasmineState(#Neuron, neuronMeasure.rOrder, neuronMeasure.n, neuronMeasure.sigmaH, neuronMeasure.entropy);
    let droneJ = createJasmineState(#Drone, droneMeasure.rOrder, droneMeasure.n, droneMeasure.sigmaH, droneMeasure.entropy);
    let swarmJ = createJasmineState(#Swarm, swarmMeasure.rOrder, swarmMeasure.n, swarmMeasure.sigmaH, swarmMeasure.entropy);
    let organismJ = createJasmineState(#Organism, organismMeasure.rOrder, organismMeasure.n, organismMeasure.sigmaH, organismMeasure.entropy);
    let worldJ = createJasmineState(#World, worldMeasure.rOrder, worldMeasure.n, worldMeasure.sigmaH, worldMeasure.entropy);
    
    // Step 2: Apply bidirectional coupling
    // Upward: neuron → drone → swarm → organism → world
    let droneJCoupled = applyUpwardCoupling(droneJ.jValue, [neuronJ.jValue], state.upwardCoupling);
    let swarmJCoupled = applyUpwardCoupling(swarmJ.jValue, [neuronJ.jValue, droneJ.jValue], state.upwardCoupling);
    let organismJCoupled = applyUpwardCoupling(organismJ.jValue, [neuronJ.jValue, droneJ.jValue, swarmJ.jValue], state.upwardCoupling);
    let worldJCoupled = applyUpwardCoupling(worldJ.jValue, [neuronJ.jValue, droneJ.jValue, swarmJ.jValue, organismJ.jValue], state.upwardCoupling);
    
    // Downward: world → organism → swarm → drone → neuron
    let organismJFinal = applyDownwardConstraint(organismJCoupled, worldJCoupled, state.downwardCoupling);
    let swarmJFinal = applyDownwardConstraint(swarmJCoupled, organismJFinal, state.downwardCoupling);
    let droneJFinal = applyDownwardConstraint(droneJCoupled, swarmJFinal, state.downwardCoupling);
    let neuronJFinal = applyDownwardConstraint(neuronJ.jValue, droneJFinal, state.downwardCoupling);
    
    // Step 3: Create final states with coupled values
    let finalNeuronJ : JasmineState = {
      rOrder = neuronJ.rOrder;
      n = neuronJ.n;
      sigmaH = neuronJ.sigmaH;
      entropy = neuronJ.entropy;
      jValue = neuronJFinal;
      balanced = isBalanced(neuronJFinal, #Neuron);
      level = #Neuron;
    };
    
    let finalDroneJ : JasmineState = {
      rOrder = droneJ.rOrder;
      n = droneJ.n;
      sigmaH = droneJ.sigmaH;
      entropy = droneJ.entropy;
      jValue = droneJFinal;
      balanced = isBalanced(droneJFinal, #Drone);
      level = #Drone;
    };
    
    let finalSwarmJ : JasmineState = {
      rOrder = swarmJ.rOrder;
      n = swarmJ.n;
      sigmaH = swarmJ.sigmaH;
      entropy = swarmJ.entropy;
      jValue = swarmJFinal;
      balanced = isBalanced(swarmJFinal, #Swarm);
      level = #Swarm;
    };
    
    let finalOrganismJ : JasmineState = {
      rOrder = organismJ.rOrder;
      n = organismJ.n;
      sigmaH = organismJ.sigmaH;
      entropy = organismJ.entropy;
      jValue = organismJFinal;
      balanced = isBalanced(organismJFinal, #Organism);
      level = #Organism;
    };
    
    let finalWorldJ : JasmineState = {
      rOrder = worldJ.rOrder;
      n = worldJ.n;
      sigmaH = worldJ.sigmaH;
      entropy = worldJ.entropy;
      jValue = worldJCoupled;
      balanced = isBalanced(worldJCoupled, #World);
      level = #World;
    };
    
    // Step 4: Construct new hierarchy state
    let newState : HierarchyState = {
      neuronJ = finalNeuronJ;
      droneJ = finalDroneJ;
      swarmJ = finalSwarmJ;
      organismJ = finalOrganismJ;
      worldJ = finalWorldJ;
      hierarchyCoherent = 
        finalNeuronJ.balanced and 
        finalDroneJ.balanced and 
        finalSwarmJ.balanced and 
        finalOrganismJ.balanced and 
        finalWorldJ.balanced;
      upwardCoupling = state.upwardCoupling;
      downwardCoupling = state.downwardCoupling;
      lastBeat = beatNum;
    };
    
    newState
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initHierarchyState() : HierarchyState {
    let defaultJState : JasmineState = {
      rOrder = 0.8;
      n = 1;
      sigmaH = 0.5;
      entropy = 0.5;
      jValue = 0.5;
      balanced = true;
      level = #Neuron;
    };
    
    {
      neuronJ = { defaultJState with level = #Neuron };
      droneJ = { defaultJState with level = #Drone };
      swarmJ = { defaultJState with level = #Swarm };
      organismJ = { defaultJState with level = #Organism };
      worldJ = { defaultJState with level = #World };
      hierarchyCoherent = true;
      upwardCoupling = TAU_EMERGENCE;    // Golden ratio coupling
      downwardCoupling = TAU_EMERGENCE;
      lastBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HIERARCHY REPORT
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getHierarchyReport(state: HierarchyState) : Text {
    let statusIcon = func (balanced: Bool) : Text {
      if (balanced) "✓" else "✗"
    };
    
    "JASMINE HIERARCHY STATUS (Beat " # Nat.toText(state.lastBeat) # "):\n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "Level      │ J-Value │ Balanced │ r    │ H    │ σ_H\n" #
    "───────────┼─────────┼──────────┼──────┼──────┼──────\n" #
    "WORLD      │ " # Float.format(#fix 3, state.worldJ.jValue) # "   │ " # statusIcon(state.worldJ.balanced) # "        │ " # Float.format(#fix 2, state.worldJ.rOrder) # " │ " # Float.format(#fix 2, state.worldJ.entropy) # " │ " # Float.format(#fix 2, state.worldJ.sigmaH) # "\n" #
    "ORGANISM   │ " # Float.format(#fix 3, state.organismJ.jValue) # "   │ " # statusIcon(state.organismJ.balanced) # "        │ " # Float.format(#fix 2, state.organismJ.rOrder) # " │ " # Float.format(#fix 2, state.organismJ.entropy) # " │ " # Float.format(#fix 2, state.organismJ.sigmaH) # "\n" #
    "SWARM      │ " # Float.format(#fix 3, state.swarmJ.jValue) # "   │ " # statusIcon(state.swarmJ.balanced) # "        │ " # Float.format(#fix 2, state.swarmJ.rOrder) # " │ " # Float.format(#fix 2, state.swarmJ.entropy) # " │ " # Float.format(#fix 2, state.swarmJ.sigmaH) # "\n" #
    "DRONE      │ " # Float.format(#fix 3, state.droneJ.jValue) # "   │ " # statusIcon(state.droneJ.balanced) # "        │ " # Float.format(#fix 2, state.droneJ.rOrder) # " │ " # Float.format(#fix 2, state.droneJ.entropy) # " │ " # Float.format(#fix 2, state.droneJ.sigmaH) # "\n" #
    "NEURON     │ " # Float.format(#fix 3, state.neuronJ.jValue) # "   │ " # statusIcon(state.neuronJ.balanced) # "        │ " # Float.format(#fix 2, state.neuronJ.rOrder) # " │ " # Float.format(#fix 2, state.neuronJ.entropy) # " │ " # Float.format(#fix 2, state.neuronJ.sigmaH) # "\n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "HIERARCHY COHERENT: " # (if (state.hierarchyCoherent) "YES ✓" else "NO ✗") # "\n" #
    "Upward Coupling: " # Float.format(#fix 3, state.upwardCoupling) # "\n" #
    "Downward Coupling: " # Float.format(#fix 3, state.downwardCoupling)
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
