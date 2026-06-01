"""NOVA Safety — Validator"""

import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional
from .constants import *


@dataclass
class ValidationResult:
    """Result of a safety validation check."""
    valid: bool
    level: SafetyLevel
    checks_passed: int
    checks_failed: int
    violations: List[str] = field(default_factory=list)
    timestamp_ms: float = 0.0
    score: float = 1.0  # 0..1 safety score

    def __post_init__(self):
        if self.timestamp_ms == 0.0:
            self.timestamp_ms = time.time() * 1000


class SafetyValidator:
    """
    Core safety validator. Enforces NOVA Alpha Safety constraints.
    Evaluates actions against 481 compliance controls.
    """

    def __init__(self, strict: bool = True):
        self.strict = strict
        self._rules: List[Dict[str, Any]] = []
        self._history: List[ValidationResult] = []

    def add_rule(self, name: str, check_fn, level: SafetyLevel = SafetyLevel.WARNING) -> None:
        """Add a safety rule."""
        self._rules.append({"name": name, "check": check_fn, "level": level})

    def validate(self, action: Dict[str, Any]) -> ValidationResult:
        """Validate an action against all safety rules."""
        passed = 0
        failed = 0
        violations = []
        worst_level = SafetyLevel.SAFE

        for rule in self._rules:
            try:
                result = rule["check"](action)
                if result:
                    passed += 1
                else:
                    failed += 1
                    violations.append(f"{rule['name']}: FAILED")
                    if self._level_severity(rule["level"]) > self._level_severity(worst_level):
                        worst_level = rule["level"]
            except Exception as e:
                failed += 1
                violations.append(f"{rule['name']}: ERROR - {str(e)}")
                worst_level = SafetyLevel.CRITICAL

        score = passed / max(1, passed + failed)
        valid = failed == 0 if self.strict else score >= PHI_INV

        result = ValidationResult(
            valid=valid, level=worst_level,
            checks_passed=passed, checks_failed=failed,
            violations=violations, score=score,
        )
        self._history.append(result)
        return result

    def _level_severity(self, level: SafetyLevel) -> int:
        return list(SafetyLevel).index(level)

    @property
    def history(self) -> List[ValidationResult]:
        return list(self._history)
