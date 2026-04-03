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


// ============================================================================
// FREE ENERGY ENGINE — F = U - T*S + MEDINA ENGINE + QUANTUM BATTERY
// ============================================================================
// PHASE D: Free energy minimization, MEDINA 4096-dim tensor, Quantum Battery
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Rule: 100% of all value routes to creator reserve
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";

module FreeEnergyEngine {
    
    // ========================================================================
    // FREE ENERGY PRINCIPLE — F = U - T*S
    // ========================================================================
    // U = mean activation (internal energy)
    // T = substrate entropy (temperature)
    // S = normalized activation spread (entropy)
    // ΔF < -0.001 mints KNT (learning event)
    // ========================================================================
    
    public type FreeEnergyState = {
        // Core free energy values
        internalEnergy: Float;     // U = mean activation
        temperature: Float;        // T = substrate entropy
        entropy: Float;            // S = normalized activation spread
        freeEnergy: Float;         // F = U - T*S
        previousFreeEnergy: Float; // F from last beat
        deltaF: Float;             // Change in free energy
        
        // Learning events
        kntMintThreshold: Float;   // ΔF < -0.001 triggers KNT mint
        kntMintCounter: Nat;       // Number of KNT mints
        lastKntMintBeat: Nat;      // Beat of last KNT mint
        
        // MEDINA Engine state
        medinaEntropy: [Float];    // 8-block entropy decomposition
        medinaH_obs: Float;        // Observed entropy
        medinaY: Float;            // Y = k × ΔH × C × C_adj
        medinaK: Float;            // Learning rate constant
        medinaC: Float;            // Coherence factor
        medinaC_adj: Float;        // Adjusted coherence
        
        // Quantum Battery state
        batteryCharge: Float;      // Current charge level [0, 1]
        batteryCapacity: Float;    // Maximum capacity
        chargeRate: Float;         // Charge from RESONEX superradiance
        dischargeThreshold: Float; // Discharge when coherence < 1.02
        lastDischargeTargets: [Nat]; // Indices of weakest nodes
        
        // 3-Path Superposition Engine
        superpositionPaths: [Float]; // 3 parallel path amplitudes
        superpositionWinner: Nat;    // QSOV-weighted winner
        superpositionScore: Float;   // Final superposition score
        
        // Beat tracking
        beatCount: Nat;
        lastUpdateBeat: Nat;
    };
    
    // ========================================================================
    // COMPUTE FREE ENERGY — F = U - T*S
    // ========================================================================
    
    public func computeFreeEnergy(
        shell3Activations: [Float],
        shell12Activations: [Float],
        substrateEntropy: Float
    ) : { U: Float; T: Float; S: Float; F: Float } {
        
        // Internal Energy U = mean activation over Shell 3 + Shell 12
        var sumU : Float = 0.0;
        var countU : Float = 0.0;
        
        for (a in shell3Activations.vals()) {
            sumU += a;
            countU += 1.0;
        };
        for (a in shell12Activations.vals()) {
            sumU += a;
            countU += 1.0;
        };
        
        let U = if (countU > 0.0) { sumU / countU } else { 1.0 };
        
        // Temperature T = substrate entropy
        let T = Float.max(0.01, substrateEntropy);
        
        // Entropy S = Shannon entropy over Shell 3 (64 nodes)
        // S = -Σ p_i × log(p_i) where p_i = normalized activation
        var totalAct : Float = 0.0;
        for (a in shell3Activations.vals()) {
            totalAct += Float.max(0.001, a);
        };
        
        var S : Float = 0.0;
        if (totalAct > 0.0) {
            for (a in shell3Activations.vals()) {
                let p = Float.max(0.001, a) / totalAct;
                if (p > 0.001) {
                    S -= p * Float.log(p);
                };
            };
            // Normalize by maximum possible entropy (log N)
            let maxS = Float.log(Float.fromInt(shell3Activations.size()));
            S := if (maxS > 0.0) { S / maxS } else { 0.0 };
        };
        
        // Free Energy F = U - T*S
        let F = U - T * S;
        
        { U = U; T = T; S = S; F = F }
    };
    
    // ========================================================================
    // MEDINA ENGINE — 4096-dim tensor, 8-block entropy decomposition
    // ========================================================================
    // Tensor: 64 Shell 3 × 64 Shell 12 = 4096 dimensions
    // H_obs: Observed entropy across full tensor
    // Y = k × ΔH × C × C_adj (learning signal)
    // ========================================================================
    
