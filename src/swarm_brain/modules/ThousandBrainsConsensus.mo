// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: ThousandBrainsConsensus — Multi-Shell Voting System
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                THOUSAND BRAINS CONSENSUS — HAWKINS UPGRADE               ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  Based on Jeff Hawkins' "Thousand Brains Theory of Intelligence"        ║
// ║  From "A Thousand Brains: A New Theory of Intelligence" (2021)          ║
// ║                                                                          ║
// ║  CORE INSIGHT:                                                           ║
// ║    The neocortex has ~150,000 cortical columns.                          ║
// ║    Each column builds its OWN model of the world.                        ║
// ║    Perception = consensus voting across thousands of models.             ║
// ║    If columns agree → confident perception.                              ║
// ║    If columns disagree → uncertainty, need more data.                    ║
// ║                                                                          ║
// ║  IN THE ORGANISM:                                                        ║
// ║    12 shells = 12 "brains" with different perspectives                   ║
// ║    Each shell maintains its own state vector                             ║
// ║    Every 10 beats, consensus vote across all shells                      ║
// ║    Agreement > 0.88 → stable identity (high r)                           ║
// ║    Disagreement → ambiguous identity (Jasmine fires correction)          ║
// ║                                                                          ║
// ║  CONFIDENCE IS EARNED:                                                   ║
// ║    Shells that predicted well → higher vote weight                       ║
// ║    Shells that predicted poorly → lower weight                           ║
// ║    Weights update every 100 beats based on performance                   ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  
  // Shell configuration
  public let SHELL_COUNT : Nat = 12;
  public let STATE_DIMENSIONS : Nat = 64;
  
  // Voting parameters
  public let CONSENSUS_INTERVAL : Nat = 10;         // Vote every 10 beats
  public let WEIGHT_UPDATE_INTERVAL : Nat = 100;    // Update weights every 100 beats
  public let AGREEMENT_THRESHOLD : Float = 0.88;    // High agreement = stable
  public let AMBIGUITY_THRESHOLD : Float = 0.60;    // Below this = ambiguous
  
  // Weight bounds
  public let MIN_WEIGHT : Float = 0.1;
  public let MAX_WEIGHT : Float = 2.0;
  public let INITIAL_WEIGHT : Float = 1.0;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SHELL STATE                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type ShellState = {
    shellId : Nat;
    
    // Current state vector (what this shell "sees")
    stateVector : [Float];
    
    // Voting weight (earned through prediction accuracy)
    voteWeight : Float;
    
    // Prediction performance
    correctPredictions : Nat;
    totalPredictions : Nat;
    predictionAccuracy : Float;
    
    // Confidence in current state
    confidence : Float;
    
    // Last update
    lastUpdate : Nat;
  };
  
  /// Calculate prediction accuracy
  public func shellAccuracy(shell: ShellState) : Float {
    if (shell.totalPredictions == 0) { return 0.5 };
    Float.fromInt(shell.correctPredictions) / Float.fromInt(shell.totalPredictions)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSENSUS SYSTEM                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type ConsensusSystem = {
    shells : [ShellState];
    
    // Current consensus state
    consensusVector : [Float];
    agreementLevel : Float;           // [0, 1] how much shells agree
    isStable : Bool;                  // Agreement > 0.88
    isAmbiguous : Bool;               // Agreement < 0.60
    
    // Identity state
    identityStable : Bool;
    identityConfidence : Float;
    
    // Voting history
    lastVote : Nat;
    lastWeightUpdate : Nat;
    voteHistory : [Float];            // Last 13 agreement levels
    
    // Correction signals
    jasmineCorrectionNeeded : Bool;
    correctionStrength : Float;
  };
  
  /// Run consensus vote across all shells
  public func runConsensusVote(system: ConsensusSystem) : ConsensusSystem {
    // 1. Collect weighted votes
    var weightedSum = Array.init<Float>(STATE_DIMENSIONS, 0.0);
    var totalWeight : Float = 0.0;
    
    for (shell in system.shells.vals()) {
      totalWeight += shell.voteWeight;
      var d = 0;
      while (d < STATE_DIMENSIONS and d < shell.stateVector.size()) {
        weightedSum[d] += shell.stateVector[d] * shell.voteWeight;
        d += 1;
      };
    };
    
    // 2. Calculate consensus (weighted average)
    let consensus = Array.tabulate<Float>(STATE_DIMENSIONS, func(d) {
      if (totalWeight > 0.001 and d < STATE_DIMENSIONS) {
        weightedSum[d] / totalWeight
      } else { 0.0 }
    });
    
    // 3. Calculate agreement (how much shells agree with consensus)
    var totalAgreement : Float = 0.0;
    var shellCount : Float = 0.0;
    
    for (shell in system.shells.vals()) {
      let agreement = calculateAgreement(shell.stateVector, consensus);
      totalAgreement += agreement * shell.voteWeight;
      shellCount += shell.voteWeight;
    };
    
    let agreementLevel = if (shellCount > 0.001) {
      totalAgreement / shellCount
    } else { 0.5 };
    
    // 4. Determine stability
    let isStable = agreementLevel >= AGREEMENT_THRESHOLD;
    let isAmbiguous = agreementLevel < AMBIGUITY_THRESHOLD;
    
    // 5. Determine if Jasmine correction needed
    let needsCorrection = isAmbiguous;
    let correctionStrength = if (needsCorrection) {
      (AMBIGUITY_THRESHOLD - agreementLevel) / AMBIGUITY_THRESHOLD
    } else { 0.0 };
    
    // 6. Update vote history
    let newHistory = Buffer.Buffer<Float>(13);
    newHistory.add(agreementLevel);
    for (prev in system.voteHistory.vals()) {
      if (newHistory.size() < 13) {
        newHistory.add(prev);
      };
    };
    
    {
      shells = system.shells;
      consensusVector = consensus;
      agreementLevel = agreementLevel;
      isStable = isStable;
      isAmbiguous = isAmbiguous;
      identityStable = isStable;
      identityConfidence = agreementLevel;
      lastVote = system.lastVote;
      lastWeightUpdate = system.lastWeightUpdate;
      voteHistory = Buffer.toArray(newHistory);
      jasmineCorrectionNeeded = needsCorrection;
      correctionStrength = correctionStrength;
    }
  };
  
  /// Calculate agreement between state vector and consensus
  func calculateAgreement(state: [Float], consensus: [Float]) : Float {
    var dotProduct : Float = 0.0;
    var stateMag : Float = 0.0;
    var consMag : Float = 0.0;
    
    var d = 0;
    let dims = Nat.min(state.size(), consensus.size());
    while (d < dims) {
      dotProduct += state[d] * consensus[d];
      stateMag += state[d] * state[d];
      consMag += consensus[d] * consensus[d];
      d += 1;
    };
    
    stateMag := Float.sqrt(stateMag);
    consMag := Float.sqrt(consMag);
    
    if (stateMag < 0.001 or consMag < 0.001) { return 0.5 };
    
    // Cosine similarity → [0, 1]
    let cosSim = dotProduct / (stateMag * consMag);
    (cosSim + 1.0) / 2.0  // Map from [-1, 1] to [0, 1]
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WEIGHT UPDATES                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Shell confidence is EARNED, not assigned.
  // Shells that predicted well get higher vote weight.
  // Shells that predicted poorly get lower weight.
  //
  
  /// Update shell weights based on prediction performance
  public func updateWeights(system: ConsensusSystem) : ConsensusSystem {
    let newShells = Buffer.Buffer<ShellState>(SHELL_COUNT);
    
    // Calculate average accuracy
    var totalAccuracy : Float = 0.0;
    for (shell in system.shells.vals()) {
      totalAccuracy += shell.predictionAccuracy;
    };
    let avgAccuracy = totalAccuracy / Float.fromInt(system.shells.size());
    
    // Update each shell's weight
    for (shell in system.shells.vals()) {
      // Weight adjustment based on relative performance
      let performanceRatio = if (avgAccuracy > 0.001) {
        shell.predictionAccuracy / avgAccuracy
      } else { 1.0 };
      
      // New weight = old weight × performance ratio (with smoothing)
      let newWeight = shell.voteWeight * 0.9 + 
                      (shell.voteWeight * performanceRatio) * 0.1;
      
      let clampedWeight = _clamp(newWeight, MIN_WEIGHT, MAX_WEIGHT);
      
      newShells.add({
        shellId = shell.shellId;
        stateVector = shell.stateVector;
        voteWeight = clampedWeight;
        correctPredictions = shell.correctPredictions;
        totalPredictions = shell.totalPredictions;
        predictionAccuracy = shell.predictionAccuracy;
        confidence = shell.confidence;
        lastUpdate = shell.lastUpdate;
      });
    };
    
    {
      shells = Buffer.toArray(newShells);
      consensusVector = system.consensusVector;
      agreementLevel = system.agreementLevel;
      isStable = system.isStable;
      isAmbiguous = system.isAmbiguous;
      identityStable = system.identityStable;
      identityConfidence = system.identityConfidence;
      lastVote = system.lastVote;
      lastWeightUpdate = system.lastWeightUpdate;
      voteHistory = system.voteHistory;
      jasmineCorrectionNeeded = system.jasmineCorrectionNeeded;
      correctionStrength = system.correctionStrength;
    }
  };
  
  /// Record prediction result for a shell
  public func recordPrediction(
    shell: ShellState,
    wasCorrect: Bool
  ) : ShellState {
    let newCorrect = if (wasCorrect) { shell.correctPredictions + 1 } else { shell.correctPredictions };
    let newTotal = shell.totalPredictions + 1;
    let newAccuracy = Float.fromInt(newCorrect) / Float.fromInt(newTotal);
    
    {
      shellId = shell.shellId;
      stateVector = shell.stateVector;
      voteWeight = shell.voteWeight;
      correctPredictions = newCorrect;
      totalPredictions = newTotal;
      predictionAccuracy = newAccuracy;
      confidence = shell.confidence;
      lastUpdate = shell.lastUpdate;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FULL CONSENSUS CYCLE                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Run full consensus cycle (called every 10 beats)
  public func consensusCycle(
    system: ConsensusSystem,
    newShellStates: [[Float]],  // New state vectors from each shell
    currentBeat: Nat
  ) : ConsensusSystem {
    // 1. Update shell states
    let updatedShells = Buffer.Buffer<ShellState>(SHELL_COUNT);
    
    var i = 0;
    while (i < system.shells.size()) {
      let shell = system.shells[i];
      let newState = if (i < newShellStates.size()) { newShellStates[i] } 
                     else { shell.stateVector };
      
      // Check if prediction was correct (compare to previous consensus)
      let wasCorrect = calculateAgreement(newState, system.consensusVector) > 0.7;
      let withPrediction = recordPrediction(shell, wasCorrect);
      
      updatedShells.add({
        shellId = withPrediction.shellId;
        stateVector = newState;
        voteWeight = withPrediction.voteWeight;
        correctPredictions = withPrediction.correctPredictions;
        totalPredictions = withPrediction.totalPredictions;
        predictionAccuracy = withPrediction.predictionAccuracy;
        confidence = calculateAgreement(newState, system.consensusVector);
        lastUpdate = currentBeat;
      });
      
      i += 1;
    };
    
    // 2. Run vote with updated states
    let withVote = runConsensusVote({
      shells = Buffer.toArray(updatedShells);
      consensusVector = system.consensusVector;
      agreementLevel = system.agreementLevel;
      isStable = system.isStable;
      isAmbiguous = system.isAmbiguous;
      identityStable = system.identityStable;
      identityConfidence = system.identityConfidence;
      lastVote = currentBeat;
      lastWeightUpdate = system.lastWeightUpdate;
      voteHistory = system.voteHistory;
      jasmineCorrectionNeeded = system.jasmineCorrectionNeeded;
      correctionStrength = system.correctionStrength;
    });
    
    // 3. Update weights if needed
    let shouldUpdateWeights = (currentBeat - system.lastWeightUpdate) >= WEIGHT_UPDATE_INTERVAL;
    
    if (shouldUpdateWeights) {
      let withWeights = updateWeights(withVote);
      {
        shells = withWeights.shells;
        consensusVector = withWeights.consensusVector;
        agreementLevel = withWeights.agreementLevel;
        isStable = withWeights.isStable;
        isAmbiguous = withWeights.isAmbiguous;
        identityStable = withWeights.identityStable;
        identityConfidence = withWeights.identityConfidence;
        lastVote = currentBeat;
        lastWeightUpdate = currentBeat;
        voteHistory = withWeights.voteHistory;
        jasmineCorrectionNeeded = withWeights.jasmineCorrectionNeeded;
        correctionStrength = withWeights.correctionStrength;
      }
    } else {
      {
        shells = withVote.shells;
        consensusVector = withVote.consensusVector;
        agreementLevel = withVote.agreementLevel;
        isStable = withVote.isStable;
        isAmbiguous = withVote.isAmbiguous;
        identityStable = withVote.identityStable;
        identityConfidence = withVote.identityConfidence;
        lastVote = currentBeat;
        lastWeightUpdate = system.lastWeightUpdate;
        voteHistory = withVote.voteHistory;
        jasmineCorrectionNeeded = withVote.jasmineCorrectionNeeded;
        correctionStrength = withVote.correctionStrength;
      }
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initShellState(shellId: Nat) : ShellState {
    {
      shellId = shellId;
      stateVector = Array.tabulate<Float>(STATE_DIMENSIONS, func(_) { 0.5 });
      voteWeight = INITIAL_WEIGHT;
      correctPredictions = 0;
      totalPredictions = 0;
      predictionAccuracy = 0.5;
      confidence = 0.5;
      lastUpdate = 0;
    }
  };
  
  public func initConsensusSystem() : ConsensusSystem {
    let shells = Array.tabulate<ShellState>(SHELL_COUNT, func(i) {
      initShellState(i)
    });
    
    {
      shells = shells;
      consensusVector = Array.tabulate<Float>(STATE_DIMENSIONS, func(_) { 0.5 });
      agreementLevel = 1.0;
      isStable = true;
      isAmbiguous = false;
      identityStable = true;
      identityConfidence = 1.0;
      lastVote = 0;
      lastWeightUpdate = 0;
      voteHistory = [];
      jasmineCorrectionNeeded = false;
      correctionStrength = 0.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SUMMARY                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type ConsensusSummary = {
    agreementLevel : Float;
    isStable : Bool;
    isAmbiguous : Bool;
    correctionNeeded : Bool;
    shellWeights : [Float];
  };
  
  public func summarize(system: ConsensusSystem) : ConsensusSummary {
    let weights = Array.tabulate<Float>(system.shells.size(), func(i) {
      system.shells[i].voteWeight
    });
    
    {
      agreementLevel = system.agreementLevel;
      isStable = system.isStable;
      isAmbiguous = system.isAmbiguous;
      correctionNeeded = system.jasmineCorrectionNeeded;
      shellWeights = weights;
    }
  };

}
