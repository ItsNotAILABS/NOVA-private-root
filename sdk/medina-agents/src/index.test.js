import test from 'node:test';
import assert from 'node:assert/strict';
import { Agent, AGENT_TYPES, AGENT_STATES, DEPLOYMENT_TARGETS } from './index.js';

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
