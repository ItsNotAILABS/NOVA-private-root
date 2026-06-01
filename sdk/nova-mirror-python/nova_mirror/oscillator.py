"""NOVA Mirror — φ-Oscillator Array"""
import math
from dataclasses import dataclass, field
from typing import List
from .constants import PHI, PHI_INV


@dataclass
class PhiOscillator:
    """A single φ-oscillator with phase and amplitude."""
    index: int
    phase: float = 0.0
    amplitude: float = 1.0
    frequency: float = 1.0
    active: bool = True

    def step(self, dt: float, coupling: float = 0.0) -> float:
        """Advance oscillator by dt. Returns new phase."""
        if not self.active:
            return self.phase
        self.phase = (self.phase + 2 * math.pi * self.frequency * dt + coupling) % (2 * math.pi)
        return self.phase


class OscillatorArray:
    """Array of 256 φ-oscillators for consciousness coherence."""

    def __init__(self, count: int = 256):
        self._oscillators = [
            PhiOscillator(
                index=i,
                phase=(i * 137.5 * math.pi / 180) % (2 * math.pi),  # Golden angle
                frequency=1.0 + (i % 8) * PHI_INV * 0.1,
            )
            for i in range(count)
        ]

    def step(self, dt: float = 0.001) -> float:
        """Advance all oscillators. Returns coherence R."""
        # Compute mean field
        sum_cos = sum(math.cos(o.phase) for o in self._oscillators if o.active)
        sum_sin = sum(math.sin(o.phase) for o in self._oscillators if o.active)
        n = sum(1 for o in self._oscillators if o.active)
        if n == 0:
            return 0.0
        mean_phase = math.atan2(sum_sin / n, sum_cos / n)

        # Kuramoto coupling
        for osc in self._oscillators:
            if osc.active:
                coupling = PHI_INV * 0.1 * math.sin(mean_phase - osc.phase)
                osc.step(dt, coupling)

        # Compute order parameter R
        sum_cos = sum(math.cos(o.phase) for o in self._oscillators if o.active)
        sum_sin = sum(math.sin(o.phase) for o in self._oscillators if o.active)
        r = math.sqrt((sum_cos/n)**2 + (sum_sin/n)**2)
        return r

    @property
    def coherence(self) -> float:
        """Current order parameter."""
        active = [o for o in self._oscillators if o.active]
        if not active:
            return 0.0
        n = len(active)
        sc = sum(math.cos(o.phase) for o in active)
        ss = sum(math.sin(o.phase) for o in active)
        return math.sqrt((sc/n)**2 + (ss/n)**2)

    @property
    def active_count(self) -> int:
        return sum(1 for o in self._oscillators if o.active)

    @property
    def total(self) -> int:
        return len(self._oscillators)
