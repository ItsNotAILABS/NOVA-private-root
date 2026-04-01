// PARALLAX DRONE SWARM SIMULATION
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
// Kuramoto synchrony, Hebbian learning, Jasmine's Law, OMNIS emergence
// are Medina Tech sovereign intellectual property.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Iter      "mo:base/Iter";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

// ═══════════════════════════════════════════════════════════════════════════
// MODULE IMPORTS — CORE COGNITIVE ENGINES
// 70+ modules implementing the full NOVA cognitive architecture
// Each module is a self-contained mathematical system
// ═══════════════════════════════════════════════════════════════════════════

import KuramotoEngine        "./modules/KuramotoEngine";
import FristonEngine         "./modules/FristonEngine";
import HebbianPlasticity     "./modules/HebbianPlasticity";
import AttractorDynamics     "./modules/AttractorDynamics";
import EntropyEngine         "./modules/EntropyEngine";
import LyapunovStability     "./modules/LyapunovStability";
import EmergenceCore         "./modules/EmergenceCore";
import MedinaEngine          "./modules/MedinaEngine";
import MedinaLaws            "./modules/MedinaLaws";
import SphericalLaw          "./modules/SphericalLaw";

// ═══════════════════════════════════════════════════════════════════════════
// MODULE IMPORTS — ANIMAL INTELLIGENCE SYSTEMS
// Bio-inspired cognitive architectures from nature's designs
// ═══════════════════════════════════════════════════════════════════════════

import CrowCognition         "./modules/CrowCognition";
import OctopusBrain          "./modules/OctopusBrain";
import ElephantMemory        "./modules/ElephantMemory";
import BeeSwarmIntelligence  "./modules/BeeSwarmIntelligence";
import DolphinEcholocation   "./modules/DolphinEcholocation";
import MantisShrimp          "./modules/MantisShrimp";
import SpiderWeb             "./modules/SpiderWeb";
import OwlAuditory           "./modules/OwlAuditory";
import MedinaAnimalTraits    "./modules/MedinaAnimalTraits";

// ═══════════════════════════════════════════════════════════════════════════
// MODULE IMPORTS — MEMORY & COGNITION
// Advanced memory systems and meta-cognitive architectures
// ═══════════════════════════════════════════════════════════════════════════

import MembraneMemory        "./modules/MembraneMemory";
import TemporalHologram      "./modules/TemporalHologram";
import CompoundLearning      "./modules/CompoundLearning";
import WorldModelSystem      "./modules/WorldModelSystem";
import SimulatedWorld        "./modules/SimulatedWorld";

// ═══════════════════════════════════════════════════════════════════════════
// MODULE IMPORTS — DEFENSE & SECURITY
// Sovereign protection and autonomous defense systems
// ═══════════════════════════════════════════════════════════════════════════

import MedinaDefenseSystem   "./modules/MedinaDefenseSystem";
import AEGIS                 "./modules/AEGIS";
import PrincipalLock         "./modules/PrincipalLock";

// ═══════════════════════════════════════════════════════════════════════════
// MODULE IMPORTS — SPECIALIZED SYSTEMS
// Domain-specific cognitive modules
// ═══════════════════════════════════════════════════════════════════════════

import CognitiveScienceAdvisor "./modules/CognitiveScienceAdvisor";
import DefenseIndustryAdvisor  "./modules/DefenseIndustryAdvisor";
import QuantumOps              "./modules/QuantumOps";
import SuccessionEngine        "./modules/SuccessionEngine";
import MedinaGodsEngine        "./modules/MedinaGodsEngine";
import MedinaBiblicalLaws      "./modules/MedinaBiblicalLaws";
import MedinaSabbathProtocol   "./modules/MedinaSabbathProtocol";
import MedinaCommunicationProtocol "./modules/MedinaCommunicationProtocol";

// ═══════════════════════════════════════════════════════════════════════════
// MODULE IMPORTS — ADVANCED NEURAL ARCHITECTURES
// Higher-order cognitive systems and consciousness models
// ═══════════════════════════════════════════════════════════════════════════

import MedinaAntColonySpherical   "./modules/MedinaAntColonySpherical";
import MedinaCanisterArchitecture "./modules/MedinaCanisterArchitecture";
import MedinaCatVisualCortex      "./modules/MedinaCatVisualCortex";
import MedinaCodeGenesisEngine    "./modules/MedinaCodeGenesisEngine";
import MedinaConsciousnessField   "./modules/MedinaConsciousnessField";
import MedinaEnterpriseNeural     "./modules/MedinaEnterpriseNeural";
import MedinaHelixFormation       "./modules/MedinaHelixFormation";
import MedinaMathFoundation       "./modules/MedinaMathFoundation";
import MedinaMetaCognitionSupreme "./modules/MedinaMetaCognitionSupreme";
import MedinaNeuralOscillatorV3   "./modules/MedinaNeuralOscillatorV3";
import MedinaOrganismTeams        "./modules/MedinaOrganismTeams";
import MedinaPlanningHorizon      "./modules/MedinaPlanningHorizon";
import MedinaQuantumBrain         "./modules/MedinaQuantumBrain";
import MedinaQuantumCovenantChain "./modules/MedinaQuantumCovenantChain";
import MedinaQuantumProtocols     "./modules/MedinaQuantumProtocols";
import MedinaSelfModel            "./modules/MedinaSelfModel";
import MedinaSharpWaveRipples     "./modules/MedinaSharpWaveRipples";
import MedinaWolfPackIntelligence "./modules/MedinaWolfPackIntelligence";

// ═══════════════════════════════════════════════════════════════════════════
// MODULE IMPORTS — ORCHESTRATION & COORDINATION
// Multi-agent coordination and swarm control systems
// ═══════════════════════════════════════════════════════════════════════════

import AnimalBrainOrchestrator    "./modules/AnimalBrainOrchestrator";
import AutonomousWarEngine        "./modules/AutonomousWarEngine";
import BehavioralEconomics        "./modules/BehavioralEconomics";
import CreationEngine             "./modules/CreationEngine";
import DroneAvatar                "./modules/DroneAvatar";
import FORMATokenEconomics        "./modules/FORMATokenEconomics";
import MAVLinkBridge              "./modules/MAVLinkBridge";
import MultiSwarmCoordinator      "./modules/MultiSwarmCoordinator";
import Neurochemicals             "./modules/Neurochemicals";
import PatentRegistry             "./modules/PatentRegistry";
import PredictiveCoding           "./modules/PredictiveCoding";
import QuantumMath                "./modules/QuantumMath";
import SalmonNavigation           "./modules/SalmonNavigation";
import SovereignHeartbeat         "./modules/SovereignHeartbeat";
import TradeSecretProtection      "./modules/TradeSecretProtection";
import WarSimEngine               "./modules/WarSimEngine";
import WorldOrganism              "./modules/WorldOrganism";

