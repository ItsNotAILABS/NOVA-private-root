"""NOVA Embedding — φ-Index"""
import math
from dataclasses import dataclass, field
from typing import Dict, List, Tuple
from .constants import PHI, PHI_INV, DistanceMetric
from .vector import Vector, VectorStore


@dataclass
class SearchResult:
    vector_id: str
    score: float
    metadata: Dict = field(default_factory=dict)


class PhiIndex:
    """φ-bucketed index for fast approximate nearest neighbor search."""

    def __init__(self, store: VectorStore, buckets: int = 16):
        self._store = store
        self._buckets: Dict[int, List[str]] = {i: [] for i in range(buckets)}
        self._bucket_count = buckets

    def build(self) -> int:
        """Build index from current store contents."""
        self._buckets = {i: [] for i in range(self._bucket_count)}
        for vid, vec in self._store._vectors.items():
            bucket = self._hash_vector(vec.values)
            self._buckets[bucket].append(vid)
        return self._store.size

    def _hash_vector(self, values: List[float]) -> int:
        """φ-based locality-sensitive hash."""
        h = sum(v * PHI_INV**(i % 8) for i, v in enumerate(values[:8]))
        return int(abs(h) * self._bucket_count) % self._bucket_count

    def search(self, query: List[float], k: int = 5) -> List[SearchResult]:
        """Fast approximate search using bucket lookup."""
        bucket = self._hash_vector(query)
        # Search primary bucket + neighbors
        candidates = list(self._buckets.get(bucket, []))
        candidates += self._buckets.get((bucket + 1) % self._bucket_count, [])
        candidates += self._buckets.get((bucket - 1) % self._bucket_count, [])

        scored = []
        for vid in set(candidates):
            vec = self._store.get(vid)
            if vec:
                # Cosine similarity
                dot = sum(a*b for a, b in zip(query, vec.values))
                nq = math.sqrt(sum(a*a for a in query))
                nv = vec.norm
                sim = dot / (nq * nv) if nq > 0 and nv > 0 else 0.0
                scored.append(SearchResult(vector_id=vid, score=sim, metadata=vec.metadata))
        
        scored.sort(key=lambda r: -r.score)
        return scored[:k]

    @property
    def indexed_count(self) -> int:
        return sum(len(b) for b in self._buckets.values())
