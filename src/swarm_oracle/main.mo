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

// PARALLAX DRONE SWARM — SWARM ORACLE
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// SWARM ORACLE (ORACULUM GREGIS)
// ═══════════════════════════════════════════════════════════════════════
// Unified read-only information canister. Every public information
// endpoint is declared as `query` or `composite query` — no caller
// can ever mutate swarm state through this interface.
//
// Composite queries fan out to the registered peer canisters and
// return pure information snapshots. The oracle itself holds NO
// operational state; it is a sovereign lens over the swarm.
//
// PUBLIC READ API  (query / composite query — zero side-effects):
//   getOracleSeal()               — local identity
//   getOracleGenesis()            — registration status
//   getCanisterRegistry()         — registered peer principals
//   getBrainSwarmSnapshot()       — swarm_brain drone field
//   getBrainExtendedSnapshot()    — swarm_brain extended metrics
//   getBrainTeamSnapshot()        — swarm_brain team / morale
//   getBrainQMetrics()            — swarm_brain quantum cognitive
//   getBrainFrequencyTier()       — swarm_brain Hz tier
//   getBrainSacesiOutput()        — swarm_brain SACESI scalar
//   getBrainJasmineVector()       — swarm_brain Jasmine drift
//   getBrainOmnis()               — swarm_brain OMNIS emergence
//   getBrainKfHz()                — swarm_brain Kuramoto order
//   getBrainCompliance()          — swarm_brain law compliance
//   getOrganismOrgans()           — swarm_organism 18-organ grid
//   getOrganismNeuroChem()        — swarm_organism hormones
//   getOrganismMetals()           — swarm_organism metal outputs
//   getOrganismHive()             — swarm_organism hive state
//   getOrganismAnt()              — swarm_organism ACO state
//   getOrganismMode()             — swarm_organism mode text
//   getCommandSnapshot()          — swarm_command mission state
//   getCommandWaypoints()         — swarm_command waypoint list
//   getMetalsSnapshot()           — swarm_metals resonance vector
//   getAuditEntryCount()          — swarm_audit log size
//   getAuditRecentEntries(n)      — swarm_audit last N entries
//   getTelemetryDroneCount()      — swarm_telemetry fleet size
//   getTelemetryAll()             — swarm_telemetry full fleet
//   getQuantumSwarmMetrics()      — swarm_quantum coherence
//   getSystemCoreDiagnostic()     — aggregated local summary
//
// ADMIN WRITE API (update, architect-only — wires oracle to peers):
//   claimOracle()
//   setBrainCanister(p)
//   setOrganismCanister(p)
//   setCommandCanister(p)
//   setMetalsCanister(p)
//   setAuditCanister(p)
//   setTelemetryCanister(p)
//   setQuantumCanister(p)

