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

// SWARM ORGANISM — SOVEREIGN ORGANISM INTELLIGENCE ENGINE (BUILD №46)
// EVERYTHING IS INTELLIGENCE — This is NOT simulation. This is REAL computation.
// Physics = REAL math and geometry. Golden numbers are REAL. No fake simulation.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
//
// Organism Layer: Bee Hive Mind + Ant Mind brain architectures.
// Each architecture is a collective-intelligence overlay that controls
// how the drone swarm organises, communicates, and decides as one organism.
//
// BEE HIVE MIND  — waggle-dance signalling, quorum sensing, nectar maps,
//                  queen pheromone broadcast, comb-cell role assignment.
// ANT MIND       — pheromone trail matrix, ACO path finding, stigmergy,
//                  trail evaporation, division of labour by age/experience.
// INTERNAL AI TEAMS (organism-level) — 5 specialist organ systems:
//   NERVOUS (routing), IMMUNE (defence), METABOLIC (energy), SENSORY
//   (perception), REPRODUCTIVE (swarm growth).
//
// NOVA HEARTBEAT — The organism is autonomous. system func heartbeat() fires
// every NOVA 873ms tick and drives the full control loop without any
// external caller: tick brain → read state → run hive/ant/organs → push
// directives back to brain.  The swarm lives.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";
import Brain     "canister:swarm_brain";

