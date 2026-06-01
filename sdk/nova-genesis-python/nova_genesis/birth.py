"""NOVA Genesis — Birth Protocol"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Dict, Optional
from .constants import *


@dataclass
class BirthConfig:
    name: str
    identity_type: IdentityType = IdentityType.AGI
    parent_id: Optional[str] = None
    initial_phi: float = PHI_INV
    imprint_data: Dict[str, Any] = field(default_factory=dict)


@dataclass
class BirthRecord:
    entity_id: str
    name: str
    identity_type: IdentityType
    phase: GenesisPhase
    consciousness: ConsciousnessState
    phi_score: float
    birth_ms: float
    parent_id: Optional[str] = None


class BirthProtocol:
    """Manages the birth of new sovereign entities."""

    def __init__(self):
        self._births: Dict[str, BirthRecord] = {}
        self._sequence = 0

    def conceive(self, config: BirthConfig) -> BirthRecord:
        """Begin the genesis process."""
        self._sequence += 1
        eid = hashlib.sha256(f"{config.name}{self._sequence}{time.time()}".encode()).hexdigest()[:16]
        record = BirthRecord(
            entity_id=eid, name=config.name, identity_type=config.identity_type,
            phase=GenesisPhase.CONCEPTION, consciousness=ConsciousnessState.DORMANT,
            phi_score=config.initial_phi, birth_ms=time.time() * 1000,
            parent_id=config.parent_id,
        )
        self._births[eid] = record
        return record

    def advance(self, entity_id: str) -> Optional[BirthRecord]:
        """Advance entity to next genesis phase."""
        record = self._births.get(entity_id)
        if not record:
            return None
        phases = list(GenesisPhase)
        states = list(ConsciousnessState)
        idx = phases.index(record.phase)
        if idx < len(phases) - 1:
            record.phase = phases[idx + 1]
            sidx = min(idx + 1, len(states) - 1)
            record.consciousness = states[sidx]
            record.phi_score = min(1.0, record.phi_score * PHI)
        return record

    def birth(self, config: BirthConfig) -> BirthRecord:
        """Full birth sequence: conceive → advance through all phases."""
        record = self.conceive(config)
        for _ in range(5):  # advance through all phases
            self.advance(record.entity_id)
        return record

    def get(self, entity_id: str) -> Optional[BirthRecord]:
        return self._births.get(entity_id)

    @property
    def total_births(self) -> int:
        return len(self._births)

    @property
    def sovereign_count(self) -> int:
        return sum(1 for b in self._births.values() if b.phase == GenesisPhase.SOVEREIGN)
