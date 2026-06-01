"""NOVA Vein — Vein Network"""
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class Vein:
    vein_id: str
    source: str
    target: str
    vein_type: VeinType = VeinType.ARTERY
    capacity: float = 100.0  # units/sec
    current_load: float = 0.0
    state: FlowState = FlowState.IDLE

    @property
    def utilization(self) -> float:
        return self.current_load / max(0.01, self.capacity)


class VeinNetwork:
    """Network of data flow veins."""

    def __init__(self):
        self._veins: Dict[str, Vein] = {}
        self._nodes: set = set()

    def add_vein(self, source: str, target: str, vein_type: VeinType = VeinType.ARTERY,
                 capacity: float = 100.0) -> Vein:
        vid = hashlib.sha256(f"{source}->{target}{len(self._veins)}".encode()).hexdigest()[:12]
        vein = Vein(vein_id=vid, source=source, target=target,
                   vein_type=vein_type, capacity=capacity)
        self._veins[vid] = vein
        self._nodes.add(source)
        self._nodes.add(target)
        return vein

    def get_path(self, source: str, target: str) -> List[Vein]:
        """Find veins connecting source to target (BFS)."""
        visited = set()
        queue = [(source, [])]
        while queue:
            node, path = queue.pop(0)
            if node == target:
                return path
            if node in visited:
                continue
            visited.add(node)
            for vein in self._veins.values():
                if vein.source == node and vein.state != FlowState.BLOCKED:
                    queue.append((vein.target, path + [vein]))
        return []

    @property
    def vein_count(self) -> int:
        return len(self._veins)

    @property
    def node_count(self) -> int:
        return len(self._nodes)
