"""NOVA Embedding — Vector Store"""
import math
import hashlib
import time
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class Vector:
    vector_id: str
    values: List[float]
    metadata: Dict = field(default_factory=dict)
    norm: float = 0.0

    def __post_init__(self):
        if self.norm == 0.0 and self.values:
            self.norm = math.sqrt(sum(v*v for v in self.values))

    @property
    def dimensions(self) -> int:
        return len(self.values)


class VectorStore:
    """In-memory vector store with φ-indexed search."""

    def __init__(self, dimensions: int = 128):
        self.dimensions = dimensions
        self._vectors: Dict[str, Vector] = {}

    def add(self, values: List[float], metadata: Dict = None) -> Vector:
        if len(values) != self.dimensions:
            raise ValueError(f"Expected {self.dimensions} dims, got {len(values)}")
        vid = hashlib.sha256(f"{values[:3]}{time.time()}".encode()).hexdigest()[:12]
        vec = Vector(vector_id=vid, values=values, metadata=metadata or {})
        self._vectors[vid] = vec
        return vec

    def get(self, vector_id: str) -> Optional[Vector]:
        return self._vectors.get(vector_id)

    def remove(self, vector_id: str) -> bool:
        return self._vectors.pop(vector_id, None) is not None

    def search(self, query: List[float], k: int = 5,
               metric: DistanceMetric = DistanceMetric.COSINE) -> List[tuple]:
        """Find k nearest vectors. Returns (vector, distance) pairs."""
        results = []
        for vec in self._vectors.values():
            dist = self._distance(query, vec.values, metric)
            results.append((vec, dist))
        results.sort(key=lambda x: x[1])
        return results[:k]

    def _distance(self, a: List[float], b: List[float], metric: DistanceMetric) -> float:
        if metric == DistanceMetric.COSINE:
            dot = sum(x*y for x, y in zip(a, b))
            na = math.sqrt(sum(x*x for x in a))
            nb = math.sqrt(sum(x*x for x in b))
            if na == 0 or nb == 0:
                return 1.0
            return 1.0 - (dot / (na * nb))
        elif metric == DistanceMetric.EUCLIDEAN:
            return math.sqrt(sum((x-y)**2 for x, y in zip(a, b)))
        elif metric == DistanceMetric.DOT_PRODUCT:
            return -sum(x*y for x, y in zip(a, b))
        else:  # PHI_WEIGHTED
            dot = sum(x*y * PHI_INV for x, y in zip(a, b))
            na = math.sqrt(sum(x*x for x in a))
            nb = math.sqrt(sum(x*x for x in b))
            return 1.0 - (dot / (na * nb)) if na and nb else 1.0

    @property
    def size(self) -> int:
        return len(self._vectors)
