// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  MEDINA ICP — MATALKO ICP                                                ║
// ║  NOVA architecture expressed as math / physics / chemistry /             ║
// ║  memory potential functions.                                             ║
// ║  All formulas are ICP-native (no floats lost, no external calls).        ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.   ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import T     "./Types";

module {

  // ── PHI CONSTANTS ─────────────────────────────────────────────────────────
  // φ = (1 + √5) / 2  ≈ 1.6180339887
  // φ is the transfer function between adjacent levels of any
  // naturally sustained coupled oscillating system.

  let PHI  : Float = 1.6180339887;
  let PHI2 : Float = PHI  * PHI;         // φ²  ≈ 2.618
  let PHI3 : Float = PHI2 * PHI;         // φ³  ≈ 4.236
  let PHI4 : Float = PHI3 * PHI;         // φ⁴  ≈ 6.854

  // Schumann fundamental (Earth's resonance)
  let SCHUMANN_HZ : Float = 7.83;

  // ── HEARTBEAT DERIVATION ──────────────────────────────────────────────────
  // Organism heartbeat = φ⁴ × Schumann period = 875.28 ms = 68.5 BPM.
  // Walking up phi ladder from Schumann:
  //   sensory  = φ² × (1/7.83) s  =  334 ms
  //   write    = φ³ × (1/7.83) s  =  541 ms
  //   beat     = φ⁴ × (1/7.83) s  =  875 ms
  //   coherence = φ⁵ × (1/7.83) s = 1416 ms

  public func heartbeatMs() : Float {
    PHI4 / SCHUMANN_HZ * 1000.0
  };

  public func sensoryWindowMs() : Float {
    PHI2 / SCHUMANN_HZ * 1000.0
  };

  public func writeWindowMs() : Float {
    PHI3 / SCHUMANN_HZ * 1000.0
  };

  // ── MACRO ABSORPTION ──────────────────────────────────────────────────────
  // Macro absorption integrates micro-domain scores into one field scalar.
  // A(t) = Σ wᵢ · sᵢ   where sᵢ are normalized domain scores [0,1].

  public func macroAbsorption(scores : [Float]) : Float {
    if (scores.size() == 0) return 0.0;
    var sum : Float = 0.0;
    for (s in scores.vals()) { sum += s };
    sum / Float.fromInt(scores.size())
  };

  // ── DUAL-READ ENERGY ──────────────────────────────────────────────────────
  // Energy of the dual-read pair:
  // E_dual = √(E_semantic² + E_resonance²)
  // Normalized by √2 so maximum energy = 1.

  public func dualReadEnergy(semantic : Float, resonance : Float) : Float {
    Float.sqrt(semantic * semantic + resonance * resonance) / Float.sqrt(2.0)
  };

  // ── STABILITY POTENTIAL ───────────────────────────────────────────────────
  // Lyapunov-inspired stability potential for the organism state.
  // V(x) = (1 - coherence)² + (1 - lawScore)²
  // When coherence = 1 and lawScore = 1, V = 0 (equilibrium).

  public func stabilityPotential(coherence : Float, lawScore : Float) : Float {
    let dC = 1.0 - coherence;
    let dL = 1.0 - lawScore;
    dC * dC + dL * dL
  };

  // ── CHEMISTRY POTENTIAL ───────────────────────────────────────────────────
  // Chemical potential μ governs the free-energy drive of the organism.
  // Modeled as μ = T × ln(activity / equilibrium)  (Van 't Hoff analogy)
  // where T is thermal noise proxy (entropy), activity is current drive,
  // equilibrium is the resting state drive.
  // Clamped to [-1.0, 1.0].

  public func chemPotential(
    entropy     : Float,   // [0,1] — current entropy level
    activity    : Float,   // [0,1] — current activity drive
    equilibrium : Float    // [0,1] — resting activity level
  ) : Float {
    if (equilibrium <= 0.0 or activity <= 0.0) return 0.0;
    let mu = entropy * Float.log(activity / equilibrium);
    Float.max(-1.0, Float.min(1.0, mu))
  };

  // ── MEMORY POTENTIAL ──────────────────────────────────────────────────────
  // Memory potential Ψ encodes how much usable potential is stored
  // in the memory temple at a given beat.
  // Ψ = Σ sᵢ × pᵢ  where sᵢ = salience, pᵢ = pinned bonus (1.2 if pinned, else 1.0)
  // Normalized to [0, 1] by dividing by entry count.

  public func memoryPotential(
    saliences : [Float],
    pinned    : [Bool]
  ) : Float {
    let n = saliences.size();
    if (n == 0) return 0.0;
    var sum : Float = 0.0;
    var i   : Nat   = 0;
    while (i < n) {
      let bonus : Float = if (i < pinned.size() and pinned[i]) 1.2 else 1.0;
      sum += saliences[i] * bonus;
      i += 1;
    };
    Float.min(1.0, sum / Float.fromInt(n))
  };

  // ── FULL SNAPSHOT ─────────────────────────────────────────────────────────

  public func snapshot(
    beat        : Nat,
    domainScores : [Float],
    semantic    : Float,
    resonance   : Float,
    coherence   : Float,
    lawScore    : Float,
    entropy     : Float,
    activity    : Float,
    equilibrium : Float,
    saliences   : [Float],
    pinned      : [Bool]
  ) : T.MatalkoSnapshot {
    {
      beat            = beat;
      macroAbsorption = macroAbsorption(domainScores);
      dualReadEnergy  = dualReadEnergy(semantic, resonance);
      stabilityPot    = stabilityPotential(coherence, lawScore);
      chemPotential   = chemPotential(entropy, activity, equilibrium);
      memPotential    = memoryPotential(saliences, pinned);
    }
  };

}
