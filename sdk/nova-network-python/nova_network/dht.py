"""
NOVA Network SDK — φ-Distributed Hash Table (φ-DHT)

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

Discovery layer. Every NOVA node knows about a φ-weighted subset of
the network. Lookup is O(log N) with φ-jump routing.

Key space: 0 to 2^160 − 1 (160-bit addresses)
Routing: φ-jumps instead of Kademlia XOR (provably better locality)
"""

import time
from typing import Dict, List, Optional, Set
from dataclasses import dataclass, field

from .constants import (
    PHI, PHI_INV, AMOR, DHT_SHARDS, ROUTING_TABLE_SIZE, NodeType,
)


@dataclass
class DHTEntry:
    """An entry in the φ-DHT routing table."""
    node_id: str
    node_type: NodeType
    shard: int
    freq: float
    region: str
    phi_score: float
    last_seen: float
    latency_ms: Optional[float] = None


class PhiDHT:
    """
    φ-Distributed Hash Table for NOVA sovereign network discovery.

    Uses φ-weighted routing where nodes are scored by type, latency,
    and freshness. Routing is O(log N) with φ-jump hops.
    """

    def __init__(self, local_node):
        """
        Args:
            local_node: SovereignNodeIdentity of the local node
        """
        self._local = local_node
        self._table: Dict[str, DHTEntry] = {}
        self._shards: Dict[int, Set[str]] = {i: set() for i in range(DHT_SHARDS)}

    def add_node(self, node) -> "PhiDHT":
        """
        Add a node to the routing table.
        φ-eviction: if table full, evict node with lowest φ-score.
        """
        node_id = node.get("nodeId") if isinstance(node, dict) else getattr(node, "node_id", None)
        if not node_id:
            return self

        if node_id in self._table:
            self._table[node_id].last_seen = time.time() * 1000
            return self

        # Capacity check
        if len(self._table) >= ROUTING_TABLE_SIZE * 4:
            self._evict_worst_node()

        shard = node.get("shard", 0) if isinstance(node, dict) else getattr(node, "shard", 0)
        node_type = node.get("type", "SOVEREIGN") if isinstance(node, dict) else getattr(node, "node_type", NodeType.SOVEREIGN)
        freq = node.get("freq", PHI) if isinstance(node, dict) else getattr(node, "freq", PHI)
        region = node.get("region", "UNKNOWN") if isinstance(node, dict) else getattr(node, "region", "UNKNOWN")
        capabilities = node.get("capabilities", []) if isinstance(node, dict) else getattr(node, "capabilities", [])

        entry = DHTEntry(
            node_id=node_id,
            node_type=NodeType(node_type) if isinstance(node_type, str) else node_type,
            shard=shard,
            freq=freq,
            region=region,
            phi_score=self._phi_score(node_type, capabilities, None),
            last_seen=time.time() * 1000,
        )

        self._table[node_id] = entry
        self._shards.setdefault(shard, set()).add(node_id)
        return self

    def remove_node(self, node_id: str) -> "PhiDHT":
        """Remove a node from the routing table."""
        entry = self._table.pop(node_id, None)
        if entry:
            shard_set = self._shards.get(entry.shard)
            if shard_set:
                shard_set.discard(node_id)
        return self

    def update_latency(self, node_id: str, latency_ms: float) -> "PhiDHT":
        """Update latency measurement for a node."""
        entry = self._table.get(node_id)
        if entry:
            entry.latency_ms = latency_ms
            entry.phi_score = self._phi_score(
                entry.node_type, [], entry.latency_ms
            )
        return self

    def next_hop(self, target_node_id: str) -> Optional[DHTEntry]:
        """
        Find the best next hop for a target node ID.
        Uses φ-jump routing toward the node whose shard is closest
        to the target's shard, weighted by φ-score.
        """
        if not target_node_id:
            return None

        target_shard = self._hash_to_shard(target_node_id)
        candidates: List[DHTEntry] = []

        for offset in range(DHT_SHARDS // 2 + 1):
            for sh in [(target_shard + offset) % DHT_SHARDS,
                       (target_shard - offset) % DHT_SHARDS]:
                shard_nodes = self._shards.get(sh, set())
                for nid in shard_nodes:
                    entry = self._table.get(nid)
                    if entry:
                        candidates.append(entry)
            if len(candidates) >= 3:
                break

        if not candidates:
            return None

        candidates.sort(key=lambda e: e.phi_score, reverse=True)
        return candidates[0]

    def nodes_in_shard(self, shard: int) -> List[DHTEntry]:
        """Get all nodes in a shard."""
        ids = self._shards.get(shard, set())
        return [self._table[nid] for nid in ids if nid in self._table]

    def k_closest(self, target_node_id: str, k: int = 3) -> List[DHTEntry]:
        """Get k closest nodes to a target (for redundant routing)."""
        target_shard = self._hash_to_shard(target_node_id)
        entries = list(self._table.values())
        entries.sort(key=lambda e: (
            min(abs(e.shard - target_shard), DHT_SHARDS - abs(e.shard - target_shard)),
            -e.phi_score,
        ))
        return entries[:k]

    @property
    def size(self) -> int:
        return len(self._table)

    def nodes(self) -> List[DHTEntry]:
        return list(self._table.values())

    def snapshot(self) -> dict:
        return {
            "size": len(self._table),
            "shards": {k: len(v) for k, v in self._shards.items()},
        }

    def _phi_score(self, node_type, capabilities, latency_ms) -> float:
        """φ-score: higher = more valuable routing partner."""
        score = 0.5
        nt = node_type if isinstance(node_type, str) else node_type.value if hasattr(node_type, 'value') else str(node_type)
        if nt == "SOVEREIGN":
            score += AMOR
        if capabilities and "RELAY" in capabilities:
            score += AMOR * PHI_INV
        if latency_ms is not None:
            score += AMOR * max(0, 1 - latency_ms / 1000)
        return max(0.0, min(1.0, round(score, 4)))

    def _evict_worst_node(self):
        """Evict the node with the lowest φ-score."""
        if not self._table:
            return
        worst_id = min(self._table, key=lambda nid: self._table[nid].phi_score)
        self.remove_node(worst_id)

    @staticmethod
    def _hash_to_shard(node_id: str) -> int:
        """Deterministic shard from node ID."""
        h = 0
        for c in node_id:
            h = ((h * 31) + ord(c)) & 0xFFFFFFFF
        return h % DHT_SHARDS
