"""NOVA Trust — Attestation Registry"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class Attestation:
    attestation_id: str
    attester: str
    subject: str
    att_type: AttestationType
    claim: str
    confidence: float = 1.0
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)
    valid: bool = True


class AttestationRegistry:
    """Registry of peer attestations."""

    def __init__(self):
        self._attestations: Dict[str, Attestation] = {}

    def attest(self, attester: str, subject: str, claim: str,
               att_type: AttestationType = AttestationType.PEER,
               confidence: float = 1.0) -> Attestation:
        aid = hashlib.sha256(f"{attester}{subject}{claim}{time.time()}".encode()).hexdigest()[:16]
        att = Attestation(attestation_id=aid, attester=attester, subject=subject,
                         att_type=att_type, claim=claim, confidence=confidence)
        self._attestations[aid] = att
        return att

    def revoke(self, attestation_id: str) -> bool:
        if attestation_id in self._attestations:
            self._attestations[attestation_id].valid = False
            return True
        return False

    def get_for_subject(self, subject: str) -> List[Attestation]:
        return [a for a in self._attestations.values() if a.subject == subject and a.valid]

    def consensus_score(self, subject: str) -> float:
        atts = self.get_for_subject(subject)
        if not atts:
            return 0.0
        return sum(a.confidence for a in atts) / len(atts)

    @property
    def total(self) -> int:
        return len(self._attestations)
