// ============================================================
// NEUROEMERGENCE CORE — KURAMOTO ENGINE
// Phase oscillator dynamics for neural synchronization
// Kuramoto model: dθᵢ/dt = ωᵢ + K/N Σⱼ sin(θⱼ - θᵢ)
// Animal-frequency extension: 18-organ phase coupling
// Global order parameter r = |1/N Σ exp(i·θⱼ)| → coherenceC
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Array "mo:base/Array";

module {

  // ── Types ─────────────────────────────────────────────────────
  public type Oscillator = {
    phase      : Float;  // θ ∈ [0, 2π)
    naturalFreq: Float;  // ωᵢ (Hz equivalent)
    coupling   : Float;  // local coupling strength
    amplitude  : Float;  // 0-1 signal strength
  };

  public type KuramotoState = {
    oscillators     : [Oscillator];  // N oscillators
    globalCoupling  : Float;         // K
    orderParam      : Float;         // r ∈ [0,1]
    meanPhase       : Float;         // ψ = arg(Σ exp(i·θⱼ))
    beatNum         : Nat;
    syncHistory     : [Float];       // last 100 r values
    criticalK       : Float;         // phase transition threshold
  };

  // ── Constants ─────────────────────────────────────────────────
  let PI     : Float = 3.14159265358979323846;
  let TWO_PI : Float = 6.28318530717958647692;

  // 18-organ natural frequencies (Hz-equivalent, from swarm_organism spec)
  public let ORGAN_FREQS : [Float] = [
    0.08,  // heart
    0.05,  // lungs
    0.12,  // brain
    0.03,  // liver
    0.02,  // kidneys
    0.10,  // gut
    0.07,  // spleen
    0.04,  // pancreas
    0.15,  // thyroid
    0.06,  // adrenals
    0.09,  // thymus
    0.11,  // skin
    0.08,  // marrow
    0.04,  // lymph
    0.03,  // gonads
    0.05,  // eyes
    0.02,  // ears
    0.13   // spine
  ];

  // ── Clamp helper ──────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── Wrap phase to [0, 2π) ─────────────────────────────────────
  func wrapPhase(theta: Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TWO_PI };
    while (t >= TWO_PI) { t -= TWO_PI };
    t
  };

  // ── Order parameter (global synchronization measure) ──────────
  // r = |1/N Σⱼ exp(i·θⱼ)| = √((Σcos θⱼ)² + (Σsin θⱼ)²) / N
  // ψ = atan2(Σsin θⱼ, Σcos θⱼ)
  public func computeOrderParameter(oscs: [Oscillator]) : (Float, Float) {
    let n = oscs.size();
    if (n == 0) { return (0.0, 0.0) };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (o in oscs.vals()) {
      sumCos += Float.cos(o.phase) * o.amplitude;
      sumSin += Float.sin(o.phase) * o.amplitude;
    };
    let nf = Float.fromInt(n);
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf;
    let psi = Float.arctan2(sumSin, sumCos);
    (_clamp(r, 0.0, 1.0), wrapPhase(psi))
  };

  // ── Single oscillator update ──────────────────────────────────
  // dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  // Simplified: dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ)
  func updateOscillator(
    osc: Oscillator, r: Float, meanPhase: Float, globalK: Float, dt: Float
  ) : Oscillator {
    let coupling = osc.coupling * globalK * r * Float.sin(meanPhase - osc.phase);
    let newPhase = wrapPhase(osc.phase + (osc.naturalFreq + coupling) * dt);
    {
      phase = newPhase;
      naturalFreq = osc.naturalFreq;
      coupling = osc.coupling;
      amplitude = osc.amplitude;
    }
  };

  // ── Full beat update ──────────────────────────────────────────
  public func beatKuramoto(state: KuramotoState, dt: Float) : KuramotoState {
    let (r, psi) = computeOrderParameter(state.oscillators);
    let newOscs = Array.map<Oscillator, Oscillator>(
      state.oscillators,
      func(o) { updateOscillator(o, r, psi, state.globalCoupling, dt) }
    );
    // Update sync history (circular buffer of 100)
    let newHistory = if (state.syncHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i) { state.syncHistory[i + 1] });
      Array.append<Float>(tail, [r])
    } else {
      Array.append<Float>(state.syncHistory, [r])
    };
    {
      oscillators    = newOscs;
      globalCoupling = state.globalCoupling;
      orderParam     = r;
      meanPhase      = psi;
      beatNum        = state.beatNum + 1;
      syncHistory    = newHistory;
      criticalK      = state.criticalK;
    }
  };

  // ── Adaptive coupling (organism learns optimal K) ─────────────
  // If r < target → increase K; if r > target → decrease K
  public func adaptCoupling(
    state: KuramotoState, targetR: Float, adaptRate: Float
  ) : KuramotoState {
    let error = targetR - state.orderParam;
    let newK = _clamp(state.globalCoupling + error * adaptRate, 0.0, 10.0);
    {
      oscillators    = state.oscillators;
      globalCoupling = newK;
      orderParam     = state.orderParam;
      meanPhase      = state.meanPhase;
      beatNum        = state.beatNum;
      syncHistory    = state.syncHistory;
      criticalK      = state.criticalK;
    }
  };

  // ── Phase reset (triggered by ARES or high-threat events) ─────
  public func phaseReset(state: KuramotoState, targetPhase: Float) : KuramotoState {
    let resetOscs = Array.map<Oscillator, Oscillator>(
      state.oscillators,
      func(o) { { phase = targetPhase; naturalFreq = o.naturalFreq; coupling = o.coupling; amplitude = o.amplitude } }
    );
    {
      oscillators    = resetOscs;
      globalCoupling = state.globalCoupling;
      orderParam     = 1.0;  // Perfect sync after reset
      meanPhase      = targetPhase;
      beatNum        = state.beatNum;
      syncHistory    = state.syncHistory;
      criticalK      = state.criticalK;
    }
  };

  // ── Synchronization variance ──────────────────────────────────
  // σ² = (1/N) Σ (θᵢ - ψ)²
  public func syncVariance(state: KuramotoState) : Float {
    let n = state.oscillators.size();
    if (n == 0) { return 0.0 };
    var sumSq : Float = 0.0;
    for (o in state.oscillators.vals()) {
      let diff = wrapPhase(o.phase - state.meanPhase);
      let centered = if (diff > PI) { diff - TWO_PI } else { diff };
      sumSq += centered * centered;
    };
    sumSq / Float.fromInt(n)
  };

  // ── Critical coupling estimate ────────────────────────────────
  // Kc ≈ 2 / (π · g(0)) where g(ω) is frequency distribution density at ω=0
  // For uniform distribution [ω_min, ω_max]: Kc ≈ 2(ω_max - ω_min) / π
  public func estimateCriticalK(oscs: [Oscillator]) : Float {
    if (oscs.size() < 2) { return 1.0 };
    var minW : Float = oscs[0].naturalFreq;
    var maxW : Float = oscs[0].naturalFreq;
    for (o in oscs.vals()) {
      if (o.naturalFreq < minW) { minW := o.naturalFreq };
      if (o.naturalFreq > maxW) { maxW := o.naturalFreq };
    };
    2.0 * (maxW - minW) / PI
  };

  // ── Init 18-organ oscillators ─────────────────────────────────
  public func initOrganOscillators() : [Oscillator] {
    Array.tabulate<Oscillator>(18, func(i) {
      {
        phase = Float.fromInt(i) * TWO_PI / 18.0;  // evenly distributed
        naturalFreq = ORGAN_FREQS[i];
        coupling = 1.0;
        amplitude = 1.0;
      }
    })
  };

  // ── Init full state ───────────────────────────────────────────
  public func initKuramoto() : KuramotoState {
    let oscs = initOrganOscillators();
    let kc = estimateCriticalK(oscs);
    {
      oscillators    = oscs;
      globalCoupling = kc * 1.5;  // Start above critical
      orderParam     = 0.5;
      meanPhase      = 0.0;
      beatNum        = 0;
      syncHistory    = [];
      criticalK      = kc;
    }
  };

  // ── Animal Kuramoto peak detection ────────────────────────────
  // Returns true if r > 0.85 for 10+ consecutive beats
  public func isKuramotoPeak(state: KuramotoState) : Bool {
    if (state.syncHistory.size() < 10) { return false };
    let start = state.syncHistory.size() - 10;
    var allHigh = true;
    for (i in Array.keys(state.syncHistory)) {
      if (i >= start and state.syncHistory[i] < 0.85) {
        allHigh := false;
      };
    };
    allHigh
  };

  // ── Coherence-to-Kuramoto mapping ─────────────────────────────
  // Maps organism coherenceC to expected r value
  public func coherenceToR(coherenceC: Float) : Float {
    // Sigmoid mapping: r = 1 / (1 + exp(-10*(C - 0.5)))
    1.0 / (1.0 + Float.exp(-10.0 * (coherenceC - 0.5)))
  };

}
