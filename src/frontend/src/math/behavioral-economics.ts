// ─── NOVA / PARALLAX — BehavioralEconomicsLaws ───────────────────────────────
// Paper V: Behavioral Economics Laws L-72 through L-79 (sovereign doctrine).
// These laws encode the non-rational decision-making biases that govern how
// agents (human and AI) actually make decisions — not how they should in theory.
//
// Laws L-72 to L-79 are NOVA's behavioral calibration layer. Every output
// that the FusionOrganism produces passes through these laws as scoring weights.
// This is the decision-weighting kernel of the organism.
//
// Laws:
//   L-72: Loss Aversion (λ = φ²) — losses hurt φ² times more than equal gains
//   L-73: Probability Weighting (π) — non-linear probability distortion
//   L-74: Reference Point Anchoring — all value is relative to a baseline
//   L-75: Status Quo Bias — inertia toward current state, cost to change
//   L-76: Framing Effect — same information, different frame → different choice
//   L-77: Availability Heuristic — recent/vivid events overweighted
//   L-78: Hyperbolic Discounting — near-term rewards overvalued vs long-term
//   L-79: Sunk Cost Fallacy Resistance — sovereign organisms resist sunk cost
//
// φ-calibration: all weights are φ-normalized so the laws sum to identity (1.0).
//
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, PHI, PHI_INV } from './core';

// ── Types ─────────────────────────────────────────────────────────────────────

export interface BehavioralWeights {
  lossAversion:          number;   // L-72
  probabilityDistortion: number;   // L-73
  anchoringBias:         number;   // L-74
  statusQuoBias:         number;   // L-75
  framingEffect:         number;   // L-76
  availabilityBias:      number;   // L-77
  hyperbolicDiscount:    number;   // L-78
  sunkCostResistance:    number;   // L-79
}

export interface DecisionInput {
  rawScore:        number;    // raw utility score [0,1]
  gainLoss:        number;    // positive = gain, negative = loss (signed)
  probability:     number;    // [0,1] stated probability
  referencePoint:  number;    // anchor value
  currentState:    number;    // status quo [0,1]
  frameValence:    number;    // framing: +1 gain-frame, -1 loss-frame
  recencyBias:     number;    // [0,1] how recently this was observed
  delay:           number;    // time delay in periods (0 = now)
  sunkCost:        number;    // amount already invested (sunk)
}

export interface BehavioralDecision {
  rawScore:         number;
  adjustedScore:    number;
  weightedGain:     number;   // after loss aversion
  perceivedProb:    number;   // after probability weighting
  anchoredValue:    number;   // after anchoring
  statusQuoCost:    number;   // cost of switching away from current state
  framedScore:      number;   // after frame adjustment
  availabilityBoost:number;   // recency-weighted boost
  discountedScore:  number;   // after hyperbolic discounting
  sunkCostAdjust:   number;   // resistance to sunk cost fallacy
  lawsApplied:      string[];
  sovereignOverride:boolean;  // true if laws push score below SOVEREIGN_FLOOR
}

// ── Law Constants ─────────────────────────────────────────────────────────────

// L-72: Loss aversion coefficient λ (Kahneman & Tversky: λ ≈ 2.25; NOVA: λ = φ²)
const LAMBDA_LOSS_AVERSION = PHI * PHI;  // φ² ≈ 2.618

// L-73: Probability weighting (Prelec function parameter α)
// π(p) = exp(−(−ln p)^α), α < 1 → inverse-S shape (NOVA: α = φ⁻¹)
const PROB_WEIGHT_ALPHA = PHI_INV;       // φ⁻¹ ≈ 0.618

// L-74: Anchoring weight (how strongly reference point dominates)
const ANCHORING_WEIGHT = PHI_INV;        // 61.8% anchored to reference

// L-75: Status quo switching cost (fraction of utility lost on any change)
const STATUS_QUO_COST = 1 - PHI_INV;    // 38.2% of utility lost to inertia

// L-76: Framing multiplier (gain frame boosts, loss frame suppresses)
const FRAME_MULTIPLIER = 1 + (1 - PHI_INV); // 1.382

