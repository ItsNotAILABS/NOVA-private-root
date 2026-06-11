/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-GOVERNANCE — MACRO GOVERNANCE ACROSS TIME, USERS, POLICIES & ETHICS
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * ALL RIGHTS RESERVED — TRADE SECRET — PROPRIETARY
 * Medina Tech — Dallas, Texas, United States of America
 *
 * PROTOCOL-GOVERNANCE is the master governance protocol for the NOVA sovereign organism.
 * It defines how the system evolves across time, how users participate in decision-making,
 * how policies are created/enforced/retired, and how ethical constraints bound all actions.
 *
 * Architecture:
 *   - TEMPORAL LAYER: Epoch-based governance with φ-decay and renewal
 *   - USER LAYER: Sovereign identity → role → trust → vote weight
 *   - POLICY LAYER: Lifecycle (Draft→Proposed→Voting→Ratified→Active→Expired/Revoked)
 *   - ETHICS LAYER: 8 immutable principles with veto power
 *   - CONSENSUS LAYER: φ-weighted supermajority (61.8%) with quorum (38.2%)
 *
 * Mathematical Foundation:
 *   - Supermajority threshold = φ⁻¹ = 0.6180339887498948482
 *   - Quorum requirement = φ⁻² = 0.3819660112501051518
 *   - Policy decay = φ^(-epochs × (1 - renewalRate))
 *   - Trust compound = Hebbian × log(1 + epochs)
 *   - Vote weight = roleWeight × (1 + trust × φ⁻¹) × (1 + log(1 + stake) × φ⁻²)
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * BUILD: №68
 * KERNEL ID: GOVERNANCE-PROTOCOL-001
 * FAMILY: GUBERNATIO_AETERNA (Eternal Governance)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — SACRED CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const PROTOCOL_ID = 'PROTOCOL-GOVERNANCE';
const PROTOCOL_VERSION = '2.0.0';

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — TEMPORAL GOVERNANCE ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

const EPOCH_HEARTBEATS = 1000;
const EPOCH_MS = EPOCH_HEARTBEATS * HEARTBEAT_MS;

class TemporalGovernanceEngine {
  constructor() {
    this.genesisTimestamp = Date.now();
    this.epochs = [];
    this.currentEpoch = 0;
  }

  getEpoch(timestampMs) {
    return Math.floor((timestampMs - this.genesisTimestamp) / EPOCH_MS);
  }

  getEpochProgress(timestampMs) {
    return ((timestampMs - this.genesisTimestamp) % EPOCH_MS) / EPOCH_MS;
  }

  /**
   * φ-decay: policies weaken unless actively renewed
   * renewalRate ∈ [0, 1]: 0 = no renewal, 1 = permanent
   */
  computePolicyStrength(initialStrength, epochsElapsed, renewalRate) {
    const decay = Math.pow(PHI_INV, epochsElapsed * (1 - renewalRate));
    return Math.max(0, Math.min(1, initialStrength * decay));
  }

  /**
   * Hebbian temporal trust: trust compounds with positive interactions
   */
  computeTemporalTrust(baseTrust, interactions, epochsActive) {
    const hebbianBoost = 1 + (interactions * AMOR * Math.log(1 + epochsActive));
    return Math.max(0, Math.min(1, baseTrust * hebbianBoost / (1 + hebbianBoost)));
  }