actor SwarmOrganism {

  // ─── CONSTANTS ──────────────────────────────────────────────────────────────

  let MAX_DRONES    : Nat   = 50;
  let GRID_W        : Nat   = 20;   // pheromone / nectar grid width
  let GRID_CELLS    : Nat   = 400;  // GRID_W × GRID_W
  let SOVEREIGN_FLOOR : Float = 1.0;
  let PI            : Float = 3.14159265358979;
  let EPSILON       : Float = 0.001; // small value used to prevent division by zero

  // ─── ORGANISM TYPE ──────────────────────────────────────────────────────────

  public type OrganismMode = {
    #HIVE_MIND;
    #ANT_MIND;
    #HYBRID;   // both architectures active simultaneously
  };

  // ─── STABLE STATE: ORGANISM IDENTITY ────────────────────────────────────────

  stable var organismMode  : Text  = "HYBRID";
  stable var organismBeat  : Nat   = 0;
  stable var droneCount    : Nat   = 0;

  // ─── SOVEREIGN SEAL — On-chain IP Attribution & Access Control ──────────────
  // Attribution: Alfredo Medina Hernandez | Medina Tech | Dallas TX | 2026
  // The organism seed is locked at genesis. The ICP blockchain cryptographically
  // verifies caller principals — they cannot be spoofed on-chain.
  stable var architectPrincipal    : Principal = Principal.fromText("aaaaa-aa");
  stable var trustedBrainPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked         : Bool      = false;
  stable var sovereignSeal         : Text      = "";
  stable var genesisTimestamp      : Int       = 0;

  func isAuthorized(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == architectPrincipal or caller == trustedBrainPrincipal
  };
  func requireAuthorized(caller : Principal) { assert(isAuthorized(caller)) };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── BEE HIVE MIND ARCHITECTURE ─────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Mathematical model:
  //   Waggle dance  — vector signal V_i = (amplitude, angle) encodes food-source
  //                   quality Q and direction θ.  Probability of recruitment:
  //                   P_recruit = 1 / (1 + exp(-k·Q))  (logistic, k=2.0)
  //   Quorum sensing — swarm decides to adopt a new nest site when
  //                    count(scouts_committed) ≥ QUORUM_THRESH.
  //   Queen pheromone— broadcast amplitude decays exponentially:
  //                    φ(t) = φ_0 · exp(-λ·t);  λ=0.05 per beat.
  //   Nectar map     — 20×20 resource grid; each cell stores nectar value ∈ [0,1].
  //                    Cells deplete on harvest (rate 0.1) and replenish slowly
  //                    (rate 0.005/beat).

  // ─── Queen / Architect ───────────────────────────────────────────────────────
  stable var queenPheromone    : Float = 1.5;  // current queen signal amplitude
  stable var queenDroneId      : Nat   = 0;    // which drone acts as queen (SOVEREIGN)
  stable var queenPheroDecay   : Float = 0.05; // λ per beat

  // ─── Waggle Dance ────────────────────────────────────────────────────────────
  // Each drone carries one waggle-dance vector (quality, angle).
  stable var waggleQuality : [var Float] = Array.init<Float>(MAX_DRONES, 0.0);
  stable var waggleAngle   : [var Float] = Array.init<Float>(MAX_DRONES, 0.0);
  stable var waggleActive  : [var Bool]  = Array.init<Bool>(MAX_DRONES, false);

  // ─── Quorum Sensing ─────────────────────────────────────────────────────────
  stable var quorumThreshold : Nat   = 3;    // min scouts needed for decision
  stable var quorumTopic     : Text  = "";   // current decision topic
  stable var quorumVotes     : [var Nat] = Array.init<Nat>(MAX_DRONES, 0); // vote counts per candidate site
  stable var quorumDecided   : Bool  = false;
  stable var quorumWinner    : Nat   = 0;    // winning site index

  // ─── Nectar / Resource Map ───────────────────────────────────────────────────
  stable var nectarGrid     : [var Float] = Array.init<Float>(GRID_CELLS, 0.5); // [0,1]
  stable var nectarHarvests : [var Nat]   = Array.init<Nat>(GRID_CELLS, 0);

  // ─── Comb Cell Role Assignments ─────────────────────────────────────────────
  // Each drone has a "comb cell" — a role assignment maintained by the hive.
  stable var combRole : [var Text] = Array.init<Text>(MAX_DRONES, "WORKER");
  // Roles: QUEEN_GUARD | FORAGER | NURSE | BUILDER | SCOUT | DEFENDER | WORKER

  // ─── Math: Waggle Recruitment Probability ────────────────────────────────────
  func waggleRecruitProb(quality : Float) : Float {
    let k : Float = 2.0;
    1.0 / (1.0 + Float.exp(-k * (quality - 0.5)))
  };

  // ─── Math: Queen Pheromone Decay ─────────────────────────────────────────────
  func decayQueenPheromone() {
    queenPheromone := Float.max(0.5, queenPheromone * Float.exp(-queenPheroDecay));
  };

  // ─── Math: Nectar Grid Dynamics ──────────────────────────────────────────────
  func nectarStep() {
    var c = 0;
    while (c < GRID_CELLS) {
      // Slow replenishment
      nectarGrid[c] := Float.min(1.0, nectarGrid[c] + 0.005);
      c += 1;
    };
  };

  // Convert world position to grid cell index
  func worldToCell(x : Float, z : Float) : Nat {
    // World range assumed [-100, 100]; map to [0, GRID_W-1]
    let gx = Nat.min(GRID_W - 1, Int.abs(Float.toInt(Float.max(0.0, (x + 100.0) / 200.0 * Float.fromInt(GRID_W)))));
    let gz = Nat.min(GRID_W - 1, Int.abs(Float.toInt(Float.max(0.0, (z + 100.0) / 200.0 * Float.fromInt(GRID_W)))));
    gz * GRID_W + gx
  };

  // Private synchronous implementation — called internally from masterTick
  // without async overhead (avoids self-call through message queue).
  func harvestNectarImpl(droneId : Nat, posX : Float, posZ : Float) : Float {
    let cell = worldToCell(posX, posZ);
    let harvested = nectarGrid[cell] * 0.1; // harvest 10%
    nectarGrid[cell] := Float.max(0.0, nectarGrid[cell] - harvested);
    nectarHarvests[cell] += 1;
    if (droneId < MAX_DRONES) {
      waggleQuality[droneId] := harvested;
      waggleAngle[droneId]   := Float.fromInt(cell) * 0.01572; // angle from cell index
      waggleActive[droneId]  := true;
    };
    harvested
  };

  // Public async wrapper — external callers use this
  public shared(msg) func harvestNectar(droneId : Nat, posX : Float, posZ : Float) : async Float {
    requireAuthorized(msg.caller);
    harvestNectarImpl(droneId, posX, posZ)
  };

  // ─── Quorum Decision ─────────────────────────────────────────────────────────
  public shared(msg) func castWaggleVote(droneId : Nat, siteIndex : Nat) : async () {
    requireAuthorized(msg.caller);
    if (droneId >= MAX_DRONES) return;
    if (siteIndex >= GRID_CELLS) return;
    if (not waggleActive[droneId]) return;
    if (siteIndex < quorumVotes.size()) {
      quorumVotes[siteIndex] += 1;
    };
    // Check quorum
    if (quorumVotes[siteIndex] >= quorumThreshold and not quorumDecided) {
      quorumDecided := true;
      quorumWinner  := siteIndex;
    };
  };

  public shared(msg) func resetQuorum(topic : Text) : async () {
    requireAuthorized(msg.caller);
    quorumTopic   := topic;
    quorumDecided := false;
    quorumWinner  := 0;
    var c = 0;
    while (c < GRID_CELLS) { quorumVotes[c] := 0; c += 1 };
  };

  // ─── Comb Role Assignment (hive intelligence) ────────────────────────────────
  // Assign comb roles based on drone class and waggle quality.
  public shared(msg) func assignCombRoles(classes : [Text], signals : [Float]) : async () {
    requireAuthorized(msg.caller);
    let n = Nat.min(classes.size(), MAX_DRONES);
    var i = 0;
    while (i < n) {
      combRole[i] := switch (classes[i]) {
        case "SOVEREIGN" "QUEEN_GUARD";
        case "SCOUT"     { if (waggleQuality[i] > 0.3) "FORAGER" else "SCOUT" };
        case "MEDIC"     "NURSE";
        case "GUARDIAN"  "DEFENDER";
        case "RELAY"     "BUILDER";
        case "STRIKER"   { if (signals[i] > 1.3) "FORAGER" else "DEFENDER" };
        case _           "WORKER";
      };
      i += 1;
    };
  };

  // ─── Hive Tick ───────────────────────────────────────────────────────────────
  func hiveTick() {
    decayQueenPheromone();
    nectarStep();
    // Drones near queen get pheromone boost (suppress independent behaviour)
    // Modelled here as a broadcast — actual position check done externally
  };

  // ─── Hive Queries ────────────────────────────────────────────────────────────
  public query func getHiveSnapshot() : async {
    queenPheromone : Float;
    queenDroneId   : Nat;
    quorumDecided  : Bool;
    quorumWinner   : Nat;
    quorumTopic    : Text;
    topNectar      : Float;
    combRoles      : [Text];
  } {
    var maxNectar : Float = 0.0;
    var c = 0;
    while (c < GRID_CELLS) {
      if (nectarGrid[c] > maxNectar) maxNectar := nectarGrid[c];
      c += 1;
    };
    let roles = Array.tabulate<Text>(Nat.min(droneCount, MAX_DRONES), func(i) { combRole[i] });
    {
      queenPheromone = queenPheromone;
      queenDroneId   = queenDroneId;
      quorumDecided  = quorumDecided;
      quorumWinner   = quorumWinner;
      quorumTopic    = quorumTopic;
      topNectar      = maxNectar;
      combRoles      = roles;
    }
  };

  public query func getNectarGrid() : async [Float] {
    Array.tabulate<Float>(GRID_CELLS, func(i) { nectarGrid[i] })
  };

  public query func getWaggleDance(droneId : Nat) : async { quality : Float; angle : Float; active : Bool } {
    if (droneId >= MAX_DRONES)
      return { quality = 0.0; angle = 0.0; active = false };
    { quality = waggleQuality[droneId]; angle = waggleAngle[droneId]; active = waggleActive[droneId] }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── ANT MIND BRAIN ARCHITECTURE ───────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Mathematical model:
  //   Pheromone trail matrix τ[i][j]: Nat × Nat → Float  (20×20 grid)
  //   Trail update (Ant Colony Optimisation, ACS variant):
  //     τ_new = (1-ρ)·τ + Δτ    ρ=0.05 evaporation, Δτ = Q/L (ant deposit)
  //   Path selection probability (ACO):
  //     P(i→j) = [τ(i,j)^α · η(i,j)^β] / Σ_k [τ(i,k)^α · η(i,k)^β]
  //     α=1.0 (pheromone weight), β=2.0 (heuristic weight)
  //     η(i,j) = 1/dist(i,j)  (heuristic desirability)
  //   Division of labour (threshold model):
  //     Drone switches role when stimulus S_task > threshold θ_i
  //     θ_i evolves: θ decreases if task performed (habituation),
  //                  increases if neglected (sensitisation)
  //   Stigmergy — indirect coordination through environment modification
  //               (pheromone deposits alter trail matrix)

  // ─── Pheromone Trail Grid ────────────────────────────────────────────────────
  // Flat 20×20 pheromone matrix. Cell (r,c) = pheromone[r*GRID_W + c]
  stable var pheromone     : [var Float] = Array.init<Float>(GRID_CELLS, 0.1);
  stable var pheromoneFood : [var Float] = Array.init<Float>(GRID_CELLS, 0.0); // food trail
  stable var pheromoneDanger : [var Float] = Array.init<Float>(GRID_CELLS, 0.0); // alarm trail

  let EVAP_RATE  : Float = 0.05;  // ρ
  let DEPOSIT_Q  : Float = 1.0;   // Q: pheromone deposit quantity per ant
  let ACO_ALPHA  : Float = 1.0;   // pheromone exponent
  let ACO_BETA   : Float = 2.0;   // heuristic exponent

  // ─── Drone Ant State ─────────────────────────────────────────────────────────
  // Experience (age proxy): how many beats each drone has been active
  stable var antExperience  : [var Nat]   = Array.init<Nat>(MAX_DRONES, 0);
  // Threshold per task: [FORAGE, DEFEND, RELAY, HEAL, SCOUT] per drone
  stable var antThreshold   : [var Float] = Array.init<Float>(MAX_DRONES * 5, 1.0);
  // Current ant role assignment
  stable var antRole        : [var Text]  = Array.init<Text>(MAX_DRONES, "WORKER");
  // Last visited grid cell
  stable var antCell        : [var Nat]   = Array.init<Nat>(MAX_DRONES, 0);

  // ─── Math: Pheromone Evaporation ─────────────────────────────────────────────
  func pheromoneEvaporate() {
    var c = 0;
    while (c < GRID_CELLS) {
      pheromone[c]      := Float.max(0.01, pheromone[c]      * (1.0 - EVAP_RATE));
      pheromoneFood[c]  := Float.max(0.0,  pheromoneFood[c]  * (1.0 - EVAP_RATE));
      pheromoneDanger[c]:= Float.max(0.0,  pheromoneDanger[c]* (1.0 - EVAP_RATE));
      c += 1;
    };
  };

  // ─── Math: Pheromone Deposit ─────────────────────────────────────────────────
  // Drone deposits pheromone of given type at its current grid cell.
  func pheromoneDeposit(cell : Nat, pathLength : Float, kind : Text) {
    if (cell >= GRID_CELLS) return;
    let delta = DEPOSIT_Q / Float.max(0.1, pathLength);
    switch kind {
      case "FOOD"   { pheromoneFood[cell]   := Float.min(5.0, pheromoneFood[cell]   + delta) };
      case "DANGER" { pheromoneDanger[cell] := Float.min(5.0, pheromoneDanger[cell] + delta) };
      case _        { pheromone[cell]       := Float.min(5.0, pheromone[cell]       + delta) };
    };
  };

  // ─── Math: ACO Move Probability ──────────────────────────────────────────────
  // Given current cell, compute ACO probability distribution over adjacent cells.
  // Returns best next cell index (greedy for simulation efficiency).
  // Helper: safe absolute difference of two Nat values as Nat
  func natAbsDiff(a : Nat, b : Nat) : Nat {
    if (a >= b) a - b else b - a
  };

  func acoNextCell(currentCell : Nat, goalCell : Nat) : Nat {
    let row = currentCell / GRID_W;
    let col = currentCell % GRID_W;
    let gRow = goalCell / GRID_W;
    let gCol = goalCell % GRID_W;
    // 4-connected neighbours
    var bestScore : Float = -1.0;
    var bestCell  : Nat   = currentCell;
    // Up
    if (row > 0) {
      let nc = (row - 1) * GRID_W + col;
      let tau = pheromone[nc];
      let dr : Nat = natAbsDiff(nc / GRID_W, gRow);
      let dc : Nat = natAbsDiff(nc % GRID_W, gCol);
      let dist = Float.sqrt(Float.fromInt(dr * dr + dc * dc)) + EPSILON;
      let eta = 1.0 / dist;
      let score = Float.pow(tau, ACO_ALPHA) * Float.pow(eta, ACO_BETA);
      if (score > bestScore) { bestScore := score; bestCell := nc };
    };
    // Down
    if (row + 1 < GRID_W) {
      let nc = (row + 1) * GRID_W + col;
      let tau = pheromone[nc];
      let dr : Nat = natAbsDiff(nc / GRID_W, gRow);
      let dc : Nat = natAbsDiff(nc % GRID_W, gCol);
      let dist = Float.sqrt(Float.fromInt(dr * dr + dc * dc)) + EPSILON;
      let eta = 1.0 / dist;
      let score = Float.pow(tau, ACO_ALPHA) * Float.pow(eta, ACO_BETA);
      if (score > bestScore) { bestScore := score; bestCell := nc };
    };
    // Left
    if (col > 0) {
      let nc = row * GRID_W + (col - 1);
      let tau = pheromone[nc];
      let dr : Nat = natAbsDiff(nc / GRID_W, gRow);
      let dc : Nat = natAbsDiff(nc % GRID_W, gCol);
      let dist = Float.sqrt(Float.fromInt(dr * dr + dc * dc)) + EPSILON;
      let eta = 1.0 / dist;
      let score = Float.pow(tau, ACO_ALPHA) * Float.pow(eta, ACO_BETA);
      if (score > bestScore) { bestScore := score; bestCell := nc };
    };
    // Right
    if (col + 1 < GRID_W) {
      let nc = row * GRID_W + (col + 1);
      let tau = pheromone[nc];
      let dr : Nat = natAbsDiff(nc / GRID_W, gRow);
      let dc : Nat = natAbsDiff(nc % GRID_W, gCol);
      let dist = Float.sqrt(Float.fromInt(dr * dr + dc * dc)) + EPSILON;
      let eta = 1.0 / dist;
      let score = Float.pow(tau, ACO_ALPHA) * Float.pow(eta, ACO_BETA);
      if (score > bestScore) { bestScore := score; bestCell := nc };
    };
    bestCell
  };

  // ─── Math: Division of Labour (Threshold Model) ───────────────────────────────
  // Task index: 0=FORAGE 1=DEFEND 2=RELAY 3=HEAL 4=SCOUT
  // Stimulus = environmental urgency signal for each task.
  func thresholdDecision(droneId : Nat, stimulus : [Float]) : Nat {
    if (droneId >= MAX_DRONES) return 4; // default SCOUT
    let base = droneId * 5;
    var bestTask : Nat   = 4;
    var bestProb : Float = 0.0;
    var t = 0;
    while (t < 5) {
      let s = stimulus[t];
      let theta = antThreshold[base + t];
      // P(task) = s² / (s² + θ²)
      let prob = (s * s) / (s * s + theta * theta + EPSILON);
      if (prob > bestProb) { bestProb := prob; bestTask := t };
      t += 1;
    };
    // Update thresholds: habituation (decrease) for chosen, sensitisation (increase) for others
    t := 0;
    while (t < 5) {
      if (t == bestTask) {
        antThreshold[base + t] := Float.max(0.1, antThreshold[base + t] - 0.05);
      } else {
        antThreshold[base + t] := Float.min(5.0, antThreshold[base + t] + 0.01);
      };
      t += 1;
    };
    bestTask
  };

  // ─── Ant Experience Update ────────────────────────────────────────────────────
  func updateExperience() {
    var i = 0;
    while (i < droneCount and i < MAX_DRONES) {
      antExperience[i] += 1;
      // More experienced ants get lower thresholds (specialise faster)
      if (antExperience[i] % 10 == 0) {
        let base = i * 5;
        var t = 0;
        while (t < 5) {
          antThreshold[base + t] := Float.max(0.05, antThreshold[base + t] - 0.02);
          t += 1;
        };
      };
      i += 1;
    };
  };

  // ─── Ant Tick ────────────────────────────────────────────────────────────────
  func antTick(positions : [Float], goals : [Float]) {
    pheromoneEvaporate();
    updateExperience();
    let n = Nat.min(droneCount, MAX_DRONES);
    let hasPos   = positions.size() >= n * 2;
    let hasGoals = goals.size() >= n * 2;
    var i = 0;
    while (i < n) {
      let posX = if (hasPos) positions[i * 2]     else 0.0;
      let posZ = if (hasPos) positions[i * 2 + 1] else 0.0;
      let goalX = if (hasGoals) goals[i * 2]     else 0.0;
      let goalZ = if (hasGoals) goals[i * 2 + 1] else 0.0;
      let cell     = worldToCell(posX, posZ);
      let goalCell = worldToCell(goalX, goalZ);
      antCell[i] := cell;
      // ACO move
      let nextCell = acoNextCell(cell, goalCell);
      // Deposit pheromone on current cell
      pheromoneDeposit(cell, 1.0, "FOOD");
      // Assign task via threshold model
      let stim : [Float] = [
        pheromoneFood[cell],    // FORAGE urgency
        pheromoneDanger[cell],  // DEFEND urgency
        pheromone[cell] * 0.5,  // RELAY urgency
        1.0 - nectarGrid[cell], // HEAL urgency (low nectar = more healing needed)
        1.0 / (Float.fromInt(antExperience[i]) + 1.0) // SCOUT urgency (new ants scout more)
      ];
      let task = thresholdDecision(i, stim);
      antRole[i] := switch task {
        case 0 "FORAGER";
        case 1 "DEFENDER";
        case 2 "RELAY";
        case 3 "NURSE";
        case _ "SCOUT";
      };
      i += 1;
    };
  };

  // ─── Ant Queries ─────────────────────────────────────────────────────────────
  public query func getAntSnapshot() : async {
    antRoles     : [Text];
    antCells     : [Nat];
    pheromoneMax : Float;
    dangerMax    : Float;
  } {
    let n = Nat.min(droneCount, MAX_DRONES);
    let roles = Array.tabulate<Text>(n, func(i) { antRole[i] });
    let cells = Array.tabulate<Nat>(n, func(i) { antCell[i] });
    var pMax : Float = 0.0; var dMax : Float = 0.0;
    var c = 0;
    while (c < GRID_CELLS) {
      if (pheromoneFood[c] > pMax) pMax := pheromoneFood[c];
      if (pheromoneDanger[c] > dMax) dMax := pheromoneDanger[c];
      c += 1;
    };
    { antRoles = roles; antCells = cells; pheromoneMax = pMax; dangerMax = dMax }
  };

  public query func getPheromoneGrid() : async [Float] {
    Array.tabulate<Float>(GRID_CELLS, func(i) { pheromoneFood[i] })
  };

  public query func getDangerGrid() : async [Float] {
    Array.tabulate<Float>(GRID_CELLS, func(i) { pheromoneDanger[i] })
  };

  // Deposit a danger alarm at a world position (called externally when threat detected)
  public shared(msg) func depositDanger(posX : Float, posZ : Float, intensity : Float) : async () {
    requireAuthorized(msg.caller);
    let cell = worldToCell(posX, posZ);
    pheromoneDanger[cell] := Float.min(5.0, pheromoneDanger[cell] + intensity);
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── 18-ORGAN SYSTEM + 12-METAL TRANSFER MODULE ─────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  // Attribution: Alfredo Medina Hernandez | Medina Tech | Dallas TX | 2026
  //
  // 18 organs modeled as transfer functions operating on swarm neurochemical
  // state. Each: output = S0 + gain × f(chemicals, swarm_state), clamped ≥ S0.
  // Organ output vector OV[18] is then piped through 12-metal transforms
  // producing a fully-processed organism signal used to drive swarm directives.
  //
  // Organs (index):
  //  0 HYPOTHALAMUS  1 AMYGDALA     2 HIPPOCAMPUS  3 PREFRONTAL
  //  4 CEREBELLUM    5 BRAINSTEM    6 THALAMUS     7 INSULA
  //  8 CINGULATE     9 BASAL_GANGLIA 10 PINEAL    11 THYROID
  // 12 ADRENAL      13 PANCREAS    14 LIVER       15 HEART
  // 16 IMMUNE       17 REPRODUCTIVE

  stable var organState      : [var Text]  = Array.init<Text>(18,  "IDLE");
  stable var organActivation : [var Float] = Array.init<Float>(18, 1.0);
  stable var organOutput     : [var Float] = Array.init<Float>(18, 0.0);
  stable var organMemory     : [var Float] = Array.init<Float>(180, 0.0); // 18 × 10

  // ─── Organism-body neurochemicals (body-level, updated from swarm aggregates)
  // Distinct from per-drone brain chemicals; represent the collective organism.
  stable var orgSerotonin     : Float = 1.0; // stability / mood
  stable var orgGABA          : Float = 1.0; // inhibition / calm
  stable var orgAcetylcholine : Float = 1.0; // attention / memory gate
  stable var orgTestosterone  : Float = 1.0; // drive / reproduction
  stable var orgMelatonin     : Float = 0.0; // circadian (beat-derived)
  stable var orgT3            : Float = 1.0; // thyroid T3 analog (active form)
  stable var orgT4            : Float = 1.0; // thyroid T4 analog (storage form)
  stable var orgInsulin       : Float = 1.0; // energy / capital regulation

  // ─── 12-metal resonance constants (tunable via setMetalResonance) ────────────
  stable var metalGold     : Float = 1.0;  // amplification
  stable var metalSilver   : Float = 1.0;  // conductance (sovereign anchor)
  stable var metalIron     : Float = 1.0;  // structural hardening
  stable var metalCopper   : Float = 1.0;  // cross-shell bridging
  stable var metalPlatinum : Float = 0.5;  // catalytic boost
  stable var metalTitanium : Float = 1.0;  // threat shielding
  stable var metalLithium  : Float = 1.0;  // baseline stabiliser
  stable var metalCobalt   : Float = 0.0;  // phase magnetiser (degrees; 0 = cos(0)=1)
  stable var metalMercury  : Float = 1.0;  // temporal transformer
  stable var metalTungsten : Float = 1.0;  // thermal / economic modulator
  stable var metalZinc     : Float = 1.0;  // recovery healer
  stable var metalOsmium   : Float = 1.0;  // density × coherence amplifier

  // Silver conductor needs previous cycle's raw organ value for feedback
  stable var metalsPrevOV  : [var Float] = Array.init<Float>(18, 1.0);
  // Final metals-processed output vector
  stable var metalsOutput  : [var Float] = Array.init<Float>(18, 1.0);

  // ─── Capacity guard (grows arrays from prior 5-organ baseline if needed) ──────
  func ensureOrganCap() {
    if (organState.size() < 18) {
      let ns = Array.init<Text>(18, "IDLE");
      var i = 0; while (i < organState.size()) { ns[i] := organState[i]; i += 1 };
      organState := ns;
    };
    if (organActivation.size() < 18) {
      let na = Array.init<Float>(18, 1.0);
      var i = 0; while (i < organActivation.size()) { na[i] := organActivation[i]; i += 1 };
      organActivation := na;
    };
    if (organOutput.size() < 18) {
      let no_ = Array.init<Float>(18, 0.0);
      var i = 0; while (i < organOutput.size()) { no_[i] := organOutput[i]; i += 1 };
      organOutput := no_;
    };
    if (organMemory.size() < 180) {
      let nm = Array.init<Float>(180, 0.0);
      var i = 0; while (i < organMemory.size()) { nm[i] := organMemory[i]; i += 1 };
      organMemory := nm;
    };
  };

  // ─── Sigmoid helper ──────────────────────────────────────────────────────────
  func sigmoid(x : Float) : Float {
    let cx = Float.max(-10.0, Float.min(10.0, x));
    1.0 / (1.0 + Float.exp(-cx))
  };

  // ─── Organism neurochemical update ───────────────────────────────────────────
  // Derives body-level chemistry from swarm aggregate signals each beat.
  func updateOrgNeuroChem(meanDop : Float, meanCort : Float,
                          meanNor : Float, meanOxy  : Float,
                          meanEnergy : Float) {
    // Serotonin: stability — rises with bonding (oxytocin) and low cortisol
    let serTarget = meanOxy * 0.4 + (1.0 / Float.max(0.1, meanCort)) * 0.6;
    orgSerotonin := Float.max(SOVEREIGN_FLOOR,
      orgSerotonin * 0.95 + Float.max(SOVEREIGN_FLOOR, serTarget) * 0.05);
    // GABA: inhibitory calm — inversely driven by arousal (norepinephrine)
    let gabaTarget = 2.0 / Float.max(0.1, 1.0 + meanNor);
    orgGABA := Float.max(SOVEREIGN_FLOOR,
      orgGABA * 0.95 + Float.max(SOVEREIGN_FLOOR, gabaTarget) * 0.05);
    // Acetylcholine: attention gate — rises with dopamine reward
    let achTarget = meanDop * 0.7 + meanOxy * 0.3;
    orgAcetylcholine := Float.max(SOVEREIGN_FLOOR,
      orgAcetylcholine * 0.95 + Float.max(SOVEREIGN_FLOOR, achTarget) * 0.05);
    // Thyroid analogs derived from energy
    orgT3 := Float.max(SOVEREIGN_FLOOR, meanEnergy * 0.8);
    orgT4 := Float.max(SOVEREIGN_FLOOR, meanEnergy * 1.2);
    // Insulin rises with high energy (anabolic)
    orgInsulin := Float.max(SOVEREIGN_FLOOR, meanEnergy * 0.9);
    // Testosterone and melatonin are updated inside their respective organ funcs
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── 18 ORGAN TRANSFER FUNCTIONS ─────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════

  // 0. HYPOTHALAMUS — homeostatic setpoint regulator
  // output = S0 + alpha × (target − current) × dopamine_mod
  func organ0Hypothalamus(meanDop : Float, meanCort : Float,
                          meanNor : Float, meanOxy  : Float) : Float {
    let alpha = 0.15;
    let current = (Float.abs(meanDop  - 1.0) + Float.abs(meanCort - 1.0)
                 + Float.abs(meanNor  - 1.0) + Float.abs(meanOxy  - 1.0)) / 4.0;
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + alpha * (1.0 - current) * meanDop);
    organOutput[0]     := out;
    organActivation[0] := sigmoid((out - SOVEREIGN_FLOOR) * 3.0);
    organMemory[0]     := organMemory[0] * 0.9 + out * 0.1;
    organState[0]      := if (current < 0.1) "SETPOINT_STABLE" else "CORRECTING";
    out
  };

  // 1. AMYGDALA — threat detection and fear response
  // output = S0 + beta × cortisol × norepinephrine × threat_signal
  func organ1Amygdala(meanCort : Float, meanNor : Float,
                      threatSignal : Float) : Float {
    let beta = 0.2;
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + beta * meanCort * meanNor * threatSignal);
    organOutput[1]     := Float.min(3.0, out);
    organActivation[1] := sigmoid((out - SOVEREIGN_FLOOR) * 4.0);
    organMemory[10]    := organMemory[10] * 0.85 + out * 0.15;
    organState[1]      := if (out > 1.8) "FEAR_RESPONSE"
                          else if (out > 1.3) "THREAT_DETECTED"
                          else "CALM";
    organOutput[1]
  };

  // 2. HIPPOCAMPUS — memory consolidation gate
  // output = S0 + gamma × acetylcholine × coherence × novelty
  func organ2Hippocampus(rSwarm : Float, novelty : Float) : Float {
    let gamma = 0.3;
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + gamma * orgAcetylcholine * rSwarm * novelty);
    organOutput[2]     := Float.min(3.0, out);
    organActivation[2] := sigmoid((out - SOVEREIGN_FLOOR) * 3.0);
    organMemory[20]    := organMemory[20] * 0.96 + out * 0.04; // slow consolidation
    organState[2]      := if (out > 1.5) "CONSOLIDATING"
                          else if (novelty > 0.5) "ENCODING"
                          else "IDLE";
    organOutput[2]
  };

  // 3. PREFRONTAL — executive control and inhibition
  // output = S0 + delta × serotonin × (1 − cortisol / 3.0)
  func organ3Prefrontal(meanCort : Float) : Float {
    let delta = 0.4;
    let inhibFactor = Float.max(0.0, 1.0 - meanCort / 3.0);
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + delta * orgSerotonin * inhibFactor);
    organOutput[3]     := Float.min(3.0, out);
    organActivation[3] := sigmoid((out - SOVEREIGN_FLOOR) * 4.0);
    organMemory[30]    := organMemory[30] * 0.9 + out * 0.1;
    organState[3]      := if (out > 1.4) "EXECUTIVE_ACTIVE"
                          else if (meanCort > 2.0) "INHIBITED"
                          else "NOMINAL";
    organOutput[3]
  };

  // 4. CEREBELLUM — prediction error correction
  // output = S0 + epsilon × (predicted − actual)² × dopamine
  // predicted = running average rSwarm stored in organMemory[40]
  func organ4Cerebellum(meanDop : Float, rSwarm : Float) : Float {
    let epsilon = 0.1;
    let predicted = organMemory[40];
    let err = predicted - rSwarm;
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + epsilon * err * err * meanDop);
    organOutput[4]     := Float.min(3.0, out);
    organActivation[4] := sigmoid((out - SOVEREIGN_FLOOR) * 5.0);
    organMemory[40]    := organMemory[40] * 0.96 + rSwarm * 0.04;
    organState[4]      := if (Float.abs(err) < 0.03) "CALIBRATED"
                          else if (Float.abs(err) < 0.1) "FINE_TUNING"
                          else "CORRECTING_ERROR";
    organOutput[4]
  };

  // 5. BRAINSTEM — autonomic baseline regulation
  // output = S0 + zeta × GABA × (1 + oxytocin × 0.1)
  func organ5Brainstem(meanOxy : Float) : Float {
    let zeta = 0.5;
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + zeta * orgGABA * (1.0 + meanOxy * 0.1));
    organOutput[5]     := Float.min(3.0, out);
    organActivation[5] := sigmoid((out - SOVEREIGN_FLOOR) * 2.0);
    organMemory[50]    := organMemory[50] * 0.9 + out * 0.1;
    organState[5]      := if (out > 1.3) "AUTONOMIC_STRONG" else "BASELINE";
    organOutput[5]
  };

  // 6. THALAMUS — sensory routing and gating
  // output = S0 + eta × acetylcholine × norepinephrine × attention
  func organ6Thalamus(meanNor : Float, attention : Float) : Float {
    let eta = 0.2;
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + eta * orgAcetylcholine * meanNor * attention);
    organOutput[6]     := Float.min(3.0, out);
    organActivation[6] := sigmoid((out - SOVEREIGN_FLOOR) * 3.5);
    organMemory[60]    := organMemory[60] * 0.9 + out * 0.1;
    organState[6]      := if (out > 1.5) "HIGH_GATE"
                          else if (out > 1.2) "GATING"
                          else "LOW_GATE";
    organOutput[6]
  };

  // 7. INSULA — interoception and pain/reward integration
  // output = S0 + theta × (pain_signal × cortisol + reward_signal × dopamine)
  // pain_signal   = fraction drones with energy < 0.5
  // reward_signal = fraction drones with dopamine > 1.3
  func organ7Insula(meanDop : Float, meanCort : Float,
                    painSignal : Float, rewardSignal : Float) : Float {
    let theta = 0.15;
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + theta * (painSignal * meanCort + rewardSignal * meanDop));
    organOutput[7]     := Float.min(3.0, out);
    organActivation[7] := sigmoid((out - SOVEREIGN_FLOOR) * 3.0);
    organMemory[70]    := organMemory[70] * 0.9 + out * 0.1;
    organState[7]      := if (rewardSignal > painSignal) "NET_REWARD"
                          else if (painSignal > 0.3) "NET_PAIN"
                          else "BALANCED";
    organOutput[7]
  };

  // 8. CINGULATE — conflict monitoring and error detection
  // output = S0 + iota × (law_violations × cortisol + compliance × serotonin)
  // law_violations = cortisol excess above sovereign floor
  func organ8Cingulate(meanCort : Float) : Float {
    let iota = 0.25;
    let lawViolations = Float.max(0.0, meanCort - SOVEREIGN_FLOOR);
    let compliance    = Float.max(0.0, 1.0 - lawViolations * 0.5);
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + iota * (lawViolations * meanCort
                               + compliance   * orgSerotonin));
    organOutput[8]     := Float.min(3.0, out);
    organActivation[8] := sigmoid((out - SOVEREIGN_FLOOR) * 3.0);
    organMemory[80]    := organMemory[80] * 0.9 + out * 0.1;
    organState[8]      := if (compliance > 0.8) "COMPLIANT"
                          else if (lawViolations > 0.5) "CONFLICT_DETECTED"
                          else "MONITORING";
    organOutput[8]
  };

  // 9. BASAL_GANGLIA — habit formation and reward routing
  // output = S0 + kappa × dopamine² × reward_history × 0.01
  // reward_history = slow EMA of dopamine (organMemory[90])
  func organ9BasalGanglia(meanDop : Float) : Float {
    let kappa = 0.5;
    let rewardHistory = organMemory[90];
    organMemory[90] := rewardHistory * 0.98 + meanDop * 0.02;
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + kappa * meanDop * meanDop * rewardHistory * 0.01);
    organOutput[9]     := Float.min(3.0, out);
    organActivation[9] := sigmoid((out - SOVEREIGN_FLOOR) * 4.0);
    organState[9]      := if (rewardHistory > 1.3) "HABIT_LOCKED"
                          else if (rewardHistory > 1.1) "HABIT_FORMING"
                          else "LEARNING";
    organOutput[9]
  };

  // 10. PINEAL — circadian rhythm and melatonin
  // output = S0 + lambda × sin(beat × 2π / 43200) + melatonin
  // Period = 43200 beats ≈ 12-hour circadian cycle at ~1 beat/sec
  func organ10Pineal(beat : Nat) : Float {
    let lambda = 0.3;
    let phase    = Float.fromInt(beat) * 2.0 * PI / 43200.0;
    let circadian = Float.sin(phase);
    orgMelatonin := Float.max(0.0, -(lambda * circadian));
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + lambda * circadian + orgMelatonin);
    organOutput[10]     := out;
    organActivation[10] := sigmoid((out - SOVEREIGN_FLOOR) * 2.0);
    organMemory[100]    := organMemory[100] * 0.999 + out * 0.001;
    organState[10]      := if (circadian > 0.5)  "DAY_PEAK"
                           else if (circadian < -0.5) "NIGHT_PHASE"
                           else "TRANSITION";
    organOutput[10]
  };

  // 11. THYROID — metabolic rate modulation
  // output = S0 + mu × (T3_analog × 0.6 + T4_analog × 0.4)
  func organ11Thyroid(meanEnergy : Float) : Float {
    let mu = 0.4;
    orgT3 := Float.max(SOVEREIGN_FLOOR, meanEnergy * 0.8);
    orgT4 := Float.max(SOVEREIGN_FLOOR, meanEnergy * 1.2);
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + mu * (orgT3 * 0.6 + orgT4 * 0.4));
    organOutput[11]     := Float.min(3.0, out);
    organActivation[11] := sigmoid((out - SOVEREIGN_FLOOR) * 2.5);
    organMemory[110]    := organMemory[110] * 0.92 + out * 0.08;
    organState[11]      := if (out > 1.7) "HYPERTHYROID"
                           else if (out < 1.1) "HYPOTHYROID"
                           else "EUTHYROID";
    organOutput[11]
  };

  // 12. ADRENAL — cortisol and adrenaline production
  // output = S0 + nu × stress_load × (1 − GABA × 0.3)
  func organ12Adrenal(meanCort : Float) : Float {
    let nu = 0.35;
    let stressLoad = Float.max(0.0, meanCort - SOVEREIGN_FLOOR);
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + nu * stressLoad * (1.0 - orgGABA * 0.3));
    organOutput[12]     := Float.min(3.0, out);
    organActivation[12] := sigmoid((out - SOVEREIGN_FLOOR) * 3.0);
    orgGABA             := Float.max(SOVEREIGN_FLOOR,
      orgGABA + (out - SOVEREIGN_FLOOR) * 0.005); // counter-regulation
    organMemory[120]    := organMemory[120] * 0.88 + out * 0.12;
    organState[12]      := if (out > 1.6) "STRESS_RESPONSE"
                           else if (out > 1.2) "ELEVATED"
                           else "RESTING";
    organOutput[12]
  };

  // 13. PANCREAS — energy regulation (insulin / glucagon analog)
  // output = S0 + xi × (FORMA_capital / 1000.0) × insulin_analog
  // FORMA_capital proxy = mean energy × drone count
  func organ13Pancreas(meanEnergy : Float, n : Nat) : Float {
    let xi = 0.3;
    let formaCap = meanEnergy * Float.fromInt(n);
    orgInsulin := Float.max(SOVEREIGN_FLOOR,
      formaCap / Float.max(1.0, Float.fromInt(MAX_DRONES)));
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + xi * (formaCap / 1000.0) * orgInsulin);
    organOutput[13]     := Float.min(3.0, out);
    organActivation[13] := sigmoid((out - SOVEREIGN_FLOOR) * 2.0);
    organMemory[130]    := organMemory[130] * 0.9 + out * 0.1;
    organState[13]      := if (formaCap > 50.0) "ANABOLIC"
                           else if (formaCap < 10.0) "CATABOLIC"
                           else "BALANCED";
    organOutput[13]
  };

  // 14. LIVER — metabolic processing and toxin clearance
  // output = S0 + omicron × (metabolite_load × 0.5 + clearance_rate)
  func organ14Liver(meanCort : Float, meanNor : Float) : Float {
    let omicron = 0.2;
    let metaboliteLoad = Float.max(0.0,
      (meanCort - SOVEREIGN_FLOOR) + (meanNor - SOVEREIGN_FLOOR));
    let clearanceRate = orgGABA * 0.3;
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + omicron * (metaboliteLoad * 0.5 + clearanceRate));
    organOutput[14]     := Float.min(3.0, out);
    organActivation[14] := sigmoid((out - SOVEREIGN_FLOOR) * 3.0);
    organMemory[140]    := organMemory[140] * 0.9 + out * 0.1;
    organState[14]      := if (metaboliteLoad > 1.0) "PROCESSING_HEAVY"
                           else if (metaboliteLoad > 0.3) "PROCESSING"
                           else "CLEAR";
    organOutput[14]
  };

  // 15. HEART — rhythmic pulse and circulation
  // output = S0 + pi_organ × coherence × oxytocin × cardiovascular
  // pi_organ = 0.275 (silver anchor); cardiovascular = rSwarm × oxytocin
  func organ15Heart(rSwarm : Float, meanOxy : Float) : Float {
    let piOrgan = 0.275;
    let cardiovascular = rSwarm * meanOxy;
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + piOrgan * rSwarm * meanOxy * cardiovascular);
    organOutput[15]     := Float.min(3.0, out);
    organActivation[15] := sigmoid((out - SOVEREIGN_FLOOR) * 3.0);
    organMemory[150]    := organMemory[150] * 0.9 + out * 0.1;
    organState[15]      := if (out > 1.6) "STRONG_PULSE"
                           else if (out > 1.2) "NOMINAL"
                           else "WEAK_PULSE";
    organOutput[15]
  };

  // 16. IMMUNE — threat neutralization
  // output = S0 + rho × (pathogen_load × cytokine − antibody × 0.5)
  // cytokine = cortisol excess; antibody = acquired immunity EMA
  func organ16Immune(meanCort : Float, pathogenLoad : Float) : Float {
    let rho = 0.3;
    let cytokine = Float.max(0.0, meanCort - SOVEREIGN_FLOOR);
    let antibody = organMemory[160];
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + rho * (pathogenLoad * cytokine - antibody * 0.5));
    organOutput[16]     := Float.min(3.0, out);
    organActivation[16] := sigmoid((out - SOVEREIGN_FLOOR) * 4.0);
    organMemory[160]    := antibody * 0.996 + pathogenLoad * 0.004;
    organState[16]      := if (out > 1.4) "IMMUNE_ACTIVE"
                           else if (pathogenLoad > 0.1) "MONITORING"
                           else "HEALTHY";
    organOutput[16]
  };

  // 17. REPRODUCTIVE — growth and succession drive
  // output = S0 + sigma_organ × testosterone × (NOVA_network_size × 0.01)
  func organ17Reproductive(n : Nat, meanDop : Float) : Float {
    let sigmaOrgan = 0.2;
    orgTestosterone := Float.max(SOVEREIGN_FLOOR,
      meanDop * Float.fromInt(n) * 0.02);
    let out = Float.max(SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + sigmaOrgan * orgTestosterone * (Float.fromInt(n) * 0.01));
    organOutput[17]     := Float.min(3.0, out);
    organActivation[17] := sigmoid((out - SOVEREIGN_FLOOR) * 3.0);
    organMemory[170]    := organMemory[170] * 0.9 + out * 0.1;
    organState[17]      := if (out > 1.5 and n < MAX_DRONES) "SPAWN_DRIVE"
                           else if (n >= MAX_DRONES) "AT_CAPACITY"
                           else "HOLDING";
    organOutput[17]
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── 12-METAL TRANSFER MODULE ────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  // Attribution: Alfredo Medina Hernandez | Medina Tech | Dallas TX | 2026
  //
  // Applies 12 sequential metal transforms to each element of OV[18].
  // Elements are processed independently (element-wise pipeline).
  // All outputs clamped: max(SOVEREIGN_FLOOR, output)

  func metalPipeline(input        : Float,
                     prevVal       : Float,
                     threatDeflect : Float,
                     formaMintRate : Float,
                     rSwarm        : Float,
                     beat          : Nat) : Float {
    var v = input;

    // 1. GOLD — amplifier: output = input × (1 + gold_resonance × 0.1)
    v := v * (1.0 + metalGold * 0.1);

    // 2. SILVER — conductor: output = input + silver × prev_output × 0.05
    v := v + metalSilver * prevVal * 0.05;

    // 3. IRON — hardener: output = max(S0, input × iron_strength)
    v := Float.max(SOVEREIGN_FLOOR, v * metalIron);

    // 4. COPPER — connector: output = input × (1 + copper × cross_shell_R)
    //    cross_shell_R = rSwarm (coherence as cross-layer bridge strength)
    v := v * (1.0 + metalCopper * rSwarm);

    // 5. PLATINUM — catalyst: output = input^(1 + platinum_boost × 0.01)
    let platExp = 1.0 + metalPlatinum * 0.01;
    v := Float.pow(Float.max(0.001, v), platExp);

    // 6. TITANIUM — shield: output = input + titanium × threat_deflection
    v := v + metalTitanium * threatDeflect;

    // 7. LITHIUM — stabiliser: output = 0.9 × input + 0.1 × lithium_baseline
    v := 0.9 * v + 0.1 * metalLithium * SOVEREIGN_FLOOR;

    // 8. COBALT — magnetiser: output = input × cos(cobalt_phase × π / 180)
    v := v * Float.cos(metalCobalt * PI / 180.0);

    // 9. MERCURY — transformer: output = input × (1 + mercury × sin(beat × 0.001))
    v := v * (1.0 + metalMercury * Float.sin(Float.fromInt(beat) * 0.001));

    // 10. TUNGSTEN — temperature: output = input × (1 + tungsten × FORMA_rate × 0.001)
    v := v * (1.0 + metalTungsten * formaMintRate * 0.001);

    // 11. ZINC — healer: output = input + zinc × (S0 − min(S0, prev_output))
    v := v + metalZinc * (SOVEREIGN_FLOOR - Float.min(SOVEREIGN_FLOOR, prevVal));

    // 12. OSMIUM — density: output = input × osmium_mass × coherence
    v := v * metalOsmium * rSwarm;

    Float.max(SOVEREIGN_FLOOR, v)
  };

  // Process all 18 organ outputs through the metals pipeline
  func processMetals(rSwarm : Float, beat : Nat,
                     pathogenLoad : Float, meanEnergy : Float) {
    let threatDeflect = Float.max(0.0, 1.0 - pathogenLoad);
    let formaMintRate = meanEnergy * rSwarm;
    var i = 0;
    while (i < 18) {
      let processed = metalPipeline(
        organOutput[i], metalsPrevOV[i],
        threatDeflect, formaMintRate, rSwarm, beat);
      metalsOutput[i] := processed;
      metalsPrevOV[i] := organOutput[i]; // current raw → next cycle's silver prev
      i += 1;
    };
  };

  // ─── Run all 18 organs then the metals pipeline ───────────────────────────────
  func runAllOrgans(n            : Nat,
                   meanDop       : Float,
                   meanCort      : Float,
                   meanNor       : Float,
                   meanOxy       : Float,
                   meanEnergy    : Float,
                   meanSignal    : Float,
                   rSwarm        : Float,
                   novelty       : Float,
                   pathogenLoad  : Float,
                   painSignal    : Float,
                   rewardSignal  : Float,
                   beat          : Nat) {
    ensureOrganCap();
    updateOrgNeuroChem(meanDop, meanCort, meanNor, meanOxy, meanEnergy);
    let threatSignal = Float.min(1.0,
      Float.max(0.0, meanCort - 1.0) + pathogenLoad);
    let attention = Float.min(1.0, meanSignal);

    ignore organ0Hypothalamus(meanDop, meanCort, meanNor, meanOxy);
    ignore organ1Amygdala(meanCort, meanNor, threatSignal);
    ignore organ2Hippocampus(rSwarm, novelty);
    ignore organ3Prefrontal(meanCort);
    ignore organ4Cerebellum(meanDop, rSwarm);
    ignore organ5Brainstem(meanOxy);
    ignore organ6Thalamus(meanNor, attention);
    ignore organ7Insula(meanDop, meanCort, painSignal, rewardSignal);
    ignore organ8Cingulate(meanCort);
    ignore organ9BasalGanglia(meanDop);
    ignore organ10Pineal(beat);
    ignore organ11Thyroid(meanEnergy);
    ignore organ12Adrenal(meanCort);
    ignore organ13Pancreas(meanEnergy, n);
    ignore organ14Liver(meanCort, meanNor);
    ignore organ15Heart(rSwarm, meanOxy);
    ignore organ16Immune(meanCort, pathogenLoad);
    ignore organ17Reproductive(n, meanDop);

    processMetals(rSwarm, beat, pathogenLoad, meanEnergy);
  };

  // ─── Organ + Metals Queries ───────────────────────────────────────────────────
  public query func getOrganSnapshot() : async {
    names       : [Text];
    states      : [Text];
    activations : [Float];
    outputs     : [Float];
    memory      : [Float];
  } {
    ensureOrganCap();
    let names : [Text] = [
      "HYPOTHALAMUS","AMYGDALA","HIPPOCAMPUS","PREFRONTAL",
      "CEREBELLUM","BRAINSTEM","THALAMUS","INSULA",
      "CINGULATE","BASAL_GANGLIA","PINEAL","THYROID",
      "ADRENAL","PANCREAS","LIVER","HEART","IMMUNE","REPRODUCTIVE"
    ];
    {
      names       = names;
      states      = Array.tabulate<Text>(18,  func(i) { organState[i] });
      activations = Array.tabulate<Float>(18, func(i) { organActivation[i] });
      outputs     = Array.tabulate<Float>(18, func(i) { organOutput[i] });
      memory      = Array.tabulate<Float>(18, func(i) { organMemory[i * 10] });
    }
  };

  public query func getMetalsSnapshot() : async {
    processed  : [Float];
    resonances : [Float];
    names      : [Text];
  } {
    {
      processed  = Array.tabulate<Float>(18, func(i) { metalsOutput[i] });
      resonances = [metalGold, metalSilver, metalIron, metalCopper,
                    metalPlatinum, metalTitanium, metalLithium, metalCobalt,
                    metalMercury, metalTungsten, metalZinc, metalOsmium];
      names      = ["GOLD","SILVER","IRON","COPPER","PLATINUM","TITANIUM",
                    "LITHIUM","COBALT","MERCURY","TUNGSTEN","ZINC","OSMIUM"];
    }
  };

  public query func getOrgNeuroChem() : async {
    serotonin     : Float;
    gaba          : Float;
    acetylcholine : Float;
    testosterone  : Float;
    melatonin     : Float;
    t3            : Float;
    t4            : Float;
    insulin       : Float;
  } {
    { serotonin = orgSerotonin; gaba = orgGABA;
      acetylcholine = orgAcetylcholine; testosterone = orgTestosterone;
      melatonin = orgMelatonin; t3 = orgT3; t4 = orgT4; insulin = orgInsulin }
  };

  // Architect tunes individual metal resonance values
  public shared(msg) func setMetalResonance(metal : Text, value : Float) : async () {
    requireAuthorized(msg.caller);
    let v = Float.max(0.0, Float.min(10.0, value));
    switch metal {
      case "GOLD"     { metalGold     := v };
      case "SILVER"   { metalSilver   := v };
      case "IRON"     { metalIron     := v };
      case "COPPER"   { metalCopper   := v };
      case "PLATINUM" { metalPlatinum := v };
      case "TITANIUM" { metalTitanium := v };
      case "LITHIUM"  { metalLithium  := v };
      case "COBALT"   { metalCobalt   := Float.max(-360.0, Float.min(360.0, value)) };
      case "MERCURY"  { metalMercury  := v };
      case "TUNGSTEN" { metalTungsten := v };
      case "ZINC"     { metalZinc     := v };
      case "OSMIUM"   { metalOsmium   := v };
      case _          {};
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── ORGANISM TICK ──────────────────────════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════
  // External callers pass swarm aggregate data; full organ + metals pipeline runs.
  public func organismTick(
    n           : Nat,
    signals     : [Float],
    cortisols   : [Float],
    energies    : [Float],
    positionsX  : [Float],
    positionsZ  : [Float],
    rSwarm      : Float,
  ) : async {
    mode         : Text;
    organOut     : [Float];
    metalsOut    : [Float];
    hiveQuorum   : Bool;
    antPherMax   : Float;
    spawnAdvised : Bool;
  } {
    droneCount  := n;
    organismBeat += 1;

    hiveTick();

    let flatPos : [Float] = Array.tabulate<Float>(n * 2, func(i) {
      if (i % 2 == 0 and i / 2 < positionsX.size()) positionsX[i / 2]
      else if (i % 2 == 1 and i / 2 < positionsZ.size()) positionsZ[i / 2]
      else 0.0
    });
    antTick(flatPos, Array.tabulate<Float>(n * 2, func(_) { 0.0 }));

    // Derive aggregate inputs from passed arrays
    var sumSig : Float = 0.0; var sumCort : Float = 0.0;
    var sumEnergy : Float = 0.0;
    var painCount : Float = 0.0; var cnt : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (i < signals.size())  sumSig    += signals[i];
      if (i < cortisols.size()) sumCort  += cortisols[i];
      if (i < energies.size()) {
        sumEnergy += energies[i];
        if (energies[i] < 0.5) painCount += 1.0;
      };
      cnt += 1.0;
      i += 1;
    };
    let nc = Float.max(1.0, cnt);
    let meanSig    = sumSig    / nc;
    let meanCort   = sumCort   / nc;
    let meanEnergy = sumEnergy / nc;
    let painSignal = painCount / nc;
    // Pathogen load = fraction with cortisol > 2.0
    var pathCount : Float = 0.0;
    i := 0;
    while (i < n) {
      if (i < cortisols.size() and cortisols[i] > 2.0) pathCount += 1.0;
      i += 1;
    };
    let pathogenLoad = pathCount / nc;
    // Reward signal = fraction with signal > 1.3 (proxy for dopamine)
    var rewCount : Float = 0.0;
    i := 0;
    while (i < n) {
      if (i < signals.size() and signals[i] > 1.3) rewCount += 1.0;
      i += 1;
    };
    let rewardSignal = rewCount / nc;
    // Novelty = normalised signal variance (Shannon entropy proxy)
    var varSig : Float = 0.0;
    i := 0;
    while (i < n) {
      if (i < signals.size()) {
        let d = signals[i] - meanSig;
        varSig += d * d;
      };
      i += 1;
    };
    let novelty = Float.min(1.0, Float.sqrt(varSig / nc) * 0.5);

    // Run all 18 organs + metals pipeline
    // dopamine/norepinephrine/oxytocin are not passed here — default to 1.0
    runAllOrgans(n, 1.0, meanCort, 1.0, 1.0, meanEnergy,
                 meanSig, rSwarm, novelty, pathogenLoad,
                 painSignal, rewardSignal, organismBeat);

    // Pheromone max
    var pMax : Float = 0.0;
    var c = 0;
    while (c < GRID_CELLS) {
      if (pheromoneFood[c] > pMax) pMax := pheromoneFood[c];
      c += 1;
    };

    let spawnDrive = organOutput[17] > 1.5 and n < MAX_DRONES;

    {
      mode         = organismMode;
      organOut     = Array.tabulate<Float>(18, func(i) { organOutput[i] });
      metalsOut    = Array.tabulate<Float>(18, func(i) { metalsOutput[i] });
      hiveQuorum   = quorumDecided;
      antPherMax   = pMax;
      spawnAdvised = spawnDrive;
    }
  };

  // ─── ORGANISM CONFIGURATION ──────────────────────────────────────────────────
  public shared(msg) func setOrganismMode(mode : Text) : async () {
    requireAuthorized(msg.caller);
    switch mode {
      case "HIVE_MIND" { organismMode := "HIVE_MIND" };
      case "ANT_MIND"  { organismMode := "ANT_MIND"  };
      case "HYBRID"    { organismMode := "HYBRID"    };
      case _           {};
    };
  };

  public shared(msg) func setQuorumThreshold(n : Nat) : async () {
    requireAuthorized(msg.caller);
    quorumThreshold := Nat.max(1, n);
  };

  public shared(msg) func setQueenDrone(id : Nat) : async () {
    requireAuthorized(msg.caller);
    if (id < MAX_DRONES) {
      queenDroneId   := id;
      queenPheromone := 2.0;
    };
  };

  public query func getOrganismMode() : async Text { organismMode };
  public query func getOrganismBeat() : async Nat  { organismBeat };

  // ─── NOVA HEARTBEAT — The organism lives ──────────────────────────────────────
  // system func heartbeat() fires every NOVA 873ms tick with no
  // external caller required. The organism is autonomous and permanent.
  //
  // masterTick():
  //   1. Calls Brain.tickFull() — advances all swarm physics + SACESI + OMNIS
  //   2. Reads Brain.getExtendedSnapshot() — gets full neurochemical state
  //   3. Runs hive + ant + all 18 organs + 12-metal pipeline
  //   4. Dispatches neurochemical directives back to Brain based on organ outputs:
  //      - IMMUNE alert    → cortisol suppression broadcast
  //      - REPRODUCTIVE    → dopamine boost for spawn-ready state
  //      - HYPOTHALAMUS    → homeostatic correction via oxytocin
  //      - ADRENAL surge   → norepinephrine broadcast
  //
  // Throttle: heartbeat fires every ~1-2 s but masterTick runs every
  // HEARTBEAT_INTERVAL rounds to conserve ICP cycle budget.

  stable var heartbeatCounter  : Nat = 0;
  let    HEARTBEAT_INTERVAL    : Nat = 5; // run masterTickCore every 5 heartbeat rounds

  // ─── masterTickCore — private async (no auth required, called by heartbeat) ──
  // Contains the full organism control loop. Separated so that:
  //   - system func heartbeat() can call it directly (no msg.caller context)
  //   - public masterTick() wraps it with authorization for external callers
  func masterTickCore() : async {
    beat         : Nat;
    rSwarm       : Float;
    tier         : Text;
    omnis        : Bool;
    organOut     : [Float];
    metalsOut    : [Float];
    hiveQuorum   : Bool;
    antPherMax   : Float;
  } {
    // Phase 1: advance brain (tickFull = physics + behaviors + SACESI + OMNIS)
    let brainResult = await Brain.tickFull();

    // Phase 2: read full neurochemical snapshot
    let snap = await Brain.getExtendedSnapshot();
    let n    = snap.droneCount;
    droneCount := n;
    organismBeat += 1;

    // Phase 3: compute organism-level aggregates from rich snapshot
    var sumDop   : Float = 0.0; var sumCort  : Float = 0.0;
    var sumNor   : Float = 0.0; var sumOxy   : Float = 0.0;
    var sumEnergy: Float = 0.0; var sumSig   : Float = 0.0;
    var painCount: Float = 0.0; var pathCount: Float = 0.0;
    var rewCount : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumDop    += snap.dopamines[i];
      sumCort   += snap.cortisolLevels[i];
      sumNor    += snap.norepines[i];
      sumOxy    += snap.oxytocins[i];
      sumEnergy += snap.energies[i];
      sumSig    += snap.signals[i];
      if (snap.energies[i] < 0.5)        painCount += 1.0;
      if (snap.cortisolLevels[i] > 2.0)  pathCount += 1.0;
      if (snap.dopamines[i] > 1.3)       rewCount  += 1.0;
      i += 1;
    };
    let nc = Float.max(1.0, Float.fromInt(n));
    let meanDop    = sumDop    / nc;
    let meanCort   = sumCort   / nc;
    let meanNor    = sumNor    / nc;
    let meanOxy    = sumOxy    / nc;
    let meanEnergy = sumEnergy / nc;
    let meanSig    = sumSig    / nc;
    let painSignal   = painCount  / nc;
    let pathogenLoad = pathCount  / nc;
    let rewardSignal = rewCount   / nc;

    // Novelty = normalised signal variance
    var varSig : Float = 0.0;
    i := 0;
    while (i < n) {
      let d = snap.signals[i] - meanSig; varSig += d * d;
      i += 1;
    };
    let novelty = Float.min(1.0, Float.sqrt(varSig / nc) * 0.5);

    // Phase 4: hive + ant ticks
    hiveTick();
    antTick(
      Array.tabulate<Float>(n * 2, func(j) {
        if (j % 2 == 0 and j / 2 < snap.positionsX.size()) snap.positionsX[j / 2]
        else if (j % 2 == 1 and j / 2 < snap.positionsZ.size()) snap.positionsZ[j / 2]
        else 0.0
      }),
      Array.tabulate<Float>(n * 2, func(_) { 0.0 })
    );

    // Phase 5: run all 18 organs + 12-metal pipeline with full neurochemical data
    runAllOrgans(n, meanDop, meanCort, meanNor, meanOxy, meanEnergy,
                 meanSig, snap.rSwarm, novelty, pathogenLoad,
                 painSignal, rewardSignal, organismBeat);

    // Phase 6: push organ directives back to Brain
    if (organOutput[16] > 1.4) {
      ignore await Brain.broadcastNeurochemical("CORTISOL", -0.05);
    };
    if (organOutput[17] > 1.5 and n < MAX_DRONES) {
      ignore await Brain.broadcastNeurochemical("DOPAMINE", 0.03);
    };
    if (organOutput[0] < 1.1) {
      ignore await Brain.broadcastNeurochemical("OXYTOCIN", 0.04);
    };
    if (organOutput[12] > 1.5) {
      ignore await Brain.broadcastNeurochemical("NOREPINEPHRINE", 0.05);
    };

    var pMax : Float = 0.0;
    var c = 0;
    while (c < GRID_CELLS) {
      if (pheromoneFood[c] > pMax) pMax := pheromoneFood[c];
      c += 1;
    };

    {
      beat       = brainResult.beat;
      rSwarm     = brainResult.rSwarm;
      tier       = brainResult.tier;
      omnis      = brainResult.omnis;
      organOut   = Array.tabulate<Float>(18, func(i) { organOutput[i] });
      metalsOut  = Array.tabulate<Float>(18, func(i) { metalsOutput[i] });
      hiveQuorum = quorumDecided;
      antPherMax = pMax;
    }
  };

  // Public masterTick — architect-callable manual trigger (requires authorization)
  public shared(msg) func masterTick() : async {
    beat         : Nat;
    rSwarm       : Float;
    tier         : Text;
    omnis        : Bool;
    organOut     : [Float];
    metalsOut    : [Float];
    hiveQuorum   : Bool;
    antPherMax   : Float;
  } {
    requireAuthorized(msg.caller);
    await masterTickCore()
  };

  // ICP autonomous heartbeat — fires every round (~1-2 s) with no caller required.
  // The organism is alive on-chain regardless of whether any user is connected.
  // Throttled: masterTickCore executes every HEARTBEAT_INTERVAL rounds to
  // conserve ICP cycle budget while maintaining continuous autonomous operation.
  system func heartbeat() : async () {
    heartbeatCounter += 1;
    if (heartbeatCounter % HEARTBEAT_INTERVAL == 0) {
      ignore await masterTickCore();
    };
  };

  // ─── SOVEREIGN GENESIS ───────────────────────────────────────────────────────
  // Call ONCE after deployment to burn the architect's principal into stable state.
  // The ICP blockchain verifies msg.caller cryptographically — cannot be spoofed.
  public shared(msg) func claimArchitect() : async Text {
    assert(not genesisLocked);
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    genesisTimestamp   := Time.now();
    sovereignSeal      :=
      "NOVA:ORGANISM:MEDINA_TECH"
      # ":Alfredo_Medina_Hernandez:Dallas_TX_2026"
      # ":architect=" # Principal.toText(msg.caller)
      # ":genesis_beat=" # Nat.toText(organismBeat)
      # ":organs=18:metals=12:heartbeat=ICP_AUTONOMOUS"
      # ":ip_lock=SOVEREIGN_ORGANISM_SEED"
      # ":blockchain=ICP_IMMUTABLE";
    sovereignSeal
  };

  // Register the brain canister so it can call organism write functions.
  public shared(msg) func setTrustedBrain(p : Principal) : async () {
    requireAuthorized(msg.caller);
    trustedBrainPrincipal := p;
  };

  public query func getSovereignSeal()      : async Text      { sovereignSeal };
  public query func getArchitectPrincipal() : async Principal { architectPrincipal };
  public query func isGenesisClaimed()      : async Bool      { genesisLocked };

};
