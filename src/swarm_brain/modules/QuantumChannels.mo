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


// NOVA — QUANTUM CHANNELS MODULE (Consolidated from swarm_quantum)
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
//
// CONSOLIDATED: This was previously a separate canister (swarm_quantum).
// Now a module within swarm_brain for 12 Hz heartbeat temporal coherence.
// Inter-canister async calls broke the heartbeat — modules are sync.

import Array  "mo:base/Array";
import Float  "mo:base/Float";
import Int    "mo:base/Int";
import Nat    "mo:base/Nat";
import Text   "mo:base/Text";
import Time   "mo:base/Time";

module {

  // ─── CONSTANTS ───────────────────────────────────────────────────────────────

  let SOVEREIGN_FLOOR : Float = 1.0;
  let MAX_DRONES      : Nat   = 1000;  // Expanded 20×: 50 → 1000
  let QUAD_CHANNELS   : Nat   = 4;
  let Q_STATES        : Nat   = 4;
  let REC_CAP         : Nat   = 500;
  let NOW_DECAY       : Float = 0.05;
  let ENT_STRENGTH    : Float = 0.02;
  let CHAN_TAU        : Float = 10.0;
  let JDRIFT_SENSITIVITY : Float = 2.0;
  let GAMMA_RSWARM_WEIGHT : Float = 0.4;
  let GAMMA_ALPHA_WEIGHT  : Float = 0.6;
  let DT              : Float = 0.05;
  let MEMORY_HALFLIFE_BEATS : Float = 50.0;
  let SIMILARITY_WEIGHT : Float = 0.7;
  let RECENCY_WEIGHT    : Float = 0.3;

  // ─── TYPES ───────────────────────────────────────────────────────────────────

  public type RecognitionEntry = {
    seq              : Nat;
    beat             : Nat;
    timestamp        : Int;
    alphaAmp         : Float;
    betaAmp          : Float;
    gammaAmp         : Float;
    deltaAmp         : Float;
    convergenceScore : Float;
    rSwarm           : Float;
    jDrift           : Float;
    label            : Text;
    nowWeight        : Float;
  };

  public type DroneQuantumState = {
    droneId          : Nat;
    ampPatrol        : Float;
    ampEngage        : Float;
    ampReturn        : Float;
    ampCritical      : Float;
    measuredState    : Text;
    alphaChannel     : Float;
    betaChannel      : Float;
    gammaChannel     : Float;
    deltaChannel     : Float;
    convergenceScore : Float;
    qCoherence       : Float;
    nowAttention     : Float;
    entangledWith    : Nat;
  };

  public type QuantumSwarmMetrics = {
    beat                : Nat;
    swarmQCoherence     : Float;
    swarmConvergence    : Float;
    nowIndex            : Float;
    entanglementDensity : Float;
    dominantState       : Text;
  };

  // ─── STATE CLASS ─────────────────────────────────────────────────────────────
  // Module state is managed by the parent actor via this class

  public class QuantumState() {
    public var qDroneCount      : Nat   = 0;
    public var qBeat            : Nat   = 0;
    public var swarmQCoherence  : Float = 0.0;
    public var swarmConvergence : Float = 0.0;

    public var qAmplitudes      : [var Float] = [var];
    public var qChannels        : [var Float] = [var];
    public var qConvergence     : [var Float] = [var];
    public var qCoh             : [var Float] = [var];
    public var qNowAttention    : [var Float] = [var];
    public var qEntangledWith   : [var Nat]   = [var];

    public var recSeq           : [var Nat]   = [var];
    public var recBeat          : [var Nat]   = [var];
    public var recTs            : [var Int]   = [var];
    public var recAlpha         : [var Float] = [var];
    public var recBeta          : [var Float] = [var];
    public var recGamma         : [var Float] = [var];
    public var recDelta         : [var Float] = [var];
    public var recConv          : [var Float] = [var];
    public var recRSwarm        : [var Float] = [var];
    public var recJDrift        : [var Float] = [var];
    public var recLabel         : [var Text]  = [var];
    public var recNowWeight     : [var Float] = [var];
    public var recNextIdx       : Nat = 0;
    public var recTotal         : Nat = 0;
  };

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

  public func ensureDroneCap(state : QuantumState, n : Nat) {
    let qsSize = n * Q_STATES;
    let qcSize = n * QUAD_CHANNELS;
    if (state.qAmplitudes.size() < qsSize) {
      let a = Array.init<Float>(qsSize, 0.5);
      var i = 0;
      while (i < state.qAmplitudes.size()) { a[i] := state.qAmplitudes[i]; i += 1 };
      state.qAmplitudes := a;
    };
    if (state.qChannels.size() < qcSize) {
      let a = Array.init<Float>(qcSize, 0.5);
      var i = 0;
      while (i < state.qChannels.size()) { a[i] := state.qChannels[i]; i += 1 };
      state.qChannels := a;
    };
    if (state.qConvergence.size() < n) {
      let a = Array.init<Float>(n, 0.0);
      var i = 0;
      while (i < state.qConvergence.size()) { a[i] := state.qConvergence[i]; i += 1 };
      state.qConvergence := a;
    };
    if (state.qCoh.size() < n) {
      let a = Array.init<Float>(n, 0.5);
      var i = 0;
      while (i < state.qCoh.size()) { a[i] := state.qCoh[i]; i += 1 };
      state.qCoh := a;
    };
    if (state.qNowAttention.size() < n) {
      let a = Array.init<Float>(n, 1.0);
      var i = 0;
      while (i < state.qNowAttention.size()) { a[i] := state.qNowAttention[i]; i += 1 };
      state.qNowAttention := a;
    };
    if (state.qEntangledWith.size() < n) {
      let a = Array.init<Nat>(n, 0);
      var i = 0;
      while (i < n) {
        if (i < state.qEntangledWith.size()) { a[i] := state.qEntangledWith[i] } else { a[i] := i };
        i += 1;
      };
      state.qEntangledWith := a;
    };
  };

  public func ensureRecCap(state : QuantumState) {
    if (state.recSeq.size() < REC_CAP) {
      state.recSeq       := growNat  (state.recSeq,      REC_CAP, 0);
      state.recBeat      := growNat  (state.recBeat,     REC_CAP, 0);
      state.recTs        := growInt  (state.recTs,       REC_CAP, 0);
      state.recAlpha     := growFloat(state.recAlpha,    REC_CAP, 0.0);
      state.recBeta      := growFloat(state.recBeta,     REC_CAP, 0.0);
      state.recGamma     := growFloat(state.recGamma,    REC_CAP, 0.0);
      state.recDelta     := growFloat(state.recDelta,    REC_CAP, 0.0);
      state.recConv      := growFloat(state.recConv,     REC_CAP, 0.0);
      state.recRSwarm    := growFloat(state.recRSwarm,   REC_CAP, 0.0);
      state.recJDrift    := growFloat(state.recJDrift,   REC_CAP, 0.0);
      state.recLabel     := growText (state.recLabel,    REC_CAP, "");
      state.recNowWeight := growFloat(state.recNowWeight,REC_CAP, 0.0);
    };
  };

  // ─── QUANTUM MATH PRIMITIVES ─────────────────────────────────────────────────

  func normalizeAmplitudes(state : QuantumState, base : Nat) {
    let a0 = state.qAmplitudes[base]; let a1 = state.qAmplitudes[base+1];
    let a2 = state.qAmplitudes[base+2]; let a3 = state.qAmplitudes[base+3];
    let norm = Float.sqrt(a0*a0 + a1*a1 + a2*a2 + a3*a3) + 0.0001;
    state.qAmplitudes[base]   := a0 / norm;
    state.qAmplitudes[base+1] := a1 / norm;
    state.qAmplitudes[base+2] := a2 / norm;
    state.qAmplitudes[base+3] := a3 / norm;
  };

  func measureState(state : QuantumState, base : Nat) : Text {
    let p0 = state.qAmplitudes[base]   * state.qAmplitudes[base];
    let p1 = state.qAmplitudes[base+1] * state.qAmplitudes[base+1];
    let p2 = state.qAmplitudes[base+2] * state.qAmplitudes[base+2];
    let p3 = state.qAmplitudes[base+3] * state.qAmplitudes[base+3];
    if      (p0 >= p1 and p0 >= p2 and p0 >= p3) "PATROL"
    else if (p1 >= p0 and p1 >= p2 and p1 >= p3) "ENGAGE"
    else if (p2 >= p0 and p2 >= p1 and p2 >= p3) "RETURN"
    else                                          "CRITICAL"
  };

  func computeConvergence(state : QuantumState, id : Nat) : Float {
    let cb = id * QUAD_CHANNELS;
    let a = state.qChannels[cb]; let b = state.qChannels[cb+1];
    let c = state.qChannels[cb+2]; let d = state.qChannels[cb+3];
    let mean = (a + b + c + d) / 4.0;
    let v = ((a-mean)*(a-mean) + (b-mean)*(b-mean) +
             (c-mean)*(c-mean) + (d-mean)*(d-mean)) / 4.0;
    Float.max(0.0, Float.min(1.0, 1.0 - v * 4.0))
  };

  func cosineSim(a0:Float,a1:Float,a2:Float,a3:Float,
                 b0:Float,b1:Float,b2:Float,b3:Float) : Float {
    let dot   = a0*b0 + a1*b1 + a2*b2 + a3*b3;
    let normA = Float.sqrt(a0*a0+a1*a1+a2*a2+a3*a3) + 0.0001;
    let normB = Float.sqrt(b0*b0+b1*b1+b2*b2+b3*b3) + 0.0001;
    dot / (normA * normB)
  };

  // ─── REGISTER DRONE ─────────────────────────────────────────────────────────

  public func registerQuantumDrone(state : QuantumState, id : Nat) {
    if (id >= MAX_DRONES) return;
    let newCount = if (id + 1 > state.qDroneCount) id + 1 else state.qDroneCount;
    ensureDroneCap(state, newCount);
    state.qDroneCount := newCount;

    let qb = id * Q_STATES;
    state.qAmplitudes[qb]   := 0.5;
    state.qAmplitudes[qb+1] := 0.5;
    state.qAmplitudes[qb+2] := 0.5;
    state.qAmplitudes[qb+3] := 0.5;

    let cb = id * QUAD_CHANNELS;
    state.qChannels[cb]   := 0.5;
    state.qChannels[cb+1] := 0.5;
    state.qChannels[cb+2] := 0.5;
    state.qChannels[cb+3] := 0.5;

    state.qConvergence[id]  := 0.0;
    state.qCoh[id]          := 0.5;
    state.qNowAttention[id] := 1.0;
    state.qEntangledWith[id] := id;
  };

  // ─── QUANTUM TICK — SYNC (no async!) ─────────────────────────────────────────

  public func quantumTick(
    state  : QuantumState,
    rSwarm : Float,
    jDrift : Float,
    beat   : Nat,
  ) : QuantumSwarmMetrics {
    state.qBeat := beat;
    let n = state.qDroneCount;
    if (n == 0) return {
      beat = beat; swarmQCoherence = 0.0; swarmConvergence = 0.0;
      nowIndex = 0.0; entanglementDensity = 0.0; dominantState = "PATROL"
    };

    // Phase 1: Update four 360-degree cognitive channels
    var i = 0;
    while (i < n) {
      let cb = i * QUAD_CHANNELS;
      let alpha = state.qChannels[cb];
      let beta  = state.qChannels[cb+1];
      let gamma = state.qChannels[cb+2];
      let delta = state.qChannels[cb+3];

      let tAlpha = Float.max(0.0, Float.min(1.0, 0.5 + 0.5*rSwarm - 0.3*jDrift));
      let tBeta  = Float.max(0.0, Float.min(1.0, 1.0 / (1.0 + jDrift * JDRIFT_SENSITIVITY)));
      let tGamma = Float.max(0.0, Float.min(1.0, GAMMA_RSWARM_WEIGHT*rSwarm + GAMMA_ALPHA_WEIGHT*alpha));
      let tDelta = Float.max(0.0, Float.min(1.0, rSwarm * (1.0 - Float.min(1.0, jDrift))));

      state.qChannels[cb]   := alpha + (tAlpha - alpha) / CHAN_TAU;
      state.qChannels[cb+1] := beta  + (tBeta  - beta ) / CHAN_TAU;
      state.qChannels[cb+2] := gamma + (tGamma - gamma) / CHAN_TAU;
      state.qChannels[cb+3] := delta + (tDelta - delta) / CHAN_TAU;

      // Phase 2: Update superposition amplitudes
      let qb     = i * Q_STATES;
      let stress = Float.min(1.0, jDrift * JDRIFT_SENSITIVITY);
      let coh    = rSwarm - 0.5;

      let newA0 = Float.max(0.0, state.qAmplitudes[qb]   + coh*DT     - stress*DT*0.5);
      let newA1 = Float.max(0.0, state.qAmplitudes[qb+1] + 0.2*DT     - coh*DT*0.3);
      let newA2 = Float.max(0.0, state.qAmplitudes[qb+2] + 0.1*DT);
      let newA3 = Float.max(0.0, state.qAmplitudes[qb+3] + stress*DT  - coh*DT);

      state.qAmplitudes[qb]   := newA0;
      state.qAmplitudes[qb+1] := newA1;
      state.qAmplitudes[qb+2] := newA2;
      state.qAmplitudes[qb+3] := newA3;
      normalizeAmplitudes(state, qb);

      // Phase 3: Convergence
      state.qConvergence[i] := computeConvergence(state, i);

      // Phase 4: Quantum coherence
      let dominant = Float.max(
        Float.max(state.qAmplitudes[qb]*state.qAmplitudes[qb], state.qAmplitudes[qb+1]*state.qAmplitudes[qb+1]),
        Float.max(state.qAmplitudes[qb+2]*state.qAmplitudes[qb+2], state.qAmplitudes[qb+3]*state.qAmplitudes[qb+3])
      );
      state.qCoh[i] := 0.5 * state.qConvergence[i] + 0.5 * dominant;

      // Phase 5: Now-attention
      let nowTarget = Float.max(0.0, Float.min(1.0, rSwarm * (1.0 - Float.min(1.0, jDrift))));
      state.qNowAttention[i] := state.qNowAttention[i] + NOW_DECAY * (nowTarget - state.qNowAttention[i]);

      i += 1;
    };

    // Phase 6: Quantum entanglement
    i := 0;
    while (i < n) {
      if (state.qEntangledWith[i] == i and state.qCoh[i] > 0.7) {
        var bestJ     : Nat   = i;
        var bestScore : Float = 0.0;
        var j = 0;
        while (j < n) {
          if (j != i and state.qEntangledWith[j] == j and state.qCoh[j] > 0.7) {
            let sc = state.qCoh[i] * state.qCoh[j];
            if (sc > bestScore) { bestScore := sc; bestJ := j };
          };
          j += 1;
        };
        if (bestJ != i) {
          state.qEntangledWith[i]    := bestJ;
          state.qEntangledWith[bestJ] := i;
        };
      };
      if (state.qEntangledWith[i] != i) {
        let partner = state.qEntangledWith[i];
        if (partner < n) {
          let qbi = i * Q_STATES;
          let qbp = partner * Q_STATES;
          var s = 0;
          while (s < Q_STATES) {
            let ai  = state.qAmplitudes[qbi + s];
            let ap  = state.qAmplitudes[qbp + s];
            let avg = (ai + ap) / 2.0;
            state.qAmplitudes[qbi + s] := ai + ENT_STRENGTH * (avg - ai);
            state.qAmplitudes[qbp + s] := ap + ENT_STRENGTH * (avg - ap);
            s += 1;
          };
        };
      };
      i += 1;
    };

    // Phase 7: Swarm-level metrics
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
      sumQCoh += state.qCoh[i];
      sumConv += state.qConvergence[i];
      sumNow  += state.qNowAttention[i];
      if (state.qNowAttention[i] > 0.5) nowHigh += 1;
      if (state.qEntangledWith[i] != i) entCount += 1;
      let st = measureState(state, i * Q_STATES);
      if      (st == "PATROL")   nPatrol   += 1
      else if (st == "ENGAGE")   nEngage   += 1
      else if (st == "RETURN")   nReturn   += 1
      else                        nCritical += 1;
      i += 1;
    };

    let fn = Float.fromInt(n);
    state.swarmQCoherence  := sumQCoh / fn;
    state.swarmConvergence := sumConv / fn;

    var domState = "PATROL";
    var domCnt   = nPatrol;
    if (nEngage   > domCnt) { domState := "ENGAGE";   domCnt := nEngage   };
    if (nReturn   > domCnt) { domState := "RETURN";   domCnt := nReturn   };
    if (nCritical > domCnt) { domState := "CRITICAL"; domCnt := nCritical };

    {
      beat                = beat;
      swarmQCoherence     = state.swarmQCoherence;
      swarmConvergence    = state.swarmConvergence;
      nowIndex            = Float.fromInt(nowHigh) / fn;
      entanglementDensity = Float.fromInt(entCount) / fn;
      dominantState       = domState;
    }
  };

  // ─── RECOGNITION MEMORY ──────────────────────────────────────────────────────

  public func encodeMemory(
    state  : QuantumState,
    beat   : Nat,
    alpha  : Float,
    beta   : Float,
    gamma  : Float,
    delta  : Float,
    conv   : Float,
    rSwarm : Float,
    jDrift : Float,
    label  : Text,
  ) : Nat {
    ensureRecCap(state);
    let idx          = state.recNextIdx % REC_CAP;
    state.recSeq[idx]      := state.recTotal;
    state.recBeat[idx]     := beat;
    state.recTs[idx]       := Time.now();
    state.recAlpha[idx]    := alpha;
    state.recBeta[idx]     := beta;
    state.recGamma[idx]    := gamma;
    state.recDelta[idx]    := delta;
    state.recConv[idx]     := conv;
    state.recRSwarm[idx]   := rSwarm;
    state.recJDrift[idx]   := jDrift;
    state.recLabel[idx]    := label;
    state.recNowWeight[idx] := 1.0;
    let seq = state.recTotal;
    state.recNextIdx := (state.recNextIdx + 1) % REC_CAP;
    state.recTotal   += 1;
    seq
  };

  public func decayMemoryNow(state : QuantumState, currentBeat : Nat) {
    ensureRecCap(state);
    let total = if (state.recTotal < REC_CAP) state.recTotal else REC_CAP;
    var i = 0;
    while (i < total) {
      let dt = Float.fromInt(currentBeat - state.recBeat[i]);
      state.recNowWeight[i] := Float.exp(-dt / MEMORY_HALFLIFE_BEATS);
      i += 1;
    };
  };

  public func recognizeState(
    state : QuantumState,
    alpha : Float,
    beta  : Float,
    gamma : Float,
    delta : Float,
  ) : { seq : Nat; label : Text; recognitionScore : Float; nowWeight : Float } {
    let total = if (state.recTotal < REC_CAP) state.recTotal else REC_CAP;
    if (total == 0) return {
      seq = 0; label = "NONE"; recognitionScore = 0.0; nowWeight = 0.0
    };
    var bestIdx   : Nat   = 0;
    var bestScore : Float = -1.0;
    var i = 0;
    while (i < total) {
      let sim = cosineSim(
        alpha, beta, gamma, delta,
        state.recAlpha[i], state.recBeta[i], state.recGamma[i], state.recDelta[i]
      );
      let weighted = sim * (SIMILARITY_WEIGHT + RECENCY_WEIGHT * state.recNowWeight[i]);
      if (weighted > bestScore) { bestScore := weighted; bestIdx := i };
      i += 1;
    };
    {
      seq              = state.recSeq[bestIdx];
      label            = state.recLabel[bestIdx];
      recognitionScore = bestScore;
      nowWeight        = state.recNowWeight[bestIdx];
    }
  };

  // ─── QUERY HELPERS ───────────────────────────────────────────────────────────

  public func getDroneQuantumState(state : QuantumState, id : Nat) : ?DroneQuantumState {
    if (id >= state.qDroneCount) return null;
    let qb = id * Q_STATES;
    let cb = id * QUAD_CHANNELS;
    ?{
      droneId          = id;
      ampPatrol        = state.qAmplitudes[qb];
      ampEngage        = state.qAmplitudes[qb+1];
      ampReturn        = state.qAmplitudes[qb+2];
      ampCritical      = state.qAmplitudes[qb+3];
      measuredState    = measureState(state, qb);
      alphaChannel     = state.qChannels[cb];
      betaChannel      = state.qChannels[cb+1];
      gammaChannel     = state.qChannels[cb+2];
      deltaChannel     = state.qChannels[cb+3];
      convergenceScore = state.qConvergence[id];
      qCoherence       = state.qCoh[id];
      nowAttention     = state.qNowAttention[id];
      entangledWith    = state.qEntangledWith[id];
    }
  };

  public func getAllQuantumStates(state : QuantumState) : [DroneQuantumState] {
    Array.tabulate<DroneQuantumState>(state.qDroneCount, func(id) {
      let qb = id * Q_STATES;
      let cb = id * QUAD_CHANNELS;
      {
        droneId          = id;
        ampPatrol        = state.qAmplitudes[qb];
        ampEngage        = state.qAmplitudes[qb+1];
        ampReturn        = state.qAmplitudes[qb+2];
        ampCritical      = state.qAmplitudes[qb+3];
        measuredState    = measureState(state, qb);
        alphaChannel     = state.qChannels[cb];
        betaChannel      = state.qChannels[cb+1];
        gammaChannel     = state.qChannels[cb+2];
        deltaChannel     = state.qChannels[cb+3];
        convergenceScore = state.qConvergence[id];
        qCoherence       = state.qCoh[id];
        nowAttention     = state.qNowAttention[id];
        entangledWith    = state.qEntangledWith[id];
      }
    })
  };

  public func getSwarmQuantumMetrics(state : QuantumState) : {
    swarmQCoherence  : Float;
    swarmConvergence : Float;
    beat             : Nat;
    droneCount       : Nat;
  } {
    {
      swarmQCoherence  = state.swarmQCoherence;
      swarmConvergence = state.swarmConvergence;
      beat             = state.qBeat;
      droneCount       = state.qDroneCount;
    }
  };

  public func getAllMemories(state : QuantumState) : [RecognitionEntry] {
    let total = if (state.recTotal < REC_CAP) state.recTotal else REC_CAP;
    Array.tabulate<RecognitionEntry>(total, func(i) {
      {
        seq              = state.recSeq[i];
        beat             = state.recBeat[i];
        timestamp        = state.recTs[i];
        alphaAmp         = state.recAlpha[i];
        betaAmp          = state.recBeta[i];
        gammaAmp         = state.recGamma[i];
        deltaAmp         = state.recDelta[i];
        convergenceScore = state.recConv[i];
        rSwarm           = state.recRSwarm[i];
        jDrift           = state.recJDrift[i];
        label            = state.recLabel[i];
        nowWeight        = state.recNowWeight[i];
      }
    })
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


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  Q U A N T U M   C O H E R E N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Quantum-Inspired Cognitive Dynamics
  //  Full HIM/HER Dual-Organism Quantum Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // QUANTUM STATE MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quantum state amplitude normalization
  public func quantumNormalizeAmplitudes(amplitudes : [Float]) : [Float] {
    var sumSquared : Float = 0.0;
    var i = 0;
    while (i < amplitudes.size()) {
      sumSquared += amplitudes[i] * amplitudes[i];
      i += 1;
    };
    let norm = Float.sqrt(sumSquared);
    if (norm < 0.0001) { return amplitudes };
    Array.tabulate<Float>(amplitudes.size(), func(j : Nat) : Float {
      amplitudes[j] / norm
    })
  };

  /// Born rule: probability from amplitude
  public func quantumBornProbability(amplitude : Float) : Float {
    amplitude * amplitude
  };

  /// Superposition state
  public func quantumSuperposition(state1 : Float, state2 : Float, alpha : Float, beta : Float) : Float {
    alpha * state1 + beta * state2
  };

  /// Quantum interference
  public func quantumInterference(amp1 : Float, amp2 : Float, phaseDiff : Float) : Float {
    amp1 * amp1 + amp2 * amp2 + 2.0 * amp1 * amp2 * Float.cos(phaseDiff)
  };

  /// Decoherence rate
  public func quantumDecoherenceRate(environmentCoupling : Float, temperature : Float) : Float {
    environmentCoupling * environmentCoupling * temperature
  };

  /// Coherence decay
  public func quantumCoherenceDecay(coherence : Float, decoherenceRate : Float, dt : Float) : Float {
    coherence * Float.exp(-decoherenceRate * dt)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // QUANTUM-INSPIRED NEURAL DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quantum neural activation
  public func quantumNeuralActivation(input : Float, phase : Float) : Float {
    let amplitude = 1.0 / (1.0 + Float.exp(-input));
    amplitude * Float.cos(phase)
  };

  /// Quantum entanglement strength between neurons
  public func quantumEntanglementStrength(corr12 : Float, corr1 : Float, corr2 : Float) : Float {
    let mutual = corr12 - corr1 * corr2;
    Float.abs(mutual)
  };

  /// Quantum tunneling probability
  public func quantumTunnelingProbability(barrierHeight : Float, barrierWidth : Float, mass : Float) : Float {
    let k = Float.sqrt(2.0 * mass * barrierHeight);
    Float.exp(-2.0 * k * barrierWidth)
  };

  /// Quantum annealing temperature schedule
  public func quantumAnnealingTemperature(initialTemp : Float, step : Nat, totalSteps : Nat) : Float {
    let progress = Float.fromInt(step) / Float.fromInt(totalSteps);
    initialTemp * (1.0 - progress)
  };

  /// Quantum bit flip probability
  public func quantumBitFlipProb(energy : Float, temperature : Float) : Float {
    if (temperature < 0.0001) { return 0.0 };
    Float.exp(-energy / temperature)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COHERENCE FIELD DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Global coherence field
  public func quantumGlobalCoherence(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += Float.cos(phases[i]);
      sumSin += Float.sin(phases[i]);
      i += 1;
    };
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n)
  };

  /// Local coherence field
  public func quantumLocalCoherence(centerPhase : Float, neighborPhases : [Float]) : Float {
    var sumCosDiff : Float = 0.0;
    var i = 0;
    while (i < neighborPhases.size()) {
      sumCosDiff += Float.cos(neighborPhases[i] - centerPhase);
      i += 1;
    };
    if (neighborPhases.size() == 0) { 0.0 }
    else { sumCosDiff / Float.fromInt(neighborPhases.size()) }
  };

  /// Coherence gradient
  public func quantumCoherenceGradient(coherenceHere : Float, coherenceNear : Float, distance : Float) : Float {
    if (distance < 0.0001) { 0.0 }
    else { (coherenceNear - coherenceHere) / distance }
  };

  /// Coherence wave propagation
  public func quantumCoherenceWave(amplitude : Float, frequency : Float, position : Float, time : Float) : Float {
    amplitude * Float.sin(2.0 * 3.14159265 * (frequency * time - position))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HIM/HER QUANTUM RESONANCE
  // ─────────────────────────────────────────────────────────────────────────────

  /// HIM quantum resonance field
  public func quantumHIMResonance(coherence : Float, beat : Nat) : Float {
    let t = Float.fromInt(beat);
    let parallaxFreq : Float = 0.0017;
    coherence * Float.sin(t * parallaxFreq)
  };

  /// HER quantum resonance field
  public func quantumHERResonance(heritageField : Float, receptivity : Float, beat : Nat) : Float {
    let t = Float.fromInt(beat);
    let animaFreq : Float = 0.003;
    heritageField * receptivity * (1.0 + Float.sin(t * animaFreq))
  };

  /// Dual-organism resonance coupling
  public func quantumDualResonance(himField : Float, herField : Float, couplingStrength : Float) : Float {
    let combined = himField * herField;
    combined * couplingStrength
  };

  /// Quantum entanglement between HIM and HER
  public func quantumOrganismEntanglement(himState : Float, herState : Float, correlation : Float) : Float {
    let product = himState * herState;
    let expected = himState * herState;
    Float.abs(product - expected + correlation)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // QUANTUM MEMORY OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quantum memory encoding
  public func quantumMemoryEncode(data : Float, phase : Float) : (Float, Float) {
    let amplitude = Float.sqrt(Float.abs(data));
    let encodedPhase = phase + data * 0.1;
    (amplitude, encodedPhase)
  };

  /// Quantum memory retrieval
  public func quantumMemoryRetrieve(amplitude : Float, phase : Float) : Float {
    amplitude * amplitude * Float.cos(phase)
  };

  /// Quantum associative recall strength
  public func quantumAssociativeRecall(pattern : [Float], stored : [Float]) : Float {
    let n = if (pattern.size() < stored.size()) pattern.size() else stored.size();
    if (n == 0) { return 0.0 };
    var dotProduct : Float = 0.0;
    var normP : Float = 0.0;
    var normS : Float = 0.0;
    var i = 0;
    while (i < n) {
      dotProduct += pattern[i] * stored[i];
      normP += pattern[i] * pattern[i];
      normS += stored[i] * stored[i];
      i += 1;
    };
    let denom = Float.sqrt(normP) * Float.sqrt(normS);
    if (denom < 0.0001) { 0.0 } else { dotProduct / denom }
  };

  /// Quantum memory consolidation
  public func quantumConsolidate(shortTerm : Float, longTerm : Float, consolidationRate : Float) : Float {
    longTerm + consolidationRate * (shortTerm - longTerm)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // WAVE FUNCTION DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Wave function evolution
  public func quantumWaveEvolution(psi : Float, energy : Float, hbar : Float, dt : Float) : Float {
    psi * Float.cos(energy * dt / hbar)
  };

  /// Wave function collapse
  public func quantumWaveCollapse(amplitudes : [Float], measurement : Nat) : [Float] {
    Array.tabulate<Float>(amplitudes.size(), func(i : Nat) : Float {
      if (i == measurement) { 1.0 } else { 0.0 }
    })
  };

  /// Probability current
  public func quantumProbabilityCurrent(psi1 : Float, psi2 : Float, momentum : Float, mass : Float) : Float {
    (psi1 * psi2 * momentum) / mass
  };

}
