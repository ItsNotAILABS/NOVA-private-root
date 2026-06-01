"""NOVA Trust — Reputation Engine"""
import time
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *
from .score import TrustScorer, TrustScore


@dataclass
class PeerReputation:
    node_id: str
    trust_score: float
    attestation_count: int
    level: TrustLevel
    rank: int = 0


class ReputationEngine:
    """Global reputation ranking system."""

    def __init__(self, scorer: TrustScorer):
        self._scorer = scorer

    def rankings(self, limit: int = 10) -> List[PeerReputation]:
        scores = list(self._scorer._scores.values())
        scores.sort(key=lambda s: -s.score)
        results = []
        for i, s in enumerate(scores[:limit]):
            results.append(PeerReputation(
                node_id=s.node_id, trust_score=s.score,
                attestation_count=s.positive, level=s.level, rank=i+1,
            ))
        return results

    def percentile(self, node_id: str) -> float:
        scores = sorted(self._scorer._scores.values(), key=lambda s: s.score)
        for i, s in enumerate(scores):
            if s.node_id == node_id:
                return (i + 1) / len(scores) if scores else 0.0
        return 0.0
