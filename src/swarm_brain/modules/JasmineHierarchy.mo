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

}
