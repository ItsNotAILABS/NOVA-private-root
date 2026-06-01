"""NOVA Consensus — Consensus Node"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class NodeConfig:
    node_id: str
    phi_weight: float = PHI_INV
    timeout_ms: float = 5000.0


class ConsensusNode:
    """A node participating in BFT consensus."""

    def __init__(self, config: NodeConfig):
        self.config = config
        self.role = NodeRole.VALIDATOR
        self.phase = ConsensusPhase.IDLE
        self._term = 0
        self._voted_for: Optional[str] = None
        self._commit_log: List[str] = []

    @property
    def node_id(self) -> str:
        return self.config.node_id

    @property
    def term(self) -> int:
        return self._term

    def start_new_term(self) -> int:
        self._term += 1
        self._voted_for = None
        return self._term

    def vote_for(self, candidate_id: str) -> bool:
        if self._voted_for is None:
            self._voted_for = candidate_id
            return True
        return False

    def commit(self, block_hash: str) -> None:
        self._commit_log.append(block_hash)
        self.phase = ConsensusPhase.FINALIZED

    @property
    def commit_count(self) -> int:
        return len(self._commit_log)

    def reset_phase(self) -> None:
        self.phase = ConsensusPhase.IDLE
