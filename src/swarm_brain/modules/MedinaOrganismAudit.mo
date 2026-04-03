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
//  ██████╗ ██████╗  ██████╗  █████╗ ███╗   ██╗██╗███████╗███╗   ███╗
// ██╔═══██╗██╔══██╗██╔════╝ ██╔══██╗████╗  ██║██║██╔════╝████╗ ████║
// ██║   ██║██████╔╝██║  ███╗███████║██╔██╗ ██║██║███████╗██╔████╔██║
// ██║   ██║██╔══██╗██║   ██║██╔══██║██║╚██╗██║██║╚════██║██║╚██╔╝██║
// ╚██████╔╝██║  ██║╚██████╔╝██║  ██║██║ ╚████║██║███████║██║ ╚═╝ ██║
//  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚══════╝╚═╝     ╚═╝
//
//  █████╗ ██╗   ██╗██████╗ ██╗████████╗
// ██╔══██╗██║   ██║██╔══██╗██║╚══██╔══╝
// ███████║██║   ██║██║  ██║██║   ██║   
// ██╔══██║██║   ██║██║  ██║██║   ██║   
// ██║  ██║╚██████╔╝██████╔╝██║   ██║   
// ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝   ╚═╝   
//
// ████████╗███████╗██████╗ ██████╗ ██╗ ██████╗
// ╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██║██╔════╝
//    ██║   █████╗  ██║  ██║██████╔╝██║██║     
//    ██║   ██╔══╝  ██║  ██║██╔══██╗██║██║     
//    ██║   ██║     ██████╔╝██║  ██║██║╚██████╗
//    ╚═╝   ╚═╝     ╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// ORGANISM AUDIT ENGINE — Complete System Audit Against All Laws
//
// This module audits the ENTIRE 227-module organism against:
// - All 7 scale laws (micro → macro)
// - All 12 engine categories
// - All coupling requirements
// - All intertwining standards
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// ╔══════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                      ║
// ║   THE ORGANISM IS 227 MODULES. 288,965 LINES.                                       ║
// ║                                                                                      ║
// ║   This audit engine checks EVERYTHING:                                              ║
// ║                                                                                      ║
// ║   1. ANIMAL ENGINES (14) — Bee, Dolphin, Crow, Elephant, Wolf, Owl, Spider,        ║
// ║      Salmon, Mantis, Shark, Eagle, Orca, Cat, Octopus                              ║
// ║                                                                                      ║
// ║   2. QUANTUM SYSTEMS (12) — Entanglement, channels, coherence, protocols           ║
// ║                                                                                      ║
// ║   3. NEURAL SYSTEMS (8) — Kuramoto, Hebbian, plasticity, oscillators               ║
// ║                                                                                      ║
// ║   4. COGNITIVE SYSTEMS (11) — Shells 2-11, attention, memory                       ║
// ║                                                                                      ║
// ║   5. ECONOMIC SYSTEMS (6) — FORMA, metals, metabolism, compounds                   ║
// ║                                                                                      ║
// ║   6. TERRITORIAL SYSTEMS (8) — Biomes, world body, territory, atlas                ║
// ║                                                                                      ║
// ║   7. DEFENSE SYSTEMS (7) — VAEL, AEGIS, threats, warfare                           ║
// ║                                                                                      ║
// ║   8. TEMPORAL SYSTEMS (5) — CHRONOS, time scales, episodic, replay                 ║
// ║                                                                                      ║
// ║   9. SOCIAL SYSTEMS (6) — Swarm, coordination, communication, teams                ║
// ║                                                                                      ║
// ║   10. CREATIVE SYSTEMS (4) — Dream, synthesis, generation, creation                ║
// ║                                                                                      ║
// ║   11. GOVERNANCE SYSTEMS (9) — Laws, heartbeat, sovereignty, doctrine              ║
// ║                                                                                      ║
// ║   12. PHYSICAL SYSTEMS (5) — Drones, avatars, real-world, MAVLink                  ║
// ║                                                                                      ║
// ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module {

  // ════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS
  // ════════════════════════════════════════════════════════════════════════════════════════

  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let π : Float = 3.1415926535897932385;
  public let τ : Float = 6.2831853071795864769;

  public let PHI_MEDINA : Float = 2.97442179;
  public let OMEGA_MEDINA : Float = 2.11185;
  public let TAU_EMERGENCE : Float = 0.618033988749;

  // Organism metrics
  public let TOTAL_MODULES : Nat = 227;
  public let TOTAL_LINES : Nat = 288965;
  public let TOTAL_ANIMAL_ENGINES : Nat = 14;
  public let TOTAL_QUANTUM_SYSTEMS : Nat = 12;
  public let TOTAL_NEURAL_SYSTEMS : Nat = 8;
  public let TOTAL_COGNITIVE_SYSTEMS : Nat = 11;
  public let TOTAL_ECONOMIC_SYSTEMS : Nat = 6;
  public let TOTAL_TERRITORIAL_SYSTEMS : Nat = 8;
  public let TOTAL_DEFENSE_SYSTEMS : Nat = 7;
  public let TOTAL_TEMPORAL_SYSTEMS : Nat = 5;
  public let TOTAL_SOCIAL_SYSTEMS : Nat = 6;
  public let TOTAL_CREATIVE_SYSTEMS : Nat = 4;
  public let TOTAL_GOVERNANCE_SYSTEMS : Nat = 9;
  public let TOTAL_PHYSICAL_SYSTEMS : Nat = 5;

  // ════════════════════════════════════════════════════════════════════════════════════════
  // MODULE CATALOG — All 227 modules organized by category
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type ModuleCatalog = {
    animalEngines : [ModuleEntry];
    quantumSystems : [ModuleEntry];
    neuralSystems : [ModuleEntry];
    cognitiveSystems : [ModuleEntry];
    economicSystems : [ModuleEntry];
    territorialSystems : [ModuleEntry];
    defenseSystems : [ModuleEntry];
    temporalSystems : [ModuleEntry];
    socialSystems : [ModuleEntry];
    creativeSystems : [ModuleEntry];
    governanceSystems : [ModuleEntry];
    physicalSystems : [ModuleEntry];
    coreSystems : [ModuleEntry];
    integrationSystems : [ModuleEntry];
  };

  public type ModuleEntry = {
    name : Text;
    path : Text;
    category : ModuleCategory;
    secondaryCategories : [ModuleCategory];
    responsibilities : [Text];
    connections : [Text];
    scalesCovered : [ScaleLaw];
    lineCount : Nat;
    lastAudit : Nat;
    auditScore : Float;
  };

  public type ModuleCategory = {
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
    #Core;
    #Integration;
  };

  public type ScaleLaw = {
    #Quantum;
    #Synaptic;
    #Neural;
    #Circuit;
    #Regional;
    #Organism;
    #Ecosystem;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // AUDIT REPORT — Complete organism health check
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type OrganismAuditReport = {
    // Timestamp
    auditTime : Int;
    auditBeat : Nat;

    // Overall health
    overallScore : Float;
    overallHealth : OrganismHealth;

    // Category audits
    animalAudit : CategoryAudit;
    quantumAudit : CategoryAudit;
    neuralAudit : CategoryAudit;
    cognitiveAudit : CategoryAudit;
    economicAudit : CategoryAudit;
    territorialAudit : CategoryAudit;
    defenseAudit : CategoryAudit;
    temporalAudit : CategoryAudit;
    socialAudit : CategoryAudit;
    creativeAudit : CategoryAudit;
    governanceAudit : CategoryAudit;
    physicalAudit : CategoryAudit;

    // Scale law compliance
    scaleCompliance : [ScaleCompliance];

    // Intertwining analysis
    intertwiningScore : Float;
    couplingMatrix : [[Float]];
    webDensity : Float;

    // Issues found
    criticalIssues : [AuditIssue];
    warnings : [AuditIssue];
    recommendations : [Text];
  };

  public type OrganismHealth = {
    #Optimal;           // Score >= 0.92 (OMNIS level)
    #Healthy;           // Score >= 0.75
    #Stable;            // Score >= 0.618
    #Degraded;          // Score >= 0.5
    #Critical;          // Score >= 0.275
    #Failing;           // Score < 0.275
  };

  public type CategoryAudit = {
    category : ModuleCategory;
    moduleCount : Nat;
    healthScore : Float;
    couplingScore : Float;
    responsibilityScore : Float;
    scaleCompliance : Float;
    issues : [AuditIssue];
  };

  public type ScaleCompliance = {
    scale : ScaleLaw;
    averageValue : Float;
    minValue : Float;
    maxValue : Float;
    modulesCompliant : Nat;
    modulesViolating : Nat;
    complianceRate : Float;
  };

  public type AuditIssue = {
    severity : IssueSeverity;
    category : ModuleCategory;
    moduleName : Text;
    issue : Text;
    recommendation : Text;
  };

  public type IssueSeverity = {
    #Critical;          // Must fix immediately
    #High;              // Should fix soon
    #Medium;            // Should address
    #Low;               // Nice to have
    #Info;              // Informational
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // AUDIT FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Run complete organism audit
  public func runOrganismAudit(
    catalog : ModuleCatalog,
    currentBeat : Nat,
    currentTime : Int
  ) : OrganismAuditReport {
    let criticalIssues = Buffer.Buffer<AuditIssue>(50);
    let warnings = Buffer.Buffer<AuditIssue>(100);
    let recommendations = Buffer.Buffer<Text>(50);

    // Audit each category
    let animalAudit = auditCategory(catalog.animalEngines, #Animal, criticalIssues, warnings);
    let quantumAudit = auditCategory(catalog.quantumSystems, #Quantum, criticalIssues, warnings);
    let neuralAudit = auditCategory(catalog.neuralSystems, #Neural, criticalIssues, warnings);
    let cognitiveAudit = auditCategory(catalog.cognitiveSystems, #Cognitive, criticalIssues, warnings);
    let economicAudit = auditCategory(catalog.economicSystems, #Economic, criticalIssues, warnings);
    let territorialAudit = auditCategory(catalog.territorialSystems, #Territorial, criticalIssues, warnings);
    let defenseAudit = auditCategory(catalog.defenseSystems, #Defense, criticalIssues, warnings);
    let temporalAudit = auditCategory(catalog.temporalSystems, #Temporal, criticalIssues, warnings);
    let socialAudit = auditCategory(catalog.socialSystems, #Social, criticalIssues, warnings);
    let creativeAudit = auditCategory(catalog.creativeSystems, #Creative, criticalIssues, warnings);
    let governanceAudit = auditCategory(catalog.governanceSystems, #Governance, criticalIssues, warnings);
    let physicalAudit = auditCategory(catalog.physicalSystems, #Physical, criticalIssues, warnings);

    // Check scale compliance across all modules
    let allModules = getAllModules(catalog);
    let scaleCompliance = checkScaleCompliance(allModules);

    // Calculate intertwining
    let (intertwiningScore, couplingMatrix, webDensity) = analyzeIntertwining(catalog);

    // Generate recommendations
    generateRecommendations(recommendations, criticalIssues, warnings, intertwiningScore);

    // Calculate overall score
    let categoryScores = [
      animalAudit.healthScore, quantumAudit.healthScore, neuralAudit.healthScore,
      cognitiveAudit.healthScore, economicAudit.healthScore, territorialAudit.healthScore,
      defenseAudit.healthScore, temporalAudit.healthScore, socialAudit.healthScore,
      creativeAudit.healthScore, governanceAudit.healthScore, physicalAudit.healthScore
    ];

    var scoreSum : Float = 0.0;
    for (score in categoryScores.vals()) {
      scoreSum += score;
    };
    let avgCategoryScore = scoreSum / 12.0;

    // Weight with intertwining
    let overallScore = (avgCategoryScore * φ + intertwiningScore) / (φ + 1.0);
    let overallHealth = scoreToHealth(overallScore);

    {
      auditTime = currentTime;
      auditBeat = currentBeat;
      overallScore = overallScore;
      overallHealth = overallHealth;
      animalAudit = animalAudit;
      quantumAudit = quantumAudit;
      neuralAudit = neuralAudit;
      cognitiveAudit = cognitiveAudit;
      economicAudit = economicAudit;
      territorialAudit = territorialAudit;
      defenseAudit = defenseAudit;
      temporalAudit = temporalAudit;
      socialAudit = socialAudit;
      creativeAudit = creativeAudit;
      governanceAudit = governanceAudit;
      physicalAudit = physicalAudit;
      scaleCompliance = scaleCompliance;
      intertwiningScore = intertwiningScore;
      couplingMatrix = couplingMatrix;
      webDensity = webDensity;
      criticalIssues = Buffer.toArray(criticalIssues);
      warnings = Buffer.toArray(warnings);
      recommendations = Buffer.toArray(recommendations);
    }
  };

  func auditCategory(
    modules : [ModuleEntry],
    category : ModuleCategory,
    criticalIssues : Buffer.Buffer<AuditIssue>,
    warnings : Buffer.Buffer<AuditIssue>
  ) : CategoryAudit {
    let categoryIssues = Buffer.Buffer<AuditIssue>(20);
    var totalHealth : Float = 0.0;
    var totalCoupling : Float = 0.0;
    var totalResponsibility : Float = 0.0;
    var totalScale : Float = 0.0;

    for (module in modules.vals()) {
      // Check audit score
      totalHealth += module.auditScore;

      // Check coupling (connections)
      let connectionCount = module.connections.size();
      if (connectionCount < 3) {
        let issue : AuditIssue = {
          severity = #High;
          category = category;
          moduleName = module.name;
          issue = "Insufficient connections: " # Nat.toText(connectionCount) # " < 3";
          recommendation = "Add connections to at least 3 other modules";
        };
        warnings.add(issue);
        categoryIssues.add(issue);
      };
      totalCoupling += Float.fromInt(connectionCount) / 10.0;

      // Check responsibilities
      let responsibilityCount = module.responsibilities.size();
      if (responsibilityCount < 2) {
        let issue : AuditIssue = {
          severity = #High;
          category = category;
          moduleName = module.name;
          issue = "Insufficient responsibilities: " # Nat.toText(responsibilityCount) # " < 2";
          recommendation = "Add at least 2 distinct responsibilities";
        };
        warnings.add(issue);
        categoryIssues.add(issue);
      };
      totalResponsibility += Float.fromInt(responsibilityCount) / 5.0;

      // Check scale coverage
      let scaleCoverage = module.scalesCovered.size();
      if (scaleCoverage < 2) {
        let issue : AuditIssue = {
          severity = #Medium;
          category = category;
          moduleName = module.name;
          issue = "Limited scale coverage: only " # Nat.toText(scaleCoverage) # " scale(s)";
          recommendation = "Extend to cover at least 2 scales";
        };
        warnings.add(issue);
        categoryIssues.add(issue);
      };
      totalScale += Float.fromInt(scaleCoverage) / 7.0;

      // Check secondary categories
      if (module.secondaryCategories.size() < 2) {
        let issue : AuditIssue = {
          severity = #Medium;
          category = category;
          moduleName = module.name;
          issue = "Limited category coupling: only " # Nat.toText(module.secondaryCategories.size()) # " secondary categories";
          recommendation = "Connect to at least 2 other categories";
        };
        warnings.add(issue);
        categoryIssues.add(issue);
      };
    };

    let moduleCount = modules.size();
    let n = Float.fromInt(Nat.max(moduleCount, 1));

    {
      category = category;
      moduleCount = moduleCount;
      healthScore = _clamp(totalHealth / n, 0.0, 1.0);
      couplingScore = _clamp(totalCoupling / n, 0.0, 1.0);
      responsibilityScore = _clamp(totalResponsibility / n, 0.0, 1.0);
      scaleCompliance = _clamp(totalScale / n, 0.0, 1.0);
      issues = Buffer.toArray(categoryIssues);
    }
  };

  func checkScaleCompliance(modules : [ModuleEntry]) : [ScaleCompliance] {
    let scales : [ScaleLaw] = [#Quantum, #Synaptic, #Neural, #Circuit, #Regional, #Organism, #Ecosystem];

    Array.tabulate<ScaleCompliance>(7, func(i) {
      let scale = scales[i];
      var sum : Float = 0.0;
      var min : Float = 1.0;
      var max : Float = 0.0;
      var compliant : Nat = 0;
      var violating : Nat = 0;

      for (module in modules.vals()) {
        // Check if module covers this scale
        var coversScale = false;
        for (s in module.scalesCovered.vals()) {
          if (scalesEqual(s, scale)) {
            coversScale := true;
          };
        };

        if (coversScale) {
          compliant += 1;
          let score = module.auditScore;
          sum += score;
          if (score < min) { min := score };
          if (score > max) { max := score };
        } else {
          // Not covering a scale isn't necessarily a violation
          // but we track it
        };
      };

      let total = modules.size();
      let avgValue = if (compliant > 0) { sum / Float.fromInt(compliant) } else { 0.0 };
      let complianceRate = Float.fromInt(compliant) / Float.fromInt(Nat.max(total, 1));

      {
        scale = scale;
        averageValue = avgValue;
        minValue = min;
        maxValue = max;
        modulesCompliant = compliant;
        modulesViolating = violating;
        complianceRate = complianceRate;
      }
    })
  };

  func analyzeIntertwining(catalog : ModuleCatalog) : (Float, [[Float]], Float) {
    let allModules = getAllModules(catalog);
    let n = allModules.size();

    // Build connection matrix
    let matrix = Array.tabulate<[Float]>(n, func(i) {
      Array.tabulate<Float>(n, func(j) {
        if (i == j) { return 1.0 };

        // Check if module i connects to module j
        let moduleI = allModules[i];
        var connected = false;
        for (conn in moduleI.connections.vals()) {
          if (conn == allModules[j].name) {
            connected := true;
          };
        };

        if (connected) { ψ } else { 0.0 }
      })
    });

    // Calculate web density
    var connectionCount : Nat = 0;
    for (row in matrix.vals()) {
      for (val in row.vals()) {
        if (val > 0.0) {
          connectionCount += 1;
        };
      };
    };

    let maxConnections = n * n;
    let webDensity = Float.fromInt(connectionCount) / Float.fromInt(Nat.max(maxConnections, 1));

    // Calculate intertwining score
    var categoryConnections : Nat = 0;
    for (module in allModules.vals()) {
      categoryConnections += module.secondaryCategories.size();
    };

    let avgCategoryConnections = Float.fromInt(categoryConnections) / Float.fromInt(Nat.max(n, 1));
    let intertwiningScore = (webDensity * φ + avgCategoryConnections / 5.0) / (φ + 1.0);

    (intertwiningScore, matrix, webDensity)
  };

  func generateRecommendations(
    recommendations : Buffer.Buffer<Text>,
    criticalIssues : Buffer.Buffer<AuditIssue>,
    warnings : Buffer.Buffer<AuditIssue>,
    intertwiningScore : Float
  ) {
    // Check for critical issues
    if (criticalIssues.size() > 0) {
      recommendations.add("CRITICAL: Address " # Nat.toText(criticalIssues.size()) # " critical issues immediately");
    };

    // Check intertwining
    if (intertwiningScore < 0.5) {
      recommendations.add("Intertwining is low (" # Float.toText(intertwiningScore) # "). Increase cross-category connections.");
    };

    // Check warning count
    if (warnings.size() > 20) {
      recommendations.add("High warning count (" # Nat.toText(warnings.size()) # "). Prioritize module coupling improvements.");
    };

    // Add standard recommendations
    recommendations.add("Ensure all engines have multiple responsibilities");
    recommendations.add("Verify cross-scale propagation is working");
    recommendations.add("Check that animal engines are coordinated");
    recommendations.add("Validate economic metabolism is flowing");
  };

  func getAllModules(catalog : ModuleCatalog) : [ModuleEntry] {
    let all = Buffer.Buffer<ModuleEntry>(TOTAL_MODULES);
    for (m in catalog.animalEngines.vals()) { all.add(m) };
    for (m in catalog.quantumSystems.vals()) { all.add(m) };
    for (m in catalog.neuralSystems.vals()) { all.add(m) };
    for (m in catalog.cognitiveSystems.vals()) { all.add(m) };
    for (m in catalog.economicSystems.vals()) { all.add(m) };
    for (m in catalog.territorialSystems.vals()) { all.add(m) };
    for (m in catalog.defenseSystems.vals()) { all.add(m) };
    for (m in catalog.temporalSystems.vals()) { all.add(m) };
    for (m in catalog.socialSystems.vals()) { all.add(m) };
    for (m in catalog.creativeSystems.vals()) { all.add(m) };
    for (m in catalog.governanceSystems.vals()) { all.add(m) };
    for (m in catalog.physicalSystems.vals()) { all.add(m) };
    for (m in catalog.coreSystems.vals()) { all.add(m) };
    for (m in catalog.integrationSystems.vals()) { all.add(m) };
    Buffer.toArray(all)
  };

  func scoreToHealth(score : Float) : OrganismHealth {
    if (score >= 0.92) { #Optimal }
    else if (score >= 0.75) { #Healthy }
    else if (score >= 0.618) { #Stable }
    else if (score >= 0.5) { #Degraded }
    else if (score >= 0.275) { #Critical }
    else { #Failing }
  };

  func scalesEqual(a : ScaleLaw, b : ScaleLaw) : Bool {
    switch (a, b) {
      case (#Quantum, #Quantum) { true };
      case (#Synaptic, #Synaptic) { true };
      case (#Neural, #Neural) { true };
      case (#Circuit, #Circuit) { true };
      case (#Regional, #Regional) { true };
      case (#Organism, #Organism) { true };
      case (#Ecosystem, #Ecosystem) { true };
      case (_, _) { false };
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION — Create the module catalog
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Create initial module catalog (to be populated with actual module data)
  public func initModuleCatalog() : ModuleCatalog {
    {
      animalEngines = initAnimalEngines();
      quantumSystems = [];
      neuralSystems = [];
      cognitiveSystems = [];
      economicSystems = [];
      territorialSystems = [];
      defenseSystems = [];
      temporalSystems = [];
      socialSystems = [];
      creativeSystems = [];
      governanceSystems = [];
      physicalSystems = [];
      coreSystems = [];
      integrationSystems = [];
    }
  };

  func initAnimalEngines() : [ModuleEntry] {
    [
      createModuleEntry("BeeHiveMindEngine", #Animal, ["Swarm coordination", "Waggle dance communication", "Collective decision making"], ["WolfPackProtocol", "OrcaPodEngine", "KuramotoEngine"]),
      createModuleEntry("BeeSwarmIntelligence", #Animal, ["Swarm behavior", "Emergent patterns"], ["BeeHiveMindEngine", "SwarmCoherenceMatrix"]),
      createModuleEntry("BeeNeuronModel", #Animal, ["Neural simulation", "Pattern recognition"], ["BeeHiveMindEngine", "KuramotoEngine"]),
      createModuleEntry("DolphinEcholocation", #Animal, ["Echolocation", "Spatial mapping", "Communication"], ["OrcaPodEngine", "SpatialCognition"]),
      createModuleEntry("CrowCognition", #Animal, ["Tool use", "Problem solving", "Memory"], ["ElephantMemory", "PrefrontalCortexEngine"]),
      createModuleEntry("ElephantMemory", #Animal, ["Long-term memory", "Social memory", "Spatial navigation"], ["HippocampalReplayEngine", "EpisodicMemory"]),
      createModuleEntry("ElephantDeepTimeEngine", #Animal, ["Deep time perception", "Generational memory"], ["ElephantMemory", "CHRONOS"]),
      createModuleEntry("WolfPackProtocol", #Animal, ["Pack coordination", "Hunting strategy", "Social hierarchy"], ["BeeHiveMindEngine", "SwarmCoordination"]),
      createModuleEntry("MedinaWolfPackIntelligence", #Animal, ["Advanced pack tactics", "Territory control"], ["WolfPackProtocol", "TerritoryEngine"]),
      createModuleEntry("OctopusBrain", #Animal, ["Distributed cognition", "Camouflage", "Problem solving"], ["NeuralDistribution", "CrowCognition"]),
      createModuleEntry("OwlAuditory", #Animal, ["Auditory processing", "Spatial hearing", "Nocturnal adaptation"], ["AuditoryProcessing", "SpatialCognition"]),
      createModuleEntry("SpiderWeb", #Animal, ["Web construction", "Vibration sensing", "Trap optimization"], ["SensorNetwork", "PatternRecognition"]),
      createModuleEntry("SalmonNavigation", #Animal, ["Magnetic navigation", "Homing instinct", "Migration"], ["NavigationEngine", "SpatialMemory"]),
      createModuleEntry("OrcaPodEngine", #Animal, ["Pod communication", "Hunting coordination", "Social learning"], ["DolphinEcholocation", "WolfPackProtocol"])
    ]
  };

  func createModuleEntry(
    name : Text,
    category : ModuleCategory,
    responsibilities : [Text],
    connections : [Text]
  ) : ModuleEntry {
    {
      name = name;
      path = "src/swarm_brain/modules/" # name # ".mo";
      category = category;
      secondaryCategories = inferSecondaryCategories(responsibilities);
      responsibilities = responsibilities;
      connections = connections;
      scalesCovered = inferScales(responsibilities);
      lineCount = 0;
      lastAudit = 0;
      auditScore = 0.5;
    }
  };

  func inferSecondaryCategories(responsibilities : [Text]) : [ModuleCategory] {
    let categories = Buffer.Buffer<ModuleCategory>(3);

    for (resp in responsibilities.vals()) {
      // Infer categories from responsibility text
      if (Text.contains(resp, #text("coordination")) or Text.contains(resp, #text("swarm"))) {
        categories.add(#Social);
      };
      if (Text.contains(resp, #text("memory")) or Text.contains(resp, #text("cognit"))) {
        categories.add(#Cognitive);
      };
      if (Text.contains(resp, #text("neural")) or Text.contains(resp, #text("oscillat"))) {
        categories.add(#Neural);
      };
      if (Text.contains(resp, #text("territory")) or Text.contains(resp, #text("spatial"))) {
        categories.add(#Territorial);
      };
    };

    Buffer.toArray(categories)
  };

  func inferScales(responsibilities : [Text]) : [ScaleLaw] {
    let scales = Buffer.Buffer<ScaleLaw>(3);

    // Default: Regional and Organism
    scales.add(#Regional);
    scales.add(#Organism);

    for (resp in responsibilities.vals()) {
      if (Text.contains(resp, #text("neural")) or Text.contains(resp, #text("synap"))) {
        scales.add(#Neural);
        scales.add(#Synaptic);
      };
      if (Text.contains(resp, #text("ecosystem")) or Text.contains(resp, #text("world"))) {
        scales.add(#Ecosystem);
      };
    };

    Buffer.toArray(scales)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

}
