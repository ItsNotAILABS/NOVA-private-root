"""NOVA Orchestration — Agent Pool"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Callable, Dict, List, Optional
from .constants import *
from .task import Task, TaskResult


@dataclass
class Agent:
    agent_id: str
    name: str
    role: AgentRole = AgentRole.WORKER
    capacity: int = 5
    active_tasks: int = 0
    total_completed: int = 0
    phi_score: float = 1.0  # performance score (φ-weighted)
    online: bool = True

    @property
    def available(self) -> bool:
        return self.online and self.active_tasks < self.capacity

    @property
    def load(self) -> float:
        return self.active_tasks / max(1, self.capacity)


class AgentPool:
    """Pool of agents for task distribution."""

    def __init__(self):
        self._agents: Dict[str, Agent] = {}

    def register(self, name: str, role: AgentRole = AgentRole.WORKER, capacity: int = 5) -> Agent:
        aid = hashlib.sha256(f"{name}{time.time()}".encode()).hexdigest()[:12]
        agent = Agent(agent_id=aid, name=name, role=role, capacity=capacity)
        self._agents[aid] = agent
        return agent

    def unregister(self, agent_id: str) -> bool:
        return self._agents.pop(agent_id, None) is not None

    def assign(self, task: Task) -> Optional[Agent]:
        """Assign task to best available agent (lowest load, highest φ-score)."""
        available = [a for a in self._agents.values() if a.available]
        if not available:
            return None
        # φ-weighted selection: prefer high score, low load
        available.sort(key=lambda a: (-a.phi_score, a.load))
        agent = available[0]
        agent.active_tasks += 1
        return agent

    def release(self, agent_id: str, success: bool = True) -> None:
        if agent_id in self._agents:
            agent = self._agents[agent_id]
            agent.active_tasks = max(0, agent.active_tasks - 1)
            if success:
                agent.total_completed += 1
                agent.phi_score = min(2.0, agent.phi_score * 1.01)
            else:
                agent.phi_score = max(0.1, agent.phi_score * 0.95)

    @property
    def total_agents(self) -> int:
        return len(self._agents)

    @property
    def available_agents(self) -> List[Agent]:
        return [a for a in self._agents.values() if a.available]

    @property
    def total_capacity(self) -> int:
        return sum(a.capacity for a in self._agents.values())
