"""NOVA Swarm — Formation Patterns"""
import math
from dataclasses import dataclass, field
from typing import List, Tuple
from .constants import *


@dataclass
class Formation:
    formation_type: FormationType
    positions: List[Tuple[float, float]]
    agent_count: int


class FormationEngine:
    """Generates φ-based formation patterns for swarm agents."""

    def golden_spiral(self, n: int, scale: float = 1.0) -> Formation:
        """Generate golden spiral formation."""
        positions = []
        for i in range(n):
            angle = i * GOLDEN_ANGLE * math.pi / 180
            r = scale * math.sqrt(i + 1)
            x = r * math.cos(angle)
            y = r * math.sin(angle)
            positions.append((x, y))
        return Formation(FormationType.GOLDEN_SPIRAL, positions, n)

    def fibonacci_lattice(self, n: int, radius: float = 10.0) -> Formation:
        """Generate Fibonacci lattice on a disc."""
        positions = []
        for i in range(n):
            r = radius * math.sqrt((i + 0.5) / n)
            theta = 2 * math.pi * i / PHI
            positions.append((r * math.cos(theta), r * math.sin(theta)))
        return Formation(FormationType.FIBONACCI_LATTICE, positions, n)

    def phi_cluster(self, n: int, clusters: int = 3) -> Formation:
        """Generate φ-spaced clusters."""
        positions = []
        per_cluster = n // clusters
        for c in range(clusters):
            cx = c * PHI * 5
            cy = (c % 2) * PHI * 3
            for i in range(per_cluster):
                angle = i * GOLDEN_ANGLE * math.pi / 180
                r = math.sqrt(i + 1)
                positions.append((cx + r * math.cos(angle), cy + r * math.sin(angle)))
        return Formation(FormationType.PHI_CLUSTER, positions, len(positions))
