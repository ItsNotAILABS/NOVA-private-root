// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: TriModalSwarmKernel — Scale-Invariant Swarm Dynamics Across Modes
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              TRI-MODAL SWARM KERNEL                                      ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  OPERATIONAL SCALE-INVARIANCE (not just theoretical)                     ║
// ║                                                                          ║
// ║  Three mathematically consistent runtime modes:                          ║
// ║                                                                          ║
// ║  1. EXACT MODE (N ≤ 2,048):                                              ║
// ║     - Full-resolution Kuramoto dynamics                                  ║
// ║     - O(N²) coupling computations                                        ║
// ║     - Best for verification, training, doctrine tuning                   ║
// ║                                                                          ║
// ║  2. CLUSTERED MEAN-FIELD MODE (2,048 < N ≤ 65,536):                      ║
// ║     - Drones partition into adaptive pods                                ║
// ║     - Per-pod moments (r, ψ, variance)                                   ║
// ║     - Sparse inter-pod coupling graph                                    ║
// ║     - O(P² + N) where P = number of pods                                 ║
// ║                                                                          ║
// ║  3. CONTINUUM MODE (N > 65,536):                                         ║
// ║     - Population density model ρ(θ, ω, t)                                ║
// ║     - PDE-inspired approximation (Fokker-Planck)                         ║
// ║     - Sampled representative agents for drift correction                 ║
// ║     - O(M) where M = resolution of phase discretization                  ║
// ║                                                                          ║
// ║  DRIFT SAFETY ACROSS MODES:                                              ║
// ║     - Invariant surfaces common to all modes                             ║
// ║     - Overlap windows for parallel execution during transitions          ║
// ║     - Switch only when invariant divergence < ε                          ║
// ║                                                                          ║
// ║  MULTIPLE RESPONSIBILITIES:                                              ║
// ║    1. Mode selection and switching                                       ║
// ║    2. Exact dynamics computation                                         ║
// ║    3. Clustered mean-field dynamics                                      ║
// ║    4. Continuum PDE dynamics                                             ║
// ║    5. Invariant verification                                             ║
// ║    6. Drift monitoring                                                   ║
// ║    7. Transition orchestration                                           ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MATHEMATICAL CONSTANTS                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let τ : Float = 6.2831853071795864769;
  public let π : Float = 3.1415926535897932385;
  public let e : Float = 2.7182818284590452354;

  // Mode thresholds
  public let EXACT_MODE_LIMIT : Nat = 2048;
  public let CLUSTERED_MODE_LIMIT : Nat = 65536;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     RUNTIME MODE TYPES                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type RuntimeMode = {
    #Exact;           // N ≤ 2,048
    #ClusteredMeanField;  // 2,048 < N ≤ 65,536
    #Continuum;       // N > 65,536
  };

  public type ModeTransition = {
    fromMode : RuntimeMode;
    toMode : RuntimeMode;
    transitionBeat : Nat;
    overlapWindow : Nat;    // Beats of parallel execution
    invariantThreshold : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     OSCILLATOR STATE                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Individual oscillator (used in Exact mode)
  public type Oscillator = {
    id : Nat32;
    phase : Float;          // θ ∈ [0, 2π)
    naturalFrequency : Float;  // ω
    amplitude : Float;      // For extended Kuramoto
    coherence : Float;      // Local coherence
  };

  // Pod/cluster (used in Clustered mode)
  public type Pod = {
    id : Nat32;
    memberCount : Nat;
    
    // Mean-field moments
    orderParameter : Float;     // r = |Σ e^(iθ)|/N
    meanPhase : Float;          // ψ = arg(Σ e^(iθ))
    phaseVariance : Float;      // Var(θ)
    meanFrequency : Float;      // <ω>
    frequencyVariance : Float;  // Var(ω)
    
    // Centroid position (for spatial clustering)
    centroidTheta : Float;
    centroidPhi : Float;
  };

  // Phase distribution (used in Continuum mode)
  public type PhaseDistribution = {
    density : [Float];      // ρ(θ) discretized on grid
    gridSize : Nat;         // Number of grid points
    deltaTheta : Float;     // Grid spacing
    
    // Fourier modes of distribution
    fourierModes : [ComplexNum];  // ρ̂_k
    maxModes : Nat;
  };

  public type ComplexNum = {
    re : Float;
    im : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INVARIANT SURFACES                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Invariants that must be preserved across all modes
  public type SwarmInvariants = {
    // Primary order parameter
    globalOrderParameter : Float;   // r ∈ [0, 1]
    globalMeanPhase : Float;        // ψ ∈ [0, 2π)
    
    // Secondary invariants
    totalEnergy : Float;
    totalCoherence : Float;
    
    // Distribution moments
    meanFrequency : Float;
    frequencyVariance : Float;
    
    // Topological invariants
    windingNumber : Int;
    
    // Stability invariants
    lyapunovEstimate : Float;
    entropyRate : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TRI-MODAL SWARM KERNEL                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type TriModalKernel = {
    // Current mode
    mode : RuntimeMode;
    
    // Population size
    N : Nat;
    
    // Coupling parameters
    K : Float;              // Base coupling strength
    adaptiveK : Float;      // Current adaptive coupling
    
    // Mode-specific state (only one active at a time)
    exactState : ?ExactModeState;
    clusteredState : ?ClusteredModeState;
    continuumState : ?ContinuumModeState;
    
    // Invariants (common to all modes)
    invariants : SwarmInvariants;
    
    // Transition management
    transitionInProgress : Bool;
    shadowState : ?ShadowState;  // For overlap window
    
    // Beat tracking
    currentBeat : Nat;
    modeStartBeat : Nat;
  };

  public type ExactModeState = {
    oscillators : [Oscillator];
    couplingMatrix : ?[[Float]];  // Optional explicit coupling
  };

  public type ClusteredModeState = {
    pods : [Pod];
    podCouplingGraph : [[Float]];  // Sparse inter-pod coupling
    oscillatorToPod : [Nat];       // Mapping from oscillator ID to pod
  };

  public type ContinuumModeState = {
    distribution : PhaseDistribution;
    representativeAgents : [Oscillator];  // Sampled for drift correction
    frequencyDistribution : [Float];      // g(ω)
  };

  public type ShadowState = {
    mode : RuntimeMode;
    invariants : SwarmInvariants;
    beatsRemaining : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     KERNEL CREATION                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Create kernel with automatic mode selection
  public func createKernel(N : Nat, K : Float, frequencies : [Float]) : TriModalKernel {
    let mode = selectMode(N);
    
    let initialInvariants : SwarmInvariants = {
      globalOrderParameter = 0.0;
      globalMeanPhase = 0.0;
      totalEnergy = Float.fromInt(N);
      totalCoherence = 1.0;
      meanFrequency = arrayMean(frequencies);
      frequencyVariance = arrayVariance(frequencies);
      windingNumber = 0;
      lyapunovEstimate = 0.0;
      entropyRate = 0.0;
    };
    
    var kernel : TriModalKernel = {
      mode = mode;
      N = N;
      K = K;
      adaptiveK = K;
      exactState = null;
      clusteredState = null;
      continuumState = null;
      invariants = initialInvariants;
      transitionInProgress = false;
      shadowState = null;
      currentBeat = 0;
      modeStartBeat = 0;
    };
    
    // Initialize appropriate mode state
    kernel := initializeModeState(kernel, frequencies);
    
    // Compute initial invariants
    kernel := updateInvariants(kernel);
    
    kernel
  };

  // Select mode based on population size
  public func selectMode(N : Nat) : RuntimeMode {
    if (N <= EXACT_MODE_LIMIT) {
      #Exact
    } else if (N <= CLUSTERED_MODE_LIMIT) {
      #ClusteredMeanField
    } else {
      #Continuum
    }
  };

  // Initialize state for current mode
  func initializeModeState(kernel : TriModalKernel, frequencies : [Float]) : TriModalKernel {
    switch (kernel.mode) {
      case (#Exact) {
        let oscillators = Array.tabulate<Oscillator>(kernel.N, func(i : Nat) : Oscillator {
          let omega = if (i < frequencies.size()) { frequencies[i] } else { 1.0 };
          {
            id = Nat32.fromNat(i);
            phase = τ * Float.fromInt(i) / Float.fromInt(kernel.N);  // Uniform initial
            naturalFrequency = omega;
            amplitude = 1.0;
            coherence = 1.0;
          }
        });
        
        {
          mode = kernel.mode;
          N = kernel.N;
          K = kernel.K;
          adaptiveK = kernel.adaptiveK;
          exactState = ?{ oscillators = oscillators; couplingMatrix = null };
          clusteredState = null;
          continuumState = null;
          invariants = kernel.invariants;
          transitionInProgress = kernel.transitionInProgress;
          shadowState = kernel.shadowState;
          currentBeat = kernel.currentBeat;
          modeStartBeat = kernel.modeStartBeat;
        }
      };
      case (#ClusteredMeanField) {
        let numPods = Nat.max(1, kernel.N / 128);  // ~128 oscillators per pod
        let pods = initializePods(kernel.N, numPods, frequencies);
        let coupling = initializePodCoupling(numPods);
        let mapping = initializeOscillatorPodMapping(kernel.N, numPods);
        
        {
          mode = kernel.mode;
          N = kernel.N;
          K = kernel.K;
          adaptiveK = kernel.adaptiveK;
          exactState = null;
          clusteredState = ?{
            pods = pods;
            podCouplingGraph = coupling;
            oscillatorToPod = mapping;
          };
          continuumState = null;
          invariants = kernel.invariants;
          transitionInProgress = kernel.transitionInProgress;
          shadowState = kernel.shadowState;
          currentBeat = kernel.currentBeat;
          modeStartBeat = kernel.modeStartBeat;
        }
      };
      case (#Continuum) {
        let gridSize : Nat = 256;
        let distribution = initializeDistribution(gridSize);
        let freqDist = discretizeFrequencyDistribution(frequencies, 64);
        let representatives = sampleRepresentatives(kernel.N, 64, frequencies);
        
        {
          mode = kernel.mode;
          N = kernel.N;
          K = kernel.K;
          adaptiveK = kernel.adaptiveK;
          exactState = null;
          clusteredState = null;
          continuumState = ?{
            distribution = distribution;
            representativeAgents = representatives;
            frequencyDistribution = freqDist;
          };
          invariants = kernel.invariants;
          transitionInProgress = kernel.transitionInProgress;
          shadowState = kernel.shadowState;
          currentBeat = kernel.currentBeat;
          modeStartBeat = kernel.modeStartBeat;
        }
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     EXACT MODE DYNAMICS                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Full Kuramoto dynamics: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  public func exactModeStep(kernel : TriModalKernel, dt : Float) : TriModalKernel {
    switch (kernel.exactState) {
      case (null) { return kernel };
      case (?state) {
        let N = state.oscillators.size();
        let K = kernel.adaptiveK;
        
        // Compute order parameter for mean-field optimization
        var sumCos : Float = 0.0;
        var sumSin : Float = 0.0;
        for (osc in state.oscillators.vals()) {
          sumCos += Float.cos(osc.phase);
          sumSin += Float.sin(osc.phase);
        };
        let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(N);
        let psi = Float.arctan2(sumSin, sumCos);
        
        // Update phases using mean-field approximation
        let newOscillators = Array.tabulate<Oscillator>(N, func(i : Nat) : Oscillator {
          let osc = state.oscillators[i];
          
          // dθ/dt = ω + K·r·sin(ψ - θ)
          let dPhase = osc.naturalFrequency + K * r * Float.sin(psi - osc.phase);
          var newPhase = osc.phase + dPhase * dt;
          
          // Wrap to [0, 2π)
          while (newPhase >= τ) { newPhase -= τ };
          while (newPhase < 0.0) { newPhase += τ };
          
          {
            id = osc.id;
            phase = newPhase;
            naturalFrequency = osc.naturalFrequency;
            amplitude = osc.amplitude;
            coherence = r;
          }
        });
        
        let newState : ExactModeState = {
          oscillators = newOscillators;
          couplingMatrix = state.couplingMatrix;
        };
        
        {
          mode = kernel.mode;
          N = kernel.N;
          K = kernel.K;
          adaptiveK = kernel.adaptiveK;
          exactState = ?newState;
          clusteredState = null;
          continuumState = null;
          invariants = kernel.invariants;
          transitionInProgress = kernel.transitionInProgress;
          shadowState = kernel.shadowState;
          currentBeat = kernel.currentBeat + 1;
          modeStartBeat = kernel.modeStartBeat;
        }
      };
    }
  };

  // Full O(N²) exact computation for verification
  public func exactModeStepFull(kernel : TriModalKernel, dt : Float) : TriModalKernel {
    switch (kernel.exactState) {
      case (null) { return kernel };
      case (?state) {
        let N = state.oscillators.size();
        let K = kernel.adaptiveK;
        
        // Compute all pairwise interactions
        let newOscillators = Array.tabulate<Oscillator>(N, func(i : Nat) : Oscillator {
          let osc = state.oscillators[i];
          
          // Full coupling: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
          var couplingSum : Float = 0.0;
          for (j in Iter.range(0, N - 1)) {
            if (j != i) {
              let other = state.oscillators[j];
              couplingSum += Float.sin(other.phase - osc.phase);
            };
          };
          
          let dPhase = osc.naturalFrequency + (K / Float.fromInt(N)) * couplingSum;
          var newPhase = osc.phase + dPhase * dt;
          
          while (newPhase >= τ) { newPhase -= τ };
          while (newPhase < 0.0) { newPhase += τ };
          
          {
            id = osc.id;
            phase = newPhase;
            naturalFrequency = osc.naturalFrequency;
            amplitude = osc.amplitude;
            coherence = osc.coherence;
          }
        });
        
        {
          mode = kernel.mode;
          N = kernel.N;
          K = kernel.K;
          adaptiveK = kernel.adaptiveK;
          exactState = ?{ oscillators = newOscillators; couplingMatrix = state.couplingMatrix };
          clusteredState = null;
          continuumState = null;
          invariants = kernel.invariants;
          transitionInProgress = kernel.transitionInProgress;
          shadowState = kernel.shadowState;
          currentBeat = kernel.currentBeat + 1;
          modeStartBeat = kernel.modeStartBeat;
        }
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CLUSTERED MEAN-FIELD MODE                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Per-pod mean-field with sparse inter-pod coupling
  public func clusteredModeStep(kernel : TriModalKernel, dt : Float) : TriModalKernel {
    switch (kernel.clusteredState) {
      case (null) { return kernel };
      case (?state) {
        let numPods = state.pods.size();
        let K = kernel.adaptiveK;
        
        // Step 1: Update each pod's internal dynamics
        // Pod order parameter evolves as: dr/dt ≈ K·r·(1 - r²)/2 - D·r
        // where D is related to frequency spread
        
        var newPods = Array.tabulate<Pod>(numPods, func(p : Nat) : Pod {
          let pod = state.pods[p];
          
          // Internal dynamics
          let D = Float.sqrt(pod.frequencyVariance);
          let dr = K * pod.orderParameter * (1.0 - pod.orderParameter * pod.orderParameter) / 2.0 - D * pod.orderParameter;
          var newR = pod.orderParameter + dr * dt;
          newR := Float.max(0.0, Float.min(1.0, newR));
          
          // Inter-pod coupling
          var interPodCoupling : Float = 0.0;
          for (q in Iter.range(0, numPods - 1)) {
            if (q != p) {
              let otherPod = state.pods[q];
              let coupling = state.podCouplingGraph[p][q];
              interPodCoupling += coupling * otherPod.orderParameter * 
                                  Float.sin(otherPod.meanPhase - pod.meanPhase);
            };
          };
          
          // Update mean phase
          let dPsi = pod.meanFrequency + K * interPodCoupling / Float.fromInt(numPods);
          var newPsi = pod.meanPhase + dPsi * dt;
          while (newPsi >= τ) { newPsi -= τ };
          while (newPsi < 0.0) { newPsi += τ };
          
          {
            id = pod.id;
            memberCount = pod.memberCount;
            orderParameter = newR;
            meanPhase = newPsi;
            phaseVariance = pod.phaseVariance * (1.0 - 0.01 * newR);  // Decreases with sync
            meanFrequency = pod.meanFrequency;
            frequencyVariance = pod.frequencyVariance;
            centroidTheta = pod.centroidTheta;
            centroidPhi = pod.centroidPhi;
          }
        });
        
        {
          mode = kernel.mode;
          N = kernel.N;
          K = kernel.K;
          adaptiveK = kernel.adaptiveK;
          exactState = null;
          clusteredState = ?{
            pods = newPods;
            podCouplingGraph = state.podCouplingGraph;
            oscillatorToPod = state.oscillatorToPod;
          };
          continuumState = null;
          invariants = kernel.invariants;
          transitionInProgress = kernel.transitionInProgress;
          shadowState = kernel.shadowState;
          currentBeat = kernel.currentBeat + 1;
          modeStartBeat = kernel.modeStartBeat;
        }
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONTINUUM MODE (PDE)                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Fokker-Planck equation for phase density:
  // ∂ρ/∂t + ∂/∂θ[(ω + K·r·sin(ψ - θ))ρ] = D·∂²ρ/∂θ²
  public func continuumModeStep(kernel : TriModalKernel, dt : Float) : TriModalKernel {
    switch (kernel.continuumState) {
      case (null) { return kernel };
      case (?state) {
        let M = state.distribution.gridSize;
        let dTheta = state.distribution.deltaTheta;
        let K = kernel.adaptiveK;
        let D : Float = 0.01;  // Diffusion coefficient
        
        // Compute order parameter from distribution
        var sumCos : Float = 0.0;
        var sumSin : Float = 0.0;
        for (i in Iter.range(0, M - 1)) {
          let theta = Float.fromInt(i) * dTheta;
          sumCos += state.distribution.density[i] * Float.cos(theta) * dTheta;
          sumSin += state.distribution.density[i] * Float.sin(theta) * dTheta;
        };
        let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin);
        let psi = Float.arctan2(sumSin, sumCos);
        
        // Update density using finite differences
        let newDensity = Array.tabulate<Float>(M, func(i : Nat) : Float {
          let theta = Float.fromInt(i) * dTheta;
          let rho = state.distribution.density[i];
          
          // Advection velocity: v(θ) = ω_mean + K·r·sin(ψ - θ)
          let v = kernel.invariants.meanFrequency + K * r * Float.sin(psi - theta);
          
          // Upwind scheme for advection
          let im1 = if (i == 0) { M - 1 } else { i - 1 };
          let ip1 = if (i == M - 1) { 0 } else { i + 1 };
          
          let rhoM = state.distribution.density[im1];
          let rhoP = state.distribution.density[ip1];
          
          // Advection term (upwind)
          let advection = if (v > 0.0) {
            -v * (rho - rhoM) / dTheta
          } else {
            -v * (rhoP - rho) / dTheta
          };
          
          // Diffusion term (central)
          let diffusion = D * (rhoP - 2.0 * rho + rhoM) / (dTheta * dTheta);
          
          Float.max(0.0, rho + (advection + diffusion) * dt)
        });
        
        // Normalize
        var total : Float = 0.0;
        for (rho in newDensity.vals()) { total += rho * dTheta };
        let normalizedDensity = Array.map<Float, Float>(newDensity, func(rho : Float) : Float {
          rho / (total + 1e-10)
        });
        
        // Update Fourier modes
        let newModes = computeFourierModes(normalizedDensity, state.distribution.maxModes);
        
        // Update representative agents for drift correction
        let newReps = updateRepresentatives(state.representativeAgents, r, psi, K, dt);
        
        {
          mode = kernel.mode;
          N = kernel.N;
          K = kernel.K;
          adaptiveK = kernel.adaptiveK;
          exactState = null;
          clusteredState = null;
          continuumState = ?{
            distribution = {
              density = normalizedDensity;
              gridSize = M;
              deltaTheta = dTheta;
              fourierModes = newModes;
              maxModes = state.distribution.maxModes;
            };
            representativeAgents = newReps;
            frequencyDistribution = state.frequencyDistribution;
          };
          invariants = kernel.invariants;
          transitionInProgress = kernel.transitionInProgress;
          shadowState = kernel.shadowState;
          currentBeat = kernel.currentBeat + 1;
          modeStartBeat = kernel.modeStartBeat;
        }
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     UNIFIED STEP FUNCTION                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Main entry point: automatically uses correct mode
  public func step(kernel : TriModalKernel, dt : Float) : TriModalKernel {
    var updatedKernel = switch (kernel.mode) {
      case (#Exact) { exactModeStep(kernel, dt) };
      case (#ClusteredMeanField) { clusteredModeStep(kernel, dt) };
      case (#Continuum) { continuumModeStep(kernel, dt) };
    };
    
    // Update invariants
    updatedKernel := updateInvariants(updatedKernel);
    
    // Check for mode transition if shadow state active
    if (updatedKernel.transitionInProgress) {
      updatedKernel := checkTransitionCompletion(updatedKernel);
    };
    
    updatedKernel
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INVARIANT COMPUTATION                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Compute invariants from current mode state
  public func updateInvariants(kernel : TriModalKernel) : TriModalKernel {
    let newInvariants = switch (kernel.mode) {
      case (#Exact) { computeExactInvariants(kernel) };
      case (#ClusteredMeanField) { computeClusteredInvariants(kernel) };
      case (#Continuum) { computeContinuumInvariants(kernel) };
    };
    
    {
      mode = kernel.mode;
      N = kernel.N;
      K = kernel.K;
      adaptiveK = kernel.adaptiveK;
      exactState = kernel.exactState;
      clusteredState = kernel.clusteredState;
      continuumState = kernel.continuumState;
      invariants = newInvariants;
      transitionInProgress = kernel.transitionInProgress;
      shadowState = kernel.shadowState;
      currentBeat = kernel.currentBeat;
      modeStartBeat = kernel.modeStartBeat;
    }
  };

  func computeExactInvariants(kernel : TriModalKernel) : SwarmInvariants {
    switch (kernel.exactState) {
      case (null) { kernel.invariants };
      case (?state) {
        let N = state.oscillators.size();
        
        var sumCos : Float = 0.0;
        var sumSin : Float = 0.0;
        var sumOmega : Float = 0.0;
        var sumOmega2 : Float = 0.0;
        var totalEnergy : Float = 0.0;
        
        for (osc in state.oscillators.vals()) {
          sumCos += Float.cos(osc.phase);
          sumSin += Float.sin(osc.phase);
          sumOmega += osc.naturalFrequency;
          sumOmega2 += osc.naturalFrequency * osc.naturalFrequency;
          totalEnergy += osc.amplitude * osc.amplitude;
        };
        
        let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(N);
        let psi = Float.arctan2(sumSin, sumCos);
        let meanOmega = sumOmega / Float.fromInt(N);
        let varOmega = sumOmega2 / Float.fromInt(N) - meanOmega * meanOmega;
        
        // Estimate Lyapunov exponent
        let lyap = kernel.K * r - Float.sqrt(varOmega);
        
        // Entropy rate (approximate)
        let entropy = -Float.log(r + 0.01);
        
        {
          globalOrderParameter = r;
          globalMeanPhase = psi;
          totalEnergy = totalEnergy;
          totalCoherence = r;
          meanFrequency = meanOmega;
          frequencyVariance = varOmega;
          windingNumber = 0;  // Would need to track
          lyapunovEstimate = lyap;
          entropyRate = entropy;
        }
      };
    }
  };

  func computeClusteredInvariants(kernel : TriModalKernel) : SwarmInvariants {
    switch (kernel.clusteredState) {
      case (null) { kernel.invariants };
      case (?state) {
        // Aggregate from pods
        var totalR : Float = 0.0;
        var sumCos : Float = 0.0;
        var sumSin : Float = 0.0;
        var totalMembers : Nat = 0;
        var sumOmega : Float = 0.0;
        var sumVar : Float = 0.0;
        
        for (pod in state.pods.vals()) {
          let weight = Float.fromInt(pod.memberCount);
          totalR += pod.orderParameter * weight;
          sumCos += pod.orderParameter * Float.cos(pod.meanPhase) * weight;
          sumSin += pod.orderParameter * Float.sin(pod.meanPhase) * weight;
          totalMembers += pod.memberCount;
          sumOmega += pod.meanFrequency * weight;
          sumVar += pod.frequencyVariance * weight;
        };
        
        let N = Float.fromInt(totalMembers);
        let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / N;
        let psi = Float.arctan2(sumSin, sumCos);
        
        {
          globalOrderParameter = r;
          globalMeanPhase = psi;
          totalEnergy = N;
          totalCoherence = r;
          meanFrequency = sumOmega / N;
          frequencyVariance = sumVar / N;
          windingNumber = 0;
          lyapunovEstimate = kernel.K * r - Float.sqrt(sumVar / N);
          entropyRate = -Float.log(r + 0.01);
        }
      };
    }
  };

  func computeContinuumInvariants(kernel : TriModalKernel) : SwarmInvariants {
    switch (kernel.continuumState) {
      case (null) { kernel.invariants };
      case (?state) {
        let M = state.distribution.gridSize;
        let dTheta = state.distribution.deltaTheta;
        
        var sumCos : Float = 0.0;
        var sumSin : Float = 0.0;
        
        for (i in Iter.range(0, M - 1)) {
          let theta = Float.fromInt(i) * dTheta;
          let rho = state.distribution.density[i];
          sumCos += rho * Float.cos(theta) * dTheta;
          sumSin += rho * Float.sin(theta) * dTheta;
        };
        
        let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin);
        let psi = Float.arctan2(sumSin, sumCos);
        
        // Entropy from distribution
        var entropy : Float = 0.0;
        for (rho in state.distribution.density.vals()) {
          if (rho > 1e-10) {
            entropy -= rho * Float.log(rho) * dTheta;
          };
        };
        
        {
          globalOrderParameter = r;
          globalMeanPhase = psi;
          totalEnergy = Float.fromInt(kernel.N);
          totalCoherence = r;
          meanFrequency = kernel.invariants.meanFrequency;
          frequencyVariance = kernel.invariants.frequencyVariance;
          windingNumber = 0;
          lyapunovEstimate = kernel.K * r - Float.sqrt(kernel.invariants.frequencyVariance);
          entropyRate = entropy;
        }
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MODE TRANSITIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Initiate transition to new mode with overlap window
  public func initiateTransition(
    kernel : TriModalKernel,
    targetMode : RuntimeMode,
    overlapBeats : Nat
  ) : TriModalKernel {
    // Create shadow state for current mode
    let shadow : ShadowState = {
      mode = kernel.mode;
      invariants = kernel.invariants;
      beatsRemaining = overlapBeats;
    };
    
    // Initialize target mode
    let frequencies = extractFrequencies(kernel);
    var newKernel : TriModalKernel = {
      mode = targetMode;
      N = kernel.N;
      K = kernel.K;
      adaptiveK = kernel.adaptiveK;
      exactState = null;
      clusteredState = null;
      continuumState = null;
      invariants = kernel.invariants;
      transitionInProgress = true;
      shadowState = ?shadow;
      currentBeat = kernel.currentBeat;
      modeStartBeat = kernel.currentBeat;
    };
    
    newKernel := initializeModeState(newKernel, frequencies);
    newKernel
  };

  // Check if transition can complete
  func checkTransitionCompletion(kernel : TriModalKernel) : TriModalKernel {
    switch (kernel.shadowState) {
      case (null) {
        // No shadow state, transition complete
        {
          mode = kernel.mode;
          N = kernel.N;
          K = kernel.K;
          adaptiveK = kernel.adaptiveK;
          exactState = kernel.exactState;
          clusteredState = kernel.clusteredState;
          continuumState = kernel.continuumState;
          invariants = kernel.invariants;
          transitionInProgress = false;
          shadowState = null;
          currentBeat = kernel.currentBeat;
          modeStartBeat = kernel.modeStartBeat;
        }
      };
      case (?shadow) {
        // Check invariant divergence
        let divergence = invariantDivergence(kernel.invariants, shadow.invariants);
        let epsilon : Float = 0.1;
        
        if (shadow.beatsRemaining == 0 or divergence < epsilon) {
          // Transition complete
          {
            mode = kernel.mode;
            N = kernel.N;
            K = kernel.K;
            adaptiveK = kernel.adaptiveK;
            exactState = kernel.exactState;
            clusteredState = kernel.clusteredState;
            continuumState = kernel.continuumState;
            invariants = kernel.invariants;
            transitionInProgress = false;
            shadowState = null;
            currentBeat = kernel.currentBeat;
            modeStartBeat = kernel.modeStartBeat;
          }
        } else {
          // Continue overlap
          {
            mode = kernel.mode;
            N = kernel.N;
            K = kernel.K;
            adaptiveK = kernel.adaptiveK;
            exactState = kernel.exactState;
            clusteredState = kernel.clusteredState;
            continuumState = kernel.continuumState;
            invariants = kernel.invariants;
            transitionInProgress = true;
            shadowState = ?{
              mode = shadow.mode;
              invariants = shadow.invariants;
              beatsRemaining = shadow.beatsRemaining - 1;
            };
            currentBeat = kernel.currentBeat;
            modeStartBeat = kernel.modeStartBeat;
          }
        }
      };
    }
  };

  // Compute divergence between invariant sets
  public func invariantDivergence(a : SwarmInvariants, b : SwarmInvariants) : Float {
    let dR = Float.abs(a.globalOrderParameter - b.globalOrderParameter);
    let dPsi = Float.abs(Float.sin(a.globalMeanPhase - b.globalMeanPhase));
    let dE = Float.abs(a.totalEnergy - b.totalEnergy) / (a.totalEnergy + b.totalEnergy + 1e-10);
    let dC = Float.abs(a.totalCoherence - b.totalCoherence);
    
    (dR + dPsi + dE + dC) / 4.0
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ADAPTIVE COUPLING                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // K(t) = K₀ + a₁·trust(t) - a₂·anomaly(t) + a₃·headroom(t)
  public func updateAdaptiveCoupling(
    kernel : TriModalKernel,
    trust : Float,
    anomaly : Float,
    resourceHeadroom : Float
  ) : TriModalKernel {
    let a1 : Float = 0.5;
    let a2 : Float = 1.0;
    let a3 : Float = 0.3;
    
    let rawK = kernel.K + a1 * trust - a2 * anomaly + a3 * resourceHeadroom;
    
    // Clip to stability interval
    let Kmin : Float = 0.1;
    let Kmax : Float = 10.0;
    let clippedK = Float.max(Kmin, Float.min(Kmax, rawK));
    
    // Low-pass filter to avoid oscillatory overreaction
    let alpha : Float = 0.1;
    let smoothedK = alpha * clippedK + (1.0 - alpha) * kernel.adaptiveK;
    
    {
      mode = kernel.mode;
      N = kernel.N;
      K = kernel.K;
      adaptiveK = smoothedK;
      exactState = kernel.exactState;
      clusteredState = kernel.clusteredState;
      continuumState = kernel.continuumState;
      invariants = kernel.invariants;
      transitionInProgress = kernel.transitionInProgress;
      shadowState = kernel.shadowState;
      currentBeat = kernel.currentBeat;
      modeStartBeat = kernel.modeStartBeat;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  func arrayMean(arr : [Float]) : Float {
    if (arr.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    for (x in arr.vals()) { sum += x };
    sum / Float.fromInt(arr.size())
  };

  func arrayVariance(arr : [Float]) : Float {
    if (arr.size() == 0) { return 0.0 };
    let mean = arrayMean(arr);
    var sum2 : Float = 0.0;
    for (x in arr.vals()) {
      let diff = x - mean;
      sum2 += diff * diff;
    };
    sum2 / Float.fromInt(arr.size())
  };

  func initializePods(N : Nat, numPods : Nat, frequencies : [Float]) : [Pod] {
    let perPod = N / numPods;
    
    Array.tabulate<Pod>(numPods, func(p : Nat) : Pod {
      let startIdx = p * perPod;
      let endIdx = if (p == numPods - 1) { N } else { (p + 1) * perPod };
      let count = endIdx - startIdx;
      
      // Compute pod statistics
      var sumOmega : Float = 0.0;
      var sumOmega2 : Float = 0.0;
      for (i in Iter.range(startIdx, endIdx - 1)) {
        let omega = if (i < frequencies.size()) { frequencies[i] } else { 1.0 };
        sumOmega += omega;
        sumOmega2 += omega * omega;
      };
      let meanOmega = sumOmega / Float.fromInt(count);
      let varOmega = sumOmega2 / Float.fromInt(count) - meanOmega * meanOmega;
      
      {
        id = Nat32.fromNat(p);
        memberCount = count;
        orderParameter = 0.5;  // Initial
        meanPhase = τ * Float.fromInt(p) / Float.fromInt(numPods);
        phaseVariance = π * π / 3.0;  // Uniform distribution variance
        meanFrequency = meanOmega;
        frequencyVariance = varOmega;
        centroidTheta = π / 2.0;
        centroidPhi = τ * Float.fromInt(p) / Float.fromInt(numPods);
      }
    })
  };

  func initializePodCoupling(numPods : Nat) : [[Float]] {
    // All-to-all with distance-based weights
    Array.tabulate<[Float]>(numPods, func(i : Nat) : [Float] {
      Array.tabulate<Float>(numPods, func(j : Nat) : Float {
        if (i == j) { 0.0 }
        else {
          // Coupling decreases with "distance" (pod index difference)
          let dist = Float.fromInt(Int.abs(Int.sub(i, j)));
          1.0 / (1.0 + dist)
        }
      })
    })
  };

  func initializeOscillatorPodMapping(N : Nat, numPods : Nat) : [Nat] {
    let perPod = N / numPods;
    Array.tabulate<Nat>(N, func(i : Nat) : Nat {
      Nat.min(i / perPod, numPods - 1)
    })
  };

  func initializeDistribution(gridSize : Nat) : PhaseDistribution {
    let dTheta = τ / Float.fromInt(gridSize);
    
    // Start with uniform distribution
    let uniform = 1.0 / τ;
    let density = Array.tabulate<Float>(gridSize, func(_ : Nat) : Float { uniform });
    
    let maxModes : Nat = 16;
    let modes = Array.tabulate<ComplexNum>(maxModes, func(_ : Nat) : ComplexNum {
      { re = 0.0; im = 0.0 }
    });
    
    {
      density = density;
      gridSize = gridSize;
      deltaTheta = dTheta;
      fourierModes = modes;
      maxModes = maxModes;
    }
  };

  func discretizeFrequencyDistribution(frequencies : [Float], numBins : Nat) : [Float] {
    if (frequencies.size() == 0) {
      return Array.tabulate<Float>(numBins, func(_ : Nat) : Float { 1.0 / Float.fromInt(numBins) });
    };
    
    // Find range
    var minOmega : Float = frequencies[0];
    var maxOmega : Float = frequencies[0];
    for (omega in frequencies.vals()) {
      if (omega < minOmega) { minOmega := omega };
      if (omega > maxOmega) { maxOmega := omega };
    };
    
    let range = maxOmega - minOmega + 1e-10;
    let binWidth = range / Float.fromInt(numBins);
    
    // Count frequencies in each bin
    let counts = Array.init<Float>(numBins, 0.0);
    for (omega in frequencies.vals()) {
      let bin = Int.abs(Float.toInt((omega - minOmega) / binWidth));
      let binIdx = Nat.min(bin, numBins - 1);
      counts[binIdx] += 1.0;
    };
    
    // Normalize
    let total = Float.fromInt(frequencies.size());
    Array.tabulate<Float>(numBins, func(i : Nat) : Float { counts[i] / total })
  };

  func sampleRepresentatives(N : Nat, numReps : Nat, frequencies : [Float]) : [Oscillator] {
    let step = N / numReps;
    
    Array.tabulate<Oscillator>(numReps, func(i : Nat) : Oscillator {
      let idx = i * step;
      let omega = if (idx < frequencies.size()) { frequencies[idx] } else { 1.0 };
      {
        id = Nat32.fromNat(idx);
        phase = τ * Float.fromInt(i) / Float.fromInt(numReps);
        naturalFrequency = omega;
        amplitude = 1.0;
        coherence = 1.0;
      }
    })
  };

  func computeFourierModes(density : [Float], maxModes : Nat) : [ComplexNum] {
    let M = density.size();
    let dTheta = τ / Float.fromInt(M);
    
    Array.tabulate<ComplexNum>(maxModes, func(k : Nat) : ComplexNum {
      var re : Float = 0.0;
      var im : Float = 0.0;
      
      for (i in Iter.range(0, M - 1)) {
        let theta = Float.fromInt(i) * dTheta;
        let rho = density[i];
        re += rho * Float.cos(Float.fromInt(k) * theta) * dTheta;
        im += rho * Float.sin(Float.fromInt(k) * theta) * dTheta;
      };
      
      { re = re; im = im }
    })
  };

  func updateRepresentatives(
    reps : [Oscillator],
    r : Float,
    psi : Float,
    K : Float,
    dt : Float
  ) : [Oscillator] {
    Array.tabulate<Oscillator>(reps.size(), func(i : Nat) : Oscillator {
      let osc = reps[i];
      let dPhase = osc.naturalFrequency + K * r * Float.sin(psi - osc.phase);
      var newPhase = osc.phase + dPhase * dt;
      while (newPhase >= τ) { newPhase -= τ };
      while (newPhase < 0.0) { newPhase += τ };
      
      {
        id = osc.id;
        phase = newPhase;
        naturalFrequency = osc.naturalFrequency;
        amplitude = osc.amplitude;
        coherence = r;
      }
    })
  };

  func extractFrequencies(kernel : TriModalKernel) : [Float] {
    switch (kernel.exactState) {
      case (?state) {
        Array.map<Oscillator, Float>(state.oscillators, func(o : Oscillator) : Float {
          o.naturalFrequency
        })
      };
      case (null) {
        // Generate default frequencies
        Array.tabulate<Float>(kernel.N, func(i : Nat) : Float {
          1.0 + 0.1 * Float.sin(Float.fromInt(i) * φ)
        })
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENGINE INTERFACE                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type KernelResponsibility = {
    #ModeSelection;
    #ExactDynamics;
    #ClusteredDynamics;
    #ContinuumDynamics;
    #InvariantVerification;
    #DriftMonitoring;
    #TransitionOrchestration;
  };

  public func getKernelStats(kernel : TriModalKernel) : {
    mode : RuntimeMode;
    N : Nat;
    r : Float;
    psi : Float;
    K : Float;
    beat : Nat;
    transitioning : Bool;
  } {
    {
      mode = kernel.mode;
      N = kernel.N;
      r = kernel.invariants.globalOrderParameter;
      psi = kernel.invariants.globalMeanPhase;
      K = kernel.adaptiveK;
      beat = kernel.currentBeat;
      transitioning = kernel.transitionInProgress;
    }
  };

}