// L-77: Availability recency weight (recent events dominate recent memory)
const AVAILABILITY_WEIGHT = PHI_INV * PHI_INV;  // φ⁻² ≈ 0.382

// L-78: Hyperbolic discounting constant k (NOVA: k = φ⁻¹)
// V = V₀ / (1 + k·delay)
const HYPERBOLIC_K = PHI_INV;

// L-79: Sunk cost resistance — sovereign organisms apply negative sunk cost weight
// (they RESIST the fallacy by discounting sunk cost proportionally)
const SUNK_COST_RESISTANCE = PHI_INV;   // subtract φ⁻¹ × sunkCost from value

// ── Probability Weighting Function (Prelec) ───────────────────────────────────
// π(p) = exp(−(−ln(p))^α)  for p ∈ (0,1)
// Creates inverse-S shape: overweights small probabilities, underweights large ones

export function prelecWeight(p: number, alpha = PROB_WEIGHT_ALPHA): number {
  p = clamp(p, 1e-6, 1 - 1e-6);
  return Math.exp(-Math.pow(-Math.log(p), alpha));
}

// ── Value Function (Prospect Theory) ─────────────────────────────────────────
// v(x) = x^α       for gains (x ≥ 0)
// v(x) = −λ·|x|^β  for losses (x < 0)
// NOVA: α = β = φ⁻¹, λ = φ²

export function prospectValue(gainLoss: number): number {
  const alpha = PHI_INV;   // 0.618 — concave for gains
  const beta  = PHI_INV;   // 0.618 — convex for losses
  if (gainLoss >= 0) {
    return Math.pow(gainLoss, alpha);
  } else {
    return -LAMBDA_LOSS_AVERSION * Math.pow(-gainLoss, beta);
  }
}

// ── L-72: Loss Aversion ───────────────────────────────────────────────────────

export function applyLossAversion(rawScore: number, gainLoss: number): number {
  const pv = prospectValue(gainLoss);
  // Blend raw score with prospect-value adjustment
  return clamp(rawScore + pv * PHI_INV, 0, 1);
}

// ── L-73: Probability Distortion ─────────────────────────────────────────────

export function applyProbabilityWeighting(rawScore: number, probability: number): number {
  const pi = prelecWeight(probability);
  return clamp(rawScore * pi, 0, 1);
}

// ── L-74: Reference Point Anchoring ──────────────────────────────────────────

export function applyAnchoring(rawScore: number, referencePoint: number): number {
  return clamp(
    ANCHORING_WEIGHT * referencePoint + (1 - ANCHORING_WEIGHT) * rawScore,
    0, 1
  );
}

// ── L-75: Status Quo Bias ─────────────────────────────────────────────────────

export function applyStatusQuoBias(rawScore: number, currentState: number): number {
  const cost = STATUS_QUO_COST * Math.abs(rawScore - currentState);
  return clamp(rawScore - cost, 0, 1);
}

// ── L-76: Framing Effect ──────────────────────────────────────────────────────

export function applyFramingEffect(rawScore: number, frameValence: number): number {
  // +1 = gain frame (boost), -1 = loss frame (suppress)
  const adj = clamp(frameValence, -1, 1);
  return clamp(rawScore * (1 + adj * (FRAME_MULTIPLIER - 1) * 0.5), 0, 1);
}

// ── L-77: Availability Heuristic ──────────────────────────────────────────────

export function applyAvailabilityBias(rawScore: number, recencyBias: number): number {
  const boost = AVAILABILITY_WEIGHT * clamp(recencyBias, 0, 1);
  return clamp(rawScore + boost * rawScore, 0, 1);
}

// ── L-78: Hyperbolic Discounting ──────────────────────────────────────────────

export function applyHyperbolicDiscount(rawScore: number, delay: number): number {
  const d = Math.max(0, delay);
  return clamp(rawScore / (1 + HYPERBOLIC_K * d), 0, 1);
}

