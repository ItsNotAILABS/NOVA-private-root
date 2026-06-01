"""NOVA Memory — Memory Store"""
import time
import hashlib
import math
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional
from .constants import *


@dataclass
class Memory:
    memory_id: str
    content: Any
    tier: MemoryTier = MemoryTier.WORKING
    state: MemoryState = MemoryState.ACTIVE
    strength: float = 1.0
    created_ms: float = field(default_factory=lambda: time.time() * 1000)
    last_access_ms: float = 0.0
    access_count: int = 0
    tags: List[str] = field(default_factory=list)
    associations: List[str] = field(default_factory=list)


@dataclass
class MemoryQuery:
    tags: List[str] = field(default_factory=list)
    tier: Optional[MemoryTier] = None
    min_strength: float = 0.0
    limit: int = 10


class MemoryStore:
    """φ-weighted sovereign memory store with decay and consolidation."""

    def __init__(self, capacity: int = 10000):
        self.capacity = capacity
        self._memories: Dict[str, Memory] = {}

    def store(self, content: Any, tier: MemoryTier = MemoryTier.WORKING,
              tags: List[str] = None, strength: float = 1.0) -> Memory:
        mid = hashlib.sha256(f"{content}{time.time()}".encode()).hexdigest()[:16]
        mem = Memory(memory_id=mid, content=content, tier=tier,
                     tags=tags or [], strength=strength)
        self._memories[mid] = mem
        self._enforce_capacity()
        return mem

    def recall(self, memory_id: str) -> Optional[Memory]:
        mem = self._memories.get(memory_id)
        if mem and mem.state == MemoryState.ACTIVE:
            mem.access_count += 1
            mem.last_access_ms = time.time() * 1000
            # Hebbian: strengthen on recall
            mem.strength = min(2.0, mem.strength * (1 + PHI_INV * 0.1))
            return mem
        return None

    def search(self, query: MemoryQuery) -> List[Memory]:
        results = []
        for mem in self._memories.values():
            if mem.state == MemoryState.DECAYED:
                continue
            if query.tier and mem.tier != query.tier:
                continue
            if mem.strength < query.min_strength:
                continue
            if query.tags and not any(t in mem.tags for t in query.tags):
                continue
            results.append(mem)
        results.sort(key=lambda m: -m.strength)
        return results[:query.limit]

    def decay(self, rate: float = 0.01) -> int:
        """Apply φ-decay to all memories. Returns count decayed."""
        decayed = 0
        for mem in self._memories.values():
            if mem.state == MemoryState.PROTECTED or mem.tier == MemoryTier.SOVEREIGN:
                continue
            mem.strength *= (1.0 - rate * PHI_INV)
            if mem.strength < 0.01:
                mem.state = MemoryState.DECAYED
                decayed += 1
        return decayed

    def promote(self, memory_id: str, target_tier: MemoryTier) -> bool:
        mem = self._memories.get(memory_id)
        if not mem:
            return False
        mem.tier = target_tier
        if target_tier == MemoryTier.SOVEREIGN:
            mem.state = MemoryState.PROTECTED
        return True

    def _enforce_capacity(self) -> None:
        if len(self._memories) > self.capacity:
            weakest = sorted(self._memories.values(), key=lambda m: m.strength)
            for mem in weakest[:len(self._memories) - self.capacity]:
                if mem.tier != MemoryTier.SOVEREIGN:
                    del self._memories[mem.memory_id]

    @property
    def size(self) -> int:
        return len(self._memories)

    @property
    def active_count(self) -> int:
        return sum(1 for m in self._memories.values() if m.state == MemoryState.ACTIVE)
