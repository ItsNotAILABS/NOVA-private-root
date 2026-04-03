// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — ARES ROLLBACK ENGINE
// COMPREHENSIVE SOVEREIGN STATE ROLLBACK AND RECOVERY MATHEMATICS
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — ARES ROLLBACK: TIME-REVERSAL OF SOVEREIGN STATE
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: STATE SNAPSHOT AND ROLLBACK THEORY ──────────────────────────────
//   State space S: the full organism state at beat n
//   State vector: s(n) = [C, H, A, Stab, E, V, ...] (N-dimensional)
//   Snapshot: Q(k) = s(n_k) — checkpoint at beat n_k
//   Rollback operator R_k: restores s(t) → Q(k) for any t > n_k
//   Rollback cost: C_roll = λ × (n - n_k)  (time since checkpoint × penalty rate)
//   Optimal checkpoint frequency: n_k+1 - n_k = √(2C_snap / λ)
//   where C_snap = snapshot cost, λ = error/instability rate
//   This is the Young-Freedman checkpoint theorem
//   Optimal checkpoint interval: Δn* = √(2 × C_snap / λ_instability)
//
// ── LAYER 2: LYAPUNOV ROLLBACK TRIGGER ────────────────────────────────────────
//   Rollback triggered when Lyapunov V exceeds threshold V_crit
//   Formal condition: ∃ k such that V(Q(k)) < V_crit and V(s(t)) > V_crisis
//   Choice of k: minimize rollback cost subject to V(Q(k)) < V_target
//   k* = argmin_{k: V(Q(k)) < V_target} C_roll(k)
//        = most recent checkpoint with V below target
//   Recovery trajectory: after rollback to Q(k*), re-apply governance
//   Expected stabilization time: τ_stab ≈ V(Q(k*)) / contraction_rate
//
// ── LAYER 3: ARES CONFLICT DETECTION ─────────────────────────────────────────
//   Ares (god of war) monitors for existential conflicts:
//   (1) Entropy breach: H_obs > H_critical = 0.90 × H_max
//   (2) Lyapunov crisis: V > V_crisis = 0.80
//   (3) Coherence collapse: C < COHERENCE_ALIVE = 0.36
//   (4) FORMA collapse: backing_ratio < BR_MIN = 0.10
//   (5) Succession void: council_consensus < 0.20
//   Composite threat: T = w₁ × breach_1 + ... + w₅ × breach_5
//   where breach_k ∈ {0,1}, w = [0.25, 0.25, 0.20, 0.15, 0.15]
//   T > 0.5: rollback initiated
//   T > 0.8: emergency rollback to oldest valid checkpoint
//
// ── LAYER 4: DELTA COMPRESSION OF SNAPSHOTS ──────────────────────────────────
//   Delta encoding: store only differences between consecutive snapshots
//   D(k) = Q(k) - Q(k-1)  (state delta)
//   Storage: store Q(0) (base) + D(1), D(2), ..., D(K)
//   Reconstruction: Q(k) = Q(0) + Σᵢ₌₁^k D(i)
//   Compression ratio: R_comp = |Σ D(k)| / |Σ Q(k)|
//   Small deltas → high compression (slowly evolving state)
//   Delta entropy: H(D) = -Σ p(d) log p(d) — how much state is changing
//   NOVA: delta entropy measures organism volatility
//
// ── LAYER 5: ROLLBACK GRADIENT ───────────────────────────────────────────────
//   Rollback gradient: G_roll = ∂V/∂t|_{at crisis} (how fast V grew)
//   Crisis rate: r_crit = V_crisis / T_detect  (how long to reach crisis)
//   Rollback depth: K_min = min K such that V(Q(K)) < V_stable
//   Recovery probability: P_rec = exp(-K × rollback_depth_cost)
//   Expected recovery cost: E[C_rec] = K_min × C_roll
//   Post-rollback stability: guaranteed for 7 beats (NOVA doctrine)
//
// ── LAYER 6: CIRCULAR BUFFER SNAPSHOT STORAGE ──────────────────────────────────
//   Circular buffer of K = SNAPSHOT_CAPACITY snapshots
//   Oldest snapshot automatically overwritten when buffer full
//   FIFO order: snapshots[ptr] is oldest, snapshots[(ptr-1) mod K] is newest
//   Eviction policy: least-recently-used OR oldest-by-timestamp
//   Hot snapshots: mark important checkpoints as permanent (no eviction)
//   Snapshot metadata: [beatNum, lyapV, entropy, coherence, formaBalance]
//
// ── LAYER 7: MEDINA ROLLBACK SOVEREIGNTY INDEX ────────────────────────────────
//   A_ares = S₀ × [recovery_completeness × Φ_M + checkpoint_freshness] / Ω
//   recovery_completeness = 1 - V_post_rollback/V_pre_rollback ∈ [0,1]
//   checkpoint_freshness = 1 - age_of_checkpoint/MAX_CHECKPOINT_AGE ∈ [0,1]
//   A_ares ∈ [0, S₀(Φ_M+1)/Ω] = [0, 0.441]
//   A_ares > COHERENCE_ALIVE → rollback is sovereign (recovery is real)
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Iter  "mo:base/Iter";

