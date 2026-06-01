"""NOVA Sovereignty — Evidence Matrix"""
import time
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *


@dataclass
class Evidence:
    evidence_id: str
    grade: EvidenceGrade
    description: str
    phi_weight: float = 1.0
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class EvidenceMatrix:
    """Evidence matrix for claim evaluation."""

    def __init__(self):
        self._evidence: Dict[str, List[Evidence]] = {}
        self._grade_weights = {
            EvidenceGrade.FORMAL_PROOF: 1.0,
            EvidenceGrade.EMPIRICAL: PHI_INV,
            EvidenceGrade.TESTIMONIAL: PHI_INV ** 2,
            EvidenceGrade.SELF_REPORT: PHI_INV ** 3,
            EvidenceGrade.NONE: 0.0,
        }

    def add(self, claim_id: str, grade: EvidenceGrade, description: str) -> Evidence:
        import hashlib
        eid = hashlib.sha256(f"{claim_id}{description}{time.time()}".encode()).hexdigest()[:12]
        ev = Evidence(evidence_id=eid, grade=grade, description=description,
                     phi_weight=self._grade_weights[grade])
        self._evidence.setdefault(claim_id, []).append(ev)
        return ev

    def score(self, claim_id: str) -> float:
        evs = self._evidence.get(claim_id, [])
        if not evs:
            return 0.0
        total = sum(e.phi_weight for e in evs)
        return min(1.0, total / len(evs))

    def get_evidence(self, claim_id: str) -> List[Evidence]:
        return self._evidence.get(claim_id, [])
