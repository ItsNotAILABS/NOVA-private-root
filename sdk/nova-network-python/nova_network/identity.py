"""
NOVA Network SDK — Sovereign Node Identity

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

Each NOVA node has a sovereign address derived from its Phantom wallet.
The address encodes: node type, shard affinity, and φ-resonance frequency.
"""

import os
import time
import math
from dataclasses import dataclass, field
from typing import List, Optional

from .constants import PHI, PHI_INV, DHT_SHARDS, NodeType


def secure_id(n: int = 16) -> str:
    """Generate a cryptographically secure hex identifier."""
    return os.urandom(n).hex()


def _compute_shard(raw_id: str) -> int:
    """Deterministic shard assignment from node ID."""
    h = 0
    for c in raw_id:
        h = ((h * 31) + ord(c)) & 0xFFFFFFFF
    return h % DHT_SHARDS


@dataclass
class SovereignNodeIdentity:
    """A sovereign node identity in the NOVA mesh."""
    node_id: str
    node_type: NodeType
    wallet_address: str
    shard: int
    freq: float
    region: str
    capabilities: List[str]
    created_at: float
    sovereignty: float = field(default=PHI_INV)

    def to_dict(self) -> dict:
        return {
            "nodeId": self.node_id,
            "type": self.node_type.value,
            "walletAddress": self.wallet_address,
            "shard": self.shard,
            "freq": self.freq,
            "region": self.region,
            "capabilities": self.capabilities,
            "createdAt": self.created_at,
            "sovereignty": self.sovereignty,
        }


def create_node_identity(
    node_type: NodeType = NodeType.SOVEREIGN,
    wallet_address: Optional[str] = None,
    region: str = "UNKNOWN",
    capabilities: Optional[List[str]] = None,
) -> SovereignNodeIdentity:
    """
    Create a sovereign node identity.

    Args:
        node_type: Type of node (SOVEREIGN, RELAY, EDGE, PHANTOM)
        wallet_address: Phantom wallet address (auto-generated if None)
        region: Geographic region identifier
        capabilities: List of node capabilities

    Returns:
        SovereignNodeIdentity instance
    """
    raw_id = wallet_address if wallet_address else secure_id(20)
    shard = _compute_shard(raw_id)
    shard_int = 0
    for c in raw_id:
        shard_int = ((shard_int * 31) + ord(c)) & 0xFFFFFFFF
    freq = round(PHI * (1 + (shard_int % 100) / 100), 6)

    return SovereignNodeIdentity(
        node_id=f"NOVA-NODE-{raw_id[:8].upper()}",
        node_type=node_type,
        wallet_address=raw_id,
        shard=shard,
        freq=freq,
        region=region,
        capabilities=capabilities or ["ROUTE", "STORE", "GOSSIP"],
        created_at=time.time() * 1000,
        sovereignty=PHI_INV,
    )
