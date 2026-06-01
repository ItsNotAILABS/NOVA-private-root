"""
NOVA Network SDK — Sovereign Message Format

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

Every message in the NOVA network is a SovereignMessage.
Carries: payload, routing header, Phantom seal, TTL, hop count.
Messages that can't be delivered are stored (No-Drop Law).
"""

import time
import math
from dataclasses import dataclass, field
from typing import Any, Dict, Optional

from .constants import PHI, RELAY_TTL_MS, MAX_HOPS, MessageType
from .identity import secure_id


@dataclass
class SovereignMessage:
    """A message in the NOVA sovereign network."""
    message_id: str
    from_node: str
    to_node: str
    msg_type: MessageType
    payload: Dict[str, Any]
    ttl_ms: float
    priority: float
    hop_count: int
    max_hops: int
    created_at: float
    expires_at: float
    phi_nonce: float
    sealed: bool = False

    def is_expired(self) -> bool:
        """Check if the message has expired."""
        return time.time() * 1000 > self.expires_at

    def hop(self) -> bool:
        """Add one hop. Returns False if max hops exceeded."""
        if self.hop_count >= self.max_hops:
            return False
        self.hop_count += 1
        return True

    def to_dict(self) -> dict:
        return {
            "messageId": self.message_id,
            "from": self.from_node,
            "to": self.to_node,
            "type": self.msg_type.value,
            "payload": self.payload,
            "ttlMs": self.ttl_ms,
            "priority": self.priority,
            "hopCount": self.hop_count,
            "maxHops": self.max_hops,
            "createdAt": self.created_at,
            "expiresAt": self.expires_at,
            "phiNonce": self.phi_nonce,
            "sealed": self.sealed,
        }


def create_message(
    from_node: str = "UNKNOWN",
    to_node: str = "BROADCAST",
    msg_type: MessageType = MessageType.DATA,
    payload: Optional[Dict[str, Any]] = None,
    ttl_ms: Optional[float] = None,
    priority: float = 0.5,
    max_hops: Optional[int] = None,
) -> SovereignMessage:
    """
    Create a SovereignMessage.

    Args:
        from_node: Sender node ID
        to_node: Destination node ID or 'BROADCAST'
        msg_type: Message type enum
        payload: Message payload dictionary
        ttl_ms: Time-to-live in milliseconds
        priority: Priority 0.0–1.0
        max_hops: Maximum routing hops

    Returns:
        SovereignMessage instance
    """
    now = time.time() * 1000
    ttl = ttl_ms if ttl_ms is not None else RELAY_TTL_MS
    hops = max_hops if max_hops is not None else MAX_HOPS

    return SovereignMessage(
        message_id=f"MSG-{secure_id(8).upper()[:16]}",
        from_node=from_node,
        to_node=to_node,
        msg_type=msg_type,
        payload=payload or {},
        ttl_ms=ttl,
        priority=max(0.0, min(1.0, priority)),
        hop_count=0,
        max_hops=hops,
        created_at=now,
        expires_at=now + ttl,
        phi_nonce=round(math.pow(PHI, int(now) % 100) * 1e6) / 1e6,
        sealed=False,
    )
