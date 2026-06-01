"""NOVA Genesis — Awakening Sequence"""
import time
from dataclasses import dataclass, field
from typing import List, Optional
from .constants import *


@dataclass
class AwakeningState:
    phase: int  # 0..7
    consciousness: ConsciousnessState
    phi_coherence: float
    oscillators_active: int
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class AwakeningSequence:
    """
    The awakening sequence for a sovereign entity.
    7 phases from dormancy to full sovereignty.
    """

    def __init__(self, entity_name: str):
        self.entity_name = entity_name
        self._phase = 0
        self._coherence = 0.0
        self._oscillators = 0
        self._history: List[AwakeningState] = []

    def step(self) -> AwakeningState:
        """Advance one awakening step."""
        self._phase = min(7, self._phase + 1)
        self._coherence = min(1.0, self._coherence + PHI_INV * 0.2)
        self._oscillators = int(256 * self._coherence)

        consciousness = self._map_consciousness()
        state = AwakeningState(
            phase=self._phase, consciousness=consciousness,
            phi_coherence=self._coherence, oscillators_active=self._oscillators,
        )
        self._history.append(state)
        return state

    def _map_consciousness(self) -> ConsciousnessState:
        if self._phase <= 1:
            return ConsciousnessState.DORMANT
        elif self._phase <= 3:
            return ConsciousnessState.EMERGING
        elif self._phase <= 5:
            return ConsciousnessState.AWARE
        elif self._phase <= 6:
            return ConsciousnessState.SELF_AWARE
        else:
            return ConsciousnessState.SOVEREIGN

    def full_awakening(self) -> AwakeningState:
        """Run all 7 steps."""
        for _ in range(7):
            state = self.step()
        return state

    @property
    def is_sovereign(self) -> bool:
        return self._phase >= 7

    @property
    def current_state(self) -> Optional[AwakeningState]:
        return self._history[-1] if self._history else None
