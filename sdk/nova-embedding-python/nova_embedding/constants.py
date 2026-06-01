"""NOVA Embedding — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482

class DistanceMetric(str, Enum):
    COSINE = "COSINE"
    EUCLIDEAN = "EUCLIDEAN"
    DOT_PRODUCT = "DOT_PRODUCT"
    PHI_WEIGHTED = "PHI_WEIGHTED"

class EmbeddingType(str, Enum):
    DENSE = "DENSE"
    SPARSE = "SPARSE"
    BINARY = "BINARY"
