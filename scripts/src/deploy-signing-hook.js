'use strict';

/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA DEPLOY SIGNING HOOK
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Wires the Internal AI Identity Registry into the deployment pipeline.
 * When an internal AI agent performs a deploy action, this hook stamps the
 * output with the agent's name + emoji signature.
 *
 * Usage (from deploy scripts):
 *   const hook = require('./deploy-signing-hook');
 *   const result = hook.signDeployAction('ANI-AGI-001', 'swarm_brain', 'ic');
 *   console.log(result.signature); // "ANIMUS MAXIMUS 🔥"
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * ═══════════════════════════════════════════════════════════════════════════════
 */

const { registry, signAction, signCommit, signReport } = require('./living-libraries/index');

/**
 * Sign a deployment action with the deploying agent's identity.
 * @param {string} agentId - The internal AI agent performing the deploy
 * @param {string} canisterName - Name of the canister being deployed
 * @param {string} network - Target network (ic, local, etc.)
 * @param {Object} metadata - Additional deploy metadata
 * @returns {Object} Signed deploy record
 */
function signDeployAction(agentId, canisterName, network, metadata = {}) {
  return signAction(agentId, 'deploy', {
    canister: canisterName,
    network,
    deployedAt: new Date().toISOString(),
    ...metadata,
  });
}

/**
 * Sign a deploy commit message with the deploying agent's identity.
 * @param {string} agentId - The internal AI agent performing the deploy
 * @param {string} commitMessage - The commit message to sign
 * @returns {string} Commit message with signature footer
 */
function signDeployCommit(agentId, commitMessage) {
  return signCommit(agentId, commitMessage);
}

/**
 * Sign a deployment report with the agent's identity.
 * @param {string} agentId - The internal AI agent generating the report
 * @param {string} reportTitle - Report title
 * @returns {Object} Signed report object
 */
function signDeployReport(agentId, reportTitle) {
  return signReport(agentId, reportTitle);
}

/**
 * Format a deploy log line with agent signature.
 * @param {string} agentId - The agent performing the action
 * @param {string} message - Log message
 * @returns {string} Formatted log with emoji prefix
 */
function formatDeployLog(agentId, message) {
  const identity = registry.identities.get(agentId);
  if (!identity) {
    return `🤖 [Unknown Agent] ${message}`;
  }
  return `${identity.emoji} [${identity.name}] ${message}`;
}

module.exports = {
  signDeployAction,
  signDeployCommit,
  signDeployReport,
  formatDeployLog,
};
