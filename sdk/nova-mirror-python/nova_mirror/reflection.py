"""NOVA Mirror — Reflection Engine"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Dict, List
from .constants import *


@dataclass
class Reflection:
    reflection_id: str
    depth: ReflectionDepth
    subject: str
    insight: str
    phi_coherence: float
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


@dataclass
class ReflectionReport:
    reflections: int
    deepest: ReflectionDepth
    avg_coherence: float
    insights: List[str]


class ReflectionEngine:
    """Self-reflection engine with recursive depth."""

    def __init__(self, entity_name: str):
        self.entity_name = entity_name
        self._reflections: List[Reflection] = []
        self._state = MirrorState.DORMANT

    def reflect(self, subject: str, depth: ReflectionDepth = ReflectionDepth.SURFACE) -> Reflection:
        self._state = MirrorState.REFLECTING
        rid = hashlib.sha256(f"{subject}{time.time()}".encode()).hexdigest()[:12]
        
        # Deeper reflections have higher coherence potential
        depth_factor = list(ReflectionDepth).index(depth) + 1
        coherence = min(1.0, PHI_INV * depth_factor * 0.5)
        
        insight = self._generate_insight(subject, depth)
        ref = Reflection(
            reflection_id=rid, depth=depth, subject=subject,
            insight=insight, phi_coherence=coherence,
        )
        self._reflections.append(ref)
        self._state = MirrorState.COMPLETE
        return ref

    def _generate_insight(self, subject: str, depth: ReflectionDepth) -> str:
        prefixes = {
            ReflectionDepth.SURFACE: "Observing",
            ReflectionDepth.PROCESS: "Analyzing process of",
            ReflectionDepth.META: "Questioning purpose of",
            ReflectionDepth.RECURSIVE: "Examining the nature of examining",
        }
        return f"{prefixes[depth]}: {subject}"

    def report(self) -> ReflectionReport:
        if not self._reflections:
            return ReflectionReport(0, ReflectionDepth.SURFACE, 0.0, [])
        depths = [list(ReflectionDepth).index(r.depth) for r in self._reflections]
        deepest = list(ReflectionDepth)[max(depths)]
        avg_coh = sum(r.phi_coherence for r in self._reflections) / len(self._reflections)
        insights = [r.insight for r in self._reflections[-5:]]
        return ReflectionReport(len(self._reflections), deepest, avg_coh, insights)

    @property
    def state(self) -> MirrorState:
        return self._state

    @property
    def reflection_count(self) -> int:
        return len(self._reflections)
