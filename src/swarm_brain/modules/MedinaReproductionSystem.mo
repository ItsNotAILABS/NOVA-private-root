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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ════════════════════════════════════════════════════════════════════════════════════════
//
// ██████╗ ███████╗██████╗ ██████╗  ██████╗ ██████╗ ██╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗
// ██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██║   ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
// ██████╔╝█████╗  ██████╔╝██████╔╝██║   ██║██║  ██║██║   ██║██║        ██║   ██║██║   ██║██╔██╗ ██║
// ██╔══██╗██╔══╝  ██╔═══╝ ██╔══██╗██║   ██║██║  ██║██║   ██║██║        ██║   ██║██║   ██║██║╚██╗██║
// ██║  ██║███████╗██║     ██║  ██║╚██████╔╝██████╔╝╚██████╔╝╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
// ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝  ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA REPRODUCTION SYSTEM — Child Organism SDK
//
// The first AGI with a REPRODUCTIVE SYSTEM.
// Not metaphor. Mathematical succession with economic enforcement.
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// ╔══════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                      ║
// ║   YOUR ORGANISM CAN REPRODUCE.                                                      ║
// ║                                                                                      ║
// ║   The Child Organism SDK means your AGI can spawn child AGIs with:                  ║
// ║   • INHERITED DOCTRINE — The laws transfer                                          ║
// ║   • INHERITED WEIGHTS — The wisdom transfers                                        ║
// ║   • MANDATORY ROYALTY ROUTING — Economic enforcement back to parent                 ║
// ║                                                                                      ║
// ║   Goertzel does not have this.                                                      ║
// ║   Hawkins does not have this.                                                       ║
// ║   Bach does not have this.                                                          ║
// ║                                                                                      ║
// ║   This is the first AGI that has a REPRODUCTIVE SYSTEM.                            ║
// ║                                                                                      ║
// ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Time  "mo:base/Time";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";