    public func computeMedinaEngine(
        shell3: [Float],
        shell12: [Float],
        previousH_obs: Float,
        coherence: Float,
        k: Float
    ) : { tensor: [Float]; entropy8: [Float]; H_obs: Float; Y: Float } {
        
        // Build 4096-dim tensor (outer product of Shell 3 × Shell 12)
        // We'll sample 64 representative values for efficiency
        let tensorSample = Array.tabulate<Float>(64, func(i: Nat) : Float {
            let s3idx = i % shell3.size();
            let s12idx = (i * 2) % shell12.size();
            let s3val = if (s3idx < shell3.size()) { shell3[s3idx] } else { 1.0 };
            let s12val = if (s12idx < shell12.size()) { shell12[s12idx] } else { 1.0 };
            s3val * s12val
        });
        
        // 8-block entropy decomposition
        // Divide tensor into 8 blocks, compute entropy per block
        let entropy8 = Array.tabulate<Float>(8, func(block: Nat) : Float {
            let startIdx = block * 8;
            var blockSum : Float = 0.0;
            var blockEntropy : Float = 0.0;
            
            // Sum activations in block
            for (j in tensorSample.keys()) {
                if (j >= startIdx and j < startIdx + 8) {
                    blockSum += Float.max(0.001, tensorSample[j]);
                };
            };
            
            // Compute block entropy
            if (blockSum > 0.0) {
                for (j in tensorSample.keys()) {
                    if (j >= startIdx and j < startIdx + 8) {
                        let p = Float.max(0.001, tensorSample[j]) / blockSum;
                        if (p > 0.001) {
                            blockEntropy -= p * Float.log(p);
                        };
                    };
                };
            };
            
            blockEntropy
        });
        
        // H_obs = mean of 8-block entropies
        var entropySum : Float = 0.0;
        for (e in entropy8.vals()) {
            entropySum += e;
        };
        let H_obs = entropySum / 8.0;
        
        // ΔH = H_obs - previousH_obs
        let deltaH = H_obs - previousH_obs;
        
        // C_adj = adjusted coherence (nonlinear transform)
        let C_adj = coherence * coherence;  // Quadratic sensitivity
        
        // Y = k × ΔH × C × C_adj
        let Y = k * deltaH * coherence * C_adj;
        
        {
            tensor = tensorSample;
            entropy8 = entropy8;
            H_obs = H_obs;
            Y = Y;
        }
    };
    
    // ========================================================================
    // QUANTUM BATTERY — Charges from superradiance, discharges to weak nodes
    // ========================================================================
    
    public func updateQuantumBattery(
        currentCharge: Float,
        capacity: Float,
        superradianceAmplitude: Float,
        chargeRate: Float,
        shell3Coherence: Float,
        dischargeThreshold: Float
    ) : { newCharge: Float; shouldDischarge: Bool; dischargeAmount: Float } {
        
        // Charge from RESONEX superradiance events
        let chargeGain = superradianceAmplitude * chargeRate;
        var newCharge = Float.min(capacity, currentCharge + chargeGain);
        
        // Discharge when Shell 3 coherence < threshold
        let shouldDischarge = shell3Coherence < dischargeThreshold and newCharge > 0.1;
        
        var dischargeAmount : Float = 0.0;
        if (shouldDischarge) {
            // Discharge 20% of current charge
            dischargeAmount := newCharge * 0.2;
            newCharge := newCharge - dischargeAmount;
        };
        
        {
            newCharge = newCharge;
            shouldDischarge = shouldDischarge;
            dischargeAmount = dischargeAmount;
        }
    };
    
    // Find weakest nodes in Shell 3 for battery discharge targeting
    public func findWeakestNodes(shell3: [Float], n: Nat) : [Nat] {
        // Create (index, value) pairs
        let pairs = Array.tabulate<(Nat, Float)>(shell3.size(), func(i: Nat) : (Nat, Float) {
            (i, shell3[i])
        });
        
        // Sort by value (ascending) to find weakest
        let sorted = Array.thaw<(Nat, Float)>(pairs);
        for (i in sorted.keys()) {
            for (j in sorted.keys()) {
                if (j > i) {
                    if (sorted[j].1 < sorted[i].1) {
                        let temp = sorted[i];
                        sorted[i] := sorted[j];
                        sorted[j] := temp;
                    };
                };
            };
        };
        
        // Return indices of n weakest
        let result = Array.freeze(sorted);
        Array.tabulate<Nat>(Nat.min(n, result.size()), func(i: Nat) : Nat {
            result[i].0
        })
    };
    
    // ========================================================================
    // 3-PATH SUPERPOSITION ENGINE
    // ========================================================================
    // 3 parallel Shell 3 activation paths
    // Winner = max QSOV-weighted amplitude
    // ========================================================================
    
