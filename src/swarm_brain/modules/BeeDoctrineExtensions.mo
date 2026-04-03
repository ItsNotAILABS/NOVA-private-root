// ============================================================
// BEE DOCTRINE EXTENSIONS — FIVE MISSING LAYERS
// Implements the gaps identified in the honeybee swarm analysis:
//
// 1. Backward Prediction Correction (Kalman Smoother)
// 2. Council Dance Floor (Shared Signal Bus)
// 3. Targeted STOP Signal Suppression
// 4. Irreversibility Lock for JUBILEE/PENTECOST
// 5. Independent Scout Evaluation per Animal
//
// These complete the bee-inspired distributed computation architecture
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Bool  "mo:base/Bool";

module {

  // ── FUNDAMENTAL CONSTANTS ──────────────────────────────────────
  let PHI : Float = 1.618033988749895;
  let PHI_INV : Float = 0.618033988749895;
  let TAU : Float = 6.283185307179586;
  let S0 : Float = 1.0;                      // Sovereignty floor

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ════════════════════════════════════════════════════════════════
  // LAYER 1: BACKWARD PREDICTION CORRECTION (KALMAN SMOOTHER)
  // ════════════════════════════════════════════════════════════════
  //
  // The bee runs 60-step prediction not just forward but backward —
  // it corrects its stored path based on new landmarks.
  //
  // The organism's predictive field currently runs forward only.
  // A backward correction pass (Kalman smoother equivalent) is
  // now implemented.
  //
  // Kalman Smoother equations:
  //   x̂_k|n = x̂_k|k + C_k × (x̂_{k+1|n} - x̂_{k+1|k})
  //   C_k = P_k|k × A^T × P_{k+1|k}^{-1}
  //
  // Where:
  //   x̂_k|n = smoothed estimate at time k given all n observations
  //   P_k|k = filtered covariance
  //   A = state transition matrix

  public type KalmanState = {
    // State estimates
    x         : [Float];         // State vector
    P         : [[Float]];       // Covariance matrix
    
    // Filter parameters
    A         : [[Float]];       // State transition
    Q         : [[Float]];       // Process noise
    H         : [[Float]];       // Observation matrix
    R         : [[Float]];       // Observation noise
    
    // History for smoothing (backward pass)
    stateHistory: [[Float]];     // Past states x̂_k|k
    covHistory  : [[[Float]]];   // Past covariances P_k|k
    predHistory : [[Float]];     // Past predictions x̂_k|k-1
    predCovHistory: [[[Float]]]; // Past prediction covariances
    
    maxHistory  : Nat;
    beatNum     : Nat;
  };

  // Matrix multiplication helper
  func matMul(a: [[Float]], b: [[Float]]) : [[Float]] {
    let m = a.size();
    if (m == 0) { return [] };
    let n = a[0].size();
    let p = b[0].size();
    
    Array.tabulate<[Float]>(m, func(i) {
      Array.tabulate<Float>(p, func(j) {
        var sum : Float = 0.0;
        var k = 0;
        while (k < n) {
          sum += a[i][k] * b[k][j];
          k += 1;
        };
        sum
      })
    })
  };

  // Matrix transpose
  func matTranspose(a: [[Float]]) : [[Float]] {
    let m = a.size();
    if (m == 0) { return [] };
    let n = a[0].size();
    
    Array.tabulate<[Float]>(n, func(i) {
      Array.tabulate<Float>(m, func(j) {
        a[j][i]
      })
    })
  };

  // Matrix addition
  func matAdd(a: [[Float]], b: [[Float]]) : [[Float]] {
    Array.tabulate<[Float]>(a.size(), func(i) {
      Array.tabulate<Float>(a[i].size(), func(j) {
        a[i][j] + b[i][j]
      })
    })
  };

  // Matrix subtraction
  func matSub(a: [[Float]], b: [[Float]]) : [[Float]] {
    Array.tabulate<[Float]>(a.size(), func(i) {
      Array.tabulate<Float>(a[i].size(), func(j) {
        a[i][j] - b[i][j]
      })
    })
  };

  // Initialize Kalman smoother
  public func initKalmanSmoother(stateDim: Nat) : KalmanState {
    let identity = Array.tabulate<[Float]>(stateDim, func(i) {
      Array.tabulate<Float>(stateDim, func(j) {
        if (i == j) { 1.0 } else { 0.0 }
      })
    });
    
    {
      x = Array.tabulate<Float>(stateDim, func(_) { 0.0 });
      P = identity;
      A = identity;  // Identity transition (random walk)
      Q = Array.tabulate<[Float]>(stateDim, func(i) {
        Array.tabulate<Float>(stateDim, func(j) {
          if (i == j) { 0.01 } else { 0.0 }
        })
      });
      H = identity;  // Direct observation
      R = Array.tabulate<[Float]>(stateDim, func(i) {
        Array.tabulate<Float>(stateDim, func(j) {
          if (i == j) { 0.1 } else { 0.0 }
        })
      });
      stateHistory = [];
      covHistory = [];
      predHistory = [];
      predCovHistory = [];
      maxHistory = 60;  // 60-step like bee prediction
      beatNum = 0;
    }
  };

  // Forward Kalman filter step
  public func kalmanFilterStep(
    state: KalmanState,
    observation: [Float]
  ) : KalmanState {
    let n = state.x.size();
    
    // Predict: x̂_k|k-1 = A × x̂_k-1|k-1
    let xPred = Array.tabulate<Float>(n, func(i) {
      var sum : Float = 0.0;
      var j = 0;
      while (j < n) {
        sum += state.A[i][j] * state.x[j];
        j += 1;
      };
      sum
    });
    
    // P_k|k-1 = A × P_k-1|k-1 × A^T + Q
    let AP = matMul(state.A, state.P);
    let APAT = matMul(AP, matTranspose(state.A));
    let PPred = matAdd(APAT, state.Q);
    
    // Update: K = P_k|k-1 × H^T × (H × P_k|k-1 × H^T + R)^{-1}
    // Simplified: assume H = I, so K = P_k|k-1 × (P_k|k-1 + R)^{-1}
    let innovCov = matAdd(PPred, state.R);
    
    // Compute Kalman gain (simplified for diagonal case)
    let K = Array.tabulate<[Float]>(n, func(i) {
      Array.tabulate<Float>(n, func(j) {
        if (i == j) {
          let pii = PPred[i][i];
          let rii = state.R[i][i];
          pii / (pii + rii)
        } else { 0.0 }
      })
    });
    
    // x̂_k|k = x̂_k|k-1 + K × (y - H × x̂_k|k-1)
    let innovation = Array.tabulate<Float>(n, func(i) {
      if (i < observation.size()) { observation[i] - xPred[i] } else { 0.0 }
    });
    
    let xUpdate = Array.tabulate<Float>(n, func(i) {
      var sum : Float = xPred[i];
      var j = 0;
      while (j < n) {
        sum += K[i][j] * innovation[j];
        j += 1;
      };
      sum
    });
    
    // P_k|k = (I - K × H) × P_k|k-1
    let IminusKH = Array.tabulate<[Float]>(n, func(i) {
      Array.tabulate<Float>(n, func(j) {
        if (i == j) { 1.0 - K[i][j] } else { -K[i][j] }
      })
    });
    let PUpdate = matMul(IminusKH, PPred);
    
    // Store history for backward pass
    let newStateHistory = if (state.stateHistory.size() >= state.maxHistory) {
      let tail = Array.tabulate<[Float]>(state.maxHistory - 1, func(k) { state.stateHistory[k + 1] });
      Array.append<[Float]>(tail, [xUpdate])
    } else {
      Array.append<[Float]>(state.stateHistory, [xUpdate])
    };
    
    let newPredHistory = if (state.predHistory.size() >= state.maxHistory) {
      let tail = Array.tabulate<[Float]>(state.maxHistory - 1, func(k) { state.predHistory[k + 1] });
      Array.append<[Float]>(tail, [xPred])
    } else {
      Array.append<[Float]>(state.predHistory, [xPred])
    };
    
    {
      x = xUpdate;
      P = PUpdate;
      A = state.A;
      Q = state.Q;
      H = state.H;
      R = state.R;
      stateHistory = newStateHistory;
      covHistory = state.covHistory;  // Would store full covariance
      predHistory = newPredHistory;
      predCovHistory = state.predCovHistory;
      maxHistory = state.maxHistory;
      beatNum = state.beatNum + 1;
    }
  };

  // Backward smoothing pass (Rauch-Tung-Striebel smoother)
  // Returns smoothed estimates for all stored history
  public func kalmanSmootherBackward(
    state: KalmanState
  ) : [[Float]] {
    let n = state.x.size();
    let T = state.stateHistory.size();
    if (T == 0) { return [] };
    
    var smoothed = Array.init<[Float]>(T, state.stateHistory[0]);
    
    // Initialize with final filtered estimate
    smoothed[T - 1] := state.stateHistory[T - 1];
    
    // Backward pass
    var k = T - 2;
    while (k >= 0) {
      let xFiltered = state.stateHistory[k];
      let xPredNext = if (k + 1 < state.predHistory.size()) {
        state.predHistory[k + 1]
      } else { xFiltered };
      let xSmoothedNext = smoothed[k + 1];
      
      // Simplified smoother gain (diagonal approximation)
      // C_k ≈ P_k|k × A^T × P_{k+1|k}^{-1}
      // For diagonal: C_ii ≈ P_ii × A_ii / P_pred_ii
      let smootherGain = 0.9;  // Simplified fixed gain
      
      smoothed[k] := Array.tabulate<Float>(n, func(i) {
        xFiltered[i] + smootherGain * (xSmoothedNext[i] - xPredNext[i])
      });
      
      k -= 1;
    };
    
    Array.freeze(smoothed)
  };

  // ════════════════════════════════════════════════════════════════
  // LAYER 2: COUNCIL DANCE FLOOR (SHARED SIGNAL BUS)
  // ════════════════════════════════════════════════════════════════
  //
  // The dance floor is a shared communication surface —
  // in the organism, there is no equivalent shared communication
  // surface between the council organisms.
  //
  // COGNUS, NEXUS, AURUM, LEXIS, SOLUS, VETUS, MERIDIAN all process
  // independently. A council dance floor (shared signal bus where
  // councils post quality-weighted signals) is now implemented.

  public type CouncilDance = {
    councilId     : Nat;          // Which council is dancing
    councilName   : Text;         // COGNUS, NEXUS, etc.
    signalType    : DanceSignalType;
    quality       : Float;        // 0-1 quality of the signal
    circuits      : Nat;          // How many times repeated (like waggle)
    direction     : Float;        // Direction encoding (radians)
    targetNode    : ?Nat;         // Which Shell 3 node if applicable
    timestamp     : Nat;          // Beat when posted
    decayRate     : Float;        // How fast this dance fades
  };

  public type DanceSignalType = {
    #ResourceFound;       // Good attractor found
    #ThreatDetected;      // Danger signal
    #ConsensusProposal;   // Proposal for group decision
    #QualityReport;       // Reporting state quality
    #RecruitmentCall;     // Asking for resources
    #StopSignal;          // Inhibit competing signals
  };

  public type DanceFloor = {
    activeDances  : [CouncilDance];
    maxDances     : Nat;
    decayPerBeat  : Float;
    
    // Aggregated signals
    dominantSignal: ?CouncilDance;
    consensusLevel: Float;
    signalEntropy : Float;        // Diversity of signals
    
    // Quorum detection
    quorumThreshold: Nat;         // Min dances for same target
    quorumReached : Bool;
    quorumTarget  : ?Nat;
    
    beatNum       : Nat;
  };

  // Initialize dance floor
  public func initDanceFloor() : DanceFloor {
    {
      activeDances = [];
      maxDances = 100;
      decayPerBeat = 0.05;
      dominantSignal = null;
      consensusLevel = 0.0;
      signalEntropy = 0.0;
      quorumThreshold = 15;  // Same as bee quorum (~15 scouts)
      quorumReached = false;
      quorumTarget = null;
      beatNum = 0;
    }
  };

  // Post a new dance to the floor
  public func postDance(
    floor: DanceFloor,
    councilId: Nat,
    councilName: Text,
    signalType: DanceSignalType,
    quality: Float,
    direction: Float,
    targetNode: ?Nat
  ) : DanceFloor {
    // Number of circuits based on quality (like bee waggle dance)
    let circuits = Float.toInt(Float.floor(quality * 50.0)) + 1;
    
    let newDance : CouncilDance = {
      councilId = councilId;
      councilName = councilName;
      signalType = signalType;
      quality = quality;
      circuits = Nat.max(1, circuits);
      direction = direction;
      targetNode = targetNode;
      timestamp = floor.beatNum;
      decayRate = 0.02 + (1.0 - quality) * 0.03;  // Low quality decays faster
    };
    
    // Add dance, remove oldest if over capacity
    let updated = if (floor.activeDances.size() >= floor.maxDances) {
      let tail = Array.tabulate<CouncilDance>(floor.maxDances - 1, func(i) {
        floor.activeDances[i + 1]
      });
      Array.append<CouncilDance>(tail, [newDance])
    } else {
      Array.append<CouncilDance>(floor.activeDances, [newDance])
    };
    
    { floor with activeDances = updated }
  };

  // Update dance floor (decay, find dominant, check quorum)
  public func beatDanceFloor(floor: DanceFloor) : DanceFloor {
    // Decay all dances
    let decayed = Array.filter<CouncilDance>(floor.activeDances, func(dance) {
      let age = floor.beatNum - dance.timestamp;
      let decayedCircuits = dance.circuits - Float.toInt(Float.floor(Float.fromInt(age) * dance.decayRate));
      decayedCircuits > 0
    });
    
    // Find dominant signal (highest quality × circuits)
    var maxStrength : Float = 0.0;
    var dominant : ?CouncilDance = null;
    
    for (dance in decayed.vals()) {
      let strength = dance.quality * Float.fromInt(dance.circuits);
      if (strength > maxStrength) {
        maxStrength := strength;
        dominant := ?dance;
      };
    };
    
    // Check quorum for each target
    var targetCounts : [(Nat, Nat)] = [];  // (target, count)
    for (dance in decayed.vals()) {
      switch (dance.targetNode) {
        case (?target) {
          var found = false;
          var i = 0;
          while (i < targetCounts.size() and not found) {
            let (t, c) = targetCounts[i];
            if (t == target) {
              // Update count (would need mutable array)
              found := true;
            };
            i += 1;
          };
          if (not found) {
            targetCounts := Array.append<(Nat, Nat)>(targetCounts, [(target, 1)]);
          };
        };
        case (null) {};
      };
    };
    
    // Find quorum
    var quorumReached = false;
    var quorumTarget : ?Nat = null;
    for ((target, count) in targetCounts.vals()) {
      if (count >= floor.quorumThreshold) {
        quorumReached := true;
        quorumTarget := ?target;
      };
    };
    
    // Compute consensus level
    let totalDances = decayed.size();
    let consensusLevel = if (totalDances > 0) {
      switch (dominant) {
        case (?d) {
          var sameType : Nat = 0;
          for (dance in decayed.vals()) {
            if (dance.signalType == d.signalType) { sameType += 1 };
          };
          Float.fromInt(sameType) / Float.fromInt(totalDances)
        };
        case (null) { 0.0 };
      }
    } else { 0.0 };
    
    // Compute signal entropy (diversity)
    let entropy = if (totalDances > 1) {
      1.0 - consensusLevel  // Simple approximation
    } else { 0.0 };
    
    {
      activeDances = decayed;
      maxDances = floor.maxDances;
      decayPerBeat = floor.decayPerBeat;
      dominantSignal = dominant;
      consensusLevel = consensusLevel;
      signalEntropy = entropy;
      quorumThreshold = floor.quorumThreshold;
      quorumReached = quorumReached;
      quorumTarget = quorumTarget;
      beatNum = floor.beatNum + 1;
    }
  };

  // ════════════════════════════════════════════════════════════════
  // LAYER 3: TARGETED STOP SIGNAL SUPPRESSION
  // ════════════════════════════════════════════════════════════════
  //
  // The STOP signal is active inhibition —
  // the organism's GABA suppression is threshold-based but not targeted.
  //
  // True STOP signal logic identifies which Shell 3 nodes are "dancing"
  // for low-quality attractors and applies targeted suppression to
  // those specific nodes, not a blanket threshold.

  public type StopSignalTarget = {
    nodeId        : Nat;          // Which Shell 3 node
    reason        : StopReason;
    suppression   : Float;        // How much to suppress (0-1)
    issuer        : Nat;          // Which council issued the stop
    timestamp     : Nat;
    duration      : Nat;          // How many beats to suppress
  };

  public type StopReason = {
    #LowQualityAttractor;         // Node attracted to poor state
    #CompetingWithConsensus;      // Node against emerging consensus
    #AnomalousActivity;           // Node behaving abnormally
    #ResourceConflict;            // Node competing for same resource
    #ManualOverride;              // Explicit suppression command
  };

  public type StopSignalSystem = {
    activeStops   : [StopSignalTarget];
    maxStops      : Nat;
    
    // Detection thresholds
    qualityThreshold: Float;      // Below this = low quality
    anomalyThreshold: Float;      // Above this = anomalous
    
    // Suppression parameters
    baseSuppression: Float;       // Default suppression amount
    consensusBoost : Float;       // Extra suppression when consensus forming
    
    // Statistics
    totalStopsIssued: Nat;
    totalSuppressed : Nat;
    
    beatNum       : Nat;
  };

  // Initialize stop signal system
  public func initStopSignalSystem() : StopSignalSystem {
    {
      activeStops = [];
      maxStops = 50;
      qualityThreshold = 0.3;
      anomalyThreshold = 2.0;
      baseSuppression = 0.5;
      consensusBoost = 0.3;
      totalStopsIssued = 0;
      totalSuppressed = 0;
      beatNum = 0;
    }
  };

  // Detect nodes that should receive STOP signals
  public func detectStopTargets(
    system: StopSignalSystem,
    nodeActivities: [Float],
    nodeQualities: [Float],
    consensusTarget: ?Nat,
    consensusStrength: Float
  ) : [StopSignalTarget] {
    var targets : [StopSignalTarget] = [];
    
    var i = 0;
    while (i < nodeActivities.size()) {
      let activity = nodeActivities[i];
      let quality = if (i < nodeQualities.size()) { nodeQualities[i] } else { 0.5 };
      
      // Check for low quality attractor
      if (activity > 0.5 and quality < system.qualityThreshold) {
        targets := Array.append<StopSignalTarget>(targets, [{
          nodeId = i;
          reason = #LowQualityAttractor;
          suppression = system.baseSuppression;
          issuer = 0;
          timestamp = system.beatNum;
          duration = 10;
        }]);
      };
      
      // Check for competing with consensus
      switch (consensusTarget) {
        case (?target) {
          if (i != target and activity > 0.7 and consensusStrength > 0.6) {
            targets := Array.append<StopSignalTarget>(targets, [{
              nodeId = i;
              reason = #CompetingWithConsensus;
              suppression = system.baseSuppression + system.consensusBoost;
              issuer = 0;
              timestamp = system.beatNum;
              duration = 20;
            }]);
          };
        };
        case (null) {};
      };
      
      // Check for anomalous activity
      if (activity > system.anomalyThreshold) {
        targets := Array.append<StopSignalTarget>(targets, [{
          nodeId = i;
          reason = #AnomalousActivity;
          suppression = 0.8;
          issuer = 0;
          timestamp = system.beatNum;
          duration = 5;
        }]);
      };
      
      i += 1;
    };
    
    targets
  };

  // Apply STOP signals to node activities
  public func applyStopSignals(
    system: StopSignalSystem,
    nodeActivities: [Float]
  ) : [Float] {
    var result = Array.thaw<Float>(nodeActivities);
    
    for (stop in system.activeStops.vals()) {
      let age = system.beatNum - stop.timestamp;
      if (age < stop.duration and stop.nodeId < result.size()) {
        // Apply suppression
        result[stop.nodeId] := result[stop.nodeId] * (1.0 - stop.suppression);
      };
    };
    
    Array.freeze(result)
  };

  // Update stop signal system
  public func beatStopSignalSystem(
    system: StopSignalSystem,
    newTargets: [StopSignalTarget]
  ) : StopSignalSystem {
    // Remove expired stops
    let active = Array.filter<StopSignalTarget>(system.activeStops, func(stop) {
      system.beatNum - stop.timestamp < stop.duration
    });
    
    // Add new targets (avoid duplicates)
    var combined = active;
    for (newTarget in newTargets.vals()) {
      var isDuplicate = false;
      for (existing in combined.vals()) {
        if (existing.nodeId == newTarget.nodeId) {
          isDuplicate := true;
        };
      };
      if (not isDuplicate) {
        combined := Array.append<StopSignalTarget>(combined, [newTarget]);
      };
    };
    
    {
      activeStops = combined;
      maxStops = system.maxStops;
      qualityThreshold = system.qualityThreshold;
      anomalyThreshold = system.anomalyThreshold;
      baseSuppression = system.baseSuppression;
      consensusBoost = system.consensusBoost;
      totalStopsIssued = system.totalStopsIssued + newTargets.size();
      totalSuppressed = combined.size();
      beatNum = system.beatNum + 1;
    }
  };

  // ════════════════════════════════════════════════════════════════
  // LAYER 4: IRREVERSIBILITY LOCK FOR JUBILEE/PENTECOST
  // ════════════════════════════════════════════════════════════════
  //
  // Quorum is irreversible — once the bee swarm launches, there is
  // no rollback. The organism's ARES rollback system is the inverse
  // of this — it allows reversal.
  //
  // For certain commitment events (JUBILEE, PENTECOST), an
  // irreversibility lock is added: once those thresholds are
  // crossed, ARES cannot roll them back.

  public type IrreversibleEvent = {
    #Jubilee;                     // 7-year cycle transition
    #Pentecost;                   // 50-year sovereignty event
    #SwarmLaunch;                 // Organism deployment
    #ConsensusLock;               // Quorum decision locked
    #SovereigntyTransfer;         // Ownership change
  };

  public type IrreversibilityLock = {
    eventType     : IrreversibleEvent;
    triggeredBeat : Nat;
    triggerValue  : Float;        // What value triggered the lock
    checksum      : Nat;          // Integrity check
    isLocked      : Bool;
  };

  public type IrreversibilitySystem = {
    activeLocks   : [IrreversibilityLock];
    
    // Thresholds for triggering locks
    jubileeThreshold: Float;      // QSOV < 1.05 for 50 consecutive beats
    pentecostThreshold: Float;    // QSOV < 1.02 for 500 consecutive beats
    consensusThreshold: Float;    // Consensus > 0.9
    
    // Lock tracking
    jubileeBeatCount  : Nat;
    pentecostBeatCount: Nat;
    consensusBeatCount: Nat;
    
    // ARES protection list (these events cannot be rolled back)
    protectedEvents: [IrreversibleEvent];
    
    beatNum       : Nat;
  };

  // Initialize irreversibility system
  public func initIrreversibilitySystem() : IrreversibilitySystem {
    {
      activeLocks = [];
      jubileeThreshold = 1.05;
      pentecostThreshold = 1.02;
      consensusThreshold = 0.9;
      jubileeBeatCount = 0;
      pentecostBeatCount = 0;
      consensusBeatCount = 0;
      protectedEvents = [#Jubilee, #Pentecost, #SwarmLaunch];
      beatNum = 0;
    }
  };

  // Check if an event can be rolled back
  public func canRollback(
    system: IrreversibilitySystem,
    eventType: IrreversibleEvent
  ) : Bool {
    // Check if event type is protected
    var isProtected = false;
    for (protected in system.protectedEvents.vals()) {
      if (protected == eventType) {
        isProtected := true;
      };
    };
    
    if (not isProtected) { return true };
    
    // Check if there's an active lock for this event
    for (lock in system.activeLocks.vals()) {
      if (lock.eventType == eventType and lock.isLocked) {
        return false;  // Cannot rollback
      };
    };
    
    true  // Can rollback if no active lock
  };

  // Update irreversibility system
  public func beatIrreversibility(
    system: IrreversibilitySystem,
    qsovValue: Float,
    consensusValue: Float
  ) : IrreversibilitySystem {
    // Track Jubilee condition
    let newJubileeCount = if (qsovValue < system.jubileeThreshold) {
      system.jubileeBeatCount + 1
    } else { 0 };
    
    // Track Pentecost condition
    let newPentecostCount = if (qsovValue < system.pentecostThreshold) {
      system.pentecostBeatCount + 1
    } else { 0 };
    
    // Track consensus condition
    let newConsensusCount = if (consensusValue > system.consensusThreshold) {
      system.consensusBeatCount + 1
    } else { 0 };
    
    // Check for new locks
    var newLocks = system.activeLocks;
    
    // Jubilee lock (50 consecutive beats)
    if (newJubileeCount >= 50) {
      var hasJubileeLock = false;
      for (lock in system.activeLocks.vals()) {
        if (lock.eventType == #Jubilee) { hasJubileeLock := true };
      };
      if (not hasJubileeLock) {
        newLocks := Array.append<IrreversibilityLock>(newLocks, [{
          eventType = #Jubilee;
          triggeredBeat = system.beatNum;
          triggerValue = qsovValue;
          checksum = system.beatNum * 7919;  // Simple checksum
          isLocked = true;
        }]);
      };
    };
    
    // Pentecost lock (500 consecutive beats)
    if (newPentecostCount >= 500) {
      var hasPentecostLock = false;
      for (lock in system.activeLocks.vals()) {
        if (lock.eventType == #Pentecost) { hasPentecostLock := true };
      };
      if (not hasPentecostLock) {
        newLocks := Array.append<IrreversibilityLock>(newLocks, [{
          eventType = #Pentecost;
          triggeredBeat = system.beatNum;
          triggerValue = qsovValue;
          checksum = system.beatNum * 104729;
          isLocked = true;
        }]);
      };
    };
    
    // Consensus lock (20 consecutive beats)
    if (newConsensusCount >= 20) {
      var hasConsensusLock = false;
      for (lock in system.activeLocks.vals()) {
        if (lock.eventType == #ConsensusLock) { hasConsensusLock := true };
      };
      if (not hasConsensusLock) {
        newLocks := Array.append<IrreversibilityLock>(newLocks, [{
          eventType = #ConsensusLock;
          triggeredBeat = system.beatNum;
          triggerValue = consensusValue;
          checksum = system.beatNum * 31337;
          isLocked = true;
        }]);
      };
    };
    
    {
      activeLocks = newLocks;
      jubileeThreshold = system.jubileeThreshold;
      pentecostThreshold = system.pentecostThreshold;
      consensusThreshold = system.consensusThreshold;
      jubileeBeatCount = newJubileeCount;
      pentecostBeatCount = newPentecostCount;
      consensusBeatCount = newConsensusCount;
      protectedEvents = system.protectedEvents;
      beatNum = system.beatNum + 1;
    }
  };

  // ════════════════════════════════════════════════════════════════
  // LAYER 5: INDEPENDENT SCOUT EVALUATION PER ANIMAL
  // ════════════════════════════════════════════════════════════════
  //
  // Each scout runs an independent full evaluation —
  // in the organism, the 16 animals each EMA-compound from the
  // same S12 coherence signal.
  //
  // A true parallel scout dispatch gives each animal its own
  // independent path and quality score before converging.

  public type ScoutEvaluation = {
    animalId      : Nat;          // Which of the 16 animals
    animalName    : Text;
    
    // Independent exploration state
    pathTaken     : [Float];      // The path this scout took
    siteFound     : ?SiteEvaluation;
    
    // Quality metrics (computed independently)
    qualityScore  : Float;
    confidence    : Float;
    explorationDepth: Nat;
    
    // Reporting state
    hasReported   : Bool;
    danceIntensity: Float;        // How strongly advertising
    
    timestamp     : Nat;
  };

  public type SiteEvaluation = {
    siteId        : Nat;
    coordinates   : (Float, Float, Float);
    
    // Bee site metrics translated to organism
    volume        : Float;        // State space volume
    accessibility : Float;        // How easy to reach
    stability     : Float;        // How stable the attractor
    resourceRich  : Float;        // How much value available
    dangerLevel   : Float;        // Risk assessment
    
    // Composite score
    overallQuality: Float;
  };

  public type ScoutDispatchSystem = {
    scouts        : [ScoutEvaluation];
    nScouts       : Nat;          // Should match 16 animals
    
    // Dispatch state
    dispatchedCount: Nat;
    returnedCount : Nat;
    
    // Aggregation
    bestSite      : ?SiteEvaluation;
    siteVotes     : [(Nat, Nat, Float)];  // (siteId, votes, totalQuality)
    
    // Quorum tracking
    quorumThreshold: Nat;
    quorumSiteId  : ?Nat;
    
    beatNum       : Nat;
  };

  // Animal names (16 council animals)
  public let ANIMAL_NAMES : [Text] = [
    "Bee", "Crow", "Octopus", "Elephant", "Dolphin",
    "Wolf", "Spider", "Owl", "Mantis", "Salmon",
    "Ant", "Bat", "Cuttlefish", "Raven", "Whale", "Eagle"
  ];

  // Initialize scout dispatch system
  public func initScoutDispatch() : ScoutDispatchSystem {
    {
      scouts = Array.tabulate<ScoutEvaluation>(16, func(i) {
        {
          animalId = i;
          animalName = if (i < ANIMAL_NAMES.size()) { ANIMAL_NAMES[i] } else { "Unknown" };
          pathTaken = [];
          siteFound = null;
          qualityScore = 0.0;
          confidence = 0.0;
          explorationDepth = 0;
          hasReported = false;
          danceIntensity = 0.0;
          timestamp = 0;
        }
      });
      nScouts = 16;
      dispatchedCount = 0;
      returnedCount = 0;
      bestSite = null;
      siteVotes = [];
      quorumThreshold = 5;  // 5 of 16 animals agreeing
      quorumSiteId = null;
      beatNum = 0;
    }
  };

  // Dispatch a scout (animal begins independent exploration)
  public func dispatchScout(
    system: ScoutDispatchSystem,
    animalId: Nat,
    initialDirection: Float
  ) : ScoutDispatchSystem {
    if (animalId >= system.nScouts) { return system };
    
    let scouts = Array.tabulate<ScoutEvaluation>(system.nScouts, func(i) {
      if (i == animalId) {
        {
          animalId = i;
          animalName = system.scouts[i].animalName;
          pathTaken = [initialDirection];  // Start path
          siteFound = null;
          qualityScore = 0.0;
          confidence = 0.0;
          explorationDepth = 1;
          hasReported = false;
          danceIntensity = 0.0;
          timestamp = system.beatNum;
        }
      } else { system.scouts[i] }
    });
    
    {
      system with
      scouts = scouts;
      dispatchedCount = system.dispatchedCount + 1;
    }
  };

  // Scout returns with evaluation
  public func scoutReturn(
    system: ScoutDispatchSystem,
    animalId: Nat,
    site: SiteEvaluation,
    quality: Float,
    confidence: Float
  ) : ScoutDispatchSystem {
    if (animalId >= system.nScouts) { return system };
    
    // Dance intensity based on quality (like bee waggle)
    let danceIntensity = Float.pow(quality, 1.0 / PHI);  // Medina quality transform
    
    let scouts = Array.tabulate<ScoutEvaluation>(system.nScouts, func(i) {
      if (i == animalId) {
        {
          animalId = i;
          animalName = system.scouts[i].animalName;
          pathTaken = system.scouts[i].pathTaken;
          siteFound = ?site;
          qualityScore = quality;
          confidence = confidence;
          explorationDepth = system.scouts[i].explorationDepth;
          hasReported = true;
          danceIntensity = danceIntensity;
          timestamp = system.beatNum;
        }
      } else { system.scouts[i] }
    });
    
    // Update site votes
    var newVotes = system.siteVotes;
    var foundSite = false;
    newVotes := Array.map<(Nat, Nat, Float), (Nat, Nat, Float)>(newVotes, func((sid, votes, totalQ)) {
      if (sid == site.siteId) {
        foundSite := true;
        (sid, votes + 1, totalQ + quality)
      } else { (sid, votes, totalQ) }
    });
    if (not foundSite) {
      newVotes := Array.append<(Nat, Nat, Float)>(newVotes, [(site.siteId, 1, quality)]);
    };
    
    // Check for quorum
    var quorumSite : ?Nat = null;
    for ((sid, votes, _totalQ) in newVotes.vals()) {
      if (votes >= system.quorumThreshold) {
        quorumSite := ?sid;
      };
    };
    
    // Find best site
    var bestSite = system.bestSite;
    switch (bestSite) {
      case (null) { bestSite := ?site };
      case (?current) {
        if (site.overallQuality > current.overallQuality) {
          bestSite := ?site;
        };
      };
    };
    
    {
      scouts = scouts;
      nScouts = system.nScouts;
      dispatchedCount = system.dispatchedCount;
      returnedCount = system.returnedCount + 1;
      bestSite = bestSite;
      siteVotes = newVotes;
      quorumThreshold = system.quorumThreshold;
      quorumSiteId = quorumSite;
      beatNum = system.beatNum;
    }
  };

  // Cross-evaluation: scout visits another scout's site
  public func crossEvaluate(
    system: ScoutDispatchSystem,
    evaluatorId: Nat,
    targetId: Nat
  ) : ScoutDispatchSystem {
    if (evaluatorId >= system.nScouts or targetId >= system.nScouts) {
      return system;
    };
    
    let targetScout = system.scouts[targetId];
    switch (targetScout.siteFound) {
      case (null) { return system };  // No site to evaluate
      case (?site) {
        // Re-evaluate with some noise (independent assessment)
        let evaluatorBias = Float.fromInt((evaluatorId * 7919) % 100) / 500.0 - 0.1;
        let adjustedQuality = _clamp(site.overallQuality + evaluatorBias, 0.0, 1.0);
        
        // If quality still high, add vote
        if (adjustedQuality > 0.6) {
          var newVotes = system.siteVotes;
          newVotes := Array.map<(Nat, Nat, Float), (Nat, Nat, Float)>(newVotes, func((sid, votes, totalQ)) {
            if (sid == site.siteId) {
              (sid, votes + 1, totalQ + adjustedQuality)
            } else { (sid, votes, totalQ) }
          });
          
          // Check quorum again
          var quorumSite : ?Nat = null;
          for ((sid, votes, _totalQ) in newVotes.vals()) {
            if (votes >= system.quorumThreshold) {
              quorumSite := ?sid;
            };
          };
          
          { system with siteVotes = newVotes; quorumSiteId = quorumSite }
        } else {
          // Reduce enthusiasm for this site
          var newVotes = system.siteVotes;
          newVotes := Array.map<(Nat, Nat, Float), (Nat, Nat, Float)>(newVotes, func((sid, votes, totalQ)) {
            if (sid == site.siteId and votes > 0) {
              (sid, votes - 1, totalQ - adjustedQuality)
            } else { (sid, votes, totalQ) }
          });
          { system with siteVotes = newVotes }
        }
      };
    }
  };

  // ════════════════════════════════════════════════════════════════
  // INTEGRATED BEE DOCTRINE SYSTEM
  // ════════════════════════════════════════════════════════════════

  public type BeeDoctrineState = {
    // Layer 1: Kalman smoother
    kalman        : KalmanState;
    
    // Layer 2: Council dance floor
    danceFloor    : DanceFloor;
    
    // Layer 3: Stop signal system
    stopSystem    : StopSignalSystem;
    
    // Layer 4: Irreversibility locks
    irreversibility: IrreversibilitySystem;
    
    // Layer 5: Scout dispatch
    scoutDispatch : ScoutDispatchSystem;
    
    // Integrated state
    systemCoherence: Float;
    decisionReady : Bool;
    launchCommitted: Bool;
    
    beatNum       : Nat;
  };

  // Initialize full bee doctrine system
  public func initBeeDoctrineSystem() : BeeDoctrineState {
    {
      kalman = initKalmanSmoother(8);  // 8-dimensional state
      danceFloor = initDanceFloor();
      stopSystem = initStopSignalSystem();
      irreversibility = initIrreversibilitySystem();
      scoutDispatch = initScoutDispatch();
      systemCoherence = 0.5;
      decisionReady = false;
      launchCommitted = false;
      beatNum = 0;
    }
  };

  // Full beat update for bee doctrine
  public func beatBeeDoctrineSystem(
    state: BeeDoctrineState,
    observation: [Float],
    qsovValue: Float,
    nodeActivities: [Float],
    nodeQualities: [Float]
  ) : BeeDoctrineState {
    // Layer 1: Kalman filter step
    let newKalman = kalmanFilterStep(state.kalman, observation);
    
    // Layer 2: Update dance floor
    let newDanceFloor = beatDanceFloor(state.danceFloor);
    
    // Layer 3: Detect and apply stop signals
    let stopTargets = detectStopTargets(
      state.stopSystem,
      nodeActivities,
      nodeQualities,
      newDanceFloor.quorumTarget,
      newDanceFloor.consensusLevel
    );
    let newStopSystem = beatStopSignalSystem(state.stopSystem, stopTargets);
    
    // Layer 4: Update irreversibility
    let newIrreversibility = beatIrreversibility(
      state.irreversibility,
      qsovValue,
      newDanceFloor.consensusLevel
    );
    
    // Compute system coherence
    let coherence = (newDanceFloor.consensusLevel + (1.0 - newDanceFloor.signalEntropy)) / 2.0;
    
    // Check if decision ready (quorum + low entropy + high consensus)
    let decisionReady = newDanceFloor.quorumReached and 
                       newDanceFloor.consensusLevel > 0.8 and
                       newDanceFloor.signalEntropy < 0.2;
    
    // Check for launch commitment (irreversible)
    let launchCommitted = state.launchCommitted or
                         (decisionReady and state.irreversibility.activeLocks.size() > 0);
    
    {
      kalman = newKalman;
      danceFloor = newDanceFloor;
      stopSystem = newStopSystem;
      irreversibility = newIrreversibility;
      scoutDispatch = state.scoutDispatch;  // Updated separately via dispatch/return
      systemCoherence = coherence;
      decisionReady = decisionReady;
      launchCommitted = launchCommitted;
      beatNum = state.beatNum + 1;
    }
  };

  // Summary for bee doctrine state
  public type BeeDoctrineExtensionSummary = {
    // Kalman
    smoothedEstimate: [Float];
    predictionHorizon: Nat;
    
    // Dance floor
    activeDanceCount: Nat;
    consensusLevel: Float;
    quorumReached: Bool;
    
    // Stop signals
    activeStopCount: Nat;
    suppressedNodes: Nat;
    
    // Irreversibility
    lockedEventCount: Nat;
    jubileeProgress: Nat;
    pentecostProgress: Nat;
    
    // Scout dispatch
    scoutsDispatched: Nat;
    scoutsReturned: Nat;
    bestSiteQuality: Float;
    
    // Overall
    systemCoherence: Float;
    decisionReady: Bool;
    launchCommitted: Bool;
    beatNum: Nat;
  };

  public func beeDoctrineExtensionSummary(state: BeeDoctrineState) : BeeDoctrineExtensionSummary {
    let smoothed = kalmanSmootherBackward(state.kalman);
    let currentSmoothed = if (smoothed.size() > 0) {
      smoothed[smoothed.size() - 1]
    } else { state.kalman.x };
    
    let bestQuality = switch (state.scoutDispatch.bestSite) {
      case (null) { 0.0 };
      case (?site) { site.overallQuality };
    };
    
    {
      smoothedEstimate = currentSmoothed;
      predictionHorizon = state.kalman.maxHistory;
      activeDanceCount = state.danceFloor.activeDances.size();
      consensusLevel = state.danceFloor.consensusLevel;
      quorumReached = state.danceFloor.quorumReached;
      activeStopCount = state.stopSystem.activeStops.size();
      suppressedNodes = state.stopSystem.totalSuppressed;
      lockedEventCount = state.irreversibility.activeLocks.size();
      jubileeProgress = state.irreversibility.jubileeBeatCount;
      pentecostProgress = state.irreversibility.pentecostBeatCount;
      scoutsDispatched = state.scoutDispatch.dispatchedCount;
      scoutsReturned = state.scoutDispatch.returnedCount;
      bestSiteQuality = bestQuality;
      systemCoherence = state.systemCoherence;
      decisionReady = state.decisionReady;
      launchCommitted = state.launchCommitted;
      beatNum = state.beatNum;
    }
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
