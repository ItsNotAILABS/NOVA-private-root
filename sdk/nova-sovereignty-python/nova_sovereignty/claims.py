"""NOVA Sovereignty — Claims"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class ClaimVerdict:
    claim_id: str
    approved: bool
    phi_score: float
    reason: str


@dataclass
class Claim:
    claim_id: str
    claimant: str
    claim_type: ClaimType
    statement: str
    evidence_ids: List[str] = field(default_factory=list)
    state: ClaimState = ClaimState.SUBMITTED
    phi_score: float = 0.0
    submitted_ms: float = field(default_factory=lambda: time.time() * 1000)


class ClaimRegistry:
    """Registry of sovereignty claims."""

    def __init__(self):
        self._claims: Dict[str, Claim] = {}

    def submit(self, claimant: str, statement: str,
               claim_type: ClaimType = ClaimType.VERIFIABLE) -> Claim:
        cid = hashlib.sha256(f"{claimant}{statement}{time.time()}".encode()).hexdigest()[:16]
        claim = Claim(claim_id=cid, claimant=claimant, claim_type=claim_type, statement=statement)
        self._claims[cid] = claim
        return claim

    def review(self, claim_id: str, phi_score: float) -> Optional[ClaimVerdict]:
        claim = self._claims.get(claim_id)
        if not claim:
            return None
        claim.phi_score = phi_score
        approved = phi_score >= CERT_THRESHOLD
        claim.state = ClaimState.CERTIFIED if approved else ClaimState.REVOKED
        return ClaimVerdict(claim_id=claim_id, approved=approved,
                          phi_score=phi_score, reason="φ-score threshold")

    def revoke(self, claim_id: str) -> bool:
        if claim_id in self._claims:
            self._claims[claim_id].state = ClaimState.REVOKED
            return True
        return False

    def get(self, claim_id: str) -> Optional[Claim]:
        return self._claims.get(claim_id)

    @property
    def total(self) -> int:
        return len(self._claims)

    @property
    def certified_count(self) -> int:
        return sum(1 for c in self._claims.values() if c.state == ClaimState.CERTIFIED)
