"""NOVA Governance — Voting"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *


@dataclass
class Vote:
    voter: str
    proposal_id: str
    choice: VoteChoice
    weight: float = 1.0
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


@dataclass
class VoteResult:
    proposal_id: str
    votes_for: float
    votes_against: float
    votes_abstain: float
    total_weight: float
    passed: bool


class VotingEngine:
    """φ-weighted voting engine."""

    def __init__(self):
        self._votes: Dict[str, List[Vote]] = {}

    def cast(self, voter: str, proposal_id: str, choice: VoteChoice,
             weight: float = 1.0) -> Vote:
        vote = Vote(voter=voter, proposal_id=proposal_id, choice=choice, weight=weight)
        self._votes.setdefault(proposal_id, []).append(vote)
        return vote

    def tally(self, proposal_id: str, quorum_type: QuorumType = QuorumType.PHI_WEIGHTED) -> VoteResult:
        votes = self._votes.get(proposal_id, [])
        v_for = sum(v.weight for v in votes if v.choice == VoteChoice.FOR)
        v_against = sum(v.weight for v in votes if v.choice == VoteChoice.AGAINST)
        v_abstain = sum(v.weight for v in votes if v.choice == VoteChoice.ABSTAIN)
        total = v_for + v_against + v_abstain

        if quorum_type == QuorumType.SIMPLE_MAJORITY:
            passed = v_for > v_against
        elif quorum_type == QuorumType.SUPER_MAJORITY:
            passed = v_for >= total * 2/3
        elif quorum_type == QuorumType.PHI_WEIGHTED:
            passed = v_for >= total * PHI_INV
        else:  # UNANIMOUS
            passed = v_against == 0 and v_for > 0

        return VoteResult(
            proposal_id=proposal_id, votes_for=v_for,
            votes_against=v_against, votes_abstain=v_abstain,
            total_weight=total, passed=passed,
        )

    def voter_count(self, proposal_id: str) -> int:
        return len(self._votes.get(proposal_id, []))
