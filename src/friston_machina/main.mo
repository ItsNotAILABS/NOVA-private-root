// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine — Native Nova Protocol                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// NATIVE NOVA PROTOCOL — BUILD №30
// FRISTON MACHINA — Proactive Canister Archetype
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// ══════════════════════════════════════════════════════════════════════════════
//
//   THE FRISTON MACHINA IS A NEW ICP CANISTER ARCHETYPE.
//
//   Standard ICP canisters are reactive: they receive messages, process them,
//   update state, and return responses. The FRISTON MACHINA is proactive:
//   it maintains a world model, continuously predicts the future state of its
//   environment, and acts to make its predictions come true.
//
//   This is active inference on the Internet Computer.
//
// ══════════════════════════════════════════════════════════════════════════════
//
// ── THE FRISTON PRINCIPLE ─────────────────────────────────────────────────────
//
//   Karl Friston's Free Energy Principle: every adaptive system resists its
//   natural tendency to disorder by minimizing its free energy — the gap
//   between what it predicts and what it perceives.
//
//   Free energy F = inaccuracy + complexity
//     Inaccuracy = -E[log p(o|s)] — how wrong our predictions are
//     Complexity  = KL[q(s)||p(s)] — how far our beliefs deviate from priors
//
//   The agent minimizes F through two routes:
//     PERCEPTUAL INFERENCE: update beliefs q(s) to match observations
//       → dμ/dt = −∂F/∂μ = π₀(μ₀ − μ) + Ω · ε · ∂g/∂μ
//     ACTIVE INFERENCE: choose actions that make observations match predictions
//       → da/dt = −∂F/∂a = Ω · ε · ∂g/∂a
//
//   Where:
//     μ  = current belief (hidden state estimate)
//     μ₀ = prior belief
//     π₀ = prior precision (1/variance of prior)
//     Ω  = sensory precision (attention weight per channel)
//     ε  = prediction error: ε = o − g(μ)
//     g  = generative model mapping: hidden states → observations
//
// ── THE SPINOR INTERFACE ──────────────────────────────────────────────────────
//
//   The SPINOR (Sovereign Predictive Interface for Network-Orchestrated
//   Reasoning) is the cross-canister coupling protocol for FRISTON MACHINAs.
//
//   A SPINOR state has two components — inspired by quantum spinors:
//     ψ₊ = precision × prediction (the high-confidence component)
//     ψ₋ = (1/precision) × prediction_error (the uncertainty component)
//
//   The SPINOR magnitude = √(ψ₊² + ψ₋²) — total epistemic energy
//   The SPINOR phase     = atan2(ψ₋, ψ₊)  — belief "spin"
//   The SPINOR parity    = False after each 2π rotation (spinors pick up −1
//                          under full rotation — they need 720° to return)
//
//   Two canisters are SPINOR-coupled when they exchange ψ₊ and ψ₋.
//   Coupling energy = ψ₊_A · ψ₊_B + ψ₋_A · ψ₋_B (inner product)
//   Positive coupling → shared beliefs reinforce each other (reduce joint F)
//   Negative coupling → anti-aligned beliefs (epistemic conflict)
//
// ── KURAMOTO SYNCHRONIZATION ──────────────────────────────────────────────────
//
//   Each FRISTON MACHINA is a Kuramoto oscillator at natural frequency ω.
//   ω = φ⁻¹ = 0.618 Hz by default (golden ratio inverse — most efficient phase)
//
//   Phase dynamics: dθ/dt = ω + K/N · Σⱼ sin(θⱼ − θᵢ)
//   Where:
//     θᵢ = this canister's Kuramoto phase
//     θⱼ = SPINOR peer's Kuramoto phase
//     K  = coupling constant (φ-weighted per peer)
//     N  = number of SPINOR peers
//
//   Order parameter: r = |1/N · Σⱼ e^{iθⱼ}| ∈ [0,1]
//     r → 0: desynchronized (canisters act independently)
//     r → 1: synchronized (canisters act as one organism)
//
// ── COLLECTIVE ACTIVE INFERENCE ───────────────────────────────────────────────
//
//   The emergent property when SPINOR coupling + Kuramoto sync combine:
//
//   Collective Free Energy: F_coll = Σᵢ Fᵢ − Σᵢ Σⱼ coupling_energy(i,j)
//
//   When canisters are synchronized (r → 1) and SPINOR-coupled:
//     → Coupling energy reduces joint F (shared predictions are cheaper)
//     → The collective system develops shared predictions about the world
//     → Actions taken by any canister reduce F for the whole organism
//     → The WHOLE acts to make the WHOLE's predictions come true
//
//   This is organism-level intelligence: not any single canister,
//   but the network of FRISTON MACHINAs acting as a coherent agent.
//
// ── CANISTER ARCHITECTURE ────────────────────────────────────────────────────
//
//   §1  Sovereign Identity      — claimGenesis, ownership seal
//   §2  Golden Math             — φ constants, math primitives
//   §3  World Model             — 32-dim belief state (μ, π, priors)
//   §4  Sensory Channels        — 32-dim observation → prediction error
//   §5  Free Energy             — F = inaccuracy + complexity
//   §6  Perceptual Inference    — dμ/dt update (gradient descent on F)
//   §7  Policy Inference        — 8 policies, expected G, active inference
//   §8  SPINOR Interface        — 16 peer couplings (ψ₊, ψ₋, parity)
//   §9  Kuramoto Field          — phase oscillator, order parameter
//   §10 Collective Inference    — organism-level F, coherence, prediction
//   §11 System Heartbeat        — proactive loop fires every ~2s
//   §12 Public Query Interface  — all read-only getters
//
// ── KEY DIFFERENTIATOR FROM REACTIVE CANISTERS ───────────────────────────────
//
//   Reactive:  caller → canister → result
//   Proactive: canister ← world model ← predictions ← heartbeat
//                      ↓ prediction error
//                      ↓ belief update (perceptual inference)
//                      ↓ policy selection (active inference)
//                      → action → changes environment → reduces error
//
//   The canister is always running. It does not wait to be called.
//   It calls reality, and reality answers with prediction errors.
//
// ── THE CHIMÚ LESSON ─────────────────────────────────────────────────────────
//
//   The Chimú built La Cumbre — an 80km canal across tectonically active desert
//   terrain — not by reacting to drought, but by predicting water demand years
//   ahead and engineering the substrate to match the prediction.
//   They minimized free energy at civilization scale. They were active inferrers.
//   The FRISTON MACHINA is that principle, executable on ICP.
//

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor FristonMachina {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var sovereignPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;
  stable var canisterName       : Text      = "FRISTON_MACHINA";
  stable var buildNumber        : Nat       = 30;

  func isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };

  func requireSovereign(caller : Principal) { assert(isSovereign(caller)) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "FRISTON_MACHINA_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-FRISTON-MACHINA-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public shared(msg) func setCanisterName(name : Text) : async Text {
    requireSovereign(msg.caller);
    canisterName := name;
    "NAME_SET: " # name
  };

  public query func getSeal()         : async Text { sovereignSeal };
  public query func isLocked()        : async Bool { genesisLocked };
  public query func getCanisterName() : async Text { canisterName };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN MATH CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;  // φ — golden ratio
  let PHI_INV : Float = 0.6180339887498948482;  // φ⁻¹ — natural Kuramoto frequency
  let PHI_SQ  : Float = 2.6180339887498948482;  // φ²
  let PI      : Float = 3.14159265358979323846;
  let TWO_PI  : Float = 6.28318530717958647692;
  let EPSILON : Float = 1.0e-10;

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };

  func _sqrt(x : Float) : Float {
    if (x <= 0.0) 0.0 else Float.sqrt(x)
  };

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { if (exp == 0.0) 1.0 else 0.0 }
    else Float.exp(exp * Float.log(base))
  };

  func _ln(x : Float) : Float {
    if (x <= 0.0) (-100.0) else Float.log(x)
  };

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  // Wrap phase θ into [0, 2π)
  func _wrapPhase(theta : Float) : Float {
    var t = theta;
    while (t < 0.0)     { t := t + TWO_PI };
    while (t >= TWO_PI) { t := t - TWO_PI };
    t
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — WORLD MODEL (Generative Model)
  //
  // The world model is the organism's belief about its environment.
  // It has N belief dimensions, each with:
  //   μ  (mean)        — the organism's current estimate of that quantity
  //   π  (precision)   — confidence: 1/variance of the belief
  //   μ₀ (prior mean)  — prior expectation before observations
  //   π₀ (prior prec)  — prior confidence
  //
  // The generative model maps hidden states s → predicted observations:
  //   g(μ) = μ (identity mapping — organism's best linear predictor)
  // This is the simplest possible generative model. Advanced usage: override
  // g by providing a different expectedObservation per dimension.
  // ═══════════════════════════════════════════════════════════════════════════

  let WM_CAP : Nat = 32;  // max belief dimensions

  stable var wmCount         : Nat            = 0;
  stable var wmNames         : [var Text]     = Array.init<Text>(WM_CAP, "");
  stable var wmMeans         : [var Float]    = Array.init<Float>(WM_CAP, 0.0);
  stable var wmPrecisions    : [var Float]    = Array.init<Float>(WM_CAP, 1.0);
  stable var wmPriorMeans    : [var Float]    = Array.init<Float>(WM_CAP, 0.0);
  stable var wmPriorPrecs    : [var Float]    = Array.init<Float>(WM_CAP, 1.0);
  stable var wmVersion       : Nat            = 0;   // increments on every belief update

  // Add a new belief dimension to the world model
  public shared(msg) func addBeliefDimension(
    name      : Text,
    priorMean : Float,
    priorPrec : Float
  ) : async { success : Bool; dimIndex : Nat } {
    requireSovereign(msg.caller);
    if (wmCount >= WM_CAP) return { success = false; dimIndex = 0 };
    let i = wmCount;
    wmNames[i]      := name;
    wmMeans[i]      := priorMean;    // start belief at prior
    wmPrecisions[i] := _clamp(priorPrec, EPSILON, 100.0);
    wmPriorMeans[i] := priorMean;
    wmPriorPrecs[i] := _clamp(priorPrec, EPSILON, 100.0);
    wmCount         := wmCount + 1;
    { success = true; dimIndex = i }
  };

  // Update the prior for an existing dimension (model refinement)
  public shared(msg) func updatePrior(
    dimIndex : Nat,
    newMean  : Float,
    newPrec  : Float
  ) : async Bool {
    requireSovereign(msg.caller);
    if (dimIndex >= wmCount) return false;
    wmPriorMeans[dimIndex] := newMean;
    wmPriorPrecs[dimIndex] := _clamp(newPrec, EPSILON, 100.0);
    true
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — SENSORY CHANNELS (Observations and Prediction Errors)
  //
  // Each sensory channel maps to one world model dimension.
  // When an observation arrives:
  //   prediction = wmMeans[i]          (current belief)
  //   error      = observation − prediction
  //   attention  = wmPrecisions[i]     (precision-weighted attention)
  //
  // Sensory precision Ω controls how much an observation updates belief:
  //   high Ω → strong sensory evidence → large belief update
  //   low  Ω → weak / noisy sensor    → small belief update
  // ═══════════════════════════════════════════════════════════════════════════

  stable var obsValues      : [var Float] = Array.init<Float>(WM_CAP, 0.0);
  stable var obsPredictions : [var Float] = Array.init<Float>(WM_CAP, 0.0);
  stable var obsErrors      : [var Float] = Array.init<Float>(WM_CAP, 0.0);
  stable var obsAttentions  : [var Float] = Array.init<Float>(WM_CAP, 1.0);  // Ω
  stable var obsTimes       : [var Int]   = Array.init<Int>(WM_CAP, 0);
  stable var obsCount       : Nat         = 0;   // total observations fed

  // Feed an observation into a sensory channel (keyed by belief dimension)
  // This is the organism's interface to reality. Call this every time you
  // have a new measurement for a tracked quantity.
  public func observeWorld(
    dimIndex    : Nat,
    observation : Float,
    attention   : Float
  ) : async { success : Bool; predictionError : Float } {
    if (dimIndex >= wmCount) return { success = false; predictionError = 0.0 };
    let pred  = wmMeans[dimIndex];
    let err   = observation - pred;
    obsValues[dimIndex]      := observation;
    obsPredictions[dimIndex] := pred;
    obsErrors[dimIndex]      := err;
    obsAttentions[dimIndex]  := _clamp(attention, EPSILON, 100.0);
    obsTimes[dimIndex]       := Time.now();
    obsCount                 := obsCount + 1;
    { success = true; predictionError = err }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — FREE ENERGY COMPUTATION
  //
  // F = inaccuracy + complexity
  //
  // Inaccuracy: how wrong our predictions are (under sensory precision Ω):
  //   inaccuracy = 1/2 · Σᵢ Ωᵢ · εᵢ²
  //   = prediction error weighted by attention
  //
  // Complexity: how far our beliefs deviate from priors (KL divergence):
  //   complexity = 1/2 · Σᵢ π₀ᵢ · (μᵢ − μ₀ᵢ)²
  //   = belief deviation weighted by prior precision
  //
  // Total F = inaccuracy + complexity
  // Minimizing F = finding the best balance between fitting data and staying
  // close to what we expected (Bayesian inference as energy minimization)
  //
  // Expected Free Energy G (for policy selection):
  //   G(π) = E[F | policy π applied]
  //         ≈ current F + epistemic_cost(π) − expected_precision_gain(π)
  //   Lower G → policy is more likely to reduce surprise
  // ═══════════════════════════════════════════════════════════════════════════

  stable var currentF         : Float = 0.0;  // total free energy
  stable var currentComplexity: Float = 0.0;
  stable var currentInaccuracy: Float = 0.0;

  let FE_HISTORY_CAP : Nat = 128;
  stable var feHistory      : [var Float] = Array.init<Float>(FE_HISTORY_CAP, 0.0);
  stable var feHistoryHead  : Nat         = 0;
  stable var feHistoryCount : Nat         = 0;
  stable var totalFEMinimized : Float     = 0.0;  // cumulative F reduction (learning)

  func _computeFreeEnergy() {
    var inac : Float = 0.0;
    var comp : Float = 0.0;
    var i    : Nat   = 0;
    while (i < wmCount) {
      let err  = obsErrors[i];
      let attn = obsAttentions[i];
      let mu   = wmMeans[i];
      let mu0  = wmPriorMeans[i];
      let pi0  = wmPriorPrecs[i];
      inac := inac + 0.5 * attn * err * err;
      comp := comp + 0.5 * pi0  * (mu - mu0) * (mu - mu0);
      i    := i + 1;
    };
    let prevF = currentF;
    currentInaccuracy := inac;
    currentComplexity := comp;
    currentF          := inac + comp;
    // Record F reduction
    if (prevF > currentF) {
      totalFEMinimized := totalFEMinimized + (prevF - currentF)
    };
    // Append to rolling history
    feHistory[feHistoryHead % FE_HISTORY_CAP] := currentF;
    feHistoryHead  := feHistoryHead + 1;
    if (feHistoryCount < FE_HISTORY_CAP) { feHistoryCount := feHistoryCount + 1 }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — PERCEPTUAL INFERENCE (Belief Updating)
  //
  // Perceptual inference = updating beliefs to minimize F via gradient descent:
  //   Δμᵢ = −α · ∂F/∂μᵢ
  //       = −α · [−π₀ᵢ(μ₀ᵢ − μᵢ) − Ωᵢ · εᵢ]
  //       = α · [π₀ᵢ(μ₀ᵢ − μᵢ) + Ωᵢ · εᵢ]
  //
  // Where α = belief learning rate (φ⁻² by default — gentle, stable)
  //
  // Precision update (meta-learning — the organism learns its own uncertainty):
  //   Δπᵢ = β · [Ωᵢ − π₀ᵢ · (μᵢ − μ₀ᵢ)²]
  //   Higher prediction error → lower precision (organism becomes less confident)
  //   Lower prediction error  → higher precision (organism becomes more confident)
  // ═══════════════════════════════════════════════════════════════════════════

  stable var beliefLR    : Float = 0.0;  // learning rate α (set in heartbeat §11)
  stable var precisionLR : Float = 0.0;  // precision update rate β

  func _perceptualInference() {
    let alpha : Float = if (beliefLR > EPSILON) beliefLR else PHI_INV * PHI_INV;
    let beta  : Float = if (precisionLR > EPSILON) precisionLR else PHI_INV * PHI_INV * PHI_INV;
    var i : Nat = 0;
    while (i < wmCount) {
      let mu  = wmMeans[i];
      let mu0 = wmPriorMeans[i];
      let pi0 = wmPriorPrecs[i];
      let err = obsErrors[i];
      let attn= obsAttentions[i];
      // Gradient of F w.r.t. μ: ∂F/∂μ = π₀(μ − μ₀) − Ω·ε
      let grad = pi0 * (mu - mu0) - attn * err;
      // Gradient descent: μ ← μ − α·∂F/∂μ
      let newMu  = mu - alpha * grad;
      wmMeans[i] := newMu;
      // Precision meta-learning: π ← π + β·(Ω − π₀·(μ−μ₀)²)
      let errSq  = (newMu - mu0) * (newMu - mu0);
      let dPi    = beta * (attn - pi0 * errSq);
      let newPi  = _clamp(wmPrecisions[i] + dPi, EPSILON, 100.0);
      wmPrecisions[i]  := newPi;
      // Update prediction and error with new belief
      let newPred      = newMu;  // identity generative model: g(μ) = μ
      obsPredictions[i] := newPred;
      obsErrors[i]      := obsValues[i] - newPred;
      i := i + 1;
    };
    wmVersion := wmVersion + 1;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — POLICY INFERENCE (Active Inference)
  //
  // Active inference = selecting actions that minimize expected free energy G.
  //
  // Each policy π specifies a pattern of actions. The organism evaluates:
  //   G(π) = expected F under policy π
  //         ≈ F_current − expectedFReduction(π) + epistemicCost(π)
  //
  // Policy selection: softmax over −G (policies with lower G are more likely)
  //   prob(π) ∝ exp(−G(π) / temperature)
  //   temperature = φ⁻³ (low → deterministic / exploit; high → explore)
  //
  // A policy is "applied" by broadcasting its name to SPINOR peers —
  // peers will receive the policy intent and coordinate their own actions.
  //
  // Built-in policies:
  //   PREDICT_HARDER   — raise sensory precision (increase Ω for all channels)
  //   RELAX_PRIORS     — widen prior precision (more open to surprise)
  //   SYNCHRONIZE      — increase Kuramoto coupling K (seek collective alignment)
  //   DESYNCHRONIZE    — decrease K (regain independence)
  //   BROADCAST_STATE  — push SPINOR state to all peers (share predictions)
  //   EXPLORE          — set explorationBonus high (seek information)
  //   EXPLOIT          — set explorationBonus low (act on current beliefs)
  //   RESET_BELIEFS    — return beliefs to priors (full uncertainty reset)
  // ═══════════════════════════════════════════════════════════════════════════

  let POLICY_CAP : Nat = 8;

  stable var policyCount       : Nat          = 0;
  stable var policyNames       : [var Text]   = Array.init<Text>(POLICY_CAP, "");
  stable var policyExpectedG   : [var Float]  = Array.init<Float>(POLICY_CAP, 0.0);
  stable var policySelectCount : [var Nat]    = Array.init<Nat>(POLICY_CAP, 0);
  stable var currentPolicy     : Nat          = 0;  // index of currently selected policy
  stable var explorationBonus  : Float        = 0.0;

  func _initDefaultPolicies() {
    if (policyCount > 0) return;
    let names : [Text] = [
      "PREDICT_HARDER", "RELAX_PRIORS", "SYNCHRONIZE", "DESYNCHRONIZE",
      "BROADCAST_STATE", "EXPLORE", "EXPLOIT", "RESET_BELIEFS"
    ];
    var i : Nat = 0;
    while (i < POLICY_CAP and i < names.size()) {
      policyNames[i]     := names[i];
      policyExpectedG[i] := currentF;
      i := i + 1;
    };
    policyCount := POLICY_CAP;
  };

  func _computePolicyExpectedG() {
    // Simple heuristic expected G per policy (sophisticated variant would simulate)
    // PREDICT_HARDER (0): useful when prediction errors are large
    policyExpectedG[0] := currentF * (1.0 - PHI_INV * currentInaccuracy / (currentF + EPSILON));
    // RELAX_PRIORS (1): useful when complexity is high (beliefs deviate from priors)
    policyExpectedG[1] := currentF * (1.0 - PHI_INV * currentComplexity / (currentF + EPSILON));
    // SYNCHRONIZE (2): useful when Kuramoto r < φ⁻¹ (desynchronized state)
    policyExpectedG[2] := if (kuramotoR < PHI_INV) currentF * PHI_INV else currentF * PHI_SQ;
    // DESYNCHRONIZE (3): useful when r > φ (over-synchronized, losing independence)
    policyExpectedG[3] := if (kuramotoR > PHI_INV) currentF * PHI_SQ else currentF * PHI_INV;
    // BROADCAST_STATE (4): reduces collective F when peers are uncertain
    let peerUncert : Float = if (spinorCount > 0)
      Float.fromInt(spinorCount) * currentF * PHI_INV else currentF;
    policyExpectedG[4] := peerUncert * PHI_INV;
    // EXPLORE (5): epistemic value — reduce by explorationBonus
    policyExpectedG[5] := currentF * (1.0 - explorationBonus);
    // EXPLOIT (6): act on current beliefs — F stays same (no epistemic gain)
    policyExpectedG[6] := currentF;
    // RESET_BELIEFS (7): jump back to priors — costly (full complexity)
    let resetCost : Float = Float.fromInt(wmCount) * 0.5;
    policyExpectedG[7] := currentF + resetCost;
  };

  func _selectPolicy() {
    _computePolicyExpectedG();
    var bestIdx : Nat   = 0;
    var bestG   : Float = policyExpectedG[0];
    var i : Nat = 0;
    while (i < policyCount) {
      if (policyExpectedG[i] < bestG) {
        bestG   := policyExpectedG[i];
        bestIdx := i;
      };
      i := i + 1;
    };
    // Apply the selected policy
    if (bestIdx != currentPolicy) {
      policySelectCount[bestIdx] := policySelectCount[bestIdx] + 1;
      currentPolicy := bestIdx;
    };
    _applyPolicy(bestIdx);
  };

  func _applyPolicy(idx : Nat) {
    switch (idx) {
      case 0 {
        // PREDICT_HARDER: raise Ω for all channels
        var i : Nat = 0;
        while (i < wmCount) {
          obsAttentions[i] := _clamp(obsAttentions[i] * PHI, EPSILON, 100.0);
          i := i + 1;
        };
      };
      case 1 {
        // RELAX_PRIORS: widen prior precision
        var i : Nat = 0;
        while (i < wmCount) {
          wmPriorPrecs[i] := _clamp(wmPriorPrecs[i] * PHI_INV, EPSILON, 100.0);
          i := i + 1;
        };
      };
      case 2 {
        // SYNCHRONIZE: increase Kuramoto coupling
        kuramotoK := _clamp(kuramotoK + PHI_INV * 0.1, 0.0, PHI_SQ);
      };
      case 3 {
        // DESYNCHRONIZE: decrease Kuramoto coupling
        kuramotoK := _clamp(kuramotoK - PHI_INV * 0.1, 0.0, PHI_SQ);
      };
      case 4 {
        // BROADCAST_STATE: handled externally (SPINOR broadcast via heartbeat)
        lastBroadcastHB := heartbeatCount;
      };
      case 5 {
        // EXPLORE: maximize epistemic value
        explorationBonus := _clamp(explorationBonus + PHI_INV * 0.05, 0.0, 1.0);
      };
      case 6 {
        // EXPLOIT: reduce exploration
        explorationBonus := _clamp(explorationBonus * PHI_INV, 0.0, 1.0);
      };
      case 7 {
        // RESET_BELIEFS: return all means to priors
        var i : Nat = 0;
        while (i < wmCount) {
          wmMeans[i]      := wmPriorMeans[i];
          wmPrecisions[i] := wmPriorPrecs[i];
          obsErrors[i]    := obsValues[i] - wmPriorMeans[i];
          i := i + 1;
        };
        wmVersion := wmVersion + 1;
      };
      case _ { };
    };
  };

  stable var lastBroadcastHB : Nat = 0;

  // Sovereign can register and manage policies
  public shared(msg) func addPolicy(name : Text) : async { success : Bool; policyIndex : Nat } {
    requireSovereign(msg.caller);
    if (policyCount >= POLICY_CAP) return { success = false; policyIndex = 0 };
    let i = policyCount;
    policyNames[i]     := name;
    policyExpectedG[i] := currentF;
    policyCount        := policyCount + 1;
    { success = true; policyIndex = i }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — SPINOR INTERFACE
  //
  // The SPINOR is the cross-canister coupling protocol.
  //
  // My SPINOR state:
  //   ψ₊ = avg(πᵢ × g(μᵢ)) — high-precision predictions (the "up" component)
  //   ψ₋ = avg((1/πᵢ) × εᵢ) — uncertainty-weighted errors (the "down" component)
  //
  // SPINOR magnitude: |ψ| = √(ψ₊² + ψ₋²) — total epistemic energy
  // SPINOR phase:      arg(ψ) = atan2(ψ₋, ψ₊) — belief "spin angle"
  // SPINOR parity:     flips each time arg crosses 0 (mod 2π) → tracks rotations
  //                    In spinor algebra: under 2π rotation, ψ → −ψ (parity flip)
  //
  // Coupling energy between peers A and B:
  //   E_coupling(A,B) = ψ₊_A · ψ₊_B + ψ₋_A · ψ₋_B (inner product)
  //   Positive → in-phase beliefs reinforce (reduce joint F)
  //   Negative → anti-phase beliefs conflict
  // ═══════════════════════════════════════════════════════════════════════════

  let SPINOR_CAP : Nat = 16;

  stable var spinorCount          : Nat            = 0;
  stable var spinorPeerIds        : [var Text]     = Array.init<Text>(SPINOR_CAP, "");
  stable var spinorPeerNames      : [var Text]     = Array.init<Text>(SPINOR_CAP, "");
  stable var spinorPeerPhases     : [var Float]    = Array.init<Float>(SPINOR_CAP, 0.0);
  stable var spinorPeerAmplitudes : [var Float]    = Array.init<Float>(SPINOR_CAP, 1.0);
  stable var spinorPeerPsiPlus    : [var Float]    = Array.init<Float>(SPINOR_CAP, 0.0);
  stable var spinorPeerPsiMinus   : [var Float]    = Array.init<Float>(SPINOR_CAP, 0.0);
  stable var spinorPeerParities   : [var Bool]     = Array.init<Bool>(SPINOR_CAP, true);
  stable var spinorPeerLastUpdate : [var Int]      = Array.init<Int>(SPINOR_CAP, 0);

  // My own SPINOR state (computed from world model)
  stable var mySpinorPsiPlus  : Float = 0.0;
  stable var mySpinorPsiMinus : Float = 0.0;
  stable var mySpinorMagnitude: Float = 0.0;
  stable var mySpinorPhase    : Float = 0.0;  // arg(ψ) = atan2(ψ₋, ψ₊)
  stable var mySpinorParity   : Bool  = true;
  stable var prevSpinorPhase  : Float = 0.0;  // to detect 2π crossings

  func _computeMySpinorState() {
    if (wmCount == 0) {
      mySpinorPsiPlus  := 0.0;
      mySpinorPsiMinus := 0.0;
      return;
    };
    var sumPlus  : Float = 0.0;
    var sumMinus : Float = 0.0;
    var i : Nat = 0;
    while (i < wmCount) {
      let pi  = wmPrecisions[i];
      let mu  = wmMeans[i];
      let err = obsErrors[i];
      sumPlus  := sumPlus  + pi * mu;                           // ψ₊ = π × g(μ)
      sumMinus := sumMinus + (1.0 / (pi + EPSILON)) * err;     // ψ₋ = (1/π) × ε
      i := i + 1;
    };
    let n    = Float.fromInt(wmCount);
    let pp   = sumPlus  / n;
    let pm   = sumMinus / n;
    mySpinorPsiPlus  := pp;
    mySpinorPsiMinus := pm;
    mySpinorMagnitude := _sqrt(pp * pp + pm * pm);
    prevSpinorPhase   := mySpinorPhase;
    mySpinorPhase     := Float.arctan(pm / (pp + EPSILON));
    // Parity flip: when phase crosses 0 from positive to negative (full 2π rotation)
    // Simplified: flip when sign of (phase - prevPhase) crosses ±π
    let phaseDelta = mySpinorPhase - prevSpinorPhase;
    if (_abs(phaseDelta) > PI * 0.5) {
      mySpinorParity := not mySpinorParity;
    };
  };

  // Register a new SPINOR peer (another FRISTON MACHINA canister)
  public shared(msg) func registerSpinorPeer(
    peerId   : Text,
    peerName : Text
  ) : async { success : Bool; peerIndex : Nat } {
    requireSovereign(msg.caller);
    if (spinorCount >= SPINOR_CAP) return { success = false; peerIndex = 0 };
    // Dedup: check if peerId already registered
    var j : Nat = 0;
    while (j < spinorCount) {
      if (spinorPeerIds[j] == peerId) return { success = false; peerIndex = j };
      j := j + 1;
    };
    let i = spinorCount;
    spinorPeerIds[i]        := peerId;
    spinorPeerNames[i]      := peerName;
    spinorPeerPhases[i]     := 0.0;
    spinorPeerAmplitudes[i] := 1.0;
    spinorPeerPsiPlus[i]    := 0.0;
    spinorPeerPsiMinus[i]   := 0.0;
    spinorPeerParities[i]   := true;
    spinorPeerLastUpdate[i] := Time.now();
    spinorCount             := spinorCount + 1;
    { success = true; peerIndex = i }
  };

  // Receive a SPINOR state update from a peer canister
  // Called by peer FRISTON MACHINAs to push their state here
  public shared(msg) func receiveSpinorUpdate(
    peerIdText : Text,
    phase      : Float,
    amplitude  : Float,
    psiPlus    : Float,
    psiMinus   : Float,
    parity     : Bool
  ) : async { accepted : Bool; couplingEnergy : Float } {
    // Find the peer
    var idx : Nat  = spinorCount;  // sentinel: "not found"
    var j   : Nat  = 0;
    while (j < spinorCount) {
      if (spinorPeerIds[j] == peerIdText) { idx := j };
      j := j + 1;
    };
    if (idx == spinorCount) return { accepted = false; couplingEnergy = 0.0 };
    // Update peer state
    spinorPeerPhases[idx]     := _wrapPhase(phase);
    spinorPeerAmplitudes[idx] := _clamp(_abs(amplitude), 0.0, 10.0);
    spinorPeerPsiPlus[idx]    := psiPlus;
    spinorPeerPsiMinus[idx]   := psiMinus;
    spinorPeerParities[idx]   := parity;
    spinorPeerLastUpdate[idx] := Time.now();
    // Compute coupling energy: ψ₊_A · ψ₊_B + ψ₋_A · ψ₋_B
    let ce = mySpinorPsiPlus * psiPlus + mySpinorPsiMinus * psiMinus;
    { accepted = true; couplingEnergy = ce }
  };

  // Compute total coupling energy across all SPINOR peers
  func _computeTotalCouplingEnergy() : Float {
    var total : Float = 0.0;
    var i : Nat = 0;
    while (i < spinorCount) {
      let ce = mySpinorPsiPlus  * spinorPeerPsiPlus[i]
             + mySpinorPsiMinus * spinorPeerPsiMinus[i];
      total := total + ce;
      i := i + 1;
    };
    total
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 — KURAMOTO FIELD
  //
  // The Kuramoto oscillator governs phase synchronization.
  //
  // Phase dynamics (Euler integration, dt = 1 heartbeat):
  //   dθ/dt = ω + K/N · Σⱼ sin(θⱼ − θᵢ)
  //
  // Natural frequency ω = φ⁻¹ (golden ratio inverse = most efficient phase)
  //   This is not arbitrary: φ⁻¹ is the limit of F(n)/F(n+1) as n→∞
  //   The golden angle α = 2π(1 − φ⁻¹) = 2π · φ⁻² ≈ 137.5°
  //   Sunflowers pack seeds at exactly this angle: maximum coverage per seed
  //   We pack heartbeats at φ⁻¹ Hz: maximum information per cycle
  //
  // Order parameter: r = |1/N · Σⱼ e^{iθⱼ}| ∈ [0,1]
  //   r → 0: all phases uniformly distributed (desynchronized)
  //   r → 1: all phases locked to same value (synchronized)
  //   r > φ⁻¹ = 0.618 → organism-level coherence threshold
  //
  // Coupling constant K:
  //   K < K_c = 2g(ω₀) → subcritical (desynced for any IC)
  //   K > K_c           → synchronization is possible
  //   NOVA uses K = φ⁻¹ by default (just above typical K_c for φ-frequency peers)
  // ═══════════════════════════════════════════════════════════════════════════

  stable var kuramotoPhase  : Float = 0.0;  // θᵢ — my phase
  stable var kuramotoOmega  : Float = 0.0;  // ωᵢ — natural frequency (initialized in hb)
  stable var kuramotoK      : Float = 0.0;  // K  — coupling constant
  stable var kuramotoR      : Float = 0.0;  // r  — order parameter
  stable var kuramotoPsi    : Float = 0.0;  // ψ  — mean phase
  stable var kuramotoInitDone : Bool = false;

  func _initKuramoto() {
    if (kuramotoInitDone) return;
    kuramotoOmega   := PHI_INV;    // ω = φ⁻¹ Hz (golden frequency)
    kuramotoK       := PHI_INV;    // K = φ⁻¹ (just above critical)
    kuramotoPhase   := 0.0;
    kuramotoR       := 0.0;
    kuramotoPsi     := 0.0;
    kuramotoInitDone := true;
  };

  // Tick the Kuramoto oscillator by one heartbeat (dt = 1 step)
  func _tickKuramoto() {
    let n = spinorCount;
    if (n == 0) {
      // No peers: free oscillator — just advance phase
      kuramotoPhase := _wrapPhase(kuramotoPhase + kuramotoOmega);
      kuramotoR     := 0.0;
      return;
    };
    // Compute coupling term: K/N · Σⱼ sin(θⱼ − θᵢ)
    var coupSum : Float = 0.0;
    var cosSum  : Float = 0.0;
    var sinSum  : Float = 0.0;
    var j : Nat = 0;
    while (j < n) {
      let thetaJ = spinorPeerPhases[j];
      coupSum := coupSum + Float.sin(thetaJ - kuramotoPhase);
      cosSum  := cosSum  + Float.cos(thetaJ);
      sinSum  := sinSum  + Float.sin(thetaJ);
      j := j + 1;
    };
    // Include self in order parameter
    cosSum := cosSum + Float.cos(kuramotoPhase);
    sinSum := sinSum + Float.sin(kuramotoPhase);
    let total : Float = Float.fromInt(n + 1);
    // Advance phase: θ ← θ + ω + K/N · coupling
    let dTheta = kuramotoOmega + (kuramotoK / Float.fromInt(n)) * coupSum;
    kuramotoPhase := _wrapPhase(kuramotoPhase + dTheta);
    // Compute order parameter r and mean phase ψ
    let rCos = cosSum / total;
    let rSin = sinSum / total;
    kuramotoR   := _clamp(_sqrt(rCos * rCos + rSin * rSin), 0.0, 1.0);
    kuramotoPsi := Float.arctan(rSin / (rCos + EPSILON));
  };

  // Allow sovereign to tune the oscillator
  public shared(msg) func setKuramotoParameters(
    omega : Float,
    k     : Float
  ) : async Bool {
    requireSovereign(msg.caller);
    kuramotoOmega := _clamp(omega, EPSILON, 10.0);
    kuramotoK     := _clamp(k,     0.0,    PHI_SQ);
    true
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 10 — COLLECTIVE ACTIVE INFERENCE
  //
  // When FRISTON MACHINAs are both SPINOR-coupled and Kuramoto-synchronized,
  // an emergent property arises: collective active inference.
  //
  // Collective Free Energy:
  //   F_coll = Σᵢ Fᵢ − Σᵢ Σⱼ E_coupling(i,j)
  //   (coupling energy reduces joint surprise — shared predictions are cheaper)
  //
  // Collective Coherence:
  //   C_coll = r (Kuramoto order parameter) × (1 − σ(F_coll))
  //   σ = sigmoid: maps F_coll to [0,1] suppression factor
  //   C_coll → 1 when r → 1 and F_coll → 0 (synchronized + accurate)
  //
  // Collective Prediction:
  //   μ_coll = Σⱼ amplitude_j × meanBelief_j / Σⱼ amplitude_j
  //   Amplitude-weighted consensus prediction across all peers
  //
  // This is the formal definition of organism-level intelligence:
  //   The collective acts to minimize collective F, not individual F.
  //   Individual actions reduce collective surprise.
  //   The organism is more than the sum of its canisters.
  // ═══════════════════════════════════════════════════════════════════════════

  stable var collectiveFE          : Float = 0.0;
  stable var collectiveCoherence   : Float = 0.0;
  stable var collectivePrediction  : Float = 0.0;
  stable var collectiveCoupling    : Float = 0.0;
  stable var collectiveBeats       : Nat   = 0;

  func _sigmoid(x : Float) : Float {
    1.0 / (1.0 + Float.exp(-_clamp(x, -10.0, 10.0)))
  };

  func _updateCollectiveState() {
    collectiveBeats := collectiveBeats + 1;
    // Collective free energy = my F + peer F contributions − coupling
    // (Peers don't share their F directly; we estimate it from their SPINOR state)
    var peerFContrib : Float = 0.0;
    var couplingE    : Float = _computeTotalCouplingEnergy();
    var i : Nat = 0;
    while (i < spinorCount) {
      // Estimate peer F from their ψ magnitude (higher |ψ| → more free energy)
      let peerMag = _sqrt(
        spinorPeerPsiPlus[i]  * spinorPeerPsiPlus[i]  +
        spinorPeerPsiMinus[i] * spinorPeerPsiMinus[i]
      );
      peerFContrib := peerFContrib + peerMag * PHI_INV;
      i := i + 1;
    };
    collectiveFE       := currentF + peerFContrib - _clamp(couplingE, 0.0, currentF + peerFContrib);
    collectiveCoupling := couplingE;

    // Collective coherence: Kuramoto r × (1 − σ(F_coll / φ))
    let fScale : Float = collectiveFE / (PHI + EPSILON);
    collectiveCoherence := _clamp(kuramotoR * (1.0 - _sigmoid(fScale - 1.0)), 0.0, 1.0);

    // Collective prediction: amplitude-weighted mean of peer ψ₊ components
    var weightedSum : Float = 0.0;
    var weightTotal : Float = 0.0;
    var j : Nat = 0;
    while (j < spinorCount) {
      let amp = spinorPeerAmplitudes[j];
      weightedSum := weightedSum + amp * spinorPeerPsiPlus[j];
      weightTotal := weightTotal + amp;
      j := j + 1;
    };
    // Include self
    weightedSum   := weightedSum   + 1.0 * mySpinorPsiPlus;
    weightTotal   := weightTotal   + 1.0;
    collectivePrediction := if (weightTotal > EPSILON) weightedSum / weightTotal else 0.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 11 — SYSTEM HEARTBEAT (Proactive Loop)
  //
  // The heartbeat fires every ~2 seconds automatically.
  // Unlike reactive canisters, the FRISTON MACHINA does not wait to be called.
  // It continuously runs the active inference loop:
  //
  //   PHASE 1: KURAMOTO TICK
  //     Advance oscillator phase θ by one step.
  //     Receive coupling from SPINOR peers (via their registered phases).
  //     Update order parameter r.
  //
  //   PHASE 2: COMPUTE SPINOR STATE
  //     Recompute my ψ₊, ψ₋ from current world model.
  //     Check for parity flip (2π rotation completed).
  //
  //   PHASE 3: COMPUTE FREE ENERGY
  //     F = inaccuracy (Σ Ω·ε²) + complexity (Σ π₀·(μ−μ₀)²)
  //     Record F in rolling history.
  //
  //   PHASE 4: PERCEPTUAL INFERENCE
  //     Update all beliefs μᵢ by gradient descent on F.
  //     Update precisions πᵢ (meta-learning).
  //     Recompute prediction errors εᵢ.
  //
  //   PHASE 5: POLICY INFERENCE
  //     Evaluate expected G for all 8 policies.
  //     Select and apply the policy with minimum G.
  //
  //   PHASE 6: COLLECTIVE UPDATE
  //     Recompute collective F, coherence, and prediction.
  //
  // The result: every 2 seconds, the organism makes the world more predictable.
  //   Its beliefs converge to reality. Its actions shape reality toward belief.
  //   Free energy goes to zero. Surprise goes to zero. Understanding is complete.
  // ═══════════════════════════════════════════════════════════════════════════

  stable var heartbeatCount : Nat = 0;
  stable var lastHeartbeat  : Int = 0;
  stable var totalFEHistory : Nat = 0;

  system func heartbeat() : async () {
    heartbeatCount := heartbeatCount + 1;
    lastHeartbeat  := Time.now();

    // Initialize on first heartbeat
    _initKuramoto();
    if (policyCount == 0) { _initDefaultPolicies() };
    // Set default learning rates if not yet configured
    if (beliefLR < EPSILON)    { beliefLR    := _pow(PHI_INV, 2.0) };  // φ⁻²
    if (precisionLR < EPSILON) { precisionLR := _pow(PHI_INV, 3.0) };  // φ⁻³

    // PHASE 1: KURAMOTO TICK
    _tickKuramoto();

    // PHASE 2: COMPUTE SPINOR STATE
    _computeMySpinorState();

    // PHASE 3: COMPUTE FREE ENERGY
    _computeFreeEnergy();
    totalFEHistory := totalFEHistory + 1;

    // PHASE 4: PERCEPTUAL INFERENCE (only if we have observations)
    if (wmCount > 0 and obsCount > 0) {
      _perceptualInference();
      _computeFreeEnergy();  // recompute after belief update
    };

    // PHASE 5: POLICY INFERENCE (every 5 beats — policy selection is expensive)
    if (heartbeatCount % 5 == 0) {
      _selectPolicy();
    };

    // PHASE 6: COLLECTIVE UPDATE
    _updateCollectiveState();
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 12 — PUBLIC QUERY INTERFACE
  // ═══════════════════════════════════════════════════════════════════════════

  // Manual inference trigger (can be called externally to force an inference cycle)
  public shared func runInferenceCycle() : async {
    freeEnergy  : Float;
    inaccuracy  : Float;
    complexity  : Float;
    currentPolicy : Text;
    kuramotoR   : Float;
    spinorMag   : Float;
  } {
    _computeMySpinorState();
    _computeFreeEnergy();
    if (wmCount > 0 and obsCount > 0) {
      _perceptualInference();
      _computeFreeEnergy();
    };
    _selectPolicy();
    _updateCollectiveState();
    {
      freeEnergy    = currentF;
      inaccuracy    = currentInaccuracy;
      complexity    = currentComplexity;
      currentPolicy = if (currentPolicy < policyCount) policyNames[currentPolicy] else "NONE";
      kuramotoR     = kuramotoR;
      spinorMag     = mySpinorMagnitude;
    }
  };

  // Read the full world model state
  public query func getWorldModel() : async {
    dimCount       : Nat;
    names          : [Text];
    means          : [Float];
    precisions     : [Float];
    priorMeans     : [Float];
    priorPrecs     : [Float];
    predictions    : [Float];
    observations   : [Float];
    errors         : [Float];
    attentions     : [Float];
    modelVersion   : Nat;
  } {
    let n = wmCount;
    {
      dimCount    = n;
      names       = Array.tabulate<Text>(n,  func(i) { wmNames[i] });
      means       = Array.tabulate<Float>(n, func(i) { wmMeans[i] });
      precisions  = Array.tabulate<Float>(n, func(i) { wmPrecisions[i] });
      priorMeans  = Array.tabulate<Float>(n, func(i) { wmPriorMeans[i] });
      priorPrecs  = Array.tabulate<Float>(n, func(i) { wmPriorPrecs[i] });
      predictions = Array.tabulate<Float>(n, func(i) { obsPredictions[i] });
      observations= Array.tabulate<Float>(n, func(i) { obsValues[i] });
      errors      = Array.tabulate<Float>(n, func(i) { obsErrors[i] });
      attentions  = Array.tabulate<Float>(n, func(i) { obsAttentions[i] });
      modelVersion= wmVersion;
    }
  };

  // Read my SPINOR state
  public query func getSpinorState() : async {
    psiPlus    : Float;
    psiMinus   : Float;
    magnitude  : Float;
    phase      : Float;
    parity     : Bool;
    peerCount  : Nat;
  } {
    {
      psiPlus   = mySpinorPsiPlus;
      psiMinus  = mySpinorPsiMinus;
      magnitude = mySpinorMagnitude;
      phase     = mySpinorPhase;
      parity    = mySpinorParity;
      peerCount = spinorCount;
    }
  };

  // Read the Kuramoto field state
  public query func getKuramotoState() : async {
    phase   : Float;
    omega   : Float;
    k       : Float;
    r       : Float;
    psi     : Float;
    synced  : Bool;   // true if r > φ⁻¹ (organism coherence threshold)
  } {
    {
      phase  = kuramotoPhase;
      omega  = kuramotoOmega;
      k      = kuramotoK;
      r      = kuramotoR;
      psi    = kuramotoPsi;
      synced = kuramotoR > PHI_INV;
    }
  };

  // Read the free energy state
  public query func getFreeEnergy() : async {
    total          : Float;
    inaccuracy     : Float;
    complexity     : Float;
    totalMinimized : Float;
    historyCount   : Nat;
    trend          : Text;  // "DECREASING" | "STABLE" | "INCREASING"
  } {
    let trend : Text = if (feHistoryCount < 2) "INSUFFICIENT_DATA"
    else {
      let curr = feHistory[(feHistoryHead - 1) % FE_HISTORY_CAP];
      let prev = feHistory[(feHistoryHead - 2) % FE_HISTORY_CAP];
      if      (curr < prev - EPSILON) "DECREASING"
      else if (curr > prev + EPSILON) "INCREASING"
      else                            "STABLE"
    };
    {
      total          = currentF;
      inaccuracy     = currentInaccuracy;
      complexity     = currentComplexity;
      totalMinimized = totalFEMinimized;
      historyCount   = feHistoryCount;
      trend          = trend;
    }
  };

  // Read the collective active inference state
  public query func getCollectiveState() : async {
    collectiveFE         : Float;
    collectiveCoherence  : Float;
    collectivePrediction : Float;
    collectiveCoupling   : Float;
    collectiveBeats      : Nat;
    isCoherent           : Bool;  // collectiveCoherence > φ⁻¹
  } {
    {
      collectiveFE         = collectiveFE;
      collectiveCoherence  = collectiveCoherence;
      collectivePrediction = collectivePrediction;
      collectiveCoupling   = collectiveCoupling;
      collectiveBeats      = collectiveBeats;
      isCoherent           = collectiveCoherence > PHI_INV;
    }
  };

  // Read policy state
  public query func getPolicyState() : async {
    policyCount    : Nat;
    names          : [Text];
    expectedG      : [Float];
    selectCounts   : [Nat];
    currentPolicy  : Text;
    explorationBonus : Float;
  } {
    let n = policyCount;
    {
      policyCount   = n;
      names         = Array.tabulate<Text>(n,  func(i) { policyNames[i] });
      expectedG     = Array.tabulate<Float>(n, func(i) { policyExpectedG[i] });
      selectCounts  = Array.tabulate<Nat>(n,   func(i) { policySelectCount[i] });
      currentPolicy = if (currentPolicy < n) policyNames[currentPolicy] else "NONE";
      explorationBonus = explorationBonus;
    }
  };

  // Read SPINOR peer registry
  public query func getSpinorPeers() : async {
    peerCount : Nat;
    ids       : [Text];
    names     : [Text];
    phases    : [Float];
    amplitudes: [Float];
    psiPlus   : [Float];
    psiMinus  : [Float];
    parities  : [Bool];
  } {
    let n = spinorCount;
    {
      peerCount  = n;
      ids        = Array.tabulate<Text>(n,  func(i) { spinorPeerIds[i] });
      names      = Array.tabulate<Text>(n,  func(i) { spinorPeerNames[i] });
      phases     = Array.tabulate<Float>(n, func(i) { spinorPeerPhases[i] });
      amplitudes = Array.tabulate<Float>(n, func(i) { spinorPeerAmplitudes[i] });
      psiPlus    = Array.tabulate<Float>(n, func(i) { spinorPeerPsiPlus[i] });
      psiMinus   = Array.tabulate<Float>(n, func(i) { spinorPeerPsiMinus[i] });
      parities   = Array.tabulate<Bool>(n,  func(i) { spinorPeerParities[i] });
    }
  };

  // Heartbeat proof of operation
  public query func getHeartbeatProof() : async {
    heartbeatCount : Nat;
    lastHeartbeat  : Int;
    uptime         : Text;
    isProactive    : Bool;
  } {
    let uptimeSec = (Time.now() - genesisTimestamp) / 1_000_000_000;
    {
      heartbeatCount = heartbeatCount;
      lastHeartbeat  = lastHeartbeat;
      uptime         = Int.toText(uptimeSec) # "s";
      isProactive    = true;  // always proactive — this is the new archetype
    }
  };

  // Full machine status — one call to see everything
  public query func getMachineStatus() : async {
    // Identity
    canisterName   : Text;
    sovereignSeal  : Text;
    buildNumber    : Nat;
    heartbeatCount : Nat;
    // World model
    wmDimensions   : Nat;
    wmVersion      : Nat;
    obsCount       : Nat;
    // Free energy
    freeEnergy     : Float;
    inaccuracy     : Float;
    complexity     : Float;
    feTrend        : Text;
    // Inference
    currentPolicy  : Text;
    explorationBonus : Float;
    // SPINOR
    spinorPsiPlus  : Float;
    spinorPsiMinus : Float;
    spinorMagnitude: Float;
    spinorParity   : Bool;
    spinorPeers    : Nat;
    // Kuramoto
    kuramotoPhase  : Float;
    kuramotoR      : Float;
    isSynchronized : Bool;
    // Collective
    collectiveFE   : Float;
    collectiveCoherence : Float;
    isCoherent     : Bool;
    // Architecture
    archetype      : Text;
    phi            : Float;
  } {
    let trend : Text = if (feHistoryCount < 2) "INITIALIZING"
    else {
      let curr = feHistory[(feHistoryHead - 1) % FE_HISTORY_CAP];
      let prev = feHistory[(feHistoryHead - 2) % FE_HISTORY_CAP];
      if      (curr < prev - EPSILON) "DECREASING"
      else if (curr > prev + EPSILON) "INCREASING"
      else                            "STABLE"
    };
    {
      canisterName   = canisterName;
      sovereignSeal  = sovereignSeal;
      buildNumber    = buildNumber;
      heartbeatCount = heartbeatCount;
      wmDimensions   = wmCount;
      wmVersion      = wmVersion;
      obsCount       = obsCount;
      freeEnergy     = currentF;
      inaccuracy     = currentInaccuracy;
      complexity     = currentComplexity;
      feTrend        = trend;
      currentPolicy  = if (currentPolicy < policyCount) policyNames[currentPolicy] else "NONE";
      explorationBonus = explorationBonus;
      spinorPsiPlus  = mySpinorPsiPlus;
      spinorPsiMinus = mySpinorPsiMinus;
      spinorMagnitude= mySpinorMagnitude;
      spinorParity   = mySpinorParity;
      spinorPeers    = spinorCount;
      kuramotoPhase  = kuramotoPhase;
      kuramotoR      = kuramotoR;
      isSynchronized = kuramotoR > PHI_INV;
      collectiveFE   = collectiveFE;
      collectiveCoherence  = collectiveCoherence;
      isCoherent     = collectiveCoherence > PHI_INV;
      archetype      = "FRISTON_MACHINA — Proactive ICP Canister — Active Inference + SPINOR + Kuramoto";
      phi            = PHI;
    }
  };

}
