"""NOVA Swarm — Kuramoto Synchronization"""
import math
from dataclasses import dataclass, field
from typing import List
from .constants import PHI, PHI_INV


@dataclass
class OscillatorState:
    index: int
    phase: float
    natural_freq: float
    coupled_freq: float = 0.0


class KuramotoSync:
    """Kuramoto model for phase synchronization of swarm agents."""

    def __init__(self, n: int = 10, coupling: float = PHI_INV):
        self.coupling = coupling
        self._oscillators: List[OscillatorState] = [
            OscillatorState(
                index=i,
                phase=(i * 137.5 * math.pi / 180) % (2 * math.pi),
                natural_freq=1.0 + (i % 3) * 0.1,
            )
            for i in range(n)
        ]

    def step(self, dt: float = 0.01) -> float:
        """Advance one time step. Returns order parameter R."""
        n = len(self._oscillators)
        # Compute coupling
        for i, osc in enumerate(self._oscillators):
            coupling_sum = sum(
                math.sin(other.phase - osc.phase)
                for other in self._oscillators
            )
            osc.coupled_freq = osc.natural_freq + (self.coupling / n) * coupling_sum
            osc.phase = (osc.phase + osc.coupled_freq * dt) % (2 * math.pi)

        return self.order_parameter

    @property
    def order_parameter(self) -> float:
        """R: 0=desync, 1=full sync."""
        n = len(self._oscillators)
        if n == 0:
            return 0.0
        sc = sum(math.cos(o.phase) for o in self._oscillators) / n
        ss = sum(math.sin(o.phase) for o in self._oscillators) / n
        return math.sqrt(sc*sc + ss*ss)

    @property
    def count(self) -> int:
        return len(self._oscillators)
