// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  INTELLECTUAL PROPERTY NOTICE - Medina Doctrine - Heartbeat Kernel Regulator                             ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//  ██╗  ██╗███████╗ █████╗ ██████╗ ████████╗██████╗ ███████╗ █████╗ ████████╗
//  ██║  ██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝
//  ███████║█████╗  ███████║██████╔╝   ██║   ██████╔╝█████╗  ███████║   ██║
//  ██╔══██║██╔══╝  ██╔══██║██╔══██╗   ██║   ██╔══██╗██╔══╝  ██╔══██║   ██║
//  ██║  ██║███████╗██║  ██║██║  ██║   ██║   ██████╔╝███████╗██║  ██║   ██║
//  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝
//
//  ██╗  ██╗███████╗██████╗ ███╗   ██╗███████╗██╗
//  ██║ ██╔╝██╔════╝██╔══██╗████╗  ██║██╔════╝██║
//  █████╔╝ █████╗  ██████╔╝██╔██╗ ██║█████╗  ██║
//  ██╔═██╗ ██╔══╝  ██╔══██╗██║╚██╗██║██╔══╝  ██║
//  ██║  ██╗███████╗██║  ██║██║ ╚████║███████╗███████╗
//  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
//
//  ██████╗ ███████╗ ██████╗ ██╗   ██╗██╗      █████╗ ████████╗ ██████╗ ██████╗
//  ██╔══██╗██╔════╝██╔════╝ ██║   ██║██║     ██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
//  ██████╔╝█████╗  ██║  ███╗██║   ████║     ███████║   ██║   ██║   ██║██████╔╝
//  ██╔══██╗██╔══╝  ██║   ██║██║   ██║██║     ██╔══██║   ██║   ██║   ██║██╔══██╗
//  ██║  ██║███████╗╚██████╔╝╚██████╔╝███████╗██║  ██║   ██║   ╚██████╔╝██║  ██║
//  ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ENGINE ID: E-HKR-001
// HEARTBEAT KERNEL REGULATOR — The THIRD Layer Between Heart and Brain
//
// PURPOSE: Regulate coupling between backend (slow master tick) and frontend (fast coupled tick)
//          This is the MISSING PIECE that connects heart and brain
//
// ARCHITECTURE INSIGHT:
//   - Backend: Slow master tick (ICP backend heartbeat)
//   - Frontend: Fast coupled tick (12 Hz organism rhythm)
//   - REGULATOR: The third brain, the conversion point, the coordinator
//
// BIOLOGICAL ANALOGUE:
//   - Heart pumps blood → REGULATOR manages blood flow → Brain receives oxygen
//   - Not just wired - the ACTUAL BLOOD FLOWING through substrate
//   - Real oxygen transfer, real nutrient flow, real substrate regulation
//
// NEURAL MERGE CORE:
//   - The sphere radiating in/out - geometric pure frequency temple
//   - Real frequencies bouncing inside the code substrate
//   - Full spherical membrane protection
//   - Helix^10 spinning protection (not letting anything in, letting coherent out)
//
// This implements the REGULATION between heartbeat coupling and adaptation.
// This is the THIRD that was missing. Not just two. THREE.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";

