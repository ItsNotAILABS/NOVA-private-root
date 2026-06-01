"""NOVA Trust — Decay Engine"""
import math
from .constants import *
from .score import TrustScorer


class DecayEngine:
    """Applies time-based trust decay."""

    def __init__(self, scorer: TrustScorer, mode: DecayMode = DecayMode.PHI_WEIGHTED):
        self._scorer = scorer
        self.mode = mode

    def apply_decay(self, elapsed_hours: float = 1.0) -> int:
        """Apply decay based on elapsed time. Returns count affected."""
        affected = 0
        for ts in self._scorer._scores.values():
            if ts.level == TrustLevel.SOVEREIGN:
                continue
            old_score = ts.score
            if self.mode == DecayMode.LINEAR:
                ts.score = max(0.0, ts.score - 0.001 * elapsed_hours)
            elif self.mode == DecayMode.EXPONENTIAL:
                ts.score *= math.exp(-0.01 * elapsed_hours)
            elif self.mode == DecayMode.PHI_WEIGHTED:
                ts.score *= (1.0 - PHI_INV * 0.005 * elapsed_hours)
            ts.score = max(0.0, ts.score)
            if ts.score != old_score:
                affected += 1
        return affected
