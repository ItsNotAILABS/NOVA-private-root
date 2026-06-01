"""NOVA Phantom — Transfer Engine"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional
from .constants import *


@dataclass
class PhantomTransfer:
    transfer_id: str
    sender: str
    recipient: str
    amount: float
    state: TransferState = TransferState.PENDING
    envelope_id: Optional[str] = None
    created_ms: float = field(default_factory=lambda: time.time() * 1000)


class TransferEngine:
    """Manages phantom (private) transfers."""

    def __init__(self):
        self._transfers: Dict[str, PhantomTransfer] = {}
        self._counter = 0

    def initiate(self, sender: str, recipient: str, amount: float) -> PhantomTransfer:
        self._counter += 1
        tid = hashlib.sha256(f"{sender}{recipient}{self._counter}".encode()).hexdigest()[:16]
        transfer = PhantomTransfer(
            transfer_id=tid, sender=sender, recipient=recipient, amount=amount,
        )
        self._transfers[tid] = transfer
        return transfer

    def execute(self, transfer_id: str) -> bool:
        t = self._transfers.get(transfer_id)
        if not t or t.state != TransferState.PENDING:
            return False
        t.state = TransferState.IN_TRANSIT
        t.state = TransferState.DELIVERED
        return True

    def cancel(self, transfer_id: str) -> bool:
        t = self._transfers.get(transfer_id)
        if not t or t.state == TransferState.DELIVERED:
            return False
        t.state = TransferState.CANCELLED
        return True

    @property
    def pending_count(self) -> int:
        return sum(1 for t in self._transfers.values() if t.state == TransferState.PENDING)

    @property
    def total_transferred(self) -> float:
        return sum(t.amount for t in self._transfers.values() if t.state == TransferState.DELIVERED)
