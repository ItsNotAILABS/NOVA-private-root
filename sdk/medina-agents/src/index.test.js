import test from 'node:test';
import assert from 'node:assert/strict';
import {
  Agent,
  AGENT_TYPES,
  AGENT_STATES,
  DEPLOYMENT_TARGETS,
  InternalAIIdentityRegistry,
  DEFAULT_INTERNAL_AI_EMOJI,
} from './index.js';

test('Agent defaults to INTERNAL type and dormant state', () => {
  const agent = new Agent({ name: 'test-agent' });
  assert.equal(agent.type, AGENT_TYPES.INTERNAL);
  assert.equal(agent.state, AGENT_STATES.DORMANT);
});

test('Agent lifecycle moves dormant -> alive -> hibernating -> dead', async () => {
  const agent = new Agent({ name: 'lifecycle-agent' });
  await agent.awaken();
  assert.equal(agent.state, AGENT_STATES.ALIVE);

  await agent.hibernate();
  assert.equal(agent.state, AGENT_STATES.HIBERNATING);

  await agent.terminate();
  assert.equal(agent.state, AGENT_STATES.DEAD);
});

test('Agent deploy rejects invalid target', async () => {
  const agent = new Agent({ name: 'deploy-agent' });
  await assert.rejects(() => agent.deploy('INVALID_TARGET'), /Invalid deployment target/);
  assert.equal(Object.values(DEPLOYMENT_TARGETS).includes('INVALID_TARGET'), false);
});

test('InternalAIIdentityRegistry registers identity with custom emoji', () => {
  const registry = new InternalAIIdentityRegistry();
  const identity = registry.register({
    agentId: 'agent-1',
    name: 'NOVA Builder',
    emoji: '🛠️',
  });

  assert.equal(identity.agentId, 'agent-1');
  assert.equal(identity.name, 'NOVA Builder');
  assert.equal(identity.emoji, '🛠️');
});

test('InternalAIIdentityRegistry uses default emoji when none is provided', () => {
  const registry = new InternalAIIdentityRegistry();
  const identity = registry.register({
    agentId: 'agent-2',
    name: 'NOVA Reporter',
  });

  assert.equal(identity.emoji, DEFAULT_INTERNAL_AI_EMOJI);
});

test('InternalAIIdentityRegistry signs commit and report with name + emoji', () => {
  const registry = new InternalAIIdentityRegistry();
  registry.register({
    agentId: 'agent-3',
    name: 'NOVA Deployer',
    emoji: '🚀',
  });

  const signedCommit = registry.signCommit('agent-3', 'deploy mainnet');
  const signedReport = registry.signReport('agent-3', 'deployment status');

  assert.match(signedCommit.signedCommitMessage, /Signed-by: NOVA Deployer 🚀/);
  assert.equal(signedReport.reportFooter, 'Signed by NOVA Deployer 🚀');
});
