"""NOVA Health — Health Monitor"""
import time
from dataclasses import dataclass, field
from typing import Callable, Dict, List, Optional
from .constants import *


@dataclass
class HealthCheck:
    name: str
    subsystem: SubsystemType
    check_fn: Callable
    interval_ms: float = 5000.0
    last_check_ms: float = 0.0
    last_state: HealthState = HealthState.HEALTHY
    consecutive_failures: int = 0


@dataclass
class HealthReport:
    overall_state: HealthState
    subsystem_states: Dict[str, HealthState]
    checks_passed: int
    checks_failed: int
    uptime_ms: float
    phi_vitality: float  # 0..1
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class HealthMonitor:
    """System-wide health monitoring with φ-vitality scoring."""

    def __init__(self):
        self._checks: Dict[str, HealthCheck] = {}
        self._start_ms = time.time() * 1000

    def register_check(self, name: str, subsystem: SubsystemType,
                       check_fn: Callable, interval_ms: float = 5000.0) -> HealthCheck:
        hc = HealthCheck(name=name, subsystem=subsystem, check_fn=check_fn, interval_ms=interval_ms)
        self._checks[name] = hc
        return hc

    def run_checks(self) -> HealthReport:
        passed = 0
        failed = 0
        subsystem_states: Dict[str, HealthState] = {}

        for check in self._checks.values():
            try:
                result = check.check_fn()
                if result:
                    check.last_state = HealthState.HEALTHY
                    check.consecutive_failures = 0
                    passed += 1
                else:
                    check.consecutive_failures += 1
                    check.last_state = (HealthState.DEGRADED if check.consecutive_failures < 3
                                       else HealthState.UNHEALTHY)
                    failed += 1
            except Exception:
                check.consecutive_failures += 1
                check.last_state = HealthState.CRITICAL
                failed += 1
            check.last_check_ms = time.time() * 1000
            subsystem_states[check.subsystem.value] = check.last_state

        total = passed + failed
        vitality = passed / max(1, total)
        overall = self._overall_state(vitality)

        return HealthReport(
            overall_state=overall, subsystem_states=subsystem_states,
            checks_passed=passed, checks_failed=failed,
            uptime_ms=time.time() * 1000 - self._start_ms,
            phi_vitality=vitality,
        )

    def _overall_state(self, vitality: float) -> HealthState:
        if vitality >= PHI_INV:
            return HealthState.HEALTHY
        elif vitality >= PHI_INV ** 2:
            return HealthState.DEGRADED
        elif vitality > 0:
            return HealthState.UNHEALTHY
        else:
            return HealthState.CRITICAL

    @property
    def check_count(self) -> int:
        return len(self._checks)
