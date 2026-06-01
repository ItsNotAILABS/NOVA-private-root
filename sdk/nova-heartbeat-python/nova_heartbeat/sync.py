"""NOVA Heartbeat — Phase Synchronization"""

import math
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import PHI, PHI_INV, HEARTBEAT_MS


@dataclass
class PhaseVector:
    """Phase state of a peer."""
    node_id: str
    phase: float
    frequency: float = 1000.0 / HEARTBEAT_MS
    last_update_ms: float = 0.0
    coherence: float = 1.0


class PhaseSynchronizer:
    """
    Kuramoto-model phase synchronizer for multi-node heartbeat alignment.
    
    Each node adjusts its phase toward the mean field using φ-weighted coupling.
    """

    def __init__(self, node_id: str, coupling_strength: float = PHI_INV):
        self.node_id = node_id
        self.coupling = coupling_strength
        self._peers: Dict[str, PhaseVector] = {}
        self._own_phase = 0.0
        self._own_freq = 1000.0 / HEARTBEAT_MS

    @property
    def own_phase(self) -> float:
        return self._own_phase

    @property
    def peer_count(self) -> int:
        return len(self._peers)

    def update_peer(self, node_id: str, phase: float, timestamp_ms: float) -> None:
        """Update a peer's phase information."""
        if node_id in self._peers:
            self._peers[node_id].phase = phase
            self._peers[node_id].last_update_ms = timestamp_ms
        else:
            self._peers[node_id] = PhaseVector(
                node_id=node_id, phase=phase, last_update_ms=timestamp_ms
            )

    def compute_correction(self) -> float:
        """Compute Kuramoto phase correction toward mean field."""
        if not self._peers:
            return 0.0

        # Mean field: R*e^(iΨ) = (1/N) Σ e^(iθ_j)
        sum_cos = sum(math.cos(p.phase) for p in self._peers.values())
        sum_sin = sum(math.sin(p.phase) for p in self._peers.values())
        n = len(self._peers)
        mean_phase = math.atan2(sum_sin / n, sum_cos / n)

        # Kuramoto correction: dθ/dt = ω + (K/N) Σ sin(θ_j - θ_i)
        correction = self.coupling * math.sin(mean_phase - self._own_phase)
        return correction

    def step(self, dt_ms: float) -> float:
        """Advance synchronizer by dt milliseconds. Returns new phase."""
        correction = self.compute_correction()
        phase_advance = 2 * math.pi * self._own_freq * (dt_ms / 1000.0)
        self._own_phase = (self._own_phase + phase_advance + correction) % (2 * math.pi)
        return self._own_phase

    def coherence(self) -> float:
        """Compute order parameter R (0=desync, 1=full sync)."""
        if not self._peers:
            return 1.0
        phases = [self._own_phase] + [p.phase for p in self._peers.values()]
        n = len(phases)
        sum_cos = sum(math.cos(p) for p in phases)
        sum_sin = sum(math.sin(p) for p in phases)
        r = math.sqrt((sum_cos/n)**2 + (sum_sin/n)**2)
        return r

    def remove_peer(self, node_id: str) -> None:
        """Remove a peer."""
        self._peers.pop(node_id, None)
