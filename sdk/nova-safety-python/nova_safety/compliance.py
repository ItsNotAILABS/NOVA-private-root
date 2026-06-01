"""NOVA Safety — Compliance Engine (481 Controls)"""

import time
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Set
from .constants import *


@dataclass
class Control:
    """A single compliance control."""
    control_id: str
    category: ControlCategory
    name: str
    description: str
    enabled: bool = True
    passed: bool = False
    last_check_ms: float = 0.0


@dataclass
class ComplianceReport:
    """Compliance assessment report."""
    total_controls: int
    passed: int
    failed: int
    exempt: int
    state: ComplianceState
    score: float
    by_category: Dict[str, Dict[str, int]] = field(default_factory=dict)
    timestamp_ms: float = 0.0


class ComplianceEngine:
    """
    Manages 481 compliance controls across 10 categories.
    Tracks compliance state and generates reports.
    """

    def __init__(self):
        self._controls: Dict[str, Control] = {}
        self._generate_controls()

    def _generate_controls(self) -> None:
        """Generate all 481 controls."""
        idx = 0
        for category, count in CONTROL_CATEGORIES.items():
            for i in range(count):
                idx += 1
                cid = f"CTRL-{category.value[:3]}-{i+1:03d}"
                self._controls[cid] = Control(
                    control_id=cid,
                    category=category,
                    name=f"{category.value} Control #{i+1}",
                    description=f"Compliance control for {category.value.lower()} domain",
                )

    def check_control(self, control_id: str, passed: bool) -> bool:
        """Record a control check result."""
        if control_id not in self._controls:
            return False
        self._controls[control_id].passed = passed
        self._controls[control_id].last_check_ms = time.time() * 1000
        return True

    def check_category(self, category: ControlCategory, passed: bool) -> int:
        """Mark all controls in a category. Returns count updated."""
        count = 0
        for ctrl in self._controls.values():
            if ctrl.category == category and ctrl.enabled:
                ctrl.passed = passed
                ctrl.last_check_ms = time.time() * 1000
                count += 1
        return count

    def report(self) -> ComplianceReport:
        """Generate compliance report."""
        passed = sum(1 for c in self._controls.values() if c.passed and c.enabled)
        exempt = sum(1 for c in self._controls.values() if not c.enabled)
        active = sum(1 for c in self._controls.values() if c.enabled)
        failed = active - passed

        score = passed / max(1, active)
        if score >= PHI_INV:
            state = ComplianceState.COMPLIANT
        elif score >= AMOR:
            state = ComplianceState.PARTIAL
        else:
            state = ComplianceState.NON_COMPLIANT

        by_cat = {}
        for category in ControlCategory:
            cat_ctrls = [c for c in self._controls.values() if c.category == category]
            cat_passed = sum(1 for c in cat_ctrls if c.passed)
            by_cat[category.value] = {"total": len(cat_ctrls), "passed": cat_passed}

        return ComplianceReport(
            total_controls=TOTAL_CONTROLS,
            passed=passed, failed=failed, exempt=exempt,
            state=state, score=score,
            by_category=by_cat,
            timestamp_ms=time.time() * 1000,
        )

    @property
    def total_controls(self) -> int:
        return len(self._controls)

    def get_control(self, control_id: str) -> Optional[Control]:
        return self._controls.get(control_id)

    def controls_by_category(self, category: ControlCategory) -> List[Control]:
        return [c for c in self._controls.values() if c.category == category]
