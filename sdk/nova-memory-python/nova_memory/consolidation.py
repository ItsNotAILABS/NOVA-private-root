"""NOVA Memory — Consolidation Engine"""
import time
from dataclasses import dataclass, field
from typing import List
from .constants import *
from .store import Memory, MemoryStore


@dataclass
class ConsolidationResult:
    consolidated: int
    promoted: int
    decayed: int
    duration_ms: float


class ConsolidationEngine:
    """Consolidates working memory to long-term using φ-weighted importance."""

    def __init__(self, store: MemoryStore, mode: ConsolidationMode = ConsolidationMode.PHI_WEIGHT):
        self._store = store
        self.mode = mode
        self._threshold = PHI_INV  # minimum strength for promotion

    def consolidate(self) -> ConsolidationResult:
        start = time.time() * 1000
        consolidated = 0
        promoted = 0
        decayed = 0

        for mem in list(self._store._memories.values()):
            if mem.tier == MemoryTier.SOVEREIGN:
                continue
            if mem.tier == MemoryTier.WORKING and mem.strength >= self._threshold:
                mem.tier = MemoryTier.SHORT_TERM
                consolidated += 1
            elif mem.tier == MemoryTier.SHORT_TERM and mem.access_count >= 3:
                mem.tier = MemoryTier.LONG_TERM
                promoted += 1
            elif mem.strength < 0.01:
                mem.state = MemoryState.DECAYED
                decayed += 1

        return ConsolidationResult(
            consolidated=consolidated, promoted=promoted,
            decayed=decayed, duration_ms=time.time() * 1000 - start,
        )

    def sleep_cycle(self) -> ConsolidationResult:
        """Run a full sleep consolidation cycle (offline processing)."""
        self._store.decay(rate=0.05)
        return self.consolidate()
