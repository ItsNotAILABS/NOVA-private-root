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


// ============================================================
// NEUROEMERGENCE CORE — ENTROPY ENGINE
// Shannon / Fisher / Observational entropy computation
// H_obs = -Σ pᵢ log₂(pᵢ) over 18-organ distribution
// Fisher information for precision/uncertainty trade-off
// Maxwell's Demon gate: entropy sorting for coherence extraction
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Types ─────────────────────────────────────────────────────
  public type EntropyState = {
    // Core entropies
    shannonH       : Float;   // Shannon entropy H = -Σ pᵢ log₂(pᵢ)
    fisherI        : Float;   // Fisher information I(θ) = E[(∂logL/∂θ)²]
    observationalH : Float;   // H_obs = weighted organ entropy

    // Organ probability distribution
    organProbs     : [Float]; // 18-element probability distribution

    // Demon gate state
    demonGateOpen  : Bool;
    demonSortCount : Nat;     // how many sorts performed
    entropyExtracted : Float; // total entropy removed by demon

    // History
    hHistory       : [Float]; // last 100 H values
    beatNum        : Nat;

    // Thresholds
    lowEntropyThresh  : Float;  // below this → high coherence possible
    highEntropyThresh : Float;  // above this → chaos warning
  };

  // ── Constants ─────────────────────────────────────────────────
  let LOG2_E : Float = 1.4426950408889634;  // 1/ln(2)
  let EPSILON : Float = 1e-10;  // prevent log(0)

  // ── Clamp helper ──────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── Natural log ───────────────────────────────────────────────
  func ln(x: Float) : Float {
    if (x <= 0.0) { return -100.0 };  // safe lower bound
    Float.log(x)
  };

  // ── Log base 2 ────────────────────────────────────────────────
  func log2(x: Float) : Float {
    ln(x) * LOG2_E
  };

  // ── Normalize to probability distribution ─────────────────────
  public func normalize(values: [Float]) : [Float] {
    var sum : Float = 0.0;
    for (v in values.vals()) { sum += Float.abs(v) };
    if (sum < EPSILON) {
      // Uniform distribution if all zeros
      let n = values.size();
      return Array.tabulate<Float>(n, func(_) { 1.0 / Float.fromInt(n) });
    };
    Array.map<Float, Float>(values, func(v) { Float.abs(v) / sum })
  };

  // ── Shannon entropy ───────────────────────────────────────────
  // H = -Σ pᵢ log₂(pᵢ)
  public func shannonEntropy(probs: [Float]) : Float {
    var h : Float = 0.0;
    for (p in probs.vals()) {
      if (p > EPSILON) {
        h -= p * log2(p);
      };
    };
    _clamp(h, 0.0, 12.0)  // max ~log₂(18) ≈ 4.17 for 18 organs
  };

  // ── Fisher information ────────────────────────────────────────
  // I(θ) = Σᵢ (1/pᵢ)(∂pᵢ/∂θ)²
  // Approximated as I ≈ Σᵢ 1/(pᵢ + ε) for precision measure
  public func fisherInfo(probs: [Float]) : Float {
    var fi : Float = 0.0;
    for (p in probs.vals()) {
      if (p > EPSILON) {
        fi += 1.0 / (p + EPSILON);
      };
    };
    _clamp(fi / Float.fromInt(probs.size()), 0.0, 100.0)
  };

  // ── Observational entropy (weighted) ──────────────────────────
  // H_obs = Σᵢ wᵢ · (-pᵢ log₂ pᵢ) where wᵢ are organ importance weights
  public func observationalEntropy(probs: [Float], weights: [Float]) : Float {
    var hObs : Float = 0.0;
    let n = if (probs.size() < weights.size()) { probs.size() } else { weights.size() };
    for (i in Array.keys(probs)) {
      if (i < n) {
        let p = probs[i];
        let w = weights[i];
        if (p > EPSILON) {
          hObs += w * (-p * log2(p));
        };
      };
    };
    _clamp(hObs, 0.0, 12.0)
  };

  // 18-organ importance weights (from biological hierarchy)
  public let ORGAN_WEIGHTS : [Float] = [
    0.12,  // heart (critical)
    0.10,  // lungs
    0.15,  // brain (highest)
    0.08,  // liver
    0.06,  // kidneys
    0.07,  // gut
    0.04,  // spleen
    0.05,  // pancreas
    0.03,  // thyroid
    0.04,  // adrenals
    0.03,  // thymus
    0.05,  // skin
    0.04,  // marrow
    0.03,  // lymph
    0.02,  // gonads
    0.03,  // eyes
    0.02,  // ears
    0.04   // spine
  ];

  // ── Maxwell's Demon gate ──────────────────────────────────────
  // Sorts high-energy (high probability) organs from low-energy
  // Reduces entropy by concentrating probability mass
  public func demonSort(probs: [Float], sortStrength: Float) : ([Float], Float) {
    // Find max probability index
    var maxIdx = 0;
    var maxP : Float = 0.0;
    for (i in Array.keys(probs)) {
      if (probs[i] > maxP) {
        maxP := probs[i];
        maxIdx := i;
      };
    };

    // Concentrate probability toward max (demon sorting)
    let boost = sortStrength * 0.1;
    let newProbs = Array.mapEntries<Float, Float>(probs, func(i, p) {
      if (i == maxIdx) { p + boost } else { p * (1.0 - boost / Float.fromInt(probs.size() - 1)) }
    });

    let normalized = normalize(newProbs);
    let beforeH = shannonEntropy(probs);
    let afterH = shannonEntropy(normalized);
    let extracted = beforeH - afterH;

    (normalized, extracted)
  };

  // ── Beat update ───────────────────────────────────────────────
  public func beatEntropy(state: EntropyState, newOrganValues: [Float]) : EntropyState {
    let probs = normalize(newOrganValues);
    let newShannon = shannonEntropy(probs);
    let newFisher = fisherInfo(probs);
    let newObs = observationalEntropy(probs, ORGAN_WEIGHTS);

    // Update history
    let newHistory = if (state.hHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i) { state.hHistory[i + 1] });
      Array.append<Float>(tail, [newObs])
    } else {
      Array.append<Float>(state.hHistory, [newObs])
    };

    // Check demon gate trigger (if entropy too high and gate closed)
    let shouldOpenGate = newObs > state.highEntropyThresh and not state.demonGateOpen;

    {
      shannonH       = newShannon;
      fisherI        = newFisher;
      observationalH = newObs;
      organProbs     = probs;
      demonGateOpen  = shouldOpenGate or state.demonGateOpen;
      demonSortCount = state.demonSortCount;
      entropyExtracted = state.entropyExtracted;
      hHistory       = newHistory;
      beatNum        = state.beatNum + 1;
      lowEntropyThresh = state.lowEntropyThresh;
      highEntropyThresh = state.highEntropyThresh;
    }
  };

  // ── Apply demon sort (if gate is open) ────────────────────────
  public func applyDemonSort(state: EntropyState, sortStrength: Float) : EntropyState {
    if (not state.demonGateOpen) { return state };

    let (newProbs, extracted) = demonSort(state.organProbs, sortStrength);
    let newObs = observationalEntropy(newProbs, ORGAN_WEIGHTS);

    // Close gate if entropy is now low enough
    let shouldClose = newObs < state.lowEntropyThresh;

    {
      shannonH       = shannonEntropy(newProbs);
      fisherI        = fisherInfo(newProbs);
      observationalH = newObs;
      organProbs     = newProbs;
      demonGateOpen  = not shouldClose;
      demonSortCount = state.demonSortCount + 1;
      entropyExtracted = state.entropyExtracted + extracted;
      hHistory       = state.hHistory;
      beatNum        = state.beatNum;
      lowEntropyThresh = state.lowEntropyThresh;
      highEntropyThresh = state.highEntropyThresh;
    }
  };

  // ── Entropy rate estimation ───────────────────────────────────
  // ΔH/Δt from history
  public func entropyRate(state: EntropyState) : Float {
    if (state.hHistory.size() < 2) { return 0.0 };
    let n = state.hHistory.size();
    state.hHistory[n - 1] - state.hHistory[n - 2]
  };

  // ── Entropy health score ──────────────────────────────────────
  // Optimal entropy is not too low (rigid) or too high (chaotic)
  public func entropyHealthScore(state: EntropyState) : Float {
    let target = (state.lowEntropyThresh + state.highEntropyThresh) / 2.0;
    let deviation = Float.abs(state.observationalH - target);
    let maxDev = (state.highEntropyThresh - state.lowEntropyThresh) / 2.0;
    _clamp(1.0 - deviation / maxDev, 0.0, 1.0)
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initEntropy() : EntropyState {
    let uniformProbs = Array.tabulate<Float>(18, func(_) { 1.0 / 18.0 });
    {
      shannonH       = shannonEntropy(uniformProbs);
      fisherI        = fisherInfo(uniformProbs);
      observationalH = observationalEntropy(uniformProbs, ORGAN_WEIGHTS);
      organProbs     = uniformProbs;
      demonGateOpen  = false;
      demonSortCount = 0;
      entropyExtracted = 0.0;
      hHistory       = [];
      beatNum        = 0;
      lowEntropyThresh = 2.0;   // below → very ordered
      highEntropyThresh = 8.0;  // above → chaotic
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type EntropySummary = {
    shannonH      : Float;
    fisherI       : Float;
    observationalH: Float;
    entropyRate   : Float;
    healthScore   : Float;
    demonGateOpen : Bool;
    totalExtracted: Float;
  };

  public func summary(state: EntropyState) : EntropySummary {
    {
      shannonH       = state.shannonH;
      fisherI        = state.fisherI;
      observationalH = state.observationalH;
      entropyRate    = entropyRate(state);
      healthScore    = entropyHealthScore(state);
      demonGateOpen  = state.demonGateOpen;
      totalExtracted = state.entropyExtracted;
    }
  };

}
