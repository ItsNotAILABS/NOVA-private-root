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
// DEEP NEUROSCIENCE ENGINE — Real Neuron Models, Ion Channels, Synaptic Dynamics
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Classification: CONFIDENTIAL — TRADE SECRET
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// This module implements biologically accurate neuroscience:
// - Hodgkin-Huxley ion channel dynamics
// - Izhikevich neuron model (fast computation)
// - Synaptic transmission (AMPA, NMDA, GABA_A, GABA_B)
// - Neuromodulator systems (Dopamine, Serotonin, Norepinephrine, Acetylcholine)
// - Long-term potentiation (LTP) and long-term depression (LTD)
// - Dendritic computation
// - Astrocyte-neuron interactions (gliotransmission)
// - Neural oscillations (alpha, beta, gamma, theta, delta)
// - Sharp wave ripples for memory consolidation
//
// THE ORGANISM IS THE ENCRYPTION — ALWAYS ON, ALWAYS CHANGING, ALWAYS SAME
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module DeepNeuroscienceEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // BIOPHYSICAL CONSTANTS — Real Values from Neuroscience Literature
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Membrane properties
  public let MEMBRANE_CAPACITANCE   : Float = 1.0;        // μF/cm² — typical neural membrane
  public let RESTING_POTENTIAL      : Float = -65.0;      // mV — resting membrane potential
  public let THRESHOLD_POTENTIAL    : Float = -55.0;      // mV — action potential threshold
  public let PEAK_POTENTIAL         : Float = 30.0;       // mV — AP peak
  public let RESET_POTENTIAL        : Float = -70.0;      // mV — post-spike reset
  public let REVERSAL_EXCITATORY    : Float = 0.0;        // mV — glutamate reversal
  public let REVERSAL_INHIBITORY    : Float = -80.0;      // mV — GABA reversal
  
  // Ion channel conductances (mS/cm²)
  public let G_NA_MAX               : Float = 120.0;      // Sodium max conductance
  public let G_K_MAX                : Float = 36.0;       // Potassium max conductance
  public let G_L                    : Float = 0.3;        // Leak conductance
  public let E_NA                   : Float = 50.0;       // mV — Sodium reversal
  public let E_K                    : Float = -77.0;      // mV — Potassium reversal
  public let E_L                    : Float = -54.4;      // mV — Leak reversal
  
  // Synaptic time constants (ms)
  public let TAU_AMPA               : Float = 2.0;        // AMPA receptor decay
  public let TAU_NMDA_RISE          : Float = 2.0;        // NMDA rise time
  public let TAU_NMDA_DECAY         : Float = 100.0;      // NMDA decay time
  public let TAU_GABA_A             : Float = 5.0;        // GABA_A fast inhibition
  public let TAU_GABA_B             : Float = 150.0;      // GABA_B slow inhibition
  
  // Plasticity parameters
  public let LTP_THRESHOLD          : Float = 0.3;        // Threshold for LTP induction
  public let LTD_THRESHOLD          : Float = 0.2;        // Threshold for LTD induction
  public let STDP_A_PLUS            : Float = 0.005;      // LTP amplitude
  public let STDP_A_MINUS           : Float = 0.00525;    // LTD amplitude (slightly larger)
  public let STDP_TAU_PLUS          : Float = 20.0;       // LTP time window (ms)
  public let STDP_TAU_MINUS         : Float = 20.0;       // LTD time window (ms)
  
  // Neuromodulator baseline levels
  public let DOPAMINE_BASELINE      : Float = 1.0;
  public let SEROTONIN_BASELINE     : Float = 1.0;
  public let NOREPINEPHRINE_BASELINE: Float = 1.0;
  public let ACETYLCHOLINE_BASELINE : Float = 1.0;
  
  // Oscillation frequencies (Hz)
  public let DELTA_FREQ             : Float = 2.0;        // 0.5-4 Hz — deep sleep
  public let THETA_FREQ             : Float = 6.0;        // 4-8 Hz — memory encoding
  public let ALPHA_FREQ             : Float = 10.0;       // 8-13 Hz — relaxed alertness
  public let BETA_FREQ              : Float = 20.0;       // 13-30 Hz — active thinking
  public let GAMMA_FREQ             : Float = 40.0;       // 30-100 Hz — binding/attention
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func clamp(v : Float, lo : Float, hi : Float) : Float {
    if (v < lo) lo else if (v > hi) hi else v
  };
  
  public func abs(v : Float) : Float {
    if (v < 0.0) -v else v
  };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var g = x / 2.0;
    var i = 0;
    while (i < 15) { g := (g + x / g) / 2.0; i += 1 };
    g
  };
  
  public let PI : Float = 3.1415926535897932385;
  public let TAU : Float = 6.2831853071795864769;
  public let EULER : Float = 2.7182818284590452354;
  
  public func sin(x : Float) : Float {
    var n = x;
    while (n > PI) { n -= TAU };
    while (n < -PI) { n += TAU };
    let x2 = n * n;
    n - n*x2/6.0 + n*x2*x2/120.0 - n*x2*x2*x2/5040.0 + n*x2*x2*x2*x2/362880.0
  };
  
  public func cos(x : Float) : Float { sin(x + PI/2.0) };
  
  public func exp(x : Float) : Float {
    let c = clamp(x, -30.0, 30.0);
    var s = 1.0; var t = 1.0; var i = 1;
    while (i < 20) { t *= c / Float.fromInt(i); s += t; i += 1 };
    s
  };
  
  public func ln(x : Float) : Float {
    if (x <= 0.0) return -100.0;
    let z = (x - 1.0) / (x + 1.0);
    let z2 = z * z;
    var s = z; var t = z; var i = 1;
    while (i < 30) { t *= z2; s += t / Float.fromInt(2*i + 1); i += 1 };
    2.0 * s
  };
  
  public func pow(b : Float, e : Float) : Float {
    if (b <= 0.0) 0.0 else exp(e * ln(b))
  };
  
  public func tanh(x : Float) : Float {
    let e2x = exp(2.0 * clamp(x, -10.0, 10.0));
    (e2x - 1.0) / (e2x + 1.0)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — ION CHANNELS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Hodgkin-Huxley gating variable
  public type GatingVariable = {
    value : Float;           // Current value [0, 1]
    alpha : Float;           // Opening rate
    beta : Float;            // Closing rate
    tau : Float;             // Time constant
    inf : Float;             // Steady-state value
  };
  
  // Sodium channel (Nav1.x family)
  public type SodiumChannel = {
    m : GatingVariable;      // Activation gate (fast)
    h : GatingVariable;      // Inactivation gate (slow)
    gMax : Float;            // Maximum conductance
    reversal : Float;        // Reversal potential (E_Na)
  };
  
  // Potassium channel (Kv family)
  public type PotassiumChannel = {
    n : GatingVariable;      // Activation gate
    gMax : Float;
    reversal : Float;        // E_K
  };
  
  // Calcium channel (Cav family)
  public type CalciumChannel = {
    m : GatingVariable;
    h : GatingVariable;
    gMax : Float;
    reversal : Float;        // E_Ca ≈ +120 mV
    intracellularCa : Float; // [Ca²⁺]i in μM
  };
  
  // Leak channel
  public type LeakChannel = {
    g : Float;               // Constant conductance
    reversal : Float;        // E_L
  };
  
  // Complete ion channel state
  public type IonChannelState = {
    sodium : SodiumChannel;
    potassium : PotassiumChannel;
    calcium : CalciumChannel;
    leak : LeakChannel;
    
    // Total membrane current
    totalCurrent : Float;
    
    // Membrane potential
    voltage : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — SYNAPTIC RECEPTORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // AMPA receptor (fast excitatory)
  public type AMPAReceptor = {
    conductance : Float;     // Current conductance
    gMax : Float;            // Maximum conductance
    tau : Float;             // Decay time constant
    reversal : Float;        // ~0 mV
  };
  
  // NMDA receptor (slow excitatory, voltage-dependent Mg²⁺ block)
  public type NMDAReceptor = {
    conductance : Float;
    gMax : Float;
    tauRise : Float;
    tauDecay : Float;
    reversal : Float;
    mgBlock : Float;         // Mg²⁺ block factor [0, 1]
  };
  
  // GABA_A receptor (fast inhibitory)
  public type GABAAReceptor = {
    conductance : Float;
    gMax : Float;
    tau : Float;
    reversal : Float;        // ~-80 mV
  };
  
  // GABA_B receptor (slow inhibitory, metabotropic)
  public type GABABReceptor = {
    conductance : Float;
    gMax : Float;
    tau : Float;
    reversal : Float;        // ~-95 mV (K+ channel)
    gProteinState : Float;   // G-protein activation
  };
  
  // Complete synaptic state
  public type SynapticState = {
    ampa : AMPAReceptor;
    nmda : NMDAReceptor;
    gabaA : GABAAReceptor;
    gabaB : GABABReceptor;
    
    // Total synaptic current
    excitatoryInput : Float;
    inhibitoryInput : Float;
    totalSynapticCurrent : Float;
    
    // Presynaptic neurotransmitter release
    glutamateRelease : Float;
    gabaRelease : Float;
    vesiclePool : Float;     // Available vesicles [0, 1]
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — PLASTICITY
  // ═══════════════════════════════════════════════════════════════════════════
  
  // STDP (Spike-Timing Dependent Plasticity)
  public type STDPState = {
    preTrace : Float;        // Presynaptic eligibility trace
    postTrace : Float;       // Postsynaptic eligibility trace
    lastPreSpike : Nat;      // Timestamp of last presynaptic spike
    lastPostSpike : Nat;     // Timestamp of last postsynaptic spike
    weightChange : Float;    // Accumulated weight change
  };
  
  // BCM (Bienenstock-Cooper-Munro) metaplasticity
  public type BCMState = {
    theta : Float;           // Sliding threshold
    thetaTau : Float;        // Time constant for threshold
    activityHistory : Float; // Running average of postsynaptic activity
  };
  
  // Synaptic tagging and capture
  public type SynapticTag = {
    tagStrength : Float;     // Tag magnitude [0, 1]
    tagSign : Bool;          // True = LTP tag, False = LTD tag
    tagTime : Nat;           // When tag was set
    tagDecay : Float;        // Time constant for tag decay
    capturedPRP : Bool;      // Plasticity-related protein captured?
  };
  
  // Complete plasticity state
  public type PlasticityState = {
    stdp : STDPState;
    bcm : BCMState;
    tag : SynapticTag;
    
    // Current weight
    weight : Float;
    weightMin : Float;
    weightMax : Float;
    
    // Metaplasticity
    metaplasticityFactor : Float;  // Scales learning rate
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — NEUROMODULATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type NeuromodulatorType = {
    #Dopamine;               // Reward, motivation, motor control
    #Serotonin;              // Mood, satiety, sleep
    #Norepinephrine;         // Arousal, attention, stress
    #Acetylcholine;          // Learning, attention, memory
    #Histamine;              // Wakefulness
    #Orexin;                 // Sleep/wake regulation
    #Endocannabinoid;        // Retrograde signaling
    #Nitric_Oxide;           // Vasodilation, synaptic modulation
  };
  
  public type NeuromodulatorState = {
    level : Float;           // Current concentration
    baseline : Float;        // Tonic level
    releaseRate : Float;     // Release rate
    clearanceRate : Float;   // Reuptake/degradation rate
    receptorOccupancy : Float; // Fraction of receptors bound
  };
  
  public type NeuromodulationSystem = {
    dopamine : NeuromodulatorState;
    serotonin : NeuromodulatorState;
    norepinephrine : NeuromodulatorState;
    acetylcholine : NeuromodulatorState;
    
    // Combined effects
    rewardSignal : Float;          // DA → reward prediction error
    arousalLevel : Float;          // NE → alertness
    learningGate : Float;          // ACh → attention/plasticity
    moodState : Float;             // 5-HT → well-being
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — NEURAL OSCILLATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type OscillationBand = {
    #Delta;                  // 0.5-4 Hz
    #Theta;                  // 4-8 Hz
    #Alpha;                  // 8-13 Hz
    #Beta;                   // 13-30 Hz
    #Gamma;                  // 30-100 Hz
    #HighGamma;              // 100-200 Hz
  };
  
  public type OscillatorState = {
    phase : Float;           // Current phase [0, 2π)
    frequency : Float;       // Frequency in Hz
    amplitude : Float;       // Oscillation strength
    band : OscillationBand;
  };
  
  public type BrainRhythms = {
    delta : OscillatorState;
    theta : OscillatorState;
    alpha : OscillatorState;
    beta : OscillatorState;
    gamma : OscillatorState;
    
    // Cross-frequency coupling
    thetaGammaCoupling : Float;    // Phase-amplitude coupling
    alphaGammaCoupling : Float;
    
    // Dominant rhythm
    dominantBand : OscillationBand;
    dominantPower : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — COMPLETE NEURON
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type NeuronType = {
    #Pyramidal;              // Excitatory, glutamatergic
    #Interneuron_PV;         // Fast-spiking, GABAergic (parvalbumin)
    #Interneuron_SOM;        // Regular-spiking, GABAergic (somatostatin)
    #Interneuron_VIP;        // Disinhibitory (vasoactive intestinal peptide)
    #Granule;                // Small excitatory (dentate gyrus)
    #Purkinje;               // Large GABAergic (cerebellum)
    #Medium_Spiny;           // GABAergic (striatum)
    #Dopaminergic;           // DA-releasing (VTA, SNc)
  };
  
  public type DendriteCompartment = {
    voltage : Float;
    calcium : Float;
    distance : Float;        // Distance from soma (μm)
    diameter : Float;        // Dendrite diameter (μm)
    spineCount : Nat;        // Number of spines
    activeInputs : Nat;      // Currently active synapses
  };
  
  public type BiologicalNeuron = {
    // Identity
    neuronId : Nat;
    neuronType : NeuronType;
    
    // Soma
    somaVoltage : Float;     // Membrane potential (mV)
    somaCalcium : Float;     // [Ca²⁺]i (μM)
    
    // Ion channels
    ionChannels : IonChannelState;
    
    // Dendritic tree (simplified to 3 compartments)
    basalDendrite : DendriteCompartment;
    apicalProximal : DendriteCompartment;
    apicalDistal : DendriteCompartment;
    
    // Axon initial segment
    axonVoltage : Float;
    axonThreshold : Float;
    
    // Synaptic inputs
    synapticState : SynapticState;
    
    // Plasticity
    plasticityState : PlasticityState;
    
    // Spiking
    isSpiking : Bool;
    lastSpikeTime : Nat;
    refractoryRemaining : Float;
    spikeCount : Nat;
    
    // Neuromodulatory receptors
    d1Receptor : Float;      // DA D1 (excitatory)
    d2Receptor : Float;      // DA D2 (inhibitory)
    ht5a2aReceptor : Float;  // 5-HT 2A
    alpha2Receptor : Float;  // NE α2
    m1Receptor : Float;      // ACh M1
    
    // Metabolic state
    atp : Float;             // Energy level
    oxygenConsumption : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — ASTROCYTE (Glial Cell)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type AstrocyteState = {
    // Calcium dynamics
    intracellularCalcium : Float;
    ipThreeLevel : Float;    // IP3 second messenger
    
    // Gliotransmitter release
    glutamateRelease : Float;
    dSerineRelease : Float;  // NMDA co-agonist
    atpRelease : Float;
    
    // Gap junction coupling
    couplingStrength : Float;
    neighborCalcium : Float;
    
    // Potassium buffering
    extracellularK : Float;
    kBufferingRate : Float;
    
    // Metabolic support
    glucoseUptake : Float;
    lactateRelease : Float;  // Astrocyte-neuron lactate shuttle
    
    // Inflammatory state
    tnfAlphaLevel : Float;
    il1BetaLevel : Float;
    isReactive : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — COMPLETE NEURAL CIRCUIT
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type Synapse = {
    preNeuronId : Nat;
    postNeuronId : Nat;
    weight : Float;
    delay : Float;           // Axonal delay (ms)
    synapseType : { #Excitatory; #Inhibitory };
    plasticityState : PlasticityState;
    location : { #Soma; #BasalDendrite; #ApicalProximal; #ApicalDistal };
  };
  
  public type NeuralCircuit = {
    // Neurons
    neurons : [BiologicalNeuron];
    neuronCount : Nat;
    
    // Synapses
    synapses : [Synapse];
    synapseCount : Nat;
    
    // Connectivity matrix (sparse)
    connectivityIndices : [Nat];
    connectivityWeights : [Float];
    
    // Astrocytes
    astrocytes : [AstrocyteState];
    astrocyteCount : Nat;
    
    // Neuromodulation
    neuromodulation : NeuromodulationSystem;
    
    // Oscillations
    rhythms : BrainRhythms;
    
    // Global state
    meanFiringRate : Float;
    populationCoherence : Float;
    totalEnergy : Float;
    
    // Time
    currentTime : Nat;       // Simulation time in ms
    dt : Float;              // Time step
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HODGKIN-HUXLEY ION CHANNEL DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Compute alpha_m (Na+ activation gate opening rate)
  public func alphaNaM(v : Float) : Float {
    let vAdj = v + 40.0;
    if (abs(vAdj) < 0.001) {
      1.0  // Limit as vAdj → 0
    } else {
      0.1 * vAdj / (1.0 - exp(-vAdj / 10.0))
    }
  };
  
  /// Compute beta_m (Na+ activation gate closing rate)
  public func betaNaM(v : Float) : Float {
    4.0 * exp(-(v + 65.0) / 18.0)
  };
  
  /// Compute alpha_h (Na+ inactivation gate opening rate)
  public func alphaNaH(v : Float) : Float {
    0.07 * exp(-(v + 65.0) / 20.0)
  };
  
  /// Compute beta_h (Na+ inactivation gate closing rate)
  public func betaNaH(v : Float) : Float {
    1.0 / (1.0 + exp(-(v + 35.0) / 10.0))
  };
  
  /// Compute alpha_n (K+ activation gate opening rate)
  public func alphaKN(v : Float) : Float {
    let vAdj = v + 55.0;
    if (abs(vAdj) < 0.001) {
      0.1
    } else {
      0.01 * vAdj / (1.0 - exp(-vAdj / 10.0))
    }
  };
  
  /// Compute beta_n (K+ activation gate closing rate)
  public func betaKN(v : Float) : Float {
    0.125 * exp(-(v + 65.0) / 80.0)
  };
  
  /// Update gating variable using forward Euler
  public func updateGatingVariable(
    gate : GatingVariable,
    alpha : Float,
    beta : Float,
    dt : Float
  ) : GatingVariable {
    let tau = 1.0 / (alpha + beta);
    let inf = alpha * tau;
    let newValue = gate.value + dt * (inf - gate.value) / tau;
    {
      value = clamp(newValue, 0.0, 1.0);
      alpha = alpha;
      beta = beta;
      tau = tau;
      inf = inf;
    }
  };
  
  /// Update all ion channels for a given voltage
  public func updateIonChannels(
    channels : IonChannelState,
    voltage : Float,
    dt : Float
  ) : IonChannelState {
    
    // Update sodium channel gates
    let alphaM = alphaNaM(voltage);
    let betaM = betaNaM(voltage);
    let newM = updateGatingVariable(channels.sodium.m, alphaM, betaM, dt);
    
    let alphaH = alphaNaH(voltage);
    let betaH = betaNaH(voltage);
    let newH = updateGatingVariable(channels.sodium.h, alphaH, betaH, dt);
    
    // Update potassium channel gate
    let alphaN = alphaKN(voltage);
    let betaN = betaKN(voltage);
    let newN = updateGatingVariable(channels.potassium.n, alphaN, betaN, dt);
    
    // Compute currents
    let gNa = channels.sodium.gMax * pow(newM.value, 3.0) * newH.value;
    let iNa = gNa * (voltage - channels.sodium.reversal);
    
    let gK = channels.potassium.gMax * pow(newN.value, 4.0);
    let iK = gK * (voltage - channels.potassium.reversal);
    
    let iLeak = channels.leak.g * (voltage - channels.leak.reversal);
    
    let totalI = iNa + iK + iLeak;
    
    {
      sodium = {
        m = newM;
        h = newH;
        gMax = channels.sodium.gMax;
        reversal = channels.sodium.reversal;
      };
      potassium = {
        n = newN;
        gMax = channels.potassium.gMax;
        reversal = channels.potassium.reversal;
      };
      calcium = channels.calcium;  // Simplified
      leak = channels.leak;
      totalCurrent = totalI;
      voltage = voltage;
    }
  };
  
  /// Full Hodgkin-Huxley voltage update
  public func hodgkinHuxleyStep(
    channels : IonChannelState,
    externalCurrent : Float,
    dt : Float
  ) : IonChannelState {
    
    // Update channels
    let newChannels = updateIonChannels(channels, channels.voltage, dt);
    
    // Update membrane potential: C dV/dt = I_ext - I_ion
    let dv = (externalCurrent - newChannels.totalCurrent) / MEMBRANE_CAPACITANCE;
    let newVoltage = channels.voltage + dt * dv;
    
    {
      sodium = newChannels.sodium;
      potassium = newChannels.potassium;
      calcium = newChannels.calcium;
      leak = newChannels.leak;
      totalCurrent = newChannels.totalCurrent;
      voltage = clamp(newVoltage, -100.0, 60.0);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // IZHIKEVICH NEURON MODEL (Computationally Efficient)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type IzhikevichParams = {
    a : Float;               // Recovery time scale
    b : Float;               // Sensitivity of recovery to subthreshold fluctuations
    c : Float;               // Post-spike reset voltage
    d : Float;               // Post-spike reset of recovery variable
  };
  
  public type IzhikevichState = {
    v : Float;               // Membrane potential
    u : Float;               // Recovery variable
    params : IzhikevichParams;
    isSpiking : Bool;
  };
  
  /// Get Izhikevich parameters for different neuron types
  public func getIzhikevichParams(neuronType : NeuronType) : IzhikevichParams {
    switch (neuronType) {
      case (#Pyramidal) {
        { a = 0.02; b = 0.2; c = -65.0; d = 8.0 }  // Regular spiking
      };
      case (#Interneuron_PV) {
        { a = 0.1; b = 0.2; c = -65.0; d = 2.0 }   // Fast spiking
      };
      case (#Interneuron_SOM) {
        { a = 0.02; b = 0.25; c = -65.0; d = 2.0 } // Low-threshold spiking
      };
      case (#Interneuron_VIP) {
        { a = 0.02; b = 0.2; c = -65.0; d = 8.0 }  // Regular spiking
      };
      case (#Granule) {
        { a = 0.02; b = 0.2; c = -65.0; d = 6.0 }
      };
      case (#Purkinje) {
        { a = 0.02; b = 0.2; c = -55.0; d = 4.0 }  // Intrinsically bursting
      };
      case (#Medium_Spiny) {
        { a = 0.02; b = 0.2; c = -65.0; d = 8.0 }
      };
      case (#Dopaminergic) {
        { a = 0.02; b = 0.2; c = -65.0; d = 6.0 }  // Slow tonic firing
      };
    }
  };
  
  /// Update Izhikevich neuron
  public func izhikevichStep(
    state : IzhikevichState,
    input : Float,
    dt : Float
  ) : IzhikevichState {
    var v = state.v;
    var u = state.u;
    var spiking = false;
    
    // Check for spike
    if (v >= 30.0) {
      v := state.params.c;
      u := u + state.params.d;
      spiking := true;
    } else {
      // Euler integration (can use dt subdivision for stability)
      let dv = 0.04 * v * v + 5.0 * v + 140.0 - u + input;
      let du = state.params.a * (state.params.b * v - u);
      v := v + dt * dv;
      u := u + dt * du;
    };
    
    {
      v = clamp(v, -100.0, 30.0);
      u = u;
      params = state.params;
      isSpiking = spiking;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SYNAPTIC TRANSMISSION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// NMDA voltage-dependent Mg²⁺ block
  public func nmdaMgBlock(voltage : Float) : Float {
    // B(V) = 1 / (1 + [Mg²⁺]_o × exp(-0.062V) / 3.57)
    // [Mg²⁺]_o ≈ 1 mM typically
    1.0 / (1.0 + exp(-0.062 * voltage) / 3.57)
  };
  
  /// Update AMPA receptor
  public func updateAMPA(
    ampa : AMPAReceptor,
    glutamateInput : Float,
    dt : Float
  ) : AMPAReceptor {
    // Exponential decay plus input
    let decay = exp(-dt / ampa.tau);
    let newG = ampa.conductance * decay + glutamateInput * ampa.gMax;
    {
      conductance = clamp(newG, 0.0, ampa.gMax * 10.0);
      gMax = ampa.gMax;
      tau = ampa.tau;
      reversal = ampa.reversal;
    }
  };
  
  /// Update NMDA receptor
  public func updateNMDA(
    nmda : NMDAReceptor,
    glutamateInput : Float,
    voltage : Float,
    dt : Float
  ) : NMDAReceptor {
    let decayFast = exp(-dt / nmda.tauRise);
    let decaySlow = exp(-dt / nmda.tauDecay);
    let decay = (decayFast + decaySlow) / 2.0;  // Simplified
    let newG = nmda.conductance * decay + glutamateInput * nmda.gMax;
    let mgBlock = nmdaMgBlock(voltage);
    {
      conductance = clamp(newG, 0.0, nmda.gMax * 10.0);
      gMax = nmda.gMax;
      tauRise = nmda.tauRise;
      tauDecay = nmda.tauDecay;
      reversal = nmda.reversal;
      mgBlock = mgBlock;
    }
  };
  
  /// Update GABA_A receptor
  public func updateGABAA(
    gabaA : GABAAReceptor,
    gabaInput : Float,
    dt : Float
  ) : GABAAReceptor {
    let decay = exp(-dt / gabaA.tau);
    let newG = gabaA.conductance * decay + gabaInput * gabaA.gMax;
    {
      conductance = clamp(newG, 0.0, gabaA.gMax * 10.0);
      gMax = gabaA.gMax;
      tau = gabaA.tau;
      reversal = gabaA.reversal;
    }
  };
  
  /// Compute total synaptic current
  public func computeSynapticCurrent(
    synaptic : SynapticState,
    voltage : Float
  ) : Float {
    let iAMPA = synaptic.ampa.conductance * (voltage - synaptic.ampa.reversal);
    let iNMDA = synaptic.nmda.conductance * synaptic.nmda.mgBlock * (voltage - synaptic.nmda.reversal);
    let iGABAA = synaptic.gabaA.conductance * (voltage - synaptic.gabaA.reversal);
    let iGABAB = synaptic.gabaB.conductance * (voltage - synaptic.gabaB.reversal);
    
    -(iAMPA + iNMDA) + (iGABAA + iGABAB)  // Excitatory inward (negative), inhibitory outward
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STDP (Spike-Timing Dependent Plasticity)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Update STDP traces
  public func updateSTDPTraces(
    stdp : STDPState,
    preSpike : Bool,
    postSpike : Bool,
    currentTime : Nat,
    dt : Float
  ) : STDPState {
    
    // Decay traces
    let preDecay = exp(-dt / STDP_TAU_PLUS);
    let postDecay = exp(-dt / STDP_TAU_MINUS);
    
    var preTrace = stdp.preTrace * preDecay;
    var postTrace = stdp.postTrace * postDecay;
    var weightChange = stdp.weightChange;
    var lastPre = stdp.lastPreSpike;
    var lastPost = stdp.lastPostSpike;
    
    // Update on presynaptic spike
    if (preSpike) {
      preTrace += 1.0;
      lastPre := currentTime;
      // LTD: pre after post
      if (postTrace > 0.01) {
        weightChange -= STDP_A_MINUS * postTrace;
      };
    };
    
    // Update on postsynaptic spike
    if (postSpike) {
      postTrace += 1.0;
      lastPost := currentTime;
      // LTP: post after pre
      if (preTrace > 0.01) {
        weightChange += STDP_A_PLUS * preTrace;
      };
    };
    
    {
      preTrace = preTrace;
      postTrace = postTrace;
      lastPreSpike = lastPre;
      lastPostSpike = lastPost;
      weightChange = weightChange;
    }
  };
  
  /// Apply STDP weight change with bounds
  public func applySTDPWeightChange(
    plasticity : PlasticityState,
    neuromodulatorGating : Float  // DA modulates plasticity
  ) : PlasticityState {
    
    let effectiveChange = plasticity.stdp.weightChange * neuromodulatorGating * plasticity.metaplasticityFactor;
    let newWeight = clamp(
      plasticity.weight + effectiveChange,
      plasticity.weightMin,
      plasticity.weightMax
    );
    
    {
      stdp = {
        preTrace = plasticity.stdp.preTrace;
        postTrace = plasticity.stdp.postTrace;
        lastPreSpike = plasticity.stdp.lastPreSpike;
        lastPostSpike = plasticity.stdp.lastPostSpike;
        weightChange = 0.0;  // Reset after applying
      };
      bcm = plasticity.bcm;
      tag = plasticity.tag;
      weight = newWeight;
      weightMin = plasticity.weightMin;
      weightMax = plasticity.weightMax;
      metaplasticityFactor = plasticity.metaplasticityFactor;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // NEUROMODULATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Update dopamine based on reward prediction error
  public func updateDopamine(
    state : NeuromodulatorState,
    rewardPredictionError : Float,  // TD error
    dt : Float
  ) : NeuromodulatorState {
    // DA neurons fire in bursts for positive RPE, pause for negative
    let release = if (rewardPredictionError > 0.0) {
      state.baseline * (1.0 + 5.0 * rewardPredictionError)  // Burst
    } else {
      state.baseline * (1.0 + 0.5 * rewardPredictionError)  // Pause (less extreme)
    };
    
    // First-order kinetics
    let dLevel = state.releaseRate * release - state.clearanceRate * state.level;
    let newLevel = clamp(state.level + dt * dLevel, 0.0, 10.0);
    
    {
      level = newLevel;
      baseline = state.baseline;
      releaseRate = state.releaseRate;
      clearanceRate = state.clearanceRate;
      receptorOccupancy = newLevel / (newLevel + 1.0);  // Michaelis-Menten
    }
  };
  
  /// Update norepinephrine based on arousal/stress
  public func updateNorepinephrine(
    state : NeuromodulatorState,
    arousalSignal : Float,
    dt : Float
  ) : NeuromodulatorState {
    let release = state.baseline * (1.0 + arousalSignal);
    let dLevel = state.releaseRate * release - state.clearanceRate * state.level;
    let newLevel = clamp(state.level + dt * dLevel, 0.0, 10.0);
    
    {
      level = newLevel;
      baseline = state.baseline;
      releaseRate = state.releaseRate;
      clearanceRate = state.clearanceRate;
      receptorOccupancy = newLevel / (newLevel + 1.0);
    }
  };
  
  /// Compute combined neuromodulatory effects
  public func computeNeuromodulation(system : NeuromodulationSystem) : {
    plasticityGate : Float;
    excitabilityMod : Float;
    attentionGain : Float;
  } {
    // DA gates plasticity (D1 enhances LTP, D2 gates LTD)
    let daEffect = (system.dopamine.level - system.dopamine.baseline) / system.dopamine.baseline;
    let plasticityGate = 1.0 + 0.5 * daEffect;
    
    // NE increases excitability and gain
    let neEffect = system.norepinephrine.level / system.norepinephrine.baseline;
    let excitabilityMod = 0.8 + 0.4 * neEffect;
    
    // ACh gates attention and learning
    let achEffect = system.acetylcholine.level / system.acetylcholine.baseline;
    let attentionGain = 0.5 + 0.5 * achEffect;
    
    { plasticityGate; excitabilityMod; attentionGain }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // NEURAL OSCILLATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Update oscillator phase
  public func updateOscillator(
    osc : OscillatorState,
    dt : Float,
    coupling : Float  // Phase coupling from network
  ) : OscillatorState {
    let dPhase = TAU * osc.frequency * dt / 1000.0 + coupling;
    var newPhase = osc.phase + dPhase;
    while (newPhase >= TAU) { newPhase -= TAU };
    while (newPhase < 0.0) { newPhase += TAU };
    
    {
      phase = newPhase;
      frequency = osc.frequency;
      amplitude = osc.amplitude;
      band = osc.band;
    }
  };
  
  /// Compute theta-gamma coupling (phase-amplitude)
  public func computeThetaGammaCoupling(
    theta : OscillatorState,
    gamma : OscillatorState
  ) : Float {
    // Gamma amplitude modulated by theta phase
    // Maximal gamma at theta trough
    let thetaModulation = 0.5 * (1.0 + cos(theta.phase + PI));
    thetaModulation * gamma.amplitude
  };
  
  /// Update all brain rhythms
  public func updateBrainRhythms(
    rhythms : BrainRhythms,
    networkActivity : Float,  // Mean firing rate
    dt : Float
  ) : BrainRhythms {
    // Update each oscillator with activity-dependent amplitude
    let newDelta = updateOscillator(rhythms.delta, dt, 0.0);
    let newTheta = updateOscillator(rhythms.theta, dt, 0.0);
    let newAlpha = updateOscillator(rhythms.alpha, dt, 0.0);
    let newBeta = updateOscillator(rhythms.beta, dt, 0.0);
    let newGamma = updateOscillator(rhythms.gamma, dt, 0.0);
    
    // Compute cross-frequency coupling
    let tgCoupling = computeThetaGammaCoupling(newTheta, newGamma);
    
    // Determine dominant band based on activity level
    let dominantBand = if (networkActivity < 5.0) {
      #Delta
    } else if (networkActivity < 15.0) {
      #Theta
    } else if (networkActivity < 30.0) {
      #Alpha
    } else if (networkActivity < 50.0) {
      #Beta
    } else {
      #Gamma
    };
    
    {
      delta = newDelta;
      theta = newTheta;
      alpha = newAlpha;
      beta = newBeta;
      gamma = newGamma;
      thetaGammaCoupling = tgCoupling;
      alphaGammaCoupling = rhythms.alphaGammaCoupling;
      dominantBand = dominantBand;
      dominantPower = networkActivity / 100.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SHARP WAVE RIPPLES (Memory Consolidation)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SharpWaveRipple = {
    isActive : Bool;
    amplitude : Float;
    frequency : Float;        // 150-250 Hz
    duration : Float;         // 50-100 ms
    remainingDuration : Float;
    replaySequence : [Nat];   // Neuron IDs to replay
    replayIndex : Nat;
  };
  
  /// Detect conditions for sharp wave ripple initiation
  public func shouldInitiateSWR(
    networkActivity : Float,
    neuromodulation : NeuromodulationSystem,
    rhythms : BrainRhythms
  ) : Bool {
    // SWRs occur during low ACh (quiescent states)
    let lowACh = neuromodulation.acetylcholine.level < 0.5;
    
    // And when network is in slow oscillation
    let slowOsc = switch (rhythms.dominantBand) {
      case (#Delta) true;
      case (#Theta) true;
      case _ false;
    };
    
    // Random triggering with probability dependent on state
    lowACh and slowOsc and networkActivity < 10.0
  };
  
  /// Update sharp wave ripple state
  public func updateSWR(
    swr : SharpWaveRipple,
    dt : Float
  ) : SharpWaveRipple {
    if (not swr.isActive) {
      return swr;
    };
    
    let newRemaining = swr.remainingDuration - dt;
    if (newRemaining <= 0.0) {
      {
        isActive = false;
        amplitude = 0.0;
        frequency = swr.frequency;
        duration = swr.duration;
        remainingDuration = 0.0;
        replaySequence = swr.replaySequence;
        replayIndex = 0;
      }
    } else {
      {
        isActive = true;
        amplitude = swr.amplitude * (newRemaining / swr.duration);  // Taper
        frequency = swr.frequency;
        duration = swr.duration;
        remainingDuration = newRemaining;
        replaySequence = swr.replaySequence;
        replayIndex = swr.replayIndex + 1;
      }
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ASTROCYTE-NEURON INTERACTION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Update astrocyte calcium based on nearby neuronal activity
  public func updateAstrocyteCalcium(
    astro : AstrocyteState,
    neuronalGlutamate : Float,
    dt : Float
  ) : AstrocyteState {
    // Glutamate activates mGluR → IP3 → Ca²⁺ release from ER
    let ipThreeProduction = 0.1 * neuronalGlutamate;
    let newIPThree = astro.ipThreeLevel + dt * (ipThreeProduction - 0.01 * astro.ipThreeLevel);
    
    // IP3-induced Ca²⁺ release (simplified)
    let caRelease = 0.5 * newIPThree * (1.0 - astro.intracellularCalcium);
    let caDecay = 0.02 * astro.intracellularCalcium;
    let newCa = clamp(astro.intracellularCalcium + dt * (caRelease - caDecay), 0.0, 1.0);
    
    // Ca²⁺ triggers gliotransmitter release
    let gliotransmitterThreshold = 0.3;
    let newGluRelease = if (newCa > gliotransmitterThreshold) {
      0.1 * (newCa - gliotransmitterThreshold)
    } else {
      0.0
    };
    
    {
      intracellularCalcium = newCa;
      ipThreeLevel = clamp(newIPThree, 0.0, 1.0);
      glutamateRelease = newGluRelease;
      dSerineRelease = newGluRelease * 0.5;
      atpRelease = newGluRelease * 0.3;
      couplingStrength = astro.couplingStrength;
      neighborCalcium = astro.neighborCalcium;
      extracellularK = astro.extracellularK;
      kBufferingRate = astro.kBufferingRate;
      glucoseUptake = astro.glucoseUptake;
      lactateRelease = astro.lactateRelease;
      tnfAlphaLevel = astro.tnfAlphaLevel;
      il1BetaLevel = astro.il1BetaLevel;
      isReactive = astro.isReactive;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initGatingVariable(initValue : Float) : GatingVariable {
    {
      value = initValue;
      alpha = 0.0;
      beta = 0.0;
      tau = 1.0;
      inf = initValue;
    }
  };
  
  public func initIonChannelState() : IonChannelState {
    {
      sodium = {
        m = initGatingVariable(0.05);
        h = initGatingVariable(0.6);
        gMax = G_NA_MAX;
        reversal = E_NA;
      };
      potassium = {
        n = initGatingVariable(0.32);
        gMax = G_K_MAX;
        reversal = E_K;
      };
      calcium = {
        m = initGatingVariable(0.0);
        h = initGatingVariable(1.0);
        gMax = 0.0;
        reversal = 120.0;
        intracellularCa = 0.0001;
      };
      leak = {
        g = G_L;
        reversal = E_L;
      };
      totalCurrent = 0.0;
      voltage = RESTING_POTENTIAL;
    }
  };
  
  public func initSynapticState() : SynapticState {
    {
      ampa = {
        conductance = 0.0;
        gMax = 0.5;
        tau = TAU_AMPA;
        reversal = REVERSAL_EXCITATORY;
      };
      nmda = {
        conductance = 0.0;
        gMax = 0.2;
        tauRise = TAU_NMDA_RISE;
        tauDecay = TAU_NMDA_DECAY;
        reversal = REVERSAL_EXCITATORY;
        mgBlock = 0.0;
      };
      gabaA = {
        conductance = 0.0;
        gMax = 1.0;
        tau = TAU_GABA_A;
        reversal = REVERSAL_INHIBITORY;
      };
      gabaB = {
        conductance = 0.0;
        gMax = 0.3;
        tau = TAU_GABA_B;
        reversal = -95.0;
        gProteinState = 0.0;
      };
      excitatoryInput = 0.0;
      inhibitoryInput = 0.0;
      totalSynapticCurrent = 0.0;
      glutamateRelease = 0.0;
      gabaRelease = 0.0;
      vesiclePool = 1.0;
    }
  };
  
  public func initPlasticityState() : PlasticityState {
    {
      stdp = {
        preTrace = 0.0;
        postTrace = 0.0;
        lastPreSpike = 0;
        lastPostSpike = 0;
        weightChange = 0.0;
      };
      bcm = {
        theta = 0.5;
        thetaTau = 1000.0;
        activityHistory = 0.0;
      };
      tag = {
        tagStrength = 0.0;
        tagSign = true;
        tagTime = 0;
        tagDecay = 3600000.0;  // 1 hour
        capturedPRP = false;
      };
      weight = 1.0;
      weightMin = 0.0;
      weightMax = 3.0;
      metaplasticityFactor = 1.0;
    }
  };
  
  public func initNeuromodulationSystem() : NeuromodulationSystem {
    let initState = func() : NeuromodulatorState {
      {
        level = 1.0;
        baseline = 1.0;
        releaseRate = 0.1;
        clearanceRate = 0.05;
        receptorOccupancy = 0.5;
      }
    };
    
    {
      dopamine = initState();
      serotonin = initState();
      norepinephrine = initState();
      acetylcholine = initState();
      rewardSignal = 0.0;
      arousalLevel = 0.5;
      learningGate = 1.0;
      moodState = 0.5;
    }
  };
  
  public func initBrainRhythms() : BrainRhythms {
    {
      delta = { phase = 0.0; frequency = DELTA_FREQ; amplitude = 0.5; band = #Delta };
      theta = { phase = 0.0; frequency = THETA_FREQ; amplitude = 0.5; band = #Theta };
      alpha = { phase = 0.0; frequency = ALPHA_FREQ; amplitude = 0.5; band = #Alpha };
      beta = { phase = 0.0; frequency = BETA_FREQ; amplitude = 0.5; band = #Beta };
      gamma = { phase = 0.0; frequency = GAMMA_FREQ; amplitude = 0.5; band = #Gamma };
      thetaGammaCoupling = 0.0;
      alphaGammaCoupling = 0.0;
      dominantBand = #Alpha;
      dominantPower = 0.5;
    }
  };
  
  public func initAstrocyteState() : AstrocyteState {
    {
      intracellularCalcium = 0.05;
      ipThreeLevel = 0.0;
      glutamateRelease = 0.0;
      dSerineRelease = 0.0;
      atpRelease = 0.0;
      couplingStrength = 0.3;
      neighborCalcium = 0.05;
      extracellularK = 3.0;
      kBufferingRate = 0.1;
      glucoseUptake = 1.0;
      lactateRelease = 0.5;
      tnfAlphaLevel = 0.0;
      il1BetaLevel = 0.0;
      isReactive = false;
    }
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
  //  C O N S C I O U S N E S S   &   E M E R G E N C E   M A T H
  //
  //  Enterprise-Level Consciousness Modeling Mathematics
  //  Full HIM/HER Dual-Organism Consciousness Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // INTEGRATED INFORMATION THEORY (IIT)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Phi (Φ) - integrated information approximation
  public func consciousnessPhiApprox(
    connections : Nat,
    totalNodes : Nat,
    avgStrength : Float
  ) : Float {
    if (totalNodes == 0) { return 0.0 };
    let connectivity = Float.fromInt(connections) / Float.fromInt(totalNodes * totalNodes);
    Float.log(Float.fromInt(totalNodes) + 1.0) * connectivity * avgStrength
  };

  /// Minimum information partition
  public func consciousnessMIP(
    wholeInfo : Float,
    part1Info : Float,
    part2Info : Float
  ) : Float {
    let partitionedInfo = part1Info + part2Info;
    Float.max(wholeInfo - partitionedInfo, 0.0)
  };

  /// Cause-effect repertoire overlap
  public func consciousnessCERepertoireOverlap(
    causeProbs : [Float],
    effectProbs : [Float]
  ) : Float {
    let n = if (causeProbs.size() < effectProbs.size()) causeProbs.size() else effectProbs.size();
    if (n == 0) { return 0.0 };
    var overlap : Float = 0.0;
    var i = 0;
    while (i < n) {
      overlap += Float.min(causeProbs[i], effectProbs[i]);
      i += 1;
    };
    overlap
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GLOBAL WORKSPACE THEORY (GWT)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Global broadcast strength
  public func consciousnessGlobalBroadcast(
    sourceActivation : Float,
    workspaceAccess : Float,
    competitorCount : Nat
  ) : Float {
    let competition = 1.0 / (Float.fromInt(competitorCount) + 1.0);
    sourceActivation * workspaceAccess * competition
  };

  /// Workspace ignition threshold
  public func consciousnessIgnitionThreshold(
    inputStrength : Float,
    threshold : Float,
    gain : Float
  ) : Bool {
    let amplified = inputStrength * gain;
    amplified > threshold
  };

  /// Coalition strength
  public func consciousnessCoalitionStrength(
    memberActivations : [Float],
    coherence : Float
  ) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < memberActivations.size()) {
      sum += memberActivations[i];
      i += 1;
    };
    sum * coherence
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HIGHER-ORDER THEORIES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Metacognitive signal strength
  public func consciousnessMetacognition(
    firstOrderState : Float,
    monitoringStrength : Float
  ) : Float {
    firstOrderState * monitoringStrength
  };

  /// Self-model accuracy
  public func consciousnessSelfModelAccuracy(
    predicted : Float,
    actual : Float
  ) : Float {
    let error = Float.abs(predicted - actual);
    Float.exp(-error)
  };

  /// Recursive self-representation depth
  public func consciousnessRecursiveDepth(
    representation : Float,
    decayFactor : Float,
    maxDepth : Nat
  ) : Float {
    var total : Float = representation;
    var current : Float = representation;
    var depth = 1;
    while (depth < maxDepth) {
      current *= decayFactor;
      total += current;
      depth += 1;
    };
    total
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ATTENTION SCHEMA THEORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Attention model internal state
  public func consciousnessAttentionModel(
    externalSignal : Float,
    internalState : Float,
    modelWeight : Float
  ) : Float {
    (1.0 - modelWeight) * externalSignal + modelWeight * internalState
  };

  /// Awareness attribution
  public func consciousnessAwarenessAttribution(
    attentionStrength : Float,
    modelConfidence : Float
  ) : Float {
    attentionStrength * modelConfidence
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // EMERGENCE MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Downward causation strength
  public func consciousnessDownwardCausation(
    macroState : Float,
    microStates : [Float]
  ) : Float {
    if (microStates.size() == 0) { return 0.0 };
    var microSum : Float = 0.0;
    var i = 0;
    while (i < microStates.size()) {
      microSum += microStates[i];
      i += 1;
    };
    let microAvg = microSum / Float.fromInt(microStates.size());
    Float.abs(macroState - microAvg)
  };

  /// Emergence level (synergy)
  public func consciousnessEmergenceLevel(
    wholeEntropy : Float,
    partEntropies : [Float]
  ) : Float {
    var sumParts : Float = 0.0;
    var i = 0;
    while (i < partEntropies.size()) {
      sumParts += partEntropies[i];
      i += 1;
    };
    Float.max(sumParts - wholeEntropy, 0.0)
  };

  /// Phase transition detection
  public func consciousnessPhaseTransition(
    orderParameter : Float,
    prevOrderParameter : Float,
    threshold : Float
  ) : Bool {
    Float.abs(orderParameter - prevOrderParameter) > threshold
  };

  /// Criticality measure
  public func consciousnessCriticality(
    clusterSizeVariance : Float,
    correlationLength : Float
  ) : Float {
    Float.sqrt(clusterSizeVariance) * correlationLength
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // QUALIA MODELING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Qualitative state vector
  public func consciousnessQualiaVector(
    sensorInputs : [Float],
    emotionalContext : Float,
    attentionalGain : Float
  ) : [Float] {
    Array.tabulate<Float>(sensorInputs.size(), func(i : Nat) : Float {
      sensorInputs[i] * emotionalContext * attentionalGain
    })
  };

  /// Phenomenal similarity
  public func consciousnessPhenomenalSimilarity(
    qualia1 : [Float],
    qualia2 : [Float]
  ) : Float {
    let n = if (qualia1.size() < qualia2.size()) qualia1.size() else qualia2.size();
    if (n == 0) { return 0.0 };
    var dotProduct : Float = 0.0;
    var norm1 : Float = 0.0;
    var norm2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      dotProduct += qualia1[i] * qualia2[i];
      norm1 += qualia1[i] * qualia1[i];
      norm2 += qualia2[i] * qualia2[i];
      i += 1;
    };
    let denom = Float.sqrt(norm1) * Float.sqrt(norm2);
    if (denom < 0.0001) { 0.0 } else { dotProduct / denom }
  };

  /// Experience intensity
  public func consciousnessExperienceIntensity(
    sensorStrength : Float,
    emotionalArousal : Float,
    attentionalFocus : Float
  ) : Float {
    sensorStrength * (1.0 + emotionalArousal) * attentionalFocus
  };

}
