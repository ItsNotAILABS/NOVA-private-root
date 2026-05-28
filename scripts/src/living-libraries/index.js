'use strict';

/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * LIVING LIBRARIES — Index
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Bootstraps the global Internal AI Identity Registry with all fleet identities.
 * Import this file to get a ready-to-use registry with every internal AI agent
 * pre-registered and their emoji signatures active.
 *
 * Usage:
 *   const { registry, signCommit, signReport, signAction } = require('./index');
 *   const signed = signCommit('ANI-AGI-001', 'deploy swarm_brain canister');
 *   // → "deploy swarm_brain canister\n\nSigned-by: ANIMUS MAXIMUS 🔥"
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * ═══════════════════════════════════════════════════════════════════════════════
 */

const {
  InternalAIIdentityRegistry,
  DEFAULT_INTERNAL_AI_EMOJI,
} = require('./internal-ai-identity-registry');

const { ALL_IDENTITIES } = require('./fleet-identities');

// ═══ Bootstrap the global registry with all fleet identities ═══

const registry = new InternalAIIdentityRegistry();

for (const identity of ALL_IDENTITIES) {
  registry.register(identity);
}

// ═══ Convenience functions bound to the global registry ═══

function signCommit(agentId, commitMessage) {
  return registry.signCommit(agentId, commitMessage);
}

function signReport(agentId, reportTitle) {
  return registry.signReport(agentId, reportTitle);
}

function signAction(agentId, actionType, details) {
  const identity = registry.identities.get(agentId);
  if (!identity) {
    return {
      actionType,
      details,
      signedBy: 'Unknown Agent',
      emoji: DEFAULT_INTERNAL_AI_EMOJI,
      signature: `Unknown Agent ${DEFAULT_INTERNAL_AI_EMOJI}`,
      signedAt: Date.now(),
    };
  }
  const signature = `${identity.name} ${identity.emoji}`;
  return {
    actionType,
    details,
    signedBy: identity.name,
    agentId: identity.agentId,
    emoji: identity.emoji,
    signature,
    signedAt: Date.now(),
  };
}

function getIdentity(agentId) {
  return registry.identities.get(agentId) || null;
}

function listIdentities() {
  return Array.from(registry.identities.values());
}

module.exports = {
  registry,
  signCommit,
  signReport,
  signAction,
  getIdentity,
  listIdentities,
  InternalAIIdentityRegistry,
  DEFAULT_INTERNAL_AI_EMOJI,
  ALL_IDENTITIES,
};