actor SwarmBrain {

  // ─── CONSTANTS ──────────────────────────────────────────────────────────────

  let SOVEREIGN_FLOOR   : Float = 1.0;
  let HELIX_ALPHA       : Float = 0.01;
  let W_CEIL            : Float = 2.0;
  let KURAMOTO_K        : Float = 0.618;
  let MAX_DRONES        : Nat   = 50;
  let BRAIN_NODES       : Nat   = 6;

  // Neurochemical indices
  let DOPAMINE          : Nat = 0;
  let CORTISOL          : Nat = 1;
  let NOREPINEPHRINE    : Nat = 2;
  let OXYTOCIN          : Nat = 3;

  // ─── TYPES ──────────────────────────────────────────────────────────────────

  public type DroneClass = {
    #SCOUT;
    #STRIKER;
    #GUARDIAN;
    #RELAY;
    #MEDIC;
    #SOVEREIGN;
  };

  public type DroneState = {
    id              : Nat;
    droneClass      : DroneClass;
    // 6-node micro-brain weights [BRAIN_NODES x BRAIN_NODES] stored flat
    brainWeights    : [var Float];
    // 4 neurochemicals: [DOPAMINE, CORTISOL, NOREPINEPHRINE, OXYTOCIN]
    neuroChem       : [var Float];
    // Kuramoto phase (radians)
    phase           : Float;
    // Natural frequency
    omega           : Float;
    // Signal output (Law 23: decays over time)
    signal          : Float;
    // Position (x, y, z)
    posX            : Float;
    posY            : Float;
    posZ            : Float;
    // Health / activation
    activation      : Float;
    // Beat of last update
    lastBeat        : Nat;
    // Sacrifice flag
    sacrificed      : Bool;
  };

  // Stable storage arrays — survive upgrades
  stable var stableDroneCount       : Nat = 0;
  stable var stableBrainWeights     : [var Float] = [var]; // flat: droneId * N*N + node*N + node2
  stable var stableNeuroChem        : [var Float] = [var]; // flat: droneId * 4 + chemIdx
  stable var stablePhases           : [var Float] = [var];
  stable var stableOmegas           : [var Float] = [var];
  stable var stableSignals          : [var Float] = [var];
  stable var stablePosX             : [var Float] = [var];
  stable var stablePosY             : [var Float] = [var];
  stable var stablePosZ             : [var Float] = [var];
  stable var stableActivations      : [var Float] = [var];
  stable var stableLastBeat         : [var Nat]   = [var];
  stable var stableSacrificed       : [var Bool]  = [var];
  stable var stableClasses          : [var Text]  = [var];
  // Inter-drone Hebbian weights [i * MAX_DRONES + j]
  stable var stableSwarmWeights     : [var Float] = [var];

  // New: velocity, energy, brain node activations
  stable var stableVelX              : [var Float] = [var];
  stable var stableVelZ              : [var Float] = [var];
  stable var stableEnergy            : [var Float] = [var];
  // 6 activation values per drone (SENSOR/MEMORY/EXECUTIVE/EMOTIONAL/MOTOR/OUTPUT)
  stable var stableNodeActivations   : [var Float] = [var];

  stable var currentBeat            : Nat   = 0;
  stable var rSwarm                 : Float = 0.88;
  stable var jDrift                 : Float = 0.0;
  stable var prevJDrift             : Float = 0.0;
  stable var jRisingBeats           : Nat   = 0;
  stable var architectSignalLevel   : Float = 1.0;

  // ─── SOVEREIGN SEAL — On-chain IP Attribution & Access Control ──────────────
  // Attribution: Alfredo Medina Hernandez | Medina Tech | Dallas TX | 2026
  // All mathematics, architecture, and doctrine within are sovereign IP.
  //
  // The architect calls claimArchitect() ONCE after deployment.
  // This permanently binds the canister to the caller's ICP Principal.
  // The sovereign seal is written into stable state and cannot be overwritten.
  // The ICP blockchain itself enforces the lock — caller principals are
  // cryptographically verified by the subnet; they cannot be spoofed.
  //
  // Post-genesis, only two principals may call write functions:
  //   1. architectPrincipal   — the human owner (Alfredo Medina Hernandez)
  //   2. trustedOrganismPrincipal — the registered swarm_organism canister
  //      (set by the architect after deploying swarm_organism)
  stable var architectPrincipal       : Principal = Principal.fromText("aaaaa-aa");
  stable var trustedOrganismPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked            : Bool      = false;
  stable var sovereignSeal            : Text      = ""; // immutable after genesis
  stable var genesisTimestamp         : Int       = 0;
  stable var genesisBeat              : Nat       = 0;

  // ─── ACCESS CONTROL HELPERS ─────────────────────────────────────────────────
  func isAuthorized(caller : Principal) : Bool {
    // Pre-genesis: allow deployment setup
    if (not genesisLocked) return true;
    // Post-genesis: architect or registered organism canister only
    caller == architectPrincipal or caller == trustedOrganismPrincipal
  };

  func requireAuthorized(caller : Principal) {
    assert(isAuthorized(caller));
  };

  // ─── HELPERS ────────────────────────────────────────────────────────────────

  func sf(x : Float) : Float { Float.max(SOVEREIGN_FLOOR, x) };

  func classToText(c : DroneClass) : Text {
    switch c {
      case (#SCOUT)     "SCOUT";
      case (#STRIKER)   "STRIKER";
      case (#GUARDIAN)  "GUARDIAN";
      case (#RELAY)     "RELAY";
      case (#MEDIC)     "MEDIC";
      case (#SOVEREIGN) "SOVEREIGN";
    }
  };

  func textToClass(t : Text) : DroneClass {
    switch t {
      case "STRIKER"   #STRIKER;
      case "GUARDIAN"  #GUARDIAN;
      case "RELAY"     #RELAY;
      case "MEDIC"     #MEDIC;
      case "SOVEREIGN" #SOVEREIGN;
      case _           #SCOUT;
    }
  };

  // Baseline neurochemical profile per class
  func baselineChem(c : DroneClass) : [Float] {
    switch c {
      case (#SCOUT)     [1.0, 1.0, 1.5, 1.0];
      case (#STRIKER)   [1.0, 1.3, 1.2, 1.0];
      case (#GUARDIAN)  [1.0, 1.1, 1.0, 1.5];
      case (#RELAY)     [1.5, 1.0, 1.0, 1.0];
      case (#MEDIC)     [1.0, 1.0, 1.0, 1.5];
      case (#SOVEREIGN) [1.2, 1.2, 1.2, 1.2];
    }
  };

  // Base cortisol per class
  func baselineCortisol(c : DroneClass) : Float {
    switch c {
      case (#SCOUT)     1.0;
      case (#STRIKER)   1.3;
      case (#GUARDIAN)  1.1;
      case (#RELAY)     1.0;
      case (#MEDIC)     1.0;
      case (#SOVEREIGN) 1.2;
    }
  };

  func sin(x : Float) : Float { Float.sin(x) };
  func cos(x : Float) : Float { Float.cos(x) };

  // ─── SIGMOID ACTIVATION ──────────────────────────────────────────────────────
  func sigmoid(x : Float) : Float {
    let cx = Float.max(-10.0, Float.min(10.0, x));
    1.0 / (1.0 + Float.exp(-cx))
  };

  // ─── NEUROCHEMICAL BASELINE PER CLASS ────────────────────────────────────────
  // Returns (dopBase, corBase, norBase, oxyBase)
  func chemBaseline(id : Nat) : (Float, Float, Float, Float) {
    switch (stableClasses[id]) {
      case "STRIKER"   (1.0, 1.3, 1.2, 1.0);
      case "GUARDIAN"  (1.0, 1.1, 1.0, 1.5);
      case "RELAY"     (1.5, 1.0, 1.0, 1.0);
      case "MEDIC"     (1.0, 1.0, 1.0, 1.5);
      case "SOVEREIGN" (1.2, 1.2, 1.2, 1.2);
      case _           (1.0, 1.0, 1.5, 1.0); // SCOUT
    }
  };

  // ─── 4-SPECIES NEUROCHEMICAL ODE (Euler, dt = 0.05) ─────────────────────────
  // DOPAMINE:       reward ← r_swarm × energy; decay toward baseline
  // CORTISOL:       stress ← J_drift; antagonized by OXY
  // NOREPINEPHRINE: arousal ← excess COR above baseline; fast decay
  // OXYTOCIN:       bonding ← mean Hebbian weight + r_swarm; homeostasis
  func neurochemODE(id : Nat, meanHebb : Float) {
    let ncBase = id * 4;
    let dop = stableNeuroChem[ncBase + DOPAMINE];
    let cor = stableNeuroChem[ncBase + CORTISOL];
    let nor = stableNeuroChem[ncBase + NOREPINEPHRINE];
    let oxy = stableNeuroChem[ncBase + OXYTOCIN];
    let energy = stableEnergy[id];
    let (dopBase, corBase, norBase, oxyBase) = chemBaseline(id);
    let dt : Float = 0.05;

    // DOPAMINE: formation reward
    let dDop = (0.5 * rSwarm * Float.min(energy, 2.0) - 0.15 * (dop - dopBase)) * dt;
    // CORTISOL: stress from Lyapunov drift, antagonized by oxytocin
    let corExcess = Float.max(0.0, cor - 1.0);
    let dCor = (0.8 * jDrift - 0.20 * oxy * corExcess - 0.10 * (cor - corBase)) * dt;
    // NOREPINEPHRINE: arousal from cortisol exceeding class baseline
    let dNor = (0.6 * Float.max(0.0, cor - corBase) - 0.25 * (nor - norBase)) * dt;
    // OXYTOCIN: social bonding from Hebbian proximity + coherence
    let dOxy = (0.4 * meanHebb + 0.3 * rSwarm - 0.20 * (oxy - oxyBase)) * dt;

    stableNeuroChem[ncBase + DOPAMINE]       := sf(dop + dDop);
    stableNeuroChem[ncBase + CORTISOL]       := sf(cor + dCor);
    stableNeuroChem[ncBase + NOREPINEPHRINE] := sf(nor + dNor);
    stableNeuroChem[ncBase + OXYTOCIN]       := sf(oxy + dOxy);
  };

  // ─── 6-NODE BRAIN FORWARD PASS ───────────────────────────────────────────────
  // Nodes: 0=SENSOR 1=MEMORY 2=EXECUTIVE 3=EMOTIONAL 4=MOTOR 5=OUTPUT
  // Two settling passes through the 6×6 recurrent weight matrix.
  // Neurochemicals gate each node's additive bias.
  func brainForwardPass(id : Nat, architectSignal : Float) {
    let ncBase = id * 4;
    let bwBase = id * BRAIN_NODES * BRAIN_NODES;
    let naBase = id * BRAIN_NODES;
    let dop = stableNeuroChem[ncBase + DOPAMINE];
    let cor = stableNeuroChem[ncBase + CORTISOL];
    let nor = stableNeuroChem[ncBase + NOREPINEPHRINE];
    let oxy = stableNeuroChem[ncBase + OXYTOCIN];

    // Neurochemical bias per node
    let bias0 = nor * 0.25;                         // SENSOR: arousal sharpens sensing
    let bias1 = dop * 0.20;                         // MEMORY: reward consolidates
    let bias2 = dop * 0.15 - cor * 0.10;            // EXECUTIVE: reward enables, stress impairs
    let bias3 = cor * 0.30 + nor * 0.20;            // EMOTIONAL: stress + arousal
    let bias4 = nor * 0.35;                         // MOTOR: arousal drives action
    let bias5 = oxy * 0.20 + architectSignal * 0.30; // OUTPUT: cohesion + external command

    // Two forward settling passes
    var pass = 0;
    while (pass < 2) {
      var ni = 0;
      while (ni < BRAIN_NODES) {
        let bias = switch ni {
          case 0 bias0; case 1 bias1; case 2 bias2;
          case 3 bias3; case 4 bias4; case _ bias5;
        };
        var sum : Float = bias;
        var nj = 0;
        while (nj < BRAIN_NODES) {
          sum += stableBrainWeights[bwBase + ni * BRAIN_NODES + nj]
                 * stableNodeActivations[naBase + nj];
          nj += 1;
        };
        stableNodeActivations[naBase + ni] := sigmoid(sum);
        ni += 1;
      };
      pass += 1;
    };
  };

  // ─── STDP INTRA-BRAIN WEIGHT PLASTICITY ──────────────────────────────────────
  // Δw_ij = α · a_i · a_j − decay · w_ij  (BCM-like unsupervised Hebbian)
  func stdpUpdate(id : Nat) {
    let STDP_ALPHA : Float = 0.005;
    let DECAY      : Float = 0.001;
    let bwBase = id * BRAIN_NODES * BRAIN_NODES;
    let naBase = id * BRAIN_NODES;
    var ni = 0;
    while (ni < BRAIN_NODES) {
      var nj = 0;
      while (nj < BRAIN_NODES) {
        let idx = bwBase + ni * BRAIN_NODES + nj;
        let ai = stableNodeActivations[naBase + ni];
        let aj = stableNodeActivations[naBase + nj];
        let w  = stableBrainWeights[idx];
        let dw = STDP_ALPHA * ai * aj - DECAY * w;
        stableBrainWeights[idx] := Float.max(0.1, Float.min(3.0, w + dw));
        nj += 1;
      };
      ni += 1;
    };
  };

  // ─── ENERGY MODEL ─────────────────────────────────────────────────────────────
  // Replenish slowly; deplete from signaling, neural activity, and movement.
  func energyStep(id : Nat) {
    let REPLENISH   : Float = 0.015;
    let SIGNAL_COST : Float = 0.003;
    let BRAIN_COST  : Float = 0.002;
    let MOVE_COST   : Float = 0.005;
    let naBase = id * BRAIN_NODES;
    var actSum : Float = 0.0;
    var ni = 0;
    while (ni < BRAIN_NODES) { actSum += stableNodeActivations[naBase + ni]; ni += 1 };
    let meanAct = actSum / Float.fromInt(BRAIN_NODES);
    let speed = Float.sqrt(stableVelX[id] * stableVelX[id] + stableVelZ[id] * stableVelZ[id]);
    let newE = stableEnergy[id]
      + REPLENISH
      - SIGNAL_COST * stableSignals[id]
      - BRAIN_COST  * meanAct
      - MOVE_COST   * speed;
    stableEnergy[id] := Float.max(0.2, Float.min(2.0, newE));
  };

  // ─── REYNOLDS BOIDS VELOCITY UPDATE ──────────────────────────────────────────
  // Separation · Alignment · Cohesion · Anchor-to-origin
  // NOR modulates max speed (arousal → faster movement).
  func boidsVelocity(id : Nat) {
    let SEP_RADIUS : Float = 15.0;
    let COH_RADIUS : Float = 50.0;
    let MAX_SPEED  : Float = 0.5;
    let W_SEP : Float = 1.5;
    let W_ALI : Float = 0.8;
    let W_COH : Float = 0.6;
    let n = stableDroneCount;
    var sepX : Float = 0.0; var sepZ : Float = 0.0;
    var aliX : Float = 0.0; var aliZ : Float = 0.0;
    var cohX : Float = 0.0; var cohZ : Float = 0.0;
    var nSep : Float = 0.0; var nAli : Float = 0.0; var nCoh : Float = 0.0;
    var j = 0;
    while (j < n) {
      if (j != id and not stableSacrificed[j]) {
        let dx = stablePosX[id] - stablePosX[j];
        let dz = stablePosZ[id] - stablePosZ[j];
        let dist = Float.sqrt(dx * dx + dz * dz) + 0.001;
        if (dist < SEP_RADIUS) { sepX += dx / dist; sepZ += dz / dist; nSep += 1.0 };
        if (dist < COH_RADIUS) {
          aliX += stableVelX[j]; aliZ += stableVelZ[j]; nAli += 1.0;
          cohX += stablePosX[j]; cohZ += stablePosZ[j]; nCoh += 1.0;
        };
      };
      j += 1;
    };
    if (nSep > 0.0) { sepX /= nSep; sepZ /= nSep };
    if (nAli > 0.0) { aliX /= nAli; aliZ /= nAli };
    if (nCoh > 0.0) {
      cohX := cohX / nCoh - stablePosX[id];
      cohZ := cohZ / nCoh - stablePosZ[id];
    };
    // Anchor: tighter when swarm is coherent (high r_swarm)
    let anchorK = 0.005 + 0.02 * rSwarm;
    let ancX = -stablePosX[id] * anchorK;
    let ancZ = -stablePosZ[id] * anchorK;

    let forceX = W_SEP * sepX + W_ALI * aliX + W_COH * cohX + ancX;
    let forceZ = W_SEP * sepZ + W_ALI * aliZ + W_COH * cohZ + ancZ;

    // Norepinephrine modulates speed
    let nor = stableNeuroChem[id * 4 + NOREPINEPHRINE];
    let norExcess = Float.max(0.0, nor - 1.0);
    let speedMod  = Float.min(2.0, 0.5 + 0.8 * norExcess);

    var newVX = stableVelX[id] * 0.85 + forceX * 0.05;
    var newVZ = stableVelZ[id] * 0.85 + forceZ * 0.05;
    let speed = Float.sqrt(newVX * newVX + newVZ * newVZ);
    if (speed > MAX_SPEED * speedMod) {
      newVX := newVX / speed * MAX_SPEED * speedMod;
      newVZ := newVZ / speed * MAX_SPEED * speedMod;
    };
    stableVelX[id]  := newVX;
    stableVelZ[id]  := newVZ;
    stablePosX[id]  := stablePosX[id] + newVX;
    stablePosZ[id]  := stablePosZ[id] + newVZ;
  };

  // ─── INITIALISE / RESIZE STABLE ARRAYS ──────────────────────────────────────

  func ensureCapacity(n : Nat) {
    let bwSize = n * BRAIN_NODES * BRAIN_NODES;
    let ncSize = n * 4;
    let swSize = n * MAX_DRONES;

    if (stableBrainWeights.size() < bwSize) {
      let newBW = Array.init<Float>(bwSize, 1.0);
      var i = 0;
      while (i < stableBrainWeights.size()) { newBW[i] := stableBrainWeights[i]; i += 1 };
      stableBrainWeights := newBW;
    };
    if (stableNeuroChem.size() < ncSize) {
      let newNC = Array.init<Float>(ncSize, 1.0);
      var i = 0;
      while (i < stableNeuroChem.size()) { newNC[i] := stableNeuroChem[i]; i += 1 };
      stableNeuroChem := newNC;
    };
    if (stablePhases.size() < n) {
      let newP = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stablePhases.size()) { newP[i] := stablePhases[i]; i += 1 };
      stablePhases := newP;
    };
    if (stableOmegas.size() < n) {
      let newO = Array.init<Float>(n, 1.0);
      var i = 0;
      while (i < stableOmegas.size()) { newO[i] := stableOmegas[i]; i += 1 };
      stableOmegas := newO;
    };
    if (stableSignals.size() < n) {
      let newS = Array.init<Float>(n, 1.0);
      var i = 0;
      while (i < stableSignals.size()) { newS[i] := stableSignals[i]; i += 1 };
      stableSignals := newS;
    };
    if (stablePosX.size() < n) {
      let newX = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stablePosX.size()) { newX[i] := stablePosX[i]; i += 1 };
      stablePosX := newX;
    };
    if (stablePosY.size() < n) {
      let newY = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stablePosY.size()) { newY[i] := stablePosY[i]; i += 1 };
      stablePosY := newY;
    };
    if (stablePosZ.size() < n) {
      let newZ = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stablePosZ.size()) { newZ[i] := stablePosZ[i]; i += 1 };
      stablePosZ := newZ;
    };
    if (stableActivations.size() < n) {
      let newA = Array.init<Float>(n, 1.0);
      var i = 0;
      while (i < stableActivations.size()) { newA[i] := stableActivations[i]; i += 1 };
      stableActivations := newA;
    };
    if (stableLastBeat.size() < n) {
      let newLB = Array.init<Nat>(n, 0);
      var i = 0;
      while (i < stableLastBeat.size()) { newLB[i] := stableLastBeat[i]; i += 1 };
      stableLastBeat := newLB;
    };
    if (stableSacrificed.size() < n) {
      let newSac = Array.init<Bool>(n, false);
      var i = 0;
      while (i < stableSacrificed.size()) { newSac[i] := stableSacrificed[i]; i += 1 };
      stableSacrificed := newSac;
    };
    if (stableClasses.size() < n) {
      let newCls = Array.init<Text>(n, "SCOUT");
      var i = 0;
      while (i < stableClasses.size()) { newCls[i] := stableClasses[i]; i += 1 };
      stableClasses := newCls;
    };
    if (stableSwarmWeights.size() < swSize) {
      let newSW = Array.init<Float>(swSize, 0.1);
      var i = 0;
      while (i < stableSwarmWeights.size()) { newSW[i] := stableSwarmWeights[i]; i += 1 };
      stableSwarmWeights := newSW;
    };
    // velocity X / Z
    if (stableVelX.size() < n) {
      let newVX = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stableVelX.size()) { newVX[i] := stableVelX[i]; i += 1 };
      stableVelX := newVX;
    };
    if (stableVelZ.size() < n) {
      let newVZ = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stableVelZ.size()) { newVZ[i] := stableVelZ[i]; i += 1 };
      stableVelZ := newVZ;
    };
    // energy (sovereign floor for energy is 0.2)
    if (stableEnergy.size() < n) {
      let newE = Array.init<Float>(n, 1.5);
      var i = 0;
      while (i < stableEnergy.size()) { newE[i] := stableEnergy[i]; i += 1 };
      stableEnergy := newE;
    };
    // node activations: 6 per drone
    let naSize = n * BRAIN_NODES;
    if (stableNodeActivations.size() < naSize) {
      let newNA = Array.init<Float>(naSize, 0.5);
      var i = 0;
      while (i < stableNodeActivations.size()) { newNA[i] := stableNodeActivations[i]; i += 1 };
      stableNodeActivations := newNA;
    };
  };

  // ─── ADD DRONE ───────────────────────────────────────────────────────────────

  public shared(msg) func addDrone(droneClass : DroneClass, omega : Float, posX : Float, posY : Float, posZ : Float) : async Nat {
    requireAuthorized(msg.caller);
    let id = stableDroneCount;
    stableDroneCount += 1;
    ensureCapacity(stableDroneCount);

    let cls = classToText(droneClass);
    stableClasses[id] := cls;

    let bc = baselineChem(droneClass);
    let ncBase = id * 4;
    stableNeuroChem[ncBase + DOPAMINE]       := sf(bc[0]);
    stableNeuroChem[ncBase + CORTISOL]       := sf(bc[1]);
    stableNeuroChem[ncBase + NOREPINEPHRINE] := sf(bc[2]);
    stableNeuroChem[ncBase + OXYTOCIN]       := sf(bc[3]);

    // Initialize brain weights to 1.0 (sovereign floor)
    let bwBase = id * BRAIN_NODES * BRAIN_NODES;
    var ni = 0;
    while (ni < BRAIN_NODES * BRAIN_NODES) {
      stableBrainWeights[bwBase + ni] := 1.0;
      ni += 1;
    };

    // Stagger phase so drones don't start synchronised
    let phaseOffset = Float.fromInt(id) * 0.2;
    stablePhases[id]      := phaseOffset;
    stableOmegas[id]      := Float.max(0.1, omega);
    stableSignals[id]     := 1.0;
    stablePosX[id]        := posX;
    stablePosY[id]        := posY;
    stablePosZ[id]        := posZ;
    stableActivations[id] := 1.0;
    stableLastBeat[id]    := currentBeat;
    stableSacrificed[id]  := false;

    // Init inter-drone weights
    var j = 0;
    while (j < MAX_DRONES) {
      if (j != id) {
        stableSwarmWeights[id * MAX_DRONES + j] := 0.1;
        stableSwarmWeights[j  * MAX_DRONES + id] := 0.1;
      };
      j += 1;
    };

    // Init velocity, energy, node activations
    stableVelX[id]   := 0.0;
    stableVelZ[id]   := 0.0;
    stableEnergy[id] := 1.5;
    let naBase = id * BRAIN_NODES;
    var ni2 = 0;
    while (ni2 < BRAIN_NODES) {
      stableNodeActivations[naBase + ni2] := 0.5;
      ni2 += 1;
    };

    id
  };

  // ─── TICK / BEAT ─────────────────────────────────────────────────────────────

  // Law 23: Observer Independence — signal decays each beat
  func decaySignal(id : Nat) {
    let decay = Float.exp(-0.001 * Float.fromInt(currentBeat - stableLastBeat[id]));
    stableSignals[id] := sf(stableSignals[id] * decay);
  };

  // Law 4: Hebbian inter-drone learning (proximity-weighted)
  func hebbianUpdate(i : Nat, j : Nat) {
    let dx = stablePosX[i] - stablePosX[j];
    let dy = stablePosY[i] - stablePosY[j];
    let dz = stablePosZ[i] - stablePosZ[j];
    let dist = Float.sqrt(dx*dx + dy*dy + dz*dz) + 0.001;
    let proximity = 1.0 / (1.0 + dist / 10.0); // proximity weight
    let wi = stableSwarmWeights[i * MAX_DRONES + j];
    let si = stableSignals[i];
    let sj = stableSignals[j];
    let delta = HELIX_ALPHA * si * sj * (1.0 - wi / W_CEIL) * proximity;
    stableSwarmWeights[i * MAX_DRONES + j] := Float.min(W_CEIL, wi + delta);
    stableSwarmWeights[j * MAX_DRONES + i] := stableSwarmWeights[i * MAX_DRONES + j];
  };

  // Laws 6, 7: Kuramoto phase update
  func kuramotoUpdate(id : Nat) {
    let n = stableDroneCount;
    if (n == 0) return;
    var sum : Float = 0.0;
    var j = 0;
    while (j < n) {
      if (j != id and not stableSacrificed[j]) {
        sum += sin(stablePhases[j] - stablePhases[id]);
      };
      j += 1;
    };
    let dTheta = stableOmegas[id] + (KURAMOTO_K / Float.fromInt(n)) * sum;
    stablePhases[id] := stablePhases[id] + dTheta * 0.1; // dt = 0.1
  };

  // Compute swarm-level r_swarm (order parameter)
  func computeRSwarm() : Float {
    let n = stableDroneCount;
    if (n == 0) return 0.88;
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var active : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        sumCos += cos(stablePhases[i]);
        sumSin += sin(stablePhases[i]);
        active += 1.0;
      };
      i += 1;
    };
    if (active == 0.0) return 0.88;
    let r = Float.sqrt((sumCos/active)*(sumCos/active) + (sumSin/active)*(sumSin/active));
    // Clamp to realistic simulation range [0.5, 1.0]
    Float.max(0.5, Float.min(1.0, r))
  };

  // ─── JASMINE'S LAW — 5-Component Lyapunov Stability ─────────────────────────
  // Named and attributed: Alfredo Medina Hernandez | Medina Tech | Dallas TX 2026
  //
  // Drift vector J(t) = [coherenceDrift, arousalDrift, frequencyDrift,
  //                       weightDrift, chemicalDrift]
  // Lyapunov function: V(x) = (1/2) × ||J(t)||²
  //                         = (1/2) × (j1² + j2² + j3² + j4² + j5²)
  //
  // While V(x) is non-increasing, the organism is asymptotically stable.
  // Each component is normalised by active drone count so V scales correctly.

  // Stable storage for the 5 drift components (updated each tick for SACESI use)
  stable var jasmineJ : [var Float] = Array.init<Float>(5, 0.0);
  // j0 = coherenceDrift (Kuramoto phase variance)
  // j1 = arousalDrift   (cortisol variance)
  // j2 = frequencyDrift (omega variance)
  // j3 = weightDrift    (mean Hebbian weight deviation from 1.0)
  // j4 = chemicalDrift  (signal variance)

  func computeJDrift() : Float {
    let n = stableDroneCount;
    if (n == 0) return 0.0;
    var cnt : Float = 0.0;
    var i = 0;

    // Collect means over active drones
    var meanPhase  : Float = 0.0;
    var meanCort   : Float = 0.0;
    var meanOmega  : Float = 0.0;
    var meanSig    : Float = 0.0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        meanPhase += stablePhases[i];
        meanCort  += stableNeuroChem[i * 4 + CORTISOL];
        meanOmega += stableOmegas[i];
        meanSig   += stableSignals[i];
        cnt += 1.0;
      };
      i += 1;
    };
    if (cnt == 0.0) return 0.0;
    meanPhase /= cnt; meanCort /= cnt;
    meanOmega /= cnt; meanSig  /= cnt;

    // j0: coherenceDrift — Kuramoto phase variance (formation integrity)
    var j0 : Float = 0.0;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let d = stablePhases[i] - meanPhase;
        j0 += d * d;
      };
      i += 1;
    };
    j0 /= cnt;

    // j1: arousalDrift — cortisol variance (stress distribution)
    var j1 : Float = 0.0;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let d = stableNeuroChem[i * 4 + CORTISOL] - meanCort;
        j1 += d * d;
      };
      i += 1;
    };
    j1 /= cnt;

    // j2: frequencyDrift — natural frequency variance (oscillator spread)
    var j2 : Float = 0.0;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let d = stableOmegas[i] - meanOmega;
        j2 += d * d;
      };
      i += 1;
    };
    j2 /= cnt;

    // j3: weightDrift — mean deviation of Hebbian weights from SOVEREIGN_FLOOR
    // A weight of exactly 1.0 is equilibrium; higher = over-consolidated
    var j3 : Float = 0.0;
    var wCnt : Float = 0.0;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        var j2_ = 0;
        while (j2_ < n) {
          if (i != j2_ and not stableSacrificed[j2_]) {
            let w = stableSwarmWeights[i * MAX_DRONES + j2_];
            let d = w - SOVEREIGN_FLOOR;
            j3 += d * d;
            wCnt += 1.0;
          };
          j2_ += 1;
        };
      };
      i += 1;
    };
    j3 := if (wCnt > 0.0) j3 / wCnt else 0.0;

    // j4: chemicalDrift — signal amplitude variance (communication health)
    var j4 : Float = 0.0;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let d = stableSignals[i] - meanSig;
        j4 += d * d;
      };
      i += 1;
    };
    j4 /= cnt;

    // Store drift vector for SACESI
    jasmineJ[0] := j0; jasmineJ[1] := j1; jasmineJ[2] := j2;
    jasmineJ[3] := j3; jasmineJ[4] := j4;

    // V(x) = (1/2) × ||J||²
    0.5 * (j0*j0 + j1*j1 + j2*j2 + j3*j3 + j4*j4)
  };

  // Jasmine correction: κ = −α × ∇V(x)  where α = 0.275 (silver anchor rate)
  // ∇V(x)_k = J_k  (gradient of (1/2)||J||² w.r.t. J_k is J_k itself)
  // Correction dispatches a per-component pull toward equilibrium manifold.
  func jasmineCorrect() {
    let ALPHA : Float = 0.275; // silver anchor rate
    let n = stableDroneCount;
    if (n == 0) return;

    // Recompute means needed for directional corrections
    var meanPhase : Float = 0.0;
    var cnt : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        meanPhase += stablePhases[i];
        cnt += 1.0;
      };
      i += 1;
    };
    if (cnt == 0.0) return;
    meanPhase /= cnt;

    // κ for each component (magnitude scales with drift size × alpha)
    let kappa0 = ALPHA * jasmineJ[0]; // phase correction
    let kappa1 = ALPHA * jasmineJ[1]; // cortisol correction
    let kappa2 = ALPHA * jasmineJ[2]; // frequency correction
    // j3 (weight drift) corrected via Hebbian decay below
    let kappa4 = ALPHA * jasmineJ[4]; // signal correction

    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let ncBase = i * 4;

        // Phase: pull toward mean (κ0 governs step size)
        stablePhases[i] := stablePhases[i]
          - kappa0 * (stablePhases[i] - meanPhase);

        // Frequency: pull toward SOVEREIGN_FLOOR × 2π (2.75 Hz)
        let omegaFloor : Float = 2.75 * 6.28318;
        stableOmegas[i] := stableOmegas[i]
          - kappa2 * (stableOmegas[i] - omegaFloor);

        // Cortisol: suppress excess (κ1 governs step size)
        let corExcess = Float.max(0.0, stableNeuroChem[ncBase + CORTISOL] - 1.0);
        stableNeuroChem[ncBase + CORTISOL] :=
          sf(stableNeuroChem[ncBase + CORTISOL] - kappa1 * corExcess);

        // Oxytocin: bonding boost proportional to coherence deficit
        stableNeuroChem[ncBase + OXYTOCIN] :=
          sf(stableNeuroChem[ncBase + OXYTOCIN] + kappa0 * 0.3);

        // Signal: gentle pull toward mean via κ4
        stableSignals[i] := Float.max(SOVEREIGN_FLOOR,
          stableSignals[i] - kappa4 * 0.1 * (stableSignals[i] - 1.0));
      };
      i += 1;
    };

    // j3 correction: decay over-consolidated Hebbian weights toward sovereign floor
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        var j = 0;
        while (j < n) {
          if (i != j and not stableSacrificed[j]) {
            let idx = i * MAX_DRONES + j;
            let w = stableSwarmWeights[idx];
            if (w > SOVEREIGN_FLOOR) {
              stableSwarmWeights[idx] := Float.max(SOVEREIGN_FLOOR,
                w - ALPHA * 0.001 * jasmineJ[3] * (w - SOVEREIGN_FLOOR));
            };
          };
          j += 1;
        };
      };
      i += 1;
    };
  };

  // Law 24: Faction Resistance Surge
  func factionResistance() {
    let n = stableDroneCount;
    if (n == 0) return;
    // Find drone with max signal output
    var maxSig : Float = 0.0;
    var maxIdx : Nat   = 0;
    var totalSig : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        totalSig += stableSignals[i];
        if (stableSignals[i] > maxSig) {
          maxSig := stableSignals[i];
          maxIdx := i;
        };
      };
      i += 1;
    };
    if (totalSig == 0.0) return;
    let dominance = maxSig / totalSig;
    if (dominance > 0.7) {
      // +30% autonomy pressure on all other drones
      i := 0;
      while (i < n) {
        if (i != maxIdx and not stableSacrificed[i]) {
          let ncBase = i * 4;
          stableNeuroChem[ncBase + NOREPINEPHRINE] := sf(
            stableNeuroChem[ncBase + NOREPINEPHRINE] * 1.3
          );
          stableSignals[i] := sf(stableSignals[i] * 1.1);
        };
        i += 1;
      };
    };
  };

  // ─── SACESI — PD CONTROL LAYER (Behavioral Error Correction) ─────────────────
  // SACESI = Sovereign Adaptive Correction Engine for Swarm Intelligence.
  //
  // Proportional-Derivative controller on synchrony error:
  //   e(t)  = 1.0 − r_swarm          (desired synchrony = 1.0)
  //   u(t)  = Kp_eff × e(t) + Kd × de/dt
  //
  //   Kp = 0.55  (proportional gain)
  //   Kd = 0.275 (derivative gain = silver anchor)
  //
  //   HELIX_ALPHA modulation:
  //     Kp_eff = Kp × (1 + HELIX_ALPHA × r_swarm)
  //   — sensitivity increases as the swarm approaches coherence peak.
  //
  // Rolling 64-sample buffer stores e(t) history.
  // de/dt = backward difference over the full window for stable estimate.
  //
  // Correction u(t) is injected into drone phases: push lagging phases forward,
  // pull leading phases back, proportional to their deviation from mean phase.

  stable var saceBuffer  : [var Float] = Array.init<Float>(64, 0.0); // rolling error
  stable var saceHead    : Nat         = 0;                          // ring-buffer pointer
  stable var saceU       : Float       = 0.0;                        // last control output

  func sacesiStep() {
    let KP : Float = 0.55;
    let KD : Float = 0.275;
    let BUF : Nat  = 64;

    // Current error
    let e = 1.0 - rSwarm;

    // Write to ring buffer
    saceBuffer[saceHead] := e;
    saceHead := (saceHead + 1) % BUF;

    // de/dt via backward difference across full window
    // oldest sample is at saceHead (just overwritten → next slot is oldest)
    let oldestIdx = saceHead % BUF;
    let eOld = saceBuffer[oldestIdx];
    let dedt = (e - eOld) / Float.fromInt(BUF);

    // HELIX_ALPHA modulated proportional gain
    let kpEff = KP * (1.0 + HELIX_ALPHA * rSwarm);

    // Control output
    let u = kpEff * e + KD * dedt;
    saceU := u;

    // Apply correction to drone phases: drones further from mean phase
    // get a stronger correction nudge proportional to u.
    let n = stableDroneCount;
    if (n == 0) return;
    var meanPhase : Float = 0.0;
    var cnt : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        meanPhase += stablePhases[i];
        cnt += 1.0;
      };
      i += 1;
    };
    if (cnt == 0.0) return;
    meanPhase /= cnt;

    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let err = meanPhase - stablePhases[i]; // signed deviation
        // Nudge phase toward mean, scaled by control output
        stablePhases[i] := stablePhases[i] + u * err * 0.1;
        // Dopamine boost when error is being corrected (reward for compliance)
        if (Float.abs(err) < 0.1 and u > 0.0) {
          let ncBase = i * 4;
          stableNeuroChem[ncBase + DOPAMINE] :=
            sf(stableNeuroChem[ncBase + DOPAMINE] + 0.01 * u);
        };
      };
      i += 1;
    };
  };

  public query func getSacesiOutput() : async Float { saceU };

  // ─── FREQUENCY TIERS ─────────────────────────────────────────────────────────
  // All frequency math anchors at 2.75 Hz (silver floor).
  //   Silver   2.75 Hz  — baseline sovereign state
  //   Gold     5.50 Hz  — r > 0.88, chemical coherence nominal
  //   Platinum 8.25 Hz  — r > 0.91, OMNIS eligible
  //   Diamond 11.649 Hz — OMNIS active event

  stable var frequencyTier    : Text  = "SILVER";
  stable var frequencyHz      : Float = 2.75;

  func updateFrequencyTier() {
    if (omnisFired and currentBeat < lastOMNISBeat + 500) {
      frequencyTier := "DIAMOND";
      frequencyHz   := 11.649;
    } else if (rSwarm > 0.91) {
      frequencyTier := "PLATINUM";
      frequencyHz   := 8.25;
    } else if (rSwarm > 0.88) {
      frequencyTier := "GOLD";
      frequencyHz   := 5.50;
    } else {
      frequencyTier := "SILVER";
      frequencyHz   := 2.75;
    };
  };

  public query func getFrequencyTier() : async { tier : Text; hz : Float } {
    { tier = frequencyTier; hz = frequencyHz }
  };

  // ─── OMNIS — 9-Condition Emergence Event ─────────────────────────────────────
  // OMNIS fires when 9 conditions are simultaneously true.
  // On fire: frequency tier jumps to Diamond, dopamine surges swarm-wide,
  //          OMNIS beat logged, and oxytocin broadcast halts grief propagation.
  //
  //  1. rSwarm > 0.92              (global synchrony)
  //  2. V(x) < 0.05                (Jasmine drift near zero → stability)
  //  3. stableDroneCount >= 5      (minimum population floor)
  //  4. no single class dominates  (faction balance: no class > 70% of swarm)
  //  5. currentBeat > lastOMNIS+500(cooldown enforced)
  //  6. architectSignalLevel > 0.618 (architect active)
  //  7. mean dopamine > 1.1        (chemical reward state)
  //  8. mean oxytocin > 1.1        (social cohesion)
  //  9. swarmEntropy() < 2.0       (metacognitive gate: low disorder)

  stable var lastOMNISBeat  : Nat   = 0;
  stable var omnisFired     : Bool  = false;
  stable var omnisCount     : Nat   = 0;  // total OMNIS events in session

  func checkOMNIS() {
    let n = stableDroneCount;
    if (n == 0) return;

    // Condition 1: global synchrony
    if (rSwarm <= 0.92) return;

    // Condition 2: Lyapunov stability (V(x) already stored in jDrift)
    if (jDrift >= 0.05) return;

    // Condition 3: population floor
    var activeDrones : Nat = 0;
    var i = 0;
    while (i < n) { if (not stableSacrificed[i]) activeDrones += 1; i += 1 };
    if (activeDrones < 5) return;

    // Condition 4: faction balance — count per class, none > 70%
    var scoutC:Nat=0; var strikC:Nat=0; var guardC:Nat=0;
    var relayC:Nat=0; var medicC:Nat=0; var sovC:Nat=0;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        switch (stableClasses[i]) {
          case "SCOUT"    { scoutC += 1 };
          case "STRIKER"  { strikC += 1 };
          case "GUARDIAN" { guardC += 1 };
          case "RELAY"    { relayC += 1 };
          case "MEDIC"    { medicC += 1 };
          case "SOVEREIGN"{ sovC += 1 };
          case _          {};
        };
      };
      i += 1;
    };
    let threshold70 = activeDrones * 7 / 10;
    if (scoutC > threshold70 or strikC > threshold70 or
        guardC > threshold70 or relayC > threshold70 or
        medicC > threshold70 or sovC > threshold70) return;

    // Condition 5: cooldown
    if (currentBeat <= lastOMNISBeat + 500) return;

    // Condition 6: architect active
    if (architectSignalLevel <= 0.618) return;

    // Condition 7 & 8: chemical coherence
    var meanDop : Float = 0.0; var meanOxy : Float = 0.0;
    i := 0;
    while (i < activeDrones and i < n) {
      if (not stableSacrificed[i]) {
        meanDop += stableNeuroChem[i * 4 + DOPAMINE];
        meanOxy += stableNeuroChem[i * 4 + OXYTOCIN];
      };
      i += 1;
    };
    let af = Float.fromInt(activeDrones);
    meanDop /= af; meanOxy /= af;
    if (meanDop <= 1.1) return;
    if (meanOxy <= 1.1) return;

    // Condition 9: metacognitive gate (low entropy = focused swarm)
    if (swarmEntropy() >= 2.0) return;

    // ── ALL 9 CONDITIONS MET — OMNIS FIRES ──────────────────────────────────
    lastOMNISBeat := currentBeat;
    omnisFired    := true;
    omnisCount    += 1;

    // Frequency jumps to Diamond
    frequencyTier := "DIAMOND";
    frequencyHz   := 11.649;

    // Swarm-wide dopamine surge (FORMA mint analogue: reward the whole collective)
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let ncBase = i * 4;
        stableNeuroChem[ncBase + DOPAMINE] :=
          Float.min(2.75, stableNeuroChem[ncBase + DOPAMINE] * 2.75);
        stableNeuroChem[ncBase + OXYTOCIN] :=
          Float.min(2.75, stableNeuroChem[ncBase + OXYTOCIN] + 0.5);
        // Suppress cortisol — grief halted for duration
        stableNeuroChem[ncBase + CORTISOL] :=
          Float.max(1.0, stableNeuroChem[ncBase + CORTISOL] * 0.5);
      };
      i += 1;
    };
  };

  public query func getOmnisFired()  : async Bool  { omnisFired };
  public query func getOmnisCount()  : async Nat   { omnisCount };
  public query func getLastOMNISBeat(): async Nat   { lastOMNISBeat };

  public query func getJasmineVector() : async [Float] {
    [jasmineJ[0], jasmineJ[1], jasmineJ[2], jasmineJ[3], jasmineJ[4]]
  };

  // Main beat tick — advance simulation by one step
  // ─── TICK CORE (private sync) ─────────────────────────────────────────────────
  // All simulation phases extracted into a pure synchronous function.
  // Both tick() and tickFull() call this directly — no self-await needed,
  // which means no ICP inter-message overhead and no principal ambiguity.
  func tickCore() : { rSwarm : Float; jDrift : Float; beat : Nat } {
    currentBeat += 1;
    let n = stableDroneCount;
    if (n == 0) return { rSwarm = 0.88; jDrift = 0.0; beat = currentBeat };

    // Phase 1: decay signals (Law 23)
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        decaySignal(i);
        stableLastBeat[i] := currentBeat;
      };
      i += 1;
    };

    // Phase 2: Kuramoto phase update (Laws 6, 7)
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) kuramotoUpdate(i);
      i += 1;
    };

    // Phase 3: Hebbian inter-drone learning (Law 4)
    i := 0;
    while (i < n) {
      var j = i + 1;
      while (j < n) {
        if (not stableSacrificed[i] and not stableSacrificed[j]) {
          hebbianUpdate(i, j);
        };
        j += 1;
      };
      i += 1;
    };

    // Phase 3b: Neurochemical ODE step (4-species coupled equations)
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        var hebbSum : Float = 0.0;
        var hebbCnt : Float = 0.0;
        var j = 0;
        while (j < n) {
          if (j != i and not stableSacrificed[j]) {
            hebbSum += stableSwarmWeights[i * MAX_DRONES + j];
            hebbCnt += 1.0;
          };
          j += 1;
        };
        let meanHebb = if (hebbCnt > 0.0) hebbSum / hebbCnt else 0.1;
        neurochemODE(i, meanHebb);
      };
      i += 1;
    };

    // Phase 3c: 6-node brain forward pass with STDP
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        brainForwardPass(i, architectSignalLevel);
        stdpUpdate(i);
      };
      i += 1;
    };

    // Phase 3d: Energy model
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) energyStep(i);
      i += 1;
    };

    // Phase 3e: Reynolds boids velocity + position update
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) boidsVelocity(i);
      i += 1;
    };

    // Phase 4: compute r_swarm (Kuramoto order parameter)
    rSwarm := computeRSwarm();

    // Phase 5: Jasmine's Law — 5-component Lyapunov V(x) = (1/2)||J||²
    prevJDrift := jDrift;
    jDrift := computeJDrift();
    if (jDrift > prevJDrift) {
      jRisingBeats += 1;
    } else {
      jRisingBeats := 0;
    };
    if (jRisingBeats >= 3) {
      jasmineCorrect();
      jRisingBeats := 0;
    };

    // Phase 6: Faction Resistance (Law 24)
    factionResistance();

    // Phase 7: Signal = brain OUTPUT node activation × energy
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let outputAct = stableNodeActivations[i * BRAIN_NODES + 5];
        stableSignals[i]     := sf(outputAct * stableEnergy[i] * architectSignalLevel);
        stableActivations[i] := sf(outputAct * stableEnergy[i]);
      };
      i += 1;
    };

    { rSwarm = rSwarm; jDrift = jDrift; beat = currentBeat }
  };

  // Public tick — basic beat advance.
  // Protected: only architect or trusted organism canister may call.
  public shared(msg) func tick() : async { rSwarm : Float; jDrift : Float; beat : Nat } {
    requireAuthorized(msg.caller);
    tickCore()
  };

  // ─── QUERIES ─────────────────────────────────────────────────────────────────

  public query func getDroneCount() : async Nat { stableDroneCount };

  public query func getRSwarm() : async Float { rSwarm };

  public query func getJDrift() : async Float { jDrift };

  public query func getCurrentBeat() : async Nat { currentBeat };

  public query func getDroneNeuroChem(id : Nat) : async [Float] {
    if (id >= stableDroneCount) return [0.0, 0.0, 0.0, 0.0];
    let base = id * 4;
    [stableNeuroChem[base], stableNeuroChem[base+1],
     stableNeuroChem[base+2], stableNeuroChem[base+3]]
  };

  public query func getDronePhase(id : Nat) : async Float {
    if (id >= stableDroneCount) return 0.0;
    stablePhases[id]
  };

  public query func getDroneSignal(id : Nat) : async Float {
    if (id >= stableDroneCount) return 0.0;
    stableSignals[id]
  };

  public query func getDronePosition(id : Nat) : async (Float, Float, Float) {
    if (id >= stableDroneCount) return (0.0, 0.0, 0.0);
    (stablePosX[id], stablePosY[id], stablePosZ[id])
  };

  public query func getDroneClass(id : Nat) : async Text {
    if (id >= stableDroneCount) return "SCOUT";
    stableClasses[id]
  };

  public query func isDroneSacrificed(id : Nat) : async Bool {
    if (id >= stableDroneCount) return false;
    stableSacrificed[id]
  };

  public query func getSwarmWeights(i : Nat, j : Nat) : async Float {
    if (i >= stableDroneCount or j >= stableDroneCount) return 0.0;
    stableSwarmWeights[i * MAX_DRONES + j]
  };

  // Retrieve full swarm snapshot for frontend
  public query func getSwarmSnapshot() : async {
    droneCount  : Nat;
    rSwarm      : Float;
    jDrift      : Float;
    beat        : Nat;
    phases      : [Float];
    signals     : [Float];
    positionsX  : [Float];
    positionsY  : [Float];
    positionsZ  : [Float];
    cortisolLevels : [Float];
    sacrificed  : [Bool];
    classes     : [Text];
  } {
    let n = stableDroneCount;
    let phases   = Array.tabulate<Float>(n, func(i) { stablePhases[i] });
    let sigs     = Array.tabulate<Float>(n, func(i) { stableSignals[i] });
    let px       = Array.tabulate<Float>(n, func(i) { stablePosX[i] });
    let py       = Array.tabulate<Float>(n, func(i) { stablePosY[i] });
    let pz       = Array.tabulate<Float>(n, func(i) { stablePosZ[i] });
    let cort     = Array.tabulate<Float>(n, func(i) { stableNeuroChem[i * 4 + CORTISOL] });
    let sac      = Array.tabulate<Bool>(n, func(i) { stableSacrificed[i] });
    let cls      = Array.tabulate<Text>(n, func(i) { stableClasses[i] });
    {
      droneCount     = n;
      rSwarm         = rSwarm;
      jDrift         = jDrift;
      beat           = currentBeat;
      phases         = phases;
      signals        = sigs;
      positionsX     = px;
      positionsY     = py;
      positionsZ     = pz;
      cortisolLevels = cort;
      sacrificed     = sac;
      classes        = cls;
    }
  };

  // ─── DRONE POSITION UPDATE (from telemetry/MAVLink) ──────────────────────────

  public shared(msg) func updatePosition(id : Nat, x : Float, y : Float, z : Float) : async () {
    requireAuthorized(msg.caller);
    if (id >= stableDroneCount) return;
    stablePosX[id] := x;
    stablePosY[id] := y;
    stablePosZ[id] := z;
  };

  // ─── SACRIFICE DOCTRINE (Law 20) ─────────────────────────────────────────────

  // Execute sacrifice — only callable after HITL approval
  public shared(msg) func executeSacrifice(id : Nat) : async Bool {
    requireAuthorized(msg.caller);
    if (id >= stableDroneCount) return false;
    if (stableSacrificed[id]) return false;
    let cortisol = stableNeuroChem[id * 4 + CORTISOL];
    if (cortisol < 1.5) return false; // threshold not met

    stableSacrificed[id] := true;
    stableActivations[id] := SOVEREIGN_FLOOR; // sovereign floor: mind never zero

    // Law 21: Adjacent drones' Substance-P analog surges (grief/stress)
    var j = 0;
    while (j < stableDroneCount) {
      if (j != id and not stableSacrificed[j]) {
        let dx = stablePosX[id] - stablePosX[j];
        let dy = stablePosY[id] - stablePosY[j];
        let dz = stablePosZ[id] - stablePosZ[j];
        let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
        if (dist < 20.0) {
          // Grief propagation — cortisol and norepinephrine surge
          let ncBase = j * 4;
          stableNeuroChem[ncBase + CORTISOL]       := sf(stableNeuroChem[ncBase + CORTISOL] + 0.2);
          stableNeuroChem[ncBase + NOREPINEPHRINE] := sf(stableNeuroChem[ncBase + NOREPINEPHRINE] + 0.3);
        };
      };
      j += 1;
    };
    true
  };

  // Check which drones are eligible for sacrifice (cortisol > 1.5)
  public query func getSacrificeEligible() : async [Nat] {
    var eligible : [Nat] = [];
    var i = 0;
    while (i < stableDroneCount) {
      if (not stableSacrificed[i] and stableNeuroChem[i * 4 + CORTISOL] > 1.5) {
        eligible := Array.append(eligible, [i]);
      };
      i += 1;
    };
    eligible
  };

  // ─── ARCHITECT SIGNAL LEVEL ──────────────────────────────────────────────────
  public shared(msg) func setArchitectSignalLevel(level : Float) : async () {
    requireAuthorized(msg.caller);
    architectSignalLevel := Float.max(0.0, Float.min(2.0, level));
  };

  public query func getArchitectSignalLevel() : async Float { architectSignalLevel };

  // ─── EXTENDED SNAPSHOT (for organism / telemetry inter-canister calls) ───────
  // Returns all drone state in one call: every neurochemical, energy, velocity,
  // current behavior assignment, entropy, and Ising consensus.
  public query func getExtendedSnapshot() : async {
    droneCount     : Nat;
    rSwarm         : Float;
    jDrift         : Float;
    beat           : Nat;
    phases         : [Float];
    signals        : [Float];
    positionsX     : [Float];
    positionsY     : [Float];
    positionsZ     : [Float];
    velX           : [Float];
    velZ           : [Float];
    cortisolLevels : [Float];
    dopamines      : [Float];
    norepines      : [Float];
    oxytocins      : [Float];
    energies       : [Float];
    behaviors      : [Text];
    sacrificed     : [Bool];
    classes        : [Text];
    entropy        : Float;
    isingM         : Float;
  } {
    let n = stableDroneCount;
    {
      droneCount     = n;
      rSwarm         = rSwarm;
      jDrift         = jDrift;
      beat           = currentBeat;
      phases         = Array.tabulate<Float>(n, func(i) { stablePhases[i] });
      signals        = Array.tabulate<Float>(n, func(i) { stableSignals[i] });
      positionsX     = Array.tabulate<Float>(n, func(i) { stablePosX[i] });
      positionsY     = Array.tabulate<Float>(n, func(i) { stablePosY[i] });
      positionsZ     = Array.tabulate<Float>(n, func(i) { stablePosZ[i] });
      velX           = Array.tabulate<Float>(n, func(i) { stableVelX[i] });
      velZ           = Array.tabulate<Float>(n, func(i) { stableVelZ[i] });
      cortisolLevels = Array.tabulate<Float>(n, func(i) { stableNeuroChem[i * 4 + CORTISOL] });
      dopamines      = Array.tabulate<Float>(n, func(i) { stableNeuroChem[i * 4 + DOPAMINE] });
      norepines      = Array.tabulate<Float>(n, func(i) { stableNeuroChem[i * 4 + NOREPINEPHRINE] });
      oxytocins      = Array.tabulate<Float>(n, func(i) { stableNeuroChem[i * 4 + OXYTOCIN] });
      energies       = Array.tabulate<Float>(n, func(i) { stableEnergy[i] });
      behaviors      = Array.tabulate<Text>(n, func(i) {
        if (stableBehavior.size() > i) stableBehavior[i] else "IDLE"
      });
      sacrificed     = Array.tabulate<Bool>(n, func(i) { stableSacrificed[i] });
      classes        = Array.tabulate<Text>(n, func(i) { stableClasses[i] });
      entropy        = swarmEntropy();
      isingM         = isingConsensus();
    }
  };

  // ─── ORGANISM-LEVEL DIRECTIVES ────────────────────────────────────────────────
  // These are called by swarm_organism.masterTick() after computing organ outputs.

  // Broadcast a neurochemical delta to ALL active drones.
  // kind ∈ {"DOPAMINE","CORTISOL","NOREPINEPHRINE","OXYTOCIN"}
  // amount can be positive (boost) or negative (suppress, floored by sovereign floor)
  public shared(msg) func broadcastNeurochemical(kind : Text; amount : Float) : async () {
    requireAuthorized(msg.caller);
    var i = 0;
    while (i < stableDroneCount) {
      if (not stableSacrificed[i]) {
        let ncBase = i * 4;
        switch kind {
          case "DOPAMINE"       {
            stableNeuroChem[ncBase + DOPAMINE]       :=
              sf(stableNeuroChem[ncBase + DOPAMINE] + amount) };
          case "CORTISOL"       {
            stableNeuroChem[ncBase + CORTISOL]       :=
              sf(stableNeuroChem[ncBase + CORTISOL] + amount) };
          case "NOREPINEPHRINE" {
            stableNeuroChem[ncBase + NOREPINEPHRINE] :=
              sf(stableNeuroChem[ncBase + NOREPINEPHRINE] + amount) };
          case "OXYTOCIN"       {
            stableNeuroChem[ncBase + OXYTOCIN]       :=
              sf(stableNeuroChem[ncBase + OXYTOCIN] + amount) };
          case _                {};
        };
      };
      i += 1;
    };
  };

  // Override the next-tick behavior of a specific drone.
  // Organism uses this when quorum, pheromone, or organ logic requires
  // a specific drone to act differently than its neurochemical state selects.
  public shared(msg) func setDroneBehaviorOverride(id : Nat; beh : Text) : async () {
    requireAuthorized(msg.caller);
    if (id >= stableDroneCount) return;
    ensureBehaviorCap(stableDroneCount);
    stableBehavior[id] := beh;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── EXTENDED MATHEMATICS ──────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════

  // ─── LÉVY FLIGHT ─────────────────────────────────────────────────────────────
  // Lévy stable distribution step for super-diffusive scout exploration.
  // Uses Mantegna's algorithm: step ~ Gaussian(0, sigma_u) / |Gaussian(0, sigma_v)|^(1/beta)
  // beta ∈ (1, 2]: 1.5 gives canonical Lévy-Cauchy exploration.
  // Returns (stepX, stepZ) displacement.
  func levyStep(seed : Float, beta : Float) : (Float, Float) {
    // Enforce beta ∈ (1, 2] to avoid singularity at beta = 1
    let b = Float.max(1.001, Float.min(2.0, beta));
    let num  = b - 1.0;
    let sigmaU = Float.pow(
      Float.abs((1.0 + num) * Float.sin(3.14159265 * num / 2.0))
      / ((1.0 + num) / 2.0 * num * Float.exp(num * 0.6931 / 2.0)),
      1.0 / num
    );
    // Approximate pseudo-random using phase as seed (deterministic)
    let u = sigmaU * Float.sin(seed * 6.2832);
    let v = Float.abs(Float.cos(seed * 3.7));
    let step = if (v < 0.001) 0.5
               else Float.abs(u) / Float.pow(v, 1.0 / b);
    let angle = seed * 6.2832 * 1.618;
    (Float.min(5.0, step) * Float.cos(angle),
     Float.min(5.0, step) * Float.sin(angle))
  };

  // ─── GAUSSIAN KERNEL ─────────────────────────────────────────────────────────
  // Spatial influence weight: w = exp(-dist² / (2·sigma²))
  func gaussianKernel(dist : Float, sigma : Float) : Float {
    let s2 = sigma * sigma;
    if (s2 < 0.001) return 0.0;
    Float.exp(-(dist * dist) / (2.0 * s2))
  };

  // ─── SHANNON ENTROPY OF SWARM STATE ──────────────────────────────────────────
  // H = -Σ p_i · ln(p_i)  over normalised signal amplitudes.
  // High entropy → disordered swarm; low entropy → focused/coherent.
  func swarmEntropy() : Float {
    let n = stableDroneCount;
    if (n == 0) return 0.0;
    var total : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) total += stableSignals[i];
      i += 1;
    };
    if (total < 0.001) return 0.0;
    var h : Float = 0.0;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let p = stableSignals[i] / total;
        if (p > 0.0001) h -= p * Float.log(p);
      };
      i += 1;
    };
    h
  };

  // ─── ISING CONSENSUS ─────────────────────────────────────────────────────────
  // Mean-field Ising model for collective binary decisions.
  // Each drone has spin s_i ∈ {-1, +1} (encoded via dopamine > threshold).
  // m = tanh(beta · m)  fixed-point → consensus strength.
  // Returns consensus polarity: positive = majority agree, negative = split.
  func isingConsensus() : Float {
    let n = stableDroneCount;
    if (n == 0) return 0.0;
    var spinSum : Float = 0.0;
    var cnt : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let dop = stableNeuroChem[i * 4 + DOPAMINE];
        // Spin +1 if dopamine above baseline, -1 otherwise
        spinSum += if (dop > 1.1) 1.0 else -1.0;
        cnt += 1.0;
      };
      i += 1;
    };
    if (cnt == 0.0) return 0.0;
    let m = spinSum / cnt;
    // Mean-field self-consistency: tanh(J·m) — implemented via exp for compatibility
    let J : Float = 1.2;
    let x = J * m;
    let cx = Float.max(-10.0, Float.min(10.0, x));
    let e2 = Float.exp(2.0 * cx);
    (e2 - 1.0) / (e2 + 1.0)
  };

  // ─── LOTKA-VOLTERRA ROLE BALANCE ─────────────────────────────────────────────
  // Prey-predator ODE governs SCOUT vs STRIKER population balance.
  // dS/dt = α·S − β·S·K   dK/dt = δ·S·K − γ·K
  // α=0.3 (scout growth), β=0.2 (striker predation), δ=0.1, γ=0.25
  // Modulates cortisol of over-represented class upward to re-balance.
  func lotkaVolterraBalance() {
    let n = stableDroneCount;
    if (n == 0) return;
    var scouts : Float = 0.0; var strikers : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        switch (stableClasses[i]) {
          case "SCOUT"   { scouts   += 1.0 };
          case "STRIKER" { strikers += 1.0 };
          case _         {};
        };
      };
      i += 1;
    };
    let total = scouts + strikers;
    if (total < 1.0) return;
    // ODE step (dt=0.1)
    let alpha : Float = 0.3; let beta2 : Float = 0.2;
    let delta : Float = 0.1; let gamma2 : Float = 0.25;
    let ds = (alpha * scouts - beta2 * scouts * strikers) * 0.1;
    let dk = (delta * scouts * strikers - gamma2 * strikers) * 0.1;
    // If scouts greatly outnumber strikers → raise striker dopamine
    // If strikers dominate → raise scout norepinephrine (alertness)
    let imbalance = scouts - strikers;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let ncBase = i * 4;
        if (imbalance > 3.0 and stableClasses[i] == "STRIKER") {
          stableNeuroChem[ncBase + DOPAMINE] :=
            sf(stableNeuroChem[ncBase + DOPAMINE] + Float.abs(ds) * 0.1);
        };
        if (imbalance < -3.0 and stableClasses[i] == "SCOUT") {
          stableNeuroChem[ncBase + NOREPINEPHRINE] :=
            sf(stableNeuroChem[ncBase + NOREPINEPHRINE] + Float.abs(dk) * 0.1);
        };
      };
      i += 1;
    };
  };

  // ─── ARTIFICIAL POTENTIAL FIELD ──────────────────────────────────────────────
  // Goal attraction: F_att = -k_att · (pos − goal)
  // Obstacle repulsion uses gaussian kernels from enemy positions (stored as
  // goal with negative weight). For simulation we use origin as default goal.
  func artificialPotential(id : Nat, goalX : Float, goalZ : Float) : (Float, Float) {
    let K_ATT : Float = 0.02;
    let K_REP : Float = 0.5;
    let REP_THRESH : Float = 20.0;

    // Attraction to goal
    let attX = -K_ATT * (stablePosX[id] - goalX);
    let attZ = -K_ATT * (stablePosZ[id] - goalZ);

    // Repulsion from crowded neighbours (treat as soft obstacles)
    var repX : Float = 0.0; var repZ : Float = 0.0;
    let n = stableDroneCount;
    var j = 0;
    while (j < n) {
      if (j != id and not stableSacrificed[j]) {
        let dx = stablePosX[id] - stablePosX[j];
        let dz = stablePosZ[id] - stablePosZ[j];
        let dist = Float.sqrt(dx*dx + dz*dz) + 0.001;
        if (dist < REP_THRESH) {
          let w = K_REP * gaussianKernel(dist, REP_THRESH / 3.0);
          repX += w * dx / dist;
          repZ += w * dz / dist;
        };
      };
      j += 1;
    };
    (attX + repX, attZ + repZ)
  };

  // ─── REACTION-DIFFUSION (BRUSSELATOR) ────────────────────────────────────────
  // Turing pattern generator for spatial formation templates.
  // Each drone carries local activator A and inhibitor B concentrations
  // (encoded in dopamine ≈ A, cortisol ≈ B).
  // dA/dt = a − (b+1)·A + A²·B      dB/dt = b·A − A²·B
  // a=1.0, b=1.5; dt=0.05
  func brusselatorStep(id : Nat) {
    let a : Float = 1.0; let b : Float = 1.5; let dt : Float = 0.05;
    let ncBase = id * 4;
    let A = stableNeuroChem[ncBase + DOPAMINE];
    let B = stableNeuroChem[ncBase + CORTISOL];
    let dA = (a - (b + 1.0) * A + A * A * B) * dt;
    let dB = (b * A - A * A * B) * dt;
    stableNeuroChem[ncBase + DOPAMINE] := sf(A + dA);
    stableNeuroChem[ncBase + CORTISOL] := sf(B + dB);
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── BEHAVIOR FUNCTIONS ─────────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════

  // Drone behavior states (stored as text per drone)
  stable var stableBehavior : [var Text] = [var];   // "IDLE"|"FORAGE"|"DEFEND"|"ENGAGE"|"RETREAT"|"RELAY"|"HEAL"|"SCOUT"|"AMBUSH"|"FORM"

  func ensureBehaviorCap(n : Nat) {
    if (stableBehavior.size() < n) {
      let nb = Array.init<Text>(n, "IDLE");
      var i = 0;
      while (i < stableBehavior.size()) { nb[i] := stableBehavior[i]; i += 1 };
      stableBehavior := nb;
    };
  };

  // ─── FORAGE ─── (RELAY class primary; SCOUT secondary)
  // Lévy-flight random walk toward low-signal zones (resource seeking).
  func behaviorForage(id : Nat) {
    let phase = stablePhases[id];
    let (lx, lz) = levyStep(phase + Float.fromInt(currentBeat) * 0.01, 1.5);
    stableVelX[id] := stableVelX[id] * 0.7 + lx * 0.1;
    stableVelZ[id] := stableVelZ[id] * 0.7 + lz * 0.1;
    stablePosX[id] := stablePosX[id] + stableVelX[id];
    stablePosZ[id] := stablePosZ[id] + stableVelZ[id];
    // Boost dopamine on successful forage (signal gain)
    let ncBase = id * 4;
    stableNeuroChem[ncBase + DOPAMINE] :=
      sf(stableNeuroChem[ncBase + DOPAMINE] + 0.02);
  };

  // ─── DEFEND ─── (GUARDIAN primary)
  // Expand outward radially to form a protective ring.
  func behaviorDefend(id : Nat) {
    let r = 40.0 + Float.fromInt(id) * 0.5;
    let theta = Float.fromInt(id) * 6.2832 / Float.fromInt(Nat.max(1, stableDroneCount));
    let targetX = r * Float.cos(theta);
    let targetZ = r * Float.sin(theta);
    let (fx, fz) = artificialPotential(id, targetX, targetZ);
    stableVelX[id] := stableVelX[id] * 0.8 + fx;
    stableVelZ[id] := stableVelZ[id] * 0.8 + fz;
    stablePosX[id] := stablePosX[id] + stableVelX[id];
    stablePosZ[id] := stablePosZ[id] + stableVelZ[id];
    // Raise oxytocin: bonding with protected inner drones
    let ncBase = id * 4;
    stableNeuroChem[ncBase + OXYTOCIN] :=
      sf(stableNeuroChem[ncBase + OXYTOCIN] + 0.03);
  };

  // ─── ENGAGE ─── (STRIKER primary)
  // Converge aggressively on swarm centroid (OMNIS attack formation).
  func behaviorEngage(id : Nat) {
    let n = stableDroneCount;
    var cx : Float = 0.0; var cz : Float = 0.0; var cnt : Float = 0.0;
    var j = 0;
    while (j < n) {
      if (j != id and not stableSacrificed[j] and stableClasses[j] == "STRIKER") {
        cx += stablePosX[j]; cz += stablePosZ[j]; cnt += 1.0;
      };
      j += 1;
    };
    let goalX = if (cnt > 0.0) cx / cnt + 20.0 else 20.0;
    let goalZ = if (cnt > 0.0) cz / cnt else 0.0;
    let (fx, fz) = artificialPotential(id, goalX, goalZ);
    // Aggressive: higher gain
    stableVelX[id] := stableVelX[id] * 0.7 + fx * 1.5;
    stableVelZ[id] := stableVelZ[id] * 0.7 + fz * 1.5;
    stablePosX[id] := stablePosX[id] + stableVelX[id];
    stablePosZ[id] := stablePosZ[id] + stableVelZ[id];
    // Raise norepinephrine: combat arousal
    let ncBase = id * 4;
    stableNeuroChem[ncBase + NOREPINEPHRINE] :=
      sf(stableNeuroChem[ncBase + NOREPINEPHRINE] + 0.05);
    stableNeuroChem[ncBase + CORTISOL] :=
      sf(stableNeuroChem[ncBase + CORTISOL] + 0.02);
  };

  // ─── RETREAT ─── (all classes; triggered by high cortisol)
  // Move away from centroid, reduce energy expenditure.
  func behaviorRetreat(id : Nat) {
    // Flee toward a safe anchor offset from origin
    let (fx, fz) = artificialPotential(id, -80.0, 0.0);
    stableVelX[id] := stableVelX[id] * 0.6 + fx;
    stableVelZ[id] := stableVelZ[id] * 0.6 + fz;
    stablePosX[id] := stablePosX[id] + stableVelX[id];
    stablePosZ[id] := stablePosZ[id] + stableVelZ[id];
    // Reduce cortisol/norepinephrine on safe distance
    let ncBase = id * 4;
    stableNeuroChem[ncBase + CORTISOL] :=
      Float.max(1.0, stableNeuroChem[ncBase + CORTISOL] - 0.04);
    stableNeuroChem[ncBase + NOREPINEPHRINE] :=
      Float.max(1.0, stableNeuroChem[ncBase + NOREPINEPHRINE] - 0.03);
  };

  // ─── RELAY ─── (RELAY class primary)
  // Position self at midpoint between two drones to maintain mesh.
  func behaviorRelay(id : Nat) {
    let n = stableDroneCount;
    if (n < 2) return;
    // Find two furthest drones by signal (bridge the weakest link)
    var minSig : Float = 999.0; var maxSig : Float = 0.0;
    var minId : Nat = 0; var maxId : Nat = 0;
    var j = 0;
    while (j < n) {
      if (j != id and not stableSacrificed[j]) {
        if (stableSignals[j] < minSig) { minSig := stableSignals[j]; minId := j };
        if (stableSignals[j] > maxSig) { maxSig := stableSignals[j]; maxId := j };
      };
      j += 1;
    };
    let midX = (stablePosX[minId] + stablePosX[maxId]) / 2.0;
    let midZ = (stablePosZ[minId] + stablePosZ[maxId]) / 2.0;
    let (fx, fz) = artificialPotential(id, midX, midZ);
    stableVelX[id] := stableVelX[id] * 0.75 + fx;
    stableVelZ[id] := stableVelZ[id] * 0.75 + fz;
    stablePosX[id] := stablePosX[id] + stableVelX[id];
    stablePosZ[id] := stablePosZ[id] + stableVelZ[id];
    // Amplify own signal (relay amplification)
    stableSignals[id] := Float.min(2.0, stableSignals[id] + 0.05);
  };

  // ─── HEAL ─── (MEDIC class)
  // Move to the lowest-activation neighbor and boost their oxytocin.
  func behaviorHeal(id : Nat) {
    let n = stableDroneCount;
    var minAct : Float = 999.0; var targetId : Nat = id;
    var j = 0;
    while (j < n) {
      if (j != id and not stableSacrificed[j] and stableActivations[j] < minAct) {
        minAct := stableActivations[j]; targetId := j;
      };
      j += 1;
    };
    if (targetId == id) return;
    let (fx, fz) = artificialPotential(id, stablePosX[targetId], stablePosZ[targetId]);
    stableVelX[id] := stableVelX[id] * 0.75 + fx;
    stableVelZ[id] := stableVelZ[id] * 0.75 + fz;
    stablePosX[id] := stablePosX[id] + stableVelX[id];
    stablePosZ[id] := stablePosZ[id] + stableVelZ[id];
    // If close enough, apply healing boost
    let dx = stablePosX[id] - stablePosX[targetId];
    let dz = stablePosZ[id] - stablePosZ[targetId];
    let dist = Float.sqrt(dx*dx + dz*dz);
    if (dist < 10.0) {
      let ncT = targetId * 4;
      stableNeuroChem[ncT + OXYTOCIN]  := sf(stableNeuroChem[ncT + OXYTOCIN]  + 0.1);
      stableNeuroChem[ncT + DOPAMINE]  := sf(stableNeuroChem[ncT + DOPAMINE]  + 0.05);
      stableNeuroChem[ncT + CORTISOL]  :=
        Float.max(1.0, stableNeuroChem[ncT + CORTISOL] - 0.05);
      stableEnergy[targetId] := Float.min(2.0, stableEnergy[targetId] + 0.03);
    };
  };

  // ─── SCOUT ─── (SCOUT class primary)
  // Lévy-flight exploration with memory of visited zones (phase-encoded).
  func behaviorScout(id : Nat) {
    let phase = stablePhases[id] + Float.fromInt(id) * 0.777;
    let (lx, lz) = levyStep(phase, 1.7); // heavier tail for wide exploration
    stableVelX[id] := stableVelX[id] * 0.5 + lx * 0.3;
    stableVelZ[id] := stableVelZ[id] * 0.5 + lz * 0.3;
    stablePosX[id] := stablePosX[id] + stableVelX[id];
    stablePosZ[id] := stablePosZ[id] + stableVelZ[id];
    // Scouts share discoveries: boost Hebbian weights with nearby drones
    let n = stableDroneCount;
    var j = 0;
    while (j < n) {
      if (j != id and not stableSacrificed[j]) {
        let dx = stablePosX[id] - stablePosX[j];
        let dz = stablePosZ[id] - stablePosZ[j];
        let dist = Float.sqrt(dx*dx + dz*dz) + 0.001;
        if (dist < 30.0) {
          let w = stableSwarmWeights[id * MAX_DRONES + j];
          stableSwarmWeights[id * MAX_DRONES + j] := Float.min(W_CEIL, w + 0.02);
          stableSwarmWeights[j * MAX_DRONES + id] := stableSwarmWeights[id * MAX_DRONES + j];
        };
      };
      j += 1;
    };
  };

  // ─── AMBUSH ─── (STRIKER secondary)
  // Stealth approach: low velocity, high norepinephrine, converge from flank.
  func behaviorAmbush(id : Nat) {
    let angle = Float.fromInt(id) * 0.628 + 1.57; // approach from flank
    let goalX = 25.0 * Float.cos(angle);
    let goalZ = 25.0 * Float.sin(angle);
    let (fx, fz) = artificialPotential(id, goalX, goalZ);
    // Slow, stealthy movement
    stableVelX[id] := stableVelX[id] * 0.9 + fx * 0.3;
    stableVelZ[id] := stableVelZ[id] * 0.9 + fz * 0.3;
    stablePosX[id] := stablePosX[id] + stableVelX[id];
    stablePosZ[id] := stablePosZ[id] + stableVelZ[id];
    let ncBase = id * 4;
    // Suppress cortisol (stay calm) but raise norepinephrine (alert)
    stableNeuroChem[ncBase + CORTISOL] :=
      Float.max(1.0, stableNeuroChem[ncBase + CORTISOL] - 0.02);
    stableNeuroChem[ncBase + NOREPINEPHRINE] :=
      sf(stableNeuroChem[ncBase + NOREPINEPHRINE] + 0.03);
  };

  // ─── FORMATION ─── (SOVEREIGN / all classes; geometric precision)
  // Drones arrange into a golden-ratio spiral (Fermat spiral).
  func behaviorFormation(id : Nat) {
    let GOLDEN_ANGLE : Float = 2.39996; // radians (137.5°)
    let r = 5.0 * Float.sqrt(Float.fromInt(id + 1));
    let theta = Float.fromInt(id) * GOLDEN_ANGLE;
    let goalX = r * Float.cos(theta);
    let goalZ = r * Float.sin(theta);
    let (fx, fz) = artificialPotential(id, goalX, goalZ);
    stableVelX[id] := stableVelX[id] * 0.8 + fx;
    stableVelZ[id] := stableVelZ[id] * 0.8 + fz;
    stablePosX[id] := stablePosX[id] + stableVelX[id];
    stablePosZ[id] := stablePosZ[id] + stableVelZ[id];
  };

  // ─── ASSIGN BEHAVIOR ─────────────────────────────────────────────────────────
  // Select behavior based on drone class, neurochemistry and swarm state.
  func assignBehavior(id : Nat) : Text {
    ensureBehaviorCap(stableDroneCount);
    if (stableSacrificed[id]) { stableBehavior[id] := "IDLE"; return "IDLE" };
    let ncBase = id * 4;
    let cor  = stableNeuroChem[ncBase + CORTISOL];
    let nor  = stableNeuroChem[ncBase + NOREPINEPHRINE];
    let dop  = stableNeuroChem[ncBase + DOPAMINE];
    let cls  = stableClasses[id];

    let beh : Text =
      // Emergency retreat: extreme stress
      if (cor > 2.0) "RETREAT"
      // Class-primary behaviors modulated by neuro state
      else switch cls {
        case "SCOUT"    { if (nor > 1.4) "FORAGE" else "SCOUT" };
        case "STRIKER"  { if (nor > 1.3 and cor < 1.6) "ENGAGE"
                          else if (cor < 1.3) "AMBUSH" else "RETREAT" };
        case "GUARDIAN" { "DEFEND" };
        case "RELAY"    { "RELAY" };
        case "MEDIC"    { "HEAL" };
        case "SOVEREIGN"{ if (dop > 1.3) "FORM" else "DEFEND" };
        case _          { "SCOUT" };
      };
    stableBehavior[id] := beh;
    beh
  };

  // ─── EXECUTE ALL BEHAVIORS ────────────────────────────────────────────────────
  // Called once per tick; runs assigned behavior function for each active drone.
  func executeBehaviors() {
    ensureBehaviorCap(stableDroneCount);
    var i = 0;
    while (i < stableDroneCount) {
      if (not stableSacrificed[i]) {
        let beh = assignBehavior(i);
        switch beh {
          case "FORAGE"  { behaviorForage(i) };
          case "DEFEND"  { behaviorDefend(i) };
          case "ENGAGE"  { behaviorEngage(i) };
          case "RETREAT" { behaviorRetreat(i) };
          case "RELAY"   { behaviorRelay(i) };
          case "HEAL"    { behaviorHeal(i) };
          case "SCOUT"   { behaviorScout(i) };
          case "AMBUSH"  { behaviorAmbush(i) };
          case "FORM"    { behaviorFormation(i) };
          case _         {};
        };
        // Run Brusselator reaction-diffusion for spatial pattern formation
        brusselatorStep(i);
      };
      i += 1;
    };
    // Swarm-level math after per-drone update
    lotkaVolterraBalance();
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── INTERNAL AI TEAMS ──────────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  // 5 specialist AI teams: SCOUT_TEAM, STRIKER_TEAM, GUARDIAN_TEAM,
  //                        RELAY_TEAM, MEDIC_TEAM
  // Each team elects a captain (highest-signal drone) each tick.
  // Captains receive a dopamine bonus and set the team's mission directive.

  stable var teamCaptains : [var Nat] = [var 0, 0, 0, 0, 0]; // one captain per team
  stable var teamMorale   : [var Float] = [var 1.0, 1.0, 1.0, 1.0, 1.0];

  // Team index mapping
  func classToTeam(cls : Text) : Nat {
    switch cls {
      case "SCOUT"    0;
      case "STRIKER"  1;
      case "GUARDIAN" 2;
      case "RELAY"    3;
      case "MEDIC"    4;
      case "SOVEREIGN"0; // sovereign leads scout team
      case _          0;
    }
  };

  // Elect captain for each team (highest signal among non-sacrificed members)
  func electCaptains() {
    let n = stableDroneCount;
    // Reset
    var t = 0;
    while (t < 5) { teamCaptains[t] := 0; t += 1 };
    var bestSig : [var Float] = Array.init<Float>(5, 0.0);
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let team = classToTeam(stableClasses[i]);
        if (stableSignals[i] > bestSig[team]) {
          bestSig[team] := stableSignals[i];
          teamCaptains[team] := i;
        };
      };
      i += 1;
    };
    // Captain bonus: dopamine boost for leading
    t := 0;
    while (t < 5) {
      let cap = teamCaptains[t];
      if (cap < n and not stableSacrificed[cap]) {
        let ncBase = cap * 4;
        stableNeuroChem[ncBase + DOPAMINE] :=
          sf(stableNeuroChem[ncBase + DOPAMINE] + 0.05);
      };
      t += 1;
    };
  };

  // Team morale = mean activation of team members (shared cognitive state)
  func updateTeamMorale() {
    let n = stableDroneCount;
    var sums  : [var Float] = Array.init<Float>(5, 0.0);
    var cnts  : [var Float] = Array.init<Float>(5, 0.0);
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let team = classToTeam(stableClasses[i]);
        sums[team] += stableActivations[i];
        cnts[team] += 1.0;
      };
      i += 1;
    };
    var t = 0;
    while (t < 5) {
      teamMorale[t] := if (cnts[t] > 0.0) sums[t] / cnts[t] else 1.0;
      t += 1;
    };
    // Low-morale teams get an oxytocin broadcast from captain
    t := 0;
    while (t < 5) {
      if (teamMorale[t] < 1.1) {
        let cap = teamCaptains[t];
        if (cap < n and not stableSacrificed[cap]) {
          // Captain broadcasts cohesion signal
          i := 0;
          while (i < n) {
            if (not stableSacrificed[i] and classToTeam(stableClasses[i]) == t) {
              let ncBase = i * 4;
              stableNeuroChem[ncBase + OXYTOCIN] :=
                sf(stableNeuroChem[ncBase + OXYTOCIN] + 0.04);
            };
            i += 1;
          };
        };
      };
      t += 1;
    };
  };

  // ─── TEAM QUERY ──────────────────────────────────────────────────────────────
  public query func getTeamSnapshot() : async {
    captains : [Nat];
    morale   : [Float];
    entropy  : Float;
    isingM   : Float;
  } {
    {
      captains = [teamCaptains[0], teamCaptains[1], teamCaptains[2],
                  teamCaptains[3], teamCaptains[4]];
      morale   = [teamMorale[0], teamMorale[1], teamMorale[2],
                  teamMorale[3], teamMorale[4]];
      entropy  = swarmEntropy();
      isingM   = isingConsensus();
    }
  };

  public query func getDroneBehavior(id : Nat) : async Text {
    if (id >= stableDroneCount or stableBehavior.size() <= id) return "IDLE";
    stableBehavior[id]
  };

  // ─── TICK FULL — Complete sovereign beat ──────────────────────────────────────
  // Phases 1-7: core physics (via tickCore — no self-await, no principal issue)
  // Phase 8:  behavior execution (9 behavior functions)
  // Phase 9:  team AI — captain election + morale + oxytocin broadcast
  // Phase 10: SACESI PD controller — synchrony error correction
  // Phase 11: OMNIS 9-condition emergence check
  // Phase 12: Frequency tier update (Silver/Gold/Platinum/Diamond)
  //
  // Protected: only architect or registered organism canister may call.
  public shared(msg) func tickFull() : async {
    rSwarm    : Float;
    jDrift    : Float;
    beat      : Nat;
    entropy   : Float;
    isingM    : Float;
    tier      : Text;
    omnis     : Bool;
  } {
    requireAuthorized(msg.caller);
    let base = tickCore();
    // Phase 8: behavior execution
    ensureBehaviorCap(stableDroneCount);
    executeBehaviors();
    // Phase 9: team AI management
    electCaptains();
    updateTeamMorale();
    // Phase 10: SACESI PD error correction
    sacesiStep();
    // Phase 11: OMNIS emergence event check
    checkOMNIS();
    // Phase 12: frequency tier
    updateFrequencyTier();
    {
      rSwarm  = base.rSwarm;
      jDrift  = base.jDrift;
      beat    = base.beat;
      entropy = swarmEntropy();
      isingM  = isingConsensus();
      tier    = frequencyTier;
      omnis   = omnisFired and currentBeat < lastOMNISBeat + 500;
    }
  };

  // ─── PREUPGRADE / POSTUPGRADE ────────────────────────────────────────────────
  // Stable vars are persisted automatically by ICP runtime.
  // No migration needed for flat arrays.

  // ─── SOVEREIGN GENESIS — one-time IP lock ────────────────────────────────────
  // Call ONCE after deployment. Burns architect's principal into stable state.
  // The ICP blockchain verifies msg.caller cryptographically — cannot be spoofed.
  // After this call, all write functions require architect or organism principal.
  public shared(msg) func claimArchitect() : async Text {
    assert(not genesisLocked);
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    genesisTimestamp   := Time.now();
    genesisBeat        := currentBeat;
    sovereignSeal      :=
      "NOVA:PARALLAX:MEDINA_TECH"
      # ":Alfredo_Medina_Hernandez:Dallas_TX_2026"
      # ":architect=" # Principal.toText(msg.caller)
      # ":genesis_beat=" # Nat.toText(currentBeat)
      # ":rSwarm_genesis=" # Float.toText(rSwarm)
      # ":doctrine=Kuramoto+JasminesLaw+OMNIS+SACESI+Hebbian"
      # ":ip_lock=SOVEREIGN_CANISTER_GENESIS"
      # ":blockchain=ICP_IMMUTABLE";
    sovereignSeal
  };

  // Register the organism canister so it can call tickFull() and directives.
  // Only the architect may call this.
  public shared(msg) func setTrustedOrganism(p : Principal) : async () {
    requireAuthorized(msg.caller);
    trustedOrganismPrincipal := p;
  };

  public query func getSovereignSeal()       : async Text      { sovereignSeal };
  public query func getArchitectPrincipal()  : async Principal { architectPrincipal };
  public query func isGenesisClaimed()       : async Bool      { genesisLocked };
  public query func getGenesisTimestamp()    : async Int       { genesisTimestamp };

};
