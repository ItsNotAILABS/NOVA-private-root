"""NOVA Orchestration — Task Management"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Callable, Dict, List, Optional
from .constants import *


@dataclass
class TaskResult:
    task_id: str
    success: bool
    output: Any = None
    error: Optional[str] = None
    duration_ms: float = 0.0


@dataclass
class Task:
    task_id: str
    name: str
    payload: Dict[str, Any] = field(default_factory=dict)
    state: TaskState = TaskState.PENDING
    priority: Priority = Priority.NORMAL
    created_ms: float = field(default_factory=lambda: time.time() * 1000)
    started_ms: float = 0.0
    completed_ms: float = 0.0
    retries: int = 0
    max_retries: int = 3
    result: Optional[TaskResult] = None
    depends_on: List[str] = field(default_factory=list)


class TaskQueue:
    """Priority task queue with φ-weighted scheduling."""

    def __init__(self, max_size: int = 1000):
        self.max_size = max_size
        self._tasks: Dict[str, Task] = {}
        self._completed: List[Task] = []

    def enqueue(self, name: str, payload: Dict[str, Any] = None,
                priority: Priority = Priority.NORMAL, depends_on: List[str] = None) -> Task:
        tid = hashlib.sha256(f"{name}{time.time()}".encode()).hexdigest()[:16]
        task = Task(task_id=tid, name=name, payload=payload or {},
                    priority=priority, depends_on=depends_on or [])
        self._tasks[tid] = task
        return task

    def dequeue(self) -> Optional[Task]:
        """Get highest-priority ready task."""
        ready = [t for t in self._tasks.values()
                 if t.state == TaskState.PENDING and self._deps_met(t)]
        if not ready:
            return None
        ready.sort(key=lambda t: (-t.priority.value, t.created_ms))
        task = ready[0]
        task.state = TaskState.RUNNING
        task.started_ms = time.time() * 1000
        return task

    def complete(self, task_id: str, success: bool, output: Any = None, error: str = None) -> Optional[TaskResult]:
        if task_id not in self._tasks:
            return None
        task = self._tasks[task_id]
        task.completed_ms = time.time() * 1000
        task.state = TaskState.COMPLETED if success else TaskState.FAILED
        result = TaskResult(task_id=task_id, success=success, output=output, error=error,
                           duration_ms=task.completed_ms - task.started_ms)
        task.result = result
        self._completed.append(task)
        del self._tasks[task_id]
        return result

    def retry(self, task_id: str) -> bool:
        if task_id not in self._tasks:
            return False
        task = self._tasks[task_id]
        if task.retries >= task.max_retries:
            return False
        task.retries += 1
        task.state = TaskState.PENDING
        return True

    def _deps_met(self, task: Task) -> bool:
        for dep_id in task.depends_on:
            if dep_id in self._tasks:
                return False
        return True

    @property
    def pending_count(self) -> int:
        return sum(1 for t in self._tasks.values() if t.state == TaskState.PENDING)

    @property
    def running_count(self) -> int:
        return sum(1 for t in self._tasks.values() if t.state == TaskState.RUNNING)

    @property
    def size(self) -> int:
        return len(self._tasks)
