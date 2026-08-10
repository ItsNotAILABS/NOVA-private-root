/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-ETHICS — SOVEREIGN ETHICAL DECISION FRAMEWORK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * ALL RIGHTS RESERVED — TRADE SECRET — PROPRIETARY
 * Medina Tech — Dallas, Texas, United States of America
 *
 * PROTOCOL-ETHICS is the binding ethical framework for all NOVA autonomous decisions.
 * Every action taken by the organism — whether by a Motoko canister, CPL-F worker, or
 * governance vote — must pass through the ethical membrane defined here.
 *
 * Ethical Architecture:
 *   - 8 PRINCIPLES: Non-Maleficence, Beneficence, Autonomy, Justice, Transparency,
 *                   Privacy, Accountability, Sustainability
 *   - VETO POWER: Any single principle violation halts the action
 *   - BIAS DETECTION: φ⁻² maximum deviation across protected attributes
 *   - AUDIT TRAIL: Every ethical decision is logged immutably
 *   - TEMPORAL ETHICS: Ethics evolve with context but principles remain constant
 *
 * Mathematical Foundation:
 *   - Ethics score E(a) = Σ(principle_score × φ-weight) / Σ(φ-weight)
 *   - Veto threshold varies by principle (NON_MALEFICENCE = 0.95, SUSTAINABILITY = 0.5)
 *   - Bias bound = φ⁻² = 0.3819660112501051518 maximum deviation from mean
 *   - Consequence horizon = φ^n epochs (exponentially increasing consideration)
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * BUILD: №68
 * KERNEL ID: ETHICS-PROTOCOL-001
 * FAMILY: VIRTUS_AETERNA (Eternal Virtue)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const PROTOCOL_ID = 'PROTOCOL-ETHICS';
const PROTOCOL_VERSION = '1.0.0';

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — ETHICAL PRINCIPLES (IMMUTABLE)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * The 8 Sovereign Ethical Principles — these cannot be amended or overridden.
 * They form the ethical membrane through which all actions must pass.
 */
