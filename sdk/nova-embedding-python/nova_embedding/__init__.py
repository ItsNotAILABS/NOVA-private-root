"""
NOVA Embedding SDK — Vector Embeddings & Similarity

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, DistanceMetric, EmbeddingType
from .vector import Vector, VectorStore
from .similarity import SimilarityEngine, SimilarityResult
from .reduction import DimensionReducer, ReducedSpace
from .index import PhiIndex, SearchResult

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "DistanceMetric", "EmbeddingType",
    "Vector", "VectorStore",
    "SimilarityEngine", "SimilarityResult",
    "DimensionReducer", "ReducedSpace",
    "PhiIndex", "SearchResult",
]
