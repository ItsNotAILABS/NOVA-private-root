"""NOVA Consensus — Block & Chain"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional
from .constants import *


@dataclass
class Block:
    block_number: int
    previous_hash: str
    data: Any
    proposer: str
    state: BlockState = BlockState.PROPOSED
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)
    block_hash: str = ""

    def __post_init__(self):
        if not self.block_hash:
            content = f"{self.block_number}{self.previous_hash}{self.data}{self.proposer}"
            self.block_hash = hashlib.sha256(content.encode()).hexdigest()[:32]


class BlockChain:
    """Simple in-memory blockchain for consensus."""

    def __init__(self):
        genesis = Block(block_number=0, previous_hash="0"*32,
                       data="GENESIS", proposer="SYSTEM")
        genesis.state = BlockState.FINALIZED
        self._chain: List[Block] = [genesis]

    def propose(self, data: Any, proposer: str) -> Block:
        prev = self._chain[-1]
        block = Block(
            block_number=len(self._chain),
            previous_hash=prev.block_hash,
            data=data, proposer=proposer,
        )
        return block

    def append(self, block: Block) -> bool:
        if block.previous_hash != self._chain[-1].block_hash:
            return False
        block.state = BlockState.FINALIZED
        self._chain.append(block)
        return True

    @property
    def height(self) -> int:
        return len(self._chain)

    @property
    def latest(self) -> Block:
        return self._chain[-1]

    def get_block(self, number: int) -> Optional[Block]:
        if 0 <= number < len(self._chain):
            return self._chain[number]
        return None
