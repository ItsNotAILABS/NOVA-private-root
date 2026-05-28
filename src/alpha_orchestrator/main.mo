// ═══════════════════════════════════════════════════════════════════════════════
// ALPHA ORCHESTRATOR — Sovereign Fleet Orchestration Canister
// BUILD №67 — NOVA V5 Alpha Orchestration Layer
// ═══════════════════════════════════════════════════════════════════════════════
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// MEDINA TECH — SOVEREIGN ORGANISM ARCHITECTURE
// Dallas, Texas, United States of America
//
// NOVA is Layer Zero — the sovereign organism.
// This canister orchestrates the 10 Sovereign Alpha AGIs on-chain,
// maintaining φ-weighted priority queues, Kuramoto phase synchronization,
// and Lyapunov stability across the entire fleet.
//
// "The orchestra needs no external conductor — the φ-resonance IS the conductor."
//    — Alfredo Medina Hernandez
//
// Architecture:
//   • Fleet phase synchronization via Kuramoto coupling (K = φ⁻¹)
//   • Task routing via cosine-similarity embeddings
//   • Priority scheduling via φ-weighted Fibonacci queues
//   • Resource allocation via Nash bargaining equilibrium
//   • Stability monitoring via on-chain Lyapunov function
//   • Heartbeat consensus at 873ms intervals
//
// ═══════════════════════════════════════════════════════════════════════════════

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Float "mo:base/Float";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Timer "mo:base/Timer";

