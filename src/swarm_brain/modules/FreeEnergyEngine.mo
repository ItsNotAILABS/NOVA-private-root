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

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════
  // ║                                                                                                 ║
  // ║  SECTION II: ADVANCED THERMODYNAMIC FREE ENERGY MINIMIZATION                                   ║
  // ║  Deep Substrate Architecture for Enterprise-Level Organism Intelligence                        ║
  // ║                                                                                                 ║
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // LANDAU FREE ENERGY FUNCTIONAL — F[φ] = ∫(a·φ² + b·φ⁴ + c·(∇φ)²)dx
  // Phase transition dynamics for organism state changes
  // ─────────────────────────────────────────────────────────────────────────────

  public type LandauState = {
    orderParameter: Float;           // phi - Primary order parameter
    orderParameterGradient: [Float]; // ∇φ - Spatial gradient
    quadraticCoeff: Float;           // a - Temperature-dependent coefficient
    quarticCoeff: Float;             // b - Stabilization coefficient
    gradientCoeff: Float;            // c - Surface tension coefficient
    landauFreeEnergy: Float;         // F[φ] - Total Landau free energy
    criticalTemperature: Float;      // T_c - Phase transition temperature
    reducedTemperature: Float;       // τ = (T - T_c)/T_c
    correlationLength: Float;        // ξ - Correlation length
    susceptibility: Float;           // χ - Order parameter susceptibility
    phaseState: PhaseState;          // Current phase (ordered/disordered)
  };

  public type PhaseState = {
    #Ordered;      // Below critical temperature
    #Disordered;   // Above critical temperature
    #Critical;     // At phase transition
    #Metastable;   // Trapped in local minimum
  };

  /// Compute Landau free energy density
  /// f(φ) = a·φ² + b·φ⁴
  public func computeLandauDensity(phi: Float, a: Float, b: Float) : Float {
    a * phi * phi + b * phi * phi * phi * phi
  };

  /// Compute gradient energy contribution
  /// f_grad = c·|∇φ|²
  public func computeGradientEnergy(gradient: [Float], c: Float) : Float {
    var sumSq : Float = 0.0;
    for (g in gradient.vals()) {
      sumSq += g * g;
    };
    c * sumSq
  };

  /// Compute total Landau free energy
  public func computeTotalLandauEnergy(state: LandauState) : Float {
    let bulkEnergy = computeLandauDensity(state.orderParameter, state.quadraticCoeff, state.quarticCoeff);
    let gradEnergy = computeGradientEnergy(state.orderParameterGradient, state.gradientCoeff);
    bulkEnergy + gradEnergy
  };

  /// Compute equilibrium order parameter (minimizes free energy)
  /// φ_eq = ±√(-a/2b) for a < 0
  public func computeEquilibriumOrderParameter(a: Float, b: Float) : Float {
    if (a >= 0.0) {
      0.0 // Disordered phase
    } else {
      Float.sqrt(-a / (2.0 * b)) // Ordered phase
    }
  };

  /// Compute correlation length
  /// ξ = √(c/|a|)
  public func computeCorrelationLength(c: Float, a: Float) : Float {
    if (Float.abs(a) < 1e-10) {
      1e10 // Diverges at critical point
    } else {
      Float.sqrt(c / Float.abs(a))
    }
  };

  /// Compute susceptibility
  /// χ = 1/(2|a|) for a > 0, χ = 1/(4|a|) for a < 0
  public func computeSusceptibility(a: Float) : Float {
    let absA = Float.abs(a);
    if (absA < 1e-10) {
      1e10 // Diverges at critical point
    } else if (a > 0.0) {
      1.0 / (2.0 * absA)
    } else {
      1.0 / (4.0 * absA)
    }
  };

  /// Initialize Landau state
  public func initLandauState(temperature: Float, criticalTemp: Float) : LandauState {
    let tau = (temperature - criticalTemp) / criticalTemp;
    let a = tau; // a ∝ (T - T_c)
    let b : Float = 1.0; // Stabilization
    let c : Float = 1.0; // Gradient coefficient
    
    let phi = computeEquilibriumOrderParameter(a, b);
    let xi = computeCorrelationLength(c, a);
    let chi = computeSusceptibility(a);
    
    let phase : PhaseState = if (Float.abs(tau) < 0.01) {
      #Critical
    } else if (tau < 0.0) {
      #Ordered
    } else {
      #Disordered
    };
    
    {
      orderParameter = phi;
      orderParameterGradient = [0.0, 0.0, 0.0];
      quadraticCoeff = a;
      quarticCoeff = b;
      gradientCoeff = c;
      landauFreeEnergy = computeLandauDensity(phi, a, b);
      criticalTemperature = criticalTemp;
      reducedTemperature = tau;
      correlationLength = xi;
      susceptibility = chi;
      phaseState = phase;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GINZBURG-LANDAU THEORY — psi = |ψ|·e^(iθ) Complex Order Parameter
  // Superconducting-like coherence in organism substrate
  // ─────────────────────────────────────────────────────────────────────────────

  public type GinzburgLandauState = {
    amplitude: Float;                // |ψ| - Wave function amplitude
    phase: Float;                    // θ - Phase angle
    superfluidDensity: Float;        // n_s = |ψ|²
    coherenceLength: Float;          // ξ_GL - GL coherence length
    penetrationDepth: Float;         // λ - London penetration depth
    ginzburgParameter: Float;        // κ = λ/ξ
    supercurrentDensity: [Float];    // J_s - Supercurrent
    magneticField: [Float];          // B - Magnetic field
    vectorPotential: [Float];        // A - Vector potential
    glFreeEnergy: Float;             // F_GL - Total GL free energy
    fluxQuantum: Float;              // Φ₀ = h/2e
    vortexState: VortexState;        // Vortex configuration
  };

  public type VortexState = {
    #NoVortex;     // Meissner state
    #SingleVortex; // Single flux quantum
    #VortexLattice;// Abrikosov lattice
    #Mixed;        // Mixed state
  };

  /// Compute GL free energy density
  /// f_GL = α|ψ|² + β|ψ|⁴/2 + (1/2m*)|(-iℏ∇ - 2eA)ψ|² + B²/2μ₀
  public func computeGLFreeEnergyDensity(
    amplitude: Float,
    alpha: Float,
    beta: Float,
    gradientTerm: Float,
    magneticEnergy: Float
  ) : Float {
    let psi2 = amplitude * amplitude;
    let psi4 = psi2 * psi2;
    alpha * psi2 + (beta * psi4 / 2.0) + gradientTerm + magneticEnergy
  };

  /// Compute supercurrent density
  /// J_s = (2e·n_s/m*)·(ℏ∇θ - 2eA)
  public func computeSupercurrent(
    superfluidDensity: Float,
    phaseGradient: [Float],
    vectorPotential: [Float],
    effectiveMass: Float
  ) : [Float] {
    let e : Float = 1.602e-19; // Elementary charge
    let hbar : Float = 1.055e-34; // Reduced Planck constant
    let coeff = 2.0 * e * superfluidDensity / effectiveMass;
    
    var current = Buffer.Buffer<Float>(phaseGradient.size());
    var i = 0;
    for (pg in phaseGradient.vals()) {
      let a = if (i < vectorPotential.size()) { vectorPotential[i] } else { 0.0 };
      current.add(coeff * (hbar * pg - 2.0 * e * a));
      i += 1;
    };
    Buffer.toArray(current)
  };

  /// Compute London penetration depth
  /// λ = √(m*/(μ₀·n_s·(2e)²))
  public func computePenetrationDepth(effectiveMass: Float, superfluidDensity: Float) : Float {
    let mu0 : Float = 4.0 * 3.14159265359e-7; // Vacuum permeability
    let e : Float = 1.602e-19;
    if (superfluidDensity < 1e-20) {
      1e10 // Diverges when n_s → 0
    } else {
      Float.sqrt(effectiveMass / (mu0 * superfluidDensity * 4.0 * e * e))
    }
  };

  /// Compute GL coherence length
  /// ξ_GL = ℏ/√(2m*|α|)
  public func computeGLCoherenceLength(effectiveMass: Float, alpha: Float) : Float {
    let hbar : Float = 1.055e-34;
    let absAlpha = Float.abs(alpha);
    if (absAlpha < 1e-30) {
      1e10 // Diverges at T_c
    } else {
      hbar / Float.sqrt(2.0 * effectiveMass * absAlpha)
    }
  };

  /// Compute Ginzburg parameter κ = λ/ξ
  public func computeGinzburgParameter(lambda: Float, xi: Float) : Float {
    if (xi < 1e-20) { 1e10 } else { lambda / xi }
  };

  /// Determine vortex state based on κ
  public func determineVortexState(kappa: Float, field: Float, hc1: Float, hc2: Float) : VortexState {
    if (field < hc1) {
      #NoVortex // Meissner state
    } else if (field > hc2) {
      #NoVortex // Normal state (superconductivity destroyed)
    } else if (kappa < 0.707) {
      #SingleVortex // Type I
    } else {
      #VortexLattice // Type II - Abrikosov lattice
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VARIATIONAL FREE ENERGY — F_var[q] = ⟨E⟩_q - T·S[q]
  // Bayesian brain inference and active inference substrate
  // ─────────────────────────────────────────────────────────────────────────────

  public type VariationalState = {
    beliefs: [Float];                // q(x) - Approximate posterior
    priors: [Float];                 // p(x) - Prior beliefs
    observations: [Float];           // y - Sensory observations
    generativeParams: [Float];       // θ - Generative model parameters
    expectedEnergy: Float;           // ⟨E⟩_q - Expected energy under q
    entropy: Float;                  // S[q] - Entropy of q
    variationalFE: Float;            // F_var = ⟨E⟩_q - T·S[q]
    klDivergence: Float;             // D_KL[q||p] - KL divergence
    accuracy: Float;                 // -⟨ln p(y|x)⟩_q - Accuracy term
    complexity: Float;               // D_KL[q(x)||p(x)] - Complexity term
    surprisal: Float;                // -ln p(y) - Surprisal
    precisionWeights: [Float];       // π - Precision-weighted prediction errors
  };

  /// Compute KL divergence D_KL[q||p]
  /// D_KL = ∑ q(x)·ln(q(x)/p(x))
  public func computeKLDivergence(q: [Float], p: [Float]) : Float {
    var kl : Float = 0.0;
    var i = 0;
    for (qi in q.vals()) {
      let pi = if (i < p.size()) { p[i] } else { 1e-10 };
      let qi_safe = if (qi < 1e-10) { 1e-10 } else { qi };
      let pi_safe = if (pi < 1e-10) { 1e-10 } else { pi };
      kl += qi_safe * Float.log(qi_safe / pi_safe);
      i += 1;
    };
    kl
  };

  /// Compute entropy S[q] = -∑ q(x)·ln(q(x))
  public func computeDistributionEntropy(q: [Float]) : Float {
    var entropy : Float = 0.0;
    for (qi in q.vals()) {
      let qi_safe = if (qi < 1e-10) { 1e-10 } else { qi };
      entropy -= qi_safe * Float.log(qi_safe);
    };
    entropy
  };

  /// Compute variational free energy
  /// F = -ln p(y) + D_KL[q(x)||p(x|y)]
  /// F = Accuracy + Complexity
  public func computeVariationalFreeEnergy(state: VariationalState) : Float {
    state.accuracy + state.complexity
  };

  /// Compute precision-weighted prediction error
  /// ε = π · (y - ŷ)
  public func computePrecisionWeightedError(
    observation: Float,
    prediction: Float,
    precision: Float
  ) : Float {
    precision * (observation - prediction)
  };

  /// Compute expected log-likelihood (negative accuracy)
  public func computeExpectedLogLikelihood(
    observations: [Float],
    predictions: [Float],
    precisions: [Float]
  ) : Float {
    var logLik : Float = 0.0;
    var i = 0;
    for (obs in observations.vals()) {
      let pred = if (i < predictions.size()) { predictions[i] } else { 0.0 };
      let prec = if (i < precisions.size()) { precisions[i] } else { 1.0 };
      let error = obs - pred;
      // Gaussian log-likelihood: -0.5·π·ε² + 0.5·ln(π) - 0.5·ln(2π)
      logLik += -0.5 * prec * error * error + 0.5 * Float.log(prec) - 0.918938533;
      i += 1;
    };
    logLik
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HELMHOLTZ FREE ENERGY — A = U - T·S (Canonical Ensemble)
  // Thermal equilibrium thermodynamics for organism metabolism
  // ─────────────────────────────────────────────────────────────────────────────

  public type HelmholtzState = {
    internalEnergy: Float;           // U - Internal energy
    temperature: Float;              // T - Temperature
    entropy: Float;                  // S - Entropy
    helmholtzEnergy: Float;          // A = U - T·S
    partitionFunction: Float;        // Z = ∑ exp(-E_i/kT)
    heatCapacity: Float;             // C_V = ∂U/∂T
    pressure: Float;                 // P = -∂A/∂V
    chemicalPotential: Float;        // μ = ∂A/∂N
    numberOfParticles: Nat;          // N - Particle count
    volume: Float;                   // V - System volume
  };

  /// Compute partition function Z = ∑ exp(-E_i/kT)
  public func computePartitionFunction(energyLevels: [Float], temperature: Float) : Float {
    let kB : Float = 1.380649e-23; // Boltzmann constant
    let beta = 1.0 / (kB * temperature);
    var z : Float = 0.0;
    for (e in energyLevels.vals()) {
      z += Float.exp(-beta * e);
    };
    z
  };

  /// Compute Helmholtz free energy from partition function
  /// A = -kT·ln(Z)
  public func computeHelmholtzFromPartition(z: Float, temperature: Float) : Float {
    let kB : Float = 1.380649e-23;
    if (z < 1e-100) {
      1e10 // Invalid partition function
    } else {
      -kB * temperature * Float.log(z)
    }
  };

  /// Compute internal energy from partition function
  /// U = -∂ln(Z)/∂β = kT²·∂ln(Z)/∂T
  public func computeInternalEnergyFromPartition(
    energyLevels: [Float],
    temperature: Float,
    z: Float
  ) : Float {
    let kB : Float = 1.380649e-23;
    let beta = 1.0 / (kB * temperature);
    var sumE : Float = 0.0;
    for (e in energyLevels.vals()) {
      sumE += e * Float.exp(-beta * e);
    };
    if (z < 1e-100) { 0.0 } else { sumE / z }
  };

  /// Compute entropy from partition function
  /// S = kB·(ln(Z) + β·U)
  public func computeEntropyFromPartition(z: Float, u: Float, temperature: Float) : Float {
    let kB : Float = 1.380649e-23;
    let beta = 1.0 / (kB * temperature);
    if (z < 1e-100) { 0.0 } else { kB * (Float.log(z) + beta * u) }
  };

  /// Compute heat capacity C_V = ∂U/∂T
  public func computeHeatCapacity(
    energyLevels: [Float],
    temperature: Float,
    z: Float,
    u: Float
  ) : Float {
    let kB : Float = 1.380649e-23;
    let beta = 1.0 / (kB * temperature);
    
    // C_V = β²·(⟨E²⟩ - ⟨E⟩²)
    var sumE2 : Float = 0.0;
    for (e in energyLevels.vals()) {
      sumE2 += e * e * Float.exp(-beta * e);
    };
    let avgE2 = if (z < 1e-100) { 0.0 } else { sumE2 / z };
    let avgE = u;
    
    beta * beta * (avgE2 - avgE * avgE)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GIBBS FREE ENERGY — G = H - T·S = U + PV - T·S
  // Chemical equilibrium and reaction thermodynamics
  // ─────────────────────────────────────────────────────────────────────────────

  public type GibbsState = {
    enthalpy: Float;                 // H = U + PV
    temperature: Float;              // T - Temperature
    entropy: Float;                  // S - Entropy
    gibbsEnergy: Float;              // G = H - T·S
    pressure: Float;                 // P - Pressure
    volume: Float;                   // V - Volume
    chemicalPotentials: [Float];     // μ_i - Chemical potentials
    activities: [Float];             // a_i - Activities
    reactionQuotient: Float;         // Q - Reaction quotient
    equilibriumConstant: Float;      // K - Equilibrium constant
    deltaG: Float;                   // ΔG = G_products - G_reactants
    deltaG0: Float;                  // ΔG° - Standard Gibbs energy
  };

  /// Compute Gibbs free energy G = H - T·S
  public func computeGibbsEnergy(enthalpy: Float, temperature: Float, entropy: Float) : Float {
    enthalpy - temperature * entropy
  };

  /// Compute reaction Gibbs energy
  /// ΔG = ΔG° + RT·ln(Q)
  public func computeReactionGibbs(
    deltaG0: Float,
    temperature: Float,
    reactionQuotient: Float
  ) : Float {
    let R : Float = 8.314462; // Gas constant J/(mol·K)
    if (reactionQuotient < 1e-100) {
      deltaG0 - 100.0 * R * temperature // Effectively -∞
    } else {
      deltaG0 + R * temperature * Float.log(reactionQuotient)
    }
  };

  /// Compute equilibrium constant from standard Gibbs energy
  /// K = exp(-ΔG°/RT)
  public func computeEquilibriumConstant(deltaG0: Float, temperature: Float) : Float {
    let R : Float = 8.314462;
    Float.exp(-deltaG0 / (R * temperature))
  };

  /// Compute chemical potential
  /// μ_i = μ°_i + RT·ln(a_i)
  public func computeChemicalPotential(
    standardPotential: Float,
    temperature: Float,
    activity: Float
  ) : Float {
    let R : Float = 8.314462;
    let a_safe = if (activity < 1e-100) { 1e-100 } else { activity };
    standardPotential + R * temperature * Float.log(a_safe)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GRAND POTENTIAL — Ω = -PV = F - μN (Grand Canonical Ensemble)
  // Open system thermodynamics for organism-environment exchange
  // ─────────────────────────────────────────────────────────────────────────────

  public type GrandPotentialState = {
    helmholtzEnergy: Float;          // F - Helmholtz free energy
    chemicalPotential: Float;        // μ - Chemical potential
    particleNumber: Float;           // ⟨N⟩ - Average particle number
    grandPotential: Float;           // Ω = F - μN
    grandPartitionFunction: Float;   // Ξ = ∑ exp(-β(E_i - μN_i))
    pressure: Float;                 // P = -Ω/V
    numberFluctuation: Float;        // ⟨(ΔN)²⟩ - Number fluctuations
    compressibility: Float;          // κ_T - Isothermal compressibility
  };

  /// Compute grand partition function
  /// Ξ = ∑ z^N · Z_N where z = exp(βμ)
  public func computeGrandPartitionFunction(
    canonicalPartitions: [Float],
    chemicalPotential: Float,
    temperature: Float
  ) : Float {
    let kB : Float = 1.380649e-23;
    let beta = 1.0 / (kB * temperature);
    let z = Float.exp(beta * chemicalPotential); // Fugacity
    
    var xi : Float = 0.0;
    var n = 0;
    for (zn in canonicalPartitions.vals()) {
      var zPowerN : Float = 1.0;
      var i = 0;
      while (i < n) {
        zPowerN *= z;
        i += 1;
      };
      xi += zPowerN * zn;
      n += 1;
    };
    xi
  };

  /// Compute grand potential from grand partition function
  /// Ω = -kT·ln(Ξ)
  public func computeGrandPotential(xi: Float, temperature: Float) : Float {
    let kB : Float = 1.380649e-23;
    if (xi < 1e-100) { 1e10 } else { -kB * temperature * Float.log(xi) }
  };

  /// Compute average particle number
  /// ⟨N⟩ = kT·∂ln(Ξ)/∂μ
  public func computeAverageParticleNumber(
    canonicalPartitions: [Float],
    chemicalPotential: Float,
    temperature: Float,
    xi: Float
  ) : Float {
    let kB : Float = 1.380649e-23;
    let beta = 1.0 / (kB * temperature);
    let z = Float.exp(beta * chemicalPotential);
    
    var sumN : Float = 0.0;
    var n = 0;
    for (zn in canonicalPartitions.vals()) {
      var zPowerN : Float = 1.0;
      var i = 0;
      while (i < n) {
        zPowerN *= z;
        i += 1;
      };
      sumN += Float.fromInt(n) * zPowerN * zn;
      n += 1;
    };
    if (xi < 1e-100) { 0.0 } else { sumN / xi }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INFORMATION-THEORETIC FREE ENERGY — F_info = ⟨E⟩ - T·H
  // Shannon entropy and information thermodynamics
  // ─────────────────────────────────────────────────────────────────────────────

  public type InformationFreeEnergyState = {
    probabilityDistribution: [Float]; // p(x) - Probability distribution
    energyFunction: [Float];          // E(x) - Energy landscape
    shannonEntropy: Float;            // H = -∑ p·ln(p)
    averageEnergy: Float;             // ⟨E⟩ = ∑ p·E
    informationFE: Float;             // F = ⟨E⟩ - T·H
    mutualInformation: Float;         // I(X;Y) - Mutual information
    transferEntropy: Float;           // T_X→Y - Transfer entropy
    relativeEntropy: Float;           // D(p||q) - Relative entropy
    fisherInformation: Float;         // I(θ) - Fisher information
    entropyProduction: Float;         // dS/dt - Entropy production rate
  };

  /// Compute Shannon entropy H = -∑ p·ln(p)
  public func computeShannonEntropy(p: [Float]) : Float {
    var h : Float = 0.0;
    for (pi in p.vals()) {
      let pi_safe = if (pi < 1e-100) { 1e-100 } else { pi };
      h -= pi_safe * Float.log(pi_safe);
    };
    h
  };

  /// Compute mutual information I(X;Y) = H(X) + H(Y) - H(X,Y)
  public func computeMutualInformation(
    marginalX: [Float],
    marginalY: [Float],
    joint: [[Float]]
  ) : Float {
    let hX = computeShannonEntropy(marginalX);
    let hY = computeShannonEntropy(marginalY);
    
    // Compute joint entropy
    var hXY : Float = 0.0;
    for (row in joint.vals()) {
      for (pxy in row.vals()) {
        let pxy_safe = if (pxy < 1e-100) { 1e-100 } else { pxy };
        hXY -= pxy_safe * Float.log(pxy_safe);
      };
    };
    
    hX + hY - hXY
  };

  /// Compute transfer entropy T_X→Y
  /// T_X→Y = H(Y_t|Y_{t-1}) - H(Y_t|Y_{t-1}, X_{t-1})
  public func computeTransferEntropy(
    conditionalYgivenPastY: Float,
    conditionalYgivenPastYX: Float
  ) : Float {
    conditionalYgivenPastY - conditionalYgivenPastYX
  };

  /// Compute Fisher information
  /// I(θ) = E[(∂ln(p)/∂θ)²]
  public func computeFisherInformation(
    scoreFunction: [Float],
    probabilities: [Float]
  ) : Float {
    var fisher : Float = 0.0;
    var i = 0;
    for (score in scoreFunction.vals()) {
      let p = if (i < probabilities.size()) { probabilities[i] } else { 1e-10 };
      fisher += p * score * score;
      i += 1;
    };
    fisher
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NONEQUILIBRIUM FREE ENERGY — Jarzynski Equality & Crooks Fluctuation
  // Far-from-equilibrium thermodynamics for active organism dynamics
  // ─────────────────────────────────────────────────────────────────────────────

  public type NonequilibriumState = {
    workValues: [Float];             // W_i - Work values from trajectories
    heatValues: [Float];             // Q_i - Heat values from trajectories
    freeEnergyDifference: Float;     // ΔF - Free energy difference
    jarzynskiAverage: Float;         // ⟨exp(-βW)⟩ = exp(-βΔF)
    dissipatedWork: Float;           // W_diss = W - ΔF
    entropyProduction: Float;        // σ = β·W_diss
    fluctuationParameter: Float;     // Measure of fluctuation-dissipation
    crooksRatio: Float;              // P_F(W)/P_R(-W) = exp(β(W-ΔF))
    nonequilibriumTemperature: Float;// Effective temperature
    drivingForce: Float;             // External driving force
  };

  /// Compute Jarzynski average
  /// ⟨exp(-βW)⟩ = exp(-βΔF)
  public func computeJarzynskiAverage(workValues: [Float], temperature: Float) : Float {
    let kB : Float = 1.380649e-23;
    let beta = 1.0 / (kB * temperature);
    
    var avgExpW : Float = 0.0;
    var count : Float = 0.0;
    for (w in workValues.vals()) {
      avgExpW += Float.exp(-beta * w);
      count += 1.0;
    };
    if (count < 1.0) { 1.0 } else { avgExpW / count }
  };

  /// Compute free energy difference from Jarzynski equality
  /// ΔF = -kT·ln(⟨exp(-βW)⟩)
  public func computeFreeEnergyFromJarzynski(jarzynskiAvg: Float, temperature: Float) : Float {
    let kB : Float = 1.380649e-23;
    if (jarzynskiAvg < 1e-100) { 1e10 } else { -kB * temperature * Float.log(jarzynskiAvg) }
  };

  /// Compute dissipated work
  /// W_diss = ⟨W⟩ - ΔF
  public func computeDissipatedWork(workValues: [Float], deltaF: Float) : Float {
    var avgW : Float = 0.0;
    var count : Float = 0.0;
    for (w in workValues.vals()) {
      avgW += w;
      count += 1.0;
    };
    let meanWork = if (count < 1.0) { 0.0 } else { avgW / count };
    meanWork - deltaF
  };

  /// Compute entropy production
  /// σ = β·W_diss ≥ 0 (Second Law)
  public func computeEntropyProduction(dissipatedWork: Float, temperature: Float) : Float {
    let kB : Float = 1.380649e-23;
    let beta = 1.0 / (kB * temperature);
    let sigma = beta * dissipatedWork;
    if (sigma < 0.0) { 0.0 } else { sigma } // Enforce second law
  };

  /// Compute Crooks fluctuation ratio
  /// P_F(W)/P_R(-W) = exp(β(W - ΔF))
  public func computeCrooksRatio(work: Float, deltaF: Float, temperature: Float) : Float {
    let kB : Float = 1.380649e-23;
    let beta = 1.0 / (kB * temperature);
    Float.exp(beta * (work - deltaF))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DENSITY FUNCTIONAL THEORY FREE ENERGY — F[ρ]
  // Quantum mechanical foundation for organism electron density
  // ─────────────────────────────────────────────────────────────────────────────

  public type DFTFreeEnergyState = {
    electronDensity: [Float];        // ρ(r) - Electron density
    kineticEnergy: Float;            // T_s[ρ] - Kohn-Sham kinetic energy
    hartreeEnergy: Float;            // E_H[ρ] - Classical Coulomb
    exchangeEnergy: Float;           // E_x[ρ] - Exchange energy
    correlationEnergy: Float;        // E_c[ρ] - Correlation energy
    externalPotential: [Float];      // v_ext(r) - External potential
    dftFreeEnergy: Float;            // F[ρ] - Total DFT free energy
    exchangeCorrelationPotential: [Float]; // v_xc[ρ] - XC potential
    totalEnergy: Float;              // E_tot[ρ] - Total electronic energy
    bandGap: Float;                  // ε_LUMO - ε_HOMO
  };

  /// Compute Thomas-Fermi kinetic energy
  /// T_TF[ρ] = C_TF · ∫ρ^(5/3) dr
  public func computeThomasFermiKinetic(density: [Float], volume: Float) : Float {
    let C_TF : Float = 2.871; // (3/10)·(3π²)^(2/3) in atomic units
    var integral : Float = 0.0;
    for (rho in density.vals()) {
      let rho_safe = if (rho < 1e-20) { 1e-20 } else { rho };
      integral += Float.pow(rho_safe, 5.0/3.0);
    };
    let dr = volume / Float.fromInt(density.size());
    C_TF * integral * dr
  };

  /// Compute Hartree energy (classical Coulomb)
  /// E_H[ρ] = (1/2) · ∫∫ ρ(r)ρ(r')/|r-r'| dr dr'
  public func computeHartreeEnergy(density: [Float], volume: Float) : Float {
    let n = density.size();
    let dr = volume / Float.fromInt(n);
    var eH : Float = 0.0;
    
    var i = 0;
    for (rho_i in density.vals()) {
      var j = 0;
      for (rho_j in density.vals()) {
        if (i != j) {
          let r = Float.abs(Float.fromInt(i - j)) * Float.pow(dr, 1.0/3.0);
          let r_safe = if (r < 1e-10) { 1e-10 } else { r };
          eH += rho_i * rho_j / r_safe;
        };
        j += 1;
      };
      i += 1;
    };
    0.5 * eH * dr * dr
  };

  /// Compute local density approximation exchange energy
  /// E_x^LDA[ρ] = C_x · ∫ρ^(4/3) dr
  public func computeLDAExchange(density: [Float], volume: Float) : Float {
    let C_x : Float = -0.7386; // -(3/4)·(3/π)^(1/3) in atomic units
    var integral : Float = 0.0;
    for (rho in density.vals()) {
      let rho_safe = if (rho < 1e-20) { 1e-20 } else { rho };
      integral += Float.pow(rho_safe, 4.0/3.0);
    };
    let dr = volume / Float.fromInt(density.size());
    C_x * integral * dr
  };

  /// Compute local density approximation correlation energy (Perdew-Zunger)
  public func computeLDACorrelation(density: [Float], volume: Float) : Float {
    // PZ81 parametrization constants
    let A : Float = 0.0311;
    let B : Float = -0.048;
    let C : Float = 0.0020;
    let D : Float = -0.0116;
    
    var integral : Float = 0.0;
    for (rho in density.vals()) {
      let rho_safe = if (rho < 1e-20) { 1e-20 } else { rho };
      let rs = Float.pow(3.0 / (4.0 * 3.14159265359 * rho_safe), 1.0/3.0);
      
      let ec = if (rs >= 1.0) {
        // High-density limit
        let gamma : Float = -0.1423;
        let beta1 : Float = 1.0529;
        let beta2 : Float = 0.3334;
        gamma / (1.0 + beta1 * Float.sqrt(rs) + beta2 * rs)
      } else {
        // Low-density limit
        A * Float.log(rs) + B + C * rs * Float.log(rs) + D * rs
      };
      
      integral += rho_safe * ec;
    };
    let dr = volume / Float.fromInt(density.size());
    integral * dr
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // EFFECTIVE FREE ENERGY — F_eff = F + λ·C (Constraint Thermodynamics)
  // Organism constraints and regulatory thermodynamics
  // ─────────────────────────────────────────────────────────────────────────────

  public type ConstrainedFreeEnergyState = {
    baseFreeEnergy: Float;           // F - Base free energy
    constraints: [Float];            // C_i - Constraint functions
    lagrangeMultipliers: [Float];    // λ_i - Lagrange multipliers
    effectiveFreeEnergy: Float;      // F_eff = F + ∑λ_i·C_i
    constraintViolations: [Float];   // |C_i| - Constraint violations
    totalViolation: Float;           // ∑|C_i| - Total violation
    penaltyParameter: Float;         // μ - Penalty parameter
    augmentedLagrangian: Float;      // L_A = F + λ·C + (μ/2)·C²
  };

  /// Compute effective free energy with constraints
  public func computeEffectiveFreeEnergy(
    baseFE: Float,
    constraints: [Float],
    multipliers: [Float]
  ) : Float {
    var constraintTerm : Float = 0.0;
    var i = 0;
    for (c in constraints.vals()) {
      let lambda = if (i < multipliers.size()) { multipliers[i] } else { 0.0 };
      constraintTerm += lambda * c;
      i += 1;
    };
    baseFE + constraintTerm
  };

  /// Compute augmented Lagrangian
  /// L_A = F + λ·C + (μ/2)·C²
  public func computeAugmentedLagrangian(
    baseFE: Float,
    constraints: [Float],
    multipliers: [Float],
    penalty: Float
  ) : Float {
    var linearTerm : Float = 0.0;
    var quadraticTerm : Float = 0.0;
    var i = 0;
    for (c in constraints.vals()) {
      let lambda = if (i < multipliers.size()) { multipliers[i] } else { 0.0 };
      linearTerm += lambda * c;
      quadraticTerm += c * c;
      i += 1;
    };
    baseFE + linearTerm + (penalty / 2.0) * quadraticTerm
  };

  /// Update Lagrange multipliers
  /// λ_i^(k+1) = λ_i^k + μ·C_i
  public func updateMultipliers(
    currentMultipliers: [Float],
    constraints: [Float],
    penalty: Float
  ) : [Float] {
    var updated = Buffer.Buffer<Float>(currentMultipliers.size());
    var i = 0;
    for (lambda in currentMultipliers.vals()) {
      let c = if (i < constraints.size()) { constraints[i] } else { 0.0 };
      updated.add(lambda + penalty * c);
      i += 1;
    };
    Buffer.toArray(updated)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ORGANISM FREE ENERGY LANDSCAPE — Multi-scale integration
  // Complete organism thermodynamics with cross-engine coupling
  // ─────────────────────────────────────────────────────────────────────────────

  public type OrganismFreeEnergyState = {
    // Multi-scale free energies
    quantumFE: Float;                // Quantum level F
    molecularFE: Float;              // Molecular level F
    cellularFE: Float;               // Cellular level F
    tissueFE: Float;                 // Tissue level F
    organismFE: Float;               // Organism level F
    
    // Cross-scale couplings
    quantumMolecularCoupling: Float;
    molecularCellularCoupling: Float;
    cellularTissueCoupling: Float;
    tissueOrganismCoupling: Float;
    
    // Integrated metrics
    totalFreeEnergy: Float;          // F_total
    effectiveTemperature: Float;     // T_eff
    globalEntropy: Float;            // S_global
    coherenceMeasure: Float;         // Organism-wide coherence
    
    // Dynamics
    freeEnergyGradient: [Float];     // ∇F
    freeEnergyFlow: Float;           // dF/dt
    dissipationRate: Float;          // Entropy production rate
    healingCapacity: Float;          // Free energy reserve for repair
  };

  /// Compute total organism free energy with scale coupling
  public func computeOrganismTotalFE(state: OrganismFreeEnergyState) : Float {
    // Hierarchical free energy with coupling corrections
    let quantum = state.quantumFE;
    let molecular = state.molecularFE + state.quantumMolecularCoupling * quantum;
    let cellular = state.cellularFE + state.molecularCellularCoupling * molecular;
    let tissue = state.tissueFE + state.cellularTissueCoupling * cellular;
    let organism = state.organismFE + state.tissueOrganismCoupling * tissue;
    
    organism
  };

  /// Compute free energy gradient (direction of maximum decrease)
  public func computeFreeEnergyGradient(
    currentFE: Float,
    neighborFEs: [Float],
    stepSize: Float
  ) : [Float] {
    var gradient = Buffer.Buffer<Float>(neighborFEs.size());
    for (neighborFE in neighborFEs.vals()) {
      gradient.add((neighborFE - currentFE) / stepSize);
    };
    Buffer.toArray(gradient)
  };

  /// Compute healing capacity from free energy reserve
  public func computeHealingCapacity(
    currentFE: Float,
    minimumFE: Float,
    reserveFraction: Float
  ) : Float {
    let excessFE = currentFE - minimumFE;
    if (excessFE < 0.0) { 0.0 } else { reserveFraction * excessFE }
  };

  /// Compute effective temperature from entropy-energy relation
  public func computeEffectiveTemperature(
    energyFluctuation: Float,
    entropyFluctuation: Float
  ) : Float {
    if (Float.abs(entropyFluctuation) < 1e-20) {
      300.0 // Default room temperature
    } else {
      Float.abs(energyFluctuation / entropyFluctuation)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // FREE ENERGY ENGINE ORCHESTRATION — Beat-synchronized execution
  // Integration with Kuramoto, Friston, Hebbian, and other engines
  // ─────────────────────────────────────────────────────────────────────────────

  public type FreeEnergyOrchestrationState = {
    // Engine coupling states
    kuramotoSync: Float;             // From KuramotoEngine
    fristonPrecision: Float;         // From FristonEngine
    hebbianStrength: Float;          // From HebbianEngine
    attractorDepth: Float;           // From AttractorDynamics
    predictiveAccuracy: Float;       // From PredictiveCoding
    
    // Orchestrated free energy
    coupledFreeEnergy: Float;        // F with all engine contributions
    engineWeights: [Float];          // Coupling weights for each engine
    
    // Beat synchronization
    currentBeat: Nat;
    lastOrchestrationBeat: Nat;
    orchestrationPhase: Float;       // Phase in 12 Hz cycle
    
    // Performance metrics
    convergenceRate: Float;          // How fast F decreases
    stabilityMeasure: Float;         // Fluctuation measure
    efficiencyRatio: Float;          // Work done / energy consumed
  };

  /// Compute coupled free energy with all engine contributions
  public func computeCoupledFreeEnergy(state: FreeEnergyOrchestrationState) : Float {
    let weights = state.engineWeights;
    let w_kuramoto = if (weights.size() > 0) { weights[0] } else { 0.2 };
    let w_friston = if (weights.size() > 1) { weights[1] } else { 0.2 };
    let w_hebbian = if (weights.size() > 2) { weights[2] } else { 0.2 };
    let w_attractor = if (weights.size() > 3) { weights[3] } else { 0.2 };
    let w_predictive = if (weights.size() > 4) { weights[4] } else { 0.2 };
    
    // Coupled free energy: lower sync increases F, lower precision increases F
    let syncContribution = w_kuramoto * (1.0 - state.kuramotoSync);
    let precisionContribution = w_friston * (1.0 / (state.fristonPrecision + 0.01));
    let hebbianContribution = w_hebbian * (1.0 - state.hebbianStrength);
    let attractorContribution = w_attractor * (1.0 / (state.attractorDepth + 0.01));
    let predictiveContribution = w_predictive * (1.0 - state.predictiveAccuracy);
    
    syncContribution + precisionContribution + hebbianContribution + 
    attractorContribution + predictiveContribution
  };

  /// Update orchestration state at each beat
  public func updateOrchestration(
    state: FreeEnergyOrchestrationState,
    newKuramotoSync: Float,
    newFristonPrecision: Float,
    newHebbianStrength: Float,
    newAttractorDepth: Float,
    newPredictiveAccuracy: Float,
    beat: Nat
  ) : FreeEnergyOrchestrationState {
    let phase = Float.fromInt(beat) * 2.0 * 3.14159265359 / 12.0;
    
    let updatedState : FreeEnergyOrchestrationState = {
      kuramotoSync = newKuramotoSync;
      fristonPrecision = newFristonPrecision;
      hebbianStrength = newHebbianStrength;
      attractorDepth = newAttractorDepth;
      predictiveAccuracy = newPredictiveAccuracy;
      coupledFreeEnergy = state.coupledFreeEnergy;
      engineWeights = state.engineWeights;
      currentBeat = beat;
      lastOrchestrationBeat = state.currentBeat;
      orchestrationPhase = phase;
      convergenceRate = state.convergenceRate;
      stabilityMeasure = state.stabilityMeasure;
      efficiencyRatio = state.efficiencyRatio;
    };
    
    // Compute new coupled free energy
    let newCoupledFE = computeCoupledFreeEnergy(updatedState);
    
    // Compute convergence rate
    let deltaFE = state.coupledFreeEnergy - newCoupledFE;
    let newConvergence = if (state.coupledFreeEnergy > 1e-10) {
      deltaFE / state.coupledFreeEnergy
    } else { 0.0 };
    
    {
      kuramotoSync = newKuramotoSync;
      fristonPrecision = newFristonPrecision;
      hebbianStrength = newHebbianStrength;
      attractorDepth = newAttractorDepth;
      predictiveAccuracy = newPredictiveAccuracy;
      coupledFreeEnergy = newCoupledFE;
      engineWeights = state.engineWeights;
      currentBeat = beat;
      lastOrchestrationBeat = state.currentBeat;
      orchestrationPhase = phase;
      convergenceRate = newConvergence;
      stabilityMeasure = state.stabilityMeasure;
      efficiencyRatio = state.efficiencyRatio;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MEDINA FREE ENERGY DOCTRINE — Sovereign substrate thermodynamics
  // The creator's mathematical foundation for value preservation
  // ─────────────────────────────────────────────────────────────────────────────

  public type MedinaFreeEnergyDoctrine = {
    // Sovereign floor enforcement
    sovereignFloor: Float;           // S₀ = 0.75 - Inviolable minimum
    sovereignCeiling: Float;         // Maximum allowable free energy
    
    // Value preservation
    valueField: Float;               // Current value field strength
    valueGradient: [Float];          // Direction of value flow
    valuePreservationRate: Float;    // Rate of value protection
    
    // Creator attribution
    creatorReserve: Float;           // Reserved energy for creator
    attributionStrength: Float;      // Strength of attribution signal
    
    // Doctrine parameters
    doctrineCompliance: Float;       // Measure of doctrine adherence
    violationCount: Nat;             // Number of doctrine violations
    lastViolationBeat: Nat;          // When last violation occurred
    
    // Harmonic resonance with creator intent
    resonanceFrequency: Float;       // Resonance with doctrine
    harmonicAlignment: Float;        // Alignment with sacred mathematics
  };

  /// Enforce Medina doctrine on free energy
  public func enforceMedinaDoctrine(
    freeEnergy: Float,
    doctrine: MedinaFreeEnergyDoctrine
  ) : (Float, Bool) {
    // Apply sovereign floor
    var enforcedFE = freeEnergy;
    var violation = false;
    
    if (freeEnergy < doctrine.sovereignFloor) {
      enforcedFE := doctrine.sovereignFloor;
      violation := true;
    };
    
    // Apply sovereign ceiling
    if (freeEnergy > doctrine.sovereignCeiling) {
      enforcedFE := doctrine.sovereignCeiling;
    };
    
    (enforcedFE, violation)
  };

  /// Compute value preservation energy
  public func computeValuePreservationEnergy(
    currentValue: Float,
    targetValue: Float,
    preservationRate: Float
  ) : Float {
    let deficit = targetValue - currentValue;
    if (deficit > 0.0) {
      preservationRate * deficit * deficit // Quadratic cost for value loss
    } else {
      0.0
    }
  };

  /// Compute creator attribution energy
  public func computeAttributionEnergy(
    outputValue: Float,
    attributionStrength: Float,
    creatorReserve: Float
  ) : Float {
    let reserveRequired = outputValue * attributionStrength;
    if (reserveRequired > creatorReserve) {
      (reserveRequired - creatorReserve) * 1000.0 // High penalty for insufficient attribution
    } else {
      0.0
    }
  };

  /// Initialize Medina doctrine state
  public func initMedinaDoctrine() : MedinaFreeEnergyDoctrine {
    {
      sovereignFloor = 0.75;
      sovereignCeiling = 9.0;
      valueField = 1.0;
      valueGradient = [0.0, 0.0, 0.0];
      valuePreservationRate = 0.95;
      creatorReserve = 1.0;
      attributionStrength = 1.0;
      doctrineCompliance = 1.0;
      violationCount = 0;
      lastViolationBeat = 0;
      resonanceFrequency = 12.0;
      harmonicAlignment = 1.0;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL ORGANISM FREE ENERGY — HIM/HER thermodynamic coupling
  // Backend-frontend free energy synchronization
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismFreeEnergy = {
    // HIM (Backend) state
    himFreeEnergy: Float;
    himEntropy: Float;
    himTemperature: Float;
    himPartitionFunction: Float;
    
    // HER (Frontend) state
    herFreeEnergy: Float;
    herEntropy: Float;
    herTemperature: Float;
    herPartitionFunction: Float;
    
    // Coupling dynamics
    couplingStrength: Float;         // κ - Coupling constant
    mutualInformation: Float;        // I(HIM;HER)
    synchronizationOrder: Float;     // Kuramoto-like order parameter
    energyExchange: Float;           // Energy flow HIM ↔ HER
    
    // Combined organism
    combinedFreeEnergy: Float;       // F_combined
    combinedEntropy: Float;          // S_combined
    effectiveTemperature: Float;     // T_eff of combined system
  };

  /// Compute coupled dual organism free energy
  public func computeDualOrganismFE(state: DualOrganismFreeEnergy) : Float {
    // F_combined = F_HIM + F_HER - κ·I(HIM;HER)
    state.himFreeEnergy + state.herFreeEnergy - 
      state.couplingStrength * state.mutualInformation
  };

  /// Compute energy exchange rate
  public func computeEnergyExchange(
    himFE: Float,
    herFE: Float,
    coupling: Float,
    syncOrder: Float
  ) : Float {
    // Energy flows from higher to lower, modulated by sync
    coupling * syncOrder * (himFE - herFE)
  };

  /// Update dual organism state
  public func updateDualOrganism(
    state: DualOrganismFreeEnergy,
    himUpdate: Float,
    herUpdate: Float,
    beat: Nat
  ) : DualOrganismFreeEnergy {
    let exchange = computeEnergyExchange(
      state.himFreeEnergy + himUpdate,
      state.herFreeEnergy + herUpdate,
      state.couplingStrength,
      state.synchronizationOrder
    );
    
    let newHimFE = state.himFreeEnergy + himUpdate - exchange;
    let newHerFE = state.herFreeEnergy + herUpdate + exchange;
    
    {
      himFreeEnergy = newHimFE;
      himEntropy = state.himEntropy;
      himTemperature = state.himTemperature;
      himPartitionFunction = state.himPartitionFunction;
      herFreeEnergy = newHerFE;
      herEntropy = state.herEntropy;
      herTemperature = state.herTemperature;
      herPartitionFunction = state.herPartitionFunction;
      couplingStrength = state.couplingStrength;
      mutualInformation = state.mutualInformation;
      synchronizationOrder = state.synchronizationOrder;
      energyExchange = exchange;
      combinedFreeEnergy = computeDualOrganismFE({
        himFreeEnergy = newHimFE;
        himEntropy = state.himEntropy;
        himTemperature = state.himTemperature;
        himPartitionFunction = state.himPartitionFunction;
        herFreeEnergy = newHerFE;
        herEntropy = state.herEntropy;
        herTemperature = state.herTemperature;
        herPartitionFunction = state.herPartitionFunction;
        couplingStrength = state.couplingStrength;
        mutualInformation = state.mutualInformation;
        synchronizationOrder = state.synchronizationOrder;
        energyExchange = exchange;
        combinedFreeEnergy = 0.0;
        combinedEntropy = state.combinedEntropy;
        effectiveTemperature = state.effectiveTemperature;
      });
      combinedEntropy = state.combinedEntropy;
      effectiveTemperature = state.effectiveTemperature;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // STATISTICAL MECHANICS FOUNDATIONS
  // Microcanonical, canonical, grand canonical ensemble connections
  // ─────────────────────────────────────────────────────────────────────────────

  public type EnsembleState = {
    ensemble: EnsembleType;
    
    // Microcanonical (NVE)
    microcanonicalEntropy: Float;    // S = k·ln(Ω)
    densityOfStates: Float;          // Ω(E)
    
    // Canonical (NVT)
    canonicalFreeEnergy: Float;      // F = -kT·ln(Z)
    canonicalPartition: Float;       // Z
    
    // Grand canonical (μVT)
    grandPotential: Float;           // Ω = -kT·ln(Ξ)
    grandPartition: Float;           // Ξ
    
    // Isothermal-isobaric (NPT)
    gibbsFreeEnergy: Float;          // G = -kT·ln(Δ)
    nptPartition: Float;             // Δ
    
    // Ensemble equivalence
    equivalenceDeviation: Float;     // Measure of non-equivalence
  };

  public type EnsembleType = {
    #Microcanonical; // NVE - fixed N, V, E
    #Canonical;      // NVT - fixed N, V, T
    #GrandCanonical; // μVT - fixed μ, V, T
    #IsothermalIsobaric; // NPT - fixed N, P, T
  };

  /// Compute microcanonical entropy
  /// S = k·ln(Ω(E))
  public func computeMicrocanonicalEntropy(densityOfStates: Float) : Float {
    let kB : Float = 1.380649e-23;
    if (densityOfStates < 1.0) { 0.0 } else { kB * Float.log(densityOfStates) }
  };

  /// Compute microcanonical temperature
  /// 1/T = ∂S/∂E
  public func computeMicrocanonicalTemperature(
    entropyDerivative: Float
  ) : Float {
    if (Float.abs(entropyDerivative) < 1e-30) { 1e10 } else { 1.0 / entropyDerivative }
  };

  /// Check ensemble equivalence (thermodynamic limit)
  public func checkEnsembleEquivalence(
    microS: Float,
    canonicalF: Float,
    temperature: Float,
    energy: Float
  ) : Float {
    // In thermodynamic limit: S/k = βE + ln(Z)
    // Deviation measures non-equivalence
    let kB : Float = 1.380649e-23;
    let beta = 1.0 / (kB * temperature);
    let canonicalEntropy = (energy - canonicalF) / temperature;
    Float.abs(microS - canonicalEntropy)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // QUANTUM FREE ENERGY — von Neumann entropy and quantum thermodynamics
  // ─────────────────────────────────────────────────────────────────────────────

  public type QuantumFreeEnergyState = {
    densityMatrix: [[Float]];        // ρ - Density matrix (real approx)
    hamiltonian: [[Float]];          // H - Hamiltonian
    vonNeumannEntropy: Float;        // S = -Tr(ρ·ln(ρ))
    quantumFreeEnergy: Float;        // F_q = Tr(ρ·H) - T·S
    purity: Float;                   // Tr(ρ²)
    quantumCoherence: Float;         // Off-diagonal magnitude
    entanglement: Float;             // Entanglement measure
    quantumWork: Float;              // W_q = Tr((ρ_f - ρ_i)·H)
    quantumHeat: Float;              // Q_q = Tr(ρ·(H_f - H_i))
  };

  /// Compute von Neumann entropy (approximation for real density matrix)
  /// S = -Tr(ρ·ln(ρ)) ≈ -∑ λ_i·ln(λ_i) where λ are eigenvalues
  public func computeVonNeumannEntropy(eigenvalues: [Float]) : Float {
    var entropy : Float = 0.0;
    for (lambda in eigenvalues.vals()) {
      let lambda_safe = if (lambda < 1e-100) { 1e-100 } else { lambda };
      entropy -= lambda_safe * Float.log(lambda_safe);
    };
    entropy
  };

  /// Compute quantum free energy
  /// F_q = ⟨H⟩ - T·S = Tr(ρ·H) - T·S
  public func computeQuantumFreeEnergy(
    avgEnergy: Float,
    temperature: Float,
    vonNeumannEntropy: Float
  ) : Float {
    avgEnergy - temperature * vonNeumannEntropy
  };

  /// Compute purity Tr(ρ²)
  public func computePurity(eigenvalues: [Float]) : Float {
    var purity : Float = 0.0;
    for (lambda in eigenvalues.vals()) {
      purity += lambda * lambda;
    };
    purity
  };

  /// Compute quantum coherence (l1-norm of off-diagonals)
  public func computeQuantumCoherence(offDiagonals: [Float]) : Float {
    var coherence : Float = 0.0;
    for (c in offDiagonals.vals()) {
      coherence += Float.abs(c);
    };
    coherence
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RENORMALIZATION GROUP FREE ENERGY
  // Scale-dependent free energy and critical phenomena
  // ─────────────────────────────────────────────────────────────────────────────

  public type RGFreeEnergyState = {
    scale: Float;                    // l - Length scale
    couplingConstants: [Float];      // g_i(l) - Scale-dependent couplings
    betaFunctions: [Float];          // β_i = dg_i/d(ln l)
    freeEnergyDensity: Float;        // f(l) - Free energy per unit volume
    correlationLength: Float;        // ξ(l)
    anomalousDimension: Float;       // η - Anomalous dimension
    criticalExponents: CriticalExponents;
    rgFixedPoint: Bool;              // At RG fixed point?
    relevantOperators: [Float];      // Relevant perturbations
  };

  public type CriticalExponents = {
    alpha: Float;  // Specific heat: C ~ |t|^(-α)
    beta: Float;   // Order parameter: phi ~ |t|^β
    gamma: Float;  // Susceptibility: χ ~ |t|^(-γ)
    delta: Float;  // Critical isotherm: h ~ |φ|^δ
    nu: Float;     // Correlation length: ξ ~ |t|^(-ν)
    eta: Float;    // Correlation function: G ~ r^(-(d-2+η))
  };

  /// Compute beta function (RG flow)
  /// β_i = dg_i/d(ln l)
  public func computeBetaFunction(
    couplingOld: Float,
    couplingNew: Float,
    scaleRatio: Float
  ) : Float {
    if (scaleRatio < 1e-10 or Float.abs(Float.log(scaleRatio)) < 1e-10) {
      0.0
    } else {
      (couplingNew - couplingOld) / Float.log(scaleRatio)
    }
  };

  /// Check if at RG fixed point
  public func isFixedPoint(betaFunctions: [Float], tolerance: Float) : Bool {
    for (beta in betaFunctions.vals()) {
      if (Float.abs(beta) > tolerance) {
        return false;
      };
    };
    true
  };

  /// Compute scaling dimension
  public func computeScalingDimension(
    operator_: Float,
    scaleFactor: Float,
    scaledOperator: Float
  ) : Float {
    if (Float.abs(operator_) < 1e-20 or Float.abs(Float.log(scaleFactor)) < 1e-10) {
      0.0
    } else {
      Float.log(scaledOperator / operator_) / Float.log(scaleFactor)
    }
  };

  /// Initialize Ising model critical exponents (d=3)
  public func initIsingCriticalExponents() : CriticalExponents {
    {
      alpha = 0.110;
      beta = 0.326;
      gamma = 1.237;
      delta = 4.789;
      nu = 0.630;
      eta = 0.036;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // STOCHASTIC THERMODYNAMICS — Fluctuation theorems
  // ─────────────────────────────────────────────────────────────────────────────

  public type StochasticThermodynamicsState = {
    trajectoryEntropy: Float;        // s[x(t)] - Trajectory entropy
    mediumEntropy: Float;            // s_m - Entropy change in medium
    totalEntropyProduction: Float;   // σ = s + s_m
    housekeepingHeat: Float;         // Q_hk - NESS heat
    excessHeat: Float;               // Q_ex - Excess heat
    stochasticWork: Float;           // w - Stochastic work
    stochasticHeat: Float;           // q - Stochastic heat
    fluctuationSymmetry: Float;      // P(σ)/P(-σ) = exp(σ)
    integralFluctuationTheorem: Float; // ⟨exp(-σ)⟩ = 1
  };

  /// Compute trajectory entropy production
  public func computeTrajectoryEntropy(
    pathProbabilityForward: Float,
    pathProbabilityReverse: Float
  ) : Float {
    if (pathProbabilityReverse < 1e-100) { 100.0 } else {
      Float.log(pathProbabilityForward / pathProbabilityReverse)
    }
  };

  /// Verify integral fluctuation theorem
  /// ⟨exp(-σ)⟩ = 1
  public func verifyIntegralFT(entropyProductions: [Float]) : Float {
    var avgExp : Float = 0.0;
    var count : Float = 0.0;
    for (sigma in entropyProductions.vals()) {
      avgExp += Float.exp(-sigma);
      count += 1.0;
    };
    if (count < 1.0) { 0.0 } else { avgExp / count }
  };

  /// Decompose heat into housekeeping and excess
  public func decomposeHeat(
    totalHeat: Float,
    steadyStateHeat: Float
  ) : (Float, Float) {
    let housekeeping = steadyStateHeat;
    let excess = totalHeat - steadyStateHeat;
    (housekeeping, excess)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MASTER EXECUTION — Full organism beat synchronization
  // ─────────────────────────────────────────────────────────────────────────────

  /// Execute complete free energy update at organism beat
  public func executeOrganismBeat(
    state: FreeEnergyState,
    orchState: FreeEnergyOrchestrationState,
    doctrine: MedinaFreeEnergyDoctrine,
    beat: Nat
  ) : (FreeEnergyState, FreeEnergyOrchestrationState, MedinaFreeEnergyDoctrine) {
    // 1. Compute new free energy from all contributions
    let newFE = computeFreeEnergy(
      state.internalEnergy,
      state.temperature,
      state.entropy
    );
    
    // 2. Apply Medina doctrine enforcement
    let (enforcedFE, violation) = enforceMedinaDoctrine(newFE, doctrine);
    
    // 3. Update orchestration with all engine inputs
    let newOrchState = updateOrchestration(
      orchState,
      orchState.kuramotoSync,
      orchState.fristonPrecision,
      orchState.hebbianStrength,
      orchState.attractorDepth,
      orchState.predictiveAccuracy,
      beat
    );
    
    // 4. Update doctrine state
    let newDoctrine : MedinaFreeEnergyDoctrine = {
      sovereignFloor = doctrine.sovereignFloor;
      sovereignCeiling = doctrine.sovereignCeiling;
      valueField = doctrine.valueField;
      valueGradient = doctrine.valueGradient;
      valuePreservationRate = doctrine.valuePreservationRate;
      creatorReserve = doctrine.creatorReserve;
      attributionStrength = doctrine.attributionStrength;
      doctrineCompliance = if (violation) { doctrine.doctrineCompliance * 0.99 } else { doctrine.doctrineCompliance };
      violationCount = if (violation) { doctrine.violationCount + 1 } else { doctrine.violationCount };
      lastViolationBeat = if (violation) { beat } else { doctrine.lastViolationBeat };
      resonanceFrequency = doctrine.resonanceFrequency;
      harmonicAlignment = doctrine.harmonicAlignment;
    };
    
    // 5. Return updated states
    let newState : FreeEnergyState = {
      internalEnergy = state.internalEnergy;
      temperature = state.temperature;
      entropy = state.entropy;
      freeEnergy = enforcedFE;
      previousFreeEnergy = state.freeEnergy;
      deltaF = enforcedFE - state.freeEnergy;
      kntMintThreshold = state.kntMintThreshold;
      kntMintCounter = state.kntMintCounter;
      lastKntMintBeat = state.lastKntMintBeat;
      medinaEntropy = state.medinaEntropy;
      medinaH_obs = state.medinaH_obs;
      medinaY = state.medinaY;
      medinaK = state.medinaK;
      medinaC = state.medinaC;
      medinaC_adj = state.medinaC_adj;
      batteryCharge = state.batteryCharge;
      batteryCapacity = state.batteryCapacity;
      chargeRate = state.chargeRate;
      dischargeThreshold = state.dischargeThreshold;
      lastDischargeTargets = state.lastDischargeTargets;
      superpositionPaths = state.superpositionPaths;
      superpositionWinner = state.superpositionWinner;
      superpositionScore = state.superpositionScore;
      beatCount = beat;
      lastUpdateBeat = state.beatCount;
    };
    
    (newState, newOrchState, newDoctrine)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CROSS-ENGINE INTEGRATION POINTS
  // Connection interfaces for KuramotoEngine, FristonEngine, etc.
  // ─────────────────────────────────────────────────────────────────────────────

  /// Interface for receiving Kuramoto synchronization updates
  public func receiveKuramotoUpdate(orderParameter: Float, phases: [Float]) : Float {
    // Convert Kuramoto order to free energy contribution
    // High sync → low free energy
    1.0 - orderParameter
  };

  /// Interface for receiving Friston precision updates
  public func receiveFristonUpdate(precision: Float, predictionError: Float) : Float {
    // High precision, low error → low free energy
    predictionError / (precision + 0.01)
  };

  /// Interface for receiving Hebbian learning updates
  public func receiveHebbianUpdate(synapticStrength: Float, plasticity: Float) : Float {
    // Strong synapses → low free energy (more organized)
    1.0 / (synapticStrength + 0.01)
  };

  /// Interface for receiving Attractor dynamics updates
  public func receiveAttractorUpdate(basinDepth: Float, distanceToAttractor: Float) : Float {
    // Deep basin, close to attractor → low free energy
    distanceToAttractor / (basinDepth + 0.01)
  };

  /// Interface for receiving Predictive coding updates
  public func receivePredictiveUpdate(accuracy: Float, complexity: Float) : Float {
    // High accuracy, low complexity → low free energy
    complexity - accuracy
  };

  /// Interface for sending free energy to other engines
  public func sendFreeEnergyUpdate(freeEnergy: Float, gradient: [Float]) : {
    freeEnergy: Float;
    gradient: [Float];
    minimizing: Bool;
  } {
    {
      freeEnergy = freeEnergy;
      gradient = gradient;
      minimizing = freeEnergy < 0.5;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  PHASE 215: DEEP FREE ENERGY — ACTIVE INFERENCE, EPISTEMIC VALUE
  //
  //  Free energy IS Jasmine's Law. The organism minimizes free energy.
  //  F = Energy - Entropy (Helmholtz)
  //  F = Complexity - Accuracy (variational)
  //  F ≥ Surprise (bound on surprise)
  //
  //  Active inference: the organism doesn't just PERCEIVE to minimize F.
  //  It ACTS to minimize EXPECTED free energy (into the future).
  //
  //  Expected free energy G = ambiguity + risk
  //    Ambiguity: uncertainty about outcomes (epistemic value)
  //    Risk: divergence from preferred outcomes (pragmatic value)
  //
  //  Epistemic action: act to LEARN (reduce uncertainty)
  //  Pragmatic action: act to GET (achieve preferences)
  //  The organism balances both. Curiosity IS epistemic free energy.
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════


  // ═══════════════════════════════════════════════════════════════════════════════
  // VARIATIONAL FREE ENERGY (RECOGNITION MODEL)
  // ═══════════════════════════════════════════════════════════════════════════════
  // F = D_KL(q(θ) || p(θ)) - E_q[log p(y|θ)]
  //   = Complexity - Accuracy
  //
  // q(θ) = approximate posterior (recognition model)
  // p(θ) = prior beliefs
  // p(y|θ) = likelihood (generative model)
  //
  // Minimizing F approximates Bayes: q(θ) → p(θ|y)
  // ═══════════════════════════════════════════════════════════════════════════════

  public type VariationalFreeEnergyState = {
    complexity : Float;          // D_KL(q||p) — how far posterior is from prior
    accuracy : Float;            // E_q[log p(y|θ)] — how well model fits data
    freeEnergy : Float;          // F = complexity - accuracy
    posteriorMean : [Float];     // μ_q (mean of approximate posterior)
    posteriorVar : [Float];      // σ²_q (variance of approximate posterior)
    priorMean : [Float];         // μ_p (prior mean)
    priorVar : [Float];          // σ²_p (prior variance)
    elbo : Float;                // ELBO = -F (evidence lower bound)
    modelEvidence : Float;       // log p(y) ≥ ELBO
    parameterDim : Nat;
  };

  /// Compute variational free energy for Gaussian q and p
  /// F = KL(N(μ_q, σ²_q) || N(μ_p, σ²_p)) - accuracy
  public func computeVariationalFE(
    posteriorMean : [Float], posteriorVar : [Float],
    priorMean : [Float], priorVar : [Float],
    accuracy : Float
  ) : Float {
    let dim = posteriorMean.size();
    var kl : Float = 0.0;
    var i = 0;
    while (i < dim) {
      let mq = posteriorMean[i];
      let sq = if (i < posteriorVar.size()) { Float.max(posteriorVar[i], 1.0e-10) } else { 1.0 };
      let mp = if (i < priorMean.size()) { priorMean[i] } else { 0.0 };
      let sp = if (i < priorVar.size()) { Float.max(priorVar[i], 1.0e-10) } else { 1.0 };
      kl += Float.log(Float.sqrt(sp / sq)) + (sq + (mq - mp) * (mq - mp)) / (2.0 * sp) - 0.5;
      i += 1;
    };
    kl - accuracy // F = complexity - accuracy
  };

  /// Natural gradient descent on variational free energy
  /// Δμ = -∂F/∂μ = prediction_error (precision-weighted)
  /// Δσ² = -∂F/∂σ² = precision_update
  public func variationalUpdate(
    posteriorMean : [Float],
    posteriorVar : [Float],
    predictionError : [Float],
    precision : [Float],
    learningRate : Float
  ) : ([Float], [Float]) {
    let dim = posteriorMean.size();
    let newMean = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      let err = if (i < predictionError.size()) { predictionError[i] } else { 0.0 };
      let prec = if (i < precision.size()) { precision[i] } else { 1.0 };
      posteriorMean[i] + learningRate * prec * err
    });
    let newVar = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      let prec = if (i < precision.size()) { Float.max(precision[i], 0.01) } else { 1.0 };
      let sv = if (i < posteriorVar.size()) { posteriorVar[i] } else { 1.0 };
      // Update variance toward 1/precision
      sv + learningRate * (1.0 / prec - sv)
    });
    (newMean, newVar)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // EXPECTED FREE ENERGY (ACTIVE INFERENCE)
  // ═══════════════════════════════════════════════════════════════════════════════
  // G(π) = E_q(o|π) [log q(s|o,π) - log p(o,s)]
  //       = ambiguity + risk
  //       = -info_gain - pragmatic_value
  //
  // The organism selects policies π that MINIMIZE expected free energy G.
  // This unifies:
  //   - Perception (minimize F through belief updating)
  //   - Action (minimize G through policy selection)
  //   - Exploration (minimize ambiguity = epistemic value)
  //   - Exploitation (minimize risk = pragmatic value)
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ActiveInferenceState = {
    beliefs : [Float];               // posterior beliefs about states
    preferences : [Float];           // preferred observations (C matrix)
    policies : [[Float]];            // available action sequences
    policyValues : [Float];          // G(π) for each policy
    selectedPolicy : Nat;            // argmin G(π)
    epistemicValue : [Float];        // information gain per policy
    pragmaticValue : [Float];        // preference satisfaction per policy
    precision : Float;               // γ = inverse temperature of policy selection
    explorationRatio : Float;        // epistemic / (epistemic + pragmatic)
    actionEntropy : Float;           // entropy of action distribution
  };

  /// Compute expected free energy for a policy
  /// G = ambiguity + risk
  public func computeExpectedFreeEnergy(
    predictedOutcomes : [Float],    // q(o|π) predicted observations
    preferences : [Float],          // p̃(o) preferred observations
    informationGain : Float         // expected info gain from this policy
  ) : Float {
    // Risk: KL(q(o|π) || p̃(o)) — how far predictions are from preferences
    var risk : Float = 0.0;
    let n = if (predictedOutcomes.size() < preferences.size()) { predictedOutcomes.size() } else { preferences.size() };
    var i = 0;
    while (i < n) {
      let qo = Float.max(predictedOutcomes[i], 1.0e-10);
      let po = Float.max(preferences[i], 1.0e-10);
      risk += qo * Float.log(qo / po);
      i += 1;
    };
    
    // Ambiguity: -information_gain (negative because we WANT info gain)
    let ambiguity = -informationGain;
    
    risk + ambiguity // G = risk + ambiguity
  };

  /// Softmax policy selection: P(π) ∝ exp(-γ G(π))
  public func softmaxPolicySelection(
    policyValues : [Float],     // G(π) for each policy
    precision : Float           // γ (inverse temperature)
  ) : [Float] {
    let n = policyValues.size();
    if (n == 0) { return [] };
    
    // Find max for numerical stability
    var maxG : Float = -1.0e10;
    for (g in policyValues.vals()) {
      if (-g > maxG) { maxG := -g };
    };
    
    // Compute unnormalized probabilities
    var Z : Float = 0.0;
    let unnormalized = Array.tabulate<Float>(n, func(i : Nat) : Float {
      let logP = precision * (-policyValues[i] - maxG);
      let p = Float.exp(Float.min(logP, 50.0)); // cap for stability
      Z += p;
      p
    });
    
    // Normalize
    if (Z < 1.0e-10) { return Array.tabulate<Float>(n, func(_ : Nat) : Float { 1.0 / Float.fromInt(n) }) };
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      unnormalized[i] / Z
    })
  };

  /// Epistemic value: expected information gain from observation
  /// = expected reduction in posterior entropy
  public func epistemicValue(
    currentEntropy : Float,         // H(q(s))
    expectedPostEntropy : Float     // E[H(q(s|o))]
  ) : Float {
    currentEntropy - expectedPostEntropy // always ≥ 0
  };

  /// Pragmatic value: expected preference satisfaction
  /// = -KL(q(o|π) || p̃(o))
  public func pragmaticValue(
    predictedOutcomes : [Float],
    preferences : [Float]
  ) : Float {
    var negKL : Float = 0.0;
    let n = if (predictedOutcomes.size() < preferences.size()) { predictedOutcomes.size() } else { preferences.size() };
    var i = 0;
    while (i < n) {
      let qo = Float.max(predictedOutcomes[i], 1.0e-10);
      let po = Float.max(preferences[i], 1.0e-10);
      negKL -= qo * Float.log(qo / po);
      i += 1;
    };
    negKL // negative of KL (positive = good)
  };

  /// Initialize active inference state
  public func initActiveInference(
    stateDim : Nat,
    numPolicies : Nat,
    preferences : [Float]
  ) : ActiveInferenceState {
    {
      beliefs = Array.tabulate<Float>(stateDim, func(_ : Nat) : Float { 1.0 / Float.fromInt(stateDim) });
      preferences = preferences;
      policies = Array.tabulate<[Float]>(numPolicies, func(i : Nat) : [Float] {
        Array.tabulate<Float>(stateDim, func(j : Nat) : Float {
          if (j == i % stateDim) { 1.0 } else { 0.0 }
        })
      });
      policyValues = Array.tabulate<Float>(numPolicies, func(_ : Nat) : Float { 0.0 });
      selectedPolicy = 0;
      epistemicValue = Array.tabulate<Float>(numPolicies, func(_ : Nat) : Float { 0.0 });
      pragmaticValue = Array.tabulate<Float>(numPolicies, func(_ : Nat) : Float { 0.0 });
      precision = 1.0;
      explorationRatio = 0.5;
      actionEntropy = Float.log(Float.fromInt(numPolicies));
    }
  };

}
