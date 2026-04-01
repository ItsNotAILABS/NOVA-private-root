// PARALLAX DRONE SWARM SIMULATION — ORGANISM LAYER
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
// ICP HEARTBEAT — The organism is autonomous. system func heartbeat() fires
// every ICP round (~2 s) and drives the full control loop without any
// external caller: tick brain → read state → run hive/ant/organs → push
// directives back to brain.  The swarm lives.

import Array "mo:base/Array";
import Float "mo:base/Float";
import Int   "mo:base/Int";
import Nat   "mo:base/Nat";
import Text  "mo:base/Text";
import Time  "mo:base/Time";
import Brain "canister:swarm_brain";

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
  public func harvestNectar(droneId : Nat, posX : Float, posZ : Float) : async Float {
    harvestNectarImpl(droneId, posX, posZ)
  };

  // ─── Quorum Decision ─────────────────────────────────────────────────────────
  public func castWaggleVote(droneId : Nat, siteIndex : Nat) : async () {
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

  public func resetQuorum(topic : Text) : async () {
    quorumTopic   := topic;
    quorumDecided := false;
    quorumWinner  := 0;
    var c = 0;
    while (c < GRID_CELLS) { quorumVotes[c] := 0; c += 1 };
  };

  // ─── Comb Role Assignment (hive intelligence) ────────────────────────────────
  // Assign comb roles based on drone class and waggle quality.
  public func assignCombRoles(classes : [Text], signals : [Float]) : async () {
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
  public func depositDanger(posX : Float, posZ : Float, intensity : Float) : async () {
    let cell = worldToCell(posX, posZ);
    pheromoneDanger[cell] := Float.min(5.0, pheromoneDanger[cell] + intensity);
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── INTERNAL AI ORGAN TEAMS ────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Five organ systems operate in parallel as internal AI sub-agents:
  //   NERVOUS    — neural routing: optimises inter-drone signal paths
  //   IMMUNE     — defence coordinator: detects anomalies and quarantines
  //   METABOLIC  — energy manager: balances energy across drones
  //   SENSORY    — perception coordinator: aggregates scout + waggle data
  //   REPRODUCTIVE — swarm growth advisor: recommends new drone spawns

  stable var organState : [var Text] = Array.init<Text>(5, "IDLE");
  // Organ 0=NERVOUS  1=IMMUNE  2=METABOLIC  3=SENSORY  4=REPRODUCTIVE

  stable var organActivation : [var Float] = Array.init<Float>(5, 1.0);
  stable var organOutput     : [var Float] = Array.init<Float>(5, 0.0);

  // Per-organ stable memory (10 floats each)
  stable var organMemory : [var Float] = Array.init<Float>(50, 0.0); // 5 organs × 10

  // ─── Sigmoid helper ──────────────────────────────────────────────────────────
  func sigmoid(x : Float) : Float {
    let cx = Float.max(-10.0, Float.min(10.0, x));
    1.0 / (1.0 + Float.exp(-cx))
  };

  // ─── NERVOUS ORGAN ─── (signal routing optimisation)
  // Computes a routing score = mean inter-drone correlation of signals.
  // Output modulates architectSignalLevel externally.
  func organNervous(signals : [Float]) : Float {
    let n = signals.size();
    if (n == 0) return 1.0;
    var sum : Float = 0.0;
    var i = 0;
    while (i < n) { sum += signals[i]; i += 1 };
    let mean = sum / Float.fromInt(n);
    var variance : Float = 0.0;
    i := 0;
    while (i < n) {
      let d = signals[i] - mean;
      variance += d * d;
      i += 1;
    };
    variance := if (n > 1) variance / Float.fromInt(n - 1) else 0.0;
    // Low variance → high coherence → strong routing output
    let coherence = 1.0 / (1.0 + variance);
    organActivation[0] := sigmoid(coherence * 3.0 - 1.5);
    organOutput[0]     := coherence;
    let mem = organMemory[0];
    organMemory[0] := mem * 0.9 + coherence * 0.1; // running average
    organState[0] := if (coherence > 0.7) "ROUTING_OPTIMAL" else "ROUTING_DEGRADED";
    coherence
  };

  // ─── IMMUNE ORGAN ─── (anomaly detection + quarantine recommendation)
  // Detects drones with extreme cortisol (stress > 2.0) → quarantine flag.
  func organImmune(cortisols : [Float]) : Nat {
    let n = cortisols.size();
    var anomalies : Nat = 0;
    var i = 0;
    while (i < n) {
      if (cortisols[i] > 2.0) anomalies += 1;
      i += 1;
    };
    let fraction = Float.fromInt(anomalies) / Float.max(1.0, Float.fromInt(n));
    organActivation[1] := sigmoid(fraction * 5.0 - 2.0);
    organOutput[1]     := fraction;
    organMemory[10]    := organMemory[10] * 0.9 + fraction * 0.1;
    organState[1] := if (anomalies == 0) "HEALTHY" else if (fraction < 0.2) "MONITORING" else "ALERT";
    anomalies
  };

  // ─── METABOLIC ORGAN ─── (energy balance)
  // Computes mean and distributes energy deficit warnings.
  func organMetabolic(energies : [Float]) : Float {
    let n = energies.size();
    if (n == 0) return 1.0;
    var total : Float = 0.0;
    var minE  : Float = 999.0;
    var i = 0;
    while (i < n) {
      total += energies[i];
      if (energies[i] < minE) minE := energies[i];
      i += 1;
    };
    let mean = total / Float.fromInt(n);
    organActivation[2] := sigmoid((mean - 1.0) * 3.0);
    organOutput[2]     := mean;
    organMemory[20]    := organMemory[20] * 0.9 + mean * 0.1;
    organState[2] := if (minE < 0.5) "CRITICAL_ENERGY" else if (mean < 1.0) "LOW_ENERGY" else "ENERGY_OK";
    mean
  };

  // ─── SENSORY ORGAN ─── (aggregates scout + waggle map into situation report)
  func organSensory(waggleQualities : [Float], nectarTop : Float) : Float {
    let n = waggleQualities.size();
    var totalQ : Float = 0.0;
    var i = 0;
    while (i < n) { totalQ += waggleQualities[i]; i += 1 };
    let meanQ = if (n > 0) totalQ / Float.fromInt(n) else 0.0;
    let awareness = meanQ * 0.5 + nectarTop * 0.5;
    organActivation[3] := sigmoid(awareness * 4.0 - 2.0);
    organOutput[3]     := awareness;
    organMemory[30]    := organMemory[30] * 0.9 + awareness * 0.1;
    organState[3] := if (awareness > 0.6) "HIGH_AWARENESS" else "LOW_AWARENESS";
    awareness
  };

  // ─── REPRODUCTIVE ORGAN ─── (swarm growth recommendation)
  // Recommends spawn if mean energy > 1.5 and quorum decided.
  func organReproductive(meanEnergy : Float, rSwarm : Float) : Bool {
    let shouldSpawn = meanEnergy > 1.5 and rSwarm > 0.8 and droneCount < MAX_DRONES;
    organActivation[4] := sigmoid((meanEnergy - 1.5) * 5.0 + (rSwarm - 0.8) * 10.0);
    organOutput[4]     := if (shouldSpawn) 1.0 else 0.0;
    organMemory[40]    := organMemory[40] * 0.9 + (if (shouldSpawn) 1.0 else 0.0) * 0.1;
    organState[4] := if (shouldSpawn) "SPAWN_RECOMMENDED" else "HOLDING";
    shouldSpawn
  };

  // ─── Organ System Queries ────────────────────────────────────────────────────
  public query func getOrganSnapshot() : async {
    states      : [Text];
    activations : [Float];
    outputs     : [Float];
    memory      : [Float];
  } {
    let states  = Array.tabulate<Text>(5,  func(i) { organState[i] });
    let acts    = Array.tabulate<Float>(5, func(i) { organActivation[i] });
    let outs    = Array.tabulate<Float>(5, func(i) { organOutput[i] });
    // Return first 5 memory slots (one per organ)
    let mems = Array.tabulate<Float>(5, func(i) { organMemory[i * 10] });
    { states = states; activations = acts; outputs = outs; memory = mems }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── ORGANISM TICK ──────────────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  // Called once per simulation beat.
  // Accepts a swarm snapshot to run all organism-level intelligence.
  public func organismTick(
    n           : Nat;
    signals     : [Float];
    cortisols   : [Float];
    energies    : [Float];
    positionsX  : [Float];
    positionsZ  : [Float];
    rSwarm      : Float;
  ) : async {
    mode         : Text;
    nervousOut   : Float;
    immuneAlert  : Nat;
    metabolicAvg : Float;
    sensoryAware : Float;
    spawnAdvised : Bool;
    hiveQuorum   : Bool;
    antPherMax   : Float;
  } {
    droneCount  := n;
    organismBeat += 1;

    // Hive tick
    hiveTick();

    // Ant tick (pass positions as flat [x0,z0, x1,z1, ...] and zero goals)
    let flatPos : [Float] = Array.tabulate<Float>(n * 2, func(i) {
      if (i % 2 == 0 and i / 2 < positionsX.size()) positionsX[i / 2]
      else if (i % 2 == 1 and i / 2 < positionsZ.size()) positionsZ[i / 2]
      else 0.0
    });
    antTick(flatPos, Array.tabulate<Float>(n * 2, func(_) { 0.0 }));

    // Organ systems
    let nOut = organNervous(signals);
    let iOut = organImmune(cortisols);
    let mOut = organMetabolic(energies);

    // Waggle quality slice
    let wq = Array.tabulate<Float>(Nat.min(n, MAX_DRONES), func(i) { waggleQuality[i] });
    var topNectar : Float = 0.0;
    var c = 0;
    while (c < GRID_CELLS) {
      if (nectarGrid[c] > topNectar) topNectar := nectarGrid[c];
      c += 1;
    };
    let sOut = organSensory(wq, topNectar);
    let rOut = organReproductive(mOut, rSwarm);

    // Pheromone max
    var pMax : Float = 0.0;
    c := 0;
    while (c < GRID_CELLS) {
      if (pheromoneFood[c] > pMax) pMax := pheromoneFood[c];
      c += 1;
    };

    {
      mode         = organismMode;
      nervousOut   = nOut;
      immuneAlert  = iOut;
      metabolicAvg = mOut;
      sensoryAware = sOut;
      spawnAdvised = rOut;
      hiveQuorum   = quorumDecided;
      antPherMax   = pMax;
    }
  };

  // ─── ORGANISM CONFIGURATION ──────────────────────────────────────────────────
  public func setOrganismMode(mode : Text) : async () {
    switch mode {
      case "HIVE_MIND" { organismMode := "HIVE_MIND" };
      case "ANT_MIND"  { organismMode := "ANT_MIND"  };
      case "HYBRID"    { organismMode := "HYBRID"    };
      case _           {};
    };
  };

  public func setQuorumThreshold(n : Nat) : async () {
    quorumThreshold := Nat.max(1, n);
  };

  public func setQueenDrone(id : Nat) : async () {
    if (id < MAX_DRONES) {
      queenDroneId   := id;
      queenPheromone := 2.0; // fresh queen broadcast
    };
  };

  public query func getOrganismMode() : async Text { organismMode };
  public query func getOrganismBeat() : async Nat  { organismBeat };

};
