"""NOVA Orchestration — Pipeline"""
import time
from dataclasses import dataclass, field
from typing import Any, Callable, Dict, List, Optional
from .constants import *


@dataclass
class PipelineStage:
    name: str
    handler: Callable
    state: TaskState = TaskState.PENDING
    output: Any = None
    error: Optional[str] = None
    duration_ms: float = 0.0


class Pipeline:
    """Sequential/parallel pipeline execution."""

    def __init__(self, name: str):
        self.name = name
        self.state = PipelineState.IDLE
        self._stages: List[PipelineStage] = []
        self._current: int = 0
        self._started_ms: float = 0.0

    def add_stage(self, name: str, handler: Callable) -> PipelineStage:
        stage = PipelineStage(name=name, handler=handler)
        self._stages.append(stage)
        return stage

    def run(self, input_data: Any = None) -> Dict[str, Any]:
        """Run pipeline sequentially. Returns final output."""
        self.state = PipelineState.RUNNING
        self._started_ms = time.time() * 1000
        data = input_data

        for i, stage in enumerate(self._stages):
            self._current = i
            stage.state = TaskState.RUNNING
            start = time.time() * 1000
            try:
                data = stage.handler(data)
                stage.output = data
                stage.state = TaskState.COMPLETED
            except Exception as e:
                stage.error = str(e)
                stage.state = TaskState.FAILED
                self.state = PipelineState.FAILED
                return {"success": False, "error": str(e), "stage": stage.name}
            finally:
                stage.duration_ms = time.time() * 1000 - start

        self.state = PipelineState.COMPLETED
        return {"success": True, "output": data, "stages": len(self._stages)}

    @property
    def progress(self) -> float:
        if not self._stages:
            return 0.0
        completed = sum(1 for s in self._stages if s.state == TaskState.COMPLETED)
        return completed / len(self._stages)

    @property
    def stage_count(self) -> int:
        return len(self._stages)