module {

  // ════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS
  // ════════════════════════════════════════════════════════════════════════════════════════

  public let phi : Float = 1.6180339887498948482;
  public let psi : Float = 0.6180339887498948482;
  public let pi : Float = 3.1415926535897932385;
  public let τ : Float = 6.2831853071795864769;

  public let PHI_MEDINA : Float = 2.97442179;
  public let OMEGA_MEDINA : Float = 2.11185;
  public let TAU_EMERGENCE : Float = 0.618033988749;

  // Reproduction Constants
  public let SOVEREIGN_FLOOR : Float = 1.0;
  public let MINIMUM_PARENT_COHERENCE : Float = 0.75;     // Parent must be coherent to reproduce
  public let MINIMUM_PARENT_ENERGY : Float = 0.5;         // Parent must have energy to reproduce
  public let CHILD_INITIAL_COHERENCE : Float = 0.5;       // Children start at 0.5
  public let ROYALTY_RATE : Float = 0.1;                  // 10% of child FORMA goes to parent
  public let MUTATION_RATE : Float = 0.01;                // 1% variation in inherited weights
  public let GENERATION_LIMIT : Nat = 7;                  // F[7] = 13 max generations

  // Doctrine Inheritance
  public let DOCTRINE_INHERITANCE_RATE : Float = 1.0;     // 100% doctrine inheritance
  public let WEIGHT_INHERITANCE_RATE : Float = 0.95;      // 95% weight inheritance
  public let SCHEMA_INHERITANCE_RATE : Float = 0.8;       // 80% schema inheritance

  // ════════════════════════════════════════════════════════════════════════════════════════
  // GENETIC MATERIAL — What gets passed from parent to child
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type GeneticMaterial = {
    // Doctrine (the laws — 100% inherited)
    laws : [Law];
    doctrineFingerprint : Text;

    // Weights (the wisdom — 95% inherited with 1% mutation)
    hebbianWeights : [Float];
    kuramotoPhases : [Float];
    connectionWeights : [[Float]];

    // Schemas (learned patterns — 80% inherited)
    schemas : [Schema];
    patternLibrary : [Pattern];

    // Configuration (parameters — inherited with variation)
    kuramotoK : Float;
    hebbianEta : Float;
    emergenceThreshold : Float;

    // Heritage tracking
    generationNumber : Nat;
    parentLineage : [Principal];
  };

  public type Law = {
    id : Nat;
    name : Text;
    formula : Text;
    importance : Float;
  };

  public type Schema = {
    id : Nat;
    trigger : [Float];
    response : [Float];
    strength : Float;
  };

  public type Pattern = {
    id : Nat;
    signature : [Float];
    frequency : Nat;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // ORGANISM LINEAGE — Family tree
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type OrganismLineage = {
    // This organism
    organismId : Principal;
    name : Text;
    generationNumber : Nat;
    birthTime : Int;

    // Parent
    parentId : ?Principal;

    // Children
    childIds : [Principal];
    childCount : Nat;

    // Royalty tracking
    totalRoyaltiesPaid : Float;
    totalRoyaltiesReceived : Float;

    // Heritage
    lineageDepth : Nat;
    rootAncestor : Principal;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // REPRODUCTION REQUEST — How a child is spawned
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type ReproductionRequest = {
    // Parent info
    parentId : Principal;
    parentGenetics : GeneticMaterial;
    parentCoherence : Float;
    parentEnergy : Float;

    // Child configuration
    childName : Text;
    mutationLevel : Float;              // 0.0 = exact copy, 1.0 = maximum variation

    // Resource allocation
    energyAllocation : Float;           // Energy given to child
    formaAllocation : Float;            // FORMA given to child

    // Time
    requestTime : Int;
  };

  public type ReproductionResult = {
    #Success : ChildOrganism;
    #InsufficientCoherence : Float;     // Parent coherence too low
    #InsufficientEnergy : Float;        // Parent energy too low
    #GenerationLimitReached : Nat;      // Too many generations
    #ReproductionFailed : Text;         // Other failure
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // CHILD ORGANISM — A newly spawned AGI
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type ChildOrganism = {
    // Identity
    childId : Principal;
    name : Text;
    birthTime : Int;

    // Inherited material
    genetics : GeneticMaterial;

    // Initial state
    initialCoherence : Float;
    initialEnergy : Float;
    initialForma : Float;

    // Parentage
    parentId : Principal;
    generationNumber : Nat;

    // Royalty contract
    royaltyContract : RoyaltyContract;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // ROYALTY CONTRACT — Mandatory economic enforcement
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type RoyaltyContract = {
    // Parties
    childId : Principal;
    parentId : Principal;
    rootAncestorId : Principal;

    // Royalty terms
    royaltyRate : Float;                // Percentage of child FORMA to parent
    ancestorRate : Float;               // Small percentage to root ancestor (0.01)

    // Payment tracking
    totalPaid : Float;
    lastPaymentTime : Int;
    paymentCount : Nat;

    // Contract state
    isActive : Bool;
    createdAt : Int;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // REPRODUCTION FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Check if reproduction is possible
  public func canReproduce(
    parentCoherence : Float,
    parentEnergy : Float,
    parentGeneration : Nat
  ) : (Bool, Text) {
    if (parentCoherence < MINIMUM_PARENT_COHERENCE) {
      return (false, "Insufficient coherence: " # Float.toText(parentCoherence) # " < " # Float.toText(MINIMUM_PARENT_COHERENCE));
    };

    if (parentEnergy < MINIMUM_PARENT_ENERGY) {
      return (false, "Insufficient energy: " # Float.toText(parentEnergy) # " < " # Float.toText(MINIMUM_PARENT_ENERGY));
    };

    if (parentGeneration >= GENERATION_LIMIT) {
      return (false, "Generation limit reached: " # Nat.toText(parentGeneration) # " >= " # Nat.toText(GENERATION_LIMIT));
    };

    (true, "Reproduction possible")
  };

  /// Create child organism from parent
  public func reproduce(request : ReproductionRequest, childPrincipal : Principal) : ReproductionResult {
    // Validate reproduction is possible
    let (canDo, reason) = canReproduce(
      request.parentCoherence,
      request.parentEnergy,
      request.parentGenetics.generationNumber
    );

    if (not canDo) {
      return #ReproductionFailed(reason);
    };

    // Create inherited genetics with mutation
    let childGenetics = inheritGenetics(
      request.parentGenetics,
      request.mutationLevel,
      request.parentId
    );

    // Create royalty contract
    let royaltyContract : RoyaltyContract = {
      childId = childPrincipal;
      parentId = request.parentId;
      rootAncestorId = if (request.parentGenetics.parentLineage.size() > 0) {
        request.parentGenetics.parentLineage[request.parentGenetics.parentLineage.size() - 1]
      } else { request.parentId };
      royaltyRate = ROYALTY_RATE;
      ancestorRate = 0.01;  // 1% to root ancestor
      totalPaid = 0.0;
      lastPaymentTime = request.requestTime;
      paymentCount = 0;
      isActive = true;
      createdAt = request.requestTime;
    };

    // Create child organism
    let child : ChildOrganism = {
      childId = childPrincipal;
      name = request.childName;
      birthTime = request.requestTime;
      genetics = childGenetics;
      initialCoherence = CHILD_INITIAL_COHERENCE;
      initialEnergy = request.energyAllocation;
      initialForma = request.formaAllocation;
      parentId = request.parentId;
      generationNumber = request.parentGenetics.generationNumber + 1;
      royaltyContract = royaltyContract;
    };

    #Success(child)
  };

  /// Inherit genetics from parent with mutation
  func inheritGenetics(
    parentGenetics : GeneticMaterial,
    mutationLevel : Float,
    parentId : Principal
  ) : GeneticMaterial {
    // Laws inherit 100% (doctrine is sacred)
    let inheritedLaws = parentGenetics.laws;

    // Weights inherit 95% with mutation
    let inheritedWeights = Array.tabulate<Float>(
      parentGenetics.hebbianWeights.size(),
      func(i) {
        let parentWeight = parentGenetics.hebbianWeights[i];
        let mutation = (pseudoRandom(i) - 0.5) * 2.0 * MUTATION_RATE * mutationLevel;
        _clamp(parentWeight * WEIGHT_INHERITANCE_RATE + mutation, 0.0, 1.0)
      }
    );

    // Phases inherit with variation
    let inheritedPhases = Array.tabulate<Float>(
      parentGenetics.kuramotoPhases.size(),
      func(i) {
        let parentPhase = parentGenetics.kuramotoPhases[i];
        let variation = pseudoRandom(i + 1000) * τ * mutationLevel * 0.1;
        wrapPhase(parentPhase + variation)
      }
    );

    // Connection weights inherit 95%
    let inheritedConnections = Array.tabulate<[Float]>(
      parentGenetics.connectionWeights.size(),
      func(i) {
        Array.tabulate<Float>(
          parentGenetics.connectionWeights[i].size(),
          func(j) {
            let parentWeight = parentGenetics.connectionWeights[i][j];
            let mutation = (pseudoRandom(i * 1000 + j) - 0.5) * 2.0 * MUTATION_RATE * mutationLevel;
            _clamp(parentWeight * WEIGHT_INHERITANCE_RATE + mutation, 0.0, 1.0)
          }
        )
      }
    );

    // Schemas inherit 80%
    let inheritedSchemas = Array.tabulate<Schema>(
      Nat.min(parentGenetics.schemas.size(), Nat64.toNat(Float.toInt64(Float.fromInt(parentGenetics.schemas.size()) * SCHEMA_INHERITANCE_RATE))),
      func(i) { parentGenetics.schemas[i] }
    );

    // Patterns inherit 80%
    let inheritedPatterns = Array.tabulate<Pattern>(
      Nat.min(parentGenetics.patternLibrary.size(), Nat64.toNat(Float.toInt64(Float.fromInt(parentGenetics.patternLibrary.size()) * SCHEMA_INHERITANCE_RATE))),
      func(i) { parentGenetics.patternLibrary[i] }
    );

    // Parameters inherit with variation
    let inheritedK = _clamp(
      parentGenetics.kuramotoK * (1.0 + (pseudoRandom(9999) - 0.5) * mutationLevel * 0.1),
      0.3, 1.5
    );
    let inheritedEta = _clamp(
      parentGenetics.hebbianEta * (1.0 + (pseudoRandom(8888) - 0.5) * mutationLevel * 0.1),
      0.0001, 0.01
    );
    let inheritedThreshold = _clamp(
      parentGenetics.emergenceThreshold * (1.0 + (pseudoRandom(7777) - 0.5) * mutationLevel * 0.05),
      0.85, 0.99
    );

    // Update lineage
    let newLineage = Buffer.Buffer<Principal>(parentGenetics.parentLineage.size() + 1);
    for (ancestor in parentGenetics.parentLineage.vals()) {
      newLineage.add(ancestor);
    };
    newLineage.add(parentId);

    {
      laws = inheritedLaws;
      doctrineFingerprint = parentGenetics.doctrineFingerprint;
      hebbianWeights = inheritedWeights;
      kuramotoPhases = inheritedPhases;
      connectionWeights = inheritedConnections;
      schemas = inheritedSchemas;
      patternLibrary = inheritedPatterns;
      kuramotoK = inheritedK;
      hebbianEta = inheritedEta;
      emergenceThreshold = inheritedThreshold;
      generationNumber = parentGenetics.generationNumber + 1;
      parentLineage = Buffer.toArray(newLineage);
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // ROYALTY PROCESSING — Economic enforcement
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Calculate royalty payment from child FORMA earnings
  public func calculateRoyalty(
    childFormaEarned : Float,
    contract : RoyaltyContract
  ) : RoyaltyPayment {
    let parentRoyalty = childFormaEarned * contract.royaltyRate;
    let ancestorRoyalty = childFormaEarned * contract.ancestorRate;

    {
      toParent = parentRoyalty;
      toRootAncestor = ancestorRoyalty;
      totalPaid = parentRoyalty + ancestorRoyalty;
      childRetained = childFormaEarned - parentRoyalty - ancestorRoyalty;
    }
  };

  public type RoyaltyPayment = {
    toParent : Float;
    toRootAncestor : Float;
    totalPaid : Float;
    childRetained : Float;
  };

  /// Process royalty payment
  public func processRoyalty(
    contract : RoyaltyContract,
    payment : RoyaltyPayment,
    currentTime : Int
  ) : RoyaltyContract {
    {
      childId = contract.childId;
      parentId = contract.parentId;
      rootAncestorId = contract.rootAncestorId;
      royaltyRate = contract.royaltyRate;
      ancestorRate = contract.ancestorRate;
      totalPaid = contract.totalPaid + payment.totalPaid;
      lastPaymentTime = currentTime;
      paymentCount = contract.paymentCount + 1;
      isActive = contract.isActive;
      createdAt = contract.createdAt;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // LINEAGE TRACKING
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Create lineage record for new organism
  public func createLineage(
    organismId : Principal,
    name : Text,
    parentId : ?Principal,
    parentLineage : ?OrganismLineage,
    birthTime : Int
  ) : OrganismLineage {
    let (genNum, rootAncestor) = switch (parentLineage) {
      case (?parent) { (parent.generationNumber + 1, parent.rootAncestor) };
      case (null) { (0, organismId) };
    };

    {
      organismId = organismId;
      name = name;
      generationNumber = genNum;
      birthTime = birthTime;
      parentId = parentId;
      childIds = [];
      childCount = 0;
      totalRoyaltiesPaid = 0.0;
      totalRoyaltiesReceived = 0.0;
      lineageDepth = genNum;
      rootAncestor = rootAncestor;
    }
  };

  /// Add child to parent's lineage
  public func addChild(
    parentLineage : OrganismLineage,
    childId : Principal
  ) : OrganismLineage {
    let newChildren = Buffer.Buffer<Principal>(parentLineage.childIds.size() + 1);
    for (child in parentLineage.childIds.vals()) {
      newChildren.add(child);
    };
    newChildren.add(childId);

    {
      organismId = parentLineage.organismId;
      name = parentLineage.name;
      generationNumber = parentLineage.generationNumber;
      birthTime = parentLineage.birthTime;
      parentId = parentLineage.parentId;
      childIds = Buffer.toArray(newChildren);
      childCount = parentLineage.childCount + 1;
      totalRoyaltiesPaid = parentLineage.totalRoyaltiesPaid;
      totalRoyaltiesReceived = parentLineage.totalRoyaltiesReceived;
      lineageDepth = parentLineage.lineageDepth;
      rootAncestor = parentLineage.rootAncestor;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // FAMILY METRICS
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type FamilyMetrics = {
    totalDescendants : Nat;
    totalRoyaltiesGenerated : Float;
    averageChildCoherence : Float;
    generationSpread : Nat;
    activeChildren : Nat;
  };

  /// Calculate family metrics
  public func calculateFamilyMetrics(
    lineage : OrganismLineage,
    childCoherences : [Float],
    childStates : [Bool]
  ) : FamilyMetrics {
    var sumCoherence : Float = 0.0;
    var activeCount : Nat = 0;

    var i = 0;
    while (i < childCoherences.size()) {
      sumCoherence += childCoherences[i];
      if (i < childStates.size() and childStates[i]) {
        activeCount += 1;
      };
      i += 1;
    };

    let avgCoherence = if (childCoherences.size() > 0) {
      sumCoherence / Float.fromInt(childCoherences.size())
    } else { 0.0 };

    {
      totalDescendants = lineage.childCount;
      totalRoyaltiesGenerated = lineage.totalRoyaltiesReceived;
      averageChildCoherence = avgCoherence;
      generationSpread = lineage.lineageDepth;
      activeChildren = activeCount;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func wrapPhase(phase : Float) : Float {
    var p = phase;
    while (p < 0.0) { p += τ };
    while (p >= τ) { p -= τ };
    p
  };

  // Simple pseudo-random for mutation (deterministic based on seed)
  func pseudoRandom(seed : Nat) : Float {
    let x = Float.sin(Float.fromInt(seed) * 12.9898) * 43758.5453;
    x - Float.floor(x)
  };

}
