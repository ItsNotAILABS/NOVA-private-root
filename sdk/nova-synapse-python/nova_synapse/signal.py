"""NOVA Synapse — Signal Propagation"""
import time
from dataclasses import dataclass, field
from typing import Any, Dict, List
from .constants import *
from .synapse import SynapseNetwork


@dataclass
class Signal:
    source: str
    signal_type: SignalType
    strength: float = 1.0
    payload: Any = None
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)
    hops: int = 0


class SignalPropagator:
    """Propagates signals through the synapse network."""

    def __init__(self, network: SynapseNetwork):
        self._network = network
        self._delivered: List[Dict[str, Any]] = []

    def propagate(self, signal: Signal, max_hops: int = 8) -> List[Dict[str, Any]]:
        """Propagate signal from source through network. Returns deliveries."""
        deliveries = []
        frontier = [(signal.source, signal.strength, 0)]
        visited = set()

        while frontier:
            node, strength, hops = frontier.pop(0)
            if node in visited or hops > max_hops:
                continue
            visited.add(node)

            outputs = self._network.get_outputs(node)
            for syn in outputs:
                new_strength = strength * syn.weight
                if syn.synapse_type == SynapseType.INHIBITORY:
                    new_strength = -new_strength
                if abs(new_strength) > 0.01:  # No-Drop threshold
                    delivery = {
                        "target": syn.post_node,
                        "strength": new_strength,
                        "hops": hops + 1,
                        "synapse_id": syn.synapse_id,
                    }
                    deliveries.append(delivery)
                    frontier.append((syn.post_node, abs(new_strength), hops + 1))

        self._delivered.extend(deliveries)
        return deliveries

    @property
    def total_deliveries(self) -> int:
        return len(self._delivered)
