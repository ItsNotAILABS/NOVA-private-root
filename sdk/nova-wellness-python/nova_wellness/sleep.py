"""NOVA Wellness — Sleep Cycle Engine"""
import time
from dataclasses import dataclass, field
from typing import List
from .constants import *


@dataclass
class SleepCycle:
    cycle_number: int
    phase: SleepPhase
    duration_ms: float
    consolidation_score: float  # how much memory was consolidated
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class SleepCycleEngine:
    """Manages organism sleep cycles (offline consolidation)."""

    def __init__(self, cycle_duration_ms: float = 90000):  # 90 second cycles (scaled)
        self.cycle_duration_ms = cycle_duration_ms
        self._current_phase = SleepPhase.AWAKE
        self._cycle_count = 0
        self._cycles: List[SleepCycle] = []

    def enter_sleep(self) -> SleepCycle:
        """Begin sleep (light phase)."""
        self._current_phase = SleepPhase.LIGHT
        self._cycle_count += 1
        cycle = SleepCycle(
            cycle_number=self._cycle_count,
            phase=SleepPhase.LIGHT,
            duration_ms=self.cycle_duration_ms * PHI_INV,
            consolidation_score=0.3,
        )
        self._cycles.append(cycle)
        return cycle

    def deep_sleep(self) -> SleepCycle:
        """Enter deep sleep (maximum consolidation)."""
        self._current_phase = SleepPhase.DEEP
        cycle = SleepCycle(
            cycle_number=self._cycle_count,
            phase=SleepPhase.DEEP,
            duration_ms=self.cycle_duration_ms * PHI_INV ** 2,
            consolidation_score=0.8,
        )
        self._cycles.append(cycle)
        return cycle

    def rem_phase(self) -> SleepCycle:
        """REM phase (integration)."""
        self._current_phase = SleepPhase.REM
        cycle = SleepCycle(
            cycle_number=self._cycle_count,
            phase=SleepPhase.REM,
            duration_ms=self.cycle_duration_ms * PHI_INV,
            consolidation_score=0.6,
        )
        self._cycles.append(cycle)
        return cycle

    def wake(self) -> SleepCycle:
        """Wake up."""
        self._current_phase = SleepPhase.AWAKE
        cycle = SleepCycle(
            cycle_number=self._cycle_count,
            phase=SleepPhase.WAKING,
            duration_ms=0,
            consolidation_score=0.0,
        )
        self._cycles.append(cycle)
        return cycle

    def full_cycle(self) -> List[SleepCycle]:
        """Run a complete sleep cycle: light → deep → REM → wake."""
        return [self.enter_sleep(), self.deep_sleep(), self.rem_phase(), self.wake()]

    @property
    def phase(self) -> SleepPhase:
        return self._current_phase

    @property
    def total_cycles(self) -> int:
        return self._cycle_count
