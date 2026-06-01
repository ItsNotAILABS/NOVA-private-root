"""
NOVA Network SDK — Store-and-Forward Relay (No-Drop Law compliant)

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

If a message can't be delivered immediately (target node offline),
it is stored and retried. Load ≤ AMOR × capacity ensures zero drop.
Fibonacci retry schedule: 1s, 2s, 3s, 5s, 8s, 13s, 21s, 34s...
"""

import time
from typing import List, Dict, Optional
from dataclasses import dataclass

from .constants import AMOR, GOSSIP_SCHEDULE_MS
from .messages import SovereignMessage


@dataclass
class RelayEntry:
    """An entry in the relay store."""
    msg: SovereignMessage
    attempts: int = 0
    next_retry: float = 0.0


class RelayStore:
    """
    Store-and-forward relay compliant with NOVA's No-Drop Law.

    Messages that cannot be delivered immediately are stored and retried
    on a Fibonacci schedule. Load is kept ≤ AMOR × capacity.
    """

    def __init__(self, capacity: Optional[int] = None):
        """
        Args:
            capacity: Max messages to store. Defaults to floor(AMOR × 1000).
        """
        self._capacity = capacity or int(1000 * AMOR)
        self._store: Dict[str, RelayEntry] = {}

    def store(self, msg: SovereignMessage) -> bool:
        """
        Store a message for later delivery.

        Returns False if at capacity (backpressure signal) or message expired.
        """
        if len(self._store) >= self._capacity:
            return False
        if msg.is_expired():
            return False
        self._store[msg.message_id] = RelayEntry(
            msg=msg,
            attempts=0,
            next_retry=time.time() * 1000 + GOSSIP_SCHEDULE_MS[0],
        )
        return True

    def due(self) -> List[SovereignMessage]:
        """Get messages ready for retry."""
        now = time.time() * 1000
        ready: List[SovereignMessage] = []
        expired_ids: List[str] = []

        for msg_id, entry in self._store.items():
            if entry.msg.is_expired():
                expired_ids.append(msg_id)
                continue
            if entry.next_retry <= now:
                entry.attempts += 1
                idx = min(entry.attempts, len(GOSSIP_SCHEDULE_MS) - 1)
                entry.next_retry = now + GOSSIP_SCHEDULE_MS[idx]
                ready.append(entry.msg)

        for msg_id in expired_ids:
            del self._store[msg_id]

        return ready

    def remove(self, message_id: str) -> "RelayStore":
        """Remove a message (successfully delivered)."""
        self._store.pop(message_id, None)
        return self

    def evict(self) -> "RelayStore":
        """Evict expired messages."""
        expired = [mid for mid, e in self._store.items() if e.msg.is_expired()]
        for mid in expired:
            del self._store[mid]
        return self

    @property
    def size(self) -> int:
        return len(self._store)

    @property
    def capacity(self) -> int:
        return self._capacity

    @property
    def load(self) -> float:
        """Current load factor."""
        if self._capacity == 0:
            return 0.0
        return round(len(self._store) / self._capacity, 4)

    @property
    def no_drop_ok(self) -> bool:
        """No-Drop Law: load ≤ AMOR × C."""
        return self.load <= AMOR
