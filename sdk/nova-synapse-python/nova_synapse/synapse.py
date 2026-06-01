"""NOVA Synapse — Synapse & Network"""
import hashlib
import time
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple
from .constants import *


@dataclass
class Synapse:
    synapse_id: str
    pre_node: str
    post_node: str
    weight: float = PHI_INV
    synapse_type: SynapseType = SynapseType.EXCITATORY
    delay_ms: float = 1.0
    active: bool = True
    last_fire_ms: float = 0.0


class SynapseNetwork:
    """Network of synaptic connections with φ-weighted plasticity."""

    def __init__(self):
        self._synapses: Dict[str, Synapse] = {}
        self._nodes: set = set()

    def connect(self, pre: str, post: str, weight: float = PHI_INV,
                syn_type: SynapseType = SynapseType.EXCITATORY) -> Synapse:
        sid = hashlib.sha256(f"{pre}->{post}{time.time()}".encode()).hexdigest()[:12]
        syn = Synapse(synapse_id=sid, pre_node=pre, post_node=post,
                     weight=weight, synapse_type=syn_type)
        self._synapses[sid] = syn
        self._nodes.add(pre)
        self._nodes.add(post)
        return syn

    def disconnect(self, synapse_id: str) -> bool:
        return self._synapses.pop(synapse_id, None) is not None

    def get_outputs(self, node_id: str) -> List[Synapse]:
        return [s for s in self._synapses.values() if s.pre_node == node_id and s.active]

    def get_inputs(self, node_id: str) -> List[Synapse]:
        return [s for s in self._synapses.values() if s.post_node == node_id and s.active]

    def strengthen(self, synapse_id: str, amount: float = 0.1) -> None:
        if synapse_id in self._synapses:
            s = self._synapses[synapse_id]
            s.weight = min(2.0, s.weight + amount * PHI_INV)

    def weaken(self, synapse_id: str, amount: float = 0.1) -> None:
        if synapse_id in self._synapses:
            s = self._synapses[synapse_id]
            s.weight = max(0.01, s.weight - amount * PHI_INV)

    @property
    def synapse_count(self) -> int:
        return len(self._synapses)

    @property
    def node_count(self) -> int:
        return len(self._nodes)
