// ============================================================
// NEUROEMERGENCE CORE — LYAPUNOV STABILITY ENGINE
// 5-component stability with coherence attractors
// V(t) = Σᵢ wᵢ(xᵢ - x̄ᵢ)² + cross-term penalties
// dV/dt < 0 ⟹ stable (asymptotic convergence to attractor)
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Types ─────────────────────────────────────────────────────
  public type LyapunovState = {
    // 5 core state variables
    coherenceC     : Float;  // x₁: global coherence
    entropy        : Float;  // x₂: observational entropy H_obs
    arousal        : Float;  // x₃: arousal level
    stability      : Float;  // x₄: structural stability
    emergence      : Float;  // x₅: emergence score

    // Attractor targets (homeostatic equilibrium)
    targetC        : Float;  // x̄₁
    targetH        : Float;  // x̄₂
    targetA        : Float;  // x̄₃
    targetS        : Float;  // x̄₄
    targetE        : Float;  // x̄₅

    // Lyapunov function value
    lyapunovV      : Float;
    lyapunovDot    : Float;  // dV/dt

    // Weights for each component
    weights        : [Float];

    // History for derivative estimation
    vHistory       : [Float];
    beatNum        : Nat;

    // Stability classification
    stableBeats    : Nat;    // consecutive beats with dV/dt < 0
    unstableBeats  : Nat;    // consecutive beats with dV/dt > 0
    isAsymptotic   : Bool;   // true if converging to attractor
  };

  // ── Constants ─────────────────────────────────────────────────
  public let DEFAULT_WEIGHTS : [Float] = [
    0.35,  // coherence weight (highest priority)
    0.20,  // entropy weight
    0.15,  // arousal weight
    0.15,  // stability weight
    0.15   // emergence weight
  ];

  public let DEFAULT_TARGETS : [Float] = [
    0.75,  // target coherence
    6.0,   // target entropy (bits, ~12 max)
    0.50,  // target arousal
    0.85,  // target stability
    0.70   // target emergence
  ];

  // ── Clamp helper ──────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── Lyapunov function V ───────────────────────────────────────
  // V = Σᵢ wᵢ(xᵢ - x̄ᵢ)² + λ·cross_terms
  // Cross-terms penalize coherence-entropy anti-correlation
  public func computeV(state: LyapunovState) : Float {
    let dC = state.coherenceC - state.targetC;
    let dH = (state.entropy / 12.0) - (state.targetH / 12.0);  // normalize
    let dA = state.arousal - state.targetA;
    let dS = state.stability - state.targetS;
    let dE = state.emergence - state.targetE;

    // Quadratic terms
    let v1 = state.weights[0] * dC * dC;
    let v2 = state.weights[1] * dH * dH;
    let v3 = state.weights[2] * dA * dA;
    let v4 = state.weights[3] * dS * dS;
    let v5 = state.weights[4] * dE * dE;

    // Cross-term: penalize low coherence + high entropy
    let crossCH = 0.1 * (1.0 - state.coherenceC) * (state.entropy / 12.0);
    // Cross-term: penalize high arousal + low stability
    let crossAS = 0.1 * state.arousal * (1.0 - state.stability);

    v1 + v2 + v3 + v4 + v5 + crossCH + crossAS
  };

  // ── Lyapunov derivative estimate ──────────────────────────────
  // dV/dt ≈ (V(t) - V(t-1)) / dt
  func estimateVDot(current: Float, history: [Float]) : Float {
    if (history.size() == 0) { return 0.0 };
    let prev = history[history.size() - 1];
    current - prev
  };

  // ── Beat update ───────────────────────────────────────────────
  public func beatLyapunov(
    state: LyapunovState,
    newC: Float, newH: Float, newA: Float, newS: Float, newE: Float
  ) : LyapunovState {
    let updated : LyapunovState = {
      coherenceC = newC;
      entropy    = newH;
      arousal    = newA;
      stability  = newS;
      emergence  = newE;
      targetC    = state.targetC;
      targetH    = state.targetH;
      targetA    = state.targetA;
      targetS    = state.targetS;
      targetE    = state.targetE;
      lyapunovV  = 0.0;  // computed below
      lyapunovDot = 0.0;
      weights    = state.weights;
      vHistory   = state.vHistory;
      beatNum    = state.beatNum + 1;
      stableBeats = state.stableBeats;
      unstableBeats = state.unstableBeats;
      isAsymptotic = state.isAsymptotic;
    };

    let newV   = computeV(updated);
    let newDot = estimateVDot(newV, state.vHistory);

    // Update history (circular buffer of 100)
    let newHistory = if (state.vHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i) { state.vHistory[i + 1] });
      Array.append<Float>(tail, [newV])
    } else {
      Array.append<Float>(state.vHistory, [newV])
    };

    // Stability tracking
    let (newStable, newUnstable) = if (newDot < -0.001) {
      (state.stableBeats + 1, 0)  // converging
    } else if (newDot > 0.001) {
      (0, state.unstableBeats + 1)  // diverging
    } else {
      (state.stableBeats, state.unstableBeats)  // equilibrium
    };

    let isAsymp = newStable >= 10 and newV < 0.1;

    {
      coherenceC = newC;
      entropy    = newH;
      arousal    = newA;
      stability  = newS;
      emergence  = newE;
      targetC    = state.targetC;
      targetH    = state.targetH;
      targetA    = state.targetA;
      targetS    = state.targetS;
      targetE    = state.targetE;
      lyapunovV  = newV;
      lyapunovDot = newDot;
      weights    = state.weights;
      vHistory   = newHistory;
      beatNum    = state.beatNum + 1;
      stableBeats = newStable;
      unstableBeats = newUnstable;
      isAsymptotic = isAsymp;
    }
  };

  // ── Adaptive target adjustment ────────────────────────────────
  // Organism learns its own optimal attractor based on performance
  public func adaptTargets(
    state: LyapunovState, performanceSignal: Float, adaptRate: Float
  ) : LyapunovState {
    // If performing well, shift targets toward current state
    // If performing poorly, shift targets away from current state
    let sign = if (performanceSignal > 0.5) { 1.0 } else { -1.0 };
    let delta = adaptRate * sign;

    {
      coherenceC = state.coherenceC;
      entropy    = state.entropy;
      arousal    = state.arousal;
      stability  = state.stability;
      emergence  = state.emergence;
      targetC    = _clamp(state.targetC + delta * (state.coherenceC - state.targetC), 0.3, 0.95);
      targetH    = _clamp(state.targetH + delta * (state.entropy - state.targetH), 2.0, 10.0);
      targetA    = _clamp(state.targetA + delta * (state.arousal - state.targetA), 0.2, 0.8);
      targetS    = _clamp(state.targetS + delta * (state.stability - state.targetS), 0.5, 0.95);
      targetE    = _clamp(state.targetE + delta * (state.emergence - state.targetE), 0.4, 0.9);
      lyapunovV  = state.lyapunovV;
      lyapunovDot = state.lyapunovDot;
      weights    = state.weights;
      vHistory   = state.vHistory;
      beatNum    = state.beatNum;
      stableBeats = state.stableBeats;
      unstableBeats = state.unstableBeats;
      isAsymptotic = state.isAsymptotic;
    }
  };

  // ── Stability classification ──────────────────────────────────
  public type StabilityClass = {
    #AsymptoticStable;   // dV/dt < 0 consistently, V → 0
    #MarginallyStable;   // dV/dt ≈ 0, bounded oscillation
    #Unstable;           // dV/dt > 0, diverging
    #LimitCycle;         // periodic oscillation around attractor
    #ChaosEdge;          // edge of chaos (high entropy, low V variance)
  };

  public func classifyStability(state: LyapunovState) : StabilityClass {
    if (state.isAsymptotic) {
      return #AsymptoticStable;
    };
    if (state.unstableBeats > 20) {
      return #Unstable;
    };
    if (state.vHistory.size() >= 20) {
      // Check for limit cycle (periodic V)
      var variance : Float = 0.0;
      var mean : Float = 0.0;
      let n = state.vHistory.size();
      for (v in state.vHistory.vals()) { mean += v };
      mean /= Float.fromInt(n);
      for (v in state.vHistory.vals()) {
        let d = v - mean;
        variance += d * d;
      };
      variance /= Float.fromInt(n);

      if (variance > 0.01 and variance < 0.1) {
        return #LimitCycle;
      };
      if (state.entropy > 9.0 and variance < 0.01) {
        return #ChaosEdge;
      };
    };
    #MarginallyStable
  };

  // ── Distance to attractor ─────────────────────────────────────
  public func distanceToAttractor(state: LyapunovState) : Float {
    Float.sqrt(state.lyapunovV)
  };

  // ── Convergence rate estimate ─────────────────────────────────
  // λ ≈ -dV/dt / (2V) when V > 0
  public func convergenceRate(state: LyapunovState) : Float {
    if (state.lyapunovV < 0.001) { return 0.0 };
    -state.lyapunovDot / (2.0 * state.lyapunovV)
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initLyapunov() : LyapunovState {
    {
      coherenceC = 0.5;
      entropy    = 6.0;
      arousal    = 0.5;
      stability  = 0.5;
      emergence  = 0.5;
      targetC    = DEFAULT_TARGETS[0];
      targetH    = DEFAULT_TARGETS[1];
      targetA    = DEFAULT_TARGETS[2];
      targetS    = DEFAULT_TARGETS[3];
      targetE    = DEFAULT_TARGETS[4];
      lyapunovV  = 0.0;
      lyapunovDot = 0.0;
      weights    = DEFAULT_WEIGHTS;
      vHistory   = [];
      beatNum    = 0;
      stableBeats = 0;
      unstableBeats = 0;
      isAsymptotic = false;
    }
  };

  // ── Summarize stability health ────────────────────────────────
  public type LyapunovSummary = {
    currentV      : Float;
    currentDot    : Float;
    distToAttract : Float;
    convRate      : Float;
    stability     : StabilityClass;
    stableBeats   : Nat;
    isHealthy     : Bool;
  };

  public func summary(state: LyapunovState) : LyapunovSummary {
    let stab = classifyStability(state);
    let healthy = switch (stab) {
      case (#AsymptoticStable) { true };
      case (#MarginallyStable) { true };
      case (#LimitCycle) { true };
      case _ { false };
    };
    {
      currentV      = state.lyapunovV;
      currentDot    = state.lyapunovDot;
      distToAttract = distanceToAttractor(state);
      convRate      = convergenceRate(state);
      stability     = stab;
      stableBeats   = state.stableBeats;
      isHealthy     = healthy;
    }
  };

}
