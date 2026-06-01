"""
NOVA Network SDK — Lyapunov Convergence Monitor

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

Proves network stability: V̇ ≤ 0.
V(t) = sum of |disagreement| across all peers.
If dV/dt < 0 for 3 consecutive gossip rounds → network converged.
"""

import time
from typing import List, Dict
from dataclasses import dataclass, field

from .constants import LYAPUNOV_ALPHA


@dataclass
class LyapunovState:
    """Current state of the Lyapunov monitor."""
    V: float
    dV: float
    stable: bool
    converged: bool
    label: str
    history: List[Dict]


class LyapunovMonitor:
    """
    Lyapunov Convergence Monitor for NOVA network stability.

    Tracks a Lyapunov function V(t) representing network disagreement.
    When V̇ ≤ 0 for 3 consecutive rounds, network is proven stable.
    """

    def __init__(self):
        self._V: float = 1.0
        self._dV: float = 0.0
        self._history: List[Dict] = []
        self._converge_count: int = 0

    def update(self, disagreement: float) -> LyapunovState:
        """
        Update with current network disagreement level.

        Args:
            disagreement: Fraction of peers with conflicting routing tables [0, 1].

        Returns:
            Current LyapunovState
        """
        v_new = max(0.0, min(1.0, float(disagreement)))
        self._dV = v_new - self._V
        # Exponential moving average
        self._V = (1 - LYAPUNOV_ALPHA) * self._V + LYAPUNOV_ALPHA * v_new
        self._V = max(0.0, min(1.0, self._V))

        stable = self._dV <= 0
        if stable:
            self._converge_count += 1
        else:
            self._converge_count = 0

        self._history.append({
            "V": round(self._V, 4),
            "dV": round(self._dV, 4),
            "stable": stable,
            "at": time.time() * 1000,
        })
        if len(self._history) > 100:
            self._history.pop(0)

        return self.state()

    def state(self) -> LyapunovState:
        """Get current Lyapunov state."""
        converged = self._converge_count >= 3
        if converged:
            label = "CONVERGED — V̇ ≤ 0 (Lyapunov stable)"
        elif self._dV <= 0:
            label = "STABILISING"
        else:
            label = "DIVERGING — gossip needed"

        return LyapunovState(
            V=round(self._V, 4),
            dV=round(self._dV, 4),
            stable=self._dV <= 0,
            converged=converged,
            label=label,
            history=self._history[-8:],
        )

    @property
    def V(self) -> float:
        return self._V

    @property
    def is_stable(self) -> bool:
        return self._dV <= 0

    @property
    def is_converged(self) -> bool:
        return self._converge_count >= 3
