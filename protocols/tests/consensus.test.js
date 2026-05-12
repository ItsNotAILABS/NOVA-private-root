import test from 'node:test';
import assert from 'node:assert/strict';
import { Proposal, PROPOSAL_STATES, VOTE_TYPES, ConsensusNode } from '../PROTOCOL-CONSENSUS.js';

test('Proposal accepts when quorum is reached with majority FOR votes', () => {
  const proposal = new Proposal('feature.flag', true, { quorum: 0.5 });
  proposal.vote('n1', VOTE_TYPES.FOR, 1);
  proposal.vote('n2', VOTE_TYPES.FOR, 1);

  const decision = proposal.canDecide(3);
  assert.equal(decision.canDecide, true);
  assert.equal(decision.result, PROPOSAL_STATES.ACCEPTED);
});

test('Proposal stays undecided when participation is below quorum', () => {
  const proposal = new Proposal('feature.flag', true, { quorum: 0.8 });
  proposal.vote('n1', VOTE_TYPES.FOR, 1);

  const decision = proposal.canDecide(3);
  assert.equal(decision.canDecide, false);
  assert.equal(decision.reason, 'insufficient_participation');
});

test('ConsensusNode peer count includes self', () => {
  const node = new ConsensusNode('node-a');
  node.addPeer('node-b').addPeer('node-c');
  assert.equal(node.getTotalNodes(), 3);
});
