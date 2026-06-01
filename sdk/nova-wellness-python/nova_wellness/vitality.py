"""NOVA Wellness — Vitality Monitor"""
import time
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *


@dataclass
class VitalityScore:
    overall: float  # 0..1
    vitals: Dict[str, float]
    state: WellnessState
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class VitalityMonitor:
    """Monitors organism vitality across multiple vital signs."""

    def __init__(self):
        self._vitals: Dict[str, float] = {v.value: 1.0 for v in VitalSign}
        self._history: List[VitalityScore] = []

    def update(self, vital: VitalSign, value: float) -> None:
        self._vitals[vital.value] = max(0.0, min(1.0, value))

    def score(self) -> VitalityScore:
        values = list(self._vitals.values())
        overall = sum(values) / len(values) if values else 0.0
        state = self._classify(overall)
        vs = VitalityScore(overall=overall, vitals=dict(self._vitals), state=state)
        self._history.append(vs)
        return vs

    def _classify(self, overall: float) -> WellnessState:
        if overall >= 0.9:
            return WellnessState.THRIVING
        elif overall >= PHI_INV:
            return WellnessState.HEALTHY
        elif overall >= PHI_INV ** 2:
            return WellnessState.FATIGUED
        elif overall >= PHI_INV ** 3:
            return WellnessState.STRESSED
        else:
            return WellnessState.CRITICAL

    @property
    def current_state(self) -> WellnessState:
        if self._history:
            return self._history[-1].state
        return WellnessState.HEALTHY
