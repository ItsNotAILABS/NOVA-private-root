"""NOVA Health — Self-Healing"""
import time
from dataclasses import dataclass, field
from typing import Callable, Dict, List
from .constants import *


@dataclass
class HealingAction:
    name: str
    target: SubsystemType
    action_fn: Callable
    success: bool = False
    duration_ms: float = 0.0


class SelfHealer:
    """Automated self-healing for degraded subsystems."""

    def __init__(self):
        self._actions: Dict[SubsystemType, List[HealingAction]] = {}
        self._history: List[HealingAction] = []

    def register_action(self, name: str, target: SubsystemType, action_fn: Callable) -> None:
        self._actions.setdefault(target, []).append(
            HealingAction(name=name, target=target, action_fn=action_fn)
        )

    def heal(self, target: SubsystemType) -> List[HealingAction]:
        """Attempt healing actions for a subsystem."""
        actions = self._actions.get(target, [])
        results = []
        for action in actions:
            start = time.time() * 1000
            try:
                action.action_fn()
                action.success = True
            except Exception:
                action.success = False
            action.duration_ms = time.time() * 1000 - start
            results.append(action)
            self._history.append(action)
        return results

    @property
    def heal_count(self) -> int:
        return len(self._history)

    @property
    def success_rate(self) -> float:
        if not self._history:
            return 0.0
        return sum(1 for a in self._history if a.success) / len(self._history)
