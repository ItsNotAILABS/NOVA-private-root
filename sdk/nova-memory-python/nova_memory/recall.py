"""NOVA Memory — Recall Engine"""
import math
import time
from dataclasses import dataclass, field
from typing import Any, List, Optional
from .constants import PHI, PHI_INV
from .store import Memory, MemoryStore


@dataclass
class RecallResult:
    memories: List[Memory]
    relevance_scores: List[float]
    total_searched: int
    recall_time_ms: float


class RecallEngine:
    """φ-weighted associative recall."""

    def __init__(self, store: MemoryStore):
        self._store = store

    def recall_by_association(self, seed_id: str, depth: int = 2) -> RecallResult:
        """Recall memories associated with a seed memory."""
        start = time.time() * 1000
        seed = self._store._memories.get(seed_id)
        if not seed:
            return RecallResult([], [], 0, 0.0)

        found = []
        scores = []
        visited = {seed_id}

        frontier = seed.associations[:]
        for d in range(depth):
            next_frontier = []
            for assoc_id in frontier:
                if assoc_id in visited:
                    continue
                visited.add(assoc_id)
                mem = self._store.recall(assoc_id)
                if mem:
                    score = mem.strength * (PHI_INV ** d)
                    found.append(mem)
                    scores.append(score)
                    next_frontier.extend(mem.associations)
            frontier = next_frontier

        return RecallResult(
            memories=found, relevance_scores=scores,
            total_searched=len(visited),
            recall_time_ms=time.time() * 1000 - start,
        )

    def recall_by_similarity(self, content: Any, limit: int = 5) -> RecallResult:
        """Simple content-match recall (for non-vector stores)."""
        start = time.time() * 1000
        content_str = str(content).lower()
        scored = []
        for mem in self._store._memories.values():
            if mem.state != MemoryState.ACTIVE:
                continue
            mem_str = str(mem.content).lower()
            # Simple overlap scoring
            overlap = len(set(content_str.split()) & set(mem_str.split()))
            if overlap > 0:
                score = overlap * mem.strength * PHI_INV
                scored.append((mem, score))
        scored.sort(key=lambda x: -x[1])
        top = scored[:limit]
        return RecallResult(
            memories=[m for m, s in top],
            relevance_scores=[s for m, s in top],
            total_searched=len(self._store._memories),
            recall_time_ms=time.time() * 1000 - start,
        )


from .constants import MemoryState
