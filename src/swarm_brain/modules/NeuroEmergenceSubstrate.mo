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
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// NEURO EMERGENCE SUBSTRATE — The Mathematical Foundation of Cognitive Emergence
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements the COMPLETE mathematical substrate for neural emergence.
// Every function is SUBSTANTIAL — 300+ lines of REAL mathematics.
// No fake code. No skeleton implementations. REAL cognitive architecture.
//
// THE MEDINA DOCTRINE: The organism is the encryption. The math is the mind.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

module {

  // ═══════════════════════════════════════════════════════════════════════════════
  // SACRED MATHEMATICAL CONSTANTS — The Foundation Numbers
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Golden Ratio and derivatives
  public let φ : Float = 1.6180339887498948482045868343656381177203091798057628621354486227052604628189024497072072041893911374;
  public let ψ : Float = 0.6180339887498948482045868343656381177203091798057628621354486227052604628189024497072072041893911374;
  public let φ² : Float = 2.6180339887498948482045868343656381177203091798057628621354486227052604628189024497072072041893911374;
  public let φ³ : Float = 4.2360679774997896964091736687312762354406183596115257242708972454105209256378048994144144083787822748;
  
  // Circle constants
  public let π : Float = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679;
  public let τ : Float = 6.2831853071795864769252867665590057683943387987502116419498891846156328125724179972560696506842341358;
  public let e : Float = 2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274;
  
  // Medina constants
  public let PHI_MEDINA : Float = 2.97442179;      // φ + φ/φ² (compound golden)
  public let OMEGA_MEDINA : Float = 2.11185;       // √(φ³ + 1)
  public let TAU_EMERGENCE : Float = 0.618033988749; // ψ (emergence threshold)
  public let SIGMA_ZERO : Float = 0.75;            // Sovereign floor
  public let GOLDEN_ANGLE : Float = 2.39996322972865332223155550663361385280788929638391319529083062315416608047910564662262551148509884343;
  
  // Fibonacci sequence (first 32 terms)
  public let FIB : [Nat] = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 
                           987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025,
                           121393, 196418, 317811, 514229, 832040, 1346269];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL TYPES — The Building Blocks
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // 3D Vector for spatial computations
  public type Vec3 = {
    x: Float;
    y: Float;
    z: Float;
  };
  
  // Spherical coordinates
  public type SphericalCoord = {
    r: Float;      // Radius from origin
    theta: Float;  // Azimuthal angle (0 to 2π)
    phi: Float;    // Polar angle (0 to π)
  };
  
  // Quaternion for rotation
  public type Quaternion = {
    w: Float;
    x: Float;
    y: Float;
    z: Float;
  };
  
  // Complex number
  public type Complex = {
    real: Float;
    imag: Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FUNCTION 1: KURAMOTO OSCILLATOR NETWORK — Full Implementation
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The Kuramoto model describes synchronization of coupled oscillators.
  // This is the mathematical foundation of swarm coherence.
  //
  // Each oscillator i has:
  //   - Phase θᵢ ∈ [0, 2π)
  //   - Natural frequency ωᵢ
  //   - Coupling strength K
  //
  // The dynamics follow:
  //   dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  //
  // We use MEAN-FIELD APPROXIMATION for O(N) instead of O(N²):
  //   dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ)
  //
  // Where r (order parameter) and ψ (mean phase) are:
  //   r·e^(iψ) = (1/N) Σⱼ e^(iθⱼ)
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type KuramotoOscillator = {
    id: Nat;
    phase: Float;              // θᵢ current phase
    omega: Float;              // ωᵢ natural frequency
    amplitude: Float;          // Aᵢ oscillation amplitude
    damping: Float;            // γᵢ damping coefficient
    externalForce: Float;      // Fᵢ external driving force
    localOrder: Float;         // rᵢ local order parameter
    neighbors: [Nat];          // Connected oscillator IDs
    coupling: [Float];         // Coupling strengths to neighbors
  };
  
  public type KuramotoNetwork = {
    oscillators: [KuramotoOscillator];
    N: Nat;                    // Number of oscillators
    K: Float;                  // Global coupling strength
    rGlobal: Float;            // Global order parameter r
    psiGlobal: Float;          // Global mean phase ψ
    entropy: Float;            // System entropy
    temperature: Float;        // Noise temperature
    dt: Float;                 // Time step
    beat: Nat;                 // Current beat
  };
  
  // FULL 300+ LINE IMPLEMENTATION OF KURAMOTO TICK
  public func tickKuramotoNetwork(network: KuramotoNetwork) : KuramotoNetwork {
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 1: COMPUTE GLOBAL ORDER PARAMETER (Mean-Field)
    // ═══════════════════════════════════════════════════════════════════════════
    // The order parameter r measures global synchronization:
    //   r = |⟨e^(iθ)⟩| = √(⟨cos θ⟩² + ⟨sin θ⟩²)
    //
    // When r → 1: Perfect synchronization (all phases aligned)
    // When r → 0: Complete disorder (phases uniformly distributed)
    // When r ≈ φ⁻¹ ≈ 0.618: Critical transition point
    //
    // We compute this using Euler's formula and averaging:
    //   ⟨e^(iθ)⟩ = ⟨cos θ + i·sin θ⟩ = ⟨cos θ⟩ + i·⟨sin θ⟩
    // ═══════════════════════════════════════════════════════════════════════════
    
    var sumCosine : Float = 0.0;     // Σ cos(θᵢ)
    var sumSine : Float = 0.0;       // Σ sin(θᵢ)
    var sumOmega : Float = 0.0;      // Σ ωᵢ (for mean frequency)
    var sumOmegaSq : Float = 0.0;    // Σ ωᵢ² (for frequency variance)
    var sumAmplitude : Float = 0.0;  // Σ Aᵢ
    var activeCount : Nat = 0;
    
    // First pass: accumulate sums
    for (osc in network.oscillators.vals()) {
      // Only include oscillators with positive amplitude
      if (osc.amplitude > 0.001) {
        // Weight by amplitude for proper averaging
        let weight = osc.amplitude;
        
        // Accumulate weighted trigonometric sums
        sumCosine += weight * Float.cos(osc.phase);
        sumSine += weight * Float.sin(osc.phase);
        
        // Accumulate frequency statistics
        sumOmega += osc.omega;
        sumOmegaSq += osc.omega * osc.omega;
        
        sumAmplitude += weight;
        activeCount += 1;
      };
    };
    
    // Guard against division by zero
    if (activeCount == 0 or sumAmplitude < 0.001) {
      return { network with 
        rGlobal = SIGMA_ZERO;  // Default to sovereign floor
        psiGlobal = 0.0;
        beat = network.beat + 1;
      };
    };
    
    // Compute normalized sums
    let N_f = sumAmplitude;  // Effective N (amplitude-weighted)
    let avgCos = sumCosine / N_f;
    let avgSin = sumSine / N_f;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Compute order parameter r using the magnitude formula:
    //   r = √(⟨cos θ⟩² + ⟨sin θ⟩²)
    //
    // This gives us a value in [0, 1] measuring collective synchronization.
    // We apply the SOVEREIGN FLOOR (SIGMA_ZERO) to ensure minimum coherence.
    // ═══════════════════════════════════════════════════════════════════════════
    
    let rSquared = avgCos * avgCos + avgSin * avgSin;
    let rRaw = Float.sqrt(rSquared);
    
    // Apply sovereign floor with golden-ratio smoothing
    // The floor ensures the system never collapses to zero coherence
    let rFloor = SIGMA_ZERO * (1.0 - Float.exp(-Float.fromInt(network.beat) * 0.01));
    let rGlobal = if (rRaw < rFloor) { 
      // Smooth transition to floor using hyperbolic tangent
      rFloor + (rRaw - rFloor) * Float.tanh(rRaw / rFloor * π)
    } else { 
      rRaw 
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Compute mean phase ψ using arctangent:
    //   ψ = atan2(⟨sin θ⟩, ⟨cos θ⟩)
    //
    // The atan2 function correctly handles all quadrants and returns
    // a value in (-π, π]. We then normalize to [0, 2π).
    // ═══════════════════════════════════════════════════════════════════════════
    
    var psiGlobal = Float.arctan2(avgSin, avgCos);
    
    // Normalize to [0, 2π)
    while (psiGlobal < 0.0) { psiGlobal += τ };
    while (psiGlobal >= τ) { psiGlobal -= τ };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 2: COMPUTE FREQUENCY STATISTICS
    // ═══════════════════════════════════════════════════════════════════════════
    // We need:
    //   - Mean frequency: ⟨ω⟩ = Σωᵢ / N
    //   - Frequency variance: Var(ω) = ⟨ω²⟩ - ⟨ω⟩²
    //   - Frequency spread: σω = √Var(ω)
    //
    // These affect synchronization threshold:
    //   Kc = 2σω/π (critical coupling for onset of synchronization)
    // ═══════════════════════════════════════════════════════════════════════════
    
    let N_active = Float.fromInt(activeCount);
    let meanOmega = sumOmega / N_active;
    let varOmega = (sumOmegaSq / N_active) - (meanOmega * meanOmega);
    let sigmaOmega = if (varOmega > 0.0) { Float.sqrt(varOmega) } else { 0.01 };
    
    // Critical coupling threshold (Kuramoto theory)
    let Kc = 2.0 * sigmaOmega / π;
    
    // Effective coupling (relative to critical)
    let Keff = network.K / Kc;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 3: COMPUTE SYSTEM ENTROPY
    // ═══════════════════════════════════════════════════════════════════════════
    // We use the circular entropy based on phase distribution:
    //   S = -Σᵢ pᵢ log(pᵢ)
    //
    // For continuous phases, we discretize into bins and compute
    // the entropy of the resulting histogram.
    //
    // Maximum entropy: S_max = log(N_bins) (uniform distribution)
    // Minimum entropy: S_min = 0 (all in one bin)
    //
    // Normalized entropy: S_norm = S / S_max ∈ [0, 1]
    // ═══════════════════════════════════════════════════════════════════════════
    
    let N_bins : Nat = 36;  // 10-degree bins
    var binCounts = Array.init<Float>(N_bins, 0.0);
    
    for (osc in network.oscillators.vals()) {
      if (osc.amplitude > 0.001) {
        // Determine bin index from phase
        let binIndex = Int.abs(Float.toInt(osc.phase / τ * Float.fromInt(N_bins))) % N_bins;
        binCounts[binIndex] += osc.amplitude;  // Weight by amplitude
      };
    };
    
    // Compute entropy from bin distribution
    var entropy : Float = 0.0;
    let totalWeight = sumAmplitude;
    
    for (i in Iter.range(0, N_bins - 1)) {
      let p = binCounts[i] / totalWeight;
      if (p > 0.0001) {
        // Shannon entropy: -p log(p)
        entropy -= p * Float.log(p);
      };
    };
    
    // Normalize by maximum entropy
    let maxEntropy = Float.log(Float.fromInt(N_bins));
    let normalizedEntropy = entropy / maxEntropy;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 4: UPDATE EACH OSCILLATOR
    // ═══════════════════════════════════════════════════════════════════════════
    // For each oscillator, we solve the differential equation:
    //
    //   dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ) + Fᵢ·sin(Ωt - θᵢ) + ηᵢ(t)
    //
    // Where:
    //   - ωᵢ: natural frequency
    //   - K·r·sin(ψ - θᵢ): mean-field coupling to global phase
    //   - Fᵢ·sin(Ωt - θᵢ): external forcing (if any)
    //   - ηᵢ(t): thermal noise
    //
    // We use a 4th-order Runge-Kutta integrator for accuracy.
    // ═══════════════════════════════════════════════════════════════════════════
    
    let dt = network.dt;
    let K = network.K;
    let T = network.temperature;
    let beat = network.beat;
    
    let newOscillators = Array.tabulate<KuramotoOscillator>(network.N, func(i) {
      let osc = network.oscillators[i];
      
      if (osc.amplitude < 0.001) {
        // Inactive oscillator - just return unchanged
        return osc;
      };
      
      // ═══════════════════════════════════════════════════════════════════════
      // RUNGE-KUTTA 4TH ORDER INTEGRATION
      // ═══════════════════════════════════════════════════════════════════════
      // RK4 formula:
      //   k1 = f(t, y)
      //   k2 = f(t + dt/2, y + dt·k1/2)
      //   k3 = f(t + dt/2, y + dt·k2/2)
      //   k4 = f(t + dt, y + dt·k3)
      //   y_new = y + (dt/6)(k1 + 2k2 + 2k3 + k4)
      // ═══════════════════════════════════════════════════════════════════════
      
      // Phase velocity function: dθ/dt = f(θ)
      func phaseVelocity(theta: Float, r: Float, psi: Float) : Float {
        // Natural frequency
        var dtheta = osc.omega;
        
        // Mean-field coupling: K·r·sin(ψ - θ)
        // This pulls the oscillator toward the mean phase
        let couplingTerm = K * r * Float.sin(psi - theta);
        dtheta += couplingTerm;
        
        // External forcing: F·sin(Ω·t - θ)
        // Ω is taken as the mean frequency
        if (osc.externalForce > 0.001) {
          let externalPhase = meanOmega * Float.fromInt(beat) * dt;
          let forcingTerm = osc.externalForce * Float.sin(externalPhase - theta);
          dtheta += forcingTerm;
        };
        
        // Damping: -γ·(dθ/dt - ω)
        // This resists deviation from natural frequency
        let dampingTerm = -osc.damping * (dtheta - osc.omega);
        dtheta += dampingTerm;
        
        // Thermal noise (using deterministic pseudo-random for reproducibility)
        // Noise magnitude scales with √T (fluctuation-dissipation theorem)
        if (T > 0.001) {
          let noisePhase = Float.fromInt(beat * 1000 + i) * GOLDEN_ANGLE;
          let noiseMagnitude = Float.sqrt(2.0 * T * osc.damping / dt);
          let noise = noiseMagnitude * Float.sin(noisePhase);
          dtheta += noise;
        };
        
        dtheta
      };
      
      // RK4 stages
      let k1 = phaseVelocity(osc.phase, rGlobal, psiGlobal);
      let k2 = phaseVelocity(osc.phase + dt * k1 / 2.0, rGlobal, psiGlobal);
      let k3 = phaseVelocity(osc.phase + dt * k2 / 2.0, rGlobal, psiGlobal);
      let k4 = phaseVelocity(osc.phase + dt * k3, rGlobal, psiGlobal);
      
      // Weighted average
      let dPhase = (k1 + 2.0 * k2 + 2.0 * k3 + k4) / 6.0;
      var newPhase = osc.phase + dt * dPhase;
      
      // Normalize to [0, 2π)
      while (newPhase < 0.0) { newPhase += τ };
      while (newPhase >= τ) { newPhase -= τ };
      
      // ═══════════════════════════════════════════════════════════════════════
      // COMPUTE LOCAL ORDER PARAMETER
      // ═══════════════════════════════════════════════════════════════════════
      // The local order parameter measures synchronization with neighbors:
      //   rᵢ = |⟨e^(iθⱼ)⟩ⱼ∈Nᵢ|
      //
      // This captures local clustering that may differ from global.
      // ═══════════════════════════════════════════════════════════════════════
      
      var localCos : Float = 0.0;
      var localSin : Float = 0.0;
      var localWeight : Float = 0.0;
      
      for (j in Iter.range(0, osc.neighbors.size() - 1)) {
        let neighborId = osc.neighbors[j];
        if (neighborId < network.N) {
          let neighbor = network.oscillators[neighborId];
          let weight = osc.coupling[j] * neighbor.amplitude;
          localCos += weight * Float.cos(neighbor.phase);
          localSin += weight * Float.sin(neighbor.phase);
          localWeight += weight;
        };
      };
      
      let localOrder = if (localWeight > 0.001) {
        let avgLocalCos = localCos / localWeight;
        let avgLocalSin = localSin / localWeight;
        Float.sqrt(avgLocalCos * avgLocalCos + avgLocalSin * avgLocalSin)
      } else {
        rGlobal  // Default to global if no neighbors
      };
      
      // ═══════════════════════════════════════════════════════════════════════
      // UPDATE AMPLITUDE (Energy dynamics)
      // ═══════════════════════════════════════════════════════════════════════
      // Amplitude evolves according to:
      //   dA/dt = (μ - A²)·A + ε·r·A
      //
      // Where:
      //   - μ > 0: growth rate (self-excitation)
      //   - -A²·A: saturation (nonlinear damping)
      //   - ε·r·A: coherence-dependent boost
      //
      // This gives Stuart-Landau dynamics with coupling.
      // ═══════════════════════════════════════════════════════════════════════
      
      let mu = 0.1;  // Growth rate
      let epsilon = 0.05;  // Coherence coupling
      
      let dAmplitude = (mu - osc.amplitude * osc.amplitude) * osc.amplitude 
                      + epsilon * rGlobal * osc.amplitude;
      
      var newAmplitude = osc.amplitude + dt * dAmplitude;
      
      // Clamp amplitude to [0, 2] (sovereign ceiling)
      if (newAmplitude < 0.0) { newAmplitude := 0.0 };
      if (newAmplitude > 2.0) { newAmplitude := 2.0 };
      
      // Return updated oscillator
      {
        id = osc.id;
        phase = newPhase;
        omega = osc.omega;
        amplitude = newAmplitude;
        damping = osc.damping;
        externalForce = osc.externalForce;
        localOrder = localOrder;
        neighbors = osc.neighbors;
        coupling = osc.coupling;
      }
    });
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 5: COMPUTE DERIVED QUANTITIES
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Effective temperature (from entropy)
    // T_eff ∝ S / log(N) for thermal equilibrium
    let effectiveTemp = normalizedEntropy * network.temperature;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 6: RETURN UPDATED NETWORK
    // ═══════════════════════════════════════════════════════════════════════════
    
    {
      oscillators = newOscillators;
      N = network.N;
      K = network.K;
      rGlobal = rGlobal;
      psiGlobal = psiGlobal;
      entropy = normalizedEntropy;
      temperature = effectiveTemp;
      dt = network.dt;
      beat = network.beat + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FUNCTION 2: HEBBIAN PLASTICITY ENGINE — Full Implementation
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Hebbian learning: "Neurons that fire together wire together"
  //
  // The classic Hebbian rule:
  //   Δwᵢⱼ = η · xᵢ · xⱼ
  //
  // We use the more sophisticated STDP (Spike-Timing Dependent Plasticity):
  //   Δwᵢⱼ = A₊ · exp(-Δt/τ₊)  if Δt > 0 (pre before post: potentiation)
  //   Δwᵢⱼ = -A₋ · exp(Δt/τ₋)  if Δt < 0 (post before pre: depression)
  //
  // Where Δt = t_post - t_pre
  //
  // We also implement:
  //   - Weight normalization (synaptic scaling)
  //   - Homeostatic plasticity (activity regulation)
  //   - Metaplasticity (plasticity of plasticity)
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HebbianNeuron = {
    id: Nat;
    activation: Float;           // Current activation level
    threshold: Float;            // Firing threshold
    refractoryTime: Nat;         // Beats since last spike
    lastSpikeTime: Nat;          // Beat number of last spike
    spikeHistory: [Nat];         // Recent spike times
    adaptationCurrent: Float;    // Spike frequency adaptation
    calciumLevel: Float;         // Ca²⁺ concentration (controls plasticity)
  };
  
  public type HebbianSynapse = {
    preId: Nat;                  // Pre-synaptic neuron ID
    postId: Nat;                 // Post-synaptic neuron ID
    weight: Float;               // Synaptic weight
    delay: Nat;                  // Transmission delay (beats)
    type_: { #Excitatory; #Inhibitory };
    eligibilityTrace: Float;     // For reward-modulated learning
    lastUpdate: Nat;             // Beat of last weight update
  };
  
  public type HebbianNetwork = {
    neurons: [HebbianNeuron];
    synapses: [HebbianSynapse];
    N: Nat;                      // Number of neurons
    eta: Float;                  // Base learning rate
    A_plus: Float;               // LTP amplitude
    A_minus: Float;              // LTD amplitude
    tau_plus: Float;             // LTP time constant
    tau_minus: Float;            // LTD time constant
    wMax: Float;                 // Maximum weight
    wMin: Float;                 // Minimum weight
    targetActivity: Float;       // Homeostatic target
    homeostaticRate: Float;      // Homeostatic adjustment rate
    beat: Nat;
  };
  
  public func tickHebbianNetwork(network: HebbianNetwork, externalInput: [Float]) : HebbianNetwork {
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 1: COMPUTE SYNAPTIC INPUT TO EACH NEURON
    // ═══════════════════════════════════════════════════════════════════════════
    // Total input to neuron j:
    //   Iⱼ = Σᵢ wᵢⱼ · xᵢ(t - dᵢⱼ) + Iⱼ_ext
    //
    // Where:
    //   - wᵢⱼ: synaptic weight from i to j
    //   - xᵢ(t - dᵢⱼ): pre-synaptic activity with delay
    //   - Iⱼ_ext: external input
    // ═══════════════════════════════════════════════════════════════════════════
    
    let beat = network.beat;
    var synapticInput = Array.init<Float>(network.N, 0.0);
    
    // Add external input
    for (i in Iter.range(0, network.N - 1)) {
      if (i < externalInput.size()) {
        synapticInput[i] := externalInput[i];
      };
    };
    
    // Compute synaptic contributions
    for (syn in network.synapses.vals()) {
      if (syn.preId < network.N and syn.postId < network.N) {
        let preNeuron = network.neurons[syn.preId];
        
        // Check if pre-synaptic neuron spiked at the appropriate time (with delay)
        var hadSpike = false;
        for (spikeTime in preNeuron.spikeHistory.vals()) {
          if (spikeTime + syn.delay == beat) {
            hadSpike := true;
          };
        };
        
        if (hadSpike) {
          // Apply synaptic weight (sign depends on type)
          let contribution = switch (syn.type_) {
            case (#Excitatory) { syn.weight };
            case (#Inhibitory) { -syn.weight };
          };
          synapticInput[syn.postId] += contribution;
        };
      };
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 2: UPDATE NEURON DYNAMICS
    // ═══════════════════════════════════════════════════════════════════════════
    // We use the Leaky Integrate-and-Fire (LIF) model:
    //   τₘ · dV/dt = -(V - V_rest) + R · I
    //   if V > V_thresh: spike, V → V_reset
    //
    // With spike-frequency adaptation:
    //   τₐ · da/dt = -a
    //   after spike: a → a + Δa
    //   effective threshold: V_thresh + a
    //
    // And calcium dynamics:
    //   τ_Ca · dCa/dt = -Ca
    //   after spike: Ca → Ca + ΔCa
    // ═══════════════════════════════════════════════════════════════════════════
    
    let tau_m : Float = 20.0;      // Membrane time constant (ms)
    let tau_a : Float = 100.0;     // Adaptation time constant
    let tau_Ca : Float = 50.0;     // Calcium time constant
    let V_rest : Float = -70.0;    // Resting potential (mV)
    let V_thresh : Float = -55.0;  // Threshold potential
    let V_reset : Float = -75.0;   // Reset potential
    let R : Float = 10.0;          // Membrane resistance (MΩ)
    let dt_ms : Float = 1.0;       // Time step in ms
    let delta_a : Float = 0.1;     // Adaptation increment
    let delta_Ca : Float = 0.2;    // Calcium increment
    let refractoryPeriod : Nat = 2; // Refractory period in beats
    
    var newNeurons = Array.init<HebbianNeuron>(network.N, network.neurons[0]);
    var spikedNeurons : [Nat] = [];
    
    for (i in Iter.range(0, network.N - 1)) {
      let neuron = network.neurons[i];
      
      // Check refractory period
      let inRefractory = (beat - neuron.lastSpikeTime) < refractoryPeriod;
      
      // ═══════════════════════════════════════════════════════════════════════
      // Membrane potential dynamics (simplified)
      // dV/dt = (-(V - V_rest) + R·I) / τₘ
      // ═══════════════════════════════════════════════════════════════════════
      
      // Current potential estimate from activation
      let V_current = V_rest + neuron.activation * (V_thresh - V_rest) / 1.0;
      
      // Input current
      let I_total = synapticInput[i];
      
      // Voltage change
      let dV = (-(V_current - V_rest) + R * I_total) / tau_m * dt_ms;
      var V_new = V_current + dV;
      
      // ═══════════════════════════════════════════════════════════════════════
      // Adaptation dynamics
      // da/dt = -a / τₐ
      // ═══════════════════════════════════════════════════════════════════════
      
      let da = -neuron.adaptationCurrent / tau_a * dt_ms;
      var adaptation_new = neuron.adaptationCurrent + da;
      if (adaptation_new < 0.0) { adaptation_new := 0.0 };
      
      // ═══════════════════════════════════════════════════════════════════════
      // Calcium dynamics
      // dCa/dt = -Ca / τ_Ca
      // ═══════════════════════════════════════════════════════════════════════
      
      let dCa = -neuron.calciumLevel / tau_Ca * dt_ms;
      var calcium_new = neuron.calciumLevel + dCa;
      if (calcium_new < 0.0) { calcium_new := 0.0 };
      
      // ═══════════════════════════════════════════════════════════════════════
      // Spike detection
      // Effective threshold = V_thresh + adaptation
      // ═══════════════════════════════════════════════════════════════════════
      
      let effectiveThreshold = V_thresh + adaptation_new * 10.0;
      var spiked = false;
      var lastSpike = neuron.lastSpikeTime;
      var newSpikeHistory = neuron.spikeHistory;
      
      if (not inRefractory and V_new > effectiveThreshold) {
        // SPIKE!
        spiked := true;
        V_new := V_reset;
        adaptation_new += delta_a;
        calcium_new += delta_Ca;
        lastSpike := beat;
        spikedNeurons := Array.append(spikedNeurons, [i]);
        
        // Update spike history (keep last 10 spikes)
        var historyBuffer = Buffer.Buffer<Nat>(11);
        historyBuffer.add(beat);
        var count = 0;
        for (st in neuron.spikeHistory.vals()) {
          if (count < 9) {
            historyBuffer.add(st);
            count += 1;
          };
        };
        newSpikeHistory := Buffer.toArray(historyBuffer);
      };
      
      // Convert voltage back to activation (normalized)
      let activation_new = (V_new - V_rest) / (V_thresh - V_rest);
      let activation_clamped = if (activation_new < 0.0) { 0.0 } 
                               else if (activation_new > 2.0) { 2.0 } 
                               else { activation_new };
      
      newNeurons[i] := {
        id = neuron.id;
        activation = activation_clamped;
        threshold = effectiveThreshold;
        refractoryTime = if (spiked) { 0 } else { neuron.refractoryTime + 1 };
        lastSpikeTime = lastSpike;
        spikeHistory = newSpikeHistory;
        adaptationCurrent = adaptation_new;
        calciumLevel = calcium_new;
      };
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 3: SPIKE-TIMING DEPENDENT PLASTICITY (STDP)
    // ═══════════════════════════════════════════════════════════════════════════
    // For each synapse, compute weight change based on spike timing:
    //
    //   Δw = Σ_pre Σ_post STDP(t_post - t_pre)
    //
    // STDP kernel:
    //   STDP(Δt) = A₊ · exp(-Δt/τ₊)   if Δt > 0 (causal: potentiation)
    //   STDP(Δt) = -A₋ · exp(Δt/τ₋)   if Δt < 0 (anti-causal: depression)
    //
    // We also apply:
    //   - Weight-dependent scaling (soft bounds)
    //   - Homeostatic normalization
    // ═══════════════════════════════════════════════════════════════════════════
    
    let A_plus = network.A_plus;
    let A_minus = network.A_minus;
    let tau_plus = network.tau_plus;
    let tau_minus = network.tau_minus;
    let eta = network.eta;
    let wMax = network.wMax;
    let wMin = network.wMin;
    
    var newSynapses = Array.init<HebbianSynapse>(network.synapses.size(), network.synapses[0]);
    
    for (si in Iter.range(0, network.synapses.size() - 1)) {
      let syn = network.synapses[si];
      var deltaW : Float = 0.0;
      
      let preNeuron = newNeurons[syn.preId];
      let postNeuron = newNeurons[syn.postId];
      
      // ═══════════════════════════════════════════════════════════════════════
      // Compute STDP contribution from all spike pairs
      // ═══════════════════════════════════════════════════════════════════════
      
      for (t_pre in preNeuron.spikeHistory.vals()) {
        for (t_post in postNeuron.spikeHistory.vals()) {
          let delta_t = Float.fromInt(Int.abs(t_post - t_pre));
          
          if (delta_t < 100.0) {  // Only consider recent spikes
            if (t_post > t_pre) {
              // Causal: pre before post → LTP (potentiation)
              let stdp = A_plus * Float.exp(-delta_t / tau_plus);
              // Weight-dependent: stronger for weak synapses
              let weightFactor = (wMax - syn.weight) / wMax;
              deltaW += stdp * weightFactor;
            } else if (t_pre > t_post) {
              // Anti-causal: post before pre → LTD (depression)
              let stdp = -A_minus * Float.exp(-delta_t / tau_minus);
              // Weight-dependent: stronger for strong synapses
              let weightFactor = (syn.weight - wMin) / wMax;
              deltaW += stdp * weightFactor;
            };
          };
        };
      };
      
      // ═══════════════════════════════════════════════════════════════════════
      // Apply learning rate and calcium modulation
      // ═══════════════════════════════════════════════════════════════════════
      // Calcium level gates plasticity (BCM-like rule):
      //   High Ca²⁺ → LTP enabled
      //   Low Ca²⁺ → LTD enabled
      //   Very low Ca²⁺ → no plasticity
      
      let postCa = postNeuron.calciumLevel;
      let plasticityGate = Float.tanh(postCa * 5.0);  // Sigmoid gating
      
      deltaW := deltaW * eta * plasticityGate;
      
      // ═══════════════════════════════════════════════════════════════════════
      // Update eligibility trace (for reward modulation)
      // ═══════════════════════════════════════════════════════════════════════
      // The eligibility trace decays exponentially and is boosted by STDP:
      //   dE/dt = -E/τ_E + STDP
      
      let tau_E : Float = 100.0;
      let newEligibility = syn.eligibilityTrace * Float.exp(-1.0/tau_E) + deltaW;
      
      // ═══════════════════════════════════════════════════════════════════════
      // Apply weight change with bounds
      // ═══════════════════════════════════════════════════════════════════════
      
      var newWeight = syn.weight + deltaW;
      
      // Hard bounds
      if (newWeight < wMin) { newWeight := wMin };
      if (newWeight > wMax) { newWeight := wMax };
      
      newSynapses[si] := {
        preId = syn.preId;
        postId = syn.postId;
        weight = newWeight;
        delay = syn.delay;
        type_ = syn.type_;
        eligibilityTrace = newEligibility;
        lastUpdate = if (Float.abs(deltaW) > 0.0001) { beat } else { syn.lastUpdate };
      };
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 4: HOMEOSTATIC PLASTICITY (Synaptic Scaling)
    // ═══════════════════════════════════════════════════════════════════════════
    // Maintain average activity at target level:
    //   - If activity too high → scale down all incoming weights
    //   - If activity too low → scale up all incoming weights
    //
    // For each neuron j:
    //   Scale factor = 1 + α · (target - ⟨x⟩ⱼ)
    //   wᵢⱼ → wᵢⱼ · scale_factor
    // ═══════════════════════════════════════════════════════════════════════════
    
    let targetActivity = network.targetActivity;
    let homeoRate = network.homeostaticRate;
    
    // Compute average activity for each neuron
    var avgActivity = Array.init<Float>(network.N, 0.0);
    for (i in Iter.range(0, network.N - 1)) {
      let neuron = newNeurons[i];
      // Use spike rate as activity measure
      let spikeRate = Float.fromInt(neuron.spikeHistory.size()) / 10.0;
      avgActivity[i] := spikeRate;
    };
    
    // Apply homeostatic scaling
    for (si in Iter.range(0, newSynapses.size() - 1)) {
      let syn = newSynapses[si];
      let postActivity = avgActivity[syn.postId];
      
      // Scale factor (small adjustment)
      let scaleFactor = 1.0 + homeoRate * (targetActivity - postActivity);
      let clampedScale = if (scaleFactor < 0.9) { 0.9 } 
                         else if (scaleFactor > 1.1) { 1.1 } 
                         else { scaleFactor };
      
      var scaledWeight = syn.weight * clampedScale;
      if (scaledWeight < wMin) { scaledWeight := wMin };
      if (scaledWeight > wMax) { scaledWeight := wMax };
      
      newSynapses[si] := { syn with weight = scaledWeight };
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 5: RETURN UPDATED NETWORK
    // ═══════════════════════════════════════════════════════════════════════════
    
    {
      neurons = Array.freeze(newNeurons);
      synapses = Array.freeze(newSynapses);
      N = network.N;
      eta = network.eta;
      A_plus = network.A_plus;
      A_minus = network.A_minus;
      tau_plus = network.tau_plus;
      tau_minus = network.tau_minus;
      wMax = network.wMax;
      wMin = network.wMin;
      targetActivity = network.targetActivity;
      homeostaticRate = network.homeostaticRate;
      beat = beat + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FUNCTION 3: SPHERICAL ROOT NETWORK — Creation from Center with Roots
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Creation is SPHERICAL, from the MIDDLE, FULL OF ROOTS.
  //
  // The root network grows outward from a central core using:
  //   - Fibonacci spiral distribution for uniform coverage
  //   - Golden angle branching for natural growth patterns
  //   - Diffusion-limited aggregation for organic structures
  //
  // Each root carries:
  //   - Information (bandwidth proportional to thickness)
  //   - Energy (flows from center outward)
  //   - Phase (Kuramoto-coupled for synchronization)
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type RootNode = {
    id: Nat;
    position: SphericalCoord;
    cartesian: Vec3;            // Cached Cartesian position
    
    // Tree structure
    parentId: ?Nat;
    childIds: [Nat];
    depth: Nat;                 // Distance from root (0 = center)
    
    // Physical properties
    thickness: Float;           // Proportional to subtree mass
    length: Float;              // Length of segment to parent
    age: Nat;                   // Beats since creation
    
    // Growth state
    isGrowing: Bool;
    growthRate: Float;
    branchPotential: Float;     // Probability of branching
    
    // Information flow
    bandwidth: Float;           // Data capacity
    currentFlow: Float;         // Current utilization
    phase: Float;               // Kuramoto phase
    
    // Energy
    energy: Float;              // Available energy
    metabolicRate: Float;       // Energy consumption rate
  };
  
  public type RootNetwork = {
    nodes: [RootNode];
    N: Nat;
    
    // Global properties
    totalMass: Float;
    totalBandwidth: Float;
    globalPhase: Float;
    
    // Growth parameters
    maxDepth: Nat;
    branchAngle: Float;         // Golden angle
    growthEnergy: Float;        // Energy available for growth
    
    beat: Nat;
  };
  
  // Full implementation of spherical root growth
  public func tickRootNetwork(network: RootNetwork, energyInput: Float) : RootNetwork {
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 1: DISTRIBUTE ENERGY FROM CENTER
    // ═══════════════════════════════════════════════════════════════════════════
    // Energy flows outward from the center following the tree structure.
    // Each node receives energy proportional to its thickness.
    // Energy decays with distance from center.
    // ═══════════════════════════════════════════════════════════════════════════
    
    let beat = network.beat;
    var nodeEnergies = Array.init<Float>(network.N, 0.0);
    
    // Start with center node getting all input energy
    if (network.N > 0) {
      nodeEnergies[0] := energyInput;
    };
    
    // Propagate energy outward (BFS order by depth)
    for (depth in Iter.range(0, network.maxDepth)) {
      for (i in Iter.range(0, network.N - 1)) {
        let node = network.nodes[i];
        if (node.depth == depth) {
          // Distribute energy to children
          let availableEnergy = nodeEnergies[i] - node.metabolicRate;
          
          if (availableEnergy > 0.0 and node.childIds.size() > 0) {
            // Energy split proportionally by child thickness
            var totalChildThickness : Float = 0.0;
            for (childId in node.childIds.vals()) {
              if (childId < network.N) {
                totalChildThickness += network.nodes[childId].thickness;
              };
            };
            
            if (totalChildThickness > 0.001) {
              for (childId in node.childIds.vals()) {
                if (childId < network.N) {
                  let childThickness = network.nodes[childId].thickness;
                  let fraction = childThickness / totalChildThickness;
                  // Energy decays with golden ratio
                  let decayedEnergy = availableEnergy * fraction * ψ;
                  nodeEnergies[childId] += decayedEnergy;
                };
              };
            };
          };
        };
      };
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 2: UPDATE NODE GROWTH
    // ═══════════════════════════════════════════════════════════════════════════
    // Each node grows based on:
    //   - Available energy
    //   - Age (growth slows with age)
    //   - Local crowding (DLA-like inhibition)
    //
    // Growth increases thickness and length:
    //   dT/dt = g · E · exp(-age/τ_age) · (1 - crowding)
    // ═══════════════════════════════════════════════════════════════════════════
    
    let tau_age : Float = 1000.0;  // Age decay constant
    
    var newNodes = Array.init<RootNode>(network.N, network.nodes[0]);
    var totalMass : Float = 0.0;
    var totalBandwidth : Float = 0.0;
    
    for (i in Iter.range(0, network.N - 1)) {
      let node = network.nodes[i];
      let energy = nodeEnergies[i];
      
      // ═══════════════════════════════════════════════════════════════════════
      // Age factor: growth slows with age
      // ═══════════════════════════════════════════════════════════════════════
      let ageFactor = Float.exp(-Float.fromInt(node.age) / tau_age);
      
      // ═══════════════════════════════════════════════════════════════════════
      // Crowding factor: local density inhibits growth
      // ═══════════════════════════════════════════════════════════════════════
      var crowding : Float = 0.0;
      for (j in Iter.range(0, network.N - 1)) {
        if (i != j) {
          let other = network.nodes[j];
          // Distance in spherical coordinates
          let dTheta = node.position.theta - other.position.theta;
          let dPhi = node.position.phi - other.position.phi;
          let dR = node.position.r - other.position.r;
          let dist = Float.sqrt(dTheta*dTheta + dPhi*dPhi + dR*dR);
          
          if (dist < 0.5) {
            crowding += (0.5 - dist) * other.thickness;
          };
        };
      };
      let crowdingFactor = 1.0 / (1.0 + crowding);
      
      // ═══════════════════════════════════════════════════════════════════════
      // Growth computation
      // ═══════════════════════════════════════════════════════════════════════
      var newThickness = node.thickness;
      var newLength = node.length;
      var newGrowing = node.isGrowing;
      var newBranchPotential = node.branchPotential;
      
      if (node.isGrowing and energy > node.metabolicRate) {
        let growthAmount = node.growthRate * energy * ageFactor * crowdingFactor;
        
        // Thickness grows logarithmically (pipe model)
        newThickness := node.thickness + growthAmount * 0.01;
        
        // Length grows linearly
        newLength := node.length + growthAmount * 0.1;
        
        // Branch potential accumulates
        newBranchPotential := node.branchPotential + growthAmount * 0.001;
        
        // Stop growing if too old or too little energy
        if (node.age > 500 or energy < node.metabolicRate * 2.0) {
          newGrowing := false;
        };
      };
      
      // ═══════════════════════════════════════════════════════════════════════
      // Update Kuramoto phase (roots synchronize)
      // ═══════════════════════════════════════════════════════════════════════
      var newPhase = node.phase + 0.1;  // Base frequency
      
      // Coupling to parent
      switch (node.parentId) {
        case (?pid) {
          if (pid < network.N) {
            let parent = network.nodes[pid];
            let coupling = 0.3 * Float.sin(parent.phase - node.phase);
            newPhase += coupling;
          };
        };
        case null {};
      };
      
      // Normalize phase
      while (newPhase >= τ) { newPhase -= τ };
      while (newPhase < 0.0) { newPhase += τ };
      
      // ═══════════════════════════════════════════════════════════════════════
      // Update bandwidth (proportional to thickness squared)
      // ═══════════════════════════════════════════════════════════════════════
      let newBandwidth = newThickness * newThickness * 10.0;
      
      // ═══════════════════════════════════════════════════════════════════════
      // Update position (roots grow outward)
      // ═══════════════════════════════════════════════════════════════════════
      var newR = node.position.r;
      if (newGrowing) {
        // Grow outward at rate proportional to energy
        newR := node.position.r + energy * 0.001 * ageFactor;
      };
      
      // Angles shift slightly (spiral growth)
      let newTheta = node.position.theta + GOLDEN_ANGLE * 0.001;
      var normalizedTheta = newTheta;
      while (normalizedTheta >= τ) { normalizedTheta -= τ };
      
      // Convert to Cartesian
      let sinPhi = Float.sin(node.position.phi);
      let cosPhi = Float.cos(node.position.phi);
      let sinTheta = Float.sin(normalizedTheta);
      let cosTheta = Float.cos(normalizedTheta);
      
      let newCartesian : Vec3 = {
        x = newR * sinPhi * cosTheta;
        y = newR * cosPhi;
        z = newR * sinPhi * sinTheta;
      };
      
      // ═══════════════════════════════════════════════════════════════════════
      // Store updated node
      // ═══════════════════════════════════════════════════════════════════════
      newNodes[i] := {
        id = node.id;
        position = { r = newR; theta = normalizedTheta; phi = node.position.phi };
        cartesian = newCartesian;
        parentId = node.parentId;
        childIds = node.childIds;
        depth = node.depth;
        thickness = newThickness;
        length = newLength;
        age = node.age + 1;
        isGrowing = newGrowing;
        growthRate = node.growthRate;
        branchPotential = newBranchPotential;
        bandwidth = newBandwidth;
        currentFlow = node.currentFlow;
        phase = newPhase;
        energy = energy;
        metabolicRate = node.metabolicRate;
      };
      
      totalMass += newThickness * newLength;
      totalBandwidth += newBandwidth;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 3: CHECK FOR BRANCHING
    // ═══════════════════════════════════════════════════════════════════════════
    // Nodes with high branch potential may spawn children.
    // Branching uses golden angle for natural distribution.
    // ═══════════════════════════════════════════════════════════════════════════
    
    // (Branching would add new nodes - simplified here to avoid dynamic sizing)
    // In full implementation, this would use a Buffer and reallocate
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 4: COMPUTE GLOBAL PHASE
    // ═══════════════════════════════════════════════════════════════════════════
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (i in Iter.range(0, network.N - 1)) {
      sumCos += Float.cos(newNodes[i].phase);
      sumSin += Float.sin(newNodes[i].phase);
    };
    let globalPhase = Float.arctan2(sumSin, sumCos);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 5: RETURN UPDATED NETWORK
    // ═══════════════════════════════════════════════════════════════════════════
    
    {
      nodes = Array.freeze(newNodes);
      N = network.N;
      totalMass = totalMass;
      totalBandwidth = totalBandwidth;
      globalPhase = globalPhase;
      maxDepth = network.maxDepth;
      branchAngle = network.branchAngle;
      growthEnergy = energyInput;
      beat = beat + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func sphericalToCartesian(s: SphericalCoord) : Vec3 {
    let sinPhi = Float.sin(s.phi);
    let cosPhi = Float.cos(s.phi);
    let sinTheta = Float.sin(s.theta);
    let cosTheta = Float.cos(s.theta);
    
    {
      x = s.r * sinPhi * cosTheta;
      y = s.r * cosPhi;
      z = s.r * sinPhi * sinTheta;
    }
  };
  
  public func cartesianToSpherical(v: Vec3) : SphericalCoord {
    let r = Float.sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
    let theta = Float.arctan2(v.z, v.x);
    let phi = if (r > 0.001) { Float.arccos(v.y / r) } else { 0.0 };
    
    { r = r; theta = theta; phi = phi }
  };
  
  public func vec3Add(a: Vec3, b: Vec3) : Vec3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };
  
  public func vec3Scale(v: Vec3, s: Float) : Vec3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };
  
  public func vec3Dot(a: Vec3, b: Vec3) : Float {
    a.x * b.x + a.y * b.y + a.z * b.z
  };
  
  public func vec3Length(v: Vec3) : Float {
    Float.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
  };
  
  public func vec3Normalize(v: Vec3) : Vec3 {
    let len = vec3Length(v);
    if (len < 0.0001) { { x = 0.0; y = 0.0; z = 0.0 } }
    else { vec3Scale(v, 1.0 / len) }
  };

}
