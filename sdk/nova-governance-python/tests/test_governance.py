"""NOVA Governance SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_governance import *

def test_proposal():
    engine = ProposalEngine()
    p = engine.create("Test Proposal", "Description", "alice")
    assert p.state == ProposalState.DRAFT
    engine.activate(p.proposal_id)
    assert p.state == ProposalState.ACTIVE

def test_voting():
    ve = VotingEngine()
    ve.cast("alice", "prop-1", VoteChoice.FOR, weight=2.0)
    ve.cast("bob", "prop-1", VoteChoice.FOR, weight=1.0)
    ve.cast("carol", "prop-1", VoteChoice.AGAINST, weight=1.0)
    result = ve.tally("prop-1", QuorumType.PHI_WEIGHTED)
    assert result.passed  # 3/4 > PHI_INV

def test_quorum():
    calc = QuorumCalculator()
    result = calc.check(100, 70, QuorumType.PHI_WEIGHTED)
    assert result.met  # 70 > 61.8

def test_quorum_not_met():
    calc = QuorumCalculator()
    result = calc.check(100, 50, QuorumType.PHI_WEIGHTED)
    assert not result.met

def test_council():
    council = Council()
    council.add_member("m1", "Alice", GovernanceRole.SOVEREIGN, 2.0)
    council.add_member("m2", "Bob", GovernanceRole.CITIZEN, 1.0)
    assert council.member_count == 2
    assert council.total_voting_power == 3.0
    assert len(council.sovereigns) == 1

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
