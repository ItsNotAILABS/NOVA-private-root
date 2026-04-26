// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  MEDINA ICP — MAIN ACTOR                                                 ║
// ║  Universal command plane entry points for NOVA MEDINA on ICP.            ║
// ║                                                                          ║
// ║  Command grammar:                                                        ║
// ║    /memory find|pin|map                                                  ║
// ║    /govern status|propose|approve                                        ║
// ║    /model invoke|route                                                   ║
// ║    /workspace open                                                       ║
// ║    /company onboard|connect|internalize|hybrid                           ║
// ║    /replay show                                                          ║
// ║    /run                                                                  ║
// ║                                                                          ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.   ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import Array   "mo:base/Array";
import Float   "mo:base/Float";
import Iter    "mo:base/Iter";
import Nat     "mo:base/Nat";
import Text    "mo:base/Text";
import Time    "mo:base/Time";

import T       "./Types";
import LE      "./LawEngine";
import MT      "./MemoryTemple";
import Gov     "./Governance";
import MR      "./ModelRouter";
import Co      "./Company";
import Orch    "./Orchestrators";
import Math    "./MatalkoICP";

actor Medina {

  // ── STATE ──────────────────────────────────────────────────────────────────

  stable var beat          : Nat  = 0;
  stable var lawEpoch      : Nat  = 0;

  // Memory Temple
  stable var memNextId     : Nat  = 0;
  stable var memEntries    : [T.MemEntry] = [];

  // Governance
  stable var propNextId    : Nat  = 0;
  stable var proposals     : [T.Proposal] = [];

  // Company tenants
  stable var tenantNextId  : Nat  = 0;
  stable var tenants       : [T.TenantRecord] = [];

  // Invocation log
  stable var invocations   : [T.InvocationResult] = [];

  // Replay + incident logs
  stable var replayLog     : [T.ReplayEntry] = [];
  stable var incidents     : [T.Incident] = [];
  stable var incidentNext  : Nat = 0;
  stable var replayNext    : Nat = 0;

  // Matalko snapshots
  stable var snapshots     : [T.MatalkoSnapshot] = [];

  // Orchestrator last beats
  stable var orchBeats     : [T.OrchBeat] = [];

  // ── HELPERS ────────────────────────────────────────────────────────────────

  func currentLawPass() : T.LawPass {
    let dr = LE.dualRead(0.85, 0.80);
    LE.recitalPlusOne(lawEpoch, "sovereign-state-" # Nat.toText(beat),
      "beat-advance", 0.90, 0.85, 0.80, dr)
  };

  func appendReplay(op : Text, outcome : Text) {
    let entry : T.ReplayEntry = {
      id = replayNext; operation = op; outcome; beat
    };
    replayLog    := Array.append(replayLog, [entry]);
    replayNext   += 1;
  };

  func appendIncident(kind : T.IncidentKind, msg : Text) {
    let inc : T.Incident = { id = incidentNext; kind; msg; beat };
    incidents    := Array.append(incidents, [inc]);
    incidentNext += 1;
  };

  // ── BEAT TICK ──────────────────────────────────────────────────────────────

  /// Advance one organism beat. Evaluates all orchestrators and updates
  /// the law epoch under RECITAL_PLUS_ONE.
  public func tick() : async { beat : Nat; orchPassed : Nat } {
    beat      += 1;
    lawEpoch  += 1;
    let pass   = currentLawPass();
    orchBeats := Orch.evalAll(beat, 0.85);
    let passed = Array.filter<T.OrchBeat>(orchBeats, func(ob) { ob.passed }).size();
    appendReplay("tick", "beat=" # Nat.toText(beat) # " orchPassed=" # Nat.toText(passed));
    { beat; orchPassed = passed }
  };

  // ── COMMAND PLANE ──────────────────────────────────────────────────────────

  /// Parse and dispatch a raw text command.
  public func runTextCommand(raw : Text) : async Text {
    let cmd = parseCommand(raw);
    await runCommand(cmd)
  };

  /// Dispatch a pre-parsed command.
  public func runCommand(cmd : T.ParsedCommand) : async Text {
    switch (cmd.tag) {
      case (#memory_find)  { memoryFind(cmd.args)   };
      case (#memory_pin)   { memoryPin(cmd.args)    };
      case (#memory_map)   { memoryMap(cmd.args)    };
      case (#govern_status)   { govStatus()         };
      case (#govern_propose)  { govPropose(cmd.args)};
      case (#govern_approve)  { govApprove(cmd.args)};
      case (#model_invoke) { modelInvoke(cmd.args)  };
      case (#model_route)  { modelRoute(cmd.args)   };
      case (#workspace_open) { workspaceOpen(cmd.args) };
      case (#company_onboard)      { companyOnboard(cmd.args)     };
      case (#company_connect)      { companyConnect(cmd.args)     };
      case (#company_internalize)  { companyInternalize(cmd.args) };
      case (#company_hybrid)       { companyHybrid(cmd.args)      };
      case (#replay_show)  { replayShow(cmd.args)   };
      case (#run)          { runGeneral(cmd.args)   };
      case (#unknown)      {
        appendIncident(#parse_error, "unknown command: " # cmd.raw);
        "ERROR: unknown command: " # cmd.raw
      };
    }
  };

  // ── COMMAND PARSER ─────────────────────────────────────────────────────────

  func parseCommand(raw : Text) : T.ParsedCommand {
    let parts = Iter.toArray(Text.split(raw, #char ' '));
    let nParts = parts.size();
    let verb   = if (nParts > 0) parts[0] else "";
    let sub    = if (nParts > 1) parts[1] else "";
    let args   = if (nParts > 2) Array.tabulate<Text>(nParts - 2, func(i) { parts[i + 2] }) else [];

    let tag : T.CommandTag = switch (verb, sub) {
      case ("/memory",    "find")        #memory_find;
      case ("/memory",    "pin")         #memory_pin;
      case ("/memory",    "map")         #memory_map;
      case ("/govern",    "status")      #govern_status;
      case ("/govern",    "propose")     #govern_propose;
      case ("/govern",    "approve")     #govern_approve;
      case ("/model",     "invoke")      #model_invoke;
      case ("/model",     "route")       #model_route;
      case ("/workspace", "open")        #workspace_open;
      case ("/company",   "onboard")     #company_onboard;
      case ("/company",   "connect")     #company_connect;
      case ("/company",   "internalize") #company_internalize;
      case ("/company",   "hybrid")      #company_hybrid;
      case ("/replay",    "show")        #replay_show;
      case ("/run",       _)             #run;
      case _                             #unknown;
    };
    { tag; raw; args }
  };

  // ── MEMORY COMMANDS ────────────────────────────────────────────────────────

  func memoryFind(args : [Text]) : Text {
    let searchQ = if (args.size() > 0) args[0] else "";
    let found = Array.filter<T.MemEntry>(memEntries, func(e) {
      Text.contains(e.content, #text searchQ)
    });
    "MEMORY-FIND: " # Nat.toText(found.size()) # " entries matched \"" # searchQ # "\""
  };

  func memoryPin(args : [Text]) : Text {
    if (args.size() == 0) return "ERROR: /memory pin <id>";
    let idOpt = Nat.fromText(args[0]);
    switch (idOpt) {
      case null { "ERROR: invalid id" };
      case (?targetId) {
        memEntries := Array.map<T.MemEntry, T.MemEntry>(
          memEntries,
          func(e) { if (e.id == targetId) MT.pin(e) else e }
        );
        appendReplay("/memory pin", "id=" # args[0]);
        "MEMORY-PIN: id=" # args[0] # " pinned=true"
      };
    }
  };

  func memoryMap(args : [Text]) : Text {
    let mode : T.MapMode = if (args.size() > 0) {
      switch (args[0]) {
        case "ring" #ring;
        case "path" #path;
        case _      #helix;
      }
    } else #helix;
    let sorted = switch (mode) {
      case (#helix) MT.mapHelix(memEntries);
      case (#ring)  MT.mapRing(memEntries);
      case (#path) {
        let prefix = if (args.size() > 1) args[1] else "";
        MT.mapPath(memEntries, prefix)
      };
    };
    "MEMORY-MAP[" # debug_show(mode) # "]: " # Nat.toText(sorted.size()) # " entries"
  };

  // ── GOVERNANCE COMMANDS ────────────────────────────────────────────────────

  func govStatus() : Text {
    let s = Gov.statusSummary(proposals);
    "GOVERN-STATUS: pending=" # Nat.toText(s.pending)
    # " approved=" # Nat.toText(s.approved)
    # " rejected=" # Nat.toText(s.rejected)
    # " rolledBack=" # Nat.toText(s.rolledBack)
  };

  func govPropose(args : [Text]) : Text {
    let reg : T.Register = if (args.size() > 0) {
      switch (args[0]) {
        case "founder"  #founder;
        case "builder"  #builder;
        case "organism" #organism;
        case _          #external;
      }
    } else #external;
    let content = if (args.size() > 1) args[1] else "(no content)";
    let p = Gov.createProposal(propNextId, reg, content, lawEpoch);
    proposals   := Array.append(proposals, [p]);
    propNextId  += 1;
    appendReplay("/govern propose", "id=" # Nat.toText(p.id));
    "GOVERN-PROPOSE: id=" # Nat.toText(p.id) # " register=" # debug_show(reg)
  };

  func govApprove(args : [Text]) : Text {
    if (args.size() == 0) return "ERROR: /govern approve <id>";
    let idOpt = Nat.fromText(args[0]);
    switch (idOpt) {
      case null { "ERROR: invalid proposal id" };
      case (?targetId) {
        let pass = currentLawPass();
        proposals := Array.map<T.Proposal, T.Proposal>(proposals, func(p) {
          if (p.id == targetId) {
            switch (Gov.approve(p, pass)) {
              case (#ok(updated)) updated;
              case (#err(_))      p;
            }
          } else p
        });
        appendReplay("/govern approve", "id=" # args[0]);
        "GOVERN-APPROVE: id=" # args[0]
      };
    }
  };

  // ── MODEL COMMANDS ─────────────────────────────────────────────────────────

  func modelInvoke(args : [Text]) : Text {
    let roleStr  = if (args.size() > 0) args[0] else "analyst";
    let payload  = if (args.size() > 1) args[1] else "";
    let role = textToRole(roleStr);
    let result = MR.invoke(role, payload, beat);
    invocations := Array.append(invocations, [result]);
    appendReplay("/model invoke", result.modelLabel);
    "MODEL-INVOKE: " # result.modelLabel # " output=" # result.output
  };

  func modelRoute(args : [Text]) : Text {
    let roleStr  = if (args.size() > 0) args[0] else "analyst";
    let payload  = if (args.size() > 1) args[1] else "";
    let role = textToRole(roleStr);
    let result = MR.invoke(role, payload, beat);
    "MODEL-ROUTE: " # result.modelLabel # " rationale=" # result.rationale
  };

  func textToRole(s : Text) : T.ModelRole {
    switch (s) {
      case "strategist"     #strategist;
      case "builder"        #builder;
      case "governance"     #governance;
      case "memory_curator" #memory_curator;
      case "operations"     #operations;
      case "defense_risk"   #defense_risk;
      case "projection"     #projection;
      case _                #analyst;
    }
  };

  // ── WORKSPACE COMMAND ──────────────────────────────────────────────────────

  func workspaceOpen(args : [Text]) : Text {
    let wsId = if (args.size() > 0) args[0] else "default";
    appendReplay("/workspace open", wsId);
    "WORKSPACE-OPEN: id=" # wsId # " beat=" # Nat.toText(beat)
  };

  // ── COMPANY COMMANDS ───────────────────────────────────────────────────────

  func companyOnboard(args : [Text]) : Text {
    let name = if (args.size() > 0) args[0] else "unknown";
    let modeStr = if (args.size() > 1) args[1] else "connect";
    let mode : T.OnboardMode = switch (modeStr) {
      case "internalize" #internalize;
      case "hybrid"      #hybrid;
      case _             #connect;
    };
    let pass = currentLawPass();
    switch (Co.onboard(tenantNextId, name, mode, pass, beat)) {
      case (#ok(t)) {
        tenants       := Array.append(tenants, [t]);
        tenantNextId  += 1;
        appendReplay("/company onboard", "id=" # Nat.toText(t.id) # " name=" # name);
        "COMPANY-ONBOARD: id=" # Nat.toText(t.id) # " mode=" # modeStr
      };
      case (#err(e)) { appendIncident(#permission_denied, e); "ERROR: " # e };
    }
  };

  func companyConnect(args : [Text]) : Text {
    if (args.size() < 2) return "ERROR: /company connect <tenantId> <systemId>";
    let tidOpt = Nat.fromText(args[0]);
    switch (tidOpt) {
      case null { "ERROR: invalid tenantId" };
      case (?tid) {
        let sysId = args[1];
        tenants := Array.map<T.TenantRecord, T.TenantRecord>(tenants, func(t) {
          if (t.id == tid) {
            switch (Co.connect(t, sysId, "direct", beat)) {
              case (#ok(u)) u;
              case (#err(_)) t;
            }
          } else t
        });
        appendReplay("/company connect", "tid=" # Nat.toText(tid) # " sys=" # sysId);
        "COMPANY-CONNECT: tenantId=" # Nat.toText(tid) # " systemId=" # sysId
      };
    }
  };

  func companyInternalize(args : [Text]) : Text {
    if (args.size() < 2) return "ERROR: /company internalize <tenantId> <assetId>";
    let tidOpt = Nat.fromText(args[0]);
    switch (tidOpt) {
      case null { "ERROR: invalid tenantId" };
      case (?tid) {
        let assetId = args[1];
        let pass    = currentLawPass();
        tenants := Array.map<T.TenantRecord, T.TenantRecord>(tenants, func(t) {
          if (t.id == tid) {
            switch (Co.internalize(t, assetId, "document", pass, beat)) {
              case (#ok(u)) u;
              case (#err(_)) t;
            }
          } else t
        });
        appendReplay("/company internalize", "tid=" # Nat.toText(tid) # " asset=" # assetId);
        "COMPANY-INTERNALIZE: tenantId=" # Nat.toText(tid) # " assetId=" # assetId
      };
    }
  };

  func companyHybrid(args : [Text]) : Text {
    if (args.size() < 2) return "ERROR: /company hybrid <tenantId> <deltaKey>";
    let tidOpt = Nat.fromText(args[0]);
    switch (tidOpt) {
      case null { "ERROR: invalid tenantId" };
      case (?tid) {
        let deltaKey = args[1];
        tenants := Array.map<T.TenantRecord, T.TenantRecord>(tenants, func(t) {
          if (t.id == tid) {
            switch (Co.hybridReconcile(t, deltaKey, "edge→nova", beat)) {
              case (#ok(u)) u;
              case (#err(_)) t;
            }
          } else t
        });
        appendReplay("/company hybrid", "tid=" # Nat.toText(tid) # " delta=" # deltaKey);
        "COMPANY-HYBRID: tenantId=" # Nat.toText(tid) # " delta=" # deltaKey
      };
    }
  };

  // ── REPLAY COMMAND ─────────────────────────────────────────────────────────

  func replayShow(args : [Text]) : Text {
    let n = if (args.size() > 0) {
      switch (Nat.fromText(args[0])) { case (?v) v; case null 10 }
    } else 10;
    let total = replayLog.size();
    let start = if (total > n) total - n else 0;
    let recent = Array.tabulate<T.ReplayEntry>(total - start, func(i) { replayLog[start + i] });
    var out = "REPLAY-SHOW last " # Nat.toText(recent.size()) # ":\n";
    for (r in recent.vals()) {
      out #= "  [" # Nat.toText(r.beat) # "] " # r.operation # " → " # r.outcome # "\n";
    };
    out
  };

  // ── RUN (GENERAL) ──────────────────────────────────────────────────────────

  func runGeneral(args : [Text]) : Text {
    let payload = if (args.size() > 0) args[0] else "";
    let result  = MR.invoke(#analyst, payload, beat);
    appendReplay("/run", result.output);
    "RUN: " # result.output
  };

  // ── MEMORY TEMPLE PUBLIC API ───────────────────────────────────────────────

  /// Store a new memory entry at the given coordinate.
  public func memoryStore(
    content  : Text,
    theta    : Float,
    phi      : Float,
    depth    : Float,
    ring     : Nat,
    salience : Float
  ) : async Nat {
    let coord : T.MemCoord = { theta; phi; depth; ring; beat };
    let lineage : T.MemLineage = {
      parentHash = "beat-" # Nat.toText(beat - 1);
      chainHash  = "chain-" # Nat.toText(beat);
      seqRef     = "seq-" # Nat.toText(memNextId);
    };
    let entry : T.MemEntry = {
      id = memNextId; coord; lineage; content;
      salience; pinned = false; beat;
    };
    memEntries := Array.append(memEntries, [entry]);
    let id = memNextId;
    memNextId  += 1;
    appendReplay("memoryStore", "id=" # Nat.toText(id));
    id
  };

  /// Query memory entries (returns up to 20 results).
  public query func memoryQuery(searchQ : Text) : async [T.MemEntry] {
    let found = Array.filter<T.MemEntry>(memEntries, func(e) {
      Text.contains(e.content, #text searchQ)
    });
    if (found.size() > 20) Array.tabulate<T.MemEntry>(20, func(i) { found[i] })
    else found
  };

  // ── GOVERNANCE PUBLIC API ──────────────────────────────────────────────────

  public query func getProposals() : async [T.Proposal] { proposals };

  // ── MODEL PUBLIC API ───────────────────────────────────────────────────────

  public query func getInvocations() : async [T.InvocationResult] { invocations };

  // ── COMPANY PUBLIC API ─────────────────────────────────────────────────────

  public query func getTenants() : async [T.TenantRecord] { tenants };

  // ── ORCHESTRATOR PUBLIC API ────────────────────────────────────────────────

  public query func getOrchBeats() : async [T.OrchBeat] { orchBeats };

  // ── REPLAY / INCIDENT PUBLIC API ──────────────────────────────────────────

  public query func getReplayLog() : async [T.ReplayEntry] { replayLog };
  public query func getIncidents() : async [T.Incident]    { incidents };

  // ── MATALKO SNAPSHOT ──────────────────────────────────────────────────────

  /// Capture a Matalko physics/math/memory snapshot at the current beat.
  public func captureSnapshot(
    domainScores : [Float],
    semantic     : Float,
    resonance    : Float,
    coherence    : Float,
    lawScore     : Float,
    entropy      : Float,
    activity     : Float,
    equilibrium  : Float,
    saliences    : [Float],
    pinned       : [Bool]
  ) : async T.MatalkoSnapshot {
    let s = Math.snapshot(
      beat, domainScores,
      semantic, resonance,
      coherence, lawScore,
      entropy, activity, equilibrium,
      saliences, pinned
    );
    snapshots := Array.append(snapshots, [s]);
    s
  };

  public query func getSnapshots() : async [T.MatalkoSnapshot] { snapshots };

  // ── ROLLBACK ──────────────────────────────────────────────────────────────

  /// Roll back an approved proposal.
  public func rollbackProposal(id : Nat, reason : Text) : async Text {
    let pass = currentLawPass();
    var result = "NOT-FOUND";
    proposals := Array.map<T.Proposal, T.Proposal>(proposals, func(p) {
      if (p.id == id) {
        switch (Gov.rollback(p, pass, reason)) {
          case (#ok(u)) { result := "ROLLED-BACK:" # Nat.toText(id); u };
          case (#err(e)) { result := "ERR:" # e; p };
        }
      } else p
    });
    appendReplay("rollback", result);
    result
  };

}