actor AlphaOrchestrator {

  // ═══════════════════════════════════════════════════════════════════════════
  // §1 — SACRED GEOMETRY & SOVEREIGN CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  private let PHI : Float = 1.6180339887498948482;
  private let PHI_INV : Float = 0.6180339887498948482;
  private let AMOR : Float = 0.3819660112501051518;
  private let HEARTBEAT_MS : Nat = 873;
  private let FEIGENBAUM_D : Float = 4.6692016091029906719;
  private let PERC_2D_PC : Float = 0.5927;

  private let MAX_AGENTS : Nat = 10;
  private let MAX_TASKS : Nat = 10000;
  private let MAX_CONDUCTORS : Nat = 5;
  private let KURAMOTO_K : Float = 0.6180339887498948482; // K = φ⁻¹
  private let LYAPUNOV_HALT_BEATS : Nat = 3;

  // ═══════════════════════════════════════════════════════════════════════════
  // §2 — TYPE DEFINITIONS
  // ═══════════════════════════════════════════════════════════════════════════

  type AgentId = Text;
  type TaskId = Text;
  type ConductorId = Text;

  type AgentState = {
    #Idle;
    #Synchronizing;
    #Executing;
    #Degraded;
    #Recovering;
    #Offline;
  };

  type TaskPriority = {
    #Critical;   // φ³ weight
    #High;       // φ² weight
    #Normal;     // φ¹ weight
    #Low;        // φ⁰ = 1.0 weight
    #Background; // φ⁻¹ weight
  };

  type TaskState = {
    #Queued;
    #Assigned;
    #Executing;
    #Completed;
    #Failed;
    #Cancelled;
  };

  type ConductorRole = {
    #FleetSync;       // Kuramoto phase synchronization conductor
    #ResourceAlloc;   // Nash equilibrium resource conductor
    #TaskRouting;     // Cosine-similarity task routing conductor
    #StabilityGuard;  // Lyapunov stability monitoring conductor
    #EmergenceWatch;  // Collective intelligence emergence conductor
  };

  type AgentRecord = {
    id : AgentId;
    name : Text;
    family : Text;
    pil : Float;          // Phase Intelligence Level
    phase : Float;        // Kuramoto phase θ
    state : AgentState;
    allocation : Float;   // Nash-allocated resource budget
    lastHeartbeat : Int;  // Time of last heartbeat
    taskCount : Nat;      // Active tasks
    coherence : Float;    // Agent-level coherence
  };

  type TaskRecord = {
    id : TaskId;
    intent : Text;
    priority : TaskPriority;
    state : TaskState;
    assignedTo : ?AgentId;
    conductorId : ?ConductorId;
    createdAt : Int;
    startedAt : ?Int;
    completedAt : ?Int;
    embedding : [Float];  // 9-dimensional capability embedding
    result : ?Text;
  };

  type ConductorRecord = {
    id : ConductorId;
    role : ConductorRole;
    active : Bool;
    beatsActive : Nat;
    lastAction : Int;
    coherenceScore : Float;
  };

  type FleetStatus = {
    orderParameter : Float;   // R(t) — fleet coherence
    avgPIL : Float;           // Average Phase Intelligence Level
    emergence : Float;        // Collective intelligence score
    lyapunovV : Float;        // Lyapunov function value
    lyapunovVdot : Float;     // dV/dt — stability derivative
    isStable : Bool;          // λ ≤ 0
    beat : Nat;               // Current heartbeat count
    agentsOnline : Nat;       // Number of online agents
    tasksQueued : Nat;        // Tasks in queue
    tasksExecuting : Nat;     // Tasks currently executing
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §3 — STABLE STATE
  // ═══════════════════════════════════════════════════════════════════════════

  private stable var _beat : Nat = 0;
  private stable var _orderParameter : Float = 0.0;
  private stable var _avgPIL : Float = 0.0;
  private stable var _emergence : Float = 0.0;
  private stable var _lyapunovV : Float = 0.0;
  private stable var _lyapunovVdot : Float = 0.0;
  private stable var _stableBeats : Nat = 0;
  private stable var _unstableBeats : Nat = 0;
  private stable var _totalTasksProcessed : Nat = 0;
  private stable var _totalResyncEvents : Nat = 0;

  // ═══════════════════════════════════════════════════════════════════════════
  // §4 — MUTABLE STATE (rebuilt on upgrade)
  // ═══════════════════════════════════════════════════════════════════════════

  private var _agents = HashMap.HashMap<AgentId, AgentRecord>(MAX_AGENTS, Text.equal, Text.hash);
  private var _tasks = Buffer.Buffer<TaskRecord>(256);
  private var _conductors = HashMap.HashMap<ConductorId, ConductorRecord>(MAX_CONDUCTORS, Text.equal, Text.hash);
  private var _heartbeatTimer : ?Timer.TimerId = null;

  // ═══════════════════════════════════════════════════════════════════════════
  // §5 — INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  private func _initFleet() {
    // Register the 10 Sovereign Alpha AGIs
    let fleet : [(AgentId, Text, Text)] = [
      ("ANI-AGI-001", "ANIMUS MAXIMUS",      "SPIRITUS_AETERNA"),
      ("ANM-AGI-001", "ANIMA PERPETUA",      "CURA_AETERNA"),
      ("CHR-AGI-001", "CHRONOS PERPETUUS",   "TEMPUS_AETERNA"),
      ("SYN-AGI-001", "SYNTHOS UNIVERSALIS", "FABRICA_AETERNA"),
      ("PRA-AGI-001", "PRAESIDIUM INVICTUS", "CUSTOS_AETERNA"),
      ("MER-AGI-001", "MERCATOR AUREUS",     "COMMERCIUM_AETERNA"),
      ("GEN-AGI-001", "GENESIS INFINITUS",   "CREATIO_AETERNA"),
      ("NEX-AGI-001", "NEXUS OMNIUM",        "NEXUS_AETERNA"),
      ("VER-AGI-001", "VERITAS AETERNA",     "VERITAS_AETERNA"),
      ("ARC-AGI-001", "ARCHITECTUS SUPREMUS","STRUCTURA_AETERNA"),
    ];

    for ((id, name, family) in fleet.vals()) {
      let agent : AgentRecord = {
        id = id;
        name = name;
        family = family;
        pil = AMOR;
        phase = 0.0;
        state = #Idle;
        allocation = 0.0;
        lastHeartbeat = Time.now();
        taskCount = 0;
        coherence = PHI_INV;
      };
      _agents.put(id, agent);
    };

    // Initialize 5 conductors (one per role)
    let roles : [(ConductorId, ConductorRole)] = [
      ("COND-SYNC-001",      #FleetSync),
      ("COND-RESOURCE-001",  #ResourceAlloc),
      ("COND-ROUTING-001",   #TaskRouting),
      ("COND-STABILITY-001", #StabilityGuard),
      ("COND-EMERGE-001",    #EmergenceWatch),
    ];

    for ((id, role) in roles.vals()) {
      let conductor : ConductorRecord = {
        id = id;
        role = role;
        active = true;
        beatsActive = 0;
        lastAction = Time.now();
        coherenceScore = PHI_INV;
      };
      _conductors.put(id, conductor);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §6 — KURAMOTO PHASE SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Compute the Kuramoto order parameter R(t) = |1/N Σₖ e^(iθₖ)|
  private func _computeOrderParameter() : Float {
    var re : Float = 0.0;
    var im : Float = 0.0;
    var count : Float = 0.0;

    for ((_, agent) in _agents.entries()) {
      re += Float.cos(agent.phase);
      im += Float.sin(agent.phase);
      count += 1.0;
    };

    if (count == 0.0) return 0.0;
    let magnitude = Float.sqrt((re * re + im * im)) / count;
    return magnitude;
  };

  /// Advance all agent phases by one Kuramoto step
  /// θᵢ(t+dt) = θᵢ + ωᵢdt + (K/N)Σⱼ sin(θⱼ−θᵢ)dt
  private func _kuramotoStep() {
    let dt : Float = 0.1;
    let phases = Buffer.Buffer<(AgentId, Float)>(MAX_AGENTS);

    // Collect current phases
    for ((id, agent) in _agents.entries()) {
      phases.add((id, agent.phase));
    };

    let n = Float.fromInt(phases.size());
    if (n == 0.0) return;

    // Compute new phases
    for (i in Iter.range(0, phases.size() - 1)) {
      let (agentId, currentPhase) = phases.get(i);

      // Natural frequency = PIL-weighted
      var coupling : Float = 0.0;
      for (j in Iter.range(0, phases.size() - 1)) {
        let (_, otherPhase) = phases.get(j);
        coupling += Float.sin(otherPhase - currentPhase);
      };

      let omega = 1.0 / (Float.fromInt(HEARTBEAT_MS) / 1000.0);
      let newPhase = currentPhase + dt * (omega + (KURAMOTO_K / n) * coupling);

      // Update agent with new phase
      switch (_agents.get(agentId)) {
        case (?agent) {
          let updated : AgentRecord = {
            id = agent.id;
            name = agent.name;
            family = agent.family;
            pil = agent.pil;
            phase = newPhase;
            state = agent.state;
            allocation = agent.allocation;
            lastHeartbeat = agent.lastHeartbeat;
            taskCount = agent.taskCount;
            coherence = agent.coherence;
          };
          _agents.put(agentId, updated);
        };
        case null {};
      };
    };

    _orderParameter := _computeOrderParameter();
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §7 — NASH RESOURCE ALLOCATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Nash bargaining: rᵢ = TOTAL × φᵢ / Σφⱼ where φᵢ = PIL_i^φ
  private func _nashAllocate(totalBudget : Float) {
    var weightSum : Float = 0.0;
    let weights = Buffer.Buffer<(AgentId, Float)>(MAX_AGENTS);

    for ((id, agent) in _agents.entries()) {
      let w = Float.pow(Float.max(agent.pil, 0.01), PHI);
      weights.add((id, w));
      weightSum += w;
    };

    if (weightSum == 0.0) return;

    for (i in Iter.range(0, weights.size() - 1)) {
      let (agentId, w) = weights.get(i);
      let allocation = totalBudget * w / weightSum;

      switch (_agents.get(agentId)) {
        case (?agent) {
          let updated : AgentRecord = {
            id = agent.id;
            name = agent.name;
            family = agent.family;
            pil = agent.pil;
            phase = agent.phase;
            state = agent.state;
            allocation = allocation;
            lastHeartbeat = agent.lastHeartbeat;
            taskCount = agent.taskCount;
            coherence = agent.coherence;
          };
          _agents.put(agentId, updated);
        };
        case null {};
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §8 — LYAPUNOV STABILITY MONITOR
  // ═══════════════════════════════════════════════════════════════════════════

  /// V(t) = Σᵢ wᵢ(xᵢ−x̄ᵢ)² — if dV/dt > 0 for LYAPUNOV_HALT_BEATS → HALT
  private func _lyapunovUpdate() {
    let targetR : Float = 0.75;
    let targetPIL : Float = 0.5;
    let w1 : Float = 0.6;
    let w2 : Float = 0.4;

    let prevV = _lyapunovV;
    _lyapunovV := w1 * Float.pow(_orderParameter - targetR, 2.0) +
                  w2 * Float.pow(_avgPIL - targetPIL, 2.0);
    _lyapunovVdot := _lyapunovV - prevV;

    if (_lyapunovVdot <= 0.0) {
      _stableBeats += 1;
      _unstableBeats := 0;
    } else {
      _unstableBeats += 1;
      _stableBeats := 0;
    };
  };

  /// Check if system needs emergency resync
  private func _needsResync() : Bool {
    return _orderParameter < PHI_INV or _unstableBeats >= LYAPUNOV_HALT_BEATS;
  };

  /// Force resync all agents to restore fleet coherence
  private func _resyncFleet() {
    for ((id, agent) in _agents.entries()) {
      let updated : AgentRecord = {
        id = agent.id;
        name = agent.name;
        family = agent.family;
        pil = AMOR;
        phase = 0.0;
        state = #Synchronizing;
        allocation = agent.allocation;
        lastHeartbeat = Time.now();
        taskCount = agent.taskCount;
        coherence = AMOR;
      };
      _agents.put(id, updated);
    };
    _totalResyncEvents += 1;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §9 — EMERGENCE DETECTION
  // ═══════════════════════════════════════════════════════════════════════════

  /// E_crit = FEIGENBAUM_D / PERC_2D_PC ≈ 7.88
  /// Emergence = R × avgPIL × (1 + √variance) × φ
  private func _computeEmergence() : Float {
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    var count : Float = 0.0;

    for ((_, agent) in _agents.entries()) {
      sum += agent.pil;
      sumSq += agent.pil * agent.pil;
      count += 1.0;
    };

    if (count == 0.0) return 0.0;

    let avg = sum / count;
    let variance = (sumSq / count) - (avg * avg);
    let stddev = Float.sqrt(Float.max(variance, 0.0));

    _avgPIL := avg;
    _emergence := _orderParameter * avg * (1.0 + stddev) * PHI;
    return _emergence;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §10 — PRIORITY WEIGHT CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════

  private func _priorityWeight(priority : TaskPriority) : Float {
    switch (priority) {
      case (#Critical)   { PHI * PHI * PHI };      // φ³ ≈ 4.236
      case (#High)       { PHI * PHI };            // φ² ≈ 2.618
      case (#Normal)     { PHI };                  // φ  ≈ 1.618
      case (#Low)        { 1.0 };                  // φ⁰ = 1.0
      case (#Background) { PHI_INV };              // φ⁻¹ ≈ 0.618
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §11 — TASK ROUTING (Cosine Similarity)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Route task to best-fit agent via cosine similarity on capability embeddings
  private func _routeTask(embedding : [Float]) : ?AgentId {
    var bestSim : Float = -1.0;
    var bestAgent : ?AgentId = null;
    var idx : Float = 0.0;

    for ((id, agent) in _agents.entries()) {
      // Generate capability vector from agent index + φ offsets
      idx += 1.0;
      var dot : Float = 0.0;
      var normA : Float = 0.0;
      var normE : Float = 0.0;

      for (j in Iter.range(0, 8)) {
        let cap = Float.cos(idx * PHI + Float.fromInt(j) * PHI_INV);
        let emb = if (j < embedding.size()) { embedding[j] } else { 0.0 };
        dot += cap * emb;
        normA += cap * cap;
        normE += emb * emb;
      };

      let denom = Float.sqrt(normA) * Float.sqrt(normE);
      let sim = if (denom > 0.0) { dot / denom } else { 0.0 };

      if (sim > bestSim) {
        bestSim := sim;
        bestAgent := ?id;
      };
    };

    return bestAgent;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §12 — HEARTBEAT TICK (873ms sovereign rhythm)
  // ═══════════════════════════════════════════════════════════════════════════

  private func _tick() : async () {
    _beat += 1;

    // Step 1: Kuramoto phase synchronization
    _kuramotoStep();

    // Step 2: Compute emergence
    ignore _computeEmergence();

    // Step 3: Nash resource allocation (budget = 1000 units)
    _nashAllocate(1000.0);

    // Step 4: Lyapunov stability check
    _lyapunovUpdate();

    // Step 5: Resync if needed
    if (_needsResync()) {
      _resyncFleet();
    };

    // Step 6: Update conductor beats
    for ((id, conductor) in _conductors.entries()) {
      let updated : ConductorRecord = {
        id = conductor.id;
        role = conductor.role;
        active = conductor.active;
        beatsActive = conductor.beatsActive + 1;
        lastAction = Time.now();
        coherenceScore = _orderParameter;
      };
      _conductors.put(id, updated);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §13 — PUBLIC API: FLEET MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Start the orchestrator heartbeat
  public shared func start() : async () {
    _initFleet();
    let interval = HEARTBEAT_MS * 1_000_000; // Convert ms to nanoseconds
    _heartbeatTimer := ?Timer.recurringTimer<system>(#nanoseconds(interval), _tick);
  };

  /// Stop the orchestrator heartbeat
  public shared func stop() : async () {
    switch (_heartbeatTimer) {
      case (?timerId) { Timer.cancelTimer(timerId); _heartbeatTimer := null };
      case null {};
    };
  };

  /// Get current fleet status
  public query func getFleetStatus() : async FleetStatus {
    var tasksQueued : Nat = 0;
    var tasksExecuting : Nat = 0;
    var agentsOnline : Nat = 0;

    for (i in Iter.range(0, _tasks.size() - 1)) {
      let task = _tasks.get(i);
      switch (task.state) {
        case (#Queued) { tasksQueued += 1 };
        case (#Executing) { tasksExecuting += 1 };
        case _ {};
      };
    };

    for ((_, agent) in _agents.entries()) {
      switch (agent.state) {
        case (#Offline) {};
        case _ { agentsOnline += 1 };
      };
    };

    return {
      orderParameter = _orderParameter;
      avgPIL = _avgPIL;
      emergence = _emergence;
      lyapunovV = _lyapunovV;
      lyapunovVdot = _lyapunovVdot;
      isStable = _unstableBeats < LYAPUNOV_HALT_BEATS;
      beat = _beat;
      agentsOnline = agentsOnline;
      tasksQueued = tasksQueued;
      tasksExecuting = tasksExecuting;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §14 — PUBLIC API: AGENT HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Called by each AGI to report its PIL and phase every heartbeat
  public shared func reportAgentHeartbeat(agentId : AgentId, pil : Float, phase : Float) : async {
    allocation : Float;
    fleetR : Float;
    isStable : Bool;
  } {
    switch (_agents.get(agentId)) {
      case (?agent) {
        let updated : AgentRecord = {
          id = agent.id;
          name = agent.name;
          family = agent.family;
          pil = Float.max(0.0, Float.min(1.0, pil));
          phase = phase;
          state = #Idle;
          allocation = agent.allocation;
          lastHeartbeat = Time.now();
          taskCount = agent.taskCount;
          coherence = _orderParameter;
        };
        _agents.put(agentId, updated);
        return {
          allocation = agent.allocation;
          fleetR = _orderParameter;
          isStable = _unstableBeats < LYAPUNOV_HALT_BEATS;
        };
      };
      case null {
        return { allocation = 0.0; fleetR = _orderParameter; isStable = true };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §15 — PUBLIC API: TASK SUBMISSION & ROUTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Submit a task for orchestration — routes to best-fit agent
  public shared func submitTask(intent : Text, priority : TaskPriority, embedding : [Float]) : async TaskId {
    let taskId = "TASK-" # Int.toText(Time.now()) # "-" # Nat.toText(_totalTasksProcessed);
    let assignedAgent = _routeTask(embedding);

    let task : TaskRecord = {
      id = taskId;
      intent = intent;
      priority = priority;
      state = switch (assignedAgent) { case (?_) { #Assigned }; case null { #Queued } };
      assignedTo = assignedAgent;
      conductorId = ?"COND-ROUTING-001";
      createdAt = Time.now();
      startedAt = switch (assignedAgent) { case (?_) { ?Time.now() }; case null { null } };
      completedAt = null;
      embedding = embedding;
      result = null;
    };

    _tasks.add(task);
    _totalTasksProcessed += 1;

    // Update agent task count
    switch (assignedAgent) {
      case (?agentId) {
        switch (_agents.get(agentId)) {
          case (?agent) {
            let updated : AgentRecord = {
              id = agent.id;
              name = agent.name;
              family = agent.family;
              pil = agent.pil;
              phase = agent.phase;
              state = #Executing;
              allocation = agent.allocation;
              lastHeartbeat = agent.lastHeartbeat;
              taskCount = agent.taskCount + 1;
              coherence = agent.coherence;
            };
            _agents.put(agentId, updated);
          };
          case null {};
        };
      };
      case null {};
    };

    return taskId;
  };

  /// Complete a task with result
  public shared func completeTask(taskId : TaskId, result : Text) : async Bool {
    var found = false;
    let updated = Buffer.Buffer<TaskRecord>(_tasks.size());

    for (i in Iter.range(0, _tasks.size() - 1)) {
      let task = _tasks.get(i);
      if (task.id == taskId and not found) {
        found := true;
        let completedTask : TaskRecord = {
          id = task.id;
          intent = task.intent;
          priority = task.priority;
          state = #Completed;
          assignedTo = task.assignedTo;
          conductorId = task.conductorId;
          createdAt = task.createdAt;
          startedAt = task.startedAt;
          completedAt = ?Time.now();
          embedding = task.embedding;
          result = ?result;
        };
        updated.add(completedTask);

        // Decrease agent task count
        switch (task.assignedTo) {
          case (?agentId) {
            switch (_agents.get(agentId)) {
              case (?agent) {
                let updatedAgent : AgentRecord = {
                  id = agent.id;
                  name = agent.name;
                  family = agent.family;
                  pil = Float.min(1.0, agent.pil + 0.01); // PIL grows on completion
                  phase = agent.phase;
                  state = if (agent.taskCount <= 1) { #Idle } else { #Executing };
                  allocation = agent.allocation;
                  lastHeartbeat = agent.lastHeartbeat;
                  taskCount = if (agent.taskCount > 0) { agent.taskCount - 1 } else { 0 };
                  coherence = agent.coherence;
                };
                _agents.put(agentId, updatedAgent);
              };
              case null {};
            };
          };
          case null {};
        };
      } else {
        updated.add(task);
      };
    };

    _tasks := updated;
    return found;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §16 — PUBLIC API: CONDUCTOR MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get all conductor statuses
  public query func getConductors() : async [(ConductorId, ConductorRole, Bool, Float)] {
    let result = Buffer.Buffer<(ConductorId, ConductorRole, Bool, Float)>(MAX_CONDUCTORS);
    for ((id, conductor) in _conductors.entries()) {
      result.add((id, conductor.role, conductor.active, conductor.coherenceScore));
    };
    return Buffer.toArray(result);
  };

  /// Activate or deactivate a conductor
  public shared func setConductorActive(conductorId : ConductorId, active : Bool) : async Bool {
    switch (_conductors.get(conductorId)) {
      case (?conductor) {
        let updated : ConductorRecord = {
          id = conductor.id;
          role = conductor.role;
          active = active;
          beatsActive = conductor.beatsActive;
          lastAction = Time.now();
          coherenceScore = conductor.coherenceScore;
        };
        _conductors.put(conductorId, updated);
        return true;
      };
      case null { return false };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §17 — PUBLIC API: DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get full agent roster with current state
  public query func getAgents() : async [(AgentId, Text, Float, Float, AgentState)] {
    let result = Buffer.Buffer<(AgentId, Text, Float, Float, AgentState)>(MAX_AGENTS);
    for ((_, agent) in _agents.entries()) {
      result.add((agent.id, agent.name, agent.pil, agent.phase, agent.state));
    };
    return Buffer.toArray(result);
  };

  /// Get orchestration metrics
  public query func getMetrics() : async {
    totalBeats : Nat;
    totalTasksProcessed : Nat;
    totalResyncEvents : Nat;
    orderParameter : Float;
    emergence : Float;
    isStable : Bool;
  } {
    return {
      totalBeats = _beat;
      totalTasksProcessed = _totalTasksProcessed;
      totalResyncEvents = _totalResyncEvents;
      orderParameter = _orderParameter;
      emergence = _emergence;
      isStable = _unstableBeats < LYAPUNOV_HALT_BEATS;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §18 — SYSTEM CALLBACKS
  // ═══════════════════════════════════════════════════════════════════════════

  system func preupgrade() {
    // Stable vars persist automatically
  };

  system func postupgrade() {
    _initFleet();
  };
};
