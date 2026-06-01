"""NOVA Heartbeat — Beat-Aligned Task Scheduler"""

import time
from dataclasses import dataclass, field
from typing import Callable, Dict, List, Optional
from .constants import HEARTBEAT_MS, PHI_INV


@dataclass
class ScheduledTask:
    """A task scheduled to run on heartbeat boundaries."""
    task_id: str
    callback: Callable
    every_n_beats: int = 1
    last_run_beat: int = 0
    enabled: bool = True
    run_count: int = 0


class HeartbeatScheduler:
    """
    Schedules tasks aligned to the 873ms heartbeat rhythm.
    Tasks fire on beat boundaries, not wall-clock time.
    """

    def __init__(self):
        self._tasks: Dict[str, ScheduledTask] = {}
        self._beat_count = 0

    def register(self, task_id: str, callback: Callable, every_n_beats: int = 1) -> ScheduledTask:
        """Register a task to run every N beats."""
        task = ScheduledTask(task_id=task_id, callback=callback, every_n_beats=every_n_beats)
        self._tasks[task_id] = task
        return task

    def unregister(self, task_id: str) -> bool:
        """Remove a scheduled task."""
        return self._tasks.pop(task_id, None) is not None

    def on_beat(self, beat_sequence: int) -> List[str]:
        """Called on each heartbeat. Returns list of task_ids that ran."""
        self._beat_count = beat_sequence
        ran = []
        for task in self._tasks.values():
            if not task.enabled:
                continue
            if (beat_sequence - task.last_run_beat) >= task.every_n_beats:
                task.callback()
                task.last_run_beat = beat_sequence
                task.run_count += 1
                ran.append(task.task_id)
        return ran

    def enable(self, task_id: str) -> None:
        if task_id in self._tasks:
            self._tasks[task_id].enabled = True

    def disable(self, task_id: str) -> None:
        if task_id in self._tasks:
            self._tasks[task_id].enabled = False

    @property
    def task_count(self) -> int:
        return len(self._tasks)

    @property
    def beat_count(self) -> int:
        return self._beat_count