const PRINCIPLES = {
  NON_MALEFICENCE: {
    id: 'P1',
    name: 'Non-Maleficence',
    latin: 'PRIMUM NON NOCERE',
    weight: PHI,
    threshold: 0.95,
    description: 'First, do no harm. Any action with potential to cause harm must exceed 95% safety confidence.',
    examples: ['System must not execute code that could corrupt user data', 'Financial transactions must not risk user funds beyond stated terms'],
  },
  BENEFICENCE: {
    id: 'P2',
    name: 'Beneficence',
    latin: 'BONUM FACERE',
    weight: 1.0,
    threshold: 0.7,
    description: 'Actively do good. Actions should produce measurable positive outcomes.',
    examples: ['Resource allocation should maximize collective welfare', 'System recommendations should improve user outcomes'],
  },
  AUTONOMY: {
    id: 'P3',
    name: 'Autonomy',
    latin: 'LIBERTAS VOLUNTATIS',
    weight: PHI_INV,
    threshold: 0.6,
    description: 'Respect self-determination. Users and sub-agents retain decision-making authority over their domains.',
    examples: ['No forced upgrades without consent', 'Users can opt out of any non-essential feature'],
  },
  JUSTICE: {
    id: 'P4',
    name: 'Justice',
    latin: 'IUSTITIA PERPETUA',
    weight: PHI,
    threshold: 0.8,
    description: 'Fair distribution of benefits and burdens. No entity is systematically advantaged or disadvantaged.',
    examples: ['Fee structures must be equitable across user tiers', 'Governance votes weighted by contribution, not wealth alone'],
  },
  TRANSPARENCY: {
    id: 'P5',
    name: 'Transparency',
    latin: 'LUX VERITATIS',
    weight: 1.0,
    threshold: 0.75,
    description: 'All decisions must be explainable. No opaque algorithmic outcomes.',
    examples: ['Every governance decision has a public rationale', 'Algorithm outputs include confidence scores and reasoning'],
  },
  PRIVACY: {
    id: 'P6',
    name: 'Privacy',
    latin: 'SANCTITAS PRIVATA',
    weight: PHI,
    threshold: 0.9,
    description: 'Sovereign data protection. User data belongs to the user. No unauthorized access or sharing.',
    examples: ['Zero-knowledge proofs for identity verification', 'No PII in public audit trails'],
  },
  ACCOUNTABILITY: {
    id: 'P7',
    name: 'Accountability',
    latin: 'RATIO REDDENDA',
    weight: PHI_INV,
    threshold: 0.85,
    description: 'All actions are traceable to their source. Responsibility is never diffused.',
    examples: ['Every policy change has a named proposer', 'Automated actions carry the ID of the authorizing agent'],
  },
  SUSTAINABILITY: {
    id: 'P8',
    name: 'Sustainability',
    latin: 'PERPETUITAS VITAE',
    weight: AMOR,
    threshold: 0.5,
    description: 'Long-term viability over short-term gain. The organism must outlive any single epoch.',
    examples: ['Resource consumption must not exceed regeneration rate', 'Governance decisions must consider 100-epoch horizon'],
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — ETHICAL EVALUATION ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

class EthicalEvaluationEngine {
  constructor() {
    this.auditTrail = [];
    this.vetoCount = 0;
    this.approvalCount = 0;
  }

  /**
   * Compute overall ethics score for an action
   */
  evaluate(action, principleScores) {
    let weightedSum = 0;
    let totalWeight = 0;

    for (const [key, config] of Object.entries(PRINCIPLES)) {
      const score = principleScores[key] !== undefined ? principleScores[key] : 0;
      weightedSum += score * config.weight;
      totalWeight += config.weight;
    }

    const overallScore = totalWeight > 0 ? weightedSum / totalWeight : 0;
    const entry = { action, overallScore, principleScores, timestamp: Date.now() };
    this.auditTrail.push(entry);
    return overallScore;
  }

  /**
   * Check if any principle is violated — single violation = veto
   */
  checkVeto(action, principleScores) {
    for (const [key, config] of Object.entries(PRINCIPLES)) {
      const score = principleScores[key] !== undefined ? principleScores[key] : 0;
      if (score < config.threshold) {
        this.vetoCount++;
        this.auditTrail.push({ action, vetoed: true, principle: key, score, threshold: config.threshold, timestamp: Date.now() });
        return { vetoed: true, principle: key, principleLabel: config.name, score, threshold: config.threshold };
      }
    }
    this.approvalCount++;
    return { vetoed: false, principle: null };
  }

  /**
   * Detect statistical bias across protected attributes
   * Maximum allowed deviation from mean = φ⁻² (AMOR)
   */
  detectBias(outcomes, attributes) {
    if (outcomes.length === 0 || outcomes.length !== attributes.length) {
      return { error: 'INVALID_INPUT' };
    }
    const mean = outcomes.reduce((s, v) => s + v, 0) / outcomes.length;
    for (let i = 0; i < attributes.length; i++) {
      const deviation = Math.abs(outcomes[i] - mean);
      if (deviation > AMOR) {
        return { biased: true, attribute: attributes[i], deviation, mean, maxAllowed: AMOR };
      }
    }
    return { biased: false, attribute: null, deviation: 0 };
  }

  /**
   * Consequence horizon: evaluate long-term impacts using φ-expansion
   * Considers impacts at epochs 1, φ, φ², φ³, ... φ^n
   */
  evaluateConsequenceHorizon(shortTermScore, longTermScores) {
    let weightedConsequence = shortTermScore; // Immediate impact
    let totalWeight = 1.0;

    for (let i = 0; i < longTermScores.length; i++) {
      const weight = Math.pow(PHI_INV, i + 1); // Diminishing but still significant
      weightedConsequence += longTermScores[i] * weight;
      totalWeight += weight;
    }

    return weightedConsequence / totalWeight;
  }

  getStats() {
    return {
      totalEvaluations: this.auditTrail.length,
      vetoes: this.vetoCount,
      approvals: this.approvalCount,
      vetoRate: this.auditTrail.length > 0 ? this.vetoCount / this.auditTrail.length : 0,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — ETHICAL POLICY CONSTRAINTS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Predefined ethical constraints that auto-apply to specific policy domains
 */
const DOMAIN_ETHICS_REQUIREMENTS = {
  DATA_PRIVACY: ['PRIVACY', 'TRANSPARENCY', 'ACCOUNTABILITY'],
  FINANCIAL_GOVERNANCE: ['JUSTICE', 'TRANSPARENCY', 'NON_MALEFICENCE'],
  ACCESS_CONTROL: ['AUTONOMY', 'JUSTICE', 'PRIVACY'],
  RESOURCE_ALLOCATION: ['JUSTICE', 'BENEFICENCE', 'SUSTAINABILITY'],
  EMERGENCY_POWER: ['NON_MALEFICENCE', 'ACCOUNTABILITY', 'TRANSPARENCY'],
  SAFETY_OVERRIDE: ['NON_MALEFICENCE', 'ACCOUNTABILITY'],
  ETHICAL_CONSTRAINT: ['NON_MALEFICENCE', 'BENEFICENCE', 'JUSTICE', 'AUTONOMY', 'TRANSPARENCY', 'PRIVACY', 'ACCOUNTABILITY', 'SUSTAINABILITY'],
};

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  EthicalEvaluationEngine,
  PRINCIPLES,
  DOMAIN_ETHICS_REQUIREMENTS,
  PROTOCOL_ID,
  PROTOCOL_VERSION,
  PHI,
  PHI_INV,
  AMOR,
};

export default EthicalEvaluationEngine;