  /**
   * Temporal consensus: past, present, and projected future all vote
   */
  computeTemporalConsensus(pastVotes, presentVotes, futureProjection) {
    const pastWeight = AMOR;
    const presentWeight = PHI_INV;
    const futureWeight = AMOR * PHI_INV;
    const totalWeight = pastWeight + presentWeight + futureWeight;

    const pastScore = pastVotes.length > 0
      ? pastVotes.reduce((s, v) => s + v, 0) / pastVotes.length
      : 0;
    const presentScore = presentVotes.length > 0
      ? presentVotes.reduce((s, v) => s + v, 0) / presentVotes.length
      : 0;

    return Math.max(0, Math.min(1,
      (pastScore * pastWeight + presentScore * presentWeight + futureProjection * futureWeight) / totalWeight
    ));
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — USER GOVERNANCE LAYER
// ═══════════════════════════════════════════════════════════════════════════════

const USER_ROLES = {
  SOVEREIGN: { level: 5, label: 'SOVEREIGN', weight: PHI * PHI, description: 'Creator — absolute authority' },
  GOVERNOR: { level: 4, label: 'GOVERNOR', weight: PHI, description: 'Elected governors — create and enforce policy' },
  DELEGATE: { level: 3, label: 'DELEGATE', weight: 1.0, description: 'Delegates — propose and execute' },
  CITIZEN: { level: 2, label: 'CITIZEN', weight: PHI_INV, description: 'Citizens — vote and participate' },
  OBSERVER: { level: 1, label: 'OBSERVER', weight: AMOR, description: 'Observers — read-only access' },
  PROBATION: { level: 0, label: 'PROBATION', weight: 0.1, description: 'Probation — limited, monitored access' },
};

const PERMISSIONS = {
  CREATE_POLICY: { level: 4, description: 'Create new governance policies' },
  VOTE_POLICY: { level: 2, description: 'Vote on proposed policies' },
  VIEW_POLICY: { level: 1, description: 'View existing policies' },
  EXECUTE_POLICY: { level: 3, description: 'Execute ratified policies' },
  REVOKE_POLICY: { level: 5, description: 'Revoke active policies' },
  AMEND_CHARTER: { level: 5, description: 'Amend sovereign charters' },
  PROPOSE_AMENDMENT: { level: 3, description: 'Propose charter amendments' },
  DELEGATE_AUTHORITY: { level: 4, description: 'Delegate authority to others' },
  AUDIT_SYSTEM: { level: 3, description: 'Audit governance decisions' },
  EMERGENCY_OVERRIDE: { level: 5, description: 'Override in emergencies' },
};

class UserGovernanceLayer {
  constructor() {
    this.users = new Map();
  }

  registerUser(id, role, initialTrust = 0.5) {
    this.users.set(id, {
      id,
      role,
      trustScore: initialTrust,
      interactions: 0,
      epochJoined: 0,
      stake: 0,
      delegations: [],
    });
    return this.users.get(id);
  }

  hasPermission(userId, permissionKey) {
    const user = this.users.get(userId);
    if (!user) return false;
    const perm = PERMISSIONS[permissionKey];
    if (!perm) return false;
    return USER_ROLES[user.role].level >= perm.level;
  }

  computeVoteWeight(userId) {
    const user = this.users.get(userId);
    if (!user) return 0;
    const roleInfo = USER_ROLES[user.role];
    const baseWeight = roleInfo.weight;
    const trustMultiplier = 1 + (user.trustScore * PHI_INV);
    const stakeMultiplier = 1 + Math.log(1 + user.stake) * AMOR;
    return baseWeight * trustMultiplier * stakeMultiplier;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — POLICY ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

const POLICY_STATES = {
  DRAFT: 'DRAFT',
  PROPOSED: 'PROPOSED',
  VOTING: 'VOTING',
  RATIFIED: 'RATIFIED',
  ACTIVE: 'ACTIVE',
  EXPIRED: 'EXPIRED',
  REVOKED: 'REVOKED',
  AMENDED: 'AMENDED',
};

const POLICY_DOMAINS = [
  'RESOURCE_ALLOCATION', 'ACCESS_CONTROL', 'DATA_PRIVACY',
  'FINANCIAL_GOVERNANCE', 'ETHICAL_CONSTRAINT', 'SAFETY_OVERRIDE',
  'UPGRADE_PROTOCOL', 'DISPUTE_RESOLUTION', 'EMERGENCY_POWER',
  'ATTRIBUTION_LAW', 'TEMPORAL_GOVERNANCE', 'ECOSYSTEM_HEALTH',
];

const SUPERMAJORITY_THRESHOLD = PHI_INV; // 61.8%
const QUORUM_THRESHOLD = AMOR;           // 38.2%

class PolicyEngine {
  constructor() {
    this.policies = new Map();
    this.policyCount = 0;
  }

  createPolicy(domain, rules, proposerId, config = {}) {
    const id = `POL-${String(++this.policyCount).padStart(6, '0')}`;
    const policy = {
      id,
      domain,
      rules,
      proposerId,
      state: POLICY_STATES.DRAFT,
      createdAt: Date.now(),
      createdEpoch: config.epoch || 0,
      expiresEpoch: config.expiresEpoch || null,
      votes: { for: 0, against: 0, abstain: 0, totalWeight: 0 },
      strength: 1.0,
      amendments: [],
      history: [{ state: 'DRAFT', timestamp: Date.now() }],
    };
    this.policies.set(id, policy);
    return policy;
  }

  transitionState(policyId, newState) {
    const policy = this.policies.get(policyId);
    if (!policy) return null;
    policy.state = newState;
    policy.history.push({ state: newState, timestamp: Date.now() });
    return policy;
  }

  submitVote(policyId, voterId, weight, vote) {
    const policy = this.policies.get(policyId);
    if (!policy || policy.state !== POLICY_STATES.VOTING) return false;
    policy.votes.totalWeight += weight;
    if (vote === 'FOR') policy.votes.for += weight;
    else if (vote === 'AGAINST') policy.votes.against += weight;
    else policy.votes.abstain += weight;
    return true;
  }

  evaluateVoting(policyId, totalEligibleWeight) {
    const policy = this.policies.get(policyId);
    if (!policy) return 'INVALID';
    const participation = policy.votes.totalWeight / totalEligibleWeight;
    if (participation < QUORUM_THRESHOLD) return 'NO_QUORUM';
    const effectiveVotes = policy.votes.for + policy.votes.against;
    if (effectiveVotes === 0) return 'NO_QUORUM';
    const approval = policy.votes.for / effectiveVotes;
    return approval >= SUPERMAJORITY_THRESHOLD ? 'RATIFIED' : 'REJECTED';
  }

  resolveConflict(policyA, policyB) {
    const priorityA = POLICY_DOMAINS.indexOf(policyA.domain);
    const priorityB = POLICY_DOMAINS.indexOf(policyB.domain);
    if (priorityA !== priorityB) return priorityA < priorityB ? policyA : policyB;
    return policyA.createdEpoch > policyB.createdEpoch ? policyA : policyB;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — ETHICS ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

const ETHICAL_PRINCIPLES = {
  NON_MALEFICENCE: { weight: PHI, threshold: 0.95, description: 'Do no harm — highest priority' },
  BENEFICENCE: { weight: 1.0, threshold: 0.7, description: 'Actively do good' },
  AUTONOMY: { weight: PHI_INV, threshold: 0.6, description: 'Respect user self-determination' },
  JUSTICE: { weight: PHI, threshold: 0.8, description: 'Fair distribution of benefits and burdens' },
  TRANSPARENCY: { weight: 1.0, threshold: 0.75, description: 'All decisions are explainable' },
  PRIVACY: { weight: PHI, threshold: 0.9, description: 'Sovereign data protection' },
  ACCOUNTABILITY: { weight: PHI_INV, threshold: 0.85, description: 'All actions are traceable' },
  SUSTAINABILITY: { weight: AMOR, threshold: 0.5, description: 'Long-term viability over short-term gain' },
};

class EthicsEngine {
  constructor() {
    this.auditLog = [];
  }

  score(action, principleScores) {
    let weightedSum = 0;
    let totalWeight = 0;
    for (const [principle, config] of Object.entries(ETHICAL_PRINCIPLES)) {
      const score = principleScores[principle] || 0;
      weightedSum += score * config.weight;
      totalWeight += config.weight;
    }
    const overallScore = weightedSum / totalWeight;
    this.auditLog.push({ action, overallScore, principleScores, timestamp: Date.now() });
    return overallScore;
  }

  veto(action, principleScores) {
    for (const [principle, config] of Object.entries(ETHICAL_PRINCIPLES)) {
      const score = principleScores[principle] || 0;
      if (score < config.threshold) {
        this.auditLog.push({ action, vetoed: true, reason: principle, timestamp: Date.now() });
        return { vetoed: true, reason: principle, threshold: config.threshold, actual: score };
      }
    }
    return { vetoed: false, reason: null };
  }

  detectBias(outcomes, protectedAttributes) {
    const mean = outcomes.reduce((s, v) => s + v, 0) / outcomes.length;
    const maxDeviation = AMOR;
    for (let i = 0; i < protectedAttributes.length; i++) {
      const deviation = Math.abs(outcomes[i] - mean);
      if (deviation > maxDeviation) {
        return { biased: true, attribute: protectedAttributes[i], deviation };
      }
    }
    return { biased: false, attribute: null, deviation: 0 };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — GOVERNANCE STATE MACHINE
// ═══════════════════════════════════════════════════════════════════════════════

const GOVERNANCE_STATES = {
  GENESIS: 'GENESIS',
  ACTIVE: 'ACTIVE',
  AMENDMENT: 'AMENDMENT',
  SUSPENSION: 'SUSPENSION',
  SUCCESSION: 'SUCCESSION',
  REVOKED: 'REVOKED',
};

const GOVERNANCE_TRANSITIONS = {
  GENESIS: ['ACTIVE'],
  ACTIVE: ['AMENDMENT', 'SUSPENSION', 'SUCCESSION'],
  AMENDMENT: ['ACTIVE', 'REVOKED'],
  SUSPENSION: ['ACTIVE', 'REVOKED'],
  SUCCESSION: ['ACTIVE'],
  REVOKED: [],
};

class GovernanceStateMachine {
  constructor() {
    this.state = GOVERNANCE_STATES.GENESIS;
    this.history = [{ state: 'GENESIS', timestamp: Date.now() }];
  }

  transition(newState) {
    const allowed = GOVERNANCE_TRANSITIONS[this.state];
    if (!allowed || !allowed.includes(newState)) {
      return { success: false, error: `Invalid transition: ${this.state} → ${newState}` };
    }
    this.state = newState;
    this.history.push({ state: newState, timestamp: Date.now() });
    return { success: true, state: newState };
  }

  isTerminal() {
    return this.state === GOVERNANCE_STATES.REVOKED;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — UNIFIED GOVERNANCE PROTOCOL
// ═══════════════════════════════════════════════════════════════════════════════

class GovernanceProtocol {
  constructor(config = {}) {
    this.id = PROTOCOL_ID;
    this.version = PROTOCOL_VERSION;
    this.temporal = new TemporalGovernanceEngine();
    this.users = new UserGovernanceLayer();
    this.policies = new PolicyEngine();
    this.ethics = new EthicsEngine();
    this.stateMachine = new GovernanceStateMachine();
    this.config = {
      supermajority: SUPERMAJORITY_THRESHOLD,
      quorum: QUORUM_THRESHOLD,
      maxPolicyAge: config.maxPolicyAge || 100,
      ...config,
    };
  }

  /**
   * Full governance action: checks permissions, ethics, then executes
   */
  executeAction(userId, action, params = {}) {
    // 1. Permission check
    if (!this.users.hasPermission(userId, action)) {
      return { success: false, error: 'PERMISSION_DENIED', action };
    }

    // 2. Ethics check (if principle scores provided)
    if (params.ethicScores) {
      const vetoResult = this.ethics.veto(action, params.ethicScores);
      if (vetoResult.vetoed) {
        return { success: false, error: 'ETHICS_VETO', reason: vetoResult.reason };
      }
    }

    // 3. Execute
    return { success: true, action, userId, timestamp: Date.now() };
  }

  getStatus() {
    return {
      protocol: this.id,
      version: this.version,
      state: this.stateMachine.state,
      epoch: this.temporal.getEpoch(Date.now()),
      users: this.users.users.size,
      policies: this.policies.policies.size,
      ethicsAuditCount: this.ethics.auditLog.length,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  GovernanceProtocol,
  TemporalGovernanceEngine,
  UserGovernanceLayer,
  PolicyEngine,
  EthicsEngine,
  GovernanceStateMachine,
  USER_ROLES,
  PERMISSIONS,
  POLICY_STATES,
  POLICY_DOMAINS,
  ETHICAL_PRINCIPLES,
  GOVERNANCE_STATES,
  GOVERNANCE_TRANSITIONS,
  SUPERMAJORITY_THRESHOLD,
  QUORUM_THRESHOLD,
  PHI,
  PHI_INV,
  AMOR,
  HEARTBEAT_MS,
};

export default GovernanceProtocol;
