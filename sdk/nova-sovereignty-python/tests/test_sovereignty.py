"""NOVA Sovereignty SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_sovereignty import *

def test_claim_submit():
    reg = ClaimRegistry()
    c = reg.submit("alice", "I am sovereign", ClaimType.VERIFIABLE)
    assert c.state == ClaimState.SUBMITTED
    assert reg.total == 1

def test_claim_review():
    reg = ClaimRegistry()
    c = reg.submit("alice", "claim1")
    v = reg.review(c.claim_id, 0.7)
    assert v.approved  # 0.7 > PHI_INV

def test_validator():
    v = SovereigntyValidator()
    evidence = {"DR-1": 0.8, "DR-2": 0.7, "DR-3": 0.5, "DR-4": 0.6, "DR-5": 0.4, "DR-6": 0.9}
    result = v.validate(evidence)
    assert isinstance(result.phi_score, float)

def test_certificate_issue():
    ca = CertificateAuthority()
    cert = ca.issue("entity-1", 0.8)
    assert cert is not None
    assert ca.active_count == 1

def test_certificate_below_threshold():
    ca = CertificateAuthority()
    cert = ca.issue("entity-1", 0.3)
    assert cert is None

def test_certificate_verify():
    ca = CertificateAuthority()
    cert = ca.issue("entity-1", 0.9)
    assert ca.verify(cert.cert_id)

def test_evidence_matrix():
    em = EvidenceMatrix()
    em.add("claim-1", EvidenceGrade.FORMAL_PROOF, "mathematical proof")
    em.add("claim-1", EvidenceGrade.EMPIRICAL, "test results")
    score = em.score("claim-1")
    assert score > 0

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
