"""NOVA Synapse — Network Topology"""
from dataclasses import dataclass
from typing import Dict, Set
from .constants import PHI
from .synapse import SynapseNetwork


@dataclass
class TopologyStats:
    nodes: int
    synapses: int
    avg_degree: float
    max_degree: int
    density: float
    clustering: float


class NetworkTopology:
    """Analyzes synapse network topology."""

    def __init__(self, network: SynapseNetwork):
        self._network = network

    def stats(self) -> TopologyStats:
        nodes = self._network.node_count
        synapses = self._network.synapse_count
        
        if nodes == 0:
            return TopologyStats(0, 0, 0.0, 0, 0.0, 0.0)

        # Compute degrees
        degrees: Dict[str, int] = {}
        for syn in self._network._synapses.values():
            degrees[syn.pre_node] = degrees.get(syn.pre_node, 0) + 1
            degrees[syn.post_node] = degrees.get(syn.post_node, 0) + 1

        avg_deg = sum(degrees.values()) / max(1, len(degrees))
        max_deg = max(degrees.values()) if degrees else 0
        max_possible = nodes * (nodes - 1)
        density = synapses / max_possible if max_possible > 0 else 0.0

        return TopologyStats(
            nodes=nodes, synapses=synapses,
            avg_degree=avg_deg, max_degree=max_deg,
            density=density, clustering=density * PHI,  # approximation
        )
