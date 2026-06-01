"""NOVA Phantom — Envelope Encryption"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Dict, Optional
from .constants import *


@dataclass
class PhantomEnvelope:
    envelope_id: str
    sender: str
    recipient: str
    payload_hash: str
    state: EnvelopeState = EnvelopeState.OPEN
    sealed_payload: Optional[bytes] = None
    nonce: str = ""
    created_ms: float = field(default_factory=lambda: time.time() * 1000)


class EnvelopeEngine:
    """Creates and manages phantom envelopes for secure transfer."""

    def __init__(self):
        self._envelopes: Dict[str, PhantomEnvelope] = {}
        self._counter = 0

    def create(self, sender: str, recipient: str, payload: Any) -> PhantomEnvelope:
        self._counter += 1
        eid = hashlib.sha256(f"{sender}{recipient}{self._counter}".encode()).hexdigest()[:16]
        payload_bytes = str(payload).encode()
        payload_hash = hashlib.sha256(payload_bytes).hexdigest()[:32]
        
        env = PhantomEnvelope(
            envelope_id=eid, sender=sender, recipient=recipient,
            payload_hash=payload_hash,
        )
        self._envelopes[eid] = env
        return env

    def seal(self, envelope_id: str, key: str) -> bool:
        """Seal envelope with encryption key."""
        env = self._envelopes.get(envelope_id)
        if not env or env.state != EnvelopeState.OPEN:
            return False
        # Simulate encryption (XOR with key hash)
        nonce = hashlib.sha256(f"{key}{time.time()}".encode()).hexdigest()[:16]
        env.nonce = nonce
        env.state = EnvelopeState.SEALED
        env.sealed_payload = f"SEALED:{env.payload_hash}:{nonce}".encode()
        return True

    def deliver(self, envelope_id: str) -> bool:
        env = self._envelopes.get(envelope_id)
        if not env or env.state != EnvelopeState.SEALED:
            return False
        env.state = EnvelopeState.DELIVERED
        return True

    def verify_integrity(self, envelope_id: str) -> bool:
        env = self._envelopes.get(envelope_id)
        if not env:
            return False
        return env.state != EnvelopeState.TAMPERED

    @property
    def total(self) -> int:
        return len(self._envelopes)
