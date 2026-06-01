"""NOVA Embedding — Similarity Engine"""
import math
from dataclasses import dataclass
from typing import List
from .constants import *
from .vector import Vector, VectorStore


@dataclass
class SimilarityResult:
    query_id: str
    matches: List[tuple]  # (vector_id, score)
    metric: DistanceMetric


class SimilarityEngine:
    """Compute similarities between vectors."""

    def __init__(self, store: VectorStore):
        self._store = store

    def similar(self, vector_id: str, k: int = 5,
                metric: DistanceMetric = DistanceMetric.COSINE) -> SimilarityResult:
        vec = self._store.get(vector_id)
        if not vec:
            return SimilarityResult(vector_id, [], metric)
        results = self._store.search(vec.values, k + 1, metric)
        # Exclude self
        matches = [(v.vector_id, 1.0 - d) for v, d in results if v.vector_id != vector_id][:k]
        return SimilarityResult(vector_id, matches, metric)

    def batch_similarity(self, ids: List[str], k: int = 5) -> List[SimilarityResult]:
        return [self.similar(vid, k) for vid in ids]
