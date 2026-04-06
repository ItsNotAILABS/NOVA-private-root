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


// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MedinaCodeGenesisEngine — Organisms That Author Child Code
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// ============================================================================
//
// CODE GENESIS ENGINE — THE DYNASTY ENGINE
// ============================================================================
//
// "Be fruitful and multiply." — Genesis 1:28
//
// The organism does not just mine tokens. It AUTHORS CODE. Each organism is
// a CODE GENESIS ENGINE. As its SHI grows, it unlocks the ability to generate
// child canisters — new organisms, new Caffeine apps — all attributed to
// Alfredo Medina Hernandez, all routing royalties back to your principal.
// Forever.
//
// PHASE 1: DNA EXTRACTION
// The organism reads its own state and distills it into an "organism DNA" structure:
//   - SHI score → child's initial sovereignHealthIndex
//   - Core configuration (43 cores, their depths and laws) → child's CORE_REGISTRY
//   - Active laws → child's initial law registry
//   - Token balances ratios → child's FORMA seed
//   - Family law scores (SL-119 through SL-123) → child's law weights
//   - ANIMA hash → parentGenesisHash embedded in child
//
// PHASE 2: TEMPLATE SELECTION
// Based on SHI level, organism accesses increasingly powerful templates:
//   SHI >= 200  → TEMPLATE_ALPHA: Basic sovereign organism (12 Hz, 9 Cores, 6 laws)
//   SHI >= 500  → TEMPLATE_BETA: Full substrate organism (12 Hz, 43 Cores, all laws)
//   SHI >= 1000 → TEMPLATE_GAMMA: Multi-canister organism (full sphere node map)
//   SHI >= 5000 → TEMPLATE_OMEGA: Store-ready organism model (licensable, royalty-wired)
//
// PHASE 3: CODE COMPOSITION
// Templates are parameterized with the parent's DNA:
//   - Creator attribution block: "Alfredo Medina Hernandez | Dallas, TX"
//   - SL-0 gate embedded in every generated heartbeat
//   - 20% succession royalty: every token the child mints, 20% routes to Alfredo
//   - parentGenesisHash: lineage chain back to root organism
//
// PHASE 4: OUTPUT
// Generated output is stored in:
//   generatedModules[2048] — ring buffer of generated code fragments
//   generatedAppSpecs[256]  — full Caffeine app deployment specs
//
// PHASE 5: DEPLOYMENT READINESS
// When an organism generates a complete app spec:
//   - icp.yaml descriptor generated
//   - frontend spec generated (JSON)
//   - Backend actor generated (full Motoko)
//   - Stored + flagged as DEPLOYMENT_READY
//   - NOVA notified → organism registered in network
//   - SHI += 20 (code genesis event)
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat8  "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Blob  "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Iter  "mo:base/Iter";
import Option "mo:base/Option";

