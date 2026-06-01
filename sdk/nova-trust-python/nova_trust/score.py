"""NOVA Trust — Trust Scoring"""
import time
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class TrustScore:
    node_id: str
    score: float = 0.5  # 0..1
    level: TrustLevel = TrustLevel.PROVISIONAL
    interactions: int = 0
    positive: int = 0
    negative: int = 0
    last_update_ms: float = 0.0


class TrustScorer:
    """φ-weighted trust scoring system."""

    def __init__(self):
        self._scores: Dict[str, TrustScore] = {}

    def get_or_create(self, node_id: str) -> TrustScore:
        if node_id not in self._scores:
            self._scores[node_id] = TrustScore(node_id=node_id)
        return self._scores[node_id]

    def record_interaction(self, node_id: str, positive: bool, weight: float = 1.0) -> TrustScore:
        ts = self.get_or_create(node_id)
        ts.interactions += 1
        if positive:
            ts.positive += 1
            ts.score = min(1.0, ts.score + weight * PHI_INV * 0.1)
        else:
            ts.negative += 1
            ts.score = max(0.0, ts.score - weight * PHI_INV * 0.15)
        ts.level = self._classify(ts.score)
        ts.last_update_ms = time.time() * 1000
        return ts

    def _classify(self, score: float) -> TrustLevel:
        if score >= 0.9:
            return TrustLevel.SOVEREIGN
        elif score >= 0.75:
            return TrustLevel.VERIFIED
        elif score >= 0.5:
            return TrustLevel.TRUSTED
        elif score >= 0.25:
            return TrustLevel.PROVISIONAL
        else:
            return TrustLevel.UNTRUSTED

    def get_score(self, node_id: str) -> Optional[TrustScore]:
        return self._scores.get(node_id)

    @property
    def total_nodes(self) -> int:
        return len(self._scores)
