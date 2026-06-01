"""NOVA Governance — Proposals"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class Proposal:
    proposal_id: str
    title: str
    description: str
    proposer: str
    state: ProposalState = ProposalState.DRAFT
    quorum_type: QuorumType = QuorumType.PHI_WEIGHTED
    created_ms: float = field(default_factory=lambda: time.time() * 1000)
    deadline_ms: float = 0.0


class ProposalEngine:
    """Manages proposal lifecycle."""

    def __init__(self, voting_period_ms: float = 86400000):  # 24h default
        self.voting_period_ms = voting_period_ms
        self._proposals: Dict[str, Proposal] = {}

    def create(self, title: str, description: str, proposer: str,
               quorum: QuorumType = QuorumType.PHI_WEIGHTED) -> Proposal:
        pid = hashlib.sha256(f"{title}{time.time()}".encode()).hexdigest()[:16]
        now = time.time() * 1000
        prop = Proposal(
            proposal_id=pid, title=title, description=description,
            proposer=proposer, quorum_type=quorum,
            deadline_ms=now + self.voting_period_ms,
        )
        self._proposals[pid] = prop
        return prop

    def activate(self, proposal_id: str) -> bool:
        p = self._proposals.get(proposal_id)
        if p and p.state == ProposalState.DRAFT:
            p.state = ProposalState.ACTIVE
            return True
        return False

    def resolve(self, proposal_id: str, passed: bool) -> bool:
        p = self._proposals.get(proposal_id)
        if p and p.state == ProposalState.ACTIVE:
            p.state = ProposalState.PASSED if passed else ProposalState.REJECTED
            return True
        return False

    def execute(self, proposal_id: str) -> bool:
        p = self._proposals.get(proposal_id)
        if p and p.state == ProposalState.PASSED:
            p.state = ProposalState.EXECUTED
            return True
        return False

    def get(self, proposal_id: str) -> Optional[Proposal]:
        return self._proposals.get(proposal_id)

    @property
    def active_count(self) -> int:
        return sum(1 for p in self._proposals.values() if p.state == ProposalState.ACTIVE)

    @property
    def total(self) -> int:
        return len(self._proposals)
