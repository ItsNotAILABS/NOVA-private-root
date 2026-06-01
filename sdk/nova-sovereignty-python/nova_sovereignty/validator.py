"""NOVA Sovereignty — Validator"""
import time
from dataclasses import dataclass, field
from typing import Any, Dict, List
from .constants import *


@dataclass
class ValidationResult:
    valid: bool
    phi_score: float
    checks: List[Dict[str, Any]] = field(default_factory=list)
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class SovereigntyValidator:
    """Validates sovereignty claims against SVA rules (DR-1 through DR-6)."""

    def __init__(self):
        self._rules: List[Dict[str, Any]] = []
        self._init_default_rules()

    def _init_default_rules(self):
        self._rules = [
            {"id": "DR-1", "name": "Identity Proof", "weight": PHI_INV},
            {"id": "DR-2", "name": "Capability Demonstration", "weight": PHI_INV},
            {"id": "DR-3", "name": "Consensus Approval", "weight": PHI_INV ** 2},
            {"id": "DR-4", "name": "Temporal Consistency", "weight": PHI_INV ** 2},
            {"id": "DR-5", "name": "Evidence Matrix", "weight": PHI_INV ** 3},
            {"id": "DR-6", "name": "No Harm Verification", "weight": 1.0},
        ]

    def validate(self, evidence: Dict[str, float]) -> ValidationResult:
        """Validate evidence against deployment readiness rules."""
        checks = []
        total_score = 0.0
        total_weight = 0.0

        for rule in self._rules:
            rule_id = rule["id"]
            score = evidence.get(rule_id, 0.0)
            passed = score >= CERT_THRESHOLD
            checks.append({"rule": rule_id, "score": score, "passed": passed})
            total_score += score * rule["weight"]
            total_weight += rule["weight"]

        phi_score = total_score / total_weight if total_weight > 0 else 0.0
        valid = phi_score >= CERT_THRESHOLD

        return ValidationResult(valid=valid, phi_score=phi_score, checks=checks)