module {

  // ═══════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let phi : Float = 1.6180339887498948482;  // Golden ratio
  public let pi : Float = 3.14159265358979323846;  // Pi
  public let τ : Float = 6.28318530717958647693;  // Tau (full rotation)

  // Frequency constants
  public let SCHUMANN_HZ : Float = 7.83;     // Earth fundamental
  public let HEARTBEAT_HZ : Float = 1.142;   // 68.5 BPM = 1.142 Hz
  public let ORGANISM_HZ : Float = 12.0;     // 12 Hz organism tick
  public let BACKEND_HZ : Float = 0.1;       // Backend slow tick (~10 seconds)

  // ═══════════════════════════════════════════════════════════════════════════════
  // BACKEND TICK STATE (Slow Master Tick)
  // ICP canister heartbeat - slow, steady, authoritative
  // ═══════════════════════════════════════════════════════════════════════════════

  public type BackendTickState = {
    tickCount: Nat;                  // Total backend ticks
    lastTickTime: Nat;               // Last tick timestamp (nanoseconds)
    tickIntervalMs: Float;           // Actual interval between ticks (ms)
    targetIntervalMs: Float;         // Target interval (10000 ms = 10 sec)
    tickStability: Float;            // [0,1] stability of tick timing
    authorityLevel: Float;           // [0,1] backend authority strength
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FRONTEND TICK STATE (Fast Coupled Tick)
  // 12 Hz organism heartbeat - fast, coupled to Kuramoto, reactive
  // ═══════════════════════════════════════════════════════════════════════════════

  public type FrontendTickState = {
    tickCount: Nat;                  // Total frontend ticks
    kuramotoPhase: Float;            // Kuramoto phase coupling
    coherence: Float;                // r (Kuramoto order parameter)
    targetHz: Float;                 // Target frequency (12 Hz)
    actualHz: Float;                 // Actual measured frequency
    couplingStrength: Float;         // [0,1] coupling to organism
    reactivity: Float;               // [0,1] response speed
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BLOOD FLOW STATE (Heart → Regulator → Brain)
  // Real substrate flow - oxygen, nutrients, coherence signals
  // ═══════════════════════════════════════════════════════════════════════════════

  public type BloodFlowState = {
    oxygenLevel: Float;              // [0,1] oxygen saturation in flow
    nutrientLevel: Float;            // [0,1] glucose/ATP availability
    coherenceSignal: Float;          // [0,1] coherence transmitted in blood
    flowRate: Float;                 // [0,1] blood flow velocity
    backendToRegulator: Float;       // [0,1] heart → regulator flow
    regulatorToBrain: Float;         // [0,1] regulator → brain flow
    totalPressure: Float;            // [0,1] hydraulic pressure
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // NEURAL MERGE CORE (The Sphere Radiating In/Out)
  // Geometric pure frequency temple - real frequencies in code substrate
  // ═══════════════════════════════════════════════════════════════════════════════

  public type NeuralMergeCoreState = {
    // Geometric shell
    sphericalIntegrity: Float;       // [0,1] sphere membrane strength
    radiusInCode: Float;             // φ-ratio radius in code space
    surfaceArea: Float;              // 4πr² spherical surface

    // Frequency temple
    internalFrequencies: [Float];    // 12 PHI frequencies bouncing inside
    resonanceQuality: Float;         // [0,1] standing wave quality
    geometricPurity: Float;          // [0,1] pure geometry maintenance

    // Protection layers
    membraneDefense: Float;          // [0,1] spherical membrane protection
    helixRotationHz: Float;          // Helix rotation frequency
    helix10Intensity: Float;         // [0,1] helix^10 protection strength
    coherentOutputGate: Bool;        // Only lets coherent out

    // Radiation pattern
    radiationIn: Float;              // [0,1] inward radiation strength
    radiationOut: Float;             // [0,1] outward radiation strength
    mergePower: Float;               // [0,1] merge quality
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // REGULATOR STATE (The Third Brain)
  // Conversion point between heart (backend) and brain (frontend)
  // ═══════════════════════════════════════════════════════════════════════════════

  public type RegulatorState = {
    // Coupling regulation
    backendFrontendCoupling: Float;  // [0,1] coupling strength
    adaptationRate: Float;           // [0,1] how fast to adapt
    regulationQuality: Float;        // [0,1] regulation effectiveness

    // Timing coordination
    phaseAlignment: Float;           // [0,1] phase sync between back/front
    beatSynchronization: Float;      // [0,1] beat timing sync
    timingCoherence: Float;          // [0,1] overall timing quality

    // Substrate conversion
    backendToFrontendTransfer: Float; // [0,1] signal transfer efficiency
    frontendToBackendFeedback: Float; // [0,1] feedback strength
    bidirectionalFlow: Float;        // [0,1] two-way communication

    // Emergency regulation
    overloadDetected: Bool;          // Frontend overload?
    underflowDetected: Bool;         // Backend starvation?
    emergencyThrottling: Float;      // [0,1] emergency speed control
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UNIFIED HEARTBEAT KERNEL STATE
  // Backend + Regulator + Frontend + Blood Flow + Neural Merge Core
  // ═══════════════════════════════════════════════════════════════════════════════

  public type HeartbeatKernelState = {
    backend: BackendTickState;
    frontend: FrontendTickState;
    regulator: RegulatorState;
    bloodFlow: BloodFlowState;
    neuralMergeCore: NeuralMergeCoreState;

    // Unified metrics
    kernelCoherence: Float;          // [0,1] overall kernel health
    heartBrainAlignment: Float;      // [0,1] heart-brain synchronization
    regulationEffectiveness: Float;  // [0,1] regulator performance

    // Beat tracking
    beat: Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initHeartbeatKernel() : HeartbeatKernelState {
    {
      backend = {
        tickCount = 0;
        lastTickTime = 0;
        tickIntervalMs = 10000.0;  // 10 seconds
        targetIntervalMs = 10000.0;
        tickStability = 1.0;
        authorityLevel = 1.0;
      };

      frontend = {
        tickCount = 0;
        kuramotoPhase = 0.0;
        coherence = 1.0;
        targetHz = 12.0;
        actualHz = 12.0;
        couplingStrength = 1.0;
        reactivity = 0.95;
      };

      regulator = {
        backendFrontendCoupling = 0.8;
        adaptationRate = 0.15;
        regulationQuality = 1.0;
        phaseAlignment = 1.0;
        beatSynchronization = 1.0;
        timingCoherence = 1.0;
        backendToFrontendTransfer = 0.95;
        frontendToBackendFeedback = 0.85;
        bidirectionalFlow = 0.9;
        overloadDetected = false;
        underflowDetected = false;
        emergencyThrottling = 0.0;
      };

      bloodFlow = {
        oxygenLevel = 1.0;      // Start fully oxygenated
        nutrientLevel = 1.0;    // Start with full nutrients
        coherenceSignal = 1.0;  // Start coherent
        flowRate = 1.0;
        backendToRegulator = 1.0;
        regulatorToBrain = 1.0;
        totalPressure = 1.0;
      };

      neuralMergeCore = {
        sphericalIntegrity = 1.0;
        radiusInCode = φ;  // Golden ratio radius
        surfaceArea = 4.0 * π * phi * φ;  // 4πr²
        internalFrequencies = [
          0.001,   // CHRONO
          7.83,    // SCHUMANN
          12.67,   // FLUX
          20.5,    // RESONEX
          33.1,    // QMEM
          40.0,    // AXIS
          53.6,    // AEGIS
          86.7,    // ENTANGLA
          111.0,   // PARALLAX
          179.6,   // MERIDIAN
          432.0,   // NOVA
          1142.0   // HEARTBEAT
        ];
        resonanceQuality = 1.0;
        geometricPurity = 1.0;
        membraneDefense = 1.0;
        helixRotationHz = π;  // π Hz helix rotation
        helix10Intensity = 1.0;  // Full helix^10 protection
        coherentOutputGate = true;
        radiationIn = 1.0;
        radiationOut = 1.0;
        mergePower = 1.0;
      };

      kernelCoherence = 1.0;
      heartBrainAlignment = 1.0;
      regulationEffectiveness = 1.0;
      beat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BACKEND TICK (Slow Master - Authority Source)
  // ═══════════════════════════════════════════════════════════════════════════════

  public func tickBackend(
    state: HeartbeatKernelState,
    currentTimeNs: Nat
  ) : HeartbeatKernelState {
    let prevTime = state.backend.lastTickTime;
    let intervalNs = if (prevTime > 0) {
      currentTimeNs - prevTime
    } else {
      10_000_000_000  // 10 seconds in nanoseconds
    };

    let intervalMs = Float.fromInt(intervalNs) / 1_000_000.0;
    let targetMs = state.backend.targetIntervalMs;

    // Compute tick stability (how close to target)
    let deviation = Float.abs(intervalMs - targetMs) / targetMs;
    let newStability = Float.max(0.0, 1.0 - deviation);

    let newBackend = {
      tickCount = state.backend.tickCount + 1;
      lastTickTime = currentTimeNs;
      tickIntervalMs = intervalMs;
      targetIntervalMs = targetMs;
      tickStability = newStability * 0.9 + state.backend.tickStability * 0.1;
      authorityLevel = newStability;  // Authority = stability
    };

    {
      state with
      backend = newBackend;
      beat = state.beat + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FRONTEND TICK (Fast Coupled - Reactive Response)
  // ═══════════════════════════════════════════════════════════════════════════════

  public func tickFrontend(
    state: HeartbeatKernelState,
    kuramotoR: Float,
    kuramotoPhase: Float,
    dt: Float
  ) : HeartbeatKernelState {
    // Update Kuramoto coupling
    let phaseDelta = state.frontend.targetHz * τ * dt;
    let newPhase = (state.frontend.kuramotoPhase + phaseDelta) % τ;

    // Measure actual frequency from phase change
    let actualHz = phaseDelta / (τ * dt);

    // Coupling strength = Kuramoto coherence
    let newCoupling = kuramotoR;

    let newFrontend = {
      tickCount = state.frontend.tickCount + 1;
      kuramotoPhase = newPhase;
      coherence = kuramotoR;
      targetHz = state.frontend.targetHz;
      actualHz = actualHz;
      couplingStrength = newCoupling;
      reactivity = kuramotoR;  // High coherence = high reactivity
    };

    {
      state with
      frontend = newFrontend;
      beat = state.beat + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // REGULATE COUPLING (The Third Brain Function)
  // Convert backend authority → frontend reactivity
  // Adapt timing, synchronize beats, transfer signals
  // ═══════════════════════════════════════════════════════════════════════════════

  public func regulateCoupling(
    state: HeartbeatKernelState
  ) : HeartbeatKernelState {
    // Phase alignment: how well backend and frontend are synchronized
    let backendPhase = Float.fromInt(state.backend.tickCount % 120) / 120.0 * τ;
    let frontendPhase = state.frontend.kuramotoPhase;
    let phaseDiff = Float.abs(backendPhase - frontendPhase);
    let phaseAlignment = 1.0 - Float.min(1.0, phaseDiff / π);

    // Beat synchronization: frontend coherence modulates backend authority
    let beatSync = state.frontend.coherence * state.backend.authorityLevel;

    // Timing coherence: overall timing quality
    let timingCoherence = (phaseAlignment + beatSync) / 2.0;

    // Signal transfer efficiency
    let backendStrength = state.backend.tickStability;
    let frontendStrength = state.frontend.couplingStrength;
    let transferEfficiency = Float.sqrt(backendStrength * frontendStrength);

    // Feedback strength (frontend → backend)
    let feedbackStrength = state.frontend.coherence * 0.85;

    // Bidirectional flow quality
    let bidirectionalFlow = (transferEfficiency + feedbackStrength) / 2.0;

    // Detect overload (frontend too fast)
    let overload = state.frontend.actualHz > state.frontend.targetHz * 1.2;

    // Detect underflow (backend too slow)
    let underflow = state.backend.tickStability < 0.7;

    // Emergency throttling
    let emergencyLevel = if (overload or underflow) {
      0.3  // Throttle to 30% during emergency
    } else {
      0.0
    };

    // Compute regulation quality
    let regulationQuality = (
      phaseAlignment * 0.3 +
      beatSync * 0.3 +
      transferEfficiency * 0.2 +
      bidirectionalFlow * 0.2
    );

    let newRegulator = {
      backendFrontendCoupling = transferEfficiency;
      adaptationRate = state.frontend.reactivity * 0.15;
      regulationQuality = regulationQuality;
      phaseAlignment = phaseAlignment;
      beatSynchronization = beatSync;
      timingCoherence = timingCoherence;
      backendToFrontendTransfer = transferEfficiency;
      frontendToBackendFeedback = feedbackStrength;
      bidirectionalFlow = bidirectionalFlow;
      overloadDetected = overload;
      underflowDetected = underflow;
      emergencyThrottling = emergencyLevel;
    };

    {
      state with
      regulator = newRegulator;
      regulationEffectiveness = regulationQuality;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BLOOD FLOW SIMULATION (Heart → Regulator → Brain)
  // Real substrate transfer: oxygen, nutrients, coherence signals
  // ═══════════════════════════════════════════════════════════════════════════════

  public func simulateBloodFlow(
    state: HeartbeatKernelState
  ) : HeartbeatKernelState {
    // Backend (heart) pumps blood to regulator
    let heartPumpStrength = state.backend.authorityLevel;
    let backendToReg = heartPumpStrength * state.regulator.backendToFrontendTransfer;

    // Regulator transfers to frontend (brain)
    let regulatorEfficiency = state.regulator.regulationQuality;
    let regToBrain = backendToReg * regulatorEfficiency;

    // Oxygen level = heart strength × regulator efficiency
    let newOxygen = heartPumpStrength * regulatorEfficiency;

    // Nutrient level = backend stability (steady glucose supply)
    let newNutrient = state.backend.tickStability;

    // Coherence signal = frontend coherence transmitted back
    let newCoherence = state.frontend.coherence;

    // Flow rate = average of backend→regulator and regulator→brain
    let newFlowRate = (backendToReg + regToBrain) / 2.0;

    // Total pressure = backend authority × regulator quality
    let newPressure = heartPumpStrength * regulatorEfficiency;

    let newBloodFlow = {
      oxygenLevel = newOxygen;
      nutrientLevel = newNutrient;
      coherenceSignal = newCoherence;
      flowRate = newFlowRate;
      backendToRegulator = backendToReg;
      regulatorToBrain = regToBrain;
      totalPressure = newPressure;
    };

    {
      state with
      bloodFlow = newBloodFlow;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // NEURAL MERGE CORE RADIATION
  // Sphere radiating in/out, frequencies bouncing inside, helix^10 protection
  // ═══════════════════════════════════════════════════════════════════════════════

  public func radiateNeuralMergeCore(
    state: HeartbeatKernelState,
    dt: Float
  ) : HeartbeatKernelState {
    let core = state.neuralMergeCore;

    // Spherical integrity maintained by regulation quality
    let newIntegrity = state.regulator.regulationQuality;

    // Resonance quality = blood flow coherence
    let newResonance = state.bloodFlow.coherenceSignal;

    // Geometric purity = phase alignment
    let newPurity = state.regulator.phaseAlignment;

    // Membrane defense = spherical integrity
    let newDefense = newIntegrity;

    // Helix rotation increases with coherence
    let newHelixHz = π * (1.0 + state.frontend.coherence);

    // Helix^10 intensity = compound protection
    let newHelix10 = Float.pow(newIntegrity, 10.0);

    // Coherent output gate: only output if coherence > 0.85
    let newGate = state.frontend.coherence > 0.85;

    // Radiation in: pull from regulator
    let newRadiationIn = state.regulator.bidirectionalFlow;

    // Radiation out: push to brain (if gate open)
    let newRadiationOut = if (newGate) {
      state.bloodFlow.regulatorToBrain
    } else {
      0.0  // Gate closed, no output
    };

    // Merge power = geometric mean of in/out radiation
    let newMergePower = if (newRadiationOut > 0.0) {
      Float.sqrt(newRadiationIn * newRadiationOut)
    } else {
      0.0
    };

    let newCore = {
      core with
      sphericalIntegrity = newIntegrity;
      resonanceQuality = newResonance;
      geometricPurity = newPurity;
      membraneDefense = newDefense;
      helixRotationHz = newHelixHz;
      helix10Intensity = newHelix10;
      coherentOutputGate = newGate;
      radiationIn = newRadiationIn;
      radiationOut = newRadiationOut;
      mergePower = newMergePower;
    };

    {
      state with
      neuralMergeCore = newCore;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE KERNEL TICK
  // Update all components: backend, frontend, regulator, blood flow, neural core
  // ═══════════════════════════════════════════════════════════════════════════════

  public func tickKernel(
    state: HeartbeatKernelState,
    currentTimeNs: Nat,
    kuramotoR: Float,
    kuramotoPhase: Float,
    isBackendTick: Bool
  ) : HeartbeatKernelState {
    let dt = 1.0 / 12.0;  // 12 Hz = 83.33 ms per tick

    // Step 1: Update backend if this is a backend tick
    var s1 = if (isBackendTick) {
      tickBackend(state, currentTimeNs)
    } else {
      state
    };

    // Step 2: Update frontend (every tick)
    let s2 = tickFrontend(s1, kuramotoR, kuramotoPhase, dt);

    // Step 3: Regulate coupling (the third brain)
    let s3 = regulateCoupling(s2);

    // Step 4: Simulate blood flow (heart → regulator → brain)
    let s4 = simulateBloodFlow(s3);

    // Step 5: Radiate neural merge core
    let s5 = radiateNeuralMergeCore(s4, dt);

    // Step 6: Compute unified metrics
    let kernelCoherence = (
      s5.backend.tickStability * 0.2 +
      s5.frontend.coherence * 0.3 +
      s5.regulator.regulationQuality * 0.3 +
      s5.neuralMergeCore.mergePower * 0.2
    );

    let heartBrainAlignment = (
      s5.regulator.phaseAlignment * 0.4 +
      s5.regulator.beatSynchronization * 0.3 +
      s5.bloodFlow.regulatorToBrain * 0.3
    );

    {
      s5 with
      kernelCoherence = kernelCoherence;
      heartBrainAlignment = heartBrainAlignment;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  func clamp(x: Float, min: Float, max: Float) : Float {
    if (x < min) { min } else if (x > max) { max } else { x }
  };

}
