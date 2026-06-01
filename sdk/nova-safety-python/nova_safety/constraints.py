"""NOVA Safety — Constraint Engine"""

import time
from dataclasses import dataclass, field
from typing import Any, Callable, Dict, List, Optional
from .constants import PHI_INV, SafetyLevel


@dataclass
class Constraint:
    """A safety constraint."""
    name: str
    check_fn: Callable
    level: SafetyLevel = SafetyLevel.WARNING
    enabled: bool = True
    description: str = ""


@dataclass
class ConstraintViolation:
    """A constraint violation record."""
    constraint_name: str
    level: SafetyLevel
    context: Dict[str, Any] = field(default_factory=dict)
    timestamp_ms: float = 0.0
    resolved: bool = False


class ConstraintEngine:
    """
    Manages and enforces safety constraints.
    Violations are tracked and can trigger escalation.
    """

    def __init__(self):
        self._constraints: Dict[str, Constraint] = {}
        self._violations: List[ConstraintViolation] = []

    def add(self, name: str, check_fn: Callable, level: SafetyLevel = SafetyLevel.WARNING,
            description: str = "") -> Constraint:
        """Add a constraint."""
        c = Constraint(name=name, check_fn=check_fn, level=level, description=description)
        self._constraints[name] = c
        return c

    def remove(self, name: str) -> bool:
        return self._constraints.pop(name, None) is not None

    def enforce(self, context: Dict[str, Any]) -> List[ConstraintViolation]:
        """Enforce all constraints against context. Returns violations."""
        violations = []
        for c in self._constraints.values():
            if not c.enabled:
                continue
            try:
                if not c.check_fn(context):
                    v = ConstraintViolation(
                        constraint_name=c.name,
                        level=c.level,
                        context=context,
                        timestamp_ms=time.time() * 1000,
                    )
                    violations.append(v)
                    self._violations.append(v)
            except Exception:
                v = ConstraintViolation(
                    constraint_name=c.name,
                    level=SafetyLevel.CRITICAL,
                    context=context,
                    timestamp_ms=time.time() * 1000,
                )
                violations.append(v)
                self._violations.append(v)
        return violations

    def is_safe(self, context: Dict[str, Any]) -> bool:
        """Check if context passes all constraints."""
        return len(self.enforce(context)) == 0

    @property
    def violation_count(self) -> int:
        return len(self._violations)

    @property
    def active_violations(self) -> List[ConstraintViolation]:
        return [v for v in self._violations if not v.resolved]

    @property
    def constraint_count(self) -> int:
        return len(self._constraints)
