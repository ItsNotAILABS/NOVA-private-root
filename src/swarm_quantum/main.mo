// PARALLAX DRONE SWARM SIMULATION — QUANTUM COGNITIVE LAYER
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
// Quantum models, Four-360 mind architecture, Recognition Memory,
// and Convergent Multi-Stream Thinking are Medina Tech sovereign IP.
//
// Architecture mirrors the sovereign mind:
//   • Four 360-degree cognitive channels (ALPHA/BETA/GAMMA/DELTA) process
//     all dimensions simultaneously — spatial, temporal, relational, executive.
//   • Every channel is a complete (360°) perspective; nothing is dropped.
//   • All four streams converge at a single critical focal point (the
//     convergenceScore) — multiple tasks, one conclusion.
//   • Memory is a RECOGNITION layer: it matches the present against the past
//     via cosine similarity, not merely chronological recall.
//   • Now-attention anchors each drone (and the swarm) to the present moment.
//   • Quantum entanglement couples drone-pairs so that their cognitive states
//     correlate — coordinated without centralised command.

import Array  "mo:base/Array";
import Float  "mo:base/Float";
import Int    "mo:base/Int";
import Nat    "mo:base/Nat";
import Text   "mo:base/Text";
import Time   "mo:base/Time";

actor SwarmQuantum {

  // ─── CONSTANTS ───────────────────────────────────────────────────────────────

  let SOVEREIGN_FLOOR : Float = 1.0;
  let MAX_DRONES      : Nat   = 50;
  // Four cognitive channels (ALPHA=0, BETA=1, GAMMA=2, DELTA=3)
  let QUAD_CHANNELS   : Nat   = 4;
  // Quantum superposition states (PATROL=0, ENGAGE=1, RETURN=2, CRITICAL=3)
  let Q_STATES        : Nat   = 4;
  // Recognition memory circular buffer capacity
  let REC_CAP         : Nat   = 500;
  // Now-attention pull rate (fraction of gap closed per beat)
  let NOW_DECAY       : Float = 0.05;
  // Entanglement correlation strength per beat
  let ENT_STRENGTH    : Float = 0.02;
  // Channel update time-constant (beats) — shared with swarm_brain.quantumStateUpdate
  let CHAN_TAU        : Float = 10.0;
  // jDrift sensitivity for temporal channel: how strongly drift suppresses BETA
  let JDRIFT_SENSITIVITY : Float = 2.0;
  // GAMMA channel blend: fraction from rSwarm vs. ALPHA feedback
  let GAMMA_RSWARM_WEIGHT : Float = 0.4;
  let GAMMA_ALPHA_WEIGHT  : Float = 0.6;
  // ODE integration step for amplitude dynamics
  let DT              : Float = 0.05;
  // Recognition memory half-life in beats (present-moment decay)
  let MEMORY_HALFLIFE_BEATS : Float = 50.0;
  // Similarity-vs-recency blend weights for recognition scoring
  let SIMILARITY_WEIGHT : Float = 0.7;
  let RECENCY_WEIGHT    : Float = 0.3;

  // ─── TYPES ───────────────────────────────────────────────────────────────────

  // One entry in the recognition memory
  public type RecognitionEntry = {
    seq              : Nat;
    beat             : Nat;
    timestamp        : Int;
    // Four-channel cognitive state when this memory was encoded
    alphaAmp         : Float;
    betaAmp          : Float;
    gammaAmp         : Float;
    deltaAmp         : Float;
    // Convergence score at encoding (how aligned the 4 channels were)
    convergenceScore : Float;
    // Swarm metrics at encoding
    rSwarm           : Float;
    jDrift           : Float;
    // Semantic label for this memory
    lbl            : Text;
    // Present-moment weight: decays as beats pass (recent = more salient)
    nowWeight        : Float;
  };

  // Quantum snapshot for a single drone
  public type DroneQuantumState = {
    droneId          : Nat;
    // Superposition probability amplitudes (normalised: Σ aᵢ² = 1)
    ampPatrol        : Float;
    ampEngage        : Float;
    ampReturn        : Float;
    ampCritical      : Float;
    // Dominant measured state (highest amplitude²)
    measuredState    : Text;
    // Four 360-degree cognitive channel amplitudes
    alphaChannel     : Float;  // spatial / sensing
    betaChannel      : Float;  // temporal / memory
    gammaChannel     : Float;  // relational / executive
    deltaChannel     : Float;  // emotional-motor / action
    // Convergence: 0=channels diverge, 1=all channels fully agree
    convergenceScore : Float;
    // Quantum coherence at drone level
    qCoherence       : Float;
    // Present-moment attention weight [0, 1]
    nowAttention     : Float;
    // Entanglement partner (equals droneId when unentangled)
    entangledWith    : Nat;
  };

  // Swarm-level quantum metrics returned by quantumTick
  public type QuantumSwarmMetrics = {
    beat                : Nat;
    swarmQCoherence     : Float;
    swarmConvergence    : Float;
    nowIndex            : Float;   // fraction of drones with nowAttention > 0.5
    entanglementDensity : Float;   // fraction of drones that are entangled
    dominantState       : Text;    // most common measured state across the swarm
  };

  // ─── STABLE STATE ────────────────────────────────────────────────────────────

  stable var qDroneCount      : Nat   = 0;
  stable var qBeat            : Nat   = 0;
  stable var swarmQCoherence  : Float = 0.0;
  stable var swarmConvergence : Float = 0.0;

  // Per-drone: quantum superposition amplitudes [id * Q_STATES + stateIdx]
  stable var qAmplitudes      : [var Float] = [var];
  // Per-drone: four cognitive channel values  [id * QUAD_CHANNELS + chanIdx]
  stable var qChannels        : [var Float] = [var];
  // Per-drone: convergence score
  stable var qConvergence     : [var Float] = [var];
  // Per-drone: quantum coherence
  stable var qCoh             : [var Float] = [var];
  // Per-drone: present-moment attention weight
  stable var qNowAttention    : [var Float] = [var];
  // Per-drone: entanglement partner id (self = unentangled)
  stable var qEntangledWith   : [var Nat]   = [var];

  // Recognition memory — stable parallel arrays
  stable var recSeq           : [var Nat]   = [var];
  stable var recBeat          : [var Nat]   = [var];
  stable var recTs            : [var Int]   = [var];
  stable var recAlpha         : [var Float] = [var];
  stable var recBeta          : [var Float] = [var];
  stable var recGamma         : [var Float] = [var];
  stable var recDelta         : [var Float] = [var];
  stable var recConv          : [var Float] = [var];
  stable var recRSwarm        : [var Float] = [var];
  stable var recJDrift        : [var Float] = [var];
  stable var recLabel         : [var Text]  = [var];
  stable var recNowWeight     : [var Float] = [var];
  stable var recNextIdx       : Nat = 0;
  stable var recTotal         : Nat = 0;

  // ─── HELPERS ─────────────────────────────────────────────────────────────────

  func growNat(old : [var Nat], cap : Nat, def : Nat) : [var Nat] {
    let a = Array.init<Nat>(cap, def);
    var i = 0; while (i < old.size() and i < cap) { a[i] := old[i]; i += 1 }; a
  };
  func growInt(old : [var Int], cap : Nat, def : Int) : [var Int] {
    let a = Array.init<Int>(cap, def);
    var i = 0; while (i < old.size() and i < cap) { a[i] := old[i]; i += 1 }; a
  };
  func growFloat(old : [var Float], cap : Nat, def : Float) : [var Float] {
    let a = Array.init<Float>(cap, def);
    var i = 0; while (i < old.size() and i < cap) { a[i] := old[i]; i += 1 }; a
  };
  func growText(old : [var Text], cap : Nat, def : Text) : [var Text] {
    let a = Array.init<Text>(cap, def);
    var i = 0; while (i < old.size() and i < cap) { a[i] := old[i]; i += 1 }; a
  };

  func ensureDroneCap(n : Nat) {
    let qsSize = n * Q_STATES;
    let qcSize = n * QUAD_CHANNELS;
    if (qAmplitudes.size() < qsSize) {
      // Equal-superposition initial state: all amplitudes = 0.5
      let a = Array.init<Float>(qsSize, 0.5);
      var i = 0;
      while (i < qAmplitudes.size()) { a[i] := qAmplitudes[i]; i += 1 };
      qAmplitudes := a;
    };
    if (qChannels.size() < qcSize) {
      let a = Array.init<Float>(qcSize, 0.5);
      var i = 0;
      while (i < qChannels.size()) { a[i] := qChannels[i]; i += 1 };
      qChannels := a;
    };
    if (qConvergence.size() < n) {
      let a = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < qConvergence.size()) { a[i] := qConvergence[i]; i += 1 };
      qConvergence := a;
    };
    if (qCoh.size() < n) {
      let a = Array.init<Float>(n, 0.5);
      var i = 0;
      while (i < qCoh.size()) { a[i] := qCoh[i]; i += 1 };
      qCoh := a;
    };
    if (qNowAttention.size() < n) {
      let a = Array.init<Float>(n, 1.0);
      var i = 0;
      while (i < qNowAttention.size()) { a[i] := qNowAttention[i]; i += 1 };
      qNowAttention := a;
    };
    if (qEntangledWith.size() < n) {
      let a = Array.init<Nat>(n, 0);
      // Initialise each entry: use existing data for old slots, self-ID for new ones
      var i = 0;
      while (i < n) {
        if (i < qEntangledWith.size()) { a[i] := qEntangledWith[i] } else { a[i] := i };
        i += 1;
      };
      qEntangledWith := a;
    };
  };

  func ensureRecCap() {
    if (recSeq.size() < REC_CAP) {
      recSeq       := growNat  (recSeq,      REC_CAP, 0);
      recBeat      := growNat  (recBeat,     REC_CAP, 0);
      recTs        := growInt  (recTs,       REC_CAP, 0);
      recAlpha     := growFloat(recAlpha,    REC_CAP, 0.0);
      recBeta      := growFloat(recBeta,     REC_CAP, 0.0);
      recGamma     := growFloat(recGamma,    REC_CAP, 0.0);
      recDelta     := growFloat(recDelta,    REC_CAP, 0.0);
      recConv      := growFloat(recConv,     REC_CAP, 0.0);
      recRSwarm    := growFloat(recRSwarm,   REC_CAP, 0.0);
      recJDrift    := growFloat(recJDrift,   REC_CAP, 0.0);
      recLabel     := growText (recLabel,    REC_CAP, "");
      recNowWeight := growFloat(recNowWeight,REC_CAP, 0.0);
    };
  };

  // ─── QUANTUM MATH PRIMITIVES ─────────────────────────────────────────────────

  // Re-normalise the 4 amplitude values rooted at [base] so Σ aᵢ² = 1
  func normalizeAmplitudes(base : Nat) {
    let a0 = qAmplitudes[base]; let a1 = qAmplitudes[base+1];
    let a2 = qAmplitudes[base+2]; let a3 = qAmplitudes[base+3];
    let norm = Float.sqrt(a0*a0 + a1*a1 + a2*a2 + a3*a3) + 0.0001;
    qAmplitudes[base]   := a0 / norm;
    qAmplitudes[base+1] := a1 / norm;
    qAmplitudes[base+2] := a2 / norm;
    qAmplitudes[base+3] := a3 / norm;
  };

  // Collapse: return the label of the state with the highest probability (aᵢ²)
  func measureState(base : Nat) : Text {
    let p0 = qAmplitudes[base]   * qAmplitudes[base];
    let p1 = qAmplitudes[base+1] * qAmplitudes[base+1];
    let p2 = qAmplitudes[base+2] * qAmplitudes[base+2];
    let p3 = qAmplitudes[base+3] * qAmplitudes[base+3];
    if      (p0 >= p1 and p0 >= p2 and p0 >= p3) "PATROL"
    else if (p1 >= p0 and p1 >= p2 and p1 >= p3) "ENGAGE"
    else if (p2 >= p0 and p2 >= p1 and p2 >= p3) "RETURN"
    else                                          "CRITICAL"
  };

  // Convergence: 4 channels agree → high score (1 = all identical, 0 = max spread)
  // Computed as 1 − 4·variance(a,b,c,d) clamped to [0,1].
  func computeConvergence(id : Nat) : Float {
    let cb = id * QUAD_CHANNELS;
    let a = qChannels[cb]; let b = qChannels[cb+1];
    let c = qChannels[cb+2]; let d = qChannels[cb+3];
    let mean = (a + b + c + d) / 4.0;
    let v = ((a-mean)*(a-mean) + (b-mean)*(b-mean) +
             (c-mean)*(c-mean) + (d-mean)*(d-mean)) / 4.0;
    Float.max(0.0, Float.min(1.0, 1.0 - v * 4.0))
  };

  // Cosine similarity between two 4-D vectors (for recognition memory)
  func cosineSim(a0:Float,a1:Float,a2:Float,a3:Float,
                 b0:Float,b1:Float,b2:Float,b3:Float) : Float {
    let dot   = a0*b0 + a1*b1 + a2*b2 + a3*b3;
    let normA = Float.sqrt(a0*a0+a1*a1+a2*a2+a3*a3) + 0.0001;
    let normB = Float.sqrt(b0*b0+b1*b1+b2*b2+b3*b3) + 0.0001;
    dot / (normA * normB)
  };

  // ─── REGISTER DRONE ─────────────────────────────────────────────────────────

  // Called once per drone (mirror of swarm_brain's addDrone).
  public func registerQuantumDrone(id : Nat) : async () {
    if (id >= MAX_DRONES) return;
    let newCount = if (id + 1 > qDroneCount) id + 1 else qDroneCount;
    ensureDroneCap(newCount);
    qDroneCount := newCount;

    // Equal superposition: all 4 quantum states equally probable
    let qb = id * Q_STATES;
    qAmplitudes[qb]   := 0.5;
    qAmplitudes[qb+1] := 0.5;
    qAmplitudes[qb+2] := 0.5;
    qAmplitudes[qb+3] := 0.5;

    // All four channels start at 0.5 (holistic balance)
    let cb = id * QUAD_CHANNELS;
    qChannels[cb]   := 0.5;  // ALPHA: spatial / sensing
    qChannels[cb+1] := 0.5;  // BETA:  temporal / memory
    qChannels[cb+2] := 0.5;  // GAMMA: relational / executive
    qChannels[cb+3] := 0.5;  // DELTA: emotional-motor / action

    qConvergence[id]  := 0.0;
    qCoh[id]          := 0.5;
    qNowAttention[id] := 1.0; // fully present at birth
    qEntangledWith[id] := id;  // self = no entanglement yet
  };

  // ─── QUANTUM TICK ────────────────────────────────────────────────────────────
  // Drive the quantum layer forward by one beat given current swarm metrics.
  // rSwarm and jDrift are passed from the main swarm_brain tick.
  public func quantumTick(
    rSwarm : Float,
    jDrift : Float,
    beat   : Nat,) : async QuantumSwarmMetrics {
    qBeat := beat;
    let n  = qDroneCount;
    if (n == 0) return {
      beat = beat; swarmQCoherence = 0.0; swarmConvergence = 0.0;
      nowIndex = 0.0; entanglementDensity = 0.0; dominantState = "PATROL"
    };

    // ── Phase 1: Update four 360-degree cognitive channels ────────────────────
    // ALPHA (spatial / sensor): sharpens with swarm coherence, dulled by drift
    // BETA  (temporal / memory): clearest when drift is zero (stable past recall)
    // GAMMA (relational):        social bond — moves toward ALPHA
    // DELTA (executive / action):goal clarity — rSwarm × stability
    var i = 0;
    while (i < n) {
      let cb = i * QUAD_CHANNELS;
      let alpha = qChannels[cb];
      let beta  = qChannels[cb+1];
      let gamma = qChannels[cb+2];
      let delta = qChannels[cb+3];

      let tAlpha = Float.max(0.0, Float.min(1.0, 0.5 + 0.5*rSwarm - 0.3*jDrift));
      let tBeta  = Float.max(0.0, Float.min(1.0, 1.0 / (1.0 + jDrift * JDRIFT_SENSITIVITY)));
      let tGamma = Float.max(0.0, Float.min(1.0, GAMMA_RSWARM_WEIGHT*rSwarm + GAMMA_ALPHA_WEIGHT*alpha));
      let tDelta = Float.max(0.0, Float.min(1.0, rSwarm * (1.0 - Float.min(1.0, jDrift))));

      qChannels[cb]   := alpha + (tAlpha - alpha) / CHAN_TAU;
      qChannels[cb+1] := beta  + (tBeta  - beta ) / CHAN_TAU;
      qChannels[cb+2] := gamma + (tGamma - gamma) / CHAN_TAU;
      qChannels[cb+3] := delta + (tDelta - delta) / CHAN_TAU;

      // ── Phase 2: Update superposition amplitudes ───────────────────────────
      // High coherence boosts PATROL; high stress boosts CRITICAL
      let qb     = i * Q_STATES;
      let stress = Float.min(1.0, jDrift * JDRIFT_SENSITIVITY);
      let coh    = rSwarm - 0.5; // [0, 0.5]

      let newA0 = Float.max(0.0, qAmplitudes[qb]   + coh*DT     - stress*DT*0.5);
      let newA1 = Float.max(0.0, qAmplitudes[qb+1] + 0.2*DT     - coh*DT*0.3);
      let newA2 = Float.max(0.0, qAmplitudes[qb+2] + 0.1*DT);
      let newA3 = Float.max(0.0, qAmplitudes[qb+3] + stress*DT  - coh*DT);

      qAmplitudes[qb]   := newA0;
      qAmplitudes[qb+1] := newA1;
      qAmplitudes[qb+2] := newA2;
      qAmplitudes[qb+3] := newA3;
      normalizeAmplitudes(qb);

      // ── Phase 3: Convergence (4-channel agreement) ─────────────────────────
      qConvergence[i] := computeConvergence(i);

      // ── Phase 4: Quantum coherence (channel convergence × state clarity) ───
      let dominant = Float.max(
        Float.max(qAmplitudes[qb]*qAmplitudes[qb],   qAmplitudes[qb+1]*qAmplitudes[qb+1]),
        Float.max(qAmplitudes[qb+2]*qAmplitudes[qb+2], qAmplitudes[qb+3]*qAmplitudes[qb+3])
      );
      qCoh[i] := 0.5 * qConvergence[i] + 0.5 * dominant;

      // ── Phase 5: Now-attention ─────────────────────────────────────────────
      // Pull toward present: rSwarm × (1 − jDrift); decay from past focus
      let nowTarget = Float.max(0.0, Float.min(1.0, rSwarm * (1.0 - Float.min(1.0, jDrift))));
      qNowAttention[i] := qNowAttention[i] + NOW_DECAY * (nowTarget - qNowAttention[i]);

      i += 1;
    };

    // ── Phase 6: Quantum entanglement ─────────────────────────────────────────
    // Pair highly-coherent unentangled drones; correlate entangled pairs
    i := 0;
    while (i < n) {
      // Form new entanglements for solo high-coherence drones
      if (qEntangledWith[i] == i and qCoh[i] > 0.7) {
        var bestJ     : Nat   = i;
        var bestScore : Float = 0.0;
        var j = 0;
        while (j < n) {
          if (j != i and qEntangledWith[j] == j and qCoh[j] > 0.7) {
            let sc = qCoh[i] * qCoh[j];
            if (sc > bestScore) { bestScore := sc; bestJ := j };
          };
          j += 1;
        };
        if (bestJ != i) {
          qEntangledWith[i]    := bestJ;
          qEntangledWith[bestJ] := i;
        };
      };
      // Correlate entangled pair amplitudes (symmetric pull toward average)
      if (qEntangledWith[i] != i) {
        let partner = qEntangledWith[i];
        if (partner < n) {
          let qbi = i * Q_STATES;
          let qbp = partner * Q_STATES;
          var s = 0;
          while (s < Q_STATES) {
            let ai  = qAmplitudes[qbi + s];
            let ap  = qAmplitudes[qbp + s];
            let avg = (ai + ap) / 2.0;
            qAmplitudes[qbi + s] := ai + ENT_STRENGTH * (avg - ai);
            qAmplitudes[qbp + s] := ap + ENT_STRENGTH * (avg - ap);
            s += 1;
          };
        };
      };
      i += 1;
    };

    // ── Phase 7: Swarm-level metrics ──────────────────────────────────────────
    var sumQCoh   : Float = 0.0;
    var sumConv   : Float = 0.0;
    var sumNow    : Float = 0.0;
    var entCount  : Nat   = 0;
    var nowHigh   : Nat   = 0;
    var nPatrol   : Nat   = 0;
    var nEngage   : Nat   = 0;
    var nReturn   : Nat   = 0;
    var nCritical : Nat   = 0;

    i := 0;
    while (i < n) {
      sumQCoh += qCoh[i];
      sumConv += qConvergence[i];
      sumNow  += qNowAttention[i];
      if (qNowAttention[i] > 0.5) nowHigh += 1;
      if (qEntangledWith[i] != i) entCount += 1;
      let st = measureState(i * Q_STATES);
      if      (st == "PATROL")   nPatrol   += 1
      else if (st == "ENGAGE")   nEngage   += 1
      else if (st == "RETURN")   nReturn   += 1
      else                        nCritical += 1;
      i += 1;
    };

    let fn = Float.fromInt(n);
    swarmQCoherence  := sumQCoh / fn;
    swarmConvergence := sumConv / fn;

    var domState = "PATROL";
    var domCnt   = nPatrol;
    if (nEngage   > domCnt) { domState := "ENGAGE";   domCnt := nEngage   };
    if (nReturn   > domCnt) { domState := "RETURN";   domCnt := nReturn   };
    if (nCritical > domCnt) { domState := "CRITICAL"; domCnt := nCritical };

    {
      beat                = beat;
      swarmQCoherence     = swarmQCoherence;
      swarmConvergence    = swarmConvergence;
      nowIndex            = Float.fromInt(nowHigh) / fn;
      entanglementDensity = Float.fromInt(entCount) / fn;
      dominantState       = domState;
    }
  };

  // ─── RECOGNITION MEMORY ──────────────────────────────────────────────────────
  // Memory is a RECOGNITION layer — it matches the present against the encoded
  // past using cosine similarity weighted by present-moment salience (nowWeight).

  // Encode the current four-channel state into recognition memory.
  public func encodeMemory(
    beat   : Nat,
    alpha  : Float,
    beta   : Float,
    gamma  : Float,
    delta  : Float,
    conv   : Float,
    rSwarm : Float,
    jDrift : Float,
    lbl  : Text,
  ) : async Nat {
    ensureRecCap();
    let idx          = recNextIdx % REC_CAP;
    recSeq[idx]      := recTotal;
    recBeat[idx]     := beat;
    recTs[idx]       := Time.now();
    recAlpha[idx]    := alpha;
    recBeta[idx]     := beta;
    recGamma[idx]    := gamma;
    recDelta[idx]    := delta;
    recConv[idx]     := conv;
    recRSwarm[idx]   := rSwarm;
    recJDrift[idx]   := jDrift;
    recLabel[idx]    := lbl;
    recNowWeight[idx] := 1.0; // fully present when just encoded
    let seq   = recTotal;
    recNextIdx := (recNextIdx + 1) % REC_CAP;
    recTotal   += 1;
    seq
  };

  // Decay nowWeight for all stored memories (call once per beat).
  public func decayMemoryNow(currentBeat : Nat) : async () {
    ensureRecCap();
    let total = if (recTotal < REC_CAP) recTotal else REC_CAP;
    var i = 0;
    while (i < total) {
      let dt = Float.fromInt(currentBeat - recBeat[i]);
      // Exponential decay with half-life = 50 beats
      recNowWeight[i] := Float.exp(-dt / MEMORY_HALFLIFE_BEATS);
      i += 1;
    };
  };

  // Recognize: find the stored memory whose four-channel vector is most similar
  // to the query vector, weighted by nowWeight (recent memories are more salient).
  // Returns the best match's seq, label, similarity score, and nowWeight.
  public query func recognizeState(
    alpha : Float,
    beta  : Float,
    gamma : Float,
    delta : Float,
  ) : async { seq : Nat; lbl : Text; recognitionScore : Float; nowWeight : Float } {
    let total = if (recTotal < REC_CAP) recTotal else REC_CAP;
    if (total == 0) return {
      seq = 0; lbl = "NONE"; recognitionScore = 0.0; nowWeight = 0.0
    };
    var bestIdx   : Nat   = 0;
    var bestScore : Float = -1.0;
    var i = 0;
    while (i < total) {
      let sim = cosineSim(
        alpha, beta, gamma, delta,
        recAlpha[i], recBeta[i], recGamma[i], recDelta[i]
      );
      // Weight: 70% similarity + 30% nowWeight → recent memories win ties
      let weighted = sim * (SIMILARITY_WEIGHT + RECENCY_WEIGHT * recNowWeight[i]);
      if (weighted > bestScore) { bestScore := weighted; bestIdx := i };
      i += 1;
    };
    {
      seq              = recSeq[bestIdx];
      lbl            = recLabel[bestIdx];
      recognitionScore = bestScore;
      nowWeight        = recNowWeight[bestIdx];
    }
  };

  // Retrieve all stored recognition memories.
  public query func getAllMemories() : async [RecognitionEntry] {
    let total = if (recTotal < REC_CAP) recTotal else REC_CAP;
    Array.tabulate<RecognitionEntry>(total, func(i) {
      {
        seq              = recSeq[i];
        beat             = recBeat[i];
        timestamp        = recTs[i];
        alphaAmp         = recAlpha[i];
        betaAmp          = recBeta[i];
        gammaAmp         = recGamma[i];
        deltaAmp         = recDelta[i];
        convergenceScore = recConv[i];
        rSwarm           = recRSwarm[i];
        jDrift           = recJDrift[i];
        lbl            = recLabel[i];
        nowWeight        = recNowWeight[i];
      }
    })
  };

  // ─── DRONE QUERY FUNCTIONS ───────────────────────────────────────────────────

  // Full quantum state for one drone.
  public query func getDroneQuantumState(id : Nat) : async ?DroneQuantumState {
    if (id >= qDroneCount) return null;
    let qb = id * Q_STATES;
    let cb = id * QUAD_CHANNELS;
    ?{
      droneId          = id;
      ampPatrol        = qAmplitudes[qb];
      ampEngage        = qAmplitudes[qb+1];
      ampReturn        = qAmplitudes[qb+2];
      ampCritical      = qAmplitudes[qb+3];
      measuredState    = measureState(qb);
      alphaChannel     = qChannels[cb];
      betaChannel      = qChannels[cb+1];
      gammaChannel     = qChannels[cb+2];
      deltaChannel     = qChannels[cb+3];
      convergenceScore = qConvergence[id];
      qCoherence       = qCoh[id];
      nowAttention     = qNowAttention[id];
      entangledWith    = qEntangledWith[id];
    }
  };

  // All drone quantum states in one call (frontend efficiency).
  public query func getAllQuantumStates() : async [DroneQuantumState] {
    Array.tabulate<DroneQuantumState>(qDroneCount, func(id) {
      let qb = id * Q_STATES;
      let cb = id * QUAD_CHANNELS;
      {
        droneId          = id;
        ampPatrol        = qAmplitudes[qb];
        ampEngage        = qAmplitudes[qb+1];
        ampReturn        = qAmplitudes[qb+2];
        ampCritical      = qAmplitudes[qb+3];
        measuredState    = measureState(qb);
        alphaChannel     = qChannels[cb];
        betaChannel      = qChannels[cb+1];
        gammaChannel     = qChannels[cb+2];
        deltaChannel     = qChannels[cb+3];
        convergenceScore = qConvergence[id];
        qCoherence       = qCoh[id];
        nowAttention     = qNowAttention[id];
        entangledWith    = qEntangledWith[id];
      }
    })
  };

  // Swarm-level quantum summary (cached from last quantumTick).
  public query func getSwarmQuantumMetrics() : async {
    swarmQCoherence  : Float;
    swarmConvergence : Float;
    beat             : Nat;
    droneCount       : Nat;
  } {
    {
      swarmQCoherence  = swarmQCoherence;
      swarmConvergence = swarmConvergence;
      beat             = qBeat;
      droneCount       = qDroneCount;
    }
  };

  public query func getDroneCount() : async Nat { qDroneCount };

};
