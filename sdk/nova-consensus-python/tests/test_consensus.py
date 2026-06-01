"""NOVA Consensus SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_consensus import *

def test_node():
    config = NodeConfig(node_id="node-1")
    node = ConsensusNode(config)
    assert node.node_id == "node-1"
    assert node.role == NodeRole.VALIDATOR

def test_blockchain():
    chain = BlockChain()
    assert chain.height == 1  # genesis
    block = chain.propose("tx-data", "node-1")
    assert chain.append(block)
    assert chain.height == 2

def test_bft_voting():
    bft = BFTVoting(total_nodes=5)
    for i in range(4):
        bft.cast(f"node-{i}", "block-hash-1", VoteType.VOTE)
    result = bft.tally("block-hash-1")
    assert result.approved

def test_bft_no_quorum():
    bft = BFTVoting(total_nodes=10)
    bft.cast("node-0", "block-1", VoteType.VOTE)
    result = bft.tally("block-1")
    assert not result.approved

def test_leader_election():
    import random
    random.seed(42)
    nodes = [f"node-{i}" for i in range(5)]
    election = LeaderElection(nodes)
    result = election.start_election("node-0")
    assert result.total_nodes == 5
    # With seed 42, result is deterministic

if __name__ == "__main__":
    tests = [f for f in dir() if f.startswith("test_")]
    passed = 0
    for t in tests:
        try:
            eval(f"{t}()")
            passed += 1
            print(f"  ✓ {t}")
        except Exception as e:
            print(f"  ✗ {t}: {e}")
    print(f"\n{passed}/{len(tests)} tests passed")
