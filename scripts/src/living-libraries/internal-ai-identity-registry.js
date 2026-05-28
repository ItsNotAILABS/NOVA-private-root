'use strict';

const DEFAULT_INTERNAL_AI_EMOJI = '🤖';

class InternalAIIdentityRegistry {
  constructor(config = {}) {
    this.defaultEmoji = config.defaultEmoji || DEFAULT_INTERNAL_AI_EMOJI;
    this.identities = new Map();
  }

  register(identity = {}) {
    if (!identity.agentId) throw new Error('Identity must include agentId');
    if (!identity.name) throw new Error('Identity must include name');

    const record = {
      agentId: identity.agentId,
      name: identity.name,
      role: identity.role || 'internal_ai',
      emoji: identity.emoji || this.defaultEmoji,
      createdAt: identity.createdAt || Date.now(),
      updatedAt: Date.now(),
    };

    this.identities.set(record.agentId, record);
    return { ...record };
  }

  signCommit(agentId, commitMessage) {
    const identity = this.identities.get(agentId);
    if (!identity) throw new Error(`Identity not found for agent: ${agentId}`);
    const signature = `${identity.name} ${identity.emoji}`;
    return `${commitMessage}\n\nSigned-by: ${signature}`;
  }

  signReport(agentId, reportTitle) {
    const identity = this.identities.get(agentId);
    if (!identity) throw new Error(`Identity not found for agent: ${agentId}`);
    const signature = `${identity.name} ${identity.emoji}`;
    return {
      title: reportTitle,
      signedBy: identity.name,
      emoji: identity.emoji,
      footer: `Signed by ${signature}`,
      signedAt: Date.now(),
    };
  }
}

const globalInternalAIIdentityRegistry = new InternalAIIdentityRegistry();

module.exports = {
  DEFAULT_INTERNAL_AI_EMOJI,
  InternalAIIdentityRegistry,
  globalInternalAIIdentityRegistry,
};
