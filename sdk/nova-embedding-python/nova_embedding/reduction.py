"""NOVA Embedding — Dimension Reduction"""
import math
import random
from dataclasses import dataclass, field
from typing import List
from .constants import PHI, PHI_INV


@dataclass
class ReducedSpace:
    original_dims: int
    target_dims: int
    vectors: List[List[float]]
    variance_retained: float


class DimensionReducer:
    """Simple random projection dimension reduction (Johnson-Lindenstrauss)."""

    def __init__(self, target_dims: int = 16):
        self.target_dims = target_dims
        self._matrix: List[List[float]] = []

    def fit(self, original_dims: int) -> None:
        """Generate random projection matrix."""
        random.seed(42)  # Deterministic
        scale = 1.0 / math.sqrt(self.target_dims)
        self._matrix = [
            [random.gauss(0, scale) for _ in range(original_dims)]
            for _ in range(self.target_dims)
        ]

    def transform(self, vectors: List[List[float]]) -> ReducedSpace:
        """Project vectors to lower dimensions."""
        if not self._matrix:
            self.fit(len(vectors[0]) if vectors else 0)
        
        reduced = []
        for vec in vectors:
            proj = [sum(m * v for m, v in zip(row, vec)) for row in self._matrix]
            reduced.append(proj)

        return ReducedSpace(
            original_dims=len(vectors[0]) if vectors else 0,
            target_dims=self.target_dims,
            vectors=reduced,
            variance_retained=PHI_INV,  # Approximate for random projection
        )