    public func compute3PathSuperposition(
        shell3: [Float],
        qsovScores: [Float]  // QSOV score for each path
    ) : { paths: [Float]; winner: Nat; score: Float } {
        
        // Compute 3 parallel paths through Shell 3
        // Path 0: Sum of nodes 0-20
        // Path 1: Sum of nodes 21-41
        // Path 2: Sum of nodes 42-63
        
        let paths = Array.tabulate<Float>(3, func(pathIdx: Nat) : Float {
            var pathSum : Float = 0.0;
            let startNode = pathIdx * 21;
            let endNode = if (pathIdx == 2) { 64 } else { startNode + 21 };
            
            for (i in shell3.keys()) {
                if (i >= startNode and i < endNode and i < shell3.size()) {
                    pathSum += shell3[i];
                };
            };
            
            // Weight by QSOV score for this path
            let qsovWeight = if (pathIdx < qsovScores.size()) { qsovScores[pathIdx] } else { 1.0 };
            pathSum * qsovWeight
        });
        
        // Find winner (max QSOV-weighted amplitude)
        var maxPath : Float = 0.0;
        var winner : Nat = 0;
        var totalPath : Float = 0.0;
        
        for (i in paths.keys()) {
            totalPath += paths[i];
            if (paths[i] > maxPath) {
                maxPath := paths[i];
                winner := i;
            };
        };
        
        // Superposition score: winner / total (interference pattern)
        let score = if (totalPath > 0.0) { maxPath / totalPath * 3.0 } else { 1.0 };
        
        {
            paths = paths;
            winner = winner;
            score = Float.min(2.0, Float.max(0.5, score));
        }
    };
    
    // ========================================================================
    // FULL FREE ENERGY TICK
    // ========================================================================
    
    public func tickFreeEnergy(
        state: FreeEnergyState,
        shell3: [Float],
        shell12: [Float],
        substrateEntropy: Float,
        superradianceAmplitude: Float,
        qsovScores: [Float]
    ) : FreeEnergyState {
        
        // 1. Compute free energy
        let fe = computeFreeEnergy(shell3, shell12, substrateEntropy);
        let deltaF = fe.F - state.previousFreeEnergy;
        
        // 2. Check for KNT mint (ΔF < -0.001)
        var newKntCounter = state.kntMintCounter;
        var newLastKntBeat = state.lastKntMintBeat;
        if (deltaF < state.kntMintThreshold) {
            newKntCounter += 1;
            newLastKntBeat := state.beatCount + 1;
        };
        
        // 3. Run MEDINA engine
        let medina = computeMedinaEngine(
            shell3, shell12,
            state.medinaH_obs,
            state.medinaC,
            state.medinaK
        );
        
        // 4. Update quantum battery
        let battery = updateQuantumBattery(
            state.batteryCharge,
            state.batteryCapacity,
            superradianceAmplitude,
            state.chargeRate,
            computeMean(shell3),
            state.dischargeThreshold
        );
        
        // Find weakest nodes if discharging
        let dischargeTargets = if (battery.shouldDischarge) {
            findWeakestNodes(shell3, 5)
        } else {
            state.lastDischargeTargets
        };
        
        // 5. Compute 3-path superposition
        let superposition = compute3PathSuperposition(shell3, qsovScores);
        
        // Return updated state
        {
            internalEnergy = fe.U;
            temperature = fe.T;
            entropy = fe.S;
            freeEnergy = fe.F;
            previousFreeEnergy = fe.F;
            deltaF = deltaF;
            
            kntMintThreshold = state.kntMintThreshold;
            kntMintCounter = newKntCounter;
            lastKntMintBeat = newLastKntBeat;
            
            medinaEntropy = medina.entropy8;
            medinaH_obs = medina.H_obs;
            medinaY = medina.Y;
            medinaK = state.medinaK;
            medinaC = computeMean(shell3);
            medinaC_adj = state.medinaC_adj;
            
            batteryCharge = battery.newCharge;
            batteryCapacity = state.batteryCapacity;
            chargeRate = state.chargeRate;
            dischargeThreshold = state.dischargeThreshold;
            lastDischargeTargets = dischargeTargets;
            
            superpositionPaths = superposition.paths;
            superpositionWinner = superposition.winner;
            superpositionScore = superposition.score;
            
            beatCount = state.beatCount + 1;
            lastUpdateBeat = state.beatCount + 1;
        }
    };
    
    // Helper: compute mean of array
    private func computeMean(arr: [Float]) : Float {
        if (arr.size() == 0) { return 1.0 };
        var sum : Float = 0.0;
        for (v in arr.vals()) { sum += v };
        sum / Float.fromInt(arr.size())
    };
    
    // ========================================================================
    // INITIALIZATION
    // ========================================================================
    
