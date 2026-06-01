"""NOVA Synapse — Hebbian Learning"""
import time
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *
from .synapse import SynapseNetwork


@dataclass
class LearningEvent:
    synapse_id: str
    pre_node: str
    post_node: str
    delta_weight: float
    new_weight: float
    mode: PlasticityMode
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class HebbianLearner:
    """Hebbian learning: neurons that fire together wire together."""

    def __init__(self, network: SynapseNetwork, learning_rate: float = PHI_INV * 0.1,
                 mode: PlasticityMode = PlasticityMode.HEBBIAN):
        self._network = network
        self.learning_rate = learning_rate
        self.mode = mode
        self._events: List[LearningEvent] = []

    def learn(self, pre_node: str, post_node: str, correlation: float = 1.0) -> List[LearningEvent]:
        """Apply Hebbian learning to synapses between pre and post."""
        events = []
        for syn in self._network._synapses.values():
            if syn.pre_node == pre_node and syn.post_node == post_node:
                if self.mode == PlasticityMode.HEBBIAN:
                    delta = self.learning_rate * correlation
                elif self.mode == PlasticityMode.ANTI_HEBBIAN:
                    delta = -self.learning_rate * correlation
                else:
                    delta = self.learning_rate * correlation * PHI_INV

                old_weight = syn.weight
                syn.weight = max(0.01, min(2.0, syn.weight + delta))
                
                event = LearningEvent(
                    synapse_id=syn.synapse_id, pre_node=pre_node,
                    post_node=post_node, delta_weight=delta,
                    new_weight=syn.weight, mode=self.mode,
                )
                events.append(event)
                self._events.append(event)
        return events

    @property
    def event_count(self) -> int:
        return len(self._events)