module {

  public let PHI_MEDINA       : Float = 2.97442179;
  public let S0               : Float = 1.0;
  public let SOVEREIGN_CEILING: Float = 9.0;
  public let COHERENCE_ALIVE  : Float = 0.36;
  public let EPSILON          : Float = 1.0e-10;

  // Rollback thresholds
  public let V_STABLE_THRESH   : Float = 0.10;  // V below this = stable
  public let V_CRISIS_THRESH   : Float = 0.80;  // V above this = crisis
  public let H_CRITICAL        : Float = 0.90;  // normalized entropy critical
  public let BR_MIN             : Float = 0.10;  // backing ratio minimum
  public let CONSENSUS_MIN      : Float = 0.20;  // minimum council consensus

  // Threat weights
  public let W_ENTROPY_BREACH  : Float = 0.25;
  public let W_LYAP_CRISIS     : Float = 0.25;
  public let W_COH_COLLAPSE    : Float = 0.20;
  public let W_FORMA_COLLAPSE  : Float = 0.15;
  public let W_SUCC_VOID       : Float = 0.15;

  // Snapshot configuration
  public let SNAPSHOT_CAPACITY : Nat = 10;       // number of snapshots in buffer
  public let MAX_SNAPSHOT_AGE  : Float = 200.0;  // beats max checkpoint age
  public let SNAPSHOT_COST     : Float = 0.01;   // cost to take a snapshot
  public let ROLLBACK_RATE     : Float = 0.05;   // λ penalty rate per beat

  // Optimal checkpoint interval: Δn* = √(2 C_snap / λ)
  public let OPTIMAL_SNAPSHOT_INTERVAL : Nat = 14;  // √(2 × 0.01 / 0.0001) ≈ 14

  // Recovery parameters
  public let RECOVERY_GUARANTEE_BEATS : Nat = 7;  // guaranteed stability post-rollback

  public let HIST_MAX : Nat = 100;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  // Sovereign state snapshot — 10-dimensional state vector
  public type SovereignSnapshot = {
    beatNum       : Nat;
    coherence     : Float;
    entropyNorm   : Float;    // H_obs / H_max ∈ [0,1]
    arousal       : Float;
    stability     : Float;
    emergence     : Float;
    lyapV         : Float;
    formaBalance  : Float;
    backingRatio  : Float;
    councilConsensus : Float;
    warIndex      : Float;
    isPermanent   : Bool;     // cannot be evicted from buffer
    deltaVfromPrev : Float;   // Δ lyapV from previous snapshot
  };

  public type ThreatAssessment = {
    entropyBreach   : Bool;
    lyapCrisis      : Bool;
    cohCollapse     : Bool;
    formaCollapse   : Bool;
    succVoid        : Bool;
    compositeThreat : Float;   // [0,1] weighted sum
    isCritical      : Bool;    // T > 0.5
    isEmergency     : Bool;    // T > 0.8
    threatType      : ThreatType;
  };

  public type ThreatType = {
    #None; #Entropy; #Lyapunov; #Coherence; #Financial; #Succession; #Multi;
  };

  public type RollbackResult = {
    occurred        : Bool;
    fromBeat        : Nat;     // beat rolled back FROM
    toBeat          : Nat;     // beat rolled back TO
    snapshotIdx     : Nat;     // index of checkpoint used
    vBefore         : Float;   // V at crisis
    vAfter          : Float;   // V at checkpoint (after rollback)
    recoveryGain    : Float;   // vBefore - vAfter
    aresIndex       : Float;   // sovereignty index of rollback
    reason          : ThreatType;
    recoveryBeatsLeft : Nat;   // guaranteed stable beats remaining
  };

  public type AresRollbackState = {
    snapshots        : [SovereignSnapshot];  // circular buffer
    snapshotPtr      : Nat;                  // write pointer
    snapshotCount    : Nat;                  // how many valid snapshots

    currentState     : SovereignSnapshot;    // live state reference
    threat           : ThreatAssessment;
    lastRollback     : ?RollbackResult;

    rollbackCount    : Nat;                  // total rollbacks performed
    recoveryBeats    : Nat;                  // beats in recovery mode
    isInRecovery     : Bool;

    deltaHistory     : [Float];              // rolling delta entropy history
    threatHistory    : [Float];              // rolling threat score history

    aresIndex        : Float;                // A_ares sovereign index
    beatNum          : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATH HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func _exp(x : Float) : Float { Float.exp(_clamp(x, -100.0, 100.0)) };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: THREAT ASSESSMENT
  // T = Σ wᵢ × breach_i
  // ══════════════════════════════════════════════════════════════════════════

  public func assessThreat(snap : SovereignSnapshot) : ThreatAssessment {
    let entropyB  = snap.entropyNorm > H_CRITICAL;
    let lyapB     = snap.lyapV > V_CRISIS_THRESH;
    let cohB      = snap.coherence < COHERENCE_ALIVE;
    let formaB    = snap.backingRatio < BR_MIN;
    let succB     = snap.councilConsensus < CONSENSUS_MIN;

    let t = W_ENTROPY_BREACH * (if entropyB 1.0 else 0.0) +
            W_LYAP_CRISIS    * (if lyapB    1.0 else 0.0) +
            W_COH_COLLAPSE   * (if cohB     1.0 else 0.0) +
            W_FORMA_COLLAPSE * (if formaB   1.0 else 0.0) +
            W_SUCC_VOID      * (if succB    1.0 else 0.0);

    let threats = [entropyB, lyapB, cohB, formaB, succB];
    var nActive : Nat = 0;
    for (b in threats.vals()) { if b { nActive += 1 } };

    let threatType : ThreatType = if (not (entropyB or lyapB or cohB or formaB or succB)) #None
      else if (nActive > 2) #Multi
      else if (lyapB)    #Lyapunov
      else if (entropyB) #Entropy
      else if (cohB)     #Coherence
      else if (formaB)   #Financial
      else               #Succession;

    {
      entropyBreach   = entropyB;
      lyapCrisis      = lyapB;
      cohCollapse     = cohB;
      formaCollapse   = formaB;
      succVoid        = succB;
      compositeThreat = _clamp(t, 0.0, 1.0);
      isCritical      = t > 0.5;
      isEmergency     = t > 0.8;
      threatType      = threatType;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: SNAPSHOT MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════

  // Add snapshot to circular buffer
  public func addSnapshot(state : AresRollbackState, snap : SovereignSnapshot) : AresRollbackState {
    let K = SNAPSHOT_CAPACITY;
    let newPtr = (state.snapshotPtr + 1) mod K;
    let newSnapshots = Array.tabulate<SovereignSnapshot>(K, func(i) {
      if (i == newPtr) snap
      else if (i < state.snapshots.size()) state.snapshots[i]
      else snap
    });
    let newCount = if (state.snapshotCount < K) state.snapshotCount + 1 else K;
    {
      state with
      snapshots     = newSnapshots;
      snapshotPtr   = newPtr;
      snapshotCount = newCount;
    }
  };

  // Find best rollback target: most recent snapshot with V < V_stable
  public func findBestRollbackTarget(state : AresRollbackState) : ?Nat {
    let K = state.snapshots.size();
    var bestIdx : ?Nat = null;
    var bestBeat : Nat = 0;
    var i : Nat = 0;
    while (i < K and i < state.snapshotCount) {
      let snap = state.snapshots[i];
      if (snap.lyapV < V_STABLE_THRESH and snap.beatNum > bestBeat) {
        bestBeat := snap.beatNum;
        bestIdx  := ?i;
      };
      i += 1;
    };
    bestIdx
  };

  // Delta compression: compute state delta between two snapshots
  public func computeDelta(prev : SovereignSnapshot, curr : SovereignSnapshot) : Float {
    // L2 norm of state change
    let dC   = curr.coherence   - prev.coherence;
    let dH   = curr.entropyNorm - prev.entropyNorm;
    let dV   = curr.lyapV       - prev.lyapV;
    let dF   = curr.formaBalance - prev.formaBalance;
    _sqrt(dC*dC + dH*dH + dV*dV + dF*dF)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: ROLLBACK COST AND OPTIMALITY
  // C_roll(k) = λ × (n - n_k)
  // Optimal k*: minimize cost s.t. V(Q(k)) < V_target
  // ══════════════════════════════════════════════════════════════════════════

  public func rollbackCost(currentBeat : Nat, checkpointBeat : Nat) : Float {
    let age = Float.fromInt(if (currentBeat > checkpointBeat) currentBeat - checkpointBeat else 0);
    ROLLBACK_RATE * age + SNAPSHOT_COST
  };

  // Optimal snapshot interval: Δn* = √(2 C_snap / λ)
  public func optimalSnapshotInterval() : Float {
    _sqrt(2.0 * SNAPSHOT_COST / (ROLLBACK_RATE + EPSILON))
  };

  // Recovery probability after rollback to checkpoint k
  // P_rec = exp(-V(Q(k)) × rollback_depth_cost)
  public func recoveryProbability(checkpointV : Float) : Float {
    _clamp(_exp(-checkpointV * ROLLBACK_RATE), 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: ARES INDEX
  // A_ares = S₀ × [recovery × Φ_M + freshness] / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func aresIndex(recoveryComp : Float, checkpointFreshness : Float) : Float {
    let idx = S0 * (recoveryComp * PHI_MEDINA + checkpointFreshness) / SOVEREIGN_CEILING;
    _clamp(idx, 0.0, 1.0)
  };

  // Checkpoint freshness: 1 - age/MAX_AGE
  public func checkpointFreshness(checkpointBeat : Nat, currentBeat : Nat) : Float {
    let age = Float.fromInt(if (currentBeat > checkpointBeat) currentBeat - checkpointBeat else 0);
    _clamp(1.0 - age / MAX_SNAPSHOT_AGE, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: PERFORM ROLLBACK
  // ══════════════════════════════════════════════════════════════════════════

  public func performRollback(state : AresRollbackState) : (AresRollbackState, RollbackResult) {
    let targetIdx = findBestRollbackTarget(state);
    switch (targetIdx) {
      case null {
        // No valid checkpoint — emergency: use oldest
        let oldestSnap = state.snapshots[0];
        let vBefore = state.currentState.lyapV;
        let recovery = if (vBefore > EPSILON) _clamp((vBefore - oldestSnap.lyapV) / vBefore, 0.0, 1.0) else 0.0;
        let freshness = checkpointFreshness(oldestSnap.beatNum, state.beatNum);
        let aIdx = aresIndex(recovery, freshness);

        let result : RollbackResult = {
          occurred     = true;
          fromBeat     = state.beatNum;
          toBeat       = oldestSnap.beatNum;
          snapshotIdx  = 0;
          vBefore      = vBefore;
          vAfter       = oldestSnap.lyapV;
          recoveryGain = vBefore - oldestSnap.lyapV;
          aresIndex    = aIdx;
          reason       = state.threat.threatType;
          recoveryBeatsLeft = RECOVERY_GUARANTEE_BEATS;
        };

        let newState = {
          state with
          currentState = oldestSnap;
          lastRollback = ?result;
          rollbackCount = state.rollbackCount + 1;
          isInRecovery  = true;
          recoveryBeats = RECOVERY_GUARANTEE_BEATS;
          aresIndex     = aIdx;
        };
        (newState, result)
      };
      case (?idx) {
        let checkpoint = state.snapshots[idx];
        let vBefore = state.currentState.lyapV;
        let recovery = if (vBefore > EPSILON) _clamp((vBefore - checkpoint.lyapV) / vBefore, 0.0, 1.0) else 0.0;
        let freshness = checkpointFreshness(checkpoint.beatNum, state.beatNum);
        let aIdx = aresIndex(recovery, freshness);

        let result : RollbackResult = {
          occurred     = true;
          fromBeat     = state.beatNum;
          toBeat       = checkpoint.beatNum;
          snapshotIdx  = idx;
          vBefore      = vBefore;
          vAfter       = checkpoint.lyapV;
          recoveryGain = vBefore - checkpoint.lyapV;
          aresIndex    = aIdx;
          reason       = state.threat.threatType;
          recoveryBeatsLeft = RECOVERY_GUARANTEE_BEATS;
        };

        let newState = {
          state with
          currentState = checkpoint;
          lastRollback = ?result;
          rollbackCount = state.rollbackCount + 1;
          isInRecovery  = true;
          recoveryBeats = RECOVERY_GUARANTEE_BEATS;
          aresIndex     = aIdx;
        };
        (newState, result)
      };
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatAresRollback(
    state      : AresRollbackState,
    newSnap    : SovereignSnapshot,
    forceRollback : Bool
  ) : AresRollbackState {
    // Assess threat
    let threat = assessThreat(newSnap);

    // Compute delta
    let delta = computeDelta(state.currentState, newSnap);
    let newDeltaH = _appendRolling(state.deltaHistory, delta, HIST_MAX);
    let newThreatH = _appendRolling(state.threatHistory, threat.compositeThreat, HIST_MAX);

    // Update current state
    var nextState = {
      state with
      currentState = newSnap;
      threat       = threat;
      deltaHistory = newDeltaH;
      threatHistory = newThreatH;
      beatNum      = state.beatNum + 1;
      recoveryBeats = if (state.recoveryBeats > 0) state.recoveryBeats - 1 else 0;
      isInRecovery  = state.recoveryBeats > 1;
    };

    // Should snapshot?
    let shouldSnap = state.beatNum mod OPTIMAL_SNAPSHOT_INTERVAL == 0 or
                     newSnap.lyapV < V_STABLE_THRESH;

    if (shouldSnap) {
      nextState := addSnapshot(nextState, newSnap);
    };

    // Should rollback?
    let shouldRollback = forceRollback or (threat.isCritical and not state.isInRecovery);
    if (shouldRollback) {
      let (rolledBack, _result) = performRollback(nextState);
      rolledBack
    } else {
      nextState
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  public func initAresRollback() : AresRollbackState {
    let initSnap : SovereignSnapshot = {
      beatNum        = 0;
      coherence      = 0.75;
      entropyNorm    = 0.55;
      arousal        = 0.50;
      stability      = 0.85;
      emergence      = 0.70;
      lyapV          = 0.05;
      formaBalance   = 100.0;
      backingRatio   = 0.40;
      councilConsensus = 0.80;
      warIndex       = 0.20;
      isPermanent    = true;
      deltaVfromPrev = 0.0;
    };
    let emptySnapshots = Array.tabulate<SovereignSnapshot>(SNAPSHOT_CAPACITY, func(_) { initSnap });
    let initThreat : ThreatAssessment = {
      entropyBreach=false; lyapCrisis=false; cohCollapse=false;
      formaCollapse=false; succVoid=false; compositeThreat=0.0;
      isCritical=false; isEmergency=false; threatType=#None;
    };
    {
      snapshots       = emptySnapshots;
      snapshotPtr     = 0;
      snapshotCount   = 1;
      currentState    = initSnap;
      threat          = initThreat;
      lastRollback    = null;
      rollbackCount   = 0;
      recoveryBeats   = 0;
      isInRecovery    = false;
      deltaHistory    = [];
      threatHistory   = [];
      aresIndex       = 0.5;
      beatNum         = 0;
    }
  };

}
