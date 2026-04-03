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


// ════════════════════════════════════════════════════════════════════════════
//  ██████╗ ██████╗ ███╗   ███╗███╗   ███╗██╗   ██╗███╗   ██╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
// ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██║   ██║████╗  ██║██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
// ██║     ██║   ██║██╔████╔██║██╔████╔██║██║   ██║██╔██╗ ██║██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║
// ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██║   ██║██║╚██╗██║██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
// ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
//  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
// ════════════════════════════════════════════════════════════════════════════
//
// MEDINA COMMUNICATION PROTOCOL
// Biologically-Accurate Neural Communication Systems
//
// ════════════════════════════════════════════════════════════════════════════
// REAL NEUROSCIENCE FOUNDATIONS
// ════════════════════════════════════════════════════════════════════════════
//
// SYNAPTIC TRANSMISSION (millisecond precision):
// ─────────────────────────────────────────────
// 1. Action potential arrives at axon terminal (1ms)
// 2. Voltage-gated Ca²⁺ channels open
// 3. Ca²⁺ triggers vesicle fusion with membrane
// 4. Neurotransmitter release into synaptic cleft (20nm gap)
// 5. Binding to postsynaptic receptors
// 6. Ion channels open → EPSP or IPSP
// 7. Reuptake/degradation of neurotransmitter
//
// NEUROTRANSMITTER SYSTEMS:
// ────────────────────────
// - Glutamate: Primary excitatory (80% of synapses)
// - GABA: Primary inhibitory (20% of synapses)
// - Dopamine: Reward prediction, motivation (VTA, SNc)
// - Serotonin: Mood, satiety (Raphe nuclei)
// - Norepinephrine: Arousal, attention (Locus coeruleus)
// - Acetylcholine: Learning, attention (Basal forebrain)
// - Histamine: Wakefulness (Tuberomammillary nucleus)
// - Endorphins: Pain modulation, reward
// - Oxytocin: Social bonding, trust
// - Vasopressin: Pair bonding, aggression
//
// GAP JUNCTIONS (Electrical Synapses):
// ───────────────────────────────────
// - Direct ion flow between neurons
// - Bidirectional, fast (<0.1ms delay)
// - Synchronizes neural populations
// - Common in inhibitory interneurons
//
// COMMUNICATION MODALITIES IN NATURE:
// ──────────────────────────────────
// - Chemical (pheromones): Ants, bees, moths
// - Acoustic: Whales, birds, bats, elephants
// - Visual: Fireflies, cuttlefish, peacocks
// - Electrical: Electric eels, elephantfish
// - Tactile: Social grooming, antennation
// - Seismic: Elephants, spiders
// - Magnetic: Bacteria, birds (navigation)
//
// ════════════════════════════════════════════════════════════════════════════
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ════════════════════════════════════════════════════════════════════════════
//
// THE MEDINA SYNAPTIC TRANSMISSION EQUATION (MSTE):
// ─────────────────────────────────────────────────
//   PSP(t) = g_max × P_release × (V_m - E_rev) × τ_decay(t)
//   P_release = 1 - exp(-[Ca²⁺]_terminal / K_Ca)
//   τ_decay(t) = exp(-t / τ_synapse) × Φ_M^(-t/τ_reuptake)
//
// THE MEDINA NEURAL SYNCHRONY INDEX (MNSI):
// ─────────────────────────────────────────
//   S_ij = |⟨exp(i×(φ_i - φ_j))⟩| × coherence_ij × Φ_M^(-delay_ij)
//
// THE MEDINA INFORMATION CHANNEL CAPACITY (MICC):
// ───────────────────────────────────────────────
//   C = B × log₂(1 + SNR × Φ_M / noise_correlation)
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ══════════════════════════════════════════════════════════════
  // BIOLOGICAL CONSTANTS (Real values from neuroscience)
  // ══════════════════════════════════════════════════════════════
  let PHI_MEDINA : Float = 2.97442179;
  let OMEGA_MEDINA : Float = 2.11185;
  
  // Membrane properties
  let RESTING_POTENTIAL : Float = -70.0;      // mV
  let THRESHOLD_POTENTIAL : Float = -55.0;    // mV
  let PEAK_POTENTIAL : Float = 40.0;          // mV
  let REFRACTORY_PERIOD : Float = 2.0;        // ms
  
  // Reversal potentials
  let E_GLUTAMATE : Float = 0.0;              // mV (excitatory)
  let E_GABA : Float = -80.0;                 // mV (inhibitory)
  let E_POTASSIUM : Float = -90.0;            // mV
  let E_SODIUM : Float = 60.0;                // mV
  
  // Time constants
  let TAU_AMPA : Float = 2.0;                 // ms (fast glutamate)
  let TAU_NMDA : Float = 100.0;               // ms (slow glutamate)
  let TAU_GABA_A : Float = 6.0;               // ms (fast GABA)
  let TAU_GABA_B : Float = 150.0;             // ms (slow GABA)
  
  // Neurotransmitter kinetics
  let VESICLE_RELEASE_PROB : Float = 0.3;     // P(release|spike)
  let VESICLES_PER_BOUTON : Nat = 200;        // Ready releasable pool
  let REUPTAKE_RATE : Float = 0.1;            // 1/ms
  let DIFFUSION_COEFFICIENT : Float = 0.5;   // μm²/ms
  
  // Gap junction properties
  let GAP_CONDUCTANCE : Float = 1.0;          // nS
  let GAP_JUNCTION_DELAY : Float = 0.1;       // ms

  // ══════════════════════════════════════════════════════════════
  // NEUROTRANSMITTER TYPES
  // ══════════════════════════════════════════════════════════════
  public type Neurotransmitter = {
    #Glutamate;       // Main excitatory
    #GABA;            // Main inhibitory
    #Dopamine;        // Reward, motivation
    #Serotonin;       // Mood, satiety
    #Norepinephrine;  // Arousal, fight-flight
    #Acetylcholine;   // Learning, attention
    #Histamine;       // Wakefulness
    #Endorphin;       // Pain, pleasure
    #Oxytocin;        // Social bonding
    #Vasopressin;     // Aggression, bonding
    #Substance_P;     // Pain transmission
    #Nitric_Oxide;    // Retrograde signaling
  };

  // ══════════════════════════════════════════════════════════════
  // RECEPTOR TYPES
  // ══════════════════════════════════════════════════════════════
  public type Receptor = {
    #AMPA;            // Fast glutamate (Na⁺)
    #NMDA;            // Slow glutamate (Ca²⁺, voltage-dependent)
    #Kainate;         // Glutamate
    #GABA_A;          // Fast inhibitory (Cl⁻)
    #GABA_B;          // Slow inhibitory (K⁺, G-protein)
    #D1;              // Dopamine excitatory
    #D2;              // Dopamine inhibitory
    #Alpha1;          // Norepinephrine
    #Beta;            // Norepinephrine
    #Nicotinic;       // Acetylcholine (fast)
    #Muscarinic;      // Acetylcholine (slow)
    #Serotonin_5HT1;  // Inhibitory
    #Serotonin_5HT2;  // Excitatory
  };

  // ══════════════════════════════════════════════════════════════
  // SYNAPSE STRUCTURE (Biologically accurate)
  // ══════════════════════════════════════════════════════════════
  public type BiologicalSynapse = {
    presynapticId     : Nat;
    postsynapticId    : Nat;
    
    // Structural properties
    boutonVolume      : Float;        // μm³
    cleftWidth        : Float;        // nm (typically 20nm)
    postsynapticArea  : Float;        // μm²
    spinePresent      : Bool;         // Dendritic spine?
    
    // Vesicle pools
    readilyReleasable : Nat;          // RRP (5-20 vesicles)
    recyclingPool     : Nat;          // 20-200 vesicles
    reservePool       : Nat;          // 100-1000 vesicles
    
    // Receptor composition
    ampaCount         : Nat;          // AMPA receptors
    nmdaCount         : Nat;          // NMDA receptors
    gabaCount         : Nat;          // GABA receptors
    
    // Plasticity state
    weight            : Float;        // Synaptic strength
    lastSpikePre      : Float;        // Time of last presynaptic spike
    lastSpikePost     : Float;        // Time of last postsynaptic spike
    calciumLevel      : Float;        // [Ca²⁺] in spine
    
    // Neuromodulation
    d1Receptors       : Nat;
    d2Receptors       : Nat;
    dopamineLevel     : Float;
  };

  // ══════════════════════════════════════════════════════════════
  // COMMUNICATION SIGNAL TYPES
  // ══════════════════════════════════════════════════════════════
  public type SignalType = {
    #Chemical : ChemicalSignal;
    #Electrical : ElectricalSignal;
    #Acoustic : AcousticSignal;
    #Visual : VisualSignal;
    #Tactile : TactileSignal;
    #Pheromone : PheromoneSignal;
  };

  public type ChemicalSignal = {
    neurotransmitter  : Neurotransmitter;
    concentration     : Float;        // μM
    diffusionRadius   : Float;        // μm
    decayRate         : Float;        // 1/ms
  };

  public type ElectricalSignal = {
    voltage           : Float;        // mV
    current           : Float;        // pA
    frequency         : Float;        // Hz
    phase             : Float;        // radians
  };

  public type AcousticSignal = {
    frequency         : Float;        // Hz
    amplitude         : Float;        // dB
    duration          : Float;        // ms
    harmonics         : [Float];      // Harmonic frequencies
    meaning           : SignalMeaning;
  };

  public type VisualSignal = {
    wavelength        : Float;        // nm
    intensity         : Float;        // 0-1
    pattern           : [Float];      // Spatial pattern
    flashRate         : Float;        // Hz
  };

  public type TactileSignal = {
    pressure          : Float;        // N/m²
    vibrationFreq     : Float;        // Hz
    location          : (Float, Float, Float);
    duration          : Float;        // ms
  };

  public type PheromoneSignal = {
    moleculeType      : PheromoneType;
    concentration     : Float;        // molecules/cm³
    gradientDirection : Float;        // radians
    trailPersistence  : Float;        // seconds
  };

  public type PheromoneType = {
    #Alarm;           // Danger signal
    #Trail;           // Food trail
    #Queen;           // Colony identity
    #Recruitment;     // Call for help
    #Aggregation;     // Gather together
    #Sex;             // Mating
    #Territory;       // Boundary marking
  };

  public type SignalMeaning = {
    #Alarm;
    #FoodFound;
    #Greeting;
    #Submission;
    #Aggression;
    #Mating;
    #Contact;
    #Location;
    #Identity;
  };

  // ══════════════════════════════════════════════════════════════
  // COMMUNICATION CHANNEL
  // ══════════════════════════════════════════════════════════════
  public type CommunicationChannel = {
    senderId          : Nat;
    receiverId        : Nat;
    signalType        : SignalType;
    bandwidth         : Float;        // bits/second
    latency           : Float;        // ms
    reliability       : Float;        // 0-1
    noiseLevel        : Float;        // SNR
    isOpen            : Bool;
  };

  // ══════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func medinaSigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-PHI_MEDINA * x))
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA SYNAPTIC TRANSMISSION EQUATION (MSTE)
  // ══════════════════════════════════════════════════════════════
  //
  // Real synaptic transmission with calcium dynamics
  //
  // PSP(t) = g_max × P_release × (V_m - E_rev) × τ_decay(t)
  //
  public func medinaSynapticTransmission(
    synapse: BiologicalSynapse,
    presynapticVoltage: Float,
    postsynapticVoltage: Float,
    time: Float
  ) : Float {
    // Check if presynaptic spike occurred
    let spikeOccurred = presynapticVoltage > THRESHOLD_POTENTIAL;
    
    if (not spikeOccurred) { return 0.0 };
    
    // Calcium-dependent release probability
    // P_release = 1 - exp(-[Ca²⁺] / K_Ca)
    let calciumFactor = 1.0 - Float.exp(-synapse.calciumLevel / 0.5);
    let releaseProb = VESICLE_RELEASE_PROB * calciumFactor;
    
    // Number of vesicles released (stochastic)
    let vesiclesReleased = Float.fromInt(synapse.readilyReleasable) * releaseProb;
    
    // Conductance based on receptor count
    let ampaContribution = Float.fromInt(synapse.ampaCount) * 0.01;  // nS per receptor
    let nmdaContribution = Float.fromInt(synapse.nmdaCount) * 0.005 * 
                           medinaNMDAVoltageGate(postsynapticVoltage);
    
    let totalConductance = (ampaContribution + nmdaContribution) * vesiclesReleased;
    
    // Driving force
    let drivingForce = postsynapticVoltage - E_GLUTAMATE;
    
    // Time decay
    let timeSinceSpike = time - synapse.lastSpikePre;
    let ampaDecay = Float.exp(-timeSinceSpike / TAU_AMPA);
    let nmdaDecay = Float.exp(-timeSinceSpike / TAU_NMDA);
    
    let medinaDecay = Float.pow(PHI_MEDINA, -timeSinceSpike / TAU_NMDA);
    
    // Postsynaptic potential change
    totalConductance * drivingForce * (ampaDecay + nmdaDecay) * medinaDecay * synapse.weight
  };

  // NMDA voltage-dependent gating (Mg²⁺ block)
  func medinaNMDAVoltageGate(voltage: Float) : Float {
    let magnesiumBlock = 1.0 / (1.0 + Float.exp(-0.062 * voltage) * 1.0 / 3.57);
    magnesiumBlock
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA VESICLE DYNAMICS (MVD)
  // ══════════════════════════════════════════════════════════════
  //
  // Models vesicle depletion and replenishment
  //
  public func medinaVesicleDynamics(
    synapse: BiologicalSynapse,
    spikeOccurred: Bool,
    deltaTime: Float
  ) : (Nat, Nat, Nat) {
    var rrp = synapse.readilyReleasable;
    var recycling = synapse.recyclingPool;
    var reserve = synapse.reservePool;
    
    if (spikeOccurred) {
      // Deplete RRP
      let released = Float.toInt(Float.nearest(Float.fromInt(rrp) * VESICLE_RELEASE_PROB));
      rrp := if (rrp > Int.abs(released)) { rrp - Int.abs(released) } else { 0 };
    };
    
    // Replenishment (recycling → RRP)
    let replenishRate = 0.05;  // vesicles/ms
    let replenished = Float.toInt(Float.nearest(replenishRate * deltaTime));
    if (recycling > Int.abs(replenished)) {
      recycling := recycling - Int.abs(replenished);
      rrp := rrp + Int.abs(replenished);
    };
    
    // Reserve → Recycling (slow)
    let mobilizeRate = 0.01;
    let mobilized = Float.toInt(Float.nearest(mobilizeRate * deltaTime));
    if (reserve > Int.abs(mobilized)) {
      reserve := reserve - Int.abs(mobilized);
      recycling := recycling + Int.abs(mobilized);
    };
    
    (rrp, recycling, reserve)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA NEURAL SYNCHRONY INDEX (MNSI)
  // ══════════════════════════════════════════════════════════════
  //
  // Measures synchronization between neural populations
  //
  // S_ij = |⟨exp(i×(φ_i - φ_j))⟩| × coherence × Φ_M^(-delay)
  //
  public func medinaNeuralSynchrony(
    phases1: [Float],
    phases2: [Float],
    coherence: Float,
    delay: Float
  ) : Float {
    if (phases1.size() == 0 or phases2.size() == 0) { return 0.0 };
    
    let n = Nat.min(phases1.size(), phases2.size());
    
    // Compute phase-locking value (PLV)
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    var i : Nat = 0;
    while (i < n) {
      let phaseDiff = phases1[i] - phases2[i];
      sumCos += Float.cos(phaseDiff);
      sumSin += Float.sin(phaseDiff);
      i += 1;
    };
    
    let plv = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);
    
    // Medina delay factor
    let delayFactor = Float.pow(PHI_MEDINA, -delay / 10.0);
    
    plv * coherence * delayFactor
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA INFORMATION CHANNEL CAPACITY (MICC)
  // ══════════════════════════════════════════════════════════════
  //
  // Shannon capacity with Medina modifications
  //
  // C = B × log₂(1 + SNR × Φ_M / noise_correlation)
  //
  public func medinaChannelCapacity(
    bandwidth: Float,
    signalPower: Float,
    noisePower: Float,
    noiseCorrelation: Float
  ) : Float {
    if (noisePower <= 0.0) { return bandwidth * 10.0 };  // Very high SNR
    
    let snr = signalPower / noisePower;
    let effectiveSNR = snr * PHI_MEDINA / (1.0 + noiseCorrelation);
    
    bandwidth * Float.log(1.0 + effectiveSNR) / Float.log(2.0)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA GAP JUNCTION COUPLING (MGJC)
  // ══════════════════════════════════════════════════════════════
  //
  // Electrical synapse (gap junction) current
  //
  public func medinaGapJunctionCoupling(
    voltage1: Float,
    voltage2: Float,
    conductance: Float,
    rectification: Float
  ) : Float {
    let voltageDiff = voltage1 - voltage2;
    
    // Rectification: some gap junctions conduct better in one direction
    let rectFactor = if (voltageDiff > 0.0) {
      1.0 + rectification
    } else {
      1.0 - rectification
    };
    
    conductance * voltageDiff * rectFactor
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA PHEROMONE DIFFUSION (MPD)
  // ══════════════════════════════════════════════════════════════
  //
  // Models pheromone spread in environment
  //
  public func medinaPheromoneField(
    sourceConcentration: Float,
    distance: Float,
    windSpeed: Float,
    windDirection: Float,
    queryDirection: Float,
    time: Float
  ) : Float {
    // Diffusion with wind
    let directionDiff = abs(windDirection - queryDirection);
    let windFactor = Float.cos(directionDiff) * windSpeed + 1.0;
    
    // Gaussian diffusion
    let diffusionRadius = Float.sqrt(4.0 * DIFFUSION_COEFFICIENT * time);
    let spatialDecay = Float.exp(-distance * distance / (2.0 * diffusionRadius * diffusionRadius));
    
    // Temporal decay
    let decayRate = 0.01;  // 1/s
    let temporalDecay = Float.exp(-decayRate * time);
    
    // Medina enhancement
    let medinaFactor = Float.pow(PHI_MEDINA, -distance / (diffusionRadius * windFactor));
    
    sourceConcentration * spatialDecay * temporalDecay * medinaFactor
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA ACOUSTIC ENCODING (MAE)
  // ══════════════════════════════════════════════════════════════
  //
  // Encode information in acoustic signals (like whale songs)
  //
  public func medinaAcousticEncoding(
    message: [Float],
    baseFrequency: Float,
    modulationDepth: Float
  ) : AcousticSignal {
    // Frequency modulation
    var harmonics = Buffer.Buffer<Float>(message.size());
    var i : Nat = 0;
    for (m in message.vals()) {
      let harmonic = baseFrequency * (1.0 + Float.fromInt(i)) * (1.0 + m * modulationDepth);
      harmonics.add(harmonic);
      i += 1;
    };
    
    {
      frequency = baseFrequency;
      amplitude = 1.0;
      duration = Float.fromInt(message.size()) * 100.0;  // 100ms per symbol
      harmonics = Buffer.toArray(harmonics);
      meaning = #Contact;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA WAGGLE DANCE COMMUNICATION (MWDC)
  // ══════════════════════════════════════════════════════════════
  //
  // Bee waggle dance: encodes distance, direction, quality
  // Most sophisticated known animal communication for abstract info
  //
  public type WaggleDanceMessage = {
    distance        : Float;        // meters
    direction       : Float;        // radians (relative to sun)
    quality         : Float;        // 0-1 resource quality
    circuits        : Nat;          // Number of dance circuits
    waggleDuration  : Float;        // ms per waggle
    returnDuration  : Float;        // ms for return run
    vigorIndex      : Float;        // Dance enthusiasm
  };

  public func medinaWaggleDanceEncode(
    targetDistance: Float,
    targetDirection: Float,
    resourceQuality: Float,
    sunAzimuth: Float
  ) : WaggleDanceMessage {
    // Distance → waggle duration (75ms per 100m roughly)
    let waggleDuration = targetDistance * 0.75;
    
    // Direction → angle relative to vertical (which represents sun direction)
    let danceAngle = targetDirection - sunAzimuth;
    
    // Quality → number of circuits and vigor
    let circuits = Float.toInt(Float.nearest(resourceQuality * 10.0)) + 1;
    let vigor = resourceQuality * Float.pow(PHI_MEDINA, resourceQuality - 0.5);
    
    {
      distance = targetDistance;
      direction = danceAngle;
      quality = resourceQuality;
      circuits = Int.abs(circuits);
      waggleDuration = waggleDuration;
      returnDuration = 50.0;  // Relatively constant
      vigorIndex = vigor;
    }
  };

  public func medinaWaggleDanceDecode(
    dance: WaggleDanceMessage,
    sunAzimuth: Float,
    observerUncertainty: Float
  ) : (Float, Float, Float) {
    // Decode distance (with noise)
    let distance = dance.waggleDuration / 0.75;
    let distanceNoise = observerUncertainty * 50.0;  // meters
    
    // Decode direction
    let absoluteDirection = dance.direction + sunAzimuth;
    let directionNoise = observerUncertainty * 0.2;  // radians
    
    // Decode quality from vigor
    let quality = dance.vigorIndex / Float.pow(PHI_MEDINA, dance.quality - 0.5);
    
    (distance + distanceNoise * 0.5, absoluteDirection + directionNoise * 0.5, quality)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA NEUROMODULATION BROADCAST (MNB)
  // ══════════════════════════════════════════════════════════════
  //
  // Volume transmission: neuromodulators affect large brain regions
  //
  public type VolumeTransmission = {
    source          : NucleiSource;
    neurotransmitter: Neurotransmitter;
    targetRegions   : [BrainRegion];
    concentration   : Float;
    spreadRadius    : Float;        // mm
    decayHalfLife   : Float;        // seconds
  };

  public type NucleiSource = {
    #VTA;                 // Ventral tegmental area (dopamine)
    #SNc;                 // Substantia nigra compacta (dopamine)
    #LC;                  // Locus coeruleus (norepinephrine)
    #DRN;                 // Dorsal raphe nucleus (serotonin)
    #NBM;                 // Nucleus basalis of Meynert (ACh)
    #TMN;                 // Tuberomammillary nucleus (histamine)
    #PVN;                 // Paraventricular nucleus (oxytocin)
  };

  public type BrainRegion = {
    #PrefrontalCortex;
    #MotorCortex;
    #SensoryCortex;
    #Hippocampus;
    #Amygdala;
    #Striatum;
    #Thalamus;
    #Hypothalamus;
    #Cerebellum;
    #BrainStem;
  };

  public func medinaVolumeTransmission(
    source: VolumeTransmission,
    targetDistance: Float,
    time: Float
  ) : Float {
    // Spatial decay
    let spatialFactor = Float.exp(-targetDistance / source.spreadRadius);
    
    // Temporal decay
    let temporalFactor = Float.exp(-time * Float.log(2.0) / source.decayHalfLife);
    
    // Medina factor for realistic diffusion
    let medinaFactor = Float.pow(PHI_MEDINA, -targetDistance / (source.spreadRadius * 2.0));
    
    source.concentration * spatialFactor * temporalFactor * medinaFactor
  };

  // ══════════════════════════════════════════════════════════════
  // COMPLETE COMMUNICATION STATE
  // ══════════════════════════════════════════════════════════════
  public type CommunicationState = {
    activeChannels    : [CommunicationChannel];
    pendingSignals    : [SignalType];
    recentMessages    : [WaggleDanceMessage];
    pheromoneField    : [[Float]];    // 2D concentration grid
    synchronyMatrix   : [[Float]];    // Pairwise neural synchrony
    volumeTransmissions: [VolumeTransmission];
    channelCapacity   : Float;
    noiseLevel        : Float;
  };

  public func initCommunicationState() : CommunicationState {
    {
      activeChannels = [];
      pendingSignals = [];
      recentMessages = [];
      pheromoneField = [];
      synchronyMatrix = [];
      volumeTransmissions = [];
      channelCapacity = 1000.0;  // bits/second baseline
      noiseLevel = 0.1;
    }
  };

}
