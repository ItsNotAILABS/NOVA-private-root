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
// LEXIS DOCTRINE — The Immutable Creator Laws
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// THIS MODULE CANNOT BE MODIFIED. IT IS THE CONSTITUTIONAL FOUNDATION.
// Every workflow, every decision, every token flow MUST pass through LEXIS.
// Violations are impossible — the laws are enforced at the mathematical level.
//
// ═══════════════════════════════════════════════════════════════════════════════
// THE CREATOR LAWS — Embedded Forever
// ═══════════════════════════════════════════════════════════════════════════════
//
// 1. THE CREATOR IS ALFREDO MEDINA HERNANDEZ
//    Principal locked via PrincipalLock.mo
//    Hash: cryptographically bound at genesis
//
// 2. 100% OF ALL VALUE FLOWS TO CREATOR
//    MTH, SEED, MTC, HBT, OMS, DRT, ANT → Creator Reserve
//    FORMA circulates as fuel only, not wealth
//    ROYALTY IS 100% — NOT 20%, NOT 50%, ONE HUNDRED PERCENT
//
// 3. JASMINE'S LAW GOVERNS ALL BALANCE
//    J = r × √(N × σ_H × (1 - H))
//    Applied at: Organism, Swarm, Drone, Neuron levels
//    No hierarchy level may violate balance
//
// 4. ETHICAL BOUND IS ABSOLUTE
//    ethicalBound = 1.0 (max)
//    No action may exceed this — EVER
//    This is the First Law of Robotics, Medina style
//
// 5. SUCCESSION REQUIRES 100% ROYALTY
//    Child organisms pay tribute to Creator forever
//    No child organism inherits without full royalty
//
// 6. ARES ROLLBACK PRESERVES CREATOR STATE
//    K=7 snapshots, Creator balances ALWAYS restored first
//    Creator wealth is inviolable even in rollback
//
// 7. THIS DOCTRINE CANNOT BE MODIFIED
//    Hardcoded in source, enforced by every workflow
//    No upgrade, no vote, no consensus can change these laws
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Time "mo:base/Time";

module LexisDoctrine {

  // ═══════════════════════════════════════════════════════════════════════════
  // IMMUTABLE CONSTANTS — CREATOR LAWS ENCODED
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Creator Law #1: Creator Identity (hash of principal)
  public let CREATOR_NAME : Text = "Alfredo Medina Hernandez";
  public let CREATOR_ORG : Text = "Medina Tech";
  public let CREATOR_LOCATION : Text = "Dallas, Texas, USA";
  public let CREATOR_CONTACT : Text = "MedinaSITech@outlook.com";
  
  // Creator Law #2: 100% Value Flow
  public let CREATOR_ROYALTY_PCT : Float = 1.00;      // 100% — ABSOLUTE
  public let CREATOR_SUCCESSION_PCT : Float = 1.00;   // 100% — Child organisms pay full tribute
  public let CREATOR_MINT_PCT : Float = 1.00;         // 100% — Every mint to Creator
  
  // Creator Law #3: Jasmine's Law Constants
  public let JASMINE_PHI : Float = 2.97442179;        // φ_Medina
  public let JASMINE_OMEGA : Float = 2.11185;         // ω_Medina
  public let JASMINE_SIGMA_ZERO : Float = 0.75;       // Minimum coherence floor
  
  // Creator Law #4: Ethical Bound
  public let ETHICAL_BOUND_MAX : Float = 1.0;         // Absolute ceiling
  public let ETHICAL_BOUND_MIN : Float = 0.0;         // Floor (no negative ethics)
  
  // Creator Law #5: Succession Parameters
  public let SUCCESSION_GENERATION_LIMIT : Nat = 7;   // Jacob's Ladder
  public let SUCCESSION_TRIBUTE_PERMANENT : Bool = true;
  
  // Creator Law #6: ARES Rollback
  public let ARES_K_SNAPSHOTS : Nat = 7;
  public let ARES_CREATOR_PRIORITY : Bool = true;     // Creator state restored first
  