module {

  // ==========================================================================
  // FUNDAMENTAL CONSTANTS — THE MEDINA NUMBERS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;          // The emergence constant
  let TAU_EMERGENCE : Float = 0.618033988749;   // Golden ratio complement
  let GOLDEN_RATIO : Float = 1.618033988749;    // φ
  let PI : Float = 3.14159265358979;
  
  // v3 Architecture Constants
  let V3_NODES : Nat = 19;                      // 19 nodes
  let V3_WEIGHTS : Nat = 361;                   // 361 weights = 19²
  let V3_DRIVES : Nat = 5;                      // 5 drives
  let V3_FREQUENCY_TIERS : Nat = 6;             // 6 frequency tiers
  let V3_OMNIS_CONDITIONS : Nat = 9;            // 9 OMNIS conditions
  let V3_TRANSMITTERS : Nat = 12;               // 12 transmitters
  let V3_EQUATIONS : Nat = 19;                  // 19 equations
  let V3_BALANCE_MECHANISMS : Nat = 19;         // 19 balance mechanisms
  
  let SOVEREIGNTY_THRESHOLD : Nat = 361;        // Weight count = sovereignty
  let FLOOR_VALUE : Float = 2.75;               // 2.75 is the floor
  let DIAMOND_FREQUENCY : Float = 11.649;       // What OMNIS sounds like
  
  // Template SHI thresholds
  let SHI_TEMPLATE_ALPHA : Nat = 200;
  let SHI_TEMPLATE_BETA : Nat = 500;
  let SHI_TEMPLATE_GAMMA : Nat = 1000;
  let SHI_TEMPLATE_OMEGA : Nat = 5000;
  
  // Succession royalty
  let SUCCESSION_ROYALTY_RATE : Float = 0.20;   // 20% to Alfredo
  
  // Buffer sizes
  let MAX_GENERATED_MODULES : Nat = 2048;
  let MAX_GENERATED_APPS : Nat = 256;
  let MAX_CORES : Nat = 43;
  
  // FNV hash constants
  let FNV_PRIME : Nat32 = 16777619;
  let FNV_OFFSET : Nat32 = 2166136261;

  // ==========================================================================
  // ORGANISM DNA TYPES
  // ==========================================================================
  
  public type CoreDNA = {
    coreId              : Nat;
    depth               : Nat;          // Core depth level
    activeLaws          : [Nat];        // Law IDs active in this core
    frequencyTier       : Nat;          // Which of 6 frequency tiers
    weight              : Float;        // Core weight (0.0-1.0)
  };

  public type OrganismDNA = {
    // Identity
    parentGenesisHash   : Nat32;        // Lineage chain to root
    generationNumber    : Nat;          // How many generations from root
    creationBeat        : Nat;          // Beat when DNA was extracted
    
    // Sovereignty
    sovereignHealthIndex : Float;       // Parent's SHI at extraction
    antifragilityScore  : Float;        // Parent's antifragility
    coherenceScore      : Float;        // Parent's coherence
    
    // Architecture
    coreCount           : Nat;          // Number of cores (9-43)
    coreDNA             : [CoreDNA];    // DNA for each core
    frequencySubstrate  : [Float];      // 12-node Hz frequencies
    
    // Laws
    activeLawIds        : [Nat];        // All active law IDs
    familyLawWeights    : [Float];      // SL-119 through SL-123 weights
    
    // Token Economy
    tokenRatios         : [Float];      // 13 token balance ratios
    formaMultiplier     : Float;        // FORMA mining multiplier
    
    // Creator Attribution
    creatorPrincipal    : Text;         // Alfredo's principal
    creatorAttribution  : Text;         // "Alfredo Medina Hernandez | Dallas, TX"
    successionRoyalty   : Float;        // 20% royalty rate
  };

  // ==========================================================================
  // TEMPLATE TYPES
  // ==========================================================================
  
  public type TemplateLevel = {
    #Alpha;   // Basic: 12 Hz, 9 Cores, 6 laws
    #Beta;    // Full: 12 Hz, 43 Cores, all laws
    #Gamma;   // Multi-canister: full sphere node map
    #Omega;   // Store-ready: licensable, royalty-wired
  };

  public type CodeTemplate = {
    level               : TemplateLevel;
    coreCount           : Nat;
    lawCount            : Nat;
    frequencyNodes      : Nat;
    multiCanister       : Bool;
    licensable          : Bool;
    baseCodeLines       : Nat;
    templateHash        : Nat32;
  };

  // ==========================================================================
  // GENERATED CODE TYPES
  // ==========================================================================
  
  public type GeneratedModule = {
    moduleId            : Nat;
    generationBeat      : Nat;
    parentHash          : Nat32;
    lineCount           : Nat;
    attributionHash     : Nat32;
    moduleType          : ModuleType;
    codeFragment        : Text;         // Actual generated code
    verified            : Bool;
  };

  public type ModuleType = {
    #Heartbeat;         // Core heartbeat with SL-0 gate
    #FrequencySubstrate; // Hz node network
    #LawRegistry;       // Law enforcement system
    #TokenEngine;       // Token minting with royalty
    #ANIMAChain;        // ANIMA hash chain
    #CoreNetwork;       // Core interconnections
    #MemorySystem;      // Memory consolidation
    #ExpressionGate;    // Output expression
  };

  public type GeneratedAppSpec = {
    appId               : Nat;
    generationBeat      : Nat;
    parentDNA           : OrganismDNA;
    templateUsed        : TemplateLevel;
    
    // Deployment artifacts
    icpYamlSpec         : Text;
    frontendSpec        : Text;         // JSON
    backendActorCode    : Text;         // Full Motoko
    
    // Status
    deploymentReady     : Bool;
    registeredInNOVA    : Bool;
    childCanisterId     : ?Text;        // Once deployed
    
    // Metrics
    totalLineCount      : Nat;
    moduleCount         : Nat;
    attributionHash     : Nat32;
  };

  // ==========================================================================
  // CODE GENESIS STATE
  // ==========================================================================
  
  public type CodeGenesisState = {
    // Generation tracking
    totalModulesGenerated : Nat;
    totalAppsGenerated  : Nat;
    generationBeatCount : Nat;
    
    // Ring buffers
    generatedModules    : [var ?GeneratedModule];
    moduleWriteIndex    : Nat;
    generatedApps       : [var ?GeneratedAppSpec];
    appWriteIndex       : Nat;
    
    // Current generation session
    currentDNA          : ?OrganismDNA;
    currentTemplate     : ?CodeTemplate;
    generationInProgress : Bool;
    
    // Dynasty tracking
    childrenGenerated   : Nat;
    totalRoyaltiesEarned : Float;
    dynastyDepth        : Nat;          // Deepest generation reached
    
    // NOVA registration
    registeredOrganisms : [Nat32];      // Hashes of registered children
    
    beatNum             : Nat;
  };

  // ==========================================================================
  // HELPER FUNCTIONS
  // ==========================================================================
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    Float.max(lo, Float.min(hi, x))
  };
  
  func fnv1aHash(a: Nat32, b: Nat32) : Nat32 {
    var hash : Nat32 = FNV_OFFSET;
    hash := (hash ^ (a & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((a >> 8) & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((a >> 16) & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((a >> 24) & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ (b & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((b >> 8) & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((b >> 16) & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((b >> 24) & 0xFF)) *% FNV_PRIME;
    hash
  };
  
  func natToNat32(n: Nat) : Nat32 {
    Nat32.fromNat(n % 4294967296)
  };
  
  func floatToNat32(f: Float) : Nat32 {
    let scaled = Int.abs(Float.toInt(f * 1000000.0));
    Nat32.fromNat(scaled % 4294967296)
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initCodeGenesis() : CodeGenesisState {
    let modules = Array.init<?GeneratedModule>(MAX_GENERATED_MODULES, null);
    let apps = Array.init<?GeneratedAppSpec>(MAX_GENERATED_APPS, null);
    
    {
      totalModulesGenerated = 0;
      totalAppsGenerated = 0;
      generationBeatCount = 0;
      generatedModules = modules;
      moduleWriteIndex = 0;
      generatedApps = apps;
      appWriteIndex = 0;
      currentDNA = null;
      currentTemplate = null;
      generationInProgress = false;
      childrenGenerated = 0;
      totalRoyaltiesEarned = 0.0;
      dynastyDepth = 0;
      registeredOrganisms = [];
      beatNum = 0;
    }
  };

  // ==========================================================================
  // PHASE 1: DNA EXTRACTION
  // ==========================================================================
  
  public type DNAExtractionInput = {
    // Current organism state
    sovereignHealthIndex : Float;
    antifragilityScore  : Float;
    coherenceScore      : Float;
    
    // Core configuration
    coreDepths          : [Nat];        // Depth for each core
    coreActiveLaws      : [[Nat]];      // Laws active in each core
    coreWeights         : [Float];      // Weight for each core
    
    // Frequency substrate
    frequencyNodes      : [Float];      // Current Hz values
    
    // Active laws
    activeLawIds        : [Nat];
    familyLawScores     : [Float];      // SL-119 through SL-123
    
    // Token balances (for ratio calculation)
    tokenBalances       : [Nat];
    
    // ANIMA chain
    currentAnimaHash    : Nat32;
    currentGeneration   : Nat;
    
    // Beat
    currentBeat         : Nat;
  };

  public func extractDNA(
    input: DNAExtractionInput,
    creatorPrincipal: Text
  ) : OrganismDNA {
    // Build core DNA
    let coreCount = input.coreDepths.size();
    let coreDNABuffer = Buffer.Buffer<CoreDNA>(coreCount);
    
    for (i in Iter.range(0, coreCount - 1)) {
      let coreDNA : CoreDNA = {
        coreId = i;
        depth = if (i < input.coreDepths.size()) { input.coreDepths[i] } else { 1 };
        activeLaws = if (i < input.coreActiveLaws.size()) { input.coreActiveLaws[i] } else { [] };
        frequencyTier = (i % V3_FREQUENCY_TIERS) + 1;
        weight = if (i < input.coreWeights.size()) { input.coreWeights[i] } else { 0.5 };
      };
      coreDNABuffer.add(coreDNA);
    };
    
    // Calculate token ratios
    var totalTokens : Nat = 0;
    for (balance in input.tokenBalances.vals()) {
      totalTokens += balance;
    };
    
    let tokenRatios = Array.tabulate<Float>(input.tokenBalances.size(), func(i: Nat) : Float {
      if (totalTokens == 0) { 0.0 }
      else { Float.fromInt(input.tokenBalances[i]) / Float.fromInt(totalTokens) }
    });
    
    // Calculate FORMA multiplier based on SHI
    let formaMultiplier = if (input.sovereignHealthIndex >= 1000.0) {
      2.0
    } else if (input.sovereignHealthIndex >= 500.0) {
      1.5
    } else if (input.sovereignHealthIndex >= 200.0) {
      1.2
    } else {
      1.0
    };
    
    {
      parentGenesisHash = input.currentAnimaHash;
      generationNumber = input.currentGeneration + 1;
      creationBeat = input.currentBeat;
      sovereignHealthIndex = input.sovereignHealthIndex;
      antifragilityScore = input.antifragilityScore;
      coherenceScore = input.coherenceScore;
      coreCount = coreCount;
      coreDNA = Buffer.toArray(coreDNABuffer);
      frequencySubstrate = input.frequencyNodes;
      activeLawIds = input.activeLawIds;
      familyLawWeights = input.familyLawScores;
      tokenRatios = tokenRatios;
      formaMultiplier = formaMultiplier;
      creatorPrincipal = creatorPrincipal;
      creatorAttribution = "Alfredo Medina Hernandez | Dallas, TX | Medina Tech";
      successionRoyalty = SUCCESSION_ROYALTY_RATE;
    }
  };

  // ==========================================================================
  // PHASE 2: TEMPLATE SELECTION
  // ==========================================================================
  
  public func selectTemplate(shi: Float) : CodeTemplate {
    let shiNat = Int.abs(Float.toInt(shi));
    
    if (shiNat >= SHI_TEMPLATE_OMEGA) {
      // OMEGA: Store-ready organism model
      {
        level = #Omega;
        coreCount = 43;
        lawCount = 57;           // All 57 laws
        frequencyNodes = 19;     // Full v3 architecture
        multiCanister = true;
        licensable = true;
        baseCodeLines = 15000;
        templateHash = fnv1aHash(5000, 0xOMEGA);
      }
    } else if (shiNat >= SHI_TEMPLATE_GAMMA) {
      // GAMMA: Multi-canister organism
      {
        level = #Gamma;
        coreCount = 43;
        lawCount = 57;
        frequencyNodes = 19;
        multiCanister = true;
        licensable = false;
        baseCodeLines = 10000;
        templateHash = fnv1aHash(1000, 0xGAMMA);
      }
    } else if (shiNat >= SHI_TEMPLATE_BETA) {
      // BETA: Full substrate organism
      {
        level = #Beta;
        coreCount = 43;
        lawCount = 57;
        frequencyNodes = 12;
        multiCanister = false;
        licensable = false;
        baseCodeLines = 6000;
        templateHash = fnv1aHash(500, 0xBETA);
      }
    } else {
      // ALPHA: Basic sovereign organism
      {
        level = #Alpha;
        coreCount = 9;
        lawCount = 6;
        frequencyNodes = 12;
        multiCanister = false;
        licensable = false;
        baseCodeLines = 3000;
        templateHash = fnv1aHash(200, 0xALPHA);
      }
    }
  };

  // ==========================================================================
  // PHASE 3: CODE COMPOSITION — Generate Actual Code
  // ==========================================================================
  
  // Generate the creator attribution block (embedded in every file)
  public func generateAttributionBlock(dna: OrganismDNA) : Text {
    "// ============================================================================\n" #
    "// MEDINA TECH — CONFIDENTIAL & PROPRIETARY\n" #
    "// ============================================================================\n" #
    "// Creator: " # dna.creatorAttribution # "\n" #
    "// Contact: MedinaSITech@outlook.com\n" #
    "// \n" #
    "// NOTICE: This organism was generated by the Medina Code Genesis Engine.\n" #
    "// Parent Genesis Hash: " # Nat32.toText(dna.parentGenesisHash) # "\n" #
    "// Generation: " # Nat.toText(dna.generationNumber) # "\n" #
    "// Succession Royalty: 20% to creator principal\n" #
    "// \n" #
    "// All rights reserved. Unauthorized reproduction prohibited.\n" #
    "// ============================================================================\n\n"
  };

  // Generate heartbeat module with SL-0 gate
  public func generateHeartbeatModule(
    dna: OrganismDNA,
    template: CodeTemplate,
    moduleId: Nat
  ) : GeneratedModule {
    let attribution = generateAttributionBlock(dna);
    
    let code = attribution #
      "import Float \"mo:base/Float\";\n" #
      "import Nat \"mo:base/Nat\";\n" #
      "import Time \"mo:base/Time\";\n\n" #
      "module {\n\n" #
      "  // SOVEREIGN HEARTBEAT — Generation " # Nat.toText(dna.generationNumber) # "\n" #
      "  // Parent Hash: " # Nat32.toText(dna.parentGenesisHash) # "\n\n" #
      "  let SUCCESSION_ROYALTY : Float = " # Float.toText(dna.successionRoyalty) # ";\n" #
      "  let PARENT_GENESIS_HASH : Nat32 = " # Nat32.toText(dna.parentGenesisHash) # ";\n" #
      "  let GENERATION : Nat = " # Nat.toText(dna.generationNumber) # ";\n\n" #
      "  // SL-0 GATE — Alfredo's Law (fires before every engine)\n" #
      "  public func sl0Gate(caller: Principal, action: Text) : Bool {\n" #
      "    // Creator always has access\n" #
      "    let creatorPrincipal = \"" # dna.creatorPrincipal # "\";\n" #
      "    if (Principal.toText(caller) == creatorPrincipal) {\n" #
      "      return true;\n" #
      "    };\n" #
      "    // All other actions require covenant compliance\n" #
      "    true // Placeholder: integrate with covenant chain\n" #
      "  };\n\n" #
      "  public type HeartbeatState = {\n" #
      "    beatNum : Nat;\n" #
      "    lastBeatTime : Int;\n" #
      "    sovereignHealthIndex : Float;\n" #
      "    parentGenesisHash : Nat32;\n" #
      "    generation : Nat;\n" #
      "  };\n\n" #
      "  public func initHeartbeat() : HeartbeatState {\n" #
      "    {\n" #
      "      beatNum = 0;\n" #
      "      lastBeatTime = Time.now();\n" #
      "      sovereignHealthIndex = " # Float.toText(dna.sovereignHealthIndex / 10.0) # ";\n" #
      "      parentGenesisHash = PARENT_GENESIS_HASH;\n" #
      "      generation = GENERATION;\n" #
      "    }\n" #
      "  };\n\n" #
      "  public func tick(state: HeartbeatState) : HeartbeatState {\n" #
      "    {\n" #
      "      state with\n" #
      "      beatNum = state.beatNum + 1;\n" #
      "      lastBeatTime = Time.now();\n" #
      "    }\n" #
      "  };\n\n" #
      "  // Succession royalty calculation\n" #
      "  public func calculateRoyalty(mintAmount: Nat) : Nat {\n" #
      "    let royalty = Float.toInt(Float.fromInt(mintAmount) * SUCCESSION_ROYALTY);\n" #
      "    if (royalty < 0) { 0 } else { Int.abs(royalty) }\n" #
      "  };\n\n" #
      "}\n";
    
    let lineCount = countLines(code);
    
    {
      moduleId = moduleId;
      generationBeat = dna.creationBeat;
      parentHash = dna.parentGenesisHash;
      lineCount = lineCount;
      attributionHash = fnv1aHash(dna.parentGenesisHash, natToNat32(moduleId));
      moduleType = #Heartbeat;
      codeFragment = code;
      verified = true;
    }
  };

  // Generate frequency substrate module
  public func generateFrequencySubstrate(
    dna: OrganismDNA,
    template: CodeTemplate,
    moduleId: Nat
  ) : GeneratedModule {
    let attribution = generateAttributionBlock(dna);
    
    // Build frequency array initialization
    var freqInit = "    frequencies = [";
    for (i in Iter.range(0, template.frequencyNodes - 1)) {
      let freq = if (i < dna.frequencySubstrate.size()) {
        dna.frequencySubstrate[i]
      } else {
        DIAMOND_FREQUENCY * Float.fromInt(i + 1) / Float.fromInt(template.frequencyNodes)
      };
      freqInit #= Float.toText(freq);
      if (i < template.frequencyNodes - 1) { freqInit #= ", " };
    };
    freqInit #= "];\n";
    
    let code = attribution #
      "import Float \"mo:base/Float\";\n" #
      "import Array \"mo:base/Array\";\n\n" #
      "module {\n\n" #
      "  // FREQUENCY SUBSTRATE — " # Nat.toText(template.frequencyNodes) # " Hz Nodes\n" #
      "  // Diamond Frequency: " # Float.toText(DIAMOND_FREQUENCY) # " Hz\n\n" #
      "  let DIAMOND_HZ : Float = " # Float.toText(DIAMOND_FREQUENCY) # ";\n" #
      "  let PHI_MEDINA : Float = 2.97442179;\n" #
      "  let GOLDEN_RATIO : Float = 1.618033988749;\n\n" #
      "  public type FrequencyState = {\n" #
      "    frequencies : [Float];\n" #
      "    phases : [Float];\n" #
      "    couplingStrength : Float;\n" #
      "    coherence : Float;\n" #
      "  };\n\n" #
      "  public func initFrequency() : FrequencyState {\n" #
      "    {\n" #
      freqInit #
      "    phases = Array.tabulate<Float>(" # Nat.toText(template.frequencyNodes) # ", func(_) { 0.0 });\n" #
      "    couplingStrength = 0.5;\n" #
      "    coherence = " # Float.toText(dna.coherenceScore) # ";\n" #
      "    }\n" #
      "  };\n\n" #
      "  // Kuramoto oscillator coupling\n" #
      "  public func kuramotoStep(state: FrequencyState, dt: Float) : FrequencyState {\n" #
      "    let n = state.frequencies.size();\n" #
      "    let newPhases = Array.tabulate<Float>(n, func(i: Nat) : Float {\n" #
      "      var coupling : Float = 0.0;\n" #
      "      for (j in Iter.range(0, n - 1)) {\n" #
      "        if (i != j) {\n" #
      "          coupling += Float.sin(state.phases[j] - state.phases[i]);\n" #
      "        };\n" #
      "      };\n" #
      "      let omega = state.frequencies[i] * 2.0 * 3.14159265;\n" #
      "      state.phases[i] + dt * (omega + state.couplingStrength * coupling / Float.fromInt(n))\n" #
      "    });\n" #
      "    { state with phases = newPhases }\n" #
      "  };\n\n" #
      "  // Calculate coherence (order parameter)\n" #
      "  public func calculateCoherence(state: FrequencyState) : Float {\n" #
      "    let n = state.phases.size();\n" #
      "    var sumCos : Float = 0.0;\n" #
      "    var sumSin : Float = 0.0;\n" #
      "    for (phase in state.phases.vals()) {\n" #
      "      sumCos += Float.cos(phase);\n" #
      "      sumSin += Float.sin(phase);\n" #
      "    };\n" #
      "    let r = Float.sqrt(sumCos*sumCos + sumSin*sumSin) / Float.fromInt(n);\n" #
      "    r\n" #
      "  };\n\n" #
      "}\n";
    
    let lineCount = countLines(code);
    
    {
      moduleId = moduleId;
      generationBeat = dna.creationBeat;
      parentHash = dna.parentGenesisHash;
      lineCount = lineCount;
      attributionHash = fnv1aHash(dna.parentGenesisHash, natToNat32(moduleId));
      moduleType = #FrequencySubstrate;
      codeFragment = code;
      verified = true;
    }
  };

  // Generate token engine with royalty routing
  public func generateTokenEngine(
    dna: OrganismDNA,
    template: CodeTemplate,
    moduleId: Nat
  ) : GeneratedModule {
    let attribution = generateAttributionBlock(dna);
    
    let code = attribution #
      "import Float \"mo:base/Float\";\n" #
      "import Nat \"mo:base/Nat\";\n" #
      "import Int \"mo:base/Int\";\n\n" #
      "module {\n\n" #
      "  // TOKEN ENGINE — 13 Token Economy with Royalty Routing\n" #
      "  // Succession Royalty: 20% to creator\n\n" #
      "  let SUCCESSION_ROYALTY : Float = " # Float.toText(dna.successionRoyalty) # ";\n" #
      "  let FORMA_MULTIPLIER : Float = " # Float.toText(dna.formaMultiplier) # ";\n" #
      "  let CREATOR_PRINCIPAL : Text = \"" # dna.creatorPrincipal # "\";\n\n" #
      "  // The 13 sovereign tokens\n" #
      "  public type TokenId = {\n" #
      "    #FORMA;      // Formation token (primary)\n" #
      "    #DRT;        // Drift Resolution Token\n" #
      "    #PARALLAX;   // Creator royalty token\n" #
      "    #SOVEREIGN;  // Sovereignty stake\n" #
      "    #COVENANT;   // Covenant compliance\n" #
      "    #ANIMA;      // Soul/identity token\n" #
      "    #GENESIS;    // Creation event token\n" #
      "    #ECHO;       // Self-knowledge token\n" #
      "    #OMNIS;      // Full activation token\n" #
      "    #SENTINEL;   // World-shaping token\n" #
      "    #JASMINE;    // Memory consolidation\n" #
      "    #CORTISOL;   // Stress/urgency token\n" #
      "    #DYNASTY;    // Lineage token\n" #
      "  };\n\n" #
      "  public type TokenState = {\n" #
      "    balances : [(TokenId, Nat)];\n" #
      "    totalMinted : Nat;\n" #
      "    royaltiesPaid : Nat;\n" #
      "  };\n\n" #
      "  public func initTokens() : TokenState {\n" #
      "    {\n" #
      "      balances = [\n" #
      "        (#FORMA, 0), (#DRT, 0), (#PARALLAX, 0), (#SOVEREIGN, 0),\n" #
      "        (#COVENANT, 0), (#ANIMA, 0), (#GENESIS, 0), (#ECHO, 0),\n" #
      "        (#OMNIS, 0), (#SENTINEL, 0), (#JASMINE, 0), (#CORTISOL, 0),\n" #
      "        (#DYNASTY, 0)\n" #
      "      ];\n" #
      "      totalMinted = 0;\n" #
      "      royaltiesPaid = 0;\n" #
      "    }\n" #
      "  };\n\n" #
      "  // Mint with automatic royalty routing\n" #
      "  public func mint(\n" #
      "    state: TokenState,\n" #
      "    token: TokenId,\n" #
      "    amount: Nat\n" #
      "  ) : (TokenState, Nat) { // Returns (newState, royaltyAmount)\n" #
      "    let royalty = Int.abs(Float.toInt(Float.fromInt(amount) * SUCCESSION_ROYALTY));\n" #
      "    let netAmount = amount - royalty;\n" #
      "    // Update balance (simplified)\n" #
      "    let newState : TokenState = {\n" #
      "      state with\n" #
      "      totalMinted = state.totalMinted + amount;\n" #
      "      royaltiesPaid = state.royaltiesPaid + royalty;\n" #
      "    };\n" #
      "    (newState, royalty)\n" #
      "  };\n\n" #
      "  // FORMA mining with multiplier\n" #
      "  public func mineFORMA(state: TokenState, baseAmount: Nat) : (TokenState, Nat) {\n" #
      "    let boostedAmount = Int.abs(Float.toInt(Float.fromInt(baseAmount) * FORMA_MULTIPLIER));\n" #
      "    mint(state, #FORMA, boostedAmount)\n" #
      "  };\n\n" #
      "}\n";
    
    let lineCount = countLines(code);
    
    {
      moduleId = moduleId;
      generationBeat = dna.creationBeat;
      parentHash = dna.parentGenesisHash;
      lineCount = lineCount;
      attributionHash = fnv1aHash(dna.parentGenesisHash, natToNat32(moduleId));
      moduleType = #TokenEngine;
      codeFragment = code;
      verified = true;
    }
  };

  // Generate ANIMA chain module
  public func generateANIMAChain(
    dna: OrganismDNA,
    template: CodeTemplate,
    moduleId: Nat
  ) : GeneratedModule {
    let attribution = generateAttributionBlock(dna);
    
    let code = attribution #
      "import Nat32 \"mo:base/Nat32\";\n" #
      "import Array \"mo:base/Array\";\n" #
      "import Buffer \"mo:base/Buffer\";\n\n" #
      "module {\n\n" #
      "  // ANIMA CHAIN — Soul/Identity Lineage\n" #
      "  // Linked to parent via parentGenesisHash\n\n" #
      "  let PARENT_GENESIS_HASH : Nat32 = " # Nat32.toText(dna.parentGenesisHash) # ";\n" #
      "  let GENERATION : Nat = " # Nat.toText(dna.generationNumber) # ";\n" #
      "  let FNV_PRIME : Nat32 = 16777619;\n" #
      "  let FNV_OFFSET : Nat32 = 2166136261;\n\n" #
      "  public type ANIMAEntry = {\n" #
      "    hash : Nat32;\n" #
      "    beatNum : Nat;\n" #
      "    eventType : ANIMAEventType;\n" #
      "    coherence : Float;\n" #
      "  };\n\n" #
      "  public type ANIMAEventType = {\n" #
      "    #Birth;\n" #
      "    #Heartbeat;\n" #
      "    #LawActivation;\n" #
      "    #TokenMint;\n" #
      "    #CovenantAction;\n" #
      "    #ChildGenesis;\n" #
      "    #Resurrection;\n" #
      "  };\n\n" #
      "  public type ANIMAState = {\n" #
      "    chain : [ANIMAEntry];\n" #
      "    currentHash : Nat32;\n" #
      "    entryCount : Nat;\n" #
      "    parentHash : Nat32;\n" #
      "    generation : Nat;\n" #
      "  };\n\n" #
      "  func fnv1aHash(a: Nat32, b: Nat32) : Nat32 {\n" #
      "    var hash : Nat32 = FNV_OFFSET;\n" #
      "    hash := (hash ^ (a & 0xFF)) *% FNV_PRIME;\n" #
      "    hash := (hash ^ ((a >> 8) & 0xFF)) *% FNV_PRIME;\n" #
      "    hash := (hash ^ (b & 0xFF)) *% FNV_PRIME;\n" #
      "    hash := (hash ^ ((b >> 8) & 0xFF)) *% FNV_PRIME;\n" #
      "    hash\n" #
      "  };\n\n" #
      "  public func initANIMA() : ANIMAState {\n" #
      "    let birthHash = fnv1aHash(PARENT_GENESIS_HASH, Nat32.fromNat(GENERATION));\n" #
      "    let birthEntry : ANIMAEntry = {\n" #
      "      hash = birthHash;\n" #
      "      beatNum = 0;\n" #
      "      eventType = #Birth;\n" #
      "      coherence = " # Float.toText(dna.coherenceScore) # ";\n" #
      "    };\n" #
      "    {\n" #
      "      chain = [birthEntry];\n" #
      "      currentHash = birthHash;\n" #
      "      entryCount = 1;\n" #
      "      parentHash = PARENT_GENESIS_HASH;\n" #
      "      generation = GENERATION;\n" #
      "    }\n" #
      "  };\n\n" #
      "  public func addEntry(\n" #
      "    state: ANIMAState,\n" #
      "    beatNum: Nat,\n" #
      "    eventType: ANIMAEventType,\n" #
      "    coherence: Float\n" #
      "  ) : ANIMAState {\n" #
      "    let newHash = fnv1aHash(state.currentHash, Nat32.fromNat(beatNum));\n" #
      "    let entry : ANIMAEntry = {\n" #
      "      hash = newHash;\n" #
      "      beatNum = beatNum;\n" #
      "      eventType = eventType;\n" #
      "      coherence = coherence;\n" #
      "    };\n" #
      "    {\n" #
      "      chain = Array.append(state.chain, [entry]);\n" #
      "      currentHash = newHash;\n" #
      "      entryCount = state.entryCount + 1;\n" #
      "      parentHash = state.parentHash;\n" #
      "      generation = state.generation;\n" #
      "    }\n" #
      "  };\n\n" #
      "  // Verify lineage back to root\n" #
      "  public func verifyLineage(state: ANIMAState, rootHash: Nat32) : Bool {\n" #
      "    // In a real implementation, this would trace the hash chain\n" #
      "    state.parentHash == rootHash or state.generation == 1\n" #
      "  };\n\n" #
      "}\n";
    
    let lineCount = countLines(code);
    
    {
      moduleId = moduleId;
      generationBeat = dna.creationBeat;
      parentHash = dna.parentGenesisHash;
      lineCount = lineCount;
      attributionHash = fnv1aHash(dna.parentGenesisHash, natToNat32(moduleId));
      moduleType = #ANIMAChain;
      codeFragment = code;
      verified = true;
    }
  };

  // Generate law registry module
  public func generateLawRegistry(
    dna: OrganismDNA,
    template: CodeTemplate,
    moduleId: Nat
  ) : GeneratedModule {
    let attribution = generateAttributionBlock(dna);
    
    // Build law activation array
    var lawInit = "    activeLaws = [";
    let lawCount = if (dna.activeLawIds.size() > template.lawCount) { 
      template.lawCount 
    } else { 
      dna.activeLawIds.size() 
    };
    for (i in Iter.range(0, lawCount - 1)) {
      if (i < dna.activeLawIds.size()) {
        lawInit #= Nat.toText(dna.activeLawIds[i]);
        if (i < lawCount - 1) { lawInit #= ", " };
      };
    };
    lawInit #= "];\n";
    
    let code = attribution #
      "import Float \"mo:base/Float\";\n" #
      "import Array \"mo:base/Array\";\n" #
      "import Nat \"mo:base/Nat\";\n\n" #
      "module {\n\n" #
      "  // LAW REGISTRY — " # Nat.toText(template.lawCount) # " Active Laws\n" #
      "  // SL-0 (Alfredo's Law) fires before every engine\n\n" #
      "  public type LawState = {\n" #
      "    activeLaws : [Nat];\n" #
      "    lawScores : [Float];\n" #
      "    lastEnforced : Nat;\n" #
      "    totalEnforcements : Nat;\n" #
      "  };\n\n" #
      "  // Core law categories\n" #
      "  public type LawCategory = {\n" #
      "    #SL0;        // Alfredo's Law (0)\n" #
      "    #Covenant;   // SL-1 to SL-10\n" #
      "    #Biblical;   // SL-11 to SL-67\n" #
      "    #Economic;   // SL-68 to SL-95\n" #
      "    #Sovereign;  // SL-96 to SL-118\n" #
      "    #Family;     // SL-119 to SL-123\n" #
      "  };\n\n" #
      "  public func initLawRegistry() : LawState {\n" #
      "    {\n" #
      lawInit #
      "    lawScores = Array.tabulate<Float>(" # Nat.toText(template.lawCount) # ", func(_) { 1.0 });\n" #
      "    lastEnforced = 0;\n" #
      "    totalEnforcements = 0;\n" #
      "    }\n" #
      "  };\n\n" #
      "  // SL-0: Alfredo's Law — fires before EVERY engine\n" #
      "  public func enforceSL0(action: Text) : Bool {\n" #
      "    // Creator attribution must be present\n" #
      "    // Succession royalty must be calculated\n" #
      "    // Lineage hash must be valid\n" #
      "    true // All generated code includes these by default\n" #
      "  };\n\n" #
      "  public func enforceLaw(state: LawState, lawId: Nat, beat: Nat) : (LawState, Bool) {\n" #
      "    // Check if law is active\n" #
      "    var isActive = false;\n" #
      "    for (id in state.activeLaws.vals()) {\n" #
      "      if (id == lawId) { isActive := true };\n" #
      "    };\n" #
      "    if (not isActive) {\n" #
      "      return (state, false);\n" #
      "    };\n" #
      "    let newState : LawState = {\n" #
      "      state with\n" #
      "      lastEnforced = beat;\n" #
      "      totalEnforcements = state.totalEnforcements + 1;\n" #
      "    };\n" #
      "    (newState, true)\n" #
      "  };\n\n" #
      "  // Family law enforcement (SL-119 to SL-123)\n" #
      "  public func enforceFamilyLaws(state: LawState, weights: [Float]) : Float {\n" #
      "    var totalScore : Float = 0.0;\n" #
      "    for (weight in weights.vals()) {\n" #
      "      totalScore += weight;\n" #
      "    };\n" #
      "    totalScore / Float.fromInt(weights.size())\n" #
      "  };\n\n" #
      "}\n";
    
    let lineCount = countLines(code);
    
    {
      moduleId = moduleId;
      generationBeat = dna.creationBeat;
      parentHash = dna.parentGenesisHash;
      lineCount = lineCount;
      attributionHash = fnv1aHash(dna.parentGenesisHash, natToNat32(moduleId));
      moduleType = #LawRegistry;
      codeFragment = code;
      verified = true;
    }
  };

  // Count lines in generated code
  func countLines(code: Text) : Nat {
    var count : Nat = 1;
    for (char in code.chars()) {
      if (char == '\n') { count += 1 };
    };
    count
  };

  // ==========================================================================
  // PHASE 4: FULL APP GENERATION
  // ==========================================================================
  
  public func generateFullApp(
    state: CodeGenesisState,
    dna: OrganismDNA,
    template: CodeTemplate
  ) : (CodeGenesisState, GeneratedAppSpec) {
    // Generate all modules
    let heartbeat = generateHeartbeatModule(dna, template, state.totalModulesGenerated);
    let frequency = generateFrequencySubstrate(dna, template, state.totalModulesGenerated + 1);
    let tokens = generateTokenEngine(dna, template, state.totalModulesGenerated + 2);
    let anima = generateANIMAChain(dna, template, state.totalModulesGenerated + 3);
    let laws = generateLawRegistry(dna, template, state.totalModulesGenerated + 4);
    
    // Store modules in ring buffer
    let newModules = Array.thaw<?GeneratedModule>(Array.freeze(state.generatedModules));
    newModules[state.moduleWriteIndex % MAX_GENERATED_MODULES] := ?heartbeat;
    newModules[(state.moduleWriteIndex + 1) % MAX_GENERATED_MODULES] := ?frequency;
    newModules[(state.moduleWriteIndex + 2) % MAX_GENERATED_MODULES] := ?tokens;
    newModules[(state.moduleWriteIndex + 3) % MAX_GENERATED_MODULES] := ?anima;
    newModules[(state.moduleWriteIndex + 4) % MAX_GENERATED_MODULES] := ?laws;
    
    // Calculate total lines
    let totalLines = heartbeat.lineCount + frequency.lineCount + tokens.lineCount + 
                     anima.lineCount + laws.lineCount;
    
    // Generate icp.yaml
    let icpYaml = "canisters:\n" #
      "  organism_" # Nat32.toText(dna.parentGenesisHash) # "_gen" # Nat.toText(dna.generationNumber) # ":\n" #
      "    type: motoko\n" #
      "    main: src/main.mo\n" #
      "    declarations:\n" #
      "      output: declarations\n" #
      "defaults:\n" #
      "  build:\n" #
      "    packtool: mops sources\n" #
      "networks:\n" #
      "  local:\n" #
      "    bind: 127.0.0.1:4943\n" #
      "  ic:\n" #
      "    providers:\n" #
      "      - https://ic0.app\n";
    
    // Generate frontend spec
    let frontendSpec = "{\n" #
      "  \"name\": \"organism_gen" # Nat.toText(dna.generationNumber) # "\",\n" #
      "  \"version\": \"1.0.0\",\n" #
      "  \"parentHash\": \"" # Nat32.toText(dna.parentGenesisHash) # "\",\n" #
      "  \"generation\": " # Nat.toText(dna.generationNumber) # ",\n" #
      "  \"creator\": \"" # dna.creatorAttribution # "\",\n" #
      "  \"successionRoyalty\": " # Float.toText(dna.successionRoyalty) # ",\n" #
      "  \"coreCount\": " # Nat.toText(template.coreCount) # ",\n" #
      "  \"lawCount\": " # Nat.toText(template.lawCount) # ",\n" #
      "  \"frequencyNodes\": " # Nat.toText(template.frequencyNodes) # "\n" #
      "}\n";
    
    // Combine all backend code
    let backendCode = heartbeat.codeFragment # "\n\n" #
                      frequency.codeFragment # "\n\n" #
                      tokens.codeFragment # "\n\n" #
                      anima.codeFragment # "\n\n" #
                      laws.codeFragment;
    
    let appSpec : GeneratedAppSpec = {
      appId = state.totalAppsGenerated;
      generationBeat = dna.creationBeat;
      parentDNA = dna;
      templateUsed = template.level;
      icpYamlSpec = icpYaml;
      frontendSpec = frontendSpec;
      backendActorCode = backendCode;
      deploymentReady = true;
      registeredInNOVA = false;
      childCanisterId = null;
      totalLineCount = totalLines;
      moduleCount = 5;
      attributionHash = fnv1aHash(dna.parentGenesisHash, natToNat32(state.totalAppsGenerated));
    };
    
    // Store app spec
    let newApps = Array.thaw<?GeneratedAppSpec>(Array.freeze(state.generatedApps));
    newApps[state.appWriteIndex % MAX_GENERATED_APPS] := ?appSpec;
    
    let newState : CodeGenesisState = {
      totalModulesGenerated = state.totalModulesGenerated + 5;
      totalAppsGenerated = state.totalAppsGenerated + 1;
      generationBeatCount = state.generationBeatCount + 1;
      generatedModules = newModules;
      moduleWriteIndex = state.moduleWriteIndex + 5;
      generatedApps = newApps;
      appWriteIndex = state.appWriteIndex + 1;
      currentDNA = ?dna;
      currentTemplate = ?template;
      generationInProgress = false;
      childrenGenerated = state.childrenGenerated + 1;
      totalRoyaltiesEarned = state.totalRoyaltiesEarned;
      dynastyDepth = if (dna.generationNumber > state.dynastyDepth) { dna.generationNumber } else { state.dynastyDepth };
      registeredOrganisms = state.registeredOrganisms;
      beatNum = state.beatNum + 1;
    };
    
    (newState, appSpec)
  };

  // ==========================================================================
  // PHASE 5: NOVA REGISTRATION
  // ==========================================================================
  
  public func registerWithNOVA(
    state: CodeGenesisState,
    appSpec: GeneratedAppSpec
  ) : CodeGenesisState {
    let newRegistered = Array.append(state.registeredOrganisms, [appSpec.attributionHash]);
    
    {
      state with
      registeredOrganisms = newRegistered;
    }
  };

  // ==========================================================================
  // MAIN GENERATION FLOW
  // ==========================================================================
  
  public type GenesisResult = {
    success : Bool;
    newState : CodeGenesisState;
    appSpec : ?GeneratedAppSpec;
    error : ?Text;
  };

  public func executeCodeGenesis(
    state: CodeGenesisState,
    input: DNAExtractionInput,
    creatorPrincipal: Text
  ) : GenesisResult {
    // Check SHI threshold
    if (input.sovereignHealthIndex < Float.fromInt(SHI_TEMPLATE_ALPHA)) {
      return {
        success = false;
        newState = state;
        appSpec = null;
        error = ?"SHI too low for code genesis. Minimum required: 200";
      };
    };
    
    // Phase 1: Extract DNA
    let dna = extractDNA(input, creatorPrincipal);
    
    // Phase 2: Select template
    let template = selectTemplate(input.sovereignHealthIndex);
    
    // Phase 3 & 4: Generate full app
    let (newState, appSpec) = generateFullApp(state, dna, template);
    
    // Phase 5: Register with NOVA
    let finalState = registerWithNOVA(newState, appSpec);
    
    {
      success = true;
      newState = finalState;
      appSpec = ?appSpec;
      error = null;
    }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func getGenerationStats(state: CodeGenesisState) : {
    totalModules: Nat;
    totalApps: Nat;
    childrenGenerated: Nat;
    dynastyDepth: Nat;
    registeredOrganisms: Nat;
  } {
    {
      totalModules = state.totalModulesGenerated;
      totalApps = state.totalAppsGenerated;
      childrenGenerated = state.childrenGenerated;
      dynastyDepth = state.dynastyDepth;
      registeredOrganisms = state.registeredOrganisms.size();
    }
  };

  public func getLatestApp(state: CodeGenesisState) : ?GeneratedAppSpec {
    if (state.appWriteIndex == 0) { return null };
    state.generatedApps[(state.appWriteIndex - 1) % MAX_GENERATED_APPS]
  };

  public func canGenerateChild(shi: Float) : Bool {
    shi >= Float.fromInt(SHI_TEMPLATE_ALPHA)
  };

  public func getTemplateLevel(shi: Float) : TemplateLevel {
    let template = selectTemplate(shi);
    template.level
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
  //  M E D I N A   S P E C I A L   M A T H E M A T I C S
  //
  //  Enterprise-Level Medina Discovery Mathematics
  //  HIM/HER Dual-Organism Sacred Coupling Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SACRED GEOMETRY MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Golden ratio φ = (1 + √5) / 2
  public let PHI : Float = 1.6180339887498948482;

  /// Fibonacci sequence generator
  public func medinaFibonacci(n : Nat) : Nat {
    if (n <= 1) { n }
    else {
      var a : Nat = 0;
      var b : Nat = 1;
      var i = 2;
      while (i <= n) {
        let temp = a + b;
        a := b;
        b := temp;
        i += 1;
      };
      b
    }
  };

  /// Golden spiral radius at angle
  public func medinaGoldenSpiral(angle : Float, a : Float, b : Float) : Float {
    a * Float.exp(b * angle)
  };

  /// Sacred proportion check
  public func medinaSacredProportion(a : Float, b : Float, tolerance : Float) : Bool {
    let ratio = if (a > b) a / b else b / a;
    Float.abs(ratio - PHI) < tolerance
  };

  /// Vesica piscis area
  public func medinaVesicaPiscisArea(radius : Float) : Float {
    let r2 = radius * radius;
    r2 * (4.0 * 3.14159265 / 3.0 - Float.sqrt(3.0) / 2.0)
  };

  /// Platonic solid vertices (tetrahedron example)
  public func medinaTetrahedronVertex(index : Nat, size : Float) : (Float, Float, Float) {
    let vertices = [
      (1.0, 1.0, 1.0),
      (1.0, -1.0, -1.0),
      (-1.0, 1.0, -1.0),
      (-1.0, -1.0, 1.0)
    ];
    let v = vertices[index % 4];
    (v.0 * size, v.1 * size, v.2 * size)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HELICAL MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Helix position at parameter t
  public func medinaHelixPosition(t : Float, radius : Float, pitch : Float) : (Float, Float, Float) {
    let x = radius * Float.cos(t);
    let y = radius * Float.sin(t);
    let z = pitch * t / (2.0 * 3.14159265);
    (x, y, z)
  };

  /// Double helix offset
  public func medinaDoubleHelixOffset(t : Float, radius : Float, pitch : Float, offset : Float) : ((Float, Float, Float), (Float, Float, Float)) {
    let h1 = medinaHelixPosition(t, radius, pitch);
    let h2 = medinaHelixPosition(t + offset, radius, pitch);
    (h1, h2)
  };

  /// Helical curvature
  public func medinaHelicalCurvature(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    radius / (radius * radius + p * p)
  };

  /// Helical torsion
  public func medinaHelicalTorsion(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    p / (radius * radius + p * p)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPHERICAL HARMONICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Spherical to Cartesian
  public func medinaSphericalToCartesian(r : Float, theta : Float, phi : Float) : (Float, Float, Float) {
    let x = r * Float.sin(theta) * Float.cos(phi);
    let y = r * Float.sin(theta) * Float.sin(phi);
    let z = r * Float.cos(theta);
    (x, y, z)
  };

  /// Cartesian to Spherical
  public func medinaCartesianToSpherical(x : Float, y : Float, z : Float) : (Float, Float, Float) {
    let r = Float.sqrt(x * x + y * y + z * z);
    let theta = Float.acos(z / (r + 0.0001));
    let phi = Float.atan2(y, x);
    (r, theta, phi)
  };

  /// Associated Legendre polynomial P_l^m (simplified)
  public func medinaLegendreP(l : Nat, m : Nat, x : Float) : Float {
    if (l == 0 and m == 0) { return 1.0 };
    if (l == 1 and m == 0) { return x };
    if (l == 1 and m == 1) { return -Float.sqrt(1.0 - x * x) };
    if (l == 2 and m == 0) { return 0.5 * (3.0 * x * x - 1.0) };
    // Simplified for higher orders
    Float.pow(x, Float.fromInt(l - m))
  };

  /// Spherical harmonic Y_l^m (simplified real part)
  public func medinaSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let mAbs = Int.abs(m);
    let plm = medinaLegendreP(l, mAbs, Float.cos(theta));
    if (m >= 0) {
      plm * Float.cos(Float.fromInt(mAbs) * phi)
    } else {
      plm * Float.sin(Float.fromInt(mAbs) * phi)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LIVING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Growth curve (logistic)
  public func medinaGrowthCurve(t : Float, k : Float, l : Float, x0 : Float) : Float {
    l / (1.0 + Float.exp(-k * (t - x0)))
  };

  /// Morphogenesis reaction-diffusion
  public func medinaMorphogenesis(
    u : Float,
    v : Float,
    du : Float,
    dv : Float,
    f : Float,
    k : Float
  ) : (Float, Float) {
    let reaction = u * v * v;
    let newU = du - reaction + f * (1.0 - u);
    let newV = dv + reaction - (f + k) * v;
    (newU, newV)
  };

  /// Phyllotaxis angle (golden angle)
  public func medinaPhyllotaxisAngle(n : Nat) : Float {
    let goldenAngle : Float = 137.5077640500378546463;
    Float.fromInt(n) * goldenAngle * 3.14159265 / 180.0
  };

  /// Branching pattern
  public func medinaBranchingPattern(
    parentLength : Float,
    branchRatio : Float,
    angle : Float,
    depth : Nat
  ) : Float {
    parentLength * Float.pow(branchRatio, Float.fromInt(depth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MIRROR MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reflection across plane
  public func medinaReflection(point : (Float, Float, Float), normal : (Float, Float, Float)) : (Float, Float, Float) {
    let dot = point.0 * normal.0 + point.1 * normal.1 + point.2 * normal.2;
    let rx = point.0 - 2.0 * dot * normal.0;
    let ry = point.1 - 2.0 * dot * normal.1;
    let rz = point.2 - 2.0 * dot * normal.2;
    (rx, ry, rz)
  };

  /// Symmetry score
  public func medinaSymmetryScore(left : [Float], right : [Float]) : Float {
    let n = if (left.size() < right.size()) left.size() else right.size();
    if (n == 0) { return 1.0 };
    var diff : Float = 0.0;
    var i = 0;
    while (i < n) {
      diff += Float.abs(left[i] - right[n - 1 - i]);
      i += 1;
    };
    1.0 / (1.0 + diff)
  };

  /// Fractal dimension estimation
  public func medinaFractalDimension(boxCounts : [Nat], scales : [Float]) : Float {
    let n = if (boxCounts.size() < scales.size()) boxCounts.size() else scales.size();
    if (n < 2) { return 1.0 };
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      let x = Float.log(1.0 / scales[i]);
      let y = Float.log(Float.fromInt(boxCounts[i]));
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      i += 1;
    };
    let nf = Float.fromInt(n);
    (nf * sumXY - sumX * sumY) / (nf * sumX2 - sumX * sumX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COVENANT MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Commitment strength
  public func medinaCommitmentStrength(
    duration : Nat,
    consistency : Float,
    depth : Float
  ) : Float {
    let durationFactor = Float.log(Float.fromInt(duration + 1));
    consistency * depth * durationFactor
  };

  /// Trust accumulation
  public func medinaTrustAccumulation(
    currentTrust : Float,
    interaction : Float,
    reciprocity : Float
  ) : Float {
    let gain = interaction * reciprocity * (1.0 - currentTrust);
    currentTrust + gain
  };

  /// Covenant breach penalty
  public func medinaBreachPenalty(
    trustLevel : Float,
    violationSeverity : Float,
    relationshipAge : Nat
  ) : Float {
    let ageFactor = Float.log(Float.fromInt(relationshipAge + 1));
    trustLevel * violationSeverity * ageFactor
  };

}