import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor SwarmOracle {

  // ─── SOVEREIGN IDENTITY ─────────────────────────────────────────────────────

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;

  // ─── CANISTER REGISTRY ───────────────────────────────────────────────────────
  // Each peer canister is registered by its Principal after deployment.
  // Until registered the composite queries return empty/zero values — never trap.

  stable var brainId     : ?Principal = null;
  stable var organismId  : ?Principal = null;
  stable var commandId   : ?Principal = null;
  stable var metalsId    : ?Principal = null;
  stable var auditId     : ?Principal = null;
  stable var telemetryId : ?Principal = null;
  stable var quantumId   : ?Principal = null;

  // ─── AUTHORIZATION ──────────────────────────────────────────────────────────

  func isAuthorized(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == architectPrincipal
  };

  func requireAuthorized(caller : Principal) {
    assert(isAuthorized(caller));
  };

  // ─── GENESIS CLAIM ──────────────────────────────────────────────────────────

  public shared(msg) func claimOracle() : async Text {
    if (genesisLocked) return "ORACLE_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-ORACLE-v1-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "ORACLE_CLAIMED: " # sovereignSeal
  };

  // ─── CANISTER REGISTRATION (architect-only update calls) ─────────────────────

  public shared(msg) func setBrainCanister(p : Principal) : async () {
    requireAuthorized(msg.caller);
    brainId := ?p;
  };

  public shared(msg) func setOrganismCanister(p : Principal) : async () {
    requireAuthorized(msg.caller);
    organismId := ?p;
  };

  public shared(msg) func setCommandCanister(p : Principal) : async () {
    requireAuthorized(msg.caller);
    commandId := ?p;
  };

  public shared(msg) func setMetalsCanister(p : Principal) : async () {
    requireAuthorized(msg.caller);
    metalsId := ?p;
  };

  public shared(msg) func setAuditCanister(p : Principal) : async () {
    requireAuthorized(msg.caller);
    auditId := ?p;
  };

  public shared(msg) func setTelemetryCanister(p : Principal) : async () {
    requireAuthorized(msg.caller);
    telemetryId := ?p;
  };

  public shared(msg) func setQuantumCanister(p : Principal) : async () {
    requireAuthorized(msg.caller);
    quantumId := ?p;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // READ-ONLY PUBLIC API — pure query and composite query only
  // ═══════════════════════════════════════════════════════════════════════════

  // ─── LOCAL ORACLE STATE (pure query — no cross-canister call) ───────────────

  public query func getOracleSeal() : async Text { sovereignSeal };

  public query func getOracleGenesis() : async {
    seal      : Text;
    architect : Text;
    timestamp : Int;
    claimed   : Bool;
  } {
    {
      seal      = sovereignSeal;
      architect = Principal.toText(architectPrincipal);
      timestamp = genesisTimestamp;
      claimed   = genesisLocked;
    }
  };

  // Returns the principal text for each registered peer canister.
  // "NOT_REGISTERED" means that canister has not been wired yet.
  public query func getCanisterRegistry() : async {
    brain     : Text;
    organism  : Text;
    command   : Text;
    metals    : Text;
    audit     : Text;
    telemetry : Text;
    quantum   : Text;
  } {
    func pid(p : ?Principal) : Text {
      switch p { case null "NOT_REGISTERED"; case (?pp) Principal.toText(pp) }
    };
    {
      brain     = pid(brainId);
      organism  = pid(organismId);
      command   = pid(commandId);
      metals    = pid(metalsId);
      audit     = pid(auditId);
      telemetry = pid(telemetryId);
      quantum   = pid(quantumId);
    }
  };

  // ─── SWARM BRAIN — composite read-only queries ────────────────────────────

  public composite query func getBrainSwarmSnapshot() : async {
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
    qChannelsAlpha : [Float];
    qChannelsBeta  : [Float];
    qChannelsGamma : [Float];
    qChannelsDelta : [Float];
    qConvergence   : [Float];
    qCoherence     : [Float];
    nowAttention   : [Float];
  } {
    switch (brainId) {
      case null {
        {
          droneCount = 0; rSwarm = 0.0; jDrift = 0.0; beat = 0;
          phases = []; signals = []; positionsX = []; positionsY = [];
          positionsZ = []; cortisolLevels = []; sacrificed = []; classes = [];
          qChannelsAlpha = []; qChannelsBeta = []; qChannelsGamma = [];
          qChannelsDelta = []; qConvergence = []; qCoherence = [];
          nowAttention = [];
        }
      };
      case (?p) {
        let brain = actor(Principal.toText(p)) : actor {
          getSwarmSnapshot : shared query () -> async {
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
            qChannelsAlpha : [Float];
            qChannelsBeta  : [Float];
            qChannelsGamma : [Float];
            qChannelsDelta : [Float];
            qConvergence   : [Float];
            qCoherence     : [Float];
            nowAttention   : [Float];
          };
        };
        await brain.getSwarmSnapshot()
      };
    }
  };

  public composite query func getBrainExtendedSnapshot() : async {
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
  } {
    switch (brainId) {
      case null {
        {
          droneCount = 0; rSwarm = 0.0; jDrift = 0.0; beat = 0;
          phases = []; signals = []; positionsX = []; positionsY = [];
          positionsZ = []; velX = []; velZ = [];
          cortisolLevels = []; dopamines = []; norepines = [];
          oxytocins = []; energies = []; behaviors = [];
          sacrificed = []; classes = []; entropy = 0.0;
        }
      };
      case (?p) {
        let brain = actor(Principal.toText(p)) : actor {
          getExtendedSnapshot : shared query () -> async {
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
          };
        };
        await brain.getExtendedSnapshot()
      };
    }
  };

  public composite query func getBrainTeamSnapshot() : async {
    captains : [Nat];
    morale   : [Float];
    entropy  : Float;
    isingM   : Float;
  } {
    switch (brainId) {
      case null { { captains = []; morale = []; entropy = 0.0; isingM = 0.0 } };
      case (?p) {
        let brain = actor(Principal.toText(p)) : actor {
          getTeamSnapshot : shared query () -> async {
            captains : [Nat];
            morale   : [Float];
            entropy  : Float;
            isingM   : Float;
          };
        };
        await brain.getTeamSnapshot()
      };
    }
  };

  public composite query func getBrainQMetrics() : async {
    swarmQCoherence  : Float;
    swarmConvergence : Float;
    swarmNowIndex    : Float;
  } {
    switch (brainId) {
      case null { { swarmQCoherence = 0.0; swarmConvergence = 0.0; swarmNowIndex = 0.0 } };
      case (?p) {
        let brain = actor(Principal.toText(p)) : actor {
          getSwarmQMetrics : shared query () -> async {
            swarmQCoherence  : Float;
            swarmConvergence : Float;
            swarmNowIndex    : Float;
          };
        };
        await brain.getSwarmQMetrics()
      };
    }
  };

  public composite query func getBrainFrequencyTier() : async { tier : Text; hz : Float } {
    switch (brainId) {
      case null { { tier = "UNKNOWN"; hz = 0.0 } };
      case (?p) {
        let brain = actor(Principal.toText(p)) : actor {
          getFrequencyTier : shared query () -> async { tier : Text; hz : Float };
        };
        await brain.getFrequencyTier()
      };
    }
  };

  public composite query func getBrainSacesiOutput() : async Float {
    switch (brainId) {
      case null { 0.0 };
      case (?p) {
        let brain = actor(Principal.toText(p)) : actor {
          getSacesiOutput : shared query () -> async Float;
        };
        await brain.getSacesiOutput()
      };
    }
  };

  public composite query func getBrainJasmineVector() : async [Float] {
    switch (brainId) {
      case null { [] };
      case (?p) {
        let brain = actor(Principal.toText(p)) : actor {
          getJasmineVector : shared query () -> async [Float];
        };
        await brain.getJasmineVector()
      };
    }
  };

  public composite query func getBrainOmnis() : async {
    fired    : Bool;
    count    : Nat;
    lastBeat : Nat;
  } {
    switch (brainId) {
      case null { { fired = false; count = 0; lastBeat = 0 } };
      case (?p) {
        let brain = actor(Principal.toText(p)) : actor {
          getOmnisFired    : shared query () -> async Bool;
          getOmnisCount    : shared query () -> async Nat;
          getLastOMNISBeat : shared query () -> async Nat;
        };
        let fired    = await brain.getOmnisFired();
        let count    = await brain.getOmnisCount();
        let lastBeat = await brain.getLastOMNISBeat();
        { fired; count; lastBeat }
      };
    }
  };

  public composite query func getBrainKfHz() : async {
    current : Float;
    history : [Float];
  } {
    switch (brainId) {
      case null { { current = 0.0; history = [] } };
      case (?p) {
        let brain = actor(Principal.toText(p)) : actor {
          getKfHzCurrent : shared query () -> async Float;
          getKfHzHistory : shared query () -> async [Float];
        };
        let current = await brain.getKfHzCurrent();
        let history = await brain.getKfHzHistory();
        { current; history }
      };
    }
  };

  public composite query func getBrainCompliance() : async {
    score            : Float;
    doctrineFingerprint : Nat32;
  } {
    switch (brainId) {
      case null { { score = 0.0; doctrineFingerprint = 0 } };
      case (?p) {
        let brain = actor(Principal.toText(p)) : actor {
          getComplianceScore     : shared query () -> async Float;
          getDoctrineFingerprint : shared query () -> async Nat32;
        };
        let score               = await brain.getComplianceScore();
        let doctrineFingerprint = await brain.getDoctrineFingerprint();
        { score; doctrineFingerprint }
      };
    }
  };

  // ─── SWARM ORGANISM — composite read-only queries ────────────────────────

  public composite query func getOrganismOrgans() : async {
    names       : [Text];
    states      : [Text];
    activations : [Float];
    outputs     : [Float];
    memory      : [Float];
  } {
    switch (organismId) {
      case null { { names = []; states = []; activations = []; outputs = []; memory = [] } };
      case (?p) {
        let org = actor(Principal.toText(p)) : actor {
          getOrganSnapshot : shared query () -> async {
            names       : [Text];
            states      : [Text];
            activations : [Float];
            outputs     : [Float];
            memory      : [Float];
          };
        };
        await org.getOrganSnapshot()
      };
    }
  };

  public composite query func getOrganismNeuroChem() : async {
    serotonin     : Float;
    gaba          : Float;
    acetylcholine : Float;
    testosterone  : Float;
    melatonin     : Float;
    t3            : Float;
    t4            : Float;
    insulin       : Float;
  } {
    switch (organismId) {
      case null {
        {
          serotonin = 0.0; gaba = 0.0; acetylcholine = 0.0;
          testosterone = 0.0; melatonin = 0.0;
          t3 = 0.0; t4 = 0.0; insulin = 0.0;
        }
      };
      case (?p) {
        let org = actor(Principal.toText(p)) : actor {
          getOrgNeuroChem : shared query () -> async {
            serotonin     : Float;
            gaba          : Float;
            acetylcholine : Float;
            testosterone  : Float;
            melatonin     : Float;
            t3            : Float;
            t4            : Float;
            insulin       : Float;
          };
        };
        await org.getOrgNeuroChem()
      };
    }
  };

  public composite query func getOrganismMetals() : async {
    processed  : [Float];
    resonances : [Float];
    names      : [Text];
  } {
    switch (organismId) {
      case null { { processed = []; resonances = []; names = [] } };
      case (?p) {
        let org = actor(Principal.toText(p)) : actor {
          getMetalsSnapshot : shared query () -> async {
            processed  : [Float];
            resonances : [Float];
            names      : [Text];
          };
        };
        await org.getMetalsSnapshot()
      };
    }
  };

  public composite query func getOrganismHive() : async {
    queenPheromone : Float;
    queenDroneId   : Nat;
    quorumDecided  : Bool;
    quorumWinner   : Nat;
    quorumTopic    : Text;
    topNectar      : Float;
    combRoles      : [Text];
  } {
    switch (organismId) {
      case null {
        {
          queenPheromone = 0.0; queenDroneId = 0; quorumDecided = false;
          quorumWinner = 0; quorumTopic = ""; topNectar = 0.0; combRoles = [];
        }
      };
      case (?p) {
        let org = actor(Principal.toText(p)) : actor {
          getHiveSnapshot : shared query () -> async {
            queenPheromone : Float;
            queenDroneId   : Nat;
            quorumDecided  : Bool;
            quorumWinner   : Nat;
            quorumTopic    : Text;
            topNectar      : Float;
            combRoles      : [Text];
          };
        };
        await org.getHiveSnapshot()
      };
    }
  };

  public composite query func getOrganismAnt() : async {
    antRoles     : [Text];
    antCells     : [Nat];
    pheromoneMax : Float;
    dangerMax    : Float;
  } {
    switch (organismId) {
      case null { { antRoles = []; antCells = []; pheromoneMax = 0.0; dangerMax = 0.0 } };
      case (?p) {
        let org = actor(Principal.toText(p)) : actor {
          getAntSnapshot : shared query () -> async {
            antRoles     : [Text];
            antCells     : [Nat];
            pheromoneMax : Float;
            dangerMax    : Float;
          };
        };
        await org.getAntSnapshot()
      };
    }
  };

  public composite query func getOrganismMode() : async Text {
    switch (organismId) {
      case null { "NOT_REGISTERED" };
      case (?p) {
        let org = actor(Principal.toText(p)) : actor {
          getOrganismMode : shared query () -> async Text;
        };
        await org.getOrganismMode()
      };
    }
  };

  // ─── SWARM COMMAND — composite read-only queries ─────────────────────────

  public composite query func getCommandSnapshot() : async {
    missionStatus   : Text;
    missionName     : Text;
    emergencyActive : Bool;
    commsLost       : Bool;
    architectSignal : Float;
    pendingCount    : Nat;
  } {
    switch (commandId) {
      case null {
        {
          missionStatus = "NOT_REGISTERED"; missionName = "";
          emergencyActive = false; commsLost = false;
          architectSignal = 0.0; pendingCount = 0;
        }
      };
      case (?p) {
        let cmd = actor(Principal.toText(p)) : actor {
          getCommandSnapshot : shared query () -> async {
            missionStatus   : Text;
            missionName     : Text;
            emergencyActive : Bool;
            commsLost       : Bool;
            architectSignal : Float;
            pendingCount    : Nat;
          };
        };
        await cmd.getCommandSnapshot()
      };
    }
  };

  public composite query func getCommandWaypoints() : async [{ x : Float; y : Float; z : Float; lbl : Text }] {
    switch (commandId) {
      case null { [] };
      case (?p) {
        let cmd = actor(Principal.toText(p)) : actor {
          getWaypoints : shared query () -> async [{ x : Float; y : Float; z : Float; lbl : Text }];
        };
        await cmd.getWaypoints()
      };
    }
  };

  // ─── SWARM METALS — composite read-only queries ──────────────────────────

  public composite query func getMetalsSnapshot() : async {
    resonances     : [Float];
    names          : [Text];
    prevOutput     : [Float];
    processedCount : Nat;
    seal           : Text;
  } {
    switch (metalsId) {
      case null { { resonances = []; names = []; prevOutput = []; processedCount = 0; seal = "" } };
      case (?p) {
        let m = actor(Principal.toText(p)) : actor {
          getMetalsSnapshot : shared query () -> async {
            resonances     : [Float];
            names          : [Text];
            prevOutput     : [Float];
            processedCount : Nat;
            seal           : Text;
          };
        };
        await m.getMetalsSnapshot()
      };
    }
  };

  // ─── SWARM AUDIT — composite read-only queries ───────────────────────────

  public composite query func getAuditEntryCount() : async Nat {
    switch (auditId) {
      case null { 0 };
      case (?p) {
        let a = actor(Principal.toText(p)) : actor {
          getEntryCount : shared query () -> async Nat;
        };
        await a.getEntryCount()
      };
    }
  };

  public composite query func getAuditRecentEntries(n : Nat) : async [{
    seq         : Nat;
    kind        : Text;
    beat        : Nat;
    timestamp   : Int;
    droneId     : Int;
    description : Text;
    rSwarm      : Float;
    jDrift      : Float;
    cortisol    : Float;
    operator    : Text;
    metadata    : Text;
  }] {
    switch (auditId) {
      case null { [] };
      case (?p) {
        let a = actor(Principal.toText(p)) : actor {
          getRecentEntries : shared query (Nat) -> async [{
            seq         : Nat;
            kind        : Text;
            beat        : Nat;
            timestamp   : Int;
            droneId     : Int;
            description : Text;
            rSwarm      : Float;
            jDrift      : Float;
            cortisol    : Float;
            operator    : Text;
            metadata    : Text;
          }];
        };
        await a.getRecentEntries(n)
      };
    }
  };

  // ─── SWARM TELEMETRY — composite read-only queries ───────────────────────

  public composite query func getTelemetryDroneCount() : async Nat {
    switch (telemetryId) {
      case null { 0 };
      case (?p) {
        let t = actor(Principal.toText(p)) : actor {
          getDroneCount : shared query () -> async Nat;
        };
        await t.getDroneCount()
      };
    }
  };

  public composite query func getTelemetryAll() : async [{
    droneId        : Nat;
    droneClass     : Text;
    posX           : Float;
    posY           : Float;
    posZ           : Float;
    velX           : Float;
    velY           : Float;
    velZ           : Float;
    heading        : Float;
    altitude       : Float;
    batteryPct     : Float;
    signalStrength : Float;
    cortisol       : Float;
    dopamine       : Float;
    norepinephrine : Float;
    oxytocin       : Float;
    phase          : Float;
    activation     : Float;
    sacrificed     : Bool;
    beat           : Nat;
    timestamp      : Int;
  }] {
    switch (telemetryId) {
      case null { [] };
      case (?p) {
        let t = actor(Principal.toText(p)) : actor {
          getAllTelemetry : shared query () -> async [{
            droneId        : Nat;
            droneClass     : Text;
            posX           : Float;
            posY           : Float;
            posZ           : Float;
            velX           : Float;
            velY           : Float;
            velZ           : Float;
            heading        : Float;
            altitude       : Float;
            batteryPct     : Float;
            signalStrength : Float;
            cortisol       : Float;
            dopamine       : Float;
            norepinephrine : Float;
            oxytocin       : Float;
            phase          : Float;
            activation     : Float;
            sacrificed     : Bool;
            beat           : Nat;
            timestamp      : Int;
          }];
        };
        await t.getAllTelemetry()
      };
    }
  };

  // ─── SWARM QUANTUM — composite read-only queries ─────────────────────────

  public composite query func getQuantumSwarmMetrics() : async {
    swarmQCoherence  : Float;
    swarmConvergence : Float;
    beat             : Nat;
    droneCount       : Nat;
  } {
    switch (quantumId) {
      case null { { swarmQCoherence = 0.0; swarmConvergence = 0.0; beat = 0; droneCount = 0 } };
      case (?p) {
        let q = actor(Principal.toText(p)) : actor {
          getSwarmQuantumMetrics : shared query () -> async {
            swarmQCoherence  : Float;
            swarmConvergence : Float;
            beat             : Nat;
            droneCount       : Nat;
          };
        };
        await q.getSwarmQuantumMetrics()
      };
    }
  };

  // ─── SYSTEM CORE DIAGNOSTIC (pure query — local oracle summary only) ────────
  // Returns oracle registration status and timestamp for all dimensions.
  // No cross-canister calls — always instant and always read-only.

  public query func getSystemCoreDiagnostic() : async {
    oracleSeal          : Text;
    oracleTimestamp     : Int;
    claimed             : Bool;
    architect           : Text;
    brainRegistered     : Bool;
    organismRegistered  : Bool;
    commandRegistered   : Bool;
    metalsRegistered    : Bool;
    auditRegistered     : Bool;
    telemetryRegistered : Bool;
    quantumRegistered   : Bool;
    dimensionCount      : Nat;
  } {
    let registered = [
      brainId != null,
      organismId != null,
      commandId != null,
      metalsId != null,
      auditId != null,
      telemetryId != null,
      quantumId != null,
    ];
    var count = 0;
    for (r in registered.vals()) { if r { count += 1 } };
    {
      oracleSeal          = sovereignSeal;
      oracleTimestamp     = genesisTimestamp;
      claimed             = genesisLocked;
      architect           = Principal.toText(architectPrincipal);
      brainRegistered     = brainId     != null;
      organismRegistered  = organismId  != null;
      commandRegistered   = commandId   != null;
      metalsRegistered    = metalsId    != null;
      auditRegistered     = auditId     != null;
      telemetryRegistered = telemetryId != null;
      quantumRegistered   = quantumId   != null;
      dimensionCount      = count;
    }
  };

};