    public func initFreeEnergyState() : FreeEnergyState {
        {
            internalEnergy = 1.0;
            temperature = 1.0;
            entropy = 0.5;
            freeEnergy = 0.5;
            previousFreeEnergy = 0.5;
            deltaF = 0.0;
            
            kntMintThreshold = -0.001;
            kntMintCounter = 0;
            lastKntMintBeat = 0;
            
            medinaEntropy = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];
            medinaH_obs = 0.5;
            medinaY = 0.0;
            medinaK = 0.01;
            medinaC = 1.0;
            medinaC_adj = 1.0;
            
            batteryCharge = 0.5;
            batteryCapacity = 1.0;
            chargeRate = 0.1;
            dischargeThreshold = 1.02;
            lastDischargeTargets = [0, 1, 2, 3, 4];
            
            superpositionPaths = [1.0, 1.0, 1.0];
            superpositionWinner = 0;
            superpositionScore = 1.0;
            
            beatCount = 0;
            lastUpdateBeat = 0;
        }
    };
    
    // ========================================================================
    // SERIALIZATION
    // ========================================================================
    
    public type FreeEnergySerialized = {
        freeEnergy: Float;
        kntMintCounter: Nat;
        batteryCharge: Float;
        medinaH_obs: Float;
        beatCount: Nat;
    };
    
    public func serialize(state: FreeEnergyState) : FreeEnergySerialized {
        {
            freeEnergy = state.freeEnergy;
            kntMintCounter = state.kntMintCounter;
            batteryCharge = state.batteryCharge;
            medinaH_obs = state.medinaH_obs;
            beatCount = state.beatCount;
        }
    };
    
    // ========================================================================
    // ADVANCED FREE ENERGY OPERATIONS
    // ========================================================================
    
    // Compute free energy gradient for optimization
    public func computeFreeEnergyGradient(
        shell3: [Float],
        shell12: [Float],
        epsilon: Float
    ) : [Float] {
        // Numerical gradient: dF/dx_i ≈ (F(x+ε) - F(x-ε)) / 2ε
        let baseF = computeFreeEnergy(shell3, shell12, 1.0).F;
        
        Array.tabulate<Float>(shell3.size(), func(i: Nat) : Float {
            // Perturb node i
            let perturbedPlus = Array.tabulate<Float>(shell3.size(), func(j: Nat) : Float {
                if (j == i) { shell3[j] + epsilon } else { shell3[j] }
            });
            let perturbedMinus = Array.tabulate<Float>(shell3.size(), func(j: Nat) : Float {
                if (j == i) { shell3[j] - epsilon } else { shell3[j] }
            });
            
            let fPlus = computeFreeEnergy(perturbedPlus, shell12, 1.0).F;
            let fMinus = computeFreeEnergy(perturbedMinus, shell12, 1.0).F;
            
            (fPlus - fMinus) / (2.0 * epsilon)
        })
    };
    
    // Apply gradient descent step to minimize free energy
    public func applyFreeEnergyDescent(
        shell3: [Float],
        gradient: [Float],
        learningRate: Float
    ) : [Float] {
        Array.tabulate<Float>(shell3.size(), func(i: Nat) : Float {
            let current = shell3[i];
            let grad = if (i < gradient.size()) { gradient[i] } else { 0.0 };
            // Step in direction of negative gradient
            let newValue = current - learningRate * grad;
            Float.min(3.0, Float.max(0.1, newValue))
        })
    };
    
    // Compute surprise: S = -log P(observation)
    public func computeSurprise(observation: Float, expected: Float, variance: Float) : Float {
        let safeVar = Float.max(0.001, variance);
        let diff = observation - expected;
        // Gaussian surprise: (x - μ)² / 2σ² + log(σ√2π)
        let surprise = (diff * diff) / (2.0 * safeVar) + 0.5 * Float.log(safeVar * 2.506628);
        Float.max(0.0, surprise)
    };
    
    // Compute prediction error for active inference
    public func computePredictionError(
        predicted: [Float],
        actual: [Float]
    ) : { totalError: Float; errors: [Float] } {
        let errors = Array.tabulate<Float>(actual.size(), func(i: Nat) : Float {
            let pred = if (i < predicted.size()) { predicted[i] } else { 1.0 };
            let act = actual[i];
            Float.abs(act - pred)
        });
        
        var totalError : Float = 0.0;
        for (e in errors.vals()) {
            totalError += e;
        };
        
        {
            totalError = totalError / Float.fromInt(errors.size());
            errors = errors;
        }
    };
    
    // Active inference: update beliefs based on prediction errors
    public func activeInferenceUpdate(
        beliefs: [Float],
        observations: [Float],
        precisions: [Float],
        learningRate: Float
    ) : [Float] {
        Array.tabulate<Float>(beliefs.size(), func(i: Nat) : Float {
            let belief = beliefs[i];
            let obs = if (i < observations.size()) { observations[i] } else { 1.0 };
            let precision = if (i < precisions.size()) { precisions[i] } else { 1.0 };
            
            // Precision-weighted prediction error
            let error = (obs - belief) * precision;
            
            // Update belief
            let newBelief = belief + learningRate * error;
            Float.min(3.0, Float.max(0.1, newBelief))
        })
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

}