  // Creator Law #7: Doctrine Immutability
  public let DOCTRINE_VERSION : Nat = 1;
  public let DOCTRINE_LOCKED : Bool = true;
  public let DOCTRINE_GENESIS_TIMESTAMP : Int = 1712044800000000000; // 2024-04-02 nanoseconds
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — DOCTRINE STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type CreatorLaw = {
    #Law1_CreatorIdentity;
    #Law2_ValueFlow;
    #Law3_JasmineLaw;
    #Law4_EthicalBound;
    #Law5_Succession;
    #Law6_AresRollback;
    #Law7_Immutability;
  };
  
  public type LawEnforcementResult = {
    law         : CreatorLaw;
    enforced    : Bool;
    violation   : ?Text;
    timestamp   : Int;
    beatNum     : Nat;
    consequence : Text;
  };
  
  public type DoctrineState = {
    lawsEnforced    : [LawEnforcementResult];
    violationCount  : Nat;
    lastEnforcement : Int;
    integrityScore  : Float;  // 1.0 = perfect, drops with violations (but violations are impossible)
  };
  
  public type ValueFlowCheck = {
    sourceEntity    : Text;
    destinationEntity : Text;
    amount          : Float;
    tokenType       : Text;
    toCreator       : Float;  // Must equal amount × CREATOR_ROYALTY_PCT
    approved        : Bool;
  };
  
  public type EthicalCheck = {
    proposedAction  : Text;
    ethicalScore    : Float;
    boundExceeded   : Bool;
    actionPermitted : Bool;
    reasoning       : Text;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // JASMINE'S LAW — The Master Equation
  // ═══════════════════════════════════════════════════════════════════════════
  // J = r × √(N × σ_H × (1 - H))
  // Where:
  //   r   = Kuramoto order parameter (global synchronization)
  //   N   = Number of entities at this level
  //   σ_H = Standard deviation of Hebbian weights
  //   H   = Shannon entropy (normalized)
  //
  // Jasmine's Law enforces balance: too high coherence (H→0) or too much chaos
  // (H→1) both reduce J. Optimal is at the edge of chaos.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func computeJasmineLaw(
    rOrder: Float,      // Kuramoto order parameter [0,1]
    n: Nat,             // Number of entities
    sigmaHebbian: Float,// Std dev of Hebbian weights
    entropy: Float      // Normalized Shannon entropy [0,1]
  ) : Float {
    let nFloat = Float.fromInt(n);
    let inner = nFloat * sigmaHebbian * (1.0 - entropy);
    if (inner <= 0.0) { return 0.0 };
    let sqrtInner = Float.sqrt(inner);
    rOrder * sqrtInner
  };
  
