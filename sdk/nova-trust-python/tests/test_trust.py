"""NOVA Trust SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from nova_trust import (
    PHI, PHI_INV, TrustLevel, AttestationType, DecayMode,
    TrustScore, TrustScorer,
    Attestation, AttestationRegistry,
    ReputationEngine, PeerReputation,
    DecayEngine,
)

def test_scorer():
    scorer = TrustScorer()
    ts = scorer.record_interaction("node-1", positive=True)
    assert ts.score > 0.5

def test_scorer_negative():
    scorer = TrustScorer()
    scorer.record_interaction("node-1", positive=False)
    ts = scorer.get_score("node-1")
    assert ts.score < 0.5

def test_attestation():
    reg = AttestationRegistry()
    att = reg.attest("alice", "bob", "is_reliable")
    assert reg.total == 1
    assert att.valid

def test_attestation_revoke():
    reg = AttestationRegistry()
    att = reg.attest("alice", "bob", "claim1")
    reg.revoke(att.attestation_id)
    assert len(reg.get_for_subject("bob")) == 0

def test_reputation():
    scorer = TrustScorer()
    for i in range(5):
        scorer.record_interaction(f"node-{i}", positive=True)
    engine = ReputationEngine(scorer)
    rankings = engine.rankings(3)
    assert len(rankings) <= 3

def test_decay():
    scorer = TrustScorer()
    scorer.record_interaction("node-1", positive=True, weight=5.0)
    engine = DecayEngine(scorer)
    affected = engine.apply_decay(24.0)
    assert affected >= 1

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
