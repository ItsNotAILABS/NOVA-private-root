"""NOVA Solver — Constraint Solver"""
import time
from dataclasses import dataclass, field
from typing import Any, Callable, Dict, List, Optional
from .constants import *


@dataclass
class Solution:
    variables: Dict[str, Any]
    feasible: bool
    violations: List[str] = field(default_factory=list)
    objective: float = 0.0


@dataclass
class ConstraintSet:
    constraints: List[Dict[str, Any]] = field(default_factory=list)

    def add(self, name: str, check_fn: Callable) -> None:
        self.constraints.append({"name": name, "check": check_fn})

    @property
    def count(self) -> int:
        return len(self.constraints)


class ConstraintSolver:
    """Solves constraint satisfaction problems."""

    def __init__(self):
        self._state = SolverState.IDLE

    def solve(self, constraints: ConstraintSet, variables: Dict[str, Any]) -> Solution:
        """Check if variable assignment satisfies all constraints."""
        self._state = SolverState.SOLVING
        violations = []
        for c in constraints.constraints:
            try:
                if not c["check"](variables):
                    violations.append(c["name"])
            except Exception as e:
                violations.append(f"{c['name']}: {e}")

        feasible = len(violations) == 0
        self._state = SolverState.CONVERGED if feasible else SolverState.DIVERGED
        return Solution(variables=variables, feasible=feasible, violations=violations)

    @property
    def state(self) -> SolverState:
        return self._state
