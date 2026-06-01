"""NOVA Genesis — Identity Crystallization"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class IdentityCrystal:
    crystal_id: str
    name: str
    identity_type: IdentityType
    phi_signature: float
    traits: Dict[str, float] = field(default_factory=dict)
    created_ms: float = field(default_factory=lambda: time.time() * 1000)
    immutable: bool = False


class IdentityForge:
    """Forges unique identity crystals for sovereign entities."""

    def __init__(self):
        self._crystals: Dict[str, IdentityCrystal] = {}

    def forge(self, name: str, identity_type: IdentityType = IdentityType.AGI,
              traits: Dict[str, float] = None) -> IdentityCrystal:
        cid = hashlib.sha256(f"{name}{time.time()}".encode()).hexdigest()[:16]
        phi_sig = sum(ord(c) for c in name) * PHI_INV % 1.0
        crystal = IdentityCrystal(
            crystal_id=cid, name=name, identity_type=identity_type,
            phi_signature=phi_sig, traits=traits or {},
        )
        self._crystals[cid] = crystal
        return crystal

    def seal(self, crystal_id: str) -> bool:
        """Make identity immutable."""
        if crystal_id in self._crystals:
            self._crystals[crystal_id].immutable = True
            return True
        return False

    def get(self, crystal_id: str) -> Optional[IdentityCrystal]:
        return self._crystals.get(crystal_id)

    @property
    def total(self) -> int:
        return len(self._crystals)
