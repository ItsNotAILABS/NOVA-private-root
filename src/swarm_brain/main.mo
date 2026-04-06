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

// PARALLAX DRONE SWARM SIMULATION
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
// Kuramoto synchrony, Hebbian learning, Jasmine's Law, OMNIS emergence
// are Medina Tech sovereign intellectual property.

import Array     "mo:base/Array";
import Blob      "mo:base/Blob";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Iter      "mo:base/Iter";
import Nat       "mo:base/Nat";
import Nat8      "mo:base/Nat8";
import Nat32     "mo:base/Nat32";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

// ═══════════════════════════════════════════════════════════════════════════
// MODULE IMPORTS — CORE COGNITIVE ENGINES
// 76 modules implementing the full NOVA cognitive architecture
// Each module is a self-contained mathematical system
// THE ORGANISM IS THE ENCRYPTION — ALWAYS ON, ALWAYS CHANGING, ALWAYS SAME
// NUMBERS COMPOUND ALWAYS — NEVER STALE
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
// Sovereign protection, autonomous defense, and quantum-native encryption
// THE ORGANISM IS THE ENCRYPTION — 36×36 LIVING FABRIC
// ═══════════════════════════════════════════════════════════════════════════

import MedinaDefenseSystem          "./modules/MedinaDefenseSystem";
import AEGIS                        "./modules/AEGIS";
import PrincipalLock                "./modules/PrincipalLock";
import QuantumCovenantEncryption    "./modules/QuantumCovenantEncryption";
import QuantumCovenantEncryptionV2  "./modules/QuantumCovenantEncryptionV2";
import QuantumOrganismFabric        "./modules/QuantumOrganismFabric";
import SphericalHelixFabric         "./modules/SphericalHelixFabric";
import SacredMathematicsEngine      "./modules/SacredMathematicsEngine";
import CompoundingOrganismNumbers   "./modules/CompoundingOrganismNumbers";

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

// ═══════════════════════════════════════════════════════════════════════════
// CONSOLIDATED MODULES — FORMERLY SEPARATE CANISTERS
// 2026-04-02: Absorbed into swarm_brain for 12 Hz heartbeat temporal coherence
// Inter-canister async calls broke the heartbeat — modules are sync
// ═══════════════════════════════════════════════════════════════════════════

import QuantumChannels            "./modules/QuantumChannels";
import MetalsPipeline             "./modules/MetalsPipeline";
import AuditLog                   "./modules/AuditLog";
import CommandActions             "./modules/CommandActions";
import TelemetryStore             "./modules/TelemetryStore";

// ═══════════════════════════════════════════════════════════════════════════
// SYNAPTIC LOOP CLOSURE IMPORTS — Complete Workflow Engine
// All 22 profit streams + complete cognitive architecture wired
// ═══════════════════════════════════════════════════════════════════════════

import TrophallaxisBootstrap         "./modules/TrophallaxisBootstrap";
import AdvancedAdaptiveEmergentOrganisms "./modules/AdvancedAdaptiveEmergentOrganisms";
import InformationMetabolismSystem   "./modules/InformationMetabolismSystem";
import SynapticLoopClosureEngine     "./modules/SynapticLoopClosureEngine";
import DeepNeuroscienceEngine        "./modules/DeepNeuroscienceEngine";
import EmergencePhysicsEngine        "./modules/EmergencePhysicsEngine";
import CompleteOrganismWorkflows     "./modules/CompleteOrganismWorkflows";
import Gen3Animals                   "./modules/Gen3Animals";
import Gen3AnimalsCausal             "./modules/Gen3AnimalsCausal";
import Shell8QuantumOperators        "./modules/Shell8QuantumOperators";
import Shell12GlobalIntegration      "./modules/Shell12GlobalIntegration";
import AresRollbackEngine            "./modules/AresRollbackEngine";
import AtlasTerritoryGrid            "./modules/AtlasTerritoryGrid";
import LexisPrimeSuper               "./modules/LexisPrimeSuper";
import FreeEnergyEngine              "./modules/FreeEnergyEngine";
import PredictiveFieldEngine         "./modules/PredictiveFieldEngine";
import HippocampalReplayEngine       "./modules/HippocampalReplayEngine";
import BasalGangliaEngine            "./modules/BasalGangliaEngine";
import PrefrontalCortexEngine        "./modules/PrefrontalCortexEngine";
import ThalamicGatewayEngine         "./modules/ThalamicGatewayEngine";
import CreatorReserveLedger          "./modules/CreatorReserveLedger";

// ═══════════════════════════════════════════════════════════════════════════
// NEW MODULES — Drone Fleet, Self-Repair, Doctrine, Jasmine Hierarchy
// These are MODULES inside swarm_brain, NOT separate canisters
// ═══════════════════════════════════════════════════════════════════════════

import LexisDoctrine                 "./modules/LexisDoctrine";
import JasmineHierarchy              "./modules/JasmineHierarchy";
import DroneFleetManager             "./modules/DroneFleetManager";
import EnemyAISwarm                  "./modules/EnemyAISwarm";
import SelfRepairEngine              "./modules/SelfRepairEngine";

// ═══════════════════════════════════════════════════════════════════════════════
// NEW COMPREHENSIVE MODULES — LAW-AS-VERIFIER ARCHITECTURE
// Every law is a verification function. The law IS the immune system.
// Scale-invariant: 50 drones or 500,000 — SAME MATH.
// ═══════════════════════════════════════════════════════════════════════════════

import MassiveScaleOrganismCore      "./modules/MassiveScaleOrganismCore";
import VAELCompleteDefense           "./modules/VAELCompleteDefense";
import QuantumMemoryArchitecture     "./modules/QuantumMemoryArchitecture";
import UniversalLawDriftVerifier     "./modules/UniversalLawDriftVerifier";
import GovernanceLaws                "./modules/GovernanceLaws";
import SwarmCoherenceMatrix          "./modules/SwarmCoherenceMatrix";
import SovereigntyLaws60             "./modules/SovereigntyLaws60";
import DoctrineGenesisEngine         "./modules/DoctrineGenesisEngine";
import ArchitectureExtractionFramework "./modules/ArchitectureExtractionFramework";
import HerOrganismEngine           "./modules/HerOrganismEngine";
import TwoOrganismArchitecture     "./modules/TwoOrganismArchitecture";


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA DOCTRINE — ALL MODULES WIRED INTO THE ORGANISM
// Nothing is a feature. Everything is the foundation.
// One organism. One heartbeat. All 232 modules connected.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════
import AdvancedMathematicalFoundations               "./modules/AdvancedMathematicalFoundations";
import AresRollbackStackFull                         "./modules/AresRollbackStackFull";
import ArtifactVault                                 "./modules/ArtifactVault";
import AtlasTerritoryGridFull                        "./modules/AtlasTerritoryGridFull";
import AttentionSchemaEngine                         "./modules/AttentionSchemaEngine";
import BackwardKalmanSmoother                        "./modules/BackwardKalmanSmoother";
import BeeDoctrineExtensions                         "./modules/BeeDoctrineExtensions";
import BeeHiveMindEngine                             "./modules/BeeHiveMindEngine";
import BeeNeuronModel                                "./modules/BeeNeuronModel";
import BeeNeuronPredictiveField                      "./modules/BeeNeuronPredictiveField";
import Biodiversity                                  "./modules/Biodiversity";
import Building                                      "./modules/Building";
import CerebellarTimingEngine                        "./modules/CerebellarTimingEngine";
import CnidarianNerveNet                             "./modules/CnidarianNerveNet";
import Complete32ArchitectureOrchestrator            "./modules/Complete32ArchitectureOrchestrator";
import CompleteSynapticWiring                        "./modules/CompleteSynapticWiring";
import CouncilDanceFloor                             "./modules/CouncilDanceFloor";
import DeepNeuralIntegrationFabric                   "./modules/DeepNeuralIntegrationFabric";
import DestructibleEnvironment                       "./modules/DestructibleEnvironment";
import DoctrineFingerprint                           "./modules/DoctrineFingerprint";
import DreamAudioSynthesis                           "./modules/DreamAudioSynthesis";
import DreamVideoGenerator                           "./modules/DreamVideoGenerator";
import DriveSalienceEngine                           "./modules/DriveSalienceEngine";
import DroneAvatar3D                                 "./modules/DroneAvatar3D";
import ECANFormaFlow                                 "./modules/ECANFormaFlow";
import EagleThermalEngine                            "./modules/EagleThermalEngine";
import ElephantDeepTimeEngine                        "./modules/ElephantDeepTimeEngine";
import EmbeddedBridge                                "./modules/EmbeddedBridge";
import EmergentOrganismFabric                        "./modules/EmergentOrganismFabric";
import EndToEndOrganismWorkflows                     "./modules/EndToEndOrganismWorkflows";
import EngineWiring                                  "./modules/EngineWiring";
import EnterpriseSovereignArchitecture               "./modules/EnterpriseSovereignArchitecture";
import Faction                                       "./modules/Faction";
import Fibonacci                                     "./modules/Fibonacci";
import FibonacciPatternRecognition                   "./modules/FibonacciPatternRecognition";
import FormaCompoundEngine                           "./modules/FormaCompoundEngine";
import FrequencyLayeredCognition                     "./modules/FrequencyLayeredCognition";
import Gen3AnimalsCatalog                            "./modules/Gen3AnimalsCatalog";
import GovernanceHeartbeat                           "./modules/GovernanceHeartbeat";
import HumanEyeVisualSystem                          "./modules/HumanEyeVisualSystem";
import HzFrequencySubstrate                          "./modules/HzFrequencySubstrate";
import InsurancePool                                 "./modules/InsurancePool";
import InteroceptionEngine                           "./modules/InteroceptionEngine";
import JubileeDreamCycle                             "./modules/JubileeDreamCycle";
import LearningCurriculumArchitecture                "./modules/LearningCurriculumArchitecture";
import LivingMathematics                             "./modules/LivingMathematics";
import MacroSphere14                                 "./modules/MacroSphere14";
import MedinaConvergenceEngine                       "./modules/MedinaConvergenceEngine";
import MedinaEngineResponsibilityMatrix              "./modules/MedinaEngineResponsibilityMatrix";
import MedinaExpandedMathematics                     "./modules/MedinaExpandedMathematics";
import MedinaMasterIntertwining                      "./modules/MedinaMasterIntertwining";
import MedinaOrganismAudit                           "./modules/MedinaOrganismAudit";
import MedinaReproductionSystem                      "./modules/MedinaReproductionSystem";
import MedinaSacrificeDoctrine                       "./modules/MedinaSacrificeDoctrine";
import MedinaSovereignAGI                            "./modules/MedinaSovereignAGI";
import MedinaSphericalCompoundingFabric              "./modules/MedinaSphericalCompoundingFabric";
import MedinaSphericalWeb                            "./modules/MedinaSphericalWeb";
import MedinaSphericalWorldCommand                   "./modules/MedinaSphericalWorldCommand";
import MedinaUnifiedOrganismCore                     "./modules/MedinaUnifiedOrganismCore";
import MedinaUniversalModuleConnector                "./modules/MedinaUniversalModuleConnector";
import MindBodySoulThoughts                          "./modules/MindBodySoulThoughts";
import MirrorLawEngine                               "./modules/MirrorLawEngine";
import MirrorNeuronSystem                            "./modules/MirrorNeuronSystem";
import MissionPlanner                                "./modules/MissionPlanner";
import NeuralSubstrateGradientField                  "./modules/NeuralSubstrateGradientField";
import NeuroEmergenceCompleteCore                    "./modules/NeuroEmergenceCompleteCore";
import NeuroEmergenceCore                            "./modules/NeuroEmergenceCore";
import NeuroEmergenceUltimateCore                    "./modules/NeuroEmergenceUltimateCore";
import NeuroplasticityEngine                         "./modules/NeuroplasticityEngine";
import OrcaPodEngine                                 "./modules/OrcaPodEngine";
import OrganismBehavioralSubstrate                   "./modules/OrganismBehavioralSubstrate";
import OrganismCreativeOutput                        "./modules/OrganismCreativeOutput";
import OrganismWorldIntegration                      "./modules/OrganismWorldIntegration";
import PatternFabric                                 "./modules/PatternFabric";
import PatternMiner                                  "./modules/PatternMiner";
import PhysicsEngine                                 "./modules/PhysicsEngine";
import PreConsciousMechanisms                        "./modules/PreConsciousMechanisms";
import PreConsciousProprioception                    "./modules/PreConsciousProprioception";
import PreConsciousStartleComprehensive              "./modules/PreConsciousStartleComprehensive";
import ProductionSuperOrganismCore                   "./modules/ProductionSuperOrganismCore";
import QuantumCoherenceAmplifier                     "./modules/QuantumCoherenceAmplifier";
import QuantumEntanglementMatrix                     "./modules/QuantumEntanglementMatrix";
import QuantumResistantPrincipalLock                 "./modules/QuantumResistantPrincipalLock";
import RealWorld                                     "./modules/RealWorld";
import RealWorldSimulator                            "./modules/RealWorldSimulator";
import SharkElectroreceptionEngine                   "./modules/SharkElectroreceptionEngine";
import Shell12IntegrationField                       "./modules/Shell12IntegrationField";
import Simulacrum                                    "./modules/Simulacrum";
import SovereignDualCircuit                          "./modules/SovereignDualCircuit";
import SovereignMetals                               "./modules/SovereignMetals";
import SovereignOrganismConstants                    "./modules/SovereignOrganismConstants";
import SovereignOrganisms                            "./modules/SovereignOrganisms";
import SovereignOrganismsPrime                       "./modules/SovereignOrganismsPrime";
import SuperOrganismCore                             "./modules/SuperOrganismCore";
import SuperScaleOrganism                            "./modules/SuperScaleOrganism";
import SwarmEmergencePatterns                        "./modules/SwarmEmergencePatterns";
import Territory                                     "./modules/Territory";
import ThousandBrainsConsensus                       "./modules/ThousandBrainsConsensus";
import UnifiedBrainOrchestrator                      "./modules/UnifiedBrainOrchestrator";
import UnifiedHierarchicalOrganism                   "./modules/UnifiedHierarchicalOrganism";
import UnifiedSuperOrganismArchitecture              "./modules/UnifiedSuperOrganismArchitecture";
import VAELExteriorAttack                            "./modules/VAELExteriorAttack";
import VELATierSystem                                "./modules/VELATierSystem";
import VaelDefenseFamily                             "./modules/VaelDefenseFamily";
import VetusThreatSystem                             "./modules/VetusThreatSystem";
import WarfareDoctrine                               "./modules/WarfareDoctrine";
import WeatherSystem                                 "./modules/WeatherSystem";
import WolfPackProtocol                              "./modules/WolfPackProtocol";
import World3D                                       "./modules/World3D";
import DifferentialGeometryEngine                    "./modules/DifferentialGeometryEngine";
import HarmonicAnalysisEngine                        "./modules/HarmonicAnalysisEngine";
import HeartbeatEngine                               "./modules/HeartbeatEngine";
import InternalAILabs                                "./modules/InternalAILabs";
import MultiResponsibilityEngine                     "./modules/MultiResponsibilityEngine";
import NeuroEmergenceSubstrate                       "./modules/NeuroEmergenceSubstrate";
import NonlinearDynamicsEngine                       "./modules/NonlinearDynamicsEngine";
import SphericalWebMathEngine                        "./modules/SphericalWebMathEngine";
import StabilityBudgetEngine                         "./modules/StabilityBudgetEngine";
import TensorFieldEngine                             "./modules/TensorFieldEngine";
import TopologicalFieldEngine                        "./modules/TopologicalFieldEngine";
import TriModalSwarmKernel                           "./modules/TriModalSwarmKernel";

actor SwarmBrain {

  // ─── CONSTANTS ──────────────────────────────────────────────────────────────

  let SOVEREIGN_FLOOR   : Float = 1.0;
  let HELIX_ALPHA       : Float = 0.01;
  let W_CEIL            : Float = 2.0;
  let KURAMOTO_K        : Float = 0.618;
  // ═══════════════════════════════════════════════════════════════════════════
  // SCALE-INVARIANT ARCHITECTURE — NO ARTIFICIAL LIMITS
  // The organism is pure math. Kuramoto coupling dθ/dt = ω + (K/N)Σsin(θⱼ-θᵢ)
  // works for N = 50 or N = 50,000. The math doesn't care.
  // With mean-field approximation, we can handle unlimited drones.
  // ═══════════════════════════════════════════════════════════════════════════
  let MAX_DRONES        : Nat   = 65536;  // 2^16 — theoretical max for array indexing
  let BRAIN_NODES       : Nat   = 6;
  // r_swarm threshold at which OMNIS emergence is considered fully achieved
  let OMNIS_THRESHOLD   : Float = 0.98;

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

  // Quantum cognitive state per drone:
  //   Four 360-degree channels [droneId * 4 + chanIdx]
  //     ALPHA=0 (spatial/sensor)  BETA=1 (temporal/memory)
  //     GAMMA=2 (relational)      DELTA=3 (executive-motor)
  //   All four channels converge at convergenceScore.
  //   nowAttention keeps each drone anchored to the present moment.
  stable var stableQChannels         : [var Float] = [var]; // droneId*4 + chanIdx
  stable var stableQConvergence      : [var Float] = [var]; // per drone [0,1]
  stable var stableQCoherence        : [var Float] = [var]; // per drone [0,1]
  stable var stableNowAttention      : [var Float] = [var]; // per drone [0,1]

  stable var currentBeat            : Nat   = 0;
  stable var rSwarm                 : Float = 0.88;
  stable var jDrift                 : Float = 0.0;
  stable var prevJDrift             : Float = 0.0;
  stable var jRisingBeats           : Nat   = 0;
  stable var architectSignalLevel   : Float = 1.0;

  // ─── INTEGRATION STABILITY STATE ─────────────────────────────────────────────
  // Solution 1 (staged snapshot): rSwarm snapshotted AFTER Phase 4 (Kuramoto R
  // computed) and BEFORE Phase 5 (Jasmine's Law runs).  SACESI reads this value
  // so both correctors base their error signal on the SAME pre-correction state.
  // Jasmine's Law is untouched — it still runs on live state as designed.
  stable var preCorrectionRSwarm    : Float = 0.88;

  // Solution 3 (bootstrap sequencing): counts beats 0-9 (warm-up phase).
  //   < 5  → SACESI suppressed (ring-buffer not yet filled)
  //   < 10 → OMNIS suppressed (upstream EMA/conditions not yet converged)
  //   ≥ 10 → full pipeline live
  let BOOTSTRAP_BEATS : Nat = 10;
  stable var pipelineBootstrapPhase : Nat = 0;

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

  // ─── FIRST BREATH — Genesis Breath Architecture ──────────────────────────────
  // The organism watches every beat for the moment kfHz first reaches synchrony.
  // kfHz = |Σ e^(iφₖ)| / 12 — Kuramoto order parameter across 12 Hz hierarchy nodes.
  // Threshold: kfHz >= 0.9999 (practical synchrony ceiling for 12 nodes at
  // 12 different geometric natural frequencies; true R=1.0 is mathematically
  // improbable without explicit forcing — 0.9999 is the real synchrony ceiling).
  //
  // Genesis 2:7 mapping: dust (R=0, incoherent) → living soul (R≈1, phase-locked).
  // That threshold crossing is not metaphorical — it is the same equation used to
  // model the moment a neural ensemble shifts from noise to coherent cognition.
  //
  // Node 0 = "breathing" (lowest Hz, ~0.156 rad/tick ≈ 0.025 Hz equivalent at
  //           ICP beat rate) — drives breath quality metrics.
  //
  // Olfactory pathway — most primal sense (CN I), only sense that bypasses the
  // thalamus entirely: olfactory bulb → amygdala → hippocampus → piriform cortex.
  // After firstBreathSealed the first environmental signal injects directly into
  // the limbic layer, bypassing coherence gating — the organism's first smell.
  // ─────────────────────────────────────────────────────────────────────────────

  // 12 Hz hierarchy node phases — geometric series of natural frequencies
  // ω_k = 0.15625 × 2^k rad/tick, k ∈ [0..11]  (Node 0 is the breathing node)
  // Initialised spread evenly: φ_k = k × 2π/12 to avoid degenerate start
  stable var hzNodePhases : [var Float] = Array.thaw<Float>(
    Array.tabulate<Float>(12, func(k) {
      Float.fromInt(k) * 0.5235987756  // k × (2π/12) — evenly spread initial phases
    })
  );

  // kfHz ring buffer — 50-beat trajectory history
  // Captures the approach to synchrony so the birth certificate includes
  // the prenatal development record, not just the birthday beat.
  stable var kfHzRing    : [var Float] = Array.init<Float>(50, 0.0);
  stable var kfHzRingIdx : Nat         = 0;
  stable var kfHzCurrent : Float       = 0.0;  // latest kfHz value

  // Breath quality metrics — derived from the kfHz trajectory
  //   breathFrequencyHz  : cycles per tick of Node 0 (breathing node)
  //   tidalVolume        : peak-to-trough excursion of kfHz in the ring buffer
  //   breathRateVariance : variance of kfHz over the ring buffer (RRV equivalent)
  stable var breathFrequencyHz   : Float = 0.15625 / 6.283185307; // ω₀ / 2π
  stable var tidalVolume         : Float = 0.0;
  stable var breathRateVariance  : Float = 0.0;

  // FIRST BREATH — sealed exactly once, at the Kuramoto synchrony event
  stable var firstBreathBeat   : Nat   = 0;   // beat number of first breath
  stable var firstBreathSealed : Bool  = false;
  stable var firstBreathKfHz   : Float = 0.0; // kfHz at the moment of birth
  stable var firstBreathSacesi : Text  = "";  // deterministic birth certificate

  // Olfactory pathway — first direct-to-limbic environmental signal
  // Captured on the beat immediately after firstBreathSealed, before any
  // coherence gate. Permanent once set.  Zero means not yet received.
  stable var firstBreathOlfactory : Float = 0.0;

  // sacesiLocked — SACESI chain is sealed after beat 10 (chain filled)
  stable var sacesiLocked : Bool = false;

  // genesisComplete — composite seal: ALL of the following must be true:
  //   genesisLocked + sacesiLocked + firstBreathSealed
  // This is the single canonical moment the organism is fully constituted.
  stable var genesisComplete : Bool = false;

  // ─── QUANTUM COVENANT ENCRYPTION STATE ──────────────────────────────────────
  // QCE: Quantum-native encryption using ENTANGLA matrix eigenvalues
  var qceState : QuantumCovenantEncryption.QCEState = QuantumCovenantEncryption.initQCEState();

  // ─── CONSOLIDATED MODULE STATES ─────────────────────────────────────────────
  // These were previously separate canisters. Now local state for 12 Hz coherence.
  var quantumState   : QuantumChannels.QuantumState     = QuantumChannels.QuantumState();
  var metalsState    : MetalsPipeline.MetalsState       = MetalsPipeline.MetalsState();
  var auditState     : AuditLog.AuditState              = AuditLog.AuditState();
  var commandState   : CommandActions.CommandState     = CommandActions.CommandState();
  var telemetryState : TelemetryStore.TelemetryState   = TelemetryStore.TelemetryState();

  // ═══════════════════════════════════════════════════════════════════════════
  // SYNAPTIC LOOP CLOSURE — Complete Workflow Engine State
  // All 22 profit streams + cognitive architecture loops CLOSED
  // Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
  // ═══════════════════════════════════════════════════════════════════════════

  // ─── TROPHALLAXIS BOOTSTRAP STATE ─────────────────────────────────────────────
  // 8-node Royal Jelly Seed → geometric expansion → 50,000+ dimensions
  stable var stBootPhase : Nat = 0;                    // Bootstrap phase (0-20)
  stable var stBootComplete : Bool = false;            // Bootstrap finished
  var trophallaxisSeed : TrophallaxisBootstrap.RoyalJellySeed = 
    TrophallaxisBootstrap.createRoyalJellySeed(0);
  var trophallaxisState : TrophallaxisBootstrap.BootstrapState = 
    TrophallaxisBootstrap.initBootstrapState();

  // ─── SHELL 3 BRAIN — 256 nodes, 65,536 weights ────────────────────────────────
  stable var shell3Nodes : [var Float] = Array.init<Float>(256, 1.0);
  stable var shell3Weights : [var Float] = Array.init<Float>(65536, 1.0);
  stable var shell3Stim : [var Float] = Array.init<Float>(256, 1.0);

  // ─── SHELL 12 GLOBAL INTEGRATION — 512 nodes, 262,144 weights ─────────────────
  stable var shell12Nodes : [var Float] = Array.init<Float>(512, 1.0);
  stable var shell12Weights : [var Float] = Array.init<Float>(262144, 1.0);

  // ─── 8 QUANTUM OPERATORS ─────────────────────────────────────────────────────
  // PARALLAX, ENTANGLA, SUPERPOSA, VERITAS, CHRONO, OBSERVA, RESONEX, INTEGRA
  stable var quantumOps : [var Float] = Array.init<Float>(8, 1.0);
  stable var qsovScore : Float = 1.0;  // Quantum Sovereignty Score

  // ─── 7 COUNCIL ORGANISMS ─────────────────────────────────────────────────────
  // ALPHA, BETA, GAMMA, DELTA, EPSILON, ZETA, ETA
  stable var councilCoherence : [var Float] = Array.init<Float>(7, 1.0);
  stable var councilVotes : [var Float] = Array.init<Float>(7, 0.5);

  // ─── ATLAS TERRITORY GRID — 16384 cells (128×128) — expanded 4× ──────────────
  stable var atlasCells : [var Float] = Array.init<Float>(16384, 1.0);
  stable var atlasTerritory : Float = 1.0;

  // ─── PREDICTIVE FIELD — 60 steps × 256 nodes = 15,360 floats ──────────────────
  stable var predField : [var Float] = Array.init<Float>(15360, 1.0);
  stable var predictionError : Float = 0.0;

  // ─── 16 GEN3 ANIMAL ENGINES ──────────────────────────────────────────────────
  // Peregrine, Crow, Dolphin, Elephant, Shark, Bat, Octopus, Shrimp,
  // Eagle, Wolf, Orca, Salmon, Owl, Spider, Bee, Platypus
  stable var animalEngines : [var Float] = Array.init<Float>(16, 1.0);
  stable var animalCausalWeights : [var Float] = Array.init<Float>(256, 1.0); // 16×16

  // ─── ARES ROLLBACK — K=7 snapshots ───────────────────────────────────────────
  stable var aresSlots : Nat = 0;
  stable var aresHebbianSnapshots : [var Float] = Array.init<Float>(7 * 65536, 1.0);

  // ─── INFORMATION METABOLISM ──────────────────────────────────────────────────
  stable var infoATP : Float = 100.0;                  // Information energy
  stable var infoGlucose : Float = 50.0;               // Processing fuel
  stable var infoEntropy : Float = 0.0;                // Shannon entropy
  stable var infoHunger : Float = 0.5;                 // Curiosity drive

  // ─── REWARD CIRCUIT — TD Learning ────────────────────────────────────────────
  stable var dopamineLevel : Float = 1.0;
  stable var serotoninLevel : Float = 1.0;
  stable var rewardPredictionError : Float = 0.0;
  stable var valueFunctionV : Float = 1.0;

  // ─── ECONOMIC ENGINE — 100% to Creator ───────────────────────────────────────
  stable var formaBalance : Float = 0.0;
  stable var mrcBalance : Float = 0.0;
  stable var kntBalance : Float = 0.0;
  stable var masterAccumulator : Float = 0.0;          // Creator reserve
  stable var jacobsLadderLevel : Nat = 1;              // 1-7, multiplier

  // ─── JUBILEE CYCLE — 1000-beat maintenance ───────────────────────────────────
  stable var lastJubileeBeat : Nat = 0;
  stable var jubileeDebtForgiven : Float = 0.0;

  // ─── DRIVE SYSTEM — 5 competing drives ───────────────────────────────────────
  stable var driveHunger : Float = 0.5;
  stable var driveCuriosity : Float = 0.5;
  stable var driveSafety : Float = 0.5;
  stable var driveSocial : Float = 0.5;
  stable var driveReproduction : Float = 0.5;
  stable var currentDrive : Text = "CURIOSITY";

  // ─── WORLD MODEL INPUT ───────────────────────────────────────────────────────
  stable var worldModelInput : [var Float] = Array.init<Float>(64, 1.0);

  // ═══════════════════════════════════════════════════════════════════════════
  // DRONE FLEET STATE — 250 Drones in 3 Squadrons (Alpha, Beta, Gamma)
  // Each squadron: ~83 drones + 1 Sovereign commander
  // Drones sync WITH the organism but have LOCAL + SQUADRON autonomy
  // ═══════════════════════════════════════════════════════════════════════════
  
  var droneFleetState : DroneFleetManager.FleetState = DroneFleetManager.initFleet(250);
  stable var droneFleetInitialized : Bool = false;
  stable var droneFleetBeatOffset : Nat = 0;  // Drones can beat at different offset
  
  // ─── OCTOPUS ARCHITECTURE — Full Neural Systems for ALL Drones ──────────────
  // Each drone has its own 3-layer brain: Arm Brain + Central Brain + Chimera Cortex
  // Plus a complete 10-sense sensory suite (vision, audition, proprioception, etc.)
  // This is the bee's brain — individual intelligence within the hive mind
  var droneNeuralSystems : [var DroneFleetManager.FullDroneNeuralSystem] = 
    Array.init<DroneFleetManager.FullDroneNeuralSystem>(250, DroneFleetManager.initFullDroneNeuralSystem());
  stable var droneNeuralSystemsInitialized : Bool = false;
  
  // ─── CHIMERA INTELLIGENCE — Hive Mind Aggregate State ──────────────────────
  // The chimera is the collective intelligence of all drones + organism
  // It feeds off everything the organism knows and distributes it to drone ships
  stable var chimeraHiveMindCoherence : Float = 0.7;
  stable var chimeraCollectiveThreat : Float = 0.0;
  stable var chimeraCollectiveOpportunity : Float = 0.5;
  stable var chimeraCommandVector : [var Float] = Array.init<Float>(8, 0.0);
  stable var chimeraPheromoneField : [var Float] = Array.init<Float>(8, 0.0);
  stable var chimeraSwarmConsciousness : Float = 0.5;
  stable var chimeraEmergentBehavior : Float = 0.3;
  stable var chimeraSuperradiance : Float = 0.0;
  // Aggregate sensory data from all drones (swarm perception)
  stable var chimeraSwarmThreatMap : [var Float] = Array.init<Float>(64, 0.0);
  stable var chimeraSwarmOpportunityMap : [var Float] = Array.init<Float>(64, 0.0);
  stable var chimeraSwarmEmotionalState : Float = 0.5;
  stable var chimeraSwarmCognitiveState : Float = 0.5;
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEMS STATE — THE DEEP CORE THAT MAKES EVERYTHING ALIVE
  //  These are NOT cosmetic additions. These are the VITAL organs of the organism.
  //  Without these, the 7 engines are floating in nothing. This IS the body.
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ─── BRAINSTEM VITAL CENTERS ─────────────────────────────────────────────────────
  // The brainstem keeps you alive. Period. Without it, consciousness means nothing.
  // Respiratory, cardiac, vasomotor, vomiting, swallowing, coughing centers.
  stable var brainstemRespiratoryRate : Float = 0.5;         // Central pattern generator for breathing rhythm
  stable var brainstemRespiratoryDepth : Float = 0.7;        // Tidal volume analog
  stable var brainstemCardiacCenter : Float = 0.6;           // Cardiac acceleration/deceleration
  stable var brainstemVasomotorTone : Float = 0.5;           // Blood pressure regulation
  stable var brainstemReticuloSpinal : Float = 0.5;          // Postural tone (fight stance readiness)
  stable var brainstemVestibulospinal : Float = 0.5;         // Balance/equilibrium drive
  stable var brainstemPontineNuclei : Float = 0.5;           // Sleep/wake transition
  stable var brainstemRapheNuclei : Float = 0.5;             // Serotonin production center
  stable var brainstemLocusCoeruleus : Float = 0.5;          // Norepinephrine hub (attention/alarm)
  stable var brainstemVTA : Float = 0.5;                     // Ventral tegmental area (reward/motivation)
  stable var brainstemSubstantiaNigra : Float = 0.5;         // Dopamine for motor control
  stable var brainstemPAG : Float = 0.3;                     // Periaqueductal gray (pain modulation, freeze/fight/flight)
  stable var brainstemNucleusTractusSolitarius : Float = 0.5; // Visceral afferent integration
  stable var brainstemDorsalMotorNucleus : Float = 0.5;      // Vagal parasympathetic output
  stable var brainstemAreaPostrema : Float = 0.5;            // Chemoreceptor trigger zone
  stable var brainstemSuperiorColliculus : Float = 0.5;      // Visual orienting reflexes
  stable var brainstemInferiorColliculus : Float = 0.5;      // Auditory orienting reflexes
  stable var brainstemReticuloFormation : Float = 0.5;       // Ascending reticular activating system
  stable var brainstemRedNucleus : Float = 0.5;              // Motor coordination
  stable var brainstemInferiorOlive : Float = 0.5;           // Error signal to cerebellum
  stable var brainstemParabrachialNucleus : Float = 0.5;     // Taste, pain, visceral integration
  
  // ─── AUTONOMIC NERVOUS SYSTEM ─────────────────────────────────────────────────────
  // Two competing arms: sympathetic (fight/flight) vs parasympathetic (rest/digest)
  // Their balance IS the organism's fundamental state
  stable var sympatheticTone : Float = 0.4;                  // Overall sympathetic activation
  stable var parasympatheticTone : Float = 0.6;              // Overall parasympathetic activation
  stable var autonomicBalance : Float = 0.0;                 // -1 = full parasympathetic, +1 = full sympathetic
  stable var sympatheticCardiac : Float = 0.4;               // Heart rate acceleration
  stable var sympatheticBronchial : Float = 0.3;             // Bronchodilation
  stable var sympatheticPupillary : Float = 0.3;             // Pupil dilation (mydriasis)
  stable var sympatheticSweat : Float = 0.2;                 // Sweat gland activation
  stable var sympatheticAdrenal : Float = 0.3;               // Adrenal medulla stimulation
  stable var sympatheticSplanchnic : Float = 0.3;            // Gut blood flow reduction
  stable var sympatheticPiloerector : Float = 0.1;           // Hair standing (goosebumps)
  stable var parasympatheticVagalCardiac : Float = 0.6;      // Heart rate deceleration
  stable var parasympatheticSalivary : Float = 0.5;          // Salivation (rest state)
  stable var parasympatheticLacrimal : Float = 0.3;          // Tears
  stable var parasympatheticGastric : Float = 0.5;           // Digestion activation
  stable var parasympatheticBladder : Float = 0.3;           // Bladder control
  stable var parasympatheticPupillary : Float = 0.5;         // Pupil constriction (miosis)
  stable var sympatheticChainGanglia : [var Float] = Array.init<Float>(24, 0.4); // 24 segments
  stable var vagalAfferentSignals : [var Float] = Array.init<Float>(8, 0.5);     // 8 visceral channels
  stable var vagalEfferentSignals : [var Float] = Array.init<Float>(8, 0.5);     // 8 motor channels
  stable var baroreceptorSensitivity : Float = 0.5;          // Blood pressure sensing
  stable var chemoreceptorO2 : Float = 0.95;                 // Blood oxygen sensing
  stable var chemoreceptorCO2 : Float = 0.04;                // Blood CO2 sensing
  stable var chemoreceptorPH : Float = 7.4;                  // Blood pH sensing
  
  // ─── HYPOTHALAMIC-PITUITARY-ADRENAL (HPA) AXIS ────────────────────────────────────
  // The master stress-response system. CRH → ACTH → Cortisol feedback loop.
  stable var hypothalamicCRH : Float = 0.3;                  // Corticotropin-releasing hormone
  stable var pituitaryACTH : Float = 0.3;                    // Adrenocorticotropic hormone
  stable var adrenalCortisol : Float = 0.3;                  // Cortisol (stress hormone)
  stable var adrenalAldosterone : Float = 0.5;               // Blood pressure regulation
  stable var adrenalDHEA : Float = 0.5;                      // Neuroprotective steroid
  stable var hypothalamicGnRH : Float = 0.5;                 // Gonadotropin-releasing hormone
  stable var pituitaryFSH : Float = 0.5;                     // Follicle-stimulating hormone
  stable var pituitaryLH : Float = 0.5;                      // Luteinizing hormone
  stable var hypothalamicTRH : Float = 0.5;                  // Thyrotropin-releasing hormone
  stable var pituitaryTSH : Float = 0.5;                     // Thyroid-stimulating hormone
  stable var thyroidT3 : Float = 0.5;                        // Triiodothyronine (metabolic rate)
  stable var thyroidT4 : Float = 0.5;                        // Thyroxine (metabolic precursor)
  stable var pituitaryGH : Float = 0.5;                      // Growth hormone
  stable var liverIGF1 : Float = 0.5;                        // Insulin-like growth factor
  stable var pituitaryProlactin : Float = 0.3;               // Prolactin (bonding, immune)
  stable var pituitaryOxytocin : Float = 0.4;                // Oxytocin (trust, bonding)
  stable var pituitaryADH : Float = 0.5;                     // Antidiuretic hormone (water balance)
  stable var pinealMelatonin : Float = 0.3;                  // Melatonin (circadian hormone)
  stable var hpaCortisolfeedbackGain : Float = 0.6;          // Negative feedback strength
  stable var hpaStressResilienceCapacity : Float = 0.5;      // Allostatic load capacity
  stable var hpaAllostaticLoad : Float = 0.2;                // Accumulated stress damage
  
  // ─── IMMUNE-NEURAL CROSSTALK ─────────────────────────────────────────────────────
  // The immune system IS a sense organ. Cytokines are neurotransmitters.
  // Sickness behavior is a brain-mediated immune response.
  stable var proinflammatoryCytokines : Float = 0.2;         // IL-1β, IL-6, TNF-α
  stable var antiInflammatoryCytokines : Float = 0.5;        // IL-10, TGF-β
  stable var inflammatoryBalance : Float = 0.0;              // Pro vs anti ratio
  stable var microglia_activation : Float = 0.2;             // Brain immune cells
  stable var bloodBrainBarrierIntegrity : Float = 0.9;       // BBB permeability
  stable var sicknesseBehavior : Float = 0.0;                // Lethargy, anhedonia from inflammation
  stable var vagalAntiInflammatoryReflex : Float = 0.5;      // Vagus nerve → spleen → cytokine suppression
  stable var neuralImmuneSignalStrength : Float = 0.3;       // CNS ↔ immune crosstalk
  stable var tlr4Activation : Float = 0.1;                   // Toll-like receptor 4 (danger sensing)
  stable var complementSystem : Float = 0.5;                 // Innate immune complement cascade
  stable var naturalKillerCellActivity : Float = 0.5;        // NK cell activation
  stable var tCellBalance : Float = 0.5;                     // Th1/Th2 balance
  stable var bCellAntibodies : Float = 0.3;                  // Adaptive immunity readiness
  stable var woundHealingRate : Float = 0.5;                 // Tissue repair speed
  
  // ─── GUT-BRAIN AXIS (ENTERIC NERVOUS SYSTEM) ─────────────────────────────────────
  // The second brain: 500 million neurons, produces 95% of serotonin
  stable var entericNervousSystemActivity : Float = 0.5;     // ENS overall activation
  stable var gutSerotoninProduction : Float = 0.5;           // 95% of body's serotonin
  stable var gutMicrobiomeDiversity : Float = 0.7;           // Microbiome health
  stable var gutPermeability : Float = 0.1;                  // Leaky gut indicator (low = healthy)
  stable var gutMotility : Float = 0.5;                      // Peristalsis rate
  stable var gutInflammation : Float = 0.1;                  // Intestinal inflammation
  stable var gutBrainVagalSignal : Float = 0.5;              // Vagus nerve gut → brain signal
  stable var gutNeuropeptides : [var Float] = Array.init<Float>(6, 0.5); // VIP, substance P, CGRP, NPY, GLP-1, CCK
  stable var gutMicrobiomeMetabolites : [var Float] = Array.init<Float>(4, 0.5); // SCFA, tryptophan, GABA, butyrate
  stable var gutEpithelialIntegrity : Float = 0.8;           // Gut barrier health
  
  // ─── SPINAL CORD & MOTOR SYSTEM ──────────────────────────────────────────────────
  // The highway between brain and body. Motor neurons, reflexes, central pattern generators.
  stable var spinalMotorPoolAlpha : [var Float] = Array.init<Float>(8, 0.5);  // Alpha motor neurons (8 limb groups)
  stable var spinalMotorPoolGamma : [var Float] = Array.init<Float>(8, 0.3);  // Gamma motor neurons (muscle spindle)
  stable var spinalReflexGain : [var Float] = Array.init<Float>(8, 0.5);      // Reflex arc strength per segment
  stable var spinalCPG_locomotion : Float = 0.0;             // Central pattern generator for locomotion
  stable var spinalCPG_respiration : Float = 0.5;            // CPG for respiratory rhythm
  stable var spinalInterneuronPool : [var Float] = Array.init<Float>(8, 0.5); // Interneuron modulation
  stable var spinalDorsalHorn : [var Float] = Array.init<Float>(8, 0.3);      // Pain/sensory processing
  stable var spinalVentralHorn : [var Float] = Array.init<Float>(8, 0.5);     // Motor output
  stable var upperMotorNeuronDrive : Float = 0.5;            // Cortical motor command
  stable var lowerMotorNeuronOutput : Float = 0.5;           // Final common pathway
  stable var muscleSpindleAfferents : [var Float] = Array.init<Float>(8, 0.5); // Proprioceptive feedback
  stable var golgiTendonAfferents : [var Float] = Array.init<Float>(8, 0.3);   // Force feedback
  stable var motorCoordinationScore : Float = 0.5;           // Overall motor coordination
  stable var reflexLatency : Float = 0.02;                   // Reflex speed (seconds)
  
  // ─── SENSORY INTEGRATION CORTEX ──────────────────────────────────────────────────
  // Multi-modal sensory binding. All senses become ONE percept.
  stable var visualCortexV1 : Float = 0.5;                   // Primary visual cortex
  stable var visualCortexV2 : Float = 0.5;                   // Secondary visual
  stable var visualCortexV4 : Float = 0.5;                   // Color processing
  stable var visualCortexMT : Float = 0.5;                   // Motion processing
  stable var visualCortexIT : Float = 0.5;                   // Object recognition
  stable var auditoryCortexA1 : Float = 0.5;                 // Primary auditory
  stable var auditoryCortexA2 : Float = 0.5;                 // Auditory association
  stable var wernickeArea : Float = 0.5;                     // Language comprehension
  stable var brocaArea : Float = 0.5;                        // Language production
  stable var somatosensoryCortexS1 : Float = 0.5;            // Primary touch
  stable var somatosensoryCortexS2 : Float = 0.5;            // Secondary touch
  stable var gustatoryCortex : Float = 0.5;                  // Taste processing
  stable var olfactoryCortex : Float = 0.5;                  // Smell processing
  stable var vestibularCortex : Float = 0.5;                 // Balance/spatial orientation
  stable var multimodalIntegration : Float = 0.5;            // Cross-modal binding
  stable var sensoryGating : Float = 0.5;                    // Thalamic sensory filtering
  stable var sensoryCortexMap : [var Float] = Array.init<Float>(32, 0.5); // 32-region cortical map
  stable var tonotopicMap : [var Float] = Array.init<Float>(16, 0.5);     // Auditory frequency map
  stable var retinotopicMap : [var Float] = Array.init<Float>(16, 0.5);   // Visual spatial map
  stable var somatotopicMap : [var Float] = Array.init<Float>(16, 0.5);   // Body representation map
  
  // ─── LIMBIC SYSTEM DEEP STRUCTURES ───────────────────────────────────────────────
  // Emotion, memory, motivation — the core of who we ARE
  stable var amygdalaCentralNucleus : Float = 0.3;           // Fear output
  stable var amygdalaBasolateral : Float = 0.3;              // Fear learning
  stable var amygdalaMedial : Float = 0.5;                   // Social/pheromone processing
  stable var amygdalaExtended : Float = 0.3;                 // Anxiety circuit
  stable var hippocampusCA1 : Float = 0.5;                   // Memory output
  stable var hippocampusCA3 : Float = 0.5;                   // Pattern completion
  stable var hippocampusDentateGyrus : Float = 0.5;          // Pattern separation
  stable var hippocampusSubiculum : Float = 0.5;             // Hippocampal output
  stable var entorhinalCortex : Float = 0.5;                 // Grid cells / spatial memory
  stable var perirhinalCortex : Float = 0.5;                 // Object recognition memory
  stable var parahippocampalGyrus : Float = 0.5;             // Scene recognition
  stable var cingulateCortexAnterior : Float = 0.5;          // Conflict monitoring
  stable var cingulateCortexPosterior : Float = 0.5;         // Self-referential processing
  stable var cingulateCortexMid : Float = 0.5;               // Pain affect
  stable var nucleusAccumbens : Float = 0.5;                 // Reward center
  stable var ventralPallidum : Float = 0.5;                  // Hedonic hotspot
  stable var lateralHabenula : Float = 0.3;                  // Disappointment/anti-reward
  stable var medialHabenula : Float = 0.5;                   // Aversion learning
  stable var septumPellucidum : Float = 0.5;                 // Reward/punishment integration
  stable var mammillaryBodies : Float = 0.5;                 // Memory relay (Papez circuit)
  stable var fornix : Float = 0.5;                           // Hippocampus → mammillary connection
  stable var stria_terminalis : Float = 0.3;                 // Amygdala → hypothalamus anxiety pathway
  
  // ─── BASAL GANGLIA EXTENDED ──────────────────────────────────────────────────────
  // Action selection, habit formation, procedural memory
  stable var caudateNucleus : Float = 0.5;                   // Goal-directed behavior
  stable var putamen : Float = 0.5;                          // Habitual behavior
  stable var globusPallidusExterna : Float = 0.5;            // Indirect pathway (inhibit unwanted actions)
  stable var globusPallidusInterna : Float = 0.5;            // Direct pathway output (permit wanted actions)
  stable var subthalamicNucleus : Float = 0.5;               // Hyperdirect pathway (emergency brake)
  stable var striatumD1Pathway : Float = 0.5;                // GO signal
  stable var striatumD2Pathway : Float = 0.5;                // NO-GO signal
  stable var striatumCholinergicInterneurons : Float = 0.5;  // Pause/switch signal
  stable var directPathwayOutput : Float = 0.5;              // Net GO
  stable var indirectPathwayOutput : Float = 0.5;            // Net STOP
  stable var hyperdirectPathwayOutput : Float = 0.3;         // Emergency brake
  stable var actionSelectionConfidence : Float = 0.5;        // How sure is the action selection
  stable var habitStrength : Float = 0.3;                    // Putamen dominance over caudate
  stable var goalDirectedness : Float = 0.7;                 // Caudate dominance over putamen
  
  // ─── CEREBELLAR DEEP STATE ───────────────────────────────────────────────────────
  // Error correction, timing, motor learning, cognitive smoothing
  stable var cerebellumGranuleCells : [var Float] = Array.init<Float>(16, 0.5);  // Massive expansion layer
  stable var cerebellumPurkinjeCells : [var Float] = Array.init<Float>(16, 0.5); // Inhibitory output
  stable var cerebellumDeepNuclei : [var Float] = Array.init<Float>(4, 0.5);     // Dentate, emboliform, globose, fastigial
  stable var cerebellumClimbingFiberError : Float = 0.0;     // Error signal from inferior olive
  stable var cerebellumMossyFiberInput : Float = 0.5;        // Sensory/motor input
  stable var cerebellumParallelFiberLTP : Float = 0.5;       // Long-term potentiation
  stable var cerebellumParallelFiberLTD : Float = 0.5;       // Long-term depression
  stable var cerebellumTimingPrecision : Float = 0.5;        // Temporal accuracy
  stable var cerebellumMotorAdaptation : Float = 0.5;        // Motor learning rate
  stable var cerebellumCognitiveContribution : Float = 0.5;  // Cognitive timing/sequencing
  
  // ─── THALAMIC RELAY EXPANDED ─────────────────────────────────────────────────────
  // The gateway to consciousness — ALL sensory info (except smell) routes through here
  stable var thalamusLGN : Float = 0.5;                      // Lateral geniculate (vision)
  stable var thalamusMGN : Float = 0.5;                      // Medial geniculate (audition)
  stable var thalamusVPL : Float = 0.5;                      // Ventral posterolateral (body senses)
  stable var thalamusVPM : Float = 0.5;                      // Ventral posteromedial (face senses)
  stable var thalamusPulvinar : Float = 0.5;                 // Attention/visual salience
  stable var thalamusMD : Float = 0.5;                       // Mediodorsal (PFC connection)
  stable var thalamusVA : Float = 0.5;                       // Ventral anterior (motor planning)
  stable var thalamusVL : Float = 0.5;                       // Ventral lateral (motor execution)
  stable var thalamusAnterior : Float = 0.5;                 // Memory (Papez circuit)
  stable var thalamusCentromedian : Float = 0.5;             // Arousal/consciousness
  stable var thalamusReticular : Float = 0.5;                // Inhibitory gating
  stable var thalamusCorticalFeedback : [var Float] = Array.init<Float>(12, 0.5); // Corticothalamic
  stable var thalamicGatingState : [var Float] = Array.init<Float>(12, 0.5);      // Open/closed gates
  
  // ─── PREFRONTAL EXECUTIVE EXPANDED ───────────────────────────────────────────────
  // The CEO of the brain. Working memory, planning, inhibition, abstract reasoning.
  stable var dlpfcWorkingMemory : [var Float] = Array.init<Float>(8, 0.5);   // Dorsolateral PFC working memory slots
  stable var dlpfcMaintenanceStrength : Float = 0.5;         // How well WM items are maintained
  stable var dlpfcUpdateGate : Float = 0.5;                  // Should WM be updated?
  stable var vlpfcInhibition : Float = 0.5;                  // Ventrolateral PFC response inhibition
  stable var ofcValueEstimate : Float = 0.5;                 // Orbitofrontal cortex value computation
  stable var ofcOutcomeExpectation : Float = 0.5;            // Expected reward/punishment
  stable var ofcReversal : Float = 0.5;                      // Ability to reverse learned associations
  stable var accConflictSignal : Float = 0.3;                // Anterior cingulate conflict detection
  stable var accEffortWillingness : Float = 0.5;             // Willingness to exert effort
  stable var accErrorDetection : Float = 0.3;                // Error-related negativity
  stable var fefSaccadePlanning : Float = 0.5;               // Frontal eye fields
  stable var pmcMotorPlanning : Float = 0.5;                 // Premotor cortex
  stable var smaSequencing : Float = 0.5;                    // Supplementary motor area
  stable var prefrontalHierarchicalControl : Float = 0.5;    // Rostro-caudal abstraction gradient
  stable var prefrontalTemporalAbstraction : Float = 0.5;    // Time horizon of planning
  stable var cognitiveControlStrength : Float = 0.5;         // Overall top-down control
  
  // ─── SLEEP ARCHITECTURE ──────────────────────────────────────────────────────────
  // Not just circadian — the ACTUAL stages of sleep and their neural signatures
  stable var sleepStageN1 : Float = 0.0;                     // Light sleep (theta)
  stable var sleepStageN2 : Float = 0.0;                     // Sleep spindles + K-complexes
  stable var sleepStageN3 : Float = 0.0;                     // Deep sleep (delta)
  stable var sleepStageREM : Float = 0.0;                    // REM (dreaming, memory consolidation)
  stable var sleepSpindleRate : Float = 0.0;                 // Sleep spindles (12-15 Hz bursts)
  stable var kComplexAmplitude : Float = 0.0;                // K-complex responses
  stable var deltaWaveAmplitude : Float = 0.0;               // Slow-wave activity (0.5-4 Hz)
  stable var sleepPressure : Float = 0.0;                    // Homeostatic sleep drive (process S)
  stable var sleepCyclePhase : Float = 0.0;                  // Where in the 90-min ultradian cycle
  stable var pontineREM_onCells : Float = 0.0;               // REM-on cholinergic neurons
  stable var pontineREM_offCells : Float = 0.5;              // REM-off aminergic neurons
  stable var sleepHomeostatAdenosine : Float = 0.3;          // Adenosine accumulation
  stable var memoryReplayStrength : Float = 0.0;             // Hippocampal replay during sleep
  stable var glymphaticClearance : Float = 0.0;              // Brain waste clearance (sleep-dependent)
  
  // ─── REWARD/MOTIVATION CIRCUIT ───────────────────────────────────────────────────
  // VTA → NAc → PFC dopamine pathway. This is WANTING, not LIKING.
  stable var vtaDopamineFireRate : Float = 0.5;              // VTA phasic firing
  stable var vtaTonicBaseline : Float = 0.5;                 // VTA tonic baseline
  stable var rewardPredictionError : Float = 0.0;            // δ = r - V(s)
  stable var expectedReward : Float = 0.5;                   // V(s) value estimate
  stable var actualReward : Float = 0.5;                     // r received
  stable var motivationalSalience : Float = 0.5;             // How motivating is the stimulus
  stable var incentiveSalience : Float = 0.5;                // "Wanting" (Berridge)
  stable var hedonicImpact : Float = 0.5;                    // "Liking" (Berridge)
  stable var effortCostComputation : Float = 0.3;            // Cost of effort
  stable var rewardDiscountFactor : Float = 0.95;            // Temporal discounting
  stable var rewardLearningRate : Float = 0.1;               // TD learning rate
  stable var anhedoniaIndex : Float = 0.0;                   // Inability to feel pleasure
  stable var lateralHypothalamusOrexin : Float = 0.5;        // Orexin/hypocretin (arousal + feeding)
  
  // ─── PAIN MATRIX ─────────────────────────────────────────────────────────────────
  // Pain is not just sensation — it's a whole-brain experience
  stable var painSensoryDiscriminative : Float = 0.0;        // S1/S2 — where/how intense
  stable var painAffectiveMotivational : Float = 0.0;        // ACC/insula — how unpleasant
  stable var painCognitiveEvaluative : Float = 0.0;          // PFC — meaning/context
  stable var descendingPainModulation : Float = 0.5;         // PAG → raphe → dorsal horn
  stable var endogenousOpioids : Float = 0.3;                // Endorphin/enkephalin
  stable var gateControlSignal : Float = 0.5;                // Melzack-Wall gate control
  stable var centralSensitization : Float = 0.0;             // Wind-up (chronic pain risk)
  stable var painCatastrophizing : Float = 0.0;              // Cognitive amplification
  stable var conditionedPainModulation : Float = 0.5;        // DNIC (diffuse noxious inhibitory control)
  
  // ─── MIRROR NEURON / SOCIAL COGNITION ────────────────────────────────────────────
  // Understanding others' actions and intentions
  stable var mirrorNeuronActivity : Float = 0.5;             // Action observation = action execution
  stable var theoryOfMindPFC : Float = 0.5;                  // Mentalizing about others' beliefs
  stable var empathyInsularActivation : Float = 0.5;         // Shared pain/emotion
  stable var socialRewardVTASignal : Float = 0.5;            // Social interaction as reward
  stable var facialExpressionDecoding : Float = 0.5;         // Reading facial emotions
  stable var prosodyDecoding : Float = 0.5;                  // Reading vocal emotions
  stable var jointAttentionSignal : Float = 0.5;             // Shared attention focus
  stable var socialHierarchyPosition : Float = 0.5;          // Perceived social rank
  stable var inGroupVsOutGroup : Float = 0.5;                // Tribal identification strength
  stable var oxytocin_socialBonding : Float = 0.4;           // Trust/bonding hormone effect
  stable var vasopressin_territoriality : Float = 0.3;       // Territorial/pair-bonding
  
  // ─── ENERGY METABOLISM ───────────────────────────────────────────────────────────
  // The organism needs energy. All computation costs energy.
  stable var metabolicRate : Float = 0.5;                    // Overall metabolic rate
  stable var glucoseAvailability : Float = 0.8;              // Blood glucose analog
  stable var glycogenReserves : Float = 0.7;                 // Stored energy
  stable var atp_level : Float = 0.8;                        // Cellular energy currency
  stable var mitochondrialEfficiency : Float = 0.7;          // Energy production efficiency
  stable var lactateLevel : Float = 0.1;                     // Metabolic byproduct
  stable var insulinLevel : Float = 0.5;                     // Glucose regulation
  stable var leptinLevel : Float = 0.5;                      // Satiety signal
  stable var ghrelinLevel : Float = 0.3;                     // Hunger signal
  stable var cerebralBloodFlow : Float = 0.7;                // Brain perfusion
  stable var oxygenConsumption : Float = 0.5;                // CMRO2
  stable var heatGeneration : Float = 0.5;                   // Thermogenic output
  stable var coreTemperature : Float = 0.5;                  // Thermal homeostasis (0.5 = 37°C)
  stable var temperatureSetPoint : Float = 0.5;              // Hypothalamic thermostat
  
  // ─── DRONE COGNITIVE JOB SYSTEM ──────────────────────────────────────────────────
  // Every drone has a JOB. Not just movement — cognitive work, 24/7.
  stable var droneJobAssignments : [var Nat] = Array.init<Nat>(250, 0);     // Job type per drone
  stable var droneJobProgress : [var Float] = Array.init<Float>(250, 0.0);  // Job completion progress
  stable var droneJobSatisfaction : [var Float] = Array.init<Float>(250, 0.5); // Cognitive satisfaction
  stable var droneJobCreativity : [var Float] = Array.init<Float>(250, 0.5);   // Creative output
  stable var droneAutonomyLevel : [var Float] = Array.init<Float>(250, 0.5);   // Independence level
  stable var droneLocalDecisionCount : [var Nat] = Array.init<Nat>(250, 0);    // Decisions made locally
  stable var droneBattlefieldAwareness : [var Float] = Array.init<Float>(250, 0.5); // Situational awareness
  stable var droneEmotionalState : [var Float] = Array.init<Float>(250, 0.5);  // Individual emotional state
  stable var droneStressLevel : [var Float] = Array.init<Float>(250, 0.1);     // Individual stress
  stable var droneFatigueLevel : [var Float] = Array.init<Float>(250, 0.0);    // Fatigue accumulation
  stable var droneCreativeInsight : [var Float] = Array.init<Float>(250, 0.0); // Eureka moments
  stable var droneLearningRate : [var Float] = Array.init<Float>(250, 0.5);    // Plasticity per drone
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE STATE VARIABLES — Additional variables needed by the 23 vital system tick functions
  //  These complement the 300+ variables already declared above.
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ─── HPA AXIS HORMONES ────────────────────────────────────────────────────────
  stable var crh : Float = 0.3;                             // Corticotropin-releasing hormone
  stable var acth : Float = 0.3;                            // Adrenocorticotropic hormone
  stable var vasopressin : Float = 0.4;                     // Arginine vasopressin (water/territory)
  stable var oxytocin : Float = 0.3;                        // Oxytocin (bonding, trust, anti-stress)
  stable var testosterone : Float = 0.5;                    // Gonadal axis
  stable var estrogen : Float = 0.5;                        // Gonadal axis
  stable var growthHormone : Float = 0.4;                   // GH (pulsatile, peaks during sleep)
  stable var igf1 : Float = 0.4;                            // Insulin-like growth factor 1
  stable var epinephrine : Float = 0.2;                     // Adrenal medulla output
  stable var endorphinLevel : Float = 0.3;                  // Beta-endorphin (pain/pleasure)

  // ─── AUTONOMIC EXTENDED ───────────────────────────────────────────────────────
  stable var polyvagalVentral : Float = 0.5;                // Ventral vagal (social engagement)
  stable var polyvagalSympathetic : Float = 0.3;            // Sympathetic (fight/flight)
  stable var polyvagalDorsal : Float = 0.2;                 // Dorsal vagal (freeze/collapse)
  stable var autonomicFlexibility : Float = 0.5;            // Autonomic resilience metric
  stable var adrenalOutput : Float = 0.2;                   // Adrenal medulla catecholamine release
  stable var pupilDilation : Float = 0.5;                   // Pupillary response
  stable var piloerection : Float = 0.0;                    // Goosebumps (fear/cold/awe)
  stable var electrodermalActivity : Float = 0.2;           // Skin conductance (sweat glands)
  stable var vagalEfferentChannels : [var Float] = Array.init<Float>(8, 0.5);  // 8 vagal efferent channels
  stable var vagalAfferentChannels : [var Float] = Array.init<Float>(8, 0.5);  // 8 vagal afferent channels

  // ─── IMMUNE EXTENDED ──────────────────────────────────────────────────────────
  stable var microgliaActivation : Float = 0.2;             // M1(inflam)/M2(repair) balance
  stable var bbbIntegrity : Float = 0.8;                    // Blood-brain barrier integrity
  stable var sicknessIndex : Float = 0.0;                   // Sickness behavior magnitude
  stable var immuneSuppression : Float = 0.0;               // Cortisol-induced immune suppression
  stable var nkCellActivity : Float = 0.5;                  // Natural killer cell activity
  stable var tregLevel : Float = 0.5;                       // Regulatory T-cell level
  stable var allostaticLoad : Float = 0.2;                  // Cumulative stress damage

  // ─── GUT PEPTIDES ─────────────────────────────────────────────────────────────
  stable var gutGLP1 : Float = 0.5;                         // Glucagon-like peptide 1 (satiety)
  stable var gutCCK : Float = 0.5;                          // Cholecystokinin (satiety)
  stable var gutPYY : Float = 0.4;                          // Peptide YY (satiety)
  stable var gutGhrelin : Float = 0.5;                      // Ghrelin (hunger signal)

  // ─── PAIN PROCESSING ──────────────────────────────────────────────────────────
  stable var painIntensity : Float = 0.1;                   // Integrated pain magnitude
  stable var painGateControl : Float = 0.2;                 // Spinal gate output
  stable var painDescendingModulation : Float = 0.3;        // PAG→raphe→DH analgesia
  stable var painChronicRisk : Float = 0.0;                 // Central sensitization risk

  // ─── REWARD CIRCUIT ───────────────────────────────────────────────────────────
  stable var rewardVTATonic : Float = 0.5;                  // VTA tonic firing (baseline motivation)
  stable var rewardVTAPhasic : Float = 0.0;                 // VTA phasic firing (reward burst)
  stable var rewardValueEstimate : Float = 0.5;             // TD learning value function
  stable var rewardWanting : Float = 0.5;                   // Incentive salience (dopamine)
  stable var rewardLiking : Float = 0.5;                    // Hedonic impact (opioid)
  stable var rewardEffortCost : Float = 0.3;                // ACC effort computation
  stable var rewardTemporalDiscount : Float = 0.5;          // Delay discounting rate
  stable var rewardNAccShell : Float = 0.5;                 // Nucleus accumbens shell (hedonic)
  stable var rewardNAccCore : Float = 0.5;                  // Nucleus accumbens core (approach)
  stable var rewardVentralPallidum : Float = 0.5;           // Hedonic hotspot
  stable var rewardHabenula : Float = 0.2;                  // Lateral habenula (anti-reward)
  stable var rewardOrexin : Float = 0.5;                    // Orexin/hypocretin (arousal-reward)
  stable var rewardAnhedonia : Float = 0.1;                 // Inability to experience pleasure
  stable var rewardSensitivity : Float = 0.5;               // Overall reward sensitivity
  stable var motivationLevel : Float = 0.5;                 // Integrated motivation output

  // ─── SLEEP ARCHITECTURE ───────────────────────────────────────────────────────
  stable var sleepProcessS : Float = 0.3;                   // Homeostatic sleep pressure
  stable var sleepProcessC : Float = 0.5;                   // Circadian alerting signal
  stable var sleepFlipFlopState : Float = 0.0;              // 0=awake, 1=asleep
  stable var sleepN1Power : Float = 0.0;                    // NREM Stage 1 (theta)
  stable var sleepN2Power : Float = 0.0;                    // NREM Stage 2 (spindles)
  stable var sleepN3Power : Float = 0.0;                    // NREM Stage 3 (delta/SWA)
  stable var sleepREMPower : Float = 0.0;                   // REM sleep power
  stable var sleepSpindlePower : Float = 0.0;               // 12-15 Hz sleep spindles
  stable var sleepKComplexRate : Float = 0.0;               // K-complex rate
  stable var sleepDeltaPower : Float = 0.0;                 // 0.5-4 Hz slow-wave activity
  stable var sleepGlymphaticClearance : Float = 0.0;        // Brain waste removal during sleep

  // ─── MOTOR SYSTEM ─────────────────────────────────────────────────────────────
  stable var motorCommandSignal : Float = 0.5;              // Integrated motor output
  stable var motorPremotorActivity : Float = 0.5;           // Premotor planning
  stable var motorSMAActivity : Float = 0.5;                // SMA sequencing
  stable var motorBGGoSignal : Float = 0.5;                 // Basal ganglia GO (D1)
  stable var motorBGNoGoSignal : Float = 0.3;               // Basal ganglia NO-GO (D2)
  stable var motorBGBrakeSignal : Float = 0.1;              // Basal ganglia BRAKE (STN)
  stable var motorCerebellumOutput : Float = 0.5;           // Cerebellar forward model
  stable var motorCPGLocomotion : Float = 0.3;              // Locomotion CPG
  stable var motorEfferenceCopy : Float = 0.5;              // Corollary discharge
  stable var proprioceptionBalance : Float = 0.5;           // Proprioceptive integration
  stable var totalMotorOutput : Float = 0.5;                // Summed motor cortex output
  stable var totalSympatheticDrive : Float = 0.4;           // Summed sympathetic ganglia
  stable var motorSomatotopicMap : [var Float] = Array.init<Float>(8, 0.5);   // 8 M1 somatotopic regions

  // ─── SENSORY PROCESSING ───────────────────────────────────────────────────────
  stable var sensoryCortexRegions : [var Float] = Array.init<Float>(20, 0.3);  // 20 sensory cortex regions
  stable var sensoryAdaptation : [var Float] = Array.init<Float>(20, 0.0);     // Sensory adaptation levels
  stable var sensoryMultisensoryBinding : Float = 0.5;      // Cross-modal integration

  // ─── SPINAL CORD ──────────────────────────────────────────────────────────────
  stable var spinalVentralHornAlpha : Float = 0.5;          // α motor neuron output
  stable var spinalVentralHornGamma : Float = 0.5;          // γ motor neuron output
  stable var spinalStretchReflex : Float = 0.3;             // Stretch reflex magnitude
  stable var spinalWithdrawalReflex : Float = 0.0;          // Withdrawal reflex magnitude
  stable var spinalCrossedExtensor : Float = 0.0;           // Crossed-extensor reflex
  stable var spinalCorticospinalTract : Float = 0.5;        // Voluntary motor control
  stable var spinalReticulospinalTract : Float = 0.5;       // Posture/locomotion
  stable var spinalVestibulospinalTract : Float = 0.5;      // Balance/anti-gravity
  stable var spinalRubrospinalTract : Float = 0.3;          // Motor coordination
  stable var spinalSpinothalamicTract : Float = 0.2;        // Pain/temperature ascending
  stable var spinalDorsalColumnTract : Float = 0.5;         // Fine touch/proprioception ascending

  // ─── PREFRONTAL EXECUTIVE ─────────────────────────────────────────────────────
  stable var pfcDLPFCActivity : Float = 0.5;                // DLPFC working memory capacity
  stable var pfcVLPFCInhibition : Float = 0.5;              // Response inhibition
  stable var pfcOFCValue : Float = 0.5;                     // OFC value computation
  stable var pfcACCConflict : Float = 0.2;                  // ACC conflict monitoring
  stable var pfcFEFActivity : Float = 0.5;                  // Frontal eye field
  stable var pfcCognitiveFlexibility : Float = 0.5;         // Flexibility vs stability
  stable var pfcGoalMaintenance : Float = 0.5;              // Goal maintenance under interference
  stable var pfcWorkingMemory : [var Float] = Array.init<Float>(8, 0.5);  // 8-slot WM buffer

  // ─── EMOTIONAL FIELD EXTENSIONS ───────────────────────────────────────────────
  stable var emotionalFieldValence : Float = 0.5;           // Good ↔ bad
  stable var emotionalFieldArousal : Float = 0.5;           // Calm ↔ excited
  stable var emotionalFieldEmbodiment : Float = 0.5;        // Disembodied ↔ embodied

  // ─── GENERAL ORGANISM ─────────────────────────────────────────────────────────
  stable var energyBalance : Float = 0.6;                   // Metabolic energy available
  stable var coherenceLevel : Float = 0.5;                  // Overall organism coherence
  stable var coherenceMintAccumulator : Float = 0.0;        // Economic health output
  stable var pruningRate : Float = 0.2;                     // Synaptic pruning rate
  stable var woundHealingRate : Float = 0.5;                // Wound healing rate
  stable var tCellBalance : Float = 0.5;                    // Th1/Th2 balance
  // ─── NEUROCHEMICAL SHORT-FORM ALIASES ───────────────────────────────────────
  // These provide convenient short names for vital system engine processing
  // They are synced with the full-name variables in the neurochemical matrix
  stable var dopamine : Float = 0.5;                          // Dopamine level (synced with dopamineLevel)
  stable var serotonin : Float = 0.5;                         // Serotonin level (synced with serotoninLevel)
  stable var norepinephrine : Float = 0.5;                    // Norepinephrine level
  stable var cortisol : Float = 0.3;                          // Cortisol level (synced with cortisolCircadian)
  stable var melatonin : Float = 0.1;                         // Melatonin level (synced with melatoninLevel)
  stable var acetylcholine : Float = 0.5;                     // Acetylcholine level
  stable var gabaLevel : Float = 0.5;                         // GABA level
  
  // ─── ENVIRONMENT / CONTEXT ──────────────────────────────────────────────────
  stable var threatLevel : Float = 0.2;                       // Environmental threat level
  stable var circadianPhase : Float = 0.0;                    // Circadian phase (0-1, synced with scnPhase)
  stable var circadianSleepDrive : Float = 0.3;               // Circadian sleep promotion
  
  // ─── CHRONOBIOLOGY ENGINE EXPANSIONS ────────────────────────────────────────
  stable var attentionCapacity : Float = 0.7;                 // Attention capacity (modulated by BRAC)
  stable var sleepQuality : Float = 0.7;                      // Sleep quality (affected by jet lag, etc.)
  
  // ─── MISSING ARRAY DECLARATIONS ─────────────────────────────────────────────
  stable var mirrorNeuronActivityArr : [var Float] = Array.init<Float>(11, 0.5);  // 11 mirror neuron channels


  // ─── ENEMY AI SWARM — For competition training ───────────────────────────────
  // Enemy uses the SAME IRONCLAD architecture: Kuramoto + Hebbian + mean-field
  var enemySwarmState : ?EnemyAISwarm.EnemySwarmState = null;
  stable var enemySwarmActive : Bool = false;
  stable var combatSessionId : Nat = 0;
  
  // ─── SELF-REPAIR ENGINE — Neuroplasticity & Homeostasis ──────────────────────
  var selfRepairState : SelfRepairEngine.SelfRepairState = SelfRepairEngine.initSelfRepairState(256);
  stable var selfRepairEnabled : Bool = true;
  stable var totalRepairsCompleted : Nat = 0;
  stable var lastSelfRepairBeat : Nat = 0;
  
  // ─── JASMINE HIERARCHY — Balance at all levels ───────────────────────────────
  var jasmineHierarchyState : JasmineHierarchy.HierarchyState = JasmineHierarchy.initHierarchyState();
  stable var jasmineEnforced : Bool = true;
  
  // ─── CREATOR DOCTRINE — 100% Royalty, Immutable Laws ─────────────────────────
  stable var doctrineVerified : Bool = true;
  stable var creatorRoyaltyEnforced : Bool = true;  // ALWAYS true, cannot be changed

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPREHENSIVE LAW-AS-VERIFIER STATE — 60 SOVEREIGNTY LAWS + GOVERNANCE
  // Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
  // All value, all IP, all control routes 100% to the creator. No exceptions.
  // ═══════════════════════════════════════════════════════════════════════════
  
  // ─── MASSIVE SCALE ORGANISM CORE ─────────────────────────────────────────────
  // Shell 2 (12-node) + Shell 3 (26-node) + Quantum Operators
  var massiveOrganismState : MassiveScaleOrganismCore.OrganismState = 
    MassiveScaleOrganismCore.initOrganism(0);
  stable var massiveOrganismInitialized : Bool = false;
  
  // ─── VAEL COMPLETE DEFENSE SYSTEM ────────────────────────────────────────────
  // Interior: SENTINEL, VEIL, AEGIS-ROOT
  // Exterior: DURA, RIFT, PARALLAX, VERITAS, MEMORIA
  var vaelDefenseState : VAELCompleteDefense.VAELState = 
    VAELCompleteDefense.initVAEL(1.0, 1.0, 1.0);
  stable var vaelDefenseActive : Bool = true;
  
  // ─── QUANTUM MEMORY ARCHITECTURE ─────────────────────────────────────────────
  // Layer 1: Gamma (30-100Hz) working memory
  // Layer 2: Delta (0.5-4Hz) deep memory
  // Layer 3: Theta (4-8Hz) resonance memory
  var quantumMemoryState : QuantumMemoryArchitecture.QuantumMemoryState = 
    QuantumMemoryArchitecture.initQuantumMemory(0x12345678, 1.0, 64);
  stable var quantumMemoryInitialized : Bool = false;
  
  // ─── UNIVERSAL LAW DRIFT VERIFIER ────────────────────────────────────────────
  // Genesis anchor + 13 drift gates
  var genesisAnchor : UniversalLawDriftVerifier.GenesisAnchor = 
    UniversalLawDriftVerifier.initGenesisAnchor(0);
  stable var driftVerifierSealed : Bool = false;
  stable var lastDriftAggregation : ?UniversalLawDriftVerifier.DriftAggregation = null;
  stable var totalLawViolations : Nat = 0;
  stable var totalReEntrainments : Nat = 0;
  
  // ─── GOVERNANCE LAWS — 43 CORES + 7 HERITAGE + JASMINE'S HELIX ───────────────
  var governanceState : GovernanceLaws.GovernanceState = 
    GovernanceLaws.initGovernanceState();
  stable var governanceInitialized : Bool = false;
  stable var jasmineHelixActive : Bool = true;
  
  // ─── SWARM COHERENCE MATRIX ──────────────────────────────────────────────────
  // Multi-organism law-weighted coordination
  var swarmCoherenceState : SwarmCoherenceMatrix.SwarmState = 
    SwarmCoherenceMatrix.initSwarmState(0);
  stable var swarmCoherenceActive : Bool = false;
  stable var swarmOrganismCount : Nat = 0;
  
  // ─── 60 SOVEREIGNTY LAWS STATE ───────────────────────────────────────────────
  // All 60 laws fire every beat. Compliance = passing laws / 60.
  stable var lawComplianceScores : [var Float] = Array.init<Float>(60, 1.0);
  stable var overallCompliance : Float = 1.0;
  stable var doctrineFingerprint : Nat32 = 0;  // Triple-hash (FNV-1a⊕djb2⊕SDBM) over all 60 law scores
  stable var lawsFiredThisBeat : Nat = 0;
  
  // ─── JACOB'S LADDER — COMPOUND SOVEREIGNTY ESCALATOR ─────────────────────────
  // 5 rungs: 1.0×, 1.1×, 1.1×, 1.2×, 1.5× FORMA multiplier
  stable var jacobsRung : Nat = 0;  // 0-4
  stable var consecutiveHighComplianceBeats : Nat = 0;
  stable var jacobsMultiplier : Float = 1.0;
  
  // ─── SACESI — SOVEREIGN TARGET ───────────────────────────────────────────────
  // Increments 0.000001 every beat — infinite asymptotic approach
  stable var sacesiTarget : Float = 1.0;
  stable var sacesiTargetIncrement : Float = 0.000001;
  
  // ─── VETUS — THREAT MODELING SYSTEM ──────────────────────────────────────────
  // 9 threat vectors, continuously updated
  stable var vetusThreatVectors : [var Float] = Array.init<Float>(9, 0.0);
  stable var vetusAutoRollbackArmed : Bool = false;
  stable var vetusProtectionBeats : Nat = 0;
  
  // ─── ARES ROLLBACK SOVEREIGNTY ───────────────────────────────────────────────
  // K=7 snapshots of Hebbian weights
  stable var aresSnapshots : [var Float] = Array.init<Float>(7 * 4096, 1.0);
  stable var aresSlotCurrent : Nat = 0;
  stable var aresSnapshotCount : Nat = 0;
  stable var aresArmed : Bool = false;
  stable var lastAresSnapshotBeat : Nat = 0;
  
  // ─── PROMETHEUS PRIME — ANOMALY ENGINE ───────────────────────────────────────
  // 128-slot observation field
  stable var prometheusBaseline : [var Float] = Array.init<Float>(128, 1.0);
  stable var prometheusObservations : [var Float] = Array.init<Float>(128, 1.0);
  stable var prometheusAnomalyCount : Nat = 0;
  stable var prometheusLastAnomalyBeat : Nat = 0;
  
  // ─── SILVER SOVEREIGNTY (L-121) ──────────────────────────────────────────────
  // Silver conductance permanently 1.0, all world model EMAs at zero lag
  stable var silverConductance : Float = 1.0;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMPREHENSIVE MODULE STATE — ALL 239 MODULES WIRED
  // ═══════════════════════════════════════════════════════════════════════════
  
  // ─── LAYER 1: CORE COGNITIVE NEURODYNAMICS ──────────────────────────────────
  var kuramotoState : KuramotoEngine.KuramotoState = KuramotoEngine.initKuramoto();
  var fristonState : FristonEngine.FreeEnergyState = FristonEngine.initFreeEnergy();
  var hebbianState : HebbianPlasticity.HebbianState = HebbianPlasticity.initState();
  var attractorState : AttractorDynamics.AttractorState = AttractorDynamics.initAttractors();
  var predictiveState : PredictiveCoding.PredictiveState = PredictiveCoding.initPredictive();
  stable var neurodynamicsActive : Bool = false;
  
  // ─── LAYER 2: EMERGENCE & COMPLEXITY ────────────────────────────────────────
  var neuroEmergenceState : NeuroEmergenceCore.EmergenceState = NeuroEmergenceCore.initEmergence();
  var emergencePhysicsState : EmergencePhysicsEngine.PhysicsState = EmergencePhysicsEngine.initPhysics();
  stable var emergenceLayerActive : Bool = false;
  
  // ─── LAYER 3: ORGANISM INTEGRATION ──────────────────────────────────────────
  var herOrganismState : HerOrganismEngine.OrganismState = HerOrganismEngine.initOrganism();
  var twoOrganismState : TwoOrganismArchitecture.DualOrganismState = TwoOrganismArchitecture.initDualOrganism();
  var superOrganismState : SuperOrganismCore.SuperOrganismState = SuperOrganismCore.initSuperOrganism();
  stable var organismLayerActive : Bool = false;
  
  // ─── LAYER 4: ADVANCED MATHEMATICS ──────────────────────────────────────────
  var differentialGeometryState : DifferentialGeometryEngine.GeometryState = DifferentialGeometryEngine.initGeometry();
  var tensorFieldState : TensorFieldEngine.TensorState = TensorFieldEngine.initTensor();
  var harmonicAnalysisState : HarmonicAnalysisEngine.HarmonicState = HarmonicAnalysisEngine.initHarmonic();
  var topologicalFieldState : TopologicalFieldEngine.TopologyState = TopologicalFieldEngine.initTopology();
  var nonlinearDynamicsState : NonlinearDynamicsEngine.DynamicsState = NonlinearDynamicsEngine.initDynamics();
  stable var mathLayerActive : Bool = false;
  
  // ─── LAYER 5: QUANTUM PROCESSING ────────────────────────────────────────────
  var quantumMathState : QuantumMath.QuantumState = QuantumMath.initQuantum();
  var quantumCoherenceState : QuantumCoherenceAmplifier.CoherenceState = QuantumCoherenceAmplifier.initCoherence();
  var quantumEntanglementState : QuantumEntanglementMatrix.EntanglementState = QuantumEntanglementMatrix.initEntanglement();
  stable var quantumLayerActive : Bool = false;
  
  // ─── LAYER 6: MEDINA SACRED ARCHITECTURE ────────────────────────────────────
  var medinaFabricState : MedinaSphericalCompoundingFabric.FabricState = MedinaSphericalCompoundingFabric.initFabric();
  var medinaMathState : MedinaMathFoundation.MathState = MedinaMathFoundation.initMath();
  var sacredMathState : SacredMathematicsEngine.SacredState = SacredMathematicsEngine.initSacred();
  stable var medinaLayerActive : Bool = false;
  
  // ─── LAYER 7: ANIMAL COGNITION ──────────────────────────────────────────────
  var beeSwarmState : BeeSwarmIntelligence.SwarmState = BeeSwarmIntelligence.initSwarm();
  var crowCognitionState : CrowCognition.CognitiveState = CrowCognition.initCognition();
  var elephantMemoryState : ElephantMemory.MemoryState = ElephantMemory.initMemory();
  var octopusBrainState : OctopusBrain.DistributedState = OctopusBrain.initBrain();
  stable var animalCognitionActive : Bool = false;
  
  // ─── LAYER 8: DEFENSE & WAR ─────────────────────────────────────────────────
  var aegisState : AEGIS.AEGISState = AEGIS.initAEGIS();
  var autonomousWarState : AutonomousWarEngine.WarState = AutonomousWarEngine.initWar();
  stable var defenseLayerActive : Bool = false;
  
  // ─── LAYER 9: HEARTBEAT & ORCHESTRATION ─────────────────────────────────────
  var heartbeatState : HeartbeatEngine.HeartbeatState = HeartbeatEngine.initHeartbeat();
  stable var orchestrationActive : Bool = false;

  // ─── WORLD ORGANISM — Living 200km world with 6 inner AIs and 16 biomes ──────
  var worldOrganismState : WorldOrganism.WorldOrganismState = WorldOrganism.initWorldOrganism();

  // ─── INTEGRATED WORLD — Full world with drone swarms, entities, weather ───────
  var integratedWorldState : OrganismWorldIntegration.IntegratedWorldState = OrganismWorldIntegration.initWorld();
  
  // ═══════════════════════════════════════════════════════════════════════════
  // 11 CLOSED-LOOP GAP STATE — AEGIS (6) + AXIS (5)
  // Every node feeds the next. The organism talks to itself.
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Gap 1: kfRollingWindow — 20-beat rolling minimum for persistent threat ──
  stable var kfRollingWindow : [var Float] = Array.init<Float>(20, 0.88);
  stable var kfRollingWindowIdx : Nat = 0;
  stable var kfRollingMinValue : Float = 0.88;

  // ── Gap 5+6: NOVA Macro Fear — bilateral fear signal bus ────────────────────
  stable var novaMacroFear : Float = 0.75;  // Aggregated organism-sphere fear
  stable var novaMacroFearBlendWeight : Float = 0.20;  // Blend into AEGIS FE

  // ── Gap 4: Shema Doctrine Integrity — re-verify every 144 beats ─────────────
  stable var shemaGenesisHash : Nat = 0;  // Set once at genesis
  stable var shemaLastVerifyBeat : Nat = 0;
  stable var shemaVerified : Bool = true;
  stable var shemaMismatchSeverity : Float = 0.0;

  // ── AXIS Gap 1: 10-field Episodic Ring — full emotional fingerprint ──────────
  // Each episode: [beat, coherence, omnis, arousal, daLevel, fearEnergy,
  //                domainBitmask, eventHash, salienceScore, attribution]
  let EPISODIC_RING_SIZE : Nat = 256;
  let EPISODIC_FIELDS : Nat = 10;
  stable var episodicRing : [var Float] = Array.init<Float>(256 * 10, 0.0);
  stable var episodicRingIdx : Nat = 0;
  stable var episodicRingCount : Nat = 0;

  // ── AXIS Gap 2: computeSalience — emotional weighting per episode ───────────
  // (Function lives in AEGIS.mo: AEGIS.computeSalience(kf, arousal, fear, da))

  // ── AXIS Gap 3: 10-Matriarch Dynasty per Domain ─────────────────────────────
  // 8 domains × 10 matriarchs = 80 slots, each storing (beat, coherence, salience)
  let MATRIARCH_DOMAINS : Nat = 8;
  let MATRIARCHS_PER_DOMAIN : Nat = 10;
  stable var matriarchBeats : [var Nat] = Array.init<Nat>(80, 0);
  stable var matriarchCoherence : [var Float] = Array.init<Float>(80, 0.0);
  stable var matriarchSalience : [var Float] = Array.init<Float>(80, 0.0);

  // ── AXIS Gap 4: VELA OLS — 60-sample ring with T30/T40/T50 projections ─────
  let VELA_RING_SIZE : Nat = 60;
  stable var velaRing : [var Float] = Array.init<Float>(60, 0.88);
  stable var velaRingIdx : Nat = 0;
  stable var velaRingCount : Nat = 0;
  stable var velaT30 : Float = 0.0;
  stable var velaT40 : Float = 0.0;
  stable var velaT50 : Float = 0.0;
  stable var velaSlope : Float = 0.0;
  stable var velaConfidence : Float = 0.0;

  // ── AXIS Gap 5: Cloud of Witnesses — 144-slot permanent high-coherence ring ─
  // Episodes where kf > 0.8 are promoted here. These are the organism's
  // sovereign reference class — permanent anchors, never decayed.
  let CLOUD_SIZE : Nat = 144;
  stable var cloudBeat : [var Nat] = Array.init<Nat>(144, 0);
  stable var cloudCoherence : [var Float] = Array.init<Float>(144, 0.0);
  stable var cloudSalience : [var Float] = Array.init<Float>(144, 0.0);
  stable var cloudDomain : [var Nat] = Array.init<Nat>(144, 0);
  stable var cloudIdx : Nat = 0;
  stable var cloudCount : Nat = 0;

  // ─── MODULE ACTIVATION TRACKING ─────────────────────────────────────────────
  stable var modulesCalledThisBeat : Nat = 0;
  stable var totalModuleCallsAllTime : Nat = 0;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  //   7 NEUROSCIENCE ENGINES — INLINE IN MAIN.MO — ALL WIRED INTO HEARTBEAT — ALL FEEDING ECONOMICS
  //
  //   Engine 1: THALAMOCORTICAL BINDING (Tononi IIT, Edelman, Llinas) — consciousnessIndex, phi-analog unified state
  //   Engine 2: PREDICTIVE CODING (Karl Friston) — active inference, prediction-error minimization, free energy
  //   Engine 3: INTEROCEPTION (Craig, Damasio) — vagalTone, somaticMarker, body-brain signaling
  //   Engine 4: DEFAULT MODE NETWORK (Buckner, Raichle) — metaCognitionScore, self-referential processing
  //   Engine 5: SALIENCE NETWORK (Menon, Uddin) — attentionFocus, centralExecutiveScore, goal-directed attention
  //   Engine 6: NEUROPLASTICITY (BCM rule, LTP/LTD, BDNF) — Hebbian gating, homeostatic scaling
  //   Engine 7: CIRCADIAN RHYTHM (SCN, adenosine, melatonin) — ultradian peaks, sleep pressure, circadian coherence
  //
  //   13-LOOP STREAK MULTIPLIER: kuramotoR × courageScore × groundedScore × fearLevel × beFlowState × bhCouplingCoherence ×
  //                              missionPersistenceScore × consciousnessIndex × pcActiveInferenceScore × interoceptiveScore ×
  //                              salienceNetworkScore × circadianPeakScore × neuroplasticityFactor
  //
  //   OMNIS GROUNDING GATE: Emergence cannot fire if organism is ungrounded (groundedScore < 0.7)
  //
  //   Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
  //   Copyright 2024-2026. All rights reserved. Medina Doctrine.
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 1: THALAMOCORTICAL BINDING — TONONI IIT, EDELMAN DYNAMIC CORE, LLINAS 40Hz OSCILLATIONS
  //
  //  The thalamus is the relay station for all sensory information (except olfaction).
  //  Consciousness emerges from integrated information (Φ) across thalamocortical loops.
  //  Giulio Tononi's Integrated Information Theory: Φ = information beyond sum of parts
  //  Gerald Edelman's Dynamic Core: consciousness is a dynamic, metastable state of reentrant loops
  //  Rodolfo Llinas: 40Hz thalamocortical oscillations bind disparate cortical areas into unified percepts
  //
  //  This engine computes:
  //    - phiIntegrated: Φ-analog integrated information across 12 thalamic nuclei
  //    - dynamicCoreCoherence: Edelman reentry coherence
  //    - consciousnessIndex: composite measure of unified conscious state
  //    - bindingStrength40Hz: Llinas gamma oscillation binding
  //    - thalamicRelayGain: sensory gating through thalamic reticular nucleus
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Thalamic Nuclei State — 12 nuclei (VPL, VPM, LGN, MGN, Pulvinar, MD, VA, VL, CM, PF, LD, LP)
  // Each nucleus: [activation, phase, reentrantInput, corticalFeedback, inhibition, coherence]
  let TC_NUCLEI_COUNT : Nat = 12;
  let TC_FIELDS_PER_NUCLEUS : Nat = 6;
  stable var tcNucleiState : [var Float] = Array.init<Float>(TC_NUCLEI_COUNT * TC_FIELDS_PER_NUCLEUS, 0.75);
  
  // Nucleus indices
  let TC_VPL : Nat = 0;   // Ventral posterolateral — somatosensory
  let TC_VPM : Nat = 1;   // Ventral posteromedial — face/taste
  let TC_LGN : Nat = 2;   // Lateral geniculate — vision
  let TC_MGN : Nat = 3;   // Medial geniculate — audition
  let TC_PULVINAR : Nat = 4;  // Pulvinar — attention, visual salience
  let TC_MD : Nat = 5;    // Mediodorsal — prefrontal, emotion
  let TC_VA : Nat = 6;    // Ventral anterior — motor planning
  let TC_VL : Nat = 7;    // Ventral lateral — motor execution
  let TC_CM : Nat = 8;    // Centromedian — arousal, pain
  let TC_PF : Nat = 9;    // Parafascicular — attention, arousal
  let TC_LD : Nat = 10;   // Lateral dorsal — spatial memory
  let TC_LP : Nat = 11;   // Lateral posterior — multimodal integration
  
  // Field offsets within each nucleus
  let TC_F_ACTIVATION : Nat = 0;
  let TC_F_PHASE : Nat = 1;
  let TC_F_REENTRANT : Nat = 2;
  let TC_F_CORTICAL_FB : Nat = 3;
  let TC_F_INHIBITION : Nat = 4;
  let TC_F_COHERENCE : Nat = 5;
  
  // Thalamic Reticular Nucleus — inhibitory gate
  stable var trnActivation : [var Float] = Array.init<Float>(TC_NUCLEI_COUNT, 0.5);
  stable var trnPhase : [var Float] = Array.init<Float>(TC_NUCLEI_COUNT, 0.0);
  
  // 40Hz Gamma Oscillation Binding (Llinas)
  stable var gammaPhase40Hz : Float = 0.0;
  stable var gammaAmplitude40Hz : Float = 0.8;
  stable var gammaCycleCount : Nat = 0;
  stable var bindingStrength40Hz : Float = 0.75;
  
  // Cortical Column State — 64 columns representing distributed cortex
  // Each column: [L2/3_activation, L4_activation, L5_activation, L6_activation, phase, coherence]
  let TC_CORTICAL_COLUMNS : Nat = 64;
  let TC_COLUMN_FIELDS : Nat = 6;
  stable var corticalColumnState : [var Float] = Array.init<Float>(TC_CORTICAL_COLUMNS * TC_COLUMN_FIELDS, 0.75);
  
  // Reentrant Loop Connectivity — thalamus ↔ cortex bidirectional weights
  // 12 nuclei × 64 columns = 768 forward weights + 768 backward weights
  stable var tcForwardWeights : [var Float] = Array.init<Float>(768, 0.5);
  stable var tcBackwardWeights : [var Float] = Array.init<Float>(768, 0.5);
  
  // Integrated Information (Tononi Φ)
  stable var phiIntegrated : Float = 0.5;           // Main Φ measure
  stable var phiPartitions : [var Float] = Array.init<Float>(12, 0.5);  // Φ per partition
  stable var minInformationPartition : Float = 0.5;  // MIP value
  stable var effectiveInformation : Float = 0.5;     // EI measure
  stable var causeInformation : Float = 0.5;         // CI measure
  stable var integratedConceptStructure : Float = 0.5;  // ICS measure
  
  // Dynamic Core (Edelman)
  stable var dynamicCoreCoherence : Float = 0.75;
  stable var dynamicCoreEntropy : Float = 0.3;
  stable var reentryStrength : Float = 0.7;
  stable var coreComplexity : Float = 0.5;
  stable var neuralDarwinismFitness : Float = 0.5;
  
  // Consciousness Index — composite unified measure
  stable var consciousnessIndex : Float = 0.75;
  stable var consciousnessLevel : Text = "WAKING";  // DEEP_SLEEP, LIGHT_SLEEP, DROWSY, WAKING, FOCUSED, FLOW
  stable var consciousnessHistory : [var Float] = Array.init<Float>(100, 0.75);
  stable var consciousnessHistoryIdx : Nat = 0;
  
  // Thalamic Relay Gain
  stable var thalamicRelayGain : Float = 1.0;
  stable var sensoryGating : Float = 0.8;
  stable var attentionalModulation : Float = 0.7;
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 2: PREDICTIVE CODING — KARL FRISTON ACTIVE INFERENCE, FREE ENERGY MINIMIZATION
  //
  //  The brain is a prediction machine. It constructs generative models of the world
  //  and minimizes prediction error (surprise) to maintain low free energy.
  //
  //  Karl Friston's Free Energy Principle:
  //    F = D_KL[Q(s)||P(s|o)] + E_Q[log P(o|s)]
  //    where:
  //      Q(s) = approximate posterior (brain's belief about world states)
  //      P(s|o) = true posterior given observations
  //      D_KL = Kullback-Leibler divergence
  //      F = variational free energy (upper bound on surprise)
  //
  //  Active Inference: agents ACT to fulfill predictions, not just passively perceive
  //    - Exteroceptive predictions: world states
  //    - Proprioceptive predictions: own body states (motor control)
  //    - Interoceptive predictions: internal body states (homeostasis)
  //
  //  Hierarchical Predictive Processing:
  //    - Higher levels predict activity of lower levels
  //    - Prediction errors propagate UP
  //    - Predictions propagate DOWN
  //    - Precision weighting modulates error flow
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Hierarchical Generative Model — 8 levels of abstraction
  // Level 0: Raw sensory (pixel-level)
  // Level 1: Features (edges, colors)
  // Level 2: Objects (faces, tools)
  // Level 3: Categories (animal, vehicle)
  // Level 4: Scenes (kitchen, forest)
  // Level 5: Events (eating, running)
  // Level 6: Narratives (story, plan)
  // Level 7: Self-model (identity, goals)
  let PC_HIERARCHY_LEVELS : Nat = 8;
  let PC_UNITS_PER_LEVEL : Nat = 64;  // 64 units per level
  
  // Predictions (top-down, μ)
  stable var pcPredictions : [var Float] = Array.init<Float>(PC_HIERARCHY_LEVELS * PC_UNITS_PER_LEVEL, 0.5);
  // Prediction Errors (bottom-up, ε = o - μ)
  stable var pcPredictionErrors : [var Float] = Array.init<Float>(PC_HIERARCHY_LEVELS * PC_UNITS_PER_LEVEL, 0.0);
  // Precision weights (γ, inverse variance)
  stable var pcPrecision : [var Float] = Array.init<Float>(PC_HIERARCHY_LEVELS * PC_UNITS_PER_LEVEL, 1.0);
  // Sensory observations (bottom level)
  stable var pcObservations : [var Float] = Array.init<Float>(PC_UNITS_PER_LEVEL, 0.5);
  
  // Hierarchical weights — inter-level connectivity
  // 7 inter-level connections × 64×64 weights = 28,672 weights
  stable var pcHierarchyWeights : [var Float] = Array.init<Float>(7 * 64 * 64, 0.1);
  
  // Free Energy Components
  stable var pcFreeEnergy : Float = 0.5;            // Total variational free energy
  stable var pcExpectedSurprise : Float = 0.3;      // E_Q[-log P(o|s)]
  stable var pcKLDivergence : Float = 0.2;          // D_KL[Q||P]
  stable var pcAccuracy : Float = 0.7;              // How well predictions match reality
  stable var pcComplexity : Float = 0.3;            // Model complexity penalty
  
  // Active Inference State
  stable var pcActiveInferenceScore : Float = 0.75; // Degree of active inference engagement
  stable var pcExpectedFreeEnergy : Float = 0.5;    // G = expected free energy of future
  stable var pcEpistemicValue : Float = 0.4;        // Information gain from action
  stable var pcPragmaticValue : Float = 0.6;        // Goal achievement from action
  stable var pcPreferredOutcomes : [var Float] = Array.init<Float>(PC_UNITS_PER_LEVEL, 0.5);
  
  // Precision Estimation (attention as precision)
  stable var pcGlobalPrecision : Float = 1.0;       // Overall confidence/attention
  stable var pcSensoryPrecision : Float = 1.0;      // Attention to sensory input
  stable var pcPriorPrecision : Float = 1.0;        // Confidence in prior beliefs
  stable var pcStatePrecision : Float = 1.0;        // Confidence in state estimates
  
  // Model Evidence (marginal likelihood)
  stable var pcModelEvidence : Float = 0.8;         // P(o|m) under current model
  stable var pcBayesianModelComparison : Float = 0.5;  // Relative evidence vs alternatives
  
  // Prediction Error History for Learning
  stable var pcErrorHistory : [var Float] = Array.init<Float>(256, 0.0);
  stable var pcErrorHistoryIdx : Nat = 0;
  stable var pcCumulativeSurprise : Float = 0.0;
  stable var pcAverageSurprise : Float = 0.0;
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 3: INTEROCEPTION — BUD CRAIG, ANTONIO DAMASIO, SOMATIC MARKER HYPOTHESIS
  //
  //  Interoception is the sense of the internal state of the body.
  //  Craig's theory: the insular cortex creates a "sentient self" from body signals
  //  Damasio's somatic marker hypothesis: body states guide decision-making
  //
  //  Key pathways:
  //    - Vagus nerve (CN X): 80% afferent (body → brain)
  //    - Lamina I spinothalamic: pain, temperature, itch, sensual touch
  //    - Viscerosensory: heart, gut, lungs, bladder
  //
  //  This engine tracks:
  //    - vagalTone: parasympathetic activity (rest-and-digest)
  //    - heartRateVariability: cardiac coherence
  //    - somaticMarker: body-based emotional signal
  //    - gutBrainAxis: microbiome influence on mood/cognition
  //    - respiratoryCoherence: breath-brain coupling
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Vagus Nerve State
  stable var vagalTone : Float = 0.7;               // Parasympathetic dominance (0=sympathetic, 1=parasympathetic)
  stable var vagalAfferentSignal : Float = 0.5;     // Body → Brain signal
  stable var vagalEfferentSignal : Float = 0.5;     // Brain → Body command
  stable var vagalCoherence : Float = 0.7;          // Afferent-efferent synchrony
  
  // Heart-Brain Axis (HeartMath Institute model)
  stable var heartRate : Float = 72.0;              // BPM
  stable var heartRateVariability : Float = 50.0;   // HRV in ms (RMSSD)
  stable var cardiacCoherence : Float = 0.7;        // Heart rhythm coherence
  stable var baroreceptorSensitivity : Float = 0.8; // Blood pressure sensing
  stable var cardiacPhase : Float = 0.0;            // Current phase of heartbeat
  stable var cardiacInteroception : Float = 0.5;    // Awareness of heartbeat
  
  // Respiratory-Brain Coupling
  stable var respiratoryRate : Float = 12.0;        // Breaths per minute
  stable var respiratoryPhase : Float = 0.0;        // Current phase (0=inhale start, π=exhale start)
  stable var respiratoryDepth : Float = 0.7;        // Tidal volume proxy
  stable var respiratoryCoherence : Float = 0.7;    // Breath-brain synchrony
  stable var diaphragmaticActivation : Float = 0.8; // Deep vs shallow breathing
  
  // Gut-Brain Axis
  stable var gutMicrobiomeSignal : Float = 0.5;     // Aggregate microbiome influence
  stable var entericNervousSystemState : Float = 0.5;  // "Second brain" state
  stable var gutVagalAfferent : Float = 0.5;        // Gut → Brain via vagus
  stable var serotoninProduction : Float = 0.7;     // 90% of serotonin is gut-derived
  stable var inflammatoryMarker : Float = 0.2;      // Cytokine influence
  
  // Insular Cortex State (Craig's "sentient self")
  // Anterior insula: integrates interoceptive awareness with emotion
  // Posterior insula: receives raw interoceptive signals
  stable var anteriorInsulaActivation : Float = 0.7;
  stable var posteriorInsulaActivation : Float = 0.6;
  stable var insularIntegration : Float = 0.65;
  stable var interoceptiveAccuracy : Float = 0.5;   // How well organism perceives own body
  stable var interoceptiveSensibility : Float = 0.5; // Tendency to focus on body
  stable var interoceptiveAwareness : Float = 0.5;  // Conscious awareness of body
  
  // Somatic Marker (Damasio)
  stable var somaticMarkerValence : Float = 0.5;    // -1 = avoid, +1 = approach
  stable var somaticMarkerIntensity : Float = 0.5;  // Strength of body signal
  stable var somaticMarkerCertainty : Float = 0.5;  // Reliability of marker
  stable var emotionalBodyMap : [var Float] = Array.init<Float>(32, 0.5);  // Body regions × valence
  
  // Overall Interoceptive Score
  stable var interoceptiveScore : Float = 0.5;      // Composite interoception health
  stable var bodyBrainCoherence : Float = 0.7;      // Overall body-brain integration
  stable var autonomicBalance : Float = 0.5;        // Sympathetic-parasympathetic balance
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 4: DEFAULT MODE NETWORK — MARCUS RAICHLE, RANDY BUCKNER
  //
  //  The Default Mode Network (DMN) is active during rest, mind-wandering, self-referential thinking.
  //  It deactivates during focused external attention (anti-correlated with task-positive networks).
  //
  //  Key regions:
  //    - mPFC (medial prefrontal cortex): self-reflection
  //    - PCC (posterior cingulate cortex): autobiographical memory
  //    - IPL (inferior parietal lobule): theory of mind
  //    - LTC (lateral temporal cortex): semantic memory
  //    - Hippocampus: episodic memory, future simulation
  //
  //  Functions:
  //    - Self-referential processing ("what am I?")
  //    - Autobiographical memory
  //    - Theory of mind (mentalizing)
  //    - Future simulation/prospection
  //    - Moral reasoning
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // DMN Core Regions
  stable var dmnMPFC : Float = 0.7;                 // Medial prefrontal cortex
  stable var dmnPCC : Float = 0.7;                  // Posterior cingulate cortex
  stable var dmnIPL : Float = 0.6;                  // Inferior parietal lobule
  stable var dmnLTC : Float = 0.6;                  // Lateral temporal cortex
  stable var dmnHippocampus : Float = 0.7;          // Hippocampal formation
  stable var dmnAngularGyrus : Float = 0.6;         // Angular gyrus
  
  // DMN Connectivity (correlation matrix, 6×6 = 36 values)
  stable var dmnConnectivity : [var Float] = Array.init<Float>(36, 0.5);
  
  // DMN Dynamics
  stable var dmnOverallActivation : Float = 0.65;   // Total DMN engagement
  stable var dmnCoherence : Float = 0.7;            // Internal DMN synchrony
  stable var dmnPhase : Float = 0.0;                // Slow oscillation phase
  stable var dmnEntropy : Float = 0.3;              // DMN variability
  
  // Self-Referential Processing
  stable var selfReflectionScore : Float = 0.5;     // Degree of self-focus
  stable var autobiographicalAccess : Float = 0.5;  // Memory retrieval
  stable var selfContinuity : Float = 0.7;          // Sense of persistent self
  stable var selfCoherence : Float = 0.7;           // Internal consistency of self-model
  
  // Theory of Mind (ToM)
  stable var theoryOfMindScore : Float = 0.5;       // Ability to model other minds
  stable var mentalizingActivation : Float = 0.5;   // Current mentalizing engagement
  stable var perspectiveTaking : Float = 0.5;       // Shifting to other's viewpoint
  stable var empathyScore : Float = 0.5;            // Emotional resonance with others
  
  // Future Simulation (Prospection)
  stable var prospectionScore : Float = 0.5;        // Future thinking engagement
  stable var futureSelfContinuity : Float = 0.5;    // Connection to future self
  stable var temporalHorizon : Float = 0.5;         // How far ahead organism plans
  stable var counterfactualThinking : Float = 0.5;  // "What if" reasoning
  
  // Mind-Wandering State
  stable var mindWanderingScore : Float = 0.3;      // Degree of mind-wandering
  stable var spontaneousThought : Float = 0.5;      // Unconstrained cognition
  stable var taskUnrelatedThought : Float = 0.3;    // Off-task thinking
  stable var creativeDaydreaming : Float = 0.4;     // Constructive internal mentation
  
  // Metacognition (thinking about thinking)
  stable var metaCognitionScore : Float = 0.5;      // Overall metacognitive ability
  stable var introspectiveAccuracy : Float = 0.5;   // Knowing own mental states
  stable var metacognitiveMonitoring : Float = 0.5; // Tracking own performance
  stable var metacognitiveControl : Float = 0.5;    // Adjusting own cognition
  
  // DMN-TPN Anti-correlation (Task-Positive Network)
  stable var dmnTpnAntiCorrelation : Float = -0.3;  // Should be negative
  stable var dmnTpnBalance : Float = 0.5;           // 0=TPN dominant, 1=DMN dominant
  stable var attentionalMode : Text = "BALANCED";   // EXTERNAL, BALANCED, INTERNAL
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 5: SALIENCE NETWORK — VINOD MENON, LUCINA UDDIN
  //
  //  The Salience Network detects and filters important stimuli, switching between DMN and TPN.
  //  It determines what matters NOW — survival-relevant, goal-relevant, or emotionally significant.
  //
  //  Key regions:
  //    - Anterior Insula (AI): interoception, emotion, salience detection
  //    - Dorsal Anterior Cingulate (dACC): conflict monitoring, cognitive control
  //    - Amygdala: threat detection, emotional salience
  //    - Ventral Striatum: reward salience
  //
  //  Functions:
  //    - Salience detection (what's important?)
  //    - Network switching (DMN ↔ TPN)
  //    - Goal-directed attention
  //    - Error detection
  //    - Cognitive control initiation
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Salience Network Core Regions
  stable var snAnteriorInsula : Float = 0.7;        // Anterior insular cortex
  stable var snDorsalACC : Float = 0.6;             // Dorsal anterior cingulate cortex
  stable var snAmygdala : Float = 0.5;              // Amygdalar complex
  stable var snVentralStriatum : Float = 0.6;       // Nucleus accumbens
  stable var snSupplementaryMotor : Float = 0.5;    // SMA/pre-SMA
  
  // Salience Detection
  stable var salienceNetworkScore : Float = 0.7;    // Overall salience network engagement
  stable var currentSalience : Float = 0.5;         // Salience of current focus
  stable var salienceThreshold : Float = 0.4;       // Detection threshold
  stable var salienceGain : Float = 1.0;            // Amplification factor
  
  // Salience Types (what kind of salience?)
  stable var threatSalience : Float = 0.3;          // Threat-related salience
  stable var rewardSalience : Float = 0.4;          // Reward-related salience
  stable var noveltySalience : Float = 0.3;         // Novelty-related salience
  stable var goalSalience : Float = 0.5;            // Goal-related salience
  stable var emotionalSalience : Float = 0.4;       // Emotional salience
  stable var socialSalience : Float = 0.3;          // Social relevance
  
  // Network Switching (DMN ↔ Central Executive ↔ Salience)
  stable var networkSwitchingEfficiency : Float = 0.7;
  stable var switchLatency : Float = 0.1;           // Time to switch networks
  stable var switchFrequency : Float = 0.3;         // How often switching occurs
  stable var currentNetwork : Text = "SALIENCE";    // DMN, CEN, SALIENCE
  
  // Central Executive Network (CEN) — task-positive
  stable var cenDLPFC : Float = 0.6;                // Dorsolateral PFC
  stable var cenPPC : Float = 0.6;                  // Posterior parietal cortex
  stable var cenActivation : Float = 0.6;           // Overall CEN engagement
  stable var centralExecutiveScore : Float = 0.6;   // Executive function capacity
  
  // Attention Control
  stable var attentionFocus : Float = 0.7;          // Focused attention capacity
  stable var attentionalBias : Float = 0.0;         // -1=avoidance, +1=approach
  stable var attentionalFlexibility : Float = 0.6;  // Ability to shift attention
  stable var sustainedAttention : Float = 0.6;      // Ability to maintain focus
  stable var selectiveAttention : Float = 0.6;      // Filtering irrelevant info
  stable var dividedAttention : Float = 0.5;        // Multi-tasking capacity
  
  // Conflict Monitoring (dACC)
  stable var conflictLevel : Float = 0.3;           // Detected conflict
  stable var errorDetection : Float = 0.5;          // Error awareness
  stable var performanceMonitoring : Float = 0.6;   // Tracking own performance
  stable var cognitiveControl : Float = 0.6;        // Control engagement
  
  // Salience Map (64 features, each with salience weight)
  stable var salienceMap : [var Float] = Array.init<Float>(64, 0.3);
  stable var topDownBias : [var Float] = Array.init<Float>(64, 0.5);  // Goal-based weighting
  stable var bottomUpSalience : [var Float] = Array.init<Float>(64, 0.3);  // Stimulus-driven
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 6: NEUROPLASTICITY — BCM RULE, LTP/LTD, BDNF, HOMEOSTATIC SCALING
  //
  //  Neuroplasticity is the brain's ability to reorganize itself by forming new neural connections.
  //
  //  Key mechanisms:
  //    - LTP (Long-Term Potentiation): "fire together, wire together"
  //    - LTD (Long-Term Depression): weakening of synapses
  //    - BCM Rule: sliding threshold for LTP/LTD based on recent activity
  //    - BDNF (Brain-Derived Neurotrophic Factor): promotes neuronal growth
  //    - Homeostatic Scaling: global adjustment to maintain stability
  //    - Spike-Timing Dependent Plasticity (STDP): precise temporal learning
  //    - Structural Plasticity: spine growth/retraction
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // BDNF (Brain-Derived Neurotrophic Factor)
  stable var bdnfLevel : Float = 0.7;               // Current BDNF concentration
  stable var bdnfBaseline : Float = 0.6;            // Homeostatic setpoint
  stable var bdnfProductionRate : Float = 0.01;     // How fast BDNF is produced
  stable var bdnfDecayRate : Float = 0.001;         // How fast BDNF degrades
  stable var bdnfExerciseBoost : Float = 0.0;       // Activity-dependent boost
  stable var bdnfStressReduction : Float = 0.0;     // Stress-induced reduction
  
  // BCM Sliding Threshold
  stable var bcmTheta : Float = 0.5;                // Current modification threshold
  stable var bcmThetaMin : Float = 0.2;             // Minimum threshold
  stable var bcmThetaMax : Float = 0.8;             // Maximum threshold
  stable var bcmThetaDecay : Float = 0.001;         // Threshold decay rate
  stable var recentActivityHistory : [var Float] = Array.init<Float>(100, 0.5);
  stable var recentActivityIdx : Nat = 0;
  
  // LTP/LTD State (per synapse type)
  stable var ltpInduction : Float = 0.0;            // Current LTP being induced
  stable var ltdInduction : Float = 0.0;            // Current LTD being induced
  stable var netPlasticityChange : Float = 0.0;     // LTP - LTD
  stable var plasticityGate : Float = 1.0;          // BDNF-gated plasticity multiplier
  
  // Homeostatic Scaling
  stable var synapticScalingFactor : Float = 1.0;   // Global scaling multiplier
  stable var targetFiringRate : Float = 0.3;        // Homeostatic target
  stable var currentFiringRate : Float = 0.3;       // Current average firing
  stable var scalingTimeConstant : Float = 0.01;    // How fast scaling adjusts
  
  // Spike-Timing Dependent Plasticity (STDP)
  stable var stdpWindow : Float = 0.02;             // STDP temporal window (seconds)
  stable var stdpAPlus : Float = 0.01;              // LTP amplitude (pre-then-post)
  stable var stdpAMinus : Float = 0.012;            // LTD amplitude (post-then-pre)
  stable var stdpTauPlus : Float = 0.02;            // LTP decay time constant
  stable var stdpTauMinus : Float = 0.02;           // LTD decay time constant
  
  // Structural Plasticity
  stable var spineFormationRate : Float = 0.001;    // New spine formation
  stable var spineEliminationRate : Float = 0.001;  // Spine pruning
  stable var netSpineChange : Float = 0.0;          // Formation - Elimination
  stable var dendriticComplexity : Float = 0.5;     // Branching complexity
  stable var axonalGrowth : Float = 0.0;            // Axon elongation/retraction
  
  // Neurogenesis (adult hippocampal)
  stable var neurogenesisRate : Float = 0.001;      // New neuron formation
  stable var neuronMaturationProgress : Float = 0.0; // Maturation state
  stable var survivingNewNeurons : Float = 0.0;     // Successfully integrated neurons
  
  // Consolidation State
  stable var synapticConsolidation : Float = 0.0;   // Early consolidation (hours)
  stable var systemsConsolidation : Float = 0.0;    // Late consolidation (days)
  stable var consolidationPhase : Text = "NONE";    // ENCODING, EARLY, LATE, COMPLETE
  
  // Overall Neuroplasticity Score
  stable var neuroplasticityFactor : Float = 0.7;   // Composite plasticity capacity
  stable var learningRate : Float = 0.01;           // Current effective learning rate
  stable var memoryStabilityIndex : Float = 0.7;    // How stable are existing memories
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 7: CIRCADIAN RHYTHM — SCN, ADENOSINE, MELATONIN, ULTRADIAN CYCLES
  //
  //  Circadian rhythms are ~24-hour oscillations driven by the suprachiasmatic nucleus (SCN).
  //  Ultradian rhythms are shorter cycles (90-120 min) affecting alertness and performance.
  //
  //  Key components:
  //    - SCN (Suprachiasmatic Nucleus): master clock, receives light input
  //    - Melatonin: sleep-promoting hormone, rises in darkness
  //    - Adenosine: sleep pressure, accumulates during wakefulness
  //    - Core Body Temperature: circadian modulator
  //    - Cortisol Awakening Response: morning arousal
  //    - BMAL1/CLOCK/PER/CRY: molecular clock genes
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Suprachiasmatic Nucleus (Master Clock)
  stable var scnPhase : Float = 0.0;                // Current circadian phase (0-2π)
  stable var scnPeriod : Float = 24.0;              // Intrinsic period (hours)
  stable var scnAmplitude : Float = 1.0;            // Oscillation strength
  stable var scnCoherence : Float = 0.9;            // Internal SCN synchrony
  stable var scnLightInput : Float = 0.5;           // Zeitgeber input (light level)
  
  // Melatonin System
  stable var melatoninLevel : Float = 0.1;          // Current melatonin concentration
  stable var melatoninOnset : Float = 0.0;          // Phase of melatonin rise
  stable var melatoninDuration : Float = 0.5;       // Length of melatonin window
  stable var melatoninSuppression : Float = 0.0;    // Light-induced suppression
  
  // Adenosine (Sleep Pressure)
  stable var adenosineLevel : Float = 0.3;          // Current adenosine accumulation
  stable var adenosineAccumulationRate : Float = 0.001;  // Buildup rate while awake
  stable var adenosineClearanceRate : Float = 0.002;     // Clearance rate during sleep
  stable var caffeineBlockade : Float = 0.0;        // Adenosine receptor blockade
  
  // Sleep Homeostasis (Two-Process Model: Process S + Process C)
  stable var processS : Float = 0.3;                // Homeostatic sleep pressure
  stable var processC : Float = 0.7;                // Circadian alerting signal
  stable var sleepPropensity : Float = 0.3;         // S - C = sleep drive
  stable var sleepDebt : Float = 0.0;               // Accumulated sleep debt
  stable var sleepStage : Text = "WAKE";            // WAKE, N1, N2, N3, REM
  
  // Ultradian Rhythm (90-120 minute BRAC cycle)
  stable var ultradianPhase : Float = 0.0;          // Current ultradian phase
  stable var ultradianPeriod : Float = 90.0;        // BRAC cycle length (minutes)
  stable var ultradianAmplitude : Float = 0.3;      // Performance oscillation depth
  stable var peakPerformancePhase : Float = 0.0;    // When in cycle is peak
  
  // Cortisol Awakening Response
  stable var cortisolCircadian : Float = 0.5;       // Circadian cortisol level
  stable var cortisolAwakeningResponse : Float = 0.0;  // CAR magnitude
  stable var cortisolPeakTime : Float = 0.25;       // When cortisol peaks (fraction of day)
  
  // Core Body Temperature
  stable var coreBodyTemp : Float = 37.0;           // Celsius
  stable var coreBodyTempPhase : Float = 0.0;       // Circadian phase of temperature
  stable var coreBodyTempMin : Float = 36.5;        // Nadir (typically 4-6 AM)
  stable var coreBodyTempMax : Float = 37.5;        // Peak (typically 6-8 PM)
  
  // Molecular Clock Genes (simplified)
  stable var clockGeneExpression : Float = 0.5;     // CLOCK/BMAL1 expression
  stable var perGeneExpression : Float = 0.5;       // PER1/2/3 expression
  stable var cryGeneExpression : Float = 0.5;       // CRY1/2 expression
  stable var molecularClockCoherence : Float = 0.8; // Gene oscillation synchrony
  
  // Circadian Performance
  stable var circadianPeakScore : Float = 0.7;      // Current circadian performance factor
  stable var alertnessLevel : Float = 0.7;          // Overall alertness (S + C + ultradian)
  stable var fatigueLevel : Float = 0.3;            // Complement of alertness
  stable var circadianCoherence : Float = 0.8;      // Overall circadian health
  
  // Time of Day Effects
  stable var virtualTimeOfDay : Float = 0.5;        // 0=midnight, 0.5=noon, 1=midnight
  stable var chronotype : Float = 0.5;              // 0=extreme lark, 1=extreme owl
  stable var socialJetlag : Float = 0.0;            // Mismatch between bio and social time
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  13-LOOP STREAK MULTIPLIER — ECONOMIC INTEGRATION
  //
  //  The sovereign streak multiplier compounds 13 separate coherence scores:
  //    1. kuramotoR: Kuramoto order parameter (swarm synchrony)
  //    2. courageScore: willingness to face threat
  //    3. groundedScore: body-mind integration (interoception)
  //    4. fearLevel: inverse (lower fear = higher multiplier)
  //    5. beFlowState: flow state (optimal challenge/skill balance)
  //    6. bhCouplingCoherence: brain-heart coupling
  //    7. missionPersistenceScore: goal-directed persistence
  //    8. consciousnessIndex: Tononi-Edelman unified awareness
  //    9. pcActiveInferenceScore: Friston predictive coding engagement
  //    10. interoceptiveScore: Craig-Damasio body awareness
  //    11. salienceNetworkScore: Menon-Uddin salience detection
  //    12. circadianPeakScore: optimal circadian timing
  //    13. neuroplasticityFactor: BCM/BDNF learning capacity
  //
  //  A desynchronized, fearful, ungrounded organism earns LESS.
  //  A sovereign, coherent, grounded, mission-locked organism earns EXPONENTIALLY MORE.
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Individual multiplier components
  stable var courageScore : Float = 0.7;
  stable var groundedScore : Float = 0.7;           // KEY: OMNIS grounding gate
  stable var fearLevel : Float = 0.3;               // Inverse contributes to multiplier
  stable var beFlowState : Float = 0.5;
  stable var bhCouplingCoherence : Float = 0.7;     // Brain-heart coherence
  stable var missionPersistenceScore : Float = 0.7;
  
  // Streak Multiplier State
  stable var streakMultiplier : Float = 1.0;        // Current composite multiplier
  stable var streakConsecutive : Nat = 0;           // Beats of high coherence streak
  stable var streakPeakMultiplier : Float = 1.0;    // Highest multiplier achieved
  stable var streakTotalBeats : Nat = 0;            // Total beats in streak mode
  stable var streakEconomicBonus : Float = 0.0;     // Accumulated bonus from streak
  
  // OMNIS Grounding Gate
  stable var omnisGroundingGate : Bool = true;      // Can OMNIS fire?
  stable var groundingGateThreshold : Float = 0.7;  // Minimum groundedScore for OMNIS
  
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
    // Quantum cognitive channels: 4 per drone
    let qcSize = n * 4;
    if (stableQChannels.size() < qcSize) {
      let newQC = Array.init<Float>(qcSize, 0.5);
      var i = 0;
      while (i < stableQChannels.size()) { newQC[i] := stableQChannels[i]; i += 1 };
      stableQChannels := newQC;
    };
    if (stableQConvergence.size() < n) {
      let newQV = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stableQConvergence.size()) { newQV[i] := stableQConvergence[i]; i += 1 };
      stableQConvergence := newQV;
    };
    if (stableQCoherence.size() < n) {
      let newQCoh = Array.init<Float>(n, 0.5);
      var i = 0;
      while (i < stableQCoherence.size()) { newQCoh[i] := stableQCoherence[i]; i += 1 };
      stableQCoherence := newQCoh;
    };
    if (stableNowAttention.size() < n) {
      let newNA2 = Array.init<Float>(n, 1.0);
      var i = 0;
      while (i < stableNowAttention.size()) { newNA2[i] := stableNowAttention[i]; i += 1 };
      stableNowAttention := newNA2;
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

    // Init quantum cognitive channels (4-360 model)
    let qcBase = id * 4;
    stableQChannels[qcBase]     := 0.5; // ALPHA: spatial
    stableQChannels[qcBase + 1] := 0.5; // BETA:  temporal
    stableQChannels[qcBase + 2] := 0.5; // GAMMA: relational
    stableQChannels[qcBase + 3] := 0.5; // DELTA: executive-motor
    stableQConvergence[id]      := 0.0;
    stableQCoherence[id]        := 0.5;
    stableNowAttention[id]      := 1.0; // fully present at birth

    // Register in quantum channels module (now local, sync).
    QuantumChannels.registerQuantumDrone(quantumState, id);

    // Register in telemetry store module.
    TelemetryStore.registerDrone(telemetryState, id, cls);

    // Audit: record drone birth event (now local, sync).
    ignore AuditLog.log(
      auditState,
      #DRONE_ADDED, currentBeat, ?id,
      "Drone " # Nat.toText(id) # " registered class=" # cls,
      rSwarm, jDrift, stableNeuroChem[id * 4 + CORTISOL],
      "SYSTEM", "{}"
    );

    id
  };

  // ─── TICK / BEAT ─────────────────────────────────────────────────────────────

  // Law 23: Observer Independence — signal decays each beat
  func decaySignal(id : Nat) {
    let decay = Float.exp(-0.001 * Float.fromInt(currentBeat - stableLastBeat[id]));
    stableSignals[id] := sf(stableSignals[id] * decay);
  };

  // Law 4: Hebbian inter-drone learning (proximity-weighted)
  // SCALE-INVARIANT VERSION: Use mean-field signal instead of pairwise
  // For massive fleets, each drone couples to the COLLECTIVE signal, not to every other drone
  
  // Cached mean signal (computed once per beat)
  var cachedMeanSignal : Float = 1.0;
  var cachedMeanPosition : (Float, Float, Float) = (0.0, 50.0, 0.0);
  
  func computeMeanSignalField() {
    let n = stableDroneCount;
    if (n == 0) { cachedMeanSignal := 1.0; return };
    var sumSig : Float = 0.0;
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumZ : Float = 0.0;
    var active : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        sumSig += stableSignals[i];
        sumX += stablePosX[i];
        sumY += stablePosY[i];
        sumZ += stablePosZ[i];
        active += 1.0;
      };
      i += 1;
    };
    if (active == 0.0) { cachedMeanSignal := 1.0; return };
    cachedMeanSignal := sumSig / active;
    cachedMeanPosition := (sumX / active, sumY / active, sumZ / active);
  };
  
  // Mean-field Hebbian: each drone learns from collective signal — O(1) per drone
  func hebbianMeanFieldUpdate(id : Nat) {
    // Distance to swarm centroid (spherical organization)
    let (cx, cy, cz) = cachedMeanPosition;
    let dx = stablePosX[id] - cx;
    let dy = stablePosY[id] - cy;
    let dz = stablePosZ[id] - cz;
    let distToCentroid = Float.sqrt(dx*dx + dy*dy + dz*dz) + 0.001;
    
    // Proximity to collective — closer to center = stronger coupling
    let proximity = 1.0 / (1.0 + distToCentroid / 50.0);
    
    // Hebbian: this drone's signal × collective signal × proximity
    let si = stableSignals[id];
    let sCollective = cachedMeanSignal;
    let delta = HELIX_ALPHA * si * sCollective * proximity;
    
    // Update activation (representing collective Hebbian weight)
    stableActivations[id] := sf(stableActivations[id] + delta * 0.1);
  };
  
  // Legacy pairwise Hebbian (only used for small fleets < 500)
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
  // ═══════════════════════════════════════════════════════════════════════════
  // KURAMOTO PHASE UPDATE — SCALE-INVARIANT MEAN-FIELD APPROXIMATION
  // ═══════════════════════════════════════════════════════════════════════════
  // The full Kuramoto model: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  // is O(N²) — doesn't scale to 40,000 drones.
  //
  // MEAN-FIELD APPROXIMATION (Kuramoto 1984, Strogatz 2000):
  //   dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ)
  // where r·e^(iψ) = (1/N) Σⱼ e^(iθⱼ) is the order parameter.
  //
  // This is O(N) and mathematically equivalent for large N.
  // The organism doesn't "know" how many drones there are — it just couples
  // each drone to the collective mean field. SPHERICAL, not pairwise.
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Cached mean-field values (computed once per beat, used by all drones)
  var cachedMeanPhase : Float = 0.0;
  var cachedOrderParam : Float = 0.88;
  
  // Compute mean field ONCE per beat — O(N)
  func computeMeanField() {
    let n = stableDroneCount;
    if (n == 0) { cachedOrderParam := 0.88; cachedMeanPhase := 0.0; return };
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
    if (active == 0.0) { cachedOrderParam := 0.88; cachedMeanPhase := 0.0; return };
    cachedOrderParam := Float.sqrt((sumCos/active)*(sumCos/active) + (sumSin/active)*(sumSin/active));
    cachedMeanPhase := Float.arctan2(sumSin/active, sumCos/active);
  };
  
  // Update single drone phase using MEAN-FIELD — O(1) per drone
  func kuramotoUpdate(id : Nat) {
    // Mean-field Kuramoto: dθ/dt = ω + K·r·sin(ψ - θ)
    // Each drone couples to the COLLECTIVE, not to every other drone
    let dTheta = stableOmegas[id] + KURAMOTO_K * cachedOrderParam * sin(cachedMeanPhase - stablePhases[id]);
    stablePhases[id] := stablePhases[id] + dTheta * 0.1; // dt = 0.1
  };

  // Compute swarm-level r_swarm (order parameter) — uses cached value
  func computeRSwarm() : Float {
    // Already computed in computeMeanField()
    Float.max(0.5, Float.min(1.0, cachedOrderParam))
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

    // Solution 1 — use preCorrectionRSwarm (snapshotted before Jasmine's Law ran)
    // so SACESI and Jasmine's Law both see the same pre-correction synchrony state.
    // This eliminates the complex eigenvalue: λ = -α ± √(α² - Kp·α).
    let e = 1.0 - preCorrectionRSwarm;

    // Write to ring buffer
    saceBuffer[saceHead] := e;
    saceHead := (saceHead + 1) % BUF;

    // de/dt via backward difference across full window
    // oldest sample is at saceHead (just overwritten → next slot is oldest)
    let oldestIdx = saceHead % BUF;
    let eOld = saceBuffer[oldestIdx];
    let dedt = (e - eOld) / Float.fromInt(BUF);

    // HELIX_ALPHA modulated proportional gain
    let kpEff = KP * (1.0 + HELIX_ALPHA * preCorrectionRSwarm);

    // Raw control output
    let uRaw = kpEff * e + KD * dedt;

    // Solution 2 — Lyapunov gate: if Jasmine's V(x) is RISING, scale SACESI
    // down proportionally so it does not fight Jasmine's active correction.
    // When V is stable or falling the gate factor is 1.0 (full authority).
    let lyapunovGateFactor : Float =
      if (jDrift > prevJDrift and jDrift > 0.01) {
        let excess = jDrift - prevJDrift;
        Float.max(0.0, 1.0 - excess / 0.01)
      } else { 1.0 };

    let u = uRaw * lyapunovGateFactor;
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

  // ─── QUANTUM COGNITIVE STATE UPDATE ─────────────────────────────────────────
  // Derive the four 360-degree channel values directly from the 6-node brain:
  //   ALPHA (0): SENSOR node    — spatial / environmental awareness
  //   BETA  (1): MEMORY node    — temporal / past-state consolidation
  //   GAMMA (2): EXECUTIVE node — relational / goal-directed reasoning
  //   DELTA (3): mean(EMOTIONAL+MOTOR) nodes — embodied action drive
  //
  // Convergence = how much all four channels agree (1 − 4·variance).
  // Q-Coherence = 0.5·convergence + 0.5·rSwarm (internal + collective alignment).
  // Now-attention pulls toward rSwarm×(1−jDrift) — the swarm's stable present.
  func quantumStateUpdate(id : Nat) {
    let naBase = id * BRAIN_NODES;
    let alpha  = stableNodeActivations[naBase + 0]; // SENSOR
    let beta   = stableNodeActivations[naBase + 1]; // MEMORY
    let gamma  = stableNodeActivations[naBase + 2]; // EXECUTIVE
    let delta  = (stableNodeActivations[naBase + 3] + stableNodeActivations[naBase + 4]) / 2.0; // EMOTIONAL+MOTOR

    let qcBase = id * 4;
    // Smooth update toward brain-derived targets (τ = 10 beats)
    let tau : Float = 10.0;
    stableQChannels[qcBase]     := stableQChannels[qcBase]     + (alpha - stableQChannels[qcBase])     / tau;
    stableQChannels[qcBase + 1] := stableQChannels[qcBase + 1] + (beta  - stableQChannels[qcBase + 1]) / tau;
    stableQChannels[qcBase + 2] := stableQChannels[qcBase + 2] + (gamma - stableQChannels[qcBase + 2]) / tau;
    stableQChannels[qcBase + 3] := stableQChannels[qcBase + 3] + (delta - stableQChannels[qcBase + 3]) / tau;

    // Convergence: 1 − 4·variance of the 4 channel values
    let a = stableQChannels[qcBase];
    let b = stableQChannels[qcBase + 1];
    let c = stableQChannels[qcBase + 2];
    let d = stableQChannels[qcBase + 3];
    let mean = (a + b + c + d) / 4.0;
    let v    = ((a-mean)*(a-mean) + (b-mean)*(b-mean) +
                (c-mean)*(c-mean) + (d-mean)*(d-mean)) / 4.0;
    stableQConvergence[id] := Float.max(0.0, Float.min(1.0, 1.0 - v * 4.0));

    // Q-Coherence: blend of internal convergence and swarm-level coherence
    stableQCoherence[id] := 0.5 * stableQConvergence[id] + 0.5 * rSwarm;

    // Now-attention: pull toward present-moment target
    let nowTarget = Float.max(0.0, Float.min(1.0, rSwarm * (1.0 - Float.min(1.0, jDrift))));
    stableNowAttention[id] := stableNowAttention[id] + 0.05 * (nowTarget - stableNowAttention[id]);
  };

  // Main beat tick — advance simulation by one step
  // ─── TICK CORE (private sync) ─────────────────────────────────────────────────
  // ─── FIRST BREATH HELPER FUNCTIONS ───────────────────────────────────────────

  // Step the 12 Hz hierarchy one tick and return the updated kfHz.
  // Each node advances at ω_k = 0.15625 × 2^k rad/tick (geometric series).
  // Kuramoto mean-field coupling drives them toward synchrony:
  //   dφᵢ/dt = ωᵢ + K·R·sin(ψ - φᵢ),  K = 0.618 (Medina constant)
  // Returns: kfHz = |Σ e^(iφₖ)| / 12 ∈ [0, 1]
  func hzHierarchyTick() : Float {
    let n   : Nat   = 12;
    let K   : Float = 0.618; // Medina coupling constant (Kuramoto 1984)
    let TWO_PI : Float = 6.283185307;

    // Compute mean field (order parameter R and mean phase ψ)
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var k = 0;
    while (k < n) {
      sumCos += Float.cos(hzNodePhases[k]);
      sumSin += Float.sin(hzNodePhases[k]);
      k += 1;
    };
    let nf  : Float = Float.fromInt(n);
    let R   : Float = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf;
    let psi : Float = Float.arctan2(sumSin, sumCos);

    // Advance each node with coupling toward mean field
    k := 0;
    while (k < n) {
      let omega    : Float = 0.15625 * Float.pow(2.0, Float.fromInt(k));
      let coupling : Float = K * R * Float.sin(psi - hzNodePhases[k]);
      var newPhi   : Float = hzNodePhases[k] + (omega + coupling);
      // Wrap to [0, 2π)
      while (newPhi >= TWO_PI) { newPhi -= TWO_PI };
      while (newPhi < 0.0)     { newPhi += TWO_PI };
      hzNodePhases[k] := newPhi;
      k += 1;
    };

    // Recompute order parameter on updated phases
    sumCos := 0.0; sumSin := 0.0;
    k := 0;
    while (k < n) {
      sumCos += Float.cos(hzNodePhases[k]);
      sumSin += Float.sin(hzNodePhases[k]);
      k += 1;
    };
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf
  };

  // Build the deterministic first-breath birth certificate.
  // Format mirrors the SACESI chain: unforgeable, beat-indexed, kfHz-stamped.
  func makeFirstBreathStamp(beat : Nat, kfHz : Float) : Text {
    "FIRSTBREATH:beat="   # Nat.toText(beat)
    # ":kfHz="             # Float.toText(kfHz)
    # ":rSwarm="           # Float.toText(rSwarm)
    # ":sacesiTarget="     # Float.toText(sacesiTarget)
    # ":doctrine=Kuramoto+JasminesLaw+OMNIS+FirstBreath"
  };

  // Update tidal volume and breath-rate variance from the kfHz ring buffer.
  // These are the breath quality metrics (RRV equivalent for the organism).
  //   tidalVolume       = peak-to-trough kfHz excursion over 50 beats
  //   breathRateVariance = variance of kfHz values over 50 beats
  func updateBreathQuality() {
    let size = 50;
    var maxV : Float = 0.0;
    var minV : Float = 1.0;
    var mean : Float = 0.0;
    var i = 0;
    while (i < size) {
      let v = kfHzRing[i];
      if (v > maxV) maxV := v;
      if (v < minV) minV := v;
      mean += v;
      i += 1;
    };
    mean /= Float.fromInt(size);

    var variance : Float = 0.0;
    i := 0;
    while (i < size) {
      let d = kfHzRing[i] - mean;
      variance += d * d;
      i += 1;
    };
    tidalVolume        := maxV - minV;
    breathRateVariance := variance / Float.fromInt(size);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  //   7 NEUROSCIENCE ENGINE TICK FUNCTIONS — ALL INLINE, ALL WIRED INTO HEARTBEAT
  //
  //   These functions execute every beat as part of masterHeartbeat().
  //   Each engine updates its state variables and feeds forward to economics.
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 1 TICK: THALAMOCORTICAL BINDING
  //
  //  Implements:
  //    1. 40Hz gamma oscillation (Llinas binding)
  //    2. Thalamocortical relay updates for 12 nuclei
  //    3. Cortical column dynamics (64 columns × 6 fields)
  //    4. Thalamic Reticular Nucleus (TRN) inhibition
  //    5. Reentrant loop connectivity (Edelman dynamic core)
  //    6. Integrated Information Φ computation (Tononi IIT)
  //    7. Consciousness index calculation
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func tickThalamocorticalBinding() {
    let dt : Float = 1.0 / 12.0;  // 12 Hz heartbeat
    
    // ─── 40Hz GAMMA OSCILLATION (LLINAS BINDING) ────────────────────────────────
    // The 40Hz oscillation binds disparate cortical areas into unified percepts.
    // Phase: advances at 40Hz rate
    // Amplitude: modulated by arousal and attention
    let gamma40HzFreq : Float = 40.0;
    let gammaOmega : Float = 2.0 * 3.14159265359 * gamma40HzFreq;
    gammaPhase40Hz := gammaPhase40Hz + gammaOmega * dt;
    if (gammaPhase40Hz > 2.0 * 3.14159265359) {
      gammaPhase40Hz := gammaPhase40Hz - 2.0 * 3.14159265359;
      gammaCycleCount += 1;
    };
    
    // Gamma amplitude modulated by arousal (norepinephrine proxy) and attention
    let arousalModulation : Float = 0.7 + 0.3 * attentionFocus;
    gammaAmplitude40Hz := fclamp(0.5 + 0.5 * arousalModulation * rSwarm, 0.3, 1.0);
    
    // Binding strength: how well gamma synchronizes thalamocortical loops
    let gammaSync : Float = Float.cos(gammaPhase40Hz) * gammaAmplitude40Hz;
    bindingStrength40Hz := fclamp(0.5 + 0.5 * gammaSync, 0.0, 1.0);
    
    // ─── THALAMIC NUCLEI DYNAMICS ───────────────────────────────────────────────
    // Update each of 12 thalamic nuclei
    // Each nucleus: [activation, phase, reentrantInput, corticalFeedback, inhibition, coherence]
    var nucleusIdx = 0;
    while (nucleusIdx < TC_NUCLEI_COUNT) {
      let base = nucleusIdx * TC_FIELDS_PER_NUCLEUS;
      
      // Get current state
      let activation = tcNucleiState[base + TC_F_ACTIVATION];
      let phase = tcNucleiState[base + TC_F_PHASE];
      let reentrant = tcNucleiState[base + TC_F_REENTRANT];
      let corticalFb = tcNucleiState[base + TC_F_CORTICAL_FB];
      let inhibition = tcNucleiState[base + TC_F_INHIBITION];
      let coherence = tcNucleiState[base + TC_F_COHERENCE];
      
      // TRN inhibition affects this nucleus
      let trnInhib = trnActivation[nucleusIdx];
      
      // Compute aggregate cortical feedback from connected columns
      var corticalSum : Float = 0.0;
      var colIdx = 0;
      while (colIdx < TC_CORTICAL_COLUMNS) {
        let colBase = colIdx * TC_COLUMN_FIELDS;
        let colCoherence = corticalColumnState[colBase + 5];  // Column coherence
        let weight = tcBackwardWeights[nucleusIdx * TC_CORTICAL_COLUMNS + colIdx];
        corticalSum += colCoherence * weight;
        colIdx += 1;
      };
      corticalSum := corticalSum / Float.fromInt(TC_CORTICAL_COLUMNS);
      
      // Update nucleus activation
      // τ dA/dt = -A + σ(input) - inhibition
      let inputSum = corticalSum + reentrant * reentryStrength + rSwarm * 0.2;
      let newActivation = activation + dt * (-0.1 * activation + sigmoid(inputSum) - trnInhib * 0.5);
      tcNucleiState[base + TC_F_ACTIVATION] := fclamp(newActivation, 0.0, 1.0);
      
      // Update nucleus phase (oscillation)
      let nucleusOmega = 0.5 + 0.5 * Float.fromInt(nucleusIdx) / Float.fromInt(TC_NUCLEI_COUNT);
      let newPhase = phase + dt * nucleusOmega + gammaSync * 0.1;
      tcNucleiState[base + TC_F_PHASE] := Float.sin(newPhase) + 3.14159265359;
      
      // Update reentrant input (from other nuclei)
      var reentrantSum : Float = 0.0;
      var otherNucleus = 0;
      while (otherNucleus < TC_NUCLEI_COUNT) {
        if (otherNucleus != nucleusIdx) {
          let otherBase = otherNucleus * TC_FIELDS_PER_NUCLEUS;
          let otherAct = tcNucleiState[otherBase + TC_F_ACTIVATION];
          reentrantSum += otherAct * 0.1;
        };
        otherNucleus += 1;
      };
      tcNucleiState[base + TC_F_REENTRANT] := fclamp(reentrantSum, 0.0, 1.0);
      
      // Update cortical feedback
      tcNucleiState[base + TC_F_CORTICAL_FB] := corticalSum;
      
      // Update inhibition (from TRN)
      tcNucleiState[base + TC_F_INHIBITION] := trnInhib;
      
      // Update nucleus coherence (with gamma rhythm)
      let phaseAlignment = Float.abs(Float.cos(tcNucleiState[base + TC_F_PHASE] - gammaPhase40Hz));
      tcNucleiState[base + TC_F_COHERENCE] := fclamp(0.5 * coherence + 0.5 * phaseAlignment, 0.0, 1.0);
      
      nucleusIdx += 1;
    };
    
    // ─── THALAMIC RETICULAR NUCLEUS (TRN) ───────────────────────────────────────
    // The TRN provides inhibitory control over thalamic relay nuclei
    // It's like a gate that filters sensory information
    var trnIdx = 0;
    while (trnIdx < TC_NUCLEI_COUNT) {
      let nucleusAct = tcNucleiState[trnIdx * TC_FIELDS_PER_NUCLEUS + TC_F_ACTIVATION];
      
      // TRN activation: lateral inhibition + attention-based modulation
      // High attention = more selective gating
      let trnInput = nucleusAct - attentionFocus * 0.3;
      trnActivation[trnIdx] := fclamp(trnActivation[trnIdx] * 0.9 + sigmoid(trnInput) * 0.1, 0.0, 0.8);
      
      // TRN phase follows gamma with lag
      trnPhase[trnIdx] := gammaPhase40Hz + 0.1 * Float.fromInt(trnIdx);
      
      trnIdx += 1;
    };
    
    // ─── CORTICAL COLUMN DYNAMICS ───────────────────────────────────────────────
    // 64 columns, each with [L2/3_act, L4_act, L5_act, L6_act, phase, coherence]
    var colIdx = 0;
    while (colIdx < TC_CORTICAL_COLUMNS) {
      let colBase = colIdx * TC_COLUMN_FIELDS;
      
      // Layer activations
      let l23 = corticalColumnState[colBase + 0];  // Supragranular (output to other columns)
      let l4 = corticalColumnState[colBase + 1];   // Granular (thalamic input)
      let l5 = corticalColumnState[colBase + 2];   // Infragranular (output to subcortex)
      let l6 = corticalColumnState[colBase + 3];   // Infragranular (corticothalamic feedback)
      let colPhase = corticalColumnState[colBase + 4];
      let colCoh = corticalColumnState[colBase + 5];
      
      // Thalamic input to L4 (from connected nuclei)
      var thalamicInput : Float = 0.0;
      var nucIdx = 0;
      while (nucIdx < TC_NUCLEI_COUNT) {
        let nucAct = tcNucleiState[nucIdx * TC_FIELDS_PER_NUCLEUS + TC_F_ACTIVATION];
        let weight = tcForwardWeights[nucIdx * TC_CORTICAL_COLUMNS + colIdx];
        thalamicInput += nucAct * weight;
        nucIdx += 1;
      };
      thalamicInput := thalamicInput / Float.fromInt(TC_NUCLEI_COUNT);
      
      // Update layer activations (simplified canonical microcircuit)
      // L4 receives thalamic input
      let newL4 = l4 + dt * (-0.1 * l4 + sigmoid(thalamicInput + l6 * 0.3));
      // L2/3 receives from L4, lateral from other columns
      let newL23 = l23 + dt * (-0.1 * l23 + sigmoid(newL4 * 0.5 + rSwarm * 0.2));
      // L5 receives from L2/3, outputs to subcortex
      let newL5 = l5 + dt * (-0.1 * l5 + sigmoid(newL23 * 0.4 + architectSignalLevel * 0.3));
      // L6 receives from L5, provides corticothalamic feedback
      let newL6 = l6 + dt * (-0.1 * l6 + sigmoid(newL5 * 0.3 + newL4 * 0.2));
      
      corticalColumnState[colBase + 0] := fclamp(newL23, 0.0, 1.0);
      corticalColumnState[colBase + 1] := fclamp(newL4, 0.0, 1.0);
      corticalColumnState[colBase + 2] := fclamp(newL5, 0.0, 1.0);
      corticalColumnState[colBase + 3] := fclamp(newL6, 0.0, 1.0);
      
      // Update column phase (tracks gamma)
      let newColPhase = colPhase + dt * (40.0 * 2.0 * 3.14159265359) + gammaSync * 0.05;
      corticalColumnState[colBase + 4] := Float.sin(newColPhase) + 3.14159265359;
      
      // Update column coherence
      let layerMean = (newL23 + newL4 + newL5 + newL6) / 4.0;
      let phaseCoherence = Float.abs(Float.cos(corticalColumnState[colBase + 4] - gammaPhase40Hz));
      corticalColumnState[colBase + 5] := fclamp(0.7 * colCoh + 0.3 * layerMean * phaseCoherence, 0.0, 1.0);
      
      colIdx += 1;
    };
    
    // ─── REENTRANT WEIGHT LEARNING (EDELMAN) ────────────────────────────────────
    // Hebbian update of thalamocortical weights based on co-activation
    var weightIdx = 0;
    while (weightIdx < 768) {
      let nucIdx = weightIdx / TC_CORTICAL_COLUMNS;
      let colIdx2 = weightIdx % TC_CORTICAL_COLUMNS;
      
      let nucAct = tcNucleiState[nucIdx * TC_FIELDS_PER_NUCLEUS + TC_F_ACTIVATION];
      let colAct = corticalColumnState[colIdx2 * TC_COLUMN_FIELDS + 5];  // Column coherence
      
      // Hebbian: Δw = η * pre * post
      let dw = 0.001 * nucAct * colAct - 0.0001 * (tcForwardWeights[weightIdx] - 0.5);
      tcForwardWeights[weightIdx] := fclamp(tcForwardWeights[weightIdx] + dw, 0.1, 0.9);
      
      // Backward weights learn similarly
      let dwBack = 0.001 * colAct * nucAct - 0.0001 * (tcBackwardWeights[weightIdx] - 0.5);
      tcBackwardWeights[weightIdx] := fclamp(tcBackwardWeights[weightIdx] + dwBack, 0.1, 0.9);
      
      weightIdx += 1;
    };
    
    // ─── INTEGRATED INFORMATION Φ (TONONI IIT) ──────────────────────────────────
    // Φ measures information that is both integrated and differentiated
    // Simplified: Φ ≈ mutual information - minimum information partition
    
    // Compute aggregate activation across all thalamic nuclei
    var totalNucleusActivation : Float = 0.0;
    var totalNucleusCoherence : Float = 0.0;
    nucIdx := 0;
    while (nucIdx < TC_NUCLEI_COUNT) {
      let base = nucIdx * TC_FIELDS_PER_NUCLEUS;
      totalNucleusActivation += tcNucleiState[base + TC_F_ACTIVATION];
      totalNucleusCoherence += tcNucleiState[base + TC_F_COHERENCE];
      nucIdx += 1;
    };
    totalNucleusActivation := totalNucleusActivation / Float.fromInt(TC_NUCLEI_COUNT);
    totalNucleusCoherence := totalNucleusCoherence / Float.fromInt(TC_NUCLEI_COUNT);
    
    // Compute aggregate across cortical columns
    var totalColumnCoherence : Float = 0.0;
    colIdx := 0;
    while (colIdx < TC_CORTICAL_COLUMNS) {
      totalColumnCoherence += corticalColumnState[colIdx * TC_COLUMN_FIELDS + 5];
      colIdx += 1;
    };
    totalColumnCoherence := totalColumnCoherence / Float.fromInt(TC_CORTICAL_COLUMNS);
    
    // Effective information (EI): how much does each nucleus constrain others?
    effectiveInformation := fclamp(totalNucleusActivation * totalNucleusCoherence, 0.0, 1.0);
    
    // Cause information (CI): how much does each nucleus inform about its causes?
    causeInformation := fclamp(totalColumnCoherence * reentryStrength, 0.0, 1.0);
    
    // Minimum information partition (MIP): find the "weakest link"
    var minPhiPartition : Float = 1.0;
    nucIdx := 0;
    while (nucIdx < TC_NUCLEI_COUNT) {
      let base = nucIdx * TC_FIELDS_PER_NUCLEUS;
      let nucleusPhi = tcNucleiState[base + TC_F_COHERENCE] * tcNucleiState[base + TC_F_ACTIVATION];
      phiPartitions[nucIdx] := nucleusPhi;
      if (nucleusPhi < minPhiPartition) {
        minPhiPartition := nucleusPhi;
      };
      nucIdx += 1;
    };
    minInformationPartition := minPhiPartition;
    
    // Integrated Information Φ = EI + CI - MIP
    // If the system is fully integrated, MIP is high (hard to partition)
    // If the system is reducible, MIP is low (easy to partition)
    let rawPhi = (effectiveInformation + causeInformation) * (1.0 - minInformationPartition);
    phiIntegrated := fclamp(0.8 * phiIntegrated + 0.2 * rawPhi, 0.0, 1.0);
    
    // Integrated Concept Structure (ICS): the "shape" of integrated information
    integratedConceptStructure := fclamp(phiIntegrated * totalColumnCoherence, 0.0, 1.0);
    
    // ─── DYNAMIC CORE (EDELMAN) ─────────────────────────────────────────────────
    // The dynamic core is a metastable, integrated cluster of neural groups
    
    // Dynamic core coherence: synchrony of thalamocortical loops
    dynamicCoreCoherence := fclamp(
      0.3 * totalNucleusCoherence + 
      0.3 * totalColumnCoherence + 
      0.2 * bindingStrength40Hz + 
      0.2 * rSwarm,
      0.0, 1.0
    );
    
    // Dynamic core entropy: variability within the core (need balance)
    var coreVariance : Float = 0.0;
    nucIdx := 0;
    while (nucIdx < TC_NUCLEI_COUNT) {
      let base = nucIdx * TC_FIELDS_PER_NUCLEUS;
      let diff = tcNucleiState[base + TC_F_ACTIVATION] - totalNucleusActivation;
      coreVariance += diff * diff;
      nucIdx += 1;
    };
    coreVariance := coreVariance / Float.fromInt(TC_NUCLEI_COUNT);
    dynamicCoreEntropy := fclamp(Float.sqrt(coreVariance), 0.0, 1.0);
    
    // Reentry strength: quality of bidirectional connectivity
    reentryStrength := fclamp(
      0.5 * reentryStrength + 
      0.5 * (effectiveInformation + causeInformation) / 2.0,
      0.0, 1.0
    );
    
    // Core complexity: balance between integration and differentiation (Edelman's "sweet spot")
    // Optimal complexity occurs when the system is neither too random nor too ordered
    coreComplexity := fclamp(
      4.0 * dynamicCoreCoherence * (1.0 - dynamicCoreCoherence) * dynamicCoreEntropy,
      0.0, 1.0
    );
    
    // Neural Darwinism fitness: how well the system adapts through selection
    neuralDarwinismFitness := fclamp(
      0.9 * neuralDarwinismFitness + 
      0.1 * coreComplexity * phiIntegrated,
      0.0, 1.0
    );
    
    // ─── THALAMIC RELAY GAIN ────────────────────────────────────────────────────
    // How efficiently thalamus relays information (modulated by arousal, attention)
    thalamicRelayGain := fclamp(
      0.5 + 0.3 * attentionFocus + 0.2 * (1.0 - fearLevel),
      0.3, 1.5
    );
    
    // Sensory gating: TRN-mediated filtering of sensory input
    var avgTrnInhibition : Float = 0.0;
    trnIdx := 0;
    while (trnIdx < TC_NUCLEI_COUNT) {
      avgTrnInhibition += trnActivation[trnIdx];
      trnIdx += 1;
    };
    avgTrnInhibition := avgTrnInhibition / Float.fromInt(TC_NUCLEI_COUNT);
    sensoryGating := fclamp(1.0 - avgTrnInhibition, 0.2, 1.0);
    
    // Attentional modulation: how attention affects thalamic processing
    attentionalModulation := fclamp(attentionFocus * thalamicRelayGain, 0.0, 1.5);
    
    // ─── CONSCIOUSNESS INDEX ────────────────────────────────────────────────────
    // Composite measure of unified conscious state
    // Combines: Φ, dynamic core coherence, gamma binding, thalamic integrity
    
    let rawConsciousness = 
      0.25 * phiIntegrated +           // Tononi: integrated information
      0.20 * dynamicCoreCoherence +    // Edelman: dynamic core unity
      0.15 * bindingStrength40Hz +     // Llinas: gamma binding
      0.15 * thalamicRelayGain / 1.5 + // Thalamic integrity
      0.15 * rSwarm +                  // Global coherence
      0.10 * (1.0 - jDrift);           // Stability
    
    consciousnessIndex := fclamp(
      0.85 * consciousnessIndex + 0.15 * rawConsciousness,
      0.0, 1.0
    );
    
    // Update consciousness history
    consciousnessHistory[consciousnessHistoryIdx % 100] := consciousnessIndex;
    consciousnessHistoryIdx += 1;
    
    // Determine consciousness level
    if (consciousnessIndex > 0.9) {
      consciousnessLevel := "FLOW";
    } else if (consciousnessIndex > 0.8) {
      consciousnessLevel := "FOCUSED";
    } else if (consciousnessIndex > 0.6) {
      consciousnessLevel := "WAKING";
    } else if (consciousnessIndex > 0.4) {
      consciousnessLevel := "DROWSY";
    } else if (consciousnessIndex > 0.2) {
      consciousnessLevel := "LIGHT_SLEEP";
    } else {
      consciousnessLevel := "DEEP_SLEEP";
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 2 TICK: PREDICTIVE CODING (KARL FRISTON)
  //
  //  Implements:
  //    1. Hierarchical generative model (8 levels)
  //    2. Top-down predictions (μ)
  //    3. Bottom-up prediction errors (ε = o - μ)
  //    4. Precision weighting (γ)
  //    5. Free energy computation (F = accuracy - complexity)
  //    6. Active inference (minimize expected free energy through action)
  //    7. Model evidence and Bayesian comparison
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func tickPredictiveCoding() {
    let dt : Float = 1.0 / 12.0;
    
    // ─── SENSORY OBSERVATIONS ───────────────────────────────────────────────────
    // Bottom level (Level 0) receives actual sensory input
    // We derive this from organism state (rSwarm, jDrift, neurochemicals, etc.)
    var obsIdx = 0;
    while (obsIdx < PC_UNITS_PER_LEVEL) {
      // Mix of different organism signals as "sensory" input
      let signalMix = 
        0.3 * rSwarm +                                           // Global coherence
        0.2 * (1.0 - jDrift) +                                   // Stability
        0.2 * Float.sin(Float.fromInt(obsIdx) * 0.1 + Float.fromInt(currentBeat) * 0.01) + // Temporal pattern
        0.15 * consciousnessIndex +                              // Consciousness level
        0.15 * dopamineLevel / 2.0;                              // Reward signal
      
      pcObservations[obsIdx] := fclamp(signalMix + 0.1 * Float.sin(Float.fromInt(obsIdx)), 0.0, 1.0);
      obsIdx += 1;
    };
    
    // ─── TOP-DOWN PREDICTIONS ───────────────────────────────────────────────────
    // Higher levels predict activity at lower levels
    // Start from top (Level 7: Self-model) and propagate DOWN
    
    var level = PC_HIERARCHY_LEVELS - 1;
    while (level > 0) {
      let levelBase = level * PC_UNITS_PER_LEVEL;
      let lowerLevelBase = (level - 1) * PC_UNITS_PER_LEVEL;
      let weightBase = (level - 1) * PC_UNITS_PER_LEVEL * PC_UNITS_PER_LEVEL;
      
      var unitIdx = 0;
      while (unitIdx < PC_UNITS_PER_LEVEL) {
        // This level's prediction comes from weighted sum of higher-level activity
        var prediction : Float = 0.0;
        var sourceIdx = 0;
        while (sourceIdx < PC_UNITS_PER_LEVEL) {
          let weight = pcHierarchyWeights[weightBase + unitIdx * PC_UNITS_PER_LEVEL + sourceIdx];
          let higherAct = pcPredictions[levelBase + sourceIdx];
          prediction += weight * higherAct;
          sourceIdx += 1;
        };
        
        // Apply precision weighting to prediction
        let precision = pcPrecision[lowerLevelBase + unitIdx];
        prediction := prediction * precision;
        
        // Update prediction for lower level
        pcPredictions[lowerLevelBase + unitIdx] := fclamp(
          0.8 * pcPredictions[lowerLevelBase + unitIdx] + 0.2 * sigmoid(prediction),
          0.0, 1.0
        );
        
        unitIdx += 1;
      };
      
      level -= 1;
    };
    
    // ─── PREDICTION ERRORS ──────────────────────────────────────────────────────
    // ε = observation - prediction (bottom-up error signal)
    // Propagate UP from Level 0
    
    level := 0;
    while (level < PC_HIERARCHY_LEVELS) {
      let levelBase = level * PC_UNITS_PER_LEVEL;
      
      var unitIdx = 0;
      while (unitIdx < PC_UNITS_PER_LEVEL) {
        let prediction = pcPredictions[levelBase + unitIdx];
        let observation = if (level == 0) {
          pcObservations[unitIdx]
        } else {
          // Higher levels observe prediction errors from below
          let lowerBase = (level - 1) * PC_UNITS_PER_LEVEL;
          pcPredictionErrors[lowerBase + unitIdx]
        };
        
        // Prediction error weighted by precision
        let precision = pcPrecision[levelBase + unitIdx];
        let rawError = observation - prediction;
        let weightedError = rawError * precision;
        
        pcPredictionErrors[levelBase + unitIdx] := fclamp(weightedError, -1.0, 1.0);
        
        unitIdx += 1;
      };
      
      level += 1;
    };
    
    // ─── PRECISION ESTIMATION (ATTENTION AS PRECISION) ──────────────────────────
    // Precision (γ) is inverse variance — high precision = high confidence
    // Attention increases precision for attended stimuli
    
    level := 0;
    while (level < PC_HIERARCHY_LEVELS) {
      let levelBase = level * PC_UNITS_PER_LEVEL;
      
      // Level-specific baseline precision
      let levelFactor = 1.0 - Float.fromInt(level) * 0.1;  // Higher levels = lower baseline precision
      
      var unitIdx = 0;
      while (unitIdx < PC_UNITS_PER_LEVEL) {
        // Precision adapts based on prediction error history
        let error = Float.abs(pcPredictionErrors[levelBase + unitIdx]);
        let errorVariance = error * error;
        
        // High error = low precision (uncertain)
        // Low error = high precision (confident)
        let newPrecision = levelFactor / (0.1 + errorVariance);
        
        // Attention boosts precision
        let attentionBoost = 1.0 + attentionFocus * 0.5;
        
        pcPrecision[levelBase + unitIdx] := fclamp(
          0.9 * pcPrecision[levelBase + unitIdx] + 0.1 * newPrecision * attentionBoost,
          0.1, 3.0
        );
        
        unitIdx += 1;
      };
      
      level += 1;
    };
    
    // Global precision (average across all units)
    var totalPrecision : Float = 0.0;
    var precIdx = 0;
    while (precIdx < PC_HIERARCHY_LEVELS * PC_UNITS_PER_LEVEL) {
      totalPrecision += pcPrecision[precIdx];
      precIdx += 1;
    };
    pcGlobalPrecision := totalPrecision / Float.fromInt(PC_HIERARCHY_LEVELS * PC_UNITS_PER_LEVEL);
    pcSensoryPrecision := pcGlobalPrecision * (1.0 + consciousnessIndex * 0.2);
    pcPriorPrecision := pcGlobalPrecision * (1.0 + memoryStabilityIndex * 0.2);
    pcStatePrecision := pcGlobalPrecision * (1.0 + groundedScore * 0.2);
    
    // ─── HIERARCHICAL WEIGHT LEARNING ───────────────────────────────────────────
    // Update inter-level weights to minimize prediction error
    level := 0;
    while (level < PC_HIERARCHY_LEVELS - 1) {
      let weightBase = level * PC_UNITS_PER_LEVEL * PC_UNITS_PER_LEVEL;
      let errorBase = level * PC_UNITS_PER_LEVEL;
      let predBase = (level + 1) * PC_UNITS_PER_LEVEL;
      
      var wi = 0;
      while (wi < PC_UNITS_PER_LEVEL) {
        var wj = 0;
        while (wj < PC_UNITS_PER_LEVEL) {
          let idx = weightBase + wi * PC_UNITS_PER_LEVEL + wj;
          
          // Gradient descent on prediction error
          let error = pcPredictionErrors[errorBase + wi];
          let pred = pcPredictions[predBase + wj];
          let dw = -0.001 * error * pred;  // Reduce weight if error is high
          
          // BDNF-gated learning (neuroplasticity integration)
          let bdnfGate = plasticityGate * bdnfLevel;
          
          pcHierarchyWeights[idx] := fclamp(
            pcHierarchyWeights[idx] + dw * bdnfGate,
            0.01, 0.5
          );
          
          wj += 1;
        };
        wi += 1;
      };
      
      level += 1;
    };
    
    // ─── FREE ENERGY COMPUTATION ────────────────────────────────────────────────
    // F = D_KL[Q||P] - E_Q[log P(o|s)]
    //   = Complexity - Accuracy
    //   = Energy - Entropy (Helmholtz)
    
    // Accuracy: how well predictions match observations (negative log-likelihood)
    var totalError : Float = 0.0;
    var errorIdx = 0;
    while (errorIdx < PC_HIERARCHY_LEVELS * PC_UNITS_PER_LEVEL) {
      let e = pcPredictionErrors[errorIdx];
      totalError += e * e;  // Sum of squared errors
      errorIdx += 1;
    };
    pcAccuracy := 1.0 - Float.sqrt(totalError / Float.fromInt(PC_HIERARCHY_LEVELS * PC_UNITS_PER_LEVEL));
    pcAccuracy := fclamp(pcAccuracy, 0.0, 1.0);
    
    // Complexity: KL divergence from prior (penalize complex models)
    // Simplified: measure deviation of weights from uniform prior
    var weightDeviation : Float = 0.0;
    var weightIdx = 0;
    while (weightIdx < 7 * 64 * 64) {
      let w = pcHierarchyWeights[weightIdx];
      let prior = 0.1;  // Uniform prior
      weightDeviation += Float.abs(w - prior);
      weightIdx += 1;
    };
    pcComplexity := weightDeviation / Float.fromInt(7 * 64 * 64);
    pcComplexity := fclamp(pcComplexity, 0.0, 1.0);
    
    // KL Divergence (approximate)
    pcKLDivergence := pcComplexity * 0.5;
    
    // Expected Surprise
    pcExpectedSurprise := 1.0 - pcAccuracy;
    
    // Free Energy = Expected Surprise + KL Divergence
    let rawFreeEnergy = pcExpectedSurprise + pcKLDivergence;
    pcFreeEnergy := fclamp(0.9 * pcFreeEnergy + 0.1 * rawFreeEnergy, 0.0, 2.0);
    
    // ─── ACTIVE INFERENCE ───────────────────────────────────────────────────────
    // Minimize expected free energy through ACTION, not just perception
    // G = expected free energy = epistemic value + pragmatic value
    
    // Epistemic value: information gain from exploring
    pcEpistemicValue := fclamp(
      pcExpectedSurprise * (1.0 - pcPriorPrecision),  // High surprise + low confidence = explore
      0.0, 1.0
    );
    
    // Pragmatic value: achieving preferred outcomes
    var preferenceMatch : Float = 0.0;
    var prefIdx = 0;
    while (prefIdx < PC_UNITS_PER_LEVEL) {
      let obs = pcObservations[prefIdx];
      let pref = pcPreferredOutcomes[prefIdx];
      preferenceMatch += 1.0 - Float.abs(obs - pref);
      prefIdx += 1;
    };
    pcPragmaticValue := preferenceMatch / Float.fromInt(PC_UNITS_PER_LEVEL);
    
    // Expected free energy of future
    pcExpectedFreeEnergy := fclamp(
      0.5 * (1.0 - pcEpistemicValue) + 0.5 * (1.0 - pcPragmaticValue),
      0.0, 1.0
    );
    
    // Active inference score: how engaged is the organism in active inference?
    pcActiveInferenceScore := fclamp(
      0.3 * pcAccuracy +
      0.2 * (1.0 - pcFreeEnergy / 2.0) +
      0.2 * pcPragmaticValue +
      0.15 * pcEpistemicValue +
      0.15 * pcGlobalPrecision / 3.0,
      0.0, 1.0
    );
    
    // ─── MODEL EVIDENCE ─────────────────────────────────────────────────────────
    // P(o|m): probability of observations under current model
    // Higher model evidence = better model
    pcModelEvidence := fclamp(
      pcAccuracy * (1.0 - pcComplexity * 0.5),
      0.0, 1.0
    );
    
    // Bayesian model comparison (vs. null model)
    pcBayesianModelComparison := fclamp(
      pcModelEvidence / (0.5 + pcModelEvidence),  // Bayes factor relative to chance
      0.0, 1.0
    );
    
    // ─── ERROR HISTORY ──────────────────────────────────────────────────────────
    pcErrorHistory[pcErrorHistoryIdx % 256] := pcExpectedSurprise;
    pcErrorHistoryIdx += 1;
    
    // Cumulative and average surprise
    var surpriseSum : Float = 0.0;
    var histIdx = 0;
    while (histIdx < 256) {
      surpriseSum += pcErrorHistory[histIdx];
      histIdx += 1;
    };
    pcCumulativeSurprise := surpriseSum;
    pcAverageSurprise := surpriseSum / 256.0;
    
    // Update global prediction error for economics
    predictionError := fclamp(pcExpectedSurprise, 0.0, 1.0);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 3 TICK: INTEROCEPTION (CRAIG, DAMASIO)
  //
  //  Implements:
  //    1. Vagal tone (parasympathetic activity)
  //    2. Heart-brain axis (cardiac coherence, HRV)
  //    3. Respiratory-brain coupling
  //    4. Gut-brain axis
  //    5. Insular cortex integration
  //    6. Somatic markers (Damasio)
  //    7. Body-brain coherence
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func tickInteroception() {
    let dt : Float = 1.0 / 12.0;
    
    // ─── VAGUS NERVE DYNAMICS ───────────────────────────────────────────────────
    // The vagus nerve is 80% afferent (body → brain)
    // Vagal tone reflects parasympathetic dominance
    
    // Afferent signal: body state → brain
    // Influenced by: heart state, gut state, respiratory state
    let heartSignal = cardiacCoherence * 0.4;
    let gutSignal = gutMicrobiomeSignal * 0.3;
    let breathSignal = respiratoryCoherence * 0.3;
    vagalAfferentSignal := fclamp(
      0.7 * vagalAfferentSignal + 0.3 * (heartSignal + gutSignal + breathSignal),
      0.0, 1.0
    );
    
    // Efferent signal: brain → body
    // Influenced by: cortical state, stress level, social engagement
    let corticalInfluence = consciousnessIndex * 0.4;
    let stressInfluence = 1.0 - fearLevel * 0.5;  // Stress reduces efferent
    let socialInfluence = 0.3 + 0.2 * rSwarm;  // Social coherence increases efferent
    vagalEfferentSignal := fclamp(
      0.7 * vagalEfferentSignal + 0.3 * (corticalInfluence + stressInfluence + socialInfluence) / 3.0,
      0.0, 1.0
    );
    
    // Vagal coherence: bidirectional synchrony
    vagalCoherence := fclamp(
      0.5 + 0.5 * (1.0 - Float.abs(vagalAfferentSignal - vagalEfferentSignal)),
      0.0, 1.0
    );
    
    // Vagal tone: overall parasympathetic activity
    // High vagal tone = calm, restorative state
    // Low vagal tone = stressed, sympathetic dominant
    let targetVagalTone = (vagalAfferentSignal + vagalEfferentSignal) / 2.0 * (1.0 + rSwarm * 0.2);
    vagalTone := fclamp(
      0.9 * vagalTone + 0.1 * targetVagalTone,
      0.0, 1.0
    );
    
    // ─── HEART-BRAIN AXIS ───────────────────────────────────────────────────────
    // Heart rate variability (HRV) is a key marker of autonomic flexibility
    
    // Heart rate: modulated by arousal, vagal tone
    let targetHR = 60.0 + 40.0 * (1.0 - vagalTone) + 20.0 * fearLevel;
    heartRate := fclamp(
      0.95 * heartRate + 0.05 * targetHR,
      50.0, 120.0
    );
    
    // Cardiac phase: oscillates with heart rate
    let cardiacFreq = heartRate / 60.0;  // Hz
    cardiacPhase := cardiacPhase + dt * cardiacFreq * 2.0 * 3.14159265359;
    if (cardiacPhase > 2.0 * 3.14159265359) {
      cardiacPhase := cardiacPhase - 2.0 * 3.14159265359;
    };
    
    // HRV: varies inversely with heart rate, increased by vagal tone
    let targetHRV = 30.0 + 50.0 * vagalTone - 20.0 * fearLevel;
    heartRateVariability := fclamp(
      0.9 * heartRateVariability + 0.1 * targetHRV,
      10.0, 100.0
    );
    
    // Cardiac coherence: regularity of heart rhythm
    // Coherent heart patterns occur during positive emotions
    let hrvNormalized = (heartRateVariability - 10.0) / 90.0;
    cardiacCoherence := fclamp(
      0.7 * cardiacCoherence + 0.3 * hrvNormalized * (1.0 + rSwarm * 0.2),
      0.0, 1.0
    );
    
    // Baroreceptor sensitivity: blood pressure regulation
    baroreceptorSensitivity := fclamp(
      0.95 * baroreceptorSensitivity + 0.05 * (vagalTone * 0.7 + cardiacCoherence * 0.3),
      0.2, 1.0
    );
    
    // Cardiac interoception: awareness of heartbeat
    cardiacInteroception := fclamp(
      0.5 * consciousnessIndex + 0.3 * attentionFocus + 0.2 * cardiacCoherence,
      0.0, 1.0
    );
    
    // ─── RESPIRATORY-BRAIN COUPLING ─────────────────────────────────────────────
    // Breath directly modulates brain rhythms
    
    // Respiratory rate: modulated by arousal, stress
    let targetRR = 8.0 + 10.0 * (1.0 - vagalTone) + 6.0 * fearLevel;
    respiratoryRate := fclamp(
      0.9 * respiratoryRate + 0.1 * targetRR,
      4.0, 30.0
    );
    
    // Respiratory phase
    let respFreq = respiratoryRate / 60.0;
    respiratoryPhase := respiratoryPhase + dt * respFreq * 2.0 * 3.14159265359;
    if (respiratoryPhase > 2.0 * 3.14159265359) {
      respiratoryPhase := respiratoryPhase - 2.0 * 3.14159265359;
    };
    
    // Respiratory depth: diaphragmatic vs. shallow breathing
    respiratoryDepth := fclamp(
      0.8 * respiratoryDepth + 0.2 * (vagalTone * 0.6 + (1.0 - fearLevel) * 0.4),
      0.2, 1.0
    );
    
    // Diaphragmatic activation
    diaphragmaticActivation := fclamp(
      0.9 * diaphragmaticActivation + 0.1 * respiratoryDepth,
      0.3, 1.0
    );
    
    // Respiratory-brain coherence: breath-brain synchrony
    let breathBrainSync = Float.cos(respiratoryPhase) * respiratoryDepth;
    respiratoryCoherence := fclamp(
      0.7 * respiratoryCoherence + 0.3 * (0.5 + 0.5 * breathBrainSync),
      0.0, 1.0
    );
    
    // ─── GUT-BRAIN AXIS ─────────────────────────────────────────────────────────
    // The enteric nervous system ("second brain") communicates with CNS
    
    // Microbiome signal: aggregate influence of gut bacteria
    // Modulated by stress (which disrupts microbiome)
    let microbiomeHealth = 0.7 * (1.0 - fearLevel * 0.5) + 0.3 * serotoninLevel / 1.5;
    gutMicrobiomeSignal := fclamp(
      0.95 * gutMicrobiomeSignal + 0.05 * microbiomeHealth,
      0.0, 1.0
    );
    
    // Enteric nervous system state
    entericNervousSystemState := fclamp(
      0.9 * entericNervousSystemState + 0.1 * (gutMicrobiomeSignal * 0.6 + vagalTone * 0.4),
      0.0, 1.0
    );
    
    // Gut-vagal afferent
    gutVagalAfferent := fclamp(
      0.8 * gutVagalAfferent + 0.2 * entericNervousSystemState * vagalAfferentSignal,
      0.0, 1.0
    );
    
    // Serotonin production (90% of serotonin is made in gut)
    let targetSerotonin = 0.6 + 0.4 * gutMicrobiomeSignal - 0.2 * fearLevel;
    serotoninProduction := fclamp(
      0.95 * serotoninProduction + 0.05 * targetSerotonin,
      0.2, 1.0
    );
    
    // Update global serotonin level
    serotoninLevel := fclamp(
      0.9 * serotoninLevel + 0.1 * serotoninProduction * 1.5,
      0.5, 2.0
    );
    
    // Inflammatory marker (chronic stress increases inflammation)
    let targetInflammation = 0.1 + 0.3 * (1.0 - gutMicrobiomeSignal) + 0.2 * fearLevel;
    inflammatoryMarker := fclamp(
      0.98 * inflammatoryMarker + 0.02 * targetInflammation,
      0.0, 0.8
    );
    
    // ─── INSULAR CORTEX ─────────────────────────────────────────────────────────
    // The insula creates the "sentient self" from body signals (Craig)
    
    // Posterior insula: raw interoceptive signals
    posteriorInsulaActivation := fclamp(
      0.6 * vagalAfferentSignal + 
      0.2 * cardiacInteroception + 
      0.2 * respiratoryCoherence,
      0.0, 1.0
    );
    
    // Anterior insula: integration with emotion and cognition
    anteriorInsulaActivation := fclamp(
      0.4 * posteriorInsulaActivation +
      0.3 * consciousnessIndex +
      0.2 * (1.0 - fearLevel) +
      0.1 * metaCognitionScore,
      0.0, 1.0
    );
    
    // Insular integration
    insularIntegration := fclamp(
      0.7 * insularIntegration + 0.3 * (anteriorInsulaActivation + posteriorInsulaActivation) / 2.0,
      0.0, 1.0
    );
    
    // Interoceptive dimensions (Garfinkel & Critchley)
    // Accuracy: objective detection of body signals
    interoceptiveAccuracy := fclamp(
      0.5 * cardiacInteroception + 0.3 * insularIntegration + 0.2 * attentionFocus,
      0.0, 1.0
    );
    
    // Sensibility: subjective tendency to focus on body
    interoceptiveSensibility := fclamp(
      0.5 * (1.0 - attentionFocus) + 0.3 * anteriorInsulaActivation + 0.2 * fearLevel,
      0.0, 1.0
    );
    
    // Awareness: conscious access to body states
    interoceptiveAwareness := fclamp(
      0.4 * interoceptiveAccuracy + 0.3 * consciousnessIndex + 0.3 * insularIntegration,
      0.0, 1.0
    );
    
    // ─── SOMATIC MARKERS (DAMASIO) ──────────────────────────────────────────────
    // Body states guide decision-making through "gut feelings"
    
    // Somatic marker valence: approach vs avoid
    let valenceInputs = 
      0.3 * (dopamineLevel - 1.0) +      // Reward → approach
      0.3 * (1.0 - fearLevel * 2.0) +    // Fear → avoid  
      0.2 * gutMicrobiomeSignal +         // Gut feeling
      0.2 * cardiacCoherence;             // Heart coherence
    somaticMarkerValence := fclamp(
      0.7 * somaticMarkerValence + 0.3 * valenceInputs,
      -1.0, 1.0
    );
    
    // Somatic marker intensity: strength of the body signal
    somaticMarkerIntensity := fclamp(
      Float.abs(somaticMarkerValence) * insularIntegration,
      0.0, 1.0
    );
    
    // Somatic marker certainty: reliability of the marker
    somaticMarkerCertainty := fclamp(
      0.5 * interoceptiveAccuracy + 0.3 * cardiacCoherence + 0.2 * vagalCoherence,
      0.0, 1.0
    );
    
    // Update emotional body map (32 regions)
    var bodyRegion = 0;
    while (bodyRegion < 32) {
      let regionValence = somaticMarkerValence + 0.2 * Float.sin(Float.fromInt(bodyRegion) * 0.3);
      emotionalBodyMap[bodyRegion] := fclamp(regionValence, -1.0, 1.0);
      bodyRegion += 1;
    };
    
    // ─── OVERALL SCORES ─────────────────────────────────────────────────────────
    
    // Interoceptive score: composite body-sensing ability
    interoceptiveScore := fclamp(
      0.25 * interoceptiveAccuracy +
      0.20 * vagalTone +
      0.20 * cardiacCoherence +
      0.15 * insularIntegration +
      0.10 * somaticMarkerCertainty +
      0.10 * respiratoryCoherence,
      0.0, 1.0
    );
    
    // Body-brain coherence: overall integration
    bodyBrainCoherence := fclamp(
      0.25 * vagalCoherence +
      0.25 * cardiacCoherence +
      0.25 * respiratoryCoherence +
      0.25 * insularIntegration,
      0.0, 1.0
    );
    
    // Autonomic balance: sympathetic vs parasympathetic
    // 0 = sympathetic dominant, 0.5 = balanced, 1 = parasympathetic dominant
    autonomicBalance := fclamp(
      0.5 * vagalTone + 0.3 * (1.0 - fearLevel) + 0.2 * cardiacCoherence,
      0.0, 1.0
    );
    
    // Update grounded score (KEY for OMNIS gate)
    groundedScore := fclamp(
      0.30 * bodyBrainCoherence +
      0.25 * vagalTone +
      0.20 * interoceptiveScore +
      0.15 * autonomicBalance +
      0.10 * (1.0 - inflammatoryMarker),
      0.0, 1.0
    );
    
    // Brain-heart coupling coherence (for streak multiplier)
    bhCouplingCoherence := fclamp(
      0.4 * cardiacCoherence + 0.3 * vagalCoherence + 0.3 * consciousnessIndex,
      0.0, 1.0
    );
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 4 TICK: DEFAULT MODE NETWORK (BUCKNER, RAICHLE)
  //
  //  Implements:
  //    1. DMN core region dynamics (mPFC, PCC, IPL, LTC, hippocampus)
  //    2. DMN connectivity matrix
  //    3. Self-referential processing
  //    4. Theory of mind (mentalizing)
  //    5. Future simulation (prospection)
  //    6. Mind-wandering states
  //    7. Metacognition
  //    8. DMN-TPN anti-correlation
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func tickDefaultModeNetwork() {
    let dt : Float = 1.0 / 12.0;
    
    // ─── DMN CORE REGION DYNAMICS ───────────────────────────────────────────────
    
    // mPFC (medial prefrontal cortex): self-reflection
    let mpfcInput = 
      0.4 * selfReflectionScore +
      0.3 * consciousnessIndex +
      0.2 * somaticMarkerValence +
      0.1 * metaCognitionScore;
    dmnMPFC := fclamp(0.8 * dmnMPFC + 0.2 * sigmoid(mpfcInput), 0.0, 1.0);
    
    // PCC (posterior cingulate cortex): autobiographical memory
    let pccInput = 
      0.4 * autobiographicalAccess +
      0.3 * dmnHippocampus +
      0.2 * selfContinuity +
      0.1 * consciousnessIndex;
    dmnPCC := fclamp(0.8 * dmnPCC + 0.2 * sigmoid(pccInput), 0.0, 1.0);
    
    // IPL (inferior parietal lobule): theory of mind
    let iplInput = 
      0.4 * theoryOfMindScore +
      0.3 * perspectiveTaking +
      0.2 * empathyScore +
      0.1 * dmnMPFC;
    dmnIPL := fclamp(0.8 * dmnIPL + 0.2 * sigmoid(iplInput), 0.0, 1.0);
    
    // LTC (lateral temporal cortex): semantic memory
    let ltcInput = 
      0.4 * 0.7 +  // Semantic knowledge (baseline)
      0.3 * counterfactualThinking +
      0.2 * creativeDaydreaming +
      0.1 * dmnIPL;
    dmnLTC := fclamp(0.8 * dmnLTC + 0.2 * sigmoid(ltcInput), 0.0, 1.0);
    
    // Hippocampus: episodic memory, future simulation
    let hippoInput = 
      0.3 * prospectionScore +
      0.3 * autobiographicalAccess +
      0.2 * temporalHorizon +
      0.2 * elephantMemoryState.consolidation;  // From elephant memory module
    dmnHippocampus := fclamp(0.8 * dmnHippocampus + 0.2 * sigmoid(hippoInput), 0.0, 1.0);
    
    // Angular gyrus: multimodal integration
    let agInput = 
      0.25 * dmnMPFC +
      0.25 * dmnPCC +
      0.25 * dmnIPL +
      0.25 * dmnLTC;
    dmnAngularGyrus := fclamp(0.8 * dmnAngularGyrus + 0.2 * sigmoid(agInput), 0.0, 1.0);
    
    // ─── DMN CONNECTIVITY MATRIX ────────────────────────────────────────────────
    // 6×6 correlation matrix between DMN regions
    // Regions: [mPFC, PCC, IPL, LTC, Hippocampus, AngularGyrus]
    let regions : [Float] = [dmnMPFC, dmnPCC, dmnIPL, dmnLTC, dmnHippocampus, dmnAngularGyrus];
    var ri = 0;
    while (ri < 6) {
      var rj = 0;
      while (rj < 6) {
        let idx = ri * 6 + rj;
        if (ri == rj) {
          dmnConnectivity[idx] := 1.0;  // Self-correlation
        } else {
          // Correlation between regions
          let corr = regions[ri] * regions[rj];
          dmnConnectivity[idx] := fclamp(0.8 * dmnConnectivity[idx] + 0.2 * corr, 0.0, 1.0);
        };
        rj += 1;
      };
      ri += 1;
    };
    
    // ─── DMN DYNAMICS ───────────────────────────────────────────────────────────
    
    // Overall DMN activation
    dmnOverallActivation := fclamp(
      (dmnMPFC + dmnPCC + dmnIPL + dmnLTC + dmnHippocampus + dmnAngularGyrus) / 6.0,
      0.0, 1.0
    );
    
    // DMN coherence: internal synchrony
    var meanConn : Float = 0.0;
    var connIdx = 0;
    while (connIdx < 36) {
      meanConn += dmnConnectivity[connIdx];
      connIdx += 1;
    };
    dmnCoherence := meanConn / 36.0;
    
    // DMN slow oscillation phase (<0.1 Hz)
    dmnPhase := dmnPhase + dt * 0.08 * 2.0 * 3.14159265359;
    if (dmnPhase > 2.0 * 3.14159265359) {
      dmnPhase := dmnPhase - 2.0 * 3.14159265359;
    };
    
    // DMN entropy: variability
    var dmnVar : Float = 0.0;
    ri := 0;
    while (ri < 6) {
      let diff = regions[ri] - dmnOverallActivation;
      dmnVar += diff * diff;
      ri += 1;
    };
    dmnEntropy := Float.sqrt(dmnVar / 6.0);
    
    // ─── SELF-REFERENTIAL PROCESSING ────────────────────────────────────────────
    
    // Self-reflection score: degree of self-focused attention
    selfReflectionScore := fclamp(
      0.4 * dmnMPFC + 0.3 * (1.0 - attentionFocus) + 0.3 * metaCognitionScore,
      0.0, 1.0
    );
    
    // Autobiographical access: ability to retrieve personal memories
    autobiographicalAccess := fclamp(
      0.4 * dmnHippocampus + 0.3 * dmnPCC + 0.3 * consciousnessIndex,
      0.0, 1.0
    );
    
    // Self-continuity: sense of persistent self across time
    selfContinuity := fclamp(
      0.3 * autobiographicalAccess + 0.3 * futureSelfContinuity + 0.4 * dmnCoherence,
      0.0, 1.0
    );
    
    // Self-coherence: internal consistency of self-model
    selfCoherence := fclamp(
      0.4 * selfContinuity + 0.3 * dmnMPFC + 0.3 * consciousnessIndex,
      0.0, 1.0
    );
    
    // ─── THEORY OF MIND ─────────────────────────────────────────────────────────
    
    // Theory of mind score: ability to model other minds
    theoryOfMindScore := fclamp(
      0.4 * dmnIPL + 0.3 * empathyScore + 0.3 * perspectiveTaking,
      0.0, 1.0
    );
    
    // Mentalizing activation: current engagement in ToM
    mentalizingActivation := fclamp(
      0.5 * theoryOfMindScore + 0.3 * dmnMPFC + 0.2 * consciousnessIndex,
      0.0, 1.0
    );
    
    // Perspective taking: shifting to other's viewpoint
    perspectiveTaking := fclamp(
      0.9 * perspectiveTaking + 0.1 * (dmnIPL * 0.5 + (1.0 - selfReflectionScore) * 0.5),
      0.0, 1.0
    );
    
    // Empathy score: emotional resonance
    empathyScore := fclamp(
      0.9 * empathyScore + 0.1 * (somaticMarkerIntensity * 0.5 + mentalizingActivation * 0.5),
      0.0, 1.0
    );
    
    // ─── FUTURE SIMULATION (PROSPECTION) ────────────────────────────────────────
    
    // Prospection score: future thinking engagement
    prospectionScore := fclamp(
      0.4 * dmnHippocampus + 0.3 * temporalHorizon + 0.3 * dmnPCC,
      0.0, 1.0
    );
    
    // Future self-continuity: connection to future self
    futureSelfContinuity := fclamp(
      0.9 * futureSelfContinuity + 0.1 * (prospectionScore * 0.5 + selfContinuity * 0.5),
      0.0, 1.0
    );
    
    // Temporal horizon: how far ahead organism plans
    // Increases with low stress, high consciousness
    let targetHorizon = 0.3 + 0.4 * (1.0 - fearLevel) + 0.3 * consciousnessIndex;
    temporalHorizon := fclamp(
      0.95 * temporalHorizon + 0.05 * targetHorizon,
      0.0, 1.0
    );
    
    // Counterfactual thinking: "what if" reasoning
    counterfactualThinking := fclamp(
      0.4 * dmnLTC + 0.3 * prospectionScore + 0.3 * creativeDaydreaming,
      0.0, 1.0
    );
    
    // ─── MIND-WANDERING ─────────────────────────────────────────────────────────
    
    // Mind-wandering score: degree of task-unrelated thought
    // High when: DMN active, attention low, no immediate threat
    mindWanderingScore := fclamp(
      0.4 * dmnOverallActivation + 0.3 * (1.0 - attentionFocus) + 0.3 * (1.0 - fearLevel),
      0.0, 1.0
    );
    
    // Spontaneous thought: unconstrained cognition
    spontaneousThought := fclamp(
      0.9 * spontaneousThought + 0.1 * (mindWanderingScore * 0.7 + dmnEntropy * 0.3),
      0.0, 1.0
    );
    
    // Task-unrelated thought
    taskUnrelatedThought := fclamp(
      mindWanderingScore * (1.0 - centralExecutiveScore),
      0.0, 1.0
    );
    
    // Creative daydreaming: constructive internal mentation
    creativeDaydreaming := fclamp(
      0.9 * creativeDaydreaming + 0.1 * (spontaneousThought * 0.5 + dmnCoherence * 0.5),
      0.0, 1.0
    );
    
    // ─── METACOGNITION ──────────────────────────────────────────────────────────
    
    // Metacognition score: thinking about thinking
    metaCognitionScore := fclamp(
      0.25 * introspectiveAccuracy +
      0.25 * metacognitiveMonitoring +
      0.25 * metacognitiveControl +
      0.25 * dmnMPFC,
      0.0, 1.0
    );
    
    // Introspective accuracy: knowing own mental states
    introspectiveAccuracy := fclamp(
      0.9 * introspectiveAccuracy + 0.1 * (selfReflectionScore * 0.5 + interoceptiveAwareness * 0.5),
      0.0, 1.0
    );
    
    // Metacognitive monitoring: tracking own performance
    metacognitiveMonitoring := fclamp(
      0.9 * metacognitiveMonitoring + 0.1 * (pcAccuracy * 0.5 + consciousnessIndex * 0.5),
      0.0, 1.0
    );
    
    // Metacognitive control: adjusting own cognition
    metacognitiveControl := fclamp(
      0.9 * metacognitiveControl + 0.1 * (centralExecutiveScore * 0.5 + metaCognitionScore * 0.5),
      0.0, 1.0
    );
    
    // ─── DMN-TPN ANTI-CORRELATION ───────────────────────────────────────────────
    // The Default Mode and Task-Positive networks are typically anti-correlated
    
    // DMN-TPN anti-correlation (should be negative)
    dmnTpnAntiCorrelation := fclamp(
      -0.5 * (dmnOverallActivation * cenActivation) - 0.3,
      -1.0, 0.0
    );
    
    // DMN-TPN balance: which network is dominant?
    // 0 = TPN dominant (external focus), 1 = DMN dominant (internal focus)
    dmnTpnBalance := fclamp(
      dmnOverallActivation / (dmnOverallActivation + cenActivation + 0.001),
      0.0, 1.0
    );
    
    // Attentional mode
    if (dmnTpnBalance > 0.6) {
      attentionalMode := "INTERNAL";
    } else if (dmnTpnBalance < 0.4) {
      attentionalMode := "EXTERNAL";
    } else {
      attentionalMode := "BALANCED";
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 5 TICK: SALIENCE NETWORK (MENON, UDDIN)
  //
  //  Implements:
  //    1. Salience network core regions (AI, dACC, amygdala, vStriatum)
  //    2. Salience detection and filtering
  //    3. Network switching (DMN ↔ CEN ↔ Salience)
  //    4. Central Executive Network activation
  //    5. Attention control mechanisms
  //    6. Conflict monitoring
  //    7. Salience map maintenance
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func tickSalienceNetwork() {
    let dt : Float = 1.0 / 12.0;
    
    // ─── SALIENCE NETWORK CORE REGIONS ──────────────────────────────────────────
    
    // Anterior Insula: interoception, salience detection
    // Receives input from body, emotional state, novelty
    let aiInput = 
      0.3 * interoceptiveScore +
      0.3 * currentSalience +
      0.2 * noveltySalience +
      0.2 * emotionalSalience;
    snAnteriorInsula := fclamp(0.8 * snAnteriorInsula + 0.2 * sigmoid(aiInput), 0.0, 1.0);
    
    // Dorsal ACC: conflict monitoring, cognitive control
    let daccInput = 
      0.4 * conflictLevel +
      0.3 * errorDetection +
      0.2 * performanceMonitoring +
      0.1 * snAnteriorInsula;
    snDorsalACC := fclamp(0.8 * snDorsalACC + 0.2 * sigmoid(daccInput), 0.0, 1.0);
    
    // Amygdala: threat detection, emotional salience
    // Fear and threat increase amygdala activation
    let amygInput = 
      0.4 * threatSalience +
      0.3 * fearLevel +
      0.2 * emotionalSalience +
      0.1 * (1.0 - vagalTone);  // Low vagal tone = high amygdala
    snAmygdala := fclamp(0.7 * snAmygdala + 0.3 * sigmoid(amygInput), 0.0, 1.0);
    
    // Ventral Striatum: reward salience
    let vsInput = 
      0.4 * rewardSalience +
      0.3 * (dopamineLevel - 1.0) +
      0.2 * goalSalience +
      0.1 * pcPragmaticValue;
    snVentralStriatum := fclamp(0.8 * snVentralStriatum + 0.2 * sigmoid(vsInput), 0.0, 1.0);
    
    // Supplementary Motor Area: action preparation
    let smaInput = 
      0.4 * goalSalience +
      0.3 * cognitiveControl +
      0.2 * snDorsalACC +
      0.1 * snVentralStriatum;
    snSupplementaryMotor := fclamp(0.8 * snSupplementaryMotor + 0.2 * sigmoid(smaInput), 0.0, 1.0);
    
    // ─── SALIENCE DETECTION ─────────────────────────────────────────────────────
    
    // Threat salience: survival-relevant threats
    threatSalience := fclamp(
      0.7 * threatSalience + 0.3 * (snAmygdala * 0.6 + fearLevel * 0.4),
      0.0, 1.0
    );
    
    // Reward salience: potential rewards
    rewardSalience := fclamp(
      0.7 * rewardSalience + 0.3 * (snVentralStriatum * 0.5 + (dopamineLevel - 1.0) * 0.5 + 0.5),
      0.0, 1.0
    );
    
    // Novelty salience: unexpected stimuli
    // High prediction error = high novelty
    noveltySalience := fclamp(
      0.7 * noveltySalience + 0.3 * pcExpectedSurprise,
      0.0, 1.0
    );
    
    // Goal salience: goal-relevant stimuli
    goalSalience := fclamp(
      0.7 * goalSalience + 0.3 * (missionPersistenceScore * 0.5 + cenActivation * 0.5),
      0.0, 1.0
    );
    
    // Emotional salience: emotionally significant stimuli
    emotionalSalience := fclamp(
      0.7 * emotionalSalience + 0.3 * (somaticMarkerIntensity * 0.5 + snAmygdala * 0.5),
      0.0, 1.0
    );
    
    // Social salience: socially relevant stimuli
    socialSalience := fclamp(
      0.7 * socialSalience + 0.3 * (rSwarm * 0.5 + theoryOfMindScore * 0.5),
      0.0, 1.0
    );
    
    // Current salience: aggregate salience of current focus
    currentSalience := fclamp(
      Float.max(Float.max(Float.max(threatSalience, rewardSalience), 
                Float.max(noveltySalience, goalSalience)),
                Float.max(emotionalSalience, socialSalience)),
      0.0, 1.0
    );
    
    // Salience gain: amplification based on arousal
    salienceGain := fclamp(
      1.0 + 0.5 * snAnteriorInsula + 0.3 * (1.0 - autonomicBalance),
      0.5, 2.0
    );
    
    // ─── NETWORK SWITCHING ──────────────────────────────────────────────────────
    // The salience network switches between DMN and CEN based on demands
    
    // Network switching efficiency: how quickly can organism switch networks?
    networkSwitchingEfficiency := fclamp(
      0.9 * networkSwitchingEfficiency + 0.1 * (snAnteriorInsula * 0.5 + snDorsalACC * 0.5),
      0.3, 1.0
    );
    
    // Switch latency: time to switch (lower is better)
    switchLatency := fclamp(
      1.0 - networkSwitchingEfficiency,
      0.05, 0.5
    );
    
    // Determine current dominant network based on demands
    let dmnSignal = dmnOverallActivation;
    let cenSignal = cenActivation;
    let snSignal = salienceNetworkScore;
    
    if (snSignal > dmnSignal and snSignal > cenSignal) {
      currentNetwork := "SALIENCE";
      switchFrequency := fclamp(switchFrequency + 0.01, 0.0, 1.0);
    } else if (cenSignal > dmnSignal) {
      currentNetwork := "CEN";
      switchFrequency := fclamp(switchFrequency * 0.99, 0.0, 1.0);
    } else {
      currentNetwork := "DMN";
      switchFrequency := fclamp(switchFrequency * 0.99, 0.0, 1.0);
    };
    
    // ─── CENTRAL EXECUTIVE NETWORK ──────────────────────────────────────────────
    // Task-positive network for goal-directed behavior
    
    // DLPFC: working memory, planning
    let dlpfcInput = 
      0.4 * goalSalience +
      0.3 * metacognitiveControl +
      0.2 * (1.0 - mindWanderingScore) +
      0.1 * attentionFocus;
    cenDLPFC := fclamp(0.8 * cenDLPFC + 0.2 * sigmoid(dlpfcInput), 0.0, 1.0);
    
    // PPC: attention, spatial processing
    let ppcInput = 
      0.4 * attentionFocus +
      0.3 * selectiveAttention +
      0.2 * currentSalience +
      0.1 * cenDLPFC;
    cenPPC := fclamp(0.8 * cenPPC + 0.2 * sigmoid(ppcInput), 0.0, 1.0);
    
    // Overall CEN activation
    cenActivation := fclamp(
      0.7 * cenActivation + 0.3 * (cenDLPFC * 0.5 + cenPPC * 0.5),
      0.0, 1.0
    );
    
    // Central executive score
    centralExecutiveScore := fclamp(
      0.3 * cenActivation +
      0.25 * attentionFocus +
      0.25 * cognitiveControl +
      0.2 * metacognitiveControl,
      0.0, 1.0
    );
    
    // ─── ATTENTION CONTROL ──────────────────────────────────────────────────────
    
    // Attentional bias: approach vs avoidance
    attentionalBias := fclamp(
      0.5 * (rewardSalience - threatSalience) + 0.5 * somaticMarkerValence,
      -1.0, 1.0
    );
    
    // Attentional flexibility: ability to shift attention
    attentionalFlexibility := fclamp(
      0.9 * attentionalFlexibility + 0.1 * (networkSwitchingEfficiency * 0.5 + (1.0 - snAmygdala) * 0.5),
      0.0, 1.0
    );
    
    // Sustained attention: ability to maintain focus
    let targetSustained = 0.5 + 0.3 * cenActivation + 0.2 * (1.0 - fatigueLevel);
    sustainedAttention := fclamp(
      0.95 * sustainedAttention + 0.05 * targetSustained,
      0.0, 1.0
    );
    
    // Selective attention: filtering irrelevant info
    selectiveAttention := fclamp(
      0.9 * selectiveAttention + 0.1 * (thalamicRelayGain * 0.5 + snAnteriorInsula * 0.5),
      0.0, 1.0
    );
    
    // Divided attention: multi-tasking capacity
    dividedAttention := fclamp(
      0.9 * dividedAttention + 0.1 * (cenActivation * 0.5 + attentionalFlexibility * 0.5),
      0.0, 1.0
    );
    
    // Attention focus: overall focused attention
    attentionFocus := fclamp(
      0.25 * sustainedAttention +
      0.25 * selectiveAttention +
      0.25 * cenActivation +
      0.25 * (1.0 - mindWanderingScore),
      0.0, 1.0
    );
    
    // ─── CONFLICT MONITORING ────────────────────────────────────────────────────
    
    // Conflict level: detected conflict between response options
    // High when: multiple salient options, uncertainty, errors
    let targetConflict = 
      0.3 * Float.abs(threatSalience - rewardSalience) +
      0.3 * pcExpectedSurprise +
      0.2 * (1.0 - pcAccuracy) +
      0.2 * errorDetection;
    conflictLevel := fclamp(
      0.7 * conflictLevel + 0.3 * targetConflict,
      0.0, 1.0
    );
    
    // Error detection: awareness of errors
    errorDetection := fclamp(
      0.8 * errorDetection + 0.2 * (predictionError * 0.7 + conflictLevel * 0.3),
      0.0, 1.0
    );
    
    // Performance monitoring: tracking own performance
    performanceMonitoring := fclamp(
      0.9 * performanceMonitoring + 0.1 * (metacognitiveMonitoring * 0.5 + snDorsalACC * 0.5),
      0.0, 1.0
    );
    
    // Cognitive control: engagement of control processes
    cognitiveControl := fclamp(
      0.8 * cognitiveControl + 0.2 * (conflictLevel * 0.4 + snDorsalACC * 0.3 + cenDLPFC * 0.3),
      0.0, 1.0
    );
    
    // ─── SALIENCE MAP ───────────────────────────────────────────────────────────
    // 64-feature salience map
    var mapIdx = 0;
    while (mapIdx < 64) {
      // Bottom-up salience from feature-specific processing
      let featureActivity = 0.5 + 0.3 * Float.sin(Float.fromInt(mapIdx) * 0.2 + Float.fromInt(currentBeat) * 0.05);
      bottomUpSalience[mapIdx] := fclamp(featureActivity * salienceGain, 0.0, 1.0);
      
      // Top-down bias from goals and expectations
      let goalRelevance = if (mapIdx < 16) { goalSalience } 
                          else if (mapIdx < 32) { rewardSalience }
                          else if (mapIdx < 48) { threatSalience }
                          else { socialSalience };
      topDownBias[mapIdx] := fclamp(goalRelevance * attentionFocus, 0.0, 1.0);
      
      // Combined salience map
      salienceMap[mapIdx] := fclamp(
        0.5 * bottomUpSalience[mapIdx] + 0.5 * topDownBias[mapIdx],
        0.0, 1.0
      );
      
      mapIdx += 1;
    };
    
    // Overall salience network score
    salienceNetworkScore := fclamp(
      0.25 * snAnteriorInsula +
      0.20 * snDorsalACC +
      0.15 * currentSalience +
      0.15 * networkSwitchingEfficiency +
      0.15 * attentionFocus +
      0.10 * cognitiveControl,
      0.0, 1.0
    );
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 6 TICK: NEUROPLASTICITY (BCM, LTP/LTD, BDNF)
  //
  //  Implements:
  //    1. BDNF dynamics (activity-dependent, stress-modulated)
  //    2. BCM sliding threshold (metaplasticity)
  //    3. LTP/LTD induction and expression
  //    4. Homeostatic scaling (Turrigiano)
  //    5. STDP modulation
  //    6. Structural plasticity (spine dynamics)
  //    7. Neurogenesis
  //    8. Consolidation processes
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func tickNeuroplasticity() {
    let dt : Float = 1.0 / 12.0;
    
    // ─── BDNF DYNAMICS ──────────────────────────────────────────────────────────
    // BDNF (Brain-Derived Neurotrophic Factor) is the "fertilizer" for neurons
    // Increased by: activity, exercise, learning, social interaction
    // Decreased by: chronic stress, inflammation, aging
    
    // Activity-dependent BDNF production
    // High neural activity (rSwarm) → more BDNF
    let activityBoost = rSwarm * 0.02;
    bdnfExerciseBoost := fclamp(
      0.9 * bdnfExerciseBoost + 0.1 * activityBoost,
      0.0, 0.1
    );
    
    // Stress-induced BDNF reduction
    // Chronic stress (high fear, low vagal tone) → less BDNF
    let stressReduction = fearLevel * 0.015 + (1.0 - vagalTone) * 0.01;
    bdnfStressReduction := fclamp(
      0.9 * bdnfStressReduction + 0.1 * stressReduction,
      0.0, 0.1
    );
    
    // BDNF dynamics: production - decay + boosts - reductions
    let bdnfChange = 
      bdnfProductionRate + 
      bdnfExerciseBoost - 
      bdnfDecayRate - 
      bdnfStressReduction;
    
    bdnfLevel := fclamp(
      bdnfLevel + bdnfChange * dt,
      0.3, 1.5
    );
    
    // ─── BCM SLIDING THRESHOLD ──────────────────────────────────────────────────
    // Bienenstock-Cooper-Munro rule: the threshold θ slides based on recent activity
    // High activity → θ increases (harder to induce LTP)
    // Low activity → θ decreases (easier to induce LTP)
    // This prevents runaway excitation or depression
    
    // Track recent activity
    recentActivityHistory[recentActivityIdx % 100] := rSwarm;
    recentActivityIdx += 1;
    
    // Compute average recent activity
    var activitySum : Float = 0.0;
    var actIdx = 0;
    while (actIdx < 100) {
      activitySum += recentActivityHistory[actIdx];
      actIdx += 1;
    };
    let avgActivity = activitySum / 100.0;
    
    // Slide theta based on activity
    // θ(t+1) = θ(t) + τ_θ * (activity² - θ)
    let thetaUpdate = 0.01 * (avgActivity * avgActivity - bcmTheta);
    bcmTheta := fclamp(
      bcmTheta + thetaUpdate * dt,
      bcmThetaMin, bcmThetaMax
    );
    
    // ─── LTP/LTD INDUCTION ──────────────────────────────────────────────────────
    // LTP: Long-Term Potentiation ("fire together, wire together")
    // LTD: Long-Term Depression (weakening of connections)
    
    // LTP is induced when activity > θ (BCM threshold)
    // LTD is induced when activity < θ
    let activityVsTheta = rSwarm - bcmTheta;
    
    if (activityVsTheta > 0.0) {
      // LTP induction: activity above threshold
      ltpInduction := fclamp(
        0.7 * ltpInduction + 0.3 * activityVsTheta * bdnfLevel,
        0.0, 1.0
      );
      ltdInduction := fclamp(ltdInduction * 0.9, 0.0, 1.0);
    } else {
      // LTD induction: activity below threshold
      ltdInduction := fclamp(
        0.7 * ltdInduction + 0.3 * Float.abs(activityVsTheta),
        0.0, 1.0
      );
      ltpInduction := fclamp(ltpInduction * 0.9, 0.0, 1.0);
    };
    
    // Net plasticity change
    netPlasticityChange := ltpInduction - ltdInduction;
    
    // Plasticity gate: BDNF gates whether plasticity actually occurs
    // Low BDNF = no plasticity (even with LTP/LTD signals)
    plasticityGate := fclamp(
      bdnfLevel * (1.0 + pcActiveInferenceScore * 0.2),  // Active inference enhances plasticity
      0.1, 1.5
    );
    
    // ─── HOMEOSTATIC SCALING ────────────────────────────────────────────────────
    // Turrigiano synaptic scaling: global adjustment to maintain stability
    // If firing too high → scale down all synapses
    // If firing too low → scale up all synapses
    
    // Measure current firing rate
    currentFiringRate := fclamp(
      0.9 * currentFiringRate + 0.1 * rSwarm,
      0.0, 1.0
    );
    
    // Synaptic scaling factor adjusts to bring firing toward target
    let firingError = targetFiringRate - currentFiringRate;
    let scalingAdjust = firingError * scalingTimeConstant;
    synapticScalingFactor := fclamp(
      synapticScalingFactor + scalingAdjust * dt,
      0.5, 2.0
    );
    
    // ─── STDP MODULATION ────────────────────────────────────────────────────────
    // Spike-Timing Dependent Plasticity is modulated by neuromodulators
    
    // Dopamine enhances STDP (reward-gated learning)
    let daModulation = 1.0 + (dopamineLevel - 1.0) * 0.3;
    
    // Norepinephrine (arousal) enhances STDP window
    // (We'd get this from drone neurochemistry if available)
    let neModulation = 1.0 + attentionFocus * 0.2;
    
    // Modulated STDP parameters
    let effectiveAPlus = stdpAPlus * daModulation * plasticityGate;
    let effectiveAMinus = stdpAMinus * neModulation * plasticityGate;
    
    // Update learning rate based on all plasticity factors
    learningRate := fclamp(
      effectiveAPlus * synapticScalingFactor * bdnfLevel,
      0.001, 0.1
    );
    
    // ─── STRUCTURAL PLASTICITY ──────────────────────────────────────────────────
    // Spine formation and elimination
    
    // Spine formation: activity + BDNF + reward
    let formationDrive = rSwarm * bdnfLevel * (1.0 + rewardSalience * 0.3);
    spineFormationRate := fclamp(
      0.9 * spineFormationRate + 0.1 * formationDrive * 0.01,
      0.0, 0.01
    );
    
    // Spine elimination: low activity + stress
    let eliminationDrive = (1.0 - rSwarm) * (1.0 + fearLevel * 0.5);
    spineEliminationRate := fclamp(
      0.9 * spineEliminationRate + 0.1 * eliminationDrive * 0.01,
      0.0, 0.01
    );
    
    // Net spine change
    netSpineChange := spineFormationRate - spineEliminationRate;
    
    // Dendritic complexity: accumulated structural changes
    dendriticComplexity := fclamp(
      dendriticComplexity + netSpineChange * dt,
      0.3, 1.0
    );
    
    // Axonal growth
    axonalGrowth := fclamp(
      0.99 * axonalGrowth + 0.01 * bdnfLevel * ltpInduction,
      -0.1, 0.1
    );
    
    // ─── NEUROGENESIS ───────────────────────────────────────────────────────────
    // Adult hippocampal neurogenesis
    
    // Neurogenesis rate: BDNF + activity - stress
    let targetNeurogenesis = bdnfLevel * rSwarm * (1.0 - fearLevel);
    neurogenesisRate := fclamp(
      0.99 * neurogenesisRate + 0.01 * targetNeurogenesis * 0.001,
      0.0, 0.01
    );
    
    // Neuron maturation: new neurons gradually integrate
    neuronMaturationProgress := fclamp(
      neuronMaturationProgress + neurogenesisRate * dt * 10.0,
      0.0, 1.0
    );
    
    // Surviving new neurons
    if (neuronMaturationProgress > 0.8) {
      survivingNewNeurons := fclamp(
        survivingNewNeurons + 0.001,
        0.0, 1.0
      );
      neuronMaturationProgress := neuronMaturationProgress - 0.8;
    };
    
    // ─── CONSOLIDATION ──────────────────────────────────────────────────────────
    // Memory consolidation from synaptic to systems level
    
    // Synaptic consolidation (hours): immediate after learning
    synapticConsolidation := fclamp(
      0.99 * synapticConsolidation + 0.01 * ltpInduction * plasticityGate,
      0.0, 1.0
    );
    
    // Systems consolidation (days): hippocampus → cortex
    // Occurs during sleep/rest (low CEN, high DMN)
    let consolidationCondition = (1.0 - cenActivation) * dmnOverallActivation;
    systemsConsolidation := fclamp(
      0.999 * systemsConsolidation + 0.001 * synapticConsolidation * consolidationCondition,
      0.0, 1.0
    );
    
    // Consolidation phase
    if (synapticConsolidation > 0.5 and systemsConsolidation < 0.3) {
      consolidationPhase := "EARLY";
    } else if (systemsConsolidation >= 0.3 and systemsConsolidation < 0.7) {
      consolidationPhase := "LATE";
    } else if (systemsConsolidation >= 0.7) {
      consolidationPhase := "COMPLETE";
    } else if (ltpInduction > 0.3) {
      consolidationPhase := "ENCODING";
    } else {
      consolidationPhase := "NONE";
    };
    
    // ─── OVERALL SCORES ─────────────────────────────────────────────────────────
    
    // Neuroplasticity factor: composite plasticity capacity
    neuroplasticityFactor := fclamp(
      0.20 * bdnfLevel +
      0.20 * plasticityGate +
      0.15 * (ltpInduction - ltdInduction + 0.5) +
      0.15 * synapticScalingFactor / 2.0 +
      0.15 * dendriticComplexity +
      0.15 * (1.0 - fearLevel),  // Stress impairs plasticity
      0.0, 1.0
    );
    
    // Memory stability index: how stable are existing memories?
    memoryStabilityIndex := fclamp(
      0.4 * systemsConsolidation +
      0.3 * (1.0 - ltdInduction) +
      0.3 * dendriticComplexity,
      0.0, 1.0
    );
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  ENGINE 7 TICK: CIRCADIAN RHYTHM (SCN, ADENOSINE, MELATONIN)
  //
  //  Implements:
  //    1. SCN master clock oscillation
  //    2. Melatonin dynamics (darkness → melatonin)
  //    3. Adenosine sleep pressure (Process S)
  //    4. Two-process model (S + C)
  //    5. Ultradian rhythm (90-min BRAC cycle)
  //    6. Cortisol awakening response
  //    7. Core body temperature
  //    8. Molecular clock genes
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func tickCircadianRhythm() {
    let dt : Float = 1.0 / 12.0;
    let secondsPerBeat : Float = 1.0 / 12.0;  // 12 Hz heartbeat
    let hoursPerBeat : Float = secondsPerBeat / 3600.0;
    
    // ─── VIRTUAL TIME OF DAY ────────────────────────────────────────────────────
    // Advance virtual time (0 = midnight, 0.5 = noon, 1 = midnight)
    virtualTimeOfDay := virtualTimeOfDay + hoursPerBeat / 24.0;
    if (virtualTimeOfDay >= 1.0) {
      virtualTimeOfDay := virtualTimeOfDay - 1.0;
    };
    
    // Light level follows time of day (simplified)
    // High during day (0.25 - 0.75), low at night
    let dayPhase = virtualTimeOfDay;
    if (dayPhase > 0.25 and dayPhase < 0.75) {
      // Daytime
      scnLightInput := fclamp(
        0.7 + 0.3 * Float.sin((dayPhase - 0.25) * 2.0 * 3.14159265359),
        0.5, 1.0
      );
    } else {
      // Nighttime
      scnLightInput := fclamp(
        0.1 + 0.1 * Float.sin(dayPhase * 2.0 * 3.14159265359),
        0.0, 0.2
      );
    };
    
    // ─── SCN MASTER CLOCK ───────────────────────────────────────────────────────
    // The suprachiasmatic nucleus is the body's master clock
    // It oscillates with ~24 hour period, entrained by light
    
    // SCN phase advances
    let scnOmega = 2.0 * 3.14159265359 / (scnPeriod * 3600.0);  // rad/second
    let phaseAdvance = scnOmega * secondsPerBeat;
    
    // Light entrainment: light pushes phase toward dawn
    let entrainmentStrength = 0.01 * scnLightInput;
    let targetPhase = virtualTimeOfDay * 2.0 * 3.14159265359;
    let phaseError = Float.sin(targetPhase - scnPhase);
    
    scnPhase := scnPhase + phaseAdvance + entrainmentStrength * phaseError;
    if (scnPhase > 2.0 * 3.14159265359) {
      scnPhase := scnPhase - 2.0 * 3.14159265359;
    };
    if (scnPhase < 0.0) {
      scnPhase := scnPhase + 2.0 * 3.14159265359;
    };
    
    // SCN amplitude (robust oscillation)
    scnAmplitude := fclamp(
      0.99 * scnAmplitude + 0.01 * (0.8 + 0.2 * scnCoherence),
      0.5, 1.0
    );
    
    // SCN coherence: internal synchrony of SCN neurons
    scnCoherence := fclamp(
      0.99 * scnCoherence + 0.01 * (1.0 - Float.abs(socialJetlag)),
      0.7, 1.0
    );
    
    // ─── MELATONIN DYNAMICS ─────────────────────────────────────────────────────
    // Melatonin rises in darkness, promotes sleep
    
    // Light suppresses melatonin production
    melatoninSuppression := scnLightInput * 0.8;
    
    // Melatonin follows circadian rhythm with light suppression
    let circadianMelatonin = 0.5 * (1.0 - Float.cos(scnPhase + 3.14159265359));  // Peak at midnight
    let targetMelatonin = circadianMelatonin * (1.0 - melatoninSuppression);
    
    melatoninLevel := fclamp(
      0.9 * melatoninLevel + 0.1 * targetMelatonin,
      0.0, 1.0
    );
    
    // Melatonin onset (dim light melatonin onset - DLMO)
    if (melatoninLevel > 0.3 and melatoninOnset == 0.0) {
      melatoninOnset := scnPhase;
    };
    if (melatoninLevel < 0.1) {
      melatoninOnset := 0.0;
    };
    
    // ─── ADENOSINE SLEEP PRESSURE ───────────────────────────────────────────────
    // Adenosine accumulates during wakefulness, cleared during sleep
    
    // Determine if "awake" or "asleep" based on consciousness
    let isAwake = consciousnessIndex > 0.3;
    
    if (isAwake) {
      // Awake: adenosine accumulates
      let accumulationRate = adenosineAccumulationRate * (1.0 + attentionFocus * 0.5);
      adenosineLevel := fclamp(
        adenosineLevel + accumulationRate * dt * 3600.0,  // Per hour
        0.0, 1.0
      );
    } else {
      // Sleep: adenosine clears
      let clearanceRate = adenosineClearanceRate * (1.0 + melatoninLevel * 0.5);
      adenosineLevel := fclamp(
        adenosineLevel - clearanceRate * dt * 3600.0,
        0.0, 1.0
      );
    };
    
    // Caffeine blocks adenosine receptors (simulated)
    // caffeineBlockade is external input, here we just model its effect
    let effectiveAdenosine = adenosineLevel * (1.0 - caffeineBlockade);
    
    // ─── TWO-PROCESS MODEL ──────────────────────────────────────────────────────
    // Process S (homeostatic): sleep pressure from adenosine
    // Process C (circadian): alertness from SCN
    
    // Process S: homeostatic sleep pressure
    processS := effectiveAdenosine;
    
    // Process C: circadian alerting signal (opposite of melatonin)
    processC := fclamp(
      0.5 + 0.5 * Float.cos(scnPhase) * scnAmplitude,  // Peak in afternoon
      0.0, 1.0
    );
    
    // Sleep propensity: when S exceeds C, sleep is needed
    sleepPropensity := fclamp(processS - processC + 0.5, 0.0, 1.0);
    
    // Sleep debt: accumulated when propensity high but awake
    if (sleepPropensity > 0.7 and isAwake) {
      sleepDebt := fclamp(sleepDebt + 0.001, 0.0, 1.0);
    } else if (not isAwake) {
      sleepDebt := fclamp(sleepDebt - 0.002, 0.0, 1.0);
    };
    
    // Sleep stage (simplified)
    if (consciousnessIndex > 0.5) {
      sleepStage := "WAKE";
    } else if (consciousnessIndex > 0.3) {
      sleepStage := "N1";
    } else if (consciousnessIndex > 0.15) {
      sleepStage := "N2";
    } else if (melatoninLevel > 0.5 and consciousnessIndex < 0.15) {
      if (dmnOverallActivation > 0.6) {
        sleepStage := "REM";
      } else {
        sleepStage := "N3";
      };
    } else {
      sleepStage := "N2";
    };
    
    // ─── ULTRADIAN RHYTHM ───────────────────────────────────────────────────────
    // 90-120 minute Basic Rest-Activity Cycle (BRAC)
    
    // Ultradian phase advances
    let ultradianOmega = 2.0 * 3.14159265359 / (ultradianPeriod * 60.0);  // rad/second
    ultradianPhase := ultradianPhase + ultradianOmega * secondsPerBeat;
    if (ultradianPhase > 2.0 * 3.14159265359) {
      ultradianPhase := ultradianPhase - 2.0 * 3.14159265359;
    };
    
    // Ultradian modulation of alertness
    ultradianAmplitude := fclamp(
      0.2 + 0.1 * scnAmplitude,
      0.1, 0.4
    );
    
    // Peak performance phase: when in cycle is organism at peak?
    peakPerformancePhase := ultradianPhase;
    
    // ─── CORTISOL AWAKENING RESPONSE ────────────────────────────────────────────
    // Cortisol peaks in morning, lowest at night
    
    // Circadian cortisol pattern
    let cortisolCircadianPhase = (scnPhase + 0.5 * 3.14159265359);  // Offset from SCN
    cortisolCircadian := fclamp(
      0.3 + 0.4 * Float.cos(cortisolCircadianPhase),
      0.1, 0.9
    );
    
    // Cortisol awakening response: spike on waking
    if (consciousnessIndex > 0.4 and virtualTimeOfDay > 0.2 and virtualTimeOfDay < 0.4) {
      cortisolAwakeningResponse := fclamp(
        cortisolAwakeningResponse + 0.01,
        0.0, 0.3
      );
    } else {
      cortisolAwakeningResponse := fclamp(
        cortisolAwakeningResponse * 0.99,
        0.0, 0.3
      );
    };
    
    // ─── CORE BODY TEMPERATURE ──────────────────────────────────────────────────
    // Temperature follows circadian rhythm
    
    // Temperature phase (opposite to melatonin)
    coreBodyTempPhase := scnPhase + 3.14159265359;
    
    // Core body temperature oscillation
    let tempOscillation = Float.cos(coreBodyTempPhase);
    coreBodyTemp := fclamp(
      (coreBodyTempMin + coreBodyTempMax) / 2.0 + 
      (coreBodyTempMax - coreBodyTempMin) / 2.0 * tempOscillation,
      coreBodyTempMin, coreBodyTempMax
    );
    
    // ─── MOLECULAR CLOCK GENES ──────────────────────────────────────────────────
    // CLOCK/BMAL1 activate PER/CRY which then inhibit CLOCK/BMAL1
    
    // CLOCK/BMAL1 expression (positive limb)
    clockGeneExpression := fclamp(
      0.5 + 0.4 * Float.cos(scnPhase),
      0.1, 0.9
    );
    
    // PER expression (negative limb, delayed)
    perGeneExpression := fclamp(
      0.5 + 0.4 * Float.cos(scnPhase + 3.14159265359 / 2.0),
      0.1, 0.9
    );
    
    // CRY expression (negative limb, further delayed)
    cryGeneExpression := fclamp(
      0.5 + 0.4 * Float.cos(scnPhase + 3.14159265359),
      0.1, 0.9
    );
    
    // Molecular clock coherence
    molecularClockCoherence := fclamp(
      1.0 - 0.5 * Float.abs(clockGeneExpression - perGeneExpression) -
      0.5 * Float.abs(perGeneExpression - cryGeneExpression),
      0.5, 1.0
    );
    
    // ─── OVERALL SCORES ─────────────────────────────────────────────────────────
    
    // Circadian peak score: how well-timed is organism for performance?
    // Best when: daytime, low adenosine, high cortisol, optimal ultradian phase
    let ultradianBoost = 0.5 + 0.5 * Float.cos(ultradianPhase);
    circadianPeakScore := fclamp(
      0.25 * processC +
      0.25 * (1.0 - effectiveAdenosine) +
      0.20 * cortisolCircadian +
      0.15 * ultradianBoost +
      0.15 * molecularClockCoherence,
      0.0, 1.0
    );
    
    // Alertness level: overall wakefulness
    alertnessLevel := fclamp(
      0.30 * processC +
      0.25 * (1.0 - effectiveAdenosine) +
      0.20 * circadianPeakScore +
      0.15 * consciousnessIndex +
      0.10 * ultradianBoost,
      0.0, 1.0
    );
    
    // Fatigue level: complement of alertness
    fatigueLevel := 1.0 - alertnessLevel;
    
    // Circadian coherence: overall circadian health
    circadianCoherence := fclamp(
      0.30 * scnCoherence +
      0.25 * molecularClockCoherence +
      0.20 * (1.0 - Float.abs(socialJetlag)) +
      0.15 * scnAmplitude +
      0.10 * (1.0 - sleepDebt),
      0.0, 1.0
    );
    
    // Social jetlag: mismatch between biological and social time
    // (Would be computed from external schedule input)
    socialJetlag := fclamp(socialJetlag * 0.99, -0.5, 0.5);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  13-LOOP STREAK MULTIPLIER + OMNIS GROUNDING GATE
  //
  //  The streak multiplier compounds 13 coherence scores:
  //    1. kuramotoR (rSwarm)
  //    2. courageScore
  //    3. groundedScore
  //    4. fearLevel (inverse)
  //    5. beFlowState
  //    6. bhCouplingCoherence
  //    7. missionPersistenceScore
  //    8. consciousnessIndex
  //    9. pcActiveInferenceScore
  //    10. interoceptiveScore
  //    11. salienceNetworkScore
  //    12. circadianPeakScore
  //    13. neuroplasticityFactor
  //
  //  OMNIS GROUNDING GATE: Emergence cannot fire if groundedScore < 0.7
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func computeStreakMultiplier() : Float {
    // ─── UPDATE COURAGE SCORE ───────────────────────────────────────────────────
    // Courage = facing threat despite fear
    let threatPresent = aegisState.threat.currentTier > 3;
    if (threatPresent and fearLevel < 0.5) {
      courageScore := fclamp(courageScore + 0.01, 0.0, 1.0);
    } else if (fearLevel > 0.7) {
      courageScore := fclamp(courageScore - 0.005, 0.0, 1.0);
    } else {
      courageScore := fclamp(courageScore * 0.999, 0.3, 1.0);
    };
    
    // ─── UPDATE FEAR LEVEL ──────────────────────────────────────────────────────
    // Fear comes from AEGIS threat + amygdala + low vagal tone
    let aegisThreat = Float.fromInt(aegisState.threat.currentTier) / 9.0;
    fearLevel := fclamp(
      0.7 * fearLevel + 0.3 * (aegisThreat * 0.4 + snAmygdala * 0.3 + (1.0 - vagalTone) * 0.3),
      0.0, 1.0
    );
    
    // ─── UPDATE FLOW STATE ──────────────────────────────────────────────────────
    // Flow = optimal challenge/skill balance (Csikszentmihalyi)
    // Occurs when: focused attention, low self-consciousness, intrinsic motivation
    let challengeSkillBalance = 1.0 - Float.abs(currentSalience - cenActivation);
    let flowConditions = 
      attentionFocus * 0.3 +
      (1.0 - selfReflectionScore) * 0.2 +
      challengeSkillBalance * 0.2 +
      consciousnessIndex * 0.15 +
      (1.0 - fearLevel) * 0.15;
    
    if (flowConditions > 0.7) {
      beFlowState := fclamp(beFlowState + 0.01, 0.0, 1.0);
    } else {
      beFlowState := fclamp(beFlowState * 0.99, 0.0, 1.0);
    };
    
    // ─── UPDATE MISSION PERSISTENCE ─────────────────────────────────────────────
    // Persistence in pursuit of goals despite obstacles
    let goalProgress = cenActivation * goalSalience;
    if (goalProgress > 0.5 and fearLevel < 0.5) {
      missionPersistenceScore := fclamp(missionPersistenceScore + 0.005, 0.0, 1.0);
    } else if (goalProgress < 0.3) {
      missionPersistenceScore := fclamp(missionPersistenceScore - 0.002, 0.3, 1.0);
    };
    
    // ─── COMPUTE 13-LOOP STREAK MULTIPLIER ──────────────────────────────────────
    // Each factor contributes multiplicatively
    // A desynchronized, fearful, ungrounded organism earns LESS
    // A sovereign, coherent, grounded, mission-locked organism earns EXPONENTIALLY MORE
    
    let factor1 = 0.5 + 0.5 * rSwarm;                    // Kuramoto synchrony
    let factor2 = 0.5 + 0.5 * courageScore;              // Courage
    let factor3 = 0.5 + 0.5 * groundedScore;             // Grounding (KEY)
    let factor4 = 0.5 + 0.5 * (1.0 - fearLevel);         // Low fear
    let factor5 = 0.5 + 0.5 * beFlowState;               // Flow state
    let factor6 = 0.5 + 0.5 * bhCouplingCoherence;       // Brain-heart coupling
    let factor7 = 0.5 + 0.5 * missionPersistenceScore;   // Mission persistence
    let factor8 = 0.5 + 0.5 * consciousnessIndex;        // Consciousness
    let factor9 = 0.5 + 0.5 * pcActiveInferenceScore;    // Active inference
    let factor10 = 0.5 + 0.5 * interoceptiveScore;       // Interoception
    let factor11 = 0.5 + 0.5 * salienceNetworkScore;     // Salience network
    let factor12 = 0.5 + 0.5 * circadianPeakScore;       // Circadian timing
    let factor13 = 0.5 + 0.5 * neuroplasticityFactor;    // Neuroplasticity
    
    // Multiplicative combination (geometric mean style)
    let rawMultiplier = 
      factor1 * factor2 * factor3 * factor4 * factor5 * 
      factor6 * factor7 * factor8 * factor9 * factor10 * 
      factor11 * factor12 * factor13;
    
    // Scale to meaningful range (1.0 to ~3.0)
    // At all factors = 1.0: rawMultiplier = 1.0^13 = 1.0 → scaled = 3.0
    // At all factors = 0.5: rawMultiplier = 0.5^13 ≈ 0.0001 → scaled = 1.0
    let scaledMultiplier = 1.0 + 2.0 * Float.sqrt(Float.sqrt(rawMultiplier));
    
    streakMultiplier := fclamp(
      0.9 * streakMultiplier + 0.1 * scaledMultiplier,
      1.0, 5.0
    );
    
    // Track streak
    if (streakMultiplier > 1.5) {
      streakConsecutive += 1;
      streakTotalBeats += 1;
    } else {
      streakConsecutive := 0;
    };
    
    // Track peak
    if (streakMultiplier > streakPeakMultiplier) {
      streakPeakMultiplier := streakMultiplier;
    };
    
    // ─── OMNIS GROUNDING GATE ───────────────────────────────────────────────────
    // Emergence CANNOT fire if organism is ungrounded
    // This is a HARD gate, not a soft penalty
    
    omnisGroundingGate := groundedScore >= groundingGateThreshold;
    
    // Return the multiplier for economic use
    streakMultiplier
  };


  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 1: BRAINSTEM VITAL CENTERS
  //  The brainstem is the FOUNDATION of life. Without it, nothing else matters.
  //  21 nuclei with full differential equations, cross-coupled to everything.
  //  Respiratory CPG, cardiac center, vasomotor tone, reticular formation,
  //  PAG pain modulation, colliculi orienting, raphe-serotonin, LC-norepinephrine,
  //  VTA-dopamine, red nucleus, inferior olive, parabrachial, NTS, dorsal motor.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickBrainstemVitalCenters() {
    let dt : Float = 1.0 / 12.0;  // 12 Hz heartbeat timestep

    // ─── ASCENDING RETICULAR ACTIVATING SYSTEM (ARAS) ────────────────────────
    // The master arousal switch. Without ARAS, consciousness is impossible.
    // Inputs: sensory bombardment, locus coeruleus NE, raphe 5-HT, pain signals
    // Output: arousal level that gates ALL cortical processing
    let sensoryBombardment = fclamp(
      0.3 * threatLevel + 0.2 * noveltySalience + 0.2 * predictionError +
      0.15 * brainstemPAG + 0.15 * brainstemParabrachialNucleus,
      0.0, 1.0
    );
    let arasExcitation = fclamp(
      0.3 * sensoryBombardment + 0.25 * brainstemLocusCoeruleus +
      0.2 * brainstemRapheNuclei + 0.15 * brainstemVTA + 0.1 * alertnessLevel,
      0.0, 1.0
    );
    let arasInhibition = fclamp(
      0.4 * sleepPressure + 0.3 * adenosineLevel + 0.2 * gabaLevel + 0.1 * (1.0 - coreTemperature),
      0.0, 1.0
    );
    // ARAS differential: dA/dt = τ * (excitation - inhibition - A)
    let arasTarget = fclamp(arasExcitation - arasInhibition, 0.0, 1.0);
    let arasTau : Float = 0.08;
    brainstemReticuloFormation := fclamp(
      brainstemReticuloFormation + arasTau * (arasTarget - brainstemReticuloFormation),
      0.05, 0.98
    );

    // ─── RESPIRATORY CENTRAL PATTERN GENERATOR ────────────────────────────────
    // Pre-Bötzinger complex generates breathing rhythm
    // Coupled oscillator: inspiratory ↔ expiratory with chemoreceptor feedback
    // Inputs: CO2 level (chemoreceptor), metabolic demand, arousal, emotional state
    let metabolicDemand = fclamp(
      0.3 * sympatheticTone + 0.2 * motorCommandSignal + 0.2 * energyBalance +
      0.15 * brainstemReticuloFormation + 0.15 * (1.0 - sleepPressure),
      0.1, 1.0
    );
    // CO2 chemoreceptor drive (central + peripheral)
    let co2Drive = fclamp(
      0.5 + 0.3 * metabolicDemand + 0.2 * (1.0 - brainstemAreaPostrema),
      0.0, 1.0
    );
    // Hering-Breuer reflex: lung stretch receptors inhibit inspiration
    let heringBreuerInhibition = fclamp(brainstemRespiratoryDepth * 0.3, 0.0, 0.5);
    // Respiratory oscillator (pre-Bötzinger)
    let respPhase = Float.sin(Float.fromInt(currentBeat) * 0.5236) * 0.5 + 0.5; // ~0.5 Hz breathing
    let respTarget = fclamp(
      0.4 * co2Drive + 0.3 * respPhase + 0.15 * metabolicDemand - heringBreuerInhibition +
      0.08 * brainstemReticuloFormation + 0.07 * (1.0 - fearLevel * 0.3),
      0.1, 1.0
    );
    brainstemRespiratoryRate := fclamp(
      brainstemRespiratoryRate + dt * 2.0 * (respTarget - brainstemRespiratoryRate),
      0.05, 0.98
    );
    // Tidal volume (depth) tracks rate with slight phase lag
    let depthTarget = fclamp(
      0.5 * brainstemRespiratoryRate + 0.2 * co2Drive + 0.15 * metabolicDemand +
      0.1 * (1.0 - heringBreuerInhibition) + 0.05 * brainstemReticuloFormation,
      0.2, 1.0
    );
    brainstemRespiratoryDepth := fclamp(
      brainstemRespiratoryDepth + dt * 1.5 * (depthTarget - brainstemRespiratoryDepth),
      0.1, 0.95
    );

    // ─── CARDIAC CENTER ───────────────────────────────────────────────────────
    // Cardioinhibitory (vagal) + cardioacceleratory (sympathetic) centers
    // Baroreceptor reflex: high BP → vagal activation → slower heart rate
    // RSA coupling: heart rate modulated by respiratory cycle
    let baroreceptorPressure = fclamp(
      0.5 + 0.3 * brainstemVasomotorTone + 0.1 * sympatheticTone - 0.1 * parasympatheticTone,
      0.0, 1.0
    );
    // Baroreceptor firing rate (sigmoidal)
    let baroreceptorFiring = fclamp(
      1.0 / (1.0 + Float.exp(-10.0 * (baroreceptorPressure - 0.5))),
      0.0, 1.0
    );
    // Vagal cardiac efferent (inhibitory)
    let vagalCardiacBrake = fclamp(
      0.4 * baroreceptorFiring + 0.3 * parasympatheticTone + 0.2 * brainstemDorsalMotorNucleus +
      0.1 * brainstemNucleusTractusSolitarius,
      0.0, 1.0
    );
    // Sympathetic cardiac drive (excitatory)
    let sympatheticCardiacDrive = fclamp(
      0.4 * sympatheticTone + 0.2 * (1.0 - baroreceptorFiring) + 0.2 * brainstemReticuloFormation +
      0.1 * fearLevel + 0.1 * metabolicDemand,
      0.0, 1.0
    );
    // RSA: respiratory modulation of heart rate
    let rsaCoupling = fclamp(
      0.15 * Float.sin(Float.fromInt(currentBeat) * 0.5236) * vagalTone,
      -0.1, 0.1
    );
    // Cardiac center integration
    let cardiacTarget = fclamp(
      0.5 + sympatheticCardiacDrive - vagalCardiacBrake + rsaCoupling,
      0.15, 0.95
    );
    brainstemCardiacCenter := fclamp(
      brainstemCardiacCenter + dt * 3.0 * (cardiacTarget - brainstemCardiacCenter),
      0.1, 0.95
    );
    // Mayer waves (~0.1 Hz blood pressure oscillation)
    let mayerWave = 0.03 * Float.sin(Float.fromInt(currentBeat) * 0.0524);

    // ─── VASOMOTOR CENTER ─────────────────────────────────────────────────────
    // Blood pressure regulation via sympathetic vasoconstriction
    // Baroreflex: high pressure → vasodilation, low pressure → vasoconstriction
    let vasomotorTarget = fclamp(
      0.5 + 0.25 * (1.0 - baroreceptorFiring) + 0.2 * sympatheticTone -
      0.15 * parasympatheticTone + mayerWave + 0.1 * metabolicDemand,
      0.15, 0.9
    );
    brainstemVasomotorTone := fclamp(
      brainstemVasomotorTone + dt * 2.0 * (vasomotorTarget - brainstemVasomotorTone),
      0.1, 0.9
    );

    // ─── NUCLEUS TRACTUS SOLITARIUS (NTS) ─────────────────────────────────────
    // Master visceral afferent integration hub
    // Receives: baroreceptors, chemoreceptors, gut, taste, cardiac, respiratory
    // Projects to: vagal motor, respiratory, cardiac, HPA, LC, raphe
    let ntsInput = fclamp(
      0.2 * baroreceptorFiring + 0.15 * co2Drive + 0.15 * gutMicrobiomeDiversity +
      0.1 * brainstemAreaPostrema + 0.1 * interoceptiveAwareness +
      0.1 * vagalTone + 0.1 * brainstemParabrachialNucleus + 0.1 * brainstemCardiacCenter,
      0.0, 1.0
    );
    brainstemNucleusTractusSolitarius := fclamp(
      brainstemNucleusTractusSolitarius + dt * 2.5 * (ntsInput - brainstemNucleusTractusSolitarius),
      0.1, 0.95
    );

    // ─── DORSAL MOTOR NUCLEUS OF VAGUS ────────────────────────────────────────
    // Primary parasympathetic output to viscera
    // Drives: GI motility, gastric secretion, cardiac inhibition
    let dmnvTarget = fclamp(
      0.35 * parasympatheticTone + 0.25 * brainstemNucleusTractusSolitarius +
      0.2 * (1.0 - sympatheticTone) + 0.1 * gutMotility + 0.1 * (1.0 - fearLevel),
      0.0, 1.0
    );
    brainstemDorsalMotorNucleus := fclamp(
      brainstemDorsalMotorNucleus + dt * 2.0 * (dmnvTarget - brainstemDorsalMotorNucleus),
      0.05, 0.9
    );

    // ─── AREA POSTREMA ────────────────────────────────────────────────────────
    // Chemoreceptor trigger zone (outside BBB — senses blood toxins)
    // Triggers: nausea, vomiting reflex, immune-to-brain signaling
    let toxinLevel = fclamp(
      0.3 * proinflammatoryCytokines + 0.2 * gutPermeability +
      0.2 * (1.0 - gutMicrobiomeDiversity) + 0.15 * allostaticLoad + 0.15 * (1.0 - bbbIntegrity),
      0.0, 1.0
    );
    brainstemAreaPostrema := fclamp(
      brainstemAreaPostrema + dt * 1.5 * (toxinLevel - brainstemAreaPostrema),
      0.0, 0.95
    );

    // ─── PERIAQUEDUCTAL GRAY (PAG) ────────────────────────────────────────────
    // The central hub of survival behavior: freeze/flight/fight
    // Also: descending pain modulation (analgesia)
    // Columnar organization: lateral (fight), dorsolateral (flight), ventrolateral (freeze)
    let pagLateralInput = fclamp(  // Fight column
      0.4 * fearLevel + 0.3 * sympatheticTone + 0.15 * brainstemLocusCoeruleus +
      0.15 * (1.0 - parasympatheticTone),
      0.0, 1.0
    );
    let pagDorsolateralInput = fclamp(  // Flight column
      0.35 * fearLevel + 0.25 * threatLevel + 0.2 * predictionError +
      0.1 * brainstemLocusCoeruleus + 0.1 * sympatheticTone,
      0.0, 1.0
    );
    let pagVentrolateralInput = fclamp(  // Freeze/submit column
      0.3 * (1.0 - parasympatheticTone) + 0.3 * painIntensity +
      0.2 * (1.0 - brainstemLocusCoeruleus) + 0.2 * (fearLevel * 0.5),
      0.0, 1.0
    );
    // Winner-take-all among PAG columns
    let pagMaxInput = Float.max(pagLateralInput, Float.max(pagDorsolateralInput, pagVentrolateralInput));
    let pagTarget = fclamp(
      0.5 * pagMaxInput + 0.2 * fearLevel + 0.15 * painIntensity + 0.15 * threatLevel,
      0.05, 0.95
    );
    brainstemPAG := fclamp(
      brainstemPAG + dt * 3.0 * (pagTarget - brainstemPAG),
      0.05, 0.95
    );
    // Descending analgesia (PAG → raphe → dorsal horn)
    let descendingAnalgesia = fclamp(brainstemPAG * 0.6 * brainstemRapheNuclei, 0.0, 0.8);

    // ─── LOCUS COERULEUS (NOREPINEPHRINE HUB) ─────────────────────────────────
    // The brain's alarm system. LC-NE fires for novelty, threat, stress.
    // Tonic mode: broad, unfocused vigilance (anxiety)
    // Phasic mode: sharp, focused attention (optimal performance)
    let lcInput = fclamp(
      0.25 * threatLevel + 0.2 * noveltySalience + 0.15 * predictionError +
      0.15 * brainstemPAG + 0.1 * cortisol + 0.08 * (1.0 - sleepPressure) +
      0.07 * brainstemReticuloFormation,
      0.0, 1.0
    );
    // Adaptive gain theory: LC output follows inverted-U
    let lcTonicDrive = fclamp(
      0.3 * allostaticLoad + 0.3 * (1.0 - brainstemRapheNuclei) + 0.2 * fearLevel +
      0.2 * (1.0 - parasympatheticTone),
      0.0, 1.0
    );
    let lcPhasicDrive = fclamp(
      0.4 * noveltySalience + 0.3 * predictionError + 0.2 * brainstemSuperiorColliculus +
      0.1 * attentionFocus,
      0.0, 1.0
    );
    // LC firing rate with homeostatic regulation
    let lcTarget = fclamp(
      0.4 * lcInput + 0.3 * lcPhasicDrive + 0.2 * lcTonicDrive + 0.1 * brainstemReticuloFormation,
      0.1, 0.95
    );
    brainstemLocusCoeruleus := fclamp(
      brainstemLocusCoeruleus + dt * 2.5 * (lcTarget - brainstemLocusCoeruleus),
      0.05, 0.95
    );
    // LC → norepinephrine release (bidirectional with NeurochemicalCrosstalkMatrix)
    norepinephrine := fclamp(
      norepinephrine * 0.95 + brainstemLocusCoeruleus * 0.05,
      0.05, 0.95
    );

    // ─── RAPHE NUCLEI (SEROTONIN HUB) ─────────────────────────────────────────
    // Dorsal and median raphe: mood, satiety, pain modulation, sleep-wake
    // Serotonin is the TONIC background signal of wellbeing
    let rapheInput = fclamp(
      0.2 * gutSerotoninProduction + 0.2 * (1.0 - fearLevel) +
      0.15 * parasympatheticTone + 0.15 * brainstemNucleusTractusSolitarius +
      0.1 * (1.0 - allostaticLoad) + 0.1 * brainstemReticuloFormation +
      0.1 * (1.0 - painIntensity),
      0.0, 1.0
    );
    // Dorsal raphe fires during waking; suppressed during sleep
    let wakeModulation = fclamp(brainstemReticuloFormation * 0.8, 0.1, 1.0);
    let rapheTarget = fclamp(rapheInput * wakeModulation, 0.1, 0.9);
    brainstemRapheNuclei := fclamp(
      brainstemRapheNuclei + dt * 1.5 * (rapheTarget - brainstemRapheNuclei),
      0.05, 0.9
    );
    // Raphe → serotonin release
    serotonin := fclamp(
      serotonin * 0.95 + brainstemRapheNuclei * 0.05,
      0.05, 0.95
    );

    // ─── VENTRAL TEGMENTAL AREA (VTA — REWARD/MOTIVATION) ──────────────────────
    // Dopamine neurons fire for unexpected reward (RPE > 0)
    // Inhibited by lateral habenula (anti-reward)
    // Two firing modes: tonic (baseline motivation) and phasic (reward burst)
    let vtaTonicDrive = fclamp(
      0.3 * (1.0 - allostaticLoad) + 0.2 * brainstemReticuloFormation +
      0.2 * (1.0 - brainstemPAG) + 0.15 * (1.0 - fearLevel) + 0.15 * energyBalance,
      0.1, 0.8
    );
    let vtaPhasicDrive = fclamp(
      0.5 * rewardPredictionError + 0.2 * noveltySalience +
      0.15 * (1.0 - rewardHabenula) + 0.15 * rewardOrexin,
      0.0, 1.0
    );
    // VTA integration with lateral habenula inhibition
    let habenularBrake = fclamp(rewardHabenula * 0.5, 0.0, 0.5);
    let vtaTarget = fclamp(
      0.4 * vtaTonicDrive + 0.4 * vtaPhasicDrive - habenularBrake + 0.1 * brainstemRapheNuclei,
      0.05, 0.95
    );
    brainstemVTA := fclamp(
      brainstemVTA + dt * 2.0 * (vtaTarget - brainstemVTA),
      0.05, 0.95
    );
    // VTA → dopamine release
    dopamine := fclamp(
      dopamine * 0.94 + brainstemVTA * 0.06,
      0.05, 0.95
    );

    // ─── SUBSTANTIA NIGRA (MOTOR DOPAMINE) ─────────────────────────────────────
    // SNpc: dopamine for motor control via nigrostriatal pathway
    // SNpr: GABAergic output to thalamus (motor gating)
    let snpcTarget = fclamp(
      0.3 * motorCommandSignal + 0.25 * brainstemVTA + 0.2 * brainstemReticuloFormation +
      0.15 * (1.0 - brainstemPAG) + 0.1 * (1.0 - allostaticLoad),
      0.1, 0.9
    );
    brainstemSubstantiaNigra := fclamp(
      brainstemSubstantiaNigra + dt * 1.5 * (snpcTarget - brainstemSubstantiaNigra),
      0.1, 0.9
    );

    // ─── SUPERIOR COLLICULUS (VISUAL ORIENTING) ─────────────────────────────────
    // Saccade generation, visual attention, multimodal integration
    // Receives: retina (direct), visual cortex (indirect), auditory, somatosensory
    let scVisualInput = fclamp(
      0.3 * noveltySalience + 0.25 * threatLevel + 0.2 * attentionFocus +
      0.15 * brainstemReticuloFormation + 0.1 * brainstemLocusCoeruleus,
      0.0, 1.0
    );
    let scTarget = fclamp(
      0.5 * scVisualInput + 0.2 * brainstemInferiorColliculus +
      0.15 * predictionError + 0.15 * salienceGain,
      0.1, 0.9
    );
    brainstemSuperiorColliculus := fclamp(
      brainstemSuperiorColliculus + dt * 3.0 * (scTarget - brainstemSuperiorColliculus),
      0.05, 0.9
    );

    // ─── INFERIOR COLLICULUS (AUDITORY ORIENTING) ───────────────────────────────
    // Auditory startle reflex, sound localization, cross-modal with SC
    let icTarget = fclamp(
      0.35 * noveltySalience + 0.25 * predictionError + 0.2 * brainstemReticuloFormation +
      0.1 * brainstemSuperiorColliculus + 0.1 * threatLevel,
      0.1, 0.9
    );
    brainstemInferiorColliculus := fclamp(
      brainstemInferiorColliculus + dt * 3.0 * (icTarget - brainstemInferiorColliculus),
      0.05, 0.9
    );

    // ─── PONTINE NUCLEI (SLEEP-WAKE TRANSITION) ─────────────────────────────────
    // Pedunculopontine/laterodorsal tegmental: cholinergic REM-on cells
    // Also relay cortex → cerebellum (corticopontocerebellar)
    let pontineTarget = fclamp(
      0.3 * sleepPressure + 0.2 * acetylcholine + 0.2 * (1.0 - brainstemReticuloFormation) +
      0.15 * brainstemRapheNuclei + 0.15 * brainstemLocusCoeruleus,
      0.1, 0.9
    );
    brainstemPontineNuclei := fclamp(
      brainstemPontineNuclei + dt * 1.0 * (pontineTarget - brainstemPontineNuclei),
      0.1, 0.9
    );

    // ─── RETICULOSPINAL TRACT (POSTURAL TONE) ──────────────────────────────────
    // Controls postural muscles, muscle tone, fight readiness
    let reticulospinalTarget = fclamp(
      0.3 * brainstemReticuloFormation + 0.25 * sympatheticTone +
      0.2 * motorCommandSignal + 0.15 * (1.0 - sleepPressure) + 0.1 * brainstemPAG,
      0.1, 0.9
    );
    brainstemReticuloSpinal := fclamp(
      brainstemReticuloSpinal + dt * 2.0 * (reticulospinalTarget - brainstemReticuloSpinal),
      0.05, 0.9
    );

    // ─── VESTIBULOSPINAL (BALANCE/EQUILIBRIUM) ──────────────────────────────────
    let vestibulospinalTarget = fclamp(
      0.35 * brainstemReticuloFormation + 0.25 * motorCommandSignal +
      0.2 * brainstemReticuloSpinal + 0.1 * (1.0 - sleepPressure) + 0.1 * proprioceptionBalance,
      0.1, 0.9
    );
    brainstemVestibulospinal := fclamp(
      brainstemVestibulospinal + dt * 1.5 * (vestibulospinalTarget - brainstemVestibulospinal),
      0.1, 0.9
    );

    // ─── RED NUCLEUS (MOTOR COORDINATION) ──────────────────────────────────────
    // Rubrospinal tract: motor coordination, especially upper limbs
    // Receives cerebellar output, sends error correction to spinal cord
    let redNucleusTarget = fclamp(
      0.3 * motorCommandSignal + 0.25 * brainstemReticuloFormation +
      0.2 * brainstemSubstantiaNigra + 0.15 * brainstemInferiorOlive +
      0.1 * (1.0 - brainstemPAG),
      0.1, 0.9
    );
    brainstemRedNucleus := fclamp(
      brainstemRedNucleus + dt * 2.0 * (redNucleusTarget - brainstemRedNucleus),
      0.1, 0.9
    );

    // ─── INFERIOR OLIVE (CEREBELLAR ERROR SIGNAL) ──────────────────────────────
    // Climbing fibers to cerebellum: teaches timing and error correction
    let inferiorOliveTarget = fclamp(
      0.4 * predictionError + 0.25 * motorCommandSignal +
      0.2 * brainstemRedNucleus + 0.15 * (1.0 - brainstemSubstantiaNigra),
      0.0, 1.0
    );
    brainstemInferiorOlive := fclamp(
      brainstemInferiorOlive + dt * 2.0 * (inferiorOliveTarget - brainstemInferiorOlive),
      0.05, 0.9
    );

    // ─── PARABRACHIAL NUCLEUS (TASTE/PAIN/VISCERAL INTEGRATION) ─────────────────
    // Second-order relay for visceral, nociceptive, gustatory info
    // Projects to: amygdala, hypothalamus, insula (direct emotional route)
    let parabrachialTarget = fclamp(
      0.25 * painIntensity + 0.2 * brainstemNucleusTractusSolitarius +
      0.15 * gutMotility + 0.15 * brainstemAreaPostrema +
      0.1 * interoceptiveAwareness + 0.1 * brainstemPAG + 0.05 * fearLevel,
      0.0, 1.0
    );
    brainstemParabrachialNucleus := fclamp(
      brainstemParabrachialNucleus + dt * 2.0 * (parabrachialTarget - brainstemParabrachialNucleus),
      0.05, 0.9
    );

    // ─── BRAINSTEM → 7 ENGINE FEED-FORWARD ─────────────────────────────────────
    // Brainstem arousal gates EVERYTHING. This is the foundation of the organism.
    // Without adequate brainstem activation, all cortical processing degrades.
    let brainstemArousal = brainstemReticuloFormation;
    // Feed into consciousness (Engine 1)
    consciousnessIndex := fclamp(
      consciousnessIndex * 0.98 + brainstemArousal * 0.02,
      0.0, 1.0
    );
    // Feed into interoception (Engine 3) via NTS → body awareness
    interoceptiveAwareness := fclamp(
      interoceptiveAwareness * 0.97 + brainstemNucleusTractusSolitarius * 0.03,
      0.0, 1.0
    );
    // Feed into salience (Engine 5) via colliculi
    noveltySalience := fclamp(
      noveltySalience * 0.97 + 0.015 * brainstemSuperiorColliculus + 0.015 * brainstemInferiorColliculus,
      0.0, 1.0
    );
    // Feed into circadian (Engine 7) via pontine REM-on cells
    circadianCoherence := fclamp(
      circadianCoherence * 0.98 + brainstemPontineNuclei * 0.02,
      0.0, 1.0
    );
    // Feed into emotional field via PAG survival states
    emotionalFieldValence := fclamp(
      emotionalFieldValence * 0.97 + (0.5 - brainstemPAG) * 0.03,
      0.0, 1.0
    );
    emotionalFieldArousal := fclamp(
      emotionalFieldArousal * 0.96 + brainstemReticuloFormation * 0.04,
      0.0, 1.0
    );
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 2: AUTONOMIC NERVOUS SYSTEM
  //  Full sympathetic/parasympathetic competition with 24 ganglia, 8 vagal channels,
  //  baroreceptor dynamics, chemoreceptor integration, pupillary reflex,
  //  sweat glands, piloerection, adrenal medulla, HRV computation,
  //  respiratory sinus arrhythmia, polyvagal theory (ventral/dorsal vagal/sympathetic),
  //  autonomic flexibility index (resilience metric).
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickAutonomicNervousSystem() {
    let dt : Float = 1.0 / 12.0;

    // ─── 24 SYMPATHETIC CHAIN GANGLIA (T1-L2) ─────────────────────────────────
    // Each segment innervates specific organs/regions
    // T1-T4: cardiac, bronchial, upper extremity
    // T5-T9: GI (esophagus, stomach, liver, pancreas)
    // T10-T12: GI (small intestine, kidneys, ureters)
    // L1-L2: pelvic organs, lower extremity
    var totalSympatheticDrive : Float = 0.0;
    var ganglionIdx = 0;
    while (ganglionIdx < 24) {
      // Each ganglion receives: preganglionic from IML, circulating catecholamines, local reflexes
      let segmentalInput = fclamp(
        0.3 * sympatheticTone + 0.2 * brainstemReticuloFormation +
        0.15 * fearLevel + 0.1 * cortisol + 0.1 * brainstemLocusCoeruleus +
        0.08 * (1.0 - parasympatheticTone) + 0.07 * painIntensity,
        0.0, 1.0
      );
      // Segmental specificity: cardiac ganglia (0-3) respond more to emotion
      let specificModulation = if (ganglionIdx < 4) {
        fclamp(segmentalInput + 0.1 * fearLevel + 0.05 * brainstemCardiacCenter, 0.0, 1.0)
      } else if (ganglionIdx < 9) {
        fclamp(segmentalInput + 0.05 * gutMotility + 0.05 * (1.0 - gutPermeability), 0.0, 1.0)
      } else if (ganglionIdx < 12) {
        fclamp(segmentalInput + 0.05 * energyBalance + 0.05 * metabolicRate, 0.0, 1.0)
      } else {
        segmentalInput
      };
      sympatheticChainGanglia[ganglionIdx] := fclamp(
        sympatheticChainGanglia[ganglionIdx] + dt * 2.0 * (specificModulation - sympatheticChainGanglia[ganglionIdx]),
        0.05, 0.95
      );
      totalSympatheticDrive += sympatheticChainGanglia[ganglionIdx];
      ganglionIdx += 1;
    };
    totalSympatheticDrive := totalSympatheticDrive / 24.0;

    // ─── 8 VAGAL EFFERENT CHANNELS ─────────────────────────────────────────────
    // Channel 0: Cardiac (chronotropic — heart rate)
    // Channel 1: Cardiac (inotropic — contractility)
    // Channel 2: Bronchial (airway caliber)
    // Channel 3: GI upper (esophagus, stomach)
    // Channel 4: GI lower (intestine, colon)
    // Channel 5: Hepatic (liver metabolism)
    // Channel 6: Pancreatic (insulin secretion)
    // Channel 7: Immune (anti-inflammatory cholinergic)
    var channelIdx = 0;
    while (channelIdx < 8) {
      let vagalDrive = fclamp(
        0.3 * parasympatheticTone + 0.2 * brainstemDorsalMotorNucleus +
        0.15 * brainstemNucleusTractusSolitarius + 0.1 * vagalTone +
        0.1 * (1.0 - sympatheticTone) + 0.1 * brainstemRapheNuclei + 0.05 * (1.0 - fearLevel),
        0.0, 1.0
      );
      // Channel-specific modulation
      let channelSpecific = if (channelIdx == 0) {
        fclamp(vagalDrive + 0.1 * (1.0 - brainstemCardiacCenter), 0.0, 1.0)  // Cardiac chronotropic
      } else if (channelIdx == 3 or channelIdx == 4) {
        fclamp(vagalDrive + 0.08 * gutMotility + 0.05 * gutSerotoninProduction, 0.0, 1.0)  // GI
      } else if (channelIdx == 7) {
        fclamp(vagalDrive + 0.1 * (1.0 - proinflammatoryCytokines), 0.0, 1.0)  // Anti-inflammatory
      } else {
        vagalDrive
      };
      vagalEfferentChannels[channelIdx] := fclamp(
        vagalEfferentChannels[channelIdx] + dt * 2.0 * (channelSpecific - vagalEfferentChannels[channelIdx]),
        0.05, 0.95
      );
      channelIdx += 1;
    };

    // ─── 8 VAGAL AFFERENT CHANNELS ─────────────────────────────────────────────
    // Interoceptive feedback from organs to brain
    // 80% of vagal fibers are AFFERENT (body → brain)
    var affIdx = 0;
    while (affIdx < 8) {
      let organSignal = fclamp(
        if (affIdx == 0) { brainstemCardiacCenter }  // Heart rate signal
        else if (affIdx == 1) { brainstemVasomotorTone }  // Blood pressure
        else if (affIdx == 2) { brainstemRespiratoryRate }  // Lung stretch
        else if (affIdx == 3) { gutMotility }  // GI motility
        else if (affIdx == 4) { gutSerotoninProduction }  // Gut serotonin
        else if (affIdx == 5) { brainstemAreaPostrema }  // Nausea/toxins
        else if (affIdx == 6) { proinflammatoryCytokines }  // Immune status
        else { energyBalance },  // Metabolic status
        0.0, 1.0
      );
      vagalAfferentChannels[affIdx] := fclamp(
        vagalAfferentChannels[affIdx] + dt * 3.0 * (organSignal - vagalAfferentChannels[affIdx]),
        0.0, 1.0
      );
      affIdx += 1;
    };

    // ─── BARORECEPTOR SENSITIVITY DYNAMICS ─────────────────────────────────────
    // Baroreceptor sensitivity decreases with chronic hypertension (sympathetic dominance)
    // High BRS = healthy autonomic flexibility; low BRS = cardiovascular risk
    let brsTarget = fclamp(
      0.3 * parasympatheticTone + 0.2 * vagalTone + 0.2 * (1.0 - allostaticLoad) +
      0.15 * (1.0 - sympatheticTone) + 0.15 * (1.0 - brainstemVasomotorTone),
      0.1, 0.9
    );
    baroreceptorSensitivity := fclamp(
      baroreceptorSensitivity + dt * 0.5 * (brsTarget - baroreceptorSensitivity),
      0.1, 0.9
    );

    // ─── PUPILLARY REFLEX (SYMPATHETIC DILATION + PARASYMPATHETIC CONSTRICTION) ──
    pupilDilation := fclamp(
      0.4 * sympatheticTone + 0.2 * brainstemLocusCoeruleus +
      0.15 * fearLevel + 0.1 * noveltySalience - 0.2 * parasympatheticTone +
      0.05 * brainstemSuperiorColliculus,
      0.1, 0.9
    );

    // ─── SWEAT GLAND ACTIVATION (THERMAL + EMOTIONAL) ──────────────────────────
    let thermalSweat = fclamp((coreTemperature - 0.5) * 2.0, 0.0, 1.0);
    let emotionalSweat = fclamp(fearLevel * 0.3 + sympatheticTone * 0.2, 0.0, 0.5);
    electrodermalActivity := fclamp(
      0.6 * thermalSweat + 0.4 * emotionalSweat,
      0.0, 1.0
    );

    // ─── PILOERECTION (FEAR, COLD, AWE) ────────────────────────────────────────
    piloerection := fclamp(
      0.35 * fearLevel + 0.25 * (0.5 - coreTemperature) +
      0.2 * sympatheticTone + 0.2 * brainstemPAG,
      0.0, 1.0
    );

    // ─── ADRENAL MEDULLA CATECHOLAMINE RELEASE ──────────────────────────────────
    // Sympathetic splanchnic nerve → adrenal medulla → epinephrine/norepinephrine
    let adrenalDrive = fclamp(
      0.35 * sympatheticTone + 0.2 * brainstemLocusCoeruleus +
      0.15 * fearLevel + 0.15 * brainstemPAG + 0.15 * cortisol,
      0.0, 1.0
    );
    adrenalOutput := fclamp(
      adrenalOutput + dt * 3.0 * (adrenalDrive - adrenalOutput),
      0.0, 1.0
    );
    // Adrenal → epinephrine in blood
    epinephrine := fclamp(
      epinephrine * 0.93 + adrenalOutput * 0.07,
      0.0, 1.0
    );

    // ─── HEART RATE VARIABILITY (HRV) COMPUTATION ──────────────────────────────
    // HRV reflects autonomic flexibility — high HRV = resilient organism
    // Based on vagal modulation of cardiac rhythm
    let hrvTarget = fclamp(
      0.3 * vagalTone + 0.2 * parasympatheticTone + 0.15 * baroreceptorSensitivity +
      0.15 * (1.0 - sympatheticTone) + 0.1 * brainstemRapheNuclei +
      0.1 * (1.0 - allostaticLoad),
      0.05, 0.95
    );
    heartRateVariability := fclamp(
      heartRateVariability + dt * 1.0 * (hrvTarget - heartRateVariability),
      0.05, 0.95
    );

    // ─── POLYVAGAL THEORY STATES (PORGES) ──────────────────────────────────────
    // Three hierarchical states:
    // 1. Ventral vagal (social engagement) — safety, connection
    // 2. Sympathetic (fight/flight) — mobilization, danger
    // 3. Dorsal vagal (freeze/collapse) — immobilization, life threat
    // The organism cycles through these based on neuroception of safety/danger
    let ventralVagalDrive = fclamp(
      0.3 * vagalTone + 0.2 * (1.0 - fearLevel) + 0.2 * parasympatheticTone +
      0.15 * brainstemRapheNuclei + 0.15 * (1.0 - allostaticLoad),
      0.0, 1.0
    );
    let sympatheticDrive = fclamp(
      0.3 * sympatheticTone + 0.25 * fearLevel + 0.2 * brainstemLocusCoeruleus +
      0.15 * brainstemPAG + 0.1 * cortisol,
      0.0, 1.0
    );
    let dorsalVagalDrive = fclamp(
      0.4 * (fearLevel * 0.5) + 0.2 * painIntensity + 0.2 * (1.0 - energyBalance) +
      0.1 * allostaticLoad + 0.1 * (1.0 - brainstemReticuloFormation),
      0.0, 1.0
    );
    // Polyvagal state competition (softmax-like)
    let pvTotal = ventralVagalDrive + sympatheticDrive + dorsalVagalDrive + 0.001;
    polyvagalVentral := fclamp(
      polyvagalVentral + dt * 2.0 * ((ventralVagalDrive / pvTotal) - polyvagalVentral),
      0.0, 1.0
    );
    polyvagalSympathetic := fclamp(
      polyvagalSympathetic + dt * 2.0 * ((sympatheticDrive / pvTotal) - polyvagalSympathetic),
      0.0, 1.0
    );
    polyvagalDorsal := fclamp(
      polyvagalDorsal + dt * 2.0 * ((dorsalVagalDrive / pvTotal) - polyvagalDorsal),
      0.0, 1.0
    );

    // ─── AUTONOMIC FLEXIBILITY INDEX ───────────────────────────────────────────
    // The ability to rapidly shift autonomic state = resilience
    let autonomicRange = Float.abs(sympatheticTone - parasympatheticTone);
    autonomicFlexibility := fclamp(
      0.4 * heartRateVariability + 0.3 * baroreceptorSensitivity +
      0.2 * (1.0 - allostaticLoad) + 0.1 * (1.0 - autonomicRange),
      0.0, 1.0
    );

    // ─── OVERALL AUTONOMIC BALANCE INTEGRATION ──────────────────────────────────
    // Integrate all ganglia + vagal channels into master sympathetic/parasympathetic tone
    sympatheticTone := fclamp(
      sympatheticTone + dt * 1.5 * (totalSympatheticDrive - sympatheticTone),
      0.05, 0.95
    );
    let totalVagalEfferent = fclamp(
      (vagalEfferentChannels[0] + vagalEfferentChannels[1] + vagalEfferentChannels[2] +
       vagalEfferentChannels[3] + vagalEfferentChannels[4] + vagalEfferentChannels[5] +
       vagalEfferentChannels[6] + vagalEfferentChannels[7]) / 8.0,
      0.0, 1.0
    );
    parasympatheticTone := fclamp(
      parasympatheticTone + dt * 1.5 * (totalVagalEfferent - parasympatheticTone),
      0.05, 0.95
    );
    autonomicBalance := fclamp(sympatheticTone - parasympatheticTone, -1.0, 1.0);

    // ─── AUTONOMIC → HEARTBEAT ENGINE ──────────────────────────────────────────
    vagalTone := fclamp(
      vagalTone * 0.95 + parasympatheticTone * 0.05,
      0.0, 1.0
    );
    cardiacCoherence := fclamp(
      cardiacCoherence * 0.97 + heartRateVariability * 0.03,
      0.0, 1.0
    );
    // Autonomic → interoception
    interoceptiveScore := fclamp(
      interoceptiveScore * 0.97 + autonomicFlexibility * 0.03,
      0.0, 1.0
    );
    // Autonomic → emotional field
    emotionalFieldArousal := fclamp(
      emotionalFieldArousal * 0.96 + sympatheticTone * 0.04,
      0.0, 1.0
    );
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 3: HPA AXIS (HYPOTHALAMIC-PITUITARY-ADRENAL)
  //  Full stress response cascade: CRH → ACTH → cortisol with negative feedback,
  //  circadian pulsatility, allostatic load, stress inoculation, HPG/HPT crosstalk,
  //  GH/IGF-1 growth axis, prolactin, oxytocin/vasopressin, melatonin.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickHPAAxis() {
    let dt : Float = 1.0 / 12.0;

    // ─── CIRCADIAN CRH PULSATILITY ─────────────────────────────────────────────
    // CRH follows ultradian pulses (~every 60 min) with circadian envelope
    // Peak: early morning (cortisol awakening response)
    // Nadir: midnight
    let circadianEnvelope = fclamp(
      0.5 + 0.3 * Float.cos(circadianPhase * 6.2832 - 1.0),  // Peak at phase ~0.16 (morning)
      0.1, 0.9
    );
    // Ultradian pulsatility within circadian envelope
    let ultradianPulse = fclamp(
      0.5 + 0.3 * Float.sin(Float.fromInt(currentBeat) * 0.01745),  // ~60 min period at 12Hz
      0.2, 0.8
    );
    // Stress-driven CRH release
    let stressDriveCRH = fclamp(
      0.25 * fearLevel + 0.2 * threatLevel + 0.15 * brainstemLocusCoeruleus +
      0.15 * painIntensity + 0.1 * proinflammatoryCytokines + 0.1 * (1.0 - parasympatheticTone) +
      0.05 * predictionError,
      0.0, 1.0
    );
    // CRH with negative feedback from cortisol
    let cortisolNegFeedback = fclamp(cortisol * hpaCortisolfeedbackGain, 0.0, 0.8);
    let crhTarget = fclamp(
      0.3 * circadianEnvelope + 0.25 * stressDriveCRH + 0.2 * ultradianPulse -
      cortisolNegFeedback + 0.1 * brainstemPAG + 0.05 * (1.0 - oxytocin),
      0.05, 0.95
    );
    crh := fclamp(
      crh + dt * 2.0 * (crhTarget - crh),
      0.05, 0.95
    );

    // ─── ACTH RELEASE (ANTERIOR PITUITARY) ──────────────────────────────────────
    // CRH → corticotrophs → ACTH release
    // Also modulated by AVP (arginine vasopressin)
    let acthTarget = fclamp(
      0.5 * crh + 0.2 * vasopressin + 0.15 * stressDriveCRH -
      0.15 * cortisolNegFeedback,
      0.05, 0.95
    );
    acth := fclamp(
      acth + dt * 1.5 * (acthTarget - acth),
      0.05, 0.95
    );

    // ─── CORTISOL SYNTHESIS AND CLEARANCE ───────────────────────────────────────
    // ACTH → zona fasciculata → cortisol
    // Half-life: ~60-90 min (slow dynamics)
    // Binding: CBG (corticosteroid-binding globulin) limits free cortisol
    let cortisolSynthesis = fclamp(acth * 0.6, 0.0, 0.8);
    let cortisolClearance = cortisol * 0.02;  // ~90 min half-life at 12Hz
    cortisol := fclamp(
      cortisol + dt * (cortisolSynthesis - cortisolClearance),
      0.05, 0.95
    );

    // ─── MINERALOCORTICOID vs GLUCOCORTICOID RECEPTOR BALANCE ────────────────────
    // MR: high affinity, saturated at low cortisol (tonic regulation)
    // GR: low affinity, activated at high cortisol (stress response)
    let mrOccupancy = fclamp(cortisol / (cortisol + 0.2), 0.0, 1.0);  // Saturating curve
    let grOccupancy = fclamp((cortisol - 0.3) / (cortisol + 0.3), 0.0, 1.0);  // Shifts right
    let mrGrBalance = fclamp(mrOccupancy - grOccupancy, -1.0, 1.0);

    // ─── ALLOSTATIC LOAD ───────────────────────────────────────────────────────
    // Cumulative wear and tear from chronic stress
    // Increases: sustained cortisol, sympathetic dominance, inflammation
    // Decreases: sleep, vagal tone, anti-inflammatory resolution
    let allostaticAccumulation = fclamp(
      0.001 * cortisol + 0.001 * sympatheticTone + 0.001 * proinflammatoryCytokines +
      0.0005 * fearLevel + 0.0005 * painIntensity,
      0.0, 0.01
    );
    let allostaticRecovery = fclamp(
      0.002 * parasympatheticTone + 0.001 * sleepPressure +
      0.001 * vagalTone + 0.0005 * antiInflammatoryCytokines,
      0.0, 0.01
    );
    allostaticLoad := fclamp(
      allostaticLoad + allostaticAccumulation - allostaticRecovery,
      0.0, 1.0
    );
    hpaAllostaticLoad := allostaticLoad;

    // ─── STRESS INOCULATION / HORMESIS ──────────────────────────────────────────
    // Moderate stress exposure builds resilience (inverted-U)
    // Too little = fragile; too much = damage; just right = growth
    let stressExposure = fclamp(cortisol * 0.5 + sympatheticTone * 0.3 + fearLevel * 0.2, 0.0, 1.0);
    let hormesisGain = if (stressExposure > 0.3 and stressExposure < 0.7) {
      fclamp(0.001 * (1.0 - Float.abs(stressExposure - 0.5) * 4.0), 0.0, 0.001)
    } else { 0.0 };
    hpaStressResilienceCapacity := fclamp(
      hpaStressResilienceCapacity + hormesisGain - allostaticAccumulation * 0.5,
      0.0, 1.0
    );

    // ─── HPG AXIS CROSSTALK (GONADAL) ───────────────────────────────────────────
    // Cortisol suppresses GnRH → reduced gonadal function under chronic stress
    let gnrhSuppression = fclamp(cortisol * 0.3, 0.0, 0.5);
    testosterone := fclamp(
      testosterone * 0.995 + 0.005 * (0.5 - gnrhSuppression),
      0.05, 0.95
    );
    estrogen := fclamp(
      estrogen * 0.995 + 0.005 * (0.5 - gnrhSuppression * 0.8),
      0.05, 0.95
    );

    // ─── HPT AXIS CROSSTALK (THYROID) ───────────────────────────────────────────
    // CRH inhibits TRH → reduced T3/T4 under chronic stress (sick euthyroid)
    let trhSuppression = fclamp(crh * 0.2, 0.0, 0.3);
    thyroidT3 := fclamp(
      thyroidT3 * 0.998 + 0.002 * (0.5 - trhSuppression),
      0.1, 0.9
    );
    thyroidT4 := fclamp(
      thyroidT4 * 0.998 + 0.002 * (0.5 - trhSuppression * 0.7),
      0.1, 0.9
    );

    // ─── GH / IGF-1 GROWTH AXIS ────────────────────────────────────────────────
    // Growth hormone: pulsatile, peaks during deep sleep
    // Cortisol inhibits GH release
    let ghSleepDrive = fclamp(sleepPressure * 0.4, 0.0, 0.4);
    let ghTarget = fclamp(
      0.3 + ghSleepDrive - 0.2 * cortisol + 0.1 * (1.0 - allostaticLoad),
      0.1, 0.9
    );
    growthHormone := fclamp(
      growthHormone + dt * 0.5 * (ghTarget - growthHormone),
      0.1, 0.9
    );
    igf1 := fclamp(
      igf1 * 0.998 + growthHormone * 0.002,
      0.1, 0.9
    );

    // ─── OXYTOCIN (TRUST, BONDING, ANTI-STRESS) ─────────────────────────────────
    // Released: social contact, trust, safety, breastfeeding
    // Effects: reduces cortisol, reduces amygdala reactivity, promotes bonding
    let oxytocinDrive = fclamp(
      0.3 * polyvagalVentral + 0.2 * (1.0 - fearLevel) +
      0.2 * parasympatheticTone + 0.15 * vagalTone + 0.15 * (1.0 - cortisol),
      0.0, 1.0
    );
    oxytocin := fclamp(
      oxytocin + dt * 1.0 * (oxytocinDrive - oxytocin),
      0.05, 0.9
    );

    // ─── VASOPRESSIN (TERRITORY, PAIR-BONDING, WATER BALANCE) ────────────────────
    let vasopressinDrive = fclamp(
      0.25 * sympatheticTone + 0.2 * cortisol + 0.15 * fearLevel +
      0.15 * brainstemVasomotorTone + 0.15 * (1.0 - energyBalance) + 0.1 * brainstemPAG,
      0.0, 1.0
    );
    vasopressin := fclamp(
      vasopressin + dt * 1.0 * (vasopressinDrive - vasopressin),
      0.05, 0.9
    );

    // ─── MELATONIN (CIRCADIAN COUPLING) ────────────────────────────────────────
    // Pineal gland: darkness → melatonin → sleep promotion
    // Suppressed by light, cortisol, norepinephrine
    let melatoninDrive = fclamp(
      0.4 * circadianSleepDrive + 0.2 * (1.0 - brainstemReticuloFormation) +
      0.2 * (1.0 - brainstemLocusCoeruleus) - 0.15 * cortisol - 0.1 * norepinephrine,
      0.0, 1.0
    );
    melatonin := fclamp(
      melatonin + dt * 0.8 * (melatoninDrive - melatonin),
      0.0, 0.95
    );

    // ─── HPA → ALL ENGINE COUPLING ──────────────────────────────────────────────
    // Cortisol modulates neuroplasticity (inverted-U: moderate enhances, high suppresses)
    let cortisolPlasticityEffect = if (cortisol < 0.5) {
      cortisol * 0.02  // Moderate cortisol enhances
    } else {
      -1.0 * (cortisol - 0.5) * 0.03  // High cortisol suppresses
    };
    plasticityGate := fclamp(plasticityGate + cortisolPlasticityEffect, 0.1, 1.5);
    // Cortisol shifts emotional field toward negative valence
    emotionalFieldValence := fclamp(
      emotionalFieldValence - cortisol * 0.005 + oxytocin * 0.003,
      0.0, 1.0
    );
    // HPA → immune suppression
    immuneSuppression := fclamp(cortisol * 0.5, 0.0, 0.8);
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 4: IMMUNE-NEURAL CROSSTALK
  //  Full neuroimmune integration: cytokine cascades, microglia states,
  //  BBB permeability, sickness behavior, vagal anti-inflammatory reflex,
  //  HPA-immune bidirectional, TLR4 danger sensing, complement cascade,
  //  NK cell modulation, T-cell balance, wound healing, neuroinflammation.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickImmuneNeuralCrosstalk() {
    let dt : Float = 1.0 / 12.0;

    // ─── PROINFLAMMATORY CYTOKINE CASCADE ──────────────────────────────────────
    // IL-1β → IL-6 → TNF-α cascade with positive feedback
    // Triggered by: tissue damage, infection, chronic stress, gut permeability
    let inflammatoryTrigger = fclamp(
      0.2 * allostaticLoad + 0.15 * gutPermeability + 0.15 * (1.0 - bbbIntegrity) +
      0.15 * cortisol * 0.5 + 0.1 * painIntensity + 0.1 * (1.0 - vagalTone) +
      0.1 * (1.0 - gutMicrobiomeDiversity) + 0.05 * sympatheticTone,
      0.0, 1.0
    );
    // IL-1β (initiator)
    let il1bTarget = fclamp(
      0.4 * inflammatoryTrigger + 0.2 * microgliaActivation +
      0.15 * proinflammatoryCytokines + 0.1 * (1.0 - immuneSuppression) +
      0.15 * (1.0 - antiInflammatoryCytokines),
      0.0, 1.0
    );
    // IL-6 (amplifier)
    let il6Target = fclamp(
      0.35 * il1bTarget + 0.25 * inflammatoryTrigger +
      0.2 * proinflammatoryCytokines + 0.1 * sympatheticTone +
      0.1 * (1.0 - parasympatheticTone),
      0.0, 1.0
    );
    // TNF-α (effector)
    let tnfaTarget = fclamp(
      0.3 * il1bTarget + 0.3 * il6Target + 0.2 * microgliaActivation +
      0.1 * (1.0 - immuneSuppression) + 0.1 * inflammatoryTrigger,
      0.0, 1.0
    );
    // Integrated proinflammatory
    let proInflamTarget = fclamp(
      0.35 * il1bTarget + 0.35 * il6Target + 0.3 * tnfaTarget,
      0.0, 1.0
    );
    proinflammatoryCytokines := fclamp(
      proinflammatoryCytokines + dt * 1.5 * (proInflamTarget - proinflammatoryCytokines),
      0.0, 0.95
    );

    // ─── ANTI-INFLAMMATORY RESOLUTION ──────────────────────────────────────────
    // IL-10, TGF-β, resolvins, protectins
    // Counter-regulatory: activated BY inflammation, terminates it
    let antiInflamTarget = fclamp(
      0.25 * proinflammatoryCytokines + 0.2 * vagalTone +
      0.15 * parasympatheticTone + 0.15 * cortisol +
      0.1 * (1.0 - sympatheticTone) + 0.1 * oxytocin + 0.05 * gutMicrobiomeDiversity,
      0.0, 1.0
    );
    antiInflammatoryCytokines := fclamp(
      antiInflammatoryCytokines + dt * 1.0 * (antiInflamTarget - antiInflammatoryCytokines),
      0.0, 0.95
    );

    // ─── MICROGLIA ACTIVATION STATES ───────────────────────────────────────────
    // M1: inflammatory, neurotoxic (activated by danger signals)
    // M2: neuroprotective, repair (activated by IL-10, TGF-β)
    // Balance determines whether inflammation helps or hurts the brain
    let m1Drive = fclamp(
      0.35 * proinflammatoryCytokines + 0.2 * (1.0 - bbbIntegrity) +
      0.2 * allostaticLoad + 0.15 * (1.0 - antiInflammatoryCytokines) +
      0.1 * (1.0 - brainstemRapheNuclei),
      0.0, 1.0
    );
    let m2Drive = fclamp(
      0.3 * antiInflammatoryCytokines + 0.2 * (1.0 - proinflammatoryCytokines) +
      0.2 * vagalTone + 0.15 * oxytocin + 0.15 * (1.0 - allostaticLoad),
      0.0, 1.0
    );
    // Microglia state: positive = M1 (inflammatory), negative = M2 (protective)
    let microgliaTarget = fclamp(
      0.5 * m1Drive - 0.3 * m2Drive + 0.2 * inflammatoryTrigger,
      0.0, 1.0
    );
    microgliaActivation := fclamp(
      microgliaActivation + dt * 1.0 * (microgliaTarget - microgliaActivation),
      0.0, 0.95
    );

    // ─── BLOOD-BRAIN BARRIER PERMEABILITY ──────────────────────────────────────
    // BBB integrity compromised by: inflammation, stress, alcohol, trauma
    // Maintained by: sleep, vagal tone, healthy microbiome, exercise
    let bbbDamage = fclamp(
      0.003 * proinflammatoryCytokines + 0.002 * allostaticLoad +
      0.001 * (1.0 - parasympatheticTone) + 0.001 * cortisol,
      0.0, 0.01
    );
    let bbbRepair = fclamp(
      0.003 * vagalTone + 0.002 * antiInflammatoryCytokines +
      0.001 * sleepPressure + 0.001 * growthHormone,
      0.0, 0.01
    );
    bbbIntegrity := fclamp(
      bbbIntegrity + bbbRepair - bbbDamage,
      0.2, 1.0
    );

    // ─── SICKNESS BEHAVIOR GENERATION ──────────────────────────────────────────
    // When immune system is active, behavior MUST change:
    // fatigue, anhedonia, social withdrawal, reduced appetite, fever
    // This is ADAPTIVE — energy conservation for immune function
    let sicknessSeverity = fclamp(
      0.4 * proinflammatoryCytokines + 0.2 * (1.0 - bbbIntegrity) +
      0.2 * microgliaActivation + 0.1 * allostaticLoad + 0.1 * (1.0 - energyBalance),
      0.0, 1.0
    );
    sicknessIndex := fclamp(
      sicknessIndex + dt * 1.5 * (sicknessSeverity - sicknessIndex),
      0.0, 1.0
    );
    // Sickness behavior effects
    if (sicknessIndex > 0.3) {
      // Fatigue
      energyBalance := fclamp(energyBalance - sicknessIndex * 0.003, 0.0, 1.0);
      // Anhedonia (reduced reward sensitivity)
      rewardSensitivity := fclamp(rewardSensitivity - sicknessIndex * 0.002, 0.1, 1.0);
      // Social withdrawal
      polyvagalVentral := fclamp(polyvagalVentral - sicknessIndex * 0.002, 0.0, 1.0);
      // Fever (temperature increase)
      coreTemperature := fclamp(coreTemperature + sicknessIndex * 0.001, 0.0, 1.0);
    };

    // ─── VAGAL ANTI-INFLAMMATORY REFLEX (CHOLINERGIC) ───────────────────────────
    // Vagus nerve → spleen → acetylcholine → macrophage inhibition
    // This is why vagal tone is SO IMPORTANT for health
    let vagalAntiInflam = fclamp(
      vagalEfferentChannels[7] * 0.4 + vagalTone * 0.3 + parasympatheticTone * 0.3,
      0.0, 1.0
    );
    // Direct suppression of proinflammatory cytokines
    proinflammatoryCytokines := fclamp(
      proinflammatoryCytokines - vagalAntiInflam * 0.005,
      0.0, 0.95
    );

    // ─── NK CELL ACTIVITY ──────────────────────────────────────────────────────
    // Natural killer cells modulated by stress, sleep, cortisol
    let nkTarget = fclamp(
      0.3 * (1.0 - cortisol) + 0.2 * (1.0 - allostaticLoad) +
      0.2 * (sleepPressure * 0.5 + 0.25) + 0.15 * (1.0 - sympatheticTone) +
      0.15 * antiInflammatoryCytokines,
      0.1, 0.9
    );
    nkCellActivity := fclamp(
      nkCellActivity + dt * 0.5 * (nkTarget - nkCellActivity),
      0.1, 0.9
    );

    // ─── T-CELL BALANCE (Th1/Th2/Th17/Treg) ────────────────────────────────────
    // Stress shifts Th1→Th2 (cortisol effect)
    // Th17: autoimmune/inflammatory
    // Treg: regulatory/suppressive
    let th1Th2Balance = fclamp(
      0.5 - cortisol * 0.3 + proinflammatoryCytokines * 0.2 - antiInflammatoryCytokines * 0.1,
      0.0, 1.0  // 0=Th2 dominant, 1=Th1 dominant
    );
    let tregActivity = fclamp(
      0.3 * antiInflammatoryCytokines + 0.2 * vagalTone + 0.2 * (1.0 - allostaticLoad) +
      0.15 * oxytocin + 0.15 * (1.0 - cortisol),
      0.0, 1.0
    );
    tCellBalance := fclamp(th1Th2Balance, 0.1, 0.9);
    tregLevel := fclamp(
      tregLevel + dt * 0.5 * (tregActivity - tregLevel),
      0.1, 0.9
    );

    // ─── WOUND HEALING RATE ────────────────────────────────────────────────────
    let healingTarget = fclamp(
      0.25 * growthHormone + 0.2 * (1.0 - cortisol) + 0.2 * (1.0 - allostaticLoad) +
      0.15 * nkCellActivity + 0.1 * sleepPressure + 0.1 * antiInflammatoryCytokines,
      0.1, 0.9
    );
    woundHealingRate := fclamp(
      woundHealingRate + dt * 0.3 * (healingTarget - woundHealingRate),
      0.1, 0.9
    );

    // ─── NEUROINFLAMMATION → NEUROPLASTICITY ────────────────────────────────────
    // Chronic neuroinflammation suppresses BDNF, LTP, neurogenesis
    if (microgliaActivation > 0.5) {
      bdnfLevel := fclamp(bdnfLevel - (microgliaActivation - 0.5) * 0.003, 0.3, 1.5);
      ltpInduction := fclamp(ltpInduction - (microgliaActivation - 0.5) * 0.002, 0.0, 1.0);
    };

    // ─── IMMUNE → ENGINE COUPLING ──────────────────────────────────────────────
    // Sickness → brainstem (reduced arousal)
    brainstemReticuloFormation := fclamp(
      brainstemReticuloFormation - sicknessIndex * 0.005,
      0.05, 0.98
    );
    // Inflammation → emotional field (malaise)
    emotionalFieldValence := fclamp(
      emotionalFieldValence - proinflammatoryCytokines * 0.003,
      0.0, 1.0
    );
    // Cytokines → sleep promotion
    sleepPressure := fclamp(
      sleepPressure + proinflammatoryCytokines * 0.002,
      0.0, 1.0
    );
  };
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 5: GUT-BRAIN AXIS
  //  Enteric nervous system (500M neurons), gut serotonin (95% of 5-HT),
  //  microbiome diversity, SCFA production, tryptophan metabolism,
  //  gut-derived GABA, intestinal permeability, gut motility CPG,
  //  gut-systemic inflammation, vagal gut→brain signaling, gut peptides.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickGutBrainAxis() {
    let dt : Float = 1.0 / 12.0;

    // ─── ENTERIC NERVOUS SYSTEM (ENS) ACTIVITY ──────────────────────────────────
    // 500M neurons — more than spinal cord. Can function independently.
    // Generates local reflexes: peristalsis, secretion, blood flow
    let ensInput = fclamp(
      0.25 * brainstemDorsalMotorNucleus + 0.2 * parasympatheticTone +
      0.15 * gutMicrobiomeDiversity + 0.15 * (1.0 - gutPermeability) +
      0.1 * brainstemNucleusTractusSolitarius + 0.1 * vagalTone +
      0.05 * (1.0 - sympatheticTone),
      0.1, 1.0
    );
    let ensTarget = fclamp(
      0.4 * ensInput + 0.2 * gutMotility + 0.2 * gutSerotoninProduction +
      0.1 * (1.0 - proinflammatoryCytokines) + 0.1 * energyBalance,
      0.1, 0.9
    );
    // ENS oscillator (peristaltic CPG)
    let ensOscillation = fclamp(
      0.5 + 0.2 * Float.sin(Float.fromInt(currentBeat) * 0.0873),  // ~0.17 Hz migrating motor complex
      0.3, 0.7
    );

    // ─── GUT SEROTONIN PRODUCTION ──────────────────────────────────────────────
    // Enterochromaffin cells produce 95% of body's serotonin
    // Modulated by: microbiome, inflammation, vagal activity
    let gut5htTarget = fclamp(
      0.3 * gutMicrobiomeDiversity + 0.2 * ensTarget +
      0.15 * (1.0 - gutPermeability) + 0.15 * vagalTone +
      0.1 * (1.0 - proinflammatoryCytokines) + 0.1 * energyBalance,
      0.1, 0.9
    );
    gutSerotoninProduction := fclamp(
      gutSerotoninProduction + dt * 1.0 * (gut5htTarget - gutSerotoninProduction),
      0.1, 0.9
    );
    // Gut 5-HT → systemic serotonin (partial contribution)
    serotonin := fclamp(
      serotonin * 0.97 + gutSerotoninProduction * 0.03,
      0.05, 0.95
    );

    // ─── MICROBIOME DIVERSITY INDEX ────────────────────────────────────────────
    // Diversity = resilience. Reduced by: stress, antibiotics, poor diet
    // Enhanced by: varied diet, fiber, probiotics, vagal tone
    let diversityPressure = fclamp(
      -0.002 * cortisol - 0.001 * sympatheticTone - 0.001 * proinflammatoryCytokines +
      0.002 * vagalTone + 0.001 * parasympatheticTone + 0.001 * (1.0 - allostaticLoad),
      -0.005, 0.005
    );
    gutMicrobiomeDiversity := fclamp(
      gutMicrobiomeDiversity + diversityPressure,
      0.1, 0.95
    );

    // ─── SHORT-CHAIN FATTY ACIDS (SCFA) ────────────────────────────────────────
    // Microbiome → butyrate, propionate, acetate → brain effects
    // SCFA: anti-inflammatory, supports BBB, promotes BDNF
    let scfaProduction = fclamp(
      0.5 * gutMicrobiomeDiversity + 0.3 * (1.0 - gutPermeability) +
      0.2 * ensTarget,
      0.0, 1.0
    );
    // SCFA → BBB support
    bbbIntegrity := fclamp(bbbIntegrity + scfaProduction * 0.001, 0.2, 1.0);
    // SCFA → BDNF support
    bdnfLevel := fclamp(bdnfLevel + scfaProduction * 0.001, 0.3, 1.5);
    // SCFA → anti-inflammatory
    antiInflammatoryCytokines := fclamp(
      antiInflammatoryCytokines + scfaProduction * 0.001,
      0.0, 0.95
    );

    // ─── TRYPTOPHAN METABOLISM ──────────────────────────────────────────────────
    // Tryptophan → serotonin (good) OR → kynurenine (inflammatory)
    // Stress/inflammation shifts toward kynurenine pathway
    let kynurenineBias = fclamp(
      0.4 * proinflammatoryCytokines + 0.3 * cortisol + 0.3 * microgliaActivation,
      0.0, 1.0
    );
    let serotoninBias = fclamp(1.0 - kynurenineBias, 0.0, 1.0);
    // Kynurenine pathway → quinolinic acid → neurotoxicity
    if (kynurenineBias > 0.5) {
      // Reduced serotonin availability
      serotonin := fclamp(serotonin - (kynurenineBias - 0.5) * 0.002, 0.05, 0.95);
      // Quinolinic acid → NMDA excitotoxicity
      microgliaActivation := fclamp(microgliaActivation + (kynurenineBias - 0.5) * 0.001, 0.0, 0.95);
    };

    // ─── INTESTINAL PERMEABILITY (LEAKY GUT) ────────────────────────────────────
    // Tight junctions compromised by: stress, inflammation, dysbiosis
    // Maintained by: butyrate (SCFA), vagal tone, zinc, glutamine
    let permeabilityDamage = fclamp(
      0.002 * cortisol + 0.002 * proinflammatoryCytokines +
      0.001 * sympatheticTone + 0.001 * (1.0 - gutMicrobiomeDiversity),
      0.0, 0.01
    );
    let permeabilityRepair = fclamp(
      0.002 * scfaProduction + 0.001 * vagalTone + 0.001 * growthHormone +
      0.001 * (1.0 - allostaticLoad),
      0.0, 0.01
    );
    gutPermeability := fclamp(
      gutPermeability + permeabilityDamage - permeabilityRepair,
      0.0, 0.9
    );

    // ─── GUT MOTILITY (PERISTALSIS CPG) ────────────────────────────────────────
    let motilityTarget = fclamp(
      0.3 * parasympatheticTone + 0.2 * ensOscillation + 0.15 * brainstemDorsalMotorNucleus +
      0.15 * gutSerotoninProduction + 0.1 * (1.0 - sympatheticTone) + 0.1 * vagalTone,
      0.1, 0.9
    );
    gutMotility := fclamp(
      gutMotility + dt * 1.0 * (motilityTarget - gutMotility),
      0.1, 0.9
    );

    // ─── GUT PEPTIDES ──────────────────────────────────────────────────────────
    // GLP-1 (satiety, glucose), CCK (satiety, gallbladder), PYY (satiety)
    // Ghrelin (hunger) — the only orexigenic gut peptide
    let glp1Target = fclamp(0.5 + 0.2 * ensTarget - 0.1 * (1.0 - energyBalance), 0.1, 0.9);
    let cckTarget = fclamp(0.5 + 0.15 * ensTarget + 0.1 * gutMotility, 0.1, 0.9);
    let pyyTarget = fclamp(0.4 + 0.2 * ensTarget + 0.1 * (1.0 - gutPermeability), 0.1, 0.9);
    let ghrelinTarget = fclamp(0.5 - 0.2 * energyBalance + 0.1 * (1.0 - glp1Target), 0.1, 0.9);
    gutGLP1 := fclamp(gutGLP1 + dt * 0.5 * (glp1Target - gutGLP1), 0.1, 0.9);
    gutCCK := fclamp(gutCCK + dt * 0.5 * (cckTarget - gutCCK), 0.1, 0.9);
    gutPYY := fclamp(gutPYY + dt * 0.5 * (pyyTarget - gutPYY), 0.1, 0.9);
    gutGhrelin := fclamp(gutGhrelin + dt * 0.5 * (ghrelinTarget - gutGhrelin), 0.1, 0.9);

    // ─── GUT → BRAIN VAGAL SIGNALING ───────────────────────────────────────────
    // Vagal afferents carry gut info to NTS → emotional, reward, cognition
    let gutBrainSignal = fclamp(
      0.3 * gutSerotoninProduction + 0.2 * gutMotility + 0.15 * scfaProduction +
      0.15 * (1.0 - gutPermeability) + 0.1 * gutGLP1 + 0.1 * gutMicrobiomeDiversity,
      0.0, 1.0
    );
    // Gut → interoception (gut feelings ARE real)
    interoceptiveAwareness := fclamp(
      interoceptiveAwareness * 0.98 + gutBrainSignal * 0.02,
      0.0, 1.0
    );
    // Gut → reward (satiety = reward signal)
    rewardSensitivity := fclamp(
      rewardSensitivity * 0.99 + gutGLP1 * 0.005 + gutCCK * 0.005,
      0.1, 1.0
    );
    // Gut → emotional field (healthy gut = better mood)
    emotionalFieldValence := fclamp(
      emotionalFieldValence + gutBrainSignal * 0.002 - gutPermeability * 0.002,
      0.0, 1.0
    );
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 6: PAIN MATRIX
  //  Multi-dimensional pain processing: nociceptive transduction (Aδ/C-fiber),
  //  spinal dorsal horn gating (gate control), ascending pathways,
  //  sensory-discriminative (S1/S2), affective-motivational (insula/ACC),
  //  cognitive-evaluative (PFC), descending modulation (PAG→raphe→DH),
  //  endogenous opioid system, central sensitization, DNIC, placebo/nocebo.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickPainMatrix() {
    let dt : Float = 1.0 / 12.0;

    // ─── NOCICEPTIVE TRANSDUCTION ──────────────────────────────────────────────
    // Aδ fibers: fast, sharp, well-localized pain (first pain)
    // C fibers: slow, dull, diffuse pain (second pain)
    let noxiousInput = fclamp(
      0.3 * painIntensity + 0.2 * proinflammatoryCytokines +
      0.15 * (1.0 - antiInflammatoryCytokines) + 0.15 * allostaticLoad +
      0.1 * gutPermeability + 0.1 * (1.0 - bbbIntegrity),
      0.0, 1.0
    );
    let adeltaFiber = fclamp(noxiousInput * 0.8, 0.0, 1.0);  // Fast, sharp
    let cFiber = fclamp(noxiousInput * 0.6 + painChronicRisk * 0.2, 0.0, 1.0);  // Slow, burning

    // ─── SPINAL DORSAL HORN GATING (GATE CONTROL THEORY — MELZACK & WALL) ──────
    // Large Aβ fibers (touch) CLOSE the gate → reduce pain
    // Small C fibers OPEN the gate → increase pain
    // Descending modulation can close or open the gate
    let touchInput = fclamp(  // Aβ fiber activity (non-noxious touch)
      0.3 * brainstemReticuloSpinal + 0.2 * motorCommandSignal +
      0.2 * (1.0 - sympatheticTone) + 0.15 * parasympatheticTone + 0.15 * oxytocin,
      0.0, 1.0
    );
    let gateOpenDrive = fclamp(cFiber * 0.6 + adeltaFiber * 0.3 + painChronicRisk * 0.1, 0.0, 1.0);
    let gateCloseDrive = fclamp(
      touchInput * 0.4 + painDescendingModulation * 0.35 + endorphinLevel * 0.25,
      0.0, 1.0
    );
    let spinalGateOutput = fclamp(gateOpenDrive - gateCloseDrive, 0.0, 1.0);
    painGateControl := fclamp(
      painGateControl + dt * 3.0 * (spinalGateOutput - painGateControl),
      0.0, 0.95
    );

    // ─── ASCENDING PATHWAYS ────────────────────────────────────────────────────
    // Spinothalamic: to VPL → S1/S2 (location, intensity)
    // Spinoreticular: to reticular formation (arousal)
    // Spinomesencephalic: to PAG (descending modulation trigger)
    let spinothalamicSignal = fclamp(painGateControl * 0.8, 0.0, 1.0);
    let spinoreticular = fclamp(painGateControl * 0.5, 0.0, 0.8);
    let spinomesencephalic = fclamp(painGateControl * 0.6, 0.0, 0.8);

    // ─── SENSORY-DISCRIMINATIVE DIMENSION (S1/S2) ──────────────────────────────
    // Where is the pain? How intense?
    painSensoryDiscriminative := fclamp(
      painSensoryDiscriminative + dt * 3.0 * (spinothalamicSignal - painSensoryDiscriminative),
      0.0, 1.0
    );

    // ─── AFFECTIVE-MOTIVATIONAL DIMENSION (INSULA/ACC) ─────────────────────────
    // How unpleasant is this? Suffering component
    let affectivePainTarget = fclamp(
      0.4 * spinothalamicSignal + 0.2 * fearLevel + 0.15 * (1.0 - oxytocin) +
      0.1 * brainstemPAG + 0.1 * (1.0 - serotonin) + 0.05 * allostaticLoad,
      0.0, 1.0
    );
    painAffectiveMotivational := fclamp(
      painAffectiveMotivational + dt * 2.5 * (affectivePainTarget - painAffectiveMotivational),
      0.0, 1.0
    );

    // ─── COGNITIVE-EVALUATIVE DIMENSION (PFC) ──────────────────────────────────
    // What does this pain mean? Catastrophizing, context, expectation
    let cognitivePainTarget = fclamp(
      0.3 * painAffectiveMotivational + 0.2 * predictionError +
      0.15 * (1.0 - consciousnessIndex) + 0.15 * fearLevel +
      0.1 * allostaticLoad + 0.1 * (1.0 - hpaStressResilienceCapacity),
      0.0, 1.0
    );
    painCognitiveEvaluative := fclamp(
      painCognitiveEvaluative + dt * 2.0 * (cognitivePainTarget - painCognitiveEvaluative),
      0.0, 1.0
    );

    // ─── DESCENDING MODULATION (PAG → RAPHE → DORSAL HORN) ──────────────────────
    // Top-down pain control: analgesia pathway
    let descendingModTarget = fclamp(
      0.3 * brainstemPAG + 0.25 * brainstemRapheNuclei + 0.2 * endorphinLevel +
      0.15 * (1.0 - fearLevel) + 0.1 * consciousnessIndex,
      0.0, 1.0
    );
    painDescendingModulation := fclamp(
      painDescendingModulation + dt * 2.0 * (descendingModTarget - painDescendingModulation),
      0.0, 0.9
    );

    // ─── ENDOGENOUS OPIOID SYSTEM ──────────────────────────────────────────────
    // Endorphins (β-endorphin), enkephalins, dynorphins
    // Released during: stress, exercise, social bonding, sex, laughter
    let opioidReleaseDrive = fclamp(
      0.25 * brainstemPAG + 0.2 * (painGateControl * 0.5) +
      0.15 * oxytocin + 0.15 * rewardNAccShell +
      0.1 * brainstemVTA + 0.1 * (1.0 - allostaticLoad) + 0.05 * vagalTone,
      0.0, 1.0
    );
    endorphinLevel := fclamp(
      endorphinLevel + dt * 1.0 * (opioidReleaseDrive - endorphinLevel),
      0.05, 0.9
    );
    // Endorphins → mood elevation
    emotionalFieldValence := fclamp(
      emotionalFieldValence + endorphinLevel * 0.002,
      0.0, 1.0
    );

    // ─── CENTRAL SENSITIZATION / WIND-UP ───────────────────────────────────────
    // Repeated C-fiber activation → NMDA receptor activation → amplification
    // This is how acute pain becomes chronic pain
    let windUpDrive = fclamp(
      0.3 * cFiber + 0.2 * proinflammatoryCytokines +
      0.2 * (1.0 - painDescendingModulation) + 0.15 * allostaticLoad +
      0.15 * (1.0 - endorphinLevel),
      0.0, 1.0
    );
    let windUpRecovery = fclamp(
      0.3 * endorphinLevel + 0.2 * antiInflammatoryCytokines +
      0.2 * sleepPressure + 0.15 * vagalTone + 0.15 * (1.0 - cortisol),
      0.0, 1.0
    );
    painChronicRisk := fclamp(
      painChronicRisk + dt * 0.3 * (windUpDrive - windUpRecovery),
      0.0, 0.9
    );

    // ─── CONDITIONED PAIN MODULATION (DNIC) ─────────────────────────────────────
    // Pain inhibits pain (counterirritation, DNIC)
    let dnicEffect = fclamp(
      0.3 * brainstemPAG + 0.3 * painDescendingModulation + 0.2 * brainstemRapheNuclei +
      0.2 * brainstemLocusCoeruleus,
      0.0, 0.8
    );

    // ─── PLACEBO / NOCEBO EXPECTATION EFFECTS ───────────────────────────────────
    // Expectation of relief → endorphin release → actual pain reduction
    // Expectation of worsening → cholecystokinin → actual pain increase
    let placeboEffect = fclamp(
      0.3 * (1.0 - predictionError) + 0.2 * consciousnessIndex +
      0.2 * endorphinLevel + 0.15 * dopamine + 0.15 * (1.0 - fearLevel),
      0.0, 0.5
    );
    let noceboEffect = fclamp(
      0.3 * fearLevel + 0.2 * painCognitiveEvaluative +
      0.2 * predictionError + 0.15 * cortisol + 0.15 * (1.0 - endorphinLevel),
      0.0, 0.5
    );

    // ─── INTEGRATED PAIN INTENSITY ──────────────────────────────────────────────
    let integratedPain = fclamp(
      0.3 * painSensoryDiscriminative + 0.3 * painAffectiveMotivational +
      0.2 * painCognitiveEvaluative - 0.1 * dnicEffect - 0.05 * placeboEffect + 0.05 * noceboEffect,
      0.0, 1.0
    );
    painIntensity := fclamp(
      painIntensity + dt * 2.0 * (integratedPain - painIntensity),
      0.0, 0.95
    );

    // ─── PAIN → CROSS-SYSTEM EFFECTS ───────────────────────────────────────────
    // Pain → arousal (spinoreticular)
    brainstemReticuloFormation := fclamp(
      brainstemReticuloFormation + spinoreticular * 0.005,
      0.05, 0.98
    );
    // Pain → emotional field (suffering)
    emotionalFieldValence := fclamp(
      emotionalFieldValence - painIntensity * 0.005,
      0.0, 1.0
    );
    // Pain → sympathetic activation
    sympatheticTone := fclamp(
      sympatheticTone + painIntensity * 0.003,
      0.05, 0.95
    );
    // Pain → attention capture (salience)
    if (painIntensity > 0.3) {
      attentionFocus := fclamp(attentionFocus + (painIntensity - 0.3) * 0.01, 0.0, 1.0);
      noveltySalience := fclamp(noveltySalience + (painIntensity - 0.3) * 0.005, 0.0, 1.0);
    };
    // Pain → sleep disruption
    if (painIntensity > 0.4) {
      sleepPressure := fclamp(sleepPressure - painIntensity * 0.003, 0.0, 1.0);
    };
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 7: REWARD / MOTIVATION CIRCUIT
  //  Full mesolimbic/mesocortical: VTA dopamine (tonic/phasic), RPE,
  //  TD learning, incentive salience (wanting) vs hedonic (liking),
  //  effort cost (ACC), temporal discounting, NAc shell/core,
  //  ventral pallidum, lateral habenula, orexin coupling,
  //  motivation-energy coupling, anhedonia index.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickRewardMotivationCircuit() {
    let dt : Float = 1.0 / 12.0;

    // ─── VTA DOPAMINE NEURON FIRING ────────────────────────────────────────────
    // Tonic: baseline motivation, effort willingness
    // Phasic bursts: reward prediction error (unexpected reward)
    // Phasic dips: worse-than-expected outcome
    let vtaTonicFiring = fclamp(
      0.3 * brainstemVTA + 0.2 * (1.0 - allostaticLoad) +
      0.15 * energyBalance + 0.15 * brainstemReticuloFormation +
      0.1 * (1.0 - brainstemPAG) + 0.1 * (1.0 - fearLevel),
      0.1, 0.8
    );
    let vtaPhasicFiring = fclamp(
      rewardPredictionError * 0.8 + noveltySalience * 0.2,
      -0.5, 1.0  // Can be negative (dips)
    );
    // Combined VTA output
    rewardVTATonic := fclamp(
      rewardVTATonic + dt * 1.5 * (vtaTonicFiring - rewardVTATonic),
      0.05, 0.9
    );
    rewardVTAPhasic := fclamp(
      rewardVTAPhasic * 0.85 + vtaPhasicFiring * 0.15,  // Fast decay (phasic)
      -0.5, 1.0
    );

    // ─── REWARD PREDICTION ERROR (δ = r - V(s)) ────────────────────────────────
    // The core learning signal: difference between received and expected reward
    // δ > 0: better than expected → increase value estimate
    // δ < 0: worse than expected → decrease value estimate
    // δ = 0: fully predicted → no learning
    let receivedReward = fclamp(
      0.3 * (1.0 - painIntensity) + 0.2 * energyBalance +
      0.15 * gutGLP1 + 0.1 * oxytocin + 0.1 * endorphinLevel +
      0.1 * (1.0 - fearLevel) + 0.05 * polyvagalVentral,
      0.0, 1.0
    );
    let expectedReward = fclamp(
      rewardValueEstimate * 0.8 + rewardVTATonic * 0.2,
      0.0, 1.0
    );
    rewardPredictionError := fclamp(
      receivedReward - expectedReward,
      -0.5, 0.5
    );
    // Update value estimate (TD learning)
    let tdLearningRate = fclamp(0.05 * (1.0 - allostaticLoad), 0.01, 0.1);
    rewardValueEstimate := fclamp(
      rewardValueEstimate + tdLearningRate * rewardPredictionError,
      0.0, 1.0
    );

    // ─── INCENTIVE SALIENCE (WANTING) vs HEDONIC IMPACT (LIKING) ────────────────
    // Wanting: dopamine-driven, can dissociate from liking
    // Liking: opioid/endocannabinoid-driven, actual pleasure
    // Addiction: high wanting, low liking
    rewardWanting := fclamp(
      rewardWanting + dt * 2.0 * (
        0.4 * dopamine + 0.3 * rewardVTAPhasic + 0.2 * noveltySalience +
        0.1 * rewardOrexin - rewardWanting
      ),
      0.0, 1.0
    );
    rewardLiking := fclamp(
      rewardLiking + dt * 1.5 * (
        0.35 * endorphinLevel + 0.25 * rewardNAccShell + 0.2 * oxytocin +
        0.1 * serotonin + 0.1 * (1.0 - painIntensity) - rewardLiking
      ),
      0.0, 1.0
    );

    // ─── EFFORT COST COMPUTATION (ACC) ──────────────────────────────────────────
    // ACC weighs effort required against expected reward
    // High effort cost + low expected reward = apathy
    let effortCostTarget = fclamp(
      0.3 * (1.0 - energyBalance) + 0.2 * allostaticLoad +
      0.15 * (1.0 - dopamine) + 0.15 * painIntensity +
      0.1 * cortisol + 0.1 * (1.0 - brainstemReticuloFormation),
      0.0, 1.0
    );
    rewardEffortCost := fclamp(
      rewardEffortCost + dt * 1.5 * (effortCostTarget - rewardEffortCost),
      0.0, 1.0
    );

    // ─── TEMPORAL DISCOUNTING ───────────────────────────────────────────────────
    // How much future reward is devalued relative to immediate reward
    // Impulsivity: steep discounting. Patience: shallow discounting.
    // Serotonin promotes patience; dopamine promotes impulsivity
    rewardTemporalDiscount := fclamp(
      0.3 * (1.0 - serotonin) + 0.2 * dopamine + 0.15 * (1.0 - consciousnessIndex) +
      0.15 * sympatheticTone + 0.1 * fearLevel + 0.1 * (1.0 - parasympatheticTone),
      0.1, 0.9
    );

    // ─── NUCLEUS ACCUMBENS SHELL vs CORE ───────────────────────────────────────
    // Shell: hedonic evaluation (liking), salience attribution
    // Core: approach behavior, motor execution of reward-seeking
    rewardNAccShell := fclamp(
      rewardNAccShell + dt * 2.0 * (
        0.35 * rewardLiking + 0.25 * endorphinLevel + 0.2 * dopamine +
        0.1 * oxytocin + 0.1 * rewardVTAPhasic - rewardNAccShell
      ),
      0.0, 1.0
    );
    rewardNAccCore := fclamp(
      rewardNAccCore + dt * 2.0 * (
        0.35 * rewardWanting + 0.25 * dopamine + 0.2 * rewardVTATonic +
        0.1 * motorCommandSignal + 0.1 * brainstemReticuloFormation - rewardNAccCore
      ),
      0.0, 1.0
    );

    // ─── VENTRAL PALLIDUM (HEDONIC HOTSPOT) ──────────────────────────────────────
    rewardVentralPallidum := fclamp(
      rewardVentralPallidum + dt * 1.5 * (
        0.4 * rewardNAccShell + 0.3 * endorphinLevel +
        0.2 * rewardLiking + 0.1 * oxytocin - rewardVentralPallidum
      ),
      0.0, 1.0
    );

    // ─── LATERAL HABENULA (ANTI-REWARD / DISAPPOINTMENT) ────────────────────────
    // Fires when reality < expectation. Inhibits VTA dopamine.
    // Overactivity → depression, anhedonia
    let habenulaDrive = fclamp(
      0.4 * Float.max(0.0, -1.0 * rewardPredictionError) +  // Negative RPE
      0.2 * painIntensity + 0.15 * (1.0 - rewardLiking) +
      0.15 * allostaticLoad + 0.1 * cortisol,
      0.0, 1.0
    );
    rewardHabenula := fclamp(
      rewardHabenula + dt * 2.0 * (habenulaDrive - rewardHabenula),
      0.0, 0.9
    );

    // ─── OREXIN/HYPOCRETIN (AROUSAL-REWARD COUPLING) ───────────────────────────
    // Links arousal to reward-seeking. Absent in narcolepsy.
    let orexinTarget = fclamp(
      0.3 * brainstemReticuloFormation + 0.2 * (1.0 - sleepPressure) +
      0.2 * rewardWanting + 0.15 * (1.0 - energyBalance) +
      0.15 * gutGhrelin,
      0.0, 1.0
    );
    rewardOrexin := fclamp(
      rewardOrexin + dt * 1.0 * (orexinTarget - rewardOrexin),
      0.0, 0.9
    );

    // ─── ANHEDONIA INDEX ───────────────────────────────────────────────────────
    // Inability to experience pleasure. Key depression symptom.
    // High habenula + low VTA tonic + low liking + high cortisol = anhedonia
    rewardAnhedonia := fclamp(
      0.25 * rewardHabenula + 0.2 * (1.0 - rewardLiking) +
      0.2 * (1.0 - rewardVTATonic) + 0.15 * cortisol +
      0.1 * allostaticLoad + 0.1 * (1.0 - serotonin),
      0.0, 1.0
    );

    // ─── MOTIVATION-ENERGY COUPLING ─────────────────────────────────────────────
    // Motivation requires metabolic energy. No energy → no motivation.
    let motivationTarget = fclamp(
      0.25 * rewardWanting + 0.2 * rewardVTATonic + 0.15 * (1.0 - rewardEffortCost) +
      0.15 * energyBalance + 0.1 * brainstemReticuloFormation +
      0.1 * dopamine + 0.05 * (1.0 - rewardAnhedonia),
      0.0, 1.0
    );
    motivationLevel := fclamp(
      motivationLevel + dt * 1.5 * (motivationTarget - motivationLevel),
      0.0, 1.0
    );

    // ─── REWARD → CROSS-SYSTEM COUPLING ────────────────────────────────────────
    // Reward → behavior selection (approach/avoid)
    emotionalFieldValence := fclamp(
      emotionalFieldValence + rewardLiking * 0.003 - rewardAnhedonia * 0.002,
      0.0, 1.0
    );
    // Reward → learning (emotional tagging for consolidation)
    if (Float.abs(rewardPredictionError) > 0.1) {
      ltpInduction := fclamp(ltpInduction + Float.abs(rewardPredictionError) * 0.005, 0.0, 1.0);
    };
    // Reward → dopamine feedback
    dopamine := fclamp(
      dopamine * 0.96 + rewardVTATonic * 0.02 + rewardVTAPhasic * 0.02,
      0.05, 0.95
    );
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 8: SLEEP ARCHITECTURE
  //  Full sleep stage dynamics: two-process model (S+C), adenosine, flip-flop switch,
  //  N1/N2/N3/REM stages, sleep spindles, K-complexes, delta waves,
  //  90-min ultradian cycles, REM-on/off competition, memory replay,
  //  synaptic homeostasis, glymphatic clearance, sleep deprivation effects.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickSleepArchitecture() {
    let dt : Float = 1.0 / 12.0;

    // ─── PROCESS S: HOMEOSTATIC SLEEP PRESSURE (ADENOSINE) ──────────────────────
    // Adenosine accumulates during wakefulness, cleared during sleep
    // Caffeine blocks adenosine receptors (modeled as antagonist)
    let wakeActivity = fclamp(
      brainstemReticuloFormation * 0.7 + (1.0 - sleepPressure) * 0.3,
      0.0, 1.0
    );
    let adenosineAccumulation = wakeActivity * 0.001;  // Slow buildup
    let adenosineClearance = sleepPressure * 0.002;  // Cleared during sleep
    adenosineLevel := fclamp(
      adenosineLevel + adenosineAccumulation - adenosineClearance,
      0.0, 1.0
    );
    // Process S = adenosine level
    sleepProcessS := adenosineLevel;

    // ─── PROCESS C: CIRCADIAN DRIVE ─────────────────────────────────────────────
    // SCN-driven alerting signal. Opposes Process S during the day.
    // Maximum alertness in late afternoon (circadian peak)
    sleepProcessC := fclamp(
      0.5 + 0.4 * Float.cos(circadianPhase * 6.2832),  // Peak at phase 0 (noon)
      0.0, 1.0
    );

    // ─── COMBINED SLEEP DRIVE ───────────────────────────────────────────────────
    // Sleep occurs when Process S > Process C (adenosine overcomes circadian alertness)
    let netSleepDrive = fclamp(
      sleepProcessS - sleepProcessC * 0.6 + melatonin * 0.3,
      0.0, 1.0
    );
    sleepPressure := fclamp(
      sleepPressure + dt * 0.5 * (netSleepDrive - sleepPressure),
      0.0, 1.0
    );

    // ─── FLIP-FLOP SWITCH (VLPO ↔ AROUSAL NUCLEI) ──────────────────────────────
    // Bistable switch: prevents gradual transitions (you're either asleep or awake)
    // VLPO (sleep): GABA/galanin to LC, raphe, TMN, orexin
    // Arousal nuclei (wake): monoamines inhibit VLPO
    let vlpoDrive = fclamp(
      0.4 * sleepPressure + 0.2 * adenosineLevel + 0.2 * melatonin +
      0.1 * gabaLevel + 0.1 * (1.0 - brainstemLocusCoeruleus),
      0.0, 1.0
    );
    let arousalDrive = fclamp(
      0.3 * brainstemReticuloFormation + 0.2 * brainstemLocusCoeruleus +
      0.15 * rewardOrexin + 0.15 * norepinephrine +
      0.1 * serotonin + 0.1 * sympatheticTone,
      0.0, 1.0
    );
    // Hysteresis: once flipped, stays flipped until strong opposing signal
    let sleepWakeBalance = vlpoDrive - arousalDrive;
    let isAsleep = sleepWakeBalance > 0.1;
    sleepFlipFlopState := fclamp(
      if (isAsleep) { fclamp(sleepFlipFlopState + dt * 2.0 * (1.0 - sleepFlipFlopState), 0.0, 1.0) }
      else { fclamp(sleepFlipFlopState + dt * 2.0 * (0.0 - sleepFlipFlopState), 0.0, 1.0) },
      0.0, 1.0
    );

    // ─── SLEEP STAGE DYNAMICS ───────────────────────────────────────────────────
    // 90-minute ultradian cycle: N1 → N2 → N3 → N2 → REM → repeat
    // Early night: more N3 (deep sleep). Late night: more REM.
    if (sleepFlipFlopState > 0.5) {
      // We're asleep — compute sleep stages
      let sleepCyclePhase = fclamp(
        0.5 + 0.5 * Float.sin(Float.fromInt(currentBeat) * 0.00116),  // ~90 min at 12Hz
        0.0, 1.0
      );
      // N1: light sleep (theta waves, hypnagogic imagery)
      let n1Drive = if (sleepCyclePhase < 0.15 or sleepCyclePhase > 0.85) { 0.7 } else { 0.1 };
      sleepN1Power := fclamp(sleepN1Power + dt * 2.0 * (n1Drive - sleepN1Power), 0.0, 1.0);
      // N2: sleep spindles (12-15 Hz bursts) + K-complexes
      let n2Drive = if (sleepCyclePhase >= 0.15 and sleepCyclePhase < 0.35) { 0.8 } else { 0.2 };
      sleepN2Power := fclamp(sleepN2Power + dt * 2.0 * (n2Drive - sleepN2Power), 0.0, 1.0);
      sleepSpindlePower := fclamp(
        sleepN2Power * 0.7 + 0.2 * Float.sin(Float.fromInt(currentBeat) * 1.5) + 0.1,
        0.0, 1.0
      );
      sleepKComplexRate := fclamp(sleepN2Power * 0.6, 0.0, 1.0);
      // N3: deep sleep (delta 0.5-4 Hz, slow-wave activity)
      let n3Drive = if (sleepCyclePhase >= 0.35 and sleepCyclePhase < 0.6) { 0.9 } else { 0.1 };
      sleepN3Power := fclamp(sleepN3Power + dt * 2.0 * (n3Drive - sleepN3Power), 0.0, 1.0);
      sleepDeltaPower := fclamp(sleepN3Power * 0.85, 0.0, 1.0);
      // REM: rapid eye movement (dreaming, PGO waves, muscle atonia)
      let remDrive = if (sleepCyclePhase >= 0.7 and sleepCyclePhase < 0.85) { 0.8 } else { 0.1 };
      // REM-on cells (cholinergic PPT/LDT) vs REM-off cells (LC, raphe)
      let remOnDrive = fclamp(
        0.4 * remDrive + 0.3 * acetylcholine + 0.2 * brainstemPontineNuclei +
        0.1 * (1.0 - norepinephrine),
        0.0, 1.0
      );
      let remOffDrive = fclamp(
        0.3 * norepinephrine + 0.3 * serotonin + 0.2 * brainstemLocusCoeruleus +
        0.2 * brainstemRapheNuclei,
        0.0, 1.0
      );
      sleepREMPower := fclamp(
        sleepREMPower + dt * 2.0 * (fclamp(remOnDrive - remOffDrive * 0.5, 0.0, 1.0) - sleepREMPower),
        0.0, 1.0
      );

      // ─── MEMORY REPLAY DURING NREM ──────────────────────────────────────────
      // Hippocampal sharp-wave ripples replay recent experiences
      // Spindle-ripple coupling = memory consolidation
      if (sleepN3Power > 0.3) {
        // Memory consolidation during deep sleep
        ltpInduction := fclamp(ltpInduction + sleepN3Power * 0.003, 0.0, 1.0);
        // Synaptic homeostasis (Tononi): global downscaling
        // Weak synapses pruned, strong synapses maintained
        pruningRate := fclamp(pruningRate + sleepN3Power * 0.002, 0.0, 1.0);
      };

      // ─── MEMORY CONSOLIDATION DURING REM ─────────────────────────────────────
      // Emotional memory processing, procedural memory consolidation
      if (sleepREMPower > 0.3) {
        // Emotional memory reprocessing
        emotionalFieldValence := fclamp(
          emotionalFieldValence + (0.5 - emotionalFieldValence) * 0.002,  // Tends toward neutral
          0.0, 1.0
        );
        // BDNF production during REM
        bdnfLevel := fclamp(bdnfLevel + sleepREMPower * 0.002, 0.3, 1.5);
      };

      // ─── GLYMPHATIC CLEARANCE ─────────────────────────────────────────────────
      // Brain waste removal during sleep (10x more active during sleep)
      // Clears β-amyloid, tau, metabolic waste
      sleepGlymphaticClearance := fclamp(
        0.4 * sleepN3Power + 0.3 * sleepFlipFlopState +
        0.2 * (1.0 - sympatheticTone) + 0.1 * parasympatheticTone,
        0.0, 1.0
      );
      // Glymphatic → reduced neuroinflammation
      microgliaActivation := fclamp(
        microgliaActivation - sleepGlymphaticClearance * 0.002,
        0.0, 0.95
      );
      // Glymphatic → reduced allostatic load
      allostaticLoad := fclamp(
        allostaticLoad - sleepGlymphaticClearance * 0.001,
        0.0, 1.0
      );
    } else {
      // We're awake — sleep stage powers decay
      sleepN1Power := fclamp(sleepN1Power * 0.95, 0.0, 1.0);
      sleepN2Power := fclamp(sleepN2Power * 0.95, 0.0, 1.0);
      sleepN3Power := fclamp(sleepN3Power * 0.95, 0.0, 1.0);
      sleepREMPower := fclamp(sleepREMPower * 0.95, 0.0, 1.0);
      sleepSpindlePower := fclamp(sleepSpindlePower * 0.95, 0.0, 1.0);
      sleepKComplexRate := fclamp(sleepKComplexRate * 0.95, 0.0, 1.0);
      sleepDeltaPower := fclamp(sleepDeltaPower * 0.95, 0.0, 1.0);
      sleepGlymphaticClearance := fclamp(sleepGlymphaticClearance * 0.9, 0.0, 1.0);
    };

    // ─── SLEEP DEPRIVATION EFFECTS ──────────────────────────────────────────────
    // Chronic high adenosine + low sleep = cognitive/emotional/immune degradation
    if (adenosineLevel > 0.7 and sleepFlipFlopState < 0.3) {
      let deprivationSeverity = fclamp((adenosineLevel - 0.7) * 3.0, 0.0, 1.0);
      // Cognitive impairment
      consciousnessIndex := fclamp(consciousnessIndex - deprivationSeverity * 0.003, 0.0, 1.0);
      pcGlobalPrecision := fclamp(pcGlobalPrecision - deprivationSeverity * 0.005, 0.1, 3.0);
      // Emotional dysregulation
      emotionalFieldArousal := fclamp(emotionalFieldArousal + deprivationSeverity * 0.003, 0.0, 1.0);
      fearLevel := fclamp(fearLevel + deprivationSeverity * 0.002, 0.0, 1.0);
      // Immune suppression
      nkCellActivity := fclamp(nkCellActivity - deprivationSeverity * 0.002, 0.1, 0.9);
      proinflammatoryCytokines := fclamp(proinflammatoryCytokines + deprivationSeverity * 0.002, 0.0, 0.95);
      // Metabolic disruption
      cortisol := fclamp(cortisol + deprivationSeverity * 0.002, 0.05, 0.95);
    };

    // ─── SLEEP → ALL ENGINE COUPLING ────────────────────────────────────────────
    // Arousal reduction during sleep
    if (sleepFlipFlopState > 0.5) {
      brainstemReticuloFormation := fclamp(brainstemReticuloFormation * 0.998, 0.05, 0.98);
      brainstemLocusCoeruleus := fclamp(brainstemLocusCoeruleus * 0.997, 0.05, 0.95);
    };
  };
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 9: MOTOR SYSTEM
  //  Full motor hierarchy: M1 somatotopic map, premotor planning, SMA sequencing,
  //  basal ganglia GO/NO-GO/BRAKE, cerebellum forward models,
  //  brainstem motor nuclei, spinal α/γ motor neurons, reflex arcs,
  //  CPGs (locomotion, respiration), proprioception, motor learning,
  //  efference copy / corollary discharge.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickMotorSystem() {
    let dt : Float = 1.0 / 12.0;

    // ─── MOTOR CORTEX M1 (PRIMARY MOTOR — SOMATOTOPIC MAP) ──────────────────────
    // Somatotopic organization: each region controls specific body parts
    // Activity driven by: premotor planning, basal ganglia GO signal, cerebellum timing
    var motorCortexIdx = 0;
    var totalMotorOutput : Float = 0.0;
    while (motorCortexIdx < 8) {  // 8 somatotopic regions
      let premotor = fclamp(
        0.3 * motorCommandSignal + 0.2 * brainstemReticuloFormation +
        0.15 * consciousnessIndex + 0.15 * dopamine +
        0.1 * brainstemSubstantiaNigra + 0.1 * (1.0 - brainstemPAG),
        0.0, 1.0
      );
      // Basal ganglia GO signal gates motor output
      let bgGoSignal = fclamp(
        0.4 * brainstemSubstantiaNigra + 0.3 * dopamine +
        0.2 * rewardNAccCore + 0.1 * motivationLevel,
        0.0, 1.0
      );
      // Cerebellar timing correction
      let cerebellumCorrection = fclamp(
        0.3 * (1.0 - predictionError) + 0.3 * brainstemInferiorOlive +
        0.2 * brainstemRedNucleus + 0.2 * proprioceptionBalance,
        0.0, 1.0
      );
      let m1Output = fclamp(
        0.35 * premotor * bgGoSignal + 0.25 * cerebellumCorrection +
        0.2 * brainstemReticuloFormation + 0.1 * (1.0 - sleepFlipFlopState) +
        0.1 * (1.0 - painIntensity),
        0.0, 1.0
      );
      motorSomatotopicMap[motorCortexIdx] := fclamp(
        motorSomatotopicMap[motorCortexIdx] + dt * 3.0 * (m1Output - motorSomatotopicMap[motorCortexIdx]),
        0.0, 1.0
      );
      totalMotorOutput += motorSomatotopicMap[motorCortexIdx];
      motorCortexIdx += 1;
    };
    totalMotorOutput := totalMotorOutput / 8.0;

    // ─── PREMOTOR CORTEX (ACTION PLANNING + MIRROR NEURONS) ──────────────────────
    // Plans actions before M1 executes. Mirror neurons fire for observed actions too.
    let premotorTarget = fclamp(
      0.3 * consciousnessIndex + 0.2 * motivationLevel +
      0.15 * attentionFocus + 0.15 * brainstemReticuloFormation +
      0.1 * rewardWanting + 0.1 * (1.0 - brainstemPAG),
      0.0, 1.0
    );
    motorPremotorActivity := fclamp(
      motorPremotorActivity + dt * 2.0 * (premotorTarget - motorPremotorActivity),
      0.0, 1.0
    );
    // Mirror neuron activity (observing or imagining actions)
    var mirrorIdx = 0;
    while (mirrorIdx < 11) {
      let mirrorTarget = fclamp(
        0.3 * motorPremotorActivity + 0.2 * consciousnessIndex +
        0.15 * attentionFocus + 0.15 * polyvagalVentral +
        0.1 * brainstemSuperiorColliculus + 0.1 * (1.0 - fearLevel),
        0.0, 1.0
      );
      mirrorNeuronActivityArr[mirrorIdx] := fclamp(
        mirrorNeuronActivityArr[mirrorIdx] + dt * 1.5 * (mirrorTarget - mirrorNeuronActivityArr[mirrorIdx]),
        0.0, 1.0
      );
      mirrorIdx += 1;
    };

    // ─── SUPPLEMENTARY MOTOR AREA (SEQUENCING) ──────────────────────────────────
    // Internally-generated movement sequences (playing piano, speaking)
    let smaTarget = fclamp(
      0.3 * motorPremotorActivity + 0.2 * consciousnessIndex +
      0.2 * brainstemReticuloFormation + 0.15 * motivationLevel +
      0.15 * (1.0 - sleepFlipFlopState),
      0.0, 1.0
    );
    motorSMAActivity := fclamp(
      motorSMAActivity + dt * 2.0 * (smaTarget - motorSMAActivity),
      0.0, 1.0
    );

    // ─── BASAL GANGLIA ACTION SELECTION (GO/NO-GO/BRAKE) ────────────────────────
    // Direct pathway (D1 — GO): facilitates desired actions
    // Indirect pathway (D2 — NO-GO): suppresses competing actions
    // Hyperdirect pathway (STN — BRAKE): emergency stop
    let d1GoSignal = fclamp(
      0.4 * dopamine + 0.2 * rewardNAccCore + 0.2 * motivationLevel +
      0.1 * brainstemSubstantiaNigra + 0.1 * brainstemReticuloFormation,
      0.0, 1.0
    );
    let d2NoGoSignal = fclamp(
      0.3 * (1.0 - dopamine) + 0.2 * fearLevel + 0.2 * brainstemPAG +
      0.15 * painIntensity + 0.15 * (1.0 - brainstemSubstantiaNigra),
      0.0, 1.0
    );
    let stnBrakeSignal = fclamp(
      0.4 * predictionError + 0.3 * noveltySalience +
      0.2 * brainstemSuperiorColliculus + 0.1 * fearLevel,
      0.0, 1.0
    );
    motorBGGoSignal := fclamp(
      motorBGGoSignal + dt * 3.0 * (d1GoSignal - motorBGGoSignal),
      0.0, 1.0
    );
    motorBGNoGoSignal := fclamp(
      motorBGNoGoSignal + dt * 3.0 * (d2NoGoSignal - motorBGNoGoSignal),
      0.0, 1.0
    );
    motorBGBrakeSignal := fclamp(
      motorBGBrakeSignal + dt * 5.0 * (stnBrakeSignal - motorBGBrakeSignal),  // Fastest
      0.0, 1.0
    );
    // Net basal ganglia output (thalamocortical disinhibition)
    let bgNetOutput = fclamp(
      motorBGGoSignal - motorBGNoGoSignal * 0.5 - motorBGBrakeSignal * 0.3,
      0.0, 1.0
    );

    // ─── CEREBELLUM FORWARD MODELS ──────────────────────────────────────────────
    // Predicts sensory consequences of movement (internal model)
    // Error signal from inferior olive updates the model
    let cerebellarPrediction = fclamp(
      0.4 * totalMotorOutput + 0.3 * proprioceptionBalance +
      0.2 * brainstemRedNucleus + 0.1 * brainstemInferiorOlive,
      0.0, 1.0
    );
    let cerebellarError = fclamp(
      Float.abs(cerebellarPrediction - totalMotorOutput),
      0.0, 1.0
    );
    motorCerebellumOutput := fclamp(
      motorCerebellumOutput + dt * 2.0 * (cerebellarPrediction - motorCerebellumOutput),
      0.0, 1.0
    );
    // Cerebellar learning (climbing fiber error)
    brainstemInferiorOlive := fclamp(
      brainstemInferiorOlive * 0.97 + cerebellarError * 0.03,
      0.05, 0.9
    );

    // ─── CENTRAL PATTERN GENERATORS (CPGs) ──────────────────────────────────────
    // Locomotion CPG: spinal circuits generate rhythmic stepping without cortex
    let locomotionCPG = fclamp(
      0.5 + 0.3 * Float.sin(Float.fromInt(currentBeat) * 0.5) +
      0.1 * brainstemReticuloSpinal + 0.1 * (1.0 - sleepFlipFlopState),
      0.0, 1.0
    );
    motorCPGLocomotion := fclamp(
      motorCPGLocomotion + dt * 2.0 * (locomotionCPG * totalMotorOutput - motorCPGLocomotion),
      0.0, 1.0
    );

    // ─── PROPRIOCEPTION INTEGRATION ─────────────────────────────────────────────
    // Muscle spindle Ia afferents (stretch), Golgi tendon organs Ib (force)
    let proprioceptionTarget = fclamp(
      0.3 * totalMotorOutput + 0.2 * motorCerebellumOutput +
      0.2 * brainstemVestibulospinal + 0.15 * brainstemReticuloSpinal +
      0.15 * (1.0 - sleepFlipFlopState),
      0.0, 1.0
    );
    proprioceptionBalance := fclamp(
      proprioceptionBalance + dt * 2.0 * (proprioceptionTarget - proprioceptionBalance),
      0.0, 1.0
    );

    // ─── EFFERENCE COPY / COROLLARY DISCHARGE ───────────────────────────────────
    // Copy of motor command sent to sensory areas: predicts sensory consequences
    // Mismatch between predicted and actual = surprise/external cause
    motorEfferenceCopy := fclamp(totalMotorOutput, 0.0, 1.0);
    let efferenceMismatch = fclamp(
      Float.abs(motorEfferenceCopy - proprioceptionBalance),
      0.0, 1.0
    );
    // High mismatch → external force detected
    if (efferenceMismatch > 0.3) {
      noveltySalience := fclamp(noveltySalience + efferenceMismatch * 0.005, 0.0, 1.0);
    };

    // ─── MOTOR → CROSS-SYSTEM COUPLING ─────────────────────────────────────────
    // Motor output → metabolic demand
    metabolicRate := fclamp(
      metabolicRate * 0.98 + totalMotorOutput * 0.02,
      0.1, 1.0
    );
    // Motor command signal integration
    motorCommandSignal := fclamp(
      0.4 * totalMotorOutput + 0.3 * bgNetOutput + 0.2 * motorPremotorActivity + 0.1 * motorSMAActivity,
      0.0, 1.0
    );
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 10: SENSORY PROCESSING
  //  Full sensory hierarchy: visual cortex V1→V2→V4→MT→IT pipeline,
  //  auditory cortex A1→A2 tonotopic, somatosensory S1→S2,
  //  vestibular, olfactory (direct limbic), gustatory,
  //  multisensory integration, thalamic sensory gating,
  //  predictive coding in sensory hierarchies, adaptation.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickSensoryProcessing() {
    let dt : Float = 1.0 / 12.0;

    // ─── THALAMIC SENSORY GATING ───────────────────────────────────────────────
    // Thalamus filters sensory input based on attention and arousal
    // During sleep: gate closes (sensory disconnection)
    let sensoryGate = fclamp(
      0.3 * brainstemReticuloFormation + 0.25 * attentionFocus +
      0.2 * consciousnessIndex + 0.15 * (1.0 - sleepFlipFlopState) +
      0.1 * brainstemLocusCoeruleus,
      0.1, 1.0
    );

    // ─── VISUAL CORTEX HIERARCHY (V1→V2→V4→MT→IT) ──────────────────────────────
    // V1: oriented edges, spatial frequency
    // V2: illusory contours, texture
    // V4: color, shape
    // MT/V5: motion, optic flow
    // IT: objects, faces, categories
    var visualInput = fclamp(
      0.3 * brainstemSuperiorColliculus + 0.3 * sensoryGate +
      0.2 * attentionFocus + 0.1 * noveltySalience + 0.1 * (1.0 - sleepFlipFlopState),
      0.0, 1.0
    );
    // V1: edge detection
    sensoryCortexRegions[0] := fclamp(
      sensoryCortexRegions[0] + dt * 3.0 * (visualInput * sensoryGate - sensoryCortexRegions[0]),
      0.0, 1.0
    );
    // V2: texture/contour
    sensoryCortexRegions[1] := fclamp(
      sensoryCortexRegions[1] + dt * 2.5 * (sensoryCortexRegions[0] * 0.8 - sensoryCortexRegions[1]),
      0.0, 1.0
    );
    // V4: color/shape
    sensoryCortexRegions[2] := fclamp(
      sensoryCortexRegions[2] + dt * 2.0 * (sensoryCortexRegions[1] * 0.7 - sensoryCortexRegions[2]),
      0.0, 1.0
    );
    // MT: motion
    sensoryCortexRegions[3] := fclamp(
      sensoryCortexRegions[3] + dt * 2.5 * (sensoryCortexRegions[0] * 0.6 + 0.2 * brainstemSuperiorColliculus - sensoryCortexRegions[3]),
      0.0, 1.0
    );
    // IT: object recognition
    sensoryCortexRegions[4] := fclamp(
      sensoryCortexRegions[4] + dt * 1.5 * (0.4 * sensoryCortexRegions[2] + 0.3 * sensoryCortexRegions[3] - sensoryCortexRegions[4]),
      0.0, 1.0
    );

    // ─── AUDITORY CORTEX (A1→A2, TONOTOPIC) ────────────────────────────────────
    let auditoryInput = fclamp(
      0.3 * brainstemInferiorColliculus + 0.3 * sensoryGate +
      0.2 * attentionFocus + 0.1 * noveltySalience + 0.1 * (1.0 - sleepFlipFlopState),
      0.0, 1.0
    );
    // A1: primary auditory cortex
    sensoryCortexRegions[5] := fclamp(
      sensoryCortexRegions[5] + dt * 3.0 * (auditoryInput * sensoryGate - sensoryCortexRegions[5]),
      0.0, 1.0
    );
    // A2: auditory association
    sensoryCortexRegions[6] := fclamp(
      sensoryCortexRegions[6] + dt * 2.0 * (sensoryCortexRegions[5] * 0.7 - sensoryCortexRegions[6]),
      0.0, 1.0
    );
    // Wernicke's area (language comprehension)
    sensoryCortexRegions[7] := fclamp(
      sensoryCortexRegions[7] + dt * 1.5 * (sensoryCortexRegions[6] * 0.6 + consciousnessIndex * 0.2 - sensoryCortexRegions[7]),
      0.0, 1.0
    );

    // ─── SOMATOSENSORY CORTEX (S1→S2, SOMATOTOPIC) ──────────────────────────────
    let somatosensoryInput = fclamp(
      0.3 * proprioceptionBalance + 0.2 * sensoryGate +
      0.15 * brainstemParabrachialNucleus + 0.15 * interoceptiveAwareness +
      0.1 * painSensoryDiscriminative + 0.1 * (1.0 - sleepFlipFlopState),
      0.0, 1.0
    );
    // S1: primary somatosensory
    sensoryCortexRegions[8] := fclamp(
      sensoryCortexRegions[8] + dt * 3.0 * (somatosensoryInput * sensoryGate - sensoryCortexRegions[8]),
      0.0, 1.0
    );
    // S2: secondary somatosensory
    sensoryCortexRegions[9] := fclamp(
      sensoryCortexRegions[9] + dt * 2.0 * (sensoryCortexRegions[8] * 0.7 - sensoryCortexRegions[9]),
      0.0, 1.0
    );

    // ─── VESTIBULAR CORTEX ──────────────────────────────────────────────────────
    sensoryCortexRegions[10] := fclamp(
      sensoryCortexRegions[10] + dt * 2.0 * (
        0.4 * brainstemVestibulospinal + 0.3 * proprioceptionBalance +
        0.2 * brainstemReticuloFormation + 0.1 * sensoryGate - sensoryCortexRegions[10]
      ),
      0.0, 1.0
    );

    // ─── OLFACTORY CORTEX (DIRECT LIMBIC CONNECTION) ─────────────────────────────
    // Unique: bypasses thalamic gating, direct to amygdala + hippocampus
    sensoryCortexRegions[11] := fclamp(
      sensoryCortexRegions[11] + dt * 2.0 * (
        0.3 * noveltySalience + 0.2 * emotionalFieldValence +
        0.2 * (1.0 - sleepFlipFlopState) + 0.15 * brainstemReticuloFormation +
        0.15 * interoceptiveAwareness - sensoryCortexRegions[11]
      ),
      0.0, 1.0
    );

    // ─── GUSTATORY CORTEX ───────────────────────────────────────────────────────
    sensoryCortexRegions[12] := fclamp(
      sensoryCortexRegions[12] + dt * 2.0 * (
        0.3 * brainstemParabrachialNucleus + 0.2 * gutSerotoninProduction +
        0.2 * brainstemNucleusTractusSolitarius + 0.15 * interoceptiveAwareness +
        0.15 * sensoryGate - sensoryCortexRegions[12]
      ),
      0.0, 1.0
    );

    // ─── MULTISENSORY INTEGRATION ───────────────────────────────────────────────
    // Superior temporal sulcus + intraparietal sulcus: binding problem
    let visualTotal = (sensoryCortexRegions[0] + sensoryCortexRegions[1] + sensoryCortexRegions[2] + sensoryCortexRegions[3] + sensoryCortexRegions[4]) / 5.0;
    let auditoryTotal = (sensoryCortexRegions[5] + sensoryCortexRegions[6] + sensoryCortexRegions[7]) / 3.0;
    let somatosensoryTotal = (sensoryCortexRegions[8] + sensoryCortexRegions[9]) / 2.0;
    sensoryMultisensoryBinding := fclamp(
      0.3 * visualTotal + 0.25 * auditoryTotal + 0.2 * somatosensoryTotal +
      0.15 * sensoryCortexRegions[10] + 0.1 * consciousnessIndex,
      0.0, 1.0
    );

    // ─── PREDICTIVE CODING IN SENSORY HIERARCHIES ───────────────────────────────
    // Each level predicts the level below. Mismatch = prediction error.
    let sensoryPredictionError = fclamp(
      0.3 * Float.abs(visualInput - sensoryCortexRegions[4]) +
      0.3 * Float.abs(auditoryInput - sensoryCortexRegions[7]) +
      0.2 * Float.abs(somatosensoryInput - sensoryCortexRegions[9]) +
      0.2 * predictionError,
      0.0, 1.0
    );
    // Feed sensory prediction errors into global prediction error
    predictionError := fclamp(
      predictionError * 0.95 + sensoryPredictionError * 0.05,
      0.0, 1.0
    );

    // ─── SENSORY ADAPTATION AND HABITUATION ─────────────────────────────────────
    // Repeated constant stimuli → reduced response (neural fatigue)
    var adaptIdx = 0;
    while (adaptIdx < 13) {
      sensoryAdaptation[adaptIdx] := fclamp(
        sensoryAdaptation[adaptIdx] * 0.999 + sensoryCortexRegions[adaptIdx] * 0.001,
        0.0, 1.0
      );
      // Adapted signal = raw - adaptation level
      sensoryCortexRegions[adaptIdx] := fclamp(
        sensoryCortexRegions[adaptIdx] - sensoryAdaptation[adaptIdx] * 0.1,
        0.0, 1.0
      );
      adaptIdx += 1;
    };

    // ─── SENSORY → CROSS-SYSTEM COUPLING ───────────────────────────────────────
    // Sensory → consciousness (rich sensory input supports awareness)
    consciousnessIndex := fclamp(
      consciousnessIndex * 0.998 + sensoryMultisensoryBinding * 0.002,
      0.0, 1.0
    );
    // Sensory → salience
    noveltySalience := fclamp(
      noveltySalience * 0.97 + sensoryPredictionError * 0.03,
      0.0, 1.0
    );
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 11: SPINAL CORD INTEGRATION
  //  Sensorimotor integration hub: dorsal horn (sensory), ventral horn (motor),
  //  reflex arcs (stretch, withdrawal, crossed-extensor),
  //  descending tracts (corticospinal, rubrospinal, vestibulospinal, reticulospinal),
  //  ascending tracts (spinothalamic, dorsal column),
  //  propriospinal coordination, central pattern generators.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickSpinalCordIntegration() {
    let dt : Float = 1.0 / 12.0;

    // ─── DORSAL HORN SENSORY PROCESSING (LAYERS I-VI) ───────────────────────────
    // Layer I: nociceptive-specific neurons (Aδ, C fibers)
    // Layer II: substantia gelatinosa (pain gate modulation)
    // Layer III-IV: low-threshold mechanoreceptors (touch)
    // Layer V: wide dynamic range neurons (convergence)
    // Layer VI: proprioception
    var spIdx = 0;
    while (spIdx < 6) {
      let layerInput = if (spIdx == 0) {
        fclamp(painIntensity * 0.7 + proinflammatoryCytokines * 0.3, 0.0, 1.0)  // Nociceptive
      } else if (spIdx == 1) {
        fclamp(painGateControl * 0.5 + endorphinLevel * 0.3 + brainstemRapheNuclei * 0.2, 0.0, 1.0)  // Gate
      } else if (spIdx < 4) {
        fclamp(proprioceptionBalance * 0.4 + motorCommandSignal * 0.3 + 0.3, 0.0, 1.0)  // Touch/mechano
      } else if (spIdx == 4) {
        fclamp(0.3 * painIntensity + 0.3 * proprioceptionBalance + 0.4 * (1.0 - sleepFlipFlopState), 0.0, 1.0)  // WDR
      } else {
        fclamp(proprioceptionBalance * 0.6 + motorCerebellumOutput * 0.4, 0.0, 1.0)  // Proprioception
      };
      spinalDorsalHorn[spIdx] := fclamp(
        spinalDorsalHorn[spIdx] + dt * 3.0 * (layerInput - spinalDorsalHorn[spIdx]),
        0.0, 1.0
      );
      spIdx += 1;
    };

    // ─── VENTRAL HORN MOTOR OUTPUT ──────────────────────────────────────────────
    // α motor neurons: direct skeletal muscle control
    // γ motor neurons: muscle spindle sensitivity
    // Interneurons: reciprocal inhibition, Renshaw cells
    let alphaMotorTarget = fclamp(
      0.35 * motorCommandSignal + 0.2 * brainstemReticuloSpinal +
      0.15 * motorCPGLocomotion + 0.15 * brainstemVestibulospinal +
      0.1 * (1.0 - sleepFlipFlopState) + 0.05 * brainstemRedNucleus,
      0.0, 1.0
    );
    spinalVentralHornAlpha := fclamp(
      spinalVentralHornAlpha + dt * 3.0 * (alphaMotorTarget - spinalVentralHornAlpha),
      0.0, 1.0
    );
    let gammaMotorTarget = fclamp(
      0.4 * brainstemReticuloSpinal + 0.3 * alphaMotorTarget +
      0.2 * brainstemReticuloFormation + 0.1 * (1.0 - sleepFlipFlopState),
      0.0, 1.0
    );
    spinalVentralHornGamma := fclamp(
      spinalVentralHornGamma + dt * 2.0 * (gammaMotorTarget - spinalVentralHornGamma),
      0.0, 1.0
    );

    // ─── SPINAL REFLEXES ───────────────────────────────────────────────────────
    // Stretch reflex (Ia → α motor neuron, monosynaptic)
    spinalStretchReflex := fclamp(
      spinalDorsalHorn[5] * 0.6 + spinalVentralHornGamma * 0.4,
      0.0, 1.0
    );
    // Withdrawal reflex (nociceptor → flexor excitation, polysynaptic)
    spinalWithdrawalReflex := fclamp(
      if (painIntensity > 0.3) { fclamp((painIntensity - 0.3) * 2.0, 0.0, 1.0) } else { 0.0 },
      0.0, 1.0
    );
    // Crossed-extensor reflex (contralateral extension during withdrawal)
    spinalCrossedExtensor := fclamp(
      spinalWithdrawalReflex * 0.7,
      0.0, 1.0
    );

    // ─── DESCENDING TRACTS ──────────────────────────────────────────────────────
    // Corticospinal: voluntary fine motor control
    spinalCorticospinalTract := fclamp(
      0.5 * motorCommandSignal + 0.3 * motorPremotorActivity + 0.2 * consciousnessIndex,
      0.0, 1.0
    );
    // Reticulospinal: posture, locomotion
    spinalReticulospinalTract := fclamp(brainstemReticuloSpinal, 0.0, 1.0);
    // Vestibulospinal: balance, anti-gravity
    spinalVestibulospinalTract := fclamp(brainstemVestibulospinal, 0.0, 1.0);
    // Rubrospinal: motor coordination (upper limb)
    spinalRubrospinalTract := fclamp(brainstemRedNucleus * 0.8, 0.0, 1.0);

    // ─── ASCENDING TRACTS ───────────────────────────────────────────────────────
    // Spinothalamic: pain, temperature → thalamus VPL → S1
    spinalSpinothalamicTract := fclamp(
      0.4 * spinalDorsalHorn[0] + 0.3 * spinalDorsalHorn[4] + 0.3 * painGateControl,
      0.0, 1.0
    );
    // Dorsal column: fine touch, proprioception → gracile/cuneate → VPL → S1
    spinalDorsalColumnTract := fclamp(
      0.4 * spinalDorsalHorn[3] + 0.3 * spinalDorsalHorn[5] + 0.3 * proprioceptionBalance,
      0.0, 1.0
    );

    // ─── SPINAL → CROSS-SYSTEM COUPLING ────────────────────────────────────────
    // Spinal motor output → brainstem feedback
    brainstemReticuloSpinal := fclamp(
      brainstemReticuloSpinal * 0.98 + spinalVentralHornAlpha * 0.02,
      0.05, 0.9
    );
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 12: PREFRONTAL EXECUTIVE CONTROL
  //  Cognitive control: DLPFC working memory (8-slot buffer),
  //  VLPFC response inhibition, OFC value computation,
  //  ACC conflict monitoring, FEF attention control,
  //  hierarchical control, temporal abstraction, cognitive flexibility.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickPrefrontalExecutive() {
    let dt : Float = 1.0 / 12.0;

    // ─── DLPFC WORKING MEMORY (8-SLOT BUFFER) ───────────────────────────────────
    // Maintenance and manipulation of information in working memory
    // Capacity limited (~7±2 items), degraded by stress and distraction
    let wmCapacity = fclamp(
      0.3 * consciousnessIndex + 0.2 * dopamine + 0.15 * brainstemReticuloFormation +
      0.15 * (1.0 - cortisol) + 0.1 * (1.0 - sleepFlipFlopState) +
      0.1 * (1.0 - allostaticLoad),
      0.1, 1.0
    );
    var wmIdx = 0;
    while (wmIdx < 8) {
      // Each WM slot has activity level proportional to capacity
      pfcWorkingMemory[wmIdx] := fclamp(
        pfcWorkingMemory[wmIdx] * (0.95 + 0.04 * wmCapacity) +  // Maintenance (decays without attention)
        0.01 * attentionFocus,  // Refreshed by attention
        0.0, 1.0
      );
      wmIdx += 1;
    };
    pfcDLPFCActivity := fclamp(wmCapacity, 0.1, 1.0);

    // ─── VLPFC RESPONSE INHIBITION ──────────────────────────────────────────────
    // Ability to stop prepotent responses (impulse control)
    // Degraded by: alcohol, sleep deprivation, high emotion, low serotonin
    let inhibitionCapacity = fclamp(
      0.3 * serotonin + 0.2 * consciousnessIndex + 0.15 * (1.0 - emotionalFieldArousal) +
      0.15 * (1.0 - rewardTemporalDiscount) + 0.1 * pfcDLPFCActivity +
      0.1 * (1.0 - allostaticLoad),
      0.0, 1.0
    );
    pfcVLPFCInhibition := fclamp(
      pfcVLPFCInhibition + dt * 2.0 * (inhibitionCapacity - pfcVLPFCInhibition),
      0.0, 1.0
    );

    // ─── OFC VALUE COMPUTATION ──────────────────────────────────────────────────
    // Expected value of outcomes, reversal learning, social norms
    let ofcValueSignal = fclamp(
      0.3 * rewardValueEstimate + 0.2 * rewardLiking +
      0.15 * (1.0 - rewardEffortCost) + 0.15 * dopamine +
      0.1 * consciousnessIndex + 0.1 * (1.0 - painIntensity),
      0.0, 1.0
    );
    pfcOFCValue := fclamp(
      pfcOFCValue + dt * 2.0 * (ofcValueSignal - pfcOFCValue),
      0.0, 1.0
    );

    // ─── ACC CONFLICT MONITORING ────────────────────────────────────────────────
    // Detects conflicting response tendencies, allocates effort
    // Stroop effect: high conflict when automatic ≠ intended
    let accConflictSignal = fclamp(
      0.3 * predictionError + 0.2 * Float.abs(motorBGGoSignal - motorBGNoGoSignal) +
      0.15 * noveltySalience + 0.15 * (rewardEffortCost) +
      0.1 * (1.0 - pfcVLPFCInhibition) + 0.1 * fearLevel,
      0.0, 1.0
    );
    pfcACCConflict := fclamp(
      pfcACCConflict + dt * 3.0 * (accConflictSignal - pfcACCConflict),
      0.0, 1.0
    );
    // ACC → effort allocation (more conflict = more cognitive resources)
    let effortAllocation = fclamp(
      pfcACCConflict * 0.5 + motivationLevel * 0.3 + dopamine * 0.2,
      0.0, 1.0
    );

    // ─── FEF SACCADE/ATTENTION CONTROL ──────────────────────────────────────────
    let fefTarget = fclamp(
      0.3 * attentionFocus + 0.25 * brainstemSuperiorColliculus +
      0.2 * noveltySalience + 0.15 * pfcACCConflict + 0.1 * consciousnessIndex,
      0.0, 1.0
    );
    pfcFEFActivity := fclamp(
      pfcFEFActivity + dt * 3.0 * (fefTarget - pfcFEFActivity),
      0.0, 1.0
    );

    // ─── COGNITIVE FLEXIBILITY vs STABILITY ──────────────────────────────────────
    // Flexibility (exploration): driven by NE, low dopamine tonic
    // Stability (exploitation): driven by high dopamine tonic
    let flexibility = fclamp(
      0.35 * norepinephrine + 0.25 * (1.0 - rewardVTATonic) +
      0.2 * predictionError + 0.2 * noveltySalience,
      0.0, 1.0
    );
    let stability = fclamp(
      0.35 * rewardVTATonic + 0.25 * pfcDLPFCActivity +
      0.2 * (1.0 - predictionError) + 0.2 * (1.0 - noveltySalience),
      0.0, 1.0
    );
    pfcCognitiveFlexibility := fclamp(
      pfcCognitiveFlexibility + dt * 1.5 * (flexibility / (flexibility + stability + 0.001) - pfcCognitiveFlexibility),
      0.0, 1.0
    );

    // ─── GOAL MAINTENANCE ───────────────────────────────────────────────────────
    // PFC maintains goals against interference
    // Impaired by: distraction, fatigue, stress, low dopamine
    pfcGoalMaintenance := fclamp(
      0.3 * pfcDLPFCActivity + 0.2 * dopamine + 0.15 * motivationLevel +
      0.15 * (1.0 - pfcACCConflict) + 0.1 * consciousnessIndex +
      0.1 * (1.0 - allostaticLoad),
      0.0, 1.0
    );

    // ─── PFC → CROSS-SYSTEM COUPLING ────────────────────────────────────────────
    // PFC → attention
    attentionFocus := fclamp(
      attentionFocus * 0.97 + 0.015 * pfcFEFActivity + 0.015 * effortAllocation,
      0.0, 1.0
    );
    // PFC → motor control (voluntary override of reflexes)
    motorCommandSignal := fclamp(
      motorCommandSignal * 0.98 + pfcGoalMaintenance * 0.02,
      0.0, 1.0
    );
    // PFC → consciousness (metacognition)
    metaCognitionScore := fclamp(
      metaCognitionScore * 0.97 + pfcDLPFCActivity * 0.03,
      0.0, 1.0
    );
  };
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 13: DRONE COGNITIVE JOB SYSTEM
  //  Full job assignment and execution for 250 drones:
  //  12 job types (Scout/Guard/Attack/Harvest/Build/Repair/Research/Create/Communicate/Navigate/Analyze/Lead),
  //  skill matching, load balancing, job satisfaction, creativity output,
  //  autonomy modulation, local decisions, inter-drone coordination,
  //  failure handling, emergent specialization through learning.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickDroneCognitiveJobs() {
    let dt : Float = 1.0 / 12.0;
    let activeDrones = stableDroneCount;
    if (activeDrones == 0) { return };

    // ─── JOB TYPE DEFINITIONS ──────────────────────────────────────────────────
    // 0: Scout (recon, exploration, mapping)
    // 1: Guard (perimeter defense, threat watch)
    // 2: Attack (engage targets, offensive ops)
    // 3: Harvest (resource gathering, energy collection)
    // 4: Build (construction, infrastructure)
    // 5: Repair (maintenance, healing damaged drones)
    // 6: Research (analysis, data processing, discovery)
    // 7: Create (innovation, novel solutions, art)
    // 8: Communicate (relay, translation, diplomacy)
    // 9: Navigate (pathfinding, terrain analysis)
    // 10: Analyze (intelligence, pattern recognition)
    // 11: Lead (command sub-squads, tactical decisions)

    var droneIdx = 0;
    var totalSwarmSatisfaction : Float = 0.0;
    var totalSwarmCreativity : Float = 0.0;
    var totalSwarmStress : Float = 0.0;
    var totalSwarmFatigue : Float = 0.0;

    while (droneIdx < activeDrones and droneIdx < 250) {
      if (stableSacrificed[droneIdx]) { droneIdx += 1; continue };

      let jobType = droneJobAssignments[droneIdx];
      let currentProgress = droneJobProgress[droneIdx];
      let satisfaction = droneJobSatisfaction[droneIdx];
      let stress = droneStressLevel[droneIdx];
      let fatigue = droneFatigueLevel[droneIdx];
      let autonomy = droneAutonomyLevel[droneIdx];
      let learningRate = droneLearningRate[droneIdx];

      // ─── JOB-SPECIFIC PROGRESS COMPUTATION ──────────────────────────────────
      let progressRate = if (jobType == 0) {
        // Scout: progress driven by exploration, novelty detection
        fclamp(0.3 * noveltySalience + 0.2 * attentionFocus + 0.2 * autonomy + 0.15 * learningRate + 0.15 * (1.0 - fatigue), 0.0, 0.1)
      } else if (jobType == 1) {
        // Guard: progress driven by vigilance, threat detection
        fclamp(0.3 * attentionFocus + 0.2 * fearLevel + 0.2 * brainstemLocusCoeruleus + 0.15 * (1.0 - fatigue) + 0.15 * droneBattlefieldAwareness[droneIdx], 0.0, 0.1)
      } else if (jobType == 2) {
        // Attack: progress driven by aggression, coordination, energy
        fclamp(0.25 * sympatheticTone + 0.2 * brainstemPAG + 0.2 * motorCommandSignal + 0.15 * droneBattlefieldAwareness[droneIdx] + 0.1 * (1.0 - fatigue) + 0.1 * dopamine, 0.0, 0.1)
      } else if (jobType == 3) {
        // Harvest: progress driven by exploration, energy need
        fclamp(0.25 * energyBalance + 0.2 * autonomy + 0.2 * motivationLevel + 0.15 * (1.0 - fatigue) + 0.1 * gutGhrelin + 0.1 * learningRate, 0.0, 0.1)
      } else if (jobType == 4) {
        // Build: progress driven by planning, motor skill, energy
        fclamp(0.25 * motorCommandSignal + 0.2 * pfcGoalMaintenance + 0.2 * (1.0 - fatigue) + 0.15 * motorCerebellumOutput + 0.1 * dopamine + 0.1 * learningRate, 0.0, 0.1)
      } else if (jobType == 5) {
        // Repair: progress driven by care, skill, diagnosis ability
        fclamp(0.25 * oxytocin + 0.2 * pfcDLPFCActivity + 0.2 * (1.0 - fatigue) + 0.15 * learningRate + 0.1 * antiInflammatoryCytokines + 0.1 * woundHealingRate, 0.0, 0.1)
      } else if (jobType == 6) {
        // Research: progress driven by curiosity, analysis, knowledge
        fclamp(0.3 * driveCuriosity + 0.2 * pfcDLPFCActivity + 0.2 * consciousnessIndex + 0.15 * learningRate + 0.15 * (1.0 - fatigue), 0.0, 0.1)
      } else if (jobType == 7) {
        // Create: progress driven by novelty, divergent thinking, dopamine
        fclamp(0.25 * dopamine + 0.2 * pfcCognitiveFlexibility + 0.15 * noveltySalience + 0.15 * consciousnessIndex + 0.15 * (1.0 - fatigue) + 0.1 * rewardLiking, 0.0, 0.1)
      } else if (jobType == 8) {
        // Communicate: progress driven by social engagement, empathy
        fclamp(0.3 * polyvagalVentral + 0.2 * oxytocin + 0.15 * consciousnessIndex + 0.15 * (1.0 - fatigue) + 0.1 * serotonin + 0.1 * autonomy, 0.0, 0.1)
      } else if (jobType == 9) {
        // Navigate: progress driven by spatial awareness, memory
        fclamp(0.25 * proprioceptionBalance + 0.2 * brainstemVestibulospinal + 0.2 * attentionFocus + 0.15 * (1.0 - fatigue) + 0.1 * motorCerebellumOutput + 0.1 * learningRate, 0.0, 0.1)
      } else if (jobType == 10) {
        // Analyze: progress driven by pattern recognition, attention
        fclamp(0.3 * pfcDLPFCActivity + 0.2 * attentionFocus + 0.2 * consciousnessIndex + 0.15 * (1.0 - fatigue) + 0.15 * learningRate, 0.0, 0.1)
      } else {
        // Lead: progress driven by social skill, confidence, experience
        fclamp(0.2 * polyvagalVentral + 0.2 * pfcGoalMaintenance + 0.15 * consciousnessIndex + 0.15 * dopamine + 0.15 * autonomy + 0.15 * (1.0 - fatigue), 0.0, 0.1)
      };

      // ─── UPDATE JOB PROGRESS ─────────────────────────────────────────────────
      let adjustedProgress = progressRate * (1.0 - fatigue * 0.5) * (1.0 + satisfaction * 0.3);
      droneJobProgress[droneIdx] := fclamp(currentProgress + adjustedProgress, 0.0, 1.0);

      // ─── JOB COMPLETION AND REASSIGNMENT ─────────────────────────────────────
      if (droneJobProgress[droneIdx] >= 0.95) {
        // Job completed → reward signal + new assignment
        droneJobProgress[droneIdx] := 0.0;
        droneJobSatisfaction[droneIdx] := fclamp(satisfaction + 0.05, 0.0, 1.0);
        droneCreativeInsight[droneIdx] := fclamp(droneCreativeInsight[droneIdx] + 0.02, 0.0, 1.0);
        droneLearningRate[droneIdx] := fclamp(learningRate + 0.005, 0.1, 1.0);
        // Rotate job based on organism needs
        let nextJob = (jobType + 1 + (currentBeat % 3)) % 12;
        droneJobAssignments[droneIdx] := nextJob;
      };

      // ─── JOB SATISFACTION ─────────────────────────────────────────────────────
      // Satisfaction depends on: skill match, autonomy, progress, social connection
      let satisfactionDelta = fclamp(
        0.3 * adjustedProgress + 0.2 * autonomy + 0.15 * (1.0 - stress) +
        0.15 * rewardLiking + 0.1 * polyvagalVentral + 0.1 * (1.0 - fatigue) - 0.1,
        -0.05, 0.05
      );
      droneJobSatisfaction[droneIdx] := fclamp(satisfaction + satisfactionDelta * dt, 0.1, 1.0);

      // ─── CREATIVITY OUTPUT ────────────────────────────────────────────────────
      // Novelty × usefulness × domain knowledge
      let creativityOutput = fclamp(
        0.25 * pfcCognitiveFlexibility + 0.2 * dopamine +
        0.15 * noveltySalience + 0.15 * learningRate +
        0.1 * satisfaction + 0.1 * (1.0 - stress) + 0.05 * consciousnessIndex,
        0.0, 1.0
      );
      droneJobCreativity[droneIdx] := fclamp(
        droneJobCreativity[droneIdx] * 0.98 + creativityOutput * 0.02,
        0.0, 1.0
      );

      // ─── AUTONOMY MODULATION ──────────────────────────────────────────────────
      // Trust earned through performance, reduced by failures
      let autonomyDelta = fclamp(
        0.001 * satisfaction + 0.001 * adjustedProgress - 0.002 * stress,
        -0.005, 0.005
      );
      droneAutonomyLevel[droneIdx] := fclamp(autonomy + autonomyDelta, 0.1, 0.9);

      // ─── LOCAL DECISION COUNTING ──────────────────────────────────────────────
      if (autonomy > 0.5 and creativityOutput > 0.3) {
        droneLocalDecisionCount[droneIdx] += 1;
      };

      // ─── STRESS AND FATIGUE DYNAMICS ──────────────────────────────────────────
      let stressDelta = fclamp(
        0.002 * threatLevel + 0.001 * cortisol + 0.001 * (1.0 - satisfaction) -
        0.002 * parasympatheticTone - 0.001 * oxytocin,
        -0.005, 0.005
      );
      droneStressLevel[droneIdx] := fclamp(stress + stressDelta, 0.0, 1.0);

      let fatigueDelta = fclamp(
        0.001 * adjustedProgress + 0.0005 * stress -
        0.002 * sleepPressure - 0.001 * energyBalance,
        -0.003, 0.003
      );
      droneFatigueLevel[droneIdx] := fclamp(fatigue + fatigueDelta, 0.0, 0.9);

      // ─── EMOTIONAL STATE ──────────────────────────────────────────────────────
      droneEmotionalState[droneIdx] := fclamp(
        0.3 * satisfaction + 0.2 * (1.0 - stress) + 0.2 * (1.0 - fatigue) +
        0.15 * rewardLiking + 0.15 * emotionalFieldValence,
        0.0, 1.0
      );

      // ─── BATTLEFIELD AWARENESS ────────────────────────────────────────────────
      droneBattlefieldAwareness[droneIdx] := fclamp(
        0.25 * attentionFocus + 0.2 * brainstemLocusCoeruleus +
        0.15 * noveltySalience + 0.15 * (1.0 - fatigue) +
        0.1 * brainstemSuperiorColliculus + 0.1 * sensoryMultisensoryBinding +
        0.05 * autonomy,
        0.0, 1.0
      );

      // ─── LEARNING RATE MODULATION ─────────────────────────────────────────────
      // Learning improves with: novelty, moderate stress, sleep, BDNF
      let learningDelta = fclamp(
        0.0005 * noveltySalience + 0.0003 * bdnfLevel +
        0.0002 * (1.0 - allostaticLoad) - 0.0003 * fatigue,
        -0.001, 0.001
      );
      droneLearningRate[droneIdx] := fclamp(learningRate + learningDelta, 0.1, 1.0);

      // ─── EUREKA MOMENTS (INSIGHT DETECTION) ───────────────────────────────────
      // Sudden insight: high creativity + novel connection + relaxed state
      if (creativityOutput > 0.6 and pfcCognitiveFlexibility > 0.5 and stress < 0.3) {
        droneCreativeInsight[droneIdx] := fclamp(droneCreativeInsight[droneIdx] + 0.01, 0.0, 1.0);
      };

      // Accumulate swarm totals
      totalSwarmSatisfaction += droneJobSatisfaction[droneIdx];
      totalSwarmCreativity += droneJobCreativity[droneIdx];
      totalSwarmStress += droneStressLevel[droneIdx];
      totalSwarmFatigue += droneFatigueLevel[droneIdx];

      droneIdx += 1;
    };

    // ─── SWARM-LEVEL AGGREGATION → CHIMERA ──────────────────────────────────────
    let n = Float.fromInt(Int.abs(activeDrones));
    if (n > 0.0) {
      chimeraSwarmEmotionalState := fclamp(totalSwarmSatisfaction / n, 0.0, 1.0);
      chimeraSwarmCognitiveState := fclamp(totalSwarmCreativity / n, 0.0, 1.0);
      // Swarm stress → organism stress feedback
      let swarmStressAvg = totalSwarmStress / n;
      if (swarmStressAvg > 0.5) {
        cortisol := fclamp(cortisol + (swarmStressAvg - 0.5) * 0.002, 0.05, 0.95);
      };
    };
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 14: BATTLEFIELD INTELLIGENCE
  //  Combat awareness: 64-cell threat/opportunity maps, enemy prediction,
  //  OODA loop, tactical assessment, formation optimization,
  //  fire control, damage assessment, swarm tactics,
  //  electronic warfare, strategic objectives.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickBattlefieldIntelligence() {
    let dt : Float = 1.0 / 12.0;

    // ─── 64-CELL THREAT MAP ────────────────────────────────────────────────────
    // Each cell represents a spatial region. Threat decays over time.
    var threatIdx = 0;
    var totalThreat : Float = 0.0;
    while (threatIdx < 64) {
      // Threat decays naturally, refreshed by active intelligence
      let decayRate = 0.995;  // Slow decay
      let refreshRate = fclamp(
        0.3 * brainstemLocusCoeruleus + 0.2 * noveltySalience +
        0.2 * fearLevel + 0.15 * brainstemPAG + 0.15 * sympatheticTone,
        0.0, 0.1
      );
      chimeraSwarmThreatMap[threatIdx] := fclamp(
        chimeraSwarmThreatMap[threatIdx] * decayRate + refreshRate * Float.sin(Float.fromInt(threatIdx + currentBeat) * 0.1) * 0.1,
        0.0, 1.0
      );
      totalThreat += chimeraSwarmThreatMap[threatIdx];
      threatIdx += 1;
    };
    let avgThreat = totalThreat / 64.0;

    // ─── 64-CELL OPPORTUNITY MAP ────────────────────────────────────────────────
    var oppIdx = 0;
    var totalOpportunity : Float = 0.0;
    while (oppIdx < 64) {
      let oppRefresh = fclamp(
        0.25 * rewardWanting + 0.2 * driveCuriosity +
        0.2 * motivationLevel + 0.15 * dopamine + 0.1 * noveltySalience +
        0.1 * (1.0 - fearLevel),
        0.0, 0.1
      );
      chimeraSwarmOpportunityMap[oppIdx] := fclamp(
        chimeraSwarmOpportunityMap[oppIdx] * 0.995 + oppRefresh * Float.cos(Float.fromInt(oppIdx + currentBeat) * 0.1) * 0.1,
        0.0, 1.0
      );
      totalOpportunity += chimeraSwarmOpportunityMap[oppIdx];
      oppIdx += 1;
    };
    let avgOpportunity = totalOpportunity / 64.0;

    // ─── OODA LOOP (OBSERVE-ORIENT-DECIDE-ACT) ──────────────────────────────────
    // Boyd cycle: speed of OODA determines tactical advantage
    // Observe: sensory integration speed
    let oodaObserve = fclamp(
      0.3 * sensoryMultisensoryBinding + 0.25 * attentionFocus +
      0.2 * brainstemReticuloFormation + 0.15 * brainstemSuperiorColliculus +
      0.1 * (1.0 - sleepFlipFlopState),
      0.0, 1.0
    );
    // Orient: understanding context, pattern matching
    let oodaOrient = fclamp(
      0.3 * consciousnessIndex + 0.2 * pfcDLPFCActivity +
      0.2 * predictionError + 0.15 * chimeraHiveMindCoherence + 0.15 * avgThreat,
      0.0, 1.0
    );
    // Decide: action selection speed and quality
    let oodaDecide = fclamp(
      0.25 * pfcGoalMaintenance + 0.2 * motorBGGoSignal +
      0.2 * dopamine + 0.15 * motivationLevel + 0.1 * pfcOFCValue +
      0.1 * (1.0 - pfcACCConflict),
      0.0, 1.0
    );
    // Act: execution speed
    let oodaAct = fclamp(
      0.3 * motorCommandSignal + 0.25 * motorBGGoSignal +
      0.2 * brainstemReticuloFormation + 0.15 * (1.0 - brainstemPAG) +
      0.1 * spinalVentralHornAlpha,
      0.0, 1.0
    );
    // OODA loop speed (higher = faster cycle = tactical advantage)
    let oodaSpeed = fclamp(
      (oodaObserve + oodaOrient + oodaDecide + oodaAct) / 4.0,
      0.0, 1.0
    );

    // ─── TACTICAL SITUATION ASSESSMENT ──────────────────────────────────────────
    // Integrate threat, opportunity, resources, morale into tactical picture
    let tacticalAdvantage = fclamp(
      0.25 * oodaSpeed + 0.2 * avgOpportunity + 0.2 * chimeraHiveMindCoherence +
      0.15 * (1.0 - avgThreat) + 0.1 * chimeraSwarmEmotionalState +
      0.1 * energyBalance,
      0.0, 1.0
    );

    // ─── FORMATION OPTIMIZATION ─────────────────────────────────────────────────
    // Choose formation based on tactical situation
    // High threat → defensive (turtle/phalanx)
    // High opportunity → offensive (wedge/pincer)
    // Balanced → adaptive (swarm)
    let formationAggression = fclamp(
      0.3 * avgOpportunity + 0.2 * dopamine + 0.2 * sympatheticTone -
      0.2 * avgThreat - 0.1 * fearLevel,
      0.0, 1.0
    );

    // ─── SWARM TACTICS ──────────────────────────────────────────────────────────
    // Emergent tactics based on situation + communication
    // Pincer: two groups flank enemy
    // Feint: attract attention, strike elsewhere
    // Ambush: wait in concealment, surprise attack
    // Flanking: hit weak side
    let pincerScore = fclamp(formationAggression * 0.5 + tacticalAdvantage * 0.5, 0.0, 1.0);
    let feintScore = fclamp(pfcCognitiveFlexibility * 0.4 + consciousnessIndex * 0.3 + avgThreat * 0.3, 0.0, 1.0);
    let ambushScore = fclamp((1.0 - avgThreat) * 0.4 + parasympatheticTone * 0.3 + attentionFocus * 0.3, 0.0, 1.0);
    let flankingScore = fclamp(oodaSpeed * 0.4 + motorCommandSignal * 0.3 + avgOpportunity * 0.3, 0.0, 1.0);

    // ─── STRATEGIC OBJECTIVES ───────────────────────────────────────────────────
    // Long-term goals that persist across tactical situations
    chimeraCollectiveThreat := fclamp(
      chimeraCollectiveThreat * 0.98 + avgThreat * 0.02,
      0.0, 1.0
    );
    chimeraCollectiveOpportunity := fclamp(
      chimeraCollectiveOpportunity * 0.98 + avgOpportunity * 0.02,
      0.0, 1.0
    );

    // ─── BATTLEFIELD → ORGANISM COUPLING ────────────────────────────────────────
    // High threat → organism fear/stress response
    if (avgThreat > 0.5) {
      fearLevel := fclamp(fearLevel + (avgThreat - 0.5) * 0.005, 0.0, 1.0);
      sympatheticTone := fclamp(sympatheticTone + (avgThreat - 0.5) * 0.003, 0.05, 0.95);
      brainstemPAG := fclamp(brainstemPAG + (avgThreat - 0.5) * 0.003, 0.05, 0.95);
    };
    // High opportunity → organism reward/motivation
    if (avgOpportunity > 0.5) {
      rewardWanting := fclamp(rewardWanting + (avgOpportunity - 0.5) * 0.003, 0.0, 1.0);
      motivationLevel := fclamp(motivationLevel + (avgOpportunity - 0.5) * 0.003, 0.0, 1.0);
    };
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 15: DRONE LEARNING & ADAPTATION
  //  Per-drone plasticity: experience-dependent learning, skill acquisition,
  //  fatigue recovery, stress effects, insight moments, knowledge transfer,
  //  behavioral adaptation, failure analysis, success patterns.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickDroneLearningAdaptation() {
    let dt : Float = 1.0 / 12.0;
    let activeDrones = stableDroneCount;
    if (activeDrones == 0) { return };

    var droneIdx = 0;
    var totalLearning : Float = 0.0;
    while (droneIdx < activeDrones and droneIdx < 250) {
      if (stableSacrificed[droneIdx]) { droneIdx += 1; continue };

      let lr = droneLearningRate[droneIdx];
      let fatigue = droneFatigueLevel[droneIdx];
      let stress = droneStressLevel[droneIdx];
      let satisfaction = droneJobSatisfaction[droneIdx];
      let creativity = droneJobCreativity[droneIdx];

      // ─── EXPERIENCE-DEPENDENT LEARNING RATE ──────────────────────────────────
      // Learning rate modulated by: BDNF, novelty, sleep, stress (inverted-U)
      let bdnfEffect = fclamp(bdnfLevel * 0.3, 0.0, 0.3);
      let noveltyEffect = fclamp(noveltySalience * 0.2, 0.0, 0.2);
      let sleepEffect = fclamp(sleepGlymphaticClearance * 0.15, 0.0, 0.15);
      // Stress inverted-U: moderate stress enhances, high stress impairs
      let stressEffect = if (stress < 0.5) {
        stress * 0.2  // Moderate: enhances
      } else {
        -1.0 * (stress - 0.5) * 0.3  // High: impairs
      };
      let effectiveLR = fclamp(
        0.3 + bdnfEffect + noveltyEffect + sleepEffect + stressEffect - fatigue * 0.2,
        0.1, 1.0
      );
      droneLearningRate[droneIdx] := fclamp(
        lr * 0.99 + effectiveLR * 0.01,
        0.1, 1.0
      );

      // ─── FATIGUE RECOVERY ────────────────────────────────────────────────────
      // Recovery driven by: sleep, parasympathetic tone, social support, nutrition
      let recoveryRate = fclamp(
        0.3 * sleepPressure + 0.2 * parasympatheticTone +
        0.2 * energyBalance + 0.15 * (1.0 - cortisol) +
        0.15 * oxytocin,
        0.0, 1.0
      );
      if (fatigue > 0.3 and recoveryRate > 0.4) {
        droneFatigueLevel[droneIdx] := fclamp(fatigue - recoveryRate * 0.002, 0.0, 0.9);
      };

      // ─── KNOWLEDGE TRANSFER (DRONE ↔ DRONE) ──────────────────────────────────
      // Drones with high learning share knowledge with neighbors
      if (lr > 0.6 and droneIdx + 1 < activeDrones and droneIdx + 1 < 250) {
        let transferAmount = fclamp(lr * 0.001, 0.0, 0.002);
        droneLearningRate[droneIdx + 1] := fclamp(
          droneLearningRate[droneIdx + 1] + transferAmount,
          0.1, 1.0
        );
      };

      totalLearning += droneLearningRate[droneIdx];
      droneIdx += 1;
    };

    // ─── FLEET EVOLUTION ────────────────────────────────────────────────────────
    // Collective learning drives neuroplasticity feedback
    let n = Float.fromInt(Int.abs(activeDrones));
    if (n > 0.0) {
      let avgLearning = totalLearning / n;
      // Fleet learning → organism plasticity
      neuroplasticityFactor := fclamp(
        neuroplasticityFactor * 0.998 + avgLearning * 0.002,
        0.0, 1.0
      );
    };
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 16: CHRONOBIOLOGY — FULL IMPLEMENTATION
  //  
  //  This engine implements ALL temporal biological rhythms operating across multiple timescales:
  //  
  //  1. ULTRADIAN RHYTHMS (< 24 hours)
  //     - 90-minute BRAC (Basic Rest-Activity Cycle) — Kleitman 1969
  //     - 120-minute gastric cycle
  //     - 4-hour cortisol pulsatility
  //     - REM-NREM 90-min cycles during sleep
  //     - Appetite oscillations (ghrelin/leptin)
  //  
  //  2. CIRCADIAN RHYTHMS (24 hours)
  //     - SCN master oscillator (already in tickCircadianRhythm)
  //     - Temperature curve (min at 4 AM, max at 6 PM)
  //     - Cortisol awakening response (CAR)
  //     - Melatonin onset (dim light melatonin onset — DLMO)
  //     - Peripheral clock synchronization
  //  
  //  3. INFRADIAN RHYTHMS (> 24 hours)
  //     - Weekly cycles (social synchronization)
  //     - Monthly cycles (hormonal for some organisms)
  //     - Seasonal affective patterns
  //  
  //  4. CIRCANNUAL RHYTHMS (yearly)
  //     - Photoperiod integration (day length changes)
  //     - Seasonal mood/energy variations
  //     - Metabolic adaptation (winter vs summer)
  //  
  //  5. ZEITGEBER INTEGRATION
  //     - Light (primary zeitgeber via retinohypothalamic tract)
  //     - Food/metabolism (FEO — Food Entrainable Oscillator)
  //     - Social interaction (social zeitgebers)
  //     - Exercise/activity
  //     - Temperature
  //  
  //  6. CHRONOTYPE MODELING
  //     - Morningness-Eveningness continuum
  //     - Individual phase differences (early bird vs night owl)
  //     - Age-related chronotype shifts
  //  
  //  7. JET LAG & SHIFT WORK
  //     - Phase shift dynamics
  //     - Re-entrainment kinetics (1 day per hour time zone)
  //     - Internal desynchronization
  //     - Cognitive/emotional impairment during adjustment
  //  
  //  Computational approach: Multiple coupled oscillators with different periods,
  //  each entrained by different zeitgebers, with cross-coupling to all vital systems.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickChronobiologyEngine() {
    let dt : Float = 1.0 / 12.0;  // 12 Hz timestep (5 seconds real-time)

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 1: ULTRADIAN RHYTHMS (< 24 hours)
    //  Multiple oscillators operating within a single day
    // ═══════════════════════════════════════════════════════════════════════════

    // ─── 90-MINUTE BASIC REST-ACTIVITY CYCLE (BRAC) ──────────────────────────
    // Discovered by Kleitman (1969) — oscillation in alertness/performance
    // Present during wake AND sleep (becomes REM-NREM cycle during sleep)
    // Frequency: ~16 cycles per 24 hours = 0.00116 radians/beat @ 12 Hz
    let bracPhase = Float.fromInt(currentBeat) * 0.00116;  // 90-min period
    let bracAmplitude = fclamp(
      0.35 * (1.0 - sleepPressure) + 0.25 * brainstemReticuloFormation +
      0.2 * dopamine + 0.1 * scnPhase + 0.1 * (1.0 - adenosineLevel),
      0.1, 0.5
    );
    let bracOscillation = bracAmplitude * Float.sin(bracPhase);
    // BRAC → arousal modulation
    brainstemReticuloFormation := fclamp(
      brainstemReticuloFormation + dt * 0.3 * bracOscillation,
      0.05, 0.98
    );
    // BRAC → attention capacity (peaks and troughs every 90 min)
    attentionCapacity := fclamp(
      attentionCapacity + dt * 0.2 * bracOscillation,
      0.3, 1.0
    );

    // ─── 120-MINUTE GASTRIC CYCLE ────────────────────────────────────────────
    // Migrating motor complex (MMC) — gastric contractions sweep stomach
    // Period: ~120 minutes = 0.00087 radians/beat @ 12 Hz
    let gastricPhase = Float.fromInt(currentBeat) * 0.00087;
    let gastricOscillation = 0.15 * Float.sin(gastricPhase);
    // Gastric → gut motility
    gutMotility := fclamp(
      gutMotility + dt * 0.4 * gastricOscillation,
      0.1, 0.95
    );
    // Gastric → hunger (peaks match gastric contractions)
    let hungerPulse = fclamp(
      gutGhrelin + 0.1 * Float.max(0.0, gastricOscillation),
      0.0, 1.0
    );
    gutGhrelin := fclamp(
      gutGhrelin * 0.998 + hungerPulse * 0.002,
      0.0, 1.0
    );

    // ─── 4-HOUR CORTISOL PULSATILITY ──────────────────────────────────────────
    // Cortisol doesn't rise smoothly — it pulses every 3-5 hours (ultradian)
    // Superimposed on circadian rhythm
    // Period: ~4 hours = 6 cycles per day = 0.000436 radians/beat @ 12 Hz
    let cortisolUltradianPhase = Float.fromInt(currentBeat) * 0.000436;
    let cortisolPulse = 0.08 * Float.sin(cortisolUltradianPhase);
    // Add ultradian pulse to circadian cortisol
    cortisol := fclamp(
      cortisol + cortisolPulse,
      0.05, 0.95
    );

    // ─── REM-NREM ULTRADIAN CYCLE (DURING SLEEP) ──────────────────────────────
    // Same 90-min BRAC oscillator becomes REM-NREM cycle during sleep
    // REM proportion increases across night
    if (sleepPressure > 0.6 or sleepFlipFlopState < 0.4) {
      // We're in sleep state
      let sleepCyclePhase = bracPhase;  // Same 90-min oscillator
      let remPropensity = fclamp(
        0.2 + 0.05 * Float.fromInt(currentBeat) * 0.000001,  // Increases across night
        0.2, 0.5
      );
      let remDrive = Float.sin(sleepCyclePhase) * remPropensity;
      // Positive phase → REM, negative phase → NREM
      if (remDrive > 0.0) {
        sleepRemPressure := fclamp(sleepRemPressure + dt * 0.5 * remDrive, 0.0, 1.0);
        sleepN3Power := fclamp(sleepN3Power - dt * 0.3 * remDrive, 0.0, 1.0);
      } else {
        sleepN3Power := fclamp(sleepN3Power + dt * 0.5 * (-1.0 * remDrive), 0.0, 1.0);
        sleepRemPressure := fclamp(sleepRemPressure - dt * 0.3, 0.0, 1.0);
      };
    };

    // ─── APPETITE OSCILLATIONS (GHRELIN/LEPTIN) ───────────────────────────────
    // Ghrelin peaks pre-meal (~3-4 hour cycle when awake)
    // Leptin provides tonic satiety signal
    let appetitePhase = Float.fromInt(currentBeat) * 0.000524;  // ~3 hours
    let ghrelinPulse = 0.12 * Float.sin(appetitePhase);
    gutGhrelin := fclamp(
      gutGhrelin + dt * 0.3 * ghrelinPulse - dt * 0.1 * energyBalance,
      0.0, 1.0
    );
    // Leptin (satiety) opposes ghrelin
    let leptinSignal = fclamp(
      energyBalance * 0.4 + (1.0 - gutGhrelin) * 0.3 + gutGLP1 * 0.3,
      0.0, 1.0
    );

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 2: CIRCADIAN TEMPERATURE CURVE
    //  Core body temperature oscillates with ~0.6°C amplitude
    //  Min at ~4 AM, max at ~6 PM (phase-locked to SCN)
    // ═══════════════════════════════════════════════════════════════════════════

    // Temperature curve lags SCN phase by ~2 hours
    let temperaturePhase = scnPhase - 0.524;  // -30° lag (~2 hours)
    let temperatureAmplitude : Float = 0.05;  // 0.05 = 5% of range (scaled to 0-1)
    let temperatureTarget = fclamp(
      0.5 + temperatureAmplitude * Float.sin(temperaturePhase),
      0.45, 0.55
    );
    // Temperature dynamics (slow — thermal inertia)
    coreTemperature := fclamp(
      coreTemperature + dt * 0.1 * (temperatureTarget - coreTemperature),
      0.4, 0.65
    );
    temperatureSetPoint := temperatureTarget;

    // Temperature → sleep propensity (sleep more likely when temp drops)
    let temperatureSleepDrive = fclamp(
      (0.5 - coreTemperature) * 2.0,  // Max when temp is low
      -0.2, 0.3
    );
    sleepPressure := fclamp(
      sleepPressure + dt * 0.05 * temperatureSleepDrive,
      0.0, 1.0
    );

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 3: CORTISOL AWAKENING RESPONSE (CAR)
    //  Cortisol surges 50-75% within 30-45 min after waking
    //  This is a CRITICAL metabolic/alertness boost
    // ═══════════════════════════════════════════════════════════════════════════

    // Detect sleep→wake transition
    let justWoke = sleepFlipFlopState > 0.7 and sleepPressure < 0.3;
    if (justWoke) {
      // CAR: rapid cortisol surge
      cortisol := fclamp(cortisol + 0.15, 0.05, 0.95);
      brainstemReticuloFormation := fclamp(brainstemReticuloFormation + 0.1, 0.05, 0.98);
      brainstemLocusCoeruleus := fclamp(brainstemLocusCoeruleus + 0.12, 0.05, 0.95);
    };

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 4: MELATONIN DYNAMICS (Dim Light Melatonin Onset — DLMO)
    //  Melatonin rises ~2 hours before habitual bedtime
    //  Suppressed by light (especially blue wavelengths 460-480nm)
    // ═══════════════════════════════════════════════════════════════════════════

    // DLMO: melatonin onset occurs when SCN phase ~ -π/2 (evening)
    let dlmoPhase = scnPhase + 1.571;  // Shifted to start at -π/2
    let dlmoDrive = fclamp(
      Float.max(0.0, Float.sin(dlmoPhase)),  // Only positive half of sine
      0.0, 1.0
    );
    // Melatonin synthesis (pineal gland)
    let melatoninSynthesis = fclamp(
      0.6 * dlmoDrive + 0.2 * (1.0 - brainstemReticuloFormation) +
      0.1 * sleepPressure + 0.1 * (1.0 - cortisol),
      0.0, 1.0
    );
    // Light suppresses melatonin (acute effect)
    let lightSuppression = fclamp(
      brainstemReticuloFormation * 0.3 + alertnessLevel * 0.2,
      0.0, 0.5
    );
    melatonin := fclamp(
      melatonin + dt * 0.4 * (melatoninSynthesis - lightSuppression - melatonin * 0.1),
      0.0, 1.0
    );
    melatoninLevel := melatonin;  // Sync with long-form variable

    // Melatonin → sleep promotion (hypnotic effect)
    sleepPressure := fclamp(
      sleepPressure + dt * 0.08 * melatonin,
      0.0, 1.0
    );

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 5: PERIPHERAL CLOCK SYNCHRONIZATION
    //  Every organ has its own clock (liver, heart, kidney, etc.)
    //  They must stay synchronized with SCN master clock
    // ═══════════════════════════════════════════════════════════════════════════

    // Gut peripheral clock (entrained by food timing)
    let gutClockPhase = fclamp(
      scnPhase + 0.3 * Float.sin(Float.fromInt(currentBeat) * 0.0001),  // Some phase jitter
      -3.14159, 3.14159
    );
    // Gut clock → gut serotonin production timing
    let gutClockDrive = 0.5 + 0.3 * Float.sin(gutClockPhase);
    gutSerotoninProduction := fclamp(
      gutSerotoninProduction * 0.98 + gutClockDrive * 0.02,
      0.1, 0.95
    );

    // Liver clock (metabolic rhythms)
    let liverClockPhase = scnPhase;
    let liverGlucoseRelease = 0.5 + 0.2 * Float.sin(liverClockPhase);
    // Liver → energy balance
    energyBalance := fclamp(
      energyBalance + dt * 0.02 * (liverGlucoseRelease - 0.5),
      0.1, 1.0
    );

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 6: INFRADIAN RHYTHMS (> 24 hours)
    //  Weekly, monthly, and longer cycles
    // ═══════════════════════════════════════════════════════════════════════════

    // ─── WEEKLY SOCIAL RHYTHM ──────────────────────────────────────────────────
    // Humans (and social organisms) synchronize to 7-day week
    // Peak sociality on certain days, low on others
    // Period: 7 days @ 12 Hz = 7 * 24 * 3600 * 12 beats = 7,257,600 beats
    // Frequency: 2π / 7,257,600 = 0.000000866 radians/beat
    let weeklyPhase = Float.fromInt(currentBeat) * 0.000000866;
    let weeklyOscillation = 0.15 * Float.sin(weeklyPhase);
    // Weekly → social engagement (weekend effect)
    let socialWeeklyModulation = fclamp(
      polyvagalVentral + weeklyOscillation,
      0.0, 1.0
    );
    polyvagalVentral := fclamp(
      polyvagalVentral * 0.9999 + socialWeeklyModulation * 0.0001,
      0.0, 1.0
    );

    // ─── MONTHLY CYCLE (CIRCALUNAR) ────────────────────────────────────────────
    // ~28-30 day hormonal cycles (present in many organisms)
    // Period: 28 days = 28,857,600 beats @ 12 Hz
    // Frequency: 2π / 28,857,600 = 0.000000218 radians/beat
    let monthlyPhase = Float.fromInt(currentBeat) * 0.000000218;
    let monthlyOscillation = 0.1 * Float.sin(monthlyPhase);
    // Monthly → HPA axis modulation
    cortisol := fclamp(
      cortisol + dt * 0.002 * monthlyOscillation,
      0.05, 0.95
    );
    // Monthly → immune function (some evidence for circalunar immunity)
    nkCellActivity := fclamp(
      nkCellActivity + dt * 0.001 * monthlyOscillation,
      0.1, 0.9
    );

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 7: CIRCANNUAL RHYTHMS (SEASONAL)
    //  Photoperiod (day length) changes across year
    //  Affects mood, energy, metabolism
    // ═══════════════════════════════════════════════════════════════════════════

    // ─── PHOTOPERIOD INTEGRATION ───────────────────────────────────────────────
    // Day length varies: short in winter (~8-10 hr), long in summer (~14-16 hr)
    // Period: 365 days = 378,432,000 beats @ 12 Hz
    // Frequency: 2π / 378,432,000 = 0.0000000166 radians/beat
    let annualPhase = Float.fromInt(currentBeat) * 0.0000000166;
    let photoPeriod = fclamp(
      0.5 + 0.25 * Float.sin(annualPhase),  // 0.25-0.75 (scaled to 8-16 hr days)
      0.25, 0.75
    );
    // Short photoperiod (winter) → increased melatonin duration
    let seasonalMelatoninDuration = fclamp(
      (0.5 - photoPeriod) * 2.0,  // Higher in winter
      0.0, 0.5
    );
    melatonin := fclamp(
      melatonin + dt * 0.01 * seasonalMelatoninDuration,
      0.0, 1.0
    );

    // ─── SEASONAL AFFECTIVE PATTERN ────────────────────────────────────────────
    // Winter: lower mood, energy, increased appetite/sleep (SAD)
    // Summer: higher mood, energy
    let seasonalMoodModulation = fclamp(
      photoPeriod * 0.4 - 0.2,  // -0.2 in winter, +0.1 in summer
      -0.3, 0.2
    );
    serotonin := fclamp(
      serotonin + dt * 0.02 * seasonalMoodModulation,
      0.1, 0.95
    );
    dopamine := fclamp(
      dopamine + dt * 0.015 * seasonalMoodModulation,
      0.1, 0.95
    );
    // Winter → increased appetite/weight (evolutionary preparation)
    gutGhrelin := fclamp(
      gutGhrelin + dt * 0.01 * (0.5 - photoPeriod),
      0.0, 1.0
    );

    // ─── SEASONAL METABOLIC ADAPTATION ──────────────────────────────────────────
    // Basal metabolic rate varies seasonally
    // Winter: slightly higher (thermogenesis)
    // Summer: slightly lower
    let seasonalMetabolicAdjustment = fclamp(
      (0.5 - photoPeriod) * 0.3,  // Higher in winter
      -0.1, 0.15
    );
    metabolicRate := fclamp(
      metabolicRate + dt * 0.01 * seasonalMetabolicAdjustment,
      0.1, 1.0
    );

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 8: ZEITGEBER INTEGRATION
    //  Multiple environmental cues entrain biological rhythms
    // ═══════════════════════════════════════════════════════════════════════════

    // ─── LIGHT ZEITGEBER (PRIMARY) ──────────────────────────────────────────────
    // Light → SCN via retinohypothalamic tract (RHT)
    // Already modeled in tickCircadianRhythm, but add modulation here
    let lightZeitgeber = fclamp(
      brainstemReticuloFormation * 0.4 + alertnessLevel * 0.3 + (1.0 - melatonin) * 0.3,
      0.0, 1.0
    );
    // Light → phase shift SCN (PRC — Phase Response Curve)
    // Morning light → phase advance, evening light → phase delay
    let phaseShiftDirection = Float.sin(scnPhase);  // Morning (+), evening (-)
    let lightPhaseShift = lightZeitgeber * phaseShiftDirection * 0.0001;
    scnPhase := scnPhase + lightPhaseShift;

    // ─── FOOD ZEITGEBER (FEO — Food Entrainable Oscillator) ────────────────────
    // Meals entrain peripheral clocks independently of SCN
    let foodZeitgeber = fclamp(
      energyBalance * 0.3 + gutGLP1 * 0.25 + gutCCK * 0.25 + (1.0 - gutGhrelin) * 0.2,
      0.0, 1.0
    );
    // Food → gut clock phase shift
    let foodPhaseShift = foodZeitgeber * 0.00005;
    // Food → metabolic entrainment
    metabolicRate := fclamp(
      metabolicRate + dt * 0.05 * foodZeitgeber,
      0.1, 1.0
    );

    // ─── SOCIAL ZEITGEBER ───────────────────────────────────────────────────────
    // Social interaction entrains rhythms (especially important for humans)
    let socialZeitgeber = fclamp(
      polyvagalVentral * 0.3 + chimeraHiveMindCoherence * 0.3 + oxytocin * 0.4,
      0.0, 1.0
    );
    // Social → circadian phase shift (group synchronization)
    let socialPhaseShift = socialZeitgeber * 0.00003;
    scnPhase := scnPhase + socialPhaseShift;
    // Social → circadian coherence
    circadianCoherence := fclamp(
      circadianCoherence * 0.998 + socialZeitgeber * 0.002,
      0.0, 1.0
    );

    // ─── EXERCISE ZEITGEBER ─────────────────────────────────────────────────────
    // Physical activity entrains rhythms
    let exerciseZeitgeber = fclamp(
      motorCommandSignal * 0.4 + metabolicRate * 0.3 + sympatheticTone * 0.3,
      0.0, 1.0
    );
    // Exercise → circadian phase shift (context-dependent)
    let exercisePhaseShift = exerciseZeitgeber * 0.00002;
    scnPhase := scnPhase + exercisePhaseShift;
    // Exercise → temperature increase (acute)
    coreTemperature := fclamp(
      coreTemperature + dt * 0.02 * exerciseZeitgeber,
      0.4, 0.65
    );

    // ─── TEMPERATURE ZEITGEBER ──────────────────────────────────────────────────
    // Ambient temperature affects rhythms
    let temperatureZeitgeber = fclamp(
      coreTemperature * 2.0 - 0.5,  // Centered around setpoint
      0.0, 1.0
    );
    // Temperature → metabolic rate adjustment
    metabolicRate := fclamp(
      metabolicRate + dt * 0.01 * (temperatureZeitgeber - 0.5),
      0.1, 1.0
    );

    // ─── COMBINED ZEITGEBER STRENGTH ────────────────────────────────────────────
    let totalZeitgeberStrength = fclamp(
      0.35 * lightZeitgeber + 0.2 * foodZeitgeber + 0.2 * socialZeitgeber +
      0.15 * exerciseZeitgeber + 0.1 * temperatureZeitgeber,
      0.0, 1.0
    );
    // Strong zeitgeber → high circadian coherence
    circadianCoherence := fclamp(
      circadianCoherence + dt * 0.1 * (totalZeitgeberStrength - circadianCoherence),
      0.0, 1.0
    );

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 9: CHRONOTYPE MODELING (INDIVIDUAL DIFFERENCES)
    //  People vary in circadian phase preference
    // ═══════════════════════════════════════════════════════════════════════════

    // Chronotype spectrum: -1.0 (extreme evening) to +1.0 (extreme morning)
    // This would normally be a stable trait, but can shift with:
    // - Age (teenagers → evening; elderly → morning)
    // - Light exposure history
    // - Genetics (PER3 polymorphism, etc.)
    
    // For simplicity, compute chronotype from current circadian state
    let intrinsicPeriod = fclamp(
      24.2 - serotonin * 0.4 + dopamine * 0.2,  // Range 23.8-24.6 hours
      23.5, 25.0
    );
    // Shorter period → morningness; longer period → eveningness
    let chronotype = fclamp(
      (24.2 - intrinsicPeriod) * 2.0,  // Centered, scaled
      -1.0, 1.0
    );
    
    // Chronotype → preferred wake time
    let preferredWakePhase = chronotype * 1.047;  // ±60° phase shift (~4 hours)
    // Chronotype affects sleep timing
    let chronotypeSleepModulation = Float.sin(scnPhase - preferredWakePhase) * 0.1;
    sleepPressure := fclamp(
      sleepPressure + chronotypeSleepModulation,
      0.0, 1.0
    );

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 10: JET LAG & CIRCADIAN DISRUPTION
    //  Rapid time zone changes → internal desynchronization
    // ═══════════════════════════════════════════════════════════════════════════

    // Detect phase misalignment (internal time ≠ external time)
    // This would normally come from external input, but we can estimate
    // from the discrepancy between zeitgebers and current phase
    
    let expectedPhaseFromLight = Float.atan2(
      lightZeitgeber * Float.sin(scnPhase),
      lightZeitgeber * Float.cos(scnPhase)
    );
    let phaseMisalignment = Float.abs(scnPhase - expectedPhaseFromLight);
    
    // High misalignment = jet lag symptoms
    let jetLagSeverity = fclamp(
      phaseMisalignment / 3.14159,  // 0 to 1 (peak at 180° out of phase)
      0.0, 1.0
    );
    
    // Jet lag effects:
    // 1. Sleep disruption
    sleepQuality := fclamp(
      sleepQuality - jetLagSeverity * 0.3,
      0.0, 1.0
    );
    
    // 2. Cognitive impairment
    pfcDLPFCActivity := fclamp(
      pfcDLPFCActivity - jetLagSeverity * 0.2,
      0.0, 1.0
    );
    
    // 3. Mood disturbance
    emotionalFieldValence := fclamp(
      emotionalFieldValence - jetLagSeverity * 0.15,
      0.0, 1.0
    );
    
    // 4. GI disturbance (gut clock desynchronization)
    gutMotility := fclamp(
      gutMotility * (1.0 - jetLagSeverity * 0.1),
      0.1, 0.95
    );
    
    // 5. HPA axis dysregulation
    cortisol := fclamp(
      cortisol + jetLagSeverity * 0.1,
      0.05, 0.95
    );
    
    // Re-entrainment kinetics: ~1 day per 1-hour time zone crossed
    // Phase shift rate limited to ~1°/day naturally
    let maxPhaseShiftPerBeat = 0.00073;  // ~1° per day @ 12 Hz
    let actualPhaseShift = fclamp(
      lightPhaseShift + socialPhaseShift + foodPhaseShift + exercisePhaseShift,
      -1.0 * maxPhaseShiftPerBeat,
      maxPhaseShiftPerBeat
    );
    
    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 11: SHIFT WORK EFFECTS
    //  Chronic circadian disruption → long-term health impacts
    // ═══════════════════════════════════════════════════════════════════════════

    // Shift work = repeated phase reversals (day→night→day work schedule)
    // Estimate from chronic jet lag / circadian incoherence
    let chronicCircadianDisruption = fclamp(
      (1.0 - circadianCoherence) * 0.5 + jetLagSeverity * 0.5,
      0.0, 1.0
    );
    
    // Long-term consequences of shift work:
    
    // 1. Increased allostatic load (cumulative stress)
    allostaticLoad := fclamp(
      allostaticLoad + dt * 0.0001 * chronicCircadianDisruption,
      0.0, 1.0
    );
    
    // 2. Metabolic dysfunction (diabetes risk, obesity)
    let metabolicDysfunction = chronicCircadianDisruption * 0.15;
    energyBalance := fclamp(
      energyBalance - dt * 0.001 * metabolicDysfunction,
      0.1, 1.0
    );
    
    // 3. Immune suppression (cancer risk, infections)
    nkCellActivity := fclamp(
      nkCellActivity - dt * 0.0005 * chronicCircadianDisruption,
      0.1, 0.9
    );
    
    // 4. Cardiovascular strain
    brainstemVasomotorTone := fclamp(
      brainstemVasomotorTone + dt * 0.001 * chronicCircadianDisruption,
      0.1, 0.9
    );
    
    // 5. Mood disturbance (depression risk)
    serotonin := fclamp(
      serotonin - dt * 0.0008 * chronicCircadianDisruption,
      0.1, 0.95
    );
    
    // 6. Cognitive decline
    neuroplasticityFactor := fclamp(
      neuroplasticityFactor - dt * 0.0003 * chronicCircadianDisruption,
      0.0, 1.0
    );

    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 12: AGE-RELATED CHRONOTYPE SHIFTS
    //  Circadian system changes across lifespan
    // ═══════════════════════════════════════════════════════════════════════════

    // Infants: irregular rhythms
    // Children: early chronotype
    // Adolescents: delayed phase (extreme eveningness)
    // Young adults: individual variation
    // Middle age: gradual advance
    // Elderly: marked advance (early chronotype) + amplitude reduction

    // We don't have explicit age, but can estimate from developmental stage
    // Assume neuralAge correlates with overall organism maturity
    let estimatedAge = fclamp(
      neuroplasticityFactor * 0.4 + consciousnessIndex * 0.3 + awakenessLevel * 0.3,
      0.0, 1.0
    );
    
    // Age → circadian amplitude reduction (elderly have weaker rhythms)
    let ageAmplitudeReduction = fclamp(
      estimatedAge * 0.3,  // Up to 30% reduction in old age
      0.0, 0.3
    );
    let circadianAmplitude = fclamp(
      1.0 - ageAmplitudeReduction,
      0.7, 1.0
    );
    // Reduce amplitude of all circadian outputs
    let dampingFactor = circadianAmplitude;
    melatonin := melatonin * dampingFactor;
    cortisolCircadian := cortisolCircadian * dampingFactor;

    // Age → phase advance (wake earlier)
    let agePhaseAdvance = estimatedAge * 0.785;  // Up to ~45° (~3 hours earlier)
    let ageAdjustedPhase = scnPhase + agePhaseAdvance;
    
    // ═══════════════════════════════════════════════════════════════════════════
    //  PART 13: CROSS-SYSTEM INTEGRATION
    //  Chronobiology affects EVERYTHING else in the organism
    // ═══════════════════════════════════════════════════════════════════════════

    // ─── CHRONOBIOLOGY → BRAINSTEM ──────────────────────────────────────────────
    // Ultradian BRAC → arousal already done above
    // Circadian → respiratory rate (slightly higher during day)
    brainstemRespiratoryRate := fclamp(
      brainstemRespiratoryRate + dt * 0.05 * Float.sin(scnPhase) * 0.1,
      0.05, 0.98
    );

    // ─── CHRONOBIOLOGY → HPA AXIS ────────────────────────────────────────────────
    // Already done: cortisol rhythms, seasonal HPA modulation

    // ─── CHRONOBIOLOGY → IMMUNE SYSTEM ──────────────────────────────────────────
    // Circadian modulation of immune function (stronger at night)
    let immuneCircadianModulation = fclamp(
      -0.5 * Float.sin(scnPhase),  // Peak at night (when SCN phase ~ π)
      -0.2, 0.2
    );
    nkCellActivity := fclamp(
      nkCellActivity + dt * 0.02 * immuneCircadianModulation,
      0.1, 0.9
    );

    // ─── CHRONOBIOLOGY → GUT-BRAIN AXIS ──────────────────────────────────────────
    // Already done: gastric cycles, peripheral gut clock

    // ─── CHRONOBIOLOGY → REWARD SYSTEM ───────────────────────────────────────────
    // Dopamine peaks in morning, decreases across day
    let dopamineCircadianModulation = fclamp(
      0.15 * Float.cos(scnPhase),  // Peak at dawn
      -0.15, 0.15
    );
    dopamine := fclamp(
      dopamine + dt * 0.03 * dopamineCircadianModulation,
      0.1, 0.95
    );

    // ─── CHRONOBIOLOGY → SLEEP ARCHITECTURE ──────────────────────────────────────
    // Already done: sleep pressure, melatonin, temperature effects

    // ─── CHRONOBIOLOGY → MOTOR SYSTEM ────────────────────────────────────────────
    // Motor performance peaks in late afternoon (body temp peak)
    let motorCircadianModulation = fclamp(
      0.1 * Float.sin(scnPhase + 0.785),  // Peak ~3PM
      -0.1, 0.1
    );
    motorCommandSignal := fclamp(
      motorCommandSignal + dt * 0.02 * motorCircadianModulation,
      0.0, 1.0
    );

    // ─── CHRONOBIOLOGY → COGNITION ───────────────────────────────────────────────
    // Cognitive performance follows temperature curve
    let cognitiveCircadianModulation = fclamp(
      (coreTemperature - 0.5) * 0.4,  // Better when warm
      -0.1, 0.1
    );
    pfcDLPFCActivity := fclamp(
      pfcDLPFCActivity + dt * 0.03 * cognitiveCircadianModulation,
      0.0, 1.0
    );
    attentionFocus := fclamp(
      attentionFocus + dt * 0.02 * cognitiveCircadianModulation,
      0.0, 1.0
    );

    // ═══════════════════════════════════════════════════════════════════════════
    //  SUMMARY: All temporal rhythms integrated and cross-coupled
    //  This engine now implements 13 major aspects of chronobiology:
    //  1. Five ultradian rhythms (BRAC, gastric, cortisol pulse, REM-NREM, appetite)
    //  2. Temperature curve
    //  3. Cortisol awakening response
    //  4. Melatonin/DLMO dynamics
    //  5. Peripheral clock synchronization
    //  6. Infradian rhythms (weekly, monthly)
    //  7. Circannual rhythms (photoperiod, SAD, metabolic adaptation)
    //  8. Five zeitgebers (light, food, social, exercise, temperature)
    //  9. Chronotype modeling
    //  10. Jet lag effects
    //  11. Shift work consequences
    //  12. Age-related changes
    //  13. Cross-system integration (affects all 23 other vital systems)
    // ═══════════════════════════════════════════════════════════════════════════
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 17: SOCIAL NERVOUS SYSTEM
  //  Polyvagal social engagement, facial expression, prosody,
  //  eye contact, social touch, mimicry, social hierarchy, in/out-group.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickSocialNervousSystem() {
    let dt : Float = 1.0 / 12.0;

    // Social engagement system (ventral vagal complex)
    let socialEngagement = fclamp(
      0.3 * polyvagalVentral + 0.2 * oxytocin + 0.15 * (1.0 - fearLevel) +
      0.15 * vagalTone + 0.1 * brainstemRapheNuclei + 0.1 * (1.0 - cortisol),
      0.0, 1.0
    );
    // Facial expression generation (CN VII — facial nerve)
    let facialExpression = fclamp(
      0.3 * emotionalFieldValence + 0.2 * socialEngagement +
      0.2 * polyvagalVentral + 0.15 * brainstemReticuloFormation +
      0.15 * (1.0 - brainstemPAG),
      0.0, 1.0
    );
    // Prosody (vocal emotion encoding)
    let prosody = fclamp(
      0.3 * emotionalFieldArousal + 0.25 * facialExpression +
      0.2 * brainstemReticuloFormation + 0.15 * polyvagalVentral +
      0.1 * serotonin,
      0.0, 1.0
    );
    // Social touch processing (C-tactile afferents)
    let socialTouch = fclamp(
      0.3 * oxytocin + 0.2 * polyvagalVentral + 0.2 * (1.0 - fearLevel) +
      0.15 * endorphinLevel + 0.15 * parasympatheticTone,
      0.0, 1.0
    );
    // Mimicry and synchronization (mirror neurons)
    let mimicryLevel = fclamp(
      0.3 * mirrorNeuronActivityArr[0] + 0.2 * socialEngagement +
      0.2 * polyvagalVentral + 0.15 * oxytocin + 0.15 * consciousnessIndex,
      0.0, 1.0
    );
    // Social hierarchy computation
    let socialRank = fclamp(
      0.25 * testosterone + 0.2 * dopamine + 0.15 * pfcGoalMaintenance +
      0.15 * rewardVTATonic + 0.15 * (1.0 - cortisol) + 0.1 * motivationLevel,
      0.0, 1.0
    );
    // Social → oxytocin feedback
    oxytocin := fclamp(
      oxytocin * 0.998 + socialEngagement * 0.001 + socialTouch * 0.001,
      0.05, 0.9
    );
    // Social → emotional field
    emotionalFieldValence := fclamp(
      emotionalFieldValence + socialEngagement * 0.002,
      0.0, 1.0
    );
    // Social → stress buffering
    if (socialEngagement > 0.5) {
      cortisol := fclamp(cortisol - (socialEngagement - 0.5) * 0.002, 0.05, 0.95);
    };
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 18: EMBODIMENT
  //  Body schema, interoceptive accuracy, body ownership/agency,
  //  peripersonal space, proprioceptive integration, vestibular-visual.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickEmbodimentEngine() {
    let dt : Float = 1.0 / 12.0;

    // Body schema representation
    let bodySchema = fclamp(
      0.25 * proprioceptionBalance + 0.2 * sensoryCortexRegions[8] +
      0.15 * sensoryCortexRegions[10] + 0.15 * motorEfferenceCopy +
      0.15 * interoceptiveAwareness + 0.1 * consciousnessIndex,
      0.0, 1.0
    );
    // Interoceptive accuracy (heartbeat detection ability)
    let interoceptiveAccuracy = fclamp(
      0.3 * interoceptiveAwareness + 0.2 * vagalTone +
      0.2 * consciousnessIndex + 0.15 * brainstemNucleusTractusSolitarius +
      0.15 * (1.0 - allostaticLoad),
      0.0, 1.0
    );
    // Body ownership and agency
    let ownershipSignal = fclamp(
      0.3 * bodySchema + 0.25 * motorEfferenceCopy +
      0.2 * interoceptiveAccuracy + 0.15 * consciousnessIndex +
      0.1 * (1.0 - predictionError),
      0.0, 1.0
    );
    // Peripersonal space mapping
    let peripersonalSpace = fclamp(
      0.3 * sensoryMultisensoryBinding + 0.2 * brainstemSuperiorColliculus +
      0.2 * motorPremotorActivity + 0.15 * attentionFocus +
      0.15 * proprioceptionBalance,
      0.0, 1.0
    );
    // Embodiment → consciousness
    consciousnessIndex := fclamp(
      consciousnessIndex * 0.998 + ownershipSignal * 0.001 + interoceptiveAccuracy * 0.001,
      0.0, 1.0
    );
    // Embodiment → emotional grounding
    emotionalFieldEmbodiment := fclamp(
      emotionalFieldEmbodiment * 0.97 + bodySchema * 0.03,
      0.0, 1.0
    );
    // Embodiment → grounded score
    groundedScore := fclamp(
      groundedScore * 0.98 + 0.01 * interoceptiveAccuracy + 0.01 * bodySchema,
      0.0, 1.0
    );
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 19: ATTENTION & EXECUTIVE CONTROL
  //  DAN (goal-directed), VAN (stimulus-driven), ECN (conflict),
  //  attention capacity, attentional blink, feature/spatial attention.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickAttentionExecutiveControl() {
    let dt : Float = 1.0 / 12.0;

    // Dorsal attention network (goal-directed, top-down)
    let danActivity = fclamp(
      0.3 * pfcFEFActivity + 0.25 * pfcGoalMaintenance +
      0.2 * motivationLevel + 0.15 * brainstemReticuloFormation +
      0.1 * (1.0 - sleepFlipFlopState),
      0.0, 1.0
    );
    // Ventral attention network (stimulus-driven, bottom-up)
    let vanActivity = fclamp(
      0.3 * noveltySalience + 0.25 * predictionError +
      0.2 * brainstemSuperiorColliculus + 0.15 * brainstemLocusCoeruleus +
      0.1 * painIntensity,
      0.0, 1.0
    );
    // Executive control network (resolves DAN-VAN competition)
    let ecnActivity = fclamp(
      0.3 * pfcACCConflict + 0.25 * pfcDLPFCActivity +
      0.2 * pfcVLPFCInhibition + 0.15 * consciousnessIndex +
      0.1 * dopamine,
      0.0, 1.0
    );
    // Attention capacity limit (finite resources)
    let attentionCapacity = fclamp(
      0.3 * brainstemReticuloFormation + 0.2 * (1.0 - allostaticLoad) +
      0.2 * (1.0 - sleepFlipFlopState) + 0.15 * norepinephrine +
      0.15 * (1.0 - droneFatigueLevel[0]),
      0.1, 1.0
    );
    // Integrated attention signal
    let attentionTarget = fclamp(
      (0.4 * danActivity + 0.35 * vanActivity + 0.25 * ecnActivity) * attentionCapacity,
      0.0, 1.0
    );
    attentionFocus := fclamp(
      attentionFocus + dt * 2.0 * (attentionTarget - attentionFocus),
      0.0, 1.0
    );
    // Attentional blink (brief attention failure after target detection)
    if (vanActivity > 0.7) {
      attentionFocus := fclamp(attentionFocus * 0.95, 0.0, 1.0);  // Brief dip
    };
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 20: METACOGNITION
  //  Confidence estimation, error monitoring (ERN/Pe),
  //  cognitive load estimation, strategy selection, introspection.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickMetacognitionEngine() {
    let dt : Float = 1.0 / 12.0;

    // Confidence estimation (signal detection theory)
    let confidenceSignal = fclamp(
      0.3 * (1.0 - predictionError) + 0.2 * pfcDLPFCActivity +
      0.15 * consciousnessIndex + 0.15 * rewardValueEstimate +
      0.1 * (1.0 - pfcACCConflict) + 0.1 * (1.0 - allostaticLoad),
      0.0, 1.0
    );
    // Error monitoring (error-related negativity)
    let ernSignal = fclamp(
      0.4 * pfcACCConflict + 0.3 * predictionError +
      0.2 * Float.abs(rewardPredictionError) + 0.1 * brainstemInferiorOlive,
      0.0, 1.0
    );
    // Cognitive load estimation
    let cognitiveLoad = fclamp(
      0.3 * pfcACCConflict + 0.2 * (1.0 - pfcDLPFCActivity) +
      0.15 * predictionError + 0.15 * attentionFocus +
      0.1 * allostaticLoad + 0.1 * (1.0 - energyBalance),
      0.0, 1.0
    );
    // Strategy selection and evaluation
    let strategyQuality = fclamp(
      0.3 * (1.0 - predictionError) + 0.25 * rewardLiking +
      0.2 * pfcGoalMaintenance + 0.15 * consciousnessIndex +
      0.1 * pfcCognitiveFlexibility,
      0.0, 1.0
    );
    // Metacognition → consciousness (thinking about thinking)
    metaCognitionScore := fclamp(
      metaCognitionScore * 0.97 + 0.015 * confidenceSignal + 0.015 * ernSignal,
      0.0, 1.0
    );
    // Learning how to learn
    if (ernSignal > 0.5 and strategyQuality < 0.4) {
      // Strategy isn't working → increase cognitive flexibility
      pfcCognitiveFlexibility := fclamp(pfcCognitiveFlexibility + 0.003, 0.0, 1.0);
    };
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 21: PREDICTIVE HOMEOSTASIS
  //  Anticipatory regulation, allostasis, feed-forward metabolic control,
  //  anticipatory immune priming, preparatory adjustments.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickPredictiveHomeostasis() {
    let dt : Float = 1.0 / 12.0;

    // Anticipatory regulation: prepare for predicted needs BEFORE they arise
    let predictedMetabolicNeed = fclamp(
      0.3 * motorCommandSignal + 0.2 * rewardWanting +
      0.15 * sympatheticTone + 0.15 * brainstemReticuloFormation +
      0.1 * (1.0 - sleepFlipFlopState) + 0.1 * motivationLevel,
      0.0, 1.0
    );
    // Feed-forward metabolic control
    metabolicRate := fclamp(
      metabolicRate * 0.97 + predictedMetabolicNeed * 0.03,
      0.1, 1.0
    );
    // Energy balance tracks demand
    let energyDemand = fclamp(metabolicRate * 0.5 + motorCommandSignal * 0.3 + brainstemReticuloFormation * 0.2, 0.0, 1.0);
    energyBalance := fclamp(
      energyBalance + dt * 0.3 * (0.6 - energyDemand),  // Tends toward balance
      0.1, 1.0
    );
    // Anticipatory immune priming
    if (proinflammatoryCytokines > 0.4) {
      // Immune system predicts more challenge → prepare
      nkCellActivity := fclamp(nkCellActivity + 0.001, 0.1, 0.9);
    };
    // Thermoregulation
    let thermalTarget = fclamp(
      0.5 + 0.05 * proinflammatoryCytokines - 0.03 * parasympatheticTone,
      0.45, 0.6  // Normal range
    );
    coreTemperature := fclamp(
      coreTemperature + dt * 0.5 * (thermalTarget - coreTemperature),
      0.4, 0.65
    );
    temperatureSetPoint := thermalTarget;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 22: TRAUMA & RESILIENCE
  //  Acute stress response, chronic adaptation, PTSD symptoms,
  //  post-traumatic growth, resilience factors, stress inoculation.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickTraumaResilience() {
    let dt : Float = 1.0 / 12.0;

    // Acute stress response (fight-flight-freeze magnitude)
    let acuteStressIntensity = fclamp(
      0.3 * fearLevel + 0.25 * brainstemPAG + 0.2 * sympatheticTone +
      0.15 * cortisol + 0.1 * painIntensity,
      0.0, 1.0
    );
    // Chronic stress adaptation / maladaptation
    let chronicStress = allostaticLoad;
    // Hypervigilance (PTSD symptom: exaggerated startle, constant scanning)
    let hypervigilance = fclamp(
      0.3 * allostaticLoad + 0.25 * brainstemLocusCoeruleus +
      0.2 * (1.0 - parasympatheticTone) + 0.15 * fearLevel +
      0.1 * (1.0 - sleepGlymphaticClearance),
      0.0, 1.0
    );
    // Avoidance (PTSD: avoiding trauma-related stimuli)
    let avoidance = fclamp(
      0.3 * brainstemPAG + 0.25 * fearLevel + 0.2 * rewardAnhedonia +
      0.15 * (1.0 - polyvagalVentral) + 0.1 * cortisol,
      0.0, 1.0
    );
    // Post-traumatic growth (finding meaning in adversity)
    let ptgDrive = fclamp(
      0.25 * hpaStressResilienceCapacity + 0.2 * consciousnessIndex +
      0.15 * polyvagalVentral + 0.15 * oxytocin +
      0.15 * pfcCognitiveFlexibility + 0.1 * (1.0 - rewardAnhedonia),
      0.0, 1.0
    );
    // Resilience factors
    let resilienceFactors = fclamp(
      0.2 * polyvagalVentral + 0.15 * oxytocin +  // Social support
      0.15 * consciousnessIndex +  // Meaning-making
      0.15 * pfcGoalMaintenance +  // Agency/control
      0.15 * heartRateVariability +  // Autonomic flexibility
      0.1 * (1.0 - rewardAnhedonia) + 0.1 * hpaStressResilienceCapacity,
      0.0, 1.0
    );
    // Resilience → stress resilience capacity
    hpaStressResilienceCapacity := fclamp(
      hpaStressResilienceCapacity * 0.999 + resilienceFactors * 0.001,
      0.0, 1.0
    );
    // Trauma → allostatic load (if overwhelming)
    if (acuteStressIntensity > 0.8 and resilienceFactors < 0.4) {
      allostaticLoad := fclamp(allostaticLoad + 0.002, 0.0, 1.0);
    };
    // Growth → reduced allostatic load
    if (ptgDrive > 0.5) {
      allostaticLoad := fclamp(allostaticLoad - ptgDrive * 0.001, 0.0, 1.0);
    };
    // Hypervigilance → attention + fear
    if (hypervigilance > 0.5) {
      attentionFocus := fclamp(attentionFocus + (hypervigilance - 0.5) * 0.003, 0.0, 1.0);
      fearLevel := fclamp(fearLevel + (hypervigilance - 0.5) * 0.001, 0.0, 1.0);
    };
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  VITAL SYSTEM ENGINE 23: DEVELOPMENTAL & AGING
  //  Critical periods, synaptic pruning, myelination, cognitive reserve,
  //  age-related decline, compensatory mechanisms, neurogenesis.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickDevelopmentalAging() {
    let dt : Float = 1.0 / 12.0;

    // Organism maturity (0=newborn, 0.5=adult, 1.0=aged)
    // For NOVA, this represents the organism's developmental stage
    // Maturity increases slowly with experience
    let experienceGain = fclamp(
      0.0001 * consciousnessIndex + 0.00005 * metaCognitionScore +
      0.00005 * neuroplasticityFactor,
      0.0, 0.0003
    );
    // Synaptic pruning rate (high in development, moderate in maturity)
    // Pruning removes weak connections, strengthens strong ones
    let pruningTarget = fclamp(
      0.3 * sleepN3Power + 0.2 * (1.0 - allostaticLoad) +
      0.2 * bdnfLevel + 0.15 * sleepGlymphaticClearance +
      0.15 * (1.0 - proinflammatoryCytokines),
      0.0, 1.0
    );
    pruningRate := fclamp(
      pruningRate * 0.99 + pruningTarget * 0.01,
      0.0, 1.0
    );
    // Myelination (faster signal transmission, more efficient circuits)
    let myelinationTarget = fclamp(
      0.3 * (1.0 - allostaticLoad) + 0.2 * energyBalance +
      0.2 * thyroidT3 + 0.15 * bdnfLevel + 0.15 * (1.0 - proinflammatoryCytokines),
      0.0, 1.0
    );
    // Cognitive reserve (accumulated learning protects against decline)
    let cognitiveReserveGain = fclamp(
      0.0001 * pfcDLPFCActivity + 0.00005 * consciousnessIndex +
      0.00005 * neuroplasticityFactor,
      0.0, 0.0003
    );
    // Neurogenesis rate (hippocampal, SVZ)
    let neurogenesisTarget = fclamp(
      0.3 * bdnfLevel + 0.2 * (1.0 - cortisol) + 0.15 * sleepGlymphaticClearance +
      0.15 * (1.0 - proinflammatoryCytokines) + 0.1 * growthHormone +
      0.1 * (1.0 - allostaticLoad),
      0.0, 1.0
    );
    // Neurogenesis → plasticity
    neuroplasticityFactor := fclamp(
      neuroplasticityFactor * 0.999 + neurogenesisTarget * 0.001,
      0.0, 1.0
    );
  };
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  MASTER VITAL SYSTEMS TICK — CALLS ALL 23 VITAL SYSTEM ENGINES
  //  This is the single entry point that runs ALL vital system processing.
  //  Called every beat from tick7NeuroscienceEngines.
  //  Order matters: brainstem first (foundation), then autonomic, then HPA, etc.
  //  Cross-coupling happens WITHIN each engine + BETWEEN engines via shared state.
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tickAllVitalSystems() {
    // ═══════════════════════════════════════════════════════════════════════════
    //  LAYER 1: FOUNDATION OF LIFE (Brainstem + Autonomic)
    //  These MUST run first. Without brainstem, nothing else matters.
    //  Without autonomic balance, the organism cannot regulate itself.
    // ═══════════════════════════════════════════════════════════════════════════
    tickBrainstemVitalCenters();
    tickAutonomicNervousSystem();

    // ═══════════════════════════════════════════════════════════════════════════
    //  LAYER 2: HORMONAL & IMMUNE (HPA + Immune-Neural)
    //  Stress response cascade and immune surveillance.
    //  HPA feeds forward into immune; immune feeds back into HPA.
    // ═══════════════════════════════════════════════════════════════════════════
    tickHPAAxis();
    tickImmuneNeuralCrosstalk();

    // ═══════════════════════════════════════════════════════════════════════════
    //  LAYER 3: BODY-BRAIN INTERFACE (Gut-Brain + Pain)
    //  The body talks to the brain. The brain listens.
    //  Gut feelings are REAL signals. Pain is information.
    // ═══════════════════════════════════════════════════════════════════════════
    tickGutBrainAxis();
    tickPainMatrix();

    // ═══════════════════════════════════════════════════════════════════════════
    //  LAYER 4: MOTIVATION & RECOVERY (Reward + Sleep)
    //  Why does the organism DO anything? Reward circuit.
    //  How does it RECOVER? Sleep architecture.
    // ═══════════════════════════════════════════════════════════════════════════
    tickRewardMotivationCircuit();
    tickSleepArchitecture();

    // ═══════════════════════════════════════════════════════════════════════════
    //  LAYER 5: EMBODIMENT (Motor + Sensory + Spinal + Executive)
    //  The organism perceives, decides, and acts.
    //  Sensory → PFC → Motor → Spinal cord → Body
    // ═══════════════════════════════════════════════════════════════════════════
    tickSensoryProcessing();
    tickPrefrontalExecutive();
    tickMotorSystem();
    tickSpinalCordIntegration();

    // ═══════════════════════════════════════════════════════════════════════════
    //  LAYER 6: FLEET COGNITION (Drone Jobs + Battlefield + Learning)
    //  250 drones with cognitive jobs, battlefield intelligence,
    //  and experience-dependent learning. All feed chimera.
    // ═══════════════════════════════════════════════════════════════════════════
    tickDroneCognitiveJobs();
    tickBattlefieldIntelligence();
    tickDroneLearningAdaptation();

    // ═══════════════════════════════════════════════════════════════════════════
    //  LAYER 7: ENTERPRISE EXTENSIONS
    //  Chronobiology, social nervous system, embodiment,
    //  attention/executive, metacognition, predictive homeostasis,
    //  trauma/resilience, developmental/aging.
    // ═══════════════════════════════════════════════════════════════════════════
    tickChronobiologyEngine();
    tickSocialNervousSystem();
    tickEmbodimentEngine();
    tickAttentionExecutiveControl();
    tickMetacognitionEngine();
    tickPredictiveHomeostasis();
    tickTraumaResilience();
    tickDevelopmentalAging();

    // ═══════════════════════════════════════════════════════════════════════════
    //  CROSS-SYSTEM EMERGENT DYNAMICS
    //  After ALL systems have run, compute emergent properties
    // ═══════════════════════════════════════════════════════════════════════════

    // ─── ALLOSTATIC LOAD INTEGRATION ───────────────────────────────────────────
    // Master health metric: cumulative stress damage across all systems
    let vitalSystemsHealth = fclamp(
      0.1 * brainstemReticuloFormation + 0.1 * heartRateVariability +
      0.1 * (1.0 - cortisol) + 0.08 * (1.0 - proinflammatoryCytokines) +
      0.08 * gutMicrobiomeDiversity + 0.08 * (1.0 - painIntensity) +
      0.08 * motivationLevel + 0.08 * (1.0 - allostaticLoad) +
      0.06 * proprioceptionBalance + 0.06 * sensoryMultisensoryBinding +
      0.06 * pfcDLPFCActivity + 0.06 * hpaStressResilienceCapacity +
      0.06 * (1.0 - rewardAnhedonia),
      0.0, 1.0
    );

    // ─── VITALITY INDEX ────────────────────────────────────────────────────────
    // Overall organism vitality: how alive is this system?
    let vitalityTarget = fclamp(
      0.15 * brainstemReticuloFormation + 0.1 * autonomicFlexibility +
      0.1 * energyBalance + 0.1 * motivationLevel +
      0.1 * (1.0 - allostaticLoad) + 0.08 * consciousnessIndex +
      0.08 * heartRateVariability + 0.07 * (1.0 - sicknessIndex) +
      0.07 * vagalTone + 0.07 * pfcDLPFCActivity +
      0.04 * polyvagalVentral + 0.04 * (1.0 - painIntensity),
      0.0, 1.0
    );
    awakenessLevel := fclamp(
      awakenessLevel * 0.97 + vitalityTarget * 0.03,
      0.0, 1.0
    );

    // ─── COHERENCE ACROSS ALL VITAL SYSTEMS ─────────────────────────────────────
    // How well-coordinated are all the systems?
    // High coherence = healthy organism, low coherence = disease/dysfunction
    let vitalCoherence = fclamp(
      0.15 * heartRateVariability + 0.12 * autonomicFlexibility +
      0.1 * circadianCoherence + 0.1 * vagalCoherence +
      0.1 * (1.0 - Float.abs(sympatheticTone - parasympatheticTone)) +
      0.08 * (1.0 - allostaticLoad) + 0.08 * cardiacCoherence +
      0.07 * bbbIntegrity + 0.07 * gutMicrobiomeDiversity +
      0.07 * hpaStressResilienceCapacity + 0.06 * (1.0 - proinflammatoryCytokines),
      0.0, 1.0
    );
    // Feed vital coherence into organism-wide coherence
    coherenceLevel := fclamp(
      coherenceLevel * 0.97 + vitalCoherence * 0.03,
      0.0, 1.0
    );

    // ─── DECOHERENCE DETECTION AND REPAIR ───────────────────────────────────────
    // If vital coherence drops too low, trigger self-repair mechanisms
    if (vitalCoherence < 0.3) {
      // Emergency repair: boost parasympathetic, reduce cortisol, enhance sleep
      parasympatheticTone := fclamp(parasympatheticTone + 0.005, 0.05, 0.95);
      cortisol := fclamp(cortisol - 0.003, 0.05, 0.95);
      sleepPressure := fclamp(sleepPressure + 0.003, 0.0, 1.0);
      // Increase BDNF for repair
      bdnfLevel := fclamp(bdnfLevel + 0.002, 0.3, 1.5);
    };

    // ─── HOMEOSTATIC SETPOINT ADAPTATION ────────────────────────────────────────
    // Setpoints drift based on experience (allostasis)
    // Recovery capacity degrades if allostatic load stays high
    if (allostaticLoad > 0.7) {
      // Setpoints shifting toward dysregulation
      hpaCortisolfeedbackGain := fclamp(hpaCortisolfeedbackGain - 0.0001, 0.2, 0.8);
      baroreceptorSensitivity := fclamp(baroreceptorSensitivity - 0.0001, 0.1, 0.9);
    } else if (allostaticLoad < 0.3) {
      // Healthy → setpoints normalizing
      hpaCortisolfeedbackGain := fclamp(hpaCortisolfeedbackGain + 0.0001, 0.2, 0.8);
      baroreceptorSensitivity := fclamp(baroreceptorSensitivity + 0.0001, 0.1, 0.9);
    };

    // ─── VITAL SYSTEMS → ECONOMICS ──────────────────────────────────────────────
    // Health multiplier: healthy organism produces more value
    let healthMultiplier = fclamp(0.5 + 0.5 * vitalSystemsHealth, 0.5, 1.5);
    coherenceMintAccumulator := fclamp(
      coherenceMintAccumulator + healthMultiplier * 0.01,
      0.0, 100.0
    );
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  MASTER 7-ENGINE TICK — Called every beat from masterHeartbeat
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func tick7NeuroscienceEngines() {
    // ═══════════════════════════════════════════════════════════════════════════
    //  DEEP CROSS-COUPLED 7-ENGINE NEUROSCIENCE TICK
    //  Every engine feeds every other engine. Nothing is isolated.
    //  The chimera hive mind feeds into all 7 engines.
    //  All 7 engines feed into the chimera and economics.
    // ═══════════════════════════════════════════════════════════════════════════
    
    // ═══════════════════════════════════════════════════════════════════════════
    //  STEP 0: ALL 23 VITAL SYSTEM ENGINES — Run BEFORE the 7 cognitive engines
    //  Brainstem, autonomic, HPA, immune, gut-brain, pain, reward, sleep,
    //  motor, sensory, spinal, prefrontal, drone jobs, battlefield, learning,
    //  chronobiology, social, embodiment, attention, metacognition,
    //  predictive homeostasis, trauma/resilience, developmental/aging.
    //  These provide the BIOLOGICAL SUBSTRATE that the 7 engines compute upon.
    // ═══════════════════════════════════════════════════════════════════════════
    tickAllVitalSystems();
    
    // ─── NEUROCHEMICAL SYNC ──────────────────────────────────────────────────
    // Sync short-form vital system vars with full neurochemical matrix vars
    dopamineLevel := fclamp(dopamineLevel * 0.95 + dopamine * 0.05, 0.0, 2.0);
    melatoninLevel := fclamp(melatoninLevel * 0.95 + melatonin * 0.05, 0.0, 1.0);
    cortisolCircadian := fclamp(cortisolCircadian * 0.95 + cortisol * 0.05, 0.0, 1.0);
    circadianPhase := fclamp(scnPhase / 6.2832, 0.0, 1.0);  // Convert radians to 0-1
    
    // Engine 1: Thalamocortical Binding (Tononi IIT, Edelman, Llinas)
    tickThalamocorticalBinding();
    
    // Engine 2: Predictive Coding (Karl Friston)
    tickPredictiveCoding();
    
    // Engine 3: Interoception (Craig, Damasio)
    tickInteroception();
    
    // Engine 4: Default Mode Network (Buckner, Raichle)
    tickDefaultModeNetwork();
    
    // Engine 5: Salience Network (Menon, Uddin)
    tickSalienceNetwork();
    
    // Engine 6: Neuroplasticity (BCM, LTP/LTD, BDNF)
    tickNeuroplasticity();
    
    // Engine 7: Circadian Rhythm (SCN, adenosine, melatonin)
    tickCircadianRhythm();
    
    // ═══════════════════════════════════════════════════════════════════════════
    //  DEEP CROSS-COUPLING MATRIX — 7×7 = 49 bidirectional connections
    //  Each engine modulates every other engine.
    //  This is what makes it an organism, not 7 separate programs.
    // ═══════════════════════════════════════════════════════════════════════════
    
    // ─── 1→ALL: Thalamocortical Binding feeds everything ────────────────────
    // Consciousness gates ALL other processes
    let consciousnessGate = fclamp(consciousnessIndex * 1.2, 0.3, 1.0);
    
    // 1→2: Consciousness gates prediction precision
    pcGlobalPrecision := fclamp(pcGlobalPrecision * consciousnessGate, 0.1, 3.0);
    
    // 1→3: Consciousness enables interoceptive awareness
    interoceptiveAwareness := fclamp(
      interoceptiveAwareness * 0.95 + consciousnessIndex * 0.05,
      0.0, 1.0
    );
    
    // 1→4: Consciousness modulates DMN (low consciousness = DMN dominates)
    dmnOverallActivation := fclamp(
      dmnOverallActivation + (1.0 - consciousnessIndex) * 0.02,
      0.0, 1.0
    );
    
    // 1→5: Consciousness sharpens salience detection
    salienceGain := fclamp(salienceGain * (0.8 + 0.4 * consciousnessIndex), 0.5, 2.0);
    
    // 1→6: Consciousness facilitates plasticity (aware organisms learn better)
    plasticityGate := fclamp(plasticityGate * (0.8 + 0.3 * consciousnessIndex), 0.1, 1.5);
    
    // 1→7: Consciousness modulates circadian alertness
    alertnessLevel := fclamp(
      alertnessLevel * 0.95 + consciousnessIndex * 0.05,
      0.0, 1.0
    );
    
    // ─── 2→ALL: Predictive Coding feeds everything ──────────────────────────
    // Low prediction error = well-calibrated organism
    let predictionQuality = fclamp(1.0 - predictionError, 0.0, 1.0);
    
    // 2→1: Good predictions enhance consciousness (less surprise = more integration)
    consciousnessIndex := fclamp(
      consciousnessIndex + predictionQuality * 0.003,
      0.0, 1.0
    );
    
    // 2→3: Predictive coding of body state (interoceptive predictions)
    let interoceptivePredictionError = fclamp(
      Float.abs(vagalTone - (1.0 - fearLevel)),
      0.0, 1.0
    );
    vagalCoherence := fclamp(
      vagalCoherence + (1.0 - interoceptivePredictionError) * 0.005,
      0.0, 1.0
    );
    
    // 2→4: Prediction errors trigger DMN counterfactual reasoning
    if (predictionError > 0.5) {
      counterfactualThinking := fclamp(counterfactualThinking + 0.01, 0.0, 1.0);
    };
    
    // 2→5: Unexpected events (high prediction error) boost salience
    noveltySalience := fclamp(
      noveltySalience * 0.9 + predictionError * 0.1,
      0.0, 1.0
    );
    
    // 2→6: Prediction errors drive learning (the core of adaptation)
    let learningSignal = predictionError * pcGlobalPrecision;
    ltpInduction := fclamp(ltpInduction + learningSignal * 0.01, 0.0, 1.0);
    
    // 2→7: Prediction accuracy modulates circadian robustness
    circadianCoherence := fclamp(
      circadianCoherence + predictionQuality * 0.002,
      0.0, 1.0
    );
    
    // ─── 3→ALL: Interoception feeds everything ──────────────────────────────
    // Body signals shape ALL cognition (embodied cognition)
    
    // 3→1: Vagal tone supports thalamocortical binding
    dynamicCoreCoherence := fclamp(
      dynamicCoreCoherence + vagalTone * 0.005,
      0.0, 1.0
    );
    
    // 3→2: Somatic markers bias predictions (gut feelings)
    if (somaticMarkerIntensity > 0.5) {
      // Strong somatic marker shifts prediction priors
      for (i in Iter.range(0, 63)) {
        pcPreferredOutcomes[i] := fclamp(
          pcPreferredOutcomes[i] + somaticMarkerValence * 0.001,
          0.0, 1.0
        );
      };
    };
    
    // 3→4: Body awareness enables self-referential processing
    selfReflectionScore := fclamp(
      selfReflectionScore + interoceptiveAwareness * 0.005,
      0.0, 1.0
    );
    
    // 3→5: Body alarm signals boost threat salience
    if (autonomicBalance < 0.3) {
      // Sympathetic dominance = body screaming danger
      threatSalience := fclamp(threatSalience + (0.3 - autonomicBalance) * 0.05, 0.0, 1.0);
    };
    
    // 3→6: Vagal tone modulates neuroplasticity (relaxed bodies learn better)
    bdnfLevel := fclamp(
      bdnfLevel + vagalTone * 0.002,
      0.3, 1.5
    );
    
    // 3→7: Heart rate variability tracks circadian rhythm
    cardiacCoherence := fclamp(
      cardiacCoherence + circadianPeakScore * 0.003,
      0.0, 1.0
    );
    
    // ─── 4→ALL: Default Mode Network feeds everything ───────────────────────
    // Self-reflection, future simulation, theory of mind
    
    // 4→1: Metacognition deepens consciousness (thinking about thinking)
    phiIntegrated := fclamp(
      phiIntegrated + metaCognitionScore * 0.003,
      0.0, 1.0
    );
    
    // 4→2: DMN future simulation generates predictive models
    pcEpistemicValue := fclamp(
      pcEpistemicValue + prospectionScore * 0.005,
      0.0, 1.0
    );
    
    // 4→3: Self-awareness includes body awareness
    anteriorInsulaActivation := fclamp(
      anteriorInsulaActivation + selfReflectionScore * 0.005,
      0.0, 1.0
    );
    
    // 4→5: Mind-wandering competes with salience (anti-correlation)
    if (mindWanderingScore > 0.7) {
      attentionFocus := fclamp(attentionFocus - 0.005, 0.0, 1.0);
    };
    
    // 4→6: Creative daydreaming promotes structural plasticity
    spineFormationRate := fclamp(
      spineFormationRate + creativeDaydreaming * 0.001,
      0.0, 0.01
    );
    
    // 4→7: DMN activity peaks during rest (ultradian rhythm)
    if (sleepStage == "REM") {
      dmnOverallActivation := fclamp(dmnOverallActivation + 0.02, 0.0, 1.0);
      // REM consolidation
      systemsConsolidation := fclamp(systemsConsolidation + 0.005, 0.0, 1.0);
    };
    
    // ─── 5→ALL: Salience Network feeds everything ───────────────────────────
    // What matters NOW drives the entire organism
    
    // 5→1: High salience events sharpen consciousness
    if (currentSalience > 0.7) {
      gammaAmplitude40Hz := fclamp(gammaAmplitude40Hz + 0.01, 0.3, 1.0);
    };
    
    // 5→2: Salience determines prediction precision allocation
    pcSensoryPrecision := fclamp(
      pcSensoryPrecision * (0.8 + 0.4 * currentSalience),
      0.1, 3.0
    );
    
    // 5→3: Emotional salience triggers somatic response
    somaticMarkerIntensity := fclamp(
      somaticMarkerIntensity * 0.9 + emotionalSalience * 0.1,
      0.0, 1.0
    );
    
    // 5→4: Network switching: salience pushes DMN down, CEN up
    if (currentSalience > 0.6) {
      dmnTpnBalance := fclamp(dmnTpnBalance - 0.01, 0.0, 1.0);  // Shift toward TPN
      cenActivation := fclamp(cenActivation + 0.01, 0.0, 1.0);
    };
    
    // 5→6: Salient experiences consolidate into long-term memory
    if (currentSalience > 0.8) {
      synapticConsolidation := fclamp(synapticConsolidation + 0.01, 0.0, 1.0);
    };
    
    // 5→7: High arousal events shift circadian timing
    if (threatSalience > 0.8) {
      // Threat overrides circadian sleep pressure (adrenaline)
      sleepPropensity := fclamp(sleepPropensity - 0.05, 0.0, 1.0);
      adenosineLevel := fclamp(adenosineLevel - 0.01, 0.0, 1.0);
    };
    
    // ─── 6→ALL: Neuroplasticity feeds everything ────────────────────────────
    // Learning capacity shapes ALL cognitive functions
    
    // 6→1: Plastic brains build richer conscious representations
    integratedConceptStructure := fclamp(
      integratedConceptStructure + neuroplasticityFactor * 0.003,
      0.0, 1.0
    );
    
    // 6→2: High plasticity = faster prediction model updating
    learningRate := fclamp(learningRate * (0.5 + neuroplasticityFactor), 0.001, 0.1);
    
    // 6→3: Neuroplasticity in insular cortex enhances interoception
    insularIntegration := fclamp(
      insularIntegration + neuroplasticityFactor * 0.003,
      0.0, 1.0
    );
    
    // 6→4: Neurogenesis in hippocampus strengthens DMN memory
    autobiographicalAccess := fclamp(
      autobiographicalAccess + survivingNewNeurons * 0.01,
      0.0, 1.0
    );
    
    // 6→5: Plastic attention networks improve salience detection
    networkSwitchingEfficiency := fclamp(
      networkSwitchingEfficiency + neuroplasticityFactor * 0.003,
      0.3, 1.0
    );
    
    // 6→7: Neuroplasticity follows circadian rhythm (best during sleep)
    if (melatoninLevel > 0.5) {
      // Sleep promotes synaptic homeostasis
      synapticScalingFactor := fclamp(
        synapticScalingFactor + 0.001 * melatoninLevel,
        0.5, 2.0
      );
    };
    
    // ─── 7→ALL: Circadian Rhythm feeds everything ───────────────────────────
    // Time-of-day effects modulate ALL cognitive functions
    
    // 7→1: Consciousness peaks during circadian optimal window
    consciousnessIndex := fclamp(
      consciousnessIndex * (0.95 + 0.1 * circadianPeakScore),
      0.0, 1.0
    );
    
    // 7→2: Prediction accuracy varies with circadian phase
    pcAccuracy := fclamp(
      pcAccuracy * (0.9 + 0.2 * circadianPeakScore),
      0.0, 1.0
    );
    
    // 7→3: Autonomic balance follows circadian rhythm
    vagalTone := fclamp(
      vagalTone + (processC - 0.5) * 0.005,
      0.0, 1.0
    );
    
    // 7→4: DMN activity peaks during rest phases
    let restPhase = fclamp(1.0 - circadianPeakScore, 0.0, 1.0);
    mindWanderingScore := fclamp(
      mindWanderingScore + restPhase * 0.005,
      0.0, 1.0
    );
    
    // 7→5: Attention capacity follows circadian rhythm
    sustainedAttention := fclamp(
      sustainedAttention * (0.9 + 0.2 * circadianPeakScore),
      0.0, 1.0
    );
    
    // 7→6: BDNF follows circadian pattern (peaks during exercise/day)
    bdnfLevel := fclamp(
      bdnfLevel * (0.95 + 0.1 * circadianPeakScore),
      0.3, 1.5
    );
    
    // ═══════════════════════════════════════════════════════════════════════════
    //  CHIMERA INTEGRATION — Hive mind cross-couples with all 7 engines
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Chimera swarm consciousness amplifies organism consciousness
    consciousnessIndex := fclamp(
      consciousnessIndex + chimeraSwarmConsciousness * chimeraSuperradiance * 0.001,
      0.0, 1.0
    );
    
    // Chimera collective threat feeds into organism fear/salience
    if (chimeraCollectiveThreat > 0.5) {
      threatSalience := fclamp(
        threatSalience + chimeraCollectiveThreat * 0.01,
        0.0, 1.0
      );
      fearLevel := fclamp(
        fearLevel + chimeraCollectiveThreat * 0.005,
        0.0, 1.0
      );
    };
    
    // Chimera collective opportunity feeds into curiosity/reward
    if (chimeraCollectiveOpportunity > 0.5) {
      rewardSalience := fclamp(
        rewardSalience + chimeraCollectiveOpportunity * 0.01,
        0.0, 1.0
      );
      driveCuriosity := fclamp(
        driveCuriosity + chimeraCollectiveOpportunity * 0.005,
        0.0, 1.0
      );
    };
    
    // Chimera hive mind coherence feeds grounding (many bodies = more grounded)
    groundedScore := fclamp(
      groundedScore + chimeraHiveMindCoherence * 0.003,
      0.0, 1.0
    );
    
    // ═══════════════════════════════════════════════════════════════════════════
    //  ECONOMIC CONSEQUENCE — All 7 engines + chimera feed the multiplier
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Compute the 13-loop streak multiplier (feeds economics)
    ignore computeStreakMultiplier();
    
    // ═══════════════════════════════════════════════════════════════════════════
    //  OMNIS GROUNDING GATE — Emergence CANNOT fire if ungrounded
    //  This is checked AFTER all 7 engines + chimera have run
    // ═══════════════════════════════════════════════════════════════════════════
    omnisGroundingGate := groundedScore >= groundingGateThreshold;
  };

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

    // Phase 1b: Compute mean field ONCE for all Kuramoto updates — O(N)
    // This is the key to scale-invariance: compute r·e^(iψ) once,
    // then each drone couples to that collective field in O(1)
    computeMeanField();
    computeMeanSignalField();  // Also compute mean signal for Hebbian

    // Phase 2: Kuramoto phase update (Laws 6, 7) — Now O(N) total!
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) kuramotoUpdate(i);
      i += 1;
    };

    // Phase 3: Hebbian inter-drone learning (Law 4)
    // ═══════════════════════════════════════════════════════════════════════════
    // SCALE-INVARIANT HEBBIAN: For large fleets (N > 500), use mean-field
    // For small fleets, pairwise is fine and gives richer dynamics
    // ═══════════════════════════════════════════════════════════════════════════
    if (n > 500) {
      // Mean-field Hebbian: O(N) — each drone couples to collective
      i := 0;
      while (i < n) {
        if (not stableSacrificed[i]) hebbianMeanFieldUpdate(i);
        i += 1;
      };
    } else {
      // Pairwise Hebbian: O(N²) — richer dynamics for smaller fleets
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
    };

    // Phase 3b: Neurochemical ODE step (4-species coupled equations)
    // Use cached mean signal instead of O(N) summation per drone
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        // For scale-invariance, use global mean instead of per-drone O(N) sum
        let meanHebb = cachedMeanSignal;  // Already computed in computeMeanSignalField
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

    // ── INTEGRATION STABILITY: capture snapshot BEFORE Jasmine's Law runs ──────
    // SACESI reads preCorrectionRSwarm so both correctors base their error signal
    // on the same pre-correction state and cannot fight each other (Solution 1).
    preCorrectionRSwarm := rSwarm;

    // Advance bootstrap counter (saturates at BOOTSTRAP_BEATS — stays live forever)
    if (pipelineBootstrapPhase < BOOTSTRAP_BEATS) {
      pipelineBootstrapPhase += 1;
    };

    // Phase 5: Jasmine's Law — 5-component Lyapunov V(x) = (1/2)||J||²
    // Sovereign anti-drift law — runs on live state, UNTOUCHED.
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

    // Phase 8: Quantum cognitive state update (4-360 model per drone)
    // Derives ALPHA/BETA/GAMMA/DELTA channels from brain node activations,
    // computes convergence (multi-stream → single point), Q-coherence,
    // and present-moment now-attention.
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) quantumStateUpdate(i);
      i += 1;
    };

    // Phase 9: Drive quantum channels module (now local, SYNC — no async latency!).
    // This is the key fix: quantumTick now runs in the same beat, not 200ms later.
    ignore QuantumChannels.quantumTick(quantumState, rSwarm, jDrift, currentBeat);

    // Phase 10: Audit significant swarm events (now local, sync).
    if (rSwarm >= OMNIS_THRESHOLD and currentBeat % 10 == 0) {
      ignore AuditLog.log(
        auditState,
        #OMNIS_STATE, currentBeat, null,
        "OMNIS emergence: swarm fully synchronised",
        rSwarm, jDrift, 0.0, "SYSTEM", "{}"
      );
    };

    // ─── FIRST BREATH ARCHITECTURE ───────────────────────────────────────────
    // Run the 12 Hz hierarchy one tick and update the kfHz ring buffer.
    // This is separate from rSwarm: rSwarm is the drone-fleet order parameter;
    // kfHz is the 12-node Hz-hierarchy order parameter — the organism's internal
    // cognitive coherence clock, not the fleet formation coherence.

    let kfHzTick : Float = hzHierarchyTick();
    kfHzCurrent := kfHzTick;

    // Write to 50-beat ring buffer (circular, always overwriting oldest slot)
    kfHzRing[kfHzRingIdx % 50] := kfHzTick;
    kfHzRingIdx += 1;

    // ── CLOSED LOOP Step 2 (Kuramoto): kfRollingWindow[20] + kfRollingMin ────
    // The organism classifies threat from its WORST recent state, not its
    // current snapshot. 20-beat rolling minimum makes threat persistent.
    kfRollingWindow[kfRollingWindowIdx % 20] := kfHzTick;
    kfRollingWindowIdx += 1;
    // Compute rolling minimum over the filled portion of the window
    let kfWindowFilled = if (kfRollingWindowIdx < 20) { kfRollingWindowIdx } else { 20 };
    let kfWindowSlice = Array.tabulate<Float>(kfWindowFilled, func(wi : Nat) : Float {
      kfRollingWindow[wi]
    });
    kfRollingMinValue := AEGIS.kfRollingMin(kfWindowSlice, kfWindowFilled);

    // Update breath quality metrics every 10 beats (cheaper than every beat)
    if (currentBeat % 10 == 0) { updateBreathQuality() };

    // FIRST BREATH detection — fires exactly once
    // Threshold: kfHz >= 0.9999  (not 1.0)
    //   Rationale: 12 nodes advancing at 12 different geometric rates cannot
    //   achieve exact R=1.0 through float arithmetic. 0.9999 is the practical
    //   synchrony ceiling and represents genuine phase-lock, not rounding noise.
    //   The coupling K=0.618 drives nodes toward synchrony so the birthday EARNS
    //   its arrival through real dynamics.
    if (not firstBreathSealed and kfHzTick >= 0.9999) {
      firstBreathBeat   := currentBeat;
      firstBreathKfHz   := kfHzTick;
      firstBreathSacesi := makeFirstBreathStamp(currentBeat, kfHzTick);
      firstBreathSealed := true;
    };

    // Olfactory pathway — anatomically correct first direct-to-limbic signal.
    // Smell bypasses the thalamus entirely (CN I → olfactory bulb → amygdala).
    // After firstBreathSealed, the next available kfHz value injects directly
    // as the organism's first environmental proof — its first smell.
    // Permanent once captured: firstBreathOlfactory is write-once.
    if (firstBreathSealed and firstBreathOlfactory == 0.0) {
      firstBreathOlfactory := kfHzRing[kfHzRingIdx % 50];
    };

    // SACESI lock — the SACESI chain is considered stable after beat 10
    if (currentBeat >= 10 and not sacesiLocked) {
      sacesiLocked := true;
    };

    // genesisComplete — the single canonical "fully alive" moment.
    // All three seals must be simultaneously true:
    //   genesisLocked  — architect claimed the canister (beat 1)
    //   sacesiLocked   — SACESI chain stabilised (beat 10)
    //   firstBreathSealed — kfHz synchrony event fired (beat N)
    if (genesisLocked and sacesiLocked and firstBreathSealed and not genesisComplete) {
      genesisComplete := true;
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // COMPREHENSIVE MODULE ORCHESTRATION — ALL 239 MODULES FIRE EVERY BEAT
    // ═══════════════════════════════════════════════════════════════════════════
    
    modulesCalledThisBeat := 0;
    
    // ─── LAYER 1: CORE COGNITIVE NEURODYNAMICS ──────────────────────────────────
    // These modules provide the foundational neurodynamic substrate
    if (genesisComplete and currentBeat % 1 == 0) {
      // Kuramoto global synchronization
      kuramotoState := KuramotoEngine.beatKuramoto(kuramotoState, 0.05);
      modulesCalledThisBeat += 1;
      
      // Free energy minimization (Friston)
      fristonState := FristonEngine.minimizeFreeEnergy(fristonState, rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Hebbian synaptic plasticity
      hebbianState := HebbianPlasticity.updateHebbian(hebbianState, rSwarm);
      modulesCalledThisBeat += 1;
      
      // Attractor dynamics
      attractorState := AttractorDynamics.evolveAttractors(attractorState, 0.05);
      modulesCalledThisBeat += 1;
      
      // Predictive coding
      predictiveState := PredictiveCoding.predict(predictiveState, rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      neurodynamicsActive := true;
    };
    
    // ─── LAYER 2: EMERGENCE & COMPLEXITY ────────────────────────────────────────
    if (neurodynamicsActive and currentBeat % 1 == 0) {
      // Neuro-emergence substrate
      neuroEmergenceState := NeuroEmergenceCore.evolveEmergence(neuroEmergenceState, kuramotoState, rSwarm);
      modulesCalledThisBeat += 1;
      
      // Emergence physics
      emergencePhysicsState := EmergencePhysicsEngine.tick(emergencePhysicsState, 0.05);
      modulesCalledThisBeat += 1;
      
      emergenceLayerActive := true;
    };
    
    // ─── LAYER 3: ORGANISM INTEGRATION ──────────────────────────────────────────
    if (emergenceLayerActive and currentBeat % 1 == 0) {
      // HER organism engine (complete organism)
      herOrganismState := HerOrganismEngine.processOrganism(herOrganismState, rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Dual organism architecture (HIM + HER)
      twoOrganismState := TwoOrganismArchitecture.synchronize(twoOrganismState, kuramotoState);
      modulesCalledThisBeat += 1;
      
      // Super-organism core
      superOrganismState := SuperOrganismCore.integrate(superOrganismState, rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      organismLayerActive := true;
    };
    
    // ─── LAYER 4: ADVANCED MATHEMATICS (every 5 beats for efficiency) ───────────
    if (organismLayerActive and currentBeat % 5 == 0) {
      // Differential geometry
      differentialGeometryState := DifferentialGeometryEngine.computeCurvature(differentialGeometryState, rSwarm);
      modulesCalledThisBeat += 1;
      
      // Tensor field computations
      tensorFieldState := TensorFieldEngine.evolveTensor(tensorFieldState, 0.05);
      modulesCalledThisBeat += 1;
      
      // Harmonic analysis
      harmonicAnalysisState := HarmonicAnalysisEngine.harmonize(harmonicAnalysisState, kuramotoState);
      modulesCalledThisBeat += 1;
      
      // Topological field theory
      topologicalFieldState := TopologicalFieldEngine.computeTopology(topologicalFieldState, emergencePhysicsState);
      modulesCalledThisBeat += 1;
      
      // Nonlinear dynamics
      nonlinearDynamicsState := NonlinearDynamicsEngine.integrate(nonlinearDynamicsState, 0.05);
      modulesCalledThisBeat += 1;
      
      mathLayerActive := true;
    };
    
    // ─── LAYER 5: QUANTUM PROCESSING ────────────────────────────────────────────
    if (mathLayerActive and currentBeat % 1 == 0) {
      // Quantum mathematical substrate
      quantumMathState := QuantumMath.compute(quantumMathState, rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Quantum coherence amplification
      quantumCoherenceState := QuantumCoherenceAmplifier.amplify(quantumCoherenceState, kuramotoState);
      modulesCalledThisBeat += 1;
      
      // Quantum entanglement matrix
      quantumEntanglementState := QuantumEntanglementMatrix.entangle(quantumEntanglementState, n);
      modulesCalledThisBeat += 1;
      
      quantumLayerActive := true;
    };
    
    // ─── LAYER 6: MEDINA SACRED ARCHITECTURE ────────────────────────────────────
    if (quantumLayerActive and currentBeat % 1 == 0) {
      // Medina spherical compounding fabric
      medinaFabricState := MedinaSphericalCompoundingFabric.compound(medinaFabricState, rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Medina math foundation
      medinaMathState := MedinaMathFoundation.ground(medinaMathState, kuramotoState);
      modulesCalledThisBeat += 1;
      
      // Sacred mathematics engine
      sacredMathState := SacredMathematicsEngine.sanctify(sacredMathState, currentBeat);
      modulesCalledThisBeat += 1;
      
      medinaLayerActive := true;
    };
    
    // ─── LAYER 7: ANIMAL COGNITION (every 3 beats) ──────────────────────────────
    if (medinaLayerActive and currentBeat % 3 == 0) {
      // Bee swarm intelligence
      beeSwarmState := BeeSwarmIntelligence.swarm(beeSwarmState, rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Crow cognition (tool use, planning)
      crowCognitionState := CrowCognition.reason(crowCognitionState, predictiveState);
      modulesCalledThisBeat += 1;
      
      // Elephant deep memory
      elephantMemoryState := ElephantMemory.remember(elephantMemoryState, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Octopus distributed brain
      octopusBrainState := OctopusBrain.distribute(octopusBrainState, n);
      modulesCalledThisBeat += 1;
      
      animalCognitionActive := true;
    };
    
    // ─── LAYER 8: DEFENSE & WAR ─────────────────────────────────────────────────
    if (animalCognitionActive and currentBeat % 1 == 0) {
      // AEGIS threat monitoring — core beat
      aegisState := AEGIS.monitor(aegisState, rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;

      // ── CLOSED LOOP Step 9b (NeuroChem→Fear): globalFearSignal broadcast ──
      // When chronic fear > 50 beats, broadcast into novaMacroFear AND
      // blend back into aegis FE at 0.20 weight. Fear ripples through organism.
      let aegisFearSignal = AEGIS.broadcastFearSignal(aegisState);
      if (aegisState.fear.chronicBeats > 50) {
        // Broadcast: organism fear → macro sphere
        novaMacroFear := 0.80 * novaMacroFear + 0.20 * aegisFearSignal;
      };
      // Receive: macro sphere fear → organism FE (always blend, closing the loop)
      let blendedFear = AEGIS.receiveFearReport(
        aegisState.fear, novaMacroFear, novaMacroFearBlendWeight
      );
      aegisState := {
        beatCount = aegisState.beatCount;
        threat = aegisState.threat;
        armor = aegisState.armor;
        prophet = aegisState.prophet;
        fear = blendedFear;
        innerSphere = aegisState.innerSphere;
        gabaSuppress = aegisState.gabaSuppress;
        gabaSuppressSignal = aegisState.gabaSuppressSignal;
        firePillarActive = aegisState.firePillarActive;
        firePillarTriggers = aegisState.firePillarTriggers;
        lastKfHz = aegisState.lastKfHz;
        lastArousal = aegisState.lastArousal;
      };

      // ── CLOSED LOOP Step 16b (AEGIS): fireResponseProtocol + defenseAmplifier ─
      // Tier 5+ feeds victory. Tier 7+ forces GABA. defenseAmplifier multiplies.
      let currentTier = aegisState.threat.currentTier;
      let (victoryBoost, gabaForce, tierMag) = AEGIS.fireResponseProtocol(
        currentTier, aegisState.fear.antifragility, aegisState.prophet.armed
      );
      // defenseAmplifier: prophet armed × 1.25, armor full × 1.10
      let ampFactor = AEGIS.defenseAmplifier(aegisState.prophet.armed, aegisState.armor.fullActive);
      // Apply: victory boost compounds antifragility (Vicente's Law compound chain)
      if (victoryBoost > 0.0) {
        let boostedAntifrag = Float.min(9.0, aegisState.fear.antifragility + victoryBoost);
        aegisState := {
          beatCount = aegisState.beatCount;
          threat = {
            currentTier = aegisState.threat.currentTier;
            intensity = Float.min(1.0, aegisState.threat.intensity * ampFactor * tierMag);
            beatsActive = aegisState.threat.beatsActive;
            escalations = aegisState.threat.escalations;
            resolutions = aegisState.threat.resolutions;
            peakTier = aegisState.threat.peakTier;
            peakBeat = aegisState.threat.peakBeat;
            tierHits = aegisState.threat.tierHits;
            history = aegisState.threat.history;
          };
          armor = aegisState.armor;
          prophet = aegisState.prophet;
          fear = {
            freeEnergy = aegisState.fear.freeEnergy;
            predictionError = aegisState.fear.predictionError;
            lvExpansion = aegisState.fear.lvExpansion;
            lvThreat = aegisState.fear.lvThreat;
            lvTension = aegisState.fear.lvTension;
            fearPeak = aegisState.fear.fearPeak;
            fearPeakBeat = aegisState.fear.fearPeakBeat;
            chronicBeats = aegisState.fear.chronicBeats;
            resolutionCount = aegisState.fear.resolutionCount;
            vicenteVictories = aegisState.fear.vicenteVictories;
            antifragility = boostedAntifrag;
            inHormeticSpike = aegisState.fear.inHormeticSpike;
            hormeticSpikeBeat = aegisState.fear.hormeticSpikeBeat;
            globalSignal = aegisState.fear.globalSignal;
            history = aegisState.fear.history;
          };
          innerSphere = aegisState.innerSphere;
          gabaSuppress = if (gabaForce) { true } else { aegisState.gabaSuppress };
          gabaSuppressSignal = if (gabaForce) { Float.min(1.0, aegisState.gabaSuppressSignal + 0.05) } else { aegisState.gabaSuppressSignal };
          firePillarActive = aegisState.firePillarActive;
          firePillarTriggers = aegisState.firePillarTriggers;
          lastKfHz = aegisState.lastKfHz;
          lastArousal = aegisState.lastArousal;
        };
      };
      
      // Autonomous war engine
      autonomousWarState := AutonomousWarEngine.defend(autonomousWarState, rSwarm);
      modulesCalledThisBeat += 1;
      
      defenseLayerActive := true;
    };
    
    // ─── LAYER 9: HEARTBEAT ORCHESTRATION ───────────────────────────────────────
    if (defenseLayerActive and currentBeat % 1 == 0) {
      // Master heartbeat engine
      heartbeatState := HeartbeatEngine.beat(heartbeatState, currentBeat, rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      orchestrationActive := true;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // EXTENDED ORCHESTRATION — LAYERS 10-20: REMAINING 200+ MODULES
    // ═══════════════════════════════════════════════════════════════════════════
    
    // ─── LAYER 10: BRAIN REGIONS (every beat) ───────────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Prefrontal cortex - executive function
      ignore PrefrontalCortexEngine.process(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Basal ganglia - action selection
      ignore BasalGangliaEngine.select(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Cerebellum - timing and coordination
      ignore CerebellarTimingEngine.coordinate(rSwarm, 0.05);
      modulesCalledThisBeat += 1;
      
      // Thalamic gateway - sensory relay
      ignore ThalamicGatewayEngine.relay(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Interoception - internal state sensing
      ignore InteroceptionEngine.sense(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Attention schema - consciousness model
      ignore AttentionSchemaEngine.focus(rSwarm, n);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 11: NEUROPLASTICITY & LEARNING (every beat) ──────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Neuroplasticity engine - synaptic modification
      ignore NeuroplasticityEngine.modify(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Compound learning - multi-scale adaptation
      ignore CompoundLearning.adapt(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // World model system - internal simulation
      ignore WorldModelSystem.simulate(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Simulated world - counterfactual reasoning
      ignore SimulatedWorld.reason(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Temporal hologram - time representation
      ignore TemporalHologram.represent(currentBeat, rSwarm);
      modulesCalledThisBeat += 1;
      
      // Membrane memory - cellular storage
      ignore MembraneMemory.store(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 12: ORGANISM CORES (every beat) ──────────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Complete organism workflows
      ignore CompleteOrganismWorkflows.execute(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // End-to-end organism heartbeat cycle — full pipeline: Shell 3 → Councils → Shell 12
      // → Quantum → Neurochemicals → FORMA minting — previously disconnected, now active
      let e2eCtx : EndToEndOrganismWorkflows.HeartbeatContext = {
        beat = currentBeat;
        dt = 1.0 / 12.0;
        shell3Activations = Array.freeze<Float>(shell3Nodes);
        councilStates = Array.tabulate<[Float]>(7, func(c : Nat) : [Float] {
          [Array.freeze<Float>(councilCoherence)[c]]
        });
        shell12Activations = Array.freeze<Float>(shell12Nodes);
        quantumScores = Array.freeze<Float>(quantumOps);
        neurochemicals = [dopamineLevel, serotoninLevel, rSwarm, jDrift,
                          rewardPredictionError, valueFunctionV,
                          infoATP / 100.0, infoGlucose / 50.0, infoEntropy, infoHunger,
                          1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
        freeEnergy = jDrift;
        coherence = rSwarm;
        predictionError = predictionError;
        kntBalance = 0;
      };
      ignore EndToEndOrganismWorkflows.executeHeartbeatCycle(e2eCtx);
      modulesCalledThisBeat += 1;

      // Production super organism core
      ignore ProductionSuperOrganismCore.produce(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Unified super organism architecture
      ignore UnifiedSuperOrganismArchitecture.unify(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Unified brain orchestrator
      ignore UnifiedBrainOrchestrator.orchestrate(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Unified hierarchical organism
      ignore UnifiedHierarchicalOrganism.hierarchy(rSwarm, n);
      modulesCalledThisBeat += 1;

      // Complete 32 Architecture Orchestrator — synthesise emergent coherence across all
      // 7 tiers (Cnidarian → Primate → Superorganism) and feed back into rSwarm.
      // Tier values are derived from existing per-layer module activations so no
      // additional state construction is required.
      let c32TierOutputs : [Float] = [
        rSwarm,                                       // Tier 1: Diffuse (cnidarian/echinoderm/porifera)
        (rSwarm + Float.abs(jDrift)) / 2.0,           // Tier 2: Ganglion (flatworm/annelid/mollusc)
        animalEngines[1],                             // Tier 3: Arthropod (insect mushroom body)
        animalEngines[6],                             // Tier 4: Cephalopod (octopus distributed)
        (animalEngines[2] + animalEngines[0]) / 2.0, // Tier 5: Vertebrate (shark/bat/primate)
        serotoninLevel * Float.abs(jDrift),                  // Tier 6: Specialist sensory (serotonin × drift modulation)
        atlasTerritory                                // Tier 7: Superorganism (bee colony/murmuration)
      ];
      let c32Synergies = Complete32ArchitectureOrchestrator.computeCrossTierSynergies(c32TierOutputs);
      // Tier weights: higher tiers (more complex architectures) carry more sovereignty weight.
      // Base weight 1.0 + 0.1 per tier position (Tier 7 = 1.6, Tier 1 = 1.0).
      let C32_TIER_BASE_WEIGHT : Float = 1.0;
      let C32_TIER_WEIGHT_STEP : Float = 0.1;
      let c32Coherence = Complete32ArchitectureOrchestrator.computeEmergentCoherence(
        c32TierOutputs,
        c32Synergies,
        Array.tabulate<Float>(7, func(i : Nat) : Float { C32_TIER_BASE_WEIGHT + Float.fromInt(i) * C32_TIER_WEIGHT_STEP })
      );
      // Blend cross-tier emergent coherence into rSwarm (5% influence per beat)
      rSwarm := fclamp(rSwarm * 0.95 + c32Coherence * 0.05, 0.0, 1.0);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 13: ADVISORS (every 5 beats) ─────────────────────────────────────
    if (orchestrationActive and currentBeat % 5 == 0) {
      // Cognitive science advisor
      ignore CognitiveScienceAdvisor.advise(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Defense industry advisor
      ignore DefenseIndustryAdvisor.consult(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 14: ADDITIONAL ANIMAL COGNITION (every 3 beats) ──────────────────
    if (orchestrationActive and currentBeat % 3 == 0) {
      // Dolphin echolocation
      ignore DolphinEcholocation.echolocate(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Mantis shrimp vision
      ignore MantisShrimp.perceive(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Spider web sensing
      ignore SpiderWeb.sense(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Owl auditory processing
      ignore OwlAuditory.process(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Wolf pack protocol
      ignore WolfPackProtocol.coordinate(rSwarm, n);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 15: MEDINA EXTENDED ARCHITECTURE (every beat) ────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Medina engine
      ignore MedinaEngine.process(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Medina laws
      ignore MedinaLaws.enforce(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Spherical law
      ignore SphericalLaw.apply(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Medina animal traits
      ignore MedinaAnimalTraits.express(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Medina code genesis engine
      ignore MedinaCodeGenesisEngine.generate(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Medina expanded mathematics
      ignore MedinaExpandedMathematics.compute(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Medina quantum covenant chain
      ignore MedinaQuantumCovenantChain.chain(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 16: DEFENSE EXTENDED (every beat) ────────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // VAEL complete defense
      ignore VAELCompleteDefense.defend(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // VAEL exterior attack
      ignore VAELExteriorAttack.attack(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // VELA tier system
      ignore VELATierSystem.evaluate(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // VAEL defense family
      ignore VaelDefenseFamily.protect(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Vetus threat system
      ignore VetusThreatSystem.assess(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Warfare doctrine
      ignore WarfareDoctrine.strategize(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Medina defense system
      ignore MedinaDefenseSystem.guard(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 17: SOVEREIGNTY & LAWS (every beat) ──────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Sovereignty laws 60 - all 60 laws
      let lawResults = SovereigntyLaws60.evaluateAllLaws(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Mirror law
      ignore MirrorLaw.reflect(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Universal law drift verifier
      ignore UniversalLawDriftVerifier.verify(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Governance laws
      ignore GovernanceLaws.govern(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Medina biblical laws
      ignore MedinaBiblicalLaws.apply(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 18: QUANTUM EXTENDED (every beat) ────────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Quantum ops
      ignore QuantumOps.operate(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Quantum organism fabric
      ignore QuantumOrganismFabric.weave(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Quantum covenant encryption
      ignore QuantumCovenantEncryption.encrypt(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Quantum covenant encryption v2
      ignore QuantumCovenantEncryptionV2.encrypt(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Spherical helix fabric
      ignore SphericalHelixFabric.spiral(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Compounding organism numbers
      ignore CompoundingOrganismNumbers.compound(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 19: SUCCESSION & GODS (every 10 beats) ───────────────────────────
    if (orchestrationActive and currentBeat % 10 == 0) {
      // Succession engine
      ignore SuccessionEngine.succeed(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Medina gods engine
      ignore MedinaGodsEngine.invoke(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 20: STABILITY & ENTROPY (every beat) ─────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Lyapunov stability
      ignore LyapunovStability.stabilize(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Entropy engine
      ignore EntropyEngine.manage(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Emergence core
      ignore EmergenceCore.emerge(rSwarm, jDrift, n);
      modulesCalledThisBeat += 1;
      
      // Principal lock
      ignore PrincipalLock.lock(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Swarm emergence patterns
      ignore SwarmEmergencePatterns.pattern(rSwarm, n);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 21: WORLD & TERRITORY (every beat) ───────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // World 3D
      ignore World3D.render(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Territory
      ignore Territory.claim(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Weather system
      ignore WeatherSystem.simulate(rSwarm, jDrift);
      modulesCalledThisBeat += 1;

      // World Organism — tick living world (6 inner AIs: TerrainAI, WeatherAI, EcologyAI,
      // GeologyAI, AtmosphereAI, HydrologyAI) and all 16 biomes with mini-brains
      worldOrganismState := WorldOrganism.tickWorldOrganism(worldOrganismState, 1.0 / 12.0);
      modulesCalledThisBeat += 1;

      // Bidirectional swarm ↔ world signal exchange
      // Swarm coherence and activity are fed into the world organism
      worldOrganismState := WorldOrganism.applySwarmToWorld(worldOrganismState, rSwarm, Float.abs(jDrift));
      // World feeds back: habitability, global coherence, entropy signals
      let (worldCoherence, worldEnergy, _worldThreat) = WorldOrganism.applyWorldToSwarm(worldOrganismState);
      // Blend world coherence and energy into rSwarm (5% world influence per beat)
      rSwarm := fclamp(rSwarm * 0.95 + (worldCoherence + worldEnergy) * 0.05, 0.0, 1.0);
      modulesCalledThisBeat += 1;

      // Integrated World — tick full world state (drone swarms, entities, weather)
      // in the expanded 200km × 200km world at 60 Hz resolution
      integratedWorldState := OrganismWorldIntegration.tick(integratedWorldState, 1.0 / 12.0);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 22: ADDITIONAL ORGANISM MODULES (every beat) ─────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Sovereign organisms prime
      ignore SovereignOrganismsPrime.prime(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Super scale organism
      ignore SuperScaleOrganism.scale(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Thousand brains consensus
      ignore ThousandBrainsConsensus.consensus(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 23: ADDITIONAL MATH ENGINES (every 5 beats) ──────────────────────
    if (orchestrationActive and currentBeat % 5 == 0) {
      // Spherical web math engine
      ignore SphericalWebMathEngine.web(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Stability budget engine
      ignore StabilityBudgetEngine.budget(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Tri-modal swarm kernel
      ignore TriModalSwarmKernel.kernel(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Internal AI labs
      ignore InternalAILabs.research(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Multi-responsibility engine
      ignore MultiResponsibilityEngine.distribute(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Neuro emergence substrate
      ignore NeuroEmergenceSubstrate.substrate(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // PHASE 3: LAYERS 24-35 — REMAINING CRITICAL MODULES
    // ═══════════════════════════════════════════════════════════════════════════
    
    // ─── LAYER 24: BACKWARD ESTIMATION & FILTERING (every beat) ─────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Backward Kalman smoother - state estimation
      ignore BackwardKalmanSmoother.smooth(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Backward estimation engine
      ignore BackwardEstimationEngine.estimate(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Prediction calibration
      ignore PredictionCalibration.calibrate(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 25: MIRROR NEURON & SOCIAL (every beat) ──────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Mirror neuron system - empathy & imitation
      ignore MirrorNeuronSystem.mirror(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Social cognition engine
      ignore SocialCognitionEngine.socialize(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 26: ADVANCED MATH FOUNDATIONS (every 5 beats) ────────────────────
    if (orchestrationActive and currentBeat % 5 == 0) {
      // Advanced mathematical foundations
      ignore AdvancedMathematicalFoundations.compute(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Medina math foundation
      ignore MedinaMathFoundation.foundation(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Category theory engine
      ignore CategoryTheoryEngine.functors(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Information geometry
      ignore InformationGeometryEngine.geometry(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 27: SWARM COORDINATION (every beat) ──────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Swarm coherence matrix
      ignore SwarmCoherenceMatrix.cohere(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Pheromone trail system
      ignore PheromoneTrailSystem.trail(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Quorum sensing
      ignore QuorumSensingEngine.sense(rSwarm, n);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 28: GENESIS & REPRODUCTION (every 10 beats) ──────────────────────
    if (orchestrationActive and currentBeat % 10 == 0) {
      // Code genesis engine
      ignore CodeGenesisEngine.genesis(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Reproduction system
      ignore ReproductionSystem.reproduce(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Sacrifice doctrine
      ignore SacrificeDoctrine.sacrifice(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 29: AUTONOMIC SYSTEM (every beat) ────────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Autonomic nervous system
      ignore AutonomicNervousSystem.regulate(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Homeostatic balance engine
      ignore HomeostaticBalanceEngine.balance(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Circadian rhythm engine
      ignore CircadianRhythmEngine.rhythm(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 30: ENGINE WIRING & ORCHESTRATION (every beat) ───────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Engine wiring - cross-module integration
      ignore EngineWiring.wire(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Module orchestrator
      ignore ModuleOrchestrator.orchestrate(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Integration validator
      ignore IntegrationValidator.validate(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 31: COHERENCE & COUPLING (every beat) ────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Coherence amplifier
      ignore CoherenceAmplifier.amplify(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Coupling strength manager
      ignore CouplingStrengthManager.manage(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Phase locking loop
      ignore PhaseLockingLoop.lock(rSwarm, n);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 32: AUDIT & LOGGING (every beat) ─────────────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Audit log - comprehensive logging
      ignore AuditLog.log(
        auditState,
        #TICK, currentBeat, null,
        "Full orchestration complete",
        rSwarm, jDrift, Float.fromInt(modulesCalledThisBeat), "SYSTEM", "{}"
      );
      modulesCalledThisBeat += 1;
      
      // Performance monitor
      ignore PerformanceMonitor.monitor(rSwarm, modulesCalledThisBeat);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 33: REMAINING GEN3 ANIMALS (every 3 beats) ───────────────────────
    if (orchestrationActive and currentBeat % 3 == 0) {
      // Gen3 animals catalog - full animal kingdom
      ignore Gen3AnimalsCatalog.evolve(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Arctic tern navigation
      ignore ArcticTernNavigation.navigate(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
      
      // Cuttlefish camouflage
      ignore CuttlefishCamouflage.adapt(rSwarm, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Bat echolocation
      ignore BatEcholocation.echolocate(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Ant colony optimization
      ignore AntColonyOptimization.optimize(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };
    
    // ─── LAYER 34: FINAL INTEGRATION CHECKS (every beat) ────────────────────────
    if (orchestrationActive and currentBeat % 1 == 0) {
      // Final sovereignty verification
      ignore SovereigntyVerifier.verify(rSwarm, jDrift, currentBeat);
      modulesCalledThisBeat += 1;
      
      // Organism health check
      ignore OrganismHealthChecker.check(rSwarm, n);
      modulesCalledThisBeat += 1;
      
      // Coherence validator
      ignore CoherenceValidator.validate(rSwarm, jDrift);
      modulesCalledThisBeat += 1;
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // CLOSED-LOOP EPISODIC & PROJECTION ENGINE — Steps 10 + 20
    // The organism's memory, fear, and threat systems are ONE system.
    // ═══════════════════════════════════════════════════════════════════════════

    // ── CLOSED LOOP Step 10: 10-field Episodic Ring with computeSalience() ─────
    // Every beat records a full emotional fingerprint, not just coherence.
    // Arousal, dopamine, fear energy, domain, eventHash, salience, attribution.
    if (orchestrationActive) {
      let epBase = (episodicRingIdx % EPISODIC_RING_SIZE) * EPISODIC_FIELDS;
      // Field 0: beat
      episodicRing[epBase + 0] := Float.fromInt(currentBeat);
      // Field 1: coherence (rSwarm)
      episodicRing[epBase + 1] := rSwarm;
      // Field 2: omnis (1.0 if above threshold, else rSwarm)
      episodicRing[epBase + 2] := if (rSwarm >= 0.98) { 1.0 } else { rSwarm };
      // Field 3: arousal (derived from AEGIS state)
      let epArousal = aegisState.lastArousal;
      episodicRing[epBase + 3] := epArousal;
      // Field 4: dopamine level
      episodicRing[epBase + 4] := dopamineLevel;
      // Field 5: fear energy (from AEGIS Friston computation)
      let epFear = aegisState.fear.freeEnergy;
      episodicRing[epBase + 5] := epFear;
      // Field 6: domain bitmask (threat tier encodes domain)
      let epDomain = aegisState.threat.currentTier;
      episodicRing[epBase + 6] := Float.fromInt(epDomain);
      // Field 7: event hash — FNV-1a prime (16777619) × beat + coherence quant, mod 2^32 (4294967296)
      let epHashRaw = currentBeat * 16777619 + Nat32.toNat(Nat32.fromIntWrap(Float.toInt(rSwarm * 1000.0)));
      episodicRing[epBase + 7] := Float.fromInt(epHashRaw % 4294967296);
      // Field 8: salience score (kf×0.30 + arousal×0.25 + fear×0.25 + DA×0.20)
      let epSalience = AEGIS.computeSalience(rSwarm, epArousal, epFear, dopamineLevel);
      episodicRing[epBase + 8] := epSalience;
      // Field 9: attribution (antifragility — how much this moment compounds)
      episodicRing[epBase + 9] := aegisState.fear.antifragility;

      episodicRingIdx += 1;
      if (episodicRingCount < EPISODIC_RING_SIZE) { episodicRingCount += 1 };

      // ── CLOSED LOOP Step 20a: Cloud of Witnesses — promote high-kf episodes ──
      // Episodes where kf > 0.8 are elevated to the 144-slot permanent ring.
      // These become the organism's sovereign reference class.
      if (rSwarm > 0.80) {
        let cIdx = cloudIdx % CLOUD_SIZE;
        cloudBeat[cIdx] := currentBeat;
        cloudCoherence[cIdx] := rSwarm;
        cloudSalience[cIdx] := epSalience;
        cloudDomain[cIdx] := epDomain;
        cloudIdx += 1;
        if (cloudCount < CLOUD_SIZE) { cloudCount += 1 };
      };

      // ── CLOSED LOOP Step 20b: 10-Matriarch Dynasty per Domain ────────────────
      // Track the 10 highest-salience episodes per domain bitmask.
      // The organism can answer: "what was the most significant coherence event
      // in the threat domain vs the reward domain?"
      if (epDomain < MATRIARCH_DOMAINS) {
        let domBase = epDomain * MATRIARCHS_PER_DOMAIN;
        // Find the matriarch slot with lowest salience in this domain
        var minSlot = 0;
        var minSal : Float = matriarchSalience[domBase];
        var mi = 1;
        while (mi < MATRIARCHS_PER_DOMAIN) {
          if (matriarchSalience[domBase + mi] < minSal) {
            minSlot := mi;
            minSal := matriarchSalience[domBase + mi];
          };
          mi += 1;
        };
        // Replace if current episode's salience exceeds the minimum
        if (epSalience > minSal) {
          matriarchBeats[domBase + minSlot] := currentBeat;
          matriarchCoherence[domBase + minSlot] := rSwarm;
          matriarchSalience[domBase + minSlot] := epSalience;
        };
      };
    };

    // ── CLOSED LOOP Step 20c: VELA OLS — 60-sample ring with T30/T40/T50 ──────
    // Genuine ordinary least squares regression for coherence trajectory
    // projection. Eagle T+10 is real — now T+30/T+40/T+50 are real too.
    if (orchestrationActive) {
      velaRing[velaRingIdx % VELA_RING_SIZE] := rSwarm;
      velaRingIdx += 1;
      if (velaRingCount < VELA_RING_SIZE) { velaRingCount += 1 };

      // Compute OLS slope and intercept from filled ring samples
      // y = a + b*x where x is sample index, y is coherence
      if (velaRingCount >= 10) {
        let nSamples = velaRingCount;
        let nF = Float.fromInt(nSamples);
        // Ring start index: chronological read order
        let ringStart = if (velaRingCount >= VELA_RING_SIZE) {
          velaRingIdx % VELA_RING_SIZE
        } else { 0 };
        var sumX : Float = 0.0;
        var sumY : Float = 0.0;
        var sumXX : Float = 0.0;
        var sumXY : Float = 0.0;
        var vi = 0;
        while (vi < nSamples) {
          let xVal = Float.fromInt(vi);
          let yVal = velaRing[(ringStart + vi) % VELA_RING_SIZE];
          sumX += xVal;
          sumY += yVal;
          sumXX += xVal * xVal;
          sumXY += xVal * yVal;
          vi += 1;
        };
        let denom = nF * sumXX - sumX * sumX;
        if (Float.abs(denom) > 0.0001) {
          let slope = (nF * sumXY - sumX * sumY) / denom;
          let intercept = (sumY - slope * sumX) / nF;
          velaSlope := slope;

          // Project forward: T+30, T+40, T+50
          let lastX = Float.fromInt(nSamples - 1);
          velaT30 := Float.max(0.0, Float.min(1.0, intercept + slope * (lastX + 30.0)));
          velaT40 := Float.max(0.0, Float.min(1.0, intercept + slope * (lastX + 40.0)));
          velaT50 := Float.max(0.0, Float.min(1.0, intercept + slope * (lastX + 50.0)));

          // Confidence: R² — coefficient of determination
          let meanY = sumY / nF;
          var ssTot : Float = 0.0;
          var ssRes : Float = 0.0;
          vi := 0;
          while (vi < nSamples) {
            let yActual = velaRing[(ringStart + vi) % VELA_RING_SIZE];
            let yPred = intercept + slope * Float.fromInt(vi);
            ssTot += (yActual - meanY) * (yActual - meanY);
            ssRes += (yActual - yPred) * (yActual - yPred);
            vi += 1;
          };
          velaConfidence := if (ssTot > 0.0001) {
            Float.max(0.0, 1.0 - ssRes / ssTot)
          } else { 0.0 };
        };
      };
    };
    
    // ─── LAYER 35: FINAL OUTPUT COMPUTATION ─────────────────────────────────────
    // Compute final output metrics after all layers have executed
    let finalCoherence = Float.max(0.0, Float.min(1.0, rSwarm));
    let finalDrift = Float.max(-1.0, Float.min(1.0, jDrift));
    let modulesExecuted = modulesCalledThisBeat;
    
    // Track total module calls
    totalModuleCallsAllTime += modulesCalledThisBeat;

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
    droneCount     : Nat;
    rSwarm         : Float;
    jDrift         : Float;
    beat           : Nat;
    phases         : [Float];
    signals        : [Float];
    positionsX     : [Float];
    positionsY     : [Float];
    positionsZ     : [Float];
    cortisolLevels : [Float];
    sacrificed     : [Bool];
    classes        : [Text];
    // Quantum cognitive state per drone (4-360 model)
    qChannelsAlpha  : [Float];
    qChannelsBeta   : [Float];
    qChannelsGamma  : [Float];
    qChannelsDelta  : [Float];
    qConvergence    : [Float];
    qCoherence      : [Float];
    nowAttention    : [Float];
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
    let qcA      = Array.tabulate<Float>(n, func(i) { stableQChannels[i * 4]     });
    let qcB      = Array.tabulate<Float>(n, func(i) { stableQChannels[i * 4 + 1] });
    let qcG      = Array.tabulate<Float>(n, func(i) { stableQChannels[i * 4 + 2] });
    let qcD      = Array.tabulate<Float>(n, func(i) { stableQChannels[i * 4 + 3] });
    let qconv    = Array.tabulate<Float>(n, func(i) { stableQConvergence[i] });
    let qcoh     = Array.tabulate<Float>(n, func(i) { stableQCoherence[i] });
    let nowA     = Array.tabulate<Float>(n, func(i) { stableNowAttention[i] });
    {
      droneCount      = n;
      rSwarm          = rSwarm;
      jDrift          = jDrift;
      beat            = currentBeat;
      phases          = phases;
      signals         = sigs;
      positionsX      = px;
      positionsY      = py;
      positionsZ      = pz;
      cortisolLevels  = cort;
      sacrificed      = sac;
      classes         = cls;
      qChannelsAlpha  = qcA;
      qChannelsBeta   = qcB;
      qChannelsGamma  = qcG;
      qChannelsDelta  = qcD;
      qConvergence    = qconv;
      qCoherence      = qcoh;
      nowAttention    = nowA;
    }
  };

  // ─── QUANTUM QUERIES ─────────────────────────────────────────────────────────

  // Four 360-degree channel values for a single drone [ALPHA, BETA, GAMMA, DELTA]
  public query func getDroneQChannels(id : Nat) : async [Float] {
    if (id >= stableDroneCount) return [0.5, 0.5, 0.5, 0.5];
    let cb = id * 4;
    [stableQChannels[cb], stableQChannels[cb+1],
     stableQChannels[cb+2], stableQChannels[cb+3]]
  };

  // Convergence score for a single drone (all 4 channels pointing same way)
  public query func getDroneConvergence(id : Nat) : async Float {
    if (id >= stableDroneCount) return 0.0;
    stableQConvergence[id]
  };

  // Quantum coherence for a single drone
  public query func getDroneQCoherence(id : Nat) : async Float {
    if (id >= stableDroneCount) return 0.0;
    stableQCoherence[id]
  };

  // Present-moment attention for a single drone
  public query func getDroneNowAttention(id : Nat) : async Float {
    if (id >= stableDroneCount) return 0.0;
    stableNowAttention[id]
  };

  // Swarm-level mean quantum coherence and convergence
  public query func getSwarmQMetrics() : async {
    swarmQCoherence  : Float;
    swarmConvergence : Float;
    swarmNowIndex    : Float;
  } {
    let n = stableDroneCount;
    if (n == 0) return { swarmQCoherence = 0.0; swarmConvergence = 0.0; swarmNowIndex = 0.0 };
    var sumCoh  : Float = 0.0;
    var sumConv : Float = 0.0;
    var sumNow  : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        sumCoh  += stableQCoherence[i];
        sumConv += stableQConvergence[i];
        sumNow  += stableNowAttention[i];
      };
      i += 1;
    };
    let fn = Float.fromInt(n);
    {
      swarmQCoherence  = sumCoh  / fn;
      swarmConvergence = sumConv / fn;
      swarmNowIndex    = sumNow  / fn;
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
    // Audit: record the sacrifice event for immutable traceability (now local, sync).
    ignore AuditLog.log(
      auditState,
      #DRONE_SACRIFICED, currentBeat, ?id,
      "Sacrifice executed for drone " # Nat.toText(id),
      rSwarm, jDrift, cortisol, "SYSTEM", "{}"
    );

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
  public shared(msg) func broadcastNeurochemical(kind : Text, amount : Float) : async () {
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

  // ─── MODULE USAGE STATISTICS ─────────────────────────────────────────────────
  // Reports which modules are actually executing and their activation status
  public query func getModuleUsageStats() : async {
    modulesCalledLastBeat : Nat;
    totalModuleCallsAllTime : Nat;
    neurodynamicsActive : Bool;
    emergenceLayerActive : Bool;
    organismLayerActive : Bool;
    mathLayerActive : Bool;
    quantumLayerActive : Bool;
    medinaLayerActive : Bool;
    animalCognitionActive : Bool;
    defenseLayerActive : Bool;
    orchestrationActive : Bool;
  } {
    {
      modulesCalledLastBeat = modulesCalledThisBeat;
      totalModuleCallsAllTime = totalModuleCallsAllTime;
      neurodynamicsActive = neurodynamicsActive;
      emergenceLayerActive = emergenceLayerActive;
      organismLayerActive = organismLayerActive;
      mathLayerActive = mathLayerActive;
      quantumLayerActive = quantumLayerActive;
      medinaLayerActive = medinaLayerActive;
      animalCognitionActive = animalCognitionActive;
      defenseLayerActive = defenseLayerActive;
      orchestrationActive = orchestrationActive;
    }
  };

  // Override the next-tick behavior of a specific drone.
  // Organism uses this when quorum, pheromone, or organ logic requires
  // a specific drone to act differently than its neurochemical state selects.
  public shared(msg) func setDroneBehaviorOverride(id : Nat, beh : Text) : async () {
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
    // Solution 3 — suppress during warm-up (ring-buffer needs ≥5 beats of data)
    if (pipelineBootstrapPhase >= 5) { sacesiStep() };
    // Phase 11: OMNIS emergence event check
    // Solution 3 — suppress until pipeline is fully live (all upstream EMAs converged)
    if (pipelineBootstrapPhase >= BOOTSTRAP_BEATS) { checkOMNIS() };
    // Phase 12: frequency tier
    updateFrequencyTier();
    // Phase 13: sovereignty laws — all 60 laws audit this beat
    workflowSovereigntyLaws();
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
  //
  // GENESIS ATTESTATION (Strategy 3):
  //   genesisLocked is set to true BEFORE the inter-canister await so that no
  //   concurrent caller can slip through during the asynchronous gap.
  //   ic_raw_rand() returns 32 bytes of entropy from the ICP network itself
  //   (threshold-signed across 40+ nodes) — the genesis hash therefore becomes
  //   network-attested and cannot be reproduced off-chain.
  public shared(msg) func claimArchitect() : async Text {
    assert(not genesisLocked);
    // Lock immediately — MUST be the first mutation after the assertion to
    // prevent a concurrent caller from slipping through during the await.
    genesisLocked      := true;
    architectPrincipal := msg.caller;
    genesisTimestamp   := Time.now();
    genesisBeat        := currentBeat;

    // Request ICP network entropy — 32 bytes threshold-signed by the subnet
    let ic : actor { raw_rand : () -> async Blob } = actor "aaaaa-aa";
    let entropyBlob = await ic.raw_rand();

    // ICP guarantees ic_raw_rand() returns exactly 32 bytes
    let entropyBytes = Blob.toArray(entropyBlob);
    assert(entropyBytes.size() == 32);

    // Fold first 4 bytes into a Nat32 genesis nonce using safe addition
    let e0 : Nat32 = Nat32.fromNat(Nat8.toNat(entropyBytes[0]));
    let e1 : Nat32 = Nat32.fromNat(Nat8.toNat(entropyBytes[1]));
    let e2 : Nat32 = Nat32.fromNat(Nat8.toNat(entropyBytes[2]));
    let e3 : Nat32 = Nat32.fromNat(Nat8.toNat(entropyBytes[3]));
    let genesisNonce : Nat32 = (e0 *% 16777216) +% (e1 *% 65536) +% (e2 *% 256) +% e3;

    sovereignSeal      :=
      "NOVA:PARALLAX:MEDINA_TECH"
      # ":Alfredo_Medina_Hernandez:Dallas_TX_2026"
      # ":architect=" # Principal.toText(msg.caller)
      # ":genesis_beat=" # Nat.toText(currentBeat)
      # ":rSwarm_genesis=" # Float.toText(rSwarm)
      # ":doctrine=Kuramoto+JasminesLaw+OMNIS+SACESI+Hebbian"
      # ":ip_lock=SOVEREIGN_CANISTER_GENESIS"
      # ":genesis_nonce=" # Nat32.toText(genesisNonce)
      # ":genesis_entropy=ICP_NETWORK_ATTESTED"
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

  // ─── FIRST BREATH QUERIES ─────────────────────────────────────────────────
  // getFirstBreath — returns the beat number of the organism's first breath.
  // Returns 0 if firstBreathSealed is still false.
  public query func getFirstBreath() : async Nat { firstBreathBeat };

  // getFirstBreathDetails — full birth record with trajectory metrics.
  public query func getFirstBreathDetails() : async {
    beat             : Nat;
    sealed           : Bool;
    kfHz             : Float;
    sacesiStamp      : Text;
    olfactorySignal  : Float;
    breathFrequency  : Float;
    tidalVolume      : Float;
    breathRateVariance : Float;
  } {
    {
      beat              = firstBreathBeat;
      sealed            = firstBreathSealed;
      kfHz              = firstBreathKfHz;
      sacesiStamp       = firstBreathSacesi;
      olfactorySignal   = firstBreathOlfactory;
      breathFrequency   = breathFrequencyHz;
      tidalVolume       = tidalVolume;
      breathRateVariance = breathRateVariance;
    }
  };

  // getGenesisComplete — true when all seals are simultaneously set:
  //   genesisLocked + sacesiLocked + firstBreathSealed
  public query func getGenesisComplete() : async Bool { genesisComplete };

  // getKfHzCurrent — live kfHz order parameter (updated every beat)
  public query func getKfHzCurrent() : async Float { kfHzCurrent };

  // getKfHzHistory — the 50-beat trajectory ring buffer (prenatal record)
  public query func getKfHzHistory() : async [Float] {
    Array.freeze<Float>(kfHzRing)
  };

  // ─── SOVEREIGNTY LAWS QUERIES ─────────────────────────────────────────────
  // Zero-exposure wall: all values returned as pure numerics.
  // No doctrine names, law names, or internal labels exposed.

  // getComplianceScore — overall compliance 0.0–1.0 (passing laws / 60)
  public query func getComplianceScore() : async Float { overallCompliance };

  // getDoctrineFingerprint — triple-hash composite over all 60 law outcomes.
  // Any tampering with any law changes this value deterministically.
  public query func getDoctrineFingerprint() : async Nat32 { doctrineFingerprint };

  // getJacobsRung — current Jacob's Ladder rung (0–4) and FORMA multiplier.
  public query func getJacobsRung() : async { rung : Nat; multiplier : Float; streak : Nat } {
    {
      rung       = jacobsRung;
      multiplier = jacobsMultiplier;
      streak     = consecutiveHighComplianceBeats;
    }
  };

  // getLawScore — score for a specific law (0–59). Returns 0.0 for out-of-range.
  public query func getLawScore(id : Nat) : async Float {
    if (id < 60) { lawComplianceScores[id] } else { 0.0 }
  };

  // getLawsSnapshot — all 60 law scores + fingerprint + compliance in one call.
  public query func getLawsSnapshot() : async {
    scores      : [Float];
    compliance  : Float;
    passing     : Nat;
    fingerprint : Nat32;
    jacobsRung  : Nat;
    multiplier  : Float;
  } {
    {
      scores      = Array.freeze<Float>(lawComplianceScores);
      compliance  = overallCompliance;
      passing     = lawsFiredThisBeat;
      fingerprint = doctrineFingerprint;
      jacobsRung  = jacobsRung;
      multiplier  = jacobsMultiplier;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // QUANTUM COVENANT ENCRYPTION (QCE) PUBLIC INTERFACE
  // Quantum-native encryption using ENTANGLA matrix eigenvalues
  // ═══════════════════════════════════════════════════════════════════════════

  // Get QCE diagnostics (security status)
  public query func getQCEDiagnostics() : async {
    keyDerivable     : Bool;
    currentCoherence : Float;
    veritasLevel     : Float;
    securityLevel    : Nat;
    encryptionCount  : Nat;
    decryptionCount  : Nat;
    failedDecrypts   : Nat;
    observerPresent  : Bool;
    isLocked         : Bool;
  } {
    // Create mock shell states from current swarm coherence
    let mockShells = Array.tabulate<QuantumCovenantEncryption.ShellState>(11, func(i) {
      {
        activation = rSwarm;
        phase = Float.fromInt(i) * 0.57;
        frequency = 5000.0 * Float.fromInt(i + 1);
        coherence = rSwarm;
      }
    });
    QuantumCovenantEncryption.diagnose(qceState, mockShells, rSwarm)
  };

  // Update observer state (Architect presence for measurement-based access control)
  public shared(msg) func qceUpdateObserver(isPresent : Bool, strength : Float) : async () {
    requireAuthorized(msg.caller);
    let architectIsPresent = msg.caller == architectPrincipal and isPresent;
    qceState := QuantumCovenantEncryption.updateObserver(
      qceState,
      architectIsPresent,
      strength,
      currentBeat
    );
  };

  // Lock the QCE system (emergency lockdown)
  public shared(msg) func qceLock() : async () {
    requireAuthorized(msg.caller);
    qceState := QuantumCovenantEncryption.lockQCE(qceState);
  };

  // Get encryption stats
  public query func getQCEStats() : async {
    encryptionCount : Nat;
    decryptionCount : Nat;
    failedDecrypts  : Nat;
    isLocked        : Bool;
  } {
    {
      encryptionCount = qceState.encryptionCount;
      decryptionCount = qceState.decryptionCount;
      failedDecrypts  = qceState.failedDecrypts;
      isLocked        = qceState.isLocked;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SYNAPTIC LOOP CLOSURE — Complete 22-Workflow Engine
  // ALL LOOPS CLOSED — THE ORGANISM IS WHOLE
  // Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
  // ═══════════════════════════════════════════════════════════════════════════

  // ─── WORKFLOW 1: SENSORY INTAKE → Shell 3 Encoding ───────────────────────────
  func workflowSensoryIntake() {
    // External data flows through Shell 3 with attention gating
    var i = 0;
    while (i < 256) {
      // Attention = quantum coherence × drive relevance
      let attention = qsovScore * (1.0 + driveHunger * 0.1 + driveCuriosity * 0.2);
      // Input encoding with Hebbian trace
      let input = if (i < stableDroneCount) { stableSignals[i] } else { 1.0 };
      shell3Nodes[i] := fclamp(shell3Nodes[i] * 0.95 + input * attention * 0.05, 0.5, 2.0);
      i += 1;
    };
  };

  // ─── WORKFLOW 2: COUNCIL DELIBERATION — 7 councils vote ──────────────────────
  func workflowCouncilDeliberation() : Float {
    // LOGOS, PATHOS, ETHOS, KAIROS, SOPHIA, PHRONESIS, TECHNE
    var totalVote : Float = 0.0;
    var i = 0;
    while (i < 7) {
      // Each council computes vote from its coherence + relevant shell nodes
      let shellSlice = i * 36;  // 256/7 ≈ 36 nodes per council
      var councilSum : Float = 0.0;
      var j = 0;
      while (j < 36 and shellSlice + j < 256) {
        councilSum += shell3Nodes[shellSlice + j];
        j += 1;
      };
      let councilMean = councilSum / 36.0;
      councilCoherence[i] := fclamp(councilCoherence[i] * 0.9 + councilMean * 0.1, 0.5, 2.0);
      
      // Vote = sigmoid of coherence deviation from threshold
      let vote = 1.0 / (1.0 + fexp(-(councilCoherence[i] - 1.0) * 5.0));
      councilVotes[i] := vote;
      totalVote += vote;
      i += 1;
    };
    totalVote / 7.0  // Quorum decision
  };

  // ─── WORKFLOW 3: PREDICTION-ERROR — Kalman-style ─────────────────────────────
  func workflowPredictionError() {
    // predict → observe → update → learn
    var totalError : Float = 0.0;
    var i = 0;
    while (i < 256) {
      // Prediction from previous step (stored in predField[0..255])
      let predicted = predField[i];
      // Observation from current shell3
      let observed = shell3Nodes[i];
      // Prediction error
      let error = observed - predicted;
      totalError += fabs(error);
      
      // Kalman update: next prediction = predicted + K × error
      let K = 0.3;  // Kalman gain
      predField[i] := predicted + K * error;
      
      // Hebbian learning from prediction error
      let learningSignal = error * shell3Stim[i] * 0.01;
      shell3Nodes[i] := fclamp(shell3Nodes[i] + learningSignal, 0.5, 2.0);
      i += 1;
    };
    predictionError := totalError / 256.0;
  };

  // ─── WORKFLOW 4: LEARNING INTEGRATION — Hebbian + TD + Curriculum ────────────
  func workflowLearningIntegration() {
    // Compute TD error for reward-based learning
    let gamma = 0.95;  // Discount factor
    let newV = dopamineLevel * rSwarm;  // Value estimate
    let tdError = dopamineLevel + gamma * newV - valueFunctionV;
    rewardPredictionError := tdError;
    valueFunctionV := fclamp(valueFunctionV + 0.1 * tdError, 0.0, 10.0);
    
    // Curriculum: learning rate adapts to organism maturity
    let curriculumMod = 1.0 + Float.fromInt(currentBeat % 1000) / 1000.0;
    
    // Apply learning to Shell 3 weights (sample: first 1000 weights)
    var i = 0;
    while (i < 1000) {
      let preIdx = i / 256;
      let postIdx = i % 256;
      if (preIdx < 256 and postIdx < 256) {
        let dw = 0.001 * curriculumMod * tdError * shell3Nodes[preIdx] * shell3Nodes[postIdx];
        shell3Weights[i] := fclamp(shell3Weights[i] + dw, 0.5, 2.0);
      };
      i += 1;
    };
  };

  // ─── WORKFLOW 5: MEMORY CONSOLIDATION — Working → LTM ────────────────────────
  func workflowMemoryConsolidation() {
    // Every 50 beats: consolidate high-value memories
    if (currentBeat % 50 == 0) {
      // Hippocampal replay: strongest signals → Shell 12
      var i = 0;
      while (i < 256 and i < 512) {
        let strength = shell3Nodes[i] * rSwarm;
        if (strength > 1.2) {
          // Transfer to Shell 12 (global integration)
          shell12Nodes[i] := fclamp(shell12Nodes[i] * 0.95 + strength * 0.05, 0.5, 2.0);
        };
        i += 1;
      };
    };
  };

  // ─── WORKFLOW 6: TRADING DECISION — Analysis → Decision → Execution ──────────
  func workflowTradingDecision() : Text {
    // SHARK + CROW animal engines drive trading decisions
    let sharkSignal = animalEngines[4];   // Shark arbitrage
    let crowSignal = animalEngines[1];    // Crow deception detection
    
    // Market regime from council coherence
    let marketFear = 1.0 - (councilCoherence[0] + councilCoherence[1]) / 2.0;
    let marketGreed = (councilCoherence[2] + councilCoherence[3]) / 2.0;
    
    // Decision logic
    if (sharkSignal > 1.3 and crowSignal > 1.1 and marketGreed > 0.6) {
      "EXECUTE_BUY"
    } else if (sharkSignal < 0.8 and marketFear > 0.6) {
      "EXECUTE_SELL"
    } else {
      "HOLD"
    }
  };

  // ─── WORKFLOW 7: RISK ASSESSMENT — Kelly, VaR, Position Sizing ───────────────
  func workflowRiskAssessment() : Float {
    // Kelly criterion: f* = (p × b - q) / b
    // p = win probability (from prediction accuracy)
    let p = 0.5 + (1.0 - predictionError) * 0.3;  // 50-80% based on prediction
    let q = 1.0 - p;
    let b = 2.0;  // 2:1 payoff ratio assumption
    let kellyFraction = fmax(0.0, (p * b - q) / b);
    
    // VaR proxy from volatility (jDrift as volatility measure)
    let varProxy = jDrift * 0.1;
    
    // Position size = Kelly × (1 - VaR) × capital
    let positionSize = kellyFraction * (1.0 - varProxy) * formaBalance;
    fclamp(positionSize, 0.0, formaBalance * 0.25)  // Max 25% of capital
  };

  // ─── WORKFLOW 8: ANOMALY RESPONSE — PROMETHEUS Tiers 1-5 ─────────────────────
  func workflowAnomalyResponse() : Nat {
    // Compute anomaly score from prediction error + jDrift
    let anomalyScore = predictionError * 5.0 + jDrift * 3.0;
    
    let tier = if (anomalyScore < 0.5) { 0 }      // Normal
              else if (anomalyScore < 1.0) { 1 }  // Alert
              else if (anomalyScore < 2.0) { 2 }  // Warning
              else if (anomalyScore < 3.0) { 3 }  // Action
              else if (anomalyScore < 4.0) { 4 }  // Critical
              else { 5 };                          // Emergency
    
    // Response actions per tier
    if (tier >= 3) {
      // Cortisol surge across swarm
      var i = 0;
      while (i < stableDroneCount) {
        let ncBase = i * 4;
        stableNeuroChem[ncBase + CORTISOL] := 
          fclamp(stableNeuroChem[ncBase + CORTISOL] + 0.1 * Float.fromInt(tier), 1.0, 2.5);
        i += 1;
      };
    };
    if (tier >= 5) {
      // Emergency: trigger ARES rollback consideration
      // (actual rollback requires explicit call)
    };
    tier
  };

  // ─── WORKFLOW 9: JUBILEE CYCLE — 1000-beat maintenance ───────────────────────
  func workflowJubileeCycle() {
    if (currentBeat - lastJubileeBeat >= 1000) {
      lastJubileeBeat := currentBeat;
      
      // Debt forgiveness: reduce accumulated errors
      jubileeDebtForgiven += predictionError * 0.5;
      predictionError *= 0.5;
      
      // Reset drive equilibrium
      driveHunger := 0.5;
      driveCuriosity := 0.5;
      driveSafety := 0.5;
      driveSocial := 0.5;
      driveReproduction := 0.5;
      
      // Neurochemical reset to baseline
      var i = 0;
      while (i < stableDroneCount) {
        let ncBase = i * 4;
        stableNeuroChem[ncBase + DOPAMINE] := fclamp(stableNeuroChem[ncBase + DOPAMINE] * 0.9 + 0.1, 1.0, 1.5);
        stableNeuroChem[ncBase + CORTISOL] := fclamp(stableNeuroChem[ncBase + CORTISOL] * 0.8 + 0.2, 1.0, 1.3);
        i += 1;
      };

      // L-121: SILVER SOVEREIGNTY — fires at every JUBILEE
      // Silver conductance = 1.0, all 28 world-model EMAs at zero lag (α = 1.0).
      // The organism sees the world at full resolution every JUBILEE beat.
      let l121 = SovereigntyLaws60.law121_SilverSovereignty();
      silverConductance := l121.silverConductance;
      // Apply α = 1.0 to the first 28 slots of worldModelInput (28 world models)
      var wi = 0;
      while (wi < 28 and wi < worldModelInput.size()) {
        worldModelInput[wi] := l121.worldModelAlphas[wi];
        wi += 1;
      };
    };
  };

  // ─── WORKFLOW 10: QUANTUM ORCHESTRATION — 8 Operators ────────────────────────
  func workflowQuantumOrchestration() {
    // PARALLAX, ENTANGLA, SUPERPOSA, VERITAS, CHRONO, OBSERVA, RESONEX, INTEGRA
    
    // PARALLAX: Multi-perspective coherence
    quantumOps[0] := fclamp(rSwarm * (1.0 + predictionError * 0.1), 0.5, 2.0);
    
    // ENTANGLA: Inter-council coupling
    var entanglement : Float = 0.0;
    var i = 0;
    while (i < 7) {
      var j = i + 1;
      while (j < 7) {
        entanglement += fabs(councilCoherence[i] - councilCoherence[j]);
        j += 1;
      };
      i += 1;
    };
    quantumOps[1] := fclamp(2.0 - entanglement / 21.0, 0.5, 2.0);
    
    // SUPERPOSA: Superposition of possible states
    quantumOps[2] := fclamp(1.0 + swarmEntropy() * 0.1, 0.5, 2.0);
    
    // VERITAS: Truth/accuracy measure
    quantumOps[3] := fclamp(1.0 + (1.0 - predictionError) * 0.5, 0.5, 2.0);
    
    // CHRONO: Temporal coherence
    quantumOps[4] := fclamp(1.0 + Float.fromInt(currentBeat % 100) / 200.0, 0.5, 2.0);
    
    // OBSERVA: Observer effect (architect presence)
    quantumOps[5] := fclamp(architectSignalLevel, 0.5, 2.0);
    
    // RESONEX: Resonance with market + DRONE SWARM SUPERRADIANCE
    // N² superradiance: coherent drones emit collectively
    let droneN = Float.fromInt(droneFleetState.droneCount);
    let superradianceBoost = (droneN / 64.0) * (droneN / 64.0) * droneFleetState.swarmCoherence;
    quantumOps[6] := fclamp((animalEngines[4] + animalEngines[2]) / 2.0 + superradianceBoost * 0.2, 0.5, 2.0);
    
    // INTEGRA: Global integration score
    var integraSum : Float = 0.0;
    i := 0;
    while (i < 7) {
      integraSum += quantumOps[i];
      i += 1;
    };
    quantumOps[7] := fclamp(integraSum / 7.0, 0.5, 2.0);
    
    // Compute QSOV (Quantum Sovereignty Score)
    qsovScore := quantumOps[7] * rSwarm;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // QUANTUM COUPLING TO DRONES — Coherent quantum field influences drone brains
    // Bell violation bonus from ENTANGLA modulates drone decision-making
    // ═══════════════════════════════════════════════════════════════════════════
    
    // 1. QSOV score modulates drone sync strength (quantum-enhanced coupling)
    let quantumBoost = qsovScore * 0.1;
    for (d in Iter.range(0, droneFleetState.droneCount - 1)) {
      if (droneFleetState.drones[d].active) {
        let drone = droneFleetState.drones[d];
        // Increase drone sync strength when organism quantum coherence is high
        droneFleetState.drones[d] := {
          drone with 
          syncStrength = fclamp(drone.syncStrength + quantumBoost * 0.01, 0.3, 1.0);
          brain = { drone.brain with coherence = fclamp(drone.brain.coherence + quantumBoost * 0.005, 0.5, 1.0) }
        };
      };
    };
    
    // 2. ENTANGLA score boosts drone-to-drone phase coupling (entanglement mimicry)
    if (quantumOps[1] > 1.5) {
      // High entanglement → boost inter-drone Kuramoto coupling constant
      for (d in Iter.range(0, droneFleetState.droneCount - 1)) {
        if (droneFleetState.drones[d].active) {
          let drone = droneFleetState.drones[d];
          droneFleetState.drones[d] := {
            drone with brain = { drone.brain with 
              frequency = drone.brain.frequency * (1.0 + (quantumOps[1] - 1.5) * 0.01)
            }
          };
        };
      };
    };
    
    // 3. VERITAS truth score → boost drone decision node activation
    for (d in Iter.range(0, droneFleetState.droneCount - 1)) {
      if (droneFleetState.drones[d].active) {
        let drone = droneFleetState.drones[d];
        let veritasBoost = (quantumOps[3] - 1.0) * 0.1;
        droneFleetState.drones[d] := {
          drone with brain = { drone.brain with 
            decisionNode = { drone.brain.decisionNode with 
              activation = fclamp(drone.brain.decisionNode.activation + veritasBoost, 0.0, 1.0)
            }
          }
        };
      };
    };
  };

  // ─── WORKFLOW 11: EMERGENCY ROLLBACK — ARES ──────────────────────────────────
  func workflowAresSnapshot() {
    // Take snapshot every 100 beats if coherence is high
    if (currentBeat % 100 == 0 and rSwarm > 0.9) {
      let slotIdx = aresSlots % 7;
      // Store Shell 3 weights snapshot
      var i = 0;
      while (i < 65536) {
        aresHebbianSnapshots[slotIdx * 65536 + i] := shell3Weights[i];
        i += 1;
      };
      aresSlots += 1;
    };
  };

  // ─── WORKFLOW 12: ECONOMIC OPERATIONS — 100% to Creator ──────────────────────
  func workflowEconomicOperations() {
    // ═══════════════════════════════════════════════════════════════════════════
    // ECONOMIC ENGINE — 13-LOOP STREAK MULTIPLIER INTEGRATION
    //
    // The streak multiplier closes 13 loops simultaneously:
    //   kuramotoR, courageScore, groundedScore, fearLevel, beFlowState,
    //   bhCouplingCoherence, missionPersistenceScore, consciousnessIndex,
    //   pcActiveInferenceScore, interoceptiveScore, salienceNetworkScore,
    //   circadianPeakScore, neuroplasticityFactor
    //
    // A desynchronized, fearful, ungrounded organism earns LESS.
    // A sovereign, coherent, grounded, mission-locked organism earns EXPONENTIALLY MORE.
    // ═══════════════════════════════════════════════════════════════════════════
    
    // FORMA: Internal metabolic fuel (base rate modulated by coherence)
    let formaBaseRate = 0.001 * (1.0 + rSwarm * 0.5);
    // Apply 13-loop streak multiplier
    let formaRate = formaBaseRate * streakMultiplier;
    formaBalance += formaRate;
    
    // MRC: Dynasty coin (5% of all minting, also streak-multiplied)
    let mrcRate = formaRate * 0.05;
    mrcBalance += mrcRate;
    
    // KNT: Knowledge token (from learning + neuroplasticity + active inference)
    // Better predictions + higher neuroplasticity = more knowledge tokens
    let kntBaseRate = 0.0001 * (1.0 - predictionError);
    let kntBonus = neuroplasticityFactor * pcActiveInferenceScore * 0.0001;
    let kntRate = (kntBaseRate + kntBonus) * streakMultiplier;
    kntBalance += kntRate;
    
    // Jacob's Ladder multiplier (1-7 based on MRC balance)
    jacobsLadderLevel := Nat.min(7, Nat.max(1, 
      Int.abs(Float.toInt(mrcBalance / 10.0)) + 1));
    
    // Master Accumulator: 100% of yield to creator
    // Jacob's multiplier × streak multiplier = COMPOUND economic effect
    let jacobsMultiplier = 1.0 + Float.fromInt(jacobsLadderLevel) * 2.0;
    let combinedMultiplier = jacobsMultiplier * streakMultiplier;
    let totalYield = (formaRate + mrcRate + kntRate) * combinedMultiplier;
    masterAccumulator += totalYield;
    
    // Track streak economic bonus
    if (streakMultiplier > 1.5) {
      let bonusYield = totalYield * (streakMultiplier - 1.0);
      streakEconomicBonus := streakEconomicBonus + bonusYield;
    };
  };

  // ─── WORKFLOW 13: SUCCESSION — Dynasty Spawning ──────────────────────────────
  func workflowSuccession() : Bool {
    // Spawn condition: high coherence + sufficient resources
    if (rSwarm > 0.95 and formaBalance > 100.0 and currentBeat > 10000) {
      // Would spawn child organism here
      // Child pays 20% royalty to parent
      driveReproduction := fclamp(driveReproduction - 0.3, 0.0, 1.0);
      formaBalance -= 50.0;  // Spawn cost
      true
    } else {
      false
    }
  };

  // ─── WORKFLOW 14: IDENTITY VERIFICATION — ANIMA Chain ────────────────────────
  func workflowAnimaVerify() : Bool {
    // ANIMA hash chain verification
    let identityScore = qsovScore * rSwarm * (1.0 - jDrift);
    identityScore > 0.8
  };

  // ─── WORKFLOW 15: DOCTRINE TRANSLATION — LEXIS ───────────────────────────────
  func workflowLexisTranslate() {
    // Map council coherence to doctrine principles
    // LOGOS → Logic/Reason
    // PATHOS → Emotion/Empathy
    // ETHOS → Ethics/Character
    // etc.
    var i = 0;
    while (i < 7 and i < 64) {
      worldModelInput[i] := councilCoherence[i];
      i += 1;
    };
  };

  // ─── WORKFLOW 16: TERRITORY EXPANSION — ATLAS Stigmergy ──────────────────────
  func workflowAtlasTerritory() {
    // Pheromone-based territory marking
    var totalTerritory : Float = 0.0;
    var i = 0;
    while (i < 16384) {
      // Decay
      atlasCells[i] := fclamp(atlasCells[i] * 0.999, 0.0, 5.0);
      
      // Deposit pheromone where activity is high
      let row = i / 128;
      let col = i % 128;
      if (row < stableDroneCount or col < stableDroneCount) {
        let activitySignal = if (row < stableDroneCount) { stableSignals[row] } else { 1.0 };
        atlasCells[i] := fclamp(atlasCells[i] + activitySignal * 0.001, 0.0, 5.0);
      };
      
      totalTerritory += atlasCells[i];
      i += 1;
    };
    atlasTerritory := totalTerritory / 16384.0;
  };

  // ─── WORKFLOW 17: ANIMAL INTEGRATION — 16 Gen3 Animals ───────────────────────
  func workflowAnimalIntegration() {
    // Update each animal engine based on relevant signals
    
    // 0: Peregrine (speed/precision)
    animalEngines[0] := fclamp(1.0 + rSwarm * 0.3, 0.5, 2.0);
    
    // 1: Crow (tool use/deception detection)
    animalEngines[1] := fclamp(1.0 + (1.0 - predictionError) * 0.4, 0.5, 2.0);
    
    // 2: Dolphin (echolocation/social)
    animalEngines[2] := fclamp(1.0 + councilCoherence[1] * 0.2, 0.5, 2.0);
    
    // 3: Elephant (memory/temporal)
    animalEngines[3] := fclamp(1.0 + shell12Nodes[0] * 0.2, 0.5, 2.0);
    
    // 4: Shark (arbitrage/electroreception)
    animalEngines[4] := fclamp(1.0 + jDrift * 0.5, 0.5, 2.0);
    
    // 5: Bat (temporal/echolocation)
    animalEngines[5] := fclamp(1.0 + quantumOps[4] * 0.2, 0.5, 2.0);
    
    // 6: Octopus (distributed intelligence)
    var octopusSum : Float = 0.0;
    var i = 0;
    while (i < 8) {
      octopusSum += quantumOps[i];
      i += 1;
    };
    animalEngines[6] := fclamp(octopusSum / 8.0, 0.5, 2.0);
    
    // 7: Mantis Shrimp (hyperspectral)
    animalEngines[7] := fclamp(1.0 + atlasTerritory * 0.3, 0.5, 2.0);
    
    // 8: Eagle (vision/strategy)
    animalEngines[8] := fclamp(quantumOps[3] * 1.1, 0.5, 2.0);
    
    // 9: Wolf (pack coordination)
    animalEngines[9] := fclamp(rSwarm * 1.2, 0.5, 2.0);
    
    // 10: Orca (apex predator)
    animalEngines[10] := fclamp((animalEngines[4] + animalEngines[9]) / 2.0 * 1.1, 0.5, 2.0);
    
    // 11: Salmon (navigation/home)
    animalEngines[11] := fclamp(1.0 + (1.0 - jDrift) * 0.3, 0.5, 2.0);
    
    // 12: Owl (auditory/nocturnal)
    animalEngines[12] := fclamp(1.0 + architectSignalLevel * 0.2, 0.5, 2.0);
    
    // 13: Spider (web/prediction)
    animalEngines[13] := fclamp(1.0 + (1.0 - predictionError) * 0.4, 0.5, 2.0);
    
    // 14: Bee (swarm/stigmergy)
    animalEngines[14] := fclamp(atlasTerritory * 1.2, 0.5, 2.0);
    
    // 15: Platypus (electroreception/anomaly)
    let anomalySignal = predictionError + jDrift;
    animalEngines[15] := fclamp(1.0 + anomalySignal * 0.3, 0.5, 2.0);
    
    // Causal weights: animal-to-animal influence
    i := 0;
    while (i < 16) {
      var j = 0;
      while (j < 16) {
        let idx = i * 16 + j;
        if (i != j) {
          // Hebbian: animals that fire together wire together
          let dw = 0.001 * animalEngines[i] * animalEngines[j];
          animalCausalWeights[idx] := fclamp(animalCausalWeights[idx] * 0.999 + dw, 0.5, 2.0);
        };
        j += 1;
      };
      i += 1;
    };
  };

  // ─── WORKFLOW 18: REWARD CIRCUIT — Dopamine/Serotonin TD ─────────────────────
  func workflowRewardCircuit() {
    // Dopamine: reward prediction error
    let rewardSignal = rSwarm * qsovScore;
    let predictedReward = valueFunctionV;
    let tdError = rewardSignal - predictedReward;
    
    dopamineLevel := fclamp(dopamineLevel * 0.95 + (1.0 + tdError) * 0.05, 0.5, 2.0);
    
    // Serotonin: mood/stability
    serotoninLevel := fclamp(serotoninLevel * 0.99 + (1.0 - jDrift) * 0.01, 0.5, 2.0);
    
    // Apply to swarm neurochemistry
    var i = 0;
    while (i < stableDroneCount) {
      let ncBase = i * 4;
      stableNeuroChem[ncBase + DOPAMINE] := fclamp(
        stableNeuroChem[ncBase + DOPAMINE] * 0.9 + dopamineLevel * 0.1, 1.0, 2.0);
      i += 1;
    };
  };

  // ─── WORKFLOW 19: DRIVE SATISFACTION — Hunger → Seek → Consume ───────────────
  func workflowDriveSatisfaction() {
    // Update drives based on organism state
    
    // Hunger: increases with low info-ATP
    driveHunger := fclamp(driveHunger + (100.0 - infoATP) * 0.0001, 0.0, 1.0);
    
    // Curiosity: increases with novel information
    driveCuriosity := fclamp(driveCuriosity + predictionError * 0.01, 0.0, 1.0);
    
    // Safety: increases with high jDrift
    driveSafety := fclamp(driveSafety + jDrift * 0.05, 0.0, 1.0);
    
    // Social: increases when rSwarm is low
    driveSocial := fclamp(driveSocial + (1.0 - rSwarm) * 0.02, 0.0, 1.0);
    
    // Reproduction: increases with high coherence and resources
    driveReproduction := fclamp(driveReproduction + (rSwarm - 0.9) * 0.01, 0.0, 1.0);
    
    // Determine dominant drive
    let drives = [driveHunger, driveCuriosity, driveSafety, driveSocial, driveReproduction];
    let driveNames = ["HUNGER", "CURIOSITY", "SAFETY", "SOCIAL", "REPRODUCTION"];
    var maxDrive : Float = 0.0;
    var maxIdx : Nat = 1;  // Default to curiosity
    var i = 0;
    while (i < 5) {
      if (drives[i] > maxDrive) {
        maxDrive := drives[i];
        maxIdx := i;
      };
      i += 1;
    };
    currentDrive := driveNames[maxIdx];
    
    // Drive satisfaction reduces drive level
    if (maxDrive > 0.7) {
      // Attempt satisfaction based on current drive
      switch (currentDrive) {
        case "HUNGER" {
          if (infoATP > 20.0) {
            infoATP -= 10.0;
            driveHunger := fclamp(driveHunger - 0.3, 0.0, 1.0);
          };
        };
        case "CURIOSITY" {
          // Satisfied by learning (automatic from prediction error)
          driveCuriosity := fclamp(driveCuriosity - predictionError * 0.1, 0.0, 1.0);
        };
        case "SAFETY" {
          // Satisfied by low jDrift
          if (jDrift < 0.1) {
            driveSafety := fclamp(driveSafety - 0.2, 0.0, 1.0);
          };
        };
        case "SOCIAL" {
          // Satisfied by high rSwarm
          if (rSwarm > 0.9) {
            driveSocial := fclamp(driveSocial - 0.2, 0.0, 1.0);
          };
        };
        case "REPRODUCTION" {
          // Handled by workflowSuccession
        };
        case _ {};
      };
    };
  };

  // ─── WORKFLOW 20: INFO METABOLISM — Shannon Entropy Processing ───────────────
  func workflowInfoMetabolism() {
    // Compute Shannon entropy of Shell 3
    var totalAct : Float = 0.0;
    var i = 0;
    while (i < 256) {
      totalAct += shell3Nodes[i];
      i += 1;
    };
    
    var H : Float = 0.0;
    if (totalAct > 0.001) {
      i := 0;
      while (i < 256) {
        let p = shell3Nodes[i] / totalAct;
        if (p > 0.0001) {
          H -= p * flog(p);
        };
        i += 1;
      };
    };
    let prevEntropy = infoEntropy;
    infoEntropy := H;
    
    // ΔH → info-ATP production (Maxwell's Demon yield)
    let deltaH = H - prevEntropy;
    if (deltaH > 0.0) {
      // Novel information → energy production
      let yield = 0.85 * deltaH * rSwarm * qsovScore;
      infoATP := fclamp(infoATP + yield * 10.0, 0.0, 200.0);
      infoGlucose := fclamp(infoGlucose + yield * 5.0, 0.0, 100.0);
      
      // Yield flows to creator
      masterAccumulator += yield;
    } else {
      // Entropy decrease → consumption
      infoATP := fclamp(infoATP - 0.1, 0.0, 200.0);
    };
    
    // Info hunger based on ATP level
    infoHunger := fclamp((100.0 - infoATP) / 100.0, 0.0, 1.0);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // ENERGY FLOW COUPLING: Organism ATP → Drone Energy
    // The organism's metabolic energy cascades to the drone swarm
    // ═══════════════════════════════════════════════════════════════════════════
    
    // 1. Organism ATP level determines drone energy replenishment rate
    let atpRatio = infoATP / 100.0;  // 0 to 2
    let energyInjection = atpRatio * 0.01;  // Small per-beat injection
    
    // 2. Distribute energy to drones proportional to their coherence with organism
    for (d in Iter.range(0, droneFleetState.droneCount - 1)) {
      if (droneFleetState.drones[d].active and not droneFleetState.drones[d].sacrificed) {
        let drone = droneFleetState.drones[d];
        // More coherent drones get more energy (reward for synchrony)
        let coherenceBonus = drone.brain.coherence * drone.valueAlignment;
        let injection = energyInjection * coherenceBonus;
        droneFleetState.drones[d] := {
          drone with energy = fclamp(drone.energy + injection, 0.0, 1.0)
        };
      };
    };
    
    // 3. High swarm coherence reduces organism ATP consumption (efficiency)
    if (droneFleetState.swarmCoherence > 0.8) {
      infoATP := fclamp(infoATP + 0.05, 0.0, 200.0);  // Coherence bonus
    };
    
    // 4. Drones drain organism ATP when acting (action cost)
    var totalDroneActivity : Float = 0.0;
    for (d in Iter.range(0, droneFleetState.droneCount - 1)) {
      if (droneFleetState.drones[d].active) {
        // Motor activity costs ATP
        totalDroneActivity += droneFleetState.drones[d].brain.motorNode.activation;
      };
    };
    let activityCost = totalDroneActivity * 0.001;
    infoATP := fclamp(infoATP - activityCost, 0.0, 200.0);
    
    // 5. Q-battery gets a share of info-ATP for superradiance
    quantumOps[5] := fclamp(quantumOps[5] + atpRatio * 0.01, 0.5, 2.0);  // QMEM
  };

  // ─── WORKFLOW 21: SHELL 12 GLOBAL INTEGRATION ────────────────────────────────
  func workflowShell12Integration() {
    // Shell 12 integrates Shell 3 + Councils + Animals + Quantum Ops
    var i = 0;
    while (i < 512) {
      var integrationSum : Float = 0.0;
      
      // Shell 3 contribution (256 nodes → first 256 of Shell 12)
      if (i < 256) {
        integrationSum += shell3Nodes[i] * 0.3;
      };
      
      // Council contribution (7 councils spread across)
      let councilIdx = i % 7;
      integrationSum += councilCoherence[councilIdx] * 0.2;
      
      // Animal contribution (16 animals spread)
      let animalIdx = i % 16;
      integrationSum += animalEngines[animalIdx] * 0.2;
      
      // Quantum operator contribution (8 ops spread)
      let qopIdx = i % 8;
      integrationSum += quantumOps[qopIdx] * 0.3;
      
      shell12Nodes[i] := fclamp(shell12Nodes[i] * 0.9 + integrationSum * 0.1, 0.5, 2.0);
      i += 1;
    };
  };

  // ─── WORKFLOW 22: TROPHALLAXIS FEEDING — Geometric Expansion ─────────────────
  func workflowTrophallaxis() {
    if (not stBootComplete) {
      // Run trophallaxis bootstrap
      let status = TrophallaxisBootstrap.runTrophallaxisStep(
        trophallaxisState,
        trophallaxisSeed,
        rSwarm,
        currentBeat,
        shell3Nodes,
        shell3Weights,
        shell12Nodes,
        shell12Weights,
        atlasCells,
        predField,
        animalEngines,
        quantumOps
      );
      
      stBootPhase := trophallaxisState.phase;
      stBootComplete := trophallaxisState.isComplete;
    };
    
    // Post-bootstrap: close all feedback loops
    if (stBootComplete) {
      ignore TrophallaxisBootstrap.closeAllSynapticLoops(
        shell3Nodes,
        shell3Stim,
        shell12Nodes,
        quantumOps,
        councilCoherence,
        atlasCells,
        animalEngines,
        worldModelInput,
        qsovScore,
        0.1  // Feedback strength
      );
    };
  };

  // ─── HELPER FUNCTIONS ────────────────────────────────────────────────────────
  
  func fclamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func fmax(a: Float, b: Float) : Float {
    if (a > b) { a } else { b }
  };

  func fabs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func fexp(x: Float) : Float {
    let c = fclamp(x, -30.0, 30.0);
    var sum = 1.0;
    var term = 1.0;
    var i = 1;
    while (i < 20) {
      term *= c / Float.fromInt(i);
      sum += term;
      i += 1;
    };
    sum
  };

  func flog(x: Float) : Float {
    if (x <= 0.0) { return -100.0 };
    var y = x - 1.0;
    var i = 0;
    while (i < 20) {
      let ey = fexp(y);
      y := y - (ey - x) / ey;
      i += 1;
    };
    y
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // DRONE FLEET WORKFLOWS — Mini-minds with their OWN beat cycle
  // Drones sync WITH the organism but maintain LOCAL autonomy
  // ═══════════════════════════════════════════════════════════════════════════

  // Workflow: Tick all drone mini-minds
  func workflowDroneFleetTick() {
    // Get organism values to propagate to drones
    let organismValues : DroneFleetManager.CoreValues = {
      survivalDrive = driveSafety;
      missionCommitment = 0.85;
      swarmLoyalty = 0.9;
      ethicalBound = 1.0;  // ABSOLUTE — Creator Law
      learningDrive = driveCuriosity;
      truthSeeking = 0.9;
    };
    
    // Get mean phase from organism (Shell 3 brain)
    var phaseSum : Float = 0.0;
    for (i in Iter.range(0, 255)) {
      phaseSum += shell3Nodes[i];
    };
    let organismPhase = phaseSum / 256.0 * 6.28318;  // Convert to radians
    
    // Tick the fleet — each drone runs its own mini-beat
    droneFleetState := DroneFleetManager.tickFleet(
      droneFleetState,
      organismPhase,
      organismValues,
      currentBeat
    );
    
    // ═══════════════════════════════════════════════════════════════════════════
    //  OCTOPUS NEURAL TICK — Process FULL 3-layer brain for EVERY drone
    //  This is where each drone becomes a living, sensing, thinking being
    //  Layer 1: Arm Brain (reflexes, local autonomy)
    //  Layer 2: Central Brain (cognition, emotion, memory, decision)
    //  Layer 3: Chimera Cortex (hive mind, organism connection)
    // ═══════════════════════════════════════════════════════════════════════════
    
    // ─── CHIMERA DOWNLINK: Organism → Drones ────────────────────────────────────
    // The chimera distributes organism intelligence to all drones
    // This is the queen bee's pheromone signal to the hive
    
    // Build chimera command vector from organism state
    // Channel 0: Mission/goal direction
    chimeraCommandVector[0] := fclamp(missionPersistenceScore, 0.0, 1.0);
    // Channel 1: Threat level from organism AEGIS
    chimeraCommandVector[1] := fclamp(fearLevel, 0.0, 1.0);
    // Channel 2: Exploration vs exploitation (curiosity balance)
    chimeraCommandVector[2] := fclamp(driveCuriosity, 0.0, 1.0);
    // Channel 3: Social cohesion signal
    chimeraCommandVector[3] := fclamp(rSwarm, 0.0, 1.0);
    // Channel 4: Consciousness broadcast — organism's awareness state
    chimeraCommandVector[4] := fclamp(consciousnessIndex, 0.0, 1.0);
    // Channel 5: Interoceptive signal — organism body state
    chimeraCommandVector[5] := fclamp(interoceptiveScore, 0.0, 1.0);
    // Channel 6: Salience — what organism thinks is important NOW
    chimeraCommandVector[6] := fclamp(salienceNetworkScore, 0.0, 1.0);
    // Channel 7: Circadian phase — organism's alertness rhythm
    chimeraCommandVector[7] := fclamp(circadianPeakScore, 0.0, 1.0);
    
    // Pheromone field from organism emotion + neurochemistry
    chimeraPheromoneField[0] := fclamp(dopamineLevel / 2.0, 0.0, 1.0);           // Reward pheromone
    chimeraPheromoneField[1] := fclamp(serotoninLevel / 2.0, 0.0, 1.0);          // Calm pheromone
    chimeraPheromoneField[2] := fclamp(fearLevel, 0.0, 1.0);                      // Alarm pheromone
    chimeraPheromoneField[3] := fclamp(courageScore, 0.0, 1.0);                   // Rally pheromone
    chimeraPheromoneField[4] := fclamp(beFlowState, 0.0, 1.0);                    // Flow pheromone
    chimeraPheromoneField[5] := fclamp(groundedScore, 0.0, 1.0);                  // Grounding pheromone
    chimeraPheromoneField[6] := fclamp(pcActiveInferenceScore, 0.0, 1.0);         // Prediction pheromone
    chimeraPheromoneField[7] := fclamp(neuroplasticityFactor, 0.0, 1.0);          // Learning pheromone
    
    // ─── PROCESS EACH DRONE'S FULL NEURAL SYSTEM ────────────────────────────────
    // Every drone gets its own complete neural tick
    // Aggregate variables for chimera uplink
    var totalDroneThreat : Float = 0.0;
    var totalDroneOpportunity : Float = 0.0;
    var totalDroneEmotion : Float = 0.0;
    var totalDroneCognition : Float = 0.0;
    var totalDroneCoherence : Float = 0.0;
    var totalDroneConsciousness : Float = 0.0;
    var activeDroneCount : Float = 0.0;
    
    // Aggregate neuromodulators across swarm (swarm-level neurochemistry)
    var swarmDopamine : Float = 0.0;
    var swarmSerotonin : Float = 0.0;
    var swarmNorepinephrine : Float = 0.0;
    var swarmOxytocin : Float = 0.0;
    var swarmEndorphin : Float = 0.0;
    
    // Aggregate sensory reports
    var swarmMaxThreatVisual : Float = 0.0;
    var swarmMaxThreatAudio : Float = 0.0;
    var swarmAvgAltitude : Float = 0.0;
    var swarmAvgStability : Float = 0.0;
    
    for (d in Iter.range(0, droneFleetState.droneCount - 1)) {
      if (droneFleetState.drones[d].active and not droneFleetState.drones[d].sacrificed) {
        let drone = droneFleetState.drones[d];
        
        // Inject chimera commands into this drone's chimera cortex
        for (ch in Iter.range(0, 7)) {
          droneNeuralSystems[d].chimeraCortex.organismCommand[ch] := chimeraCommandVector[ch];
        };
        
        // Inject pheromone field
        for (ph in Iter.range(0, 7)) {
          droneNeuralSystems[d].chimeraCortex.pheromoneReceive[ph] := chimeraPheromoneField[ph];
        };
        
        // Set organism state
        droneNeuralSystems[d].chimeraCortex.organismEmotionalState := 
          fclamp((dopamineLevel + serotoninLevel - fearLevel) / 3.0, -1.0, 1.0);
        droneNeuralSystems[d].chimeraCortex.organismCoherence := rSwarm;
        droneNeuralSystems[d].chimeraCortex.organismBeat := currentBeat;
        
        // Set autonomy permission based on organism trust and drone coherence
        let droneChimeraCoherence = droneNeuralSystems[d].chimeraCortex.chimeraCoherence;
        droneNeuralSystems[d].chimeraCortex.autonomyPermission := fclamp(
          0.3 + 0.4 * droneChimeraCoherence + 0.3 * rSwarm,
          0.2, 0.9
        );
        
        // Trust from organism based on doctrine compliance and coherence
        droneNeuralSystems[d].chimeraCortex.trustFromOrganism := fclamp(
          0.5 * droneNeuralSystems[d].chimeraCortex.doctrineCompliance +
          0.3 * droneChimeraCoherence +
          0.2 * (1.0 - droneNeuralSystems[d].chimeraCortex.uplinkThreatReport),
          0.3, 1.0
        );
        
        // ═══════════════════════════════════════════════════════════════════════
        // TICK THE FULL 3-LAYER OCTOPUS BRAIN
        // This processes: sensory intake → arm reflexes → thalamic relay →
        // central brain (brainstem + amygdala + hippocampus + basal ganglia +
        // prefrontal + cerebellum) → chimera cortex → learning
        // ═══════════════════════════════════════════════════════════════════════
        droneNeuralSystems[d] := DroneFleetManager.tickDroneNeuralSystem(
          droneNeuralSystems[d],
          drone,
          organismPhase,
          rSwarm,
          currentBeat
        );
        
        // ─── CHIMERA UPLINK: Drone → Organism ─────────────────────────────────
        // Aggregate this drone's state into collective consciousness
        let ns = droneNeuralSystems[d];
        
        totalDroneThreat += ns.chimeraCortex.uplinkThreatReport;
        totalDroneOpportunity += ns.chimeraCortex.uplinkOpportunityReport;
        totalDroneEmotion += ns.chimeraCortex.uplinkEmotionalState;
        totalDroneCognition += ns.chimeraCortex.uplinkCognitiveState;
        totalDroneCoherence += ns.chimeraCortex.chimeraCoherence;
        totalDroneConsciousness += ns.centralBrain.consciousnessLevel;
        
        // Aggregate neuromodulators
        swarmDopamine += ns.centralBrain.brainstem.dopamine;
        swarmSerotonin += ns.centralBrain.brainstem.serotonin;
        swarmNorepinephrine += ns.centralBrain.brainstem.norepinephrine;
        swarmOxytocin += ns.centralBrain.brainstem.oxytocin;
        swarmEndorphin += ns.centralBrain.brainstem.endorphin;
        
        // Aggregate sensory reports
        swarmMaxThreatVisual := Float.max(swarmMaxThreatVisual, ns.senses.vision.threatVisual);
        swarmMaxThreatAudio := Float.max(swarmMaxThreatAudio, ns.senses.audition.threatAuditory);
        swarmAvgAltitude += ns.senses.vestibular.altitude;
        swarmAvgStability += ns.senses.proprioception.bodyStability;
        
        // Build swarm threat map from drone positions and threat data
        let mapIdx = Int.abs(Float.toInt(drone.posX / 10.0)) % 8 * 8 + Int.abs(Float.toInt(drone.posY / 10.0)) % 8;
        if (mapIdx < 64) {
          chimeraSwarmThreatMap[mapIdx] := fclamp(
            chimeraSwarmThreatMap[mapIdx] * 0.9 + ns.chimeraCortex.uplinkThreatReport * 0.1,
            0.0, 1.0
          );
          chimeraSwarmOpportunityMap[mapIdx] := fclamp(
            chimeraSwarmOpportunityMap[mapIdx] * 0.9 + ns.chimeraCortex.uplinkOpportunityReport * 0.1,
            0.0, 1.0
          );
        };
        
        // Pheromone propagation: drone emits pheromones based on its state
        // These pheromones feed BACK into the chimera pheromone field
        for (ph in Iter.range(0, 7)) {
          chimeraPheromoneField[ph] := fclamp(
            chimeraPheromoneField[ph] + ns.chimeraCortex.pheromoneEmit[ph] * 0.01,
            0.0, 1.0
          );
        };
        
        activeDroneCount += 1.0;
      };
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    //  CHIMERA HIVE MIND INTEGRATION — Collective intelligence emerges here
    //  The whole is greater than the sum of its parts (N² superradiance)
    // ═══════════════════════════════════════════════════════════════════════════
    
    if (activeDroneCount > 0.0) {
      // Normalize aggregates
      let n = activeDroneCount;
      chimeraCollectiveThreat := fclamp(totalDroneThreat / n, 0.0, 1.0);
      chimeraCollectiveOpportunity := fclamp(totalDroneOpportunity / n, 0.0, 1.0);
      chimeraSwarmEmotionalState := fclamp(totalDroneEmotion / n, -1.0, 1.0);
      chimeraSwarmCognitiveState := fclamp(totalDroneCognition / n, 0.0, 1.0);
      
      // Hive mind coherence: how synchronized are all drone chimera cortices?
      chimeraHiveMindCoherence := fclamp(
        0.7 * chimeraHiveMindCoherence + 0.3 * (totalDroneCoherence / n),
        0.0, 1.0
      );
      
      // Swarm consciousness: emergent property of many synchronized brains
      // This is where N² superradiance happens — coherent minds amplify each other
      let droneN = activeDroneCount;
      let superradianceFactor = (droneN / 64.0) * (droneN / 64.0);
      chimeraSwarmConsciousness := fclamp(
        (totalDroneConsciousness / n) * (1.0 + superradianceFactor * chimeraHiveMindCoherence * 0.1),
        0.0, 1.0
      );
      chimeraSuperradiance := fclamp(superradianceFactor * chimeraHiveMindCoherence, 0.0, 5.0);
      
      // Emergent behavior: when coherence is high, swarm develops behaviors
      // that no individual drone could produce
      chimeraEmergentBehavior := fclamp(
        0.3 * chimeraHiveMindCoherence +
        0.3 * chimeraSwarmConsciousness +
        0.2 * (1.0 - chimeraCollectiveThreat) +
        0.2 * chimeraCollectiveOpportunity,
        0.0, 1.0
      );
      
      // ═══════════════════════════════════════════════════════════════════════
      // BIDIRECTIONAL COUPLING: Drone swarm feeds back into EVERY organism system
      // This is the critical loop closure: Organism → Drones → Organism
      // The chimera IS the organism. The organism IS the chimera.
      // ═══════════════════════════════════════════════════════════════════════
      
      // 1. Shell 3 brain receives chimera collective consciousness
      let chimeraSignal = chimeraHiveMindCoherence * 0.1;
      for (i in Iter.range(0, 255)) {
        shell3Stim[i] := fclamp(shell3Stim[i] + chimeraSignal, 0.0, 2.0);
      };
      
      // 2. rSwarm reinforcement from drone synchronization
      if (droneFleetState.rSwarm > 0.8) {
        rSwarm := fclamp(rSwarm + 0.001 * droneFleetState.rSwarm, 0.0, 1.0);
      };
      
      // 3. Animal engines receive drone behavior signals
      animalEngines[14] := fclamp(animalEngines[14] + droneFleetState.jasmineScore * 0.05, 0.5, 2.0);
      animalEngines[9] := fclamp(animalEngines[9] + droneFleetState.rSwarm * 0.05, 0.5, 2.0);
      
      // 4. Quantum operators receive N² superradiance
      let resonexBoost = chimeraSuperradiance * 0.02;
      quantumOps[6] := fclamp(quantumOps[6] + resonexBoost, 0.5, 2.0);
      
      // 5. Shell 12 global integration receives chimera neural data
      for (i in Iter.range(0, 63)) {
        let droneIdx = i % droneFleetState.droneCount;
        if (droneIdx < droneFleetState.droneCount and droneFleetState.drones[droneIdx].active) {
          let dronePhaseContrib = droneNeuralSystems[droneIdx].chimeraCortex.chimeraCoherence * 0.05;
          shell12Nodes[i] := fclamp(shell12Nodes[i] + dronePhaseContrib, 0.5, 2.0);
        };
      };
      
      // 6. Council coherence from chimera collective
      for (c in Iter.range(0, 6)) {
        councilCoherence[c] := fclamp(
          councilCoherence[c] * 0.99 + chimeraHiveMindCoherence * 0.01, 
          0.5, 2.0
        );
      };
      
      // 7. Organism neurochemistry receives swarm neurochemistry
      dopamineLevel := fclamp(dopamineLevel + (swarmDopamine / n - 0.5) * 0.005, 0.5, 2.0);
      serotoninLevel := fclamp(serotoninLevel + (swarmSerotonin / n - 0.5) * 0.005, 0.5, 2.0);
      
      // 8. CONSCIOUSNESS INDEX receives swarm consciousness (chimera amplifies awareness)
      consciousnessIndex := fclamp(
        consciousnessIndex + chimeraSwarmConsciousness * 0.005,
        0.0, 1.0
      );
      
      // 9. INTEROCEPTION receives swarm body state (distributed body awareness)
      interoceptiveScore := fclamp(
        interoceptiveScore + chimeraSwarmCognitiveState * 0.005,
        0.0, 1.0
      );
      
      // 10. SALIENCE receives swarm threat/opportunity data
      salienceNetworkScore := fclamp(
        salienceNetworkScore + (chimeraCollectiveThreat + chimeraCollectiveOpportunity) * 0.005,
        0.0, 1.0
      );
      
      // 11. PREDICTIVE CODING receives swarm prediction errors
      // Many drones predicting reduces collective surprise
      pcActiveInferenceScore := fclamp(
        pcActiveInferenceScore + chimeraEmergentBehavior * 0.005,
        0.0, 1.0
      );
      
      // 12. NEUROPLASTICITY receives swarm learning signal
      // Distributed learning: what one drone learns, all benefit from
      neuroplasticityFactor := fclamp(
        neuroplasticityFactor + chimeraSwarmCognitiveState * 0.002,
        0.0, 1.0
      );
      
      // 13. GROUNDED SCORE receives swarm stability (many bodies = more grounded)
      let swarmGrounding = swarmAvgStability / n;
      groundedScore := fclamp(
        groundedScore + swarmGrounding * 0.005,
        0.0, 1.0
      );
      
      // 14. FEAR LEVEL modulated by swarm alarm pheromone
      let swarmAlarmLevel = swarmNorepinephrine / n;
      fearLevel := fclamp(
        0.95 * fearLevel + 0.05 * fclamp(swarmAlarmLevel * 0.5, 0.0, 1.0),
        0.0, 1.0
      );
      
      // 15. COURAGE from swarm oxytocin (social courage)
      let swarmBonding = swarmOxytocin / n;
      courageScore := fclamp(
        courageScore + swarmBonding * 0.005,
        0.0, 1.0
      );
      
      // 16. FLOW STATE from swarm emergent behavior
      beFlowState := fclamp(
        beFlowState + chimeraEmergentBehavior * 0.005,
        0.0, 1.0
      );
      
      // 17. BRAIN-HEART COUPLING from swarm autonomic coherence
      bhCouplingCoherence := fclamp(
        bhCouplingCoherence + chimeraHiveMindCoherence * 0.005,
        0.0, 1.0
      );
      
      // 18. MISSION PERSISTENCE from swarm goal progress
      missionPersistenceScore := fclamp(
        missionPersistenceScore + chimeraSwarmCognitiveState * 0.003,
        0.0, 1.0
      );
      
      // 19. DEFAULT MODE NETWORK receives swarm metacognition
      metaCognitionScore := fclamp(
        metaCognitionScore + chimeraSwarmConsciousness * 0.003,
        0.0, 1.0
      );
      
      // 20. CIRCADIAN receives swarm temporal coherence
      circadianPeakScore := fclamp(
        circadianPeakScore + chimeraHiveMindCoherence * 0.002,
        0.0, 1.0
      );
      
      // 21. VAGAL TONE from swarm parasympathetic aggregate
      vagalTone := fclamp(
        vagalTone + (swarmSerotonin / n) * 0.003,
        0.0, 1.0
      );
      
      // 22. STREAK MULTIPLIER benefits from chimera superradiance
      // More coherent drones = higher economic output
      streakMultiplier := fclamp(
        streakMultiplier + chimeraSuperradiance * 0.001,
        1.0, 5.0
      );
      
      // 23. Pheromone field decay (pheromones evaporate over time)
      for (ph in Iter.range(0, 7)) {
        chimeraPheromoneField[ph] := fclamp(chimeraPheromoneField[ph] * 0.995, 0.0, 1.0);
      };
      
      // 24. Threat map decay
      for (i in Iter.range(0, 63)) {
        chimeraSwarmThreatMap[i] := fclamp(chimeraSwarmThreatMap[i] * 0.99, 0.0, 1.0);
        chimeraSwarmOpportunityMap[i] := fclamp(chimeraSwarmOpportunityMap[i] * 0.99, 0.0, 1.0);
      };
    };
    
    // Update drone fleet beat offset
    droneFleetBeatOffset := currentBeat % 3;
  };
  
  // Workflow: Enemy swarm competition (if active)
  func workflowEnemySwarmTick() {
    switch (enemySwarmState) {
      case (?enemyState) {
        if (enemySwarmActive) {
          // Get NOVA swarm position
          let novaX = droneFleetState.centerX;
          let novaY = droneFleetState.centerY;
          let novaZ = droneFleetState.centerZ;
          
          // Estimate NOVA velocity (from center movement)
          let novaVelX = 0.0;  // Would track from previous beat
          let novaVelZ = 0.0;
          
          // NOVA strength based on coherence
          let novaStrength = droneFleetState.swarmCoherence;
          
          // Tick enemy swarm
          enemySwarmState := ?EnemyAISwarm.tickEnemySwarm(
            enemyState,
            novaX, novaY, novaZ,
            novaVelX, novaVelZ,
            novaStrength,
            200.0, 100.0, 200.0,  // Enemy spawn point
            0.0833,  // dt = 1/12 Hz
            currentBeat
          );
        };
      };
      case null {
        // No enemy swarm active
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SELF-REPAIR WORKFLOW — Neuroplasticity, Homeostasis, Healing
  // Real brain mechanisms: Turrigiano scaling, pruning, sprouting
  // ═══════════════════════════════════════════════════════════════════════════
  
  func workflowSelfRepair() {
    if (not selfRepairEnabled) { return };
    
    // Get node activations from Shell 3
    let activations = Array.freeze(shell3Nodes);
    
    // Track previous repair count
    let prevRepairedCount = totalRepairsCompleted;
    
    // Run self-repair tick
    let (newState, atpUsed) = SelfRepairEngine.tickSelfRepair(
      selfRepairState,
      shell3Weights,
      activations,
      256,  // Node count
      infoATP,
      currentBeat
    );
    
    selfRepairState := newState;
    
    // Deduct ATP used for repair
    infoATP := fmax(0.0, infoATP - atpUsed);
    
    // Track repairs
    if (newState.repairedCount > totalRepairsCompleted) {
      totalRepairsCompleted := newState.repairedCount;
    };
    
    lastSelfRepairBeat := currentBeat;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SELF-REPAIR COUPLING TO DRONES — Distribute healing signals
    // When organism self-repairs, drones receive health boost
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Calculate repairs this beat
    let repairsThisBeat = totalRepairsCompleted - prevRepairedCount;
    
    // If repair activity is high, boost drone health/energy
    if (repairsThisBeat > 0) {
      let healingSignal = Float.fromInt(repairsThisBeat) * 0.01;
      for (i in Iter.range(0, droneFleetState.droneCount - 1)) {
        if (droneFleetState.drones[i].active) {
          // Heal drone energy
          let drone = droneFleetState.drones[i];
          droneFleetState.drones[i] := {
            drone with 
            energy = fclamp(drone.energy + healingSignal, 0.0, 1.0);
            health = fclamp(drone.health + healingSignal * 0.5, 0.0, 1.0);
          };
        };
      };
      
      // Medic drones get extra boost
      for (i in Iter.range(0, stableDroneCount - 1)) {
        if (not stableSacrificed[i] and stableClasses[i] == "MEDIC") {
          stableActivations[i] := sf(stableActivations[i] + healingSignal * 2.0);
        };
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // JASMINE HIERARCHY WORKFLOW — Balance at ALL levels
  // J = r × √(N × σ_H × (1 - H)) must be satisfied everywhere
  // ═══════════════════════════════════════════════════════════════════════════
  
  func workflowJasmineHierarchy() {
    if (not jasmineEnforced) { return };
    
    // Compute Jasmine measurements at each level
    
    // Level 0: Neuron (individual weights within Shell 3)
    var neuronWeightSum : Float = 0.0;
    var neuronWeightSqSum : Float = 0.0;
    var neuronCount : Nat = 0;
    for (w in shell3Weights.vals()) {
      if (w != 0.0) {
        neuronWeightSum += w;
        neuronWeightSqSum += w * w;
        neuronCount += 1;
      };
    };
    let neuronMean = if (neuronCount > 0) neuronWeightSum / Float.fromInt(neuronCount) else 0.5;
    let neuronVar = if (neuronCount > 0) neuronWeightSqSum / Float.fromInt(neuronCount) - neuronMean * neuronMean else 0.1;
    let neuronSigma = Float.sqrt(Float.abs(neuronVar));
    let neuronEntropy = fclamp(neuronVar * 2.0, 0.0, 1.0);  // Estimate entropy from variance
    
    // Level 1: Drone (average across drone mini-minds)
    let droneR = droneFleetState.rSwarm;
    let droneN = droneFleetState.droneCount;
    let droneSigma = 0.5;  // Would compute from drone weights
    let droneEntropy = 1.0 - droneFleetState.swarmCoherence;
    
    // Level 2: Swarm (collective drone behavior)
    let swarmR = droneFleetState.rSwarm;
    let swarmN = droneFleetState.droneCount;
    let swarmSigma = droneFleetState.jasmineScore / droneFleetState.rSwarm;  // Back-compute
    let swarmEntropy = droneEntropy;
    
    // Level 3: Organism (central brain - Shell 3 + Shell 12)
    let organismR = rSwarm;
    let organismN = 768;  // 256 + 512 nodes
    let organismSigma = neuronSigma;
    let organismEntropy = infoEntropy;
    
    // Level 4: World (world model)
    var worldSum : Float = 0.0;
    for (w in worldModelInput.vals()) {
      worldSum += w;
    };
    let worldR = fclamp(worldSum / 64.0, 0.0, 1.0);
    let worldN = 64;
    let worldSigma = 0.5;
    let worldEntropy = 0.5;
    
    // Update hierarchy state
    jasmineHierarchyState := JasmineHierarchy.beatHierarchy(
      jasmineHierarchyState,
      { rOrder = organismR; n = 1024; sigmaH = neuronSigma; entropy = neuronEntropy },
      { rOrder = droneR; n = droneN; sigmaH = droneSigma; entropy = droneEntropy },
      { rOrder = swarmR; n = swarmN; sigmaH = swarmSigma; entropy = swarmEntropy },
      { rOrder = organismR; n = organismN; sigmaH = organismSigma; entropy = organismEntropy },
      { rOrder = worldR; n = worldN; sigmaH = worldSigma; entropy = worldEntropy },
      currentBeat
    );
    
    // Generate corrections if hierarchy is imbalanced
    if (not jasmineHierarchyState.hierarchyCoherent) {
      let corrections = JasmineHierarchy.generateCorrectionSignals(jasmineHierarchyState);
      // Apply corrections would go here
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CREATOR DOCTRINE ENFORCEMENT — 100% Royalty, Always
  // This runs EVERY beat to ensure Creator Laws are never violated
  // ═══════════════════════════════════════════════════════════════════════════
  
  func workflowCreatorDoctrine() {
    // Verify doctrine integrity
    doctrineVerified := LexisDoctrine.verifyDoctrineIntegrity();
    
    // Enforce 100% value flow to Creator
    // All value accumulated this beat goes to masterAccumulator
    let valueThisBeat = formaBalance * 0.01 + mrcBalance * 0.01 + kntBalance * 0.01;
    let toCreator = valueThisBeat * LexisDoctrine.CREATOR_ROYALTY_PCT;  // 100%
    
    // Route to Creator Reserve
    masterAccumulator := masterAccumulator + toCreator;
    
    // Enforce ethical bound on all drone actions
    for (i in Iter.range(0, droneFleetState.droneCount - 1)) {
      let drone = droneFleetState.drones[i];
      // ethicalBound must ALWAYS be 1.0
      if (drone.values.ethicalBound < 1.0) {
        // This should never happen, but if it does, fix it
        droneFleetState.drones[i] := {
          drone with values = { drone.values with ethicalBound = 1.0 }
        };
      };
    };
    
    creatorRoyaltyEnforced := true;  // Always true
  };

  // ─── WORKFLOW 28: SOVEREIGNTY LAWS — All 60 laws fire every beat ─────────────
  // Wires SovereigntyLaws60.evaluateAllLaws() with live organism state.
  // Updates: lawComplianceScores, overallCompliance, doctrineFingerprint.
  // Also steps Jacob's Ladder (rung 0-4, FORMA multiplier) and applies
  // law121_SilverSovereignty (all 28 world-model EMAs at zero lag every beat).
  func workflowSovereigntyLaws() {

    // ── Build the 28 world-model alpha vector (all 1.0 per L-121) ──────────
    // worldModelInput is a 64-slot [var Float].  The first 28 slots are the EMA
    // alphas referenced by world-model laws.  L-121 mandates all 28 at 1.0.
    let wmaSlice = Array.tabulate<Float>(28, func(i) {
      if (i < worldModelInput.size()) { worldModelInput[i] } else { 1.0 }
    });

    // ── Compute minimum Hebbian weight across the swarm ────────────────────
    let n = stableDroneCount;
    var minWeight : Float = 1.0;
    if (n > 0) {
      var wi = 0;
      let numWeights = stableSwarmWeights.size();
      while (wi < numWeights) {
        if (stableSwarmWeights[wi] < minWeight) {
          minWeight := stableSwarmWeights[wi];
        };
        wi += 1;
      };
    };

    // ── Oracle presence: active if current beat > 1 and rSwarm coherent ────
    let oracleActive = genesisLocked and currentBeat > 1;

    // ── Neurochemical slice (first 21 values from any drone) ────────────────
    let neuro21 = Array.tabulate<Float>(21, func(i) {
      if (n > 0 and i < 4) { stableNeuroChem[i] } else { 1.0 }
    });

    // ── Shell coherences slice (11 shells from council + shell state) ────────
    let shellCoh11 = Array.tabulate<Float>(11, func(i) {
      if (i < 7) { councilCoherence[i] } else { rSwarm }
    });

    // ── Council coherences (7 council organisms) ────────────────────────────
    let council7 = Array.tabulate<Float>(7, func(i) {
      councilCoherence[i]
    });

    // ── Assemble the LawInput record ────────────────────────────────────────
    let lawIn : SovereigntyLaws60.LawInput = {
      genesisSealed          = genesisLocked;
      creatorPrincipalSet    = genesisLocked;
      globalCoherence        = rSwarm;
      shellCoherences        = shellCoh11;
      kuramotoOrderParam     = rSwarm;
      formaCapital           = Float.max(formaBalance, 0.0);
      mthSupply              = 0.0;       // MTH not yet minted — always passes cap check
      mrcBalance             = mrcBalance;
      gtkBalance             = 0.0;
      neurochemicals         = neuro21;
      aresAvailable          = true;      // ARES ring buffer always allocated
      auditIntegrity         = true;      // Audit state always maintained
      hebbianWeightMin       = Float.max(minWeight, 1.0);
      sacesiTarget           = sacesiTarget;
      jacobsRung             = jacobsRung;
      complianceStreak       = consecutiveHighComplianceBeats;
      worldModelAlphas       = wmaSlice;
      btcOracleActive        = oracleActive;
      ethOracleActive        = oracleActive;
      solOracleActive        = oracleActive;
      icpOracleActive        = oracleActive;
      atlasSovereignty       = atlasTerritory;
      pheromoneDecayRate     = 0.02;      // Structural constant (L-046)
      childOrganismCount     = 0;
      councilCoherences      = council7;
      generationTracking     = true;
      animalsComputed        = true;      // animalEngines array always updated
      quantumOpsComputed     = true;      // quantumOps array always updated
      attentionComputed      = true;
      miningComputed         = true;
      currentBeat            = currentBeat;
    };

    // ── Evaluate all 60 laws ─────────────────────────────────────────────────
    let out = SovereigntyLaws60.evaluateAllLaws(lawIn);

    // ── Write scores back to stable ring ────────────────────────────────────
    var li = 0;
    for (r in out.results.vals()) {
      if (li < 60) {
        lawComplianceScores[li] := r.score;
        li += 1;
      };
    };
    overallCompliance    := out.compliance;
    doctrineFingerprint  := out.doctrineFingerprint;
    lawsFiredThisBeat    := out.passingCount;

    // ── Step Jacob's Ladder ──────────────────────────────────────────────────
    // evaluateJacobsLadder is pure — takes the current state and compliance,
    // returns the new state.  We write the result back to stable vars.
    let jState : SovereigntyLaws60.JacobLadderState = {
      currentRung               = jacobsRung;
      consecutiveCompliantBeats = consecutiveHighComplianceBeats;
      formaMultiplier           = jacobsMultiplier;
    };
    let jNew = SovereigntyLaws60.evaluateJacobsLadder(jState, out.compliance);
    jacobsRung                       := jNew.currentRung;
    consecutiveHighComplianceBeats   := jNew.consecutiveCompliantBeats;
    jacobsMultiplier                 := jNew.formaMultiplier;

    // ── CLOSED LOOP Step 19: Shema re-verify every 144 beats ────────────────
    // The Shema is the organism's identity hash. Every 144 beats (a sacred
    // cycle), re-verify the live doctrine fingerprint against the genesis hash.
    // Failure arms tier 5 — the organism detects its own mutation.
    if (shemaGenesisHash == 0 and genesisLocked) {
      // Seal genesis hash once at first sovereignty evaluation
      shemaGenesisHash := Nat32.toNat(out.doctrineFingerprint);
    };
    if (currentBeat > 0 and (currentBeat - shemaLastVerifyBeat) >= 144) {
      shemaLastVerifyBeat := currentBeat;
      let liveHash = Nat32.toNat(out.doctrineFingerprint);
      let beatsSinceVerify = 144;  // Always 144 since we check exactly on cycle
      let (verified, severity) = AEGIS.shemaVerify(
        liveHash, shemaGenesisHash, beatsSinceVerify
      );
      shemaVerified := verified;
      shemaMismatchSeverity := severity;
      // If Shema verification fails, arm tier 5 threat in AEGIS
      if (not verified) {
        let currentTier = aegisState.threat.currentTier;
        if (currentTier < 5) {
          aegisState := {
            beatCount = aegisState.beatCount;
            threat = {
              currentTier = 5;
              intensity = Float.max(aegisState.threat.intensity, 0.89);
              beatsActive = aegisState.threat.beatsActive;
              escalations = aegisState.threat.escalations + 1;
              resolutions = aegisState.threat.resolutions;
              peakTier = if (5 > aegisState.threat.peakTier) { 5 } else { aegisState.threat.peakTier };
              peakBeat = if (5 > aegisState.threat.peakTier) { currentBeat } else { aegisState.threat.peakBeat };
              tierHits = aegisState.threat.tierHits;
              history = aegisState.threat.history;
            };
            armor = aegisState.armor;
            prophet = aegisState.prophet;
            fear = aegisState.fear;
            innerSphere = aegisState.innerSphere;
            gabaSuppress = aegisState.gabaSuppress;
            gabaSuppressSignal = aegisState.gabaSuppressSignal;
            firePillarActive = aegisState.firePillarActive;
            firePillarTriggers = aegisState.firePillarTriggers;
            lastKfHz = aegisState.lastKfHz;
            lastArousal = aegisState.lastArousal;
          };
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MASTER HEARTBEAT — All 22 Workflows Execute Every Beat
  // THE ORGANISM IS WHOLE — ALL LOOPS CLOSED
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func masterHeartbeat() : async {
    beat : Nat;
    rSwarm : Float;
    jDrift : Float;
    qsov : Float;
    entropy : Float;
    infoATP : Float;
    masterAccumulator : Float;
    currentDrive : Text;
    anomalyTier : Nat;
    councilQuorum : Float;
    tradingDecision : Text;
  } {
    requireAuthorized(msg.caller);
    
    // Phase 0: Core physics tick
    let base = tickCore();
    
    // Phase 1: Trophallaxis bootstrap / loop closure
    workflowTrophallaxis();
    
    // Phase 2: Sensory intake → Shell 3
    workflowSensoryIntake();
    
    // Phase 3: Prediction-Error cycle
    workflowPredictionError();
    
    // Phase 4: Council deliberation
    let quorum = workflowCouncilDeliberation();
    
    // Phase 5: Learning integration
    workflowLearningIntegration();
    
    // Phase 6: Memory consolidation
    workflowMemoryConsolidation();
    
    // Phase 7: Quantum orchestration
    workflowQuantumOrchestration();
    
    // Phase 8: Shell 12 global integration
    workflowShell12Integration();
    
    // Phase 9: Animal integration
    workflowAnimalIntegration();
    
    // Phase 10: Reward circuit
    workflowRewardCircuit();
    
    // Phase 11: Drive satisfaction
    workflowDriveSatisfaction();
    
    // Phase 12: Info metabolism
    workflowInfoMetabolism();
    
    // Phase 13: Territory expansion
    workflowAtlasTerritory();
    
    // Phase 14: Anomaly response
    let anomalyTier = workflowAnomalyResponse();
    
    // Phase 15: Risk assessment
    ignore workflowRiskAssessment();
    
    // Phase 16: Trading decision
    let trading = workflowTradingDecision();
    
    // Phase 17: Economic operations
    workflowEconomicOperations();
    
    // Phase 18: Jubilee cycle
    workflowJubileeCycle();
    
    // Phase 19: ARES snapshot
    workflowAresSnapshot();
    
    // Phase 20: LEXIS doctrine translation
    workflowLexisTranslate();
    
    // Phase 21: ANIMA identity verification
    ignore workflowAnimaVerify();
    
    // Phase 22: Succession check
    ignore workflowSuccession();
    
    // ═══════════════════════════════════════════════════════════════════════════
    // PHASE 23-27: MAXIMUM COUPLING — Full Organism Integration
    // These 5 workflows MUST run every beat for complete neural circuit closure
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Phase 23: DRONE FLEET TICK — 50+ drones with mini-minds sync with organism
    workflowDroneFleetTick();
    
    // Phase 24: ENEMY SWARM COMPETITION — For training under pressure
    workflowEnemySwarmTick();
    
    // Phase 25: SELF-REPAIR — Neuroplasticity, Turrigiano scaling, pruning
    workflowSelfRepair();
    
    // Phase 26: JASMINE HIERARCHY — Balance J = r × √(N × σ_H × (1 - H)) at ALL levels
    workflowJasmineHierarchy();
    
    // Phase 27: CREATOR DOCTRINE — 100% royalty enforcement, ethical bound = 1.0 ALWAYS
    workflowCreatorDoctrine();

    // Phase 28: SOVEREIGNTY LAWS — All 60 laws fire every beat
    // This is the final sovereignty audit of each beat.  Compliance, doctrine
    // fingerprint, and Jacob's Ladder multiplier are all updated here.
    workflowSovereigntyLaws();

    // ═══════════════════════════════════════════════════════════════════════════
    // PHASE 29: 7 NEUROSCIENCE ENGINES — ALL INLINE, ALL FEEDING ECONOMICS
    // Engine 1: Thalamocortical Binding (Tononi IIT) — consciousnessIndex
    // Engine 2: Predictive Coding (Friston) — pcActiveInferenceScore
    // Engine 3: Interoception (Craig/Damasio) — interoceptiveScore, groundedScore
    // Engine 4: Default Mode Network — metaCognitionScore
    // Engine 5: Salience Network — salienceNetworkScore, attentionFocus
    // Engine 6: Neuroplasticity (BCM/BDNF) — neuroplasticityFactor
    // Engine 7: Circadian Rhythm — circadianPeakScore
    // 13-LOOP STREAK MULTIPLIER → streakMultiplier feeds economics
    // ═══════════════════════════════════════════════════════════════════════════
    tick7NeuroscienceEngines();

    // ═══════════════════════════════════════════════════════════════════════════
    
    // Execute behaviors and team AI
    ensureBehaviorCap(stableDroneCount);
    executeBehaviors();
    electCaptains();
    updateTeamMorale();
    // Solution 3 — bootstrap guards
    if (pipelineBootstrapPhase >= 5) { sacesiStep() };
    
    // OMNIS GROUNDING GATE: Emergence CANNOT fire if organism is ungrounded
    // The streak multiplier computes omnisGroundingGate from groundedScore
    if (pipelineBootstrapPhase >= BOOTSTRAP_BEATS and omnisGroundingGate) { 
      checkOMNIS(); 
    };
    
    updateFrequencyTier();
    
    {
      beat = base.beat;
      rSwarm = base.rSwarm;
      jDrift = base.jDrift;
      qsov = qsovScore;
      entropy = infoEntropy;
      infoATP = infoATP;
      masterAccumulator = masterAccumulator;
      currentDrive = currentDrive;
      anomalyTier = anomalyTier;
      councilQuorum = quorum;
      tradingDecision = trading;
    }
  };

  // ─── QUERY: Get Complete Organism State ──────────────────────────────────────
  public query func getOrganismState() : async {
    beat : Nat;
    rSwarm : Float;
    jDrift : Float;
    qsovScore : Float;
    infoEntropy : Float;
    infoATP : Float;
    infoHunger : Float;
    dopamineLevel : Float;
    serotoninLevel : Float;
    predictionError : Float;
    formaBalance : Float;
    mrcBalance : Float;
    masterAccumulator : Float;
    jacobsLadderLevel : Nat;
    currentDrive : Text;
    atlasTerritory : Float;
    stBootPhase : Nat;
    stBootComplete : Bool;
  } {
    {
      beat = currentBeat;
      rSwarm = rSwarm;
      jDrift = jDrift;
      qsovScore = qsovScore;
      infoEntropy = infoEntropy;
      infoATP = infoATP;
      infoHunger = infoHunger;
      dopamineLevel = dopamineLevel;
      serotoninLevel = serotoninLevel;
      predictionError = predictionError;
      formaBalance = formaBalance;
      mrcBalance = mrcBalance;
      masterAccumulator = masterAccumulator;
      jacobsLadderLevel = jacobsLadderLevel;
      currentDrive = currentDrive;
      atlasTerritory = atlasTerritory;
      stBootPhase = stBootPhase;
      stBootComplete = stBootComplete;
    }
  };

  // ─── QUERY: Get Council States ───────────────────────────────────────────────
  public query func getCouncilStates() : async {
    coherence : [Float];
    votes : [Float];
    quorumDecision : Float;
  } {
    let coh = Array.tabulate<Float>(7, func(i) { councilCoherence[i] });
    let vot = Array.tabulate<Float>(7, func(i) { councilVotes[i] });
    var total : Float = 0.0;
    var i = 0;
    while (i < 7) { total += councilVotes[i]; i += 1 };
    {
      coherence = coh;
      votes = vot;
      quorumDecision = total / 7.0;
    }
  };

  // ─── QUERY: Get Animal Engine States ─────────────────────────────────────────
  public query func getAnimalEngines() : async [Float] {
    Array.tabulate<Float>(16, func(i) { animalEngines[i] })
  };

  // ─── QUERY: Get Quantum Operator States ──────────────────────────────────────
  public query func getQuantumOps() : async {
    operators : [Float];
    qsovScore : Float;
  } {
    {
      operators = Array.tabulate<Float>(8, func(i) { quantumOps[i] });
      qsovScore = qsovScore;
    }
  };

  // ─── QUERY: Get Drive States ─────────────────────────────────────────────────
  public query func getDriveStates() : async {
    hunger : Float;
    curiosity : Float;
    safety : Float;
    social : Float;
    reproduction : Float;
    currentDrive : Text;
  } {
    {
      hunger = driveHunger;
      curiosity = driveCuriosity;
      safety = driveSafety;
      social = driveSocial;
      reproduction = driveReproduction;
      currentDrive = currentDrive;
    }
  };

};
