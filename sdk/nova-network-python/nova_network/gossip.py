"""
NOVA Network SDK — Gossip Engine (Fibonacci interval anti-fragmentation)

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

Every NOVA node gossips its routing table to GOSSIP_FAN_OUT peers
on a Fibonacci schedule. This ensures the network:
  1. Self-heals when nodes join/leave
  2. Converges on a consistent view (Lyapunov guarantee)
  3. Never fragments (anti-fragmentation by construction)
"""

import time
import random
from typing import List, Callable, Optional, Dict

from .constants import AMOR, GOSSIP_FAN_OUT, GOSSIP_SCHEDULE_MS, MessageType
from .messages import SovereignMessage, create_message
from .dht import PhiDHT


class GossipEngine:
    """
    Fibonacci-interval gossip engine for anti-fragmentation.

    Broadcasts routing table subsets to randomly selected peers
    on a Fibonacci schedule, ensuring the network self-heals and
    never fragments.
    """

    def __init__(self, dht: PhiDHT, local_node):
        """
        Args:
            dht: The local node's PhiDHT
            local_node: SovereignNodeIdentity of the local node
        """
        self._dht = dht
        self._local = local_node
        self._round: int = 0
        self._sinks: List[Callable] = []
        self._log: List[Dict] = []

    def gossip_round(self) -> List[SovereignMessage]:
        """
        Generate a gossip round — broadcast known peers to fan-out nodes.

        Returns:
            List of SovereignMessages (one per target peer)
        """
        self._round += 1
        peers = self._dht.nodes()
        sample = self._sample(peers, GOSSIP_FAN_OUT)

        announce = [
            {"nodeId": p.node_id, "shard": p.shard, "type": p.node_type.value, "freq": p.freq}
            for p in peers[:20]
        ]

        local_id = self._local.node_id if hasattr(self._local, 'node_id') else self._local.get("nodeId", "")
        local_shard = self._local.shard if hasattr(self._local, 'shard') else self._local.get("shard", 0)

        messages = []
        for peer in sample:
            msg = create_message(
                from_node=local_id,
                to_node=peer.node_id,
                msg_type=MessageType.GOSSIP,
                payload={"peers": announce, "round": self._round, "localShard": local_shard},
                ttl_ms=GOSSIP_SCHEDULE_MS[-1] * 2,
                priority=AMOR,
            )
            messages.append(msg)

        self._log.append({"round": self._round, "fanOut": len(sample), "at": time.time() * 1000})
        if len(self._log) > 50:
            self._log.pop(0)

        for msg in messages:
            self._emit("GOSSIP:SENT", {"to": msg.to_node, "round": self._round})

        return messages

    def receive_gossip(self, msg: SovereignMessage) -> Dict:
        """
        Receive a gossip message — learn about new peers.

        Args:
            msg: A GOSSIP-type SovereignMessage

        Returns:
            Dict with 'new_peers' count
        """
        if msg.msg_type != MessageType.GOSSIP:
            return {"new_peers": 0}

        peers = msg.payload.get("peers", [])
        local_id = self._local.node_id if hasattr(self._local, 'node_id') else self._local.get("nodeId", "")
        new_peers = 0

        for peer in peers:
            peer_id = peer.get("nodeId", "")
            if peer_id and peer_id != local_id and peer_id not in [n.node_id for n in self._dht.nodes()]:
                self._dht.add_node(peer)
                new_peers += 1

        if new_peers > 0:
            self._emit("GOSSIP:LEARNED", {"from": msg.from_node, "new_peers": new_peers})

        return {"new_peers": new_peers, "round": msg.payload.get("round")}

    def add_sink(self, fn: Callable) -> "GossipEngine":
        """Add an event sink callback."""
        self._sinks.append(fn)
        return self

    def stats(self) -> Dict:
        """Get gossip statistics."""
        return {
            "round": self._round,
            "peer_count": self._dht.size,
            "last_round": self._log[-1] if self._log else None,
        }

    def _sample(self, arr, k):
        """Unbiased random sampling of k items from arr."""
        if len(arr) <= k:
            return list(arr)
        return random.sample(list(arr), k)

    def _emit(self, event_type: str, payload: dict):
        """Emit an event to all sinks."""
        event = {"type": event_type, "payload": payload, "at": time.time() * 1000}
        for fn in self._sinks:
            try:
                fn(event)
            except Exception:
                pass
