// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ════════════════════════════════════════════════════════════════════════════════════════
//
// ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
// ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝
// █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗  
// ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝  
// ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗
// ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
//
// ██████╗ ███████╗███████╗██████╗  ██████╗ ███╗   ██╗███████╗██╗██████╗ ██╗██╗     ██╗████████╗██╗   ██╗
// ██╔══██╗██╔════╝██╔════╝██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║██╔══██╗██║██║     ██║╚══██╔══╝╚██╗ ██╔╝
// ██████╔╝█████╗  ███████╗██████╔╝██║   ██║██╔██╗ ██║███████╗██║██████╔╝██║██║     ██║   ██║    ╚████╔╝ 
// ██╔══██╗██╔══╝  ╚════██║██╔═══╝ ██║   ██║██║╚██╗██║╚════██║██║██╔══██╗██║██║     ██║   ██║     ╚██╔╝  
// ██║  ██║███████╗███████║██║     ╚██████╔╝██║ ╚████║███████║██║██████╔╝██║███████╗██║   ██║      ██║   
// ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝      ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝╚═════╝ ╚═╝╚══════╝╚═╝   ╚═╝      ╚═╝   
//
// ███╗   ███╗ █████╗ ████████╗██████╗ ██╗██╗  ██╗
// ████╗ ████║██╔══██╗╚══██╔══╝██╔══██╗██║╚██╗██╔╝
// ██╔████╔██║███████║   ██║   ██████╔╝██║ ╚███╔╝ 
// ██║╚██╔╝██║██╔══██║   ██║   ██╔══██╗██║ ██╔██╗ 
// ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║██║██╔╝ ██╗
// ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA ENGINE RESPONSIBILITY MATRIX
//
// Every engine in the organism has MULTIPLE responsibilities.
// Nothing is single-purpose. Everything is intertwined.
//
// This module defines and enforces the responsibility matrix for ALL engines.
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// ╔══════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                      ║
// ║   THE LAW: EVERY ENGINE HAS 2+ RESPONSIBILITIES                                     ║
// ║                                                                                      ║
// ║   This is not optional. This is how organisms work.                                 ║
// ║   A heart pumps blood AND produces hormones.                                        ║
// ║   A liver filters toxins AND produces bile.                                         ║
// ║   A neuron fires signals AND produces neurotransmitters.                            ║
// ║                                                                                      ║
// ║   Our engines are the same:                                                         ║
// ║   • BeeHiveMindEngine: Swarm coordination AND economic signaling                    ║
// ║   • KuramotoEngine: Neural sync AND pattern emergence                               ║
// ║   • FORMATokenEconomics: Metabolism AND governance voting                           ║
// ║   • ElephantMemory: Storage AND emotional processing                                ║
// ║                                                                                      ║
// ║   MINIMUM REQUIREMENTS:                                                             ║
// ║   • 2+ distinct responsibilities per engine                                         ║
// ║   • 3+ category connections per engine                                              ║
// ║   • 2+ scale coverage per engine                                                    ║
// ║                                                                                      ║
// ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module {

  // ════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS
  // ════════════════════════════════════════════════════════════════════════════════════════

  public let phi : Float = 1.6180339887498948482;
  public let psi : Float = 0.6180339887498948482;

  // Minimum requirements
  public let MIN_RESPONSIBILITIES : Nat = 2;
  public let MIN_CATEGORY_CONNECTIONS : Nat = 3;
  public let MIN_SCALE_COVERAGE : Nat = 2;

  // ════════════════════════════════════════════════════════════════════════════════════════
  // TYPES
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type ScaleLaw = {
    #Quantum;
    #Synaptic;
    #Neural;
    #Circuit;
    #Regional;
    #Organism;
    #Ecosystem;
  };

  public type EngineCategory = {
    #Animal;
    #Quantum;
    #Neural;
    #Cognitive;
    #Economic;
    #Territorial;
    #Defense;
    #Temporal;
    #Social;
    #Creative;
    #Governance;
    #Physical;
  };

  public type ResponsibilityType = {
    #Primary;           // Main function
    #Secondary;         // Supporting function
    #Emergent;          // Emerges from interactions
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // ENGINE RESPONSIBILITY DEFINITION
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type EngineResponsibility = {
    name : Text;
    description : Text;
    responsibilityType : ResponsibilityType;
    inputCategories : [EngineCategory];
    outputCategories : [EngineCategory];
    scalesAffected : [ScaleLaw];
    importance : Float;                    // 0.0 to 1.0
  };

  public type EngineDefinition = {
    engineName : Text;
    modulePath : Text;
    primaryCategory : EngineCategory;
    secondaryCategories : [EngineCategory];
    responsibilities : [EngineResponsibility];
    scalesCovered : [ScaleLaw];
    connectedEngines : [Text];
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // THE RESPONSIBILITY MATRIX — All major engines with their responsibilities
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Get the complete responsibility matrix for all major engines
  public func getResponsibilityMatrix() : [EngineDefinition] {
    [
      // ═══════════════════════════════════════════════════════════════════════════════
      // ANIMAL ENGINES
      // ═══════════════════════════════════════════════════════════════════════════════

      {
        engineName = "BeeHiveMindEngine";
        modulePath = "src/swarm_brain/modules/BeeHiveMindEngine.mo";
        primaryCategory = #Animal;
        secondaryCategories = [#Social, #Economic, #Neural];
        responsibilities = [
          {
            name = "Swarm Coordination";
            description = "Coordinate bee-like swarm behavior across drones";
            responsibilityType = #Primary;
            inputCategories = [#Animal, #Social];
            outputCategories = [#Social, #Physical];
            scalesAffected = [#Regional, #Organism];
            importance = 0.9;
          },
          {
            name = "Waggle Dance Communication";
            description = "Encode and decode information through dance patterns";
            responsibilityType = #Primary;
            inputCategories = [#Cognitive, #Territorial];
            outputCategories = [#Social, #Economic];
            scalesAffected = [#Neural, #Regional];
            importance = 0.85;
          },
          {
            name = "Economic Signaling";
            description = "Signal resource locations and values to swarm";
            responsibilityType = #Secondary;
            inputCategories = [#Economic, #Territorial];
            outputCategories = [#Economic, #Social];
            scalesAffected = [#Regional, #Ecosystem];
            importance = 0.7;
          },
          {
            name = "Collective Decision Making";
            description = "Make group decisions through quorum sensing";
            responsibilityType = #Secondary;
            inputCategories = [#Social, #Cognitive];
            outputCategories = [#Governance, #Social];
            scalesAffected = [#Regional, #Organism];
            importance = 0.8;
          }
        ];
        scalesCovered = [#Neural, #Regional, #Organism, #Ecosystem];
        connectedEngines = ["WolfPackProtocol", "OrcaPodEngine", "KuramotoEngine", "SwarmCoherenceMatrix"];
      },

      {
        engineName = "DolphinEcholocation";
        modulePath = "src/swarm_brain/modules/DolphinEcholocation.mo";
        primaryCategory = #Animal;
        secondaryCategories = [#Cognitive, #Territorial, #Social];
        responsibilities = [
          {
            name = "Echolocation Processing";
            description = "Process sonar returns for spatial mapping";
            responsibilityType = #Primary;
            inputCategories = [#Physical, #Cognitive];
            outputCategories = [#Cognitive, #Territorial];
            scalesAffected = [#Neural, #Circuit];
            importance = 0.95;
          },
          {
            name = "3D Spatial Mapping";
            description = "Build and maintain 3D world models";
            responsibilityType = #Primary;
            inputCategories = [#Territorial, #Cognitive];
            outputCategories = [#Territorial, #Cognitive];
            scalesAffected = [#Circuit, #Regional];
            importance = 0.9;
          },
          {
            name = "Pod Communication";
            description = "Coordinate with other organisms through clicks";
            responsibilityType = #Secondary;
            inputCategories = [#Social, #Animal];
            outputCategories = [#Social, #Cognitive];
            scalesAffected = [#Regional, #Organism];
            importance = 0.75;
          }
        ];
        scalesCovered = [#Neural, #Circuit, #Regional, #Organism];
        connectedEngines = ["OrcaPodEngine", "SpatialCognition", "WorldModelSystem"];
      },

      {
        engineName = "ElephantMemory";
        modulePath = "src/swarm_brain/modules/ElephantMemory.mo";
        primaryCategory = #Animal;
        secondaryCategories = [#Cognitive, #Temporal, #Social];
        responsibilities = [
          {
            name = "Long-Term Memory Storage";
            description = "Store and retrieve episodic memories across sessions";
            responsibilityType = #Primary;
            inputCategories = [#Cognitive, #Temporal];
            outputCategories = [#Cognitive, #Temporal];
            scalesAffected = [#Synaptic, #Circuit];
            importance = 0.95;
          },
          {
            name = "Social Memory";
            description = "Remember relationships and social hierarchies";
            responsibilityType = #Primary;
            inputCategories = [#Social, #Cognitive];
            outputCategories = [#Social, #Governance];
            scalesAffected = [#Regional, #Organism];
            importance = 0.85;
          },
          {
            name = "Emotional Processing";
            description = "Associate memories with emotional valence";
            responsibilityType = #Secondary;
            inputCategories = [#Cognitive, #Neural];
            outputCategories = [#Cognitive, #Social];
            scalesAffected = [#Neural, #Circuit];
            importance = 0.8;
          },
          {
            name = "Spatial Navigation";
            description = "Remember routes and locations across territories";
            responsibilityType = #Secondary;
            inputCategories = [#Territorial, #Cognitive];
            outputCategories = [#Territorial, #Physical];
            scalesAffected = [#Circuit, #Regional];
            importance = 0.75;
          }
        ];
        scalesCovered = [#Synaptic, #Neural, #Circuit, #Regional, #Organism];
        connectedEngines = ["HippocampalReplayEngine", "ElephantDeepTimeEngine", "EpisodicMemory", "CrowCognition"];
      },

      {
        engineName = "WolfPackProtocol";
        modulePath = "src/swarm_brain/modules/WolfPackProtocol.mo";
        primaryCategory = #Animal;
        secondaryCategories = [#Social, #Defense, #Territorial];
        responsibilities = [
          {
            name = "Pack Coordination";
            description = "Coordinate multi-agent hunting and patrol behavior";
            responsibilityType = #Primary;
            inputCategories = [#Social, #Animal];
            outputCategories = [#Social, #Physical];
            scalesAffected = [#Regional, #Organism];
            importance = 0.9;
          },
          {
            name = "Hunting Strategy";
            description = "Execute coordinated pursuit and capture tactics";
            responsibilityType = #Primary;
            inputCategories = [#Defense, #Territorial];
            outputCategories = [#Defense, #Physical];
            scalesAffected = [#Regional, #Ecosystem];
            importance = 0.85;
          },
          {
            name = "Social Hierarchy";
            description = "Maintain alpha/beta/omega structure";
            responsibilityType = #Secondary;
            inputCategories = [#Social, #Governance];
            outputCategories = [#Governance, #Social];
            scalesAffected = [#Regional, #Organism];
            importance = 0.75;
          },
          {
            name = "Territory Defense";
            description = "Patrol and protect territory boundaries";
            responsibilityType = #Secondary;
            inputCategories = [#Territorial, #Defense];
            outputCategories = [#Territorial, #Defense];
            scalesAffected = [#Regional, #Ecosystem];
            importance = 0.8;
          }
        ];
        scalesCovered = [#Regional, #Organism, #Ecosystem];
        connectedEngines = ["BeeHiveMindEngine", "OrcaPodEngine", "TerritoryEngine", "VAELCompleteDefense"];
      },

      // ═══════════════════════════════════════════════════════════════════════════════
      // NEURAL ENGINES
      // ═══════════════════════════════════════════════════════════════════════════════

      {
        engineName = "KuramotoEngine";
        modulePath = "src/swarm_brain/modules/KuramotoEngine.mo";
        primaryCategory = #Neural;
        secondaryCategories = [#Cognitive, #Quantum, #Temporal];
        responsibilities = [
          {
            name = "Neural Synchronization";
            description = "Synchronize oscillator phases across the organism";
            responsibilityType = #Primary;
            inputCategories = [#Neural, #Quantum];
            outputCategories = [#Neural, #Cognitive];
            scalesAffected = [#Neural, #Circuit, #Organism];
            importance = 0.95;
          },
          {
            name = "Order Parameter Computation";
            description = "Compute r value representing global coherence";
            responsibilityType = #Primary;
            inputCategories = [#Neural, #Cognitive];
            outputCategories = [#Cognitive, #Governance];
            scalesAffected = [#Neural, #Organism];
            importance = 0.9;
          },
          {
            name = "Pattern Emergence";
            description = "Detect emergent patterns from synchronized activity";
            responsibilityType = #Secondary;
            inputCategories = [#Neural, #Cognitive];
            outputCategories = [#Cognitive, #Creative];
            scalesAffected = [#Circuit, #Regional];
            importance = 0.85;
          },
          {
            name = "Temporal Binding";
            description = "Bind events across time through phase alignment";
            responsibilityType = #Secondary;
            inputCategories = [#Temporal, #Neural];
            outputCategories = [#Temporal, #Cognitive];
            scalesAffected = [#Neural, #Circuit];
            importance = 0.8;
          }
        ];
        scalesCovered = [#Neural, #Circuit, #Regional, #Organism];
        connectedEngines = ["HebbianPlasticity", "FristonEngine", "BeeHiveMindEngine", "AttentionSchemaEngine"];
      },

      {
        engineName = "HebbianPlasticity";
        modulePath = "src/swarm_brain/modules/HebbianPlasticity.mo";
        primaryCategory = #Neural;
        secondaryCategories = [#Cognitive, #Temporal, #Governance];
        responsibilities = [
          {
            name = "Synaptic Weight Update";
            description = "Update connection weights based on co-activation";
            responsibilityType = #Primary;
            inputCategories = [#Neural, #Cognitive];
            outputCategories = [#Neural, #Cognitive];
            scalesAffected = [#Synaptic, #Neural];
            importance = 0.95;
          },
          {
            name = "Long-Term Potentiation";
            description = "Strengthen frequently-used connections";
            responsibilityType = #Primary;
            inputCategories = [#Neural, #Temporal];
            outputCategories = [#Neural, #Cognitive];
            scalesAffected = [#Synaptic, #Circuit];
            importance = 0.9;
          },
          {
            name = "Memory Consolidation";
            description = "Transfer learning from HER to HIM backend";
            responsibilityType = #Secondary;
            inputCategories = [#Cognitive, #Temporal];
            outputCategories = [#Cognitive, #Governance];
            scalesAffected = [#Circuit, #Organism];
            importance = 0.85;
          },
          {
            name = "Weight Decay";
            description = "Prune unused connections for efficiency";
            responsibilityType = #Secondary;
            inputCategories = [#Neural, #Governance];
            outputCategories = [#Neural, #Economic];
            scalesAffected = [#Synaptic, #Neural];
            importance = 0.7;
          }
        ];
        scalesCovered = [#Synaptic, #Neural, #Circuit, #Organism];
        connectedEngines = ["KuramotoEngine", "ElephantMemory", "MedinaSovereignAGI", "NeuroplasticityEngine"];
      },

      // ═══════════════════════════════════════════════════════════════════════════════
      // ECONOMIC ENGINES
      // ═══════════════════════════════════════════════════════════════════════════════

      {
        engineName = "FORMATokenEconomics";
        modulePath = "src/swarm_brain/modules/FORMATokenEconomics.mo";
        primaryCategory = #Economic;
        secondaryCategories = [#Governance, #Territorial, #Social];
        responsibilities = [
          {
            name = "Metabolic Regulation";
            description = "Control FORMA flow as organism's metabolism";
            responsibilityType = #Primary;
            inputCategories = [#Economic, #Governance];
            outputCategories = [#Economic, #Territorial];
            scalesAffected = [#Regional, #Organism, #Ecosystem];
            importance = 0.95;
          },
          {
            name = "Governance Voting";
            description = "Weight votes by FORMA holdings for decisions";
            responsibilityType = #Primary;
            inputCategories = [#Governance, #Social];
            outputCategories = [#Governance, #Social];
            scalesAffected = [#Organism, #Ecosystem];
            importance = 0.9;
          },
          {
            name = "Resource Distribution";
            description = "Distribute resources across biomes and drones";
            responsibilityType = #Secondary;
            inputCategories = [#Economic, #Territorial];
            outputCategories = [#Territorial, #Physical];
            scalesAffected = [#Regional, #Ecosystem];
            importance = 0.85;
          },
          {
            name = "Incentive Alignment";
            description = "Align individual and collective incentives";
            responsibilityType = #Secondary;
            inputCategories = [#Social, #Governance];
            outputCategories = [#Social, #Economic];
            scalesAffected = [#Regional, #Organism];
            importance = 0.8;
          }
        ];
        scalesCovered = [#Regional, #Organism, #Ecosystem];
        connectedEngines = ["MedinaSphericalWeb", "InsurancePool", "CreatorReserveLedger", "SovereignMetals"];
      },

      // ═══════════════════════════════════════════════════════════════════════════════
      // DEFENSE ENGINES
      // ═══════════════════════════════════════════════════════════════════════════════

      {
        engineName = "VAELCompleteDefense";
        modulePath = "src/swarm_brain/modules/VAELCompleteDefense.mo";
        primaryCategory = #Defense;
        secondaryCategories = [#Governance, #Territorial, #Cognitive];
        responsibilities = [
          {
            name = "Threat Detection";
            description = "Identify and classify threats to the organism";
            responsibilityType = #Primary;
            inputCategories = [#Defense, #Cognitive];
            outputCategories = [#Defense, #Governance];
            scalesAffected = [#Regional, #Organism];
            importance = 0.95;
          },
          {
            name = "Defense Coordination";
            description = "Coordinate multi-layered defense response";
            responsibilityType = #Primary;
            inputCategories = [#Defense, #Social];
            outputCategories = [#Defense, #Physical];
            scalesAffected = [#Regional, #Organism, #Ecosystem];
            importance = 0.9;
          },
          {
            name = "Immune Response";
            description = "Neutralize internal threats and corruption";
            responsibilityType = #Secondary;
            inputCategories = [#Defense, #Neural];
            outputCategories = [#Defense, #Governance];
            scalesAffected = [#Circuit, #Regional];
            importance = 0.85;
          },
          {
            name = "Deterrence Signaling";
            description = "Signal strength to potential adversaries";
            responsibilityType = #Secondary;
            inputCategories = [#Defense, #Social];
            outputCategories = [#Social, #Territorial];
            scalesAffected = [#Organism, #Ecosystem];
            importance = 0.75;
          }
        ];
        scalesCovered = [#Circuit, #Regional, #Organism, #Ecosystem];
        connectedEngines = ["AEGIS", "WolfPackProtocol", "VetusThreatSystem", "AutonomousWarEngine"];
      },

      // ═══════════════════════════════════════════════════════════════════════════════
      // TEMPORAL ENGINES
      // ═══════════════════════════════════════════════════════════════════════════════

      {
        engineName = "HippocampalReplayEngine";
        modulePath = "src/swarm_brain/modules/HippocampalReplayEngine.mo";
        primaryCategory = #Temporal;
        secondaryCategories = [#Cognitive, #Neural, #Creative];
        responsibilities = [
          {
            name = "Memory Replay";
            description = "Replay episodic memories for consolidation";
            responsibilityType = #Primary;
            inputCategories = [#Cognitive, #Temporal];
            outputCategories = [#Cognitive, #Neural];
            scalesAffected = [#Neural, #Circuit];
            importance = 0.9;
          },
          {
            name = "Sequence Compression";
            description = "Compress long sequences into short bursts";
            responsibilityType = #Primary;
            inputCategories = [#Temporal, #Cognitive];
            outputCategories = [#Cognitive, #Neural];
            scalesAffected = [#Neural, #Circuit];
            importance = 0.85;
          },
          {
            name = "Future Simulation";
            description = "Simulate possible futures using past patterns";
            responsibilityType = #Secondary;
            inputCategories = [#Temporal, #Creative];
            outputCategories = [#Creative, #Cognitive];
            scalesAffected = [#Circuit, #Regional];
            importance = 0.8;
          },
          {
            name = "Sleep-Wake Integration";
            description = "Coordinate with dream cycles for processing";
            responsibilityType = #Secondary;
            inputCategories = [#Temporal, #Neural];
            outputCategories = [#Neural, #Creative];
            scalesAffected = [#Organism];
            importance = 0.75;
          }
        ];
        scalesCovered = [#Neural, #Circuit, #Regional, #Organism];
        connectedEngines = ["ElephantMemory", "JubileeDreamCycle", "DreamVideoGenerator", "MedinaSharpWaveRipples"];
      }
    ]
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // VALIDATION FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Validate that an engine meets minimum responsibility requirements
  public func validateEngine(engine : EngineDefinition) : EngineValidationResult {
    let errors = Buffer.Buffer<Text>(5);

    // Check minimum responsibilities
    if (engine.responsibilities.size() < MIN_RESPONSIBILITIES) {
      errors.add("Engine '" # engine.engineName # "' has only " # Nat.toText(engine.responsibilities.size()) # " responsibilities (minimum: " # Nat.toText(MIN_RESPONSIBILITIES) # ")");
    };

    // Check category connections
    let totalCategories = 1 + engine.secondaryCategories.size();
    if (totalCategories < MIN_CATEGORY_CONNECTIONS) {
      errors.add("Engine '" # engine.engineName # "' has only " # Nat.toText(totalCategories) # " category connections (minimum: " # Nat.toText(MIN_CATEGORY_CONNECTIONS) # ")");
    };

    // Check scale coverage
    if (engine.scalesCovered.size() < MIN_SCALE_COVERAGE) {
      errors.add("Engine '" # engine.engineName # "' covers only " # Nat.toText(engine.scalesCovered.size()) # " scales (minimum: " # Nat.toText(MIN_SCALE_COVERAGE) # ")");
    };

    // Check connected engines
    if (engine.connectedEngines.size() < 3) {
      errors.add("Engine '" # engine.engineName # "' has only " # Nat.toText(engine.connectedEngines.size()) # " connected engines (minimum: 3)");
    };

    let isValid = errors.size() == 0;
    let score = computeEngineScore(engine);

    {
      engineName = engine.engineName;
      isValid = isValid;
      score = score;
      errors = Buffer.toArray(errors);
      responsibilityCount = engine.responsibilities.size();
      categoryCount = totalCategories;
      scaleCount = engine.scalesCovered.size();
      connectionCount = engine.connectedEngines.size();
    }
  };

  public type EngineValidationResult = {
    engineName : Text;
    isValid : Bool;
    score : Float;
    errors : [Text];
    responsibilityCount : Nat;
    categoryCount : Nat;
    scaleCount : Nat;
    connectionCount : Nat;
  };

  /// Compute a score for how well an engine is intertwined
  func computeEngineScore(engine : EngineDefinition) : Float {
    let respScore = Float.fromInt(engine.responsibilities.size()) / 5.0;  // Normalize to 5 max
    let catScore = Float.fromInt(1 + engine.secondaryCategories.size()) / 5.0;
    let scaleScore = Float.fromInt(engine.scalesCovered.size()) / 7.0;
    let connScore = Float.fromInt(engine.connectedEngines.size()) / 10.0;

    // Golden-weighted average
    (respScore * phi + catScore * phi + scaleScore + connScore) / (φ + phi + 1.0 + 1.0)
  };

  /// Validate all engines in the responsibility matrix
  public func validateAllEngines() : MatrixValidationResult {
    let matrix = getResponsibilityMatrix();
    let results = Buffer.Buffer<EngineValidationResult>(matrix.size());
    var totalScore : Float = 0.0;
    var validCount : Nat = 0;

    for (engine in matrix.vals()) {
      let result = validateEngine(engine);
      results.add(result);
      totalScore += result.score;
      if (result.isValid) { validCount += 1 };
    };

    let avgScore = totalScore / Float.fromInt(matrix.size());

    {
      totalEngines = matrix.size();
      validEngines = validCount;
      invalidEngines = matrix.size() - validCount;
      averageScore = avgScore;
      results = Buffer.toArray(results);
    }
  };

  public type MatrixValidationResult = {
    totalEngines : Nat;
    validEngines : Nat;
    invalidEngines : Nat;
    averageScore : Float;
    results : [EngineValidationResult];
  };

}
