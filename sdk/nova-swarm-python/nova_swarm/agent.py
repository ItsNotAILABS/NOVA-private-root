"""NOVA Swarm — Swarm Agents"""
import hashlib
import time
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class SwarmAgent:
    agent_id: str
    name: str
    role: SwarmRole = SwarmRole.WORKER
    position: List[float] = field(default_factory=lambda: [0.0, 0.0])
    velocity: List[float] = field(default_factory=lambda: [0.0, 0.0])
    phi_score: float = PHI_INV
    active: bool = True


class SwarmAgentPool:
    """Pool of swarm agents."""

    def __init__(self):
        self._agents: Dict[str, SwarmAgent] = {}

    def spawn(self, name: str, role: SwarmRole = SwarmRole.WORKER,
              position: List[float] = None) -> SwarmAgent:
        aid = hashlib.sha256(f"{name}{time.time()}".encode()).hexdigest()[:12]
        agent = SwarmAgent(agent_id=aid, name=name, role=role,
                          position=position or [0.0, 0.0])
        self._agents[aid] = agent
        return agent

    def remove(self, agent_id: str) -> bool:
        return self._agents.pop(agent_id, None) is not None

    def get_by_role(self, role: SwarmRole) -> List[SwarmAgent]:
        return [a for a in self._agents.values() if a.role == role and a.active]

    @property
    def count(self) -> int:
        return len(self._agents)

    @property
    def active_count(self) -> int:
        return sum(1 for a in self._agents.values() if a.active)

    @property
    def agents(self) -> List[SwarmAgent]:
        return list(self._agents.values())