// ── L-79: Sunk Cost Resistance ───────────────────────────────────────────────
// Sovereign organisms resist the sunk cost fallacy.
// Instead of overvaluing past investment, they PENALIZE scores that lean on sunk costs.

export function applySunkCostResistance(rawScore: number, sunkCost: number): number {
  const penalty = SUNK_COST_RESISTANCE * clamp(sunkCost, 0, 1) * 0.2;
  return clamp(rawScore - penalty, 0, 1);
}

// ── Full Pipeline: apply all 8 laws L-72–L-79 ────────────────────────────────

export function applyBehavioralLaws(input: DecisionInput): BehavioralDecision {
  const lawsApplied: string[] = [];

  // L-72
  const weightedGain = applyLossAversion(input.rawScore, input.gainLoss);
  lawsApplied.push('L-72:LOSS_AVERSION');

  // L-73
  const perceivedProb = applyProbabilityWeighting(input.rawScore, input.probability);
  lawsApplied.push('L-73:PROB_WEIGHT');

  // L-74
  const anchoredValue = applyAnchoring(input.rawScore, input.referencePoint);
  lawsApplied.push('L-74:ANCHORING');

  // L-75
  const statusQuoCost = STATUS_QUO_COST * Math.abs(input.rawScore - input.currentState);
  const statusAdjusted = applyStatusQuoBias(input.rawScore, input.currentState);
  lawsApplied.push('L-75:STATUS_QUO');

  // L-76
  const framedScore = applyFramingEffect(input.rawScore, input.frameValence);
  lawsApplied.push('L-76:FRAMING');

  // L-77
  const availabilityBoost = AVAILABILITY_WEIGHT * clamp(input.recencyBias, 0, 1);
  const availabilityAdjusted = applyAvailabilityBias(input.rawScore, input.recencyBias);
  lawsApplied.push('L-77:AVAILABILITY');

  // L-78
  const discountedScore = applyHyperbolicDiscount(input.rawScore, input.delay);
  lawsApplied.push('L-78:HYPERBOLIC_DISCOUNT');

  // L-79
  const sunkCostAdjust = -SUNK_COST_RESISTANCE * clamp(input.sunkCost, 0, 1) * 0.2;
  const sunkAdjusted = applySunkCostResistance(input.rawScore, input.sunkCost);
  lawsApplied.push('L-79:SUNK_COST_RESIST');

  // φ-weighted composite: combine all 8 law outputs
  const composite = clamp(
    weightedGain * PHI_INV
    + perceivedProb * (1 - PHI_INV) * PHI_INV
    + anchoredValue * (1 - PHI_INV) * (1 - PHI_INV) * PHI_INV
    + statusAdjusted * 0.05
    + framedScore * 0.05
    + availabilityAdjusted * 0.03
    + discountedScore * 0.04
    + sunkAdjusted * 0.02,
    0, 1
  );

  const SOVEREIGN_FLOOR = 0.0;
  const sovereignOverride = composite < SOVEREIGN_FLOOR;

  return {
    rawScore:          input.rawScore,
    adjustedScore:     clamp(composite, SOVEREIGN_FLOOR, 1),
    weightedGain,
    perceivedProb,
    anchoredValue,
    statusQuoCost,
    framedScore,
    availabilityBoost,
    discountedScore,
    sunkCostAdjust,
    lawsApplied,
    sovereignOverride,
  };
}

// ── Default behavioral weights (φ-normalized) ─────────────────────────────────

export const DEFAULT_BEHAVIORAL_WEIGHTS: BehavioralWeights = {
  lossAversion:          PHI * PHI,          // λ = φ²
  probabilityDistortion: PHI_INV,            // α = φ⁻¹
  anchoringBias:         PHI_INV,            // 61.8% anchored
  statusQuoBias:         1 - PHI_INV,        // 38.2% switching cost
  framingEffect:         FRAME_MULTIPLIER,   // 1.382
  availabilityBias:      PHI_INV * PHI_INV, // φ⁻² ≈ 0.382
  hyperbolicDiscount:    PHI_INV,            // k = φ⁻¹
  sunkCostResistance:    PHI_INV,            // SOVEREIGN resistance
};