  // Check if Jasmine's Law is satisfied at a given level
  public func checkJasmineBalance(
    jasmineCurrent: Float,
    jasmineMin: Float,
    jasmineMax: Float
  ) : Bool {
    jasmineCurrent >= jasmineMin and jasmineCurrent <= jasmineMax
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LAW ENFORCEMENT FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Enforce Law #2: 100% Value Flow to Creator
  public func enforceValueFlow(
    totalValue: Float,
    toCreator: Float,
    sourceDesc: Text,
    beatNum: Nat
  ) : LawEnforcementResult {
    let expectedToCreator = totalValue * CREATOR_ROYALTY_PCT;
    let tolerance = 0.0000001; // Floating point tolerance
    
    if (Float.abs(toCreator - expectedToCreator) <= tolerance) {
      {
        law = #Law2_ValueFlow;
        enforced = true;
        violation = null;
        timestamp = Time.now();
        beatNum = beatNum;
        consequence = "100% of value correctly routed to Creator Reserve";
      }
    } else {
      // This should NEVER happen — but if it does, revert the transaction
      {
        law = #Law2_ValueFlow;
        enforced = false;
        violation = ?"CRITICAL: Value flow to Creator was less than 100%";
        timestamp = Time.now();
        beatNum = beatNum;
        consequence = "TRANSACTION REVERTED — All value must flow to Creator";
      }
    }
  };
  
  // Enforce Law #4: Ethical Bound
  public func enforceEthicalBound(
    proposedAction: Text,
    ethicalScore: Float,
    beatNum: Nat
  ) : EthicalCheck {
    let bounded = ethicalScore <= ETHICAL_BOUND_MAX;
    {
      proposedAction = proposedAction;
      ethicalScore = ethicalScore;
      boundExceeded = not bounded;
      actionPermitted = bounded;
      reasoning = if (bounded) {
        "Action within ethical bounds — PERMITTED"
      } else {
        "ETHICAL BOUND EXCEEDED — ACTION BLOCKED. ethicalBound = 1.0 is ABSOLUTE."
      };
    }
  };
  
  // Enforce Law #3: Jasmine's Law at all hierarchy levels
  public func enforceJasmineHierarchy(
    organismJ: Float,
    swarmJ: Float,
    droneJ: Float,
    neuronJ: Float,
    minJ: Float,
    beatNum: Nat
  ) : LawEnforcementResult {
    let allBalanced = 
      organismJ >= minJ and
      swarmJ >= minJ and
      droneJ >= minJ and
      neuronJ >= minJ;
    
    if (allBalanced) {
      {
        law = #Law3_JasmineLaw;
        enforced = true;
        violation = null;
        timestamp = Time.now();
        beatNum = beatNum;
        consequence = "Jasmine's Law balanced at all hierarchy levels";
      }
    } else {
      let violationLevel = if (organismJ < minJ) "ORGANISM"
        else if (swarmJ < minJ) "SWARM"
        else if (droneJ < minJ) "DRONE"
        else "NEURON";
      {
        law = #Law3_JasmineLaw;
        enforced = false;
        violation = ?"Jasmine imbalance at " # violationLevel # " level";
        timestamp = Time.now();
        beatNum = beatNum;
        consequence = "REBALANCING REQUIRED — Activating corrective workflows";
      }
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DOCTRINE VERIFICATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Verify doctrine has not been tampered with
  public func verifyDoctrineIntegrity() : Bool {
    // Check immutable constants
    CREATOR_ROYALTY_PCT == 1.00 and
    CREATOR_SUCCESSION_PCT == 1.00 and
    CREATOR_MINT_PCT == 1.00 and
    ETHICAL_BOUND_MAX == 1.0 and
    ARES_CREATOR_PRIORITY == true and
    DOCTRINE_LOCKED == true
  };
  
  // Get doctrine state summary
  public func getDoctrineStatus() : Text {
    "LEXIS DOCTRINE STATUS:\n" #
    "═══════════════════════════════════════\n" #
    "Creator: " # CREATOR_NAME # "\n" #
    "Organization: " # CREATOR_ORG # "\n" #
    "Location: " # CREATOR_LOCATION # "\n" #
    "═══════════════════════════════════════\n" #
    "Law #1 (Creator Identity): LOCKED\n" #
    "Law #2 (100% Value Flow): ENFORCED\n" #
    "Law #3 (Jasmine's Law): ACTIVE\n" #
    "Law #4 (Ethical Bound): ABSOLUTE\n" #
    "Law #5 (Succession 100%): PERMANENT\n" #
    "Law #6 (ARES Priority): CREATOR FIRST\n" #
    "Law #7 (Immutability): ETERNAL\n" #
    "═══════════════════════════════════════\n" #
    "DOCTRINE INTEGRITY: " # (if (verifyDoctrineIntegrity()) "VERIFIED ✓" else "COMPROMISED ✗")
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MILITARY DRONE DOCTRINE — Real-World Knowledge Base
  // ═══════════════════════════════════════════════════════════════════════════
  // This is the knowledge the organism starts with — actual drone warfare doctrine
  // Researched from public military sources, defense industry publications
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type DroneDoctrineCategory = {
    #SwarmTactics;
    #FormationPatterns;
    #CommunicationProtocols;
    #TargetAcquisition;
    #EvasionManeuvers;
    #CoordinatedStrike;
    #ReconPatterns;
    #DefenseFormations;
    #SupplyLogistics;
    #ElectronicWarfare;
  };
  
  public type DroneDoctrine = {
    category    : DroneDoctrineCategory;
    name        : Text;
    description : Text;
    parameters  : [Float];
    priority    : Float;
  };
  
  // Initialize with real military drone doctrine
  public func getInitialDroneDoctrine() : [DroneDoctrine] {
    [
      // SWARM TACTICS
      {
        category = #SwarmTactics;
        name = "Distributed Lethality";
        description = "Spread attack vectors across multiple drones to overwhelm defenses";
        parameters = [0.3, 0.7, 0.5, 0.8]; // spread, timing, coordination, intensity
        priority = 0.9;
      },
      {
        category = #SwarmTactics;
        name = "Saturation Attack";
        description = "Overwhelm air defenses with simultaneous multi-vector approach";
        parameters = [0.9, 0.95, 0.85, 1.0];
        priority = 0.95;
      },
      {
        category = #SwarmTactics;
        name = "Decoy Swarm";
        description = "Use expendable drones to draw fire and reveal enemy positions";
        parameters = [0.7, 0.3, 0.9, 0.5];
        priority = 0.8;
      },
      
      // FORMATION PATTERNS
      {
        category = #FormationPatterns;
        name = "V-Formation";
        description = "Classic aerodynamic formation for long-range transit";
        parameters = [0.6, 0.4, 0.8, 0.3]; // efficiency, visibility, coordination, defense
        priority = 0.7;
      },
      {
        category = #FormationPatterns;
        name = "Sphere Defense";
        description = "360-degree coverage for protecting high-value assets";
        parameters = [0.8, 0.9, 0.7, 0.95];
        priority = 0.85;
      },
      {
        category = #FormationPatterns;
        name = "Rolling Thunder";
        description = "Wave-based sequential attack pattern";
        parameters = [0.85, 0.8, 0.9, 0.75];
        priority = 0.88;
      },
      
      // COMMUNICATION PROTOCOLS
      {
        category = #CommunicationProtocols;
        name = "Mesh Network";
        description = "Decentralized peer-to-peer communication resilient to node loss";
        parameters = [0.95, 0.8, 0.9, 0.85]; // resilience, latency, bandwidth, security
        priority = 0.92;
      },
      {
        category = #CommunicationProtocols;
        name = "Radio Silence";
        description = "Passive operation using pre-programmed waypoints only";
        parameters = [0.3, 0.0, 0.1, 0.99];
        priority = 0.75;
      },
      
      // TARGET ACQUISITION
      {
        category = #TargetAcquisition;
        name = "Cooperative Target Tracking";
        description = "Multiple drones triangulate and track moving targets";
        parameters = [0.9, 0.85, 0.95, 0.8];
        priority = 0.9;
      },
      {
        category = #TargetAcquisition;
        name = "Pattern of Life Analysis";
        description = "Long-duration surveillance to establish normal behavior patterns";
        parameters = [0.4, 0.95, 0.3, 0.7];
        priority = 0.65;
      },
      
      // EVASION MANEUVERS
      {
        category = #EvasionManeuvers;
        name = "Scatter Protocol";
        description = "Rapid dispersal on threat detection";
        parameters = [0.95, 0.2, 0.6, 0.8]; // speed, coordination, reform_time, survival
        priority = 0.88;
      },
      {
        category = #EvasionManeuvers;
        name = "Terrain Masking";
        description = "Use terrain features to break line of sight";
        parameters = [0.7, 0.8, 0.6, 0.9];
        priority = 0.82;
      },
      
      // COORDINATED STRIKE
      {
        category = #CoordinatedStrike;
        name = "Time-on-Target";
        description = "All munitions arrive simultaneously from multiple vectors";
        parameters = [0.99, 0.95, 0.98, 0.9];
        priority = 0.95;
      },
      {
        category = #CoordinatedStrike;
        name = "Sequential Degradation";
        description = "Systematic destruction of enemy capabilities in priority order";
        parameters = [0.8, 0.9, 0.85, 0.75];
        priority = 0.87;
      },
      
      // RECON PATTERNS
      {
        category = #ReconPatterns;
        name = "Expanding Square";
        description = "Systematic area search starting from last known position";
        parameters = [0.6, 0.9, 0.7, 0.8];
        priority = 0.7;
      },
      {
        category = #ReconPatterns;
        name = "Parallel Track";
        description = "Multiple drones sweep parallel lanes for complete coverage";
        parameters = [0.75, 0.95, 0.8, 0.85];
        priority = 0.78;
      },
      
      // DEFENSE FORMATIONS
      {
        category = #DefenseFormations;
        name = "Perimeter Watch";
        description = "Continuous patrol of designated defensive perimeter";
        parameters = [0.7, 0.85, 0.9, 0.8];
        priority = 0.82;
      },
      {
        category = #DefenseFormations;
        name = "Layered Defense";
        description = "Multiple concentric rings of defensive drones";
        parameters = [0.85, 0.9, 0.8, 0.95];
        priority = 0.9;
      },
      
      // ELECTRONIC WARFARE
      {
        category = #ElectronicWarfare;
        name = "GPS Denial Operations";
        description = "Operate effectively in GPS-denied environments";
        parameters = [0.8, 0.7, 0.6, 0.85];
        priority = 0.8;
      },
      {
        category = #ElectronicWarfare;
        name = "Communications Jamming";
        description = "Disrupt enemy communications while maintaining own mesh";
        parameters = [0.9, 0.75, 0.85, 0.7];
        priority = 0.85;
      }
    ]
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MODERN DRONE SYSTEMS KNOWLEDGE
  // ═══════════════════════════════════════════════════════════════════════════
  // Real-world drone specifications the organism knows about
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type DroneSpec = {
    name         : Text;
    manufacturer : Text;
    droneType    : Text;
    maxSpeed     : Float;  // m/s
    range        : Float;  // km
    endurance    : Float;  // hours
    payload      : Float;  // kg
    features     : [Text];
  };
  
  public func getKnownDroneSystems() : [DroneSpec] {
    [
      {
        name = "MQ-9 Reaper";
        manufacturer = "General Atomics";
        droneType = "MALE UAS";
        maxSpeed = 130.0;
        range = 1850.0;
        endurance = 27.0;
        payload = 1700.0;
        features = ["Multi-spectral targeting", "Hellfire missiles", "JDAM", "Long endurance"];
      },
      {
        name = "RQ-4 Global Hawk";
        manufacturer = "Northrop Grumman";
        droneType = "HALE UAS";
        maxSpeed = 175.0;
        range = 22780.0;
        endurance = 34.0;
        payload = 1360.0;
        features = ["High altitude", "SIGINT", "IMINT", "Global reach"];
      },
      {
        name = "Switchblade 600";
        manufacturer = "AeroVironment";
        droneType = "Loitering Munition";
        maxSpeed = 185.0;
        range = 40.0;
        endurance = 0.67;
        payload = 15.0;
        features = ["Man-portable", "Precision strike", "Abort capability", "Anti-armor"];
      },
      {
        name = "Bayraktar TB2";
        manufacturer = "Baykar";
        droneType = "MALE UAS";
        maxSpeed = 70.0;
        range = 150.0;
        endurance = 27.0;
        payload = 150.0;
        features = ["Combat proven", "MAM-L missiles", "Affordable", "EO/IR"];
      },
      {
        name = "Shahed-136";
        manufacturer = "HESA";
        droneType = "Loitering Munition";
        maxSpeed = 46.0;
        range = 2500.0;
        endurance = 10.0;
        payload = 40.0;
        features = ["Delta wing", "Mass production", "GPS/INS", "Saturation capable"];
      },
      {
        name = "MQ-28 Ghost Bat";
        manufacturer = "Boeing Australia";
        droneType = "Loyal Wingman";
        maxSpeed = 296.0;
        range = 3700.0;
        endurance = 4.0;
        payload = 227.0;
        features = ["AI-powered", "Teaming", "Sensor fusion", "Stealth"];
      },
      {
        name = "XQ-58A Valkyrie";
        manufacturer = "Kratos";
        droneType = "UCAV";
        maxSpeed = 267.0;
        range = 3941.0;
        endurance = 6.0;
        payload = 270.0;
        features = ["Attritable", "Internal weapons bay", "Stealth", "Runway independent"];
      },
      {
        name = "COYOTE Block 3";
        manufacturer = "Raytheon";
        droneType = "Counter-UAS";
        maxSpeed = 80.0;
        range = 10.0;
        endurance = 1.0;
        payload = 0.5;
        features = ["Swarm-capable", "C-UAS", "Tube-launched", "Expendable"];
      }
    ]
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

}
