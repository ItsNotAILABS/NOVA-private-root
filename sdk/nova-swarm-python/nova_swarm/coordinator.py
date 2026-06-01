"""NOVA Swarm — Coordination"""
import time
import math
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *
from .agent import SwarmAgent, SwarmAgentPool


@dataclass
class CoordinationResult:
    agents_coordinated: int
    avg_coherence: float
    state: SwarmState
    iterations: int
    duration_ms: float


class SwarmCoordinator:
    """Coordinates swarm agents using φ-weighted rules."""

    def __init__(self, pool: SwarmAgentPool):
        self._pool = pool
        self._state = SwarmState.FORMING
        self._iteration = 0

    def coordinate(self, iterations: int = 10) -> CoordinationResult:
        """Run coordination (Boids-like with φ-weights)."""
        start = time.time() * 1000
        agents = self._pool.agents

        for _ in range(iterations):
            self._iteration += 1
            for agent in agents:
                if not agent.active:
                    continue
                # Cohesion: move toward center of mass
                center = self._center_of_mass(agents, agent)
                # Separation: avoid crowding
                sep = self._separation(agents, agent)
                # Alignment: match velocity of neighbors
                align = self._alignment(agents, agent)

                # φ-weighted update
                for d in range(2):
                    agent.velocity[d] += (
                        center[d] * PHI_INV * 0.01 +
                        sep[d] * PHI_INV * 0.05 +
                        align[d] * PHI_INV * 0.01
                    )
                    agent.position[d] += agent.velocity[d]

        self._state = SwarmState.ACTIVE
        coherence = self._compute_coherence(agents)

        return CoordinationResult(
            agents_coordinated=len(agents),
            avg_coherence=coherence,
            state=self._state,
            iterations=iterations,
            duration_ms=time.time() * 1000 - start,
        )

    def _center_of_mass(self, agents: List[SwarmAgent], exclude: SwarmAgent) -> List[float]:
        others = [a for a in agents if a.agent_id != exclude.agent_id and a.active]
        if not others:
            return [0.0, 0.0]
        cx = sum(a.position[0] for a in others) / len(others)
        cy = sum(a.position[1] for a in others) / len(others)
        return [cx - exclude.position[0], cy - exclude.position[1]]

    def _separation(self, agents: List[SwarmAgent], agent: SwarmAgent) -> List[float]:
        sx, sy = 0.0, 0.0
        for other in agents:
            if other.agent_id == agent.agent_id:
                continue
            dx = agent.position[0] - other.position[0]
            dy = agent.position[1] - other.position[1]
            dist = math.sqrt(dx*dx + dy*dy) + 0.001
            if dist < 2.0:
                sx += dx / dist
                sy += dy / dist
        return [sx, sy]

    def _alignment(self, agents: List[SwarmAgent], agent: SwarmAgent) -> List[float]:
        others = [a for a in agents if a.agent_id != agent.agent_id and a.active]
        if not others:
            return [0.0, 0.0]
        vx = sum(a.velocity[0] for a in others) / len(others)
        vy = sum(a.velocity[1] for a in others) / len(others)
        return [vx - agent.velocity[0], vy - agent.velocity[1]]

    def _compute_coherence(self, agents: List[SwarmAgent]) -> float:
        if len(agents) < 2:
            return 1.0
        cx = sum(a.position[0] for a in agents) / len(agents)
        cy = sum(a.position[1] for a in agents) / len(agents)
        avg_dist = sum(math.sqrt((a.position[0]-cx)**2 + (a.position[1]-cy)**2) for a in agents) / len(agents)
        return 1.0 / (1.0 + avg_dist)

    @property
    def state(self) -> SwarmState:
        return self._state
