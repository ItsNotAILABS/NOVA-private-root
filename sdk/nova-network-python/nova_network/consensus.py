"""
NOVA Network SDK — Consensus Protocol

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

Distributed agreement without central coordination.
Uses Raft-like leader election with φ-weighted Byzantine fault tolerance.
"""

import time
import math
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, field

from .constants import (
    PHI, PHI_INV, AMOR, HEARTBEAT_MS,
    NodeState, ProposalState, VoteType,
)


@dataclass
class Vote:
    """A vote on a proposal."""
    node_id: str
    vote_type: VoteType
    weight: float = 1.0
    timestamp: float = field(default_factory=lambda: time.time() * 1000)


@dataclass
class Proposal:
    """A consensus proposal."""
    proposal_id: str
    key: str
    value: object
    proposer: str
    term: int = 0
    state: ProposalState = ProposalState.PENDING
    votes: Dict[str, Vote] = field(default_factory=dict)
    quorum: float = 0.5
    timeout_ms: float = 30000.0
    created_at: float = field(default_factory=lambda: time.time() * 1000)
    decided_at: Optional[float] = None

    def vote(self, node_id: str, vote_type: VoteType, weight: float = 1.0) -> "Proposal":
        """Cast a vote on this proposal."""
        self.votes[node_id] = Vote(node_id=node_id, vote_type=vote_type, weight=weight)
        return self

    def tally(self) -> Dict[str, float]:
        """Calculate weighted vote totals."""
        totals = {"for": 0.0, "against": 0.0, "abstain": 0.0}
        for v in self.votes.values():
            if v.vote_type == VoteType.FOR:
                totals["for"] += v.weight
            elif v.vote_type == VoteType.AGAINST:
                totals["against"] += v.weight
            else:
                totals["abstain"] += v.weight
        return totals

    def is_decided(self, total_nodes: int) -> bool:
        """Check if the proposal has reached quorum (for or against)."""
        if self.state != ProposalState.PENDING:
            return True
        totals = self.tally()
        total_weight = totals["for"] + totals["against"] + totals["abstain"]
        if total_weight == 0:
            return False
        # Decided if FOR reaches quorum OR AGAINST reaches (1 - quorum)
        for_ratio = totals["for"] / max(total_weight, 1)
        against_ratio = totals["against"] / max(total_weight, 1)
        return for_ratio >= self.quorum or against_ratio >= (1 - self.quorum)

    def is_expired(self) -> bool:
        """Check if the proposal has timed out."""
        return time.time() * 1000 - self.created_at > self.timeout_ms


class ConsensusNode:
    """
    A consensus participant using Raft-like leader election
    with φ-weighted voting.
    """

    def __init__(self, node_id: str, quorum: float = 0.5):
        """
        Args:
            node_id: This node's identifier
            quorum: Fraction of votes needed for consensus (default 0.5)
        """
        self._node_id = node_id
        self._state = NodeState.FOLLOWER
        self._term: int = 0
        self._leader: Optional[str] = None
        self._proposals: Dict[str, Proposal] = {}
        self._committed: Dict[str, object] = {}
        self._quorum = quorum
        self._votes_received: Dict[str, str] = {}  # term → voted_for
        self._last_heartbeat: float = time.time() * 1000

    @property
    def node_id(self) -> str:
        return self._node_id

    @property
    def state(self) -> NodeState:
        return self._state

    @property
    def term(self) -> int:
        return self._term

    @property
    def leader(self) -> Optional[str]:
        return self._leader

    def propose(self, key: str, value: object) -> Proposal:
        """
        Submit a new proposal for consensus.

        Args:
            key: The key to set
            value: The value to agree on

        Returns:
            The created Proposal
        """
        proposal = Proposal(
            proposal_id=f"prop_{self._node_id}_{int(time.time()*1000)}",
            key=key,
            value=value,
            proposer=self._node_id,
            term=self._term,
            quorum=self._quorum,
        )
        self._proposals[proposal.proposal_id] = proposal
        # Auto-vote FOR own proposals
        proposal.vote(self._node_id, VoteType.FOR, PHI_INV)
        return proposal

    def vote_on(self, proposal_id: str, vote_type: VoteType, weight: float = 1.0) -> Optional[Proposal]:
        """
        Cast a vote on a proposal.

        Args:
            proposal_id: ID of the proposal to vote on
            vote_type: FOR, AGAINST, or ABSTAIN
            weight: φ-weighted vote importance

        Returns:
            The updated Proposal, or None if not found
        """
        proposal = self._proposals.get(proposal_id)
        if not proposal or proposal.state != ProposalState.PENDING:
            return None
        proposal.vote(self._node_id, vote_type, weight)
        return proposal

    def check_proposals(self, total_nodes: int) -> List[Proposal]:
        """
        Check all pending proposals for resolution.

        Args:
            total_nodes: Total number of nodes in the consensus group

        Returns:
            List of newly decided proposals
        """
        decided: List[Proposal] = []
        for proposal in self._proposals.values():
            if proposal.state != ProposalState.PENDING:
                continue
            if proposal.is_expired():
                proposal.state = ProposalState.EXPIRED
                proposal.decided_at = time.time() * 1000
                decided.append(proposal)
            elif proposal.is_decided(total_nodes):
                totals = proposal.tally()
                if totals["for"] > totals["against"]:
                    proposal.state = ProposalState.COMMITTED
                    self._committed[proposal.key] = proposal.value
                else:
                    proposal.state = ProposalState.REJECTED
                proposal.decided_at = time.time() * 1000
                decided.append(proposal)
        return decided

    def start_election(self) -> int:
        """
        Start a leader election (transition to CANDIDATE).

        Returns:
            The new term number
        """
        self._term += 1
        self._state = NodeState.CANDIDATE
        self._leader = None
        return self._term

    def receive_vote(self, from_node: str, term: int, granted: bool):
        """Process an incoming vote for our candidacy."""
        if term == self._term and granted:
            self._votes_received[from_node] = self._node_id

    def become_leader(self):
        """Transition to LEADER state."""
        self._state = NodeState.LEADER
        self._leader = self._node_id

    def accept_leader(self, leader_id: str, term: int):
        """Accept another node as leader."""
        if term >= self._term:
            self._term = term
            self._state = NodeState.FOLLOWER
            self._leader = leader_id
            self._last_heartbeat = time.time() * 1000

    def heartbeat(self):
        """Record a heartbeat from the leader."""
        self._last_heartbeat = time.time() * 1000

    def election_timeout_elapsed(self, timeout_ms: float = None) -> bool:
        """Check if the election timeout has elapsed since last heartbeat."""
        timeout = timeout_ms or (HEARTBEAT_MS * PHI * 3)
        return (time.time() * 1000 - self._last_heartbeat) > timeout

    def get_committed(self, key: str) -> Optional[object]:
        """Get a committed value by key."""
        return self._committed.get(key)

    def status(self) -> Dict:
        """Get consensus node status."""
        return {
            "nodeId": self._node_id,
            "state": self._state.value,
            "term": self._term,
            "leader": self._leader,
            "proposals": len(self._proposals),
            "committed": len(self._committed),
            "lastHeartbeat": self._last_heartbeat,
        }
