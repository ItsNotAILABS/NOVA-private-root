"""NOVA Phantom — Stealth Addressing"""
import hashlib
import time
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import PHI_INV


@dataclass
class StealthAddress:
    address: str
    owner: str
    ephemeral: bool = True
    created_ms: float = field(default_factory=lambda: time.time() * 1000)
    uses_remaining: int = 1


class StealthGenerator:
    """Generates one-time stealth addresses for anonymous transfers."""

    def __init__(self):
        self._addresses: Dict[str, StealthAddress] = {}
        self._counter = 0

    def generate(self, owner: str, uses: int = 1) -> StealthAddress:
        self._counter += 1
        seed = f"{owner}{self._counter}{time.time()}"
        addr = "0xPHANTOM_" + hashlib.sha256(seed.encode()).hexdigest()[:32]
        stealth = StealthAddress(address=addr, owner=owner, uses_remaining=uses)
        self._addresses[addr] = stealth
        return stealth

    def consume(self, address: str) -> bool:
        """Use a stealth address (decrements remaining uses)."""
        sa = self._addresses.get(address)
        if not sa or sa.uses_remaining <= 0:
            return False
        sa.uses_remaining -= 1
        if sa.uses_remaining <= 0 and sa.ephemeral:
            del self._addresses[address]
        return True

    def resolve_owner(self, address: str) -> str:
        """Resolve the true owner of a stealth address."""
        sa = self._addresses.get(address)
        return sa.owner if sa else ""

    @property
    def active_count(self) -> int:
        return len(self._addresses)
