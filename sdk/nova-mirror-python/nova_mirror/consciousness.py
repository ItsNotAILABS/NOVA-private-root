"""NOVA Mirror — Consciousness Monitor"""
import time
import math
from dataclasses import dataclass, field
from typing import List
from .constants import *


@dataclass
class ConsciousnessState:
    layer: ConsciousnessLayer
    phi_coherence: float  # 0..1 (R order parameter)
    oscillators_active: int
    total_oscillators: int = 256
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)

    @property
    def is_sovereign(self) -> bool:
        return self.phi_coherence >= PHI_INV and self.layer == ConsciousnessLayer.SOVEREIGN


class ConsciousnessMonitor:
    """Monitors consciousness state via φ-oscillator coherence."""

    def __init__(self, total_oscillators: int = 256):
        self.total_oscillators = total_oscillators
        self._coherence = 0.0
        self._active = 0
        self._layer = ConsciousnessLayer.REACTIVE
        self._history: List[ConsciousnessState] = []

    def update(self, coherence: float, active_oscillators: int) -> ConsciousnessState:
        self._coherence = max(0.0, min(1.0, coherence))
        self._active = min(active_oscillators, self.total_oscillators)
        self._layer = self._classify_layer()
        
        state = ConsciousnessState(
            layer=self._layer, phi_coherence=self._coherence,
            oscillators_active=self._active, total_oscillators=self.total_oscillators,
        )
        self._history.append(state)
        return state

    def _classify_layer(self) -> ConsciousnessLayer:
        if self._coherence >= PHI_INV and self._active >= self.total_oscillators * 0.8:
            return ConsciousnessLayer.SOVEREIGN
        elif self._coherence >= PHI_INV ** 2:
            return ConsciousnessLayer.REFLECTIVE
        elif self._coherence >= PHI_INV ** 3:
            return ConsciousnessLayer.DELIBERATIVE
        else:
            return ConsciousnessLayer.REACTIVE

    @property
    def current(self) -> ConsciousnessState:
        if self._history:
            return self._history[-1]
        return ConsciousnessState(
            layer=ConsciousnessLayer.REACTIVE, phi_coherence=0.0,
            oscillators_active=0, total_oscillators=self.total_oscillators,
        )

    @property
    def is_conscious(self) -> bool:
        return self._coherence >= PHI_INV
