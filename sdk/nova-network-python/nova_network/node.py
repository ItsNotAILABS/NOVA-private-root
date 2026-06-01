"""
NOVA Network SDK — Sovereign Nova Node (Full Network Participant)

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

The SovereignNovaNode is the full network participant that integrates:
  - φ-DHT discovery
  - Phantom encryption
  - Store-and-forward relay
  - Lyapunov convergence monitoring
  - Fibonacci gossip
  - Message routing
"""

import time
import threading
from typing import Callable, Dict, List, Optional, Any
from dataclasses import dataclass, field

from .constants import (
    PHI, PHI_INV, AMOR, HEARTBEAT_MS, GOSSIP_SCHEDULE_MS,
    NodeType, MessageType,
)
from .identity import SovereignNodeIdentity, create_node_identity
from .messages import SovereignMessage, create_message
from .dht import PhiDHT
from .relay import RelayStore
from .lyapunov import LyapunovMonitor
from .gossip import GossipEngine
from .encryption import network_seal, network_unseal


@dataclass
class NetworkStats:
    """Network statistics for a node."""
    sent: int = 0
    received: int = 0
    relayed: int = 0
    dropped: int = 0
    gossip_rounds: int = 0


class SovereignNovaNode:
    """
    Full sovereign NOVA network participant.

    Integrates all network subsystems: DHT discovery, phantom encryption,
    store-and-forward relay, Lyapunov convergence, and Fibonacci gossip.
    """

    def __init__(
        self,
        node_type: NodeType = NodeType.SOVEREIGN,
        wallet_address: Optional[str] = None,
        region: str = "UNKNOWN",
        capabilities: Optional[List[str]] = None,
        relay_capacity: Optional[int] = None,
    ):
        """
        Args:
            node_type: Type of node
            wallet_address: Optional wallet address for identity
            region: Geographic region
            capabilities: Node capabilities
            relay_capacity: Max relay store capacity
        """
        self._identity = create_node_identity(
            node_type=node_type,
            wallet_address=wallet_address,
            region=region,
            capabilities=capabilities,
        )
        self._dht = PhiDHT(self._identity)
        self._gossip = GossipEngine(self._dht, self._identity)
        self._relay = RelayStore(relay_capacity)
        self._lyapunov = LyapunovMonitor()
        self._inbox: List[Dict] = []
        self._outbox: List[Dict] = []
        self._handlers: Dict[str, Callable] = {}
        self._sinks: List[Callable] = []
        self._beat: int = 0
        self._running: bool = False
        self._timer: Optional[threading.Timer] = None
        self._gossip_idx: int = 0
        self._stats = NetworkStats()

        # Wire gossip events
        self._gossip.add_sink(lambda event: self._publish(event["type"], event.get("payload", {})))

    @property
    def node_id(self) -> str:
        return self._identity.node_id

    @property
    def shard(self) -> int:
        return self._identity.shard

    @property
    def identity(self) -> SovereignNodeIdentity:
        return self._identity

    # ── PEER MANAGEMENT ──────────────────────────────────────────────────────

    def add_peer(self, node_data) -> "SovereignNovaNode":
        """Add a peer node to the routing table."""
        if isinstance(node_data, SovereignNodeIdentity):
            self._dht.add_node({
                "nodeId": node_data.node_id,
                "shard": node_data.shard,
                "type": node_data.node_type.value,
                "freq": node_data.freq,
                "region": node_data.region,
                "capabilities": node_data.capabilities,
            })
            nid = node_data.node_id
        else:
            self._dht.add_node(node_data)
            nid = node_data.get("nodeId", "") if isinstance(node_data, dict) else ""
        self._publish("NETWORK:PEER_ADDED", {"nodeId": nid, "shard": self.shard})
        return self

    def remove_peer(self, node_id: str) -> "SovereignNovaNode":
        """Remove a peer."""
        self._dht.remove_node(node_id)
        self._publish("NETWORK:PEER_REMOVED", {"nodeId": node_id})
        return self

    def peers(self) -> List:
        """List all known peers."""
        return self._dht.nodes()

    # ── MESSAGE ROUTING ──────────────────────────────────────────────────────

    def send(
        self,
        to: str,
        payload: Optional[Dict] = None,
        msg_type: MessageType = MessageType.DATA,
        priority: float = 0.5,
        ttl_ms: Optional[float] = None,
        recipient_public_key: Optional[str] = None,
    ) -> SovereignMessage:
        """
        Send a message into the sovereign network.

        Seals with Phantom encryption, adds to outbox, routes via φ-DHT.

        Args:
            to: Destination node ID
            payload: Message payload
            msg_type: Message type
            priority: Priority 0.0-1.0
            ttl_ms: Time-to-live in ms
            recipient_public_key: Optional encryption key

        Returns:
            The created SovereignMessage
        """
        msg = create_message(
            from_node=self.node_id,
            to_node=to,
            msg_type=msg_type,
            payload=payload or {},
            priority=priority,
            ttl_ms=ttl_ms,
        )
        envelope = network_seal(msg, recipient_public_key)
        self._outbox.append({"msg": msg, "envelope": envelope, "queuedAt": time.time() * 1000})
        self._stats.sent += 1
        self._publish("NETWORK:MESSAGE_SENT", {
            "messageId": msg.message_id, "to": msg.to_node, "type": msg.msg_type.value
        })
        return msg

    def receive(self, envelope: Dict) -> Optional[SovereignMessage]:
        """
        Receive an incoming network envelope.

        Unseals, routes onward if not the destination, or delivers to handlers.

        Args:
            envelope: Sealed network envelope

        Returns:
            The unsealed message if destined for this node, else None
        """
        msg_dict = network_unseal(envelope)
        if not msg_dict:
            self._stats.dropped += 1
            return None

        # Reconstruct message
        msg = create_message(
            from_node=msg_dict.get("from", "UNKNOWN"),
            to_node=msg_dict.get("to", "BROADCAST"),
            msg_type=MessageType(msg_dict.get("type", "DATA")),
            payload=msg_dict.get("payload", {}),
            ttl_ms=msg_dict.get("ttlMs"),
            priority=msg_dict.get("priority", 0.5),
            max_hops=msg_dict.get("maxHops"),
        )
        msg.message_id = msg_dict.get("messageId", msg.message_id)
        msg.hop_count = msg_dict.get("hopCount", 0)
        msg.created_at = msg_dict.get("createdAt", msg.created_at)
        msg.expires_at = msg_dict.get("expiresAt", msg.expires_at)

        if msg.is_expired():
            self._stats.dropped += 1
            return None

        self._stats.received += 1

        # Am I the destination?
        if msg.to_node == self.node_id or msg.to_node == "BROADCAST":
            self._inbox.append({"msg": msg, "receivedAt": time.time() * 1000})
            if len(self._inbox) > 500:
                self._inbox.pop(0)
            self._publish("NETWORK:MESSAGE_RECEIVED", {
                "messageId": msg.message_id, "from": msg.from_node, "type": msg.msg_type.value
            })
            # Dispatch to handler
            handler = self._handlers.get(msg.msg_type.value) or self._handlers.get("*")
            if handler:
                try:
                    handler(msg)
                except Exception:
                    pass
            if msg.msg_type == MessageType.GOSSIP:
                self._gossip.receive_gossip(msg)
            return msg

        # Route onward
        if not msg.hop():
            stored = self._relay.store(msg)
            if not stored:
                self._stats.dropped += 1
            else:
                self._stats.relayed += 1
            return None

        next_hop = self._dht.next_hop(msg.to_node)
        if not next_hop:
            self._relay.store(msg)
            self._stats.relayed += 1
            return None

        sealed = network_seal(msg, None)
        self._outbox.append({"msg": msg, "envelope": sealed, "nextHop": next_hop.node_id, "queuedAt": time.time() * 1000})
        self._stats.relayed += 1
        self._publish("NETWORK:MESSAGE_ROUTED", {"messageId": msg.message_id, "via": next_hop.node_id})
        return None

    def broadcast(self, payload: Dict, msg_type: MessageType = MessageType.DATA) -> SovereignMessage:
        """Broadcast to all known peers (up to 8)."""
        msg = create_message(
            from_node=self.node_id,
            to_node="BROADCAST",
            msg_type=msg_type,
            payload=payload,
            priority=AMOR,
        )
        for peer in self._dht.nodes()[:8]:
            envelope = network_seal(
                create_message(
                    from_node=self.node_id,
                    to_node=peer.node_id,
                    msg_type=msg_type,
                    payload=payload,
                    priority=AMOR,
                ),
                None,
            )
            self._outbox.append({"msg": msg, "envelope": envelope, "queuedAt": time.time() * 1000})
        self._stats.sent += min(self._dht.size, 8)
        return msg

    # ── MESSAGE HANDLERS ─────────────────────────────────────────────────────

    def on(self, msg_type: str, handler: Callable) -> "SovereignNovaNode":
        """Register a handler for a message type."""
        self._handlers[msg_type] = handler
        return self

    def inbox(self, msg_type: Optional[str] = None) -> List[SovereignMessage]:
        """Get all received messages, optionally filtered by type."""
        if msg_type:
            return [e["msg"] for e in self._inbox if e["msg"].msg_type.value == msg_type]
        return [e["msg"] for e in self._inbox]

    def flush_outbox(self) -> List[Dict]:
        """Flush the outbox (returns messages ready to transmit)."""
        out = list(self._outbox)
        self._outbox = []
        return out

    # ── RELAY & RETRY ────────────────────────────────────────────────────────

    def retry_relayed(self) -> int:
        """Retry stored messages that are due."""
        due = self._relay.due()
        for msg in due:
            next_hop = self._dht.next_hop(msg.to_node)
            if next_hop:
                envelope = network_seal(msg, None)
                self._outbox.append({"msg": msg, "envelope": envelope, "nextHop": next_hop.node_id, "queuedAt": time.time() * 1000})
                self._relay.remove(msg.message_id)
                self._stats.relayed += 1
        return len(due)

    # ── STATUS & MONITORING ──────────────────────────────────────────────────

    def network_status(self) -> Dict:
        """Get full network status."""
        lyapunov = self._lyapunov.state()
        return {
            "nodeId": self.node_id,
            "shard": self.shard,
            "type": self._identity.node_type.value,
            "peers": self._dht.size,
            "dhtShards": self._dht.snapshot(),
            "relay": {
                "stored": self._relay.size,
                "capacity": self._relay.capacity,
                "load": self._relay.load,
                "noDropOK": self._relay.no_drop_ok,
            },
            "lyapunov": {
                "V": lyapunov.V,
                "dV": lyapunov.dV,
                "stable": lyapunov.stable,
                "converged": lyapunov.converged,
                "label": lyapunov.label,
            },
            "gossip": self._gossip.stats(),
            "inbox": len(self._inbox),
            "outbox": len(self._outbox),
            "stats": {
                "sent": self._stats.sent,
                "received": self._stats.received,
                "relayed": self._stats.relayed,
                "dropped": self._stats.dropped,
                "gossipRounds": self._stats.gossip_rounds,
            },
            "beat": self._beat,
        }

    # ── LIFECYCLE ────────────────────────────────────────────────────────────

    def start(self) -> "SovereignNovaNode":
        """Start the node (heartbeat loop, gossip, relay retry)."""
        if self._running:
            return self
        self._running = True
        self._schedule_beat()
        self._publish("NETWORK:NODE_START", {"nodeId": self.node_id, "shard": self.shard})
        return self

    def stop(self) -> "SovereignNovaNode":
        """Stop the node."""
        self._running = False
        if self._timer:
            self._timer.cancel()
            self._timer = None
        self._publish("NETWORK:NODE_STOP", {"nodeId": self.node_id})
        return self

    def add_sink(self, fn: Callable) -> "SovereignNovaNode":
        """Add an event sink callback."""
        self._sinks.append(fn)
        return self

    # ── INTERNAL ─────────────────────────────────────────────────────────────

    def _schedule_beat(self):
        if not self._running:
            return
        self._timer = threading.Timer(HEARTBEAT_MS / 1000.0, self._on_beat)
        self._timer.daemon = True
        self._timer.start()

    def _on_beat(self):
        if not self._running:
            return
        self._beat += 1

        # Gossip on Fibonacci schedule
        interval = GOSSIP_SCHEDULE_MS[self._gossip_idx % len(GOSSIP_SCHEDULE_MS)]
        if (self._beat * HEARTBEAT_MS) % interval < HEARTBEAT_MS:
            msgs = self._gossip.gossip_round()
            self._stats.gossip_rounds += 1
            self._gossip_idx += 1
            for msg in msgs:
                envelope = network_seal(msg, None)
                self._outbox.append({"msg": msg, "envelope": envelope, "queuedAt": time.time() * 1000})

        # Retry relay
        self.retry_relayed()

        # Evict expired relay messages
        if self._beat % 10 == 0:
            self._relay.evict()

        # Update Lyapunov
        disagreement = self._relay.load if self._dht.size > 0 else 1.0
        self._lyapunov.update(disagreement)

        self._schedule_beat()

    def _publish(self, event_type: str, payload: Dict):
        event = {
            "type": event_type,
            "payload": payload,
            "nodeId": self.node_id,
            "beat": self._beat,
            "at": time.time() * 1000,
        }
        for fn in self._sinks:
            try:
                fn(event)
            except Exception:
                pass
