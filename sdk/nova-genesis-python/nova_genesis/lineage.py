"""NOVA Genesis — Lineage Tracking"""
import time
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class LineageNode:
    entity_id: str
    name: str
    parent_id: Optional[str] = None
    children: List[str] = field(default_factory=list)
    generation: int = 0
    birth_ms: float = field(default_factory=lambda: time.time() * 1000)


class Lineage:
    """Tracks parent-child relationships between sovereign entities."""

    def __init__(self):
        self._nodes: Dict[str, LineageNode] = {}

    def add(self, entity_id: str, name: str, parent_id: Optional[str] = None) -> LineageNode:
        generation = 0
        if parent_id and parent_id in self._nodes:
            generation = self._nodes[parent_id].generation + 1
            self._nodes[parent_id].children.append(entity_id)
        node = LineageNode(entity_id=entity_id, name=name,
                          parent_id=parent_id, generation=generation)
        self._nodes[entity_id] = node
        return node

    def get_ancestors(self, entity_id: str) -> List[LineageNode]:
        ancestors = []
        current = self._nodes.get(entity_id)
        while current and current.parent_id:
            parent = self._nodes.get(current.parent_id)
            if parent:
                ancestors.append(parent)
                current = parent
            else:
                break
        return ancestors

    def get_descendants(self, entity_id: str) -> List[LineageNode]:
        descendants = []
        node = self._nodes.get(entity_id)
        if not node:
            return []
        queue = list(node.children)
        while queue:
            cid = queue.pop(0)
            child = self._nodes.get(cid)
            if child:
                descendants.append(child)
                queue.extend(child.children)
        return descendants

    @property
    def total(self) -> int:
        return len(self._nodes)

    @property
    def max_generation(self) -> int:
        if not self._nodes:
            return 0
        return max(n.generation for n in self._nodes.values())
