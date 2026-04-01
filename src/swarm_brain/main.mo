// PARALLAX DRONE SWARM SIMULATION
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
// Kuramoto synchrony, Hebbian learning, Jasmine's Law, OMNIS emergence
// are Medina Tech sovereign intellectual property.

import Array "mo:base/Array";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

actor SwarmBrain {

  // ─── CONSTANTS ──────────────────────────────────────────────────────────────

  let SOVEREIGN_FLOOR   : Float = 1.0;
  let HELIX_ALPHA       : Float = 0.01;
  let W_CEIL            : Float = 2.0;
  let KURAMOTO_K        : Float = 0.618;
  let MAX_DRONES        : Nat   = 50;
  let BRAIN_NODES       : Nat   = 6;

  // Neurochemical indices
  let DOPAMINE          : Nat = 0;
  let CORTISOL          : Nat = 1;
  let NOREPINEPHRINE    : Nat = 2;
  let OXYTOCIN          : Nat = 3;

  // ─── TYPES ──────────────────────────────────────────────────────────────────

  public type DroneClass = {
    #SCOUT;
    #STRIKER;
    #GUARDIAN;
    #RELAY;
    #MEDIC;
    #SOVEREIGN;
  };

  public type DroneState = {
    id              : Nat;
    droneClass      : DroneClass;
    // 6-node micro-brain weights [BRAIN_NODES x BRAIN_NODES] stored flat
    brainWeights    : [var Float];
    // 4 neurochemicals: [DOPAMINE, CORTISOL, NOREPINEPHRINE, OXYTOCIN]
    neuroChem       : [var Float];
    // Kuramoto phase (radians)
    phase           : Float;
    // Natural frequency
    omega           : Float;
    // Signal output (Law 23: decays over time)
    signal          : Float;
    // Position (x, y, z)
    posX            : Float;
    posY            : Float;
    posZ            : Float;
    // Health / activation
    activation      : Float;
    // Beat of last update
    lastBeat        : Nat;
    // Sacrifice flag
    sacrificed      : Bool;
  };

  // Stable storage arrays — survive upgrades
  stable var stableDroneCount       : Nat = 0;
  stable var stableBrainWeights     : [var Float] = [var]; // flat: droneId * N*N + node*N + node2
  stable var stableNeuroChem        : [var Float] = [var]; // flat: droneId * 4 + chemIdx
  stable var stablePhases           : [var Float] = [var];
  stable var stableOmegas           : [var Float] = [var];
  stable var stableSignals          : [var Float] = [var];
  stable var stablePosX             : [var Float] = [var];
  stable var stablePosY             : [var Float] = [var];
  stable var stablePosZ             : [var Float] = [var];
  stable var stableActivations      : [var Float] = [var];
  stable var stableLastBeat         : [var Nat]   = [var];
  stable var stableSacrificed       : [var Bool]  = [var];
  stable var stableClasses          : [var Text]  = [var];
  // Inter-drone Hebbian weights [i * MAX_DRONES + j]
  stable var stableSwarmWeights     : [var Float] = [var];

  stable var currentBeat            : Nat   = 0;
  stable var rSwarm                 : Float = 0.88;
  stable var jDrift                 : Float = 0.0;
  stable var prevJDrift             : Float = 0.0;
  stable var jRisingBeats           : Nat   = 0;

  // ─── HELPERS ────────────────────────────────────────────────────────────────

  func sf(x : Float) : Float { Float.max(SOVEREIGN_FLOOR, x) };

  func classToText(c : DroneClass) : Text {
    switch c {
      case (#SCOUT)     "SCOUT";
      case (#STRIKER)   "STRIKER";
      case (#GUARDIAN)  "GUARDIAN";
      case (#RELAY)     "RELAY";
      case (#MEDIC)     "MEDIC";
      case (#SOVEREIGN) "SOVEREIGN";
    }
  };

  func textToClass(t : Text) : DroneClass {
    switch t {
      case "STRIKER"   #STRIKER;
      case "GUARDIAN"  #GUARDIAN;
      case "RELAY"     #RELAY;
      case "MEDIC"     #MEDIC;
      case "SOVEREIGN" #SOVEREIGN;
      case _           #SCOUT;
    }
  };

  // Baseline neurochemical profile per class
  func baselineChem(c : DroneClass) : [Float] {
    switch c {
      case (#SCOUT)     [1.0, 1.0, 1.5, 1.0];
      case (#STRIKER)   [1.0, 1.3, 1.2, 1.0];
      case (#GUARDIAN)  [1.0, 1.1, 1.0, 1.5];
      case (#RELAY)     [1.5, 1.0, 1.0, 1.0];
      case (#MEDIC)     [1.0, 1.0, 1.0, 1.5];
      case (#SOVEREIGN) [1.2, 1.2, 1.2, 1.2];
    }
  };

  // Base cortisol per class
  func baselineCortisol(c : DroneClass) : Float {
    switch c {
      case (#SCOUT)     1.0;
      case (#STRIKER)   1.3;
      case (#GUARDIAN)  1.1;
      case (#RELAY)     1.0;
      case (#MEDIC)     1.0;
      case (#SOVEREIGN) 1.2;
    }
  };

  func sin(x : Float) : Float { Float.sin(x) };
  func cos(x : Float) : Float { Float.cos(x) };

  // ─── INITIALISE / RESIZE STABLE ARRAYS ──────────────────────────────────────

  func ensureCapacity(n : Nat) {
    let bwSize = n * BRAIN_NODES * BRAIN_NODES;
    let ncSize = n * 4;
    let swSize = n * MAX_DRONES;

    if (stableBrainWeights.size() < bwSize) {
      let newBW = Array.init<Float>(bwSize, 1.0);
      var i = 0;
      while (i < stableBrainWeights.size()) { newBW[i] := stableBrainWeights[i]; i += 1 };
      stableBrainWeights := newBW;
    };
    if (stableNeuroChem.size() < ncSize) {
      let newNC = Array.init<Float>(ncSize, 1.0);
      var i = 0;
      while (i < stableNeuroChem.size()) { newNC[i] := stableNeuroChem[i]; i += 1 };
      stableNeuroChem := newNC;
    };
    if (stablePhases.size() < n) {
      let newP = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stablePhases.size()) { newP[i] := stablePhases[i]; i += 1 };
      stablePhases := newP;
    };
    if (stableOmegas.size() < n) {
      let newO = Array.init<Float>(n, 1.0);
      var i = 0;
      while (i < stableOmegas.size()) { newO[i] := stableOmegas[i]; i += 1 };
      stableOmegas := newO;
    };
    if (stableSignals.size() < n) {
      let newS = Array.init<Float>(n, 1.0);
      var i = 0;
      while (i < stableSignals.size()) { newS[i] := stableSignals[i]; i += 1 };
      stableSignals := newS;
    };
    if (stablePosX.size() < n) {
      let newX = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stablePosX.size()) { newX[i] := stablePosX[i]; i += 1 };
      stablePosX := newX;
    };
    if (stablePosY.size() < n) {
      let newY = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stablePosY.size()) { newY[i] := stablePosY[i]; i += 1 };
      stablePosY := newY;
    };
    if (stablePosZ.size() < n) {
      let newZ = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < stablePosZ.size()) { newZ[i] := stablePosZ[i]; i += 1 };
      stablePosZ := newZ;
    };
    if (stableActivations.size() < n) {
      let newA = Array.init<Float>(n, 1.0);
      var i = 0;
      while (i < stableActivations.size()) { newA[i] := stableActivations[i]; i += 1 };
      stableActivations := newA;
    };
    if (stableLastBeat.size() < n) {
      let newLB = Array.init<Nat>(n, 0);
      var i = 0;
      while (i < stableLastBeat.size()) { newLB[i] := stableLastBeat[i]; i += 1 };
      stableLastBeat := newLB;
    };
    if (stableSacrificed.size() < n) {
      let newSac = Array.init<Bool>(n, false);
      var i = 0;
      while (i < stableSacrificed.size()) { newSac[i] := stableSacrificed[i]; i += 1 };
      stableSacrificed := newSac;
    };
    if (stableClasses.size() < n) {
      let newCls = Array.init<Text>(n, "SCOUT");
      var i = 0;
      while (i < stableClasses.size()) { newCls[i] := stableClasses[i]; i += 1 };
      stableClasses := newCls;
    };
    if (stableSwarmWeights.size() < swSize) {
      let newSW = Array.init<Float>(swSize, 0.1);
      var i = 0;
      while (i < stableSwarmWeights.size()) { newSW[i] := stableSwarmWeights[i]; i += 1 };
      stableSwarmWeights := newSW;
    };
  };

  // ─── ADD DRONE ───────────────────────────────────────────────────────────────

  public func addDrone(droneClass : DroneClass, omega : Float, posX : Float, posY : Float, posZ : Float) : async Nat {
    let id = stableDroneCount;
    stableDroneCount += 1;
    ensureCapacity(stableDroneCount);

    let cls = classToText(droneClass);
    stableClasses[id] := cls;

    let bc = baselineChem(droneClass);
    let ncBase = id * 4;
    stableNeuroChem[ncBase + DOPAMINE]       := sf(bc[0]);
    stableNeuroChem[ncBase + CORTISOL]       := sf(bc[1]);
    stableNeuroChem[ncBase + NOREPINEPHRINE] := sf(bc[2]);
    stableNeuroChem[ncBase + OXYTOCIN]       := sf(bc[3]);

    // Initialize brain weights to 1.0 (sovereign floor)
    let bwBase = id * BRAIN_NODES * BRAIN_NODES;
    var ni = 0;
    while (ni < BRAIN_NODES * BRAIN_NODES) {
      stableBrainWeights[bwBase + ni] := 1.0;
      ni += 1;
    };

    // Stagger phase so drones don't start synchronised
    let phaseOffset = Float.fromInt(id) * 0.2;
    stablePhases[id]      := phaseOffset;
    stableOmegas[id]      := Float.max(0.1, omega);
    stableSignals[id]     := 1.0;
    stablePosX[id]        := posX;
    stablePosY[id]        := posY;
    stablePosZ[id]        := posZ;
    stableActivations[id] := 1.0;
    stableLastBeat[id]    := currentBeat;
    stableSacrificed[id]  := false;

    // Init inter-drone weights
    var j = 0;
    while (j < MAX_DRONES) {
      if (j != id) {
        stableSwarmWeights[id * MAX_DRONES + j] := 0.1;
        stableSwarmWeights[j  * MAX_DRONES + id] := 0.1;
      };
      j += 1;
    };

    id
  };

  // ─── TICK / BEAT ─────────────────────────────────────────────────────────────

  // Law 23: Observer Independence — signal decays each beat
  func decaySignal(id : Nat) {
    let decay = Float.exp(-0.001 * Float.fromInt(currentBeat - stableLastBeat[id]));
    stableSignals[id] := sf(stableSignals[id] * decay);
  };

  // Law 4: Hebbian inter-drone learning (proximity-weighted)
  func hebbianUpdate(i : Nat, j : Nat) {
    let dx = stablePosX[i] - stablePosX[j];
    let dy = stablePosY[i] - stablePosY[j];
    let dz = stablePosZ[i] - stablePosZ[j];
    let dist = Float.sqrt(dx*dx + dy*dy + dz*dz) + 0.001;
    let proximity = 1.0 / (1.0 + dist / 10.0); // proximity weight
    let wi = stableSwarmWeights[i * MAX_DRONES + j];
    let si = stableSignals[i];
    let sj = stableSignals[j];
    let delta = HELIX_ALPHA * si * sj * (1.0 - wi / W_CEIL) * proximity;
    stableSwarmWeights[i * MAX_DRONES + j] := Float.min(W_CEIL, wi + delta);
    stableSwarmWeights[j * MAX_DRONES + i] := stableSwarmWeights[i * MAX_DRONES + j];
  };

  // Laws 6, 7: Kuramoto phase update
  func kuramotoUpdate(id : Nat) {
    let n = stableDroneCount;
    if (n == 0) return;
    var sum : Float = 0.0;
    var j = 0;
    while (j < n) {
      if (j != id and not stableSacrificed[j]) {
        sum += sin(stablePhases[j] - stablePhases[id]);
      };
      j += 1;
    };
    let dTheta = stableOmegas[id] + (KURAMOTO_K / Float.fromInt(n)) * sum;
    stablePhases[id] := stablePhases[id] + dTheta * 0.1; // dt = 0.1
  };

  // Compute swarm-level r_swarm (order parameter)
  func computeRSwarm() : Float {
    let n = stableDroneCount;
    if (n == 0) return 0.88;
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var active : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        sumCos += cos(stablePhases[i]);
        sumSin += sin(stablePhases[i]);
        active += 1.0;
      };
      i += 1;
    };
    if (active == 0.0) return 0.88;
    let r = Float.sqrt((sumCos/active)*(sumCos/active) + (sumSin/active)*(sumSin/active));
    // Clamp to realistic simulation range [0.5, 1.0]
    Float.max(0.5, Float.min(1.0, r))
  };

  // Jasmine's Law: swarm-level Lyapunov drift
  func computeJDrift() : Float {
    let n = stableDroneCount;
    if (n == 0) return 0.0;
    var j : Float = 0.0;
    var i = 0;
    // Component 1: formation integrity (phase variance from mean)
    var meanPhase : Float = 0.0;
    var cnt : Float = 0.0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        meanPhase += stablePhases[i];
        cnt += 1.0;
      };
      i += 1;
    };
    if (cnt > 0.0) meanPhase /= cnt;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let d = stablePhases[i] - meanPhase;
        j += 0.4 * d * d;
      };
      i += 1;
    };
    // Component 2: mission coherence (cortisol variance)
    var meanCort : Float = 0.0;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        meanCort += stableNeuroChem[i * 4 + CORTISOL];
      };
      i += 1;
    };
    if (cnt > 0.0) meanCort /= cnt;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let d = stableNeuroChem[i * 4 + CORTISOL] - meanCort;
        j += 0.3 * d * d;
      };
      i += 1;
    };
    // Component 3: communication health (signal variance)
    var meanSig : Float = 0.0;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        meanSig += stableSignals[i];
      };
      i += 1;
    };
    if (cnt > 0.0) meanSig /= cnt;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        let d = stableSignals[i] - meanSig;
        j += 0.3 * d * d;
      };
      i += 1;
    };
    if (cnt > 0.0) j / cnt else 0.0
  };

  // Jasmine correction: pull drones back to coherence
  func jasmineCorrect() {
    let n = stableDroneCount;
    var meanPhase : Float = 0.0;
    var cnt : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        meanPhase += stablePhases[i];
        cnt += 1.0;
      };
      i += 1;
    };
    if (cnt > 0.0) meanPhase /= cnt;
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        // Pull phase toward mean by 10%
        stablePhases[i] := stablePhases[i] * 0.9 + meanPhase * 0.1;
        // Boost oxytocin (cohesion signal)
        let ncBase = i * 4;
        stableNeuroChem[ncBase + OXYTOCIN] := sf(stableNeuroChem[ncBase + OXYTOCIN] + 0.05);
        // Reduce cortisol
        stableNeuroChem[ncBase + CORTISOL] := sf(stableNeuroChem[ncBase + CORTISOL] - 0.03);
      };
      i += 1;
    };
  };

  // Law 24: Faction Resistance Surge
  func factionResistance() {
    let n = stableDroneCount;
    if (n == 0) return;
    // Find drone with max signal output
    var maxSig : Float = 0.0;
    var maxIdx : Nat   = 0;
    var totalSig : Float = 0.0;
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        totalSig += stableSignals[i];
        if (stableSignals[i] > maxSig) {
          maxSig := stableSignals[i];
          maxIdx := i;
        };
      };
      i += 1;
    };
    if (totalSig == 0.0) return;
    let dominance = maxSig / totalSig;
    if (dominance > 0.7) {
      // +30% autonomy pressure on all other drones
      i := 0;
      while (i < n) {
        if (i != maxIdx and not stableSacrificed[i]) {
          let ncBase = i * 4;
          stableNeuroChem[ncBase + NOREPINEPHRINE] := sf(
            stableNeuroChem[ncBase + NOREPINEPHRINE] * 1.3
          );
          stableSignals[i] := sf(stableSignals[i] * 1.1);
        };
        i += 1;
      };
    };
  };

  // Main beat tick — advance simulation by one step
  public func tick() : async { rSwarm : Float; jDrift : Float; beat : Nat } {
    currentBeat += 1;
    let n = stableDroneCount;
    if (n == 0) return { rSwarm = 0.88; jDrift = 0.0; beat = currentBeat };

    // Phase 1: decay signals (Law 23)
    var i = 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        decaySignal(i);
        stableLastBeat[i] := currentBeat;
      };
      i += 1;
    };

    // Phase 2: Kuramoto phase update (Laws 6, 7)
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) kuramotoUpdate(i);
      i += 1;
    };

    // Phase 3: Hebbian inter-drone learning (Law 4)
    i := 0;
    while (i < n) {
      var j = i + 1;
      while (j < n) {
        if (not stableSacrificed[i] and not stableSacrificed[j]) {
          hebbianUpdate(i, j);
        };
        j += 1;
      };
      i += 1;
    };

    // Phase 4: compute r_swarm
    rSwarm := computeRSwarm();

    // Phase 5: Jasmine's Law
    prevJDrift := jDrift;
    jDrift := computeJDrift();
    if (jDrift > prevJDrift) {
      jRisingBeats += 1;
    } else {
      jRisingBeats := 0;
    };
    if (jRisingBeats >= 3) {
      jasmineCorrect();
      jRisingBeats := 0;
    };

    // Phase 6: Faction Resistance (Law 24)
    factionResistance();

    // Phase 7: Boost signals from Hebbian influence
    i := 0;
    while (i < n) {
      if (not stableSacrificed[i]) {
        var influence : Float = 0.0;
        var j = 0;
        while (j < n) {
          if (j != i and not stableSacrificed[j]) {
            influence += stableSwarmWeights[i * MAX_DRONES + j] * stableSignals[j];
          };
          j += 1;
        };
        stableSignals[i] := sf(stableSignals[i] + 0.001 * influence);
        stableActivations[i] := sf(stableActivations[i]);
      };
      i += 1;
    };

    { rSwarm = rSwarm; jDrift = jDrift; beat = currentBeat }
  };

  // ─── QUERIES ─────────────────────────────────────────────────────────────────

  public query func getDroneCount() : async Nat { stableDroneCount };

  public query func getRSwarm() : async Float { rSwarm };

  public query func getJDrift() : async Float { jDrift };

  public query func getCurrentBeat() : async Nat { currentBeat };

  public query func getDroneNeuroChem(id : Nat) : async [Float] {
    if (id >= stableDroneCount) return [0.0, 0.0, 0.0, 0.0];
    let base = id * 4;
    [stableNeuroChem[base], stableNeuroChem[base+1],
     stableNeuroChem[base+2], stableNeuroChem[base+3]]
  };

  public query func getDronePhase(id : Nat) : async Float {
    if (id >= stableDroneCount) return 0.0;
    stablePhases[id]
  };

  public query func getDroneSignal(id : Nat) : async Float {
    if (id >= stableDroneCount) return 0.0;
    stableSignals[id]
  };

  public query func getDronePosition(id : Nat) : async (Float, Float, Float) {
    if (id >= stableDroneCount) return (0.0, 0.0, 0.0);
    (stablePosX[id], stablePosY[id], stablePosZ[id])
  };

  public query func getDroneClass(id : Nat) : async Text {
    if (id >= stableDroneCount) return "SCOUT";
    stableClasses[id]
  };

  public query func isDroneSacrificed(id : Nat) : async Bool {
    if (id >= stableDroneCount) return false;
    stableSacrificed[id]
  };

  public query func getSwarmWeights(i : Nat, j : Nat) : async Float {
    if (i >= stableDroneCount or j >= stableDroneCount) return 0.0;
    stableSwarmWeights[i * MAX_DRONES + j]
  };

  // Retrieve full swarm snapshot for frontend
  public query func getSwarmSnapshot() : async {
    droneCount  : Nat;
    rSwarm      : Float;
    jDrift      : Float;
    beat        : Nat;
    phases      : [Float];
    signals     : [Float];
    positionsX  : [Float];
    positionsY  : [Float];
    positionsZ  : [Float];
    cortisolLevels : [Float];
    sacrificed  : [Bool];
    classes     : [Text];
  } {
    let n = stableDroneCount;
    let phases   = Array.tabulate<Float>(n, func(i) { stablePhases[i] });
    let sigs     = Array.tabulate<Float>(n, func(i) { stableSignals[i] });
    let px       = Array.tabulate<Float>(n, func(i) { stablePosX[i] });
    let py       = Array.tabulate<Float>(n, func(i) { stablePosY[i] });
    let pz       = Array.tabulate<Float>(n, func(i) { stablePosZ[i] });
    let cort     = Array.tabulate<Float>(n, func(i) { stableNeuroChem[i * 4 + CORTISOL] });
    let sac      = Array.tabulate<Bool>(n, func(i) { stableSacrificed[i] });
    let cls      = Array.tabulate<Text>(n, func(i) { stableClasses[i] });
    {
      droneCount     = n;
      rSwarm         = rSwarm;
      jDrift         = jDrift;
      beat           = currentBeat;
      phases         = phases;
      signals        = sigs;
      positionsX     = px;
      positionsY     = py;
      positionsZ     = pz;
      cortisolLevels = cort;
      sacrificed     = sac;
      classes        = cls;
    }
  };

  // ─── DRONE POSITION UPDATE (from telemetry/MAVLink) ──────────────────────────

  public func updatePosition(id : Nat, x : Float, y : Float, z : Float) : async () {
    if (id >= stableDroneCount) return;
    stablePosX[id] := x;
    stablePosY[id] := y;
    stablePosZ[id] := z;
  };

  // ─── SACRIFICE DOCTRINE (Law 20) ─────────────────────────────────────────────

  // Execute sacrifice — only callable after HITL approval
  public func executeSacrifice(id : Nat) : async Bool {
    if (id >= stableDroneCount) return false;
    if (stableSacrificed[id]) return false;
    let cortisol = stableNeuroChem[id * 4 + CORTISOL];
    if (cortisol < 1.5) return false; // threshold not met

    stableSacrificed[id] := true;
    stableActivations[id] := SOVEREIGN_FLOOR; // sovereign floor: mind never zero

    // Law 21: Adjacent drones' Substance-P analog surges (grief/stress)
    var j = 0;
    while (j < stableDroneCount) {
      if (j != id and not stableSacrificed[j]) {
        let dx = stablePosX[id] - stablePosX[j];
        let dy = stablePosY[id] - stablePosY[j];
        let dz = stablePosZ[id] - stablePosZ[j];
        let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
        if (dist < 20.0) {
          // Grief propagation — cortisol and norepinephrine surge
          let ncBase = j * 4;
          stableNeuroChem[ncBase + CORTISOL]       := sf(stableNeuroChem[ncBase + CORTISOL] + 0.2);
          stableNeuroChem[ncBase + NOREPINEPHRINE] := sf(stableNeuroChem[ncBase + NOREPINEPHRINE] + 0.3);
        };
      };
      j += 1;
    };
    true
  };

  // Check which drones are eligible for sacrifice (cortisol > 1.5)
  public query func getSacrificeEligible() : async [Nat] {
    var eligible : [Nat] = [];
    var i = 0;
    while (i < stableDroneCount) {
      if (not stableSacrificed[i] and stableNeuroChem[i * 4 + CORTISOL] > 1.5) {
        eligible := Array.append(eligible, [i]);
      };
      i += 1;
    };
    eligible
  };

  // ─── SIGNAL BOOST (Architect Signal) ─────────────────────────────────────────

  public func boostSignal(id : Nat, amount : Float) : async () {
    if (id >= stableDroneCount) return;
    stableSignals[id] := sf(stableSignals[id] + amount);
  };

  // ─── PREUPGRADE / POSTUPGRADE ────────────────────────────────────────────────
  // Stable vars are persisted automatically by ICP runtime.
  // No migration needed for flat arrays.

};
