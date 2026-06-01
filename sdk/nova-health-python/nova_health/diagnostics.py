"""NOVA Health — Diagnostics"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Callable, Dict, List, Optional
from .constants import *


@dataclass
class DiagnosticResult:
    diagnostic_id: str
    name: str
    passed: bool
    details: str = ""
    severity: Severity = Severity.INFO
    duration_ms: float = 0.0


@dataclass
class Diagnostic:
    name: str
    runner: Callable
    severity: Severity = Severity.MEDIUM


class DiagnosticEngine:
    """Runs diagnostic suites for deep system analysis."""

    def __init__(self):
        self._diagnostics: List[Diagnostic] = []
        self._results: List[DiagnosticResult] = []

    def add(self, name: str, runner: Callable, severity: Severity = Severity.MEDIUM) -> None:
        self._diagnostics.append(Diagnostic(name=name, runner=runner, severity=severity))

    def run_all(self) -> List[DiagnosticResult]:
        results = []
        for diag in self._diagnostics:
            start = time.time() * 1000
            did = hashlib.sha256(f"{diag.name}{time.time()}".encode()).hexdigest()[:12]
            try:
                outcome = diag.runner()
                passed = bool(outcome)
                details = str(outcome) if outcome else "PASS"
            except Exception as e:
                passed = False
                details = f"ERROR: {e}"
            duration = time.time() * 1000 - start
            result = DiagnosticResult(
                diagnostic_id=did, name=diag.name, passed=passed,
                details=details, severity=diag.severity, duration_ms=duration,
            )
            results.append(result)
        self._results.extend(results)
        return results

    @property
    def total_diagnostics(self) -> int:
        return len(self._diagnostics)

    @property
    def last_results(self) -> List[DiagnosticResult]:
        return self._results[-len(self._diagnostics):] if self._results else []
