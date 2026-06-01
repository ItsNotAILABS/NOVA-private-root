"""NOVA Consensus — BFT Voting"""
import time
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *


@dataclass
class BFTVote:
    voter: str
    block_hash: str
    vote_type: VoteType
    phi_weight: float = PHI_INV
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


@dataclass
class BFTResult:
    block_hash: str
    total_weight: float
    threshold: float
    approved: bool
    vote_count: int


class BFTVoting:
    """Byzantine Fault Tolerant voting with φ-weighted votes."""

    def __init__(self, total_nodes: int):
        self.total_nodes = total_nodes
        self._votes: Dict[str, List[BFTVote]] = {}

    def cast(self, voter: str, block_hash: str, vote_type: VoteType = VoteType.VOTE,
             weight: float = PHI_INV) -> BFTVote:
        vote = BFTVote(voter=voter, block_hash=block_hash,
                      vote_type=vote_type, phi_weight=weight)
        self._votes.setdefault(block_hash, []).append(vote)
        return vote

    def tally(self, block_hash: str) -> BFTResult:
        votes = self._votes.get(block_hash, [])
        total_weight = sum(v.phi_weight for v in votes)
        threshold = self.total_nodes * BFT_THRESHOLD * PHI_INV
        approved = total_weight >= threshold

        return BFTResult(
            block_hash=block_hash,
            total_weight=total_weight,
            threshold=threshold,
            approved=approved,
            vote_count=len(votes),
        )

    def has_quorum(self, block_hash: str) -> bool:
        result = self.tally(block_hash)
        return result.approved

    def clear(self, block_hash: str) -> None:
        self._votes.pop(block_hash, None)
