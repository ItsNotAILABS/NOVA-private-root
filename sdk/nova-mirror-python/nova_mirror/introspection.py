"""NOVA Mirror — Introspection Engine"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Dict, List
from .constants import PHI, PHI_INV


@dataclass
class Insight:
    insight_id: str
    category: str
    content: str
    confidence: float
    actionable: bool = False
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class IntrospectionEngine:
    """Deep introspection — the system examining its own state."""

    def __init__(self):
        self._insights: List[Insight] = []

    def introspect(self, state: Dict[str, Any], category: str = "general") -> Insight:
        iid = hashlib.sha256(f"{category}{time.time()}".encode()).hexdigest()[:12]
        
        # Analyze state for insights
        content = self._analyze(state, category)
        confidence = min(1.0, len(state) * PHI_INV * 0.2)
        
        insight = Insight(
            insight_id=iid, category=category, content=content,
            confidence=confidence, actionable=confidence > PHI_INV,
        )
        self._insights.append(insight)
        return insight

    def _analyze(self, state: Dict[str, Any], category: str) -> str:
        metrics = len(state)
        return f"Introspection [{category}]: {metrics} state dimensions observed"

    @property
    def insight_count(self) -> int:
        return len(self._insights)

    @property
    def actionable_insights(self) -> List[Insight]:
        return [i for i in self._insights if i.actionable]
