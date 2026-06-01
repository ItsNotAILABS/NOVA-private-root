"""NOVA Orchestration — Scheduler"""
import time
from dataclasses import dataclass, field
from typing import Callable, Dict, List
from .constants import PHI_INV


@dataclass
class Schedule:
    name: str
    interval_ms: float
    callback: Callable
    last_run_ms: float = 0.0
    run_count: int = 0
    enabled: bool = True


class Scheduler:
    """φ-interval task scheduler."""

    def __init__(self):
        self._schedules: Dict[str, Schedule] = {}

    def every(self, name: str, interval_ms: float, callback: Callable) -> Schedule:
        s = Schedule(name=name, interval_ms=interval_ms, callback=callback)
        self._schedules[name] = s
        return s

    def tick(self) -> List[str]:
        """Check and run due schedules. Returns names of executed."""
        now = time.time() * 1000
        ran = []
        for s in self._schedules.values():
            if not s.enabled:
                continue
            if now - s.last_run_ms >= s.interval_ms:
                s.callback()
                s.last_run_ms = now
                s.run_count += 1
                ran.append(s.name)
        return ran

    def cancel(self, name: str) -> bool:
        return self._schedules.pop(name, None) is not None

    @property
    def count(self) -> int:
        return len(self._schedules)
