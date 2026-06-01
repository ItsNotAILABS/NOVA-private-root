"""NOVA Consensus — Leader Election"""
import time
import hashlib
import random
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class ElectionResult:
    term: int
    leader_id: Optional[str]
    votes_received: int
    total_nodes: int
    success: bool


class LeaderElection:
    """φ-weighted leader election (Raft-like)."""

    def __init__(self, nodes: List[str]):
        self._nodes = nodes
        self._term = 0
        self._leader: Optional[str] = None
        self._votes: Dict[str, str] = {}  # voter -> candidate

    def start_election(self, candidate_id: str) -> ElectionResult:
        """Start a new election term."""
        self._term += 1
        self._votes.clear()
        self._votes[candidate_id] = candidate_id  # vote for self

        # Simulate other nodes voting (φ-weighted probability)
        for node in self._nodes:
            if node == candidate_id:
                continue
            # Each node votes with probability based on candidate score
            if random.random() < PHI_INV:
                self._votes[node] = candidate_id

        votes_received = sum(1 for v in self._votes.values() if v == candidate_id)
        majority = len(self._nodes) // 2 + 1
        success = votes_received >= majority

        if success:
            self._leader = candidate_id

        return ElectionResult(
            term=self._term, leader_id=candidate_id if success else None,
            votes_received=votes_received, total_nodes=len(self._nodes),
            success=success,
        )

    @property
    def current_leader(self) -> Optional[str]:
        return self._leader

    @property
    def current_term(self) -> int:
        return self._term
